; Executor startup hotkey.
^+!x::Run, C:\Program Files (x86)\Executor\Executor.exe

; use Caps Lock as the trigger key.
CapsLock::
	; SetCapsLockState, Off
	Send, #z
return

#ifWinActive, ahk_class TSetupForm

; Make ctrl+backspace actually work as expected.
^Backspace::
	Send, ^+{Left}
	Send, {Backspace}
return
	
#ifWinActive