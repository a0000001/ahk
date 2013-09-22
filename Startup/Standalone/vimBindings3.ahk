#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Force just one instance, we don't want muliple of this running around.
; #NoTrayIcon

; #Include %A_ScriptDir%\iniReadStandalone.ahk

Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIcon.ico
Menu, Tray, icon, , , 1 ; Keep suspend from changing it to the AHK default.

; State flags.
global vimKeysOn := 1
global superKeysOn := 0
global suspended := 0

; Special flags for previous action.
global justFound := 0
global justOmnibox := 0

; Titles for which pages to check for.
global titles := 4
global titles1 := " - Gmail"
global titles2 := " - Google Search"
global titles3 := " - feedly"
global titles4 := " - Reddit"

pageHasOwnControls() {
	WinGetTitle, pageTitle, A
	StringTrimRight, pageTitle, pageTitle, 16 ; Slice off the " - Google Chrome" on the end.
	
	; MsgBox, % pageTitle
	
	i := 1
	Loop, %titles% {
		if(InStr(pageTitle, titles%i%)) {
			; MsgBox, % titles%i%
			return true
		}
		i++
	}
	
	return false
}

~!#x::
	Suspend, Toggle
	if(suspended) {
		suspended := 0
		if(vimKeysOn) {
			if(superKeysOn) {
				Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIconSuper.ico
			} else {
				Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIcon.ico
			}
		} else {
			Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIconPaused.ico
		}
	} else {
		suspended := 1
		Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIconSuspended.ico
	}
return

setVimState(toState, super = false) {
	if(toState) {
		vimKeysOn := 1
		if(super) {
			superKeysOn := 1
			Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIconSuper.ico
		} else {
			superKeysOn := 0 ; Reset it.
			Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIcon.ico
		}
	} else {
		vimKeysOn := 0
		Menu, Tray, Icon, ..\CommonIncludes\Icons\vimIconPaused.ico
		superKeysOn := 0
	}
}

; Hotkeys related to script state, plus ones that always run.
#IfWinActive, ahk_class Chrome_WidgetWin_1
	; Special super-on.
	F8::
		if(superKeysOn) {
			setVimState(true, false)
		} else {
			setVimState(true, true)
		}
	return
	
	; Explicit unpause.
	!m::
	!j::
		setVimState(true)
	return
		
	; Unpause specially for find.
	~$Esc::
		if(superKeysOn) {
			setVimState(true) ; Special additional reset.
		}
		if(justFound) {
			setVimState(true)
			justFound := 0
		}
	return

	; Unpause specially for omnibox.
	~$Enter::
		if(justOmnibox) {
			setVimState(true)
			justOmnibox := 0
		}
	return
	
	; Close Tab. Here because F9 is not a typically-pressed key.
	F9::
		Send, ^w
	~^w::
		setVimState(true)
	return
#IfWinActive

; Main hotkeys, run if not turned off.
#If WinActive("ahk_class Chrome_WidgetWin_1") && vimKeysOn
	; Next/Previous Tab.
	o::Send, ^{Tab}
	u::Send, ^+{Tab}
	
	; Find
	/::
		Send, ^f
	~^f::
		setVimState(false)
		justFound := 1
	return

	; Pause/suspend.
	~^l::
	~^t::
		justOmnibox := 1
	i::
		setVimState(false)
	return
	
	; Reload.
	; r::Send, ^r
	
	; Forward, to match backspace for back.
	\::Send, !{Right}
	
	; Special addition for when j/k turned off because special page.
	Space & j::Send, {Down}
	Space & k::Send, {Up}
	Space Up::Send, {Space}
#If

; Main hotkeys, run if turned on and we're not on a special page.
#If WinActive("ahk_class Chrome_WidgetWin_1") && vimKeysOn && !pageHasOwnControls()
	; Up/Down/Left/Right.
	j::Send, {Down}
	k::Send, {Up}
	h::Send, {Left}
	l::Send, {Right}
	
	; Page Up/Down/Top/Bottom.
	`;::Send, {PgDn}
	p::Send, {PgUp}
	[::Send, {Home}
	]::Send, {End}
#If

; Special keys, only activated at higher level
#If WinActive("ahk_class Chrome_WidgetWin_1") && vimKeysOn && superKeysOn
	; Next/previous page, uses (modified) userscript. (Greasemonkeyboard)
	m::Send, ^{Right}
	n::Send, ^{Left}
#If