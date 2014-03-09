; Activate/Launch/Minimize Hotkeys.

#SingleInstance force
#NoTrayIcon

; For use of common inclues: Path to precede the borg.ini path.
borgFolderINI := "..\"
#Include %A_ScriptDir%\..\
#Include commonIncludes.ahk

programToLaunch = %1%

; Slap the given string onto the end of our variable base to make the full variable
programClass := "pLaunchClass_"programToLaunch
programPath := "pLaunchPath_"programToLaunch

activateOpenMinimize(%programClass%, %programPath%)

ExitApp

; Hotkey to die.
~^+!#r::
	ExitApp
return