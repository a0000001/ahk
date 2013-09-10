#InstallKeybdHook
#SingleInstance, Force

hold := 0

^#x::
               hold := mod(hold + 1, 2)
               msgBox, % hold
return

!+x::
               if(!hold) {
                               ExitApp
               }
return