#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

i := 0
; dataByGroups := Object()
executorData := Object()
currKeyword := ""
badKey := "ahk_blank"

; i := 40

; Get Setup and History, too.
IniRead, setup, executorDev.ini, Setup, , %badKey%
IniRead, history, executorDev.ini, History, , %badKey%


IniRead, currKeyword, executorDev.ini, W%i%, keywords, %badKey%
IniRead, currCommand, executorDev.ini, W%i%, command, %badKey%
IniRead, currComment,  executorDev.ini, W%i%, comment, %badKey%
IniRead, currKey, executorDev.ini, W%i%, key, %badKey%
IniRead, currKeymod, executorDev.ini, W%i%, keymod, %badKey%
IniRead, currGroup, executorDev.ini, W%i%, group, %badKey%

; Wrap it all in quotes.
; currKeyword = "%currKeyword%" ; Opting not to wrap keyword, it can't contain spaces anyway.
currCommand = "%currCommand%"
currComment = "%currComment%"
currKey = "%currKey%"
currKeymod = "%currKeymod%"
currGroup = "%currGroup%"

; MsgBox, % currKey
; MsgBox, "%badKey%"

; dataByGroups[currGroup, "keyword"] := currKeyword
; dataByGroups[currGroup, "command"] := currCommand
; dataByGroups[currGroup, "comment"] := currComment
; dataByGroups[currGroup, "key"] := currKey
; dataByGroups[currGroup, "keyMod"] := currKeymod

; testSysApps = "System Apps"
; MsgBox, % dataByGroups[testSysApps, "keyword"]
	
; return

while(currKeyword != badKey) {
	; keywords%i% := currKeyword
	; commands%i% := currCommand
	; comments%i% := currComment
	; keys%i% := currKey
	; keymods%i% := currKeymod
	; groups%i% := currGroup
	
	; if(!dataByGroups[currGroup]) {
		; dataByGroups[currGroup] := Object()
	; }
	
	executorData[i] = Object()
	executorData[i, "keyword"] := currKeyword
	executorData[i, "command"] := currCommand
	executorData[i, "comment"] := currComment
	executorData[i, "key"] := currKey
	executorData[i, "keymod"] := curKeymod
	executorData[i, "group"] := currGroup
	
	; dataByGroups[currGroup, currKeyword] := Object()
	; ; dataByGroups[currGroup, currKeyword, "keyword"] := currKeyword
	; dataByGroups[currGroup, currKeyword, "command"] := currCommand
	; dataByGroups[currGroup, currKeyword, "comment"] := currComment
	; dataByGroups[currGroup, currKeyword, "key"] := currKey
	; dataByGroups[currGroup, currKeyword, "keyMod"] := currKeymod
	
	; MsgBox, %currKeyword% "ahk_blank"
	; if(currKeyword = "ahk_blank") {
		; MsgBox, asdf
	; }
	
	i++
	; i += 100
	
	IniRead, currKeyword, executorDev.ini, W%i%, keywords, %badKey%
	IniRead, currCommand, executorDev.ini, W%i%, command, %badKey%
	IniRead, currComment,  executorDev.ini, W%i%, comment, %badKey%
	IniRead, currKey, executorDev.ini, W%i%, key, %badKey%
	IniRead, currKeymod, executorDev.ini, W%i%, keymod, %badKey%
	IniRead, currGroup, executorDev.ini, W%i%, group, %badKey%
	
	; Wrap it all in quotes.
	; currKeyword = "%currKeyword%"
	currCommand = "%currCommand%"
	currComment = "%currComment%"
	currKey = "%currKey%"
	currKeymod = "%currKeymod%"
	currGroup = "%currGroup%"
}

; So now we have a data structure that holds everything from the ini file. Now, divide it up by groups...
dataByGroups := Object()
groups := Object()
groupCounts := Object()
numGroups := 0
i := 0
while(i <= executorData._MaxIndex()) {
	currGroup := executorData[i, "group"]
	
	if(!dataByGroups[currGroup]) {
		dataByGroups[currGroup] := Object()
		groups[numGroups] := currGroup
		groupCounts[currGroup] := 1
		numGroups++
	}
	
	dataByGroups[currGroup, 
	
	
	i++
}


; grp = "System Apps"
; keyword = "flux"

; MsgBox, % dataByGroups[grp, keyword, "command"]

MsgBox, % executorData[5, "keyword"]
MsgBox, % executorData._MaxIndex()


; numKeywords := i - 1

; array1 := Object()
; array1[""] := "a"

; MsgBox, % array1[""]

; MsgBox, % numKeywords
; MsgBox, % setup
; MsgBox, % history
; MsgBox, % keywords0
; MsgBox, % keys0

