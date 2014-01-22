; Row class for use in Selector.
class SelectorRow {
	rowArr := []
	name := ""
	abbr := ""
	action := ""
	dataNums := []
	data := []
	
	static debugNoRecurse := true
	
	; Constructor.
	__New(arr = "") {
	}
	
	parseArray(arr) {
		For i,a in arr {
			; MsgBox, %"x " i "	" a
			; MsgBox, Adding to row: %a%
			this.rowArr.insert(a)
		}
		
		; Variable access to needed pieces.
		if(Selector.nameIndex)
			this.name := this.rowArr[Selector.nameIndex]
		if(Selector.abbrevIndex)
			this.abbrev := this.rowArr[Selector.abbrevIndex]
		if(Selector.actionIndex)
			this.action := this.rowArr[Selector.actionIndex]
		For i,j in Selector.dataIndices {
			; MsgBox, % this.rowArr[j]
			this.data.insert(this.rowArr[j])
			this.dataNums.insert(i)
		}
	}
	
	; Deep copy function.
	clone() {
		; MsgBox, % this.toDebugString()
		; MsgBox, % new SelectorRow(this.rowArr).toDebugString()
		; return new SelectorRow(this.rowArr)
		temp := new SelectorRow()
		temp.name := this.name
		temp.abbrev := this.abbrev
		temp.action := this.action
		For i,d in this.dataNums {
			temp.dataNums.insert(d)
			temp.data.insert(this.data[i])
		}
		
		return temp
	}
	
	get(i) {
		; MsgBox, % "Getting " i ": " rowArr[i]
		if(i < 0) {
			return this.rowArr[this.rowArr.MaxIndex()]
		}
		return this.rowArr[i]
	}
	set(i, x) {
		if(i < 0) {
			; MsgBox, % i "	" this.rowArr.MaxIndex()
			i := this.rowArr.MaxIndex()
		}
		this.rowArr[i] := x
		
		; Update the special properties if needed, too.
		; MsgBox, % i " " Selector.abbrevIndex
		if(i = Selector.nameIndex) {
			this.name := x
		} else if(i = Selector.abbrevIndex) {
			this.abbrev := x
		} else if(i = Selector.actionIndex) {
			this.action := x
		}
	}
	
	setName(n) {
		this.name := n
		if(Selector.nameIndex)
			this.rowArr[Selector.nameIndex] := n
	}
	setAbbrev(a) {
		this.abbrev := a
		if(Selector.abbrevIndex)
			this.rowArr[Selector.abbrevIndex] := n
	}
	setAction(a) {
		this.action := a
		if(Selector.actionIndex)
			this.rowArr[Selector.actionIndex] := n
	}
	
	getData(n) {
		For i,d in this.dataNums {
			if(d = n) {
				return this.data[i]
			}
		}
	}
	
	; Function to output this object as a string for debug purposes.
	toDebugString(numTabs = 0) {
		outStr := "[SelectorRow Object]`n"
		
		numTabs++
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .=	"Name: " this.name "`n"
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .= "Abbreviation: " this.abbrev "`n"
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .= "Action: " this.action "`n"
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .= "Data:`n"
		
		numTabs++
		For i,d in this.data {
			Loop, %numTabs%
				outStr .= "`t"
			outStr .= this.dataNums[i] "	" d "`n"
		}
		numTabs--
		
		Loop, %numTabs%
			outStr .= "`t"
		outStr .= "RowArr:`n"
		
		numTabs++
		
		For i,r in this.rowArr {
			Loop, %numTabs%
				outStr .= "`t"
			outStr .= i "	" r "`n"
		}
		
		return outStr "`n"
	}
}