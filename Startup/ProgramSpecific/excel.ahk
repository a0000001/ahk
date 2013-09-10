; Excel hotkeys.
#ifWinActive, ahk_class XLMAIN

; Auto-fix column width 
^+w::
	Send !h
	Send o
	Send i
return

#ifWinActive