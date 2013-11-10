; Constants for machines.
global THINKPAD := 1
global EPIC_DESKTOP := 2

; Get the argument that says which computer we're on, and run certain things accordingly.
IniRead, machineName, %borgPathINI%, Main, MachineName
if(machineName = "THINKPAD") {
	borgWhichMachine := THINKPAD
} else if(machineName = "EPIC_DESKTOP") {
	borgWhichMachine := EPIC_DESKTOP
}
; borgWhichMachine := THINKPAD
; MsgBox, % machineName
; MsgBox, % borgWhichMachine