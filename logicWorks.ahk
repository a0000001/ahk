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

;Loop, 10 {
;	Index = %A_Index%
;	Index--
;	Hotkey, +%Index%, colorThis
;}

#ifWinActive, LogicWorks 5

colorThis:
	; get mouse position
	CoordMode, Mouse, Relative
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

+1::
+2::
+3::
+4::
+5::
+6::
+7::
+8::
+9::
+0::
	Gosub, colorThis
return

^+t::
	Send !w
	Sleep 100
	Send {Down}{Down}{Down}
	Send {Enter}
return

^+p::
	CoordMode, Mouse, Relative
	MouseGetPos, xPos, yPos
	Click 260,60
	MouseMove, xPos, yPos
return

+#r::
	Send !m
	Sleep 100
	Send rr
	Send {Enter}
return

#ifWinActive