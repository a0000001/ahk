; Things for git source control.

; File comparison constants.
global FC_NAME := 1
global FC_LOC := 2
global FC_REF_LOC := 3
global FC_ZIP_LOC := 4
global FC_ZIP_REF_LOC := 5

; Function to check what's changed against reference versions, and update them as needed.
; zipOrUnzip can be "u" or "z".
gitZipUnzip(zipOrUnzip, noRun = 1) {
	iniFile := "zipReferences.ini"
	
	lines := fileLinesToArray(iniFile)
	DEBUG.popup(debugGit, lines, "File lines")
	
	fileList := TableList.parseList(lines)
	DEBUG.popup(debugGit, fileList, "TableList")
	
	For i,f in fileList {
		if(zipOrUnzip = "z") {
			curr := f[FC_LOC]
			ref := f[FC_REF_LOC]
			currZip := f[FC_ZIP_LOC]
			refZip := f[FC_ZIP_REF_LOC]
		} else if(zipOrUnzip = "u") {
			currZip := f[FC_LOC]
			refZip := f[FC_REF_LOC]
			curr := f[FC_ZIP_LOC]
			ref := f[FC_ZIP_REF_LOC]
		} else if(zipOrUnzip = "b") {
; Something special here for both.
		}
		
		DEBUG.popup(debugGit, f[FC_NAME], "Name", curr, "Current", ref, "Reference", compareFiles(curr, ref), "Different")
		
		if(compareFiles(curr, ref)) {
		
; NOTE: GOOD OPPORTUNITY FOR MULTI-USE SELECTOR TEST/SETUP.

			; Do the zip/unzip operation to ensure that the newest version is where it needs to be.
			Selector.select("..\Selector\zip.ini", "DO_WAIT", f[FC_NAME] zipOrUnzip)
			
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
	
	return
}