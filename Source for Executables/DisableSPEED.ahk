﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE, SOFTWARE\Policies\Microsoft\Windows\BITS, EnableBITSMaxBandwidth, 1
RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE, SOFTWARE\Policies\Microsoft\Windows\BITS, MaxTransferRateOnSchedule, 300