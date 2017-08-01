	#Include UP_DEC.ahk
	AdminName = %DecAdminName%
	AdminPass = %DecPass%
#Include Add_INI.ahk
Main:
{	
	If 1 = /S
	{
		computername = %2%
		;FilePath = %3%
		Goto RunArbFile
	}
	;else if 1 = /I
	;{
	;	Compname = %2%
	;	Gosub PreloadStuff
	;	Goto ImmediateUP
	;}
	else
	{
		Msgbox, yeah.... you didn't give any parameters so im exiting
		ExitApp
	}
}
Return

RunArbFile:
	FileCopy, Config.ini, \\%computername%\%FilePath%, 1
	if ErrorLevel > 0 
		{
		MsgBox Fatal Error`n Config could not be copied. `n`nNot arbitrary fileing on %computername% 
		Return
		}
	FileSelectFile, arbitraryfile
	;msgbox, %arbitraryfile%
	If ErrorLevel > 0
		Return
	;Msgbox, Running %arbitraryfile%`nOn %computername%
	
	StringGetPos, locat, arbitraryfile, \, R
	locat := locat + 2 
	stringmid, filename, arbitraryfile, locat
	FileCopy, %arbitraryfile%, \\%computername%\%FilePath%, 1
	FileAppend, %A_Now% Arb File sent and now executing on %ComputerName% `n, %FILogFile%
	;msgbox, psexec \\%computername% -u %AdminName% -p %AdminPass% -h "%RemFilePath%%filename%" /D
	Runwait psexec \\%computername% -u %AdminName% -p %AdminPass% -h "%RemFilePath%%filename%" /D
	;msgbox,  \\%computername%\%FilePath%%filename%
	FileDelete \\%computername%\%FilePath%%filename%
	;msgbox, \\%computername%\%FilePath%Config.ini
	FileDelete \\%computername%\%FilePath%Config.ini
	FileAppend, %A_Now% Arb File Deleted and finished executing on %ComputerName% `n, %FILogFile%
ExitApp
