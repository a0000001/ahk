setupTrayIcons(v, m) {
	global vars, mapping
	
	vars := v
	mapping := m
	
	Menu, Tray, Icon, , , 1 ; Keep suspend from changing it to the AHK default.
	
	updateTrayIcon()
	
	; Map it all to begin wtih.
	
	; MsgBox, % mapping[0][0]
	
	; ; Get the normal icon out of the mapping (all 0s)
	; varsLen := vars.MaxIndex()
	; ; MsgBox, % varsLen
	
	; temp := mapping[0]
	; ; MsgBox, Start: %temp%
	
	; Loop, %varsLen% {
		; temp := temp[0]
		; ; MsgBox, % A_Index "	" temp
	; }
	
	; MsgBox, Final: %temp%
	
	; ; Initial icon setup.
	; Menu, Tray, Icon, % temp
	
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
	
	
	; temp := %varName%
	; MsgBox, % temp
; }

; setupTrayIcon(iconOn, iconOff = "", varToToggle) {
	; global activeTrayIcon, iconPathOn, iconPathOff
	
	; iconPathOn := iconOn
	; iconPathOff := iconOff
	
	; ; MsgBox, %iconOn% %iconOff%
	
	
; }

; Suspend hotkey, change tray icon too.
; !#x::
; ToggleSuspend:
	
; return