#IfWinActive, ahk_class wndclass_desked_gsk
	; Create all required procedure stubs from an interface.
	^+f::
		ControlGet, CurrentProcedure, List, Selected, ComboBox1
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
			ControlFocus, ComboBox1, A
			Send, {Down}
			Sleep, 100
			
			ControlGet, ObjectList, List, , ComboBox1
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
			
			Control, Choose, %classRow%, ComboBox1, A
		}
		
		LastItem := ""
		SelectedItem := ""
		
		; ComboBox1, ComboBox2
		
		ControlFocus, ComboBox2, A
		Send, {Down}
		
		Sleep, 100
		
		ControlGet, List, List, , ComboBox2
		
		; MsgBox, % List
		
		RegExReplace(List, "`n", "", countNewLines)
		
		; MsgBox, % countNewLines
		
		countNewLines++
		
		Loop %countNewLines% {			
			; MsgBox, % A_Index
			
			ControlFocus, ComboBox2, A
			Control, Choose, %A_Index%, ComboBox2, A
		}
	return
	
	
#IfWinActive