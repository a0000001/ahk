; Epic-specific functions.

; If given:
;	Both:
;		Silently chooses, no popup.
;	INI only:
;		Prefixes popup.
;	Neither/num only:
;		General popup.
generateEMC2ObjectLink(edit = true, ini = "", num = "", iniPath = "emc2link.ini") {
	DEBUG.popup(DEBUG.epic, edit, "Edit", ini, "INI", num, "Num", iniPath, "INI Path")
	
	; result := Selector.select(iniPath, "POPUP", "", ini, num)
	; return
	
	if(ini && num) ; Silent choice.
		iniURL := Selector.select(iniPath, "RETURN", ini "." num)
	else if(ini && !num) ; INI only - prefix.
		iniURL := Selector.select(iniPath, "RETURN", "", ini ".")
	else if(!ini && num) ; Num only - postfix.
		iniURL := Selector.select(iniPath, "RETURN", "", "", "." num)
	else ; Generic case - nothing given yet, get it all from the user.
		iniURL := Selector.select(iniPath, "RETURN")
	
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
	clipboard := getCurrentEMC2ObjectLink(edit)
}

; Gets a link to the object currently open in EMC2.
getCurrentEMC2ObjectLink(edit = true) {
	objectName := getEMC2ObjectFromTitle(true)
		
	objectSplit := specialSplit(objectName, A_Space)
	DEBUG.popup(DEBUG.hyperspace, objectSplit, "EMC2 Object Name")
	
	; Get the link.
	link := generateEMC2ObjectLink(edit, objectSplit[1], objectSplit[2], "..\Selector\emc2link.ini")
	DEBUG.popup(DEBUG.hyperspace, link, "Generated Link")
	
	return link
}

; Gets the info for the object open in EMC2 from the title of the window.
getEMC2ObjectFromTitle(includeINI = false) {
	WinGetTitle, title
	DEBUG.popup(DEBUG.hyperspace, title, "Title", includeINI, "Include INI")
	
	; If the title doesn't have a number, we shouldn't be returning anything.
	if(title = "EMC2")
		return ""
	
	titleSplit := specialSplit(title, " - ")
	DEBUG.popup(DEBUG.hyperspace, titleSplit, "Title split")
	if(includeINI)
		return titleSplit[1]
	
	objectNameSplit := specialSplit(titleSplit[1], A_Space)
	DEBUG.popup(DEBUG.hyperspace, objectNameSplit, "Object name split")
	return objectNameSplit[2]
}