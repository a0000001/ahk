; Buddy list.
#IfWinActive, ahk_class tSkMainForm

; Close the window.
^!s::Send !{F4}

; Options.
!o::Send !to

; Snapshot.
^+s::
	Send !adv
	Sleep, 500
	WinActivate, ahk_class tSkMainForm
return

#IfWinActive


; Conversation window.
#IfWinActive, ahk_class TConversationForm

; ; Snapshot.
; ^+s::
	; Send !adv
	; Sleep, 500
	; WinActivate, ahk_class TConversationForm
; return

; ; Share the screen.
; ^+c::Send !ar

#IfWinActive 