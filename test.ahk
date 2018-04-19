DetectHiddenWindows On
Run %ComSpec%,, Hide, pid
WinWait ahk_pid %pid%
DllCall("AttachConsole", "UInt", pid)
WshShell := ComObjCreate("Wscript.Shell")
exec := WshShell.Exec("ping www.google.com")
output := exec.StdOut.ReadAll()
MsgBox %output%
DllCall("FreeConsole")
Process Close, %pid%
return