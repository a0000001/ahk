
; Replace windows explorer with FreeCommander.
; #e::Run "C:\Program Files\FreeCommander\FreeCommander.exe"

; Activation hotkey.
#e::
	if(WinExist("ahk_class TfcForm")) {
		; Make it a tool-type window to hide it from the taskbar.
		; WinSet, ExStyle, +0x80
		
		; Grab the style so we can tell if it's already hidden.
		WinGet, style, Style, ahk_class TfcForm
		
		if(WinActive("ahk_class TfcForm") && !(style = "0x07CF0000" || style = "0x06CF0000" || style = "0x36CF0000")) {
			minimizeWindowSpecial()
			activateLastWindow()
		} else {
			WinShow
			; WinMaximize
			WinActivate
			; Send, ^+{F2}
		}
		
	} else {
		; MsgBox, Running FC.
		Run "C:\Program Files (x86)\FreeCommander\FreeCommander.exe"
		WinWait, ahk_class TfcForm
	}
return

#IfWinActive, ahk_class TfcForm
	; ; New folder hotkey.
	; ^n::
		; Send, ^+n
		; Send, f
	; return

	; ; 7-zip unzip.
	; ^u::
		; Send, ^+c
		; Sleep, 500
		
		; ; MsgBox, % clipboard
		
		; ; Snag the filepath off of the clipboard, encase it in quotes.
		; filePath := clipboard
		
		; ; MsgBox, % filePath
		
		; ; Split off the path to the zipped file and the name of the zipped file (for subfolder name).
		; StringGetPos, slashPos, clipboard, \, R
		; StringTrimRight, parentPath, clipboard, (StrLen(clipboard) - slashPos) - 1
		; StringTrimLeft, fileName, clipboard, slashPos + 1
		
		; ; MsgBox, %parentPath%`n%fileName%
		
		; ; Decide if this file has an extension.
		; StringGetPos, dotPos, fileName, ., L
		; if(dotPos == -1) {
			; fileName = %fileName%Out
		; } else {
			; ; If so, split it off and use the remainder as the folder name.
			; StringTrimRight, fileName, fileName, StrLen(fileName) - dotPos
		; }
		
		; ; MsgBox, %parentPath% %fileName%
		
		; ; Unzip it.
		; runStr = "C:\Program Files\7-zip\7z.exe" x -o"%parentPath%%fileName%" "%filePath%"
		; ; MsgBox, % runStr
		; ; clipboard := runStr
		; Run, %runStr%
	; return

	; ; 7-zip zip.
	; ^+u::
		; Send, ^+c
		; Sleep, 500
		
		; ; Get the user's intended archive filename.
		; InputBox, archiveName, Input Archive Name, Archive Name:, , 200, 90
		
		; if(ErrorLevel){
			; return
		; }
		
		; ; MsgBox, % clipboard
		
		; ; Split off the path to the zipped file and the name of the zipped file (for subfolder name).
		; StringGetPos, newLinePos, clipboard, `n, R
		; StringTrimLeft, parentPath, clipboard, newLinePos + 1
		; StringGetPos, slashPos, parentPath, \, R
		; StringTrimRight, parentPath, parentPath, (StrLen(parentPath) - slashPos) - 1
		
		; ; MsgBox, % slashPos parentPath
		
		; ; return
		
		; StringSplit, fileNames, clipboard, `n
		; ; fileNames := clipboard
		
		; ; StringReplace, fileNames, fileNames, `n, %A_Space%
		
		; fileNamesString := ""
		
		; i := 1
		; while(i <= fileNames0) {
			
			; if(i < fileNames0) {
				; StringTrimRight, fileNames%i%, fileNames%i%, 1
			; }
			
			; temp := fileNames%i%
			; fileNamesString = %fileNamesString% "%temp%"
			; i++
		; }
		
		; ; MsgBox, % fileNamesString
		; ; clipboard := fileNamesString
		
		; runStr = "C:\Program Files\7-zip\7z.exe" a %parentPath%%archiveName% %fileNamesString%
		
		; ; MsgBox, % runStr
		; ; clipboard := runStr
		
		; Run, %runStr%
	; return
#IfWinActive 