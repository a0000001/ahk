; #NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

#IfWinActive, ahk_class MozillaWindowClass

; Escape the keyboard focus from flash.
CapsLock::
	; 660, 40
	CoordMode, Mouse, Relative
	MouseGetPos, startX, startY	
	Click, 660, 40
	MouseMove, startX, startY
	
	Sleep, 100
	
	Send, {Tab}
	
	CoordMode, Mouse, Screen
return

; Easy bookmark hotkeys.
F8::
	FF_BookmarkToFolder(fff_mikal)
return

F9::
	FF_BookmarkToFolder(fff_backlog)
return

F10::
	FF_BookmarkToFolder(fff_tech)
return

$F11::
	FF_BookmarkToFolder(fff_ahk)
return

F12::
	FF_BookmarkToFolder(fff_games)
return

; Fullscreen to dodge special bookmarking hotkeys.
!Enter::Send, {F11}

; Disable close window hotkeys
^+w::return

; Disable search ctrl K hotkey, and turn it into the darken bookmarklet instead!
^k::
	Send, ^l
	Send, d
	Send, {Enter}
return

; ^Right::
;^Up::
^Down::
	Send, ^l
	SendRaw, +
	Send, {Enter}
return

return

; Dom inspector
; ^+k::
	; SetTitleMatchMode, 2
	; if WinActive(" - DOM Inspector"){
		; Send, !f
		; Sleep, 100
		; Send, h
		; Sleep, 100
		; Send, 1
	; } else {
		; ControlSend, ahk_parent, ^+i, Mozilla Firefox
		; Sleep, 500
		; WinClose,  - DOM Inspector	; Close one of the two that pop up, for whatever reason.
	; }
	; SetTitleMatchMode, 1
; return

; Addons menu
^+e:: Send ^+a

; Show/hide addons bar
; ^+a::Send ^/

; Show all bookmarks
^+b::
	Send, !b
	Sleep, 100
	Send, {Enter}
return

; Show/hide bookmarks toolbar
;^+b::
;	Send !v
;	Sleep, 100
;	Send tb
;return

; Tab groups hotkey
^e::^+e

; For hiding GR activity with just right hand
RAlt & `;::Send ^1

; Firebug - inspect element
;^+i::
;	Send ^+c
;return

; Options Menu
!o::
	send !t
	sleep 1
	send o
return

; Extension Options Menu
; !e::
	; send !t
	; sleep 1
	; send e
; return

; Print Preview
; ^+v::
	; send !f
	; sleep 1
	; send v
; return

; DownThemAll manager
^!j::
	Send !tm{Enter}
return

; easy bookmark of odd links in google reader for showing to mikal later.
; $^+m::
	; Click, right
	; Send, l
; return

#ifWinActive, ahk_class MozillaDialogClass

; ^+m::
; ;	Send, {Tab}{Tab}{Space}
; ;	Sleep, 100
	; Send, {Tab}Mikal
; ;	Send, {Tab}{Tab}
	; Send, {Enter}
; return


#ifWinActive