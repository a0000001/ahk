; Sites to open with a global hotkey.

^+!a::
	; if(borgWhichMachine = THINKPAD) {	
		howManySites := 4
		Run, https://mail.google.com/
		Sleep, 100
		Run, http://www.facebook.com/
		Sleep, 100
		Run, http://www.reddit.com/
		Sleep, 100
		Run, http://cloud.feedly.com/#latest
		Sleep, 100
	; } else if(borgWhichMachine = EPIC_DESKTOP) {
		; ; Betelgeuse
	; }
	
	howManySites--
	
	Send, {Ctrl Down}{Shift Down}
	Send, {Tab %howManySites%}
	Send, {Shift Up}{Ctrl Up}
return