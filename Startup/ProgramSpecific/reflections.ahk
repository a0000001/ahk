#ifWinActive, ahk_class r2Window

	^i::
		; Block and buffer input until {ENTER} is pressed.
		Input, textIn, , {Enter}
		
		; Get the length of the string we're going to add.
		inputLength := StrLen(textIn)
		
		; Insert that many spaces.
		Send, {Insert %inputLength%}
		
		; Actually send our input text.
		SendRaw, % textIn
	return

	^v::
		; Get the length of the string we're going to add.
		inputLength := StrLen(clipboard)
		
		; Insert that many spaces.
		Send, {Insert %inputLength%}
		
		; Actually send our input text.
		SendRaw, % clipboard
	return

	; TLG Hotkey.
	^t::
		Send, %epicID%
	return
	
	; Unix password hotkey.
	^!t::
		Send, %epicUnixPass%
	return

	^l::
	^+l::
		Send, !el{Enter}
	return

#ifWinActive


; Quick TLG Reference Popup.
^#!t::
	; Gui, +Left
	Gui, Font,, Courier New
	Gui, Add, Text,, %tlgQuickRefText%
	Gui, Add, Button, Default, OK
	Gui, Show,, TLG Codes	
return

ButtonOK:
	Gui, Hide
return