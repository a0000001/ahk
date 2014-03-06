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
		ControlSend_Return("", "!s")
	return
	
	; Fill date in unit charge entry.
	^+f::
		ControlGet_Send_Return("ThunderRT6TextBox50", "ThunderRT6TextBox54")
	return
	
	
	; EMC2: Make ^h for server object, similar to ^g for client object.
	^h::
		Send, ^6
	return
	
	
	; EMC2: Get DLG number from title.
	^+c::
		clipboard := getEMC2ObjectFromTitle()
	return
	
	; EMC2: Take DLG # and pop up the DLG in EpicStudio sidebar.
	^+o::
		dlg := getEMC2ObjectFromTitle()
		if(dlg)
			Run, %pLaunchPath_EpicStudio% DLG-%dlg%
		
	return
	
	; EMC2: Generate link using title for current object (DLG, etc.) and puts it on the clipboard.
	^+l::
		copyCurrentEMC2ObjectLink(true)
	return
	
	; EMC2: Generate (view-only) link using title for current object (DLG, etc.) and puts it on the clipboard.
	^+w::
		copyCurrentEMC2ObjectLink(false)
	return
	
	; EMC2: Open view (web) version of the current object.
	^!w::
		link := getCurrentEMC2ObjectLink(false)
		Run, % link
	return
	
	; Insert HB SU SmartText.
	:*:hb.su::
		Send, ^{F10}
		WinWait, SmartText Selection
		SendRaw, HB DEVELOPMENT APPROVAL
		Send, {Enter 2}
	return
#If

; Generic linker - will allow coming from clipboard or selected text, or input entirely. Puts the link on the clipboard.
^+!l::
	copyEMC2ObjectLink()
	
	; link := getEMC2ObjectLink()
	; if(link)
		; clipboard := link
	
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

#If borgWhichMachine = EPIC_DESKTOP
	; Generic opener - generates and launches the link created.
	^!#o::
		link := getEMC2ObjectLink()
		if(link)
			Run, % link
	return
#If

; #IfWinActive, Demand Claim Processing
	; ; For demanding claims: Ctrl + Enter pops null unto the right box, tabs until accept is active, and accepts it.
	; ^NumPadEnter::
	; ^Enter::
		; ControlGetFocus, currControl, A
		; ; MsgBox, % currControl
		; if(currControl = "ThunderRT6CommandButton10") {
			; Send, +{Tab 3}
			; Send, null
			; Send, {Tab 3}
			; Send, {Enter}
		; }
	; return
; #IfWinActive

; Activiation for when hyperspace hides from Alt+Tab b/c of a popup.
!+h::
	WinActivate, ahk_class ThunderRT6MDIForm
return
