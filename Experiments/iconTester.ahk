#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

icons := Object()
global currIcon := 1

FileSelectFile, files, M3, G:\Downloads

; MsgBox, %files%

if(ErrorLevel) {
	ExitApp
}

Loop, Parse, files, `n
{
    if(A_INDEX = 1) {
        ; MsgBox, The selected files are all contained in %A_LoopField%.
		path := A_LoopField
    } else {
        ; MsgBox, 4, , The next file is %A_LoopField%.  Continue?
        ; IfMsgBox, No, break
		icons.Insert(path . "\" . A_LoopField)
    }
}

; MsgBox, % icons[1]
Menu, Tray, Icon, % icons[1]



; Exit.
~!+x::ExitApp

; ----------------------------------------------------------------------------------------------------------------------

^a::
	currIcon++
	
	if(!icons.HasKey(currIcon)) {
		currIcon := 1
	}
	
	Menu, Tray, Icon, % icons[currIcon]
return

^+a::
	currIcon--
	
	if(!icons.HasKey(currIcon)) {
		currIcon := icons.MaxIndex()
	}
	
	Menu, Tray, Icon, % icons[currIcon]
return

