#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
#SingleInstance force

; http://www.autohotkey.com/forum/viewtopic.php?p=424077#424077

SetBatchLines, -1

Gui, Font, s10
Gui, Add, ListView, r20 w300 Grid Checked AltSubmit vLV, Template|Path
IL := IL_Create(20)
LV_SetImageList(IL,1)

Loop, HKCR,,2
{
 RegRead, defaultExtVal, HKCR, %A_LoopRegName%
 If ErrorLevel
  continue
 If (shellNew := hasShellNew(A_LoopRegName "\" defaultExtVal))
  If (!isEmpty(A_LoopRegName "\" defaultExtVal "\" shellNew))
   addRow(defaultExtVal, A_LoopRegName "\" defaultExtVal, shellNew)
  Else continue
 Else
  If (shellNew := hasShellNew(A_LoopRegName)) AND (!isEmpty(A_LoopRegName "\" shellNew))
   addRow(defaultExtVal, A_LoopRegName, shellNew)
}
LV_ModifyCol(1)
LV_ModifyCol(2,"0 Sort")

GuiControl, +gLV, LV
Gui, Show
return
GuiClose:
 ExitApp

hasShellNew(subKey) {
 Loop, HKCR, %subKey%, 2
  If (A_LoopRegName = "ShellNew") OR (A_LoopRegName = "ShellNew-")
   Return, A_LoopRegName
}

isEmpty(subKey) {
 Loop, HKCR, %subKey%
  Return, false
 Return, true
}

addRow(defaultExtVal, subKey, shellNew) {
 global IL
 RegRead, fileType, HKCR, %defaultExtVal%
 RegRead, iconPath, HKCR, %subKey%\%shellNew%, IconPath
 If ErrorLevel
  RegRead, iconPath, HKCR, %defaultExtVal%\DefaultIcon
 StringSplit, icon, iconpath, `,
 StringReplace, icon1, icon1, `%SystemRoot`%  , %A_WinDir%
 StringReplace, icon1, icon1, `%ProgramFiles`%, %A_ProgramFiles%
 StringReplace, icon1, icon1, ",,All
 ILnum := IL_Add(IL, icon1, icon2<0 ? icon2:++icon2)
 prefix := (fileType = "Folder") ? A_Tab A_Tab:(fileType = "ShortCut") ? A_Tab:""
 checkBox := (shellNew = "ShellNew-") ? "":"Check"
 LV_Add(checkBox " Icon" ILnum, fileType, prefix subKey)
}

regRename(subKey) {
 If !InStr(subKey, "ShellNew")
  Return, "invalid parameter"
 Loop, HKCR, %subKey%,,1
 {
  If InStr(subKey, "ShellNew-")
   StringReplace, B_LoopRegSubKey, A_LoopRegSubKey, ShellNew-, ShellNew
  Else
   StringReplace, B_LoopRegSubKey, A_LoopRegSubKey, ShellNew, ShellNew-
  RegRead, value
  RegWrite, %A_LoopRegType%, HKCR, %B_LoopRegSubKey%, %A_LoopRegName%, %value%
 }
 RegDelete, HKCR, %subKey%
}

LV:
 Critical
 If (A_GuiEvent == "I")
  If (shellNew := InStr(ErrorLevel, "C", 1) ? "\ShellNew-"
               :  InStr(ErrorLevel, "c", 1) ? "\ShellNew":"") {
   LV_GetText(path, A_EventInfo, 2)
   path = %path%
   regRename(path shellNew)
  }
return


























~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload