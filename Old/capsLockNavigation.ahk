#IfWinActive, ahk_class Chrome_WidgetWin_1

; Scrolling
$*j::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}{Down}
	} else {
		Send, {Blind}j
	}
return

$*k::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}{Up}
	} else {
		Send, {Blind}k
	}
return

$*h::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}{Left}
	} else {
		Send, {Blind}h
	}
return

$*l::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}{Right}
	} else {
		Send, {Blind}l
	}
return


; Tab switching
$*o::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}^{Tab}
	} else {
		Send, {Blind}o
	}
return

$*u::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}^+{Tab}
	} else {
		Send, {Blind}u
	}
return


; Closing
$*y::
	if(getkeystate("CapsLock", "T")) {
		closeWindowSpecial(1)
	} else {
		Send, {Blind}y
	}
return


; PgUp/PgDn.
$*`;::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}{PgDn}
	} else {
		Send, {Blind}`;
	}
return

$*p::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}{PgUp}
	} else {
		Send, {Blind}p
	}
return


; Home/End.
$*[::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}{Home}
	} else {
		Send, {Blind}[
	}
return

$*]::
	if(getkeystate("CapsLock", "T")) {
		Send, {Blind}{End}
	} else {
		Send, {Blind}]
	}
return

#IfWinActive