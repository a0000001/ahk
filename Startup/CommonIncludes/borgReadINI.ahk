; Constants for machines.
; global THINKPAD := 1
; global EPIC_DESKTOP := 2
global THINKPAD := "THINKPAD"
global EPIC_DESKTOP := "EPIC_DESKTOP"

; Constants for which key closes tabs with vimBindings.
global vimBindingsF9 := "F9"
global vimBindingsF6 := "F6"

; Get the argument that says which computer we're on, and run certain things accordingly.
; IniRead, machineName, %borgPathINI%, Main, MachineName
; if(machineName = "THINKPAD") {
	; borgWhichMachine := THINKPAD
; } else if(machineName = "EPIC_DESKTOP") {
	; borgWhichMachine := EPIC_DESKTOP
; }
IniRead, borgWhichMachine, %borgPathINI%, Main, MachineName

; Get the argument that says which key in vimBindings should close tabs.
IniRead, borgVimBindingsCloseKey, %borgPathINI%, Main, VimBindingsCloseKey
if(!borgVimBindingsCloseKey)
	borgVimBindingsCloseKey := vimBindingsF9

; borgWhichMachine := THINKPAD
; borgWhichMachine := vimBindingsF9
DEBUG.popup(DEBUG.borgReadINI, machineName, "Machine name", borgWhichMachine, "Borg which machine")