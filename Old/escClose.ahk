; #NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

#include %A_ScriptDir%\Includes\specialClose.ahk

; Special closing hotkey
~Escape::
	closeWindowSpecial(0)
return