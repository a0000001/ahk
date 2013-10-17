; Graphics-related functions.

; Finds coordinates of all instances of a given image.
FindImageCoordsWithinArea(imagePath, X, Y, W, H) {
	global iSearch_imageSpacingTolerance
	
	; MsgBox, %X% %Y% %W% %H%
	
	; Find image onscreen. Note that *TransWhite means that a full-white transparent color can match anything.
	ImageSearch, outX, outY, X, Y, W, H, *TransWhite %imagePath%
	
	if(ErrorLevel = 0) { ; We found something, store and recurse!
		; CoordMode, Mouse, Relative
		; MouseMove, %outX%, %outY%
		; CoordMode, Mouse, Screen
		; MsgBox, %ErrorLevel% Found image at (%outX%, %outY%).
		
		outStr = %outX%-%outY%
		firstXY := FindImageCoordsWithinArea(imagePath, outX + iSearch_imageSpacingTolerance, outY, W, H)
		secondXY := FindImageCoordsWithinArea(imagePath, X, outY + iSearch_imageSpacingTolerance, outX, H)
		
		if(firstXY != "") {
			outStr = %outStr%.%firstXY%
		}
		
		if(secondXY != "") {
			outStr = %outStr%.%secondXY%
		}
	} else {
		outStr := ""
		; MsgBox, Nuttin': %ErrorLevel%
	}
	
	return outStr
}

; Clicks on the found instance of the image with the given class.
ClickWhereFindImage(imagePath, nnClass = "") {
	WinGetPos, X, Y, width, height, A
	; MsgBox, %X% %Y% %width% %height%
	
	coords := FindImageCoordsWithinArea(imagePath, X, Y, width, height)
	; MsgBox, % coords
	
	RegExReplace(coords, "\.", "", periodCount)
	coordsCount := periodCount + 1
	; MsgBox, % coordsCount
	
	; Split the coords into a 2-dimensional array. (pointNum, X/Y)
	StringSplit, splitCoords, coords, .
	Loop, %coordsCount% {
		StringSplit, splitCoords%A_Index%_, splitCoords%A_Index%, -
	}
	; MsgBox, % splitCoords1_1 " " splitCoords1_2
	
	; Store the old mouse position to move back to once we're finished.
	MouseGetPos, prevX, prevY
	
	; ImageSearch gives us back x and y based on the current window, so the mouse should move based on that, too.
	CoordMode, Mouse, Relative
	
	; Split up the given classNN argument by spaces.
	RegExReplace(nnClass, " ", "", classCount)
	classCount++
	
	; MsgBox, %nnClass% %classCount%
	
	StringSplit, classArr, nnClass, %A_Space%
	
	; MsgBox, % classArr1
	
	; Loop over the given coordinates, move the mouse there, and use mousegetpos to get the class of the control.
	Loop, %coordsCount% {
		MouseMove, splitCoords%A_Index%_1, splitCoords%A_Index%_2
		; MsgBox, % splitCoords%A_Index%_1 ", " splitCoords%A_Index%_2
		
		MouseGetPos, , , , controlNN
		; MsgBox, %imagePath% %ErrorLevel% %controlNN%
		
		; If it matches the given control, be done.
		Loop, %classCount% {
			; MsgBox, % A_Index classArr%A_Index% controlNN
			if(controlNN = classArr%A_Index% || classArr1 = "") {
				; MsgBox, % "Match found at " splitCoords%A_Index%_1 ", " splitCoords%A_Index%_2 "!"
				foundOne := true
				break
			}
		}
			
		if(foundOne) {
			break
		}
	}
	
	; Restore this for other scripts' sake.
	CoordMode, Mouse, Screen
	
	; MsgBox, % foundOne
	
	if(foundOne) {
		; Click the control!
		Send, {Click}
	}
	
	; Move the mouse back to its former position.
	MouseMove, prevX, prevY
	
	return foundOne
}