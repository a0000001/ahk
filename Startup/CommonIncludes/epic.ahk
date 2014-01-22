; Epic-specific functions.

; If given:
;	Both:
;		Silently chooses, no popup.
;	INI only:
;		Prefixes popup.
;	Neither/num only:
;		General popup.
generateEMC2ObjectLink(edit = true, ini = "", num = "", iniPath = "emc2link.ini") {
	DEBUG.popupV(DEBUG.epic, edit, "Edit", ini, "INI", num, "Num", iniPath, "INI Path")
	
	if(!ini || num) ; Generic popup, silent choice if INI given.
		iniURL := Selector.select(iniPath, "RETURN", ini)
	else ; Special case - prefix it.
		iniURL := Selector.select(iniPath, "RETURN", "", ini ".")
	
	; Ditch if we don't have our needed beginning.
	if(!iniURL)
		return ""
	
	if(edit)
		return iniURL num "?action=EDIT"
	else
		return iniURL num "?action=VIEW"
}