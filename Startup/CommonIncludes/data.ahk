; Data-structure-related functions.

; Inserts an item at the beginning of an array.
insertFront(ByRef arr, new) {
	arr2 := Object()
	arr2.Insert(new)
	; DEBUG.popup(arr2, "Array 2")
	
	arrLen := arr.MaxIndex()
	Loop, %arrLen% {
		arr2.Insert(arr[A_Index])
	}
	
	return arr2
}

; Array contains function. Returns index if it exists, assumes a numerical index starting at 1.
contains(haystack, needle, partialMatch = false) {
	; if(partialMatch)
		; DEBUG.popup(haystack, "Hay", needle, "Needle")
	
	For i, el in haystack {
		; if(partialMatch)
			; DEBUG.popup(i, "Index", el, "Element", needle, "Needle", partialMatch, "Partial", stringContains(el, needle), "Element contains needle")
		
		if( el = needle || (partialMatch && stringContains(needle, el)) )
			return i
	}
}

; Table contains function.	
tableContains(table, toFind) {
	For i,row in table {
		For j,r in row {
			; debugPrint(r)
			if(r = toFind) {
				return i
			}
		}
	}
}

; Converts decimal numbers to hex ones.
decimalToHex(var) {
	SetFormat, integer, hex
	var += 0
	SetFormat, integer, d
	return var
}

; Contained, single call for multiple equality tests.
matches(vars*) {
	varsLen := vars.MaxIndex()
	if(mod(varsLen, 2) = 1)
		return -1
	
	for i,v in vars {
		if(mod(i, 2) = 1) {
			if(v != vars[i+1])
				return false
		}
	}
	
	return true
}