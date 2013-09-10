; For find command
; #f::run C:\Program Files (x86)\Everything\Everything.exe

; For everything: open folder.
; +Enter::
	; setTitleMatchMode, 2
	; if WinActive(" - Everything")
	; {
		; Send +{AppsKey}
		; Send e
		; Send {Enter}
	; }
	; setTitleMatchMode, 1
; return