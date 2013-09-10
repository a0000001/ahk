#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

; Completely neuter the caps lock, including all modifier key combos.
CapsLock::
	SetCapsLockState, off
return

^CapsLock::
	SetCapsLockState, off
return

^+CapsLock::
	SetCapsLockState, off
return

#CapsLock::
	SetCapsLockState, off
return

!CapsLock::
	SetCapsLockState, off
return

+CapsLock::
	SetCapsLockState, off
return