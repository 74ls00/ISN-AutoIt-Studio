
Func _ProjectISN_Write_in_Config($key, $value)
	IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", $key, $value)
EndFunc   ;==>_ProjectISN_Write_in_Config

Func _ProjectISN_Config_Read($key, $errorkey)
	$i = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", $key, $errorkey)
	Return $i
EndFunc   ;==>_ProjectISN_Config_Read


Func _Weitere_Einstellungen_zu_Projekteinstellungen()
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $aenderungs_manager_GUI)
	GUISetState(@SW_HIDE, $changelog_generieren_GUI)
	_Zeige_Projekteinstellungen("changelog")
EndFunc   ;==>_Weitere_Einstellungen_zu_Projekteinstellungen




Func _Zeige_Projekteinstellungen($Seite="")
	If $Studiomodus = 2 Then
		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(670), 0, $Studiofenster)
		Return
	EndIf

;~    	If $Templatemode = 1 Or $Tempmode = 1 Or $Studiomodus = 2 Then
;~ 		MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(386), 0, $studiofenster)
;~ 		Return
;~ 	EndIf

	GUICtrlSetData($projekteinstellungen_titel, _ProjectISN_Config_Read("name", "") & " - " & _Get_langstr(1078))
	WinSetTitle($Projekteinstellungen_GUI, "", _ProjectISN_Config_Read("name", "") & " - " & _Get_langstr(1078))

   _Load_Compiler_settings()
   _Projekteinstellungen_Lade_Projekteigenschaften()

   guictrlsetdata($projekteinstellungen_kompilieren_Ordnerpfad_input,_ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%"))

	If _ProjectISN_Config_Read("use_changelog_manager", "false") = "true" Then
		GUICtrlSetState($Projekteinstellungen_aenderungsprotokolle_aktivieren_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Projekteinstellungen_aenderungsprotokolle_aktivieren_checkbox, $GUI_UNCHECKED)
	EndIf

	If _ProjectISN_Config_Read("changelog_use_author_from_project", "false") = "true" Then
		GUICtrlSetState($Projekteinstellungen_aenderungsprotokolle_verwende_autor_aus_projekt_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Projekteinstellungen_aenderungsprotokolle_verwende_autor_aus_projekt_checkbox, $GUI_UNCHECKED)
	EndIf

   GUICtrlSetData($projekteinstellungen_temp_au3_ordner_input, _ProjectISN_Config_Read("temp_script_path", "%projectdir%\Temp"))
   GUICtrlSetData($projekteinstellungen_temp_au3_name_input, _ProjectISN_Config_Read("temp_script_name", "Tempscript_%count%"))

	switch _ProjectISN_Config_Read("temp_script_delete_mode", "2")
	   case "1"
		GUICtrlSetState($projekteinstellungen_temp_au3_loeschen_radio, $GUI_CHECKED)
	   case "2"
		GUICtrlSetState($projekteinstellungen_temp_au3_fragen_radio, $GUI_CHECKED)
	 case "3"
		GUICtrlSetState($projekteinstellungen_temp_au3_nichts_radio, $GUI_CHECKED)
	EndSwitch




	_Projekteinstellungen_Event()

    if $Seite <> "" Then
	  switch $Seite
		 case "compile"
			GUICtrlSetState($Projekteinstellungen_compile_tab, $GUI_SHOW)
			_GUICtrlTreeView_SelectItem ($projekteinstellungen_navigation,$projekteinstellungen_kompilierungseinstellungen)

		 case "changelog"
			GUICtrlSetState($Projekteinstellungen_changelog_tab, $GUI_SHOW)
			_GUICtrlTreeView_SelectItem ($projekteinstellungen_navigation,$projekteinstellungen_navigation_aenderungsprotokolle)

		 case "projectproperties"
			GUICtrlSetState($Projekteinstellungen_eigenschaften_tab, $GUI_SHOW)
			_GUICtrlTreeView_SelectItem ($projekteinstellungen_navigation,$projekteinstellungen_navigation_Eigenschaften)
			If _Pruefe_auf_Type3_Plugin($Plugin_Platzhalter_Projekteigenschaften) <> -1 then return ;Platzhalter für Plugin

	  EndSwitch
    EndIf

   ;Globale APIs in Liste Laden
   _API_Pfade_in_Listview_Laden() ;Global
   _Projekteinstellungen_API_Pfade_in_Listview_Laden() ;Projekt

   AdlibRegister("_Projekteinstellungen_Ordnerstruktur_aktualisiere_label",1000)
	GUISetState(@SW_SHOW, $Projekteinstellungen_GUI)
	GUISetState(@SW_DISABLE, $StudioFenster)
 EndFunc   ;==>_Zeige_Projekteinstellungen

func _Projekteinstellungen_Weitere_Dateien_zum_kompilieren()
_Projekteinstellungen_OK()
_Weitere_Dateien_zum_Kompilieren_waehlen()
EndFunc


Func _Projekteinstellungen_Lade_Projekteigenschaften()

	$isnpath = $Pfad_zur_Project_ISN
    $isndatei_name = StringTrimLeft($isnpath,StringInStr($isnpath,"\",0,-1))
	GUICtrlSetData($projekteinstellungen_projekt_titel, IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "name", ""))
	GUICtrlSetData($projekteinstellungen_projekt_version_und_autor, "v. "&IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", "")&@crlf&"by "&IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", ""))
	$sizeF = DirGetSize($Offenes_Projekt, 1)
	$files = $sizeF[1]
	$folders = $sizeF[2]
	$sizeF[0] = Round($sizeF[0] / 1024)
	If $sizeF[0] > 1024 Then
		$sizeF[0] = Round($sizeF[0] / 1024) & " MB"
	Else
		$sizeF[0] = $sizeF[0] & " KB"
	EndIf

	$time = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "time", "0")
	$hms = Int($time * 360000)
	$mms = Int($time * 60000)
	$sms = Int($time * 1000)

	Local $timer, $Secs, $Mins, $Hour, $time
    $dif = TimerDiff($Project_timer)
	$dif = Int($dif)
	$time = $dif +$Pause_time+IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "time", "0")
	_TicksToTime($time, $Hour, $Mins, $Secs)

	$var = IniReadSectionNames($isnpath)
	$Anzahl_Makros_im_Projekt = 0
	If @error Then
		MsgBox(4096, "", "Error reading .isn file!")
	Else
		For $i = 1 To $var[0]
			If StringInStr($var[$i], "#isnrule#") Then
				$Anzahl_Makros_im_Projekt = $Anzahl_Makros_im_Projekt + 1
			EndIf
		Next
	EndIf

	_GUICtrlListView_BeginUpdate($Project_Properties_listview)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Project_Properties_listview))

	;Projektname
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(368), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "name", ""), 1)

	;Version
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(217), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "version", ""), 1)

	;Name der Hauptdatei
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(16), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "mainfile", ""), 1)

	;Name der Projektdatei
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(1116), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, $isndatei_name, 1)

	;Kommentar
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(133), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "comment", ""), 1)

	;Author
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(369), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "author", ""), 1)

	;Erstellt am
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(171), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "date", ""), 1)

	;Erstellt mit Studioversion
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(224), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "studioversion", ""), 1)


	;Größe
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(220), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, $sizeF[0], 1)

	;Anzahl Dateien/Ordner
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(221), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, $files & " " & _Get_langstr(222) & "  /  " & $folders & " " & _Get_langstr(223), 1)

	;Zeit
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(225), 0)
	if $Tempmode = 0 Then
	   _GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, $Hour & "h " & $Mins & "m " & $Secs & "s", 1)
	Else
	  _GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, "-", 1)
	Endif

	;Wie oft geöffnet
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(397), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, IniRead($isnpath, "ISNAUTOITSTUDIO", "projectopened", "") & "x", 1)

	;Makros Anzahl
	_GUICtrlListView_AddItem($Project_Properties_listview, _Get_langstr(707), 0)
	_GUICtrlListView_AddSubItem($Project_Properties_listview, _GUICtrlListView_GetItemCount($Project_Properties_listview) - 1, $Anzahl_Makros_im_Projekt, 1)

	_GUICtrlListView_EndUpdate($Project_Properties_listview)



EndFunc   ;==>_Zeige_Projekteinstellungen("projectproperties")

Func _Projekteinstellungen_Navigation_Event()
	AdlibUnRegister("_Projekteinstellungen_Navigation_Event")
	$mark = _GUICtrlTreeView_GetText($projekteinstellungen_navigation, _GUICtrlTreeView_GetSelection($projekteinstellungen_navigation))
	If $mark = "" Then Return
	If $mark = _Get_langstr(911) Then
		If _GUICtrlTab_GetCurSel($projekteinstellungen_dummytab) <> 0 Then GUICtrlSetState($Projekteinstellungen_changelog_tab, $GUI_SHOW)
	EndIf

	If $mark = _Get_langstr(563) Then
		If _GUICtrlTab_GetCurSel($projekteinstellungen_dummytab) <> 1 Then GUICtrlSetState($Projekteinstellungen_compile_tab, $GUI_SHOW)
   EndIf

   If $mark = _Get_langstr(51) Then
		If _GUICtrlTab_GetCurSel($projekteinstellungen_dummytab) <> 2 Then GUICtrlSetState($Projekteinstellungen_eigenschaften_tab, $GUI_SHOW)
   EndIf

   If $mark = _Get_langstr(1092) Then
		If _GUICtrlTab_GetCurSel($projekteinstellungen_dummytab) <> 3 Then GUICtrlSetState($Projekteinstellungen_hauptdatei_tab, $GUI_SHOW)
	EndIf

   If $mark = _Get_langstr(1095) Then
		If _GUICtrlTab_GetCurSel($projekteinstellungen_dummytab) <> 4 Then GUICtrlSetState($Projekteinstellungen_temporaere_au3, $GUI_SHOW)
   EndIf

   If $mark = _Get_langstr(1121) Then
		If _GUICtrlTab_GetCurSel($projekteinstellungen_dummytab) <> 5 Then GUICtrlSetState($Projekteinstellungen_APIs_Tab, $GUI_SHOW)
   EndIf

 EndFunc

Func _Projekteinstellungen_Event()

	If GUICtrlRead($Projekteinstellungen_aenderungsprotokolle_aktivieren_checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($Projekteinstellungen_aenderungsprotokolle_verwende_autor_aus_projekt_checkbox, $GUI_ENABLE)
	Else
		GUICtrlSetState($Projekteinstellungen_aenderungsprotokolle_verwende_autor_aus_projekt_checkbox, $GUI_DISABLE)
	EndIf

EndFunc   ;==>_Projekteinstellungen_Event



Func _Projekteinstellungen_OK()
    $Einstellungen_Eingabefeld_Text = GUICtrlRead($projekteinstellungen_kompilieren_Ordnerpfad_input)
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "?", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "=", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, ",", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, '"', "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "<", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, ">", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "*", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "|", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "\\", "")
	$Einstellungen_Eingabefeld_Text = StringStripWS($Einstellungen_Eingabefeld_Text,3)
	if stringleft($Einstellungen_Eingabefeld_Text,1) = "\" then $Einstellungen_Eingabefeld_Text = StringTrimLeft($Einstellungen_Eingabefeld_Text,1)
	$Einstellungen_Eingabefeld_Text = _WinAPI_PathRemoveBackslash ($Einstellungen_Eingabefeld_Text)
	GUICtrlSetData($projekteinstellungen_kompilieren_Ordnerpfad_input,$Einstellungen_Eingabefeld_Text)


    If GUICtrlRead($Kompilieren_Einstellungen_Projekt_in_Ordner_Bereitstellen_Checkbox) = $GUI_CHECKED Then
	  if guictrlread($projekteinstellungen_kompilieren_Ordnerpfad_input) = "" Then
	  GUICtrlSetState($Projekteinstellungen_compile_tab, $GUI_SHOW)
	  _Input_Error_FX($projekteinstellungen_kompilieren_Ordnerpfad_input)
	  return
	  EndIf
   EndIf


   if guictrlread($projekteinstellungen_temp_au3_ordner_input) = "" Then
	  GUICtrlSetState($Projekteinstellungen_temporaere_au3, $GUI_SHOW)
	  _Input_Error_FX($projekteinstellungen_temp_au3_ordner_input)
	  return
   EndIf

   if guictrlread($projekteinstellungen_temp_au3_name_input) = "" Then
	  GUICtrlSetState($Projekteinstellungen_temporaere_au3, $GUI_SHOW)
	  _Input_Error_FX($projekteinstellungen_temp_au3_name_input)
	  return
   EndIf

    AdlibUnRegister("_Projekteinstellungen_Ordnerstruktur_aktualisiere_label")
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Projekteinstellungen_GUI)

   _ProjectISN_Write_in_Config("temp_script_path",guictrlread($projekteinstellungen_temp_au3_ordner_input))
   if not StringInStr(guictrlread($projekteinstellungen_temp_au3_name_input),"%count%") then GUICtrlSetData($projekteinstellungen_temp_au3_name_input,GUICtrlRead($projekteinstellungen_temp_au3_name_input)&"%count%")
   _ProjectISN_Write_in_Config("temp_script_name",guictrlread($projekteinstellungen_temp_au3_name_input))

   If GUICtrlRead($projekteinstellungen_temp_au3_loeschen_radio) = $GUI_CHECKED Then _ProjectISN_Write_in_Config("temp_script_delete_mode","1")
   If GUICtrlRead($projekteinstellungen_temp_au3_fragen_radio) = $GUI_CHECKED Then _ProjectISN_Write_in_Config("temp_script_delete_mode","2")
   If GUICtrlRead($projekteinstellungen_temp_au3_nichts_radio) = $GUI_CHECKED Then _ProjectISN_Write_in_Config("temp_script_delete_mode","3")




   _ProjectISN_Write_in_Config("compile_finished_project_dir",guictrlread($projekteinstellungen_kompilieren_Ordnerpfad_input))

	If GUICtrlRead($Projekteinstellungen_aenderungsprotokolle_aktivieren_checkbox) = $GUI_CHECKED Then
		_ProjectISN_Write_in_Config("use_changelog_manager", "true")
	Else
		_ProjectISN_Write_in_Config("use_changelog_manager", "false")
	EndIf

	If GUICtrlRead($Projekteinstellungen_aenderungsprotokolle_verwende_autor_aus_projekt_checkbox) = $GUI_CHECKED Then
		_ProjectISN_Write_in_Config("changelog_use_author_from_project", "true")
	Else
		_ProjectISN_Write_in_Config("changelog_use_author_from_project", "false")
	EndIf

   _save_Compiler_settings()
   _Projekteinstellungen_API_Pfade_abspeichern()
   _Skripteditor_APIs_und_properties_neu_einlesen()
   _Neue_APIs_und_properties_an_Scintilla_controls_senden()





EndFunc   ;==>_Projekteinstellungen_OK

Func _Neue_APIs_und_properties_an_Scintilla_controls_senden()

	If $Offenes_Projekt = "" Then Return
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
	For $x = 0 To $Offene_tabs - 1
		If $Plugin_Handle[$x] = -1 Then

;properties und APIs setzen
SendMessageString($SCE_EDITOR[$x], $SCI_SETKEYWORDS, 1, $au3_keywords_functions)
SendMessageString($SCE_EDITOR[$x], $SCI_SETKEYWORDS, 0, $au3_keywords_keywords)
SendMessageString($SCE_EDITOR[$x], $SCI_SETKEYWORDS, 2, $au3_keywords_macros)
SendMessageString($SCE_EDITOR[$x], $SCI_SETKEYWORDS, 4, $au3_keywords_preprocessor)
SendMessageString($SCE_EDITOR[$x], $SCI_SETKEYWORDS, 3, $au3_keywords_sendkeys)
SendMessageString($SCE_EDITOR[$x], $SCI_SETKEYWORDS, 7, $UDF_Keywords)
SendMessageString($SCE_EDITOR[$x], $SCI_SETKEYWORDS, 5, $special_Keywords)
SendMessageString($SCE_EDITOR[$x], $SCI_SETKEYWORDS, 6, $au3_keywords_abbrev)

		EndIf
	Next
endfunc




Func _Projekteinstellungen_Abbrechen()
   AdlibUnRegister("_Projekteinstellungen_Ordnerstruktur_aktualisiere_label")
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Projekteinstellungen_GUI)
EndFunc   ;==>_Projekteinstellungen_Abbrechen


Func _Projekteinstellungen_Zeige_Aenderungsprotokolle()
	_Projekteinstellungen_OK()
	_Zeige_changelogmanager()
EndFunc   ;==>_Projekteinstellungen_Zeige_Aenderungsprotokolle

Func _Projekteinstellungen_Hyperlinks_preufen()
	$CursorInfo = GUIGetCursorInfo($Projekteinstellungen_GUI)
	If Not IsArray($CursorInfo) Then Return
	If $Hyperlink_Old_Control = $CursorInfo[4] Then Return
	$Hyperlink_Old_Control = $CursorInfo[4]
	Switch $CursorInfo[4]

		Case $projekteinstellungen_aenderungsprotokolle_hyperlink
			_Hyperlink_Label_Hover($projekteinstellungen_aenderungsprotokolle_hyperlink)
			Return

		Case $projekteinstellungen_kompilieren_dateien_auswaehlen_hyperlink1
			_Hyperlink_Label_Hover($projekteinstellungen_kompilieren_dateien_auswaehlen_hyperlink1)
			Return

		 Case $projekteinstellungen_kompilieren_WrapperGUI_Hyperlink1
			_Hyperlink_Label_Hover($projekteinstellungen_kompilieren_WrapperGUI_Hyperlink1)
			Return

		 Case $projekteinstellungen_kompilieren_hauptdatei_auendern_hyperlink1
			_Hyperlink_Label_Hover($projekteinstellungen_kompilieren_hauptdatei_auendern_hyperlink1)
			Return

		Case $projekteinstellungen_kompilieren_dateien_auswaehlen_hyperlink2
			_Hyperlink_Label_Hover($projekteinstellungen_kompilieren_dateien_auswaehlen_hyperlink2)
			Return

		 Case $projekteinstellungen_kompilieren_WrapperGUI_Hyperlink2
			_Hyperlink_Label_Hover($projekteinstellungen_kompilieren_WrapperGUI_Hyperlink2)
			Return

		 Case $projekteinstellungen_kompilieren_hauptdatei_auendern_hyperlink2
			_Hyperlink_Label_Hover($projekteinstellungen_kompilieren_hauptdatei_auendern_hyperlink2)
			Return

		 Case $projekteinstellungen_APIs_Programmeinstellungen_hyperlink1
			_Hyperlink_Label_Hover($projekteinstellungen_APIs_Programmeinstellungen_hyperlink1)
			Return

	EndSwitch
	_Hyperlink_Label_Hover_Reset()


EndFunc   ;==>_Projekteinstellungen_Hyperlinks_preufen

func _Weitere_Dateien_zum_Kompilieren_waehlen_hyperlink()
   _Projekteinstellungen_OK()
   _Weitere_Dateien_zum_Kompilieren_waehlen()
EndFunc


Func _Hyperlink_Label_Hover($Control = "")
	If $Control = "" Then Return
	If $Hyperlink_unterstrichen <> 0 Then _Hyperlink_Label_Hover_Reset()
	$Hyperlink_unterstrichen = $Control
	GUICtrlSetFont($Control, 9, 400, 4)
EndFunc   ;==>_Hyperlink_Label_Hover

Func _Hyperlink_Label_Hover_Reset()
	If $Hyperlink_unterstrichen = 0 Then Return
	GUICtrlSetFont($Hyperlink_unterstrichen, 9, 400, 0)
	$Hyperlink_unterstrichen = 0
EndFunc   ;==>_Hyperlink_Label_Hover_Reset

func _Projekteinstellungen_Wrapper_Hyperlink()
if _ProjectISN_Config_Read("mainfile", "") = "" then return
_Projekteinstellungen_OK()
Try_to_opten_file($Offenes_Projekt & "\" & _ProjectISN_Config_Read("mainfile", ""))
_Zeige_AutoIt3Wrapper_GUI()
EndFunc

func _Projekteinstellungen_Ordnerstruktur_aktualisiere_label()
local $zielpfad = ""

		If $releasemode = 1 Then
			$zielpfad = _ISN_Variablen_aufloesen($releasefolder)
		EndIf

		If $releasemode = 2 Then
			$zielpfad = $Offenes_Projekt & "\" & _ISN_Variablen_aufloesen($releasefolder)
		EndIf


$Einstellungen_Eingabefeld_Text = GUICtrlRead($projekteinstellungen_kompilieren_Ordnerpfad_input)

    If $releasemode = "2" Then $Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text,"%projectname%","")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "?", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "=", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, ",", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, '"', "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "<", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, ">", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "*", "")
	$Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text, "|", "")
	  $Einstellungen_Eingabefeld_Text = StringReplace($Einstellungen_Eingabefeld_Text,"\\","")
   if stringleft($Einstellungen_Eingabefeld_Text,1) = "\" then $Einstellungen_Eingabefeld_Text = StringTrimLeft($Einstellungen_Eingabefeld_Text,1)
$Einstellungen_Eingabefeld_Text = _ISN_Variablen_aufloesen($Einstellungen_Eingabefeld_Text)
if $Einstellungen_Eingabefeld_Text <> "" then $Einstellungen_Eingabefeld_Text = "\"&$Einstellungen_Eingabefeld_Text

GUICtrlSetData($projekteinstellungen_kompilieren_Ordnerpfad_vorschau_label,_Get_langstr(1039)&@crlf&$zielpfad&$Einstellungen_Eingabefeld_Text)


EndFunc


func _Projekteinstellungen_Temp_Script_Standard_wiederherstellen()
GUICtrlSetState($projekteinstellungen_temp_au3_fragen_radio, $GUI_CHECKED)
GUICtrlSetData($projekteinstellungen_temp_au3_ordner_input,"%projectdir%\Temp")
GUICtrlSetData($projekteinstellungen_temp_au3_name_input,"Tempscript_%count%")
EndFunc


func _Projekteinstellungen_Hyperlink_zu_globalen_APIs()
_Projekteinstellungen_OK()
GUICtrlSetState($config_Sheet_API_Pfade, $GUI_SHOW)
_GUICtrlTreeView_SelectItem ($config_selectorlist, $config_Programmpfade_APIs)
_Show_Configgui()
EndFunc


func _Projekteinstellungen_API_Pfad_entfernen()
if _GUICtrlListView_GetSelectionMark($Projekteinstellungen_API_Listview) = -1 then return
if _GUICtrlListView_GetItemText($Projekteinstellungen_API_Listview,_GUICtrlListView_GetSelectionMark($Projekteinstellungen_API_Listview),1) = "1" Then
   msgbox(262144 + 16, _Get_langstr(25), _Get_langstr(1176), 0, $Projekteinstellungen_GUI)
   Return
EndIf
_GUICtrlListView_DeleteItem($Projekteinstellungen_API_Listview,_GUICtrlListView_GetSelectionMark($Projekteinstellungen_API_Listview))
_GUICtrlListView_SetItemSelected ($Projekteinstellungen_API_Listview,_GUICtrlListView_GetSelectionMark($Projekteinstellungen_API_Listview),True ,True)
EndFunc

func _Projekteinstellungenn_Properties_Pfad_entfernen()
if _GUICtrlListView_GetSelectionMark($Projekteinstellungen_Proberties_Listview) = -1 then return
if _GUICtrlListView_GetItemText($Projekteinstellungen_Proberties_Listview,_GUICtrlListView_GetSelectionMark($Projekteinstellungen_Proberties_Listview),1) = "1" Then
   msgbox(262144 + 16, _Get_langstr(25), _Get_langstr(1176), 0, $Projekteinstellungen_GUI)
   Return
EndIf
_GUICtrlListView_DeleteItem($Projekteinstellungen_Proberties_Listview,_GUICtrlListView_GetSelectionMark($Projekteinstellungen_Proberties_Listview))
_GUICtrlListView_SetItemSelected ($Projekteinstellungen_Proberties_Listview,_GUICtrlListView_GetSelectionMark($Projekteinstellungen_Proberties_Listview),True ,True)
EndFunc

func _Projekteinstellungen_Properties_Pfad_hinzufuegen()
$Ordnerpfad = FileSelectFolder (_Get_langstr(298),$Offenes_Projekt,7,"",$Projekteinstellungen_GUI)
if $Ordnerpfad = "" OR @error then Return
FileChangeDir(@ScriptDir)
if not _IsDir($Ordnerpfad) then return
if _WinAPI_PathIsRoot($Ordnerpfad) then return
if _GUICtrlListView_FindText ($Projekteinstellungen_Proberties_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad,1),-1) = -1 then _GUICtrlListView_AddItem($Projekteinstellungen_Proberties_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad), 0)
EndFunc

func _Projekteinstellungen_API_Pfad_hinzufuegen()
$Ordnerpfad = FileSelectFolder (_Get_langstr(298),$Offenes_Projekt,7,"",$Projekteinstellungen_GUI)
if $Ordnerpfad = "" OR @error then Return
FileChangeDir(@ScriptDir)
if not _IsDir($Ordnerpfad) then return
if _WinAPI_PathIsRoot($Ordnerpfad) then return
if _GUICtrlListView_FindText ($Projekteinstellungen_API_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad,1),-1) = -1 then _GUICtrlListView_AddItem($Projekteinstellungen_API_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad), 0)
EndFunc


func _Projekteinstellungen_API_Pfade_abspeichern()
local $Fertiger_String = ""

;API Ordner
for $x = 0 To _GUICtrlListView_GetItemCount($Projekteinstellungen_API_Listview)
   if _GUICtrlListView_GetItemText ($Projekteinstellungen_API_Listview,$x) = "" then ContinueLoop
   if _GUICtrlListView_GetItemText($Projekteinstellungen_API_Listview,$x,1) = "1" Then  ContinueLoop ;Globale Einträge ignorieren
   $Fertiger_String = $Fertiger_String&_GUICtrlListView_GetItemText ($Projekteinstellungen_API_Listview,$x)&"|"
Next
if StringRight($Fertiger_String,1) = "|" then $Fertiger_String = StringTrimRight($Fertiger_String,1)
_ProjectISN_Write_in_Config("additional_api_folders", $Fertiger_String)

;Properties Ordner
$Fertiger_String = ""
for $x = 0 To _GUICtrlListView_GetItemCount($Projekteinstellungen_Proberties_Listview)
   if _GUICtrlListView_GetItemText($Projekteinstellungen_Proberties_Listview,$x,1) = "1" Then  ContinueLoop ;Globale Einträge ignorieren
   if _GUICtrlListView_GetItemText ($Projekteinstellungen_Proberties_Listview,$x) = "" then ContinueLoop
   $Fertiger_String = $Fertiger_String&_GUICtrlListView_GetItemText ($Projekteinstellungen_Proberties_Listview,$x)&"|"
Next
if StringRight($Fertiger_String,1) = "|" then $Fertiger_String = StringTrimRight($Fertiger_String,1)
_ProjectISN_Write_in_Config("additional_properties_folders", $Fertiger_String)
EndFunc



func _Projekteinstellungen_API_Pfade_in_Listview_Laden()
;Benutzerdefinierte Einträge hinzufügen
$Projekt_API_Ordner_String = _ProjectISN_Config_Read("additional_api_folders","")

if $Projekt_API_Ordner_String <> "" Then
   $Orner_Array = StringSplit($Projekt_API_Ordner_String,"|",2)
   if IsArray($Orner_Array) Then
	  for $index = 0 to ubound($Orner_Array)-1
		 if $Orner_Array[$index] = "" then ContinueLoop
		 if $Orner_Array[$index] = "%isnstudiodir%\Data\Api" then ContinueLoop
		 if $Orner_Array[$index] = "%myisndatadir%\Data\Api" then ContinueLoop
		 _GUICtrlListView_AddItem($Projekteinstellungen_API_Listview, $Orner_Array[$index], 0)
	  Next
   Endif
EndIf

$Projekt_Proberties_Ordner_String = _ProjectISN_Config_Read("additional_properties_folders","")

if $Projekt_Proberties_Ordner_String <> "" Then
   $Orner_Array = StringSplit($Projekt_Proberties_Ordner_String,"|",2)
   if IsArray($Orner_Array) Then
	  for $index = 0 to ubound($Orner_Array)-1
		 if $Orner_Array[$index] = "" then ContinueLoop
		 if $Orner_Array[$index] = "%isnstudiodir%\Data\Properties" then ContinueLoop
		 if $Orner_Array[$index] = "%myisndatadir%\Data\Properties" then ContinueLoop
		 _GUICtrlListView_AddItem($Projekteinstellungen_Proberties_Listview, $Orner_Array[$index], 0)
	  Next
   Endif
EndIf
endfunc