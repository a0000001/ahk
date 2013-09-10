#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


MsgBox, Ctrl+f to format, Ctrl+u to unformat.

^f::
	temp := clipboard
	Send, % convert_formatPhoneNumber(temp)

return

^u::
	temp := clipboard
	Send, % convert_unFormatPhoneNumber(temp)
return

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload