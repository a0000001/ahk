#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

; #Include %A_ScriptDir%\..\Startup\commonIncludesStandalone.ahk
#Include %A_ScriptDir%\..\Startup\
#Include commonIncludes.ahk

commandLineArg = %1%
if(commandLineArg) {
	gitZipUnzip(commandLineArg)
	ExitApp
}

^z::
	gitZipUnzip("z")
	ExitApp
return

^u::
	gitZipUnzip("u")
	ExitApp
return