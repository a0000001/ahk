; === Scripts which run independently, but should still be started/reloaded with this one. === ;

; Not needed except on Epic machine.
if(borgWhichMachine = EPIC_DESKTOP) {
	Run, Standalone\killUAC.ahk
	Run, Standalone\tortoiseSVN_dlgFiller.ahk
}

Run, Standalone\vimBindings3.ahk