; Powerpoint hotkeys.

#IfWinActive, ahk_class PPTFrameClass
	;j::down
	;k::up
	MButton & RButton::Send !sc

	; Reading mode - like slideshow, but doesn't fullscreen!
	^+r::Send, !wd

	RButton::
		if(WinActive("PowerPoint Slide Show - [")) {
			Send, {Up}
		} else {
			Click, Right
		}
		; wID := WinActive("PowerPoint Slide Show - [")
		; MouseGetPos, , , currWin
		; if(wID = currWin) {
			; Click, Left
		; } else {
			; Click, Right
		; }
	return
	; LButton::
		; wID := WinActive("PowerPoint Slide Show - [")
		; MouseGetPos, , , currWin
		; if(wID = currWin) {
			; Send, {Up}
		; } else {
			; Click, Left
		; }
	; return
#IfWinActive


; Powerpoint Slideshow hotkeys.
#IfWinActive, ahk_class screenClass
	j::down
	k::up
	RButton::Send {Up}
	MButton & RButton::Send {Esc}
#IfWinActive
