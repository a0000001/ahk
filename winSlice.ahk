#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

; http://www.autohotkey.com/forum/viewtopic.php?p=391678#391678

WindowTransparency = 255
MinSize = 30

CoordMode, Mouse, Relative
CoordMode, ToolTip, Relative
SetWinDelay, 0
Return

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload

Left::
WinMove, ahk_id %WindowID%,, 500, 500
Return

Space::
Gui, Destroy
SelectWindow()
SelectRegion(RegionX,RegionY,RegionW,RegionH)
WinGet, PreviousTransparency, Transparent, ahk_id %WindowID%
If PreviousTransparency =
 PreviousTransparency = Off
WinSet, AlwaysOnTop, On, ahk_id %WindowID%
WinSet, Region, %RegionX%-%RegionY% w%RegionW% h%RegionH% r5-5, ahk_id %WindowID%
Gui, Add, Text, x5 y1 w25 h20 gMoveWin, ::::::::
Gui, Add, Button, x32 y1 w50 h20 Default gToggleDisable vToggleDisable, Disable
Gui, Add, Button, x82 y1 w50 h20 gRestoreWin, Restore
Gui, Add, Button, x132 y1 w80 h20 gChangeTransparency, Transparency
Gui, +AlwaysOnTop +LastFound -Caption +ToolWindow
WinSet, Region, 0-0 w215 h23 R10-10
If (Round(WindowTransparency) = 255)
{
 WinSet, Transparent, Off
 WinSet, Transparent, Off, ahk_id %WindowID%
}
Else
{
 WinSet, Transparent, %WindowTransparency%
 WinSet, Transparent, %WindowTransparency%, ahk_id %WindowID%
}
WinGetPos, TempX, TempY,,, ahk_id %WindowID%
Gui, Show, % "x" . (RegionX + TempX) . " y" . ((RegionY - 23) + TempY) . " w215 h23"
Return

GuiClose:
Return

;2GuiClose:
;Return

MoveWin:
MouseGetPos, PosX, PosY
Gui, +LastFound
WinGetPos, TempX, TempY
WinGetPos, OffsetX, OffsetY,,, ahk_id %WindowID%
OffsetX -= TempX
OffsetY -= TempY
SetTimer, DragWin, 100

DragWin:
If Not GetKeyState("LButton","P")
{
 SetTimer, DragWin, Off
 Return
}
CoordMode, Mouse
MouseGetPos, TempX, TempY
Gui, +LastFound
WinMove,,, TempX - PosX, TempY - PosY
WinMove, ahk_id %WindowID%,, (TempX + OffsetX) - PosX, (TempY + OffsetY) - PosY
Return

ToggleDisable:
If WinDisabled
{
 WinDisabled =
 Gui, +LastFound
 WinSet, Enable,, ahk_id %WindowID%
 WinSet, ExStyle, -0x20, ahk_id %WindowID%
 GuiControl,, ToggleDisable, Disable
}
Else
{
 WinDisabled = 1
 Gui, +LastFound
 WinSet, ExStyle, -0x20, ahk_id %WindowID%
 WinSet, Disable,, ahk_id %WindowID%
 GuiControl,, ToggleDisable, Enable
}
Return

ChangeTransparency:
WindowTransparency /= 2.55
Gui, 2:Default
Gui, Add, Text, x2 y0 w70 h20 +Left, Transparency:
Gui, Add, Edit, x72 y0 w50 h20 gUpdateSlider vUpdateSlider
Gui, Add, UpDown, vWindowTransparency gWindowTransparency, %WindowTransparency%
Gui, Add, Slider, x2 y20 w120 h30 AltSubmit vSlidingTrans gSlidingTrans, %WindowTransparency%
Gui, Add, Button, x2 y52 w120 h20 Default gSaveTransparency, OK
Gui, +ToolWindow -Border +LastFound +AlwaysOnTop
WindowTransparency *= 2.55
WinSet, Transparent, %WindowTransparency%
GuiControl, Focus, SlidingTrans
Gui, Show, w125 h73, Transparency Settings
Return

UpdateSlider:
GuiControlGet, Temp1,, UpdateSlider
GuiControl,, SlidingTrans, %Temp1%
Return

WindowTransparency:
GuiControl,, SlidingTrans, %WindowTransparency%
Return

SlidingTrans:
GuiControl,, WindowTransparency, %SlidingTrans%
Return

SaveTransparency:
Gui, 2:Default
GuiControlGet, WindowTransparency,, WindowTransparency
Gui, Destroy
WindowTransparency *= 2.55
Gui, 1:Default
Gui, +LastFound
If (Round(WindowTransparency) = 255)
{
 WinSet, Transparent, Off
 WinSet, Transparent, Off, ahk_id %WindowID%
}
Else
{
 WinSet, Transparent, %WindowTransparency%
 WinSet, Transparent, %WindowTransparency%, ahk_id %WindowID%
}
Return

Esc::
RestoreWin:
RestoreWin()
ExitApp

Null:
Return

SelectWindow()
{
 global WindowID
 SelectButton = RButton
 Gui, 99:Color, Black
 Gui, 99:-Caption +ToolWindow +LastFound +AlwaysOnTop +E0x20
 WinSet, Transparent, 100
 SetTimer, Darken, 800
 Gosub, Darken
 Hotkey, %SelectButton%, Null
 KeyWait, %SelectButton%, D
 KeyWait, %SelectButton%
 SetTimer, Darken, Off
 Gui, 99:Destroy
 MouseGetPos,,, WindowID
 ToolTip
 Hotkey, %SelectButton%, Off
 Return

 Darken:
 MouseGetPos,,, TempID
 If TempID = %TempID1%
  Return
 WinGetPos, TempX, TempY, TempW, TempH, ahk_id %TempID%
 Gui, 99:Show, x%TempX% y%TempY% w%TempW% h%TempH% NoActivate
 ToolTip, Press %SelectButton% on a window to select it.
 TempID1 = %TempID%
 Return
}

SelectRegion(ByRef RegionX,ByRef RegionY,ByRef RegionW,ByRef RegionH)
{
 global WindowID
 global MinSize
 DragKey = LButton
 ConfirmKey = Enter
 Gui, 99:Color, Black
 Gui, 99:-Caption +ToolWindow +LastFound +AlwaysOnTop
 WinSet, Transparent, 100
 WinActivate, ahk_id %WindowID%
 WinGetPos, TempX, TempY, TempW, TempH, ahk_id %WindowID%
 Gui, 99:+LastFound
 Gui, 99:Show, x%TempX% y%TempY% w%TempW% h%TempH% NoActivate
 Hotkey, %DragKey%, Drag
 Loop
 {
  ToolTip, Drag %DragKey% over the region to keep on top. Press %ConfirmKey% when done
  Hotkey, %ConfirmKey%, Null
  KeyWait, %ConfirmKey%, D
  KeyWait, %ConfirmKey%
  ToolTip
  If SelectX =
   Continue
  If SelectY =
   Continue
  If SelectX > %SelectW%
  {
   Temp1 = %SelectX%
   SelectX = %SelectW%
   SelectW = %Temp1%
  }
  If SelectY > %SelectH%
  {
   Temp1 = %SelectY%
   SelectY = %SelectH%
   SelectH = %Temp1%
  }
  RegionX = %SelectX%
  RegionY = %SelectY%
  RegionW := Abs(SelectW - SelectX)
  RegionH := Abs(SelectH - SelectY)
  If (RegionW < MinSize || RegionH < MinSize)
  {
   ToolTip, The width and height of selection must be at least %MinSize% pixels each.
   WinSet, Region
   Sleep, 2000
  }
  Else
   Break
 }
 Gui, 99:Destroy
 Hotkey, %DragKey%, Off
 Hotkey, %ConfirmKey%, Off
 Return

 Drag:
 MouseGetPos, SelectX, SelectY
 SelectY -= TitleBarSize
 WinGetPos,,, TempW, TempH, ahk_id %WindowID%
 If (SelectX < 0 || SelectY < 0 || SelectX > TempW || SelectY > TempH)
  Return
 SetTimer, ResizeSelection, 100

 DragUp:
 If Not GetKeyState(DragKey,"P")
 {
  SetTimer, ResizeSelection, Off
  Return
 }
 Return

 ResizeSelection:
 MouseGetPos, SelectW, SelectH
 If (SelectW = SelectW1 && SelectH = SelectH1)
  Return
 If SelectW < 0
  SelectW = 0
 If SelectH < 0
  SelectH = 0
 If SelectW > %TempW%
  SelectW = %TempW%
 If SelectH > %TempH%
  SelectH = %TempH%
 Gui, 99:+LastFound
 If Not GetKeyState(DragKey,"P")
 {
  SetTimer, ResizeSelection, Off
  Return
 }
 WinSet, Region, 0-0 %TempW%-0 %TempW%-%TempH% 0-%TempH% 0-0 %SelectX%-%SelectY% %SelectW%-%SelectY% %SelectW%-%SelectH% %SelectX%-%SelectH% %SelectX%-%SelectY%
 SelectW1 = %SelectW%
 SelectH1 = %SelectH%
 Return
}

RestoreWin()
{
 global WindowID
 global PreviousTransparency
 WinSet, Enable,, ahk_id %WindowID%
 WinSet, Region,, ahk_id %WindowID%
 WinSet, AlwaysOnTop, Off, ahk_id %WindowID%
 WinSet, Transparent, %PreviousTransparency%
}