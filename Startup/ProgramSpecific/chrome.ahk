sendToOmniboxAndGo(url) {
	Send, ^l
	Sleep, 100
	SendRaw, %url%
	Send, {Enter}
}

#ifWinActive, ahk_class Chrome_WidgetWin_1

	; For easier middle-clicking on bookmarks.
	^MButton::^LButton

	; Bookmarklet hotkeys.
	!`;::sendToOmniboxAndGo("d") ; Darken bookmarklet hotkey.
	$^Right::sendToOmniboxAndGo("+") ; Increment.
	!z::sendToOmniboxAndGo("pz") ; PageZipper.

	; Options hotkey.
	!o::
		Send, !e
		Sleep, 100
		Send, s
	return
	
	; Extensions hotkey.
	^+e::
		Send, !e
		Sleep, 100
		Send, l
		Sleep, 100
		Send, e
		Send, {Enter}
	return

#ifWinActive


; Epic-Specific.
#If WinActive("ahk_class Chrome_WidgetWin_1") && borgWhichMachine = EPIC_DESKTOP

	; Chrome: easy open of file-type links that don't work there.
	$^+RButton::
		tempClipboard := clipboard
		Click, Right
		Sleep, 500
		Send, {Down 5}
		Send, {Enter}
		Sleep, 100
		Run, %clipboard%
		clipboard := tempClipboard
	return

	; Keepass Lastpass-like hotkey.
	$!i::Send, ^+u
	
#If

