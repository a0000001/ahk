; === Beginning of hotkeys, all auto-executing portions are done. === ;

; Hotkey for reloading entire script.
!+r::
	Suspend, Permit
	Reload
return

; Suspend hotkey, change tray icon too.
!#x::
	Suspend, Toggle
	suspended := !suspended
	updateTrayIcon()
	; Suspend
	; if(activeTrayIcon) {
		; Menu, Tray, Icon, %borgIconPathStopped%
		; activeTrayIcon := false
	; } else {
		; Menu, Tray, Icon, %borgIconPath%
		; activeTrayIcon := true
	; }
return

; ; Emergency Exit (for use when VirtualBox joins forces with altdrag, sticks, and freaks out)
; !+#r::
; *^PrintScreen::
	; Process, Close, emailReminder.exe
	; ExitApp
; return

; ; Attempt at fixing stuck modifier issues.
; *^Pause::
	; Send {RControl Down}{LControl Up}{RControl Up}{LShift Up}{RShift Up}{LWin Up}{LAlt Up}{RAlt Up}
; return