@ECHO OFF

REM Prompt user for password.^
"..\Outside Utilities\editv22\EditV64.exe" -m -p "Enter password to use for archives: " pass

REM Unzip the lot of them.^
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\privateVariables.7z -o..\Startup\CommonIncludes\ -aoa -p%pass%

"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\emc2.7z -aoa -p%pass%
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\epicStudio.7z -aoa -p%pass%
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\hyperspace.7z -aoa -p%pass%
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\phone.7z -aoa -p%pass%
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\text.7z -aoa -p%pass%
"C:\Program Files\7-Zip\7z.exe" e ..\Zipped\tlg.7z -aoa -p%pass%