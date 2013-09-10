; Auto-Execute
	DetectHiddenWindows, On
return

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
#SingleInstance force

; http://www.autohotkey.com/forum/topic43514.html
;Code contributed from the following sources:
;
;http://www.autohotkey.com/forum/viewtopic.php?t=41097&postdays=0&postorder=asc&start=0
;http://www.autohotkey.com/forum/topic17314.html#NoTrayIcon
^!d:: ;You can change this to any other key combo ^=CTRL !=ALT D=D Key
	TI := TrayIcons( "digsby-app.exe" )
	StringSplit,TIV, TI, |
	uID  := RegExReplace( TIV4, "uID: " )
	Msg  := RegExReplace( TIV5, "MessageID: " )
	hWnd := RegExReplace( TIV6, "hWnd: " )
	PostMessage, Msg, uID,0x0203,, ahk_id %hWnd% ; Double Click Digsby Icon
return

TrayIcons(sExeName = "")
{
   WinGet,   pidTaskbar, PID, ahk_class Shell_TrayWnd
   hProc:=   DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
   pProc:=   DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 32, "Uint", 0x1000, "Uint", 0x4)
   idxTB:=   GetTrayBar()
      SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_BUTTONCOUNT
   Loop,   %ErrorLevel%
   {
      SendMessage, 0x417, A_Index-1, pProc, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_GETBUTTON
      VarSetCapacity(btn,32,0), VarSetCapacity(nfo,32,0)
      DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pProc, "Uint", &btn, "Uint", 32, "Uint", 0)
         iBitmap   := NumGet(btn, 0)
         idn   := NumGet(btn, 4)
         Statyle := NumGet(btn, 8)
      If   dwData   := NumGet(btn,12)
         iString   := NumGet(btn,16)
      Else   dwData   := NumGet(btn,16,"int64"), iString:=NumGet(btn,24,"int64")
      DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "Uint", &nfo, "Uint", 32, "Uint", 0)
      If   NumGet(btn,12)
         hWnd   := NumGet(nfo, 0)
      ,   uID   := NumGet(nfo, 4)
      ,   nMsg   := NumGet(nfo, 8)
      ,   hIcon   := NumGet(nfo,20)
      Else   hWnd   := NumGet(nfo, 0,"int64"), uID:=NumGet(nfo, 8), nMsg:=NumGet(nfo,12)
      WinGet, pid, PID,              ahk_id %hWnd%
      WinGet, sProcess, ProcessName, ahk_id %hWnd%
      WinGetClass, sClass,           ahk_id %hWnd%
      If !sExeName || (sExeName = sProcess) || (sExeName = pid)
         VarSetCapacity(sTooltip,128), VarSetCapacity(wTooltip,128*2)
      ,   DllCall("ReadProcessMemory", "Uint", hProc, "Uint", iString, "Uint", &wTooltip, "Uint", 128*2, "Uint", 0)
      ,   DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "str", wTooltip, "int", -1, "str", sTooltip, "int", 128, "Uint", 0, "Uint", 0)
      ,   sTrayIcons .= "idx: " . A_Index-1 . " | idn: " . idn . " | Pid: " . pid . " | uID: " . uID . " | MessageID: " . nMsg . " | hWnd: " . hWnd . " | Class: " . sClass . " | Process: " . sProcess . "`n" . "   | Tooltip: " . sTooltip . "`n"
   }
   DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pProc, "Uint", 0, "Uint", 0x8000)
   DllCall("CloseHandle", "Uint", hProc)
   Return   sTrayIcons
}
GetTrayBar()
{
   ControlGet, hParent, hWnd,, TrayNotifyWnd1  , ahk_class Shell_TrayWnd
   ControlGet, hChild , hWnd,, ToolbarWindow321, ahk_id %hParent%
   Loop
   {
      ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
      If  Not   hWnd
         Break
      Else If   hWnd = %hChild%
      {
         idxTB := A_Index
         Break
      }
   }
   Return   idxTB
}