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
	static whiteSpaceChars := [ A_Space, A_Tab ]
	
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
	
	parseFile(fileName, chars = "") {
		if(!fileName || !FileExist(fileName)) {
			DEBUG.popup(DEBUG.tableList, fPath, "File does not exist")
			return ""
		}
		
		; Read the file into an array.
		lines := fileLinesToArray(fileName)
		DEBUG.popup(DEBUG.tableList, fileName, "Filename", lines, "Lines from file")
		
		return this.parseList(lines, chars)
	}
	
	parseList(lines, chars = "") {
		this.init(lines, chars)
		
		currItem := Object()
		
		; Loop through and do work on them.
		For i,row in lines {
			; Strip off any leading whitespace.
			Loop {
				firstChar := SubStr(row, 1, 1)
			
				if(!contains(TableList.whiteSpaceChars, firstChar)) {
					DEBUG.popup(DEBUG.tableList, firstChar, "First not blank, moving on.")
					Break
				}
				
				if(DEBUG.tableList)
					originalRow := row
				
				StringTrimLeft, row, row, 1
				
				DEBUG.popup(DEBUG.tableList, originalRow, "Row", firstChar, "First Char", row, "Trimmed")
			}
			
			; Ignore it entirely if it's an empty line or beings with ; (a comment).
			firstChar := SubStr(row, 1, 1)
			
			if(firstChar = this.commentChar || firstChar = "") {
				DEBUG.popup(DEBUG.tableList, firstChar, "Comment or blank line")
			
			; Special row for modifying the current mod.
			} else if(firstChar = "[") {
				DEBUG.popup(DEBUG.tableList, row, "Modifier Line", firstChar, "First Char")
				this.updateMods(row)
			
			; Special row for label/title later on, leave it unmolested.
			} else if(firstChar = this.passChar) {
				DEBUG.popup(DEBUG.tableList, row, "Hash Line", firstChar, "First Char")
				currItem := Object()
				currItem.Insert(row)
				this.table.Insert(currItem)
			
			; Your everyday line, the average Joe-Billy-Bob-Jacob.
			} else {
				if(DEBUG.tableList)
					originalRow := row
				
				; Apply any active modifications.
				currItem := this.applyMods(row)
				DEBUG.popup(DEBUG.tableList, originalRow, "Normal Row", this.mods, "Current Mods", currItem, "Processed Row")
				
				this.table.Insert(currItem)
			}
			
		}
		
		return this.table
	}

	; Kill mods with the given label.
	killMods(killLabel = 0) {
		DEBUG.popup(DEBUG.tableList, killLabel, "Killing all mods with label")
		
		i := 1
		modsLen := this.mods.MaxIndex()
		Loop, %modsLen% {
			if(this.mods[i].label = killLabel) {
				DEBUG.popup(DEBUG.tableList, mods[i], "Removing Mod")
				this.mods.Remove(i)
				i--
			}
			i++
		}
	}

	; Update the given modifier string given the new one.
	updateMods(newRow) {
		DEBUG.popup(DEBUG.tableList, this.mods, "Current Mods", newRow, "New Mod")
		
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
				this.killMods(remLabel)
				label := 0
				
				return
			}
			
			; Split new into individual mods.
			newModsSplit := specialSplit(newRow, "|", [this.escChar])
			; newModsSplit := specialSplit(newRow, "|", this.escChar)
			DEBUG.popup(DEBUG.listTable, newRow, "Row", newModsSplit, "Row Split")
			For i,currMod in newModsSplit {
				firstChar := SubStr(currMod, 1, 1)
				
				; Check for an add row label.
				if(i = 1 && firstChar = this.addChar) {
					label := SubStr(currMod, 2)
					; MsgBox, % "Add Label: " label
				} else {
					; Allow backwards stacking - that is, a later mod can go first in mod order.
					if(firstChar = this.preChar) {
						if(DEBUG.listTable)
							preMod := true
						
						newMod := this.parseModLine(SubStr(currMod, 2), label)
						this.mods := insertFront(this.mods, newMod)
					} else {
						newMod := this.parseModLine(currMod, label)
						this.mods.Insert(newMod)
					}
				}
				
				DEBUG.popup(DEBUG.tableList, currMod, "Mod processed", firstChar, "First Char", label, "Label", preMod, "Premod", this.mods, "Current Mods")
			}
		}
	}

	; Takes a modifier string and spits out the mod object/array. Assumes no [] around it, and no special chars at start.
	parseModLine(modLine, label = 0) {
		if(DEBUG.tableList)
			origModLine := modLine
		
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
		
		DEBUG.popup(DEBUG.tableList, origModLine, "Mod Line", currMod, "Mod processed", commaPos, "Comma position", closeParenPos, "Close paren position")
		return currMod
	}

	; Apply currently active string modifications to given row.
	applyMods(row) {
		; Split up the row by tabs.
		rowBits := specialSplit(row, A_Tab, [this.escChar])
		; rowBits := specialSplit(row, A_Tab, this.escChar)
		
		DEBUG.popup(DEBUG.tableList, row, "Row", rowBits, "Row bits")
		if(DEBUG.tableList)
			origBits := rowBits
		
		; If there aren't any mods, just split the row and send it on.
		if(this.mods.MaxIndex() != "") {
			; Apply the mods.
			For i,currMod in this.mods {
				if(DEBUG.tableList)
					beforeBits := rowBits
				
				rowBits := currMod.executeMod(rowBits)
				
				DEBUG.popup(DEBUG.tableList, beforeBits, "Row bits", currMod, "Mod to apply", rowBits, "Processed bits")
			}
			
			DEBUG.popup(DEBUG.tableList, origBits, "Row bits", rowBits, "Finished bits")
			return rowBits
		}
		
		return rowBits
	}
}