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
	Send, !hy
return
^+[::
	Send, !ho
return
^+]::
	Send, !hs
return
^d::
	Send, !hd
return
	
#ifWinActive