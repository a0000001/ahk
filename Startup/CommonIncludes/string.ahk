; String manipulation functions.

global SPLIT_ESC_CHAR := 1
global SPLIT_IGNORE_CHARS := 2
global SPLIT_PLACEHOLDER_CHAR := 3

global SPLIT_DEFAULT_ESC_CHAR := "\x"
global SPLIT_DEFAULT_IGNORE_CHARS := []
global SPLIT_DEFAULT_PLACEHOLDER_CHAR := "x"

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
; Note: making default non-blank so that if blank passed in, no esc chars at all.
; specialSplit(string, delimeter, escChar = "\x", placeholderChar = "x") {
specialSplit(string, delimeter, chars = "") {
	; Process the chars array.
	escChar := chars[SPLIT_ESC_CHAR] ? chars[SPLIT_ESC_CHAR] : SPLIT_DEFAULT_ESC_CHAR
	ignoreChars := chars[SPLIT_IGNORE_CHARS] ? chars[SPLIT_IGNORE_CHARS] : SPLIT_DEFAULT_IGNORE_CHARS
	placeHolderChar := chars[SPLIT_PLACEHOLDER_CHAR] ? chars[SPLIT_PLACEHOLDER_CHAR] : SPLIT_DEFAULT_PLACEHOLDER_CHAR
	
	DEBUG.popup(debugString, chars, "Chars", escChar, "EscChar", placeholderChar, "Placeholderchar")
	
	; Can't put a global as a true default, so making do here.
	if(escChar = "\x") {
		escChar := LIST_DEFAULT_ESC_CHAR
	}
	
	outArr := Object()
	escapeNext := false
	currStr := ""
	
	DEBUG.popup(debugString, string, "String to split")
	
	; Loop, one character at a time.
	Loop, Parse, string
	{
		DEBUG.popup(debugString, A_LoopField, "Current char")
		
		; If the last character was the escape character, replace this escaped sequence with the real thing.
		if(escapeNext) {
			; Reset this.
			escapeNext := false
			
			; Special ignore: \x is treated as blank, a placeholder for the start of the string if needed.
			if(A_LoopField != placeholderChar) {
				; Escaped character becomes what it was previously, sans slash.
				currStr .= A_LoopField
			}
		
		; The next character is escaped, so we won't add this one in.
		} else if(A_LoopField = escChar) {
			escapeNext := true
			DEBUG.popup(debugString, A_LoopField, "Escape char caught")
		
		; Stick this group into the array, move onto the next.
		} else if(A_LoopField = delimeter) {
			DEBUG.popup(debugString, currStr, "Current string going in")
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
	DEBUG.popup(debugString, prepend, "Pre", input, "Input", postpend, "Post")
	return prepend . input . postpend
}

; Function to debug print an array.
arrayToDebugString(arr, depth = 1) {
	outStr := "Size: " arr.MaxIndex() "`n`n"
	
	if(depth = 1) {
		For i,a in arr {
			outStr .= a "`n"
		}
	} else if(depth = 2) {
		For i,a in arr {
			outStr .= "Item " i ":`n	"
			For j,b in a {
				outStr .= b "`n	"
			}
			outStr .= "`n"
		}
	}
	
	return outStr
}

; Phone number parsing function.
parsePhone(input) {
	nums := RegExReplace(input, "[^0-9]" , "")
	StringLen, len, nums
	
	DEBUG.popup(debugString, input, "Input", nums, "Nums", len, "Len")
	
	if(len=4) ; Old extension.
		return "7"nums
	if(len=5) ; Extension.
		return nums
	if(len=7) ; Normal?
		return nums
	if(len=8) ; I've got nothing...
		return nums
	if(len=10) ; Normal with area code.
		return "81"nums
	if(len=11) ; Normal with area code plus 1 at beginning.
		return "8"nums
	if(len=12) ; Already has everything needs, in theory.
		return nums
	return -1
}

; Gives the height of the given text.
getTextHeight(text) {
	StringReplace, text, text, `n, `n, UseErrorLevel
	lines := ErrorLevel + 1
	
	lineHeight := 17 ; play with this value
	
	height := lines * lineHeight
	DEBUG.popup(debugString, lines, "Lines", lineHeight, "Line height", height, "Height")
	
	return height
}

; Gives the specified number of tabs as a string.
getTabs(i) {
	outStr := ""
	Loop, %i%
		outStr .= "`t"
	return outStr
}

; Gives the specified number of newlines as a string.
getNewLines(i) {
	outStr := ""
	Loop, %i%
		outStr .= "`n"
	return outStr
}

; Turns all double quotes (") into double double quotes ("") or more, if second argument given.
escapeDoubleQuotes(s, num = 2) {
	replString := ""
	while(num > 0) {
		replString .= """"
		num--
	}
	
	StringReplace, s, s, ", %replString%, All		; For syntax! "
	return s
}

; Wraps each line of the array in quotes, turning any quotes already there into double double quotes.
quoteWrapArrayDouble(arr) {
	outArr := []
	
	For i,a in arr {
		outArr.insert("""" escapeDoubleQuotes(a) """")
	}
	
	return outArr
}

; Given an array of strings, put them all together.
arrayToString(arr, spacesBetween = true, preString = "", postString = "") {
	outStr := ""
	
	For i,a in arr {
		outStr .= preString a postString
		
		if(spacesBetween)
			outStr .= " "
	}
	
	; Take off the last, extraneous space.
	StringTrimRight, outStr, outStr, 1
	
	return outStr
}