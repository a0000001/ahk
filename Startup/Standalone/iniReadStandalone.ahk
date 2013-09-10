; Constants for machines.
THINKPAD := 1
EPIC_DESKTOP := 2

; Get the argument that says which computer we're on, and run certain things accordingly.
; IniRead, machineName, F:\personal\gborg\ahk\Startup\borg.ini, Main, MachineName
IniRead, machineName, ..\borg.ini, Main, MachineName
if(machineName = "THINKPAD") {
	borgWhichMachine := THINKPAD
} else if(machineName = "EPIC_DESKTOP") {
	borgWhichMachine := EPIC_DESKTOP
}

; borgWhichMachine := THINKPAD
; MsgBox, % machineName
; MsgBox, % borgWhichMachine