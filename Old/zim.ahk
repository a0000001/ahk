#ifWinActive, ahk_class gdkWindowToplevel

; Sub- and Super-script shortcuts.
^+-::
	Send, !m
	Send, {Up}{Up}{Up}
	Send, {Enter}
return
^+=::
	Send, !m
	Send, {Up}{Up}
	Send, {Enter}
return

#ifWinActive