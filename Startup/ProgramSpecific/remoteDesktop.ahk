﻿; Disconnect hotkey.
!Esc::
	RunCommand("tsdiscon")
return

#IfWinActive ahk_class TscShellContainerClass
	; Allow escape from remote desktop with hotkey.
	!CapsLock::	; One of a few keys that the host still captures.
		Suspend, Off
		Sleep 50 ; Need a short sleep here for focus to restore properly.
		WinMinimize, A ; need A to specify Active window
	return
#IfWinActive

#If !WinActive("ahk_class TscShellContainerClass") && WinExist("ahk_class TscShellContainerClass")
	; Switch back into remote desktop with same hotkey.
	!CapsLock::
		WinActivate, ahk_class TscShellContainerClass
	return
#If 