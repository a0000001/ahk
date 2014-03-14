#IfWinActive, ahk_class WindowsForms10.Window.8.app.0.2bf8098_r13_ad1
	; TLG Hotkey.
	^t::
		Send, %epicID%
	return

	; ; Better access to INTermediate code.
	; ^+i::
		; ControlSend, , ^+v
	; return

	; Reopen recently closed file.
	^+t::
		Send, !ffr{Enter}
	return

	; Duplicate Line.
	; ^d::
		; Send, {End}{Shift Down}{Home}{Shift Up}
		; ; Send, ^c
		; ; Sleep, 100
		; line := getSelectedText()
		
		; Send, {End}{Enter}
		; SendRaw, %line%
		; Send, {Up}{End}
	; return
	
	; Debug, auto-search for workstation ID.
	~F3::
		WinWait, Attach to Process, , 5
		if(!ErrorLevel) {
			Send, {Tab}{Down 2}
			Send, % epicComputerName
			Send, {Enter}{Down}
		} else
			DEBUG.popup(debugEpicStudio,ErrorLevel,"ES Debug WinWait ErrorLevel")
	return
	
	; ; Toggle comment. 
	; ^+c::
		; Send, {End}{Shift Down}{Home}{Shift Up}
		; ; Send, ^c
		; ; Sleep, 100
		; ; line := clipboard
		; ; MsgBox, % line
		; line := getSelectedText()
		
		; ; Determine if the line is currenly commented.
		; commented = false
		; firstChar := SubStr(line,1,1)
		
		; if(firstChar = ";") {
			; ; MsgBox, commented!
			; line := SubStr(line,2)
			; if(SubStr(line,1,1) = " ") {
				; line := SubStr(line,2)
			; }
		; } else {
			; ; MsgBox, not commented!
			; line := "; "line
		; }
		
		; SendRaw, %line%
		; Send, {Home}
	; return
	
	; Link routine to currently open (in object explorer tab) DLG.
	^+l::
		WinGetText, text
		DEBUG.popup(DEBUG.epicStudio, text, "Window Text")
		
		Loop, Parse, text, `n
		{
			if(SubStr(A_LoopField, 1, 4) = "DLG ") {
				objectName := A_LoopField
				dlgNum := SubStr(objectName, 4)
				DEBUG.popup(DEBUG.epicStudio, A_Index, "On line", objectName, "Found object", dlgNum, "With DLG number")
				break
			}
		}
		
		if(!objectName)
			return
		
		Send, ^l
		WinWaitActive, Link DLG, , 5
		Send, % dlgNum
		Send, {Enter}
	return

	; ^q::Send, % commentStartString
	
	getInfoFromTitle(info) {
		; debugPrint(info)
		
		WinGetTitle, title
		; MsgBox, % title
		
		splitTitle := specialSplit(title, "(")
		; debugPrint(splitTitle)
		splitTitle[1] := SubStr(splitTitle[1], 1, -1)
		splitTitle[2] := SubStr(splitTitle[2], 1, -2)
		splitTitle[3] := SubStr(splitTitle[3], 5, -14)
		; debugPrint(splitTitle)
		
		if(info = EPICSTUDIO_ROUTINE) {
			return splitTitle[1]
		} else if(info = EPICSTUDIO_ENVIRONMENT) {
			return splitTitle[2]
		} else if(info = EPICSTUDIO_DLG) {
			return splitTitle[3]
		}
		
		MsgBox, Bad info choice!
	}
	
	getEpicEnvironment(env, type) {
		; Read the file into an array.
		lines := fileLinesToArray("A:\Selector\epicEnvironments.ini")
		; debugPrint(lines)
		
		; Parse those lines into a N x N array, where the meaningful lines have become a size 3 array (Name, Abbrev, Action) each.
		; table := cleanParseList(lines)
		table := TableList.parseList(lines)
		; debugPrint(table)
		
		; Find the current environment in the table.
		rowNum := tableContains(table, env)
		; debugPrint(rowNum)
		
		return table[rowNum, type]
	}
	
	diffWithEnvironment(type) {
		currEnv := getInfoFromTitle(EPICSTUDIO_ENVIRONMENT)
		; debugPrint(currEnv)
		
		diffEnv := getEpicEnvironment(currEnv, type)
		; debugPrint(diffEnv)
		
		; Get to diff prompt.
		Send, !d
		WinWait, Diff with Object
		
		; Move to environment field, and drop in what we figured out.
		Send, {Tab 3}
		Send, % diffEnv
		
		; Get through search popup, then accept.
		Send, {Enter}
		WinWait, Find Environment
		Send, {Enter 2}
	}
	
	; Diff with IDE.
	^d::
		diffWithEnvironment(EPIC_IDE)
	return
	; Diff with QA.
	^q::
		diffWithEnvironment(EPIC_QA)
	return
	
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
#IfWinActive

#IfWinActive, New Object
	; Make ctrl+backspace act as expected.
	^Backspace::
		Send, ^+{Left}
		Send, {Backspace}
	return
#IfWinActive 