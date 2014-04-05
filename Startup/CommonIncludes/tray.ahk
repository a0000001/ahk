setupTrayIcons(v, m) {
	global vars, mapping
	vars := v
	mapping := m
	
	Menu, Tray, Icon, , , 1 ; Keep suspend from changing it to the AHK default.
	updateTrayIcon()
}

getValuesFromNames(names) {
	values := Object()
	
	namesLen := names.MaxIndex() + 1
	Loop, %namesLen% {
		currName := names[A_Index - 1]
		currVal := %currName%
		values[A_Index - 1] := currVal
		; DEBUG.popup(currName, "Current name", currVal, "Current value")
}
	
	return values
}

updateTrayIcon() {
	global vars, mapping
	values := getValuesFromNames(vars)
	; DEBUG.popup(vars, "Vars", values, "Values")
	
	temp := mapping
	while(temp.HasKey(0)) {
		temp := temp[values[A_Index - 1]]
	}
	; DEBUG.popup(temp, "Temp")
	
	Menu, Tray, Icon, % temp
}




; ; Below subroutines now in startup.ahk.
; ; TrayminOpen:
	; ; SetWinDelay, 0
	; ; SetFormat, Integer, D
	; ; CoordMode, Mouse, Screen
	; ; DetectHiddenWindows On
	; ; hAHK := WinExist("ahk_class AutoHotkey ahk_pid " . DllCall("GetCurrentProcessId"))
	; ; ShellHook := DllCall("RegisterWindowMessage", "str", "SHELLHOOK")
	; ; DllCall("RegisterShellHookWindow", "Uint", hAHK)
	; ; OnExit, TrayminClose
; ; Return

; ; TrayminClose:
	; ; DllCall("DeregisterShellHookWindow", "Uint", hAHK)
	; ; WinTraymin(0,-1)
	; ; OnExit
	; ; ExitApp
; ; Return

; ;----------------------------------------------------------
; ;----------------------------------------------------------
; ; WinTraymin.ahk
; ; by Sean
; ;----------------------------------------------------------
; ;----------------------------------------------------------
; ; Adding a trayminned trayicon of hWnd:	WinTraymin(hWnd,0), where 0 can be omitted.
; ; Removing all trayminned trayicons:	WinTraymin(0,-1).
; ; Other values than 0 & -1 are reserved for internal use.
; ;----------------------------------------------------------
; ; #SingleInstance force
; ;#NoTrayIcon

; ; ~RButton Up::
	; ; if (h := WM_NCHITTEST()) {
		; ; WinTraymin(h)
	; ; } else {
		; ; Click, % SubStr(A_ThisHotkey,1,1)	; for hotkey: LButton/MButton/RButton
	; ; }
; ; return

; WM_NCHITTEST()
; {
	; CoordMode, Mouse, Relative
	; WinGet, winID, ID
	; WinGetPos, , , wid
	; ;Click
	; MouseMove, (wid-80), 10
	; CoordMode, Mouse, Screen
	; ;MouseGetPos, x, y, z
	; ;SendMessage, 0x84, 0, (x&0xFFFF)|(y&0xFFFF)<<16,, ahk_id %z%
	; Return	ErrorLevel=8 ? z : ""
; }

; WM_SHELLHOOKMESSAGE(wParam, lParam, nMsg)
; {
	; Critical
	; If	nMsg=1028
	; {
		; If	wParam=1028
			; Return
		; Else If	(lParam=0x201||lParam=0x205||lParam=0x207)
			; WinTraymin(wParam,3)
	; }
	; Else If	(wParam=1||wParam=2)
		; WinTraymin(lParam,wParam)
	; Return	0
; }

; WinTraymin(hWnd = "", nFlags = "")
; {
	; Local	h, ni, fi, uid, pid, hProc, sClass
	; Static	nMsg, nIcons:=0
	; nMsg ? "" : OnMessage(nMsg:=1028,"WM_SHELLHOOKMESSAGE")
	; NumPut(hAHK,NumPut(VarSetCapacity(ni,444,0),ni))
	; If Not	nFlags
	; {
		; If Not	((hWnd+=0)||hWnd:=DllCall("GetForegroundWindow"))||((h:=DllCall("GetWindow","Uint",hWnd,"Uint",4))&&DllCall("IsWindowVisible","Uint",h)&&!hWnd:=h)||!(VarSetCapacity(sClass,15),DllCall("GetClassNameA","Uint",hWnd,"str",sClass,"Uint",VarSetCapacity(sClass)+1))||sClass=="Shell_TrayWnd"||sClass=="Progman"
		; Return
		; OnMessage(ShellHook,"")
		; WinMinimize,	ahk_id %hWnd%
		; WinHide,	ahk_id %hWnd%
		; Sleep,	100
		; OnMessage(ShellHook,"WM_SHELLHOOKMESSAGE")
		; uID:=uID_%hWnd%,uID ? "" : (uID_%hWnd%:=uID:=++nIcons=nMsg ? ++nIcons : nIcons)
		; hIcon_%uID% ? "" : (VarSetCapacity(fi,352,0),DllCall("GetWindowThreadProcessId","Uint",hWnd,"UintP",pid),DllCall("psapi\GetModuleFileNameExA","Uint",hProc:=DllCall("kernel32\OpenProcess","Uint",0x410,"int",0,"Uint",pid),"Uint",0,"Uint",&fi+12,"Uint",260),DllCall("kernel32\CloseHandle","Uint",hProc),DllCall("shell32\SHGetFileInfoA","Uint",&fi+12,"Uint",0,"Uint",&fi,"Uint",352,"Uint",0x101),hIcon_%uID%:=NumGet(fi)),DllCall("GetWindowTextA","Uint",hWnd,"Uint",NumPut(hIcon_%uID%,NumPut(nMsg,NumPut(1|2|4,NumPut(uID,ni,8)))),"int",64)
		; Return	hWnd_%uID%:=DllCall("shell32\Shell_NotifyIconA","Uint",hWnd_%uID% ? 1 : 0,"Uint",&ni) ? hWnd : DllCall("ShowWindow","Uint",hWnd,"int",5)*0
	; }
	; Else If	nFlags > 0
	; {
		; If	(nFlags=3&&uID:=hWnd)
			; If	WinExist("ahk_id " . hWnd:=hWnd_%uID%)
			; {
				; WinShow,	ahk_id %hWnd%
				; WinRestore,	ahk_id %hWnd%
			; }
			; Else	nFlags:=2
		; Else	uID:=uID_%hWnd%
		; Return	uID ? (hWnd_%uID% ? (DllCall("shell32\Shell_NotifyIconA","Uint",2,"Uint",NumPut(uID,ni,8)-12),hWnd_%uID%:="") : "",nFlags==2&&hIcon_%uID% ? (DllCall("DestroyIcon","Uint",hIcon_%uID%),hIcon_%uID%:="") : "") : ""
	; }
	; Else
		; Loop, % nIcons
			; hWnd_%A_Index% ? (DllCall("shell32\Shell_NotifyIconA","Uint",2,"Uint",NumPut(A_Index,ni,8)-12),DllCall("ShowWindow","Uint",hWnd_%A_Index%,"int",5),hWnd_%A_Index%:="") : "",hIcon_%A_Index% ? (DllCall("DestroyIcon","Uint",hIcon_%A_Index%),hIcon_%A_Index%:="") : ""
; }

; End minToTray.


; Modified from http://www.autohotkey.com/forum/topic43514.html .
TrayIcons(sExeName = "") {
	WinGet, pidTaskbar, PID, ahk_class Shell_TrayWnd
	hProc := DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
	pProc := DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 32, "Uint", 0x1000, "Uint", 0x4)
	idxTB := GetTrayBar()
	SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_BUTTONCOUNT
	
	; DEBUG.popup(pidTaskbar, "Taskbar PID", hProc, "Process handle", pProc, "Process p", idxTB, "Taskbar Index", ErrorLevel, "Error Level")
	
	Loop, %ErrorLevel%
	{
		SendMessage, 0x417, A_Index-1, pProc, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_GETBUTTON
			VarSetCapacity(btn,32,0), VarSetCapacity(nfo,32,0)
		DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pProc, "Uint", &btn, "Uint", 32, "Uint", 0)
		iBitmap := NumGet(btn, 0)
		idn := NumGet(btn, 4)
		Statyle := NumGet(btn, 8)
		
		if(dwData := NumGet(btn,12)) {
			iString := NumGet(btn,16)
		} else {
			dwData := NumGet(btn,16,"int64")
			iString :=NumGet(btn,24,"int64")
		}
		
		; DEBUG.popup(iBitmap, "iBitmap", idn, "idn", Statyle, "Statyle", dwData, "dwData", iString, "iString")
		
		DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "Uint", &nfo, "Uint", 32, "Uint", 0)
		
		if(NumGet(btn,12)) {
			hWnd := NumGet(nfo, 0)
			uID := NumGet(nfo, 4)
			nMsg := NumGet(nfo, 8)
			hIcon := NumGet(nfo,20)
		} else { 
			hWnd := NumGet(nfo, 0,"int64")
			uID :=NumGet(nfo, 8)
			nMsg :=NumGet(nfo,12)
		}
		
		WinGet, pid, PID, ahk_id %hWnd%
		WinGet, sProcess, ProcessName, ahk_id %hWnd%
		WinGetClass, sClass, ahk_id %hWnd%
		
		; DEBUG.popup(hWnd, "Window handle", uID, "uID", nMsg, "nMsg", hIcon, "hIcon", sExeName, "sExeName", pid, "pid", sProcess, "sProcess", sClass, "sClass")
		
		if(!sExeName || (sExeName = sProcess) || (sExeName = pid)) {
			VarSetCapacity(sTooltip,128)
			VarSetCapacity(wTooltip,128*2)
			DllCall("ReadProcessMemory", "Uint", hProc, "Uint", iString, "Uint", &wTooltip, "Uint", 128*2, "Uint", 0)
			DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "str", wTooltip, "int", -1, "str", sTooltip, "int", 128, "Uint", 0, "Uint", 0)
			sTrayIcons .= "idx: " . A_Index-1 . " | idn: " . idn . " | Pid: " . pid . " | uID: " . uID . " | MessageID: " . nMsg . " | hWnd: " . hWnd . " | Class: " . sClass . " | Process: " . sProcess . "`n" . "   | Tooltip: " . sTooltip . "`n"
		}
		
		; DEBUG.popup(hWnd, "Window handle", uID, "uID", nMsg, "nMsg", hIcon, "hIcon", sExeName, "sExeName", pid, "pid", sProcess, "sProcess", sClass, "sClass")
	}
	
	DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pProc, "Uint", 0, "Uint", 0x8000)
	DllCall("CloseHandle", "Uint", hProc)
	
	return sTrayIcons
}

GetTrayBar() {
	ControlGet, hParent, hWnd, , TrayNotifyWnd1  , ahk_class Shell_TrayWnd
	ControlGet, hChild , hWnd, , ToolbarWindow321, ahk_id %hParent%
	
	Loop {
		ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
		if(NOT hWnd) {
			Break
		} else if (hWnd == hChild) {
			idxTB := A_Index
			Break
		}
	}
	
	return idxTB
}

; Double-click an icon in the system tray with the given executable (case sensitive).
doubleClickTrayIcon(exeName) {
	TI := TrayIcons(exeName)
	StringSplit,TIV, TI, |
	uID  := RegExReplace( TIV4, "uID: " )
	Msg  := RegExReplace( TIV5, "MessageID: " )
	hWnd := RegExReplace( TIV6, "hWnd: " )
	
	; DEBUG.popup(TI, "TI", uID, "uID", Msg, "Msg", hWnd, "hWnd")
	
	PostMessage, Msg, uID, 0x0203, , ahk_id %hWnd% ; Double Click Icon
}