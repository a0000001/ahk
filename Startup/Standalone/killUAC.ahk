; Disables UAC. Separate because requires admin previledges.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; #Include %A_ScriptDir%\..\CommonIncludes\runAsAdmin.ahk
#Include commonIncludesStandalone.ahk
; #Include ..\commonIncludesStandalone.ahk

RunAsAdmin()

windir = C:\windows

Run, C:\Windows\System32\cmd.exe /k %windir%\System32\reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f, , Min, pid

; MsgBox, % pid

Sleep, 500

WinClose, ahk_pid %pid%