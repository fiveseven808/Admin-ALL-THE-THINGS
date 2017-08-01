#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance Force
/*
ADMIN ALL THE THINGS!!!! (AATT)
This script is an interface to deal with unruly users and to give them a heads up and admin them if they get too cocky :D

Changelog:
1001
	- updated flash 14 to flash 15. added delete entry and changed freshimagedomeadminahk
1010
	- added encryption to the program. now the username and password are not stored in plaintext. this is only useful if the program becomes compiled though lol.
	- added a change user button. 
	- deleted the useless save button
	x bug still includes having to hit "load" before you try to delete anything (double right click) 
1020
	- fixed the tooltip bug where the tooltips dont go away after deleting an entry
	- began preparing program for deployment as i'm not going to be working at client soon. 
1021
	- Security issues a bit... fixed some... 
	- making windows update let you know when the computer is supposedly back online
1022
	- Enabling much easier to change stuff... planning on finally compiling this... 
1028
	- Changed up-enc.ahk to include DOMAIN when it asks for username
1029
	- Added error check for client program installer when appending to file
	- added the ability to specify where the log file is going and what is it called
	- Added ini capability to the prgoram installer (requires copy on run though lol)
Bugs: 
	- none that i see at the moment 
	
*/
Gui +Resize
computername = NULL
	#Include UP_DEC.ahk
	AdminName = %DecAdminName%
	AdminPass = %DecPass%
	;Files called in this program
	#Include Add_INI.ahk
		
	;These files will be loaded/checked when the program runs or compiles. Not necessary to keep in distribution
	;	#Include UP_DEC.ahk
	;	#Include Add_INI.ahk
	;	#Include GetIP.ahk
	;	#Include GetUpdateStatus.ahk

Blahgui:
{
Gui,Add,Text,x93 y18 w154 h15 -Wrap Center,Admin ALL THE THINGS v3
Gui,Add,Edit,x114 y50 w109 h21 vcomputername 1 Uppercase,Computer Name
Gui,Add,Button,x113 y76 w43 h23 Default,Add
Gui,Add,Text,x92 y32 w163 h18,---------------------------------------------------
Gui,Add,Button,x32 y199 w109 h23 gButtonEnableThreatening,Enable Threatening
Gui,Add,Button,x32 y231 w109 h24 gButtonGetIdleTime,Get User Idle Time
Gui,Add,Button,x39 y263 w96 h24 gButtonSendThreat,Send Threat
Gui,Add,Button,x203 y323 w112 h23 gButtonRebootClient,Reboot Client
Gui,Add,Text,x8 y110 w330 h33 vthecontrolled 0x1000 Center,Current controlled Computer is `n%computername%
Gui,Add,Button,x203 y353 w113 h23 gButtonShutdownClient,Shutdown Client
Gui,Add,Button,x202 y381 w115 h25 gButtonPingForever,Ping Forever
Gui,Add,Button,x31 y335 w114 h22 gButtonArbitraryFile,Run Arbitrary File
Gui,Add,Button,x8 y363 w160 h26 gButtonRunFresh,Run Fresh Image Install
Gui,Add,Button,x189 y173 w139 h26 gButtonQueryUpdates,Query for Updates
Gui,Add,Button,x27 y427 w124 h24 gButtonViewProcs,Current Processes
Gui,Add,Button,x48 y456 w83 h25 gButtonPSKill,Kill Process
Gui,Add,Button,x8 y395 w159 h26 gButtonExplore,Open in Explorer
Gui,Add,Button,x206 y208 w103 h24 gButtonRunUpdates,Run Updates
Gui,Add,Button,x182 y243 w152 h25 gButtonPSinfoApps,View Installed Apps
Gui,Add,Text,x11 y317 w163 h18,---------------------------------------------------
Gui,Add,Text,x9 y488 w322 h18,---------------------------------------------------------------------------------------------------------------------------------------------------------
Gui,Add,Text,x182 y276 w163 h18,---------------------------------------------------
Gui,Add,Button,x64 y293 w43 h23 gButtonChat,Chat
Gui,Add,Button,x203 y294 w112 h23 gButtonCleanup,Cleanup Files
Gui,Add,Button,x32 y171 w109 h23 gButtonMSTSC,Remote In
Gui,Add,Text,x182 y409 w163 h18,---------------------------------------------------
Gui,Add,Button,x202 y425 w115 h25 gButtonHotkeyInfo,HotKey Help
Gui,Add,ListView,x346 y11 w449 h300 vLiveCompList gMyListView AltSubmit Checked Grid,Computer Name|IP Address IPV4|Updates Running|Computer On|Last Seen
Gui,Add,Button,x173 y76 w50 h23 gRefreshListView,Refresh
Gui,Add,ListView,x346 y323 w449 h185 vDeadCompList gMyListView2 AltSubmit Checked Grid,Computer Name|IP Address IPV4|Updates Running|Line|Last Seen
Gui,Add,Text,x9 y147 w322 h18,---------------------------------------------------------------------------------------------------------------------------------------------------------
Gui,Add,Button,x34 y60 w43 h23 gButtonLoad,Load
Gui,Add,Button,x257 y56 w59 h36 gButtonChangeUser,Change User
Gui,Show, w811 h521 ,
	Sleep 500
	Gosub ButtonLoad
	;LV_ModifyCol()  ; Auto-size each column to fit its contents.
	LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
Return
}

ButtonLoad:
	File = CompList.txt
	Gosub FreshLoad
Return

ButtonChangeUser:
	RunWait, %EncoderFile%
	Msgbox, 4,,AATT needs to be restarted to load the new users, do you wish to reload the program?
	IfMsgBox Yes
		{
		Reload
		Sleep 1000
		Msgbox, The Script could not be reloaded. Please Reload manually
		}
Return

MyListView:
;msgbox, a guicontrol is %A_GuiControl%
Gui, ListView, LiveCompList
LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
LV_GetText(IPText, A_EventInfo, 2) 
LV_GetText(UpdateText, A_EventInfo,3) 
LV_GetText(OnText, A_EventInfo,4)
if A_GuiEvent = DoubleClick
{
    ;ToolTip, You %a_guievent%ed row number %A_EventInfo%. Computer: "%RowText%" IP: "%IPText%" Updating: "%UpdateText%" Computer on: "%OnText%"
	;SetTimer, RemoveToolTip, 5000
	StringTrimRight, RowText, RowText, 1 
	ComputerName = %RowText%
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
}
if A_GuiEvent = R
{
	Loop,Parse,tmpfilevar,`n
		{
		;msgbox, current linecontains %A_LoopField%
		If (A_LoopField = "END") 	
			Break
		If (A_LoopField = RowText) 	
			DeleteRow := A_Index 																		
		}
    ToolTip, Lol Deleting Computer %RowText%
	SetTimer, RemoveToolTip, 5000
	LV_Delete(A_EventInfo)
	RemoveLines(file, DeleteRow, 1)
	FileRead, tmpfilevar, %File%
	ComputerName = DELETED
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
}
return



MyListView2:
;msgbox, a guicontrol is %A_GuiControl%
Gui, ListView, DeadCompList
LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
LV_GetText(IPText, A_EventInfo, 2) 
LV_GetText(UpdateText, A_EventInfo,3) 
LV_GetText(LineNumText, A_EventInfo,4)
if A_GuiEvent = DoubleClick
{
    ;ToolTip, You %a_guievent%ed row number %A_EventInfo%. Computer: "%RowText%" IP: "%IPText%" Updating: "%UpdateText%" Computer on: "%OnText%"
	;SetTimer, RemoveToolTip, 5000
	StringTrimRight, RowText, RowText, 1 
	ComputerName = %RowText%
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
}
if A_GuiEvent = R
{
	Loop,Parse,tmpfilevar,`n
		{
		;msgbox, current linecontains %A_LoopField%
		If (A_LoopField = "END") 	
			Break
		If (A_LoopField = RowText) 	
			DeleteRow := A_Index 																		
		}
    ToolTip, Lol Deleting Computer %RowText%
	SetTimer, RemoveToolTip, 5000
	LV_Delete(A_EventInfo)
	RemoveLines(file, DeleteRow, 1)
	FileRead, tmpfilevar, %File%
	ComputerName = DELETED
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
}
return

FreshLoad:
	SetTimer, QuickieFreshLV, off
	SetTimer, RefreshListView, off
	Gui, ListView, DeadCompList
	LV_Delete()
	Gui, ListView, LiveCompList
	LV_Delete()
	FileRead,tmpfilevar,%File%
	If (ErrorLevel=1)
	{
	  Msgbox,16,Fatal Error, Error trying to read`n%file%
	  ExitApp
	}
	Loop,Parse,tmpfilevar,`n
		{
		;msgbox, current linecontains %A_LoopField%
		If (A_LoopField = "END") 																; reached the end of the IP address list
			Break
		tempcompread := A_LoopField
		Gosub GetIP 																			;Retrieves ComputerUpAddr and CompOn and LastSeen
		If CompOn = 1
			Gosub GetUpdatestatus 																;Retrieves If computer is on and updating currently.
		LV_Add("", tempcompread, ComputerUpAddr, UPStatus, CompOn, LastSeen)
		}
																								;Finished Importing data from file
	Gosub QuickieFreshLV																		;Parse out the Null computers and quick refresh list at the same time?
	SetTimer, QuickieFreshLV, 5001
	SetTimer, RefreshListView, 60000
Return

RefreshListView:
	;msgbox, starting refresh at %a_now%
	SetTimer, QuickieFreshLV, off
	SetTimer, RefreshListView, off
	Gui, ListView, LiveCompList
		tempcount := lv_getcount()
		Loop, % lv_getcount()
		{
			LV_GetText(tempcompread, A_Index) 
			LV_GetText(ComputerUpAddr, A_Index, 2) 
			LV_GetText(UPStatus, A_Index,3) 
			LV_GetText(CompOn, A_Index,4)
			LV_GetText(LastSeen, A_Index,5)
			;msgbox, %A_Index% with name %tempcompread% is being processed row number %A_EventInfo%. Computer: "%tempcompread%" IP: "%ComputerUpAddr%" Updating: "%UPStatus%" Computer on: "%CompOn%"
				Gosub GetIP 
				If CompOn = 1
					Gosub GetUpdatestatus 		;Retrieves If computer is on and updating currently.
			LV_Modify(A_Index,,tempcompread,ComputerUpAddr,UPStatus,CompOn,LastSeen)
		}	
	;MSGBOX, FINISHED WITH LIVECOMPLIST
	Gui, ListView, DeadCompList
		tempcount := lv_getcount()
		Loop, %tempcount%
		{
			Gui, ListView, DeadCompList
			FromTheBot := tempcount - A_Index + 1
			LV_GetText(tempcompread, FromTheBot) 
			LV_GetText(ComputerUpAddr, FromTheBot, 2) 
			LV_GetText(UPStatus, FromTheBot,3) 
			LV_GetText(CompOn, FromTheBot,4)
			LV_GetText(LastSeen, FromTheBot,5)
			;msgbox, fromthebot = %FromTheBot%`ntempcompread = %tempcompread%
			Gosub GetIP 
			If (ComputerUpAddr != "Null")
			{
				Gui, ListView, LiveCompList
				LV_Add("", tempcompread, ComputerUpAddr, UPStatus, CompOn, LastSeen)
				Gui, ListView, DeadCompList
				LV_Delete(FromTheBot)
			}
		}	
	SetTimer, QuickieFreshLV, 5001
	SetTimer, RefreshListView, 60000
Return


QuickieFreshLV:
	SetTimer, QuickieFreshLV, off
	Loop
	{
		Gosub QuickieGuts
		If FoundANull = 0
			Break
	}
	SetTimer, QuickieFreshLV, 5001
Return

QuickieGuts:
	FoundANull = 0
	Gui, ListView, LiveCompList
	Loop % LV_GetCount()
	{
		LV_GetText(tempcompread, A_Index, 1)  ; Get the text from the row's first field.
		LV_GetText(ComputerUpAddr, A_Index, 2) 
		LV_GetText(UPStatus, A_Index,3) 
		LV_GetText(CompOn, A_Index,4)
		LV_GetText(LastSeen, A_Index,5)
		;msgbox, quicking this %tempcompread% at index %a_index%
		If (ComputerUpAddr != "Null")
			Gosub GetIP 					;Retrieves ComputerUpAddr and CompOn and LastSeen
		Else If (ComputerUpAddr = "Null")
			{
			;msgbox, foudn a null. %tempcompread%
			Gui, ListView, DeadCompList
			/*
			SameNameFound = 0
			Loop % LV_GetCount()
				{
				RowNumber := LV_GetCount() - 
				LV_GetText(DeadCompListName, A_Index)  ; Get the text from the row's first field.
				If DeadCompListName = %tempcompread%
					{
					SameNameFound = 1
					Break
					}
				}
			*/
			LastRow = 0
			FileRead, tmpfilevar, %File%
			Loop,Parse,tmpfilevar,`n
				{
				LastRow := LastRow + 1
				If (A_LoopField = tempcompread)														; reached the end of the computer list
					{
					SameNameFound = 0
					Break
					}
				}
			;Msgbox last row = %lastrow%
			If SameNameFound = 0
				{
				Gui, ListView, DeadCompList
				LV_Add("", tempcompread, ComputerUpAddr, UPStatus, LastRow, LastSeen)
				}
			Gui, ListView, LiveCompList
			LV_Delete(A_Index)
			FoundANull = 1
			Break
			}
		If CompOn = 1
			Gosub GetUpdatestatus 		;Retrieves If computer is on and updating currently.
		LV_Modify(A_Index,,tempcompread,ComputerUpAddr,UPStatus,CompOn,LastSeen)
	}
Return

RemoveLines(filename, startingLine, numOfLines)
{
       Loop, Read, %filename%
               if ( A_Index < StartingLine )
                       || ( A_Index >= StartingLine + numOfLines )
                               ret .= "`r`n" . A_LoopReadLine
       FileDelete, % FileName
       FileAppend, % SubStr(ret, 3), % FileName
}
Return


FileSave:
	FileDelete, %File%
	FileAppend, %tmpfilevar%%A_Space%, %File%
	FileRead, tmpfilevar, %File%
Return

RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
return


GetIP:
	#Include GetIP.ahk
Return

GetUpdatestatus:
	#Include GetUpdateStatus.ahk
Return

;----------------------------------------------------------------------
;----------------------------------------------------------------------

ButtonAdd:
	Gui, Submit, NoHide
	Gosub AddCompToBottom
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
Return

;----------------------------------------------------------------------

ButtonMSTSC:
	Run mstsc /v:%computername%
return

ButtonEnableThreatening:
	FileCopy, Enable Threatening.exe, \\%computername%\%FilePath%, 1
	Runwait psexec \\%computername% -h "%RemFilePath%Enable Threatening.exe"
	FileDelete \\%computername%\%FilePath%Enable Threatening.exe
Return

ButtonGetIdleTime:
	BlockInput On
	Run cmd
	WinWaitActive, ahk_class ConsoleWindowClass
	SendRAW psexec \\%computername% -h quser
	Send {enter}
	BlockInput Off
Return

ButtonSendThreat:
	;prompt remote computer with threatening message
	ThreatCmd:="msg " . "* /server:" . computername . " /w < threat.txt"
	RunWait %comspec% /c """%ThreatCmd%"""
	Msgbox, Threat acknowledged on `n`n%computername%
Return

ButtonChat:
	Run "UniMsg\UniMsg.exe" /A %computername% %AdminName% %AdminPass% %FilePath% %RemFilePath%
Return

;----------------------------------------------------------------------

ButtonArbitraryFile:
	FileCopy, Config.ini, \\%computername%\%FilePath%, 1
	if ErrorLevel > 0 
		{
		MsgBox Fatal Error`n Config could not be copied. `n`nNot arbitrary fileing. 
		Return
		}
	FileSelectFile, arbitraryfile
	If ErrorLevel > 0
		Return
	Msgbox, Running %arbitraryfile%`nOn %computername%
	
	StringGetPos, locat, arbitraryfile, \, R
	locat := locat + 2 
	stringmid, filename, arbitraryfile, locat
	FileCopy, %arbitraryfile%, \\%computername%\%FilePath%, 1
	Runwait  psexec \\%computername%  -u %AdminName% -p %AdminPass% -h "%RemFilePath%%filename%" /D
	FileDelete \\%computername%\%FilePath%%filename%
	If ErrorLevel = 0
		Msgbox, \\%computername%\%FilePath%%filename%`n`n Has been Deleted
	FileDelete \\%computername%\%FilePath%Config.ini
	If ErrorLevel = 0
		Msgbox, \\%computername%\%FilePath%Config.ini`n`n Has been Deleted
Return

ButtonRunFresh:
	Run "%FreshImageFile%" /S %computername%
return

ButtonExplore:
	Run \\%computername%\C$
Return

ButtonViewProcs:
	Run pslist -s \\%computername% 
return


ButtonPSKill:
	Gui Destroy
	Goto QueryKill
return

;----------------------------------------------------------------------

ButtonQueryUpdates:
	Run "%QueryUpdatesFile%" /S %computername%
	Sleep 250
Return

ButtonRunUpdates:
	Run "%QueryUpdatesFile%" /I %computername%
	Sleep 250
Return

ButtonPSinfoApps:
	BlockInput On
	Run cmd
	WinWaitActive, ahk_class ConsoleWindowClass
	SendRAW psinfo -s \\%computername% -h
	Send {enter}
	BlockInput Off
return

;----------------------------------------------------------------------

ButtonCleanup:
	FileCopy, Disable Threatening.exe, \\%computername%\%FilePath%, 1
	Runwait, psexec \\%computername%   -u %AdminName% -p %AdminPass% -h "%RemFilePath%Disable Threatening.exe",,Min
	Runwait, psexec \\%computername%   -u %AdminName% -p %AdminPass% -h "%RemFilePath%DisableSPEED.exe",,Min
	FileDelete \\%computername%\%FilePath%Disable Threatening.exe
	numfiledel = 0
	FileDelete \\%computername%\%FilePath%client Program Installer EX SILENT MULTI x1001.exe
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%client Program Installer EX SILENT MULTI x0916.exe
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%client Program Installer EX SILENT MULTI x0909.exe
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%client Program Installer EX SILENT MULTI x0829.exe
	If ErrorLevel = 0
		NumFileDel ++
		FileDelete \\%computername%\%FilePath%Config.ini
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%HKLM_CSC_Start_4.reg
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%DisableSpeed.exe
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%EnableSpeed.exe
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%WUInstall.exe
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%Enable Threatening.exe
	If ErrorLevel = 0
		NumFileDel ++
	FileDelete \\%computername%\%FilePath%UniMsg.exe
	If ErrorLevel = 0
		NumFileDel ++
	Msgbox, %ComputerName% had %numfiledel% files Deleted
return

ButtonRebootClient:
	Msgbox, 52, WARNING!!!, The computer`n`n`t%computername%`n`nWill Reboot IMMEDIATELY. `n`n`nAre you sure you want to continue?
	IfMsgBox No
		Return
	Run shutdown -r -f -m \\%computername% -t 1 -c "HAHAHAHAHAHAHA"
	;Run ping %computername% /t
	Msgbox, %ComputerName% is restarting. Will check when it's back and let you know! ;) 
	Run %BackOnlineFile% %computername% /V
Return

ButtonShutdownClient:
	Msgbox, 52, WARNING!!!, The computer`n`n`t%computername%`n`nWill Shutdown IMMEDIATELY. `n`n`nAre you sure you want to continue?
	IfMsgBox No
		Return
	Msgbox, %computername% is now SHUTTING DOWN. 
	Run shutdown -s -f -m \\%computername% -t 1 -c "HAHAHAHAHAHAHA"
return

ButtonPingForever:
	Run ping %computername% /t
return

;----------------------------------------------------------------------

ButtonHotkeyInfo:
	Msgbox,0, Hotkey Information,
	(
	Hotkey Information
	`n`n`tF1: Remote into Highlighted computer
	`n`tF2: Explore Highlighted computer (good for checking access)
	`n`tF3: Run Windows Updates on highlighted computer
	`n`tF4: Add and Control current highlighted computer. 
	`n`tWin + X: Remove server from RDCman under mouse hover
	`n`tDouble Left Click: Control computer under cursor
	`n`tDouble Right Click: Delete computer under cursor 
	`t`t(perform a "load" before doing this)
	)
return

;----------------------------------------------------------------------
;Subroutines
;----------------------------------------------------------------------


QueryKill:
	Gui, Add, Text,, Gimme name of process to Kill
	Gui, Add, Edit, vDieProc ym
	Gui, Add, Button, default, OK
	Gui, Show,, KILL IT WITH FIRE
return

ButtonOK:
	Gui, Submit
	Gui, Destroy
	Runwait pskill -t \\%computername% %DieProc%
	Goto Blahgui
Return

;----------------------------------------------------------------------
;HotKeys
;----------------------------------------------------------------------
F1::
	Send ^c
	Sleep 250
	computername = %clipboard%
	Sleep 250
	Gosub ButtonAdd
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
	Run mstsc /v:%computername%
Return

F2::
	Send ^c
	Sleep 250
	computername = %clipboard%
	Gosub AddCompToBottom
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
	Run \\%computername%\C$
Return

F3::
	Send ^c
	Sleep 250
	computername = %clipboard%
	Gosub AddCompToBottom
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
	Msgbox, 52, WARNING!!!, Do you REALLY want to Update `n%computername%
	IfMsgBox Yes
		Gosub ButtonRunUpdates
Return

F4::
	Send ^c
	Sleep 250
	Computername = %clipboard%
	GuiControl,text, thecontrolled, Current controlled Computer is `n%computername%
	WinActivate, %A_ScriptName%
	Gosub AddCompToBottom
Return

#x::
	Mouseclick, right
	Send v
	Send {Left}
	Send {Enter}
return

AddCompToBottom:
	LastRow = 0
	FileRead, tmpfilevar, %File%
	Loop,Parse,tmpfilevar,`n
		{
		If A_LoopField =  																; reached the end of the computer list
			Break
		LastRow := LastRow + 1
		}
	;msgbox, lastrow is %lastrow%
	LV_Delete(LastRow)
	RemoveLines(file, LastRow, 1)
	FileRead, tmpfilevar, %File%
	FileAppend,`n%Computername%,%File%
	FileAppend,`nEND,%File%
	Gosub FreshLoad
Return


GuiClose:
ExitApp


	