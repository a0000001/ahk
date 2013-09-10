#ifWinActive, ahk_class Notepad++

; Ctrl+Shift+t browser-like behavior.
^+t::
	Send !f
	Send 1
return

; Disable Alt+Shift+X close document
!+x::Return

; Prevent accidental random insert instead of redo.
^+z:: Send ^y

; New document.
^n::^t

; Special key for notepad++ save session and load session
^!s::Send ^+!{Backspace}
^!l::Send ^+!{PgUp}

#ifWinActive