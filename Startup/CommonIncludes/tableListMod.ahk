; Modification class for parsing lists.
class TableListMod {
	debugNoRecurse := true
	debugName := "TableListMod"
	
	mod := ""
	bit := 1
	start := 1
	len := 0
	text := ""
	label := 0
	
	__New(m, s, l, t, a) {
		this.mod := m
		this.start := s
		this.len := l
		this.text := t
		this.label := a
	}
	
	; Actually do what this mod describes to the given row.
	executeMod(rowBits) {
		rowBit := rowBits[this.bit]
		
		startOffset := endOffset := 0
		if(this.len > 0) {
			endOffset := this.len
		} else if(this.len < 0) {
			startOffset := this.len
		}
		
		rowBitLen := StrLen(rowBit)
		if(this.start > 0) {
			startLen := this.start - 1
		} else if(this.start < 0) {
			startLen := rowBitLen + this.start + 1
		} else {
			startLen := rowBitLen // 2
		}
		
		outBit := SubStr(rowBit, 1, startLen + startOffset) . this.text . SubStr(rowBit, (startLen + 1) + endOffset)
		DEBUG.popup(DEBUG.tableListMod, rowBits, "Row to apply to", this, "Mod applied", rowBit, "On row bit", outBit, "Finished bit", startLen, "Start len", startOffset, "Start offset", startLen + 1, "Start len + 1", endOffset, "End offset")
		
		; Put the bit back into the full row.
		rowBits[this.bit] := outBit
		
		return rowBits
	}
	
	toDebugString() {
		return "Mod: " this.mod "`nBit: " this.bit "`nStart: " this.start "`nLength: " this.len "`nText: " this.text "`nLabel: " this.label
	}
}