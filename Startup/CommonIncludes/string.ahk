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
cleanParseList(lines, escapeChar = "\", defaultBit = 1) {
	currMods := "[]"
	list := Object()
	currItem := Object()
	
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
		
		; Special row for label/title later on, leave it unmolested.
		} else if(firstChar = "#") {
			; MsgBox, Hash line: %currRow%
			currItem := Object()
			currItem.Insert(currRow)
			list.Insert(currItem)
		
		; Your everyday line, the average Joe-Billy-Bob-Jacob.
		} else {
			; MsgBox, % currRow
			
			; Apply any active modifications.
			; MsgBox, Row before: %currRow% `nMods: %currMods%
			currItem := applyMods(currRow, currMods, escapeChar, defaultBit)
			; MsgBox, % "Row after: " . currRow[1] . " " . currRow[2] . " " . currRow[3] . "`nMods: " . currMods
			
			
			list.Insert(currItem)
		}
		
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
			; Allow backwards stacking - that is, a later mod can go first on string.
			if(SubStr(new, 2, 1) = "/") {
				StringTrimRight, new, new, 1
				StringTrimLeft, current, current, 1
				return "[" . SubStr(new, 3) . "|" . current
			} else {
				StringTrimRight, current, current, 1
				StringTrimLeft, new, new, 1
				return current . "|" . new
			}
		}
	}
}

; Apply given string modifications to given row.
applyMods(row, mods, escapeChar = "\", defaultBit = 1) {
	; MsgBox, Modification to apply: %mods% `nOn String: %row%
	whichBit := defaultBit
	
	; If there's no mods, we're done.
	if(mods = "[]") {
		return specialSplit(row, A_Tab, escapeChar)
		
	; Otherwise, we actually have work to do - time to get to work!
	} else {
		; First, strip off the beginning and ending brackets.
		StringTrimLeft, mods, mods, 1
		StringTrimRight, mods, mods, 1
		
		; Split up the mods by pipes, and the row by tabs.
		modsSplit := specialSplit(mods, "|", escapeChar)
		rowBits := specialSplit(row, A_Tab, escapeChar)
		
		; Now apply those split properties to the string.
		modsLen := modsSplit.MaxIndex()
		Loop, %modsLen% {
			currMod := modsSplit[A_Index]
			; MsgBox, % currMod
			
			; Next, check if we're dealing with anything but the first bit of the given row.
			firstChar := SubStr(currMod, 1, 1)
			; MsgBox, First char: %firstChar%
			if(firstChar = "{") {
				closeCurlyPos := InStr(currMod, "}")
				whichBit := SubStr(currMod, 2, closeCurlyPos - 2)
				; MsgBox, % "Full Row: " . row . "`nWhich Bit: " . whichBit . "`nRow bit: " . rowBits[whichBit]
				
				currMod := SubStr(currMod, closeCurlyPos + 1)
				; MsgBox, % "Trimmed current mod: " . currMod
				
				firstChar := SubStr(currMod, 1, 1)
			}
			
			
			; Beginning: prepend.
			if(firstChar = "b") {
				rowBits[whichBit] := SubStr(currMod, 3) . rowBits[whichBit]
			
			; End: postpend.
			} else if(firstChar = "e") {
				rowBits[whichBit] := rowBits[whichBit] . SubStr(currMod, 3)
			
			; Middle: insert/delete somewhere else.
			} else {
				; Assuming form: m:(x, y)abc
				;	x: +/- number, indicates where to start and from which direction to count it.
				;	y: +/- number, indicates which direction and how far to delete before inserting.
				;		Optional if abc present.
				;	abc is the text to insert at the point given after deleting any specified ranges. 
				;		Optional if y present.
				currMod := SubStr(currMod, 3)
				
				modLen := StrLen(currMod)
				commaPos := InStr(currMod, ",")
				closeParenPos := InStr(currMod, ")")
				
				; Snag the given information.
				insertString := SubStr(currMod, closeParenPos + 1)
				if(commaPos) {
					startPos := SubStr(currMod, 2, commaPos - 2)
					deleteLen := SubStr(currMod, commaPos + 1, closeParenPos - (commaPos + 1))
				} else {
					startPos := SubStr(currMod, 2, closeParenPos - 2)
					deleteLen := 0
				}
				
				; MsgBox, Mod: %currMod% `nModLen: %modLen% `nComma: %commaPos% `nCloseParenPos: %closeParenPos% `nStart: %startPos% `nLength: %deleteLen% `nInsert: %insertString%
				
				; Do the operation on the given row.
				
				; Delete the range where we're supposed to (if we are), and shove the given string in the space.
				if(deleteLen > 0) {
					rowBits[whichBit] := SubStr(rowBits[whichBit], 1, startPos) . insertString . SubStr(rowBits[whichBit], startPos + deleteLen + 1)
				} else if(deleteLen < 0) {
					rowBits[whichBit] := SubStr(rowBits[whichBit], 1, startPos + deleteLen) . insertString . SubStr(rowBits[whichBit], startPos + 1)
				}
			}
			
			; MsgBox, % "Row now: " . rowBits[whichBit]
		}
		
		; MsgBox, Row bit finished: %rowBits[whichBit]%
		
		return rowBits
	}
}

