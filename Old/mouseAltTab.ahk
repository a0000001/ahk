; Phased into explorer.ahk

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
#SingleInstance force
/*
; Alt-tab mouse mods
;~MButton & WheelDown::
~LControl & WheelUp::  ; Scroll left.
	altTabbed = 1
	Send {LAlt Down}{Shift Down}
	Send {Tab}
return

~RButton & WheelDown::
	altTabbed = 1
	Send {LAlt Down}
	Send {Tab}
return

~RButton::
	if(altTabbed = 1)
	{
		altTabbed = 0
		Send {LAlt Up}
		Send {Enter}
	}
return
*/






; Final version:
RButton & WheelDown::AltTab
RButton & WheelUp::ShiftAltTab

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload