; Disables UAC. Separate because requires admin previledges.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Force just one instance, we don't want muliple of this running around.

; For use of common inclues: Path to precede the borg.ini path.
borgFolderINI := "..\"

; #Include %A_ScriptDir%\..\commonIncludesStandalone.ahk
#Include %A_ScriptDir%\..\
#Include commonIncludes.ahk

runCommand("reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f")

ExitApp

; Hotkey to die.
~^+!#r::
	ExitApp
return