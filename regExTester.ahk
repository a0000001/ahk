#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

;http://www.autohotkey.com/forum/viewtopic.php?p=392140#392140

; dR's Simple RegEx Tester v 0.1.5
AutoExecute:

  Gosub, SetDemoText
  Gui,Margin,0,0
  Gui,Font,s10,Lucida Console
  Gui,Add,Edit,x10 y10 vNeedle w450 hwndRex gEval +AltSubmit,% "\b([rR]\w+[nrst])\b"
  Gui,Font
  Gui,Add,CheckBox,yp+5 x+10 w100 vMatchAll Checked gEval, MatchAll ?
  Gui,Add,StatusBar
  Gui Show, +Hide w570 h480, dR's Simple RegExTester v0.1.5
  Gui, 1:+LastFound +Resize
  DllCall("SendMessage", "UInt", REdit1 := DllCall("CreateWindowEx" ,Uint, 0x200, str,  re:="RichEdit20A", str, re
      , Uint, 0x54B371C4,int, 10, int, 40, int, 550, int, 420, Uint, WinExist(),Uint, 0, Uint, hInstance := DllCall("LoadLibrary"
      , Str, "riched20.dll"), Uint, 0), "UInt", 0x435, "UInt", "0", "UInt", "2147483647"), DllCall("SendMessage", "UInt"
      , res, "UInt", 0x461, "Str", "", "Str", "")
  DllCall("user32.dll\SendMessage", "UInt", REdit1, "UInt", 0x461, "Str", "", "Str", DemoText)
  Gui Show

  VarSetCapacity(SETTEXTEX,8,0), numput(SETTEXTEX,1,0,"Uint")
 
~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload
 
Eval:
  GuiControlGet,Needle
  GuiControlGet,MatchAll
  ; Get Haystack
  VarSetCapacity(t1, 8, 0), t2 := 1252, VarSetCapacity(t3, 20, 0), NumPut(0, t1, 0), NumPut(t2, t1, 4)
  If (ts := DllCall("user32.dll\SendMessage", "UInt", REdit1, "UInt", 0x45F, "UInt", &t1, "UInt", "0")) {
    ts+=1,NumPut(ts, t3, 0, "Int"), NumPut(t2, t3, 8, "Int"), VarSetCapacity(Haystack, ts + 1, 0)
    DllCall("user32.dll\SendMessage", "UInt", REdit1, "UInt", 0x45E, "UInt", &t3, "UInt", &Haystack)
    VarSetCapacity(Haystack, -1)
  }
  if ( StrLen( Needle ) ) {
    test := RegExMatch( HayStack, Needle, Match ), RegExErrorLevel := ErrorLevel, p := 0
    SB_SetText( RegExErrorLevel != 0 ? "RegEx ErrorLevel: " RegExErrorLevel : "RegEx OK." )
   
    if ( test && MatchAll == 1 )
      while( p := RegExMatch( HayStack, Needle, Match, p == 0 ? 1 : p + StrLen(Match)+9 ) )
        HayStack := RegExReplace(HayStack, "\Q" match "\E", "\b\cf2" match "\cf1\b0 " , o, 1, p)
    else if ( test && MatchAll == 0 )
        RegExMatch( HayStack, Needle, Match, 1 ), HayStack := RegExReplace(HayStack, "\Q" match "\E"
        , "\b\cf2" match "\cf1\b0 " , o, 1 )
  }
  DllCall("SendMessage", "UInt", REdit1, "UInt", EM_SETTEXTEX := 0x461, "UInt", &SETTEXTEX, "str"
  , "{\rtf1\ansi\ansicpg29779\deff0\deflang1033\deflangfe1033{\fonttbl{\f0\fswiss\fprq2\fcharset0 Arial;}}"
   . "{\colortbl `;\red0\green0\blue0;\red255\green128\blue0;}"
   . "\viewkind4\uc1\pard\nowidctlpar\cf1\cb4\f0\fs20"
   .  RegExReplace( HayStack, "\r\n?", "\par`n" ) "\b0\f0\par}")
  Gui Show
Return

SetDemoText:
  DemoText=
  (LTrim Join`n
    Welcome to simple RegExTester 0.1.5. It's intended to be a very simple tool,
    yet powerfull enough to easily visualize your RegExNeedles on your custom
    texts. To do this, simple paste in your text in the big box and enter your
    Regular Expression Needle above. You will see your results instantly.
    `nFeatures of this tool:
    `n`t- real time updates of the result as you type
    `t- full regex syntax as it's available to AutoHotkey
    `t- simple yet powerfull in its usage`n
    This tool uses a stripped version of corrupt's libraries for RichEdit Controls.
    The full libraries may and advanced usage samples may be found here:
    `thttp://www.autohotkey.com/forum/viewtopic.php?p=123286#123286
    `nAt present day it only uses the RichtEdit v2 Control, thus it cannot be run on
    systems lacking it, such as Windows 95.`n`nHave fun!`ndR`n
  )
return

GuiSize:
  ; FixMe
  ControlMove,,10,70,% A_GuiWidth-20, A_GuiHeight-70, ahk_id %REdit1%
  GuiControl, Move, Needle, % "x10 y10 w" A_GuiWidth-120
  GuiControl, Move, MatchAll, % "x" A_GuiWidth-100
Return

GuiClose:
GuiEscape:
  DllCall("DestroyWindow", "UInt", REdit1)
  DllCall("FreeLibrary", "UInt", hInstance)
ExitApp