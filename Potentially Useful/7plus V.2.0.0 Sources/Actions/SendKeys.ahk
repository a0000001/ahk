Action_SendKeys_Init(Action)
{
	Action.Category := "Input"
}
Action_SendKeys_ReadXML(Action, XMLAction)
{
	Action.Keys := XMLAction.Keys
}
Action_SendKeys_Execute(Action,Event)
{
	keys := Event.ExpandPlaceholders(Action.Keys)
	Send %keys%
	return 1
} 
Action_SendKeys_DisplayString(Action)
{
	return "SendKeys " Action.Keys
}
Action_SendKeys_GuiShow(Action, ActionGUI, GoToLabel = "")
{
	static sActionGUI
	if(GoToLabel = "")
	{
		sActionGUI := ActionGUI
		SubEventGUI_Add(Action, ActionGUI, "Edit", "Keys", "", "", "Keys to send:", "Placeholders", "Action_SendKeys_Placeholders", "Key names", "Action_SendKeys_KeyNames")
	}
	else if(GoToLabel = "Placeholders")
		SubEventGUI_Placeholders(sActionGUI, "Keys")
}
Action_SendKeys_Placeholders:
Action_SendKeys_GuiShow("", "", "Placeholders")
return

Action_SendKeys_KeyNames:
run http://www.autohotkey.com/docs/commands/Send.htm
return

Action_SendKeys_GuiSubmit(Action, ActionGUI)
{
	SubEventGUI_GUISubmit(Action, ActionGUI)
}