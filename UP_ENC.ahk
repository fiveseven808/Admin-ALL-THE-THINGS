AskUname:
{
	Gui, Add, Text,, Username with DOMAIN?
	Gui, Add, Edit, vUname ym
	Gui, Add, Button, gButtonOK1 default, OK
	Gui, Show,, Initial Config
	Return
}

ButtonOK1:
Gui, Submit
Gui, Destroy

AskPWD:
{
	Gui, Add, Text,, Password?
	Gui, Add, Edit, Password vPWD ym
	Gui, Add, Button, gButtonOK2 default, OK
	Gui, Show,, Initial Config
	Return
}

ButtonOK2:
Gui, Submit
Gui, Destroy

	;msgbox uname = %uname% `npass = %PWD%
	EncAdminName := DraGon_Enc(uname)
	EncPass := DraGon_Enc(PWD)
	msgbox, encrypted name = %EncAdminName% `n encrypted password = %EncPass%
	DecAdminName := DraGon_Dec(EncAdminName)
	DecPass := DraGon_Dec(EncPass)
	;msgbox, decrypted name = %DecAdminName% `n encrypted password = %DecPass%
	FileDelete, Admin.bin
	FileAppend, %EncAdminName%`n, Admin.bin
	FileAppend, %EncPass%, Admin.bin
	Msgbox, Username and Password Changed successfully!
GuiClose:	
exitapp

#include DragonEnc.ahk