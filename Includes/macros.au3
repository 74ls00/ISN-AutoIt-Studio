;Macros for ISN




Func _Config_Ruleaction($action = "", $ID = "")
	$Temp_ID_Holder = $ID
	Switch $action

		Case $Key_Action1
			_Show_Config_Statusbar($ID)

		Case $Key_Action2
			_Show_Config_Sleeprule($ID)

		Case $Key_Action3
			_Save_Config_Minimize()

		Case $Key_Action4
			_Show_Config_Fileoperation($ID)

		Case $Key_Action5
			_Show_Config_Runfile($ID)

		Case $Key_Action6
			_Show_Config_compilefile($ID)

		Case $Key_Action7
			_Save_Config_closeproject()

		Case $Key_Action8
			_Show_Config_openexternalfile($ID)

		Case $Key_Action9
			_Show_Config_msgboxrule($ID)

		Case $Key_Action10
			_Show_Config_executecommand($ID)

		Case $Key_Action11
			_Show_Config_setstartparams($ID)

		Case $Key_Action12
			_Show_Config_addlog($ID)

		Case $Key_Action13
			_Save_Config_Backup()

		Case $Key_Action14
			_Show_Config_Codeausschnitt($ID)

		Case $Key_Action15
			_Show_Config_changeprojectversion($ID)

		Case $Key_Action16
			_Show_Config_runscript($ID)

	EndSwitch
	GUISetState(@SW_HIDE, $choose_action_GUI)
EndFunc   ;==>_Config_Ruleaction

Func _get_actionname_by_section($section)
	$section = StringTrimRight($section, StringLen($section) - StringInStr($section, "[") + 1)
	If $section = $Key_Action1 Then Return _Get_langstr(517)
	If $section = $Key_Action2 Then Return _Get_langstr(540)
	If $section = $Key_Action3 Then Return _Get_langstr(550)
	If $section = $Key_Action4 Then Return _Get_langstr(575)
	If $section = $Key_Action5 Then Return _Get_langstr(592)
	If $section = $Key_Action6 Then Return _Get_langstr(601)
	If $section = $Key_Action7 Then Return _Get_langstr(320)
	If $section = $Key_Action8 Then Return _Get_langstr(509)
	If $section = $Key_Action9 Then Return _Get_langstr(646)
	If $section = $Key_Action10 Then Return _Get_langstr(784)
	If $section = $Key_Action11 Then Return _Get_langstr(490)
	If $section = $Key_Action12 Then Return _Get_langstr(820)
	If $section = $Key_Action13 Then Return _Get_langstr(893)
	If $section = $Key_Action14 Then Return _Get_langstr(973)
	If $section = $Key_Action15 Then Return _Get_langstr(233)
	If $section = $Key_Action16 Then Return _Get_langstr(1126)

EndFunc   ;==>_get_actionname_by_section

Func _get_details_by_section($section, $ruleID = "")
	If $ruleID = "" Then $ruleID = GUICtrlRead($rule_ID)
	$action = StringTrimRight($section, StringLen($section) - StringInStr($section, "[") + 1)
	$action_ID = _StringBetween($section, '[', ']')
	If $action = $Key_Action1 Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "statusbar_string[" & $action_ID[0] & "]", "")
	If $action = $Key_Action2 Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "sleep_time[" & $action_ID[0] & "]", "")
	If $action = $Key_Action3 Then Return ""

	If $action = $Key_Action4 Then
		$readen_mode = IniRead($Pfad_zur_Project_ISN, $ruleID, "fileoperation_mode[" & $action_ID[0] & "]", "copy")
		If $readen_mode = "copy" Then $Str = _Get_langstr(111)
		If $readen_mode = "move" Then $Str = _Get_langstr(121)
		If $readen_mode = "delete" Then $Str = _Get_langstr(67)
		If $readen_mode = "rename" Then $Str = _Get_langstr(66)
		$Str = $Str & " " & IniRead($Pfad_zur_Project_ISN, $ruleID, "fileoperation_source[" & $action_ID[0] & "]", "")
		Return $Str
	EndIf

	If $action = $Key_Action5 Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "file_runpath[" & $action_ID[0] & "]", "")
	If $action = $Key_Action6 Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_inputfile[" & $action_ID[0] & "]", "")
	If $action = $Key_Action7 Then Return ""
	If $action = $Key_Action8 Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "open_externalfile[" & $action_ID[0] & "]", "")
	If $action = $Key_Action9 Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "msgbox_text[" & $action_ID[0] & "]", "")
	If $action = $Key_Action10 Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "command[" & $action_ID[0] & "]", "")
	If $action = $Key_Action11 Then Return StringReplace(IniRead($Pfad_zur_Project_ISN, $ruleID, "params[" & $action_ID[0] & "]", ""), "#BREAK#", " ")
	If $action = $Key_Action12 Then Return StringReplace(IniRead($Pfad_zur_Project_ISN, $ruleID, "text[" & $action_ID[0] & "]", ""), "#BREAK#", " ")
	If $action = $Key_Action13 Then Return ""
	If $action = $Key_Action14 Then Return StringReplace(IniRead($Pfad_zur_Project_ISN, $ruleID, "code[" & $action_ID[0] & "]", ""), "[BREAK]", " ")
	If $action = $Key_Action15 Then
		$readen_mode = IniRead($Pfad_zur_Project_ISN, $ruleID, "setversionmode[" & $action_ID[0] & "]", "set")
		If $readen_mode = "set" Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "setversionto[" & $action_ID[0] & "]", "")
		If $readen_mode = "add" Then Return _Get_langstr(980)
	EndIf
	If $action = $Key_Action16 Then
		$readen_mode = IniRead($Pfad_zur_Project_ISN, $ruleID, "use_tab_to_run[" & $action_ID[0] & "]", "true")
		If $readen_mode = "true" Then Return _Get_langstr(1128)
		If $readen_mode = "false" Then Return IniRead($Pfad_zur_Project_ISN, $ruleID, "run_filename[" & $action_ID[0] & "]", "")
	EndIf
	Return ""
EndFunc   ;==>_get_details_by_section

Func _get_triggername_by_section($section)
	If $section = $Section_Trigger1 Then Return _Get_langstr(20)
	If $section = $Section_Trigger2 Then Return _Get_langstr(1196)
	If $section = $Section_Trigger3 Then Return _Get_langstr(9)
	If $section = $Section_Trigger4 Then Return _Get_langstr(327)
	If $section = $Section_Trigger5 Then Return _Get_langstr(108)
	If $section = $Section_Trigger6 Then Return _Get_langstr(320)
	If $section = $Section_Trigger7 Then Return _Get_langstr(508)
	If $section = $Section_Trigger8 Then Return _Get_langstr(80)
	If $section = $Section_Trigger9 Then Return _Get_langstr(552)
	If $section = $Section_Trigger10 Then Return _Get_langstr(106)
	If $section = $Section_Trigger11 Then Return _Get_langstr(561)
	If $section = $Section_Trigger12 Then Return _Get_langstr(611)
	If $section = $Section_Trigger13 Then Return _Get_langstr(612)
	If $section = $Section_Trigger14 Then Return _Get_langstr(613)
	If $section = $Section_Trigger15 Then Return _Get_langstr(614)
	If $section = $Section_Trigger16 Then Return _Get_langstr(615)
	If $section = $Section_Trigger17 Then Return _Get_langstr(906)
	If $section = $Section_Trigger18 Then Return _Get_langstr(907)
	If $section = $Section_Trigger19_compilefile Then Return _Get_langstr(1198)
	If $section = $Section_Trigger20_beforecompileproject Then Return _Get_langstr(1197)
	If $section = $Section_Trigger21_beforecompilefile Then Return _Get_langstr(1199)


EndFunc   ;==>_get_triggername_by_section

Func _Show_Add_Trigger()
	GUICtrlSetData($Trigger_Combolist, "")
	GUICtrlSetData($Trigger_Combolabel, "")

	$Combostring = ""

	Global $Trigger_Selection_combo_ARRAY[1]

	$Combostring = $Combostring & _Get_langstr(20) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger1)

	$Combostring = $Combostring & _Get_langstr(1196) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger2)

	$Combostring = $Combostring & _Get_langstr(9) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger3)

	$Combostring = $Combostring & _Get_langstr(327) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger4)

	$Combostring = $Combostring & _Get_langstr(108) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger5)

	$Combostring = $Combostring & _Get_langstr(508) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger7)

	$Combostring = $Combostring & _Get_langstr(80) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger8)

	$Combostring = $Combostring & _Get_langstr(552) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger9)

	$Combostring = $Combostring & _Get_langstr(106) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger10)

	$Combostring = $Combostring & _Get_langstr(561) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger11)

	$Combostring = $Combostring & _Get_langstr(611) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger12)

	$Combostring = $Combostring & _Get_langstr(612) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger13)

	$Combostring = $Combostring & _Get_langstr(613) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger14)

	$Combostring = $Combostring & _Get_langstr(614) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger15)

	$Combostring = $Combostring & _Get_langstr(615) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger16)

	$Combostring = $Combostring & _Get_langstr(906) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger17)

	$Combostring = $Combostring & _Get_langstr(907) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger18)

	$Combostring = $Combostring & _Get_langstr(1198) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger19_compilefile)

	$Combostring = $Combostring & _Get_langstr(1197) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger20_beforecompileproject)

	$Combostring = $Combostring & _Get_langstr(1199) & "|"
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger21_beforecompilefile)

	$Combostring = $Combostring & _Get_langstr(320)
	_ArrayAdd($Trigger_Selection_combo_ARRAY, $Section_Trigger6)

	;Build clean sortet arrays and strings
	$Array_to_sort = StringSplit($Combostring, "|", 2)
	_ArrayDelete($Trigger_Selection_combo_ARRAY, 0)
	$iRows = UBound($Array_to_sort)
	If $iRows < UBound($Trigger_Selection_combo_ARRAY) Then $iRows = UBound($Trigger_Selection_combo_ARRAY) - 1
	Dim $aOutput[$iRows][2]
	For $x = 0 To $iRows - 1
		If $x > UBound($Array_to_sort) - 1 Then ContinueLoop
		$aOutput[$x][0] = $Array_to_sort[$x]
		If $x > UBound($Trigger_Selection_combo_ARRAY) - 1 Then ContinueLoop
		$aOutput[$x][1] = $Trigger_Selection_combo_ARRAY[$x]
	Next
	_ArraySort($aOutput)
	$Combostring = ""
	Global $Trigger_Selection_combo_ARRAY[1]
	For $x = 0 To UBound($aOutput) - 1
		$Combostring = $Combostring & $aOutput[$x][0] & "|"
		_ArrayAdd($Trigger_Selection_combo_ARRAY, $aOutput[$x][1])
	Next
	$Combostring = StringTrimRight($Combostring, 1) ;trim last |
	_ArrayDelete($Trigger_Selection_combo_ARRAY, 0)

	GUICtrlSetData($Trigger_Combolist, $Combostring, _Get_langstr(20))
	_Read_triggerlabel()
	GUISetState(@SW_SHOW, $choose_trigger)
	GUISetState(@SW_DISABLE, $newrule_GUI)
EndFunc   ;==>_Show_Add_Trigger

Func _Read_triggerlabel()
	GUICtrlSetData($Trigger_Combolabel, "")
	Switch $Trigger_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($Trigger_Combolist)]

		Case $Section_Trigger1
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(511))

		Case $Section_Trigger2
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(512))

		Case $Section_Trigger3
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(513))

		Case $Section_Trigger4
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(516))

		Case $Section_Trigger5
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(544))

		Case $Section_Trigger6
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(545))

		Case $Section_Trigger7
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(546))

		Case $Section_Trigger8
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(547))

		Case $Section_Trigger9
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(553))

		Case $Section_Trigger10
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(560))

		Case $Section_Trigger11
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(562))

		Case $Section_Trigger12
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(617))

		Case $Section_Trigger13
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(617))

		Case $Section_Trigger14
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(617))

		Case $Section_Trigger15
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(617))

		Case $Section_Trigger16
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(617))

		Case $Section_Trigger17
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(617))

		Case $Section_Trigger18
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(617))

		Case $Section_Trigger19_compilefile
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(1077))

		Case $Section_Trigger20_beforecompileproject
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(1201))

		Case $Section_Trigger21_beforecompilefile
			GUICtrlSetData($Trigger_Combolabel, _Get_langstr(1200))
	EndSwitch
EndFunc   ;==>_Read_triggerlabel

Func _Loesche_Regel()
	If _GUICtrlListView_GetSelectionMark($listview_projectrules) = -1 Then Return
	If _GUICtrlListView_GetItemCount($listview_projectrules) = 0 Then Return
	$answer = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(539), 0, $ruleseditor)
	If $answer = 6 Then

		$to_delete = _GUICtrlListView_GetItemText($listview_projectrules, _GUICtrlListView_GetSelectionMark($listview_projectrules), 2)
		IniDelete($Pfad_zur_Project_ISN, $to_delete)

		;Delete every possible trigger
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger1, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger2, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger3, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger4, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger5, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger6, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger7, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger8, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger9, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger10, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger11, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger12, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger13, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger14, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger15, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger16, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger17, $to_delete)
		IniDelete($Pfad_zur_Project_ISN, $Section_Trigger18, $to_delete)

		_Build_Rulelist()
	EndIf
EndFunc   ;==>_Loesche_Regel

Func _Show_Add_action()
	GUICtrlSetData($action_Combolist, "")
	GUICtrlSetData($action_Combolabel, "")
	Global $Action_Selection_combo_ARRAY[1]
	$Combostring = ""

	$Combostring = $Combostring & _Get_langstr(517) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action1)

	$Combostring = $Combostring & _Get_langstr(550) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action3)

	$Combostring = $Combostring & _Get_langstr(575) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action4)

	$Combostring = $Combostring & _Get_langstr(592) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action5)

	$Combostring = $Combostring & _Get_langstr(601) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action6)

	$Combostring = $Combostring & _Get_langstr(320) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action7)

	$Combostring = $Combostring & _Get_langstr(509) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action8)

	$Combostring = $Combostring & _Get_langstr(646) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action9)

	$Combostring = $Combostring & _Get_langstr(784) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action10)

	$Combostring = $Combostring & _Get_langstr(490) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action11)

	$Combostring = $Combostring & _Get_langstr(820) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action12)

	$Combostring = $Combostring & _Get_langstr(893) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action13)

	$Combostring = $Combostring & _Get_langstr(973) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action14)

	$Combostring = $Combostring & _Get_langstr(233) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action15)

	$Combostring = $Combostring & _Get_langstr(1126) & "|"
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action16)


	$Combostring = $Combostring & _Get_langstr(540)
	_ArrayAdd($Action_Selection_combo_ARRAY, $Key_Action2)

	;Build clean sortet arrays and strings
	$Array_to_sort = StringSplit($Combostring, "|", 2)
	_ArrayDelete($Action_Selection_combo_ARRAY, 0)
	$iRows = UBound($Array_to_sort)
	If $iRows < UBound($Action_Selection_combo_ARRAY) Then $iRows = UBound($Action_Selection_combo_ARRAY) - 1
	Dim $aOutput[$iRows][2]
	For $x = 0 To $iRows - 1
		If $x > UBound($Array_to_sort) - 1 Then ContinueLoop
		$aOutput[$x][0] = $Array_to_sort[$x]
		If $x > UBound($Action_Selection_combo_ARRAY) - 1 Then ContinueLoop
		$aOutput[$x][1] = $Action_Selection_combo_ARRAY[$x]
	Next
	_ArraySort($aOutput)
	$Combostring = ""
	Global $Action_Selection_combo_ARRAY[1]
	For $x = 0 To UBound($aOutput) - 1
		$Combostring = $Combostring & $aOutput[$x][0] & "|"
		_ArrayAdd($Action_Selection_combo_ARRAY, $aOutput[$x][1])
	Next
	$Combostring = StringTrimRight($Combostring, 1) ;trim last |
	_ArrayDelete($Action_Selection_combo_ARRAY, 0)

	GUICtrlSetData($action_Combolist, $Combostring, _Get_langstr(517))
	_Read_actionlabel()
	GUISetState(@SW_SHOW, $choose_action_GUI)
	GUISetState(@SW_DISABLE, $newrule_GUI)
EndFunc   ;==>_Show_Add_action

Func _Read_actionlabel()
	GUICtrlSetData($action_Combolabel, "")
	Switch $Action_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($action_Combolist)]

		Case $Key_Action1
			GUICtrlSetData($action_Combolabel, _Get_langstr(518))

		Case $Key_Action2
			GUICtrlSetData($action_Combolabel, _Get_langstr(541))

		Case $Key_Action3
			GUICtrlSetData($action_Combolabel, _Get_langstr(551))

		Case $Key_Action4
			GUICtrlSetData($action_Combolabel, _Get_langstr(576))

		Case $Key_Action5
			GUICtrlSetData($action_Combolabel, _Get_langstr(593))

		Case $Key_Action6
			GUICtrlSetData($action_Combolabel, _Get_langstr(600))

		Case $Key_Action7
			GUICtrlSetData($action_Combolabel, _Get_langstr(624))

		Case $Key_Action8
			GUICtrlSetData($action_Combolabel, _Get_langstr(645))

		Case $Key_Action9
			GUICtrlSetData($action_Combolabel, _Get_langstr(647))

		Case $Key_Action10
			GUICtrlSetData($action_Combolabel, _Get_langstr(785))

		Case $Key_Action11
			GUICtrlSetData($action_Combolabel, _Get_langstr(807))

		Case $Key_Action12
			GUICtrlSetData($action_Combolabel, _Get_langstr(871))

		Case $Key_Action13
			GUICtrlSetData($action_Combolabel, _Get_langstr(898))

		Case $Key_Action14
			GUICtrlSetData($action_Combolabel, _Get_langstr(974))

		Case $Key_Action15
			GUICtrlSetData($action_Combolabel, _Get_langstr(981))

		Case $Key_Action16
			GUICtrlSetData($action_Combolabel, _Get_langstr(1129))
	EndSwitch
EndFunc   ;==>_Read_actionlabel

Func _Pruefe_Macrosicherheit($modus = 1, $rulesection = "", $ini_section = "", $action_section = "", $ruleID = "")
	;Sicherheit
	If $Makrosicherheitslevel = 4 Then Return "false" ;Alles blokieren
	$makroname = IniRead($Pfad_zur_Project_ISN, $ini_section, "name", "")


	Switch $modus

		Case 1 ;Makro selbst
			If $Makrosicherheitslevel = 2 Or $Makrosicherheitslevel = 3 Then
				Local $aktionen = ""
				;Aktionen in text umwandeln
				$actions_array = StringSplit(IniRead($Pfad_zur_Project_ISN, $ini_section, "actions", ""), "|", 2)
				For $u = 0 To UBound($actions_array) - 1
					If $actions_array[$u] = "" Then ContinueLoop
					$aktionen = $aktionen & " - " & _get_actionname_by_section($actions_array[$u]) & @CRLF
				Next
				$antwort = MsgBox(262144 + 4 + 48, _Get_langstr(1150), _Get_langstr(1159) & @CRLF & @CRLF & _Get_langstr(527) & " " & $makroname & @CRLF & _Get_langstr(1158) & " " & _get_triggername_by_section($rulesection) & @CRLF & @CRLF & _Get_langstr(1162) & @CRLF & $aktionen & @CRLF & _Get_langstr(1160), 0, $Studiofenster)
				If @error Then Return "false"
				If $antwort = 7 Then Return "false"
			EndIf

		Case 2 ;Aktion eines makros
			If $Makrosicherheitslevel = 3 Or $Makrosicherheitslevel = 1 Then

				If $Makrosicherheitslevel = 1 Then
					Local $keine_bestaetigung_noetig = 1
					;Hier werden Makros angegeben die auf der Stufe Niedrig eine bestätigungen benötigen

					Switch StringTrimRight($action_section, StringLen($action_section) - StringInStr($action_section, "[") + 1)

						Case $Key_Action4 ;Dateioperation
							$keine_bestaetigung_noetig = 0

						Case $Key_Action5 ;Datei starten
							$keine_bestaetigung_noetig = 0

						Case $Key_Action10 ;Befehl ausführen
							$keine_bestaetigung_noetig = 0

						Case $Key_Action16 ;Skript ausführen
							$keine_bestaetigung_noetig = 0
					EndSwitch

					If $keine_bestaetigung_noetig = 1 Then Return "true"
				EndIf


				$actionname = _get_actionname_by_section($action_section)
				$details = _get_details_by_section($action_section, $ruleID)
				$antwort = MsgBox(262144 + 4 + 48, _Get_langstr(1150), StringReplace(_Get_langstr(1164), "%1", $makroname) & @CRLF & @CRLF & _Get_langstr(1165) & " " & $actionname & @CRLF & _Get_langstr(139) & ": " & $details & @CRLF & @CRLF & _Get_langstr(1160), 0, $Studiofenster)
				If @error Then Return "false"
				If $antwort = 7 Then Return "false"

			EndIf

	EndSwitch
	Return "true" ;Makro darf ausgeführt werden
EndFunc   ;==>_Pruefe_Macrosicherheit




Func _run_rule($rulesection = "")
	If $rulesection = "" Then Return 0
	If $Offenes_Projekt = "" Then
		$Regel_lauft = 0
		Return 0
	EndIf
	If $Regel_lauft = 1 Then Return -1

	$Regel_lauft = 1
	$readenrules = IniReadSection($Pfad_zur_Project_ISN, $rulesection)
	If @error Then
		;Nichts zu erledigen
		$Regel_lauft = 0
		Return 0
	EndIf

	For $i = 1 To $readenrules[0][0]
		If IniRead($Pfad_zur_Project_ISN, $readenrules[$i][0], "status", "active") <> "active" Then ContinueLoop
		If _Pruefe_Macrosicherheit(1, $rulesection, $readenrules[$i][0]) <> "true" Then
			_Write_log(StringReplace(_Get_langstr(1161), "%1", IniRead($Pfad_zur_Project_ISN, $readenrules[$i][0], "name", "")), "FF0000")
			ContinueLoop
		EndIf
		$readen = IniRead($Pfad_zur_Project_ISN, $readenrules[$i][0], "actions", "")
		$actions_array = StringSplit($readen, "|", 2)
		For $u = 0 To UBound($actions_array) - 1
			If $actions_array[$u] = "" Then ContinueLoop
			$action_ID = _StringBetween($actions_array[$u], '[', ']')
			If _Pruefe_Macrosicherheit(2, $rulesection, $readenrules[$i][0], $actions_array[$u], $readenrules[$i][0]) <> "true" Then
				_Write_log(StringReplace(StringReplace(_Get_langstr(1163), "%2", IniRead($Pfad_zur_Project_ISN, $readenrules[$i][0], "name", "")), "%1", _get_actionname_by_section($actions_array[$u])), "FF0000")
				ContinueLoop
			EndIf
			Switch StringTrimRight($actions_array[$u], StringLen($actions_array[$u]) - StringInStr($actions_array[$u], "[") + 1)

				Case $Key_Action1
					_Run_Statusbar($readenrules[$i][0], $action_ID[0])

				Case $Key_Action2
					_Run_Sleeprule($readenrules[$i][0], $action_ID[0])

				Case $Key_Action3
					_Run_MinimizestudioRule($readenrules[$i][0], $action_ID[0])

				Case $Key_Action4
					_Run_fileoperationrule($readenrules[$i][0], $action_ID[0])
					;_Update_Treeview() ;Zum Abschluss noch den Projektbaum aktualisieren

				Case $Key_Action5
					_Run_openfilerule($readenrules[$i][0], $action_ID[0])

				Case $Key_Action6
					_Run_compilefilerule($readenrules[$i][0], $action_ID[0])
					;_Update_Treeview() ;Zum Abschluss noch den Projektbaum aktualisieren

				Case $Key_Action7
					_Run_closeprojectRule($readenrules[$i][0], $action_ID[0])

				Case $Key_Action8
					_Run_openexternalfilerule($readenrules[$i][0], $action_ID[0])

				Case $Key_Action9
					_Run_msgboxrule($readenrules[$i][0], $action_ID[0])

				Case $Key_Action10
					_Run_executecommandrule($readenrules[$i][0], $action_ID[0])
					;_Update_Treeview() ;Zum Abschluss noch den Projektbaum aktualisieren

				Case $Key_Action11
					_Run_setstartparamsrule($readenrules[$i][0], $action_ID[0])

				Case $Key_Action12
					_Run_addlogrule($readenrules[$i][0], $action_ID[0])

				Case $Key_Action13
					_Run_Makro_Backup($readenrules[$i][0], $action_ID[0])
					;_Update_Treeview() ;Zum Abschluss noch den Projektbaum aktualisieren

				Case $Key_Action14
					_Run_codeausschnitt_einfuegen_macro($readenrules[$i][0], $action_ID[0])

				Case $Key_Action15
					_Run_changeprojectversion($readenrules[$i][0], $action_ID[0])

				Case $Key_Action16
					_Run_macro_runscript($readenrules[$i][0], $action_ID[0])
					;_Update_Treeview() ;Zum Abschluss noch den Projektbaum aktualisieren


			EndSwitch
			If $Regel_lauft <> 1 Then ExitLoop
			If $Offenes_Projekt = "" Then ExitLoop
		Next

	Next

	$Regel_lauft = 0
	;_WinFlash($Studiofenster)
	Return 1
EndFunc   ;==>_run_rule

;-----------------------------------------------------------------------------------------------------------------------------------------
;	MACROS
;-----------------------------------------------------------------------------------------------------------------------------------------

Func _cancel_any_config()
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $stausbar_Set_GUI)
	GUISetState(@SW_HIDE, $Slepprule_GUI)
	GUISetState(@SW_HIDE, $rule_fileoperation_configgui)
	GUISetState(@SW_HIDE, $runfile_config)
	GUISetState(@SW_HIDE, $rulecompileconfig_gui)
	GUISetState(@SW_HIDE, $msgboxcreator_rule)
	GUISetState(@SW_HIDE, $ExecuteCommandRuleConfig_GUI)
	GUISetState(@SW_HIDE, $parameter_GUI_rule)
	GUISetState(@SW_HIDE, $addlog_GUI)
	GUISetState(@SW_HIDE, $Makro_Codeausschnitt_GUI)
	GUISetState(@SW_HIDE, $macro_changeVersionGUI)
	GUISetState(@SW_HIDE, $macro_runscriptGUI)
EndFunc   ;==>_cancel_any_config

Func _Run_Statusbar($ruleID, $ID)
	_GUICtrlStatusBar_SetText($Status_bar, _ISN_Variablen_aufloesen(IniRead($Pfad_zur_Project_ISN, $ruleID, "statusbar_string[" & $ID & "]", "")))
EndFunc   ;==>_Run_Statusbar

Func _Show_Config_Statusbar($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	GUICtrlSetData($stausbarGUI_input, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "statusbar_string[" & $ID & "]", ""))
	$Temp_ID_Holder = $ID
	GUISetState(@SW_SHOW, $stausbar_Set_GUI)
EndFunc   ;==>_Show_Config_Statusbar

Func _Save_Config_Statusbar()
	If GUICtrlRead($stausbarGUI_input) = "" Then
		_Input_Error_FX($stausbarGUI_input)
		Return
	EndIf

	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action1 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action1 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "statusbar_string[" & $Temp_ID_Holder & "]", GUICtrlRead($stausbarGUI_input))
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $stausbar_Set_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_Statusbar

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_Sleeprule($ruleID, $ID)
	Sleep(Number(IniRead($Pfad_zur_Project_ISN, $ruleID, "sleep_time[" & $ID & "]", "0")))
EndFunc   ;==>_Run_Sleeprule

Func _Show_Config_Sleeprule($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	GUICtrlSetData($Slepprule_GUI_input, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "sleep_time[" & $ID & "]", ""))
	$Temp_ID_Holder = $ID
	GUISetState(@SW_SHOW, $Slepprule_GUI)
EndFunc   ;==>_Show_Config_Sleeprule

Func _Save_Config_Sleeprule()
	If GUICtrlRead($Slepprule_GUI_input) = "" Then
		_Input_Error_FX($Slepprule_GUI_input)
		Return
	EndIf
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action2 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action2 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "sleep_time[" & $Temp_ID_Holder & "]", GUICtrlRead($Slepprule_GUI_input))
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $Slepprule_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_Sleeprule

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_MinimizestudioRule($ruleID, $ID)
	WinSetState($Studiofenster, "", @SW_MINIMIZE)
EndFunc   ;==>_Run_MinimizestudioRule

Func _Save_Config_Minimize()
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action3 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action3 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	Else
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(549), 0, $newrule_GUI)
	EndIf
	GUISetState(@SW_ENABLE, $newrule_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_Minimize

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_fileoperationrule($ruleID, $ID)
	$readen_mode = IniRead($Pfad_zur_Project_ISN, $ruleID, "fileoperation_mode[" & $ID & "]", "copy")
	$source = IniRead($Pfad_zur_Project_ISN, $ruleID, "fileoperation_source[" & $ID & "]", "")
	$target = IniRead($Pfad_zur_Project_ISN, $ruleID, "fileoperation_target[" & $ID & "]", "")
	$mustconfirm = IniRead($Pfad_zur_Project_ISN, $ruleID, "fileoperation_mustconfirm[" & $ID & "]", "false")
	If $mustconfirm = "true" Then
		$flags = $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION
	Else
		$flags = $FOF_SIMPLEPROGRESS
	EndIf
	If $source = "" Then Return
	If $readen_mode = "copy" Or $readen_mode = "move" Then
		If $target = "" Then Return
	EndIf

	_Write_ISN_Debug_Console("Fileoparation initiated!", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
	;Sicherheitsstufen
	;-> Windows dir kan nicht gelöscht werden!!
	If $source = "%windowsdir%" And $readen_mode = "delete" Then Return
	If $source = "%windowsdir%\" And $readen_mode = "delete" Then Return
	If $source = "%windowsdir%\" And $readen_mode = "rename" Then Return
	If $source = "%windowsdir%" And $readen_mode = "rename" Then Return
	If $source = "%windowsdir%" And $readen_mode = "move" Then Return
	If $source = "%windowsdir%\" And $readen_mode = "move" Then Return

	If $source = "%isnstudiodir%" And $readen_mode = "delete" Then Return
	If $source = "%isnstudiodir%\" And $readen_mode = "delete" Then Return
	If $source = "%%isnstudiodir%" And $readen_mode = "rename" Then Return
	If $source = "%isnstudiodir%\" And $readen_mode = "rename" Then Return
	If $source = "%%isnstudiodir%" And $readen_mode = "move" Then Return
	If $source = "%isnstudiodir%\" And $readen_mode = "move" Then Return

	$source = _ISN_Variablen_aufloesen($source)
	$target = _ISN_Variablen_aufloesen($target, $source)

;~ msgbox(0,"source",$source)
;~ msgbox(0,"$target",$target)
	If Not FileExists($source) Then
		_Write_ISN_Debug_Console("|--> RESULT: ERROR (File " & StringReplace($source, "\", "\\") & " does not exists!)", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		Return
	EndIf

	If $readen_mode = "delete" Then
		If _IsDir($source) = True Then
			_Write_ISN_Debug_Console("|--> MODE: Delete Folder (" & StringReplace($source, "\", "\\") & ")", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			DirRemove($source, 1)
			If @error Then
				_Write_ISN_Debug_Console("|--> RESULT: ERROR (Errorcode: " & @error & ", Extended: " & @extended & ")", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			Else
				_Write_ISN_Debug_Console("|--> RESULT: OK", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			EndIf
		Else
			_Write_ISN_Debug_Console("|--> MODE: Delete File (" & StringReplace($source, "\", "\\") & ")", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			FileDelete($source)
			If @error Then
				_Write_ISN_Debug_Console("|--> RESULT: ERROR (Errorcode: " & @error & ", Extended: " & @extended & ")", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			Else
				_Write_ISN_Debug_Console("|--> RESULT: OK", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			EndIf
		EndIf
	EndIf

	If $readen_mode = "copy" Then
		_Write_ISN_Debug_Console("|--> MODE: Copy", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_Write_ISN_Debug_Console("|--> SOURCE: " & StringReplace($source, "\", "\\"), $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_Write_ISN_Debug_Console("|--> DESTINATION: " & StringReplace($target, "\", "\\"), $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_FileOperationProgress($source, $target, 1, $FO_COPY, $flags)
		If @error Then
			_Write_ISN_Debug_Console("|--> RESULT: ERROR (Errorcode: " & @error & ", Extended: " & @extended & ")", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		Else
			_Write_ISN_Debug_Console("|--> RESULT: OK", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		EndIf
	EndIf

	If $readen_mode = "move" Then
		_Write_ISN_Debug_Console("|--> MODE: Move", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_Write_ISN_Debug_Console("|--> SOURCE: " & StringReplace($source, "\", "\\"), $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_Write_ISN_Debug_Console("|--> DESTINATION: " & StringReplace($target, "\", "\\"), $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_FileOperationProgress($source, $target, 1, $FO_MOVE, $flags)
		If @error Then
			_Write_ISN_Debug_Console("|--> RESULT: ERROR (Errorcode: " & @error & ", Extended: " & @extended & ")", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		Else
			_Write_ISN_Debug_Console("|--> RESULT: OK", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		EndIf
	EndIf

	If $readen_mode = "rename" Then
		If $target = "" Then Return
		If _IsDir($source) = True Then
			$new_Name = StringTrimRight($source, StringLen($source) - StringInStr($source, "\", 0, -1))
			$new_Name = $new_Name & $target
			_Write_ISN_Debug_Console("|--> MODE: Rename Dir", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			_Write_ISN_Debug_Console("|--> FROM: " & StringReplace($source, "\", "\\"), $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			_Write_ISN_Debug_Console("|--> TO: " & StringReplace($new_Name, "\", "\\"), $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			DirMove($source, $new_Name)
			If @error Then
				_Write_ISN_Debug_Console("|--> RESULT: ERROR (Errorcode: " & @error & ", Extended: " & @extended & ")", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			Else
				_Write_ISN_Debug_Console("|--> RESULT: OK", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			EndIf
		Else
			$new_Name = StringTrimRight($source, StringLen($source) - StringInStr($source, "\", 0, -1))
			$new_Name = $new_Name & $target
			_Write_ISN_Debug_Console("|--> MODE: Rename File", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			_Write_ISN_Debug_Console("|--> FROM: " & StringReplace($source, "\", "\\"), $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			_Write_ISN_Debug_Console("|--> TO: " & StringReplace($new_Name, "\", "\\"), $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			FileMove($source, $new_Name)
			If @error Then
				_Write_ISN_Debug_Console("|--> RESULT: ERROR (Errorcode: " & @error & ", Extended: " & @extended & ")", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			Else
				_Write_ISN_Debug_Console("|--> RESULT: OK", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
			EndIf
		EndIf
	EndIf

EndFunc   ;==>_Run_fileoperationrule

Func _Show_Config_Fileoperation($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	$Temp_ID_Holder = $ID
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_mode[" & $ID & "]", "copy")
	If $readen_mode = "copy" Then GUICtrlSetState($rule_fileoperations_radio_copy, $GUI_CHECKED)
	If $readen_mode = "move" Then GUICtrlSetState($rule_fileoperations_radio_move, $GUI_CHECKED)
	If $readen_mode = "delete" Then GUICtrlSetState($rule_fileoperations_radio_delete, $GUI_CHECKED)
	If $readen_mode = "rename" Then GUICtrlSetState($rule_fileoperations_radio_rename, $GUI_CHECKED)
	GUICtrlSetData($rule_fileoperations_input_quelle, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_source[" & $ID & "]", ""))
	GUICtrlSetData($rule_fileoperations_input_ziel, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_target[" & $ID & "]", ""))
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_mustconfirm[" & $ID & "]", "true")
	If $readen_mode = "true" Then
		GUICtrlSetState($rule_fileoperations_confirmcheckbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($rule_fileoperations_confirmcheckbox, $GUI_UNCHECKED)
	EndIf
	_Config_Fileoperation_set_radios()
	GUISetState(@SW_SHOW, $rule_fileoperation_configgui)
EndFunc   ;==>_Show_Config_Fileoperation

Func _Fileoperation_select_sourcefile()
	$var = FileOpenDialog(_Get_langstr(187), $Offenes_Projekt, "All (*.*)", 1 + 2, "", $rule_fileoperation_configgui)
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return
	$var = _ISN_Pfad_durch_Variablen_ersetzen($var)
	GUICtrlSetData($rule_fileoperations_input_quelle, $var)
EndFunc   ;==>_Fileoperation_select_sourcefile

Func _Fileoperation_select_sourcefolder()
	$res = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS, 0, 0, $rule_fileoperation_configgui)
	FileChangeDir(@ScriptDir)
	If @error Or $res = "" Then
		Return
	Else
		If $res = "" Then Return
		$res = _ISN_Pfad_durch_Variablen_ersetzen($res)
		GUICtrlSetData($rule_fileoperations_input_quelle, $res)
	EndIf
EndFunc   ;==>_Fileoperation_select_sourcefolder

Func _Fileoperation_select_targetfolder()
	$res = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS, 0, 0, $rule_fileoperation_configgui)
	FileChangeDir(@ScriptDir)
	If @error Or $res = "" Then
		Return
	Else
		If $res = "" Then Return
		$res = _ISN_Pfad_durch_Variablen_ersetzen($res)
		GUICtrlSetData($rule_fileoperations_input_ziel, $res)
	EndIf
EndFunc   ;==>_Fileoperation_select_targetfolder

Func _Config_Fileoperation_set_radios()

	GUICtrlSetState($rule_fileoperations_ziel_bt1, $GUI_ENABLE)
	GUICtrlSetState($rule_fileoperations_ziel_bt2, $GUI_ENABLE)
	GUICtrlSetState($rule_fileoperations_ziellabel, $GUI_ENABLE)
	GUICtrlSetState($rule_fileoperations_confirmcheckbox, $GUI_ENABLE)
	GUICtrlSetState($rule_fileoperations_input_ziel, $GUI_ENABLE)
	GUICtrlSetData($rule_fileoperations_ziellabel, _Get_langstr(583))

	If GUICtrlRead($rule_fileoperations_radio_delete) = $GUI_CHECKED Then
		GUICtrlSetState($rule_fileoperations_ziel_bt1, $GUI_DISABLE)
		GUICtrlSetState($rule_fileoperations_ziel_bt2, $GUI_DISABLE)
		GUICtrlSetState($rule_fileoperations_ziellabel, $GUI_DISABLE)
		GUICtrlSetState($rule_fileoperations_confirmcheckbox, $GUI_DISABLE)
		GUICtrlSetState($rule_fileoperations_input_ziel, $GUI_DISABLE)
		GUICtrlSetState($rule_fileoperations_confirmcheckbox, $GUI_UNCHECKED)
		GUICtrlSetData($rule_fileoperations_input_ziel, "")
	EndIf

	If GUICtrlRead($rule_fileoperations_radio_rename) = $GUI_CHECKED Then
		GUICtrlSetState($rule_fileoperations_ziel_bt1, $GUI_DISABLE)
		GUICtrlSetState($rule_fileoperations_ziel_bt2, $GUI_DISABLE)
		GUICtrlSetData($rule_fileoperations_ziellabel, _Get_langstr(599))
		GUICtrlSetState($rule_fileoperations_confirmcheckbox, $GUI_DISABLE)
		GUICtrlSetState($rule_fileoperations_confirmcheckbox, $GUI_UNCHECKED)
	EndIf

EndFunc   ;==>_Config_Fileoperation_set_radios

Func _Show_Extendedpaths()
	$Temp_Button_ID_HOLDER = @GUI_CtrlId
	GUICtrlSetData($choose_fileoperations_extendenpaths_Combolist, "")
	$def_wert = "%projectdir%"
	$Str = $Programmvariablen
	If $Temp_Button_ID_HOLDER = $projekteinstellungen_kompilieren_Ordnerpfad_button Then
		$Str = $Variablen_Ordnerstruktur
		$def_wert = "%projectname%"
	EndIf
	$tmp_array = StringSplit($Str, "|", 2)
	_ArraySort($tmp_array)
	$Str = _ArrayToString($tmp_array, "|")
	GUICtrlSetData($choose_fileoperations_extendenpaths_Combolist, $Str, $def_wert)
	_Select_Extendedpaths()
	GUISetState(@SW_SHOW, $choose_fileoperations_extendenpaths_GUI)
	GUISetState(@SW_HIDE, $rulecompileconfig_gui)
	GUISetState(@SW_HIDE, $rule_fileoperation_configgui)
	GUISetState(@SW_HIDE, $runfile_config)
	GUISetState(@SW_HIDE, $Projekteinstellungen_GUI)
EndFunc   ;==>_Show_Extendedpaths


Func _Select_Extendedpaths()
	$txt = GUICtrlRead($choose_fileoperations_extendenpaths_Combolist)
	Switch $txt

		Case "%projectdir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(578))

		Case "%compileddir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(579))

		Case "%isnstudiodir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(580))

		Case "%windowsdir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(581))

		Case "%tempdir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(586))

		Case "%desktopdir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(587))

		Case "%backupdir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(588))

		Case "%mydocumentsdir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(816))

		Case "%projectversion%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(977))

		Case "%filedir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(1048))

		Case "%lastcompiledfile_exe%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(1065))

		Case "%lastcompiledfile_source%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(1066))

		Case "%projectname%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, StringReplace(_Get_langstr(5), ":", ""))

		Case "%projectauthor%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, StringReplace(_Get_langstr(369), ":", ""))

		Case "%myisndatadir%"
			GUICtrlSetData($choose_fileoperations_extendenpaths_Combolabel, _Get_langstr(1125))


	EndSwitch
EndFunc   ;==>_Select_Extendedpaths

Func _hide_Extendedpaths()
	If $Temp_Button_ID_HOLDER = $rule_fileoperations_quelle_bt1 Then GUISetState(@SW_SHOW, $rule_fileoperation_configgui)
	If $Temp_Button_ID_HOLDER = $rule_fileoperations_ziel_bt2 Then GUISetState(@SW_SHOW, $rule_fileoperation_configgui)
	If $Temp_Button_ID_HOLDER = $rule_compile_choosedest Then GUISetState(@SW_SHOW, $rulecompileconfig_gui)
	If $Temp_Button_ID_HOLDER = $openfilerule_extended_paths Then GUISetState(@SW_SHOW, $runfile_config)
	If $Temp_Button_ID_HOLDER = $openfilemakro_extended_paths_Parameter Then GUISetState(@SW_SHOW, $runfile_config)
	If $Temp_Button_ID_HOLDER = $projekteinstellungen_kompilieren_Ordnerpfad_button Then GUISetState(@SW_SHOW, $Projekteinstellungen_GUI)
	If $Temp_Button_ID_HOLDER = $projekteinstellungen_temp_au3_ordner_button Then GUISetState(@SW_SHOW, $Projekteinstellungen_GUI)

	GUISetState(@SW_HIDE, $choose_fileoperations_extendenpaths_GUI)
EndFunc   ;==>_hide_Extendedpaths

Func _Extendedpaths_OK()
	If $Temp_Button_ID_HOLDER = $rule_fileoperations_quelle_bt1 Then GUICtrlSetData($rule_fileoperations_input_quelle, GUICtrlRead($rule_fileoperations_input_quelle) & GUICtrlRead($choose_fileoperations_extendenpaths_Combolist))
	If $Temp_Button_ID_HOLDER = $rule_fileoperations_ziel_bt2 Then GUICtrlSetData($rule_fileoperations_input_ziel, GUICtrlRead($rule_fileoperations_input_ziel) & GUICtrlRead($choose_fileoperations_extendenpaths_Combolist))
	If $Temp_Button_ID_HOLDER = $rule_compile_choosedest Then GUICtrlSetData($rule_compile_despathinput, GUICtrlRead($rule_compile_despathinput) & GUICtrlRead($choose_fileoperations_extendenpaths_Combolist))
	If $Temp_Button_ID_HOLDER = $openfilerule_extended_paths Then GUICtrlSetData($openfilerule_exeinput, GUICtrlRead($openfilerule_exeinput) & GUICtrlRead($choose_fileoperations_extendenpaths_Combolist))
	If $Temp_Button_ID_HOLDER = $openfilemakro_extended_paths_Parameter Then GUICtrlSetData($openfilerule_paraminput, GUICtrlRead($openfilerule_paraminput) & GUICtrlRead($choose_fileoperations_extendenpaths_Combolist))
	If $Temp_Button_ID_HOLDER = $projekteinstellungen_kompilieren_Ordnerpfad_button Then GUICtrlSetData($projekteinstellungen_kompilieren_Ordnerpfad_input, GUICtrlRead($projekteinstellungen_kompilieren_Ordnerpfad_input) & GUICtrlRead($choose_fileoperations_extendenpaths_Combolist))
	If $Temp_Button_ID_HOLDER = $projekteinstellungen_temp_au3_ordner_button Then GUICtrlSetData($projekteinstellungen_temp_au3_ordner_input, GUICtrlRead($projekteinstellungen_temp_au3_ordner_input) & GUICtrlRead($choose_fileoperations_extendenpaths_Combolist))
	_hide_Extendedpaths()
EndFunc   ;==>_Extendedpaths_OK

Func _Save_Config_Fileoperation()
	If GUICtrlRead($rule_fileoperations_input_quelle) = "" Then
		_Input_Error_FX($rule_fileoperations_input_quelle)
		Return
	EndIf

	If GUICtrlRead($rule_fileoperations_input_ziel) = "" And GUICtrlRead($rule_fileoperations_radio_copy) = $GUI_CHECKED Then
		_Input_Error_FX($rule_fileoperations_input_ziel)
		Return
	EndIf

	If GUICtrlRead($rule_fileoperations_input_ziel) = "" And GUICtrlRead($rule_fileoperations_radio_move) = $GUI_CHECKED Then
		_Input_Error_FX($rule_fileoperations_input_ziel)
		Return
	EndIf

	If GUICtrlRead($rule_fileoperations_input_ziel) = "" And GUICtrlRead($rule_fileoperations_radio_rename) = $GUI_CHECKED Then
		_Input_Error_FX($rule_fileoperations_input_ziel)
		Return
	EndIf

	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action4 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action4 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	If GUICtrlRead($rule_fileoperations_radio_copy) = $GUI_CHECKED Then $readen_mode = "copy"
	If GUICtrlRead($rule_fileoperations_radio_move) = $GUI_CHECKED Then $readen_mode = "move"
	If GUICtrlRead($rule_fileoperations_radio_delete) = $GUI_CHECKED Then $readen_mode = "delete"
	If GUICtrlRead($rule_fileoperations_radio_rename) = $GUI_CHECKED Then $readen_mode = "rename"
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_mode[" & $Temp_ID_Holder & "]", $readen_mode)

	;Verwende Automatisch Platzhalter wenn möglich
	$quelle = GUICtrlRead($rule_fileoperations_input_quelle)
	$quelle = _ISN_Pfad_durch_Variablen_ersetzen($quelle)
	If StringInStr($quelle, "%filedir%") Then $quelle = StringReplace($quelle, "%filedir%", "") ;Filedir darf bei Quellenangaben nicht verwendet werden!

	$ziel = GUICtrlRead($rule_fileoperations_input_ziel)
	$ziel = _ISN_Pfad_durch_Variablen_ersetzen($ziel)


	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_source[" & $Temp_ID_Holder & "]", $quelle)
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_target[" & $Temp_ID_Holder & "]", $ziel)
	If GUICtrlRead($rule_fileoperations_confirmcheckbox) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "fileoperation_mustconfirm[" & $Temp_ID_Holder & "]", $readen_mode)
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $rule_fileoperation_configgui)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_Fileoperation

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_openfilerule($ruleID, $ID)
	$run_flags = 0
	If IniRead($Pfad_zur_Project_ISN, $ruleID, "file_runhidewindow[" & $ID & "]", "false") = "false" Then
		$run_flags = @SW_SHOW
	Else
		$run_flags = @SW_HIDE
	EndIf

	$File_to_run = IniRead($Pfad_zur_Project_ISN, $ruleID, "file_runpath[" & $ID & "]", "")
	$File_to_run = _ISN_Variablen_aufloesen($File_to_run)

	$Parameter = _IniReadRaw($Pfad_zur_Project_ISN, $ruleID, "file_runparam[" & $ID & "]", "")
	$Parameter = _ISN_Variablen_aufloesen($Parameter)
	If IniRead($Pfad_zur_Project_ISN, $ruleID, "file_executeparameter[" & $ID & "]", "false") = "true" Then
		$Parameter = Execute($Parameter)
	EndIf

	If IniRead($Pfad_zur_Project_ISN, $ruleID, "file_runwait[" & $ID & "]", "false") = "false" Then
		ShellExecute(_ISN_Variablen_aufloesen($File_to_run), _ISN_Variablen_aufloesen($Parameter), "", "", $run_flags)
	Else
		GUISetState(@SW_SHOW, $warte_auf_Makro_GUI)
		GUISetState(@SW_DISABLE, $Studiofenster)
		ShellExecuteWait(_ISN_Variablen_aufloesen($File_to_run), _ISN_Variablen_aufloesen($Parameter), "", "", $run_flags)
		GUISetState(@SW_ENABLE, $Studiofenster)
		GUISetState(@SW_HIDE, $warte_auf_Makro_GUI)
	EndIf
EndFunc   ;==>_Run_openfilerule

Func _Show_Config_Runfile($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	GUICtrlSetData($openfilerule_exeinput, _IniReadRaw($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_runpath[" & $ID & "]", ""))
	GUICtrlSetData($openfilerule_paraminput, _IniReadRaw($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_runparam[" & $ID & "]", ""))
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_runwait[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($openfilerule_waitcheckbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($openfilerule_waitcheckbox, $GUI_UNCHECKED)
	EndIf

	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_executeparameter[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($openfilemakro_parameterexecutecheckbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($openfilemakro_parameterexecutecheckbox, $GUI_UNCHECKED)
	EndIf

	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_runhidewindow[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($openfilerule_hidewindowcheckbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($openfilerule_hidewindowcheckbox, $GUI_UNCHECKED)
	EndIf
	$Temp_ID_Holder = $ID
	GUISetState(@SW_SHOW, $runfile_config)
EndFunc   ;==>_Show_Config_Runfile

Func _Save_Config_Runfile()
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action5 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action5 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	$Parameter = GUICtrlRead($openfilerule_paraminput)

	$Exe_Input = GUICtrlRead($openfilerule_exeinput)
	If StringInStr($Exe_Input, "%filedir%") Then $Exe_Input = StringReplace($Exe_Input, "%filedir%", "") ;Filedir darf bei Quellenangaben nicht verwendet werden!
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_runpath[" & $Temp_ID_Holder & "]", $Exe_Input)


	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_runparam[" & $Temp_ID_Holder & "]", $Parameter)
	If GUICtrlRead($openfilerule_waitcheckbox) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_runwait[" & $Temp_ID_Holder & "]", $readen_mode)

	If GUICtrlRead($openfilemakro_parameterexecutecheckbox) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_executeparameter[" & $Temp_ID_Holder & "]", $readen_mode)

	If GUICtrlRead($openfilerule_hidewindowcheckbox) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "file_runhidewindow[" & $Temp_ID_Holder & "]", $readen_mode)
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $runfile_config)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_Runfile

Func _Config_Runfileselect_file()
	$var = FileOpenDialog(_Get_langstr(187), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All (*.*)", 1 + 2 + 4, "", $runfile_config)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	If @error Then
		Return
	Else
		$var = _ISN_Pfad_durch_Variablen_ersetzen($var)
		GUICtrlSetData($openfilerule_exeinput, $var)
	EndIf
EndFunc   ;==>_Config_Runfileselect_file

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Show_Config_compilefile($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)

	;compression
	$readen_compress = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_compression[" & $ID & "]", "normal")
	If $readen_compress = "lowest" Then $tmp = _Get_langstr(565)
	If $readen_compress = "low" Then $tmp = _Get_langstr(566)
	If $readen_compress = "normal" Then $tmp = _Get_langstr(567)
	If $readen_compress = "high" Then $tmp = _Get_langstr(568)
	If $readen_compress = "highest" Then $tmp = _Get_langstr(569)
	GUICtrlSetData($Compile_rulecompressioncombo, "")
	GUICtrlSetData($Compile_rulecompressioncombo, _Get_langstr(569) & "|" & _Get_langstr(568) & "|" & _Get_langstr(567) & "|" & _Get_langstr(566) & "|" & _Get_langstr(565), $tmp)

	;inputfile
	GUICtrlSetData($compile_rule_inputfile, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_inputfile[" & $ID & "]", ""))

	;icon
	GUICtrlSetData($Compile_ruleIconpath, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_exeicon[" & $ID & "]", "%isnstudiodir%\autoitstudioicon.ico"))
	_SetImage($Compile_rulevorschauicon, _ISN_Variablen_aufloesen(GUICtrlRead($Compile_ruleIconpath)))

	;exename
	GUICtrlSetData($rule_compile_exename, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_exename[" & $ID & "]", ""))

	;despath
	GUICtrlSetData($rule_compile_despathinput, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_destination[" & $ID & "]", "%filedir%"))

	;upx
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_useupx[" & $ID & "]", "true")
	If $readen_mode = "true" Then
		GUICtrlSetState($Compile_ruleupx_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Compile_ruleupx_checkbox, $GUI_UNCHECKED)
	EndIf

	;x64
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_x64[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($compile_rulex64_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_rulex64_checkbox, $GUI_UNCHECKED)
	EndIf

	;openfolder
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_openaftercompile[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($compile_ruleopenfolder_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_ruleopenfolder_checkbox, $GUI_UNCHECKED)
	EndIf

	;console
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_console[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($compile_rulechckboxconsole, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_rulechckboxconsole, $GUI_UNCHECKED)
	EndIf

	$Temp_ID_Holder = $ID
	GUISetState(@SW_SHOW, $rulecompileconfig_gui)
EndFunc   ;==>_Show_Config_compilefile

Func _Save_Config_compilefile()
	If GUICtrlRead($compile_rule_inputfile) = "" Then
		_Input_Error_FX($compile_rule_inputfile)
		Return
	EndIf

	If GUICtrlRead($rule_compile_despathinput) = "" Then
		_Input_Error_FX($rule_compile_despathinput)
		Return
	EndIf

	If GUICtrlRead($rule_compile_exename) = "" Then
		_Input_Error_FX($rule_compile_exename)
		Return
	EndIf

	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action6 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action6 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf

	$Inputfile = GUICtrlRead($compile_rule_inputfile)
	If StringInStr($Inputfile, "%filedir%") Then $Inputfile = StringReplace($Inputfile, "%filedir%", "") ;Filedir darf bei Quellenangaben nicht verwendet werden!
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_inputfile[" & $Temp_ID_Holder & "]", $Inputfile)
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_exeicon[" & $Temp_ID_Holder & "]", GUICtrlRead($Compile_ruleIconpath))
	$exename = GUICtrlRead($rule_compile_exename)
	$exename = StringReplace($exename, "?", "")
	$exename = StringReplace($exename, "=", "")
	$exename = StringReplace($exename, ",", "")
	$exename = StringReplace($exename, "*", "")
	$exename = StringReplace($exename, "\", "")
	$exename = StringReplace($exename, "/", "")
	$exename = StringReplace($exename, '"', "")
	$exename = StringReplace($exename, "<", "")
	$exename = StringReplace($exename, ">", "")
	$exename = StringReplace($exename, "|", "")
	If Not StringInStr($exename, ".exe") Then $exename = $exename & ".exe"
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_exename[" & $Temp_ID_Holder & "]", $exename)
	$target = GUICtrlRead($rule_compile_despathinput)
	If StringRight($target, 1) = "\" Then $target = StringTrimRight($target, 1)
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_destination[" & $Temp_ID_Holder & "]", $target)
	$tmp = GUICtrlRead($Compile_rulecompressioncombo)
	If $tmp = _Get_langstr(565) Then $readen_compress = "lowest"
	If $tmp = _Get_langstr(566) Then $readen_compress = "low"
	If $tmp = _Get_langstr(567) Then $readen_compress = "normal"
	If $tmp = _Get_langstr(568) Then $readen_compress = "high"
	If $tmp = _Get_langstr(569) Then $readen_compress = "highest"
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_compression[" & $Temp_ID_Holder & "]", $readen_compress)
	;upx
	If GUICtrlRead($Compile_ruleupx_checkbox) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_useupx[" & $Temp_ID_Holder & "]", $readen_mode)

	;x64
	If GUICtrlRead($compile_rulex64_checkbox) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_x64[" & $Temp_ID_Holder & "]", $readen_mode)

	;openfolder
	If GUICtrlRead($compile_ruleopenfolder_checkbox) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_openaftercompile[" & $Temp_ID_Holder & "]", $readen_mode)

	;console
	If GUICtrlRead($compile_rulechckboxconsole) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "compile_console[" & $Temp_ID_Holder & "]", $readen_mode)
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $rulecompileconfig_gui)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_compilefile

Func _compilerule_select_sourcefile()
	$var = FileOpenDialog(_Get_langstr(187), $Offenes_Projekt, "AutoIt 3 Script (*.au3)", 1 + 2, "", $rulecompileconfig_gui)
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return

	Dim $szDrive, $szDir, $szFName, $szExt
	$path = _PathSplit($var, $szDrive, $szDir, $szFName, $szExt)
	GUICtrlSetData($rule_compile_exename, $szFName & ".exe")

	$var = _ISN_Pfad_durch_Variablen_ersetzen($var)
	GUICtrlSetData($compile_rule_inputfile, $var)

EndFunc   ;==>_compilerule_select_sourcefile

Func _compilerule_select_iconfile()
	$var = FileOpenDialog(_Get_langstr(187), $Offenes_Projekt, "Icons (*.ico)", 1 + 2, "", $rulecompileconfig_gui)
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return
	_SetImage($Compile_rulevorschauicon, $var)
	$var = _ISN_Pfad_durch_Variablen_ersetzen($var)
	GUICtrlSetData($Compile_ruleIconpath, $var)
EndFunc   ;==>_compilerule_select_iconfile






Func _Run_compilefilerule($ruleID, $ID)
	If Not FileExists(_ISN_Variablen_aufloesen(IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_exeicon[" & $ID & "]", @ScriptDir & "\autoitstudioicon.ico"))) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(664), 0, $studiofenster)
		Return
	EndIf

	If Not FileExists($AutoIt3Wrapper_exe_path) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1032), 0, $studiofenster)
		Return
	EndIf


	GUISetState(@SW_DISABLE, $studiofenster)
	GUISetState(@SW_SHOW, $compilingRule)

	$source = IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_inputfile[" & $ID & "]", "")
	$source = _ISN_Variablen_aufloesen($source) ;Elemente wie %projectdir% auflösen



	$target = IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_destination[" & $ID & "]", "")
	$target = _ISN_Variablen_aufloesen($target, $source) ;Elemente wie %projectdir% auflösen

	;Prüfe ob datei geöffnet ist und speichere diese vor dem Kompilieren
	$alreadyopen = _GUICtrlTab_FindTab($hTab, StringTrimLeft($source, StringInStr($source, "\", 0, -1)))
	If $alreadyopen <> -1 Then
		$res = _ArraySearch($Datei_pfad, $source)
		If $res <> -1 Then
			If BitAND(_GUICtrlTab_GetItemState($htab, $res), $TCIS_HIGHLIGHTED) Then _try_to_save_file($res) ;Nur Speichern wenn in der Datei auch was geändert wurde (Neu seit version 1.03)
		EndIf
	EndIf

   ;Dateiinhalt vor dem Kompilieren einlesen (sichern)
	Local $hFile = FileOpen($source, $FO_READ + FileGetEncoding($source))
	Local  $Dateiinhalt_vor_dem_Kompilieren = FileRead($hFile, FileGetSize($source))
	FileClose($hFile)
	if not _System_benoetigt_double_byte_character_Support() Then $Dateiinhalt_vor_dem_Kompilieren = _ANSI2UNICODE($Dateiinhalt_vor_dem_Kompilieren)



	$exename = IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_exename[" & $ID & "]", "")
	$exename = StringReplace($exename, "?", "")
	$exename = StringReplace($exename, "=", "")
	$exename = StringReplace($exename, ",", "")
	$exename = StringReplace($exename, "\", "")
	$exename = StringReplace($exename, "/", "")
	$exename = StringReplace($exename, '"', "")
	$exename = StringReplace($exename, "<", "")
	$exename = StringReplace($exename, ">", "")
	$exename = StringReplace($exename, "|", "")
	_Clear_Debuglog()
;~ 	$Console_Bluemode = 1

	$Adittional_Prams = ""
	If IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_x64[" & $ID & "]", "false") = "true" Then $Adittional_Prams = $Adittional_Prams & "/x64 "
	If IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_useupx[" & $ID & "]", "true") = "false" Then $Adittional_Prams = $Adittional_Prams & "/nopack "
	If IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_console[" & $ID & "]", "false") = "true" Then $Adittional_Prams = $Adittional_Prams & "/console "
	$readen_compress = IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_compression[" & $ID & "]", "normal")
	If $readen_compress = "lowest" Then $Adittional_Prams = $Adittional_Prams & "/comp 0 "
	If $readen_compress = "low" Then $Adittional_Prams = $Adittional_Prams & "/comp 1 "
	If $readen_compress = "normal" Then $Adittional_Prams = $Adittional_Prams & "/comp 2 "
	If $readen_compress = "high" Then $Adittional_Prams = $Adittional_Prams & "/comp 3 "
	If $readen_compress = "highest" Then $Adittional_Prams = $Adittional_Prams & "/comp 4 "

	If StringRight($target, 1) = "\" Then $target = StringTrimRight($target, 1)
	If StringRight($source, 1) = "\" Then $source = StringTrimRight($source, 1)
	$fertiger_zielpfad = $target & "\" & $exename
;~ 	$source = StringReplace($source, "\\", "\")
;~ 	$target = StringReplace($target, "\\", "\")


	GUICtrlSetData($rulecompile_label1, _Get_langstr(602) & " " & $source)
	$Pfadaenderung_durch_Wrapper = _Kompilieren_Datei_Analysieren_und_Zielpfade_herausfinden($source)
	If $Pfadaenderung_durch_Wrapper <> "" Then $fertiger_zielpfad = $Pfadaenderung_durch_Wrapper
	GUICtrlSetData($rulecompile_label2, _Get_langstr(583) & " " & $fertiger_zielpfad)
	DirCreate($target)
	$Iconfilepath = IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_exeicon[" & $ID & "]", "%isnstudiodir%\autoitstudioicon.ico")
	$Iconfilepath = _ISN_Variablen_aufloesen($Iconfilepath, $source)

	$Zuletzt_Kompilierte_Datei_Pfad_au3 = $source ;Dateipfad der zuletzt kompilierten Datei (.au3 Datei)

	$data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /in "' & $source & '" /out "' & $target & "\" & $exename & '" ' & $Adittional_Prams & ' /icon "' & $Iconfilepath & '"', 0, $Offenes_Projekt, @SW_HIDE, 1)
	Dim $szDrive, $szDir, $szFName, $szExt
	$path = _PathSplit($source, $szDrive, $szDir, $szFName, $szExt)
	If FileExists($szDrive & $szDir & $szFName & "_Obfuscated" & $szExt) Then FileDelete(FileGetShortName($szDrive & $szDir & $szFName) & "_Obfuscated" & $szExt)
	If FileExists($szDrive & $szDir & $szFName & "_stripped" & $szExt) Then FileDelete(FileGetShortName($szDrive & $szDir & $szFName) & "_stripped" & $szExt)
	If FileExists($szDrive & $szDir & _GetShortName($szFName) & "_Obfuscated" & $szExt) Then FileDelete($szDrive & $szDir & _GetShortName($szFName) & "_Obfuscated" & $szExt)
	If FileExists($szDrive & $szDir & _GetShortName($szFName) & "_stripped" & $szExt) Then FileDelete($szDrive & $szDir & _GetShortName($szFName) & "_stripped" & $szExt)
	If FileExists($szDrive & $szDir & $szFName & ".tbl") Then FileDelete(FileGetShortName($szDrive & $szDir & $szFName) & ".tbl")
	If FileExists($szDrive & $szDir & _GetShortName($szFName) & ".tbl") Then FileDelete($szDrive & $szDir & _GetShortName($szFName) & ".tbl")
;~ 	$Console_Bluemode = 0
	$Zuletzt_Kompilierte_Datei_Pfad_exe = $target & "\" & $exename ;Dateipfad der zuletzt kompilierten Datei (.exe Datei)

	;Exit Codes Analysieren und ggf. Änderungen vornehmen
	If IsArray($data) Then
		If $data[1] <> 0 Then
			$result = MsgBox(262196, _Get_langstr(394), StringReplace(_Get_langstr(1138), "%1", $szFName & $szExt) & @CRLF & @CRLF & _Get_langstr(1139), 0, $compilingRule)
			If $result = 7 Then $Regel_lauft = 0 ;Stoppe weitere ausführung
		EndIf
	EndIf


	If _Pruefe_ob_Datei_geoeffnet($source) = "true" Then ;Lese Datei neu ein (falls geöffnet)

	   	;Dateiinhalt nach dem Kompilieren einlesen, und falls sich etwas verändert hat -> Datei neu einlesen
	Local $hFile = FileOpen($source, $FO_READ + FileGetEncoding($source))
	Local  $Dateiinhalt_nach_dem_Kompilieren = FileRead($hFile, FileGetSize($source))
	FileClose($hFile)
	if not _System_benoetigt_double_byte_character_Support() Then $Dateiinhalt_nach_dem_Kompilieren = _ANSI2UNICODE($Dateiinhalt_nach_dem_Kompilieren)

	 if $Dateiinhalt_nach_dem_Kompilieren <> $Dateiinhalt_vor_dem_Kompilieren then
		$tabpage = _GUICtrlTab_FindTab($hTab, StringTrimLeft($source, StringInStr($source, "\", 0, -1)))
		$old_cur_pos = Sci_GetCurrentPos($SCE_EDITOR[$tabpage])
		LoadEditorFile($SCE_EDITOR[$tabpage], $source)
		$FILE_CACHE[$tabpage] = Sci_GetLines($SCE_EDITOR[$tabpage])
		_Editor_Restore_Fold()
		Sci_SetCurrentPos($SCE_EDITOR[$tabpage], $old_cur_pos)
   endif
	EndIf

	GUISetState(@SW_ENABLE, $studiofenster)
	GUISetState(@SW_HIDE, $compilingRule)

	If IniRead($Pfad_zur_Project_ISN, $ruleID, "compile_openaftercompile[" & $ID & "]", "false") = "true" Then ShellExecute("explorer.exe", FileGetShortName($target))


EndFunc   ;==>_Run_compilefilerule

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_closeprojectRule($ruleID, $ID)
	_Close_Project()
EndFunc   ;==>_Run_closeprojectRule

Func _Save_Config_closeproject()
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action7 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action7 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	Else
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(549), 0, $newrule_GUI)
	EndIf
	GUISetState(@SW_ENABLE, $newrule_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_closeproject

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Show_Config_openexternalfile($ID)
	$var = FileOpenDialog(_Get_langstr(187), $Offenes_Projekt, "All (*.*)", 1 + 2 + 4, "", $newrule_GUI)
	FileChangeDir(@ScriptDir)
	If @error Then
		_cancel_any_config()
		Return
	EndIf
	If $var = "" Then
		_cancel_any_config()
		Return
	EndIf
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action8 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action8 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf

	$var = _ISN_Pfad_durch_Variablen_ersetzen($var)
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "open_externalfile[" & $Temp_ID_Holder & "]", $var)
	GUISetState(@SW_ENABLE, $newrule_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Show_Config_openexternalfile

Func _Run_openexternalfilerule($ruleID, $ID)
	$var = _ISN_Variablen_aufloesen(IniRead($Pfad_zur_Project_ISN, $ruleID, "open_externalfile[" & $ID & "]", ""))
	Try_to_opten_file($var)
EndFunc   ;==>_Run_openexternalfilerule

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_msgboxrule($ruleID, $ID)
	$titel = IniRead($Pfad_zur_Project_ISN, $ruleID, "msgbox_title[" & $ID & "]", "")
	$text = IniRead($Pfad_zur_Project_ISN, $ruleID, "msgbox_text[" & $ID & "]", "")
	$timeout = IniRead($Pfad_zur_Project_ISN, $ruleID, "msgbox_timeout[" & $ID & "]", "0")
	$text = StringReplace($text, "[BREAK]", @CRLF)
	$flags = 0
	$icon = IniRead($Pfad_zur_Project_ISN, $ruleID, "msgbox_icon[" & $ID & "]", 0)
	If $icon = 0 Then $flags = $flags + 0
	If $icon = 1 Then $flags = $flags + 16
	If $icon = 2 Then $flags = $flags + 48
	If $icon = 3 Then $flags = $flags + 64
	If $icon = 4 Then $flags = $flags + 32
	If IniRead($Pfad_zur_Project_ISN, $ruleID, "msgbox_ontop[" & $ID & "]", "") = "true" Then $flags = $flags + 262144
	If IniRead($Pfad_zur_Project_ISN, $ruleID, "msgbox_textright[" & $ID & "]", "") = "true" Then $flags = $flags + 524288
	If IniRead($Pfad_zur_Project_ISN, $ruleID, "msgbox_hasicon[" & $ID & "]", "") = "true" Then $flags = $flags + 4096
	MsgBox($flags, _ISN_Variablen_aufloesen($titel), _ISN_Variablen_aufloesen($text), $timeout, $Studiofenster)
EndFunc   ;==>_Run_msgboxrule

Func _Save_Config_msgboxrule()

	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action9 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action9 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_timeout[" & $Temp_ID_Holder & "]", GUICtrlRead($msgbox_creatorrule_timeout))
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_title[" & $Temp_ID_Holder & "]", GUICtrlRead($msgbox_creatorrule_title))
	$text = GUICtrlRead($msgbox_creatorrule_edit)
	$text = StringReplace($text, @CRLF, "[BREAK]")
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_text[" & $Temp_ID_Holder & "]", $text)

	$flags = 0
	If GUICtrlRead($msgbox_creatorrule_icon1) = $GUI_CHECKED Then $flags = 0
	If GUICtrlRead($msgbox_creatorrule_icon2) = $GUI_CHECKED Then $flags = 1
	If GUICtrlRead($msgbox_creatorrule_icon3) = $GUI_CHECKED Then $flags = 2
	If GUICtrlRead($msgbox_creatorrule_icon4) = $GUI_CHECKED Then $flags = 3
	If GUICtrlRead($msgbox_creatorrule_icon5) = $GUI_CHECKED Then $flags = 4
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_icon[" & $Temp_ID_Holder & "]", $flags)

	;vordergrund
	If GUICtrlRead($msgbox_creatorrule_voreground) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_ontop[" & $Temp_ID_Holder & "]", $readen_mode)

	;text rechts
	If GUICtrlRead($msgbox_creatorrule_rechts) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_textright[" & $Temp_ID_Holder & "]", $readen_mode)

	;text rechts
	If GUICtrlRead($msgbox_creatorrule_hasicon) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_hasicon[" & $Temp_ID_Holder & "]", $readen_mode)

	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $msgboxcreator_rule)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_msgboxrule

Func _Show_Config_msgboxrule($ID)
	GUICtrlSetData($msgbox_creatorrule_timeout, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_timeout[" & $ID & "]", "0"))
	GUICtrlSetData($msgbox_creatorrule_title, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_title[" & $ID & "]", ""))
	$text = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_text[" & $ID & "]", "")
	$text = StringReplace($text, "[BREAK]", @CRLF)
	GUICtrlSetData($msgbox_creatorrule_edit, $text)

	$ico = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_icon[" & $ID & "]", 0)
	GUICtrlSetState($msgbox_creatorrule_icon1, $GUI_UNCHECKED)
	GUICtrlSetState($msgbox_creatorrule_icon2, $GUI_UNCHECKED)
	GUICtrlSetState($msgbox_creatorrule_icon3, $GUI_UNCHECKED)
	GUICtrlSetState($msgbox_creatorrule_icon4, $GUI_UNCHECKED)
	GUICtrlSetState($msgbox_creatorrule_icon5, $GUI_UNCHECKED)
	If $ico = 0 Then GUICtrlSetState($msgbox_creatorrule_icon1, $GUI_CHECKED)
	If $ico = 1 Then GUICtrlSetState($msgbox_creatorrule_icon2, $GUI_CHECKED)
	If $ico = 2 Then GUICtrlSetState($msgbox_creatorrule_icon3, $GUI_CHECKED)
	If $ico = 3 Then GUICtrlSetState($msgbox_creatorrule_icon4, $GUI_CHECKED)
	If $ico = 4 Then GUICtrlSetState($msgbox_creatorrule_icon5, $GUI_CHECKED)

	;vordergrund
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_ontop[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($msgbox_creatorrule_voreground, $GUI_CHECKED)
	Else
		GUICtrlSetState($msgbox_creatorrule_voreground, $GUI_UNCHECKED)
	EndIf

	;text rechts
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_textright[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($msgbox_creatorrule_rechts, $GUI_CHECKED)
	Else
		GUICtrlSetState($msgbox_creatorrule_rechts, $GUI_UNCHECKED)
	EndIf

	;icon
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "msgbox_hasicon[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($msgbox_creatorrule_hasicon, $GUI_CHECKED)
	Else
		GUICtrlSetState($msgbox_creatorrule_hasicon, $GUI_UNCHECKED)
	EndIf

	GUISetState(@SW_DISABLE, $newrule_GUI)
	GUISetState(@SW_SHOW, $msgboxcreator_rule)
EndFunc   ;==>_Show_Config_msgboxrule

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_executecommandrule($ruleID, $ID)
	Execute(_ISN_Variablen_aufloesen(IniRead($Pfad_zur_Project_ISN, $ruleID, "command[" & $ID & "]", "")))
EndFunc   ;==>_Run_executecommandrule

Func _Show_Config_executecommand($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	GUICtrlSetData($ExecuteCommandRuleConfig_GUI_input, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "command[" & $ID & "]", ""))
	$Temp_ID_Holder = $ID
	GUISetState(@SW_SHOW, $ExecuteCommandRuleConfig_GUI)
EndFunc   ;==>_Show_Config_executecommand

Func _Save_Config_executecommand()
	If GUICtrlRead($ExecuteCommandRuleConfig_GUI_input) = "" Then
		_Input_Error_FX($ExecuteCommandRuleConfig_GUI_input)
		Return
	EndIf
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action10 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action10 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "command[" & $Temp_ID_Holder & "]", GUICtrlRead($ExecuteCommandRuleConfig_GUI_input))
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $ExecuteCommandRuleConfig_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_executecommand

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_setstartparamsrule($ruleID, $ID)
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "testparam", _ISN_Variablen_aufloesen(_IniReadRaw($Pfad_zur_Project_ISN, $ruleID, "params[" & $ID & "]", "")))
EndFunc   ;==>_Run_setstartparamsrule

Func _Show_Config_setstartparams($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	GUICtrlSetData($startparameter_input_makro, StringReplace(_IniReadRaw($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "params[" & $ID & "]", ""), "#BREAK#", @CRLF))
	$Temp_ID_Holder = $ID
	GUISetState(@SW_SHOW, $parameter_GUI_rule)
	_GUICtrlEdit_SetSel($startparameter_input_makro, -1, -1)
EndFunc   ;==>_Show_Config_setstartparams

Func _Save_Config_setstartparams()
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action11 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action11 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "params[" & $Temp_ID_Holder & "]", StringReplace(GUICtrlRead($startparameter_input_makro), @CRLF, "#BREAK#"))
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $parameter_GUI_rule)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_setstartparams

;-----------------------------------------------------------------------------------------------------------------------------------------


Func _Run_addlogrule($ruleID, $ID)
	_Write_log(_ISN_Variablen_aufloesen(StringReplace(IniRead($Pfad_zur_Project_ISN, $ruleID, "text[" & $ID & "]", ""), "#BREAK#", @CRLF)), StringTrimLeft(IniRead($Pfad_zur_Project_ISN, $ruleID, "text_colour[" & $ID & "]", "0x000000"), 2), IniRead($Pfad_zur_Project_ISN, $ruleID, "text_big[" & $ID & "]", "false"), IniRead($Pfad_zur_Project_ISN, $ruleID, "text_notime[" & $ID & "]", "false"))
EndFunc   ;==>_Run_addlogrule

Func _Show_Config_addlog($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)

	;uhrzeit
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "text_notime[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($addlog_checkbox_uhrzeit, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($addlog_checkbox_uhrzeit, $GUI_CHECKED)
	EndIf

	;fett
	$readen_mode = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "text_big[" & $ID & "]", "false")
	If $readen_mode = "true" Then
		GUICtrlSetState($addlog_checkbox_fett, $GUI_CHECKED)
	Else
		GUICtrlSetState($addlog_checkbox_fett, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($addlog_textfeld, StringReplace(IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "text[" & $ID & "]", ""), "#BREAK#", @CRLF))
	GUICtrlSetData($addlog_input_farbe, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "text_colour[" & $ID & "]", "0x000000"))
	GUICtrlSetColor($addlog_input_farbe, _ColourInvert(Execute(GUICtrlRead($addlog_input_farbe))))
	GUICtrlSetBkColor($addlog_input_farbe, GUICtrlRead($addlog_input_farbe))
	GUICtrlSetState($addlog_textfeld, $GUI_FOCUS)
	$Temp_ID_Holder = $ID
	GUISetState(@SW_SHOW, $addlog_GUI)
EndFunc   ;==>_Show_Config_addlog

Func _Save_Config_addlog()
	If GUICtrlRead($addlog_textfeld) = "" Then
		_Input_Error_FX($addlog_textfeld)
		Return
	EndIf

	If GUICtrlRead($addlog_input_farbe) = "" Then
		_Input_Error_FX($addlog_input_farbe)
		Return
	EndIf

	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action12 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action12 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf


	;Uhrzeit
	If GUICtrlRead($addlog_checkbox_uhrzeit) = $GUI_CHECKED Then
		$readen_mode = "false"
	Else
		$readen_mode = "true"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "text_notime[" & $Temp_ID_Holder & "]", $readen_mode)

	;Fett
	If GUICtrlRead($addlog_checkbox_fett) = $GUI_CHECKED Then
		$readen_mode = "true"
	Else
		$readen_mode = "false"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "text_big[" & $Temp_ID_Holder & "]", $readen_mode)

	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "text_colour[" & $Temp_ID_Holder & "]", GUICtrlRead($addlog_input_farbe))
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "text[" & $Temp_ID_Holder & "]", StringReplace(GUICtrlRead($addlog_textfeld), @CRLF, "#BREAK#"))
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $addlog_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_addlog

Func _Choose_colour_addlogrule()
	$res = _ChooseColor(2, GUICtrlRead($addlog_input_farbe), 2, $addlog_GUI)
	If $res = -1 Then Return
	GUICtrlSetData($addlog_input_farbe, $res)
	GUICtrlSetColor($addlog_input_farbe, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($addlog_input_farbe, $res)
EndFunc   ;==>_Choose_colour_addlogrule

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_Makro_Backup($ruleID, $ID)
	_Backup_Files()
EndFunc   ;==>_Run_Makro_Backup

Func _Save_Config_Backup()
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action13 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action13 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	Else
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(549), 0, $newrule_GUI)
	EndIf
	GUISetState(@SW_ENABLE, $newrule_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_Backup

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Show_Config_Codeausschnitt($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	SendMessageString($Makro_Codeausschnitt_GUI_scintilla, $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessageString($Makro_Codeausschnitt_GUI_scintilla, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessageString($Makro_Codeausschnitt_GUI_scintilla, $SCI_SETSAVEPOINT, 0, 0)
	$Gelesener_Code = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "code[" & $ID & "]", "")
	$Gelesener_Code = StringReplace($Gelesener_Code, "[BREAK]", @CRLF)
	SCI_SetText($Makro_Codeausschnitt_GUI_scintilla, $Gelesener_Code)
	GUISetState(@SW_SHOW, $Makro_Codeausschnitt_GUI)
EndFunc   ;==>_Show_Config_Codeausschnitt

Func _Run_codeausschnitt_einfuegen_macro($ruleID, $ID)
	$Gelesener_codestring = _IniReadRaw($Pfad_zur_Project_ISN, $ruleID, "code[" & $ID & "]", "")
	If $Gelesener_codestring = "" Then Return
	$Gelesener_codestring = _ISN_Variablen_aufloesen($Gelesener_codestring)
	$Gelesener_codestring = StringReplace($Gelesener_codestring, "[BREAK]", @CRLF)
	If _GUICtrlTab_GetItemCount($hTab) > 0 Then
		If $Plugin_Handle[_GUICtrlTab_GetCurFocus($hTab)] = -1 Then
			Sci_InsertText($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)]), $Gelesener_codestring)
			_Check_Buttons(0)
		EndIf
	EndIf
EndFunc   ;==>_Run_codeausschnitt_einfuegen_macro

Func _Makro_Codeausschnitt_GUI_Resize()
	Local $Makro_Codeausschnitt_clientsize = WinGetClientSize($Makro_Codeausschnitt_GUI)
	If IsArray($Makro_Codeausschnitt_clientsize) Then WinMove($Makro_Codeausschnitt_GUI_scintilla, "", 10 * $DPI, 76 * $DPI, $Makro_Codeausschnitt_clientsize[0] - ((12 + 10) * $DPI), $Makro_Codeausschnitt_clientsize[1] - ((60 + 76) * $DPI))
EndFunc   ;==>_Makro_Codeausschnitt_GUI_Resize

Func _Save_Config_codeausschnitt_einfuegen()
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action14 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action14 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf

	;Code abspeichern
	$Code = Sci_GetText($Makro_Codeausschnitt_GUI_scintilla)
	$Code = StringReplace($Code, @CRLF, "[BREAK]")
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "code[" & $Temp_ID_Holder & "]", $Code)


	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $Makro_Codeausschnitt_GUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_codeausschnitt_einfuegen

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_changeprojectversion($ruleID, $ID)
	$modus = IniRead($Pfad_zur_Project_ISN, $ruleID, "setversionmode[" & $ID & "]", "")
	If $modus = "" Then Return

	If $modus = "set" Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", IniRead($Pfad_zur_Project_ISN, $ruleID, "setversionto[" & $ID & "]", ""))
	EndIf

	If $modus = "add" Then
		$Alte_Version = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", "")
		$Alte_Version = StringRegExpReplace($Alte_Version, "[^0-9.,\s]", "")
		$Alte_Version = StringStripWS($Alte_Version, 3)
		$Neue_Version = _Projektversion_erhoehen($Alte_Version, IniRead($Pfad_zur_Project_ISN, $ruleID, "decimalplaces[" & $ID & "]", 2))
		$Neue_Version = StringReplace(IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", ""), $Alte_Version, $Neue_Version)
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", $Neue_Version)
	EndIf
EndFunc   ;==>_Run_changeprojectversion

Func _Changeprojectversion_makro_radioevent()
	If GUICtrlRead($macro_changeVersionGUI_Versionsetzen_radio) = $GUI_CHECKED Then
		GUICtrlSetState($macro_changeVersionGUI_Versionsetzen_input, $GUI_ENABLE)
		GUICtrlSetState($macro_changeVersionGUI_Versionerhoehen_dezimalstellen_combo, $GUI_DISABLE)
	Else
		GUICtrlSetState($macro_changeVersionGUI_Versionsetzen_input, $GUI_DISABLE)
		GUICtrlSetState($macro_changeVersionGUI_Versionerhoehen_dezimalstellen_combo, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_Changeprojectversion_makro_radioevent


Func _Projektversion_erhoehen($hVer, $hMax = 2)
	Local $Inc = 0, $Rtn = ''
	$cVer = StringSplit($hVer, '.')
	$cVer[$cVer[0]] += 1

	For $i = $cVer[0] To 1 Step -1
		If StringLen($cVer[$i]) > $hMax Then
			If $i <> 1 Then $cVer[$i] = 0
			If $i - 1 = 0 Then ExitLoop
			$cVer[$i - 1] += 1
		EndIf
	Next

	For $i = 1 To $cVer[0]
		$Rtn = $Rtn & '.' & String($cVer[$i])
	Next
	Return StringTrimLeft($Rtn, 1)
EndFunc   ;==>_Projektversion_erhoehen


Func _Show_Config_changeprojectversion($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	$modus = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "setversionmode[" & $ID & "]", "set")
	If $modus = "set" Then
		GUICtrlSetState($macro_changeVersionGUI_Versionsetzen_radio, $GUI_CHECKED)
		GUICtrlSetState($macro_changeVersionGUI_Versionerhoehen_radio, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($macro_changeVersionGUI_Versionerhoehen_radio, $GUI_CHECKED)
		GUICtrlSetState($macro_changeVersionGUI_Versionsetzen_radio, $GUI_UNCHECKED)
	EndIf
	_Changeprojectversion_makro_radioevent()
	GUICtrlSetData($macro_changeVersionGUI_Versionerhoehen_dezimalstellen_combo, "")
	GUICtrlSetData($macro_changeVersionGUI_Versionerhoehen_dezimalstellen_combo, "1|2|3|4|5|6|7|8|9", IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "decimalplaces[" & $ID & "]", "2"))
	GUICtrlSetData($macro_changeVersionGUI_Versionsetzen_input, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "setversionto[" & $ID & "]", ""))
	$Temp_ID_Holder = $ID
	GUISetState(@SW_SHOW, $macro_changeVersionGUI)
EndFunc   ;==>_Show_Config_changeprojectversion

Func _Save_Config_changeprojectversion()
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action15 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action15 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "setversionto[" & $Temp_ID_Holder & "]", GUICtrlRead($macro_changeVersionGUI_Versionsetzen_input))

	If GUICtrlRead($macro_changeVersionGUI_Versionsetzen_radio) = $GUI_CHECKED Then
		$readen_mode = "set"
	Else
		$readen_mode = "add"
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "setversionmode[" & $Temp_ID_Holder & "]", $readen_mode)
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "decimalplaces[" & $Temp_ID_Holder & "]", GUICtrlRead($macro_changeVersionGUI_Versionerhoehen_dezimalstellen_combo))

	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $macro_changeVersionGUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_changeprojectversion

;-----------------------------------------------------------------------------------------------------------------------------------------

Func _Run_macro_runscript($ruleID, $ID)
	$Parameter_string = _IniReadRaw($Pfad_zur_Project_ISN, $ruleID, "params[" & $ID & "]", "")
	Local $Datei = ""
	Local $param_mode = 0
	$Use_Tab = IniRead($Pfad_zur_Project_ISN, $ruleID, "use_tab_to_run[" & $ID & "]", "true")
	If $Use_Tab = "true" Then
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return ;Kein Tab geöffnet
		If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) = $Autoitextension Then
			$Datei = $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] ;Aktueller Tab ist au3 Tab
		Else
			Return ;Kein au3 Tab
		EndIf
	Else
		$Datei = _ISN_Variablen_aufloesen(IniRead($Pfad_zur_Project_ISN, $ruleID, "run_filename[" & $ID & "]", ""))
	EndIf

	If Not FileExists($Datei) Then
		MsgBox(262144 + 16, _Get_langstr(25), $Datei & " " & _Get_langstr(332), 0, $Studiofenster)
		Return ;Datei nicht gefunden
	EndIf

	$Use_Params = IniRead($Pfad_zur_Project_ISN, $ruleID, "use_params[" & $ID & "]", "false")
	If $Use_Params = "false" Then
		$param_mode = 1
	Else
		$param_mode = 0
	EndIf

	_Testscript(_ISN_Variablen_aufloesen($Datei), $param_mode, _ISN_Variablen_aufloesen($Parameter_string))
EndFunc   ;==>_Run_macro_runscript

Func _Show_Config_runscript($ID)
	GUISetState(@SW_DISABLE, $newrule_GUI)
	GUICtrlSetData($macro_runscript_parameter_edit, StringReplace(_IniReadRaw($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "params[" & $ID & "]", ""), "#BREAK#", @CRLF))

	;aktueller Tab oder eigene Datei
	If IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "use_tab_to_run[" & $ID & "]", "true") = "true" Then
		GUICtrlSetState($macro_runscript_currenttab_checkbox, $GUI_CHECKED)
		GUICtrlSetState($macro_runscript_usefile_checkbox, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($macro_runscript_currenttab_checkbox, $GUI_UNCHECKED)
		GUICtrlSetState($macro_runscript_usefile_checkbox, $GUI_CHECKED)
	EndIf

	;Parameter
	If IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "use_params[" & $ID & "]", "false") = "true" Then
		GUICtrlSetState($macro_runscript_parameter_none_checkbox, $GUI_UNCHECKED)
		GUICtrlSetState($macro_runscript_parameter_use_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($macro_runscript_parameter_none_checkbox, $GUI_CHECKED)
		GUICtrlSetState($macro_runscript_parameter_use_checkbox, $GUI_UNCHECKED)
	EndIf

	;Dateiname
	GUICtrlSetData($macro_runscript_usefile_input, IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "run_filename[" & $ID & "]", ""))

	$Temp_ID_Holder = $ID
	_Macro_Runscript_Toggle_Radios()
	GUISetState(@SW_SHOW, $macro_runscriptGUI)
	_GUICtrlEdit_SetSel($startparameter_input_makro, -1, -1)
EndFunc   ;==>_Show_Config_runscript

Func _Save_Config_runscript()
	$readen = IniRead($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", "")
	If Not StringInStr($readen, $Key_Action16 & "[" & $Temp_ID_Holder & "]") Then
		$readen = $readen & $Key_Action16 & "[" & $Temp_ID_Holder & "]|"
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "actions", $readen)
	EndIf
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "run_filename[" & $Temp_ID_Holder & "]", _ISN_Pfad_durch_Variablen_ersetzen(GUICtrlRead($macro_runscript_usefile_input)))
	IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "params[" & $Temp_ID_Holder & "]", StringReplace(GUICtrlRead($macro_runscript_parameter_edit), @CRLF, "#BREAK#"))

	;aktueller Tab oder eigene Datei
	If GUICtrlRead($macro_runscript_currenttab_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "use_tab_to_run[" & $Temp_ID_Holder & "]", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "use_tab_to_run[" & $Temp_ID_Holder & "]", "false")
	EndIf

	;Parameter verwenden
	If GUICtrlRead($macro_runscript_parameter_none_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "use_params[" & $Temp_ID_Holder & "]", "false")
	Else
		IniWrite($Pfad_zur_Project_ISN, GUICtrlRead($rule_ID), "use_params[" & $Temp_ID_Holder & "]", "true")
	EndIf

	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $macro_runscriptGUI)
	_Reload_Actionlist()
EndFunc   ;==>_Save_Config_runscript

Func _Macro_Runscript_Toggle_Radios()
	If GUICtrlRead($macro_runscript_usefile_checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($macro_runscript_usefile_input, $GUI_ENABLE)
		GUICtrlSetState($macro_runscript_pfeil, $GUI_ENABLE)
		GUICtrlSetState($macro_runscript_usefile_button, $GUI_ENABLE)
	Else
		GUICtrlSetState($macro_runscript_usefile_input, $GUI_DISABLE)
		GUICtrlSetState($macro_runscript_pfeil, $GUI_DISABLE)
		GUICtrlSetState($macro_runscript_usefile_button, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($macro_runscript_parameter_use_checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($macro_runscript_parameter_edit, $GUI_ENABLE)
	Else
		GUICtrlSetState($macro_runscript_parameter_edit, $GUI_DISABLE)
	EndIf

EndFunc   ;==>_Macro_Runscript_Toggle_Radios

Func _Macro_Runscript_select_file()
	$var = FileOpenDialog(_Get_langstr(187), $Offenes_Projekt, "AutoIt3 Files (*.au3)", 1 + 2, "", $macro_runscriptGUI)
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return
	$var = _ISN_Pfad_durch_Variablen_ersetzen($var)
	GUICtrlSetData($macro_runscript_usefile_input, $var)
EndFunc   ;==>_Macro_Runscript_select_file

;-----------------------------------------------------------------------------------------------------------------------------------------
