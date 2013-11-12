; Data-structure-related functions.

; Inserts an item at the beginning of an array.
insertFront(ByRef arr, new) {
	arr2 := Object()
	arr2.Insert(new)
	
	arrLen := arr.MaxIndex()
	Loop, %arrLen% {
		arr2.Insert(arr[A_Index])
	}
	
	arr := arr2
}