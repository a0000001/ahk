; Function to either focus or open a program.
activateOpenMinimize(ahkClass, pathToExecutable) {
	if(SubStr(ahkClass, 1, 8) = "_{NAME}_") {
		ahkClassString := ahkClass
	} else {
		ahkClassString := "ahk_class "ahkClass
	}
	
	if(WinExist(ahkClassString)) {
		if(WinActive(ahkClassString)) {
			minimizeWindowSpecial(1)
		} else {
			WinShow
			WinActivate
		}
	} else {
		; MsgBox, % pathToExecutable
		Run %pathToExecutable%
	}
}

; Activate window by name, loosely.
activateByName(name) {
	setTitleMatchMode, 2
	WinActivate, %name%
	setTitleMatchMode, 1
}

; Function to close windows - used by multiple hotkeys in slightly different ways.
closeWindowSpecial(case = 0) {
	
	SetTitleMatchMode, 2
	
	;WinActive("ahk_class tSkMainForm.UnicodeClass") ; Skype-related?
	
	if WinActive("ahk_class FM") ; 7-zip
	or WinActive("ahk_class tSkMainForm") ; Skype Buddy List
	or WinActive("ahk_class Framework::CFrame")
	; or WinActive("ahk_class PP12FrameClass") ; PPT - presentation?
	or WinActive("ahk_class ahk_class QWidget")
	; or WinActive("ahk_class PPTFrameClass") ; PPT - Main window.
	or WinActive("ahk_class TfrmMain")
	or WinActive("ahk_class THomeForm")
	; or WinActive("ahk_class Miranda") ; Miranda IM
	or WinActive("Buddy List") ; Pidgin Buddy List
	or WinActive("ahk_class classFoxitReader") ; FoxIt PDF Reader
	or WinActive("ahk_class SUMATRA_PDF_FRAME") ; SumatraPDF Reader
	or WinActive("ahk_class Notepad") ; Notepad.
	or WinActive("ahk_class 1by1WndClass") ; 1by1 Audio Player.
	{
		sleep, 10
		send !{F4}
	}

	if WinActive("ahk_class CabinetWClass") ; Windows Explorer
	or WinActive("ahk_class Notepad++") ; Notepad++
	or WinActive("MightyText") ; MightyText Popup Window
	; or WinActive("Source of: ") ; Firefox Source View
	; or (WinActive("Library") && !WinActive("Media Library Search")) ; Firefox All Bookmarks View, but not Foobar's media library search!
	; or WinActive(" - DownThemAll!") ; DownThemAll Download Manager Window
	; or WinActive(" - DOM Inspector") ; Dom inspector window
	{
		sleep, 10
		send ^w
	}
	
	else if(WinActive("ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}")) {
		; WinTraymin()
		; Send, !q
		PostMessage, 0x112, 0xF020
	}
	; if((WinActive("ahk_class MozillaWindowClass")) ; Firefox - tabs. Only if CapsLock was held.
	; and case == 1)
	; {
		; sleep, 10
		; send ^w
	; }
	
	; if((WinActive("ahk_class Chrome_WidgetWin_1")) ; Chrome - tabs. Only if CapsLock was held.
	; and case == 1)
	; {
		; sleep, 10
		; send ^w
	; }
	
	SetTitleMatchMode, 1
}


minimizeWindowSpecial(case = 0) {
	if(WinActive("ahk_class {97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}")) { ; Foobar.
		PostMessage, 0x112, 0xF020

	} else if(WinActive("ahk_class TfrmMain")) { ; SyncBack
		PostMessage, 0x112, 0xF020

	} else if(WinActive("ahk_class EVERYTHING")) {
		if(case = 1) {
			Send, {Esc}
		} else {
			WinMinimize, A
		}

	} else if(WinActive("ahk_class PROCEXPL")) {
		WinClose

	} else if(WinActive("Buddy List")) { ; Pidgin
		WinClose

	} else if(WinActive("ahk_class ahk_class CabinetWClass")) { ; Windows Explorer/QTTabbar.
		Send, ^m

	} else {
		WinMinimize, A
	}
}