; http://www.autohotkey.com/forum/viewtopic.php?t=8086&postdays=0&postorder=asc&start=15

SetTimer, TrayIcons, 500
;^!a::TrayIcons()

TrayIcons:
	TrayIcons()
Return

TrayIcons(sExeName = "")
{
   DetectHiddenWindows, On
   idxTB := GetTrayBar()
   WinGet, pidTaskbar, PID, ahk_class Shell_TrayWnd

   hProc := DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
   pRB := DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 20, "Uint", 0x1000, "Uint", 0x4)

   VarSetCapacity(btn, 20)
   VarSetCapacity(nfo, 24)

   SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_BUTTONCOUNT
   max = %errorlevel%

   Loop, %max%
   {
      i := max - A_index
      SendMessage, 0x417, i, pRB, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_GETBUTTON

      DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pRB, "Uint", &btn, "Uint", 20, "Uint", 0)

      dwData   := NumGet(btn,12)

      DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "Uint", &nfo, "Uint", 24, "Uint", 0)

      hWnd   := NumGet(nfo, 0)

      WinGet, pid, PID,              ahk_id %hWnd%

      ifwinnotexist, ahk_id %hWnd%
      {
      idx := i+1
      ;MsgBox, 4, , Delete tray icon %idx%?
      ;IfMsgBox Yes
      deletetrayicon(idx)
      }

      tmp = index=%a_index%, i=%i%, pid=%pid%`n
      strayicons .= tmp

   }

   DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pRB, "Uint", 0, "Uint", 0x8000)
   DllCall("CloseHandle", "Uint", hProc)

   Return   sTrayIcons
}

DeleteTrayIcon(idx)
{
   idxTB := GetTrayBar()
   SendMessage, 0x416, idx - 1, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd   ; TB_DELETEBUTTON
   SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
}

GetTrayBar()
{
   WinGet, ControlList, ControlList, ahk_class Shell_TrayWnd
   RegExMatch(ControlList, "(?<=ToolbarWindow32)\d+(?!.*ToolbarWindow32)", nTB)

   Loop, %nTB%
   {
      ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
      hParent := DllCall("GetParent", "Uint", hWnd)
      WinGetClass, sClass, ahk_id %hParent%
      If (sClass <> "SysPager")
         Continue
      idxTB := A_Index
         Break
   }

   Return   idxTB
}