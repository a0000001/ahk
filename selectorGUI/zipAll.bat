@ECHO OFF

REM Prompt user for password.^
"..\Outside Utilities\editv22\EditV64.exe" -m -p "Enter password to use for archives: " pass

REM Zip the lot of them up.^
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\privateVariables.7z ..\Startup\CommonIncludes\privateVariables.ahk -p%pass%
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\tlgNumbers.7z tlgNumbers.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\phoneNumbers.7z phoneNumbers.ini -p%pass%