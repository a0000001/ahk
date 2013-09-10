#ifWinActive, ahk_class SWT_Window0

; Ctrl-tab/Ctrl-shift-tab shortcuts.
^Tab::^PgDn
^+Tab::Send {CTRL Down}{PgUp Down}{PgUp Up}{CTRL Up}

; For cleaning.
^\::Send, !pn

; 
$!p::^!p

#ifWinActive

; Run as something?
; $Enter::
	; if(WinActive("Run As") and WinActive("ahk_class #32770")) {
		; Send, {Down}{Up}{Enter}
	; } else {
		; Send, {Enter}
	; }
; return