#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

; sets statuses for disby and skype, both, to either away or to available.

; set to away
!+a::
	; Skype
	IfWinNotExist, ahk_class tSkMainForm.UnicodeClass
	{
		Send ^!s
	}
	WinActivate, ahk_class tSkMainForm.UnicodeClass
	Send !s
	Send oa
	Sleep 100
	Send !s
	Send l	
	
	; digsby
	IfWinNotExist, ahk_class wxWindowClassNR
	{
		Send ^!d
	}
	WinActivate, ahk_class wxWindowClassNR
	Send !d
	Send {Down}{Right}{Down}{Down}{Down}{Down}{Down}{Enter}
return

; set to available again
!+#a::
	; Skype
	IfWinNotExist, ahk_class tSkMainForm.UnicodeClass
	{
		Send ^!s
	}
	WinActivate, ahk_class tSkMainForm.UnicodeClass
	Send !s
	Send oo
	Sleep 100
	Send !s
	Send l
	
	; digsby
	IfWinNotExist, ahk_class wxWindowClassNR
	{
		Send ^!d
	}
	WinActivate, ahk_class wxWindowClassNR
	Send !d
	Send {Down}{Right}{Down}{Down}{Down}{Enter}
return