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

^+y::
	MsgBox, % applyMods("thisIsAString	2", "[{1}b:asdf|e:here'sJohnny!|b:more|m:(5,2)ggggg]")
	MsgBox, % applyMods("thisIsAString	2", "[{2}b:asdf|e:here'sJohnny!|b:more|m:(5,2)ggggg]")
	MsgBox, % applyMods("thisIsAString	2", "[{2}b:asdf|e:here'sJohnny!|{1}b:more|m:(5,2)ggggg]")
	MsgBox, % applyMods("thisIsAString	2", "[{1}b:asdf|e:here'sJohnny!|b:more|m:(5,-2)ggggg]")
	; MsgBox, % applyMods("thisIsAString	2", "[{30}b:asdf|e:here'sJohnny!|b:more|m:(-5,2)ggggg]")
	MsgBox, % applyMods("thisIsAString	2", "[b:asdf|e:here'sJohnny!|b:more|m:(-5,-2)ggggg]")
return

^a::
	; m := "-0"
	; g := m + 1
	; MsgBox, % g
	
	; Get user input.
	; FileSelectFile, fileName
	fileName := "A:\ahk_shared\VB6\ReferencesHelper\vbHyperspaceUsualReferencesCompacter.txt"
	
	; Read in the list of names.
	referenceLines := fileLinesToArray(fileName)
	
	; Parse the list into nice, uniform reference lines.
	references := cleanParseList(referenceLines)
	
	textOut := ""
	refsLen := references.MaxIndex()
	Loop, %refsLen% {
		textOut .= references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM] . "`n"
		; MsgBox, % references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM]
		; findReferenceLine(references[A_Index, LIST_ITEM], references[A_Index, LIST_NUM])
	}
	
	MsgBox, Selected References: `n`n%textOut%
return

^b::
	; Get user input.
	; FileSelectFile, fileName
	fileName := "J:\vbHyperspaceRefsModded.ini"
	
	; Read in the list of names.
	referenceLines := fileLinesToArray(fileName)
	
	; Parse the list into nice, uniform reference lines.
	references := cleanParseList2(referenceLines)
	
	; MsgBox, % references[1]
	; MsgBox, % references[2]
	
	textOut := ""
	refsLen := references.MaxIndex()
	Loop, %refsLen% {
		textOut .= references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM] . "`n"
		; MsgBox, % references[A_Index, LIST_ITEM] . "	" . references[A_Index, LIST_NUM]
		; findReferenceLine(references[A_Index, LIST_ITEM], references[A_Index, LIST_NUM])
	}
	
	MsgBox, Selected References: `n`n%textOut%
return

cleanParseList2(lines, defaultBit = 1) {
	currMods := "[]"
	list := Object()
	
	; MsgBox, % lines[1] . "`n" . LIST_ITEM . "`n" . iSearch_imageSpacingTolerance
	
	; Loop through and do work on them.
	linesLen := lines.MaxIndex()
	Loop, %linesLen% {
		currRow := lines[A_Index]
		; MsgBox, %currRow%
		
		; Strip off any leading whitespace.
		Loop {
			firstChar := SubStr(currRow, 1, 1)
			; MsgBox, First char: z%firstChar%z
		
			if(firstChar != A_Tab && firstChar != A_Space) {
				; MsgBox, Break
				Break
			}
			; MsgBox, trimming
			StringTrimLeft, currRow, currRow, 1
			; MsgBox, trimmed: z%currRow%z
		}
		
		; Ignore it entirely if it's an empty line or beings with ; (a comment).
		firstChar := SubStr(currRow, 1, 1)
		; MsgBox, First char: z%firstChar%z
		if(firstChar = ";" || firstChar = "") {
			; MsgBox, Comment or blank, ignoring!
			
		; Special row for modifying the current stringmod.
		} else if(firstChar = "[") {
			; MsgBox, Modifier line: %currRow%
			currMods := updateModifierString(currMods, currRow)
		
		; Your everyday line, the average Joe-Billy-Bob-Jacob.
		} else {
			; MsgBox, % currRow
			
			; Apply any active modifications.
			; MsgBox, Row before: %currRow% `nMods: %currMods%
			; currRow := applyMods(currRow, currMods, defaultBit)
			; MsgBox, Row after: %currRow% `nMods: %currMods%
			currItem := applyMods(currRow, currMods, defaultBit)
			
			; currItem := Object()
			; currItem[LIST_ITEM] := currRow
			; currItem[LIST_NUM] := 0
			; itemLen := 
			; currItem[LIST_ITEM] := currRowSplit[
			; currItem[LIST_NUM] := 0
			list.Insert(currItem)
		}
		
		; ; A true line to eventually things to! Yay!
		; } else {
			; ; MsgBox, Pre: %currPrepend%z `nPost: %currPostpend%
		
			; ; Clean lineArr2 in case it isn't in next line.
			; lineArr2 := 0
			
			; ; MsgBox, %cleanLine%
			; StringSplit, lineArr, cleanLine, %A_Tab%
			
			; currLine := expandLine(lineArr1, currPrepend, currPostpend)
			; whichNum := lineArr2
			
			; ; MsgBox, Pre: `n%currPrepend% `n`nPost: `n%currPostpend% `n`nIn: `n%cleanLine% `n`nOut: `n%currLine% `n`nNum: `n%whichNum%
			; ; MsgBox, Found: `n%prevSearch% `n`nNext: `n%currLine%
			
			; currItem := Object()
			; currItem[LIST_ITEM] := currLine
			; currItem[LIST_NUM] := whichNum
			; list.Insert(currItem)
			
			; prevSearch := currLine
		; }
		
	}
	
	return list
}

; Update the given modifier string given the new one.
updateModifierString(current, new) {
	; MsgBox, Current: %current% `nNew: %new%
	
	; If it's just [], all previous mods are wiped clean.
	if(new = "[]") {
		return "[]"
	} else {
		if(current = "[]") {
			return new
		} else {
			StringTrimRight, current, current, 1
			StringTrimLeft, new, new, 1
			return current . "|" . new
		}
	}
}

; Apply given string modifications to given row.
applyMods(row, mods, defaultBit = 1) {
	; MsgBox, Modification to apply: %mods% `nOn String: %row%
	whichBit := defaultBit
	
	; If there's no mods, we're done.
	if(mods = "[]") {
		return specialSplit(row, A_Tab)
		
	; Otherwise, we actually have work to do - time to get to work!
	} else {
		; First, strip off the beginning and ending brackets.
		StringTrimLeft, mods, mods, 1
		StringTrimRight, mods, mods, 1
		
		; Split up the mods by pipes, and the row by tabs.
		modsSplit := specialSplit(mods, "|")
		rowBits := specialSplit(row, A_Tab)
		
		; Now apply those split properties to the string.
		modsLen := modsSplit.MaxIndex()
		Loop, %modsLen% {
			; MsgBox, % modsSplit[A_Index]
			
			; Next, check if we're dealing with anything but the first bit of the given row.
			firstChar := SubStr(modsSplit[A_Index], 1, 1)
			; MsgBox, First char: %firstChar%
			if(firstChar = "{") {
				whichBit := SubStr(modsSplit[A_Index], 2, InStr(modsSplit[A_Index], "}") - 2)
				currRow := rowBits[whichBit]
				; MsgBox, Full Row: %row% `nWhich Bit: %whichBit% `nRow bit: %currRow%
			}
			
			
			; Beginning: prepend.
			if(firstChar = "b") {
				rowBits[whichBit] := SubStr(modsSplit[A_Index], 3) . rowBits[whichBit]
			
			; End: postpend.
			} else if(firstChar = "e") {
				rowBits[whichBit] := rowBits[whichBit] . SubStr(modsSplit[A_Index], 3)
			
			; Middle: insert/delete somewhere else.
			} else {
				; Assuming form: m:(x, y)abc
				;	x: +/- number, indicates where to start and from which direction to count it.
				;	y: +/- number, indicates which direction and how far to delete before inserting.
				;		Optional if abc present.
				;	abc is the text to insert at the point given after deleting any specified ranges. 
				;		Optional if y present.
				currentMod := SubStr(modsSplit[A_Index], 3)
				
				modLen := StrLen(currentMod)
				commaPos := InStr(currentMod, ",")
				closeParenPos := InStr(currentMod, ")")
				
				; Snag the given information.
				insertString := SubStr(currentMod, closeParenPos + 1)
				if(commaPos) {
					startPos := SubStr(currentMod, 2, commaPos - 2)
					deleteLen := SubStr(currentMod, commaPos + 1, closeParenPos - (commaPos + 1))
				} else {
					startPos := SubStr(currentMod, 2, closeParenPos - 2)
					deleteLen := 0
				}
				
				; MsgBox, Mod: %currentMod% `nModLen: %modLen% `nComma: %commaPos% `nCloseParenPos: %closeParenPos% `nStart: %startPos% `nLength: %deleteLen% `nInsert: %insertString%
				
				; Do the operation on the given row.
				
				; Delete the range where we're supposed to (if we are), and shove the given string in the space.
				if(deleteLen > 0) {
					rowBits[whichBit] := SubStr(rowBits[whichBit], 1, startPos) . insertString . SubStr(rowBits[whichBit], startPos + deleteLen + 1)
				} else if(deleteLen < 0) {
					rowBits[whichBit] := SubStr(rowBits[whichBit], 1, startPos + deleteLen) . insertString . SubStr(rowBits[whichBit], startPos + 1)
				}
			}
			
			; currRow := rowBits[whichBit]
			; MsgBox, Row now: %currRow%
		}
		
		; MsgBox, Row bit finished: %rowBits[whichBit]%
		
		return rowBits
		
		; ; Piece row back together now.
		; row := ""
		; rowBitLen := rowBits.MaxIndex()
		; Loop, %rowBitLen% {
			; row .= rowBits[A_Index]
			; if(A_Index != rowBitLen) {
				; row .= A_Tab
			; }
		; }
		
		; return row
	}
}

; Splits a string on given delimeter, but ignores escaped delimeters.
specialSplit(string, delimeter, escapeChar = "\") {
	outArr := Object()
	escapeNext := false
	currStr := ""
	
	; MsgBox, Splitting string: %string%
	
	; Loop, one character at a time.
	Loop, Parse, string
	{
		; MsgBox, % A_LoopField
		
		; If the last character was the escape character, replace this escaped sequence with the real thing.
		if(escapeNext) {
			; Reset this.
			escapeNext := false
			
			; Escaped character becomes what it was previously, sans slash.
			currStr .= A_LoopField
		
		; The next character is escaped, so we won't add this one in.
		} else if(A_LoopField = escapeChar) {
			escapeNext := true
		
		; Stick this group into the array, move onto the next.
		} else if(A_LoopField = delimeter) {
			; MsgBox, Current string going in: %currStr%
			outArr.Insert(currStr)
			currStr := ""
		
		; Normal case.
		} else {
			currStr .= A_LoopField
		}
	}
	
	; Shove the last string in there, too.
	outArr.Insert(currStr)
	
	return outArr
}

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