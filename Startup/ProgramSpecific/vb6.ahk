#IfWinActive, ahk_class wndclass_desked_gsk

	; Redo, not yank.
	^y::
	^+z::
		Send, !e
		Sleep, 100
		Send, r
	return
	
	; Stop when running.
	F12::
		Send, !r
		Sleep, 100
		Send, e
	return
	
	; Options.
	$!o::
		Send, {Blind}t ; Because it's an ALT+ hotkey, alt coming up prematurely disrupted the selection. So, just use the alt already down.
		Sleep, 250
		Send, o
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
		Send, {Click}
		MouseMove, prevX, prevY
		
		; Restore this for other scripts' sake.
		CoordMode, Mouse, Screen
	}
	
	getSelectedText() {
		ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
		
		; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
		Clipboard := ; Clear the clipboard
		
		Send, ^c
		Sleep, 100
		
		textFound := clipboard
		
		Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
		ClipSaved =   ; Free the memory in case the clipboard was very large.
		
		return textFound
	}
	
	^`;::
		ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbCommentToolbarButton.png")
	return
	
	^+`;::
		ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbUncommentToolbarButton.png")
	return
	
	^+c::
		foundText := getSelectedText()
		if (foundText = "") { ; Guarenteed single-line deal.
			
			; Select the first part of the string, to see if there's a comment character at the 
			; beginning, and to keep track of where we are so we can put the cursor back.
			Send, {Shift Down}{Home}{Shift Up}
			firstPart := getSelectedText()
			
			; Test the first character.
			if(SubStr(firstPart, 1, 1) = "'") {
				; MsgBox, commented!
				ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbUncommentToolbarButton.png")
				
			} else {
				; MsgBox, not commented.
				ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbCommentToolbarButton.png")
			}
			
			Send, {Right} ; Unhighlight what we just selected, leaving their cursor where it was previously.
			
		} else { ; Could be either, but we can look at what we've got to tell.
			newLinePos := InStr(foundText, "`n")
			if(newLinePos = 0) {
				; MsgBox, single line.
				
				; Get out of the highlight first.
				Send, {Right}
				
				; Select the first part of the string, to see if there's a comment character at the 
				; beginning, and to keep track of where we are so we can put the cursor back.
				Send, {Shift Down}{Home}{Shift Up}
				firstPart := getSelectedText()
				
				; Test the first character.
				if(SubStr(firstPart, 1, 1) = "'") {
					; MsgBox, commented!
					ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbUncommentToolbarButton.png")
					
				} else {
					; MsgBox, not commented.
					ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbCommentToolbarButton.png")
				}
				
				; Calculate the distance to get back to the original highlight, and do so.
				; firstPartLen := StrLen(firstPart)
				foundTextLen := StrLen(foundText)
				; MsgBox, % foundTextLen
				
				Send, {Right}{Shift Down}{Left %foundTextLen%}{Shift Up}
				
			} else {
				; MsgBox, multi line.
				if(SubStr(foundText, newLinePos+1, 1)) = "'" {
					; MsgBox, commented!
					ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbUncommentToolbarButton.png")
				} else {
					; MsgBox, not commented.
					ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbCommentToolbarButton.png")
				}
			}
		}
	return
	
	; Hotkeys for adding elements to form.
	^+l::ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbLabelToolbarButton.png")
	^+t::ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbTextboxToolbarButton.png")
	^+b::ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbCommandButtonToolbarButton.png")
	^+s::ClickWhereFindImage("C:\Users\gborg\ahk\Images\vbShapeToolbarButton.png")
	
#IfWinActive