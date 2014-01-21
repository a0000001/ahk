#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

#Include commonIncludesStandalone.ahk

; Tray icon setup.
global suspended := 0
v := Object()
v[0] := "suspended"
m := Object()
m[0] := "..\CommonIncludes\Icons\turtle.ico"
m[1] := "..\CommonIncludes\Icons\turtleRed.ico"
setupTrayIcons(v, m)

SetTitleMatchMode RegEx

Loop {
	WinWaitActive, ^C:\\EpicSource\\\d\.\d\\DLG-(\d+)[-\\].* - Commit - TortoiseSVN
	ControlGetText, DLG, Edit2
	if(DLG = "") {
		WinGetActiveTitle, Title
		RegExMatch(Title, "^C:\\EpicSource\\\d\.\d\\DLG-(\d+)[-\\].* - Commit - TortoiseSVN", DLG)
		ControlSend, Edit2, %DLG1%
		Send, {Tab 2}
	}
	
	Sleep, 5000 ; Wait 5 seconds before going again, to reduce idle looping.
}

return

; Hotkey to die.
~^+!#r::
	ExitApp
return

; Suspend hotkey.
~!#x::
	Suspend, Toggle
	suspended := !suspended
	updateTrayIcon()
return