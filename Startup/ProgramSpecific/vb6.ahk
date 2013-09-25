#IfWinActive, ahk_class wndclass_desked_gsk

	; Redo, not yank.
	^y::
	^+z::
		Send, !e
		Sleep, 100
		Send, r
	return
	
	; Stop when running.
	F12::
		Send, !r
		Sleep, 100
		Send, e
	return
	
	; Options.
	$!o::
		Send, {Blind}t ; Because it's an ALT+ hotkey, alt coming up prematurely disrupted the selection. So, just use the alt already down.
		Sleep, 250
		Send, o
	return
	
	; Epic Headers Addin.
	^+h::
		Send, !a
		Sleep, 100
		Send, {Up}{Enter}
	return
	
	; Epic VB Parse Addin.
	^+p::
		Send, !a
		Sleep, 100
		Send, {Up 2}{Enter}
	return
	
#IfWinActive