#IfWinActive, ahk_class SunAwtFrame
	^Tab::Send, ^{F6}
	^+Tab::Send, ^+{F6}
#IfWinActive

#IfWinActive, ahk_class SunAwtDialog
	Tab::F6
#IfWinActive 