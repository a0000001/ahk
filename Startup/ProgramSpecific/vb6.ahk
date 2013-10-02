#IfWinActive, ahk_class wndclass_desked_gsk

	; Redo, not yank.
	^y::
	^+z::
		Send, !e
		Sleep, 100
		Send, r
	return
	
	; Show/hide project explorer.
	$F1::
		DetectHiddenText, Off
		
		If(WinActive("", "Project - ")) {
			good := ClickWhereFindImage(iSearchPath_vbGenericClose, iSearchClass_vbProjectExplorer)
			
			if(!good) {
				MsgBox, Not Found...
			}
		} else {
			Send, ^r
		}
		
		DetectHiddenText, On
	return
	
	; Show/hide properties sidebar.
	$F4::
		DetectHiddenText, Off
		
		If(WinActive("", "Properties - ")) {
			good := ClickWhereFindImage(iSearchPath_vbGenericClose, iSearchClass_vbPropertiesSidebar)
			
			if(!good) {
				MsgBox, Not Found...
			}
		} else {
			Send, {F4}
		}
		
		DetectHiddenText, On
	return
	
	; Show/hide toolbox bar.
	$F3::
		DetectHiddenText, Off
		
		If(toggleToolbox) {
			toggleToolbox := false
			
			good := ClickWhereFindImage(iSearchPath_vbGenericClose, iSearchClass_vbToolbarPalette)
			
			if(!good) {
				MsgBox, Not Found...
			}
		} else {
			toggleToolbox := true
			
			Send, !v
			Sleep, 100
			Send, x
		}
		
		DetectHiddenText, On
	return
	
	; Code vs. design swap. Note: only works if mini-window within window is maximized within outer window.
	Pause::
		WinGetTitle, title
		; MsgBox, % title
		
		StringTrimRight, title, title, 2
		
		; MsgBox, % title
		
		; StringRight, title, title, 4
		parenPos := InStr(title, "(")
		StringTrimLeft, title, title, parenPos
		
		; MsgBox, % title
		
		if(title = "Code") {
			Send, +{F7}
		} else if(title = "Form" || title = "UserControl") {
			Send, {F7}
		}
	return
	
	; Stop when running.
	$F12::
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
	
	; References window.
	^+r::
		Send, !p
		Sleep, 100
		Send, n
	return
	
	FindImageCoordsWithinArea(imagePath, X, Y, W, H) {
		ImageSearch, outX, outY, X, Y, W, H, %imagePath%
		
		if(ErrorLevel = 0) { ; We found something, store and recurse!
			; CoordMode, Mouse, Relative
			; MouseMove, %outX%, %outY%
			; CoordMode, Mouse, Screen
			
			; MsgBox, %ErrorLevel% Found image at (%outX%, %outY%).
			
			outStr = %outX%-%outY%
			firstXY := FindImageCoordsWithinArea(imagePath, outX+1, outY, W, H)
			secondXY := FindImageCoordsWithinArea(imagePath, X, outY+1, outX, H)
			
			if(firstXY != "") {
				outStr = %outStr%.%firstXY%
			}
			
			if(secondXY != "") {
				outStr = %outStr%.%secondXY%
			}
		} else {
			outStr := ""
		}
		
		return outStr
	}
	
	ClickWhereFindImage(imagePath, nnClass = "") {
		WinGetPos, X, Y, width, height, A
		; MsgBox, %X% %Y%
		
		coords := FindImageCoordsWithinArea(imagePath, X, Y, width+X, height+Y)
		; MsgBox, % coords
		
		RegExReplace(coords, "\.", "", periodCount)
		coordsCount := periodCount + 1
		; MsgBox, % coordsCount
		
		; Split the coords into a 2-dimensional array. (pointNum, X/Y)
		StringSplit, splitCoords, coords, .
		Loop, %coordsCount% {
			StringSplit, splitCoords%A_Index%_, splitCoords%A_Index%, -
		}
		; MsgBox, % splitCoords1_1 " " splitCoords1_2
		
		; Store the old mouse position to move back to once we're finished.
		MouseGetPos, prevX, prevY
		
		; ImageSearch gives us back x and y based on the current window, so the mouse should move based on that, too.
		CoordMode, Mouse, Relative
			
		; Loop over the given coordinates, move the mouse there, and use mousegetpos to get the class of the control.
		Loop, %coordsCount% {
			MouseMove, splitCoords%A_Index%_1, splitCoords%A_Index%_2
			; MsgBox, % splitCoords%A_Index%_1 ", " splitCoords%A_Index%_2
			
			MouseGetPos, , , , controlNN
			; MsgBox, %imagePath% %ErrorLevel% %controlNN%
			
			; If it matches the given control, be done.
			if(controlNN = nnClass) {
				; MsgBox, % "Match found at " splitCoords%A_Index%_1 ", " splitCoords%A_Index%_2 "!"
				foundOne := true
				break
			}
		}
		
		; Restore this for other scripts' sake.
		CoordMode, Mouse, Screen
		
		if(foundOne) {
			; Click the control!
			Send, {Click}
		}
		
		; Move the mouse back to its former position.
		MouseMove, prevX, prevY
		
		return foundOne
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
		ClickWhereFindImage(iSearchPath_vbComment, iSearchClass_vbToolbar2)
	return
	
	^+`;::
		ClickWhereFindImage(iSearchPath_vbUncomment, iSearchClass_vbToolbar2)
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
				ClickWhereFindImage(iSearchPath_vbUncomment, iSearchClass_vbToolbar2)
				
			} else {
				; MsgBox, not commented.
				ClickWhereFindImage(iSearchPath_vbComment, iSearchClass_vbToolbar2)
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
					ClickWhereFindImage(iSearchPath_vbUncomment, iSearchClass_vbToolbar2)
					
				} else {
					; MsgBox, not commented.
					ClickWhereFindImage(iSearchPath_vbComment, iSearchClass_vbToolbar2)
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
					ClickWhereFindImage(iSearchPath_vbUncomment, iSearchClass_vbToolbar2)
				} else {
					; MsgBox, not commented.
					ClickWhereFindImage(iSearchPath_vbComment, iSearchClass_vbToolbar2)
				}
			}
		}
	return
	
	; Hotkeys for adding elements to form.
	^+l::ClickWhereFindImage(iSearchPath_vbToolboxLabel, iSearchClass_vbToolbarPalette)
	^+t::ClickWhereFindImage(iSearchPath_vbToolboxTextbox, iSearchClass_vbToolbarPalette)
	^+b::ClickWhereFindImage(iSearchPath_vbToolboxCommandButton, iSearchClass_vbToolbarPalette)
	^+s::ClickWhereFindImage(iSearchPath_vbToolboxShape, iSearchClass_vbToolbarPalette)
	^+e::ClickWhereFindImage(iSearchPath_vbToolboxChrontrol, iSearchClass_vbToolbarPalette)
		
	; Create all required procedure stubs from an interface.
	^+f::
		WinGet, List, ControlList, A
		
		; MsgBox, % List
		
		Loop, Parse, List, `n  ; Rows are delimited by linefeeds (`n).
		{
			if(InStr(A_LoopField, "ComboBox")) {
				; MsgBox %className% is on row #%A_Index%.
				; classRow := A_Index
				; break
				ControlGetPos, x, y, w, h, %A_LoopField%
				; MsgBox, %x% %y%
				
				; When two in a row have the same y value, they're what we're looking for.
				if(y = yPast) {
					; MsgBox, Got two! %x% %y% %yPast%
					fieldName := A_LoopField
					
					break
				}
				
				yPast := y
				fieldNamePast := A_LoopField
			}
		}
		
		; MsgBox, %fieldNamePast% %fieldName%
		
		
		
		ControlGet, CurrentProcedure, List, Selected, %fieldNamePast%
		; MsgBox, % CurrentProcedure
		
		; Allow being on "Implements ..." line instead of having left combobox correctly selected first.
		if(CurrentProcedure = "(General)") {
			ClipSave := clipboard ; Save the current clipboard.
			
			Send, {End}{Shift Down}{Home}{Shift Up}
			Send, ^c
			
			Sleep, 100 ; Allow clipboard time to populate.
			
			lineString := clipboard
			; MsgBox, % lineString
			
			clipboard := ClipSave ; Restore clipboard
			
			; Pull the class name from the implements statement.
			StringTrimLeft, className, lineString, 11
			
			; Trims trailing spaces via "Autotrim" behavior.
			className = %className%
			
			; MsgBox, z%className%z
			
			; Open the dropdown so we can see everything.
			ControlFocus, %fieldNamePast%, A
			Send, {Down}
			Sleep, 100
			
			ControlGet, ObjectList, List, , %fieldNamePast%
			; MsgBox, % ObjectList
			
			classRow := 0
			
			Loop, Parse, ObjectList, `n  ; Rows are delimited by linefeeds (`n).
			{
				if(A_LoopField = className) {
					; MsgBox %className% is on row #%A_Index%.
					classRow := A_Index
					break
				}
			}
			
			Control, Choose, %classRow%, %fieldNamePast%, A
		}
		
		LastItem := ""
		SelectedItem := ""
		
		ControlFocus, %fieldName%, A
		Send, {Down}
		
		Sleep, 100
		
		ControlGet, List, List, , %fieldName%
		
		; MsgBox, % List
		
		RegExReplace(List, "`n", "", countNewLines)
		
		; MsgBox, % countNewLines
		
		countNewLines++
		
		Loop %countNewLines% {			
			; MsgBox, % A_Index
			
			ControlFocus, %fieldName%, A
			Control, Choose, %A_Index%, %fieldName%, A
		}
	return
	
	
#IfWinActive

#IfWinActive, ahk_class #32770
	; TLG Hotkey.
	$^t::
		SetTitleMatchMode, 2
		
		if(WinActive(" - Project Properties")) { ; The ahk_class is shared among many, but I don't want it to work with all of them.
			Send, %epicID%
		} else {
			Send, ^t
		}
		
		SetTitleMatchMode, 1
	return
#IfWinActive