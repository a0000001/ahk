#If WinActive("ahk_class ThunderRT6MDIForm") || WinActive("ahk_class ThunderRT6FormDC")

	; TLG Hotkey.
	^t::
		Send, %epicID%
	return
	
	; Login hotkey.
	^+t::		
		Send, %epicID%{Tab}%epicUnixPass%{Enter}
		Sleep, 250
		if(hyperspaceNotLoadedYet()) {
			Send, {Enter}
		}
		Sleep, 250
		If(hyperspaceNotLoadedYet()) {
			Send, {Enter}
		}
	return
	
	hyperspaceNotLoadedYet() {
		return WinActive("Hyperspace - Test") || WinActive("Hyperspace - Training")
	}
	
	; Exit hotkey.
	^d::
		KeyWait, Control
		Send, {Alt Down}{Alt Up}
		Sleep, 100
		Send, x
	return
	
	; Make ctrl+backspace act as expected.
	^Backspace::
		Send, ^+{Left}
		Send, {Backspace}
	return
	
	; EMC2: Get DLG number from title.
	^+c::
		WinGetTitle, title
		; MsgBox, % title
		
		StringSplit, splitTitle, title, -, %A_Space%
		; MsgBox, % splitTitle1
		
		StringSplit, splitFirstPart, splitTitle1, %A_Space%
		; MsgBox, %splitFirstPart1% - %splitFirstPart2%
		
		clipboard := splitFirstPart2
	return

#IfWinActive