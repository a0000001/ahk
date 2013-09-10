; Powerpoint hotkeys.
#ifWinActive, ahk_class PPTFrameClass

;j::down
;k::up
MButton & RButton::Send !sc

#ifWinActive


; Powerpoint Slideshow hotkeys.
#ifWinActive, ahk_class screenClass

j::down
k::up
RButton::Send {Up}
MButton & RButton::Send {Esc}

#ifWinActive