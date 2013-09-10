#SingleInstance force

; Based on http://www.autohotkey.com/forum/viewtopic.php?t=75491

; ------------------------- Menu Tray Icon ----------------------------
Menu, Tray, Icon, %A_WorkingDir%\hourglass.ico
;Menu, Tray, Add, showDestTime, Show Current Destination Time
;Menu, Tray, Default, showDestTime, Show Current Destination Time

Menu, tray, add  ; Creates a separator line.
Menu, tray, add, Show Destination Time, ShowDestTime  ; Creates a new menu item.
Menu, tray, Default, Show Destination Time

; ------------------------- Variables ----------------------------

devTemp := 0
reallyClose := 0
freezeDisplay := 0
ampmTime := 0
destTime := 0

guiid := 995
timer := 300
started := false
stoptime := A_NOW
half := false
updating := false

; colors and transparencies
c_transp_over := 230
c_transp_out := 0
col_timer = 00FF00
col_window = 000000

; guiWidth changes during execution.
guiWidth := 255
guiMargin := 13
tmpWidth := guiWidth - (guiMargin * 2)

; initial digit widths for h, m, s
hDigits := 3
mDigits := 3
sDigits := 2

; ------------------------- GUI ----------------------------

; First, get current window, to bring back to the top later.
WinGetTitle, prevWin, A

Gui, Color, %col_window%
Gui, +Toolwindow -Resize -SysMenu -Border -Caption +AlwaysOnTop +LastFound
WinGet, guiid, ID
WinSet, Transparent, %c_transp_out%

Gui, Font,c%col_timer% s40,Consolas
Gui, Add, Text, x%guiMargin% y10 w%tmpWidth% h50 vTimerText, 05:00


; ------------------------- SETUP TIMER (INITIALLY) ------------------------------------------

SysGet, MonArea, MonitorWorkArea
showx := MonAreaRight-guiWidth
showy := MonAreaBottom-75

; Command line stuff
if (%0%) {
   commandTime = %1%
} else {
	IniRead, commandTime, timer.ini, Main, LastTime
}

;---------------------------- Figure out what the input time was --------------------------------------------------------

;time is in seconds.
time := 0

StringGetPos, cPos, commandTime, `:
StringGetPos, pPos, commandTime, p
StringGetPos, aPos, commandTime, a
if(cPos > -1 || pPos > -1 || aPos > -1){
	; given a time instead - do that math
	
	destTime := commandTime
	
	ampmTime := 1
	
	; get am/pm bit
	StringRight, ampm, commandTime, 1
	if(ampm = "m"){
		StringTrimRight, commandTime, commandTime, 1
		StringRight, ampm, commandTime, 1
	}
	
	; cut off the am/pm bit, regardless of how it was.
	StringTrimRight, commandTime, commandTime, 1
	
	if(cPos > -1){	
		; time is colon'd
		StringLeft, hs, commandTime, cPos
		StringTrimLeft, commandTime, commandTime, cPos + 1
		
		StringLeft, ms, commandTime, 2
		StringTrimLeft, commandTime, commandTime, 2
	} else {
		; time is in another form, such as 1p for 1PM - all that should be left now is the hour.		
		hs := commandTime
	}
	
	; take care of AM/PM junk.
	if(ampm = "p" && hs != 12)
		hs += 12
	
	; add zeroes for things if they're missing.
	if(strlen(hs) = 0)
		hs := "00"
	if(strlen(ms) = 0)
		ms := "00"
	if(strlen(ss) = 0)
		ss := "00"		
	
	; add leading zeroes if needed
	if(strlen(hs) = 1)
		hs := "0" . hs
	if(strlen(ms) = 1)
		ms := "0" . ms
	if(strlen(ss) = 1)
		ss := "0" . ss
	
	targetTime := A_year A_mon A_mday hs ms ss
	temp3 := targetTime
	EnvSub, temp3, %A_now%, Seconds
	time := temp3
	
} else {
	; hours
	StringGetPos, hPos, commandTime, h
	StringLeft, hs, commandTime, hPos
	time += hs*60*60
	StringTrimLeft, commandTime, commandTime, hPos + 1

	; minutes
	StringGetPos, mPos, commandTime, m
	StringLeft, ms, commandTime, mPos
	time += ms*60
	StringTrimLeft, commandTime, commandTime, mPos + 1

	; seconds
	StringGetPos, sPos, commandTime, s
	StringLeft, ss, commandTime, sPos
	time += ss
	
	timerTemp := time
	
	; Construct destination time from it.
	tmpH := timerTemp // 60 // 60
	timerTemp := timerTemp - (tmpH * 60 * 60)

	tmpM := timerTemp // 60
	timerTemp := timerTemp - (tmpM * 60)
	
	tmpS := timerTemp
	
;	MsgBox, %tmpH%:%tmpM%:%tmpS%
}

timer := time
;MsgBox, %timer%

;----------------------- Show and Start ----------------------------------------

Gui, Show, W%guiWidth% H75 X%showx% Y%showy%

;Send, {Alt Down}{Tab}{Shift Down}{Tab}{Shift Up}{Alt Up}
WinActivate %prevWin%

GoSub, StartStop
GoSub, showhidetimer

Return

;-------------------- Show Timer --------------------

browser_refresh::
	GoSub showhidetimer
return

showhidetimer:
	GoSub, showtimer
	While GetKeyState("browser_refresh","P")
		Sleep, 1
	Sleep, 2050
	
	if (freezeDisplay == 0) {
		GoSub, hidetimer
	}
return

showtimer:
	hotkey, browser_refresh, off
	steps := (c_transp_over - c_transp_out) // 20
	trans := c_transp_out
	loop, %steps%
	{
		trans += 20
        WinSet, Transparent, %trans%, ahk_id %guiid%
        sleep, 20
    }
   WinSet, Transparent, %c_transp_over%, ahk_id %guiid%
   shown = 1
Return

hidetimer:
	 hotkey, browser_refresh, on
     steps := (c_transp_over - c_transp_out) // 10
     trans := c_transp_over
     loop, %steps%
     {
        trans -= 10
        WinSet, Transparent, %trans%, ahk_id %guiid%
        sleep, 10
     }
     WinSet, Transparent, %c_transp_out%, ahk_id %guiid%
	 shown = 0
Return

;----------------------------- Start and Stop Timer -------------------------------

browser_stop::
	GoSub StartStop	
	if(shown){
		Sleep, 1000
		GoSub, hidetimer
	} else {
		GoSub, showtimer
	}
return

StartStop:
   half := false
   updating := false
   GuiControl, Text, Working,
   if (started) {
      started := false
      SetTimer, cycledown, OFF
   } else {
      started := true
      stoptime := A_NOW
      envAdd, stoptime, %timer%, S
      SetTimer, cycledown, 500
      goto cycledown
   }
Return

; ----------------- Update Label -----------------------------

UpdateTimerLabel:

	if (freezeDisplay == 1) {
		return
	}

	; getting hrs/mins/secs   
	timerTemp := timer

	tmpH := timerTemp // 60 // 60
	timerTemp := timerTemp - (tmpH * 60 * 60)

	tmpM := timerTemp // 60
	timerTemp := timerTemp - (tmpM * 60)
	
	tmpS := timerTemp

	;MsgBox, %tmpH%:%tmpM%:%tmpS%
	
	tmpstr  := ""
	
	if(tmpH != 0 || tmpM != 0 || tmpS != 0){
		if(tmpH == 0) {
			; don't add anything.
			hDigits := 0
		} else {
			if(tmpH < 10) {
				hDigits := 2	
			} else {
				hDigits := strlen(tmpH) + 1
			}
			; add number, one or two digits.
			tmpstr := tmpstr . tmpH . ":"
		}

		if(tmpM == 0) {
			; don't add anything, unless hours exist.
			if (tmpH == 0) {
				mDigits := 0
			} else {
				mDigits := 3
				tmpstr := tmpstr . "00:"
			}
		} else if (tmpM < 10) {
			; 1-digit minute values. Keep extra 0 if hours exist.
			if (tmpH == 0) {
				mDigits := 2
				tmpstr := tmpstr . tmpM . ":"
			} else {
				mDigits := 3
				tmpstr := tmpstr . "0" . tmpM . ":"
			}
		} else {
			; normal, 2-digit minute values.
			mDigits := 3
			tmpstr := tmpstr . tmpM . ":"
		}
		
		if (tmpS < 10) {
			; 1-digit second values. Keep extra 0 if minutes exist.
			if (tmpM == 0) {
				sDigits := 1
				tmpstr := tmpstr . tmpS
			} else {
				sDigits := 2
				tmpstr := tmpstr . "0" . tmpS
			}
		} else {
			; normal, 2-digit second values.
			sDigits := 2
			tmpstr := tmpstr . tmpS
		}   
	}
	
	; set guiWidth based on digit widths.
	totalDigits := hDigits + mDigits + sDigits
	
	;MsgBox, %hDigits% %mDigits% %sDigits% %totalDigits%
	;MsgBox, %tmpH% %tmpM% %tmpS%
	;MsgBox, %tmpstr%
	
	tmpWidth := totalDigits * 29
	guiWidth := tmpWidth + (guiMargin * 2)

	if(devTemp == 0){
;		MsgBox, %totalDigits% %tmpWidth% %guiWidth%
		devTemp += 1
	}
	
	showx := MonAreaRight-guiWidth
	showy := MonAreaBottom-75
	
	Gui, Show, NoActivate W%guiWidth% H75 X%showx% Y%showy%
   
	GuiControl, Text, TimerText, %tmpstr%
	GuiControl, Move, TimerText, x%guiMargin% y10 w%tmpWidth% h50
	
Return

; ----------------- Actual Work / Cycles -----------------------------

cycledown:
	if (updating)
		Return
	timer := stoptime
	EnvSub timer, A_Now, S
	GoSub UpdateTimerLabel
	If (A_Now >= stoptime) {
		reallyClose := 1
	
		GuiControl, Text, TimerText, Timer Finished
		GuiControl, Move, TimerText, x%guiMargin% y10 w410 h50
		
		showx := MonAreaRight - 430
		showy := MonAreaBottom - 75
		Gui, Show, NoActivate W430 H75 X%showx% Y%showy%
		
		WinSet, Transparent, %c_transp_over%, ahk_id %guiid%
		
		loop 3{
			SoundPlay, Windows Logoff Sound.wav
			Sleep, 2450
		}
		
		Gui, Show, W430 H75 center
		Pause
	}
Return

;---------------------- Clean-Up -------------------------

gtfo:
ExitApp

ShowDestTime:
	MsgBox, Current Destination Time is: %destTime%
	MsgBox, Current Remaining Time is: %tmpstr%
return

GuiEscape:
GuiClose:
ExitApp

;Shift+Alt+X = Exit + warning, in case closing other scripts and this one unintentionally.
~+!x::
	if (reallyClose == 0) {
	
		GuiControl, Text, TimerText, Close Timer?
		GuiControl, Move, TimerText, x%guiMargin% y10 w350 h50
	
		Gui, Show, W370 H75 center
		WinSet, Transparent, %c_transp_over%, ahk_id %guiid%
		
		reallyClose := 1
		freezeDisplay := 1
		
	} else {
		ExitApp
	}
return

; ~+!r::
	; Sleep, 100
	; tempStoreTime = %1%
	; if (ampmTime == 0) {
		; tempStoreTime = %timer%s
	; }
	; IniWrite, %tempStoreTime%, timer.ini, Main, LastTime	
	; Run, G:\Scripts\timer\timer.ahk
; return

#ifWinActive, ahk_class AutoHotkeyGUI

Esc::
	reallyClose := 0
	freezeDisplay := 0
	
	Sleep, 2050
	GoSub, hidetimer
return

#ifWinActive