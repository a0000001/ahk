#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

#Include ..\Startup\commonIncludesStandalone.ahk

global FC_NAME := 1
global FC_LOC := 2
global FC_REF_LOC := 3
global FC_ZIP_LOC := 4
global FC_ZIP_REF_LOC := 5

gitZipUnzip(unzip) {
	iniFile := "zipReferences.ini"
	
	if(unzip) {
		postFix := "u"
	} else {
		postFix := "z"
	}
	
	lines := fileLinesToArray(iniFile)
	; MsgBox, % arrayToDebugString(lines)
	
	fileList := cleanParseList(lines)
	; MsgBox, % arrayToDebugString(list, 2)
	
	For i,f in fileList {
		curr := f[FC_LOC]
		ref := f[FC_REF_LOC]
		currZip := f[FC_ZIP_LOC]
		refZip := f[FC_ZIP_REF_LOC]
		; MsgBox, % f[FC_NAME] "`n" curr "`n" ref "`n" compareFiles(curr, ref)
		if(compareFiles(curr, ref)) {
		
; NOTE: GOOD OPPORTUNITY FOR MULTI-USE SELECTOR TEST/SETUP.

			; Do the zip/unzip operation to ensure that the newest version is where it needs to be.
			Selector.select("..\Selector\zip.ini", "RUNWAIT", f[FC_NAME] postFix)
			
			; Update the reference versions of the file(s).
			if(SubStr(curr, 1, 1) = "*") {
				StringTrimLeft, curr, curr, 1
				files := specialSplit(curr, A_Space)
				refFiles := specialSplit(ref, A_Space)
				
				For j,file in files {
					currRefFile := refFiles[j]
					FileCopy, %file%, %currRefFile%, 1
				}
			} else {
				FileCopy, %curr%, %ref%, 1
			}
			
			; Update the ref version of the zip.
			FileCopy, %currZip%, %refZip%, 1
		}
	}
}

^a::
	gitZipUnzip(0)
	; gitZipUnzip(1)
return