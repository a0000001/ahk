; Outlook Hotkeys.
#ifWinActive, ahk_class rctrl_renwnd32

	; Shortcut to go to today on the calendar. (In desired, 2-day view.)
	^t::
		Send, ^2
		Send, {Up}{Down}
		Send, !h
;		Send, 12
		Send, od
		Send, !1
		Send, !3
		Send, {Left}
		Send, {Home}
	return
	
	; Archive the current message.
	^e::
		Send, ^q
		Send, !4
		; Send, ^+2
	return
	
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
	^+3::
		Send, !v
		Send, sc
		Send, 3
	return
	
	; Week vs. Month vs. 2-day view.
;	^d::^!1
;	^w::^!2
;	^m::^!4

	; TLG Event Creation Macro.
	^n::
		Send, !hy
	return
	^+n::
		Send, ^n
	return
	


	~^2::
;		Sleep, 100
		Send, {Left}
	return
	
	!WheelUp::!Up
	!WheelDown::!Down
	
#ifWinActive

; Outlook activation hotkey.
; !2::WinActivate, ahk_class rctrl_renwnd32

; Universal new email.
!+e::
	SetTitleMatchMode, 2
	WinActivate, Microsoft Outlook
	SetTitleMatchMode, 1
	
	Send, ^+m
Return