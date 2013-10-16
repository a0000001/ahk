; (Semi-) Generic standalone script which launches one of many given choices.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

#Include httpQuery.ahk

; Constants and such.
ROW_HEIGHT := 18 ; Height to add per row of text.
NAME := 1
ABBREV := 2
PATH := 3

height := 152 ; Starting height. Includes prompt, plus extra newline above and below choice list.
sessionsArr := Object() ; Object to hold all the read-in info.
sessionsLen := 1
; starArr := Object()
starLen := -1

filePath = %1%
actionType = %2%
StringTrimRight, lastExecutedFileName, filePath, 4
lastExecutedFileName := lastExecutedFileName . "Last.ini"

; Read in the various paths, names, and abbreviations.
Loop, Read, %filePath%
{
	; MsgBox, %A_LoopReadLine%
	if(A_Index = 1) {
		title := A_LoopReadLine
	} else if(A_Index = 2) {
		prompt := A_LoopReadLine
	} else if(A_LoopReadLine = "" || SubStr(A_LoopReadLine, 1, 1) = ";") { ; Blank line or comment, ignore it.
		; MsgBox, blank
	} else {
		if(SubStr(A_LoopReadLine, 1, 1) = "*") {
			; MsgBox, It's a star row!
			starRow := true
			sessionsLen-- ; Don't want to leave an empty space in the visible rows.
		}
		
		Loop, Parse, A_LoopReadLine, %A_Tab% ; Parse the string based on the tab character.
		{
			if(starRow) { ; Special case: allow matching on this row, but don't show it. (Generally will be treated as row 0).
				; MsgBox, got a star chunk: %A_LoopField%
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

; Put the above stuff together.
displayText := prompt "`n`n"
Loop, %sessionsLen% {
	displayText := displayText A_Index ") " sessionsArr[A_Index, ABBREV] ":`t" sessionsArr[A_Index, NAME] "`n"
	height := height + ROW_HEIGHT
}

; Actually prompt the user.
; MsgBox, % displayText
InputBox, userIn, %title%, %displayText%, , 400, height
if(ErrorLevel || userIn = "") {
	ExitApp
}

; Special case: if "." was entered, execute last-executed command instead.
if(userIn = ".") {
	FileReadLine, recentRun, %lastExecutedFileName%, 1
	; MsgBox, %recentRun%
	if(recentRun) {
		doAction(recentRun)
	} else {
		MsgBox, No recent item stored!
	}
	
	ExitApp
}

; MsgBox, %userIn%

; Figure out if what they gave us matches anything.
foundNum := 0
Loop, %sessionsLen% {
	if(userIn = A_Index || userIn = sessionsArr[A_Index, ABBREV] || userIn = sessionsArr[A_Index, NAME]) {
		; MsgBox, Found: %userIn% at index: %A_Index%
		foundNum := A_Index
		break
	}
}

; MsgBox, % foundNum

; Try the star entries if you didn't find it above.
if(foundNum = 0) {
	tempLen := -starLen
	Loop, %tempLen% {
		idx := -A_Index
		; MsgBox, % userIn " " idx " " sessionsArr[idx, ABBREV] " " sessionsArr[idx, NAME]
		if(userIn = idx || userIn = sessionsArr[idx, ABBREV] || userIn = sessionsArr[idx, NAME]) {
			; MsgBox, Star Found: %userIn% at index: %A_Index%
			foundNum := idx
			break
		}
	}
}

if(foundNum = 0) {
	MsgBox, No matches found!
	ExitApp
}

action := sessionsArr[foundNum, PATH]

if(foundNum > 0) {
	; Remove the old 'last entered' file and stick this one in as the new one.
	; MsgBox, % lastExecutedFileName
	FileDelete, %lastExecutedFileName%
	FileAppend, %action%, %lastExecutedFileName%
}
	
; So now we have a match - do it and die.
doAction(action)
ExitApp



; Function to do what it is we want done, then exit.
doAction(input) {
	global actionType
	
	; MsgBox, % input "`n" actionType
	
	if(actionType = "RUN") {
		Run, % input
	} else if(actionType = "PASTE") {
		SendRaw, %input%
	} else if(actionType = "CALL") {
		if(input = "-") {
			; MsgBox, Hanging up current call.
			URL :="http://guru/services/Webdialer.asmx/HangUpCall?"
			MsgText = Hanging up current call. `n`nContinue?
		} else {
			; MsgBox, Calling %input%...
			phoneNum := parsePhone(input)
			
			if(phoneNum = -1) {
				return
			}
			
			URL := "http://guru/services/Webdialer.asmx/CallNumber?extension=" . phoneNum
			MsgText = Calling: `n`n%input% `n[%phoneNum%] `n`nContinue?
		}
		
		MsgBox, 4,, %MsgText%
		IfMsgBox No
			ExitApp
		
		MsgBox, % URL
		; httpQuery(html, URL)
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
