@ECHO OFF

REM Prompt user for password.^
"..\Outside Utilities\editv22\EditV64.exe" -m -p "Enter password to use for archives: " pass

REM Unzip the lot of them.^
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\privateVariables.7z -o..\Startup\CommonIncludes\ -aoa -p%pass%
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\tlgNumbers.7z -aoa -p%pass%
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\phoneNumbers.7z -aoa -p%pass%