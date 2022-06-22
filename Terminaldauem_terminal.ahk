#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; #NoTrayIcon
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
IniRead, DefaultShell, ./config.ini, Settings, DefaultShell
if !A_IsAdmin {
	Run *Runas %A_ScriptFullPath%
	ExitApp
}
WindowTerminal = "wt"


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
	Location := uriDecode(Location)
	if (Location == "")
	{
		Location = "C:\Users\%A_UserName%"
	}

	ComObjCreate("Shell.Application").Windows.FindWindowSW(0, 0, 8, 0, 1).Document.Application.ShellExecute(WindowTerminal , "-w Terminal_Dau_em nt -d" . Location)

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
	Location := uriDecode(Location)
	if (Location == "")
	{
		Location = "C:\Users\%A_UserName%"
	}

	Run *Runas WindowTerminal  "-w \"Terminal Dau em adub\" nt -d" Location
}

return

uriDecode(str) {
	Loop
		If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
		Else Break
	Return, str
}

