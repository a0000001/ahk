; Note: the #noTrayIcon is in appKiller.ahk

; @MyWorkingDir:
; Sets the "working directory" of the running script
MyWorkingDir = G:\Scripts\Startup

partOfAutoInclude := 1

; @IncludeFolders:
; A list of all the folders to search:
StartUp := MyWorkingDir
IncludeFolders = 
(comments ltrim
	%Startup%\ProgramSpecific
	%StartUp%\Includes
	%StartUp%
)
; @IncludeOrCombine:
; Determines if the output script will be 
; a list of "#Include"d files, or 
; a single file with the text from all files
; combined.
IncludeOrCombine = INCLUDE 
; IncludeOrCombine = COMBINE



; End of the customizable section








TempFileName = %A_Temp%\AutoInclude.ahk

;Let's collect all the Auto-Execute lines from each file,
;as well as all the code from each file, 
;and create a new script that includes all of them!

InitializeFunctions = 
IncludeFiles = 

;We have to "Split" the folders list for each line:
Loop Parse, IncludeFolders, `n
{
	IncludeFolder := A_LoopField
	;Set the Include Path:
	IncludeFiles =
	(ltrim
									%IncludeFiles%
									
									#Include %IncludeFolder%
									;The following files were found in this Include folder:
	)

	;Let's load all the files from the folder:
	SetWorkingDir %IncludeFolder%
	Loop *.ahk,0,1 ;recursive
	{
		; Ignore any files with "exclude" in the title:
		If RegexMatch(A_LoopFileFullPath, "i)\bEXCLUDE\b")
			continue
	
		; We are going to create an "#Include" directive for each file, but just in case
		; there is an auto-execute initialize function, let's be sure to copy that.

		FirstLineOfFile =
		FileReadLine FirstLineOfFile, %A_LoopFileFullPath%, 1
		
		;See if the line is an "Init":
		IfInString FirstLineOfFile, _init( 
		{
			InitializeFunctions = 
			(ltrim 
										%InitializeFunctions%
										%FirstLineOfFile%
			)
		}
		If RegexMatch(FirstLineOfFile, "i);.*auto.*execute") {
			; Create a label:
			label := A_LoopFileFullPath
			label := RegExReplace(label, "[-+'=,.!$#() `t\^[\]\\]", "_") ; Replace all filename characters that are not valid for labels
			InitializeFunctions =
			(ltrim
										%InitializeFunctions%
										GoSub %label%_Init ; Run the Auto-Execute code for this file
			)
			IncludeFiles =
			(ltrim
									%IncludeFiles%
									%label%_Init: ; Run the Auto-Execute code for this file
			)
		}
		

		If IncludeOrCombine = COMBINE
		{	FileRead FullFile, %A_LoopFileFullPath%
			IncludeFiles = 
			(ltrim
										%IncludeFiles%
										
										; #############################################################################
										; ###################################### Beginning of file %A_LoopFileFullPath%
										; #############################################################################
										%FullFile%
										; #############################################################################
										; ###################################### End Of File %A_LoopFileFullPath%
										; #############################################################################
			)
		} Else {	
			IncludeFiles = 
			(ltrim
										%IncludeFiles%
										#Include %A_LoopFileFullPath%
			)
		}
	}
}	
	

FileDelete %TempFileName%
;Create our new file:
FileAppend ,
(ltrim
									;This file was automatically created from all the scripts found in the IncludeFolder
									#SingleInstance Force

									;#noTrayIcon
									Menu, Tray, Icon, Icons\all.ico
									
									;The following Initialize functions were extracted from their corresponding #Include files:
										%InitializeFunctions%
									SetWorkingDir %MyWorkingDir%
									return ;this will guarantee that no AutoExecute code will be called

									%IncludeFiles%
)
, %TempFileName%
Run %TempFileName%