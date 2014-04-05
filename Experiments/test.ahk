#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

; #Include ..\Startup\commonIncludesStandalone.ahk
borgFolderINI := "..\Startup\"
#Include %A_ScriptDir%\..\Startup\
#Include commonIncludes.ahk

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

; Hotkeys that pop up/copy some useful info about the active window.
F1::
	WinGetClass, currClass, A
	WinGetTitle, currTitle, A
	ControlGetFocus, currControl, A
	DEBUG.popup(1, currClass, "Class", currTitle, "Title", currControl, "Control")
return
F2::
	WinGetClass, currClass, A
	clipboard := currClass
return
F3::
	WinGetTitle, currTitle, A
	clipboard := currTitle
return
F4::
	clipboard := getFocusedControl()
return

; ----------------------------------------------------------------------------------------------------------------------

^b::
	x := 5
	y := 5
	z := 6
	
	MsgBox, % matches(x, y) matches(y, z)
	
	; WinGetClass, test
	; MsgBox, % test
	
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
	
	; Send, ^+s
	; WinWait, Save As
	
	; Send, ..{Enter}
	; Sleep, 250
	
	; Send, {Tab}p
	; Sleep, 100
	
	; Send, {Enter}
	; Sleep, 100
	
	; Send, y
	
	
	; Send, {Enter}
	
return

; ^y::
	; x := Object()
	; x.Insert("5")
	; x.Insert("6")
	; x.Insert("7")
	; x.Insert("8")
	; DEBUG.popup(x, "X")
	; ; MsgBox, % DEBUG.stringMultiHelper(x, "X")
; return

^h::
	; Get user input.
	FileSelectFile, fileName
	
	list := TableList.parseFile(fileName)
	DEBUG.popup(list, "Parsed List")
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