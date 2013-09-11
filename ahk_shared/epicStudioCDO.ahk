#ifWinActive, ahk_class WindowsForms10.Window.8.app.0.2bf8098_r13_ad1

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