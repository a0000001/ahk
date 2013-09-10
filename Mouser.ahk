#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

SetWinDelay,0 

Gosub,INI
Gosub,TRAYMENU
; Get the monitor resolution (from http://www.donationcoder.com/Software/Skrommel/DimSaver/DimSaver.ahk)
SysGet,monitorcount,MonitorCount
l=0
t=0
r=0
b=0
Loop,%monitorcount%
{
SysGet,monitor,Monitor,%A_Index%
If (monitorLeft<l)
l:=monitorLeft
If (monitorTop<t)
t:=monitorTop
If (monitorRight>r)
r:=monitorRight
If (monitorBottom>b)
b:=monitorBottom
}
resolutionRight:=r+Abs(l)
resolutionBottom:=b+Abs(t)

;SysGet, resolution, Monitor
;SysGet, resolutionRight, 78
;SysGet, resolutionBottom, 79

half_x := Ceil(resolutionRight/2)
ceiling := 0
right := Ceil(resolutionRight)
box_w := 0
box_y := 0



visualizations := visualizations
color := Ceil(color)
transparency:=transparency
locator := locator
mouse_up := mousekeyup
mouse_down := mousekeydown
mouse_left := mousekeyleft
mouse_right := mousekeyright
leftclick := leftclick
rightclick := rightclick

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload

^+Enter::
Click
return

START:
CoordMode, Mouse
MouseGetPos, current_x, current_y
if STARTED <> "yes"
{
	if locator = 1
	{
		GoSub, Locate
	}
	first_y = "y"
	first_x = "y"
	move_x := current_x
	move_y := current_y
	full_y := Ceil(resolutionBottom)
	floor := Ceil(resolutionBottom)

}
STARTED = "yes"


Loop
{
	;MsgBox, New Coordinates: %move_x% x %move_y%
	MouseGetPos, current_x, current_y
	Input, UserInput, T5 L1, {Enter}{Escape}{Up}{Down}{Left}{Right},%mouse_up%,%mouse_left%,%mouse_down%,%mouse_right%,%leftclick%,%rightclick%,%doubleclick%
	IfInString, ErrorLevel, EndKey:Up
	{
		Gosub, UP
		Gosub, Start
	}
	IfInString, ErrorLevel, EndKey:Down
	{
		Gosub, DOWN
		Gosub, Start
	}
	IfInString, ErrorLevel, EndKey:Left
	{
		Gosub, LEFT
		Gosub, Start
	}
	IfInString, ErrorLevel, EndKey:Right
	{
		Gosub, RIGHT
		Gosub, Start
	}
	
	IfInString, ErrorLevel, EndKey:Escape
	{
		Gosub, Quit
	}
	IfInString, ErrorLevel, EndKey:Enter
	{
		Gosub, ClickMouse
	}

	if UserInput = %mouse_up%
	{
		Gosub, UP
	}
	else if UserInput = %mouse_down%
	{
		Gosub, DOWN
	}
	else if UserInput = %mouse_left%
	{
		Gosub, LEFT
	}
	else if UserInput = %mouse_right%
	{
		Gosub, RIGHT
	}
	else if UserInput = %leftclick%
	{
		GoSub, ClickMouse
	}
	else if UserInput = %rightclick%
	{
		GoSub, RightClickMouse
		Exit
	}
	else if UserInput = d
	{
		GoSub, DoubleClickMouse
		Exit
	}

	if ErrorLevel = Max
	{
				
	}
	if ErrorLevel = NewInput
		return
}
return

UP:
	if first_y = ""
	{
		box_w_t := resolutionBottom - half_y
		move_y := Ceil(current_y - half_y)
		floor := current_y
	}
	if first_y = "y"
	{
		half_y := current_y/2
		floor := current_y
		move_y := Ceil(current_y - (half_y))
		box_w_t := resolutionBottom
	}
	half_y := half_y/2
	MouseMove, %move_x%, %move_y%
	if visualizations = 1
	{
		;;; Create Window ;;;
		Gui,4: +AlwaysOnTop -Caption +LastFound +ToolWindow
		Gui,4: Color, Ceil(color)
		if transparencyon = 1
		{
			WinSet, TransColor, EEAAEE %transparency%
		}
		Gui,4: Show, x0 y%floor% w%resolutionRight% h%box_w_t% noactivate
	}
	first_y = ""
return

DOWN:
	if first_y = "y"
	{
		half_y := (resolutionBottom - current_y)/2
		ceiling := current_y
		move_y := Ceil(current_y + half_y)
		box_y := ceiling
	}
	;
	if first_y = ""
	{
		ceiling := current_y
		move_y := Ceil(half_y + current_y)
		box_y := current_y
	}
	half_y := half_y/2
	MouseMove, %move_x%, %move_y%
	if visualizations = 1
	{
		;;; Create Window ;;;
		Gui,3: +AlwaysOnTop -Caption +LastFound +ToolWindow
		Gui,3: Color, Ceil(color)
		if transparencyon = 1
		{
			WinSet, TransColor, EEAAEE %transparency%
		}
		Gui,3: Show, x0 y0 w%resolutionRight% h%box_y% noactivate
	}
	first_y = ""
return

LEFT:
	if first_x = "y"
	{
		half_x := current_x/2
		right := current_x
		move_x := Ceil(current_x - (half_x))
		box_w_r := resolutionRight
	}
	if first_x = ""
	{
		box_w_r := resolutionRight - half_x
		right := right - half_x
		half_x := half_x/2
		move_x := Ceil(right - half_x)
	}
	first_x = ""
	MouseMove, %move_x%, %move_y%
	if visualizations = 1
	{
		;;; Create Window ;;;
		Gui,2: +AlwaysOnTop -Caption +LastFound +ToolWindow
		Gui,2: Color, Ceil(color)
		if transparencyon = 1
		{		
			WinSet, TransColor, %color% %transparency%
		}
		Gui,2: Show, x%right% y0 w%box_w_r% h%resolutionBottom% noactivate
	}
return

RIGHT:
	if first_x = "y"
	{
		half_x := (resolutionRight - current_x)/2
		left := current_x
		move_x := Ceil(current_x + half_x)
		box_w := left
	}
	if first_x = ""
	{
		box_w := box_w + half_x
		left := left + half_x
		half_x := half_x/2
		move_x := Ceil(current_x + half_x)
	}
	first_x = ""
	MouseMove, %move_x%, %move_y%
	if visualizations = 1
	{		
		;;; Create Window ;;;
		Gui,1: +AlwaysOnTop -Caption +LastFound +ToolWindow
		Gui,1: Color, Ceil(color)
		if transparencyon = 1
		{
			WinSet, TransColor, EEAAEE %transparency%
		}
		Gui,1: Show, x0 y0 w%box_w% h%resolutionBottom% noactivate
	}
return

Quit:
Gui,1: Destroy
Gui,2: Destroy
Gui,3: Destroy
Gui,4: Destroy
STARTED = "no"
Gosub, EMPTY
Exit
return

ClickMouse:
Click
Gui,1: Destroy
Gui,2: Destroy
Gui,3: Destroy
Gui,4: Destroy
STARTED = "no"
Gosub, EMPTY
Exit
return

RightClickMouse:
Click right
Gui,1: Destroy
Gui,2: Destroy
Gui,3: Destroy
Gui,4: Destroy
STARTED = "no"
Gosub, EMPTY
Exit
return

DoubleClickMouse:
Click
Click
Gui,1: Destroy
Gui,2: Destroy
Gui,3: Destroy
Gui,4: Destroy
STARTED = "no"
Gosub, EMPTY
Exit
return


EMPTY:
SysGet, resolution, Monitor
SysGet, resolutionRight, 78
SysGet, resolutionBottom, 79
half_x := Ceil(resolutionRight/2)
ceiling := 0
right := Ceil(resolutionRight)
box_w := 0
box_y := 0
Exit
return

Locate:
delay := 200
x_pos := Ceil(current_x - 50)
y_pos := Ceil(current_y - 50)
Gui, 5: +AlwaysOnTop -Caption +LastFound +ToolWindow
Gui, 5: Color, FF3333
WinSet, TransColor, %color% %transparency%
Gui,5: Show, x%x_pos% y%y_pos% w100 h100 noactivate
Loop, 1
{
	Sleep, %delay%
	WinHide
	Sleep, %delay%
	WinShow
}
Sleep, %delay%
Gui, 5: Destroy
return

INI:
IfNotExist,Mouser.ini
{
  IniWrite,^M,Mouser.ini,Settings,hotkey
  IniWrite,1,Mouser.ini,Settings,visualizations
  IniWrite,FF3333,Mouser.ini,Settings,color
  IniWrite,70,Mouser.ini,Settings,transparency
  IniWrite,1,Mouser.ini,Settings,locator
  IniWrite,1,Mouser.ini,Settings,transparencyon
  IniWrite,i,Mouser.ini,Settings,mousekeyup
  IniWrite,j,Mouser.ini,Settings,mousekeyleft
  IniWrite,l,Mouser.ini,Settings,mousekeyright
  IniWrite,`,,Mouser.ini,Settings,mousekeydown
  IniWrite,k,Mouser.ini,Settings,leftclick
  IniWrite,d,Mouser.ini,Settings,doubleclick
  IniWrite,r,Mouser.ini,Settings,rightclick

}
IniRead,hotkey,Mouser.ini,Settings,hotkey
IniRead,visualizations,Mouser.ini,Settings,visualizations
IniRead,color,Mouser.ini,Settings,color
IniRead,transparency,Mouser.ini,Settings,transparency
IniRead,locator,Mouser.ini,Settings,locator
IniRead,mousekeyup,Mouser.ini,Settings,mousekeyup
IniRead,mousekeyleft,Mouser.ini,Settings,mousekeyleft
IniRead,mousekeyright,Mouser.ini,Settings,mousekeyright
IniRead,mousekeydown,Mouser.ini,Settings,mousekeydown
IniRead,leftclick,Mouser.ini,Settings,leftclick
IniRead,rightclick,Mouser.ini,Settings,rightclick
IniRead,doubleclick,Mouser.ini,Settings,doubleclick
IniRead,transparencyon,Mouser.ini,Settings,transparencyon
HotKey,%hotkey%,START
Return

TRAYMENU:
Menu,Tray,NoStandard 
Menu,Tray,DeleteAll 
Menu,Tray,Add,Mouser,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Default,Mouser
Menu,Tray,Tip,Mouser
Return

SETTINGS:
HotKey,%hotkey%,Off
Gui,8: Destroy
Gui,8: Add,GroupBox,xm ym w400 h70,&Hotkey
Gui,8: Add,Hotkey,xp+10 yp+20 w380 vshotkey, %hotkey%
StringReplace,current,hotkey,+,Shift +%A_Space%
StringReplace,current,current,^,Ctrl +%A_Space%
StringReplace,current,current,!,Alt +%A_Space%
Gui,8: Add,Text,,Current hotkey: %current%


Gui,8: Add,GroupBox,xm 30 w400 h120,&Mouse movement keys

; Hotkey UP
Gui,8: Add, Text, xm+170 yp+20, UP
Gui,8: Add,Hotkey,xm+175 yp+20 w50 vsmousekeyup, %mousekeyup%
StringReplace,currentup,mousekeyup,+,Shift +%A_Space%
StringReplace,currentup,currentup,^,Ctrl +%A_Space%
StringReplace,currentup,currentup,!,Alt +%A_Space%

; Hotkey LEFT
Gui,8: Add, Text, xm+90 yp+20, LEFT
Gui,8: Add,Hotkey,xp+36 yp w50 vsmousekeyleft, %mousekeyleft%
StringReplace,currentleft,mousekeyleft,+,Shift +%A_Space%
StringReplace,currentleft,currentleft,^,Ctrl +%A_Space%
StringReplace,currentleft,currentleft,!,Alt +%A_Space%

; Hotkey RIGHT
Gui,8: Add,Hotkey,xp+98 yp w50 vsmousekeyright, %mousekeyright%
StringReplace,currentright,mousekeyright,+,Shift +%A_Space%
StringReplace,currentright,currentright,^,Ctrl +%A_Space%
StringReplace,currentright,currentright,!,Alt +%A_Space%
Gui,8: Add, Text, xp+55 yp, RIGHT

; Hotkey DOWN
Gui,8: Add,Hotkey,xp-104 yp+20 w50 vsmousekeydown, %mousekeydown%
StringReplace,currentdown,mousekeydown,+,Shift +%A_Space%
StringReplace,currentdown,currentdown,^,Ctrl +%A_Space%
StringReplace,currentdown,currentdown,!,Alt +%A_Space%
Gui,8: Add, Text, xp+35 yp+25, DOWN

Gui,8: Add,GroupBox,xm yp+30 w400 h90,&Mouse clicks

; Hotkey LEFTCLICK
Gui,8: Add, Text, xm+10 yp+20, Left click:
Gui,8: Add, Hotkey,xm+75 yp-2 w50 vsleftclick, %leftclick%

; Hotkey RIGHTCLICK
Gui,8: Add, Text, xm+10 yp+25, Right click:
Gui,8: Add, Hotkey,xm+75 yp-2 w50 vsrightclick, %rightclick%

; Hotkey DOUBLECLICK
Gui,8: Add, Text, xm+10 yp+25, Double click:
Gui,8: Add, Hotkey,xm+75 yp-2 w50 vsdoubleclick, %doubleclick%


Gui,8: Add, Checkbox, xm+10 yp+40 vslocator_cbox Checked%locator%, Locator (flashes location of mouse when hotkey is pressed)
Gui,8: Add, Checkbox, vsvisualizations_cbox Checked%visualizations%, Screen visualizations (displays area of screen that has been ruled out)
Gui,8: Add,GroupBox,xm y+10 w400 h80,&Visualization Transparency (0 to 250; default:70; currently:%transparency%):
Gui,8: Add, Slider, xp+10 yp+20 w380 vstransparency Range0-250 ToolTipRight TickInterval25, %transparency%
Gui,8: Add, Checkbox, vstransparencyon_cbox Checked%transparencyon%, Transparency (turning transparency off speeds up mouse movement)
Gui,8: Add,Button,xm y+30 w75 GSETTINGSOK,&OK
Gui,8: Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,8: Show,,Mouser Settings
Return

SETTINGSOK:
Gui,8: Submit
If shotkey<>
{
  hotkey:=shotkey
  HotKey,%hotkey%,START
}
If smousekeyup<>
{
  mousekeyup := smousekeyup
  StringReplace, mousekeyup, mousekeyup, Numpad,,All
}
If smousekeyleft<>
{
  mousekeyleft := smousekeyleft
  StringReplace, mousekeyleft, mousekeyleft, Numpad,,All
}
If smousekeyright<>
{
  mousekeyright := smousekeyright
  StringReplace, mousekeyright, mousekeyright, Numpad,,All
}
If smousekeydown<>
{
  mousekeydown := smousekeydown
  StringReplace, mousekeydown, mousekeydown, Numpad,,All
}
If sleftclick<>
{
  leftclick := sleftclick
  StringReplace, leftclick, leftclick, Numpad,,All
}
If srightclick<>
{
  rightclick := srightclick
  StringReplace, rightclick, rightclick, Numpad,,All
}
If srightclick<>
{
  doubleclick := sdoubleclick
  StringReplace, doubleclick, doubleclick, Numpad,,All
}


HotKey,%hotkey%,On
If stransparency<>
  transparency:=stransparency
If slocator<>
  locator = %slocator%
if slocator_cbox<>
  locator := slocator_cbox
if svisualizations_cbox<>
  visualizations := svisualizations_cbox
if stransparencyon_cbox<>
  transparencyon := stransparencyon_cbox

IniWrite,%hotkey%,Mouser.ini,Settings,hotkey
IniWrite,%visualizations%,Mouser.ini,Settings,visualizations
IniWrite,%transparency%,Mouser.ini,Settings,transparency
IniWrite,%locator%,Mouser.ini,Settings,locator
IniWrite,%transparencyon%,Mouser.ini,Settings,transparencyon
IniWrite,%mousekeyup%, Mouser.ini, Settings,mousekeyup
IniWrite,%mousekeyleft%, Mouser.ini, Settings,mousekeyleft
IniWrite,%mousekeyright%, Mouser.ini, Settings,mousekeyright
IniWrite,%mousekeydown%, Mouser.ini, Settings,mousekeydown
IniWrite,%leftclick%, Mouser.ini, Settings,leftclick
IniWrite,%rightclick%, Mouser.ini, Settings,rightclick
IniWrite,%doubleclick%, Mouser.ini, Settings,doubleclick
Gui, 8: Destroy
Reload
Sleep 1000
MsgBox, Please restart Mouser to activate new settings.
Return

SETTINGSCANCEL:
HotKey,%hotkey%,START,On
HotKey,%hotkey%,On
Gui,8: Destroy
Return


ABOUT:
Gui,Destroy
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,Mouser v1.0 - by Adam Pash
Gui,Font
Gui,Add,Text,xm,Press Ctrl+M to locate and move the mouse.
Gui,Add,Text,xm,To change the settings, choose Settings in the tray menu.
Gui,Add,Text,xm y+15,Made using AutoHotkey 
Gui,Font
Gui,Font
Gui,Add,Text,xm,For more Autohotkey love, check out:
Gui, Font, Bold
Gui,Add,Text,xm,http://lifehacker.com/software/autohotkey
Gui,Show,,ShiftOff About
about=
Return

EXIT:
ExitApp