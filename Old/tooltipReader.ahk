; Integrated into main script.

; Based on http://www.autohotkey.com/board/topic/53672-get-the-text-content-of-a-tool-tip-window/?p=336440

/*
responding to the first post:

close balloon tips on a case by case basis
http://www.autohotkey.com/forum/viewtopic.php?t=55390

Leef_me's old post, rediscovered, yeah!
ControlClick coordinates and Windows Spy question (reads a tooltip in the process)
http://www.autohotkey.com/forum/topic54333.html

Keyboard shortcut to close balloon tips
http://www.autohotkey.com/forum/viewtopic.php?t=15141&highlight=close+balloon
*/


#singleinstance force
; CoordMode, ToolTip, screen
; CoordMode, Mouse, screen
return



;======== show the information from a single tooltip =========
F1::
ControlGetText, tooltip2,,ahk_class tooltips_class32
;tooltip, ******************`n%tooltip2%`n******************, 1300, 300
;sleep, 1000
;tooltip
msgbox, %tooltip2%
return


;======== show the information from a multiple tooltips =========
F2::
WinGet, ID, LIST,ahk_class tooltips_class32
tt_text=
Loop, %id%
{
  this_id := id%A_Index%
  ControlGetText, tooltip2,,ahk_id %this_id%
  tt_text.= "******************`n" tooltip2 "`n******************`n"
}

;tooltip, %tt_text%, 300, 300
msgbox, %tt_text%
;sleep, 3000
;tooltip

return