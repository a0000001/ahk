; http://www.autohotkey.com/community/viewtopic.php?t=5273

;#   GUI to create screenshots easily
;#
;#   OS: Windows XP
;#   AHK version: 1.0.41.00   (http://www.autohotkey.com/download/)
;#   Date: 2006-01-25
;#
;#   inspired by EasyCopy from http://www.augrin.com
;#   which we have on UNIX but not on PC
;#
;#   Idea and technique to draw the frame with DllCall are from shimanov
;#   http://www.autohotkey.com/forum/viewtopic.php?t=5206
;#
;#   Several new features added by hps
;#
;#   Requires: IrfanView
;#
;#   Known problems:
;#      -
;#
;#   Wish list:
;#      - Auto-Interval (image sequence in timesteps)
;#      - Create Multi-Tif
;#      - Create Amimation with VideoMach

;#############   Directives   #################################################

;IrfanView: Tool, to process image files; source: "http://www.irfanview.com"
;in the subfolder "Plugins" of IrfanView the file "Effects.dll" is needed.
;as a default the executable and subfolder with the dll is assumed to be in the same folder with the script
SplitPath, A_ScriptName,,,, ScriptNoExt
StartCenterIni      = %ScriptNoExt%.ini
IniRead, ExeCapture, %StartCenterIni%, EasyCopy, ExeCapture, i_view32.exe
If not FileExist(ExeCapture)
  {
    FileSelectFile, ExeCapture , 3, , Please select the executable of IrfanView (i_view32.exe), Executables (*.exe)
    If ( not FileExist(ExeCapture) or not ExeCapture )
      {
        MsgBox, 16, IrfanView not found,The executable of Irfanview`n%ExeCapture%`ncouldn't be found.`nThe script will exit now.
        ExitApp
      }
    IniWrite, %ExeCapture%, %StartCenterIni%, EasyCopy, ExeCapture
  }

Version             = v0.7
EasyCopyWindowtitle = Easy Copy AHK
EasyCopyIconID      = 175
PathProjects        = %A_ScriptDir%

;location of icon file
If ( A_OSType = "WIN32_WINDOWS" )  ; Windows 9x
    IconFile = %A_WinDir%\system\shell32.dll
else
    IconFile = %A_WinDir%\system32\shell32.dll

;get screen size
ScreenWidth = %A_ScreenWidth%
ScreenHeight = %A_ScreenHeight%

;the followup version to Irfanview 3.9.7.0 will be able to capture regions on secondary monitors
FileGetVersion, ExeCaptureversion , %ExeCapture%
If ExeCaptureVersion > 3.9.7.0
  {
    ; get screen size from virtual screen
    Sysget, ScreenWidth, 78
    Sysget, ScreenHeight, 79
  }

#SingleInstance force                           ;enforce only one instance
SetBatchLines, -1
CoordMode, Mouse, Screen

;get previous settings
GoSub, ReadDefaultsFromIni

;Tray menu
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, %IconFile%, %EasyCopyIconID%  ;icon for window and for proces in task manager
If ErrorLevel
    Menu, Tray, Icon, %IconFile%, 14  ;different icon ID, if Iconfile doesn't contain enough Icons
Menu, Tray, UseErrorLevel, Off
Menu, Tray, NoStandard
Menu, Tray, Tip, %EasyCopyWindowtitle%
Menu, Tray, Add, Show EasyCopy, TrayShowGui
Menu, Tray, Add, Open Destination, BtnOpen
Menu, Tray, Add, Options, BtnOptions
Menu, Tray, Add, Capture Screen, BtnCaptureScreen
Menu, Tray, Add, Capture Window, BtnCaptureWindow
Menu, Tray, Add, Capture Client Area, BtnCaptureClientArea
Menu, Tray, Add, Capture Region, BtnCaptureRegion
Menu, Tray, Add, Capture Redo, BtnRedoCapture
Menu, Tray, Add, Exit, GuiClose
Menu, Tray, Default, Show EasyCopy
If ShowGuiWithSingleCLick
   Menu, Tray, Click, 1

;Show GUI
GoSub, BuildGuiEasyCopy

;Activate hotkeys
GoSub, ActivateHotKeys

;activate gui mouse hotkeys
WM_RBUTTONDOWN = 0x204
OnMessage(WM_RBUTTONDOWN , "RollUpDownGui1")
WM_MBUTTONDOWN = 0x207
OnMessage(WM_MBUTTONDOWN , "ToggleOnTop")

;specify temp file for preview
TempFileName = %TEMP%\Easycopy_screenshot_temp
Return
;##############################################################################
;#############   End of AutoExecution-Section   ###############################
;##############################################################################


;##############################################################################
;#############   Actions of GUI 1 - EasyCopy   ################################
;##############################################################################

;#############   Build GUI 1 for Easy Copy   ##################################
BuildGuiEasyCopy:
  Gui, 1:Margin, 1, 1
  Gui, 1:+ToolWindow
  Gui, 1:Add, Button, xm Section gBtnCaptureScreen, &Screen
  Gui, 1:Add, Button, ys gBtnCaptureWindow, &Window
  Gui, 1:Add, Button, ys gBtnCaptureClientArea, &Client Area
  Gui, 1:Add, Button, ys gBtnCaptureRegion, &Region
  Gui, 1:Add, Button, ys gBtnRedoCapture, Re&do
  Gui, 1:Add, Text, xm y+6 Section, Path:
  Gui, 1:Add, Edit, ys-4 Right r1 w205 vEdtPath, %EdtPath%
  Gui, 1:Add, Button, ys-5 gBtnBrowsePath, ...
  Gui, 1:Add, Text, xm y+6 Section, File:
  Gui, 1:Add, Edit, ys-4 r1 w232 vEdtFileName, %EdtFileName%
  Gui, 1:Add, Checkbox, xm y+6 Section vChkShowPreview Checked%ChkShowPreview%, preview
  Gui, 1:Add, Button, ys-5 vBtnSave gBtnSave Disabled, Save
  Gui, 1:Add, Button, ys-5 vBtnPrint gBtnPrint Disabled, Print
  Gui, 1:Add, Button, ys-5 gBtnOptions, Options
  Gui, 1:Add, Button, ys-5 gBtnOpen, Open
  Gui, 1:Add, Button, ys-5 vBtnEdit gBtnEdit Disabled, Edit 
  Gui, 1:Add, Picture, xm vPicPreview,
 
  ShowOptions =
  If HideGuiOnStart
    {
      DetectHiddenWindows, On
      ShowOption = Hide
    }
  IniRead, Pos_Gui1, %StartCenterIni%, EasyCopy, Pos_Gui1, x0 y0
  WinnameGui1 = %EasyCopyWindowtitle% %Version%
  Gui, 1:Show, %ShowOption% %Pos_Gui1%,%WinnameGui1%

  ;get uniqueID of GUI for window roll up
  WinGet, Gui1UniqueID, ID, %WinNameGui1%
  GuiRolledUp := False

  ;get Gui width and height for Resize of Preview
  WinGetPos, , , Gui1Width, Gui1Height, ahk_id %Gui1UniqueID%
  DetectHiddenWindows, Off
Return

;#############   Read user defaults from ini   ################################
ReadDefaultsFromIni:
  IniRead, EdtPath,        %StartCenterIni%, EasyCopy, EdtPath,        %PathProjects%
  IniRead, EdtFileName,    %StartCenterIni%, EasyCopy, EdtFileName,    shot_##.jpg
  IniRead, ChkShowPreview, %StartCenterIni%, EasyCopy, ChkShowPreview, 1

  IniRead, ChkAutoNumber,  %StartCenterIni%, EasyCopy, ChkAutoNumber,  1
  IniRead, EdtAutoNumber,  %StartCenterIni%, EasyCopy, EdtAutoNumber,  1
  IniRead, ChkHideMouse,   %StartCenterIni%, EasyCopy, ChkHideMouse,   1
  IniRead, ChkAllowRegionMove, %StartCenterIni%, EasyCopy, ChkAllowRegionMove, 0
  IniRead, OpenAsThumbs,   %StartCenterIni%, EasyCopy, OpenAsThumbs,   1

  IniRead, CobFrameColor, %StartCenterIni%, EasyCopy, CobFrameColor, 00FFFF Yellow
  IniRead, EdtFrameThickness, %StartCenterIni%, EasyCopy, EdtFrameThickness, 2
  IniRead, ChkDrawGoldenCut, %StartCenterIni%, EasyCopy, ChkDrawGoldenCut, 1
  IniRead, CobGoldenCutColor, %StartCenterIni%, EasyCopy, CobGoldenCutColor, FF00FF Fuchsia
  IniRead, CobGoldenCutStyle, %StartCenterIni%, EasyCopy, CobGoldenCutStyle, 1 dash
  IniRead, ChkDrawCrossLines, %StartCenterIni%, EasyCopy, ChkDrawCrossLines, 1
  IniRead, CobCrossLinesColor, %StartCenterIni%, EasyCopy, CobCrossLinesColor, 0000FF Red
  IniRead, CobCrossLinesStyle, %StartCenterIni%, EasyCopy, CobCrossLinesStyle, 2 dot

  IniRead, ShortCutCaptureScreen,  %StartCenterIniFile%, EasyCopy, ShortCutCaptureScreen, !1
  IniRead, ShortCutCaptureWindow, %StartCenterIniFile%, EasyCopy, ShortCutCaptureWindow, !2
  IniRead, ShortCutCaptureClientArea, %StartCenterIniFile%, EasyCopy, ShortCutCaptureClientArea, !3
  IniRead, ShortCutCaptureRegion,    %StartCenterIniFile%, EasyCopy, ShortCutCaptureRegion, !4
  IniRead, ShortCutRedoCapture,   %StartCenterIniFile%, EasyCopy, ShortCutRedoCapture, !5

  IniRead, CobColorDepth, %StartCenterIni%, EasyCopy, CobColorDepth, No change
  IniRead, ChkSwapBlackAndWhite, %StartCenterIni%, EasyCopy, ChkSwapBlackAndWhite, 0
  IniRead, ChkGrayScale, %StartCenterIni%, EasyCopy, ChkGrayScale, 0
  IniRead, ChkApplySharpen, %StartCenterIni%, EasyCopy, ChkApplySharpen, 0
  IniRead, EdtSharpen, %StartCenterIni%, EasyCopy, EdtSharpen, 33
  IniRead, ChkApplyContrast, %StartCenterIni%, EasyCopy, ChkApplyContrast, 0
  IniRead, EdtContrast, %StartCenterIni%, EasyCopy, EdtContrast, 33

  IniRead, CobTifCompression, %StartCenterIni%, EasyCopy, CobTifCompression, Default
  IniRead, EdtJpgQuality, %StartCenterIni%, EasyCopy, EdtJpgQuality, 75
  IniRead, CopytoClipboard, %StartCenterIni%, EasyCopy,CopytoClipboard, 0

  IniRead, HideGuiOnStart, %StartCenterIni%, EasyCopy, HideGuiOnStart, 0   
  IniRead, HideGuiAfterCapture, %StartCenterIni%, EasyCopy, HideGuiAfterCapture, 0
  IniRead, ShowGuiWithSingleCLick, %StartCenterIni%, EasyCopy,ShowGuiWithSingleCLick, 1
Return

;#############   Activates user defined hotkeys   #############################
ActivateHotKeys:
  Hotkey, %ShortCutCaptureScreen%,     BtnCaptureScreen, On
  Hotkey, %ShortCutCaptureWindow%,     BtnCaptureWindow, On
  Hotkey, %ShortCutCaptureClientArea%, BtnCaptureClientArea, On
  Hotkey, %ShortCutCaptureRegion%,     BtnCaptureRegion, On
  Hotkey, %ShortCutRedoCapture%,       BtnRedoCapture, On
Return

;#############   Browse to Path to save image file   ##########################
BtnBrowsePath:
  Gui, 1: Submit, NoHide
  Gui, 1:+OwnDialogs
  FileSelectFolder, SelectedDir, *%EdtPath%, 3, Select Path to save image file
  if SelectedDir
      GuiControl, 1: ,EdtPath, %SelectedDir%
  ;right justiefy the edit controls content if longer then control length
  SendMessage, 0xB1, 500, 500, Edit1 ; 0xB1 is EM_SETSEL
return

;#############   Close Gui 1  and save settings   #############################
GuiEscape:
GuiClose:
  Gui, 1: Submit, NoHide
  IniWrite, %EdtPath%,        %StartCenterIni%, EasyCopy, EdtPath
  IniWrite, %EdtFileName%,    %StartCenterIni%, EasyCopy, EdtFileName
  IniWrite, %ChkShowPreview%, %StartCenterIni%, EasyCopy, ChkShowPreview
  Gui, 1:Show, Hide
  DetectHiddenWindows, On
  WinGetPos, PosX, PosY, , , ahk_id %Gui1UniqueID%
  IniWrite, x%PosX% y%PosY%, %StartCenterIni%, EasyCopy, Pos_Gui1
  ExitApp
Return

;#############   Show / Hide Gui1 from tray menu ( or hide by rollup )  ######
RollUpDownGui1(wParam, lParam, msg, hwnd)
  {
    Global Gui1UniqueID, GuiRolledUp, ShowGuiWithSingleCLick
    If (ShowGuiWithSingleCLick and msg = "0x204")
        Gui, 1:Hide
    Else
      {
        WM_NCMOUSEMOVE = 0xA0
        If ( GuiRolledUp and msg = WM_NCMOUSEMOVE)
          {
            Gui, 1:Show, AutoSize
            OnMessage(WM_NCMOUSEMOVE , "")
          }
        Else If ( !GuiRolledUp and msg = "0x204")
          {
            WinMove, ahk_id %Gui1UniqueID%,,,,, 22
            OnMessage(WM_NCMOUSEMOVE , "RollUpDownGui1")
          }
        Else
            Return
        GuiRolledUp := not GuiRolledUp
      }
  }

;#############   Toggle Show/hide of GUI from Tray   ##########################
TrayShowGui:
  IfWinExist, ahk_id %Gui1UniqueID%
       Gui, 1:Hide
  Else
      Gui, 1:Show, AutoSize
Return

;#############   Open destination folder in explorer   ########################
BtnOpen:
  Gui, 1: Submit, NoHide
  If OpenAsThumbs
      Run, %ExeCapture% "%EdtPath%" /thumbs
  Else
      Run, explorer /e`,"%EdtPath%"
Return

;#############   toggle Gui 1 stay on top   ##############################
ToggleOnTop(wParam, lParam, msg, hwnd)
  {
    Global Gui1UniqueID
    WinGet, ExStyle, ExStyle, ahk_id %Gui1UniqueID%
    WinGetTitle, CurrentTitle , ahk_id %Gui1UniqueID%
    If (ExStyle & 0x8) ; 0x8 is WS_EX_TOPMOST
      {
        Gui, 1: -AlwaysOnTop
        StringTrimRight, CurrentTitle, CurrentTitle, 8
        WinSetTitle, ahk_id %Gui1UniqueID%, , %CurrentTitle%
      }
    Else
      {
        Gui, 1: +AlwaysOnTop
        WinSetTitle, ahk_id %Gui1UniqueID%, , %CurrentTitle% - *AOT*
      }
  }

;##############################################################################
;#############   Actions of GUI 2 - Options   #################################
;##############################################################################

;#############   Build Gui 2 - Options   ######################################
BtnOptions:
  ;color palette for combobox of line colors in BBGGRR
  ColorPalette =
    (LTrim Join|
      000000 Black
      C0C0C0 Silver
      808080 Gray
      FFFFFF White
      000080 Maroon
      0000FF Red
      800080 Purple
      FF00FF Fuchsia
      008000 Green
      00FF00 Lime
      008080 Olive
      00FFFF Yellow
      800000 Navy
      FF0000 Blue
      808000 Teal
      FFFF00 Aqua
    )

  ;de-activate old hotkeys
  Hotkey, %ShortCutCaptureScreen%,    Off
  Hotkey, %ShortCutCaptureWindow%,    Off
  Hotkey, %ShortCutCaptureClientArea%,Off
  Hotkey, %ShortCutCaptureRegion%,    Off
  Hotkey, %ShortCutRedoCapture%,      Off

  ;Set no max/min icon, small border, and on top of Gui 1
  Gui, 2: +ToolWindow +Owner1
  Gui, 1: +Disabled

  Gui, 2:Add, Tab, xm w360 r7 Section, Misc|Lines|ShortCuts|Quality|Save|ShowHide
    Gui, 2:Tab, Misc
      Gui, 2:Add,Checkbox,xs+10 ys+30 vChkAutoNumber gApplyChkStatusGui2 Checked%ChkAutoNumber%,Use # in filename to number files`nautomatically. Start with number:
      Gui, 2:Add,Edit,x+5 ys+35 r1 Right Number w100 vEdtAutoNumber,
      Gui, 2:Add,UpDown, Range1-999999999999, %EdtAutoNumber%
      Gui, 2:Add,Checkbox, xs+10 ys+70 vChkHideMouse Checked%ChkHideMouse%, Hide mouse pointer
      Gui, 2:Add,Checkbox, xs+10 ys+90 vChkAllowRegionMove Checked%ChkAllowRegionMove%, Allow to move region with middle mouse button.`nRight mouse button will finish capturing.
      Gui, 2:Add,Checkbox, xs+10 ys+122 vOpenAsThumbs Checked%OpenAsThumbs%, "Open" button shows Irfanview thumbnails`n instead of explorer folder
    Gui, 2:Tab, Lines
      Gui, 2:Add,Text,xs+10 ys+30,Frame to capture region
      Gui, 2:Add,Text,xs+30 ys+50, Color:
      Gui, 2:Add,ComboBox,x+10 ys+46 w100 vCobFrameColor,%ColorPalette%
      Gui, 2:Add,Text,xs+180 ys+50, Thickness:
      Gui, 2:Add,Edit,xs+240 ys+46 w35 r1 Number Limit2 vEdtFrameThickness,
      Gui, 2:Add,UpDown, Range1-10, %EdtFrameThickness%
     
      Gui, 2:Add,Checkbox,xs+10 ys+75 vChkDrawGoldenCut gApplyChkStatusGui2 Checked%ChkDrawGoldenCut%,Draw lines for golden cut
      Gui, 2:Add,Text,xs+30 ys+95, Color:
      Gui, 2:Add,ComboBox,x+10 ys+91 w100 vCobGoldenCutColor,%ColorPalette%
      Gui, 2:Add,Text,xs+180 ys+95, Style:
      Gui, 2:Add,ComboBox,xs+240 ys+91 w90 vCobGoldenCutStyle,0 solid|1 dash|2 dot|3 dashdot|4 dashdotdot

      Gui, 2:Add,Checkbox,xs+10 ys+120 vChkDrawCrossLines gApplyChkStatusGui2 Checked%ChkDrawCrossLines%,Draw cross lines
      Gui, 2:Add,Text,xs+30 ys+140, Color:
      Gui, 2:Add,ComboBox,x+10 ys+136 w100 vCobCrossLinesColor,%ColorPalette%
      Gui, 2:Add,Text,xs+180 ys+140, Style:
      Gui, 2:Add,ComboBox,xs+240 ys+136 w90 vCobCrossLinesStyle,0 solid|1 dash|2 dot|3 dashdot|4 dashdotdot
    Gui, 2:Tab, ShortCuts
      Gui, 2:Add,Text,   xs+10  ys+30, ShortCut to capture screen
      Gui, 2:Add,Hotkey, xs+160 ys+26  w190 vShortCutCaptureScreen,%ShortCutCaptureScreen%
      Gui, 2:Add,Text,   xs+10  ys+55, ShortCut to capture window
      Gui, 2:Add,Hotkey, xs+160 ys+51  w190 vShortCutCaptureWindow,%ShortCutCaptureWindow%
      Gui, 2:Add,Text,   xs+10  ys+80,ShortCut to capture client area
      Gui, 2:Add,Hotkey, xs+160 ys+76  w190 vShortCutCaptureClientArea,%ShortCutCaptureClientArea%
      Gui, 2:Add,Text,   xs+10  ys+105,ShortCut to capture region
      Gui, 2:Add,Hotkey, xs+160 ys+101 w190 vShortCutCaptureRegion,%ShortCutCaptureRegion%
      Gui, 2:Add,Text,   xs+10  ys+130,ShortCut to redo capture
      Gui, 2:Add,Hotkey, xs+160 ys+126 w190 vShortCutRedoCapture,%ShortCutRedoCapture%
    Gui, 2:Tab, Quality
      Gui, 2:Add,Text,     xs+10 ys+30, Change color depth of image to BitsPerPixel
      Gui, 2:Add,ComboBox, xs+220 ys+26 w125 vCobColorDepth , No change|1 (2 colors)|4 (16 colors)|8 (256 colors)|24 (16777216 colors)
      Gui, 2:Add,Checkbox, xs+10 ys+55 vChkSwapBlackAndWhite Checked%ChkSwapBlackAndWhite%, Swap black and white color
      Gui, 2:Add,Checkbox, xs+10 ys+80 vChkGrayScale Checked%ChkGrayScale%, Convert image to grayscale
      Gui, 2:Add,Checkbox, xs+10 ys+105 vChkApplySharpen gApplyChkStatusGui2 Checked%ChkApplySharpen%, Apply sharpen filter, with value
      Gui, 2:Add,Edit, xs+180 ys+101 vEdtSharpen Right Number Limit3 w30, %EdtSharpen%
      Gui, 2:Add,Checkbox, xs+10 ys+130 vChkApplyContrast gApplyChkStatusGui2 Checked%ChkApplyContrast%, Apply contrast, with value
      Gui, 2:Add,Edit, xs+180 ys+126 vEdtContrast Right Number Limit3 w30, %EdtContrast%
    Gui, 2:Tab, Save
      Gui, 2:Add,Text, xs+10 ys+30, TIF save compression
      Gui, 2:Add,ComboBox, xs+120 ys+26 w90 vCobTifCompression, Default|0 = None|1 = LZW|2 = Packbits|3 = Fax3|4 = Fax4|5 = Huffman|6 = JPG|7 = ZIP

      Gui, 2:Add,Text, xs+10 ys+55 , JPG save quality
      Gui, 2:Add,Text, vTxt1SldJpgQ, Small`nSize
      Gui, 2:Add,Text, vTxt2SldJpgQ, High`nQuality
      Gui, 2:Add,Slider, xs+55 ys+75 Buddy1Txt1SldJpgQ Buddy2Txt2SldJpgQ AltSubmit vSldJpgQuality gSldJpgQuality, %EdtJpgQuality%
      Gui, 2:Add,Edit, xs+230 ys+75 vEdtJpgQuality gEdtJpgQuality Right Number Limit3 r1 w45,
      Gui, 2:Add,UpDown, Range1-100, %EdtJpgQuality%
      Gui, 2:Add,Checkbox, xs+10 ys+120 vCopytoClipboard Checked%CopytoClipboard%, Copy screenshot also to clipboard
    Gui, 2:Tab, ShowHide
      Gui, 2:Add,Checkbox,xs+10 ys+30 vHideGuiOnStart Checked%HideGuiOnStart%,Hide Gui on startup
      Gui, 2:Add,Checkbox, xs+10 ys+50 vHideGuiAfterCapture Checked%HideGuiAfterCapture%, Hide Gui after capture (only if preview is off)
      Gui, 2:Add,Checkbox, xs+10 ys+70 vShowGuiWithSingleCLick Checked%ShowGuiWithSingleCLick%, Single click on tray icon or right click on titlebar shows or hides Gui
  Gui, 2:Tab

  Gui, 2:Add,Button,xm Section gApplyOptions,Apply
  Gui, 2:Add,Button,ys gCancelOptions,Cancel

  ;select previous settings in comboboxes
  GuiControl, 2:ChooseString, CobFrameColor, %CobFrameColor%
  GuiControl, 2:ChooseString, CobGoldenCutColor, %CobGoldenCutColor%
  GuiControl, 2:ChooseString, CobGoldenCutStyle, %CobGoldenCutStyle%
  GuiControl, 2:ChooseString, CobCrossLinesColor, %CobCrossLinesColor%
  GuiControl, 2:ChooseString, CobCrossLinesStyle, %CobCrossLinesStyle%
  GuiControl, 2:ChooseString, CobColorDepth, %CobColorDepth%
  GuiControl, 2:ChooseString, CobTifCompression, %CobTifCompression%

  ;set controls to enable/disable, depending on checkbox status
  GoSub, ApplyChkStatusGui2

  ;get previous position and show Gui
  IniRead, Pos_Gui2, %StartCenterIni%, EasyCopy, Pos_Gui2, %A_Space%
  WinnameGui2 = %EasyCopyWindowtitle% - Options
  Gui, 2:Show, %Pos_Gui2%, %WinnameGui2%
return

;#############   JPGQ slider is moved   #######################################
SldJpgQuality:
  ;adjust edit field
  GuiControl, 2:, EdtJpgQuality, %SldJpgQuality%
return
 
;#############   JPGQ edit field gets chnaged   ###############################
EdtJpgQuality:
  ;get value
  GuiControlGet, EdtJpgQuality, 2:
  ;enforce limit 1 - 100 and set slider position
  If EdtJpgQuality > 100
    {
      GuiControl, 2:, EdtJpgQuality, 100
      GuiControl, 2:, SldJpgQuality, 100
    }
  Else If  EdtJpgQuality < 0
    {
      GuiControl, 2:, EdtJpgQuality, 0
      GuiControl, 2:, SldJpgQuality, 0
    }
  Else
      GuiControl, 2:, SldJpgQuality, %EdtJpgQuality%
return

;#############   Apply status to controls depending on checkbox   #############
ApplyChkStatusGui2:
  ;Get options
  GuiControlGet, ChkAutoNumber, 2:
  GuiControlGet, ChkDrawGoldenCut, 2:
  GuiControlGet, ChkDrawCrossLines, 2:
  GuiControlGet, ChkApplySharpen, 2:
  GuiControlGet, ChkApplyContrast, 2:

  GuiControl, 2:Enable%ChkAutoNumber%     , EdtAutoNumber
  GuiControl, 2:Enable%ChkDrawGoldenCut%  , CobGoldenCutColor
  GuiControl, 2:Enable%ChkDrawGoldenCut%  , CobGoldenCutStyle
  GuiControl, 2:Enable%ChkDrawCrossLines% , CobCrossLinesColor
  GuiControl, 2:Enable%ChkDrawCrossLines% , CobCrossLinesStyle
  GuiControl, 2:Enable%ChkApplySharpen%   , EdtSharpen
  GuiControl, 2:Enable%ChkApplyContrast%  , EdtContrast
return

;#############   Apply and save options   #####################################
ApplyOptions:
  ;Get options
  Gui, 2: Submit, NoHide

  If ShowGuiWithSingleCLick
     Menu, Tray, Click, 1
  Else
     Menu, Tray, Click, 2
   
  ;store options to ini
  IniWrite, %ChkAutoNumber%, %StartCenterIni%, EasyCopy, ChkAutoNumber
  IniWrite, %EdtAutoNumber%, %StartCenterIni%, EasyCopy, EdtAutoNumber
  IniWrite, %ChkHideMouse%, %StartCenterIni%, EasyCopy, ChkHideMouse
  IniWrite, %ChkAllowRegionMove%, %StartCenterIni%, EasyCopy, ChkAllowRegionMove
  IniWrite, %OpenAsThumbs%, %StartCenterIni%, EasyCopy, OpenAsThumbs

  IniWrite, %CobFrameColor%, %StartCenterIni%, EasyCopy, CobFrameColor
  IniWrite, %EdtFrameThickness%, %StartCenterIni%, EasyCopy, EdtFrameThickness
  IniWrite, %ChkDrawGoldenCut%, %StartCenterIni%, EasyCopy, ChkDrawGoldenCut
  IniWrite, %CobGoldenCutColor%, %StartCenterIni%, EasyCopy, CobGoldenCutColor
  IniWrite, %CobGoldenCutStyle%, %StartCenterIni%, EasyCopy, CobGoldenCutStyle
  IniWrite, %ChkDrawCrossLines%, %StartCenterIni%, EasyCopy, ChkDrawCrossLines
  IniWrite, %CobCrossLinesColor%, %StartCenterIni%, EasyCopy, CobCrossLinesColor
  IniWrite, %CobCrossLinesStyle%, %StartCenterIni%, EasyCopy, CobCrossLinesStyle

  IniWrite, %ShortCutCaptureScreen%,  %StartCenterIniFile%, EasyCopy, ShortCutCaptureScreen
  IniWrite, %ShortCutCaptureWindow%, %StartCenterIniFile%, EasyCopy, ShortCutCaptureWindow
  IniWrite, %ShortCutCaptureClientArea%, %StartCenterIniFile%, EasyCopy, ShortCutCaptureClientArea
  IniWrite, %ShortCutCaptureRegion%,    %StartCenterIniFile%, EasyCopy, ShortCutCaptureRegion
  IniWrite, %ShortCutRedoCapture%,   %StartCenterIniFile%, EasyCopy, ShortCutRedoCapture

  IniWrite, %CobColorDepth%, %StartCenterIni%, EasyCopy, CobColorDepth
  IniWrite, %ChkSwapBlackAndWhite%, %StartCenterIni%, EasyCopy, ChkSwapBlackAndWhite
  IniWrite, %ChkGrayScale%, %StartCenterIni%, EasyCopy, ChkGrayScale
  IniWrite, %ChkApplySharpen%, %StartCenterIni%, EasyCopy, ChkApplySharpen
  IniWrite, %EdtSharpen%, %StartCenterIni%, EasyCopy, EdtSharpen
  IniWrite, %ChkApplyContrast%, %StartCenterIni%, EasyCopy, ChkApplyContrast
  IniWrite, %EdtContrast%, %StartCenterIni%, EasyCopy, EdtContrast

  IniWrite, %CobTifCompression%, %StartCenterIni%, EasyCopy, CobTifCompression
  IniWrite, %EdtJpgQuality%, %StartCenterIni%, EasyCopy, EdtJpgQuality
  IniWrite, %CopytoClipboard%, %StartCenterIni%, EasyCopy, CopytoClipboard

  IniWrite, %HideGuiOnStart%, %StartCenterIni%, EasyCopy, HideGuiOnStart
  IniWrite, %HideGuiAfterCapture%, %StartCenterIni%, EasyCopy, HideGuiAfterCapture
  IniWrite, %ShowGuiWithSingleCLick%, %StartCenterIni%, EasyCopy, ShowGuiWithSingleCLick
  GoSub, CancelOptions
return

;#############   Close GUI 2 - Options   ######################################
2GuiEscape:
2GuiClose:
CancelOptions:
  ;activate hotkeys
  GoSub, ActivateHotKeys

  ;store current position and close gui
  WinGetPos, PosX, PosY, SizeW, SizeH, %WinnameGui2%
  IniWrite, x%PosX% y%PosY%, %StartCenterIni%, EasyCopy, Pos_Gui2
 
  ;close Options GUI
  Gui, 2: Destroy
 
  ;enable GUI 1 and bring it to front again
  Gui, 1: -Disabled
  Gui, 1: Show
return

;##############################################################################
;#############   Capture Screenshot   #########################################
;##############################################################################

;#############   Redo previous capture   ######################################
BtnRedoCapture:
  If RedoBuffer is not space
      If IsLabel(RedoBuffer)
          GoSub, %RedoBuffer%
Return

;#############   Capture full screen   ########################################
BtnCaptureScreen:
  ;memorize this as last action
  RedoBuffer = BtnCaptureScreen

  ;AreaID ( 0 = screen, 1 = Window, 2 = client area)
  AreaID = 0
 
  ;start capture process
  GoSub, StartAreaCaptureProcess
Return

;#############   Capture active window   ######################################
BtnCaptureWindow:
  RedoBuffer = BtnCaptureWindow
  AreaID = 1
  GoSub, StartAreaCaptureProcess
Return

;#############   Capture client area of window   ##############################
BtnCaptureClientArea:
  RedoBuffer = BtnCaptureClientArea
  AreaID = 2
  GoSub, StartAreaCaptureProcess
Return

;#############   Start Capture Process   ######################################
StartAreaCaptureProcess:
  ;get data from GUI
  Gui, 1:Submit, NoHide

  If not GetFileName(ChkShowPreview, ChkAutoNumber)
    Return

  ;hide GUI if file name is found
  Gui, 1:Hide

  ;activate escape sequence
  HotKey, $Esc, EscapeScreenShot, On
  EscapeSequence := True
 
  ;wait for window selection if AreaID >= 1 
  If AreaID
    {
      ;wait for window to be selected
      KeyWait, LButton, D
     
      ;wait for Lbutton to be release (otherwise window will be moved, when mouse gets hidden)
      KeyWait, LButton
    }

  ;capture options for area
  CaptureOptions = /capture=%AreaID%
 
  ;do screenshot capture if escape sequence hasn't be activated yet
  If EscapeSequence
      GoSub, CaptureScreenShot

  ;turn off hotkey for escape sequence if it hasn't been yet
  HotKey, $Esc, Off
Return

;#############   ESC hotkey to aboard screenshots   ###########################
EscapeScreenShot:
  ;turn off hotkey
  HotKey, $Esc, Off

  ;set escape sequence
  EscapeSequence := False

  ;show Gui again
  Gui, 1:Show, AutoSize
Return

;#############   Capture screenshot   #########################################
CaptureScreenShot:
  ;if hide mouse is wanted memorize current position and move it to lower right corner
  If ChkHideMouse
    {
      MouseGetPos, MhideX, MhideY
      MouseMove, %ScreenWidth%, %ScreenHeight% , 0
    }
   
  ;add rest of options for screenshot
  GoSub, AddCaptureOptions

  RunWait,
    (LTrim Join`s
      %ExeCapture%
      %CaptureOptions%
      /convert="%FileNameForImage%"
    )

  ;if mouse was hidden, move it back again
  If ChkHideMouse
      MouseMove, %MhideX%, %MhideY% , 0

  ;show preview or give feedback
  If ChkShowPreview
    {
      ;add preview to GUI
      GuiControl, 1:, PicPreview, %FileNameForImage%

      ;adjust size of Picture to fit initial GuiWidth
      GuiControlGet, PicPreview, 1:Pos
      GuiControl, 1:Move, PicPreview, % "w" Gui1Width "h" PicPreviewH*Gui1Width/PicPreviewW ;%

      ;enable Buttons and memorize filename
      GuiControl, 1:Enable , BtnSave
      GuiControl, 1:Enable , BtnPrint
      PreViewFileName = %FileNameForImage%
    }
  Else ;no preview wanted
    {
      ;give feedback
      LastSavedFile = %FileNameForImage%
      GuiControl, 1:Enable , BtnEdit
      ToolTip, ScreenShot saved as`n%FileNameForImage%
      SetTimer, RemoveToolTip, 2000

      ;empty vars, controls and disable buttons
      PreViewFileName =
      FileNameForImage =
      GuiControl, 1: , PicPreview,
      GuiControl, 1:Disable , BtnSave
      GuiControl, 1:Disable , BtnPrint
    }

  ;show Gui if wanted, autosize to fit preview (added, new or delted)
  If ( HideGuiAfterCapture = 0 Or ChkShowPreview = 1)
      Gui, 1:Show, AutoSize
Return

;#############   Add options for screenshot   #################################
AddCaptureOptions:
  If ( CobColorDepth <> "No change" )
    {
      StringSplit, Value, CobColorDepth, %A_Space%
      CaptureOptions = %CaptureOptions% /bpp=%Value1%
    }
  If ChkSwapBlackAndWhite
      CaptureOptions = %CaptureOptions% /swap_bw
  If ChkGrayScale
      CaptureOptions = %CaptureOptions% /gray
  If ChkApplySharpen
      CaptureOptions = %CaptureOptions% /sharpen=%EdtSharpen%
  If ChkApplyContrast
      CaptureOptions = %CaptureOptions% /contrast=%EdtContrast%
  If ( CobTifCompression <> "Default" AND OutExtension = "tif" )
    {
      StringSplit, Value, CobTifCompression, %A_Space%
      CaptureOptions = %CaptureOptions% /tifc=%Value1%
    }
  If ( OutExtension = "jpg" )
      CaptureOptions = %CaptureOptions% /jpgq=%EdtJpgQuality%
  If CopyToClipboard
      CaptureOptions = %CaptureOptions% /clipcopy
Return

;#############   Get File Name for image  #####################################
GetFileName(ChkShowPreview, ChkAutoNumber)
{ 
  global EdtFileName, EdtPath, EdtAutoNumber
         , FileNameForImage, PreViewFileName
         , TempFileName, OutExtension
 
  ;return if no filename is given
  If EdtFileName is space
    {
      MsgBox, 48, Problem , No filename is given.
      Return 0
    }

  ;get extension of file to be saved
  SplitPath, EdtFileName, , , OutExtension

  ;if preview is wanted
  If ChkShowPreview
    {
      ;remove previous preview file
      FileDelete, %PreViewFileName%
     
      ;If no extention is found, use JPG
      If OutExtension is space
          OutExtension = jpg
     
      ;specify temp file for preview
      FileNameForImage = %TempFileName%.%OutExtension%
    }
  ; no preview wanted - get file name for image
  Else If ChkAutoNumber
    {
      FileNameForImage := GetAvailableFileName(EdtFileName, EdtPath, EdtAutoNumber)
      If (FileNameForImage = 0 )
        {
          MsgBox, 48, Problem to find file name for screenshot,%ErrorLevel%`nNo screenshot taken or saved.
          Return 0
        }
    }
  Else If EdtPath is not space
    {
      StringRight, LastChar, EdtPath, 1
      If ( LastChar <> "\" )
        EdtPath = %EdtPath%\
      If ( InStr(FileExist(EdtPath), "D") = 0 )
        {
          MsgBox, 48, Problem, The given path >%EdtPath%< doesn't exist.
          Return 0
        }
      FileNameForImage := EdtPath . EdtFileName 
    }
  Else
      FileNameForImage := EdtFileName
  Return 1
}

;#############   Get next free/available File Name   ##########################
GetAvailableFileName( GivenFileName, GivenPath = "", StartID = 1 )
{
  ;check if GivenPath exist and add "\" if necessary
  If GivenPath is not space
    {
      StringRight, LastChar, GivenPath, 1
      If ( LastChar <> "\" )
        GivenPath = %GivenPath%\
      If ( InStr(FileExist(GivenPath), "D") = 0 )
        {
          ErrorLevel = The given path >%GivenPath%< doesn't exist.
          Return 0
        }
    }

  ;check if StartID is reasonable
  If ( StartID < 0 Or Mod(StartID, 1) <> 0 )
    {
      ErrorLevel =
        (LTrim
           The StartID >%StartID%< is smaller then zero or not an integer.
           It has to be a positive integer.
        )
      Return 0
    }

  ;split GivenFileName with #
  StringSplit, NameArray, GivenFileName, #
 
  ;if GivenFileName doesn't contain # ...
  If NameArray0 < 2
    {
      ;check if GivenFileName exists
      If FileExist(GivenPath . GivenFileName)
        {
          ErrorLevel =
            (LTrim
              The given file >%GivenFileName%< does exist
              in path >%GivenPath%<.
              (if path is empty, it's the path of the script/exe)
            )
          Return 0
        }
      Else
          Return GivenPath . GivenFileName
    }

  ;check if StartID isn't too large
  If ( StrLen(StartID) > NameArray0 - 1 )
    {
      ErrorLevel =
        (LTrim
           The StartID >%StartID%< is too large
           for the filename >%GivenFileName%<.
        )
      Return 0
    }
 
  ;Search from StartID ...
  Loop
    {
      Number := A_Index + StartID - 1
             
      ;untill number is too large ...
      If ( StrLen(Number) > NameArray0 - 1 )
        {
          ErrorLevel =
            (LTrim
              All files exist for >%GivenFileName%<
              with all # between %StartID% and %Number%.
            )
          Return 0
        }

      ;otherwise fill number with leading zeros
      Loop, % NameArray0 - 1 - StrLen(Number) ;%
          Number = 0%Number%
     
      ;split number in an array
      StringSplit, NumberArray, Number
     
      ;mix and concatenate the names array with the numbers array
      FileName =
      Loop, %NameArray0%
          FileName := FileName . NameArray%A_Index% . NumberArray%A_Index%
     
      ;check if GivenFileName doesn't exist
      If not FileExist(GivenPath . FileName)
          Return GivenPath . FileName
     }
}

;##############################################################################
;#############   Save or Print Previews   Edit last saved file    #############
;##############################################################################

;#############   Save preview   ###############################################
BtnSave:
  ;get path and filename
  Gui, 1:Submit, NoHide

  ;check if preview file still exists
  If FileExist(PreViewFileName)
    {
      If GetFileName(0, ChkAutoNumber)
        {
          ;copy preview image to destination image with overwrite
          FileCopy, %PreViewFileName%, %FileNameForImage% , 1
          LastSavedFile= %FileNameForImage%
          GuiControl, 1:Enable , BtnEdit
          ;give feedback
          ToolTip, ScreenShot saved as`n%FileNameForImage%
        }
    }
  Else  ;preview file doesn't exist
    GoSub, NoPreviewFileFound
     
  ;remove Feedback after 2 sec
  SetTimer, RemoveToolTip, 2000
Return

NoPreviewFileFound:
      ;give feedback
      ToolTip, File of ScreenShot PreView doesn't exist`n%PreViewFileName%
     
      ;empty vars, controls and disable buttons
      PreViewFileName =
      FileNameForImage =
      GuiControl, 1: , PicPreview,
      GuiControl, 1:Disable , BtnSave
      GuiControl, 1:Disable , BtnPrint
     
      ;autosize Gui to fit removed preview
      Gui, 1:Show, AutoSize
Return

;#############   Print preview   ###############################################
BtnPrint:
  ;check if preview file still exists
  If FileExist(PreViewFileName)
    {
      ;print preview image on default printer
      RunWait,
        (Join`s
          %ExeCapture%
          %PreViewFileName%
          /print
        )
      ;give feedback
      ToolTip, ScreenShot printed on default Printer
    }
  Else  ;preview file doesn't exist
    GoSub, NoPreviewFileFound

  ;remove Feedback after 2 sec
  SetTimer, RemoveToolTip, 2000
Return

;#############   Edit last saved file   #######################################
BtnEdit:
  Run, %ExeCapture% %LastSavedFile%
Return

;#############   Remove Feedback from Screen   ################################
RemoveToolTip:
  SetTimer, RemoveToolTip, Off
  ToolTip
Return

;##############################################################################
;#############   Capture Region   #############################################
;##############################################################################

;#############   Prepare region screenshot   ##################################
BtnCaptureRegion:
  ;get data from GUI
  Gui, 1:Submit, NoHide

  If not GetFileName(ChkShowPreview, ChkAutoNumber)
    Return

  ;hide GUI
  Gui, 1:Hide

  ;get colors for frame and lines and combine them to 0x00BBGGRR
  StringSplit, Value, CobFrameColor, %A_Space%
  frame_c  = 0x00%Value1%
  StringSplit, Value, CobGoldenCutColor, %A_Space%
  lineGC_c = 0x00%Value1%
  StringSplit, Value, CobCrossLinesColor, %A_Space%
  line_c   = 0x00%Value1%

  ;get line styles
  StringSplit, Value, CobGoldenCutStyle, %A_Space%
  lineGC_s = %Value1%
  StringSplit, Value, CobCrossLinesStyle, %A_Space%
  line_s   = %Value1%
 
  ;specify line thicknesses and thresholds
  lineGC_t = 1
  line_t   = 1
  ThresholdCrossLine = 50
  ThresholdGoldenCutLine = 100
 
  ;activate hotkeys (set to ON to ensure multiple uses)
  HotKey, $Lbutton, DrawRegionFrame, On
  HotKey, $Esc,     CleanUpRegionFrame, On
Return

;#############   Draw frame when mouse is draged   ############################
;When user clicks with Left-Mouse Button and drags, a frame is drawn on screen
DrawRegionFrame:
  ;set fast execution
  SetBatchLines, -1

  ;get starting position from mouse
  MouseGetPos, MX, MY
     
  ;create transparent GUI covering the whole screen
  Gui, 3:Color, Black
  Gui, 3:+Lastfound +AlwaysOnTop
  WinSet, TransColor, Black
  Gui, 3:-Caption
  Gui, 3:Show, x0 y0 w%ScreenWidth% h%ScreenHeight%

  ;retrieve the unique ID number (HWND/handle) of that window
  WinGet, hw_frame, id

  ;more information on the use functions in MSDN
  ; http://msdn.microsoft.com/library/default.asp
 
  ;Get handle to display device context (DC) for the client area of a specified window
  hdc_frame := DllCall( "GetDC"
                      , "uint", hw_frame )
                     
  ;create buffer to store old color data to remove drawn rectangles
  hdc_buffer := DllCall( "gdi32.dll\CreateCompatibleDC"
                       , "uint", hdc_frame )
 
  ;Create Bitmap buffer to remove drawn rectangles
  hbm_buffer := DllCall( "gdi32.dll\CreateCompatibleBitmap"
                       , "uint", hdc_frame
                       , "int", ScreenWidth
                       , "int", ScreenHeight )
 
  ;Select Bitmap buffer in buffer to remove drawn rectangles
  DllCall( "gdi32.dll\SelectObject"
         , "uint", hdc_buffer
         , "uint", hbm_buffer )

  ;create a dummy rectangular region.
  h_region := DllCall( "gdi32.dll\CreateRectRgn"
                     , "int", 0
                     , "int", 0
                     , "int", 0
                     , "int", 0 )

  ;specify the color of the frame.
  h_brush := DllCall( "gdi32.dll\CreateSolidBrush"
                    , "uint", frame_c )

  ;specify the style, thickness and color of the cross lines
  h_pen := DllCall( "gdi32.dll\CreatePen"
                   , "int", line_s
                   , "int", line_t
                   , "uint", line_c)

  ;specify the style, thickness and color of the golden cut lines
  h_penGC := DllCall( "gdi32.dll\CreatePen"
                     , "int", lineGC_s
                     , "int", lineGC_t
                     , "uint", lineGC_c)

  ;check continously if the mouse is draged while LButton is down and redraw frame.
  Loop
    {
      ;redraw frame when LButton is still down
      If GetKeyState("LButton", "P")
        {
          ;get current mouse position
          MouseGetPos, MXend, MYend
         
          ;redraw only if mouse moved to a different position
          If ( MXend <> MXend_old
               AND MYend <> MYend_old)
            {
              ;compute width and height of frame
              w := abs(MX - MXend)
              h := abs(MY - MYend)
             
              ;find upper left corner
              X := Min( MX, MXend )
              Y := Min( MY, MYend )
           
              ;remove old rectangle form screen and save/buffer screen below new rectangle
              BufferAndRestoreRegion( X, Y, w, h )
             
              ;draw rectangle frame
              DrawFrame( X, Y, w, h, EdtFrameThickness )
             
              ;if rectangle is large enough draw cross lines
              If ( w > ThresholdCrossLine AND h > ThresholdCrossLine AND ChkDrawCrossLines )
                  DrawCross( X, Y, w, h )
             
              ;if rectangle large enough draw golden cut lines
              If ( w > ThresholdGoldenCutLine AND h > ThresholdGoldenCutLine AND ChkDrawGoldenCut )
                  DrawGoldenCut( X, Y, w, h )
             
              ;memorize position
              MXend_old = %MXend%
              MYend_old = %MYend%
             
              ;sleep to increase performance
              Sleep, 50
            }
         }       
      Else   ;LButton is released
          Break
    }
  ;if wanted activate new hotkeys to allow moving of frame
  If ChkAllowRegionMove
    {
      ;Middle mouse button to move frame
      HotKey, $Mbutton, MoveRegionFrame, On

      ;Right mouse button to take region screenshot
      HotKey, $Rbutton, CaptureRegion, On
    }
  Else ; moving of frame not wanted
    {
      ;take region screenshot
      GoSub, CaptureRegion
    }
Return

;#############   Capture region screenshot   ##################################
CaptureRegion:
  ;hide GUI, if it hasn't been done before (e.g. with redo)
  Gui, 1:Submit

  ;get File Name (has to be redone due to redo)
  If not GetFileName(ChkShowPreview, ChkAutoNumber)
    Return

  ;remove buffer, handles, and GUI from memory, disable hotkeys
  GoSub, CleanUpRegionFrame
 
  ;capture options for region
  CaptureOptions = /capture=0 /crop=(%X%,%Y%,%w%,%h%)
 
  ;do screenshot capture
  GoSub, CaptureScreenShot

  ;memorize this as last action, so that the exact same rectangle is taken with redo
  RedoBuffer = CaptureRegion
Return

;#############   Return lower value of two values   ###########################
Min( value1, value2 )
  {
    If ( value1 < value2 )
        return value1
    Else
        return value2
  }

;#############   Move frame with mouse drag   #################################
; When user clicks with Middle-Mouse Button and drags, the frame is moved on the screen
MoveRegionFrame:
  ;set fast execution
  SetBatchLines, -1

  ;get starting position from mouse
  MouseGetPos, MX, MY
 
  ;memorize initial frame position
  InitialX = %X%
  InitialY = %Y%

  ;check continously if the mouse is draged while MButton is down and redraw frame.
  Loop
    {
      ;redraw frame when MButton is still down
      If GetKeyState("MButton", "P")
        {
          ;get current mouse position
          MouseGetPos, MXend, MYend
         
          ;redraw only if mouse moved to a different position
          If ( MXend <> MXend_old
               AND MYend <> MYend_old)
            {
              ;find upper left corner
              X := InitialX + MXend - MX
              Y := InitialY + MYend - MY
           
              ;remove old rectangle and save screen below new rectangle
              BufferAndRestoreRegion( X, Y, w, h )
             
              ;draw rectangle frame
              DrawFrame( X, Y, w, h, EdtFrameThickness )
             
              ;if rectangle large enough draw cross lines
              If ( w > ThresholdCrossLine AND h > ThresholdCrossLine AND ChkDrawCrossLines )
                  DrawCross( X, Y, w, h )
             
              ;if rectangle large enough draw golden cut lines
              If ( w > ThresholdGoldenCutLine AND h > ThresholdGoldenCutLine AND ChkDrawGoldenCut )
                  DrawGoldenCut( X, Y, w, h )
             
              ;memorize position
              MXend_old = %MXend%
              MYend_old = %MYend%
             
              ;sleep to increase performance
              Sleep, 50
            }
         }       
      Else   ;MButton is released
          Break
    }
Return

;#############   Remove handles and buffers from memory   #####################
;#############   Remove GUI from memory and disable hotkeys   #################
CleanUpRegionFrame:
  DeleteObject( h_brush )
  DeleteObject( h_pen )
  DeleteObject( h_region )
  DeleteObject( hbm_buffer )
   
  DeleteDC( hdc_frame )
  DeleteDC( hdc_buffer )

  Gui, 3:Destroy

  ;turn off hotkeys
  HotKey, $Lbutton, Off
  HotKey, $Esc,     Off
  If ChkAllowRegionMove
    {
      HotKey, $Mbutton, Off
      HotKey, $Rbutton, Off
    }

  ;if action is canceled show GUi again
  If ( A_ThisHotkey = "$ESC" )
      Gui, 1:Show, AutoSize
Return

DeleteObject( p_object )
  {
    ;deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources
    DllCall( "gdi32.dll\DeleteObject", "uint", p_object )
  }

DeleteDC( p_dc )
  {
    ;deletes the specified device context (DC).
    DllCall( "gdi32.dll\DeleteDC", "uint", p_dc )
  }

;#############   remove old rectangle and save screen below new rectangle   ###
BufferAndRestoreRegion( p_x, p_y, p_w, p_h )
  {
    global   hdc_frame, hdc_buffer
    static   buffer_state, old_x, old_y, old_w, old_h
     
    ;Copies the source rectangle directly to the destination rectangle.
    SRCCOPY   = 0x00CC0020
       
    ;remove previously drawn rectangle (restore previoulsy buffered color data)
    if ( buffer_state = "full")
       ;perform transfer of color data of rectangle from source DC into destination DC
       ; from buffer to screen, erasing the previously darwn reactangle
       DllCall( "gdi32.dll\BitBlt"
              , "uint", hdc_frame
              , "int", old_x
              , "int", old_y
              , "int", old_w
              , "int", old_h
              , "uint", hdc_buffer
              , "int", 0
              , "int", 0
              , "uint", SRCCOPY )
    else
       buffer_state = full
 
    ;remember new rectangle for next loop (to be removed)
    old_x := p_x
    old_y := p_y
    old_w := p_w
    old_h := p_h
 
    ; Store current color data of new ractangle in buffer
    DllCall( "gdi32.dll\BitBlt"
           , "uint", hdc_buffer
           , "int", 0
           , "int", 0
           , "int", p_w
           , "int", p_h
           , "uint", hdc_frame
           , "int", p_x
           , "int", p_y
           , "uint", SRCCOPY )
  }
 
;#############   draw frame   #################################################
DrawFrame( p_x, p_y, p_w, p_h, p_t )
  {
    global   hdc_frame, h_region, h_brush
     
    ; modify dummy rectangular region to desired reactangle
    DllCall( "gdi32.dll\SetRectRgn"
           , "uint", h_region
           , "int", p_x
           , "int", p_y
           , "int", p_x+p_w
           , "int", p_y+p_h )
   
    ; draw region frame with thickness (width and hight are the same)
    DllCall( "gdi32.dll\FrameRgn"
           , "uint", hdc_frame
           , "uint", h_region
           , "uint", h_brush
           , "int", p_t
           , "int", p_t )
  }

;#############   draw cross lines   ###########################################
DrawCross( p_x, p_y, p_w, p_h )
  {
    global   hdc_frame, h_pen
         
    ;margin to the inside of the region to start drawing the lines
    LineMargin = 10

    ;select the correct pen into DC
    DllCall( "gdi32.dll\SelectObject"
           , "uint", hdc_frame
           , "uint", h_pen )
               
    ;update the current position to specified point
    DllCall( "gdi32.dll\MoveToEx"
           , "uint", hdc_frame
           , "int", p_x+LineMargin
           , "int", p_y+LineMargin
           , "uint", 0)
   
    ;draw a line from the current position up to, but not including, the specified point.
    DllCall( "gdi32.dll\LineTo"
           , "uint", hdc_frame
           , "int", p_x+p_w-LineMargin
           , "int", p_y+p_h-LineMargin)
   
    DllCall( "gdi32.dll\MoveToEx"
           , "uint", hdc_frame
           , "int", p_x+p_w-LineMargin
           , "int", p_y+LineMargin
           , "uint", 0)

    DllCall( "gdi32.dll\LineTo"
           , "uint", hdc_frame
           , "int", p_x+LineMargin
           , "int", p_y+p_h-LineMargin)
  }

;#############   draw golden cut lines   ######################################
DrawGoldenCut( p_x, p_y, p_w, p_h )
  {
    global   hdc_frame, h_penGC
         
    ;margin to the inside of the region to start drawing the lines
    LineMargin = 10

    ;select the correct pen into DC
    DllCall( "gdi32.dll\SelectObject"
           , "uint", hdc_frame
           , "uint", h_penGC )

    ;update the current position to specified point
    DllCall( "gdi32.dll\MoveToEx"
           , "uint", hdc_frame
           , "int", p_x+p_w/3
           , "int", p_y+LineMargin
           , "uint", 0)
   
    ;draw a line from the current position up to, but not including, the specified point.
    DllCall( "gdi32.dll\LineTo"
           , "uint", hdc_frame
           , "int", p_x+p_w/3
           , "int", p_y+p_h-LineMargin)
   
    DllCall( "gdi32.dll\MoveToEx"
           , "uint", hdc_frame
           , "int", p_x+2*p_w/3
           , "int", p_y+LineMargin
           , "uint", 0)

    DllCall( "gdi32.dll\LineTo"
           , "uint", hdc_frame
           , "int", p_x+2*p_w/3
           , "int", p_y+p_h-LineMargin)
   
    DllCall( "gdi32.dll\MoveToEx"
           , "uint", hdc_frame
           , "int", p_x+LineMargin
           , "int", p_y+p_h/3
           , "uint", 0)

    DllCall( "gdi32.dll\LineTo"
           , "uint", hdc_frame
           , "int", p_x+p_w-LineMargin
           , "int", p_y+p_h/3)
   
    DllCall( "gdi32.dll\MoveToEx"
           , "uint", hdc_frame
           , "int", p_x+LineMargin
           , "int", p_y+2*p_h/3
           , "uint", 0)

    DllCall( "gdi32.dll\LineTo"
           , "uint", hdc_frame
           , "int", p_x+p_w-LineMargin
           , "int", p_y+2*p_h/3)
  }

;##############################################################################
;#############   End of File   ################################################
;############################################################################## 