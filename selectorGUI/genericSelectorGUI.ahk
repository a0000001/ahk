; (Semi-) Generic standalone script which launches one of many given choices.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

#Include HTTPRequest.ahk

; Constants and such.
global NAME := 1
global ABBREV := 2
global PATH := 3

; height := 152 ; Starting height. Includes prompt, plus extra newline above and below choice list.
height := 105 ; Starting height. Includes prompt, plus extra newline above and below choice list.
sessionsArr := Object() ; Object to hold all the read-in info.
sessionsLen := 1
; starArr := Object()
starLen := -1
extraLines := Object()
extraLen := 1

foundNum := 0
saveEntry := 1

filePath = %1%
actionType = %2%
silentChoice = %3%
fileName := SubStr(filePath, 1, -4)
iconName := fileName ".ico"
lastExecutedFileName := fileName "Last.ini"
; MsgBox, % lastExecutedFileName
; if(silentChoice != "") {
	; MsgBox, % silentChoice
; }

; Set the tray icon based on the input ini filename.
Menu, Tray, Icon, %iconName%

; Read in the various paths, names, and abbreviations.
Loop, Read, %filePath%
{
	; MsgBox, %A_LoopReadLine%
	if(A_Index = 1) {
		title := A_LoopReadLine
	; } else if(A_Index = 2) {
		; prompt := A_LoopReadLine
	} else if(A_LoopReadLine = "" || SubStr(A_LoopReadLine, 1, 1) = ";") { ; Blank line or comment, ignore it.
		; MsgBox, blank
	} else if(SubStr(A_LoopReadLine, 1, 1) = "#") { ; Special: add a title and/or blank row in the list display.
		; MsgBox, #
		if(StrLen(A_LoopReadLine) < 3) { ; If title, #{Space}Title.
			extraLines[sessionsLen] := " "
		} else {
			extraLines[sessionsLen] .= SubStr(A_LoopReadLine, 3)
		}
		
		extraLen++
	} else {
		if(SubStr(A_LoopReadLine, 1, 1) = "*") {
			; MsgBox, It's a star row!
			starRow := true
			sessionsLen-- ; Don't want to leave an empty space in the visible rows.
		}
		
		Loop, Parse, A_LoopReadLine, %A_Tab% ; Parse the string based on the tab character.
		{
			if(starRow) { ; Special case: allow matching on this row, but don't show it. (Generally will be treated as row 0).
				; MsgBox, got a star chunk: %A_LoopField% %starLen%
				sessionsArr[starLen, A_Index] := A_LoopField
			} else {
				; MsgBox, Line contains: %A_LoopReadLine% with field %A_Index% : %A_LoopField%
				sessionsArr[sessionsLen, A_Index] := A_LoopField
			}
		}
		
		if(starRow) {
			starRow := false
			starLen--
		}
		sessionsLen++
	}
}
; MsgBox, % sessionsLen
; MsgBox, % sessionsArr[4, PATH]

; Adjust by one.
sessionsLen--
starLen++
extraLen--


; ----- Get choice. ----- ;


; Allow for a command-line-passed input rather than popping up a GUI.
if(silentChoice != "") {
	userIn := silentChoice
} else {
	; Put the above stuff together.
	displayText := ""
	Loop, %sessionsLen% {
		; Extra newline if requested.
		if(extraLines[A_Index]) {
			if(extraLines[A_Index] != " " && A_Index != 1) {
				displayText .= "`n"
			}
			
			displayText .= extraLines[A_Index]"`n"
		}
		
		displayText .= A_Index ") " sessionsArr[A_Index, ABBREV] ":`t" sessionsArr[A_Index, NAME] "`n"
	}

	; Actually prompt the user.
	height += getTextHeight(displayText)
	InputBox, userIn, %title%, %displayText%, , 400, %height%
	if(ErrorLevel || userIn = "") {
		ExitApp
	}
}



; MsgBox, z%userIn%z



; ----- Parse input to meaningful command. ----- ;

; "." gives us the last executed command.
if(userIn = ".") {
	FileReadLine, recentRun, %lastExecutedFileName%, 1
	; MsgBox, %recentRun%
	if(recentRun) {
		action := recentRun
		saveEntry := 0
	} else {
		MsgBox, No recent item stored!
		ExitApp
	}

; ".yada" passes in "yada" as an arbitrary, meaninful command.
} else if(subStr(userIn, 1, 1) = ".") {
	action := SubStr(userIn, 2)
	; MsgBox, % action

; Otherwise, we search through the data structure by both number and shortcut and look for a match.
} else {
	action := searchTable(sessionsArr, sessionsLen, starLen, userIn)
	
	; MsgBox, % action
	
	if(action = "") {
		MsgBox, No matches found!
		ExitApp
	}
}

; MsgBox, %action%, %saveEntry%
; ExitApp

; Don't save star entries or the previous entry (input of ".").
if(saveEntry) {
	; Remove the old 'last entered' file and stick this one in as the new one.
	; MsgBox, % lastExecutedFileName
	FileDelete, %lastExecutedFileName%
	FileAppend, %action%, %lastExecutedFileName%
}

; So now we have something valid - do it and die.
doAction(action)
return



; Gives the height of the given text.
getTextHeight(text) {
	StringReplace, text, text, `n, `n, UseErrorLevel
	lines := ErrorLevel + 1
	
	lineHeight := 17 ; play with this value
	
	height := lines * lineHeight
	; MsgBox % lines " " height
	
	return height
}

; Function to search our generated table for a given index/shortcut.
searchTable(table, tableLen, starLen, input) {
	global saveEntry
	; MsgBox, % input . ", " . table[1, NAME] . " " . table[1, PATH]
	
	; First try the normal, visible entries.
	Loop, %tableLen% {
		if(input = A_Index || input = table[A_Index, ABBREV] || input = table[A_Index, NAME]) {
			; MsgBox, Found: %input% at index: %A_Index%
			; foundNum := A_Index
			; action := table[A_Index, PATH]
			return table[A_Index, PATH]
		}
	}
	
	; Try the star entries if you didn't find it above.
	tempLen := -starLen
	Loop, %tempLen% {
		idx := -A_Index
		; MsgBox, % input " " idx " " table[idx, ABBREV] " " table[idx, NAME]
		if(input = idx || input = table[idx, ABBREV] || input = table[idx, NAME]) {
			; MsgBox, Star Found: %input% at index: %A_Index%
			; foundNum := idx
			; action := table[idx, PATH]
			saveEntry := 0
			return table[idx, PATH]
		}
	}
	
	return ""
}

; Function to do what it is we want done, then exit.
doAction(input) {
	global actionType
	
	; MsgBox, % input "`n" actionType
	
	if(actionType = "RUN") {
		Run, % input
	} else if(actionType = "PASTE") {
		SendRaw, %input%
	} else if(actionType = "CALL") {
		
		URL := "http://guru/services/Webdialer.asmx/"
		
		if(input = "-") {
			; MsgBox, Hanging up current call.
			URL .= "HangUpCall?"
			MsgText = Hanging up current call. `n`nContinue?
		} else {
			; MsgBox, Calling %input%...
			phoneNum := parsePhone(input)
			
			if(phoneNum = -1) {
				return
			}
			
			URL .= "CallNumber?extension=" . phoneNum
			MsgText = Calling: `n`n%input% `n[%phoneNum%] `n`nContinue?
		}
		
		MsgBox, 4,, %MsgText%
		IfMsgBox No
			ExitApp
		
		; MsgBox, % URL
		; URL := "http://guru/services/Webdialer.asmx/CallNumber?extension=813015291674"
		
		; MsgBox, URL: %URL%
		
		; httpQuery(html, URL) ; Utter, miserable failure.
		; Run, http://guru/services/Webdialer.asmx/CallNumber?extension=813015291674 ; Works, but pops up the response in browser.
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
