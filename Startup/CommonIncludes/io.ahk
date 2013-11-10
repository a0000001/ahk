; Functions related to file input/output and user input.

; Read in a file and return it as an array.
fileLinesToArray(fileName) {
	lines := Object()
	
	Loop Read, %fileName% 
	{
		lines[A_Index] := A_LoopReadLine
		lines[0] := A_Index
	}
	
	return lines
}

; Get text from a control, send it to another, and focus a third.
ControlGet_Send_Return(fromControl, toControl, retControl = "") {
	ControlGetText, data, %fromControl%, A
	; MsgBox, %data%
	ControlSend_Return(toControl, data, retControl)
}

; Send text to a particular control, then focus another.
ControlSend_Return(toControl, keys, retControl = "") {
	if(!retControl) {
		ControlGetFocus, retControl, A
	}
	; MsgBox, %retControl%
	
	; MsgBox, %toControl%
	if(toControl) {
		ControlFocus, %toControl%
	}
	
	; MsgBox, %keys%
	Sleep, 100
	Send, %keys%
	Sleep, 100
	ControlFocus, %retControl%, A
}

; Allows SendRaw'ing of input with tabs to programs which auto-indent text.
sendRawWithTabs(input) {
	; Split the input text on newlines, as that's where the tabs will be an issue.
	Loop, Parse, input, `n, `r  ; Specifying `n prior to `r allows both Windows and Unix files to be parsed.
	{
		; Get how many tabs we're dealing with while also pulling them off.
		currLine := A_LoopField
		numTabs := 0
		while SubStr(currLine, 1, 1) = A_Tab
		{
			; MsgBox, Before: %currLine% %numTabs%
			numTabs++
			StringTrimLeft, currLine, currLine, 1
			; MsgBox, After: %currLine% %numTabs%
		}
		
		Send, {Tab %numTabs%}
		SendRaw, %currLine%
		Send, {Enter}
		Send, +{Tab %numTabs%}
	}
}

; Grabs the selected text using the clipboard, fixing the clipboard as it finishes.
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

; Grabs the selected text using the clipboard, fixing the clipboard as it finishes.
sendTextWithClipboard(text) {
	; MsgBox, %text%
	
	ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
	Clipboard := "" ; Clear the clipboard
	
	Clipboard := text
	Sleep, 100
	Send, ^v
	Sleep, 100
	
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved =   ; Free the memory in case the clipboard was very large.
}