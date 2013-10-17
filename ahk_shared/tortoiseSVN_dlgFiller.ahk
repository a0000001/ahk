#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

SetTitleMatchMode RegEx

Loop {
	WinWaitActive, ^C:\\EpicSource\\\d\.\d\\DLG-(\d+)[-\\].* - Commit - TortoiseSVN
	ControlGetText, DLG, Edit2
	if(DLG = "") {
		WinGetActiveTitle, Title
		RegExMatch(Title, "^C:\\EpicSource\\\d\.\d\\DLG-(\d+)[-\\].* - Commit - TortoiseSVN", DLG)
		ControlSend, Edit2, %DLG1%
	}
	
	Sleep, 5000 ; Wait 5 seconds before going again, to reduce idle looping.
}