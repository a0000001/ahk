; Script for easy access to zipping/unzipping private variables password-protected archive.

RunString := ""

Loop {
	InputBox, UserInput, Zip/Unzip private AHK vars, Zip or Unzip privateVariables.ahk?, , 380, 170
	
	if(UserInput == "" || ErrorLevel){
		break
	} else if(UserInput = "z" || UserInput = "zip") {
		; MsgBox, zip
		RunString = "C:\Program Files\7-Zip\7z.exe" u privateVariables.7z privateVariables.ahk -p
	} else if(UserInput = "u" || UserInput = "unzip") {
		; MsgBox, unzip
		RunString = "C:\Program Files\7-Zip\7z.exe" e privateVariables.7z -aoa
	}
	
	if(RunString != "") {
		; MsgBox, running %UserInput%
		Run, %RunString%
		break
	}
}

ExitApp

Esc::
	Gui, Destroy
	ExitApp
return







; MsgBox, % RunString

