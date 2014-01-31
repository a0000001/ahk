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