; Row class for use in Selector.
class SelectorRow {
	rowArr := []
	name := ""
	abbr := ""
	action := ""
	userInput := ""
	dataNums := []
	data := []
	
	static debugNoRecurse := true
	
	; Constructor.
	__New(arr = "") {
	}
	
	parseArray(arr) {
		For i,a in arr
			this.rowArr.insert(a)
		
		; Variable access to needed pieces.
		if(Selector.nameIndex)
			this.name := this.rowArr[Selector.nameIndex]
		if(Selector.abbrevIndex)
			this.abbrev := this.rowArr[Selector.abbrevIndex]
		if(Selector.actionIndex)
			this.action := this.rowArr[Selector.actionIndex]
		if(Selector.userInputIndex)
			this.userInput := this.rowArr[Selector.userInputIndex]
		For i,j in Selector.dataIndices {
			this.data.insert(this.rowArr[j])
			this.dataNums.insert(i)
		}
	}
	
	; Deep copy function.
	clone() {
		temp := new SelectorRow()
		temp.name := this.name
		temp.abbrev := this.abbrev
		temp.action := this.action
		temp.userInput := this.userInput
		For i,d in this.dataNums {
			temp.dataNums.insert(d)
			temp.data.insert(this.data[i])
		}
		
		return temp
	}
	
	get(i) {
		if(i < 0)
			return this.rowArr[this.rowArr.MaxIndex()]
		
		return this.rowArr[i]
	}
	set(i, x) {
		if(i < 0)
			i := this.rowArr.MaxIndex()
		
		this.rowArr[i] := x
		
		; Update the special properties if needed, too.
		if(i = Selector.nameIndex) {
			this.name := x
		} else if(i = Selector.abbrevIndex) {
			this.abbrev := x
		} else if(i = Selector.actionIndex) {
			this.action := x
		} else if(i = Selector.userInputIndex) {
			this.userInput := x
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
			this.rowArr[Selector.abbrevIndex] := a
	}
	setAction(a) {
		this.action := a
		if(Selector.actionIndex)
			this.rowArr[Selector.actionIndex] := a
	}
	setUserInput(ui) {
		this.userInput := ui
		if(Selector.userInputIndex)
			this.rowArr[Selector.userInputIndex] := ui
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
		outStr .= "User Input: " this.userInput "`n"
		
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