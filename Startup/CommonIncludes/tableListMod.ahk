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