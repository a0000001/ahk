#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon
;Menu, Tray, Icon, Startup\Icons\trebleClefBlueShiny.ico

BlockInput, mousemove

suspendedNow := 0

; Next, Previous, Play/Pause
RButton::
	if(!suspendedNow) {
		Send, {Media_Next}
	} else {
		Click, right
	}
return
LButton::
	if(!suspendedNow) {
		Send, {Media_Prev}
	} else {
		Click
	}
return
MButton::
	if(!suspendedNow) {
		Send, {Media_Play_Pause}
	} else {
		Click, middle
	}
return

; Show current info
LButton & RButton::Send, ^!{Space}

; Movement within the list.
LButton & WheelDown::Send, {Down}
LButton & WheelUp::Send, {Up}

; Volume
$WheelUp::
	if(!suspendedNow) {
		Send, {Volume_Up 5}
	} else {
		Send, {WheelUp}
	}
return
$WheelDown::
	if(!suspendedNow) {
		Send, {Volume_Down 5}
	} else {
		Send, {WheelDown}
	}
return

; Exit.
RButton & LButton::
	if(suspendedNow) {
		suspendedNow := 0
;		Menu, Tray, Icon, Startup\Icons\trebleClefBlueShiny.ico
		BlockInput, mousemove
	} else {
		suspendedNow := 1
;		Menu, Tray, Icon, Startup\Icons\eighthNotesConnectedPink.ico
		BlockInput, mousemoveOff
	}
return

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload