#ifWinActive, ahk_class CabinetWClass

; New folder: modding hotkey
^n::^+n

; ; New autohotkey script
; ^+s::
	; send !f
	; send w
	; send a
	; send {Enter}
; return

; ; Edit file in Notepad++
; ^+n::
	; send !f
	; send n
	; send {ENTER}
; return

; ; Open in Adobe Reader/Powerpoint
; ^+a::
; ^+p::
	; send !f
	; send h
	; send {Right}
	; send {Enter}
; return

; ; unzip to folder with zipped file's name (via 7-zip)
; ^u::
	; send !f
	; send 7
	; send {Down}{Down}{Down}{Enter}
; return

; ; Tab renaming abilities
; Tab::
	; ;Hotkey,Tab,Off
	; ControlGetFocus, CurrentControl,A
	; If (CurrentControl="Edit2")
	; {
		; Send {Enter}{Down}{F2}
		; }
	; Else
	; {
		; Send {Tab}
	; }
	; ;Hotkey,Tab,On
; Return

; ; Shift-Tab renaming abilities
; +Tab::
	; ;Hotkey,+Tab,Off
	; ControlGetFocus, CurrentControl,A
	; If (CurrentControl="Edit2")
	; {
		; Send {Enter}{Up}{F2}
	; }
	; Else
	; {
		; Send +{Tab}
	; }
	; ;Hotkey,+Tab,On
; Return

; Firefox-like ctrl+l shortcut
; ^l::
	; Send !d
; return

; http://www.autohotkey.com/forum/post-342375.html#342375
; Hide/show hidden files.
#h::
RegRead, ValorHidden, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
if ValorHidden = 2
   RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
Else
   RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
send {F5}
Return

#ifWinActive