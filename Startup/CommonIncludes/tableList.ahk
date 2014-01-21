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