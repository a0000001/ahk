#IfWinActive, ahk_class Notepad++

; Ctrl+Shift+t browser-like behavior.
^+t::
	Send !f
	Send 1
return

; Disable Alt+Shift+X close document
!+x::Return

; Prevent accidental random insert instead of redo.
^+z:: Send ^y

; New document.
^n::^t

; Special key for notepad++ save session and load session
^!s::Send ^+!{Backspace}
^!l::Send ^+!{PgUp}

; AHK debugging hotkeys.
$F5::
	debuggerStarted := scriptStarted := 0
	
	; If the debugger isn't running, start it.
	if(!isWindowInState("Active", "", "DBGp")) {
		Send, {F6}
		
		SetTitleMatchMode, Slow
		WinWaitActive, , Disconnected..., 5
		SetTitleMatchMode, Fast
		
		if(ErrorLevel) {
			MsgBox, Failed to start debugger!
			return
		}
		
		debuggerStarted := 1
	}
	
	; If debugger is running, but script is not, run script.
	if(isWindowInState("Active", "", "Disconnected...", 1, "Slow")) {
		ControlSend, Scintilla1, {F7}
		
		SetTitleMatchMode, Slow
		WinWaitNotActive, , Disconnected..., 5
		SetTitleMatchMode, Fast
		
		if(ErrorLevel) {
			MsgBox, Failed to run script!
			return
		}
		
		scriptStarted := 1
	}
	
	; If we're actively debugging, just continue.
	if(isWindowInState("Active", "", "DBGp") && !isWindowInState("Active", "", "Disconnected...", 1, "Slow")) {
		if(!debuggerStarted && !scriptStarted)
			ControlSend, Scintilla1, {F5}
	}
return

#IfWinActive
