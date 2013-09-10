#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Force just one instance, we don't want muliple of this running around.
; #NoTrayIcon

Menu, Tray, Icon, Icons\vimIcon.ico
Menu, Tray, icon, , , 1 ; Keep suspend from changing it to the AHK default.


~+!x::ExitApp				; Shift+Alt+X = Emergency Exit
~!+r::Reload				; Shift+Alt+R = Reload
~!#x::Suspend

#ifWinActive, ahk_class Chrome_WidgetWin_1

	; Function to tell if the URL bar is active.
	chromeTextFieldActive() {
		ControlGetFocus, controlName, A
		; MsgBox, % controlName
		if(controlName = "Chrome_OmniboxView1" || controlName = "ViewsTextfieldEdit1") {
			return true
		} else {
			return false
		}
	}
	
	setSuspend(value) {
		if(value) {
			Suspend, On
			scriptSuspended := true
			Menu, Tray, Icon, Icons\vimIconStopped.ico
		} else {
			Suspend, Off
			scriptSuspended := false
			Menu, Tray, Icon, Icons\vimIcon.ico
		}
		return
	}

	; Special disable - Suspend, On hotkeys aren't kept around.
	i::
		Suspend, On
		setSuspend(true)
	return
	
	; For disable/enable.
	~^t::
	~^l::
	~^f::
		Suspend, Permit
		setSuspend(true)
	return
	~Esc::
	!l::
		Suspend, Permit
		setSuspend(false)
	return
	
	; Special, in case of new tab on close.
	~^w::
		Suspend, Permit
		setSuspend(false)
		
		Sleep, 500
		
		; If URL bar is active, suspend it.
		if(chromeTextFieldActive()) {
			setSuspend(true)
		}
	return
	
	; Special, because this can turn things back on if it's in the URL bar.
	~Enter::
		Suspend, Permit
		if(chromeTextFieldActive()) {
			setSuspend(false) ; If URL bar is active, all bets are off, unsuspend it.
		} else {
			setSuspend(true) ; If not, then match what it was before we did anything.
		}
	return

	; Up/Down/Left/Right.
	j::Send, {Down}
	k::Send, {Up}
	h::Send, {Left}
	l::Send, {Right}

	; Page Up/Down
	`;::Send, {PgDn}
	p::Send, {PgUp}
	[::Send, {Home}
	]::Send, {End}

	; Next/Previous tab.
	o::Send, ^{Tab}
	u::Send, ^+{Tab}

	; Reload.
	r::Send, ^r

	; Close tab.
	y::Send, ^w
	
	; Search.
	/::
		Send, ^f
		setSuspend(true)
	return

#ifWinActive