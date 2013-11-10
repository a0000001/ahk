#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

; #Include TrayIconToggler.ahk
; #Include ..\Startup\CommonIncludes\tray.ahk
; #Include ..\Startup\CommonIncludes\io.ahk
; #Include test2\test2.ahk
#Include ..\Startup\commonIncludesStandalone.ahk

suspended := 0
v := Object()
m := Object()
v[0] := "suspended"
m[0] := "..\Startup\CommonIncludes\Icons\test.ico"
m[1] := "..\Startup\CommonIncludes\Icons\testSuspended.ico"
setupTrayIcons(v, m)

; ----------------------------------------------------------------------------------------------------------------------

; iniPath := "..\Startup"
; IniRead, machineName, ..\Startup\..\Startup\borg.ini, Main, MachineName
; MsgBox, %machineName%

; a::
	; ; Get user input.
	; FileSelectFile, fileName

	; ; Read in the list of names.
	; referenceLines := fileLinesToArray(fileName)

	; ; Parse the list into nice, uniform reference lines.
	; references := cleanParseList(referenceLines)

	; textOut := ""
	; refsLen := references.MaxIndex()
	; Loop, %refsLen% {
		; textOut .= references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM] . "`n"
		; ; MsgBox, % references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM]
		; findReferenceLine(references[A_Index, LIST_ITEM], references[A_Index, LIST_NUM])
	; }

	; MsgBox, Selected References: `n`n%textOut%
; return

; b::
	; ; Send, {Esc}
	; ; MsgBox, asdf
	; Send, f
	; KeyWait, Esc, T1
; return

; global ITEM := 1
; global NUM := 2

; ^a::
	; ; Get user input.
	; FileSelectFile, fileName
	
	; ; Read in the list of names.
	; referenceLines := fileLinesToArray(fileName)
	
	; ; Parse the list into nice, uniform reference lines.
	; references := cleanParseList(referenceLines)
	
	
	; textOut := ""
	; refsLen := references.MaxIndex()
	; Loop, %refsLen% {
		; textOut .= references[A_Index, ITEM] . "	" . references[A_Index, NUM] . "`n"
		; ; MsgBox, % references[A_Index, ITEM] . "	" . references[A_Index, NUM]
		; ; findReferenceLine(references[A_Index, ITEM], references[A_Index, NUM])
	; }
	
	; MsgBox, Selected References: `n`n%textOut%
; return

; ; Parses and cleans the given list into single-line items.
; cleanParseList(lines) {
	; currPrepend := ""
	; currPostpend := ""
	; list := Object()
	
	; ; Loop through and do work on them.
	; linesLen := lines.MaxIndex()
	; Loop, %linesLen% {
		; ; Clean off leading tab if it exists.
		; cleanLine := lines[A_Index]
		; if(SubStr(cleanLine, 1, 1) = A_Tab) {
			; StringTrimLeft, cleanLine, cleanLine, 1
		; }
		
		; ; Ignore blank and 'commented' lines.
		; if(cleanLine != "" && Substr(cleanLine, 1, 2) != "//") {
			; ; MsgBox, %cleanLine%
			
			; ; Special begin prepend/postpend block line.
			; if(SubStr(cleanLine, 1, 2) = "[ ") {
				; currPrepend := ""
				; currPostpend := ""
				; params1 := ""
				; params2 := ""
				
				; tempLine := lines[A_Index]
				; StringSplit, params, tempLine, |
				
				; ; First parameter.
				; paramChar := SubStr(params1, 3, 1) ; Starting at 3 and 4 to cut out the "[ "
				; paramValue := SubStr(params1, 4)
				; if(paramChar = "b") {
					; currPrepend := paramValue
				; } else if(paramChar = "e") {
					; currPostpend := paramValue
				; }
				
				; ; Second parameter.
				; if(params2) {
					; paramChar := SubStr(params2, 1, 1)
					; paramValue := SubStr(params2, 2)
					; if(paramChar = "b") {
						; currPrepend := paramValue
					; } else if(paramChar = "e") {
						; currPostpend := paramValue
					; }
				; }
			
			; ; Special end block line.
			; } else if(SubStr(cleanLine, 1, 1) = "]") {
				; currPrepend := ""
				; currPostpend := ""
				; ; MsgBox, wiped.
			
			; ; A true line to eventually things to! Yay!
			; } else {
				; ; MsgBox, Pre: %currPrepend%z `nPost: %currPostpend%
			
				; ; Clean lineArr2 in case it isn't in next line.
				; lineArr2 := 0
				
				; ; MsgBox, %cleanLine%
				; StringSplit, lineArr, cleanLine, %A_Tab%
				
				; currLine := expandReferenceLine(lineArr1, currPrepend, currPostpend)
				; whichNum := lineArr2
				
				; ; MsgBox, Pre: `n%currPrepend% `n`nPost: `n%currPostpend% `n`nIn: `n%cleanLine% `n`nOut: `n%currLine% `n`nNum: `n%whichNum%
				; ; MsgBox, Found: `n%prevSearch% `n`nNext: `n%currLine%
				
				; currItem := Object()
				; currItem[ITEM] := currLine
				; currItem[NUM] := whichNum
				; list.Insert(currItem)
				
				; prevSearch := currLine
			; }
		; }
	; }
	
	; return list
; }

expandReferenceLine(input, prepend = "", postpend = "") {
	; MsgBox, Expanding `nPre: %prepend% `nInput: %input% `nApp: %postpend%
	return prepend . input . postpend
}

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


; ----------------------------------------------------------------------------------------------------------------------

~#!x::
	Suspend
	suspended := !suspended
	updateTrayIcon()
return

; Exit, reload, and suspend.
~!+x::ExitApp
; ~#!x::Suspend
^!r::
~!+r::
	Suspend, Permit
	Reload
return