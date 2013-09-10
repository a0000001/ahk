; Up and down at an interval. (override Win+up and Win+down windows shortcuts)
#Up::Send {Volume_Up 5}
#Down::Send {Volume_Down 5}

; Volume control.
+^WheelUp::Send, {Volume_Up}
+^WheelDown::Send, {Volume_Down}
; ^!WheelUp::Send, {Volume_Up 5}
; ^!WheelDown::Send, {Volume_Down 5}

; Toggle Mute.
#Enter::VA_SetMasterMute(!VA_GetMasterMute())

