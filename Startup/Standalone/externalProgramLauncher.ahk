; Activate/Launch/Minimize Hotkeys.

#SingleInstance force
#NoTrayIcon

; #Include iniReadStandalone.ahk
; #Include ..\CommonIncludes\commonVariables.ahk
; #Include ..\CommonIncludes\window.ahk

#Include ..\commonIncludesStandalone.ahk

programToLaunch = %1%

; Slap the given string onto the end of our variable base to make the full variable
programClass := "pLaunchClass_"programToLaunch
programPath := "pLaunchPath_"programToLaunch

activateOpenMinimize(%programClass%, %programPath%)
