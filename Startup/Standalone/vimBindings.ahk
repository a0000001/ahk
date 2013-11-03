#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; Force just one instance, we don't want muliple of this running around.
; #NoTrayIcon

#Include CommonIncludes\trayTools.ahk

; State flags.
global suspended := 0
global vimKeysOn := 1
global superKeysOn := 0

; Mapping for what states make which tray icons.
v := Object()
v[0] := "suspended"
v[1] := "vimKeysOn"
v[2] := "superKeysOn"
m := Object()
m[0, 0] := "..\CommonIncludes\Icons\vimIconPaused.ico"
m[0, 1, 0] := "..\CommonIncludes\Icons\vimIcon.ico"
m[0, 1, 1] := "..\CommonIncludes\Icons\vimIconSuper.ico"
m[1] := "..\CommonIncludes\Icons\vimIconSuspended.ico"

setupTrayIcons(v, m)

; Special flags for previous action.
global justFound := 0
global justOmnibox := 0
global justFeedlySearched := 0
global justOtherKeyPressed := 0

; Control classes.
ChromeSearchboxClass := "Chrome_WidgetWin_11"
ChromeOmnibarClass := "" ; Blank at this time.

; Titles for which pages have controls of their own.
global ownControlTitles := Object()
ownControlTitles[1] := " - Gmail"
ownControlTitles[2] := " - feedly"
ownControlTitles[3] := " - Reddit"
; ownControlTitles[4] := " - Google Search"

global excludeTitles := Object()
excludeTitles[1] := "MightyText"
excludeTitles[2] := "Login" ; Lastpass

pageHasOwnControls() {
	WinGetTitle, pageTitle, A
	StringTrimRight, pageTitle, pageTitle, 16 ; Slice off the " - Google Chrome" on the end.
	; MsgBox, % pageTitle
	
	numTitles := ownControlTitles.MaxIndex()
	Loop, %numTitles% {
		if(InStr(pageTitle, ownControlTitles[A_Index])) {
			; MsgBox, % ownControlTitles%A_Index%
			return true
		}
	}
	
	return false
}

pageToExclude() {
	WinGetTitle, pageTitle, A	
	; MsgBox, % pageTitle
	
	numTitles := excludeTitles.MaxIndex()
	Loop, %numTitles% {
		if(InStr(pageTitle, excludeTitles[A_Index])) {
			; MsgBox, % excludeTitles%A_Index%
			return true
		}
	}
	
	return false
}

chromeOrFirefoxActive() {
	return (WinActive("ahk_class Chrome_WidgetWin_1") || WinActive("ahk_class MozillaWindowClass"))
}

specialTextFieldActive() {
	ControlGetFocus, controlName, A
	; MsgBox, % controlName
	if(WinActive("ahk_class Chrome_WidgetWin_1")) {
		if(controlName = ChromeOmnibarClass || controlName = ChromeSearchboxClass) {
			return true
		} else {
			return false
		}
	} else {
		return false
	}
}

~!#x::
	Suspend, Toggle
	suspended := !suspended
	updateTrayIcon()
return

setVimState(toState, super = false) {
	vimKeysOn := toState
	superKeysOn := (toState && super)
	updateTrayIcon()
}

; Hotkeys related to script state, plus ones that always run.
#If chromeOrFirefoxActive()
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
		
	; Unpause specially for find (and feedly)
	~$Esc::
	~$Enter::
		unpauseSpecial()
	return
	
	; Close Tab. Here because F9 is not a typically-pressed key.
	F9::
		Send, ^w
	~^w::
		setVimState(true)
	return
#If

unpauseSpecial() {
	global superKeysOn, justFeedlySearched, justOtherKeyPressed
	
	if(superKeysOn || justFeedlySearched || justOtherKeyPressed) {
		setVimState(true)
		justFeedlySearched := 0
		justOtherKeyPressed := 0
	}
}

; Main hotkeys, run if not turned off.
#If chromeOrFirefoxActive() && vimKeysOn && !pageToExclude() && !specialTextFieldActive()
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

	; Feedly: if gg, pause script until enter or esc.
	; ~g::
		; WinGetTitle, pageTitle, A	
		; ; MsgBox, % pageTitle
		
		; if(InStr(pageTitle, " - feedly")) {
			; justFeedlySearched := 1
			; setVimState(false)
		; }
	; return
	
	; Letters that carry no vim meaning, so are normal typing.
	~a::
	~b::
	~c::
	~d::
	~e::
	~f::
	~g::
	~q::
	~r::
	~s::
	~t::
	~v::
	~w::
	~x::
	~y::
	~z::
	
	; Shifted letters never carry any vim meaning.
	~+a::
	~+b::
	~+c::
	~+d::
	~+e::
	~+f::
	~+g::
	~+h::
	~+i::
	~+j::
	~+k::
	~+l::
	~+m::
	~+n::
	~+o::
	~+p::
	~+q::
	~+r::
	~+s::
	~+t::
	~+u::
	~+v::
	~+w::
	~+x::
	~+y::
	~+z::
	
	; Numbers and shifted numbers never carry any vim meaning.
	~0::
	~1::
	~2::
	~3::
	~4::
	~5::
	~6::
	~7::
	~8::
	~9::
	~+0::
	~+1::
	~+2::
	~+3::
	~+4::
	~+5::
	~+6::
	~+7::
	~+8::
	~+9::
	
	; Symbols that don't carry any vim meaning, plus shifted versions.
	~`::
	~-::
	~=::
	~+`::
	~+-::
	~+=::
	
	; Symbols that normally carry vim meaning, but don't shifted.
	~+[::
	~+]::
	~+`;::
	~+'::
	~+/::
	~+,::
	~+.::
	
		setVimState(false)
		justOtherKeyPressed := 1
	return
	
	
	; +'::
		; justDoubleQuoted := 1
		; setVimState(false)
	; return
	
	; General: Double quote will never be a legitimate control input, turn it off.
	
	; Pause/suspend.
	; ~^l::
	; ~^t::
		; justOmnibox := 1
	i::
		setVimState(false)
	return
	
	; Reload.
	; r::Send, ^r
	
	; Forward, to match backspace for back.
	\::Send, !{Right}
	
	; Special addition for when j/k turned off because special page.
	' & j::Send, {Down}
	' & k::Send, {Up}
	' Up::Send, '
#If

; Main hotkeys, run if turned on and we're not on a special page.
#If chromeOrFirefoxActive() && vimKeysOn && !pageHasOwnControls() && !pageToExclude() && !specialTextFieldActive()
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
#If chromeOrFirefoxActive() && vimKeysOn && superKeysOn
	; Next/previous page, uses (modified) userscript. (Greasemonkeyboard)
	m::Send, ^{Right}
	n::Send, ^{Left}
	
	; These are also forced on, regardless of page having own controls, if superkeys are on.
	
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