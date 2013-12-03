; Author: J. Lloyd
; press ctrl+shift+L with the XXX ####### text highlighted for a log to turn it into a link.
; Supported: DLG, SLG, QAN, TN
; Added support for DRN - J. Greiveldinger 08/2011
; Added support for ZCN - E. Cox 09/2011
; Added support for Sherlock - E. Cox 11/2011
; Fixed bugs - Z. Glazer 12/2011
; Added support for OneNote 2010 - Z. Glazer 1/2012
; Added PRJ support - Rehm 6/28/2012
; Added XDS support - ncastner 8/9/2012
; Added ZPF (Saved Search) support - ncastner 3/4/2013
; Added Nova support - bstodola 3/29/2013
; Added ILG support - avo 9/26/2013

+^l::
	ErrorLevel = 0
	ClipRec := ClipboardAll 
	clipboard =
	action = EDIT
	Send, ^c 
	Sleep 50

	If ErrorLevel
	{
		MsgBox Could not copy text. Script not executed.
		clipboard := ClipRec 
		ClipRec = 
		Return
	}

	IfInString, Clipboard, DLG
	{
		StringReplace, clipboard, clipboard, DLG%A_Space%, emc2://TRACK/DLG/
	}
	IfInString, Clipboard, SLG
	{
		StringReplace, clipboard, clipboard, SLG%A_Space%, emc2://TRACK/SLG/
	}
	IfInString, Clipboard, QAN
	{
		StringReplace, clipboard, clipboard, QAN%A_Space%, emc2://TRACK/ZQN/
	}
	IfInString, Clipboard, PRJ
	{
		StringReplace, clipboard, clipboard, PRJ%A_Space%, emc2://TRACK/PRJ/
	}
	IfInString, Clipboard, ZQN
	{
		StringReplace, clipboard, clipboard, ZQN%A_Space%, emc2://TRACK/ZQN/
	}
	IfInString, Clipboard, TN
	{
		StringReplace, clipboard, clipboard, TN%A_Space%, emc2://TRACK/XTN/
	}
	IfInString, Clipboard, XTN
	{
		StringReplace, clipboard, clipboard, XTN%A_Space%, emc2://TRACK/XTN/
	}
	IfInString, Clipboard, DRN
	{
		StringReplace, clipboard, clipboard, DRN%A_Space%, emc2://TRACK/DRN/
		action = VIEW
	}
	IfInString, Clipboard, ZCN
	{
		StringReplace, clipboard, clipboard, ZCN%A_Space%, emc2://TRACK/ZCN/
	}
	IfInString, Clipboard, XDS
	{
		StringReplace, clipboard, clipboard, XDS%A_Space%, emc2://TRACK/XDS/
	}
	IfInString, Clipboard, Sherlock
	{
		StringReplace, clipboard, clipboard, Sherlock%A_Space%, https://sherlock.epic.com/default.aspx?view=slg/home#id=
	}
	IfInString, Clipboard, Nova
	{
		RNid := SubStr(clipboard, 6)
		StringReplace, clipboard, clipboard, Nova%A_Space%, https://nova.epic.com/Search.aspx#SearchTerm=
	}
	IfInString, Clipboard, ZPF
	{
		StringReplace, clipboard, clipboard, ZPF%A_Space%, emc2://TRACK/ZPF/
	}
	IfInString, Clipboard, ILG
	{
		StringReplace, clipboard, clipboard, ILG%A_Space%, emc2://TRACK/ILG/
	}
	
	MsgBox, % clipboard
	return
	
	If StrLen(Clipboard)>0 
	{
		IfInString, clipboard, sherlock
		{
			clipboard=%clipboard%&view=1&pd=1
		}
		Else IfInString, clipboard, nova
		{
			clipboard=%clipboard%&RnID=%RNid%
		}
		Else
			clipboard =%clipboard%?action=%action%
			Send, ^k
			WinWait,Insert Hyperlink,,0
		
		If ErrorLevel
		{
			ErrorLevel = 0
			WinWait,Link,,0   
		}
		
		If ErrorLevel
		{
			Clipboard := ClipRec
			ClipRec =
			Return
		}
		
		WinGetTitle, ttl
		
		If ttl = Insert Hyperlink
		{
			Send, ^v
			Send, `n
		}
		
		If ttl = Link
		{
			Send, ^v
			Send, `n
		}
	}
	
	Clipboard := ClipRec 
	ClipRec = 
return


