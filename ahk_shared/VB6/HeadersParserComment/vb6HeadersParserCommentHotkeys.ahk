/*
Author: Gavin Borg
Description: Adds a number of shortcuts for VB6.
Installation: Copy this containing folder (HeadersParserComment) to your desktop and run the .ahk file within.
Shortcuts:
	Ctrl+Y/Ctrl+Shift+Z: 
		These will now “redo”. This was created because by default, Ctrl+Y cuts a line.
	Ctrl+M:
		Makes the current control. Uses the File->Make… item.
	Ctrl+Shift+H:
		Opens the Epic Headers popup found in Add-ins->Epic Headers.
	Ctrl+Shift+P:
		Opens the Epic VBParse popup found in Add-ins->Epic VBParse.
	Ctrl+Shift+R:
		Opens the references window. Note that the references window opens slowly.
	Ctrl+Semicolon:
		Comments the current line or selected block of code. Note that the comment button (see screenshot in folder) must be visible.
	Ctrl+Shift+Semicolon:
		Uncomments the current line or selected block of code. Note that the uncomment button (see screenshot in folder) must be visible.
Notes:
	If you run VB6 as an admin, you need to also run AutoHotkey.exe (typically in C:\Program Files\AutoHotkey\) as an admin as well.
		Failing to do so will result in this script not appearing to work at all.
	The commenting hotkeys will only work if the toolbar buttons that they use are visible onscreen, as this script actually pushes them.
	If only the commenting hotkeys don't work, you may need to take new screenshots for those two toolbar buttons and replace the ones in the folder (the folder on your desktop, that is, not the server folder).

*/

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force  ; Ensures that if this script is running, running it again replaces the first instance.
; #NoTrayIcon  ; Uncomment to hide the tray icon.

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
		ImageSearch, outX, outY, 0, 0, width, height, *TransWhite %imagePath%
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