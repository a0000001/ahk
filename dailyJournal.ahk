#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

FormatTime, date, , dddd`, M/d/yy

; Run, S:\dailyJournal.txt

GoSub, CreateGUI

Gui, Show, , Add to Daily Journal

return

; 2 and is special - we'll need to change the height.
CreateGUI:
	GoSub, CreateGUI1
	GoSub, CreateGUI2
	GoSub, CreateGUI3
return

CreateGUI1:
	Gui, Add, Text,, Date:
	Gui, Add, Text,, Wake:
	Gui, Add, Text, r10, Events:
return

; New blank labels here!

CreateGUI2:
	Gui, Add, Text,, Concerta:
	Gui, Add, Text,, Feeling:
	Gui, Add, Text,, Sleep:
	; The ym option starts a new column of controls.
	Gui, Add, Edit, ym vDateToday
	Gui, Add, Edit, vWake
	Gui, Add, Edit, vEvents r10 w300 WantTab T5
return

; Insert new things here!

CreateGUI3:
	Gui, Add, Edit, vConcerta
	Gui, Add, Edit, vFeeling
	Gui, Add, Edit, vSleep
	Gui, Add, Button, default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.
return

Enter::
	ControlGetFocus, currControl, A
	if(currControl == "Edit3") {
		;MsgBox
		Gui, Destroy
		GoSub, CreateGUI
		Gui, Add, Text,, Date2:
		Gui, Show
	} else {
;		MsgBox,
		Send {Enter}
	}
return
	
;^Tab::return

Esc::ExitApp

+Tab::Backspace

;; To Do ---------------
; Events: split into lines, then loop thru them and add a `t before each line.
; Concerta: calculate hours past 11a.
; Wake: default time based on day.
; Use 'array' to hold new edit rows.
; Specify controls by variables, not classNN.
; Use ControlGui to do things with them.
; Find a way to keep track of how many edits, how far indented, etc.



ButtonOK:

MsgBox


;Gui, Submit  ; Save the input from the user to each control's associated variable.
;FileAppend,
;(
;%DateToday%`r
;Wake: %Wake%`r
;Events:`r`t%Events%`r
;Concerta: %Concerta%`r
;Feeling: %Feeling%`r
;Sleep: %Sleep%
;), G:\Downloads\appendTest.txt
return

;Saturday, 2/18/12
;	Wake: 
;	Events:
;		
;	Concerta: 
;	Feeling:
;		
;	Sleep: 

^i::
	Send, ^{End}
	Send, %date%
	Send, `r{Tab}Wake:{Space}
	Send, `rEvents:
	Send, `r{Tab}
	Send, `r{Backspace}Concerta:{Space}
	Send, `rFeeling:
	Send, `r{Tab}
	Send, `r{Backspace}Sleep:{Space}
	Send, `r{Backspace}
	Send, `r{Backspace}
	Send, {Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{End}
	ExitApp
return

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload