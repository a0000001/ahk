global SELECTOR_TITLE_CHAR := 1
global SELECTOR_HISTORY_CHAR := 2
global SELECTOR_ARBITRARY_CHAR := 3
global SELECTOR_HIDDEN_CHAR := 4
global SELECTOR_LABEL_CHAR := 5
global SELECTOR_START_MODEL_ROW_CHAR := 6
global SELECTOR_START_ACTION_DEF_ROW_CHAR := 7

; Selector class which reads in and stores data from a file, and given an index, abbreviation or action, can return the result (and do the action).
class Selector {
	; Constants and such.
	static nameIndex := 1
	static abbrevIndex := 2
	static actionIndex := 3
	static dataIndices := []
	
	static nameConstant := "NAME"
	static abbrevConstant := "ABBREV"
	static actionConstant := "ACTION"
	static dataConstant := "DATA"
	
	static actionRowDef := ""
	
	; Constructor: take any characters they want to change and keep track of them, and read in the various files.
	__New(filePath, chars = "") {
		this.init(filePath, chars)
	}
	
	init(fPath, chars) {
		; Various choice data objects.
		this.choices := Object() ; Visible choices the user can pick from.
		this.hiddenChoices := Object() ; Invisible choices the user can pick from.
		this.nonChoices := Object() ; Lines that will be displayed as titles, extra newlines, etc, but have no other significance.
		this.historyChoices := Object() ; Lines read in from the history file.
		
		; Character defaults vs what they gave us.
		this.titleChar := chars[SELECTOR_TITLE_CHAR] ? chars[SELECTOR_TITLE_CHAR] : "="
		this.historyChar := chars[SELECTOR_HISTORY_CHAR] ? chars[SELECTOR_HISTORY_CHAR] : "+"
		this.arbitChar := chars[SELECTOR_ARBITRARY_CHAR] ? chars[SELECTOR_ARBITRARY_CHAR] : "."
		this.hiddenChar := chars[SELECTOR_HIDDEN_CHAR] ? chars[SELECTOR_HIDDEN_CHAR] : "*"
		this.labelChar := chars[SELECTOR_LABEL_CHAR] ? chars[SELECTOR_LABEL_CHAR] : "#"
		this.startModelRowChar := chars[SELECTOR_START_MODEL_ROW_CHAR] ? chars[SELECTOR_START_MODEL_ROW_CHAR] : "("
		this.startActionDefRowChar := chars[SELECTOR_START_ACTION_DEF_ROW_CHAR] ? chars[SELECTOR_START_ACTION_DEF_ROW_CHAR] : "{"
		
		; Other init values.
		this.startHeight := 105 ; Starting height. Includes prompt, plus extra newline above and below choice list.
		this.title := "Please make a choice by either number or abbreviation:"
		this.filePath := fPath
		this.fileName := ""
		
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
	select(filePath, actionType = "", silentChoice = "", chars = "") {
		; MsgBox, % filePath "`n" actionType "`n" silentChoice
		
		; Set up our various information, read-ins, etc.
		this.init(filePath, chars)
		
		; If they've given us a choice, run silently.
		if(silentChoice != "")
			userIn := silentChoice
		else ; Prepare and show the GUI.
			userIn := this.launchSelectorPopup()
		
		if(userIn = "") {
			return ""
		}
		
		; Parse input to meaningful command.
		; MsgBox, % "UserIn: " userIn
		; action := this.parseChoice(userIn, actionType)
		rowToDo := this.parseChoice(userIn, actionType)
		
		; Store what we're about to do in the history file.
		; Don't save hidden entries or the previous entry (input of this.historyChar).
		; firstChar := SubStr(userIn, 1, 1)
		firstChar := SubStr(rowToDo.name, 1, 1)
		if(firstChar != this.hiddenChar && firstChar != this.historyChar) {
			historyFilePath := this.fileName "History.ini"
			
			; If the histoy file already has 10 entries, trim off the oldest one.
			if(this.historyChoices.MaxIndex() = 10) {
				FileDelete, %historyFilePath%
				Loop, 9 {
					; MsgBox, % "Adding back in history choice: " this.historyChoices[A_Index + 1]
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
		; Read the file into an array.
		lines := fileLinesToArray(filePath)
		; MsgBox, % arrayToDebugString(lines)
		
		; Parse those lines into a N x 3 array, where the meaningful lines have become a size 3 array (Name, Abbrev, Action) each.
		list := cleanParseList(lines)
		; MsgBox, % arrayToDebugString(list, 2)
		
		For i,currItem in list {
			; currItem := list[i]
			; MsgBox, % currItem[this.NAME_IDX]
			
			; Parse this size-3 array into a new Row object.
			; currRow := new SelectorRow(currItem[Selector.NAME_IDX], currItem[Selector.ABBR_IDX], currItem[Selector.DATA_IDX])
			currRow := new SelectorRow(currItem)
			; MsgBox, % currRow.toDebugString()
			
			firstChar := SubStr(currRow.get(1), 1, 1)
			; MsgBox, % "First char: " firstChar
			
			; Popup title.
			if(i = 1 && firstChar = this.titleChar) {
				; MsgBox, Title row!
				this.title := SubStr(currRow.name, 2)
			
			; Special: add a title and/or blank row in the list display.
			} else if(firstChar = this.labelChar) {
				; MsgBox, % this.labelChar currRow.name
				
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
					; MsgBox, % "Just added: " . this.nonChoices[this.nonChoices.MaxIndex()] . " at index: " . idx+1
				}
				
			; Invisible, but viable, choice.
			} else if(firstChar = this.hiddenChar) {
				; MsgBox, It's a star row!
				this.hiddenChoices.Insert(currRow)
			
			; Special model row that tells us how a file with more than 3 columns should be laid out.
			} else if(firstChar = this.startModelRowChar) {
				; MsgBox, Model row!
				this.parseModelRow(currRow)
			
			; Special row that tells us how to string together the action if it's not directly in there - used for more complex substitutions.
			} else if(firstChar = this.startActionDefRowChar) {
				; Strip off the bracket from the first element.
				currRow.set(1, SubStr(currRow.get(1), 2))
				
				this.actionRowDef := currRow
			
			; Otherwise, it's a visible, viable choice!
			} else {
				; Allow piped-together entries, but only show the first one.
				if(inStr(currRow.abbrev, "|")) {
					; MsgBox, % "pipe: " currRow.abbrev
					splitAbbrev := specialSplit(currRow.abbrev, "|")
					For i,a in splitAbbrev {
						tempRow := currRow.clone()
						tempRow.abbrev := splitAbbrev[i]
						
						if(A_Index = 1) {
							this.choices.Insert(tempRow)
						} else {
							this.hiddenChoices.Insert(tempRow)
						}
					}
				} else {
					; MsgBox, % "Choice added: `n" currRow.toDebugString()
					this.choices.Insert(currRow)
				}
			}
		}
		
		; MsgBox, % this.toDebugString()
	}
	
	; Function to deal with special model rows.
	parseModelRow(row) {
		; Strip off the paren from the first element.
		row.set(1, SubStr(row.get(1), 2))
		; row.set(-1, SubStr(row.get(-1), 1, -1))
		
		For i,r in row.rowArr {
			; MsgBox, % i "	" r
			if(r = this.nameConstant)
				this.nameIndex := i
			else if(r = this.abbrevConstant)
				this.abbrevIndex := i
			else if(r = this.actionConstant)
				this.actionIndex := i
			else if(InStr(r, this.dataConstant))
				this.dataIndices.insert(i)
		}
		
		; outStr := "Model row results:" "`n`nName: " this.nameIndex "`nAbbreviation: " this.abbrevIndex "`nAction: " this.actionIndex "`nData: "
		; For i,d in this.dataIndices
			; outStr .= "`n	"d
		; MsgBox, % outStr
	}
	
	; Generate the text for the GUI and display it, returning the user's response.
	launchSelectorPopup() {
		; Generate the text to display from the various choice objects.
		displayText := ""
		For i,c in this.choices {
			; Extra newline if requested.
			if(this.nonChoices[i]) {
				; MsgBox, % i "	" this.nonChoices[i]
				if(this.nonChoices[i] != " " && i != 1) {
					displayText .= "`n"
				}
				
				displayText .= this.nonChoices[i] "`n"
			}
			
			displayText .= i ") " c.abbrev ":`t" c.name "`n"
		}
		
		; Actually prompt the user.
		height := this.startHeight + getTextHeight(displayText)
		title := this.title
		InputBox, userIn, %title%, %displayText%, , 400, %height%
		if(ErrorLevel)
			userIn := ""
		
		return userIn
	}
	
	; Function to turn the input into something useful.
	parseChoice(ByRef userIn, ByRef actionType) {
		histCharPos := InStr(userIn, this.historyChar)
		arbCharPos := InStr(userIn, this.arbitChar)
		; MsgBox, % histCharPos
		
		rowToDo := ""
		rest := SubStr(userIn, 2)
		
		; Just historyChar gives us the last executed command. ArbitChar on its own does the same.
		if(userIn = this.historyChar || userIn = this.arbitChar) {
			if(this.historyChoices.MaxIndex()) {
				; action := this.parseChoice(this.historyChoices[ this.historyChoices.MaxIndex() ], actionType)
				rowToDo := this.parseChoice(this.historyChoices[ this.historyChoices.MaxIndex() ], actionType)
			} else {
				MsgBox, No history available!
				; action := ""
			}
		
		; History choice - 1 is last entry, 2 is next to last entered, etc.
		} else if(histCharPos = 1) {
			; Special case: historyChar+0 is the edit action, which will open the current INI file for editing.
			if(rest = 0 || rest = "e" || rest = "edit") {
				; MsgBox, Edit action!
				actionType := "EDIT"
				; action := this.filePath
				rowToDo := new SelectorRow()
				rowToDo.action := this.filePath
			
			; Otherwise, it has to be numeric.
			} else If rest Is Not Number ; This if loop behaves oddly with curly braces.
				MsgBox, History character must be used with numeric input or "edit"!
			
			; Normal case, get the history entry specified.
			else {
				; MsgBox, % arrayToDebugString(this.historyChoices)
				; action := this.parseChoice(this.historyChoices[ this.historyChoices.MaxIndex() + 1 - userIn ], actionType)
				rowToDo := this.parseChoice(this.historyChoices[ this.historyChoices.MaxIndex() + 1 - userIn ], actionType)
			}
		; ".yada" passes in "yada" as an arbitrary, meaninful command.
		} else if(arbCharPos = 1) {
			; action := rest
			rowToDo := new SelectorRow()
			rowToDo.action := rest

		; Allow concatentation of arbitrary addition with short.yada or #.yada.
		} else if(arbCharPos > 1) {
			StringSplit, splitBits, userIn, % this.arbitChar
			; MsgBox, % splitBits1 . "	" . splitBits2
			; action := this.searchAllTables(splitBits1)
			rowToDo := this.searchAllTables(splitBits1)
			if(!rowToDo) {
				MsgBox, No matches found!
			}
			; userIn := splitBits1 . this.arbitChar . splitBits2 ; Update userIn so that first half of x+y is the shortcut.
			rowToDo.abbrev := splitBits1 . this.arbitChar . splitBits2 ; Update the return so that first half of x+y is the shortcut.
			; action .= splitBits2
			rowToDo.action .= splitBits2
			
		; Otherwise, we search through the data structure by both number and shortcut and look for a match.
		} else {
			; action := this.searchAllTables(userIn)
			rowToDo := this.searchAllTables(userIn)
			
			if(!rowToDo) {
				MsgBox, No matches found!
			}
		}

		; MsgBox, % "Action: " action
		; return action
		; MsgBox, % "Row To Do: `n`n" rowToDo.toDebugString()
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
			out.name := this.hiddenChar input ; Mark that this is an invisible choice.
			; input := this.hiddenChar input ; Mark that this is an invisible choice.
		
		return out
	}

	; Function to search our generated table for a given index/shortcut.
	searchTable(input, table) {
		For i,t in table {
			; MsgBox, % input ", " t.name " " t.abbrev " " t.action
			if(input = i || input = t.abbrev || input = t.name) {
				; MsgBox, Found: %input% at index: %i%
				; input := t.abbrev
				; return t.action
				return t.clone()
			}
		}
		
		return ""
	}
	
	; Puts together the action for files in which it's not explicit, but pieced together.
	processAction(def, row) {
		action := ""
		; MsgBox, % arrayToDebugString(def.rowArr, 2)
		
		For i,d in def.rowArr {
			; MsgBox, % "Def: " d
			if(d = "NAME")
				action .= row.name
			else if(d = "ABBREV")
				action .= row.abbrev
			else if(d = "ACTION")
				action .= row.action
			else if(SubStr(d, 1, StrLen(this.dataConstant)) = this.dataConstant) {
				; This should be the number associated with the data bit.
				rest := SubStr(d, StrLen(this.dataConstant) + 1)
				
				; Get the data from that number and stick it on the end.
				action .= row.getData(rest)
			} else
				action .= d
			
			; MsgBox, % "Action: " action
		}
		
		return action
	}

	; Function to do what it is we want done, then exit.
	doAction(rowToDo, actionType) {
		; MsgBox, % "ActionType: " actionType "`n`nAction Row to run:`n" rowToDo.toDebugString()
		
		action := rowToDo.action
		
		; If this is a more complex case, process the action before trying to do it.
		if(this.actionRowDef) {
			action := this.processAction(this.actionRowDef, rowToDo)
		}
		
		; For functional use: return what we've decided.
		if(actionType = "" || actionType = "RETURN") {
			return action
			
		; Run the action.
		} else if(actionType = "RUN") {
			Run, % action
			
		; Run the action, waiting for it to finish.
		} else if(actionType = "RUNWAIT") {
			RunWait, % action
		
		; Just send the text of the action.
		} else if(actionType = "PASTE") {
			SendRaw, %action%
		
		; Send the text of the action and press enter.
		} else if(actionType = "PASTE_SUBMIT") {
			SendRaw, %action%
			Send, {Enter}
		
		; Mainly for debug: pop up a message box with the action.
		} else if(actionType = "POPUP") {
			MsgBox, %action%
		
		; Testing: parse and display the given file.
		} else if(actionType = "TEST") {
			; Run given file with a POPUP action. Yes, this is getting rather meta.
			Run, select.ahk %action% POPUP
		
		; Edit the current ini file.
		} else if(actionType = "EDIT") {
			Run, %action%
		
		; Call the action.
		} else if(actionType = "CALL") {
			URL := "http://guru/services/Webdialer.asmx/"
			
			if(action = "-") {
				; MsgBox, Hanging up current call.
				URL .= "HangUpCall?"
				MsgText = Hanging up current call. `n`nContinue?
			} else {
				phoneNum := parsePhone(action)
				
				if(phoneNum = -1) {
					MsgBox, Invalid phone number!
					return
				}
				
				URL .= "CallNumber?extension=" . phoneNum
				MsgText = Calling: `n`n%action% `n[%phoneNum%] `n`nContinue?
			}
			
			MsgBox, 4,, %MsgText%
			IfMsgBox No
				ExitApp
				
			HTTPRequest(URL, In := "", Out := "")
			; MsgBox, Response: %html%
		} else {
			MsgBox, Action type not recognized, exiting.
		}
	}
	
	; Function to output this object as a string for debug purposes.
	toDebugString() {
		outStr := "Choices:"
		For i,r in this.choices
			outStr .= "`n" i r.toDebugString()
		outStr .= "`n`nHidden Choices:"
		For i,r in this.hiddenChoices
			outStr .= "`n`n" i r.toDebugString()
		outStr .= "`n`nNon-Choices:"
		For i,r in this.nonChoices
			outStr .= "`n	" i " " r
		outStr .= "`n`nHistory Choices:"
		For i,r in this.historyChoices
			outStr .= i " " r
		
		return outStr
	}
}

; Row class for use in the Selector. Has three pieces.
class SelectorRow {
	rowArr := []
	name := ""
	abbr := ""
	action := ""
	dataNums := []
	data := []
	
	; Constructor.
	__New(arr = "") {
		if(arr != "") {
			For i,a in arr {
				; MsgBox, %"x " i "	" a
				; MsgBox, Adding to row: %a%
				this.rowArr.insert(a)
			}
			
			; Variable access to needed pieces.
			this.name := this.rowArr[Selector.nameIndex]
			this.abbrev := this.rowArr[Selector.abbrevIndex]
			this.action := this.rowArr[Selector.actionIndex]
			For i,j in Selector.dataIndices {
				; MsgBox, % this.rowArr[j]
				this.data.insert(this.rowArr[j])
				this.dataNums.insert(i)
			}
			
			; MsgBox, % this.rowArr[1] "x"
			
			; Temp, remove and fix later.
			; this.name := this.rowArr[1]
			; this.abbrev := this.rowArr[2]
			; this.action := this.rowArr[3]
			
			; MsgBox, % "Name: " this.name
		}
	}
	; __New(n, a, d) {
		; this.name := n
		; this.abbrev := a
		; this.action := d
	; }
	
	; Shallow copy function.
	clone() {
		; return new SelectorRow(this.name, this.abbrev, this.action)
		return new SelectorRow(this.rowArr)
	}
	
	get(i) {
		; MsgBox, % "Getting " i ": " rowArr[i]
		if(i < 0) {
			return this.rowArr[this.rowArr.MaxIndex()]
		}
		return this.rowArr[i]
	}
	set(i, x) {
		if(i < 0) {
			; MsgBox, % i "	" this.rowArr.MaxIndex()
			this.rowArr[this.rowArr.MaxIndex()] := x
			return
		}
		this.rowArr[i] := x
	}
	
	getData(n) {
		For i,d in this.dataNums {
			if(d = n) {
				return this.data[i]
			}
		}
	}
	
	; Function to output this object as a string for debug purposes.
	toDebugString() {
		outStr := "        Name: " this.name "`n	Abbreviation: " this.abbrev "`n	Action: " this.action "`n	Data:"
		For i,d in this.data
			outStr .= "`n		" this.dataNums[i] "	" d
		return outStr
	}
}