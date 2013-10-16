#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

; Exit, reload, and suspend.
!+x::ExitApp
~#!x::Suspend
~!+r::
	Suspend, Permit
	Reload
return

; --------------------------------------------------------------------------------------------------------------------------------------------

^a::
	testObj := Object()

	testObj[-1] := 5

	MsgBox, % testObj[-1]
return