#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; #NoTrayIcon
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if !A_IsAdmin {
	Run *Runas %A_ScriptFullPath%
	ExitApp
}

^!t::
MouseGetPos, , , WndH
WinGet Process, ProcessName, ahk_id %WndH%

If ( Process = "explorer.exe" ) {
	WinGetClass Class, ahk_id %WndH%
	If ( Class ~= "Progman|WorkerW" )
	 Location := A_Desktop
	Else If ( Class ~= "(Cabinet|Explore)WClass" )
	{
	 For Window In ComObjCreate("Shell.Application").Windows
		If ( Window.HWnd == WndH )
		{
		   URL := Window.LocationURL
		   Break
		}
	 StringTrimLeft, Location, URL, 8 ; remove "file:///"
	 StringReplace Location, Location, /, \, All
	}
	if (Location == "")
	{
		if !A_IsAdmin
		{
			Run %ComSpec% /K pushd "C:\Users\%A_UserName%" & title Cmd
		}
		else
		{
			ComObjCreate("Shell.Application").Windows.FindWindowSW(0, 0, 8, 0, 1).Document.Application.ShellExecute(Chr(34) ComSpec Chr(34), "/K pushd ""C:\Users\" . A_UserName . """ & title Cmd")
		}
		; Run %ComSpec% /K pushd "C:\Users\%A_UserName%" & title Cmder & "D:\portapps\cmder\vendor\init.bat"
	}
	else 
	{
		if !A_IsAdmin
		{
			Run %ComSpec% /K pushd "%Location%" & title Cmd
		}
		else
		{
			ComObjCreate("Shell.Application").Windows.FindWindowSW(0, 0, 8, 0, 1).Document.Application.ShellExecute(Chr(34) ComSpec Chr(34),"/k pushd " . Location . " & title Cmd")
		}
		; Run %ComSpec% /K pushd "%Location%" & title Cmder & "D:\portapps\cmder\vendor\init.bat"
	}
}
return
	
^!+t::
MouseGetPos, , , WndH
WinGet Process, ProcessName, ahk_id %WndH%

If ( Process = "explorer.exe" ) {
	WinGetClass Class, ahk_id %WndH%
	If ( Class ~= "Progman|WorkerW" )
	 Location := A_Desktop
	Else If ( Class ~= "(Cabinet|Explore)WClass" )
	{
	 For Window In ComObjCreate("Shell.Application").Windows
		If ( Window.HWnd == WndH )
		{
		   URL := Window.LocationURL
		   Break
		}
	 StringTrimLeft, Location, URL, 8 ; remove "file:///"
	 StringReplace Location, Location, /, \, All
	}
	if (Location == "")
	{
		Run *Runas %ComSpec% /K pushd "C:\Users\%A_UserName%" & title Cmd
		; Run *Runas %ComSpec% /K pushd "C:\Users\%A_UserName%" & title Cmder & "D:\portapps\cmder\vendor\init.bat"
	}
	else  
	{
		Run *Runas %ComSpec% /K pushd "%Location%" & title Cmd
		; Run *Runas %ComSpec% /K pushd "%Location%" & title Cmder & "D:\portapps\cmder\vendor\init.bat"
	}
}

return