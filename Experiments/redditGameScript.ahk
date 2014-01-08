    ; -----------------------------------------------------
    ; Trade Channels 1-10
    ; -----------------------------------------------------
    ~^0::
        BlockInput On
        
        Send, {Space}{Enter}
        Sleep, 1200
        
        Loop, 8 {
            tempIndex := A_Index + 1
            Send, /trade %tempIndex%
            
            Sleep, 1200
            Send, {Enter 2}
            Sleep, 1200
            Send, {Up 2}
            Sleep, 1200
            Send, {Enter 2}
            Sleep, 1200
        }
        
        Send, /trade 1
        
        Sleep, 1200
        Send, {Enter 2}
        Sleep, 1200
        Send, {Up 2}
        Sleep, 1200
        Send, {Enter}
        
        BlockInput Off
    return