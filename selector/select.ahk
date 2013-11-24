#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include selector.ahk

filePath = %1%
actionType = %2%
silentChoice = %3%
launchSelector(filePath, actionType, silentChoice)