setupTrayIcon(iconOn, iconOff = "", varToToggle) {
	global activeTrayIcon, iconPathOn, iconPathOff
	
	iconPathOn := iconOn
	iconPathOff := iconOff
	
	; MsgBox, %iconOn% %iconOff%
	
	; Initial icon setup.
	Menu, Tray, Icon, %iconOn%
	activeTrayIcon := true
	Menu, Tray, icon, , , 1 ; Keep suspend from changing it to the AHK default.
	
	Hotkey, ~!#x, ToggleSuspend
}

; Suspend hotkey, change tray icon too.
; !#x::
toggleSuspend:
	Suspend
	global activeTrayIcon, iconPathOn, iconPathOff
	
	if(activeTrayIcon) {
		Menu, Tray, Icon, %iconPathOff%
		activeTrayIcon := false
	} else {
		Menu, Tray, Icon, %iconPathOn%
		activeTrayIcon := true
	}
return