@ECHO OFF

REM Prompt user for password.
"A:\Outside Utilities\editv22\EditV32.exe" -m -p "Enter password to use for archives: " pass

REM Zip the lot of them up.
"C:\Program Files\7-Zip\7z.exe" u A:\Zipped\privateVariables.7z A:\Startup\CommonIncludes\privateVariables.ahk -p%pass%

"C:\Program Files\7-Zip\7z.exe" u A:\Zipped\emc2.7z A:\Startup\CommonIncludes\SelectorFiles\emc2.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u A:\Zipped\epicStudio.7z A:\Startup\CommonIncludes\SelectorFiles\epicStudio.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u A:\Zipped\hyperspace.7z A:\Startup\CommonIncludes\SelectorFiles\hyperspace.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u A:\Zipped\outlookTLG.7z A:\Startup\CommonIncludes\SelectorFiles\outlookTLG.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u A:\Zipped\phone.7z A:\Startup\CommonIncludes\SelectorFiles\phone.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u A:\Zipped\text.7z A:\Startup\CommonIncludes\SelectorFiles\text.ini -p%pass%
"C:\Program Files\7-Zip\7z.exe" u A:\Zipped\tlg.7z A:\Startup\CommonIncludes\SelectorFiles\tlg.ini -p%pass%

pause