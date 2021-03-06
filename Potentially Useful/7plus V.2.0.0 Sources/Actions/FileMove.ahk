Action_Move_Init(Action)
{
	Action_FileOperation_Init(Action)
}

Action_Move_ReadXML(Action, XMLAction)
{
	Action_FileOperation_ReadXML(Action, XMLAction)
}

Action_Move_Execute(Action, Event)
{
	Action_FileOperation_ProcessPaths(Action, Event, sources, targets, flags)
	ShellFileOperation(0x1, sources, targets, flags)  
	return 1
}
Action_Move_DisplayString(Action)
{
	global Settings_Events
	return Action_FileOperation_DisplayString(Action)
}

Action_Move_GuiShow(Action, ActionGUI, GoToLabel = "")
{	
	Action_FileOperation_GuiShow(Action, ActionGUI)
}
Action_Move_GuiSubmit(Action, ActionGUI)
{
	SubEventGUI_GUISubmit(Action, ActionGUI)
}   