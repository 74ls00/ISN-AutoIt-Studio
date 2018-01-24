;ISN AUTOIT CONVERTER
;----------------------------------------------
;converter.au3 for ISN Form Studio 2 by ISI360
;----------------------------------------------
Global $Menu_ICON_UDF_BENOETIGT = 0
Global $genstyle = ""
Global $genexstyle = ""
Global $Testmode = 1
Global $ISN_Studio_Projekt_WORKINGDIR = ""
Global $ISN_Studio_Projekt_WORKINGDIR_MODE3 = ""

Func _sortiere_Controls_nach_Order($section_array)
	If Not IsArray($section_array) Then Return
	$quell_array = $section_array
	_ArrayDelete($quell_array, 0)
	Dim $Elemente_sortiert[UBound($quell_array)][2]
	Dim $Fertiges_Array[UBound($section_array)]
	For $i = 0 To UBound($Elemente_sortiert) - 1
		$Elemente_sortiert[$i][0] = $quell_array[$i]
		$Elemente_sortiert[$i][1] = Number(_IniReadEx($Cache_Datei_Handle, $quell_array[$i], "order", "-1"))
	Next
	_ArraySort($Elemente_sortiert, 0, 0, 0, 1)
	$Fertiges_Array[0] = $section_array[0]
	For $i = 1 To UBound($Elemente_sortiert)
		$Fertiges_Array[$i] = $Elemente_sortiert[$i - 1][0]
	Next
	Return $Fertiges_Array
EndFunc   ;==>_sortiere_Controls_nach_Order


Func _Return_Workdir($zu_pruefen = "", $savefile = 0)
	If $zu_pruefen <> "" Then
		If FileExists($zu_pruefen) Then
			If $Testmode = 1 Or $savefile <> 0 Then
				Return '"'
			Else
				Return ""
			EndIf
		Else
			Return _Return_Workdir("")
		EndIf

	Else
		If $DEBUG = "true" Then Return '"' & @ScriptDir & "\"
		If $Testmode = 0 Then Return '@scriptdir&"\"&"'
		If $Testmode > 0 Then


			If $ISN_Studio_Projekt_WORKINGDIR = "" Then
				$data = $ISN_AutoIt_Studio_opened_project_Path
				$ISN_Studio_Projekt_WORKINGDIR = '"' & $data & "\"
				$ISN_Studio_Projekt_WORKINGDIR_MODE3 = $data & "\"
			EndIf



			If $Testmode = 1 Then Return $ISN_Studio_Projekt_WORKINGDIR
			If $Testmode = 3 Then Return $ISN_Studio_Projekt_WORKINGDIR_MODE3

		EndIf
	EndIf
EndFunc   ;==>_Return_Workdir

Func _AU3Converter_Menu_Lade_Childs($file, $rootitem = "", $Childsstring = "", $for_testing_only = 0, $Handle_Deklaration = "")
	If $rootitem = "" Then Return
	If $Childsstring = "-1" Then Return
	If $Childsstring = "" Then Return
	If $rootitem = "root" Then Return
	If StringTrimLeft($Childsstring, StringLen($Childsstring) - 1) = "|" Then $Childsstring = StringTrimRight($Childsstring, 1)
	$ChildsstringSplit = StringSplit($Childsstring, "|", 2)
	If Not IsArray($ChildsstringSplit) Then Return
	For $x = 0 To UBound($ChildsstringSplit) - 1
		$Handle = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "handle", "")
		$checked = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "checked", "0")
		$radio = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "radio", "0")
		$iconmode = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "iconmode", "0")
		$iconpath = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "iconpath", "")
		$func = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "func", "")
		$iconvarible = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "iconvarible", "")
		$iconID = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "iconid", "0")
		If $iconID = "" Then $iconID = 0
		$Text = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "text", "")
		If _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "textmode", "text") = "text" Then
			$Textmodezeichen = '"'
		Else
			$Textmodezeichen = ""
		EndIf
		$childs = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "childs", "-1")
		If $childs = "-1" Then
			FileWriteLine($file, $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben($Handle) & ' = GUICtrlCreateMenuItem(' & $Textmodezeichen & $Text & $Textmodezeichen & ',' & $rootitem & ',-1,' & $radio & ')')
		Else
			FileWriteLine($file, $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben($Handle) & ' = GUICtrlCreateMenu(' & $Textmodezeichen & $Text & $Textmodezeichen & ',' & $rootitem & ')')
		EndIf
		If $checked = "1" Then FileWriteLine($file, "GUICtrlSetState(-1, $GUI_CHECKED)")
		If $func <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1, "'&$func&'")')

		If $iconmode <> "0" Then
			$Menu_ICON_UDF_BENOETIGT = 1
			$IconPfad = '"' & $iconpath & '"'
			If $iconvarible <> "" And $for_testing_only = 0 Then $IconPfad = $iconvarible
			If $iconmode = "1" Then $iconID = 0
			FileWriteLine($file, "_GUICtrlMenu_SetItemBmp(GUICtrlGetHandle(" & $rootitem & "), " & _Handle_mit_Dollar_zurueckgeben($Handle) & ", _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), " & $IconPfad & ", " & $iconID & ", 16, 16),false)")
		EndIf

		_AU3Converter_Menu_Lade_Childs($file, _Handle_mit_Dollar_zurueckgeben($Handle), $childs, $for_testing_only, $Handle_Deklaration)
	Next

;~ next
EndFunc   ;==>_AU3Converter_Menu_Lade_Childs




;Save = 1 wenn nur gui ausgegeben werden soll
Func _TEST_FORM($show = 0, $save = 0, $for_testing_only = 0, $No_UI = 0)
	$AutoITEXE_Path = IniRead($Pfad_zur_Studioconfig, "config", "autoitexe", "")
	$AutoITEXE_Path = _ISN_Variablen_aufloesen($AutoITEXE_Path)
	If Not FileExists($AutoITEXE_Path) Then
		MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(169), 0, $StudioFenster)
	EndIf
	$Menu_ICON_UDF_BENOETIGT = 0
	_SetStatustext(_ISNPlugin_Get_langstring(168))
	Local $Handle_Deklaration = ""
	Switch _IniReadEx($Cache_Datei_Handle, "gui", "Handle_deklaration", "default")
		Case "default"
			Switch $FormStudio_Global_Handle_deklaration
				Case "global"
					$Handle_Deklaration = "Global "

				Case "local"
					$Handle_Deklaration = "Local "

			EndSwitch

		Case "global"
			$Handle_Deklaration = "Global "

		Case "local"
			$Handle_Deklaration = "Local "

	EndSwitch

	If _IniReadEx($Cache_Datei_Handle, "gui", "Handle_deklaration", "default") = "default" Then
		If $Handle_Deklaration <> "" And $FormStudio_Global_Handle_deklaration_const = "true" Then $Handle_Deklaration = $Handle_Deklaration & "Const "
	Else
		If $Handle_Deklaration <> "" And _IniReadEx($Cache_Datei_Handle, "gui", "Handle_deklaration_const", "") = "true" Then $Handle_Deklaration = $Handle_Deklaration & "Const "
	EndIf


	$fortschritt = 0 ; 0 %
	GUICtrlSetData($StudioFenster_inside_load, $fortschritt)
	GUICtrlSetData($StudioFenster_inside_Text2, $fortschritt & " %")





	If $save = 0 And $No_UI = 0 Then
		GUISetState(@SW_HIDE, $GUI_Editor)
		GUISetState(@SW_HIDE, $Formstudio_controleditor_GUI)
		GUICtrlSetData($StudioFenster_inside_Text1, _ISNPlugin_Get_langstring(51))
		GUICtrlSetData($StudioFenster_inside_Text2, "0 %")
		GUICtrlSetData($StudioFenster_inside_load, 0)
		GUICtrlSetState($StudioFenster_inside_Text1, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_Text2, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_Icon, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_load, $GUI_SHOW)

	EndIf

	If $save = 1 Then
		$Testmode = 0
	Else
		$Testmode = 1
	EndIf


	Local $THERE_IS_A_edit = 0
	Local $THERE_IS_A_Listview = 0
	Local $THERE_IS_A_TAB = 0
	Local $THERE_IS_A_IP = 0
	Local $THERE_IS_A_Treeview = 0
	Local $THERE_IS_A_slider = 0
	Local $THERE_IS_A_date = 0
	Local $THERE_IS_A_UPDOWN = 0
	Local $THERE_IS_A_progress = 0
	Local $THERE_IS_A_listbox = 0
	Local $THERE_IS_A_combo = 0

   ;Cache Datei niederschreiben
   _IniCloseFileEx($Cache_Datei_Handle)
   _IniCloseFileEx($Cache_Datei_Handle2)
   $Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
   $Cache_Datei_Handle2 = _IniOpenFile($Cache_Datei2)

	If Not _FileReadToArray($Cache_Datei, $aRecords) Then
		Return
	EndIf
	For $x = 1 To $aRecords[0]
		If StringInStr($aRecords[$x], "type=tab") > 0 Then $THERE_IS_A_TAB = 1
		If StringInStr($aRecords[$x], "type=ip") > 0 Then $THERE_IS_A_IP = 1
		If StringInStr($aRecords[$x], "type=treeview") > 0 Then $THERE_IS_A_Treeview = 1
		If StringInStr($aRecords[$x], "type=slider") > 0 Then $THERE_IS_A_slider = 1
		If StringInStr($aRecords[$x], "type=date") > 0 Then $THERE_IS_A_date = 1
		If StringInStr($aRecords[$x], "type=calendar") > 0 Then $THERE_IS_A_date = 1
		If StringInStr($aRecords[$x], "type=listview") > 0 Then $THERE_IS_A_Listview = 1
		If StringInStr($aRecords[$x], "type=edit") > 0 Then $THERE_IS_A_edit = 1
		If StringInStr($aRecords[$x], "type=input") > 0 Then $THERE_IS_A_edit = 1
		If StringInStr($aRecords[$x], "type=updown") > 0 Then $THERE_IS_A_UPDOWN = 1
		If StringInStr($aRecords[$x], "type=progress") > 0 Then $THERE_IS_A_progress = 1
		If StringInStr($aRecords[$x], "type=listbox") > 0 Then $THERE_IS_A_listbox = 1
		If StringInStr($aRecords[$x], "type=combo") > 0 Then $THERE_IS_A_combo = 1
	Next



	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	$anzahl = 0
	If @error Then
		Sleep(0)
	Else
		For $i = 1 To $var[0]
			$anzahl = $anzahl + 1
		Next
	EndIf
	$to_add_Pro_Element = 110 / $anzahl
	$fortschritt = 0 ; 0 %
	GUICtrlSetData($StudioFenster_inside_load, $fortschritt)
	If $fortschritt < 100 Then GUICtrlSetData($StudioFenster_inside_Text2, Int($fortschritt) & " %")


	$file = FileOpen($Temp_AU3_File, 2)
	If @error Then
		MsgBox(4096, "", "Form konnte nicht generiert werden!")
		Return
	EndIf

	;includes
	;Neu ab 0.97 auch die Includes werden in die ISF geschrieben, ABER nur als include once
;~ if $save = 0 then ;includes only for testmode
	If _IniReadEx($Cache_Datei_Handle, "gui", "isf_include_once", "false") = "true" Then
		FileWriteLine($file, '#include-once')
		FileWriteLine($file, '')
	EndIf

	FileWriteLine($file, '; -- Created with ISN Form Studio 2 for ISN AutoIt Studio -- ;')


	Local $Const_Modus = "variables"
	If _IniReadEx($Cache_Datei_Handle, "gui", "const_modus", "default") = "default" Then
		$Const_Modus = $FormStudio_Global_const_modus
	Else
		$Const_Modus = _IniReadEx($Cache_Datei_Handle, "gui", "const_modus", "variables")
	 EndIf



   if _IniReadEx($Cache_Datei_Handle, "gui", "only_controls_in_isf", "false") <> "true" OR $save = 0 Then
	if $Const_Modus = "variables" then ;Bei Magic Numbers werden keine Includes in die isf geschrieben
	FileWriteLine($file, '#include <StaticConstants.au3>')
	FileWriteLine($file, '#include <GUIConstantsEx.au3>')
	FileWriteLine($file, '#include <WindowsConstants.au3>')
	FileWriteLine($file, '#Include <GuiButton.au3>')
	If $THERE_IS_A_UPDOWN = 1 Then FileWriteLine($file, '#include <UpDownConstants.au3>')
	If $THERE_IS_A_Listview = 1 Then FileWriteLine($file, '#include <GuiListView.au3>')
	If $THERE_IS_A_slider = 1 Then FileWriteLine($file, '#include <SliderConstants.au3>')
	If $THERE_IS_A_slider = 1 Then FileWriteLine($file, '#include <GuiSlider.au3>')
	If $THERE_IS_A_TAB = 1 Then FileWriteLine($file, '#include <GuiTab.au3>')
	If $THERE_IS_A_IP = 1 Then FileWriteLine($file, '#Include <GuiIPAddress.au3>')
	If $THERE_IS_A_Treeview = 1 Then FileWriteLine($file, '#include <TreeViewConstants.au3>')
	If $THERE_IS_A_date = 1 Then FileWriteLine($file, '#include <DateTimeConstants.au3>')
	If $THERE_IS_A_edit = 1 Then FileWriteLine($file, '#include <EditConstants.au3>')
	If $THERE_IS_A_progress = 1 Then FileWriteLine($file, '#include <ProgressConstants.au3>')
	If $THERE_IS_A_listbox = 1 Then FileWriteLine($file, '#include <ListBoxConstants.au3>')
	If $THERE_IS_A_combo = 1 Then FileWriteLine($file, '#include <ComboConstants.au3>')
	If $MENUCONTROL_ID <> "" Then FileWriteLine($file, '#Include <GuiMenu.au3>')
	If $TOOLBARCONTROL_ID <> "" Then FileWriteLine($file, '#include <GuiToolbar.au3>')
	If $STATUSBARCONTROL_ID <> "" Then FileWriteLine($file, '#include <GuiStatusBar.au3>')
    Endif
;~ endif


	FileWriteLine($file, @CRLF)

   ;Extracode vor der GUI


	;gui
	If _IniReadEx($Cache_Datei_Handle, "gui", "codebeforegui", "") <> "" Then
		If _IniReadEx($Cache_Datei_Handle, "gui", "type", "") <> "tab" Then
			$data = _IniReadEx($Cache_Datei_Handle, "gui", "codebeforegui", "")
			$data = StringReplace($data, '$gui_handle', _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")), 0)
			$data = StringReplace($data, '[BREAK]', @CRLF, 0)
			if $Extracode_beim_Testen_Ignorieren = "1" AND $for_testing_only = 1 then
					   ;Extracode wird übersprungen
			   else
					   FileWriteLine($file, $data)
					   FileWriteLine($file, @CRLF)
			Endif
		 EndIf
	EndIf

	If _IniReadEx($Cache_Datei_Handle, "gui", "title_textmode", "normal") = "normal" And $for_testing_only = 0 Then
		$Gui_Titel = '"' & _IniReadEx($Cache_Datei_Handle, "gui", "title", "") & '"'
	Else
		$Gui_Titel = _IniReadEx($Cache_Datei_Handle, "gui", "title", "")
	EndIf

	$GUI_xpos = -1
	If _IniReadEx($Cache_Datei_Handle, "gui", "xpos", -1) <> -1 Then $GUI_xpos = _IniReadEx($Cache_Datei_Handle, "gui", "xpos", -1)
	$GUI_ypos = -1
	If _IniReadEx($Cache_Datei_Handle, "gui", "ypos", -1) <> -1 Then $GUI_ypos = _IniReadEx($Cache_Datei_Handle, "gui", "ypos", -1)

	$gui_style = -1
	$gui_exstyle = -1
	$gui_style = _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, "gui", "style", "-1"))
	$gui_exstyle = _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, "gui", "exstyle", "-1"),$for_testing_only)



	If _IniReadEx($Cache_Datei_Handle, "gui", "parent", "") = "" Then
		If $for_testing_only = 1 Then
			FileWriteLine($file, $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")) & ' = GUICreate("' & _IniReadEx($Cache_Datei_Handle, "gui", "title", "") & '",' & _IniReadEx($Cache_Datei_Handle, "gui", "breite", "") & ',' & _IniReadEx($Cache_Datei_Handle, "gui", "hoehe", "") & ',' & $GUI_xpos & ',' & $GUI_ypos & ',' & $gui_style & ',' & $gui_exstyle & ')')
		Else
			FileWriteLine($file, $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")) & ' = GUICreate(' & $Gui_Titel & ',' & _IniReadEx($Cache_Datei_Handle, "gui", "breite", "") & ',' & _IniReadEx($Cache_Datei_Handle, "gui", "hoehe", "") & ',' & $GUI_xpos & ',' & $GUI_ypos & ',' & $gui_style & ',' & $gui_exstyle & ')')

		EndIf
	Else
		If $for_testing_only = 1 Then
			FileWriteLine($file, $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")) & ' = GUICreate("' & _IniReadEx($Cache_Datei_Handle, "gui", "title", "") & '",' & _IniReadEx($Cache_Datei_Handle, "gui", "breite", "") & ',' & _IniReadEx($Cache_Datei_Handle, "gui", "hoehe", "") & ',' & $GUI_xpos & ',' & $GUI_ypos & ',' & $gui_style & ',' & $gui_exstyle & ')')
		Else
			FileWriteLine($file, $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")) & ' = GUICreate(' & $Gui_Titel & ',' & _IniReadEx($Cache_Datei_Handle, "gui", "breite", "") & ',' & _IniReadEx($Cache_Datei_Handle, "gui", "hoehe", "") & ',' & $GUI_xpos & ',' & $GUI_ypos & ',' & $gui_style & ',' & $gui_exstyle & ',' & _IniReadEx($Cache_Datei_Handle, "gui", "parent", "") & ')')
		EndIf
	EndIf

	;BGColour
	If _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "") = "none" And _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "") <> "0xF0F0F0" Then FileWriteLine($file, 'GUISetBkColor(' & _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "-1") & ',' & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")) & ')')

   ;GUI Events
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_close", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_CLOSE")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_close", "")&'", '&  _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_minimize", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_MINIMIZE")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_minimize", "")&'", '&  _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_restore", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_RESTORE")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_restore", "")&'", '&  _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_maximize", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_MAXIMIZE")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_maximize", "")&'", '&  _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_mousemove", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_MOUSEMOVE")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_mousemove", "")&'", '&  _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_primarydown", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_PRIMARYDOWN")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_primarydown", "")&'", '&  _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_primaryup", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_PRIMARYUP")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_primaryup", "")&'", '& _Handle_mit_Dollar_zurueckgeben( _IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_secoundarydown", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_SECONDARYDOWN")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_secoundarydown", "")&'", '& _Handle_mit_Dollar_zurueckgeben( _IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_secoundaryup", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_SECONDARYUP")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_secoundaryup", "")&'", '& _Handle_mit_Dollar_zurueckgeben( _IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_resized", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_RESIZED")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_resized", "")&'", '&  _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')
	If _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_dropped", "") <> "" Then FileWriteLine($file, 'GUISetOnEvent('&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_DROPPED")&', "'&_IniReadEx($Cache_Datei_Handle, "gui", "gui_event_dropped", "")&'", '& _Handle_mit_Dollar_zurueckgeben( _IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))&')')

	;BGImage
	If _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "") <> "none" Then
		Local $Bild_Pfad = _Return_Workdir(_IniReadEx($Cache_Datei_Handle, "gui", "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "")
		If _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "") = "" Then $Bild_Pfad = '"'
		FileWriteLine($file, $Handle_Deklaration & '$BGimage = GUICtrlCreatePic(' & $Bild_Pfad & '",0,0,' & _IniReadEx($Cache_Datei_Handle, "gui", "breite", 640) & ',' & _IniReadEx($Cache_Datei_Handle, "gui", "hoehe", 480) & ',' & _Style_in_fertiges_Format_ausgeben("$WS_CLIPSIBLINGS") & ')')
		FileWriteLine($file, 'guictrlsetstate(-1,$GUI_DISABLE)')
	 EndIf

  EndIf

	;Extracode
	If _IniReadEx($Cache_Datei_Handle, "gui", "code", "") <> "" Then
		If _IniReadEx($Cache_Datei_Handle, "gui", "type", "") <> "tab" Then
			$data = _IniReadEx($Cache_Datei_Handle, "gui", "code", "")
			$data = StringReplace($data, '$gui_handle', _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")), 0)
			$data = StringReplace($data, '[BREAK]', @CRLF, 0)
			if $Extracode_beim_Testen_Ignorieren = "1" AND $for_testing_only = 1 then
					   ;Extracode wird übersprungen
			   else
					   FileWriteLine($file, $data)
			Endif
		EndIf
	EndIf





	;Very first create the Menu
	If $MENUCONTROL_ID <> "" Then

		$Menu_INIString = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($MENUCONTROL_ID), "text", "")
		If $Menu_INIString <> "" Then
			_Menu_editor_Lade_aus_INIString($Menu_INIString)


			$RootString = _IniReadEx($MenuEditor_tempfile_handle, "root", "order", "")
			If $RootString <> "" Then
				If StringTrimLeft($RootString, StringLen($RootString) - 1) = "|" Then $RootString = StringTrimRight($RootString, 1)
				$RootSplit = StringSplit($RootString, "|", 2)
				If IsArray($RootSplit) Then
					For $y = 0 To UBound($RootSplit) - 1
						$Handle = _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "handle", "")
						$Text = _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "text", "")
						$func = _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "func", "")
						If _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "textmode", "text") = "text" Then
							$Textmodezeichen = '"'
						Else
							$Textmodezeichen = ""
						EndIf

						FileWriteLine($file, $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben($Handle) & ' = GUICtrlCreateMenu(' & $Textmodezeichen & $Text & $Textmodezeichen & ')')
						If $func <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1, "'&$func&'")')
						_AU3Converter_Menu_Lade_Childs($file, _Handle_mit_Dollar_zurueckgeben($Handle), _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "childs", "-1"), 0, $Handle_Deklaration)
					Next

				EndIf
			EndIf
		EndIf
	EndIf






	;FIRST CREATE TAB!!
	If $THERE_IS_A_TAB = 1 Then


		If _IniReadEx($Cache_Datei_Handle, "tab", "style", "-1") = "" Then
			$genstyle = -1
		Else
			$genstyle = _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, "tab", "style", "-1"))
		EndIf

		If _IniReadEx($Cache_Datei_Handle, "tab", "exstyle", "-1") = "" Then
			$genexstyle = -1
		Else
			$genexstyle = _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, "tab", "exstyle", "-1"))
		EndIf


		If _IniReadEx($Cache_Datei_Handle, "tab", "type", "") = "tab" Then

			If _IniReadEx($Cache_Datei_Handle, "tab", "textmode", "text") = "text" Then
				$Textmodezeichen = '"'
			Else
				$Textmodezeichen = ""
			EndIf
			If $for_testing_only = 1 Then $Textmodezeichen = '"'
			;Control & Style
			Global $ID_TAB = _IniReadEx($Cache_Datei_Handle, "tab", "id", "")
			FileWriteLine($file, $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "tab", "id", "")) & ' = GUICtrlCreatetab(' & _IniReadEx($Cache_Datei_Handle, "tab", "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, "tab", "y", "") & ',' & _
					_IniReadEx($Cache_Datei_Handle, "tab", "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, "tab", "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
			FileWriteLine($file, 'GuiCtrlSetState(-1,' & $GUI_ONTOP & ')')
			;Event
			If _IniReadEx($Cache_Datei_Handle, "tab", "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, "tab", "func", "") & '")')
			;State
			If _IniReadEx($Cache_Datei_Handle, "tab", "state", "") <> "$GUI_SHOW+$GUI_ENABLE" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, "tab", "state", "")) & ')')
			;Font
			If (_IniReadEx($Cache_Datei_Handle, "tab", "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, "tab", "fontsize", "-1") <> "8") Or (_IniReadEx($Cache_Datei_Handle, "tab", "fontstyle", "-1") <> "400") Or (_IniReadEx($Cache_Datei_Handle, "tab", "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, "tab", "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, "tab", "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, "tab", "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, "tab", "font", "MS Sans Serif") & '")')
			;Textcolour
			If _IniReadEx($Cache_Datei_Handle, "tab", "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, "tab", "textcolour", "-1") & '")')
			;BGColour
			If _IniReadEx($Cache_Datei_Handle, "tab", "bgcolour", "") <> "0xFFFFFF" And _IniReadEx($Cache_Datei_Handle, "tab", "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, "tab", "bgcolour", "-1") & '")')
			;Tooltip
			If _IniReadEx($Cache_Datei_Handle, "tab", "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, "tab", "tooltip", "") & $Textmodezeichen & ')')
			;Resize
			If _IniReadEx($Cache_Datei_Handle, "tab", "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, "tab", "resize", "") & ')')

			;Make Pages
			$pages = _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0")
			$page = 1
			While $page < $pages + 1
				If _IniReadEx($Cache_Datei_Handle, "TABPAGE" & $page, "textmode", "text") = "text" Then
					$Textmodezeichen = '"'
				Else
					$Textmodezeichen = ""
				EndIf
				If $for_testing_only = 1 Then $Textmodezeichen = '"'
				$Tabpage_Handle_FertigerText = ""
				$Tabpage_Handle = _IniReadEx($Cache_Datei_Handle, "TABPAGE" & $page, "handle", "")
				If $Tabpage_Handle <> "" Then
					$Tabpage_Handle_FertigerText = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben($Tabpage_Handle) & " = "
				EndIf

				FileWriteLine($file, $Tabpage_Handle_FertigerText & 'GUICtrlCreateTabItem(' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, "TABPAGE" & $page, "text", "#error#") & $Textmodezeichen & ')')
				$page = $page + 1
			WEnd
		EndIf

		;Extracode
		If _IniReadEx($Cache_Datei_Handle, "tab", "code", "") <> "" Then
			$data = _IniReadEx($Cache_Datei_Handle, "tab", "code", "")
			$data = StringReplace($data, '$control_handle', _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "tab", "id", "")), 0)
			$data = StringReplace($data, '[BREAK]', @CRLF, 0)
			if $Extracode_beim_Testen_Ignorieren = "1" AND $for_testing_only = 1 then
					   ;Extracode wird übersprungen
			else
					   FileWriteLine($file, $data)
			Endif
		EndIf


		FileWriteLine($file, 'GUICtrlCreateTabItem("")')
		;FileWriteLine($file,'GUISetState()')
		FileWriteLine($file, '_GUICtrlTab_SetCurFocus(' & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "tab", "id", "")) & ',' & - 1 & ')')


	EndIf

	;diverse controls

	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	$var = _sortiere_Controls_nach_Order($var)
	_IniReadSectionNamesEx($Cache_Datei_Handle2) ;Nochmal zum prüfen von @error
	If @error Then
		Sleep(0)
	Else
		$last_tabpage = -1
		For $i = 1 To $var[0]

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "style", "-1") = "" Then
				$genstyle = -1
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "toolbar" Then $genstyle = 0
			Else
				$genstyle = _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "style", "-1"))
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "exstyle", "-1") = "" Then
				$genexstyle = -1
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "toolbar" Then $genexstyle = 0
			Else
				$genexstyle = _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "exstyle", "-1"))
			EndIf



			If $THERE_IS_A_TAB = 1 Then
				$readenpage = _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "-1")
				If $readenpage <> $last_tabpage And $readenpage <> "-1" Then
					FileWriteLine($file, 'GUISwitch(' & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")) & ',_GUICtrlTab_SetCurFocus(' & _Handle_mit_Dollar_zurueckgeben($ID_TAB) & ',' & $readenpage & ')&GUICtrlRead (' & _Handle_mit_Dollar_zurueckgeben($ID_TAB) & ', 1))')
					$last_tabpage = $readenpage
				EndIf
			EndIf


			If $THERE_IS_A_TAB = 1 Then
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "-1") = "-1" And $last_tabpage <> -1 Then
					FileWriteLine($file, 'GUICtrlCreateTabItem("")')
					$last_tabpage = -1
				EndIf
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "textmode", "text") = "text" Then
				$Textmodezeichen = '"'
			Else
				$Textmodezeichen = ""
			EndIf
			If $for_testing_only = 1 Then $Textmodezeichen = '"'

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "button" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateButton(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "0xF0F0F0" And _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;ICO
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") <> "" Then
					$iconindex = _IniReadEx($Cache_Datei_Handle, $var[$i], "iconindex", "-1")
					If $iconindex = "" Then $iconindex = "-1"
					If $iconindex = "-1" Then
						FileWriteLine($file, 'GUICtrlSetImage(-1,' & _Return_Workdir(_IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & '")')
					Else
						FileWriteLine($file, 'GUICtrlSetImage(-1,' & _Return_Workdir(_IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & '",' & $iconindex & ')')
					EndIf
				EndIf
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf


			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "label" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateLabel(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")') ;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "input" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateInput(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "checkbox" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateCheckbox(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;ICO
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") <> "" Then
					$iconindex = _IniReadEx($Cache_Datei_Handle, $var[$i], "iconindex", "-1")
					If $iconindex = "" Then $iconindex = "-1"
					If $iconindex = "-1" Then
						FileWriteLine($file, 'GUICtrlSetImage(-1,' & _Return_Workdir(_IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & '")')
					Else
						FileWriteLine($file, 'GUICtrlSetImage(-1,' & _Return_Workdir(_IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & '",' & $iconindex & ')')
					EndIf
				EndIf
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "0xF0F0F0" And _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf


			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "radio" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateRadio(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "0xF0F0F0" And _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf


			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "image" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				Local $Bild_Pfad = _Return_Workdir(_IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "")
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") = "" Then $Bild_Pfad = '"'

			   if _IniReadEx($Cache_Datei_Handle, $var[$i], "textmode", "text") = "text" then
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreatePic(' & $Bild_Pfad & '",' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
					 Else
			   FileWriteLine($file, $IDSTRING & 'GUICtrlCreatePic(' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
			   endif



				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "slider" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateSlider(' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle  & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Data
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "text", "") <> 0 Then FileWriteLine($file, 'GUICtrlSetData(-1,' & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & ')')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "0xF0F0F0" And _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "progress" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateProgress(' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Data
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "text", "") <> 0 Then FileWriteLine($file, 'GUICtrlSetData(-1,' & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & ')')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "0xF0F0F0" And _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "updown" Then
				;Control & Style
				$Style_fuer_inputcontrol = "-1"
				If $genstyle <> "-1" And BitAND($genstyle, $ES_NUMBER) Then
					$Style_fuer_inputcontrol = $Default_Input + $ES_NUMBER
					$genstyle = $genstyle - $ES_NUMBER
				EndIf

				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateInput(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ', ' & $Style_fuer_inputcontrol & ',' & $genexstyle & ')')



				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
				;Updown
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", ""))&"_Updown" & ' = '
				FileWriteLine($file, $IDSTRING&'GUICtrlCreateUpdown(-1,' & $genstyle & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "icon" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				Local $Bild_Pfad = _Return_Workdir(_IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "")
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") = "" Then $Bild_Pfad = '"'
				$iconindex = _IniReadEx($Cache_Datei_Handle, $var[$i], "iconindex", "-1")
				If $iconindex = "" Then $iconindex = "-1"

				if _IniReadEx($Cache_Datei_Handle, $var[$i], "textmode", "text") = "text" then
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateIcon(' & $Bild_Pfad & '",' & $iconindex & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
					 Else
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateIcon(' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & ',' & $iconindex & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
			    EndIf

				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "combo" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateCombo("",' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				FileWriteLine($file, 'GUICtrlSetData(-1,' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "edit" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateEdit(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "group" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateGroup(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf


			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "listbox" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreatelist("",' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')

			   ;Text als Guictrlsetdata übergeben
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "text", "") <> "" Then FileWriteLine($file, 'GUICtrlSetData(-1,' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ')')

				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf


			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "date" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateDate(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "calendar" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateMonthCal(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf


			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "listview" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreatelistview(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf


			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "softbutton" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateButton(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')

				;ICO
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") <> "" Then FileWriteLine($file, 'GUICtrlSetImage(-1,' & _Return_Workdir() & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf


			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "ip" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & '_GUICtrlIpAddress_Create($' & _IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Data
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "text", "") <> "" Then FileWriteLine($file, '_GUICtrlIpAddress_Set($' & _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") & ',"' & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & '")')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "treeview" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateTreeView(' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ',' & $genexstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "com" Then
				;Control & Style
				$IDSTRING = ""
				$IDSTRING2 = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING2 = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & '_ctrl = '
				FileWriteLine($file, $IDSTRING & 'ObjCreate(' & $Textmodezeichen & StringReplace(_IniReadEx($Cache_Datei_Handle, $var[$i], "text", ""), "[BREAK]", '"&@crlf&"') & $Textmodezeichen & ')')
				FileWriteLine($file, $IDSTRING2 & 'GUICtrlCreateObj(' & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ')')

				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')

				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "dummy" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateDummy()')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "graphic" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & 'GUICtrlCreateGraphic(' & _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "") & ',' & _
						_IniReadEx($Cache_Datei_Handle, $var[$i], "width", "") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "") & ',' & $genstyle & ')')
				;Event
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") <> "" Then FileWriteLine($file, 'GUICtrlSetOnEvent(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "func", "") & '")')
				;State
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "$GUI_SHOW+$GUI_ENABLE" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "80" And _IniReadEx($Cache_Datei_Handle, $var[$i], "state", "") <> "" Then FileWriteLine($file, 'GUICtrlSetState(-1,' & _Style_in_fertiges_Format_ausgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "state", "")) & ')')
				;Font
				If (_IniReadEx($Cache_Datei_Handle, $var[$i], "font", "") <> "MS Sans Serif") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "") <> "8") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "") <> "400") Or (_IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "-1") <> "0") Then FileWriteLine($file, 'GUICtrlSetFont(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontsize", "8") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontstyle", "400") & ',' & _IniReadEx($Cache_Datei_Handle, $var[$i], "fontattribute", "0") & ',"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "font", "MS Sans Serif") & '")')
				;Textcolour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") <> "0x000000" Then FileWriteLine($file, 'GUICtrlSetColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "textcolour", "") & '")')
				;BGColour
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "0xF0F0F0" And _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") <> "" Then FileWriteLine($file, 'GUICtrlSetBkColor(-1,"' & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgcolour", "") & '")')
				;ICO
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") <> "" Then
					$iconindex = _IniReadEx($Cache_Datei_Handle, $var[$i], "iconindex", "-1")
					If $iconindex = "" Then $iconindex = "-1"
					If $iconindex = "-1" Then
						FileWriteLine($file, 'GUICtrlSetImage(-1,' & _Return_Workdir(_IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & '")')
					Else
						FileWriteLine($file, 'GUICtrlSetImage(-1,' & _Return_Workdir(_IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", ""), $save) & _IniReadEx($Cache_Datei_Handle, $var[$i], "bgimage", "") & '",' & $iconindex & ')')
					EndIf
				EndIf
				;Tooltip
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") <> "" Then FileWriteLine($file, 'GUICtrlSetTip(-1,' & $Textmodezeichen & _IniReadEx($Cache_Datei_Handle, $var[$i], "tooltip", "") & $Textmodezeichen & ')')
				;Resize
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") <> "" Then FileWriteLine($file, 'GUICtrlSetResizing(-1,' & _IniReadEx($Cache_Datei_Handle, $var[$i], "resize", "") & ')')
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "toolbar" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & '_GUICtrlToolbar_Create($' & _IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui") & ',' & $genstyle & ',' & $genexstyle & ')')

			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") = "statusbar" Then
				;Control & Style
				$IDSTRING = ""
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") <> "" Then $IDSTRING = $Handle_Deklaration & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")) & ' = '
				FileWriteLine($file, $IDSTRING & '_GUICtrlStatusBar_Create($' & _IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")& ', -1, "",' & $genstyle & ',' & $genexstyle & ')')

			EndIf

			;Extracode
			If _IniReadEx($Cache_Datei_Handle, $var[$i], "code", "") <> "" Then
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") <> "tab" Then
					$data = _IniReadEx($Cache_Datei_Handle, $var[$i], "code", "")

					If _IniReadEx($Cache_Datei_Handle, $var[$i], "id", "") = "" Then
						$data = StringReplace($data, '$control_handle', '-1', 0)
					Else
						$data = StringReplace($data, '$control_handle', _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, $var[$i], "id", "")), 0)
					EndIf
					$data = StringReplace($data, '[BREAK]', @CRLF, 0)
					if $Extracode_beim_Testen_Ignorieren = "1" AND $for_testing_only = 1 then
					   ;Extracode wird übersprungen
					   else
					   FileWriteLine($file, $data)
					 Endif
				EndIf
			EndIf











			$fortschritt = $fortschritt + $to_add_Pro_Element
			GUICtrlSetData($StudioFenster_inside_load, $fortschritt)
			If $fortschritt < 100 Then GUICtrlSetData($StudioFenster_inside_Text2, Int($fortschritt) & " %")

		Next
	EndIf


	GUICtrlSetData($StudioFenster_inside_Text2, "100 %")









	;end stuff
	If $THERE_IS_A_TAB = 1 Then FileWriteLine($file, '_GUICtrlTab_SetCurFocus(' & _Handle_mit_Dollar_zurueckgeben($ID_TAB) & ',0)')
	If $save = 0 Then
		FileWriteLine($file, 'GUISetState(@SW_SHOW,' & _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")) & ')')
		FileWriteLine($file, @CRLF)
		FileWriteLine($file, @CRLF)
		If $Menu_ICON_UDF_BENOETIGT = 1 Then
			Dim $iconUDF_text
			If _FileReadToArray(@ScriptDir & "\Data\UDF_menuicons.au3", $iconUDF_text) Then
				If IsArray($iconUDF_text) Then
					For $e = 1 To $iconUDF_text[0]
						FileWriteLine($file, $iconUDF_text[$e])
					Next
				EndIf
			EndIf
			FileWriteLine($file, @CRLF)
			FileWriteLine($file, @CRLF)
		EndIf
		FileWriteLine($file, 'While 1')
		FileWriteLine($file, '	$nMsg = GUIGetMsg()')
		FileWriteLine($file, '	Switch $nMsg')
		FileWriteLine($file, '		Case '&_Style_in_fertiges_Format_ausgeben("$GUI_EVENT_CLOSE"))
		FileWriteLine($file, '			Exit')
		FileWriteLine($file, @CRLF)
		FileWriteLine($file, '	EndSwitch')
		FileWriteLine($file, 'WEnd')
	EndIf
	FileClose($file)
	If $No_UI = 0 Then
		GUISetState(@SW_ENABLE, $StudioFenster)
		GUISetState(@SW_SHOW, $GUI_Editor)
		GUISetState(@SW_SHOW, $Formstudio_controleditor_GUI)
		GUICtrlSetState($StudioFenster_inside_Text1, $GUI_HIDE)
		GUICtrlSetState($StudioFenster_inside_Text2, $GUI_HIDE)
		GUICtrlSetState($StudioFenster_inside_Icon, $GUI_HIDE)
		GUICtrlSetState($StudioFenster_inside_load, $GUI_HIDE)
	EndIf
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	_SetStatustext(_ISNPlugin_Get_langstring(46))
	Sleep(100)
	If $show = 1 Then Run($AutoITEXE_Path & ' "' & $Temp_AU3_File & '"', @ScriptDir)
EndFunc   ;==>_TEST_FORM

Func _Copy_to_Clipboard()
	ClipPut(_ANSI2UNICODE(Sci_GetLines($sci)))
EndFunc   ;==>_Copy_to_Clipboard

Func _Save_AS_Au3()
	If FileExists($Temp_AU3_File) = 0 Then
		_TEST_FORM(0)
	EndIf
	$i = FileSaveDialog(_ISNPlugin_Get_langstring(70), $ISN_Studio_Projekt_WORKINGDIR_MODE3, "AutoIt Skript (*.au3)", 18, _IniReadEx($Cache_Datei_Handle, "gui", "title", "MyForm"))
	FileChangeDir(@ScriptDir)
	If $i = "" Then Return
	$check = $i
	If StringTrimLeft($check, StringLen($check) - 4) = ".au3" Then $i = StringTrimRight($i, 4)
	FileCopy($Temp_AU3_File, $i & ".au3", 9)
EndFunc   ;==>_Save_AS_Au3






