; Mikal Hotkey Override
#+m::#+n

#ifWinActive, ahk_class Miranda

; Kill skype when we go offline in miranda - it freaks the frack out otherwise.
;~^0::
;	Sleep, 1000
;	process, close, Skype.exe
;return

#ifWinActive