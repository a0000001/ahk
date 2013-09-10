#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

OnExit, OnExit

SetWorkingDir, %A_Temp%

;//Default Keys:
;//         F12: Run highlighted text as an AHK script
;//   Shift+F12: Edit highlighted text in your default editor & then Run as AHK script
;//     Alt+F12: Save last tested script

RunScript_Hotkey=F12
EditnRun_Hotkey=+F12
SaveLast_Hotkey=!F12

;//DontConfirmTempScriptDeleteOnExit=1

Hotkey, %RunScript_Hotkey%, RunScript
Hotkey, %EditnRun_Hotkey%, EditnRun
Hotkey, %SaveLast_Hotkey%, SaveLast

InsertScript_Before=
(LTrim
	;//This is inserted in all scripts before any other code...
)

InsertScript_After=
(LTrim
	;//This is inserted in all scripts after any other code...
	^+#!x::ExitApp			;Ctrl+Shift+Win+Alt+X = Emergency Exit
)

Loop {
	Random, TempScriptFile, 1000000, 9999999
	TempScriptFile=%A_Temp%\temp%TempScriptFile%.ahk
	IfNotExist, %TempScriptFile%
		break
	If A_Index>9
	{
		msgbox, 16, , Error generating Temp Script Filename...
		ExitApp
	}
}

WarnAHKCmds=
(LTrim
	DllCall
	FileAppend
	FileCopy
	FileCopyDir
	FileCreateDir
	FileCreateShortcut
	FileDelete
	FileInstall
	FileMove
	FileMoveDir
	FileRecycle
	FileRecycleEmpty
	FileRemoveDir
	FileSetAttrib
	FileSetTime
	IniDelete
	IniWrite
	Process.+Close
	RegDelete
	RegWrite
	Run
	RunWait
	Shutdown
	UrlDownloadToFile
	WinClose
	WinKill
)
return

RunScript:
cba:=ClipboardAll
clipboard=
Send, ^c
ClipWait, 1
if (errorlevel) {
	msgbox, 16, , ClipWait Timeout!`n`nSelect some text...
	clipboard:=cba
	cba=
	return
}
TempScript:=Clipboard
clipboard:=cba
cba=
Loop, Parse, WarnAHKCmds, `n, `r
{
	regex:="i)" A_LoopField
	m:=RegExMatch(TempScript, regex)
	;//msgbox, m(%m%):=RegExMatch(%TempScript%, %regex%)
	if (m){
		unsafecmds++
		warnmsg:=warnmsg "" unsafecmds ": " A_LoopField "`n"
	}
}
if unsafecmds
{
	s=
	if unsafecmds!=1
		s=s
	msgbox, 17, ,
	(LTrim
		Warning!...%unsafecmds% unsafe AHK Command%s% Detected...

		%warnmsg%
		...review script before running!

		Review Now?
	)
	warnmsg=
	unsafecmds=
	IfMsgBox, OK
	{
		;//msgbox, edit
		;//return
		EditScript=1
	}
	else return
}
IfExist, %TempScriptFile%
	FileDelete, %TempScriptFile%
WinWait, a
WinGetText, url
Loop, Parse, url, `n, `r
{
	if (RegExMatch(A_LoopField, "://")){
		WinGetTitle, title
		title:=";//" RegExReplace(title, " - .*$") "`n"
		url:=";//" RegExReplace(A_LoopField, ".*://www\.|&highlight=(?=&|$)") "`n"
		break
	} else url=
}
;//msgbox, title(%title%)`nurl(%url%)
if (!RegExMatch(InsertScript_Before, "`n$"))
	InsertScript_Before:=InsertScript_Before "`n"
if (!RegExMatch(InsertScript_After, "^`n"))
	InsertScript_After:="`n" InsertScript_After
FileAppend, %title%%url%%InsertScript_Before%%TempScript%%InsertScript_After%, %TempScriptFile%
if EditScript
{
	RunWait, edit %TempScriptFile%
	FileRead, TempScript, %TempScriptFile%
}
msgbox, 20, ,
(LTrim
	-------------------
	%TempScript%
	-------------------

	Run script now?
)
IfMsgBox, Yes
	Run, %TempScriptFile%
title=
url=
TempScript=
EditScript=
return

EditnRun:
EditScript=1
Gosub, RunScript
EditScript=
return

SaveLast:
IfExist, %TempScriptFile%
{
	Loop {
		;ask user where to copy %TempScriptFile% to
		FileSelectFile, SaveFile, S, %A_Desktop%, Save Script..., Autohotkey Script (*.ahk)
		if (!errorlevel) {
			SplitPath, SaveFile, , , ext
			if ext=
				SaveFile=%SaveFile%.ahk
			IfExist, %SaveFile%
			{
				msgbox, 52, , %SaveFile% already exists.`nDo you want to replace it?
				IfMsgBox, No, continue
			}
			FileCopy, %TempScriptFile%, %SaveFile%, 1
			if (errorlevel) {
				msgbox, 16, , Error saving script!
			}
		}
		break
	}
} else msgbox, 16, , Error: no last script file to save!...dumbass!
return

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload

OnExit:
IfExist, %TempScriptFile%
{
	if (!DontConfirmTempScriptDeleteOnExit) {
		msgbox, 20, , Delete temp script file?`n`n%TempScriptFile%
		IfMsgBox, Yes
			FileDelete, %TempScriptFile%
	} else FileDelete, %TempScriptFile%
}
ExitApp
