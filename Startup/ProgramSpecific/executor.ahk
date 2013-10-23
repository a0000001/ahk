; Executor startup hotkey.
^+!x::Run, C:\Program Files (x86)\Executor\Executor.exe

; Protect remote desktop executor from host AHK interference.
#IfWinNotActive, ahk_class TscShellContainerClass
	; use Caps Lock as the trigger key.
	CapsLock::
		SetCapsLockState, AlwaysOff
		Send, #z
	return
#IfWinNotActive

#ifWinActive, ahk_class TSetupForm

; Make ctrl+backspace actually work as expected.
^Backspace::
	Send, ^+{Left}
	Send, {Backspace}
return
	
#ifWinActive