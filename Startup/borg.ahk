; ===== Inclusion of all AHK scripts for Borg. ===== ;

; Initial check whether setup has been run.
if(!FileExist("borg.ini")) {
	MsgBox, Configuration file borg.ini does not exist! `n`nPlease run the setup script found in Setup\setup.ahk.
	ExitApp
}


; Common functions, hotkeys, and other such setup. 
#Include commonIncludes.ahk

; Standalone scripts. Must be first to execute so it can spin off and be on its own.
#Include standalone.ahk

; Setup for this script.
#Include borgSetup.ahk

; Setup for rest of scripts. (Variables, etc.) Includes all auto-executing code.
#Include startup.ahk

; Must go after startup, but before hotkeys begin.
#Include System\hotstrings.ahk

; Begin hotkeys with borgScript-specific ones.
#Include borgHotkeys.ahk

; System-related hotkeys.
#Include system.ahk

; Program-specific hotkeys.
#Include programSpecific.ahk