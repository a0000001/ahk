DetectHiddenText, On ; the url of the active Chrome window is hidden text...
SetTitleMatchMode, Slow ; ...we also need match mode 'slow' to detect it
; activate chrome window,
; just for demonstation:
WinActivate, ahk_class Chrome_WidgetWin_1
IfWinActive, ahk_class Chrome_WidgetWin_1 ; we only want to check for the hidden text if Chrome is the active window,
{
WinGetText, wintext, ahk_class Chrome_WidgetWin_1 ; if it is we grab the text from the window...
If InStr(wintext,"autohotkey.com")	 ;		 ...and if it contains a url that we want,
{
;### code conditional on url goes here ###
msgbox % "The active Chrome window is on the autohotkey.com domain! The page title and URL is:`n`n>" wintext								 ; <<== we run the desired code here.
}
}
exitapp