setupTrayIcons() {
	; Initial icon setup.
	Menu, Tray, Icon, % mapping[0]
	Menu, Tray, icon, , , 1 ; Keep suspend from changing it to the AHK default.
	
	Hotkey, ~!#x, ToggleSuspend
}

; updateTrayIcon(vars) {
ToggleSuspend:
	Suspend
	global mapping, vars
	
	varName := % vars[0]
	varValue := !%varName%
	
	; MsgBox, Before: %varValue%
	%varName% := varValue
	; MsgBox, After: %varValue%
	
	if(varValue) {
		Menu, Tray, Icon, % mapping[varValue]
	} else {
		Menu, Tray, Icon, % mapping[varValue]
	}
return
	
	
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