; Generic standalone script which launches one of many given choices.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

; Constants and such.
ROW_HEIGHT := 18 ; Height to add per row of text.
NAME := 1
ABBREV := 2
PATH := 3

height := 152 ; Starting height. Includes prompt, plus extra newline above and below choice list.
sessionsArr := Object() ; Object to hold all the read-in info.
sessionsLen := 1

; Read in the various paths, names, and abbreviations.
Loop, Read, %1%
{
	; MsgBox, %A_LoopReadLine%
	if(A_Index = 1) {
		title := A_LoopReadLine
	} else if (A_Index = 2) {
		prompt := A_LoopReadLine
	} else if(A_LoopReadLine = "") {
		; Blank line, ignore it.
		; MsgBox, blank
	} else {
		Loop, Parse, A_LoopReadLine, %A_Tab% ; Parse the string based on the tab character.
		{
			; MsgBox, Line contains: %A_LoopReadLine% with field %A_Index% : %A_LoopField%
			sessionsArr[sessionsLen, A_Index] := A_LoopField
		}
		sessionsLen++
	}
}
; MsgBox, % sessionsLen
; MsgBox, % sessionsArr[4, PATH]

sessionsLen--

; Put the above stuff together.
displayText := prompt "`n`n"
Loop, %sessionsLen% {
	displayText := displayText A_Index ") " sessionsArr[A_Index, ABBREV] ":`t" sessionsArr[A_Index, NAME] "`n"
	height := height + ROW_HEIGHT
}

; MsgBox, % displayText
InputBox, userIn, %title%, %displayText%, , 400, height

if(userIn = "" || ErrorLevel) {
	ExitApp
}

; MsgBox, %userIn%

; Figure out if what they gave us matches anything.
foundNum := -1
Loop, %sessionsLen% {
	if(userIn = A_Index || userIn = sessionsArr[A_Index, ABBREV] || userIn = sessionsArr[A_Index, NAME]) {
		; MsgBox, Found: %userIn% at index: %A_Index%
		foundNum := A_Index
		break
	}
}

if(foundNum = -1) {
	MsgBox, No matches found!
	ExitApp
}

; So now we have a match - launch it!
Run, % sessionsArr[foundNum, PATH]

