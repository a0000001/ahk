; Media-related hotkeys.

#If borgWhichMachine = EPIC_DESKTOP

	; Make keyboard mute/pause buttons be change tracks.
	Media_Play_Pause::return
	Media_Play_Pause Up::Send, {Media_Next}
	Volume_Mute::Send, {Media_Prev}

	; ; Ergonomic keyboard: middle wheel slider.
	; ^NumpadAdd::
	; ^WheelUp::
		; Send, {Browser_Favorites}
	; return
	; ^NumpadSub::
	; ^WheelDown::
		; Send, {Media_Play_Pause}
	return

#If