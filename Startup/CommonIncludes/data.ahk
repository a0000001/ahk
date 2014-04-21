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

; Reverse array contains function - checks if any of array strings are in given string.
containsAnyOf(haystack, needles, match = 1) { ; match = CONTAINS_ANY
	For i, el in needles {
		
		if(match = CONTAINS_ANY) {
			if(stringContains(haystack, el))
				return i
		
		} else if(match = CONTAINS_BEG) {
			chunk := SubStr(haystack, 1, StrLen(el))
			if(chunk = el)
				return i
		
		} else if(match = CONTAINS_END) {
			chunk := SubStr(haystack, (1 - StrLen(el)))
			if(chunk = el)
				return i
			
		} else {
			DEBUG.popup(match, "Unsupported match method")
		}
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