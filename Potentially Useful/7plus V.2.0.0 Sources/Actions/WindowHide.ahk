Action_WindowHide_Init(Action)
{
	WindowFilter_Init(Action)
	Action.Category := "Window"
}
Action_WindowHide_ReadXML(Action, XMLAction)
{
	WindowFilter_ReadXML(Action, XMLAction)
}
Action_WindowHide_Execute(Action)
{
	hwnd := WindowFilter_Get(Action)
	if(hwnd != 0)
		WinHide ahk_id %hwnd%
	return 1
}
Action_WindowHide_DisplayString(Action)
{
	return "Hide Window " WindowFilter_DisplayString(Action)
}
Action_WindowHide_GuiShow(Action, ActionGUI)
{
	WindowFilter_GuiShow(Action,ActionGUI)
}
Action_WindowHide_GuiSubmit(Action, ActionGUI)
{
	WindowFilter_GuiSubmit(Action,ActionGUI)
}