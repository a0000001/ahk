; Powerpoint hotkeys.
#IfWinActive, ahk_class PPTFrameClass

;j::down
;k::up
MButton & RButton::Send !sc

; Reading mode - like slideshow, but doesn't fullscreen!
^+r::Send, !wd

RButton::
	wID := WinActive("PowerPoint Slide Show - [")
	MouseGetPos, , , currWin
	if(wID = currWin) {
		Send, {Down}
	} else {
		Click, Right
	}
return
LButton::
	wID := WinActive("PowerPoint Slide Show - [")
	MouseGetPos, , , currWin
	if(wID = currWin) {
		Send, {Up}
	} else {
		Click, Left
	}
return

#IfWinActive


; Powerpoint Slideshow hotkeys.
#IfWinActive, ahk_class screenClass

j::down
k::up
LButton::Send {Up}
RButton::Send {Down}
MButton & RButton::Send {Esc}

#IfWinActive
