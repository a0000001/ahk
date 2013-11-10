; == Script setup. == ;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On

; Tray icon setup.
; #NoTrayIcon

; State flags.
global suspended := 0

; Mapping for what states make which tray icons.
v := Object()
v[0] := "suspended"
m := Object()
m[0] := borgIconPath
m[1] := borgIconPathStopped

setupTrayIcons(v, m)

; Menu, Tray, Icon, %borgIconPath%
; activeTrayIcon := true
; Menu, Tray, icon, , , 1 ; Keep suspend from changing it to the AHK default.