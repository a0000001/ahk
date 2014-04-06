; Constants.
global SELECTOR_TITLE_CHAR := 1
global SELECTOR_HISTORY_CHAR := 2
global SELECTOR_ARBITRARY_CHAR := 3
global SELECTOR_HIDDEN_CHAR := 4
global SELECTOR_LABEL_CHAR := 5
global SELECTOR_START_MODEL_ROW_CHAR := 6
global SELECTOR_START_ACTION_DEF_ROW_CHAR := 7

; Default characters.
global SELECTOR_DEFAULT_TITLE_CHAR := "="
global SELECTOR_DEFAULT_HISTORY_CHAR := "+"
global SELECTOR_DEFAULT_ARBITRARY_CHAR := "."
global SELECTOR_DEFAULT_HIDDEN_CHAR := "*"
global SELECTOR_DEFAULT_LABEL_CHAR := "#"
global SELECTOR_DEFAULT_START_MODEL_ROW_CHAR := "("
; global SELECTOR_DEFAULT_START_ACTION_DEF_ROW_CHAR := "{"


; GUI subroutines.
GuiEscape:
GuiClose:
	if(Selector.loaded) {
		Gui, Cancel
		Gui, Destroy
		return
	}

ButtonSubmitSelectorChoice:
	if(Selector.loaded) {
		Gui, Submit
		Gui, Destroy
		return
	}

; The above subroutines aren't run until this flag is set.
Selector.loaded := true

; Selector class which reads in and stores data from a file, and given an index, abbreviation or action, does that action.
class Selector {
	static debugNoRecurse := true
	
	; Constants and such.
	static nameIndex := 1
	static abbrevIndex := 2
	static actionIndex := 3
	static dataIndices := []
	
	static nameConstant := "NAME"
	static abbrevConstant := "ABBREV"
	static actionConstant := "ACTION"
	static dataConstant := "DATA"
	static userInputConstant := "USERIN"
	
	static editStrings := ["e", "edit"]
	static debugStrings := ["d", "debug"]
	
	static actionRowDef := ""
	
	
	
	; Constructor: take any characters they want to change and keep track of them, and read in the various files.
	__New(filePath, chars = "") {
		this.init(filePath, chars)
	}
	
	init(fPath, pfix, psfix, chars) {
		; Various choice data objects.
		this.choices := Object() ; Visible choices the user can pick from.
		this.hiddenChoices := Object() ; Invisible choices the user can pick from.
		this.nonChoices := Object() ; Lines that will be displayed as titles, extra newlines, etc, but have no other significance.
		this.historyChoices := Object() ; Lines read in from the history file.
		
		; Character defaults vs what they gave us.
		this.titleChar := chars[SELECTOR_TITLE_CHAR] ? chars[SELECTOR_TITLE_CHAR] : SELECTOR_DEFAULT_TITLE_CHAR
		this.historyChar := chars[SELECTOR_HISTORY_CHAR] ? chars[SELECTOR_HISTORY_CHAR] : SELECTOR_DEFAULT_HISTORY_CHAR
		this.arbitChar := chars[SELECTOR_ARBITRARY_CHAR] ? chars[SELECTOR_ARBITRARY_CHAR] : SELECTOR_DEFAULT_ARBITRARY_CHAR
		this.hiddenChar := chars[SELECTOR_HIDDEN_CHAR] ? chars[SELECTOR_HIDDEN_CHAR] : SELECTOR_DEFAULT_HIDDEN_CHAR
		this.labelChar := chars[SELECTOR_LABEL_CHAR] ? chars[SELECTOR_LABEL_CHAR] : SELECTOR_DEFAULT_LABEL_CHAR
		this.startModelRowChar := chars[SELECTOR_START_MODEL_ROW_CHAR] ? chars[SELECTOR_START_MODEL_ROW_CHAR] : SELECTOR_DEFAULT_START_MODEL_ROW_CHAR
		; this.startActionDefRowChar := chars[SELECTOR_START_ACTION_DEF_ROW_CHAR] ? chars[SELECTOR_START_ACTION_DEF_ROW_CHAR] : SELECTOR_DEFAULT_START_ACTION_DEF_ROW_CHAR
		
		; Other init values.
		; this.startHeight := 105 ; Starting height. Includes prompt, plus extra newline above and below choice list.
		this.title := "Please make a choice by either number or abbreviation:"
		this.filePath := fPath
		this.fileName := ""
		this.prefix := pfix
		this.postfix := psfix
		
		; Read in the choices file.
		if(fPath != "" && FileExist(fPath)) {
			this.loadChoicesFromFile(fPath)
		} else {
			MsgBox, File doesn't exist!
			return ""
		}
		
		; Get paths for the history and icon files, and read them in.
		this.fileName := SubStr(fPath, 1, -4)
		iconFilePath := this.fileName ".ico"
		if(FileExist(this.fileName "History.ini"))
			this.historyChoices := fileLinesToArray(this.fileName "History.ini")
		if(FileExist(iconFilePath))
			Menu, Tray, Icon, %iconFilePath%
	}
	
	; Main function. Sets up and displays the selector gui, processes the choice, etc.
	select(filePath, actionType = "", silentChoice = "", prefix = "", postfix = "", chars = "") {
		; DEBUG.popup(filePath, "Filepath", actionType, "Action Type", silentChoice, "Silent Choice", prefix, "Prefix", postfix, "Postfix")
		
		; Set up our various information, read-ins, etc.
		this.init(filePath, prefix, postfix, chars)
		; DEBUG.popup(this, "")
		
		; Loop until we get good input.
		while(rowToDo = "") {
			; Get the choice.
			if(silentChoice != "") { ; If they've given us a silent choice, run silently.
				userIn := silentChoice
				silentChoice := ""
			} else { ; Otherwise, popup time.
				userIn := this.launchSelectorPopup()
			}
			
			; Blank input, we bail.
			if(!userIn)
				return ""
			
			; userInOrig := userIn
			
			; Parse input to meaningful command.
			rowToDo := this.parseChoice(userIn, actionType)
			; DEBUG.popup(userInOrig, "User Input Original", userIn, "User Input", rowToDo, "Row Parse Result")
		}
		
		if(!rowToDo) {
			return
		}
		
		; Store what we're about to do in the history file.
		; Don't save hidden entries or the previous entry (input of this.historyChar).
		firstChar := SubStr(rowToDo.name, 1, 1)
		if(firstChar != this.hiddenChar && firstChar != this.historyChar) {
			historyFilePath := this.fileName "History.ini"
			
			; If the histoy file already has 10 entries, trim off the oldest one.
			if(this.historyChoices.MaxIndex() = 10) {
				FileDelete, %historyFilePath%
				Loop, 9 {
					; DEBUG.popup(this.historyChoices[A_Index + 1], "Adding back in history choice")
					FileAppend, % this.historyChoices[A_Index + 1] "`n", %historyFilePath%
				}
			}
			
			; Add our latest command to the end.
			tempUserIn := rowToDo.abbrev
			FileAppend, %tempUserIn%`n, %historyFilePath%
		}
		
		; So now we have something valid - do it and die.
		; return this.doAction(action, actionType)
		return this.doAction(rowToDo, actionType)
	}
	
	; Load the choices and other such things from a specially formatted file.
	loadChoicesFromFile(filePath) {
		; Parse those lines into a N x N array, where the meaningful lines have become a size 3 array (Name, Abbrev, Action) each.
		list := TableList.parseFile(filePath)
		; DEBUG.popup(list, "Parsed List")
		
		For i,currItem in list {
			; Parse this size-n array into a new SelectorRow object.
			currRow := new SelectorRow()
			currRow.parseArray(currItem)
			
			firstChar := SubStr(currRow.get(1), 1, 1)
			
			; Popup title.
			if(i = 1 && firstChar = this.titleChar) {
				; DEBUG.popup(this.titleChar, "Title char", firstChar, "First char", currRow, "Row")
				this.title := SubStr(currRow.name, 2)
			
			; Special: add a title and/or blank row in the list display.
			} else if(firstChar = this.labelChar) {
				; DEBUG.popup(this.labelChar, "Label char", firstChar, "First char", currRow, "Row")
				
				; If blank, extra newline.
				if(StrLen(currRow.name) < 3) {
					this.nonChoices.Insert(" ")
				
				; If title, #{Space}Title.
				} else {
					idx := 0
					if(this.choices.MaxIndex()) {
						idx := this.choices.MaxIndex()
					}
					
					this.nonChoices.Insert(idx + 1, SubStr(currRow.name, 3))
					; DEBUG.popup(this.nonChoices[this.nonChoices.MaxIndex()], "Just added nonchoice:", idx + 1, "At index")
				}
				
			; Invisible, but viable, choice.
			} else if(firstChar = this.hiddenChar) {
				; DEBUG.popup(this.hiddenChar, "Hidden char", firstChar, "First char", currRow, "Row")
				this.hiddenChoices.Insert(currRow)
			
			; Special model row that tells us how a file with more than 3 columns should be laid out.
			} else if(firstChar = this.startModelRowChar) {
				; DEBUG.popup(this.startModelRowChar, "Start model row char", firstChar, "First char", currRow, "Row")
				this.parseModelRow(currRow)
			
			; Otherwise, it's a visible, viable choice!
			} else {
				; Allow piped-together entries, but only show the first one.
				if(inStr(currRow.abbrev, "|")) {
					; DEBUG.popup(currRow.abbrev, "Piped")
					
					splitAbbrev := specialSplit(currRow.abbrev, "|")
					For i,a in splitAbbrev {
						tempRow := currRow.clone()
						tempRow.setAbbrev(splitAbbrev[i])
						
						if(A_Index = 1) {
							this.choices.Insert(tempRow)
						} else {
							this.hiddenChoices.Insert(tempRow)
						}
					}
				} else {
					; DEBUG.popup(currRow, "Choice added")
					this.choices.Insert(currRow)
				}
			}
		}
	}
	
	; Function to deal with special model rows.
	parseModelRow(row) {
		; Wipe the default indices.
		this.nameIndex := ""
		this.abbrevIndex := ""
		this.actionIndex := ""
		this.userInputIndex := ""
		
		; Strip off the paren from the first element.
		row.rowArr[1] := SubStr(row.rowArr[1], 2)
		
		finalIndex := 0
		For i,r in row.rowArr {
			if(r = this.nameConstant)
				this.nameIndex := i
			else if(r = this.abbrevConstant)
				this.abbrevIndex := i
			else if(r = this.actionConstant)
				this.actionIndex := i
			else if(r = this.userInputConstant)
				this.userInputIndex := i
			else if(InStr(r, this.dataConstant))
				this.dataIndices.insert(i)
			
			finalIndex := i
		}
		
		if(!this.userInputIndex)
			this.userInputIndex := finalIndex + 1
		
		; DEBUG.popup(this.nameIndex, "Model name", this.abbrevIndex, "Model abbreviation", this.actionIndex, "Model action", this.userInputIndex, "Model user input", this.dataIndices, "Model data")
	}
	
	; Generate the text for the GUI and display it, returning the user's response.
	launchSelectorPopup() {
		Static GuiUserInput ; Must be static to use with Edit control.
		
		; Various GUI element dimensions.
		titleX := 10
		indexX := 5
		abbrevX := indexX + 30
		nameX := abbrevX + 50
		inputX := 10
		
		currY := 10
		lineHeight := 25
		
		indexW := 25
		
		titleStyle := "w700 underline" ; Bold, underline.
		
		; Create and begin styling the GUI.
		Gui, Color, 2A211C
		Gui, Font, s12 cBDAE9D
		Gui, +LastFound
		GuiHWND := WinExist()
		
		; Generate the text to display from the various choice objects.
		displayText := ""
		For i,c in this.choices {
			; Extra newline if requested.
			if(this.nonChoices[i]) {
				; DEBUG.popup(i, "Index", this.nonChoices[i], "Non choice")
				if(this.nonChoices[i] != " " && i != 1) {
					currY += lineHeight
				}
				
				; Title formatting.
				Gui, Font, % titleStyle
				
				; displayText .= this.nonChoices[i] "`n"
				Gui, Add, Text, x%titleX% y%currY%, % this.nonChoices[i]
				currY += lineHeight
				
				; Clear title formatting.
				Gui, Font, norm
			}
			
			; displayText .= i ") " c.abbrev ":`t" c.name "`n"
			
			Gui, Add, Text, x%indexX% Right w%indexW% y%currY%, %i%)
			
			displayText := c.abbrev ":"
			Gui, Add, Text, x%abbrevX% y%currY%, % displayText
			
			Gui, Add, Text, x%nameX% y%currY%, % c.name
			currY += lineHeight
		}
		
		; Show the window in order to get its width.
		Gui, Show, , % this.title
		WinGetPos, X, Y, W, H, A
		; DEBUG.popup(X, "X", Y, "Y", W, "W", H, "H")
		
		; Add the edit control with almost the width of the window.
		currY += lineHeight
		W -= 25
		Gui, Add, Edit, vGuiUserInput x%inputX% y%currY% w%W% h24 -E0x200 +Border
		
		; Resize the GUI to show the newly added edit control.
		H += 30
		Gui, Show, h%H%
		
		; Hidden OK button for {Enter} submission.
		Gui, Add, Button, Hidden Default, SubmitSelectorChoice
		
		; Focus the edit control.
		GuiControl, Focus, GuiUserInput
		GuiControl, +0x800000, GuiUserInput
		
		; Fill in prefix/postfix if given.
		GuiControl, Text, GuiUserInput, % this.prefix this.postfix
		postFixLen := StrLen(this.postfix)
		
		; Make sure we're at the end of the prefix.
		Send, {End}
		Send, {Left %postFixLen%}
		
		; Wait for the user to submit the GUI.
		WinWaitClose, ahk_id %GuiHWND%
		
		; DEBUG.popup(GuiUserInput, "GUI user input")
		
		return GuiUserInput
	}
	
	; Function to turn the input into something useful.
	parseChoice(ByRef userIn, ByRef actionType) {
		histCharPos := InStr(userIn, this.historyChar)
		arbCharPos := InStr(userIn, this.arbitChar)
		
		rowToDo := ""
		rest := SubStr(userIn, 2)
		
		DEBUG.popup(userIn, "User in", actionType, "Action Type", histCharPos, "History char pos", arbCharPos, "Arbitrary char pos", rest, "Rest")
		
		; Just historyChar gives us the last executed command. ArbitChar on its own does the same.
		if(userIn = this.historyChar || userIn = this.arbitChar) {
			if(this.historyChoices.MaxIndex()) {
				rowToDo := this.parseChoice(this.historyChoices[ this.historyChoices.MaxIndex() ], actionType)
			} else {
				MsgBox, No history available!
			}
		
		; History choice - 1 is last entry, 2 is next to last entered, etc.
		} else if(histCharPos = 1) {
			; Special case: historyChar+e is the edit action, which will open the current INI file for editing.
			if(contains(this.editStrings, rest)) {
				; DEBUG.popup(rest, "Edit action `nRest", this.editStrings, "Edit strings")
				actionType := "DO"
				rowToDo := new SelectorRow()
				rowToDo.setAbbrev(userIn)
				rowToDo.setAction(this.filePath)
			
			; Special case: historyChar+d is debug action, which will copy/popup the result of the action.
			} else if(contains(this.debugStrings, rest, 1)) {
				; Peel off the d + space, and run it through this function again.
				StringTrimLeft, userIn, rest, 2
				rowToDo := this.parseChoice(userIn, actionType)
				if(rowToDo)
					rowToDo.isDebug := true
			
			; Otherwise, it has to be numeric.
			} else If rest Is Not Number ; This if loop behaves oddly with curly braces.
				MsgBox, History character must be used with numeric input or special character!
			
			; Normal case, get the history entry specified.
			else {
				rowToDo := this.parseChoice(this.historyChoices[ this.historyChoices.MaxIndex() + 1 - userIn ], actionType)
			}
		; ".yada" passes in "yada" as an arbitrary, meaninful command.
		} else if(arbCharPos = 1) {
			rowToDo := new SelectorRow()
			rowToDo.setAction(rest)

		; Allow concatentation of arbitrary addition with short.yada or #.yada.
		} else if(arbCharPos > 1) {
			StringSplit, splitBits, userIn, % this.arbitChar
			rowToDo := this.searchAllTables(splitBits1)
			if(!rowToDo) {
				MsgBox, No matches found!
			}
			rowToDo.setAbbrev(splitBits1 . this.arbitChar . splitBits2) ; Update the return so that first half of x+y is the shortcut.
			rowToDo.action .= splitBits2
			rowToDo.userInput .= splitBits2
			
		; Otherwise, we search through the data structure by both number and shortcut and look for a match.
		} else {
			rowToDo := this.searchAllTables(userIn)
			
			if(!rowToDo) {
				MsgBox, No matches found!
			}
		}
		
		DEBUG.popup(rowToDo, "Row to do")
		
		return rowToDo
	}

	; Search both given tables, the visible and the invisible.
	searchAllTables(input) {
		; Try the visible choices.
		out := this.searchTable(input, this.choices)
		if(out)
			return out
		
		; Try the invisible choices.
		out := this.searchTable(input, this.hiddenChoices)
		if(out)
			out.setName(this.hiddenChar input) ; Mark that this is an invisible choice.
		
		return out
	}

	; Function to search our generated table for a given index/shortcut.
	searchTable(input, table) {
		For i,t in table {
			; DEBUG.popup(input, "Input", t.name, "Current name", t.abbrev, "Current abbreviation", t.action, "Current Action")
			if(input = i || input = t.abbrev || input = t.name) {
				; DEBUG.popup(input, "Found input", i, "At index", t, "Row")
				return t.clone()
			}
		}
		
		return ""
	}

	; Function to do what it is we want done, then exit.
	doAction(rowToDo, actionType) {
		; DEBUG.popup(actionType, "Action type", rowToDo, "Row to run")
		
		action := rowToDo.action
		
		; Blank for functional use.
		if(!actionType) {
			return action
			
		; Generic caller for many possible actions.
		} else if(isFunc(actionType)) {
			return actionType.(rowToDo)
		
		; Error catch.
		} else {
			MsgBox, Action "%actionType%" not defined!
		}
	}
	
	; Function to output this object as a string for debug purposes.
	toDebugString(numTabs = 0) {
		outStr := "[Selector Object]`n"
		
		numTabs++
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .= "[Choices]`n"
		
		numTabs++
		For i,r in this.choices {
			Loop, %numTabs%
				outStr .= "`t"
			outStr .= "[" i "] " DEBUG.string(r, numTabs)
		}
		numTabs--
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .= "`n[Hidden Choices]`n"
		
		numTabs++
		For i,r in this.hiddenChoices {
			Loop, %numTabs%
				outStr .= "`t"
			outStr .= "[" i "] " DEBUG.string(r, numTabs)
		}
		numTabs--
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .= "`n[Non-Choices]`n"
		
		numTabs++
		For i,r in this.nonChoices {
			Loop, %numTabs%
				outStr .= "`t"
			outStr .= i "	" r "`n"
		}
		numTabs--
		
		; DEBUG.popupWithLabel("[History Choices]", this.historyChoices)
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .= "`n[History Choices]`n"
		
		numTabs++
		For i,r in this.historyChoices {
			Loop, %numTabs%
				outStr .= "`t"
			outStr .= i "	" r "`n"
		}
		numTabs--
		
		return outStr
	}
}