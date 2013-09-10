; Auto-execute

; Bookmark straight to firefox's database.

; Constant parent/folder IDs and paths.

; Folders to include:
;	Backlog
;	Mikal
;	Games
;	Tech
;	AHK
;	Comics
;	Windows
;	Firefox
;	Extensions
;	Userscripts
;	Web Dev

; fff_backlog := 16310
fff_backlog := 41
; fff_mikal := 16312
fff_mikal := 3554
; fff_games := 15842
fff_games := 38
; fff_tech := 15895
fff_tech := 39
; fff_ahk := 15908
fff_ahk := 849

sqlitePath = C:\Program Files\sqlite3\sqlite3.exe

firefoxProfilesFolder = I:\Mozilla\Firefox\Profiles
profileFolder = xjs9u7tr.Gavin11-24-12
dbName = places.sqlite

dbPath := firefoxProfilesFolder "\" profileFolder "\" dbName

; MsgBox, % dbPath


; Simple enough to do by itself.
FF_GetCleanURL() {
	quoteString = "	; Representation of " to avoid issues with escaping, etc.
	
	result := FF_RetrievePageName()
	StringSplit, outputArray, result, "
	
	return outputArray2
}

; Use the one below to get both, then return the correct one.
FF_GetCleanTitle() {
	result := FF_GetCleanTitleUrl()
	StringSplit, outputArray, result, ``
	
	return outputArray1
}

FF_GetCleanTitleURL() {
	quoteString = "	; Representation of " to avoid issues with escaping, etc.
	
	result := FF_RetrievePageName()
	StringReplace, result, result, %quoteString%, %quoteString%, UseErrorLevel
	StringSplit, outputArray, result, "
	url := outputArray2
	
	if(ErrorLevel != 6) {	; Need further processing - other "s exist.
		finalTitle := outputArray4
		
		Loop, % ErrorLevel - 6 { 
			newIndex := A_Index + 4
			
			StringTrimRight, finalTitle, finalTitle, 1
			finalTitle .= quoteString . outputArray%newIndex%
		}
		
		title := finalTitle
		
		; Escape some issue characters.
		StringReplace, title, title, ", \", A
		
	} else {
		title := outputArray4
	}
	
;	MsgBox, % url ", " title
	
	returnString := title . "``" . url
	return returnString
}

FF_BookmarkToFolder(parentID) {
	global sqlitePath, dbPath
	
	result := FF_GetCleanTitleUrl()
	StringSplit, outputArray, result, ``
	title := outputArray1
	url := outputArray2		
	
;	MsgBox, Returned: %result% `n`n Title: `n %title% `n`n URL: `n %url%
	
	; Backup for if something goes wrong, of important data.
	global StartupScriptsFolder
	FileAppend, %title%`n`t%url%`n`n, %StartupScriptsFolder%\Txts\bookmarkingBackup.txt
	
	; For command line use, 
	StringReplace, title, title, ', '', A
	
	query = "insert into moz_bookmarks(type, fk, parent, position, title) values(1, (SELECT id from moz_places where url='%url%'), %parentID%, (Select max(position) from moz_bookmarks where parent=%parentID%) + 1, '%title%');"
	
	runString = %sqlitePath% %dbPath% %query%
	
;	msgBox, % runString
;	return
	
	Run, %runString%, %firefoxProfilesFolder%\%profileFolder%, Hide UseErrorLevel

	if(ErrorLevel == ERROR) {
		MsgBox, Error!
	}
	
	Send, ^w
}

; Straight from http://www.autohotkey.com/community/viewtopic.php?p=456075#p456075 .
FF_RetrievePageName() {
   DllCall("DdeInitializeW","UPtrP",idInst,"Uint",0,"Uint",0,"Uint",0)

   ; CP_WINANSI = 1004   CP_WINUNICODE = 1200
   hServer := DllCall("DdeCreateStringHandleW","UPtr",idInst,"Str","firefox","int",1200)
   hTopic  := DllCall("DdeCreateStringHandleW","UPtr",idInst,"Str","WWW_GetWindowInfo","int",1200)
   hItem   := DllCall("DdeCreateStringHandleW","UPtr",idInst,"Str","0xFFFFFFFF","int",1200)

   hConv := DllCall("DdeConnect","UPtr",idInst,"UPtr",hServer,"UPtr",hTopic,"Uint",0)
   ; CF_TEXT = 1      CF_UNICODETEXT = 13
   hData := DllCall("DdeClientTransaction","Uint",0,"Uint",0,"UPtr",hConv,"UPtr",hItem,"UInt",1,"Uint",0x20B0,"Uint",10000,"UPtrP",nResult)
   sData := DllCall("DdeAccessData","Uint",hData,"Uint",0,"str")

   DllCall("DdeFreeStringHandle","UPtr",idInst,"UPtr",hServer)
   DllCall("DdeFreeStringHandle","UPtr",idInst,"UPtr",hTopic)
   DllCall("DdeFreeStringHandle","UPtr",idInst,"UPtr",hItem)
   DllCall("DdeUnaccessData","UPtr",hData)
   DllCall("DdeFreeDataHandle","UPtr",hData)
   DllCall("DdeDisconnect","UPtr",hConv)
   DllCall("DdeUninitialize","UPtr",idInst)
   result:=StrGet(&sData,"cp0")
   return result
}

Return