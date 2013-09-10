#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Auto-Close Double Quotes:               
; --------------------------------------------------------------
   $+'::
      SetTitleMatchMode, 2
      IfWinActive, cmd.exe
      {
         Send, +'
      }
      else IfWinActive, HomeSite
      {
         Send, +'
      }
      else
      {
         clipboard =
         Send, ^c
         if clipboard =
         {
            Send, +'+'{LEFT}
         }
         else
         {
            Send, +'^v+'
         }
      }
   return
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Auto-Close Parantheses:               
; --------------------------------------------------------------
   $+9::
      SetTitleMatchMode, 2
      IfWinActive, cmd.exe
      {
         Send, +9
      }
      else
      {
         clipboard =
         Send, ^c
         if clipboard =
         {
            Send, +9+0{LEFT}
         }
         else
         {
            Send, +9^v+0
         }
      }
   return
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Auto-Close Curly Braces:               
; --------------------------------------------------------------
   $+[::
      SetTitleMatchMode, 2
      IfWinActive, cmd.exe
      {
         Send, +[
      }
      else
      {
         clipboard =
         Send, ^c
         if clipboard =
         {
            Send, +[+]{LEFT}

         }
         else
         {
            Send, +[^v+]
         }
      }
   return
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Auto-Close Brackets:                  
; --------------------------------------------------------------
   $[::
      SetTitleMatchMode, 2
      IfWinActive, cmd.exe
      {
         Send, [
      }
      else
      {
         clipboard =
         Send, ^c
         if clipboard =
         {
            Send, []{LEFT}
         }
         else
         {
            Send, [^v]
         }
      }
   return
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~








; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; AutoHotKeys: Setup New Script   (CTRL-WIN-N)         
; --------------------------------------------------------------
   ^#N:: Send,; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{ENTER}; DescriptionGoesHere{ENTER}; --------------------------------------------------------------{ENTER 2}; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{UP}{TAB}
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Dos Window: Paste Clipboard   (SHIFT-INSERT)         
; --------------------------------------------------------------
   +Insert::
      SetTitleMatchMode, 2
      IfWinActive, C:\WINNT\System32\cmd.exe
      {
         MouseClick, RIGHT
      }
      else
      {
         ; Don't do anything globally for this
      }
   return
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
