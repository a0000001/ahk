#ifWinActive, ahk_class WindowsForms10.Window.8.app.0.2bf8098_r13_ad1

; TLG Hotkey.
^t::
	Send, 14457
return

; Better access to INTermediate code.
^+i::
	ControlSend, , ^+v
return

; Reopen recently closed file.
^+t::
	Send, !ffr{Enter}
return

; Duplicate Line.
^d::
	Send, {End}{Shift Down}{Home}{Shift Up}
	Send, ^c
	Sleep, 100
	Send, {End}{Enter}
	SendRaw, %clipboard%
	Send, {Up}{End}
return
	
; Toggle comment. 
^+c::
	Send, {End}{Shift Down}{Home}{Shift Up}
	Send, ^c
	Sleep, 100
	line := clipboard
	; MsgBox, % line
	
	; Determine if the line is currenly commented.
	commented = false
	firstChar := SubStr(line,1,1)
	
	if(firstChar = ";") {
		; MsgBox, commented!
		line := SubStr(line,2)
		if(SubStr(line,1,1) = " ") {
			line := SubStr(line,2)
		}
	} else {
		; MsgBox, not commented!
		line := "; "line
	}
	
	SendRaw, %line%
	Send, {Home}
return

^q::Send, % commentStartString

; GUI input for Chronicles Data Operation GENERATE code.
:*:`;cdo::
	Gui, Add, Text, , Type: 
	Gui, Add, Text, , Tag: 
	Gui, Add, Text, , INI: 
	Gui, Add, Text, , Lookback: 
	Gui, Add, Text, , Global: 
	Gui, Add, Text, , Items: 
	
	Gui, Add, Edit, vType x100 ym, Load
	Gui, Add, Edit, vTag,
	Gui, Add, Edit, vINI,
	Gui, Add, Edit, vLookback,
	Gui, Add, Edit, vGlobal,
	Gui, Add, Edit, vItems,
	
	;Gui, Font,, Courier New
	Gui, Add, Button, Default, Generate
	Gui, Show,, Generate CDO Comment
return

ButtonGenerate:
	Gui, Submit
	
genText = 
(
;#GENERATE#
 Type: %Type%
Tag: %Tag%
INI: %INI%
)

	if(Lookback) {
		genText = %genText%`nLookback: %Lookback%
	}
	
	if(Global) {
		genText = %genText%`nGlobal: %Global%
	}
	genText = %genText%`nItems:`n%Items%`n

	SendRaw,%genText%
	Send, {Backspace}
	SendRaw, `;#ENDGEN#
	
	Gui, Destroy
return

#ifWinActive