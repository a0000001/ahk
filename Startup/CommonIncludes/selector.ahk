global SELECTOR_TITLE_CHAR := 1
global SELECTOR_HISTORY_CHAR := 2
global SELECTOR_ARBITRARY_CHAR := 3
global SELECTOR_HIDDEN_CHAR := 4
global SELECTOR_LABEL_CHAR := 5

; Selector class which reads in and stores data from a file, and given an index, abbreviation or path (and action), can return the result (and do the action).
class Selector {
	; Constants and such.
	static NAME_IDX := 1
	static ABBR_IDX := 2
	static DATA_IDX := 3
	
	; Constructor: take any characters they want to change and keep track of them, and read in the various files.
	__New(filePath, chars = "") {
		this.init(filePath, chars)
	}
	
	init(filePath, chars) {
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
		
		; Other init values.
		this.startHeight := 105 ; Starting height. Includes prompt, plus extra newline above and below choice list.
		this.title := "Please make a choice by either number or abbreviation:"
		this.fileName := ""
		
		; Read in the choices file.
		if(filePath != "" && FileExist(filePath)) {
			this.loadChoicesFromFile(filePath)
		} else {
			MsgBox, File doesn't exist!
			return ""
		}
		
		; Get paths for the history and icon files, and read them in.
		this.fileName := SubStr(filePath, 1, -4)
		iconFilePath := this.fileName ".ico"
		if(FileExist(this.fileName "History.ini"))
			this.historyChoices := fileLinesToArray(this.fileName "History.ini")
		if(FileExist(iconFilePath))
			Menu, Tray, Icon, %iconFilePath%
	}
	
	; Main function. Sets up and displays the selector gui, processes the choice, etc.
	select(filePath, actionType = "", choice = "", chars = "") {
		; MsgBox, % filePath "`n" choice "`n" actionType
		
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
		action := this.parseChoice(userIn)
		
		; Store what we're about to do in the history file.
		; Don't save hidden entries or the previous entry (input of this.historyChar).
		firstChar := SubStr(userIn, 1, 1)
		if(firstChar != this.hiddenChar && firstChar != this.historyChar) {
			historyFilePath := this.fileName "History.ini"
			
			; If the histoy file already has 10 entries, trim off the oldest one.
			if(this.historyChoices.MaxIndex() = 10) {
				FileDelete, %historyFilePath%
				Loop, 9 {
					FileAppend, % historyChoices[A_Index + 1] "`n", %historyFilePath%
				}
			}
			
			; Add our latest command to the end.
			FileAppend, %userIn%`n, %historyFilePath%
		}

		; So now we have something valid - do it and die.
		return this.doAction(action, actionType)
	}
	
	; Load the choices and other such things from a specially formatted file.
	loadChoicesFromFile(filePath) {
		; Read the file into an array.
		lines := fileLinesToArray(filePath)
		; MsgBox, % arrayToDebugString(lines)
		
		; Parse those lines into a N x 3 array, where the meaningful lines have become a size 3 array (Name, Abbrev, Path) each.
		list := cleanParseList(lines)
		; MsgBox, % arrayToDebugString(list, 2)
		
		For i,currItem in list {
			; currItem := list[i]
			; MsgBox, % currItem[this.NAME_IDX]
			
			; Parse this size-3 array into a new Row object.
			currRow := new SelectorRow(currItem[Selector.NAME_IDX], currItem[Selector.ABBR_IDX], currItem[Selector.DATA_IDX])
			; MsgBox, % currRow.toDebugString()
			
			firstChar := SubStr(currRow.name, 1, 1)
			
			; Title.
			if(i = 1 && firstChar = this.titleChar) {
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
			
			; Otherwise, it's a visible, viable choice!
			} else {
				; Allow piped-together entries, but only show the first one.
				if(inStr(currRow.abbr, "|")) {
					; MsgBox, % "pipe: " currRow.abbr
					splitAbbrev := specialSplit(currRow.abbr, "|")
					For i,a in splitAbbrev {
						tempRow := currRow.clone()
						tempRow.abbr := splitAbbrev[i]
						
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
			
			displayText .= i ") " c.abbr ":`t" c.name "`n"
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
	parseChoice(ByRef userIn) {
		histCharPos := InStr(userIn, this.historyChar)
		arbCharPos := InStr(userIn, this.arbitChar)
		; MsgBox, % histCharPos

		; Just historyChar gives us the last executed command. ArbitChar on its own does the same.
		if(userIn = this.historyChar || userIn = this.arbitChar) {
			if(this.historyChoices.MaxIndex()) {
				action := this.parseChoice(this.historyChoices[ this.historyChoices.MaxIndex() ])
			} else {
				MsgBox, No history available!
				action := ""
			}
		
		; History choice - 1 is last entry, 2 is next to last entered, etc.
		} else if(histCharPos = 1) {
			If SubStr(userIn, 2) is not number {
				MsgBox, History character must be used with numeric input!
				action := ""
			}
			; MsgBox, % arrayToDebugString(this.historyChoices)
			action := this.parseChoice(this.historyChoices[ this.historyChoices.MaxIndex() + 1 - userIn ])
		
		; ".yada" passes in "yada" as an arbitrary, meaninful command.
		} else if(arbCharPos = 1) {
			action := SubStr(userIn, 2)

		; Allow concatentation of arbitrary addition with short.yada or #.yada.
		} else if(arbCharPos > 1) {
			StringSplit, splitBits, userIn, % this.arbitChar
			; MsgBox, % splitBits1 . "	" . splitBits2
			action := this.searchAllTables(splitBits1)
			if(action = "") {
				MsgBox, No matches found!
				action := ""
			}
			userIn := splitBits1 . this.arbitChar . splitBits2 ; Update userIn so that first half of x+y is the shortcut.
			action .= splitBits2
			
		; Otherwise, we search through the data structure by both number and shortcut and look for a match.
		} else {
			action := this.searchAllTables(userIn)
			
			if(action = "") {
				MsgBox, No matches found!
				action := ""
			}
		}

		; MsgBox, % "Action: " action
		return action
	}

	; Search both given tables, the visible and the invisible.
	searchAllTables(ByRef input) {
		; Try the visible choices.
		out := this.searchTable(input, this.choices)
		if(out)
			return out
		
		; Try the invisible choices.
		out := this.searchTable(input, this.hiddenChoices)
		input := this.hiddenChar input ; Mark that this is an invisible choice.
		return out
	}

	; Function to search our generated table for a given index/shortcut.
	searchTable(ByRef input, table) {
		For i,t in table {
			; MsgBox, % input ", " t.name " " t.abbr " " t.data
			if(input = i || input = t.abbr || input = t.name) {
				; MsgBox, Found: %input% at index: %i%
				input := t.abbr
				return t.data
			}
		}
		
		return ""
	}

	; Function to do what it is we want done, then exit.
	doAction(input, actionType) {
		; MsgBox, % "Input: "input "`nActionType: " actionType
		
		; For functional use: return what we've decided.
		if(actionType = "" || actionType = "RETURN") {
			return input
			
		; Run the action.
		} else if(actionType = "RUN") {
			Run, % input
		
		; Just send the text of the action.
		} else if(actionType = "PASTE") {
			SendRaw, %input%
		
		; Send the text of the action and press enter.
		} else if(actionType = "PASTE_SUBMIT") {
			SendRaw, %input%
			Send, {Enter}
		
		; Mainly for debug: pop up a message box with the path.
		} else if(actionType = "POPUP") {
			MsgBox, %input%
		
		; Testing: parse and display the given file.
		} else if(actionType = "TEST") {
			; Run given file with a POPUP action. Yes, this is getting rather meta.
			Run, select.ahk %input% POPUP
		
		; Call the action.
		} else if(actionType = "CALL") {
			URL := "http://guru/services/Webdialer.asmx/"
			
			if(input = "-") {
				; MsgBox, Hanging up current call.
				URL .= "HangUpCall?"
				MsgText = Hanging up current call. `n`nContinue?
			} else {
				phoneNum := parsePhone(input)
				
				if(phoneNum = -1) {
					MsgBox, Invalid phone number!
					return
				}
				
				URL .= "CallNumber?extension=" . phoneNum
				MsgText = Calling: `n`n%input% `n[%phoneNum%] `n`nContinue?
			}
			
			MsgBox, 4,, %MsgText%
			IfMsgBox No
				ExitApp
				
			HTTPRequest(URL, In := "", Out := "")
			; MsgBox, Response: %html%
		} else {
			MsgBox, No action type given, exiting...
		}
	}
	
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
	name := ""
	abbr := ""
	data := ""
	
	__New(n, a, d) {
		this.name := n
		this.abbr := a
		this.data := d
	}
	
	clone() {
		return new SelectorRow(this.name, this.abbr, this.data)
	}
	
	toDebugString() {
		return "        Name: " this.name "`n	Abbreviation: " this.abbr "`n	Data: " this.data
	}
}