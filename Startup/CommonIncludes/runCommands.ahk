; Runs a command with cmd.exe.
RunCommand(commandToRun = "", stayOpen = false) {
	runString := "C:\Windows\System32\cmd.exe "
	
	; Allow either an array or just a string.
	if(commandToRun.MaxIndex()) {
		For i,c in commandToRun {
			cmdString .= c A_Space
		}
		StringTrimRight, cmdString, cmdString, 1
	} else {
		cmdString := commandToRun
	}
	
	; Set /C or /K (command and close, or command and stay up) based on input.
	if(!cmdString || stayOpen || DEBUG.runCommands)
		runString .= "/K "
	else
		runString .= "/C "
	
	; Add the command to the run string.
	runString .= cmdString
	DEBUG.popup(DEBUG.runCommands, cmdString, "Command string", runString, "Run string")
	
	Run, % runString
}

/*           ,---,                                          ,--,    
           ,--.' |                                        ,--.'|    
           |  |  :                      .--.         ,--, |  | :    
  .--.--.  :  :  :                    .--,`|       ,'_ /| :  : '    
 /  /    ' :  |  |,--.  ,--.--.       |  |.   .--. |  | : |  ' |    
|  :  /`./ |  :  '   | /       \      '--`_ ,'_ /| :  . | '  | |    
|  :  ;_   |  |   /' :.--.  .-. |     ,--,'||  ' | |  . . |  | :    
 \  \    `.'  :  | | | \__\/: . .     |  | '|  | ' |  | | '  : |__  
  `----.   \  |  ' | : ," .--.; |     :  | |:  | : ;  ; | |  | '.'| 
 /  /`--'  /  :  :_:,'/  /  ,.  |   __|  : ''  :  `--'   \;  :    ; 
'--'.     /|  | ,'   ;  :   .'   \.'__/\_: |:  ,      .-./|  ,   /  
  `--'---' `--''     |  ,     .-./|   :    : `--`----'     ---`-'   
                      `--`---'     \   \  /                         
                                    `--`-'  
------------------------------------------------------------------
Function: To check if the user has Administrator rights and elevate it if needed by the script
URL: http://www.autohotkey.com/forum/viewtopic.php?t=50448
------------------------------------------------------------------
*/
RunAsAdmin() {
  Loop, %0%  ; For each parameter:
    {
      param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
      params .= A_Space . param
    }
  ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
      
  if not A_IsAdmin
  {
      If A_IsCompiled
         DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
      Else
         DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
      ExitApp
  }
}