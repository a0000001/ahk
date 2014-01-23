/*
Author: Originally found at http://wiki.epic.com/main/AutoHotkey#Fill_in_DLG_numbers_for_SVN . Modified slightly by Gavin Borg.

Description: Auto-fills the DLG field in tortoiseSVN.

Installation: Copy this script (tortoiseSVN_dlgFiller.ahk) to your desktop and run it.

Notes:
	This works by running in the background, waiting for a window whose title matches the tortoiseSVN title regex below.
	Since it operates based on the title of the window, it unfortunately won't work for repositories not in the C:\EpicSource\v#.#\<DLG#>\... format.
*/

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force  ; Ensures that if this script is running, running it again replaces the first instance.
; #NoTrayIcon  ; Uncomment to hide the tray icon.

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