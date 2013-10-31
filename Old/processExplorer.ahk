; Activation hotkey.
!`::
	if(WinExist("ahk_class PROCEXPL")) {
		if(!WinActive("ahk_class PROCEXPL")) {
			WinShow
			WinActivate
		} else {
			WinClose
		}		
	} else {
		Run "C:\Program Files\ProcessExplorer\procexp.exe"
	}
return

#ifWinActive, ahk_class PROCEXPL

; ; Tray icons fix
; ^+f::
	; Send !oii
	; Send !oii
; return

#ifWinActive