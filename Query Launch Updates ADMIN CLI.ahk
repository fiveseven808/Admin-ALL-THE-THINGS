/*
1003
11:35
	-	 Discovered horrible bug that sometimes left computers with files on them and BITS disabled... fixed it... shit... 
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
		Compname = %2%
		Goto Startsilent
	}
	else if 1 = /I
	{
		Compname = %2%
		Gosub PreloadStuff
		Goto ImmediateUP
	}
	else
	{
		Goto QueryPath
	}
}
Return

QueryPath:
{
	Gui, Add, Text,, Gimme name of computer to update
	Gui, Add, Edit, vCompname ym
	Gui, Add, Button, default, OK
	Gui, Show,, Initial Config
	Return
}

ButtonOK:
Gui, Submit
Gui, Destroy
Startsilent:
	Gosub PreloadStuff
	
	BlockInput, On
	run cmd
	sleep 500
	sendraw psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%wuinstall.exe" /search /criteria "IsInstalled=0 and IsHidden = 0"
	Send {Enter}
	BlockInput, Off
	
	Msgbox, 1, Continue? , Is there updates to do on %tempclip%? `nDo you want to continue with updates? `n`nWill automatically continue in 10 min, 600
	IfMsgbox Cancel
		{
		Gosub UnloadStuff
		ExitApp
		}
ImmediateUp:
	IfWinExist, Configuration Manager Trace Log Tool - [\\%tempclip%\C$\windows\windowsupdate.log]
		{
			WinActivate, Configuration Manager Trace Log Tool - [\\%tempclip%\C$\windows\windowsupdate.log]
		}
		Else
		{
			Run, %CMTracePathFile% "\\%tempclip%\C$\windows\windowsupdate.log",,Min,LogProcVar
		}
	
	Startupdates:
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%wuinstall.exe" /install /criteria "IsInstalled=0 and IsHidden = 0 and Type = 'Driver'",,Min
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%wuinstall.exe" /install /criteria "IsInstalled=0 and IsHidden = 0" /match "Tool",,Min
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%wuinstall.exe" /install /criteria "IsInstalled=0 and IsHidden = 0" /match "Platform",,Min
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%wuinstall.exe" /install /criteria "IsInstalled=0 and IsHidden = 0" /match ".NET",,Min
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%wuinstall.exe" /install /criteria "IsInstalled=0 and IsHidden = 0" /match "Service Pack",,Min
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%wuinstall.exe" /install /criteria "IsInstalled=0 and IsHidden = 0" /match "Update for",,Min
	
	;Disable Speed
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%DisableSPEED.exe",,Min
	BlockInput, On
	run, cmd,,,FinalUpdateStatusCMD
	;Msgbox, PID of the the command prompt is %FinalUpdateStatusCMD%
	sleep 500
	sendraw psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%wuinstall.exe" /search /criteria "IsInstalled=0 and IsHidden = 0"
	Send {Enter}
	BlockInput, Off
	
	
	
	Msgbox, 4, Updates Status, Finished updating everything `n%tempclip% is done. Run Again? `n`nWill automatically click no in 10 min, 600
	IfMsgBox, Yes
		Goto Startupdates
	Gosub UnloadStuff	
	Msgbox, 4, Finished updates on %tempclip%!, Finished!!! Do you want to Kill All Associated Windows EXCEPT PING?, 60
	IfMsgBox, Yes
		{
		;Process, Close, %LogProcVar%
		Process, Close, %FinalUpdateStatusCMD%
		WinKill, Configuration Manager Trace Log Tool - [\\%tempclip%\C$\windows\windowsupdate.log]
		}
	Msgbox, 4, Restart?, Do you want to restart %tempclip%? `n`nWill automatically click Yes in 5 min, 300
	IfMsgBox, Yes
		{
		Runwait psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h shutdown -r	
		Run ping %tempclip% /t
		RunWait %BackOnlineFile% %tempclip%
		Sleep 5000
		Msgbox, ,,%tempclip% is POSSIBLY back online! `n`nDouble check that computer is online before updating
		}
	IfMsgBox, Timeout
		{
		Runwait psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h shutdown -r	
		Run ping %tempclip% /t
		RunWait %BackOnlineFile% %tempclip%
		Sleep 5000
		Msgbox, ,,%tempclip% is POSSIBLY back online! `n`nDouble check that computer is online before updating
		}
	;Sleep 500
	
ExitApp

PreloadStuff:
{
	tempclip = %Compname%
	FileCopy, BTest.bin, \\%tempclip%\%FilePath%, 1
		If ErrorLevel != 0
			{
			Msgbox, Fatal Error. `n`nCannot Communicate With and or Copy files to %tempclip%. `n`nQuery Launch Updates ADMIN CLI.ahk will now Exit. 
			ExitApp
			}
	FileDelete \\%tempclip%\%FilePath%BTest.bin
	FileCopy, WUinstall.exe, \\%tempclip%\%FilePath%, 1
	FileCopy, EnableSPEED.exe, \\%tempclip%\%FilePath%, 1
	FileCopy, DisableSPEED.exe, \\%tempclip%\%FilePath%, 1
	;Enable Speed
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%EnableSPEED.exe",,Min
Return
}

UnloadStuff:
{
	tempclip = %Compname%
	Runwait, psexec \\%tempclip%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%DisableSPEED.exe",,Min
	FileDelete \\%tempclip%\%FilePath%BTest.bin
	FileDelete \\%tempclip%\%FilePath%WUinstall.exe
	FileDelete \\%tempclip%\%FilePath%EnableSPEED.exe
	FileDelete \\%tempclip%\%FilePath%DisableSPEED.exe
Return
}

GuiClose:
ExitApp