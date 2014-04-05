; Kills the windows update service until restart to kill automatic restarts/nagging.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

borgFolderINI := "Startup\"
#Include %A_ScriptDir%\Startup\..\
#Include commonIncludes.ahk

RunCommand("sc stop wuauserv", true)

ExitApp