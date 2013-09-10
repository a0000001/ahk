; Word hotkeys.
#ifWinActive, ahk_class OpusApp

; ; Word count
; ^+w::
	; Send !r
	; Send w
; return

; draw line
^+l::
	MouseGetPos, xPrevi, yPrevi
	Click down, 55, 85
	Sleep, 500
	Click up, 55, 85
	MouseMove, xPrevi, yPrevi
return

; Save as, ctrl shift s.
^+s::
	Send !fa
return

; Open last opened docs: continues after first, thru 9th.
^+t::
	Send !f
	Send {%incrementor%}
	incrementor+=1
	if (CurrentSetting >= 10)
		incrementor = 1
return

^+z:: Send ^y

#ifWinActive