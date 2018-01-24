#cs
	---------------------------------------------------
	___  __                        ___       __
	|  (_  |\ |    /\     _|_  _   | _|_   (_ _|_      _| o  _
	_|_ __) | \|   /--\ |_| |_ (_) _|_ |_   __) |_ |_| (_| | (_)

	---------------------------------------------------
	ISN AutoIt Studio Helper
	---------------------------------------------------

	Diese Datei dient dazu, um diverse Prozesse aus dem ISN AutoIt Studio in einen eigenen Thread (Prozess) auszulagern.
	Der Helper fungiert wie ein ISN Plugin und kann mit denselben Befehlen gesteuert werden.

	Aktuell übernimmt der Helper folgende Funktionen:
	- Testen eines Skriptes / Projektes
	- Updateverwaltung (Suche, Download usw)


	Geplant:
	- Generierung und speicherung des Skriptbaumes (Für schnellere darstellung)
	- Durchführung der Automatischen Backups
	---------------------------------------------------
#ce

;AutoIt Stuff
#NoTrayIcon
Opt("GUIOnEventMode", 1)
Opt("GUIResizeMode", 802)

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Description=ISN AutoIt Studio Helper
#AutoIt3Wrapper_Res_Fileversion=1.0.6
#AutoIt3Wrapper_Res_ProductVersion=1.06
#AutoIt3Wrapper_Res_LegalCopyright=ISI360
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=ProductName|ISN AutoIt Studio Helper
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Res_HiDpi=Y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;Includes 1/2
#include <GDIPlus.au3>
#include "Data\Plugins\PLUGIN SDK\isnautoitstudio_plugin.au3"

;Es müssen Parameter angegeben werden!
If Not IsArray($CmdLine) Then Exit
If $CmdLine[0] = 0 Then
	MsgBox(16 + 262144, "ISN AutoIt Studio Helper - Error", "This program is part of the ISN AutoIt Studio and cannot be started separately!", 0)
	Exit
EndIf


;CMD Startdeklarationen
Global $ISN_Helper_running = 0 ;1 if the helper started succesfully
Global $Use_Watch_Guard = 1
Global $Thread_Task = ""
Global $Testscript_file = ""
Global $Testscript_file_parameter = ""
Global $Updater_Mode = "normal" ;Oder silent
Global $updaterlocal_file = ""


;CMD Befehle
If IsArray($CmdLine) Then
	For $x = 1 To $CmdLine[0]

		;/thread_task
		If StringInStr($CmdLine[$x], "/thread_task ") Then
			$Thread_Task = StringStripWS(StringReplace($CmdLine[$x], "/thread_task ", ""), 3)
		EndIf

		;/Testscript_file
		If StringInStr($CmdLine[$x], "/testscript_file ") Then
			$Testscript_file = StringStripWS(StringReplace($CmdLine[$x], "/testscript_file ", ""), 3)
		EndIf

		;Test Script parameter
		If StringInStr($CmdLine[$x], "/testscript_parameter ") Then
			$Testscript_file_parameter = StringStripWS(StringReplace($CmdLine[$x], "/testscript_parameter ", ""), 3)
			$Testscript_file_parameter = StringReplace($Testscript_file_parameter, "<quote>", '"')
		EndIf

		;Disable ISN watch guard
		If StringInStr($CmdLine[$x], "/no_watch_guard") Then
			$Use_Watch_Guard = 0
		EndIf

		;Disable ISN watch guard
		If StringInStr($CmdLine[$x], "/updater_mode ") Then
			$Updater_Mode = StringStripWS(StringReplace($CmdLine[$x], "/updater_mode ", ""), 3)
		EndIf

		;Override update from web -> Use local file
		If StringInStr($CmdLine[$x], "/updaterlocal_file ") Then
			$updaterlocal_file = StringStripWS(StringReplace($CmdLine[$x], "/updaterlocal_file ", ""), 3)
		EndIf


	Next
EndIf


;Hauptinitialisierung des Threads -> Wie ein ISN Plugin!
_ISNThread_initialize($Use_Watch_Guard)
If @error Then
	MsgBox(16, "Error", "This program is part of the ISN AutoIt Studio and cannot be started separately!")
	Exit
EndIf


;Includes 2/2
_GDIPlus_Startup()
#include <Array.au3>
#include <Crypt.au3>
#include <GuiImageList.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIGdi.au3>
#include <Timers.au3>
#include <File.au3>
#include <SendMessage.au3>
#include <Date.au3>
#include <WinAPIShellEx.au3>
#include <WindowsConstants.au3>
#include "Includes\Autoit_Studio_Helper_Deklarationen.au3"
#include <includes\USkin.au3>
#include "includes\Icons.au3"
#include "includes\_iniEx.au3"
#include "includes\_PDH_PerformanceCounters.au3"
#include "includes\_WinTimeFunctions.au3" ; needed for certain value adjustments in retrieving Counter Values
#include "includes\_WinAPI_GetSystemInfo.au3" ; _WinAPI_GetSystemInfo_ISN(6) -> CPU count
#include "includes\_PDH_ObjectBaseCounters.au3"
#include "includes\_PDH_ProcessCounters.au3"
#include "includes\MultiGraph.au3"
#include "includes\DPI_Scaling.au3"


;Initialisiere skin
_Uskin_LoadDLL(@ScriptDir & "\Data\USkin.dll")
If Not FileExists(@ScriptDir & "\Data\Skins\" & $skin) Then $skin = "#none#"
$pfad = @ScriptDir & "\Data\Skins\" & $skin & "\skin.msstyles"
If $skin <> "#none#" Then
	_USkin_Init($pfad) ;skin zuweisen
EndIf

;Forms
#include "Forms\ISN_Minidebug1.isf" ;MiniDebug Teil1
#include "Forms\ISN_Minidebug2.isf" ;MiniDebug Teil2
#include "Forms\ISN_Debug_GUI_Erweitert.isf" ;Erweiterte Debug GUI
#include "Forms\ISN_Update.isf" ;Update GUI
#include "Forms\ISN_Update_Changelog.isf" ;Update Changelog
#include "Forms\ISN_Update_gefunden.isf" ;Update gefunden GUI
#include "Forms\ISN_Update_Warte.isf" ;Update warte GUI
#include "Includes\Autoit_Studio_Helper_Addons.au3"
#include "Includes\Update.au3"



;Was soll der Thread egtl. machen?!
Switch $Thread_Task

	Case "testscript"
		GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
		_ISNPlugin_Register_ISN_Event($ISN_AutoIt_Studio_Event_Exit_Plugin, "_ISNHelper_testscript_exit")
		Global $AutoIt3Wrapper_exe_path = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$AutoIt3Wrapper_exe_path")
		Global $autoitexe = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$autoitexe")
		$ISN_Helper_running = 1
		_ISN_Skript_Testen()

	Case "searchupdates"
		_Set_Proxyserver()
		$Studioversion = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Studioversion")
		$VersionBuild = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$VersionBuild")
		$autoupdate_searchtimer = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$autoupdate_searchtimer")
		GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
		$ISN_Helper_running = 1
		If $updaterlocal_file = "" Then
			_ISN_Helper_Nach_Updates_Suchen($Updater_Mode) ;Search update from isnetwork.at
		Else
			If FileExists($updaterlocal_file) Then
				_ISN_AutoIt_Studio_Install_Update($updaterlocal_file) ;Use a local .zip file
			Else
				Exit
			EndIf
		EndIf


EndSwitch





While 1
	Sleep(100)
WEnd

