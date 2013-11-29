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

; ^+y::
	; str1 := applyMods("thisIsAString	2", "[{1}b:asdf|e:here'sJohnny!|b:more|m:(5,2)ggggg]")
	; str2 := applyMods("thisIsAString	2", "[{2}b:asdf|e:here'sJohnny!|b:more|m:(5,2)ggggg]")
	; str3 := applyMods("thisIsAString	2", "[{2}b:asdf|e:here'sJohnny!|{1}b:more|m:(5,2)ggggg]")
	; str4 := applyMods("thisIsAString	2", "[{1}b:asdf|e:here'sJohnny!|b:more|m:(5,-2)ggggg]")
	; str5 := applyMods("thisIsAString	2", "[b:asdf|e:here'sJohnny!|b:more|m:(5,-2)ggggg]")
	
	; MsgBox, % str1[1] . A_Tab . str1[2]
	; MsgBox, % str2[1] . A_Tab . str2[2]
	; MsgBox, % str3[1] . A_Tab . str3[2]
	; MsgBox, % str4[1] . A_Tab . str4[2]
	; MsgBox, % str5[1] . A_Tab . str5[2]
; return

; ; Constants.
; global LIST_BIT := 1
; global LIST_OP = 2
; global LIST_START = 3
; global LIST_LEN = 4
; global LIST_TEXT = 5

^a::
	; SetNumLockState, On
	; MsgBox, % Substr("asdf", -1, 1)
	DetectHiddenText, On
	ControlGet, List, List, , ListView20WndClass2
	MsgBox, % List
return

^b::
	; SetNumLockState, Off
return
	; ; modStripped := "b:(3)asdf"
	; ; mods := parseModLine(modStripped)
	; ; MsgBox, % "Mod: " modStripped "`nBit: " mods[LIST_BIT] "`nStart: " mods[LIST_START] "`nLen: " mods[LIST_LEN] "`nText: " mods[LIST_TEXT]
	
	; ; modStripped := "{2}b:(3)asdf"
	; ; mods := parseModLine(modStripped)
	; ; MsgBox, % "Mod: " modStripped "`nBit: " mods[LIST_BIT] "`nStart: " mods[LIST_START] "`nLen: " mods[LIST_LEN] "`nText: " mods[LIST_TEXT]
	
	; ; modStripped := "{2}e:(3)asdf"
	; ; mods := parseModLine(modStripped)
	; ; MsgBox, % "Mod: " modStripped "`nBit: " mods[LIST_BIT] "`nStart: " mods[LIST_START] "`nLen: " mods[LIST_LEN] "`nText: " mods[LIST_TEXT]
	
	; ; modStripped := "{3}m:(3)asdf"
	; ; mods := parseModLine(modStripped)
	; ; MsgBox, % "Mod: " modStripped "`nBit: " mods[LIST_BIT] "`nStart: " mods[LIST_START] "`nLen: " mods[LIST_LEN] "`nText: " mods[LIST_TEXT]
	
	; ; modStripped := "{3}m:(3, 1)asdf"
	; ; mods := parseModLine(modStripped)
	; ; MsgBox, % "Mod: " modStripped "`nBit: " mods[LIST_BIT] "`nStart: " mods[LIST_START] "`nLen: " mods[LIST_LEN] "`nText: " mods[LIST_TEXT]
	
	; ; modStripped := "{3}m:(-3, -1)asdf"
	; ; mods := parseModLine(modStripped)
	; ; MsgBox, % "Mod: " modStripped "`nBit: " mods[LIST_BIT] "`nStart: " mods[LIST_START] "`nLen: " mods[LIST_LEN] "`nText: " mods[LIST_TEXT]
; ; return
	
	; ; start := 4
	; ; ; start := -4
	; ; len := 3
	; ; ; len := -3
	; ; ; len := 0
	
	; ; ; MsgBox, % SubStr("abcdefghij", 1, start + len) . "zzzzz" . SubStr("abcdefghij", (start + 1) + len)
; ; ; return
	
	; ; ; MsgBox, % SubStr("asdf", 0)
	
	; ; ; mod := parseModLine("b:(1)x")
	; ; ; mod := parseModLine("m:(1,1)x")
	; ; ; mod := parseModLine("e:(-1)x")
	; ; ; mod := parseModLine("m:(-1,-1)x")
	; ; mod := parseModLine("m:(0)x")
	; row := "whee	second	third	4"
	; rowSplit := specialSplit(row, A_Tab)
	
	; rowSplitLen := rowSplit.MaxIndex()
	; Loop, %rowSplitLen% {
		; MsgBox, % rowSplit[A_Index]
	; }
; return
	; ; MsgBox, % doMod(rowBit, mod)
; ; return
	; mods := Object()
	; ; updateMods(mods, SubStr("[b:test]", 2, -1))
	; ; updateMods(mods, SubStr("[/e:x]", 2, -1))
	; ; updateMods(mods, SubStr("[/{2}m:(-3, -1)asdf]", 2, -1))
	; updateMods(mods, "[{3}b:C:\Program Files (x86)\Epic\v7.9\Shared Files\EpicD79.exe EDAppServers79.EpicApp]")
	
	; Loop, 1 {
		; MsgBox, % "Mod: " mods[A_Index, LIST_MOD] "`nBit: " mods[A_Index, LIST_BIT] "`nStart: " mods[A_Index, LIST_START] "`nLen: " mods[A_Index, LIST_LEN] "`nText: " mods[A_Index, LIST_TEXT]
	; }
	
	; ; doneRow := applyMods(row, mods)
	; doneRow := applyMods(row, mods)
	; MsgBox, % doneRow[1] "`n" doneRow[2] "`n" doneRow[3]
; return

	; ; MsgBox, % SubStr("[asdf]", 2, -1)
	; test := Object()
	; test.Insert("asdf")
	
	; MsgBox, % test[1]
	
	; insertFront(test, "jkl;")
	
	; MsgBox, % test[1]
	; MsgBox, % test[2]
; return
	; ; m := "-0"
	; ; g := m + 1
	; ; MsgBox, % g
	
	; ; Get user input.
	; ; FileSelectFile, fileName
	; fileName := "A:\ahk_shared\VB6\ReferencesHelper\vbHyperspaceUsualReferencesCompacter.txt"
	
	; ; Read in the list of names.
	; referenceLines := fileLinesToArray(fileName)
	
	; ; Parse the list into nice, uniform reference lines.
	; references := cleanParseList(referenceLines)
	
	; textOut := ""
	; refsLen := references.MaxIndex()
	; Loop, %refsLen% {
		; textOut .= references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM] . "`n"
		; ; MsgBox, % references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM]
		; ; findReferenceLine(references[A_Index, LIST_ITEM], references[A_Index, LIST_NUM])
	; }
	
	; MsgBox, Selected References: `n`n%textOut%
; return

; ^b::
	; ; Get user input.
	; ; FileSelectFile, fileName
	; fileName := "J:\vbHyperspaceRefsModded.ini"
	
	; ; Read in the list of names.
	; referenceLines := fileLinesToArray(fileName)
	
	; ; Parse the list into nice, uniform reference lines.
	; references := cleanParseList(referenceLines)
	
	; ; MsgBox, % references[1]
	; ; MsgBox, % references[2]
	
	; textOut := ""
	; refsLen := references.MaxIndex()
	; Loop, %refsLen% {
		; textOut .= references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM] . "`n"
		; ; MsgBox, % references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM]
		; ; findReferenceLine(references[A_Index, LIST_ITEM], references[A_Index, LIST_NUM])
	; }
	
	; MsgBox, Selected References: `n`n%textOut%
; return

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