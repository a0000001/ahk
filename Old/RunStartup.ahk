;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

; outdated by autoInclude.ahk.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

Run, appKiller.ahk
Run, capsKill.ahk
Run, digsby.ahk
Run, emailReminder.ahk
Run, everything.ahk
Run, explorer.ahk
Run, firefox.ahk
Run, foobar.ahk
Run, hotstrings.ahk
Run, notepad++.ahk
Run, reloadDropbox.ahk
Run, reminder.ahk
Run, sites.ahk
Run, statusSet.ahk
Run, system.ahk