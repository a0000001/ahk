Action_Run_Init(Action)
{
	Action.Category := "System"
	Action.WaitForFinish := 0
}
Action_Run_ReadXML(Action, XMLAction)
{
	Action.Command := XMLAction.Command
	Action.WorkingDirectory := XMLAction.WorkingDirectory
	Action.WaitForFinish := XMLAction.WaitForFinish
}
Action_Run_Execute(Action, Event)
{
	if(!Action.tmpPid)
	{
		command := Event.ExpandPlaceholders(Action.Command)
		WorkingDirectory := Event.ExpandPlaceholders(Action.WorkingDirectory)
		if(Action.WaitForFinish)
		{
			Action.tmpPid := Run(command, WorkingDirectory)
			if(Action.tmpPid) ;If retrieved properly
				return -1
			MsgBox Waiting for %command% failed!
			return 0
		}
		else
			Run(command, WorkingDirectory)
	}
	else
	{
		pid := Action.tmpPid
		Process, Exist, %pid%
		if(ErrorLevel)
			return -1
	}
	return 1
}
Action_Run_DisplayString(Action)
{
	return "Run " Action.Command
}
Action_Run_GuiShow(Action, ActionGUI, GoToLabel = "")
{
	static sActionGUI
	if(GoToLabel = "")
	{
		sActionGUI := ActionGUI
		SubEventGUI_Add(Action, ActionGUI, "Edit", "Command", "", "", "Command:","Browse", "Action_Run_Browse", "Placeholders", "Action_Run_Placeholders")
		SubEventGUI_Add(Action, ActionGUI, "Edit", "WorkingDirectory", "", "", "Working Dir:","Browse", "Action_Run_Browse_WD", "Placeholders", "Action_Run_Placeholders_WD")
		SubEventGUI_Add(Action, ActionGUI, "Checkbox", "WaitForFinish", "Wait for finish", "", "")
	}
	else if(GoToLabel = "Browse")
		SubEventGUI_SelectFile(sActionGUI, "Command", "Select File", "", 1)
	else if(GoToLabel = "Placeholders")
		SubEventGUI_Placeholders(sActionGUI, "Command")
	else if(GoToLabel = "Browse_WD")
		SubEventGUI_Browse(sActionGUI, "WorkingDirectory", "Select working directory", "", 1)
	else if(GoToLabel = "Placeholders_WD")
		SubEventGUI_Placeholders(sActionGUI, "WorkingDirectory")
}
Action_Run_Browse:
Action_Run_GuiShow("", "", "Browse")
return
Action_Run_Placeholders:
Action_Run_GuiShow("", "", "Placeholders")
return
Action_Run_Browse_WD:
Action_Run_GuiShow("", "", "Browse_WD")
return
Action_Run_Placeholders_WD:
Action_Run_GuiShow("", "", "Placeholders_WD")
return
Action_Run_GuiSubmit(Action, ActionGUI)
{
	SubEventGUI_GUISubmit(Action, ActionGUI)
}