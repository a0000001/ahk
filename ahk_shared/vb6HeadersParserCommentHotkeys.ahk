#IfWinActive, ahk_class wndclass_desked_gsk
	
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
	
	^`;::
		ClickWhereFindImage("F:\personal\gborg\ahk\Images\vbCommentToolbarButton.png")
	return
	
	^+`;::
		ClickWhereFindImage("F:\personal\gborg\ahk\Images\vbUncommentToolbarButton.png")
	return
	
#IfWinActive