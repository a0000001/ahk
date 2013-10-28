#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#NoTrayIcon
#SingleInstance force

;;Spanish letters

;lowercase
RShift & a::Send, á
RShift & e::Send é
RShift & i::Send í
RShift & o::Send ó
RShift & u::Send ú
RShift & n::Send ñ

;uppercase
RCtrl & a::Send Á
RControl & e::Send É
RControl & i::Send Í
RControl & o::Send Ó
RControl & u::Send Ú
RControl & n::Send Ñ

;punctuation
RShift & !::Send ¡
RShift & ?::Send ¿

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload