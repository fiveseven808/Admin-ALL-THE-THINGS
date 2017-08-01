; AUTO YES!!!!

;get reference file?

;Copy and go? 

/*
Notes:
Right now the script references an ahk file to run the windows updates 
Need to merge with command line for it to work

*/

#SingleInstance off

	#Include UP_DEC.ahk
	AdminName = %DecAdminName%
	AdminPass = %DecPass%
	
	#Include Add_INI.ahk


Main:
{	
	If 1 = /S
	{
		;msgbox, Back office switch was chosen
		Compname = %2%
		;msgbox, 2 = %2% and compname = %compname%
		Goto Startsilent
	}
	else
	{
		Goto QueryPath
	}
}
Return

QueryPath:
{
	Gui, Add, Text,, Gimme name of the Computer fresh off of imaging
	Gui, Add, Edit, vCompname ym
	Gui, Add, Button, default, OK
	Gui, Show,, Initial Config
	Return
}

ButtonOK:
	Gui, Submit
	Gui, Destroy
Startsilent:
	tempclip = %Compname%
	StringLen, length, Compname
	;If (Length != 9)
	;	{
	;	Msgbox, The computer name is invalid, please make sure it is exactly 9 Characters! 
	;	Goto QueryPath
	;	}
	StringMid, DorB, Compname, 0, 1
	If DorB = D
		{
		msgbox, Executing 'D' Back office image App configuration
		Gosub RunImageD
		}
	else if DorB = B
		{
		msgbox, Executing 'B' Branch image App configuration
		Gosub RunImageB
		}
	else 
		{
		msgbox, 3, ,Not a valid computer name. Should start with D or B `n`n`n...Do you want to continue with "D" Image? `n`nYes for Back office "D"`nNo for Branch "B"`nCancel to quit. 
		IfMsgBox Yes
			{
			msgbox, Executing 'D' Back office image App configuration
			Gosub RunImageD
			}
		else IfMsgBox No
			{
			msgbox, Executing 'B' Branch image App configuration
			Gosub RunImageB
			}
		else IfMsgBox Cancel 
			{
			Goto QueryPath
			}
		}
	;Run ping %tempclip% /t ;Ping the computer
	Gosub Windowsupdates
ExitApp




RunImageD:
{
;CHOPPED F2 script for auto running shit. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;This section of the script runs and installs all 3rd party apps and uninstalls whatever is necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Gosub CopynKill
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%%InstallerFile%" /D ,,Min
	;Wait until the programs finish installing.
	BlockInput, On
	Sleep 1000
	Blockinput, Off
	Msgbox, 1, Interm D Status, Finished installing 3rd party apps. `n%tempclip% is done. `n`n Do you want to continue `nwith Windows updates? `n`nWill automatically continue in 3 Seconds, 3
	IfMsgBox Cancel
		ExitApp
	;if Timeout: 
	Return	
}

RunImageB:
{
;CHOPPED F2 script for auto running shit. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;This section of the script runs and installs all 3rd party apps and uninstalls whatever is necessary
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Gosub CopynKill
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%%InstallerFile%" /B ,,Min
	;Wait until the programs finish installing.
	BlockInput, On
	Sleep 1000
	Blockinput, Off
	Msgbox, 1, Interm B Status, Finished installing 3rd party apps. `n%tempclip% is done. `n`n Do you want to continue `nwith Windows updates? `n`nWill automatically continue in 3 Seconds, 3
	IfMsgBox Cancel
		ExitApp
	;if Timeout: 
	Return	
}

CopynKill:
{
	FileCopy, %InstallerFile%, \\%tempclip%\%FilePath%, 1
	if ErrorLevel > 0
		{
		MsgBox Fatal Error`n Installer could not be copied. `n`nQuitting Fresh Image. 
		ExitApp
		}
	FileCopy, Config.ini, \\%tempclip%\%FilePath%, 1
	if ErrorLevel > 0 
		{
		MsgBox Fatal Error`n Config could not be copied. `n`nQuitting Fresh Image. 
		ExitApp
		}

	Runwait, pskill -t \\%tempclip%  -u %AdminName% -p %AdminPass% iexplore.exe ,,Min
	Runwait, pskill -t \\%tempclip%  -u %AdminName% -p %AdminPass% "%InstallerFile%" ,,Min
	
	IfWinExist, Configuration Manager Trace Log Tool, %FILogFile%
		{
			WinActivate, Configuration Manager Trace Log Tool, %FILogFile%
		}
		Else
		{
		
			Run %CMTracePathFile% "%FILogFile%"
		}
Return
}


Windowsupdates:
{
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;This section of the script starts a special mode in "Query Launch Updates ADMIN CLI.ahk" script. Checks and installs updates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	Msgbox, 0, Rebooting,Waiting for %tempclip% to come back online, 2
	RunWait %BackOnlineFile% %tempclip%
	Sleep 5000
	Msgbox, ,,%tempclip% is back online! Windows Updating... ,2
	Gosub Cleanup
	Run "%QueryLUpdatesFile%" /I %tempclip%
Return
}

GuiClose:
ExitApp

Cleanup:
	FileDelete, \\%tempclip%\%FilePath%%InstallerFile%
	FileDelete, \\%tempclip%\%FilePath%Config.ini
Return
