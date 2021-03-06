#Persistent 
#NoTrayIcon ;Added later
#InstallMouseHook
#InstallKeyBdHook
#MaxThreads 255
#IfTimeout 150ms ;Might soften up mouse hook timeout problem
#MaxHotkeysPerInterval 1000 ;Required for mouse wheel
SetBatchLines -1
SetMouseDelay, -1 ; no pause after mouse clicks 
SetKeyDelay, -1 ; no pause after keys sent 
SetDefaultMouseSpeed, 0
CoordMode, Mouse, Screen
SetWinDelay, -1
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases. 
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability. 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;SetFormat, Integer, D
MajorVersion := 2
MinorVersion := 0
BugfixVersion := 0
#include %A_ScriptDir%\Autoexecute.ahk ;include first to avoid issues with autoexecute ending too soon because of labels
/*
#if !IsFullscreen("A",true,false)
#h::
	DetectHiddenWindows, Off
	if(WinExist("7plus Settings"))
		WinActivate 7plus Settings
	else
		ShowSettings()
	return
#if
;#q::Reload
*/
#Include %A_ScriptDir%
#include %A_ScriptDir%\lib\Array.ahk
#include %A_ScriptDir%\lib\binreadwrite.ahk
#include %A_ScriptDir%\lib\com.ahk
#include %A_ScriptDir%\lib\Crypt.ahk
#include %A_ScriptDir%\lib\Cursor.ahk
#include %A_ScriptDir%\lib\Dock.ahk
#include %A_ScriptDir%\lib\FTPLib.ahk
#include %A_ScriptDir%\lib\Functions.ahk
#include %A_ScriptDir%\lib\gdip.ahk
#include %A_ScriptDir%\lib\RemoteBuf.ahk
#include %A_ScriptDir%\lib\RichObject.ahk
#include %A_ScriptDir%\lib\Taskbutton.ahk
#include %A_ScriptDir%\lib\VA.ahk
#include %A_ScriptDir%\lib\Win.ahk
#include %A_ScriptDir%\lib\xpath.ahk

#include %A_ScriptDir%\Trigger.ahk
#include %A_ScriptDir%\EditEventGUI.ahk
#include %A_ScriptDir%\EditSubEventGUI.ahk
#include %A_ScriptDir%\Placeholders.ahk
#include %A_ScriptDir%\SubEventGUIBuilder.ahk
#include %A_ScriptDir%\messagehooks.ahk
#include %A_ScriptDir%\navigate.ahk
#include %A_ScriptDir%\FolderButtonManager.ahk
#include %A_ScriptDir%\ContextMenu.ahk
#include %A_ScriptDir%\FastFolders.ahk
#include %A_ScriptDir%\WindowHandling.ahk
#include %A_ScriptDir%\explorer.ahk
#include %A_ScriptDir%\clipboard.ahk
#include %A_ScriptDir%\FTPUpload.ahk 
#include %A_ScriptDir%\Taskbar.ahk
; #include %A_ScriptDir%\Misc.ahk
#include %A_ScriptDir%\xml.ahk
#include %A_ScriptDir%\debugging.ahk
#include %A_ScriptDir%\settings.ahk
#include %A_ScriptDir%\miscfunctions.ahk
#include %A_ScriptDir%\Registry.ahk
#include %A_ScriptDir%\SlideWindows.ahk
#include %A_ScriptDir%\JoyControl.ahk
#include %A_ScriptDir%\Tooltip.ahk
#include %A_ScriptDir%\WinTrayMin.ahk
#include %A_ScriptDir%\ExplorerTabs.ahk
#include %A_ScriptDir%\CustomHotkeys.ahk
#include %A_ScriptDir%\HotkeyGUI.ahk

#include %A_ScriptDir%\Triggers\DoubleClickDesktop.ahk
#include %A_ScriptDir%\Triggers\DoubleClickTaskbar.ahk
#include %A_ScriptDir%\Triggers\ExplorerPathChanged.ahk
#include %A_ScriptDir%\Triggers\ExplorerDoubleClickSpace.ahk
#include %A_ScriptDir%\Triggers\Hotkey.ahk
#include %A_ScriptDir%\Triggers\OnMessage.ahk
#include %A_ScriptDir%\Triggers\Trigger.ahk
#include %A_ScriptDir%\Triggers\Timer.ahk
#include %A_ScriptDir%\Triggers\WindowActivated.ahk
#include %A_ScriptDir%\Triggers\WindowClosed.ahk
#include %A_ScriptDir%\Triggers\WindowCreated.ahk
#include %A_ScriptDir%\Triggers\WindowStateChange.ahk
#include %A_ScriptDir%\Triggers\7plusStart.ahk

#include %A_ScriptDir%\Conditions\If.ahk
#include %A_ScriptDir%\Conditions\IsDialog.ahk
#include %A_ScriptDir%\Conditions\IsFullScreen.ahk
#include %A_ScriptDir%\Conditions\IsContextMenuActive.ahk
#include %A_ScriptDir%\Conditions\IsRenaming.ahk
#include %A_ScriptDir%\Conditions\KeyIsDown.ahk
#include %A_ScriptDir%\Conditions\MouseOver.ahk
#include %A_ScriptDir%\Conditions\WindowActive.ahk
#include %A_ScriptDir%\Conditions\WindowExists.ahk

#include %A_ScriptDir%\Actions\Autoupdate.ahk
#include %A_ScriptDir%\Actions\Clipboard.ahk
#include %A_ScriptDir%\Actions\Clipmenu.ahk
#include %A_ScriptDir%\Actions\ControlEvent.ahk
#include %A_ScriptDir%\Actions\ControlTimer.ahk
#include %A_ScriptDir%\Actions\Exit7plus.ahk
#include %A_ScriptDir%\Actions\FastFoldersClear.ahk
#include %A_ScriptDir%\Actions\FastFoldersMenu.ahk
#include %A_ScriptDir%\Actions\FastFoldersRecall.ahk
#include %A_ScriptDir%\Actions\FastFoldersStore.ahk
#include %A_ScriptDir%\Actions\FileCopy.ahk
#include %A_ScriptDir%\Actions\FileDelete.ahk
#include %A_ScriptDir%\Actions\FileMove.ahk
#include %A_ScriptDir%\Actions\FileWrite.ahk
#include %A_ScriptDir%\Actions\FilterList.ahk
#include %A_ScriptDir%\Actions\FlashingWindows.ahk
#include %A_ScriptDir%\Actions\FocusControl.ahk
#include %A_ScriptDir%\Actions\FTPUpload.ahk
#include %A_ScriptDir%\Actions\Input.ahk
#include %A_ScriptDir%\Actions\Message.ahk
#include %A_ScriptDir%\Actions\MinimizeToTray.ahk
#include %A_ScriptDir%\Actions\MouseClick.ahk
#include %A_ScriptDir%\Actions\NewFile.ahk
#include %A_ScriptDir%\Actions\NewFolder.ahk
#include %A_ScriptDir%\Actions\PlaySound.ahk
#include %A_ScriptDir%\Actions\Restart7plus.ahk
#include %A_ScriptDir%\Actions\Run.ahk
#include %A_ScriptDir%\Actions\Screenshot.ahk
#include %A_ScriptDir%\Actions\SelectFiles.ahk
#include %A_ScriptDir%\Actions\SendKeys.ahk
#include %A_ScriptDir%\Actions\SendMessage.ahk
#include %A_ScriptDir%\Actions\SetDirectory.ahk
#include %A_ScriptDir%\Actions\SetWindowTitle.ahk
#include %A_ScriptDir%\Actions\ShowSettings.ahk
#include %A_ScriptDir%\Actions\ShutDown.ahk
#include %A_ScriptDir%\Actions\Tooltip.ahk
#include %A_ScriptDir%\Actions\Volume.ahk
#include %A_ScriptDir%\Actions\WindowActivate.ahk
#include %A_ScriptDir%\Actions\WindowClose.ahk
#include %A_ScriptDir%\Actions\WindowHide.ahk
#include %A_ScriptDir%\Actions\WindowMove.ahk
#include %A_ScriptDir%\Actions\WindowResize.ahk
#include %A_ScriptDir%\Actions\WindowShow.ahk
#include %A_ScriptDir%\Actions\WindowState.ahk

#include %A_ScriptDir%\Generic\WindowFilter.ahk
#include %A_ScriptDir%\Generic\FileOperation.ahk


; AssignHotkeys:
; outputdebug blah
; Hotkey, If, !IsFullScreen()
; Hotkey, MButton, MButton, On
; Hotkey, If
; return
