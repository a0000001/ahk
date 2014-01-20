; Debugger object and functions.

class DEBUG {
	; enabled := false
	
	; __New(state = false) {
		; ; this.setEnabled(state)
		; ; MsgBox, % state
		; this.enabled := state
	; }
	
	; ; Setter for debug on/off flag.
	; setEnabled(state) {
		; this.enabled := state
	; }
	
	; ; Pops up a debug breakdown of the given variable.
	; ; debugPrint(var) {
	; popup(var, debugOn = true) {
		; if(debugOn) {
			; MsgBox, % this.string(var)
		; }
	; }

	; ; debugString(var, numTabs = 0) {
	; string(var, numTabs = 0, debugOn = true) {
		; if(debugOn) {
			; outStr := ""
			; varSize := var.MaxIndex()
			
			; if(IsObject(var) && IsFunc(var.toDebugString) && var.debugNoRecurse) {
				; return var.toDebugString(numTabs)
			
			; } else if(!varSize) {
				; ; MsgBox, var has no size.
				; return var
				
			; } else {
				; numTabs++
				
				; outStr .= "Size: " varSize "`n"
				; For i,v in var {
					; Loop, %numTabs%
						; outStr .= "`t"
					
					; outStr .= "[" i "] " this.string(v, numTabs) "`n"
				; }
				
				; return outStr
			; }
		; }
	; }
	
	string(var, label = "", debugOn = true, numTabs = 0, child = true) {
		if(debugOn) {
			outStr := ""
			varSize := var.MaxIndex()
			
			; Label.
			if(label) {
				outStr .= label
				if(varSize)
					outStr .= " (" varSize ")"
				outStr .= "`n"
				numTabs++
			} else if(varSize) {
				outStr .= "Array (" varSize ")`n"
				numTabs++
			}
			
			; Variable.
			if(IsObject(var) && IsFunc(var.toDebugString) && var.debugNoRecurse) {
				outStr .= getTabs(numTabs) var.toDebugString(numTabs)
			
			} else if(!varSize) {
				; MsgBox, var has no size. Should be string/number.
				
				if(!child)
					outStr .= getTabs(numTabs)
				
				outStr .= var
				
			} else {
				; MsgBox, % numTabs
				For i,v in var
					outStr .= getTabs(numTabs) "[" i "] " this.string(v, "", debugOn, numTabs) "`n"
			}
			
			; MsgBox, % outStr
			
			return outStr
		}
	}
	
	stringV(debugOn, numTabs, params*) {
		if(debugOn)
			return this.stringMultiHelper(params, numTabs)
	}
	
	; Takes in the arrays from stringV and popupV and does multiple strings.
	stringMultiHelper(params, numTabs = 0) {
		outStr := ""
		paramsLen := params.MaxIndex()
		; MsgBox, % paramsLen
		
		i := 1
		while(i <= paramsLen) {
			outStr .= this.string(params[i], params[i + 1], true, numTabs, false) "`n"
			i += 2
		}
		
		return outStr
	}
	
	popup(var, label = "", debugOn = true) {
		if(debugOn) {
			MsgBox, % this.string(var, label, debugOn, 0, false)
		}
	}
	
	popupV(debugOn, params*) {
		if(debugOn)
			MsgBox, % this.stringMultiHelper(params)
	}
}

; Standalone function for state changes.
; setDebug(state) {
	; DEBUG.enabled := state
; }
