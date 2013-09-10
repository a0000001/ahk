; Sets or unsets atShodor.
^+\::
	if(atShodor){
		atShodor := 0
		MsgBox, Location set: Home.
	} else {
		atShodor := 1
		MsgBox, Location set: Shodor.
	}
return

; Either allows ctrl+shift+a through unmolested, or changes it to ctrl+shift+s.
$^+a::
	if(atShodor) {
		Send, ^+s
	} else {
		Send, ^+a
	}
return