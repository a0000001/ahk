;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

; Kills all ahk scripts (for when they're glitched.)
!+#r::
	myID := DllCall("GetCurrentProcessId")
	ahkID = Process, Exist, AutoHotkey.exe
	while ahkID != 0{
		if(ahkID == %myID%)
		{
			Reload ; puts this process as the last of all of the AHK scripts, so it can finish killing all others before it kills itself.
		}
		Process, Close, AutoHotkey.exe
		ahkID = Process, Exist, AutoHotkey.exe
	}
return