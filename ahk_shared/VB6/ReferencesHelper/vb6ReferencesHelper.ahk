/*
Author: Gavin Borg
Description: Allows for searching for a single reference within the list, or selecting a number of them.
Installation: Copy this containing folder (ReferencesHelper) to your desktop and run the .ahk file within.
Shortcuts:
	Ctrl+F:
		Will prompt you for a reference to scroll to.
		Enter the full name of the references and press Enter to have the script scroll to that reference.
		For convenience, you may use “*” instead of “Epic Systems” to save keystrokes.
	Ctrl+A:
		Will ask you to select a text file to read the list of references from.
Notes:
	If you run VB6 as an admin, you need to also run AutoHotkey.exe (typically in C:\Program Files\AutoHotkey\) as an admin as well.
		Failing to do so will result in this script not appearing to work at all.
	The simplest form that the input file can be in is a list of the full name of each reference, one per line.
	Further details and formats for the list file can be found in “vbReferenceSelectorInputFormat.txt” in this folder, along with other examples in the other .txt files there.
	Note that the script will finish considerably more quickly if the list is in alphabetical order.

*/

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
; #NoTrayIcon ; Uncomment to hide the tray icon.

convertStarToES(string) {
	StringReplace, string, string, * , Epic Systems , All
	; MsgBox, % string
	return string
}

expandReferenceLine(input, prepend = "", postpend = "") {
	; MsgBox, Expanding `nPre: %prepend% `nInput: %input% `nApp: %postpend%
	return prepend . input . postpend
}

; References window.
#IfWinActive, References - 
	^f::
		SAME_THRESHOLD := 10
		
		InputBox, userIn, Partial Search, Please enter the first portion of the row to find. You may replace "Epic Systems " with "* "
		if(ErrorLevel) {
			return
		}
		
		userIn := convertStarToES(userIn)
		
		prevRow := ""
		prevLine := ""
		numSame := 1
		notFoundYet := true
		
		currLine := userIn
		currLen := StrLen(userIn)
		
		; MsgBox, % currLen
		
		ControlGetText, currRow, Button5, A
		if(currLine < currRow) {
			Send, {Home}
		}
		
		firstChar := SubStr(currLine, 1, 1)
		; MsgBox, % firstChar
		
		; MsgBox, % currLine
		
		; Loop downwards through lines.
		While, notFoundYet {
			SendRaw, %firstChar%
			
			Sleep, 1
			ControlGetText, currRow, Button5, A
			; MsgBox, %currRow%
			
			; This block controls for the end of the listbox, it stops when the last SAME_THRESHOLD rows are the same.
			if(currRow = prevRow) {
				numSame++
			} else {
				numSame := 1
			}
			; MsgBox, Row: %currRow% `nPrevious: %prevRow% `nnumSame: %numSame%
			if(numSame = SAME_THRESHOLD) { ; Pretty sure we're at the end now, finish.
				notFoundYet := false
			}
			
			prevRow := currRow
			
			; If it matches our input, finish.
			if(SubStr(currRow, 1, currLen) = currLine) {
				notFoundYet := false
			}
		}
		
	return

	^a::
		SAME_THRESHOLD := 10
		
		currPrepend := ""
		currPostpend := ""
		
		prevRow := ""
		prevLine := ""
		numSame := 1
		
		textOut := ""
		
		FileSelectFile, fileName
		
		; Read in the list of names.
		Loop, Read, %fileName%
		{
			notFoundYet := true
			
			; Clean off leading tab if it exists.
			cleanLine := A_LoopReadLine
			if(SubStr(cleanLine, 1, 1) = A_Tab) {
				StringTrimLeft, cleanLine, cleanLine, 1
			}
			
			; Ignore blank and 'commented' lines.
			if(cleanLine != "" && Substr(cleanLine, 1, 2) != "//") {
				
				; MsgBox, %cleanLine%
				
				; Special begin prepend/postpend block line.
				if(SubStr(cleanLine, 1, 2) = "[ ") {
					currPrepend := ""
					currPostpend := ""
					params1 := ""
					params2 := ""
					
					StringSplit, params, A_LoopReadLine, |
					
					; First parameter.
					paramChar := SubStr(params1, 3, 1) ; Starting at 3 and 4 to cut out the "[ "
					paramValue := SubStr(params1, 4)
					if(paramChar = "b") {
						currPrepend := paramValue
					} else if(paramChar = "e") {
						currPostpend := paramValue
					}
					
					; Second parameter.
					if(params2) {
						paramChar := SubStr(params2, 1, 1)
						paramValue := SubStr(params2, 2)
						if(paramChar = "b") {
							currPrepend := paramValue
						} else if(paramChar = "e") {
							currPostpend := paramValue
						}
					}
				
				; Special end block line.
				} else if(SubStr(cleanLine,1,1) = "]") {
					currPrepend := ""
					currPostpend := ""
					; MsgBox, wiped.
				
				; A true line to do things to! Yay!
				} else {
					
					; MsgBox, Pre: %currPrepend%z `nPost: %currPostpend%
				
					; Clean lineArr2 in case it isn't in next line.
					lineArr2 := 0
					
					; MsgBox, %cleanLine%
					StringSplit, lineArr, cleanLine, %A_Tab%
					
					; currLine := convertStarToES(lineArr1)
					currLine := expandReferenceLine(lineArr1, currPrepend, currPostpend)
					num := lineArr2
					
					; MsgBox, Pre: `n%currPrepend% `n`nPost: `n%currPostpend% `n`nIn: `n%cleanLine% `n`nOut: `n%currLine% `n`nNum: `n%num%
					textOut := textOut . currLine . "`n"
					
					firstChar := SubStr(currLine, 1, 1)
					; MsgBox, First Char: %firstChar%
					
;					MsgBox, Found: `n%prevSearch% `n`nNext: `n%currLine%
					
					if(currLine < currRow) {
						Send, {Home}
					}
					
					; Loop downwards through lines.
					While, notFoundYet {
						SendRaw, %firstChar%
						
						Sleep, 1
						ControlGetText, currRow, Button5, A
						; MsgBox, %currRow%
						
						; This block controls for the end of the listbox, it stops when the last SAME_THRESHOLD rows are the same.
						if(currRow = prevRow) {
							numSame++
						} else {
							numSame := 1
						}
						; MsgBox, Row: %currRow% `nPrevious: %prevRow% `nnumSame: %numSame%
						if(numSame = SAME_THRESHOLD) { ; Pretty sure we're at the end now, finish.
							notFoundYet := false
						}
						
						prevRow := currRow
						
						; If it matches our input, check it.
						if(currRow = currLine) {
							; If we've got the additional argument, push down a few more before selecting.
							if(num) {
								num--
								Send, {Down %num%}
							}
							
							Send, {Space}
							notFoundYet := false
						}
						
					}
					notFoundYet := true
					prevLine := currLine
					
					prevSearch := currLine
				}
			}
		}
		
		MsgBox, % textOut
	return
#IfWinActive