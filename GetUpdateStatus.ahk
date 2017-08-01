/*
Summary:
This is an include file that'll check to see if wuinstall.exe is on 
tempcompread
and then sets the variable if it is... 
*/
;statuscomp := RegExReplace(tempcompread, "(\n)",A_SPACE) 
;lbvar = `n
;IfInString,lbvar, tempcompread
;	msgbox, found linebreak in %tempcompread%
#Include Add_INI.ahk
UPStatus = 0
StringTrimRight,statuscomp,tempcompread,1
;Msgbox, %statuscomp% is checking if updating! 
IfExist, \\%statuscomp%\%FilePath%WUInstall.exe
	UPStatus = 1