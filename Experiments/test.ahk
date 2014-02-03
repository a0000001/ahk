#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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
	; arr0 := "a"
	; arr1 := ["b"]
	; arr2 := ["a", "b", "c"]
	; arr3 := [["z", "y", "x"], ["w", "v", "u"], ["t", "s", "r"]]
	; arr4 := [ [ ["z", "y", "x"], ["w", "v", "u"], ["t", "s", "r"] ], [["z", "y", "x"], ["w", "v", "u"], ["t", "s", "r"]], [["z", "y", "x"], ["w", "v", "u"], ["t", "s", "r"]]]
	
	; Run, C:\Program Files (x86)\Attachmate\Reflection\r2win.exe /VBA ".ConnectionType = ""SECURE SHELL"" " /VBA ".ConnectionSettings = ""Host epic-cde UserName gborg"" " /VBA ".Connect" /VBA "Call .RunMacroFile(""G:\Desktop\genericLoginMacro.rma"")" /S G:\Desktop\Text\latestSettings.r2w /NOCONNECT
	
	; RunAsAdmin()
	; Run, C:\Windows\System32\cmd.exe /C tsdiscon
	
	; RunCommand("tsdiscon")
	
	; Run, C:\Windows\System32\cmd.exe /C tsdiscon
return

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