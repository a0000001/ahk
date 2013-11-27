; Script used to call a standalone instance of the selector.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include ..\Startup\commonIncludesStandalone.ahk

filePath = %1%
actionType = %2%
silentChoice = %3%
select(filePath, actionType, silentChoice)

ExitApp


; Exit, reload, and suspend.
~!+x::ExitApp
~#!x::Suspend
~!+r::
	Suspend, Permit
	Reload
return