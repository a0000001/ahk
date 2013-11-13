#If WinActive("ahk_class r2Window") || WinActive("Reflection Secure Shell Client")
	; Insert arbitrary text, inserting needed spaces to overwrite.
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
	
	; Paste clipboard, insering spaces to overwrite first.
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
	
	; Screen wipe
	^l::
	^+l::
		Send, !el{Enter}
	return
	
	; Various commands.
	^z::
		SendRaw, d ^`%ZeW
		Send, {Enter}
	return
	
	^e::
		SendRaw, d ^e
		Send, {Enter}
	return
	
	^+e::
		SendRaw, d ^EAVIEWID
		Send, {Enter}
	return
	
	^a::
		SendRaw, d ^`%ZeADMIN
		Send, {Enter}
	return
	
	^m::
		SendRaw, d ^EZMENU
		Send, {Enter}
	return
	
	^o::
		SendRaw, d ^EDTop
		Send, {Enter}
	return
	
	; Fast Forward.
	F1::
		Send, {Home}
		Send, {F9}
		Sleep, 100
		Send, t{Enter}
	return
	
	; Allow reverse field navigation.
	+Tab::
		Send, {Left}
	return
	
	^+Tab::
		Send, {Up}
	return
	
#If

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