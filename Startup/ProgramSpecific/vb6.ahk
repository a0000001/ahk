#IfWinActive, ahk_class wndclass_desked_gsk
	
	; TLG Hotkey.
	^t::
		Send, %epicID%
	return
	
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
	
	; Make hotkey (Group)
	^+m::
		Send, !f
		Sleep, 100
		Send, g
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
	
	; Components window.
	$^r::
		Send, ^t
	return
	
	
	; Show/hide project explorer.
	$F1::
		DetectHiddenText, Off
		
		If(WinActive("", "Project - ") || WinActive("", "Project Group - ")) {
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
	
	; Comment/uncomment hotkeys.
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
				ControlGetPos, x, y, w, h, %A_LoopField%, A
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
	
	^!h::
		WinGet, List, ControlList, A
		
		; MsgBox, % List
		
		Loop, Parse, List, `n  ; Rows are delimited by linefeeds (`n).
		{
			; MsgBox, %A_LoopField%
			if(InStr(A_LoopField, "ComboBox")) {
				; MsgBox %className% is on row #%A_Index%.
				; classRow := A_Index
				; break
				ControlGetPos, x, y, w, h, %A_LoopField%, A
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
		
	; return
		
		objectComboClass := fieldNamePast
		procedureComboClass := fieldName
		
		objectComboValue := ""
		objectComboValuePast := ""
		procedureComboValue := ""
		procedureComboValuePast := ""
		
		; Module header.
		Send, !a
		Send, {Up}{Enter}
		WinWait, Epic Header Add-In
		Send, !m
		Sleep, 100
		
		Loop {
			Send, ^{Down}
			Sleep, 100
			
			ControlGetText, objectComboValue, %objectComboClass%, A
			ControlGetText, procedureComboValue, %procedureComboClass%, A
			; MsgBox, % objectComboValue . " " . procedureComboValue
			
			if(objectComboValue = objectComboValuePast && procedureComboValue = procedureComboValuePast) {
				break
			}
			procedureComboValuePast := procedureComboValue
			objectComboValuePast := objectComboValue
			
			; Add the header.
			Send, !a
			Send, {Up}{Enter}
			WinWait, Epic Header Add-In
			Send, !p
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

; Finds and checks a single reference.
findReferenceLine(lineToFind, numToMatch = 0) {
	prevRow := ""
	numSame := 1
	foundPage := false
	
	firstChar := SubStr(lineToFind, 1, 1)
	; MsgBox, % firstChar . "`n" . lineToFind
	
	; If what we're currently on is after what we want, start at the top.
	ControlGetText, currRow, Button5, A
	if(lineToFind < currRow, 1, StrLen(lineToFind)) {
		Send, {Home}
	}
	
	; Start with the first letter of the given input.
	SendRaw, %firstChar%
	
	; Loop downwards over the listbox - first by page, then by line.
	Loop {
		; Take a step down.
		if(!foundPage) {
			Send, {PgDn}
		} else {
			Send, {Down}
		}
		
		; Grab current item's identity.
		Sleep, 1
		ControlGetText, currRow, Button5, A
		; MsgBox, %currRow%
		
		; Trim it down to size to allow partial matching.
		currRow := SubStr(currRow, 1, StrLen(lineToFind))
		; MsgBox, %currRow%
		
		; Just in case we hit the end of the listbox: if we see the same row VB_REF_SAME_THRESHOLD times, finish.
		if(currRow = prevRow) {
			numSame++
		} else {
			numSame := 1
		}
		; MsgBox, Row: %currRow% `nPrevious: %prevRow% `nnumSame: %numSame%
		if(numSame = VB_REF_SAME_THRESHOLD) {
			return false
		}
		prevRow := currRow
		
		; If it matches our input, finish.
		if(lineToFind = currRow) {
			; If we've got the additional argument, push down a few more before selecting.
			if(numToMatch) {
				numToMatch-- ; We're given the index, not the number of times we need to go down.
				Send, {Down %numToMatch%}
			}
			
			; Check and finish.
			Send, {Space}
			return true
		
		; If we overshot it, back up a page and start going by single rows.
		} else if(currRow > lineToFind) {
			; MsgBox, %currRow% %lineToFind%
			
			; If we overshot it for the first time, go back a page and go by rows.
			if(!foundPage) {
				Send, {PgUp}
				foundPage := true
			
			; If we overshot once already, it's not here.
			} else {
				return false
			}
		}
	}
}

convertStarToES(string) {
	StringReplace, string, string, * , Epic Systems , All
	; MsgBox, % string
	return string
}

; References window.
#IfWinActive, References - 
	^f::
		; Get user input.
		InputBox, userIn, Partial Search, Please enter the first portion of the row to find. You may replace "Epic Systems " with "* "
		if(ErrorLevel) {
			return
		}
		
		; Expand it as needed.
		userIn := convertStarToES(userIn)
		
		; Crawl the list and check it.
		if(!findReferenceLine(userIn)) {
			MsgBox, Reference not found in list!
		}
	return

	^a::
		; Get user input.
		FileSelectFile, fileName
		
		; Read in the list of names.
		referenceLines := fileLinesToArray(fileName)
		
		; Parse the list into nice, uniform reference lines.
		references := cleanParseList(referenceLines)
		
		textOut := ""
		refsLen := references.MaxIndex()
		Loop, %refsLen% {
			textOut .= references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM] . "`n"
			; MsgBox, % references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM]
			findReferenceLine(references[A_Index, LIST_ITEM], references[A_Index, LIST_NUM])
		}
		
		MsgBox, Selected References: `n`n%textOut%
	return
#IfWinActive