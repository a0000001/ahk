#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
#SingleInstance force

if(%0%) {
	folderPath = %1%
}

If(WinExist("ahk_class TfcForm")) {
	WinActivate, ahk_class TfcForm
	Send, ^t
}

Run, C:\Program Files\FreeCommander\FreeCommander.exe /C /L="%folderPath%"