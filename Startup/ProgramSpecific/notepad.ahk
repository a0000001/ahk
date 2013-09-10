#ifWinActive, ahk_class Notepad

; Make ctrl+backspace act as expected.
^Backspace::
	Send, ^+{Left}
	Send, {Backspace}
return
	
#ifWinActive