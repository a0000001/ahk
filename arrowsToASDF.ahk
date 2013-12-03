#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
  
~+!x::ExitApp			;Shift+Alt+X = Emergency Exit
~!+r::Reload			;Shift+Alt+R = Reload

a::Left
s::Down
d::Right
w::Up

; reversed

Left::Right
Right::Left
Down::Up
Up::Down

; Erdani game - arrows to asdf, but also some other shortcuts remapped.
j::a
