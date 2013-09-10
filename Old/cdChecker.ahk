;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#noTrayIcon
#Persistent
#SingleInstance force

OnExit, ExitSub
return

ExitSub:
if A_ExitReason in Logoff,Shutdown ; Only if computer is shutted dow or user logs out.
{
	
   DriveGet, lista, List, CDROM ;get all CD drives
   Stringlen, cd_len, lista ;how much of drives?
   Loop, %cd_len%  ;for each drive
   {
      stringmid cd_letter, lista, %A_Index%, 1  ;get name of drive
      driveget isopen, StatusCD, %cd_letter% ;check if it is empty
      if (isopen != "open") ; if not - open it
      {
		 Drive, Unlock, %cd_letter%
         Drive, Eject, %cd_letter%
         }
      
      }
   }
ExitApp 