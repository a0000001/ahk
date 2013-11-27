SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force  ; Ensures that if this script is running, running it again replaces the first instance.
; #NoTrayIcon  ; Uncomment to hide the tray icon.

#Include ..\Startup\commonIncludesStandalone.ahk


; ; Note to self: could potentially start doing this using selector-type, or even modified selector, logic.

^+l::
	text := getSelectedText()
	; MsgBox, Selected Text: %text%
	
	; Drop any leading whitespace.
	cleanText = %text%
	
	; Only react if we're within our list of allowed INIs.
	ini := SubStr(cleanText, 1, 3)
	num := SubStr(cleanText, 5)
	
	; Right now using silentChoice and a bit of hackish logic - fix.
	link := select("emc2link.ini", "RETURN", ini, 1) num "?action=EDIT"
	; MsgBox, % link
	
	if(WinActive("ahk_class rctrl_renwnd32")) { ; Outlook.
		Send, ^k
		WinWait, Insert Hyperlink, , 2
		Sleep, 100
		if(ErrorLevel) {
			MsgBox, Couldn't find Insert Hyperlink window!
		} else {
			SendRaw, %link%
			Send, {Enter}
		}
	} else { ; Just output in form: "XXX ###### (emc2://TRACK/XXX/######?action=EDIT)"
		Send, %text%{Space}
		SendRaw, (%link%) 
	}
return

; Exit, reload, and suspend.
~!+x::ExitApp
~#!x::Suspend
~^!r::
	Suspend, Permit
	Reload
return