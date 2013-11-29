#If WinActive("ahk_class ThunderRT6MDIForm") || WinActive("ahk_class ThunderRT6FormDC")
	; TLG Hotkey.
	^t::
		Send, %epicID%
	return
	
	; Login hotkey.
	^+t::		
		Send, %epicID%{Tab}
		Send, %epicHyperspacePass%{Enter}
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
		if(WinActive("Hyperspace - Test") ; Hyperspace 2012, FNDEX.
			|| WinActive("Hyperspace - Training") ; PTC Hyperspace Project Dev.
			|| WinActive("Hyperspace - Foundations Lab QA") ; PTC Hyperspace Project QA.
			|| WinActive("Development Training Lab - TRNTRACK") ; EMC2 SteamTrainTrack.
		|| 0) {
			return true
		}
		
		return false
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
	
	; Allow my save reflex to live on. Return to the field we were in when we finish.
	^s::
		; ControlGetFocus, currControl, A
		; ; MsgBox, %currControl%
		
		; Send, !s
		; Sleep, 100
		
		; ; Send, +{Tab}
		; ControlFocus, %currControl%, A
		; ; ControlFocus, ThunderRT6TextBox2, A
		ControlSend_Return("", "!s")
	return
	
	; Fill date in unit charge entry.
	^+f::
		ControlGet_Send_Return("ThunderRT6TextBox50", "ThunderRT6TextBox54")
		; ControlGetFocus, currControl, A
		; ; MsgBox, %currControl%
		
		; if(WinActive("", "Charge Entry - ")) {
			; ControlGetText, date, ThunderRT6TextBox50, A
			; ; MsgBox, % date
			; ControlFocus, ThunderRT6TextBox54
			; Send, %date%
			; Sleep, 100
		; }
		
		; ControlFocus, %currControl%, A
	return
	
	
	; EMC2: Get DLG number from title.
	^+c::
		clipboard := getEMC2DLGFromTitle()
	return
	
	; EMC2: Take DLG # and pop up the DLG in EpicStudio sidebar.
	^+o::
		dlg := getEMC2DLGFromTitle()
		if(dlg) {
			Run, %pLaunchPath_EpicStudio% DLG-%dlg%
		}
	return
#If

getEMC2DLGFromTitle() {
	WinGetTitle, title
	; MsgBox, % title
	
	; If the title doesn't have a number, we shouldn't be returning anything.
	if(title != "EMC2") {
		StringSplit, splitTitle, title, -, %A_Space%
		; MsgBox, % splitTitle1
		
		StringSplit, splitFirstPart, splitTitle1, %A_Space%
		; MsgBox, %splitFirstPart1% - %splitFirstPart2%
		
		return splitFirstPart2
	}
	
	return ""
}

#IfWinActive, Demand Claim Processing
	; For demanding claims: Ctrl + Enter pops null unto the right box, tabs until accept is active, and accepts it.
	^NumPadEnter::
	^Enter::
		ControlGetFocus, currControl, A
		; MsgBox, % currControl
		if(currControl = "ThunderRT6CommandButton10") {
			Send, +{Tab 3}
			Send, null
			Send, {Tab 3}
			Send, {Enter}
		}
	return
#IfWinActive

; Activiation for when hyperspace hides from Alt+Tab b/c of a popup.
!+h::
	WinActivate, ahk_class ThunderRT6MDIForm
return
