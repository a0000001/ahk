; ===== Inclusion of all AHK scripts for Borg. ===== ;


; Constants for machines.
THINKPAD := 1
EPIC_DESKTOP := 2

; Get the argument that says which computer we're on, and run certain things accordingly.
IniRead, machineName, borg.ini, Main, MachineName
if(machineName = "THINKPAD") {
	borgWhichMachine := THINKPAD
} else if(machineName = "EPIC_DESKTOP") {
	borgWhichMachine := EPIC_DESKTOP
}
; borgWhichMachine := THINKPAD
; MsgBox, % machineName
; MsgBox, % borgWhichMachine

; Standalone scripts. Must be first to execute.
#Include standalone.ahk

; Setup for this script.
#Include borgSetup.ahk

; Common functions, hotkeys, and other such setup. 
#Include commonIncludes.ahk

; Common setup for scripts. (Variables, etc.) Includes all auto-executing code.
#Include startup.ahk

; Must go after startup, but before hotkeys begin.
#Include System\hotstrings.ahk

; Begin hotkeys with borgScript-specific ones.
#Include borgHotkeys.ahk

; System-related hotkeys.
#Include system.ahk

; Program-specific hotkeys.
#Include programSpecific.ahk