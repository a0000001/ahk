﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;#NoTrayIcon

; note to self: this must be in UTF-8 encoding.


;; Spanish letters

; Lowercase
RAlt & a::Send, á
RAlt & e::Send é
RAlt & i::Send í
RAlt & o::Send ó
RAlt & u::Send ú
RAlt & n::Send ñ

; Uppercase
RControl & a::Send Á
RControl & e::Send É
RControl & i::Send Í
RControl & o::Send Ó
RControl & u::Send Ú
RControl & n::Send Ñ

; Punctuation
RAlt & !::Send ¡
RAlt & ?::Send ¿

~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload