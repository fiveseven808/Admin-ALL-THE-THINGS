/*
Summary:
This is an include file that'll take the IP from 
tempcompread
and then find the IP by creating a temporary file and parsing through it. 
*/
PingResults:="PingResults.tmp" 
PingErr1:="Destination host unreachable"
PingErr2:="Request Timed Out"
PingErr3:="TTL Expired in Transit"
PingErr4:="Unknown Host"
PingErr5:="Ping Request could not find host"

; tempcompread = d3410ln43
ComputerUPAddr = Null
UPStatus := Null
CheckComp:
	Loop
	{
	PingCmd:="ping " . tempcompread . " -4 -n 1 -w 150 > " . PingResults
	;msgbox %pingcmd%
	RunWait %comspec% /c """%PingCmd%""",,Hide
	FileRead, tmpfilevar, %PingResults%
	;msgbox %tmpfilevar%
	Loop
	  {
		 PingError:=false
		 FileReadLine,PingLine,%PingResults%,%A_Index%
		 ;Msgbox, currnet pint ling says `n`n%pingline% `nthis is on line %A_Index%
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
		if (A_Index == 3) {
			RegExMatch(PingLine, "O)(?=|<)\d*ms", time)
			PingTime := time.Value()
		}
		StringGetPos, locat, PingLine, for, R
		;msgbox locat is %locat%
		if (locat < 0)
			continue
		locat := locat + 4
		stringmid, ComputerUPAddr, PingLine, locat
		StringTrimRight, ComputerUPAddr, ComputerUPAddr, 1
		
		CompOn = 1

		Break
	  }
		FileDelete,%PingResults%
		If PingError
		  {
			CompOn = 0
			;LastSeen = Nope
			;msgbox, okay %tempcompread% is  off cannot get IP... 
			break
		  }
		LastSeen := A_Hour . ":" . A_Min . ":" . A_Sec 
		Break
	}
;Output variables are CompOn which lets you know if the computer is pingable
; The other one is  ComputerUPAddr.
;ExitApp