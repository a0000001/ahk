﻿; Startup, auto-execute sections for all scripts.


; @Capslock Navigation.
SetCapsLockState, AlwaysOff
; @End Capslock navigation.


; @KDE Mover-Sizer.
SnapOnSizeEnabled := 1
SnapOnMoveEnabled := 1
SnapOnResizeMagnetic := 1
DoRestoreOnResize := 1
SnappingDistance := 10
WinDelay := 2

SetWinDelay, %WinDelay%
CoordMode,Mouse,Screen

MayToggle := true
; @End KDE Mover-Sizer.


; @Mouse wheel emulator.
#Persistent
Process, Priority, , Realtime

; Configuration
mouse_Threshold = 5 ; the number of pixels the mouse must move for a scroll tick to occur
scroll_Hotkey = MButton ; Hotkey to activate middle click or scrolling

;Create GUI to receive messages
Gui, +LastFound
hGui := WinExist()

;Intercept WM_INPUT messages
OnMessage(0x00FF, "InputMsg")

SetDefaultMouseSpeed, 0
scrollMode = 0 ; 0 = MouseClick, WheelUp/WheelDown, 1 = WM_VSCROLL/WM_HSCROLL, 2 = WM_MOUSEWHEEL/WM_HSCROLL
CoordMode, Mouse, Screen

HotKey, $MButton, scrollChord
HotKey, $MButton Up, scrollChord_Up
; @End mouse wheel emulator.


; @Office.
incrementor = 1
; @End office.


; @Foobar.
if(WinExist("ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}")) {
	; Setup Traymin.
	GoSub, TrayminOpen
	WinGet, foobarID, ID, ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}
	
	; Minimize foobar to tray.
	; WinTraymin(foobarID, 0)
}
; @End foobar.


; @MinToTray. To be used (above) in foobar. Not in original file because startup.ahk wigs out.
TrayminOpen:
	SetWinDelay, 0
	SetFormat, Integer, D
	CoordMode, Mouse, Screen
	DetectHiddenWindows On
	hAHK := WinExist("ahk_class AutoHotkey ahk_pid " . DllCall("GetCurrentProcessId"))
	ShellHook := DllCall("RegisterWindowMessage", "str", "SHELLHOOK")
	DllCall("RegisterShellHookWindow", "Uint", hAHK)
	OnExit, TrayminClose
return

TrayminClose:
	DllCall("DeregisterShellHookWindow", "Uint", hAHK)
	WinTraymin(0,-1)
	OnExit
	ExitApp
return
; @End MinToTray.