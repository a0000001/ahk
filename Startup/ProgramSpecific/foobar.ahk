; Hotkey catches for if foobar isn't running.
#IfWinNotExist, ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}

	^!Up::
	^!Down::
	^!Left::
	^!Right::
		Run, C:\Program Files (x86)\foobar2000\foobar2000.exe
	return
	
#IfWinNotExist

; If foobar is indeed running.
#IfWinExists, ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}
	
	^!Up::Send {Media_Stop}
	^!Down::Send {Media_Play_Pause}
	^!Right::Send {Media_Next}
	^!Left::Send {Media_Prev}
	
	; ; Foobar focusing hotkey.
	; ~!3::
		; WinActivate, ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}
	; return
	
	; $#+1::
	; $#!1::
	; $#0::
	; $#1::
	; $#2::
	; $#3::
	; $#4::
		; SwitchPlaylist(SubStr(A_ThisHotkey, 0))
	; return
	
	; SwitchPlaylist(num) {
		; if(num == 1) {
			; SetTitleMatchMode, 2
			
			; if(GetKeyState("Alt", "P")) {
				; ControlSend, {4B94B650-C2D8-40de-A0AD-E8FADF62D56C}1, ^w, foobar2000	; Kill current playlist on switch back.
			; } else if(!GetKeyState("Shift", "P")) {
				; ControlSend, {4B94B650-C2D8-40de-A0AD-E8FADF62D56C}1, {Home}, foobar2000	; Reset position in current playlist on switch.
			; }
			
			; SetTitleMatchMode, 1
		; }
		
		; Send, #{Numpad%num%}
	; }
	
	; Special activation of foobar window for search.
	~#j::
		WinGetTitle, prevWin, A
		;WinActivate, ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}
		Sleep, 100
		WinActivate, ahk_class {483DF8E3-09E3-40d2-BEB8-67284CE3559F}
	return
	
	
	; Main foobar window.
	#ifWinActive, ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}
		; Turn cursor-following-playback off.
		; ^+c::Send !pf
		
		; Turn playback-following-cursor off.
		; ^+p::Send !pu
		
		; Similar to library shortcuts, but for main window.
		^Enter::
			Send, {Enter}
			minimizeWindowSpecial()
		return
		+Enter::
			Send, ^+q
			minimizeWindowSpecial()
		return
	#IfWinActive
	

	; Media library search.
	; #IfWinActive, ahk_class {483DF8E3-09E3-40d2-BEB8-67284CE3559F}
	#IfWinActive, Media Library Search

	;ahk_class {483DF8E3-09E3-40d2-BEB8-67284CE3559F}
	; Special search ability: enter moves it down to the list instead of playing the search.
	Enter::PlaySong()

	; Special search ability: shift-enter moves it down to the list instead of playing the search.
	+Enter::PlaySong(1)

	; nowOrLater = 1 for adding to queue instead of playing now.
	PlaySong(nowOrLater = 0) {
		ControlGetFocus, currentlyActiveControl
		; MsgBox, % currentlyActiveControl
		if(currentlyActiveControl != "{4B94B650-C2D8-40de-A0AD-E8FADF62D56C}1" or currentlyActiveControl == "Edit1") {	; Bottom control is not selected, so input textbox is, or else textbox is - grab first result.
			ControlFocus, {4B94B650-C2D8-40de-A0AD-E8FADF62D56C}1  ; Activate bottom area for consistency.
			Send, {Home}
		}
		
		if(!nowOrLater) {
			Send, ^p
		} else {
			Send, ^+q
		}
		
		Sleep, 100
		WinClose, A
		WinActivate %prevWin%
	}

	; Special for search: moves to first item in list instead of buttons on right, and back.
	Tab::
		send {TAB}{TAB}{TAB}{DOWN}
	return

	+Tab::
		send +{TAB}{TAB}{TAB}
	return

	; ; Send to a playlist.
	; ^!s::Send, ^+!#{NumpadMult}
	
	#IfWinActive

#IfWinExists


; These don't really apply elsewhere.
#If borgWhichMachine = THINKPAD && !WinExist("ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}")

	browser_forward::
	browser_back::
		Run, C:\Program Files (x86)\foobar2000\foobar2000.exe
	return

#If

; These don't really apply elsewhere.
#If borgWhichMachine = THINKPAD && WinExist("ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}")

	browser_forward::
	browser_back::
		Send, ^!{Space}
	return
	
#If



; if(borgWhichMachine = THINKPAD) {
	; ; View now playing.
	; $*browser_back::
	; $*browser_forward::
		; ; DetectHiddenWindows, On
		
		; ; if(WinExist("ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}")) {
			
			; ; if(GetKeyState("RShift", "P")) {
				; ; Send {browser_search}
			; ; } else {
				; Send ^!{Space}
			; ; }
		; ; }
		; ; if(WinExist("timer.ahk")) {
			; ; if(GetKeyState("RCtrl", "P")) {
				; ; Send {browser_stop}
			; ; } else {
				; ; Send {browser_refresh}
			; ; }
		; ; }
		
		; ; DetectHiddenWindows, Off
	; return
; }

; #5::
; #6::
; #7::
; #8::
; #9::
	; return