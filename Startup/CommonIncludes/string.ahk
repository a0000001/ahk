; String manipulation functions.

; Strips the dollar sign/asterisk off of the front of hotkeys if it's there.
stripHotkeyString(hotkeyString, leaveDollarSign = 0, leaveStar = 0) {
	if(!leaveDollarSign && InStr(hotkeyString, "$")) {
		StringReplace, returnKey, hotkeyString, $
		return returnKey
	} else if(!leaveStar && InStr(hotkeyString, "*")) {
		StringReplace, returnKey, hotkeyString, *
		return returnKey
	} else {
		return A_ThisHotkey
	}
}

; Prepends and postpends the given strings to the given input.
expandLine(input, prepend = "", postpend = "") {
	; MsgBox, Expanding `nPre: %prepend% `nInput: %input% `nApp: %postpend%
	return prepend . input . postpend
}

; Parses and cleans the given list into single-line items.
cleanParseList(lines) {
	currPrepend := ""
	currPostpend := ""
	list := Object()
	
	; Loop through and do work on them.
	linesLen := lines.MaxIndex()
	Loop, %linesLen% {
		; Clean off leading tab if it exists.
		cleanLine := lines[A_Index]
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
				
				tempLine := lines[A_Index]
				StringSplit, params, tempLine, |
				
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
			} else if(SubStr(cleanLine, 1, 1) = "]") {
				currPrepend := ""
				currPostpend := ""
				; MsgBox, wiped.
			
			; A true line to eventually things to! Yay!
			} else {
				; MsgBox, Pre: %currPrepend%z `nPost: %currPostpend%
			
				; Clean lineArr2 in case it isn't in next line.
				lineArr2 := 0
				
				; MsgBox, %cleanLine%
				StringSplit, lineArr, cleanLine, %A_Tab%
				
				currLine := expandLine(lineArr1, currPrepend, currPostpend)
				whichNum := lineArr2
				
				; MsgBox, Pre: `n%currPrepend% `n`nPost: `n%currPostpend% `n`nIn: `n%cleanLine% `n`nOut: `n%currLine% `n`nNum: `n%whichNum%
				; MsgBox, Found: `n%prevSearch% `n`nNext: `n%currLine%
				
				currItem := Object()
				currItem[LIST_ITEM] := currLine
				currItem[LIST_NUM] := whichNum
				list.Insert(currItem)
				
				prevSearch := currLine
			}
		}
	}
	
	return list
}