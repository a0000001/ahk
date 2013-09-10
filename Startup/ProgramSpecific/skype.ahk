; Buddy list.
#ifWinActive, ahk_class tSkMainForm

; Close the window.
^!s::Send !{F4}

; Options.
!o::Send !to

#ifWinActive


; Conversation window.
#ifWinActive, ahk_class TConversationForm

; Snapshot.
^+s::
	Send !adv
	Sleep, 500
	WinActivate, ahk_class TConversationForm
return

; ; Share the screen.
; ^+c::Send !ar

#ifWinActive