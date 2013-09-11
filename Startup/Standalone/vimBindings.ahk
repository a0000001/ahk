#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Force just one instance, we don't want muliple of this running around.
; #NoTrayIcon

Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIconStopped.ico
Menu, Tray, icon, , , 1 ; Keep suspend from changing it to the AHK default.

suspended := 0
vimUsed := 0
vimKeysOn := 0
spaceDown := 0

; ~+!x::
	; Suspend, Permit
	; ExitApp				; Shift+Alt+X = Emergency Exit
; return
; ~!+r::
	; Suspend, Permit
	; Reload				; Shift+Alt+R = Reload
; return
~!#x::Suspend

#ifWinActive, ahk_class Chrome_WidgetWin_1

	; ; Function to tell if the URL bar is active.
	; chromeTextFieldActive() {
		; ControlGetFocus, controlName, A
		; ; MsgBox, % controlName
		; if(controlName = "Chrome_OmniboxView1" || controlName = "ViewsTextfieldEdit1") {
			; return true
		; } else {
			; return false
		; }
	; }
	
	; setSuspend(value) {
		; if(value) {
			; Suspend, On
			; scriptSuspended := true
			; Menu, Tray, Icon, Icons\vimIconStopped.ico
		; } else {
			; Suspend, Off
			; scriptSuspended := false
			; Menu, Tray, Icon, Icons\vimIcon.ico
		; }
		; return
	; }

	; ; Special disable - Suspend, On hotkeys aren't kept around.
	; i::
		; Suspend, On
		; setSuspend(true)
	; return
	
	; ; For disable/enable.
	; ~^t::
	; ~^l::
	; ~^f::
		; Suspend, Permit
		; setSuspend(true)
	; return
	; ~Esc::
	; !l::
		; Suspend, Permit
		; setSuspend(false)
	; return
	
	; ; Special, in case of new tab on close.
	; ~^w::
		; Suspend, Permit
		; setSuspend(false)
		
		; Sleep, 500
		
		; ; If URL bar is active, suspend it.
		; if(chromeTextFieldActive()) {
			; setSuspend(true)
		; }
	; return
	
	; ; Special, because this can turn things back on if it's in the URL bar.
	; ~Enter::
		; Suspend, Permit
		; if(chromeTextFieldActive()) {
			; setSuspend(false) ; If URL bar is active, all bets are off, unsuspend it.
		; } else {
			; setSuspend(true) ; If not, then match what it was before we did anything.
		; }
	; return
	
	
	; /::
		; Send, ^f
		; setSuspend(true)
	; return
	; Space & /::
		; Send, ^f
	; return
	; y::Send, ^w
	; Space & y::Send, ^w
	; r::Send, ^r
	; Space & r::Send, ^r
	; o::Send, ^{Tab}
	; u::Send, ^+{Tab}
	; Space & o::Send, ^{Tab}
	; Space & u::Send, ^+{Tab}
	; j::Send, {Down}
	; k::Send, {Up}
	; h::Send, {Left}
	; l::Send, {Right}
	; Space & j::Send, {Down}
	; Space & k::Send, {Up}
	; Space & l::Send, {Right}
	; Space & h::Send, {Left}
	; `;::Send, {PgDn}
	; p::Send, {PgUp}
	; [::Send, {Home}
	; ]::Send, {End}
	; Space & `;::Send, {PgDn}
	; Space & p::Send, {PgUp}
	; Space & [::Send, {Home}
	; Space & ]::Send, {End}
	
	; ; Check whether space is pressed, and whether the URL bar/find area are focused.
	; checkIfGo() {
		; ControlGetFocus, controlName, A
		; return (GetKeyState("Space", "P") && controlName != "")
	; }
	
	; ; Manual suspend.
	; $,::
	; $.::
		; Suspend, Permit
		; if(GetKeyState("Space", "P")) {
			; if(suspended) {
				; Suspend, Off
				; Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIconStopped.ico
				; suspended := 0
			; } else {
				; Suspend, On
				; Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIcon.ico
				; suspended := 1
			; }
			
			; spaceDownNow := false
		; } else {
			; Send, % SubStr(A_ThisHotkey,2)
		; }
	; return
	
	; ; Control space's other effects.
	; Space::
		; Suspend, Permit
		; spaceDownNow := true
	; return
	
	; Space Up::
		; Suspend, Permit
		; if(spaceDownNow) {
			; Send, {Space}
		; }
	; return

	; ; ; Up/Down/Left/Right.
	; $j::
		; if(checkIfGo()) {
			; Send, {Down}
			; spaceDownNow := false
		; } else {
			; Send, j
		; }
	; return
	; $k::
		; if(checkIfGo()) {
			; Send, {Up}
			; spaceDownNow := false
		; } else {
			; Send, k
		; }
	; return
	; $l::
		; if(checkIfGo()) {
			; Send, {Right}
			; spaceDownNow := false
		; } else {
			; Send, l
		; }
	; return
	; $h::
		; if(checkIfGo()) {
			; Send, {Left}
			; spaceDownNow := false
		; } else {
			; Send, h
		; }
	; return

	; ; Page Up/Down
	; $`;::
		; if(checkIfGo()) {
			; Send, {PgDn}
			; spaceDownNow := false
		; } else {
			; Send, `;
		; }
	; return
	; $p::
		; if(checkIfGo()) {
			; Send, {PgUp}
			; spaceDownNow := false
		; } else {
			; Send, p
		; }
	; return
	; $[::
		; if(checkIfGo()) {
			; Send, {Home}
			; spaceDownNow := false
		; } else {
			; Send, [
		; }
	; return
	; $]::
		; if(checkIfGo()) {
			; Send, {End}
			; spaceDownNow := false
		; } else {
			; Send, ]
		; }
	; return

	; ; Next/Previous tab.
	; $o::
		; if(checkIfGo()) {
			; Send, ^{Tab}
			; spaceDownNow := false
		; } else {
			; Send, o
		; }
	; return
	; $u::
		; if(checkIfGo()) {
			; Send, ^+{Tab}
			; spaceDownNow := false
		; } else {
			; Send, u
		; }
	; return

	; ; ; Reload.
	; $r::
		; if(checkIfGo()) {
			; Send, ^r
			; spaceDownNow := false
		; } else {
			; Send, r
		; }
	; return

	; ; ; Close tab.
	; $y::
		; if(checkIfGo()) {
			; Send, ^w
			; spaceDownNow := false
		; } else {
			; Send, y
		; }
	; return
	
	; ; Search.
	; $/::
		; if(checkIfGo()) {
			; Send, ^f
			; spaceDownNow := false
		; } else {
			; Send, /
		; }
	; return
	
	; ; Next and previous.
	; $m::
		; if(checkIfGo()) {
			; Send, ^l
			; Sleep, 100
			; Send, n{Enter}
			; spaceDownNow := false
		; } else {
			; Send, m
		; }
	; return
	; $n::
		; if(checkIfGo()) {
			; Send, ^l
			; Sleep, 100
			; Send, p{Enter}
			; spaceDownNow := false
		; } else {
			; Send, n
		; }
	; return
	
	sendVimCommand(keys) {
		global vimUsed := 1
		
		if(!suspended) {
			Send, %keys%
		}
	}
	
	$Space::
		if(!suspended) {
			vimKeysOn := 1
		}
		
		spaceDown := 1
	return
	
	; Emergency Exit.
	^Space::
		vimKeysOn := 0
	return
	
	#If vimKeysOn = 1 && !suspended
	
		; Up/Down/Left/Right.
		j::sendVimCommand("{Down}")
		k::sendVimCommand("{Up}")
		h::sendVimCommand("{Left}")
		l::sendVimCommand("{Right}")
		
		; Page Up/Down/Top/Bottom.
		`;::sendVimCommand("{PgDn}")
		p::sendVimCommand("{PgUp}")
		[::sendVimCommand("{Home}")
		]::sendVimCommand("{End}")
		
		; Next/Previous Tab.
		o::sendVimCommand("^{Tab}")
		u::sendVimCommand("^+{Tab}")
		
		; Close Tab.
		y::sendVimCommand("^w")
		
		; Reload.
		r::sendVimCommand("^r")
		
		; Next/Previous page link.
		m::
			sendVimCommand("^l")
			Sleep, 100
			Send, n{Enter}
			spaceDownNow := false
		return
		n::
			sendVimCommand("^l")
			Sleep, 100
			Send, p{Enter}
			spaceDownNow := false
		return
		
		; Find
		/::sendVimCommand("^f")
	
		; Manual suspend.
		,::
			Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIcon.ico
			suspended := 1
			vimKeysOn := 0
			vimUsed := 1
		return
		
	#If suspended
		
		; Manual unsuspend.
		,::
			if(spaceDown){
				Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIconStopped.ico
				suspended := 0
				vimKeysOn := 1
				vimUsed := 1
			} else {
				Send, %A_ThisHotkey%
			}
		return
		
	#If
	
#ifWinActive
	
	$Space up::
		if(!vimUsed) {
			Send, {Space}
		}
		
		vimKeysOn := 0
		vimUsed := 0
		spaceDown := 0
	return