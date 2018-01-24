
#include "..\Forms\ISN_Ersteinrichtung.isf" ;Ersteinrichtungs GUI

func _Ersteinrichtung_weiter()
	$index = _GUICtrlTab_GetCurFocus($tab_ersteinrichtung) + 1
	if $index < _GUICtrlTab_GetItemCount($tab_ersteinrichtung) then
		if _Ersteinrichtung_Pruefe_Buttons($index) = 1 then _GUICtrlTab_ActivateTab($tab_ersteinrichtung, $index)
	endif
endfunc

func _Ersteinrichtung_zurueck()
	$index = _GUICtrlTab_GetCurFocus($tab_ersteinrichtung) - 1
	if $index > -1 then
		if _Ersteinrichtung_Pruefe_Buttons($index) = 1 then _GUICtrlTab_ActivateTab($tab_ersteinrichtung, $index)
	endif
endfunc

func _Ersteinrichtung_Pruefe_Buttons($tab = 0)
	GUICtrlSetState($Ersteinrichtung_Zurueck_Button, $GUI_ENABLE)
	GUICtrlSetState($Ersteinrichtung_Weiter_Button, $GUI_ENABLE)
	GUICtrlSetdata($Ersteinrichtung_Weiter_Button, _Get_langstr(622))
	GUICtrlSetOnEvent($Ersteinrichtung_Weiter_Button, "_Ersteinrichtung_weiter")
	switch $tab

		case 0
			GUICtrlSetState($Ersteinrichtung_Zurueck_Button, $GUI_DISABLE)

		case 1
			if not _Directory_Is_Accessible(@scriptdir) Then
				GUICtrlSetState($Ersteinrichtung_portable_mode_button, $GUI_DISABLE)
			Else
				GUICtrlSetState($Ersteinrichtung_portable_mode_button, $GUI_ENABLE)
			EndIf
			GUICtrlSetState($Ersteinrichtung_Weiter_Button, $GUI_DISABLE)

		case 3
			if _GUICtrlTab_GetCurFocus($tab_ersteinrichtung) = 2 AND guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) <> "" AND GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_UNCHECKED Then
				$antwort = MsgBox(262144 + 4 + 48, _Get_langstr(48), _Get_langstr(781), 0, $first_startup)
				if $antwort = 7 then return 0
			endif

			if 	guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" AND GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_CHECKED Then
			   _Input_Error_FX($Ersteinrichtung_Datenuebernahme_config_pfad_input)
			   return 0
			endif

			;Default Werte für Verzeichnisse

			if $Erstkonfiguration_Mode = "normal" Then
				if guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, @MyDocumentsDir & "\ISN AutoIt Studio")
				if guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, $Standardordner_Projects)
				if guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, $Standardordner_Templates)
				if guictrlread($Ersteinrichtung_Verzeichnisse_Backups_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_Backups_input, $Standardordner_Backups)
				if guictrlread($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, $Standardordner_Release)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Backups_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt1, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt2, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt3, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt4, $GUI_ENABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt5, $GUI_ENABLE)

			Else
				guictrlsetdata($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, @scriptdir)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Backups_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt1, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt2, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt3, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt4, $GUI_DISABLE)
				GUICtrlSetState($Ersteinrichtung_Verzeichnisse_bt5, $GUI_DISABLE)
				if guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, $Standardordner_Projects)
				if guictrlread($Ersteinrichtung_Verzeichnisse_Backups_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_Backups_input, $Standardordner_Backups)
				if guictrlread($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, $Standardordner_Release)
				if guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input) = "" then guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, $Standardordner_Templates)
			endif

		case 4
			if _GUICtrlTab_GetCurFocus($tab_ersteinrichtung) = 3 then
			  $Arbeitsverzeichnis = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
			if $Erstkonfiguration_Mode = "normal" Then
				if _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input))) = false then
				_Input_Error_FX($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
				return
				endif

				if _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Backups_input))) = false then
				_Input_Error_FX($Ersteinrichtung_Verzeichnisse_Backups_input)
				return
				endif

				if _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))) = false then
				_Input_Error_FX($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input)
				return
				endif

				if _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))) = false then
				_Input_Error_FX($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input)
				return
				endif

				if _Ersteinrichtung_pruefe_Pfad(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))) = false then
				_Input_Error_FX($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input)
				return
				endif




			endif
				_Ersteinrichtung_Programmverzeichnisse_Finden()
			EndIf
		case 6
			GUICtrlSetdata($Ersteinrichtung_Weiter_Button, _Get_langstr(249))
			GUICtrlSetOnEvent($Ersteinrichtung_Weiter_Button, "_Ersteinrichtung_Beginne_einrichtung")

			;Baue Zusammenfassung
			guictrlsetdata($Ersteinrichtung_Zusammenfassung_Edit, "")
			$Arbeitsverzeichnis = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)

			$string = _Get_langstr(694) & @crlf & @crlf

			;Modus
			if $Erstkonfiguration_Mode = "normal" then
				$string = $string & "-> " & _Get_langstr(697) & @crlf & @crlf
			else
				$string = $string & "-> " & _Get_langstr(696) & @crlf & @crlf
			EndIf

			;Ordner
			$string = $string & "-> " & _Get_langstr(695) & @crlf
			$string = $string & "   " & _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)) & @crlf
			$string = $string & "   " & _ISN_Variablen_aufloesen($Standardordner_Plugins) & @crlf & @crlf
			$string = $string & "   " & _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input)) & @crlf
			$string = $string & "   " & _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input)) & @crlf
			$string = $string & "   " & _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Backups_input)) & @crlf
			$string = $string & "   " & _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input)) & @crlf & @crlf


			;Datenübernahme
			if GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_CHECKED then
				$string = $string & "-> " & _Get_langstr(698) & @crlf
				$string = $string & "   " & _Get_langstr(699) & " " & guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) & @crlf
				$string = $string & "   " & StringReplace(StringReplace(_Get_langstr(700), "%1", guictrlread($Ersteinrichtung_Datenuebernahme_config_projekte_input)), "%2", _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))) & @crlf
				$string = $string & "   " & StringReplace(StringReplace(_Get_langstr(700), "%1", guictrlread($Ersteinrichtung_Datenuebernahme_config_vorlagen_input)), "%2", _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))) & @crlf
				if FileExists(guictrlread($Ersteinrichtung_Datenuebernahme_config_backups_input)) then $string = $string & "   " & StringReplace(StringReplace(_Get_langstr(700), "%1", guictrlread($Ersteinrichtung_Datenuebernahme_config_backups_input)), "%2", _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Backups_input))) & @crlf
				if FileExists(guictrlread($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input)) then $string = $string & "   " & StringReplace(StringReplace(_Get_langstr(700), "%1", guictrlread($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input)), "%2", _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))) & @crlf
			    $string = $string& @crlf
			endif

			;Zusätzliche Aufgaben
			$string = $string & "-> " & _Get_langstr(701) & @crlf
			if GUICtrlRead($Ersteinrichtung_Verknuepfungen_ISN_checkbox) = $GUI_CHECKED then $string = $string & "   " & _Get_langstr(194) & @crlf
			if GUICtrlRead($Ersteinrichtung_Verknuepfungen_ISP_checkbox) = $GUI_CHECKED then $string = $string & "   " & _Get_langstr(480) & @crlf
			if GUICtrlRead($Ersteinrichtung_Verknuepfungen_ICP_checkbox) = $GUI_CHECKED then $string = $string & "   " & _Get_langstr(1320) & @crlf
			if GUICtrlRead($Ersteinrichtung_Verknuepfungen_AU3_checkbox) = $GUI_CHECKED then $string = $string & "   " & _Get_langstr(702) & @crlf
			if GUICtrlRead($Ersteinrichtung_Verknuepfungen_Kontextmenu_checkbox) = $GUI_CHECKED then $string = $string & "   " & _Get_langstr(703) & @crlf
			if GUICtrlRead($Ersteinrichtung_diverses_testprojekt_checkbox) = $GUI_CHECKED then $string = $string & "   " & _Get_langstr(787) & @crlf

			guictrlsetdata($Ersteinrichtung_Zusammenfassung_Edit, $string)

	EndSwitch
	return 1
endfunc

func _Ersteinrichtung_Beginne_einrichtung()
	Dim $szDrive, $szDir, $szFName, $szExt

	Local $Pfad_zur_config = ""
	GUICtrlSetState($Ersteinrichtung_Zurueck_Button, $GUI_DISABLE)
	GUICtrlSetState($Ersteinrichtung_Weiter_Button, $GUI_DISABLE)
	guictrlsetdata($Ersteinrichtung_Fortschritt, 0)
	guictrlsetdata($Ersteinrichtung_Fortschritt_Status, _Get_langstr(244))
	_GUICtrlTab_ActivateTab($tab_ersteinrichtung, 7)

	;Initialisierung....
	GUICtrlSetStyle($Ersteinrichtung_Fortschritt, 8)
	_SendMessage(guictrlgethandle($Ersteinrichtung_Fortschritt), $PBM_SETMARQUEE, True, 15)
	;Erstelle Ordner
	 $Arbeitsverzeichnis = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
	 	DirCreate(guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)) ;Arbeitsverzeichnis erstellen
		DirCreate(guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data")
		DirCreate(guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data\Cache")
		DirCreate(_ISN_Variablen_aufloesen($Standardordner_Plugins)) ;User Plugins Dir
	    DirCreate(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))) ;Vorlagenordner erstellen
		DirCreate(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Backups_input))) ;Backupordner erstellen
		DirCreate(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))) ;Projektverzeichnis
		DirCreate(_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))) ;Fertige Projekte


	sleep(2000)

	;Konfig aufbauen...
	GUICtrlSetStyle($Ersteinrichtung_Fortschritt, 0)
	_SendMessage(guictrlgethandle($Ersteinrichtung_Fortschritt), $PBM_SETMARQUEE, false, 15)
	guictrlsetdata($Ersteinrichtung_Fortschritt, 30)
	guictrlsetdata($Ersteinrichtung_Fortschritt_Status, _Get_langstr(704))
	$Pfad_zur_config = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data\Config.ini"



	if GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_CHECKED AND guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) <> "" AND FileExists(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input)) then
		;Alte Daten übernehmen
		Filemove(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input), guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data", 9)
		guictrlsetdata($Ersteinrichtung_Fortschritt_Status, _Get_langstr(705))
		guictrlsetdata($Ersteinrichtung_Fortschritt, 70)

		;Cache (Folding etc.)
		$TestPath = _PathSplit(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input), $szDrive, $szDir, $szFName, $szExt)
		$quelle = $szDrive & $szDir & "Cache"
		$ziel = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input) & "\Data\Cache"
		if FileExists($quelle) AND $quelle <> $ziel then
			$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			if $result = 1 then dirremove($quelle,1)
		endif

		;Projekte
		$quelle = guictrlread($Ersteinrichtung_Datenuebernahme_config_projekte_input)
		$ziel = _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))
		if $quelle <> $ziel then
			$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			if $result = 1 then dirremove($quelle,1)
		endif

		;Vorlagen
		$quelle = guictrlread($Ersteinrichtung_Datenuebernahme_config_vorlagen_input)
	  	$ziel = _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))
		if $quelle <> $ziel then
			$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			if $result = 1 then dirremove($quelle,1)
		endif

		;Backups
		$quelle = guictrlread($Ersteinrichtung_Datenuebernahme_config_backups_input)
		$ziel = _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Backups_input))
		if FileExists($Ersteinrichtung_Datenuebernahme_config_backups_input) then
		if $quelle <> $ziel then
			$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			if $result = 1 then dirremove($quelle,1)
	   endif
	   Endif

		;Releases
		$quelle = guictrlread($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input)
		$ziel = _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))
		if FileExists($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input) then
		if $quelle <> $ziel then
			$result = _FileOperationProgress($quelle & "\*.*", $ziel, 1, $FO_MOVE, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
			if $result = 1 then dirremove($quelle,1)
		endif
		Endif

		sleep(500)
	EndIf

	if iniwrite($Pfad_zur_config, "config", "autoitexe", _ISN_Pfad_durch_Variablen_ersetzen(guictrlread($Ersteinrichtung_Programmpfade_Autoit3_exe_input))) = 0 then
	 msgbox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1181),"%1",$Pfad_zur_config), 0, $first_startup)
	endif
	iniwrite($Pfad_zur_config, "config", "helpfileexe", _ISN_Pfad_durch_Variablen_ersetzen(guictrlread($Ersteinrichtung_Programmpfade_AutoIt3Help_exe_input)))
	iniwrite($Pfad_zur_config, "config", "autoit2exe", _ISN_Pfad_durch_Variablen_ersetzen(guictrlread($Ersteinrichtung_Programmpfade_Aut2exe_exe_input)))
	iniwrite($Pfad_zur_config, "config", "au3infoexe", _ISN_Pfad_durch_Variablen_ersetzen(guictrlread($Ersteinrichtung_Programmpfade_Au3Info_exe_input)))
	iniwrite($Pfad_zur_config, "config", "au3checkexe", _ISN_Pfad_durch_Variablen_ersetzen(guictrlread($Ersteinrichtung_Programmpfade_Au3Check_exe_input)))
	iniwrite($Pfad_zur_config, "config", "au3stripperexe", _ISN_Pfad_durch_Variablen_ersetzen(guictrlread($Ersteinrichtung_Programmpfade_au3stripperexe_input)))
	iniwrite($Pfad_zur_config, "config", "tidyexe", _ISN_Pfad_durch_Variablen_ersetzen(guictrlread($Ersteinrichtung_Programmpfade_Tidyexe_input)))
	iniwrite($Pfad_zur_config, "config", "language",$Combo_Sprachen[_GUICtrlComboBox_GetCurSel($langchooser) + 1])
	iniwrite($Pfad_zur_config, "config", "pluginsdir", $Standardordner_Plugins)




	if GUICtrlRead($Ersteinrichtung_Verknuepfungen_AU3_checkbox) = $GUI_CHECKED Then
		iniwrite($Pfad_zur_config, "config", "registerau3files", "true")
	Else
		iniwrite($Pfad_zur_config, "config", "registerau3files", "false")
	endif

	if GUICtrlRead($Ersteinrichtung_Verknuepfungen_ISN_checkbox) = $GUI_CHECKED Then
		iniwrite($Pfad_zur_config, "config", "registerisnfiles", "true")
	Else
		iniwrite($Pfad_zur_config, "config", "registerisnfiles", "false")
	endif

	if GUICtrlRead($Ersteinrichtung_Verknuepfungen_ISP_checkbox) = $GUI_CHECKED Then
		iniwrite($Pfad_zur_config, "config", "registerispfiles", "true")
	Else
		iniwrite($Pfad_zur_config, "config", "registerispfiles", "false")
	endif

	if GUICtrlRead($Ersteinrichtung_Verknuepfungen_ICP_checkbox) = $GUI_CHECKED Then
		iniwrite($Pfad_zur_config, "config", "registericpfiles", "true")
	Else
		iniwrite($Pfad_zur_config, "config", "registericpfiles", "false")
	 endif

	if GUICtrlRead($Ersteinrichtung_Verknuepfungen_Kontextmenu_checkbox) = $GUI_CHECKED Then
		iniwrite($Pfad_zur_config, "config", "registerinexplorer", "true")
	Else
		iniwrite($Pfad_zur_config, "config", "registerinexplorer", "false")
	endif


	;Testprojekt extrahieren
	if GUICtrlRead($Ersteinrichtung_diverses_testprojekt_checkbox) = $GUI_CHECKED Then
	_UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "")
	_UnZIP_SetOptions()
	$result = _UnZIP_Unzip(@scriptdir&"\Data\Packages\testprojekt.zip",_ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input)))
   endif

	;Erstelle default Vorlage
	$Pfad = _ISN_Variablen_aufloesen(guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))

if not FileExists($Pfad&"\default") then ;Default Vorlage nur anlegen wenn sie nicht existiert
	DirCreate($Pfad&"\default")
	DirCreate($Pfad&"\default\Forms")
	DirCreate($Pfad&"\default\Images")

$file = FileOpen($Pfad&"\default\project.isn", 2+32) ;UTF-16 LE Encoding
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
EndIf
FileWriteLine($file, "[ISNAUTOITSTUDIO]")
FileWriteLine($file, "name=Default Template")
FileWriteLine($file, "mainfile=default.au3")
FileWriteLine($file, "author=ISI360")
FileWriteLine($file, "time=0")
FileClose($file)

$file = FileOpen($Pfad&"\default\default.au3", 2)
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
EndIf
FileWriteLine($file, ";*****************************************")
FileWriteLine($file, ";%filename% by %autor%")
FileWriteLine($file, ";%langstring(30)% v. %studioversion%")
FileWriteLine($file, ";*****************************************")
FileClose($file)
endif

	;Pfad zur Config kommt in die Registrierung
	if $Erstkonfiguration_Mode = "normal" then RegWrite("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Configfile", "REG_SZ", $Pfad_zur_config)
	if $Erstkonfiguration_Mode = "portable" then
	 if IniWrite(@scriptdir & "\portable.dat", "ISNAUTOITSTUDIO", "mode", "portable") = 0 then
	 msgbox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1181),"%1",@scriptdir & "\portable.dat"), 0, $first_startup)
	endif
    Endif

	;Abschließende Aufgaben
	guictrlsetdata($Ersteinrichtung_Fortschritt, 80)
		iniwrite($Pfad_zur_config, "config", "projectfolder", guictrlread($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input))
		iniwrite($Pfad_zur_config, "config", "templatefolder", guictrlread($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input))
		if GUICtrlRead($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox) = $GUI_UNCHECKED then
		   ;Wenn Datenübernahme aktiv -> Pfade aus alter config übernehmen. (Wegen backup bzw. Releasemode)
		iniwrite($Pfad_zur_config, "config", "backupfolder", guictrlread($Ersteinrichtung_Verzeichnisse_Backups_input))
		iniwrite($Pfad_zur_config, "config", "releasefolder", guictrlread($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input))
		endif







	;Fertig
	guictrlsetdata($Ersteinrichtung_Fortschritt, 100)
	guictrlsetdata($Ersteinrichtung_Fortschritt_Status, _Get_langstr(249))
	_Datei_nach_UTF16_konvertieren($Pfad_zur_config,"false") ;Config.ini nach UTF16 konvertieren
	MsgBox(64 + 262144, _Get_langstr(61), _Get_langstr(251), 0, $first_startup)


	;Neustart des ISN AutoIt Studios!!!
	if @Compiled then
		run(@scriptdir & "\Autoit_Studio.exe", @scriptdir)
	Else
		ShellExecute(@scriptdir & "\Autoit_Studio.au3")
	endif
	_ChatBoxDestroy($console_chatbox)
	exit
endfunc

func _hardexit()
	Exit
endfunc

func _find_au3exe()
	$state = WinGetState($first_startup, "")
	If BitAnd($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AutoIt3.exe (*.exe)", 3, "", $first_startup)
		If @error Then
			return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Autoit3_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	Else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AutoIt3.exe (*.exe)", 3, "", $Config_GUI)
		If @error Then
			return
		Else
			GUICtrlSetData($Input_config_au3exe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	endif
	FileChangeDir(@scriptdir)
endfunc

func _find_au32exe()
	$state = WinGetState($first_startup, "")
	If BitAnd($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Aut2exe.exe (*.exe)", 3, "", $first_startup)
		If @error Then
			return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Aut2exe_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Aut2exe.exe (*.exe)", 3, "", $Config_GUI)
		If @error Then
			return
		Else
			GUICtrlSetData($Input_config_au2exe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		EndIf
	endif
	FileChangeDir(@scriptdir)
endfunc

func _find_help()
	$state = WinGetState($first_startup, "")
	If BitAnd($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AutoIt3Help.exe (AutoIt3Help.exe)", 3, "", $first_startup)
		If @error Then
			return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_AutoIt3Help_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AutoIt3Help.exe (AutoIt3Help.exe)", 3, "", $Config_GUI)
		If @error Then
			return
		Else
			GUICtrlSetData($Input_config_helpfile, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	endif
	FileChangeDir(@scriptdir)
 endfunc

func _find_Au3Checkexe()
	$state = WinGetState($first_startup, "")
	If BitAnd($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Au3Check.exe (Au3Check.exe)", 3, "", $first_startup)
		If @error Then
			return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Au3Check_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Au3Check.exe (Au3Check.exe)", 3, "", $Config_GUI)
		If @error Then
			return
		Else
			GUICtrlSetData($Input_config_Au3Checkexe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	endif
	FileChangeDir(@scriptdir)
 endfunc

 func _find_Au3Infoexe()
	$state = WinGetState($first_startup, "")
	If BitAnd($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Au3Info.exe (*.exe)", 3, "", $first_startup)
		If @error Then
			return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Au3Info_exe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Au3Info.exe (*.exe)", 3, "", $Config_GUI)
		If @error Then
			return
		Else
			GUICtrlSetData($Input_config_Au3Infoexe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	endif
	FileChangeDir(@scriptdir)
 endfunc


func _find_au3stripperexe()
	$state = WinGetState($first_startup, "")
	If BitAnd($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AU3Stripper.exe (AU3Stripper.exe)", 3, "", $first_startup)
		If @error Then
			return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_au3stripperexe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "AU3Stripper.exe (AU3Stripper.exe)", 3, "", $Config_GUI)
		If @error Then
			return
		Else
			GUICtrlSetData($Input_config_Au3Stripperexe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	endif
	FileChangeDir(@scriptdir)
 endfunc

func _find_Tidyexe()
	$state = WinGetState($first_startup, "")
	If BitAnd($state, 2) Then
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Tidy.exe (Tidy.exe)", 3, "", $first_startup)
		If @error Then
			return
		Else
			GUICtrlSetData($Ersteinrichtung_Programmpfade_Tidyexe_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	else
		$var = FileOpenDialog(_Get_langstr(259), @ProgramFilesDir, "Tidy.exe (Tidy.exe)", 3, "", $Config_GUI)
		If @error Then
			return
		Else
			GUICtrlSetData($Input_config_Tidyexe, _ISN_Pfad_durch_Variablen_ersetzen($var))
		endif
	endif
	FileChangeDir(@scriptdir)
 endfunc

func _Ersteinrichtung_Programmverzeichnisse_Finden()
	;Search AutoIt3.exe
   _erkenne_au3exe()

	;Search Aut2exe.exe
   _erkenne_au32exe()

	;Search AutoIt3Help.exe
   _erkenne_helpfile()

	;Search Au3Check.exe
   _erkenne_Au3Checkexe()

	;Search Au3Info.exe
   _erkenne_Au3Infoexe()

   ;Au3stripper
   _erkenne_Au3Stripperexe()

   ;Tidy
   _erkenne_Tidyexe()

	if $Erstkonfiguration_Mode = "portable" then
	GUICtrlSetState($Ersteinrichtung_Programmpfade_Portableinfo,$GUI_SHOW)
	else
	GUICtrlSetState($Ersteinrichtung_Programmpfade_Portableinfo,$GUI_HIDE)
	EndIf

EndFunc

func _Show_Firstconfig()
	guisetstate(@sw_Hide, $Logo_PNG)
	guisetstate(@sw_hide, $controlGui_startup)
	SetBitmap($Logo_PNG, $hImagestartup, 0)

	if not FileExists(@ScriptDir & "\Data\config.ini") then GUICtrlSetState($Ersteinrichtung_Info_Label1, $GUI_HIDE)
	if FileExists(@ScriptDir & "\Data\config.ini") then GUICtrlSetState($Ersteinrichtung_ISN_Logo, $GUI_HIDE)
	_Ersteinrichtung_Pruefe_Buttons()
	GUISetState(@SW_SHOW, $first_startup)

	while 1
		$state = WinGetState($first_startup, "")
		$i = 0
		if BitAnd($state, 2) then $i = 1
		if $i = 0 then exitloop
		sleep(200)
	WEnd

endfunc

func _waehle_sprache_Ersteinrichtung()
	$Languagefile = $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($langchooser) + 1]
	$Fallback_Language_Array = ""
	$Current_Language_Array = ""
	_check_fonts()
	GUISetState(@SW_HIDE, $Sprache_Ersteinrichtung_GUI)
EndFunc

func _Exit_Ersteinrichtung()
	_ChatBoxDestroy($console_chatbox)
	exit
EndFunc

func _Ersteinrichtung_waehle_normal_modus()
	$Erstkonfiguration_Mode = "normal"
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, "")
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, "")
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_Backups_input, "")
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, "")
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, "")
	if guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" AND FileExists(@scriptdir & "\Data\config.ini") then GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, @scriptdir & "\Data\config.ini")
	if guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" AND FileExists(@MyDocumentsDir & "\ISN AutoIt Studio\Data\config.ini") then GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, @MyDocumentsDir & "\ISN AutoIt Studio\Data\config.ini")
	_Ersteinrichtung_zeige_Datenuebernahme()
	_GUICtrlTab_ActivateTab($tab_ersteinrichtung, 2)
	_Ersteinrichtung_Pruefe_Buttons(_GUICtrlTab_GetCurFocus($tab_ersteinrichtung))
endfunc

func _Ersteinrichtung_waehle_portable_modus()
	$Erstkonfiguration_Mode = "portable"
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input, "")
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input, "")
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_Backups_input, "")
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input, "")
	guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input, "")
	if guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" AND FileExists(@scriptdir & "\Data\config.ini") then GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, @scriptdir & "\Data\config.ini")
	if guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) = "" AND FileExists(@MyDocumentsDir & "\ISN AutoIt Studio\Data\config.ini") then GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, @MyDocumentsDir & "\ISN AutoIt Studio\Data\config.ini")
	_Ersteinrichtung_zeige_Datenuebernahme()
	_GUICtrlTab_ActivateTab($tab_ersteinrichtung, 2)
	_Ersteinrichtung_Pruefe_Buttons(_GUICtrlTab_GetCurFocus($tab_ersteinrichtung))
endfunc

Func _Ersteinrichtung_Datenuebernahme_waehle_config()
	$var = FileOpenDialog(_Get_langstr(508), @scriptdir, "ISN AutoIt Studio config (config.ini)", 1 + 2 + 4, "", $first_startup)
	FileChangeDir(@scriptdir)
	if $var = "" then return
	If @error Then return

	GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, $var)
	_Ersteinrichtung_zeige_Datenuebernahme()

EndFunc

Func _Ersteinrichtung_zeige_Datenuebernahme()
	Dim $szDrive, $szDir, $szFName, $szExt
	Local $pfad
	if FileExists(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input)) Then
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_Alte_config_gefunden_label, _Get_langstr(782) & @crlf & "(" & guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input) & ")")
		GUICtrlSetColor($Ersteinrichtung_Datenuebernahme_Alte_config_gefunden_label, "0x008000")
		GUICtrlSetState($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox, $GUI_CHECKED)

		$TestPath = _PathSplit(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input), $szDrive, $szDir, $szFName, $szExt)
		$Arbeitsverzeichnis = $szDrive&StringTrimRight($szDir, stringlen($szDir) - StringInStr($szDir, "\Data\", 0, -1)+1)

	    ;Projekte
		$readen = iniread(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input), "config", "projectfolder", $Standardordner_Projects)
	    if $readen = "Projects" then $readen = $Standardordner_Projects
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_projekte_input, _ISN_Variablen_aufloesen($readen))

	    ;Templates
		$readen = iniread(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input), "config", "templatefolder", $Standardordner_Templates)
		if $readen = "Templates" then $readen = $Standardordner_Templates
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_vorlagen_input, _ISN_Variablen_aufloesen($readen))

	    ;Backups
		$readen = iniread(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input), "config", "backupfolder", $Standardordner_Backups)
		if $readen = "Backups" then $readen = $Standardordner_Backups
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_backups_input, _ISN_Variablen_aufloesen($readen))

	    ;Releases
		$readen = iniread(guictrlread($Ersteinrichtung_Datenuebernahme_config_pfad_input), "config", "releasefolder", $Standardordner_Release)
	    if $readen = "Release" then $readen = $Standardordner_Release
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input, _ISN_Variablen_aufloesen($readen))

	Else
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_Alte_config_gefunden_label, _Get_langstr(783))
		GUICtrlSetColor($Ersteinrichtung_Datenuebernahme_Alte_config_gefunden_label, "0x000000")
		GUICtrlSetState($Ersteinrichtung_Datenuebernahme_Alte_daten_uebernehmen_checkbox, $GUI_UNCHECKED)
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_pfad_input, "")
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_projekte_input, "")
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_vorlagen_input, "")
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_backups_input, "")
		GUICtrlSetData($Ersteinrichtung_Datenuebernahme_config_fertige_projekte_input, "")

	EndIf

EndFunc

func _Ersteinrichtung_waehle_Datenverzeichnis()
$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298),$BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE,0,0,$first_startup)
If @error Then return
if $var = "" then return
guictrlsetdata($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input,$var)
endfunc

func _Ersteinrichtung_waehle_Projektverzeichnis()
$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298),$BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE,0,0,$first_startup)
If @error Then return
if $var = "" then return
$Arbeitsverzeichnis = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektverzeichnis_input ,_ISN_Pfad_durch_Variablen_ersetzen($var))
endfunc

func _Ersteinrichtung_waehle_Vorlagenverzeichnis()
$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298),$BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE,0,0,$first_startup)
If @error Then return
if $var = "" then return
$Arbeitsverzeichnis = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
guictrlsetdata($Ersteinrichtung_Verzeichnisse_Projektvorlagen_input,_ISN_Pfad_durch_Variablen_ersetzen($var))
endfunc

func _Ersteinrichtung_waehle_Backupsverzeichnis()
$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298),$BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE,0,0,$first_startup)
If @error Then return
if $var = "" then return
$Arbeitsverzeichnis = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
guictrlsetdata($Ersteinrichtung_Verzeichnisse_Backups_input,_ISN_Pfad_durch_Variablen_ersetzen($var))
endfunc

func _Ersteinrichtung_waehle_FertigeProjekteverzeichnis()
$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298),$BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE,0,0,$first_startup)
If @error Then return
if $var = "" then return
$Arbeitsverzeichnis = guictrlread($Ersteinrichtung_Verzeichnisse_arbeitsverzeichniss_input)
guictrlsetdata($Ersteinrichtung_Verzeichnisse_Fertige_Projekte_input,_ISN_Pfad_durch_Variablen_ersetzen($var))
endfunc

; #FUNCTION# =========================================================================================================
; Name...........: GUICtrlGetBkColor
; Description ...: Retrieves the RGB value of the control background.
; Syntax.........: GUICtrlGetBkColor($iControlID)
; Parameters ....: $iControlID - A valid control ID.
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Returns RGB value of the control background.
;                  Failure - Returns 0 & sets @error = 1
; Author ........: guinness & additional information from Yashied for WinAPIEx.
; Example........; Yes
;=====================================================================================================================

Func GUICtrlGetBkColor($iControlID)
	Local $bGetBkColor, $hDC, $hHandle
	$hHandle = GUICtrlGetHandle($iControlID)
	$hDC = _WinAPI_GetDC($hHandle)
	$bGetBkColor = _WinAPI_GetPixel($hDC, 2, 2)
	_WinAPI_ReleaseDC($hHandle, $hDC)
	Return $bGetBkColor
EndFunc ;==>GUICtrlGetBkColor

func _Input_Error_FX($Control = "")
	;by ISI360
	if $Control = "" then Return
	if $Control_Flashes = 1 then Return
	$Control_Flashes = 1
	$old_bg = "0x" & Hex(GUICtrlGetBkColor($Control), 6)
	$old_red = _ColorGetRed($old_bg)
	$old_green = _ColorGetGreen($old_bg)
	$old_blue = _ColorGetBlue($old_bg)
	GUICtrlSetBkColor($Control, 0xFB6969)
	sleep(100)
	$new_bg = "0x" & Hex(GUICtrlGetBkColor($Control), 6)
	$new_red = _ColorGetRed($new_bg)
	$new_green = _ColorGetGreen($new_bg)
	$new_blue = _ColorGetBlue($new_bg)
	$steps = 5
	sleep(300)
	while 1
		$new_red = $new_red - $steps
		if $new_red < $old_red then $new_red = $old_red
		$new_green = $new_green + $steps
		if $new_green > $old_green then $new_green = $old_green
		$new_blue = $new_blue + $steps
		if $new_blue > $old_blue then $new_blue = $old_blue
		$bg = "0x" & hex($new_red, 2) & hex($new_green, 2) & hex($new_blue, 2)
		if $new_red = $old_red AND $new_green = $old_green AND $new_blue = $old_blue then ExitLoop
		GUICtrlSetBkColor($Control, $bg)
		sleep(20)
	WEnd
	GUICtrlSetBkColor($Control, $old_bg)
	$Control_Flashes = 0
endfunc



;Gibt den gewünschten String (ID) in der aktuellen Sprache zurück ($Languagefile)
func _Get_langstr($id=0)
   If $Languagefile = "" Then return ""
   If $id < 1 then return ""
   Local $String_to_return = ""

   ;Reads the current language in the buffer
   if $Current_Language_Array = "" Then
	  $Current_Language_Array = $Leeres_Array
	  $Current_Language_Array = StringRegExp(FileRead(@ScriptDir & "\data\language\"& $Languagefile), "(?m)(?i)^str\d+\=(.*)", 3)
	  _ArrayInsert($Current_Language_Array, 0, $Languagefile)
   EndIf

   ;And the backup (fallback) language
   if $Fallback_Language_Array = "" Then
	  $Fallback_Language_Array = $Leeres_Array
	  $Fallback_Language_Array = StringRegExp(FileRead(@ScriptDir & "\data\language\english.lng"), "(?m)(?i)^str\d+\=(.*)", 3)
	  _ArrayInsert($Fallback_Language_Array, 0, "english.lng")
   EndIf


   if not IsArray($Current_Language_Array) AND not IsArray($Fallback_Language_Array) then return "#LANGUAGE_ERROR#"&$id


   if $id > ubound($Current_Language_Array)-1 then
	  if $id > ubound($Fallback_Language_Array)-1 then
		 return "#LANGUAGE_ERROR#"&$id
	  Else
		 $String_to_return = StringReplace($Fallback_Language_Array[$id], "[BREAK]", @CRLF)
		 EndIf
	  Else
		 $String_to_return = StringReplace($Current_Language_Array[$id], "[BREAK]", @CRLF)
   EndIf

   if $String_to_return = "" then
	  $String_to_return = StringReplace($Fallback_Language_Array[$id], "[BREAK]", @CRLF)
	  if $String_to_return = "" then $String_to_return = "#LANGUAGE_ERROR#"&$id
   Endif
   return $String_to_return
EndFunc

func _Ersteinrichtung_pruefe_Pfad($i="")
if $i = "" then return false
if stringinstr($i, "?") OR stringinstr($i, "*") OR stringinstr($i, "|") or stringinstr($i, "<") or stringinstr($i, ">") or stringinstr($i, "'") or stringinstr($i, '"') then return false
Dim $szDrive, $szDir, $szFName, $szExt
$TestPath = _PathSplit($i, $szDrive, $szDir, $szFName, $szExt)
if $szDrive = "" then return false
return true
endfunc



Func _Ersetzte_Platzhalter($Platzhalter = "", $QuellPfadfuerFileDir = "")
	If $Platzhalter = "" Then Return ""
	Local $Str = ""

	Switch $Platzhalter

		Case "%langstring("
			Return _Get_langstr($QuellPfadfuerFileDir)


		Case "%projectversion%"
			$Str = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "version", "")
			$Str = StringReplace($Str, "\", "")
			$Str = StringReplace($Str, "/", "")
			$Str = StringReplace($Str, "?", "")
			$Str = StringReplace($Str, "*", "")
			$Str = StringReplace($Str, "|", "")
			$Str = StringReplace($Str, ":", "")
			$Str = StringReplace($Str, "<", "")
			$Str = StringReplace($Str, ">", "")
			$Str = StringReplace($Str, "'", "")
			$Str = StringReplace($Str, '"', "")
			Return $Str

		Case "%projectauthor%"
			$Str = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "author", "")
			$Str = StringReplace($Str, "\", "")
			$Str = StringReplace($Str, "/", "")
			$Str = StringReplace($Str, "?", "")
			$Str = StringReplace($Str, "*", "")
			$Str = StringReplace($Str, "|", "")
			$Str = StringReplace($Str, ":", "")
			$Str = StringReplace($Str, "<", "")
			$Str = StringReplace($Str, ">", "")
			$Str = StringReplace($Str, "'", "")
			$Str = StringReplace($Str, '"', "")
			Return $Str

		Case "%filedir%"
			If $QuellPfadfuerFileDir = "" Then
				MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(1049), 0, $StudioFenster)
				Return $Offenes_Projekt ;Bei Fehler gibt das ProjectDir zurück
			EndIf
			$Str = StringTrimRight($QuellPfadfuerFileDir, StringLen($QuellPfadfuerFileDir) - (StringInStr($QuellPfadfuerFileDir, "\", 0, -1) - 1))
			Return $Str


	EndSwitch


	Return $Str
EndFunc   ;==>_Ersetzte_Platzhalter

Func _ISN_Pfad_durch_Variablen_ersetzen($String = "", $Offenes_Projekt_Ignorieren = 0)
	If $String = "" Then Return ""
	If StringInStr($String, $Offenes_Projekt) And $Offenes_Projekt_Ignorieren = 0 Then $String = StringReplace($String, $Offenes_Projekt, "%projectdir%")
	If StringInStr($String, _ISN_Variablen_aufloesen($Projectfolder)) Then $String = StringReplace($String, _ISN_Variablen_aufloesen($Projectfolder), "%projectsdir%")
	If StringInStr($String, @ScriptDir) Then $String = StringReplace($String, @ScriptDir, "%isnstudiodir%")
    If StringInStr($String, $Pluginsdir) Then $String = StringReplace($String, @WindowsDir, "%pluginsdir%")
	If StringInStr($String, $Arbeitsverzeichnis) Then $String = StringReplace($String, $Arbeitsverzeichnis, "%myisndatadir%")
	If StringInStr($String, @DesktopDir) Then $String = StringReplace($String, @DesktopDir, "%desktopdir%")
	If StringInStr($String, @MyDocumentsDir) Then $String = StringReplace($String, @MyDocumentsDir, "%mydocumentsdir%")
	If StringInStr($String, @TempDir) Then $String = StringReplace($String, @TempDir, "%tempdir%")
	If StringInStr($String, @WindowsDir) Then $String = StringReplace($String, @WindowsDir, "%windowsdir%")


	Return $String
EndFunc   ;==>_ISN_Pfad_durch_Variablen_ersetzen


Func _ISN_Variablen_aufloesen($String = "", $QuellPfadfuerFileDir = "")
	If $String = "" Then Return ""

	$Projekt_Kompilier_mode = IniRead($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "compile_mode", "2")

	;Programmpfade
	If StringInStr($String, "%projectsdir%") Then $String = StringReplace($String, "%projectsdir%", $Projectfolder)

	;Plugins dir
	If StringInStr($String, "%pluginsdir%") Then $String = StringReplace($String, "%pluginsdir%", $Pluginsdir)

	;Variablen
	If StringInStr($String, "%projectname%") Then $String = StringReplace($String, "%projectname%", $Offenes_Projekt_name)
	If StringInStr($String, "%projectversion%") Then $String = StringReplace($String, "%projectversion%", _Ersetzte_Platzhalter("%projectversion%"))
	If StringInStr($String, "%projectauthor%") Then $String = StringReplace($String, "%projectauthor%", _Ersetzte_Platzhalter("%projectauthor%"))

	;Texte aus der Sprachdatei
	If StringInStr($String, "%langstring(") Then
		$start = StringInStr($String, "%langstring(")
		$end = StringInStr($String, ")%", 0, 1, $start)
		If $end = 0 Then Return ""
		$to_replace = StringMid($String, $start, $end + 2)
		$lng_id = StringReplace($to_replace, "%langstring(", "")
		$lng_id = StringReplace($lng_id, ")%", "")
		$String = StringReplace($String, $to_replace, _Ersetzte_Platzhalter("%langstring(", $lng_id))
	EndIf

   ;Uhrzeiten
	If StringInStr($String, "%mday%") Then $String = StringReplace($String, "%mday%", @MDAY)
	If StringInStr($String, "%mon%") Then $String = StringReplace($String, "%mon%", @MON)
	If StringInStr($String, "%year%") Then $String = StringReplace($String, "%year%", @YEAR)
	If StringInStr($String, "%hour%") Then $String = StringReplace($String, "%hour%", @HOUR)
	If StringInStr($String, "%min%") Then $String = StringReplace($String, "%min%", @MIN)
	If StringInStr($String, "%sec%") Then $String = StringReplace($String, "%sec%", @SEC)


	;Pfade
	If StringInStr($String, "%myisndatadir%") Then $String = StringReplace($String, "%myisndatadir%", $Arbeitsverzeichnis)
	If StringInStr($String, "%lastcompiledfile_exe%") Then $String = StringReplace($String, "%lastcompiledfile_exe%", $Zuletzt_Kompilierte_Datei_Pfad_exe)
	If StringInStr($String, "%lastcompiledfile_source%") Then $String = StringReplace($String, "%lastcompiledfile_source%", $Zuletzt_Kompilierte_Datei_Pfad_au3)
	If StringInStr($String, "%projectdir%") Then $String = StringReplace($String, "%projectdir%", $Offenes_Projekt)
	If StringInStr($String, "%isnstudiodir%") Then $String = StringReplace($String, "%isnstudiodir%", @ScriptDir)
	If StringInStr($String, "%windowsdir%") Then $String = StringReplace($String, "%windowsdir%", @WindowsDir)
	If StringInStr($String, "%tempdir%") Then $String = StringReplace($String, "%tempdir%", @TempDir)
	If StringInStr($String, "%desktopdir%") Then $String = StringReplace($String, "%desktopdir%", @DesktopDir)
	If StringInStr($String, "%mydocumentsdir%") Then $String = StringReplace($String, "%mydocumentsdir%", @MyDocumentsDir)
	If StringInStr($String, "%filedir%") Then $String = StringReplace($String, "%filedir%", _Ersetzte_Platzhalter("%filedir%", $QuellPfadfuerFileDir))

	$Desfolder = ""
	If StringInStr($String, "%backupdir%") Then
		If $backupmode = 1 Then
		   $Desfolder = _ISN_Variablen_aufloesen($Backupfolder & "\" & $Offenes_Projekt_name)
		EndIf
		If $backupmode = 2 Then
			$Desfolder = $Offenes_Projekt & "\" & $Backupfolder
		EndIf
		$String = StringReplace($String, "%backupdir%", $Desfolder)
	EndIf


	$zielpfad = ""
	If StringInStr($String, "%compileddir%") Then
		If $releasemode = 1 Then
			$zielpfad = _ISN_Variablen_aufloesen($releasefolder & "\" & _ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%"))
		EndIf
		If $releasemode = 2 Then
			$directory = _ProjectISN_Config_Read("compile_finished_project_dir", "%projectname%")
			$directory = StringReplace($directory, "%projectname%", "")
			$directory = StringReplace($directory, "\\", "")
			If StringLeft($directory, 1) = "\" Then $directory = StringTrimLeft($directory, 1)
			$directory = _ISN_Variablen_aufloesen($directory)
			If $directory <> "" Then $directory = "\" & $directory
			$zielpfad = $Offenes_Projekt & "\" & _ISN_Variablen_aufloesen($releasefolder) & $directory
		EndIf

		If $Projekt_Kompilier_mode = "1" Then $zielpfad = $Offenes_Projekt
		$String = StringReplace($String, "%compileddir%", $zielpfad)
	EndIf

   ;Windows Variablen auflösen
   if $allow_windows_variables_in_paths = "true" then
   $ExpandEnvStrings_old_value = Opt('ExpandEnvStrings')
   Opt('ExpandEnvStrings',1)
   $String = $String
   Opt('ExpandEnvStrings', $ExpandEnvStrings_old_value)
   endif

	Return $String
EndFunc   ;==>_ISN_Variablen_aufloesen

Func _Directory_Is_Accessible($sPath)
	If Not StringInStr(FileGetAttrib($sPath), "D", 2) Then Return SetError(1, 0, 0)
	Local $iEnum = 0
	While FileExists($sPath & "\_test_" & $iEnum)
		$iEnum += 1
	WEnd
	Local $iSuccess = DirCreate($sPath & "\_test_" & $iEnum)
	Switch $iSuccess
		Case 1
			DirRemove($sPath & "\_test_" & $iEnum)
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>_Directory_Is_Accessible




