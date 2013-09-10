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