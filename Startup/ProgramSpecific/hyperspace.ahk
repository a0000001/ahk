#If WinActive("ahk_class ThunderRT6MDIForm") || WinActive("ahk_class ThunderRT6FormDC") || WinActive("ahk_class ThunderMDIForm") || WinActive("ahk_class ThunderFormDC")
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
	
	; Exit hotkey. Requires the first toolbar item be set to Exit.
	^d::
		; KeyWait, Control
		; Send, {Alt Down}{Alt Up}
		; Sleep, 100
		; Send, x
		Send, ^1
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
		clipboard := getEMC2ObjectFromTitle()
	return
	
	; EMC2: Take DLG # and pop up the DLG in EpicStudio sidebar.
	^+o::
		dlg := getEMC2ObjectFromTitle()
		if(dlg) {
			Run, %pLaunchPath_EpicStudio% DLG-%dlg%
		}
	return
	
	; EMC2: Generate link using title for current object. (DLG, etc.)
	^+l::
		objectName := getEMC2ObjectFromTitle(true)
		objectSplit := specialSplit(objectName, A_Space)
		DEBUG.popup(objectSplit, "EMC2 Object Name:", DEBUG.hyperspace)
		
		; Get the link.
		link := generateEMC2ObjectLink(true, ini, num, "..\Selector\emc2link.ini")
		DEBUG.popup(link, "Generated Link:", DEBUG.hyperspace)
	return
#If

; Generic linker - will allow coming from clipboard or selected text, or input entirely.
^+!l::
	; Grab the selected text/clipboard.
	text := getSelectedText(true)
	DEBUG.popup(text, "Silent Choice:", DEBUG.hyperspace)
	
	; Drop any leading whitespace.
	cleanText = %text%
	
	; Grab the INI.
	ini := SubStr(cleanText, 1, 3)
	
	; Allow of form XXX 123456 or XXX123456.
	if(SubStr(cleanText, 4, 1) = A_Space)
		num := SubStr(cleanText, 5)
	else
		num := SubStr(cleanText, 4)
	
	if(StrLen(ini) != 3) {
		ini := ""
		num := ""
	}
	
	If num Is Not Number
		ini := ""
		num := ""
	
	; Get the link.
	link := generateEMC2ObjectLink(true, ini, num, "..\Selector\emc2link.ini")
	DEBUG.popup(link, "Generated Link:", DEBUG.hyperspace)
	
	; if(WinActive("ahk_class rctrl_renwnd32")) { ; Outlook.
		; Send, ^k
		; WinWait, Insert Hyperlink, , 2
		; Sleep, 100
		; if(ErrorLevel) {
			; MsgBox, Couldn't find Insert Hyperlink window!
		; } else {
			; SendRaw, %link%
			; Send, {Enter}
		; }
	; } else { ; Just output in form: "XXX ###### (emc2://TRACK/XXX/######?action=EDIT)"
		; Send, %text%{Space}
		; SendRaw, (%link%) 
	; }
return

getEMC2ObjectFromTitle(includeINI = false) {
	WinGetTitle, title
	; MsgBox, % title
	
	; If the title doesn't have a number, we shouldn't be returning anything.
	if(title != "EMC2") {
		StringSplit, splitTitle, title, -, %A_Space%
		; MsgBox, % splitTitle1
		
		if(includeINI)
			return splitTitle1
		
		StringSplit, objectName, splitTitle1, %A_Space%
		; MsgBox, %splitFirstPart1% - %splitFirstPart2%
		
		return objectName2
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
