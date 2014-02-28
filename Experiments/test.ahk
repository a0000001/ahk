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
	x := ["a", "b", "c", "d"]
	
	DEBUG.popup(1, x, "x")
	
	x.insert(2, "e")
	
	DEBUG.popup(1, x, "x")
	
	; Send, ^c
	; clipboard := "a"
	; Send, ^c
	; clipboard := "b"
	
	; x := "as""sd"
	; MsgBox, % x
	
	; arr0 := "a"
	; arr1 := ["b"]
	; arr2 := ["a", "b", "c"]
	; arr3 := [["z", "y", "x"], ["w", "v", "u"], ["t", "s", "r"]]
	; arr4 := [ [ ["z", "y", "x"], ["w", "v", "u"], ["t", "s", "r"] ], [["z", "y", "x"], ["w", "v", "u"], ["t", "s", "r"]], [["z", "y", "x"], ["w", "v", "u"], ["t", "s", "r"]]]
	
	; vbStr = /VBA ".ConnectionType = ""SECURE SHELL"" " /VBA ".ConnectionSettings = ""Host epic-cde UserName gborg"" " /VBA ".Connect" /VBA "Call .RunMacroFile(""G:\Desktop\genericLoginMacro.rma"")"
	
	; vbStr2 := "/VBA "".ConnectionType = """"SECURE SHELL"""" "" "
	; vbStr2 .= "/VBA "".ConnectionSettings = """"Host epic-cde UserName gborg"""" "" "
	; vbStr2 .= "/VBA "".Connect"" "
	; vbStr2 .= "/VBA ""Call .RunMacroFile(""""G:\Desktop\genericLoginMacro.rma"""")"" "
	
	; ;/VBA 
	; vbStr3 := []
	; vbStr3.insert(".ConnectionType = ""SECURE SHELL"" ")
	; vbStr3.insert(".ConnectionSettings = ""Host epic-cde UserName gborg"" ")
	; vbStr3.insert(".Connect")
	; vbStr3.insert("Call .RunMacroFile(""G:\Desktop\genericLoginMacro.rma"")")
	
	; vbStr4 := quoteWrapArrayDouble(vbStr3)
	
	; vbStr5 := ""
	; For i,v in vbStr4 {
		; vbStr5 .= "/VBA " v " "
	; }
	
	; vbStr6 := arrayToString(vbStr4, true, "/VBA ")
	
	; vbStr7 := ["a"
				; , "b"
				; , "c"]
				
	; vbStr8 := arrayToString(quoteWrapArrayDouble([	".ConnectionType = ""SECURE SHELL"" "
	; ,				".ConnectionSettings = ""Host epic-cde UserName gborg"" "
	; ,				".Connect"
	; ,				"Call .RunMacroFile(""G:\Desktop\genericLoginMacro.rma"")"]), true, "/VBA ")
	
	; vbStr9 := [	".ConnectionType = ""SECURE SHELL"" "
	; ,				".ConnectionSettings = ""Host epic-cde UserName gborg"" "
	; ,				".Connect"
	; ,				"Call .RunMacroFile(""G:\Desktop\genericLoginMacro.rma"")"]
	; vbStr9 := quoteWrapArrayDouble(vbStr9)
	; vbStr9 := arrayToString(vbStr9, true, "/VBA ")
	
	
	; ; For i,v in vbStr3 {
		; ; v := """" escapeDoubleQuotes(v) """"
		; ; vbStr4.insert(v)
	; ; }
	
	; DEBUG.popup(1, vbStr, "1", vbStr2, "2", vbStr3, "3", vbStr4, "4", vbStr5, "5", vbStr6, "6", vbStr7, "7", vbStr8, "8", vbStr9, "9")
	
	; ; MsgBox, % vbStr "`n`n" vbStr2
	
	; ; Run, C:\Program Files (x86)\Attachmate\Reflection\r2win.exe /VBA ".ConnectionType = ""SECURE SHELL"" " /VBA ".ConnectionSettings = ""Host epic-cde UserName gborg"" " /VBA ".Connect" /VBA "Call .RunMacroFile(""G:\Desktop\genericLoginMacro.rma"")" /S G:\Desktop\Text\latestSettings.r2w /NOCONNECT
	; Run, C:\Program Files (x86)\Attachmate\Reflection\r2win.exe %vbStr6% /S G:\Desktop\Text\latestSettings.r2w /NOCONNECT
	
	; ; RunAsAdmin()
	; ; Run, C:\Windows\System32\cmd.exe /C tsdiscon
	
	; ; RunCommand("tsdiscon")
	
	; ; Run, C:\Windows\System32\cmd.exe /C tsdiscon
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