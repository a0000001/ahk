Action_WindowActivate_Init(Action)
{
	WindowFilter_Init(Action)
	Action.Category := "Window"
}
Action_WindowActivate_ReadXML(Action, XMLAction)
{
	WindowFilter_ReadXML(Action, XMLAction)
}
Action_WindowActivate_Execute(Action)
{
	hwnd := WindowFilter_Get(Action)
	if(hwnd != 0)
		WinActivate ahk_id %hwnd%
	return 1
}
Action_WindowActivate_DisplayString(Action)
{
	return "Activate Window " WindowFilter_DisplayString(Action)
}
Action_WindowActivate_GuiShow(Action, ActionGUI)
{
	WindowFilter_GuiShow(Action,ActionGUI)
}
Action_WindowActivate_GuiSubmit(Action, ActionGUI)
{
	WindowFilter_GuiSubmit(Action,ActionGUI)
}