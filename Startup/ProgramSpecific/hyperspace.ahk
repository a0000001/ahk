#If WinActive("ahk_class ThunderRT6MDIForm") || WinActive("ahk_class ThunderRT6FormDC")

	; TLG Hotkey.
	^t::
		Send, %epicID%
	return

#IfWinActive