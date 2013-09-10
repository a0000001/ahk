; Minimizing shortcut.
$!q::minimizeWindowSpecial()

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