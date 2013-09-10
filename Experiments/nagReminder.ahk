nagreminder_reminders = Watch your Posture!/5|Be happy/1005

nagreminder_visible := 1000 * 5

nagreminder_width := 400
nagreminder_color = 99FF00

Gui 72: +LastFound -Caption +AlwaysOnTop +ToolWindow
Gui 72: Font, s20
Gui 72: Color, %nagreminder_color%
Gui 72: Add, Text, vNagreminder_popup_text, Placeholder so that the label has an initial size

SysGet, nagreminder, Monitor


nagreminder_schedules = 0

Loop, parse, nagreminder_reminders, |
{
  StringSplit, nagreminder_fields, A_LoopField, /
  nagreminder_schedules += 1
  nagreminder_text_%a_index% := nagreminder_fields1
  nagreminder_period_%a_index% := nagreminder_fields2
  nagreminder_remaining_%a_index% := nagreminder_fields2
}


SetTimer nagreminder_check, % 1000 * 60

return
 

nagreminder_check:
  loop %nagreminder_schedules%
  {
    nagreminder_remaining_%a_index% -= 1
   
    if (nagreminder_remaining_%a_index% == 0)
    {
      nagreminder_show(nagreminder_text_%a_index%)
      nagreminder_remaining_%a_index% := nagreminder_period_%a_index%
    }
  }
 
  Return


nagreminder_show(text)
{
  global

  guicontrol 72:, Nagreminder_popup_text, %text%
  random nagreminder_x,, % nagreminderright - nagreminder_width
  random nagreminder_y,, % nagreminderbottom - 50
  Gui 72: show, x%nagreminder_x% y%nagreminder_y% w%nagreminder_width% NoActivate
  sleep % nagreminder_visible
  Gui 72: hide
}	