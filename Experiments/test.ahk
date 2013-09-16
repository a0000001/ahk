#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force

blah := Object()

; if(blah["System Apps"]) {
	; MsgBox, jss
; }

blah["System Apps"] := 5
blah["System"] := 6

MsgBox, % blah._MaxIndex()

; if(blah["System Apps"]) {
	; MsgBox, fjfj
; }

; MsgBox, % blah["System Apps"]

; testIndex = "asdf asdf"

; MsgBox, % testIndex

; blah[testIndex] := 5

; MsgBox, % blah["asdf asdf"]

; blah["test test"] := 5
; MsgBox, % blah["test test"]