/*
Summary:
The computer is pinged until its off (so its not fucking around with file transfer operations or something... stalling the reboot..)
Then when the comptuer is off, it loops attempting to transfer a 0 byte file. 
When it is successful, then you know when the OS is loaded enough to interpret commands :] 
*/
#SingleInstance Off
#Include Add_INI.ahk
PingResults:="PingResults.txt" 
PingErr1:="Destination host unreachable"
PingErr2:="Request Timed Out"
PingErr3:="TTL Expired in Transit"
PingErr4:="Unknown Host"
PingErr5:="Ping Request could not find host"


Main:
{	
	If 0 > 0
	{
		Computername = %1%
		;msgbox, Checking %computername% is on or not
		Goto Checkcomp
	}
	else
	{
		Msgbox, Must be run in command line with switches `n`nBackonline [ComputerName] [/V]
		ExitApp
	}
}
Return

CheckComp:
	Loop
	{
	PingCmd:="ping " . ComputerName . " -n 1 >" . PingResults
	RunWait %comspec% /c """%PingCmd%""",,Hide
	Loop
	  {
		;msgbox, okay, in ping loop
		 PingError:=false
		 FileReadLine,PingLine,%PingResults%,%A_Index%
		 If (ErrorLevel=1)
		   Break
		 IfInString,PingLine,%PingErr1%
		 {
		   PingError:=true
		   ;msgbox, failed %PingErr1%
		   Break
		 }
		 IfInString,PingLine,%PingErr2%
		 {
		   PingError:=true
		   ;msgbox, failed %PingErr2%
		   Break
		 }
		 IfInString,PingLine,%PingErr3%
		 {
		   PingError:=true
		   ;msgbox, failed %PingErr3%
		   Break
		 }
		 IfInString,PingLine,%PingErr4%
		 {
		   PingError:=true
		   ;msgbox, failed %PingErr4%
		   Break
		 }
		 IfInString,PingLine,%PingErr5%
		 {
		   PingError:=true
		   ;msgbox, failed %PingErr5%
		   Break
		 }
		
	  }
		FileDelete,%PingResults%
		If PingError
		  {
			;msgbox, okay computer is off
			break
		  }
	}
	ThreeTimes := 0 
	Loop
	{
		;msgbox, starting threetimes loop
		Sleep 500
		FileCopy, BTest.bin, \\%computername%\%FilePath%, 1
		;msgbox, finished trying to copy.... 
		If ErrorLevel != 0
			{
			;msgbox, ,,looks like it errored trying to copy, 1
			ThreeTimes := 0
			Continue
			}
		;msgbox, about to delete... 
		FileDelete \\%computername%\%FilePath%BTest.bin
		If ErrorLevel != 0
			{
			;msgbox, ,,looks like it errored trying to delete, 1
			ThreeTimes := 0
			Continue
			}
		ThreeTimes := ThreeTimes + 1
		;msgbox, threetimes = %threetimes%
		if ThreeTimes = 3
			{
			;msgbox, aand done threetimes = %threetimes%
			Break
			}
		Continue
	}
If 2 = /V
	{
		Msgbox, Computer %ComputerName% is back online! :D 
	}
ExitApp