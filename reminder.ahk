#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#NoTrayIcon

Loop
{
	FormatTime, myTime, , HHmm
	; Reminder for daily minor backup
	if(myTime = 2200)
				{
				MsgBox Run minor backup.
				MsgBox Run mail backup.
				}
	;Backup/virus scan reminder: runs only on sundays, at 10:30, and 11.
	If (A_WDay = 1)
		{
			if(myTime = 2230)
				{
				MsgBox Leave computer awake.
				}
			if(myTime = 2300)
				{
				MsgBox Leave computer awake.
				}
		}
	Sleep, 60000
}