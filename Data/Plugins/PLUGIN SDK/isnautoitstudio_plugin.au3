; ===============================================================================================================================
;
; ISN AutoIt Studio - Plugin SDK v.1.01 by ISI360
; Last Update: 24.08.2017
;
; ===============================================================================================================================
#include-once
#include <GuiStatusBar.au3>
#include <WinAPILocale.au3>
#include <Array.au3>

#cs
	;======== how to use (Basic) ==============================================================

	Using this Plugins UDF is realy simple. First of all, include this UDF in your plugin script.

	Then, after your first GUICreate place _ISNPlugin_initialize($gui_handle). $gui_handle should be the Handle to your already created GUI.
	Defining a GUI here is mandatory! The new Plugin System communicates via WM_COPYDATA. And this needs at least one GUI in your Plugin.
	If you plan a plugin without a GUI, make a dummy one. (invisible)
	If "notab_mode" is 0 in your plugin.ini (default), the GUI you entered with "_ISNPlugin_initialize" will be set as parent in the ISN AutoIt Studio. (Please see the help file in the ISN AutoIt Studio to find more about plugin.ini keys!)

	The Function _ISNPlugin_initialize will pause your script until a "unlock" command is received from an ISN AutoIt Studio instance.
	If the "unlock" command is received, the script execution continues.

	Basically, that´s it! From this point you should have a working plugin that can interact with the ISN AutoIt Studio in both directions!
	You can simply call now functions from the plugin in the ISN AutoIt Studio, or get Variables from the ISN AutoIt Studio to your Plugin.

	Of course you still need to set up a valid plugins.ini etc. for your new plugin. You will find instructions in the help file how to do this.

	For more details and examples, please look at the help file in the ISN AutoIt Studio! (Under the topic "Plugin SDK")
	Or visit my website: https://www.isnetwork.at. Here you will find some demo plugins, wich you can easily adapt to your needs.

	;==========================================================================================


	====== AVAILABLE FUNCTIONS ======
	_ISNPlugin_initialize
	_ISNPlugin_Get_Langstring
	_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio
	_ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio
	_ISNPlugin_Assign_Variable_from_ISN_AutoIt_Studio
	_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio
	_ISNPlugin_Execute_in_ISN_AutoIt_Studio
	_ISNPlugin_Studio_Set_Statusbartext
	_ISNPlugin_Studio_Get_Statusbartext
	_ISNPlugin_Try_to_open_file_in_ISN_AutoIt_Studio
	_ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable
	_ISNPlugin_Register_ISN_Event
	_ISNPlugin_Unregister_ISN_Event
	_ISNPlugin_Studio_Config_Read_Value
	_ISNPlugin_Studio_Config_Write_Value
	_ISNPlugin_Studio_Add_Program_Log_Text
	_ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio
	_ISNPlugin_Scintilla_Get_Text
	_ISNPlugin_Scintilla_Get_Line_Text
	_ISNPlugin_Scintilla_Get_Selection_Text
	_ISNPlugin_Scintilla_Get_Current_Linenumber
	_ISNPlugin_Scintilla_Get_Linenumber_from_Pos
	_ISNPlugin_Scintilla_Get_Current_Pos
	_ISNPlugin_Scintilla_Set_Current_Pos
	_ISNPlugin_Scintilla_Set_Text
	_ISNPlugin_Scintilla_Insert_Text
	_ISNPlugin_Scintilla_Delete_All_Lines
	_ISNPlugin_Show_AutoIt_Code_Window




	====== INTERNAL USE ONLY FUNCTIONS ======
	_ISNPlugin_Receive_Message
	_ISNPlugin_Processing_Messages
	_ISNPlugin_send_message_to_ISN
	_ISNPlugin_Messagestring_Get_Element
	_ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio
	_ISNPlugin_ArrayStringToArray
	_ISNPlugin_watch_guard
	_ISNPlugin_System_needs_double_byte_character_support

#ce

;======== ISN Plugin Environment variables ===================================
; Important variables for the Plugin. These Variables are filled with values from the ISN AutoIt Studio after _ISNPlugin_initialize
; Feel free to use one of the following Variables in you Plugin

;The default value of a Plugin is "locked". So the plugin won´t do anything before an ISN Autoit Studio instance "unlocks" the plugin.
;This is used for example by the function _ISNPlugin_initialize. If no ISN Studio "unlocks" the plugin, the plugin won´t start. (_ISNPlugin_initialize. return -1)
Global $ISNPlugin_Status = "locked"

;The Handle to the Main Window of the ISN AutoIt Studio Instance
Global $ISN_AutoIt_Studio_Mainwindow_Handle = ""

;The PID of the ISN AutoIt Studio Instance
Global $ISN_AutoIt_Studio_PID = ""

;Path from where the ISN AutoIt Studio is executed (It´s only the folder path! No "\Autoit_Studio.exe" included in this path!)
Global $ISN_AutoIt_Studio_EXE_Path = ""

;Path to the config.ini of the ISN AutoIt Studio
Global $ISN_AutoIt_Studio_Config_Path = ""

;Path to the selected language file of the ISN AutoIt Studio
Global $ISN_AutoIt_Studio_Languagefile_Path = ""

;Path to the currently opened project in the ISN AutoIt Studio
Global $ISN_AutoIt_Studio_opened_project_Path = ""

;Path to the project file (*.isn) of the currently opened project
Global $ISN_AutoIt_Studio_ISN_file_Path = ""

;Name of the currently opened project in the ISN AutoIt Studio
Global $ISN_AutoIt_Studio_opened_project_Name = ""

;Contains the last received message from the ISN AutoIt Studio
Global $ISNPlugin_Received_Message = ""

;Contains the last received message from the ISN AutoIt Studio after an "unlock" command
Global $ISNPlugin_Received_Message_after_unlock = ""

;Path to the User Data Directory (%myisndatadir%) of the ISN AutoIt Studio (Caching folders and the config.ini is here)
Global $ISN_AutoIt_Studio_Data_Directory = ""

;This is the window handle that recieves Messages from the ISN AutoIt Studios. It is set through the $hgui parameter in "_ISNPlugin_initialize".
Global $ISNPlugin_Message_Window_Handle = ""

;Use this path when you have to store some data from your plugin. (For example plugin settings)
;The default path is %myisndatadir%\Data\Plugins\<name of the plugin>.
Global $ISNPlugin_Data_Path = ""

;======== Events for _ISNPlugin_Register_ISN_Event (Please do not change!) ===================================
Global Const $ISN_AutoIt_Studio_Event_Switch_Tab = "switchtab"
Global Const $ISN_AutoIt_Studio_Event_Save_Command = "save"
Global Const $ISN_AutoIt_Studio_Event_Exit_Plugin = "exit"
Global Const $ISN_AutoIt_Studio_Event_Resize = "resize"
Global Const $ISN_AutoIt_Studio_Event_Check_Changes_before_Exit = "checkchanges"

;======== Global Consts for different functions (Please do not change!) ======================================
Global Const $Plugin_System_Delimiter = "|-ISN-|"
Global Const $Program_Log_Text_Normal = "false"
Global Const $Program_Log_Text_Bold = "true"
Global Const $Program_Log_Text_No_Time = "true"
Global Const $Program_Log_Text_Insert_Time = "false"
Global Const $Get_last_used_Scintilla_Handle = "sci_lastused"
Global Const $Get_all_Scintilla_Handles = "sci_all"
Global Const $Code_Window_Wait_For_Result = "0"
Global Const $Code_Window_Show_Code_Only = "1"

;======== More Global Stuff (Please do not change!) ==========================================================
Global $Current_Language_Array = ""
Global $Fallback_Language_Array = ""
Global $Plugin_Language = ""


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_initialize
; Description ...: Use this function to initialize your plugin. This function should be called early in your script. It pauses your script untill a "unlock" command comes from an ISN AutoIt Studio instance or the timeout expires.
; Syntax.........: _ISNPlugin_initialize($hgui)
; Parameters ....: $hgui 			- 	A Handle to a GUI. This GUI will be used to receive messages from the ISN AutoIt Studio via WM_COPYDATA.
;						  		 		This GUI will also be set as parent to the ISN AutoIt Studio Tab. (Only if "plugintype" in your plugin.ini is "1" or "2")
;						  		 		If you plan a Plugin without a GUI, please use a dummy GUI (Invisible GUI). WM_COPYDATA will not work without a GUI.
;				   $Use_Watch_Guard	-	If 1 this Function also registers the Plugin Watch Guard. It simply checks every 60 secounds (via AdlibRegister) if the ISN AutoIt Studio is alive. If not it will exit.
; Return values .: -2  -	No $hgui specified. @error will be set to -2
; 				   -1  -	No "unlock" command from an ISN AutoIt Studio is received, or the timout expires. @error will be set to -1
;                   1  -	Successful received an "unlock" command from an ISN AutoIt Studio instance. The Plugin can continue the startup process.
; Author ........: ISI360
; Remarks .......: If you plan a Plugin without a GUI, please use a dummy GUI (Invisible GUI). WM_COPYDATA will not work without a GUI.
; ===============================================================================================================================
Func _ISNPlugin_initialize($hgui = "", $Use_Watch_Guard = "1")
	If $hgui = "" Then
		SetError(-2)
		Return -2
	EndIf

	GUIRegisterMsg(0x004A, "_ISNPlugin_Receive_Message") ;Register _WM_COPYDATA

	Local $Plugin_Timer = 35 ;Wait about 4 Secounds to received an "unlock" command, otherwise it will crash with @error -1

	$GUI_old_Title = WinGetTitle($hgui) ;Save old Window Title
	WinSetTitle($hgui, "", "_ISNPLUGIN_STARTUP_") ;Set new Title to the Windows, so the ISN AutoIt Studio can find it easily
	GUISetState(@SW_ENABLE, $hgui) ;Enables the GUI. This also "fixes" the resizing problems at the startup of a plugin. I don´t know why ^^

	For $Timer = 0 To $Plugin_Timer
		Sleep(100)
		If $ISNPlugin_Status <> "locked" Then
			;The plugin is unlocked and can start!

			WinSetTitle($hgui, "", $GUI_old_Title) ;Restore old Window Title

			;Set Plugin Variables
			$ISNPlugin_Message_Window_Handle = $hgui
			$ISN_AutoIt_Studio_Mainwindow_Handle = Ptr(_ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 0)) ;Set the Mainwindow Handle
			$ISN_AutoIt_Studio_PID = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 2) ;Set the ISN AutoIt Studio PID
			$ISN_AutoIt_Studio_EXE_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 3) ;Set the ISN AutoIt Studio EXE Path
			$ISN_AutoIt_Studio_Config_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 4) ;Set the ISN AutoIt Studio config.ini Path
			$ISN_AutoIt_Studio_Languagefile_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 5) ;Set the ISN AutoIt Studio language file Path
			$ISN_AutoIt_Studio_opened_project_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 6) ;Set the path to the currently opened project
			$ISN_AutoIt_Studio_opened_project_Name = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 7) ;Set the name to the currently opened project
			$ISN_AutoIt_Studio_Data_Directory = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 8) ;Set the data directory path
			$ISN_AutoIt_Studio_ISN_file_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 9) ;Set the path to the project file of the current project
			$ISNPlugin_Data_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 10) ;Set the path to the data dir of the plugin

			;...and the LEGACY stuff
			$ISN_AutoIt_Studio_Fensterhandle = $ISN_AutoIt_Studio_Mainwindow_Handle
			$ISN_AutoIt_Studio_Projektpfad = $ISN_AutoIt_Studio_opened_project_Path
			$ISN_AutoIt_Studio_Konfigurationsdatei_Pfad = $ISN_AutoIt_Studio_Config_Path

			;Register the Watch Guard. If the ISN AutoIt Studio crashes, also close the Plugin (check every 60 seconds)
			If $Use_Watch_Guard = "1" Then AdlibRegister("_ISNPlugin_watch_guard", 60 * 1000)

			;Sends the ISN the "unlocked" message
			_ISNPlugin_send_message_to_ISN("unlocked")
			Return 1
		EndIf
	Next

	WinSetTitle($hgui, "", $GUI_old_Title) ;Restore old Window Title
	GUIRegisterMsg(0x004A, "") ;Remove MsgRegister

	;No "unlock" command received
	SetError(-1)
	Return -1
EndFunc   ;==>_ISNPlugin_initialize

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_watch_guard
; Description ...: This function is registered by "_ISNPlugin_initialize" in an AdlibRegister. It checkes every 60 secounds if the ISN AutoIt Studio is still alive. If not -> Exit!
; Syntax.........: _ISNPlugin_watch_guard()
; Author ........: ISI360
; Remarks .......: Internal use only.
; ===============================================================================================================================
Func _ISNPlugin_watch_guard()
	If $ISNPlugin_Status <> "locked" Then
		If Not WinExists($ISN_AutoIt_Studio_Mainwindow_Handle) Then
			ProcessClose(@AutoItPID) ;ISN AutoIt Studio has crashed -> Exit! ProcessClose is needed here. A simlpe exit will not work (endless CPU drain) cause Guis and _WinAPI_SetParent.
		EndIf
	EndIf
EndFunc   ;==>_ISNPlugin_watch_guard

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Receive_Message
; Description ...: The Message Function for WM_COPYDATA. Messages from the ISN AutoIt Studio are received by this function.
; Author ........: ISI360 (Based on code from Yashied)
; Remarks .......: This Function will be registered with the function "_ISNPlugin_initialize".
;				   This function calls "_ISNPlugin_Processing_Messages" via AdlibRegister. _ISNPlugin_Processing_Messages processes the incoming messages.
; ===============================================================================================================================
Func _ISNPlugin_Receive_Message($hWnd, $msgID, $wParam, $lParam) ;WM_COPYDATA
	Local $tCOPYDATA = DllStructCreate("dword;dword;ptr", $lParam)
	Local $tMsg = DllStructCreate("char[" & DllStructGetData($tCOPYDATA, 2) & "]", DllStructGetData($tCOPYDATA, 3))
	$Received_Message = BinaryToString(DllStructGetData($tMsg, 1), 4)
	If $ISNPlugin_Status = "locked" Then
		If StringInStr($Received_Message, "lock") Then $ISNPlugin_Received_Message = $Received_Message ;If plugin is in "locked" mode, allow only lock and unlock commands
	Else
		$ISNPlugin_Received_Message = $Received_Message ;Set latest Received Message
	EndIf
	AdlibRegister("_ISNPlugin_Processing_Messages", 0)
	Return 0
EndFunc   ;==>_ISNPlugin_Receive_Message

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Processing_Messages
; Description ...: The function is called via AdlibRegister from "_ISNPlugin_Receive_Message". It first trys the User commands (call _ISNPlugin_Processing_Userdefined_Messages) and then the builtin commands.
; Author ........: ISI360
; Remarks .......: This function calls "_ISNPlugin_Processing_Userdefined_Messages" for custom messages. (Like Exit or Save commands) For more, see Info at the top of this UDF.
; ===============================================================================================================================
Func _ISNPlugin_Processing_Messages()
	AdlibUnRegister("_ISNPlugin_Processing_Messages")
	Local $Message = $ISNPlugin_Received_Message

	;First try the Userdefined Functions. User function can be registered with _ISNPlugin_Register_ISN_Event.
	If $ISNPlugin_Status <> "locked" Then

		Switch _ISNPlugin_Messagestring_Get_Element($Message, 1)

			Case $ISN_AutoIt_Studio_Event_Switch_Tab
				If _ISNPlugin_Processing_Userdefined_Function($ISN_AutoIt_Studio_Event_Switch_Tab) Then Return

			Case $ISN_AutoIt_Studio_Event_Save_Command
				If _ISNPlugin_Processing_Userdefined_Function($ISN_AutoIt_Studio_Event_Save_Command) Then Return

			Case $ISN_AutoIt_Studio_Event_Exit_Plugin
				If _ISNPlugin_Processing_Userdefined_Function($ISN_AutoIt_Studio_Event_Exit_Plugin) Then Return

			Case $ISN_AutoIt_Studio_Event_Resize
				If _ISNPlugin_Processing_Userdefined_Function($ISN_AutoIt_Studio_Event_Resize) Then Return

			Case $ISN_AutoIt_Studio_Event_Check_Changes_before_Exit
				If _ISNPlugin_Processing_Userdefined_Function($ISN_AutoIt_Studio_Event_Check_Changes_before_Exit) Then Return


		EndSwitch
	EndIf

	;Second try the builtin commands (if no user command was found)
	Switch _ISNPlugin_Messagestring_Get_Element($Message, 1)

		Case "unlock"
			$ISNPlugin_Received_Message_after_unlock = $Message
			$ISNPlugin_Status = "unlocked"

		Case "lock"
			$ISNPlugin_Received_Message_after_unlock = ""
			$ISNPlugin_Status = "locked"

		Case "exit"
			Exit

		Case "callfunc_in_plugin", "callasyncfunc_in_plugin"
			If _ISNPlugin_Messagestring_Get_Element($Message, 3) = "" Then
				$result = Call(_ISNPlugin_Messagestring_Get_Element($Message, 2))
			EndIf

			If (_ISNPlugin_Messagestring_Get_Element($Message, 3) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 4) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 5) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 6) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 7) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 8) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 9) = "") Then
				$result = Call(_ISNPlugin_Messagestring_Get_Element($Message, 2), _ISNPlugin_Messagestring_Get_Element($Message, 3))
			EndIf

			If (_ISNPlugin_Messagestring_Get_Element($Message, 3) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 4) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 5) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 6) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 7) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 8) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 9) = "") Then
				$result = Call(_ISNPlugin_Messagestring_Get_Element($Message, 2), _ISNPlugin_Messagestring_Get_Element($Message, 3), _ISNPlugin_Messagestring_Get_Element($Message, 4))
			EndIf

			If (_ISNPlugin_Messagestring_Get_Element($Message, 3) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 4) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 5) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 6) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 7) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 8) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 9) = "") Then
				$result = Call(_ISNPlugin_Messagestring_Get_Element($Message, 2), _ISNPlugin_Messagestring_Get_Element($Message, 3), _ISNPlugin_Messagestring_Get_Element($Message, 4), _ISNPlugin_Messagestring_Get_Element($Message, 5))
			EndIf

			If (_ISNPlugin_Messagestring_Get_Element($Message, 3) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 4) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 5) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 6) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 7) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 8) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 9) = "") Then
				$result = Call(_ISNPlugin_Messagestring_Get_Element($Message, 2), _ISNPlugin_Messagestring_Get_Element($Message, 3), _ISNPlugin_Messagestring_Get_Element($Message, 4), _ISNPlugin_Messagestring_Get_Element($Message, 5), _ISNPlugin_Messagestring_Get_Element($Message, 6))
			EndIf

			If (_ISNPlugin_Messagestring_Get_Element($Message, 3) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 4) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 5) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 6) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 7) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 8) = "") And (_ISNPlugin_Messagestring_Get_Element($Message, 9) = "") Then
				$result = Call(_ISNPlugin_Messagestring_Get_Element($Message, 2), _ISNPlugin_Messagestring_Get_Element($Message, 3), _ISNPlugin_Messagestring_Get_Element($Message, 4), _ISNPlugin_Messagestring_Get_Element($Message, 5), _ISNPlugin_Messagestring_Get_Element($Message, 6), _ISNPlugin_Messagestring_Get_Element($Message, 7))
			EndIf

			If (_ISNPlugin_Messagestring_Get_Element($Message, 3) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 4) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 5) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 6) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 7) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 8) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 9) = "") Then
				$result = Call(_ISNPlugin_Messagestring_Get_Element($Message, 2), _ISNPlugin_Messagestring_Get_Element($Message, 3), _ISNPlugin_Messagestring_Get_Element($Message, 4), _ISNPlugin_Messagestring_Get_Element($Message, 5), _ISNPlugin_Messagestring_Get_Element($Message, 6), _ISNPlugin_Messagestring_Get_Element($Message, 7), _ISNPlugin_Messagestring_Get_Element($Message, 8))
			EndIf

			If (_ISNPlugin_Messagestring_Get_Element($Message, 3) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 4) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 5) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 6) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 7) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 8) <> "") And (_ISNPlugin_Messagestring_Get_Element($Message, 9) <> "") Then
				$result = Call(_ISNPlugin_Messagestring_Get_Element($Message, 2), _ISNPlugin_Messagestring_Get_Element($Message, 3), _ISNPlugin_Messagestring_Get_Element($Message, 4), _ISNPlugin_Messagestring_Get_Element($Message, 5), _ISNPlugin_Messagestring_Get_Element($Message, 6), _ISNPlugin_Messagestring_Get_Element($Message, 7), _ISNPlugin_Messagestring_Get_Element($Message, 8), _ISNPlugin_Messagestring_Get_Element($Message, 9))
			EndIf
			If _ISNPlugin_Messagestring_Get_Element($Message, 1) = "callfunc_in_plugin" Then _ISNPlugin_send_message_to_ISN("callfunc_in_plugin" & $Plugin_System_Delimiter & _ISNPlugin_Messagestring_Get_Element($Message, 2) & $Plugin_System_Delimiter & $result) ;Ergebnis ans Plugin zurücksenden senden


		Case "isn_set_var_in_plugin" ;ISN AutoIt Studio sends a Variable to the Plugin
			;Check is message is a ArrayString
			If StringInStr(_ISNPlugin_Messagestring_Get_Element($Message, 3), ":rowdelim:") Or StringInStr(_ISNPlugin_Messagestring_Get_Element($Message, 3), ":coldelim:") Then
				;Array
				$result = Assign(StringReplace(_ISNPlugin_Messagestring_Get_Element($Message, 2), "$", ""), _ISNPlugin_ArrayStringToArray(_ISNPlugin_Messagestring_Get_Element($Message, 3)), 2)
			Else
				;Variable
				$result = Assign(StringReplace(_ISNPlugin_Messagestring_Get_Element($Message, 2), "$", ""), _ISNPlugin_Messagestring_Get_Element($Message, 3), 2)
			EndIf
			_ISNPlugin_send_message_to_ISN("isn_set_var_in_plugin" & $Plugin_System_Delimiter & _ISNPlugin_Messagestring_Get_Element($Message, 2) & $Plugin_System_Delimiter & $result)

		Case "isn_request_var_in_plugin" ;ISN AutoIt Studio requests a Varaible from the Plugin
			$return_var = Execute(_ISNPlugin_Messagestring_Get_Element($Message, 2))
			If IsArray($return_var) Then $return_var = _ArrayToString($return_var, ":rowdelim:", Default, Default, ":coldelim:")
			_ISNPlugin_send_message_to_ISN("isn_request_var_in_plugin" & $Plugin_System_Delimiter & _ISNPlugin_Messagestring_Get_Element($Message, 3) & $Plugin_System_Delimiter & $return_var)

		Case "checkchanges"
			_ISNPlugin_send_message_to_ISN("changesok")

	EndSwitch

EndFunc   ;==>_ISNPlugin_Processing_Messages

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Studio_Add_Program_Log_Text
; Description ...: Inserts a new message in the program log of the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Studio_Add_Program_Log_Text($hgui)
; Parameters ....: $Text 				- 	Text to insert.
;				   $Textcolor			-	Color of the text in RGB Hex. Default is 0x000000.
;				   $Bold				-	Set it to $Program_Log_Text_Bold if you want to display the text bold. Or use $Program_Log_Text_Normal for normal (default.
;				   $Text_without_time	-	Set it to $Program_Log_Text_No_Time if you don´t want the time displayed before your text. Or use $Program_Log_Text_Insert_Time to insert time (default).
; Return values .: -1		 -	$Text is empty. Sets @error to -1
;                   Success  -	Text is inserted in the program log
; Author ........: ISI360
; Remarks .......: If you plan a Plugin without a GUI, please use a dummy GUI (Invisible GUI). WM_COPYDATA will not work without a GUI.
; ===============================================================================================================================
Func _ISNPlugin_Studio_Add_Program_Log_Text($Text = "", $Textcolor = 0x000000, $Bold = "false", $Text_without_time = "false")
	If $Text = "" Then
		SetError(-1)
		Return -1
	EndIf

	$Textcolor = StringReplace(String(Hex($Textcolor, 6)), "0x", "")
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_Write_log", $Text, $Textcolor, $Bold, $Text_without_time)
	Return $result
EndFunc   ;==>_ISNPlugin_Studio_Add_Program_Log_Text

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_send_message_to_ISN
; Description ...: Sends a command message to the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_send_message_to_ISN($message)
; Parameters ....: $message - 	Messagestring to transfer to the ISN AutoIt Studio
; Return values .: -1  -	No $message specified. @error will be set to -2
; 				    0  -	Error while transfering the message to the ISN AutoIt Studio
;                   1  -	Successful transfered the message
; Author ........: ISI360 (Based on code from Yashied)
; Remarks .......: Messagestring are formated like this: <sender window>|<command>|<Data>|<Data>|<Data>|<Data>|<Data>...
;				   $Plugin_System_Delimiter is the delemiter between the messages
; ===============================================================================================================================
Func _ISNPlugin_send_message_to_ISN($Message = "")
	If $Message = "" Then
		SetError(-1)
		Return -1
	EndIf
	$Message = $ISNPlugin_Message_Window_Handle & $Plugin_System_Delimiter & $Message
	$Message = StringToBinary($Message, 4)
	Local $tCOPYDATA, $tMsg
	$tMsg = DllStructCreate("char[" & StringLen($Message) + 1 & "]")
	DllStructSetData($tMsg, 1, $Message)
	$tCOPYDATA = DllStructCreate("dword;dword;ptr")
	DllStructSetData($tCOPYDATA, 2, StringLen($Message) + 1)
	DllStructSetData($tCOPYDATA, 3, DllStructGetPtr($tMsg))
	$Ret = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $ISN_AutoIt_Studio_Mainwindow_Handle, "int", 0x004A, "wparam", 0, "lparam", DllStructGetPtr($tCOPYDATA))
	If (@error) Or ($Ret[0] = -1) Then Return 0
	Return 1
EndFunc   ;==>_ISNPlugin_send_message_to_ISN

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Messagestring_Get_Element
; Description ...: Use this function to easily get elements from a Messagestring.
; Syntax.........: _ISNPlugin_Messagestring_Get_Element($string = "", $Element = 0)
; Parameters ....: $string  - The Messagestring to edit.
;				   $Element - Zero based element index. This part of the string will be returned.
; Return values .:  The wished element of the String OR "" if $Element is out of the index
; Author ........: ISI360
; Remarks .......: A messagestring is formated in a specific way (see info on the top of this UDF). With this function you can easily access the wished element in the string.
;				  For example: _ISNPlugin_Messagestring_Get_Element("0x12345|save",1) will return "save".
;                 [0] = Sender window of the message
;                 [1] = command
;                 [2] = Data
;				  ...
; ===============================================================================================================================
Func _ISNPlugin_Messagestring_Get_Element($string = "", $Element = 0)
	If $string = "" Then Return ""
	Local $Split = StringSplit($string, $Plugin_System_Delimiter, 3)
	If Not IsArray($Split) Then Return ""
	If $Element > UBound($Split) - 1 Then Return ""
	Return $Split[$Element]
EndFunc   ;==>_ISNPlugin_Messagestring_Get_Element

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio
; Description ...: Wait a given time until a given message is received from the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio($Command = "", $Timeout = 2000)
; Parameters ....: $Command - 	The command to wait for
;				   $Timeout - 	Timout of the function.
; Return values .: -1  		-	Timout expires (Sets @error to -1)
; 				   Success  -	Returns the full received messagestring
; Author ........: ISI360
; Remarks .......: Is used by internal functions. The function exits immediately if the ISN AutoIt Studio window does not exist anymore. (Crashed or someting else)
; ===============================================================================================================================
Func _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio($Command = "", $Timeout = 2000)
	If $Command = "" Then Return
	If $Timeout = "" Then Return
	Local $result = ""
	While 1

		If $ISNPlugin_Received_Message <> "" Then
			If _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message, 0) = $ISN_AutoIt_Studio_Mainwindow_Handle And StringLower(_ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message, 1)) = StringLower($Command) Then ExitLoop
		EndIf

		$Timeout = $Timeout - 100
		If Not WinExists($ISN_AutoIt_Studio_Mainwindow_Handle) Then $Timeout = -1 ;ISN AutoIt Studio may crashed?
		If $Timeout < 0 Then ExitLoop
		Sleep(100)

	WEnd
	If $Timeout < 0 Then
		Return -1
		SetError(-1)
	EndIf

	$result = $ISNPlugin_Received_Message
	$ISNPlugin_Received_Message = "" ;Reset the last message
	Return $result
EndFunc   ;==>_ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio
; Description ...: Returns the value of a Variable from the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio($Varname = "")
; Parameters ....: $Varname - 	The name of the variable you want the value from. Syntax is like the "Assign" command from AutoIt.
; Return values .: ""  		-	$Varname is empty or the variable does not exists in the ISN AutoIt Studio
; 				   Success  -	The Value of the Variable
; Author ........: ISI360
; Remarks .......: The Parameter ($Varname) must contain a $ symbol do work correctly! (Like the "Assign" command in the AutoIt help)
;				   This function can also transfer arrays from the ISN AutoIt Studio to the plugin!
; ===============================================================================================================================
Func _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio($Varname = "")
	If $Varname = "" Then Return ""
	_ISNPlugin_send_message_to_ISN("isn_plugin_request_var" & $Plugin_System_Delimiter & $Varname)
	Local $result = _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio("isn_plugin_request_var", 2000)
	;Prufe ob der Empfangene String ein ArrayString ist
	If StringInStr(_ISNPlugin_Messagestring_Get_Element($result, 3), ":rowdelim:") Or StringInStr(_ISNPlugin_Messagestring_Get_Element($result, 3), ":coldelim:") Then
		;Array
		Return _ISNPlugin_ArrayStringToArray(_ISNPlugin_Messagestring_Get_Element($result, 3))
	Else
		;Variable
		Return _ISNPlugin_Messagestring_Get_Element($result, 3)
	EndIf
	Return ""
EndFunc   ;==>_ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Assign_Variable_From_ISN_AutoIt_Studio
; Description ...: Returns a Variable from the ISN AutoIt Studio and Assign it to a new Variable in the Plugin. (Like the old _ISNPlugin_Get_Variable function)
; Syntax.........: _ISNPlugin_Assign_Variable_From_ISN_AutoIt_Studio($Destination_var = "", $Varname = "")
; Parameters ....: $Destination_var - 	The name of the variable you wish to assign in the plugin. Syntax is like the "Assign" command from AutoIt.
; 				   $Varname 		- 	The Variable you want to transfer from the ISN AutoIt Studio to the new variable (for example: "$Studiofenster")
; Return values .: ""  -	$Destination_var or $Varname is empty
; 				   -1  -	Unknown error. Sets @error to -1
;                   0  -	Unable to create/assign the variable
;                   1  -	Success
; Author ........: ISI360
; Remarks .......: This function acts exactly like the old "_ISNPlugin_Get_Variable" function
;				   Both Parameters ($Destination_var and $Varname) must contain a $ symbol do work correctly! (Like the "Assign" command in the AutoIt help)
;				   This function can also transfer arrays from the ISN AutoIt Studio to the plugin!
; ===============================================================================================================================
Func _ISNPlugin_Assign_Variable_from_ISN_AutoIt_Studio($Destination_var = "", $Varname = "")
	If $Destination_var = "" Then Return ""
	If $Varname = "" Then Return ""
	_ISNPlugin_send_message_to_ISN("isn_plugin_request_var" & $Plugin_System_Delimiter & $Varname & $Plugin_System_Delimiter & $Destination_var)
	Local $result = _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio("isn_plugin_request_var", 2000)
	;Prufe ob der Empfangene String ein ArrayString ist
	If StringInStr(_ISNPlugin_Messagestring_Get_Element($result, 3), ":rowdelim:") Or StringInStr(_ISNPlugin_Messagestring_Get_Element($result, 3), ":coldelim:") Then
		;Array
		Return Assign(StringReplace(_Pluginstring_get_element($result, 4), "$", ""), _ISNPlugin_ArrayStringToArray(_ISNPlugin_Messagestring_Get_Element($result, 3)), 2)
	Else
		;Variable
		Return Assign(StringReplace(_Pluginstring_get_element($result, 4), "$", ""), _ISNPlugin_Messagestring_Get_Element($result, 3), 2)
	EndIf
	Return -1
	SetError(-1)
EndFunc   ;==>_ISNPlugin_Assign_Variable_from_ISN_AutoIt_Studio

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Get_langstring
; Description ...: Returns a String from the langugage file of the plugin. The language files should be stored under @ScriptDir\language\*.lng.
; Syntax.........: _ISNPlugin_Get_langstring($id)
; Parameters ....: $id - Language String (number) you want to know
; Return values .: "#LANGUAGE_ERROR#"   -	Error in the langauge file. (String, or file not found)
; 				   Success  			-	A Text string
; Author ........: ISI360
; Remarks .......: The selected language is the same as in the ISN AutoIt Studio. So if you want to use this function, please make sure that your plugin has the following things:
;				   A subfolder called "Language". Here you can put the language files. (*.lng) The files must have the same name as the selected one in the ISN AutoIt Studio. (for example "german.lng")
;				   The Section in the language file is [plugin]. A language file (*.lng) is just a simple ini file numbered with str1 to strXXX. So with _ISNPlugin_Get_langstring(1) you will get the string of key "str1".
;				   See the demo plugin on my website. This has also multilanguage capabilities.
;				   NOTE: This function can be called before _ISNPlugin_initialize! So you can use it to "build" your GUI before "_ISNPlugin_initialize"!
; ===============================================================================================================================
Func _ISNPlugin_Get_langstring($id = 0)
	If $Plugin_Language = "" Then
		$Plugin_Language = RegRead("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "plugin_language")
		If $Plugin_Language = "" Then $Plugin_Language = "english.lng"
	EndIf

	If $id < 1 Then Return ""
	Local $String_to_return = ""

	;Reads the current language in the buffer
	If $Current_Language_Array = "" Then
		Local $Empty_Array[1]
		_ArrayDelete($Empty_Array, 0)
		$Current_Language_Array = $Empty_Array
		$Current_Language_Array = StringRegExp(FileRead(@ScriptDir & "\language\" & $Plugin_Language), "(?m)(?i)^str\d+\=(.*)", 3)
		_ArrayInsert($Current_Language_Array, 0, $Plugin_Language)
	EndIf

	;And the backup (fallback) language
	If $Fallback_Language_Array = "" Then
		Local $Empty_Array[1]
		_ArrayDelete($Empty_Array, 0)
		$Fallback_Language_Array = $Empty_Array
		$Fallback_Language_Array = StringRegExp(FileRead(@ScriptDir & "\language\english.lng"), "(?m)(?i)^str\d+\=(.*)", 3)
		_ArrayInsert($Fallback_Language_Array, 0, "english.lng")
	EndIf

	If Not IsArray($Current_Language_Array) And Not IsArray($Fallback_Language_Array) Then Return "#LANGUAGE_ERROR#" & $id

	If $id > UBound($Current_Language_Array) - 1 Then
		If $id > UBound($Fallback_Language_Array) - 1 Then
			Return "#LANGUAGE_ERROR#" & $id
		Else
			$String_to_return = StringReplace($Fallback_Language_Array[$id], "[BREAK]", @CRLF)
		EndIf
	Else
		$String_to_return = StringReplace($Current_Language_Array[$id], "[BREAK]", @CRLF)
	EndIf

	If $String_to_return = "" Then
		$String_to_return = StringReplace($Fallback_Language_Array[$id], "[BREAK]", @CRLF)
		If $String_to_return = "" Then $String_to_return = "#LANGUAGE_ERROR#" & $id
	EndIf
	Return $String_to_return
EndFunc   ;==>_ISNPlugin_Get_langstring


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Studio_Config_Write_Value
; Description ...: Write a value in the ISN AutoIt Studio config (config.ini)
; Syntax.........: _ISNPlugin_Studio_Config_Write_Value($key = "", $value = "")
; Parameters ....: $key 	- The key name in the .ini file to write to.
;				   $value 	- The value to write/change.
; Return values .: -1 - $key is empty. Sets @error to -1
;					0 - config.ini is read only
;                   1 - Success
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Studio_Config_Write_Value($key = "", $value = "")
	If $key = "" Then
		Return "-1"
		SetError(-1)
	EndIf
	Return IniWrite($ISN_AutoIt_Studio_Config_Path, "config", $key, $value)
EndFunc   ;==>_ISNPlugin_Studio_Config_Write_Value

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Studio_Config_Read_Value
; Description ...: Read a value from the ISN AutoIt Studio config (config.ini)
; Syntax.........: _ISNPlugin_Studio_Config_Read_Value($key="", $errorkey="")
; Parameters ....: $key 		- The key name in the .ini file to read from.
;				   $errorkey 	- The default value to return if the requested key is not found. Default is "".
; Return values .: -1		- $key is empty. Sets @error to -1
;					Error	- Returns $errorkey
;                   Success - the requested key value as a string
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Studio_Config_Read_Value($key = "", $errorkey = "")
	Local $result = ""
	If $key = "" Then
		Return "-1"
		SetError(-1)
	EndIf
	$result = IniRead($ISN_AutoIt_Studio_Config_Path, "config", $key, $errorkey)
	Return $result
EndFunc   ;==>_ISNPlugin_Studio_Config_Read_Value

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Call_function_in_ISN_AutoIt_Studio
; Description ...: Calls a function in the ISN AutoIt Studio with 7 optional parameters and return the result back to the Plugin
; Syntax.........: _ISNPlugin_Call_function_in_ISN_AutoIt_Studio($funcname [,$param1,$param2,$param3,$param4,$param5,,$param6,$param7])
; Parameters ....: $funcname - Name of the function to call (for example: "_exit")
; Return values .: -1 		- Can not call the function in the ISN. Sets @error to -1
;					0 		- $funcname is empty
;                   Success - The result of the called function in the ISN AutoIt Studio
; Author ........: ISI360
; Modified.......:
; Remarks .......: Function acts like the old "_ISNPlugin_Starte_Funktion_im_ISN" function. But now with return functions!
;
; ===============================================================================================================================
Func _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio($funcname = "", $param1 = "", $param2 = "", $param3 = "", $param4 = "", $param5 = "", $param6 = "", $param7 = "")
	If $funcname = "" Then Return 0
	Local $Parameter = ""
	If $param1 <> "" Then $Parameter = $Parameter & $param1 & $Plugin_System_Delimiter
	If $param2 <> "" Then $Parameter = $Parameter & $param2 & $Plugin_System_Delimiter
	If $param3 <> "" Then $Parameter = $Parameter & $param3 & $Plugin_System_Delimiter
	If $param4 <> "" Then $Parameter = $Parameter & $param4 & $Plugin_System_Delimiter
	If $param5 <> "" Then $Parameter = $Parameter & $param5 & $Plugin_System_Delimiter
	If $param6 <> "" Then $Parameter = $Parameter & $param6 & $Plugin_System_Delimiter
	If $param7 <> "" Then $Parameter = $Parameter & $param7
	If $Parameter <> "" Then $Parameter = $Plugin_System_Delimiter & $Parameter
	_ISNPlugin_send_message_to_ISN("callfunc_in_ISN" & $Plugin_System_Delimiter & $funcname & $Parameter)
	Local $result = _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio("callfunc_in_ISN", 5000)
	If @error Or $result = "" Then
		Return ""
		SetError(-1)
	EndIf
	Return _ISNPlugin_Messagestring_Get_Element($result, 3)
EndFunc   ;==>_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio
; Description ...: Same as _ISNPlugin_Call_function_in_ISN_AutoIt_Studio, but in this case there will be no return value. So here you will get not result!
; Syntax.........: _ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio($funcname [,$param1,$param2,$param3,$param4,$param5,,$param6,$param7])
; Parameters ....: $funcname - Name of the function to call (for example: "_exit")
; Return values .: -1 		- Can not call the function in the ISN. Sets @error to -1
;					0 		- $funcname is empty
;                   Success - Call submited to the ISN AutoIt Studio
; Author ........: ISI360
; Modified.......:
; Remarks .......:
;
; ===============================================================================================================================
Func _ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio($funcname = "", $param1 = "", $param2 = "", $param3 = "", $param4 = "", $param5 = "", $param6 = "", $param7 = "")
	If $funcname = "" Then Return 0
	Local $Parameter = ""
	If $param1 <> "" Then $Parameter = $Parameter & $param1 & $Plugin_System_Delimiter
	If $param2 <> "" Then $Parameter = $Parameter & $param2 & $Plugin_System_Delimiter
	If $param3 <> "" Then $Parameter = $Parameter & $param3 & $Plugin_System_Delimiter
	If $param4 <> "" Then $Parameter = $Parameter & $param4 & $Plugin_System_Delimiter
	If $param5 <> "" Then $Parameter = $Parameter & $param5 & $Plugin_System_Delimiter
	If $param6 <> "" Then $Parameter = $Parameter & $param6 & $Plugin_System_Delimiter
	If $param7 <> "" Then $Parameter = $Parameter & $param7
	If $Parameter <> "" Then $Parameter = $Plugin_System_Delimiter & $Parameter
	_ISNPlugin_send_message_to_ISN("callfunc_async_in_ISN" & $Plugin_System_Delimiter & $funcname & $Parameter)
	Return 1
EndFunc   ;==>_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Try_to_open_file_in_ISN_AutoIt_Studio
; Description ...: Try to open a file in the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Try_to_open_file_in_ISN_AutoIt_Studio($filepath = "")
; Parameters ....: $filepath - File to open (example: C:\temp\test.au3)
; Return values .: -1 - Can not call the function in the ISN. Sets @error to -1
;					0 - $filepath is empty
;					1 - Success
; Author ........: ISI360
; Modified.......:
; Remarks .......:
;
; ===============================================================================================================================
Func _ISNPlugin_Try_to_open_file_in_ISN_AutoIt_Studio($filepath = "")
	Local $result = ""
	If $filepath = "" Then Return 0
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_Try_to_open_file", $filepath)
	If @error Or $result = "" Then
		Return "-1"
		SetError(-1)
	EndIf
	Return $result
EndFunc   ;==>_ISNPlugin_Try_to_open_file_in_ISN_AutoIt_Studio


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable
; Description ...: Try to resolve ISN AutoIt Studio pathvaraible. (For example %compileddir%)
; Syntax.........: _ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable($variable = "")
; Parameters ....: $variable - Variable you want to know
; Return values .: -1 - Can not call the function in the ISN. Sets @error to -1
;					0 - $variable is empty
;			  Success - The Path or value of the varaible
; Author ........: ISI360
; Modified.......:
; Remarks .......:
;
; ===============================================================================================================================
Func _ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable($variable = "")
	Local $result = ""
	If $variable = "" Then Return 0
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_ISN_Variablen_aufloesen", $variable)
	If @error Or $result = "" Then
		Return "-1"
		SetError(-1)
	EndIf
	Return $result
EndFunc   ;==>_ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Execute_in_ISN_AutoIt_Studio
; Description ...: Executes a command in the ISN AutoIt Studio (with Execute) and return the result to the Plugin
; Syntax.........: _ISNPlugin_Execute_in_ISN_AutoIt_Studio($command = "")
; Parameters ....: $command - Command to execute (for example: 'msgbox(3,"Hi","Text")')
; Return values .: Success - The return value of the evaluated expression in the ISN AutoIt Studio
;                  Failure - Return "" and set @error to -1
; Author ........: ISI360
; Modified.......:
; Remarks .......: Function acts like the old "_ISNPlugin_Starte_Funktion_im_ISN" function.
;
; ===============================================================================================================================
Func _ISNPlugin_Execute_in_ISN_AutoIt_Studio($Command = "")
	Local $result = ""
	If $Command = "" Then
		Return ""
		SetError(-1)
	EndIf
	_ISNPlugin_send_message_to_ISN("execute_in_ISN" & $Plugin_System_Delimiter & $Command)
	Local $result = _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio("execute_in_ISN", 5000)
	If @error Or $result = "" Then
		Return ""
		SetError(-1)
	EndIf
	Return _ISNPlugin_Messagestring_Get_Element($result, 3)
EndFunc   ;==>_ISNPlugin_Execute_in_ISN_AutoIt_Studio

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio
; Description ...: Sets a variable from the plugin in the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio($Varname = "", $Value = "")
; Parameters ....: $Varname - 	The name of the variable you want to set. Syntax is like the "Assign" command from AutoIt.
;				   $Value	-	The Value to set to the variable. This can also be a array!
; Return values .: ""  		-	$Varname or $Value is empty
; 				   -1  		-	unable to create/assign the variable. @error is set to -1
; 				   1		-	Value is set in the ISN AutoIt Studio
; Author ........: ISI360
; Remarks .......: The Parameter ($Varname) must contain a $ symbol do work correctly! (Like the "Assign" command in the AutoIt help)
;				   This function can also transfer arrays from the ISN AutoIt Studio to the plugin!
; ===============================================================================================================================
Func _ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio($Varname = "", $value = "")
	If $Varname = "" Then Return ""
	If $value = "" Then Return ""
	Local $result = ""
	$Varname = StringReplace($Varname, "$", "")
	If IsArray($value) Then
		;Array
		$array_string = _ArrayToString($value, ":rowdelim:", Default, Default, ":coldelim:")
		_ISNPlugin_send_message_to_ISN("isn_plugin_set_var" & $Plugin_System_Delimiter & $Varname & $Plugin_System_Delimiter & $array_string)
	Else
		;Variable
		_ISNPlugin_send_message_to_ISN("isn_plugin_set_var" & $Plugin_System_Delimiter & $Varname & $Plugin_System_Delimiter & $value)
	EndIf
	Local $result = _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio("isn_plugin_set_var", 5000)
	If @error Or $result = "" Then
		Return -1
		SetError(-1)
	EndIf
	Return _ISNPlugin_Messagestring_Get_Element($result, 3)
EndFunc   ;==>_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Studio_Set_Statusbartext
; Description ...: Sets the text of the status bar of the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Studio_Set_Statusbartext($Text = "")
; Parameters ....: $Text - Text to set in the statusbar
; Return values .: True  - Success
;                  False - Failure
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Studio_Set_Statusbartext($Text = "")
	If $Text = "" Then Return False
	If $ISN_AutoIt_Studio_Mainwindow_Handle = "" Then Return False
	Local $ControlHandle = ControlGetHandle($ISN_AutoIt_Studio_Mainwindow_Handle, "", "[CLASS:msctls_statusbar32]")
	Return _GUICtrlStatusBar_SetText(ControlGetHandle($ISN_AutoIt_Studio_Mainwindow_Handle, "", $ControlHandle), $Text)
EndFunc   ;==>_ISNPlugin_Studio_Set_Statusbartext

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Studio_Get_Statusbartext
; Description ...: Gets the text of the status bar of the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Studio_Get_Statusbartext($part = 0)
; Parameters ....: $part    - 0-based part index [optional]
; Return values .: Success  - Text of the Statusbar
;                  -1		- Failure. Sets @error to -1
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Studio_Get_Statusbartext($part = 0)
	Local $result = ""
	If $ISN_AutoIt_Studio_Mainwindow_Handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	Local $ControlHandle = ControlGetHandle($ISN_AutoIt_Studio_Mainwindow_Handle, "", "[CLASS:msctls_statusbar32]")
	$result = _GUICtrlStatusBar_GetText(ControlGetHandle($ISN_AutoIt_Studio_Mainwindow_Handle, "", $ControlHandle), $part)
	If @error Then SetError(-1)
	Return $result
EndFunc   ;==>_ISNPlugin_Studio_Get_Statusbartext

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Register_ISN_Event
; Description ...: Registers a specific function in the Plugin to an Event in the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Register_ISN_Event($event = "", $function = "")
; Parameters ....: $event 			- 	When the following event is triggered in the ISN AutoIt Studio, $function will be called in the plugin.
;
;				   You can use the following ISN Events:
;				   $ISN_AutoIt_Studio_Event_Switch_Tab 					When the user (or the ISN) switches from one tab to another in the ISN AutoIt Studio
;				   $ISN_AutoIt_Studio_Event_Save_Command				When the user (or the ISN) press the "save" button in the ISN AutoIt Studio
;				   $ISN_AutoIt_Studio_Event_Exit_Plugin					When the user (or the ISN) tries to exit the plugin (close the tab)
;				   $ISN_AutoIt_Studio_Event_Resize						Called when the ISN AutoIt Studio is resized
;				   $ISN_AutoIt_Studio_Event_Check_Changes_before_Exit	When the ISN AutoIt Studio exits a plugin, it sends a command to check changes before closing. NOTE: If you use this trigger, you must complete the call with _ISNPlugin_send_message_to_ISN("changesok")
;
;
;				   $function		-	This function will be called when the $event is triggered.
; Return values .:  -1 -	$event or $function is empty. Sets @error to -1
;					0  -	Cannot register the event, or $event or $function is empty. Sets @error to -1
;                   1  -	Event registered
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Register_ISN_Event($event = "", $function = "")
	Local $result = ""
	If $event = "" Or $function = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = Assign($event & "_pluginfunc", $function, 2)
	If $result = 0 Then SetError(-1)
	Return $result
EndFunc   ;==>_ISNPlugin_Register_ISN_Event

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Unregister_ISN_Event
; Description ...: Unregisters an already registered Event function from _ISNPlugin_Unregister_ISN_Event.
; Syntax.........: _ISNPlugin_Unregister_ISN_Event($event = "")
; Parameters ....: $event 			- 	Event to unregister. See _ISNPlugin_Unregister_ISN_Event for possible Events.
; Return values .:  0  -	Cannot unregister the event, or $event or is empty. Sets @error to -1
;                   1  -	Event unregistered
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Unregister_ISN_Event($event = "")
	Local $result = ""
	If $event = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = Assign($event & "_func", "", 2)
	If $result = 0 Then SetError(-1)
	Return $result
EndFunc   ;==>_ISNPlugin_Unregister_ISN_Event


;==========================================================================================
;
; Name...........: _ISNPlugin_ArrayStringToArray
; Description ...: Converts an Arraystring to an real Array (1D or 2D)
; Syntax.........: _ISNPlugin_ArrayStringToArray($sString, $sDelim4Rows, $sDelim4Cols)
; Parameters ....: $sString = ArrayString
;                  $sDelim4Rows = Delimiter for rows
;                  $sDelim4Cols = Delimiter fur columns
; Return values .: Array (1D or 2D)
; Author ........: guinness
; Modified.......: ISI360
; Remarks .......: For internal use only. This function is used, when you transfer a array to the plugin, or to the ISN.
;==========================================================================================
Func _ISNPlugin_ArrayStringToArray($sString = "", $sDelim4Rows = ":rowdelim:", $sDelim4Cols = ":coldelim:")
	If $sString = "" Then Return
	Local $aArray = StringSplit($sString, $sDelim4Rows, 3) ; Split to get rows
	Local $iBound = UBound($aArray)

	Local $aRet[$iBound][2], $aTemp, $iOverride = 0
	For $i = 0 To $iBound - 1
		$aTemp = StringSplit($aArray[$i], $sDelim4Cols, 3) ; Split to get row items
		If Not @error Then
			If $aTemp[0] > $iOverride Then
				$iOverride = $aTemp[0]
				ReDim $aRet[$iBound][$iOverride] ; Add columns to accomodate more items
			EndIf
		EndIf

		For $j = 1 To $aTemp[0]
			$aRet[$i][$j - 1] = $aTemp[$j] ; Populate each row
		Next
	Next
	If $iOverride <= 1 Then $aRet = $aArray ; Array contains single row or column

	Return $aRet
EndFunc   ;==>_ISNPlugin_ArrayStringToArray

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Processing_Userdefined_Function
; Description ...: Calls a user defined function, registered with _ISNPlugin_Register_ISN_Event
; Author ........: ISI360
; Remarks .......: For internal use only!
; ===============================================================================================================================
Func _ISNPlugin_Processing_Userdefined_Function($Command = "")
	If $Command = "" Then Return False
	If IsDeclared($Command & "_pluginfunc") Then
		$Func_to_call = Execute("$" & $Command & "_pluginfunc")
		If $Func_to_call <> "" Then
			Call($Func_to_call)
			If Not @error Then Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>_ISNPlugin_Processing_Userdefined_Function


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio
; Description ...: Gets the Handle to an Scintilla Control of the ISN AutoIt Studio.
; Syntax.........: _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio($Flags="")
; Parameters ....: $Flags 			- 	You can control with $Flags wich Control you want to know.
;
;				   $Flags can have one of the following values:
;				   $Get_last_used_Scintilla_Handle		 				Returns the handle of the last used Scintilla control in the ISN AutoIt Studio. The returned value will be a HWND string.
;				   $Get_all_Scintilla_Handles 							Returns an Array with all currently opened Scintilla controls in the ISN AutoIt Studio.
;																		The array is formates as follows: column 0: HWND Handle to the Scintilla control; column 1: Full path of the file witch is loaded in the this Scintilla control

; Return values .:  -1  	 -	$Flags is empty. Sets @error to -1
;                   Success  -	Return values depend on $Flags. See above.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio($Flags = "")
	If $Flags = "" Then
		SetError(-1)
		Return -1
	EndIf

	Switch $Flags
		Case $Get_last_used_Scintilla_Handle
			Local $result = ""
			$result = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Last_Used_Scintilla_Control")
			Return $result

		Case $Get_all_Scintilla_Handles
			Local $return_Array[1][2]
			_ArrayDelete($return_Array, 0) ;For an empty Array
			$Datei_pfad_array = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Datei_pfad")
			If Not IsArray($Datei_pfad_array) Then Return $return_Array
			$SCE_EDITOR_array = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$SCE_EDITOR")
			If Not IsArray($SCE_EDITOR_array) Then Return $return_Array
			$Plugin_Handle_array = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Plugin_Handle")
			If Not IsArray($Plugin_Handle_array) Then Return $return_Array
			For $x = 0 To UBound($SCE_EDITOR_array) - 1
				If $Plugin_Handle_array[$x] = "" Then ContinueLoop
				If $Plugin_Handle_array[$x] = "-1" Then _ArrayAdd($return_Array, $SCE_EDITOR_array[$x] & $Plugin_System_Delimiter & $Datei_pfad_array[$x])
			Next
			Return $return_Array

	EndSwitch
EndFunc   ;==>_ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio




; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Get_Text
; Description ...: Gets the whole text of an Scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Get_Text($Sci_handle="")
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Text in the control.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Get_Text($Sci_handle = "")
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("Sci_GetText", $Sci_handle)
	If _ISNPlugin_System_needs_double_byte_character_support() Then $result = BinaryToString(StringToBinary($result, 1), 4) ;Convert to UTF8
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Get_Text


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Get_Line_Text
; Description ...: Gets the text from a specific line in an scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Get_Line_Text($Sci_handle = "",$line = 0)
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
;				   $line				-	Line number to get the text from
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Text in the control.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Get_Line_Text($Sci_handle = "", $line = 0)
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("Sci_GetLine", $Sci_handle, $line - 1)
	If Not _ISNPlugin_System_needs_double_byte_character_support() Then $result = BinaryToString(StringToBinary($result, 1), 4) ;Convert to UTF8
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Get_Line_Text


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Get_Current_Linenumber
; Description ...: Returns the current linenumber (where the cursor stands at) of an scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Get_Current_Linenumber($Sci_handle = "")
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Returns the current linenumber (where the cursor stands at) of an scintilla control.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Get_Current_Linenumber($Sci_handle = "")
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("Sci_GetCurrentLine", $Sci_handle)
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Get_Current_Linenumber


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Get_Selection_Text
; Description ...: Returns the text in the selection area from an scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Get_Selection_Text($Sci_handle = "")
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Returns the text.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Get_Selection_Text($Sci_handle = "")
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("SCI_GetSelectionText", $Sci_handle)
	If Not _ISNPlugin_System_needs_double_byte_character_support() Then $result = BinaryToString(StringToBinary($result, 1), 4) ;Convert to UTF8
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Get_Selection_Text

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Insert_Text
; Description ...: Inserts some text at an specific position in an scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Insert_Text($Sci_handle = "", $Text = "", $Pos = 0)
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; 				   $Text	 			- 	Text to insert
; 				   $Pos	 				- 	Position to insert the text
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Text inserted.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Insert_Text($Sci_handle = "", $Text = "", $Pos = 0)
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	If Not _ISNPlugin_System_needs_double_byte_character_support() Then $Text = BinaryToString(StringToBinary($Text, 4), 1) ;Convert to ANSI
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("Sci_InsertText", $Sci_handle, $Pos, $Text)
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Insert_Text


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Get_Linenumber_from_Pos
; Description ...: Gets the line number from an Position in an scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Get_Linenumber_from_Pos($Sci_handle = "", $Pos = 0)
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; 				   $Pos	 				- 	Position to insert the text
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Returns the line number.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Get_Linenumber_from_Pos($Sci_handle = "", $Pos = 0)
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("Sci_GetLineFromPos", $Sci_handle, $Pos)
	If $result <> "" Then $result = $result + 1 ;No zero based results
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Get_Linenumber_from_Pos


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Get_Current_Pos
; Description ...: Returns the current position of the cursor in an scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Get_Current_Pos($Sci_handle = "")
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	The current cursor position.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Get_Current_Pos($Sci_handle = "")
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("Sci_GetCurrentPos", $Sci_handle)
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Get_Current_Pos

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Set_Current_Pos
; Description ...: Sets the current position of the cursor in an scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Set_Current_Pos($Sci_handle = "",$pos = 0)
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; 				   $Pos	 				- 	Position to set the cursor to
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Position set.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Set_Current_Pos($Sci_handle = "", $Pos = 0)
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("Sci_SetCurrentPos", $Sci_handle, $Pos)
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Set_Current_Pos


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Delete_All_Lines
; Description ...: Deletes all lines in an scintilla control.
; Syntax.........: _ISNPlugin_Scintilla_Delete_All_Lines($Sci_handle = "")
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Content removed
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Delete_All_Lines($Sci_handle = "")
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("Sci_DelLines", $Sci_handle)
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Delete_All_Lines

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Scintilla_Set_Text
; Description ...: Sets the text of an scintilla control. All previous content will be removed!
; Syntax.........: _ISNPlugin_Scintilla_Set_Text($Sci_handle = "", $Text = "")
; Parameters ....: $Sci_handle 			- 	Handle to an Scintilla control. Returned from _ISNPlugin_Get_Scintilla_Handle_from_ISN_AutoIt_Studio.
; 				   $Text	 			- 	Text to set
; Return values .:  -1  	 -	$Sci_handle is empty. Sets @error to -1
;                   Success  -	Content removed
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Scintilla_Set_Text($Sci_handle = "", $Text = "")
	Local $result = ""
	If $Sci_handle = "" Then
		SetError(-1)
		Return -1
	EndIf
	If Not _ISNPlugin_System_needs_double_byte_character_support() Then $Text = BinaryToString(StringToBinary($Text, 4), 1) ;Convert to ANSI
	$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("SCI_SetText", $Sci_handle, $Text)
	Return $result
EndFunc   ;==>_ISNPlugin_Scintilla_Set_Text


; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_Show_AutoIt_Code_Window
; Description ...: Shows an window with an Scintilla Control in it to display AutoIt Code.
; Syntax.........: _ISNPlugin_Show_AutoIt_Code_Window($Flag = 1, $Gui_Title = "", $GUI_Description = "", $AutoIt_Code="")
; Parameters ....: $Flag 				- 	Flag can have the following values:
;											$Code_Window_Show_Code_Only 	- Shows the window only with an OK Button. Returns 1 if call was ok.
;											$Code_Window_Wait_For_Result	- The window has an "OK" and an "Cancel" Button. The content of the Scintilla control is returned by this function when "OK" is pressd.
;																			  If "Cancel" is pressed it returns -2 and sets @error to -2.
; 				   $Gui_Title	 		- 	Text to apear in the window title
; 				   $GUI_Description	 	- 	Text to display as information in the GUI
; 				   $AutoIt_Code	 		- 	AutoIt Code to preinsert in the Scintilla Control
; Return values .:  -1  	 -	$AutoIt_Code is empty. Sets @error to -1
;                   Success  -	Depends on $Flag. See above.
; Author ........: ISI360
; Remarks .......:
; ===============================================================================================================================
Func _ISNPlugin_Show_AutoIt_Code_Window($Flag = 1, $Gui_Title = " ", $GUI_Description = " ", $AutoIt_Code = "")
	Local $result = ""
	If $AutoIt_Code = "" Then
		SetError(-1)
		Return -1
	EndIf
	If $Gui_Title = "" Then $Gui_Title = " "
	If $GUI_Description = "" Then $GUI_Description = " "
	If Not _ISNPlugin_System_needs_double_byte_character_support() Then $AutoIt_Code = BinaryToString(StringToBinary($AutoIt_Code, 4), 1) ;Convert to ANSI
	If $Flag = 1 Then
		$result = _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_SCI_Zeige_Extracode", $AutoIt_Code, $Gui_Title, $GUI_Description, 1)
		Return $result
	Else
		_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_SCI_Zeige_Extracode", $AutoIt_Code, $Gui_Title, $GUI_Description, 0)
		$result = _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio("extracodeanswer", 9000000000)
		$datastring = _ISNPlugin_Messagestring_Get_Element($result, 2)
		If $datastring = "#error#" Then
			SetError(-2)
			Return -2
		EndIf
		Return $datastring
	EndIf
EndFunc   ;==>_ISNPlugin_Show_AutoIt_Code_Window

; #FUNCTION# ====================================================================================================================
; Name...........: _ISNPlugin_System_needs_double_byte_character_support
; Description ...: Returns ture, if the system needs double byte character support. (For example for chinese language)
; Syntax.........: _ISNPlugin_System_needs_double_byte_character_support()
; Author ........: ISI360
; Remarks .......: Internal use only.
; ===============================================================================================================================
Func _ISNPlugin_System_needs_double_byte_character_support()
	Switch _WinAPI_GetSystemDefaultLCID()

		Case 2052 ;zh-cn
			Return True

		Case 3076 ;zh-hk
			Return True

		Case 5124 ;zh-mo
			Return True

		Case 4100 ;zh-sg
			Return True

		Case 1028 ;zh-tw
			Return True

		Case 1041 ;ja
			Return True

		Case 1042 ;ko
			Return True

	EndSwitch

	Return False
EndFunc   ;==>_ISNPlugin_System_needs_double_byte_character_support

#cs
	;======================== LEGACY STUFF ========================
	The new plugin System is nearly 100% compatible with the old MailSlot System. Here are the legacy functions to avoid compatibility problems.
	Please do not use them in new plugin projects!! They are just included for old Mailslot Plugins compatibility.

	====== LEGACY FUNCTIONS ====== (Please do not use this functions anymore. They are just included for old Mailslot Plugins compatibility) ======
	_ISNPlugin_erstelle_Mailslot
	_ISNPlugin_Get_Variable
	_ISNPlugin_beende_Mailslot
	_ISNPlugin_pruefe_auf_neue_Nachrichten
	_ISNPlugin_Nachricht_lesen
	_ISNPlugin_Starte_Funktion_im_ISN
	_ISNPlugin_Execute_im_ISN
	_ISNPlugin_Nachricht_senden
	_ISNPlugin_Warte_auf_Nachricht
	_ISNPlugin_Warte_auf_ISN_und_initialisiere_Kommunikation
	_ISNPlugin_bekannte_Nachrichten_verarbeiten

#ce

;====== LEGACY VARIABLES ====== (Please do not use them anymore)
Global $Mailslot_Name_ISN_AutoIt_Studio = ""
Global $ISN_Plugin_Warte_auf_Nachricht = 0
Global $ISN_AutoIt_Studio_Projektpfad = ""
Global $ISN_AutoIt_Studio_Konfigurationsdatei_Pfad = ""
Global $ISN_AutoIt_Studio_Fensterhandle = ""

;==========================================================================================
;
; Name...........: _ISNPlugin_Execute_im_ISN
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_Execute_in_ISN_AutoIt_Studio" instead.
;
;==========================================================================================
Func _ISNPlugin_Execute_im_ISN($befehl = "")
	$result = _ISNPlugin_Execute_in_ISN_AutoIt_Studio($befehl)
	If @error Or $result = "" Then
		Return ""
		SetError(-1)
	EndIf
	Return $result
EndFunc   ;==>_ISNPlugin_Execute_im_ISN

;==========================================================================================
;
; Name...........: _ISNPlugin_erstelle_Mailslot
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;
;==========================================================================================
Func _ISNPlugin_erstelle_Mailslot()
	Return "dummy"
EndFunc   ;==>_ISNPlugin_erstelle_Mailslot

;==========================================================================================
;
; Name...........: _ISNPlugin_beende_Mailslot
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;
;==========================================================================================
Func _ISNPlugin_beende_Mailslot($hMailSlot = "")
	Return 1
EndFunc   ;==>_ISNPlugin_beende_Mailslot

;==========================================================================================
;
; Name...........: _ISNPlugin_pruefe_auf_neue_Nachrichten
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;
;==========================================================================================
Func _ISNPlugin_pruefe_auf_neue_Nachrichten($hMailSlot = "")
	Return 0
EndFunc   ;==>_ISNPlugin_pruefe_auf_neue_Nachrichten

;==========================================================================================
;
; Name...........: _ISNPlugin_Nachricht_lesen
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;
;==========================================================================================
Func _ISNPlugin_Nachricht_lesen($hMailSlot = "")
	If $hMailSlot = "" Then Return ""
	Return ""
EndFunc   ;==>_ISNPlugin_Nachricht_lesen

;==========================================================================================
;
; Name...........: _ISNPlugin_Starte_Funktion_im_ISN
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio" instead.
;
;==========================================================================================
Func _ISNPlugin_Starte_Funktion_im_ISN($funcname = "", $param1 = "", $param2 = "", $param3 = "", $param4 = "", $param5 = "", $param6 = "", $param7 = "")
	Return _ISNPlugin_Call_Function_in_ISN_AutoIt_Studio($funcname, $param1, $param2, $param3, $param4, $param5, $param6, $param7)
EndFunc   ;==>_ISNPlugin_Starte_Funktion_im_ISN

;==========================================================================================
;
; Name...........: _ISNPlugin_Nachricht_senden
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_send_message_to_ISN" instead.
;
;==========================================================================================
Func _ISNPlugin_Nachricht_senden($Text = "")
	Return _ISNPlugin_send_message_to_ISN($Text)
EndFunc   ;==>_ISNPlugin_Nachricht_senden

;==========================================================================================
;
; Name...........: _ISNPlugin_Warte_auf_Nachricht
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio" instead.
;
;==========================================================================================
Func _ISNPlugin_Warte_auf_Nachricht($hMailSlot = "", $Zu_erwartende_Nachricht = "", $Timeout = 5000)
	Return _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio($Zu_erwartende_Nachricht, $Timeout)
EndFunc   ;==>_ISNPlugin_Warte_auf_Nachricht

;==========================================================================================
;
; Name...........: _ISNPlugin_Warte_auf_ISN_und_initialisiere_Kommunikation
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_initialize" instead.
;
;==========================================================================================
Func _ISNPlugin_Warte_auf_ISN_und_initialisiere_Kommunikation($hMailSlot = "", $hgui = "")
	$result = _ISNPlugin_initialize($hgui)
	If $result <> 1 Then $result = 0
	Return $result
EndFunc   ;==>_ISNPlugin_Warte_auf_ISN_und_initialisiere_Kommunikation

;==========================================================================================
;
; Name...........: _Pluginstring_get_element
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_Messagestring_Get_Element" instead.
;
;==========================================================================================
Func _Pluginstring_get_element($string = "", $Element = 0)
	Return _ISNPlugin_Messagestring_Get_Element($string, $Element)
EndFunc   ;==>_Pluginstring_get_element



;==========================================================================================
;
; Name...........: _ISNPlugin_Get_Variable
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_Assign_Variable_From_ISN_AutoIt_Studio" instead.
;
;==========================================================================================
Func _ISNPlugin_Get_Variable($Zielvariable = "", $Varname = "", $hMailSlot = "")
	$result = _ISNPlugin_Assign_Variable_from_ISN_AutoIt_Studio($Zielvariable, $Varname)
	If @error Then
		Return -1
		SetError(-1)
	EndIf
	Return $result
EndFunc   ;==>_ISNPlugin_Get_Variable

;==========================================================================================
;
; Name...........: _ISNPlugin_Set_Variable
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio" instead.
;
;==========================================================================================
Func _ISNPlugin_Set_Variable($Varname = "", $Wert = "")
	$result = _ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio($Varname, $Wert)
	If @error Or $result = 0 Then
		Return -1
		SetError(-1)
	EndIf
	Return $result
EndFunc   ;==>_ISNPlugin_Set_Variable

;==========================================================================================
;
; Name...........: _ISNPlugin_Set_Array
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;				   Use "_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio" instead.
;
;==========================================================================================
Func _ISNPlugin_Set_Array($Varname = "", $QuellArray = "")
	$result = _ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio($Varname, $QuellArray)
	If @error Or $result = 0 Then
		Return -1
		SetError(-1)
	EndIf
	Return $result
EndFunc   ;==>_ISNPlugin_Set_Array

;==========================================================================================
;
; Name...........: _ISNPlugin_bekannte_Nachrichten_verarbeiten
; Description ...: Please do not use this function anymore! It´s just included for old Mailslot Plugins compatibility.
;
;==========================================================================================
Func _ISNPlugin_bekannte_Nachrichten_verarbeiten($Nachricht = "")
	Return False
EndFunc   ;==>_ISNPlugin_bekannte_Nachrichten_verarbeiten

