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
	; Example: A simple input-box that asks for first name and last name:

	Gui, Add, Text,, First name:
	Gui, Add, Text,, Last name:
	Gui, Add, Edit, vFirstName ym  ; The ym option starts a new column of controls.
	Gui, Add, Edit, vLastName
	Gui, Add, Button, default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.
	Gui, Show,, Simple Input Example
	return  ; End of auto-execute section. The script is idle until the user does something.

	GuiClose:
	ButtonOK:
	Gui, Submit  ; Save the input from the user to each control's associated variable.
	MsgBox You entered "%FirstName% %LastName%".
return

^+!t::
	; Get user input.
	FileSelectFile, fileName
	
	; Read in the list of names.
	referenceLines := fileLinesToArray(fileName)
	MsgBox, % arrayToDebugString(referenceLines)
	
	; Parse the list into nice, uniform reference lines.
	references := cleanParseList(referenceLines)
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