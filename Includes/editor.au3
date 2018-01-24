
Func _Umlaute_Filtern($str = "")
	If $str = "" Then Return ""

	If StringInStr($str, "Ü", 1) Then $str = StringReplace($str, "Ü", "Ue", 0, 1)
	If StringInStr($str, "Ö", 1) Then $str = StringReplace($str, "Ö", "Oe", 0, 1)
	If StringInStr($str, "Ä", 1) Then $str = StringReplace($str, "Ä", "Ae", 0, 1)

	If StringInStr($str, "ü", 1) Then $str = StringReplace($str, "ü", "ue", 0, 1)
	If StringInStr($str, "ö", 1) Then $str = StringReplace($str, "ö", "oe", 0, 1)
	If StringInStr($str, "ä", 1) Then $str = StringReplace($str, "ä", "ae", 0, 1)

	;Verobtene Zeichen
	If StringInStr($str, "\") Then $str = StringReplace($str, "\", "")
	If StringInStr($str, "/") Then $str = StringReplace($str, "/", "")
	If StringInStr($str, "?") Then $str = StringReplace($str, "?", "")
	If StringInStr($str, ":") Then $str = StringReplace($str, ":", "")
	If StringInStr($str, "|") Then $str = StringReplace($str, "|", "")
	If StringInStr($str, "*") Then $str = StringReplace($str, "*", "")


	Return $str
EndFunc   ;==>_Umlaute_Filtern


Func _Skript_Editor_Pruefe_Dateityp($Dateityp = "")

	Local $Dateitypen = ""

	If $Skript_Editor_Automatische_Dateitypen = "true" Then
		;Dateitypen für Skript Editor werden automatisch verwaltet
		$Dateitypen = $Skript_Editor_Dateitypen_Standard
	Else
		;Dateitypen für Skript Editor werden manuell verwaltet
		$Dateitypen = $Skript_Editor_Dateitypen_Liste
	EndIf



	;Prüfen ob Dateityp mit Skript Editor geöffnet werden soll
	$Dateityp_Array = StringSplit($Dateitypen, "|", 2)
	If Not IsArray($Dateityp_Array) Then Return False

	For $x = 0 To UBound($Dateityp_Array) - 1
		If $Dateityp_Array[$x] = "" Then ContinueLoop
		If $Dateityp_Array[$x] = "|" Then ContinueLoop
		If $Dateityp = $Dateityp_Array[$x] Then Return True
	Next

	Return False
EndFunc   ;==>_Skript_Editor_Pruefe_Dateityp

Func _Mark_line($line, $colour)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	_Remove_Marks()
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERADD, $line, 2)
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERDEFINE, 2, $SC_MARK_SHORTARROW)
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERSETFORE, 2, 0x0000FF)
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERSETBACK, 2, 0x0000FF)
	;row colour
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERDEFINE, 3, $SC_MARK_Background)
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MarkerSetBack, 3, $colour)
	$marker_handle = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MarkerAdd, $line, 3)
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERSETALPHA, $line, 100)
EndFunc   ;==>_Mark_line

Func _Remove_Marks($sci = "")
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $sci = "" Then $sci = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_MarkerSetBack, 10, 0xFFFFFF)
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_MARKERSETALPHA, $marker_handle, 10)
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_MARKERDELETE, $marker_handle, 0)
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_MARKERDELETEHANDLE, $marker_handle, 0)
	SendMessage($sci, $SCI_MARKERDELETEALL, 2, 0) ;Lösche Marker die mit _Mark_line erstellt wurden (Marker ID 2)
	SendMessage($sci, $SCI_MARKERDELETEALL, 3, 0) ;Lösche Marker die mit _Mark_line erstellt wurden (Marker ID 3)
EndFunc   ;==>_Remove_Marks

Func _Show_Tab($nr = 0, $noresize_of_new_tab = 0)
	If _GUICtrlTab_GetItemCount($htab) < 1 Then Return
	If $nr > UBound($SCE_EDITOR) Then Return
	If $nr < 0 Then Return

	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	$plugsize = WinGetPos($SCE_EDITOR[$nr])

	If Not IsArray($plugsize) Then Return
	If Not IsArray($tabsize) Then Return
	$Aktuell_aktiver_Tab = _GUICtrlTab_GetCurFocus($htab)
	If $Aktuell_aktiver_Tab = -1 Then Return
	_GUICtrlStatusBar_SetText_ISN($Status_bar, "")
	_check_if_file_was_modified_external()
	If StringTrimLeft($Datei_pfad[$Aktuell_aktiver_Tab], StringInStr($Datei_pfad[$Aktuell_aktiver_Tab], ".", 0, -1)) = $Autoitextension Then
		_HIDE_FENSTER_RECHTS("false") ;show
		If $Fenster_unten_durch_toggle_versteckt = 0 Then _HIDE_FENSTER_UNTEN("false") ;show
	Else
		_HIDE_FENSTER_RECHTS("true") ;hide
		_HIDE_FENSTER_UNTEN("true") ;hide
	EndIf


	SendMessage($SCE_EDITOR[$Aktuell_aktiver_Tab], $SCI_INDICATORCLEARRANGE, 0, Sci_GetLenght($SCE_EDITOR[$Aktuell_aktiver_Tab]))
	$letztes_Suchwort = ""


	If $nr = -1 Then $nr = $Offene_tabs - 1




	;Verstecke alle Tabs
	For $i = $Offene_tabs To 1 Step -1
		If $nr = $i - 1 Then ContinueLoop
		WinMove($SCE_EDITOR[$i - 1], "", -9900, -9900, Default, Default)
;~ 		_WinAPI_SetWindowPos($SCE_EDITOR[$i - 1], $HWND_NOTOPMOST, -9900, -9900, 1, 1, $SWP_HIDEWINDOW+$SWP_NOZORDER+$SWP_NOOWNERZORDER)
;~ 		 _WinAPI_SetWindowPos($Plugin_Handle[$i - 1], $HWND_NOTOPMOST, -9900, -9900, 1, 1, $SWP_HIDEWINDOW+$SWP_NOZORDER+$SWP_NOOWNERZORDER)
		WinMove($Plugin_Handle[$i - 1], "", -9900, -9900, Default, Default)
	Next

	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	$htab_wingetpos_array = WinGetPos(GUICtrlGetHandle($htab))
	If Not IsArray($htab_wingetpos_array) Then Return

	If $noresize_of_new_tab <> 1 Then
		;Zeige gewünschten tab
		;Das Plugin bzw. den Skripteditor an die Fenstergröße anpassen
		If $Plugin_Handle[$nr] = -1 Then
			;Scintilla
			$y = $tabsize[1] + $Tabseite_hoehe
			$x = $tabsize[0] + 4
		Else
			;Plugin
			$y = $htab_wingetpos_array[1] + $Tabseite_hoehe
			$x = $htab_wingetpos_array[0] + 4
		EndIf


		If $Plugin_Handle[$nr] <> -1 Then
			_ISN_Send_Message_to_Plugin($Plugin_Handle[$nr], "resize") ;Resize an Plugin senden
		Else
			;Scintilla
			_WinAPI_SetWindowPos($SCE_EDITOR[$nr], $HWND_TOP, $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_SHOWWINDOW)
		EndIf

;~ 	_WinAPI_SetWindowPos($SCE_EDITOR[$nr],  _WinAPI_GetWindow(WinGetHandle($Studiofenster),$GW_HWNDNEXT)  , $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_SHOWWINDOW)
;~ 	$plugsize = WinGetPos($SCE_EDITOR[$nr])
;~    _WinAPI_SetWindowPos($Plugin_Handle[$nr], $HWND_TOPMOST  , 0, 0, $plugsize[2], $plugsize[3],   $SWP_SHOWWINDOW )


	EndIf
;~ 	sleep(50)
;~ 	WinMove($Plugin_Handle[$nr], "", 0, 0, $plugsize[2], $plugsize[3])

	If WinMove($Plugin_Handle[$nr], "", 0, 0) = 0 And $Plugin_Handle[$nr] <> -1 Then
		_Write_ISN_Debug_Console("Plugin with handle " & $Plugin_Handle[$nr] & " crashed!! Tab " & $nr + 1 & " will close now...", 3)
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(79), 0, $StudioFenster)
		try_to_Close_Tab($nr)
		_Write_ISN_Debug_Console("|--> Crashed tab closed!", 1)

		Return
	EndIf
	If $Plugin_Handle[$nr] = -1 Then _WinAPI_SetFocus($SCE_EDITOR[$nr])

EndFunc   ;==>_Show_Tab



Func _openscriptfile($file)
	GUISetCursor(1, 0, $studiofenster)
	If _GUICtrlTab_GetCurFocus($htab) <> $Tabswitch_last_Tab Then $Tabswitch_last_Tab = _GUICtrlTab_GetCurFocus($htab)
	_Write_log(_Get_langstr(36) & " " & StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	_GUICtrlTab_InsertItem($htab, $Offene_tabs, StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	$Tab_Rect = _GUICtrlTab_GetItemRect($htab, $Offene_tabs)
	If IsArray($Tab_Rect) Then $Tabseite_hoehe = $Tab_Rect[3] + (4 * $DPI)
	_GUICtrlTab_SetToolTips(-1, _Get_langstr(532))
	$Datei_pfad[$Offene_tabs] = $file
	$winsize = WinGetPos($StudioFenster)

	_GUICtrlTab_SetItemImage($htab, $Offene_tabs, _return_FileIcon(StringTrimLeft($file, StringInStr($file, ".", 1, -1))))
	_GUICtrlTab_ActivateTabX($htab, $Offene_tabs, 0)
	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	GUICtrlSetState($HD_Logo, $GUI_HIDE)


	;$SCE_EDITOR[$Offene_tabs] = Sci_CreateEditor($StudioFenster, $tabsize[0]+4, $tabsize[1]+24, $tabsize[2]-9,$tabsize[3]-24-4)
	$SCE_EDITOR[$Offene_tabs] = SCI_CreateEditorAu3($StudioFenster, $tabsize[0] + 4, $tabsize[1] + $Tabseite_hoehe, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4)
	$Last_Used_Scintilla_Control = $SCE_EDITOR[$Offene_tabs]
	_Write_ISN_Debug_Console("Open new script tab with handle " & $SCE_EDITOR[$Offene_tabs] & "...", 1)
	$ext = StringTrimLeft($Datei_pfad[$Offene_tabs], StringInStr($Datei_pfad[$Offene_tabs], ".", 1, -1))

	_Write_ISN_Debug_Console("|--> Setting lexer for " & $ext & "...", 1)
	Switch $ext

		Case "xml"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_XML, 0)

		Case "html"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_HTML, 0)

		Case "htm"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_HTML, 0)

		Case "txt"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_NULL, 0)

		Case "ini"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_PROPERTIES, 0)

		Case "isn"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_PROPERTIES, 0)

		Case "bat"
			SendMessage($SCE_EDITOR[$Offene_tabs], $SCI_SETLEXER, $SCLEX_BATCH, 0)



	EndSwitch

	LoadEditorFile($SCE_EDITOR[$Offene_tabs], FileGetShortName($file))



	$Plugin_Handle[$Offene_tabs] = -1

;~ 	GUISetState(@SW_LOCK,$StudioFenster)



	SendMessageString($SCE_EDITOR[$Offene_tabs], $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessageString($SCE_EDITOR[$Offene_tabs], $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessageString($SCE_EDITOR[$Offene_tabs], $SCI_SETSAVEPOINT, 0, 0)



	$FILE_CACHE[$Offene_tabs] = Sci_GetLines($SCE_EDITOR[$Offene_tabs])
	$Offene_tabs = $Offene_tabs + 1

	_Check_tabs_for_changes()

	_Show_Tab($Offene_tabs - 1)
	_Check_Buttons(0)
	;SendMessage($SCE_EDITOR[$Offene_tabs - 1], $SCI_DOCUMENTEND, 0, 0) ;Springe zum Dokumentende um die ganze Datei zu laden...
	_Editor_Restore_Fold()

;~ 	GUISetState(@SW_UNLOCK,$StudioFenster)
	;SendMessage($SCE_EDITOR[$Offene_tabs - 1], $SCI_DOCUMENTSTART, 0, 0) ;und wieder zurück :P
	If $hidefunctionstree = "false" Then _Build_Scripttree(StringTrimLeft($file, StringInStr($file, "\", 0, -1)), $Offene_tabs - 1)
	_Write_ISN_Debug_Console("|--> Tab successfully created!", 1)
	$Can_open_new_tab = 1
	_run_rule($Section_Trigger7)
	If Sci_GetLineCount($SCE_EDITOR[$Offene_tabs - 1]) > 4500 And $ext = $Autoitextension Then _Earn_trophy(14, 3)
	_Debug_log_check_redo_undo()
	GUISetCursor(2, 0, $StudioFenster)
EndFunc   ;==>_openscriptfile



Func _ArraySize($aArray)
	SetError(0)

	$index = 0

	Do
		$pop = _ArrayPop($aArray)
		$index = $index + 1
	Until @error = 1

	Return $index - 1
EndFunc   ;==>_ArraySize

Func gotomouspos()
	$p = MouseGetPos()
	$WP = WinGetPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) ;that is for difference of coordinates-Scintilla is in activX window($Sci)
	If @error Then Return
	If IsArray($WP) And IsArray($p) Then
		$p[0] -= $WP[0]
		$p[1] -= $WP[1]
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GOTOPOS, SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_POSITIONFROMPOINT, $p[0], $p[1]), 0)
		;SendMessage($Sci,$SCI_POSITIONFROMPOINT,x, y) - heare you get position from x,y
		;SendMessage($Sci,$SCI_GOTOPOS,$pos,0) - heare you go to specific position
		;if you go to an abstract position, use SendMessage($Sci,$SCI_POSITIONFROMPOINTCLOSE, x, y)
		;because it return -1 if no char close to position or the pos is outside window
	EndIf
EndFunc   ;==>gotomouspos

;Used to read a file,assign global data,and populate the Scintilla control

Func LoadEditorFile($editor, $sPath)
;~    msgbox(0,FileGetEncoding ($sPath),FileGetEncoding ($sPath))
	;  $filehandle = FileOpen ($sPath,FileGetEncoding ($sPath))
	Global $G_FileText = FileRead($sPath)

	If StringRight($G_FileText, 1) = Chr(0) Then $G_FileText = StringTrimRight($G_FileText, 1)

	If $autoit_editor_encoding = "2" Then
		If Not _System_benoetigt_double_byte_character_Support() Then
			$G_FileText = _UNICODE2ANSI($G_FileText)
		EndIf
	EndIf

	;Sci_DelLines($editor)


   _ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SCI_SetText($editor, $G_FileText)
	SendMessage($editor, $SCI_COLOURISE, 0, -1) ;Redraw the lexer
	_ISN_AutoIt_Studio_activate_GUI_Messages()

	;Sci_AddLines($editor, $G_FileText, 0)
;~  	FileClose($filehandle)
	Global $G_CurrentFile = $sPath
EndFunc   ;==>LoadEditorFile



Func _StringIsUTF8Format($sText)
	Local $iAsc, $iExt, $iLen = StringLen($sText)

	For $i = 1 To $iLen
		$iAsc = Asc(StringMid($sText, $i, 1))
		If Not BitAND($iAsc, 0x80) Then
			ContinueLoop
		ElseIf Not BitXOR(BitAND($iAsc, 0xE0), 0xC0) Then
			$iExt = 1
		ElseIf Not (BitXOR(BitAND($iAsc, 0xF0), 0xE0)) Then
			$iExt = 2
		ElseIf Not BitXOR(BitAND($iAsc, 0xF8), 0xF0) Then
			$iExt = 3
		Else
			Return False
		EndIf

		If $i + $iExt > $iLen Then Return False

		For $j = $i + 1 To $i + $iExt
			$iAsc = Asc(StringMid($sText, $j, 1))
			If BitXOR(BitAND($iAsc, 0xC0), 0x80) Then Return False
		Next

		$i += $iExt
	Next
	Return True
EndFunc   ;==>_StringIsUTF8Format


Func _UNICODE2ANSI($sString = "")
	If $autoit_editor_encoding <> "2" Then Return $sString
	If _System_benoetigt_double_byte_character_Support() Then Return $sString
	; Convert UTF8 to ANSI to insert into DB

	; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
	; ProgAndy
	; Make ANSI-string representation out of UTF-8

	Local Const $SF_ANSI = 1
	Local Const $SF_UTF8 = 4
	Return BinaryToString(StringToBinary($sString, $SF_UTF8), $SF_ANSI)
EndFunc   ;==>_UNICODE2ANSI

Func _ANSI2UNICODE($sString = "")
	If $autoit_editor_encoding <> "2" Then Return $sString
	If _System_benoetigt_double_byte_character_Support() Then Return $sString
	; Extract ANSI and convert to UTF8 to display

	; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
	; ProgAndy
	; convert ANSI-UTF8 representation to ANSI/Unicode

	Local Const $SF_ANSI = 1
	Local Const $SF_UTF8 = 4
	Return BinaryToString(StringToBinary($sString, $SF_ANSI), $SF_UTF8)
EndFunc   ;==>_ANSI2UNICODE

Func _WinGetByPID($iPID, $iArray = 0) ; 0 Will Return 1 Base Array & 1 Will Return The First Window.
	Local $aError[1] = [0], $aWinList, $sReturn
	If IsString($iPID) Then
		$iPID = ProcessExists($iPID)
	EndIf
	$aWinList = WinList()
	For $A = 1 To $aWinList[0][0]
		If WinGetProcess($aWinList[$A][1]) = $iPID And BitAND(WinGetState($aWinList[$A][1]), 2) Then
			If $iArray Then
				Return $aWinList[$A][1]
			EndIf
			$sReturn &= $aWinList[$A][1] & Chr(1)
		EndIf
	Next
	If $sReturn Then
		Return StringSplit(StringTrimRight($sReturn, 1), Chr(1))
	EndIf
	Return SetError(1, 0, $aError)
EndFunc   ;==>_WinGetByPID

Func _GetHwndFromPID($PID)
	$hWnd = 0
	$stPID = DllStructCreate("int")
	Do
		$winlist2 = WinList()
		For $i = 1 To $winlist2[0][0]
			If $winlist2[$i][0] <> "" Then
				DllCall("user32.dll", "int", "GetWindowThreadProcessId", "hwnd", $winlist2[$i][1], "ptr", DllStructGetPtr($stPID))
				If DllStructGetData($stPID, 1) = $PID Then
					$hWnd = $winlist2[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
		Sleep(100)
	Until $hWnd <> 0
	Return $hWnd
EndFunc   ;==>_GetHwndFromPID

Func _Try_to_open_file($file)
	Return Try_to_opten_file($file)
EndFunc   ;==>_Try_to_open_file

Func Try_to_opten_file($file)
	if $Offenes_Projekt = "" then return 0
	Dim $szDrive, $szDir, $szFName, $szExt
	If $Can_open_new_tab = 0 Then Return
	If $file = "#ERROR#" Then Return
	If $file = $Offenes_Projekt & "\#ERROR#" Then Return
	If Not FileExists($file) And $Studiomodus = 1 Then
		_Write_ISN_Debug_Console("Can not open file (" & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & ")!", 3)
		_Write_log(StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " " & _Get_langstr(332), "FF0000", "false")
		Return
	EndIf

	If $Offene_tabs > 19 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(123), 0, $StudioFenster)
		Return -1
	EndIf

	$res = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
	$szExt = StringTrimLeft($szExt, 1)

	If $szExt = "lnk" Then ;Verknüpfungen auflösen
		$Shortcut_array = FileGetShortcut($file)
		If IsArray($Shortcut_array) Then
			$file = $Shortcut_array[0]
			$res = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
			$szExt = StringTrimLeft($szExt, 1)
		EndIf
	EndIf

	$attrib = FileGetAttrib(FileGetShortName($file))
	If StringInStr($attrib, "R") Then _Show_Warning("warnreadonly", 513, _Get_langstr(394), _Get_langstr(458), "OK")
	If StringInStr($attrib, "D") Then Return
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
		$Can_open_new_tab = 0

		;try external plugin
		If Not _IniVirtual_Read($Plugins_Cachefile_Virtual_INI, $szExt, "program", "") = "" Then
			_open_plugintab(_IniVirtual_Read($Plugins_Cachefile_Virtual_INI, $szExt, "program", ""), $file)

			_Add_File_to_Backuplist($file)
			If $szExt = "isf" Then _Earn_trophy(2, 1)
			If $Offene_tabs > 14 Then _Earn_trophy(9, 2)
			_Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($file)
			Return 1
		EndIf

		;Included plugins
		If _Skript_Editor_Pruefe_Dateityp($szExt) Then
			If $szExt = "isn" And $Studiomodus = 2 Then
				;Öffne isn Datein im Editormodus als Projekt
				ShellExecute(@ScriptDir & "\AutoIt_Studio.exe", '"' & $file & '"', @ScriptDir)
				$Can_open_new_tab = 1
				Return 1
			Else
				_openscriptfile($file)
			EndIf
			_Add_File_to_Backuplist($file)
			If $Offene_tabs > 14 Then _Earn_trophy(9, 2)
			$Zuletzt_Verwendete_Dateien_Temp_Array = _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($file)
			Return 1
		EndIf

		If $szExt = "exe" Then
			$i = _Show_Warning("confirmexe", 513, _Get_langstr(394), _Get_langstr(417) & " (" & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & ")", _Get_langstr(429), _Get_langstr(430))
			If $i = 1 Then ShellExecute($file)
			$Can_open_new_tab = 1
			If $Offene_tabs > 14 Then _Earn_trophy(9, 2)
			$Zuletzt_Verwendete_Dateien_Temp_Array = _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($file)
			Return 1
		EndIf

		;or crash with "cannot open file"
		_Write_ISN_Debug_Console("Can not open file (" & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & ")!", 3)
		_Write_log(StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " " & _Get_langstr(673), "000000", "false")
		$Zuletzt_Verwendete_Dateien_Temp_Array = _Fuege_Datei_zu_Zuletzt_Verwendete_Dateien($file)
		ShellExecute($file)
		$Can_open_new_tab = 1
		Return -1
	Else
		_GUICtrlTab_ActivateTabX($htab, $alreadyopen)
		_Show_Tab($alreadyopen)
	EndIf

EndFunc   ;==>Try_to_opten_file

Func _Editor_Switch_Tab()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Aktuell_aktiver_Tab <> $Tabswitch_last_Tab Then $Tabswitch_last_Tab = $Aktuell_aktiver_Tab
	_Show_Tab(GUICtrlRead($htab))
	_Check_Buttons()
	_ISN_Send_Message_to_all_Plugins("switchtab")
;~ 	_Redraw_Window($SCE_EDITOR[$Offene_tabs])
EndFunc   ;==>_Editor_Switch_Tab

Func _Close_Tab_Script($nr, $refresh = 1)
	;if $nr = 0 then return
	;check for changes
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	GUISetCursor(1, 0, $studiofenster)
	_Write_ISN_Debug_Console("Closing script tab " & $nr & " (Handle " & $SCE_EDITOR[$nr] & ")...", 2)
	$Dateipfad = $Datei_pfad[$nr]
	$Can_open_new_tab = 0
	$Data = Sci_GetLines($SCE_EDITOR[$nr])
	While $Data <> $FILE_CACHE[$nr]
		_GUICtrlTab_ActivateTabX($htab, $nr, 0)
		_Show_Tab($nr)
		$answ = MsgBox(262144 + 3 + 32, _Get_langstr(48), _GUICtrlTab_GetItemText($htab, $nr) & " " & _Get_langstr(47), 0, $StudioFenster)
		If $answ = 2 Then
			$Can_open_new_tab = 1
			GUISetCursor(2, 0, $studiofenster)
			Return
		EndIf
		If $answ = 7 Then ExitLoop
		If $answ = 6 Then
			Save_File($nr)
			ExitLoop
		EndIf
	WEnd
	;EndFunc
	_Write_log(_Get_langstr(38) & " (" & _GUICtrlTab_GetItemText($htab, $nr) & ")")

	_WinAPI_DestroyWindow($SCE_EDITOR[$nr]) ;Zerstöre Scintilla Control
	_GUICtrlTab_DeleteItem($htab, $nr)

	For $i = $nr To $Offene_tabs Step +1
;~ 		ConsoleWrite("Rebuild"&random(0,222)&@crlf)
		$SCE_EDITOR[$i] = $SCE_EDITOR[$i + 1]
		$Plugin_Handle[$i] = $Plugin_Handle[$i + 1]
		$Datei_pfad[$i] = $Datei_pfad[$i + 1]
		$FILE_CACHE[$i] = $FILE_CACHE[$i + 1]
	Next

	$Offene_tabs = $Offene_tabs - 1

	_GUICtrlTab_ActivateTabX($htab, $Offene_tabs - 1, 0)
	_Show_Tab(_GUICtrlTab_GetCurFocus($htab))
	If $refresh = 1 Then _Check_Buttons(1)
	If _GUICtrlTab_GetItemCount($htab) > 0 And $refresh = 1 And _GUICtrlTab_GetCurFocus($htab) <> -1 Then _Redraw_Window($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Can_open_new_tab = 1
	GUISetCursor(2, 0, $studiofenster)
	_Pruefe_ob_sich_Datei_im_Temp_Ordner_befindet($Dateipfad)
	_Write_ISN_Debug_Console("|--> Script tab successfully closed!", 1)
EndFunc   ;==>_Close_Tab_Script


Func try_to_Close_Tab($nr, $refresh = 1)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Can_open_new_tab = 0 Then Return

	If $Plugin_Handle[$nr] = -1 Then
		If _SCE_EDITOR_is_Read_only($SCE_EDITOR[$nr]) Then Return
	EndIf


	_GUICtrlStatusBar_SetText_ISN($Status_bar, "")
	_Detailinfos_ausblenden()
	$nr = Int($nr)
	If $Plugin_Handle[$nr] = -1 Then
		_Close_Tab_Script($nr, $refresh)
	Else
		_Close_Tab_plugin($nr)
	EndIf
	_run_rule($Section_Trigger8)

EndFunc   ;==>try_to_Close_Tab

Func _Check_tabs_for_changes()
   AdlibUnRegister("_Check_tabs_for_changes")
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return

	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANUNDO, 0, 0) = 1 Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id11), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id11, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($EditMenu_item1), $GUI_ENABLE) Then GUICtrlSetState($EditMenu_item1, $GUI_ENABLE)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id11), $TBSTATE_INDETERMINATE) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id11, $TBSTATE_INDETERMINATE)
		If Not BitAND(GUICtrlGetState($EditMenu_item1), $GUI_DISABLE) Then GUICtrlSetState($EditMenu_item1, $GUI_DISABLE)
	EndIf

	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANREDO, 0, 0) = 1 Then
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id12), $TBSTATE_ENABLED) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id12, $TBSTATE_ENABLED)
		If Not BitAND(GUICtrlGetState($EditMenu_item2), $GUI_ENABLE) Then GUICtrlSetState($EditMenu_item2, $GUI_ENABLE)
	Else
		If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id12), $TBSTATE_INDETERMINATE) Then _GUICtrlToolbar_SetButtonState($hToolbar, $id12, $TBSTATE_INDETERMINATE)
		If Not BitAND(GUICtrlGetState($EditMenu_item2), $GUI_DISABLE) Then GUICtrlSetState($EditMenu_item2, $GUI_DISABLE)
	EndIf

	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 AND Not BitAND(_GUICtrlTab_GetItemState($htab, _GUICtrlTab_GetCurFocus($htab)), $TCIS_HIGHLIGHTED) Then
		$Data = Sci_GetLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		If $Data == $FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] Then
			_GUICtrlTab_HighlightItem($htab, _GUICtrlTab_GetCurFocus($htab), False)
		Else
			_GUICtrlTab_HighlightItem($htab, _GUICtrlTab_GetCurFocus($htab), True)
		EndIf
	EndIf

EndFunc   ;==>_Check_tabs_for_changes


;Saves specified data to the current opened file

Func Save_File($nr, $rebuildtree = 1)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	_Write_ISN_Debug_Console("Saving file (" & $Datei_pfad[$nr] & ") ", 1, 0)
	Local $Handle = ""
	If FileGetEncoding($Datei_pfad[$nr]) = $FO_ANSI Then
		$Handle = FileOpen($Datei_pfad[$nr], 2 + $FO_ANSI)
		_Write_ISN_Debug_Console("[SAVE AS ANSI]...", 0, 0, 1, 1)
	Else
		_Write_ISN_Debug_Console("[SAVE WITH ENCODING VALUE " & FileGetEncoding($Datei_pfad[$nr]) & "]...", 0, 0, 1, 1)
		$Handle = FileOpen($Datei_pfad[$nr], 2 + FileGetEncoding($Datei_pfad[$nr]))
	EndIf
	;_Write_log(_Get_langstr(86)&" "&stringtrimleft($Datei_pfad[$nr],stringinstr($Datei_pfad[$nr],"\",0,-1)))
	$Data = Sci_GetLines($SCE_EDITOR[$nr])
	If Not FileWrite($Handle, _ANSI2UNICODE($Data)) Then
		FileClose($Handle)
		_Write_ISN_Debug_Console("ERROR", 3, 1, 1, 1)
		_Write_log(StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], "\", 0, -1)) & " " & _Get_langstr(692), "FF0000")
;~ 		MsgBox(16, _Get_langstr(25), _Get_langstr(151), Default, $StudioFenster)
		Return 0
	EndIf
	FileClose($Handle)
	$FILE_CACHE[$nr] = $Data
	_GUICtrlTab_HighlightItem($htab, $nr, False)

	SendMessageString($SCE_EDITOR[$nr], $SCI_SETSAVEPOINT, 0, 0)
	If $rebuildtree = 1 Then _Build_Scripttree(StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], "\", 0, -1)), $nr)
	If Sci_GetLineCount($SCE_EDITOR[$nr]) > 4500 Then _Earn_trophy(14, 3)
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
	_Write_log(StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], "\", 0, -1)) & " " & _Get_langstr(691), "209B25")
	Return 1

EndFunc   ;==>Save_File

Func _try_to_save_file($nr, $rebuildtree = 1, $Nur_Skript_Tabs_Speichern = 0)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Can_open_new_tab = 0 Then Return
	$Automatische_Speicherung_eingabecounter = 0 ;Eingabecounter resetten
	$Can_open_new_tab = 0
	$ext = StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], ".", 1, -1))
	If $ext = $Autoitextension Then
		GUISetCursor(1, 0, $Studiofenster)
		_GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_INDETERMINATE)
		_GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_INDETERMINATE)
		GUICtrlSetState($FileMenu_item1, $GUI_DISABLE)
		GUICtrlSetState($FileMenu_item1b, $GUI_DISABLE)
		_Editor_Save_Fold()
		_Remove_Marks()
		Save_File($nr, $rebuildtree)
		_run_rule($Section_Trigger3)
		$Can_open_new_tab = 1
		GUISetCursor(2, 0, $Studiofenster)
		_GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_ENABLED)
		_GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_ENABLED)
		GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)
		GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
		Return
	Else
		If $Plugin_Handle[$nr] = -1 Then
			GUISetCursor(1, 0, $Studiofenster)
			_GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_INDETERMINATE)
			_GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_INDETERMINATE)
			GUICtrlSetState($FileMenu_item1, $GUI_DISABLE)
			GUICtrlSetState($FileMenu_item1b, $GUI_DISABLE)
			Save_File($nr, 0)
			_run_rule($Section_Trigger3)
			$Can_open_new_tab = 1
			GUISetCursor(2, 0, $Studiofenster)
			_GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_ENABLED)
			_GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_ENABLED)
			GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)
			GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
			Return
		EndIf
	EndIf
	If $Nur_Skript_Tabs_Speichern = 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[$nr], "save")
	_Write_log(StringTrimLeft($Datei_pfad[$nr], StringInStr($Datei_pfad[$nr], "\", 0, -1)) & " " & _Get_langstr(691), "209B25")
	_run_rule($Section_Trigger3)
	$Can_open_new_tab = 1
EndFunc   ;==>_try_to_save_file


Func _Debug_log_try_undo()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	SendMessage($Debug_log, $SCI_UNDO, 0, 0)

	_Debug_log_check_redo_undo()

EndFunc   ;==>_Debug_log_try_undo

Func _Debug_log_try_redo()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	SendMessage($Debug_log, $SCI_REDO, 0, 0)

	_Debug_log_check_redo_undo()

EndFunc   ;==>_Debug_log_try_redo

Func _Debug_clear_redo()
	SendMessage($Debug_log, $SCI_EMPTYUNDOBUFFER, 0, 0)
	_Debug_log_check_redo_undo()
EndFunc   ;==>_Debug_clear_redo

Func _Debug_Inahlt_in_Zwischenablage()
	ClipPut(Sci_GetText($Debug_log))
EndFunc   ;==>_Debug_Inahlt_in_Zwischenablage

Func _Debug_log_check_redo_undo()
	If SendMessage($Debug_log, $SCI_CANUNDO, 0, 0) = 1 Then
		GUICtrlSetState($Debug_Log_Undo_Button, $GUI_ENABLE)
	Else
		GUICtrlSetState($Debug_Log_Undo_Button, $GUI_DISABLE)
	EndIf

	If SendMessage($Debug_log, $SCI_CANREDO, 0, 0) = 1 Then
		GUICtrlSetState($Debug_Log_Redo_Button, $GUI_ENABLE)
	Else
		GUICtrlSetState($Debug_Log_Redo_Button, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_Debug_log_check_redo_undo

Func _try_undo()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_UNDO, 0, 0)

	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANUNDO, 0, 0) = 1 Then
		_GUICtrlToolbar_SetButtonState($hToolbar, $id11, $TBSTATE_ENABLED)
		GUICtrlSetState($EditMenu_item1, $GUI_ENABLE)
	Else
		_GUICtrlToolbar_SetButtonState($hToolbar, $id11, $TBSTATE_INDETERMINATE)
		GUICtrlSetState($EditMenu_item1, $GUI_DISABLE)
	EndIf

	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANREDO, 0, 0) = 1 Then
		_GUICtrlToolbar_SetButtonState($hToolbar, $id12, $TBSTATE_ENABLED)
		GUICtrlSetState($EditMenu_item2, $GUI_ENABLE)
	Else
		_GUICtrlToolbar_SetButtonState($hToolbar, $id12, $TBSTATE_INDETERMINATE)
		GUICtrlSetState($EditMenu_item2, $GUI_DISABLE)
	EndIf
	_Check_tabs_for_changes()
EndFunc   ;==>_try_undo

Func _try_redo()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_REDO, 0, 0)

	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANUNDO, 0, 0) = 1 Then
		_GUICtrlToolbar_SetButtonState($hToolbar, $id11, $TBSTATE_ENABLED)
		GUICtrlSetState($EditMenu_item1, $GUI_ENABLE)
	Else
		_GUICtrlToolbar_SetButtonState($hToolbar, $id11, $TBSTATE_INDETERMINATE)
		GUICtrlSetState($EditMenu_item1, $GUI_DISABLE)
	EndIf

	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CANREDO, 0, 0) = 1 Then
		_GUICtrlToolbar_SetButtonState($hToolbar, $id12, $TBSTATE_ENABLED)
		GUICtrlSetState($EditMenu_item2, $GUI_ENABLE)
	Else
		_GUICtrlToolbar_SetButtonState($hToolbar, $id12, $TBSTATE_INDETERMINATE)
		GUICtrlSetState($EditMenu_item2, $GUI_DISABLE)
	EndIf
	_Check_tabs_for_changes()
EndFunc   ;==>_try_redo

Func _Close_All_Tabs()
	If $Offenes_Projekt = "" Then Return
	If $Tabs_closing = 1 Then Return
	$Tabs_closing = 1
	_Write_log(_Get_langstr(81))
	GUISetCursor(1, 0, $studiofenster)
	While $Offene_tabs > 0
		try_to_Close_Tab($Offene_tabs - 1, 0)
;~ 		sleep(10)
	WEnd
	_Check_Buttons(0)
	$Tabs_closing = 0
	GUISetCursor(2, 0, $studiofenster)
EndFunc   ;==>_Close_All_Tabs

Func _Toggle_Search()
	If $Offenes_Projekt = "" Then Return
	$state = WinGetState($fFind1, "")
	If BitAND($state, 2) Then
		GUISetState(@SW_HIDE, $fFind1)
	Else
		GUISetState(@SW_SHOW, $fFind1)
		_WinAPI_SetFocus(ControlGetHandle($fFind1, "", $Search_Combo1))
	EndIf
EndFunc   ;==>_Toggle_Search

Func _Show_Search()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$len = GetSelLength($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	If $len > 0 Then
		$Text = DllStructCreate("char[" & $len + 1 & "]")
		DllCall($user32, "int", "SendMessageA", "hwnd", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "int", $SCI_GETSELTEXT, "int", 0, "ptr", DllStructGetPtr($Text))
		$findWhat = DllStructGetData($Text, 1)
		$Text = 0
	EndIf
	GUICtrlSetData($Search_Combo1, _ANSI2UNICODE($findWhat), _ANSI2UNICODE($findWhat))
	FindNext($findWhat, False, $showWarnings, $flags, True)

	GUISetState(@SW_SHOW, $fFind1)
	_WinAPI_SetFocus(ControlGetHandle($fFind1, "", $Search_Combo1))
EndFunc   ;==>_Show_Search


Func btnFindNextClick()
	If GUICtrlRead($Search_Combo1) = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Global $sci, $flags, $findWhat, $findTarget, $wrapFind, $reverseDirection
	$flags = 0

	If GUICtrlRead($cbFindMatchCase) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_MATCHCASE)
	EndIf

	If GUICtrlRead($cbFindWholeWords) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_WHOLEWORD)
	EndIf

	If GUICtrlRead($cbFindRe) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_REGEXP, $SCFIND_POSIX)
	EndIf

	If GUICtrlRead($cbFindWrapAround) == $GUI_CHECKED Then
		$wrapFind = True
	Else
		$wrapFind = False
	EndIf

	If GUICtrlRead($rFindDirectionUp) == $GUI_CHECKED Then
		$reverseDirection = True
	Else
		$reverseDirection = False
	EndIf

	If GUICtrlRead($cbFindShowWarnings) == $GUI_CHECKED Then
		$showWarnings = True
	Else
		$showWarnings = False
	EndIf

	$findWhat = GUICtrlRead($Search_Combo1)
	GUICtrlSetData($Search_Combo1, $findWhat, $findWhat)
	If $autoit_editor_encoding = "2" Then $findWhat = _UNICODE2ANSI($findWhat)
	FindNext($findWhat, $reverseDirection, $showWarnings, $flags)
	_Check_tabs_for_changes()
EndFunc   ;==>btnFindNextClick

Func btnFindReplaceAllClick()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Global $sci, $flags, $findWhat, $findTarget, $wrapFind, $reverseDirection
	$flags = 0

	If GUICtrlRead($cbFindMatchCase) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_MATCHCASE)
	EndIf

	If GUICtrlRead($cbFindWholeWords) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_WHOLEWORD)
	EndIf

	If GUICtrlRead($cbFindRe) == $GUI_CHECKED Then
		$flags = BitOR($flags, $SCFIND_REGEXP, $SCFIND_POSIX)
	EndIf

	If GUICtrlRead($cbFindWrapAround) == $GUI_CHECKED Then
		$wrapFind = False
	Else
		$wrapFind = False
	EndIf

	If GUICtrlRead($rFindDirectionUp) == $GUI_CHECKED Then
		$reverseDirection = True
	Else
		$reverseDirection = False
	EndIf

	If GUICtrlRead($cbFindShowWarnings) == $GUI_CHECKED Then
		$showWarnings = True
	Else
		$showWarnings = False
	EndIf

	$findWhat = GUICtrlRead($Search_Combo1)
	If $autoit_editor_encoding = "2" Then $findWhat = _UNICODE2ANSI($findWhat)
	Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], 0)
	While FindNext($findWhat, $reverseDirection, $showWarnings, $flags) > -1
		SendMessageString($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_REPLACESEL, 0, GUICtrlRead($Search_Combo2))
	WEnd
	_Check_tabs_for_changes()
EndFunc   ;==>btnFindReplaceAllClick

Func CloseFind()
	GUISetState(@SW_HIDE, $fFind1)
EndFunc   ;==>CloseFind

Func btnFindReplaceClick()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If GetSelLength($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) > 0 Then
		SendMessageString($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_REPLACESEL, 0, GUICtrlRead($Search_Combo2))
		btnFindNextClick()
	EndIf
	_Check_tabs_for_changes()
EndFunc   ;==>btnFindReplaceClick

Func SetSelection($anchor, $currentPos)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEL, $anchor, $currentPos)
EndFunc   ;==>SetSelection

Func FindNext($findWhat, $reverseDirection = False, $showWarnings = True, $flags = 0, $showgui = False, $reset = 0)

	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Global $findTarget, $wrapFind, $replacing
	If ($findWhat == "") Or ($showgui) Then
		If $reverseDirection Then
			GUICtrlSetState($rFindDirectionUp, $GUI_CHECKED)
			GUICtrlSetState($rFindDirectionDown, $GUI_UNCHECKED)
		Else
			GUICtrlSetState($rFindDirectionUp, $GUI_UNCHECKED)
			GUICtrlSetState($rFindDirectionDown, $GUI_CHECKED)

		EndIf
		GUISetState(@SW_SHOW, $fFind1)
		_WinAPI_SetFocus(ControlGetHandle($fFind1, "", $Search_Combo1))
		Return -1
	EndIf

	$findTarget = $findWhat
	$lenFind = StringLen($findTarget)
	If ($lenFind == 0) Then
		Return -1
	EndIf

	$startPosition = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
;~ 	$startPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_GETTARGETEND, 0, 0)

;~
	$endPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETLENGTH, 0, 0)
	If ($reverseDirection) Then
		$startPosition = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		$endPosition = 0
	EndIf

	;$flags = ($wholeWord ? SCFIND_WHOLEWORD : 0) |
	;            (matchCase ? SCFIND_MATCHCASE : 0) |
	;            (regExp ? SCFIND_REGEXP : 0) |
	;            (props.GetInt("find.replace.regexp.posix") ? SCFIND_POSIX : 0);

	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEARCHFLAGS, $flags, 0) ;
	$posFind = FindInTarget($findTarget, $lenFind, $startPosition, $endPosition)

	If ($posFind == -1) And ($wrapFind) Then
		If ($reverseDirection) Then
			$startPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETLENGTH, 0, 0)
			$endPosition = 0 ;
		Else
			$startPosition = 0 ;
			$endPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETLENGTH, 0, 0)
		EndIf
		$posFind = FindInTarget($findTarget, $lenFind, $startPosition, $endPosition) ;
		If ($showWarnings) Then
			WarnUser(_Get_langstr(102)) ;
		EndIf
	EndIf
	If ($posFind == -1) Then
		$havefound = False ;
		If ($showWarnings) Then
			WarnUser(_Get_langstr(103) & " '" & $findWhat & "'!") ;
		EndIf
	Else
		$havefound = True ;
		$start = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETTARGETSTART, 0, 0) ;
		$end = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETTARGETEND, 0, 0) ;
		$line = Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $start)
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_ENSUREVISIBLEENFORCEPOLICY, $line, 0) ;
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GOTOLINE, $line, 0)

		If ($reverseDirection) Then
			Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $start)
			SetSelection($end, $start) ;
		Else
			Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $end)
			SetSelection($start, $end) ;
		EndIf
		EnsureRangeVisible($start, $end) ;

	EndIf
	Return $posFind ;
EndFunc   ;==>FindNext

Func WarnUser($txt)
	Return MsgBox(262144 + 8192, _Get_langstr(61), $txt)
EndFunc   ;==>WarnUser

Func FindInTarget($findWhat, $lenFind, $startPosition, $endPosition)
	Global $findTarget ;

	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETTARGETSTART, $startPosition, 0)
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETTARGETEND, $endPosition, 0)

	$findWhatPtr = DllStructCreate("char[" & StringLen($findWhat) + 1 & "]")
	DllStructSetData($findWhatPtr, 1, $findWhat)
	$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "int", $SCI_SEARCHINTARGET, "int", StringLen($findWhat), "ptr", DllStructGetPtr($findWhatPtr))
	$posFind = $ret[0]

	$findWhatPtr = 0
	Return $posFind ;
EndFunc   ;==>FindInTarget

Func EnsureRangeVisible($posStart, $posEnd, $enforcePolicy = False)
	$lineStart = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, _Min($posStart, $posEnd), 0) ;
	$lineEnd = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, _Max($posStart, $posEnd), 0) ;
	For $line = $lineStart To $lineEnd
		If ($enforcePolicy) Then
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_ENSUREVISIBLEENFORCEPOLICY, $line, 0)
		Else
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_ENSUREVISIBLE, $line, 0)

		EndIf
	Next
EndFunc   ;==>EnsureRangeVisible

Func GetSelLength($sci)
	$startPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSELECTIONSTART, 0, 0)
	$endPosition = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSELECTIONEND, 0, 0)
	$len = $endPosition - $startPosition
	Return $len
EndFunc   ;==>GetSelLength

Func _Is_Comment()
	;prüft ob aktuelle Position ein Kommentar ist oder nicht
	$res = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSTYLEAT, Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), 0)
	If $res = $SCE_AU3_COMMENT Or $res = $SCE_AU3_COMMENTBLOCK Then
;~ ConsoleWrite("COMMENT!"&@crlf)
		Return True
	EndIf
;~ ConsoleWrite("NO COMMENT!"&@crlf)
	Return False
EndFunc   ;==>_Is_Comment

Func _Try_Jump_To_Line($string, $startpos = 0)
	$wrapFind = True
	If $startpos = 0 Then FindNext($string & Random(23043), False, False, $SCFIND_WHOLEWORD, False) ;mache zufallssuche um wieder von oben zu beginnen ^^
	$found = FindNext($string, False, False, $SCFIND_WHOLEWORD, False)
	While 1
		;suche solange bis wieder das element ohne kommentar gefunden wurde...
		If _Is_Comment() = True Then $found = FindNext($string, False, False, $SCFIND_WHOLEWORD, False)
		If _Is_Comment() = False Then ExitLoop
		If $found = -1 Then ExitLoop
	WEnd
	Return $found
EndFunc   ;==>_Try_Jump_To_Line

;~ ConsoleWrite("> " & @ScriptLineNumber & " makes color BLUE" & @CRLF)
;~ ConsoleWrite("! " & @ScriptLineNumber & " makes color RED" & @CRLF)
;~ ConsoleWrite("- " & @ScriptLineNumber & " makes color ORANGE" & @CRLF)
;~ ConsoleWrite("+ " & @ScriptLineNumber & " makes color GREEN" & @CRLF)

Func _Write_debug($str = "")
	$errorfinder = 0
	If $str = "" Then Return

;~ 	if stringinstr($str, "==>") Then
;~ 		_Earn_trophy(3, 1)
;~ 		$str = "[c=#FF0000]" & $str & "[/c] "
;~ 		$errorfinder = 1
;~ 		_run_rule($Section_Trigger11)
;~ 	endif
;~
;~ 	if stringinstr($str, _Get_langstr(107)) Then
;~ 		$str = "[c=#FF0000]" & $str & "[/c] "
;~ 	endif

	;Encoding
	$str = _UNICODE2ANSI($str)

	SendMessage($Debug_log, $SCI_SETREADONLY, False, 0)
	$startline = Sci_GetLineStartPos($Debug_log, Sci_GetLineCount($Debug_log) - 1)
;~ Sci_AddLines($Debug_log, $str,Sci_GetLineCount($Debug_log))
	Sci_InsertText($Debug_log, Sci_GetLenght($Debug_log), $str)

	If $Console_Bluemode = 1 Then
		SendMessage($Debug_log, $SCI_StartStyling, $startline, 31)
		SendMessage($Debug_log, $SCI_SetStyling, Sci_GetLenght($Debug_log), 4)
	EndIf

	If StringInStr($str, "==>") Then
		_Earn_trophy(3, 1)
		$startline = Sci_Search($Debug_log, "==>", Sci_GetLineStartPos($Debug_log, $startline), 0)
		SendMessage($Debug_log, $SCI_StartStyling, $startline, 31)
		SendMessage($Debug_log, $SCI_SetStyling, Sci_GetLenght($Debug_log), 3)
		$errorfinder = 1
		_run_rule($Section_Trigger11)
	EndIf

	If StringInStr($str, _Get_langstr(107)) Then
		SendMessage($Debug_log, $SCI_StartStyling, $startline, 31)
		SendMessage($Debug_log, $SCI_SetStyling, Sci_GetLenght($Debug_log), 10)
	EndIf

;~ 	SendMessage($Debug_log, $SCI_SETREADONLY, true, 0)
	If $errorfinder = 1 And $Erweitertes_debugging = "false" Then _trytofinderror(1)

	SendMessage($Debug_log, $SCI_SetAnchor, Sci_GetLenght($Debug_log), 0) ;set caret position
	SendMessage($Debug_log, $SCI_SetCurrentPos, Sci_GetLenght($Debug_log), 0) ;set caret position
	SendMessage($Debug_log, $SCI_ScrollCaret, 0, 0) ;make caret visible

	_Debug_log_check_redo_undo()
EndFunc   ;==>_Write_debug

Func _Write_debug_old($str = "")
	$errorfinder = 0
	If $str = "" Then Return
	If $Console_Bluemode = 1 Then
		$str = "[c=#0000FF]" & $str & "[/c] "
	EndIf

	If StringInStr($str, "==>") Then
		_Earn_trophy(3, 1)
		$str = "[c=#FF0000]" & $str & "[/c] "
		$errorfinder = 1
		_run_rule($Section_Trigger11)
	EndIf

	If StringInStr($str, _Get_langstr(107)) Then
		$str = "[c=#FF0000]" & $str & "[/c] "
	EndIf

	_GUICtrlRichEdit_SetFont($Debug_log, 10, "Courier New")
	_ChatBoxAdd($Debug_log, $str)
	If $errorfinder = 1 Then _trytofinderror(1)
EndFunc   ;==>_Write_debug_old

Func _Clear_Debuglog()
	SCI_SetText($Debug_log, "")
	$F4_Fehler_aktuelle_Zeile = 0
EndFunc   ;==>_Clear_Debuglog

Func _Syntaxcheck($file)
	If Not FileExists($Au3Checkexe) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1169), 0, $studiofenster)
		Return
	EndIf
	_STOPSCRIPT() ;Wenn noch ein Skript läuft -> Stoppen!
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_Syntaxcheck) <> -1 Then Return ;Platzhalter für Plugin
	If BitAND(_GUICtrlTab_GetItemState($htab, _GUICtrlTab_GetCurFocus($htab)), $TCIS_HIGHLIGHTED) Then _try_to_save_file(_GUICtrlTab_GetCurFocus($htab)) ;Nur Speichern wenn in der Datei auch was geändert wurde (Neu seit version 1.03)
	_Clear_Debuglog()
	Global $starttime = _Timer_Init()
	$SKRIPT_LAUEFT = 1
	;_Check_Buttons()
	$var = StringTrimRight($autoitexe, StringLen($autoitexe) - StringInStr($autoitexe, "\", 0, -1) + 1)
	$var = $var & "\Include"
	$Data = _RunReadStd('"' & $Au3Checkexe & '" -I "' & $var & '" "' & $file & '"', 0, $Offenes_Projekt, @SW_HIDE, 1)
	$Console_Bluemode = 1
	_Write_debug(@CRLF & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & " -> Exit Code: " & $Data[1] & @TAB & "(" & _Get_langstr(105) & " " & Round(_Timer_Diff($starttime) / 1000, 2) & " sec)")
	$Console_Bluemode = 0
	_Timer_KillTimer($studiofenster, $starttime)
	$SKRIPT_LAUEFT = 0
	_run_rule($Section_Trigger5)
	;_Check_Buttons()
EndFunc   ;==>_Syntaxcheck



Func _Run_New_AutoIt_Studio_Helper_Instance($commands = "")

	If Not FileExists($Autoit_Studio_Helper_exe) And Not FileExists(StringReplace($Autoit_Studio_Helper_exe, ".exe", ".au3")) Then
		;Helper nicht gefunden
		MsgBox(262144, "Error", "Autoit_Studio_Helper.exe not found", 0, $Studiofenster)
		SetError(-1)
		Return -1
	EndIf


	Local $Helpfer_exe = $Autoit_Studio_Helper_exe
	If Not FileExists($Helpfer_exe) Then
		$Helpfer_exe = $autoitexe & ' "' & StringReplace($Helpfer_exe, ".exe", ".au3") & '"' ;Wenn exe nicht vorhanden, nutze au3
	EndIf

	$Helper_PID = Run($Helpfer_exe & " " & $commands, @ScriptDir)
	_Write_ISN_Debug_Console("Started new ISN Helper Thread with PID "&$Helper_PID&" and the following commands: "&$commands, $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak)
	Local $Versuche_zum_suchen = 30
	Local $Helper_WindowHandle
	While 1
		$Versuche_zum_suchen = $Versuche_zum_suchen - 1
		$Helper_WindowHandle = WinGetHandle("_ISNTHREAD_STARTUP_", "")
		If Not @error Then ExitLoop
		;Letzter Versuch
		If $Versuche_zum_suchen < 1 Then
			SetError(-1)
			Return -1
		EndIf
		Sleep(100)
	WEnd
	_ISN_Send_Message_to_Plugin($Helper_WindowHandle, _Plugin_Get_Unlockstring()) ;Sende Unlock Nachricht inkl. wichtige Startvariablen an den Thread
	$Result_Array = $Leeres_Array
	_ArrayAdd($Result_Array, $Helper_WindowHandle)
	_ArrayAdd($Result_Array, $Helper_PID)
	Return $Result_Array
EndFunc   ;==>_Run_New_AutoIt_Studio_Helper_Instance


Func _Testscript($file, $without_param = 0, $Parameter_String = "")
	if $Offenes_Projekt = "" then return
	If _GUICtrlTab_GetItemCount($htab) = 0 And $Studiomodus = 2 Then Return
	If _GUICtrlTab_GetCurFocus($htab) = -1 And $Studiomodus = 2 Then Return
	If $SKRIPT_LAUEFT = 1 Then Return
	If $file = "" Then Return
	Local $params = ""

	If FileExists($autoitexe) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(300), 0, $studiofenster)
		Return
	EndIf

	;Toolbar und Buttons sperren
	If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id14), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id14, $TBSTATE_INDETERMINATE)
	If Not BitAND(GUICtrlGetState($ProjectMenu_item9), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item9, $GUI_DISABLE)
	If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id15), $TBSTATE_ENABLED) = $TBSTATE_ENABLED Then _GUICtrlToolbar_SetButtonState($hToolbar, $id15, $TBSTATE_ENABLED)
	If Not BitAND(GUICtrlGetState($ProjectMenu_item10), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($ProjectMenu_item10, $GUI_ENABLE)
	If Not BitAND(GUICtrlGetState($ProjectMenu_item8), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($ProjectMenu_item8, $GUI_DISABLE)
	If Not BitAND(_GUICtrlToolbar_GetButtonState($hToolbar, $id7), $TBSTATE_INDETERMINATE) = $TBSTATE_INDETERMINATE Then _GUICtrlToolbar_SetButtonState($hToolbar, $id7, $TBSTATE_INDETERMINATE)


	_run_rule($Section_Trigger9)


	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
	_Write_log(_Get_langstr(312), "209B25")
	_Save_All_only_script_tabs() ;Alle geöffneten Skripte (au3) Speichern bevor gestartet wird
	_Clear_Debuglog()


	If $without_param = 0 Then
		$params = ""
		If $Parameter_String = "" Then
			$array_params = StringSplit(_IniReadRaw($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "testparam", ""), "#BREAK#", 3)
		Else
			$array_params = StringSplit($Parameter_String, "#BREAK#", 3)
		EndIf
		If IsArray($array_params) Then
			For $x = 0 To UBound($array_params) - 1
				If $array_params[$x] <> "" Then
					If $x = 0 Then
						$params = $array_params[$x]
					Else
						$params = $params & " " & $array_params[$x]
					EndIf
				EndIf
			Next
		EndIf

	Else
		$params = ""
	EndIf

	;Helper Thread resetten
	$ISN_Helper_Threads[0][1] = ""
	$ISN_Helper_Threads[0][2] = ""

	$Console_Bluemode = 1
	_Write_debug(_Get_langstr(104) & " " & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & "..." & @CRLF & @CRLF)
	$Console_Bluemode = 0
	_Write_ISN_Debug_Console("Testing Au3 file (" & $file & ")...", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak)

	If $Erweitertes_debugging = "true" Then ;Falls Debugging aktiv "baue" zuerst das Debug-File
		RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Dbug_imagepath", "REG_SZ", @ScriptDir & "\Data\Dbug\IMAGES\") ;Pfad zum Images Ordner für Dbug

		Try_to_opten_file($file) ;Zu debuggende Datei sollte auch geöffnet sein
		Sleep(100)
		If _GUICtrlTab_GetItemCount($htab) <> 0 Then RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Dbug_Sci_Handle", "REG_SZ", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) ;Handle des aktuellen SCI Fensters


		FileDelete($szDrive & $szDir & $szFName & "_tmp" & $szExt)
		FileCopy($file, $szDrive & $szDir & $szFName & "_tmp" & $szExt)
		_FileWriteToLine($szDrive & $szDir & $szFName & "_tmp" & $szExt, 1, "#Include <" & @ScriptDir & "\Data\Dbug\Dbug.au3>")
		RunWait('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $szDrive & $szDir & $szFName & "_tmp" & $szExt & '" ', $szDrive & $szDir, @SW_HIDE)
		FileDelete($szDrive & $szDir & $szFName & "_tmp" & $szExt)

		Sleep(100)
		$file = FileOpen($szDrive & $szDir & $szFName & "_tmp_debug.txt", 0 + $FO_ANSI)
		; Check if file opened for reading OK
		If $file = -1 Then
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(976))
		EndIf
		$params = FileReadLine($file, 1) ;Parameter werden überschrieben
		FileClose($file)
		$file = $szDrive & $szDir & $szFName & "_tmp_debug" & $szExt
	EndIf


	$ISN_Scripttest_helper_Array = _Run_New_AutoIt_Studio_Helper_Instance('"/thread_task testscript" "/testscript_file ' & $file & '" "/testscript_parameter ' & stringreplace($params,'"',"<quote>") & '"')
	If IsArray($ISN_Scripttest_helper_Array) Then
		$ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_Handle] = $ISN_Scripttest_helper_Array[0] ;Handle
		$ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_PID] = $ISN_Scripttest_helper_Array[1] ;PID
	Else
		_Check_Buttons(0)
		_Write_debug("! Unable to start ISN Helper Thread for script testing!" & @CRLF & @CRLF)
		Return
	EndIf

	$SKRIPT_LAUEFT = 1
EndFunc   ;==>_Testscript

Func _STOPSCRIPT()
	If $SKRIPT_LAUEFT = 0 Then Return
	_ISN_Call_Async_Function_in_Plugin($ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_Handle], "_STOPSCRIPT")
;~ 	$SKRIPT_LAUEFT = 0
;~ 	_Timer_KillTimer($studiofenster, $starttime)
;~ 	_Check_Buttons(0)
;~ 	_run_rule($Section_Trigger10)
EndFunc   ;==>_STOPSCRIPT

#cs
	Func _TestscriptX($file, $without_param = 0, $Parameter_String = "")

	If _GUICtrlTab_GetItemCount($htab) = 0 And $Studiomodus = 2 Then Return
	If _GUICtrlTab_GetCurFocus($htab) = -1 And $Studiomodus = 2 Then Return
	If $SKRIPT_LAUEFT = 1 Then Return
	If $file = "" Then Return

	Local $array_params
	If FileExists($autoitexe) = 0 Then
	MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(300), 0, $studiofenster)
	Return
	EndIf
	_run_rule($Section_Trigger9)
	$f = StringTrimLeft($file, StringInStr($file, "\", 0, -1))

	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
	_Write_log(_Get_langstr(312), "209B25")
	GUICtrlSetData($DEBUGGUI_TITLE, $f & " - " & _Get_langstr(306))
	_Show_DebugGUI()

	;~ 	if _GUICtrlTab_GetItemCount($htab) > 0 AND IsArray($Datei_pfad) then
	;~ 		$ext = stringtrimleft($Datei_pfad[_GUICtrlTab_GetCurFocus($hTab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($hTab)], ".", 1, -1))
	;~
	;~ 		if $ext <> "isf" then
	;~ 			_try_to_save_file(_GUICtrlTab_GetCurFocus($hTab), 1) ;falls gerade das formstudio aktiv ist NICHT speichern da sonst die datei schreibgeschützt wird... -> Autoit kann nicht starten
	;~ 		EndIf
	;~ 	endif

	_Save_All_only_script_tabs() ;Alle geöffneten Skripte (au3) Speichern bevor gestartet wird

	_Clear_Debuglog()
	$Console_Bluemode = 1
	_Write_debug(_Get_langstr(104) & " " & StringTrimLeft($file, StringInStr($file, "\", 0, -1)) & "..." & @CRLF & @CRLF)
	$Console_Bluemode = 0

	Global $starttime = _Timer_Init()
	$SKRIPT_LAUEFT = 1
	_Check_Buttons(0)
	If $without_param = 0 Then
	$params = ""
	If $Parameter_String = "" Then
	$array_params = StringSplit(_IniReadRaw($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "testparam", ""), "#BREAK#", 3)
	Else
	$array_params = StringSplit($Parameter_String, "#BREAK#", 3)
	EndIf
	If IsArray($array_params) Then
	For $x = 0 To UBound($array_params) - 1
	If $array_params[$x] <> "" Then
	If $x = 0 Then
	$params = $array_params[$x]
	Else
	$params = $params & " " & $array_params[$x]
	EndIf
	EndIf
	Next
	EndIf

	Else
	$params = ""
	EndIf
	;~ 	$data = _RunReadStd(FileGetShortName($autoitexe) & " /ErrorStdOut " & FileGetShortName($file) & " " & $params, 0, $Offenes_Projekt, @SW_SHOW, 1)
	_Write_ISN_Debug_Console("Testing Au3 file (" & $file & ")...", $ISN_Debug_Console_Errorlevel_Info, $ISN_Debug_Console_Linebreak)


	If $Erweitertes_debugging = "true" Then ;Falls Debugging aktiv "baue" zuerst das Debug-File
	RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Dbug_imagepath", "REG_SZ", @ScriptDir & "\Data\Dbug\IMAGES\") ;Pfad zum Images Ordner für Dbug



	Try_to_opten_file($file) ;Zu debuggende Datei sollte auch geöffnet sein
	sleep(100)
	If _GUICtrlTab_GetItemCount($htab) <> 0 Then RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Dbug_Sci_Handle", "REG_SZ", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) ;Handle des aktuellen SCI Fensters


	FileDelete($szDrive & $szDir & $szFName & "_tmp" & $szExt)
	FileCopy($file, $szDrive & $szDir & $szFName & "_tmp" & $szExt)
	_FileWriteToLine($szDrive & $szDir & $szFName & "_tmp" & $szExt, 1, "#Include <" & @ScriptDir & "\Data\Dbug\Dbug.au3>")
	RunWait('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $szDrive & $szDir & $szFName & "_tmp" & $szExt & '" ', $szDrive & $szDir, @SW_HIDE)
	FileDelete($szDrive & $szDir & $szFName & "_tmp" & $szExt)

	Sleep(100)
	$file = FileOpen($szDrive & $szDir & $szFName & "_tmp_debug.txt", 0 + $FO_ANSI)
	; Check if file opened for reading OK
	If $file = -1 Then
	MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(976))
	EndIf
	$params = FileReadLine($file, 1) ;Parameter werden überschrieben
	FileClose($file)


	$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $szDrive & $szDir & $szFName & "_tmp_debug" & $szExt & '" ' & $params, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	;Aufräumen
	If FileExists($szDrive & $szDir & $szFName & "_tmp_debug" & $szExt) Then FileDelete($szDrive & $szDir & $szFName & "_tmp_debug" & $szExt)
	If FileExists($szDrive & $szDir & $szFName & "_tmp_debug.txt") Then FileDelete($szDrive & $szDir & $szFName & "_tmp_debug.txt")
	If FileExists($szDrive & $szDir & $szFName & "_tmp_debug_debug.au3") Then FileDelete($szDrive & $szDir & $szFName & "_tmp_debug_debug.au3")
	Else
	If $starte_Skripts_mit_au3Wrapper = "false" Then
	$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $file & '" ' & $params, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	Else
	$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /run /prod /ErrorStdOut /in "' & $file & '" /UserParams ' & $params, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	EndIf
	EndIf
	$Console_Bluemode = 1
	_Write_debug(@CRLF & $szFName & $szExt & " -> Exit Code: " & $Data[1] & @TAB & "(" & _Get_langstr(105) & " " & Round(_Timer_Diff($starttime) / 1000, 2) & " sec)")
	$Console_Bluemode = 0
	_Timer_KillTimer($studiofenster, $starttime)

	$SKRIPT_LAUEFT = 0
	_HIDE_DebugGUI()
	_Check_Buttons(0)
	WinActivate($Studiofenster)
	EndFunc   ;==>_Testscript
#ce


Func GoToLine($line = -1)
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $line = -1 Then
		$line = InputBox(_Get_langstr(116), _Get_langstr(116), "", "", 200 * $DPI, 150 * $DPI, Default, Default, -1, $StudioFenster)
		If @error Then Return
		$line = Number($line) - 1
	EndIf
	If StringIsInt($line) Then
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_ENSUREVISIBLEENFORCEPOLICY, $line, 0) ;
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GOTOLINE, $line, 0)
	EndIf
EndFunc   ;==>GoToLine


Func _trytofinderror($find = 0)
	Local $read = ""
	If $find = 0 Then
		$line = Sci_GetLineFromPos($Debug_log, Sci_GetCurrentPos($Debug_log))
		$F4_Fehler_aktuelle_Zeile = $line
		$read = Sci_GetLine($Debug_log, $line)
	Else

		If $F4_Fehler_aktuelle_Zeile <> 0 Then $F4_Fehler_aktuelle_Zeile = Number($F4_Fehler_aktuelle_Zeile) + 1
		If $F4_Fehler_aktuelle_Zeile > Sci_GetLineCount($Debug_log) Then Return
		For $aktuelle_Zeile = $F4_Fehler_aktuelle_Zeile To Sci_GetLineCount($Debug_log) Step +1
			If StringInStr(Sci_GetLine($Debug_log, $aktuelle_Zeile), "==>") Or StringInStr(Sci_GetLine($Debug_log, $aktuelle_Zeile), "error:") Or StringInStr(Sci_GetLine($Debug_log, $aktuelle_Zeile), "warning:") Then
				$F4_Fehler_aktuelle_Zeile = $aktuelle_Zeile
				$read = Sci_GetLine($Debug_log, $aktuelle_Zeile)
				ExitLoop
			EndIf
		Next
	EndIf
	If $read = "" Then Return


	$line = StringReplace($read, "(x86)", "")
	$line = StringReplace($line, '"', "")
	$line = StringTrimLeft($line, StringInStr($line, "("))
	$line = StringTrimRight($line, StringLen($line) - StringInStr($line, ")") + 1)
	If StringInStr($line, ",") Then $line = StringTrimRight($line, StringLen($line) - StringInStr($line, ",") + 1)
	$line = Number($line)

	If $line = "" Then Return

	$Pfad = StringInStr($read, "(")
	$Pfad = $Pfad - 1
	$Pfad = StringTrimRight($read, StringLen($read) - $Pfad + 1)
	$Pfad = StringReplace($Pfad, '"', "")

	$ext = StringTrimLeft($Pfad, StringInStr($Pfad, ".", 1, -1))
	$ext = StringReplace($ext, '"', "")
	$ext = StringReplace($ext, "'", "")




	If _GUICtrlTab_GetItemCount($htab) = 0 Then
		If $ext <> $Autoitextension Then Return
		Try_to_opten_file($Pfad)
	Else
		If $Pfad <> $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] Then
			If $ext <> $Autoitextension Then Return
			Try_to_opten_file($Pfad)
		EndIf
	EndIf



	$line -= 1
	GoToLine($line)
	_Mark_line($line, _RGB_to_BGR($scripteditor_errorcolour))

EndFunc   ;==>_trytofinderror








Func _trytocut()
   If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CUT, 0, 0)
	EndIf
	_Check_Buttons(0)
EndFunc   ;==>_trytocut

Func _trytocopy()
   If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_COPY, 0, 0)
	EndIf
	_Check_Buttons(0)
EndFunc   ;==>_trytocopy

Func _trytopaste()
   If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then
	   _ISN_AutoIt_Studio_deactivate_GUI_Messages()
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_PASTE, 0, 0)
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_COLOURISE, 0, -1) ;Redraw the lexer
		 _ISN_AutoIt_Studio_activate_GUI_Messages()
	EndIf
	_Check_Buttons(0)
EndFunc   ;==>_trytopaste

Func _trytodelete()
   If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_CLEAR, 0, 0)
	EndIf
	_Check_Buttons(0)
EndFunc   ;==>_trytodelete


Func _open_helpfile_keyword()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then
		_runhelp()
		Return
	EndIf
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	If FileExists($helpfile) = 0 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(301), 0, $studiofenster)
		Return
	EndIf
	$word = SCI_GetWordFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]))
	If $word = "" Then
		_runhelp()
		Return
	EndIf
	If StringInStr($word, "(") Then
		$word = StringTrimRight($word, StringLen($word) - StringInStr($word, "(") + 1)
	EndIf
	ShellExecute($helpfile, $word)
EndFunc   ;==>_open_helpfile_keyword

Func _comment_out()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	If $Starte_Auskommentierung = 1 Then Return
	$Starte_Auskommentierung = 1
	GUICtrlSetOnEvent($Minus_am_Nummernblock_Dummykey, "_comment_out_Nummernblock_Ersatzfunktion")
	$firstline = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSELECTIONSTART, 0, 0), 0)
	$lastlineline = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSELECTIONEND, 0, 0), 0)
	$tempvar = $firstline
	$New_text = ""
	Sci_SetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $firstline), Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $lastlineline + 1))
	;prepare new text
	While 1
		$linePos = $tempvar
		$Text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $tempvar)
		If StringInStr($Text, ";~ ") Then
			$Text = StringReplace($Text, ";~ ", "")
		Else
			If $Text = @CRLF Then
				$Text = $Text
			Else
				$Text = ";~ " & $Text
			EndIf
		EndIf
		$New_text = $New_text & $Text
		$tempvar = $tempvar + 1
		If $tempvar > $lastlineline Then ExitLoop
	WEnd

	;Replace Selected Text
	Sci_ReplaceSel($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $New_text)

;~
;~ 	;delete old lines
;~ 	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $SCI_CLEAR, 0, 0)
;~
;~ 	;Insert new text
;~ 	Sci_InsertText($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], $firstline), $New_text)
;~
	;and select it
	$lastlinelenght = Sci_GetLineLenght($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $lastlineline)
	Sci_SetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $firstline), Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $lastlineline) + $lastlinelenght - 1)

	;Sci_InsertText($Sci, $Pos, $Text)
	While _Pruefe_Hotkey($Hotkey_Keycode_auskommentieren)
		Sleep(50)
	WEnd

	While _IsPressed("6D", $user32)
		Sleep(50)
	WEnd


	;Taste wurde losgelassen
	GUICtrlSetOnEvent($Minus_am_Nummernblock_Dummykey, "_comment_out")
	$Starte_Auskommentierung = 0
	_Check_Buttons(0)
EndFunc   ;==>_comment_out

Func _comment_out_Nummernblock_Ersatzfunktion()
	;Hier gibt´s nichts zu sehen
EndFunc   ;==>_comment_out_Nummernblock_Ersatzfunktion

Func _SCE_EDITOR_is_Read_only($Handle = "")
	If $Handle = "" Then Return False
	If SendMessage($Handle, $SCI_GETREADONLY, 0, 0) Then

		$ParameterEditor_GUI_State = WinGetState($ParameterEditor_GUI, "")
		If BitAND($ParameterEditor_GUI_State, 2) Then
			MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1296), "%1", WinGetTitle($ParameterEditor_GUI)), 0, $studiofenster)
			Return True
		EndIf
	EndIf


	Return False
EndFunc   ;==>_SCE_EDITOR_is_Read_only




Func _Tidy($file)
	If Not FileExists($Tidyexe) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1328), 0, $Studiofenster)
		Return
	EndIf

	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	If $Can_open_new_tab = 0 Then Return
	If _SCE_EDITOR_is_Read_only($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) Then Return
	_STOPSCRIPT() ;Wenn noch ein Skript läuft -> Stoppen!
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 1, -1)) = $Autoitextension Then
		If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_TidySource) <> -1 Then Return ;Platzhalter für Plugin
		If BitAND(_GUICtrlTab_GetItemState($htab, _GUICtrlTab_GetCurFocus($htab)), $TCIS_HIGHLIGHTED) Then _try_to_save_file(_GUICtrlTab_GetCurFocus($htab)) ;Nur Speichern wenn in der Datei auch was geändert wurde (Neu seit version 1.03)
		If $Tidy_is_running = 1 Then Return
		$Console_Bluemode = 1
		$Can_open_new_tab = 0
		$Current_sci_pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		_Clear_Debuglog()
		_Write_debug(_Get_langstr(424) & @CRLF & @CRLF)
		$Console_Bluemode = 0
		$Tidy_is_running = 1
		;ClipPut($Tidyexe & ' "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '"')
;~ 		$Data = _RunReadStd($Tidyexe & ' "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '"', 0, @ScriptDir, @SW_HIDE, 1)
		$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /Tidy /in "' & $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)] & '"', 0, @ScriptDir, @SW_HIDE, 1)
		LoadEditorFile($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $file)
		_Write_debug(@CRLF & "-> " & _Get_langstr(249))
		_Editor_Restore_Fold()
		Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Current_sci_pos) ;Restore old Pos
		_Check_Buttons(0)

		$Tidy_is_running = 0
		_run_rule($Section_Trigger4)
		Sleep(100)
		$Can_open_new_tab = 1
	EndIf
EndFunc   ;==>_Tidy



Func _ist_nach_istgleichzeichen($line = "", $string = "")
	$pos_istgleich = StringInStr($line, "=")
	If StringInStr($line, $string) > $pos_istgleich Then Return True
	Return False
EndFunc   ;==>_ist_nach_istgleichzeichen

Func _Scripttree_pruefe_element($mode = 0, $found = 0, $searchstring = "")
	;gibt false zurück wenn etwas nicht stimmt
	$txt = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found))
	$txt = StringReplace($txt, @CRLF, "")
;~ ConsoleWrite("HOLE LINE IS:'"&$txt&"' MODE IS:"&$mode&@crlf)

	If $mode <> "region" And $mode <> "include" Then
		;prüfe ob hier nach dem richtigen gesucht wird:
		Local $is_correct = 0
		Local $uList[900]
		$uList = StringSplit($txt, ",", 2)
		$uList = StringSplit(_ArrayToString($uList), "=", 2)
		$uList = StringSplit(_ArrayToString($uList), ";", 2)
		$uList = StringSplit(_ArrayToString($uList), "~", 2)
		$uList = StringSplit(_ArrayToString($uList), "(", 2)
		$uList = StringSplit(_ArrayToString($uList), ")", 2)
		$uList = StringSplit(_ArrayToString($uList), " ", 2)
		$uList = StringSplit(_ArrayToString($uList), "|", 2)
		If Not IsArray($uList) Then Return False
		For $i = 0 To UBound($uList, 1) - 1
			If $uList[$i] = $searchstring Then $is_correct = 1

		Next
		If $is_correct = 0 Then Return False
	EndIf

	If StringInStr($txt, "#cs") Then Return False
	If StringInStr($txt, "#ce") Then Return False

	If $mode = "global" Then
		If StringInStr($txt, "global") Then

			If StringInStr($txt, "=") Then
				If _ist_nach_istgleichzeichen($txt, $searchstring) = True Then
					If StringInStr($txt, "(") = 0 And StringInStr($txt, ")") = 0 And StringInStr($txt, "+") = 0 And StringInStr($txt, "-") = 0 And StringInStr($txt, "if") = 0 Then
						Return True
					Else
						Return False
					EndIf

				EndIf
			EndIf

			Return True
		EndIf
;~ 		if StringInStr($txt, " _") AND StringInStr($txt, "then") = 0 AND StringInStr($txt, "while") = 0 AND StringInStr($txt, "next") = 0 then return true
	EndIf

	If $mode = "local" Then
		If StringInStr($txt, "local") Then
			If StringInStr($txt, "=") Then
				If _ist_nach_istgleichzeichen($txt, $searchstring) = True Then
					If StringInStr($txt, "(") = 0 And StringInStr($txt, ")") = 0 And StringInStr($txt, "+") = 0 And StringInStr($txt, "-") = 0 And StringInStr($txt, "if") = 0 Then
						Return True
					Else
						Return False
					EndIf

				EndIf
			EndIf

			Return True
		EndIf
;~ 		if StringInStr($txt, " _") AND StringInStr($txt, "then") = 0 AND StringInStr($txt, "while") = 0 AND StringInStr($txt, "next") = 0 then return true
	EndIf

	If $mode = "func" Then
		If StringInStr($txt, "func") Then
			If Not StringInStr($txt, "(") Then Return False
			Return True
		EndIf
	EndIf

	If $mode = "include" Then
		If StringInStr($txt, "#include") Then Return True
	EndIf

	If $mode = "region" Then
		If StringInStr($txt, "#region") Then
			If StringInStr($txt, "#endregion") Then Return False
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>_Scripttree_pruefe_element

Func _search_from_Scripttree($string, $startpos = 0, $mode = 0)
	$wrapFind = True
	If $autoit_editor_encoding = "2" Then $string = _UNICODE2ANSI($string)


	If $startpos = 0 Then FindNext($string & Random(23043), False, False, 0, False) ;mache zufallssuche um wieder von oben zu beginnen ^^
	$loops = 0
	While 1
		$loops = $loops + 1
		If $loops > 200 Then Return -1
;~ 		ConsoleWrite("Search: "&$string&" Loop:"&$loops&@crlf)
		;suche solange bis wieder das element ohne kommentar gefunden wurde...
		$wrapFind = True
		$found = FindNext($string, False, False, 0, False)
		If $found <> -1 Then
			If _Is_Comment() = True Then ContinueLoop
			If _Scripttree_pruefe_element($mode, $found, $string) = False Then
;~ 				ConsoleWrite("-> RETURNS FALSE" & @crlf)
				ContinueLoop
			EndIf
			If _Is_Comment() = False Then ExitLoop ;win ;)
		EndIf

		If $found = -1 Then ExitLoop

	WEnd


	Return $found
EndFunc   ;==>_search_from_Scripttree

Func SCI_GetWord_ISN_Special($sci, $onlyWordCharacters = 1)

	Local $currentPos = SCI_GetCurrentPos($sci)
	Local $start = SendMessage($sci, $SCI_WORDSTARTPOSITION, $currentPos, $onlyWordCharacters)
	If Sci_GetChar($sci, $start - 1) = "#" Or Sci_GetChar($sci, $start - 1) = "@" Or Sci_GetChar($sci, $start - 1) = "$" Then
		$start = $start - 1
	EndIf

	;Local $end = SendMessage($sci, $SCI_WORDENDPOSITION, $currentPos, $onlyWordCharacters)
	Return SCI_GETTEXTRANGE($sci, $start, $currentPos)

EndFunc   ;==>SCI_GetWord_ISN_Special

Func _ConvertAnsiToUtf8($sText)
	Local $tUnicode = _WBD_WinAPI_MultiByteToWideChar($sText)
	If @error Then Return SetError(@error, 0, "")
	Local $sUtf8 = _WBD_WinAPI_WideCharToMultiByte(DllStructGetPtr($tUnicode), 65001)
	If @error Then Return SetError(@error, 0, "")
	Return SetError(0, 0, $sUtf8)
EndFunc   ;==>_ConvertAnsiToUtf8

Func _WBD_WinAPI_MultiByteToWideChar($sText, $iCodePage = 0, $iFlags = 0)
	Local $iText, $pText, $tText

	$iText = StringLen($sText) + 1
	$tText = DllStructCreate("wchar[" & $iText & "]")
	$pText = DllStructGetPtr($tText)
	DllCall("Kernel32.dll", "int", "MultiByteToWideChar", "int", $iCodePage, "int", $iFlags, "str", $sText, "int", $iText, "ptr", $pText, "int", $iText)
	If @error Then Return SetError(@error, 0, $tText)
	Return $tText
EndFunc   ;==>_WBD_WinAPI_MultiByteToWideChar

Func _WBD_WinAPI_WideCharToMultiByte($pUnicode, $iCodePage = 0)
	Local $aResult, $tText, $pText

	$aResult = DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", $iCodePage, "int", 0, "ptr", $pUnicode, "int", -1, "ptr", 0, "int", 0, "int", 0, "int", 0)
	If @error Then Return SetError(@error, 0, "")
	$tText = DllStructCreate("char[" & $aResult[0] + 1 & "]")
	$pText = DllStructGetPtr($tText)
	$aResult = DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", $iCodePage, "int", 0, "ptr", $pUnicode, "int", -1, "ptr", $pText, "int", $aResult[0], "int", 0, "int", 0)
	If @error Then Return SetError(@error, 0, "")
	Return DllStructGetData($tText, 1)
EndFunc   ;==>_WBD_WinAPI_WideCharToMultiByte

Func _Scripttree_DB_Klick()
	If _GUICtrlTreeView_GetSelection($hTreeview2) = 0 Then Return
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), ".", 1, -1) = 0 Then Return
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(84) Then Return ;Stoppe bei Root von Globalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(416) Then Return ;Stoppe bei Root von Lokalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(83) Then Return ;Stoppe bei Root von Funktionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(433) Then Return ;Stoppe bei Root von Regionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(324) Then Return ;Stoppe bei Root von Includes
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(323) Then Return ;Stoppe bei Root von Forms im Projekt
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(323)) Then Return ;Stoppe bei Subitems von Forms im Projekt

	$mode = 0
	$str = StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1))
	If StringInStr($str, " {") Then $str = StringTrimRight($str, StringLen($str) - StringInStr($str, " {") + 1) ;Cut Counts
	$str = StringStripWS($str, 3) ;Entferne Leerzeichen am anfang & Ende eines Elements falls vorhanden
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(83)) Then $mode = "func" ;$str = "func "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(433)) Then $mode = "region" ;$str = "#region "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(84)) Then $mode = "global"
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(416)) Then $mode = "local" ;$str = "global "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(324)) Then $mode = "include" ;$str = "global "&$str


	$Result = _Finde_Element_im_Skript($str, $mode)
	If $Result = -1 Then Return ;Nichts gefunden
	;markiere ganze Zeile
	$start = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Result))
	$end = Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Result))
	SetSelection($start, $end)

EndFunc   ;==>_Scripttree_DB_Klick












Func _Find_Error_F4()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	_trytofinderror(1)
EndFunc   ;==>_Find_Error_F4


Func _kuerze_Projektname($string)
	If StringInStr($string, "\") Then
		If StringLen($string) > 33 Then
			$string = "..." & StringTrimLeft($string, StringLen($string) - 33)
		EndIf
		Return $string
	Else
		If StringLen($string) > 33 Then
			$string = StringTrimRight($string, StringLen($string) - 33) & "..."
		EndIf
		Return $string
	EndIf
EndFunc   ;==>_kuerze_Projektname

Func _Read_Last_4_Projects()
	Local $name

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj1path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj1path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_1[1], _kuerze_Projektname($name))
	$History_Projekte_Array[0] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj1path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj2path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj2path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_2[1], _kuerze_Projektname($name))
	$History_Projekte_Array[1] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj2path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj3path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj3path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_3[1], _kuerze_Projektname($name))
	$History_Projekte_Array[2] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj3path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj4path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj4path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_4[1], _kuerze_Projektname($name))
	$History_Projekte_Array[3] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj4path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj5path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj5path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_5[1], _kuerze_Projektname($name))
	$History_Projekte_Array[4] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj5path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj6path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj6path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_6[1], _kuerze_Projektname($name))
	$History_Projekte_Array[5] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj6path", ""))

	$name = IniRead(_Finde_Projektdatei(_ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj7path", ""))), "ISNAUTOITSTUDIO", "name", "")
	If $name = "" Then ;prüfe ob es vlt. eine Datei ist...
		$file = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj7path", ""))
		If FileExists($file) Then $name = $file
	EndIf
	GUICtrlSetData($last_item_7[1], _kuerze_Projektname($name))
	$History_Projekte_Array[6] = _ISN_Variablen_aufloesen(IniRead($Configfile, "history", "pj7path", ""))

	If GUICtrlRead($last_item_1[1]) = "" Then
		GUICtrlSetState($last_item_1[0], $GUI_HIDE)
		GUICtrlSetState($last_item_1[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_1[0], $GUI_SHOW)
		GUICtrlSetState($last_item_1[1], $GUI_SHOW)
		GUICtrlSetTip($last_item_1[0], $History_Projekte_Array[0])
		GUICtrlSetTip($last_item_1[1], $History_Projekte_Array[0])
	EndIf

	If GUICtrlRead($last_item_2[1]) = "" Then
		GUICtrlSetState($last_item_2[0], $GUI_HIDE)
		GUICtrlSetState($last_item_2[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_2[0], $GUI_SHOW)
		GUICtrlSetState($last_item_2[1], $GUI_SHOW)
		GUICtrlSetTip($last_item_2[0], $History_Projekte_Array[1])
		GUICtrlSetTip($last_item_2[1], $History_Projekte_Array[1])
	EndIf

	If GUICtrlRead($last_item_3[1]) = "" Then
		GUICtrlSetState($last_item_3[0], $GUI_HIDE)
		GUICtrlSetState($last_item_3[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_3[0], $GUI_SHOW)
		GUICtrlSetState($last_item_3[1], $GUI_SHOW)
		GUICtrlSetTip($last_item_3[0], $History_Projekte_Array[2])
		GUICtrlSetTip($last_item_3[1], $History_Projekte_Array[2])
	EndIf

	If GUICtrlRead($last_item_4[1]) = "" Then
		GUICtrlSetState($last_item_4[0], $GUI_HIDE)
		GUICtrlSetState($last_item_4[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_4[0], $GUI_SHOW)
		GUICtrlSetState($last_item_4[1], $GUI_SHOW)
		GUICtrlSetTip($last_item_4[0], $History_Projekte_Array[3])
		GUICtrlSetTip($last_item_4[1], $History_Projekte_Array[3])
	EndIf

	If GUICtrlRead($last_item_5[1]) = "" Then
		GUICtrlSetState($last_item_5[0], $GUI_HIDE)
		GUICtrlSetState($last_item_5[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_5[0], $GUI_SHOW)
		GUICtrlSetState($last_item_5[1], $GUI_SHOW)
		GUICtrlSetTip($last_item_5[0], $History_Projekte_Array[4])
		GUICtrlSetTip($last_item_5[1], $History_Projekte_Array[4])
	EndIf

	If GUICtrlRead($last_item_6[1]) = "" Then
		GUICtrlSetState($last_item_6[0], $GUI_HIDE)
		GUICtrlSetState($last_item_6[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_6[0], $GUI_SHOW)
		GUICtrlSetState($last_item_6[1], $GUI_SHOW)
		GUICtrlSetTip($last_item_6[0], $History_Projekte_Array[5])
		GUICtrlSetTip($last_item_6[1], $History_Projekte_Array[5])
	EndIf

	If GUICtrlRead($last_item_7[1]) = "" Then
		GUICtrlSetState($last_item_7[0], $GUI_HIDE)
		GUICtrlSetState($last_item_7[1], $GUI_HIDE)
	Else
		GUICtrlSetState($last_item_7[0], $GUI_SHOW)
		GUICtrlSetState($last_item_7[1], $GUI_SHOW)
		GUICtrlSetTip($last_item_7[0], $History_Projekte_Array[6])
		GUICtrlSetTip($last_item_7[1], $History_Projekte_Array[6])
	EndIf
EndFunc   ;==>_Read_Last_4_Projects

Func _Hit_Lastproject_1()
	If $History_Projekte_Array[0] = "" Then Return
	If _IsDir($History_Projekte_Array[0]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[0])
	Else
		If FileExists($History_Projekte_Array[0]) Then _oeffne_Editormodus($History_Projekte_Array[0])
	EndIf
EndFunc   ;==>_Hit_Lastproject_1

Func _Hit_Lastproject_2()
	If $History_Projekte_Array[1] = "" Then Return
	If _IsDir($History_Projekte_Array[1]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[1])
	Else
		If FileExists($History_Projekte_Array[1]) Then _oeffne_Editormodus($History_Projekte_Array[1])
	EndIf
EndFunc   ;==>_Hit_Lastproject_2

Func _Hit_Lastproject_3()
	If $History_Projekte_Array[2] = "" Then Return
	If _IsDir($History_Projekte_Array[2]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[2])
	Else
		If FileExists($History_Projekte_Array[2]) Then _oeffne_Editormodus($History_Projekte_Array[2])
	EndIf
EndFunc   ;==>_Hit_Lastproject_3

Func _Hit_Lastproject_4()
	If $History_Projekte_Array[3] = "" Then Return
	If _IsDir($History_Projekte_Array[3]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[3])
	Else
		If FileExists($History_Projekte_Array[3]) Then _oeffne_Editormodus($History_Projekte_Array[3])
	EndIf
EndFunc   ;==>_Hit_Lastproject_4

Func _Hit_Lastproject_5()
	If $History_Projekte_Array[4] = "" Then Return
	If _IsDir($History_Projekte_Array[4]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[4])
	Else
		If FileExists($History_Projekte_Array[4]) Then _oeffne_Editormodus($History_Projekte_Array[4])
	EndIf
EndFunc   ;==>_Hit_Lastproject_5

Func _Hit_Lastproject_6()
	If $History_Projekte_Array[5] = "" Then Return
	If _IsDir($History_Projekte_Array[5]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[5])
	Else
		If FileExists($History_Projekte_Array[5]) Then _oeffne_Editormodus($History_Projekte_Array[5])
	EndIf
EndFunc   ;==>_Hit_Lastproject_6

Func _Hit_Lastproject_7()
	If $History_Projekte_Array[6] = "" Then Return
	If _IsDir($History_Projekte_Array[6]) Then
		_Load_Project_by_Foldername($History_Projekte_Array[6])
	Else
		If FileExists($History_Projekte_Array[6]) Then _oeffne_Editormodus($History_Projekte_Array[6])
	EndIf
EndFunc   ;==>_Hit_Lastproject_7

; #FUNCTION# ;===============================================================================
;
; Name...........: _fuege_in_History_ein
; Description ...: Fügt einen Dateipfad in eine Liste zuletzt verwendeter Elemente
; Syntax.........: _fuege_in_History_ein($History_Array,$Pfad="")
; Parameters ....: $History_Array			- Das Array indem die Elemente zufinden sind
;                  $Pfad					- Pfad der Eingefügt werden soll
; Return values .: Das Array indem die Elemente zufinden sind
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird für die zuletzt verwendeten Elemente am Startscreen verwendet
; Related .......:
; Link ..........: http://www.isnetwork.at.pn
; Example .......: No
;
; ;==========================================================================================

Func _fuege_in_History_ein($History_Array, $Pfad = "")
	If $Pfad = "" Then Return
	If Not IsArray($History_Array) Then Return
	$Pfad = FileGetLongName($Pfad)
	;prüfe ob Eintrag schon in der Liste ist
	If _ArraySearch($History_Array, $Pfad) = -1 Then
		;noch nicht in der Liste

		;Rücke alle Einträge 1 nach unten
		For $x = UBound($History_Array) - 1 To 1 Step -1
			$History_Array[$x] = $History_Array[$x - 1]
		Next
		;Füge neues Element ein
		$History_Array[0] = $Pfad

	Else
		;bereits in der Liste

		;Lösche das Element aus der Liste...
		_ArrayDelete($History_Array, _ArraySearch($History_Array, $Pfad))
		_ArrayAdd($History_Array, "")
		;..und füge es neu ein:
		$History_Array = _fuege_in_History_ein($History_Array, $Pfad)
	EndIf

	;Schreibe das Array in die Config
	For $x = 0 To UBound($History_Array) - 1
		IniWrite($Configfile, "history", "pj" & $x + 1 & "path", _ISN_Pfad_durch_Variablen_ersetzen($History_Array[$x], 1))
	Next
	Return $History_Array
EndFunc   ;==>_fuege_in_History_ein

Func _Open_External_Project()
	$var = FileOpenDialog(_Get_langstr(507), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(193) & " (*.isn)", 1 + 2 + 4, "", $Welcome_GUI)
	FileChangeDir(@ScriptDir)
	If @error Then Return
	If $var = "" Then Return
	$var = StringTrimRight($var, StringLen($var) - StringInStr($var, "\", 0, -1) + 1)
	_Load_Project_by_Foldername($var)
EndFunc   ;==>_Open_External_Project

Func _Load_Project_by_Foldername($path)
	If $path = "" Then Return

	If _Pruefe_auf_mehrere_Projektdateien($path) = True Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1104), 0, $Welcome_GUI)
		Return
	EndIf

	If Not FileExists(_Finde_Projektdatei($path)) Then
		GUISetState(@SW_SHOW, $Welcome_GUI)
		Return
	EndIf

	$Pfad_zur_Project_ISN = _Finde_Projektdatei($path)
	$PID_Read = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened", "")
	$name = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", "")
	If ProcessExists($PID_Read) Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(331), 0, $Welcome_GUI)
		If $Offenes_Projekt = "" Then GUISetState(@SW_SHOW, $Welcome_GUI)
		Return
	EndIf

	If Not FileExists($path) Then
		MsgBox(262144 + 16, _Get_langstr(25), $path & " " & _Get_langstr(332), 0, $Welcome_GUI)
		Return
	EndIf

	_show_Loading(_Get_langstr(34), _Get_langstr(23))

	GUISetState(@SW_HIDE, $Welcome_GUI)
	GUISetState(@SW_HIDE, $projectmanager)

	_Write_log(_Get_langstr(34) & "(" & $name & ")", "000000", "true", "true")
	GUISetState(@SW_LOCK, $studiofenster)
	GUICtrlSetState($HD_Logo, $GUI_HIDE)

	_Loading_Progress(90)
	$Studiomodus = 1

	_Load_Project($path)
	_Check_tabs_for_changes()

	;_Write_in_Config("lastproject",$name)
	If $Templatemode = 0 And $Tempmode = 0 Then _Write_in_Config("lastproject", $path)
	If $Templatemode = 0 And $Tempmode = 0 Then $History_Projekte_Array = _fuege_in_History_ein($History_Projekte_Array, $path)
	If $Templatemode = 0 And $Tempmode = 0 Then _Start_Project_timer()

	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "opened", @AutoItPID)
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "lastopendate", @MDAY & "." & @MON & "." & @YEAR & " " & @HOUR & ":" & @MIN)
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


	_Write_ISN_Debug_Console("Project loaded (" & $Offenes_Projekt_name & ") from " & $Offenes_Projekt, 1)
	_Loading_Progress(100)
	_Check_Buttons(0)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_UNLOCK, $studiofenster)
	_Hide_Loading()
	_run_rule($Section_Trigger1)
EndFunc   ;==>_Load_Project_by_Foldername

Func _search_in_Scripttree()
	If $Control_Flashes = 1 Then Return
	If GUICtrlRead($hTreeview2_searchinput) = "" Then Return
	If GUICtrlRead($hTreeview2_searchinput) = _Get_langstr(443) Then Return
	If GUICtrlRead($hTreeview2_searchinput) <> $Treeview_Search_LastSearch Then
		$Treeview_Search_count = 0
		$Treeview_Search_LastSearch = GUICtrlRead($hTreeview2_searchinput)
	EndIf
	$node = _GUICtrlTreeView_FindItem($hTreeview2, GUICtrlRead($hTreeview2_searchinput), True, $Treeview_Search_count) ; substring
	If $node = 0 Then
		_Input_Error_FX($hTreeview2_searchinput)
;~ 		GUICtrlSetBkColor($hTreeview2_searchinput, 0xFF9E9E)
		$Treeview_Search_count = 0 ;reset search
	Else
		$Treeview_Search_count = _GUICtrlTreeView_GetNext($hTreeview2, $node)
		;GUICtrlSetBkColor($hTreeview2_searchinput,0x8EFC99)
		GUICtrlSetBkColor($hTreeview2_searchinput, $Skriptbaum_Suchfeld_Hintergrundfarbe)
		GUICtrlSetColor($hTreeview2_searchinput, $Skriptbaum_Suchfeld_Schriftfarbe)
		_GUICtrlTreeView_SelectItem($hTreeview2, $node)
		_Scripttree_DB_Klick() ;Springe zu Suchergebnis
		GUICtrlSetState($hTreeview2_searchinput, $GUI_FOCUS) ;Und gib Focus auf Suchfeld zurück
	EndIf
EndFunc   ;==>_search_in_Scripttree

Func _Toggle_hide_leftbar()
	If $Offenes_Projekt = "" Then Return
	$Pos_VSplitter_1 = ControlGetPos($StudioFenster, "", $Left_Splitter_X)
	$winpos = WinGetClientSize($studiofenster)
	If $Toggle_Leftside = 0 Then
		$Toggle_Leftside = 1
		GUICtrlSetPos($Left_Splitter_X, 18 * $DPI, Default, $Splitter_Breite)
		GUICtrlSetState($Left_Splitter_X, $GUI_HIDE)
		GUISetState(@SW_HIDE, $QuickView_GUI)
		GUICtrlSetState($hTreeview, $GUI_DISABLE)
		GUICtrlSetState($hTreeview, $GUI_HIDE)
		GUICtrlSetState($Left_Splitter_Y, $GUI_HIDE)
		GUICtrlSetState($QuickView_title, $GUI_HIDE)
		$tmp = _Get_langstr(468)
		$vertical_string = ""
		$tmp2 = StringLen($tmp)
		For $r = 1 To $tmp2
			$vertical_string = $vertical_string & StringLeft($tmp, 1) & @CRLF
			$tmp = StringTrimLeft($tmp, 1)
		Next

		GUICtrlSetData($Projecttree_title, $vertical_string)
		GUICtrlSetPos($Projecttree_title, 3, $Toolbar_Size[0] + 3, 20 * $DPI, 150 * $DPI)
		GUICtrlSetColor($Projecttree_title, $Skriptbaum_Header_Schriftfarbe)
		_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind

	Else
		$Toggle_Leftside = 0
		GUICtrlSetPos($Left_Splitter_X, ($winpos[0] / 100) * Number(_Config_Read("Left_Splitter_X", $Linker_Splitter_X_default)), $Pos_VSplitter_1[1], $Splitter_Breite)
		GUICtrlSetState($Left_Splitter_X, $GUI_SHOW)
		GUICtrlSetState($hTreeview, $GUI_ENABLE)
		GUICtrlSetState($hTreeview, $GUI_SHOW)
		If $hideprogramlog = "false" Then
			GUISetState(@SW_SHOWNOACTIVATE, $QuickView_GUI)
			GUICtrlSetState($Left_Splitter_Y, $GUI_SHOW)
			GUICtrlSetState($QuickView_title, $GUI_SHOW)
		EndIf
		GUICtrlSetData($Projecttree_title, " " & _Get_langstr(468))
		GUICtrlSetColor($Projecttree_title, $Skriptbaum_Header_Schriftfarbe)
		GUICtrlSetPos($Projecttree_title, 2, 30, 300 * $DPI, 19 * $DPI)
		_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind
	EndIf
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then Return

	$tabsize = ControlGetPos($StudioFenster, "", $htab)

	$htab_wingetpos_array = WinGetPos(GUICtrlGetHandle($htab))
	$y = $htab_wingetpos_array[1] + $Tabseite_hoehe
	$x = $htab_wingetpos_array[0] + 4

	;resize Plugin correctly
	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	WinMove($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], "", $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4)
	$plugsize = WinGetPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	WinMove($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", 0, 0, $plugsize[2], $plugsize[3])
	_ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "resize") ;Resize an Plugin senden
	;end
	_Resize_Elements_to_Window()
EndFunc   ;==>_Toggle_hide_leftbar

Func _Toggle_hide_rightbar()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$ext = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 1, -1))
	If $ext <> $Autoitextension Then Return
	$Pos_VSplitter_2 = ControlGetPos($StudioFenster, "", $Right_Splitter_X)
	$winpos = WinGetClientSize($studiofenster)
	If $Toggle_rightside = 0 Then
		$Toggle_rightside = 1

		GUICtrlSetPos($Right_Splitter_X, 18, Default)


		GUICtrlSetState($hTreeview2, $GUI_DISABLE)
		GUICtrlSetState($hTreeview2, $GUI_HIDE)
		GUICtrlSetState($Right_Splitter_X, $GUI_HIDE)
		GUICtrlSetState($Skriptbaum_Einstellungen_Button, $GUI_HIDE)
		GUICtrlSetState($Skriptbaum_Aktualisieren_Button, $GUI_HIDE)
		GUICtrlSetState($hTreeview2_searchinput, $GUI_HIDE)
		GUICtrlSetPos($Right_Splitter_X, $winpos[0] - (30 * $DPI), $Pos_VSplitter_2[1])
		$tmp = _Get_langstr(469)
		$vertical_string = ""
		$tmp2 = StringLen($tmp)
		For $r = 1 To $tmp2
			$vertical_string = $vertical_string & StringLeft($tmp, 1) & @CRLF
			$tmp = StringTrimLeft($tmp, 1)
		Next
		GUICtrlSetData($Scripttree_title, $vertical_string)
		GUICtrlSetPos($Scripttree_title, $winpos[0] - (28 * $DPI), $Toolbar_Size[0] + 3, 20 * $DPI, 150 * $DPI)
		GUICtrlSetColor($Scripttree_title, $Skriptbaum_Header_Schriftfarbe)
		_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind
	Else

		$Toggle_rightside = 0
		GUICtrlSetState($Right_Splitter_X, $GUI_SHOW)
		GUICtrlSetState($hTreeview2, $GUI_ENABLE)
		GUICtrlSetState($hTreeview2, $GUI_SHOW)
		GUICtrlSetState($Skriptbaum_Einstellungen_Button, $GUI_SHOW)
		GUICtrlSetState($Skriptbaum_Aktualisieren_Button, $GUI_SHOW)
		GUICtrlSetState($hTreeview2_searchinput, $GUI_SHOW)
		GUICtrlSetData($Scripttree_title, " " & _Get_langstr(469))
		GUICtrlSetColor($Scripttree_title, $Skriptbaum_Header_Schriftfarbe)
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		GUICtrlSetPos($Right_Splitter_X, ($winpos[0] / 100) * Number(_Config_Read("Right_Splitter_X", $Rechter_Splitter_X_default)), $Pos_VSplitter_2[1], $Splitter_Breite)
		_Aktualisiere_Splittercontrols() ;Aktuallisiere alle Controls die mit Splittern verbunden sind
	EndIf
	_Resize_Elements_to_Window()
EndFunc   ;==>_Toggle_hide_rightbar

Func _Editor_Save_Fold()
	If $savefolding = "false" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$section = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], "\", 1, -1))
	IniDelete($foldingfile, $section) ;renew
	For $count = 0 To Sci_GetLineCount($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETFOLDEXPANDED, $count, 0) = 0 Then
			IniWrite($foldingfile, $section, $count + 1, StringReplace(StringReplace(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $count), @CRLF, ""), @TAB, ""))
		EndIf
	Next
EndFunc   ;==>_Editor_Save_Fold

Func _Editor_Restore_Fold()
	If $savefolding = "false" Then Return
	If Not FileExists($foldingfile) Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	$section = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], "\", 1, -1))
	$readen_keys = IniReadSection($foldingfile, $section)
	If @error = 1 Then Return ;no folding for this file
	;count for every line...
	For $count = UBound($readen_keys) - 1 To 1 Step -1
		If $readen_keys[$count][1] = StringReplace(StringReplace(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $readen_keys[$count][0] - 1), @CRLF, ""), @TAB, "") Then
			GoToLine($readen_keys[$count][0])
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_TOGGLEFOLD, $readen_keys[$count][0] - 1, 1)
		EndIf
	Next
	GoToLine(1)
EndFunc   ;==>_Editor_Restore_Fold

Func _Try_to_open_include_hotkey()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If $Offenes_Projekt = "" Then Return
	$str = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
	_Try_to_open_include($str)
EndFunc   ;==>_Try_to_open_include_hotkey


Func _Try_to_open_include($linestring)
	If $linestring = "" Then Return

;~ 	if stringinstr($linestring, "#include") then
	;Include
	$linestring = StringStripWS($linestring, 3)
	If StringInStr($linestring, ".") Then
		$file = $linestring
		If StringInStr($file, "<") Then $file = StringTrimLeft($file, StringInStr($file, "<"))
		If StringInStr($file, '"') Then $file = StringTrimLeft($file, StringInStr($file, '"'))
		If StringInStr($file, "'") Then $file = StringTrimLeft($file, StringInStr($file, "'"))

		If StringInStr($file, ">") Then $file = StringTrimRight($file, StringLen($file) - (StringInStr($file, ">") - 1))
		If StringInStr($file, '"') Then $file = StringTrimRight($file, StringLen($file) - (StringInStr($file, '"') - 1))
		If StringInStr($file, "'") Then $file = StringTrimRight($file, StringLen($file) - (StringInStr($file, "'") - 1))
		$file = StringStripWS($file, 3)


		;Prüfe ob Datei im Projekt exestiert
		If FileExists($Offenes_Projekt & "\" & $file) Then
			Sleep(300) ;Ohne sleep wird das Fenster komisch verstümmelt..warum auch immer
			Try_to_opten_file($Offenes_Projekt & "\" & $file)
			Return
		EndIf

		;Prüfe ob Datei in den AutoIt Includes exestiert
		If FileExists($autoitexe) Then
			$tmp = $autoitexe
			$tmp = StringTrimRight($tmp, StringLen($tmp) - StringInStr($tmp, "\", 0, -1))
			$path = FileGetShortName($tmp) & "Include\" & $file
			If FileExists($path) Then
				Sleep(300) ;Ohne sleep wird das Fenster komisch verstümmelt..warum auch immer
				Try_to_opten_file($path)
				Return
			EndIf
		EndIf


		;Prüfe ob die Datei in den Benutzerdefinierten Includepfaden existiert
		$Pfade = _Config_Read("additional_includes_paths", "")
		$Pfade_Array = StringSplit($Pfade, "|", 2)
		If IsArray($Pfade_Array) Then
			For $x = 0 To UBound($Pfade_Array) - 1
				$Pfad = _ISN_Variablen_aufloesen($Pfade_Array[$x])
				If FileExists(FileGetShortName($Pfad) & "\" & $file) Then
					Sleep(300) ;Ohne sleep wird das Fenster komisch verstümmelt..warum auch immer
					Try_to_opten_file($Pfad & "\" & $file)
					Return
				EndIf
			Next
		EndIf








		;Prüfe ob die Datei selbst existiert
		If FileExists($file) Then
			Sleep(300) ;Ohne sleep wird das Fenster komisch verstümmelt..warum auch immer
			Try_to_opten_file($file)
			Return
		EndIf



		Return ;or crash
	EndIf
;~ 	Else
	;Datei
;~ 	$array = _StringBetween($linestring, '"', '"', -1)
;~ 	for $u = 0 to ubound($array)-1
;~ 		if FileExists($array[$u]) then
;~ 			Try_to_opten_file($array[$u])
;~ 			return ;open only 1 FileChangeDir
;~ 		endif
;~ 	next

;~ 	$array = _StringBetween($linestring, "'", "'", -1)
;~ 	for $u = 0 to ubound($array)-1
;~ 		if FileExists($array[$u]) then
;~ 			Try_to_opten_file($array[$u])
;~ 			return ;open only 1 FileChangeDir
;~ 		endif
;~ 	next
;~
;~ 	endif
EndFunc   ;==>_Try_to_open_include

; #FUNCTION# ;===============================================================================
; Name...........: _Debug_to_msgbox
; Description ...: Erstellt eine MsgBox im Script mit dem Ergebniss der gewählten Zeile (wie in SCiTE4AutoIt)
; Syntax.........: _Debug_to_msgbox()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: In der gewählten Zeile muss Text vorhanden sein!
; Related .......:
; Link ..........: http://www.isnetwork.at.pn
; Example .......: No
; ;==========================================================================================

Func _Debug_to_msgbox()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	Local $Fertiger_String = ""
	Local $Text_der_Zeile = ""
	Local $word = ""
	Local $Ist_nach_istgleich = "none"
	$Aktuelle_pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
	$Pos_Istgleich_zeichen = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1) + (StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1), "="))

	If $Text_der_Zeile = "" Or $Text_der_Zeile = @CRLF Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(726), 0, $studiofenster)
		Return
	EndIf

	;Analyse...
	If $Aktuelle_pos > $Pos_Istgleich_zeichen - 1 Then
		$Ist_nach_istgleich = "true"
	Else
		$Ist_nach_istgleich = "false"
	EndIf
	If Not StringInStr($Text_der_Zeile, "=") Then $Ist_nach_istgleich = "none"

	$Text_der_Zeile = StringReplace($Text_der_Zeile, @CRLF, "") ;Lösche Zeilenumbrüche
	If StringInStr($Text_der_Zeile, ";") Then $Text_der_Zeile = StringTrimRight($Text_der_Zeile, StringLen($Text_der_Zeile) - StringInStr($Text_der_Zeile, ";", -1) + 1) ;Lösche Kommentare

	If $Ist_nach_istgleich = "false" Then
		$word = SCI_GetWordFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]))
		If $word = "" Then
			Return
		EndIf
		If StringInStr($word, "(") Then
			$word = StringTrimRight($word, StringLen($word) - StringInStr($word, "(") + 1)
		EndIf
		;Letzte Prüfung
		If StringInStr($Text_der_Zeile, "$" & $word) Then $word = "$" & $word
		$Text_der_Zeile = $word
	EndIf

	If $Ist_nach_istgleich = "true" Then
		$Text_der_Zeile = StringTrimLeft($Text_der_Zeile, StringInStr($Text_der_Zeile, "=", -1) + 1)
	EndIf

	;Makierung
	$Result = Sci_GetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	If IsArray($Result) Then
		If $Result[0] <> $Result[1] Then $Text_der_Zeile = SCI_GetTextRange($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Result[0], $Result[1])
	EndIf

	$Text_der_Zeile = StringStripWS($Text_der_Zeile, 3)
	$Fertiger_String = "MsgBox(262144,'Debug line ~' & @ScriptLineNumber,'Selection:' & @lf & '" & $Text_der_Zeile & "' & @lf & @lf & 'Return:' & @lf &" & $Text_der_Zeile & ") ;### Debug MSGBOX" & @CRLF
	;Sende Text in den Editor
	Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Fertiger_String, Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) + 1)
	_Check_Buttons(0)
EndFunc   ;==>_Debug_to_msgbox

; #FUNCTION# ;===============================================================================
; Name...........: _Debug_to_console
; Description ...: Erstellt einen ConsoleWrite Befehl im Script mit dem Ergebniss der gewählten Zeile (wie in SCiTE4AutoIt)
; Syntax.........: _Debug_to_console()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: In der gewählten Zeile muss Text vorhanden sein!
; Related .......:
; Link ..........: http://www.isnetwork.at.pn
; Example .......: No
; ;==========================================================================================

Func _Debug_to_console()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	Local $Fertiger_String = ""
	Local $Text_der_Zeile = ""
	Local $word = ""
	Local $Ist_nach_istgleich = "none"
	$Aktuelle_pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
	$Pos_Istgleich_zeichen = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1) + (StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1), "="))

	If $Text_der_Zeile = "" Or $Text_der_Zeile = @CRLF Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(726), 0, $studiofenster)
		Return
	EndIf

	;Analyse...
	If $Aktuelle_pos > $Pos_Istgleich_zeichen - 1 Then
		$Ist_nach_istgleich = "true"
	Else
		$Ist_nach_istgleich = "false"
	EndIf
	If Not StringInStr($Text_der_Zeile, "=") Then $Ist_nach_istgleich = "none"

	$Text_der_Zeile = StringReplace($Text_der_Zeile, @CRLF, "") ;Lösche Zeilenumbrüche
	If StringInStr($Text_der_Zeile, ";") Then $Text_der_Zeile = StringTrimRight($Text_der_Zeile, StringLen($Text_der_Zeile) - StringInStr($Text_der_Zeile, ";", -1) + 1) ;Lösche Kommentare

	If $Ist_nach_istgleich = "false" Then
		$word = SCI_GetWordFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]))
		If $word = "" Then
			Return
		EndIf
		If StringInStr($word, "(") Then
			$word = StringTrimRight($word, StringLen($word) - StringInStr($word, "(") + 1)
		EndIf
		;Letzte Prüfung
		If StringInStr($Text_der_Zeile, "$" & $word) Then $word = "$" & $word
		$Text_der_Zeile = $word
	EndIf

	If $Ist_nach_istgleich = "true" Then
		$Text_der_Zeile = StringTrimLeft($Text_der_Zeile, StringInStr($Text_der_Zeile, "=", -1) + 1)
	EndIf

	;Makierung
	$Result = Sci_GetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	If IsArray($Result) Then
		If $Result[0] <> $Result[1] Then $Text_der_Zeile = SCI_GetTextRange($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Result[0], $Result[1])
	EndIf

	$Text_der_Zeile = StringStripWS($Text_der_Zeile, 3)

	$Fertiger_String = "ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : " & $Text_der_Zeile & " = ' & " & $Text_der_Zeile & " & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console" & @CRLF

	;Sende Text in den Editor
	Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Fertiger_String, Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) + 1)
	_Check_Buttons(0)
EndFunc   ;==>_Debug_to_console

Func _check_if_file_was_modified_external()
	If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return
	If $protect_files_from_external_modification = "false" Then Return
	If _GUICtrlTab_GetItemCount($htab) < 1 Then Return
	If $Tabs_closing = 1 Then Return
	If $Offenes_Projekt = "" Then Return
	$ext = StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 1, -1))
	If $ext = $Autoitextension Or $ext = "isn" Or $ext = "ini" Or $ext = "txt" Then
		Local $hFile = FileOpen($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], $FO_READ + FileGetEncoding($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)]))
		Local $new = FileRead($hFile, FileGetSize($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)]))
		FileClose($hFile)
		If $FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] = "" Then Return
		If $new = "" Then Return

		$lokaler_cache = $FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)]
		If Not _System_benoetigt_double_byte_character_Support() Then $lokaler_cache = _ANSI2UNICODE($lokaler_cache)

		If $lokaler_cache <> $new Then ;oje, do hods wos..
			$str = _Get_langstr(548)
			$str = StringReplace($str, "%filename%", StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], "\", 0, -1)))
			$answer = MsgBox(262144 + 48 + 4, _Get_langstr(394), $str, 0, $Studiofenster)
			If $answer = 6 Then
				LoadEditorFile($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)])
				$FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)] = Sci_GetLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
				_Show_Tab(_GUICtrlTab_GetCurFocus($htab))
			EndIf
			If $answer = 7 Then
				_try_to_save_file(_GUICtrlTab_GetCurFocus($htab), 0)
			EndIf

		EndIf
	EndIf
EndFunc   ;==>_check_if_file_was_modified_external

Func _FileReadToArray2($sFilePath, ByRef $aArray)
	Local $hFile = FileOpen($sFilePath, $FO_READ + FileGetEncoding($sFilePath))
	If $hFile = -1 Then Return SetError(1, 0, 0) ;; unable to open the file
	;; Read the file and remove any trailing white spaces
	Local $aFile = FileRead($hFile, FileGetSize($sFilePath))
;~ 	$aFile = StringStripWS($aFile, 2)
	; remove last line separator if any at the end of the file
;~ 	If StringRight($aFile, 1) = @LF Then $aFile = StringTrimRight($aFile, 1)
;~ 	If StringRight($aFile, 1) = @CR Then $aFile = StringTrimRight($aFile, 1)
	FileClose($hFile)
	If StringInStr($aFile, @LF) Then
		$aArray = StringSplit(StringStripCR($aFile), @LF)
	ElseIf StringInStr($aFile, @CR) Then ;; @LF does not exist so split on the @CR
		$aArray = StringSplit($aFile, @CR)
	Else ;; unable to split the file
		If StringLen($aFile) Then
			Dim $aArray[2] = [1, $aFile]
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_FileReadToArray2

Func _SCI_Toggle_fold()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	For $count = 0 To Sci_GetLineCount($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1
		If BitAND(SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETFOLDLEVEL, $count, 0), $SC_FOLDLEVELHEADERFLAG) Then
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_TOGGLEFOLD, $count, 1)
		EndIf
	Next
EndFunc   ;==>_SCI_Toggle_fold


Func _Save_All_only_script_tabs()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	GUISetCursor(1, 0, $Studiofenster)
	$Rebuild_Tree = 0
	$Can_open_new_tab = 0
	For $x = 0 To $Offene_tabs - 1
		If $Plugin_Handle[$x] = -1 Then
			$Rebuild_Tree = 0
			If $x = _GUICtrlTab_GetCurFocus($htab) Then $Rebuild_Tree = 1
			$ext = StringTrimLeft($Datei_pfad[$x], StringInStr($Datei_pfad[$x], ".", 1, -1))
			If $ext = $Autoitextension Then
				If Not BitAND(_GUICtrlTab_GetItemState($htab, $x), $TCIS_HIGHLIGHTED) Then ContinueLoop ;Nur Speichern wenn in der Datei auch was geändert wurde (Neu seit version 1.03)
				Save_File($x, $Rebuild_Tree) ;Nur bei au3 Datien Speichern
				_Remove_Marks($SCE_EDITOR[$x])
			EndIf
		Else
			;Plugin
		EndIf
	Next
	_run_rule($Section_Trigger3)
	GUISetCursor(2, 0, $Studiofenster)
	$Can_open_new_tab = 1
EndFunc   ;==>_Save_All_only_script_tabs


Func _Save_All_tabs($Nur_Skript_Tabs_Speichern = 0)
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	_GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_INDETERMINATE)
	_GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_INDETERMINATE)
	GUICtrlSetState($FileMenu_item1, $GUI_DISABLE)
	GUICtrlSetState($FileMenu_item1b, $GUI_DISABLE)
	GUISetCursor(1, 0, $Studiofenster)
	$Rebuild_Tree = 0
	$Can_open_new_tab = 0
	For $x = 0 To $Offene_tabs - 1
		If $Plugin_Handle[$x] = -1 Then
			$Rebuild_Tree = 0
			If $x = _GUICtrlTab_GetCurFocus($htab) Then $Rebuild_Tree = 1
			Save_File($x, $Rebuild_Tree) ;script
			_Remove_Marks($SCE_EDITOR[$x])
		Else
			If $Nur_Skript_Tabs_Speichern = 1 Then ContinueLoop
			_ISN_Send_Message_to_Plugin($Plugin_Handle[$x], "save") ;plugin
;~ ControlSend (_WinAPI_GetWindowText($Plugin_Handle[$x]), "", "", "^s")  ;Sende STRG+S an jedes Plugin
			_Write_log(StringTrimLeft($Datei_pfad[$x], StringInStr($Datei_pfad[$x], "\", 0, -1)) & " " & _Get_langstr(691), "209B25")
		EndIf
	Next

	_run_rule($Section_Trigger3)
	GUISetCursor(2, 0, $Studiofenster)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		_GUICtrlToolbar_SetButtonState($hToolbar, $id29, $TBSTATE_ENABLED)
		_GUICtrlToolbar_SetButtonState($hToolbar, $id10, $TBSTATE_ENABLED)
		GUICtrlSetState($FileMenu_item1, $GUI_ENABLE)
		GUICtrlSetState($FileMenu_item1b, $GUI_ENABLE)
	EndIf
	$Can_open_new_tab = 1
EndFunc   ;==>_Save_All_tabs

Func _Zeile_Duplizieren()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If $Offenes_Projekt = "" Then Return
	Local $Text_der_Zeile = ""
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)
	;Sende Text in den Editor
	Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Text_der_Zeile, Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) + 1)
	_Check_Buttons(0)
EndFunc   ;==>_Zeile_Duplizieren

Func _Zeile_Bookmarken()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return


	Local $firstline = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSELECTIONSTART, 0, 0), 0)
	Local $lastlineline = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSELECTIONEND, 0, 0), 0)
	Local $count = 0

	For $line = $firstline To $lastlineline
		;Bookmarks mit der Marker ID 5
		If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERGET, $line, 0) = 0 Then
			;Marker setzen
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERADD, $line, 5)
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERDEFINE, 5, $SC_MARK_CIRCLE)
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERSETFORE, 5, _RGB_to_BGR(0x3A90E8))
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERSETBACK, 5, _RGB_to_BGR(0x3A90E8))
		Else
			;Marker entfernen
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERDELETE, $line, 5)
		EndIf
		$count = $count + 1
		If $count > 49 Then ExitLoop ;Max 50 Zeilen, danach abbruch!
	Next

EndFunc   ;==>_Zeile_Bookmarken

Func _Alle_Bookmarks_entfernen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERDELETEALL, -1, 0)
EndFunc   ;==>_Alle_Bookmarks_entfernen

Func _Springe_zum_naechsten_Bookmarks()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	$startline = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), 0)
	$Next_Bookmark_line = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERNEXT, $startline + 1, 32)
	If $Next_Bookmark_line = -1 Then ;Try "warp around"
		$Next_Bookmark_line = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERNEXT, 1, 32)
		If $Next_Bookmark_line = -1 Then Return
	EndIf
	GoToLine($Next_Bookmark_line)
EndFunc   ;==>_Springe_zum_naechsten_Bookmarks

Func _Springe_zur_vorherigen_Bookmarks()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	$startline = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_LINEFROMPOSITION, Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), 0)
	$Prev_Bookmark_line = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERPREVIOUS, $startline - 1, 32)
	If $Prev_Bookmark_line = -1 Then ;Try "warp around"
		$Prev_Bookmark_line = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MARKERPREVIOUS, Sci_GetLineCount($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), 32)
		If $Prev_Bookmark_line = -1 Then Return
	EndIf
	GoToLine($Prev_Bookmark_line)
EndFunc   ;==>_Springe_zur_vorherigen_Bookmarks

Func _SCI_Kommentare_ausblenden_bzw_einblenden()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return

	If SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_STYLEGETVISIBLE, $SCE_AU3_COMMENT, 0) = 1 Then
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_STYLESETVISIBLE, $SCE_AU3_COMMENT, 0)
	Else
		SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_STYLESETVISIBLE, $SCE_AU3_COMMENT, 1)
	EndIf

EndFunc   ;==>_SCI_Kommentare_ausblenden_bzw_einblenden


Func _Markierte_Zeile_nach_oben_verschieben()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If $Offenes_Projekt = "" Then Return
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MOVESELECTEDLINESUP, 0, 0)
EndFunc   ;==>_Markierte_Zeile_nach_oben_verschieben

Func _Markierte_Zeile_nach_unten_verschieben()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If $Offenes_Projekt = "" Then Return
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_MOVESELECTEDLINESDOWN, 0, 0)
EndFunc   ;==>_Markierte_Zeile_nach_unten_verschieben

; #FUNCTION# ;===============================================================================
; Name...........: _Erstelle_UDF_Header
; Description ...: Erstellt einen UDF HEader im Script über der gewählten Funktion (wie in SCiTE4AutoIt)
; Syntax.........: _Erstelle_UDF_Header()
; Parameters ....: None
; Return values .: None
; Author ........: ISI360
; Modified.......:
; Remarks .......: In der gewählten Zeile muss Text vorhanden sein!
; Related .......:
; Link ..........: http://www.isnetwork.at.pn
; Example .......: No
; ==========================================================================================

Func _Erstelle_UDF_Header()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_UDFHeadererstellen) <> -1 Then Return ;Platzhalter für Plugin
	Local $Fertiger_String = ""
	Local $Text_der_Zeile = ""
	Local $funcname = ""
	Local $Parameters_to_list = ""
	Local $funcname_Parameters = ""
	Local $Description = ""
	Local $temp = ""
	Local $spaces = ""
	Local $x = 0
	Local $y = 0
	Local $str
	Local $optional_count = 0
	Local $temp_array
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)

	If $Text_der_Zeile = "" Or $Text_der_Zeile = @CRLF Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(726), 0, $studiofenster)
		Return
	EndIf

	If Not StringInStr($Text_der_Zeile, "func ") Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(731), 0, $studiofenster)
		Return
	EndIf

	;Func Name
	$temp = _StringBetween($Text_der_Zeile, "func ", "(")
	If IsArray($temp) Then $funcname = $temp[0]
	$temp = _StringBetween($Text_der_Zeile, "(", ")")
	If IsArray($temp) Then $funcname_Parameters = $temp[0]

	;Optionale Parameter
	If $funcname_Parameters <> "" Then
		$temp_array = StringSplit($funcname_Parameters, ",", 2)
		If IsArray($temp_array) Then
			$funcname_Parameters = ""
			$optional_count = 0
			For $x = 0 To UBound($temp_array) - 1
				$temp_array[$x] = StringStripWS($temp_array[$x], 3)

				If StringInStr($temp_array[$x], "=") Then ;optional parameter
					$funcname_Parameters = $funcname_Parameters & " [, " & $temp_array[$x]
;~ $funcname_Parameters = $funcname_Parameters&" [, "&StringStripWS (StringTrimRight($temp_array[$x],stringlen($temp_array[$x])-StringInStr($temp_array[$x],"=",0,-1)+1),3)
					$optional_count = $optional_count + 1
				Else
					$funcname_Parameters = $funcname_Parameters & ", " & $temp_array[$x]
				EndIf
			Next
			$str = ""
			For $y = 1 To $optional_count
				$str = $str & "]"
			Next
			$funcname_Parameters = $funcname_Parameters & $str
			If StringTrimRight($funcname_Parameters, StringLen($funcname_Parameters) - 2) = ", " Then $funcname_Parameters = StringTrimLeft($funcname_Parameters, 2)
			$funcname_Parameters = StringStripWS($funcname_Parameters, 3)
		EndIf
	EndIf

	;Parameter auflisten:
	$temp = _StringBetween($Text_der_Zeile, "(", ")")
	If IsArray($temp) Then $Parameters_to_list = $temp[0]
	If $Parameters_to_list <> "" Then
		$temp_array = StringSplit($Parameters_to_list, ",", 2)
		$x = 0
		If IsArray($temp_array) Then

			For $x = 0 To UBound($temp_array) - 1
				$def_value = ""
				If StringInStr($temp_array[$x], "=") Then
					$def_value = StringTrimLeft($temp_array[$x], StringInStr($temp_array[$x], "="))
					$temp_array[$x] = StringTrimRight($temp_array[$x], StringLen($temp_array[$x]) - StringInStr($temp_array[$x], "=", 0, -1) + 1)
				EndIf
				$def_value = StringStripWS($def_value, 3)
				$temp_array[$x] = StringStripWS($temp_array[$x], 3)
				$len1 = StringLen("                     ")
				$len2 = StringLen($temp_array[$x])
				$dif = $len1 - $len2

				;Fülle mit Spaces
				$spaces = ""
				For $y = 1 To $dif
					$spaces = $spaces & " "
				Next

				$type = "An unknown value."
				$gefundener_type = StringTrimRight($temp_array[$x], StringLen($temp_array[$x]) - 2)
				$gefundener_type = StringReplace($gefundener_type, "$", "")
				$gefundener_type = StringLower($gefundener_type)
				Switch $gefundener_type

					Case "a"
						$type = "An array of unknowns."

					Case "h"
						$type = "A handle value."

					Case "t"
						$type = "A dll struct value."

					Case "s"
						$type = "A string value."

					Case "b"
						$type = "A boolean value."

					Case "d"
						$type = "A binary value."

					Case "n"
						$type = "A floating point number value."

					Case "v"
						$type = "A variant value."

					Case "p"
						$type = "A pointer value."

					Case "o"
						$type = "A object value."

					Case "i"
						$type = "A integer value."

					Case "f"
						$type = "A floating point number value."

				EndSwitch

				If StringInStr($temp_array[$x], "id") Then $type = "An AutoIt controlID."
				If StringInStr($temp_array[$x], "tag") Then $type = "Structures definition."

				If $def_value <> "" Then $type = $type & " Default is " & $def_value & "."

				If $def_value <> "" Then
					$temp_array[$x] = $temp_array[$x] & $spaces & "- [optional] " & $type
				Else
					$temp_array[$x] = $temp_array[$x] & $spaces & "- " & $type
				EndIf
			Next

			;Baue fertigen String
			$Parameters_to_list = ""
			For $x = 0 To UBound($temp_array) - 1
				If $x <> UBound($temp_array) - 1 Then
					$Parameters_to_list = $Parameters_to_list & $temp_array[$x] & @CRLF
				Else
					$Parameters_to_list = $Parameters_to_list & $temp_array[$x]
				EndIf
			Next
			$Parameters_to_list = StringReplace($Parameters_to_list, @CRLF, @CRLF & ";                  ") ;Text Einrücken
		EndIf
	EndIf
	If $Parameters_to_list = "" Then $Parameters_to_list = "None"

	$Description = StringReplace(IniRead($Pfad_zur_Project_ISN, $funcname, "comment", ""), "[BREAK]", " ")

	$Fertiger_String = "; #FUNCTION# ====================================================================================================================" & @CRLF & _
			"; Name ..........: " & $funcname & @CRLF & _
			"; Description ...: " & $Description & @CRLF & _
			"; Syntax ........: " & $funcname & "(" & $funcname_Parameters & ")" & @CRLF & _
			"; Parameters ....: " & $Parameters_to_list & @CRLF & _
			"; Return values .: None" & @CRLF & _
			"; Author ........: " & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", "") & @CRLF & _
			"; Modified ......: " & @CRLF & _
			"; Remarks .......: " & @CRLF & _
			"; Related .......: " & @CRLF & _
			"; Link ..........: " & @CRLF & _
			"; Example .......: No" & @CRLF & _
			"; ==============================================================================================================================="
	;Sende Text in den Editor
	If Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) = 1 Then Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], @CRLF, 1)
	Sci_AddLines($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Fertiger_String, Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)

	_Check_Buttons(0)
EndFunc   ;==>_Erstelle_UDF_Header




Func _Springe_zu_Func()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return



	Local $funcname = ""
	$Text_der_Zeile = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) - 1)

	If $Text_der_Zeile = "" Or $Text_der_Zeile = @CRLF Then Return


	$Aktuelles_Wort = SCI_GetCurrentWordEx($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Aktuelles_Wort = StringStripWS($Aktuelles_Wort, 3)
	$Aktuelles_Wort = StringReplace($Aktuelles_Wort, "(", "")
	$Aktuelles_Wort = StringReplace($Aktuelles_Wort, ")", "")

	$Springe_zu_Func_Letzte_Pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	If $Aktuelles_Wort = "" Then Return

	$wrapFind = True
	FindNext("func " & $Aktuelles_Wort & Random(23043), False, False, 0, False) ;mache zufallssuche um wieder von oben zu beginnen ^^
	$wrapFind = True
	$found = FindNext("func " & $Aktuelles_Wort, False, False, 0, False)
	If $found = -1 Then
		$Springe_zu_Func_Letzte_Suche = ""
		$Springe_zu_Func_Letzte_Pos = 0
		MsgBox(262144 + 16, _Get_langstr(25), $Aktuelles_Wort & " " & _Get_langstr(332), 0, $Studiofenster)
	Else
		$Springe_zu_Func_Letzte_Suche = $Aktuelles_Wort
	EndIf
EndFunc   ;==>_Springe_zu_Func

Func _Springe_zu_Func_zurueck()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] <> -1 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return

	If $Springe_zu_Func_Letzte_Suche <> "" Then
		Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Springe_zu_Func_Letzte_Pos)
		$Springe_zu_Func_Letzte_Suche = ""
		$Springe_zu_Func_Letzte_Pos = 0
	EndIf
EndFunc   ;==>_Springe_zu_Func_zurueck

Func _Extracode_Copy_to_Clipboard()
	ClipPut(_ANSI2UNICODE(Sci_GetLines($scintilla_Codeausschnitt)))
EndFunc   ;==>_Extracode_Copy_to_Clipboard

Func _Extracode_Save_AS_Au3()
	_Lock_Plugintabs("lock")
	$i = FileSaveDialog(_Get_langstr(1187), $Offenes_Projekt, "AutoIt Skript (*.au3)", 18, "", $Codeausschnitt_GUI)
	_Lock_Plugintabs("unlock")
	FileChangeDir(@ScriptDir)
	If $i = "" Then Return
	$file_handle = FileOpen($i, 2)
	FileWrite($file_handle, _ANSI2UNICODE(Sci_GetLines($scintilla_Codeausschnitt)))
	FileClose($file_handle)
EndFunc   ;==>_Extracode_Save_AS_Au3

Func _SCI_Zeige_Extracode($Code_String = "", $Extracode_Label = "", $Titel2_Label = "", $flags = 0)

	;GUISetState(@SW_LOCK, $Codeausschnitt_GUI)
	SendMessageString($scintilla_Codeausschnitt, $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessageString($scintilla_Codeausschnitt, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessageString($scintilla_Codeausschnitt, $SCI_SETSAVEPOINT, 0, 0)
	$Code_String = StringReplace($Code_String, "[BREAK]", @CRLF)
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SCI_SetText($scintilla_Codeausschnitt, $Code_String)
    SendMessage($scintilla_Codeausschnitt, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()

	GUICtrlSetState($Codeausschnitt_Code_Save_as_au3_Button, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_Code_Kopieren_Button, $GUI_SHOW)
	Switch $flags

		Case 0
			GUISetState(@SW_DISABLE, $StudioFenster)
			GUICtrlSetState($Codeausschnitt_GUI_bereichlabel, $GUI_HIDE)
			GUICtrlSetState($Codeausschnitt_GUI_Dateilabel, $GUI_HIDE)
			GUICtrlSetState($Codeausschnitt_Abbrechen_Button, $GUI_SHOW)
			GUICtrlSetOnEvent($Codeausschnitt_OK_Button, "_SCI_Extracode_OK")
			GUICtrlSetOnEvent($Codeausschnitt_Abbrechen_Button, "_SCI_Extracode_Abbrechen")
			GUISetOnEvent($GUI_EVENT_CLOSE, "_SCI_Extracode_Abbrechen", $Codeausschnitt_GUI)

		Case 1
			GUICtrlSetState($Codeausschnitt_Abbrechen_Button, $GUI_HIDE)
			GUICtrlSetState($Codeausschnitt_GUI_bereichlabel, $GUI_HIDE)
			GUICtrlSetState($Codeausschnitt_GUI_Dateilabel, $GUI_HIDE)
			GUICtrlSetOnEvent($Codeausschnitt_OK_Button, "_Hide_Codeausschnitt_GUI")
			GUISetOnEvent($GUI_EVENT_CLOSE, "_Hide_Codeausschnitt_GUI", $Codeausschnitt_GUI)



	EndSwitch



	If $Titel2_Label = "" Or $Titel2_Label = " " Then
		GUICtrlSetState($Codeausschnitt_GUI_titel2, $GUI_HIDE)
	Else
		GUICtrlSetState($Codeausschnitt_GUI_titel2, $GUI_SHOW)
	EndIf

	GUICtrlSetData($Codeausschnitt_GUI_titel, $Extracode_Label)
	GUICtrlSetData($Codeausschnitt_GUI_titel2, $Titel2_Label)
	WinSetTitle($Codeausschnitt_GUI, "", $Extracode_Label)
	Codeausschnitt_GUI_Resize()
	;GUISetState(@SW_UNLOCK, $Codeausschnitt_GUI)
	GUISetState(@SW_SHOW, $Codeausschnitt_GUI)

	WinSetOnTop($Codeausschnitt_GUI, "", 1)
	If $flags = 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_DISABLE)
	Return 1
EndFunc   ;==>_SCI_Zeige_Extracode


Func _SCI_Extracode_OK()
	$Text = Sci_GetText($scintilla_Codeausschnitt)
	$Text = StringReplace($Text, Chr(0), "", 0, 1) ;NULL Byte entfernen
	$Text = StringReplace($Text, @CRLF, "[BREAK]")
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "extracodeanswer" & $Plugin_System_Delimiter & $Text)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Codeausschnitt_GUI)
	WinSetOnTop($Codeausschnitt_GUI, "", 0)
EndFunc   ;==>_SCI_Extracode_OK

Func _SCI_Extracode_Abbrechen()
	If _GUICtrlTab_GetItemCount($htab) > 0 Then WinSetState($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "", @SW_ENABLE)
	If _GUICtrlTab_GetItemCount($htab) > 0 Then _ISN_Send_Message_to_Plugin($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)], "extracodeanswer" & $Plugin_System_Delimiter & "#error#")
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Codeausschnitt_GUI)
	WinSetOnTop($Codeausschnitt_GUI, "", 0)
EndFunc   ;==>_SCI_Extracode_Abbrechen

Func _SCI_Zeige_Code_Schnipsel()
	If _GUICtrlTreeView_GetSelection($hTreeview2) = 0 Then Return
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), ".", 1, -1) = 0 Then Return
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(84) Then Return ;Stoppe bei Root von Globalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(416) Then Return ;Stoppe bei Root von Lokalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(83) Then Return ;Stoppe bei Root von Funktionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(433) Then Return ;Stoppe bei Root von Regionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(324) Then Return ;Stoppe bei Root von Includes
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(323) Then Return ;Stoppe bei Root von Forms im Projekt
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(323)) Then Return ;Stoppe bei Subitems von Forms im Projekt
	Dim $szDrive, $szDir, $szFName, $szExt

	$mode = 0
	$str = StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1))
	If StringInStr($str, " {") Then $str = StringTrimRight($str, StringLen($str) - StringInStr($str, " {") + 1) ;Cut Counts
	$str = StringStripWS($str, 3) ;Entferne Leerzeichen am anfang & Ende eines Elements falls vorhanden
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(83)) Then $mode = "func" ;$str = "func "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(433)) Then $mode = "region" ;$str = "#region "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(84)) Then $mode = "global"
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(416)) Then $mode = "local" ;$str = "global "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(324)) Then $mode = "include" ;$str = "global "&$str
	$TestPath = _PathSplit($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], $szDrive, $szDir, $szFName, $szExt)
	If $last_scripttree_jumptosearch <> $str Then
		$begin_from = 0
	Else
		$begin_from = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])))
	EndIf
	$alte_Pos = Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$last_scripttree_jumptosearch = $str
	$found = _search_from_Scripttree($str, $begin_from, $mode)
	If $found = -1 Then $found = _search_from_Scripttree($str, $begin_from, $mode) ;2te Change ;) (komischer bug, but hey it works -.-)
	If $found = -1 Then Return ;falls immer noch nichts gefunden stoppe aktion...

	;markiere ganze Zeile
	$startline = Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]))
	Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $alte_Pos)
	If Not StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $startline), "func", 2) Then Return
	;Hole gesamten Text der Func
	Local $Text = ""
	For $x = $startline To Sci_GetLineCount($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
		$Text = $Text & Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $x)
		If StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $x), "endfunc", 2) Then
			$Text = StringStripWS($Text, 2)
			ExitLoop
		EndIf
	Next
	$Codeausschnitt_Startline = $startline
	$Codeausschnitt_Endline = $x

	SendMessageString($scintilla_Codeausschnitt, $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessageString($scintilla_Codeausschnitt, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessageString($scintilla_Codeausschnitt, $SCI_SETSAVEPOINT, 0, 0)
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	SCI_SetText($scintilla_Codeausschnitt, $Text)
    SendMessage($scintilla_Codeausschnitt, $SCI_COLOURISE, 0, -1)
	_ISN_AutoIt_Studio_activate_GUI_Messages()
	WinSetTitle($Codeausschnitt_GUI, "", _Get_langstr(810))
	GUICtrlSetData($Codeausschnitt_GUI_titel, _Get_langstr(810) & ' "' & $str & '"')
	GUICtrlSetData($Codeausschnitt_GUI_titel2, $szFName & $szExt)
	GUICtrlSetData($Codeausschnitt_GUI_Dateilabel, _Get_langstr(742) & " " & $szDrive & $szDir & $szFName & $szExt)
	GUICtrlSetData($codeausschnitt_Dateipfad, $szDrive & $szDir & $szFName & $szExt)
	GUICtrlSetData($codeausschnitt_Dateipfad, $szDrive & $szDir & $szFName & $szExt)
	GUICtrlSetData($codeausschnitt_vonZEILE, $startline)
	GUICtrlSetData($codeausschnitt_bisZEILE, $x)
	GUICtrlSetState($Codeausschnitt_GUI_titel2, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_GUI_bereichlabel, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_GUI_Dateilabel, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_Code_Save_as_au3_Button, $GUI_HIDE)
	GUICtrlSetState($Codeausschnitt_Abbrechen_Button, $GUI_SHOW)
	GUICtrlSetState($Codeausschnitt_Code_Kopieren_Button, $GUI_HIDE)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Hide_Codeausschnitt_GUI", $Codeausschnitt_GUI)
	GUICtrlSetOnEvent($Codeausschnitt_Abbrechen_Button, "_Hide_Codeausschnitt_GUI")
	GUICtrlSetOnEvent($Codeausschnitt_OK_Button, "_Codeausschnitt_GUI_OK")
	GUICtrlSetData($Codeausschnitt_GUI_bereichlabel, StringReplace(StringReplace(_Get_langstr(925), "%1", $startline + 1), "%2", $x + 1))
	Codeausschnitt_GUI_Resize()
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_SHOW, $Codeausschnitt_GUI)
;~ 	SetSelection($start, $end)


EndFunc   ;==>_SCI_Zeige_Code_Schnipsel



Func _Codeausschnitt_GUI_OK()
	;Markiere Text im "echten" Editor
	Local $start = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Codeausschnitt_Startline)
	Local $end = Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Codeausschnitt_Endline)
	SetSelection($start, $end)
	;Und ersetze es durch neuen
	_ISN_AutoIt_Studio_deactivate_GUI_Messages()
	Sci_ReplaceSel($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetText($scintilla_Codeausschnitt))
	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_COLOURISE, 0, -1) ;Redraw the lexer
	_ISN_AutoIt_Studio_activate_GUI_Messages()
	_Hide_Codeausschnitt_GUI()
	_Check_tabs_for_changes()
EndFunc   ;==>_Codeausschnitt_GUI_OK


Func _Hide_Codeausschnitt_GUI()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Codeausschnitt_GUI)
EndFunc   ;==>_Hide_Codeausschnitt_GUI


Func _Oeffne_alte_Tabs($string = "")
	If $string = "" Then Return
	$Dateien = StringSplit($string, "|", 2)
	If Not IsArray($Dateien) Then Return
	For $x = 0 To UBound($Dateien) - 1
		If FileExists(_ISN_Variablen_aufloesen($Dateien[$x])) Then Try_to_opten_file(_ISN_Variablen_aufloesen($Dateien[$x]))
	Next
EndFunc   ;==>_Oeffne_alte_Tabs


Func _Skripteditor_hole_Inludes($Hauptdatei = "", $Filter = "")
	If $Hauptdatei = "" Then Return
	Dim $textarray
	Local $Includes_Array[1]
	If $Filter <> "" Then
		If StringInStr($Hauptdatei, $Filter) Then _ArrayAdd($Includes_Array, $Hauptdatei)
	Else
		_ArrayAdd($Includes_Array, $Hauptdatei) ;Hauptdatei ist (fast) immer dabei :P
	EndIf

	_FileReadToArray($Hauptdatei, $textarray)
	If Not IsArray($textarray) Then Return
	;includes
	For $i = 0 To UBound($textarray) - 1
		While StringInStr($textarray[$i], "#include")
			If Not StringInStr($textarray[$i], ".") Then ExitLoop
			If StringInStr($textarray[$i], "-once") Then ExitLoop
			$txt = $textarray[$i]
			If StringInStr($txt, ";") Then ;falls auskommentiert
				If StringInStr($txt, ";") < StringInStr($txt, "#include") Then ExitLoop
			EndIf
			If StringInStr($txt, "<") Then $txt = StringTrimLeft($txt, StringInStr($txt, "<") - 1)
			If StringInStr($txt, "'") Then $txt = StringTrimLeft($txt, StringInStr($txt, "'") - 1)
			If StringInStr($txt, '"') Then $txt = StringTrimLeft($txt, StringInStr($txt, '"') - 1)
			If StringInStr($txt, ">") Then $txt = StringTrimRight($txt, StringLen($txt) - StringInStr($txt, ">"))
			If StringInStr($txt, '"') Then $txt = StringTrimRight($txt, StringLen($txt) - StringInStr($txt, '"', 0, -1))
			If StringInStr($txt, "'") Then $txt = StringTrimRight($txt, StringLen($txt) - StringInStr($txt, "'", 0, -1))
			$txt = StringStripWS($txt, 3)
			$txt = StringReplace($txt, '"', "")
			$txt = StringReplace($txt, "'", "")
			$txt = StringReplace($txt, "<", "")
			$txt = StringReplace($txt, ">", "")

			If StringInStr($txt, "(") Then ExitLoop
			If StringInStr($txt, ")") Then ExitLoop
			If StringInStr($txt, '"') Then ExitLoop
			If StringInStr($txt, "'") Then ExitLoop

			If $txt = "" Then ExitLoop
			If $txt = " " Then ExitLoop

			If $Filter <> "" Then
				If Not StringInStr($txt, $Filter) Then ExitLoop
			EndIf
			$txt = $Offenes_Projekt & "\" & $txt
			If Not FileExists($txt) Then ExitLoop ;Dadurch werden automatisch die AutoIt Include ignoriert, da es diese im Projektverzeichnis ja nicht gibt!
			_ArrayAdd($Includes_Array, $txt)
			ExitLoop
		WEnd
	Next
	$Includes_Array[0] = UBound($Includes_Array) - 1
	Return $Includes_Array
EndFunc   ;==>_Skripteditor_hole_Inludes

Func _Neue_Datei_erstellen_ersetze_Variablen($string = "", $Dateiname = "", $Autor = "", $Proejktkommentar = "", $projektname = "")
	If $string = "" Then Return ""

	$string = StringReplace($string, "%projectname%", $projektname)
	$string = StringReplace($string, "%filename%", $Dateiname)
	$string = StringReplace($string, "%autor%", $Autor)
	$string = StringReplace($string, "%projectcomment%", $Proejktkommentar)
	$string = StringReplace($string, "%studioversion%", $Studioversion)
	$string = StringReplace($string, "%autoitversion%", FileGetVersion($autoitexe))
	$string = StringReplace($string, "%hour%", @HOUR)
	$string = StringReplace($string, "%min%", @MIN)
	$string = StringReplace($string, "%sec%", @SEC)
	$string = StringReplace($string, "%mday%", @MDAY)
	$string = StringReplace($string, "%year%", @YEAR)
	$string = StringReplace($string, "%mon%", @MON)
	$string = StringReplace($string, "%osarch%", @OSArch)
	$string = StringReplace($string, "%username%", @UserName)
	If StringInStr($string, "%langstring(") Then
		$Find_Array = _StringBetween($string, "%langstring(", ")%")
		If IsArray($Find_Array) Then
			For $x = 0 To UBound($Find_Array) - 1
				$string = StringReplace($string, "%langstring(" & $Find_Array[$x] & ")%", _Get_langstr($Find_Array[$x]))
			Next
		EndIf
	EndIf

	Return $string
EndFunc   ;==>_Neue_Datei_erstellen_ersetze_Variablen

Func _Hotkey_vorwaerts_suchen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	GUICtrlSetState($rFindDirectionUp, $GUI_UNCHECKED)
	GUICtrlSetState($rFindDirectionDown, $GUI_CHECKED)
	btnFindNextClick()
EndFunc   ;==>_Hotkey_vorwaerts_suchen

Func _Hotkey_Rueckwaerts_suchen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	GUICtrlSetState($rFindDirectionUp, $GUI_CHECKED)
	GUICtrlSetState($rFindDirectionDown, $GUI_UNCHECKED)
	btnFindNextClick()
EndFunc   ;==>_Hotkey_Rueckwaerts_suchen

Func _UDF_Funktionen_aus_Skript_Auslesen_und_zum_Autocomplete_hinzufuegen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return
	$aList = StringRegExp(StringRegExpReplace($FILE_CACHE[_GUICtrlTab_GetCurFocus($htab)], '(?ims)#c[^#]+#c', ''), '(?ims)^\s*Func\s*([^(]*)', 3)
	If Not IsArray($aList) Then Return
	If IsDeclared("SCI_Autocompletelist_backup") Then $SCI_AUTOCLIST = $SCI_Autocompletelist_backup ;Backup wiederherstellen
	For $x = 0 To UBound($aList) - 1
		_Add_item_to_Autocompleteliste($aList[$x])
	Next
	ArraySortUnique($SCI_AUTOCLIST, 0, 1) ;Sortiere Autocomplete List neu
EndFunc   ;==>_UDF_Funktionen_aus_Skript_Auslesen_und_zum_Autocomplete_hinzufuegen

Func _Add_item_to_Autocompleteliste($txt, $Pixmark = "?2")
	If Not IsArray($SCI_AUTOCLIST) Then Return
	_ArrayAdd($SCI_AUTOCLIST, $txt & $Pixmark)
	$SCI_AUTOCLIST[0] = $SCI_AUTOCLIST[0] + 1
EndFunc   ;==>_Add_item_to_Autocompleteliste




Func _Pruefe_Doppelklickwort_im_Skripteditor($Wort = "", $startpos = "-1")
	If $Tools_Parameter_Editor_aktiviert = "false" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $startpos = "-1" Then Return
	If $Wort = "" Then Return
	If StringInStr($Wort, "$") Then Return
	If StringInStr($Wort, "Global") Then Return
	If StringInStr($Wort, "Local") Then Return
	If StringInStr($Wort, "Func") Then Return
	If StringInStr($Wort, "Dim") Then Return
	If StringInStr($Wort, "#include") Then Return

	$Zeile_NR = Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $startpos)
	$Zeile_Text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Zeile_NR)
	$Zeile_Multibyte_Dif = BinaryLen(StringToBinary($Zeile_Text)) - StringLen($Zeile_Text)
	$Text_Ab_Wort = StringTrimLeft($Zeile_Text, $startpos - Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Zeile_NR))
	$Edit_Startpos = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Zeile_NR) + ($startpos - Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Zeile_NR))
	$Text_Ab_Wort = StringReplace($Text_Ab_Wort, @CRLF, "")
	$Text_Ab_Wort = StringReplace($Text_Ab_Wort, @LF, "")


	$Durch_Klammer_Geoeffnet = 0
	$Durch_Klammer_Geschlossen = 0
	$Edit_Endpos = 0

	For $x = 1 To StringLen($Text_Ab_Wort)
		$style = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSTYLEAT, $startpos + ($x - 1), 0)
		If $style = $SCE_AU3_COMMENT Or $style = $SCE_AU3_COMMENTBLOCK Then Return ;Bereits bei einem Kommentar


		If StringMid($Text_Ab_Wort, $x, 1) = "(" Then $Durch_Klammer_Geoeffnet = $Durch_Klammer_Geoeffnet + 1
		If StringMid($Text_Ab_Wort, $x, 1) = ")" Then $Durch_Klammer_Geschlossen = $Durch_Klammer_Geschlossen + 1
		If $Durch_Klammer_Geoeffnet = 0 Then ContinueLoop
		If $Durch_Klammer_Geoeffnet = $Durch_Klammer_Geschlossen Then
			$Edit_Endpos = $Edit_Startpos + $x + $Zeile_Multibyte_Dif
			ExitLoop
		EndIf
	Next






	If $Durch_Klammer_Geoeffnet = 0 Then Return
	If $Durch_Klammer_Geschlossen = 0 Then Return

	$Parameter_Editor_Startpos = $Edit_Startpos
	$Parameter_Editor_Endpos = $Edit_Endpos

	If $Parameter_SCE_HANDLE <> "" Then SendMessage($Parameter_SCE_HANDLE, $SCI_SETREADONLY, False, 0)
	$Parameter_SCE_HANDLE = $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]

	If $autoit_editor_encoding = "2" Then
		_Zeige_Parameter_Editor(_ANSI2UNICODE($Wort), _ANSI2UNICODE(SCI_GetTextRange($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Edit_Startpos, $Edit_Endpos)))
	Else
		_Zeige_Parameter_Editor($Wort, SCI_GetTextRange($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Edit_Startpos, $Edit_Endpos))
	EndIf

EndFunc   ;==>_Pruefe_Doppelklickwort_im_Skripteditor


Func _Zeige_Parameter_Editor($funcname = "", $ParameterString = "", $Nur_Kommaanzahl_zurueckgeben = 0)
	If $Tools_Parameter_Editor_aktiviert = "false" Then Return
	If $funcname = "" Then Return

	If $ParameterString = "" Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1042), 0, $Studiofenster)
		Return
	EndIf

	$Parameter_Editor_Laedt_gerade_text = 0
	Local $Calltip_Parameter_Array
	Local $sString = ""
	Local $SCI_sCallTip = _Get_langstr(1038)
	Local $Handle_fuer_listview
	$SCI_Calltipp = ArraySearchAll($SCI_sCallTip_Array, $funcname, 0, 0, 1)
	If IsArray($SCI_Calltipp) Then
		$SCI_sCallTip = $SCI_sCallTip_Array[$SCI_Calltipp[0]]
		$SCI_sCallTip = StringReplace(StringRegExpReplace(StringReplace($SCI_sCallTip, ")", ")" & @LF, 1), "(.{70,110} )", "$1" & @LF), @LF & @LF, @LF)
	EndIf

	If $Nur_Kommaanzahl_zurueckgeben = 0 Then
		$Handle_fuer_listview = $ParameterEditor_ListView
	Else
		$Handle_fuer_listview = $ParameterEditor_ListView_buffer
	EndIf


	;Parameter in Listview eintragen
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Handle_fuer_listview))


	;Parameterbeschreibung aus Calltip
	If $SCI_sCallTip <> "" And $SCI_sCallTip <> _Get_langstr(1038) Then
		$sString = StringTrimLeft($SCI_sCallTip, StringInStr($SCI_sCallTip, "("))
		$sString = StringTrimRight($sString, StringLen($sString) - (StringInStr($sString, ")", 0, 1) - 1))
		$sString = StringReplace($sString, "[", "")
		$sString = StringReplace($sString, "]", "")
		$sString = StringReplace($sString, '"', "")
		$Calltip_Parameter_Array = StringSplit($sString, ",", 2)
		If IsArray($Calltip_Parameter_Array) Then
			For $c = 0 To UBound($Calltip_Parameter_Array) - 1
				$ItemText = $Calltip_Parameter_Array[$c]
				If StringInStr($ItemText, "=") Then $ItemText = StringTrimRight($ItemText, StringLen($ItemText) - (StringInStr($ItemText, "=") - 1))
				_GUICtrlListView_AddItem($Handle_fuer_listview, StringStripWS($ItemText, 3))
			Next
		EndIf
	EndIf


	$ParameterString = StringStripWS($ParameterString, 3)
	$ParameterString = StringTrimLeft($ParameterString, 1)
	$ParameterString = StringTrimRight($ParameterString, 1)
	$Readen_Parameter_String = $ParameterString
	$Listview_Row = 0
	$durchlauf = 0
	$Parastring = ""
	$Klammer_auf = 0
	$Klammeraufcount = 0
	$Klammerzucount = 0

	;Parameterstring vorbereiten
	$array = _StringBetween($Readen_Parameter_String, '"', '"', 1)
	If IsArray($array) Then
		For $d = 0 To UBound($array) - 1
			If StringInStr($array[$d], ",") Then $Readen_Parameter_String = StringReplace($Readen_Parameter_String, $array[$d], StringReplace($array[$d], ",", "[COMMA]"))
		Next
	EndIf

	$array = _StringBetween($Readen_Parameter_String, "'", "'", 1)
	If IsArray($array) Then
		For $d = 0 To UBound($array) - 1
			If StringInStr($array[$d], ",") Then $Readen_Parameter_String = StringReplace($Readen_Parameter_String, $array[$d], StringReplace($array[$d], ",", "[COMMA]"))
		Next
	EndIf


	$Split_Array = StringSplit($Readen_Parameter_String, ",", 2)
	If IsArray($Split_Array) Then
		;Bastle Parameterarray

		For $durchlauf = 0 To UBound($Split_Array) - 1


			If StringInStr($Split_Array[$durchlauf], "(") Then
				StringReplace($Split_Array[$durchlauf], "(", "")
				$Klammeraufcount = @extended
				$Klammer_auf = $Klammer_auf + $Klammeraufcount
			EndIf

			If $Klammer_auf = 0 Then
				If _GUICtrlListView_GetItemCount($Handle_fuer_listview) < $Listview_Row + 1 Then _GUICtrlListView_AddItem($Handle_fuer_listview, _Get_langstr(1041) & " " & $Listview_Row + 1)
				_GUICtrlListView_AddSubItem($Handle_fuer_listview, $Listview_Row, StringStripWS(StringReplace($Split_Array[$durchlauf], "[COMMA]", ","), 3), 1)
				$Listview_Row = $Listview_Row + 1
			Else

				If StringInStr($Split_Array[$durchlauf], ")") Then
					StringReplace($Split_Array[$durchlauf], ")", "")
					$Klammerzucount = @extended
					$Klammer_auf = $Klammer_auf - $Klammerzucount
					If $Klammer_auf = 0 Then
						$Parastring = $Parastring & StringStripWS($Split_Array[$durchlauf], 3)
					Else
						$Parastring = $Parastring & StringStripWS($Split_Array[$durchlauf], 3) & ", "
					EndIf
					If $Klammer_auf = 0 Then
						If _GUICtrlListView_GetItemCount($Handle_fuer_listview) < $Listview_Row + 1 Then _GUICtrlListView_AddItem($Handle_fuer_listview, _Get_langstr(1041) & " " & $Listview_Row + 1)
						_GUICtrlListView_AddSubItem($Handle_fuer_listview, $Listview_Row, StringStripWS(StringReplace($Parastring, "[COMMA]", ","), 3), 1)
						$Listview_Row = $Listview_Row + 1
						$Parastring = ""
					EndIf
				Else
					$Parastring = $Parastring & StringStripWS($Split_Array[$durchlauf], 3) & ", "
				EndIf

			EndIf
		Next

	EndIf

	;Für den Editor
	If $Nur_Kommaanzahl_zurueckgeben = 1 Then

		Local $Parameter_Listview_als_Array = _GUICtrlListView_CreateArray($Handle_fuer_listview)
		Local $String_fuer_rueckgabe = ""
		If IsArray($Parameter_Listview_als_Array) Then
			For $cnt = 0 To UBound($Parameter_Listview_als_Array) - 1
				$String_fuer_rueckgabe = $String_fuer_rueckgabe & StringReplace($Parameter_Listview_als_Array[$cnt][1], ",", "##") & ","
				If StringInStr($Parameter_Listview_als_Array[$cnt][1], "#-cursor-#") Then ExitLoop ;Loop wird über den cursor hinaus gehen...abbruch!
			Next
		EndIf
		If StringRight($String_fuer_rueckgabe, 1) = "," Then $String_fuer_rueckgabe = StringTrimRight($String_fuer_rueckgabe, 1)
		StringReplace($String_fuer_rueckgabe, ",", "")
		Return @extended
	EndIf


	;Prüfe ob Array korrekt erstellt wurde
	If $Klammer_auf <> 0 Then
		;Syntaxfehler
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1042), 0, $Studiofenster)
		Return
	EndIf

	Sci_DelLines($ParameterEditor_SCIEditor)

	GUICtrlSetData($ParameterEditor_ParameterTitel, $funcname)
	GUICtrlSetData($ParameterEditor_CallTipp_Label, $SCI_sCallTip)
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
	If _GUICtrlListView_GetItemCount($Handle_fuer_listview) <> 0 Then
		_GUICtrlListView_SetItemSelected($Handle_fuer_listview, 0, True, True)
		_GUICtrlListView_SetSelectionMark($Handle_fuer_listview, 0)
		_Parameter_Editor_Listview_select_row()
	EndIf




	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_Parametereditor) <> -1 Then Return ;Platzhalter für Plugin. Falls Plugin mit -1 beendet wird, wird die ausführung hier gestoppt.



	;Setze Scintilla auf ReadOnly (Damit Coursorpositionen gleich bleiben)
	SendMessage($Parameter_SCE_HANDLE, $SCI_SETREADONLY, True, 0)

	_Parametereditor_Fenster_anpassen()
	GUISetState(@SW_SHOW, $ParameterEditor_GUI)
EndFunc   ;==>_Zeige_Parameter_Editor

Func _Hide_Parameter_Editor()
	;Scintilla wieder aktivieren
	If $Parameter_SCE_HANDLE <> "" Then SendMessage($Parameter_SCE_HANDLE, $SCI_SETREADONLY, False, 0)
	$Parameter_SCE_HANDLE = ""
	GUISetState(@SW_HIDE, $ParameterEditor_GUI)
EndFunc   ;==>_Hide_Parameter_Editor


Func _Parameter_Editor_Listview_select_row()
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) = -1 Then Return
	$Parameter_Editor_Laedt_gerade_text = 1
	Sci_DelLines($ParameterEditor_SCIEditor)
	If $autoit_editor_encoding = "2" Then
		SCI_SetText($ParameterEditor_SCIEditor, _UNICODE2ANSI(_GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 1)))
	Else
		SCI_SetText($ParameterEditor_SCIEditor, _GUICtrlListView_GetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), 1))
	EndIf
	_WinAPI_SetFocus($ParameterEditor_SCIEditor)
	Sci_SetCurrentPos($ParameterEditor_SCIEditor, SCI_GetTextLen($ParameterEditor_SCIEditor))
	$Parameter_Editor_Laedt_gerade_text = 0
EndFunc   ;==>_Parameter_Editor_Listview_select_row

Func _Parameter_Editor_Listview_select_nextrow()
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) = -1 Then Return
	$Current_Row = _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView)
	$Next_Row = $Current_Row + 1
	If $Next_Row > _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1 Then $Next_Row = 0 ;Von vorne beginnen
	_GUICtrlListView_SetItemSelected($ParameterEditor_ListView, $Next_Row, True, True)
	_GUICtrlListView_SetSelectionMark($ParameterEditor_ListView, $Next_Row)
	_GUICtrlListView_EnsureVisible($ParameterEditor_ListView, $Next_Row)
	_Parameter_Editor_Listview_select_row()
EndFunc   ;==>_Parameter_Editor_Listview_select_nextrow



Func _Parameter_Editor_Vorschaulabel_ist_nach_leerem_Parameter_etwas_vorhanden($listview = "", $start = 0)
	For $x = $start To _GUICtrlListView_GetItemCount($listview) - 1
		If _GUICtrlListView_GetItemText($listview, $x, 1) <> "" Then Return True
	Next
	Return False
EndFunc   ;==>_Parameter_Editor_Vorschaulabel_ist_nach_leerem_Parameter_etwas_vorhanden


Func _Parameter_Editor_Aktualisiere_Vorschaulabel()
	AdlibUnRegister("_Parameter_Editor_Aktualisiere_Vorschaulabel")
	$Fertige_Parameter = ""
	For $x = 0 To _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1
		$Befehl = _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x, 1)
		If $Befehl = "" Then
			If _Parameter_Editor_Vorschaulabel_ist_nach_leerem_Parameter_etwas_vorhanden($ParameterEditor_ListView, $x) Then
				$Fertige_Parameter = $Fertige_Parameter & "-1" & ", "
				ContinueLoop
			Else
				ContinueLoop
			EndIf
		EndIf

		$Fertige_Parameter = $Fertige_Parameter & $Befehl & ", "
	Next
	If StringRight($Fertige_Parameter, 2) = ", " Then $Fertige_Parameter = StringTrimRight($Fertige_Parameter, 2)
	$Fertige_Parameter = StringReplace($Fertige_Parameter, "&", "&&")
;~ $Fertige_Parameter = StringReplace($Fertige_Parameter,@crlf,"")
;~ $Fertige_Parameter = StringReplace($Fertige_Parameter,@lf,"")
;~ $Fertige_Parameter = StringReplace($Fertige_Parameter,@cr,"")
	GUICtrlSetData($ParameterEditor_Vorschau_Fertiger_Befehl_Label, GUICtrlRead($ParameterEditor_ParameterTitel) & "(" & $Fertige_Parameter & ")")
EndFunc   ;==>_Parameter_Editor_Aktualisiere_Vorschaulabel

Func _Parameter_Editor_Parameter_hinzufuegen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlListView_GetItemCount($ParameterEditor_ListView) > 49 Then Return ;Max 50 Parameter
	_GUICtrlListView_AddItem($ParameterEditor_ListView, _Get_langstr(1041) & " " & _GUICtrlListView_GetItemCount($ParameterEditor_ListView) + 1)
	_GUICtrlListView_SetItemSelected($ParameterEditor_ListView, _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1, True, True)
	_GUICtrlListView_SetSelectionMark($ParameterEditor_ListView, _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1)
	_GUICtrlListView_EnsureVisible($ParameterEditor_ListView, _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1)
	_Parameter_Editor_Listview_select_row()
EndFunc   ;==>_Parameter_Editor_Parameter_hinzufuegen

Func _Parameter_Editor_Markierten_Parameter_leeren()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) = -1 Then Return
	_GUICtrlListView_SetItemText($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), "", 1)
	SCI_SetText($ParameterEditor_SCIEditor, "")
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
EndFunc   ;==>_Parameter_Editor_Markierten_Parameter_leeren

Func _Parameter_Editor_Parameter_entfernen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView) = -1 Then Return
	_GUICtrlListView_DeleteItem($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView))
	_GUICtrlListView_SetItemSelected($ParameterEditor_ListView, _GUICtrlListView_GetSelectionMark($ParameterEditor_ListView), True, True)
	_Parameter_Editor_Listview_select_row()
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
EndFunc   ;==>_Parameter_Editor_Parameter_entfernen

Func _Parameter_Editor_Alle_Parameter_leeren()
	If $Offenes_Projekt = "" Then Return
	For $x = 0 To _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1
		_GUICtrlListView_SetItemText($ParameterEditor_ListView, $x, "", 1)
	Next
	SCI_SetText($ParameterEditor_SCIEditor, "")
	_Parameter_Editor_Aktualisiere_Vorschaulabel()
EndFunc   ;==>_Parameter_Editor_Alle_Parameter_leeren

Func _Parameter_Editor_OK()
	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If $Parameter_SCE_HANDLE <> "" Then SendMessage($Parameter_SCE_HANDLE, $SCI_SETREADONLY, False, 0) ;Editor wieder freigeben
		Sci_SetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Parameter_Editor_Startpos, $Parameter_Editor_Endpos)
		$Fertige_Parameter = ""
		For $x = 0 To _GUICtrlListView_GetItemCount($ParameterEditor_ListView) - 1
			$Befehl = _GUICtrlListView_GetItemText($ParameterEditor_ListView, $x, 1)
			If $Befehl = "" Then
				If _Parameter_Editor_Vorschaulabel_ist_nach_leerem_Parameter_etwas_vorhanden($ParameterEditor_ListView, $x) Then
					$Fertige_Parameter = $Fertige_Parameter & "-1" & ", "
					ContinueLoop
				Else
					ContinueLoop
				EndIf
			EndIf

			$Fertige_Parameter = $Fertige_Parameter & $Befehl & ", "
		Next
		If StringRight($Fertige_Parameter, 2) = ", " Then $Fertige_Parameter = StringTrimRight($Fertige_Parameter, 2)
		$Fertige_Parameter = "(" & $Fertige_Parameter & ")"

		If $autoit_editor_encoding = "2" Then
			Sci_ReplaceSel($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], _UNICODE2ANSI($Fertige_Parameter))
		Else
			Sci_ReplaceSel($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Fertige_Parameter)
		EndIf

	EndIf
	_ISNTooltip_Timer_Hide_Tooltips()
	_Hide_Parameter_Editor()
	_Check_Buttons(0)
EndFunc   ;==>_Parameter_Editor_OK

Func _Parameter_Editor_Contextmenue()
	If $Offenes_Projekt = "" Then Return
	If $Tools_Parameter_Editor_aktiviert = "false" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)] = 0 Then Return
	If StringTrimLeft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], StringInStr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], ".", 0, -1)) <> $Autoitextension Then Return
	$Aktuelles_Wort_Doppelclick = SCI_GetCurrentWordEx($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	$Aktuelles_Wort_Doppelclick = StringStripWS($Aktuelles_Wort_Doppelclick, 3)
	$Aktuelles_Wort_Doppelclick = StringReplace($Aktuelles_Wort_Doppelclick, "(", "")
	$Aktuelles_Wort_Doppelclick = StringReplace($Aktuelles_Wort_Doppelclick, ")", "")
	_Pruefe_Doppelklickwort_im_Skripteditor($Aktuelles_Wort_Doppelclick, SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_WORDENDPOSITION, Sci_GetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]), 1))
EndFunc   ;==>_Parameter_Editor_Contextmenue

Func _Kompilieren_Datei_Analysieren_und_Zielpfade_herausfinden($Datei = "")
	If $Datei = "" Then Return
	Dim $Datei_Array
	_FileReadToArray($Datei, $Datei_Array)
	If Not IsArray($Datei_Array) Then Return
	Local $Gefundener_Zielpfad = ""
	For $x = 0 To UBound($Datei_Array) - 1
		$str = $Datei_Array[$x]
		If StringInStr($str, "#AutoIt3Wrapper_Outfile") And $Gefundener_Zielpfad = "" Then $Gefundener_Zielpfad = $Datei_Array[$x]
		If StringInStr($str, "#pragma compile(Out,") Then $Gefundener_Zielpfad = $Datei_Array[$x]
		If $x > 50 Then ExitLoop ;Nur die ersten 50 Zeilen der Datei Analysieren
	Next

	;Pfade richtigstellen
	If StringInStr($Gefundener_Zielpfad, "#pragma compile(Out,") Then ;Pragma
		$Gefundener_Zielpfad = StringReplace($Gefundener_Zielpfad, "#pragma compile(Out,", "")
		If StringRight($Gefundener_Zielpfad, 1) = ")" Then $Gefundener_Zielpfad = StringTrimRight($Gefundener_Zielpfad, 1)
		$Gefundener_Zielpfad = StringStripWS($Gefundener_Zielpfad, 3)
		$Gefundener_Zielpfad = _PathFull($Gefundener_Zielpfad, $Offenes_Projekt)
	EndIf

	If StringInStr($Gefundener_Zielpfad, "#AutoIt3Wrapper_Outfile") Then ;Au3Wrapper

		$Gefundener_Zielpfad = StringTrimLeft($Gefundener_Zielpfad, StringInStr($Gefundener_Zielpfad, "="))
		$Gefundener_Zielpfad = StringStripWS($Gefundener_Zielpfad, 3)
		$Gefundener_Zielpfad = _PathFull($Gefundener_Zielpfad, $Offenes_Projekt)
	EndIf

	Return $Gefundener_Zielpfad
EndFunc   ;==>_Kompilieren_Datei_Analysieren_und_Zielpfade_herausfinden



; #FUNCTION# ====================================================================================================================
; Name ..........: _Finde_Element_im_Skript
; Description ...: Findet Elemente im aktuell geöffnetem Skript. (zb. Funktionen oder Variablen) Wird zb. verwendet beim Doppelklick auf ein Element im Skriptbaum.
;				   Wird die Funktion mit den selben Parametern erneut aufgerufen, wird nach dem nächsten Element gesucht.
; Syntax ........: _Finde_Element_im_Skript([, $name="" [, $mode=""]])
; Parameters ....: $name                - [optional] Name des Elements das gefunden werden soll. (zb. $array)
;                  $mode                - [optional] Type des Elements das gefunden werden soll. (zb. global)
; Return values .: Gibt die Position des gefundenen Elements zurück. -1 wenn nichts gefunden wurde.
; Author ........: ISI360
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Finde_Element_im_Skript($name = "", $mode = "")
	If $mode = "" Then Return
	If $name = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $Startposition_der_Suche = 0
	If $autoit_editor_encoding = "2" Then $name = _UNICODE2ANSI($name)
	$name = StringReplace($name, "\", ".")
	$name = StringReplace($name, "(", "")
	$name = StringReplace($name, "$", "")
	$name = StringStripWS($name, 3)
	If $Finde_Element_im_Skript_letztes_Wort <> $name Then
		$Startposition_der_Suche = 0
		$Finde_Element_im_Skript_letztes_Wort = $name
	Else
		$Startposition_der_Suche = $Finde_Element_im_Skript_letzte_Position
	EndIf

	Switch $mode

		Case "func"
			$name = "func " & $name & "\s*\([^(]"

		Case "global"
			$name = "global[^(]*\<" & $name & "\>"

		Case "local"
			$name = "local[^(]*\<" & $name & "\>"

		Case "region"
			$name = "#region\s*" & $name

		Case "include"
			$name = "#include\s*" & $name

	EndSwitch

	SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEARCHFLAGS, $SCFIND_REGEXP + $SCFIND_POSIX, 0) ;Setze Flags für die Suche

	$found = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $name, $Startposition_der_Suche)
	If $found = -1 Then
		$Startposition_der_Suche = 0 ;Reset wenn nicht mehr gefunden wurde
		$Finde_Element_im_Skript_letzte_Position = 0 ;Reset wenn nicht mehr gefunden wurde
		$found = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $name, $Startposition_der_Suche) ;Von vorne beginnen
		If $found = -1 Then Return $found ;falls nichts gefunden stoppe aktion...
	EndIf

	$Finde_Element_im_Skript_letzte_Position = Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found))



	Return $found
EndFunc   ;==>_Finde_Element_im_Skript



Func _Element_im_Skript_besitzt_Kommentar($name = "", $mode = "")

	If $mode = "" Then Return
	If $name = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	;Zuerst suche das Element im Skript
	$Position = _Finde_Element_im_Skript($name, $mode)
	If $Position = -1 Then Return False

	;Text aus Zeile holen
	$Text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position))

	Switch $mode

		Case "func"
			;Prüfe ob ein UDF Header mit Kommentar existiert
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEARCHFLAGS, $SCFIND_REGEXP + $SCFIND_POSIX, 0) ;Setze Flags für die Suche
			$found = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], ";(.*?)Name(.*?)" & $name, 0)
			If $found <> -1 Then
				;Suche Description Bereich
				$found2 = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], ";(.*?)Description(.*?)", $found)
				If $found2 = -1 Then Return False
				$Description_text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2))
				$Description_text = StringRegExpReplace($Description_text, "(.*?):", "")
				$Description_text = StringStripWS($Description_text, 3)
				If $Description_text <> "" Then Return True
			EndIf


		Case Else
			;Prüfen ob ein Kommentar hinter dem Element gefunden wurde
			$res = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSTYLEAT, Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position)) + StringInStr($Text, ";", 0, -1), 0)
			If $res = $SCE_AU3_COMMENT Or $res = $SCE_AU3_COMMENTBLOCK Then Return True
	EndSwitch

	Return False ;Kein Kommentar gefunden
EndFunc   ;==>_Element_im_Skript_besitzt_Kommentar



Func _Pruefe_ob_Richtiger_UDF_Header_gefunden_wurde($startpos = "", $name = "", $Handle = "")
	$line = Sci_GetLineFromPos($Handle, $startpos)
	While 1
		$Text = Sci_GetLine($Handle, $line)
		If StringInStr($Text, "; #FUNCTION#") Then Return False
		If StringInStr($Text, $name) Then Return True
		$line = $line - 1 ;suche nach oben
		If $line < 1 Then ExitLoop
	WEnd
	Return False
EndFunc   ;==>_Pruefe_ob_Richtiger_UDF_Header_gefunden_wurde

Func _Scripttree_show_comment()
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return

	If _GUICtrlTreeView_GetSelection($hTreeview2) = 0 Then Return
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), ".", 1, -1) = 0 Then Return
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(84) Then Return ;Stoppe bei Root von Globalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(416) Then Return ;Stoppe bei Root von Lokalen Variablen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(83) Then Return ;Stoppe bei Root von Funktionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(433) Then Return ;Stoppe bei Root von Regionen
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(324) Then Return ;Stoppe bei Root von Includes
	If StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1)) = _Get_langstr(323) Then Return ;Stoppe bei Root von Forms im Projekt
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(323)) Then Return ;Stoppe bei Subitems von Forms im Projekt

	$mode = 0
	$name = StringTrimLeft(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), "|", Default, -1))
	If StringInStr($name, " {") Then $name = StringTrimRight($name, StringLen($name) - StringInStr($name, " {") + 1) ;Cut Counts
	$name = StringStripWS($name, 3) ;Entferne Leerzeichen am anfang & Ende eines Elements falls vorhanden
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(83)) Then $mode = "func" ;$str = "func "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(433)) Then $mode = "region" ;$str = "#region "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(84)) Then $mode = "global"
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(416)) Then $mode = "local" ;$str = "global "&$str
	If StringInStr(_GUICtrlTreeView_GetTree($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2)), _Get_langstr(324)) Then $mode = "include" ;$str = "global "&$str

	;Suche das Element im Skript
	$Position = _Finde_Element_im_Skript($name, $mode)
	If $Position = -1 Then Return False
	If $autoit_editor_encoding = "2" Then $name = _UNICODE2ANSI($name)
	;Text aus Zeile holen
	$Text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position))

	Switch $mode

		Case "func"
			;Prüfe ob ein UDF Header mit Kommentar existiert
			SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_SETSEARCHFLAGS, $SCFIND_REGEXP + $SCFIND_POSIX, 0) ;Setze Flags für die Suche
			$found = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], ";(.*?)Name(.*?)" & $name, 0)
			If $found <> -1 Then
				;Suche Description Bereich
				$found2 = Sci_Search($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], ";(.*?)Description(.*?)", $found)
				If $found2 = -1 Then Return False
				If _Pruefe_ob_Richtiger_UDF_Header_gefunden_wurde($found2, $name, $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)]) = False Then
					MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1146), 0, $Studiofenster)
					Return False
				EndIf
				$Description_text = Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2))
				$Description_text = StringRegExpReplace($Description_text, "(.*?):", "")
				$Description_text = StringStripWS($Description_text, 3)
				If $Description_text = "" Then
					Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2)))
				Else
					$startpos = Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2))
					If StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2)), ": ") Then
						$startpos = $startpos + StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2)), ": ") + 1
					Else
						$startpos = $startpos + StringInStr(Sci_GetLine($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2)), ":")
					EndIf

					Sci_SetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $startpos, Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $found2)))

				EndIf
				_WinAPI_SetFocus($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
			Else
				$funcname = $name
				If $autoit_editor_encoding = "2" Then $funcname = _ANSI2UNICODE($funcname)
				$res = MsgBox(262144 + 32 + 4, _Get_langstr(25), StringReplace(_Get_langstr(1147), "%1", $funcname), 0, $Studiofenster)
				If @error Then Return
				If $res = 6 Then
					$findfunc = _Finde_Element_im_Skript($funcname, "func")
					If $findfunc <> -1 Then
						Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $findfunc)
						_Erstelle_UDF_Header()
						Sleep(100)
						_Scripttree_show_comment()
					EndIf
					Return
				EndIf
			EndIf


		Case Else
			;Prüfen ob ein Kommentar hinter dem Element gefunden wurde
			$res = SendMessage($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $SCI_GETSTYLEAT, Sci_GetLineStartPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position)) + StringInStr($Text, ";", 0, -1), 0)
			If $res = $SCE_AU3_COMMENT Or $res = $SCE_AU3_COMMENTBLOCK Then
				Sci_SetSelection($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position + StringInStr($Text, ";", 0, -1), Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position)))
				_WinAPI_SetFocus($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
				Return True
			Else
				Sci_SetCurrentPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineEndPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], Sci_GetLineFromPos($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Position)))
				_WinAPI_SetFocus($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
				Return True
			EndIf
	EndSwitch


	Return False
EndFunc   ;==>_Scripttree_show_comment

Func _SCI_Funcname_aus_Position($sci = "")
	If $sci = "" Then Return

	$word = ""
	$Pos = Sci_GetCurrentPos($sci)
	$SCI_TextZeile = Sci_GetLine($sci, Sci_GetLineFromPos($sci, Sci_GetCurrentPos($sci)))
	$SCI_Startpos = Sci_GetLineStartPos($sci, Sci_GetLineFromPos($sci, Sci_GetCurrentPos($sci)))
	$Pos_in_Line = $Pos - $SCI_Startpos
	$closecount = 0
	For $count = $Pos_in_Line - 1 To 0 Step -1
		$char = Sci_GetChar($sci, $SCI_Startpos + $count)
		If $char = ")" Then $closecount = $closecount + 1
		If $char = "(" Then
			If $closecount <> 0 Then
				$closecount = $closecount - 1
				ContinueLoop
			EndIf
			$word = SCI_GetWordFromPos($sci, ($SCI_Startpos + $count) - 1, 1)
			$word = StringStripWS($word, 3)
			ExitLoop
		EndIf
	Next

	Return $word
EndFunc   ;==>_SCI_Funcname_aus_Position

Func _Elemente_an_Fesntergroesse_anpassen()
	;In Dateien Suchen
	$in_dateien_suchen_gefundene_elemente_listview_Pos_Array = ControlGetPos($in_ordner_nach_text_suchen_gui, "", $in_dateien_suchen_gefundene_elemente_listview)
	If Not IsArray($in_dateien_suchen_gefundene_elemente_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($in_dateien_suchen_gefundene_elemente_listview, 0, ($in_dateien_suchen_gefundene_elemente_listview_Pos_Array[2] / 100) * 59)
	_GUICtrlListView_SetColumnWidth($in_dateien_suchen_gefundene_elemente_listview, 1, ($in_dateien_suchen_gefundene_elemente_listview_Pos_Array[2] / 100) * 8)
	_GUICtrlListView_SetColumnWidth($in_dateien_suchen_gefundene_elemente_listview, 2, ($in_dateien_suchen_gefundene_elemente_listview_Pos_Array[2] / 100) * 30)
	_CenterOnMonitor($ISN_In_Ordner_nach_Text_Suchen_Suche_laeuft_gui, "", $Runonmonitor)

	;Liste aller Projekte am Startfenster
	$Projects_Listview_Pos_Array = ControlGetPos($Welcome_GUI, "", $Projects_Listview)
	If Not IsArray($Projects_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Projects_Listview, 0, ($Projects_Listview_Pos_Array[2] / 100) * 90)

	;Skins Liste in Programmeinstellungen
	$Skins_Listview_Pos_Array = ControlGetPos($Config_GUI, "", $config_skin_list)
	If Not IsArray($Skins_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($config_skin_list, 0, ($Skins_Listview_Pos_Array[2] / 100) * 50)
	_GUICtrlListView_SetColumnWidth($config_skin_list, 1, ($Skins_Listview_Pos_Array[2] / 100) * 44)

	;Toolbar Listen in den Programmeinstellungen
	$einstellungen_toolbar_aktiveelemente_listview_Pos_Array = ControlGetPos($Config_GUI, "", $einstellungen_toolbar_aktiveelemente_listview)
	If Not IsArray($einstellungen_toolbar_aktiveelemente_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($einstellungen_toolbar_aktiveelemente_listview, 0, ($einstellungen_toolbar_aktiveelemente_listview_Pos_Array[2] / 100) * 93)

	$einstellungen_toolbar_verfuegbareelemente_listview_Pos_Array = ControlGetPos($Config_GUI, "", $einstellungen_toolbar_verfuegbareelemente_listview)
	If Not IsArray($einstellungen_toolbar_verfuegbareelemente_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($einstellungen_toolbar_verfuegbareelemente_listview, 0, ($einstellungen_toolbar_verfuegbareelemente_listview_Pos_Array[2] / 100) * 93)


	;Includesliste in den Programmeinstellungen
	$Einstellungen_AutoItIncludes_Verwalten_Listview_Pos_Array = ControlGetPos($Config_GUI, "", $Einstellungen_AutoItIncludes_Verwalten_Listview)
	If Not IsArray($Einstellungen_AutoItIncludes_Verwalten_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Einstellungen_AutoItIncludes_Verwalten_Listview, 0, ($Einstellungen_AutoItIncludes_Verwalten_Listview_Pos_Array[2] / 100) * 96)

	;Dateitypenliste in den Programmeinstellungen
	$Einstellungen_Skripteditor_Dateitypen_Listview_Pos_Array = ControlGetPos($Config_GUI, "", $Einstellungen_Skripteditor_Dateitypen_Listview)
	If Not IsArray($Einstellungen_Skripteditor_Dateitypen_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Einstellungen_Skripteditor_Dateitypen_Listview, 0, ($Einstellungen_Skripteditor_Dateitypen_Listview_Pos_Array[2] / 100) * 96)


	;APIliste in den Programmeinstellungen
	$Einstellungen_API_Listview_Pos_Array = ControlGetPos($Config_GUI, "", $Einstellungen_API_Listview)
	If Not IsArray($Einstellungen_API_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Einstellungen_API_Listview, 0, ($Einstellungen_API_Listview_Pos_Array[2] / 100) * 96)

	$Einstellungen_Properties_Listview_Pos_Array = ControlGetPos($Config_GUI, "", $Einstellungen_Properties_Listview)
	If Not IsArray($Einstellungen_Properties_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Einstellungen_Properties_Listview, 0, ($Einstellungen_Properties_Listview_Pos_Array[2] / 100) * 96)


	;Hotkeysliste in den Programmeinstellungen
	$settings_hotkeylistview_Pos_Array = ControlGetPos($Config_GUI, "", $settings_hotkeylistview)
	If Not IsArray($settings_hotkeylistview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($settings_hotkeylistview, 0, ($settings_hotkeylistview_Pos_Array[2] / 100) * 53)
	_GUICtrlListView_SetColumnWidth($settings_hotkeylistview, 1, ($settings_hotkeylistview_Pos_Array[2] / 100) * 44)

	;Pluginsliste in den Programmeinstellungen
	$Pugins_Listview_Pos_Array = ControlGetPos($Config_GUI, "", $Pugins_Listview)
	If Not IsArray($Pugins_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Pugins_Listview, 0, ($Pugins_Listview_Pos_Array[2] / 100) * 35)
	_GUICtrlListView_SetColumnWidth($Pugins_Listview, 1, ($Pugins_Listview_Pos_Array[2] / 100) * 8)
	_GUICtrlListView_SetColumnWidth($Pugins_Listview, 2, ($Pugins_Listview_Pos_Array[2] / 100) * 42)
	_GUICtrlListView_SetColumnWidth($Pugins_Listview, 3, ($Pugins_Listview_Pos_Array[2] / 100) * 10)

	;Listen in der Projektverwaltung
	$Projects_Listview_projectman_Pos_Array = ControlGetPos($projectmanager, "", $Projects_Listview_projectman)
	If Not IsArray($Projects_Listview_projectman_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Projects_Listview_projectman, 0, ($Projects_Listview_projectman_Pos_Array[2] / 100) * 45)
	_GUICtrlListView_SetColumnWidth($Projects_Listview_projectman, 1, ($Projects_Listview_projectman_Pos_Array[2] / 100) * 20)
	_GUICtrlListView_SetColumnWidth($Projects_Listview_projectman, 2, ($Projects_Listview_projectman_Pos_Array[2] / 100) * 30)

	$Projektverwaltung_Projektdetails_Listview_Pos_Array = ControlGetPos($projectmanager, "", $Projektverwaltung_Projektdetails_Listview)
	If Not IsArray($Projektverwaltung_Projektdetails_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Projektverwaltung_Projektdetails_Listview, 0, ($Projektverwaltung_Projektdetails_Listview_Pos_Array[2] / 100) * 50)
	_GUICtrlListView_SetColumnWidth($Projektverwaltung_Projektdetails_Listview, 1, ($Projektverwaltung_Projektdetails_Listview_Pos_Array[2] / 100) * 44)

	$vorlagen_Listview_projectman_Pos_Array = ControlGetPos($projectmanager, "", $vorlagen_Listview_projectman)
	If Not IsArray($vorlagen_Listview_projectman_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($vorlagen_Listview_projectman, 0, ($vorlagen_Listview_projectman_Pos_Array[2] / 100) * 45)
	_GUICtrlListView_SetColumnWidth($vorlagen_Listview_projectman, 1, ($vorlagen_Listview_projectman_Pos_Array[2] / 100) * 49)

	;Listen in den Projekteinstellungen
	$Project_Properties_listview_Pos_Array = ControlGetPos($Projekteinstellungen_GUI, "", $Project_Properties_listview)
	If Not IsArray($Project_Properties_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Project_Properties_listview, 0, ($Project_Properties_listview_Pos_Array[2] / 100) * 40)
	_GUICtrlListView_SetColumnWidth($Project_Properties_listview, 1, ($Project_Properties_listview_Pos_Array[2] / 100) * 56)

	$Projekteinstellungen_API_Listview_Pos_Array = ControlGetPos($Projekteinstellungen_GUI, "", $Projekteinstellungen_API_Listview)
	If Not IsArray($Projekteinstellungen_API_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Projekteinstellungen_API_Listview, 0, ($Projekteinstellungen_API_Listview_Pos_Array[2] / 100) * 96)
	_GUICtrlListView_SetColumnWidth($Projekteinstellungen_Proberties_Listview, 0, ($Projekteinstellungen_API_Listview_Pos_Array[2] / 100) * 96)

	;Liste in Makros
	$listview_projectrules_Pos_Array = ControlGetPos($ruleseditor, "", $listview_projectrules)
	If Not IsArray($listview_projectrules_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($listview_projectrules, 0, ($listview_projectrules_Pos_Array[2] / 100) * 85)
	_GUICtrlListView_SetColumnWidth($listview_projectrules, 1, ($listview_projectrules_Pos_Array[2] / 100) * 11)

	;Weitere Dateien kompilieren
	$Weitere_Dateien_Kompilieren_GUI_Listview_Pos_Array = ControlGetPos($Weitere_Dateien_Kompilieren_GUI, "", $Weitere_Dateien_Kompilieren_GUI_Listview)
	If Not IsArray($Weitere_Dateien_Kompilieren_GUI_Listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($Weitere_Dateien_Kompilieren_GUI_Listview, 0, ($Weitere_Dateien_Kompilieren_GUI_Listview_Pos_Array[2] / 100) * 93)

	;Makro auswählen
	$makro_auswaehlen_listview_Pos_Array = ControlGetPos($Makro_auswaehlen_GUI, "", $makro_auswaehlen_listview)
	If Not IsArray($makro_auswaehlen_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($makro_auswaehlen_listview, 0, ($makro_auswaehlen_listview_Pos_Array[2] / 100) * 84)
	_GUICtrlListView_SetColumnWidth($makro_auswaehlen_listview, 1, ($makro_auswaehlen_listview_Pos_Array[2] / 100) * 10)

	;Makro bearbeiten
	$new_rule_triggerlist_Pos_Array = ControlGetPos($newrule_GUI, "", $new_rule_triggerlist)
	If Not IsArray($new_rule_triggerlist_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($new_rule_triggerlist, 0, ($new_rule_triggerlist_Pos_Array[2] / 100) * 90)

	$new_rule_actionlist_Pos_Array = ControlGetPos($newrule_GUI, "", $new_rule_actionlist)
	If Not IsArray($new_rule_actionlist_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($new_rule_actionlist, 0, ($new_rule_actionlist_Pos_Array[2] / 100) * 45)
	_GUICtrlListView_SetColumnWidth($new_rule_actionlist, 1, ($new_rule_actionlist_Pos_Array[2] / 100) * 49)

	;Änderungsprotokolle
	$changelogmanager_listview_Pos_Array = ControlGetPos($aenderungs_manager_GUI, "", $changelogmanager_listview)
	If Not IsArray($changelogmanager_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 0, ($changelogmanager_listview_Pos_Array[2] / 100) * 8)
	_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 1, ($changelogmanager_listview_Pos_Array[2] / 100) * 19)
	_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 2, ($changelogmanager_listview_Pos_Array[2] / 100) * 40)
	_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 3, ($changelogmanager_listview_Pos_Array[2] / 100) * 10)
	_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 4, ($changelogmanager_listview_Pos_Array[2] / 100) * 10)
	_GUICtrlListView_SetColumnWidth($changelogmanager_listview, 5, ($changelogmanager_listview_Pos_Array[2] / 100) * 10)


	$changelogenerieren_listview_Pos_Array = ControlGetPos($changelog_generieren_GUI, "", $changelogenerieren_listview)
	If Not IsArray($changelogenerieren_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($changelogenerieren_listview, 0, ($changelogenerieren_listview_Pos_Array[2] / 100) * 16)
	_GUICtrlListView_SetColumnWidth($changelogenerieren_listview, 2, ($changelogenerieren_listview_Pos_Array[2] / 100) * 45)
	_GUICtrlListView_SetColumnWidth($changelogenerieren_listview, 3, ($changelogenerieren_listview_Pos_Array[2] / 100) * 15)
	_GUICtrlListView_SetColumnWidth($changelogenerieren_listview, 5, ($changelogenerieren_listview_Pos_Array[2] / 100) * 18)


	;Funktion auswählen
	$FuncListview_Pos_Array = ControlGetPos($Funclist_GUI, "", $FuncListview)
	If Not IsArray($FuncListview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($FuncListview, 0, ($FuncListview_Pos_Array[2] / 100) * 92)


EndFunc   ;==>_Elemente_an_Fesntergroesse_anpassen

Func _Parametereditor_Fenster_anpassen()
	AdlibUnRegister("_Parametereditor_Fenster_anpassen")
	;Parameter Editor
	$ParameterEditor_ListView_Pos_Array = ControlGetPos($ParameterEditor_GUI, "", $ParameterEditor_ListView)
	If Not IsArray($ParameterEditor_ListView_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($ParameterEditor_ListView, 0, ($ParameterEditor_ListView_Pos_Array[2] / 100) * 45)
	_GUICtrlListView_SetColumnWidth($ParameterEditor_ListView, 1, ($ParameterEditor_ListView_Pos_Array[2] / 100) * 49)

	$ParameterEditor_group_unten_Pos_Array = ControlGetPos($ParameterEditor_GUI, "", $ParameterEditor_group_unten)
	If Not IsArray($ParameterEditor_group_unten_Pos_Array) Then Return
	WinMove($ParameterEditor_SCIEditor, "", $ParameterEditor_ListView_Pos_Array[0], ($ParameterEditor_ListView_Pos_Array[1] + $ParameterEditor_ListView_Pos_Array[3]) + (22 * $DPI), $ParameterEditor_group_unten_Pos_Array[2])


EndFunc   ;==>_Parametereditor_Fenster_anpassen


Func _StringSize($sText, $iSize = 8.5, $iWeight = 400, $iAttrib = 0, $sName = "Arial", $iQuality = 2)
	Local Const $LOGPIXELSY = 90
	Local $fItalic = BitAND($iAttrib, 2)
	Local $hDC = _WinAPI_GetDC(0)
	Local $hFont = _WinAPI_CreateFont(-_WinAPI_GetDeviceCaps($hDC, $LOGPIXELSY) * $iSize / 72, 0, 0, 0, $iWeight, $fItalic, BitAND($iAttrib, 4), BitAND($iAttrib, 8), 0, 0, 0, $iQuality, 0, $sName)
	Local $hOldFont = _WinAPI_SelectObject($hDC, $hFont)
	Local $tSIZE
	If $fItalic Then $sText &= " "
	Local $iWidth, $iHeight
	Local $aArrayOfStrings = StringSplit($sText, @LF, 2)
	For $sString In $aArrayOfStrings
		$tSIZE = _WinAPI_GetTextExtentPoint32($hDC, $sString)
		If DllStructGetData($tSIZE, "X") > $iWidth Then $iWidth = DllStructGetData($tSIZE, "X")
		$iHeight += DllStructGetData($tSIZE, "Y")
	Next
	_WinAPI_SelectObject($hDC, $hOldFont)
	_WinAPI_DeleteObject($hFont)
	_WinAPI_ReleaseDC(0, $hDC)
	Local $aOut[2] = [$iWidth, $iHeight]
	Return $aOut
EndFunc   ;==>_StringSize

Func _ISN_Print_current_file()
	If $Offenes_Projekt = "" Then Return
	AdlibRegister("_ISN_Print_current_file_Adlib")
EndFunc   ;==>_ISN_Print_current_file

Func _ISN_Print_current_file_Adlib()
	AdlibUnRegister("_ISN_Print_current_file_Adlib")
	_Drucke_Datei($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)], $Datei_pfad[_GUICtrlTab_GetCurFocus($htab)])
EndFunc   ;==>_ISN_Print_current_file_Adlib

Func _Drucke_Datei($SCI_Editor = "", $Dateipfad = "")
	If $SCI_Editor = "" Then Return
	If $Dateipfad = "" Then Return
	If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_SeiteDrucken) <> -1 Then Return ;Platzhalter für Plugin
	Dim $szDrive, $szDir, $szFName, $szExt
	$res = _PathSplit($Dateipfad, $szDrive, $szDir, $szFName, $szExt)

	GUICtrlSetData($Please_Wait_GUI_Title, _Get_langstr(1298))
	GUICtrlSetData($Please_Wait_GUI_Text, _Get_langstr(23))

	GUISetState(@SW_SHOW, $Please_Wait_GUI)
	GUISetState(@SW_DISABLE, $Studiofenster)

	If $szExt = "." & $Autoitextension Then
		_HTML_Datei_fuer_Druck_generieren($Arbeitsverzeichnis & "\Data\Cache\print.html", $SCI_Editor, $szFName & $szExt)
	Else
		_HTML_Datei_fuer_Druck_generieren($Arbeitsverzeichnis & "\Data\Cache\print.html", $SCI_Editor, $szFName & $szExt, 1)
	EndIf

	Local $Studiofenster_pos = WinGetPos($Studiofenster)
	If IsArray($Studiofenster_pos) Then WinMove($Druckvorschau_GUI, "", $Studiofenster_pos[0], $Studiofenster_pos[1], $Studiofenster_pos[2], $Studiofenster_pos[3])
	If IsObj($Druckvorschau_oIE) Then _IENavigate($Druckvorschau_oIE, $Arbeitsverzeichnis & "\Data\Cache\print.html")
	If IsObj($Druckvorschau_oIE) Then $Druckvorschau_oIE.execWB(7, 2)

	GUISetState(@SW_ENABLE, $Studiofenster)
	GUISetState(@SW_HIDE, $Please_Wait_GUI)


EndFunc   ;==>_Drucke_Datei




Func _HTML_Datei_fuer_Druck_generieren($Zielpfad = "", $SCI_Editor = "", $Dokumenttitel = "ISN AutoIt Studio", $Ohne_Styling = 0)

	Local $HTML_Datei_Inhalt = ""
	Local $Split = ""


	;Header und Styles
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<html xmlns="http://www.w3.org/1999/xhtm">' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<head>' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<title>' & $Dokumenttitel & '</title>' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<meta name="Generator" content="ISN AutoIt Studio - www.isnetwork.at" />' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' & @CRLF


	If $Ohne_Styling <> 1 Then
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<style type="text/css">' & @CRLF
		;Style0 - AU3_DEFAULT
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S0 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE1b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE1a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style1 - AU3_COMMENT
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S1 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE2b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE2a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style2 - AU3_COMMENTBLOCK
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S2 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE3b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE3a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style3 - AU3_NUMBER
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S3 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE4b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE4a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style4 - AU3_FUNCTION
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S4 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE5b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE5a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style5 - AU3_KEYWORD
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S5 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE6b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE6a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style6 - AU3_MACRO
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S6 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE7b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE7a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style7 - AU3_STRING
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S7 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE8b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE8a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style8 - AU3_OPERATOR
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S8 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE9b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE9a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style9 - AU3_VARIABLE
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S9 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE10b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE10a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style10 - AU3_SENT
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S10 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE11b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE11a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF


		;Style11 - AU3_PREPROCESSOR
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S11 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE12b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE12a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style12 - AU3_SPECIAL
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S12 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE13b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE13a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style13 - AU3_EXPAND
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S13 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE14b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE14a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style14 - AU3_COMOBJ
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S14 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE15b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE15a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Style15 - AU3_UDF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '.S15 {' & @CRLF
		If $use_new_au3_colours = "true" Then
			$Split = StringSplit($SCE_AU3_STYLE16b, "|", 2)
		Else
			$Split = StringSplit($SCE_AU3_STYLE16a, "|", 2)
		EndIf
		If UBound($Split) - 1 = 4 Then
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: ' & StringReplace(_BGR_to_RGB($Split[0]), "0x", "#") & ';' & @CRLF
			If $Split[2] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-weight: bold;' & @CRLF
			If $Split[3] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-style: italic;' & @CRLF
			If $Split[4] = "1" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	text-decoration: underline;' & @CRLF
		EndIf
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF

		;Span
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & 'span {' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & "	font-family: '" & $scripteditor_font & "';" & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	color: #000000;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '	font-size: ' & $scripteditor_size & 'pt;' & @CRLF
		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '}' & @CRLF



		$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</style>' & @CRLF
	EndIf
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</head>' & @CRLF

	;HTML Body
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<body bgcolor="#FFFFFF">' & @CRLF


	Local $startpos = 0
	Local $Endpos = 0
	Local $Letzter_Style = ""
	Local $style_at_pos = ""
	$Endpos = Sci_GetLenght($SCI_Editor)


	;Falls im Editor etwas Markiert ist, nur Markierten Text ausgeben
	$startPosition = SendMessage($SCI_Editor, $SCI_GETSELECTIONSTART, 0, 0)
	$endPosition = SendMessage($SCI_Editor, $SCI_GETSELECTIONEND, 0, 0)
	If $startPosition <> $endPosition Then
		$startpos = $startPosition
		$Endpos = $endPosition - 1
	EndIf


	Local $Zeichenlimit = 0

	For $x = $startpos To $Endpos

		$Aktuelles_Zeichen = Sci_GetChar($SCI_Editor, $x)

		$Zeichenlimit = $Zeichenlimit + 1
		If $Zeichenlimit > 50000 Then ;Druck für max. 50.000 Zeichen limitieren
			GUISetState(@SW_ENABLE, $Studiofenster)
			GUISetState(@SW_HIDE, $Please_Wait_GUI)
			MsgBox(48 + 262144, _Get_langstr(394), StringReplace(_Get_langstr(1299), "%1", "50.000"), 0, $Studiofenster)
			ExitLoop
		EndIf



		If $Aktuelles_Zeichen = @CR Then
			If $Letzter_Style <> "" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & "</span> "
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & "<br /> " & @CRLF
			$Letzter_Style = ""
			ContinueLoop
		EndIf
		If $Aktuelles_Zeichen = @LF Then ContinueLoop
		If $Aktuelles_Zeichen = "" Then ContinueLoop
		$Aktuelles_Zeichen_html = Sci_GetChar_HTML($SCI_Editor, $x)


		$style_at_pos = String(SendMessage($SCI_Editor, $SCI_GETSTYLEAT, $x, 0))

		If $style_at_pos <> $Letzter_Style Then

			If $Letzter_Style <> "" Then $HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</span>'

			Switch $style_at_pos

				Case $SCE_AU3_DEFAULT
					$Letzter_Style = "0"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S0">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)


				Case $SCE_AU3_COMMENT
					$Letzter_Style = "1"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S1">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_COMMENTBLOCK
					$Letzter_Style = "2"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S2">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_NUMBER
					$Letzter_Style = "3"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S3">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_FUNCTION
					$Letzter_Style = "4"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S4">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_KEYWORD
					$Letzter_Style = "5"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S5">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_MACRO
					$Letzter_Style = "6"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S6">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_STRING
					$Letzter_Style = "7"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S7">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_OPERATOR
					$Letzter_Style = "8"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S8">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_VARIABLE
					$Letzter_Style = "9"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S9">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_SENT
					$Letzter_Style = "10"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S10">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_PREPROCESSOR
					$Letzter_Style = "11"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S11">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_SPECIAL
					$Letzter_Style = "12"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S12">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_EXPAND
					$Letzter_Style = "13"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S13">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_COMOBJ
					$Letzter_Style = "14"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S14">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)

				Case $SCE_AU3_UDF
					$Letzter_Style = "15"
					$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '<span class="S15">' & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)
			EndSwitch

		Else
			$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($Aktuelles_Zeichen_html)
		EndIf



		;Prüfe ob letzter Buchstabe ein Multibyte Char war und korrigiere $x
		$binary = _HexToBinaryString(StringToBinary($Aktuelles_Zeichen, 4))
		If StringLeft($binary, 2) = "11" Then $x = $x + 1
		If StringLeft($binary, 3) = "111" Then $x = $x + 1
		If StringLeft($binary, 4) = "1111" Then $x = $x + 1

	Next


	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</body>' & @CRLF
	$HTML_Datei_Inhalt = $HTML_Datei_Inhalt & '</html>' & @CRLF

	Local $HTML_Datei_Handle = FileOpen($Zielpfad, $FO_OVERWRITE + $FO_UTF8_NOBOM)
	If $HTML_Datei_Handle = -1 Then
		Return
	EndIf
	FileWrite($HTML_Datei_Handle, $HTML_Datei_Inhalt)
	FileClose($HTML_Datei_Handle)

EndFunc   ;==>_HTML_Datei_fuer_Druck_generieren


; Hex To Binary
Func _HexToBinaryString($HexValue)
	Local $Allowed = '0123456789ABCDEF'
	$HexValue = StringReplace($HexValue, "0x", "")
	Local $Test, $n
	Local $Result = ''
	If $HexValue = '' Then
		SetError(-2)
		Return
	EndIf

	$HexValue = StringSplit($HexValue, '')
	For $n = 1 To $HexValue[0]
		If Not StringInStr($Allowed, $HexValue[$n]) Then
			SetError(-1)
			Return 0
		EndIf
	Next

	Local $bits = "0000|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|1101|1110|1111"
	$bits = StringSplit($bits, '|')
	For $n = 1 To $HexValue[0]
		$Result &= $bits[Dec($HexValue[$n]) + 1]
	Next

	Return $Result

EndFunc   ;==>_HexToBinaryString

Func _HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen($char = "")
	$char = StringReplace($char, " ", "&nbsp;")
	$char = StringReplace($char, "<", "&lt;")
	$char = StringReplace($char, ">", "&gt;")
	$char = StringReplace($char, @TAB, "&emsp;")
	Return $char
EndFunc   ;==>_HTML_Datei_fuer_Druck_generieren_Zeichen_ersetzen

Func Sci_GetChar_HTML($sci, $Pos)
	If $autoit_editor_encoding = "1" Then
		Return Sci_GetChar($sci, $Pos)
	EndIf
	$binary = _HexToBinaryString(StringToBinary(Sci_GetChar($sci, $Pos), 4))
	If StringLeft($binary, 2) = "11" Then ;Multibyte Char
		$y = 2
		If StringLeft($binary, 2) = "11" Then $y = 2
		If StringLeft($binary, 3) = "111" Then $y = 3
		If StringLeft($binary, 4) = "1111" Then $y = 4
		Return _ANSI2UNICODE(SCI_GetTextRange($sci, $Pos, $Pos + $y))
	Else
		Return ChrW(SendMessage($sci, $SCI_GETCHARAT, $Pos, 0))
	EndIf
EndFunc   ;==>Sci_GetChar_HTML


Func _ISN_Projekt_Testen()
	If $Offenes_Projekt = "" Then Return
	If $Studiomodus = 1 Then
		_Testscript($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"))
	Else
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
		If $GUICtrlTab_GetCurFocus = -1 Then Return
		If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then _Testscript($Datei_pfad[$GUICtrlTab_GetCurFocus])
	EndIf

EndFunc   ;==>_ISN_Projekt_Testen

Func _ISN_Skript_Testen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then _Testscript($Datei_pfad[$GUICtrlTab_GetCurFocus]) ;Skript Testen
EndFunc   ;==>_ISN_Skript_Testen

Func _ISN_aktuellen_Tab_schliessen()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	try_to_Close_Tab($GUICtrlTab_GetCurFocus) ;Close Tab
EndFunc   ;==>_ISN_aktuellen_Tab_schliessen

Func _ISN_Tidy_aktuellen_Tab()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	_Tidy($Datei_pfad[$GUICtrlTab_GetCurFocus]) ;TidySource
EndFunc   ;==>_ISN_Tidy_aktuellen_Tab

Func _ISN_aktuellen_Tab_speichern()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	_try_to_save_file($GUICtrlTab_GetCurFocus)
EndFunc   ;==>_ISN_aktuellen_Tab_speichern


Func _ISN_Syntaxcheck_aktuellen_Tab()
	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	_Syntaxcheck($Datei_pfad[$GUICtrlTab_GetCurFocus]) ;syntaxcheck
EndFunc   ;==>_ISN_Syntaxcheck_aktuellen_Tab

Func _ISN_Projekt_Testen_ohne_Parameter()
	If $Offenes_Projekt = "" Then Return
	If $Studiomodus = 1 Then
		_Testscript($Offenes_Projekt & "\" & IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"), 1)
	Else
		If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
		Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
		If $GUICtrlTab_GetCurFocus = -1 Then Return
		If StringTrimLeft($Datei_pfad[$GUICtrlTab_GetCurFocus], StringInStr($Datei_pfad[$GUICtrlTab_GetCurFocus], ".", 0, -1)) = $Autoitextension Then _Testscript($Datei_pfad[$GUICtrlTab_GetCurFocus], 1)
	EndIf
EndFunc   ;==>_ISN_Projekt_Testen_ohne_Parameter

Func _Sci_get_Functionname_from_Position($sci = "")
	If $hidefunctionstree = "true" Then Return
	If $Bearbeitende_Function_im_skriptbaum_markieren = "false" Then Return
	If $showfunctions = "false" Then Return
	If $Offenes_Projekt = "" Then Return
	Local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)
	If $GUICtrlTab_GetCurFocus = -1 Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	If $Plugin_Handle[$GUICtrlTab_GetCurFocus] <> -1 Then Return
	$startline = SendMessage($SCE_EDITOR[$GUICtrlTab_GetCurFocus], $SCI_LINEFROMPOSITION, Sci_GetCurrentPos($SCE_EDITOR[$GUICtrlTab_GetCurFocus]), 0)
	For $x = $startline To 0 Step -1
		If StringInStr(Sci_GetLine($sci, $x), "Endfunc") Then Return
		If StringInStr(Sci_GetLine($sci, $x), "func ") And BitAND(SendMessage($SCE_EDITOR[$GUICtrlTab_GetCurFocus], $SCI_GETFOLDLEVEL, $x, 0), $SC_FOLDLEVELHEADERFLAG) Then
			ExitLoop
		EndIf
	Next
	$Line_Text = Sci_GetLine($sci, $x)
	If $Line_Text = "" Or $Line_Text = -1 Then Return
	$Line_Text = StringReplace($Line_Text, @CRLF, "")
	If Not StringInStr($Line_Text, "func ") Then Return
	Local $funcname = ""

	;Get Func Name
	$temp = _StringBetween($Line_Text, "func ", "(")
	If IsArray($temp) Then $funcname = $temp[0]
	$funcname = StringStripWS($funcname, 3)

	If $Name_der_Func_die_bearbeitet_wird <> $funcname Then
		$Name_der_Func_die_bearbeitet_wird = $funcname
		$Treeview_item = _GUICtrlTreeView_FindItem($hTreeview2, $funcname)
		If $Treeview_item <> 0 Then
			_GUICtrlTreeView_SelectItem($hTreeview2, $Treeview_item)
		EndIf
	EndIf

EndFunc   ;==>_Sci_get_Functionname_from_Position




