; (Semi-) Generic standalone script which launches one of many given choices.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include HTTPRequest.ahk

; Constants and such.
global COUNT := 0
global NAME := 1
global ABBREV := 2
global PATH := 3

global HISTORY_CHAR := "."
global ARBITRARY_CHAR := "+"

height := 105 ; Starting height. Includes prompt, plus extra newline above and below choice list.

; Objects to hold choices and lines to print.
choices := Object() ; Visible choices the user can pick from.
hiddenChoices := Object() ; Invisible choices the user can pick from.
nonChoices := Object() ; Lines that will be displayed as titles, extra newlines, etc, but have no other significance.
historyChoices := Object() ; Lines read in from the history file.

; Counts for each array are stored in arr[COUNT].
choices[COUNT] := 0
hiddenChoices[COUNT] := 0

; Read in our command line arguments.
filePath = %1%
actionType = %2%
silentChoice = %3%
fileName := SubStr(filePath, 1, -4)
iconFileName := fileName ".ico"
historyFileName := fileName "History.ini"
; MsgBox, % historyFileName
; if(silentChoice != "") {
	; MsgBox, % silentChoice
; }

; Read in the history file.
Loop Read, %historyFileName% 
{
	historyChoices[A_Index] := A_LoopReadLine
	historyChoices[COUNT] := A_Index
}

; Set the tray icon based on the input ini filename.
Menu, Tray, Icon, %iconFileName%

; Read in the various paths, names, and abbreviations.
title := loadChoicesFromFile(filePath, choices, hiddenChoices, nonChoices)

; MsgBox, Title: %title%
; MsgBox, % choices[COUNT] " " hiddenChoices[COUNT] " " nonChoices[COUNT]
; MsgBox, % choices[1, NAME] " " hiddenChoices[1, NAME] " " nonChoices[1]
; MsgBox, % choices[2, NAME] " " hiddenChoices[2, NAME] " " nonChoices[2]
; MsgBox, % choices[3, NAME] " " hiddenChoices[3, NAME] " " nonChoices[3]
; ExitApp


; ----- Get choice. ----- ;
; Allow for a command-line-passed input rather than popping up a GUI.
if(silentChoice != "") {
	userIn := silentChoice
} else {
	; Put the above stuff together.
	displayText := generateDisplayText(title, choices, nonChoices)

	; Actually prompt the user.
	height += getTextHeight(displayText)
	InputBox, userIn, %title%, %displayText%, , 400, %height%
	if(ErrorLevel || userIn = "") {
		ExitApp
	}
}

; MsgBox, z%userIn%z
; ExitApp


; ----- Parse input to meaningful command. ----- ;
action := parseChoice(ByRef userIn, choices, hiddenChoices, historyChoices)


; ----- Store what we're about to do, then do it. ----- ;
; Don't save star entries or the previous entry (input of HISTORY_CHAR).
if(SubStr(userIn, 1, 1) != "*" && userIn != HISTORY_CHAR) {
	; If the histoy file already has 10 entries, trim off the oldest one.
	if(historyChoices[COUNT] = 10) {
		FileDelete, %historyFileName%
		Loop, 9 {
			FileAppend, % historyChoices[A_Index + 1] "`n", %historyFileName%
		}
	}
	
	; Add our latest command to the end.
	FileAppend, %userIn%`n, %historyFileName%
}

; So now we have something valid - do it and die.
doAction(action)
return


; Create text to display in popup using data structures from the file.
generateDisplayText(title, choices, nonChoices) {
	outText := ""
	choicesLen := choices[COUNT]
	Loop, %choicesLen% {
		; Extra newline if requested.
		if(nonChoices[A_Index]) {
			; MsgBox, % A_Index "	" nonChoices[A_Index]
			
			if(nonChoices[A_Index] != " " && A_Index != 1) {
				outText .= "`n"
			}
			
			outText .= nonChoices[A_Index]"`n"
		}
		
		outText .= A_Index ") " choices[A_Index, ABBREV] ":`t" choices[A_Index, NAME] "`n"
	}
	
	return outText
}

; Load the choices and other such things from a specially formatted file.
loadChoicesFromFile(filePath, choices, hiddenChoices, nonChoices) {
	Loop, Read, %filePath%
	{
		; MsgBox, %A_LoopReadLine%
		
		; Title.
		if(A_Index = 1) {
			title := A_LoopReadLine
		
		; Blank lines and comments are completely ignored.
		} else if(A_LoopReadLine = "" || SubStr(A_LoopReadLine, 1, 1) = ";") { ; Blank line or comment, ignore it.
			; MsgBox, blank
		
		; Special: add a title and/or blank row in the list display.
		} else if(SubStr(A_LoopReadLine, 1, 1) = "#") {
			; MsgBox, #
			
			; Using the choice array's count instead, as this should match up (+1).
			; nonChoices[COUNT]++
			
			if(StrLen(A_LoopReadLine) < 3) { ; If title, #{Space}Title.
				nonChoices[ choices[COUNT] + 1 ] := " "
				; extraLines[sessionsLen] := " "
			} else {
				nonChoices[ choices[COUNT] + 1 ] := SubStr(A_LoopReadLine, 3)
				; extraLines[sessionsLen] .= SubStr(A_LoopReadLine, 3)
			}
			
			; extraLen++
			
		; Invisible, but viable, choice.
		} else if(SubStr(A_LoopReadLine, 1, 1) = "*") {
			; MsgBox, It's a star row!
			; starRow := true
			; sessionsLen-- ; Don't want to leave an empty space in the visible rows.
			
			hiddenChoices[COUNT]++
			
			Loop, Parse, A_LoopReadLine, %A_Tab% ; Parse the string based on the tab character.
			{
					; MsgBox, got a star chunk: %A_LoopField% %starLen%
					hiddenChoices[hiddenChoices[COUNT], A_Index] := A_LoopField
			}
		
		; Otherwise, it's a visible, viable choice!
		} else {
			choices[COUNT]++
			Loop, Parse, A_LoopReadLine, %A_Tab% ; Parse the string based on the tab character.
			{
				; MsgBox, Line contains: %A_LoopReadLine% with field %A_Index% : %A_LoopField%
				choices[choices[COUNT], A_Index] := A_LoopField
			}
			
			; if(starRow) {
				; starRow := false
				; starLen--
			; }
			; sessionsLen++
		}
	}
	
	return title
}

; Gives the height of the given text.
getTextHeight(text) {
	StringReplace, text, text, `n, `n, UseErrorLevel
	lines := ErrorLevel + 1
	
	lineHeight := 17 ; play with this value
	
	height := lines * lineHeight
	; MsgBox % lines " " height
	
	return height
}

; Search both given tables, the visible and the invisible.
searchBoth(ByRef input, table, hiddenTable) {
	; Try the visible choices.
	out := searchTable(input, table)
	if(out) {
		return out
	}
	
	; Try the invisible choices.
	out := searchTable(input, hiddenTable)
	input := "*" . input ; Mark that this is an invisible choice.
	return out
}

; Function to search our generated table for a given index/shortcut.
searchTable(ByRef input, table) {
	; MsgBox, % input . ", " . table[1, NAME] . " " . table[1, PATH]
	
	tableLen := table[COUNT]
	Loop, %tableLen% {
		if(input = A_Index || input = table[A_Index, ABBREV] || input = table[A_Index, NAME]) {
			; MsgBox, Found: %input% at index: %A_Index%
			; foundNum := A_Index
			; action := table[A_Index, PATH]
			input := table[A_Index, ABBREV]
			return table[A_Index, PATH]
		}
	}
	
	return ""
}

; Function to turn the input into something useful.
parseChoice(ByRef userIn, choices, hiddenChoices, historyChoices = "") {
	histCharPos := InStr(userIn, HISTORY_CHAR)
	arbCharPos := InStr(userIn, ARBITRARY_CHAR)
	; MsgBox, % histCharPos

	; HISTORY_CHAR gives us the last executed command.
	if(userIn = HISTORY_CHAR) {
		if(historyChoices[COUNT]) {
			; historyPicked :=  historyChoices[ historyChoices[COUNT] ]
			action := parseChoice(historyChoices[ historyChoices[COUNT] ], choices, hiddenChoices)
		} else {
			MsgBox, No history available!
			ExitApp
		}

	; "+yada" passes in "yada" as an arbitrary, meaninful command.
	} else if(arbCharPos = 1) {
		action := SubStr(userIn, 2)

	; Allow concatentation of arbitrary addition with short.yada or #.yada.
	} else if(arbCharPos > 1) {
		StringSplit, splitBits, userIn, %ARBITRARY_CHAR%
		; MsgBox, % splitBits1 . "	" . splitBits2
		action := searchBoth(splitBits1, choices, hiddenChoices)
		if(action = "") {
			MsgBox, No matches found!
			ExitApp
		}
		action .= splitBits2
		userIn := splitBits1 . ARBITRARY_CHAR . splitBits2 ; Update userIn so that first half of x+y is the shortcut.
		
	; Otherwise, we search through the data structure by both number and shortcut and look for a match.
	} else {
		action := searchBoth(userIn, choices, hiddenChoices)
		
		if(action = "") {
			MsgBox, No matches found!
			ExitApp
		}
	}

	; MsgBox, %action%
	; ExitApp
	
	return action
}

; Function to do what it is we want done, then exit.
doAction(input) {
	global actionType
	
	; MsgBox, % input "`n" actionType
	
	; Run the action.
	if(actionType = "RUN") {
		Run, % input
	
	; Just send the text of the action.
	} else if(actionType = "PASTE") {
		SendRaw, %input%
	
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

; Phone number parsing function.
parsePhone(input) {
	nums := RegExReplace(input, "[^0-9]" , "")
	StringLen, len, nums
	
	; MsgBox, % nums " x " len
	
	if(len=4) ; Old extension.
		return "7"nums
	if(len=5) ; Extension.
		return nums
	if(len=7) ; Normal?
		return nums
	if(len=8) ; I've got nothing...
		return nums
	if(len=10) ; Normal with area code.
		return "81"nums
	if(len=11) ; Normal with area code plus 1 at beginning.
		return "8"nums
	if(len=12) ; Already has everything needs, in theory.
		return nums
	return -1
}
