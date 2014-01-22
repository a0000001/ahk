; Data-structure-related functions.

; Inserts an item at the beginning of an array.
insertFront(ByRef arr, new) {
	arr2 := Object()
	arr2.Insert(new)
	DEBUG.popup(DEBUG.data, arr2, "Array 2")
	
	arrLen := arr.MaxIndex()
	Loop, %arrLen% {
		arr2.Insert(arr[A_Index])
	}
	
	return arr2
}

; Array contains function. Returns index if it exists, assumes a numerical index starting at 1.
contains(haystack, needle) {
	For i, el in haystack {
		if(el = needle) {
			return i
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