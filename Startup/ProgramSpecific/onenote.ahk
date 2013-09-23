; OneNote hotkeys.
#ifWinActive, ahk_class Framework::CFrame

; Modded ctrl+tab, etc. hotkeys.
^Tab::
	Send, ^{PgDn}
return
^+Tab::
	Send, ^{PgUp}
return
^PgDn::
	Send, ^{Tab}
return
^PgUp::
	Send, ^+{Tab}
return

; New subpage, promote and demote.
^+n::
	; Send, !hy
	Send, !5
return
^+[::
	; Send, !ho
	Send, !6
return
^+]::
	; Send, !hs
	Send, !7
return
^+d::
	; Send, !hd
	Send, !8
return
	
#ifWinActive