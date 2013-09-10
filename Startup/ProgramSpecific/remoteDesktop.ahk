#IfWinActive ahk_class TscShellContainerClass

; Allow escape from remote desktop with hotkey.
!CapsLock::	; One of a few that maps back to the host.		
	; Need a short sleep here for focus to restore properly.
	Sleep 50
	WinMinimize A    ; need A to specify Active window
return

#IfWinActive