#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload

#LButton::
SetWinDelay, -1
CoordMode, Mouse, Screen
   WinGet, windows, List,,, Program Manager      ; get list of all visible windows

   ; remove windows which we want to see on all virtual desktops
   Loop, % windows
   {
      id := % windows%A_Index%
      WinGetClass, windowClass, ahk_id %id%
      if windowClass = Shell_TrayWnd     ; remove task bar window id
           windows%A_Index%=      ; just empty the array element, array will be emptied by next switch anyway
      if windowClass = #32770            ; we also want multimontaskbar on all virtual desktops
           windows%A_Index%=      ; just empty the array element, array will be emptied by next switch anyway
      if windowClass = cygwin/x X rl-xosview-XOsview-0   ; xosviews e.d.
           windows%A_Index%=     
      if windowClass = cygwin/x X rl-xosview-XOsview-1   ; xosviews e.d.
           windows%A_Index%=     
      if windowClass = MozillaUIWindowClass              ; Mozilla thunderbird
      {
        WinGet, ExStyle, ExStyle, ahk_id %id%
          if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
           windows%A_Index%=     
      }
   }
MouseGetPos, X4, Y4   
   Loop
{

    GetKeyState, state, LButton, P
    if state = U  ; The key has been released, so break out of the loop.
        break

MouseGetPos, X5, Y5
X3:=X5-X4
X3:=X3*4
if X4 <> %X5%
{
MouseGetPos, X4, Y4   
}
   
   
    Loop, % windows
   {
      id := % windows%A_Index%
     WinGetPos,X,Y,,,ahk_id %id%
     X2 := X+X3
     if X2 > 5000
     X2 := X2 - 10000
     if X2 < -5000
     X2 := X2 + 10000
     WinMove, ahk_id %id%, ,%X2%,%Y%

   }
   
   }
   Return