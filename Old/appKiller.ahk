; No longer really needed.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon
#Persistent

; App closer: for killing memory-hog apps or for clearing running programs.
^!#x::
	;WinClose, ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}
	Process, Close, Skype.exe
	Process, Close, miranda32.exe
return