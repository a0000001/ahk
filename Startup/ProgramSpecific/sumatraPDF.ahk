#ifWinActive, ahk_class SUMATRA_PDF_FRAME

; Bookmarks panel.
^b::Send {F12}

; Surfkeys-like navigation.
`;::Send {PgDn}
p::Send {PgUp}

; Show/hide toolbar.
^/::
	Send, !v
	Sleep, 100
	Send, t
return

; Show/hide favorites.
$F11::
^e::
	Send, !a
	Sleep, 100
	Send, {Down 2}
	Send, {Enter}
return

; Retain fullscreening ability.
!Enter::
	Send, {F11}
return

; Kill unconventional hotkey to quit.
^q::Return

#ifWinActive