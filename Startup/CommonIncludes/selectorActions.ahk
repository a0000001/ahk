; Holds how to do selector actions.

; Special debug case, triggered by +d keyword before choice: copy result to clipboard, plus debug pop it up.
DEBUG_POPUP_COPY(actionRow, result = "") {
	if(!result)
		result := actionRow.action
	
	DEBUG.popup(actionRow, "Row", result, "Result")
}

; For functional use: return.
RET(actionRow) {
	if(actionRow.isDebug) {
		DEBUG_POPUP_COPY(actionRow)
		return
	}
	
	return actionRow.action
}

; Run the action.
DO(actionRow) {
	if(actionRow.isDebug) {
		DEBUG_POPUP_COPY(actionRow)
		return
	}
	
	Run, % actionRow.action
}
	
; Run the action, waiting for it to finish.
DO_WAIT(actionRow) {
	if(actionRow.isDebug) {
		DEBUG_POPUP_COPY(actionRow)
		return
	}
	
	RunWait, % actionRow.action
}

; Just send the text of the action.
PASTE(actionRow) {
	if(actionRow.isDebug) {
		DEBUG_POPUP_COPY(actionRow)
		return
	}
	
	SendRaw, % actionRow.action
}

; Send the text of the action and press enter.
PASTE_SUBMIT(actionRow) {
	if(actionRow.isDebug) {
		DEBUG_POPUP_COPY(actionRow)
		return
	}
	
	SendRaw, % actionRow.action
	Send, {Enter}
}

; Pop up a message box.
POPUP(actionRow) {
	if(actionRow.isDebug) {
		DEBUG_POPUP_COPY(actionRow)
		return
	}
	
	MsgBox, % actionRow.action
}

; Debug.
DEBUG_POPUP(actionRow) {
	if(actionRow.isDebug) {
		DEBUG_POPUP_COPY(actionRow)
		return
	}
	
	DEBUG.popup(actionRow, "Row")
}

; Run given file with a POPUP action. Yes, this is getting rather meta.
TEST(actionRow) {
	if(actionRow.isDebug) {
		DEBUG_POPUP_COPY(actionRow)
		return
	}
	
	Run, % "select.ahk " actionRow.action " DEBUG_POPUP"
}

; Change a value in an ini file.
INI_WRITE(actionRow) {
	offStrings := ["o", "f", "off", "0"]
	
	if(actionRow.data[4]) {
		file := actionRow.data[4]
		sect := actionRow.data[3]
		key := actionRow.data[2]
		val := actionRow.data[1]
		
	; Special debug case - key from name, value from arbitrary end.
	} else {
		file := actionRow.data[2]
		sect := actionRow.data[1]
		key := actionRow.name
		val := !contains(offStrings, actionRow.userInput)
	}
	
	if(!val) { ; Came from post-pended arbitrary piece.
		if(actionRow.isDebug) {
			DEBUG_POPUP_COPY(actionRow, "IniDelete, " file ", " sect ", " key)
			return
		}
		
		IniDelete, %file%, %sect%, %key%
	} else {
		if(actionRow.isDebug) {
			DEBUG_POPUP_COPY(actionRow, "IniWrite, " val ", " file ", " sect ", " key)
			return
		}
		
		IniWrite, %val%, %file%, %sect%, %key%
	}
	
	; DEBUG.popup(actionRow, "Row", file, "File", sect, "Section", key, "Key", val, "Value")
}