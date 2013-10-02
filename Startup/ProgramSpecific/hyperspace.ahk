#If WinActive("ahk_class ThunderRT6MDIForm") || WinActive("ahk_class ThunderRT6FormDC")

	; TLG Hotkey.
	^t::
		Send, %epicID%
	return
	
	; Login hotkey.
	^+t::
		Send, %epicID%{Tab}%epicUnixPass%{Enter}
		Sleep, 250
		If(WinActive("Hyperspace - Test")) {
			Send, {Enter}
		}
		Sleep, 250
		If(WinActive("Hyperspace - Test")) {
			Send, {Enter}
		}
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