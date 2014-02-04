#Persistent

SetTimer, WatchCursor, 100
Gosub, WatchCursor  ; Call it once to get it started right away.
return


WatchCursor:
text=
; get info about the current mouse location, specifically window info and control info
MouseGetPos, , , id, control
WinGetTitle, title, ahk_id %id%
WinGetClass, class, ahk_id %id%
ControlGetText, text , %control%, ahk_id %id%


; show info about the current mouse location 
tooltip, ahk_id %id%`nahk_class %class%`n%title%`nControl: %control% `ntext: %text%
return

esc::exitapp	; in case of emergency, hit escape


f1::			; copy info about the current mouse location to the clipboard
Gosub, WatchCursor  
clipboard= ahk_id %id%`r`nahk_class %class%`r`n%title%`r`nControl: %control%`r`ntext: >>>`r`n%text%
return



f2::			; copy the info (formatted as Ahk_code) to the clipboard

ahk_code=
(
  ControlGetText, text, %control%, %title%
  ControlGetText, text, %control%, ahk_class %class%
)
clipboard= %ahk_code%
msgbox %ahk_code%
return