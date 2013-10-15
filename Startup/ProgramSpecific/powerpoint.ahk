; Powerpoint hotkeys.
#ifWinActive, ahk_class PPTFrameClass

;j::down
;k::up
MButton & RButton::Send !sc

; Reading mode - like slideshow, but doesn't fullscreen!
^+r::Send, !wd

#ifWinActive


; Powerpoint Slideshow hotkeys.
#ifWinActive, ahk_class screenClass

j::down
k::up
RButton::Send {Up}
MButton & RButton::Send {Esc}

#ifWinActive