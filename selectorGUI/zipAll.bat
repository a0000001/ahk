@ECHO OFF

REM Prompt user for password.^
"..\Outside Utilities\editv22\EditV64.exe" -m -p "Enter password to use for archives: " pass

REM Zip the lot of them up.^
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\privateVariables.7z ..\Startup\CommonIncludes\privateVariables.ahk -p%pass%

"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\emc2.7z emc2.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\epicStudio.7z epicStudio.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\hyperspace.7z hyperspace.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\outlookTLG.7z outlookTLG.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\phone.7z phone.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\text.7z text.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u ..\Zipped\tlg.7z tlg.ini -p%pass%