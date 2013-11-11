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
			; MsgBox, escape char caught!
		
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
	
	; MsgBox, % lines[1] . "`n" . LIST_ITEM . "`n" . iSearch_imageSpacingTolerance
	
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