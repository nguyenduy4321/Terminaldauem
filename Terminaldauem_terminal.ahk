#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; #NoTrayIcon
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

EnvGet, CMDER_INITBAT, CMDER_INITBAT

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
	 Location:=urlToText(Location)
	}
	if (Location == "")
	{
		ComObjCreate("Shell.Application").Windows.FindWindowSW(0, 0, 8, 0, 1).Document.Application.ShellExecute(Chr(34) ComSpec Chr(34),"/k ""title Cmder & cd /d C:\Users\" . A_UserName . " & %CMDER_INITBAT%""")
	}
	else 
	{
		ComObjCreate("Shell.Application").Windows.FindWindowSW(0, 0, 8, 0, 1).Document.Application.ShellExecute(Chr(34) ComSpec Chr(34),"/k ""title Cmder & cd /d " . Location . " & %CMDER_INITBAT%""")
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
	 Location:=urlToText(Location)
	}
	if (Location == "")
	{
		ComObjCreate("Shell.Application").Windows.FindWindowSW(0, 0, 8, 0, 1).Document.Application.ShellExecute(Chr(34) ComSpec Chr(34),"/k ""title Cmder & cd /d " . A_WINDIR . "\System32 & %CMDER_INITBAT%""" ,,"runas")
	}
	else  
	{
		ComObjCreate("Shell.Application").Windows.FindWindowSW(0, 0, 8, 0, 1).Document.Application.ShellExecute(Chr(34) ComSpec Chr(34),"/k ""title Cmder & cd /d " . Location . " & %CMDER_INITBAT%""" ,,"runas")
	}
}

return


urlToText(url) {
 ; https://www.autohotkey.com/boards/viewtopic.php?style=17&p=292740#p292740
 VarSetCapacity(text, 600)
 DllCall("shlwapi\PathCreateFromUrl" (A_IsUnicode?"W":"A")
  , "Str", "file:" url, "Str", text, "UInt*", 300, "UInt", 0)
 return text
}