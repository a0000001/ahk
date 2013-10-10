#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

FileSelectFile, fileName

; Read in the various paths, names, and abbreviations.
Loop, Read, %fileName%
{
	; MsgBox, %A_LoopReadLine%
	Click, 160, 214
	Sleep, 100
	
	; WinGetPos, X, Y, W, H, A
	; ImageSearch, outX, outY, X, Y, W, H, G:\ahk\Images\emc2NewServerObject.png
	; MsgBox, % outX " " outY
	
	StringSplit, outArr, A_LoopReadLine, %A_Tab%
	ObjectName := outArr1
	SpecialName := outArr2
	
	; MsgBox, % ObjectName " x " SpecialName
	
	; Enter needed small creation popup information.
	SendRaw, %ObjectName%
	Send, {Tab 2}
	SendRaw, Clarity Column for %SpecialName%.
	Send, {Tab}
	SendRaw, Clarity Column: %SpecialName%
	Send, !r
	
	; Enter needed fields in the full content entry screen.
	Sleep, 100
	Send, {Tab 4}
	Send, Train
	Send, !a
	Send, !c
	
	Sleep, 100
	
	ExitApp
}