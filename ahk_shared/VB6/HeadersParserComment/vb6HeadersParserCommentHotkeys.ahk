#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

#IfWinActive, ahk_class wndclass_desked_gsk
	
	; Redo, not yank.
	^y::
	^+z::
		Send, !e
		Sleep, 100
		Send, r
	return
	
	; Make hotkey.
	^m::
		Send, !f
		Sleep, 100
		Send, k
	return
	
	; Epic Headers Addin.
	^+h::
		Send, !a
		Sleep, 100
		Send, {Up}{Enter}
	return
	
	; Epic VB Parse Addin.
	^+p::
		Send, !a
		Sleep, 100
		Send, {Up 2}{Enter}
	return
	
	; References window.
	^+r::
		Send, !p
		Sleep, 100
		Send, n
	return
	
	^`;::
		ClickWhereFindImage("vbCommentToolbarButton.png")
	return
	
	^+`;::
		ClickWhereFindImage("vbUncommentToolbarButton.png")
	return
	
	ClickWhereFindImage(imagePath) {
		WinGetPos, X, Y, width, height, A
		ImageSearch, outX, outY, 0, 0, width, height, %imagePath%
		; MsgBox, % outX " " outY " " ErrorLevel
		
		; ImageSearch gives us back x and y based on the current window, so the mouse should move based on that, too.
		CoordMode, Mouse, Relative
		
		; Store the old mouse position to move back to once we're finished.
		MouseGetPos, prevX, prevY
		
		; Move, click the button, move back.
		MouseMove, outX, outY
		Click
		MouseMove, prevX, prevY
		
		; Restore this for other scripts' sake.
		CoordMode, Mouse, Screen
	}
	
#IfWinActive