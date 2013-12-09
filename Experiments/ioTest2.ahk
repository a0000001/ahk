MODIFIED=20110813
Filename1=DosConsole_20110813
;-- works tested XP ---------
;-- use DropDownList & Enter


#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, off
AutoTrim, on

transform,u ,chr,129  ;ue
transform,u2,chr,154  ;Ue
transform,a ,chr,132  ;ae
transform,a2,chr,142  ;Ae
transform,o ,chr,148  ;oe
transform,o2,chr,153  ;Oe
transform,s ,chr,225  ;ss
transform,sp,chr,32   ;space

F11=test55.txt
ifexist,%f11%
   filedelete,%f11%

gosub,e4xx


gui,3: +resize
Gui,3:Font,,FixedSys
;Gui,3:Add,Text,cgreen  x10    y10     h20   w105               ,DOS-Command

cmd1=ver
Gui,3:Add,Edit,cRed     x10   y5      h20   w450  vCommandline ,%cmd1%
Gui,3:Add,Edit,cRed     x465  y5      h20   w400  vSelectedPath ,

Gui,3:Add,DropDownList,x450   y30     h600  w250  vInput gRefresh +Choose1 , %e4x%

Gui,3:Add,Edit,cBlack   x10   y70 -wrap  readonly vEditcontrol1 multi  ,

Gui,3:add,button, x10  y30 h20 w100  gSave1  vSave2, Save-Text
Gui,3:add,button, x120 y30 h20 w100  gTest11 , Test
Gui,3:add,button, x300 y30 h20 w100  gFileselect1 ,FileSelect

Gui,3:add,button, hidden default gRunDos,ok

Gui,3:Show,            x50   y2    h890  w720 ,%filename1%
;GuiControl,3:,Commandline,date /t
Guicontrol,3:focus,Commandline
GuiControl,3: Disable,Save2
return



3Guiclose:
3GuiEscape:
exitapp



test11:
FileDelete, tmpbatch.cmd
FileAppend,
(
ver
dir
date /t
time /t
), tmpbatch.cmd
;RunWait %comspec% /k tmpbatch.cmd
;FileDelete, tmpbatch.cmd
RunWait, %comspec% /c tmpbatch.cmd %selectedpath% >%f11%,,UseErrorLevel Hide
aa=
FileRead,aa, %f11%
if aa=
   aa=Wrong DOS-Command or [No text found]

;-- replace german Umlaut -----
stringreplace,aa,aa,%o% ,oe,all
stringreplace,aa,aa,%o2%,Oe,all
stringreplace,aa,aa,%a% ,ae,all
stringreplace,aa,aa,%a2%,Ae,all
stringreplace,aa,aa,%u% ,ue,all
stringreplace,aa,aa,`%,Ue,all
stringreplace,aa,aa,%s% ,ss,all

GuiControl,3:,Editcontrol1,%aa%`r`n
;GuiControl,3:,Commandline,%x2%
Guicontrol,3:focus,Commandline
GuiControl,3: Enable,Save2
return




refresh:
gui,3:submit,nohide
GuiControl,3:,Selectedpath,
x1=
x2=
x3=
stringsplit,x,input,%sp%
commandline=%x2%%sp%%x3%
GuiControl,3:,Commandline,%commandline%
gosub,rundos
return



Fileselect1:
   FileSelectFile,File,,::{20d04fe0-3aea-1069-a2d8-08002b30309d},, (*.txt)
   if file=
      return
GuiControl,3:,Selectedpath,"%file%"
return




RunDos:
gui,3:submit,nohide
Rundos1:
GuiControl,3: Disable,Save2
ifexist,%f11%
   filedelete,%f11%
;msgbox,%commandline%
;return
RunWait, %comspec% /c %CommandLine% %selectedpath% >%f11%,,UseErrorLevel Hide
aa=
FileRead,aa, %f11%
if aa=
   aa=Wrong DOS-Command or [No text found]

;-- replace german Umlaut -----
stringreplace,aa,aa,%o% ,oe,all
stringreplace,aa,aa,%o2%,Oe,all
stringreplace,aa,aa,%a% ,ae,all
stringreplace,aa,aa,%a2%,Ae,all
stringreplace,aa,aa,%u% ,ue,all
stringreplace,aa,aa,`%,Ue,all
stringreplace,aa,aa,%s% ,ss,all

GuiControl,3:,Editcontrol1,%aa%`r`n
;GuiControl,3:,Commandline,%x2%
Guicontrol,3:focus,Commandline
GuiControl,3: Enable,Save2
return



Save1:
FileSelectFile, FileName,S 16,%a_Desktop%, Select location to Save - Saves as xy.txt , *.txt
if errorlevel
	return
FileAppend, %aa%, %FileName%.txt
return

3GuiSize:
guicontrol,3: move, Editcontrol1, % "w" A_GUIWidth-20 "h" A_GUIHeight-30
return




 ;-- ctrl+alt+d = DOSCOMMANDHERE:  ---------------
 ^!d::
 ID := WinExist("A")
 WinGetClass, Class, ahk_id %ID%
 ControlGetText,ePath, Edit1, ahk_id %ID%
 if epath=
    epath=%A_desktop%
 ;msgbox,%epath%
 Run, %comspec%, %epath%
return


e4xx:
e4x=
(Ltrim join|
DOSHelp= help
version= ver
date= date /t
time= time /t
Volume= vol
ModeStatus= mode
Assoc= assoc /?
AtTimeCommands= at /?
Append= append /?
Attrib= attrib /?
Break= break /?
Cacls= cacls /?
Call= call /?
ChangeDir= cd /?
CodePage= chcp /?
CheckDisk= chkdsk /?
CheckNTFS= chkntfs /?
ClearScreen= cls /?
CMD= cmd /?
CommandCom= command /?
Color= color /?
Compare= comp /?
Compact= compact /?
Convert= convert /?
Copy= copy /?
Debug= debug /?
Defrag= defrag /?
Delete= del /?
Directory= dir /?
Diskcompare= diskcomp /?
Diskcopy= diskcopy /?
Diskpart= diskpart /?
Doskey= doskey /?
Echo= echo /?
Editor= edit /?
Endlocal= endlocal /?
Erase= erase /?
Exit= exit /?
Expand= expand /?
FileCompare= fc /?
Find= find /?
FindSTR= findstr /?
For= for /?
FormatDisk= format /?
Ftype= ftype /?
Goto= goto /?
Graphics= graphics /?
Graftabl= graftabl /?
If= if /?
Label= label /?
LoadfixStartOldie= loadfix /?
MakeDirectory= md /?
Memory= mem /?
Mode= mode /?
ModeStatus= mode
More= more /?
Move= move /?
Path= path /?
Pause= pause /?
Popd= popd /?
Print= print /?
Prompt= prompt /?
Pushd= pushd /?
RemoveDirEmpty= rd /?
Recover= recover /?
Remark= rem /?
Rename= ren /?
Replace= replace /?
Set= set /?
Setlocal= setlocal /?
Setver= setver /?
Shift= shift /?
Sort= sort /?
Start= start /?
Subst= subst /?
Title= title /?
Tree= tree /?
Type= type /?
VerifyCopy= verify
Volume= vol
xcopy= xcopy /?
)
return
;===================== END script =====================================
