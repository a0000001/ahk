; Debugger object and functions.

; Common Includes
global debugBorgReadINI
global debugCommonVariables
global debugData
global debugDebug
global debugEpic
global debugGraphics
global debugIO
global debugNumber
global debugPrivateVariables
global debugRunCommands
global debugSelector
global debugSelectorActions
global debugSelectorActionsPrivate
global debugSelectorRow
global debugString
global debugTableList
global debugTableListRow
global debugTray
global debugWindow

; Program Specific
global debugChrome
global debugEpicStudio
global debugExcel
global debugFoobar
global debugFreeCommander
global debugHyperspace
global debugNotepad
global debugNotepadPP
global debugOneNote
global debugOutlook
global debugPowerPoint
global debugReflections
global debugRemoteDesktop
global debugSites
global debugSkype
global debugSumatraPDF
global debugTortoiseSVN
global debugVB6
global debugVLC
global debugWord

; Standalone
global debugExternalProgramLauncher
global debugGitHelper
global debugKillUAC
global debugTimer
global debugVimBindings
global debugSetup

; System
global debugHotstrings
global debugInput
global debugKDEMoverSizer
global debugMedia
global debugMouse
global debugMouseWheelEmulator
global debugProgramLauncher
global debugScreen
global debugVolume

class DEBUG {
	; -- Enabled/disabled flags. -- ;
	
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
	; static gitHelper := true
	; static killUAC := true
	; static timer := true
	; static vimBindings := true
	; static setup := true
	
	; - System - ;
	
	; static hotstrings := true
	; static input := true
	; static kdeMoverSizer := true
	; static media := true
	; static mouse := true
	; static mouseWheelEmulator := true
	; static programLauncher := true
	; static screen := true
	; static volume := true
	
	
	
	string1(on, var, label = "", numTabs = 0, child = true) {
		if(on) {
			outStr := ""
			varSize := var.MaxIndex()
			
			; Label.
			if(label) {
				outStr .= label
				if(varSize)
					outStr .= " (" varSize ")"
				else
					outStr .= ":"
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
					outStr .= getTabs(numTabs) "[" i "] " this.string1(on, v, "", numTabs) "`n"
			}
			
			; MsgBox, % outStr
			
			return outStr
		}
	}
	
	stringV(on, numTabs, params*) {
		if(on)
			return this.stringMultiHelper(params, numTabs)
	}
	
	; Takes in the arrays from stringV and popupV and does multiple strings.
	stringMultiHelper(params, numTabs = 0) {
		outStr := ""
		paramsLen := params.MaxIndex()
		; MsgBox, % paramsLen
		
		i := 1
		while(i <= paramsLen) {
			outStr .= this.string1(true, params[i], params[i + 1], numTabs, false) "`n"
			i += 2
		}
		
		return outStr
	}
	
	; popup(on, var, label = "") {
		; if(on) {
			; MsgBox, % this.string1(on, var, label, 0, false)
		; }
	; }
	
	popup(on, params*) {
		if(on)
			MsgBox, % this.stringMultiHelper(params)
	}
}
