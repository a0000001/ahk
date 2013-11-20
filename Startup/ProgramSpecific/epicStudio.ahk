#ifWinActive, ahk_class WindowsForms10.Window.8.app.0.2bf8098_r13_ad1
	; TLG Hotkey.
	^t::
		Send, %epicID%
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
		; Send, ^c
		; Sleep, 100
		line := getSelectedText()
		
		Send, {End}{Enter}
		SendRaw, %line%
		Send, {Up}{End}
	return
		
	; Toggle comment. 
	^+c::
		Send, {End}{Shift Down}{Home}{Shift Up}
		; Send, ^c
		; Sleep, 100
		; line := clipboard
		; MsgBox, % line
		line := getSelectedText()
		
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
	
	; Get routine name from title to clipboard.
	!c::
		WinGetTitle, title
		; MsgBox, % title
		
		StringSplit, splitTitle, title, (, %A_Space%
		; MsgBox, % splitTitle1
		
		clipboard := splitTitle1
	return

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
		
		; Make sure we're on a clean line.
		Send, {Down}{Up}{End}{Backspace}
		
		genText := ""
		genText .= ";;#GENERATE#"
		genText .= "`n; Type: " Type
		genText .= "`n; Tag: " Tag
		genText .= "`n; INI: " INI
		if(Lookback) {
			genText .= "`n; Lookback: " Lookback
		}
		if(Global) {
			genText .= "`n; Global: " Global
		}
		genText .= "`n; Items:"
		genText .= "`n; " Items
		genText .= "`n;;#ENDGEN#"
		
		; MsgBox, % genText
		sendTextWithClipboard(genText)
		Send, {Enter}
		
		Gui, Destroy
	return
#ifWinActive

#ifWinActive, New Object
	; Make ctrl+backspace act as expected.
	^Backspace::
		Send, ^+{Left}
		Send, {Backspace}
	return
#ifWinActive