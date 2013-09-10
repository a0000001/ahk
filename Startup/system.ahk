; === General system-related scripts. === ;


#Include System\KDE Mover-Sizer.ahk
#Include System\media.ahk

; Needed if there's not a mouse.
if(borgWhichMachine = THINKPAD) {
	#Include System\mouseWheelEmulator.ahk
}

#Include System\programLauncher.ahk
#Include System\screen.ahk
#Include System\volume.ahk
#Include System\window.ahk