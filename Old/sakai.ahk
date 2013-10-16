; No longer used - better-implemented version now in selectorGUI.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, force

; Choices.

class1 = Programming Languages (CSC 231)
url1 = https://sakai.wfu.edu/dav/492ebd5a-5f85-49b6-80b5-1f58e22716a6

class2 = Combinatorics (MTH 349)
url2 = https://sakai.wfu.edu/dav/b35e33dc-2949-4d6c-9e1f-137fe81a7ed6


; Put the above stuff together.
while(class%A_Index% != "") {
	classSet .= class%A_Index% "|"
}

StringTrimRight, classSet, classSet, 1

; Pop up a gui, list choices.

Gui, Add, Text, , Choose which class' sakai to connect to:
Gui, Add, ListBox, vClassChoice AltSubmit r10 w200 choose1, %classSet%
Gui, Add, Button, Default, OK
Gui, Show
 
return

ButtonOK:
	Gui, Submit
;	MsgBox, % classChoice " " class%ClassChoice% " " url%ClassChoice%
	
	unMapNetworkDrive()	; Might be able to remove this by keeping list of available drives or something.
	mapNetworkDrive(url%ClassChoice%)
	
	ExitApp
return

Esc::
	Gui, Destroy
	ExitApp
return

unMapNetworkDrive(drive = "Z") {
	Run net use Z: /delete
}

mapNetworkDrive(url) {
	; MsgBox, % url
	
	; Attach the thing.
	runString := "net use Z: /persistent:no /user:borg " url
	clipboard := runString
	; MsgBox, % runString
	Run %runString%
}

