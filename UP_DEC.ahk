File = Admin.bin


FileRead,tmpfilevar,%File%
	If (ErrorLevel=1)
	{
	  Msgbox,16,Fatal Error, Error trying to read`n%file%
	  ExitApp
	}
	Loop,Parse,tmpfilevar,`n
		{
		;msgbox, current linecontains %A_LoopField%
		If A_LoopField = 																; reached the end of the IP address list
			Break
		If A_index = 1
			EncAdminName = %A_LoopField%
		If A_index = 2
			EncPass = %A_LoopField%
		}
	StringTrimRight,EncAdminName,EncAdminName,1
	;msgbox, crypted name = %EncAdminName% `n crypted password = %EncPass%
	DecAdminName := DraGon_Dec(EncAdminName)
	DecPass := DraGon_Dec(EncPass)
	;msgbox, decrypted name = %DecAdminName% `n dencrypted password = %DecPass%
	;exitapp

#include DragonEnc.ahk