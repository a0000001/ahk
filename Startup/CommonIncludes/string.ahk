; String manipulation functions.

; Constants.
global LIST_ESC_CHAR := 1
global LIST_PASS_ROW_CHAR := 2
global LIST_COMMENT_CHAR := 3
global LIST_PRE_CHAR := 4
global LIST_ADD_MOD_LABEL_CHAR := 5
global LIST_REMOVE_MOD_LABEL_CHAR := 6
global LIST_IGNORE_MOD_CHAR := 7

; Default chars.
global LIST_DEFAULT_ESC_CHAR := "\"
global LIST_DEFAULT_PASS_ROW_CHAR := "#"
global LIST_DEFAULT_COMMENT_CHAR := ";"
global LIST_DEFAULT_PRE_CHAR := "*"
global LIST_DEFAULT_ADD_MOD_LABEL_CHAR := "+"
global LIST_DEFAULT_REMOVE_MOD_LABEL_CHAR := "-"
global LIST_DEFAULT_IGNORE_MOD_CHAR := "/"

; Modification class for parsing lists.
class TableListMod {
	; debugOn := true
	debugNoRecurse := true
	
	mod := ""
	bit := 1
	start := 1
	len := 0
	text := ""
	label := 0
	
	debugName := "Hi. This is mah name."
	
	; __New(m, b, s, l, t, a) {
	__New(m, s, l, t, a) {
		this.mod := m
		; this.bit := b
		this.start := s
		this.len := l
		this.text := t
		this.label := a
	}
	
	; Actually do what this mod describes to the given row.
	executeMod(rowBits) {
		rowBit := rowBits[this.bit]
		
		; MsgBox, % "Modification to apply: " this.mod "`nOn String: " rowBit
		DEBUG.popupV(this.debugOn, this.mod, "Mod to apply:", rowBit, "On String:", rowBits, "")
		
		rowBitLen := StrLen(rowBit)
		
		startOffset := endOffset := 0
		if(this.len > 0) {
			endOffset := this.len
		} else if(this.len < 0) {
			startOffset := this.len
		}
		
		if(this.start > 0) {
			startLen := this.start - 1
		} else if(this.start < 0) {
			startLen := rowBitLen + this.start + 1
		} else {
			startLen := rowBitLen // 2
		}
		
		; MsgBox, % startLen " " startOffset " " startLen + 1 " " endOffset
		outBit := SubStr(rowBit, 1, startLen + startOffset) . this.text . SubStr(rowBit, (startLen + 1) + endOffset)
		; MsgBox, % "Row bit now: " . outBit
		
		; Put the bit back into the full row.
		rowBits[this.bit] := outBit
		
		return rowBits
	}
	
	toDebugString() {
		return "Mod: " this.mod "`nBit: " this.bit "`nStart: " this.start "`nLength: " this.len "`nText: " this.text "`nLabel: " this.label
	}
}

; Generic custom class for parsing lists.
class TableList {
	; static debugOn := true
	
	static whiteSpaceChars := [A_Space, A_Tab]
	
	__New(lines, chars = "") {
		this.init(lines, chars)
	}
	
	init(lines, char = "") {
		; Load any given chars.
		this.escChar := chars[LIST_ESC_CHAR] ? chars[LIST_ESC_CHAR] : LIST_DEFAULT_ESC_CHAR
		this.passChar := chars[LIST_PASS_ROW_CHAR] ? chars[LIST_PASS_ROW_CHAR] : LIST_DEFAULT_PASS_ROW_CHAR
		this.commentChar := chars[LIST_COMMENT_CHAR] ? chars[LIST_COMMENT_CHAR] : LIST_DEFAULT_COMMENT_CHAR
		this.preChar := chars[LIST_PRE_CHAR] ? chars[LIST_PRE_CHAR] : LIST_DEFAULT_PRE_CHAR
		this.addChar := chars[LIST_ADD_MOD_LABEL_CHAR] ? chars[LIST_ADD_MOD_LABEL_CHAR] : LIST_DEFAULT_ADD_MOD_LABEL_CHAR
		this.remChar := chars[LIST_REMOVE_MOD_LABEL_CHAR] ? chars[LIST_REMOVE_MOD_LABEL_CHAR] : LIST_DEFAULT_REMOVE_MOD_LABEL_CHAR
		this.ignoreModChar := chars[LIST_IGNORE_MOD_CHAR] ? chars[LIST_IGNORE_MOD_CHAR] : LIST_DEFAULT_IGNORE_MOD_CHAR
		
		; Initialize the objects.
		this.mods := Object()
		this.table := Object()
	}
	
	parseList(lines, chars = "") {
		this.init(lines, chars)
		
		currItem := Object()
		
		; Loop through and do work on them.
		For i,row in lines {
			; Strip off any leading whitespace.
			Loop {
				firstChar := SubStr(row, 1, 1)
				; MsgBox, First char: z%firstChar%z
			
				if(!contains(TableList.whiteSpaceChars, firstChar)) {
					; MsgBox, Break
					Break
				}
				; MsgBox, trimming: z%row%z
				StringTrimLeft, row, row, 1
				; MsgBox, trimmed: z%row%z
			}
			
			; Ignore it entirely if it's an empty line or beings with ; (a comment).
			firstChar := SubStr(row, 1, 1)
			; MsgBox, First char: z%firstChar%z
			if(firstChar = this.commentChar || firstChar = "") {
				; MsgBox, Comment or blank, ignoring!
				
			; Special row for modifying the current mod.
			} else if(firstChar = "[") {
				; MsgBox, Modifier line: %row%
				; updateMods(this.mods, row, escChar, preChar, postChar, addChar, remChar, defaultBit)
				; updateMods(this.mods, row, escChar, preChar, addChar, remChar, defaultBit)
				this.updateMods(row)
			
			; Special row for label/title later on, leave it unmolested.
			} else if(firstChar = this.passChar) {
				; MsgBox, Hash line: %row%
				currItem := Object()
				currItem.Insert(row)
				this.table.Insert(currItem)
			
			; Your everyday line, the average Joe-Billy-Bob-Jacob.
			} else {
				; MsgBox, % row
				
				; Apply any active modifications.
				; MsgBox, Row before: %row% `nMods: %currMods%
				currItem := this.applyMods(row)
				; MsgBox, % "Row after: " . row[1] . " " . row[2] . " " . row[3]
				
				this.table.Insert(currItem)
			}
			
		}
		
		return this.table
	}

	; Kill mods with the given label.
	killMods(killLabel = 0) {
		; MsgBox, Killing mods with label: %killLabel%
		
		i := 1
		modsLen := this.mods.MaxIndex()
		Loop, %modsLen% {
			if(this.mods[i].label = killLabel) {
				; MsgBox, % "Removing mod: " mods[i].mod
				this.mods.Remove(i)
				i--
			}
			i++
		}
	}

	; Update the given modifier string given the new one.
	; updateMods(ByRef mods, new, escChar, preChar, postChar, addChar, remChar, defaultBit = 1) {
	; updateMods(ByRef mods, new, escChar, preChar, addChar, remChar, defaultBit = 1) {
	updateMods(newRow) {
		; MsgBox, % "`nCur Mods: `n`n" mods[1].toDebugString() "`n`n" mods[2].toDebugString() "`n`n" mods[3].toDebugString() "`n`n" mods[4].toDebugString() "`n`n" mods[5].toDebugString() "`n`n"
		; MsgBox, New Mod: %newRow%
		DEBUG.popup(newRow, "New Mod:", this.debugOn)
		
		label := 0
		
		; Strip off the square brackets.
		newRow := SubStr(newRow, 2, -1)
		
		; If it's just blank, all previous mods are wiped clean.
		if(newRow = "") {
			this.mods := Object()
		} else {
			; Check for a remove row label.
			; Assuming here that it will be the first and only thing in the mod row.
			if(SubStr(newRow, 1, 1) = this.remChar) {
				remLabel := SubStr(newRow, 2)
				; MsgBox, % "Remove Label: " remLabel
				this.killMods(remLabel)
				label := 0
				
				return
			}
			
			; Split new into individual mods.
			newModsSplit := specialSplit(newRow, "|", this.escChar)
			DEBUG.popup(newModsSplit, "Modline Split", this.debugOn)
			For i,currMod in newModsSplit {
				firstChar := SubStr(currMod, 1, 1)
				; MsgBox, First char in mod line: %firstChar%
				
				; Check for an add row label.
				if(i = 1 && firstChar = this.addChar) {
					label := SubStr(currMod, 2)
					; MsgBox, % "Add Label: " label
				} else {
					; Allow backwards stacking - that is, a later mod can go first in mod order.
					if(firstChar = this.preChar) {
						DEBUG.popup(currMod, "Pre-Mod:", this.debugOn)
						newMod := this.parseModLine(SubStr(currMod, 2), label)
						this.mods := insertFront(this.mods, newMod)
					} else {
						newMod := this.parseModLine(currMod, label)
						this.mods.Insert(newMod)
					}
				}
				
				DEBUG.popup(this.mods, "Current Mods", this.debugOn)
			}
		}
	}

	; Takes a modifier string and spits out the mod object/array. Assumes no [] around it, and no special chars at start.
	parseModLine(modLine, label = 0) {
		; MsgBox, ModLine: %modLine%
		currMod := new TableListMod(modLine, 1, 0, "", label)
		
		; Next, check to see whether we have an explicit bit. Syntax: starts with {#}
		firstChar := SubStr(modLine, 1, 1)
		if(firstChar = "{") {
			closeCurlyPos := InStr(modLine, "}")
			currMod.bit := SubStr(modLine, 2, closeCurlyPos - 2)

			; MsgBox, % "Which Bit: " . currMod.bit
			
			modLine := SubStr(modLine, closeCurlyPos + 1)
			; MsgBox, % "Trimmed current currMod: " . modLine
		}
		
		; First character of remaining string indicates what sort of operation we're dealing with: b, e, or m.
		op := Substr(modLine, 1, 1)
		if(op = "b") {
			currMod.start := 1
		} else if(op = "e") {
			currMod.start := -1
		}
		
		; Shave that off too.
		StringTrimLeft, modLine, modLine, 2
		
		; Figure out the rest of the innards: parentheses and string.
		commaPos := InStr(modLine, ",")
		closeParenPos := InStr(modLine, ")")
		
		; Snag the rest of the info.
		if(SubStr(modLine, 1, 1) = "(") {
			currMod.text := SubStr(modLine, closeParenPos + 1)
				if(commaPos) { ; m: operation, two arguments in parens.
					currMod.start := SubStr(modLine, 2, commaPos - 2)
					currMod.len := SubStr(modLine, commaPos + 1, closeParenPos - (commaPos + 1))
				} else {
					if(op = "m") {
						currMod.start := SubStr(modLine, 2, closeParenPos - 2)
						currMod.len := 0
					} else {
						currMod.len := SubStr(modLine, 2, closeParenPos - 2)
					}
				}
		} else {
			currMod.text := modLine
		}
		
		; MsgBox, % "Mod: " modLine "`nComma: " commaPos "`nCloseParenPos: " closeParenPos "`nStart: " currMod.start "`nLength: " currMod.len "`nInsert: " currMod.text "`nLabel: " currMod.label
		; MsgBox, % currMod.toDebugString()
		
		return currMod
	}

	; Apply currently active string modifications to given row.
	applyMods(row) {
		; MsgBox, Row to apply mods to: %row%
		
		; Split up the row by tabs.
		rowBits := specialSplit(row, A_Tab, this.escChar)
		; debugPrint(rowBits)
		
		; If there aren't any mods, just split the row and send it on.
		if(this.mods.MaxIndex() = "") {
			return rowBits
			
		; Otherwise, we actually have work to do - time to get to work!
		} else {
			; Apply the mods.
			For i,currMod in this.mods {
				; debugPrint(rowBits)
				; debugPrint(currMod.mod)
				rowBits := currMod.executeMod(rowBits)
				; debugPrint(rowBits)
				; whichBit := currMod.bit
				; ; MsgBox, % "Mod: " currMod.mod "`nWhichBit: " currMod.bit "`nRowBit: " rowBits[whichBit]
				; rowBits[whichBit] := this.doMod(rowBits[whichBit], currMod)
			}
			
			; MsgBox, % "Row bit finished: " rowBits[whichBit]
			return rowBits
		}
	}
}

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
specialSplit(string, delimeter, escChar = "\x", placeholderChar = "x") {
	; Can't put a global as a true default, so making do here.
	if(escChar = "\x") {
		escChar := LIST_DEFAULT_ESC_CHAR
	}
	
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
			if(A_LoopField != placeholderChar) {
				; Escaped character becomes what it was previously, sans slash.
				currStr .= A_LoopField
			}
		
		; The next character is escaped, so we won't add this one in.
		} else if(A_LoopField = escChar) {
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

; ; Parses and cleans the given list into single-line items.
; ; Character positions:
; ;		Escape
; ;		Pass Row
; ;		Comment
; ;		Pre
; ;		Add Mod
; ;		Remove Mod
; cleanParseList(lines, chars = "", defaultBit = 1) {
	; ; Load any given chars.
	; escChar := chars[LIST_ESC_CHAR] ? chars[LIST_ESC_CHAR] : LIST_DEFAULT_ESC_CHAR
	; passChar := chars[LIST_PASS_ROW_CHAR] ? chars[LIST_PASS_ROW_CHAR] : LIST_DEFAULT_PASS_ROW_CHAR
	; commentChar := chars[LIST_COMMENT_CHAR] ? chars[LIST_COMMENT_CHAR] : LIST_DEFAULT_COMMENT_CHAR
	; preChar := chars[LIST_PRE_CHAR] ? chars[LIST_PRE_CHAR] : LIST_DEFAULT_PRE_CHAR
	; ; postChar := chars[LIST_POST_CHAR] ? chars[LIST_POST_CHAR] : LIST_DEFAULT_POST_CHAR
	; addChar := chars[LIST_ADD_MOD_LABEL_CHAR] ? chars[LIST_ADD_MOD_LABEL_CHAR] : LIST_DEFAULT_ADD_MOD_LABEL_CHAR
	; remChar := chars[LIST_REMOVE_MOD_LABEL_CHAR] ? chars[LIST_REMOVE_MOD_LABEL_CHAR] : LIST_DEFAULT_REMOVE_MOD_LABEL_CHAR
	
	; ; Initialize the objects.
	; mods := Object()
	; list := Object()
	; currItem := Object()
	
	; ; Loop through and do work on them.
	; For i,row in lines {
		; ; Strip off any leading whitespace.
		; Loop {
			; firstChar := SubStr(row, 1, 1)
			; ; MsgBox, First char: z%firstChar%z
		
			; if(firstChar != A_Tab && firstChar != A_Space) {
				; ; MsgBox, Break
				; Break
			; }
			; ; MsgBox, trimming
			; StringTrimLeft, row, row, 1
			; ; MsgBox, trimmed: z%row%z
		; }
		
		; ; Ignore it entirely if it's an empty line or beings with ; (a comment).
		; firstChar := SubStr(row, 1, 1)
		; ; MsgBox, First char: z%firstChar%z
		; if(firstChar = commentChar || firstChar = "") {
			; ; MsgBox, Comment or blank, ignoring!
			
		; ; Special row for modifying the current stringmod.
		; } else if(firstChar = "[") {
			; ; MsgBox, Modifier line: %row%
			; ; updateMods(mods, row, escChar, preChar, postChar, addChar, remChar, defaultBit)
			; updateMods(mods, row, escChar, preChar, addChar, remChar, defaultBit)
		
		; ; Special row for label/title later on, leave it unmolested.
		; } else if(firstChar = passChar) {
			; ; MsgBox, Hash line: %row%
			; currItem := Object()
			; currItem.Insert(row)
			; list.Insert(currItem)
		
		; ; Your everyday line, the average Joe-Billy-Bob-Jacob.
		; } else {
			; ; MsgBox, % row
			
			; ; Apply any active modifications.
			; ; MsgBox, Row before: %row% `nMods: %currMods%
			; currItem := applyMods(row, mods, escChar)
			; ; MsgBox, % "Row after: " . row[1] . " " . row[2] . " " . row[3]
			
			; list.Insert(currItem)
		; }
		
	; }
	
	; return list
; }

; ; Kill mods with the given label.
; killMods(ByRef mods, killLabel = 0) {
	; ; MsgBox, Killing mods with label: %killLabel%
	
	; i := 1
	; modsLen := mods.MaxIndex()
	; Loop, %modsLen% {
		; if(mods[i].label = killLabel) {
			; ; MsgBox, % "Removing mod: " mods[i].mod
			; mods.Remove(i)
			; i--
		; }
		; i++
	; }
; }

; ; Update the given modifier string given the new one.
; ; updateMods(ByRef mods, new, escChar, preChar, postChar, addChar, remChar, defaultBit = 1) {
; updateMods(ByRef mods, new, escChar, preChar, addChar, remChar, defaultBit = 1) {
	; ; MsgBox, % "`nCur Mods: `n`n" mods[1].toDebugString() "`n`n" mods[2].toDebugString() "`n`n" mods[3].toDebugString() "`n`n" mods[4].toDebugString() "`n`n" mods[5].toDebugString() "`n`n"
	; ; MsgBox, New Mod: %new%
	
	; label := 0
	
	; ; Strip off the square brackets.
	; new := SubStr(new, 2, -1)
	
	; ; If it's just blank, all previous mods are wiped clean.
	; if(new = "") {
		; mods := Object()
	; } else {
		; ; Check for an remove row label.
		; if(SubStr(new, 1, 1) = remChar) {
			; remLabel := SubStr(new, 2)
			; ; MsgBox, % "Remove Label: " remLabel
			; killMods(mods, remLabel)
			; label := 0
			
			; return
		; }
		
		; ; Split new into individual mods.
		; newSplit := specialSplit(new, "|", escChar)
		; For i,currMod in newSplit {
			; firstChar := SubStr(currMod, 1, 1)
			; ; MsgBox, First char in mod line: %firstChar%
			
			; ; Check for an add row label.
			; if(i = 1 && firstChar = addChar) {
				; label := SubStr(currMod, 2)
				; ; MsgBox, % "Add Label: " label
			; } else {
				; ; Allow backwards stacking - that is, a later mod can go first in mod order.
				; if(firstChar = preChar) {
					; insertFront(mods, parseModLine(SubStr(currMod, 2), label, defaultBit))
				; ; } else if(firstChar = postChar) {
					; ; insertFront(mods, parseModLine(SubStr(currMod, 2), label, defaultBit))
				; } else {
					; mods.Insert(parseModLine(currMod, label, defaultBit))
				; }
			; }
		; }
	; }
; }

; ; Takes a modifier string and spits out the mod object/array. Assumes no [] around it, and no pre/post chars at start.
; parseModLine(modLine, label = 0, defaultBit = 1) {
	; ; MsgBox, ModLine: %modLine%
	; mod := new TableListMod(modLine, defaultBit, 1, 0, "", label)
	
	; ; Next, check to see whether we have an explicit bit. Syntax: starts with {#}
	; firstChar := SubStr(modLine, 1, 1)
	; if(firstChar = "{") {
		; closeCurlyPos := InStr(modLine, "}")
		; mod.bit := SubStr(modLine, 2, closeCurlyPos - 2)
		; ; MsgBox, % "Which Bit: " . mod.bit
		
		; modLine := SubStr(modLine, closeCurlyPos + 1)
		; ; MsgBox, % "Trimmed current mod: " . modLine
	; }
	
	; ; First character of remaining string indicates what sort of operation we're dealing with: b, e, or m.
	; op := Substr(modLine, 1, 1)
	; if(op = "b") {
		; mod.start := 1
	; } else if(op = "e") {
		; mod.start := -1
	; }
	
	; ; Shave that off too.
	; StringTrimLeft, modLine, modLine, 2
	
	; ; Figure out the rest of the innards: parentheses and string.
	; commaPos := InStr(modLine, ",")
	; closeParenPos := InStr(modLine, ")")
	
	; ; Snag the rest of the info.
	; if(SubStr(modLine, 1, 1) = "(") {
		; mod.text := SubStr(modLine, closeParenPos + 1)
			; if(commaPos) { ; m: operation, two arguments in parens.
				; mod.start := SubStr(modLine, 2, commaPos - 2)
				; mod.len := SubStr(modLine, commaPos + 1, closeParenPos - (commaPos + 1))
			; } else {
				; if(op = "m") {
					; mod.start := SubStr(modLine, 2, closeParenPos - 2)
					; mod.len := 0
				; } else {
					; mod.len := SubStr(modLine, 2, closeParenPos - 2)
				; }
			; }
	; } else {
		; mod.text := modLine
	; }
	
	; ; MsgBox, % "Mod: " modLine "`nComma: " commaPos "`nCloseParenPos: " closeParenPos "`nStart: " mod.start "`nLength: " mod.len "`nInsert: " mod.text "`nLabel: " mod.label
	; ; MsgBox, % mod.toDebugString()
	
	; return mod
; }

; ; Apply given string modifications to given row.
; applyMods(row, mods, escChar) {
	; ; MsgBox, Row to apply mods to: %row%
	
	; ; Split up the row by tabs.
	; rowBits := specialSplit(row, A_Tab, escChar)
	; ; MsgBox, % rowBits[1] "`n" rowBits[2]
	
	; ; If there aren't any mods, just split the row and send it on.
	; if(mods.MaxIndex() = "") {
		; return rowBits
		
	; ; Otherwise, we actually have work to do - time to get to work!
	; } else {
		; ; Apply the mods.
		; For i,currMod in mods {
			; whichBit := currMod.bit
			; ; MsgBox, % "Mod: " currMod.mod "`nWhichBit: " currMod.bit "`nRowBit: " rowBits[whichBit]
			; rowBits[whichBit] := doMod(rowBits[whichBit], currMod)
		; }
		
		; ; MsgBox, % "Row bit finished: " rowBits[whichBit]
		; return rowBits
	; }
; }

; ; Apply a single mod to the given bit of a row.
; doMod(rowBit, mod) {
	; ; MsgBox, % "Modification to apply: " mod.mod "`nOn String: " rowBit
	
	; rowBitLen := StrLen(rowBit)
	
	; startOffset := endOffset := 0
	; if(mod.len > 0) {
		; endOffset := mod.len
	; } else if(mod.len < 0) {
		; startOffset := mod.len
	; }
	
	; if(mod.start > 0) {
		; startLen := mod.start - 1
	; } else if(mod.start < 0) {
		; startLen := rowBitLen + mod.start + 1
	; } else {
		; startLen := rowBitLen // 2
	; }
	
	; ; MsgBox, % startLen " " startOffset " " startLen + 1 " " endOffset
	; outRow := SubStr(rowBit, 1, startLen + startOffset) . mod.text . SubStr(rowBit, (startLen + 1) + endOffset)
	; ; MsgBox, % "Row bit now: " . outRow
	
	; return outRow
; }

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
	
	; MsgBox, % input " x " nums " x " len
	
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
	; MsgBox % lines " " height
	
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