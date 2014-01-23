; Convert text to inverted.
ScrollLock::
	Send, ^c
	Sleep, 100
	
	clipSave := Clipboard
	charOut:= ""
	Loop % Strlen(Clipboard) {
		invertChar:= Substr(Clipboard, A_Index, 1)
		if invertChar is upper
			charOut:= charOut Chr(Asc(invertChar) + 32)
		else if invertChar is lower
			charOut:= charOut Chr(Asc(invertChar) - 32)
		else
			charOut:= charOut invertChar
	}
	
	Clipboard := charOut
	Send, ^v
	Clipboard := clipSave
	clipSave := ""
return