; Phased into explorer.ahk

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
#SingleInstance force

; Horizontal Containment
F11::
  CoordMode, Mouse, Screen
  MouseGetPos, Xh, Yh
  Confine := !Confine
  ;ClipCursor( Confine, 0, A_ScreenHeight//2, A_ScreenWidth, A_ScreenHeight//2+1 )
  ClipCursor( Confine, 0, Yh, A_ScreenWidth, Yh+1 )
Return

; Vertical Containment
F12::
  CoordMode, Mouse, Screen
  MouseGetPos, Xv, Yv
  Confine := !Confine
  ;ClipCursor( Confine, A_ScreenWidth//2, 0, A_ScreenWidth//2+1, A_ScreenHeight )
  ClipCursor( Confine, Xv, 0, Xv+1, A_ScreenHeight )
Return


ClipCursor( Confine=True, x1=0 , y1=0, x2=1, y2=1 ) {
	VarSetCapacity(R,16,0),  NumPut(x1,&R+0),NumPut(y1,&R+4),NumPut(x2,&R+8),NumPut(y2,&R+12)
	Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor" )
}

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload