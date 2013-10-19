setupTrayIcons(v, m) {
	global vars, mapping
	
	vars := v
	mapping := m
	
	Menu, Tray, Icon, , , 1 ; Keep suspend from changing it to the AHK default.
	
	updateTrayIcon()
}

getValuesFromNames(names) {
	values := Object()
	
	namesLen := names.MaxIndex() + 1
	Loop, %namesLen% {
		currName := names[A_Index - 1]
		currVal := %currName%
		values[A_Index - 1] := currVal
		
		; MsgBox, %currName% %currVal%
	}
	
	return values
}

; UpdateIcon:
updateTrayIcon() {
	global vars, mapping
	
	values := getValuesFromNames(vars)
	
	; MsgBox, % values[0]
	; MsgBox, % values[1]
	; MsgBox, % values[2]
	
	temp := mapping
	while(temp.HasKey(0)) {
		temp := temp[values[A_Index - 1]]
		; MsgBox, % A_Index-1 " x " values[A_Index-1] " x " vars[A_Index - 1] " x " names[A_Index - 1] " x " temp
	}
	; MsgBox, %temp%
	
	Menu, Tray, Icon, % temp
}