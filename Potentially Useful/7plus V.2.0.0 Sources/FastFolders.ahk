/*
FFCondition()
{
	global Vista7, HKFastFolders
	if(Vista7)
	  ControlGetFocus focussed, A
	else
		focussed:=XPGetFocussed()
	if HKFastFolders && ((WinActive("ahk_group ExplorerGroup") ) || IsDialog()||IsWinRarExtractionDialog())  && !strStartsWith(focussed,"Edit")
		return true
	return false
}

#if FFCondition()
Numpad0 UP::SetDirectory(FF0)
Numpad1 UP::SetDirectory(FF1)
Numpad2 UP::SetDirectory(FF2)
Numpad3 UP::SetDirectory(FF3)
Numpad4 UP::SetDirectory(FF4)
Numpad5 UP::SetDirectory(FF5)
Numpad6 UP::SetDirectory(FF6)
Numpad7 UP::SetDirectory(FF7)
Numpad8 UP::SetDirectory(FF8)
Numpad9 UP::SetDirectory(FF9)
^Numpad0 UP::UpdateStoredFolder(FF0,FFTitle0)
^Numpad1 UP::UpdateStoredFolder(FF1,FFTitle1)
^Numpad2 UP::UpdateStoredFolder(FF2,FFTitle2)
^Numpad3 UP::UpdateStoredFolder(FF3,FFTitle3)
^Numpad4 UP::UpdateStoredFolder(FF4,FFTitle4)
^Numpad5 UP::UpdateStoredFolder(FF5,FFTitle5)
^Numpad6 UP::UpdateStoredFolder(FF6,FFTitle6)
^Numpad7 UP::UpdateStoredFolder(FF7,FFTitle7)
^Numpad8 UP::UpdateStoredFolder(FF8,FFTitle8)
^Numpad9 UP::UpdateStoredFolder(FF9,FFTitle9)
!Numpad0 UP::ClearStoredFolder(FF0,FFTitle0)
!Numpad1 UP::ClearStoredFolder(FF1,FFTitle1)
!Numpad2 UP::ClearStoredFolder(FF2,FFTitle2)
!Numpad3 UP::ClearStoredFolder(FF3,FFTitle3)
!Numpad4 UP::ClearStoredFolder(FF4,FFTitle4)
!Numpad5 UP::ClearStoredFolder(FF5,FFTitle5)
!Numpad6 UP::ClearStoredFolder(FF6,FFTitle6)
!Numpad7 UP::ClearStoredFolder(FF7,FFTitle7)
!Numpad8 UP::ClearStoredFolder(FF8,FFTitle8)
!Numpad9 UP::ClearStoredFolder(FF9,FFTitle9)
#if
*/
ClearStoredFolder(ByRef FF, ByRef FFTitle)
{
	global
	Critical
	local pos, name
	FF:=""
	FFTitle:=""
	if (HKFolderBand)
	{
		RemoveAllButtons(IsFastFolderButton)
		loop 10
		{
			pos:=A_Index-1
			if FF%pos%
			{			
				if(!name)
					name:=path
				AddButton("",FF%pos%,,pos ":" FFTitle%pos%)
			}
		}
	}
	Critical, Off
}
UpdateStoredFolder(ByRef FF, ByRef FFTitle, Folder="")
{
	;Update values of FF and FFTitle, then refresh fast folders
	if(Folder)
		FF := Folder
	else
		FF:=GetCurrentFolder()
	title:=FF	
	if(strStartsWith(title,"::") && WinActive("ahk_group ExplorerGroup"))
		WinGetTitle,title,A
		
	SplitPath, title , FFTitle
	if(!FFTitle)
		FFtitle:=title
	RefreshFastFolders()	
}

RefreshFastFolders()
{
	global
	if (HKFolderBand)
		RemoveAllButtons(IsFastFolderButton)
	AddAllButtons(HKFolderBand,HKPlacesBar)
}
AddAllButtons(FolderBand,PlacesBar)
{
	global	
	local pos, value
	Critical
	loop 10
	{
		pos:=A_Index-1
		if FF%pos%
		{				
			if (FolderBand)		
				AddButton("",FF%pos%,,pos ":" FFTitle%pos%)
			if(pos<=4 && PlacesBar)	;Also update placesbar
			{
				value:=FF%pos%
				RegWrite, REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Policies\comdlg32\Placesbar, Place%pos%,%value%
			}				
		}
	}
	Critical, Off
}
;Callback function for determining if a specific registry key was created by 7plus
IsFastFolderButton(Command,Title,Tooltip)
{
	x:=substr(Title,1,1)
	if(IsNumeric(x)&&substr(Title,2,1)=":")
		return true
	return false
}

FastFolderMenu()
{
	global
	Menu, FastFolders, add, 1,FastFolderMenuHandler1
	Menu, FastFolders, DeleteAll
	if ((IsWindowUnderCursor("ExploreWClass")||IsWindowUnderCursor("CabinetWClass")||IsWindowUnderCursor("WorkerW")||IsWindowUnderCursor("Progman")) && !IsRenaming())
	{
		win:=WinExist("A")
		y:=GetSelectedFiles()
		loop 10
		{
			i:=A_INDEX-1
			if(FF%i%)
			{
				x:=FFTitle%i%
				if(x && (!strStartsWith(x,"ftp://")||!y))
				{
					x := "&" i ": " x
					Menu, FastFolders, add, %x%, FastFolderMenuHandler%i%
				}
			} 
		}
		hwnd:=WinExist("A")
		Menu, FastFolders, Show
		return true
	}	
	return false
}

FastFolderMenuHandler0:
FastFolderMenuClicked(0)
return
FastFolderMenuHandler1:
FastFolderMenuClicked(1)
return
FastFolderMenuHandler2:
FastFolderMenuClicked(2)
return
FastFolderMenuHandler3:
FastFolderMenuClicked(3)
return
FastFolderMenuHandler4:
FastFolderMenuClicked(4)
return
FastFolderMenuHandler5:
FastFolderMenuClicked(5)
return
FastFolderMenuHandler6:
FastFolderMenuClicked(6)
return
FastFolderMenuHandler7:
FastFolderMenuClicked(7)
return
FastFolderMenuHandler8:
FastFolderMenuClicked(8)
return
FastFolderMenuHandler9:
FastFolderMenuClicked(9)
return

FastFolderMenuClicked(index)
{
	global
	local y:=FF%index%
	x:=GetSelectedFiles()
	StringReplace, x, x, `n , |, A
	if(x && (GetKeyState("CTRL") || GetKeyState("Shift")))
	{	
		if(GetKeyState("CTRL"))
			ShellFileOperation(0x2, x, y,0,hwnd)   
		else if(GetKeyState("Shift"))
			ShellFileOperation(0x1, x, y,0,hwnd)
	}
	else
	{
		Sleep 100
		SetDirectory(y)
	}
	Menu, FastFolders, DeleteAll
}
