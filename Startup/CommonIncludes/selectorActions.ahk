; Holds how to do selector actions.

; For functional use: return.
RET(actionRow) {
	return actionRow.action
}

; Run the action.
DO(actionRow) {
	Run, % actionRow.action
}
	
; Run the action, waiting for it to finish.
DO_WAIT(actionRow) {
	RunWait, % actionRow.action
}

; Just send the text of the action.
PASTE(actionRow) {
	SendRaw, % actionRow.action
}

; Send the text of the action and press enter.
PASTE_SUBMIT(actionRow) {
	SendRaw, % actionRow.action
	Send, {Enter}
}

; Pop up a message box.
POPUP(actionRow) {
	MsgBox, % actionRow.action
}

; Debug.
DEBUG_POPUP(actionRow) {
	DEBUG.popup(true, actionRow, "Row")
}

; Run given file with a POPUP action. Yes, this is getting rather meta.
TEST(actionRow) {
	Run, % "select.ahk " actionRow.action " DEBUG_POPUP"
}

; Change a value in an ini file.
INI_WRITE(actionRow) {
	offStrings := ["o", "f", "off"]
	
	if(actionRow.data[4]) {
		file := actionRow.data[4]
		sect := actionRow.data[3]
		key := actionRow.data[2]
		val := actionRow.data[1]
		
		IniWrite, %val%, %file%, %sect%, %key%
	
	; Special debug case - key from name, value from arbitrary end.
	} else {
		file := actionRow.data[2]
		sect := actionRow.data[1]
		key := actionRow.name
		val := !contains(offStrings, actionRow.action)
		
		if(!val) { ; Came from post-pended arbitrary piece.
			IniDelete, %file%, %sect%, %key%
		} else {
			IniWrite, %val%, %file%, %sect%, %key%
		}
	}
	
	DEBUG.popup(DEBUG.selector, actionRow, "Row", file, "File", sect, "Section", key, "Key", val, "Value")
}