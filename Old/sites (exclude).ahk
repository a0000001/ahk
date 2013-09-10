; Auto-Execute
	facebookAllowed := 1
return

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

; uses menu (dropdown) key to simulate ctrl shift alt, for one-handed use.
AppsKey::
	send {Ctrl Down}{Shift Down}{Alt Down}	
	sleep, 1000
	send {Ctrl Up}{Shift Up}{Alt Up}
return

;Here if needed: for instant, hold-down-only hotkeys for above.
;AppsKey Up::
;	send {Ctrl Up}{Shift Up}{Alt Up}
;return

; Sets or unsets facebookAllowed.
;^+\::
;	if(facebookAllowed){
;		facebookAllowed := 0
;		MsgBox, Facebook disabled.
;		MsgBox, Remember Digsby!
;	} else {
;		facebookAllowed := 1
;		MsgBox, Facebook enabled.
;		MsgBox, Remember Digsby!
;	}
;return

; Sites: Runs all usual sites.

openAll(facebookAllowed = 1, inPlace = 0) {	
	if(facebookAllowed) {
		openAndCloseEmptyTab("http://www.facebook.com/", inPlace)
		openNewTab("https://mail.google.com/mail/")
	} else {
		openAndCloseEmptyTab("https://mail.google.com/mail", inPlace)
	}
	openNewTab("http://www.google.com/calendar/render")
	openNewTab("https://www.google.com/reader/")
	
	Loop, 3
	{
		Send, ^+{Tab}
	}
}

^+!a::openAll(facebookAllowed)
#^+!a::openAll(facebookAllowed, 1)

openFacebook(facebookAllowed = 1, inPlace = 0) {
	if(facebookAllowed){
		openAndCloseEmptyTab("http://www.facebook.com/", inPlace)
	}
}

; Facebook
+!f::openFacebook(facebookAllowed)
#+!f::openFacebook(facebookAllowed, 1)

; Gmail
^+!m::openAndCloseEmptyTab("https://mail.google.com/mail/")
$#^+!m::openAndCloseEmptyTab("https://mail.google.com/mail/", 1)	; AHK has issues getting this - probably from windows. Oh well. $ did it.

; Google Calendar
^+!c::openAndCloseEmptyTab("http://www.google.com/calendar/render")
#^+!c::openAndCloseEmptyTab("http://www.google.com/calendar/render", 1)

; Google Reader
^+!r::openAndCloseEmptyTab("https://www.google.com/reader/")
#^+!r::openAndCloseEmptyTab("https://www.google.com/reader/", 1)

openWeather(inPlace = 0) {
	openAndCloseEmptyTab("http://www.wunderground.com/cgi-bin/findweather/getForecast?query=27106", inPlace)	; WFU
;	openAndCloseEmptyTab("http://www.wunderground.com/cgi-bin/findweather/getForecast?query=27712", inPlace)	; Durham
;	openAndCloseEmptyTab("http://www.wunderground.com/global/stations/94767.html", inPlace)	; Sydney
	; openAndCloseEmptyTab("http://www.wunderground.com/cgi-bin/findweather/getForecast?query=53562", inPlace) ; Madison
}

; Weather
^+!w::openWeather()
#^+!w::openWeather(1)

; Lastpass
^+!l::openAndCloseEmptyTab("chrome://lastpass/content/home.xul", 0)
#^+!l::openAndCloseEmptyTab("chrome://lastpass/content/home.xul", 1)

openNewTab(url)
{
	; Activate Firefox.
	activateByName("Mozilla Firefox")
	
	; New tab.
	Send, ^t
	Sleep, 100
	
	; Location bar, url, keep autocomplete stuff off the end, go.
	Send, ^l	
	clipboard := url	
	Send, ^v	
	Sleep, 100	
	Send, {Delete}{Enter}
}

openAndCloseEmptyTab(url, inPlace = 0){
	; Send {Ctrl Up}{Shift Up}{Alt Up}
	close := 0
	
	; Activate Firefox.
	activateByName("Mozilla Firefox")
	
	; If we need to go to end, go to end.
	if(!inPlace) {
		Send ^9
		Sleep, 100
	}
	
	; See if the tab is blank.
	currentURL := FF_GetCleanURL()
	if(currentURL == "about:blank") {
		close := 1
	}
	
	; Open a new tab.
	openNewTab(url)
	
	; Close the the previous tab, as needed.
	if(close) {
		Send ^+{Tab}
		Send ^w
	}
}