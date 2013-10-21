; Input change/fixing functions.

#If borgWhichMachine = EPIC_DESKTOP
	; For ergonomic keyboard.
	browser_back up::
		; Send, {Media_Prev}
		Click
	return
	browser_forward up::
		; Send, {Media_Next}
		Click, Right
	return

	browser_back::
	browser_forward::
		return
	; XButton1::
	; XButton2::
		; return
	
	; For ergonomic mouse. 1 is closer to me.
	XButton1::
		Send, {Media_Play_Pause}
	return
	XButton2::
		Send, {Browser_Favorites}
	return
	
	; Hotkey to fix one-spot-too-late spaces.
	; ^Space::Send, {Left}{Ctrl Down}{Left}{Ctrl Up}{Backspace}{Left}{Space}{Ctrl Down}{Right}{Ctrl Up}

#If