#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

; #Include TrayIconToggler.ahk
#Include ..\Startup\CommonIncludes\trayTools.ahk

suspended := 0
v := Object()
m := Object()
v[0] := "suspended"
m[0] := "..\Startup\CommonIncludes\Icons\test.ico"
m[1] := "..\Startup\CommonIncludes\Icons\testSuspended.ico"
setupTrayIcons(v, m)

~#!x::
	Suspend
	suspended := !suspended
	updateTrayIcon()
return

; Exit, reload, and suspend.
~!+x::ExitApp
; ~#!x::Suspend
~!+r::
	Suspend, Permit
	Reload
return

; ----------------------------------------------------------------------------------------------------------------------

^a::

; return

; CapsLock::Pause

; CapsLock::RButton
	; x = 1
	; while(x < 5) {
		; MsgBox, %A_Index%	
		; x++
	; }
	
	; ; MsgBox, % suspended
	; ; suspended := !suspended
	; Send, {Delete 2}
	SendRaw, *
	Send, {Space}{End}{Delete}{Enter}{Home}{Down}
; return

^d::
	Send, {End}{Enter}{Tab}A{Backspace}
return

$^b::
	Send, {Home}{Shift Down}{End}{Shift Up}^b{Down}{Home}
	
	; ControlGetText, test, WindowsForms10.Window.8.app.0.2bf8098_r13_ad160
	; MsgBox, % test
	
	; a := Object()
	; a[1] := "asdf"
	; testFunc(a)

	; a["01"] := 1
	; ; testObj["1"] := Object()
	
	; a["1", "a"] := "z"

	; ; MsgBox, % testObj["01"]
	; MsgBox, % a["1", "a"]
	
	; filePath := "blahBlahBlah.ini"
	; lastFilePath := SubStr(filePath, 1, -4) "Last.ini"
	; MsgBox, % lastFilePath
return

; testFunc(obj) {
	; MsgBox, % obj[1]
; }


