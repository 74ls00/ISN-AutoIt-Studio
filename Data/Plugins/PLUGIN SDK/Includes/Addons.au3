#Region Lng_Checker

Func _lng_checker_select_file()
	$result = FileOpenDialog( _ISNPlugin_Get_Langstring(45), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Language file (*.lng)", 3, "", $Plugin_SDK_GUI)
	If @error Or $result = "" Then Return
	GUICtrlSetData($lng_checker_file_input, $result)
EndFunc   ;==>_lng_checker_select_file


Func _lng_checker_reorder_language_file()
	GUICtrlSetData($lng_checker_log, "")
	Local $file = GUICtrlRead($lng_checker_file_input)
	If $file = "" Then Return
	$cache = ""
	$count_to = 20000
	Local $section = "plugin"
	If GUICtrlRead($lng_checker_type_ISN_Radio) = $GUI_CHECKED Then $section = "ISNAUTOITSTUDIO"
	_GUICtrlEdit_AppendText($lng_checker_log, "Reorder strings..." & @CRLF)
	For $v = 1 To $count_to
		$gelesener_wert = IniRead($file, $section, "str" & $v, "")
		If $gelesener_wert <> "" Then $cache = $cache & "str" & $v & "=" & $gelesener_wert & @CRLF
	Next
	_GUICtrlEdit_AppendText($lng_checker_log, "The reordered strings are now in your clipboard!" & @CRLF)
	ClipPut($cache)
EndFunc   ;==>_lng_checker_reorder_language_file

Func _lng_checker_Verify_Language_file()
	GUICtrlSetData($lng_checker_log, "")
	Local $file = GUICtrlRead($lng_checker_file_input)
	Local $section = "plugin"
	If GUICtrlRead($lng_checker_type_ISN_Radio) = $GUI_CHECKED Then $section = "ISNAUTOITSTUDIO"
	If $file = "" Then Return
	_GUICtrlEdit_AppendText($lng_checker_log, "Start Verifing file..." & @CRLF)
	If Not FileExists($file) Then
		_GUICtrlEdit_AppendText($lng_checker_log, "Can not open file!" & @CRLF)
		Return
	EndIf

	If IniRead($file, $section, "language", "") <> "" Then
		_GUICtrlEdit_AppendText($lng_checker_log, "language key ok!" & @CRLF)
	Else
		_GUICtrlEdit_AppendText($lng_checker_log, "language key error! (Or the file is UTF8 formated. Can not check UTF8 files!)" & @CRLF)
		Return
	EndIf


	$File_Array = FileReadToArray($file)
	$count = 1
	For $x = 0 To UBound($File_Array) - 1
		_GUICtrlEdit_AppendText($lng_checker_log, "Checking line " & $x & "...")
		$line = $File_Array[$x]
		If StringInStr($line, "str", 1) Then
			$res_array = _StringBetween($line, "str", "=", 0, True)
			If @error Then
				_GUICtrlEdit_AppendText($lng_checker_log, "ERROR!" & @CRLF)
				Return
			EndIf

			If $res_array[0] <> $count Then
				_GUICtrlEdit_AppendText($lng_checker_log, "Count error at string " & $res_array[0] & "! Check also the previous line!" & @CRLF)
				Return
			EndIf
			$count = $count + 1


		EndIf
		_GUICtrlEdit_AppendText($lng_checker_log, "OK" & @CRLF)
	Next

	_GUICtrlEdit_AppendText($lng_checker_log, "Finished!" & @CRLF)
EndFunc   ;==>_lng_checker_Verify_Language_file



#EndRegion Lng_Checker


#Region Create_new_Plugin

Func _Create_new_plugin()
	$plugin_Name = InputBox(_ISNPlugin_Get_Langstring(39), _ISNPlugin_Get_Langstring(41), "My new Plugin", "", -1, -1, Default, Default, 0, $Plugin_SDK_GUI)
	If @error Or $plugin_Name = "" Then Return
	Local $Errors = 0

	$default_name = StringLower($plugin_Name)
	$default_name = StringStripWS($default_name, 3)
	$default_name = StringReplace($default_name, " ", "_")
	$plugin_Folder_Name = InputBox(_ISNPlugin_Get_Langstring(39), _ISNPlugin_Get_Langstring(43), $default_name, "", -1, -1, Default, Default, 0, $Plugin_SDK_GUI)
	If @error Or $plugin_Folder_Name = "" Then Return

	$ISN_Pluginsdir = _ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable("%pluginsdir%")
	If $ISN_Pluginsdir = "" Or Not FileExists($ISN_Pluginsdir) Then Return

	;Check if already exists
	If FileExists($ISN_Pluginsdir & "\" & $plugin_Folder_Name) Then
		MsgBox(16 + 262144, _ISNPlugin_Get_Langstring(39), _ISNPlugin_Get_Langstring(44), 0)
		Return
	EndIf

	;Create directory
	DirCreate($ISN_Pluginsdir & "\" & $plugin_Folder_Name)
	If @error Then $Errors = $Errors + 1

	;Copy Sdk au3
	FileCopy(@ScriptDir & "\isnautoitstudio_plugin.au3", $ISN_Pluginsdir & "\" & $plugin_Folder_Name, 9)
	If @error Then $Errors = $Errors + 1

	;Create mainfile
	FileCopy(@ScriptDir & "\Includes\new_plugin_template.au3", $ISN_Pluginsdir & "\" & $plugin_Folder_Name & "\" & $plugin_Folder_Name & ".au3", 9)
	If @error Then $Errors = $Errors + 1

	;Create plugin.ini
	IniWrite($ISN_Pluginsdir & "\" & $plugin_Folder_Name & "\plugin.ini", "plugin", "name", $plugin_Name)
	If @error Then $Errors = $Errors + 1
	IniWrite($ISN_Pluginsdir & "\" & $plugin_Folder_Name & "\plugin.ini", "plugin", "toolsmenudescription", $plugin_Name)
	If @error Then $Errors = $Errors + 1


	If $Errors <> 0 Then
		MsgBox(16 + 262144, _ISNPlugin_Get_Langstring(39), _ISNPlugin_Get_Langstring(15), 0)
	Else
		_Plugin_INI_Editor_Load_file($ISN_Pluginsdir & "\" & $plugin_Folder_Name & "\plugin.ini")
		MsgBox(64 + 262144, _ISNPlugin_Get_Langstring(39), _ISNPlugin_Get_Langstring(42), 0)
	EndIf



EndFunc   ;==>_Create_new_plugin

#EndRegion Create_new_Plugin

#Region General
Func _Export_SDK_AU3()
	;Where to save the isnautoitstudio_plugin.au3
	$result = FileSaveDialog(_ISNPlugin_Get_Langstring(20), "", "AutoIt 3 Script (*.au3)", 2 + 16, "isnautoitstudio_plugin.au3", $Plugin_SDK_GUI)
	If @error Then Return
	FileChangeDir(@ScriptDir)

	If Not FileCopy(@ScriptDir & "\isnautoitstudio_plugin.au3", $result, 9) Then
		MsgBox(16 + 262144, _ISNPlugin_Get_Langstring(8), _ISNPlugin_Get_Langstring(15), 0)
	Else
		MsgBox(64 + 262144, _ISNPlugin_Get_Langstring(10), _ISNPlugin_Get_Langstring(16), 0)
	EndIf

EndFunc   ;==>_Export_SDK_AU3



#EndRegion General

#Region Plugin.ini Editor

Func _Plugin_INI_Editor_Select_file()
	$ISN_Pluginsdir = _ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable("%pluginsdir%")
	If $ISN_Pluginsdir = "" Or Not FileExists($ISN_Pluginsdir) Then Return
	$result = FileOpenDialog( _ISNPlugin_Get_Langstring(22), $ISN_Pluginsdir, "Plugins file (plugin.ini)", 3, "plugin.ini", $Plugin_SDK_GUI)
	If @error Or $result = "" Then Return
	_Plugin_INI_Editor_Load_file($result)
EndFunc   ;==>_Plugin_INI_Editor_Select_file

Func _Plugin_INI_Editor_Load_file($file = "")
	GUICtrlSetData($plugin_ini_editor_current_file_label, $file)
	GUICtrlSetState($plugin_ini_editor_save_button, $GUI_ENABLE)

	GUICtrlSetData($plugin_ini_editor_name_input, IniRead($file, "plugin", "name", ""))
	GUICtrlSetData($plugin_ini_editor_version_input, IniRead($file, "plugin", "version", ""))
	GUICtrlSetData($plugin_ini_editor_autor_input, IniRead($file, "plugin", "author", ""))
	GUICtrlSetData($plugin_ini_editor_comment_input, IniRead($file, "plugin", "comment", ""))
	GUICtrlSetData($plugin_ini_editor_filetypes_input, IniRead($file, "plugin", "filetypes", ""))
	GUICtrlSetData($plugin_ini_editor_placeholders_input, IniRead($file, "plugin", "isnplaceholders", ""))
	GUICtrlSetData($plugin_ini_editor_waitexit_input, IniRead($file, "plugin", "waitforplugintoexit", "0"))
	GUICtrlSetData($plugin_ini_editor_toolsdesc_input, IniRead($file, "plugin", "toolsmenudescription", ""))
	GUICtrlSetData($plugin_ini_editor_icon_input, IniRead($file, "plugin", "toolsmenuiconid", ""))
	GUICtrlSetData($plugin_ini_editor_tabdesc_input, IniRead($file, "plugin", "tabdescription", ""))
	GUICtrlSetData($plugin_ini_editor_esclusiv_input, IniRead($file, "plugin", "exclusiv", "0"))
	GUICtrlSetData($plugin_ini_editor_notab_input, IniRead($file, "plugin", "notab_mode", "0"))
EndFunc   ;==>_Plugin_INI_Editor_Load_file

Func _Plugin_INI_Editor_save_changes()
	$Ini_file = GUICtrlRead($plugin_ini_editor_current_file_label)
	Local $Errors = 0
	If Not FileExists($Ini_file) Then Return

	If GUICtrlRead($plugin_ini_editor_name_input) = "" Then
		IniDelete($Ini_file, "plugin", "name")
	Else
		IniWrite($Ini_file, "plugin", "name", GUICtrlRead($plugin_ini_editor_name_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_version_input) = "" Then
		IniDelete($Ini_file, "plugin", "version")
	Else
		IniWrite($Ini_file, "plugin", "version", GUICtrlRead($plugin_ini_editor_version_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_autor_input) = "" Then
		IniDelete($Ini_file, "plugin", "author")
	Else
		IniWrite($Ini_file, "plugin", "author", GUICtrlRead($plugin_ini_editor_autor_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_comment_input) = "" Then
		IniDelete($Ini_file, "plugin", "comment")
	Else
		IniWrite($Ini_file, "plugin", "comment", GUICtrlRead($plugin_ini_editor_comment_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_filetypes_input) = "" Then
		IniDelete($Ini_file, "plugin", "filetypes")
	Else
		IniWrite($Ini_file, "plugin", "filetypes", GUICtrlRead($plugin_ini_editor_filetypes_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_placeholders_input) = "" Then
		IniDelete($Ini_file, "plugin", "isnplaceholders")
	Else
		IniWrite($Ini_file, "plugin", "isnplaceholders", GUICtrlRead($plugin_ini_editor_placeholders_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_waitexit_input) = "" Then
		IniDelete($Ini_file, "plugin", "waitforplugintoexit")
	Else
		IniWrite($Ini_file, "plugin", "waitforplugintoexit", GUICtrlRead($plugin_ini_editor_waitexit_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_toolsdesc_input) = "" Then
		IniDelete($Ini_file, "plugin", "toolsmenudescription")
	Else
		IniWrite($Ini_file, "plugin", "toolsmenudescription", GUICtrlRead($plugin_ini_editor_toolsdesc_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_icon_input) = "" Then
		IniDelete($Ini_file, "plugin", "toolsmenuiconid")
	Else
		IniWrite($Ini_file, "plugin", "toolsmenuiconid", GUICtrlRead($plugin_ini_editor_icon_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_tabdesc_input) = "" Then
		IniDelete($Ini_file, "plugin", "tabdescription")
	Else
		IniWrite($Ini_file, "plugin", "tabdescription", GUICtrlRead($plugin_ini_editor_tabdesc_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_esclusiv_input) = "" Then
		IniDelete($Ini_file, "plugin", "exclusiv")
	Else
		IniWrite($Ini_file, "plugin", "exclusiv", GUICtrlRead($plugin_ini_editor_esclusiv_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If GUICtrlRead($plugin_ini_editor_notab_input) = "" Then
		IniDelete($Ini_file, "plugin", "notab_mode")
	Else
		IniWrite($Ini_file, "plugin", "notab_mode", GUICtrlRead($plugin_ini_editor_notab_input))
	EndIf
	If @error Then $Errors = $Errors + 1

	If $Errors <> 0 Then
		MsgBox(16 + 262144, _ISNPlugin_Get_Langstring(8), _ISNPlugin_Get_Langstring(15), 0)
	Else
		MsgBox(64 + 262144, _ISNPlugin_Get_Langstring(10), _ISNPlugin_Get_Langstring(16), 0)
	EndIf

EndFunc   ;==>_Plugin_INI_Editor_save_changes


#EndRegion Plugin.ini Editor

#Region Plugin to ICP

Func _PluginSDK_select_plugin_to_compress()
	$ISN_Pluginsdir = _ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable("%pluginsdir%")
	If $ISN_Pluginsdir = "" Or Not FileExists($ISN_Pluginsdir) Then Return
	$result = _WinAPI_BrowseForFolderDlg($ISN_Pluginsdir, _ISNPlugin_Get_Langstring(6), $BIF_RETURNONLYFSDIRS, 0, 0, $Plugin_SDK_GUI)
	If $result <> "" Then

		;Checks if a plugin.Ini is there
		If Not FileExists($result & "\plugin.ini") Then
			MsgBox(16 + 262144, _ISNPlugin_Get_Langstring(8), _ISNPlugin_Get_Langstring(11), 0)
			Return
		EndIf


		;Where to save the new icp file?
		$ICP_File_Path = FileSaveDialog(_ISNPlugin_Get_Langstring(6), "", _ISNPlugin_Get_Langstring(12) & " (*.icp)", 2 + 16, StringTrimLeft($result, StringInStr($result, "\", 0, -1)), $Plugin_SDK_GUI)
		If @error Then Return
		FileChangeDir(@ScriptDir)

		;Some zip Stuff
		$CurZipSize = 0
		$UnCompSize = DirGetSize($result)
		Global $RootDir = DllStructCreate("char[256]")
		DllStructSetData($RootDir, 1, $ISN_Pluginsdir)

		Global $TempDir = DllStructCreate("char[256]")
		DllStructSetData($TempDir, 1, @TempDir)

		Global $ZPOPT = DllStructCreate("ptr Date;ptr szRootDir;ptr szTempDir;int fTemp;int fSuffix;int fEncrypt;int fSystem;" & _
				"int fVolume;int fExtra;int fNoDirEntries;int fExcludeDate;int fIncludeDate;int fVerbose;" & _
				"int fQuiet;int fCRLFLF;int fLFCRLF;int fJunkDir;int fGrow;int fForce;int fMove;" & _
				"int fDeleteEntries;int fUpdate;int fFreshen;int fJunkSFX;int fLatestTime;int fComment;" & _
				"int fOffsets;int fPrivilege;int fEncryption;int fRecurse;int fRepair;char fLevel[2]")

		DllStructSetData($ZPOPT, "szRootDir", DllStructGetPtr($RootDir))
		DllStructSetData($ZPOPT, "szTempDir", DllStructGetPtr($TempDir))
		DllStructSetData($ZPOPT, "fTemp", 0)
		DllStructSetData($ZPOPT, "fVolume", 0)
		DllStructSetData($ZPOPT, "fExtra", 0)
		DllStructSetData($ZPOPT, "fVerbose", 1)
		DllStructSetData($ZPOPT, "fQuiet", 0)
		DllStructSetData($ZPOPT, "fCRLFLF", 0)
		DllStructSetData($ZPOPT, "fLFCRLF", 0)
		DllStructSetData($ZPOPT, "fGrow", 0)
		DllStructSetData($ZPOPT, "fForce", 0)
		DllStructSetData($ZPOPT, "fDeleteEntries", 0)
		DllStructSetData($ZPOPT, "fJunkSFX", 0)
		DllStructSetData($ZPOPT, "fOffsets", 0)
		DllStructSetData($ZPOPT, "fRepair", 0)

		_Zip_Init("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
		if @error then
			MsgBox(16 + 262144, _ISNPlugin_Get_Langstring(8), _ISNPlugin_Get_Langstring(15)&@crlf&@crlf&"Error Code 1", 0)
			Return
		endif
		$use_password = MsgBox(262144 + 4 + 32, _ISNPlugin_Get_Langstring(13), _ISNPlugin_Get_Langstring(14), 0)
		If $use_password = 6 Then
			_ZIP_SetOptions(0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 9)
		Else
			_ZIP_SetOptions(0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 9)
		EndIf
		if @error then
			MsgBox(16 + 262144, _ISNPlugin_Get_Langstring(8), _ISNPlugin_Get_Langstring(15)&@crlf&@crlf&"Error Code 2", 0)
			Return
		endif

		;Create the icp file
		ProgressOn(_ISNPlugin_Get_Langstring(6), _ISNPlugin_Get_Langstring(18), "", Default, Default, 16 + 2)
		ProgressSet(0)
		Sleep(500)
		_ZIP_Archive($ICP_File_Path, $result)
		If not @error Then
			ProgressOff()
			MsgBox(64 + 262144, _ISNPlugin_Get_Langstring(10), _ISNPlugin_Get_Langstring(16), 0)
		Else
			ProgressOff()
			MsgBox(16 + 262144, _ISNPlugin_Get_Langstring(8), _ISNPlugin_Get_Langstring(15)&@crlf&@crlf&"Error Code 3", 0)
		EndIf


	EndIf
EndFunc   ;==>_PluginSDK_select_plugin_to_compress




#EndRegion Plugin to ICP
