; Outlook Hotkeys.
#ifWinActive, ahk_class rctrl_renwnd32
	; Make Control+1 go to the inbox, rather than just to mail.
	~^1::Send, ^+i

	; Make Control+F be search, not forward.
	; ^f::Send, ^e
	
	; Shortcut to go to today on the calendar. (In desired, 3-day view.)
	^t::
		; Get to calendar if needed.
		Send, ^2
		Send, {Up}{Down}
		
		; Go to today if needed.
		Send, !h
		Send, od
		
		; Set view as desired.
		Send, !3 ; 3 days.
		; Send, ^!3 ; Week, not 3 days.
		; Send, {Left}{Home}
	return

	; ; TLG Event Creation Macro.
	; $^n::
		; if(WinActive("Calendar - ") || WinActive("TLG - ")) {
			; Send, !hy
		; } else {
			; Send, ^n
		; }
	; return
	; ^+n::
		; Send, ^n
	; return

	; Calendar view: for 3-day view - shifts one day back so today is center.
	; ~^2::
		; Send, {Left}
	; return
	
	; Send whitespace character that outlook checks the body of the message for in order to skip delay send.
	!x::
		Send, {Enter}2000!x
		Sleep, 100
		Send, !s
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
	; Calendar view: 3-day view, week view, and month view.
	$^e::Send, !3
	^w::Send, ^!3
	^q::Send, ^!4
	
	; Toggle the preview pane in calendar view.
	!r::
		Send, !v
		Send, pn
		if(previewOpen) {
			Send, b
			previewOpen := 0
		} else {
			Send, o
			previewOpen := 1
		}
	return
	
	; Time Scale on calendar: 15m and 30m.
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
	
	; Weekly scrolling.
	; !WheelUp::!Up
	; !WheelDown::!Down
	
	; Category application: Make ^F1 usable.
	^F1::^F12
#If

; Universal new email. (Yanked from BWNHotKeys.ahk on wiki)
^!m::
{
	olMailItem := 0
	MailItem := ComObjActive("Outlook.Application").CreateItem(olMailItem)
	MailItem.Display
	WinActivate Untitled - Message
	return
}

; !+e::
	; SetTitleMatchMode, 2
	; WinActivate, Microsoft Outlook
	; SetTitleMatchMode, 1
	
	; Send, ^+m
; return