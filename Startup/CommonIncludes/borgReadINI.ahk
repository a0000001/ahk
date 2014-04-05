; Constants for machines.
global THINKPAD := "THINKPAD"
global EPIC_DESKTOP := "EPIC_DESKTOP"

; Constants for which key closes tabs with vimBindings.
global vimBindingsF9 := "F9"
global vimBindingsF6 := "F6"

; Get the argument that says which computer we're on, and run certain things accordingly.
IniRead, borgWhichMachine, %borgPathINI%, Main, MachineName

; Get the argument that says which key in vimBindings should close tabs.
IniRead, borgVimBindingsCloseKey, %borgPathINI%, Main, VimBindingsCloseKey
if(!borgVimBindingsCloseKey)
	borgVimBindingsCloseKey := vimBindingsF9

; ; Read in which debug flags should be on.
; IniRead, sectionList, ..\Startup\borg.ini, Debug
; Loop, Parse, sectionList, `n
; {
	; splitLine := specialSplit(A_LoopField, "=")
	; currKey := "debug" splitLine[1]
	; %currKey% := splitLine[2]
; }
; DEBUG.popup(debugBorgReadINI, sectionList, "Debug INI settings")

; borgWhichMachine := THINKPAD
; borgWhichMachine := vimBindingsF9
; DEBUG.popup(machineName, "Machine name", borgWhichMachine, "Borg which machine")
