; Executor startup hotkey.
^+!x::activateOpenMinimize(pLaunchClass_Executor, pLaunchPath_Executor)

; Protect remote desktop executor from host AHK interference.
#IfWinNotActive, ahk_class TscShellContainerClass
	; use Caps Lock as the trigger key.
	CapsLock::
		SetCapsLockState, AlwaysOff
		Send, #a
	return
#IfWinNotActive

#ifWinActive, ahk_class TSetupForm

; Make ctrl+backspace actually work as expected.
^Backspace::
	Send, ^+{Left}
	Send, {Backspace}
return
	
#ifWinActive