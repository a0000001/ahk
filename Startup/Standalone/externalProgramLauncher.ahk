; Activate/Launch/Minimize Hotkeys.

#SingleInstance force
#NoTrayIcon

#Include iniReadStandalone.ahk

#Include ..\CommonIncludes\commonVariables.ahk
#Include ..\CommonIncludes\window.ahk

programToLaunch = %1%

; Slap the given string onto the end of our variable base to make the full variable
programClass := "pLaunchClass_"programToLaunch
programPath := "pLaunchPath_"programToLaunch

; MsgBox, % programPath
; MsgBox, % pLaunchPath_Onenote

activateOpenMinimize(%programClass%, %programPath%)

; ; Catch keyboard sends.
; ^#1::activateOrOpen("CabinetWClass", "C:\Windows\explorer.exe")
; ^#2::activateOrOpen("{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}", "C:\Program Files (x86)\foobar2000\foobar2000.exe")
; ^#3::activateOrOpen("WindowsForms10.Window.8.app.0.2bf8098_r13_ad1", "C:\Program Files (x86)\EpicStudio\EpicStudio.exe")
; ^#4::activateOrOpen("Notepad++", "C:\Program Files (x86)\Notepad++\notepad++.exe")
; ^#5::activateOrOpen("Framework::CFrame", "C:\Program Files (x86)\Microsoft Office\Office14\ONENOTE.EXE")

; if(programToLaunch = "Chrome") {
	; activateOrOpen("Chrome_WidgetWin_1", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
; } else if (programToLaunch = "Everything") {
	; activateOrOpen("EVERYTHING", "C:\Program Files (x86)\Everything\Everything.exe")
; } else if (programToLaunch = "Outlook") {
	; activateOrOpen("rctrl_renwnd32", "C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE")
; } else if (programToLaunch = "Explorer") {
	; activateOrOpen("CabinetWClass", "C:\Windows\explorer.exe")
; } else if (programToLaunch = "Foobar") {
	; activateOrOpen("{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}", "C:\Program Files (x86)\foobar2000\foobar2000.exe")
; } else if (programToLaunch = "EpicStudio") {
	; activateOrOpen("WindowsForms10.Window.8.app.0.2bf8098_r13_ad1", "C:\Program Files (x86)\EpicStudio\EpicStudio.exe")
; } else if (programToLaunch = "Notepad++") {
	; activateOrOpen("Notepad++", "C:\Program Files (x86)\Notepad++\notepad++.exe")
; } else if (programToLaunch = "Onenote") {
	; activateOrOpen("Framework::CFrame", "C:\Program Files (x86)\Microsoft Office\Office14\ONENOTE.EXE")
; }

