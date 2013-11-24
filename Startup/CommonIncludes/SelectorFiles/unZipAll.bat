@ECHO OFF

REM Prompt user for password.
"A:\Outside Utilities\editv22\EditV32.exe" -m -p "Enter password to use for archives: " pass

REM Unzip the lot of them.
"C:\Program Files\7-Zip\7z.exe" e A:\Zipped\privateVariables.7z -oA:\Startup\CommonIncludes\ -aoa -p%pass%

"C:\Program Files\7-Zip\7z.exe" e A:\Zipped\emc2.7z -aoa -oA:\Startup\CommonIncludes\SelectorFiles\ -p%pass%
"C:\Program Files\7-Zip\7z.exe" e A:\Zipped\epicStudio.7z -aoa -oA:\Startup\CommonIncludes\SelectorFiles\ -p%pass%
"C:\Program Files\7-Zip\7z.exe" e A:\Zipped\hyperspace.7z -aoa -oA:\Startup\CommonIncludes\SelectorFiles\ -p%pass%
"C:\Program Files\7-Zip\7z.exe" e A:\Zipped\outlookTLG.7z -aoa -oA:\Startup\CommonIncludes\SelectorFiles\ -p%pass%
"C:\Program Files\7-Zip\7z.exe" e A:\Zipped\phone.7z -aoa -oA:\Startup\CommonIncludes\SelectorFiles\ -p%pass%
"C:\Program Files\7-Zip\7z.exe" e A:\Zipped\text.7z -aoa -oA:\Startup\CommonIncludes\SelectorFiles\ -p%pass%
"C:\Program Files\7-Zip\7z.exe" e A:\Zipped\tlg.7z -aoa -oA:\Startup\CommonIncludes\SelectorFiles\ -p%pass%

pause