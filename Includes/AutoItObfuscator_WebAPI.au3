
Func _Obfuscator_GUI_Lizenzeinstellungen_oeffnen()
	GUISetState(@SW_HIDE, $pelock_obfuscator_GUI)
	GUICtrlSetState($config_Sheet_Tools, $GUI_SHOW)
	_Show_Configgui()
EndFunc   ;==>_Obfuscator_GUI_Lizenzeinstellungen_oeffnen


Func _Datei_aus_Projektbaum_in_Obfuscator_GUI_Laden()
	$Markierte_Datei_im_Projektbaum = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	If $Markierte_Datei_im_Projektbaum = "" Then Return
	_Dateiinhalt_in_Obfuscator_GUI_Laden($Markierte_Datei_im_Projektbaum)
EndFunc   ;==>_Datei_aus_Projektbaum_in_Obfuscator_GUI_Laden

Func _Obfuscator_GUI_Skript_eingabe_Datei_Laden()
	$Datei = FileOpenDialog(_Get_langstr(1214), $Offenes_Projekt, "AutoIt 3 Script File (*.au3)", 3, "", $pelock_obfuscator_GUI)
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $Datei = "" Then Return
	_Dateiinhalt_in_Obfuscator_GUI_Laden($Datei)
EndFunc   ;==>_Obfuscator_GUI_Skript_eingabe_Datei_Laden

Func _Dateiinhalt_in_Obfuscator_GUI_Laden($Dateipfad = "")
	If $Dateipfad = "" Then Return

	GUISetState(@SW_HIDE, $pelock_obfuscator_GUI)
	$msg_result = MsgBox(262180, _Get_langstr(48), _Get_langstr(1261), 0, $Studiofenster)
	If @error Then Return
	If $msg_result = 6 Then

		Dim $szDrive, $szDir, $szFName, $szExt
		GUICtrlSetData($warte_auf_wrapper_GUI_text, _Get_langstr(1260))
		GUISetState(@SW_SHOW, $warte_auf_wrapper_GUI)
		GUISetState(@SW_DISABLE, $Studiofenster)
		_Clear_Debuglog()
		$Data = _RunReadStd('"' & FileGetShortName($Au3Stripperexe) & '" "' & $Dateipfad & '" "/StripOnly', 0, $Offenes_Projekt, @SW_HIDE, 1)
		GUISetState(@SW_ENABLE, $Studiofenster)
		GUISetState(@SW_HIDE, $warte_auf_wrapper_GUI)
		$TestPath = _PathSplit($Dateipfad, $szDrive, $szDir, $szFName, $szExt)
		If FileExists($szDrive & $szDir & $szFName & "_stripped" & $szExt) Then
			GUICtrlSetState($pelock_obfuscator_GUI_Tab_item1, $GUI_SHOW)
			_PELock_GUI_Tab_Event()
			_Pelock_Obfuscator_GUI_Lade_Einstellungen()
			GUISetState(@SW_SHOW, $pelock_obfuscator_GUI)
			_Obfuscator_GUI_refresh_statusbar()
			LoadEditorFile($pelock_obfuscator_GUI_Eingabe_scintilla, $szDrive & $szDir & $szFName & "_stripped" & $szExt)
		EndIf
		Return
	EndIf
	GUICtrlSetState($pelock_obfuscator_GUI_Tab_item1, $GUI_SHOW)
	_PELock_GUI_Tab_Event()
	_Pelock_Obfuscator_GUI_Lade_Einstellungen()
	GUISetState(@SW_SHOW, $pelock_obfuscator_GUI)

	_Obfuscator_GUI_refresh_statusbar()
	LoadEditorFile($pelock_obfuscator_GUI_Eingabe_scintilla, $Dateipfad)
EndFunc   ;==>_Dateiinhalt_in_Obfuscator_GUI_Laden



Func _Obfuscator_GUI_Skript_ausgabe_Datei_Speichern()
	If Sci_GetText($pelock_obfuscator_GUI_Ausgabe_scintilla) = "" Then Return
	$Pfad = FileSaveDialog(_Get_langstr(1226), $Offenes_Projekt, "AutoIt 3 Script File (*.au3)", 18, "obfuscator_export.au3", $pelock_obfuscator_GUI)
	FileChangeDir(@ScriptDir)
	If $Pfad = "" Then Return
	If @error > 0 Then Return
	$Handle = FileOpen($Pfad, 2 + $FO_UTF8_NOBOM)
	$Data = Sci_GetLines($pelock_obfuscator_GUI_Ausgabe_scintilla)
	If Not FileWrite($Handle, _ANSI2UNICODE($Data)) Then
		FileClose($Handle)
		MsgBox(16 + 262144, _Get_langstr(25), _Get_langstr(151), 0, $pelock_obfuscator_GUI)
		Return
	EndIf
	FileClose($Handle)
	_Update_Treeview()
EndFunc   ;==>_Obfuscator_GUI_Skript_ausgabe_Datei_Speichern

Func _Obfuscator_GUI_Skript_eingabe_leeren()
	Sci_DelLines($pelock_obfuscator_GUI_Eingabe_scintilla)
EndFunc   ;==>_Obfuscator_GUI_Skript_eingabe_leeren


Func _Obfuscator_GUI_Skript_ausgabe_leeren()
	Sci_DelLines($pelock_obfuscator_GUI_Ausgabe_scintilla)
EndFunc   ;==>_Obfuscator_GUI_Skript_ausgabe_leeren

Func _Obfuscator_GUI_Skript_eingabe_aus_Zwischenablage_einfuegen()
	_Obfuscator_GUI_Skript_eingabe_leeren()
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	Sci_AddLines($pelock_obfuscator_GUI_Eingabe_scintilla, _UNICODE2ANSI(ClipGet()), 0)
   SendMessage($pelock_obfuscator_GUI_Eingabe_scintilla, $SCI_COLOURISE, 0, -1) ;Redraw the lexer
	_ISN_AutoIt_Studio_activate_GUI_Messages()
EndFunc   ;==>_Obfuscator_GUI_Skript_eingabe_aus_Zwischenablage_einfuegen

Func _Obfuscator_GUI_Skript_ausgabe_in_Zwischenablage_speichern()
	If Sci_GetText($pelock_obfuscator_GUI_Ausgabe_scintilla) = "" Then Return
	ClipPut(_ANSI2UNICODE(Sci_GetLines($pelock_obfuscator_GUI_Ausgabe_scintilla)))
EndFunc   ;==>_Obfuscator_GUI_Skript_ausgabe_in_Zwischenablage_speichern

Func _Obfuscator_GUI_label_tooltips_zuweisen()
	GUICtrlSetTip($Obfuscator_GUI_settings_random_integer_values_checkbox, "Global $xyz = 1", _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_array_with_random_values_checkbox, StringReplace("Global $xyz[3] = [369, 214, 592]", "\r\n", @CRLF), _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_functions_that_return_values_checkbox, StringReplace("Func xyz()\r\n    Return 1238948\r\nEndFunc", "\r\n", @CRLF), _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_random_value_characters_checkbox, 'Global $xyz = Asc("[")', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_multidimensional_array_checkbox, 'Global $xyz[2][4] = [ [5234, 14, 592, 3], [349882, 2] ]', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_autostarted_random_checkbox, StringReplace('#OnAutoItStartRegister "dhfe_nMCTQQ_qeMdNOv_hTu"\r\n...\r\nFunc dhfe_nMCTQQ_qeMdNOv_hTu()\r\n    Global Const $xyz = 88643041\r\nEndFunc', "\r\n", @CRLF), _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_code_flow_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'ConsoleWrite("1. One" & @CRLF)' & @LF & 'ConsoleWrite("2. Two" & @CRLF)' & @LF & 'ConsoleWrite("3. Three" & @CRLF)' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & '$rnd = 239892' & @LF & 'While True' & @LF & '    If 40402 = $rnd Then' & @LF & '        $rnd = 1993' & @LF & '        ConsoleWrite("2. Two" & @CRLF)' & @LF & '    ElseIf $rnd = 239892 Then' & @LF & '        $rnd = 40402' & @LF & '        ConsoleWrite("1. One" & @CRLF)' & @LF & '    ElseIf $rnd = 1993 Then' & @LF & '        ConsoleWrite("3. Three" & @CRLF)' & @LF & '        $rnd = 203030211' & @LF & '    ElseIf $rnd = 203030211 Then' & @LF & '        ExitLoop' & @LF & '    EndIf' & @LF & 'WEnd', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_rename_variables_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'Local $variable = 1' & @LF & 'Global $var = 12345' & @LF & 'Dim $iValue = 0xABBA' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'Local $nGuiyagSznwgwh = 1' & @LF & 'Global $SMGPZHGE_GRUHVBRVUR_TRMWCXZV = 12345' & @LF & 'Dim $var_12 = 0xABBA', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_rename_funcnames_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'Func Example($param1, $param2)' & @LF & 'Func ProcessSomething()' & @LF & 'Func Dummy($aArray)' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'Func VadOeCmEiez($param1, $param2)' & @LF & 'Func func_91()' & @LF & 'Func AvnsnFunc($aArray)', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_rename_funcnames_in_calls_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'Local $result = Example($param1, $param2)' & @LF & 'ProcessSomething()' & @LF & '$out = Dummy($aArray)' & @LF & 'ConsoleWrite("Obfuscation for AutoIt")' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'Local $result = $VsoLkc($param1, $param2)' & @LF & '$DOX_MDK_WAVP()' & @LF & '$out = $aRacmLko($aArray)' & @LF & '$aAxieOjxz("Obfuscation for AutoIt")', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_shuffle_functions_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'ConsoleWrite(c())' & @LF & '' & @LF & 'Func a()' & @LF & '    return "Hello!"' & @LF & 'EndFunc' & @LF & '' & @LF & 'Func b()' & @LF & '    return a()' & @LF & 'EndFunc' & @LF & '' & @LF & 'Func c()' & @LF & '    return b()' & @LF & 'EndFunc' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'ConsoleWrite(c())' & @LF & '' & @LF & 'Func c()' & @LF & '    return b()' & @LF & 'EndFunc' & @LF & '' & @LF & 'Func a()' & @LF & '    return "Hello!"' & @LF & 'EndFunc' & @LF & '' & @LF & 'Func b()' & @LF & '    return a()' & @LF & 'EndFunc', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_resolve_winapi_constants_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'MsgBox($MB_ICONINFORMATION, "Title", "Caption")' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'MsgBox(64, "Title", "Caption")', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_encrypt_numeric_values_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'Local $a = 1' & @LF & 'Local $value = 1234' & @LF & 'Local $lucky_seven = 777' & @LF & 'Local $var = 0xFFFF' & @LF & 'Local $count = 999' & @LF & 'Local $item = 0x100' & @LF & 'Local $diabolo = 666' & @LF & 'Local $num = 9' & @LF & 'Local $alignment = 512' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'Local $a = 3928 + $EiejcJks[3]' & @LF & 'Local $value = (347445640 - 347444406)' & @LF & 'Local $lucky_seven = Int(Sqrt(603729))' & @LF & 'Local $var = BitXOR(312515813, IbmmftJgowlxa())' & @LF & 'Local $count = BitOR(8966, 1033)' & @LF & 'Local $item = BitNOT(-257)' & @LF & 'Local $diabolo = BitRotate(10911744, 18, "D")' & @LF & 'Local $num = 3 * 3' & @LF & 'Local $alignment = 2 ^ 9', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_split_strings_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'ConsoleWrite("Hello World!")' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'ConsoleWrite("H" & "ell" & "o " & "W" & "orld" & "!")', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_modify_strings_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'ConsoleWrite("Hello World!")' & @LF & 'ConsoleWrite("Hello Bart")' & @LF & 'ConsoleWrite("AutoIt Decompilation")' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'ConsoleWrite(StringReverse("!dlroW olleH"))' & @LF & 'ConsoleWrite(StringTrimLeft("KKuqTHello Bart", 5))' & @LF & 'ConsoleWrite(StringTrimRight("AutoIt DecompilationX", 1))', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_encrypt_strings_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'ConsoleWrite("How to protect AutoIt script?")' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'ConsoleWrite(DlnWck(87, $KQWGAWTNE, $vOedex))' & @LF & '...' & @LF & 'Func DlnWck($var_1238, $g_tagNye, $g_v_nCrR)' & @LF & '    Local $6H_TKW[29] = [ 0x728F, 0x6DAF, 0x6CAF, 0x778F, 0x6D0F, _' & @LF & '                          0x6DAF, 0x778F, 0x6D8F, 0x6D4F, 0x6DAF, _' & @LF & '                          0x6D0F, 0x6EEF, 0x6F2F, 0x6D0F, 0x778F, _' & @LF & '                          0x736F, 0x6CEF, 0x6D0F, 0x6DAF, 0x726F, _' & @LF & '                          0x6D0F, 0x778F, 0x6D2F, 0x6F2F, 0x6D4F, _' & @LF & '                          0x6E6F, 0x6D8F, 0x6D0F, 0x73AF ]' & @LF & '    For $NYwQb = 0 To 28' & @LF & '        $Cwium = $6H_TKW[$NYwQb]' & @LF & '        $Cwium -= 0x7B90' & @LF & '        $Cwium = BitRotate($Cwium, 11, "W")' & @LF & '        $Cwium = BitNOT($Cwium)' & @LF & '        $6H_TKW[$NYwQb] = ChrW(BitAND($Cwium, 0xFFFF))' & @LF & '    Next' & @LF & '    Return _ArrayToString($6H_TKW, "")' & @LF & 'EndFunc', _Get_langstr(1256) & ":", 1)
	GUICtrlSetTip($Obfuscator_GUI_settings_insert_ternary_checkbox, _Get_langstr(1215) & ":" & @CRLF & @CRLF & 'Local $a = 1' & @LF & 'Local $var = 123' & @CRLF & @CRLF & _Get_langstr(1216) & ":" & @CRLF & @CRLF & 'Local $a = ($fBnbFcgx[5] >= $xCsccjis[12] ? 1 : $g_GIqyy)' & @LF & 'Local $var = (SqXoFunc() <> $Abv ? $var_2029[3] : 123)', _Get_langstr(1256) & ":", 1)

	#cs
		;Template
		GUICtrlSetTip($Obfuscator_GUI_settings_code_flow_checkbox,_Get_langstr(1215)&":"&@crlf&@crlf&' XX  '&@crlf&@crlf&_Get_langstr(1216)&":"&@crlf&@crlf&' XX ',_Get_langstr(1256)&":",1)
	#ce
EndFunc   ;==>_Obfuscator_GUI_label_tooltips_zuweisen

Func _Obfuscator_GUI_alle_einstellungen_aktivieren()
	GUICtrlSetState($Obfuscator_GUI_settings_random_integer_values_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_array_with_random_values_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_functions_that_return_values_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_random_value_characters_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_multidimensional_array_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_autostarted_random_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_code_flow_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_rename_variables_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_rename_funcnames_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_rename_funcnames_in_calls_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_shuffle_functions_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_resolve_winapi_constants_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_encrypt_numeric_values_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_split_strings_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_modify_strings_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_encrypt_strings_checkbox, $GUI_CHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_insert_ternary_checkbox, $GUI_CHECKED)
	_Pelock_Obfuscator_GUI_Checkbox_Event()
EndFunc   ;==>_Obfuscator_GUI_alle_einstellungen_aktivieren

Func _Obfuscator_GUI_alle_einstellungen_deaktivieren()
	GUICtrlSetState($Obfuscator_GUI_settings_random_integer_values_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_array_with_random_values_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_functions_that_return_values_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_random_value_characters_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_multidimensional_array_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_autostarted_random_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_code_flow_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_rename_variables_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_rename_funcnames_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_rename_funcnames_in_calls_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_shuffle_functions_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_resolve_winapi_constants_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_encrypt_numeric_values_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_split_strings_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_modify_strings_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_encrypt_strings_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($Obfuscator_GUI_settings_insert_ternary_checkbox, $GUI_UNCHECKED)
	_Pelock_Obfuscator_GUI_Checkbox_Event()
EndFunc   ;==>_Obfuscator_GUI_alle_einstellungen_deaktivieren


Func _PELock_GUI_Resize()
	$pelock_obfuscator_GUI_clientsize = WinGetClientSize($pelock_obfuscator_GUI)
	If IsArray($pelock_obfuscator_GUI_clientsize) Then
		WinMove($pelock_obfuscator_GUI_Eingabe_scintilla, "", 12 * $DPI, 150 * $DPI, $pelock_obfuscator_GUI_clientsize[0] - ((12 + 12) * $DPI), $pelock_obfuscator_GUI_clientsize[1] - ((64 + 150) * $DPI))
		WinMove($pelock_obfuscator_GUI_Ausgabe_scintilla, "", 12 * $DPI, 150 * $DPI, $pelock_obfuscator_GUI_clientsize[0] - ((12 + 12) * $DPI), $pelock_obfuscator_GUI_clientsize[1] - ((64 + 150) * $DPI))
	EndIf
EndFunc   ;==>_PELock_GUI_Resize

Func _Toggle_PELock_GUI()
    if $Offenes_Projekt = "" then return
	$state = WinGetState($pelock_obfuscator_GUI, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_HIDE, $pelock_obfuscator_GUI)
	Else
		_PELock_GUI_Tab_Event()
		GUISetState(@SW_SHOW, $pelock_obfuscator_GUI)
		_Pelock_Obfuscator_GUI_Lade_Einstellungen()
		_Obfuscator_GUI_refresh_statusbar()
	EndIf
EndFunc   ;==>_Toggle_PELock_GUI

Func _PELock_GUI_Tab_Event()
	Switch _GUICtrlTab_GetCurSel($pelock_obfuscator_GUI_Tab)

		Case 0 ;Eingabe
			ControlHide($pelock_obfuscator_GUI, "", $pelock_obfuscator_GUI_Ausgabe_scintilla)
			ControlShow($pelock_obfuscator_GUI, "", $pelock_obfuscator_GUI_Eingabe_scintilla)

		Case 1 ;Ausgabe
			ControlHide($pelock_obfuscator_GUI, "", $pelock_obfuscator_GUI_Eingabe_scintilla)
			ControlShow($pelock_obfuscator_GUI, "", $pelock_obfuscator_GUI_Ausgabe_scintilla)

		Case 2 ;Einstellungen
			ControlHide($pelock_obfuscator_GUI, "", $pelock_obfuscator_GUI_Ausgabe_scintilla)
			ControlHide($pelock_obfuscator_GUI, "", $pelock_obfuscator_GUI_Eingabe_scintilla)


	EndSwitch
EndFunc   ;==>_PELock_GUI_Tab_Event


Func _Obfuscator_GUI_refresh_statusbar()
	GUICtrlSetData($pelock_obfuscator_GUI_statusbar_label, "")
	GUICtrlSetColor($pelock_obfuscator_GUI_statusbar_label, 0x000000)

	If Not Ping("pelock.com") Then
		GUICtrlSetData($pelock_obfuscator_GUI_statusbar_label, _Get_langstr(1205))
		GUICtrlSetColor($pelock_obfuscator_GUI_statusbar_label, 0xFF0000)
		Return
	EndIf

	$Json_Object = _Pelock_Obfuscator_check_key_status(BinaryToString(_Crypt_DecryptData(_Config_Read("pelock_key", ""), "Isn_p#EloCK!!_PW", $CALG_RC4)))
	If Not IsObj($Json_Object) Then Return

	Local $Json_Fields = Json_ObjGetKeys($Json_Object)
	;Werte auslesen
	For $x = 0 To UBound($Json_Fields) - 1
		If $Json_Fields[$x] = "demo" Then $demo_mode = Json_ObjGet($Json_Object, "demo")
		If $Json_Fields[$x] = "credits_left" Then $left_keys = Json_ObjGet($Json_Object, "credits_left")
		If $Json_Fields[$x] = "credits_total" Then $total_keys = Json_ObjGet($Json_Object, "credits_total")
	Next

	If $demo_mode = "true" Then
		GUICtrlSetData($pelock_obfuscator_GUI_statusbar_label, _Get_langstr(1218))
		GUICtrlSetColor($pelock_obfuscator_GUI_statusbar_label, 0xFF0000)
	Else
		GUICtrlSetData($pelock_obfuscator_GUI_statusbar_label, StringReplace(StringReplace(_Get_langstr(1217), "%1", $left_keys), "%2", $total_keys))
		GUICtrlSetColor($pelock_obfuscator_GUI_statusbar_label, 0x000000)
	EndIf
EndFunc   ;==>_Obfuscator_GUI_refresh_statusbar



Func _Pelock_Obfuscator_starten()
	If Not Ping("pelock.com") Then
		MsgBox(16 + 262144, _Get_langstr(25), _Get_langstr(1205), 0, $pelock_obfuscator_GUI)
		Return
	EndIf


	If Sci_GetText($pelock_obfuscator_GUI_Eingabe_scintilla) = "" Then
		MsgBox(16 + 262144, _Get_langstr(25), _Get_langstr(1228), 0, $pelock_obfuscator_GUI)
		Return
	EndIf


	$msg_result = MsgBox(262180, _Get_langstr(48), _Get_langstr(1227), 0, $pelock_obfuscator_GUI)
	If @error Then Return
	If $msg_result = 7 Then Return

	GUISetState(@SW_SHOW, $pelock_obfuscator_GUI_vorgang_laeuft)
	GUISetState(@SW_DISABLE, $pelock_obfuscator_GUI)


	$Json_Object = _Pelock_Obfuscator_Obfuscate_Code(BinaryToString(_Crypt_DecryptData(_Config_Read("pelock_key", ""), "Isn_p#EloCK!!_PW", $CALG_RC4)), Sci_GetText($pelock_obfuscator_GUI_Eingabe_scintilla))
	If Not IsObj($Json_Object) Then
		GUISetState(@SW_ENABLE, $pelock_obfuscator_GUI)
		GUISetState(@SW_HIDE, $pelock_obfuscator_GUI_vorgang_laeuft)
		MsgBox(16 + 262144, _Get_langstr(25), _Get_langstr(1229), 0, $pelock_obfuscator_GUI)
		Return
	EndIf

	Sci_DelLines($pelock_obfuscator_GUI_Ausgabe_scintilla) ;Output löschen

	Local $errors = 0
	Local $Json_Fields = Json_ObjGetKeys($Json_Object)
	;Werte auslesen
	For $x = 0 To UBound($Json_Fields) - 1
		If $Json_Fields[$x] = "error" Then $errors = Json_ObjGet($Json_Object, "error")
		If $Json_Fields[$x] = "output" Then
		   _ISN_AutoIt_Studio_deactivate_GUI_Messages()
		   Sci_AddLines($pelock_obfuscator_GUI_Ausgabe_scintilla, Json_ObjGet($Json_Object, "output"), 0)
		   SendMessage($pelock_obfuscator_GUI_Ausgabe_scintilla, $SCI_COLOURISE, 0, -1) ;Redraw the lexer
		 _ISN_AutoIt_Studio_activate_GUI_Messages()
	    Endif
	Next

	;Prüfe auf Fehler
	If $errors <> 0 Then
		$errorstr = ""
		Switch $errors

			Case 1
				$errorstr = _Get_langstr(1230)

			Case 2
				$errorstr = _Get_langstr(1231)

			Case 3
				$errorstr = _Get_langstr(1232)

			Case 4
				$errorstr = _Get_langstr(1233)

			Case 5
				$errorstr = _Get_langstr(1234)

		EndSwitch

		GUISetState(@SW_ENABLE, $pelock_obfuscator_GUI)
		GUISetState(@SW_HIDE, $pelock_obfuscator_GUI_vorgang_laeuft)
		MsgBox(16 + 262144, _Get_langstr(25), _Get_langstr(1229) & @CRLF & @CRLF & $errorstr, 0, $pelock_obfuscator_GUI)
		Return
	EndIf

	GUICtrlSetState($pelock_obfuscator_GUI_Tab_item2, $GUI_SHOW)
	_PELock_GUI_Tab_Event()
	_Obfuscator_GUI_refresh_statusbar() ;Credits aktualisieren

	GUISetState(@SW_ENABLE, $pelock_obfuscator_GUI)
	GUISetState(@SW_HIDE, $pelock_obfuscator_GUI_vorgang_laeuft)
EndFunc   ;==>_Pelock_Obfuscator_starten





Func _Pelock_Obfuscator_check_key_status($key = "")
	Local $Curl = Curl_Easy_Init() ;Curl initialisieren
	If Not $Curl Then Return 0

	;Curl Abfrage
	Curl_Easy_Setopt($Curl, $CURLOPT_URL, $Pelock_Obfuscator_API_URL)
	Curl_Easy_Setopt($Curl, $CURLOPT_USERAGENT, "PELock AutoIt Obfuscator")
	Curl_Easy_Setopt($Curl, $CURLOPT_WRITEFUNCTION, Curl_DataWriteCallback())
	Curl_Easy_Setopt($Curl, $CURLOPT_WRITEDATA, $Curl)
	Curl_Easy_Setopt($Curl, $CURLOPT_SSL_VERIFYPEER, True)
	Curl_Easy_Setopt($Curl, $CURLOPT_FOLLOWLOCATION, True)
	Curl_Easy_Setopt($Curl, $CURLOPT_POST, True)
	Curl_Easy_Setopt($Curl, $CURLOPT_TIMEOUT, 0)
	Curl_Easy_Setopt($Curl, $CURLOPT_COPYPOSTFIELDS, "command=login&key=" & $key)


	;cURL Abfrage freigeben
	Local $Code = Curl_Easy_Perform($Curl)
	If $Code <> $CURLE_OK Then Return ""
	Local $Data = BinaryToString(Curl_Data_Get($Curl))

	;cURL Resourcen Freigeben
	Curl_Easy_Cleanup($Curl)
	Curl_Data_Cleanup($Curl)

	Return Json_Decode($Data) ;Return Data Object
EndFunc   ;==>_Pelock_Obfuscator_check_key_status


Func _Pelock_Obfuscator_Show_More_Infos()
	ShellExecute($Pelock_Obfuscator_More_Infos_URL)
EndFunc   ;==>_Pelock_Obfuscator_Show_More_Infos

Func _Pelock_Obfuscator_Buy_Key_Infos()
	ShellExecute($Pelock_Obfuscator_Buy_Key_URL)
EndFunc   ;==>_Pelock_Obfuscator_Buy_Key_Infos

Func _Pelock_Obfuscator_ISN_Settings_Check_Key()
	If Not Ping("pelock.com") Then
		MsgBox(16 + 262144, _Get_langstr(25), _Get_langstr(1205), 0, $Config_GUI)
		Return
	EndIf


	Local $left_keys = 0
	Local $total_keys = 0
	Local $demo_mode = "True"

	$Json_Object = _Pelock_Obfuscator_check_key_status(GUICtrlRead($settings_pelock_key_input))
	If Not IsObj($Json_Object) Then
		MsgBox(16 + 262144, _Get_langstr(25), _Get_langstr(1205), 0, $Config_GUI)
		Return
	EndIf

	Local $Json_Fields = Json_ObjGetKeys($Json_Object)
	;Werte auslesen
	For $x = 0 To UBound($Json_Fields) - 1
		If $Json_Fields[$x] = "demo" Then $demo_mode = Json_ObjGet($Json_Object, "demo")
		If $Json_Fields[$x] = "credits_left" Then $left_keys = Json_ObjGet($Json_Object, "credits_left")
		If $Json_Fields[$x] = "credits_total" Then $total_keys = Json_ObjGet($Json_Object, "credits_total")
	Next

	If $demo_mode = "true" Then
		MsgBox(16 + 262144, _Get_langstr(25), _Get_langstr(1212), 0, $Config_GUI)
	Else
		MsgBox(64 + 262144, _Get_langstr(61), StringReplace(StringReplace(_Get_langstr(1213), "%1", $left_keys), "%2", $total_keys), 0, $Config_GUI)
	EndIf
EndFunc   ;==>_Pelock_Obfuscator_ISN_Settings_Check_Key

Func _Pelock_Obfuscator_GUI_Checkbox_Event()


	If GUICtrlRead($Obfuscator_GUI_settings_random_integer_values_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_random_integers", "true")
	Else
		_Write_in_Config("pelock_random_integers", "false")
	EndIf



	If GUICtrlRead($Obfuscator_GUI_settings_array_with_random_values_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_random_arrays", "true")
	Else
		_Write_in_Config("pelock_random_arrays", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_functions_that_return_values_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_random_functions", "true")
	Else
		_Write_in_Config("pelock_random_functions", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_random_value_characters_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_random_characters", "true")
	Else
		_Write_in_Config("pelock_random_characters", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_multidimensional_array_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_random_arrays_multi", "true")
	Else
		_Write_in_Config("pelock_random_arrays_multi", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_autostarted_random_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_random_autostart", "true")
	Else
		_Write_in_Config("pelock_random_autostart", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_code_flow_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_mix_code_flow", "true")
	Else
		_Write_in_Config("pelock_mix_code_flow", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_rename_variables_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_rename_variables", "true")
	Else
		_Write_in_Config("pelock_rename_variables", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_rename_funcnames_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_rename_functions", "true")
	Else
		_Write_in_Config("pelock_rename_functions", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_rename_funcnames_in_calls_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_rename_function_calls", "true")
	Else
		_Write_in_Config("pelock_rename_function_calls", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_shuffle_functions_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_shuffle_functions", "true")
	Else
		_Write_in_Config("pelock_shuffle_functions", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_resolve_winapi_constants_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_resolve_const", "true")
	Else
		_Write_in_Config("pelock_resolve_const", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_encrypt_numeric_values_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_crypt_numbers", "true")
	Else
		_Write_in_Config("pelock_crypt_numbers", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_split_strings_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_split_strings", "true")
	Else
		_Write_in_Config("pelock_split_strings", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_modify_strings_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_modify_strings", "true")
	Else
		_Write_in_Config("pelock_modify_strings", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_encrypt_strings_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_crypt_strings", "true")
	Else
		_Write_in_Config("pelock_crypt_strings", "false")
	EndIf


	If GUICtrlRead($Obfuscator_GUI_settings_insert_ternary_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("pelock_insert_ternary", "true")
	Else
		_Write_in_Config("pelock_insert_ternary", "false")
	EndIf


EndFunc   ;==>_Pelock_Obfuscator_GUI_Checkbox_Event


Func _Pelock_Obfuscator_GUI_Lade_Einstellungen()

	If _Config_Read("pelock_random_integers", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_random_integer_values_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_random_integer_values_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_random_arrays", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_array_with_random_values_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_array_with_random_values_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_random_functions", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_functions_that_return_values_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_functions_that_return_values_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_random_characters", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_random_value_characters_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_random_value_characters_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_random_arrays_multi", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_multidimensional_array_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_multidimensional_array_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_random_autostart", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_autostarted_random_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_autostarted_random_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_mix_code_flow", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_code_flow_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_code_flow_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_rename_variables", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_rename_variables_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_rename_variables_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_rename_functions", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_rename_funcnames_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_rename_funcnames_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_rename_function_calls", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_rename_funcnames_in_calls_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_rename_funcnames_in_calls_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_shuffle_functions", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_shuffle_functions_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_shuffle_functions_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_resolve_const", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_resolve_winapi_constants_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_resolve_winapi_constants_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_crypt_numbers", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_encrypt_numeric_values_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_encrypt_numeric_values_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_split_strings", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_split_strings_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_split_strings_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_modify_strings", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_modify_strings_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_modify_strings_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_crypt_strings", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_encrypt_strings_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_encrypt_strings_checkbox, $GUI_UNCHECKED)
	EndIf

	If _Config_Read("pelock_insert_ternary", "true") = "true" Then
		GUICtrlSetState($Obfuscator_GUI_settings_insert_ternary_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Obfuscator_GUI_settings_insert_ternary_checkbox, $GUI_UNCHECKED)
	EndIf


EndFunc   ;==>_Pelock_Obfuscator_GUI_Lade_Einstellungen


Func _Pelock_Obfuscator_Obfuscate_Code($key = "", $Source = "")
	If $Source = "" Then Return 0

	;Encode Source for URL Transfer
	$Source = _URIEncode($Source)

	Local $Curl = Curl_Easy_Init() ;Curl initialisieren
	If Not $Curl Then Return

	;Setup Parameters
	Local $Parameters = ""

	If GUICtrlRead($Obfuscator_GUI_settings_random_integer_values_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&random_bucket_integers=1"
	If GUICtrlRead($Obfuscator_GUI_settings_array_with_random_values_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&random_bucket_arrays=1"
	If GUICtrlRead($Obfuscator_GUI_settings_functions_that_return_values_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&random_bucket_functions=1"
	If GUICtrlRead($Obfuscator_GUI_settings_random_value_characters_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&random_bucket_characters=1"
	If GUICtrlRead($Obfuscator_GUI_settings_multidimensional_array_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&random_bucket_arrays_multidimensional=1"
	If GUICtrlRead($Obfuscator_GUI_settings_autostarted_random_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&random_bucket_autostart=1"
	If GUICtrlRead($Obfuscator_GUI_settings_code_flow_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&mix_code_flow=1"
	If GUICtrlRead($Obfuscator_GUI_settings_rename_variables_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&rename_variables=1"
	If GUICtrlRead($Obfuscator_GUI_settings_rename_funcnames_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&rename_functions=1"
	If GUICtrlRead($Obfuscator_GUI_settings_rename_funcnames_in_calls_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&rename_function_calls=1"
	If GUICtrlRead($Obfuscator_GUI_settings_shuffle_functions_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&shuffle_functions=1"
	If GUICtrlRead($Obfuscator_GUI_settings_resolve_winapi_constants_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&resolve_const=1"
	If GUICtrlRead($Obfuscator_GUI_settings_encrypt_numeric_values_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&crypt_numbers=1"
	If GUICtrlRead($Obfuscator_GUI_settings_split_strings_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&split_strings=1"
	If GUICtrlRead($Obfuscator_GUI_settings_modify_strings_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&modify_strings=1"
	If GUICtrlRead($Obfuscator_GUI_settings_encrypt_strings_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&crypt_strings=1"
	If GUICtrlRead($Obfuscator_GUI_settings_insert_ternary_checkbox) = $GUI_CHECKED Then $Parameters = $Parameters & "&insert_ternary_operators=1"

	;Curl Abfrage
	Curl_Easy_Setopt($Curl, $CURLOPT_URL, $Pelock_Obfuscator_API_URL)
	Curl_Easy_Setopt($Curl, $CURLOPT_USERAGENT, "PELock AutoIt Obfuscator")
	Curl_Easy_Setopt($Curl, $CURLOPT_WRITEFUNCTION, Curl_DataWriteCallback())
	Curl_Easy_Setopt($Curl, $CURLOPT_WRITEDATA, $Curl)
	Curl_Easy_Setopt($Curl, $CURLOPT_SSL_VERIFYPEER, True)
	Curl_Easy_Setopt($Curl, $CURLOPT_FOLLOWLOCATION, True)
	Curl_Easy_Setopt($Curl, $CURLOPT_POST, True)
	Curl_Easy_Setopt($Curl, $CURLOPT_TIMEOUT, 0)
	Curl_Easy_Setopt($Curl, $CURLOPT_COPYPOSTFIELDS, "command=obfuscate&key=" & $key & $Parameters & "&source=" & $Source)


	;cURL Abfrage freigeben
	Local $Code = Curl_Easy_Perform($Curl)
	If $Code <> $CURLE_OK Then Return ""
	Local $Data = BinaryToString(Curl_Data_Get($Curl))

	;cURL Resourcen Freigeben
	Curl_Easy_Cleanup($Curl)
	Curl_Data_Cleanup($Curl)

	Return Json_Decode($Data) ;Return Data Object
EndFunc   ;==>_Pelock_Obfuscator_Obfuscate_Code

Func _URIEncode($sData)
	; Prog@ndy
	Local $aData = StringSplit(BinaryToString(StringToBinary($sData, 4), 1), "")
	Local $nChar
	$sData = ""
	For $i = 1 To $aData[0]
		; ConsoleWrite($aData[$i] & @CRLF)
		$nChar = Asc($aData[$i])
		Switch $nChar
			Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
				$sData &= $aData[$i]
			Case 32
				$sData &= "+"
			Case Else
				$sData &= "%" & Hex($nChar, 2)
		EndSwitch
	Next
	Return $sData
EndFunc   ;==>_URIEncode

Func _URIDecode($sData)
	; Prog@ndy
	Local $aData = StringSplit(StringReplace($sData, "+", " ", 0, 1), "%")
	$sData = ""
	For $i = 2 To $aData[0]
		$aData[1] &= Chr(Dec(StringLeft($aData[$i], 2))) & StringTrimLeft($aData[$i], 2)
	Next
	Return BinaryToString(StringToBinary($aData[1], 1), 4)
EndFunc   ;==>_URIDecode
