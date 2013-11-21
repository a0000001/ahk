SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force  ; Ensures that if this script is running, running it again replaces the first instance.
; #NoTrayIcon  ; Uncomment to hide the tray icon.

; Prompt the user for which computer this is.
;;; Call guiSelector as a function here, get it to return value as action?
;;; INI for computer list in this folder, then.
whichMachine := "EPIC_DESKTOP"

;; FileRead this in instead of hard-coding?
; Generate ..\borg.ini.
borgINI = 
(
[Main]
MachineName=
)
borgINI .= whichMachine
; MsgBox, z%borgINI%z

; Write borg.ini.
FileDelete, ..\borg.ini
FileAppend, %borgINI%, ..\borg.ini


; Using current absolute path, generate standalone common includes.
rootPath := ""




; Unzip all zipped files using .bat file.
Run, % rootPath "\selectorGUI\zipAll.bat"


ExitApp


; Exit, reload, and suspend.
~!+x::ExitApp
~#!x::Suspend
~!+r::
	Suspend, Permit
	Reload
return