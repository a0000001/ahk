﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

; #Include TrayIconToggler.ahk
; #Include ..\Startup\CommonIncludes\tray.ahk
; #Include ..\Startup\CommonIncludes\io.ahk
; #Include test2\test2.ahk
#Include ..\Startup\commonIncludesStandalone.ahk

; #Include stdio.ahk

suspended := 0
v := Object()
m := Object()
v[0] := "suspended"
m[0] := "..\Startup\CommonIncludes\Icons\test.ico"
m[1] := "..\Startup\CommonIncludes\Icons\testSuspended.ico"
setupTrayIcons(v, m)

; Hotkey to open test.ahk for editing.
^+e::
	Run, C:\Program Files (x86)\Notepad++\notepad++.exe A:\Experiments\test.ahk
return

; ----------------------------------------------------------------------------------------------------------------------

^b::
	; RegWrite REG_SZ, HKCR, AutoHotkeyScript\Shell\Debug,, Debug Script
	; RegWrite REG_SZ, HKCR, AutoHotkeyScript\Shell\Debug\Command,, "%A_AhkPath%" /Debug "`%l"
	
	; DetectHiddenWindows, On
	; if(WinExist("ahk_class FreeCommanderXE.SingleInst.1")) {
		; WinActivate
	; }
	
	; SetTitleMatchMode, 2
	
	; test := WinExist("", ["XKESPFEN"])
	
	; SetTitleMatchMode, 1
	
	; MsgBox, % test
	
	; x := 5
	; x += x
	; MsgBox, % x
	
	Send, ^+s
	WinWait, Save As
	
	Send, ..{Enter}
	Sleep, 250
	
	Send, {Tab}p
	Sleep, 100
	
	Send, {Enter}
	Sleep, 100
	
	Send, y
	
	
	Send, {Enter}
	
return

; ^y::
	; MsgBox, % debugBorgReadINI
; return

^+!t::
	; Get user input.
	FileSelectFile, fileName
	
	; Read in the list of names.
	referenceLines := fileLinesToArray(fileName)
	MsgBox, % arrayToDebugString(referenceLines)
	
	; Parse the list into nice, uniform reference lines.
	references := TableList.parse(referenceLines)
	MsgBox, % arrayToDebugString(references, 2)	
return

; ----------------------------------------------------------------------------------------------------------------------

~#!x::
	Suspend
	suspended := !suspended
	updateTrayIcon()
return

; Exit, reload, and suspend.
~!+x::ExitApp
; ~#!x::Suspend
^!r::
~!+r::
	Suspend, Permit
	Reload
return