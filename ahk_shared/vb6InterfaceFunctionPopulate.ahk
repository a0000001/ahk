#IfWinActive, ahk_class wndclass_desked_gsk

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