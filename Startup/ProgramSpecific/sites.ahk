; Sites to open with a global hotkey.

^+!a::
	sites := Object()
	if(borgWhichMachine = THINKPAD) {	
		sites.Insert("https://mail.google.com/")
		sites.Insert("http://www.facebook.com/")
		sites.Insert("http://www.reddit.com/")
		sites.Insert("http://cloud.feedly.com/#my")
	} else if(borgWhichMachine = EPIC_DESKTOP) {
		sites.Insert("https://mail.google.com/")
		sites.Insert("http://www.facebook.com/")
		sites.Insert("http://cloud.feedly.com/#my")
	}
	
	sitesLen := sites.MaxIndex()
	Loop, %sitesLen% {
		Run, % sites[A_Index]
		Sleep, 100
	}
	sitesLen--
	
	Send, {Ctrl Down}{Shift Down}
	Send, {Tab %sitesLen%}
	Send, {Shift Up}{Ctrl Up}
return