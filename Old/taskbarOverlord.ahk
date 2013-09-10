; Moved into MouseWheelEmulator to prevent collisions.



; http://www.ocellated.com/2009/06/04/taskbar-overlord/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#ifWinNotActive, ahk_class Halo
#ifWinNotActive, ahk_class TAGAP2

;Handle middle clicks on Windows 7 Taskbar to close all windows for a given icon
;********************************************************************************
	
	MButton::
		CoordMode, Mouse, Screen
		MouseGetPos, x, y, WinUnderMouseID
		;WinActivate, ahk_id %WinUnderMouseID%

	;Get y position relative to the bottom of the screen.
	yTop := y
	
	; Close taskbar program on middle click, if click on a taskbar icon
	if yTop <= 40
	{
		BlockInput On
		Send, +{Click %x% %y% right} ;shift right click
		Sleep, 100
		Send, C ;send c which is Close All Windows
		WinWaitNotActive, ahk_class Shell_TrayWnd,, 0.5 ; wait for save dialog, etc
		If ErrorLevel = 1
			Send, {Escape} ;hides context menu if no program icon clicked.
		BlockInput Off
	; else send normal middle click
	} else {
		If GetKeyState("MButton") {	;The middle button is physically down
			MouseClick, Middle,,,0,D 		;middle button down
			KeyWait, MButton				;to allow dragging
			MouseClick, Middle,,,,0,U		;release middle button up
		} Else {
			MouseClick, Middle,,
		}
	 }
	 
	Return