#Include test.ahk

^d::
	a := 5
	b := 2
	
	c := a + b
	
	MsgBox, % a "`n" b "`n" c
	; MsgBox, %A_AhkPath%
return