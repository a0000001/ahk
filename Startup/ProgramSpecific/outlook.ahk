; Outlook Hotkeys.
#ifWinActive, ahk_class rctrl_renwnd32

	; Make Control+1 go to the inbox, rather than just to mail.
	~^1::Send, ^+i

	; Make Control+F be search, not forward.
	^f::Send, ^e
	
	; Shortcut to go to today on the calendar. (In desired, 3-day view.)
	^t::
		Send, ^2
		Send, {Up}{Down}
		Send, !h
		Send, od
		Send, !3
		Send, {Left}{Home}
	return

	; TLG Event Creation Macro.
	$^n::
		if(WinActive("Calendar - ") || WinActive("TLG - ")) {
			Send, !hy
		} else {
			Send, ^n
		}
	return
	^+n::
		Send, ^n
	return

	; Calendar view: for 3-day view
	~^2::
		Send, {Left}
	return
#IfWinActive

; Activity-specific keys, must filter on title.
#If WinActive("Inbox - " localEmailAddress " - Microsoft Outlook")
	; Archive the current message.
	$^e::
		Send, ^q
		Send, !5
	return

#If WinActive("Calendar - " localEmailAddress " - Microsoft Outlook") || WinActive("TLG - " localEmailAddress " - Microsoft Outlook")
	; Calendar view: 3-day view.
	$^e::Send, !3
	
	; Calendar view: work week view.
	^w::Send, !-
	
	; Toggle the preview pane in calendar view.
	!r::
		Send, !v
		Send, pn
		if(previewOpen) {
			Send, r
			previewOpen := 0
		} else {
			Send, o
			previewOpen := 1
		}
	return
	
	; Time Scale on calendar.
	^+1::
		Send, !v
		Send, sc
		Send, 1
	return
	^+2::
		Send, !v
		Send, sc
		Send, 3
	return
	
	!WheelUp::!Up
	!WheelDown::!Down
#If

; Universal new email.
!+e::
	SetTitleMatchMode, 2
	WinActivate, Microsoft Outlook
	SetTitleMatchMode, 1
	
	Send, ^+m
Return