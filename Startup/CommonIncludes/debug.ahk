; Debugger object and functions.

class DEBUG {
	; -- Enabled/disabled flags. -- ;
	
	; - Common Includes. - ;
	
	; static borgReadINI := true
	; static commonVariables := true
	; static data := true
	; static debug := true
	; static graphics := true
	; static io := true
	; static privateVariables := true
	; static runAsAdmin := true
	; static selector := true
	; static selectorRow := true
	; static stringDB := true ; Special because of string function below.
	; static tableList := true
	; static tableListRow := true
	; static tray := true
	; static window := true
	
	; - Programs - ;
	
	; static chrome := true
	; static epicStudio := true
	; static excel := true
	; static foobar := true
	; static freeCommander := true
	; static hyperspace := true
	; static notepad := true
	; static notepadPP := true
	; static onenote := true
	; static outlook := true
	; static powerpoint := true
	; static reflections := true
	; static remoteDesktop := true
	; static sites := true
	; static skype := true
	; static sumatraPDF := true
	; static tortoiseSVN := true
	; static vb6 := true
	; static vlc := true
	; static word := true
	
	; - Standalone - ;
	
	; static externalProgramLauncher := true
	; static killUAC := true
	; static timer := true
	; static vimBindings := true
	
	; - System - ;
	
	; static hotstrings := true
	; static input := true
	; static kdeMoverSizer := true
	; static media := true
	; static mouseWheelEmulator := true
	; static programLauncher := true
	; static screen := true
	; static volume := true
	; static windowDB := true ; Different because there's also a common include with this name.
	
	
	
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
