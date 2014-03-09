#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

; For use of common inclues: Path to precede the borg.ini path.
borgFolderINI := "..\Startup"
#Include %A_ScriptDir%\..\Startup\
#Include commonIncludes.ahk

commandLineArg = %1%
if(commandLineArg) {
	differences := gitZipUnzip(commandLineArg)
	if(differences.maxIndex()) {
		outStr := "AHK zipfiles that have changed: `n"
		For i,d in differences
			outStr .= "`t" d "`n"
		MsgBox, % outStr
	}
	
	ExitApp
	
	; DEBUG.popup(1, , "Results")
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