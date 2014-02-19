; Either focus or open a program.
activateOpenMinimize(ahkClass, pathToExecutable) {
	if(SubStr(ahkClass, 1, 8) = "_{NAME}_") {
		ahkClassString := ahkClass
	} else {
		ahkClassString := "ahk_class "ahkClass
	}
	
	if(winExistSpecial(ahkClassString)) {
		if(winActiveSpecial(ahkClassString)) {
			minimizeWindowSpecial(1)
		} else {
			restoreActivateWindowSpecial()
		}
	} else {
		DEBUG.popup(DEBUG.window, pathToExecutable, "Path to executable")
		Run %pathToExecutable%
	}
}

; Returns whether a window exists, with special exceptions.
winExistSpecial(inClass) {
	; if(inClass = "") { ; 
		
		; return XXXXX
	; }
	
	; Normal Case.
	return WinExist(inClass)
}

; Returns whether a program is active, with special exceptions.
winActiveSpecial(inClass) {
	if(inClass = "TfcForm") { ; FreeCommander.
		; Grab the style so we can tell if it's already hidden.
		WinGet, style, Style, ahk_class TfcForm
		if(WinActive("ahk_class TfcForm") && !(style = "0x07CF0000" || style = "0x06CF0000" || style = "0x36CF0000")) {
			return true
		} else {
			return false
		}
		
		return XXXXX
	}
	
	return WinActive(inClass)
}

; Activates/shows the last found window, with special exceptions.
restoreActivateWindowSpecial() {
	; if(inClass = "") { ; 
		
		; return
	; }
	
	; Normal case.
	WinShow
	WinActivate
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
	or WinActive("ahk_class Photo_Lightweight_Viewer") ; Windows Photo Viewer.
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

	} else if(WinActive("ahk_class ahk_class CabinetWClass")) { ; Windows Explorer.
		WinMinimize

	} else if(WinActive("ahk_class TfcForm")) { ; FreeCommander.
		WinHide
		activateLastWindow()
		
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
	; Gather a list of running programs to loop over.
	WinGet, windowList, List
	WinGetTitle, oldTitle, A
	WinGetClass, oldClass, A
	
	; Loop until we have the previous window.
	Loop, %windowList%
	{
		; Gather information on the window.
		currID := windowList%A_Index%
		WinGetTitle, currTitle, ahk_id %currID%
		WinGet, currStyle, Style, ahk_id %currID%
		WinGet, currExStyle, ExStyle, ahk_id %currID%
		WinGetClass, currClass, ahk_id %currID%
		currParent := decimalToHex(DllCall("GetParent", "uint", currID))
		WinGet, currParentStyle, Style, ahk_id %currParent%
		DEBUG.popup(DEBUG.window, currID, "Current ID", currStyle, "Current style", currExStyle, "Current extended style", currParentStyle, "Current parent style", currParent, "Current parent")
		
		; Skip unimportant windows.
		if((currStyle & WS_DISABLED) || !(currTitle))
			Continue
		; Skip tool-type windows.
		if(currExStyle & WS_EX_TOOLWINDOW)
			Continue
		; Skip pspad child windows.
		if((currExStyle & ws_ex_controlparent) && !(currStyle & WS_POPUP) && (currClass != "#32770") && !(currExStyle & WS_EX_APPWINDOW))
			Continue
		; Skip notepad find windows.
		if((currStyle & WS_POPUP) && (currParent) && ((currParentStyle & WS_DISABLED) = 0))
			Continue
		; Skip other random windows.
		if(currClass = "#32770" || currClass = "AU3Reveal" || currClass = "Progman" || currClass = "AutoHotkey" || currClass = "AutoHotkeyGUI")
			Continue
		; Don't get yourself, either.
		if(oldClass = currClass || oldTitle = currTitle)
			Continue

		break
	}
	
	; WinActivate, ahk_id %currID%
	; WinGetTitle, title, ahk_id %currID%
	DEBUG.popup(DEBUG.window, title, "Title", currID, "Current ID", currStyle, "Current style", currExStyle, "Current extended style", currClass, "Current class")
	
	return, currID
}