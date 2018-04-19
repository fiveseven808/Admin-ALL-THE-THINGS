/*
Summary:
Rewriting the GetIP.ahk include to use stuff directly from command line. Can run in parallel more easier 
Should be faster and better

Changelog
180418:
	-	First commit. Doesn't seem to work after time. The output seems to somehow get corrupt. 
		Doesn't seem to update the right variables in the right times... 
		Byproduct of not making it function like and made it more global variable like... bad programming
*/
; tempcompread = d3410ln43
ComputerUPAddr = Null
CheckComp:
	StringReplace, tempcompread_clean, tempcompread, `r, , a
	StringReplace, tempcompread_clean, tempcompread_clean, `n, , a
	ping := CheckServer(tempcompread_clean)
	;msgbox, %ping%
	CompOn = 0
	Loop, Parse, ping, `n, `r
   {
      if (A_Index == 3) {												;On the third line, there should be a time. 
		 RegExMatch(A_LoopField, "O)(?=|<)\d*ms", time)
		 pingtime := time.Value()
		 if ((pingtime == -1)||pingtime == ""){							;If not then it's not valid
			Break
		 }
		 UPStatus := pingtime
		 ;msgbox, %pingtime%
		 CompOn = 1
		 LastSeen := A_Hour . ":" . A_Min . ":" . A_Sec 
         Continue
	  }
      else {
		StringGetPos, locat, A_LoopField, for, R
		;msgbox locat is %locat% and aindex = %a_index%
		if (locat < 0)
			continue
		locat := locat + 4
		stringmid, ComputerUPAddr, A_LoopField, locat
		StringTrimRight, ComputerUPAddr, ComputerUPAddr, 1
        ;return time.Value()
      }
   }

;Output variables are CompOn which lets you know if the computer is pingable
; The other one is  ComputerUPAddr.
;ExitApp


/*
CheckServer(host){
   objShell := ComObjCreate("WScript.Shell")
   objExec := objShell.Exec(ComSpec " /c ping -n 1 " host)
   strStdOut := ""
   while, !objExec.StdOut.AtEndOfStream
      strStdOut := objExec.StdOut.ReadAll()
   return strStdOut
}
*/

CheckServer(host){
	DetectHiddenWindows On
	Run %ComSpec%,, Hide, pid
	WinWait ahk_pid %pid%
	DllCall("AttachConsole", "UInt", pid)
	WshShell := ComObjCreate("Wscript.Shell")
	exec := WshShell.Exec("ping -n 1 -4 " host )
	output := exec.StdOut.ReadAll()
	;MsgBox %output%
	DllCall("FreeConsole")
	Process Close, %pid%
	return output
}