SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force  ; Ensures that if this script is running, running it again replaces the first instance.
; #NoTrayIcon  ; Uncomment to hide the tray icon.

#Include ..\CommonIncludes\io.ahk
#Include ..\CommonIncludes\data.ahk
#Include ..\CommonIncludes\HTTPRequest.ahk
#Include ..\CommonIncludes\selector.ahk
#Include ..\CommonIncludes\selectorActions.ahk
#Include ..\CommonIncludes\selectorRow.ahk
#Include ..\CommonIncludes\string.ahk
#Include ..\CommonIncludes\tableList.ahk
#Include ..\CommonIncludes\tableListMod.ahk


iniPath := "..\borg.ini"
iniSetupPath := "..\..\Selector\setup.ini"
commonPath := "..\commonIncludesStandalone.ahk"
zipPath := "..\..\Selector\zipAll.bat"
unZipPath := "..\..\Selector\unZipAll.bat"
rootTag := "<ROOT>"
machineTag := "<WHICHMACHINE>"
vimKeyTag := "<VIMCLOSEKEY>"
versionTag := "<VERSION>"


; Get current absolute path use to get ahk root folder.
StringTrimRight, rootPath, A_ScriptDir, 14 ; Length of path back to root for this particular file: \Startup\Setup.
; MsgBox, % rootPath


; Prompt the user for which computer this is.
machineInfo := Selector.select(iniSetupPath, "RET")
if(machineInfo = "") {
	MsgBox, No machine given, exiting setup...
	ExitApp
}
; MsgBox, % machineInfo
machineInfoSplit := specialSplit(machineInfo, "^")
whichMachine := machineInfoSplit[1]
editVersion := machineInfoSplit[2]
vimKey := machineInfoSplit[3]
; MsgBox, % "Machine: " whichMachine "`nVersion: " editVersion


; Generate borg.ini from user input.
FileRead, borgINI, borg.ini.master
; MsgBox, % borgINI
StringReplace, borgINI, borgINI, %machineTag%, %whichMachine%, A
StringReplace, borgINI, borgINI, %vimKeyTag%, %vimKey%, A
; MsgBox, % borgINI
FileDelete, %iniPath%
FileAppend, %borgINI%, %iniPath%


; Generate standalone standard includes, since it needs absolute paths.
FileRead, commonIncludesStandlone, commonIncludesStandalone.ahk.master
; MsgBox, % commonIncludesStandlone
StringReplace, commonIncludesStandlone, commonIncludesStandlone, %rootTag%, %rootPath%, A
; MsgBox, % commonIncludesStandlone
FileDelete, %commonPath%
FileAppend, %commonIncludesStandlone%, %commonPath%


; Generate zip/unzip batch files, since they need absolute paths.
FileRead, zipAll, zipAll.bat.master
FileRead, unZipAll, unZipAll.bat.master
; MsgBox, % zipAll "`n`n" unZipAll
StringReplace, zipAll, zipAll, %rootTag%, %rootPath%, A
StringReplace, unZipAll, unZipAll, %rootTag%, %rootPath%, A
StringReplace, zipAll, zipAll, %versionTag%, %editVersion%, A
StringReplace, unZipAll, unZipAll, %versionTag%, %editVersion%, A
; MsgBox, % zipAll "`n`n" unZipAll
FileDelete, %zipPath%
FileDelete, %unZipPath%
FileAppend, %zipAll%, %zipPath%
FileAppend, %unZipAll%, %unZipPath%


; Unzip all zipped files using .bat file.
RunWait, % unZipPath

; MsgBox, Close this once unzipping is completed.
MsgBox, 4, , Run now?
IfMsgBox Yes
	Run, %rootPath%\Startup\borg.ahk, %rootPath%\Startup\

ExitApp


; Exit, reload, and suspend.
~!+x::ExitApp
~#!x::Suspend
~!+r::
	Suspend, Permit
	Reload
return