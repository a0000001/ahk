; Minimizing shortcut.
$!q::
	if(WinActive("ahk_class TfrmMain")) ; SyncBack
		; OR WinActive("ahk_class TfcForm")) ; FreeCommander
	{
		PostMessage, 0x112, 0xF020
	} else if(WinActive("ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}")) { ; Foobar.
		; WinTraymin()
		PostMessage, 0x112, 0xF020
	; } else if(WinActive("ahk_class TfcForm")) { ; FreeCommander
		; Send, +{Esc}
		; PostMessage, 0x112, 0xF020
		; Send, !{F4}
	} else {
		WinMinimize, A
	}
return

; Sets current window to stay on top
#SPACE::Winset, Alwaysontop, , A

; Minimize to tray. (Via minToTray.)
^!q::WinTraymin()

; Enable any window mouse is currently over.
#!c::
	MouseGetPos,,, WinHndl, CtlHndl, 2
	
	WinGet, Style, Style, ahk_id %WinHndl%
	if (Style & 0x8000000) { ; WS_DISABLED.
		WinSet, Enable,, ahk_id %WinHndl%
	}
	
	WinGet, Style, Style, ahk_id %CtlHndl%
	if (Style & 0x8000000) { ; WS_DISABLED.
		WinSet, Enable,, ahk_id %CtlHndl%
	}
return

; Special closing hotkey
~Escape::
	closeWindowSpecial(0)
return