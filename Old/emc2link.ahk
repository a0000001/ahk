; Moved and improved into hyperspace.ahk.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force  ; Ensures that if this script is running, running it again replaces the first instance.
; #NoTrayIcon  ; Uncomment to hide the tray icon.

#Include ..\Startup\commonIncludesStandalone.ahk

debugOn := true

; Generic linker - will allow coming from clipboard or selected text, or input entirely.
^+!l::
	; Grab the selected text/clipboard.
	text := getSelectedText(true)
	DEBUG.popup(text, "Silent Choice:", debugOn)
	
	; Drop any leading whitespace.
	cleanText = %text%
	
	; Grab the INI.
	ini := SubStr(cleanText, 1, 3)
	
	; Allow of form XXX 123456 or XXX123456.
	if(SubStr(cleanText, 4, 1) = A_Space)
		num := SubStr(cleanText, 5)
	else
		num := SubStr(cleanText, 4)
	
	; Get the link.
	link := generateEMC2ObjectLink(true, ini, num, "emc2link.ini")
	DEBUG.popup(link, "Generated Link:", debugOn)
	
	; if(WinActive("ahk_class rctrl_renwnd32")) { ; Outlook.
		; Send, ^k
		; WinWait, Insert Hyperlink, , 2
		; Sleep, 100
		; if(ErrorLevel) {
			; MsgBox, Couldn't find Insert Hyperlink window!
		; } else {
			; SendRaw, %link%
			; Send, {Enter}
		; }
	; } else { ; Just output in form: "XXX ###### (emc2://TRACK/XXX/######?action=EDIT)"
		; Send, %text%{Space}
		; SendRaw, (%link%) 
	; }
return

; Exit, reload, and suspend.
~!+x::ExitApp
~#!x::Suspend
~^!r::
	Suspend, Permit
	Reload
return