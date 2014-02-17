; Minimizing shortcut.
$!q::minimizeWindowSpecial()

; Sets current window to stay on top
#SPACE::Winset, Alwaysontop, , A

; ; Minimize to tray. (Via minToTray.)
; ^!q::WinTraymin()

; Enable any window mouse is currently over.
#c::
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
	KeyWait, Esc, T1 ; Ensures that we don't have fall-through window closing.
return

; On computer lock, black out screen.
#l::
	Sleep, 100
	SendMessage, 0x112, 0xF170, 2,, Program Manager	; Kill screen.
	; No lock needed, windows has got it.
return

; ; Special computer lock: black out screen, pause music.
; #!l::
	; Sleep, 100
	; SendMessage, 0x112, 0xF170, 2,, Program Manager	; Kill screen.
	; Run, C:\Program Files (x86)\foobar2000\foobar2000.exe /pause	; Pause foobar.
	; DllCall("LockWorkStation")	; Lock workstation.
; return

; ; Super-special computer lock: black out screen, mute, and stop music.
; #!^l::
	; Sleep, 100
	; SendMessage, 0x112, 0xF170, 2,, Program Manager	; Kill screen.
	; VA_SetMasterMute(1)	; Mute.
	; Run, C:\Program Files (x86)\foobar2000\foobar2000.exe /stop	; Stop foobar.
	; ; DllCall("LockWorkStation")	; Lock workstation.
; return

#w::
	Sleep, 5000
	SendMessage, 0x112, 0xF170, 2,, Program Manager
return