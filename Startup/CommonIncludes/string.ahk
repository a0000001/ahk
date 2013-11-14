; String manipulation functions.

; Constants.
global LIST_MOD := 1
global LIST_BIT := 2
global LIST_START = 3
global LIST_LEN = 4
global LIST_TEXT = 5
global LIST_LABEL = 6

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
			
			; Special ignore: \x is treated as blank, a placeholder for the start of the string if needed.
			if(A_LoopField != "x") {
				; Escaped character becomes what it was previously, sans slash.
				currStr .= A_LoopField
			}
		
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
	; currMods := "[]"
	mods := Object()
	list := Object()
	currItem := Object()
	
	; MsgBox, % lines[1] . "`n" . LIST_ITEM . "`n" . iSearch_imageSpacingTolerance
	
	; Loop through and do work on them.
	linesLen := lines.MaxIndex()
	Loop, %linesLen% {
		row := lines[A_Index]
		; MsgBox, %row%
		
		; Strip off any leading whitespace.
		Loop {
			firstChar := SubStr(row, 1, 1)
			; MsgBox, First char: z%firstChar%z
		
			if(firstChar != A_Tab && firstChar != A_Space) {
				; MsgBox, Break
				Break
			}
			; MsgBox, trimming
			StringTrimLeft, row, row, 1
			; MsgBox, trimmed: z%row%z
		}
		
		; Ignore it entirely if it's an empty line or beings with ; (a comment).
		firstChar := SubStr(row, 1, 1)
		; MsgBox, First char: z%firstChar%z
		if(firstChar = ";" || firstChar = "") {
			; MsgBox, Comment or blank, ignoring!
			
		; Special row for modifying the current stringmod.
		} else if(firstChar = "[") {
			; MsgBox, Modifier line: %row%
			; currMods := updateModifierString(currMods, row)
			updateMods(mods, row, escapeChar, defaultBit)
		
		; Special row for label/title later on, leave it unmolested.
		} else if(firstChar = "#") {
			; MsgBox, Hash line: %row%
			currItem := Object()
			currItem.Insert(row)
			list.Insert(currItem)
		
		; Your everyday line, the average Joe-Billy-Bob-Jacob.
		} else {
			; MsgBox, % row
			
			; Apply any active modifications.
			; MsgBox, Row before: %row% `nMods: %currMods%
			currItem := applyMods(row, mods, escapeChar)
			; MsgBox, % "Row after: " . row[1] . " " . row[2] . " " . row[3]
			
			
			list.Insert(currItem)
		}
		
	}
	
	return list
}

; Kill mods with the given label.
killMods(ByRef mods, label = 0) {
	; MsgBox, Killing mods with label: %label%
	
	modsLen := mods.MaxIndex()
	i := 1
	Loop, %modsLen% {
		if(mods[i, LIST_LABEL] = label) {
			; MsgBox, % "Removing mod: " mods[i, LIST_MOD]
			mods.Remove(i)
			i--
		}
		i++
	}
}

; Update the given modifier string given the new one.
updateMods(ByRef mods, new, escapeChar = "\", defaultBit = 1) {
	; MsgBox, New Mod: %new%
	
	label = 0
	
	; Strip off the square brackets.
	new := SubStr(new, 2, -1)
	
	; If it's just blank, all previous mods are wiped clean.
	if(new = "") {
		mods := Object()
	} else {
		; Check for an remove row label.
		if(SubStr(new, 1, 1) = "-") {
			remLabel := SubStr(new, 2)
			; MsgBox, % "Remove Label: " remLabel
			killMods(mods, remLabel)
			label := 0
			
			return
		}
		
		; Split new into individual mods.
		newSplit := specialSplit(new, "|", escapeChar)
		newCount := newSplit.MaxIndex()
		Loop, %newCount% {
			currMod := newSplit[A_Index]
			; MsgBox, % "New split: " currMod
			
			; Check for an add row label.
			if(A_Index = 1 && SubStr(currMod, 1, 1) = "+") {
				label := SubStr(currMod, 2)
				; MsgBox, % "Add Label: " label
			} else {
				; Allow backwards stacking - that is, a later mod can go first in mod order.
				if(SubStr(currMod, 1, 1) = "/") {
					insertFront(mods, parseModLine(SubStr(currMod, 2), label, defaultBit))
				} else {
					mods.Insert(parseModLine(currMod, label, defaultBit))
				}
			}
		}
	}
}

; Takes a modifier string and spits out the mod object/array. Assumes no [] around it, and no / at start.
parseModLine(modLine, label = 0, defaultBit = 1) {
	; MsgBox, ModLine: %modLine%
	
	mod := Object()
	mod[LIST_MOD] := modLine
	mod[LIST_BIT] := defaultBit
	mod[LIST_START] := 1
	mod[LIST_LEN] := 0
	mod[LIST_TEXT] := ""
	mod[LIST_LABEL] := label
	
	; Next, check to see whether we have an explicit bit. Syntax: starts with {#}
	firstChar := SubStr(modLine, 1, 1)
	if(firstChar = "{") {
		closeCurlyPos := InStr(modLine, "}")
		mod[LIST_BIT] := SubStr(modLine, 2, closeCurlyPos - 2)
		; MsgBox, % "Which Bit: " . whichBit
		
		modLine := SubStr(modLine, closeCurlyPos + 1)
		; MsgBox, % "Trimmed current mod: " . modLine
	}
	
	; First character of remaining string indicates what sort of operation we're dealing with: b, e, or m.
	op := Substr(modLine, 1, 1)
	if(op = "b") {
		mod[LIST_START] := 1
	} else if(op = "e") {
		mod[LIST_START] := -1
	}
	
	; Shave that off too.
	StringTrimLeft, modLine, modLine, 2
	
	; Figure out the rest of the innards: parentheses and string.
	commaPos := InStr(modLine, ",")
	closeParenPos := InStr(modLine, ")")
	
	; Snag the rest of the info.
	if(SubStr(modLine, 1, 1) = "(") {
		mod[LIST_TEXT] := SubStr(modLine, closeParenPos + 1)
			if(commaPos) { ; m: operation, two arguments in parens.
				mod[LIST_START] := SubStr(modLine, 2, commaPos - 2)
				mod[LIST_LEN] := SubStr(modLine, commaPos + 1, closeParenPos - (commaPos + 1))
			} else {
				if(op = "m") {
					mod[LIST_START] := SubStr(modLine, 2, closeParenPos - 2)
					mod[LIST_LEN] := 0
				} else {
					mod[LIST_LEN] := SubStr(modLine, 2, closeParenPos - 2)
				}
			}
	} else {
		mod[LIST_TEXT] := modLine
	}
	
	; MsgBox, % "Mod: " modLine "`nComma: " commaPos "`nCloseParenPos: " closeParenPos "`nStart: " mod[LIST_START] "`nLength: " mod[LIST_LEN] "`nInsert: " mod[LIST_TEXT] "`nLabel: " mod[LIST_LABEL]
	
	return mod
}

; Apply a single mod to the given bit of a row.
doMod(rowBit, mod) {
	; MsgBox, % "Modification to apply: " mod[LIST_MOD] "`nOn String: " rowBit
	
	rowBitLen := StrLen(rowBit)
	
	startOffset := endOffset := 0
	if(mod[LIST_LEN] > 0) {
		endOffset := mod[LIST_LEN]
	} else if(mod[LIST_LEN] < 0) {
		startOffset := mod[LIST_LEN]
	}
	
	if(mod[LIST_START] > 0) {
		startLen := mod[LIST_START] - 1
	} else if(mod[LIST_START] < 0) {
		startLen := rowBitLen + mod[LIST_START] + 1
	} else {
		startLen := rowBitLen // 2
	}
	
	; MsgBox, % startLen " " startOffset " " startLen + 1 " " endOffset
	
	outRow := SubStr(rowBit, 1, startLen + startOffset) . mod[LIST_TEXT] . SubStr(rowBit, (startLen + 1) + endOffset)
	; MsgBox, % "Row bit now: " . outRow
	
	return outRow
}

; Apply given string modifications to given row.
applyMods(row, mods, escapeChar = "\") {
	; MsgBox, Row to apply mods to: %row%
	
	; Split up the row by tabs.
	rowBits := specialSplit(row, A_Tab, escapeChar)
	
	; MsgBox, % rowBits[1] "`n" rowBits[2]
	
	; If there aren't any mods, just split the row and send it on.
	if(mods.MaxIndex() = "") {
		return rowBits
		
	; Otherwise, we actually have work to do - time to get to work!
	} else {
		; Apply the mods.
		modsLen := mods.MaxIndex()
		Loop, %modsLen% {
			currMod := mods[A_Index]
			whichBit := currMod[LIST_BIT]
			
			; MsgBox, % "Mod: " currMod[LIST_MOD] "`nWhichBit: " currMod[LIST_BIT] "`nRowBit: " rowBits[whichBit]
			
			rowBits[whichBit] := doMod(rowBits[whichBit], currMod)
		}
		
		; MsgBox, % "Row bit finished: " rowBits[whichBit]
		
		return rowBits
	}
}

