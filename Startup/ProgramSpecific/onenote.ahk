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

; Turn link a more reasonable color (assuming selected) and pop up linkbox.
^+k::
	Send, !h
	Send, fc
	Send, {Down 7}{Right}
	Send, {Enter}
	Send, ^k
return

; Adds a new sub-bullet that won't disappear.
^+a::
	Send, {End}{Enter}{Tab}A{Backspace}
return

; Bolds the full row.
^+b::
	Send, {Home}{Shift Down}{End}{Shift Up}^b{Down}{Home}
return

#ifWinActive