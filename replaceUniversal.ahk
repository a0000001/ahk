#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
#SingleInstance force

; http://lifehacker.com/5825307/online-accounts-search-and-replace-and-lifehacker-tag-pages/gallery/3

^!R::
Gui:
Gui Destroy
Gui, Add, Text,, Search:
Gui, Add, Edit, r1 w210 vSearch
Gui, Add, Text,, Replace:
Gui, Add, Edit, r1 w210 vReplace
Gui, Add, Button, x+-50 y+5 gReplace Default, Replace
Gui, Show, W230 H130, Ctrl+R Everywhere
return

GuiEscape:
Gui Destroy
return

Replace:
	Gui Submit
	previous := % clipboard
	Sleep 100
	Send ^a
	Sleep 100
	Send ^c
	; Original: case sensitive.
	; newtext := RegExReplace(clipboard, Search, Replace, count)
	newtext := RegExReplace(clipboard, "i)"Search, Replace, count)
	MsgBox, 4, %count% occurrencies., %count% occurrencies. Continue?
	IfMsgBox Yes
		clipboard := % newtext
	Sleep 100
	Send ^a
	Sleep 100
	Send ^v
	clipboard := % previous
	IfMsgBox No
		Gosub Gui
	return
return

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload