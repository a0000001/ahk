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
	; or WinActive("ahk_class SUMATRA_PDF_FRAME") ; SumatraPDF Reader ; Now in sumatraPDF's program specific - needed additional case for search box.
	or WinActive("ahk_class Notepad") ; Notepad.
	or WinActive("ahk_class 1by1WndClass") ; 1by1 Audio Player.
	or WinActive("ahk_class AU3Reveal") ; WinSpy.
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
	
	else if(WinActive("ahk_class TfcForm")) { ; FreeCommander.
		minimizeWindowSpecial()
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

	} else if(WinActive("ahk_class TfcForm")) { ; FreeCommander.
		; Send, 
		WinHide
		
	} else {
		WinMinimize, A
	}
}

; Centers a window on the screen. "A" will use the active window, and passing nothing will use the last found window.
centerWindow(title = "") {
	if(!title) {
		WinGetTitle, title
	} else if(title = "A") {
		WinGetTitle, title, A
	}
	
	WinGetPos, , , Width, Height, %WinTitle%
	WinMove, %WinTitle%, , (A_ScreenWidth / 2) - (Width / 2), (A_ScreenHeight / 2) - (Height / 2)
}

activateLastWindow() {
	WinActivate, % "ahk_id " getPreviousWindowID()
}

getPreviousWindowID() {
	WS_EX_CONTROLPARENT = 0x10000
	WS_EX_APPWINDOW = 0x40000
	WS_EX_TOOLWINDOW = 0x80
	WS_DISABLED = 0x8000000
	WS_POPUP = 0x80000000
	
	; Gather a list of running programs to loop over.
	WinGet, Window_List, List
	WinGetTitle, currTitle, A
	WinGetClass, currClass, A
	
	; Loop until we have the previous window.
	Loop, %Window_List%
	{
		; Gather information on the window.
		wid := Window_List%A_Index%
		WinGetTitle, wid_Title, ahk_id %wid%
		WinGet, Style, Style, ahk_id %wid%
		WinGet, es, ExStyle, ahk_id %wid%
		WinGetClass, Win_Class, ahk_id %wid%
		WinGet, Style_parent, Style, ahk_id %Parent%
		Parent := decimalToHex(DllCall("GetParent", "uint", wid))
		; MsgBox, % wid "`n" wid_Title "`n" Style "`n" es "`n" Win_Class "`n" Style_parent "`n" Parent
		
		; Skip unimportant windows.
		if((Style & WS_DISABLED) || !(wid_Title))
			Continue
		; Skip tool-type windows.
		if(es & WS_EX_TOOLWINDOW)
			Continue
		; Skip pspad child windows.
		if((es & ws_ex_controlparent) && !(Style & WS_POPUP) && (Win_Class != "#32770") && !(es & WS_EX_APPWINDOW))
			Continue
		; Skip notepad find windows.
		if((Style & WS_POPUP) && (Parent) && ((Style_parent & WS_DISABLED) = 0))
			Continue
		; Skip other random windows.
		if(Win_Class = "#32770" || Win_Class = "AU3Reveal" || Win_Class = "Progman")
			Continue
		; Don't get yourself, either.
		if(currClass = Win_Class || currTitle = wid_Title)
			Continue

		break
	}
	
	; WinActivate, ahk_id %wid%
	; WinGetTitle, title, ahk_id %wid%
	; MsgBox, % title "`n" wid "`n" Style "`n" es "`n" Win_Class
	
	return, wid
}