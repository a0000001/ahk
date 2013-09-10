#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

; http://www.autohotkey.com/forum/viewtopic.php?p=380235#380235

; Enable any button by clicking on it
; Prohibit applications from disabling windows or controls, by simply clicking
; on them.  This is especially useful when you wish to access a parent window
; while a settings or dialog window is visible, ie; a Save/Open dialog.

;~LButton::
;  Enable_Window_Under_Cursor()
;  Return

Enable_Window_Under_Cursor() 

Enable_Window_Under_Cursor() ; By Raccoon 31-Aug-2010
{
  MouseGetPos,,, WinHndl, CtlHndl, 2
  WinGet, Style, Style, ahk_id %WinHndl%
  if (Style & 0x8000000) { ; WS_DISABLED.
    WinSet, Enable,, ahk_id %WinHndl%
  }
  WinGet, Style, Style, ahk_id %CtlHndl%
  if (Style & 0x8000000) { ; WS_DISABLED.
    WinSet, Enable,, ahk_id %CtlHndl%
  }
}

;~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
;~!+r::Reload			;Shift+Alt+R = Reload