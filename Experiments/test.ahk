#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force


; setupTrayIcon("..\Startup\CommonIncludes\Icons\turtle.ico", "..\Startup\CommonIncludes\Icons\turtleRed.ico", "suspended")

; Exit, reload, and suspend.
!+x::ExitApp
; ~#!x::Suspend
~!+r::
	Suspend, Permit
	Reload
return

; ----------------------------------------------------------------------------------------------------------------------

^a::
	a := Object()
	a[1] := "asdf"
	testFunc(a)

	; a["01"] := 1
	; ; testObj["1"] := Object()
	
	; a["1", "a"] := "z"

	; ; MsgBox, % testObj["01"]
	; MsgBox, % a["1", "a"]
	
	; filePath := "blahBlahBlah.ini"
	; lastFilePath := SubStr(filePath, 1, -4) "Last.ini"
	; MsgBox, % lastFilePath
return

testFunc(obj) {
	MsgBox, % obj[1]
}


; #Include SetupTrayIcon.ahk