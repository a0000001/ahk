#ifWinActive, ahk_class Chrome_WidgetWin_1

	; For easier middle-clicking on bookmarks.
	^MButton::^LButton

	; Darken bookmarklet hotkey.
	!`;::
		Send, ^l
		Sleep, 100
		Send, d
		Sleep, 100
		Send, {Enter}
	return

	; Increment bookmarklet hotkey.
	^Down::
		Send, ^l
		Sleep, 100
		SendRaw, +
		Sleep, 100
		Send, {Enter}
	return

	; Options hotkey.
	!o::
		Send, !e
		Send, s
	return
	
	; Extensions hotkey.
	^+e::
		Send, !e
		Send, l
		Send, e
		Send, {Enter}
	return

#ifWinActive


; Epic-Specific.
#If borgWhichMachine = EPIC_DESKTOP && WinActive("ahk_class Chrome_WidgetWin_1")

	; Chrome: easy open of file-type links that don't work there.
	$^+RButton::
		Click, Right
		Sleep, 500
		Send, {Down 5}
		
		Send, {Enter}
		Sleep, 100
		
		Run, %clipboard%
	return

	$!i::Send, ^+u
	
#If

