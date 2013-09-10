#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

color1posX = 45
color1posY = 60

color2posX = 90
color2posY = 60

color3posX = 135
color3posY = 60

color4posX = 225
color4posY = 60

color5posX = 180
color5posY = 60

color6posX = 45
color6posY = 90

color7posX = 135
color7posY = 145

color8posX = 90
color8posY = 145

color9posX = 180
color9posY = 145

color0posX = 90
color0posY = 90

Loop, 10 {
	Index = %A_Index%
	Index--
	#ifWinActive, LogicWorks 5
	Hotkey, +%Index%, colorThis
}

#ifWinActive

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload

colorThis:
	; get mouse position
	num := SubStr(A_ThisHotkey, 0, 1)
	MouseGetPos, xPos%num%, yPos%num%
	xPos := xPos%num%
	yPos := yPos%num%
	
	; color it
	Click Right
	Sleep, 100
	Send c
  	Send {Enter}
	Sleep, 100
	colorPosX := color%num%posX
	colorPosY := color%num%posY
	Click, %colorPosX%, %colorPosY%
	Click, 400, 250
	
	; return mouse to original location
	MouseMove, xPos, yPos
return