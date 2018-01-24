;ISN Autoitstudio Addons.au3


Func _Pruefe_auf_mehrere_Projektdateien($Pfad = "")
	If $Pfad = "" Then Return False
	$Dateien_Array = _FileListToArray($Pfad, "*.isn", $FLTA_FILES, True)
	If Not IsArray($Dateien_Array) Then Return False
	If UBound($Dateien_Array) - 1 > 1 Then Return True ;Wenn mehr als eine .isn Datei gefunden wurde
	Return False ;Wenn nur eine *.isn Datei gefunden wurde
EndFunc   ;==>_Pruefe_auf_mehrere_Projektdateien



Func _Finde_Projektdatei($Pfad = "")
	If $Pfad = "" Then Return ""
	Local $result = "" ;"" Wenn keine Datei gefunden wurde
	$Dateien_Array = _FileListToArray($Pfad, "*.isn", $FLTA_FILES, True)
	If Not IsArray($Dateien_Array) Then Return $result
	If UBound($Dateien_Array) - 1 > 1 Then Return $result ;Wenn mehr als eine .isn Datei gefunden wurde
	Return $Dateien_Array[1] ;Wenn nur eine *.isn Datei gefunden wurde, wird diese verwendet
EndFunc   ;==>_Finde_Projektdatei


Func _hit_win($GUI)
	$wpos = WinGetPos($GUI, "")
	$mpos = MouseGetPos()
	If Not IsArray($wpos) Then Return
	If Not IsArray($mpos) Then Return
	If @error Then Return
	If ($mpos[0] > $wpos[0] And $mpos[1] > $wpos[1]) And ($mpos[0] < $wpos[0] + $wpos[2] And $mpos[1] < $wpos[1] + $wpos[3]) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_hit_win


; ====================================================================================================

; SetBitMap
; ====================================================================================================

Func SetBitmap($hGUI, $hImage, $iOpacity)
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)

	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap

Func _SetIconAlpha($hWnd, $sIcon, $iIndex, $iWidth, $iHeight)

	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $iIndex <> 0 Then $iIndex = $iIndex - 1
	Local $hIcon = _WinAPI_ShellExtractIcons($sIcon, $iIndex, $iWidth, $iHeight)

	If $hIcon = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hBitmap, $hObj, $hDC, $hMem, $hSv

	$hDC = _WinAPI_GetDC($hWnd)
	$hMem = _WinAPI_CreateCompatibleDC($hDC)
	$hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
	$hSv = _WinAPI_SelectObject($hMem, $hBitmap)
	_WinAPI_DrawIconEx($hMem, 0, 0, $hIcon, $iWidth, $iHeight, 0, 0, 2)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	_WinAPI_SelectObject($hMem, $hSv)
	_WinAPI_DeleteDC($hMem)
	_WinAPI_DestroyIcon($hIcon)
	_WinAPI_DeleteObject(_SendMessage($hWnd, 0x0172, 0, 0))
	_SendMessage($hWnd, 0x0172, 0, $hBitmap)
	$hObj = _SendMessage($hWnd, 0x0173)
	If $hObj <> $hBitmap Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	Return 1
EndFunc   ;==>_SetIconAlpha

;___BUTTONICONS__

Func Button_AddIcon($nID, $sIconFile, $nIconID, $nAlign)
;~ 	$sIconFile = $smallIconsdll
	Local $hIL = ImageList_Create(16, 16, BitOR($ILC_MASK, $ILC_COLOR32), 0, 1)
	Local $stIcon = DllStructCreate("int")
	ExtractIconEx($sIconFile, $nIconID, DllStructGetPtr($stIcon), 0, 1)
	ImageList_AddIcon($hIL, DllStructGetData($stIcon, 1))
	DestroyIcon(DllStructGetData($stIcon, 1))
	Local $stBIL = DllStructCreate("dword;int[4];uint")
	DllStructSetData($stBIL, 1, $hIL)
	DllStructSetData($stBIL, 2, 1, 1)
	DllStructSetData($stBIL, 2, 1, 2)
	DllStructSetData($stBIL, 2, 1, 3)
	DllStructSetData($stBIL, 2, 1, 4)
	DllStructSetData($stBIL, 3, $nAlign)
	GUICtrlSendMsg($nID, $BCM_SETIMAGELIST, 0, DllStructGetPtr($stBIL))
EndFunc   ;==>Button_AddIcon

Func ExtractIconEx($sIconFile, $nIconID, $ptrIconLarge, $ptrIconSmall, $nIcons)
	Local $nCount = DllCall('shell32.dll', 'int', 'ExtractIconEx', _
			'str', $sIconFile, _
			'int', $nIconID, _
			'ptr', $ptrIconLarge, _
			'ptr', $ptrIconSmall, _
			'int', $nIcons)
	Return $nCount[0]
EndFunc   ;==>ExtractIconEx

;___END__BUTTONICONS__

Func _Dummyfunc()
EndFunc   ;==>_Dummyfunc

Func _Write_log($str, $colour = "000000", $big = "false", $notime = "false")
	$str = StringReplace($str, "\", "\\")
	$str = StringReplace($str, "/", "//")
	;uictrlsetdata($Programm_log,guictrlread($Programm_log)&@hour&":"&@min&":"&@sec&"  "&$str&@crlf)
	If $ISN_Dark_Mode = "true" Then
		If $colour = "000000" Then $colour = "DFDFDF"
	EndIf

	$time = @HOUR & ":" & @MIN & ":" & @SEC & "  "
	If $ISN_Dark_Mode = "true" Then $time = "[c=#DFDFDF]" & $time & "[/c] "

	$str = "[c=#" & $colour & "]" & $str & "[/c] "
	If $big = "true" Then $str = "[b]" & $str & "[/b] "
	If $notime = "true" Then $time = ""

	_ChatBoxAdd($Programm_log, $time & $str & @CRLF)
	;_GUICtrlEdit_Scroll($Programm_log, $SB_SCROLLCARET)
	_SendMessage($Programm_log, $WM_VSCROLL, $SB_BOTTOM, 0)
EndFunc   ;==>_Write_log

Func _show_Loading($Text1, $Text2)
	GUISetCursor(15, 0, $Loading_GUI)
	GUICtrlSetData($Loading_Text1, $Text1)
	GUICtrlSetData($Loading_Text2, $Text2)
	GUISetState(@SW_SHOW, $Loading_GUI)
	GUISetState(@SW_DISABLE, $StudioFenster)
EndFunc   ;==>_show_Loading

Func _Loading_Progress($zahl)
	GUICtrlSetData($Loading_progressbar, $zahl)
EndFunc   ;==>_Loading_Progress

Func _Hide_Loading()
	GUISetCursor(2, 0, $Loading_GUI)
	GUISetState(@SW_HIDE, $Loading_GUI)
	_Rezize()
EndFunc   ;==>_Hide_Loading

Func _Create_New_Project()
	If GUICtrlRead($new_projectvorlage_combo) = "" And GUICtrlRead($new_projectvorlage_radio1) = $GUI_CHECKED Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(380), 0, $NEW_PROJECT_GUI)
		Return
	EndIf

	If GUICtrlRead($new_projectname) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(24), 0, $NEW_PROJECT_GUI)
		_Input_Error_FX($new_projectname)
		Return
	EndIf

	If GUICtrlRead($neues_projekt_projektdatei_name) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1118), 0, $NEW_PROJECT_GUI)
		_Input_Error_FX($neues_projekt_projektdatei_name)
		Return
	EndIf

	If GUICtrlRead($new_projectmainfile) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(26), 0, $NEW_PROJECT_GUI)
		_Input_Error_FX($new_projectmainfile)
		Return
	EndIf

	If FileExists(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname))) And GUICtrlRead($new_projectstammordner_checkbox) = $GUI_UNCHECKED Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(27), 0, $NEW_PROJECT_GUI)
		Return
	EndIf

	$i = GUICtrlRead($new_projectname)
	If StringInStr($i, "\") Or StringInStr($i, "/") Or StringInStr($i, "?") Or StringInStr($i, ":") Or StringInStr($i, "*") Or StringInStr($i, "|") Or StringInStr($i, "<") Or StringInStr($i, ">") Or StringInStr($i, "'") Or StringInStr($i, '"') Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(390) & @CRLF & _Get_langstr(389), 0, $NEW_PROJECT_GUI)
		_Input_Error_FX($new_projectname)
		Return
	EndIf

	$i = GUICtrlRead($new_projectmainfile)
	If StringInStr($i, "\") Or StringInStr($i, "/") Or StringInStr($i, "?") Or StringInStr($i, ":") Or StringInStr($i, "*") Or StringInStr($i, "|") Or StringInStr($i, "<") Or StringInStr($i, ">") Or StringInStr($i, "'") Or StringInStr($i, '"') Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(505) & @CRLF & _Get_langstr(389), 0, $NEW_PROJECT_GUI)
		_Input_Error_FX($new_projectmainfile)
		Return
	EndIf

	If GUICtrlRead($new_projectvorlage_radio2) = $GUI_CHECKED Then
		If GUICtrlRead($new_projectusefollowingmainfile_input) = "" Then
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(503), 0, $NEW_PROJECT_GUI)
			_Input_Error_FX($new_projectusefollowingmainfile_input)
			Return
		EndIf
	EndIf

	AdlibUnRegister("_New_Project_inteliwrite")

	Local $Noopen = 0
	$state = WinGetState($projectmanager, "")
	If BitAND($state, 2) Then
		$Noopen = 1
	Else
		$Noopen = 0
	EndIf
	If $Noopen = 1 Then
		GUISetState(@SW_ENABLE, $projectmanager)
		GUISetState(@SW_HIDE, $NEW_PROJECT_GUI)
	EndIf
	If $Noopen = 0 Then
		_Write_log(_Get_langstr(33) & "(" & GUICtrlRead($new_projectname) & ")", "000000", "true", "true")
		GUISetState(@SW_ENABLE, $StudioFenster)
		GUISetState(@SW_HIDE, $NEW_PROJECT_GUI)
		GUISetState(@SW_HIDE, $Welcome_GUI)
		GUISetState(@SW_DISABLE, $StudioFenster)
		GUISetState(@SW_SHOW, $StudioFenster)
		;guictrlsetdata($new_projectname,StringReplace(guictrlread($new_projectname)," ","_"))
		_show_Loading(_Get_langstr(22), _Get_langstr(23))
	EndIf
	_Loading_Progress(10)
	If GUICtrlRead($new_projectstammordner_checkbox) = $GUI_UNCHECKED Then
		$res = DirCreate(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)))
		If $res = 0 Then MsgBox(16, "Error", "Cannot create project directory! Maybe access denied?!")
	EndIf
	_Loading_Progress(20)

	Local $Pfad_zur_isn = ""
	If GUICtrlRead($new_projectvorlage_radio1) = $GUI_CHECKED Or GUICtrlRead($new_projectvorlage_radio0) = $GUI_CHECKED Then
		If GUICtrlRead($new_projectvorlage_radio1) = $GUI_CHECKED Then
			_FileOperationProgress($new_projectvorlage_combo_ARRAY[_GUICtrlComboBox_GetCurSel($new_projectvorlage_combo) + 1] & "\*.*", _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)), 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			$Pfad_zur_isn = _Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)))
			FileMove($Pfad_zur_isn, _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn"), 1)
			$Pfad_zur_isn = _Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)))
			$templatemainfile = IniRead(_Finde_Projektdatei($new_projectvorlage_combo_ARRAY[_GUICtrlComboBox_GetCurSel($new_projectvorlage_combo) + 1]), "ISNAUTOITSTUDIO", "mainfile", "")
			FileMove(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & $templatemainfile), _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($new_projectmainfile)), 1)
			;Organize Mainfile
			Dim $aRecords
			_FileReadToArray(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($new_projectmainfile)), $aRecords)
			If IsArray($aRecords) Then
				For $x = 1 To $aRecords[0]
					;Alte Variablen (für Kompatibilität)
					$aRecords[$x] = StringReplace($aRecords[$x], "$FILENAME", GUICtrlRead($new_projectmainfile))
					$aRecords[$x] = StringReplace($aRecords[$x], "$AUTHOR", GUICtrlRead($new_projectauthor))
					$aRecords[$x] = StringReplace($aRecords[$x], "$PROGRAMMVERSION", $Studioversion)
					$aRecords[$x] = StringReplace($aRecords[$x], "$STR30", _Get_langstr(30))
					$aRecords[$x] = StringReplace($aRecords[$x], "$COMMENT", GUICtrlRead($new_projectcomment))

					;Neue Variablen
					$aRecords[$x] = _Neue_Datei_erstellen_ersetze_Variablen($aRecords[$x], GUICtrlRead($new_projectmainfile), GUICtrlRead($new_projectauthor), GUICtrlRead($new_projectcomment), GUICtrlRead($new_projectname))
				Next
				_FileWriteFromArray(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($new_projectmainfile)), $aRecords, 1)
			EndIf
		Else
			;Leeres Projekt
			$file = FileOpen(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($new_projectmainfile)), 1)
			FileClose($file)
		EndIf

		;Projektdatei erstellen / konvertieren
		If FileExists(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn")) Then
			_Datei_nach_UTF16_konvertieren(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn"))
		Else
			_Leere_UTF16_Datei_erstellen(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn"))
		EndIf


		IniWrite(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn"), "ISNAUTOITSTUDIO", "mainfile", GUICtrlRead($new_projectmainfile))
		$Pfad_zur_isn = _Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)))
	EndIf

	If GUICtrlRead($new_projectvorlage_radio2) = $GUI_CHECKED Then
		If GUICtrlRead($new_projectstammordner_checkbox) = $GUI_CHECKED Then
			$new_isn_path = StringTrimRight(GUICtrlRead($new_projectusefollowingmainfile_input), StringLen(GUICtrlRead($new_projectusefollowingmainfile_input)) - StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1) + 1) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn"
			_Leere_UTF16_Datei_erstellen($new_isn_path)
			IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "mainfile", StringTrimLeft(GUICtrlRead($new_projectusefollowingmainfile_input), StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1)))
			$mainfile = StringTrimLeft(GUICtrlRead($new_projectusefollowingmainfile_input), StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1))
			$Default_Name = StringTrimRight($mainfile, StringLen($mainfile) - StringInStr($mainfile, ".", 0, -1) + 1)
			IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "compile_exename", $Default_Name)

		Else
			FileCopy(GUICtrlRead($new_projectusefollowingmainfile_input), _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)), 1)
			$new_isn_path = _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn")
			_Leere_UTF16_Datei_erstellen($new_isn_path)
			IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "mainfile", StringTrimLeft(GUICtrlRead($new_projectusefollowingmainfile_input), StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1)))
			$mainfile = StringTrimLeft(GUICtrlRead($new_projectusefollowingmainfile_input), StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1))
			$Default_Name = StringTrimRight($mainfile, StringLen($mainfile) - StringInStr($mainfile, ".", 0, -1) + 1)
			IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "compile_exename", $Default_Name)

			;Ordnerinhalt kopieren
			If GUICtrlRead($new_project_ordnerinhaltkopieren_checkbox) = $GUI_CHECKED Then
				$Quellordner = GUICtrlRead($new_projectusefollowingmainfile_input)
				$Quellordner = StringTrimRight($Quellordner, (StringLen($Quellordner) - StringInStr($Quellordner, "\", 0, -1)) + 1)
				If FileExists($Quellordner) Then _FileOperationProgress($Quellordner & "\*.*", _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)), 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			EndIf

		EndIf
	EndIf

	_Loading_Progress(60)
	If GUICtrlRead($new_projectstammordner_checkbox) = $GUI_CHECKED Then
		$new_isn_path = StringTrimRight(GUICtrlRead($new_projectusefollowingmainfile_input), StringLen(GUICtrlRead($new_projectusefollowingmainfile_input)) - StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1) + 1) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn"
	Else
		$new_isn_path = _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname) & "\" & GUICtrlRead($neues_projekt_projektdatei_name) & ".isn")
	EndIf

	;gewählten Autor für´s nächste mal speichern
	_Write_in_Config("new_project_author", GUICtrlRead($new_projectauthor))


	_Write_ISN_Debug_Console("New project created! (" & GUICtrlRead($new_projectname) & ")", 1)
	IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "name", GUICtrlRead($new_projectname))
	IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "date", @MDAY & "." & @MON & "." & @YEAR)
	IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "author", GUICtrlRead($new_projectauthor))
	IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "comment", GUICtrlRead($new_projectcomment))
	IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "studioversion", $Studioversion)
	IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "version", GUICtrlRead($new_projectversion))
	IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "time", "0")
	IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "projectopened", "0")

	If GUICtrlRead($new_project_aenderungsprotokolle_checkbox) = $GUI_CHECKED Then
		IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "use_changelog_manager", "true")
	EndIf

	If GUICtrlRead($new_project_aenderungsprotokolle_author_checkbox) = $GUI_CHECKED Then
		IniWrite($new_isn_path, "ISNAUTOITSTUDIO", "changelog_use_author_from_project", "true")
	EndIf



	If $Noopen = 0 Then
		If GUICtrlRead($new_projectstammordner_checkbox) = $GUI_CHECKED Then
			_Load_Project(StringTrimRight(GUICtrlRead($new_projectusefollowingmainfile_input), StringLen(GUICtrlRead($new_projectusefollowingmainfile_input)) - StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1) + 1))
			$History_Projekte_Array = _fuege_in_History_ein($History_Projekte_Array, StringTrimRight(GUICtrlRead($new_projectusefollowingmainfile_input), StringLen(GUICtrlRead($new_projectusefollowingmainfile_input)) - StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1) + 1))
		Else
			_Load_Project(_ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)))
			$History_Projekte_Array = _fuege_in_History_ein($History_Projekte_Array, _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)))
		EndIf
	EndIf

	If $Noopen = 0 Then
		If $Templatemode = 0 And $Tempmode = 0 Then _Start_Project_timer()
		_Loading_Progress(100)
		GUISetState(@SW_ENABLE, $StudioFenster)
		_Hide_Loading()
		_GUICtrlTreeView_ExpandOneLevel($hTreeView, $hroot)
		_Check_tabs_for_changes()
		_Earn_trophy(1, 1)
		If $Templatemode = 0 And $Tempmode = 0 Then _run_rule($Section_Trigger1)
	Else
		GUISetState(@SW_ENABLE, $projectmanager)
		_Show_Projectman()
	EndIf
EndFunc   ;==>_Create_New_Project

Func _return_formicon($type)
	If $type = "button" Then Return 20
	If $type = "label" Then Return 21
	If $type = "input" Then Return 22
	If $type = "checkbox" Then Return 23
	If $type = "radio" Then Return 24
	If $type = "image" Then Return 25
	If $type = "slider" Then Return 26
	If $type = "progress" Then Return 27
	If $type = "updown" Then Return 28
	If $type = "icon" Then Return 29
	If $type = "combo" Then Return 30
	If $type = "edit" Then Return 31
	If $type = "group" Then Return 32
	If $type = "listbox" Then Return 33
	If $type = "tab" Then Return 34
	If $type = "date" Then Return 35
	If $type = "calendar" Then Return 36
	If $type = "listview" Then Return 37
	If $type = "softbutton" Then Return 48
	If $type = "ip" Then Return 47
	If $type = "treeview" Then Return 51
	If $type = "menu" Then Return 59
	If $type = "com" Then Return 108
	If $type = "dummy" Then Return 109
	If $type = "toolbar" Then Return 110
	If $type = "statusbar" Then Return 111
	If $type = "graphic" Then Return 112

	Return 20 ;crash with button
EndFunc   ;==>_return_formicon

Func _oeffne_Editormodus_Leer()
	_oeffne_Editormodus("")
EndFunc   ;==>_oeffne_Editormodus_Leer

Func _oeffne_Editormodus_mit_Datei_waehlen()
	$var = FileOpenDialog(_Get_langstr(508), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(58) & " (*.*)", 1 + 2 + 4, "", $Welcome_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	If @error Then Return
	_oeffne_Editormodus($var)
EndFunc   ;==>_oeffne_Editormodus_mit_Datei_waehlen

Func _oeffne_Editormodus($Datei = "")
	If Not FileExists($Arbeitsverzeichnis & "\Data\Editormode\project.isn") Then
		_Write_ISN_Debug_Console("\\Data\\Editormode\\project.isn not found! I create the file for you now... :)", 2)
		DirCreate($Arbeitsverzeichnis & "\Data\Editormode")
		IniWrite($Arbeitsverzeichnis & "\Data\Editormode\project.isn", "ISNAUTOITSTUDIO", "name", "Editormode")
	EndIf
	_Write_ISN_Debug_Console("Opening Editormode...", 1, 0)
	_show_Loading(_Get_langstr(662), _Get_langstr(23))
	GUISetState(@SW_HIDE, $Welcome_GUI)
;~ 	GUISetState(@SW_LOCK, $studiofenster)
	$Studiomodus = 2 ;EDITOR MODUS
	$Offene_tabs = 0
	$Offenes_Projekt = $Arbeitsverzeichnis & "\Data\Editormode"
	$Pfad_zur_Project_ISN = _Finde_Projektdatei($Offenes_Projekt)
	;Prüfe, ob die Projektdatei bereits auf UTF-16 (LE) konvertiert wurde
	If FileGetEncoding($Pfad_zur_Project_ISN) <> 32 Then
		_Datei_nach_UTF16_konvertieren($Pfad_zur_Project_ISN, False)
	EndIf
	$Offenes_Projekt_name = "Editormode"
	_Loading_Progress(30)
	_Write_log(_Get_langstr(662), "000000", "true", "true")
	_Skripteditor_APIs_und_properties_neu_einlesen()
	SCI_InitEditorAu3($scintilla_Codeausschnitt, $SCI_DEFAULTCALLTIPDIR, $SCI_DEFAULTKEYWORDDIR, $SCI_DEFAULTABBREVDIR)
	SCI_InitEditorAu3($Codeablage_scintilla, $SCI_DEFAULTCALLTIPDIR, $SCI_DEFAULTKEYWORDDIR, $SCI_DEFAULTABBREVDIR)
	SCI_InitEditorAu3($pelock_obfuscator_GUI_Eingabe_scintilla, $SCI_DEFAULTCALLTIPDIR, $SCI_DEFAULTKEYWORDDIR, $SCI_DEFAULTABBREVDIR)
	SCI_InitEditorAu3($pelock_obfuscator_GUI_Ausgabe_scintilla, $SCI_DEFAULTCALLTIPDIR, $SCI_DEFAULTKEYWORDDIR, $SCI_DEFAULTABBREVDIR)
	SendMessage($scintilla_Codeausschnitt, $SCI_UsePopup, 1, 0) ;enable context menu
	SendMessage($Codeablage_scintilla, $SCI_UsePopup, 1, 0) ;enable context menu
	SendMessage($pelock_obfuscator_GUI_Eingabe_scintilla, $SCI_UsePopup, 1, 0) ;enable context menu
	SendMessage($pelock_obfuscator_GUI_Ausgabe_scintilla, $SCI_UsePopup, 1, 0) ;enable context menu
	SendMessage($Codeablage_scintilla, $SCI_SETMARGINWIDTHN, 0, 0)
	_Aktualisiere_oder_erstelle_Projektbaum("")
	_GUICtrlTVExplorer_Expand($hWndTreeview)
	If $Datei <> "" Then $History_Projekte_Array = _fuege_in_History_ein($History_Projekte_Array, $Datei)
	If $Datei <> "" Then _GUICtrlTVExplorer_Expand($hWndTreeview, $Datei)
	_Lade_Zuletzt_Verwendete_Dateien_aus_projectISN()
	_ToDo_Liste_erstelle_Standard_Kategorien()
	_Reload_Ruleslots()
	_Check_Buttons(0)
	If $lade_zuletzt_geoeffnete_Dateien = "true" Then _Oeffne_alte_Tabs(IniRead($Arbeitsverzeichnis & "\Data\Editormode\project.isn", "ISNAUTOITSTUDIO", "opened_tabs", ""))
	_Loading_Progress(50)
	If $Datei <> "" And FileExists($Datei) Then Try_to_opten_file($Datei)
	_Loading_Progress(70)
	_QuickView_ToDo_Liste_neu_einlesen()
	WinSetTitle($Studiofenster, "", _Get_langstr(1) & " - " & _Get_langstr(661))
;~ 	GUISetState(@SW_UNLOCK, $studiofenster)
	GUISetState(@SW_ENABLE, $StudioFenster)
	_Loading_Progress(100)
	_Hide_Loading()
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
	_Show_Warning("confirmeditormode", 308, _Get_langstr(178), _Get_langstr(667), _Get_langstr(7))

EndFunc   ;==>_oeffne_Editormodus

Func _Try_to_Open_project()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(29), 0, $Welcome_GUI)
		Return
	EndIf

	If _Pruefe_auf_mehrere_Projektdateien(_ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlListView_GetItemText($Projects_Listview, _GUICtrlListView_GetSelectionMark($Projects_Listview), 3))) = True Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1104), 0, $Welcome_GUI)
		Return
	EndIf

	$PID_Read = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlListView_GetItemText($Projects_Listview, _GUICtrlListView_GetSelectionMark($Projects_Listview), 3))), "ISNAUTOITSTUDIO", "opened", "")
	If ProcessExists($PID_Read) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(331), 0, $Welcome_GUI)
		If $Autoload = "true" Then GUISetState(@SW_SHOW, $Welcome_GUI)
		Return
	EndIf
	_show_Loading(_Get_langstr(34), _Get_langstr(23))
	GUISetState(@SW_HIDE, $Welcome_GUI)

	_Loading_Progress(50)

	_Write_log(_Get_langstr(34) & "(" & _GUICtrlListView_GetItemText($Projects_Listview, _GUICtrlListView_GetSelectionMark($Projects_Listview), 0) & ")", "000000", "true", "true")
	GUISetState(@SW_LOCK, $studiofenster)
	GUICtrlSetState($HD_Logo, $GUI_HIDE)
	_Loading_Progress(90)
	_Load_Project(_ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlListView_GetItemText($Projects_Listview, _GUICtrlListView_GetSelectionMark($Projects_Listview), 3)))
;~ 	_GUICtrlTreeView_ExpandOneLevel($hTreeView, $hroot)
	_Check_tabs_for_changes()
	If $Templatemode = 0 And $Tempmode = 0 Then _Write_in_Config("lastproject", $Projectfolder & "\" & _GUICtrlListView_GetItemText($Projects_Listview, _GUICtrlListView_GetSelectionMark($Projects_Listview), 3))
	If $Templatemode = 0 And $Tempmode = 0 Then $History_Projekte_Array = _fuege_in_History_ein($History_Projekte_Array, _ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlListView_GetItemText($Projects_Listview, _GUICtrlListView_GetSelectionMark($Projects_Listview), 3)))
	;_Check_Buttons()
	If $Templatemode = 0 And $Tempmode = 0 Then _Start_Project_timer()
	$Studiomodus = 1
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "lastopendate", @MDAY & "." & @MON & "." & @YEAR & " " & @HOUR & ":" & @MIN)
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened", @AutoItPID)
	If $Templatemode = 0 And $Tempmode = 0 Then
		If $enablebackup = "true" Then
			AdlibUnRegister("_Backup_Files")
			AdlibRegister("_Backup_Files", $backuptime * 60000)
		Else
			AdlibUnRegister("_Backup_Files")
		EndIf
	EndIf


	If $Automatische_Speicherung_Modus = "1" Then
		AdlibUnRegister("_ISN_Automatische_Speicherung_starten")
		AdlibRegister("_ISN_Automatische_Speicherung_starten", _TimeToTicks($Automatische_Speicherung_Timer_Stunden, $Automatische_Speicherung_Timer_Minuten, $Automatische_Speicherung_Timer_Sekunden))
	Else
		AdlibUnRegister("_ISN_Automatische_Speicherung_Sekundenevent")
		AdlibRegister("_ISN_Automatische_Speicherung_Sekundenevent", 1000)
	EndIf



	_Check_Buttons(0)
	GUISetState(@SW_UNLOCK, $studiofenster)
	GUISetState(@SW_ENABLE, $StudioFenster)
	_Write_ISN_Debug_Console("Project loaded (" & $Offenes_Projekt_name & ") from " & $Offenes_Projekt, 1)
	_Loading_Progress(100)
	_Hide_Loading()
	_run_rule($Section_Trigger1)
EndFunc   ;==>_Try_to_Open_project

Func _Try_to_delete_project()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $projectmanager)
		Return
	EndIf
	$folder = _ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlListView_GetItemText($Projects_Listview_projectman, _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman), 3))
	$answer = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(169) & @CRLF & @CRLF & _Get_langstr(5) & " " & _
			IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "name", "#ERROR#") & @CRLF & _
			_Get_langstr(18) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "author", "#ERROR#") & @CRLF & _
			_Get_langstr(171) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "date", "#ERROR#") & @CRLF & _
			_Get_langstr(17) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "comment", "#ERROR#") & @CRLF & @CRLF & _
			_Get_langstr(172), 0, $projectmanager)

	If $answer = 6 Then
		DirRemove($folder, 1)
		_Show_Projectman()
	EndIf
EndFunc   ;==>_Try_to_delete_project

Func _Try_to_delete_project_at_welcomepage()
	If _GUICtrlListView_GetSelectionMark($Projects_Listview) = -1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(170), 0, $Welcome_GUI)
		Return
	EndIf
	$folder = _ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlListView_GetItemText($Projects_Listview, _GUICtrlListView_GetSelectionMark($Projects_Listview), 3))
	$answer = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(169) & @CRLF & @CRLF & _Get_langstr(5) & " " & _
			IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "name", "#ERROR#") & @CRLF & _
			_Get_langstr(18) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "author", "#ERROR#") & @CRLF & _
			_Get_langstr(171) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "date", "#ERROR#") & @CRLF & _
			_Get_langstr(17) & " " & IniRead(_Finde_Projektdatei($folder), "ISNAUTOITSTUDIO", "comment", "#ERROR#") & @CRLF & @CRLF & _
			_Get_langstr(172), 0, $Welcome_GUI)

	If $answer = 6 Then
		DirRemove($folder, 1)
		_Load_Projectlist()
	EndIf
EndFunc   ;==>_Try_to_delete_project_at_welcomepage

;===============================================================================
;
; Function Name:   _RunReadStd()
;
; Description::    Run a specified command, and return the Exitcode, StdOut text and
;                  StdErr text from from it. StdOut and StdErr are @tab delimited,
;                  with blank lines removed.
;
; Parameter(s):    $doscmd: the actual command to run, same as used with Run command
;                  $timeoutSeconds: maximum execution time in seconds, optional, default: 0 (wait forever),
;                  $workingdir: directory in which to execute $doscmd, optional, default: @ScriptDir
;                  $flag: show/hide flag, optional, default: @SW_HIDE
;                  $sDelim: stdOut and stdErr output deliminter, optional, default: @TAB
;                  $nRetVal: return single item from function instead of array, optional, default: -1 (return array)
;
; Requirement(s):  AutoIt 3.2.10.0
;
; Return Value(s): An array with three values, Exit Code, StdOut and StdErr
;
; Author(s):       lod3n
;                  (Thanks to mrRevoked for delimiter choice and non array return selection)
;                  (Thanks to mHZ for _ProcessOpenHandle() and _ProcessGetExitCode())
;                  (MetaThanks to DaveF for posting these DllCalls in Support Forum)
;                  (MetaThanks to JPM for including CloseHandle as needed)
;
;===============================================================================

Func _RunReadStd($doscmd, $timeoutSeconds = 0, $workingdir = @ScriptDir, $flag = @SW_HIDE, $nRetVal = -1, $sDelim = @TAB)
	Local $aReturn, $i_Pid, $h_Process, $i_ExitCode, $sStdOut, $sStdErr, $runTimer
	Dim $aReturn[3]

	; run process with StdErr and StdOut flags
	$runTimer = TimerInit()
	$i_Pid = Run($doscmd, $workingdir, $flag, 6) ; 6 = $STDERR_CHILD+$STDOUT_CHILD
	$RUNNING_SCRIPT = $i_Pid
	; Get process handle
	Sleep(100) ; or DllCall may fail - experimental
	$h_Process = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', 0x400, 'int', 0, 'int', $i_Pid)

	Global $iProcessID = $i_Pid

	$hPDHQuery = _PDH_GetNewQueryHandle()

	; Get the localized name for "Process"
	$sProcessLocal = _PDH_GetCounterNameByIndex(230, "")

	Global $poCounter = _PDH_ProcessObjectCreate($sProcess, $iProcessID)
;~ 	ConsoleWrite($poCounter & @CRLF)
	_PDH_ProcessObjectAddCounters($poCounter, "6;180") ; "% Processor Time;Working Set"
	_PDH_ProcessObjectCollectQueryData($poCounter)

	; create tab delimited string containing StdOut text from process
	$aReturn[1] = ""
	$sStdOut = ""
	While 1
		Sleep(500)
		$line = StdoutRead($i_Pid)
		If @error Then ExitLoop
		$sStdOut &= $line
		_Write_debug($line)
	WEnd

	; fetch exit code and close process handle
	If IsArray($h_Process) Then
		Sleep(100) ; or DllCall may fail - experimental
		$i_ExitCode = DllCall('kernel32.dll', 'ptr', 'GetExitCodeProcess', 'ptr', $h_Process[0], 'int*', 0)
		If IsArray($i_ExitCode) Then
			$aReturn[0] = $i_ExitCode[2]
		Else
			$aReturn[0] = -1
		EndIf
		Sleep(100) ; or DllCall may fail - experimental
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $h_Process[0])
	Else
		$aReturn[0] = -2
	EndIf

	$aReturn[0] = $sStdOut
	$aReturn[1] = $i_ExitCode[2]
	$aReturn[2] = $i_Pid
	Return $aReturn

	; return single item if correctly specified with with $nRetVal
	If $nRetVal <> -1 And $nRetVal >= 0 And $nRetVal <= 2 Then Return $aReturn[$nRetVal]

	; return array with exit code, stdout, and stderr
	Return $aReturn
EndFunc   ;==>_RunReadStd

Func _Disable_edit()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	WinSetState($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "", @SW_DISABLE)
EndFunc   ;==>_Disable_edit

Func _ENABLE_edit()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	WinSetState($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
EndFunc   ;==>_ENABLE_edit

Func _Try_to_Exit()
	If $closeaction = "close" Then AdlibRegister("_exit", 0)
	If $closeaction = "closeproject" Then AdlibRegister("_Close_Project_Adlib", 0)
	If $closeaction = "minimize" Then WinSetState($Studiofenster, "", @SW_MINIMIZE)
EndFunc   ;==>_Try_to_Exit

Func _exit_force()
	$AskExit = "false"
	$SHOW_DEBUG_CONSOLE = "false"
	AdlibRegister("_exit", 0)
EndFunc   ;==>_exit_force

Func _exit()
	AdlibUnRegister("_exit")

	If $Can_open_new_tab = 0 Then Return

	If $AskExit = "true" Then
		$i = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(188), 0, $Studiofenster)
		If $i = 7 Then Return
	EndIf
	_Write_ISN_Debug_Console("Shutting down ISN AutoIt Studio...", 2)
	FileDelete($Arbeitsverzeichnis & "\data\cache\AutoIt_Studio_Print.txt")
	_Studiofensterposition_speichern()
	GUISetState(@SW_HIDE, $msgboxcreator)
	GUISetState(@SW_HIDE, $fFind1)
	GUISetState(@SW_HIDE, $colour_picker)
	GUISetState(@SW_HIDE, $bitwise_operations_GUI)
	GUISetState(@SW_HIDE, $ToDoList_Manager)
	GUISetState(@SW_HIDE, $ParameterEditor_GUI)
	GUISetState(@SW_HIDE, $Welcome_GUI)
	GUISetState(@SW_HIDE, $QuickView_GUI)
	GUISetState(@SW_HIDE, $StudioFenster)
	WinMove($StudioFenster, "", 900000, 900000)


	If _GUICtrlTab_GetItemCount($htab) > 0 And _GUICtrlTab_GetCurFocus($htab) <> -1 Then
		If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "resize") ;Plugin versteckt sich auch beim herunterfahren
	EndIf
	If $SKRIPT_LAUEFT = 1 Then _STOPSCRIPT()
	$Benoetigte_Zeit = 0
	If $Offenes_Projekt <> "" Then
		If $Templatemode = 0 And $Tempmode = 0 Then $Benoetigte_Zeit = _stop_Project_timer()
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened", "")

		;Speichere geöffnete Tabs in die project.Isn
		$Pfade = ""
		If _GUICtrlTab_GetItemCount($htab) > 0 Then
			For $x = 0 To _GUICtrlTab_GetItemCount($htab) - 1
				$Pfade = $Pfade & _ISN_Pfad_durch_Variablen_ersetzen($Datei_pfad[$x]) & "|"
			Next
		EndIf
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened_tabs", $Pfade)

		_Write_ISN_Debug_Console("|--> Closing Type 3 Plugins...", 1)
		_Laufende_Type3_Plugins_Beenden()
		_Write_ISN_Debug_Console("|--> Type 3 Plugins closed!", 1)

		_run_rule($Section_Trigger6)
		_Zeige_neuer_changelog_eintrag_GUI()
	EndIf
	If _GUICtrlTab_GetItemCount($htab) > 0 And _GUICtrlTab_GetCurFocus($htab) <> -1 Then WinMove($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "", 900000, 900000)
	_Write_ISN_Debug_Console("|--> Closing all tabs...(" & $Offene_tabs & " tab(s) loaded)", 1)
	_Close_All_Tabs()
	_Write_ISN_Debug_Console("|--> All tabs closed!", 1)
	_Write_ISN_Debug_Console("|--> Destroy Chatboxes...", 1)
	_ChatBoxDestroy($Programm_log)
	_ChatBoxDestroy($Credits_Srollbox)
	_RDC_Destroy()
	_Kille_Laufende_Type3_Plugins()
	If $Tempmode = 1 Then DirRemove($Offenes_Projekt, 1)
	;Clean up
	DllClose($dll)
	DllClose($user32)
	DllClose($kernel32)
	FileDelete($Cachefile)
	FileDelete($Backupcache)
	If FileExists($Arbeitsverzeichnis & "\Data\Cache\print.html") Then FileDelete($Arbeitsverzeichnis & "\Data\Cache\print.html")
	DirRemove($Arbeitsverzeichnis & "\Data\Cache\tempcompile", 1)
	If $runafter <> "" Then
		_Write_ISN_Debug_Console("|--> Run before exit...!", 1)
		_Run_Beforexit()
	EndIf
	_GUICtrlListView_UnRegisterSortCallBack($changelogmanager_listview)
	_PDH_UnInit()
	_USkin_Exit()
	OnAutoItExit_modern()
	OnAutoItExit()
	_GUICtrlTVExplorer_DestroyAll()
	_RDC_CloseDll()
	_Write_ISN_Debug_Console("|--> ISN AutoIt Studio shutdown complete! Bye... ;)", 1)
	If $SHOW_DEBUG_CONSOLE = "true" And $ISN_Restart_initiated = 0 Then MsgBox(0, "", "Press ok to exit", 0, $console_GUI)
	_ChatBoxDestroy($console_chatbox)
	If $ISN_Restart_initiated = 1 Then
		If @Compiled Then
			ShellExecute(@AutoItExe)
		Else
			ShellExecute(@ScriptDir & "\" & @ScriptName)
		EndIf
	EndIf
	Exit
EndFunc   ;==>_exit

Func _Close_Project_Adlib()
AdlibUnRegister("_Close_Project_Adlib")
_Close_Project()
EndFunc

Func _Close_Project($Changelogeintrag_anzeigen = "true")
	if $Offenes_Projekt = "" then return 1 ;No project opened
	If $Can_open_new_tab = 0 Then Return
	If $SKRIPT_LAUEFT = 1 Then _STOPSCRIPT()
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened", "")
	$Benoetigte_Zeit = 0
	If $Templatemode = 0 And $Tempmode = 0 And $Studiomodus = 1 Then $Benoetigte_Zeit = _stop_Project_timer()
	_Write_ISN_Debug_Console("Closing project (" & $Offenes_Projekt_name & ")...", 1)
	_Clear_Debuglog()
	Sci_DelLines($Codeablage_scintilla)
	_Debug_clear_redo()
	GUISetState(@SW_HIDE, $msgboxcreator)
	GUISetState(@SW_HIDE, $fFind1)
	GUISetState(@SW_HIDE, $colour_picker)
	GUISetState(@SW_HIDE, $bitwise_operations_GUI)
	GUISetState(@SW_HIDE, $ToDoList_Manager)
	GUISetState(@SW_HIDE, $ParameterEditor_GUI)
	_Write_in_Config("lastproject", "")
	;Speichere geöffnete Tabs in die project.IsNumber
	$Pfade = ""
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		For $x = 0 To _GUICtrlTab_GetItemCount($htab) - 1
			$Pfade = $Pfade & _ISN_Pfad_durch_Variablen_ersetzen($Datei_pfad[$x]) & "|"
		Next
	EndIf
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened_tabs", $Pfade)

	_GUICtrlTreeView_DeleteAll($hWndTreeview)
	_GUICtrlTreeView_DeleteAll($hWndTreeView2)
	_Close_All_Tabs()

	_Write_ISN_Debug_Console("|--> Closing Type 3 Plugins...", 1)
	_Laufende_Type3_Plugins_Beenden()
	_Write_ISN_Debug_Console("|--> Type 3 Plugins closed!", 1)

	WinSetTitle($Studiofenster, "", _Get_langstr(1))
	_Reset_Search()
	If $Studiomodus = 1 Then
		_Write_log(_Get_langstr(311) & "(" & $Offenes_Projekt_name & ")", "000000", "true", "true")
	Else
		_Write_log(_Get_langstr(665) & "...", "000000", "true", "true")
	EndIf
	_Write_log("", "000000", "true", "true")
	If $Changelogeintrag_anzeigen = "true" Then _Zeige_neuer_changelog_eintrag_GUI()
	_run_rule($Section_Trigger6)
	AdlibUnRegister("_Backup_Files")
	AdlibUnRegister("_ISN_Automatische_Speicherung_Sekundenevent")
	FileDelete($Backupcache) ;Lösche Backupcache
	_GUICtrlTreeView_DeleteAll($hWndTreeview)
	_GUICtrlTreeView_DeleteAll($hWndTreeView2)
	_Clear_Projecttree_Rebuild()
	_Clear_Scripttree_Rebuild()
	_RDC_Destroy()
	_Write_ISN_Debug_Console("|--> Killing Type 3 Plugins...", 1)
	_Kille_Laufende_Type3_Plugins()
	If $Tempmode = 1 Then DirRemove($Offenes_Projekt, 1) ;Clean up tempprojects
	$Offenes_Projekt = ""
	$Offenes_Projekt_name = ""
	$Pfad_zur_Project_ISN = ""
	$Parameter_SCE_HANDLE = ""
	$Offene_tabs = 0
	$Tempmode = 0
	$SKRIPT_LAUEFT = 0
	$Studiomodus = 1
	_GUICtrlStatusBar_SetText_ISN($Status_bar, "")
	_Load_Projectlist()
	_ToDo_Liste_leeren()
	_Reset_all_Helperthreads()
	;RDC Verzeichnise freigeben
	GUISetState(@SW_DISABLE, $StudioFenster)
	If $Templatemode = 0 Then
		GUISetState(@SW_SHOW, $Welcome_GUI)
	Else
		GUISetState(@SW_SHOW, $projectmanager)
	EndIf
	$Templatemode = 0
EndFunc   ;==>_Close_Project


Func _GUICtrlStatusBar_SetText_ISN($handle = "", $text = "")
	If $handle = "" Then Return
	_GUICtrlStatusBar_SetText($handle, $text)
EndFunc   ;==>_GUICtrlStatusBar_SetText_ISN

Func _Load_Projectlist()
	_Write_ISN_Debug_Console("|--> Loading Projects...", 1, 0)
	_Read_Last_4_Projects()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projects_Listview))
	ScanforProjects(_ISN_Variablen_aufloesen($Projectfolder))
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
EndFunc   ;==>_Load_Projectlist

Func ScanforProjects($SourceFolder)
	Local $Search
	Local $file
	Local $FileAttributes
	Local $FullFilePath
	$Count = 0
	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	_GUICtrlListView_BeginUpdate($Projects_Listview)

	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf
		$file = FileFindNextFile($Search)
		If @error Then ExitLoop
		$FullFilePath = $SourceFolder & "\" & $file
		$FileAttributes = FileGetAttrib($FullFilePath)
		If StringInStr($FileAttributes, "D") Then
			If FileExists(_Finde_Projektdatei($FullFilePath)) Then
				$tmp_isn_file = _Finde_Projektdatei($FullFilePath)
				$tmp = IniReadSection($tmp_isn_file, "ISNAUTOITSTUDIO")
				If Not @error Then
					$Count = $Count + 1
					_GUICtrlListView_AddItem($Projects_Listview, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "name", "#ERROR#"), 39)
					_GUICtrlListView_AddSubItem($Projects_Listview, _GUICtrlListView_GetItemCount($Projects_Listview) - 1, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "author", ""), 1)
					_GUICtrlListView_AddSubItem($Projects_Listview, _GUICtrlListView_GetItemCount($Projects_Listview) - 1, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "comment", ""), 2)
					$folder = StringTrimLeft($FullFilePath, StringInStr($FullFilePath, "\", 0, -1))
					_GUICtrlListView_AddSubItem($Projects_Listview, _GUICtrlListView_GetItemCount($Projects_Listview) - 1, $folder, 3)
				EndIf
			EndIf
		EndIf
	WEnd
	$Descending = False
	_GUICtrlListView_SimpleSort($Projects_Listview, $Descending, 0)
	_GUICtrlListView_SetItemSelected($Projects_Listview, -1, False, False)
	_GUICtrlListView_EndUpdate($Projects_Listview)
	If $Count > 4 Then _Earn_trophy(5, 1)
EndFunc   ;==>ScanforProjects

Func _Clear_Projecttree_Rebuild()
	$Projektbaum_Treeview_Expanded_Array = $Projektbaum_Treeview_Expanded_Array_empty
EndFunc   ;==>_Clear_Projecttree_Rebuild

Func _Clear_Scripttree_Rebuild()
	$Scripttree_Treeview_Expanded_Array = $Projektbaum_Treeview_Expanded_Array_empty
EndFunc   ;==>_Clear_Scripttree_Rebuild

; #FUNCTION# ;===============================================================================
;
; Name...........: _Speichere_TVExplorer
; Description ...: Speichert alle geöffneten (expanded) Elemente des Projektbaumen im $Projektbaum_Treeview_Expanded_Array Array
; Syntax.........: _Speichere_TVExplorer($hTreeView)
; Parameters ....: $hTreeView			- Handle zum Treeview
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Speichere_TVExplorer($hTreeView)
	_Clear_Projecttree_Rebuild()
	$found = 0
	$hItem = _GUICtrlTreeView_GetFirstItem($hTreeView)
	If _GUICtrlTreeView_GetExpanded($hTreeView, $hItem) = True Then
		$Projektbaum_Treeview_Expanded_Array[$found] = _GUICtrlTreeView_GetText($hTreeView, $hItem)
		$found = $found + 1
	EndIf
	While True
		$hItem = _GUICtrlTreeView_GetNext($hTreeView, $hItem)
		If $hItem = 0 Then ExitLoop
		If _GUICtrlTreeView_GetExpanded($hTreeView, $hItem) = True Then
			$Projektbaum_Treeview_Expanded_Array[$found] = _GUICtrlTreeView_GetText($hTreeView, $hItem)
			$found = $found + 1
		EndIf
	WEnd
EndFunc   ;==>_Speichere_TVExplorer

; #FUNCTION# ;===============================================================================
;
; Name...........:  _Lade_TVExplorer
; Description ...: Lädt alle geöffneten (expanded) Elemente des Projektbaumen aus dem $Projektbaum_Treeview_Expanded_Array Array
; Syntax.........:  _Lade_TVExplorer($hTreeView)
; Parameters ....: $hTreeView			- Handle zum Treeview
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Lade_TVExplorer($hTreeView)
	$hItem = _GUICtrlTreeView_GetFirstItem($hTreeView)
	$res = _ArraySearch($Projektbaum_Treeview_Expanded_Array, _GUICtrlTreeView_GetText($hTreeView, $hItem))
	If $res <> -1 Then
		_GUICtrlTreeView_ExpandOneLevel($hTreeView, $hItem)
	EndIf
	While True
		$hItem = _GUICtrlTreeView_GetNext($hTreeView, $hItem)
		If $hItem = 0 Then ExitLoop
		$res = _ArraySearch($Projektbaum_Treeview_Expanded_Array, _GUICtrlTreeView_GetText($hTreeView, $hItem))
		If $res <> -1 Then
			If StringInStr($Offenes_Projekt, _GUICtrlTreeView_GetText($hTreeView, $hItem)) And $AutoIt_Projekte_in_Projektbaum_anzeigen = "true" And StringInStr(_GUICtrlTreeView_GetTree($hTreeView, $hItem), _Get_langstr(881)) Then ContinueLoop
			_GUICtrlTreeView_ExpandOneLevel($hTreeView, $hItem)
		EndIf
	WEnd
EndFunc   ;==>_Lade_TVExplorer

; #FUNCTION# ;===============================================================================
;
; Name...........:  _Update_Treeview
; Description ...: Aktualisiert den Projektbaum
; Syntax.........: _Update_Treeview()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Speichert automatisch geöffnete Elemente und stellt diese nach dem Aktualisieren wieder her
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Update_Treeview()
	AdlibUnRegister("_Update_Treeview")
	If $Offenes_Projekt = "" Then Return
	_GUICtrlTreeView_BeginUpdate($hTreeView)
	_Speichere_TVExplorer($hTreeView) ;Speichere geöffnete Elemente
	$old_selected_file = _GUICtrlTVExplorer_GetSelected($hTreeView)
;~ ConsoleWrite($old_selected_file&@crlf)
;~ 	_GUICtrlTVExplorer_Expand($hTreeView, StringTrimRight($file, StringLen($oldname)) & $line, 1)
;~ 		 $Path = _GUICtrlTVExplorer_GetSelected($hTreeView)
;~             _GUICtrlTVExplorer_AttachFolder($hTreeView)
;~             _GUICtrlTVExplorer_Expand($hTreeView, $Path, 0)
	_GUICtrlTVExplorer_AttachFolder($hWndTreeview) ;Lade Treeview neu
	If FileExists($old_selected_file) Then
		_GUICtrlTVExplorer_Expand($hTreeView, $old_selected_file)
	Else
		_GUICtrlTVExplorer_Expand($hTreeView)
	EndIf
	_Lade_TVExplorer($hTreeView) ;Geöffnete Elemente wiederherstellen
	_GUICtrlTreeView_EndUpdate($hTreeView)
EndFunc   ;==>_Update_Treeview

; #FUNCTION# ;===============================================================================
;
; Name...........: _Aktualisiere_oder_erstelle_Projektbaum
; Description ...: Erstellt bzw.
; Syntax.........: _Aktualisiere_oder_erstelle_Projektbaum($Rootfolder)
; Parameters ....: $Rootfolder			- Ordnerpfad der im Projektbaum angezeigt werden soll
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird jedesmal aufgerufen wenn ein Projekt geöffnet wird. Löscht das alte Treeview Control und erzeugt ein neues mit dem angegebenen Rootpfad
;					Erstellt auch über die Funktion "" das Kontextmenü für den Treeview
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Aktualisiere_oder_erstelle_Projektbaum($Rootfolder)
	$alte_position = ControlGetPos($Studiofenster, "", $hTreeView) ;hole zuerst die positionen des alten Controls
	_GUICtrlTVExplorer_Destroy($hWndTreeview) ;Zerstöre Inhalt der TVExplorer UDF
	Global $tvData[1][31] = [[0, _GUIImageList_Create(_WinAPI_GetSystemMetrics(49), _WinAPI_GetSystemMetrics(50), 5, 1), GUICreate('')]] ;Deklariere neu
	Global $tvIcon[101][3] = [[0]] ;Deklariere neu
	GUISwitch($studiofenster) ;wechsle zum Studiofenster
	_GUICtrlTVExplorer_Create($Rootfolder, $alte_position[0], $alte_position[1], $alte_position[2], $alte_position[3], -1, $WS_EX_CLIENTEDGE, $TV_FLAG_SHOWFILESEXTENSION + $TV_FLAG_SHOWFILES + $TV_FLAG_SHOWFOLDERICON + $TV_FLAG_SHOWFILEICON + $TV_FLAG_SHOWLIKEEXPLORER, "_Projecttree_event", '', 1) ;Erstelle neuen Treeview an der Position des alten
	Global $hWndTreeview = GUICtrlGetHandle($hTreeView) ;Erneuere Handle
	GUICtrlSetFont($hTreeView, $treefont_size, 400, 0, $treefont_font) ;Schrift
	GUICtrlSetColor($hTreeView, $treefont_colour) ;Farbe
	GUICtrlSetState($hTreeView, $GUI_DROPACCEPTED) ;aktiviere Drag´nDrop
;~ _Erstelle_Kontextmenue_fuer_Projektbaum()

;~ _GUICtrlTVExplorer_SetExplorerStyle($hWndTreeview) ;aktiviere modernen Explorer Style ;)
EndFunc   ;==>_Aktualisiere_oder_erstelle_Projektbaum

Func _Load_Project($Foldername)
	FileDelete($Backupcache)
	_GUICtrlTab_DeleteAllItems($htab)
	$Offene_tabs = 0
	GUICtrlSetState($hTreeView, $GUI_ENABLE)
	GUICtrlSetState($hTreeview2, $GUI_ENABLE)
	$Pfad_zur_Project_ISN = _Finde_Projektdatei($Foldername)

	;Prüfe, ob die Projektdatei bereits auf UTF-16 (LE) konvertiert wurde
	If FileGetEncoding($Pfad_zur_Project_ISN) <> 32 Then
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(1292), 0, $StudioFenster)
		_Datei_nach_UTF16_konvertieren($Pfad_zur_Project_ISN)
	EndIf

	$Offenes_Projekt = $Foldername
	$Offenes_Projekt_name = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", "")
	$RDC_Main_Thread = _RDC_Create($Offenes_Projekt, 1, BitOR($FILE_NOTIFY_CHANGE_FILE_NAME, $FILE_NOTIFY_CHANGE_DIR_NAME), 0, $Studiofenster)
	$Skriptbaum_Filter_Array = StringSplit(IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "scripttreefilter", ""), "|", 2)
	_Aktualisiere_oder_erstelle_Projektbaum($Offenes_Projekt)
	_GUICtrlTVExplorer_Expand($hWndTreeview)
	_Lade_Zuletzt_Verwendete_Dateien_aus_projectISN()
	WinSetTitle($Studiofenster, "", IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", "") & " - " & _Get_langstr(1))
	$oldoppened = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "projectopened", "0")
	$oldoppened = $oldoppened + 1
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "projectopened", $oldoppened)
	_Reload_Ruleslots()
	_Skripteditor_APIs_und_properties_neu_einlesen()
	SCI_InitEditorAu3($scintilla_Codeausschnitt, $SCI_DEFAULTCALLTIPDIR, $SCI_DEFAULTKEYWORDDIR, $SCI_DEFAULTABBREVDIR)
	SCI_InitEditorAu3($Codeablage_scintilla, $SCI_DEFAULTCALLTIPDIR, $SCI_DEFAULTKEYWORDDIR, $SCI_DEFAULTABBREVDIR)
	SCI_InitEditorAu3($pelock_obfuscator_GUI_Eingabe_scintilla, $SCI_DEFAULTCALLTIPDIR, $SCI_DEFAULTKEYWORDDIR, $SCI_DEFAULTABBREVDIR)
	SCI_InitEditorAu3($pelock_obfuscator_GUI_Ausgabe_scintilla, $SCI_DEFAULTCALLTIPDIR, $SCI_DEFAULTKEYWORDDIR, $SCI_DEFAULTABBREVDIR)
	SendMessage($scintilla_Codeausschnitt, $SCI_UsePopup, 1, 0) ;enable context menu
	SendMessage($Codeablage_scintilla, $SCI_UsePopup, 1, 0) ;enable context menu
	SendMessage($pelock_obfuscator_GUI_Eingabe_scintilla, $SCI_UsePopup, 1, 0) ;enable context menu
	SendMessage($pelock_obfuscator_GUI_Ausgabe_scintilla, $SCI_UsePopup, 1, 0) ;enable context menu
	SendMessage($Codeablage_scintilla, $SCI_SETMARGINWIDTHN, 0, 0)
	_QuickView_ToDo_Liste_neu_einlesen()
	_ToDo_Liste_erstelle_Standard_Kategorien()
	If $lade_zuletzt_geoeffnete_Dateien = "true" Then _Oeffne_alte_Tabs(IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened_tabs", ""))
	If $autoloadmainfile = "true" Then Try_to_opten_file($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"))
EndFunc   ;==>_Load_Project

Func _CheckCtrlDblClick($GUI, $CTRL)
	Local $CtrlPos = ControlGetPos($GUI, '', $CTRL)
	If Not IsArray($pos) Then Return
	If Not IsArray($CtrlPos) Then Return
	If ($pos[0] >= $CtrlPos[0] And $pos[0] <= $CtrlPos[0] + $CtrlPos[2]) And _
			($pos[1] >= $CtrlPos[1] + 20 And $pos[1] <= $CtrlPos[1] + 20 + $CtrlPos[3]) Then
		$n += 1
		$MousePos = True
		If $n = 2 And (TimerDiff($start) < $clickspeed) Then
			Return True
		Else
			$start = TimerInit()
			$n = 1
		EndIf
	EndIf
EndFunc   ;==>_CheckCtrlDblClick

Func _CheckCtrlClick($GUI, $CTRL)
	Local $CtrlPos = ControlGetPos($GUI, '', $CTRL)
	If ($pos[0] >= $CtrlPos[0] And $pos[0] <= $CtrlPos[0] + $CtrlPos[2]) And _
			($pos[1] >= $CtrlPos[1] + 20 And $pos[1] <= $CtrlPos[1] + 20 + $CtrlPos[3]) Then
		$n += 1
		$MousePos = True
		Return True
	EndIf
EndFunc   ;==>_CheckCtrlClick

Func _PRIMARYdown()
	$pos = MouseGetPos()
	Select
		Case _CheckCtrlDblClick($StudioFenster, $Debug_log)
			_trytofinderror()
		Case Else
			$MousePos = False
	EndSelect

	;Drag´n Drop für Tabitems
	If IsDeclared("Studiofenster") And IsDeclared("htab") Then
		$aCInfo = GUIGetCursorInfo($Studiofenster)
		If IsArray($aCInfo) And IsDeclared("htab") Then
			Switch $aCInfo[4]

				Case $htab
					If _GUICtrlTab_GetItemCount($htab) > 1 Then ;Nur wenn mehr als 1 Tab aktiv ist
						$Tab_Item0Rect = _GUICtrlTab_GetItemRect($htab, 0)
						$Tab_Control_Pos = ControlGetPos($Studiofenster, "", $htab)
						Opt("MouseCoordMode", 2) ;1=absolute, 0=relative, 2=client
						$pos = MouseGetPos()
						Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
						If IsArray($Tab_Control_Pos) And IsArray($Tab_Item0Rect) Then
							If $pos[1] < $Tab_Control_Pos[1] + $Tab_Item0Rect[3] Then ;Nur wenn sich maus auf den "Tabitems" befindet
								$getroffenes_item = _GUICtrlTab_HitTest($htab, $pos[0] - $Tab_Control_Pos[0], $pos[1] - $Tab_Control_Pos[1])
								If IsArray($getroffenes_item) Then
									If $getroffenes_item[0] <> -1 Then
										;Es wurde ein Tabitem getroffen
										Sleep(500) ;Warte ob Mausteste nach 500ms immer noch gedrückt ist
										If _IsPressed("01", $user32) Then
											;Drag´n Drop Tabitem


											GUISwitch($Studiofenster)
											$Tab_Dragndrop_Poslabel = GUICtrlCreateIcon($smallIconsdll, 1564, 0, 0, 15, 15)
											GUICtrlSetState(-1, $GUI_HIDE)

											Opt("MouseCoordMode", 2) ;1=absolute, 0=relative, 2=client
											While _IsPressed("01", $user32)
												Sleep(50)
												$pos = MouseGetPos()
												$Maus_ueber_Item = _GUICtrlTab_HitTest($htab, $pos[0] - $Tab_Control_Pos[0], $pos[1] - $Tab_Control_Pos[1])
												If Not IsArray($getroffenes_item) Then ExitLoop
												If Not IsArray($Maus_ueber_Item) Then ExitLoop
												If $Maus_ueber_Item[0] = -1 Then
													GUICtrlSetState($Tab_Dragndrop_Poslabel, $GUI_HIDE)
													ContinueLoop
												EndIf

												If $Maus_ueber_Item[0] = $getroffenes_item[0] Then
													GUICtrlSetState($Tab_Dragndrop_Poslabel, $GUI_HIDE)
													ContinueLoop
												EndIf

												$Tab_Dragndrop_Itemrect = _GUICtrlTab_GetItemRect($htab, $Maus_ueber_Item[0])
												If $Maus_ueber_Item[0] > $getroffenes_item[0] Then
													;Maus ist rechts neben den aktuellen Item
													GUICtrlSetImage($Tab_Dragndrop_Poslabel, $smallIconsdll, 1566)
													GUICtrlSetPos($Tab_Dragndrop_Poslabel, ($Tab_Control_Pos[0] + $Tab_Dragndrop_Itemrect[2]) - 19, $Tab_Control_Pos[1] + 5)

												Else
													;Maus ist links neben den aktuellen Item
													GUICtrlSetImage($Tab_Dragndrop_Poslabel, $smallIconsdll, 1563)
													GUICtrlSetPos($Tab_Dragndrop_Poslabel, ($Tab_Control_Pos[0] + $Tab_Dragndrop_Itemrect[0]) + 1, $Tab_Control_Pos[1] + 5)

												EndIf
												$iFlags = BitOR($SWP_SHOWWINDOW, $SWP_NOSIZE, $SWP_NOMOVE)
												_WinAPI_SetWindowPos(GUICtrlGetHandle($Tab_Dragndrop_Poslabel), $HWND_TOP, 0, 0, 0, 0, $iFlags)
											WEnd
											Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
											GUICtrlDelete($Tab_Dragndrop_Poslabel)
											If IsArray($getroffenes_item) And IsArray($Maus_ueber_Item) Then _Tabseiten_austauschen($getroffenes_item[0], $Maus_ueber_Item[0])
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf

					EndIf


			EndSwitch
		EndIf
	EndIf



EndFunc   ;==>_PRIMARYdown


Func _Tabseiten_austauschen($Quellindex = -1, $Zielindex = -1)
	If $Quellindex = -1 Then Return
	If $Zielindex = -1 Then Return

	$Quelle_State = _GUICtrlTab_GetItem($htab, $Quellindex)
	$Ziel_State = _GUICtrlTab_GetItem($htab, $Zielindex)

	If Not IsArray($Quelle_State) Then Return
	If Not IsArray($Ziel_State) Then Return

	;Tausche Arrayeinträge
	_ArraySwap($SCE_EDITOR, $Quellindex, $Zielindex)
	_ArraySwap($Plugin_Handle, $Quellindex, $Zielindex)
	_ArraySwap($FILE_CACHE, $Quellindex, $Zielindex)
	_ArraySwap($Datei_pfad, $Quellindex, $Zielindex)


	;Tabs neu konfigurieren
	_GUICtrlTab_SetItemText($htab, $Quellindex, $Ziel_State[1])
	_GUICtrlTab_SetItemText($htab, $Zielindex, $Quelle_State[1])

	_GUICtrlTab_SetItemImage($htab, $Quellindex, $Ziel_State[2])
	_GUICtrlTab_SetItemImage($htab, $Zielindex, $Quelle_State[2])

	_GUICtrlTab_SetCurSel($htab, $Zielindex)
	_Show_Tab($Zielindex)
	_Check_Buttons()
EndFunc   ;==>_Tabseiten_austauschen


Func _return_FileIcon($filetype)
	If $filetype = "wmv" Then Return 2
	If $filetype = "avi" Then Return 2
	If $filetype = "mpg" Then Return 2
	If $filetype = "mpeg" Then Return 2
	If $filetype = "divx" Then Return 2
	If $filetype = "mkv" Then Return 2
	If $filetype = "wav" Then Return 3
	If $filetype = "mp3" Then Return 3
	If $filetype = "exe" Then Return 4
	If $filetype = "bat" Then Return 17
	If $filetype = "bmp" Then Return 6
	If $filetype = "ico" Then Return 16
	If $filetype = "jpg" Then Return 6
	If $filetype = "jpeg" Then Return 6
	If $filetype = "png" Then Return 6
	If $filetype = "doc" Then Return 7
	If $filetype = "ppt" Then Return 8
	If $filetype = "xls" Then Return 9
	If $filetype = $Autoitextension Then Return 10
	If $filetype = "txt" Then Return 11
	If $filetype = "isf" Then Return 12
	If $filetype = "ini" Then Return 13
	If $filetype = "inf" Then Return 13
	If $filetype = "isn" Then Return 14
	If $filetype = "dll" Then Return 15

	Return 1

EndFunc   ;==>_return_FileIcon

Func _IsReparsePoint($FLS) ; progandy
	Dim Static $K32 = DllOpen('kernel32.dll')
	Dim $DA = DllCall($K32, 'dword', 'GetFileAttributesW', 'wstr', $FLS)

	If @error Then Return SetError(1, @error, False)
	Return BitAND($DA[0], 1024) = 1024
EndFunc   ;==>_IsReparsePoint

Func _GUICtrlTab_ActivateTabX($hWnd, $iIndex, $rebildtree = 1)
	If _GUICtrlTab_GetItemCount($hWnd) = 0 Then Return
	_GUICtrlTab_SetCurSel($hWnd, $iIndex)
	If $rebildtree = 1 Then _Check_Buttons()
EndFunc   ;==>_GUICtrlTab_ActivateTabX

Func _Try_to_import_folder()

	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(455), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
	If @error Or $var = "" Then
		Return
	Else
		$Count = 0
		If $Studiomodus = 1 Then
			$res = _WinAPI_BrowseForFolderDlg($Offenes_Projekt, _Get_langstr(59), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
		Else
			$res = _WinAPI_BrowseForFolderDlg("", _Get_langstr(59), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
		EndIf
		If @error Or $res = "" Then
			Return
		Else
			_FileOperationProgress($var & "\*.*", $res, 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			If @extended == 1 Then ;ERROR
				Return
			EndIf
			_Write_log($var & " " & _Get_langstr(63))
		EndIf
	EndIf

	FileChangeDir(@ScriptDir)
	;_Update_Treeview()

	_Show_Warning("confirmimportfolder", 9, _Get_langstr(61), _Get_langstr(456), _Get_langstr(7))
EndFunc   ;==>_Try_to_import_folder

Func _Try_to_import_file()
	_Lock_Plugintabs("lock")
	$var = FileOpenDialog(_Get_langstr(57), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(58) & " (*.*)", 1 + 2 + 4, "", $StudioFenster)
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	If @error Then
		Return
	Else
		$Count = 0
		If $Studiomodus = 1 Then
			$res = _WinAPI_BrowseForFolderDlg($Offenes_Projekt, _Get_langstr(59), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
		Else
			$res = _WinAPI_BrowseForFolderDlg("", _Get_langstr(59), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
		EndIf
		If @error Or $res = "" Then
			Return
		Else
			If StringInStr($var, "|") = 0 Then
				$Count = 1
				;FileCopy ($var, $res&"\*.*" , 1)
				_FileOperationProgress($var, $res, 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
				If @extended == 1 Then ;ERROR
					Return
				EndIf
				_Write_log($var & " " & _Get_langstr(63))
			Else
				$Pfad = StringTrimRight($var, (StringLen($var) - StringInStr($var, "|")) + 1)
				$filelist = StringTrimLeft($var, (StringInStr($var, "|"))) & "|"
				$Count = 0
				While StringLen($filelist) > 1
					$Datei = StringTrimRight($filelist, (StringLen($filelist) - StringInStr($filelist, "|")) + 1)
					;FileCopy ($pfad&"\"&$Datei, $res&"\*.*" , 1)
					_FileOperationProgress($Pfad & "\" & $Datei, $res, 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
					_Write_log($Datei & " " & _Get_langstr(63))
					$filelist = StringTrimLeft($filelist, StringInStr($filelist, "|"))
					$Count = $Count + 1
				WEnd
			EndIf

		EndIf
	EndIf
	If $Studiomodus = "2" Then _Update_Treeview()
	;_Update_Treeview()
	_Show_Warning("confirmimportfiles", 9, _Get_langstr(61), $Count & " " & _Get_langstr(60), _Get_langstr(7))
	If $Count > 14 Then _Earn_trophy(7, 2)
EndFunc   ;==>_Try_to_import_file

Func _plugin_send_msg($plugin, $msg = "")
	If $msg = "" Then
		WinSetTitle($plugin, "", "##WAITING##")
	Else
		WinSetTitle($plugin, "", $msg)
	EndIf
EndFunc   ;==>_plugin_send_msg

Func _ShowFileProperties($sFile, $sVerb = "properties", $hWnd = 0)
	; function by Rasim
	; http://www.autoitscript.com/forum/index....p?showtopic=78236&view=findpos

	Local Const $SEE_MASK_INVOKEIDLIST = 0xC
	Local Const $SEE_MASK_NOCLOSEPROCESS = 0x40
	Local Const $SEE_MASK_FLAG_NO_UI = 0x400

	Local $PropBuff, $FileBuff, $SHELLEXECUTEINFO

	$PropBuff = DllStructCreate("char[256]")
	DllStructSetData($PropBuff, 1, $sVerb)

	$FileBuff = DllStructCreate("char[256]")
	DllStructSetData($FileBuff, 1, $sFile)

	$SHELLEXECUTEINFO = DllStructCreate("int cbSize;long fMask;hwnd hWnd;ptr lpVerb;ptr lpFile;ptr lpParameters;ptr lpDirectory;" & _
			"int nShow;int hInstApp;ptr lpIDList;ptr lpClass;hwnd hkeyClass;int dwHotKey;hwnd hIcon;" & _
			"hwnd hProcess")

	DllStructSetData($SHELLEXECUTEINFO, "cbSize", DllStructGetSize($SHELLEXECUTEINFO))
	DllStructSetData($SHELLEXECUTEINFO, "fMask", $SEE_MASK_INVOKEIDLIST)
	DllStructSetData($SHELLEXECUTEINFO, "hwnd", $hWnd)
	DllStructSetData($SHELLEXECUTEINFO, "lpVerb", DllStructGetPtr($PropBuff, 1))
	DllStructSetData($SHELLEXECUTEINFO, "lpFile", DllStructGetPtr($FileBuff, 1))

	$aRet = DllCall("shell32.dll", "int", "ShellExecuteEx", "ptr", DllStructGetPtr($SHELLEXECUTEINFO))
	If $aRet[0] = 0 Then Return SetError(2, 0, 0)

	Return $aRet[0]
EndFunc   ;==>_ShowFileProperties

;1=$sPath is a dir|0=$sPath is not a dir

Func _IsDir($sPath)
	If Not StringInStr(FileGetAttrib($sPath), "D") Then Return False
	Return True
EndFunc   ;==>_IsDir



;==================================================================================================
; Function Name:   _GUICtrlTreeView_ExpandOneLevel($hTreeView [, $hParentItem=0])
; Description::    Ausklappen nur EINER Ebene eines Items, analog zum Mausklick auf '+'
; Parameter(s):    $hTreeView     Handle des TreeView
;                  $hParentItem   Handle des Auszuklappenden Parent-Items
;                                 Standard 0 ==> Handle des ersten Item im TreeView
; Return:          Erfolg         nichts
;                  Fehler         @error 1  -  TreeView enthält kein Item
;                                 @error 2  -  Item hat keine Child-Item
; Note:            Die Funktion sollte zwischen _GUICtrlTreeView_BeginUpdate() und _GUICtrlTreeView_EndUpdate()
;                  ausgeführt werden um ein Flackern zu verhindern
; Author(s):       BugFix (bugfix@autoit.de)
;==================================================================================================

Func _GUICtrlTreeView_ExpandOneLevel($hTreeView, $hParentItem = 0)
	If $hParentItem < 1 Then
		Local $hCurrentItem = _GUICtrlTreeView_GetFirstItem($hTreeView)
	Else
		Local $hCurrentItem = $hParentItem
	EndIf
	If $hCurrentItem = 0 Then Return SetError(1)
	Local $hChild
	Local $countChild = _GUICtrlTreeView_GetChildCount($hTreeView, $hCurrentItem)
	If $countChild = 0 Then Return SetError(2)
	_GUICtrlTreeView_Expand($hTreeView, $hCurrentItem)
	For $i = 1 To $countChild
		If $i = 1 Then
			$hChild = _GUICtrlTreeView_GetFirstChild($hTreeView, $hCurrentItem)
		Else
			$hChild = _GUICtrlTreeView_GetNextSibling($hTreeView, $hChild)
		EndIf
		If _GUICtrlTreeView_GetChildren($hTreeView, $hChild) Then _GUICtrlTreeView_Expand($hTreeView, $hChild, False)
	Next
EndFunc   ;==>_GUICtrlTreeView_ExpandOneLevel


Func _Show_Delete_file_GUI()
	If _GUICtrlTreeView_GetSelection($hTreeView) = 0 Then Return
	If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = $Offenes_Projekt Then Return
	If _WinAPI_PathIsRoot(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Then Return
	$Pfad = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	If _Schuetze_Wichtige_daten($Pfad) = False Then Return
	If _FileInUse($Pfad) = 1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(951), 0, $StudioFenster)
		Return
	EndIf

	$alreadyopen = _GUICtrlTab_FindTab($htab, StringTrimLeft($Pfad, StringInStr($Pfad, "\", 0, -1)))
	If $alreadyopen <> -1 Then
		$res = _ArraySearch($Datei_pfad, $Pfad)
		If $res <> -1 Then
			$alreadyopen = $res
		Else
			$alreadyopen = -1
		EndIf
	EndIf
	If $alreadyopen = -1 Then
		If StringReplace(StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)), StringInStr(_GUICtrlTreeView_GetTree($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)), "|")), $Delim1, $Delim) = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", "#ERROR#") Then Return ;cannot delete root
		GUICtrlSetData($datei_loeschen_text, StringTrimLeft($Pfad, StringInStr($Pfad, "\", 0, -1)) & " " & _Get_langstr(62))
		GUICtrlSetState($datei_loeschen_include_checkbox, $GUI_ENABLE)
		If StringInStr($Pfad, $Autoitextension) Or StringInStr($Pfad, ".isf") Then
			GUICtrlSetState($datei_loeschen_include_checkbox, $GUI_CHECKED)
		Else
			GUICtrlSetState($datei_loeschen_include_checkbox, $GUI_UNCHECKED)
		EndIf
		If $Studiomodus = 2 Or _IsDir($Pfad) = True Then
			GUICtrlSetState($datei_loeschen_include_checkbox, $GUI_UNCHECKED)
			GUICtrlSetState($datei_loeschen_include_checkbox, $GUI_DISABLE)
		EndIf
		GUISetState(@SW_SHOW, $Datei_loeschen_GUI)
		GUISetState(@SW_DISABLE, $StudioFenster)
	Else
		MsgBox(262144 + 16, _Get_langstr(25), StringTrimLeft($Pfad, StringInStr($Pfad, "\", 0, -1)) & " " & _Get_langstr(78), 0, $StudioFenster)
	EndIf
EndFunc   ;==>_Show_Delete_file_GUI

Func _Hide_Delete_file_GUI()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Datei_loeschen_GUI)
EndFunc   ;==>_Hide_Delete_file_GUI


Func _Try_to_delete_file()
	If _GUICtrlTreeView_GetSelection($hTreeView) = 0 Then Return
	If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = $Offenes_Projekt Then Return
	If _WinAPI_PathIsRoot(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Then Return
	$Pfad = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	If _Schuetze_Wichtige_daten($Pfad) = False Then Return
	$Projektbaum_ist_bereit = 0 ;Sperre Projektbaum
	_Hide_Delete_file_GUI()
	_Write_log(StringTrimLeft($Pfad, StringInStr($Pfad, "\", 0, -1)) & " " & _Get_langstr(64))
	If _IsDir($Pfad) = True Then
		DirRemove($Pfad, 1)
	Else
		FileDelete($Pfad)
	EndIf
	If GUICtrlRead($datei_loeschen_include_checkbox) = $GUI_CHECKED Then _Exclude_IT(StringTrimLeft($Pfad, StringInStr($Pfad, "\", 0, -1)))
	;_Update_Treeview()
	If $Studiomodus = "2" Then _Update_Treeview()

	$Projektbaum_ist_bereit = 1
EndFunc   ;==>_Try_to_delete_file


Func _Splitterwerte_speichern()
	If BitAND(WinGetState($Studiofenster, ""), 16) Then Return ;Nicht wenn Minimiert
	;Speichere Prozentwerde der Splitter
	$Studiopos = WinGetClientSize($Studiofenster)
	If Not IsArray($Studiopos) Then Return
	$Pos_Splitter1 = ControlGetPos($StudioFenster, "", $Left_Splitter_X) ;Zwischen projektbaum und Sci
	$Pos_Splitter2 = ControlGetPos($StudioFenster, "", $Right_Splitter_X) ;Zwischen Sci und Skriptbaum
	$Pos_Splitter3 = ControlGetPos($StudioFenster, "", $Middle_Splitter_Y) ;Scintilla output
	$Pos_Splitter4 = ControlGetPos($StudioFenster, "", $Left_Splitter_Y) ;Splitter bei Projektbaum
	;ConsoleWrite((100* $Pos_Splitter1[0])/$Studiopos[0]) &@crlf)
	If $Toggle_Leftside = 0 Then _Write_in_Config("Left_Splitter_X", Round((100 * $Pos_Splitter1[0]) / $Studiopos[0], 2))

	If $hidefunctionstree = "false" And $IS_HIDDEN_RECHTS = 0 And $Toggle_rightside = 0 Then _Write_in_Config("Right_Splitter_X", Round((100 * $Pos_Splitter2[0]) / $Studiopos[0], 2))

	If $hidedebug = "false" And $IS_HIDDEN_UNTEN = 0 Then _Write_in_Config("Middle_Splitter_Y", Round((100 * $Pos_Splitter3[1]) / $Studiopos[1], 2))
	If $hideprogramlog = "false" Then _Write_in_Config("Left_Splitter_Y", Round((100 * $Pos_Splitter4[1]) / $Studiopos[1], 2))

EndFunc   ;==>_Splitterwerte_speichern



Func _Redraw_Window($GUI = $StudioFenster)
	_Splitterwerte_speichern()


	For $i = $Offene_tabs To 1 Step -1
		WinMove($SCE_EDITOR[$i - 1], "", -9000, -9000, Default, Default)
	Next
	_Show_Tab(_GUICtrlTab_GetCurFocus($htab))

	_Rezize()
;~ DLLCAll("user32.dll","int","RedrawWindow","hwnd",$gui,"int",0,"int",0,"int",0x1)
EndFunc   ;==>_Redraw_Window

Func _Repos_HD_Logo()
	If Not IsDeclared("htab") Then Exit
	If _GUICtrlTab_GetItemCount($htab) > 0 Then Return
	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	GUICtrlSetPos($HD_Logo, ($tabsize[0] + ($tabsize[2]) / 2) - (400 / 2), ($tabsize[1] + ($tabsize[3]) / 2) - (400 / 2), 400, 400)
EndFunc   ;==>_Repos_HD_Logo

Func _Status_bar_aktualisiere_Parts()
	Local $size_StudioFenster = WinGetClientSize($StudioFenster)
	If Not IsArray($size_StudioFenster) Then Return
	Local $aParts[2] = [$size_StudioFenster[0] - 25, -1]
	_GUICtrlStatusBar_SetParts($Status_bar, $aParts)
	_GUICtrlStatusBar_SetTipText($Status_bar, 1, _Get_langstr(1141))
EndFunc   ;==>_Status_bar_aktualisiere_Parts

Func _Rezize($no_tabrefresh = 0)

	;Falls gui verkleinert wurde passe Elemente an Fenstergröße an
	_Resize_Elements_to_Window()
	;Falls der Scriptbaum gerade versteckt ist..
	If $Toggle_rightside = 1 And $hidefunctionstree = "false" Then
		$Pos_VSplitter_2 = ControlGetPos($StudioFenster, "", $Right_Splitter_X)
		$winpos = WinGetClientSize($studiofenster)
		GUICtrlSetPos($Right_Splitter_X, $winpos[0] - (30 * $DPI), $Pos_VSplitter_2[1])
		GUICtrlSetPos($Scripttree_title, $winpos[0] - (28 * $DPI), $Toolbar_Size[0] + 3, 20 * $DPI, 150 * $DPI)
	EndIf
	;Aktualisiere die Splitter
	_Aktualisiere_Splittercontrols()
	;Aktualisiere das Logo
	_Repos_HD_Logo()
	;Aktualisiere die Statusbar
	_GUICtrlStatusBar_Resize($Status_bar)
	_Status_bar_aktualisiere_Parts()
	;Aktualisiere Tab
	If $no_tabrefresh = 0 Then _Show_Tab(_GUICtrlTab_GetCurFocus($htab))
EndFunc   ;==>_Rezize


Func _Toggle_Fenster_unten()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $IS_HIDDEN_UNTEN = 1 Then
		If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return
		If $hidedebug = "true" Then Return
		_HIDE_FENSTER_UNTEN("false")
		$Fenster_unten_durch_toggle_versteckt = 0
	Else
		_HIDE_FENSTER_UNTEN("true")
		$Fenster_unten_durch_toggle_versteckt = 1
	EndIf
EndFunc   ;==>_Toggle_Fenster_unten



Func _WINDOW_REBUILD()
;~ 	Sleep(300)
;~ 	GUISetState(@SW_SHOW, $Studiofenster)
;~ 	WinSetOnTop($Studiofenster, "", 1)
;~ 	WinSetOnTop($Studiofenster, "", 0)
	_Rezize(0)
EndFunc   ;==>_WINDOW_REBUILD

Func _HIDE_FENSTER_RECHTS($state = "")
	If $state = "" Then $state = $hidefunctionstree
	If $hidefunctionstree = "true" Then $state = $hidefunctionstree
	$winpos = WinGetPos($studiofenster)
	$winpos_client = WinGetClientSize($studiofenster)
	$Pos_VSplitter_2 = ControlGetPos($StudioFenster, "", $Right_Splitter_X)
	If $state = "true" Then ;hide
		If $IS_HIDDEN_RECHTS = 1 Then Return
		If $IS_HIDDEN_RECHTS = 0 Then
			$OLD_X = (100 * $Pos_VSplitter_2[0]) / $winpos_client[0]
			$IS_HIDDEN_RECHTS = 1
		EndIf
		GUICtrlSetPos($Right_Splitter_X, $winpos_client[0] - 2, $Pos_VSplitter_2[1], $Splitter_Breite)
		GUICtrlSetState($Right_Splitter_X, $GUI_HIDE)
		GUICtrlSetState($Scripttree_title, $GUI_HIDE)
		GUICtrlSetState($Skriptbaum_Einstellungen_Button, $GUI_HIDE)
		GUICtrlSetState($Skriptbaum_Aktualisieren_Button, $GUI_HIDE)
	Else
		If $IS_HIDDEN_RECHTS = 0 Then Return
		If $Toggle_rightside = 1 Then
			$Toggle_rightside = 0
			_Toggle_hide_rightbar()
			GUICtrlSetState($Scripttree_title, $GUI_SHOW)
			$IS_HIDDEN_RECHTS = 0
		Else
			If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
			GUICtrlSetPos($Right_Splitter_X, ($winpos_client[0] / 100) * $OLD_X, $Pos_VSplitter_2[1], $Splitter_Breite)
			GUICtrlSetState($Right_Splitter_X, $GUI_SHOW)
			GUICtrlSetState($Scripttree_title, $GUI_SHOW)
			GUICtrlSetState($Skriptbaum_Einstellungen_Button, $GUI_SHOW)
			GUICtrlSetState($Skriptbaum_Aktualisieren_Button, $GUI_SHOW)
			$IS_HIDDEN_RECHTS = 0
		EndIf
	EndIf

	_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind
	_Repos_HD_Logo() ;aktualisiere Logo
EndFunc   ;==>_HIDE_FENSTER_RECHTS

Func _HIDE_FENSTER_UNTEN($state = "")
	If $state = "" Then $state = $hidedebug
	If $hidedebug = "true" Then $state = $hidedebug
	$winpos = WinGetPos($studiofenster)
	$winpos_clientsize = WinGetClientSize($studiofenster)
	$Pos_HSplitter_1 = ControlGetPos($StudioFenster, "", $Middle_Splitter_Y)
	$Pos_Splitter1 = ControlGetPos($StudioFenster, "", $Left_Splitter_X)
	If $state = "true" Then ;hide
;~ if $IS_HIDDEN_UNTEN=1 then return
		If $IS_HIDDEN_UNTEN = 0 Then
			$OLD_Y = (100 * ($Pos_HSplitter_1[1]) / $winpos_clientsize[1])
			$IS_HIDDEN_UNTEN = 1
		EndIf
		GUICtrlSetPos($Middle_Splitter_Y, $Pos_HSplitter_1[0], $winpos_clientsize[1] - 24)
		GUICtrlSetState($Middle_Splitter_Y, $GUI_HIDE)
		GUICtrlSetState($Debug_log, $GUI_HIDE)
		GUICtrlSetState($Debug_Log_Undo_Button, $GUI_HIDE)
		GUICtrlSetState($Debug_Log_Redo_Button, $GUI_HIDE)
		GUICtrlSetState($Debug_Log_Zwischenablage_Button, $GUI_HIDE)
	Else
		If $IS_HIDDEN_UNTEN = 0 Then Return
		;$OLD_Y = int(($winpos_clientsize[1] / 100) * Number(_Config_Read("Middle_Splitter_Y", $Mittlerer_Splitter_Y_default)))
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		GUICtrlSetPos($Middle_Splitter_Y, $Pos_HSplitter_1[0], ($winpos_clientsize[1] / 100) * $OLD_Y)
		GUICtrlSetState($Middle_Splitter_Y, $GUI_SHOW)
		GUICtrlSetState($Debug_log, $GUI_SHOW)
		If $Zeige_Buttons_neben_Debug_Fenster = "true" Then
			GUICtrlSetState($Debug_Log_Undo_Button, $GUI_SHOW)
			GUICtrlSetState($Debug_Log_Redo_Button, $GUI_SHOW)
			GUICtrlSetState($Debug_Log_Zwischenablage_Button, $GUI_SHOW)
		Else
			GUICtrlSetState($Debug_Log_Undo_Button, $GUI_HIDE)
			GUICtrlSetState($Debug_Log_Redo_Button, $GUI_HIDE)
			GUICtrlSetState($Debug_Log_Zwischenablage_Button, $GUI_HIDE)
		EndIf
		$IS_HIDDEN_UNTEN = 0
	EndIf

	_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind
	_Repos_HD_Logo() ;aktualisiere Logo
EndFunc   ;==>_HIDE_FENSTER_UNTEN

Func _Imagelist_replace_icon($hWnd, $toreplace, $sFile, $iIndex = 0)
	Local $pIcon, $tIcon, $hIcon

	$tIcon = DllStructCreate("int Icon")
	$pIcon = DllStructGetPtr($tIcon)
	_WinAPI_ExtractIconEx($sFile, $iIndex, 0, $pIcon, 1)
	$hIcon = DllStructGetData($tIcon, "Icon")
	_GUIImageList_ReplaceIcon($hWnd, $toreplace, $hIcon)
	_WinAPI_DestroyIcon($hIcon)
EndFunc   ;==>_Imagelist_replace_icon

Func _Macroslot_get_name($Slot_id = 0)
	If $Slot_id = 0 Then Return ""
	Local $name = ""
	Switch $Slot_id

		Case 1
			$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger12)
			If @error Then
				Return _Get_langstr(611)
			Else
				$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
				Return $name
			EndIf

		Case 2
			$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger13)
			If @error Then
				Return _Get_langstr(612)
			Else
				$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
				Return $name
			EndIf

		Case 3
			$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger14)
			If @error Then
				Return _Get_langstr(613)
			Else
				$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
				Return $name
			EndIf

		Case 4
			$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger15)
			If @error Then
				Return _Get_langstr(614)
			Else
				$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
				Return $name
			EndIf

		Case 5
			$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger16)
			If @error Then
				Return _Get_langstr(615)
			Else
				$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
				Return $name
			EndIf

		Case 6
			$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger17)
			If @error Then
				Return _Get_langstr(906)
			Else
				$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
				Return $name
			EndIf

		Case 7
			$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger18)
			If @error Then
				Return _Get_langstr(907)
			Else
				$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
				Return $name
			EndIf

	EndSwitch
	Return ""
EndFunc   ;==>_Macroslot_get_name


Func _Reload_Ruleslots()

	;regelslots in Toolbar
	$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger12)
	If @error Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id24), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id24, $TBSTATE_HIDDEN)
		If Not BitAND(GUICtrlGetState($Tools_menu_item3), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item3, $GUI_DISABLE)
		_GUICtrlODMenuItemSetText($Tools_menu_item3, _Get_langstr(611) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot1))
		_GUICtrlODMenuItemSetIcon($Tools_menu_item3, $smallIconsdll, 0)
		_Imagelist_replace_icon($hToolBarImageListNorm, 24, $smallIconsdll, "1")
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id24, 24)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id24), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id24, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($Tools_menu_item3), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_item3, $GUI_ENABLE)
		$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
		_GUICtrlODMenuItemSetText($Tools_menu_item3, $name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot1))
		$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot1", "1")
		$readen_icon = Number($readen_icon)
		If $readen_icon > 1 Then
			$readen_icon = $readen_icon - 1
		Else
			$readen_icon = 0
		EndIf
		_Imagelist_replace_icon($hToolBarImageListNorm, 24, $smallIconsdll, $readen_icon)
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id24, 24)
		_GUICtrlODMenuItemSetIcon($Tools_menu_item3, $smallIconsdll, $readen_icon + 1)
		If IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") <> "active" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id24), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id24, $TBSTATE_HIDDEN)
			If Not BitAND(GUICtrlGetState($Tools_menu_item3), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item3, $GUI_DISABLE)
		EndIf
	EndIf

	$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger13)
	If @error Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id25), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id25, $TBSTATE_HIDDEN)
		If Not BitAND(GUICtrlGetState($Tools_menu_item4), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item4, $GUI_DISABLE)
		_GUICtrlODMenuItemSetText($Tools_menu_item4, _Get_langstr(612) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot2))
		_GUICtrlODMenuItemSetIcon($Tools_menu_item4, $smallIconsdll, 909)
		_Imagelist_replace_icon($hToolBarImageListNorm, 25, $smallIconsdll, "908")
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id25, 25)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id25), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id25, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($Tools_menu_item4), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_item4, $GUI_ENABLE)
		$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
		_GUICtrlODMenuItemSetText($Tools_menu_item4, $name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot2))
		$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot2", "908")
		$readen_icon = Number($readen_icon)
		If $readen_icon > 1 Then
			$readen_icon = $readen_icon - 1
		Else
			$readen_icon = 0
		EndIf
		_Imagelist_replace_icon($hToolBarImageListNorm, 25, $smallIconsdll, $readen_icon)
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id25, 25)
		_GUICtrlODMenuItemSetIcon($Tools_menu_item4, $smallIconsdll, $readen_icon + 1)
		If IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") <> "active" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id25), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id25, $TBSTATE_HIDDEN)
			If Not BitAND(GUICtrlGetState($Tools_menu_item4), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item4, $GUI_DISABLE)
		EndIf
	EndIf

	$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger14)
	If @error Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id26), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id26, $TBSTATE_HIDDEN)
		If Not BitAND(GUICtrlGetState($Tools_menu_item5), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item5, $GUI_DISABLE)
		_GUICtrlODMenuItemSetText($Tools_menu_item5, _Get_langstr(613) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot3))
		_GUICtrlODMenuItemSetIcon($Tools_menu_item5, $smallIconsdll, 1020)
		_Imagelist_replace_icon($hToolBarImageListNorm, 26, $smallIconsdll, "1019")
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id26, 26)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id26), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id26, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($Tools_menu_item5), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_item5, $GUI_ENABLE)
		$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
		_GUICtrlODMenuItemSetText($Tools_menu_item5, $name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot3))
		$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot3", "1019")
		$readen_icon = Number($readen_icon)
		If $readen_icon > 1 Then
			$readen_icon = $readen_icon - 1
		Else
			$readen_icon = 0
		EndIf
		_Imagelist_replace_icon($hToolBarImageListNorm, 26, $smallIconsdll, $readen_icon)
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id26, 26)
		_GUICtrlODMenuItemSetIcon($Tools_menu_item5, $smallIconsdll, $readen_icon + 1)
		If IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") <> "active" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id26), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id26, $TBSTATE_HIDDEN)
			If Not BitAND(GUICtrlGetState($Tools_menu_item5), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item5, $GUI_DISABLE)
		EndIf
	EndIf

	$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger15)
	If @error Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id27), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id27, $TBSTATE_HIDDEN)
		If Not BitAND(GUICtrlGetState($Tools_menu_item6), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item6, $GUI_DISABLE)
		_GUICtrlODMenuItemSetText($Tools_menu_item6, _Get_langstr(614) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot4))
		_GUICtrlODMenuItemSetIcon($Tools_menu_item6, $smallIconsdll, 1130)
		_Imagelist_replace_icon($hToolBarImageListNorm, 27, $smallIconsdll, "1129")
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id27, 27)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id27), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id27, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($Tools_menu_item6), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_item6, $GUI_ENABLE)
		$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
		_GUICtrlODMenuItemSetText($Tools_menu_item6, $name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot4))
		$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot4", "1129")
		$readen_icon = Number($readen_icon)
		If $readen_icon > 1 Then
			$readen_icon = $readen_icon - 1
		Else
			$readen_icon = 0
		EndIf
		_Imagelist_replace_icon($hToolBarImageListNorm, 27, $smallIconsdll, $readen_icon)
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id27, 27)
		_GUICtrlODMenuItemSetIcon($Tools_menu_item6, $smallIconsdll, $readen_icon + 1)
		If IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") <> "active" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id27), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id27, $TBSTATE_HIDDEN)
			If Not BitAND(GUICtrlGetState($Tools_menu_item6), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item6, $GUI_DISABLE)
		EndIf
	EndIf

	$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger16)
	If @error Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id28), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id28, $TBSTATE_HIDDEN)
		If Not BitAND(GUICtrlGetState($Tools_menu_item7), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item7, $GUI_DISABLE)
		_GUICtrlODMenuItemSetText($Tools_menu_item7, _Get_langstr(615) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot5))
		_GUICtrlODMenuItemSetIcon($Tools_menu_item7, $smallIconsdll, 1241)
		_Imagelist_replace_icon($hToolBarImageListNorm, 28, $smallIconsdll, "1240")
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id28, 28)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id28), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id28, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($Tools_menu_item7), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_item7, $GUI_ENABLE)
		$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
		_GUICtrlODMenuItemSetText($Tools_menu_item7, $name)
		$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot5", "1240")
		$readen_icon = Number($readen_icon)
		If $readen_icon > 1 Then
			$readen_icon = $readen_icon - 1
		Else
			$readen_icon = 0
		EndIf
		_Imagelist_replace_icon($hToolBarImageListNorm, 28, $smallIconsdll, $readen_icon)
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $id28, 28)
		_GUICtrlODMenuItemSetIcon($Tools_menu_item7, $smallIconsdll, $readen_icon + 1)
		If IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") <> "active" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id28), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $id28, $TBSTATE_HIDDEN)
			If Not BitAND(GUICtrlGetState($Tools_menu_item7), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item7, $GUI_DISABLE)
		EndIf
	EndIf


	$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger17)
	If @error Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $Toolbar_makroslot6), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $Toolbar_makroslot6, $TBSTATE_HIDDEN)
		If Not BitAND(GUICtrlGetState($Tools_menu_item9), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item9, $GUI_DISABLE)
		_GUICtrlODMenuItemSetText($Tools_menu_item9, _Get_langstr(906) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot6))
		_GUICtrlODMenuItemSetIcon($Tools_menu_item9, $smallIconsdll, 1345)
		_Imagelist_replace_icon($hToolBarImageListNorm, 30, $smallIconsdll, "1344")
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $Toolbar_makroslot6, 30)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $Toolbar_makroslot6), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $Toolbar_makroslot6, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($Tools_menu_item9), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_item9, $GUI_ENABLE)
		$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
		_GUICtrlODMenuItemSetText($Tools_menu_item9, $name)
		$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot6", "1344")
		$readen_icon = Number($readen_icon)
		If $readen_icon > 1 Then
			$readen_icon = $readen_icon - 1
		Else
			$readen_icon = 0
		EndIf
		_Imagelist_replace_icon($hToolBarImageListNorm, 30, $smallIconsdll, $readen_icon)
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $Toolbar_makroslot6, 30)
		_GUICtrlODMenuItemSetIcon($Tools_menu_item9, $smallIconsdll, $readen_icon + 1)
		If IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") <> "active" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $Toolbar_makroslot6), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $Toolbar_makroslot6, $TBSTATE_HIDDEN)
			If Not BitAND(GUICtrlGetState($Tools_menu_item9), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item9, $GUI_DISABLE)
		EndIf
	EndIf

	$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger18)
	If @error Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $Toolbar_makroslot7), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $Toolbar_makroslot7, $TBSTATE_HIDDEN)
		If Not BitAND(GUICtrlGetState($Tools_menu_item10), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item10, $GUI_DISABLE)
		_GUICtrlODMenuItemSetText($Tools_menu_item10, _Get_langstr(907) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot7))
		_GUICtrlODMenuItemSetIcon($Tools_menu_item10, $smallIconsdll, 1456)
		_Imagelist_replace_icon($hToolBarImageListNorm, 31, $smallIconsdll, "1455")
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $Toolbar_makroslot7, 31)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $Toolbar_makroslot7), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $Toolbar_makroslot7, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($Tools_menu_item10), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_item10, $GUI_ENABLE)
		$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
		_GUICtrlODMenuItemSetText($Tools_menu_item10, $name)
		$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot7", "1455")
		$readen_icon = Number($readen_icon)
		If $readen_icon > 1 Then
			$readen_icon = $readen_icon - 1
		Else
			$readen_icon = 0
		EndIf
		_Imagelist_replace_icon($hToolBarImageListNorm, 31, $smallIconsdll, $readen_icon)
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $Toolbar_makroslot7, 31)
		_GUICtrlODMenuItemSetIcon($Tools_menu_item10, $smallIconsdll, $readen_icon + 1)
		If IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") <> "active" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $Toolbar_makroslot7), $TBSTATE_HIDDEN) = $TBSTATE_HIDDEN Then _GUICtrlToolbar_SetButtonState($hToolbar, $Toolbar_makroslot7, $TBSTATE_HIDDEN)
			If Not BitAND(GUICtrlGetState($Tools_menu_item10), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item10, $GUI_DISABLE)
		EndIf
	EndIf

	If $DPI <> 1 Then _GUICtrlToolbar_SetButtonSize($hToolbar, 24 * $DPI, 22 * $DPI)
	_Erstelle_Kontextmenu_fuer_Projektbaum() ;Aktualisiere Kontextmenü des Projektbaumes
EndFunc   ;==>_Reload_Ruleslots

Func _deaktiviere_Buttons_fuer_Editormodus()
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	;Deaktiviere einige Optionen im Editormodus
	If $Studiomodus = 2 Then
		If Not BitAND(GUICtrlGetState($ProjectMenu_item4), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item4, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_projekteinstellungen), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_projekteinstellungen, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($FileMenu_item6), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($FileMenu_item6, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($TreeviewContextMenu_temp_au3_file), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($TreeviewContextMenu_temp_au3_file, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item8a), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item8a, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item8b), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item8b, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item11a), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item11a, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item11b), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item11b, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($FileMenu_Neue_Datei_temp_au3file), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($FileMenu_Neue_Datei_temp_au3file, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_Kompilieren_Daten_auswaehlen), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_Kompilieren_Daten_auswaehlen, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($HelpMenu_item3), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($HelpMenu_item3, $GUI_DISABLE)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id9), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id9, $TBSTATE_INDETERMINATE)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id4), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id4, $TBSTATE_INDETERMINATE)
		_GUICtrlODMenuItemSetText($ProjectMenu_item8, _Get_langstr(82))
		_GUICtrlODMenuItemSetText($FileMenu_item13, _Get_langstr(665))
		_GUICtrlODMenuItemSetText($ProjectMenu_item3, _Get_langstr(665))
		_GUICtrlToolbar_SetButtonText($hToolbar, $Toolbarmenu_closeproject, _Get_langstr(665))
		_GUICtrlODMenuItemSetText($ProjectMenu_item8a, _Get_langstr(668) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt))
		_GUICtrlODMenuItemSetText($ProjectMenu_item11, _Get_langstr(601))
		_GUICtrlODMenuItemSetText($ProjectMenu_item11a, _Get_langstr(601) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile))
		_GUICtrlODMenuItemSetText($ProjectMenu_item8b, _Get_langstr(669) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter))
		If Not _GUICtrlTab_GetItemCount($htab) = 0 And $GUICtrlTab_GetCurFocus <> -1 Then
			If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then
				If Not BitAND(GUICtrlGetState($ProjectMenu_item11a), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item11a, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($ProjectMenu_item11b), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item11b, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($ProjectMenu_item8a), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item8a, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($ProjectMenu_item8b), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item8b, $GUI_ENABLE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id21), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id21, $TBSTATE_ENABLED)
			EndIf
		EndIf

	Else
		If Not BitAND(GUICtrlGetState($ProjectMenu_item11a), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item11a, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item11b), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item11b, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($FileMenu_Neue_Datei_temp_au3file), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_Neue_Datei_temp_au3file, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($TreeviewContextMenu_temp_au3_file), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($TreeviewContextMenu_temp_au3_file, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_Kompilieren_Daten_auswaehlen), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_Kompilieren_Daten_auswaehlen, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item4), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item4, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_projekteinstellungen), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_projekteinstellungen, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($FileMenu_item6), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item6, $GUI_ENABLE)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id9), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id9, $TBSTATE_ENABLED)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id4), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id4, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item8), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item8, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item8b), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item8b, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($HelpMenu_item3), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($HelpMenu_item3, $GUI_ENABLE)
		_GUICtrlODMenuItemSetText($FileMenu_item13, _Get_langstr(41))
		_GUICtrlToolbar_SetButtonText($hToolbar, $Toolbarmenu_closeproject, _Get_langstr(41))
		_GUICtrlODMenuItemSetText($ProjectMenu_item3, _Get_langstr(41))
		_GUICtrlODMenuItemSetText($ProjectMenu_item8, _Get_langstr(489))
		_GUICtrlODMenuItemSetText($ProjectMenu_item8a, _Get_langstr(50) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt))
		_GUICtrlODMenuItemSetText($ProjectMenu_item8b, _Get_langstr(488) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter))
		_GUICtrlODMenuItemSetText($ProjectMenu_item11, _Get_langstr(52))
		_GUICtrlODMenuItemSetText($ProjectMenu_item11a, _Get_langstr(52) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile))
	EndIf

EndFunc   ;==>_deaktiviere_Buttons_fuer_Editormodus







Func _Toolbars_Layout_erkennen()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return "none"
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return "none"
	If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then Return "au3"
	If $Plugin_Handle[$GUICtrlTab_GetCurFocus] <> "-1" Then Return "plugin"
	If $Plugin_Handle[$GUICtrlTab_GetCurFocus] = "-1" Then Return "text"
	Return "none"
EndFunc   ;==>_Toolbars_Layout_erkennen



Func _Check_Buttons($buildtree = 1)
	AdlibUnRegister("_Check_Buttons")


	If $Erweitertes_debugging = "true" Then
		If Not BitAND(GUICtrlGetState($Tools_menu_debugging_erweitertes_debugging_aktivieren), $GUI_CHECKED) = $GUI_CHECKED Then GUICtrlSetState($Tools_menu_debugging_erweitertes_debugging_aktivieren, $GUI_CHECKED)
		If Not BitAND(GUICtrlGetState($Tools_menu_debugging_erweitertes_debugging_deaktivieren), $GUI_UNCHECKED) = $GUI_UNCHECKED Then GUICtrlSetState($Tools_menu_debugging_erweitertes_debugging_deaktivieren, $GUI_UNCHECKED)
	Else
		If Not BitAND(GUICtrlGetState($Tools_menu_debugging_erweitertes_debugging_aktivieren), $GUI_UNCHECKED) = $GUI_UNCHECKED Then GUICtrlSetState($Tools_menu_debugging_erweitertes_debugging_aktivieren, $GUI_UNCHECKED)
		If Not BitAND(GUICtrlGetState($Tools_menu_debugging_erweitertes_debugging_deaktivieren), $GUI_CHECKED) = $GUI_CHECKED Then GUICtrlSetState($Tools_menu_debugging_erweitertes_debugging_deaktivieren, $GUI_CHECKED)
	EndIf

	$Automatische_Speicherung_eingabecounter = 0 ;Eingabecounter resetten

	;Benötigtes Layout ermitteln (zb. werden bei Plugins diverse Buttons deaktiviert)
	;Ist das benötigte Layout <> $Toolbars_Aktuelles_Layout werden die Buttons aktuallisiert (flackern in der GUI)
	;none = Layout wenn keine Tabs geöffnet sind
	;au3 = Layout wenn eine AutoIt Datei geöffnet ist
	;text = Layout wenn eine text Datei geöffnet ist
	;plugin = Layout wenn ein Plugin geöffnet ist
	$benoetigtes_Layout = _Toolbars_Layout_erkennen()
	If $benoetigtes_Layout <> $Toolbars_Aktuelles_Layout Then ;Layout nur refreshen wenn nötig

		Switch $benoetigtes_Layout

			Case "none"
				$Toolbars_Aktuelles_Layout = $benoetigtes_Layout
				_GUICtrlToolbar_SetButtonState($hToolbar, $id12, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id14, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id15, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id11, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id16, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id17, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id18, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id21, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_INDETERMINATE)
				GUICtrlSetState($EditMenu_item1, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item2, $GUI_DISABLE)
				GUICtrlSetState($FileMenu_item1b, $GUI_DISABLE)
				GUICtrlSetState($FileMenu_item1d, $GUI_DISABLE)
				GUICtrlSetState($FileMenu_item1c, $GUI_DISABLE)
				GUICtrlSetState($FileMenu_item1, $GUI_DISABLE)
				GUICtrlSetState($Dateimenue_Drucken, $GUI_DISABLE)
				GUICtrlSetState($AnsichtMenu_fenster_unten_umschalten, $GUI_DISABLE)
				GUICtrlSetState($AnsichtMenu_fenster_rechts_umschalten, $GUI_DISABLE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_INDETERMINATE)
				_GUICtrlToolbar_SetButtonState($hToolbar, $id13, $TBSTATE_INDETERMINATE)
				GUICtrlSetState($FileMenu_TabSchliessen, $GUI_DISABLE)
				GUICtrlSetState($TabContextMenu_Item1, $GUI_DISABLE)
				GUICtrlSetState($ProjectMenu_item9, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item7, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item1, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item2, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item3, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item4, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item5, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item6, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item7, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item8, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item9, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item10, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item11, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_Kommentare_ausblenden, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_item12, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_Zeilen_nach_oben_verschieben, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_Zeilen_nach_unten_verschieben, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_zeile_duplizieren, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_springe_zu_func, $GUI_DISABLE)
				GUICtrlSetState($Tools_menu_item1, $GUI_DISABLE)
				GUICtrlSetState($Tools_menu_debugging, $GUI_DISABLE)
				GUICtrlSetState($Tools_menu_createUDFheader, $GUI_DISABLE)
				GUICtrlSetState($Tools_menu_AutoIt3Wrapper_GUI, $GUI_DISABLE)
;~ 	GUICtrlSetState($Tools_menu_organizeincludes, $GUI_DISABLE)
				GUICtrlSetState($Tools_menu_ParameterEditor, $GUI_DISABLE)
				GUICtrlSetState($EditMenu_zeile_bookmarken_Main, $GUI_DISABLE)


			Case "text"
				$Toolbars_Aktuelles_Layout = $benoetigtes_Layout
				;aktivieren
				If Not BitAND(GUICtrlGetState($Dateimenue_Drucken), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Dateimenue_Drucken, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1c), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1c, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item3), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item3, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item4), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item4, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item5), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item5, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item6), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item6, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item7), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item7, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item8), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item8, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item9), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item9, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($TabContextMenu_Item1), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($TabContextMenu_Item1, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item10), $EditMenu_zeile_duplizieren) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_zeile_duplizieren, $GUI_ENABLE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id16), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id16, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_ENABLED)
				If Not BitAND(GUICtrlGetState($EditMenu_zeile_duplizieren), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_zeile_duplizieren, $GUI_ENABLE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id13), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id13, $TBSTATE_ENABLED)
				If Not BitAND(GUICtrlGetState($FileMenu_TabSchliessen), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_TabSchliessen, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1d), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1d, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_zeile_bookmarken_Main), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_zeile_bookmarken_Main, $GUI_ENABLE)


				;Deaktivieren
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id14), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id14, $TBSTATE_INDETERMINATE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id17), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id17, $TBSTATE_INDETERMINATE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id18), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id18, $TBSTATE_INDETERMINATE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id21), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id21, $TBSTATE_INDETERMINATE)
				If Not BitAND(GUICtrlGetState($EditMenu_springe_zu_func), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_springe_zu_func, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item11), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item11, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item12), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item12, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item8), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item8, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item10), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item10, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_debugging_debugtoMsgBox), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_debugging_debugtoMsgBox, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_debugging_debugtoConsole), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_debugging_debugtoConsole, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_item1), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item1, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_createUDFheader), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_createUDFheader, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_AutoIt3Wrapper_GUI), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_AutoIt3Wrapper_GUI, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_ParameterEditor), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_ParameterEditor, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($ProjectMenu_item9), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item9, $GUI_DISABLE)



			Case "au3"
				$Toolbars_Aktuelles_Layout = $benoetigtes_Layout
				;aktivieren
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id16), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id16, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id13), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id13, $TBSTATE_ENABLED)
				If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1d), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1d, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1c), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1c, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_TabSchliessen), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_TabSchliessen, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($ProjectMenu_item9), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item9, $GUI_ENABLE)
				If $hidedebug = "false" Then GUICtrlSetState($AnsichtMenu_fenster_unten_umschalten, $GUI_ENABLE)
				If $hidefunctionstree = "false" Then GUICtrlSetState($AnsichtMenu_fenster_rechts_umschalten, $GUI_ENABLE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id21), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id21, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id17), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id17, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id18), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id18, $TBSTATE_ENABLED)
				If Not BitAND(GUICtrlGetState($EditMenu_item10), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item10, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item11), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item11, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item12), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item12, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_springe_zu_func), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_springe_zu_func, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_item1), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_item1, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_debugging), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_debugging, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_createUDFheader), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_createUDFheader, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_AutoIt3Wrapper_GUI), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_AutoIt3Wrapper_GUI, $GUI_ENABLE)
;~ GUICtrlSetState($Tools_menu_organizeincludes, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_ParameterEditor), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Tools_menu_ParameterEditor, $GUI_ENABLE)

				If Not BitAND(GUICtrlGetState($EditMenu_zeile_duplizieren), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_zeile_duplizieren, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($Dateimenue_Drucken), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($Dateimenue_Drucken, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item3), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item3, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item4), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item4, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item5), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item5, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item6), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item6, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item7), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item7, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item8), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item8, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item9), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item9, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item11), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item11, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item12), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_item12, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1c), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1c, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_Kommentare_ausblenden), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_Kommentare_ausblenden, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_Zeilen_nach_oben_verschieben), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_Zeilen_nach_oben_verschieben, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_Zeilen_nach_unten_verschieben), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_Zeilen_nach_unten_verschieben, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_zeile_bookmarken_Main), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_zeile_bookmarken_Main, $GUI_ENABLE)


				;Deaktivieren

			Case "plugin"
				$Toolbars_Aktuelles_Layout = $benoetigtes_Layout
				;aktivieren
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id10), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id29), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_ENABLED)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id13), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id13, $TBSTATE_ENABLED)
				If Not BitAND(GUICtrlGetState($TabContextMenu_Item1), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($TabContextMenu_Item1, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1b), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_TabSchliessen), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_TabSchliessen, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1d), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1d, $GUI_ENABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)


				;Deaktivieren
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id16), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id16, $TBSTATE_INDETERMINATE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id14), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id14, $TBSTATE_INDETERMINATE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id17), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id17, $TBSTATE_INDETERMINATE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id18), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id18, $TBSTATE_INDETERMINATE)
				If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id21), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id21, $TBSTATE_INDETERMINATE)
				If Not BitAND(GUICtrlGetState($EditMenu_springe_zu_func), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_springe_zu_func, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item11), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item11, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item12), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item12, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item8), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item8, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item10), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item10, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_debugging_debugtoMsgBox), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_debugging_debugtoMsgBox, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_debugging_debugtoConsole), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_debugging_debugtoConsole, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_item1), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_item1, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_createUDFheader), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_createUDFheader, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_AutoIt3Wrapper_GUI), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_AutoIt3Wrapper_GUI, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Tools_menu_ParameterEditor), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Tools_menu_ParameterEditor, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item7), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item7, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item9), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item9, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_zeile_duplizieren), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_zeile_duplizieren, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($Dateimenue_Drucken), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($Dateimenue_Drucken, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item3), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item3, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item4), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item4, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item5), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item5, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item6), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item6, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item7), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item7, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item8), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item8, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item9), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item9, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item11), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item11, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_item12), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_item12, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($FileMenu_item1c), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($FileMenu_item1c, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($ProjectMenu_item9), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item9, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_Kommentare_ausblenden), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($EditMenu_Kommentare_ausblenden, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_Zeilen_nach_oben_verschieben), $GUI_DISABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_Zeilen_nach_oben_verschieben, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_Zeilen_nach_unten_verschieben), $GUI_DISABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_Zeilen_nach_unten_verschieben, $GUI_DISABLE)
				If Not BitAND(GUICtrlGetState($EditMenu_zeile_bookmarken_Main), $GUI_DISABLE) = $GUI_ENABLE Then GUICtrlSetState($EditMenu_zeile_bookmarken_Main, $GUI_DISABLE)




		EndSwitch

	EndIf

	_GUICtrlToolbar_SetButtonSize($hToolbar, 24 * $DPI, 22 * $DPI)
	_Check_tabs_for_changes()
;~ 	If $Offenes_Projekt <> "" Then _Reload_Ruleslots()


	If $SKRIPT_LAUEFT = 1 Then
		If $Toolbars_Aktuelles_Layout = "au3" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id14), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id14, $TBSTATE_INDETERMINATE)
			If Not BitAND(GUICtrlGetState($ProjectMenu_item9), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item9, $GUI_DISABLE)
		EndIf
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id15), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id15, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item10), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item10, $GUI_ENABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item8), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item8, $GUI_DISABLE)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id7), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id7, $TBSTATE_INDETERMINATE)

	Else
		If $Toolbars_Aktuelles_Layout = "au3" Then
			If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id14), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id14, $TBSTATE_ENABLED)
			If Not BitAND(GUICtrlGetState($ProjectMenu_item9), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item9, $GUI_ENABLE)
		EndIf
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id15), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id15, $TBSTATE_INDETERMINATE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item10), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item10, $GUI_DISABLE)
		If Not BitAND(GUICtrlGetState($ProjectMenu_item8), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item8, $GUI_ENABLE)
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id7), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id7, $TBSTATE_ENABLED)
	EndIf
;~ 	_deaktiviere_Buttons_fuer_Editormodus()

	If _GUICtrlTab_GetCurFocus($htab) = -1 Or _GUICtrlTab_GetItemCount($htab) = 0 Then
		_deaktiviere_Buttons_fuer_Editormodus()
		Return
	EndIf

	If _GUICtrlTab_GetItemCount($htab) < 1 Then Return
	If Not IsDeclared("buildtree") Then $buildtree = 1
	If $buildtree = 1 Then AdlibRegister("_Build_Scripttree") ;_Build_Scripttree(stringtrimleft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], stringinstr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], "\", 0, -1)), _GUICtrlTab_GetCurFocus($htab))
EndFunc   ;==>_Check_Buttons

Func _Schuetze_Wichtige_daten($file)
	If $file = @DesktopDir Then Return False
	If $file = @MyDocumentsDir Then Return False
	If $file = _ISN_Variablen_aufloesen($Projectfolder) Then Return False

	If $file = $Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#") Then
		MsgBox(262144 + 16, _Get_langstr(25), StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " " & _Get_langstr(119), 0, $StudioFenster)
		Return False
	EndIf

	If $file = $Pfad_zur_Project_ISN Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(120), 0, $StudioFenster)
		Return False
	EndIf
	Return True
EndFunc   ;==>_Schuetze_Wichtige_daten

Func _Try_to_move_file()
	If _GUICtrlTreeView_GetSelection($hTreeView) = 0 Then Return
	If _WinAPI_PathIsRoot(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Then Return
	$file = _GUICtrlTVExplorer_GetSelected($hWndTreeview)

	$alreadyopen = _GUICtrlTab_FindTab($htab, StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	If $alreadyopen <> -1 Then
		$res = _ArraySearch($Datei_pfad, $file)
		If $res <> -1 Then
			$alreadyopen = $res
		Else
			$alreadyopen = -1
		EndIf
	EndIf
	If $alreadyopen = -1 Then
		$sourcefile = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
		If _Schuetze_Wichtige_daten($sourcefile) = False Then Return
		If _FileInUse($sourcefile) = 1 Then
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(951), 0, $StudioFenster)
			Return
		EndIf
		If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = $Offenes_Projekt Then Return
		If $Studiomodus = 1 Then
			$destenationfolder = _WinAPI_BrowseForFolderDlg($Offenes_Projekt, _Get_langstr(152), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
		Else
			$destenationfolder = _WinAPI_BrowseForFolderDlg("", _Get_langstr(152), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
		EndIf
		If @error Or $destenationfolder = "" Then
			Return
		Else
			If StringInStr(FileGetAttrib($sourcefile), "D") Then
				DirMove($sourcefile, $destenationfolder & "\", 1)
			Else
				FileMove($sourcefile, $destenationfolder, 0)
			EndIf
		EndIf

		;_Update_Treeview()
	Else
		MsgBox(262144 + 16, _Get_langstr(25), StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " " & _Get_langstr(78), 0, $StudioFenster)
	EndIf
EndFunc   ;==>_Try_to_move_file

Func _Projektdatei_umbenennen()
	$Dateiname = StringTrimLeft($Pfad_zur_Project_ISN, StringInStr($Pfad_zur_Project_ISN, "\", 0, -1))
	$neuer_Dateiname = InputBox(_Get_langstr(1117), _Get_langstr(1117), StringReplace($Dateiname, ".isn", ""), "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $StudioFenster)
	If $neuer_Dateiname = "" Then Return
	If @error > 0 Then Return
	$neuer_Dateiname = StringReplace($neuer_Dateiname, ".", "")
	$neuer_Dateiname = StringReplace($neuer_Dateiname, ".isn", "")
	FileMove($Pfad_zur_Project_ISN, $Offenes_Projekt & "\" & $neuer_Dateiname & ".isn", 0)
	If @error Then Return
	$Projektbaum_ist_bereit = 0 ;Sperre Projektbaum
	$Pfad_zur_Project_ISN = $Offenes_Projekt & "\" & $neuer_Dateiname & ".isn"
	;_Update_Treeview()
	Sleep(250)
	$Projektbaum_ist_bereit = 1 ;Sperre Projektbaum
EndFunc   ;==>_Projektdatei_umbenennen




Func _Rename_File()
	If $Offenes_Projekt = "" Then Return
	If _GuiCtrlGetFocus($Studiofenster) <> $hTreeView Then Return ;Prüfe ob Projektbaum überhaupt den Fokus besitzt
	If _GUICtrlTreeView_GetSelection($hTreeView) = 0 Then Return
	If _WinAPI_PathIsRoot(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Then Return
;~ 	if StringReplace(StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview, _GUICtrlTreeView_GetSelection($hTreeview)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview, _GUICtrlTreeView_GetSelection($hTreeview)), "|")), $Delim1, $Delim) = iniread($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", "#ERROR#") then
	If $Offenes_Projekt = _GUICtrlTVExplorer_GetSelected($hWndTreeview) Then
		_Zeige_Projekteinstellungen("projectproperties")
		_Rename_Project()
		Return ;cannot rename root
	EndIf

	$file = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	If $file = $Pfad_zur_Project_ISN Then
		_Projektdatei_umbenennen()
		Return
	EndIf


	$oldname = StringTrimLeft($file, StringInStr($file, "\", 0, -1))
	If _Schuetze_Wichtige_daten($file) = False Then Return
	If _FileInUse($file) = 1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(951), 0, $StudioFenster)
		Return
	EndIf
	$alreadyopen = _GUICtrlTab_FindTab($htab, StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	If $alreadyopen <> -1 Then
		$res = _ArraySearch($Datei_pfad, $file)
		If $res <> -1 Then
			$alreadyopen = $res
		Else
			$alreadyopen = -1
		EndIf
	EndIf

	$Projektbaum_ist_bereit = 0 ;Sperre Projektbaum

	If $alreadyopen = -1 Then
		If StringInStr(FileGetAttrib($file), "D") Then
			$line = InputBox(_Get_langstr(145), _Get_langstr(145), $oldname, "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $StudioFenster)
			If $line = "" Then Return
			If @error > 0 Then Return
			DirMove($file, StringTrimRight($file, StringLen($oldname)) & $line, 1)
		Else
			$line = InputBox(_Get_langstr(117), _Get_langstr(118), $oldname, "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $StudioFenster)
			If $line = "" Then Return
			If @error > 0 Then Return
			FileMove($file, StringTrimRight($file, StringLen($oldname)) & $line, 0)

		EndIf
		If $file = StringTrimRight($file, StringLen($oldname)) & $line Then
			Sleep(250)
			$Projektbaum_ist_bereit = 1
			Return
		EndIf

		If $Studiomodus = "2" Then _Update_Treeview()
;~ 		_GUICtrlTreeView_BeginUpdate($hTreeView)
;~ 		_Speichere_TVExplorer($hTreeView) ;Speichere geöffnete Elemente
;~ 		_GUICtrlTVExplorer_AttachFolder($hTreeView)
;~ 		_GUICtrlTVExplorer_Expand($hTreeView, StringTrimRight($file, StringLen($oldname)) & $line, 1)
;~ 		_Lade_TVExplorer($hTreeView) ;Geöffnete Elemente wiederherstellen
;~ 		_GUICtrlTreeView_EndUpdate($hTreeView)

	Else
		MsgBox(262144 + 16, _Get_langstr(25), StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " " & _Get_langstr(78), 0, $StudioFenster)
	EndIf
	FileChangeDir(@ScriptDir)
	Sleep(250)
	$Projektbaum_ist_bereit = 1
EndFunc   ;==>_Rename_File

Func _Export_File()
	If _GUICtrlTreeView_GetSelection($hTreeView) = 0 Then Return
	If $Studiomodus = 2 Then Return
	If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = $Offenes_Projekt Then Return
	$file = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	$filename = StringTrimLeft($file, StringInStr($file, "\", 0, -1))
	If StringInStr(FileGetAttrib($file), "D") Then
		_Lock_Plugintabs("lock")
		$line = FileSaveDialog(_Get_langstr(146), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All (*.*)", 18, $filename, $StudioFenster)
		_Lock_Plugintabs("unlock")
		If $line = "" Then Return
		If @error > 0 Then Return
		;dircopy($file,$line,1)
		_FileOperationProgress($file & "\*.*", $line, 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
		If @extended == 1 Then ;ERROR
			Return
		EndIf
	Else
		_Lock_Plugintabs("lock")
		$line = FileSaveDialog(_Get_langstr(73), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All (*.*)", 18, $filename, $StudioFenster)
		_Lock_Plugintabs("unlock")
		If $line = "" Then Return
		If @error > 0 Then Return
		;filecopy($file,$line,1)
		$line = StringTrimRight($line, StringLen($line) - StringInStr($line, "\", 0, -1))
		_FileOperationProgress($file, $line, 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
		If @extended == 1 Then ;ERROR
			Return
		EndIf

	EndIf
	_Write_log($filename & " " & _Get_langstr(147))
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $StudioFenster)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>_Export_File

Func _Add_File_to_Backuplist($str)
	$file = FileOpen($Backupcache, 9 + $FO_ANSI)
	If $file = -1 Then
		MsgBox(0, "Error", "Can not add file to backupcache! Maybe you do not have write access to this folder!")
	EndIf
	FileWriteLine($file, $str)
	FileClose($file)
EndFunc   ;==>_Add_File_to_Backuplist

Func _Backup_Files()
	If $Offenes_Projekt = "" Then Return
	If $Can_open_new_tab = 0  AND $Regel_lauft = 0 Then Return
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_BackupErstellen) <> -1 Then Return ;Platzhalter für Plugin
;~ 	$current_window_focus = WinGetTitle("[ACTIVE]", "")
	_Write_ISN_Debug_Console("Backup function initiated!", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
	_Write_log(_Get_langstr(122), "368DB6")
;~ 	WinSetState($current_window_focus, "", @SW_SHOW)
;~
;~ 	WinActivate($current_window_focus, "")
;~ 	WinSetOnTop($current_window_focus, "", 1)
;~ 	WinSetOnTop($current_window_focus, "", 0)
	$file = FileOpen($Backupcache, 0 + $FO_ANSI)
	If $file = -1 Then Return
	GUISetCursor(1, 0, $studiofenster)
	Local $Ordnerstruktur = ""
	$Ordnerstruktur = $Autobackup_Ordnerstruktur
	$Anzahl_Dateien = 0

	If $backupmode = 1 Then
		$Ordnerstruktur = _ISN_Variablen_aufloesen($Ordnerstruktur)
		$Desfolder = _ISN_Variablen_aufloesen($Backupfolder & "\" & $Ordnerstruktur & "\*.*")
		If Not FileExists(_ISN_Variablen_aufloesen($Backupfolder)) Then
			If DirCreate(_ISN_Variablen_aufloesen($Backupfolder)) = 0 Then
				_Write_ISN_Debug_Console("|--> ERROR: Backupfolder not found! (" & _ISN_Variablen_aufloesen($Backupfolder) & ")", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
				MsgBox(262144 + 16, _Get_langstr(206) & " - " & _Get_langstr(25), _ISN_Variablen_aufloesen($Backupfolder) & " " & _Get_langstr(332), 0, $Studiofenster)
				Return
			EndIf
		EndIf
	EndIf
	If $backupmode = 2 Then
		$Ordnerstruktur = StringReplace($Ordnerstruktur, "%projectname%", "")
		If StringLeft($Ordnerstruktur, 1) = "\" Then $Ordnerstruktur = StringTrimLeft($Ordnerstruktur, 1)
		$Desfolder = $Offenes_Projekt & "\" & $Backupfolder & "\" & _ISN_Variablen_aufloesen($Ordnerstruktur) & "\*.*"
	EndIf

	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		_Write_ISN_Debug_Console("|--> Backup file", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_Write_ISN_Debug_Console("|--> FROM: " & $line, $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_Write_ISN_Debug_Console("|--> TO: " & $Desfolder, $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		_Write_ISN_Debug_Console("|--> RESULT:", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_No_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		If FileCopy($line, $Desfolder, 9) Then
			$Anzahl_Dateien = $Anzahl_Dateien + 1
			_Write_ISN_Debug_Console("OK", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_No_Time, $ISN_Debug_Console_No_Title)
		Else
			_Write_ISN_Debug_Console("ERROR", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_No_Time, $ISN_Debug_Console_No_Title)
		EndIf
	WEnd
	FileClose($file)
	FileSetTime($Desfolder, @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC, 0, 1) ;Aktualisiere Zeitstempel der neuen Dateien
	If $enabledeleteoldbackups = "true" Then
		_Write_ISN_Debug_Console("|--> Removing Backups older than " & $deleteoldbackupsafter & " days...", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_No_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
		If $backupmode = 1 Then
			_FileDeleteAfterXDays(_ISN_Variablen_aufloesen($Backupfolder & "\"), $deleteoldbackupsafter, True, True, True, False)
		EndIf
		If $backupmode = 2 Then _FileDeleteAfterXDays($Offenes_Projekt & "\" & $Backupfolder & "\", $deleteoldbackupsafter, True, True, True, False)
		_Write_ISN_Debug_Console("OK", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_No_Time, $ISN_Debug_Console_No_Title)
	EndIf
	GUISetCursor(2, 0, $StudioFenster)
	_Write_log(StringReplace(_Get_langstr(899), "%1", $Anzahl_Dateien), "368DB6")
	_Write_ISN_Debug_Console("|--> Backup function finished! (" & $Anzahl_Dateien & " file(s) copied)", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak, $ISN_Debug_Console_Insert_Time, $ISN_Debug_Console_Insert_Title)
EndFunc   ;==>_Backup_Files



Func _Rename_Project()
	If $Templatemode = 1 Then Return
	If $Tempmode = 1 Then Return
	$i = MsgBox(262144 + 48 + 4, _Get_langstr(178), _Get_langstr(227), 0, $Projekteinstellungen_GUI)
	If $i = 6 Then
		$var = InputBox(_Get_langstr(226), _Get_langstr(226), IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", ""), "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $Projekteinstellungen_GUI)
		If $var = "" Then Return
		If $var = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", "") Then Return
		If @error Then Return
		$var = StringReplace($var, "|", "")
		$var = StringReplace($var, "?", "")
		$var = StringReplace($var, "*", "")
		$var = StringReplace($var, "\", "")
		$var = StringReplace($var, "/", "")
		$var = StringReplace($var, '"', "")
		$var = StringReplace($var, "'", "")
		If $var = "" Then Return
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", $var)
		$var2 = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(804), 0, $Projekteinstellungen_GUI)

		$Offenes_Projekt_backup = $Offenes_Projekt
		$Offenes_Projekt_Ordner = StringTrimRight($Offenes_Projekt, StringLen($Offenes_Projekt) - StringInStr($Offenes_Projekt, "\", 0, -1))
		_Hide_projectproperties()
		_Close_Project("false")
		If $var2 = 6 Then
			;Projektordner umbenennen
			If FileExists($Offenes_Projekt_Ordner & $var) Then
				If $Offenes_Projekt_Ordner & $var <> $Offenes_Projekt_backup Then MsgBox(262144 + 48, _Get_langstr(25), _Get_langstr(805), 0, $Studiofenster)
			Else
				DirMove($Offenes_Projekt_backup, $Offenes_Projekt_Ordner & $var, 0)
				$Offenes_Projekt_backup = $Offenes_Projekt_Ordner & $var
			EndIf
		EndIf
		_Load_Project_by_Foldername($Offenes_Projekt_backup)
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(392), 0, $Studiofenster)
	EndIf
EndFunc   ;==>_Rename_Project

Func _Rename_Author()
	$var = InputBox(_Get_langstr(229), _Get_langstr(229), IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", ""), "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $Projekteinstellungen_GUI)
	If @error = 0 Then
		If $var = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", "") Then Return
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", $var)
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(230), 0, $Projekteinstellungen_GUI)
		_Zeige_Projekteinstellungen("projectproperties")
	EndIf
EndFunc   ;==>_Rename_Author

Func _Rename_Comment()
	$var = InputBox(_Get_langstr(231), _Get_langstr(231), IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "comment", ""), "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $Projekteinstellungen_GUI)
	If @error = 0 Then
		If $var = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "comment", "") Then Return
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "comment", $var)
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(232), 0, $Projekteinstellungen_GUI)
		_Zeige_Projekteinstellungen("projectproperties")
	EndIf

EndFunc   ;==>_Rename_Comment

Func _chance_Version()
	$var = InputBox(_Get_langstr(233), _Get_langstr(233), IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", ""), "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $Projekteinstellungen_GUI)
	If @error = 0 Then
		If $var = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", "") Then Return
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", $var)
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(234), 0, $Projekteinstellungen_GUI)
		_Zeige_Projekteinstellungen("projectproperties")
	EndIf
EndFunc   ;==>_chance_Version

Func _Hide_projectproperties()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Projekteinstellungen_GUI)
EndFunc   ;==>_Hide_projectproperties



Func _Projekt_timer_Pausieren()
	If $Projekt_Timer_pausiert = 1 Then Return ;Bereits pausiert
	If $Offenes_Projekt = "" Then Return
	If $Studiomodus = 2 Then Return
	If $Templatemode = 1 Then Return
	_Write_ISN_Debug_Console("Project timer for the project '" & $Offenes_Projekt_name & "' changed status to paused.", 1)
;~ ConsoleWrite("Timer pausiert!"&@crlf)
	$Pause_time = $Pause_time + Int(TimerDiff($Project_timer))
	$Projekt_Timer_pausiert = 1
	_GUICtrlStatusBar_SetIcon($Status_bar, 1, _WinAPI_ShellExtractIcons($smallIconsdll, 913, 16, 16))
EndFunc   ;==>_Projekt_timer_Pausieren

Func _Projekt_Timer_fortsetzen()
	If $Projekt_Timer_pausiert = 0 Then Return ;Läuft bereits
	If $Offenes_Projekt = "" Then Return
	If $Studiomodus = 2 Then Return
	If $Templatemode = 1 Then Return
	_Write_ISN_Debug_Console("Project timer for the project '" & $Offenes_Projekt_name & "' changed status to resumed.", 1)
;~ ConsoleWrite("Timer gestartet!"&@crlf)
	$Project_timer = TimerInit()
	$Projekt_Timer_pausiert = 0
	_GUICtrlStatusBar_SetIcon($Status_bar, 1, _WinAPI_ShellExtractIcons($smallIconsdll, 911, 16, 16))
EndFunc   ;==>_Projekt_Timer_fortsetzen


Func _stop_Project_timer()
	Local $timer, $Secs, $Mins, $Hour, $time
	Local $timer1, $Secs1, $Mins1, $Hour1, $Time1
	Local $timer2, $Secs2, $Mins2, $Hour2, $Time2
	If $Offenes_Projekt = "" Then Return
	If $Studiomodus = 2 Then Return
	If $Templatemode = 1 Then Return
	$dif = TimerDiff($Project_timer)
	$dif = Int($dif)
	$time = $dif + $Pause_time + IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "time", 0)
	_TicksToTime(IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "time", 0), $Hour, $Mins, $Secs)
	_TicksToTime($dif + $Pause_time, $Hour1, $Mins1, $Secs1)
	_TicksToTime($time, $Hour2, $Mins2, $Secs2)
	_Write_ISN_Debug_Console("Project timer for the project '" & $Offenes_Projekt_name & "' stopped.", 1)
;~ 	msgbox(0,"info","Timer Stopped!"&@crlf&"Alte Zeit: "&$Hour&"h "&$Mins&"m "&$Secs&" s ("&iniread($Offenes_Projekt&"\project.isn","ISNAUTOITSTUDIO","time","0")&")"&@crlf&"Vergangene Zeit:"&$Hour1&"h "&$Mins1&"m "&$Secs1&"s ("&$dif&")"&@crlf&"Neue Zeit:"&$Hour2&"h "&$Mins2&"m "&$Secs2&"s ("&$time&")")
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "time", $time)
	_GUICtrlStatusBar_SetIcon($Status_bar, 1, _WinAPI_ShellExtractIcons($smallIconsdll, 913, 16, 16))
	Return $dif + $Pause_time ;Rückgabe der aktuell benötigten Zeit (seit das Projekt geöffnet wurde)
EndFunc   ;==>_stop_Project_timer

Func _Start_Project_timer()
	If $Studiomodus = 2 Then Return
	If $Templatemode = 1 Then Return
	Local $timer, $Secs, $Mins, $Hour, $time
	$time = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "time", 0)
	_TicksToTime($time, $Hour, $Mins, $Secs)
	If $Hour > 9 Then _Earn_trophy(10, 3)
	If $Hour > 0 Or $Mins > 29 Then _Earn_trophy(6, 1)
	$Pause_time = 0 ;Pause Timer zurücksetzen
	$Project_timer = TimerInit()
	_Write_ISN_Debug_Console("Project timer for the project '" & $Offenes_Projekt_name & "' started.", 1)
	_GUICtrlStatusBar_SetIcon($Status_bar, 1, _WinAPI_ShellExtractIcons($smallIconsdll, 911, 16, 16))
EndFunc   ;==>_Start_Project_timer

Func _topSec()
	$Geheimcount = $Geheimcount + 1
	If $Geheimcount > 2 Then _Earn_trophy(11, 3)
EndFunc   ;==>_topSec

Func _Load_Languages()
	GUICtrlSetData($Combo_Sprachen[0], "", "")
	$Search = FileFindFirstFile(@ScriptDir & "\data\language\*.lng")
	If $Search = -1 Then
		GUICtrlSetData($Combo_Sprachen[0], "", "ERROR")
		Return
	EndIf
	$filetypes = ""
	$i = 1
	While 1
		$file = FileFindNextFile($Search)
		If @error Then ExitLoop

		$filetypes = $filetypes & _IniReadEx(@ScriptDir & "\data\language\" & $file, "ISNAUTOITSTUDIO", "language", "ERROR") & "|"
		$Combo_Sprachen[$i] = $file
		$i = $i + 1
	WEnd
	FileClose($Search)
	GUICtrlSetData($Combo_Sprachen[0], $filetypes, _IniReadEx(@ScriptDir & "\data\language\" & $Languagefile, "ISNAUTOITSTUDIO", "language", "ERROR"))
	GUICtrlSetData($langchooser, $filetypes, _IniReadEx(@ScriptDir & "\data\language\" & $Languagefile, "ISNAUTOITSTUDIO", "language", "ERROR"))

EndFunc   ;==>_Load_Languages

Func _Select_Language()
	GUICtrlSetData($Sprachen_Label_Version, _Get_langstr(619) & " " & _IniReadEx(@ScriptDir & "\data\language\" & $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1], "ISNAUTOITSTUDIO", "version", ""))
	GUICtrlSetData($Sprachen_Label_Kommentar, _Get_langstr(133) & " " & _IniReadEx(@ScriptDir & "\data\language\" & $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1], "ISNAUTOITSTUDIO", "comment", ""))
	GUICtrlSetData($Sprachen_Label_Author, _Get_langstr(132) & " " & _IniReadEx(@ScriptDir & "\data\language\" & $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1], "ISNAUTOITSTUDIO", "author", ""))
EndFunc   ;==>_Select_Language


;********************************************************************************
;Recursive search for filemask
;********************************************************************************

Func _GetFileList($T_DIR, $T_MASK)
	Dim $N_DIRNAMES[200000] ; max number of directories that can be scanned
	Local $N_DIRCOUNT = 0
	Local $N_FILE
	Local $N_SEARCH
	Local $N_TFILE
	Local $N_OFILE
	Local $T_FILENAMES
	Local $T_FILECOUNT
	Local $T_DIRCOUNT = 1
	; remove the end \ If specified
	If StringRight($T_DIR, 1) = "\" Then $T_DIR = StringTrimRight($T_DIR, 1)
	$N_DIRNAMES[$T_DIRCOUNT] = $T_DIR
	; Exit if base dir doesn't exists
	If Not FileExists($T_DIR) Then Return 0
	; keep on looping until all directories are scanned
	While $T_DIRCOUNT > $N_DIRCOUNT
		$N_DIRCOUNT = $N_DIRCOUNT + 1
		; find all subdirs in this directory and save them in a array
		$N_SEARCH = FileFindFirstFile($N_DIRNAMES[$N_DIRCOUNT] & "\*.*")
		While 1
			$N_FILE = FileFindNextFile($N_SEARCH)
			If @error Then ExitLoop
			; skip these references
			If $N_FILE = "." Or $N_FILE = ".." Then ContinueLoop
			$N_TFILE = $N_DIRNAMES[$N_DIRCOUNT] & "\" & $N_FILE
			; if Directory than add to the list of directories to be processed
			If StringInStr(FileGetAttrib($N_TFILE), "D") > 0 Then
				$T_DIRCOUNT = $T_DIRCOUNT + 1
				$N_DIRNAMES[$T_DIRCOUNT] = $N_TFILE
			EndIf
		WEnd
		FileClose($N_SEARCH)
		; find all Files that mtach the MASK
		$N_SEARCH = FileFindFirstFile($N_DIRNAMES[$N_DIRCOUNT] & "\" & $T_MASK)
		If $N_SEARCH = -1 Then ContinueLoop
		While 1
			$N_FILE = FileFindNextFile($N_SEARCH)
			If @error Then ExitLoop
			; skip these references
			If $N_FILE = "." Or $N_FILE = ".." Then ContinueLoop
			$N_TFILE = $N_DIRNAMES[$N_DIRCOUNT] & "\" & $N_FILE
			; if Directory than add to the list of directories to be processed
			If StringInStr(FileGetAttrib($N_TFILE), "D") = 0 Then
				$T_FILENAMES = $T_FILENAMES & $N_TFILE & @CR
				$T_FILECOUNT = $T_FILECOUNT + 1
				;MsgBox(0,'filecount ' & $T_FILECOUNT ,$N_TFILE)
			EndIf
		WEnd
		FileClose($N_SEARCH)
	WEnd
	$T_FILENAMES = StringTrimRight($T_FILENAMES, 1)
	$N_OFILE = StringSplit($T_FILENAMES, @CR)
	Return ($N_OFILE)
EndFunc   ;==>_GetFileList

Func _New_Folder()
	$str = InputBox(_Get_langstr(71), _Get_langstr(148), "", "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $StudioFenster)
	If @error Then
		Return
	Else
		If $str = "" Then Return
		$Count = 0
		If $Studiomodus = 1 Then
			$projectfolderr = _WinAPI_BrowseForFolderDlg($Offenes_Projekt, _Get_langstr(149), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
		Else
			$projectfolderr = _WinAPI_BrowseForFolderDlg("", _Get_langstr(149), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
		EndIf
		If @error Or $projectfolderr = "" Then
			Return
		Else
			$str = StringReplace($str, "\", "")
			$str = StringReplace($str, "/", "")
			$str = StringReplace($str, "?", "")
			$str = StringReplace($str, "*", "")
			$str = StringReplace($str, "|", "")
			$str = StringReplace($str, ":", "")
			$str = StringReplace($str, "<", "")
			$str = StringReplace($str, ">", "")
			$str = StringReplace($str, "'", "")
			$str = StringReplace($str, '"', "")
			If DirCreate($projectfolderr & "\" & $str) = 1 Then _Write_log(_Get_langstr(150) & " (" & $str & ")")
			;_Update_Treeview()
		EndIf
	EndIf
EndFunc   ;==>_New_Folder



Func _Make_New_File()
	If GUICtrlRead($newfile_filename) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(159), 0, $New_file_GUI)
		Return
	EndIf

	If GUICtrlRead($neue_datei_vorlagen_datei_combo) = "" And GUICtrlRead($neue_datei_radio2) = $GUI_CHECKED Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(746), 0, $New_file_GUI)
		Return
	EndIf

	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $New_file_GUI)

	;Umlaute filtern
	$umlaut = GUICtrlRead($newfile_filename)
	$umlaut = _Umlaute_Filtern($umlaut)
	GUICtrlSetData($newfile_filename, $umlaut)


	If $Studiomodus = 1 Then

		$projectfolderr = _WinAPI_BrowseForFolderDlg($Offenes_Projekt, _Get_langstr(160), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
	Else
		$projectfolderr = _WinAPI_BrowseForFolderDlg("", _Get_langstr(160), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
	EndIf
	If @error Or $projectfolderr = "" Then
		Return
	Else
		$filename = GUICtrlRead($newfile_filename) & GUICtrlRead($combo_newfile)

		If GUICtrlRead($neue_datei_radio1) = $GUI_CHECKED Then

			If $autoit_editor_encoding = "2" Then
				$file = FileOpen($projectfolderr & "\" & $filename, 2 + $FO_UTF8_NOBOM)
			Else
				$file = FileOpen($projectfolderr & "\" & $filename, 2)
			EndIf

			; Check if file opened for writing OK
			If $file = -1 Then
				MsgBox(0, "Error", "Unable to create new file. Maybe you do not have write access to this folder!")
				Return
			EndIf
			If GUICtrlRead($combo_newfile) = ".au3" Then
				FileWriteLine($file, ";" & $filename)
			EndIf

			If GUICtrlRead($combo_newfile) = ".isf" Then
				FileWriteLine($file, "#cs")
				FileWriteLine($file, "[gui]")
				FileWriteLine($file, "title=" & GUICtrlRead($newfile_filename))
				FileWriteLine($file, "breite=350")
				FileWriteLine($file, "hoehe=350")
				FileWriteLine($file, "style=-1")
				FileWriteLine($file, "exstyle=-1")
				FileWriteLine($file, "exstyle=-1")
				FileWriteLine($file, "bgcolour=0xF0F0F0")
				FileWriteLine($file, "bgimage=none")
				FileWriteLine($file, "handle=" & StringReplace(GUICtrlRead($newfile_filename), " ", "_"))
				FileWriteLine($file, "#ce")
			EndIf

			FileWriteLine($file, "")
			FileClose($file)
		Else ;Datei aus vorlage
			If IsArray($neue_Datei_erstellen_Vorlagendatei_combo_ARRAY) Then
				If GUICtrlRead($combo_newfile) = ".au3" Then
					;Ersetze Variablen
					Dim $aRecords
					_FileReadToArray($neue_Datei_erstellen_Vorlagendatei_combo_ARRAY[_GUICtrlComboBox_GetCurSel($neue_datei_vorlagen_datei_combo)], $aRecords)
					If IsArray($aRecords) Then
						For $x = 1 To $aRecords[0]
							;Alte Variablen (für Kompatibilität)
							$aRecords[$x] = StringReplace($aRecords[$x], "$FILENAME", $filename)
							$aRecords[$x] = StringReplace($aRecords[$x], "$AUTHOR", IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", ""))
							$aRecords[$x] = StringReplace($aRecords[$x], "$PROGRAMMVERSION", $Studioversion)
							$aRecords[$x] = StringReplace($aRecords[$x], "$STR30", _Get_langstr(30))
							$aRecords[$x] = StringReplace($aRecords[$x], "$COMMENT", IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "comment", ""))

							;Neue Variablen
							$aRecords[$x] = _Neue_Datei_erstellen_ersetze_Variablen($aRecords[$x], $filename, IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", ""), IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "comment", ""), IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", ""))
						Next
						_FileWriteFromArray($projectfolderr & "\" & $filename, $aRecords, 1)
					EndIf

				Else
					FileCopy($neue_Datei_erstellen_Vorlagendatei_combo_ARRAY[_GUICtrlComboBox_GetCurSel($neue_datei_vorlagen_datei_combo)], $projectfolderr & "\" & $filename, 9)
				EndIf


			EndIf
		EndIf
		$path = $projectfolderr

		$path = StringTrimLeft($projectfolderr, StringLen($Offenes_Projekt) + 1)
		$path = $path & "\"
		If $path = "\" Then $path = ""
		$path = $path & $filename
		_Write_log($filename & " " & _Get_langstr(161))
		If $Studiomodus = "2" Then _Update_Treeview()
		;_Update_Treeview()
		If GUICtrlRead($new_file_include_checkbox) = $GUI_CHECKED Then _Include_IT($path)
		If GUICtrlRead($new_file_open_checkbox) = $GUI_CHECKED Then Try_to_opten_file($projectfolderr & "\" & $filename)
	EndIf
EndFunc   ;==>_Make_New_File

Func _Include_IT($filepath)
	Try_to_opten_file($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"))
	Sleep(200)
	$wrapFind = False
	$pos = FindInTarget("#include", StringLen("#include"), SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETLENGTH, 0, 0), 0)
	If $pos = -1 Then $pos = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETLENGTH, 0, 0)
	$line = Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $pos) + 1
	$posFind = -1
	If $pos = -1 Then Return
	Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], '#include "' & $filepath & '"' & @CRLF, $line + 1)
EndFunc   ;==>_Include_IT

Func _Exclude_IT($file = "")
	If $file = "" Then Return
	Try_to_opten_file($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"))
	Sleep(200)

	For $x = 1 To Sci_GetLineCount($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		$Zeilentext = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $x)
		If StringInStr($Zeilentext, "#include") And StringInStr($Zeilentext, $file) Then
			$start = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $x)
			$end = Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $x)
			Sci_SetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $start, $end)
			SendMessageString($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_REPLACESEL, 0, "")
			_Check_tabs_for_changes()
		EndIf
	Next
EndFunc   ;==>_Exclude_IT



Func _Show_New_Filegui()
	GUICtrlSetData($newfile_filename, "")
	GUICtrlSetState($newfile_filename, $GUI_FOCUS)
	GUICtrlSetState($new_file_open_checkbox, $GUI_CHECKED)
	GUICtrlSetState($neue_datei_radio1, $GUI_CHECKED)
	_read_combo_new_file()
	_New_Filegui_Radio_event()
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_SHOW, $New_file_GUI)
	WinActivate($New_file_GUI)
EndFunc   ;==>_Show_New_Filegui

Func _New_Filegui_Radio_event()
	If GUICtrlRead($neue_datei_radio1) = $GUI_CHECKED Then
		GUICtrlSetState($neue_datei_radiolabel1, $GUI_DISABLE)
		GUICtrlSetState($neue_datei_radiolabel2, $GUI_DISABLE)
		GUICtrlSetState($neue_datei_vorlagen_combo, $GUI_DISABLE)
		GUICtrlSetState($neue_datei_vorlagen_datei_combo, $GUI_DISABLE)
		GUICtrlSetData($neue_datei_vorlagen_combo, "", "")
		GUICtrlSetData($neue_datei_vorlagen_datei_combo, "", "")
	Else
		GUICtrlSetState($neue_datei_radiolabel1, $GUI_ENABLE)
		GUICtrlSetState($neue_datei_radiolabel2, $GUI_ENABLE)
		GUICtrlSetState($neue_datei_vorlagen_combo, $GUI_ENABLE)
		GUICtrlSetState($neue_datei_vorlagen_datei_combo, $GUI_ENABLE)
		ScanforTemplates_Combo()
		_Show_New_Filegui_Scan_for_files()
	EndIf
EndFunc   ;==>_New_Filegui_Radio_event

Func _Show_New_Filegui_Scan_for_files()
	If GUICtrlRead($neue_datei_radio1) = $GUI_CHECKED Then Return
	Local $array
	Local $first_item
	Local $files_string
	$array = _GetFileList($new_projectvorlage_combo_ARRAY[_GUICtrlComboBox_GetCurSel($neue_datei_vorlagen_combo) + 1], "*" & GUICtrlRead($combo_newfile))
	GUICtrlSetData($neue_datei_vorlagen_datei_combo, "", "")
	If Not IsArray($array) Then Return
	$files_string = ""
	$first_item = ""
	_ArrayDelete($array, 0)
	For $x = 0 To UBound($array) - 1
		If $x = 0 Then $first_item = StringTrimLeft($array[$x], StringInStr($array[$x], "\", 0, -1))
		$files_string = $files_string & StringTrimLeft($array[$x], StringInStr($array[$x], "\", 0, -1)) & "|"
	Next
	$neue_Datei_erstellen_Vorlagendatei_combo_ARRAY = $array
	GUICtrlSetData($neue_datei_vorlagen_datei_combo, $files_string, $first_item)
EndFunc   ;==>_Show_New_Filegui_Scan_for_files

;Suche nach Vrolagen

Func ScanforVorlagen_neue_Datei_erstellen($SourceFolder)
	Local $Search
	Local $file
	Local $FileAttributes
	Local $FullFilePath
	$Count = 0
	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($vorlagen_Listview_projectman))
	_GUICtrlListView_BeginUpdate($vorlagen_Listview_projectman)
	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf
		$file = FileFindNextFile($Search)
		If @error Then ExitLoop
		$FullFilePath = $SourceFolder & "\" & $file
		$FileAttributes = FileGetAttrib($FullFilePath)
		If StringInStr($FileAttributes, "D") Then
			If FileExists(_Finde_Projektdatei($FullFilePath)) Then
				$Count = $Count + 1
				$tmp_isn_file = _Finde_Projektdatei($FullFilePath)
				_GUICtrlListView_AddItem($vorlagen_Listview_projectman, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "name", "#ERROR#"), 10)
				$folder = StringTrimLeft($FullFilePath, StringInStr($FullFilePath, "\", 0, -1))
				_GUICtrlListView_AddSubItem($vorlagen_Listview_projectman, _GUICtrlListView_GetItemCount($vorlagen_Listview_projectman) - 1, IniRead($tmp_isn_file, "ISNAUTOITSTUDIO", "author", ""), 1)
				_GUICtrlListView_AddSubItem($vorlagen_Listview_projectman, _GUICtrlListView_GetItemCount($vorlagen_Listview_projectman) - 1, $folder, 2)
			EndIf
		EndIf
	WEnd
	$Descending = False
	_GUICtrlListView_SimpleSort($vorlagen_Listview_projectman, $Descending, 0)
	_GUICtrlListView_SetItemSelected($vorlagen_Listview_projectman, -1, False, False)
	_GUICtrlListView_EndUpdate($vorlagen_Listview_projectman)
	GUICtrlSetData($Found_Vorlagen, $Count & " " & _Get_langstr(377))
EndFunc   ;==>ScanforVorlagen_neue_Datei_erstellen

Func _HIDE_New_Filegui()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $New_file_GUI)
EndFunc   ;==>_HIDE_New_Filegui

Func _read_combo_new_file()
	GUICtrlSetState($new_file_include_checkbox, $GUI_ENABLE)
	GUICtrlSetState($new_file_include_checkbox, $GUI_UNCHECKED)
	If GUICtrlRead($combo_newfile) = ".au3" Then
		_GUISetIcon($New_file_GUI, $smallIconsdll, 1788)
		GUICtrlSetData($combo_beschreibung, _Get_langstr(154))
		GUICtrlSetState($new_file_include_checkbox, $GUI_CHECKED)
	EndIf
	If GUICtrlRead($combo_newfile) = ".isf" Then
		_GUISetIcon($New_file_GUI, $smallIconsdll, 780)
		GUICtrlSetData($combo_beschreibung, _Get_langstr(153))
		GUICtrlSetState($new_file_include_checkbox, $GUI_CHECKED)
	EndIf
	If GUICtrlRead($combo_newfile) = ".ini" Then
		GUICtrlSetData($combo_beschreibung, _Get_langstr(155))
		_GUISetIcon($New_file_GUI, $smallIconsdll, 1176)
	EndIf

	If GUICtrlRead($combo_newfile) = ".txt" Then
		GUICtrlSetData($combo_beschreibung, _Get_langstr(156))
		_GUISetIcon($New_file_GUI, $smallIconsdll, 1176)
	EndIf
	GUICtrlSetData($combo_fileformat, GUICtrlRead($combo_newfile))
	If $Studiomodus = 2 Then
		GUICtrlSetState($new_file_include_checkbox, $GUI_UNCHECKED)
		GUICtrlSetState($new_file_include_checkbox, $GUI_DISABLE)
	EndIf
	_Show_New_Filegui_Scan_for_files()
EndFunc   ;==>_read_combo_new_file

Func _Show_new_Filgui_au3()
	If $Offenes_Projekt = "" Then Return
	GUICtrlSetData($combo_newfile, "")
	GUICtrlSetData($combo_newfile, ".au3|.isf|.ini|.txt", ".au3")
	_Show_New_Filegui()
EndFunc   ;==>_Show_new_Filgui_au3

Func _Show_new_Filgui_isf()
	If $Offenes_Projekt = "" Then Return
	GUICtrlSetData($combo_newfile, "")
	GUICtrlSetData($combo_newfile, ".au3|.isf|.ini|.txt", ".isf")
	_Show_New_Filegui()
EndFunc   ;==>_Show_new_Filgui_isf

Func _Show_new_Filgui_ini()
	If $Offenes_Projekt = "" Then Return
	GUICtrlSetData($combo_newfile, "")
	GUICtrlSetData($combo_newfile, ".au3|.isf|.ini|.txt", ".ini")
	_Show_New_Filegui()
EndFunc   ;==>_Show_new_Filgui_ini

Func _Show_new_Filgui_txt()
	If $Offenes_Projekt = "" Then Return
	GUICtrlSetData($combo_newfile, "")
	GUICtrlSetData($combo_newfile, ".au3|.isf|.ini|.txt", ".txt")
	_Show_New_Filegui()
EndFunc   ;==>_Show_new_Filgui_txt

Dim $Direction[7]

Func _HeaderSort(ByRef $GUIList, $column)

	If $Direction[$column] = 'Ascending' Then
		Dim $v_sort = False ;Dim $v_sort = _GUICtrlListView_GetColumnCount ($GUIList)
	Else
		Dim $v_sort = True ;Dim $v_sort[_GUICtrlListView_GetColumnCount ($GUIList) ]
	EndIf
	If $Direction[$column] = 'Ascending' Then
		$Direction[$column] = 'Decending'
	Else
		$Direction[$column] = 'Ascending'
	EndIf
	_GUICtrlListView_SimpleSort($GUIList, $v_sort, $column)

EndFunc   ;==>_HeaderSort


Func _datei_oeffnen_mit_Skript_Editor()
	If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = $Offenes_Projekt Then
		Return
	EndIf
	$file = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	$alreadyopen = _GUICtrlTab_FindTab($htab, StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	If $alreadyopen <> -1 Then
		$res = _ArraySearch($Datei_pfad, $file)
		If $res <> -1 Then
			$alreadyopen = $res
		Else
			$alreadyopen = -1
		EndIf
	EndIf
	If $alreadyopen = -1 Then
		_openscriptfile($file)
		_Add_File_to_Backuplist(_GUICtrlTVExplorer_GetSelected($hWndTreeview))
		If $Offene_tabs > 14 Then _Earn_trophy(9, 2)
		_Fuege_Datei_zu_Zuletzt_Verwendete_Dateien(_GUICtrlTVExplorer_GetSelected($hWndTreeview))
	Else
		_GUICtrlTab_ActivateTabX($htab, $alreadyopen)
		_Show_Tab($alreadyopen)
	EndIf
EndFunc   ;==>_datei_oeffnen_mit_Skript_Editor

Func _datei_oeffnen_mit_Windows()
	If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = $Offenes_Projekt Then
		Return
	EndIf
	_Write_log(StringTrimLeft(_GUICtrlTVExplorer_GetSelected($hWndTreeview), StringInStr(_GUICtrlTVExplorer_GetSelected($hWndTreeview), "\", 0, -1)) & " " & _Get_langstr(673), "000000", "false")
	ShellExecute(_GUICtrlTVExplorer_GetSelected($hWndTreeview))
EndFunc   ;==>_datei_oeffnen_mit_Windows

Func _datei_eigenschaften()
	If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = $Offenes_Projekt Then
		_Zeige_Projekteinstellungen("projectproperties")
		Return
	EndIf
	_ShowFileProperties(_GUICtrlTVExplorer_GetSelected($hWndTreeview), "properties", $StudioFenster)
EndFunc   ;==>_datei_eigenschaften

Func _datei_eigenschaften_tab()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	$Pfad = $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)]
	If Not FileExists($Pfad) Then $Pfad = StringReplace($Pfad, ".exe", "." & $Autoitextension)
	If Not FileExists($Pfad) Then Return
	_ShowFileProperties($Pfad, "properties", $StudioFenster)
EndFunc   ;==>_datei_eigenschaften_tab

Func _Show_Info()
	GUICtrlSetData($ueber_txt, _Get_langstr(1) & " v. " & $Studioversion & @CRLF & @CRLF & _Get_langstr(179) & " " & $ERSTELLUNGSTAG & @CRLF & _Get_langstr(219) & " Christian Faderl (ISI360)" & @CRLF & @CRLF & _Get_langstr(180))
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_SHOW, $ISN_Ueber_GUI)
EndFunc   ;==>_Show_Info

Func _hide_Info()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $ISN_Ueber_GUI)
EndFunc   ;==>_hide_Info

Func _close_func()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Funclist_GUI)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "listfuncsok")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($FuncListview))
EndFunc   ;==>_close_func

Func _func_select_ok()
	If GUICtrlRead($Funcinput) = "" Then Return
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Funclist_GUI)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	_ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "listfuncsok" & $Plugin_System_Delimiter & GUICtrlRead($Funcinput))
EndFunc   ;==>_func_select_ok

Func _List_Funcs()
	If $Studiomodus = 2 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(670), 0, $studiofenster)
		If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "listfuncsok")

		Return
	EndIf
	GUICtrlSetState($FuncListview, $GUI_DISABLE)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($FuncListview))
	_GUICtrlListView_AddItem($FuncListview, _Get_langstr(1034), 0)
	_GUICtrlListView_AddItem($FuncListview, _Get_langstr(23), 1)
	GUICtrlSetData($FuncText, _Get_langstr(185))
	GUICtrlSetData($Funcinput, "")
	WinSetTitle($Funclist_GUI, "", _Get_langstr(185))
	GUISetState(@SW_DISABLE, $StudioFenster)
	WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_DISABLE)
	GUISetState(@SW_SHOW, $Funclist_GUI)
	WinSetOnTop($Funclist_GUI, "", 1)
	WinActivate($Funclist_GUI)
	;List all functions in the project
	Dim $ALL_CODE
	Dim $tmp_CODE
	Dim $aRecords
	Dim $str
	$files = _GetFileList($Offenes_Projekt, "*.au3")
	For $x = 0 To UBound($files) - 1
		If FileExists($files[$x]) Then
			$source = StringTrimLeft($files[$x], StringInStr($files[$x], "\", -1, -1))
			_FileReadToArray($files[$x], $tmp_CODE)
			$new = _ArrayToString($tmp_CODE, @CRLF)
			$str = $str & $new
		EndIf
	Next

	$aList = StringRegExp(StringRegExpReplace($str, '(?ims)#c[^#]+#c', ''), '(?ims)^\s*Func\s*([^(]*)', 3)
	If IsArray($aList) Then
		$aList = _ArrayUnique($aList)
		_ArrayDelete($aList, 0)
	EndIf
	If IsArray($aList) Then _ArraySort($aList)
	_GUICtrlListView_BeginUpdate($FuncListview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($FuncListview))
	For $i = 0 To UBound($aList) - 1
		_GUICtrlListView_AddItem($FuncListview, $aList[$i], _GUICtrlListView_GetItemCount($FuncListview) - 1)
	Next

	_GUICtrlListView_EndUpdate($FuncListview)
	GUICtrlSetState($FuncListview, $GUI_ENABLE)
EndFunc   ;==>_List_Funcs

Func _List_Guis()
	If $Studiomodus = 2 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(670), 0, $studiofenster)
		_ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "listguisok")
		Return
	EndIf

	GUICtrlSetState($FuncListview, $GUI_DISABLE)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($FuncListview))
	_GUICtrlListView_AddItem($FuncListview, _Get_langstr(1034), 0)
	_GUICtrlListView_AddItem($FuncListview, _Get_langstr(23), 1)
	GUICtrlSetData($FuncText, _Get_langstr(400))
	GUICtrlSetData($Funcinput, "")
	WinSetTitle($Funclist_GUI, "", _Get_langstr(400))
	GUISetState(@SW_DISABLE, $StudioFenster)
	WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_DISABLE)
	GUISetState(@SW_SHOW, $Funclist_GUI)
	WinSetOnTop($Funclist_GUI, "", 1)
	WinActivate($Funclist_GUI)
	;List all functions in the project
	Dim $ALL_CODE
	Dim $tmp_CODE
	Dim $aRecords
	Dim $str
	Local $Fertiges_Array[1] = [0]

	$files = _GetFileList($Offenes_Projekt, "*.isf")
	$Array2 = _GetFileList($Offenes_Projekt, "*.au3")
	_ArrayConcatenate($files, $Array2)
	For $x = 0 To UBound($files) - 1
		If FileExists($files[$x]) Then
			$source = StringTrimLeft($files[$x], StringInStr($files[$x], "\", -1, -1))
			_FileReadToArray($files[$x], $tmp_CODE)
			If @error Then ContinueLoop
			$new = _ArrayToString($tmp_CODE, @CRLF)
			$str = $str & $new
		EndIf
	Next

	$aList = StringRegExp(StringRegExpReplace($str, '(?ims)#c[^#]+#c', ''), '(?ims)^\s*$\s*([^' & @CRLF & '|(]*)', 3)

	If IsArray($aList) Then
		For $i = 0 To UBound($aList) - 1
			$wert = $aList[$i]
			If Not StringInStr($wert, "guicreate") Then ContinueLoop
			If Not StringInStr($wert, "$") Then ContinueLoop
			$wert = StringTrimRight($wert, StringLen($wert) - StringInStr($wert, "=") + 1)
			$wert = StringReplace($wert, " ", "")
			_ArrayAdd($Fertiges_Array, StringStripWS($wert, 3))
		Next
	EndIf

	;Doppelte Einträge entfernen
	If IsArray($Fertiges_Array) Then _ArrayDelete($Fertiges_Array, 0)
	If IsArray($Fertiges_Array) Then
		$Fertiges_Array = _ArrayUnique($Fertiges_Array)
		_ArrayDelete($Fertiges_Array, 0)
	EndIf
	If IsArray($Fertiges_Array) Then _ArraySort($Fertiges_Array)
	_GUICtrlListView_BeginUpdate($FuncListview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($FuncListview))
	For $t = 0 To UBound($Fertiges_Array) - 1
		_GUICtrlListView_AddItem($FuncListview, $Fertiges_Array[$t], _GUICtrlListView_GetItemCount($FuncListview) - 1)
	Next
	_GUICtrlListView_EndUpdate($FuncListview)
	GUICtrlSetState($FuncListview, $GUI_ENABLE)
EndFunc   ;==>_List_Guis

Func _Select_folder_plugin()
	If $Studiomodus = 1 Then
		$result = _WinAPI_BrowseForFolderDlg($Offenes_Projekt, _Get_langstr(313), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
	Else
		$result = _WinAPI_BrowseForFolderDlg("", _Get_langstr(313), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
	EndIf
	If @error Or $result = "" Then
		_ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "selectfolderok")
		Return
	EndIf
	_ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "selectfolderok" & $Plugin_System_Delimiter & $result)
EndFunc   ;==>_Select_folder_plugin

Func _Weitere_Dateien_zum_Kompilieren_waehlen_Abbrechen()
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $Weitere_Dateien_Kompilieren_GUI)
	_GUICtrlTVExplorer_Destroy($Weitere_Dateien_Kompilieren_GUI_hTreeview, 1) ;Zerstöre Treeview
EndFunc   ;==>_Weitere_Dateien_zum_Kompilieren_waehlen_Abbrechen



Func _Weitere_Dateien_zum_Kompilieren_Lade_Treeview_aus_Listview()

	$Dateien = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "additional_files_to_compile", "")
	$files_array = StringSplit($Dateien, "|", 2)

	;Hauptdatei sperren
	$Treeview_Checkboxen_Gesperrte_Elemente = $Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "")
	$handle = _GUICtrlTVExplorer_Expand($Weitere_Dateien_Kompilieren_GUI_hTreeview, $Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", ""), 1, 1)
	MyCtrlSetItemState($Weitere_Dateien_Kompilieren_GUI_hTreeview, $handle, $GUI_CHECKED + $GUI_DISABLE)


	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Weitere_Dateien_Kompilieren_GUI_Listview))
	_GUICtrlListView_BeginUpdate($Weitere_Dateien_Kompilieren_GUI_Listview)
	_GUICtrlTreeView_BeginUpdate($Weitere_Dateien_Kompilieren_GUI_hTreeview)
	If IsArray($files_array) Then
		For $y = 0 To UBound($files_array) - 1
			If $files_array[$y] = "" Then ContinueLoop
			If $files_array[$y] = "|" Then ContinueLoop
			If Not FileExists(_ISN_Variablen_aufloesen($files_array[$y])) Then ContinueLoop
			_GUICtrlListView_AddItem($Weitere_Dateien_Kompilieren_GUI_Listview, $files_array[$y], 10)
			_GUICtrlTVExplorer_Expand($Weitere_Dateien_Kompilieren_GUI_hTreeview, _ISN_Variablen_aufloesen($files_array[$y]))
			If Not BitAND( MyCtrlGetItemState($Weitere_Dateien_Kompilieren_GUI_hTreeview, _GUICtrlTreeView_GetSelection($Weitere_Dateien_Kompilieren_GUI_hTreeview)), $GUI_DISABLE) = $GUI_DISABLE Then
				MyCtrlSetItemState($Weitere_Dateien_Kompilieren_GUI_hTreeview, _GUICtrlTreeView_GetSelection($Weitere_Dateien_Kompilieren_GUI_hTreeview), $GUI_CHECKED)
			EndIf
		Next
	EndIf
	_GUICtrlListView_EndUpdate($Weitere_Dateien_Kompilieren_GUI_Listview)
	_GUICtrlTreeView_EndUpdate($Weitere_Dateien_Kompilieren_GUI_hTreeview)
EndFunc   ;==>_Weitere_Dateien_zum_Kompilieren_Lade_Treeview_aus_Listview


Func _Weitere_Dateien_zum_Kompilieren_waehlen_OK()
	$Fertige_String = ""
	For $x = 0 To _GUICtrlListView_GetItemCount($Weitere_Dateien_Kompilieren_GUI_Listview) - 1
		$Datei = _GUICtrlListView_GetItemText($Weitere_Dateien_Kompilieren_GUI_Listview, $x)
		If $Datei = "" Then ContinueLoop
		$Fertige_String = $Fertige_String & $Datei & "|"
	Next
	If StringRight($Fertige_String, 1) = "|" Then $Fertige_String = StringTrimRight($Fertige_String, 1)
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "additional_files_to_compile", $Fertige_String)
	_Weitere_Dateien_zum_Kompilieren_waehlen_Abbrechen() ;Hide
EndFunc   ;==>_Weitere_Dateien_zum_Kompilieren_waehlen_OK

Func _Weitere_Dateien_zum_Kompilieren_waehlen()
	$Filter = "*.au3"
	GUISetState(@SW_SHOW, $Weitere_Dateien_Kompilieren_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
	Local $AutoIt_Projekte_in_Projektbaum_anzeigen_backup = $AutoIt_Projekte_in_Projektbaum_anzeigen
	$AutoIt_Projekte_in_Projektbaum_anzeigen = "false"
	GUISwitch($Weitere_Dateien_Kompilieren_GUI)
	$Weitere_Dateien_Kompilieren_GUI_Treeview = _GUICtrlTVExplorer_Create($Offenes_Projekt, 10 * $DPI, 58 * $DPI, 318 * $DPI, 319 * $DPI, -1, $WS_EX_CLIENTEDGE, $TV_FLAG_SHOWFILESEXTENSION + $TV_FLAG_SHOWFILES + $TV_FLAG_SHOWFOLDERICON + $TV_FLAG_SHOWFILEICON + $TV_FLAG_SHOWLIKEEXPLORER, "_Projecttree_event", $Filter, 0, 1)
	LoadStateImage($Weitere_Dateien_Kompilieren_GUI_Treeview, @ScriptDir & "\Data\checkboxes.bmp") ;checkboxes.bmp in den Treeview laden (TristateTreeViewLib.au3)
	$Weitere_Dateien_Kompilieren_GUI_hTreeview = GUICtrlGetHandle($Weitere_Dateien_Kompilieren_GUI_Treeview)
	GUICtrlSetFont($Weitere_Dateien_Kompilieren_GUI_hTreeview, $treefont_size, 400, 0, $treefont_font) ;Schrift
	GUICtrlSetColor($Weitere_Dateien_Kompilieren_GUI_hTreeview, $treefont_colour) ;Farbe
	_GUICtrlTVExplorer_Expand($Weitere_Dateien_Kompilieren_GUI_Treeview)
	_Weitere_Dateien_zum_Kompilieren_Lade_Treeview_aus_Listview()
	$AutoIt_Projekte_in_Projektbaum_anzeigen = $AutoIt_Projekte_in_Projektbaum_anzeigen_backup
	_Weitere_Dateien_Kompilieren_Treeview_Event()
EndFunc   ;==>_Weitere_Dateien_zum_Kompilieren_waehlen

Func _Weitere_Dateien_Kompilieren_Treeview_Event()
	$hSelected = _GUICtrlTreeView_GetSelection($Weitere_Dateien_Kompilieren_GUI_hTreeview)
	;Markiertes Element in Listview eintragen/austragen
	_GUICtrlListView_BeginUpdate($Weitere_Dateien_Kompilieren_GUI_Listview)
;~ 	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Weitere_Dateien_Kompilieren_GUI_Listview))
	_Weitere_Dateien_Kompilieren_Lade_Listview_aus_Treeview(_GUICtrlTreeView_GetFirstItem($Weitere_Dateien_Kompilieren_GUI_hTreeview), $Weitere_Dateien_Kompilieren_GUI_hTreeview)
	_GUICtrlListView_EndUpdate($Weitere_Dateien_Kompilieren_GUI_Listview)
EndFunc   ;==>_Weitere_Dateien_Kompilieren_Treeview_Event

Func _Weitere_Dateien_Kompilieren_Listview_aktualisieren($hinzufuegen = 1, $ItemText = "")
	If $hinzufuegen = 1 Then
		;Prüfen ob Element in der Liste ist. Wenn nein -> hinzufügen
		If _GUICtrlListView_FindText($Weitere_Dateien_Kompilieren_GUI_Listview, $ItemText) = -1 Then _GUICtrlListView_AddItem($Weitere_Dateien_Kompilieren_GUI_Listview, $ItemText, 10)
	Else
		;Prüfen ob Element in der Liste ist. Wenn ja -> löschen
		$find_result = _GUICtrlListView_FindText($Weitere_Dateien_Kompilieren_GUI_Listview, $ItemText)
		If $find_result <> -1 Then _GUICtrlListView_DeleteItem($Weitere_Dateien_Kompilieren_GUI_Listview, $find_result)
	EndIf
EndFunc   ;==>_Weitere_Dateien_Kompilieren_Listview_aktualisieren


Func _Weitere_Dateien_Kompilieren_Eintrag_nach_unten_verschieben()

	If _GUICtrlListView_GetSelectionMark($Weitere_Dateien_Kompilieren_GUI_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($Weitere_Dateien_Kompilieren_GUI_Listview) = 0 Then Return
	_GUICtrlListView_MoveItems($Weitere_Dateien_Kompilieren_GUI_Listview, 1)
	_GUICtrlListView_EnsureVisible($Weitere_Dateien_Kompilieren_GUI_Listview, _GUICtrlListView_GetSelectionMark($Weitere_Dateien_Kompilieren_GUI_Listview))
	_GUICtrlListView_SetItemSelected($Weitere_Dateien_Kompilieren_GUI_Listview, _GUICtrlListView_GetSelectionMark($Weitere_Dateien_Kompilieren_GUI_Listview), True, True)
EndFunc   ;==>_Weitere_Dateien_Kompilieren_Eintrag_nach_unten_verschieben

Func _Weitere_Dateien_Kompilieren_Eintrag_nach_oben_verschieben()

	If _GUICtrlListView_GetSelectionMark($Weitere_Dateien_Kompilieren_GUI_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($Weitere_Dateien_Kompilieren_GUI_Listview) = 0 Then Return
	_GUICtrlListView_MoveItems($Weitere_Dateien_Kompilieren_GUI_Listview, -1)
	_GUICtrlListView_EnsureVisible($Weitere_Dateien_Kompilieren_GUI_Listview, _GUICtrlListView_GetSelectionMark($Weitere_Dateien_Kompilieren_GUI_Listview))
	_GUICtrlListView_SetItemSelected($Weitere_Dateien_Kompilieren_GUI_Listview, _GUICtrlListView_GetSelectionMark($Weitere_Dateien_Kompilieren_GUI_Listview), True, True)
EndFunc   ;==>_Weitere_Dateien_Kompilieren_Eintrag_nach_oben_verschieben

Func _Weitere_Dateien_Kompilieren_Lade_Listview_aus_Treeview($hHandle, $Treeview = "")

	; Get the handle of the first child
	$hChild = _GUICtrlTreeView_GetFirstChild($Treeview, $hHandle)
	; If there is no child
	If $hChild = 0 Then
		Return
	EndIf

	; check the child
	If StringInStr(_GUICtrlTreeView_GetText($Treeview, $hChild), $Autoitextension) Then
		If BitAND( MyCtrlGetItemState($Weitere_Dateien_Kompilieren_GUI_hTreeview, $hChild), $GUI_CHECKED) = $GUI_CHECKED Then
			_Weitere_Dateien_Kompilieren_Listview_aktualisieren(1, _ISN_Pfad_durch_Variablen_ersetzen(_GUICtrlTVExplorer_GetPathFromItem($Treeview, $hChild)))
		Else
			_Weitere_Dateien_Kompilieren_Listview_aktualisieren(0, _ISN_Pfad_durch_Variablen_ersetzen(_GUICtrlTVExplorer_GetPathFromItem($Treeview, $hChild)))
		EndIf
	EndIf

;~     _GUICtrlTreeView_SetChecked($Treeview, $hChild, False)

	; Check for children
	_Weitere_Dateien_Kompilieren_Lade_Listview_aus_Treeview($hChild, $Treeview)

	; Now look for all grandchildren
	While 1
		; Look for next child
		$hChild = _GUICtrlTreeView_GetNextChild($Treeview, $hChild)
		; Exit the loop if none found
		If $hChild = 0 Then
			ExitLoop
		EndIf
		; check the child
		If StringInStr(_GUICtrlTreeView_GetText($Treeview, $hChild), $Autoitextension) Then
			If BitAND( MyCtrlGetItemState($Weitere_Dateien_Kompilieren_GUI_hTreeview, $hChild), $GUI_CHECKED) = $GUI_CHECKED Then
				_Weitere_Dateien_Kompilieren_Listview_aktualisieren(1, _ISN_Pfad_durch_Variablen_ersetzen(_GUICtrlTVExplorer_GetPathFromItem($Treeview, $hChild)))
			Else
				_Weitere_Dateien_Kompilieren_Listview_aktualisieren(0, _ISN_Pfad_durch_Variablen_ersetzen(_GUICtrlTVExplorer_GetPathFromItem($Treeview, $hChild)))
			EndIf
		EndIf

		; Check for children
		_Weitere_Dateien_Kompilieren_Lade_Listview_aus_Treeview($hChild, $Treeview)
		; And then look for the next child
	WEnd

EndFunc   ;==>_Weitere_Dateien_Kompilieren_Lade_Listview_aus_Treeview

Func _Treeview_Check_Parents($hHandle, $Treeview = "")

	; Get the handle of the parent
	$hParent = _GUICtrlTreeView_GetParentHandle($Treeview, $hHandle)
	; If there is no parent
	If $hParent = 0 Then
		Return
	EndIf
	; Check the parent
	_GUICtrlTreeView_SetChecked($Treeview, $hParent)

	; And look for the grandparent and so on
	_Treeview_Check_Parents($hParent, $Treeview)
EndFunc   ;==>_Treeview_Check_Parents


Func _Treeview_Uncheck_Children($hHandle, $Treeview = "")

	; Get the handle of the first child
	$hChild = _GUICtrlTreeView_GetFirstChild($Treeview, $hHandle)
	; If there is no child
	If $hChild = 0 Then
		Return
	EndIf
	; Uncheck the child
	_GUICtrlTreeView_SetChecked($Treeview, $hChild, False)

	; Check for children
	_Treeview_Uncheck_Children($hChild, $Treeview)

	; Now look for all grandchildren
	While 1
		; Look for next child
		$hChild = _GUICtrlTreeView_GetNextChild($Treeview, $hChild)
		; Exit the loop if none found
		If $hChild = 0 Then
			ExitLoop
		EndIf
		; Uncheck the child
		_GUICtrlTreeView_SetChecked($Treeview, $hChild, False)

		; Check for children
		_Treeview_Uncheck_Children($hChild, $Treeview)
		; And then look for the next child
	WEnd

EndFunc   ;==>_Treeview_Uncheck_Children


Func _Choose_File($Filter = "")
	$FilechooseFilter = $Filter
	Local $root = ""
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUICtrlSetState($Choose_File_GUI_Mehr, $GUI_SHOW)
	GUICtrlSetOnEvent($Choose_File_GUI_OK, "_Choose_File_OK")
	GUICtrlSetOnEvent($Choose_File_GUI_Abbrechen, "_close_Choose_File")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_close_Choose_File", $Choose_File_GUI)
	GUICtrlSetData($Choose_File_GUI_Label, _Get_langstr(187) & " (" & StringReplace(StringReplace($Filter, ";", ","), "*.", "") & ")")
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_DISABLE)
	GUISwitch($Choose_File_GUI)
	Local $AutoIt_Projekte_in_Projektbaum_anzeigen_backup = $AutoIt_Projekte_in_Projektbaum_anzeigen
	$AutoIt_Projekte_in_Projektbaum_anzeigen = "false"
	If $Studiomodus = 1 Then
		Global $Choose_File_Treeview = _GUICtrlTVExplorer_Create($Offenes_Projekt, 10 * $DPI, 40 * $DPI, 480 * $DPI, 355 * $DPI, -1, $WS_EX_CLIENTEDGE, $TV_FLAG_SHOWFILESEXTENSION + $TV_FLAG_SHOWFILES + $TV_FLAG_SHOWFOLDERICON + $TV_FLAG_SHOWFILEICON + $TV_FLAG_SHOWLIKEEXPLORER, "_Projecttree_event", $Filter)
	Else
		Global $Choose_File_Treeview = _GUICtrlTVExplorer_Create("", 10 * $DPI, 40 * $DPI, 480 * $DPI, 355 * $DPI, -1, $WS_EX_CLIENTEDGE, $TV_FLAG_SHOWFILESEXTENSION + $TV_FLAG_SHOWFILES + $TV_FLAG_SHOWFOLDERICON + $TV_FLAG_SHOWFILEICON + $TV_FLAG_SHOWLIKEEXPLORER, "_Projecttree_event", $Filter)
	EndIf
	$AutoIt_Projekte_in_Projektbaum_anzeigen = $AutoIt_Projekte_in_Projektbaum_anzeigen_backup
	Global $Choose_File_hTreeview = GUICtrlGetHandle($Choose_File_Treeview)
	GUICtrlSetFont($Choose_File_Treeview, $treefont_size, 400, 0, $treefont_font) ;Schrift
	GUICtrlSetColor($Choose_File_Treeview, $treefont_colour) ;Farbe
	_GUICtrlTVExplorer_Expand($Choose_File_hTreeview)
	GUISetState(@SW_SHOW, $Choose_File_GUI)
	WinSetOnTop($Choose_File_GUI, "", 1)
EndFunc   ;==>_Choose_File

Func _Choose_external_file()
	_Lock_Plugintabs("lock")
	$Datei = FileOpenDialog(_Get_langstr(969), $Offenes_Projekt, "Files (" & $FilechooseFilter & ")", 3, "", $Choose_File_GUI)
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $Datei = "" Then Return
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	$gelesener_pfad = $Datei
	If $Studiomodus = 1 Then ;Relative Pfade im Projektmodus
		$gelesener_pfad = StringReplace($gelesener_pfad, $Offenes_Projekt & "\", "")
	EndIf
	If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "listpicturesok" & $Plugin_System_Delimiter & $gelesener_pfad)
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview, 1) ;Zerstöre Treeview
EndFunc   ;==>_Choose_external_file


Func _close_Choose_File()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "listpicturesok")
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview, 1) ;Zerstöre Treeview
EndFunc   ;==>_close_Choose_File

Func _Choose_File_OK()
	Local $gelesener_pfad
	If _GUICtrlTreeView_GetSelection($Choose_File_Treeview) = 0 Then Return
	If StringInStr(_GUICtrlTreeView_GetTree($Choose_File_Treeview, _GUICtrlTreeView_GetSelection($Choose_File_Treeview)), ".", 1, -1) = 0 Then Return
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	$gelesener_pfad = _GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)
;~ 	$data = _GUICtrlTreeView_GetTree($Choose_File_Treeview, _GUICtrlTreeView_GetSelection($Choose_File_Treeview))
;~ 	$data = stringtrimleft($data, stringlen($Offenes_Projekt_name) + 1)
;~ 	$data = stringreplace($data, "|", "\")
	If $Studiomodus = 1 Then ;Relative Pfade im Projektmodus
		$gelesener_pfad = StringReplace($gelesener_pfad, $Offenes_Projekt & "\", "")
	EndIf
	If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "listpicturesok" & $Plugin_System_Delimiter & $gelesener_pfad)
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview, 1) ;Zerstöre Treeview
EndFunc   ;==>_Choose_File_OK

;===============================================================================
;
; Description:      Verknüpft Dateierweiterung mit Anwendung
; Parameter(s):     $sFileType    = Dateierweiterung
;                   $sDescription = Beschreibung für die Datei
;                   (optional) $sAppName = Anwendung für die Registriert werden
;                                          soll, wird keine Anwendung angegeben
;                                          wird die aktuelle Anwendung eingetragen
; Requirement(s):   keine
; Return Value(s):  bei Erfolg: 1
;                   bei Fehler: 0 und @error = 1
; Author(s):        bernd670
;
;===============================================================================

Func _RegisterFileType($sFileType, $sDescription, $sAppName = "", $pIcon = "")
	Dim $sTypeName
	If $pIcon = "" Then
		$icon = @ScriptDir & "\autoitstudioicon.ico"
	Else
		$icon = $pIcon
	EndIf
	If $sFileType = "" Or $sDescription = "" Then
		SetError(1)
		Return 0
	EndIf

	If $sAppName = "" Then $sAppName = @ScriptFullPath

	$sFileType = StringLower($sFileType)

	If StringLeft($sFileType, 1) <> "." Then
		$sTypeName = $sFileType
		$sFileType = "." & $sFileType
	Else
		$sTypeName = StringRight($sFileType, StringLen($sFileType) - 1)
	EndIf

	$sTypeName = $sTypeName & "file"

	;Lösche alte Methode mit AllUsers
	RegDelete("HKEY_CLASSES_ROOT\" & $sFileType)
	RegDelete("HKEY_CLASSES_ROOT\" & $sTypeName)

	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\" & $sFileType, "", "REG_SZ", $sTypeName)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\" & $sTypeName, "", "REG_SZ", $sDescription)
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\" & $sTypeName & "\shell\open\command", "", "REG_SZ", '"' & $sAppName & '" "%1"')
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\" & $sTypeName & "\DefaultIcon", "", "REG_SZ", $icon & ",0")

;~ 	RegWrite("HKCR\" & $sFileType, "", "REG_SZ", $sTypeName)
;~ 	RegWrite("HKCR\" & $sTypeName, "", "REG_SZ", $sDescription)
;~ 	RegWrite("HKCR\" & $sTypeName & "\shell\open\command", "", "REG_SZ", $sAppName & " %1")
;~ 	RegWrite("HKCR\" & $sTypeName & "\DefaultIcon", "", "REG_SZ", $icon & ",0")

	SetError(0)
	Return 1
EndFunc   ;==>_RegisterFileType

;===============================================================================
;
; Description:      Hebt Verknüpfung einer Dateierweiterung mit Anwendung auf
; Parameter(s):     $sFileType    = Dateierweiterung
; Requirement(s):   keine
; Return Value(s):  bei Erfolg: 1
;                   bei Fehler: 0 und @error = 1
; Author(s):        bernd670
;
;===============================================================================

Func _UnRegisterFileType($sFileType)
	Dim $sTypeName

	If $sFileType = "" Then
		SetError(1)
		Return 0
	EndIf

	$sFileType = StringLower($sFileType)

	If StringLeft($sFileType, 1) <> "." Then
		$sTypeName = $sFileType
		$sFileType = "." & $sFileType
	Else
		$sTypeName = StringRight($sFileType, StringLen($sFileType) - 1)
	EndIf

	$sTypeName = $sTypeName & "file"

	RegDelete("HKEY_CLASSES_ROOT\" & $sFileType)
	RegDelete("HKEY_CURRENT_USER\SOFTWARE\Classes\" & $sFileType)
	RegDelete("HKEY_CLASSES_ROOT\" & $sTypeName)
	RegDelete("HKEY_CURRENT_USER\SOFTWARE\Classes\" & $sTypeName)

	SetError(0)
	Return 1
EndFunc   ;==>_UnRegisterFileType

Func ShowLineNumbers()
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If $showlines = "false" Then
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETMARGINWIDTHN, 0, 0)
		Else
			$pixelWidth = SendMessageString($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_TEXTWIDTH, $STYLE_LINENUMBER, "99999")
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETMARGINWIDTHN, 0, $pixelWidth) ;
		EndIf
	EndIf
EndFunc   ;==>ShowLineNumbers

;===============================================================================
; Function Name:   _FileDeleteAfterXDays($sPath, $iDays[, $bForceDel][, $bRek][, $bDirDel][, $bLog])
; Description::    löscht Dateien in einem ausgewähltem Verzeichnis (rekursiv)
;                  nach einer angegebenen Anzahl von Tagen
; Parameter(s):    $sPath = Verzeichnis, aus dem die Dateien gelöscht werden sollen.
;                  $iDays = Dateien, die älter als $iDays (in Tagen) sind, löschen.
;                  $bForceDel = wenn "True" werden auch Dateien/Verzeichnisse gelöscht,
;                               die gegen löschen geschützt sind ("R"-Attribut)
;                  $bRek = wenn "True" wird das Verzeichnis rekursiv (inkl. Unter-
;                          verzeichnisse) durchsucht.
;                  $bDirDel = wenn "True" wird das Unterverzeichnis gelöscht, wenn
;                             es (aufgrund der Löschaktion) leer ist.
;                  $bLog = wenn "True" wird das Ergebnis der Löschaktion in die
;                          Console geschrieben.
; Requirement(s):  AutoIt-Version min. v3.3.2.0
;                  #include <Date.au3>
; Return Value(s): bei Erfolg Rückgabe = 1
;                  bei Fehler Rückgabe = 0
;                  und @error:
;                  1 = $iDays ist keine oder eine negative Zahl
;                  2 = Das übergebene Verzeichnis existiert nicht oder ist leer.
; Author(s):       Oscar (www.autoit.de)
;                  Micha_he (www.autoit.de)
;===============================================================================

Func _FileDeleteAfterXDays($sPath, $iDays, $bForceDel = False, $bRek = True, $bDirDel = True, $bLog = False)
	Local $hSearchm, $hEmpty, $sFile, $sDate, $iRet
	;   If (Not IsNumber($iDays)) Or ($iDays < 0) Then Return SetError(1, 0, 0)
	If StringRight($sPath, 1) <> '\' Then $sPath &= '\'
	$hSearch = FileFindFirstFile($sPath & '*.*')
	If @error Then Return SetError(2, 0, 0)
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If @extended Then
			If $bRek Then
				_FileDeleteAfterXDays($sPath & $sFile, $iDays, $bForceDel, $bRek, $bDirDel, $bLog)
				If $bDirDel Then
					$hEmpty = FileFindFirstFile($sPath & $sFile & '\*.*')
					If @error Then
						If $bForceDel Then FileSetAttrib($sPath & $sFile, '-R')
						$iRet = DirRemove($sPath & $sFile)
						If $bLog Then ConsoleWrite('Delete Folder "' & $sPath & $sFile & '" = ' & StringMid('No Yes', $iRet * 3 + 1, 3) & @CR)
					EndIf
					FileClose($hEmpty)
				EndIf
			EndIf
		Else
			$sDate = StringRegExpReplace(FileGetTime($sPath & $sFile, 0, 1), '(\d{4})(\d{2})(\d{2})(.*)', '$1/$2/$3')
			If _DateDiff('D', $sDate, _NowCalc()) > $iDays Then
				If $bForceDel Then FileSetAttrib($sPath & $sFile, '-R')
				$iRet = FileDelete($sPath & $sFile)
				If $bLog Then ConsoleWrite('Delete File "' & $sPath & $sFile & '" = ' & StringMid('No Yes', $iRet * 3 + 1, 3) & @CR)
			EndIf
		EndIf
	WEnd
	FileClose($hSearch)
	Return 1
EndFunc   ;==>_FileDeleteAfterXDays

; #FUNCTION# ====================================================================================================================
; Name...........: _ReduceMemory
; Author ........: w_Outer, Rajesh V R, Prog@ndy
; ===============================================================================================================================

Func _ReduceMemory($iPid = -1)
	If $iPid = -1 Or ProcessExists($iPid) = 0 Then
		Local $ai_GetCurrentProcess = DllCall('kernel32.dll', 'ptr', 'GetCurrentProcess')
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'ptr', $ai_GetCurrentProcess[0])
		Return $ai_Return[0]
	EndIf

	Local $ai_Handle = DllCall("kernel32.dll", 'ptr', 'OpenProcess', 'int', 0x1F0FFF, 'int', False, 'int', $iPid)
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'ptr', $ai_Handle[0])
	DllCall('kernel32.dll', 'int', 'CloseHandle', 'ptr', $ai_Handle[0])
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func _Load_Compiler_settings()
	GUICtrlSetData($compile_compression_combo, "")
	$readen_compress = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_compression", "normal")
	If $readen_compress = "lowest" Then $tmp = _Get_langstr(565)
	If $readen_compress = "low" Then $tmp = _Get_langstr(566)
	If $readen_compress = "normal" Then $tmp = _Get_langstr(567)
	If $readen_compress = "high" Then $tmp = _Get_langstr(568)
	If $readen_compress = "highest" Then $tmp = _Get_langstr(569)
	GUICtrlSetData($compile_compression_combo, _Get_langstr(569) & "|" & _Get_langstr(568) & "|" & _Get_langstr(567) & "|" & _Get_langstr(566) & "|" & _Get_langstr(565), $tmp)

	$mainfile = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "file")
	$Default_Name = StringTrimRight($mainfile, StringLen($mainfile) - StringInStr($mainfile, ".", 0, -1) + 1)
	GUICtrlSetData($Compile_filenameinput, IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_exename", $Default_Name))

	GUICtrlSetData($Compile_Iconpath, IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_exeicon", "%isnstudiodir%\autoitstudioicon.ico"))
	_SetImage($Compile_vorschauicon, _ISN_Variablen_aufloesen(GUICtrlRead($Compile_Iconpath)))

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_mode", "2") = "1" Then
		GUICtrlSetState($Kompilieren_Einstellungen_direktimProjektordnerKompilieren_Checkbox, $GUI_CHECKED)
		GUICtrlSetState($Kompilieren_Einstellungen_Projekt_in_Ordner_Bereitstellen_Checkbox, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Kompilieren_Einstellungen_direktimProjektordnerKompilieren_Checkbox, $GUI_UNCHECKED)
		GUICtrlSetState($Kompilieren_Einstellungen_Projekt_in_Ordner_Bereitstellen_Checkbox, $GUI_CHECKED)
	EndIf


	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_runaftercompile", "false") = "true" Then
		GUICtrlSetState($compile_chckboxrun, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_chckboxrun, $GUI_UNCHECKED)
	EndIf

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_openaftercompile", "true") = "true" Then
		GUICtrlSetState($compile_chckboxopen, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_chckboxopen, $GUI_UNCHECKED)
	EndIf

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_x64", "false") = "true" Then
		GUICtrlSetState($compile_x64_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_x64_checkbox, $GUI_UNCHECKED)
	EndIf

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_source", "false") = "true" Then
		GUICtrlSetState($compile_source, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_source, $GUI_UNCHECKED)
	EndIf

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_useupx", "true") = "true" Then
		GUICtrlSetState($compile_upx_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_upx_checkbox, $GUI_UNCHECKED)
	EndIf

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_console", "false") = "true" Then
		GUICtrlSetState($compile_chckboxconsole, $GUI_CHECKED)
	Else
		GUICtrlSetState($compile_chckboxconsole, $GUI_UNCHECKED)
	EndIf

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_delete_empty_folders", "true") = "true" Then
		GUICtrlSetState($kompilieren_einstellungen_leere_ordner_entfernen_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($kompilieren_einstellungen_leere_ordner_entfernen_checkbox, $GUI_UNCHECKED)
	EndIf

	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_copy_project_resources", "true") = "true" Then
		GUICtrlSetState($kompilieren_einstellungen_projektressourcen_kopieren_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($kompilieren_einstellungen_projektressourcen_kopieren_checkbox, $GUI_UNCHECKED)
	EndIf


	_Kompilieren_Einstellungen_Radio_Events()
EndFunc   ;==>_Load_Compiler_settings

Func _Kompilieren_Einstellungen_Radio_Events()

	If GUICtrlRead($Kompilieren_Einstellungen_direktimProjektordnerKompilieren_Checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($compile_source, $GUI_DISABLE)
		GUICtrlSetState($compile_chckboxopen, $GUI_DISABLE)
		GUICtrlSetState($projekteinstellungen_kompilieren_Ordnerpfad_button, $GUI_DISABLE)
		GUICtrlSetState($projekteinstellungen_kompilieren_Ordnerpfad_input, $GUI_DISABLE)
		GUICtrlSetState($projekteinstellungen_kompilieren_Ordnerpfad_vorschau_label, $GUI_DISABLE)
		GUICtrlSetState($projekteinstellungen_kompilieren_Ordnerpfad_label, $GUI_DISABLE)
		GUICtrlSetState($kompilieren_einstellungen_leere_ordner_entfernen_checkbox, $GUI_DISABLE)
		GUICtrlSetState($kompilieren_einstellungen_projektressourcen_kopieren_checkbox, $GUI_DISABLE)
	Else
		GUICtrlSetState($compile_source, $GUI_ENABLE)
		GUICtrlSetState($compile_chckboxopen, $GUI_ENABLE)
		GUICtrlSetState($projekteinstellungen_kompilieren_Ordnerpfad_button, $GUI_ENABLE)
		GUICtrlSetState($projekteinstellungen_kompilieren_Ordnerpfad_input, $GUI_ENABLE)
		GUICtrlSetState($projekteinstellungen_kompilieren_Ordnerpfad_vorschau_label, $GUI_ENABLE)
		GUICtrlSetState($projekteinstellungen_kompilieren_Ordnerpfad_label, $GUI_ENABLE)
		GUICtrlSetState($kompilieren_einstellungen_leere_ordner_entfernen_checkbox, $GUI_ENABLE)
		GUICtrlSetState($kompilieren_einstellungen_projektressourcen_kopieren_checkbox, $GUI_ENABLE)
		If GUICtrlRead($kompilieren_einstellungen_projektressourcen_kopieren_checkbox) = $GUI_CHECKED Then
			GUICtrlSetState($compile_source, $GUI_ENABLE)
		Else
			GUICtrlSetState($compile_source, $GUI_DISABLE)
			GUICtrlSetState($compile_source, $GUI_UNCHECKED)
		EndIf

	EndIf

EndFunc   ;==>_Kompilieren_Einstellungen_Radio_Events

Func _save_Compiler_settings()
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_exeicon", GUICtrlRead($Compile_Iconpath))

	$exename = GUICtrlRead($Compile_filenameinput)
	$exename = StringReplace($exename, ".exe", "")
	$exename = StringReplace($exename, "<", "")
	$exename = StringReplace($exename, ">", "")
	$exename = StringReplace($exename, "?", "")
	$exename = StringReplace($exename, "!", "")
	$exename = StringReplace($exename, "\", "")
	$exename = StringReplace($exename, "/", "")
	$exename = StringReplace($exename, "*", "")
	$exename = StringReplace($exename, "|", "")
	$exename = StringReplace($exename, '"', "")
	$exename = StringReplace($exename, ':', "")
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_exename", $exename)

	If GUICtrlRead($Kompilieren_Einstellungen_direktimProjektordnerKompilieren_Checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_mode", "1")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_mode", "2")
	EndIf

	If GUICtrlRead($kompilieren_einstellungen_leere_ordner_entfernen_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_delete_empty_folders", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_delete_empty_folders", "false")
	EndIf


	If GUICtrlRead($compile_source) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_source", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_source", "false")
	EndIf

	If GUICtrlRead($compile_x64_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_x64", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_x64", "false")
	EndIf

	If GUICtrlRead($compile_chckboxopen) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_openaftercompile", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_openaftercompile", "false")
	EndIf

	If GUICtrlRead($compile_chckboxrun) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_runaftercompile", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_runaftercompile", "false")
	EndIf

	If GUICtrlRead($compile_upx_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_useupx", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_useupx", "false")
	EndIf

	If GUICtrlRead($compile_chckboxconsole) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_console", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_console", "false")
	EndIf

	If GUICtrlRead($kompilieren_einstellungen_projektressourcen_kopieren_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_copy_project_resources", "true")
	Else
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_copy_project_resources", "false")
	EndIf

	$tmp = GUICtrlRead($compile_compression_combo)
	If $tmp = _Get_langstr(565) Then $readen_compress = "lowest"
	If $tmp = _Get_langstr(566) Then $readen_compress = "low"
	If $tmp = _Get_langstr(567) Then $readen_compress = "normal"
	If $tmp = _Get_langstr(568) Then $readen_compress = "high"
	If $tmp = _Get_langstr(569) Then $readen_compress = "highest"
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_compression", $readen_compress)

EndFunc   ;==>_save_Compiler_settings

Func _Show_Compile()
	If $Offenes_Projekt = "" Then Return
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_KompilierenEinstellungen) <> -1 Then Return ;Platzhalter für Plugin
	If $Studiomodus = 2 Then
		_Zeige_AutoIt3Wrapper_GUI()
		Return
	EndIf

	If FileExists($autoit2exe) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(299), 0, $studiofenster)
		Return
	EndIf

	_Zeige_Projekteinstellungen("compile")
EndFunc   ;==>_Show_Compile



Func _GetShortName($sPath)
	If FileExists($sPath) Then Return FileGetShortName($sPath, 1)

	Local $RetPath = ""
	Local $TailingSlashs = StringRegExpReplace($sPath, '(?i)^.*[^\\]', '')

	If StringInStr($sPath, "\") Then
		Local $sPathArr = StringSplit($sPath, "\")
		For $i = 1 To UBound($sPathArr) - 1
			If StringLen($sPathArr[$i]) > 8 Then
				$RetPath &= StringLeft(StringStripWS($sPathArr[$i], 8), 6) & "~1\"
			Else
				$RetPath &= $sPathArr[$i] & "\"
			EndIf
		Next
		$RetPath = StringRegExpReplace($RetPath, '\\+\z', '')
		$RetPath &= $TailingSlashs
	Else
		If StringLen($sPath) > 8 Then
			$RetPath = StringLeft(StringStripWS($sPath, 8), 6) & "~1"
		Else
			$RetPath = $sPath
		EndIf
	EndIf
	Return StringUpper($RetPath)
EndFunc   ;==>_GetShortName

Func _Start_Compiling_Adlib()
AdlibRegister("_Start_Compiling",250)
return $compilingGUI
EndFunc


Func _Start_Compiling()
	AdlibUnRegister("_Start_Compiling")
	If $Offenes_Projekt = "" Then Return
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_ProjektKompilieren) <> -1 Then Return ;Platzhalter für Plugin
	If $Studiomodus = 2 Then
		_Kompilieren_Editormodus()
		Return
	EndIf

	_STOPSCRIPT() ;Wenn noch ein Skript läuft -> Stoppen!

	_Load_Compiler_settings()

	If $Templatemode = 1 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(386), 0, $studiofenster)
		Return
	EndIf

	If FileExists($autoit2exe) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(299), 0, $studiofenster)
		Return
	EndIf

	If Not FileExists(_ISN_Variablen_aufloesen(GUICtrlRead($Compile_Iconpath))) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(664), 0, $studiofenster)
		Return
	EndIf

	If Not FileExists($AutoIt3Wrapper_exe_path) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1032), 0, $studiofenster)
		Return
	EndIf

	GUICtrlSetData($Statuscompile, _Get_langstr(244))
	GUISetState(@SW_SHOW, $compilingGUI)
	GUISetState(@SW_DISABLE, $StudioFenster)
	_Save_All_only_script_tabs() ;Speichern aller Skintilla Tabs
	Sleep(500)



	$Compile_Mode = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_mode", "2")
	$Kompilieren_laeuft = 1
	If $Compile_Mode = "2" Then
		;Projekt in neuem Ordner bereitstellen
		GUICtrlSetData($Statuscompile, _Get_langstr(243))

		If $releasemode = 1 Then
			$zielpfad = _ISN_Variablen_aufloesen($releasefolder)
			DirCreate($zielpfad)
			DirRemove($zielpfad & "\" & _ISN_Variablen_aufloesen(_ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%")), 1)
			DirCreate($zielpfad & "\" & _ISN_Variablen_aufloesen(_ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%")))
			$zielpfad = $zielpfad & "\" & _ISN_Variablen_aufloesen(_ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%"))
		EndIf

		If $releasemode = 2 Then
			DirRemove($Arbeitsverzeichnis & "\data\cache\tempcompile", 1)
			$directory = _ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%")
			$directory = StringReplace($directory, "%projectname%", "")
			$directory = StringReplace($directory, "\\", "")
			If StringLeft($directory, 1) = "\" Then $directory = StringTrimLeft($directory, 1)
			$directory = _ISN_Variablen_aufloesen($directory)
			If $directory <> "" Then $directory = "\" & $directory
			$zielpfad = $Offenes_Projekt & "\" & _ISN_Variablen_aufloesen($releasefolder) & $directory
			DirCreate($zielpfad)
			DirRemove($zielpfad, 1)
			DirCreate($zielpfad)
			$zielpfad = $Arbeitsverzeichnis & "\data\cache\tempcompile"
			DirCreate($zielpfad)
		EndIf
	Else
		;Projekt in Projektordner Kompilieren
		$zielpfad = $Offenes_Projekt
	EndIf



	Sleep(500)


	$mainfile = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "")
	$Default_Name = StringTrimRight($mainfile, StringLen($mainfile) - StringInStr($mainfile, ".", 0, -1) + 1)

	$exename = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_exename", $Default_Name)
	$exename = StringReplace($exename, "?", "")
	$exename = StringReplace($exename, "=", "")
	$exename = StringReplace($exename, ",", "")
	$exename = StringReplace($exename, "\", "")
	$exename = StringReplace($exename, "/", "")
	$exename = StringReplace($exename, '"', "")
	$exename = StringReplace($exename, "<", "")
	$exename = StringReplace($exename, ">", "")
	$exename = StringReplace($exename, "*", "")
	$exename = StringReplace($exename, "|", "")
	$exename = $exename & ".exe"
	_Clear_Debuglog()


	$Adittional_Prams = ""
	If GUICtrlRead($compile_x64_checkbox) = $GUI_CHECKED Then $Adittional_Prams = $Adittional_Prams & "/x64 "
	If GUICtrlRead($compile_upx_checkbox) = $GUI_UNCHECKED Then $Adittional_Prams = $Adittional_Prams & "/nopack "
;~ 	if GuiCtrlRead($compile_compression_combo) = $GUI_UNCHECKED Then $Adittional_Prams = $Adittional_Prams & "/nopack "
	If GUICtrlRead($compile_chckboxconsole) = $GUI_CHECKED Then $Adittional_Prams = $Adittional_Prams & "/console "
	$readen_compress = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_compression", "normal")
	If $readen_compress = "lowest" Then $Adittional_Prams = $Adittional_Prams & "/comp 0 "
	If $readen_compress = "low" Then $Adittional_Prams = $Adittional_Prams & "/comp 1 "
	If $readen_compress = "normal" Then $Adittional_Prams = $Adittional_Prams & "/comp 2 "
	If $readen_compress = "high" Then $Adittional_Prams = $Adittional_Prams & "/comp 3 "
	If $readen_compress = "highest" Then $Adittional_Prams = $Adittional_Prams & "/comp 4 "

	$iconpath = _ISN_Variablen_aufloesen(GUICtrlRead($Compile_Iconpath))
	$iconpath = _ISN_Variablen_aufloesen($iconpath)

	;Makro "vor Projekt kompilieren"
	GUICtrlSetData($Statuscompile, _Get_langstr(879))
	_run_rule($Section_Trigger20_beforecompileproject)
	Sleep(200)

	;Zusätzliche Dateien & Hauptdatei kompilieren
	$Dateien = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "additional_files_to_compile", "")
	If Not StringInStr($Dateien, _ISN_Pfad_durch_Variablen_ersetzen($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", ""))) Then $Dateien = _ISN_Pfad_durch_Variablen_ersetzen($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "")) & "|" & $Dateien
	If StringRight($Dateien, 1) = "|" Then $Dateien = StringTrimRight($Dateien, 1)
	$additional_files_array = StringSplit($Dateien, "|", 2)
	If IsArray($additional_files_array) Then
		For $y = 0 To UBound($additional_files_array) - 1
			If $Kompilieren_laeuft = 0 Then ExitLoop
			If $additional_files_array[$y] = "" Then ContinueLoop
			If $additional_files_array[$y] = "|" Then ContinueLoop
			If Not FileExists(_ISN_Variablen_aufloesen($additional_files_array[$y])) Then ContinueLoop
			If _ISN_Variablen_aufloesen($additional_files_array[$y]) = $Offenes_Projekt & "\" & $mainfile Then
				;Hauptdatei


;~ 				$Console_Bluemode = 1
				GUICtrlSetData($Statuscompile, _Get_langstr(245))
				$Zuletzt_Kompilierte_Datei_Pfad_au3 = $Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "") ;Dateipfad der zuletzt kompilierten Datei (.au3 Datei)

				;Dateiinhalt vor dem Kompilieren einlesen (sichern)
				Local $hFile = FileOpen($Zuletzt_Kompilierte_Datei_Pfad_au3, $FO_READ + FileGetEncoding($Zuletzt_Kompilierte_Datei_Pfad_au3))
				Local $Hauptdateiinhalt_vor_dem_Kompilieren = FileRead($hFile, FileGetSize($Zuletzt_Kompilierte_Datei_Pfad_au3))
				FileClose($hFile)
				If Not _System_benoetigt_double_byte_character_Support() Then $Hauptdateiinhalt_vor_dem_Kompilieren = _ANSI2UNICODE($Hauptdateiinhalt_vor_dem_Kompilieren)


				_run_rule($Section_Trigger21_beforecompilefile) ;Makro "Vor datei kompilieren"
				$data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /in "' & $Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "") & '" /out "' & $zielpfad & "\" & $exename & '" ' & $Adittional_Prams & ' /icon "' & $iconpath & '"', 0, $Offenes_Projekt, @SW_HIDE, 1)
				$Zuletzt_Kompilierte_Datei_Pfad_exe = $zielpfad & "\" & $exename ;Dateipfad der zuletzt kompilierten Datei (.exe Datei)
				Dim $szDrive, $szDir, $szFName, $szExt
				$path = _PathSplit(IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", ""), $szDrive, $szDir, $szFName, $szExt)
				If FileExists($Offenes_Projekt & "\" & _GetShortName($szFName) & "_Obfuscated" & $szExt) Then FileDelete($Offenes_Projekt & "\" & _GetShortName($szFName) & "_Obfuscated" & $szExt)
				If FileExists($Offenes_Projekt & "\" & _GetShortName($szFName) & "_stripped" & $szExt) Then FileDelete($Offenes_Projekt & "\" & _GetShortName($szFName) & "_stripped" & $szExt)
				If FileExists($Offenes_Projekt & "\" & $szFName & "_Obfuscated" & $szExt) Then FileDelete($Offenes_Projekt & "\" & $szFName & "_Obfuscated" & $szExt)
				If FileExists($Offenes_Projekt & "\" & $szFName & "_stripped" & $szExt) Then FileDelete($Offenes_Projekt & "\" & $szFName & "_stripped" & $szExt)
				If FileExists($Offenes_Projekt & "\" & _GetShortName(IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "")) & ".tbl") Then FileDelete($Offenes_Projekt & "\" & _GetShortName(IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "")) & ".tbl")
				If FileExists($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "") & ".tbl") Then FileDelete($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "") & ".tbl")
;~ 				$Console_Bluemode = 0
				_run_rule($Section_Trigger19_compilefile) ;Makro "Nach datei kompilieren"
				Sleep(500)

				;Exit Codes Analysieren und ggf. Änderungen vornehmen
				If IsArray($data) Then
					If $data[1] <> 0 Then
						$result = MsgBox(262196, _Get_langstr(394), StringReplace(_Get_langstr(1138), "%1", $szFName & $szExt) & @CRLF & @CRLF & _Get_langstr(1140), 0, $compilingRule)
						If $result = 7 Then $Kompilieren_laeuft = 0 ;Stoppe weitere ausführung
					EndIf
				EndIf


			Else
				GUICtrlSetData($Statuscompile, StringReplace(_Get_langstr(1069), "%1", $additional_files_array[$y]))
				_AU3_aus_Projektbaum_Direkt_Kompilieren(_ISN_Variablen_aufloesen($additional_files_array[$y]), 1)
			EndIf
		Next
	EndIf




	If $Kompilieren_laeuft = 0 Then
		GUISetState(@SW_ENABLE, $StudioFenster)
		GUISetState(@SW_HIDE, $compilingGUI)
		Return
	EndIf

	Sleep(500)
	If $Compile_Mode = "2" Then
		;Projekt in neuem Ordner bereitstellen

		If GUICtrlRead($kompilieren_einstellungen_projektressourcen_kopieren_checkbox) = $GUI_CHECKED Then
			GUICtrlSetData($Statuscompile, _Get_langstr(246))
			_FileOperationProgress($Offenes_Projekt & "\*.*", $zielpfad, 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			DirRemove(_ISN_Variablen_aufloesen($zielpfad & "\" & $releasefolder), 1) ;Damit der Relase Ordner nicht nochmals im Release Ordner landet
		EndIf

		If GUICtrlRead($compile_source) = $GUI_UNCHECKED Then
			_File_Delete_Wild($zielpfad, ".isn")
			_File_Delete_Wild($zielpfad, ".au3")
			_File_Delete_Wild($zielpfad, ".isf")
		EndIf
	EndIf


	Sleep(1000)
	GUICtrlSetData($Statuscompile, _Get_langstr(247))

	If $Compile_Mode = "2" Then
		;Projekt in neuem Ordner bereitstellen

		;Leere Ordner löschen
		If GUICtrlRead($kompilieren_einstellungen_leere_ordner_entfernen_checkbox) = $GUI_CHECKED Then _delEmpty($zielpfad)
		If $releasemode = 2 Then
			$directory = _ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%")
			$directory = StringReplace($directory, "%projectname%", "")
			$directory = StringReplace($directory, "\\", "")
			If StringLeft($directory, 1) = "\" Then $directory = StringTrimLeft($directory, 1)
			$directory = _ISN_Variablen_aufloesen($directory)
			If $directory <> "" Then $directory = "\" & $directory
			_FileOperationProgress($Arbeitsverzeichnis & "\data\cache\tempcompile\*.*", $Offenes_Projekt & "\" & _ISN_Variablen_aufloesen($releasefolder) & $directory, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			$zielpfad = $Offenes_Projekt & "\" & _ISN_Variablen_aufloesen($releasefolder)
		EndIf
	EndIf



	;Makro "Nach Projekt kompilieren"
	GUICtrlSetData($Statuscompile, _Get_langstr(879))
	_run_rule($Section_Trigger2)
	Sleep(200)


	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $compilingGUI)
	_WinFlash($Studiofenster)
	_Earn_trophy(4, 1)

	If GUICtrlRead($compile_chckboxopen) = $GUI_CHECKED And $Compile_Mode = "2" Then ShellExecute("explorer.exe", FileGetShortName($zielpfad))
	If GUICtrlRead($compile_chckboxrun) = $GUI_CHECKED Then
		Run(FileGetShortName($zielpfad & "\" & $exename))
	EndIf

	If _Pruefe_ob_Datei_geoeffnet($Offenes_Projekt & "\" & $mainfile) = "true" Then ;Lese Mainfile neu ein

		;Dateiinhalt nach dem Kompilieren einlesen, und falls sich etwas verändert hat -> Datei neu einlesen
		Local $hFile = FileOpen($Offenes_Projekt & "\" & $mainfile, $FO_READ + FileGetEncoding($Offenes_Projekt & "\" & $mainfile))
		Local $Hauptdateiinhalt_nach_dem_Kompilieren = FileRead($hFile, FileGetSize($Offenes_Projekt & "\" & $mainfile))
		FileClose($hFile)
		If Not _System_benoetigt_double_byte_character_Support() Then $Hauptdateiinhalt_nach_dem_Kompilieren = _ANSI2UNICODE($Hauptdateiinhalt_nach_dem_Kompilieren)

		If $Hauptdateiinhalt_nach_dem_Kompilieren <> $Hauptdateiinhalt_vor_dem_Kompilieren Then
			$tabpage = _GUICtrlTab_FindTab($htab, StringTrimLeft($Offenes_Projekt & "\" & $mainfile, StringInStr($Offenes_Projekt & "\" & $mainfile, "\", 0, -1)))
			If $tabpage <> -1 Then
				$res = _ArraySearch($Datei_pfad, $Offenes_Projekt & "\" & $mainfile)
				If $res <> -1 Then
					$tabpage = $res
				Else
					$tabpage = -1
				EndIf
			EndIf
			$old_cur_pos = Sci_GetCurrentPos($SCE_EDITOR[$tabpage])
			LoadEditorFile($SCE_EDITOR[$tabpage], $Offenes_Projekt & "\" & $mainfile)
			$FILE_CACHE[$tabpage] = Sci_GetLines($SCE_EDITOR[$tabpage])
			_Editor_Restore_Fold()
			Sci_SetCurrentPos($SCE_EDITOR[$tabpage], $old_cur_pos)
		EndIf
	EndIf
	$Kompilieren_laeuft = 0
	;_Update_Treeview() ;Zum Abschluss noch den Projektbaum aktualisieren
EndFunc   ;==>_Start_Compiling

Func _WinFlash($hGUI = "")
	If $hGUI = "" Then Return
	If Not WinActive($hGUI) Then WinFlash($hGUI)
EndFunc   ;==>_WinFlash

Func _delEmpty($dir)
	$folderList = _FileListToArray($dir, "*", 2)
	If @error <> 4 Then
		For $i = 1 To $folderList[0]
			_delEmpty($dir & "\" & $folderList[$i])
		Next
	EndIf
	$filelist = _FileListToArray($dir, -1, 0)
	If @error = 4 Then DirRemove($dir)
EndFunc   ;==>_delEmpty

Func _File_Delete_Wild($path, $filetype)
	$Search = FileFindFirstFile($path & "\*.*")
	If $Search <> -1 Then
		While 1
			$file = FileFindNextFile($Search)
			If @error Then ExitLoop
			If StringInStr(FileGetAttrib($path & "\" & $file), "D") Then
				_File_Delete_Wild($path & "\" & $file, $filetype)
			Else
				If StringInStr($path & "\" & $file, $filetype) Then FileDelete($path & "\" & $file)
			EndIf
		WEnd
	EndIf
	FileClose($Search)

EndFunc   ;==>_File_Delete_Wild

Func _runhelp()
	If FileExists($helpfile) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(301), 0, $studiofenster)
		Return
	EndIf
	ShellExecute($helpfile)

EndFunc   ;==>_runhelp

Func _Show_Warning($warningID, $icon, $titel = "", $text = "", $bt1_text = "", $bt2_text = "")
	If IniRead($Configfile, "warnings", $warningID, "0") = 1 Then Return 1
	While 1
		If _IsPressed("01", $user32) = 0 Then ExitLoop
		Sleep(50)
	WEnd
	$text = StringReplace($text, "[BREAK]", @CRLF)
	GUICtrlSetImage($Warnmeldung_ico, $bigiconsdll, $icon)
	GUICtrlSetData($Warnmeldung_titel, $titel)
	GUICtrlSetData($Warnmeldung_text, $text)
	WinSetTitle($warn, "", $titel)
	GUICtrlSetData($Warnmeldung_Button1, $bt1_text)
	GUICtrlSetData($Warnmeldung_Button2, $bt2_text)
	GUICtrlSetState($Warnmeldung_checkbox, $GUI_UNCHECKED)
	If $bt2_text = "" Then
		GUICtrlSetState($Warnmeldung_Button2, $GUI_HIDE)
	Else
		GUICtrlSetState($Warnmeldung_Button2, $GUI_SHOW)
	EndIf
	$return = 0
	GUISetState(@SW_SHOW, $warn)
	GUISetState(@SW_DISABLE, $StudioFenster)
	WinSetOnTop($warn, "", 1)
	While 1
		Sleep(50)
		If _IsPressed("20", $user32) Or _IsPressed("0D", $user32) Then
			$return = 1
			ExitLoop
		EndIf

		$a = GUIGetCursorInfo($warn)
		If Not IsArray($a) Then Return
		If $a[2] = 1 Then
			If $a[4] = $Warnmeldung_Button1 Then
				$return = 1
				ExitLoop
			EndIf
			If $a[4] = $Warnmeldung_Button2 Then
				$return = 2
				ExitLoop
			EndIf
		EndIf
	WEnd
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $warn)
	If GUICtrlRead($Warnmeldung_checkbox) = $GUI_CHECKED Then IniWrite($Configfile, "warnings", $warningID, "1")
	Return $return
EndFunc   ;==>_Show_Warning

Func _In_Datei_suchen_Eintrag_oeffnen()
	If _GUICtrlListView_GetItemCount($in_dateien_suchen_gefundene_elemente_listview) = 0 Then Return
	$line = _GUICtrlListView_GetItemText($in_dateien_suchen_gefundene_elemente_listview, _GUICtrlListView_GetSelectionMark($in_dateien_suchen_gefundene_elemente_listview), 1)
	$line = $line - 1
	If $line < 1 Then $line = 1
	$Pfad = _GUICtrlListView_GetItemText($in_dateien_suchen_gefundene_elemente_listview, _GUICtrlListView_GetSelectionMark($in_dateien_suchen_gefundene_elemente_listview), 2)
	$Pfad = _ISN_Variablen_aufloesen($Pfad)

	$alreadyopen = _GUICtrlTab_FindTab($htab, StringTrimLeft($Pfad, StringInStr($Pfad, "\", 0, -1)))
	If $alreadyopen <> -1 Then
		$res = _ArraySearch($Datei_pfad, $Pfad)
		If $res <> -1 Then
			$alreadyopen = $res
		Else
			$alreadyopen = -1
		EndIf
	EndIf
	If $alreadyopen = -1 Then
		_openscriptfile($Pfad)
		_Add_File_to_Backuplist($Pfad)
		If $Offene_tabs > 14 Then _Earn_trophy(9, 2)
		_Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($Pfad)
	Else
		If _GUICtrlTab_GetCurFocus($htab) <> $alreadyopen Then
			_GUICtrlTab_ActivateTabX($htab, $alreadyopen)
			_Show_Tab($alreadyopen)
		EndIf
	EndIf

	GoToLine($line)
EndFunc   ;==>_In_Datei_suchen_Eintrag_oeffnen

Func _In_Dateien_Suchen_exportiere_Liste_als_csv()
	If _GUICtrlListView_GetItemCount($in_dateien_suchen_gefundene_elemente_listview) = 0 Then Return
	_Lock_Plugintabs("lock")
	$line = FileSaveDialog(_Get_langstr(740), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "csv (*.csv)", 18, "export.csv", $in_ordner_nach_text_suchen_gui)
	_Lock_Plugintabs("unlock")
	If $line = "" Then Return
	If @error > 0 Then Return
	FileChangeDir(@ScriptDir)
	_GUICtrlListView_SaveCSV($in_dateien_suchen_gefundene_elemente_listview, $line)
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $in_ordner_nach_text_suchen_gui)
EndFunc   ;==>_In_Dateien_Suchen_exportiere_Liste_als_csv

Func _In_Dateien_Suchen_Datei_auswaehlen()
	_Lock_Plugintabs("lock")
	$var = FileOpenDialog(_Get_langstr(187), $Offenes_Projekt, "All (*.*)", 1 + 2 + 4, "", $in_ordner_nach_text_suchen_gui)
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return
	$var = _ISN_Pfad_durch_Variablen_ersetzen($var)
	GUICtrlSetData($in_dateien_suchen_ordner_input, $var)
EndFunc   ;==>_In_Dateien_Suchen_Datei_auswaehlen

Func _Toggle_In_Dateien_Suchen()
	If $Offenes_Projekt = "" Then Return
	$state = WinGetState($in_ordner_nach_text_suchen_gui, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_HIDE, $in_ordner_nach_text_suchen_gui)
	Else
		GUISetState(@SW_SHOW, $in_ordner_nach_text_suchen_gui)
	EndIf
EndFunc   ;==>_Toggle_In_Dateien_Suchen

; #FUNCTION# ====================================================================================================================
; Name ..........: _FindInFile
; Description ...: Search for a string within files located in a specific directory.
; Syntax ........: _FindInFile($sSearch, $sFilePath[, $sMask = '*'[, $fRecursive = True[, $fLiteral = Default[,
;                  $fCaseSensitive = Default[, $fDetail = Default]]]]])
; Parameters ....: $sSearch             - The keyword to search for.
;                  $sFilePath           - The folder location of where to search.
;                  $sMask               - [optional] A list of filetype extensions separated with ';' e.g. '*.au3;*.txt'. Default is all files.
;                  $fRecursive          - [optional] Search within subfolders. Default is True.
;                  $fLiteral            - [optional] Use the string as a literal search string. Default is False.
;                  $fCaseSensitive      - [optional] Use Search is case-sensitive searching. Default is False.
;                  $fDetail             - [optional] Show filenames only. Default is False.
;                  $regex          		- [optional] Search as regex
; Return values .: Success - Returns a one-dimensional and is made up as follows:
;                            $aArray[0] = Number of rows
;                            $aArray[1] = 1st file
;                            $aArray[n] = nth file
;                  Failure - Returns an empty array and sets @error to non-zero
; Author ........: guinness
; Remarks .......: For more details: http://ss64.com/nt/findstr.html
; Example .......: Yes
; ===============================================================================================================================
Func _FindInFile($sSearch, $sFilePath, $sMask = '*', $fRecursive = True, $fLiteral = Default, $fCaseSensitive = Default, $fDetail = Default, $regex = False)
	Local $sCaseSensitive = $fCaseSensitive ? '' : '/i', $sDetail = $fDetail ? '/n' : '/m', $sRecursive = ($fRecursive Or $fRecursive = Default) ? '/s' : ''
	$fLiteral_str = " "
	If $fLiteral Then
		$fLiteral_str = ' /c:'
	EndIf

	If $sMask = Default Then
		$sMask = '*'
	EndIf
	Local $Weitere_Optionen = "/P "
	If $regex = True Then $Weitere_Optionen = $Weitere_Optionen & "/R "
	$Weitere_Optionen = StringStripWS($Weitere_Optionen, 3)
	$FileAttrib = FileGetAttrib($sFilePath)
	$sFilePath = StringRegExpReplace($sFilePath, '[\\/]+$', '')
	If StringInStr($FileAttrib, "D", 1) Then $sFilePath = $sFilePath & '\'
	Local Const $aMask = StringSplit($sMask, ';')
	Local $sOutput = ''
	For $i = 1 To $aMask[0]
		If StringInStr($FileAttrib, "D", 1) Then
			$FindInFile_iPID = Run(@ComSpec & ' /c ' & 'findstr ' & $Weitere_Optionen & ' ' & $sCaseSensitive & ' ' & $sDetail & ' ' & $sRecursive & $fLiteral_str & '"' & $sSearch & '" "' & $sFilePath & $aMask[$i] & '"', @SystemDir, @SW_HIDE, $STDOUT_CHILD)
		Else
			$FindInFile_iPID = Run(@ComSpec & ' /c ' & 'findstr ' & $Weitere_Optionen & ' ' & $sCaseSensitive & ' ' & $sDetail & ' ' & $fLiteral_str & '"' & $sSearch & '" "' & $sFilePath & '"', @SystemDir, @SW_HIDE, $STDOUT_CHILD)
		EndIf

		While 1
			If Not ProcessExists($FindInFile_iPID) Then ExitLoop
			Sleep(100)
		WEnd
		$sOutput &= StdoutRead($FindInFile_iPID)

	Next

	Return StringSplit(StringStripWS(StringStripCR($sOutput), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING)), @LF, 2)
EndFunc   ;==>_FindInFile

Func _In_Dateien_suchen_Suche_starten()
	If GUICtrlRead($in_dateien_suchen_suchtext_input) = "" Then
		_Input_Error_FX($in_dateien_suchen_suchtext_input)
		Return
	EndIf

	If GUICtrlRead($in_dateien_suchen_ordner_input) = "" Then
		_Input_Error_FX($in_dateien_suchen_ordner_input)
		Return
	EndIf

	If GUICtrlRead($in_dateien_suchen_dateitypen_input) = "" Then GUICtrlSetData($in_dateien_suchen_dateitypen_input, "*")

	$Ordner = GUICtrlRead($in_dateien_suchen_ordner_input)
	$Ordner = _ISN_Variablen_aufloesen($Ordner) ;Varaiblen auflösen

	$CaseSensitive = False
	If GUICtrlRead($in_dateien_suchen_grosskleinschreibung_checkbox) = $GUI_CHECKED Then $CaseSensitive = True

	$Recursive = True
	If GUICtrlRead($in_dateien_suchen_unterordner_checkbox) = $GUI_UNCHECKED Then $Recursive = False

	$regex = False
	If GUICtrlRead($in_dateien_suchen_regex_checkbox) = $GUI_CHECKED Then $regex = True

	$wholeword = True
	If GUICtrlRead($in_dateien_suchen_ganzewoerter_checkbox) = $GUI_UNCHECKED Then $wholeword = False

	GUISetState(@SW_SHOW, $ISN_In_Ordner_nach_Text_Suchen_Suche_laeuft_gui)
	GUISetState(@SW_DISABLE, $in_ordner_nach_text_suchen_gui)
	Local $Gefundene_Elemente_Array = _FindInFile(GUICtrlRead($in_dateien_suchen_suchtext_input), $Ordner, GUICtrlRead($in_dateien_suchen_dateitypen_input), $Recursive, $wholeword, $CaseSensitive, True, $regex) ; Search for 'findinfile' within the @ScripDir and only in .au3 & .txt files.
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($in_dateien_suchen_gefundene_elemente_listview))
	If Not IsArray($Gefundene_Elemente_Array) Then
		GUISetState(@SW_ENABLE, $in_ordner_nach_text_suchen_gui)
		GUISetState(@SW_HIDE, $ISN_In_Ordner_nach_Text_Suchen_Suche_laeuft_gui)
		Return
	EndIf

	_GUICtrlListView_BeginUpdate($in_dateien_suchen_gefundene_elemente_listview)

	$FileAttrib = FileGetAttrib($Ordner)

	For $Count = 0 To UBound($Gefundene_Elemente_Array) - 1
		$String = $Gefundene_Elemente_Array[$Count]

		;Ausgabe aufbereiten
		If StringInStr($FileAttrib, "D", 1) Then
			$String = StringReplace($String, ":", "[SYS]", 1)
			$String = StringReplace($String, ":", "[STRBREAK]", 1)
			$String = StringReplace($String, ":", "[STRBREAK]", 1)
			$String = StringReplace($String, "[SYS]", ":")
		Else
			$String = StringReplace($String, ":", "[STRBREAK]", 1)
		EndIf

		;Und splitten
		$string_splitted = StringSplit($String, "[STRBREAK]", 3)
		;ConsoleWrite($string&@crlf)

		If StringInStr($FileAttrib, "D", 1) Then
			If Not IsArray($string_splitted) Or UBound($string_splitted) < 3 Then ContinueLoop

			$Dateiname = $string_splitted[0]
			$Dateiname = _ISN_Pfad_durch_Variablen_ersetzen($Dateiname)

			$Gefundener_Text_Zeile = $string_splitted[1]
			$Gefundener_Text = $string_splitted[2]
		Else
			If Not IsArray($string_splitted) Or UBound($string_splitted) < 2 Then ContinueLoop

			$Dateiname = $Ordner
			$Dateiname = _ISN_Pfad_durch_Variablen_ersetzen($Dateiname)

			$Gefundener_Text_Zeile = $string_splitted[0]
			$Gefundener_Text = $string_splitted[1]

		EndIf


		_GUICtrlListView_AddItem($in_dateien_suchen_gefundene_elemente_listview, $Gefundener_Text)
		_GUICtrlListView_AddSubItem($in_dateien_suchen_gefundene_elemente_listview, _GUICtrlListView_GetItemCount($in_dateien_suchen_gefundene_elemente_listview) - 1, $Gefundener_Text_Zeile, 1)
		_GUICtrlListView_AddSubItem($in_dateien_suchen_gefundene_elemente_listview, _GUICtrlListView_GetItemCount($in_dateien_suchen_gefundene_elemente_listview) - 1, $Dateiname, 2)
	Next


	_GUICtrlListView_EndUpdate($in_dateien_suchen_gefundene_elemente_listview)
	GUISetState(@SW_ENABLE, $in_ordner_nach_text_suchen_gui)
	GUISetState(@SW_HIDE, $ISN_In_Ordner_nach_Text_Suchen_Suche_laeuft_gui)
EndFunc   ;==>_In_Dateien_suchen_Suche_starten


;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



Func _Reset_Search()
	GUICtrlSetColor($hTreeview2_searchinput, $Skriptbaum_Suchfeld_Schriftfarbe)
	GUICtrlSetBkColor($hTreeview2_searchinput, $Skriptbaum_Suchfeld_Hintergrundfarbe)
	;GUICtrlSetFont($hTreeview2_searchinput, 9, 400, 2)
	GUICtrlSetData($hTreeview2_searchinput, "")
EndFunc   ;==>_Reset_Search

;Eine der wichtigsten Funktionen
;Ohne diese würden Kontextmenüs, Toolbarbuttons und weitere Dinge ohne Funktion bleiben

Func _InputCheck($hWndGUI, $MsgID, $wParam, $lParam)
   ;Erkenne Scintilla Control
   If _WinAPI_GetClassName($lParam) = "Scintilla" Then Return 'GUI_RUNDEFMSG'

	$nID = BitAND($wParam, 0x0000FFFF)
	;-----

	If WinActive($New_file_GUI) And _IsPressed("0D", $user32) And $wParam = 1 Then _Make_New_File() ;enter in new file
	If WinActive($New_file_GUI) And _IsPressed("1B", $user32) And $wParam = 2 Then _HIDE_New_Filegui() ;esc in new file


	If $nID = $hTreeview2_searchinput Then
		If GUICtrlRead($hTreeview2_searchinput) = "" Then GUICtrlSetBkColor($hTreeview2_searchinput, $Skriptbaum_Suchfeld_Hintergrundfarbe)
	EndIf


	$Class = ControlGetFocus($Studiofenster)
	If ControlGetHandle($Studiofenster, "", "[CLASSNN:" & $Class & "]") = GUICtrlGetHandle($hTreeview2_searchinput) And $wParam = 1 Then
		If GUICtrlRead($hTreeview2_searchinput) <> "" Then _search_in_Scripttree()
		Return
	EndIf

	Switch $nID
		Case $ISN_In_Ordner_nach_Text_Suchen_Suche_laeuft_abbrechen_button
			If ProcessExists($FindInFile_iPID) Then
				Run(@ComSpec & " /c taskkill /F /PID " & $FindInFile_iPID & " /T", @SystemDir, @SW_HIDE)
				$FindInFile_iPID = ""
			EndIf

		Case $SCI_EDITOR_CONTEXT_speichern
			_try_to_save_file(_GUICtrlTab_GetCurFocus($htab))
		Case $Skriptbaum_SetupMenu_Skriptbaum_konfigrieren
			_Zeige_Skriptbaum_Einstellungen()
		Case $Skriptbaum_SetupMenu_Filter
			_Zeige_Skriptbaum_FilterGUI()
		Case $SCI_EDITOR_CONTEXT_oeffneHilfe
			_open_helpfile_keyword()
		Case $SCI_EDITOR_CONTEXT_rueckgaengig
			_try_undo()
		Case $SCI_EDITOR_CONTEXT_wiederholen
			_try_redo()
		Case $SCI_EDITOR_CONTEXT_kopieren
			_trytocopy()
		Case $SCI_EDITOR_CONTEXT_einfuegen
			_trytopaste()
		Case $SCI_EDITOR_CONTEXT_loeschen
			_trytodelete()
		Case $SCI_EDITOR_CONTEXT_suche
			_Toggle_Search()
		Case $SCI_EDITOR_CONTEXT_Auskommentieren
			_comment_out()
		Case $SCI_EDITOR_CONTEXT_ausschneiden
			_trytocut()
		Case $Tools_menu_In_Dateien_suchen
			_Toggle_In_Dateien_Suchen()
		Case $HelpMenu_spenden
			_ISN_AutoIt_Studio_Spenden()
		Case $TabContextMenu_Item1
			_try_to_save_file(_GUICtrlTab_GetCurFocus($htab))
		Case $id10
			_try_to_save_file(_GUICtrlTab_GetCurFocus($htab))
		Case $Dateimenue_Oeffnen
			_Try_to_open_external_file()
		Case $id23
			_open_windowinfotool()
		Case $SCI_EDITOR_CONTEXT_debugtoMsgBox
			_Debug_to_msgbox()
		Case $SCI_EDITOR_CONTEXT_debugtoConsole
			_Debug_to_console()
		Case $Tools_menu_debugging_debugtoMsgBox
			_Debug_to_msgbox()
		Case $Tools_menu_debugging_debugtoconsole
			_Debug_to_console()
		Case $Tools_menu_item2
			_open_windowinfotool()
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot1
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 0) ;Call muss verwendet werden da direkter aufruf einen Fehler in der GUI erzeugt (Fenster wird verschoben?!?=
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot2
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 1)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot3
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 2)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot4
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 3)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot4
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 3)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot5
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 4)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot6
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 5)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot7
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 6)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot8
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 7)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot9
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 8)
		Case $FileMenu_zuletzt_verwendete_Dateien_Slot10
			Call("_Oeffne_Zuletzt_Verwendete_Dateie", 9)
		Case $FileMenu_item1
			_try_to_save_file(_GUICtrlTab_GetCurFocus($htab))
		Case $FileMenu_item1c
			_Speichern_unter()
		Case $TreeviewContextMenu_makroslot1
			If $TreeviewContextMenu_makroslot1 <> "" Then _ISN_execute_macroslot_01()
		Case $TreeviewContextMenu_makroslot2
			If $TreeviewContextMenu_makroslot2 <> "" Then _ISN_execute_macroslot_02()
		Case $TreeviewContextMenu_makroslot3
			If $TreeviewContextMenu_makroslot3 <> "" Then _ISN_execute_macroslot_03()
		Case $TreeviewContextMenu_makroslot4
			If $TreeviewContextMenu_makroslot4 <> "" Then _ISN_execute_macroslot_04()
		Case $TreeviewContextMenu_makroslot5
			If $TreeviewContextMenu_makroslot5 <> "" Then _ISN_execute_macroslot_05()
		Case $TreeviewContextMenu_makroslot6
			If $TreeviewContextMenu_makroslot6 <> "" Then _ISN_execute_macroslot_06()
		Case $TreeviewContextMenu_makroslot7
			If $TreeviewContextMenu_makroslot7 <> "" Then _ISN_execute_macroslot_07()
		Case $id24
			_ISN_execute_macroslot_01()
		Case $id25
			_ISN_execute_macroslot_02()
		Case $id26
			_ISN_execute_macroslot_03()
		Case $id27
			_ISN_execute_macroslot_04()
		Case $id28
			_ISN_execute_macroslot_05()
		Case $Toolbar_makroslot6
			_ISN_execute_macroslot_06()
		Case $Toolbar_makroslot7
			_ISN_execute_macroslot_07()
		Case $Tools_menu_item3
			_ISN_execute_macroslot_01()
		Case $Tools_menu_item4
			_ISN_execute_macroslot_02()
		Case $Tools_menu_item5
			_ISN_execute_macroslot_03()
		Case $Tools_menu_item6
			_ISN_execute_macroslot_04()
		Case $Tools_menu_item7
			_ISN_execute_macroslot_05()
		Case $Tools_menu_item9
			_ISN_execute_macroslot_06()
		Case $Tools_menu_item10
			_ISN_execute_macroslot_07()
		Case $HelpMenu_item2
			_Oeffne_ISN_hilfe()
		Case $HelpMenu_item1
			_runhelp()
		Case $id29
			_Save_All_tabs()
		Case $FileMenu_item1b
			_Save_All_tabs()
		Case $AnsichtMenu_fenster_links_umschalten
			_Toggle_hide_leftbar()
		Case $AnsichtMenu_fenster_rechts_umschalten
			_Toggle_hide_rightbar()
		Case $AnsichtMenu_fenstergroessen_zuruecksetzen
			_Fenstergroessen_zuruecksetzen()
		Case $AnsichtMenu_fenster_unten_umschalten
			_Toggle_Fenster_unten()
		Case $HelpMenu_item3
			_Showtrophies()
		Case $Tools_menu_item1
			_Toggle_msgboxcreator()
		Case $HelpMenu_item4
			_Show_Credits()
		Case $HelpMenu_item5
			_Show_Info()
		Case $HelpMenu_Forum
			_Open_Forum()
		Case $HelpMenu_item6
			_Show_Bugtracker()
			Return
		Case $HelpMenu_item7
			_ISN_AutoIt_Studio_nach_updates_Suchen()
		Case $ProjectMenu_item11a
			_Start_Compiling()
		Case $ProjectMenu_item11b
			_Show_Compile()
		Case $ProjectMenu_item1
			If MsgBox(262144 + 48 + 4, _Get_langstr(394), _Get_langstr(393), 0, $Studiofenster) = 6 Then
				_Close_Project()
				_Show_NEw_Project()
			EndIf
		Case $Toolbarmenu_closeproject
			_Close_Project()
		Case $ProjectMenu_item3
			_Close_Project()
		Case $ProjectMenu_Kompilieren_Daten_auswaehlen
			_Weitere_Dateien_zum_Kompilieren_waehlen()
		Case $EditMenu_item1
			_try_undo()
		Case $EditMenu_item2
			_try_redo()
		Case $id11
			_try_undo()
		Case $id12
			_try_redo()
		Case $EditMenu_zeile_duplizieren
			_Zeile_Duplizieren()
		Case $EditMenu_springe_zu_func
			_Springe_zu_Func()
		Case $Toolbarmenu_pluginslot1
			If $Toolbarmenu_pluginslot1 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem1_exe, $Tools_menu_pluginitem1_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot2
			If $Toolbarmenu_pluginslot2 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem2_exe, $Tools_menu_pluginitem2_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot3
			If $Toolbarmenu_pluginslot3 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem3_exe, $Tools_menu_pluginitem3_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot4
			If $Toolbarmenu_pluginslot4 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem4_exe, $Tools_menu_pluginitem4_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot5
			If $Toolbarmenu_pluginslot5 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem5_exe, $Tools_menu_pluginitem5_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot6
			If $Toolbarmenu_pluginslot6 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem6_exe, $Tools_menu_pluginitem6_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot7
			If $Toolbarmenu_pluginslot7 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem7_exe, $Tools_menu_pluginitem7_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot8
			If $Toolbarmenu_pluginslot8 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem8_exe, $Tools_menu_pluginitem8_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot9
			If $Toolbarmenu_pluginslot9 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem9_exe, $Tools_menu_pluginitem9_exe, 1)
			EndIf

		Case $Toolbarmenu_pluginslot10
			If $Toolbarmenu_pluginslot10 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem10_exe, $Tools_menu_pluginitem10_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem1
			If $Tools_menu_pluginitem1 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem1_exe, $Tools_menu_pluginitem1_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem2
			If $Tools_menu_pluginitem2 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem2_exe, $Tools_menu_pluginitem2_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem3
			If $Tools_menu_pluginitem3 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem3_exe, $Tools_menu_pluginitem3_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem4
			If $Tools_menu_pluginitem4 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem4_exe, $Tools_menu_pluginitem4_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem5
			If $Tools_menu_pluginitem5 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem5_exe, $Tools_menu_pluginitem5_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem6
			If $Tools_menu_pluginitem6 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem6_exe, $Tools_menu_pluginitem6_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem7
			If $Tools_menu_pluginitem7 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem7_exe, $Tools_menu_pluginitem7_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem8
			If $Tools_menu_pluginitem8 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem8_exe, $Tools_menu_pluginitem8_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem9
			If $Tools_menu_pluginitem9 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem9_exe, $Tools_menu_pluginitem9_exe, 1)
			EndIf

		Case $Tools_menu_pluginitem10
			If $Tools_menu_pluginitem10 <> "" Then
				If $Can_open_new_tab = 0 Then Return
				$Can_open_new_tab = 0
				Call("_open_plugintab", $Tools_menu_pluginitem10_exe, $Tools_menu_pluginitem10_exe, 1)
			EndIf

		Case $TreeviewContextMenu_Item_Projektbaum_aktualisieren
			_Update_Treeview()
		Case $id6
			_Update_Treeview()
		Case $ProjectMenu_item12
			_Update_Treeview()
		Case $id3
			_Try_to_import_file()
		Case $id5
			_Show_Delete_file_GUI()
		Case $id16
			_Toggle_Search()
		Case $EditMenu_item7
			_Show_Search()
		Case $FileMenu_item11
			_Toggle_Fulscreen()
		Case $FileMenu_item12
			_exit()
		Case $FileMenu_item13
			_Close_Project()
		Case $id15
			_STOPSCRIPT()
		Case $Tools_menu_bitrechner
			_Toggle_Bitoperation_rechner()
		Case $Tools_menu_ParameterEditor
			_Parameter_Editor_Contextmenue()
		Case $Tools_menu_PELock_Obfuscator
			_Toggle_PELock_GUI()
		Case $id14
			_ISN_Skript_Testen()
		Case $id17
			_ISN_Syntaxcheck_aktuellen_Tab()
		Case $EditMenu_item8
			_ISN_Syntaxcheck_aktuellen_Tab()
		Case $ProjectMenu_item8a
			_ISN_Projekt_Testen()
		Case $ProjectMenu_item8b
			_ISN_Projekt_Testen_ohne_Parameter()
		Case $ProjectMenu_backup_durchfuehren
			_Backup_Files()
		Case $EditMenu_item3
			_trytocut()
		Case $EditMenu_item4
			_trytocopy()
		Case $EditMenu_item5
			_trytopaste()
		Case $EditMenu_item6
			_trytodelete()
		Case $FileMenu_item7
			_Show_Delete_file_GUI()
		Case $FileMenu_item4
			_Try_to_import_file()
		Case $Tools_menu_AutoIt3Wrapper_GUI
			_Zeige_AutoIt3Wrapper_GUI()
		Case $Tools_menu_createUDFheader
			_Erstelle_UDF_Header()
		Case $FileMenu_item5
			_Try_to_import_folder()
		Case $id19
			_Try_to_import_folder()
		Case $id20
			_Toggle_Fulscreen()
		Case $ProjectMenu_item10
			_STOPSCRIPT()
		Case $ProjectMenu_item9
			_ISN_Skript_Testen()
		Case $EditMenu_item9
			GoToLine()
		Case $TreeviewContextMenu_Item1
			Try_to_opten_file(_GUICtrlTVExplorer_GetSelected($hWndTreeview))
		Case $TreeviewContextMenu_Item10
			_Erstelle_kopie_von_markierter_datei()
		Case $FileMenu_item14
			_Erstelle_kopie_von_markierter_datei()
		Case $TreeviewContextMenu_Item9
			_tryotopeninexplorer(_GUICtrlTVExplorer_GetSelected($hWndTreeview))
		Case $TreeviewContextMenu_Item2
			_Rename_File()
		Case $FileMenu_item8
			_Rename_File()
		Case $TreeviewContextMenu_Item3
			_Show_Delete_file_GUI()
		Case $TreeviewContextMenu_Item4
			_Try_to_move_file()
		Case $FileMenu_item9
			_Try_to_move_file()
		Case $FileMenu_item10
			_Show_Configgui()
		Case $Toolbarmenu_programmeinstellungen
			_Show_Configgui()
		Case $ProjectMenu_item13
			_Show_Ruleeditor()
		Case $id22
			_Show_Ruleeditor()
		Case $FileMenu_item6
			_Export_File()
		Case $id4
			_Export_File()
		Case $TreeviewContextMenu_Item7
			_Export_File()
		Case $TreeviewContextMenu_Item6
			_Try_to_import_file()
		Case $FileMenu_item1d
			_Close_All_Tabs()
		Case $TabContextMenu_Item5
			_Close_All_Tabs()
		Case $TreeviewContextMenu_Item6a
			_Try_to_import_folder()
		Case $FileMenu_item3
			_New_Folder()
		Case $EditMenu_item12
			_SCI_Toggle_fold()
		Case $EditMenu_zeile_bookmarken
			_Zeile_Bookmarken()
		Case $EditMenu_zeile_bookmarken_Alle_Entfernen
			_Alle_Bookmarks_entfernen()
		Case $EditMenu_zeile_bookmarken_naechste_Zeile
			_Springe_zum_naechsten_Bookmarks()
		Case $EditMenu_zeile_bookmarken_vorherige_Zeile
			_Springe_zur_vorherigen_Bookmarks()
		Case $EditMenu_Zeilen_nach_oben_verschieben
			_Markierte_Zeile_nach_oben_verschieben()
		Case $EditMenu_Zeilen_nach_unten_verschieben
			_Markierte_Zeile_nach_unten_verschieben()
		Case $EditMenu_Kommentare_ausblenden
			_SCI_Kommentare_ausblenden_bzw_einblenden()
		Case $Tools_menu_debugging_erweitertes_debugging_aktivieren
			_Erweitertes_Debugging_aktivieren()
		Case $Tools_menu_debugging_erweitertes_debugging_deaktivieren
			_Erweitertes_Debugging_deaktivieren()
		Case $id2
			_New_Folder()
		Case $TreeviewContextMenu_Item8_Item2
			_New_Folder()
		Case $ProjectMenu_item4
			_Zeige_Projekteinstellungen("projectproperties")
		Case $Toolbarmenu_projekteinstellungen
			_Zeige_Projekteinstellungen()
		Case $ProjectMenu_projekteinstellungen
			_Zeige_Projekteinstellungen()
		Case $TreeviewContextMenu_Oeffnen_Mit_Script_Editor
			_datei_oeffnen_mit_Skript_Editor()
		Case $TreeviewContextMenu_Oeffnen_Mit_Windows
			_datei_oeffnen_mit_Windows()
		Case $id9
			_Zeige_Projekteinstellungen("projectproperties")
		Case $FileMenu_TabSchliessen
			_ISN_Aktuellen_Tab_schliessen()
		Case $id13
			_ISN_Aktuellen_Tab_schliessen()
		Case $TabContextMenu_Item2
			_ISN_Aktuellen_Tab_schliessen()
		Case $TabContextMenu_Item3
			If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
			If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
			_tryotopeninexplorer($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)])
		Case $TabContextMenu_Item4
			_datei_eigenschaften_tab()
		Case $TreeviewContextMenu_Item5
			If $Offenes_Projekt = _ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlTreeView_GetTree($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView))) Then
				_Zeige_Projekteinstellungen("projectproperties")
			Else
				_datei_eigenschaften()
			EndIf
		Case $ProjectMenu_aenderungsprotokolle
			_Zeige_changelogmanager()
		Case $ProjectMenu_todo_liste
			_Toggle_ToDo_manager()
		Case $TreeviewContextMenu_Item_PELock_Obfuscator
			_Datei_aus_Projektbaum_in_Obfuscator_GUI_Laden()
		Case $TreeviewContextMenu_Item_Makro_kompilieren_bestehend
			_AU3_aus_Projektbaum_mit_vorhandenen_Makro_kompilieren()
		Case $TreeviewContextMenu_Item_Makro_kompilieren_neu
			_AU3_aus_Projektbaum_mit_neuem_Makro_kompilieren()
		Case $TreeviewContextMenu_Item_Jetzt_Kompilieren
			_AU3_aus_Projektbaum_Direkt_Kompilieren()
		Case $Toolbarmenu_aenderungsprotokoll
			_Zeige_changelogmanager()
;~ 		Case $Tools_menu_organizeincludes
;~ 			_Zeige_Organize_Includes()
		Case $TreeviewContextMenu_Item8_Item1
			_Show_New_Filegui()
		Case $FileMenu_item2a
			_Show_new_Filgui_au3()
		Case $FileMenu_Neue_Datei_temp_au3file
			_erstelle_neues_temporaeres_skript()
		Case $TreeviewContextMenu_temp_au3_file
			_erstelle_neues_temporaeres_skript()
		Case $Dateimenue_Drucken
			_ISN_Print_current_file()
		Case $SCI_EDITOR_CONTEXT_drucken
			_ISN_Print_current_file()
		Case $FileMenu_item2b
			_Show_new_Filgui_isf()
		Case $FileMenu_item2c
			_Show_new_Filgui_ini()
		Case $FileMenu_item2d
			_Show_new_Filgui_txt()
		Case $TreeviewContextMenu_Item8_a
			_Show_new_Filgui_au3()
		Case $TreeviewContextMenu_Item8_b
			_Show_new_Filgui_isf()
		Case $TreeviewContextMenu_Item8_c
			_Show_new_Filgui_ini()
		Case $TreeviewContextMenu_Item8_d
			_Show_new_Filgui_txt()
		Case $Tools_menu_item8
			_Toggle_colourpicker()
		Case $Toolbarmenu_Farbtoolbox
			_Toggle_colourpicker()

;~ 	case $FileMenu_item2
;~ 		_Show_New_Filegui()
;~ 	case $TbarMenu
;~ 		_Show_New_Filegui()
		Case $id18
			_ISN_Tidy_aktuellen_Tab()
		Case $EditMenu_item10
			_ISN_Tidy_aktuellen_Tab()
		Case $EditMenu_item11
			_comment_out()
		Case $id21
			_comment_out()
		Case $ProjectMenu_item8c
			_Show_Parameterconfig()
		Case $Scripttree_includemenu_menu3
			_SCI_Zeige_Code_Schnipsel()
		Case $Scripttree_includemenu_menu0
			$str = StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1))
			_Try_to_open_include($str)
		Case $Scripttree_includemenu_menu1
			_Scripttree_show_comment()
		Case $Scripttree_includemenu_menu2
			_Scripttree_DB_Klick()
		Case $SCI_EDITOR_CONTEXT_oeffneInclude
			$str = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
			_Try_to_open_include($str)
		Case $SCI_EDITOR_CONTEXT_ParameterEditor
			_Parameter_Editor_Contextmenue()
		Case $ProjectMenu_item2
			If $Can_open_new_tab = 0 Then Return
			If MsgBox(262144 + 48 + 4, _Get_langstr(394), _Get_langstr(393), 0, $Studiofenster) = 6 Then
				_Close_Project()
				_Show_Projectman()

			EndIf



	EndSwitch

EndFunc   ;==>_InputCheck

Func _Oeffne_ISN_hilfe()
	If $Languagefile = "german.lng" Then
		ShellExecute(@ScriptDir & "\Data\ISNhelp_ger.chm")
		Return
	EndIf

	If $Languagefile = "english.lng" Then
		ShellExecute(@ScriptDir & "\Data\ISNhelp_en.chm")
		Return
	EndIf


	;Für alle anderen Fallback auf english
	ShellExecute(@ScriptDir & "\Data\ISNhelp_en.chm")
EndFunc   ;==>_Oeffne_ISN_hilfe


Func _Projekt_Eigenschaften_Oeffnen_Projektverwaltung()
	If MsgBox(262144 + 48 + 4, _Get_langstr(394), _Get_langstr(393), 0, $Projekteinstellungen_GUI) = 6 Then
		_Hide_projectproperties()
		_Close_Project("false")
		_Show_Projectman()
	EndIf
EndFunc   ;==>_Projekt_Eigenschaften_Oeffnen_Projektverwaltung




Func _MIDDLEdown()
	AdlibUnRegister("_MIDDLEdown")
	If $Can_open_new_tab = 1 Then
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		$tPOINT = _WinAPI_GetMousePos(True, $Studiofenster)
		Local $iX = DllStructGetData($tPOINT, "X")
		Local $iY = DllStructGetData($tPOINT, "Y")
		Local $aPos = ControlGetPos($Studiofenster, "", $htab)
		If Not IsArray($aPos) Then Return
		Local $aHit = _GUICtrlTab_HitTest($htab, $iX - $aPos[0], $iY - $aPos[1])
		If Not IsArray($aHit) Then Return
		If $aHit[0] <> -1 Then
			If $aHit[0] <> _GUICtrlTab_GetCurFocus($htab) Then _GUICtrlTab_ActivateTabX($htab, $aHit[0], 0)
			try_to_Close_Tab($aHit[0])
		EndIf
	EndIf
EndFunc   ;==>_MIDDLEdown

Func _projectfolder_std()
	GUICtrlSetData($Input_Projekte_Pfad, $Standardordner_Projects)
EndFunc   ;==>_projectfolder_std

Func _backupfolder_std()
	GUICtrlSetData($Input_Backup_Pfad, $Standardordner_Backups)
EndFunc   ;==>_backupfolder_std

Func _releasefolder_std()
	GUICtrlSetData($Input_Release_Pfad, $Standardordner_Release)
EndFunc   ;==>_releasefolder_std

Func _templatefolder_std()
	GUICtrlSetData($Input_template_Pfad, $Standardordner_Templates)
EndFunc   ;==>_templatefolder_std

Func _pluginfolder_std()
	GUICtrlSetData($Einstellungen_Pfade_Pluginpfad_input, $Standardordner_Plugins)
EndFunc   ;==>_pluginfolder_std

Func _erkenne_au3exe()
	Local $RegKey = 'HKEY_LOCAL_MACHINE64\SOFTWARE\'
	If @OSArch <> 'X86' Then $RegKey &= 'Wow6432Node\'
	Local $InstallPath = RegRead($RegKey & 'AutoIt v3\AutoIt', 'InstallDir')
	Local $Pfad = ""
	If IsDeclared("Input_config_au3exe") Then GUICtrlSetData($Input_config_au3exe, $Pfad)
	;Search AutoIt3.exe
	If DriveStatus("c:\") = "READY" Then
		If FileExists("C:\Programme\AutoIt3\AutoIt3.exe") Then $Pfad = "C:\Programme\AutoIt3\AutoIt3.exe"
		If FileExists("C:\Program Files\AutoIt3\AutoIt3.exe") Then $Pfad = "C:\Program Files\AutoIt3\AutoIt3.exe"
		If FileExists("C:\Program Files (x86)\AutoIt3\AutoIt3.exe") Then $Pfad = "C:\Program Files (x86)\AutoIt3\AutoIt3.exe"
	EndIf

	If DriveStatus("D:\") = "READY" Then
		If FileExists("D:\Programme\AutoIt3\AutoIt3.exe") Then $Pfad = "D:\Programme\AutoIt3\AutoIt3.exe"
		If FileExists("D:\Program Files\AutoIt3\AutoIt3.exe") Then $Pfad = "D:\Program Files\AutoIt3\AutoIt3.exe"
		If FileExists("D:\Program Files (x86)\AutoIt3\AutoIt3.exe") Then $Pfad = "D:\Program Files (x86)\AutoIt3\AutoIt3.exe"
	EndIf
	If FileExists($InstallPath & "\AutoIt3.exe") Then $Pfad = $InstallPath & "\AutoIt3.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\AutoIt3.exe") Then $Pfad = @ScriptDir & "\AutoIt\AutoIt3.exe"
	$Pfad = _ISN_Pfad_durch_Variablen_ersetzen($Pfad)
	If IsDeclared("Input_config_au3exe") Then GUICtrlSetData($Input_config_au3exe, $Pfad)
	GUICtrlSetData($Ersteinrichtung_Programmpfade_Autoit3_exe_input, $Pfad)
EndFunc   ;==>_erkenne_au3exe

Func _erkenne_au32exe()
	Local $RegKey = 'HKEY_LOCAL_MACHINE64\SOFTWARE\'
	If @OSArch <> 'X86' Then $RegKey &= 'Wow6432Node\'
	Local $InstallPath = RegRead($RegKey & 'AutoIt v3\AutoIt', 'InstallDir')
	Local $Pfad = ""
	If IsDeclared("Input_config_au2exe") Then GUICtrlSetData($Input_config_au2exe, $Pfad)
	If DriveStatus("c:\") = "READY" Then
		If FileExists("C:\Programme\AutoIt3\Aut2Exe\Aut2exe.exe") Then $Pfad = "C:\Programme\AutoIt3\Aut2Exe\Aut2exe.exe"
		If FileExists("C:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe") Then $Pfad = "C:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe"
		If FileExists("C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe") Then $Pfad = "C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe"
	EndIf
	If DriveStatus("D:\") = "READY" Then
		If FileExists("D:\Programme\AutoIt3\Aut2Exe\Aut2exe.exe") Then $Pfad = "D:\Programme\AutoIt3\Aut2Exe\Aut2exe.exe"
		If FileExists("D:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe") Then $Pfad = "D:\Program Files\AutoIt3\Aut2Exe\Aut2exe.exe"
		If FileExists("D:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe") Then $Pfad = "D:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe"
	EndIf
	If FileExists($InstallPath & "\Aut2Exe\Aut2exe.exe") Then $Pfad = $InstallPath & "\Aut2Exe\Aut2exe.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\Aut2Exe\Aut2exe.exe") Then $Pfad = @ScriptDir & "\AutoIt\Aut2Exe\Aut2exe.exe"
	$Pfad = _ISN_Pfad_durch_Variablen_ersetzen($Pfad)
	If IsDeclared("Input_config_au2exe") Then GUICtrlSetData($Input_config_au2exe, $Pfad)
	GUICtrlSetData($Ersteinrichtung_Programmpfade_Aut2exe_exe_input, $Pfad)
EndFunc   ;==>_erkenne_au32exe

Func _erkenne_helpfile()
	Local $RegKey = 'HKEY_LOCAL_MACHINE64\SOFTWARE\'
	If @OSArch <> 'X86' Then $RegKey &= 'Wow6432Node\'
	Local $InstallPath = RegRead($RegKey & 'AutoIt v3\AutoIt', 'InstallDir')
	Local $Pfad = ""
	If IsDeclared("Input_config_helpfile") Then GUICtrlSetData($Input_config_helpfile, $Pfad)
	If DriveStatus("c:\") = "READY" Then
		If FileExists("C:\Programme\AutoIt3\AutoIt3Help.exe") Then $Pfad = "C:\Programme\AutoIt3\AutoIt3Help.exe"
		If FileExists("C:\Program Files\AutoIt3\AutoIt3Help.exe") Then $Pfad = "C:\Program Files\AutoIt3\AutoIt3Help.exe"
		If FileExists("C:\Program Files (x86)\AutoIt3\AutoIt3Help.exe") Then $Pfad = "C:\Program Files (x86)\AutoIt3\AutoIt3Help.exe"
	EndIf
	If DriveStatus("D:\") = "READY" Then
		If FileExists("D:\Programme\AutoIt3\AutoIt3Help.exe") Then $Pfad = "D:\Programme\AutoIt3\AutoIt3Help.exe"
		If FileExists("D:\Program Files\AutoIt3\AutoIt3Help.exe") Then $Pfad = "D:\Program Files\AutoIt3\AutoIt3Help.exe"
		If FileExists("D:\Program Files (x86)\AutoIt3\AutoIt3Help.exe") Then $Pfad = "D:\Program Files (x86)\AutoIt3\AutoIt3Help.exe"
	EndIf
	If FileExists($InstallPath & "\AutoIt3Help.exe") Then $Pfad = $InstallPath & "\AutoIt3Help.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\AutoIt3Help.exe") Then $Pfad = @ScriptDir & "\AutoIt\AutoIt3Help.exe"
	$Pfad = _ISN_Pfad_durch_Variablen_ersetzen($Pfad)
	If IsDeclared("Input_config_helpfile") Then GUICtrlSetData($Input_config_helpfile, $Pfad)
	GUICtrlSetData($Ersteinrichtung_Programmpfade_AutoIt3Help_exe_input, $Pfad)
EndFunc   ;==>_erkenne_helpfile

Func _erkenne_Au3Infoexe()
	Local $RegKey = 'HKEY_LOCAL_MACHINE64\SOFTWARE\'
	If @OSArch <> 'X86' Then $RegKey &= 'Wow6432Node\'
	Local $InstallPath = RegRead($RegKey & 'AutoIt v3\AutoIt', 'InstallDir')
	Local $Pfad = ""
	If IsDeclared("Input_config_Au3Infoexe") Then GUICtrlSetData($Input_config_Au3Infoexe, $Pfad)
	If DriveStatus("c:\") = "READY" Then
		If FileExists("C:\Programme\AutoIt3\Au3Info.exe") Then $Pfad = "C:\Programme\AutoIt3\Au3Info.exe"
		If FileExists("C:\Program Files\AutoIt3\Au3Info.exe") Then $Pfad = "C:\Program Files\AutoIt3\Au3Info.exe"
		If FileExists("C:\Program Files (x86)\AutoIt3\Au3Info.exe") Then $Pfad = "C:\Program Files (x86)\AutoIt3\Au3Info.exe"
	EndIf
	If DriveStatus("D:\") = "READY" Then
		If FileExists("D:\Programme\AutoIt3\Au3Info.exe") Then $Pfad = "D:\Programme\AutoIt3\Au3Info.exe"
		If FileExists("D:\Program Files\AutoIt3\Au3Info.exe") Then $Pfad = "D:\Program Files\AutoIt3\Au3Info.exe"
		If FileExists("D:\Program Files (x86)\AutoIt3\Au3Info.exe") Then $Pfad = "D:\Program Files (x86)\AutoIt3\Au3Info.exe"
	EndIf
	If FileExists($InstallPath & "\Au3Info.exe") Then $Pfad = $InstallPath & "\Au3Info.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\Au3Info.exe") Then $Pfad = @ScriptDir & "\AutoIt\Au3Info.exe"
	$Pfad = _ISN_Pfad_durch_Variablen_ersetzen($Pfad)
	If IsDeclared("Input_config_Au3Infoexe") Then GUICtrlSetData($Input_config_Au3Infoexe, $Pfad)
	GUICtrlSetData($Ersteinrichtung_Programmpfade_Au3Info_exe_input, $Pfad)
EndFunc   ;==>_erkenne_Au3Infoexe

Func _erkenne_Au3Checkexe()
	Local $RegKey = 'HKEY_LOCAL_MACHINE64\SOFTWARE\'
	If @OSArch <> 'X86' Then $RegKey &= 'Wow6432Node\'
	Local $InstallPath = RegRead($RegKey & 'AutoIt v3\AutoIt', 'InstallDir')
	Local $Pfad = ""
	If IsDeclared("Input_config_Au3Checkexe") Then GUICtrlSetData($Input_config_Au3Checkexe, $Pfad)
	If DriveStatus("c:\") = "READY" Then
		If FileExists("C:\Programme\AutoIt3\Au3Check.exe") Then $Pfad = "C:\Programme\AutoIt3\Au3Check.exe"
		If FileExists("C:\Program Files\AutoIt3\Au3Check.exe") Then $Pfad = "C:\Program Files\AutoIt3\Au3Check.exe"
		If FileExists("C:\Program Files (x86)\AutoIt3\Au3Check.exe") Then $Pfad = "C:\Program Files (x86)\AutoIt3\Au3Check.exe"
	EndIf
	If DriveStatus("D:\") = "READY" Then
		If FileExists("D:\Programme\AutoIt3\Au3Check.exe") Then $Pfad = "D:\Programme\AutoIt3\Au3Check.exe"
		If FileExists("D:\Program Files\AutoIt3\Au3Check.exe") Then $Pfad = "D:\Program Files\AutoIt3\Au3Check.exe"
		If FileExists("D:\Program Files (x86)\AutoIt3\Au3Check.exe") Then $Pfad = "D:\Program Files (x86)\AutoIt3\Au3Check.exe"
	EndIf
	If FileExists($InstallPath & "\Au3Check.exe") Then $Pfad = $InstallPath & "\Au3Check.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\Au3Check.exe") Then $Pfad = @ScriptDir & "\AutoIt\Au3Check.exe"
	$Pfad = _ISN_Pfad_durch_Variablen_ersetzen($Pfad)
	If IsDeclared("Input_config_Au3Checkexe") Then GUICtrlSetData($Input_config_Au3Checkexe, $Pfad)
	GUICtrlSetData($Ersteinrichtung_Programmpfade_Au3Check_exe_input, $Pfad)
EndFunc   ;==>_erkenne_Au3Checkexe

Func _erkenne_Au3Stripperexe()
	Local $RegKey = 'HKEY_LOCAL_MACHINE64\SOFTWARE\'
	If @OSArch <> 'X86' Then $RegKey &= 'Wow6432Node\'
	Local $InstallPath = RegRead($RegKey & 'AutoIt v3\AutoIt', 'InstallDir')
	Local $Pfad = ""
	If IsDeclared("Input_config_Au3Stripperexe") Then GUICtrlSetData($Input_config_Au3Stripperexe, $Pfad)
	If DriveStatus("c:\") = "READY" Then
		If FileExists("C:\Programme\AutoIt3\Au3Stripper\AU3Stripper.exe") Then $Pfad = "C:\Programme\AutoIt3\Au3Stripper\AU3Stripper.exe"
		If FileExists("C:\Program Files\AutoIt3\Au3Stripper\AU3Stripper.exe") Then $Pfad = "C:\Program Files\AutoIt3\Au3Stripper\AU3Stripper.exe"
		If FileExists("C:\Program Files (x86)\AutoIt3\Au3Stripper\AU3Stripper.exe") Then $Pfad = "C:\Program Files (x86)\AutoIt3\Au3Stripper\AU3Stripper.exe"
	EndIf
	If DriveStatus("D:\") = "READY" Then
		If FileExists("D:\Programme\AutoIt3\Au3Stripper\AU3Stripper.exe") Then $Pfad = "D:\Programme\AutoIt3\Au3Stripper\AU3Stripper.exe"
		If FileExists("D:\Program Files\AutoIt3\Au3Stripper\AU3Stripper.exe") Then $Pfad = "D:\Program Files\AutoIt3\Au3Stripper\AU3Stripper.exe"
		If FileExists("D:\Program Files (x86)\AutoIt3\Au3Stripper\AU3Stripper.exe") Then $Pfad = "D:\Program Files (x86)\AutoIt3\Au3Stripper\AU3Stripper.exe"
	EndIf
	If FileExists($InstallPath & "\Au3Stripper\AU3Stripper.exe") Then $Pfad = $InstallPath & "\Au3Stripper\AU3Stripper.exe"
	If FileExists($InstallPath & "\SciTE\au3Stripper\AU3Stripper.exe") Then $Pfad = $InstallPath & "\SciTE\au3Stripper\AU3Stripper.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\Au3Stripper\AU3Stripper.exe") Then $Pfad = @ScriptDir & "\AutoIt\Au3Stripper\AU3Stripper.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\SciTE\au3Stripper\AU3Stripper.exe") Then $Pfad = @ScriptDir & "\AutoIt\SciTE\au3Stripper\AU3Stripper.exe"
	$Pfad = _ISN_Pfad_durch_Variablen_ersetzen($Pfad)
	If IsDeclared("Input_config_Au3Stripperexe") Then GUICtrlSetData($Input_config_Au3Stripperexe, $Pfad)
	GUICtrlSetData($Ersteinrichtung_Programmpfade_au3stripperexe_input, $Pfad)
EndFunc   ;==>_erkenne_Au3Stripperexe

Func _erkenne_Tidyexe()
	Local $RegKey = 'HKEY_LOCAL_MACHINE64\SOFTWARE\'
	If @OSArch <> 'X86' Then $RegKey &= 'Wow6432Node\'
	Local $InstallPath = RegRead($RegKey & 'AutoIt v3\AutoIt', 'InstallDir')
	Local $Pfad = ""
	If IsDeclared("Input_config_Tidyexe") Then GUICtrlSetData($Input_config_Tidyexe, $Pfad)
	If DriveStatus("c:\") = "READY" Then
		If FileExists("C:\Programme\AutoIt3\Tidy\Tidy.exe") Then $Pfad = "C:\Programme\AutoIt3\Tidy\Tidy.exe"
		If FileExists("C:\Program Files\AutoIt3\Tidy\Tidy.exe") Then $Pfad = "C:\Program Files\AutoIt3\Tidy\Tidy.exe"
		If FileExists("C:\Program Files (x86)\AutoIt3\Tidy\Tidy.exe") Then $Pfad = "C:\Program Files (x86)\AutoIt3\Tidy\Tidy.exe"
	EndIf
	If DriveStatus("D:\") = "READY" Then
		If FileExists("D:\Programme\AutoIt3\Tidy\Tidy.exe") Then $Pfad = "D:\Programme\AutoIt3\Tidy\Tidy.exe"
		If FileExists("D:\Program Files\AutoIt3\Tidy\Tidy.exe") Then $Pfad = "D:\Program Files\AutoIt3\Tidy\Tidy.exe"
		If FileExists("D:\Program Files (x86)\AutoIt3\Tidy\Tidy.exe") Then $Pfad = "D:\Program Files (x86)\AutoIt3\Tidy\Tidy.exe"
	EndIf
	If FileExists($InstallPath & "\Tidy\Tidy.exe") Then $Pfad = $InstallPath & "\Tidy\Tidy.exe"
	If FileExists($InstallPath & "\SciTE\Tidy\Tidy.exe") Then $Pfad = $InstallPath & "\SciTE\Tidy\Tidy.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\Tidy\Tidy.exe") Then $Pfad = @ScriptDir & "\AutoIt\Tidy\Tidy.exe"
	If FileExists(@ScriptDir & "\portable.dat") And FileExists(@ScriptDir & "\autoit\SciTE\Tidy\Tidy.exe") Then $Pfad = @ScriptDir & "\AutoIt\SciTE\Tidy\Tidy.exe"
	$Pfad = _ISN_Pfad_durch_Variablen_ersetzen($Pfad)
	If IsDeclared("Input_config_Tidyexe") Then GUICtrlSetData($Input_config_Tidyexe, $Pfad)
	GUICtrlSetData($Ersteinrichtung_Programmpfade_Tidyexe_input, $Pfad)
EndFunc   ;==>_erkenne_Tidyexe

Func _Automatische_Suche_der_AutoIt_Ordner()
	;Automatische Suche der Pfade FALLS die in der config.ini nicht existieren sollten
	If Not FileExists($autoitexe) Then
		_erkenne_au3exe()
		If GUICtrlRead($Input_config_au3exe) <> "" Then
			_Write_in_Config("autoitexe", GUICtrlRead($Input_config_au3exe))
			$autoitexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_au3exe))
		EndIf
	EndIf

	If Not FileExists($autoit2exe) Then
		_erkenne_au32exe()
		If GUICtrlRead($Input_config_au2exe) <> "" Then
			_Write_in_Config("autoit2exe", GUICtrlRead($Input_config_au2exe))
			$autoit2exe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_au2exe))
		EndIf
	EndIf

	If Not FileExists($helpfile) Then
		_erkenne_helpfile()
		If GUICtrlRead($Input_config_helpfile) <> "" Then
			_Write_in_Config("helpfileexe", GUICtrlRead($Input_config_helpfile))
			$helpfile = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_helpfile))
		EndIf
	EndIf

	If Not FileExists($Au3Infoexe) Then
		_erkenne_Au3Infoexe()
		If GUICtrlRead($Input_config_Au3Infoexe) <> "" Then
			_Write_in_Config("au3infoexe", GUICtrlRead($Input_config_Au3Infoexe))
			$Au3Infoexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Au3Infoexe))
		EndIf
	EndIf

	If Not FileExists($Au3Checkexe) Then
		_erkenne_Au3Checkexe()
		If GUICtrlRead($Input_config_Au3Checkexe) <> "" Then
			_Write_in_Config("au3checkexe", GUICtrlRead($Input_config_Au3Checkexe))
			$Au3Checkexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Au3Checkexe))
		EndIf
	EndIf

	;Priorität lokale Datei
	If Not FileExists($Au3Stripperexe) Then
		_erkenne_Au3Stripperexe()
		If GUICtrlRead($Input_config_Au3Stripperexe) <> "" Then
			_Write_in_Config("au3stripperexe", GUICtrlRead($Input_config_Au3Stripperexe))
			$Au3Stripperexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Au3Stripperexe))
		EndIf
	EndIf

	;Priorität lokale Datei
	If Not FileExists($Tidyexe) Then
		_erkenne_Tidyexe()
		If GUICtrlRead($Input_config_Tidyexe) <> "" Then
			_Write_in_Config("tidyexe", GUICtrlRead($Input_config_Tidyexe))
			$Tidyexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Tidyexe))
			$Pfad_zur_TidyINI = StringTrimRight($Tidyexe, StringLen($Tidyexe) - StringInStr($Tidyexe, "\", 0, -1)) & "Tidy.ini"
		EndIf
	EndIf

EndFunc   ;==>_Automatische_Suche_der_AutoIt_Ordner



Func _Programmeinstellungen_AutoIt_Ordner_jetzt_erkennen()
	;Erzwinge erkennung für die Programmeinstellungen
	_erkenne_au3exe()
	If GUICtrlRead($Input_config_au3exe) <> "" Then
		_Write_in_Config("autoitexe", GUICtrlRead($Input_config_au3exe))
		$autoitexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_au3exe))
	EndIf


	_erkenne_au32exe()
	If GUICtrlRead($Input_config_au2exe) <> "" Then
		_Write_in_Config("autoit2exe", GUICtrlRead($Input_config_au2exe))
		$autoit2exe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_au2exe))
	EndIf


	_erkenne_helpfile()
	If GUICtrlRead($Input_config_helpfile) <> "" Then
		_Write_in_Config("helpfileexe", GUICtrlRead($Input_config_helpfile))
		$helpfile = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_helpfile))
	EndIf


	_erkenne_Au3Infoexe()
	If GUICtrlRead($Input_config_Au3Infoexe) <> "" Then
		_Write_in_Config("au3infoexe", GUICtrlRead($Input_config_Au3Infoexe))
		$Au3Infoexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Au3Infoexe))
	EndIf


	_erkenne_Au3Checkexe()
	If GUICtrlRead($Input_config_Au3Checkexe) <> "" Then
		_Write_in_Config("au3checkexe", GUICtrlRead($Input_config_Au3Checkexe))
		$Au3Checkexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Au3Checkexe))
	EndIf


	_erkenne_Au3Stripperexe()
	If GUICtrlRead($Input_config_Au3Stripperexe) <> "" Then
		_Write_in_Config("au3stripperexe", GUICtrlRead($Input_config_Au3Stripperexe))
		$Au3Stripperexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Au3Stripperexe))
	EndIf


	_erkenne_Tidyexe()
	If GUICtrlRead($Input_config_Tidyexe) <> "" Then
		_Write_in_Config("tidyexe", GUICtrlRead($Input_config_Tidyexe))
		$Tidyexe = _ISN_Variablen_aufloesen(GUICtrlRead($Input_config_Tidyexe))
		$Pfad_zur_TidyINI = StringTrimRight($Tidyexe, StringLen($Tidyexe) - StringInStr($Tidyexe, "\", 0, -1)) & "Tidy.ini"
	EndIf

EndFunc   ;==>_Programmeinstellungen_AutoIt_Ordner_jetzt_erkennen



Func _check_fonts()
	If FileExists(@WindowsDir & "\fonts\segoeui.ttf") = 0 Then
		$i = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(304), 0, $Sprache_Ersteinrichtung_GUI)
		If $i = 6 Then _install_fonts()
	EndIf

EndFunc   ;==>_check_fonts

Func _install_fonts()
	installfont(@ScriptDir & "\Data\Fonts\segoeui.ttf")
	installfont(@ScriptDir & "\Data\Fonts\segoeuib.ttf")
	installfont(@ScriptDir & "\Data\Fonts\segoeuii.ttf")
	installfont(@ScriptDir & "\Data\Fonts\segoeuil.ttf")
	installfont(@ScriptDir & "\Data\Fonts\segoeuiz.ttf")
	installfont(@ScriptDir & "\Data\Fonts\seguisb.ttf")
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(305), 0, $Sprache_Ersteinrichtung_GUI)
EndFunc   ;==>_install_fonts

Func installfont($file)
	If FileCopy($file, @WindowsDir & '\Fonts', 1) Then
		DllCall('gdi32', 'long', "AddFontResourceA", 'String', @WindowsDir & '\Fonts\' & $file)
	EndIf
EndFunc   ;==>installfont

Func _Choose_Compileicon()
	_Lock_Plugintabs("lock")
	$var = FileOpenDialog(_Get_langstr(187), $Offenes_Projekt, "Icon (*.ico)", 1 + 2 + 4, "", $Projekteinstellungen_GUI)
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return
	_SetImage($Compile_vorschauicon, $var)
	$var = _ISN_Pfad_durch_Variablen_ersetzen($var)
	GUICtrlSetData($Compile_Iconpath, $var)
EndFunc   ;==>_Choose_Compileicon

Func _MOVE_TO_CENTER()
	$w = WinGetPos($Studiofenster, "")
	If $w[1] < -10 Then
		WinMove($Studiofenster, "", Default, 0)
	EndIf
	_WINDOW_REBUILD()
EndFunc   ;==>_MOVE_TO_CENTER

Func _Hauptfenster_Refresh()
	DllCall("user32.dll", "int", "RedrawWindow", "hwnd", $Studiofenster, "int", 0, "int", 0, "int", 0x1)
	_WINDOW_REBUILD()
EndFunc   ;==>_Hauptfenster_Refresh


Func _New_Projekt_Stammordner_checkboxevent()
	If GUICtrlRead($new_projectstammordner_checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($new_project_ordnerinhaltkopieren_checkbox, $GUI_DISABLE)
		GUICtrlSetState($new_project_ordnerinhaltkopieren_checkbox, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($new_project_ordnerinhaltkopieren_checkbox, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_New_Projekt_Stammordner_checkboxevent


Func _New_Project_inteliwrite()

	If _IsPressed("01", $user32) Then Return
	$sFocus = ControlGetFocus($NEW_PROJECT_GUI)
	$hFocus = ControlGetHandle($NEW_PROJECT_GUI, "", $sFocus)
	$ctrlFocus = _WinAPI_GetDlgCtrlID($hFocus)

	If $ctrlFocus = $neues_projekt_projektdatei_name Then
		$Selection_vor_Aenderung = _GUICtrlEdit_GetSel($neues_projekt_projektdatei_name)
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), '*') Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), '*', ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), '"') Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), '"', ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), "'") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), "'", ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), ":") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), ":", ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), "ß") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), "ß", "ss"))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), "!") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), "!", ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), "?") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), "?", ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), "|") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), "|", ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), "/") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), "/", ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), "\") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), "\", ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), ".") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), ".", ""))
		If StringInStr(GUICtrlRead($neues_projekt_projektdatei_name), ".isn") Then GUICtrlSetData($neues_projekt_projektdatei_name, StringReplace(GUICtrlRead($neues_projekt_projektdatei_name), ".isn", ""))
		If IsArray($Selection_vor_Aenderung) Then _GUICtrlEdit_SetSel($neues_projekt_projektdatei_name, $Selection_vor_Aenderung[0], $Selection_vor_Aenderung[1])
	EndIf

	If $ctrlFocus = $new_projectname Or $ctrlFocus = $new_projectvorlage_radio0 Or $ctrlFocus = $new_projectvorlage_radio1 Or $ctrlFocus = $new_projectvorlage_radio2 Or $ctrlFocus = $new_projectstammordner_checkbox Or $ctrlFocus = $new_project_aenderungsprotokolle_checkbox Then

		$Selection_vor_Aenderung = _GUICtrlEdit_GetSel($new_projectname)
		$str = GUICtrlRead($new_projectname)
		$str = StringReplace($str, ".", "_")
		$str = StringReplace($str, "?", "")
		$str = StringReplace($str, "!", "")
		$str = StringReplace($str, "°", "")
		$str = StringReplace($str, ",", "")
		$str = StringReplace($str, '"', "")
		$str = StringReplace($str, "'", "")
		$str = StringReplace($str, "*", "")
		$str = StringReplace($str, "^", "")
		$str = StringReplace($str, ":", "")
		$str = StringReplace($str, "/", "")
		$str = StringReplace($str, "\", "")
		$str = StringReplace($str, "|", "")
		$str = StringReplace($str, "ß", "ss")
		GUICtrlSetData($new_projectname, $str)
		If IsArray($Selection_vor_Aenderung) Then _GUICtrlEdit_SetSel($new_projectname, $Selection_vor_Aenderung[0], $Selection_vor_Aenderung[1])


		If GUICtrlRead($new_projectstammordner_checkbox) = $GUI_UNCHECKED Then
			$str = StringReplace(GUICtrlRead($new_projectname), " ", "_")
			$str = StringReplace($str, ".", "_")
			$str = StringReplace($str, "?", "")
			$str = StringReplace($str, "!", "")
			$str = StringReplace($str, "°", "")
			$str = StringReplace($str, ",", "")
			$str = StringReplace($str, '"', "")
			$str = StringReplace($str, "'", "")
			$str = StringReplace($str, "*", "")
			$str = StringReplace($str, "^", "")
			$str = StringReplace($str, ":", "")
			$str = StringReplace($str, "/", "")
			$str = StringReplace($str, "\", "")
			$str = StringReplace($str, "|", "")
			GUICtrlSetData($new_projectmainfile, $str & "." & $Autoitextension)
			GUICtrlSetData($neues_projekt_projektdatei_name, $str)
			If GUICtrlRead($new_projectname) <> "" Then GUICtrlSetData($new_projectmainfile_create_in_folder, _ISN_Variablen_aufloesen($Projectfolder & "\" & GUICtrlRead($new_projectname)))
		Else
			GUICtrlSetData($new_projectmainfile_create_in_folder, "")
			If GUICtrlRead($new_projectusefollowingmainfile_input) <> "" Then GUICtrlSetData($new_projectmainfile_create_in_folder, StringTrimRight(GUICtrlRead($new_projectusefollowingmainfile_input), StringLen(GUICtrlRead($new_projectusefollowingmainfile_input)) - StringInStr(GUICtrlRead($new_projectusefollowingmainfile_input), "\", 0, -1) + 1))
		EndIf
	EndIf
EndFunc   ;==>_New_Project_inteliwrite

Func _Show_NEw_Project()
	GUICtrlSetData($new_projectname, "")
	GUICtrlSetData($new_projectusefollowingmainfile_input, "")
	If _Config_Read("new_project_author", "") = "" Then
		GUICtrlSetData($new_projectauthor, @UserName)
	Else
		GUICtrlSetData($new_projectauthor, _Config_Read("new_project_author", @UserName))
	EndIf
	GUICtrlSetData($new_projectcomment, "")
	GUICtrlSetData($new_projectversion, "1.0")
	GUICtrlSetData($new_projectmainfile, "." & $Autoitextension)
	GUICtrlSetData($new_projectmainfile_create_in_folder, "")
	GUICtrlSetData($neues_projekt_projektdatei_name, "")
	GUICtrlSetState($new_projectvorlage_radio1, $GUI_CHECKED)
	GUICtrlSetState($new_projectstammordner_checkbox, $GUI_UNCHECKED)
	GUICtrlSetState($new_project_aenderungsprotokolle_checkbox, $GUI_UNCHECKED)

	$state = WinGetState($projectmanager, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_SHOW, $NEW_PROJECT_GUI)
		GUISetState(@SW_DISABLE, $projectmanager)
	Else
		GUISetState(@SW_SHOW, $NEW_PROJECT_GUI)
		GUISetState(@SW_HIDE, $Welcome_GUI)
	EndIf

	ScanforTemplates_Combo()
	_Toggle_New_Projectmode()
	AdlibRegister("_New_Project_inteliwrite", 250)
EndFunc   ;==>_Show_NEw_Project

Func _Search_for_mainfile()
	$var = FileOpenDialog(_Get_langstr(187), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "AutoIt 3 Skript (*.au3)", 1 + 2 + 4, "", $NEW_PROJECT_GUI)
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return
	GUICtrlSetData($new_projectusefollowingmainfile_input, $var)
EndFunc   ;==>_Search_for_mainfile

Func _Toggle_New_Projectmode()
	If GUICtrlRead($new_project_aenderungsprotokolle_checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($new_project_aenderungsprotokolle_author_checkbox, $GUI_ENABLE)
	Else
		GUICtrlSetState($new_project_aenderungsprotokolle_author_checkbox, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($new_projectvorlage_radio0) = $GUI_CHECKED Then
		GUICtrlSetState($new_projectvorlage_label, $GUI_DISABLE)
		GUICtrlSetState($new_projectmainfile_label, $GUI_ENABLE)
		GUICtrlSetState($new_projectvorlage_combo, $GUI_DISABLE)
		GUICtrlSetState($new_projectmainfile, $GUI_ENABLE)

		GUICtrlSetState($new_projectusefollowingmainfile_label, $GUI_DISABLE)
		GUICtrlSetState($new_projectusefollowingmainfile_input, $GUI_DISABLE)
		GUICtrlSetState($new_projectusefollowingmainfile_search, $GUI_DISABLE)
		GUICtrlSetState($new_projectstammordner_checkbox, $GUI_DISABLE)
		GUICtrlSetState($new_projectstammordner_checkbox, $GUI_UNCHECKED)
		GUICtrlSetState($new_project_ordnerinhaltkopieren_checkbox, $GUI_DISABLE)
		GUICtrlSetState($new_project_ordnerinhaltkopieren_checkbox, $GUI_UNCHECKED)
	EndIf

	If GUICtrlRead($new_projectvorlage_radio1) = $GUI_CHECKED Then
		GUICtrlSetState($new_projectvorlage_label, $GUI_ENABLE)
		GUICtrlSetState($new_projectmainfile_label, $GUI_ENABLE)
		GUICtrlSetState($new_projectvorlage_combo, $GUI_ENABLE)
		GUICtrlSetState($new_projectmainfile, $GUI_ENABLE)

		GUICtrlSetState($new_projectusefollowingmainfile_label, $GUI_DISABLE)
		GUICtrlSetState($new_projectusefollowingmainfile_input, $GUI_DISABLE)
		GUICtrlSetState($new_projectusefollowingmainfile_search, $GUI_DISABLE)
		GUICtrlSetState($new_projectstammordner_checkbox, $GUI_DISABLE)
		GUICtrlSetState($new_projectstammordner_checkbox, $GUI_UNCHECKED)
		GUICtrlSetState($new_project_ordnerinhaltkopieren_checkbox, $GUI_DISABLE)
		GUICtrlSetState($new_project_ordnerinhaltkopieren_checkbox, $GUI_UNCHECKED)
	EndIf

	If GUICtrlRead($new_projectvorlage_radio2) = $GUI_CHECKED Then
		GUICtrlSetState($new_projectvorlage_label, $GUI_DISABLE)
		GUICtrlSetState($new_projectmainfile_label, $GUI_DISABLE)
		GUICtrlSetState($new_projectvorlage_combo, $GUI_DISABLE)
		GUICtrlSetState($new_projectmainfile, $GUI_DISABLE)

		GUICtrlSetState($new_projectusefollowingmainfile_label, $GUI_ENABLE)
		GUICtrlSetState($new_projectusefollowingmainfile_input, $GUI_ENABLE)
		GUICtrlSetState($new_projectusefollowingmainfile_search, $GUI_ENABLE)
		GUICtrlSetState($new_projectstammordner_checkbox, $GUI_ENABLE)
		GUICtrlSetState($new_project_ordnerinhaltkopieren_checkbox, $GUI_ENABLE)
	EndIf
	_New_Project_inteliwrite()
EndFunc   ;==>_Toggle_New_Projectmode

Func _hide_NEW_Project()
	AdlibUnRegister("_New_Project_inteliwrite")
	$state = WinGetState($projectmanager, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_ENABLE, $projectmanager)
		GUISetState(@SW_HIDE, $NEW_PROJECT_GUI)
	Else
		GUISetState(@SW_SHOW, $Welcome_GUI)
		GUISetState(@SW_HIDE, $NEW_PROJECT_GUI)
	EndIf
EndFunc   ;==>_hide_NEW_Project

Func ScanforTemplates_Combo()
	GUICtrlSetData($new_projectvorlage_combo, "", "")
	GUICtrlSetData($neue_datei_vorlagen_combo, "", "")
	Local $Search
	Local $file
	Local $FileAttributes
	Local $FullFilePath
	$Count = 0
	$Search = FileFindFirstFile(_ISN_Variablen_aufloesen($templatefolder & "\*.*"))
	$Combostring = ""
	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf
		$file = FileFindNextFile($Search)
		If @error Then ExitLoop
		$FullFilePath = _ISN_Variablen_aufloesen($templatefolder & "\" & $file)
		$FileAttributes = FileGetAttrib($FullFilePath)
		If StringInStr($FileAttributes, "D") Then
			If FileExists(_Finde_Projektdatei($FullFilePath)) Then
				$Count = $Count + 1
				$folder = $FullFilePath
				$new_projectvorlage_combo_ARRAY[$Count] = $folder
				$Combostring = $Combostring & IniRead(_Finde_Projektdatei($FullFilePath), "ISNAUTOITSTUDIO", "name", "#ERROR#") & "|"
			EndIf
		EndIf
	WEnd
	GUICtrlSetData($new_projectvorlage_combo, $Combostring, "Default Template")
	GUICtrlSetData($neue_datei_vorlagen_combo, $Combostring, "Default Template")
EndFunc   ;==>ScanforTemplates_Combo

Func _tryotopeninexplorer($file)
	If $file = $Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", "#ERROR#") Then
		Run("explorer.exe /e,/select, " & FileGetShortName($Offenes_Projekt))
	Else
		Run("explorer.exe /e,/select, " & FileGetShortName($file))
	EndIf
EndFunc   ;==>_tryotopeninexplorer

Func _Make_Temp_project()
	$Tempmode = 1
	$randommode = Int(Random(0, 400, 1))
	DirCreate(_ISN_Variablen_aufloesen($Projectfolder & "\temp" & $randommode))
	_Leere_UTF16_Datei_erstellen(_ISN_Variablen_aufloesen($Projectfolder & "\temp" & $randommode & "\project.isn"))
	IniWrite(_ISN_Variablen_aufloesen($Projectfolder & "\temp" & $randommode & "\project.isn"), "ISNAUTOITSTUDIO", "name", "temp")
	IniWrite(_ISN_Variablen_aufloesen($Projectfolder & "\temp" & $randommode & "\project.isn"), "ISNAUTOITSTUDIO", "author", "")
	IniWrite(_ISN_Variablen_aufloesen($Projectfolder & "\temp" & $randommode & "\project.isn"), "ISNAUTOITSTUDIO", "mainfile", "temp.au3")
	_FileCreate(_ISN_Variablen_aufloesen($Projectfolder & "\temp" & $randommode & "\temp.au3"))
	_Load_Project_by_Foldername(_ISN_Variablen_aufloesen($Projectfolder & "\temp" & $randommode))
	Sleep(200)
	_Show_Warning("confirmtempproject", 513, _Get_langstr(394), _Get_langstr(399), _Get_langstr(7))
EndFunc   ;==>_Make_Temp_project

Func _Run_Beforstart()
	WinSetTitle($waiter_GUI, "", _Get_langstr(403))
	GUICtrlSetData($waiter_GUI_str1, _Get_langstr(403))
	GUICtrlSetData($waiter_GUI_str2, _Get_langstr(404))
	GUISetState(@SW_SHOW, $waiter_GUI)
	RunWait($runbefore)
	GUISetState(@SW_HIDE, $waiter_GUI)
EndFunc   ;==>_Run_Beforstart

Func _Run_Beforexit()
	WinSetTitle($waiter_GUI, "", _Get_langstr(405))
	GUICtrlSetData($waiter_GUI_str1, _Get_langstr(405))
	GUICtrlSetData($waiter_GUI_str2, _Get_langstr(406))
	GUISetState(@SW_SHOW, $waiter_GUI)
	RunWait($runafter)
	GUISetState(@SW_HIDE, $waiter_GUI)
EndFunc   ;==>_Run_Beforexit

Func _select_settingscategory()
	AdlibUnRegister("_select_settingscategory")
	$mark = _GUICtrlTreeView_GetText($config_selectorlist, _GUICtrlTreeView_GetSelection($config_selectorlist))
;~ 	ConsoleWrite($mark&@crlf)
;~ 	ConsoleWrite(_GUICtrlTab_GetCurSel($config_tab)&@crlf)
	If $mark = "" Then Return
	If $mark = _Get_langstr(125) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 0 Then GUICtrlSetState($config_Sheet1, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(883) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 1 Then GUICtrlSetState($config_Sheet2, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(196) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 2 Then GUICtrlSetState($config_Sheet3, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(469) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 3 Then GUICtrlSetState($config_Sheet_Skriptbaum, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(447) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 4 Then GUICtrlSetState($config_Sheet_Darstellung, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(884) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 5 Then GUICtrlSetState($config_Sheet_Farben, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(676) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 6 Then GUICtrlSetState($config_Sheet_hotkeys, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(130) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 7 Then GUICtrlSetState($config_Sheet_sprache, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(206) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 8 Then GUICtrlSetState($config_Sheet_Backup, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(260) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 9 Then GUICtrlSetState($config_Sheet_Programmpfade, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(482) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 10 Then GUICtrlSetState($config_Sheet_Skins, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(138) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 11 Then GUICtrlSetState($config_Sheet_Plugins, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(493) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 12 Then GUICtrlSetState($config_Sheet_Erweitert, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(261) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 13 Then GUICtrlSetState($config_Sheet_Trophys, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(952) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 14 Then GUICtrlSetState($config_Sheet_Toolbar, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(327) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 15 Then GUICtrlSetState($config_Sheet_Tidy, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(1074) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 16 Then GUICtrlSetState($config_Sheet_Include, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(1085) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 17 Then GUICtrlSetState($config_Sheet_AutoSave, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(1109) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 18 Then GUICtrlSetState($config_Sheet_Skript_Editor_Dateitypen, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(1121) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 19 Then GUICtrlSetState($config_Sheet_API_Pfade, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(1150) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 20 Then GUICtrlSetState($config_Sheet_Makrosicherheit, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(407) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 21 Then GUICtrlSetState($config_Sheet_Programmpfade_AutoItPfade, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(607) Then
		If _GUICtrlTab_GetCurSel($config_tab) <> 22 Then GUICtrlSetState($config_Sheet_Tools, $GUI_SHOW)
	EndIf
EndFunc   ;==>_select_settingscategory



Func _Select_next_tab()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$current_tab = _GUICtrlTab_GetCurFocus($htab)
	$to_select = _GUICtrlTab_GetCurFocus($htab) + 1
	If $to_select > _GUICtrlTab_GetItemCount($htab) - 1 Then $to_select = 0
	Sleep(150)
	If Not _IsPressed('11', $user32) Then $to_select = $Tabswitch_last_Tab
	_GUICtrlTab_ActivateTabX($htab, $to_select)
	_Show_Tab($to_select)
	$Tabswitch_last_Tab = $current_tab
EndFunc   ;==>_Select_next_tab



Func _Select_previous_tab()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$to_select = _GUICtrlTab_GetCurFocus($htab) - 1
	If $to_select < 0 Then $to_select = _GUICtrlTab_GetItemCount($htab) - 1
	_GUICtrlTab_ActivateTabX($htab, $to_select)
	_Show_Tab($to_select)
EndFunc   ;==>_Select_previous_tab

Func _minimize_studio()
	GUISetState(@SW_MINIMIZE, $Studiofenster)
EndFunc   ;==>_minimize_studio

Func _Toggle_Fullscreen() ;for typo
	Return _Toggle_Fulscreen()
EndFunc   ;==>_Toggle_Fullscreen


Func _Toggle_Fulscreen()
	If $Fulscreen_Mode = 0 Then
		$Fulscreen_Mode = 1
		GUISetStyle($WS_POPUP, $WS_EX_ACCEPTFILES, $Studiofenster)
		;_MaxOnMonitor($Studiofenster, "", $Runonmonitor)
		WinSetState($Studiofenster, "", @SW_MAXIMIZE)
	Else
		$Fulscreen_Mode = 0
		GUISetStyle(BitOR($WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SYSMENU, $WS_CAPTION, $WS_SIZEBOX), $WS_EX_ACCEPTFILES, $Studiofenster)
		;_CenterOnMonitor($Studiofenster, "", $Runonmonitor)
		WinSetState($Studiofenster, "", @SW_MAXIMIZE)
	EndIf
	_GUICtrlStatusBar_Resize($Status_bar)

	_Rezize()
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		_Show_Tab(_GUICtrlTab_GetCurFocus($htab))
		_ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "resize")
	EndIf
	DllCall("user32.dll", "int", "RedrawWindow", "hwnd", $Studiofenster, "int", 0, "int", 0, "int", 0x1)
EndFunc   ;==>_Toggle_Fulscreen

;==================================================================================================
; Function Name:   _ShowMonitorInfo()
; Description::    Show the info in $__MonitorList in a msgbox (line 0 is entire screen)
; Parameter(s):    n/a
; Return Value(s): n/a
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _ShowMonitorInfo()
	If $__MonitorList[0][0] == 0 Then
		_GetMonitors()
	EndIf
	Local $msg = ""
	Local $i = 0
	For $i = 0 To $__MonitorList[0][0]
		$msg &= $i & " - L:" & $__MonitorList[$i][1] & ", T:" & $__MonitorList[$i][2]
		$msg &= ", R:" & $__MonitorList[$i][3] & ", B:" & $__MonitorList[$i][4]
		If $i < $__MonitorList[0][0] Then $msg &= @CRLF
	Next
	MsgBox(0, $__MonitorList[0][0] & " Monitors: ", $msg)
EndFunc   ;==>_ShowMonitorInfo

;==================================================================================================
; Function Name:   _MaxOnMonitor($Title[, $Text = ''[, $Monitor = -1]])
; Description::    Maximize a window on a specific monitor (or the monitor the mouse is on)
; Parameter(s):    $Title   The title of the window to Move/Maximize
;     optional:    $Text    The text of the window to Move/Maximize
;     optional:    $Monitor The monitor to move to (1..NumMonitors) defaults to monitor mouse is on
; Note:            Should probably have specified return/error codes but haven't put them in yet
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _MaxOnMonitor($Title, $text = '', $Monitor = -1)
	_CenterOnMonitor($Title, $text, $Monitor)
	WinSetState($Title, $text, @SW_MAXIMIZE)
EndFunc   ;==>_MaxOnMonitor

;==================================================================================================
; Function Name:   _CenterOnMonitor($Title[, $Text = ''[, $Monitor = -1]])
; Description::    Center a window on a specific monitor (or the monitor the mouse is on)
; Parameter(s):    $Title   The title of the window to Move/Maximize
;     optional:    $Text    The text of the window to Move/Maximize
;     optional:    $Monitor The monitor to move to (1..NumMonitors) defaults to monitor mouse is on
;					$Ignore_primary Ist nur 1 wenn Monitore Identifiziert werden (dadurch wird _get_primary_monitor() übersprungen)
; Note:            Should probably have specified return/error codes but haven't put them in yet
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _CenterOnMonitor($Title, $text = '', $Monitor = -1, $Ignore_primary = 0)
	If $Monitor = -1 Then $Monitor = $Runonmonitor
	If $Immer_am_primaeren_monitor_starten = "true" And $Ignore_primary = 0 Then $Monitor = _get_primary_monitor()
	$hWindow = WinGetHandle($Title, $text)
	If $Monitor > $__MonitorList[0][0] Then $Monitor = 1
	If Not @error Then
		If $Monitor == -1 Then
			$Monitor = _GetMonitorFromPoint()
		ElseIf $__MonitorList[0][0] == 0 Then
			_GetMonitors()
		EndIf
		If ($Monitor > 0) And ($Monitor <= $__MonitorList[0][0]) Then
			; Restore the window if necessary
			Local $WinState = WinGetState($hWindow)
			If BitAND($WinState, 16) Or BitAND($WinState, 32) Then
				WinSetState($hWindow, '', @SW_RESTORE)
			EndIf
			Local $WinSize = WinGetPos($hWindow)
			Local $x = Int(($__MonitorList[$Monitor][3] - $__MonitorList[$Monitor][1] - $WinSize[2]) / 2) + $__MonitorList[$Monitor][1]
			Local $y = Int(($__MonitorList[$Monitor][4] - $__MonitorList[$Monitor][2] - $WinSize[3]) / 2) + $__MonitorList[$Monitor][2]
			WinMove($hWindow, '', $x, $y)
		EndIf
	EndIf
EndFunc   ;==>_CenterOnMonitor




Func _Get_Monitor_Resolution($Monitor = -1)
	Local $array[2]
	If $Immer_am_primaeren_monitor_starten = "true" Then $Monitor = _get_primary_monitor()
	If $Monitor = -1 Then Return
	If $Monitor > $__MonitorList[0][0] Then $Monitor = 1
	If Not @error Then
		If $Monitor == -1 Then
			$Monitor = _GetMonitorFromPoint()
		ElseIf $__MonitorList[0][0] == 0 Then
			_GetMonitors()
		EndIf
		If ($Monitor > 0) And ($Monitor <= $__MonitorList[0][0]) Then
			Local $width = Int(($__MonitorList[$Monitor][3] - $__MonitorList[$Monitor][1]) / 2) * 2
			Local $height = Int(($__MonitorList[$Monitor][4] - $__MonitorList[$Monitor][2])) + $__MonitorList[$Monitor][2]
			$array[0] = $width
			$array[1] = $height
			Return $array
		EndIf
	EndIf
EndFunc   ;==>_Get_Monitor_Resolution



;==================================================================================================
; Function Name:   _GetMonitorFromPoint([$XorPoint = -654321[, $Y = 0]])
; Description::    Get a monitor number from an x/y pos or the current mouse position
; Parameter(s):
;     optional:    $XorPoint X Position or Array with X/Y as items 0,1 (ie from MouseGetPos())
;     optional:    $Y        Y Position
; Note:            Should probably have specified return/error codes but haven't put them in yet,
;                  and better checking should be done on passed variables.
;                  Used to use MonitorFromPoint DLL call, but it didn't seem to always work.
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _GetMonitorFromPoint($XorPoint = 0, $y = 0)
	If @NumParams = 0 Then
		Local $MousePos = MouseGetPos()
		Local $myX = $MousePos[0]
		Local $myY = $MousePos[1]
	ElseIf (@NumParams = 1) And IsArray($XorPoint) Then
		Local $myX = $XorPoint[0]
		Local $myY = $XorPoint[1]
	Else
		Local $myX = $XorPoint
		Local $myY = $y
	EndIf
	If $__MonitorList[0][0] == 0 Then
		_GetMonitors()
	EndIf
	Local $i = 0
	Local $Monitor = 0
	For $i = 1 To $__MonitorList[0][0]
		If ($myX >= $__MonitorList[$i][1]) _
				And ($myX < $__MonitorList[$i][3]) _
				And ($myY >= $__MonitorList[$i][2]) _
				And ($myY < $__MonitorList[$i][4]) Then $Monitor = $i
	Next
	Return $Monitor
EndFunc   ;==>_GetMonitorFromPoint

;==================================================================================================
; Function Name:   _GetMonitors()
; Description::    Load monitor positions
; Parameter(s):    n/a
; Return Value(s): 2D Array of Monitors
;                       [0][0] = Number of Monitors
;                       [i][0] = HMONITOR handle of this monitor.
;                       [i][1] = Left Position of Monitor
;                       [i][2] = Top Position of Monitor
;                       [i][3] = Right Position of Monitor
;                       [i][4] = Bottom Position of Monitor
; Note:            [0][1..4] are set to Left,Top,Right,Bottom of entire screen
;                  hMonitor is returned in [i][0], but no longer used by these routines.
;                  Also sets $__MonitorList global variable (for other subs to use)
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _GetMonitors()
	$__MonitorList[0][0] = 0 ;  Added so that the global array is reset if this is called multiple times
	Local $handle = DllCallbackRegister("_MonitorEnumProc", "int", "hwnd;hwnd;ptr;lparam")
	DllCall("user32.dll", "int", "EnumDisplayMonitors", "hwnd", 0, "ptr", 0, "ptr", DllCallbackGetPtr($handle), "lparam", 0)
	DllCallbackFree($handle)
	Local $i = 0
	For $i = 1 To $__MonitorList[0][0]
		If $__MonitorList[$i][1] < $__MonitorList[0][1] Then $__MonitorList[0][1] = $__MonitorList[$i][1]
		If $__MonitorList[$i][2] < $__MonitorList[0][2] Then $__MonitorList[0][2] = $__MonitorList[$i][2]
		If $__MonitorList[$i][3] > $__MonitorList[0][3] Then $__MonitorList[0][3] = $__MonitorList[$i][3]
		If $__MonitorList[$i][4] > $__MonitorList[0][4] Then $__MonitorList[0][4] = $__MonitorList[$i][4]
	Next
	Return $__MonitorList
EndFunc   ;==>_GetMonitors


;============================================================================================== _NumberAndNameMonitors
; Function Name:    _NumberAndNameMonitors ()
; Description:   Provides the first key elements of a multimonitor system, included the Regedit Keys
; Parameter(s):   None
; Return Value(s):   $NumberAndName [][]
;~        [0][0] total number of video devices
;;       [x][1] name of the device
;;       [x][2] name of the adapter
;;       [x][3] monitor flags (value is returned in Hex str -convert in DEC before use with Bitand)
;;       [x][4] registry key of the device
; Remarks:   the flag value [x][3] can be one of the following
;;       DISPLAY_DEVICE_ATTACHED_TO_DESKTOP  0x00000001
;;             DISPLAY_DEVICE_MULTI_DRIVER       0x00000002
;;            DISPLAY_DEVICE_PRIMARY_DEVICE    0x00000004
;;            DISPLAY_DEVICE_VGA               0x00000010
;;        DISPLAY_MIRROR_DEVICE  0X00000008
;;        DISPLAY_REMOVABLE  0X00000020
;
; Author(s):        Hermano
;===========================================================================================================================
Func _get_primary_monitor()
	Local $aScreenResolution = _DesktopDimensions()
	If Not IsArray($aScreenResolution) Then Return 1
	Return _GetMonitorFromPoint(($aScreenResolution[1] / 2), ($aScreenResolution[2] / 2))

	;Funktioniert ab Win10 nicht mehr zu 100%
;~ 	Local $dev = -1, $id = 0, $msg_ = "", $EnumDisplays, $StateFlag
;~ 	Dim $NumberAndName[2][6]
;~ 	Local $DISPLAY_DEVICE = DllStructCreate("int;char[32];char[128];int;char[128];char[128]")
;~ 	DllStructSetData($DISPLAY_DEVICE, 1, DllStructGetSize($DISPLAY_DEVICE))
;~ 	Dim $dll = "user32.dll"
;~ 	Do
;~ 		$dev += 1
;~ 		$EnumDisplays = DllCall($dll, "int", "EnumDisplayDevices", "ptr", 0, "int", $dev, "ptr", DllStructGetPtr($DISPLAY_DEVICE), "int", 1)
;~ 		If $EnumDisplays[0] <> 0 Then
;~ 			ReDim $NumberAndName[$dev + 2][6]
;~ 			$NumberAndName[$dev + 1][1] = DllStructGetData($DISPLAY_DEVICE, 2) ;device Name
;~ 			$NumberAndName[$dev + 1][2] = DllStructGetData($DISPLAY_DEVICE, 3) ;device or display description
;~ 			$NumberAndName[$dev + 1][3] = Hex(DllStructGetData($DISPLAY_DEVICE, 4)) ;all flags (value in HEX)
;~ 			$NumberAndName[$dev + 1][4] = DllStructGetData($DISPLAY_DEVICE, 6) ;registry key of the device
;~ 			$NumberAndName[$dev + 1][5] = DllStructGetData($DISPLAY_DEVICE, 5) ;hardware interface name
;~ 		EndIf
;~ 	Until $EnumDisplays[0] = 0
;~ 	$NumberAndName[0][0] += $dev
;~ 	For $x = 0 To $NumberAndName[0][0]
;~ 		If BitAND($NumberAndName[$x][3], 0x00000004) Then
;~ 			Return $x
;~ 		EndIf
;~ 	Next
;~ 	Return 1
EndFunc   ;==>_get_primary_monitor


;==================================================================================================
; Function Name:   _MonitorEnumProc($hMonitor, $hDC, $lRect, $lParam)
; Description::    Enum Callback Function for EnumDisplayMonitors in _GetMonitors
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _MonitorEnumProc($hMonitor, $hDC, $lRect, $lParam)
	Local $Rect = DllStructCreate("int left;int top;int right;int bottom", $lRect)
	$__MonitorList[0][0] += 1
	ReDim $__MonitorList[$__MonitorList[0][0] + 1][5]
	$__MonitorList[$__MonitorList[0][0]][0] = $hMonitor
	$__MonitorList[$__MonitorList[0][0]][1] = DllStructGetData($Rect, "left")
	$__MonitorList[$__MonitorList[0][0]][2] = DllStructGetData($Rect, "top")
	$__MonitorList[$__MonitorList[0][0]][3] = DllStructGetData($Rect, "right")
	$__MonitorList[$__MonitorList[0][0]][4] = DllStructGetData($Rect, "bottom")
	Return 1 ; Return 1 to continue enumeration
EndFunc   ;==>_MonitorEnumProc

; #FUNCTION# ====================================================================================================================
; Name ..........: _DesktopDimensions
; Description ...: Returns an array containing information about the primary and virtual monitors.
; Syntax ........: _DesktopDimensions()
; Return values .: Success - Returns a 6-element array containing the following information:
;                  $aArray[0] = Total number of monitors.
;                  $aArray[1] = Width of the primary monitor.
;                  $aArray[2] = Height of the primary monitor.
;                  $aArray[3] = Total width of the desktop including the width of multiple monitors. Note: If no secondary monitor this will be the same as $aArray[2].
;                  $aArray[4] = Total height of the desktop including the height of multiple monitors. Note: If no secondary monitor this will be the same as $aArray[3].
; Author ........: guinness
; Remarks .......: WinAPI.au3 must be included i.e. #include <WinAPI.au3>
; Related .......: @DesktopWidth, @DesktopHeight, _WinAPI_GetSystemMetrics
; Example .......: Yes
; ===============================================================================================================================
Func _DesktopDimensions()
	Local $aReturn = [_WinAPI_GetSystemMetrics($SM_CMONITORS), _ ; Number of monitors.
			_WinAPI_GetSystemMetrics($SM_CXSCREEN), _ ; Width or Primary monitor.
			_WinAPI_GetSystemMetrics($SM_CYSCREEN), _ ; Height or Primary monitor.
			_WinAPI_GetSystemMetrics($SM_CXVIRTUALSCREEN), _ ; Width of the Virtual screen.
			_WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN)] ; Height of the Virtual screen.
	Return $aReturn
EndFunc   ;==>_DesktopDimensions

Func _monitore_identifizieren()
	GUICtrlSetState($darstellung_identify, $GUI_DISABLE)
	Global $identifizieren_Guis[20]
	For $Count = 1 To $__MonitorList[0][0]
		$identifizieren_Guis[$Count] = GUICreate("", 800, 700, -1, -1, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOPMOST + $WS_EX_TOOLWINDOW)
		_CenterOnMonitor($identifizieren_Guis[$Count], "", $Count, 1)
		GUICtrlCreateLabel($Count, 0, 0, 800, 800, $SS_CENTER)
		GUICtrlSetBkColor(-1, -2)
		GUICtrlSetFont(-1, 400, 400, 0, "Arial")
		GUISetBkColor(0xABCDEF, $identifizieren_Guis[$Count])
		_WinAPI_SetLayeredWindowAttributes($identifizieren_Guis[$Count], 0xABCDEF, 255)
		GUISetState(@SW_SHOW, $identifizieren_Guis[$Count])
	Next
	Sleep(2500) ;wait 2,5 secounds
	For $Count = 1 To $__MonitorList[0][0]
		GUIDelete($identifizieren_Guis[$Count])
	Next
	GUICtrlSetState($darstellung_identify, $GUI_ENABLE)
EndFunc   ;==>_monitore_identifizieren

Func _ColourInvert($code)
	Return "0x" & Hex(0xFFFFFF - $code, 6)
EndFunc   ;==>_ColourInvert

Func _Drag_and_drop_import_file($Count, $files)
	WinActivate($Studiofenster)
	If $Studiomodus = 1 Then
		$res = _WinAPI_BrowseForFolderDlg($Offenes_Projekt, _Get_langstr(59), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
	Else
		$res = _WinAPI_BrowseForFolderDlg("", _Get_langstr(59), $BIF_RETURNONLYFSDIRS, 0, 0, $Studiofenster)
	EndIf
	If @error Or $res = "" Then
		Return
	Else
		For $x = 0 To $Count - 1
			_FileOperationProgress($files[$x], $res, 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			If @extended == 1 Then ;ERROR
				Return
			EndIf
			_Write_log($files[$x] & " " & _Get_langstr(63))
		Next
		FileChangeDir(@ScriptDir)
		;_Update_Treeview()
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(60), 0, $Studiofenster)
		If $Count > 14 Then _Earn_trophy(7, 2)
	EndIf
EndFunc   ;==>_Drag_and_drop_import_file

Func _GetToolbarButtonScreenPos($hWnd, $hTb, $iCmdID, $iOffset = 0, $iIndex = 0, $hRbar = -1)
	; Author: rover 04/08/2008
	; this UDF integrates _WinAPI_ClientToScreen() from WinAPI.au3 include.
	; _GUICtrlMenu_TrackPopupMenu() uses screen coordinates to place dropdown menu.
	; button client coordinates must be converted to screen coordinates.
	; $hRbar and $iIndex is for optional Rebar hwnd and band index
	; $iOffset sets menu Y position below button
	; Update: 06/27/2009 added offset for menu position below button, corrected left off-screen menu positioning.
	; Update: 07/13/2009 added compensation for CCS_NORESIZE and RBS_BANDBORDERS style alignment problems. cleaned up error handling.
	Local $aBorders, $aBandRect, $aRect, $tPOINT, $pPoint, $aRet[2]
	Local $aRect = _GUICtrlToolbar_GetButtonRect($hTb, $iCmdID)
	If @error Then Return SetError(@error, 0, $aRet)
	$tPOINT = DllStructCreate("int X;int Y")
	DllStructSetData($tPOINT, "X", $aRect[0])
	DllStructSetData($tPOINT, "Y", $aRect[3])
	$pPoint = DllStructGetPtr($tPOINT)
	DllCall("User32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", $pPoint)
	If @error Then Return SetError(@error, 0, $aRet)
	; X screen coordinate of dropdown button left corner
	$aRet[0] = DllStructGetData($tPOINT, "X")
	;limit X coordinate to 0 if button partially off-screen
;~         If $aRet[0] < 0 Then $aRet[0] = 0 ;bugfix for MultiMonitor Support
	; Y screen coordinate of dropdown button left corner
	$aRet[1] = DllStructGetData($tPOINT, "Y") + Number($iOffset)
	;#cs  comment out if not using rebars
	If $hRbar <> -1 And IsHWnd($hRbar) And IsNumber($iIndex) Then
		If BitAND(_SendMessage($hTb, $TB_GETSTYLE), $CCS_NORESIZE) = $CCS_NORESIZE Then
			$aBorders = _GUICtrlRebar_GetBandBorders($hRbar, $iIndex)
			If @error Then Return SetError(@error, 0, $aRet)
			$aBandRect = _GUICtrlRebar_GetBandRect($hRbar, $iIndex)
			If @error Then Return SetError(@error, 0, $aRet)
			; X screen coordinate of dropdown button left corner
			; add or subtract 2 pixel border of bounding rectangle for band in rebar control
			If BitAND(_WinAPI_GetWindowLong($hReBar, $GWL_STYLE), $RBS_BANDBORDERS) = 0 Then $aBandRect[0] = -$aBandRect[0]
			If $aRet[0] <> 0 Then $aRet[0] += ($aBorders[0] - $aBandRect[0])
		EndIf
	EndIf
	;#ce
	Return $aRet ; return X,Y screen coordinates of toolbar dropdown button lower left corner
EndFunc   ;==>_GetToolbarButtonScreenPos

Func _WinAPI_ShellExtractIcons($icon, $Index, $width, $height)
	Local $Ret = DllCall('shell32.dll', 'int', 'SHExtractIconsW', 'wstr', $icon, 'int', $Index, 'int', $width, 'int', $height, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)
	If @error Or $Ret[0] = 0 Or $Ret[5] = Ptr(0) Then Return SetError(1, 0, 0)
	Return $Ret[5]
EndFunc   ;==>_WinAPI_ShellExtractIcons

Func WM_DROPFILES_FUNC($hWnd, $MsgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
	_Drag_and_drop_import_file($nAmt[0], $gaDropFiles)
EndFunc   ;==>WM_DROPFILES_FUNC

Func _Fadeout_logo()
	If $enablelogo = "true" Then
		$alpha = 255
		GUISetState(@SW_HIDE, $controlGui_startup)
		While 1
			$alpha = $alpha - 13
			If $alpha < 0 Then $alpha = 0
			If $alpha = 0 Then ExitLoop
			SetBitmap($Logo_PNG, $hImagestartup, $alpha)
		WEnd
		SetBitmap($Logo_PNG, $hImagestartup, 0)
		GUISetState(@SW_HIDE, $Logo_PNG)
	EndIf
EndFunc   ;==>_Fadeout_logo

Func _Show_Parameterconfig()
	Local $array_params
	$Params = _IniReadRaw($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "testparam", "")
	GUICtrlSetData($startparameter_input, StringReplace($Params, "#BREAK#", @CRLF))
	GUISetState(@SW_SHOW, $parameter_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
	_GUICtrlEdit_SetSel($startparameter_input, -1, -1)
EndFunc   ;==>_Show_Parameterconfig

Func _HIDE_Parameterconfig()
	$Param_String = GUICtrlRead($startparameter_input)
	$Param_String = StringReplace($Param_String, @CRLF, "#BREAK#")
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "testparam", $Param_String)
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $parameter_GUI)
EndFunc   ;==>_HIDE_Parameterconfig

Func _HIDE_Parameterconfig_without_save()
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $parameter_GUI)
EndFunc   ;==>_HIDE_Parameterconfig_without_save

Func _Open_Homepage()
	ShellExecute("https://www.isnetwork.at")
EndFunc   ;==>_Open_Homepage

Func _Open_Weitere_Plugins_Downloaden()
	ShellExecute("https://www.isnetwork.at/isn-plugins/")
EndFunc   ;==>_Open_Weitere_Plugins_Downloaden

Func _Open_Forum()
	ShellExecute("https://www.isnetwork.at/forum")
EndFunc   ;==>_Open_Forum

Func _ISN_AutoIt_Studio_Spenden()
	ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=S94VE64V6HYP2&lc=AT&item_name=Spende%20fuer%20ISN%20AutoIt%20Studio&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted")
EndFunc   ;==>_ISN_AutoIt_Studio_Spenden

Func _WillkommenGUI_Wechsle_Nich_mehr_anzeigen_Checkbox()
	If GUICtrlRead($Willkommen_autoloadcheckbox) = $GUI_UNCHECKED Then
		GUICtrlSetState($Willkommen_autoloadcheckbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Willkommen_autoloadcheckbox, $GUI_UNCHECKED)
	EndIf
	_toggle_Willkommen_Autoload()
EndFunc   ;==>_WillkommenGUI_Wechsle_Nich_mehr_anzeigen_Checkbox

Func _IniReadRaw($inifile, $header, $key, $defval = "")
	Local $arr = IniReadSection($inifile, $header)
	If @error Or Not IsArray($arr) Then Return SetError(1, 0, $defval)

	For $i = 1 To $arr[0][0]
		If $arr[$i][0] == $key Then Return $arr[$i][1]
	Next

	Return SetError(1, 1, $defval)
EndFunc   ;==>_IniReadRaw


Func _Resize_Elements_to_Window()

	$size_new_resize = WinGetClientSize($Studiofenster, "")
	If BitAND(WinGetState($Studiofenster, ""), 16) Then Return
	If Not IsArray($size_before_resize) Then Return
	If Not IsArray($size_new_resize) Then Return
	If $size_new_resize[0] < 0 Then Return
	If $size_new_resize[1] < 0 Then Return
	If $size_new_resize[0] = 0 Then Return ;Fenster ist Minimiert
	If $size_new_resize[1] = 0 Then Return ;Fenster ist Minimiert
	If $size_before_resize[0] = 0 Then Return ;Fenster ist Minimiert
	If $size_before_resize[1] = 0 Then Return ;Fenster ist Minimiert
	$dif0 = $size_before_resize[0] - $size_new_resize[0]
	$dif1 = $size_before_resize[1] - $size_new_resize[1]
	If $dif0 = 0 And $dif1 = 0 Then Return

	;Abgrenzung setzen
	GUICtrlSetPos($Abgrenzung_vor_statusbar, -10, $size_new_resize[1] - 25, 9999, 2)

	;Sci Debug Output
	If $IS_HIDDEN_UNTEN = 1 Or $hidedebug = "true" Then
	Else
		GUICtrlSetPos($Middle_Splitter_Y, Default, ($size_new_resize[1] / 100) * Number(_Config_Read("Middle_Splitter_Y", $Mittlerer_Splitter_Y_default)))
	EndIf

	;Splitter zwischen Projektbaum und QuickView
	GUICtrlSetPos($Left_Splitter_Y, 2, ($size_new_resize[1] / 100) * Number(_Config_Read("Left_Splitter_Y", $Linker_Splitter_Y_default)))

	;Splitter zwischen projektbaum und Sci
	If $Toggle_Leftside = 0 Then GUICtrlSetPos($Left_Splitter_X, ($size_new_resize[0] / 100) * Number(_Config_Read("Left_Splitter_X", $Linker_Splitter_X_default)))

	;Splitter zwischen Skriptbaum und Sci
	If $hidefunctionstree = "true" Or $IS_HIDDEN_RECHTS = 1 Or $Toggle_rightside = 1 Then
		GUICtrlSetPos($Right_Splitter_X, $size_new_resize[0] - 2, 25, $Splitter_Breite, $size_new_resize[1] - 80)
	Else
		GUICtrlSetPos($Right_Splitter_X, ($size_new_resize[0] / 100) * Number(_Config_Read("Right_Splitter_X", $Rechter_Splitter_X_default)))
	EndIf

	_Show_Tab(_GUICtrlTab_GetCurFocus($htab))
EndFunc   ;==>_Resize_Elements_to_Window

Func _Try_to_open_external_file()
	If $Offenes_Projekt = "" Then Return
	_Lock_Plugintabs("lock")
	Local $Dateipfad = FileOpenDialog(_Get_langstr(509), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(58) & " (*.*)", 1 + 2, "", $Studiofenster)
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	WinActivate($Studiofenster)
	GUISwitch($Studiofenster)
	If $Dateipfad = "" Then Return
	If @error Then
		Return
	Else

		Try_to_opten_file($Dateipfad)
	EndIf
EndFunc   ;==>_Try_to_open_external_file

Func _GUISetIcon($hHandle, $sFile, $iName)
	;Edit by isi360
	Return _SendMessage($hHandle, $WM_SETICON, 1, _WinAPI_ShellExtractIcon($sFile, $iName, 16, 16))
EndFunc   ;==>_GUISetIcon



Func _open_windowinfotool()
	If $Offenes_Projekt = "" Then Return
	If Not FileExists($Au3Infoexe) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1168), 0, $Studiofenster)
		Return
	EndIf

	If ProcessExists(StringTrimLeft($Au3Infoexe, StringInStr($Au3Infoexe, "\", 0, -1))) Then
		ProcessClose(StringTrimLeft($Au3Infoexe, StringInStr($Au3Infoexe, "\", 0, -1)))
	Else
		ShellExecute($Au3Infoexe)
	EndIf
EndFunc   ;==>_open_windowinfotool

Func _Toggle_msgboxcreator()
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_MSGBoxGenerator) <> -1 Then Return ;Platzhalter für Plugin
	$state = WinGetState($msgboxcreator, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_HIDE, $msgboxcreator)
	Else
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
		If $Offenes_Projekt = "" Then Return
		GUISetState(@SW_SHOW, $msgboxcreator)
	EndIf
	_Msgbox_generator_set_state()
EndFunc   ;==>_Toggle_msgboxcreator

Func _Zeichen_fuer_Handle_ersetzen($handle = "")
	If $handle = "" Then Return $handle
	$handle = StringReplace($handle, "=", "")
	$handle = StringReplace($handle, "?", "")
	$handle = StringReplace($handle, "!", "")
	$handle = StringReplace($handle, "+", "")
	$handle = StringReplace($handle, "\", "")
	$handle = StringReplace($handle, "/", "")
	$handle = StringReplace($handle, "%", "")
	$handle = StringReplace($handle, "ö", "")
	$handle = StringReplace($handle, "ä", "")
	$handle = StringReplace($handle, "ü", "")
	$handle = StringReplace($handle, "#", "")
	$handle = StringReplace($handle, "(", "")
	$handle = StringReplace($handle, ")", "")
	$handle = StringReplace($handle, " ", "")
	Return $handle
EndFunc   ;==>_Zeichen_fuer_Handle_ersetzen

Func _Msgbox_generator_set_state()
	$buttons = 0

	If GUICtrlRead($msgbox_creator_radio_buttons1) = $GUI_CHECKED Then $buttons = 0
	If GUICtrlRead($msgbox_creator_radio_buttons2) = $GUI_CHECKED Then $buttons = 2
	If GUICtrlRead($msgbox_creator_radio_buttons3) = $GUI_CHECKED Then $buttons = 2
	If GUICtrlRead($msgbox_creator_radio_buttons4) = $GUI_CHECKED Then $buttons = 3
	If GUICtrlRead($msgbox_creator_radio_buttons5) = $GUI_CHECKED Then $buttons = 3
	If GUICtrlRead($msgbox_creator_radio_buttons6) = $GUI_CHECKED Then $buttons = 2
	If GUICtrlRead($msgbox_creator_radio_buttons7) = $GUI_CHECKED Then $buttons = 3

	GUICtrlSetState($msgbox_creator_radio_defbutton1, $GUI_CHECKED)
	GUICtrlSetState($msgbox_creator_radio_defbutton1, $GUI_DISABLE)
	GUICtrlSetState($msgbox_creator_radio_defbutton2, $GUI_DISABLE)
	GUICtrlSetState($msgbox_creator_radio_defbutton3, $GUI_DISABLE)
	If $buttons > 0.9 Then GUICtrlSetState($msgbox_creator_radio_defbutton1, $GUI_ENABLE)
	If $buttons > 1.9 Then GUICtrlSetState($msgbox_creator_radio_defbutton2, $GUI_ENABLE)
	If $buttons > 2.9 Then GUICtrlSetState($msgbox_creator_radio_defbutton3, $GUI_ENABLE)
EndFunc   ;==>_Msgbox_generator_set_state

Func _msgboxcreator_vorschau()

	$flags = 0
	$text = StringReplace(GUICtrlRead($msgbox_creator_edit), '"', "'")
	If GUICtrlRead($msgbox_creator_icon1) = $GUI_CHECKED Then $flags = $flags + 0
	If GUICtrlRead($msgbox_creator_icon2) = $GUI_CHECKED Then $flags = $flags + 16
	If GUICtrlRead($msgbox_creator_icon3) = $GUI_CHECKED Then $flags = $flags + 48
	If GUICtrlRead($msgbox_creator_icon4) = $GUI_CHECKED Then $flags = $flags + 64
	If GUICtrlRead($msgbox_creator_icon5) = $GUI_CHECKED Then $flags = $flags + 32

	If GUICtrlRead($msgbox_creator_vordergrund_checkbox) = $GUI_CHECKED Then $flags = $flags + 262144
	If GUICtrlRead($msgbox_creator_text_rechts_checkbox) = $GUI_CHECKED Then $flags = $flags + 524288
	If GUICtrlRead($msgbox_creator_hasicon_checkbox) = $GUI_CHECKED Then $flags = $flags + 4096

	If GUICtrlRead($msgbox_creator_radio_buttons1) = $GUI_CHECKED Then $flags = $flags + 0
	If GUICtrlRead($msgbox_creator_radio_buttons2) = $GUI_CHECKED Then $flags = $flags + 1
	If GUICtrlRead($msgbox_creator_radio_buttons3) = $GUI_CHECKED Then $flags = $flags + 4
	If GUICtrlRead($msgbox_creator_radio_buttons4) = $GUI_CHECKED Then $flags = $flags + 3
	If GUICtrlRead($msgbox_creator_radio_buttons5) = $GUI_CHECKED Then $flags = $flags + 2
	If GUICtrlRead($msgbox_creator_radio_buttons6) = $GUI_CHECKED Then $flags = $flags + 5
	If GUICtrlRead($msgbox_creator_radio_buttons7) = $GUI_CHECKED Then $flags = $flags + 6

	If GUICtrlRead($msgbox_creator_radio_defbutton1) = $GUI_CHECKED Then $flags = $flags + 0
	If GUICtrlRead($msgbox_creator_radio_defbutton2) = $GUI_CHECKED Then $flags = $flags + 256
	If GUICtrlRead($msgbox_creator_radio_defbutton3) = $GUI_CHECKED Then $flags = $flags + 512
	MsgBox($flags, GUICtrlRead($msgbox_creator_title), $text, GUICtrlRead($msgbox_creator_timeout), $msgboxcreator)
EndFunc   ;==>_msgboxcreator_vorschau



Func _Insert_msgboxcode()
	If $Offenes_Projekt = "" Then Return
	If GUICtrlRead($msgbox_creator_handle) = "" And GUICtrlRead($msgbox_creator_radio_buttons1) <> $GUI_CHECKED Then
		_Input_Error_FX($msgbox_creator_handle)
		Return
	EndIf
	If Not StringInStr(GUICtrlRead($msgbox_creator_handle), "$") And GUICtrlRead($msgbox_creator_handle) <> "" Then GUICtrlSetData($msgbox_creator_handle, "$" & GUICtrlRead($msgbox_creator_handle))
	If Not StringInStr(GUICtrlRead($msgbox_creator_parent), "$") And GUICtrlRead($msgbox_creator_parent) <> "" Then GUICtrlSetData($msgbox_creator_parent, "$" & GUICtrlRead($msgbox_creator_parent))
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then
			$flags = 0

			$parent = ""
			$code = ""
			$text = StringReplace(GUICtrlRead($msgbox_creator_edit), '"', "'")
			$asMsgText = StringSplit($text, @CRLF, 1)
			If $asMsgText[0] = 1 Then
				$text = $text
			Else
				$text = $asMsgText[1]
				For $iCtr = 2 To $asMsgText[0]
					$text = $text & Chr(34) & " & @CRLF & " & Chr(34) & $asMsgText[$iCtr]
				Next

			EndIf

			$handle = GUICtrlRead($msgbox_creator_handle)
			$handle = _Zeichen_fuer_Handle_ersetzen($handle)
			GUICtrlSetData($msgbox_creator_handle, $handle)

			$parent = GUICtrlRead($msgbox_creator_parent)
			$parent = _Zeichen_fuer_Handle_ersetzen($parent)
			GUICtrlSetData($msgbox_creator_parent, $parent)

			If GUICtrlRead($msgbox_creator_icon1) = $GUI_CHECKED Then $flags = $flags + 0
			If GUICtrlRead($msgbox_creator_icon2) = $GUI_CHECKED Then $flags = $flags + 16
			If GUICtrlRead($msgbox_creator_icon3) = $GUI_CHECKED Then $flags = $flags + 48
			If GUICtrlRead($msgbox_creator_icon4) = $GUI_CHECKED Then $flags = $flags + 64
			If GUICtrlRead($msgbox_creator_icon5) = $GUI_CHECKED Then $flags = $flags + 32

			If GUICtrlRead($msgbox_creator_vordergrund_checkbox) = $GUI_CHECKED Then $flags = $flags + 262144
			If GUICtrlRead($msgbox_creator_text_rechts_checkbox) = $GUI_CHECKED Then $flags = $flags + 524288
			If GUICtrlRead($msgbox_creator_hasicon_checkbox) = $GUI_CHECKED Then $flags = $flags + 4096

			If GUICtrlRead($msgbox_creator_radio_buttons1) = $GUI_CHECKED Then $flags = $flags + 0
			If GUICtrlRead($msgbox_creator_radio_buttons2) = $GUI_CHECKED Then $flags = $flags + 1
			If GUICtrlRead($msgbox_creator_radio_buttons3) = $GUI_CHECKED Then $flags = $flags + 4
			If GUICtrlRead($msgbox_creator_radio_buttons4) = $GUI_CHECKED Then $flags = $flags + 3
			If GUICtrlRead($msgbox_creator_radio_buttons5) = $GUI_CHECKED Then $flags = $flags + 2
			If GUICtrlRead($msgbox_creator_radio_buttons6) = $GUI_CHECKED Then $flags = $flags + 5
			If GUICtrlRead($msgbox_creator_radio_buttons7) = $GUI_CHECKED Then $flags = $flags + 6

			If GUICtrlRead($msgbox_creator_radio_defbutton1) = $GUI_CHECKED Then $flags = $flags + 0
			If GUICtrlRead($msgbox_creator_radio_defbutton2) = $GUI_CHECKED Then $flags = $flags + 256
			If GUICtrlRead($msgbox_creator_radio_defbutton3) = $GUI_CHECKED Then $flags = $flags + 512

			If GUICtrlRead($msgbox_creator_parent) <> "" Then $parent = ", " & GUICtrlRead($msgbox_creator_parent)

			$Istgleich = ""
			If $handle <> "" Then $Istgleich = " = "

			$code = @CRLF & $handle & $Istgleich & "MsgBox(" & $flags & ',"' & GUICtrlRead($msgbox_creator_title) & '","' & $text & '",' & GUICtrlRead($msgbox_creator_timeout) & $parent & ")" & @CRLF

			If GUICtrlRead($msgbox_creator_radio_buttons1) = $GUI_UNCHECKED Then
				$code = $code & "switch " & GUICtrlRead($msgbox_creator_handle) & @CRLF & @CRLF

				If GUICtrlRead($msgbox_creator_radio_buttons2) = $GUI_CHECKED Then
					$code = $code & @TAB & "case 1 ;OK" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 2 ;CANCEL" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
				EndIf

				If GUICtrlRead($msgbox_creator_radio_buttons3) = $GUI_CHECKED Then
					$code = $code & @TAB & "case 6 ;YES" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 7 ;NO" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
				EndIf

				If GUICtrlRead($msgbox_creator_radio_buttons4) = $GUI_CHECKED Then
					$code = $code & @TAB & "case 6 ;YES" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 7 ;NO" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 2 ;CANCEL" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
				EndIf

				If GUICtrlRead($msgbox_creator_radio_buttons5) = $GUI_CHECKED Then
					$code = $code & @TAB & "case 2 ;CANCEL" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 4 ;RETRY" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 5 ;IGNORE" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
				EndIf

				If GUICtrlRead($msgbox_creator_radio_buttons6) = $GUI_CHECKED Then
					$code = $code & @TAB & "case 5 ;RETRY" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 2 ;CANCEL" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
				EndIf

				If GUICtrlRead($msgbox_creator_radio_buttons7) = $GUI_CHECKED Then
					$code = $code & @TAB & "case 2 ;CANCEL" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 10 ;TRY AGAIN" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
					$code = $code & @TAB & "case 11 ;CONTINUE" & @CRLF & @TAB & ";Your code here..." & @CRLF & @CRLF
				EndIf

				$code = $code & "endswitch" & @CRLF
			EndIf

			If $autoit_editor_encoding = "2" Then
				Sci_InsertText($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), _UNICODE2ANSI($code))
			Else
				Sci_InsertText($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), $code)
			EndIf
			_Check_Buttons(0)
		EndIf
	EndIf
EndFunc   ;==>_Insert_msgboxcode

Func _colourpicker_pick_colour()
	GUISetState(@SW_DISABLE, $Studiofenster)
	$Farbe = _ColorChooserDialog(GUICtrlGetBkColor($colour_vorschau), $colour_picker)
	GUISetState(@SW_ENABLE, $Studiofenster)
	If $Farbe > -1 Then
		GUICtrlSetBkColor($colour_vorschau, $Farbe)
		GUICtrlSetData($colour_hex, "0x" & Hex($Farbe, 6))
		GUICtrlSetData($colour_red, _ColorGetRed($Farbe))
		GUICtrlSetData($colour_green, _ColorGetGreen($Farbe))
		GUICtrlSetData($colour_blue, _ColorGetBlue($Farbe))
	EndIf
EndFunc   ;==>_colourpicker_pick_colour

Func _colourpicker_insert_hex_in_code()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		Sci_InsertText($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), GUICtrlRead($colour_hex))
	EndIf
EndFunc   ;==>_colourpicker_insert_hex_in_code

Func _Toggle_colourpicker()
	If $Offenes_Projekt = "" Then Return
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_Farbtoolbox) <> -1 Then Return ;Platzhalter für Plugin
	$state = WinGetState($colour_picker, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_HIDE, $colour_picker)
	Else
		GUISetState(@SW_SHOW, $colour_picker)
	EndIf
EndFunc   ;==>_Toggle_colourpicker

; #FUNCTION# ;===============================================================================
;
; Name...........: _Aktualisiere_Splittercontrols
; Description ...: Wird verwendet um die Position der Controls und die Splitter zu aktualisieren
; Syntax.........: _Aktualisiere_Splittercontrols()
; Parameters ....: Keine
; Return values .: Keine
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird zb. auch in der Funktion _move_Splitter() aufgerufen
;                  Alle Controls die im Splittersystem verwendet werden sollen MÜSSEN hier aufgeführt sein!
; Related .......:
; Link ..........; http://www.isnetwork.at
; Example .......; No
;
; ;==========================================================================================

Func _Aktualisiere_Splittercontrols()

	;Hole windowclientsize
	$windowsize = WinGetClientSize($Studiofenster)
	GUICtrlSetPos($Abgrenzung_vor_statusbar, -10, $windowsize[1] - 25, 9999, 2)

	;Prüfe ob Programmlog aktiviert ist und aktiveiere/deaktiviere es
	If $hideprogramlog = "true" Then
		$position_Abgrenzung_vor_statusbar = ControlGetPos($Studiofenster, "", $Abgrenzung_vor_statusbar)
		GUICtrlSetState($QuickView_title, $GUI_HIDE)
		GUICtrlSetState($Left_Splitter_Y, $GUI_HIDE)
		GUISetState(@SW_HIDE, $QuickView_GUI)
		GUICtrlSetPos($Left_Splitter_Y, $position_Abgrenzung_vor_statusbar[0], $position_Abgrenzung_vor_statusbar[1])
	EndIf

	If $hidedebug = "false" And $IS_HIDDEN_UNTEN = 0 Then

		GUICtrlSetState($Middle_Splitter_Y, $GUI_SHOW)
		GUICtrlSetState($Debug_log, $GUI_SHOW)

		If $Zeige_Buttons_neben_Debug_Fenster = "true" Then
			GUICtrlSetState($Debug_Log_Undo_Button, $GUI_SHOW)
			GUICtrlSetState($Debug_Log_Redo_Button, $GUI_SHOW)
			GUICtrlSetState($Debug_Log_Zwischenablage_Button, $GUI_SHOW)
		Else
			GUICtrlSetState($Debug_Log_Undo_Button, $GUI_HIDE)
			GUICtrlSetState($Debug_Log_Redo_Button, $GUI_HIDE)
			GUICtrlSetState($Debug_Log_Zwischenablage_Button, $GUI_HIDE)
		EndIf
	Else
		$position_Abgrenzung_vor_statusbar = ControlGetPos($Studiofenster, "", $Abgrenzung_vor_statusbar)
		GUICtrlSetState($Middle_Splitter_Y, $GUI_HIDE)
		GUICtrlSetState($Debug_log, $GUI_HIDE)
		GUICtrlSetState($Debug_Log_Undo_Button, $GUI_HIDE)
		GUICtrlSetState($Debug_Log_Redo_Button, $GUI_HIDE)
		GUICtrlSetState($Debug_Log_Zwischenablage_Button, $GUI_HIDE)
		GUICtrlSetPos($Middle_Splitter_Y, $position_Abgrenzung_vor_statusbar[0], $position_Abgrenzung_vor_statusbar[1])
	EndIf

	;Weise zuerst (!!) die Controls den Splittern zu...
	If $Toggle_Leftside = 0 Then _Add_control_to_Splitter($Studiofenster, $Projecttree_title, -1, $Left_Splitter_X, $Abgrenzung_nach_toolbar, $hTreeView)
	If $Toggle_Leftside = 0 Then _Add_control_to_Splitter($Studiofenster, $hTreeView, -1, $Left_Splitter_X, $Projecttree_title, $Left_Splitter_Y)
	If $Toggle_Leftside = 0 Then _Add_control_to_Splitter($Studiofenster, $QuickView_title, -1, $Left_Splitter_X, $Left_Splitter_Y, 19 * $DPI)
	If $Toggle_Leftside = 0 Then _Add_control_to_Splitter($Studiofenster, $QuickView_Dummy_Control, -1, $Left_Splitter_X, $QuickView_title, $Abgrenzung_vor_statusbar)
	_Add_control_to_Splitter($Studiofenster, $htab, $Left_Splitter_X, $Right_Splitter_X, $Abgrenzung_nach_toolbar, $Middle_Splitter_Y)
	_Add_control_to_Splitter($Studiofenster, $Debug_Log_Undo_Button, $Left_Splitter_X, 25 * $DPI, $Middle_Splitter_Y, 25 * $DPI)
	If $Zeige_Buttons_neben_Debug_Fenster = "true" Then
		_Add_control_to_Splitter($Studiofenster, $Debug_log, $Debug_Log_Undo_Button, $Right_Splitter_X, $Middle_Splitter_Y, $Abgrenzung_vor_statusbar)
	Else
		_Add_control_to_Splitter($Studiofenster, $Debug_log, $Left_Splitter_X, $Right_Splitter_X, $Middle_Splitter_Y, $Abgrenzung_vor_statusbar)
	EndIf
	_Add_control_to_Splitter($Studiofenster, $Debug_Log_Redo_Button, $Left_Splitter_X, 25 * $DPI, $Debug_Log_Undo_Button, 25 * $DPI)
	_Add_control_to_Splitter($Studiofenster, $Debug_Log_Zwischenablage_Button, $Left_Splitter_X, 25 * $DPI, $Debug_Log_Redo_Button, 25 * $DPI)


	If $Toggle_rightside = 0 Then _Add_control_to_Splitter($Studiofenster, $Scripttree_title, $Right_Splitter_X, -1, $Abgrenzung_nach_toolbar, $hTreeview2_searchinput)
	If $Toggle_rightside = 0 Then GUICtrlSetPos($Skriptbaum_Einstellungen_Button, $windowsize[0] - ((25 * $DPI) + $Titel_DPI_Dif), 0, 0, 0)
	If $Toggle_rightside = 0 Then GUICtrlSetPos($Skriptbaum_Aktualisieren_Button, $windowsize[0] - ((50 * $DPI) + $Titel_DPI_Dif + $Titel_DPI_Dif), 0, 0, 0)


	If $Toggle_rightside = 0 Then _Add_control_to_Splitter($Studiofenster, $hTreeview2_searchinput, $Right_Splitter_X, $Skriptbaum_Aktualisieren_Button, $Scripttree_title, $hTreeview2)
	If $Toggle_rightside = 0 Then _Add_control_to_Splitter($Studiofenster, $Skriptbaum_Aktualisieren_Button, $hTreeview2_searchinput, $Skriptbaum_Einstellungen_Button, $Scripttree_title, $hTreeview2)
	If $Toggle_rightside = 0 Then _Add_control_to_Splitter($Studiofenster, $Skriptbaum_Einstellungen_Button, $Skriptbaum_Aktualisieren_Button, -1, $Scripttree_title, $hTreeview2)

	If $Toggle_rightside = 0 Then _Add_control_to_Splitter($Studiofenster, $hTreeview2, $Right_Splitter_X, -1, $hTreeview2_searchinput, $Abgrenzung_vor_statusbar)
	;...und lasse danach die Splitter selbst Teil des Systems sein (Wichtig!)
	If $Toggle_Leftside = 0 Then _Add_control_to_Splitter($Studiofenster, $Left_Splitter_Y, -1, $Left_Splitter_X, $hTreeView, $QuickView_title)
	If $Toggle_Leftside = 0 Then _Add_control_to_Splitter($Studiofenster, $Left_Splitter_X, $Projecttree_title, $htab, $Abgrenzung_nach_toolbar, $Abgrenzung_vor_statusbar)
	_Add_control_to_Splitter($Studiofenster, $Middle_Splitter_Y, $Left_Splitter_X, $Right_Splitter_X, $htab, $Debug_log)
	If $Toggle_rightside = 0 Then _Add_control_to_Splitter($Studiofenster, $Right_Splitter_X, $htab, $Scripttree_title, $Abgrenzung_nach_toolbar, $Abgrenzung_vor_statusbar)

	_QuickView_GUI_nach_Dummycontrol_ausrichten()



	;Das Plugin bzw. den Skripteditor an die Fenstergröße anpassen
	If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return
	If Not $Offenes_Projekt = "" Then
		$tabsize = ControlGetPos($Studiofenster, "", $htab)
		$htab_wingetpos_array = WinGetPos(GUICtrlGetHandle($htab))
		If _GUICtrlTab_GetItemCount($htab) > 0 Then
			If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then
				;Scintilla
				$y = $tabsize[1] + $Tabseite_hoehe
				$x = $tabsize[0] + 4
			Else
				;Plugin
				$y = $htab_wingetpos_array[1] + $Tabseite_hoehe
				$x = $htab_wingetpos_array[0] + 4
			EndIf

			WinMove($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "", $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4)
			$plugsize = WinGetPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
			If IsArray($plugsize) Then WinMove($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", 0, 0, $plugsize[2], $plugsize[3])
;~ 		sleep(100)
;~ 		_plugin_send_msg($Plugin_Handle[_GUICtrlTab_GetCurFocus($hTab)], "resize") ;sende resize Befehl an Plugin
		EndIf
	EndIf

EndFunc   ;==>_Aktualisiere_Splittercontrols


; #FUNCTION# ;===============================================================================
;
; Name...........: _Add_control_to_Splitter
; Description ...: Fügt ein beliebiges Control in ein Splittersystem ein. Dabei müssen jeweils die Handles der Splitter angegeben werden
; Syntax.........: _Add_control_to_Splitter($control, $splitter_left, $splitter_right, $splitter_top, $splitter_down)
; Parameters ....: $hgui				- Handle zum GUI Fenster in dem sich die Controls und Splitter befinden
;                  $control				- Handle zum Control welches in das Splittersystem eingefügt werden soll
;                  $splitter_left		- Handle zum nächstgelegenen linken Splitter (Bei -1 wird der linke GUI-Rand verwendet)
;                  $splitter_right		- Handle zum nächstgelegenen rechten Splitter (Bei -1 wird der rechte GUI-Rand verwendet)
;                  $splitter_top		- Handle zum nächstgelegenen Splitter über dem Control (Bei -1 wird der obere GUI-Rand verwendet)
;                  $splitter_down		- Handle zum nächstgelegenen Splitter unter dem Control (Bei -1 wird der untere GUI-Rand verwendet)
; Return values .: 1 - Erfolg
;                  0 - Control konnte nicht in das Splittersystem integriert werden
; Author ........: ISI360
; Modified.......:
; Remarks .......: Kann auch zum Aktualisieren der Positionen eines Controls genutzt werden (zb. durch _move_Splitter())
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Add_control_to_Splitter($hGUI = "", $control = "", $splitter_left = -1, $splitter_right = -1, $splitter_top = -1, $splitter_down = -1)
	If $hGUI = "" Then Return 0 ;error
	If $control = "" Then Return 0 ;error

	;Definiere verwendete Variablen
	Local $position_splitter_links
	Local $position_splitter_rechts
	Local $position_splitter_unten
	Local $position_splitter_oben
	Local $x
	Local $y
	Local $breite
	Local $hoehe

	;Hole Positionen von den angegebenen Splittern und der GUI
	;splitter/guirand links
	If $splitter_left <> -1 Then
		$position_splitter_links = ControlGetPos($hGUI, "", $splitter_left)
	Else
		$position_splitter_links = WinGetClientSize($hGUI, "")
	EndIf

	;splitter/guirand rechts
	If $splitter_right <> -1 Then
		$position_splitter_rechts = ControlGetPos($hGUI, "", $splitter_right)
	Else
		$position_splitter_rechts = WinGetClientSize($hGUI, "")
	EndIf

	;splitter/guirand oben
	If $splitter_top <> -1 Then
		$position_splitter_oben = ControlGetPos($hGUI, "", $splitter_top)
	Else
		$position_splitter_oben = WinGetClientSize($hGUI, "")
	EndIf

	;splitter/guirand unten
	If $splitter_down <> -1 Then
		$position_splitter_unten = ControlGetPos($hGUI, "", $splitter_down)
	Else
		$position_splitter_unten = WinGetClientSize($hGUI, "")
	EndIf

	;Berechene Positionen
	;x
	If IsArray($position_splitter_links) Then
		If $splitter_left <> -1 Then
			$x = $position_splitter_links[0] + $position_splitter_links[2] + $Splitter_Rand
		Else
			$x = $Splitter_Rand
		EndIf
	EndIf

	;y
	If IsArray($position_splitter_oben) Then
		If $splitter_top <> -1 Then
			$y = $position_splitter_oben[1] + $position_splitter_oben[3] + $Splitter_Rand
		Else
			$y = $Splitter_Rand
		EndIf
	EndIf

	;breite
	If IsArray($position_splitter_rechts) Then
		$breite = ($position_splitter_rechts[0] - $x) - $Splitter_Rand
	Else
		If $splitter_right <> -1 Then $breite = $splitter_right
	EndIf

	;höhe
	If IsArray($position_splitter_unten) Then
		$hoehe = ($position_splitter_unten[1] - $y) - $Splitter_Rand
	Else
		If $splitter_down <> -1 Then $hoehe = $splitter_down
	EndIf

	;Setze neue Positionen für das Control
	If GUICtrlSetPos($control, $x, $y, $breite, $hoehe) = 0 Then
		WinMove($control, "", $x, $y, $breite, $hoehe)
	EndIf

	;Fertig ;)
	Return 1
EndFunc   ;==>_Add_control_to_Splitter

; #FUNCTION# ;===============================================================================
;
; Name...........: _move_Splitter
; Description ...: Verschiebt durch gedrückthalten der linken Maustaste einen Splitter
; Syntax.........: _move_Splitter()
; Parameters ....: Keine
; Return values .: 1 - Erfolg
;                  0 - Fehler
; Author ........: ISI360
; Modified.......:
; Remarks .......: Muss durch eine GUICtrlSetOnEvent funktion aufgerufen werden
;                  Erkennt automatisch ob es sich bei dem Splitter um einen Horizontalen oder Vertikalen Splitter handelt
;                  Erkennt automatisch die Controls (dank dllcall) die den Splitter betreffen und achtet auf die Minimalgröße ($Splitter_Minimale_Groesse)
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _move_Splitter()
	If @GUI_CtrlId = "" Then Return 0
	If @GUI_WinHandle = "" Then Return 0
	_Write_ISN_Debug_Console("Moving a GUI splitter...", 1, 0)
	;Definiere verwendete Variablen
	Local $position_splitter
	Local $Position_Maus1
	Local $Position_Maus2
	Local $x_Differenz
	Local $y_Differenz
	Local $x
	Local $y
	Local $breite
	Local $hoehe
	Local $handle_element_oben
	Local $position_element_oben
	Local $handle_element_unten
	Local $position_element_unten
	Local $handle_element_rechts
	Local $position_element_rechts
	Local $handle_element_links
	Local $position_element_links

	$position_fenster = WinGetPos(@GUI_WinHandle) ;aktuelle Position des Fensters
	$position_fenster_clientsize = WinGetClientSize(@GUI_WinHandle) ;Clientsize des aktuellen fensters
	$position_splitter = ControlGetPos(@GUI_WinHandle, "", @GUI_CtrlId) ;aktuelle Position des Splitters
	$Position_Maus1 = MouseGetPos() ;hole mausposition
	$x_Differenz = $Position_Maus1[0] - $position_splitter[0] ;x differenz vom control zur mausposition
	$y_Differenz = $Position_Maus1[1] - $position_splitter[1] ;y differenz vom control zur mausposition

	While _IsPressed('01', $user32)
		$Position_Maus1 = MouseGetPos() ;hole mausposition
		Sleep(10) ;warte ganz kurz...
		$Position_Maus2 = MouseGetPos() ;hole 2. mausposition
		If ($Position_Maus1[0] <> $Position_Maus2[0]) Or ($Position_Maus1[1] <> $Position_Maus2[1]) Then ;falls sich mauszeiger bewegt hat...

			If $position_splitter[3] > $position_splitter[2] Then ;prüfe ob es sich um einen horizontalen oder vertikalen splitter handelt
				$x = $Position_Maus1[0] - $x_Differenz
				$y = $position_splitter[1]
				If $x < $Splitter_Rand Then $x = $Splitter_Rand ;falls splitter aus der GUI wandert
				If $x > $position_fenster_clientsize[0] Then $x = $position_fenster_clientsize[0] - $Splitter_Rand ;falls splitter aus der GUI wandert

				;Prüfe welches Control sich links und rechts neben dem Splitter befindet und prüfe desen größe...
				$position_splitter = ControlGetPos(@GUI_WinHandle, "", @GUI_CtrlId) ;aktuelle Position des Splitters
				$handle_element_links = DllCall("user32.dll", "hwnd", "WindowFromPoint", "int", ($position_fenster[0] + $position_splitter[0]) - ($Splitter_Rand + 50), "int", $position_fenster[1] + $position_splitter[1] + $Splitter_Rand + 50) ;suche control nach x und y koordinaten
				$position_element_links = ControlGetPos(@GUI_WinHandle, "", $handle_element_links[0]) ;aktuelle Position des linken Elements des Splitters
				$handle_element_rechts = DllCall("user32.dll", "hwnd", "WindowFromPoint", "int", ($position_fenster[0] + $position_splitter[0]) - ($Splitter_Rand - 50), "int", $position_fenster[1] + $position_splitter[1] + $Splitter_Rand + 50) ;suche control nach x und y koordinaten
				$position_element_rechts = ControlGetPos(@GUI_WinHandle, "", $handle_element_rechts[0]) ;aktuelle Position des rechteb Elements des Splitters
				If IsArray($position_element_links) Then
					If $x - ($position_element_links[0]) < $Splitter_Minimale_Groesse Then $x = $position_splitter[0]
				EndIf
				If IsArray($position_element_rechts) Then
					If ($position_element_rechts[0] + $position_element_rechts[2]) - $x < $Splitter_Minimale_Groesse Then $x = $position_splitter[0]
				EndIf

				GUICtrlSetPos(@GUI_CtrlId, $x, $y, $Splitter_Breite) ;setze Splitterposition für vertikalen Splitter
			Else
				$x = $position_splitter[0]
				$y = $Position_Maus1[1] - $y_Differenz
				If $y < $Splitter_Rand Then $y = $Splitter_Rand ;falls splitter aus der GUI wandert
				If $y > $position_fenster_clientsize[1] Then $y = $position_fenster_clientsize[1] - $Splitter_Rand ;falls splitter aus der GUI wandert

				;Prüfe welches Control sich ober und unterhalb dem Splitter befindet und prüfe desen größe...
				$position_splitter = ControlGetPos(@GUI_WinHandle, "", @GUI_CtrlId) ;aktuelle Position des Splitters
				$handle_element_oben = DllCall("user32.dll", "hwnd", "WindowFromPoint", "int", $position_fenster[0] + $position_splitter[0] + ($position_splitter[2] / 2), "int", ($position_fenster[1] + ($position_fenster[3] - $position_fenster_clientsize[1]) + $position_splitter[1]) - 50) ;suche control nach x und y koordinaten
				$position_element_oben = ControlGetPos(@GUI_WinHandle, "", $handle_element_oben[0]) ;aktuelle Position des oberen Elements des Splitters
				$handle_element_unten = DllCall("user32.dll", "hwnd", "WindowFromPoint", "int", $position_fenster[0] + $position_splitter[0] + ($position_splitter[2] / 2), "int", ($position_fenster[1] + ($position_fenster[3] - $position_fenster_clientsize[1]) + $position_splitter[1]) + 50) ;suche control nach x und y koordinaten

				If @GUI_CtrlId = $Left_Splitter_Y Then $handle_element_unten[0] = $QuickView_Dummy_Control ;Ausnahme für das QuickView Fenster des ISN

				$position_element_unten = ControlGetPos(@GUI_WinHandle, "", $handle_element_unten[0]) ;aktuelle Position des unteren Elements des Splitters
				If IsArray($position_element_oben) Then
					If $y - $position_element_oben[1] < $Splitter_Minimale_Groesse Then $y = $position_splitter[1]
				EndIf
				If IsArray($position_element_unten) Then
					If ($position_element_unten[1] + $position_element_unten[3]) - $y < $Splitter_Minimale_Groesse Then $y = $position_splitter[1]
				EndIf

				GUICtrlSetPos(@GUI_CtrlId, $x, $y, $position_splitter[2], $Splitter_Breite) ;setze Splitterposition für horizontalen Splitter
			EndIf
			_Aktualisiere_Splittercontrols() ;aktualisiere die Controls und andere Splitter beim bewegen des Splitters
		EndIf
	WEnd
	_QuickView_GUI_Resize()
	_Aktualisiere_Splittercontrols() ;Finale aktualisierung
	_Redraw_Window() ;Speichern der aktellen Werte der Splitter
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
	Return 1 ;Fertig
EndFunc   ;==>_move_Splitter

Func _Colour_Calltipp_Set_State($state)
	If $state = "show" Then
		$aktuelle_pos_SCE_Window = WinGetPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		$aktuelle_pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		$x = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_POINTXFROMPOSITION, 0, $aktuelle_pos) + $aktuelle_pos_SCE_Window[0]
		$y = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_POINTYFROMPOSITION, 0, $aktuelle_pos) + $aktuelle_pos_SCE_Window[1] + 50
		WinMove($mini_farb_picker_GUI, "", $x, $y) ;bewege den colour picker an die cursor stelle
		GUISetState(@SW_SHOWNOACTIVATE, $mini_farb_picker_GUI)
	Else
		GUISetState(@SW_HIDE, $mini_farb_picker_GUI)
	EndIf
EndFunc   ;==>_Colour_Calltipp_Set_State



Func _Detailinfos_ausblenden()
	$Detailinfos_GUIstate = WinGetState($Detailinfos_zu_aktuellem_Wort_GUI, "")
	If BitAND($Detailinfos_GUIstate, 2) Then GUISetState(@SW_HIDE, $Detailinfos_zu_aktuellem_Wort_GUI)
EndFunc   ;==>_Detailinfos_ausblenden



Func _Zeige_Detailinfos_zu_aktuellem_Wort($wort = "")
	If $wort <> "" Then
		If StringInStr($wort, "0x") And StringLen($wort) = 8 Then ;Courser ist in einem Farbwert
			$aktuelle_pos_SCE_Window = WinGetPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
			$aktuelle_pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
			$x = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_POINTXFROMPOSITION, 0, $aktuelle_pos) + $aktuelle_pos_SCE_Window[0] - 70
			$y = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_POINTYFROMPOSITION, 0, $aktuelle_pos) + $aktuelle_pos_SCE_Window[1] - 20
			GUICtrlSetData($Detailinfos_zu_aktuellem_Wort_Label, $wort)
			GUICtrlSetBkColor($Detailinfos_zu_aktuellem_Wort_Label, $wort)
			GUICtrlSetColor($Detailinfos_zu_aktuellem_Wort_Label, _ColourInvert(Execute($wort)))
			WinMove($Detailinfos_zu_aktuellem_Wort_GUI, "", $x, $y) ;bewege den colour picker an die cursor stelle
			GUISetState(@SW_SHOWNOACTIVATE, $Detailinfos_zu_aktuellem_Wort_GUI)
			Return
		EndIf
	EndIf
	_Detailinfos_ausblenden()
EndFunc   ;==>_Zeige_Detailinfos_zu_aktuellem_Wort



Func _Sci_show_last_Calltipp()
	;Zeige Calltipp wieder an (falls intelisense aktiv ist)
	If $disableintelisense = "false" Then
		SendMessageString($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CALLTIPSHOW, $SCIE_letzte_pos, $SCIE_letzter_calltipp)

		;by isi360
		$linee = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])))
		StringReplace($linee, ",", "")
		$SCI_hlStart = StringInStr($SCI_sCallTip, ",", 0, @extended)

		Local $iTemp = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ",") + $SCI_hlStart
		If StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart < $iTemp Or $iTemp - $SCI_hlStart = 0 Then
			$SCI_hlEnd = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart
		Else
			$SCI_hlEnd = $iTemp
		EndIf
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CALLTIPSETHLT, $SCI_hlStart, $SCI_hlEnd)
	EndIf

EndFunc   ;==>_Sci_show_last_Calltipp

Func _Mini_Farbpicker_waehle_farbe()
	Sci_InsertText($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), "0x" & Hex(GUICtrlGetBkColor(@GUI_CtrlId), 6))
	_Colour_Calltipp_Set_State("hide")
	_WinAPI_SetFocus($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) + 8)
	_Sci_show_last_Calltipp()
EndFunc   ;==>_Mini_Farbpicker_waehle_farbe

Func _Mini_Farbpicker_waehle_eigene_farbe()
	$Farbe = _ColorChooserDialog(0xFFFFFF, $Studiofenster)
	If $Farbe > -1 Then
		Sci_InsertText($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), "0x" & Hex($Farbe, 6))
		Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) + 8)
		_WinAPI_SetFocus($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		_Sci_show_last_Calltipp()
	EndIf
EndFunc   ;==>_Mini_Farbpicker_waehle_eigene_farbe

Func _ist_windows_vista_oder_hoeher()
	Switch @OSVersion
		Case "WIN_2000", "WIN_2003", "WIN_XP", "WIN_XPe"
			Return 0
	EndSwitch
	Return 1
EndFunc   ;==>_ist_windows_vista_oder_hoeher

Func _CreateBitmapFromIcon($iBackground, $sIcon, $iIndex, $iWidth, $iHeight)
	Local $hDC = _WinAPI_GetDC(0)
	Local $hBackDC = _WinAPI_CreateCompatibleDC($hDC)
	$iBackground = BitAND(BitShift($iBackground, -16) + BitAND($iBackground, 0xFF00) + BitShift($iBackground, 16), 0xFFFFFF)
	Local $hBitmap = _WinAPI_CreateSolidBitmap(0, $iBackground, $iWidth, $iHeight)
	Local $hBackSv = _WinAPI_SelectObject($hBackDC, $hBitmap)
	Local $hIcon = _WinAPI_ShellExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
	If Not @error Then
		_WinAPI_DrawIconEx($hBackDC, 0, 0, $hIcon, 0, 0, 0, 0, 0x0003)
		_WinAPI_DestroyIcon($hIcon)
	EndIf
	_WinAPI_SelectObject($hBackDC, $hBackSv)
	_WinAPI_ReleaseDC(0, $hDC)
	_WinAPI_DeleteDC($hBackDC)
	Return $hBitmap
EndFunc   ;==>_CreateBitmapFromIcon

; Diese Funktion u¨berschreibt das Standart Kontextmenu¨ mit unserm Dummy Menu¨ (Quelle US Autoit Forum)

Func Show_KontextMenu($hWnd, $nContextID)
	Local $hMenu = GUICtrlGetHandle($nContextID)
	$arPos = MouseGetPos()
	Local $x = $arPos[0]
	Local $y = $arPos[1]
;~ 	If $Y > 740 Then $Y = 730
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)

EndFunc   ;==>Show_KontextMenu




; #FUNCTION# ;===============================================================================
;
; Name...........: _Pruefe_Hotkey
; Description ...: Prüft ob eine oder mehrere Tasten gedrückt sind oder nicht
; Syntax.........: _Pruefe_Hotkey($keycode)
; Parameters ....: $keycode			- Welche Tasten sollen geprüft werden (Für mehrere Tsten zb: 11+58+22)
; Return values .: true				- Taste/Tasten ist/sind gedrückt
;                  False			- Taste/Tasten ist/sind nicht gedrückt
; Author ........: ISI360
; Modified.......:
; Remarks .......: Eine kleine erweiterte _ispressed-Funktion die es erlaubt via Keycode (zb: 11+58+22) mehrere Tastenkombinationen (bis zu 4 Tasten) abzufragen
;                  Wird benötigt da ab ISN AutoIt Studio 0.9 BETA der User selbst die Hotkeys definieren kann
;                  Werden mehr als 4 Tasten angegeben wird automatisch "false" zurückgegeben
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Pruefe_Hotkey($keyCode = "")
	If $keyCode = "" Then Return False
	$array = StringSplit($keyCode, "+", 2)
	If Not IsArray($array) Then Return False

	;Alt Gr/STRG Bugfix
	If Not StringInStr($keyCode, "11") And _IsPressed("11", $user32) Then Return False
	If Not StringInStr($keyCode, "12") And _IsPressed("12", $user32) Then Return False

	;Shift Bugfix
	If Not StringInStr($keyCode, "10") And _IsPressed("10", $user32) Then Return False

	;Windows Keys Bugfix
	If Not StringInStr($keyCode, "5B") And _IsPressed("5B", $user32) Then Return False
	If Not StringInStr($keyCode, "5C") And _IsPressed("5C", $user32) Then Return False

	;Eine Taste
	If UBound($array) - 1 = 0 Then
		If _IsPressed($array[0], $user32) Then
			$Letzter_Hotkey = $keyCode
			Return True
		Else
			Return False
		EndIf
	EndIf

	;Zwei Tasten
	If UBound($array) - 1 = 1 Then
		If _IsPressed($array[0], $user32) And _IsPressed($array[1], $user32) Then
			$Letzter_Hotkey = $keyCode
			Return True
		Else
			Return False
		EndIf
	EndIf

	;Drei Tasten
	If UBound($array) - 1 = 2 Then
		If _IsPressed($array[0], $user32) And _IsPressed($array[1], $user32) And _IsPressed($array[2], $user32) Then
			$Letzter_Hotkey = $keyCode
			Return True
		Else
			Return False
		EndIf
	EndIf

	;Vier Tasten
	If UBound($array) - 1 = 3 Then
		If _IsPressed($array[0], $user32) And _IsPressed($array[1], $user32) And _IsPressed($array[2], $user32) And _IsPressed($array[3], $user32) Then
			$Letzter_Hotkey = $keyCode
			Return True
		Else
			Return False
		EndIf
	EndIf

	;Alles darüber -> return false
	Return False
EndFunc   ;==>_Pruefe_Hotkey



; #FUNCTION# ;===============================================================================
;
; Name...........: _ISN_setze_Hotkey
; Description ...: Registriert einen ISN Hotkey Code für die Hotkey UDF
; Syntax.........:  $ISN_Keycode = Der zu registrierende ISN Hotkey (zb. 11+10+26)
;					$ISN_Function = Funktion die beim drücken der Taste aufgerufen wird
;					$Hotkey_Flags = Flags für den Hotkey.
;					$Hotkey_GUI = Für welche GUI sollen die Hotkeys gelten. 0 = gesamtes ISN.
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird durch "_ISN_aktualisiere_Hotkeys" aufgerufen
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _ISN_setze_Hotkey($ISN_Keycode = "", $ISN_Function = "", $Hotkey_Flags = "", $Hotkey_GUI = 0)
	If $ISN_Keycode = "" Then Return ;Hotkey wird nicht verwendet
	If $ISN_Function = "" Then Return ;Hotkey wird nicht verwendet

	Local $flags = $HK_FLAG_NOBLOCKHOTKEY + $HK_FLAG_NOREPEAT + $HK_FLAG_NOOVERLAPCALL ;Default Flags für Hotkeys
	If $Hotkey_Flags <> "" Then $flags = $Hotkey_Flags


	;ISN Hotkey Code für UDF umwandeln
	Local $Hotkey_Split = StringSplit($ISN_Keycode, "+", 2)
	If Not IsArray($Hotkey_Split) Then Return
	For $x = 0 To UBound($Hotkey_Split) - 1
		Switch $Hotkey_Split[$x]

			Case "11" ;STRG
				$Hotkey_Split[$x] = $CK_CONTROL


			Case "10" ;SHIFT
				$Hotkey_Split[$x] = $CK_SHIFT


			Case "12" ;ALT
				$Hotkey_Split[$x] = $CK_ALT


			Case "5B" ;WIN Key
				$Hotkey_Split[$x] = $CK_WIN


			Case "5C" ;WIN Key
				$Hotkey_Split[$x] = $CK_WIN

			Case Else
				$Hotkey_Split[$x] = "0x" & $Hotkey_Split[$x]

		EndSwitch
	Next


	Switch UBound($Hotkey_Split) - 1

		Case 0 ;Eine Taste
			_HotKey_Assign($Hotkey_Split[0], $ISN_Function, $flags, $Hotkey_GUI)

		Case 1 ;Zwei Tasten
			_HotKey_Assign(BitOR($Hotkey_Split[0], $Hotkey_Split[1]), $ISN_Function, $flags, $Hotkey_GUI)

		Case 2 ;Drei Tasten
			_HotKey_Assign(BitOR($Hotkey_Split[0], $Hotkey_Split[1], $Hotkey_Split[2]), $ISN_Function, $flags, $Hotkey_GUI)

		Case 3 ;View Tasten
			_HotKey_Assign(BitOR($Hotkey_Split[0], $Hotkey_Split[1], $Hotkey_Split[2], $Hotkey_Split[3]), $ISN_Function, $flags, $Hotkey_GUI)

	EndSwitch

EndFunc   ;==>_ISN_setze_Hotkey



; #FUNCTION# ;===============================================================================
;
; Name...........: _ISN_aktualisiere_Hotkeys
; Description ...: Registriert alle im ISN verwendeten Hotkeys mit der Hotkey UDF von Yashied
; Syntax.........:  none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Beim aufruf werden alle bereits registrierten Hotkeys entfernt und neu registriert. (zb. beim Speichern der Programmeinstellungen)
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _ISN_aktualisiere_Hotkeys()
	_HotKey_Release() ;Alle bisher registrierten Hotkeys freigeben

	_ISN_setze_Hotkey($Hotkey_Keycode_vollbild, "_Toggle_Fulscreen") ;Vollbild
	_ISN_setze_Hotkey($Hotkey_Keycode_Testprojekt, "_ISN_Projekt_Testen") ;Projekt Testen
	_ISN_setze_Hotkey($Hotkey_Keycode_Testprojekt_ohne_Parameter, "_ISN_Projekt_Testen_ohne_Parameter") ;Projekt Testen (Ohne Parameter)
	_ISN_setze_Hotkey($Hotkey_Keycode_Neue_Datei, "_Show_new_Filgui_au3") ;Neue Datei erstellen
	_ISN_setze_Hotkey($Hotkey_Keycode_Zeile_nach_oben_verschieben, "_Markierte_Zeile_nach_oben_verschieben", $HK_FLAG_NOBLOCKHOTKEY + $HK_FLAG_NOOVERLAPCALL) ;Zeile nach oben verschieben
	_ISN_setze_Hotkey($Hotkey_Keycode_Zeile_nach_unten_verschieben, "_Markierte_Zeile_nach_unten_verschieben", $HK_FLAG_NOBLOCKHOTKEY + $HK_FLAG_NOOVERLAPCALL) ;Zeile nach unten verschieben
	_ISN_setze_Hotkey($Hotkey_Keycode_Oeffnen, "_Try_to_open_external_file") ;Externe Datei öffnen
	_ISN_setze_Hotkey($Hotkey_Keycode_Farbtoolbox, "_Toggle_colourpicker") ;Farbtoolbox
	_ISN_setze_Hotkey($Hotkey_Keycode_Fensterinfotool, "_open_windowinfotool") ;Fenster Info Tool
	_ISN_setze_Hotkey($Hotkey_Keycode_Bitrechner, "_Toggle_Bitoperation_rechner") ;Bitrechner
	_ISN_setze_Hotkey($Hotkey_Keycode_Automatisches_Backup, "_Backup_Files") ;Automatisches backup
	_ISN_setze_Hotkey($Hotkey_Keycode_Aenderungsprotokolle, "_Zeige_changelogmanager") ;Änderungsprotokolle
	_ISN_setze_Hotkey($Hotkey_Keycode_In_Dateien_Suchen, "_Toggle_In_Dateien_Suchen") ;In Dateien Suchen
	_ISN_setze_Hotkey($Hotkey_Keycode_compile, "_Start_Compiling") ;Kompilieren
	_ISN_setze_Hotkey($Hotkey_Keycode_compile_Settings, "_Show_Compile") ;Kompilieren Einstellungen
	_ISN_setze_Hotkey($Hotkey_Keycode_Datei_umbenennen, "_Rename_File") ;Datei/ordner umbenennen
	_ISN_setze_Hotkey($Hotkey_PElock_Obfuscator, "_Toggle_PELock_GUI") ;PELock Obfuscator
	_ISN_setze_Hotkey($Hotkey_Keycode_Speichern_Alle_Tabs, "_Save_All_tabs") ;Speichern (alle Tabs)
	_ISN_setze_Hotkey($Hotkey_Keycode_Speichern_unter, "_Speichern_unter") ;Speichern unter...
	_ISN_setze_Hotkey($Hotkey_Keycode_AutoIt3WrapperGUI, "_Zeige_AutoIt3Wrapper_GUI") ;AutoIt3WrapperGUI
	_ISN_setze_Hotkey($Hotkey_Keycode_vorheriger_tab, "_Select_previous_tab") ;previous tab
	_ISN_setze_Hotkey($Hotkey_Keycode_naechster_tab, "_Select_next_tab") ;next tab
	_ISN_setze_Hotkey($Hotkey_Keycode_befehlhilfe, "_open_helpfile_keyword") ;Befehlhilfe
	_ISN_setze_Hotkey($Hotkey_Keycode_auskommentieren, "_comment_out") ;comment_out
	_ISN_setze_Hotkey($Hotkey_Keycode_springezuzeile, "GoToLine") ;gotoline
	_ISN_setze_Hotkey($Hotkey_Keycode_msgBoxGenerator, "_Toggle_msgboxcreator") ;Msgbox generator
	_ISN_setze_Hotkey($Hotkey_Keycode_zeile_duplizieren, "_Zeile_Duplizieren") ;Zeile Duplizieren
	_ISN_setze_Hotkey($Hotkey_Keycode_debugtomsgbox, "_Debug_to_msgbox") ;Debug zu MsgBox
	_ISN_setze_Hotkey($Hotkey_Keycode_debugtoconsole, "_Debug_to_console") ;Debug zu console
	_ISN_setze_Hotkey($Hotkey_Keycode_erstelleUDFheader, "_Erstelle_UDF_Header") ;Erstelle UDF Header
	_ISN_setze_Hotkey($Hotkey_Keycode_unteres_fenster_umschalten, "_Toggle_Fenster_unten") ;Unteres Fenster umschalten
	_ISN_setze_Hotkey($Hotkey_Keycode_linkes_fenster_umschalten, "_Toggle_hide_leftbar") ;Linkes Fenster umschalten
	_ISN_setze_Hotkey($Hotkey_Keycode_rechtes_fenster_umschalten, "_Toggle_hide_rightbar") ;Rechtes Fenster umschalten
	_ISN_setze_Hotkey($Hotkey_Keycode_Springe_zu_Func, "_Springe_zu_Func") ;Springe zu Funktion
	_ISN_setze_Hotkey($Hotkey_Keycode_Springe_zu_Func_zurueck, "_Springe_zu_Func_zurueck") ;Springe zu ausgangsposition zurück
	_ISN_setze_Hotkey($Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden, "_SCI_Kommentare_ausblenden_bzw_einblenden") ;Kommentare ausblenden / Einblenden
	_ISN_setze_Hotkey($Hotkey_Zeile_Bookmarken, "_Zeile_Bookmarken") ;Zeile Bookmarken
	_ISN_setze_Hotkey($Hotkey_Zeile_Bookmarken_Naechstes_Bookmark, "_Springe_zum_naechsten_Bookmarks") ;Bookmarken nächster Bookmark
	_ISN_setze_Hotkey($Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark, "_Springe_zur_vorherigen_Bookmarks") ;Bookmarken vorheriger Bookmark
	_ISN_setze_Hotkey($Hotkey_Zeile_Bookmarken_alle_loeschen, "_Alle_Bookmarks_entfernen") ;Bookmarken Bookmarks löschen
	_ISN_setze_Hotkey($Hotkey_Keycode_zeigefehler, "_Find_Error_F4") ;finderror
	_ISN_setze_Hotkey($Hotkey_Keycode_testeskript, "_ISN_Skript_Testen") ;Skript Testen
	_ISN_setze_Hotkey($Hotkey_Keycode_Oeffne_Include, "_Try_to_open_include_hotkey") ;Öffne markiertes Include
	_ISN_setze_Hotkey($Hotkey_Keycode_Weitersuchen, "_Hotkey_vorwaerts_suchen") ;Weitersuchen
	_ISN_setze_Hotkey($Hotkey_Keycode_Rueckwaerts_Weitersuchen, "_Hotkey_Rueckwaerts_suchen") ;Rückwärts Weitersuchen
	_ISN_setze_Hotkey($Hotkey_Keycode_tab_schliessen, "_ISN_Aktuellen_Tab_schliessen") ;Tab schließen
	_ISN_setze_Hotkey($Hotkey_Keycode_Tidy, "_ISN_Tidy_aktuellen_Tab") ;Tidy
	_ISN_setze_Hotkey($Hotkey_Keycode_Makroslot1, "_ISN_execute_macroslot_01") ;Makroslot 1
	_ISN_setze_Hotkey($Hotkey_Keycode_Makroslot2, "_ISN_execute_macroslot_02") ;Makroslot 2
	_ISN_setze_Hotkey($Hotkey_Keycode_Makroslot3, "_ISN_execute_macroslot_03") ;Makroslot 3
	_ISN_setze_Hotkey($Hotkey_Keycode_Makroslot4, "_ISN_execute_macroslot_04") ;Makroslot 4
	_ISN_setze_Hotkey($Hotkey_Keycode_Makroslot5, "_ISN_execute_macroslot_05") ;Makroslot 5
	_ISN_setze_Hotkey($Hotkey_Keycode_Makroslot6, "_ISN_execute_macroslot_06") ;Makroslot 6
	_ISN_setze_Hotkey($Hotkey_Keycode_Makroslot7, "_ISN_execute_macroslot_07") ;Makroslot 7
	_ISN_setze_Hotkey($Hotkey_Keycode_syntaxcheck, "_ISN_Syntaxcheck_aktuellen_Tab") ;Syntaxcheck
	_ISN_setze_Hotkey($Hotkey_Keycode_Speichern, "_ISN_aktuellen_Tab_speichern") ;Speichern
	_ISN_setze_Hotkey($Hotkey_Keycode_Suche, "_Show_Search") ;Suche
	_ISN_setze_Hotkey("11+56", "_Hotkey_Scintilla_Paste_func",$HK_FLAG_NOBLOCKHOTKEY + $HK_FLAG_NOOVERLAPCALL) ;STRG+V (Einfügen) für Scintilla Controls

	If $Tools_Parameter_Editor_aktiviert = "true" Then
		_ISN_setze_Hotkey($Hotkey_Keycode_Parameter_Editor, "_Parameter_Editor_Contextmenue") ;Parameter Editor
		_ISN_setze_Hotkey($Hotkey_Keycode_Parameter_Editor_alle_Parameter_leeren, "_Parameter_Editor_Alle_Parameter_leeren", "", $ParameterEditor_GUI) ;Alle Parameter Leeren
		_ISN_setze_Hotkey($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_leeren, "_Parameter_Editor_Markierten_Parameter_leeren", "", $ParameterEditor_GUI) ;Gewählten Parameter leeren
		_ISN_setze_Hotkey($Hotkey_Keycode_Parameter_Editor_naechster_Parameter, "_Parameter_Editor_Listview_select_nextrow", "", $ParameterEditor_GUI) ;Nächster Parameter
		_ISN_setze_Hotkey($Hotkey_Keycode_Parameter_Editor_neuer_Parameter, "_Parameter_Editor_Parameter_hinzufuegen", "", $ParameterEditor_GUI) ;Neuen Parameter Hinzufügen
		_ISN_setze_Hotkey($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_loeschen, "_Parameter_Editor_Parameter_entfernen", "", $ParameterEditor_GUI) ;Parameter löschen
	EndIf


	_Aktualisiere_Texte_in_Contextmenues_wegen_Hotkeys()
	_HotKey_Enable() ;Hotkeys aktivieren
EndFunc   ;==>_ISN_aktualisiere_Hotkeys




; #FUNCTION# ;===============================================================================
;
; Name...........: _Keycode_zu_Text
; Description ...: Wandelt einen Keycode (zb. 11+58) in einen für den User leicht lesbaren Text um -> zb. "STRG+X"
; Syntax.........: _Keycode_zu_Text($keycode)
; Parameters ....: $keycode			- Welcher Keycode soll umgewandelt werden
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird in den Programmeinstellungen benötigt
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Keycode_zu_Text($keyCode = "")
	If $keyCode = "" Then Return ""
	$array = StringSplit($keyCode, "+", 2)
	For $Index = 0 To UBound($array) - 1
		$text = Chr(Dec($array[$Index]))
		If $array[$Index] = "11" Then $text = "Ctrl"
		If $array[$Index] = "12" Then $text = "Alt"
		If $array[$Index] = "10" Then $text = "Shift"
		If $array[$Index] = "DC" Then $text = _Get_langstr(1021) ;"Zirkumflex"
		If $array[$Index] = "09" Then $text = "TAB"
		If $array[$Index] = "70" Then $text = "F1"
		If $array[$Index] = "71" Then $text = "F2"
		If $array[$Index] = "72" Then $text = "F3"
		If $array[$Index] = "73" Then $text = "F4"
		If $array[$Index] = "74" Then $text = "F5"
		If $array[$Index] = "75" Then $text = "F6"
		If $array[$Index] = "76" Then $text = "F7"
		If $array[$Index] = "77" Then $text = "F8"
		If $array[$Index] = "78" Then $text = "F9"
		If $array[$Index] = "79" Then $text = "F10"
		If $array[$Index] = "7A" Then $text = "F11"
		If $array[$Index] = "7B" Then $text = "F12"
		If $array[$Index] = "2E" Then $text = "Del"
		If $array[$Index] = "23" Then $text = "End"
		If $array[$Index] = "24" Then $text = "Home"
		If $array[$Index] = "0D" Then $text = "Enter"
		If $array[$Index] = "2C" Then $text = _Get_langstr(882) ;Drucken
		If $array[$Index] = "6D" Then $text = _Get_langstr(1022) ;"Minus am Nummernblock"
		If $array[$Index] = "6F" Then $text = _Get_langstr(1023) ;"Dividieren am Nummernblock"
		If $array[$Index] = "6A" Then $text = _Get_langstr(1024) ;"Multiplizieren am Nummernblock"
		If $array[$Index] = "6B" Then $text = _Get_langstr(1025) ;"Plus am Nummernblock"
		If $array[$Index] = "60" Then $text = "0 " & _Get_langstr(1026)
		If $array[$Index] = "61" Then $text = "1 " & _Get_langstr(1026)
		If $array[$Index] = "62" Then $text = "2 " & _Get_langstr(1026)
		If $array[$Index] = "63" Then $text = "3 " & _Get_langstr(1026)
		If $array[$Index] = "64" Then $text = "4 " & _Get_langstr(1026)
		If $array[$Index] = "65" Then $text = "5 " & _Get_langstr(1026)
		If $array[$Index] = "66" Then $text = "6 " & _Get_langstr(1026)
		If $array[$Index] = "67" Then $text = "7 " & _Get_langstr(1026)
		If $array[$Index] = "68" Then $text = "8 " & _Get_langstr(1026)
		If $array[$Index] = "69" Then $text = "9 " & _Get_langstr(1026)
		If $array[$Index] = "21" Then $text = _Get_langstr(1027) ;"Seite nach oben"
		If $array[$Index] = "22" Then $text = _Get_langstr(1028) ;"Seite nach unten"
		If $array[$Index] = "26" Then $text = _Get_langstr(1017) ;Pfeil oben
		If $array[$Index] = "28" Then $text = _Get_langstr(1018) ;Pfeil unten
		If $array[$Index] = "25" Then $text = _Get_langstr(1019) ;Pfeil links
		If $array[$Index] = "27" Then $text = _Get_langstr(1020) ;Pfeil rechts
		If $array[$Index] = "2D" Then $text = _Get_langstr(112) ;Einfügen (Einfg)
		If $array[$Index] = "5B" Or $array[$Index] = "5C" Then $text = _Get_langstr(1300) ;Windows Logo Taste
		$array[$Index] = $text
	Next
	Return _ArrayToString($array, "+")
EndFunc   ;==>_Keycode_zu_Text

;-----------------------------------------------------------------------------------------------------------------
;    Function       _getKeyKombi()
;
;    Description    Gibt die gedrückte Taste(nkombination) zurück, die gedrückt wurde.
;                    Die Funktion wartet solang, bis mind. eine Taste gedrückt und losgelassen wurde.
;
;    Return         Array mit n Elementen
;                    Array[0]    Anzahl der gedrückten Tasten
;                    Array[1..n]    gedrückte Taste(n) als Hex-Wert (Hex-Werte in Hilfe von _IsPressed() aufgelistet)
;
;     Version        0.1
;
;    Author         zemkedesign (http://www.autoit.de/index.php?page=User&userID=200384)
;-----------------------------------------------------------------------------------------------------------------

Func _getKeyKombi()

	Local $i_keys_pressed_count = 0
	Local $s_keys_pressed = ""
	Local $as_return[1]

	Sleep(300)
	While 1
		;Anzahl und Tasten ermitteln
		$as_array = _getKey($s_keys_pressed)
;~         ConsoleWrite($s_keys_pressed & @CR)
		;neue Taste gedrückt
		If $as_array[0] > $i_keys_pressed_count Then $s_keys_pressed &= $as_array[1]
		;aktuell weniger gedrückt, als im Durchlauf zuvor
		If $as_array[0] < $i_keys_pressed_count Then ExitLoop
		;aktuell gedrückte Tasten zwischenspeichern
		$i_keys_pressed_count = $as_array[0]
	WEnd

	;Rückgabe
	$as_return[0] = $i_keys_pressed_count ;Anzahl gedrückter Tasten
	For $i = 1 To StringLen($s_keys_pressed) Step 2
		_ArrayAdd($as_return, StringMid($s_keys_pressed, $i, 2)) ;Tasten teilen
	Next
	_ArrayDelete($as_return, 0)
	Return $as_return

EndFunc   ;==>_getKeyKombi

;-----------------------------------------------------------------------------------------------------------------
;    Function       _getKey([$s_ignored_keys = ""])
;
;    Description    Gibt die gedrückte Taste zurück, die momentan gedrückt ist.
;                    Ignoriert werden Tasten, die im Parameter gespeichert sind.
;
;    Parameter      optional    $s_ignored_keys: zu ignorierende Tasten
;
;    Return         Erfolg        Array mit zwei Elementen
;                                Array[0]    Anzahl der gedrückten Tasten (ignorierte Tasten werden mitgezählt)
;                                Array[1]    gedrückte Taste (ignorierte Tasten werden nicht zurückgegeben)
;                    Fehler        keine Taste wurde gedrückt
;                                Array[0]    0
;                                Array[1]    Leerstring
;
;     Version        0.1
;
;    Author         zemkedesign (http://www.autoit.de/index.php?page=User&userID=200384)
;-----------------------------------------------------------------------------------------------------------------

Func _getKey($s_ignored_keys = "")

	Local $as_return[2]
	Local $as_keys[81]
	$as_return[0] = 0
	$as_return[1] = ""

	#Region keys
	$as_keys[0] = "10" ;SHIFT
	$as_keys[1] = "11" ;STRG
	$as_keys[2] = "12" ;ALT
	$as_keys[3] = "30" ;0
	$as_keys[4] = "31" ;1
	$as_keys[5] = "32" ;2
	$as_keys[6] = "33" ;3
	$as_keys[7] = "34" ;4
	$as_keys[8] = "35" ;5
	$as_keys[9] = "36" ;6
	$as_keys[10] = "37" ;7
	$as_keys[11] = "38" ;8
	$as_keys[12] = "39" ;9
	$as_keys[13] = "41" ;A
	$as_keys[14] = "42" ;B
	$as_keys[15] = "43" ;C
	$as_keys[16] = "44" ;D
	$as_keys[17] = "45" ;E
	$as_keys[18] = "46" ;F
	$as_keys[19] = "47" ;G
	$as_keys[20] = "48" ;H
	$as_keys[21] = "49" ;I
	$as_keys[22] = "4A" ;J
	$as_keys[23] = "4B" ;K
	$as_keys[24] = "4C" ;L
	$as_keys[25] = "4D" ;M
	$as_keys[26] = "4E" ;N
	$as_keys[27] = "4F" ;O
	$as_keys[28] = "50" ;P
	$as_keys[29] = "51" ;Q
	$as_keys[30] = "52" ;R
	$as_keys[31] = "53" ;S
	$as_keys[32] = "54" ;T
	$as_keys[33] = "55" ;U
	$as_keys[34] = "56" ;V
	$as_keys[35] = "57" ;W
	$as_keys[36] = "58" ;X
	$as_keys[37] = "59" ;Y
	$as_keys[38] = "5A" ;Z
	$as_keys[39] = "09" ;Tab
	$as_keys[40] = "70" ;F1
	$as_keys[41] = "71" ;F2
	$as_keys[42] = "72" ;F3
	$as_keys[43] = "73" ;F4
	$as_keys[44] = "74" ;F5
	$as_keys[45] = "75" ;F6
	$as_keys[46] = "76" ;F7
	$as_keys[47] = "77" ;F8
	$as_keys[48] = "78" ;F9
	$as_keys[49] = "79" ;F9
	$as_keys[50] = "7A" ;F9
	$as_keys[51] = "7B" ;F9
	$as_keys[52] = "6D" ;Minus am Nummernblock
	$as_keys[53] = "6F" ;Dividieren am Nummernblock
	$as_keys[54] = "6A" ;Multiplizieren am Nummernblock
	$as_keys[55] = "6B" ;Plus am Nummernblock
	$as_keys[56] = "60" ;0 am Nummernblock
	$as_keys[57] = "61" ;1 am Nummernblock
	$as_keys[58] = "62" ;2 am Nummernblock
	$as_keys[59] = "63" ;3 am Nummernblock
	$as_keys[60] = "64" ;4 am Nummernblock
	$as_keys[61] = "65" ;5 am Nummernblock
	$as_keys[62] = "66" ;6 am Nummernblock
	$as_keys[63] = "67" ;7 am Nummernblock
	$as_keys[64] = "68" ;8 am Nummernblock
	$as_keys[65] = "69" ;9 am Nummernblock
	$as_keys[66] = "21" ;Page up
	$as_keys[67] = "22" ;Page down
	$as_keys[68] = "DC" ;zirkumflex
	$as_keys[69] = "26" ;Pfeil oben
	$as_keys[70] = "28" ;Pfeil unten
	$as_keys[71] = "25" ;Pfeil links
	$as_keys[72] = "27" ;Pfeil rechts
	$as_keys[73] = "5C" ;Windows Logo Taste Rechts
	$as_keys[74] = "5B" ;Windows Logo Taste Links
	$as_keys[75] = "2E" ;Del (Entf)
	$as_keys[76] = "2D" ;Einfg (Insert)
	$as_keys[77] = "23" ;Ende
	$as_keys[78] = "2C" ;Print
	$as_keys[79] = "24" ;Pos1 (Home)
	$as_keys[80] = "0D" ;Enter
	#EndRegion keys

	For $i = 0 To UBound($as_keys) - 1
		If _IsPressed($as_keys[$i], $user32) Then
			;Anzahl gedrückter Tasten erhöhen
			$as_return[0] += 1
			;Taste wurde noch nicht schon einmal gedrückt
			If StringInStr($s_ignored_keys, $as_keys[$i]) = 0 Then $as_return[1] &= $as_keys[$i]
		EndIf
	Next

	Return $as_return

EndFunc   ;==>_getKey

; #FUNCTION# ;===============================================================================
;
; Name...........: _Erstelle_kopie_von_markierter_datei
; Description ...: Erstellt eine Kopie des Markierten Elementes im Projektbaum
; Syntax.........: _Erstelle_kopie_von_markierter_datei()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Kann zb. im Kontextmenü des Projektbaumes aufgerufen werden
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Erstelle_kopie_von_markierter_datei()
	If _GUICtrlTreeView_GetSelection($hTreeView) = 0 Then Return
	If _WinAPI_PathIsRoot(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Then Return
	If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = -1 Then Return
	If _GUICtrlTVExplorer_GetSelected($hWndTreeview) = $Offenes_Projekt Then Return
	$Pfad = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($Pfad, $szDrive, $szDir, $szFName, $szExt)
	$Projektbaum_ist_bereit = 0
	$answer = InputBox(_Get_langstr(371), _Get_langstr(693), $szFName & " (" & _Get_langstr(373) & ")" & $szExt, "", Default, Default, Default, Default, 0, $Studiofenster)
	If @error Then
		Return
		$Projektbaum_ist_bereit = 1
	EndIf
	If _IsDir($Pfad) Then
		DirCopy($Pfad, $szDrive & $szDir & $answer)
	Else
		FileCopy($Pfad, $szDrive & $szDir & $answer)
	EndIf
;~ 	_GUICtrlTreeView_BeginUpdate($hTreeView)
;~ 	_Speichere_TVExplorer($hTreeView) ;Speichere geöffnete Elemente
;~ 	_GUICtrlTVExplorer_AttachFolder($hTreeView)
;~ 	_GUICtrlTVExplorer_Expand($hTreeView, $szDrive & $szDir & $answer, 1)
;~ 	_Lade_TVExplorer($hTreeView) ;Geöffnete Elemente wiederherstellen
;~ 	_GUICtrlTreeView_EndUpdate($hTreeView)
	Sleep(250)
	$Projektbaum_ist_bereit = 1
EndFunc   ;==>_Erstelle_kopie_von_markierter_datei

; #FUNCTION# ;===============================================================================
;
; Name...........: _Pruefe_nach_Onlineupdates_AUTO
; Description ...: Prüft im Hintergrund nach Updates und zeigt ggf. eine Meldung an
; Syntax.........: _Pruefe_nach_Onlineupdates_AUTO($hWnd, $Msg, $iIDTimer, $dwTime)
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird durch einen Timer aufgerufen
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Pruefe_nach_Onlineupdates_AUTO($hWnd, $msg, $iIDTimer, $dwTime)
	If $enable_autoupdate = "false" Then Return ;Autoupdate deaktiviert
	If ProcessExists($ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID]) Then Return ;Läuft bereits
	;Nur falls das Zeitlimit in Tagen bereits überschritten ist
	$Differenz = _DateDiff('D', IniRead($Configfile, "config", "autoupdate_lastdate", "2012/01/01"), _NowCalcDate())
	_Timer_KillTimer($Studiofenster, $Auto_Update_Timer_Handle) ;Stoppe Timer damit Meldung nicht nocheinmal erscheint
	If $Differenz > $autoupdate_searchtimer Then _ISN_AutoIt_Studio_nach_updates_Suchen_Silent()
EndFunc   ;==>_Pruefe_nach_Onlineupdates_AUTO



; #FUNCTION# ;===============================================================================
;
; Name...........: _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien
; Description ...: Fügt eine Datei in das Menü Datei -> Zuletzt verwendete Dateien hinzu.
; Syntax.........: _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($Pfad)
; Parameters ....: $Pfad			- Pfad zur Datei
; Return values .: Array mit allen Pfaden und Dateien
; Author ........: ISI360
; Modified.......:
; Remarks .......: List wird in der project.isn im key "lastusedfiles" gespeichert
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($Pfad = "")

	If $Pfad = "" Then Return
	If Not IsArray($Zuletzt_Verwendete_Dateien_Temp_Array) Then Return
	$Pfad = _ISN_Pfad_durch_Variablen_ersetzen(FileGetLongName($Pfad))

	;prüfe ob Eintrag schon in der Liste ist
	If _ArraySearch($Zuletzt_Verwendete_Dateien_Temp_Array, $Pfad) = -1 Then
		;noch nicht in der Liste

		;Rücke alle Einträge 1 nach unten
		For $y = UBound($Zuletzt_Verwendete_Dateien_Temp_Array) - 1 To 1 Step -1
			$Zuletzt_Verwendete_Dateien_Temp_Array[$y] = $Zuletzt_Verwendete_Dateien_Temp_Array[$y - 1]
		Next
		;Füge neues Element ein
		$Zuletzt_Verwendete_Dateien_Temp_Array[0] = $Pfad

	Else
		;bereits in der Liste

		;Lösche das Element aus der Liste...
		_ArrayDelete($Zuletzt_Verwendete_Dateien_Temp_Array, _ArraySearch($Zuletzt_Verwendete_Dateien_Temp_Array, $Pfad))
		_ArrayAdd($Zuletzt_Verwendete_Dateien_Temp_Array, "")
		;..und füge es neu ein:
		$Zuletzt_Verwendete_Dateien_Temp_Array = _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($Pfad)

	EndIf

	;Schreibe das Array in die project.isn und aktualisiere die Einträge im Datei Menü
	$lastusedfiles_String = ""
	For $x = 0 To UBound($Zuletzt_Verwendete_Dateien_Temp_Array) - 1
		$lastusedfiles_String = $lastusedfiles_String & $Zuletzt_Verwendete_Dateien_Temp_Array[$x] & "|"
		If $x = 0 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot1, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot1, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 1 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot2, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot2, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 2 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot3, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot3, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 3 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot4, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot4, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 4 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot5, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot5, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 5 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot6, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot6, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 6 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot7, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot7, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 7 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot8, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot8, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 8 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot9, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot9, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
		If $x = 9 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot10, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot10, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))

	Next

	If StringLen($lastusedfiles_String) > 1 Then $lastusedfiles_String = StringTrimRight($lastusedfiles_String, 1)
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "lastusedfiles", $lastusedfiles_String)

	Return $Zuletzt_Verwendete_Dateien_Temp_Array
EndFunc   ;==>_Fuege_Datei_zu_Zuletzt_Verwendete_Dateien

; #FUNCTION# ;===============================================================================
;
; Name...........: _Lade_Zuletzt_Verwendete_Dateien_aus_projectISN
; Description ...: Lädt die Liste der Zuletzt Verwendete Dateien aus der project.isn des jewailigen Projektes (KEY: lastusedfiles)
; Syntax.........: _Lade_Zuletzt_Verwendete_Dateien_aus_projectISN()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: $Offenes_Projekt darf nicht leer sein!
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Lade_Zuletzt_Verwendete_Dateien_aus_projectISN()
	If $Offenes_Projekt = "" Then Return
	$ini = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "lastusedfiles", "||||||||||")
	If $ini = "" Then $ini = "||||||||||"
	$array = StringSplit($ini, "|", 2)

	If IsArray($array) Then
		If UBound($array) - 1 > 10 Then Return ;Error

		;Resete alle Slots
		$Zuletzt_Verwendete_Dateien_Temp_Array = $array
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot1, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot2, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot3, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot4, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot5, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot6, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot7, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot8, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot9, _Get_langstr(722))
		_GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot10, _Get_langstr(722))

		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot1, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot2, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot3, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot4, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot5, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot6, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot7, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot8, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot9, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_zuletzt_verwendete_Dateien_Slot10, $GUI_DISABLE)

		;Setze Texte
		For $x = 0 To UBound($Zuletzt_Verwendete_Dateien_Temp_Array) - 1
			If $x = 0 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot1, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot1, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 1 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot2, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot2, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 2 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot3, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot3, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 3 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot4, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot4, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 4 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot5, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot5, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 5 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot6, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot6, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 6 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot7, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot7, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 7 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot8, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot8, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 8 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot9, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot9, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))
			If $x = 9 Then _GUICtrlODMenuItemSetText($FileMenu_zuletzt_verwendete_Dateien_Slot10, _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($FileMenu_zuletzt_verwendete_Dateien_Slot10, $Zuletzt_Verwendete_Dateien_Temp_Array[$x]))

		Next
	EndIf

EndFunc   ;==>_Lade_Zuletzt_Verwendete_Dateien_aus_projectISN

Func _kuerze_Dateinamen($String)
	If StringLen($String) > 45 Then
		$String = "..." & StringTrimLeft($String, StringLen($String) - 45)
	EndIf
	Return $String
EndFunc   ;==>_kuerze_Dateinamen

Func _Zuletzt_Verwendete_Dateien_pruefe_ob_leer($item, $text)
	If $text = "" Then
		GUICtrlSetState($item, $GUI_DISABLE)
		Return _Get_langstr(722)
	EndIf
	$text = _ISN_Variablen_aufloesen($text)
	GUICtrlSetState($item, $GUI_ENABLE)
	Return _kuerze_Dateinamen($text)
EndFunc   ;==>_Zuletzt_Verwendete_Dateien_pruefe_ob_leer

; #FUNCTION# ;===============================================================================
;
; Name...........: _Oeffne_Zuletzt_Verwendete_Dateie
; Description ...: Lädt eine Datei aus der Liste der Zuletzt Verwendete Dateien in das ISN AutoIt Studio. (Erster Slot ist 0!!)
; Syntax.........: _Oeffne_Zuletzt_Verwendete_Dateie($SlotNr)
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Dabei wird auch überprüft ob die Datei überhaupt noch existiert
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Oeffne_Zuletzt_Verwendete_Dateie($SlotNr = -1)
	If $SlotNr = -1 Then Return
	If $SlotNr > 9 Then Return
	If Not IsArray($Zuletzt_Verwendete_Dateien_Temp_Array) Then Return
	$file = $Zuletzt_Verwendete_Dateien_Temp_Array[Number($SlotNr)]
	If $file = "" Then Return
	If $file = _Get_langstr(722) Then Return
	$file = _ISN_Variablen_aufloesen($file)
	Sleep(100)
	If FileExists($file) Then
		Try_to_opten_file($file)
	Else
		;Falls Fehler versuche noch mit relativen Pfaden
		If FileExists($Offenes_Projekt & $file) Then
			Try_to_opten_file($Offenes_Projekt & $file)
		Else
			;Falls das auch nicht fnktioniert -> Fehlermeldung
			MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(724), "%1", $file), 0, $Studiofenster)
		EndIf
	EndIf
EndFunc   ;==>_Oeffne_Zuletzt_Verwendete_Dateie

Func _Speichern_unter()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Dim $szDrive, $szDir, $szFName, $szExt
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> "-1" Then Return ;KEIN SPEICHERN UNTER FÜR PLUGINS!
	$Geoeffnete_Datei = $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)]
	$TestPath = _PathSplit($Geoeffnete_Datei, $szDrive, $szDir, $szFName, $szExt)
	_Lock_Plugintabs("lock")
	$line = FileSaveDialog(_Get_langstr(725), $szDrive & $szDir, "All (*.*)", 18, $szFName & $szExt, $Studiofenster)
	_Lock_Plugintabs("unlock")
	$TestPath = _PathSplit($line, $szDrive, $szDir, $szFName, $szExt)
	If $line = "" Then Return
	If @error > 0 Then Return
	FileChangeDir(@ScriptDir)
	FileCopy($Geoeffnete_Datei, $line, 9)
	$Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] = $line
	_GUICtrlTab_SetItemText($htab, _GUICtrlTab_GetCurFocus($htab), $szFName & $szExt)
	_Redraw_Window($Studiofenster)
EndFunc   ;==>_Speichern_unter

Func _exportiere_Projekteigenschaften_als_csv()
	$line = FileSaveDialog(_Get_langstr(740), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "csv (*.csv)", 18, "export.csv", $Projekteinstellungen_GUI)
	If $line = "" Then Return
	If @error > 0 Then Return
	FileChangeDir(@ScriptDir)
	_GUICtrlListView_SaveCSV($Project_Properties_listview, $line)
	MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $Studiofenster)
EndFunc   ;==>_exportiere_Projekteigenschaften_als_csv

; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
; #FUNCTION# =========================================================================================================
; Name...........: _GUICtrlListView_SaveCSV()
; Description ...: Exports the details of a ListView to a .csv file.
; Syntax.........: _GUICtrlListView_SaveCSV($hListView, $sFile, [$sDelimiter = ",", $sQuote = '"']])
; Parameters ....: $hListView - Handle of the ListView.
;                  $sFile - FilePath, this should ideally use the filetype .csv e.g. @ScriptDir & "\Example.csv"
;                  $sDelimiter - [Optional] Delimiter to be used for the csv file. [Default = ,]
;                  $sQuote - [Optional] Style of quotes to be used for the csv file. [Default = "]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - Returns filepath.
;                  Failure - Returns filepath & sets @error = 1
; Author ........: guinness & ProgAndy for the csv idea.
; Example........; Yes
;=====================================================================================================================

Func _GUICtrlListView_SaveCSV($hListView, $sFile, $sDelimiter = ",", $sQuote = '"')
	Local $hFileOpen, $iError = 0, $sItem, $sString
	Local $iColumnCount = _GUICtrlListView_GetColumnCount($hListView)
	Local $iItemCount = _GUICtrlListView_GetItemCount($hListView)

	For $a = 0 To $iItemCount - 1
		For $B = 0 To $iColumnCount - 1
			$sItem = _GUICtrlListView_GetItemText($hListView, $a, $B)
			$sString &= $sQuote & StringReplace($sItem, $sQuote, $sQuote & $sQuote, 0, 1) & $sQuote
			If $B < $iColumnCount - 1 Then
				$sString &= $sDelimiter
			EndIf
		Next
		$sString &= @CRLF
	Next
	$hFileOpen = FileOpen($sFile, 2 + $FO_ANSI)
	FileWrite($hFileOpen, $sString)
	FileClose($hFileOpen)
	If @error Then
		$iError = 1
	EndIf
	Return SetError($iError, 0, $sFile)
EndFunc   ;==>_GUICtrlListView_SaveCSV

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayUnique
; Description ...: Returns the Unique Elements of a 1-dimensional array.
; Syntax.........: _ArrayUnique($aArray[, $iDimension = 1[, $iIdx = 0[, $iCase = 0[, $iFlags = 1]]]])
; Parameters ....: $aArray    - Input array (1D or 2D only)
;                 $iDimension  - [optional] The dimension of the array to process (only valid for 2D arrays)
;                 $iIdx     - [optional] Index at which to start scanning the input array
;                 $iCase       - [optional] Flag to indicate if string comparisons should be case sensitive
;                                | 0 - case insensitive
;                                | 1 - case sensitive
;                 $iFlags     - [optional] Set of flags, added together
;                                | 1 - Return the array count in element [0]
; Return values .: Success    - Returns a 1-dimensional array containing only the unique elements of the input array / dimension
;                 Failure     - Returns 0 and sets @error:
;                                | 1 - Input is not an array
;                                | 2 - Arrays greater than 2 dimensions are not supported
;                                | 3 - $iDimension is out of range
;                                | 4 - $iIdx is out of range
; Author ........: SmOke_N
; Modified.......: litlmike, Erik Pilsits
; Remarks .......:
; Related .......: _ArrayMax, _ArrayMin
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func __ArrayUnique(Const ByRef $aArray, $iDimension = 1, $iIdx = 0, $iCase = 0, $iFlags = 0)
	; Check to see if it is valid array
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	Local $iDims = UBound($aArray, 0)
	If $iDims > 2 Then Return SetError(2, 0, 0)
	;
	; checks the given dimension is valid
	If ($iDimension <= 0) Or (($iDims = 1) And ($iDimension > 1)) Or (($iDims = 2) And ($iDimension > UBound($aArray, 2))) Then Return SetError(3, 0, 0)
	; make $iDimension an array index, note this is ignored for 1D arrays
	$iDimension -= 1
	;
	; check $iIdx
	If ($iIdx < 0) Or ($iIdx >= UBound($aArray)) Then Return SetError(4, 0, 0)
	;
	; create dictionary
	Local $oD = ObjCreate("Scripting.Dictionary")
	; compare mode for strings
	; 0 = binary, which is case sensitive
	; 1 = text, which is case insensitive
	; this expression forces either 1 or 0
	$oD.CompareMode = Number(Not $iCase)
	;
	Local $vElem
	; walk the input array
	For $i = $iIdx To UBound($aArray) - 1
		If $iDims = 1 Then
			; 1D array
			$vElem = $aArray[$i]
		Else
			; 2D array
			$vElem = $aArray[$i][$iDimension]
		EndIf
		; add key to dictionary
		; NOTE: accessing the value (.Item property) of a key that doesn't exist creates the key :)
		; keys are guaranteed to be unique
		$oD.Item($vElem)
	Next
	;
	; return the array of unique keys
	If BitAND($iFlags, 1) = 1 Then
		Local $aTemp = $oD.Keys()
		_ArrayInsert($aTemp, 0, $oD.Count)
		Return $aTemp
	Else
		Return $oD.Keys()
	EndIf
EndFunc   ;==>__ArrayUnique

Func _Scanne_array_nach_Variablen(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iSubItem = 0)
	$iStart = _ArraySearch($avArray, $vValue, $iStart, $iEnd, $iCase, $iCompare, 1, $iSubItem)
	If @error Then Return SetError(@error, 0, -1)
	Local $Letzer_fortschritt = 0
	Local $String = _Get_langstr(747)
	Local $iIndex = 0, $avResult[UBound($avArray)]
	Do
		$globale_variablen_einlesen_fortschritt = Int(($iStart / (UBound($avArray) - 1)) * 100)
		If $globale_variablen_einlesen_fortschritt <> $Letzer_fortschritt Then _GUICtrlStatusBar_SetText_ISN($Status_bar, StringReplace($String, "%1", $globale_variablen_einlesen_fortschritt))
		$to_add = $avArray[$iStart]
		If StringLeft($to_add, 1) = "$" Then
			$to_add = StringReplace($to_add, "'", "")
			$to_add = StringReplace($to_add, '"', "")
			If $to_add <> "$" Then
				$avResult[$iIndex] = $to_add
				$iIndex += 1
			EndIf
		EndIf
		$iStart = _ArraySearch($avArray, $vValue, $iStart + 1, $iEnd, $iCase, $iCompare, 1, $iSubItem)
		$Letzer_fortschritt = $globale_variablen_einlesen_fortschritt
	Until @error

	ReDim $avResult[$iIndex]
	Return $avResult
EndFunc   ;==>_Scanne_array_nach_Variablen






; #FUNCTION# ;===============================================================================
; Name...........: _Fenstergroessen_zuruecksetzen
; Description ...: Setzt die Fenstergrößen des Projektbaumes usw. auf standard zurück
; Syntax.........: _Fenstergroessen_zuruecksetzen()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird aus den Programmeinstellungen aufgerufen
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
; ;==========================================================================================

Func _Fenstergroessen_zuruecksetzen()
	IniDelete($configfile, "config", "debugguiX")
	IniDelete($configfile, "config", "debugguiY")
	IniDelete($configfile, "config", "Left_Splitter_Y")
	IniDelete($configfile, "config", "Left_Splitter_X")
	IniDelete($configfile, "config", "Middle_Splitter_Y")
	IniDelete($configfile, "config", "Right_Splitter_X")
;~ 	if $Toggle_rightside = 0 AND $Offenes_Projekt <> "" then GUICtrlSetPos($Right_Splitter_X, _Config_Read("Right_Splitter_X", $size[2] - 268), 30, $Splitter_Breite, $size[3] - 80)

	$size1 = WinGetClientSize($Studiofenster, "")
	$size = WinGetPos($Studiofenster)

	If $Toggle_rightside = 0 And _GUICtrlTab_GetItemCount($htab) > 0 And $Offenes_Projekt <> "" Then
		$ext = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 1, -1))
		If $ext = $Autoitextension Then GUICtrlSetPos($Right_Splitter_X, ($size1[0] / 100) * Number(_Config_Read("Right_Splitter_X", $Rechter_Splitter_X_default)), 30, $Splitter_Breite, $size[3] - 80)
	EndIf


	If $hidefunctionstree = "true" Then GUICtrlSetPos($Right_Splitter_X, $size1[0] - 2, 25, $Splitter_Breite, $size1[1] - 80)


	If $Toggle_Leftside = 0 Then GUICtrlSetPos($Left_Splitter_X, ($size1[0] / 100) * Number(_Config_Read("Left_Splitter_X", $Linker_Splitter_X_default)), 30, $Splitter_Breite, $size[3] - 80)



	GUICtrlSetPos($Middle_Splitter_Y, 268, ($size1[1] / 100) * Number(_Config_Read("Left_Splitter_Y", $Linker_Splitter_Y_default)), 200, $Splitter_Breite)
	If $hidedebug = "true" Then GUICtrlSetPos($Middle_Splitter_Y, 268, $size1[1] - 20, 200, 5)
	GUICtrlSetPos($Left_Splitter_Y, 2, ($size1[1] / 100) * Number(_Config_Read("Middle_Splitter_Y", $Mittlerer_Splitter_Y_default)), 200, $Splitter_Breite)
	If $hideprogramlog = "true" Then
		GUICtrlSetPos($Left_Splitter_Y, 2, $size1[1] - 45, 200, 5)
		GUICtrlSetState($Left_Splitter_Y, $GUI_HIDE)
		GUICtrlSetState($QuickView_title, $GUI_HIDE)
		GUISetState(@SW_HIDE, $QuickView_GUI)
	EndIf
	;Aktualisiere die Splitter
	_Aktualisiere_Splittercontrols()
;~ 	msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(750), 0, $StudioFenster) ;Nervt nur ^^
EndFunc   ;==>_Fenstergroessen_zuruecksetzen

; #FUNCTION# ;===============================================================================
; Name...........: _Zeige_AutoIt3Wrapper_GUI
; Description ...: Zeigt die AutoIt3Wrapper GUI in verbindung mit dem aktuellen Skript
; Syntax.........: _Zeige_AutoIt3Wrapper_GUI()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird aus dem "Tools" Menü aufgerufen
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
; ;==========================================================================================

Func _Zeige_AutoIt3Wrapper_GUI()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return
	_try_to_save_file(_GUICtrlTab_GetCurFocus($htab))
	GUICtrlSetData($warte_auf_wrapper_GUI_text, _Get_langstr(752))
	GUISetState(@SW_SHOW, $warte_auf_wrapper_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
	_Clear_Debuglog()
	$data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /in "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '" /showgui', 0, $Offenes_Projekt, @SW_SHOW, 1)
	LoadEditorFile($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)])
	$FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] = Sci_GetLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	_Check_Buttons(0)
	;_Update_Treeview()
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $warte_auf_wrapper_GUI)
EndFunc   ;==>_Zeige_AutoIt3Wrapper_GUI

; #FUNCTION# ;===============================================================================
; Name...........: _Zeige_Organize_Includes
; Description ...: Startet Organize_Includes in verbindung mit dem aktuellen Skript
; Syntax.........: _Zeige_Organize_Includes()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird aus dem "Tools" Menü aufgerufen
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
; ;==========================================================================================

Func _Zeige_Organize_Includes()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Offenes_Projekt = "" Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return
	GUICtrlSetData($warte_auf_wrapper_GUI_text, _Get_langstr(795))
	GUISetState(@SW_SHOW, $warte_auf_wrapper_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
	_Clear_Debuglog()
	$data = _RunReadStd(@ScriptDir & '\Data\organizeincludes\OI_1.0.0.50.exe "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '"', 0, @ScriptDir & '\Data\organizeincludes\', @SW_SHOW, 1)
	LoadEditorFile($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)])
	$FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] = Sci_GetLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	_Check_Buttons(0)
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $warte_auf_wrapper_GUI)
EndFunc   ;==>_Zeige_Organize_Includes

; #FUNCTION# ;===============================================================================
; Name...........: _Kompilieren_Editormodus
; Description ...: Kompiliert eine au3 Datei im Editormodus mit dem AutoIt3Wrapper
; Syntax.........: _Kompilieren_Editormodus()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird im Editormodus verwendet
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
; ;==========================================================================================

Func _Kompilieren_Editormodus()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If $Offenes_Projekt = "" Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return
	GUISetState(@SW_SHOW, $warte_auf_wrapper_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
	_Clear_Debuglog()
	$data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /in "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '"', 0, $Offenes_Projekt, @SW_SHOW, 1)
	_Update_Treeview()
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $warte_auf_wrapper_GUI)
EndFunc   ;==>_Kompilieren_Editormodus

; #FUNCTION# ;===============================================================================
; Name...........: _Ersteinrichtungsassistenten_wiederherstellen
; Description ...: Entfernt den Pfad zur config.ini und lässt ISN so glauben er würde das erste mal gestartet
; Syntax.........: _Ersteinrichtungsassistenten_wiederherstellen()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Kann aus den Programmeinstellungen -> Erweitert ausgeführt werden
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
; ;==========================================================================================

Func _Ersteinrichtungsassistenten_wiederherstellen()
	$result = MsgBox(262144 + 48 + 4, _Get_langstr(394), _Get_langstr(789), 0, $Config_GUI)
	If $result = 6 Then
		RegDelete("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Configfile")
		FileDelete(@ScriptDir & "\portable.dat")
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(790), 0, $Config_GUI)
		_exit()
	EndIf
EndFunc   ;==>_Ersteinrichtungsassistenten_wiederherstellen

; #FUNCTION# ;===============================================================================
; Name...........: _Testprojekt_anlegen
; Description ...: Entpackt den inhalt der testprojekt.zip in den Projekte-Ordner
; Syntax.........: _Testprojekt_anlegen()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: Kann aus den Programmeinstellungen -> Erweitert ausgeführt werden
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
; ;==========================================================================================

Func _Testprojekt_anlegen()
	$result = MsgBox(262144 + 32 + 4, _Get_langstr(61), _Get_langstr(791), 0, $Config_GUI)
	If $result = 6 Then
		_UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "_UnZIP_ServiceFunc")
		_UnZIP_SetOptions()
		$result = _UnZIP_Unzip(@ScriptDir & "\Data\Packages\testprojekt.zip", _ISN_Variablen_aufloesen($Projectfolder))
		_GUICtrlStatusBar_SetText_ISN($Status_bar, "")
		MsgBox(262144 + 64, _Get_langstr(178), _Get_langstr(792), 0, $Config_GUI)
	EndIf
EndFunc   ;==>_Testprojekt_anlegen

Func _Erweitertes_Debugging_aktivieren()
	GUICtrlSetState($Tools_menu_debugging_erweitertes_debugging_aktivieren, $GUI_CHECKED)
	GUICtrlSetState($Tools_menu_debugging_erweitertes_debugging_deaktivieren, $GUI_UNCHECKED)
	$Erweitertes_debugging = "true"
	_Write_in_Config("enhanced_debugging", $Erweitertes_debugging)
	_Show_Warning("confirmdebugging", 308, _Get_langstr(178), _Get_langstr(803), _Get_langstr(7))
EndFunc   ;==>_Erweitertes_Debugging_aktivieren

Func _Erweitertes_Debugging_deaktivieren()
	GUICtrlSetState($Tools_menu_debugging_erweitertes_debugging_aktivieren, $GUI_UNCHECKED)
	GUICtrlSetState($Tools_menu_debugging_erweitertes_debugging_deaktivieren, $GUI_CHECKED)
	$Erweitertes_debugging = "false"
	_Write_in_Config("enhanced_debugging", $Erweitertes_debugging)
EndFunc   ;==>_Erweitertes_Debugging_deaktivieren


; #FUNCTION# ;===============================================================================
; Name...........: _Pruefe_ob_Datei_geoeffnet
; Description ...: Entpackt den inhalt der testprojekt.zip in den Projekte-Ordner
; Syntax.........: _Pruefe_ob_Datei_geoeffnet($Pfad)
; Parameters ....: $Pfad	- Pfad zur Datei die geprüft werden soll
; Return values .: true		- Datei ist geöffnet
;                  false	- Datei ist nicht geöffnet
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: https://www.isnetwork.at
; Example .......: No
; ;==========================================================================================

Func _Pruefe_ob_Datei_geoeffnet($Pfad = "")
	If $Pfad = "" Then Return "false"
	If _ArraySearch($Datei_pfad, $Pfad) > -1 Then Return "true"
	Return "false"
EndFunc   ;==>_Pruefe_ob_Datei_geoeffnet

; #FUNCTION# ========================================================================================================
; Name.............:    _ArraySort_MultiColumn
; Description ...:      sorts an array at given colums (multi colum sort)
; Syntax...........:    _ArraySort_MultiColumn(ByRef $aSort, ByRef $aIndices)
; Parameters ...:       $aSort - array to sort
;                       $aIndices - array with colum indices which should be sorted in specified order - zero based
;                       $dir - sort direction - if set to 1, sort descendingly
; Author .........:     UEZ
; Version ........:     v0.60 build 2011-04-19 Beta
; ===================================================================================================================
Func _ArraySort_MultiColumn(ByRef $aSort, ByRef $aIndices, $oDir = 0, $iDir = 0)
	Local $1st, $2nd
	If Not IsArray($aIndices) Or Not IsArray($aSort) Then Return SetError(1, 0, 0) ;checks if $aIndices is an array
	If UBound($aIndices) > UBound($aSort, 2) Then Return SetError(2, 0, 0) ;check if $aIndices array is greater the $aSort array
	Local $x
	For $x = 0 To UBound($aIndices) - 1 ;check if array content makes sense
		If Not IsInt($aIndices[$x]) Then Return SetError(3, 0, 0) ;array content is not numeric
	Next
	If UBound($aIndices) = 1 Then Return _ArraySort($aSort, $oDir, 0, 0, $aIndices[0]) ;check if only one index is given
	Local $j, $k, $l = 0
	_ArraySort($aSort, $oDir, 0, 0, $aIndices[0])
	Do
		$1st = $aIndices[$l]
		$2nd = $aIndices[$l + 1]
		$j = 0
		$k = 1
		While $k < UBound($aSort)
			If $aSort[$j][$1st] <> $aSort[$k][$1st] Then
				If $k - $j > 1 Then
					_ArraySort($aSort, $iDir, $j, $k - 1, $2nd)
					$j = $k
				Else
					$j = $k
				EndIf
			EndIf
			$k += 1
		WEnd
		If $k - $j > 1 Then _ArraySort($aSort, $oDir, $j, $k, $2nd)
		$l += 1
	Until $l = UBound($aIndices) - 1
	Return 1
EndFunc   ;==>_ArraySort_MultiColumn

Func _RGB_to_BGR($colour = "")
	If $colour = "" Then Return 0
	$r = _ColorGetRed($colour)
	$g = _ColorGetGreen($colour)
	$B = _ColorGetBlue($colour)
	$BGR = "0x" & Hex($B, 2) & Hex($g, 2) & Hex($r, 2)
	Return $BGR
EndFunc   ;==>_RGB_to_BGR

Func _BGR_to_RGB($colour = "")
	If $colour = "" Then Return 0
	$r = _ColorGetBlue($colour)
	$g = _ColorGetGreen($colour)
	$B = _ColorGetRed($colour)
	$RGB = "0x" & Hex($r, 2) & Hex($g, 2) & Hex($B, 2)
	Return $RGB
EndFunc   ;==>_BGR_to_RGB

Func Codeausschnitt_GUI_Resize()
	$Codeausschnitt_clientsize = WinGetClientSize($Codeausschnitt_GUI)
	If IsArray($Codeausschnitt_clientsize) Then
		If BitAND(GUICtrlGetState($Codeausschnitt_GUI_titel2), $GUI_SHOW) Then
			WinMove($scintilla_Codeausschnitt, "", 10 * $DPI, 93 * $DPI, $Codeausschnitt_clientsize[0] - ((12 + 10) * $DPI), $Codeausschnitt_clientsize[1] - ((60 + 93) * $DPI))
		Else
			WinMove($scintilla_Codeausschnitt, "", 10 * $DPI, 50 * $DPI, $Codeausschnitt_clientsize[0] - ((12 + 10) * $DPI), $Codeausschnitt_clientsize[1] - ((17 + 93) * $DPI))
		EndIf
	EndIf
EndFunc   ;==>Codeausschnitt_GUI_Resize



Func _AU3_aus_Projektbaum_mit_neuem_Makro_kompilieren()
	$Markierte_Datei_im_Projektbaum = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	If $Markierte_Datei_im_Projektbaum = "" Then Return
	_Show_new_rule_event()
	_Add_action_to_list($Key_Action6)
	Dim $szDrive, $szDir, $szFName, $szExt
	$path = _PathSplit($Markierte_Datei_im_Projektbaum, $szDrive, $szDir, $szFName, $szExt)
	GUICtrlSetData($rule_compile_exename, $szFName & ".exe")

	$Markierte_Datei_im_Projektbaum = _ISN_Pfad_durch_Variablen_ersetzen($Markierte_Datei_im_Projektbaum)
	GUICtrlSetData($compile_rule_inputfile, $Markierte_Datei_im_Projektbaum)
EndFunc   ;==>_AU3_aus_Projektbaum_mit_neuem_Makro_kompilieren


Func _GUICtrlListView_CopyAllItems($hWnd_Source, $hWnd_Destination, $bDelFlag = False)
	Local $a_Indices, $tItem = DllStructCreate($tagLVITEM), $iIndex
	Local $iCols = _GUICtrlListView_GetColumnCount($hWnd_Source)

	Local $iItems = _GUICtrlListView_GetItemCount($hWnd_Source)
	_GUICtrlListView_BeginUpdate($hWnd_Source)
	_GUICtrlListView_BeginUpdate($hWnd_Destination)
	_GUICtrlListView_DeleteAllItems($hWnd_Destination)
	If BitAND(_GUICtrlListView_GetExtendedListViewStyle($hWnd_Source), $LVS_EX_CHECKBOXES) == $LVS_EX_CHECKBOXES Then
		For $i = 0 To $iItems - 1
			If (_GUICtrlListView_GetItemChecked($hWnd_Source, $i)) Then
				If IsArray($a_Indices) Then
					ReDim $a_Indices[UBound($a_Indices) + 1]
				Else
					Local $a_Indices[2]
				EndIf
				$a_Indices[0] = $a_Indices[0] + 1
				$a_Indices[UBound($a_Indices) - 1] = $i
			EndIf
		Next

		If (IsArray($a_Indices)) Then
			For $i = 1 To $a_Indices[0]
				DllStructSetData($tItem, "Mask", BitOR($LVIF_GROUPID, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_STATE))
				DllStructSetData($tItem, "Item", $a_Indices[$i])
				DllStructSetData($tItem, "SubItem", 0)
				DllStructSetData($tItem, "StateMask", -1)
				_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
				$iIndex = _GUICtrlListView_AddItem($hWnd_Destination, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], 0), DllStructGetData($tItem, "Image"))
				_GUICtrlListView_SetItemChecked($hWnd_Destination, $iIndex)
				For $x = 1 To $iCols - 1
					DllStructSetData($tItem, "Item", $a_Indices[$i])
					DllStructSetData($tItem, "SubItem", $x)
					_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
					_GUICtrlListView_AddSubItem($hWnd_Destination, $iIndex, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], $x), $x, DllStructGetData($tItem, "Image"))
				Next
				;_GUICtrlListView_SetItemChecked($hWnd_Source, $a_Indices[$i], False)
			Next
			If $bDelFlag Then
				For $i = $a_Indices[0] To 1 Step -1
					_GUICtrlListView_DeleteItem($hWnd_Source, $a_Indices[$i])
				Next
			EndIf
		EndIf
	EndIf

	$a_Indices = _GUICtrlListView_GetSelectedIndices($hWnd_Source, 1)
	For $i = 1 To _GUICtrlListView_GetItemCount($hWnd_Source)
		DllStructSetData($tItem, "Mask", BitOR($LVIF_GROUPID, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_STATE))
		DllStructSetData($tItem, "Item", $i - 1)
		DllStructSetData($tItem, "SubItem", 0)
		DllStructSetData($tItem, "StateMask", -1)
		_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
		$iIndex = _GUICtrlListView_AddItem($hWnd_Destination, _GUICtrlListView_GetItemText($hWnd_Source, $i - 1, 0), DllStructGetData($tItem, "Image"))
		For $x = 1 To $iCols - 1
			DllStructSetData($tItem, "Item", $i - 1)
			DllStructSetData($tItem, "SubItem", $x)
			_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
			_GUICtrlListView_AddSubItem($hWnd_Destination, $iIndex, _GUICtrlListView_GetItemText($hWnd_Source, $i - 1, $x), $x, DllStructGetData($tItem, "Image"))
		Next
	Next
	_GUICtrlListView_SetItemSelected($hWnd_Source, -1, False)
	If $bDelFlag Then
		For $i = $a_Indices[0] To 1 Step -1
			_GUICtrlListView_DeleteItem($hWnd_Source, $a_Indices[$i])
		Next
	EndIf

	_GUICtrlListView_EndUpdate($hWnd_Source)
	_GUICtrlListView_EndUpdate($hWnd_Destination)
EndFunc   ;==>_GUICtrlListView_CopyAllItems

Func _AU3_aus_Projektbaum_mit_vorhandenen_Makro_kompilieren()
	$Markierte_Datei_im_Projektbaum = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	If $Markierte_Datei_im_Projektbaum = "" Then Return
	_Build_Rulelist()
	GUISetState(@SW_SHOW, $Makro_auswaehlen_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
EndFunc   ;==>_AU3_aus_Projektbaum_mit_vorhandenen_Makro_kompilieren

Func _AU3_mit_vorhandenen_Makro_kompilieren_Makro_auswaehlen()
	If _GUICtrlListView_GetSelectionMark($makro_auswaehlen_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($makro_auswaehlen_listview) = 0 Then Return
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $Makro_auswaehlen_GUI)
	$Markierte_Datei_im_Projektbaum = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	If $Markierte_Datei_im_Projektbaum = "" Then Return
	_Show_new_rule_form(_GUICtrlListView_GetItemText($makro_auswaehlen_listview, _GUICtrlListView_GetSelectionMark($makro_auswaehlen_listview), 2))
	_Add_action_to_list($Key_Action6)
	Dim $szDrive, $szDir, $szFName, $szExt
	$path = _PathSplit($Markierte_Datei_im_Projektbaum, $szDrive, $szDir, $szFName, $szExt)
	GUICtrlSetData($rule_compile_exename, $szFName & ".exe")

	$Markierte_Datei_im_Projektbaum = _ISN_Pfad_durch_Variablen_ersetzen($Markierte_Datei_im_Projektbaum)
	GUICtrlSetData($compile_rule_inputfile, $Markierte_Datei_im_Projektbaum)
EndFunc   ;==>_AU3_mit_vorhandenen_Makro_kompilieren_Makro_auswaehlen

Func _Hide_AU3_aus_Projektbaum_mit_vorhandenen_Makro_kompilieren()
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $Makro_auswaehlen_GUI)
EndFunc   ;==>_Hide_AU3_aus_Projektbaum_mit_vorhandenen_Makro_kompilieren

Func _AU3_aus_Projektbaum_Direkt_Kompilieren($Markierte_Datei_im_Projektbaum = "", $Silent = 0)
	If $Markierte_Datei_im_Projektbaum = "" Then
		$Markierte_Datei_im_Projektbaum = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
	EndIf
	If $Markierte_Datei_im_Projektbaum = "" Then Return

	If Not FileExists($AutoIt3Wrapper_exe_path) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1032), 0, $Studiofenster)
		Return
	EndIf

	_STOPSCRIPT() ;Wenn noch ein Skript läuft -> Stoppen!

	If $Silent = 0 Then
		GUISetState(@SW_SHOW, $compilingRule)
		GUISetState(@SW_DISABLE, $Studiofenster)
	EndIf

	;Prüfe ob datei geöffnet ist und speichere diese vor dem Kompilieren
	$alreadyopen = _GUICtrlTab_FindTab($htab, StringTrimLeft($Markierte_Datei_im_Projektbaum, StringInStr($Markierte_Datei_im_Projektbaum, "\", 0, -1)))
	If $alreadyopen <> -1 Then
		$res = _ArraySearch($Datei_pfad, $Markierte_Datei_im_Projektbaum)
		If $res <> -1 Then
			_try_to_save_file($res)
		EndIf
	EndIf


	;Dateiinhalt vor dem Kompilieren einlesen (sichern)
	Local $hFile = FileOpen($Markierte_Datei_im_Projektbaum, $FO_READ + FileGetEncoding($Markierte_Datei_im_Projektbaum))
	Local $Dateiinhalt_vor_dem_Kompilieren = FileRead($hFile, FileGetSize($Markierte_Datei_im_Projektbaum))
	FileClose($hFile)
	If Not _System_benoetigt_double_byte_character_Support() Then $Dateiinhalt_vor_dem_Kompilieren = _ANSI2UNICODE($Dateiinhalt_vor_dem_Kompilieren)


	$source = $Markierte_Datei_im_Projektbaum

	$target = StringReplace($Markierte_Datei_im_Projektbaum, "." & $Autoitextension, ".exe")

	_Clear_Debuglog()
	;$Console_Bluemode = 1
	$fertiger_zielpfad = $target
	$Pfadaenderung_durch_Wrapper = _Kompilieren_Datei_Analysieren_und_Zielpfade_herausfinden($source)
	If $Pfadaenderung_durch_Wrapper <> "" Then $fertiger_zielpfad = $Pfadaenderung_durch_Wrapper

	GUICtrlSetData($rulecompile_label1, _Get_langstr(602) & " " & $source)
	GUICtrlSetData($rulecompile_label2, _Get_langstr(583) & " " & $fertiger_zielpfad)

	$Zuletzt_Kompilierte_Datei_Pfad_au3 = $source ;Dateipfad der zuletzt kompilierten Datei (.au3 Datei)
	_run_rule($Section_Trigger21_beforecompilefile) ;Makro "vor Datei kompilieren"
	$data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /in "' & $source & '" /out "' & $target & '"', 0, $Offenes_Projekt, @SW_HIDE, 1)
	$Zuletzt_Kompilierte_Datei_Pfad_exe = $fertiger_zielpfad ;Dateipfad der zuletzt kompilierten Datei (.exe Datei)
	Dim $szDrive, $szDir, $szFName, $szExt
	$path = _PathSplit($source, $szDrive, $szDir, $szFName, $szExt)
	If FileExists($szDrive & $szDir & $szFName & "_Obfuscated" & $szExt) Then FileDelete(FileGetShortName($szDrive & $szDir & $szFName) & "_Obfuscated" & $szExt)
	If FileExists($szDrive & $szDir & _GetShortName($szFName) & "_Obfuscated" & $szExt) Then FileDelete($szDrive & $szDir & _GetShortName($szFName) & "_Obfuscated" & $szExt)
	If FileExists($szDrive & $szDir & $szFName & ".tbl") Then FileDelete(FileGetShortName($szDrive & $szDir & $szFName) & ".tbl")
	If FileExists($szDrive & $szDir & _GetShortName($szFName) & ".tbl") Then FileDelete($szDrive & $szDir & _GetShortName($szFName) & ".tbl")


	;Exit Codes Analysieren und ggf. Änderungen vornehmen
	If IsArray($data) Then
		If $data[1] <> 0 Then
			$result = MsgBox(262196, _Get_langstr(394), StringReplace(_Get_langstr(1138), "%1", $szFName & $szExt) & @CRLF & @CRLF & _Get_langstr(1139), 0, $compilingRule)
			If $result = 7 Then
				$Kompilieren_laeuft = 0 ;Stoppe weitere ausführung
				GUISetState(@SW_ENABLE, $Studiofenster)
				GUISetState(@SW_HIDE, $compilingRule)
				Return
			EndIf
		EndIf
	EndIf

	_run_rule($Section_Trigger19_compilefile) ;Makro "Nach Datei kompilieren"


	If _Pruefe_ob_Datei_geoeffnet($source) = "true" Then ;Lese Datei neu ein (falls geöffnet)
		;Dateiinhalt nach dem Kompilieren einlesen, und falls sich etwas verändert hat -> Datei neu einlesen
		Local $hFile = FileOpen($source, $FO_READ + FileGetEncoding($source))
		Local $Dateiinhalt_nach_dem_Kompilieren = FileRead($hFile, FileGetSize($source))
		FileClose($hFile)
		If Not _System_benoetigt_double_byte_character_Support() Then $Dateiinhalt_nach_dem_Kompilieren = _ANSI2UNICODE($Dateiinhalt_nach_dem_Kompilieren)

		If $Dateiinhalt_nach_dem_Kompilieren <> $Dateiinhalt_vor_dem_Kompilieren Then
			$tabpage = _GUICtrlTab_FindTab($htab, StringTrimLeft($source, StringInStr($source, "\", 0, -1)))
			$old_cur_pos = Sci_GetCurrentPos($SCE_EDITOR[$tabpage])
			LoadEditorFile($SCE_EDITOR[$tabpage], $source)
			$FILE_CACHE[$tabpage] = Sci_GetLines($SCE_EDITOR[$tabpage])
			_Editor_Restore_Fold()
			Sci_SetCurrentPos($SCE_EDITOR[$tabpage], $old_cur_pos)
		EndIf
	EndIf

	If $Silent = 0 Then
		;_Update_Treeview() ;Zum Abschluss noch den Projektbaum aktualisieren
		GUISetState(@SW_ENABLE, $Studiofenster)
		GUISetState(@SW_HIDE, $compilingRule)
	EndIf
EndFunc   ;==>_AU3_aus_Projektbaum_Direkt_Kompilieren


Func _Erstelle_Kontextmenu_fuer_Projektbaum()
	;Projektbaum Kontextmenü
	GUISwitch($Studiofenster)
	GUICtrlDelete($TreeviewContextMenu)
	Global $TreeviewContextMenu_dummy = GUICtrlCreateDummy()
	Global $TreeviewContextMenu = GUICtrlCreateContextMenu($TreeviewContextMenu_dummy)
	Global $TreeviewContextMenu_Item1 = _GUICtrlCreateODMenuItem(_Get_langstr(65) & @TAB & "Enter", $TreeviewContextMenu, $smallIconsdll, 1287) ;open
	_GUICtrlCreateODMenuItem("", $TreeviewContextMenu)
	Global $TreeviewContextMenu_Oeffnen_Mit = _GUICtrlCreateODMenu(_Get_langstr(1107), $TreeviewContextMenu, $smallIconsdll, 1287) ;Öffnen mit
	Global $TreeviewContextMenu_Oeffnen_Mit_Script_Editor = _GUICtrlCreateODMenuItem(_Get_langstr(196), $TreeviewContextMenu_Oeffnen_Mit, $smallIconsdll, 1786) ;Öffnen mit Scintilla
	Global $TreeviewContextMenu_Oeffnen_Mit_Windows = _GUICtrlCreateODMenuItem(_Get_langstr(1108), $TreeviewContextMenu_Oeffnen_Mit, $smallIconsdll, 193) ;An Windows übergeben

	Global $TreeviewContextMenu_Item2 = _GUICtrlCreateODMenuItem(_Get_langstr(66), $TreeviewContextMenu, $smallIconsdll, 824) ;rename
	Global $TreeviewContextMenu_Item3 = _GUICtrlCreateODMenuItem(_Get_langstr(67) & @TAB & "Del", $TreeviewContextMenu, $smallIconsdll, 1174) ;delete
	Global $TreeviewContextMenu_Item4 = _GUICtrlCreateODMenuItem(_Get_langstr(121), $TreeviewContextMenu, $smallIconsdll, 1090) ;move
	Global $TreeviewContextMenu_Item9 = _GUICtrlCreateODMenuItem(_Get_langstr(398), $TreeviewContextMenu, $smallIconsdll, 1265) ;showinexplorer
	Global $TreeviewContextMenu_Item10 = _GUICtrlCreateODMenuItem(_Get_langstr(371), $TreeviewContextMenu, $smallIconsdll, 512) ;kopie erstellen
	Global $TreeviewContextMenu_Item5 = _GUICtrlCreateODMenuItem(_Get_langstr(68), $TreeviewContextMenu, $smallIconsdll, 11) ;eigenschaften

	_GUICtrlCreateODMenuItem("", $TreeviewContextMenu)


	Global $TreeviewContextMenu_Item_Projektbaum_aktualisieren = _GUICtrlCreateODMenuItem(_Get_langstr(53), $TreeviewContextMenu, $smallIconsdll, 998) ;Projektbaum aktualisieren
	If $Tools_PELock_Obfuscator_aktiviert = "true" Then
		Global $TreeviewContextMenu_Item_PELock_Obfuscator = _GUICtrlCreateODMenuItem(_Get_langstr(1214), $TreeviewContextMenu, $smallIconsdll, 1926) ;PELock Obfuscator
	Else
		Global $TreeviewContextMenu_Item_PELock_Obfuscator = "" ;PELock Obfuscator
	EndIf
	Global $TreeviewContextMenu_Item_Kompilieren = _GUICtrlCreateODMenu(_Get_langstr(235), $TreeviewContextMenu, $smallIconsdll, 1786) ;Kompilieren
	Global $TreeviewContextMenu_Item_Jetzt_Kompilieren = _GUICtrlCreateODMenuItem(_Get_langstr(1050), $TreeviewContextMenu_Item_Kompilieren, $smallIconsdll, 1786) ;Jetzt kompilieren
	_GUICtrlCreateODMenuItem("", $TreeviewContextMenu_Item_Kompilieren)
	Global $TreeviewContextMenu_Item_Makro_kompilieren_neu = _GUICtrlCreateODMenuItem(_Get_langstr(1051), $TreeviewContextMenu_Item_Kompilieren, $smallIconsdll, 338) ;Makro kompilieren (neu)
	Global $TreeviewContextMenu_Item_Makro_kompilieren_bestehend = _GUICtrlCreateODMenuItem(_Get_langstr(1052), $TreeviewContextMenu_Item_Kompilieren, $smallIconsdll, 338) ;Makro kompilieren (bestehend)



	_GUICtrlCreateODMenuItem("", $TreeviewContextMenu)





	$TreeviewContextMenu_makroslot1 = ""
	$TreeviewContextMenu_makroslot2 = ""
	$TreeviewContextMenu_makroslot3 = ""
	$TreeviewContextMenu_makroslot4 = ""
	$TreeviewContextMenu_makroslot5 = ""
	$TreeviewContextMenu_makroslot6 = ""
	$TreeviewContextMenu_makroslot7 = ""
	If $Offenes_Projekt <> "" Then
		$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger12)
		If Not @error And IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot1_projecttreecontext", "0") = 1 And IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") = "active" Then
			$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
			$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot1", "1")
			$readen_icon = Number($readen_icon)
			If $readen_icon = 1 Then $readen_icon = $readen_icon - 1
			$TreeviewContextMenu_makroslot1 = _GUICtrlCreateODMenuItem($name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot1), $TreeviewContextMenu, $smallIconsdll, $readen_icon) ;makroslot1
		EndIf

		$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger13)
		If Not @error And IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot2_projecttreecontext", "0") = 1 And IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") = "active" Then
			$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
			$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot2", "909")
			$readen_icon = Number($readen_icon)
			If $readen_icon = 1 Then $readen_icon = $readen_icon - 1
			$TreeviewContextMenu_makroslot2 = _GUICtrlCreateODMenuItem($name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot2), $TreeviewContextMenu, $smallIconsdll, $readen_icon) ;makroslot2
		EndIf

		$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger14)
		If Not @error And IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot3_projecttreecontext", "0") = 1 And IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") = "active" Then
			$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
			$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot3", "1020")
			$readen_icon = Number($readen_icon)
			If $readen_icon = 1 Then $readen_icon = $readen_icon - 1
			$TreeviewContextMenu_makroslot3 = _GUICtrlCreateODMenuItem($name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot3), $TreeviewContextMenu, $smallIconsdll, $readen_icon) ;makroslot3
		EndIf

		$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger15)
		If Not @error And IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot4_projecttreecontext", "0") = 1 And IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") = "active" Then
			$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
			$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot4", "1130")
			$readen_icon = Number($readen_icon)
			If $readen_icon = 1 Then $readen_icon = $readen_icon - 1
			$TreeviewContextMenu_makroslot4 = _GUICtrlCreateODMenuItem($name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot4), $TreeviewContextMenu, $smallIconsdll, $readen_icon) ;makroslot4
		EndIf

		$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger16)
		If Not @error And IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot5_projecttreecontext", "0") = 1 And IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") = "active" Then
			$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
			$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot5", "1241")
			$readen_icon = Number($readen_icon)
			If $readen_icon = 1 Then $readen_icon = $readen_icon - 1
			$TreeviewContextMenu_makroslot5 = _GUICtrlCreateODMenuItem($name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot5), $TreeviewContextMenu, $smallIconsdll, $readen_icon) ;makroslot5
		EndIf


		$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger17)
		If Not @error And IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot6_projecttreecontext", "0") = 1 And IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") = "active" Then
			$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
			$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot6", "1345")
			$readen_icon = Number($readen_icon)
			If $readen_icon = 1 Then $readen_icon = $readen_icon - 1
			$TreeviewContextMenu_makroslot6 = _GUICtrlCreateODMenuItem($name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot6), $TreeviewContextMenu, $smallIconsdll, $readen_icon) ;makroslot6
		EndIf

		$sections = IniReadSection($Pfad_zur_Project_ISN, $Section_Trigger18)
		If Not @error And IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "ruleslot7_projecttreecontext", "0") = 1 And IniRead($Pfad_zur_Project_ISN, $sections[1][0], "status", "active") = "active" Then
			$name = IniRead($Pfad_zur_Project_ISN, $sections[1][0], "name", "")
			$readen_icon = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "icon_ruleslot7", "1456")
			$readen_icon = Number($readen_icon)
			If $readen_icon = 1 Then $readen_icon = $readen_icon - 1
			$TreeviewContextMenu_makroslot7 = _GUICtrlCreateODMenuItem($name & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Makroslot7), $TreeviewContextMenu, $smallIconsdll, $readen_icon) ;makroslot7
		EndIf

	EndIf


	If $TreeviewContextMenu_makroslot1 <> "" Or $TreeviewContextMenu_makroslot2 <> "" Or $TreeviewContextMenu_makroslot3 <> "" Or $TreeviewContextMenu_makroslot4 <> "" Or $TreeviewContextMenu_makroslot5 <> "" Or $TreeviewContextMenu_makroslot6 <> "" Or $TreeviewContextMenu_makroslot7 <> "" Then _GUICtrlCreateODMenuItem("", $TreeviewContextMenu)

	Global $TreeviewContextMenu_Item6 = _GUICtrlCreateODMenuItem(_Get_langstr(72), $TreeviewContextMenu, $smallIconsdll, 378) ;import
	Global $TreeviewContextMenu_Item6a = _GUICtrlCreateODMenuItem(_Get_langstr(455), $TreeviewContextMenu, $smallIconsdll, 1090) ;importfolder
	Global $TreeviewContextMenu_Item7 = _GUICtrlCreateODMenuItem(_Get_langstr(73), $TreeviewContextMenu, $smallIconsdll, 416) ;export
	_GUICtrlCreateODMenuItem("", $TreeviewContextMenu)
	Global $TreeviewContextMenu_Item8 = _GUICtrlCreateODMenu(_Get_langstr(77), $TreeviewContextMenu, $smallIconsdll, 1283) ;neu
	Global $TreeviewContextMenu_Item8_Item1 = _GUICtrlCreateODMenu(_Get_langstr(70), $TreeviewContextMenu_Item8, $smallIconsdll, 1283) ;file
	Global $TreeviewContextMenu_Item8_a = _GUICtrlCreateODMenuItem(_Get_langstr(154), $TreeviewContextMenu_Item8_Item1, $smallIconsdll, 1788, 1) ;au3 file
	Global $TreeviewContextMenu_temp_au3_file = _GUICtrlCreateODMenuItem(_Get_langstr(1094), $TreeviewContextMenu_Item8_Item1, $smallIconsdll, 1788, 1) ;temp au3 file
	Global $TreeviewContextMenu_Item8_b = _GUICtrlCreateODMenuItem(_Get_langstr(153), $TreeviewContextMenu_Item8_Item1, $smallIconsdll, 781, 1) ;isf file
	Global $TreeviewContextMenu_Item8_c = _GUICtrlCreateODMenuItem(_Get_langstr(155), $TreeviewContextMenu_Item8_Item1, $smallIconsdll, 1177, 1) ;ini file
	Global $TreeviewContextMenu_Item8_d = _GUICtrlCreateODMenuItem(_Get_langstr(156), $TreeviewContextMenu_Item8_Item1, $smallIconsdll, 1178, 1) ;txt file
	Global $TreeviewContextMenu_Item8_Item2 = _GUICtrlCreateODMenuItem(_Get_langstr(71), $TreeviewContextMenu_Item8, $smallIconsdll, 1344, 1) ;folder
EndFunc   ;==>_Erstelle_Kontextmenu_fuer_Projektbaum

Func _neuer_changelog_eintrag_Radio_Toggle()
	If GUICtrlRead($neuer_changelog_eintrag_radio1) = $GUI_CHECKED Then
		GUICtrlSetState($neuer_changelog_eintrag_bearbeiter_input, $GUI_DISABLE)
		GUICtrlSetState($neuer_changelog_eintrag_bearbeiter_label, $GUI_DISABLE)
		GUICtrlSetState($neuer_changelog_eintrag_datum_input, $GUI_DISABLE)
		GUICtrlSetState($neuer_changelog_eintrag_datum_label, $GUI_DISABLE)
		GUICtrlSetState($neuer_changelog_eintrag_version_checkbox, $GUI_DISABLE)
		GUICtrlSetState($neuer_changelog_eintrag_version_input, $GUI_DISABLE)
		GUICtrlSetState($neuer_changelog_eintrag_betreff_input, $GUI_DISABLE)
		GUICtrlSetState($neuer_changelog_eintrag_betreff_label, $GUI_DISABLE)
		GUICtrlSetState($neuer_changelog_eintrag_edit, $GUI_DISABLE)
	Else
		GUICtrlSetState($neuer_changelog_eintrag_bearbeiter_input, $GUI_ENABLE)
		GUICtrlSetState($neuer_changelog_eintrag_bearbeiter_label, $GUI_ENABLE)
		GUICtrlSetState($neuer_changelog_eintrag_datum_input, $GUI_ENABLE)
		GUICtrlSetState($neuer_changelog_eintrag_datum_label, $GUI_ENABLE)
		GUICtrlSetState($neuer_changelog_eintrag_version_checkbox, $GUI_ENABLE)
		GUICtrlSetState($neuer_changelog_eintrag_version_input, $GUI_ENABLE)
		GUICtrlSetState($neuer_changelog_eintrag_betreff_input, $GUI_ENABLE)
		GUICtrlSetState($neuer_changelog_eintrag_betreff_label, $GUI_ENABLE)
		GUICtrlSetState($neuer_changelog_eintrag_edit, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_neuer_changelog_eintrag_Radio_Toggle


Func _Zeige_neuer_changelog_eintrag_GUI()
	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "use_changelog_manager", "false") = "false" Then Return
	GUICtrlSetState($neuer_changelog_eintrag_radio1, $GUI_CHECKED)
	GUICtrlSetState($neuer_changelog_eintrag_version_checkbox, $GUI_UNCHECKED)

	If _ProjectISN_Config_Read("changelog_use_author_from_project", "false") = "true" Then
		GUICtrlSetData($neuer_changelog_eintrag_bearbeiter_input, _ProjectISN_Config_Read("author", ""))
	Else
		GUICtrlSetData($neuer_changelog_eintrag_bearbeiter_input, @UserName)
	EndIf

	GUICtrlSetData($neuer_changelog_eintrag_datum_input, @YEAR & "/" & @MON & "/" & @MDAY)
	GUICtrlSetData($neuer_changelog_eintrag_betreff_input, "")
	GUICtrlSetData($neuer_changelog_eintrag_edit, "")
	GUICtrlSetData($neuer_changelog_eintrag_version_input, IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", ""))
	_neuer_changelog_eintrag_Radio_Toggle()
	_CenterOnMonitor($neuer_changelog_eintrag_GUI, "", $Runonmonitor)
	WinSetOnTop($neuer_changelog_eintrag_GUI, "", 1)
	GUISetState(@SW_SHOW, $neuer_changelog_eintrag_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)


	While 1
		$neuer_changelog_eintrag_GUI_state = WinGetState($neuer_changelog_eintrag_GUI, "")
		If Not BitAND($neuer_changelog_eintrag_GUI_state, 2) Then ExitLoop
		Sleep(100)
	WEnd
EndFunc   ;==>_Zeige_neuer_changelog_eintrag_GUI

Func _neuer_changelog_eintrag_OK()
	If GUICtrlRead($neuer_changelog_eintrag_radio2) = $GUI_CHECKED Then
		If GUICtrlRead($neuer_changelog_eintrag_edit) = "" Then
			_Input_Error_FX($neuer_changelog_eintrag_edit)
			Return
		EndIf
	EndIf
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $neuer_changelog_eintrag_GUI)
	If GUICtrlRead($neuer_changelog_eintrag_radio2) = $GUI_CHECKED Then _Changelogeintrag_hinzufuegen()
EndFunc   ;==>_neuer_changelog_eintrag_OK


Func Date_AutoIt_2_German($conv_date)
	$String = ""
	If $conv_date = "" Then Return
	$conv_parts = StringSplit($conv_date, "/", 2)
	If IsArray($conv_parts) Then
		$String = $conv_parts[2] & "." & $conv_parts[1] & "." & $conv_parts[0]
	EndIf
	Return $String
EndFunc   ;==>Date_AutoIt_2_German




Func _Changelogeintrag_hinzufuegen()
	$Project_ISN = $Pfad_zur_Project_ISN
	$NewitemID = @MDAY & @MON & @YEAR & @HOUR & @MIN & @SEC & Random(0, 100, 1)
	$Items_String = IniRead($Pfad_zur_Project_ISN, $Changelog_Section, "items", "")
	$Items_String = $Items_String & $NewitemID & "|"
	IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "items", $Items_String)

	IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "text[" & $NewitemID & "]", StringReplace(GUICtrlRead($neuer_changelog_eintrag_edit), @CRLF, "[BREAK]"))
	If GUICtrlRead($neuer_changelog_eintrag_betreff_input) <> "" Then IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "subject[" & $NewitemID & "]", GUICtrlRead($neuer_changelog_eintrag_betreff_input))
	If GUICtrlRead($neuer_changelog_eintrag_bearbeiter_input) <> "" Then IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "editor[" & $NewitemID & "]", GUICtrlRead($neuer_changelog_eintrag_bearbeiter_input))
	If $Benoetigte_Zeit <> 0 Then IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "time[" & $NewitemID & "]", $Benoetigte_Zeit)
	$Datum_Array = _GUICtrlDTP_GetSystemTime(GUICtrlGetHandle($neuer_changelog_eintrag_datum_input))
	If IsArray($Datum_Array) Then
		IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "date[" & $NewitemID & "]", StringFormat("%04d/%02d/%02d", $Datum_Array[0], $Datum_Array[1], $Datum_Array[2]))
	EndIf
	If GUICtrlRead($neuer_changelog_eintrag_version_checkbox) = $GUI_CHECKED Then
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", GUICtrlRead($neuer_changelog_eintrag_version_input))
		IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "version[" & $NewitemID & "]", GUICtrlRead($neuer_changelog_eintrag_version_input))
	Else
		IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "version[" & $NewitemID & "]", IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", ""))
	EndIf
EndFunc   ;==>_Changelogeintrag_hinzufuegen

Func _sort_changelogmanager_listview()
	_Sortiere_Listview($changelogmanager_listview)
EndFunc   ;==>_sort_changelogmanager_listview

Func _sort_berichtgenerieren_listview()
	_Sortiere_Listview($changelogenerieren_listview)
EndFunc   ;==>_sort_berichtgenerieren_listview

Func _Sortiere_Listview($Listview = "", $Colum = "-1", $Direction = "-1")
	If $Listview = "" Then Return
	If $Colum = "-1" Then $Colum = GUICtrlGetState($Listview)
	If $Direction <> "-1" Then
		_GUICtrlListView_UnRegisterSortCallBack($Listview)
		_Sortiere_Listview($Listview, $Colum)
	EndIf
	_GUICtrlListView_RegisterSortCallBack($Listview)
	_GUICtrlListView_SortItems($Listview, $Colum)
EndFunc   ;==>_Sortiere_Listview


Func _Aenderungsmanager_Aktualisiere_Liste($handle = $changelogmanager_listview)
	If $Offenes_Projekt = "" Then Return
	Local $Gesamtzeit = 0
	Local $Geladene_Objekte = 0
	Local $Secs, $Mins, $Hour
	$ISN_Datei = $Pfad_zur_Project_ISN
	$Items_String = IniRead($Pfad_zur_Project_ISN, $Changelog_Section, "items", "")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($handle))
	_GUICtrlListView_BeginUpdate($handle)
	$Item_Array = StringSplit($Items_String, "|", 2)
	If IsArray($Item_Array) Then
		For $x = 0 To UBound($Item_Array) - 1
			If $Item_Array[$x] = "|" Then ContinueLoop
			If $Item_Array[$x] = "" Then ContinueLoop
			If $Item_Array[$x] = " " Then ContinueLoop
			$Geladene_Objekte = $Geladene_Objekte + 1
			_GUICtrlListView_AddItem($handle, IniRead($ISN_Datei, $Changelog_Section, "date[" & $Item_Array[$x] & "]", ""), -1, _GUICtrlListView_GetItemCount($handle) + 9999) ;Fix für Sortierung
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, IniRead($ISN_Datei, $Changelog_Section, "subject[" & $Item_Array[$x] & "]", ""), 1)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, StringReplace(IniRead($ISN_Datei, $Changelog_Section, "text[" & $Item_Array[$x] & "]", ""), "[BREAK]", " "), 2)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, IniRead($ISN_Datei, $Changelog_Section, "version[" & $Item_Array[$x] & "]", ""), 3)
			$Zeitms = IniRead($ISN_Datei, $Changelog_Section, "time[" & $Item_Array[$x] & "]", 0)
			$Gesamtzeit = $Gesamtzeit + $Zeitms
			_TicksToTime($Zeitms, $Hour, $Mins, $Secs)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $Hour & "h " & $Mins & "m " & $Secs & "s", 4)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, IniRead($ISN_Datei, $Changelog_Section, "editor[" & $Item_Array[$x] & "]", ""), 5)
			_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $Item_Array[$x], 6) ;ID
			_Sortiere_Listview($handle, 0, 1) ;Sortiere nach englischem Datum
		Next
		;Ersetze Englisches Datum durch Deutsches
		If $Languagefile = "german.lng" Then
			For $y = 0 To _GUICtrlListView_GetItemCount($handle) - 1
				$Datum = _GUICtrlListView_GetItemText($handle, $y, 0)
				$Datum = Date_AutoIt_2_German($Datum)
				_GUICtrlListView_SetItemText($handle, $y, $Datum, 0)
			Next
		EndIf
	EndIf
	_GUICtrlListView_EndUpdate($handle)
	GUICtrlSetData($changelogmanager_geladene_Objekte_label, $Geladene_Objekte & " " & _Get_langstr(924))
	_TicksToTime($Gesamtzeit, $Hour, $Mins, $Secs)
	GUICtrlSetData($changelogmanager_gesamtzeit_label, _Get_langstr(923) & " " & $Hour & "h " & $Mins & "m " & $Secs & "s")
EndFunc   ;==>_Aenderungsmanager_Aktualisiere_Liste

Func _changelogmanager_lade_eintrag()
	AdlibUnRegister("_changelogmanager_lade_eintrag")
	Local $Secs, $Mins, $Hour
	$ISN_Datei = $Pfad_zur_Project_ISN
	If _GUICtrlListView_GetSelectionMark($changelogmanager_listview) = -1 Then
		GUICtrlSetState($changelogmanager_datum_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_bearbeiter_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_betreff_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_version_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_text_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_uebernehmen_button, $GUI_DISABLE)
		GUICtrlSetData($changelogmanager_datum_input, "")
		GUICtrlSetData($changelogmanager_bearbeiter_input, "")
		GUICtrlSetData($changelogmanager_betreff_input, "")
		GUICtrlSetData($changelogmanager_zeit_input, "")
		GUICtrlSetData($changelogmanager_version_input, "")
		GUICtrlSetData($changelogmanager_text_input, "")
		GUICtrlSetData($changelogmanager_zeit_h, "")
		GUICtrlSetData($changelogmanager_zeit_m, "")
		GUICtrlSetData($changelogmanager_zeit_s, "")
		GUICtrlSetState($changelogmanager_version_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_datum_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_betreff_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_bearbeiter_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_h, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_m, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_s, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_h_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_m_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_s_label, $GUI_DISABLE)
		Return
	Else
		$Section_ID = _GUICtrlListView_GetItemText($changelogmanager_listview, _GUICtrlListView_GetSelectionMark($changelogmanager_listview), 6)
		If $Section_ID = "" Then Return
		GUICtrlSetState($changelogmanager_datum_input, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_bearbeiter_input, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_betreff_input, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_input, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_version_input, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_text_input, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_uebernehmen_button, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_version_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_datum_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_betreff_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_bearbeiter_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_h, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_m, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_s, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_h_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_m_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_s_label, $GUI_ENABLE)
		GUICtrlSetData($changelogmanager_datum_input, IniRead($ISN_Datei, $Changelog_Section, "date[" & $Section_ID & "]", ""))
		GUICtrlSetData($changelogmanager_bearbeiter_input, IniRead($ISN_Datei, $Changelog_Section, "editor[" & $Section_ID & "]", ""))
		GUICtrlSetData($changelogmanager_betreff_input, IniRead($ISN_Datei, $Changelog_Section, "subject[" & $Section_ID & "]", ""))
		GUICtrlSetData($changelogmanager_zeit_input, IniRead($ISN_Datei, $Changelog_Section, "time[" & $Section_ID & "]", "0"))
		_TicksToTime(GUICtrlRead($changelogmanager_zeit_input), $Hour, $Mins, $Secs)
		GUICtrlSetData($changelogmanager_zeit_h, $Hour)
		GUICtrlSetData($changelogmanager_zeit_m, $Mins)
		GUICtrlSetData($changelogmanager_zeit_s, $Secs)
		GUICtrlSetData($changelogmanager_version_input, IniRead($ISN_Datei, $Changelog_Section, "version[" & $Section_ID & "]", ""))
		GUICtrlSetData($changelogmanager_text_input, StringReplace(IniRead($ISN_Datei, $Changelog_Section, "text[" & $Section_ID & "]", ""), "[BREAK]", @CRLF))

	EndIf

EndFunc   ;==>_changelogmanager_lade_eintrag

Func _changelogmanager_eintrag_loeschen()
	If _GUICtrlListView_GetSelectionMark($changelogmanager_listview) = -1 Then Return
	$Section_ID = _GUICtrlListView_GetItemText($changelogmanager_listview, _GUICtrlListView_GetSelectionMark($changelogmanager_listview), 6)
	If $Section_ID = "" Then Return
	$ISN_Datei = $Pfad_zur_Project_ISN
	$Items_String = IniRead($Pfad_zur_Project_ISN, $Changelog_Section, "items", "")
	$Antwort = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(932), 0, $aenderungs_manager_GUI)
	If $Antwort = 6 Then
		IniDelete($ISN_Datei, $Changelog_Section, "subject[" & $Section_ID & "]")
		IniDelete($ISN_Datei, $Changelog_Section, "text[" & $Section_ID & "]")
		IniDelete($ISN_Datei, $Changelog_Section, "time[" & $Section_ID & "]")
		IniDelete($ISN_Datei, $Changelog_Section, "editor[" & $Section_ID & "]")
		IniDelete($ISN_Datei, $Changelog_Section, "version[" & $Section_ID & "]")
		IniDelete($ISN_Datei, $Changelog_Section, "date[" & $Section_ID & "]")
		$Items_String = StringReplace($Items_String, $Section_ID, "")
		$Items_String = StringReplace($Items_String, "||", "|")
		IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "items", $Items_String)
		_Aenderungsmanager_Aktualisiere_Liste()
	EndIf
EndFunc   ;==>_changelogmanager_eintrag_loeschen

Func _changelogmanager_alle_eintraege_loeschen()
	$ISN_Datei = $Pfad_zur_Project_ISN
	$Antwort = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(971), 0, $aenderungs_manager_GUI)
	If $Antwort = 6 Then
		IniDelete($ISN_Datei, $Changelog_Section)
		_Aenderungsmanager_Aktualisiere_Liste()
	EndIf
EndFunc   ;==>_changelogmanager_alle_eintraege_loeschen

Func _changelogmanager_eintrag_aendern()
	If _GUICtrlListView_GetSelectionMark($changelogmanager_listview) = -1 Then Return
	$Section_ID = _GUICtrlListView_GetItemText($changelogmanager_listview, _GUICtrlListView_GetSelectionMark($changelogmanager_listview), 6)
	If $Section_ID = "" Then Return
	$Alte_Selection = _GUICtrlListView_GetSelectionMark($changelogmanager_listview)
	$ISN_Datei = $Pfad_zur_Project_ISN
	GUICtrlSetData($changelogmanager_zeit_input, _TimeToTicks(GUICtrlRead($changelogmanager_zeit_h), GUICtrlRead($changelogmanager_zeit_m), GUICtrlRead($changelogmanager_zeit_s)))
	IniWrite($ISN_Datei, $Changelog_Section, "text[" & $Section_ID & "]", StringReplace(GUICtrlRead($changelogmanager_text_input), @CRLF, "[BREAK]"))
	IniWrite($ISN_Datei, $Changelog_Section, "subject[" & $Section_ID & "]", GUICtrlRead($changelogmanager_betreff_input))
	IniWrite($ISN_Datei, $Changelog_Section, "editor[" & $Section_ID & "]", GUICtrlRead($changelogmanager_bearbeiter_input))
	IniWrite($ISN_Datei, $Changelog_Section, "time[" & $Section_ID & "]", GUICtrlRead($changelogmanager_zeit_input))
	IniWrite($ISN_Datei, $Changelog_Section, "version[" & $Section_ID & "]", GUICtrlRead($changelogmanager_version_input))
	$Datum_Array = _GUICtrlDTP_GetSystemTime(GUICtrlGetHandle($changelogmanager_datum_input))
	If IsArray($Datum_Array) Then
		IniWrite($ISN_Datei, $Changelog_Section, "date[" & $Section_ID & "]", StringFormat("%04d/%02d/%02d", $Datum_Array[0], $Datum_Array[1], $Datum_Array[2]))
	EndIf
	_Aenderungsmanager_Aktualisiere_Liste()
	_GUICtrlListView_SetItemSelected($changelogmanager_listview, $Alte_Selection, True, True)
	_changelogmanager_lade_eintrag()
EndFunc   ;==>_changelogmanager_eintrag_aendern

Func _changelogmanager_resize()
	$Fixe_Breiten = 70 + 150 + 60 + 90 + 110
	$Listview_groesse = ControlGetPos($aenderungs_manager_GUI, "", $changelogmanager_listview)
	If Not IsArray($Listview_groesse) Then Return
	$Neue_Textbreite = $Listview_groesse[2] - $Fixe_Breiten - 40
	_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 2, $Neue_Textbreite)
EndFunc   ;==>_changelogmanager_resize

Func _Toggle_Changelogmanager()
	If GUICtrlRead($changelogmanager_protokolle_verwenden_checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($changelogmanager_listview, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_neu_button, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_loeschen_button, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_gesamtzeit_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_geladene_Objekte_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_export_button, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_import_button, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_uebernehmen_button, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_version_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_datum_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_betreff_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_bearbeiter_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_h_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_m_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_zeit_s_label, $GUI_ENABLE)
		GUICtrlSetState($changelogmanager_allesloeschen_button, $GUI_ENABLE)
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "use_changelog_manager", "true")
	Else
		GUICtrlSetState($changelogmanager_datum_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_bearbeiter_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_betreff_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_version_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_text_input, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_listview, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_neu_button, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_loeschen_button, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_gesamtzeit_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_geladene_Objekte_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_export_button, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_import_button, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_uebernehmen_button, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_version_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_datum_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_betreff_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_bearbeiter_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_h_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_m_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_s_label, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_h, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_m, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_zeit_s, $GUI_DISABLE)
		GUICtrlSetState($changelogmanager_allesloeschen_button, $GUI_DISABLE)
		IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "use_changelog_manager", "false")
	EndIf

EndFunc   ;==>_Toggle_Changelogmanager


Func _Zeige_changelogmanager()
	If $Offenes_Projekt = "" Then Return
	If $Studiomodus = 2 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(670), 0, $Studiofenster)
		Return
	EndIf
	GUISetState(@SW_DISABLE, $Studiofenster)
	_Aenderungsmanager_Aktualisiere_Liste()
	_changelogmanager_lade_eintrag()
	If IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "use_changelog_manager", "false") = "true" Then
		GUICtrlSetState($changelogmanager_protokolle_verwenden_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($changelogmanager_protokolle_verwenden_checkbox, $GUI_UNCHECKED)
	EndIf
	_Toggle_Changelogmanager()
	GUISetState(@SW_SHOW, $aenderungs_manager_GUI)
EndFunc   ;==>_Zeige_changelogmanager

Func _HIDE_changelogmanager()
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $aenderungs_manager_GUI)
EndFunc   ;==>_HIDE_changelogmanager

Func _Bericht_standardlayout_wiederherstellen()
	$text = _Hole_Standardvorlage_fuer_bericht()
	$text = StringReplace($text, "[BREAK]", @CRLF)
	GUICtrlSetData($berichtgenerieren_aufbauedit, $text)
EndFunc   ;==>_Bericht_standardlayout_wiederherstellen

Func _SHOW_bericht_generieren_GUI()
	GUISetState(@SW_SHOW, $changelog_generieren_GUI)
	GUISetState(@SW_DISABLE, $aenderungs_manager_GUI)
	GUICtrlSetData($berichtgenerieren_vorschaufenster, "")
	GUICtrlSetData($berichtgenerieren_aufbauedit, "")
	$text = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "changelog_manager_report_layout", _Hole_Standardvorlage_fuer_bericht())
	$text = StringReplace($text, "[BREAK]", @CRLF)
	GUICtrlSetData($berichtgenerieren_aufbauedit, $text)
	_Aenderungsmanager_Aktualisiere_Liste($changelogenerieren_listview)
	_Bericht_generieren_dropdowns_befuellen()
EndFunc   ;==>_SHOW_bericht_generieren_GUI

Func _HIDE_bericht_generieren_GUI()
	GUISetState(@SW_ENABLE, $aenderungs_manager_GUI)
	GUISetState(@SW_HIDE, $changelog_generieren_GUI)
	;Sepeichere Layout
	$text = StringReplace(GUICtrlRead($berichtgenerieren_aufbauedit), @CRLF, "[BREAK]")
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "changelog_manager_report_layout", $text)
	_Bericht_verstecke_hilfe()
EndFunc   ;==>_HIDE_bericht_generieren_GUI

Func _Bericht_generieren_alles_makieren()
	If _GUICtrlListView_GetItemCount($changelogenerieren_listview) = 0 Then Return
	For $y = 0 To _GUICtrlListView_GetItemCount($changelogenerieren_listview) - 1
		_GUICtrlListView_SetItemChecked($changelogenerieren_listview, $y, True)
	Next
EndFunc   ;==>_Bericht_generieren_alles_makieren

Func _Bericht_generieren_alles_abmakieren()
	If _GUICtrlListView_GetItemCount($changelogenerieren_listview) = 0 Then Return
	For $y = 0 To _GUICtrlListView_GetItemCount($changelogenerieren_listview) - 1
		_GUICtrlListView_SetItemChecked($changelogenerieren_listview, $y, False)
	Next
EndFunc   ;==>_Bericht_generieren_alles_abmakieren

Func _Bericht_generieren_dropdowns_befuellen()
	GUICtrlSetData($berichtgenerieren_bearbeiter_combo, "", "")
	GUICtrlSetData($berichtgenerieren_version_combo, "", "")
	If _GUICtrlListView_GetItemCount($changelogenerieren_listview) = 0 Then Return
	Dim $Eintraege_Version[1]
	Dim $Eintraege_Bearbeiter[1]
	For $y = 0 To _GUICtrlListView_GetItemCount($changelogenerieren_listview) - 1
		_ArrayAdd($Eintraege_Version, _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 3))
		_ArrayAdd($Eintraege_Bearbeiter, _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 5))
	Next
	_ArrayDelete($Eintraege_Version, 0)
	_ArrayDelete($Eintraege_Bearbeiter, 0)
	$Eintraege_Version = _ArrayUnique($Eintraege_Version)
	$Eintraege_Bearbeiter = _ArrayUnique($Eintraege_Bearbeiter)
	_ArrayDelete($Eintraege_Version, 0)
	_ArrayDelete($Eintraege_Bearbeiter, 0)

	If IsArray($Eintraege_Version) Then
		$Datenstring = _ArrayToString($Eintraege_Version, "|")
		GUICtrlSetData($berichtgenerieren_version_combo, $Datenstring, "")
	EndIf

	If IsArray($Eintraege_Bearbeiter) Then
		$Datenstring = _ArrayToString($Eintraege_Bearbeiter, "|")
		GUICtrlSetData($berichtgenerieren_bearbeiter_combo, $Datenstring, "")
	EndIf
EndFunc   ;==>_Bericht_generieren_dropdowns_befuellen

Func _Bericht_generieren_makiere_elemente_nach_vorgabe($Spalte = 0, $text = "")
	If _GUICtrlListView_GetItemCount($changelogenerieren_listview) = 0 Then Return
	For $y = 0 To _GUICtrlListView_GetItemCount($changelogenerieren_listview) - 1
		If StringInStr(_GUICtrlListView_GetItemText($changelogenerieren_listview, $y, $Spalte), $text) Or _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, $Spalte) = $text Then
			_GUICtrlListView_SetItemChecked($changelogenerieren_listview, $y, True)
		Else
			_GUICtrlListView_SetItemChecked($changelogenerieren_listview, $y, False)
		EndIf
	Next
EndFunc   ;==>_Bericht_generieren_makiere_elemente_nach_vorgabe

Func _Bericht_generieren_versioncombo_select()
	_Bericht_generieren_makiere_elemente_nach_vorgabe(3, GUICtrlRead($berichtgenerieren_version_combo))
EndFunc   ;==>_Bericht_generieren_versioncombo_select

Func _Bericht_generieren_bearbeitercombo_select()
	_Bericht_generieren_makiere_elemente_nach_vorgabe(5, GUICtrlRead($berichtgenerieren_bearbeiter_combo))
EndFunc   ;==>_Bericht_generieren_bearbeitercombo_select

Func _Bericht_generieren_datum_select()
	$Datum_Array = _GUICtrlDTP_GetSystemTime(GUICtrlGetHandle($berichtgenerieren_datum))
	If IsArray($Datum_Array) Then
		If $Languagefile = "german.lng" Then
			_Bericht_generieren_makiere_elemente_nach_vorgabe(0, StringFormat("%02d.%02d.%04d", $Datum_Array[2], $Datum_Array[1], $Datum_Array[0]))
		Else
			_Bericht_generieren_makiere_elemente_nach_vorgabe(0, StringFormat("%04d/%02d/%02d", $Datum_Array[0], $Datum_Array[1], $Datum_Array[2]))
		EndIf
	EndIf
EndFunc   ;==>_Bericht_generieren_datum_select

Func _Bericht_generieren()
	GUICtrlSetData($berichtgenerieren_vorschaufenster, "")
	If _GUICtrlListView_GetItemCount($changelogenerieren_listview) = 0 Then Return
	$ISN_Datei = $Pfad_zur_Project_ISN
	$Rohe_Vorlage = GUICtrlRead($berichtgenerieren_aufbauedit)
	$Rohe_Vorlage = StringReplace($Rohe_Vorlage, @CRLF, "[BREAK]")
	$Vorlage_Itemsbereich = ""
	$Fertiger_Itemsbereich = ""
	$Itemsbereich_Array = _StringBetween($Rohe_Vorlage, "<items>", "</items>")
	If IsArray($Itemsbereich_Array) Then
		$Vorlage_Itemsbereich = $Itemsbereich_Array[0]
		$Rohe_Vorlage = StringReplace($Rohe_Vorlage, $Itemsbereich_Array[0], "#ITEMSHERE#")

		For $y = 0 To _GUICtrlListView_GetItemCount($changelogenerieren_listview) - 1
			If _GUICtrlListView_GetItemChecked($changelogenerieren_listview, $y) = True Then
				$Section_ID = _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 6)
				$Bereich = $Vorlage_Itemsbereich
				$Bereich = StringReplace($Bereich, "%version%", _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 3))
				$Bereich = StringReplace($Bereich, "%id%", _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 6))
				$Bereich = StringReplace($Bereich, "%editor%", _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 5))
				$Bereich = StringReplace($Bereich, "%time%", _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 4))
				$Bereich = StringReplace($Bereich, "%date%", _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 0))
				$Bereich = StringReplace($Bereich, "%subject%", _GUICtrlListView_GetItemText($changelogenerieren_listview, $y, 1))
				$Bereich = StringReplace($Bereich, "%text%", IniRead($ISN_Datei, $Changelog_Section, "text[" & $Section_ID & "]", ""))
				$Fertiger_Itemsbereich = $Fertiger_Itemsbereich & $Bereich
			EndIf
		Next
	EndIf




	$Rohe_Vorlage = StringReplace($Rohe_Vorlage, "#ITEMSHERE#", $Fertiger_Itemsbereich)
	$Rohe_Vorlage = StringReplace($Rohe_Vorlage, "%projectname%", IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", ""))
	$Rohe_Vorlage = StringReplace($Rohe_Vorlage, "%studioversion%", $Studioversion)
	$Rohe_Vorlage = StringReplace($Rohe_Vorlage, "%projectversion%", IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", ""))


	$Rohe_Vorlage = StringReplace($Rohe_Vorlage, "<items>", "")
	$Rohe_Vorlage = StringReplace($Rohe_Vorlage, "</items>", "")
	$Rohe_Vorlage = StringReplace($Rohe_Vorlage, "[BREAK]", @CRLF)
	GUICtrlSetData($berichtgenerieren_vorschaufenster, $Rohe_Vorlage)
EndFunc   ;==>_Bericht_generieren


Func _Hole_Standardvorlage_fuer_bericht()
	$String = ""
	$String = $String & "%projectname% v. %projectversion% - " & _Get_langstr(939) & @CRLF
	$String = $String & "------------------------------------------------------------------" & @CRLF
	$String = $String & "<items>" & @CRLF
	$String = $String & "/////////////////////////////////////////" & @CRLF
	$String = $String & "///" & _Get_langstr(921) & " %date%" & @CRLF
	$String = $String & "///" & _Get_langstr(918) & " %subject%" & @CRLF
	$String = $String & "///" & _Get_langstr(920) & " %editor%" & @CRLF
	$String = $String & "/////////////////////////////////////////" & @CRLF
	$String = $String & "%text%" & @CRLF
	$String = $String & "</items>" & @CRLF
	$String = $String & "------------------------------------------------------------------" & @CRLF
	$String = $String & _Get_langstr(30) & " %studioversion%"
	Return $String
EndFunc   ;==>_Hole_Standardvorlage_fuer_bericht

Func _Bericht_generieren_speichern_unter()
	_Bericht_generieren()
	If GUICtrlRead($berichtgenerieren_vorschaufenster) = "" Then Return
	_Lock_Plugintabs("lock")
	$line = FileSaveDialog(_Get_langstr(313), $Offenes_Projekt, "Textfile (*.txt)", 18, "report.txt", $changelog_generieren_GUI)
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	If $line = "" Then Return
	If @error > 0 Then Return
	$file = FileOpen($line, 2 + $FO_ANSI)
	If $file = -1 Then Return
	FileWrite($file, GUICtrlRead($berichtgenerieren_vorschaufenster))
	FileClose($file)
	MsgBox(262144 + 64, _Get_langstr(61), StringTrimLeft($line, StringInStr($line, "\", 0, -1)) & " " & _Get_langstr(691), 0, $changelog_generieren_GUI)
	;_Update_Treeview()
EndFunc   ;==>_Bericht_generieren_speichern_unter

Func _aenderungsprotokolle_exportieren()
	$ISN_Datei = $Pfad_zur_Project_ISN
	_Lock_Plugintabs("lock")
	$line = FileSaveDialog(_Get_langstr(313), $Offenes_Projekt, "INI File (*.ini)", 18, "export.ini", $aenderungs_manager_GUI)
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	If $line = "" Then Return
	If @error > 0 Then Return

	$section = IniReadSection($ISN_Datei, $Changelog_Section)
	If @error > 0 Then Return
	IniWriteSection($line, $Changelog_Section, $section)
	MsgBox(262144 + 64, _Get_langstr(61), StringTrimLeft($line, StringInStr($line, "\", 0, -1)) & " " & _Get_langstr(691), 0, $aenderungs_manager_GUI)
	;_Update_Treeview()
EndFunc   ;==>_aenderungsprotokolle_exportieren

Func _Bericht_zeige_hilfe()
	GUISetState(@SW_SHOW, $aenderungsbericht_hilfeGUI)
EndFunc   ;==>_Bericht_zeige_hilfe

Func _Bericht_verstecke_hilfe()
	GUISetState(@SW_HIDE, $aenderungsbericht_hilfeGUI)
EndFunc   ;==>_Bericht_verstecke_hilfe

Func _aenderungsprotokolle_importieren()
	$ISN_Datei = $Pfad_zur_Project_ISN
	$Antwort = MsgBox(262144 + 4 + 48, _Get_langstr(394), _Get_langstr(949), 0, $aenderungs_manager_GUI)
	If $Antwort = 6 Then
		_Lock_Plugintabs("lock")
		$line = FileOpenDialog(_Get_langstr(313), $Offenes_Projekt, "INI File (*.ini)", 3, "", $aenderungs_manager_GUI)
		_Lock_Plugintabs("unlock")
		FileChangeDir(@ScriptDir)
		If $line = "" Then Return
		If @error > 0 Then Return

		$section = IniReadSection($line, $Changelog_Section)
		If @error > 0 Then Return
		IniDelete($ISN_Datei, $Changelog_Section)
		IniWriteSection($ISN_Datei, $Changelog_Section, $section)
		_Zeige_changelogmanager()
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(591), 0, $aenderungs_manager_GUI)
	EndIf
EndFunc   ;==>_aenderungsprotokolle_importieren

Func _Neuen_Changelogeintrag_erstellen()
	$Project_ISN = $Pfad_zur_Project_ISN
	$NewitemID = @MDAY & @MON & @YEAR & @HOUR & @MIN & @SEC & Random(0, 100, 1)
	$Items_String = IniRead($Pfad_zur_Project_ISN, $Changelog_Section, "items", "")
	$Items_String = $Items_String & $NewitemID & "|"
	IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "items", $Items_String)
	IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "text[" & $NewitemID & "]", "")
	IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "date[" & $NewitemID & "]", @YEAR & "/" & @MON & "/" & @MDAY)
	IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "editor[" & $NewitemID & "]", @UserName)
	IniWrite($Pfad_zur_Project_ISN, $Changelog_Section, "version[" & $NewitemID & "]", IniRead($Project_ISN, "ISNAUTOITSTUDIO", "version", ""))
	_Aenderungsmanager_Aktualisiere_Liste()
	If _GUICtrlListView_GetItemCount($changelogmanager_listview) = 0 Then Return
	For $y = 0 To _GUICtrlListView_GetItemCount($changelogmanager_listview) - 1
		$Section_ID = _GUICtrlListView_GetItemText($changelogmanager_listview, $y, 6)
		If $Section_ID = $NewitemID Then
			_GUICtrlListView_SetItemSelected($changelogmanager_listview, $y, True, True)
			ExitLoop
		EndIf
	Next
	_changelogmanager_lade_eintrag()
	GUICtrlSetState($changelogmanager_betreff_input, $GUI_FOCUS)
EndFunc   ;==>_Neuen_Changelogeintrag_erstellen


Func _ProcessSuspend($Process)
	$processid = ProcessExists($Process)
	If $processid Then
		$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
		$i_sucess = DllCall("ntdll.dll", "int", "NtSuspendProcess", "int", $ai_Handle[0])
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		If IsArray($i_sucess) Then
			Return 1
		Else
			SetError(1)
			Return 0
		EndIf
	Else
		SetError(2)
		Return 0
	EndIf
EndFunc   ;==>_ProcessSuspend

Func _ProcessResume($Process)
	$processid = ProcessExists($Process)
	If $processid Then
		$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
		$i_sucess = DllCall("ntdll.dll", "int", "NtResumeProcess", "int", $ai_Handle[0])
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		If IsArray($i_sucess) Then
			Return 1
		Else
			SetError(1)
			Return 0
		EndIf
	Else
		SetError(2)
		Return 0
	EndIf
EndFunc   ;==>_ProcessResume

;===============================================================================
;
; Function Name:    _FileInUse()
; Description:      Checks if file is in use
; Syntax.........: _FileInUse($sFilename, $iAccess = 1)
; Parameter(s):     $sFilename = File name
; Parameter(s):     $iAccess = 0 = GENERIC_READ - other apps can have file open in readonly mode
;                   $iAccess = 1 = GENERIC_READ|GENERIC_WRITE - exclusive access to file,
;                   fails if file open in readonly mode by app
; Return Value(s):  1 - file in use (@error contains system error code)
;                   0 - file not in use
;                   -1 dllcall error (@error contains dllcall error code)
; Author:           Siao
; Modified          rover - added some additional error handling, access mode
; Remarks           _WinAPI_CreateFile() WinAPI.au3
;===============================================================================
Func _FileInUse($sFilename, $iAccess = 0)
	If _IsDir($sFilename) Then Return 0
	$sFilename = FileGetShortName($sFilename)
	Local $aRet, $hFile, $iError, $iDA
	Local Const $GENERIC_WRITE = 0x40000000
	Local Const $GENERIC_READ = 0x80000000
	Local Const $FILE_ATTRIBUTE_NORMAL = 0x80
	Local Const $OPEN_EXISTING = 3
	$iDA = $GENERIC_READ
	If BitAND($iAccess, 1) <> 0 Then $iDA = BitOR($GENERIC_READ, $GENERIC_WRITE)
	$aRet = DllCall("Kernel32.dll", "hwnd", "CreateFile", _
			"str", $sFilename, _ ;lpFileName
			"dword", $iDA, _ ;dwDesiredAccess
			"dword", 0x00000000, _ ;dwShareMode = DO NOT SHARE
			"dword", 0x00000000, _ ;lpSecurityAttributes = NULL
			"dword", $OPEN_EXISTING, _ ;dwCreationDisposition = OPEN_EXISTING
			"dword", $FILE_ATTRIBUTE_NORMAL, _ ;dwFlagsAndAttributes = FILE_ATTRIBUTE_NORMAL
			"hwnd", 0) ;hTemplateFile = NULL
	$iError = @error
	If @error Or IsArray($aRet) = 0 Then Return SetError($iError, 0, -1)
	$hFile = $aRet[0]
	If $hFile = -1 Then ;INVALID_HANDLE_VALUE = -1
		$aRet = DllCall("Kernel32.dll", "int", "GetLastError")
		;ERROR_SHARING_VIOLATION = 32 0x20
		;The process cannot access the file because it is being used by another process.
		If @error Or IsArray($aRet) = 0 Then Return SetError($iError, 0, 1)
		Return SetError($aRet[0], 0, 1)
	Else
		;close file handle
		DllCall("Kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
		Return SetError(@error, 0, 0)
	EndIf
EndFunc   ;==>_FileInUse

Func _Skriptbaum_Zeige_Einstellungen_Popup()
	_GUICtrlMenu_TrackPopupMenu($Skriptbaum_SetupMenu_Handle, $Studiofenster)
EndFunc   ;==>_Skriptbaum_Zeige_Einstellungen_Popup







; #FUNCTION# ====================================================================================================================
; Name ..........: _GUICtrlListView_CreateArray
; Description ...: Creates a 2-dimensional array from a listview.
; Syntax ........: _GUICtrlListView_CreateArray($hListView[, $sDelimeter = '|'])
; Parameters ....: $hListView           - Control ID/Handle to the control
;                  $sDelimeter          - [optional] One or more characters to use as delimiters (case sensitive). Default is '|'.
; Return values .: Success - The array returned is two-dimensional and is made up of the following:
;                                $aArray[0][0] = Number of rows
;                                $aArray[0][1] = Number of columns

;                                $aArray[1][0] = 1st row, 1st column
;                                $aArray[1][1] = 1st row, 2nd column
;                                $aArray[1][2] = 1st row, 3rd column
;                                $aArray[n][0] = nth row, 1st column
;                                $aArray[n][1] = nth row, 2nd column
;                                $aArray[n][2] = nth row, 3rd column
; Author ........: guinness
; Remarks .......: GUICtrlListView.au3 should be included.
; Example .......: Yes
; ===============================================================================================================================
Func _GUICtrlListView_CreateArray($hListView, $sDelimeter = '|')
	If _GUICtrlListView_GetItemCount($hListView) = 0 Then Return
	Local $iColumnCount = _GUICtrlListView_GetColumnCount($hListView), $iDim = 0, $iItemCount = _GUICtrlListView_GetItemCount($hListView)
	If $sDelimeter = Default Then
		$sDelimeter = '|'
	EndIf

	Local $aColumns = 0, $aReturn[$iItemCount][$iColumnCount]

	For $i = 0 To $iItemCount - 1
		For $j = 0 To $iColumnCount - 1
			$aReturn[$i][$j] = _GUICtrlListView_GetItemText($hListView, $i, $j)
		Next
	Next
	Return SetError(Number($aReturn[0][0] = 0), 0, $aReturn)
EndFunc   ;==>_GUICtrlListView_CreateArray



Func _Erweiterte_Plugins_Erstelle_Menue($Liste = "")
	_GUICtrlODMenuItemDelete($Tools_menu_seperator)
	_GUICtrlODMenuItemDelete($Tools_menu_pluginitem1)
	_GUICtrlODMenuItemDelete($Tools_menu_pluginitem2)
	_GUICtrlODMenuItemDelete($Tools_menu_pluginitem3)
	_GUICtrlODMenuItemDelete($Tools_menu_pluginitem4)
	_GUICtrlODMenuItemDelete($Tools_menu_pluginitem5)
	$Tools_menu_pluginitem1 = ""
	$Tools_menu_pluginitem2 = ""
	$Tools_menu_pluginitem3 = ""
	$Tools_menu_pluginitem4 = ""
	$Tools_menu_pluginitem5 = ""
	$Tools_menu_pluginitem6 = ""
	$Tools_menu_pluginitem7 = ""
	$Tools_menu_pluginitem8 = ""
	$Tools_menu_pluginitem9 = ""
	$Tools_menu_pluginitem10 = ""
	$Tools_menu_pluginitem1_exe = ""
	$Tools_menu_pluginitem2_exe = ""
	$Tools_menu_pluginitem3_exe = ""
	$Tools_menu_pluginitem4_exe = ""
	$Tools_menu_pluginitem5_exe = ""
	$Tools_menu_pluginitem6_exe = ""
	$Tools_menu_pluginitem7_exe = ""
	$Tools_menu_pluginitem8_exe = ""
	$Tools_menu_pluginitem9_exe = ""
	$Tools_menu_pluginitem10_exe = ""
	If $Liste = "" Then Return
	$Erweiterte_Plugins_Pfade = StringSplit($Liste, "|", 2)
	If Not IsArray($Erweiterte_Plugins_Pfade) Then Return
	If UBound($Erweiterte_Plugins_Pfade) - 1 > 0 Then $Tools_menu_seperator = _GUICtrlCreateODMenuItem("", $ToolsMenu)
	For $x = 0 To UBound($Erweiterte_Plugins_Pfade) - 1
		If $x > 9 Then ExitLoop ;Nur max 10 Advanced Plugins (Zero based)
		If $Erweiterte_Plugins_Pfade[$x] = "|" Then ContinueLoop
		If $Erweiterte_Plugins_Pfade[$x] = "" Then ContinueLoop
		$Pfad = StringTrimRight($Erweiterte_Plugins_Pfade[$x], StringLen($Erweiterte_Plugins_Pfade[$x]) - StringInStr($Erweiterte_Plugins_Pfade[$x], "\", 0, -1))
		Assign("Tools_menu_pluginitem" & Number($x + 1), _GUICtrlCreateODMenuItem(IniRead($Pfad & "plugin.ini", "plugin", "toolsmenudescription", IniRead($Pfad & "plugin.ini", "plugin", "name", _Get_langstr(962))), $ToolsMenu))
		Assign("Tools_menu_pluginitem" & Number($x + 1) & "_exe", $Erweiterte_Plugins_Pfade[$x])
		$icon = IniRead($Pfad & "plugin.ini", "plugin", "toolsmenuiconid", "193")
		If StringInStr($icon, ".ico") Then
			_GUICtrlODMenuItemSetIcon(Execute("$Tools_menu_pluginitem" & Number($x + 1)), $Pfad & $icon, 0)
		Else
			_GUICtrlODMenuItemSetIcon(Execute("$Tools_menu_pluginitem" & Number($x + 1)), $smallIconsdll, $icon)
		EndIf
	Next
EndFunc   ;==>_Erweiterte_Plugins_Erstelle_Menue

Func _WM_NOTIFY_EDITOR($hWnd, $iMsg, $iwParam, $ilParam)
	If $Can_open_new_tab = 0 Then Return

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	$nID = BitAND($iwParam, 0x0000FFFF)

	;Extraswitch für Listview Events (Parameter Editor)
	Switch $iCode
		Case $NM_CLICK
			If $nID = $ParameterEditor_ListView Then _Parameter_Editor_Listview_select_row()

	EndSwitch


	;-----------------------------------SCRIPTEDITOR
	Local $tagNMHDR, $event
	Local $structNMHDR = DllStructCreate("hwnd hWndFrom;int IDFrom;int Code", $ilParam) ; tagNMHDR
	Local $sClassName = DllCall("User32.dll", "int", "GetClassName", "hwnd", DllStructGetData($structNMHDR, 1), "str", "", "int", 512)

	$sClassName = $sClassName[2]

	If $sClassName <> "Scintilla" Then Return 'GUI_RUNDEFMSG'
	$structNMHDR = DllStructCreate($tagSCNotification, $ilParam)
	If @error Then Return 'GUI_RUNDEFMSG'

	Global $SCI_Zeile
	Local $hwndFrom = DllStructGetData($structNMHDR, 1)
	Local $idFrom = DllStructGetData($structNMHDR, 2)
	Local $event = DllStructGetData($structNMHDR, 3)
	Local $position = DllStructGetData($structNMHDR, 4)
	Local $ch = DllStructGetData($structNMHDR, 5)
	Local $modificationType = DllStructGetData($structNMHDR, 7)


;~ 	#cs
;~
;~ 	  Local $modifiers = DllStructGetData($structNMHDR, 6)
;~ 		Local $char = DllStructGetData($structNMHDR, 8)
;~ 		Local $length = DllStructGetData($structNMHDR, 9)
;~ 		Local $linesAdded = DllStructGetData($structNMHDR, 10)

;~ 		Local $message = DllStructGetData($structNMHDR, 11)
;~ 		Local $uptr_t = DllStructGetData($structNMHDR, 12)
;~ 		Local $sptr_t = DllStructGetData($structNMHDR, 13)
;~ 		Local $Line = DllStructGetData($structNMHDR, 14)

;~ 		Local $foldLevelNow = DllStructGetData($structNMHDR, 15)
;~ 		Local $foldLevelPrev = DllStructGetData($structNMHDR, 16)
;~ 		Local $margin = DllStructGetData($structNMHDR, 17)
;~ 		Local $listType = DllStructGetData($structNMHDR, 18)

;~ 		Local $X = DllStructGetData($structNMHDR, 19)
;~ 		Local $Y = DllStructGetData($structNMHDR, 20)
;~ 	#ce


	Local $Sci = $hwndFrom

	If Not IsHWnd($Sci) Then $Sci = HWnd($Sci)
;~ 	ConsoleWrite("lll" & _WinAPI_GetClassName($Sci) & @CRLF)
	Local $line_number = SendMessage($Sci, $SCI_LINEFROMPOSITION, $position, 0)
	;Current pos to statusbar

	;Nicht beim Debug Editor
	$line = Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci))
	If $Sci <> $Debug_log Then _GUICtrlStatusBar_SetText_ISN($Status_bar, "li=" & $line + 1 & " co=" & (Sci_GetCurrentPos($Sci) - Sci_GetLineStartPos($Sci, $line)) + 1)




	;falls sich aktuelle zeile ändert -> weg mit dem colourpicker
	If Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci)) <> $SCIE_letzte_zeile Then
		$farb_picker_GUIstate = WinGetState($mini_farb_picker_GUI, "")
		If BitAND($farb_picker_GUIstate, 2) Then _Colour_Calltipp_Set_State("hide")
	EndIf
	$SCIE_letzte_zeile = Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci))

	;Select
	;Case $hwndFrom = $Sci
	;If IsHWnd($Sci) Then
	Local $Word, $WordPos, $CurrentLine, $PreviousLine, $Tabs, $TabsAdd, $style, $CurrentPos, $pos, $Replace, $AllVariables, $AllVariablesSplit, $AllWords, $err, $Variable
	Switch $event
	   case $SCN_KEY
		    ConsoleWrite(random(0,232)&" "&$event&@crlf)
		Case $SCN_CALLTIPCLICK


			If SendMessage($Sci, $SCI_CALLTIPACTIVE, 0, 0) Then
				Switch $position

					Case 1
						If IsArray($SCI_sCallTipFoundIndices) And $SCI_sCallTipSelectedIndice > 0 Then
							$SCI_sCallTipSelectedIndice -= 1
							$SCI_sCallTip = Chr(1) & $SCI_sCallTipSelectedIndice + 1 & "/" & UBound($SCI_sCallTipFoundIndices) & Chr(2) & $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[$SCI_sCallTipSelectedIndice]]
							$SCI_sCallTip = StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "([.:])", "$1" & @LF)
							SendMessageString($Sci, $SCI_CALLTIPSHOW, $SCI_sCallTipPos, $SCI_sCallTip)
						EndIf

					Case 2
						If IsArray($SCI_sCallTipFoundIndices) And $SCI_sCallTipSelectedIndice < UBound($SCI_sCallTipFoundIndices) - 1 Then
							$SCI_sCallTipSelectedIndice += 1
							$SCI_sCallTip = Chr(1) & $SCI_sCallTipSelectedIndice + 1 & "/" & UBound($SCI_sCallTipFoundIndices) & Chr(2) & $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[$SCI_sCallTipSelectedIndice]]
							$SCI_sCallTip = StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "([.:])", "$1" & @LF)
							SendMessageString($Sci, $SCI_CALLTIPSHOW, $SCI_sCallTipPos, $SCI_sCallTip)
						EndIf
				EndSwitch
			EndIf

		Case $SCN_DOUBLECLICK

			If $Sci = $Debug_log Then Return
			$Selection = Sci_GetSelection($Sci)
			If IsArray($Selection) Then
				If Sci_GetChar($Sci, $Selection[0] - 1) = "$" Or Sci_GetChar($Sci, $Selection[0] - 1) = "@" Or Sci_GetChar($Sci, $Selection[0] - 1) = "#" Then
					Sci_SetSelection($Sci, $Selection[0] - 1, $Selection[1])
				EndIf
			EndIf

			If $SkriptEditor_Doppelklick_ParameterEditor = "true" And $Tools_Parameter_Editor_aktiviert = "true" Then
				$Aktuelles_Wort_Doppelclick = StringStripWS(SCI_GetTextRange($Sci, $Selection[0], $Selection[1]), 3)
				$Aktuelles_Wort_Doppelclick = StringReplace($Aktuelles_Wort_Doppelclick, "(", "")
				$Aktuelles_Wort_Doppelclick = StringReplace($Aktuelles_Wort_Doppelclick, ")", "")
				_Pruefe_Doppelklickwort_im_Skripteditor($Aktuelles_Wort_Doppelclick, $Selection[1])
			EndIf




		Case $SCN_CHARADDED
			If SendMessage($Sci, $SCI_GETREADONLY, 0, 0) Then

				$ParameterEditor_GUI_State = WinGetState($ParameterEditor_GUI, "")
				If BitAND($ParameterEditor_GUI_State, 2) Then
					$aktuelle_pos_SCE_Window = WinGetPos($Sci)
					$aktuelle_pos = Sci_GetCurrentPos($Sci)
					$x = SendMessage($Sci, $SCI_POINTXFROMPOSITION, 0, $aktuelle_pos) + $aktuelle_pos_SCE_Window[0]
					$y = SendMessage($Sci, $SCI_POINTYFROMPOSITION, 0, $aktuelle_pos) + $aktuelle_pos_SCE_Window[1] + 10
					_ISNTooltip_with_Timer(StringReplace(_Get_langstr(1296), "%1", WinGetTitle($ParameterEditor_GUI)), $x, $y, _Get_langstr(25), 3, 1)
				EndIf

				Return
			EndIf

;~ 			$zuletzt_geschriebenes_wort = SCI_GetWordFromPos($Sci, SendMessage($Sci, $SCI_GETCURRENTPOS, 0, 0), 1)
;~ 			if $zuletzt_geschriebenes_wort = "GUICtrlSetBkColor(" Then
;~ 			$alte_sci_position = Sci_GetCurrentPos($Sci)
;~ 			Sci_AddLines($Sci, @crlf&"EndIf"&@crlf,Sci_GetCurrentLine($Sci)+1)
;~ 			Sci_SetCurrentPos($Sci, $alte_sci_position)
;~ 			endif

			Switch Chr($ch)


				Case "("
;~ 			If Chr($ch) = "(" Then
					If _Is_Comment() Then Return
					;by isi360
					$linechecker = Sci_GetLine($Sci, Sci_GetCurrentLine($Sci) - 1)
					$linechecker = StringReplace($linechecker, " ", "")
					$linechecker = StringReplace($linechecker, @TAB, "")
					If StringInStr($linechecker, "=") Then $linechecker = ""
					$linechecker = StringTrimRight($linechecker, StringLen($linechecker) - 1)

					If $disableintelisense = "false" And $linechecker <> "$" Then
						Local $Ret, $sText, $iPos = SendMessage($Sci, $SCI_GETCURRENTPOS, 0, 0), $sFuncName
						Local $iLen = SendMessage($Sci, $SCI_GETCURLINE, 0, 0)
						$SCI_Zeile = Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci))
						Local $sBuf = DllStructCreate("byte[" & $iLen & "]")
						Local $Ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_GETCURLINE, "int", $iLen, "ptr", DllStructGetPtr($sBuf))
						Local $current = $Ret[0]
						Local $startword = $current
						While $startword > 0 And StringIsAlNum(Chr(DllStructGetData($sBuf, 1, $startword - 1))) Or Chr(DllStructGetData($sBuf, 1, $startword - 1)) = "_"
							$startword -= 1
							$sFuncName = Chr(DllStructGetData($sBuf, 1, $startword)) & $sFuncName
						WEnd
;~ 						$sFuncName = _StringReverse($sFuncName)

						$SCI_sCallTipFoundIndices = ArraySearchAll($SCI_sCallTip_Array, $sFuncName, 0, 0, 1)
						$sBuf = 0
						$SCI_sCallTipSelectedIndice = 0
						$SCI_sCallTip = ""
						If IsArray($SCI_sCallTipFoundIndices) Then

							;$SCI_sCallTip = Chr(1) & "1/" & UBound($SCI_sCallTipFoundIndices) & Chr(2) & $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]]
							$SCI_sCallTip = $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]]

							$SCI_sCallTip = StringReplace(StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "(.{70,110} )", "$1" & @LF), @LF & @LF, @LF)

							$SCI_sCallTipPos = $iPos - StringLen($sFuncName)
							$SCIE_letzter_calltipp = $SCI_sCallTip
							$SCIE_letzte_pos = $SCI_sCallTipPos
							SendMessageString($Sci, $SCI_CALLTIPSHOW, $SCI_sCallTipPos, $SCI_sCallTip)
							$SCI_hlStart = StringInStr($SCI_sCallTip, "(")
							$SCI_hlEnd = StringInStr($SCI_sCallTip, ",")
							If $SCI_hlEnd = 0 Then $SCI_hlEnd = StringInStr($SCI_sCallTip, ")")
							SendMessage($Sci, $SCI_CALLTIPSETHLT, $SCI_hlStart, $SCI_hlEnd)
							Return
						EndIf
					EndIf

;~ 			ElseIf Chr($ch) = "," Then

				Case ","
					If _Is_Comment() Then Return
					If SendMessage($Sci, $SCI_CALLTIPACTIVE, 0, 0) Then
						$SCI_hlStart = $SCI_hlEnd
						Local $iTemp = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ",") + $SCI_hlStart
						If StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart < $iTemp Or $iTemp - $SCI_hlStart = 0 Then
							$SCI_hlEnd = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart
						Else
							$SCI_hlEnd = $iTemp
						EndIf
						SendMessage($Sci, $SCI_CALLTIPSETHLT, $SCI_hlStart, $SCI_hlEnd)
					Else

						;by isi360
						$funcname = _SCI_Funcname_aus_Position($Sci)
						Local $Ret, $sText, $iPos = SendMessage($Sci, $SCI_GETCURRENTPOS, 0, 0), $sFuncName
						$SCI_sCallTipFoundIndices = ArraySearchAll($SCI_sCallTip_Array, $funcname, 0, 0, 1)
						$sBuf = 0
						$SCI_sCallTipSelectedIndice = 0
						$SCI_sCallTip = ""
						If IsArray($SCI_sCallTipFoundIndices) Then

							;$SCI_sCallTip = Chr(1) & "1/" & UBound($SCI_sCallTipFoundIndices) & Chr(2) & $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]]
							$SCI_sCallTip = $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]]

							$SCI_sCallTip = StringReplace(StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "(.{70,110} )", "$1" & @LF), @LF & @LF, @LF)

							$SCI_sCallTipPos = $iPos - StringLen($sFuncName)
							$SCIE_letzter_calltipp = $SCI_sCallTip
							$SCIE_letzte_pos = $SCI_sCallTipPos
							SendMessageString($Sci, $SCI_CALLTIPSHOW, $SCI_sCallTipPos, $SCI_sCallTip)
							$SCI_hlStart = StringInStr($SCI_sCallTip, "(")
							$SCI_hlEnd = StringInStr($SCI_sCallTip, ",")
							If $SCI_hlEnd = 0 Then $SCI_hlEnd = StringInStr($SCI_sCallTip, ")")
							SendMessage($Sci, $SCI_CALLTIPSETHLT, $SCI_hlStart, $SCI_hlEnd)
							Return
						EndIf


;~ 						If Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci)) <> $SCI_Zeile Then Return
;~ 						If $SCI_sCallTip = "" Then Return
;~ 						SendMessageString($Sci, $SCI_CALLTIPSHOW, $SCI_sCallTipPos, $SCI_sCallTip)
;~ 						$linee = Sci_GetLine($Sci, Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci)))
;~ 						StringReplace($linee, ",", "")
;~ 						$SCI_hlStart = StringInStr($SCI_sCallTip, ",", 0, @extended)
;~ 						Local $iTemp = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ",") + $SCI_hlStart
;~ 						If StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart < $iTemp Or $iTemp - $SCI_hlStart = 0 Then
;~ 							$SCI_hlEnd = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart
;~ 						Else
;~ 							$SCI_hlEnd = $iTemp
;~ 						EndIf
;~ 						SendMessage($Sci, $SCI_CALLTIPSETHLT, $SCI_hlStart, $SCI_hlEnd)
;~ 						;end

					EndIf


;~
;~ 			ElseIf Chr($ch) = ")" Then
				Case ")"
					_Colour_Calltipp_Set_State("hide")
;~ 					$SCI_sCallTip = ""
					If SendMessage($Sci, $SCI_CALLTIPACTIVE, 0, 0) Then SendMessage($Sci, $SCI_CALLTIPCANCEL, 0, 0)


;~ 			ElseIf Chr($ch) = @CR Then ; if: enter is pressed / new line created

				Case @LF
					_Colour_Calltipp_Set_State("hide")
					If $Sci = $ParameterEditor_SCIEditor Then
						$Old = Sci_GetText($ParameterEditor_SCIEditor)
;~ 						if $autoit_editor_encoding = "2" then $Old = _ANSI2UNICODE($Old)
						$Old = StringReplace($Old, @CRLF, "")
						$Old = StringReplace($Old, @LF, "")
						$Old = StringReplace($Old, @CR, "")
						Sci_SetText($ParameterEditor_SCIEditor, $Old)
;~ 						If _IsPressed("11", $user32) Then
;~ 							_Parameter_Editor_Parameter_hinzufuegen()
;~ 						EndIf
						Return
					EndIf

				Case @CR
					If $AutoEnd_Keywords = "true" And $Sci <> $ParameterEditor_SCIEditor Then
						BlockInput(1)
						_Autocomplete_nach_Enter($Sci)
					EndIf





					$CurrentLine = SCI_GetCurrentLine($Sci)
					Local $Indent = 0
					$PreviousLine = SCI_GetLine($Sci, $CurrentLine - 2)

					If $PreviousLine = "" Then
						BlockInput(0)
						Return
					EndIf

					;Tab Indent
					If StringInStr($PreviousLine, "then") Or StringInStr($PreviousLine, "while ") Or StringInStr($PreviousLine, "with ") Or StringInStr($PreviousLine, "func ") Or StringInStr($PreviousLine, "for ") Or StringInStr($PreviousLine, "select ") Or StringInStr($PreviousLine, "switch ") Or StringInStr($PreviousLine, "if ") Or StringInStr($PreviousLine, "elseif ") Or StringInStr($PreviousLine, "case") Then $Indent = 1
					If StringStripWS($PreviousLine, 8) = "do" Or StringStripWS($PreviousLine, 8) = "else" Then $Indent = 1
					If StringInStr($PreviousLine, ";") Then $Indent = 0
					If StringInStr($PreviousLine, "return") Then $Indent = 0
					If StringInStr($PreviousLine, "exit") Then $Indent = 0
					If StringInStr($PreviousLine, "exitloop") Then $Indent = 0
;~ 					if StringInStr($PreviousLine, "if ") AND StringInStr($PreviousLine, "(") AND StringInStr($PreviousLine, ")") then $Indent = 0


					$TabsAdd = ""
					$Tabs = StringSplit($PreviousLine, @TAB)

					If $Tabs[0] > 1 Then
						For $i = 1 To $Tabs[0] - 1
							If Not $Tabs[$i] = "" Then ExitLoop
							$TabsAdd &= @TAB

						Next
					EndIf
					If $Indent = 1 Then $TabsAdd = $TabsAdd & @TAB
					SCI_AddLines($Sci, $TabsAdd, $CurrentLine)
					_Colour_Calltipp_Set_State("hide")




					$pos = Sci_GetLineStartPos($Sci, $CurrentLine - 1)
					If StringLen($TabsAdd) > 0 Then SCI_SetCurrentPos($Sci, $pos + StringLen($TabsAdd))
					BlockInput(0)

				Case " "
					$CurrentPos = SCI_GetCurrentPos($Sci)

					If $Auto_dollar_for_declarations = "true" And Not _Is_Comment() Then
						$Letztes_Wort = SCI_GetWordFromPos($Sci, SCI_GetCurrentPos($Sci) - 2)

						$TabsAdd = ""
						$Tabs = StringSplit(SCI_GetLine($Sci, SCI_GetCurrentLine($Sci) - 1), @TAB)
						If IsArray($Tabs) Then
							If $Tabs[0] > 1 Then
								For $i = 1 To $Tabs[0] - 1
									If Not $Tabs[$i] = "" Then ExitLoop
									$TabsAdd &= @TAB

								Next
							EndIf
						EndIf


						If $Auto_dollar_for_declarations = "true" And Not StringInStr(SCI_GetLine($Sci, SCI_GetCurrentLine($Sci) - 1), "$") Then
							Switch $Letztes_Wort

								Case "global"
									Send("$")

								Case "local"
									Send("$")

								Case "const"
									Send("$")

							EndSwitch
						EndIf


					EndIf


					$style = SendMessage($Sci, $SCI_GETSTYLEAT, $CurrentPos - 2, 0)
					If $style = $SCE_AU3_EXPAND Then
						$WordPos = SCI_GetWordPositions($Sci, $CurrentPos - 2)
						$Replace = StringRegExp($SCI_ABBREVFILE, "(?:\n|\r|\A)" & StringLower(SCI_GETTEXTRANGE($Sci, $WordPos[0], $WordPos[1])) & "=(.*)", 1)
						If Not @error Then
							$Replace = StringFormat(StringRegExpReplace($Replace[0], "\r|\n", ""))

							SCI_SetSelection($Sci, $WordPos[0], $WordPos[1] + 1)
							$WordPos[0] += StringInStr($Replace, "|", 1, 1) - 1
							If Not StringInStr($Replace, "|", 1, 1) Then $WordPos[0] = $WordPos[1] + 1
							SendMessageString($Sci, $SCI_REPLACESEL, 0, StringReplace($Replace, "|", "", 1))
							SCI_SetCurrentPos($Sci, $WordPos[0])

							;by isi360
							$linechecker = Sci_GetLine($Sci, Sci_GetCurrentLine($Sci) - 1)
							$linechecker = StringReplace($linechecker, " ", "")
							$linechecker = StringReplace($linechecker, @TAB, "")
							If StringInStr($linechecker, "=") Then $linechecker = ""
							$linechecker = StringTrimRight($linechecker, StringLen($linechecker) - 1)

							If $disableintelisense = "false" And $linechecker <> "$" Then
								Local $Ret, $sText, $iPos = SendMessage($Sci, $SCI_GETCURRENTPOS, 0, 0), $sFuncName
								Local $iLen = SendMessage($Sci, $SCI_GETCURLINE, 0, 0)
								Local $sBuf = DllStructCreate("byte[" & $iLen & "]")
								Local $Ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_GETCURLINE, "int", $iLen, "ptr", DllStructGetPtr($sBuf))
								Local $current = $Ret[0]
								Local $startword = $current
								While $startword > 0 And StringIsAlNum(Chr(DllStructGetData($sBuf, 1, $startword - 1))) Or Chr(DllStructGetData($sBuf, 1, $startword - 1)) = "_"
									$startword -= 1
									$sFuncName = Chr(DllStructGetData($sBuf, 1, $startword)) & $sFuncName
								WEnd
;~ 						$sFuncName = _StringReverse($sFuncName)
								$SCI_sCallTipFoundIndices = ArraySearchAll($SCI_sCallTip_Array, $sFuncName, 0, 0, 1)
								$sBuf = 0
								$SCI_sCallTipSelectedIndice = 0
								$SCI_sCallTip = ""
								If IsArray($SCI_sCallTipFoundIndices) Then

									;$SCI_sCallTip = Chr(1) & "1/" & UBound($SCI_sCallTipFoundIndices) & Chr(2) & $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]]
									$SCI_sCallTip = $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices[0]]

									$SCI_sCallTip = StringReplace(StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "(.{70,110} )", "$1" & @LF), @LF & @LF, @LF)

									$SCI_sCallTipPos = $iPos - StringLen($sFuncName)
									SendMessageString($Sci, $SCI_CALLTIPSHOW, $SCI_sCallTipPos, $SCI_sCallTip)

									$SCI_hlStart = StringInStr($SCI_sCallTip, "(")
									$SCI_hlEnd = StringInStr($SCI_sCallTip, ",")
									If $SCI_hlEnd = 0 Then $SCI_hlEnd = StringInStr($SCI_sCallTip, ")")
									SendMessage($Sci, $SCI_CALLTIPSETHLT, $SCI_hlStart, $SCI_hlEnd)
									Return
								EndIf
							EndIf

						EndIf
					EndIf
;~ 					ConsoleWrite(SCI_GetWordFromPos($Sci,SCI_GetCurrentPos($Sci)-2) & " - " & $style &":"& $SCE_AU3_EXPAND & @CRLF)
;~ 			Else
				Case Else
;~ 						#CS ; Uncomment this to add autocomplete for variables
					$style = SendMessage($Sci, $SCI_GETSTYLEAT, SCI_GetCurrentPos($Sci), 0)
					If Not SendMessage($Sci, $SCI_AUTOCACTIVE, 0, 0) And _
							$style <> $SCE_AU3_COMMENT And $style <> $SCE_AU3_COMMENTBLOCK _
							And $style <> $SCE_AU3_STRING And $style <> $SCE_AU3_SENT Then

;~ 						$Word = SCI_GetCurrentWordEx($Sci, 0, 1)
						$Word = SCI_GetWord_ISN_Special($Sci)
						While $Word And Not StringRegExp($Word, "\A([@$#_]|\w)")
							$Word = StringTrimLeft($Word, 1)
						WEnd
						While $Word And Not StringRegExp($Word, "([@$#_]|\w)\Z")
							$Word = StringTrimRight($Word, 1)
						WEnd


						;If $Word  = "$" Then
						If StringLeft($Word, 1) = "$" Then
							; Shows the filenames of all files in the current directory

							;AU3 Files

							;$AllWords = StringSplit($file, " []()-+*=/<>," & @CRLF & @TAB)
							;	$AllWords = StringSplit(SCI_GetText($Sci), " []()-+*=/<>," & @CRLF & @TAB)

							If $globalautocomplete = "true" Then
								$AllVariables = @CR
								Local $globale_variablen_einlesen_fortschritt = 0
								_GUICtrlStatusBar_SetText_ISN($Status_bar, StringReplace(_Get_langstr(747), "%1", $globale_variablen_einlesen_fortschritt))
								;_ArrayDisplay(StringSplit(SCI_GetText($Sci), " []()-+*=/<>," & @CRLF & @TAB))

								Dim $tmp_empty
								Dim $ALL_CODE
								Dim $tmp_CODE
								Dim $aRecords
								Local $str
								$str = ""
								$tmp_CODE = $tmp_empty

								If $globalautocomplete_current_script = "false" Then
									If $Studiomodus = 1 Then
;~ 										$FILES = _GetFileList($Offenes_Projekt, "*." & $Autoitextension)
										$files = _Skripteditor_hole_Inludes($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "")) ;Hole Variablen aus au3 Dateien die in der Hauptdatei als Include gesetzt sind
									Else
										$files = StringSplit($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], @CRLF) ;Nur im aktuellen Skript suchen im Editormodus
									EndIf
								Else
									$files = StringSplit($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], @CRLF) ;Nur im aktuellen Skript suchen
								EndIf

								$AllVariables = ""
								For $x = 0 To UBound($files) - 1
									If FileExists($files[$x]) Then
										_FileReadToArray($files[$x], $tmp_CODE)
										$str = $str & _ArrayToString($tmp_CODE, @CRLF)
									EndIf
								Next


								$AllWords = $AllWords_empty
								$AllWords = StringSplit($str, " []()-+*=/\<>:&," & @CRLF & @TAB)

								$Gefundene_Elemente_Array = _Scanne_array_nach_Variablen($AllWords, "$", 0, 0, 0, 1)
								$Gefundene_Elemente_Array = __ArrayUnique($Gefundene_Elemente_Array) ;Doppelte einträge aussortieren
								For $f = 0 To UBound($Gefundene_Elemente_Array) - 1
									$Gefundene_Elemente_Array[$f] = $Gefundene_Elemente_Array[$f] & "?15"
								Next
								$AllVariables = _ArrayToString($Gefundene_Elemente_Array, @CR)

								If $AllVariables = "" Then Return
								If $AllVariables = " " Then Return
								If $AllVariables = @CR Then Return

								SendMessage($Sci, $SCI_AUTOCSETORDER, $SC_ORDER_PERFORMSORT, 0) ;Autocomplete Liste durch Scintilla sortieren (Wichtig: Verhindert den $_ Bug!)

								if $Word = "_" AND $Skript_Editor_Autocomplete_UDF_ab_zweitem_Zeichen = "true"  then
								   if StringLen($Word) > 1 then SendMessageString($Sci, $SCI_AUTOCSHOW, StringLen($Word), $AllVariables)
								   Else
								   SendMessageString($Sci, $SCI_AUTOCSHOW, StringLen($Word), $AllVariables)
								Endif


							EndIf

						ElseIf StringLen($Word) Then

							;by isi360
							$linechecker = Sci_GetLine($Sci, Sci_GetCurrentLine($Sci) - 1)
							$linechecker = StringReplace($linechecker, " ", "")
							$linechecker = StringReplace($linechecker, @TAB, "")
							If StringInStr($linechecker, "=") Then $linechecker = ""
							$linechecker = StringTrimRight($linechecker, StringLen($linechecker) - 1)
							If $disableautocomplete = "false" And $linechecker <> "$" Then
;~ 								If Not SendMessage($Sci, $SCI_AUTOCACTIVE, 0,0) Then
;~ 							ConsoleWrite($Word & @CRLF)

								If StringRegExp($Word, "\A[A-Za-z0-9_@#]+\Z") Then ;And StringInStr(@CR & $SCI_AUTOCLIST,@CR & $Word,0) Then

									Local $pos = ArraySearchAll($SCI_AUTOCLIST, $Word, 1, 0, 1)
									If $pos = -1 Then Return 'GUI_RUNDEFMSG'
;~ 									_ArraySort($SCI_AUTOCLIST,0,1)
									$AllVariables = _ArrayToString($SCI_AUTOCLIST, @CR, $pos[0], $pos[UBound($pos) - 1])

;~ 									$AllVariables = _ArrayToString($SCI_AUTOCLIST, @CR,1)
;~ 										ConsoleWrite($AllVariables & @CRLF)
									SendMessage($Sci, $SCI_AUTOCSETORDER, $SC_ORDER_PERFORMSORT, 0) ;Autocomplete Liste durch Scintilla sortieren (Wichtig: Verhindert den $_ Bug!)

							    if $Word = "_" AND $Skript_Editor_Autocomplete_UDF_ab_zweitem_Zeichen = "true" then
								   if StringLen($Word) > 1 then SendMessageString($Sci, $SCI_AUTOCSHOW, StringLen($Word), $AllVariables)
								   Else
								   SendMessageString($Sci, $SCI_AUTOCSHOW, StringLen($Word), $AllVariables)
								Endif

								EndIf
;~ 								EndIf

							EndIf
						EndIf
					EndIf
;~ 						#CE
					;		EndIf
			EndSwitch



		Case $SCN_UPDATEUI
			If $Sci <> $Debug_log And $Sci <> $scintilla_Codeausschnitt And $Last_Used_Scintilla_Control <> $Sci Then $Last_Used_Scintilla_Control = $Sci

			$Automatische_Speicherung_eingabecounter = 0 ;Eingabecounter resetten
			$SCI_Pos_vor_Enter = (Sci_GetCurrentPos($Sci) - Sci_GetLineStartPos($Sci, $line)) + 1
			_Zeige_Detailinfos_zu_aktuellem_Wort(SCI_GetWordFromPos($Sci, SendMessage($Sci, $SCI_GETCURRENTPOS, 0, 0), 1))
			;Für inteli Matches
			If SendMessage($Sci, $SCI_GETSELECTIONSTART, 0, 0) <> 0 And $verwende_intelimark = "true" Then
				$Selection = Sci_GetSelection($Sci)
				If IsArray($Selection) Then
					If ($Selection[1] - $Selection[0] > 3) And ($Selection[1] - $Selection[0] < 201) Then ;erst ab 3 wörtern suchen (max. 200 zeichen)
						Local $Suchwort = SCI_GetTextRange($Sci, $Selection[0], $Selection[1])
						If StringLen($Suchwort) < StringLen($letztes_Suchwort) Then
							$letztes_Suchwort = ""
						EndIf
						If $letztes_Suchwort <> $Suchwort Then
							SendMessage($Sci, $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($Sci))
							$letztes_Suchwort = $Suchwort
							Local $Array_Gefundene_Elemente[1]
							$pos = 0
							For $zeile = 0 To Sci_GetLineCount($Sci)
								$Search = Sci_Search($Sci, $Suchwort, $pos)
								If $Search = -1 Then ExitLoop ;Nichts mehr gefunden
								If $Search <> -1 Then
									_ArrayAdd($Array_Gefundene_Elemente, $Search)
									$pos = $Search + 1
								EndIf
							Next
							_ArrayDelete($Array_Gefundene_Elemente, 0)
							SendMessage($Sci, $SCI_INDICSETSTYLE, 0, 8) ; Markierungsstyle
							$r = _ColorGetRed($scripteditor_highlightcolour)
							$g = _ColorGetGreen($scripteditor_highlightcolour)
							$B = _ColorGetBlue($scripteditor_highlightcolour)
							$bgclr = "0x" & Hex($B, 2) & Hex($g, 2) & Hex($r, 2)
							SendMessage($Sci, $SCI_INDICSETFORE, 0, $bgclr)

							For $x = 0 To UBound($Array_Gefundene_Elemente) - 1
								If $Array_Gefundene_Elemente[$x] = $Selection[0] Then ContinueLoop ;Makierung selbst überspringen
								SendMessage($Sci, $SCI_INDICATORFILLRANGE, $Array_Gefundene_Elemente[$x], StringLen($Suchwort))
							Next

						EndIf

					Else
						SendMessage($Sci, $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($Sci))
						$letztes_Suchwort = ""
					EndIf
				Else
					SendMessage($Sci, $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($Sci))
					$letztes_Suchwort = ""
				EndIf
			Else
				SendMessage($Sci, $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($Sci))
				$letztes_Suchwort = ""
			EndIf



		Case $SCN_MODIFIED

			_Check_tabs_for_changes()
			If (BitAND($modificationType, $SC_MOD_INSERTTEXT) Or BitAND($modificationType, $SC_MOD_DELETETEXT)) And $Parameter_Editor_Laedt_gerade_text = 0 Then
				If WinActive($ParameterEditor_GUI) And _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) <> -1 Then
					If $autoit_editor_encoding = "2" Then
						_GUICtrlListView_SetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), _ANSI2UNICODE(StringReplace(Sci_GetText($ParameterEditor_SCIEditor), @CRLF, "")), 1)
					Else
						_GUICtrlListView_SetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), StringReplace(Sci_GetText($ParameterEditor_SCIEditor), @CRLF, ""), 1)
					EndIf
					AdlibRegister("_Parameter_Editor_Aktualisiere_Vorschaulabel", 0)
				EndIf
			EndIf


			If SendMessage($Sci, $SCI_CALLTIPACTIVE, 0, 0) Then

				$Lastchar = Sci_GetChar($Sci, Sci_GetCurrentPos($Sci) - 1)


				If $Lastchar = "," Or $Lastchar = "(" Or $Lastchar = ")" Then
					;by isi360
					$trimleft = ""
					$pos = Sci_GetCurrentPos($Sci)
					$SCI_TextZeile = Sci_GetLine($Sci, Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci)))
					$SCI_Startpos = Sci_GetLineStartPos($Sci, Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci)))
					$Pos_in_Line = $pos - $SCI_Startpos
					$closecount = 0
					For $Count = $Pos_in_Line - 1 To 0 Step -1
						$char = Sci_GetChar($Sci, $SCI_Startpos + $Count)
						If $char = ")" Then $closecount = $closecount + 1
						If $char = "(" Then
							If $closecount <> 0 Then
								$closecount = $closecount - 1
								ContinueLoop
							EndIf
							$trimleft = $Count
							ExitLoop
						EndIf
					Next

					$Parastring = StringTrimLeft(Sci_GetLine($Sci, Sci_GetLineFromPos($Sci, Sci_GetCurrentPos($Sci))), $trimleft)
					$Parastring = _StringInsert($Parastring, "#-cursor-#", Sci_GetCurrentPos($Sci) - $SCI_Startpos - $trimleft) ;Coursorpos einfügen



					$trim_right = 0
					$geoeffnete_klammern = 0
					$geschlossene_klammern = 0
					For $Count = 0 To StringLen($Parastring)
						$char = StringMid($Parastring, $Count, 1)
						If $char = "(" Then $geoeffnete_klammern = $geoeffnete_klammern + 1
						If $char = ")" Then
							If $geoeffnete_klammern > 1 Then
								$geoeffnete_klammern = $geoeffnete_klammern - 1
								ContinueLoop
							EndIf
							$trim_right = StringLen($Parastring) - $Count
							ExitLoop
						EndIf
					Next

					$Parastring = StringTrimRight($Parastring, $trim_right)
					If StringRight($Parastring, 1) <> ")" Then $Parastring = $Parastring & ")"
					$Komma_anzahl = _Zeige_Parameter_Editor("123", $Parastring, 1) ;Nutze die "inteligenz" des Parameter Editors um die Anzahl der Kommas herauszufinden
;~ ConsoleWrite($Parastring&"      "&$Komma_anzahl&@crlf)


					$SCI_hlStart = StringInStr($SCI_sCallTip, ",", 0, $Komma_anzahl)
					Local $iTemp = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ",") + $SCI_hlStart
					If StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart < $iTemp Or $iTemp - $SCI_hlStart = 0 Then
						$SCI_hlEnd = StringInStr(StringTrimLeft($SCI_sCallTip, $SCI_hlStart + 1), ")") + $SCI_hlStart
					Else
						$SCI_hlEnd = $iTemp
					EndIf
					SendMessage($Sci, $SCI_CALLTIPSETHLT, $SCI_hlStart, $SCI_hlEnd)
				EndIf

				$selected_calltip_text = StringTrimRight($SCI_sCallTip, StringLen($SCI_sCallTip) - $SCI_hlEnd)
				$selected_calltip_text = StringTrimLeft($selected_calltip_text, $SCI_hlStart)
				If StringInStr($selected_calltip_text, "(") Then $selected_calltip_text = StringTrimLeft($selected_calltip_text, StringInStr($selected_calltip_text, "("))
				If Not StringInStr($selected_calltip_text, "(") And Not StringInStr($selected_calltip_text, ",") And (StringInStr($selected_calltip_text, "color") Or StringInStr($selected_calltip_text, "colour") Or StringInStr($selected_calltip_text, "background")) Then
					_Colour_Calltipp_Set_State("show")
				Else
					$farb_picker_GUIstate = WinGetState($mini_farb_picker_GUI, "")
					If BitAND($farb_picker_GUIstate, 2) Then _Colour_Calltipp_Set_State("hide")
				EndIf

			EndIf


			_Sci_get_Functionname_from_Position($Sci)

		Case $SCN_MARGINCLICK
			SendMessage($Sci, $SCI_TOGGLEFOLD, $line_number, 0)

		Case $SCN_SAVEPOINTREACHED

		Case $SCN_SAVEPOINTLEFT

	EndSwitch


	;EndIf
	;EndSelect
	$structNMHDR = 0
	$event = 0
	$lParam = 0
EndFunc   ;==>_WM_NOTIFY_EDITOR

;########################### NOTIF´s für den Projektbaum ###########################



Func _Projecttree_event($hWnd, $iMsg, $sPath, $hItem)
	Switch $iMsg
		Case $TV_NOTIFY_BEGINUPDATE
			GUISetCursor(1, 0, $Studiofenster)
		Case $TV_NOTIFY_ENDUPDATE
			GUISetCursor(2, 0, $Studiofenster)
		Case $TV_NOTIFY_SELCHANGED
;~ 			; Nothing
		Case $TV_NOTIFY_DBLCLK
			Switch $hWnd

				Case GUICtrlGetHandle($hTreeView)
					If _GUICtrlTreeView_GetSelection($hTreeView) = 0 Then Return
					If StringInStr(_GUICtrlTreeView_GetTree($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)), ".", 1, -1) = 0 Then Return
					Try_to_opten_file(_GUICtrlTVExplorer_GetSelected($hWndTreeview))

				Case GUICtrlGetHandle($Choose_File_Treeview)
					If _GUICtrlTreeView_GetSelection($Choose_File_Treeview) = 0 Then Return
					If StringInStr(_GUICtrlTreeView_GetTree($Choose_File_Treeview, _GUICtrlTreeView_GetSelection($Choose_File_Treeview)), ".", 1, -1) = 0 Then Return
					ControlClick($Choose_File_GUI, "", $Choose_File_GUI_OK)


			EndSwitch


		Case $TV_NOTIFY_RCLICK
			If $hWnd <> $hWndTreeview Then Return ;Rechtsklick nur im Projektbaum!
			;Prüfe was eigentlich markiert wurde
			GUICtrlSetState($TreeviewContextMenu_Item1, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item2, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item3, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item4, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item7, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item10, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item5, $GUI_ENABLE)
			GUICtrlSetState($TreeviewContextMenu_Item_Kompilieren, $GUI_DISABLE)
			GUICtrlSetState($TreeviewContextMenu_Item_Jetzt_Kompilieren, $GUI_DISABLE)
			GUICtrlSetState($TreeviewContextMenu_Item_Makro_kompilieren_neu, $GUI_DISABLE)
			GUICtrlSetState($TreeviewContextMenu_Item_Makro_kompilieren_bestehend, $GUI_DISABLE)

			If $Offenes_Projekt = _ISN_Variablen_aufloesen($Projectfolder & "\" & _GUICtrlTreeView_GetTree($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView))) Then
				GUICtrlSetState($TreeviewContextMenu_Item1, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item3, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item4, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item7, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item10, $GUI_DISABLE)
			EndIf


			If StringInStr(_GUICtrlTVExplorer_GetSelected($hWndTreeview), "." & $Autoitextension) And Not _IsDir(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Then ;Für Au3 Dateien
				GUICtrlSetState($TreeviewContextMenu_Item_Kompilieren, $GUI_ENABLE)
				GUICtrlSetState($TreeviewContextMenu_Item_Jetzt_Kompilieren, $GUI_ENABLE)
				GUICtrlSetState($TreeviewContextMenu_Item_Makro_kompilieren_neu, $GUI_ENABLE)
				GUICtrlSetState($TreeviewContextMenu_Item_Makro_kompilieren_bestehend, $GUI_ENABLE)

			EndIf

			If _WinAPI_PathIsRoot(_GUICtrlTVExplorer_GetSelected($hWndTreeview)) Or (_GUICtrlTVExplorer_GetSelected($hWndTreeview) == @MyDocumentsDir Or _GUICtrlTVExplorer_GetSelected($hWndTreeview) == @DesktopDir Or _GUICtrlTVExplorer_GetSelected($hWndTreeview) == _ISN_Variablen_aufloesen($Projectfolder)) Then
				GUICtrlSetState($TreeviewContextMenu_Item1, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item2, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item3, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item4, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item7, $GUI_DISABLE)
				GUICtrlSetState($TreeviewContextMenu_Item10, $GUI_DISABLE)
			EndIf
			If _GUICtrlTVExplorer_GetSelected($hWndTreeview) == @DesktopDir Then GUICtrlSetState($TreeviewContextMenu_Item5, $GUI_DISABLE)


;~ _GUICtrlMenu_TrackPopupMenu(GUICtrlGetHandle($TreeviewContextMenu), $studiofenster);, $aRet[0], $aRet[1], 1, 1, 2)
			Show_KontextMenu($Studiofenster, $TreeviewContextMenu) ;Zeige Contextmenü für den Projektbaum
			; Nothing
		Case $TV_NOTIFY_VERIFY
			If $hWnd = $Weitere_Dateien_Kompilieren_GUI_hTreeview Then _Weitere_Dateien_Kompilieren_Treeview_Event()

		Case $TV_NOTIFY_DELETINGITEM
			; Nothing
		Case $TV_NOTIFY_DISKMOUNTED
			; Nothing
		Case $TV_NOTIFY_DISKUNMOUNTED
			; Nothing
	EndSwitch
EndFunc   ;==>_Projecttree_event


Func _RetrieveDirectoryChanges()

	AdlibUnRegister('_RetrieveDirectoryChanges')

	Local $aData, $aText, $aPrev[2] = [0, ''], $sPrev = ''

	$aData = StringSplit($RDC_sEvents, '|', 2)
	$RDC_sEvents = ''
	If Not IsArray($aData) Then
		Return
	EndIf
	For $i = 0 To UBound($aData)
		If $i < UBound($aData) Then
			If $aData[$i] = $sPrev Then
				ContinueLoop
			EndIf
			$sPrev = $aData[$i]
			$aText = StringSplit($aData[$i], '?', 2)
			If IsArray($aText) Then
;~				ConsoleWrite($aText[0] & ' - ' & $aText[1] & @CR)
;~				ContinueLoop
				Switch Number($aText[0])
					Case 1 ; FILE_ACTION_ADDED
						AdlibRegister("_Update_Treeview")

;~ 					ConsoleWrite('DIRECTORY OR FILE MOVED' & @CR)

					Case 2 ; FILE_ACTION_REMOVED
						; Nothing
						AdlibRegister("_Update_Treeview")

;~ 					ConsoleWrite('FILE OR FOLDER removed' & @CR)

					Case 3 ; FILE_ACTION_MODIFIED
						; Nothing
					Case 4 ; FILE_ACTION_RENAMED_OLD_NAME
						; Nothing
					Case 5 ; FILE_ACTION_RENAMED_NEW_NAME

						AdlibRegister("_Update_Treeview")

;~ 					ConsoleWrite('FILE OR DIRECTORY RENAMED' & @CR)

				EndSwitch
			EndIf
		EndIf

		$aPrev = $aText
	Next

EndFunc   ;==>_RetrieveDirectoryChanges


Func WM_RDC($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam

	Local $aData = _RDC_GetData($lParam)

	If @error Then

		; Do something because notifications will not come from this thread!
		_Write_ISN_Debug_Console('Error: _RDC_GetData() - ' & @error & ', ' & @extended & ', ' & _RDC_GetDirectory($lParam), $ISN_Debug_Console_Errorlevel_Critical)
		_RDC_Delete($lParam)
		Return 0
	EndIf
	For $i = 1 To $aData[0][0]
		If $RDC_sEvents Then
			$RDC_sEvents &= '|'
		EndIf
		$RDC_sEvents &= $aData[$i][1] & '?' & _RDC_GetDirectory($lParam) & '\' & $aData[$i][0]
	Next
	AdlibRegister('_RetrieveDirectoryChanges', 250)
	Return 0
EndFunc   ;==>WM_RDC


Func _WM_NCACTIVATE($hWnd, $iMsg, $wParam, $lParam)
	If $hWnd = $Studiofenster Then
		If Not $wParam Then Return 1
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NCACTIVATE


Func _WM_WINDOWPOSCHANGING_ausnahmen($hWnd)
	If $hWnd = $Studiofenster Then Return False

	;Plugins
	If $Offenes_Projekt <> "" Then
		If Not IsArray($SCE_EDITOR) Then Return True
		If Not IsArray($Plugin_Handle) Then Return True
		$SCE_EDITOR_String = _ArrayToString($SCE_EDITOR)
		$Plugin_Handle_String = _ArrayToString($Plugin_Handle)
		If StringInStr($SCE_EDITOR_String, $hWnd) Then Return False
		If StringInStr($Plugin_Handle_String, $hWnd) Then Return False
	EndIf

	Return True
EndFunc   ;==>_WM_WINDOWPOSCHANGING_ausnahmen

Func WM_WINDOWPOSCHANGING($hWnd, $msg, $wParam, $lParam)

	If BitAND(WinGetState($Studiofenster, ""), 16) Then Return ;Nicht wenn Minimiert
	$size_new_resize = WinGetClientSize($Studiofenster, "")
	If Not IsArray($size_new_resize) Then Return
	If $size_new_resize[0] < 0 Then Return
	If $size_new_resize[1] < 0 Then Return
	If $size_new_resize[0] = 0 Then Return ;Fenster ist Minimiert
	If $size_new_resize[1] = 0 Then Return ;Fenster ist Minimiert



	If _WM_WINDOWPOSCHANGING_ausnahmen($hWnd) Then
		Local $stWinPos = DllStructCreate("uint;uint;int;int;int;int;uint", $lParam)



		;Das selbe auch für das QuickView Fenster
		$QuickView_Dummy_Control_Posarray = ControlGetPos($Studiofenster, "", $QuickView_Dummy_Control)
		If IsArray($QuickView_Dummy_Control_Posarray) And $hWnd = $QuickView_GUI Then
			DllStructSetData($stWinPos, 3, $QuickView_Dummy_Control_Posarray[0])
			DllStructSetData($stWinPos, 4, $QuickView_Dummy_Control_Posarray[1])
		EndIf


		Local $iLeft = DllStructGetData($stWinPos, 3)
		Local $iTop = DllStructGetData($stWinPos, 4)
		Local $iWidth = DllStructGetData($stWinPos, 5)
		Local $iHeight = DllStructGetData($stWinPos, 6)

		If $iLeft < ($iX_Min - ($iWidth - 50)) Then DllStructSetData($stWinPos, 3, $iX_Min - ($iWidth - 50))
		If $iTop < $iY_Min Then DllStructSetData($stWinPos, 4, $iY_Min)
		If $iLeft > $iX_Max Then DllStructSetData($stWinPos, 3, $iX_Max)
		If $iTop > $iY_Max Then DllStructSetData($stWinPos, 4, $iY_Max)
	EndIf
EndFunc   ;==>WM_WINDOWPOSCHANGING

Func _WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

	_WM_NOTIFY_EDITOR($hWnd, $iMsg, $iwParam, $ilParam) ;Versuche zuerst NOTIFY´s für das Scintilla Control

    ;Return..if it´s a Scintilla control
	Local $structNMHDR = DllStructCreate("hwnd hWndFrom;int IDFrom;int Code", $ilParam) ; tagNMHDR
	Local $sClassName = DllCall("User32.dll", "int", "GetClassName", "hwnd", DllStructGetData($structNMHDR, 1), "str", "", "int", 512)
	$sClassName = $sClassName[2]
	If $sClassName = "Scintilla" Then Return 'GUI_RUNDEFMSG'


	$nID = BitAND($iwParam, 0x0000FFFF) ;für Alle ;)

	;########################### NOTIF´s für den TAB und die Debug Console ###########################
	Local $hWndtabView, $tNMHDR, $hwndFrom, $iCode
	$hWndtabView = $htab
	If Not IsHWnd($hWndtabView) Then $hWndtabView = GUICtrlGetHandle($hWndtabView)
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hwndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hwndFrom

		Case $hWndtabView
			Switch $iCode
				Case $NM_RCLICK
					Local $tPOINT = _WinAPI_GetMousePos(True, $hwndFrom)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")
					Local $hItem = _GUICtrlTab_HitTest($hwndFrom, $iX, $iY)
					If $hItem <> 0 Then
						If $hItem[0] = _GUICtrlTab_GetCurFocus($htab) Then Return
						_GUICtrlTab_ActivateTabX($htab, $hItem[0])
						_Show_Tab($hItem[0])
					EndIf

			EndSwitch
	EndSwitch


	;########################### Debug Console (Rich Edit) ###########################
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hwndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hwndFrom
		Case $console_chatbox
			Select
				Case $iCode = $EN_MSGFILTER
					$tMsgFilter = DllStructCreate($tagMSGFILTER, $ilParam)
					If DllStructGetData($tMsgFilter, "msg") = $WM_LBUTTONDOWN Then
						If GUICtrlRead($debug_console_selecttextmode_checkbox) = $GUI_UNCHECKED Then GUICtrlSetState($console_commandinput, $GUI_FOCUS)
					EndIf
			EndSelect
	EndSwitch





	;########################### NOTIF´s für diverse Listviews (Startupscreen,Einstellungen...) ###########################
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hwndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")

	Switch $iCode

		Case $LVN_KEYDOWN
			If _IsPressed("26", $user32) Or _IsPressed("28", $user32) Then
				If $nID = $changelogmanager_listview Then AdlibRegister("_changelogmanager_lade_eintrag", 0)
				If $nID = $Projects_Listview_projectman Then AdlibRegister("_Load_Details_Manager", 0)
				If $nID = $Pugins_Listview Then AdlibRegister("_load_plugindetails", 0)
				If $nID = $config_skin_list Then AdlibRegister("_load_skindetails", 0)
			EndIf


			;Färbung für Listviews
		Case $NM_CUSTOMDRAW
			Local $tNMLVCUSTOMDRAW = DllStructCreate($tagNMLVCUSTOMDRAW, $ilParam)
			Local $dwDrawStage = DllStructGetData($tNMLVCUSTOMDRAW, "dwDrawStage")
			Switch $dwDrawStage
				Case $CDDS_PREPAINT
					Return $CDRF_NOTIFYITEMDRAW
				Case $CDDS_ITEMPREPAINT
					Return $CDRF_NOTIFYSUBITEMDRAW
				Case BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
					Local $iSubItem = DllStructGetData($tNMLVCUSTOMDRAW, "iSubItem")
					Local $dwItemSpec = DllStructGetData($tNMLVCUSTOMDRAW, "dwItemSpec")
					Local $hDC = DllStructGetData($tNMLVCUSTOMDRAW, "HDC")
					Switch $nID

						; DllStructSetData( $tNMLVCUSTOMDRAW, "ClrText", Listview_ColorConvert(0x000000))
						Case $quick_view_ToDoList_Listview
							$color = _ToDo_Liste_Kategoriefarbe_nach_Item_herausfinden($quick_view_ToDoList_Listview, $dwItemSpec)
							If $color <> "" Then DllStructSetData($tNMLVCUSTOMDRAW, "ClrTextBk", Listview_ColorConvert($color))

						Case $ToDoList_Listview
							$color = _ToDo_Liste_Kategoriefarbe_nach_Item_herausfinden($ToDoList_Listview, $dwItemSpec)
							If $color <> "" Then DllStructSetData($tNMLVCUSTOMDRAW, "ClrTextBk", Listview_ColorConvert($color))

						Case $Category_Manager_Listview
							$color = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", _GUICtrlListView_GetItemText($Category_Manager_Listview, $dwItemSpec, 0) & "_color", "")
							If $color <> "" Then DllStructSetData($tNMLVCUSTOMDRAW, "ClrTextBk", Listview_ColorConvert($color))



					EndSwitch
					Return $CDRF_NEWFONT
			EndSwitch



		Case $LVN_BEGINDRAG
			$tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $ilParam)
			$iEndIndex = DllStructGetData($tNMLISTVIEW, 'Item')
			$iEndSubIndex = DllStructGetData($tNMLISTVIEW, 'SubItem')
			Switch $nID

				;Bei folgenden Listviews gibt es eine Aktion wenn etwas via Dag and Drop versucht wird. Das ganze geht an die $LVN_HOTTRACK weiter...
				Case $quick_view_ToDoList_Listview
					$Listview_Drag_aktiv = 1

				Case $ToDoList_Listview
					$Listview_Drag_aktiv = 1

			EndSwitch


		Case $LVN_HOTTRACK
			If $Listview_Drag_aktiv = 1 Then ;Nur wen bereits eine Drag and Drop aktion läuft
				$Listview_Drag_aktiv = 0
				$tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $ilParam)
				$iEndIndex = DllStructGetData($tNMLISTVIEW, 'Item')
				$iEndSubIndex = DllStructGetData($tNMLISTVIEW, 'SubItem')

				Switch $nID

					Case $quick_view_ToDoList_Listview
						_ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben($quick_view_ToDoList_Listview, _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, $iEndIndex, 1))

					Case $ToDoList_Listview
						_ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben($ToDoList_Listview, _GUICtrlListView_GetItemText($ToDoList_Listview, $iEndIndex, 1))


				EndSwitch
			EndIf


		Case $NM_CLICK

			If $nID = $config_selectorlist Then
				AdlibRegister("_select_settingscategory", 0)
				Return
			EndIf
			If $nID = $projekteinstellungen_navigation Then
				AdlibRegister("_Projekteinstellungen_Navigation_Event", 0)
				Return
			EndIf
			If $nID = $listview_projectrules Then _load_ruledetails()
			If $nID = $Pugins_Listview Then _load_plugindetails()
			If $nID = $config_skin_list Then _load_skindetails()
			If $nID = $Projects_Listview_projectman Then _Load_Details_Manager()
			If $nID = $changelogmanager_listview Then _changelogmanager_lade_eintrag()
			If $nID = $FuncListview Then GUICtrlSetData($Funcinput, _GUICtrlListView_GetItemText($FuncListview, _GUICtrlListView_GetSelectionMark($FuncListview), 0))


		Case $NM_DBLCLK
			If $nID = $Projects_Listview Then _Try_to_Open_project()
			If $nID = $new_rule_triggerlist Then _edit_trigger()
			If $nID = $listview_projectrules Then _Editiere_Regel()
			If $nID = $makro_auswaehlen_listview Then _AU3_mit_vorhandenen_Makro_kompilieren_Makro_auswaehlen()
			If $nID = $Projects_Listview_projectman Then _Try_to_Open_projectman()
			If $nID = $vorlagen_Listview_projectman Then _Try_to_Open_template()
			If $nID = $new_rule_actionlist Then _edit_action()
			If $nID = $settings_hotkeylistview Then _show_Edit_Hotkey()
			If $nID = $einstellungen_toolbar_verfuegbareelemente_listview Then _Einstellungen_Toolbar_Eintrag_hinzufuegen()
			If $nID = $einstellungen_toolbar_aktiveelemente_listview Then _Einstellungen_Toolbar_entferne_Eintrag()
			If $nID = $in_dateien_suchen_gefundene_elemente_listview Then _In_Datei_suchen_Eintrag_oeffnen()
			If $nID = $FuncListview Then
				GUICtrlSetData($Funcinput, _GUICtrlListView_GetItemText($FuncListview, _GUICtrlListView_GetSelectionMark($FuncListview), 0))
				_func_select_ok()
			EndIf
			If $nID = $Category_Manager_Listview Then _ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_bearbeiten()
			If $nID = $ToDoList_Listview Then _ToDo_Liste_Aufgabe_Bearbeiten_Manager()
			If $nID = $quick_view_ToDoList_Listview Then _ToDo_Liste_Aufgabe_Bearbeiten_QuickView()

		Case $LVN_COLUMNCLICK ; A column was clicked
			$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
			$iColumnIndex = DllStructGetData($tInfo, "SubItem")
			If $nID = $Projects_Listview Then _HeaderSort($Projects_Listview, $iColumnIndex)
			If $nID = $Projects_Listview_projectman Then _HeaderSort($Projects_Listview_projectman, $iColumnIndex)
			If $nID = $vorlagen_Listview_projectman Then _HeaderSort($vorlagen_Listview_projectman, $iColumnIndex)
			If $nID = $FuncListview Then _HeaderSort($FuncListview, $iColumnIndex)
			If $nID = $settings_hotkeylistview Then _Sortiere_Listview($settings_hotkeylistview, $iColumnIndex)







		Case $NM_RCLICK

			$tPOINT = _WinAPI_GetMousePos(True, $Studiofenster)
			Local $iX = DllStructGetData($tPOINT, "X")
			Local $iY = DllStructGetData($tPOINT, "Y")

			Local $aPos = ControlGetPos($Studiofenster, "", $htab)

			Local $aHit = _GUICtrlTab_HitTest($htab, $iX - $aPos[0], $iY - $aPos[1])
			If $aHit[0] <> -1 And _GUICtrlTab_GetCurFocus($htab) <> -1 Then _GUICtrlTab_SetCurSel($htab, _GUICtrlTab_GetCurFocus($htab))
			If _GUICtrlTab_GetCurFocus($htab) = -1 And _GUICtrlTab_GetItemCount($htab) > 0 Then
				_GUICtrlTab_SetCurSel($htab, 0)
				_Show_Tab(0)
			EndIf

	EndSwitch

	;########################### NOTIF´s für die Toolbar (Dropdown zb. für Dropdownmenüs) ###########################
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hwndFrom = DllStructGetData($tNMHDR, "hWndFrom")
	$idFrom = DllStructGetData($tNMHDR, "IDFrom")
	$code = DllStructGetData($tNMHDR, "Code")

	Switch $hwndFrom
		Case $hToolbar
			Switch $code
				Case $TBN_DROPDOWN

					$hMenu = _GUICtrlMenu_CreatePopup()
					Switch $iItem
						Case $id1
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(154), $Toolbarmenu1)
							_GUICtrlMenu_SetItemBmp($hMenu, 0, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1788, 16, 16))
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(1094), $Kontextmenu_tempau3file)
							_GUICtrlMenu_SetItemBmp($hMenu, 1, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1788, 16, 16))
							If $Studiomodus = 1 Then
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, False)
							Else
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, True)
							EndIf
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(153), $Toolbarmenu2)
							_GUICtrlMenu_SetItemBmp($hMenu, 2, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 780, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 1, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 780, 16, 16), 1, 1))
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(155), $Toolbarmenu3)
							_GUICtrlMenu_SetItemBmp($hMenu, 3, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1176, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 2, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 1176, 16, 16), 1, 1))
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(156), $Toolbarmenu4)
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 3, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 1177, 16, 16), 1, 1))
							_GUICtrlMenu_SetItemBmp($hMenu, 4, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1177, 16, 16))

						Case $id7
							If $Studiomodus = 1 Then
								_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(50) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt), $Toolbarmenu_project1)
								_GUICtrlMenu_SetItemGrayed($hMenu, 0, False)
							Else
								_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(668) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt), $Toolbarmenu_project1)
								_GUICtrlMenu_SetItemGrayed($hMenu, 0, True)
								If Not _GUICtrlTab_GetItemCount($htab) = 0 Then
									Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
									If $GUICtrlTab_GetCurFocus <> -1 Then
										If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then
											_GUICtrlMenu_SetItemGrayed($hMenu, 0, False)
										EndIf
									EndIf
								EndIf
							EndIf
							_GUICtrlMenu_SetItemBmp($hMenu, 0, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 220, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 0, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 220, 16, 16), 1, 1))
							If $Studiomodus = 1 Then
								_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(488) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter), $Toolbarmenu_project2)
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, False)
							Else
								_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(669) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter), $Toolbarmenu_project2)
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, True)
								Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
								If _GUICtrlTab_GetItemCount($htab) <> 0 And $GUICtrlTab_GetCurFocus <> -1 Then
									If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then
										_GUICtrlMenu_SetItemGrayed($hMenu, 1, False)
									EndIf
								EndIf
							EndIf
							_GUICtrlMenu_SetItemBmp($hMenu, 1, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 220, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 1, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 220, 16, 16), 1, 1))
							_GUICtrlMenu_AddMenuItem($hMenu, "")
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(490), $Toolbarmenu_project3)
							_GUICtrlMenu_SetItemBmp($hMenu, 3, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 1376, 16, 16))
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 3, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 1376, 16, 16), 1, 1))

						Case $id8
							$str = ""
							If $Studiomodus = 1 Then
								$str = _Get_langstr(52)
							Else
								$str = _Get_langstr(601)
							EndIf
							_GUICtrlMenu_AddMenuItem($hMenu, $str & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile), $Toolbarmenu_compile1)
							_GUICtrlMenu_SetItemBmp($hMenu, 0, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 527, 16, 16))
							_GUICtrlMenu_SetItemGrayed($hMenu, 0, True)
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 0, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 527, 16, 16), 1, 1))
							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(1063), $Toolbarmenu_compile_daten_waehlen)
							_GUICtrlMenu_SetItemBmp($hMenu, 1, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 529, 16, 16))
							_GUICtrlMenu_SetItemGrayed($hMenu, 1, True)

							_GUICtrlMenu_AddMenuItem($hMenu, _Get_langstr(563) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_compile_Settings), $Toolbarmenu_compile2)
							_GUICtrlMenu_SetItemBmp($hMenu, 2, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $smallIconsdll, 529, 16, 16))
							_GUICtrlMenu_SetItemGrayed($hMenu, 2, True)
;~ 							_GUICtrlMenu_SetItemBmp($hMenu, 1, _WinAPI_Create32BitHBITMAP(_WinAPI_ShellExtractIcon($smallIconsdll, 529, 16, 16), 1, 1))
							If $Studiomodus = 1 Then
								_GUICtrlMenu_SetItemGrayed($hMenu, 0, False)
								_GUICtrlMenu_SetItemGrayed($hMenu, 1, False)
								_GUICtrlMenu_SetItemGrayed($hMenu, 2, False)
							EndIf
							If $Studiomodus = 2 And _GUICtrlTab_GetItemCount($htab) <> 0 Then
								Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
								If $GUICtrlTab_GetCurFocus <> -1 Then
									If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then
										_GUICtrlMenu_SetItemGrayed($hMenu, 0, False)
										_GUICtrlMenu_SetItemGrayed($hMenu, 1, True)
										_GUICtrlMenu_SetItemGrayed($hMenu, 2, False)
									EndIf
								EndIf
							EndIf

					EndSwitch
					$aRet = _GetToolbarButtonScreenPos($Studiofenster, $hToolbar, $iItem, 2)
					If Not IsArray($aRet) Then
						Dim $aRet[2] = [-1, -1]
					EndIf

					; send button dropdown menu item commandID to dummy control for use in GuiGetMsg() or GUICtrlSetOnEvent()
					; allows quick return from message handler : See warning for GUIRegisterMsg() in helpfile
					$iMenuID = _GUICtrlMenu_TrackPopupMenu($hMenu, $hToolbar, $aRet[0], $aRet[1], 1, 1, 2)
					If $iMenuID = $Toolbarmenu1 Then _Show_new_Filgui_au3()
					If $iMenuID = $Kontextmenu_tempau3file Then _erstelle_neues_temporaeres_skript()
					If $iMenuID = $Toolbarmenu2 Then _Show_new_Filgui_isf()
					If $iMenuID = $Toolbarmenu3 Then _Show_new_Filgui_ini()
					If $iMenuID = $Toolbarmenu4 Then _Show_new_Filgui_txt()
					If $iMenuID = $Toolbarmenu_project1 Then _ISN_Projekt_Testen()
					If $iMenuID = $Toolbarmenu_project2 Then _ISN_Projekt_Testen_ohne_Parameter()
					If $iMenuID = $Toolbarmenu_project3 Then _Show_Parameterconfig()
					If $iMenuID = $Toolbarmenu_compile1 Then _Start_Compiling()
					If $iMenuID = $Toolbarmenu_compile2 Then _Show_Compile()
					If $iMenuID = $Toolbarmenu_compile_daten_waehlen Then _Weitere_Dateien_zum_Kompilieren_waehlen()
					_GUICtrlMenu_DestroyMenu($hMenu)
					;If $iMenuID Then Return $TBDDRET_TREATPRESSED
					Return $TBDDRET_DEFAULT

				Case $TBN_HOTITEMCHANGE
					$tNMTBHOTITEM = DllStructCreate($tagNMTBHOTITEM, $ilParam)
					$i_idOld = DllStructGetData($tNMTBHOTITEM, "idOld")
					$i_idNew = DllStructGetData($tNMTBHOTITEM, "idNew")
					$iItem = $i_idNew
					$dwFlags = DllStructGetData($tNMTBHOTITEM, "dwFlags")

			EndSwitch
	EndSwitch

	;########################### NOTIF´s für den Skriptbaum (Treeview2) ###########################
	Local $hWndTreeView2, $tNMHDR2, $hWndFrom2, $iCode2
	$hWndTreeView2 = $hTreeview2
	If Not IsHWnd($hWndTreeView2) Then $hWndTreeView2 = GUICtrlGetHandle($hWndTreeView2)
	$tNMHDR2 = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom2 = HWnd(DllStructGetData($tNMHDR2, "hWndFrom"))
	$iIDFrom2 = DllStructGetData($tNMHDR2, "IDFrom")
	$iCode2 = DllStructGetData($tNMHDR2, "Code")

	Switch $hWndFrom2
		Case $hWndTreeView2
			Switch $iCode2

				Case $TVN_BEGINDRAGA, $TVN_BEGINDRAGW
					Local $tInfo = DllStructCreate($tagNMTREEVIEW, $ilParam)
					Local $Treeview_Item = DllStructGetData($tInfo, "NewhItem")
					Local $Sci_For_Drag = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]
					Local $Treeview_Text = StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, $Treeview_Item), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, $Treeview_Item), "|", Default, -1))
					$Treeview_Text = StringRegExpReplace($Treeview_Text, "{\s\d.\s}", "")
					$Treeview_Text = StringStripWS($Treeview_Text, 3)
					If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, $Treeview_Item), _Get_langstr(324)) Then $Treeview_Text = "#include " & $Treeview_Text
					_WinAPI_SetFocus($Sci_For_Drag)
					While _IsPressed("01", $user32) Or _IsPressed("02", $user32)
						$cuurnet_mouse_Pos = MouseGetPos()
						If IsArray($cuurnet_mouse_Pos) Then
							ToolTip($Treeview_Text, $cuurnet_mouse_Pos[0] + 5, $cuurnet_mouse_Pos[1] + 5, "", 0, 0)
							Local $WP = WinGetPos($Sci_For_Drag)
							$cuurnet_mouse_Pos[0] -= $WP[0]
							$cuurnet_mouse_Pos[1] -= $WP[1]
							SendMessage($Sci_For_Drag, $SCI_GOTOPOS, SendMessage($Sci_For_Drag, $SCI_POSITIONFROMPOINT, $cuurnet_mouse_Pos[0] - 5, $cuurnet_mouse_Pos[1]), 0)
							GUISetCursor(2, 1, $Sci_For_Drag)
						EndIf
						Sleep(50)
					WEnd
					GUISetCursor(2, 0, $Sci_For_Drag)
					ToolTip("")
					Sci_InsertText($Sci_For_Drag, Sci_GetCurrentPos($Sci_For_Drag), $Treeview_Text)


				Case $NM_DBLCLK
					Local $tPOINT = _WinAPI_GetMousePos(True, $hWndFrom2)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")
					Local $hItem = _GUICtrlTreeView_HitTestItem($hWndFrom2, $iX, $iY)
					If $hItem <> 0 Then
						If $hItem = $hRoot2 Then Return
						_Scripttree_DB_Klick()
					EndIf

				Case $NM_RCLICK
					Local $tPOINT = _WinAPI_GetMousePos(True, $hWndFrom2)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")
					Local $hItem = _GUICtrlTreeView_HitTestItem($hWndFrom2, $iX, $iY)
					If $hItem <> 0 Then
						_GUICtrlTreeView_SelectItem($hWndFrom2, $hItem, $TVGN_CARET)
						_GUICtrlTreeView_SelectItem($hTreeView2, $hItem)
						GUICtrlSetState($Scripttree_includemenu_menu0, $GUI_DISABLE)
						GUICtrlSetState($Scripttree_includemenu_menu1, $GUI_ENABLE)
						GUICtrlSetState($Scripttree_includemenu_menu2, $GUI_ENABLE)
						GUICtrlSetState($Scripttree_includemenu_menu3, $GUI_DISABLE)

						If $hItem = $hRoot2 Then Return

						If $hItem = $functiontree Then
							GUICtrlSetState($Scripttree_includemenu_menu0, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu1, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu2, $GUI_DISABLE)
							_GUICtrlMenu_TrackPopupMenu($Scripttree_includemenu_Handle, $Studiofenster)
							Return
						EndIf

						If $hItem = $globalvariablestree Then
							GUICtrlSetState($Scripttree_includemenu_menu0, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu1, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu2, $GUI_DISABLE)
							_GUICtrlMenu_TrackPopupMenu($Scripttree_includemenu_Handle, $Studiofenster)
							Return
						EndIf

						If $hItem = $includestree Then
							GUICtrlSetState($Scripttree_includemenu_menu0, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu1, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu2, $GUI_DISABLE)
							_GUICtrlMenu_TrackPopupMenu($Scripttree_includemenu_Handle, $Studiofenster)
							Return
						EndIf

						If $hItem = $localvariablestree Then
							GUICtrlSetState($Scripttree_includemenu_menu0, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu1, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu2, $GUI_DISABLE)
							_GUICtrlMenu_TrackPopupMenu($Scripttree_includemenu_Handle, $Studiofenster)
							Return
						EndIf

						If $hItem = $regionstree Then
							GUICtrlSetState($Scripttree_includemenu_menu0, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu1, $GUI_DISABLE)
							GUICtrlSetState($Scripttree_includemenu_menu2, $GUI_DISABLE)
							_GUICtrlMenu_TrackPopupMenu($Scripttree_includemenu_Handle, $Studiofenster)
							Return
						EndIf

						If $hItem = $hroot_forms Then Return

						If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(83)) Then GUICtrlSetState($Scripttree_includemenu_menu3, $GUI_ENABLE)
						If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(324)) Then GUICtrlSetState($Scripttree_includemenu_menu0, $GUI_ENABLE)
						If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(323)) Then GUICtrlSetState($Scripttree_includemenu_menu2, $GUI_DISABLE)
						_GUICtrlMenu_TrackPopupMenu($Scripttree_includemenu_Handle, $Studiofenster) ;default menu
					EndIf

			EndSwitch
	EndSwitch


	;########################### Tooltips für die Toolbar (musste ab 1.03 über WIM gelöst werden, da sonst die Toolbar nicht skaliert werden kann)###########################
	$tInfo = DllStructCreate($tagNMTTDISPINFO, $ilParam)
	$iCode = DllStructGetData($tInfo, "Code")

	;Native Tooltips für Toolbar OHNE SKIN!
	If $iCode = $TTN_GETDISPINFOW Then
		$iID = DllStructGetData($tInfo, "IDFrom")
		Switch $iID
			Case $id1 ;new file
				DllStructSetData($tInfo, "aText", _Get_langstr(43))
			Case $id2 ;new folder
				DllStructSetData($tInfo, "aText", _Get_langstr(46))
			Case $id3 ;import
				DllStructSetData($tInfo, "aText", _Get_langstr(44))
			Case $id4 ;export
				DllStructSetData($tInfo, "aText", _Get_langstr(49))
			Case $id5 ;löschen
				DllStructSetData($tInfo, "aText", _Get_langstr(45))
			Case $id6 ;projecttree
				DllStructSetData($tInfo, "aText", _Get_langstr(53))
			Case $id7 ;testproject
				DllStructSetData($tInfo, "aText", _Get_langstr(50))
			Case $id8 ;Projekt kompilieren
				DllStructSetData($tInfo, "aText", _Get_langstr(52))
			Case $id9 ;Projekt Eigenschaften
				DllStructSetData($tInfo, "aText", _Get_langstr(51))
			Case $id10 ;speichern
				DllStructSetData($tInfo, "aText", _Get_langstr(54))
			Case $id11 ;undo
				DllStructSetData($tInfo, "aText", _Get_langstr(55))
			Case $id12 ;redo
				DllStructSetData($tInfo, "aText", _Get_langstr(56))
			Case $id13 ;closetab
				DllStructSetData($tInfo, "aText", _Get_langstr(80))
			Case $id14 ;testscript
				DllStructSetData($tInfo, "aText", _Get_langstr(82))
			Case $id15 ;stopscript
				DllStructSetData($tInfo, "aText", _Get_langstr(106))
			Case $id16 ;search
				DllStructSetData($tInfo, "aText", _Get_langstr(85))
			Case $id17 ;syntaxcheck
				DllStructSetData($tInfo, "aText", _Get_langstr(108))
			Case $id18 ;tidy
				DllStructSetData($tInfo, "aText", _Get_langstr(327))
			Case $id19 ;import folder
				DllStructSetData($tInfo, "aText", _Get_langstr(455))
			Case $id20 ;fullscreenmode
				DllStructSetData($tInfo, "aText", _Get_langstr(457))
			Case $id22 ;macros
				DllStructSetData($tInfo, "aText", _Get_langstr(519))
			Case $id21 ;comment out
				DllStructSetData($tInfo, "aText", _Get_langstr(328))
			Case $id23 ;window info tool
				DllStructSetData($tInfo, "aText", _Get_langstr(609))
			Case $id24 ;macro 1
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(1))
			Case $id25 ;macro 2
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(2))
			Case $id26 ;macro 3
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(3))
			Case $id27 ;macro 4
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(4))
			Case $id28 ;macro 5
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(5))
			Case $Toolbar_makroslot6 ;macro 6
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(6))
			Case $Toolbar_makroslot7 ;macro 7
				DllStructSetData($tInfo, "aText", _Macroslot_get_name(7))
			Case $id29 ;save all tabs
				DllStructSetData($tInfo, "aText", _Get_langstr(649))
			Case $Toolbarmenu_aenderungsprotokoll
				DllStructSetData($tInfo, "aText", _Get_langstr(911))
			Case $Toolbarmenu_programmeinstellungen
				DllStructSetData($tInfo, "aText", _Get_langstr(42))
			Case $Toolbarmenu_projekteinstellungen
				DllStructSetData($tInfo, "aText", _Get_langstr(1078))
			Case $Toolbarmenu_Farbtoolbox
				DllStructSetData($tInfo, "aText", _Get_langstr(651))
			Case $Toolbarmenu_closeproject
				DllStructSetData($tInfo, "aText", _Get_langstr(41))
			Case $Toolbarmenu_pluginslot1
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(1))
			Case $Toolbarmenu_pluginslot2
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(2))
			Case $Toolbarmenu_pluginslot3
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(3))
			Case $Toolbarmenu_pluginslot4
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(4))
			Case $Toolbarmenu_pluginslot5
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(5))
			Case $Toolbarmenu_pluginslot6
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(6))
			Case $Toolbarmenu_pluginslot7
				DllStructSetData($tInfo, "aText", _AdvancedISNPlugin_get_name(7))
		EndSwitch
	EndIf

	;Tooltips für Toolbar MIT SKIN!
	If $hwndFrom = $hToolbar Then
		If $iCode = $NM_LDOWN And $Skin_is_used = "true" Then ToolTip("") ;Tooltip löschen
		If $iCode = $TBN_HOTITEMCHANGE And $Skin_is_used = "true" Then
			$tNMTBHOTITEM = DllStructCreate($tagNMTBHOTITEM, $ilParam)
			$iOld = DllStructGetData($tNMTBHOTITEM, "idOld")
			$iNew = DllStructGetData($tNMTBHOTITEM, "idNew")
			$g_iItem = $iNew
			$iFlags = DllStructGetData($tNMTBHOTITEM, "dwFlags")
			If BitAND($iFlags, $HICF_LEAVING) = $HICF_LEAVING Then
				ToolTip("") ;Tooltip löschen
			Else
				$winpos = WinGetPos($Studiofenster)
				If Not IsArray($winpos) Then Return
				$winpos_clientsize = WinGetClientSize($Studiofenster)
				If Not IsArray($winpos_clientsize) Then Return
				$aRect = _GUICtrlToolbar_GetButtonRect($hToolbar, $iNew)
				If Not IsArray($aRect) Then Return

				;Deaktivierte Buttons ignorieren
				If BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $iNew), $TBSTATE_INDETERMINATE) Then
					ToolTip("")
					Return
				EndIf

				Switch $iNew

					Case $id1 ;new file
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(43), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id2 ;new folder
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(46), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id3 ;import
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(44), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id4 ;export
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(49), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id5 ;löschen
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(45), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id6 ;projecttree
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(53), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id7 ;testproject
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(50), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id8 ;Projekt kompilieren
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(52), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id9 ;Projekt Eigenschaften
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(51), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id10 ;speichern
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(54), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id11 ;undo
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(55), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id12 ;redo
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(56), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id13 ;closetab
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(80), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id14 ;testscript
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(82), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id15 ;stopscript
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(106), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id16 ;search
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(85), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id17 ;syntaxcheck
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(108), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id18 ;tidy
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(327), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id19 ;import folder
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(455), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id20 ;fullscreenmode
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(457), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id22 ;macros
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(519), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id21 ;comment out
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(328), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id23 ;window info tool
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(609), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id24 ;macro 1
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(1), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id25 ;macro 2
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(2), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id26 ;macro 3
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(3), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id27 ;macro 4
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(4), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id28 ;macro 5
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(5), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbar_makroslot6 ;macro 6
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(6), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbar_makroslot7 ;macro 7
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Macroslot_get_name(7), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $id29 ;save all tabs
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(649), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_aenderungsprotokoll
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(911), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_programmeinstellungen
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(42), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_projekteinstellungen
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(1078), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_Farbtoolbox
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(651), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_closeproject
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_Get_langstr(41), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot1
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(1), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot2
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(2), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot3
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(3), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot4
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(4), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot5
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(5), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot6
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(6), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

					Case $Toolbarmenu_pluginslot7
						If IsArray($winpos) And IsArray($winpos_clientsize) And IsArray($aRect) Then ToolTip(_AdvancedISNPlugin_get_name(7), $winpos[0] + $aRect[2], $winpos[1] + ($winpos[3] - $winpos_clientsize[1]) + $aRect[3], "", 0)

				EndSwitch

			EndIf

		EndIf
	EndIf






	;########################### NOTIF´s für den Dateiexplorer (TVExplorer UDF) ###########################
;~	Local $tNMTREEVIEW = DllStructCreate($tagNMTREEVIEW, $ilParam)


	If @AutoItX64 Then
		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Aligment1;uint Action;uint Aligment2;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint Aligment3;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $ilParam)
	Else
		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Action;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $ilParam)
	EndIf
	Local $hTV = DllStructGetData($tNMTREEVIEW, 'hWndFrom')
	Local $Index = _TV_Index($hTV)

	If (Not $Index) Or ($tvData[$Index][27]) Then
		Return 'GUI_RUNDEFMSG'
	EndIf

	Local $hItem = DllStructGetData($tNMTREEVIEW, 'NewhItem')
	Local $hPrev = DllStructGetData($tNMTREEVIEW, 'OldhItem')
	Local $state = DllStructGetData($tNMTREEVIEW, 'NewState')
	Local $ID = DllStructGetData($tNMTREEVIEW, 'Code')
	Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
	Local $tPOINT, $flag, $path
	Local $tTVHTI

	Do
		Switch $ID

			Case $TVN_BEGINDRAGA, $TVN_BEGINDRAGW ;Beginne Drag&Drop Aktion
				Local $zielpfad = ""
				Local $Quelldatei = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
				$hItemHover = TreeItemFromPoint($hTV)

				;On click Drag fix
				If $Quelldatei <> _TV_GetPath($Index, $hItemHover) Then
					MouseUp("primary")
					Return
				EndIf

				Local $copy_mode = 0
				While _IsPressed("01", $user32)
					Sleep(50)
					$MausPosition = MouseGetPos()
					$hItemHover = TreeItemFromPoint($hTV)
					$zielpfad = _TV_GetPath($Index, $hItemHover)

					;Kopie erstellen wenn STRG gedrückt gehalten wird
					If _IsPressed("11", $user32) Then
						$copy_mode = 1
					Else
						$copy_mode = 0
					EndIf
					If IsArray($MausPosition) Then
						If _Pruefe_Ob_Drag_and_Drop_erlaubt_ist($Quelldatei, $zielpfad, $copy_mode) = 1 Then

							GUISetCursor(2, 1, $Studiofenster)
							If $copy_mode = 0 Then
								ToolTip(_Get_langstr(152) & " " & StringReplace($zielpfad, $Offenes_Projekt & "\", ""), $MausPosition[0] + 10, $MausPosition[1], StringTrimLeft($Quelldatei, StringInStr($Quelldatei, "\", 0, -1)))
							Else
								ToolTip(_Get_langstr(371) & " " & StringReplace($zielpfad, $Offenes_Projekt & "\", ""), $MausPosition[0] + 10, $MausPosition[1], StringTrimLeft($Quelldatei, StringInStr($Quelldatei, "\", 0, -1)))
							EndIf
						Else
							GUISetCursor(7, 1, $Studiofenster)
							ToolTip("")
						EndIf
					EndIf

					If $hItemHover = 1 Then
						;nix
					Else
						_SendMessage($hTV, $TVM_SELECTITEM, $TVGN_DROPHILITE, $hItemHover) ;add DropTarget
					EndIf
				WEnd

				_SendMessage($hTV, $TVM_SELECTITEM, $TVGN_DROPHILITE, 0) ;remove DropTarget
				ToolTip("")
				GUISetCursor(2, 0, $Studiofenster)
				_Try_to_move_file_drag_and_Drop($Quelldatei, $zielpfad, $copy_mode)

			Case $TVN_ITEMEXPANDINGW
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				If Not _GUICtrlTreeView_ExpandedOnce($hTV, $hItem) Then
;~					_GUICtrlTreeView_SetState($hTV, $hItem, $TVIS_EXPANDEDONCE, 1)
					_TV_Send(3, $Index, $hItem)
				EndIf
			Case $TVN_ITEMEXPANDEDW
				$path = _TV_GetPath($Index, $hItem)
				If BitAND($TVIS_EXPANDED, $state) Then
					$flag = 1
				Else
					$flag = 0
				EndIf
				If FileExists($path) Then
					_TV_SetImage($hTV, $hItem, _TV_AddIcon($Index, $path, $flag))
				Else
					_TV_Send(4, $Index, $hItem)
				EndIf
			Case $TVN_SELCHANGEDW
				If BitAND($TVIS_SELECTED, $state) Then
					_TV_Send(4, $Index, $hItem)
				EndIf
			Case $TVN_DELETEITEMW
				_TV_DeleteShortcut($Index, $hPrev)
			Case -5 ; NM_RCLICK
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				$tPOINT = _WinAPI_GetMousePos(1, $hTV)
				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPOINT, 1), DllStructGetData($tPOINT, 2))
				$hItem = DllStructGetData($tTVHTI, 'Item')
				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
					_GUICtrlTreeView_SelectItem($hTV, $hItem)
					$path = _TV_GetPath($Index, $hItem)
					If FileExists($path) Then
						_TV_SetSelected($Index, $hItem)
						_TV_Send(7, $Index, $hItem)
					Else
						_TV_Send(4, $Index, $hItem)
					EndIf
				EndIf
			Case -3 ; NM_DBLCLK
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				$tPOINT = _WinAPI_GetMousePos(1, $hTV)
				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPOINT, 1), DllStructGetData($tPOINT, 2))
				$hItem = DllStructGetData($tTVHTI, 'Item')
				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
					$path = _TV_GetPath($Index, $hItem)
					If Not _WinAPI_PathIsDirectory($path) Then
						_TV_Send(6, $Index, $hItem)
					EndIf
				EndIf
		EndSwitch
	Until 1
	_WinAPI_SetErrorMode($Mode)



;~ 	If @AutoItX64 Then
;~ 		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Aligment1;uint Action;uint Aligment2;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint Aligment3;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $ilParam)
;~ 	Else
;~ 		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Action;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $ilParam)
;~ 	EndIf
;~ 	Local $hTV = DllStructGetData($tNMTREEVIEW, 'hWndFrom')
;~ 	Local $Index = _TV_Index($hTV)

;~ 	If (Not $Index) Or ($tvData[$Index][27]) Then
;~ 		Return 'GUI_RUNDEFMSG'
;~ 	EndIf

;~ 	Local $hItem = DllStructGetData($tNMTREEVIEW, 'NewhItem')
;~ 	Local $hPrev = DllStructGetData($tNMTREEVIEW, 'OldhItem')
;~ 	Local $state = DllStructGetData($tNMTREEVIEW, 'NewState')
;~ 	Local $id = DllStructGetData($tNMTREEVIEW, 'Code')
;~ 	Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
;~ 	Local $tPOINT, $flag, $path
;~ 	Local $tTVHTI

;~ 	Do
;~ 		Switch $id
;~ 			Case $TVN_BEGINDRAGA, $TVN_BEGINDRAGW ;Beginne Drag&Drop Aktion

;~ 				$Quelldatei = _GUICtrlTVExplorer_GetSelected($hWndTreeview)
;~ 				$hItemHover = TreeItemFromPoint($hTV)

;~ 				;On click Drag fix
;~ 				If $Quelldatei <> _TV_GetPath($Index, $hItemHover) Then
;~ 					MouseUp("primary")
;~ 					Return
;~ 				EndIf

;~ 				Local $copy_mode = 0
;~ 				While _IsPressed("01", $user32)
;~ 					Sleep(50)
;~ 					$MausPosition = MouseGetPos()
;~ 					$hItemHover = TreeItemFromPoint($hTV)
;~ 					$zielpfad = _TV_GetPath($Index, $hItemHover)

;~ 					;Kopie erstellen wenn STRG gedrückt gehalten wird
;~ 					If _IsPressed("11", $user32) Then
;~ 						$copy_mode = 1
;~ 					Else
;~ 						$copy_mode = 0
;~ 					EndIf
;~ 					If IsArray($MausPosition) Then
;~ 						If _Pruefe_Ob_Drag_and_Drop_erlaubt_ist($Quelldatei, $zielpfad, $copy_mode) = 1 Then

;~ 							GUISetCursor(2, 1, $Studiofenster)
;~ 							If $copy_mode = 0 Then
;~ 								ToolTip(_Get_langstr(152) & " " & StringReplace($zielpfad, $Offenes_Projekt & "\", ""), $MausPosition[0] + 10, $MausPosition[1], StringTrimLeft($Quelldatei, StringInStr($Quelldatei, "\", 0, -1)))
;~ 							Else
;~ 								ToolTip(_Get_langstr(371) & " " & StringReplace($zielpfad, $Offenes_Projekt & "\", ""), $MausPosition[0] + 10, $MausPosition[1], StringTrimLeft($Quelldatei, StringInStr($Quelldatei, "\", 0, -1)))
;~ 							EndIf
;~ 						Else
;~ 							GUISetCursor(7, 1, $Studiofenster)
;~ 							ToolTip("")
;~ 						EndIf
;~ 					EndIf

;~ 					If $hItemHover = 1 Then
;~ 						;nix
;~ 					Else
;~ 						_SendMessage($hTV, $TVM_SELECTITEM, $TVGN_DROPHILITE, $hItemHover) ;add DropTarget
;~ 					EndIf
;~ 				WEnd

;~ 				_SendMessage($hTV, $TVM_SELECTITEM, $TVGN_DROPHILITE, 0) ;remove DropTarget
;~ 				ToolTip("")
;~ 				GUISetCursor(2, 0, $Studiofenster)
;~ 				_Try_to_move_file_drag_and_Drop($Quelldatei, $zielpfad, $copy_mode)

;~ 			Case $TVN_ITEMEXPANDINGW
;~ 				If $tvData[$Index][28] Then
;~ 					ExitLoop
;~ 				EndIf
;~ 				If Not _GUICtrlTreeView_ExpandedOnce($hTV, $hItem) Then
	;_GUICtrlTreeView_SetState($hTV, $hItem, $TVIS_EXPANDEDONCE, 1)
;~ 					_TV_Send(3, $Index, $hItem)
;~ 				EndIf
;~ 			Case $TVN_ITEMEXPANDEDW
;~ 				$path = _TV_GetPath($Index, $hItem)
;~ 				If BitAND($TVIS_EXPANDED, $state) Then
;~ 					$flag = 1
;~ 				Else
;~ 					$flag = 0
;~ 				EndIf
;~ 				If FileExists($path) Then
;~ 					_TV_SetImage($hTV, $hItem, _TV_AddIcon($Index, $path, $flag))
;~ 				Else
;~ 					_TV_Send(4, $Index, $hItem)
;~ 				EndIf
;~ 			Case $TVN_SELCHANGEDW
;~ 				If BitAND($TVIS_SELECTED, $state) Then
;~ 					_TV_Send(4, $Index, $hItem)
;~ 				EndIf
;~ 			Case $TVN_DELETEITEMW
;~ 				_TV_DeleteShortcut($Index, $hPrev)
;~ 			Case -5 ; NM_RCLICK
;~ 				If $tvData[$Index][28] Then
;~ 					ExitLoop
;~ 				EndIf
;~ 				$tPOINT = _WinAPI_GetMousePos(1, $hTV)
;~ 				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPOINT, 1), DllStructGetData($tPOINT, 2))
;~ 				$hItem = DllStructGetData($tTVHTI, 'Item')
;~ 				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
;~ 					_GUICtrlTreeView_SelectItem($hTV, $hItem)
;~ 					$path = _TV_GetPath($Index, $hItem)
;~ 					If FileExists($path) Then
;~ 						_TV_SetSelected($Index, $hItem)
;~ 						_TV_Send(7, $Index, $hItem)
;~ 					Else
;~ 						_TV_Send(4, $Index, $hItem)
;~ 					EndIf
;~ 				EndIf
;~ 			Case -3 ; NM_DBLCLK
;~ 				If $tvData[$Index][28] Then
;~ 					ExitLoop
;~ 				EndIf
;~ 				$tPOINT = _WinAPI_GetMousePos(1, $hTV)
;~ 				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPOINT, 1), DllStructGetData($tPOINT, 2))
;~ 				$hItem = DllStructGetData($tTVHTI, 'Item')
;~ 				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
;~ 					$path = _TV_GetPath($Index, $hItem)
;~ 					If Not _WinAPI_PathIsDirectory($path) Then
;~ 						_TV_Send(6, $Index, $hItem)
;~ 					EndIf
;~ 				EndIf
;~ 		EndSwitch
;~ 	Until 1
;~ 	_WinAPI_SetErrorMode($Mode)


	;########################### NOTIF´s für Checkboxen in einem Treeview (TristateTreeViewLib UDF) ###########################
	_WM_NOTIFY_Treeview($hWnd, $iMsg, $iwParam, $ilParam, $hWndFrom2) ;Versuche zuerst NOTIFY´s für das Scintilla Control

;~ 	Return
;~

	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NOTIFY

Func Listview_ColorConvert($iColor)
	Return BitOR(BitAND($iColor, 0x00FF00), BitShift(BitAND($iColor, 0x0000FF), -16), BitShift(BitAND($iColor, 0xFF0000), 16))
EndFunc   ;==>Listview_ColorConvert

Func _Pruefe_Ob_Drag_and_Drop_erlaubt_ist($Quelle = "", $Ziel = "", $copy_mode = 0)
	If $Quelle = "" Then Return 0
	If $Ziel = "" Then Return 0
	If $copy_mode = 1 Then Return 1
	If $Quelle = $Pfad_zur_Project_ISN Then Return 0
	If Not _WinAPI_PathIsDirectory($Ziel) Then Return 0
	If $Ziel = _ISN_Variablen_aufloesen($Projectfolder) Then Return 0
	If $Quelle = $Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "") Then Return 0

	Return 1
EndFunc   ;==>_Pruefe_Ob_Drag_and_Drop_erlaubt_ist


Func _Try_to_move_file_drag_and_Drop($Quelle = "", $Ziel = "", $copy_mode = 0)
	If _Pruefe_Ob_Drag_and_Drop_erlaubt_ist($Quelle, $Ziel, $copy_mode) = 0 Then Return


	If $copy_mode = 1 Then
		$Dateiname = StringTrimLeft($Quelle, StringInStr($Quelle, "\", 0, -1))
		While FileExists($Ziel & "\" & $Dateiname)
			Local $sDrive = "", $sDir = "", $sFilename = "", $sExtension = ""
			$aPathSplit = _PathSplit($Ziel & "\" & $Dateiname, $sDrive, $sDir, $sFilename, $sExtension)
			$Dateiname = $sFilename & " (" & _Get_langstr(373) & ")" & $sExtension
			If Not FileExists($Ziel & "\" & $Dateiname) Then ExitLoop
			Sleep(100)
		WEnd
		FileCopy($Quelle, $Ziel & "\" & $Dateiname)
		Sleep(100)
		$Projektbaum_ist_bereit = 0
		_GUICtrlTreeView_BeginUpdate($hTreeView)
;~ 		_Speichere_TVExplorer($hTreeView) ;Speichere geöffnete Elemente
;~ 		_GUICtrlTVExplorer_AttachFolder($hTreeView)

;~ 		_Lade_TVExplorer($hTreeView) ;Geöffnete Elemente wiederherstellen
		_GUICtrlTVExplorer_Expand($hTreeView, $Ziel & "\" & $Dateiname, 1)
		_GUICtrlTreeView_EndUpdate($hTreeView)
		$Projektbaum_ist_bereit = 1
	Else

		$alreadyopen = _GUICtrlTab_FindTab($htab, StringTrimLeft($Quelle, StringInStr($Quelle, "\", 0, -1)))
		If $alreadyopen <> -1 Then
			$res = _ArraySearch($Datei_pfad, $Quelle)
			If $res <> -1 Then
				$alreadyopen = $res
			Else
				$alreadyopen = -1
			EndIf
		EndIf
		If $alreadyopen = -1 Then

			If _WinAPI_PathIsDirectory($Quelle) Then
				If $copy_mode = 0 Then
					DirMove($Quelle, $Ziel & "\", 1)
				Else

				EndIf
			Else
				If $copy_mode = 0 Then
					FileMove($Quelle, $Ziel, 0)
				Else

				EndIf
			EndIf
			;AdlibRegister("_Update_Treeview")
		Else
			MsgBox(262144 + 16, _Get_langstr(25), StringTrimLeft($Quelle, StringInStr($Quelle, "\", 0, -1)) & " " & _Get_langstr(78), 0, $Studiofenster)
		EndIf
	EndIf

EndFunc   ;==>_Try_to_move_file_drag_and_Drop



Func TreeCreateDragImage($hWnd, $hItem)
	If _GUICtrlTreeView_GetNormalImageList($hWnd) <> 0 Then Return _GUICtrlTreeView_CreateDragImage($hWnd, $hItem)
	Local $aItemRect = _GUICtrlTreeView_DisplayRect($hWnd, $hItem, True)
	Local $iImgW = $aItemRect[2] - $aItemRect[0]
	Local $iImgH = $aItemRect[3] - $aItemRect[1]
;~ 	ConsoleWrite($iImgW & " " & $iImgH & @CRLF)
	Local $hTreeDC = _WinAPI_GetDC($hWnd)
	Local $hMemDC = _WinAPI_CreateCompatibleDC($hTreeDC)
	Local $hMemBmp = _WinAPI_CreateCompatibleBitmap($hTreeDC, $iImgW, $iImgH)
	Local $hMemBmpOld = _WinAPI_SelectObject($hMemDC, $hMemBmp)
	_WinAPI_BitBlt($hMemDC, 0, 0, $iImgW, $iImgH, $hTreeDC, $aItemRect[0], $aItemRect[1], $SRCCOPY)
	_WinAPI_SelectObject($hMemDC, $hMemBmpOld)
	_WinAPI_ReleaseDC($hWnd, $hTreeDC)
	_WinAPI_DeleteDC($hMemDC)
	Local $hImgList = _GUIImageList_Create($iImgW, $iImgH, 6)
	_GUIImageList_Add($hImgList, $hMemBmp)
	_WinAPI_DeleteObject($hMemBmp)
	Return $hImgList
EndFunc   ;==>TreeCreateDragImage

Func DrawDragImage(ByRef $hControl, ByRef $aDrag)
	Local $tPOINT, $hDC
	$hDC = _WinAPI_GetWindowDC($hControl)
	$tPOINT = _WinAPI_GetMousePos(True, $hControl)
	_WinAPI_InvalidateRect($hControl)
	_GUIImageList_Draw($aDrag, 0, $hDC, DllStructGetData($tPOINT, "X") - 10, DllStructGetData($tPOINT, "Y") - 8)
	_WinAPI_ReleaseDC($hControl, $hDC)
EndFunc   ;==>DrawDragImage

Func TreeItemFromPoint($hWnd)
	Local $tMPos = _WinAPI_GetMousePos(True, $hWnd)
	Return _GUICtrlTreeView_HitTestItem($hWnd, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
EndFunc   ;==>TreeItemFromPoint






Func _ISN_AutoIt_Studio_Dateien_und_Ordner_reorganisieren()
	;Dateien Reorganisieern
	;Unnötige Dateien sauber umsortieren bzw. löschen.
	;Falls dies aus berechtigungsgründen nicht möglich ist herscht halt Chaos im Data Ordner :P (Is aber auch kein Problem da die neuen Ordner und Daten eh über Updates eingespielt werden)

	;Alte Einträge aus der config.ini löschen
	IniDelete($Configfile, "config", "VSplitter1X")
	IniDelete($Configfile, "config", "VSplitter2X")
	IniDelete($Configfile, "config", "HSplitter1Y")
	IniDelete($Configfile, "config", "HSplitter2Y")


	If _Directory_Is_Accessible(@ScriptDir & "\Data") Then
		;Datenübernaheme für den alten Au3Defs Ordner
		If FileExists(@ScriptDir & "\Data\Au3Defs") Then
			DirCreate(@ScriptDir & "\Data\Api\")
			FileMove(@ScriptDir & "\Data\Au3Defs\*.api", @ScriptDir & "\Data\Api\")
			If @error Then MsgBox(0, "Error", "Error while moving .api files from \Data\Au3Defs to \Data\Api!")
			DirCreate(@ScriptDir & "\Data\Properties\")
			FileMove(@ScriptDir & "\Data\Au3Defs\*.properties", @ScriptDir & "\Data\Properties\")
			If @error Then MsgBox(0, "Error", "Error while moving *.properties files from \Data\Au3Defs to \Data\Properties!")
			FileRecycle(@ScriptDir & "\Data\Au3Defs")
			If @error Then MsgBox(0, "Error", "Error while removing the \Data\Au3Defs folder!")
		EndIf

		;Obfuscator löschen -> Gibt es nicht mehr (wurde durch Au3Stripper ersetzt)
		If FileExists(@ScriptDir & "\Data\Obfuscator") Then
			FileRecycle(@ScriptDir & "\Data\Obfuscator")
			If @error Then MsgBox(0, "Error", "Error while removing the \Data\Obfuscator folder!")
		EndIf

		;Alte Hilfe löschen
		If FileExists(@ScriptDir & "\Data\ISNAutoitStudiHilfe.chm") Then
			FileRecycle(@ScriptDir & "\Data\ISNAutoitStudiHilfe.chm")
			If @error Then MsgBox(0, "Error", "Error while removing the file Data\ISNAutoitStudiHilfe.chm!")
		EndIf

		;Alte Testprojekt.zip löschen
		If FileExists(@ScriptDir & "\Data\testprojekt.zip") Then
			FileRecycle(@ScriptDir & "\Data\testprojekt.zip")
			If @error Then MsgBox(0, "Error", "Error while removing the file Data\testprojekt.zip!")
		EndIf

		;Au3info löschen
		If FileExists(@ScriptDir & "\Data\Au3Info.exe") Then FileRecycle(@ScriptDir & "\Data\Au3Info.exe")

		;alten updater löschen
		If FileExists(@ScriptDir & "\updater.exe") Then FileRecycle(@ScriptDir & "\updater.exe")



		If not FileExists(@ScriptDir & "\portable.dat") then
			;Au3 Stripper löschen -> Seit 1.06 nicht mehr im Paket
			If FileExists(@ScriptDir & "\Data\Au3Stripper") Then
				FileRecycle(@ScriptDir & "\Data\Au3Stripper")
				If @error Then MsgBox(0, "Error", "Error while removing the \Data\Au3Stripper folder!")
			EndIf

			;Tidy löschen -> Seit 1.06 nicht mehr im Paket
			If FileExists(@ScriptDir & "\Data\Tidy") Then
				FileRecycle(@ScriptDir & "\Data\Tidy")
				If @error Then MsgBox(0, "Error", "Error while removing the \Data\Tidy folder!")
			EndIf
		Endif

		;Logo löschen
		If FileExists(@ScriptDir & "\Data\logo.jpg") Then FileRecycle(@ScriptDir & "\Data\logo.jpg")

		;Autoit3Wrapper
		If FileExists(@ScriptDir & "\Data\AutoIt3Wrapper\AutoIt3Wrapper.exe") Then FileRecycle(@ScriptDir & "\Data\AutoIt3Wrapper\AutoIt3Wrapper.exe")
		If FileExists(@ScriptDir & "\Data\AutoIt3Wrapper.exe") Then FileRecycle(@ScriptDir & "\Data\AutoIt3Wrapper.exe")
		If FileExists(@ScriptDir & "\Data\AutoIt3Wrapper.ico") Then FileRecycle(@ScriptDir & "\Data\AutoIt3Wrapper.ico")

		;Test dll löschen
		If FileExists(@ScriptDir & "\Data\test.dll") Then FileRecycle(@ScriptDir & "\Data\test.dll")

		;alte aero_busy_Xl löschen
		If FileExists(@ScriptDir & "\Data\aero_busy_Xl.ani") Then FileRecycle(@ScriptDir & "\Data\aero_busy_Xl.ani")


		;Au3Check löschen
		If FileExists(@ScriptDir & "\Data\Au3Check.exe") Then FileRecycle(@ScriptDir & "\Data\Au3Check.exe")
		If FileExists(@ScriptDir & "\Data\Au3Check.dat") Then FileRecycle(@ScriptDir & "\Data\Au3Check.dat")

		;Alte Bilder löschen
		If FileExists(@ScriptDir & "\Data\Normal.jpg") Then FileRecycle(@ScriptDir & "\Data\Normal.jpg")
		If FileExists(@ScriptDir & "\Data\Press.jpg") Then FileRecycle(@ScriptDir & "\Data\Press.jpg")
		If FileExists(@ScriptDir & "\Data\Over.jpg") Then FileRecycle(@ScriptDir & "\Data\Over.jpg")
		If FileExists(@ScriptDir & "\Data\editormode.jpg") Then FileRecycle(@ScriptDir & "\Data\editormode.jpg")
		If FileExists(@ScriptDir & "\Data\logo.bmp") Then FileRecycle(@ScriptDir & "\Data\logo.bmp")
		If FileExists(@ScriptDir & "\Data\logoHD.jpg") Then FileRecycle(@ScriptDir & "\Data\logoHD.jpg")
		If FileExists(@ScriptDir & "\Data\isi360.bmp") Then FileRecycle(@ScriptDir & "\Data\isi360.bmp")
		If FileExists(@ScriptDir & "\Data\troph0.jpg") Then FileRecycle(@ScriptDir & "\Data\troph0.jpg")
		If FileExists(@ScriptDir & "\Data\troph1.jpg") Then FileRecycle(@ScriptDir & "\Data\troph1.jpg")
		If FileExists(@ScriptDir & "\Data\troph2.jpg") Then FileRecycle(@ScriptDir & "\Data\troph2.jpg")
		If FileExists(@ScriptDir & "\Data\troph3.jpg") Then FileRecycle(@ScriptDir & "\Data\troph3.jpg")
		If FileExists(@ScriptDir & "\Data\troph1a.jpg") Then FileRecycle(@ScriptDir & "\Data\troph1a.jpg")
		If FileExists(@ScriptDir & "\Data\troph2a.jpg") Then FileRecycle(@ScriptDir & "\Data\troph2a.jpg")
		If FileExists(@ScriptDir & "\Data\troph3a.jpg") Then FileRecycle(@ScriptDir & "\Data\troph3a.jpg")
		If FileExists(@ScriptDir & "\Data\plugin.jpg") Then FileRecycle(@ScriptDir & "\Data\plugin.jpg")
		If FileExists(@ScriptDir & "\Data\Plugins\formstudio2\plugin.jpg") Then FileRecycle(@ScriptDir & "\Data\Plugins\formstudio2\plugin.jpg")
		If FileExists(@ScriptDir & "\Data\Plugins\fileviewer\plugin.jpg") Then FileRecycle(@ScriptDir & "\Data\Plugins\fileviewer\plugin.jpg")

		;Plugins bereinigen
		If FileExists(@ScriptDir & "\Data\Plugins\formstudio2\data\smallIcons.dll") Then FileRecycle(@ScriptDir & "\Data\Plugins\formstudio2\data\smallIcons.dll")
		If FileExists(@ScriptDir & "\Data\Plugins\formstudio2\data\control_editor.png") Then FileRecycle(@ScriptDir & "\Data\Plugins\formstudio2\data\control_editor.png")
		If FileExists(@ScriptDir & "\Data\Plugins\formstudio2\data\blue2.jpg") Then FileRecycle(@ScriptDir & "\Data\Plugins\formstudio2\data\blue2.jpg")
		If FileExists(@ScriptDir & "\Data\Plugins\formstudio2\data\left.jpg") Then FileRecycle(@ScriptDir & "\Data\Plugins\formstudio2\data\left.jpg")
		If FileExists(@ScriptDir & "\Data\Plugins\formstudio2\data\top.jpg") Then FileRecycle(@ScriptDir & "\Data\Plugins\formstudio2\data\top.jpg")

	EndIf
EndFunc   ;==>_ISN_AutoIt_Studio_Dateien_und_Ordner_reorganisieren

Func _ISN_Pfeil_ID_aus_smallicons_DLL()
	If $ISN_Dark_Mode = "true" Then
		Return 1922
	Else
		Return 1910
	EndIf
EndFunc   ;==>_ISN_Pfeil_ID_aus_smallicons_DLL

Func _GUICtrlStatusBar_SetColor($hWnd, $sText = "", $iPart = 0, $iColor = 0, $iBkColor = -1)
	;Author: rover - modified ownerdraw version of _GUICtrlStatusBar_SetText_ISN() from GuiStatusBar.au3
	;Includes RGB2BGR() - Author: Siao - <a href='http://www.autoitscript.com/forum/index.php?s=&showtopic=57161&view=findpost&p=433593' class='bbc_url' title=''>http://www.autoitscript.com/forum/index.php?s=&showtopic=57161&view=findpost&p=433593</a>
	;sets itmData element of statusbar DRAWITEMSTRUCT with pointer to struct with text and colour for part number
;~     If $Debug_SB Then _GUICtrlStatusBar_ValidateClassName($hWnd)
	Local $Ret, $tStruct, $pStruct, $iBuffer
	; In Microsoft Windows XP and earlier, the text for each part is limited to 127 characters.
	; This limitation has been removed in Windows Vista.
	; set sufficiently large buffer for use with Vista (can exceed XP limit of 128 chars)
	$tStruct = DllStructCreate("wchar Text[512];dword Color;dword BkColor;dword Trans")
	Switch $iBkColor
		Case -1
			DllStructSetData($tStruct, "Trans", 1)
		Case Else
			$iBkColor = BitAND(BitShift(String(Binary($iBkColor)), 8), 0xFFFFFF)
			DllStructSetData($tStruct, "Trans", 0)
			DllStructSetData($tStruct, "BkColor", $iBkColor)
	EndSwitch
	$iColor = BitAND(BitShift(String(Binary($iColor)), 8), 0xFFFFFF) ; From RGB2BGR() Author: Siao
	DllStructSetData($tStruct, "Text", $sText)
	DllStructSetData($tStruct, "Color", $iColor)
	$pStruct = DllStructGetPtr($tStruct)
	If _GUICtrlStatusBar_IsSimple($hWnd) Then $iPart = $SB_SIMPLEID
	;FOR INTERNAL STATUSBARS ONLY
;~     If _WinAPI_InProcess($hWnd, $__ghSBLastWnd) Then
	$Ret = _SendMessage($hWnd, $SB_SETTEXTW, BitOR($iPart, $SBT_OWNERDRAW), $pStruct, 0, "wparam", "ptr")
	Return $tStruct ; returns struct to global variable
;~     EndIf
	Return 0
EndFunc   ;==>_GUICtrlStatusBar_SetColor

; Handle WM_CONTEXTMENU messages
Func WM_CONTEXTMENU_EDITOR($hWnd, $iMsg, $iwParam, $ilParam)

	Local $tmenu
	If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return
	If Not _hit_win($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) Then Return ;Kontextmenü kann nur geöffnet werden wenn sich Mauszeiger im Fenster befindet

	;Prüfe ob Punkt "Datei öffnen" aktiviert werden soll (Für Includes)
	$str = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
	If StringInStr($str, "#include") And StringInStr($str, ".") Then
		GUICtrlSetState($SCI_EDITOR_CONTEXT_oeffneInclude, $GUI_ENABLE)
	Else
		GUICtrlSetState($SCI_EDITOR_CONTEXT_oeffneInclude, $GUI_DISABLE)
	EndIf

	;Prüfe auf Dateipfade
	$array = _StringBetween($str, '"', '"', -1)
	For $u = 0 To UBound($array) - 1
		If FileExists($array[$u]) Then GUICtrlSetState($SCI_EDITOR_CONTEXT_oeffneInclude, $GUI_ENABLE)
	Next

	$array = _StringBetween($str, "'", "'", -1)
	For $u = 0 To UBound($array) - 1
		If FileExists($array[$u]) Then GUICtrlSetState($SCI_EDITOR_CONTEXT_oeffneInclude, $GUI_ENABLE)
	Next


	;Prüfe ob Punkt Rückgängig aktiviert werden soll
	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANUNDO, 0, 0) = 1 Then
		GUICtrlSetState($SCI_EDITOR_CONTEXT_rueckgaengig, $GUI_ENABLE)
	Else
		GUICtrlSetState($SCI_EDITOR_CONTEXT_rueckgaengig, $GUI_DISABLE)
	EndIf

	;Prüfe ob Punkt Wiederholen aktiviert werden soll
	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANREDO, 0, 0) = 1 Then
		GUICtrlSetState($SCI_EDITOR_CONTEXT_wiederholen, $GUI_ENABLE)
	Else
		GUICtrlSetState($SCI_EDITOR_CONTEXT_wiederholen, $GUI_DISABLE)
	EndIf

;~ 	MouseClick("left")
	Sleep(10)
	Show_KontextMenu($Studiofenster, $ScripteditorContextMenu)

	Return True
EndFunc   ;==>WM_CONTEXTMENU_EDITOR

Func WM_GETMINMAXINFO($hWnd, $msg, $wParam, $lParam)

	$tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)

	Switch $hWnd

		Case $Config_GUI
			DllStructSetData($tagMaxinfo, 7, $Programmeinstellungen_width)
			DllStructSetData($tagMaxinfo, 8, $Programmeinstellungen_height)

		Case $NEW_PROJECT_GUI
			DllStructSetData($tagMaxinfo, 7, $Neues_Projekt_width)
			DllStructSetData($tagMaxinfo, 8, $Neues_Projekt_height)

		Case $projectmanager
			DllStructSetData($tagMaxinfo, 7, $Projektverwaltung_width)
			DllStructSetData($tagMaxinfo, 8, $Projektverwaltung_height)

		Case $Projekteinstellungen_GUI
			DllStructSetData($tagMaxinfo, 7, $Projekteinstellungen_width)
			DllStructSetData($tagMaxinfo, 8, $Projekteinstellungen_height)

		Case $ruleseditor
			DllStructSetData($tagMaxinfo, 7, $Makros_width)
			DllStructSetData($tagMaxinfo, 8, $Makros_height)

		Case $fFind1
			DllStructSetData($tagMaxinfo, 7, $Suchen_und_ersetzen_width)
			DllStructSetData($tagMaxinfo, 8, $Suchen_und_ersetzen_height)

		Case $programmeinstellungen_weiter_farbeinstellungen_GUI
			DllStructSetData($tagMaxinfo, 7, $Weitere_Farben_width)
			DllStructSetData($tagMaxinfo, 8, $Weitere_Farben_height)

		Case $skriuptbaum_FilterGUI
			DllStructSetData($tagMaxinfo, 7, $Skriptbaumfilter_width)
			DllStructSetData($tagMaxinfo, 8, $Skriptbaumfilter_height)

		Case $parameter_GUI
			DllStructSetData($tagMaxinfo, 7, $Startparameter_width)
			DllStructSetData($tagMaxinfo, 8, $Startparameter_height)

		Case $Makro_auswaehlen_GUI
			DllStructSetData($tagMaxinfo, 7, $makro_waehlen_width)
			DllStructSetData($tagMaxinfo, 8, $makro_waehlen_height)

		Case $newrule_GUI
			DllStructSetData($tagMaxinfo, 7, $makro_bearbeiten_width)
			DllStructSetData($tagMaxinfo, 8, $makro_bearbeiten_height)

		Case $aenderungs_manager_GUI
			DllStructSetData($tagMaxinfo, 7, $aenderungsprotokolle_width)
			DllStructSetData($tagMaxinfo, 8, $aenderungsprotokolle_height)

		Case $neuer_changelog_eintrag_GUI
			DllStructSetData($tagMaxinfo, 7, $aenderungsprotokolle_neuer_eintrag_width)
			DllStructSetData($tagMaxinfo, 8, $aenderungsprotokolle_neuer_eintrag_height)

		Case $changelog_generieren_GUI
			DllStructSetData($tagMaxinfo, 7, $aenderungsprotokolle_bericht_width)
			DllStructSetData($tagMaxinfo, 8, $aenderungsprotokolle_bericht_height)

		Case $bugtracker
			DllStructSetData($tagMaxinfo, 7, $bugtracker_width)
			DllStructSetData($tagMaxinfo, 8, $bugtracker_height)

		Case $ParameterEditor_GUI
			DllStructSetData($tagMaxinfo, 7, $parameter_editor_width)
			DllStructSetData($tagMaxinfo, 8, $parameter_editor_height)

		Case $Funclist_GUI
			DllStructSetData($tagMaxinfo, 7, $Funclist_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $Funclist_GUI_height)

		Case $ISNSTudio_debug
			DllStructSetData($tagMaxinfo, 7, $ISNSTudio_debug_width)
			DllStructSetData($tagMaxinfo, 8, $ISNSTudio_debug_height)

		Case $pelock_obfuscator_GUI
			DllStructSetData($tagMaxinfo, 7, $pelock_obfuscator_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $pelock_obfuscator_GUI_height)

		Case $ExecuteCommandRuleConfig_GUI
			DllStructSetData($tagMaxinfo, 7, $ExecuteCommandRuleConfig_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $ExecuteCommandRuleConfig_GUI_height)

		Case $TemplateNEU
			DllStructSetData($tagMaxinfo, 7, $TemplateNEU_width)
			DllStructSetData($tagMaxinfo, 8, $TemplateNEU_height)

		Case $ToDo_Liste_neuer_eintrag_GUI
			DllStructSetData($tagMaxinfo, 7, $ToDo_Liste_neuer_eintrag_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $ToDo_Liste_neuer_eintrag_GUI_height)

		Case $ToDoList_Manager
			DllStructSetData($tagMaxinfo, 7, $ToDoList_Manager_width)
			DllStructSetData($tagMaxinfo, 8, $ToDoList_Manager_height)

		Case $macro_runscriptGUI
			DllStructSetData($tagMaxinfo, 7, $macro_runscriptGUI_width)
			DllStructSetData($tagMaxinfo, 8, $macro_runscriptGUI_height)

		Case $rulecompileconfig_gui
			DllStructSetData($tagMaxinfo, 7, $rulecompileconfig_gui_width)
			DllStructSetData($tagMaxinfo, 8, $rulecompileconfig_gui_height)

		Case $rule_fileoperation_configgui
			DllStructSetData($tagMaxinfo, 7, $rule_fileoperation_configgui_width)
			DllStructSetData($tagMaxinfo, 8, $rule_fileoperation_configgui_height)

		Case $msgboxcreator_rule
			DllStructSetData($tagMaxinfo, 7, $msgboxcreator_rule_width)
			DllStructSetData($tagMaxinfo, 8, $msgboxcreator_rule_height)

		Case $runfile_config
			DllStructSetData($tagMaxinfo, 7, $runfile_config_width)
			DllStructSetData($tagMaxinfo, 8, $runfile_config_height)

		Case $parameter_GUI_rule
			DllStructSetData($tagMaxinfo, 7, $parameter_GUI_rule_width)
			DllStructSetData($tagMaxinfo, 8, $parameter_GUI_rule_height)

		Case $addlog_GUI
			DllStructSetData($tagMaxinfo, 7, $addlog_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $addlog_GUI_height)

		Case $stausbar_Set_GUI
			DllStructSetData($tagMaxinfo, 7, $stausbar_Set_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $stausbar_Set_GUI_height)

		Case Else
			DllStructSetData($tagMaxinfo, 7, $GUIMINWID) ; min X
			DllStructSetData($tagMaxinfo, 8, $GUIMINHT) ; min Y

	EndSwitch

	_GUICtrlStatusBar_Resize($Status_bar)
	Return 0
EndFunc   ;==>WM_GETMINMAXINFO

Func WM_ACTIVATE($hWnd, $iMsg, $wParam, $lParam)
	Return
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Switch $iMsg
		Case $WM_ACTIVATE
;~ 	   msgbox(0,"j",wingettitle("[ACTIVE]"))
			Switch $wParam
				Case 1, 2
					If $hWnd = $Studiofenster Then
						For $win = 0 To UBound($Plugin_Handle) - 1 Step 1
							If $Plugin_Handle[$win] = "" Then ContinueLoop
							If $Plugin_Handle[$win] = "-1" Then ContinueLoop
;~ 							ConsoleWrite(_WinAPI_GetAncestor($hWnd, $GA_ROOTOWNER) & "    " & $Studiofenster & @CRLF)
							If _WinAPI_GetAncestor($hWnd, $GA_ROOTOWNER) = $Studiofenster Then Return
							If $hWnd = $Plugin_Handle[$win] Then Return
							If $hWnd = $SCE_EDITOR[$win] Then Return
						Next

;~                     ConsoleWrite("!Window Activated" &random(0,1232323)& @CRLF)

						WinSetOnTop($Studiofenster, "", 1)
						WinSetOnTop($Studiofenster, "", 0)
					EndIf
				Case 0
;~                     ConsoleWrite("!Window Deactivated" & @CRLF)
			EndSwitch

	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_ACTIVATE



Func _Adlib_Bugtracker_Busyicon()
	;Busyicon für Bugtracker
	If IsObj($oIE) Then
		If $oIE.Busy Then
			GUICtrlSetState($bugtracker_busyicon, $GUI_SHOW)
		Else
			GUICtrlSetState($bugtracker_busyicon, $GUI_HIDE)
		EndIf
	EndIf
EndFunc   ;==>_Adlib_Bugtracker_Busyicon

Func _Show_Bugtracker()
	AdlibRegister("_Adlib_Bugtracker_Busyicon", 500)
	$oIE.navigate("https://isnetwork.at/bugtracker/index.php?do=index&project=2&status[]=open")
	GUISetState(@SW_SHOW, $bugtracker)
	WinActivate($bugtracker, "")
EndFunc   ;==>_Show_Bugtracker


Func _Bugtracker_lostpassword()
	$oIE.navigate("https://isnetwork.at/bugtracker/index.php?do=lostpw")
EndFunc   ;==>_Bugtracker_lostpassword

Func _Bugtracker_newaccount()
	$oIE.navigate("https://isnetwork.at/bugtracker/index.php?do=register")
EndFunc   ;==>_Bugtracker_newaccount

Func _Bugtracker_newticket()
	$oIE.navigate("https://isnetwork.at/bugtracker/index.php?do=newtask&project=2")
EndFunc   ;==>_Bugtracker_newticket

Func _Bugtracker_showalltikets()
	$oIE.navigate("https://isnetwork.at/bugtracker/index.php?project=0&status[]=")
EndFunc   ;==>_Bugtracker_showalltikets


Func _Bugtracker_to_Browser()
	ShellExecute("https://isnetwork.at/bugtracker/index.php?project=0&do=toplevel&switch=1")
EndFunc   ;==>_Bugtracker_to_Browser

Func _Hide_bugtracker()
	AdlibUnRegister("_Adlib_Bugtracker_Busyicon")
	GUISetState(@SW_HIDE, $bugtracker)
EndFunc   ;==>_Hide_bugtracker



Func _ISN_Automatische_Speicherung_Sekundenevent()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Automatische_Speicherung_Aktiv <> "true" Then
		AdlibUnRegister("_ISN_Automatische_Speicherung_Sekundenevent")
		Return
	EndIf

	If $Automatische_Speicherung_eingabecounter = -1 Then Return
	If $Automatische_Speicherung_Modus <> "2" Then
		AdlibUnRegister("_ISN_Automatische_Speicherung_Sekundenevent")
		Return
	EndIf


	$Automatische_Speicherung_eingabecounter = $Automatische_Speicherung_eingabecounter + 1 ;Zähle...

	If $Automatische_Speicherung_eingabecounter * 1000 > _TimeToTicks($Automatische_Speicherung_Eingabe_Stunden, $Automatische_Speicherung_Eingabe_Minuten, $Automatische_Speicherung_Eingabe_Sekunden) Then
		_ISN_Automatische_Speicherung_starten() ;Automatische speicherung ausführen da keine Eingabe erfolgt ist
	EndIf

EndFunc   ;==>_ISN_Automatische_Speicherung_Sekundenevent


Func _ISN_Automatische_Speicherung_starten()
	If $Automatische_Speicherung_Aktiv <> "true" Then
		AdlibUnRegister("_ISN_Automatische_Speicherung_starten")
		Return
	EndIf
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	_Write_ISN_Debug_Console("AutoSave initiated [" & $Automatische_Speicherung_eingabecounter & " secounds without an input]...", 1)
	_Write_log(_Get_langstr(1084), "368DB6")

	Local $Nur_Skripttabs_sichern = 0
	If $Automatische_Speicherung_Nur_Skript_Tabs_Sichern = "true" Then $Nur_Skripttabs_sichern = 1

	If $Automatische_Speicherung_Eingabe_Nur_einmal_sichern = "true" Then
		$Automatische_Speicherung_eingabecounter = -1
	Else
		$Automatische_Speicherung_eingabecounter = 0 ;reset
	EndIf

	If $Automatische_Speicherung_Nur_aktuellen_Tabs_Sichern = "true" Then
		_try_to_save_file(_GUICtrlTab_GetCurFocus($htab), 0, $Nur_Skripttabs_sichern)
	Else
		_Save_All_tabs($Nur_Skripttabs_sichern)
	EndIf


EndFunc   ;==>_ISN_Automatische_Speicherung_starten


Func _erstelle_neues_temporaeres_skript($Erweiterung = $Autoitextension)
	Local $Pfad = ""
	Local $Dateinummerierung = 1
	Local $Dateiname = ""
	Local $dateihandle
	$Pfad = _ISN_Variablen_aufloesen(_ProjectISN_Config_Read("temp_script_path", "%projectdir%\Temp"))
	$Pfad = _WinAPI_PathRemoveBackslash($Pfad)
	If $Pfad = "" Then Return
	If DirCreate($Pfad) = 0 Then Return ;Fehler -> Return

	$Dateiname = _ProjectISN_Config_Read("temp_script_name", "Tempscript_%count%")
	If Not StringInStr($Dateiname, "%count%") Then Return ;Kein %count% -> Return

	;Zähle nach Daten
	For $Dateinummerierung = 1 To 999 Step +1
		If Not FileExists($Pfad & "\" & StringReplace($Dateiname, "%count%", $Dateinummerierung) & "." & $Erweiterung) Then ExitLoop
	Next

	;Skript erstellen
	$Pfad = $Pfad & "\" & StringReplace($Dateiname, "%count%", $Dateinummerierung) & "." & $Erweiterung

	If $autoit_editor_encoding = "2" Then
		$dateihandle = FileOpen($Pfad, 2 + $FO_UTF8_NOBOM)
	Else
		$dateihandle = FileOpen($Pfad, 2)
	EndIf

	If $dateihandle = -1 Then
		MsgBox(0, "Error", "Unable to create new file. Maybe you do not have write access to this folder!")
		Return
	EndIf
	FileWriteLine($dateihandle, ";" & StringReplace($Dateiname, "%count%", $Dateinummerierung) & "." & $Erweiterung)
	FileClose($dateihandle)

	;_Update_Treeview()

	Try_to_opten_file($Pfad)
	_GUICtrlTVExplorer_Expand($hWndTreeview, $Pfad)
EndFunc   ;==>_erstelle_neues_temporaeres_skript

Func _Pruefe_ob_sich_Datei_im_Temp_Ordner_befindet($Dateipfad = "")
	If $Studiomodus = "2" Then Return
	Local $Pfad = ""
	$Pfad = _ISN_Variablen_aufloesen(_ProjectISN_Config_Read("temp_script_path", "%projectdir%\Temp"))
	$Pfad = _WinAPI_PathRemoveBackslash($Pfad)
	If Not FileExists($Pfad) Then Return
	If $Pfad = "" Then Return
	If StringInStr($Dateipfad, _WinAPI_PathAddBackslash($Pfad)) Then ;Datei ist im Temp Ordner (Für Temporäre Daten)
		Switch _ProjectISN_Config_Read("temp_script_delete_mode", "2") ;1 lösche, 2 fragen, 3 nichts tun

			Case "1"
				FileDelete($Dateipfad)
				;_Update_Treeview()

			Case "2"
				$Antwort = MsgBox(4 + 32 + 262144, _Get_langstr(48), StringReplace(_Get_langstr(1103), "%1", StringTrimLeft($Dateipfad, StringInStr($Dateipfad, "\", 0, -1))), 0, $Studiofenster)
				If $Antwort = 6 Then
					FileDelete($Dateipfad)
					;_Update_Treeview()
				EndIf
		EndSwitch
	EndIf
EndFunc   ;==>_Pruefe_ob_sich_Datei_im_Temp_Ordner_befindet



Func _Autocomplete_nach_Enter($sci_handle = "")
	If $sci_handle = "" Then Return
	If $AutoEnd_Keywords <> "true" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $sci_handle = $Debug_log Then Return ;In der Console nicht anwenden
	If $Can_open_new_tab = 0 Then Return ;ISN arbeitet gerade


	$Tabs_Anzahl = 0
	$Zeile_vor_Enter = Sci_GetLineFromPos($sci_handle, Sci_GetCurrentPos($sci_handle))
	If Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1) = "" Then Return

	StringReplace(StringStripWS(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), 2), @TAB, "")
	$Tabs_Anzahl = @extended
	$Striped_Zeile = StringStripWS(StringLower(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1)), 3)
	If $Striped_Zeile = "" Then Return
	$Striped_Zeile_Ohne_Kommentare = $Striped_Zeile
	If StringInStr($Striped_Zeile_Ohne_Kommentare, ";") Then $Striped_Zeile_Ohne_Kommentare = StringStripWS(StringTrimRight($Striped_Zeile_Ohne_Kommentare, (StringLen($Striped_Zeile_Ohne_Kommentare) - StringInStr($Striped_Zeile_Ohne_Kommentare, ";", 0, -1) + 1)), 3)
	$Symbole_in_Zeile = StringRegExp($Striped_Zeile, "^#|^_|^;")
	$erstes_wort = StringMatchAndGet($Striped_Zeile, "^[iI]f|^[eE]lseif|^[fF]unc|^[fF]or|^[wW]hile|^[sS]witch|^[dD]o|^[sS]elect|^[wW]ith")
	If $erstes_wort = "" Then $erstes_wort = StringTrimRight(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), StringInStr(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), " "))
	$Erstes_Wort_col = StringInStr(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), $erstes_wort)
;~ Sci_Undo($Sci_handle)
;~ $Position_im_Text_vor_Enter = Sci_GetCurrentPos($Sci_handle)
;~ $Col_Position_im_Text_vor_Enter = (Sci_GetCurrentPos($Sci_handle) - Sci_GetLineStartPos($Sci_handle, Sci_GetLineFromPos($Sci_handle, Sci_GetCurrentPos($Sci_handle)))) + 1
;~ Sci_Redo($Sci_handle)

	$Tabs = ""
	If $Tabs_Anzahl <> 0 Then
		For $y = 1 To $Tabs_Anzahl
			$Tabs = $Tabs & @TAB
		Next
	EndIf

	$keyword_gefunden = 0
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "if ") Then $keyword_gefunden = 1
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "elseif ") Then $keyword_gefunden = 1
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "while ") Then $keyword_gefunden = 1
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "do ") Then $keyword_gefunden = 1
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "switch ") Then $keyword_gefunden = 1
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "for ") Then $keyword_gefunden = 1
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "select ") Then $keyword_gefunden = 1
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "func ") Then $keyword_gefunden = 1
	If StringInStr($Striped_Zeile_Ohne_Kommentare, "with ") Then $keyword_gefunden = 1
	If $keyword_gefunden = 0 Then Return ;Kein gültiges Keywoard für Autocomplete gefunden

	If StringInStr($Striped_Zeile_Ohne_Kommentare, "if ") Then
		If StringInStr($Striped_Zeile_Ohne_Kommentare, "return") Or StringInStr($Striped_Zeile_Ohne_Kommentare, "exit") Or StringInStr($Striped_Zeile_Ohne_Kommentare, "exitloop") Or StringInStr($Striped_Zeile_Ohne_Kommentare, "then ") Then Return ;Bei einzelnen Zeilen überspringen
	EndIf


	_Autoinsertion_Smart_Korrektur($sci_handle, $erstes_wort, $Striped_Zeile_Ohne_Kommentare, $Zeile_vor_Enter, $Tabs)

;~ Sci_AddLines($Sci_handle, @crlf&$Tabs&"EndIf",$Zeile_vor_Enter+1)
	$LineBreak = @CRLF



	Switch StringLower(StringStripWS($erstes_wort, 3))

		Case "if"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "EndIf")

		Case "elseif"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "EndIf")

		Case "while"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "Wend")

		Case "for"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "Next")

		Case "switch"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "EndSwitch")

		Case "select"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "EndSelect")

		Case "do"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "Next")

		Case "func"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "EndFunc")

		Case "with"
			If _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle, $Zeile_vor_Enter, StringStripWS($erstes_wort, 3), $Erstes_Wort_col) = False Then Sci_InsertText($sci_handle, Sci_GetLineEndPos($sci_handle, $Zeile_vor_Enter), $LineBreak & $Tabs & "EndWith")

	EndSwitch

EndFunc   ;==>_Autocomplete_nach_Enter


Func _Autoinsertion_Funktion_besitzt_Klammern($func = "", $Striped_Zeile_Ohne_Kommentare = "")
	If StringInStr($func, "(") Then $func = StringTrimRight($func, StringLen($func) - StringInStr($func, "(") + 1)
	If StringInStr($func, "=") Then $func = StringTrimRight($func, StringLen($func) - StringInStr($func, "=") + 1)
	$func = StringStripWS($func, 3)
	If $func = "if" And StringInStr($Striped_Zeile_Ohne_Kommentare, "(") Then Return True
	If $func = "elseif" And StringInStr($Striped_Zeile_Ohne_Kommentare, "(") Then Return True
	If $func = "while" And StringInStr($Striped_Zeile_Ohne_Kommentare, "(") Then Return True
	If $func = "for" And StringInStr($Striped_Zeile_Ohne_Kommentare, "(") Then Return True
	If $func = "switch" And StringInStr($Striped_Zeile_Ohne_Kommentare, "(") Then Return True
	If $func = "select" And StringInStr($Striped_Zeile_Ohne_Kommentare, "(") Then Return True
	If $func = "" Then Return False
	$SCI_sCallTipFoundIndices_km = ArraySearchAll($SCI_sCallTip_Array, $func, 0, 0, 1)
	If IsArray($SCI_sCallTipFoundIndices_km) Then
		$str = $SCI_sCallTip_Array[$SCI_sCallTipFoundIndices_km[0]]
		If StringInStr($str, "(") And StringInStr($str, ")") Then Return True
	EndIf
	Return False
EndFunc   ;==>_Autoinsertion_Funktion_besitzt_Klammern


Func _Autoinsertion_Smart_Korrektur($sci_handle = "", $erstes_wort = "", $Striped_Zeile_Ohne_Kommentare = "", $Zeile_vor_Enter = 0, $Tabs = 0)
	$Then_gefunden = StringMatchAndGet($Striped_Zeile_Ohne_Kommentare, "then$")
	$Then_gefunden = StringLower($Then_gefunden)
	$Korrekturwert = 0


	Switch StringLower($erstes_wort)

		Case "if"
			If StringLower($Striped_Zeile_Ohne_Kommentare) = "if" Then
				Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare) + $Korrekturwert, " 1")
				$Korrekturwert = $Korrekturwert + StringLen(" 1")
			EndIf
			If $Then_gefunden = "" Then Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare) + $Korrekturwert, " Then")
			If $Korrekturwert <> 0 Then Return

		Case "elseif"
			If StringLower($Striped_Zeile_Ohne_Kommentare) = "elseif" Then
				Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare) + $Korrekturwert, " 1")
				$Korrekturwert = $Korrekturwert + StringLen(" 1")
			EndIf
			If $Then_gefunden = "" Then Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare) + $Korrekturwert, " Then")
			If $Korrekturwert <> 0 Then Return


		Case "while"
			If StringLower($Striped_Zeile_Ohne_Kommentare) = "while" Then
				Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare), " 1")
				Return
			EndIf


		Case "func" ;Auto Klammern auf bzw. zu
			If Not StringInStr(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), "(") And Not StringInStr(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), ")") Then
				Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare) + $Korrekturwert, "(")
				$Korrekturwert = $Korrekturwert + StringLen("(")
			EndIf

			If Not StringInStr(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), ")") Then
				Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare) + $Korrekturwert, ")")
				$Korrekturwert = $Korrekturwert + StringLen(")")
			EndIf


	EndSwitch



	If _Autoinsertion_Funktion_besitzt_Klammern(StringLower($erstes_wort), $Striped_Zeile_Ohne_Kommentare) = True Then ;Auto Klammern auf bzw. zu
		If Not StringInStr(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), "(") And Not StringInStr(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), ")") Then
			Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare) + $Korrekturwert, "(")
			$Korrekturwert = $Korrekturwert + StringLen("(")
		EndIf

		If Not StringInStr(Sci_GetLine($sci_handle, $Zeile_vor_Enter - 1), ")") Then
			Sci_InsertText($sci_handle, Sci_GetLineStartPos($sci_handle, $Zeile_vor_Enter - 1) + StringLen($Tabs) + StringLen($Striped_Zeile_Ohne_Kommentare) + $Korrekturwert, ")")
			$Korrekturwert = $Korrekturwert + StringLen(")")
		EndIf
	EndIf

EndFunc   ;==>_Autoinsertion_Smart_Korrektur


Func _Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard($sci_handle = "", $Startline = 0, $erstes_wort = "if", $Erstes_Wort_col = 0)
	If $sci_handle = "" Then Return True
	Local $End_Word = ""


	For $zeile = $Startline To Sci_GetLineCount($sci_handle)
		$textline = Sci_GetLine($sci_handle, $zeile)

;~ for $x=0 to ubound($KeyWordList)-1
		Switch StringLower($erstes_wort)

			Case "if"
				$End_Word = "endif"
				If StringInStr($textline, "if ") And StringInStr($textline, "if ") = $Erstes_Wort_col Then Return False
				If StringInStr($textline, "endif") And StringInStr($textline, "endif") = $Erstes_Wort_col Then Return True
				If StringInStr($textline, "endfunc") Then Return False ;Nur bis zum Ende einer Funktion suchen

			Case "elseif"
				$End_Word = "endif"
				If StringInStr($textline, "elseif ") And StringInStr($textline, "elseif ") = $Erstes_Wort_col Then Return False
				If StringInStr($textline, "endif") And StringInStr($textline, "endif") = $Erstes_Wort_col Then Return True
				If StringInStr($textline, "endfunc") Then Return False ;Nur bis zum Ende einer Funktion suchen

			Case "while"
				$End_Word = "wend"
				If StringInStr($textline, "while ") And StringInStr($textline, "while ") = $Erstes_Wort_col Then Return False
				If StringInStr($textline, "wend") And StringInStr($textline, "wend") = $Erstes_Wort_col Then Return True
				If StringInStr($textline, "endfunc") Then Return False ;Nur bis zum Ende einer Funktion suchen

			Case "with"
				$End_Word = "endwith"
				If StringInStr($textline, "with ") And StringInStr($textline, "with ") = $Erstes_Wort_col Then Return False
				If StringInStr($textline, "endwith") And StringInStr($textline, "endwith") = $Erstes_Wort_col Then Return True
				If StringInStr($textline, "endfunc") Then Return False ;Nur bis zum Ende einer Funktion suchen

			Case "switch"
				$End_Word = "endswitch"
				If StringInStr($textline, "switch ") And StringInStr($textline, "switch ") = $Erstes_Wort_col Then Return False
				If StringInStr($textline, "endswitch") And StringInStr($textline, "endswitch") = $Erstes_Wort_col Then Return True
				If StringInStr($textline, "endfunc") Then Return False ;Nur bis zum Ende einer Funktion suchen

			Case "for"
				$End_Word = "next"
				If StringInStr($textline, "for ") And StringInStr($textline, "for ") = $Erstes_Wort_col Then Return False
				If StringInStr($textline, "next") And StringInStr($textline, "next") = $Erstes_Wort_col Then Return True
				If StringInStr($textline, "endfunc") Then Return False ;Nur bis zum Ende einer Funktion suchen

			Case "do"
				$End_Word = "until"
				If StringInStr($textline, "do ") And StringInStr($textline, "do ") = $Erstes_Wort_col Then Return False
				If StringInStr($textline, "until") And StringInStr($textline, "until") = $Erstes_Wort_col Then Return True
				If StringInStr($textline, "endfunc") Then Return False ;Nur bis zum Ende einer Funktion suchen

			Case "select"
				$End_Word = "endselect"
				If StringInStr($textline, "select ") And StringInStr($textline, "select ") = $Erstes_Wort_col Then Return False
				If StringInStr($textline, "endselect") And StringInStr($textline, "endselect") = $Erstes_Wort_col Then Return True
				If StringInStr($textline, "endfunc") Then Return False ;Nur bis zum Ende einer Funktion suchen

			Case "func"
				$End_Word = "endfunc"
				If StringInStr($textline, "endfunc") Then Return True
				If StringInStr($textline, "func ") Then Return False


		EndSwitch
;~    if ubound($KeyWordList)-1 <> "func" AND StringInStr($textline,"endfunc") then return false
		If StringInStr($textline, $End_Word) Then
			If StringInStr($textline, $End_Word) < $Erstes_Wort_col Then Return False
		EndIf

;~ next


	Next
	Return False ;Wenn letzte Zeile erreicht wurde
EndFunc   ;==>_Autoinsertion_nach_Enter_Suche_gueltiges_End_Keywoard



; #FUNCTION# ====================================================================================================================
; Name ..........: StringMatchAndGet
; Description ...: A simple function for finding words with regular expression
; Syntax ........: StringMatchAndGet($String, $Pattern)
; Parameters ....: $String              - A string to use
;                  $Pattern             - A pattern to find any word.
; Return values .: None
; Author ........: kcvinu
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func StringMatchAndGet($String, $Pattern)
	Local $result
	Local $MatchArray = StringRegExp($String, $Pattern, 1)
	If @error Then
		$MatchArray = " "
	Else
		$result = $MatchArray[0]
	EndIf
	Return $result
EndFunc   ;==>StringMatchAndGet

Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)

	If IsDeclared("Logo_PNG") Then
		If $hWnd = $Logo_PNG And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
	EndIf

EndFunc   ;==>WM_NCHITTEST

Func _Adlib_ISN_Ram_bereinigen()
	_ReduceMemory(@AutoItPID) ;Ram sparen ;)
EndFunc   ;==>_Adlib_ISN_Ram_bereinigen

Func _GuiCtrlGetFocus($GuiRef)
	Local $hWnd = ControlGetHandle($GuiRef, "", ControlGetFocus($GuiRef))
	Local $result = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hWnd)
	Return $result[0]
EndFunc   ;==>_GuiCtrlGetFocus

Func _QuickView_GUI_nach_Dummycontrol_ausrichten()
	$QuickView_Dummy_Control_pos_Array = ControlGetPos($Studiofenster, "", $QuickView_Dummy_Control)
	If Not IsArray($QuickView_Dummy_Control_pos_Array) Then Return
	_WinAPI_SetWindowPos($QuickView_GUI, $HWND_TOP, $QuickView_Dummy_Control_pos_Array[0], $QuickView_Dummy_Control_pos_Array[1], $QuickView_Dummy_Control_pos_Array[2], $QuickView_Dummy_Control_pos_Array[3], $SWP_NOACTIVATE + $SWP_NOOWNERZORDER)
EndFunc   ;==>_QuickView_GUI_nach_Dummycontrol_ausrichten

Func _QuickView_GUI_Resize()
	$QuickView_GUI_client_array = WinGetClientSize($QuickView_GUI)
	If Not IsArray($QuickView_GUI_client_array) Then Return
	$quickview_tab_Item0_Rect = _GUICtrlTab_GetItemRect($quickview_tab, 0)
	If Not IsArray($quickview_tab_Item0_Rect) Then Return
	_WinAPI_SetWindowPos($Programm_log, $HWND_TOP, 0, $quickview_tab_Item0_Rect[3] + $Splitter_Rand, $QuickView_GUI_client_array[0], $QuickView_GUI_client_array[1] - ($quickview_tab_Item0_Rect[3] + $Splitter_Rand), $SWP_NOACTIVATE)
	_WinAPI_SetWindowPos($Codeablage_scintilla, $HWND_TOP, 0, $quickview_tab_Item0_Rect[3] + $Splitter_Rand, $QuickView_GUI_client_array[0], $QuickView_GUI_client_array[1] - ($quickview_tab_Item0_Rect[3] + $Splitter_Rand), $SWP_NOACTIVATE)

	;ToDoListe Spalten resize
	$quick_view_ToDoList_Listview_Pos_Array = ControlGetPos($QuickView_GUI, "", $quick_view_ToDoList_Listview)
	If Not IsArray($quick_view_ToDoList_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($quick_view_ToDoList_Listview, 2, ($quick_view_ToDoList_Listview_Pos_Array[2] / 100) * 65)
	_GUICtrlListView_SetColumnWidth($quick_view_ToDoList_Listview, 4, ($quick_view_ToDoList_Listview_Pos_Array[2] / 100) * 25)



EndFunc   ;==>_QuickView_GUI_Resize


Func _ToDo_Manager_GUI_Resize()
	;ToDoListe Spalten resize
	$ToDoList_Listview_Pos_Array = ControlGetPos($ToDoList_Manager, "", $ToDoList_Listview)
	If Not IsArray($ToDoList_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($ToDoList_Listview, 2, ($ToDoList_Listview_Pos_Array[2] / 100) * 40)
	_GUICtrlListView_SetColumnWidth($ToDoList_Listview, 3, ($ToDoList_Listview_Pos_Array[2] / 100) * 35)
	_GUICtrlListView_SetColumnWidth($ToDoList_Listview, 4, ($ToDoList_Listview_Pos_Array[2] / 100) * 20)
EndFunc   ;==>_ToDo_Manager_GUI_Resize


Func _QuickView_Tab_Event()
	Switch _GUICtrlTab_GetCurSel($quickview_tab)

		Case 0 ;Log
			ControlHide($QuickView_GUI, "", $Codeablage_scintilla)
			ControlShow($QuickView_GUI, "", $Programm_log)

		Case 1 ;Codeablage
			ControlHide($QuickView_GUI, "", $Programm_log)
			ControlShow($QuickView_GUI, "", $Codeablage_scintilla)

		Case 2 ;ToDo Liste
			ControlHide($QuickView_GUI, "", $Codeablage_scintilla)
			ControlHide($QuickView_GUI, "", $Programm_log)


	EndSwitch
	_QuickView_GUI_Resize()
EndFunc   ;==>_QuickView_Tab_Event

Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $Studiofenster
			_Rezize(1)

		Case $pelock_obfuscator_GUI
			_PELock_GUI_Resize()

		Case $Codeausschnitt_GUI
			Codeausschnitt_GUI_Resize()

		Case $Makro_Codeausschnitt_GUI
			_Makro_Codeausschnitt_GUI_Resize()

		Case $QuickView_GUI
			_QuickView_GUI_Resize()

		Case $console_GUI
			_Resize_Debug_Console()

		Case $ParameterEditor_GUI
			AdlibRegister("_Parametereditor_Fenster_anpassen", 50)

	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

Func HttpPost($sURL, $sData = "")
	Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

	$oHTTP.Open("POST", $sURL, False)
	If (@error) Then Return SetError(1, 0, 0)

	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

	$oHTTP.Send($sData)
	If (@error) Then Return SetError(2, 0, 0)

	If ($oHTTP.Status <> $HTTP_STATUS_OK) Then Return SetError(3, 0, 0)

	Return SetError(0, 0, $oHTTP.ResponseText)
EndFunc   ;==>HttpPost

Func HttpGet($sURL, $sData = "")
	Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

	$oHTTP.Open("GET", $sURL & "?" & $sData, False)
	If (@error) Then Return SetError(1, 0, 0)

	$oHTTP.Send()
	If (@error) Then Return SetError(2, 0, 0)

	If ($oHTTP.Status <> $HTTP_STATUS_OK) Then Return SetError(3, 0, 0)

	Return SetError(0, 0, $oHTTP.ResponseText)
EndFunc   ;==>HttpGet


Func _ToDo_Liste_Kategoriefarbe_nach_Item_herausfinden($Listview = "", $item = "")
	If $Offenes_Projekt = "" Then Return $Fenster_Hintergrundfarbe
	If Not _ist_windows_vista_oder_hoeher() Then Return $Fenster_Hintergrundfarbe
	$group_index = _GUICtrlListView_GetItemGroupID($Listview, $item)
	$ToDo_List_categories = _IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then Return $Fenster_Hintergrundfarbe ;Wenn keine Kategorien, dann stopp
	$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
	If Not IsArray($ToDo_List_categories_split) Then Return $Fenster_Hintergrundfarbe
	Return _IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $ToDo_List_categories_split[$group_index] & "_color", "")
EndFunc   ;==>_ToDo_Liste_Kategoriefarbe_nach_Item_herausfinden

Func _ToDo_Liste_leeren()
	_GUICtrlListView_RemoveAllGroups($quick_view_ToDoList_Listview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($quick_view_ToDoList_Listview))
	_GUICtrlListView_RemoveAllGroups($ToDoList_Listview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ToDoList_Listview))
EndFunc   ;==>_ToDo_Liste_leeren


Func _QuickView_ToDo_Liste_neu_einlesen()
	_ToDo_Liste_leeren()
	If Not _ist_windows_vista_oder_hoeher() Then Return


	;Zuerst Aufgabenkategorien einlesen
	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then Return ;Wenn keine Kategorien, dann stopp

	$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
	If Not IsArray($ToDo_List_categories_split) Then Return

	Local $Text_der_Kategorie = ""
	Local $Farbe_der_Kategorie = ""
	Local $Items_der_Kategorie = ""
	Local $Item_Betreff = ""
	Local $Item_Datum = ""
	Local $Item_Text = ""

	_GUICtrlListView_BeginUpdate($quick_view_ToDoList_Listview)
	_GUICtrlListView_BeginUpdate($ToDoList_Listview)

	For $Index = 0 To UBound($ToDo_List_categories_split) - 1
		If $ToDo_List_categories_split[$Index] = "" Then ContinueLoop

		;Kategorie erstellen
		$Text_der_Kategorie = _IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $ToDo_List_categories_split[$Index] & "_text", "")
		$Text_der_Kategorie = _ISN_Variablen_aufloesen($Text_der_Kategorie)
		$Farbe_der_Kategorie = _IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $ToDo_List_categories_split[$Index] & "_color", "")
		$Items_der_Kategorie = _IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $ToDo_List_categories_split[$Index] & "_items", "")

		;QuickView
		_GUICtrlListView_InsertGroup($quick_view_ToDoList_Listview, -1, $Index, $Text_der_Kategorie, 1)
		_GUICtrlListView_SetGroupInfo($quick_view_ToDoList_Listview, $Index, $Text_der_Kategorie, 1, $LVGS_COLLAPSIBLE)

		;MainGUI
		_GUICtrlListView_InsertGroup($ToDoList_Listview, -1, $Index, $Text_der_Kategorie, 1)
		_GUICtrlListView_SetGroupInfo($ToDoList_Listview, $Index, $Text_der_Kategorie, 1, $LVGS_COLLAPSIBLE)


		;Items laden
		If $Items_der_Kategorie <> "" Then
			$Items_der_Kategorie_split = StringSplit($Items_der_Kategorie, "|", 2)
			If Not IsArray($Items_der_Kategorie_split) Then ContinueLoop
			For $item_index = 0 To UBound($Items_der_Kategorie_split) - 1
				If $Items_der_Kategorie_split[$item_index] = "" Then ContinueLoop

				;Einträge Laden
				$Item_Betreff = _IniReadRaw($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Items_der_Kategorie_split[$item_index], "subject", "")
				$Item_Text = _IniReadRaw($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Items_der_Kategorie_split[$item_index], "text", "")
				$Item_Text = StringReplace($Item_Text, "[BREAK]", " ")
				$Item_Datum = _IniReadRaw($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Items_der_Kategorie_split[$item_index], "date", "")
;~ 				  If $Languagefile = "german.lng" Then $Item_Datum = Date_AutoIt_2_German($Item_Datum) ;In Deutsches Datum umwandeln


				$new_item = _GUICtrlListView_AddItem($quick_view_ToDoList_Listview, $Items_der_Kategorie_split[$item_index]) ;id
				_GUICtrlListView_AddSubItem($quick_view_ToDoList_Listview, $new_item, $ToDo_List_categories_split[$Index], 1) ;cat
				_GUICtrlListView_AddSubItem($quick_view_ToDoList_Listview, $new_item, $Item_Betreff, 2) ;betreff
				_GUICtrlListView_AddSubItem($quick_view_ToDoList_Listview, $new_item, $Item_Text, 3) ;Text
				_GUICtrlListView_AddSubItem($quick_view_ToDoList_Listview, $new_item, $Item_Datum, 4) ;datum
				_GUICtrlListView_SetItemGroupID($quick_view_ToDoList_Listview, $new_item, $Index)

				$new_item = _GUICtrlListView_AddItem($ToDoList_Listview, $Items_der_Kategorie_split[$item_index]) ;id
				_GUICtrlListView_AddSubItem($ToDoList_Listview, $new_item, $ToDo_List_categories_split[$Index], 1) ;cat
				_GUICtrlListView_AddSubItem($ToDoList_Listview, $new_item, $Item_Betreff, 2) ;betreff
				_GUICtrlListView_AddSubItem($ToDoList_Listview, $new_item, $Item_Text, 3) ;Text
				_GUICtrlListView_AddSubItem($ToDoList_Listview, $new_item, $Item_Datum, 4) ;datum
				_GUICtrlListView_SetItemGroupID($ToDoList_Listview, $new_item, $Index)

			Next
		EndIf
	Next





	_GUICtrlListView_EnableGroupView($quick_view_ToDoList_Listview)
	_GUICtrlListView_EnableGroupView($ToDoList_Listview)


	_Sortiere_Listview($quick_view_ToDoList_Listview, 4, 1) ;Nach Datum Sortieren
	_Sortiere_Listview($ToDoList_Listview, 4, 1) ;Nach Datum Sortieren

	;Ersetze Englisches Datum durch Deutsches
	If $Languagefile = "german.lng" Then
		For $y = 0 To _GUICtrlListView_GetItemCount($quick_view_ToDoList_Listview) - 1
			$Datum = _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, $y, 4)
			$Datum = Date_AutoIt_2_German($Datum) ;In Deutsches Datum umwandeln
			_GUICtrlListView_SetItemText($quick_view_ToDoList_Listview, $y, $Datum, 4)
			_GUICtrlListView_SetItemText($ToDoList_Listview, $y, $Datum, 4)
		Next
	EndIf

	_GUICtrlListView_EndUpdate($quick_view_ToDoList_Listview)
	_GUICtrlListView_EndUpdate($ToDoList_Listview)

EndFunc   ;==>_QuickView_ToDo_Liste_neu_einlesen




; modified sort call back from include GuiListView.au3
Func __GUICtrlListView_SortItems($hWnd, $iCol, $sort = -1)
	Local $iRet, $iIndex, $pFunction, $hHeader, $iFormat

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	For $x = 1 To $__g_aListViewSortInfo[0][0]
		If $hWnd = $__g_aListViewSortInfo[$x][1] Then
			$iIndex = $x
			ExitLoop
		EndIf
	Next

	$pFunction = DllCallbackGetPtr($__g_aListViewSortInfo[$iIndex][2]) ; get pointer to call back
	$__g_aListViewSortInfo[$iIndex][3] = $iCol ; $nColumn = column clicked
	$__g_aListViewSortInfo[$iIndex][7] = 0 ; $bSet
	$__g_aListViewSortInfo[$iIndex][4] = $__g_aListViewSortInfo[$iIndex][6] ; nCurCol = $nCol
	$iRet = _SendMessage($hWnd, $LVM_SORTITEMSEX, $hWnd, $pFunction, 0, "hwnd", "ptr")
	If $iRet <> 0 Then
		If $__g_aListViewSortInfo[$iIndex][9] Then ; Use arrow in header
			$hHeader = $__g_aListViewSortInfo[$iIndex][10]
			For $x = 0 To _GUICtrlHeader_GetItemCount($hHeader) - 1
				$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $x)
				If BitAND($iFormat, $HDF_SORTDOWN) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTDOWN))
				ElseIf BitAND($iFormat, $HDF_SORTUP) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTUP))
				EndIf
			Next
			$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $iCol)
			If $sort = -1 Then ; ascending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTUP))
			Else ; descending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTDOWN))
			EndIf
		EndIf
	EndIf

	Return $iRet <> 0
EndFunc   ;==>__GUICtrlListView_SortItems

Func _Toggle_ToDo_manager()
	If Not _ist_windows_vista_oder_hoeher() Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1294), 0, $Studiofenster)
		Return
	EndIf
	$state = WinGetState($ToDoList_Manager, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_HIDE, $ToDoList_Manager)
	Else
		_ToDo_Manager_GUI_Resize()
		GUISetState(@SW_SHOW, $ToDoList_Manager)
	EndIf
EndFunc   ;==>_Toggle_ToDo_manager


Func _ToDo_Liste_Kategorie_anhand_Item_finden($Listview = "", $item = "")
	If $Listview = "" Then Return
	If $item == "" Then Return
	;Quellkategorie finden
	$tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_STRING)
	$return = _GUICtrlListView_FindItem($Listview, -1, $tInfo, $item)
	If $return = -1 Then Return ""
	Return _GUICtrlListView_GetItemText($Listview, $return, 1)
EndFunc   ;==>_ToDo_Liste_Kategorie_anhand_Item_finden

;$Zielitem ist 0 index der Listview
;$Quellitem der text aus der ini
Func _ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben($Listview = "", $Zielkategorie = "", $Quellitem = "")
	If $Listview = "" Then Return
	If $Zielkategorie == "" Then Return


	If $Quellitem = "" Then ;Bei "" aktuell markiertes Element verwenden
		If _GUICtrlListView_GetSelectionMark($Listview) = -1 Then Return
		$Quellitem = _GUICtrlListView_GetItemText($Listview, _GUICtrlListView_GetSelectionMark($Listview), 0)
	EndIf


	$Quellkategorie = _ToDo_Liste_Kategorie_anhand_Item_finden($Listview, $Quellitem)
	If $Zielkategorie = $Quellkategorie Then Return ;Wenn schon in gewünschter Kategorie, dann Abbruch!


	;Item aus Quellkategorie löschen...
	$Items_der_Quellkategorie = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Quellkategorie & "_items", "")
	If $Items_der_Quellkategorie = "" Then Return ;Wenn keine Kategorien, dann stopp
	$Items_der_Quellkategorie_split = StringSplit($Items_der_Quellkategorie, "|", 2)
	If Not IsArray($Items_der_Quellkategorie_split) Then Return
	$neuer_itemstring = ""
	For $Index = 0 To UBound($Items_der_Quellkategorie_split) - 1
		If $Items_der_Quellkategorie_split[$Index] = $Quellitem Then ContinueLoop
		$neuer_itemstring = $neuer_itemstring & $Items_der_Quellkategorie_split[$Index] & "|"
	Next
	If StringRight($neuer_itemstring, 1) = "|" Then $neuer_itemstring = StringTrimRight($neuer_itemstring, 1) ;Letztes | löschen
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Quellkategorie & "_items", $neuer_itemstring)

	;..und in Zielkategorie eintragen
	$Items_der_Zielkategorie = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Zielkategorie & "_items", "")
	$Items_der_Zielkategorie = $Items_der_Zielkategorie & "|" & $Quellitem
	If StringLeft($Items_der_Zielkategorie, 1) = "|" Then $Items_der_Zielkategorie = StringTrimLeft($Items_der_Zielkategorie, 1) ;Erstes | löschen
	If StringRight($Items_der_Zielkategorie, 1) = "|" Then $Items_der_Zielkategorie = StringTrimRight($Items_der_Zielkategorie, 1) ;Letztes | löschen (falls vorhanden...warum auch immer)
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Zielkategorie & "_items", $Items_der_Zielkategorie)

	;Listen neu einlesen
	_QuickView_ToDo_Liste_neu_einlesen()
EndFunc   ;==>_ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben


Func _QuickView_Aufgabe_Abschliessen()
	If Not _ist_windows_vista_oder_hoeher() Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1294), 0, $Studiofenster)
		Return
	EndIf
	If _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview) = -1 Then Return
	_ToDo_Liste_Aufgabe_Abschliessen($quick_view_ToDoList_Listview, _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview), 0))
EndFunc   ;==>_QuickView_Aufgabe_Abschliessen

Func _QuickView_Aufgabe_in_naechste_Kategorie_verschieben()
	If Not _ist_windows_vista_oder_hoeher() Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1294), 0, $Studiofenster)
		Return
	EndIf
	If _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview) = -1 Then Return
	_ToDo_Liste_Aufgabe_in_naechste_Kategorie_verschieben($quick_view_ToDoList_Listview, _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview), 0))
EndFunc   ;==>_QuickView_Aufgabe_in_naechste_Kategorie_verschieben

Func _ToDo_Liste_Aufgabe_in_naechste_Kategorie_verschieben_button()
	If _GUICtrlListView_GetSelectionMark($ToDoList_Listview) = -1 Then Return
	_ToDo_Liste_Aufgabe_in_naechste_Kategorie_verschieben($ToDoList_Listview, _GUICtrlListView_GetItemText($ToDoList_Listview, _GUICtrlListView_GetSelectionMark($ToDoList_Listview), 0))
EndFunc   ;==>_ToDo_Liste_Aufgabe_in_naechste_Kategorie_verschieben_button


Func _ToDo_Liste_Aufgabe_Abschliessen_button()
	If _GUICtrlListView_GetSelectionMark($ToDoList_Listview) = -1 Then Return
	_ToDo_Liste_Aufgabe_Abschliessen($ToDoList_Listview, _GUICtrlListView_GetItemText($ToDoList_Listview, _GUICtrlListView_GetSelectionMark($ToDoList_Listview), 0))
EndFunc   ;==>_ToDo_Liste_Aufgabe_Abschliessen_button



Func _QuickView_Aufgabe_in_vorherige_Kategorie_verschieben()
	If Not _ist_windows_vista_oder_hoeher() Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1294), 0, $Studiofenster)
		Return
	EndIf
	If _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview) = -1 Then Return
	_ToDo_Liste_Aufgabe_in_vorherige_Kategorie_verschieben($quick_view_ToDoList_Listview, _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview), 0))
EndFunc   ;==>_QuickView_Aufgabe_in_vorherige_Kategorie_verschieben

Func _ToDo_Liste_Aufgabe_in_vorherige_Kategorie_verschieben_button()
	If _GUICtrlListView_GetSelectionMark($ToDoList_Listview) = -1 Then Return
	_ToDo_Liste_Aufgabe_in_vorherige_Kategorie_verschieben($ToDoList_Listview, _GUICtrlListView_GetItemText($ToDoList_Listview, _GUICtrlListView_GetSelectionMark($ToDoList_Listview), 0))
EndFunc   ;==>_ToDo_Liste_Aufgabe_in_vorherige_Kategorie_verschieben_button



Func _ToDo_Liste_Aufgabe_Abschliessen($Listview = "", $Quellitem = "")
	If _GUICtrlListView_GetSelectionMark($Listview) = -1 Then Return
	If $Listview = "" Then Return
	If $Quellitem = "" Then Return

	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then Return ;Wenn keine Kategorien, dann stopp

	$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
	If Not IsArray($ToDo_List_categories_split) Then Return


	Local $Quellkategorie = _ToDo_Liste_Kategorie_anhand_Item_finden($Listview, $Quellitem)
	Local $Zielkategorie = $ToDo_List_categories_split[UBound($ToDo_List_categories_split) - 1] ;Letzte Kategorie
	If $Quellkategorie = $Zielkategorie Then Return ;Bereits Abgeschlossen


	_ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben($Listview, $Zielkategorie, $Quellitem)
EndFunc   ;==>_ToDo_Liste_Aufgabe_Abschliessen


Func _ToDo_Liste_Aufgabe_in_naechste_Kategorie_verschieben($Listview = "", $Quellitem = "")
	If _GUICtrlListView_GetSelectionMark($Listview) = -1 Then Return
	If $Listview = "" Then Return
	If $Quellitem = "" Then Return

	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then Return ;Wenn keine Kategorien, dann stopp

	$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
	If Not IsArray($ToDo_List_categories_split) Then Return

	Local $Quellkategorie = _ToDo_Liste_Kategorie_anhand_Item_finden($Listview, $Quellitem)
	Local $Zielkategorie = ""

	For $Index = 0 To UBound($ToDo_List_categories_split) - 1
		If $ToDo_List_categories_split[$Index] = $Quellkategorie Then
			If $Index + 1 > UBound($ToDo_List_categories_split) - 1 Then Return ;Bereits in letzter Kategorie
			$Zielkategorie = $ToDo_List_categories_split[$Index + 1]
			ExitLoop
		EndIf
	Next

	If $Quellkategorie = $Zielkategorie Then Return
	_ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben($Listview, $Zielkategorie, $Quellitem)

	;"altes" Item wieder Markieren
	$tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_STRING)
	$find = _GUICtrlListView_FindItem($Listview, -1, $tInfo, $Quellitem)
	If $find <> -1 Then
		_GUICtrlListView_SetItemSelected($Listview, $find, True, True)
		_GUICtrlListView_SetItemFocused($Listview, $find, True)
	EndIf

EndFunc   ;==>_ToDo_Liste_Aufgabe_in_naechste_Kategorie_verschieben


Func _ToDo_Liste_Aufgabe_in_vorherige_Kategorie_verschieben($Listview = "", $Quellitem = "")
	If _GUICtrlListView_GetSelectionMark($Listview) = -1 Then Return
	If $Listview = "" Then Return
	If $Quellitem = "" Then Return

	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then Return ;Wenn keine Kategorien, dann stopp

	$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
	If Not IsArray($ToDo_List_categories_split) Then Return

	Local $Quellkategorie = _ToDo_Liste_Kategorie_anhand_Item_finden($Listview, $Quellitem)
	Local $Zielkategorie = ""

	For $Index = 0 To UBound($ToDo_List_categories_split) - 1
		If $ToDo_List_categories_split[$Index] = $Quellkategorie Then
			If $Index - 1 < 0 Then Return ;Bereits in erster Kategorie
			$Zielkategorie = $ToDo_List_categories_split[$Index - 1]
			ExitLoop
		EndIf
	Next

	If $Quellkategorie = $Zielkategorie Then Return
	_ToDo_Liste_Aufgabe_in_andere_Kategorie_verschieben($Listview, $Zielkategorie, $Quellitem)

	;"altes" Item wieder Markieren
	$tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_STRING)
	$find = _GUICtrlListView_FindItem($Listview, -1, $tInfo, $Quellitem)
	If $find <> -1 Then
		_GUICtrlListView_SetItemSelected($Listview, $find, True, True)
		_GUICtrlListView_SetItemFocused($Listview, $find, True)
	EndIf

EndFunc   ;==>_ToDo_Liste_Aufgabe_in_vorherige_Kategorie_verschieben

Func _System_benoetigt_double_byte_character_Support()
	;True = Chinesische Systeme

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

	Return False ;Nicht benötigt (zb. für deutsche oder englische systeme)
EndFunc   ;==>_System_benoetigt_double_byte_character_Support

Func _ToDo_Liste_Kategorien_verwalten_zeige_Manager()
	If Not _ist_windows_vista_oder_hoeher() Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1294), 0, $Studiofenster)
		Return
	EndIf
	_ToDo_Liste_Kategorien_verwalten_GUI_Resize()
	_ToDo_Liste_Kategorien_verwalten_Liste_Laden()
	GUISetState(@SW_SHOW, $ToDoList_Category_Manager)
	GUISetState(@SW_DISABLE, $ToDoList_Manager)
	GUISetState(@SW_DISABLE, $Studiofenster)

EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_zeige_Manager

Func _ToDo_Liste_Kategorien_verwalten_Manager_ausblenden()
	GUISetState(@SW_ENABLE, $ToDoList_Manager)
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $ToDoList_Category_Manager)
	_QuickView_ToDo_Liste_neu_einlesen()
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Manager_ausblenden

Func _ToDo_Liste_Kategorien_verwalten_GUI_Resize()
	;ToDoListe Spalten resize
	$Category_Manager_Listview_Pos_Array = ControlGetPos($ToDoList_Category_Manager, "", $Category_Manager_Listview)
	If Not IsArray($Category_Manager_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Category_Manager_Listview, 1, ($Category_Manager_Listview_Pos_Array[2] / 100) * 95)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_GUI_Resize

Func _ToDo_Liste_Kategorien_verwalten_Liste_Laden()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Category_Manager_Listview))

	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then Return ;Wenn keine Kategorien, dann stopp

	$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
	If Not IsArray($ToDo_List_categories_split) Then Return

	For $Index = 0 To UBound($ToDo_List_categories_split) - 1
		If $ToDo_List_categories_split[$Index] = "" Then ContinueLoop
		$new_item = _GUICtrlListView_AddItem($Category_Manager_Listview, $ToDo_List_categories_split[$Index]) ;id
		_GUICtrlListView_AddSubItem($Category_Manager_Listview, $new_item, _ISN_Variablen_aufloesen(_IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $ToDo_List_categories_split[$Index] & "_text", "")), 1) ;Text der Kategorie
	Next

EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Liste_Laden



Func _ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_nach_oben_verschieben()
	If _GUICtrlListView_GetSelectionMark($Category_Manager_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($Category_Manager_Listview) = 0 Then Return
	_GUICtrlListView_MoveItems($Category_Manager_Listview, -1)
	_GUICtrlListView_EnsureVisible($Category_Manager_Listview, _GUICtrlListView_GetSelectionMark($Category_Manager_Listview))
	_GUICtrlListView_SetItemSelected($Category_Manager_Listview, _GUICtrlListView_GetSelectionMark($Category_Manager_Listview), True, True)

	;Einträge in INI Speichern
	$ToDo_List_categories = ""
	For $Index = 0 To _GUICtrlListView_GetItemCount($Category_Manager_Listview) - 1
		$ToDo_List_categories = $ToDo_List_categories & _GUICtrlListView_GetItemText($Category_Manager_Listview, $Index, 0) & "|"
	Next
	If StringRight($ToDo_List_categories, 1) = "|" Then $ToDo_List_categories = StringTrimRight($ToDo_List_categories, 1)
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", $ToDo_List_categories)

EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_nach_oben_verschieben

Func _ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_nach_unten_verschieben()
	If _GUICtrlListView_GetSelectionMark($Category_Manager_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($Category_Manager_Listview) = 0 Then Return
	_GUICtrlListView_MoveItems($Category_Manager_Listview, 1)
	_GUICtrlListView_EnsureVisible($Category_Manager_Listview, _GUICtrlListView_GetSelectionMark($Category_Manager_Listview))
	_GUICtrlListView_SetItemSelected($Category_Manager_Listview, _GUICtrlListView_GetSelectionMark($Category_Manager_Listview), True, True)

	;Einträge in INI Speichern
	$ToDo_List_categories = ""
	For $Index = 0 To _GUICtrlListView_GetItemCount($Category_Manager_Listview) - 1
		$ToDo_List_categories = $ToDo_List_categories & _GUICtrlListView_GetItemText($Category_Manager_Listview, $Index, 0) & "|"
	Next
	If StringRight($ToDo_List_categories, 1) = "|" Then $ToDo_List_categories = StringTrimRight($ToDo_List_categories, 1)
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", $ToDo_List_categories)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_nach_unten_verschieben

Func _ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_loeschen()
	If _GUICtrlListView_GetSelectionMark($Category_Manager_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($Category_Manager_Listview) = 0 Then Return

	GUICtrlSetState($todo_category_loeschen_delete_all_radio, $GUI_CHECKED)
	GUICtrlSetData($todo_category_loeschen_categories_combo, "", "")
	_ToDo_Liste_Kategorien_verwalten_Kategoriue_loeschen_Radio_Event()

	GUISetState(@SW_SHOW, $ToDoList_Delete_Category)
	GUISetState(@SW_DISABLE, $ToDoList_Category_Manager)


EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_loeschen

Func _ToDo_Liste_Kategorien_verwalten_Kategoriue_loeschen_Radio_Event()
	If GUICtrlRead($todo_category_loeschen_delete_all_radio) = $GUI_CHECKED Then
		GUICtrlSetData($todo_category_loeschen_categories_combo, "", "")
		GUICtrlSetState($todo_category_loeschen_categories_combo, $GUI_DISABLE)
	Else
		GUICtrlSetState($todo_category_loeschen_categories_combo, $GUI_ENABLE)

		$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
		If $ToDo_List_categories = "" Then Return ;Wenn keine Kategorien, dann stopp

		$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
		If Not IsArray($ToDo_List_categories_split) Then Return

		$ToDo_Liste_Kategorie_loaschen_Combo = $Leeres_Array
		$Combostring = ""
		For $Index = 0 To UBound($ToDo_List_categories_split) - 1
			If $ToDo_List_categories_split[$Index] = "" Then ContinueLoop
			If $ToDo_List_categories_split[$Index] = _GUICtrlListView_GetItemText($Category_Manager_Listview, _GUICtrlListView_GetSelectionMark($Category_Manager_Listview), 0) Then ContinueLoop ;Zu löschende Kategorie NICHT eintragen ^^
			$Combostring = $Combostring & _ISN_Variablen_aufloesen(_IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $ToDo_List_categories_split[$Index] & "_text", "")) & "|"
			_ArrayAdd($ToDo_Liste_Kategorie_loaschen_Combo, $ToDo_List_categories_split[$Index])
		Next
		If StringRight($Combostring, 1) = "|" Then $Combostring = StringTrimRight($Combostring, 1)
		GUICtrlSetData($todo_category_loeschen_categories_combo, $Combostring, "")

	EndIf
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Kategoriue_loeschen_Radio_Event


Func _ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_loeschen_Abbrechen()
	GUISetState(@SW_ENABLE, $ToDoList_Category_Manager)
	GUISetState(@SW_HIDE, $ToDoList_Delete_Category)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_loeschen_Abbrechen

Func _ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_loeschen_OK()
	If _GUICtrlListView_GetSelectionMark($Category_Manager_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($Category_Manager_Listview) = 0 Then Return

	$zu_loeschende_Cat = _GUICtrlListView_GetItemText($Category_Manager_Listview, _GUICtrlListView_GetSelectionMark($Category_Manager_Listview), 0)

	If GUICtrlRead($todo_category_loeschen_delete_all_radio) = $GUI_CHECKED Then
		;Kategorie+Aufgaben löschen

		$ToDo_List_Items_String = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $zu_loeschende_Cat & "_items", "")
		$ToDo_List_Items_split_Array = StringSplit($ToDo_List_Items_String, "|", 2)
		If IsArray($ToDo_List_Items_split_Array) Then
			For $Count = 0 To UBound($ToDo_List_Items_split_Array) - 1
				If $ToDo_List_Items_split_Array[$Count] = "" Then ContinueLoop
				;Items löschen
				IniDelete($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $ToDo_List_Items_split_Array[$Count])
			Next
		EndIf

	Else
		;Aufgaben in neue Kategorie verschieben

		If IsArray($ToDo_Liste_Kategorie_loaschen_Combo) Then
			If GUICtrlRead($todo_category_loeschen_categories_combo) = "" Then
				MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1288), 0, $ToDoList_Delete_Category)
				Return
			EndIf
			$Selected_cat = $ToDo_Liste_Kategorie_loaschen_Combo[_GUICtrlComboBox_GetCurSel($todo_category_loeschen_categories_combo)]

			;Items einlesen...
			$alte_Items_zu_loeschende_Kategorie = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $zu_loeschende_Cat & "_items", "")

			;..und in Zielkategorie eintragen
			$Items_zeilkatekorie = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Selected_cat & "_items", "")
			$Items_zeilkatekorie = $Items_zeilkatekorie & "|" & $alte_Items_zu_loeschende_Kategorie
			If StringRight($Items_zeilkatekorie, 1) = "|" Then $Items_zeilkatekorie = StringTrimRight($Items_zeilkatekorie, 1)
			IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Selected_cat & "_items", $Items_zeilkatekorie)

		EndIf
	EndIf


	;Kategorie endgültig entfernen
	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
	If Not IsArray($ToDo_List_categories_split) Then Return
	$Neuer_Kategoriestring = ""
	For $Index = 0 To UBound($ToDo_List_categories_split) - 1
		If $ToDo_List_categories_split[$Index] = "" Then ContinueLoop
		If $ToDo_List_categories_split[$Index] = $zu_loeschende_Cat Then ContinueLoop ;Diese Kategorie wird gelöscht
		$Neuer_Kategoriestring = $Neuer_Kategoriestring & $ToDo_List_categories_split[$Index] & "|"
	Next
	If StringRight($Neuer_Kategoriestring, 1) = "|" Then $Neuer_Kategoriestring = StringTrimRight($Neuer_Kategoriestring, 1)

	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", $Neuer_Kategoriestring)
	IniDelete($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $zu_loeschende_Cat & "_items")
	IniDelete($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $zu_loeschende_Cat & "_text")
	IniDelete($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $zu_loeschende_Cat & "_color")


	;Kategorien neu einlesen
	_ToDo_Liste_Kategorien_verwalten_Liste_Laden()

	GUISetState(@SW_ENABLE, $ToDoList_Category_Manager)
	GUISetState(@SW_HIDE, $ToDoList_Delete_Category)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_loeschen_OK

Func _ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_bearbeiten()
	If _GUICtrlListView_GetSelectionMark($Category_Manager_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($Category_Manager_Listview) = 0 Then Return

	GUICtrlSetData($neue_kategorie_title_label, _Get_langstr(1275))
	WinSetTitle($ToDoList_New_Category, "", _Get_langstr(1275))

	$Kategorie_ID = _GUICtrlListView_GetItemText($Category_Manager_Listview, _GUICtrlListView_GetSelectionMark($Category_Manager_Listview), 0)
	GUICtrlSetData($neue_kategorie_ID_label, $Kategorie_ID)

	GUICtrlSetData($neue_kategorie_Text_input, _IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie_ID & "_text", ""))
	GUICtrlSetData($neue_kategorie_Farbe_input, IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie_ID & "_color", ""))

	If GUICtrlRead($neue_kategorie_Farbe_input) = "" Then
		GUICtrlSetColor($neue_kategorie_Farbe_input, $Schriftfarbe)
		GUICtrlSetBkColor($neue_kategorie_Farbe_input, $Fenster_Hintergrundfarbe)
	Else
		GUICtrlSetBkColor($neue_kategorie_Farbe_input, Execute(GUICtrlRead($neue_kategorie_Farbe_input)))
		GUICtrlSetColor($neue_kategorie_Farbe_input, _ColourInvert(Execute(GUICtrlRead($neue_kategorie_Farbe_input))))
	EndIf

	GUICtrlSetOnEvent($neue_kategorie_ok_button, "_ToDo_Liste_Kategorien_verwalten_Kategorie_Bearbeiten_OK")

	GUISetState(@SW_SHOW, $ToDoList_New_Category)
	GUISetState(@SW_DISABLE, $ToDoList_Category_Manager)

EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Markierte_Kategorie_bearbeiten

Func _ToDo_Liste_Kategorien_verwalten_Neue_Kategorie()
	GUICtrlSetData($neue_kategorie_title_label, _Get_langstr(1274))
	WinSetTitle($ToDoList_New_Category, "", _Get_langstr(1274))

	$neue_Kategorie_ID = "ct_" & @YEAR & @MON & @MDAY & @SEC & Random(0, 500, 1)
	GUICtrlSetData($neue_kategorie_ID_label, $neue_Kategorie_ID)

	GUICtrlSetData($neue_kategorie_Text_input, "")
	GUICtrlSetData($neue_kategorie_Farbe_input, "")
	GUICtrlSetColor($neue_kategorie_Farbe_input, $Schriftfarbe)
	GUICtrlSetBkColor($neue_kategorie_Farbe_input, $Fenster_Hintergrundfarbe)

	GUICtrlSetOnEvent($neue_kategorie_ok_button, "_ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Erstellen")

	GUISetState(@SW_SHOW, $ToDoList_New_Category)
	GUISetState(@SW_DISABLE, $ToDoList_Category_Manager)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Neue_Kategorie



Func _ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Keine_Farbe()
	GUICtrlSetData($neue_kategorie_Farbe_input, "")
	GUICtrlSetColor($neue_kategorie_Farbe_input, $Schriftfarbe)
	GUICtrlSetBkColor($neue_kategorie_Farbe_input, $Fenster_Hintergrundfarbe)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Keine_Farbe

Func _ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Farbe_waehlen()
	$res = _ChooseColor(2, GUICtrlRead($neue_kategorie_Farbe_input), 2, $ToDoList_New_Category)
	If $res = -1 Then Return
	GUICtrlSetData($neue_kategorie_Farbe_input, $res)
	GUICtrlSetColor($neue_kategorie_Farbe_input, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($neue_kategorie_Farbe_input, $res)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Farbe_waehlen

Func _ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Abbrechen()
	GUISetState(@SW_ENABLE, $ToDoList_Category_Manager)
	GUISetState(@SW_HIDE, $ToDoList_New_Category)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Abbrechen

Func _ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Erstellen()

	If GUICtrlRead($neue_kategorie_Text_input) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1228), 0, $ToDoList_New_Category)
		Return
	EndIf

	;Neue Kategorie in INI_Speichern
	$ToDo_List_categories = _IniReadRaw($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	$ToDo_List_categories = $ToDo_List_categories & "|" & GUICtrlRead($neue_kategorie_ID_label)
	If StringLeft($ToDo_List_categories, 1) = "|" Then $ToDo_List_categories = StringTrimLeft($ToDo_List_categories, 1)
	If StringRight($ToDo_List_categories, 1) = "|" Then $ToDo_List_categories = StringTrimRight($ToDo_List_categories, 1)
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", $ToDo_List_categories)
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", GUICtrlRead($neue_kategorie_ID_label) & "_text", GUICtrlRead($neue_kategorie_Text_input))
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", GUICtrlRead($neue_kategorie_ID_label) & "_color", GUICtrlRead($neue_kategorie_Farbe_input))

	;Kategorien neu einlesen
	_ToDo_Liste_Kategorien_verwalten_Liste_Laden()

	GUISetState(@SW_ENABLE, $ToDoList_Category_Manager)
	GUISetState(@SW_HIDE, $ToDoList_New_Category)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Neue_Kategorie_Erstellen

Func _ToDo_Liste_Kategorien_verwalten_Kategorie_Bearbeiten_OK()

	If GUICtrlRead($neue_kategorie_Text_input) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1228), 0, $ToDoList_New_Category)
		_Input_Error_FX($neue_kategorie_Text_input)
		Return
	EndIf

	;Neue Kategorie in INI_Speichern
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", GUICtrlRead($neue_kategorie_ID_label) & "_text", GUICtrlRead($neue_kategorie_Text_input))
	IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", GUICtrlRead($neue_kategorie_ID_label) & "_color", GUICtrlRead($neue_kategorie_Farbe_input))

	;Kategorien neu einlesen
	_ToDo_Liste_Kategorien_verwalten_Liste_Laden()

	GUISetState(@SW_ENABLE, $ToDoList_Category_Manager)
	GUISetState(@SW_HIDE, $ToDoList_New_Category)
EndFunc   ;==>_ToDo_Liste_Kategorien_verwalten_Kategorie_Bearbeiten_OK

Func _ToDo_Liste_erstelle_Standard_Kategorien()
	If $Templatemode = 1 Then Return ;In Vorlagen keine Standardkategorien erstellen (Die müssen schon selbst angelegt werden ^^)
	IniReadSection($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA")
	If @error Then

		;ToDo Bereich existiert in der project.isn noch nicht...default wird erstellt
		$Kategorie1_ID = "ct_2017030916439"
		$Kategorie2_ID = "ct_2017030916222"
		$Kategorie3_ID = "ct_201703091641"
		$Kategorie4_ID = "ct_2017030916312"
		$Kategorie_String = $Kategorie1_ID & "|" & $Kategorie2_ID & "|" & $Kategorie3_ID & "|" & $Kategorie4_ID

		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", $Kategorie_String)
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie1_ID & "_text", "%langstring(1280)%")
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie2_ID & "_text", "%langstring(1281)%")
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie3_ID & "_text", "%langstring(1282)%")
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie4_ID & "_text", "%langstring(1283)%")

		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie1_ID & "_color", "0xFF7A7A")
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie2_ID & "_color", "0xFFC56E")
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie3_ID & "_color", "0xF9FF5D")
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $Kategorie4_ID & "_color", "0xAAEE99")
	EndIf
EndFunc   ;==>_ToDo_Liste_erstelle_Standard_Kategorien

Func _QuickView_Aufgabe_loeschen()
	If Not _ist_windows_vista_oder_hoeher() Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1294), 0, $Studiofenster)
		Return
	EndIf
	If _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($quick_view_ToDoList_Listview) = 0 Then Return

	$i = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(1290), 0, $Studiofenster)
	If @error Then Return
	If $i <> 6 Then Return

	$zu_loeschendes_item = _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview), 0)
	$cat_des_items = _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview), 1)

	_ToDo_Liste_Aufgabe_Loeschen($zu_loeschendes_item, $cat_des_items)
EndFunc   ;==>_QuickView_Aufgabe_loeschen

Func _ToDo_Liste_Manager_Aufgabe_loeschen()
	If _GUICtrlListView_GetSelectionMark($ToDoList_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($ToDoList_Listview) = 0 Then Return

	$i = MsgBox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(1290), 0, $ToDoList_Manager)
	If @error Then Return
	If $i <> 6 Then Return

	$zu_loeschendes_item = _GUICtrlListView_GetItemText($ToDoList_Listview, _GUICtrlListView_GetSelectionMark($ToDoList_Listview), 0)
	$cat_des_items = _GUICtrlListView_GetItemText($ToDoList_Listview, _GUICtrlListView_GetSelectionMark($ToDoList_Listview), 1)

	_ToDo_Liste_Aufgabe_Loeschen($zu_loeschendes_item, $cat_des_items)
EndFunc   ;==>_ToDo_Liste_Manager_Aufgabe_loeschen

Func _ToDo_Liste_Aufgabe_Loeschen($item = "", $Cat = "")
	If $item = "" Then Return
	If $Cat = "" Then Return

	$zu_loeschendes_item = $item
	$cat_des_items = $Cat

	$ToDo_List_Items_String = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $cat_des_items & "_items", "")
	$ToDo_List_Items_split_Array = StringSplit($ToDo_List_Items_String, "|", 2)
	$Neuer_Item_string = ""
	If IsArray($ToDo_List_Items_split_Array) Then
		For $Count = 0 To UBound($ToDo_List_Items_split_Array) - 1
			If $ToDo_List_Items_split_Array[$Count] = "" Then ContinueLoop
			If $ToDo_List_Items_split_Array[$Count] = $zu_loeschendes_item Then ContinueLoop ;Zu löschendes Item überspringen
			$Neuer_Item_string = $Neuer_Item_string & $ToDo_List_Items_split_Array[$Count] & "|"
		Next
		If StringLeft($Neuer_Item_string, 1) = "|" Then $Neuer_Item_string = StringTrimLeft($Neuer_Item_string, 1)
		If StringRight($Neuer_Item_string, 1) = "|" Then $Neuer_Item_string = StringTrimRight($Neuer_Item_string, 1)
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $cat_des_items & "_items", $Neuer_Item_string) ;Neuen String abspeichern
	EndIf

	;Und Item selbst löschen
	IniDelete($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $zu_loeschendes_item)

	_QuickView_ToDo_Liste_neu_einlesen()
EndFunc   ;==>_ToDo_Liste_Aufgabe_Loeschen


Func _Datei_nach_UTF16_konvertieren($Datei = "", $Backup_erstellen = "true")
	;UTF16 Little Endian
	If $Datei = "" Then Return
	If Not FileExists($Datei) Then Return
	$Datei_Encoding = FileGetEncoding($Datei)
	If $Datei_Encoding = 32 Then Return ;Bereits richtiges Encoding

	Dim $szDrive, $szDir, $szFName, $szExt
	$Datei_Handle = FileOpen($Datei, $Datei_Encoding)
	If $Datei_Handle = -1 Then
		MsgBox(262144, "Error", "Error while reading file!" & @CRLF & $Datei)
		Return
	EndIf
	$Datei_Inhalt = FileRead($Datei_Handle)
	FileClose($Datei_Handle)

	$TestPath = _PathSplit($Datei, $szDrive, $szDir, $szFName, $szExt)

	If $Backup_erstellen = "true" Then
		FileMove($Datei, $szDrive & $szDir & $szFName & ".bak")
	Else
		FileRecycle($Datei) ;Alte Datei in den Papierkorb schmeißen
	EndIf

	Sleep(100)

	$Datei_Handle = FileOpen($Datei, 32 + 2)
	If $Datei_Handle = -1 Then
		MsgBox(262144, "Error", "Error while writing file!" & @CRLF & $Datei)
		Return
	EndIf
	FileWrite($Datei_Handle, $Datei_Inhalt)
	FileClose($Datei_Handle)

EndFunc   ;==>_Datei_nach_UTF16_konvertieren

Func _Leere_UTF16_Datei_erstellen($Datei = "")
	If $Datei = "" Then Return
	$Datei_Handle = FileOpen($Datei, 32 + 2)
	If $Datei_Handle = -1 Then
		MsgBox(262144, "Error", "Error while writing file!" & @CRLF & $Datei)
		Return
	EndIf
	FileWrite($Datei_Handle, "")
	FileClose($Datei_Handle)
EndFunc   ;==>_Leere_UTF16_Datei_erstellen



Func _QuickView_ToDo_Liste_Neue_Aufgabe()
	If Not _ist_windows_vista_oder_hoeher() Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1294), 0, $Studiofenster)
		Return
	EndIf

	GUICtrlSetData($todoliste_neuer_eintrag_titel_label, _Get_langstr(1265))
	WinSetTitle($ToDo_Liste_neuer_eintrag_GUI, "", _Get_langstr(1265))

	$neue_Aufgabe_ID = @YEAR & @MON & @MDAY & @SEC & Random(0, 500, 1)
	GUICtrlSetData($todoliste_neuer_eintrag_ID_label, $neue_Aufgabe_ID)

	GUICtrlSetData($todoliste_neuer_eintrag_betreff_input, "")
	GUICtrlSetData($todoliste_neuer_eintrag_text_edit, "")
	GUICtrlSetData($todoliste_neuer_eintrag_datum_input, @YEAR & "/" & @MON & "/" & @MDAY)

	GUISetOnEvent($GUI_EVENT_CLOSE, "_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_QuickView", $ToDo_Liste_neuer_eintrag_GUI)
	GUICtrlSetOnEvent($todoliste_neuer_eintrag_ok_Button, "_ToDo_Liste_Liste_Neue_Aufgabe_OK")
	GUICtrlSetOnEvent($todoliste_neuer_eintrag_abbrechen_Button, "_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_QuickView")

	GUICtrlSetState($todoliste_neuer_eintrag_betreff_input, $GUI_FOCUS)

	GUISetState(@SW_SHOW, $ToDo_Liste_neuer_eintrag_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
EndFunc   ;==>_QuickView_ToDo_Liste_Neue_Aufgabe

Func _ToDo_Liste_Liste_Neue_Aufgabe_schreiben()
	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1293), 0, $ToDo_Liste_neuer_eintrag_GUI)
		Return ;Wenn keine Kategorien, dann stopp
	EndIf

	$ToDo_List_categories_split = StringSplit($ToDo_List_categories, "|", 2)
	If Not IsArray($ToDo_List_categories_split) Then Return

	If UBound($ToDo_List_categories_split) > 0 Then
		$erste_kategorie = $ToDo_List_categories_split[0]
		$Erste_categorie_items = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $erste_kategorie & "_items", "")
		$Erste_categorie_items = $Erste_categorie_items & "|" & GUICtrlRead($todoliste_neuer_eintrag_ID_label)
		If StringLeft($Erste_categorie_items, 1) = "|" Then $Erste_categorie_items = StringTrimLeft($Erste_categorie_items, 1)
		If StringRight($Erste_categorie_items, 1) = "|" Then $Erste_categorie_items = StringTrimRight($Erste_categorie_items, 1)
		IniWrite($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", $erste_kategorie & "_items", $Erste_categorie_items)


		IniWrite($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & GUICtrlRead($todoliste_neuer_eintrag_ID_label), "subject", GUICtrlRead($todoliste_neuer_eintrag_betreff_input))
		IniWrite($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & GUICtrlRead($todoliste_neuer_eintrag_ID_label), "text", StringReplace(GUICtrlRead($todoliste_neuer_eintrag_text_edit), @CRLF, "[BREAK]"))
		$Datum_Array = _GUICtrlDTP_GetSystemTime(GUICtrlGetHandle($todoliste_neuer_eintrag_datum_input))
		If IsArray($Datum_Array) Then
			IniWrite($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & GUICtrlRead($todoliste_neuer_eintrag_ID_label), "date", StringFormat("%04d/%02d/%02d", $Datum_Array[0], $Datum_Array[1], $Datum_Array[2]))
		EndIf
		_QuickView_ToDo_Liste_neu_einlesen()
	EndIf
EndFunc   ;==>_ToDo_Liste_Liste_Neue_Aufgabe_schreiben

Func _ToDo_Liste_Liste_Neue_Aufgabe_OK()

	If GUICtrlRead($todoliste_neuer_eintrag_betreff_input) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1228), 0, $ToDo_Liste_neuer_eintrag_GUI)
		_Input_Error_FX($todoliste_neuer_eintrag_betreff_input)
		Return
	EndIf


	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1293), 0, $ToDo_Liste_neuer_eintrag_GUI)
		Return ;Wenn keine Kategorien, dann stopp
	EndIf

	_ToDo_Liste_Liste_Neue_Aufgabe_schreiben()

	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $ToDo_Liste_neuer_eintrag_GUI)

EndFunc   ;==>_ToDo_Liste_Liste_Neue_Aufgabe_OK

Func _ToDo_Liste_Liste_Neue_Aufgabe_OK_Manager()

	If GUICtrlRead($todoliste_neuer_eintrag_betreff_input) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1228), 0, $ToDo_Liste_neuer_eintrag_GUI)
		_Input_Error_FX($todoliste_neuer_eintrag_betreff_input)
		Return
	EndIf


	$ToDo_List_categories = IniRead($Pfad_zur_Project_ISN, "ISNPROJECT_TODOLISTDATA", "categories", "")
	If $ToDo_List_categories = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1293), 0, $ToDo_Liste_neuer_eintrag_GUI)
		Return ;Wenn keine Kategorien, dann stopp
	EndIf

	_ToDo_Liste_Liste_Neue_Aufgabe_schreiben()

	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $ToDo_Liste_neuer_eintrag_GUI)
	GUISetState(@SW_SHOW, $ToDoList_Manager)

EndFunc   ;==>_ToDo_Liste_Liste_Neue_Aufgabe_OK_Manager

Func _ToDo_Liste_Liste_Neue_Aufgabe_Manager()
	GUICtrlSetData($todoliste_neuer_eintrag_titel_label, _Get_langstr(1265))
	WinSetTitle($ToDo_Liste_neuer_eintrag_GUI, "", _Get_langstr(1265))

	$neue_Aufgabe_ID = @YEAR & @MON & @MDAY & @SEC & Random(0, 500, 1)
	GUICtrlSetData($todoliste_neuer_eintrag_ID_label, $neue_Aufgabe_ID)

	GUICtrlSetData($todoliste_neuer_eintrag_betreff_input, "")
	GUICtrlSetData($todoliste_neuer_eintrag_text_edit, "")
	GUICtrlSetData($todoliste_neuer_eintrag_datum_input, @YEAR & "/" & @MON & "/" & @MDAY)

	GUISetOnEvent($GUI_EVENT_CLOSE, "_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_Manager", $ToDo_Liste_neuer_eintrag_GUI)
	GUICtrlSetOnEvent($todoliste_neuer_eintrag_ok_Button, "_ToDo_Liste_Liste_Neue_Aufgabe_OK_Manager")
	GUICtrlSetOnEvent($todoliste_neuer_eintrag_abbrechen_Button, "_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_Manager")

	GUICtrlSetState($todoliste_neuer_eintrag_betreff_input, $GUI_FOCUS)

	GUISetState(@SW_HIDE, $ToDoList_Manager)
	GUISetState(@SW_SHOW, $ToDo_Liste_neuer_eintrag_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
EndFunc   ;==>_ToDo_Liste_Liste_Neue_Aufgabe_Manager

Func _ToDo_Liste_Aufgabe_Bearbeiten_Manager()
	If _GUICtrlListView_GetSelectionMark($ToDoList_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($ToDoList_Listview) = 0 Then Return

	GUICtrlSetData($todoliste_neuer_eintrag_titel_label, _Get_langstr(1272))
	WinSetTitle($ToDo_Liste_neuer_eintrag_GUI, "", _Get_langstr(1272))

	$Aufgabe_ID = _GUICtrlListView_GetItemText($ToDoList_Listview, _GUICtrlListView_GetSelectionMark($ToDoList_Listview), 0)
	GUICtrlSetData($todoliste_neuer_eintrag_ID_label, $Aufgabe_ID)

	GUICtrlSetData($todoliste_neuer_eintrag_betreff_input, IniRead($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Aufgabe_ID, "subject", ""))
	GUICtrlSetData($todoliste_neuer_eintrag_text_edit, StringReplace(IniRead($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Aufgabe_ID, "text", ""), "[BREAK]", @CRLF))
	GUICtrlSetData($todoliste_neuer_eintrag_datum_input, IniRead($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Aufgabe_ID, "date", @YEAR & " / " & @MON & " / " & @MDAY))

	GUISetOnEvent($GUI_EVENT_CLOSE, "_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_Manager", $ToDo_Liste_neuer_eintrag_GUI)
	GUICtrlSetOnEvent($todoliste_neuer_eintrag_ok_Button, "_ToDo_Liste_Aufgabe_Bearbeiten_OK_Manager")
	GUICtrlSetOnEvent($todoliste_neuer_eintrag_abbrechen_Button, "_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_Manager")

	GUICtrlSetState($todoliste_neuer_eintrag_betreff_input, $GUI_FOCUS)

	GUISetState(@SW_HIDE, $ToDoList_Manager)
	GUISetState(@SW_SHOW, $ToDo_Liste_neuer_eintrag_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
EndFunc   ;==>_ToDo_Liste_Aufgabe_Bearbeiten_Manager

Func _ToDo_Liste_Aufgabe_Bearbeiten_QuickView()
	If _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($quick_view_ToDoList_Listview) = 0 Then Return

	GUICtrlSetData($todoliste_neuer_eintrag_titel_label, _Get_langstr(1272))
	WinSetTitle($ToDo_Liste_neuer_eintrag_GUI, "", _Get_langstr(1272))

	$Aufgabe_ID = _GUICtrlListView_GetItemText($quick_view_ToDoList_Listview, _GUICtrlListView_GetSelectionMark($quick_view_ToDoList_Listview), 0)
	GUICtrlSetData($todoliste_neuer_eintrag_ID_label, $Aufgabe_ID)

	GUICtrlSetData($todoliste_neuer_eintrag_betreff_input, IniRead($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Aufgabe_ID, "subject", ""))
	GUICtrlSetData($todoliste_neuer_eintrag_text_edit, StringReplace(IniRead($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Aufgabe_ID, "text", ""), "[BREAK]", @CRLF))
	GUICtrlSetData($todoliste_neuer_eintrag_datum_input, IniRead($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & $Aufgabe_ID, "date", @YEAR & " / " & @MON & " / " & @MDAY))

	GUISetOnEvent($GUI_EVENT_CLOSE, "_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_QuickView", $ToDo_Liste_neuer_eintrag_GUI)
	GUICtrlSetOnEvent($todoliste_neuer_eintrag_ok_Button, "_ToDo_Liste_Aufgabe_Bearbeiten_OK_QuickView")
	GUICtrlSetOnEvent($todoliste_neuer_eintrag_abbrechen_Button, "_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_QuickView")

	GUICtrlSetState($todoliste_neuer_eintrag_betreff_input, $GUI_FOCUS)

	GUISetState(@SW_HIDE, $ToDoList_Manager)
	GUISetState(@SW_SHOW, $ToDo_Liste_neuer_eintrag_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)
EndFunc   ;==>_ToDo_Liste_Aufgabe_Bearbeiten_QuickView

Func _ToDo_Liste_Aufgabe_Bearbeiten_OK_Daten_Schreiben()
	IniWrite($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & GUICtrlRead($todoliste_neuer_eintrag_ID_label), "subject", GUICtrlRead($todoliste_neuer_eintrag_betreff_input))
	IniWrite($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & GUICtrlRead($todoliste_neuer_eintrag_ID_label), "text", StringReplace(GUICtrlRead($todoliste_neuer_eintrag_text_edit), @CRLF, "[BREAK]"))
	$Datum_Array = _GUICtrlDTP_GetSystemTime(GUICtrlGetHandle($todoliste_neuer_eintrag_datum_input))
	If IsArray($Datum_Array) Then
		IniWrite($Pfad_zur_Project_ISN, "TODOLIST_ITEM_" & GUICtrlRead($todoliste_neuer_eintrag_ID_label), "date", StringFormat("%04d/%02d/%02d", $Datum_Array[0], $Datum_Array[1], $Datum_Array[2]))
	EndIf
	_QuickView_ToDo_Liste_neu_einlesen()
EndFunc   ;==>_ToDo_Liste_Aufgabe_Bearbeiten_OK_Daten_Schreiben


Func _ToDo_Liste_Aufgabe_Bearbeiten_OK_QuickView()

	If GUICtrlRead($todoliste_neuer_eintrag_betreff_input) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1228), 0, $ToDo_Liste_neuer_eintrag_GUI)
		_Input_Error_FX($todoliste_neuer_eintrag_betreff_input)
		Return
	EndIf

	_ToDo_Liste_Aufgabe_Bearbeiten_OK_Daten_Schreiben()

	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $ToDo_Liste_neuer_eintrag_GUI)

EndFunc   ;==>_ToDo_Liste_Aufgabe_Bearbeiten_OK_QuickView

Func _ToDo_Liste_Aufgabe_Bearbeiten_OK_Manager()

	If GUICtrlRead($todoliste_neuer_eintrag_betreff_input) = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1228), 0, $ToDo_Liste_neuer_eintrag_GUI)
		_Input_Error_FX($todoliste_neuer_eintrag_betreff_input)
		Return
	EndIf

	_ToDo_Liste_Aufgabe_Bearbeiten_OK_Daten_Schreiben()

	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $ToDo_Liste_neuer_eintrag_GUI)
	GUISetState(@SW_SHOW, $ToDoList_Manager)

EndFunc   ;==>_ToDo_Liste_Aufgabe_Bearbeiten_OK_Manager

Func _ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_Manager()
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $ToDo_Liste_neuer_eintrag_GUI)
	GUISetState(@SW_SHOW, $ToDoList_Manager)
EndFunc   ;==>_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_Manager

Func _ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_QuickView()
	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $ToDo_Liste_neuer_eintrag_GUI)
EndFunc   ;==>_ToDo_Liste_Liste_Neue_Aufgabe_Abbrechen_QuickView


Func _ISNTooltip_with_Timer($text = "", $x = 0, $y = 0, $Title = "", $icon = 0, $options = "")
	ToolTip($text, $x, $y, $Title, $icon, $options)
	AdlibRegister("_ISNTooltip_Timer_Hide_Tooltips", 2000)
EndFunc   ;==>_ISNTooltip_with_Timer

Func _ISNTooltip_Timer_Hide_Tooltips()
	ToolTip("")
EndFunc   ;==>_ISNTooltip_Timer_Hide_Tooltips

Func _Handle_mit_Dollar_zurueckgeben($handle = "")
	If $handle = "" Then Return ""
	$handle = StringStripWS($handle, 3)
	$handle = StringReplace($handle, "$$", "")
	$handle = StringReplace($handle, "$$$", "")
	$handle = StringReplace($handle, "$$$$", "")
	If StringLeft($handle, 1) <> "$" Then
		Return "$" & $handle
	Else
		Return $handle
	EndIf
EndFunc   ;==>_Handle_mit_Dollar_zurueckgeben

; ==================================================================================================
; Func _WinAPI_ProcessGetFilename($vProcessID,$bFullPath=False)
;
; Function to get the process executable filename, or full path name, for Process
;       using DLL calls rather than WMI.
;
; $vProcessID = either a process name ("explorer.exe") or Process ID (2314)
; $bFullPath = If True, return the full path to the executable. If False, just return the process executable filename.
;
; Returns:
;   Success: String - either full path or just executable name, based on $bFullPath parameter
;   Failure: "" empty string, with @error set:
;       @error = 1 = invalid parameter or process name not found to 'exist'
;       @error = 2 = DLL call error, use _WinAPI_GetLastError()
;       @error = 3 = Couldn't obtain Process handle
;       @error = 4 = empty string returned from call (possible privilege issue)
;
; Author: Ascend4nt
; ==================================================================================================

Func _WinAPI_ProcessGetFilename($vProcessID, $bFullPath = False)
	; Not a Process ID? Must be a Process Name
	If Not IsNumber($vProcessID) Then
		$vProcessID = ProcessExists($vProcessID)
		; Process Name not found (or invalid parameter?)
		If Not $vProcessID Then Return SetError(1, 0, "")
	EndIf

	Local $sDLLFunctionName, $tErr

	; Since the parameters and returns are the same for both of these DLL calls, we can keep it all in one function
	If $bFullPath Then
		$sDLLFunctionName = "GetModuleFileNameExW"
	Else
		$sDLLFunctionName = "GetModuleBaseNameW"
	EndIf

	; Get process handle
	Local $hProcess = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', BitOR(0x400, 0x10), 'int', 0, 'int', $vProcessID)
	If @error Then Return SetError(2, 0, "")
	If Not $hProcess[0] Then Return SetError(3, 0, "")

	; Create 'receiving' string buffers and make the call
	; Path length size maximum in Unicode is 32767 (-1 for NULL)
	Local $stFilename = DllStructCreate("wchar[32767]")
	; Make the call (same parameters for both)
	Local $aRet = DllCall("Psapi.dll", "dword", $sDLLFunctionName, "ptr", $hProcess[0], "ptr", 0, "ptr", DllStructGetPtr($stFilename), "dword", 32767)

	If @error Then
		$tErr = 2
	ElseIf Not $aRet[0] Then
		$tErr = 4
	Else
		$tErr = 0
	EndIf
	; Close process handle
	DllCall('kernel32.dll', 'int', 'CloseHandle', 'ptr', $hProcess[0])
	; Error above?
	If $tErr Then Return SetError($tErr, 0, "")

	;$stFilename should now contain either the filename or full path string (based on $bFullPath)
	Local $sFilename = DllStructGetData($stFilename, 1)

	; DLLStructDelete()'s
	$stFilename = 0
	$hProcess = 0

	SetError(0)
	Return $sFilename
EndFunc   ;==>_WinAPI_ProcessGetFilename

Func _ISN_Update_pruefe_ob_installer_vorhanden_ist()
	If Not FileExists(@ScriptDir & "\update_installer.exe") Then
		;EXTRACT HERE THE MISSING UPDATER!!!
		If _ISN_Update_Installer_aus_Package_installieren() = 1 Then
			Return 1
		Else
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1332), 0)
			Return -1
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_ISN_Update_pruefe_ob_installer_vorhanden_ist


Func _ISN_AutoIt_Studio_nach_updates_Suchen()
	If _ISN_Update_pruefe_ob_installer_vorhanden_ist() <> 1 Then Return

	If ProcessExists($ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID]) Then
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(1325), 0)
		Return
	EndIf

	GUICtrlSetData($willkommen_update_suchen_button, _Get_langstr(337))
	GUICtrlSetState($willkommen_update_suchen_button, $GUI_DISABLE)

	$ISN_Scripttest_helper_Array = _Run_New_AutoIt_Studio_Helper_Instance('"/thread_task searchupdates" "/no_watch_guard"')
	If IsArray($ISN_Scripttest_helper_Array) Then
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_Handle] = $ISN_Scripttest_helper_Array[0] ;Handle
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID] = $ISN_Scripttest_helper_Array[1] ;PID
	Else
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_Handle] = ""
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID] = ""
		_Write_ISN_Debug_Console("Unable to start ISN updater thread!", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak)
		Return
	EndIf

EndFunc   ;==>_ISN_AutoIt_Studio_nach_updates_Suchen

Func _install_local_upgrade_file()
	If _ISN_Update_pruefe_ob_installer_vorhanden_ist() <> 1 Then Return
	If ProcessExists($ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID]) Then
		MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(1325), 0)
		Return
	EndIf

	$localupdatefile = FileOpenDialog("Choose file to install", "", "All (*.*)", 3, "")
	If @error Or $localupdatefile = "" Then Return

	GUICtrlSetData($willkommen_update_suchen_button, _Get_langstr(337))
	GUICtrlSetState($willkommen_update_suchen_button, $GUI_DISABLE)

	$ISN_Scripttest_helper_Array = _Run_New_AutoIt_Studio_Helper_Instance('"/thread_task searchupdates" "/no_watch_guard" "/updaterlocal_file ' & $localupdatefile & '"')
	If IsArray($ISN_Scripttest_helper_Array) Then
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_Handle] = $ISN_Scripttest_helper_Array[0] ;Handle
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID] = $ISN_Scripttest_helper_Array[1] ;PID
	Else
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_Handle] = ""
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID] = ""
		_Write_ISN_Debug_Console("Unable to start ISN updater thread!", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak)
		Return
	EndIf

EndFunc   ;==>_install_local_upgrade_file


Func _ISN_AutoIt_Studio_nach_updates_Suchen_Silent()
	If _ISN_Update_pruefe_ob_installer_vorhanden_ist() <> 1 Then Return
	If ProcessExists($ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID]) Then Return ;Läuft bereits

	GUICtrlSetData($willkommen_update_suchen_button, _Get_langstr(337))
	GUICtrlSetState($willkommen_update_suchen_button, $GUI_DISABLE)

	$ISN_Scripttest_helper_Array = _Run_New_AutoIt_Studio_Helper_Instance('"/thread_task searchupdates" "/no_watch_guard" "/updater_mode silent"')
	If IsArray($ISN_Scripttest_helper_Array) Then
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_Handle] = $ISN_Scripttest_helper_Array[0] ;Handle
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID] = $ISN_Scripttest_helper_Array[1] ;PID
	Else
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_Handle] = ""
		$ISN_Helper_Threads[$ISN_Helper_Updater][$ISN_Helper_PID] = ""
		_Write_ISN_Debug_Console("Unable to start ISN updater thread!", $ISN_Debug_Console_Errorlevel_Critical, $ISN_Debug_Console_Linebreak)
		Return
	EndIf

EndFunc   ;==>_ISN_AutoIt_Studio_nach_updates_Suchen_Silent


Func _ISN_AutoIt_Studio_activate_GUI_Messages()
GUIRegisterMsg($WM_COMMAND, "_InputCheck")
GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")
GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
GUIRegisterMsg($WM_NOTIFY, '_WM_NOTIFY')
GUIRegisterMsg($WM_WINDOWPOSCHANGING, "WM_WINDOWPOSCHANGING")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")
GUIRegisterMsg($WM_NCACTIVATE, "_WM_NCACTIVATE")
GUIRegisterMsg($WM_RDC, 'WM_RDC')
endfunc

Func _ISN_AutoIt_Studio_deactivate_GUI_Messages()
GUIRegisterMsg($WM_COMMAND, "")
GUIRegisterMsg($WM_DROPFILES, "")
GUIRegisterMsg($WM_GETMINMAXINFO, "")
GUIRegisterMsg($WM_NOTIFY, '')
GUIRegisterMsg($WM_WINDOWPOSCHANGING, "")
GUIRegisterMsg($WM_SIZE, "")
GUIRegisterMsg($WM_NCACTIVATE, "")
GUIRegisterMsg($WM_RDC, '')
endfunc

func _Hotkey_Scintilla_Paste_func()
   If $Offenes_Projekt = "" Then Return
   local $current_window = _WinAPI_GetFocus()
   if _WinAPI_GetClassName($current_window) <> "Scintilla" then return
   _ISN_AutoIt_Studio_deactivate_GUI_Messages()
   SendMessage($current_window, $SCI_PASTE, 0, 0)
   SendMessage($current_window, $SCI_COLOURISE, 0, -1) ;Redraw the lexer
   _ISN_AutoIt_Studio_activate_GUI_Messages()
EndFunc

 Func GUICheckBoxSetColor(ByRef $CtrlID,$iColor,$iBkColor="0xF1EDED")
    	$CtrlHWnd = $CtrlID
    	If Not IsHWnd($CtrlHWnd) Then $CtrlHWnd = GUICtrlGetHandle($CtrlID)
    	$aParent = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $CtrlHWnd)
    	$aCPos = ControlGetPos($aParent[0],"",$CtrlID)
    	$sOldT = GUICtrlRead($CtrlID,1)
    	GUICtrlDelete($CtrlID)
    	DllCall('uxtheme.dll', 'none', 'SetThemeAppProperties', 'int', 0)
    	$CtrlID = GUICtrlCreateCheckbox($sOldT,$aCPos[0],$aCPos[1],$aCPos[2],$aCPos[3])
		_Control_set_DPI_Scaling($CtrlID)
    	GUICtrlSetColor(-1,$iColor)
    	GUICtrlSetBkColor(-1,$iBkColor)
    	DllCall('uxtheme.dll', 'none', 'SetThemeAppProperties', 'int', 7)

EndFunc