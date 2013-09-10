#ifWinActive, ahk_class mintty

^+l::
	Send, {Enter}
	Sleep, 1
	Send, !{F8}
	Send, {Enter}
return

#ifWinActive