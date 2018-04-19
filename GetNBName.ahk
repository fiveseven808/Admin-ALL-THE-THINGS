/*
Get NetBIOS Name!
This library should be included, then called from another script 
*/


;If host is IP address
; Check for 4 periods? 
;tempcompread := "10.16.36.225"
NBFile:="NBTSTAT.tmp" 

;Example code to Run command to get host name if possible 
;
;NBName := GetNBName(tempcompread, NBFile)
;msgbox %NBName%
;exitApp

GetNBName(tempcompread, NBFile){
	StringReplace, tempcompread_clean, tempcompread, `r, , a
	StringReplace, tempcompread_clean, tempcompread_clean, `n, , a
	nbtstat := CheckServer(tempcompread_clean,NBFile)
	;msgbox %nbtstat%
	Loop, Parse, nbtstat, `n, `r
   {
      if (A_Index == (FoundLine + 1)) {
		StringReplace , NBName, A_LoopField, %A_Space%,,All
		locat := InStr(NBName, "<")
		NBName := SubStr(NBName, 1,(locat - 1))
		return %NBName%
	  }
      else {
		 IfInString, A_LoopField, -------------------------------------------
		 FoundLine := A_Index
      }
   }
}


CheckServer(host,NBFile){
	ThisProcess := DllCall("GetCurrentProcess")
	; If IsWow64Process() fails or can not be found,
	; assume this process is not running under wow64.
	; Otherwise, use the value returned in IsWow64Process.
	if !DllCall("IsWow64Process", "uint", ThisProcess, "int*", IsWow64Process)
		IsWow64Process := false
	;msgbox %IsWow64Process%
	
	If (IsWow64Process != false) {
		;msgbox it's not false!
		PingCmd:="%SystemRoot%\sysnative\nbtstat.exe -A " . host . " >" . NBFile
	} else {
		PingCmd:="nbtstat -A " . host . " >" . NBFile
	}
	;msgbox %PingCmd%
	RunWait %comspec% /c """%PingCmd%""",,hide
	FileRead, output, %NBFile%
	FileDelete,%NBFile%
	return output
}