#cs
	---------------------------------------------------
	ISN cmd (ISN AutoIt Studio Command Line Tool)
	---------------------------------------------------

	You can use this little command line toolkit to control the ISN AutoIt Studio via some cmd switches.
	For example with "ISN_cmd.exe /compile_project" you can start the compiling of the project.

	---------------------------------------------------
#ce

#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=../autoitstudioicon_red.ico
#AutoIt3Wrapper_Res_Comment=https://www.isnetwork.at
#AutoIt3Wrapper_Res_Description=ISN AutoIt Studio Command Line Tool
#AutoIt3Wrapper_Res_Fileversion=0.0.1.0
#AutoIt3Wrapper_Res_ProductVersion=0.0.1.0
#AutoIt3Wrapper_Res_LegalCopyright=ISI360
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Field=ProductName|ISN AutoIt Studio Command Line Tool
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Res_HiDpi=Y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global $Tool_Version = "0.01"
#include <WindowsConstants.au3>
#include "..\Data\Plugins\PLUGIN SDK\isnautoitstudio_plugin.au3"

If Not IsArray($CmdLine) Then Exit
If $CmdLine[0] = 0 Then
	Exit ;No Parameters
EndIf

$Dummy_GUI = GUICreate("ISN CMD Toolkit", 400, 100)
ConsoleWrite("####################################################################" & @CRLF)
ConsoleWrite("## ISN AutoIt Studio Command Line Tool v. " & $Tool_Version & " by ISI360" & @CRLF)
ConsoleWrite("####################################################################" & @CRLF)

ConsoleWrite(@CRLF)
_Process_CMD_Commands()


Func _Process_CMD_Commands()

	;Setup CMD Commands
	If IsArray($CmdLine) Then
		For $x = 1 To $CmdLine[0]

			;/help OR /?
			If StringInStr($CmdLine[$x], "/help") Or StringInStr($CmdLine[$x], "/?") Then
				$helpstring = "You can use this little command line toolkit to control the ISN AutoIt Studio via some cmd switches." & @CRLF & _
						"NOTE: If you use switches with parameters, it is recommended to put the whole command into quotes!" & @CRLF & _
						'EXAMPLE: ISN_cmd.exe "/isn_gui_handle 0x123456" "/isn_open_file C:\temp\test.au3"' & @CRLF & @CRLF & _
						"Available commands:" & @CRLF & @CRLF & _
						"/?" & @TAB & @TAB & @TAB & @TAB & "This help text" & @CRLF & _
						"/isn_gui_handle" & @TAB & @TAB & @TAB & "Sets the ISN AutoIt Studio main gui handle. If this parameter is not available, the toolkit will find the handle automatically." & @CRLF & _
						"/isn_compile_project" & @TAB & @TAB & "Compiles the currently opened project in the ISN AutoIt Studio." & @CRLF & _
						"/isn_close_project" & @TAB & @TAB & "Closes the currently opened project in the ISN AutoIt Studio." & @CRLF & _
						"/isn_backup_project" & @TAB & @TAB & "Execute the Backup function in the ISN AutoIt Studio." & @CRLF & _
						"/isn_test_project" & @TAB & @TAB & "Test (run) the currently opened project in the ISN AutoIt Studio." & @CRLF & _
						"/isn_restart" & @TAB & @TAB & @TAB & "Restarts the ISN AutoIt Studio immediately." & @CRLF & _
						"/isn_shutdown" & @TAB & @TAB & @TAB & "Exits the ISN AutoIt Studio immediately." & @CRLF & _
						"/isn_open_file" & @TAB & @TAB & @TAB & "Try to open a file in ISN AutoIt Studio. Must be a full path!" & @CRLF & _
						"/isn_open_project" & @TAB & @TAB & "Opens a ISN project in the ISN AutoIt Studio. Path must point to the *.isn file! Must be a full path!" & @CRLF & _
						"/isn_print_script" & @TAB & @TAB & "Displays the print preview of the currently opened file in the ISN AutoIt Studio!" & @CRLF & _
						"/isn_test_au3_file" & @TAB & @TAB & "Test (run) an *.au3 file within the ISN AutoIt Studio in the currently opened project. Must be a full path!" & @CRLF & _
						" "
				ConsoleWrite("ISN AutoIt Studio Command Line Tool - Help:" & @CRLF & @CRLF)
				ConsoleWrite($helpstring & @CRLF)
				Exit
			EndIf

			;/isn_gui_handle
			If StringInStr($CmdLine[$x], "/isn_gui_handle ") Then
				$GUI_Handle_to_Set = StringStripWS(StringReplace($CmdLine[$x], "/isn_gui_handle ", ""), 3)
				ConsoleWrite("ISN main GUI handle set to " & $GUI_Handle_to_Set & "!" & @CRLF)
				$ISN_AutoIt_Studio_Mainwindow_Handle = Ptr($GUI_Handle_to_Set)
				$ISNPlugin_Status = "unlocked"
				$ISNPlugin_Message_Window_Handle = $Dummy_GUI
				GUIRegisterMsg(0x004A, "_ISNPlugin_Receive_Message") ;Register _WM_COPYDATA
			EndIf

		Next
	EndIf


	;If /isn_gui_handle has not already set the needed $ISNPlugin_Message_Window_Handle value, we will find it...
	If $ISN_AutoIt_Studio_Mainwindow_Handle = "" Then
		ConsoleWrite("ISN gui handle not set! Try to find the ISN AutoIt Studio main gui...")
		Opt("WinTitleMatchMode", 2)
		Opt("WinDetectHiddenText", 1)
		$Found_GUI = WinGetHandle("ISN AutoIt Studio", "ISN_MAIN_GUI")
		If @error Then
			ConsoleWrite("Error! No ISN AutoIt Studio window found!" & @CRLF)
			Return
		Else
			Opt("WinTitleMatchMode", 1)
			Opt("WinDetectHiddenText", 0)
			$ISN_AutoIt_Studio_Mainwindow_Handle = Ptr($Found_GUI)
			$ISNPlugin_Status = "unlocked"
			$ISNPlugin_Message_Window_Handle = $Dummy_GUI
			GUIRegisterMsg(0x004A, "_ISNPlugin_Receive_Message") ;Register _WM_COPYDATA
			ConsoleWrite("ISN AutoIt Studio found! (GUI Handle: " & $ISN_AutoIt_Studio_Mainwindow_Handle & ")" & @CRLF)
		EndIf
		Opt("WinTitleMatchMode", 1)
	EndIf



	;Main CMD Commands
	If IsArray($CmdLine) Then
		For $x = 1 To $CmdLine[0]

			;/isn_open_project
			If StringInStr($CmdLine[$x], "/isn_open_project ") Then
				$File_to_open = StringStripWS(StringReplace($CmdLine[$x], "/isn_open_project ", ""), 3)
				If FileExists($File_to_open) And StringInStr($File_to_open, ".isn") Then
					ConsoleWrite("Open project command send to the ISN AutoIt Studio!" & @CRLF)
					_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_Close_Project")
					$File_to_open = StringTrimRight($File_to_open, StringLen($File_to_open) - StringInStr($File_to_open, "\", 0, -1) + 1)
					_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Load_Project_by_Foldername", $File_to_open)
				Else
					ConsoleWrite("File '" & $File_to_open & "' not found!" & @CRLF)
				EndIf
			EndIf

			;/isn_backup_project
			If StringInStr($CmdLine[$x], "/isn_backup_project") Then
				ConsoleWrite("Backup command send to the ISN AutoIt Studio!" & @CRLF)
				_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Backup_Files")
			EndIf

			;/isn_open_file
			If StringInStr($CmdLine[$x], "/isn_open_file ") Then
				$File_to_open = StringStripWS(StringReplace($CmdLine[$x], "/isn_open_file ", ""), 3)
				If FileExists($File_to_open) Then
					ConsoleWrite("Open file command send to the ISN AutoIt Studio!" & @CRLF)
					_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("Try_to_opten_file", $File_to_open)
				Else
					ConsoleWrite("File '" & $File_to_open & "' not found!" & @CRLF)
				EndIf
			EndIf

			;/isn_test_au3_file
			If StringInStr($CmdLine[$x], "/isn_test_au3_file ") Then
				$File_to_test = StringStripWS(StringReplace($CmdLine[$x], "/isn_test_au3_file ", ""), 3)
				If FileExists($File_to_test) And StringInStr($File_to_test, ".au3") Then
					ConsoleWrite("Test au3 file command send to the ISN AutoIt Studio!" & @CRLF)
					_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Testscript", $File_to_test)
				Else
					ConsoleWrite("File '" & $File_to_test & "' not found or not an AutoIt 3 Script file (*.au3)!" & @CRLF)
				EndIf
			EndIf

			;/isn_compile_project
			If StringInStr($CmdLine[$x], "/isn_compile_project") Then
				ConsoleWrite("Compile command send to the ISN AutoIt Studio!" & @CRLF)
				$compilingGUI_Handle = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_Start_Compiling_Adlib")
				$compilingGUI_Handle = Ptr($compilingGUI_Handle)
				Sleep(1500) ;Give the ISN some Time...
				;Wait while the compile GUI is active
				While 1
					$Win_state = WinGetState($compilingGUI_Handle, "")
					If Not BitAND($Win_state, 2) Then ExitLoop
					Sleep(100)
				WEnd
				Sleep(1000) ;Give the ISN some Time...
			EndIf

			;/isn_test_project
			If StringInStr($CmdLine[$x], "/isn_test_project") Then
				ConsoleWrite("Test project command send to the ISN AutoIt Studio!" & @CRLF)
				_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_ISN_Projekt_Testen")
			EndIf


			;/isn_print_script
			If StringInStr($CmdLine[$x], "/isn_print_script") Then
				ConsoleWrite("Print command send to the ISN AutoIt Studio!" & @CRLF)
				_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_ISN_Print_current_file")
			EndIf


			;/close_project
			If StringInStr($CmdLine[$x], "/isn_close_project") Then
				ConsoleWrite("Close project command send to the ISN AutoIt Studio!" & @CRLF)
				_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Close_Project")
			EndIf


			;/isn_shutdown
			If StringInStr($CmdLine[$x], "/isn_shutdown") Then
				ConsoleWrite("Shutdown command send to the ISN AutoIt Studio!" & @CRLF)
				_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Shutdown_ISN_AutoIt_Studio")
				Return
			EndIf

			;/isn_restart
			If StringInStr($CmdLine[$x], "/isn_restart") Then
				ConsoleWrite("Restart command send to the ISN AutoIt Studio!" & @CRLF)
				_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Restart_ISN_AutoIt_Studio")
				Return
			EndIf

		Next
	EndIf


EndFunc   ;==>_Process_CMD_Commands

ConsoleWrite(@CRLF & "ISN Command Line Tool finished!" & @CRLF & @CRLF)
Exit

