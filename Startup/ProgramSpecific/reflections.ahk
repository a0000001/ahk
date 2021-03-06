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
	
	; Normal paste, without all the inserting of spaces.
	^v::
		Send, +{Insert}
	return
	
	; Paste clipboard, insering spaces to overwrite first.
	$!v::
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
	
	$!e::
		SendRaw, d ^EPIC
		Send, {Enter}
	return
	
	; ^+e::
		; SendRaw, d ^EAVIEWID
		; Send, {Enter}
	; return
	
	; Pasting ZR/ZLs.
	^!e::
		SendRaw, d ^`%ZeEPIC
		Send, {Enter}
	return
	:*:.zrv::
		SendRaw, `;zcode
		Send, {Enter}
		Send, 0{Enter}
	return
	:*:.zrr::
		SendRaw, `;zrun searchCode("","","",$c(16))
		Send, {Enter}
		Send, q{Enter}
	return
	
	^a::
		SendRaw, d ^`%ZeADMIN
		Send, {Enter}
	return
	
	^+d::
		SendRaw, d ^`%ZdTOOLS
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
	
	^h::
		SendRaw, d ^HB
		Send, {Enter}
	return
	
	:*:.lock::
		SendRaw, w $$zlock^elibEALIB1(" ; Extra comment/quote here to fix syntax highlighting. "
	return
	
	:*:.unlock::
		SendRaw, w $$zunlock^elibEALIB1(" ; Extra comment/quote here to fix syntax highlighting. "
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

; ; Quick TLG Reference Popup.
; ^#!t::
	; ; Gui, +Left
	; Gui, Font,, Courier New
	; Gui, Add, Text,, %tlgQuickRefText%
	; Gui, Add, Button, Default, OK
	; Gui, Show,, TLG Codes	
; return

; ButtonOK:
	; Gui, Hide
; return