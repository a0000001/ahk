; === Program-specific scripts.. === ;

#Include ProgramSpecific\chrome.ahk
#Include ProgramSpecific\cygwin.ahk

; Not used elsewhere.
if(borgWhichMachine = THINKPAD) {
	#Include ProgramSpecific\ditto.ahk
	#Include ProgramSpecific\eclipse.ahk
	#Include ProgramSpecific\fastStoneImageViewer.ahk
	#Include ProgramSpecific\pidgin.ahk
	#Include ProgramSpecific\skype.ahk
} else if(borgWhichMachine = EPIC_DESKTOP) {
	#Include ProgramSpecific\epicStudio.ahk
	
	#Include ProgramSpecific\hyperspace.ahk
	
	#Include ProgramSpecific\outlook.ahk
	#Include ProgramSpecific\reflections.ahk
}

; #Include ProgramSpecific\everything.ahk

#Include ProgramSpecific\excel.ahk
#Include ProgramSpecific\executor.ahk
#Include ProgramSpecific\explorer.ahk

#Include ProgramSpecific\foobar.ahk
#Include ProgramSpecific\notepad.ahk
#Include ProgramSpecific\notepad++.ahk
#Include ProgramSpecific\onenote.ahk

#Include ProgramSpecific\powerpoint.ahk
; #Include ProgramSpecific\processExplorer.ahk
#Include ProgramSpecific\remoteDesktop.ahk

#Include ProgramSpecific\sumatraPDF.ahk
#Include ProgramSpecific\word.ahk