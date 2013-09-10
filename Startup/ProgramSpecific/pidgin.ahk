; Mikal Hotkey Override
#+m::
	Send, #+n
return

; #ifWinExist, ahk_class gdkWindowToplevel
; !4::
	; ; WinActivate, ahk_class gdkWindowToplevel
	; Send, ^!d
; return
; #ifWinExist

#ifWinActive, Buddy List

; Hide buddy list when active.
^!d::
	Send, !{F4}
return

; Hide/show status bar.
$^!s::
	ControlSend, gdkWindowChild14, ^!s, Buddy List
return

#ifWinActive