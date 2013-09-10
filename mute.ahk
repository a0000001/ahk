#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
#SingleInstance force

; Mutes the volume using Caps Lock key.
CapsLock::Send {Volume_Mute}

; You can still use Caps Lock by using Shift + Caps Lock.
+CapsLock::CapsLock