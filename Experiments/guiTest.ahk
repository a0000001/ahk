MsgBox, % "Result 1 = " MyGuiFunction()

MsgBox, % "Result 2 = " MyGuiFunction()

ExitApp



MyGuiFunction()  {

  Global MyEdit

  Gui, +LastFound

  GuiHWND := WinExist()           ;--get handle to this gui..



  Gui, Add , Text  ,        , Enter value

  Gui, Add , Edit  , vMyEdit,

  Gui, Add , Button, Default, OK

  Gui, Show



  WinWaitClose, ahk_id %GuiHWND%  ;--waiting for gui to close

  return ReturnCode               ;--returning value

;-------

ButtonOK:

  GuiControlGet, ReturnCode, , MyEdit

  Gui, Destroy

return

;-------

GuiEscape:

GuiClose:

  ReturnCode = -1

  Gui, Destroy

return

}