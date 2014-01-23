/*
Author: Gavin Borg

Description: Creates and inserts the needed "#GENERATE" code for Chronicles Data Operations in Caché. Works only in EpicStudio.

Installation:
	Copy this file (epicStudioCDO.ahk) to your desktop and run it.

Usage:
	1. Put your cursor at the end of a line that is blank except for a semicolon (EpicStudio automatically fills in semicolons on blank lines).
	2. After the semicolon, type “;cdo”. Note that that’s two semicolons total.
	3. A window will pop up with the various generate fields in it, which you can fill in and submit. When you do that, the script will fill in the needed #GENERATE code for you.
		Note that the global and lookback fields are optional, and their respective lines will be omitted if left blank.
	
Notes:
	None.
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

#ifWinActive, ahk_class WindowsForms10.Window.8.app.0.2bf8098_r13_ad1

; GUI input for Chronicles Data Operation GENERATE code.
:*:`;cdo::
	Gui, Add, Text, , Type: 
	Gui, Add, Text, , Tag: 
	Gui, Add, Text, , INI: 
	Gui, Add, Text, , Lookback: 
	Gui, Add, Text, , Global: 
	Gui, Add, Text, , Items: 
	
	Gui, Add, Edit, vType x100 ym, Load
	Gui, Add, Edit, vTag,
	Gui, Add, Edit, vINI,
	Gui, Add, Edit, vLookback,
	Gui, Add, Edit, vGlobal,
	Gui, Add, Edit, vItems,
	
	;Gui, Font,, Courier New
	Gui, Add, Button, Default, Generate
	Gui, Show,, Generate CDO Comment
return

ButtonGenerate:
	Gui, Submit
	
genText = 
(
;#GENERATE#
 Type: %Type%
Tag: %Tag%
INI: %INI%
)

	if(Lookback) {
		genText = %genText%`nLookback: %Lookback%
	}
	
	if(Global) {
		genText = %genText%`nGlobal: %Global%
	}
	genText = %genText%`nItems:`n%Items%`n

	SendRaw,%genText%
	Send, {Backspace}
	SendRaw, `;#ENDGEN#
	
	Gui, Destroy
return

#ifWinActive