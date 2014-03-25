#IfWinActive, ahk_class SWT_Window0
	; Ctrl-tab/Ctrl-shift-tab shortcuts.
	^Tab::^PgDn
	^+Tab::Send {CTRL Down}{PgUp Down}{PgUp Up}{CTRL Up}

	; For cleaning.
	^\::Send, !pn
#IfWinActive