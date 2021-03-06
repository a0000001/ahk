; V. 1.0, rewritten since.

; (Semi-) Generic standalone script which launches one of many given choices based on their number or shortcut.
; #Include ..\Startup\commonIncludesStandalone.ahk

; Constants and such.
global SELECTOR_NAME := 1
global SELECTOR_ABBREV := 2
global SELECTOR_PATH := 3

global SELECTOR_HISTORY_CHAR := "+"
global SELECTOR_ARBITRARY_CHAR := "."
global SELECTOR_HIDDEN_CHAR := "*"
global SELECTOR_LABEL_CHAR := "#"

global startHeight := 105 ; Starting height. Includes prompt, plus extra newline above and below choice list.

; Main function. Sets up and displays the selector gui, processes the choice, etc.
select(filePath, actionType, silentChoice = "", noIcon = 0) {
	; Objects to hold choices and lines to print.
	choices := Object() ; Visible choices the user can pick from.
	hiddenChoices := Object() ; Invisible choices the user can pick from.
	nonChoices := Object() ; Lines that will be displayed as titles, extra newlines, etc, but have no other significance.
	historyChoices := Object() ; Lines read in from the history file.

	; Read in our command line arguments.
	; filePath = %1%
	; actionType = %2%
	; silentChoice = %3%
	
	; MsgBox, % filePath "`n" actionType "`n" silentChoice
	
	fileName := SubStr(filePath, 1, -4)
	iconFileName := fileName ".ico"
	historyFileName := fileName "History.ini"
	
	; MsgBox, % historyFileName
	; if(silentChoice != "") {
		; MsgBox, % silentChoice
	; }

	; Read in the history file.
	historyChoices := fileLinesToArray(historyFileName)
	; MsgBox, % historyChoices[0] . "`n" . historyChoices[1]

	; Set the tray icon based on the input ini filename.
	if(!noIcon) {
		Menu, Tray, Icon, %iconFileName%
	}

	; Read in the various paths, names, and abbreviations.
	title := loadChoicesFromFile(filePath, choices, hiddenChoices, nonChoices)

	; MsgBox, Title: %title%
	; MsgBox, % "c" choices.MaxIndex() " h" hiddenChoices.MaxIndex() " n" nonChoices.MaxIndex()
	; MsgBox, % choices[1, SELECTOR_NAME] " " hiddenChoices[1, SELECTOR_NAME] " " nonChoices[1]
	; MsgBox, % choices[2, SELECTOR_NAME] " " hiddenChoices[2, SELECTOR_NAME] " " nonChoices[2]
	; MsgBox, % choices[3, SELECTOR_NAME] " " hiddenChoices[3, SELECTOR_NAME] " " nonChoices[3]
	; MsgBox, % nonChoices[1]
	; MsgBox, % nonChoices[10]

	; ExitApp


	; ----- Get choice. ----- ;
	; Allow for a command-line-passed input rather than popping up a GUI.
	if(silentChoice != "") {
		userIn := silentChoice
	} else {
		; Put the above stuff together.
		displayText := generateDisplayText(title, choices, nonChoices)
		
		; Actually prompt the user.
		height := startHeight + getTextHeight(displayText)
		InputBox, userIn, %title%, %displayText%, , 400, %height%
		if(ErrorLevel || userIn = "") {
			return
		}
	}

	; MsgBox, z%userIn%z
	; ExitApp


	; ----- Parse input to meaningful command. ----- ;
	action := parseChoice(userIn, choices, hiddenChoices, historyChoices)

	; ----- Store what we're about to do, then do it. ----- ;
	; Don't save hidden entries or the previous entry (input of SELECTOR_HISTORY_CHAR).
	if(SubStr(userIn, 1, 1) != SELECTOR_HIDDEN_CHAR && userIn != SELECTOR_HISTORY_CHAR) {
		; If the histoy file already has 10 entries, trim off the oldest one.
		if(historyChoices.MaxIndex() = 10) {
			FileDelete, %historyFileName%
			Loop, 9 {
				FileAppend, % historyChoices[A_Index + 1] "`n", %historyFileName%
			}
		}
		
		; Add our latest command to the end.
		FileAppend, %userIn%`n, %historyFileName%
	}

	; So now we have something valid - do it and die.
	return doAction(action, actionType)
}

; Create text to display in popup using data structures from the file.
generateDisplayText(title, choices, nonChoices) {
	outText := ""
	choicesLen := choices.MaxIndex()
	Loop, %choicesLen% {
		; Extra newline if requested.
		if(nonChoices[A_Index]) {
			; MsgBox, % A_Index "	" nonChoices[A_Index]
			
			if(nonChoices[A_Index] != " " && A_Index != 1) {
				outText .= "`n"
			}
			
			outText .= nonChoices[A_Index]"`n"
		}
		
		outText .= A_Index ") " choices[A_Index, SELECTOR_ABBREV] ":`t" choices[A_Index, SELECTOR_NAME] "`n"
	}
	
	return outText
}

; Load the choices and other such things from a specially formatted file.
loadChoicesFromFile(filePath, choices, hiddenChoices, nonChoices) {
	; Read in the list.
	lines := fileLinesToArray(filePath)
	; linesLen := lines.MaxIndex()
	; outStr2 := "Lines In: `n"
	; Loop, %linesLen% {
		; outStr2 .= lines[A_Index] . "`n"
	; }
	; MsgBox, % outStr2
	
	; Parse those lines into a uniform, one-line-per-item list.
	; chars := Object()
	; chars[LIST_ESC_CHAR] := "\"
	; chars[LIST_PASS_ROW_CHARS] := "#"
	; chars[LIST_COMMENT_CHAR] := ";"
	; chars[LIST_PRE_CHAR] := ","
	; chars[LIST_ADD_SELECTOR_LABEL_CHAR] := "+"
	; chars[LIST_REMOVE_SELECTOR_LABEL_CHAR] := "-"
	; list := cleanParseList(lines, ["\", "#", ";", ",", "+", "-"])
	; list := cleanParseList(lines, chars)
	list := cleanParseList(lines)
	; listLen := list.MaxIndex()
	; outStr2 := "`nLines Parsed: `n"
	; Loop, %listLen% {
		; outStr2 .= list[A_Index, SELECTOR_NAME] . A_Tab . list[A_Index, SELECTOR_ABBREV] . A_Tab . list[A_Index, SELECTOR_PATH] . "`n"
	; }	
	; MsgBox, % outStr2
	
	; Loop, Read, %filePath%
	listLen := list.MaxIndex()
	Loop, %listLen% {
		currItem := list[A_Index]
		; MsgBox, % currItem[SELECTOR_NAME]
		
		; Title.
		if(A_Index = 1) {
			title := currItem[SELECTOR_NAME]
		
		; Special: add a title and/or blank row in the list display.
		} else if(SubStr(currItem[SELECTOR_NAME], 1, 1) = SELECTOR_LABEL_CHAR) {
			; MsgBox, % SELECTOR_LABEL_CHAR currItem
			
			; If blank, extra newline.
			if(StrLen(currItem[SELECTOR_NAME]) < 3) {
				nonChoices.Insert(" ")
			
			; If title, #{Space}Title.
			} else {
				idx := 0
				if(choices.MaxIndex()) {
					idx := choices.MaxIndex()
				}
				
				nonChoices.Insert(idx + 1, SubStr(currItem[SELECTOR_NAME], 3))
				; MsgBox, % "Just added: " . nonChoices[nonChoices.MaxIndex()] . " at index: " . idx+1
			}
			
		; Invisible, but viable, choice.
		} else if(SubStr(currItem[SELECTOR_NAME], 1, 1) = SELECTOR_HIDDEN_CHAR) {
			; MsgBox, It's a star row!
			hiddenChoices.Insert(currItem)
		
		; Otherwise, it's a visible, viable choice!
		} else {
			; Allow piped-together entries, but only show the first one.
			if(inStr(currItem[SELECTOR_ABBREV], "|")) {
				; MsgBox, % "pipe: " currItem[SELECTOR_ABBREV]
				splitAbbrev := specialSplit(currItem[SELECTOR_ABBREV], "|")
				splitAbbrevLen := splitAbbrev.MaxIndex()
				Loop, %splitAbbrevLen% {
					tempItem := Object()
					tempItem[SELECTOR_NAME] := currItem[SELECTOR_NAME]
					tempItem[SELECTOR_ABBREV] := splitAbbrev[A_Index]
					tempItem[SELECTOR_PATH] := currItem[SELECTOR_PATH]
					
					if(A_Index = 1) {
						choices.Insert(tempItem)
					} else {
						hiddenChoices.Insert(tempItem)
					}
				}
			} else {
				choices.Insert(currItem)
			}
		}
	}
	
	return title
}

; ; Gives the height of the given text.
; getTextHeight(text) {
	; StringReplace, text, text, `n, `n, UseErrorLevel
	; lines := ErrorLevel + 1
	
	; lineHeight := 17 ; play with this value
	
	; height := lines * lineHeight
	; ; MsgBox % lines " " height
	
	; return height
; }

; Search both given tables, the visible and the invisible.
searchBoth(ByRef input, table, hiddenTable) {
	; Try the visible choices.
	out := searchTable(input, table)
	if(out) {
		return out
	}
	
	; Try the invisible choices.
	out := searchTable(input, hiddenTable)
	input := SELECTOR_HIDDEN_CHAR . input ; Mark that this is an invisible choice.
	return out
}

; Function to search our generated table for a given index/shortcut.
searchTable(ByRef input, table) {
	; MsgBox, % input . ", " . table[1, SELECTOR_NAME] . " " . table[1, SELECTOR_PATH]
	
	tableLen := table.MaxIndex()
	Loop, %tableLen% {
		; MsgBox, % input . ", " . table[A_Index, SELECTOR_NAME] . " " . table[A_Index, SELECTOR_PATH]
		if(input = A_Index || input = table[A_Index, SELECTOR_ABBREV] || input = table[A_Index, SELECTOR_NAME]) {
			; MsgBox, Found: %input% at index: %A_Index%
			input := table[A_Index, SELECTOR_ABBREV]
			return table[A_Index, SELECTOR_PATH]
		}
	}
	
	return ""
}

; Function to turn the input into something useful.
parseChoice(ByRef userIn, choices, hiddenChoices, historyChoices = "") {
	histCharPos := InStr(userIn, SELECTOR_HISTORY_CHAR)
	arbCharPos := InStr(userIn, SELECTOR_ARBITRARY_CHAR)
	; MsgBox, % histCharPos

	; SELECTOR_HISTORY_CHAR gives us the last executed command. SELECTOR_ARBITRARY_CHAR on its own does the same.
	if(userIn = SELECTOR_HISTORY_CHAR || userIn = SELECTOR_ARBITRARY_CHAR) {
		if(historyChoices.MaxIndex()) {
			action := parseChoice(historyChoices[ historyChoices.MaxIndex() ], choices, hiddenChoices)
		} else {
			MsgBox, No history available!
			return
		}

	; "+yada" passes in "yada" as an arbitrary, meaninful command.
	} else if(arbCharPos = 1) {
		action := SubStr(userIn, 2)

	; Allow concatentation of arbitrary addition with short+yada or #+yada.
	} else if(arbCharPos > 1) {
		StringSplit, splitBits, userIn, %SELECTOR_ARBITRARY_CHAR%
		; MsgBox, % splitBits1 . "	" . splitBits2
		action := searchBoth(splitBits1, choices, hiddenChoices)
		if(action = "") {
			MsgBox, No matches found!
			return
		}
		action .= splitBits2
		userIn := splitBits1 . SELECTOR_ARBITRARY_CHAR . splitBits2 ; Update userIn so that first half of x+y is the shortcut.
		
	; Otherwise, we search through the data structure by both number and shortcut and look for a match.
	} else {
		action := searchBoth(userIn, choices, hiddenChoices)
		
		if(action = "") {
			MsgBox, No matches found!
			return
		}
	}

	; MsgBox, %action%
	; ExitApp
	
	return action
}

; Function to do what it is we want done, then exit.
doAction(input, actionType) {
	; MsgBox, % input "`n" actionType
	
	; Run the action.
	if(actionType = "RUN") {
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
	
	; For functional use: return what we've decided.
	} else if(actionType = "RETURN") {
		return input
	
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
