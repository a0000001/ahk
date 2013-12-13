SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force  ; Ensures that if this script is running, running it again replaces the first instance.
; #NoTrayIcon  ; Uncomment to hide the tray icon.

#Include commonIncludesStandalone.ahk

; Tray icon setup.
global suspended := 0
; v := Object()
; v[0] := "suspended"
; m := Object()
; m[0] := "..\CommonIncludes\Icons\turtle.ico"
; m[1] := "..\CommonIncludes\Icons\turtleRed.ico"
; setupTrayIcons(v, m)

#Include Standalone\epic_FunctionHotstringsWithoutLibs.ahk
#Include Standalone\epic_FunctionHotstringsWithLibs.ahk

~!#x::
	Suspend, Toggle
	suspended := !suspended
	; updateTrayIcon()
return