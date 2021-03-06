﻿; Icon path for main icons.
borgIconPath := "CommonIncludes\Icons\borg.ico"
borgIconPathStopped := "CommonIncludes\Icons\borgStopped.ico"


; ----- AHK Script-related things. ----- ;
ahkHeaderCode =
(
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir `%A_ScriptDir`%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force  ; Ensures that if this script is running, running it again replaces the first instance.
; #NoTrayIcon  ; Uncomment to hide the tray icon.
)

ahkDefaultHotkeys = 
(
; Exit, reload, and suspend.
~!+x::ExitApp
~#!x::Suspend
^!r::
	Suspend, Permit
	Reload
return
)


; ----- Other arbitrary constants. ----- ;
if(borgWhichMachine = THINKPAD) {
	chrome_TopHeight := 90
	cygwinHomePath := "C:\cygwin\home\gborg\"
} else if(borgWhichMachine = EPIC_DESKTOP) {
	chrome_TopHeight := 100
	cygwinHomePath := "C:\cygwin64\home\gborg\"
}


; ----- Program launcher classes and strings. ----- ;
pLaunchClass_Chrome := "Chrome_WidgetWin_1"
pLaunchPath_Chrome := "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

pLaunchClass_Everything := "EVERYTHING"
pLaunchPath_Everything := "C:\Program Files (x86)\Everything\Everything.exe"

pLaunchClass_Outlook := "rctrl_renwnd32"
pLaunchPath_Outlook := "C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE /recycle"

pLaunchClass_ProcessExplorer := "PROCEXPL"
if(borgWhichMachine = THINKPAD) {
	pLaunchPath_ProcessExplorer := "C:\Program Files\ProcessExplorer\procexp.exe"
} else if(borgWhichMachine = EPIC_DESKTOP) {
	pLaunchPath_ProcessExplorer := "C:\Program Files (x86)\ProcessExplorer\procexp.exe"
} else if(borgWhichMachine = BORG_ASUS) {
	pLaunchPath_ProcessExplorer := "C:\Program Files (x86)\Process Explorer\procexp.exe"
}

pLaunchClass_Executor := "{NAME} Executor"
if(borgWhichMachine = BORG_ASUS) {
	pLaunchPath_Executor := "C:\Program Files\Executor\Executor.exe"
} else {	
	pLaunchPath_Executor := "C:\Program Files (x86)\Executor\Executor.exe"
}

pLaunchClass_Explorer := "CabinetWClass"
pLaunchPath_Explorer := "C:\Windows\explorer.exe"

; pLaunchClass_FreeCommander := "TfcForm"
pLaunchClass_FreeCommander := "FreeCommanderXE.SingleInst.1"
; pLaunchPath_FreeCommander := "C:\Program Files (x86)\FreeCommander\FreeCommander.exe"
pLaunchPath_FreeCommander := "C:\Program Files (x86)\FreeCommander XE\FreeCommander.exe"

pLaunchClass_EpicStudio := "WindowsForms10.Window.8.app.0.2bf8098_r13_ad1"
pLaunchPath_EpicStudio := "C:\Program Files (x86)\EpicStudio\EpicStudio.exe"

pLaunchClass_Foobar := "{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}"
pLaunchPath_Foobar := "C:\Program Files (x86)\foobar2000\foobar2000.exe"

pLaunchClass_NotepadPP := "Notepad++"
pLaunchPath_NotepadPP := "C:\Program Files (x86)\Notepad++\notepad++.exe"

if(borgWhichMachine = THINKPAD) {
	pLaunchClass_Onenote := "Framework::CFrame"
	pLaunchPath_Onenote := "C:\Program Files\Microsoft Office\Office15\ONENOTE.EXE"
} else if (borgWhichMachine = EPIC_DESKTOP) {
	pLaunchClass_Onenote := "Framework::CFrame"
	pLaunchPath_Onenote := "C:\Program Files (x86)\Microsoft Office\Office14\ONENOTE.EXE"
}

; pLaunchClass_Pidgin := "{NAME} Buddy List"
; pLaunchPath_Pidgin := "C:\Program Files (x86)\Pidgin\pidgin.exe"



; ----- Program launcher key bindings. ----- ;
if(borgWhichMachine = THINKPAD || borgWhichMachine = BORG_ASUS) {
	pLaunchClass_1 := pLaunchClass_Explorer
	pLaunchPath_1 := pLaunchPath_Explorer
	
	; pLaunchClass_2 := pLaunchClass_EpicStudio
	; pLaunchPath_2 := pLaunchPath_EpicStudio
	
	pLaunchClass_3 := pLaunchClass_Foobar
	pLaunchPath_3 := pLaunchPath_Foobar
	
	pLaunchClass_4 := pLaunchClass_NotepadPP
	pLaunchPath_4 := pLaunchPath_NotepadPP
	
	pLaunchClass_5 := pLaunchClass_Onenote
	pLaunchPath_5 := pLaunchPath_Onenote
	
	
	pLaunchClass_FileManager := pLaunchClass_Explorer
	pLaunchPath_FileManager := pLaunchPath_Explorer
	
	pLaunchClass_HomeWeb := pLaunchClass_Chrome
	pLaunchPath_HomeWeb := pLaunchPath_Chrome
	
	pLaunchClass_Search := pLaunchClass_Everything
	pLaunchPath_Search := pLaunchPath_Everything
	
	; pLaunchClass_Mail := pLaunchClass_Chrome
	; pLaunchPath_Mail := pLaunchPath_Chrome
	
	pLaunchClass_Media := pLaunchClass_Foobar
	pLaunchPath_Media := pLaunchPath_Foobar
	
	pLaunchClass_TaskManager := pLaunchClass_ProcessExplorer
	pLaunchPath_TaskManager := pLaunchPath_ProcessExplorer
	
	; pLaunchClass_Chat := pLaunchClass_Pidgin
	; pLaunchPath_Chat := pLaunchPath_Pidgin
	
} else if(borgWhichMachine = EPIC_DESKTOP) {
	pLaunchClass_FileManager := pLaunchClass_FreeCommander
	pLaunchPath_FileManager := pLaunchPath_FreeCommander
	
	pLaunchClass_HomeWeb := pLaunchClass_Chrome
	pLaunchPath_HomeWeb := pLaunchPath_Chrome
	
	pLaunchClass_Search := pLaunchClass_Everything
	pLaunchPath_Search := pLaunchPath_Everything
	
	pLaunchClass_Mail := pLaunchClass_Outlook
	pLaunchPath_Mail := pLaunchPath_Outlook
	
	pLaunchClass_Media := pLaunchClass_Foobar
	pLaunchPath_Media := pLaunchPath_Foobar
	
	pLaunchClass_TaskManager := pLaunchClass_ProcessExplorer
	pLaunchPath_TaskManager := pLaunchPath_ProcessExplorer
	
	pLaunchClass_1 := pLaunchClass_FreeCommander
	pLaunchPath_1 := pLaunchPath_FreeCommander
	
	pLaunchClass_2 := pLaunchClass_EpicStudio
	pLaunchPath_2 := pLaunchPath_EpicStudio
	
	pLaunchClass_3 := pLaunchClass_Foobar
	pLaunchPath_3 := pLaunchPath_Foobar
	
	pLaunchClass_4 := pLaunchClass_NotepadPP
	pLaunchPath_4 := pLaunchPath_NotepadPP
	
	pLaunchClass_5 := pLaunchClass_Onenote
	pLaunchPath_5 := pLaunchPath_Onenote
}



; ----- Control screenshots/ClassNN for use with ImageSearch. ----- ;

; VB6.
iSearch_imageSpacingTolerance := 1
iSearchPath_vbComment := "..\Images\VB6\vbCommentToolbarButton.png"
iSearchPath_vbUncomment := "..\Images\VB6\vbUncommentToolbarButton.png"
iSearchPath_vbGenericClose := "..\Images\VB6\vbGenericCloseButton.png"
iSearchPath_vbToolboxLabel := "..\Images\VB6\vbLabelToolbarButton.png"
iSearchPath_vbToolboxTextbox := "..\Images\VB6\vbTextboxToolbarButton.png"
iSearchPath_vbToolboxCommandButton := "..\Images\VB6\vbCommandButtonToolbarButton.png"
iSearchPath_vbToolboxShape := "..\Images\VB6\vbShapeToolbarButton.png"
iSearchPath_vbToolboxChrontrol := "..\Images\VB6\vbChrontrolToolbarButton.png"

iSearchClass_vbToolbar2 := "MsoCommandBar1 MsoCommandBar2 MsoCommandBar3 MsoCommandBar4 MsoCommandBar5"
iSearchClass_vbProjectExplorer := "PROJECT1"
iSearchClass_vbPropertiesSidebar := "wndclass_pbrs1"
iSearchClass_vbToolbarPalette := "ToolsPalette1"


; ----- Internal Constants. ----- ;
global LIST_ITEM := 1
global LIST_NUM := 2
global VB_REF_SAME_THRESHOLD := 10
global CONTAINS_ANY := 1
global CONTAINS_BEG := 2
global CONTAINS_END := 3


; ----- Internal Constants. ----- ;
global WS_EX_CONTROLPARENT = 0x10000
global WS_EX_APPWINDOW = 0x40000
global WS_EX_TOOLWINDOW = 0x80
global WS_DISABLED = 0x8000000
global WS_POPUP = 0x80000000

; ----- EpicStudio Constants. ----- ;
global EPICSTUDIO_ROUTINE := 1
global EPICSTUDIO_ENVIRONMENT := 2
global EPICSTUDIO_DLG := 3

; ----- Epic Constants. ----- ;
global EPIC_DEV := 1
global EPIC_IDE := 2
global EPIC_QA := 3