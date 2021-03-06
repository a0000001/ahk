; Epic-specific functions.

; Returns true if the given number could be a DLG (pure number, or starting with I, M, or Y).
isDLGNum(num) {
	dlgLetters := ["i", "m", "y", "cs"]
	
	if(isNum(num))
		return true
	
	whichLetter := containsAnyOf(num, dlgLetters, CONTAINS_BEG)
	if(whichLetter) {
		rest := SubStr(num, StrLen(dlgLetters[whichLetter]) + 1)
		if(isNum(rest))
			return true
	}
	
	return false
}

; Generates and copies a link to the clipboard.
copyEMC2ObjectLink() {
	link := getEMC2ObjectLink()
	if(link)
		clipboard := link
}

; Generates a link from the selection or clipboard.
getEMC2ObjectLink() {
	ini := ""
	num := ""
	
	; Grab the selected text/clipboard.
	text := getSelectedText(true)
	
	; Drop any leading whitespace. (Note using = not :=)
	cleanText = %text%
	
	; Split the input.
	inputSplit := specialSplit(cleanText, A_Space)
	
	; Figure out what we've got.
	; Two parts, likely everything we need.
	if(inputSplit.MaxIndex() = 2) {
		; DEBUG.popup(inputSplit, "Input", isDLGNum(inputSplit[1]), "Is 1 DLG Num", StrLen(inputSplit[1]), "Input 1 length", isDLGNum(inputSplit[2]), "Is 2 DLG Num")
		; ini is 3 and not a number, num is a number.
		if(!isDLGNum(inputSplit[1]) && StrLen(inputSplit[1]) = 3 && isDLGNum(inputSplit[2])) {
			ini := inputSplit[1]
			num := inputSplit[2]
		}
	
	; Only one. Possible ini or num on its own.
	} else if(inputSplit.MaxIndex() = 1) {
		if(isDLGNum(inputSplit[1]))
			num := inputSplit[1]
		else if(StrLen(inputSplit[1]) = 3)
			ini := inputSplit[1]
	}
	
	; DEBUG.popup(text, "Raw input", cleanText, "Clean input", inputSplit, "Clean input split", ini, "INI", num, "Num")
	
	; Get the link.
	link := generateEMC2ObjectLink(true, ini, num, "..\Selector\emc2link.ini")
	; DEBUG.popup(link, "Generated Link")
	
	return link
}

; If given:
;	Both:
;		Silently chooses, no popup.
;	INI only:
;		Prefixes popup.
;	Neither/num only:
;		General popup.
generateEMC2ObjectLink(edit = true, ini = "", num = "", iniPath = "emc2link.ini") {
	; DEBUG.popup(edit, "Edit", ini, "INI", num, "Num", iniPath, "INI Path")
	
	; result := Selector.select(iniPath, "POPUP", "", ini, num)
	; return
	
	if(ini && num) ; Silent choice.
		iniURL := Selector.select(iniPath, "RET", ini "." num)
	else if(ini && !num) ; INI only - prefix.
		iniURL := Selector.select(iniPath, "RET", "", ini ".")
	else if(!ini && num) ; Num only - postfix.
		iniURL := Selector.select(iniPath, "RET", "", "", "." num)
	else ; Generic case - nothing given yet, get it all from the user.
		iniURL := Selector.select(iniPath, "RET")
	
	; Ditch if we don't have our needed beginning.
	if(!iniURL)
		return ""
	
	if(edit)
		return iniURL "?action=EDIT"
		; return iniURL num "?action=EDIT"
	else
		return iniURL "?action=VIEW"
		; return iniURL num "?action=VIEW"
}
	

; Copies a link to the object currently open in EMC2 to the clipboard.
copyCurrentEMC2ObjectLink(edit = true) {
	link := getCurrentEMC2ObjectLink(edit)
	if(link)
		clipboard := link
}

; Gets a link to the object currently open in EMC2.
getCurrentEMC2ObjectLink(edit = true) {
	objectName := getEMC2ObjectFromTitle(true)
		
	objectSplit := specialSplit(objectName, A_Space)
	; DEBUG.popup(objectSplit, "EMC2 Object Name")
	
	; Get the link.
	link := generateEMC2ObjectLink(edit, objectSplit[1], objectSplit[2], "..\Selector\emc2link.ini")
	; DEBUG.popup(link, "Generated Link")
	
	return link
}

; Gets the info for the object open in EMC2 from the title of the window.
getEMC2ObjectFromTitle(includeINI = false) {
	WinGetTitle, title
	; DEBUG.popup(title, "Title", includeINI, "Include INI")
	
	; If the title doesn't have a number, we shouldn't be returning anything.
	if(title = "EMC2")
		return ""
	
	titleSplit := specialSplit(title, " - ")
	; DEBUG.popup(titleSplit, "Title split")
	if(includeINI)
		return titleSplit[1]
	
	objectNameSplit := specialSplit(titleSplit[1], A_Space)
	; DEBUG.popup(objectNameSplit, "Object name split")
	return objectNameSplit[2]
}