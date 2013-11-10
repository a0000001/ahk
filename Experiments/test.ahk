#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

; #Include TrayIconToggler.ahk
#Include ..\Startup\CommonIncludes\trayTools.ahk


; obj := Object()
; obj[1] := "a"
; MsgBox, % obj[1]



suspended := 0
v := Object()
m := Object()
v[0] := "suspended"
m[0] := "..\Startup\CommonIncludes\Icons\test.ico"
m[1] := "..\Startup\CommonIncludes\Icons\testSuspended.ico"
setupTrayIcons(v, m)

~#!x::
	Suspend
	suspended := !suspended
	updateTrayIcon()
return

; Exit, reload, and suspend.
~!+x::ExitApp
; ~#!x::Suspend
~!+r::
	Suspend, Permit
	Reload
return

; ----------------------------------------------------------------------------------------------------------------------

; ^b::
	; s := "asdf"
	; len := StrLen(s)
	
	; MsgBox, % s . " " . len . " " . SubStr(s, 1, len)
; return

^a::
	SAME_THRESHOLD := 10
	
	currPrepend := ""
	currPostpend := ""
	
	prevRow := ""
	prevLine := ""
	numSame := 1
	
	textOut := ""
	
	FileSelectFile, fileName
	
	; Read in the list of names.
	Loop, Read, %fileName%
	{
		notFoundYet := true
		
		; Clean off leading tab if it exists.
		cleanLine := A_LoopReadLine
		if(SubStr(cleanLine, 1, 1) = A_Tab) {
			StringTrimLeft, cleanLine, cleanLine, 1
		}
		
		; Ignore blank and 'commented' lines.
		if(cleanLine != "" && Substr(cleanLine, 1, 2) != "//") {
			
			; MsgBox, %cleanLine%
			
			; Special begin prepend/postpend block line.
			if(SubStr(cleanLine, 1, 2) = "[ ") {
				currPrepend := ""
				currPostpend := ""
				params1 := ""
				params2 := ""
				
				StringSplit, params, A_LoopReadLine, |
				
				; First parameter.
				paramChar := SubStr(params1, 3, 1) ; Starting at 3 and 4 to cut out the "[ "
				paramValue := SubStr(params1, 4)
				if(paramChar = "b") {
					currPrepend := paramValue
				} else if(paramChar = "e") {
					currPostpend := paramValue
				}
				
				; Second parameter.
				if(params2) {
					paramChar := SubStr(params2, 1, 1)
					paramValue := SubStr(params2, 2)
					if(paramChar = "b") {
						currPrepend := paramValue
					} else if(paramChar = "e") {
						currPostpend := paramValue
					}
				}
			
			; Special end block line.
			} else if(SubStr(cleanLine,1,1) = "]") {
				currPrepend := ""
				currPostpend := ""
				; MsgBox, wiped.
			
			; A true line to do things to! Yay!
			} else {
				
				; MsgBox, Pre: %currPrepend%z `nPost: %currPostpend%
			
				; Clean lineArr2 in case it isn't in next line.
				lineArr2 := 0
				
				; MsgBox, %cleanLine%
				StringSplit, lineArr, cleanLine, %A_Tab%
				
				; currLine := convertStarToES(lineArr1)
				currLine := expandReferenceLine(lineArr1, currPrepend, currPostpend)
				num := lineArr2
				
				; MsgBox, Pre: `n%currPrepend% `n`nPost: `n%currPostpend% `n`nIn: `n%cleanLine% `n`nOut: `n%currLine% `n`nNum: `n%num%
				textOut := textOut . currLine . "`n"
				
				firstChar := SubStr(currLine, 1, 1)
				; MsgBox, First Char: %firstChar%
				
;					MsgBox, Found: `n%prevSearch% `n`nNext: `n%currLine%
				
				if(currLine < currRow) {
					Send, {Home}
				}
				
				; Loop downwards through lines.
				While, notFoundYet {
					SendRaw, %firstChar%
					
					Sleep, 1
					ControlGetText, currRow, Button5, A
					; MsgBox, %currRow%
					
					; This block controls for the end of the listbox, it stops when the last SAME_THRESHOLD rows are the same.
					if(currRow = prevRow) {
						numSame++
					} else {
						numSame := 1
					}
					; MsgBox, Row: %currRow% `nPrevious: %prevRow% `nnumSame: %numSame%
					if(numSame = SAME_THRESHOLD) { ; Pretty sure we're at the end now, finish.
						notFoundYet := false
					}
					
					prevRow := currRow
					
					; If it matches our input, check it.
					if(currRow = currLine) {
						; If we've got the additional argument, push down a few more before selecting.
						if(num) {
							num--
							Send, {Down %num%}
						}
						
						Send, {Space}
						notFoundYet := false
					}
					
				}
				notFoundYet := true
				prevLine := currLine
				
				prevSearch := currLine
			}
		}
	}
	
	MsgBox, % textOut
return

; ^a::
	
; return

; ^s::
	; Send, ^{Tab}
; return

; ^b::
	
; return


; #Tab::
	; MsgBox, asdf
; return

	; ; MsgBox, % suspended
	; ; suspended := !suspended
	; Send, {Delete 2}
	; SendRaw, *
	; Send, {Space}{End}{Delete}{Enter}{Home}{Down}
; ; return

; ^d::
	; Send, {End}{Enter}{Tab}A{Backspace}
; return

; $^b::
	; Send, {Home}{Shift Down}{End}{Shift Up}^b{Down}{Home}
	
	; ControlGetText, test, WindowsForms10.Window.8.app.0.2bf8098_r13_ad160
	; MsgBox, % test
	
	; a := Object()
	; a[1] := "asdf"
	; testFunc(a)

	; a["01"] := 1
	; ; testObj["1"] := Object()
	
	; a["1", "a"] := "z"

	; ; MsgBox, % testObj["01"]
	; MsgBox, % a["1", "a"]
	
	; filePath := "blahBlahBlah.ini"
	; lastFilePath := SubStr(filePath, 1, -4) "Last.ini"
	; MsgBox, % lastFilePath
; return

; testFunc(obj) {
	; MsgBox, % obj[1]
; }


