; Input change/fixing functions.

; Executor normally uses CapsLock, but (very) occasionally, we need to use it for its intended purpose.
^!CapsLock::
	SetCapsLockState, On
return

; Numpad comma.
$NumLock::
	if(GetKeyState("NumLock", "T")) {
		Send, ,
	} else {
		SetNumLockState, On
	}
return

; Reflections/text don't play nice with this.
#IfWinNotActive, ahk_class r2Window	
	+NumLock::
		SetNumLockState, Off
	return
#IfWinNotActive

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
		Send, {Browser_Favorites}
	return
	XButton2::
		Send, {Media_Play_Pause}
	return
	
	; Hotkey to fix one-spot-too-late spaces.
	; ^Space::Send, {Left}{Ctrl Down}{Left}{Ctrl Up}{Backspace}{Left}{Space}{Ctrl Down}{Right}{Ctrl Up}

#If