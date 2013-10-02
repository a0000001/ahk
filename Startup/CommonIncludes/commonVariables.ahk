

; ----- Program launcher classes and strings. ----- ;
pLaunchClass_Chrome := "Chrome_WidgetWin_1"
pLaunchPath_Chrome := "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

pLaunchClass_Everything := "EVERYTHING"
pLaunchPath_Everything := "C:\Program Files (x86)\Everything\Everything.exe"

pLaunchClass_Outlook := "rctrl_renwnd32"
pLaunchPath_Outlook := "C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.EXE"

pLaunchClass_ProcessExplorer := "PROCEXPL"
if(borgWhichMachine = THINKPAD) {
	pLaunchPath_ProcessExplorer := "C:\Program Files\ProcessExplorer\procexp.exe"
} else if (borgWhichMachine = EPIC_DESKTOP) {
	pLaunchPath_ProcessExplorer := "C:\Program Files (x86)\ProcessExplorer\procexp.exe"
}

pLaunchClass_Explorer := "CabinetWClass"
pLaunchPath_Explorer := "C:\Windows\explorer.exe"

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

; pLaunchClass_Pidgin := "_{NAME}_Buddy List"
; pLaunchPath_Pidgin := "C:\Program Files (x86)\Pidgin\pidgin.exe"



; ----- Program launcher key bindings. ----- ;
if(borgWhichMachine = THINKPAD) {
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
	
	
	pLaunchClass_1 := pLaunchClass_Explorer
	pLaunchPath_1 := pLaunchPath_Explorer
	
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
iSearchPath_vbComment := "C:\Users\gborg\ahk\Images\vbCommentToolbarButton.png"
iSearchPath_vbUncomment := "C:\Users\gborg\ahk\Images\vbUncommentToolbarButton.png"
iSearchPath_vbGenericClose := "C:\Users\gborg\ahk\Images\vbGenericCloseButton.png"
iSearchPath_vbToolboxLabel := "C:\Users\gborg\ahk\Images\vbLabelToolbarButton.png"
iSearchPath_vbToolboxTextbox := "C:\Users\gborg\ahk\Images\vbTextboxToolbarButton.png"
iSearchPath_vbToolboxCommandButton := "C:\Users\gborg\ahk\Images\vbCommandButtonToolbarButton.png"
iSearchPath_vbToolboxShape := "C:\Users\gborg\ahk\Images\vbShapeToolbarButton.png"
iSearchPath_vbToolboxChrontrol := "C:\Users\gborg\ahk\Images\vbChrontrolToolbarButton.png"

iSearchClass_vbToolbar2 := "MsoCommandBar2 MsoCommandBar3 MsoCommandBar4"
iSearchClass_vbProjectExplorer := "PROJECT1"
iSearchClass_vbPropertiesSidebar := "wndclass_pbrs1"
iSearchClass_vbToolbarPalette := "ToolsPalette1"


