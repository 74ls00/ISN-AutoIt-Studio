;Settings.au3

func _Write_in_Config($key, $value)
	return iniwrite($Configfile, "config", $key, $value)
EndFunc

func _Config_Read($key, $errorkey)
	$i = iniread($Configfile, "config", $key, $errorkey)
	return $i
EndFunc

func _Show_Configgui()

	guisetstate(@SW_DISABLE, $StudioFenster)

	if _GUICtrlTab_GetItemCount($htab) > 0 then WinSetOnTop($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], "", 0)
	GUISetState(@SW_SHOW, $Config_GUI)
	GUISetState(@SW_HIDE, $Welcome_GUI)

	GUICtrlSetData($darstellung_monitordropdown, "")
	$string = ""
	for $nr = 1 to $__MonitorList[0][0]
		$string = $string & _Get_langstr(448) & " " & $nr & "|"
	next
	if $Runonmonitor > $__MonitorList[0][0] then
		$default = _Get_langstr(448) & " 1"
	else
		$default = _Get_langstr(448) & " " & $Runonmonitor
	EndIf

	GUICtrlSetData($darstellung_monitordropdown, $string, $default)

	;diverse inputs

	guictrlsetdata($config_autoupdate_time_in_days, $autoupdate_searchtimer)
	guictrlsetdata($darstellung_scripteditor_font, $scripteditor_font)
	guictrlsetdata($darstellung_scripteditor_size, $scripteditor_size)
	guictrlsetdata($darstellung_scripteditor_bgcolour, $scripteditor_bgcolour)
	GUICtrlSetColor($darstellung_scripteditor_bgcolour, _ColourInvert(Execute($scripteditor_bgcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_bgcolour, $scripteditor_bgcolour)

	guictrlsetdata($darstellung_scripteditor_rowcolour, $scripteditor_rowcolour)
	GUICtrlSetColor($darstellung_scripteditor_rowcolour, _ColourInvert(Execute($scripteditor_rowcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_rowcolour, $scripteditor_rowcolour)

	guictrlsetdata($darstellung_scripteditor_marccolour, $scripteditor_marccolour)
	GUICtrlSetColor($darstellung_scripteditor_marccolour, _ColourInvert(Execute($scripteditor_marccolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_marccolour, $scripteditor_marccolour)

	guictrlsetdata($darstellung_scripteditor_highlightcolour, $scripteditor_highlightcolour)
	GUICtrlSetColor($darstellung_scripteditor_highlightcolour, _ColourInvert(Execute($scripteditor_highlightcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_highlightcolour, $scripteditor_highlightcolour)

	guictrlsetdata($darstellung_scripteditor_cursorcolor, $scripteditor_caretcolour)
	GUICtrlSetColor($darstellung_scripteditor_cursorcolor, _ColourInvert(Execute($scripteditor_caretcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_cursorcolor, $scripteditor_caretcolour)

	guictrlsetdata($darstellung_scripteditor_errorcolor, $scripteditor_errorcolour)
	GUICtrlSetColor($darstellung_scripteditor_errorcolor, _ColourInvert(Execute($scripteditor_errorcolour)))
	GUICtrlSetBkColor($darstellung_scripteditor_errorcolor, $scripteditor_errorcolour)

    guictrlsetdata($darstellung_scripteditor_cursorwidth, $scripteditor_caretwidth)

	if _Config_Read("scripteditor_caretstyle", "1") = "1" Then
		guictrlsetstate($darstellung_scripteditor_cursorstyle_Radio1, $GUI_CHECKED)
		guictrlsetstate($darstellung_scripteditor_cursorstyle_Radio2, $GUI_UNCHECKED)
	Else
		guictrlsetstate($darstellung_scripteditor_cursorstyle_Radio1, $GUI_UNCHECKED)
		guictrlsetstate($darstellung_scripteditor_cursorstyle_Radio2, $GUI_CHECKED)
	 endif

	guictrlsetdata($darstellung_treefont_font, $treefont_font)
	guictrlsetdata($darstellung_treefont_size, $treefont_size)
	guictrlsetdata($darstellung_treefont_colour, $treefont_colour)
	GUICtrlSetBkColor($darstellung_treefont_colour, $treefont_colour)
	GUICtrlSetColor($darstellung_treefont_colour, _ColourInvert(Execute($treefont_colour)))

	guictrlsetdata($darstellung_defaultfont_size, $Default_font_size)
	guictrlsetdata($darstellung_defaultfont_font, $Default_font)




	guictrlsetdata($Input_config_au3exe, _Config_Read("autoitexe", ""))
	guictrlsetdata($Input_config_au2exe, _Config_Read("autoit2exe", ""))
	guictrlsetdata($Input_config_helpfile, _Config_Read("helpfileexe", ""))
	guictrlsetdata($Input_config_Au3Infoexe, _Config_Read("au3infoexe", ""))
	guictrlsetdata($Input_config_Au3Checkexe, _Config_Read("au3checkexe", ""))
	guictrlsetdata($Input_config_Au3Stripperexe, _Config_Read("au3stripperexe", ""))
	guictrlsetdata($Input_config_Tidyexe, _Config_Read("tidyexe", ""))


	guictrlsetdata($proxy_server_input, $proxy_server)
	guictrlsetdata($proxy_port_input, $proxy_port)
	guictrlsetdata($proxy_username_input, $proxy_username)
	if $proxy_PW = "" then
		$pw = ""
	else
;~ 		$pw = _StringEncrypt(0, $proxy_PW, "Isn_pRoxy_PW", 2)
		$pw = BinaryToString(_Crypt_DecryptData ($proxy_PW, "Isn_pRoxy_PW", $CALG_RC4))

	EndIf

	guictrlsetdata($proxy_password_input, $pw)



	if _Config_Read("pelock_key", "") = "" then
		guictrlsetdata($settings_pelock_key_input, "")
		else
		guictrlsetdata($settings_pelock_key_input, BinaryToString(_Crypt_DecryptData (_Config_Read("pelock_key", ""), "Isn_p#EloCK!!_PW", $CALG_RC4)))
	EndIf





	guictrlsetdata($config_inputstartbefore, $runbefore)
	guictrlsetdata($config_inputstartafter, $runafter)
	guictrlsetdata($config_fertigeprojecte_dropdown, "")
	guictrlsetdata($config_backupmode_combo, "")

	guictrlsetdata($Combo_closeprogramm, "")
	if _Config_Read("closeaction", "close") = "close" Then guictrlsetdata($Combo_closeprogramm, _Get_langstr(319) & "|" & _Get_langstr(320) & "|" & _Get_langstr(321), _Get_langstr(319))
	if _Config_Read("closeaction", "close") = "closeproject" Then guictrlsetdata($Combo_closeprogramm, _Get_langstr(319) & "|" & _Get_langstr(320) & "|" & _Get_langstr(321), _Get_langstr(320))
	if _Config_Read("closeaction", "close") = "minimize" Then guictrlsetdata($Combo_closeprogramm, _Get_langstr(319) & "|" & _Get_langstr(320) & "|" & _Get_langstr(321), _Get_langstr(321))

	if _Config_Read("releasemode", "1") = "1" Then guictrlsetdata($config_fertigeprojecte_dropdown, _Get_langstr(413) & "|" & _Get_langstr(414), _Get_langstr(413))
	if _Config_Read("releasemode", "1") = "2" Then guictrlsetdata($config_fertigeprojecte_dropdown, _Get_langstr(413) & "|" & _Get_langstr(414), _Get_langstr(414))
	_select_releasemode()

	if _Config_Read("backupmode", "1") = "1" Then guictrlsetdata($config_backupmode_combo, _Get_langstr(425) & "|" & _Get_langstr(426), _Get_langstr(425))
	if _Config_Read("backupmode", "1") = "2" Then guictrlsetdata($config_backupmode_combo, _Get_langstr(425) & "|" & _Get_langstr(426), _Get_langstr(426))



	$autoit_editor_encoding = _Config_Read("autoit_editor_encoding", "2")
	guictrlsetstate($Einstellungen_skripteditor_Zeichensatz_default, $GUI_UNCHECKED)
	guictrlsetstate($Einstellungen_skripteditor_Zeichensatz_UTF8, $GUI_UNCHECKED)
	if $autoit_editor_encoding = "1" then guictrlsetstate($Einstellungen_skripteditor_Zeichensatz_default, $GUI_CHECKED)
	if $autoit_editor_encoding = "2" then guictrlsetstate($Einstellungen_skripteditor_Zeichensatz_UTF8, $GUI_CHECKED)

	if _Config_Read("restore_old_tabs", "false") = "true" Then
		guictrlsetstate($Checkbox_lade_zuletzt_geoeffnete_Dateien, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_lade_zuletzt_geoeffnete_Dateien, $GUI_UNCHECKED)
	endif

	if _Config_Read("enable_autoupdate", "true") = "true" Then
		guictrlsetstate($Checkbox_enable_autoupdate, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_enable_autoupdate, $GUI_UNCHECKED)
	endif

	if _Config_Read("isn_save_window_position", "false") = "true" Then
		guictrlsetstate($Darstellung_ISN_Fensterpositionen_speichern_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Darstellung_ISN_Fensterpositionen_speichern_checkbox, $GUI_UNCHECKED)
	 endif


	if _Config_Read("fullscreenmode", "false") = "true" Then
		guictrlsetstate($Checkbox_fullscreenmode, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_fullscreenmode, $GUI_UNCHECKED)
	endif

	if _Config_Read("showfunctions", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_showfunctions, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_showfunctions, $GUI_UNCHECKED)
	 endif

   if _Config_Read("autoend_keywords", "true") = "true" Then
		guictrlsetstate($Checkbox_Settings_AutoEndIf_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Settings_AutoEndIf_Checkbox, $GUI_UNCHECKED)
	endif

   if _Config_Read("auto_dollar_for_declarations", "true") = "true" Then
		guictrlsetstate($Checkbox_Settings_Deklarationen_Auto_Dollar_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Settings_Deklarationen_Auto_Dollar_Checkbox, $GUI_UNCHECKED)
	 endif


	if _Config_Read("expandfunctions", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_expandfunctions, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_expandfunctions, $GUI_UNCHECKED)
	endif

	if _Config_Read("showglobalvariables", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_showglobalvariables, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_showglobalvariables, $GUI_UNCHECKED)
	endif

	if _Config_Read("expandglobalvariables", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_expandglobalvariables, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_expandglobalvariables, $GUI_UNCHECKED)
	endif

	if _Config_Read("showlocalvariables", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_showlocalvariables, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_showlocalvariables, $GUI_UNCHECKED)
	endif

	if _Config_Read("expandlocalvariables", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_expandlocalvariables, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_expandlocalvariables, $GUI_UNCHECKED)
	endif

	if _Config_Read("showincludes", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_showincludes, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_showincludes, $GUI_UNCHECKED)
	endif

	if _Config_Read("expandincludes", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_expandincludes, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_expandincludes, $GUI_UNCHECKED)
	endif

	if _Config_Read("showforms", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_showforms, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_showforms, $GUI_UNCHECKED)
	endif

	if _Config_Read("expandforms", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_expandforms, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_expandforms, $GUI_UNCHECKED)
	 endif

   if _Config_Read("scripttree_sort_funcs_alphabetical", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_alphabetisch, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_alphabetisch, $GUI_UNCHECKED)
	endif

	if _Config_Read("loadcontrols", "true") = "true" Then
		guictrlsetstate($Checkbox_loadcontrols, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_loadcontrols, $GUI_UNCHECKED)
	endif

	if _Config_Read("showregions", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_showregions, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_showregions, $GUI_UNCHECKED)
	endif

	if _Config_Read("expandregions", "true") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_expandregions, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_expandregions, $GUI_UNCHECKED)
	endif

	if _Config_Read("enable_intelimark", "true") = "true" Then
		guictrlsetstate($Checkbox_verwende_intelimark, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_verwende_intelimark, $GUI_UNCHECKED)
	endif

	if _Config_Read("trophys", "true") = "false" Then
		guictrlsetstate($Checkbox_disabletrophys, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_disabletrophys, $GUI_UNCHECKED)
	endif

;~ 	if _Config_Read("drawicons", "true") = "true" Then
;~ 		guictrlsetstate($Checkbox_disabledrawicons, $GUI_CHECKED)
;~ 	Else
;~ 		guictrlsetstate($Checkbox_disabledrawicons, $GUI_UNCHECKED)
;~ 	endif

	if _Config_Read("askexit", "true") = "true" Then
		guictrlsetstate($Checkbox_AskExit, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_AskExit, $GUI_UNCHECKED)
	endif

	if _Config_Read("autoload", "false") = "true" Then
		guictrlsetstate($Checkbox_Load_Automatic, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Load_Automatic, $GUI_UNCHECKED)
	endif

	if _Config_Read("registerinexplorer", "true") = "true" Then
		guictrlsetstate($Checkbox_contextmenu_au3files, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_contextmenu_au3files, $GUI_UNCHECKED)
	endif

	if _Config_Read("enablelogo", "true") = "true" Then
		guictrlsetstate($Checkbox_enablelogo, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_enablelogo, $GUI_UNCHECKED)
	endif

	if _Config_Read("autoloadmainfile", "true") = "true" Then
		guictrlsetstate($Checkbox_autoloadmainfile, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_autoloadmainfile, $GUI_UNCHECKED)
	endif

	if _Config_Read("registerisnfiles", "true") = "true" Then
		guictrlsetstate($Checkbox_registerisnfiles, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_registerisnfiles, $GUI_UNCHECKED)
	endif

	if _Config_Read("registerau3files", "false") = "true" Then
		guictrlsetstate($Checkbox_registerau3files, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_registerau3files, $GUI_UNCHECKED)
	endif

	if _Config_Read("registerispfiles", "true") = "true" Then
		guictrlsetstate($Checkbox_registerispfiles, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_registerispfiles, $GUI_UNCHECKED)
	endif

	if _Config_Read("registericpfiles", "true") = "true" Then
		guictrlsetstate($Checkbox_registericpfiles, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_registericpfiles, $GUI_UNCHECKED)
	 endif

	if _Config_Read("hideprogramlog", "false") = "true" Then
		guictrlsetstate($Checkbox_hideprogramlog, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_hideprogramlog, $GUI_UNCHECKED)
	endif

	if _Config_Read("hidefunctionstree", "false") = "true" Then
		guictrlsetstate($Checkbox_hidefunctionstree, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_hidefunctionstree, $GUI_UNCHECKED)
	endif

	if _Config_Read("select_current_func_in_scripttree", "false") = "true" Then
		guictrlsetstate($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_CHECKED)
	Else
		guictrlsetstate($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_UNCHECKED)
	endif

	if _Config_Read("hidedebug", "false") = "true" Then
		guictrlsetstate($Checkbox_hidedebug, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_hidedebug, $GUI_UNCHECKED)
	endif

	if _Config_Read("globalautocomplete", "true") = "true" Then
		guictrlsetstate($Checkbox_globalautocomplete, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_globalautocomplete, $GUI_UNCHECKED)
	endif

	if _Config_Read("globalautocomplete_current_script", "false") = "true" Then
		guictrlsetstate($Checkbox_globalautocomplete_current_script, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_globalautocomplete_current_script, $GUI_UNCHECKED)
	endif

	if _Config_Read("disableautocomplete", "false") = "true" Then
		guictrlsetstate($Checkbox_disableautocomplete, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_disableautocomplete, $GUI_UNCHECKED)
	endif

	if _Config_Read("disableintelisense", "false") = "true" Then
		guictrlsetstate($Checkbox_disableintelisense, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_disableintelisense, $GUI_UNCHECKED)
	endif

	if _Config_Read("showlines", "true") = "true" Then
		guictrlsetstate($Checkbox_showlines, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_showlines, $GUI_UNCHECKED)
	endif

	if _Config_Read("search_au3paths_on_startup", "false") = "true" Then
		guictrlsetstate($Checkbox_Programmpfade_automatisch_erkennen, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Programmpfade_automatisch_erkennen, $GUI_UNCHECKED)
	endif

	if FileExists(@scriptdir&"\portable.dat") Then
	guictrlsetstate($Checkbox_Programmpfade_automatisch_erkennen, $GUI_CHECKED)
	GUICtrlSetState($Checkbox_Programmpfade_automatisch_erkennen,$GUI_DISABLE)
	endif

	if _Config_Read("allowcommentout", "true") = "true" Then
		guictrlsetstate($Checkbox_allowcommentout, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_allowcommentout, $GUI_UNCHECKED)
	endif

	if _Config_Read("use_new_au3_colours", "false") = "true" Then
		guictrlsetstate($Checkbox_use_new_colours, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_use_new_colours, $GUI_UNCHECKED)
	endif

	if _Config_Read("enablebackup", "true") = "true" Then
		guictrlsetstate($Checkbox_enablebackup, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_enablebackup, $GUI_UNCHECKED)
	 endif

    if _Config_Read("manage_additional_includes_with_ISN", "false") = "true" Then
		guictrlsetstate($Einstellungen_AutoItIncludes_Verwalten_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Einstellungen_AutoItIncludes_Verwalten_Checkbox, $GUI_UNCHECKED)
	endif

	if _Config_Read("run_scripts_with_au3wrapper", "false") = "true" Then
		guictrlsetstate($checkbox_run_scripts_with_au3wrapper, $GUI_CHECKED)
	Else
		guictrlsetstate($checkbox_run_scripts_with_au3wrapper, $GUI_UNCHECKED)
	endif

	if _Config_Read("protect_files_from_external_modification", "true") = "true" Then
		guictrlsetstate($Checkbox_protect_files_from_external_modification, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_protect_files_from_external_modification, $GUI_UNCHECKED)
	endif

	if _Config_Read("enabledeleteoldbackups", "true") = "true" Then
		guictrlsetstate($Checkbox_enabledeleteoldbackups, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_enabledeleteoldbackups, $GUI_UNCHECKED)
	endif

	if _Config_Read("scripteditor_backgroundcolour_forall", "true") = "true" Then
		guictrlsetstate($einstellungen_farben_hintergrund_fuer_alle_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($einstellungen_farben_hintergrund_fuer_alle_checkbox, $GUI_UNCHECKED)
	 endif


   if _Config_Read("highDPI_mode", "true") = "true" Then
		guictrlsetstate($programmeinstellungen_Darstellung_HighDPIMode_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($programmeinstellungen_Darstellung_HighDPIMode_Checkbox, $GUI_UNCHECKED)
	endif

   if _Config_Read("enable_custom_dpi_value", "false") = "true" Then
		guictrlsetstate($programmeinstellungen_Darstellung_WindowsDPIMode_Checkbox, $GUI_UNCHECKED)
		guictrlsetstate($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($programmeinstellungen_Darstellung_WindowsDPIMode_Checkbox, $GUI_CHECKED)
		guictrlsetstate($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox, $GUI_UNCHECKED)
	endif

	if _Config_Read("savefolding", "true") = "true" Then
		guictrlsetstate($Checkbox_savefolding, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_savefolding, $GUI_UNCHECKED)
	endif

	if _Config_Read("auto_save_enabled", "true") = "true" Then
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_Aktivieren_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_Aktivieren_Checkbox, $GUI_UNCHECKED)
	endif

	if _Config_Read("auto_save_only_script_tabs", "false") = "true" Then
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox, $GUI_UNCHECKED)
   endif

    if _Config_Read("auto_save_only_current_tab", "false") = "true" Then
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox, $GUI_UNCHECKED)
    endif

    if _Config_Read("auto_save_mode", "1") = "1" Then
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_Timer_Radio, $GUI_CHECKED)
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_Input_Radio, $GUI_UNCHECKED)
	Else
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_Timer_Radio, $GUI_UNCHECKED)
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_Input_Radio, $GUI_CHECKED)
	endif

    if _Config_Read("auto_save_once_mode", "true") = "true" Then
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_UNCHECKED)
	endif

   GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, _Config_Read("auto_save_timer_secounds", "0"))
   GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, _Config_Read("auto_save_timer_minutes", "5"))
   GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, _Config_Read("auto_save_timer_hours", "0"))

   GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, _Config_Read("auto_save_input_secounds", "0"))
   GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, _Config_Read("auto_save_input_minutes", "1"))
   GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, _Config_Read("auto_save_input_hours", "0"))


	if _Config_Read("run_always_on_primary_screen", "true") = "true" Then
		guictrlsetstate($_Immer_am_primaeren_monitor_starten_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($_Immer_am_primaeren_monitor_starten_checkbox, $GUI_UNCHECKED)
	 endif

   if _Config_Read("scripteditor_doubleclickparametereditor", "false") = "true" Then
		guictrlsetstate($Checkbox_Settings_Auto_ParameterEditor, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Settings_Auto_ParameterEditor, $GUI_UNCHECKED)
	endif

   if _Config_Read("tools_Bitoperation_tester_enabled", "true") = "true" Then
		guictrlsetstate($setting_tools_bitoperation_enabled_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($setting_tools_bitoperation_enabled_checkbox, $GUI_UNCHECKED)
	endif

   if _Config_Read("tools_parameter_editor_enabled", "true") = "true" Then
		guictrlsetstate($setting_tools_parametereditor_enabled_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($setting_tools_parametereditor_enabled_checkbox, $GUI_UNCHECKED)
	endif


   if _Config_Read("tools_pelock_obfuscator_enabled", "true") = "true" Then
		guictrlsetstate($setting_tools_obfuscator_enabled_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($setting_tools_obfuscator_enabled_checkbox, $GUI_UNCHECKED)
	endif


	if _Config_Read("showdebuggui", "true") = "true" Then
		guictrlsetstate($Checkbox_disabledebuggui, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_disabledebuggui, $GUI_UNCHECKED)
   endif

   if _Config_Read("debugbuttons", "true") = "true" Then
		guictrlsetstate($Checkbox_scripteditor_debug_show_buttons_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_scripteditor_debug_show_buttons_checkbox, $GUI_UNCHECKED)
	 endif

   if _Config_Read("scripteditor_auto_manage_filetypes", "true") = "true" Then
		guictrlsetstate($Einstellungen_Skripteditor_Dateitypen_automatisch_radio, $GUI_CHECKED)
		guictrlsetstate($Einstellungen_Skripteditor_Dateitypen_manuell_radio, $GUI_UNCHECKED)
	Else
		guictrlsetstate($Einstellungen_Skripteditor_Dateitypen_manuell_radio, $GUI_CHECKED)
		guictrlsetstate($Einstellungen_Skripteditor_Dateitypen_automatisch_radio, $GUI_UNCHECKED)
	endif

	if _Config_Read("useisntoconfigtidy", "false") = "true" Then
		guictrlsetstate($einstellungen_tidy_ueberdasISNverwalten, $GUI_CHECKED)
	Else
		guictrlsetstate($einstellungen_tidy_ueberdasISNverwalten, $GUI_UNCHECKED)
	endif

	guictrlsetdata($Einstellungen_Backup_Ordnerstruktur_input, _Config_Read("backup_folderstructure", "%projectname%\%mday%.%mon%.%year%\%hour%h %min%m"))
	guictrlsetdata($Input_backuptime, _Config_Read("backuptime", "30"))
	guictrlsetdata($Input_deleteoldbackupsafter, _Config_Read("deleteoldbackupsafter", "30"))


   guictrlsetdata($Einstellungen_Pfade_Pluginpfad_input, $Pluginsdir)
   guictrlsetdata($Input_Projekte_Pfad, $Projectfolder)
   guictrlsetdata($Input_Backup_Pfad, $Backupfolder)
   guictrlsetdata($Input_Release_Pfad, $releasefolder)
   guictrlsetdata($Input_template_Pfad, $templatefolder)


	if _Config_Read("skin", "#none#") = "#none#" Then
		guictrlsetstate($config_skin_radio1, $GUI_CHECKED)
		guictrlsetstate($config_skin_radio2, $GUI_UNCHECKED)
	Else
		guictrlsetstate($config_skin_radio2, $GUI_CHECKED)
		guictrlsetstate($config_skin_radio1, $GUI_UNCHECKED)
	endif

	if _Config_Read("Use_Proxy", "false") = "true" Then
		guictrlsetstate($proxy_enable_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($proxy_enable_checkbox, $GUI_UNCHECKED)
	endif

	if _Config_Read("show_projects_in_projecttree", "false") = "true" Then
		guictrlsetstate($Checkbox_projekte_im_projektbaum, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_projekte_im_projektbaum, $GUI_UNCHECKED)
	endif

   switch _Config_Read("macro_security_level", "1")

	  case 0
		 GUICtrlSetData($programmeinstellungen_makrosicherheit_slider,4)

	  case 1
		 GUICtrlSetData($programmeinstellungen_makrosicherheit_slider,3)

	  case 2
		 GUICtrlSetData($programmeinstellungen_makrosicherheit_slider,2)

	  case 3
		 GUICtrlSetData($programmeinstellungen_makrosicherheit_slider,1)

	  case 4
		 GUICtrlSetData($programmeinstellungen_makrosicherheit_slider,0)

   EndSwitch

	$Toolbarlayout = _Config_Read("toolbar_layout",$Toolbar_Standardlayout)


     GUICtrlSetData($programmeinstellungen_DPI_Slider, number(_Config_Read("custom_dpi_value", 1))*100)
    _Darstellung_bewege_DPI_Slider()
    _API_Pfade_in_Listview_Laden()
    _Einstellungen_Skript_Editor_Dateitypen_in_Listview_Laden()
    _Lade_Weitere_Includes_in_Listview()
	_Einstellungen_Toolbar_Lade_Verfuegbarliste()
	_Einstellungen_Toolbar_Lade_Elemente_aus_Layout()
	_Immer_am_primaeren_monitor_starten_Toggle_Checkbox()
	_Toggle_autocompletefields()
	_Toggle_autoupdatefields()
	_Toggle_Filetypes_Modes()
	_Programmeinstellungen_Tools_Checkbox_event()
	_Toggle_proxyfields()
	_Toggle_Skripteditor()
	_Toggle_Autosave_Modes()
	_Toggle_backupmode()
	_Load_Skins()
	_Toggle_Skin()
	_Disable_edit()
	_Load_Languages()
	_List_Plugins()
	_Aktualisiere_Hotkeyliste()
	_Select_Language()
	_Einstellungen_Lade_Farben()
	_settings_toggle_tidywithISN()
	_Tidy_Einstellungen_einlesen()
EndFunc

func _HIDE_Configgui()
	if $Offenes_Projekt = "" AND $Studiomodus = 1 Then
		_Load_Projectlist()
		guisetstate(@SW_SHOW, $Welcome_GUI)
	Else
		guisetstate(@SW_ENABLE, $StudioFenster)

	endif

;~ 	if _GUICtrlTab_GetItemCount($htab) > 0 then WinSetOnTop($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)], "", 1)
	GUISetState(@SW_HIDE, $Config_GUI)
	_Enable_edit()
EndFunc

func _Save_Settings()

	$Require_Restart = 0

	GUISetState(@sw_show, $Einstellungen_werden_gespeichert_GUI)
	guisetstate(@SW_DISABLE, $Config_GUI)
	_Write_ISN_Debug_Console("Saving Configuration...", 1, 0)
	if $Languagefile <> $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1] Then $Require_Restart = 1

   if GuiCtrlRead($config_skin_radio2) = $GUI_CHECKED Then
		if $skin <> _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) then
		   $Require_Restart = 1
		   if  _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) = "Dark Theme" then
			 $res = msgbox(4+32+262144,_Get_langstr(48),_Get_langstr(1149),0,$Einstellungen_werden_gespeichert_GUI)
			 if $res = 6 then _farbeinstellungen_fuer_dark_theme_vorbereiten()
		   EndIf
	  Endif
   EndIf

	if GuiCtrlRead($config_skin_radio1) = $GUI_CHECKED Then
		if $skin <> "#none#" then
		   $Require_Restart = 1
			 $res = msgbox(4+32+262144,_Get_langstr(48),_Get_langstr(1177),0,$Einstellungen_werden_gespeichert_GUI)
			 if $res = 6 then _farbeinstellungen_auf_Standard_vorbereiten()
		 EndIf
	EndIf

	if GuiCtrlRead($config_skin_radio2) = $GUI_CHECKED Then
		if _GUICtrlListView_GetSelectionMark($config_skin_list) = -1 then
			_Write_in_Config("skin", "#none#")
		else
			_Write_in_Config("skin", _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2))
		endif
	Else
		_Write_in_Config("skin", "#none#")
	 endif

	if GuiCtrlRead($Combo_closeprogramm) = _Get_langstr(319) Then
		_Write_in_Config("closeaction", "close")
		$closeaction = "close"
	endif

	if GuiCtrlRead($Combo_closeprogramm) = _Get_langstr(320) Then
		_Write_in_Config("closeaction", "closeproject")
		$closeaction = "closeproject"
	endif

	if GuiCtrlRead($Combo_closeprogramm) = _Get_langstr(321) Then
		_Write_in_Config("closeaction", "minimize")
		$closeaction = "minimize"
	endif



	if _Write_in_Config("language", $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1]) = 0 Then
   msgbox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1181),"%1",$Configfile), 0, $Einstellungen_werden_gespeichert_GUI)
   EndIf

	;save Monitor
	$strx = StringTrimLeft(guictrlread($darstellung_monitordropdown), stringlen(_Get_langstr(448)) + 1)
	$strx = Number($strx)
	_Write_in_Config("runonmonitor", $strx)
	$Runonmonitor = $strx

	;Automatisches Update Intervall
	$time = guictrlread($config_autoupdate_time_in_days)
	$time = number($time)
	if $time < 1 then $time = 1
	_Write_in_Config("autoupdate_searchtimer", $time)
	$autoupdate_searchtimer = $time

	;Proxy
	_Write_in_Config("proxy_server", guictrlread($proxy_server_input))
	$proxy_server = guictrlread($proxy_server_input)

	_Write_in_Config("proxy_port", guictrlread($proxy_port_input))
	$proxy_port = guictrlread($proxy_port_input)

	_Write_in_Config("proxy_username", guictrlread($proxy_username_input))
	$proxy_username = guictrlread($proxy_username_input)

	if guictrlread($proxy_password_input) = "" then
		$pw = ""
	else
;~ 		$pw = _StringEncrypt(1, guictrlread($proxy_password_input), "Isn_pRoxy_PW", 2)
		$pw = _Crypt_EncryptData (guictrlread($proxy_password_input),"Isn_pRoxy_PW",$CALG_RC4)
	 EndIf
	_Write_in_Config("proxy_PW", $pw)
	$proxy_PW = $pw

	if guictrlread($settings_pelock_key_input) = "" then
		_Write_in_Config("pelock_key", "")
	else
		_Write_in_Config("pelock_key", _Crypt_EncryptData (guictrlread($settings_pelock_key_input),"Isn_p#EloCK!!_PW",$CALG_RC4))
	 EndIf



	if $scripteditor_font <> guictrlread($darstellung_scripteditor_font) then $Require_Restart = 1
	_Write_in_Config("scripteditor_font", guictrlread($darstellung_scripteditor_font))
	$scripteditor_font = guictrlread($darstellung_scripteditor_font)

	if $scripteditor_size <> number(StringReplace(guictrlread($darstellung_scripteditor_size), ",", ".")) then $Require_Restart = 1
	_Write_in_Config("scripteditor_size", number(StringReplace(guictrlread($darstellung_scripteditor_size), ",", ".")))
	$scripteditor_size = guictrlread($darstellung_scripteditor_size)

	if $scripteditor_bgcolour <> guictrlread($darstellung_scripteditor_bgcolour) then $Require_Restart = 1
	_Write_in_Config("scripteditor_bgcolour", guictrlread($darstellung_scripteditor_bgcolour))
	$scripteditor_bgcolour = guictrlread($darstellung_scripteditor_bgcolour)

	if $scripteditor_rowcolour <> guictrlread($darstellung_scripteditor_rowcolour) then $Require_Restart = 1
	_Write_in_Config("scripteditor_rowcolour", guictrlread($darstellung_scripteditor_rowcolour))
	$scripteditor_rowcolour = guictrlread($darstellung_scripteditor_rowcolour)

	if $scripteditor_marccolour <> guictrlread($darstellung_scripteditor_marccolour) then $Require_Restart = 1
	_Write_in_Config("scripteditor_marccolour", guictrlread($darstellung_scripteditor_marccolour))
	$scripteditor_marccolour = guictrlread($darstellung_scripteditor_marccolour)

	_Write_in_Config("scripteditor_highlightcolour", guictrlread($darstellung_scripteditor_highlightcolour))
	$scripteditor_highlightcolour = guictrlread($darstellung_scripteditor_highlightcolour)

	_Write_in_Config("scripteditor_caretcolour", guictrlread($darstellung_scripteditor_cursorcolor))
	$scripteditor_caretcolour = guictrlread($darstellung_scripteditor_cursorcolor)

	_Write_in_Config("scripteditor_errorcolour", guictrlread($darstellung_scripteditor_errorcolor))
	$scripteditor_errorcolour = guictrlread($darstellung_scripteditor_errorcolor)

	_Write_in_Config("scripteditor_caretwidth", guictrlread($darstellung_scripteditor_cursorwidth))
	$scripteditor_caretwidth = guictrlread($darstellung_scripteditor_cursorwidth)

	if GuiCtrlRead($darstellung_scripteditor_cursorstyle_Radio1) = $GUI_CHECKED Then
		$scripteditor_caretstyle = "1"
		_Write_in_Config("scripteditor_caretstyle", "1")
	Else
		$scripteditor_caretstyle = "2"
		_Write_in_Config("scripteditor_caretstyle", "2")
	 endif


	_Write_in_Config("treefont_font", guictrlread($darstellung_treefont_font))
	$treefont_font = guictrlread($darstellung_treefont_font)

	_Write_in_Config("treefont_size", number(StringReplace(guictrlread($darstellung_treefont_size), ",", ".")))
	$treefont_size = number(StringReplace(guictrlread($darstellung_treefont_size), ",", "."))

	_Write_in_Config("treefont_colour", guictrlread($darstellung_treefont_colour))
	$treefont_colour = guictrlread($darstellung_treefont_colour)

	if $Default_font <> guictrlread($darstellung_defaultfont_font) then $Require_Restart = 1
	_Write_in_Config("default_font", guictrlread($darstellung_defaultfont_font))
	$Default_font = guictrlread($darstellung_defaultfont_font)

	if $Default_font_size <> number(StringReplace(guictrlread($darstellung_defaultfont_size), ",", ".")) then $Require_Restart = 1
	_Write_in_Config("default_font_size", number(StringReplace(guictrlread($darstellung_defaultfont_size), ",", ".")))
	$Default_font_size = number(StringReplace(guictrlread($darstellung_defaultfont_size), ",", "."))

	_Write_in_Config("runbefore", guictrlread($config_inputstartbefore))
	_Write_in_Config("runafter", guictrlread($config_inputstartafter))
	$runbefore = guictrlread($config_inputstartbefore)
	$runafter = guictrlread($config_inputstartafter)

	_Write_in_Config("autoitexe", guictrlread($Input_config_au3exe))
	$autoitexe = _ISN_Variablen_aufloesen(guictrlread($Input_config_au3exe))

	_Write_in_Config("helpfileexe", guictrlread($Input_config_helpfile))
	$helpfile = _ISN_Variablen_aufloesen(guictrlread($Input_config_helpfile))

	_Write_in_Config("autoit2exe", guictrlread($Input_config_au2exe))
	$autoit2exe = _ISN_Variablen_aufloesen(guictrlread($Input_config_au2exe))

	_Write_in_Config("au3infoexe", guictrlread($Input_config_Au3Infoexe))
	$Au3Infoexe = _ISN_Variablen_aufloesen(guictrlread($Input_config_Au3Infoexe))

	_Write_in_Config("au3checkexe", guictrlread($Input_config_Au3Checkexe))
	$Au3Checkexe = _ISN_Variablen_aufloesen(guictrlread($Input_config_Au3Checkexe))

	_Write_in_Config("au3stripperexe", guictrlread($Input_config_au3stripperexe))
	$Au3Stripperexe = _ISN_Variablen_aufloesen(guictrlread($Input_config_au3stripperexe))

	_Write_in_Config("tidyexe", guictrlread($Input_config_Tidyexe))
	$Tidyexe = _ISN_Variablen_aufloesen(guictrlread($Input_config_Tidyexe))





   if guictrlread($config_fertigeprojecte_dropdown) = _Get_langstr(413) then
		if guictrlread($Input_Release_Pfad) = "" then guictrlsetdata($Input_Release_Pfad, $Standardordner_Release)
		  else
		 if guictrlread($Input_Release_Pfad) = "" then guictrlsetdata($Input_Release_Pfad, "Release")
		 if StringInStr(guictrlread($Input_Release_Pfad),"\") then guictrlsetdata($Input_Release_Pfad, StringReplace(guictrlread($Input_Release_Pfad),"\",""))
		 if StringInStr(guictrlread($Input_Release_Pfad),":") then guictrlsetdata($Input_Release_Pfad, StringReplace(guictrlread($Input_Release_Pfad),":",""))
	endif
   _Write_in_Config("releasefolder", guictrlread($Input_Release_Pfad))
   $releasefolder = guictrlread($Input_Release_Pfad)

   if guictrlread($config_fertigeprojecte_dropdown) = _Get_langstr(413) then
		_Write_in_Config("releasemode", "1")
		$releasemode = 1
   else
		_Write_in_Config("releasemode", "2")
		$releasemode = 2
   endif


    if guictrlread($config_backupmode_combo) = _Get_langstr(425) then
		if guictrlread($Input_Backup_Pfad) = "" then guictrlsetdata($Input_Backup_Pfad, $Standardordner_backups)
		  else
		 if guictrlread($Input_Backup_Pfad) = "" then guictrlsetdata($Input_Backup_Pfad, "Backup")
		 if StringInStr(guictrlread($Input_Backup_Pfad),"\") then guictrlsetdata($Input_Backup_Pfad, StringReplace(guictrlread($Input_Backup_Pfad),"\",""))
		 if StringInStr(guictrlread($Input_Backup_Pfad),":") then guictrlsetdata($Input_Backup_Pfad, StringReplace(guictrlread($Input_Backup_Pfad),":",""))
   endif


	_Write_in_Config("backupfolder", guictrlread($Input_Backup_Pfad))
	_Write_in_Config("backup_folderstructure", guictrlread($Einstellungen_Backup_Ordnerstruktur_input))
	$Autobackup_Ordnerstruktur = guictrlread($Einstellungen_Backup_Ordnerstruktur_input)

	if guictrlread($config_backupmode_combo) = _Get_langstr(425) then
		_Write_in_Config("backupmode", "1")
		$backupmode = 1
		$Backupfolder = guictrlread($Input_Backup_Pfad)
	endif
	if guictrlread($config_backupmode_combo) = _Get_langstr(426) then
		_Write_in_Config("backupmode", "2")
		$backupmode = 2
		$Backupfolder = guictrlread($Input_Backup_Pfad)
	endif


	if guictrlread($Input_Projekte_Pfad) = "" then GUICtrlSetData($Input_Projekte_Pfad,$Standardordner_Projects)
	$Projectfolder = guictrlread($Input_Projekte_Pfad)
	_Write_in_Config("projectfolder", $Projectfolder)


    if guictrlread($Einstellungen_Pfade_Pluginpfad_input) = "" then GUICtrlSetData($Einstellungen_Pfade_Pluginpfad_input,$Standardordner_Plugins)
   $Pluginsdir = guictrlread($Einstellungen_Pfade_Pluginpfad_input)
   _Write_in_Config("pluginsdir", $Pluginsdir)


    if guictrlread($Input_template_Pfad) = "" then GUICtrlSetData($Input_template_Pfad,$Standardordner_Templates)
	$templatefolder = guictrlread($Input_template_Pfad)
	_Write_in_Config("templatefolder", $templatefolder)


	$i = guictrlread($Input_backuptime)
	if $i = "" then $i = "30"
	if $i = 0 then $i = "30"
	_Write_in_Config("backuptime", $i)
	$backuptime = $i

	$i = guictrlread($Input_deleteoldbackupsafter)
	if $i = "" then $i = "30"
	if $i = 0 then $i = "30"
	_Write_in_Config("deleteoldbackupsafter", $i)
	$deleteoldbackupsafter = $i

	if GuiCtrlRead($Checkbox_lade_zuletzt_geoeffnete_Dateien) = $GUI_CHECKED Then
		$lade_zuletzt_geoeffnete_Dateien = "true"
		_Write_in_Config("restore_old_tabs", "true")
	Else
		$lade_zuletzt_geoeffnete_Dateien = "false"
		_Write_in_Config("restore_old_tabs", "false")
	endif

	if GuiCtrlRead($Checkbox_enable_autoupdate) = $GUI_CHECKED Then
		$enable_autoupdate = "true"
		_Write_in_Config("enable_autoupdate", "true")
	Else
		$enable_autoupdate = "false"
		_Write_in_Config("enable_autoupdate", "false")
	endif


	if GuiCtrlRead($programmeinstellungen_Darstellung_HighDPIMode_Checkbox) = $GUI_CHECKED Then
	   if _Config_Read("highDPI_mode", "true") <> "true" then $Require_Restart = 1
		_Write_in_Config("highDPI_mode", "true")
	 Else
		if _Config_Read("highDPI_mode", "true") <> "false" then $Require_Restart = 1
		_Write_in_Config("highDPI_mode", "false")
	endif

	if GuiCtrlRead($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox) = $GUI_CHECKED Then
	   if _Config_Read("enable_custom_dpi_value", "false") <> "true" then $Require_Restart = 1
		_Write_in_Config("enable_custom_dpi_value", "true")
	 Else
		if _Config_Read("enable_custom_dpi_value", "false") <> "false" then $Require_Restart = 1
		_Write_in_Config("enable_custom_dpi_value", "false")
	endif

	if GuiCtrlRead($Checkbox_fullscreenmode) = $GUI_CHECKED Then
		$fullscreenmode = "true"
		_Write_in_Config("fullscreenmode", "true")
	Else
		$fullscreenmode = "false"
		_Write_in_Config("fullscreenmode", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_showfunctions) = $GUI_CHECKED Then
		$showfunctions = "true"
		_Write_in_Config("showfunctions", "true")
	Else
		$showfunctions = "false"
		_Write_in_Config("showfunctions", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_expandfunctions) = $GUI_CHECKED Then
		$expandfunctions = "true"
		_Write_in_Config("expandfunctions", "true")
	Else
		$expandfunctions = "false"
		_Write_in_Config("expandfunctions", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_showglobalvariables) = $GUI_CHECKED Then
		$showglobalvariables = "true"
		_Write_in_Config("showglobalvariables", "true")
	Else
		$showglobalvariables = "false"
		_Write_in_Config("showglobalvariables", "false")
	endif

	if GuiCtrlRead($Darstellung_ISN_Fensterpositionen_speichern_checkbox) = $GUI_CHECKED Then
		$Alte_Fensterposition_verwenden = "true"
		_Write_in_Config("isn_save_window_position", "true")
	Else
		$Alte_Fensterposition_verwenden = "false"
		_Write_in_Config("isn_save_window_position", "false")
	 endif


	if GuiCtrlRead($Checkbox_contextmenu_au3files) = $GUI_CHECKED Then
		$registerinexplorer = "true"
		_Write_in_Config("registerinexplorer", "true")
	Else
		$registerinexplorer = "false"
		_Write_in_Config("registerinexplorer", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_expandglobalvariables) = $GUI_CHECKED Then
		$expandglobalvariables = "true"
		_Write_in_Config("expandglobalvariables", "true")
	Else
		$expandglobalvariables = "false"
		_Write_in_Config("expandglobalvariables", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_alphabetisch) = $GUI_CHECKED Then
		$Skriptbaum_Funcs_alphabetisch_sortieren = "true"
		_Write_in_Config("scripttree_sort_funcs_alphabetical", "true")
	Else
		$Skriptbaum_Funcs_alphabetisch_sortieren = "false"
		_Write_in_Config("scripttree_sort_funcs_alphabetical", "false")
	 endif


	if GuiCtrlRead($skriptbaum_config_checkbox_showlocalvariables) = $GUI_CHECKED Then
		$showlocalvariables = "true"
		_Write_in_Config("showlocalvariables", "true")
	Else
		$showlocalvariables = "false"
		_Write_in_Config("showlocalvariables", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_expandlocalvariables) = $GUI_CHECKED Then
		$expandlocalvariables = "true"
		_Write_in_Config("expandlocalvariables", "true")
	Else
		$expandlocalvariables = "false"
		_Write_in_Config("expandlocalvariables", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_showincludes) = $GUI_CHECKED Then
		$showincludes = "true"
		_Write_in_Config("showincludes", "true")
	Else
		$showincludes = "false"
		_Write_in_Config("showincludes", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_expandincludes) = $GUI_CHECKED Then
		$expandincludes = "true"
		_Write_in_Config("expandincludes", "true")
	Else
		$expandincludes = "false"
		_Write_in_Config("expandincludes", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_bearbeitete_func_markieren) = $GUI_CHECKED Then
		$Bearbeitende_Function_im_skriptbaum_markieren = "true"
		_Write_in_Config("select_current_func_in_scripttree", "true")
	Else
		$Bearbeitende_Function_im_skriptbaum_markieren = "false"
		_Write_in_Config("select_current_func_in_scripttree", "false")
	 endif


	if GuiCtrlRead($skriptbaum_config_checkbox_showforms) = $GUI_CHECKED Then
		$showforms = "true"
		_Write_in_Config("showforms", "true")
	Else
		$showforms = "false"
		_Write_in_Config("showforms", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_expandforms) = $GUI_CHECKED Then
		$expandforms = "true"
		_Write_in_Config("expandforms", "true")
	Else
		$expandforms = "false"
		_Write_in_Config("expandforms", "false")
	 endif

   if GuiCtrlRead($Checkbox_Settings_Auto_ParameterEditor) = $GUI_CHECKED Then
		$SkriptEditor_Doppelklick_ParameterEditor = "true"
		_Write_in_Config("scripteditor_doubleclickparametereditor", "true")
	Else
		$SkriptEditor_Doppelklick_ParameterEditor = "false"
		_Write_in_Config("scripteditor_doubleclickparametereditor", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_showregions) = $GUI_CHECKED Then
		$showregions = "true"
		_Write_in_Config("showregions", "true")
	Else
		$showregions = "false"
		_Write_in_Config("showregions", "false")
	endif

	if GuiCtrlRead($skriptbaum_config_checkbox_expandregions) = $GUI_CHECKED Then
		$expandregions = "true"
		_Write_in_Config("expandregions", "true")
	Else
		$expandregions = "false"
		_Write_in_Config("expandregions", "false")
	endif

	if GuiCtrlRead($Checkbox_disabletrophys) = $GUI_CHECKED Then
		$allow_trophys = "false"
		_Write_in_Config("trophys", "false")
	Else
		$allow_trophys = "true"
		_Write_in_Config("trophys", "true")
	 endif

    if GuiCtrlRead($Checkbox_Settings_AutoEndIf_Checkbox) = $GUI_CHECKED Then
	   	$AutoEnd_Keywords = "true"
		_Write_in_Config("autoend_keywords", "true")

	Else
		 $AutoEnd_Keywords = "false"
		_Write_in_Config("autoend_keywords", "false")
	 endif


	  if GuiCtrlRead($Checkbox_Settings_Deklarationen_Auto_Dollar_Checkbox) = $GUI_CHECKED Then
	   	$Auto_dollar_for_declarations = "true"
		_Write_in_Config("auto_dollar_for_declarations", "true")

	Else
		 $Auto_dollar_for_declarations = "false"
		_Write_in_Config("auto_dollar_for_declarations", "false")
	 endif


   if GuiCtrlRead($Checkbox_scripteditor_debug_show_buttons_checkbox) = $GUI_CHECKED Then
		$Zeige_Buttons_neben_Debug_Fenster = "true"
		_Write_in_Config("debugbuttons", "true")
	Else
		$Zeige_Buttons_neben_Debug_Fenster = "false"
		_Write_in_Config("debugbuttons", "false")
	endif


   if GuiCtrlRead($Programmeinstellungen_Automatische_Speicherung_Aktivieren_Checkbox) = $GUI_CHECKED Then
		$Automatische_Speicherung_Aktiv = "true"
		_Write_in_Config("auto_save_enabled", "true")
	Else
		$Automatische_Speicherung_Aktiv = "false"
		_Write_in_Config("auto_save_enabled", "false")
   endif

   if GuiCtrlRead($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox) = $GUI_CHECKED Then
		$Automatische_Speicherung_Nur_Skript_Tabs_Sichern = "true"
		_Write_in_Config("auto_save_only_script_tabs", "true")
	Else
		$Automatische_Speicherung_Nur_Skript_Tabs_Sichern = "false"
		_Write_in_Config("auto_save_only_script_tabs", "false")
   endif

   if GuiCtrlRead($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox) = $GUI_CHECKED Then
		$Automatische_Speicherung_Nur_aktuellen_Tabs_Sichern = "true"
		_Write_in_Config("auto_save_only_current_tab", "true")
	Else
		$Automatische_Speicherung_Nur_aktuellen_Tabs_Sichern = "false"
		_Write_in_Config("auto_save_only_current_tab", "false")
	endif

   if GuiCtrlRead($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox) = $GUI_CHECKED Then
		$Automatische_Speicherung_Eingabe_Nur_einmal_sichern = "true"
		_Write_in_Config("auto_save_once_mode", "true")
	Else
		$Automatische_Speicherung_Eingabe_Nur_einmal_sichern = "false"
		_Write_in_Config("auto_save_once_mode", "false")
	endif

   if GuiCtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_Radio) = $GUI_CHECKED Then
		$Automatische_Speicherung_Modus = "1"
		_Write_in_Config("auto_save_mode", "1")
	Else
		$Automatische_Speicherung_Modus = "2"
		_Write_in_Config("auto_save_mode", "2")
	endif


   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input) < 0 OR guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input) = "" then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input,0)
   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input) < 0 OR guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input) = "" then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input,0)
   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input) < 0 OR guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input) = "" then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input,0)
   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input) = "0" AND guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input) = "0" AND guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input) = "0" then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input,"5")

   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input) = "0" AND guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input) = "0" then
	  if guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input) < 30 then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input,"30")
   endif

   local $autoupdate_time_h = 0
   local $autoupdate_time_m = 0
   local $autoupdate_time_s = 0

   _TicksToTime (_TimeToTicks (guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input), guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input), guictrlread($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input)),$autoupdate_time_h, $autoupdate_time_m, $autoupdate_time_s)

   $Automatische_Speicherung_Timer_Sekunden = $autoupdate_time_s
   _Write_in_Config("auto_save_timer_secounds", $autoupdate_time_s)

   $Automatische_Speicherung_Timer_Minuten = $autoupdate_time_m
   _Write_in_Config("auto_save_timer_minutes", $autoupdate_time_m)

   $Automatische_Speicherung_Timer_Stunden = $autoupdate_time_h
   _Write_in_Config("auto_save_timer_hours", $autoupdate_time_h)





   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input) < 0 OR guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input) = "" then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input,0)
   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input) < 0 OR guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input) = "" then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input,0)
   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input) < 0 OR guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input) = "" then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input,0)
   if guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input) = "0" AND guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input) = "0" AND guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input) = "0" then GUICtrlSetData($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input,"1")

   $autoupdate_time_h = 0
   $autoupdate_time_m = 0
   $autoupdate_time_s = 0

   _TicksToTime (_TimeToTicks (guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input), guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input), guictrlread($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input)),$autoupdate_time_h, $autoupdate_time_m, $autoupdate_time_s)

   $Automatische_Speicherung_Eingabe_Sekunden = $autoupdate_time_s
   _Write_in_Config("auto_save_input_secounds", $autoupdate_time_s)

   $Automatische_Speicherung_Eingabe_Minuten = $autoupdate_time_m
   _Write_in_Config("auto_save_input_minutes", $autoupdate_time_m)

   $Automatische_Speicherung_Eingabe_Stunden = $autoupdate_time_h
   _Write_in_Config("auto_save_input_hours", $autoupdate_time_h)











	if GuiCtrlRead($Checkbox_protect_files_from_external_modification) = $GUI_CHECKED Then
		$protect_files_from_external_modification = "true"
		_Write_in_Config("protect_files_from_external_modification", "true")
	Else
		$protect_files_from_external_modification = "false"
		_Write_in_Config("protect_files_from_external_modification", "false")
	endif

	if GuiCtrlRead($Checkbox_verwende_intelimark) = $GUI_CHECKED Then
		$verwende_intelimark = "true"
		_Write_in_Config("enable_intelimark", "true")
	Else
		$verwende_intelimark = "false"
		_Write_in_Config("enable_intelimark", "false")
	endif


	if GuiCtrlRead($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED Then
		$hintergrundfarbe_fuer_alle_uebernehmen = "true"
		_Write_in_Config("scripteditor_backgroundcolour_forall", "true")
	Else
		$hintergrundfarbe_fuer_alle_uebernehmen = "false"
		_Write_in_Config("scripteditor_backgroundcolour_forall", "false")
	endif

	if GuiCtrlRead($_Immer_am_primaeren_monitor_starten_checkbox) = $GUI_CHECKED Then
		$Immer_am_primaeren_monitor_starten = "true"
		_Write_in_Config("run_always_on_primary_screen", "true")
	Else
		$Immer_am_primaeren_monitor_starten = "false"
		_Write_in_Config("run_always_on_primary_screen", "false")
	endif

	if GuiCtrlRead($Checkbox_AskExit) = $GUI_CHECKED Then
		$AskExit = "true"
		_Write_in_Config("askexit", "true")
	Else
		$AskExit = "false"
		_Write_in_Config("askexit", "false")
	 endif

	  if GuiCtrlRead($Einstellungen_AutoItIncludes_Verwalten_Checkbox) = $GUI_CHECKED Then
		$Zusaetzliche_Include_Pfade_ueber_ISN_verwalten = "true"
		_Write_in_Config("manage_additional_includes_with_ISN", "true")
	Else
		$Zusaetzliche_Include_Pfade_ueber_ISN_verwalten = "false"
		_Write_in_Config("manage_additional_includes_with_ISN", "false")
	endif

	if GuiCtrlRead($Checkbox_Load_Automatic) = $GUI_CHECKED Then
		$Autoload = "true"
		_Write_in_Config("autoload", "true")
	Else
		$Autoload = "false"
		_Write_in_Config("autoload", "false")
	endif

	if GuiCtrlRead($Checkbox_projekte_im_projektbaum) = $GUI_CHECKED Then
		$AutoIt_Projekte_in_Projektbaum_anzeigen = "true"
		_Write_in_Config("show_projects_in_projecttree", "true")
	Else
		$AutoIt_Projekte_in_Projektbaum_anzeigen = "false"
		_Write_in_Config("show_projects_in_projecttree", "false")
	endif

	if GuiCtrlRead($Einstellungen_Skripteditor_Dateitypen_automatisch_radio) = $GUI_CHECKED Then
		$Skript_Editor_Automatische_Dateitypen = "true"
		_Write_in_Config("scripteditor_auto_manage_filetypes", "true")
	Else
		$Skript_Editor_Automatische_Dateitypen = "false"
		_Write_in_Config("scripteditor_auto_manage_filetypes", "false")
		_Write_in_Config("scripteditor_filetypes", _Einstellungen_Skript_Editor_Dateitypen_String_aus_Listview_Laden())
		$Skript_Editor_Dateitypen_Liste = _Einstellungen_Skript_Editor_Dateitypen_String_aus_Listview_Laden()
	endif

	if $Autoload = "true" Then
		GUICtrlSetState($Willkommen_autoloadcheckbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Willkommen_autoloadcheckbox, $GUI_UNCHECKED)
	endif

	if GuiCtrlRead($Checkbox_enablelogo) = $GUI_CHECKED Then
		$enablelogo = "true"
		_Write_in_Config("enablelogo", "true")
	Else
		$enablelogo = "false"
		_Write_in_Config("enablelogo", "false")
	endif

	if GuiCtrlRead($Checkbox_autoloadmainfile) = $GUI_CHECKED Then
		$autoloadmainfile = "true"
		_Write_in_Config("autoloadmainfile", "true")
	Else
		$autoloadmainfile = "false"
		_Write_in_Config("autoloadmainfile", "false")
	endif

	if GuiCtrlRead($Checkbox_registerisnfiles) = $GUI_CHECKED Then
		$registerisnfiles = "true"
		_Write_in_Config("registerisnfiles", "true")
		_RegisterFileType("isn", _Get_langstr(193), @scriptdir & "\Autoit_Studio.exe")
	Else
		$registerisnfiles = "false"
		_Write_in_Config("registerisnfiles", "false")
		_UnRegisterFileType("isn")
	endif

	if GuiCtrlRead($Checkbox_registerispfiles) = $GUI_CHECKED Then
		$registerispfiles = "true"
		_Write_in_Config("registerispfiles", "true")
		_RegisterFileType("isp", _Get_langstr(479), @scriptdir & "\Autoit_Studio.exe",@scriptdir & "\Data\isp_icon.ico")
	Else
		$registerispfiles = "false"
		_Write_in_Config("registerispfiles", "false")
		_UnRegisterFileType("isp")
	endif

	if GuiCtrlRead($Checkbox_registericpfiles) = $GUI_CHECKED Then
		$registericpfiles = "true"
		_Write_in_Config("registericpfiles", "true")
		_RegisterFileType("icp", _Get_langstr(1319), @ScriptDir & "\Autoit_Studio.exe", @ScriptDir & "\Data\isp_icon.ico")
	Else
		$registericpfiles = "false"
		_Write_in_Config("registericpfiles", "false")
		_UnRegisterFileType("icp")
	 endif

	if GuiCtrlRead($Checkbox_registerau3files) = $GUI_CHECKED Then
		$registerau3files = "true"
		_Write_in_Config("registerau3files", "true")
	Else
		$registerau3files = "false"
		_Write_in_Config("registerau3files", "false")
	endif

	$Pfad_zur_TidyINI = guictrlread($einstellungen_tidy_ini_pfad)
	_Write_in_Config("tidy_ini_path", guictrlread($einstellungen_tidy_ini_pfad))


	if GuiCtrlRead($einstellungen_tidy_ueberdasISNverwalten) = $GUI_CHECKED Then
		$Verwalte_Tidyeinstellungen_mit_dem_ISN = "true"
		_Write_in_Config("useisntoconfigtidy", "true")
	Else
		$Verwalte_Tidyeinstellungen_mit_dem_ISN = "false"
		_Write_in_Config("useisntoconfigtidy", "false")
	endif

	if GuiCtrlRead($Checkbox_hideprogramlog) = $GUI_CHECKED Then
		$hideprogramlog = "true"
		_Write_in_Config("hideprogramlog", "true")
		guictrlsetpos($Left_Splitter_Y, 2, $size1[1] - 26, 200, 5)
		GUICtrlSetState($Left_Splitter_Y, $GUI_HIDE)
		GUICtrlSetState($QuickView_title, $GUI_HIDE)
		GUISetState(@SW_HIDE,$QuickView_GUI)
	Else
		$hideprogramlog = "false"
		_Write_in_Config("hideprogramlog", "false")
		if $Toggle_Leftside = 0 then
			GUICtrlSetState($Programm_log, $GUI_SHOW)
			GUICtrlSetState($Left_Splitter_Y, $GUI_SHOW)
			GUICtrlSetState($QuickView_title, $GUI_SHOW)
			GUISetState(@SW_SHOW,$QuickView_GUI)
		 endif
		 guictrlsetpos($Left_Splitter_Y,2, ($size1[1]/100)*number(_Config_Read("Left_Splitter_Y", $Linker_Splitter_Y_default)))
	endif

	if GuiCtrlRead($Checkbox_hidefunctionstree) = $GUI_CHECKED Then
		$hidefunctionstree = "true"
		_Write_in_Config("hidefunctionstree", "true")
		;guictrlsetpos($VSplitter_2,$size[2]-5, 25, 4, $size[3]-80)
	Else
		$hidefunctionstree = "false"
		_Write_in_Config("hidefunctionstree", "false")
	endif

	if GuiCtrlRead($Checkbox_hidedebug) = $GUI_CHECKED Then
		$hidedebug = "true"
		_Write_in_Config("hidedebug", "true")
		guictrlsetpos($Middle_Splitter_Y, 268, $size1[1] - 20, 200, 4)
	Else
		$hidedebug = "false"
		_Write_in_Config("hidedebug", "false")
		guictrlsetpos($Middle_Splitter_Y,default, ($size1[1]/100)*number(_Config_Read("Middle_Splitter_Y", $Mittlerer_Splitter_Y_default)))
	endif

	if GuiCtrlRead($Einstellungen_skripteditor_Zeichensatz_default) = $GUI_CHECKED Then
		if $autoit_editor_encoding <> "1" then $Require_Restart = 1
		$autoit_editor_encoding = "1"
		_Write_in_Config("autoit_editor_encoding", "1")
	endif

		if GuiCtrlRead($Einstellungen_skripteditor_Zeichensatz_UTF8) = $GUI_CHECKED Then
		if $autoit_editor_encoding <> "2" then $Require_Restart = 1
		$autoit_editor_encoding = "2"
		_Write_in_Config("autoit_editor_encoding", "2")
	endif

	if GuiCtrlRead($Checkbox_globalautocomplete) = $GUI_CHECKED Then
		$globalautocomplete = "true"
		_Write_in_Config("globalautocomplete", "true")
	Else
		$globalautocomplete = "false"
		_Write_in_Config("globalautocomplete", "false")
	endif

	if GuiCtrlRead($Checkbox_Programmpfade_automatisch_erkennen) = $GUI_CHECKED Then
		$Pfade_bei_Programmstart_automatisch_suchen = "true"
		_Write_in_Config("search_au3paths_on_startup", "true")
	Else
		$Pfade_bei_Programmstart_automatisch_suchen = "false"
		_Write_in_Config("search_au3paths_on_startup", "false")
	endif

	if GuiCtrlRead($Checkbox_globalautocomplete_current_script) = $GUI_CHECKED Then
		$globalautocomplete_current_script = "true"
		_Write_in_Config("globalautocomplete_current_script", "true")
	Else
		$globalautocomplete_current_script = "false"
		_Write_in_Config("globalautocomplete_current_script", "false")
	endif

	if GuiCtrlRead($Checkbox_disableautocomplete) = $GUI_CHECKED Then
		$disableautocomplete = "true"
		_Write_in_Config("disableautocomplete", "true")
	Else
		$disableautocomplete = "false"
		_Write_in_Config("disableautocomplete", "false")
	endif

	if GuiCtrlRead($checkbox_run_scripts_with_au3wrapper) = $GUI_CHECKED Then
		$starte_Skripts_mit_au3Wrapper = "true"
		_Write_in_Config("run_scripts_with_au3wrapper", "true")
	Else
		$starte_Skripts_mit_au3Wrapper = "false"
		_Write_in_Config("run_scripts_with_au3wrapper", "false")
	endif

	if GuiCtrlRead($Checkbox_disableintelisense) = $GUI_CHECKED Then
		$disableintelisense = "true"
		_Write_in_Config("disableintelisense", "true")
	Else
		$disableintelisense = "false"
		_Write_in_Config("disableintelisense", "false")
	endif

	if GuiCtrlRead($Checkbox_showlines) = $GUI_CHECKED Then
		$showlines = "true"
		_Write_in_Config("showlines", "true")
	Else
		$showlines = "false"
		_Write_in_Config("showlines", "false")
	endif

	if GuiCtrlRead($Checkbox_loadcontrols) = $GUI_CHECKED Then
		$loadcontrols = "true"
		_Write_in_Config("loadcontrols", "true")
	Else
		$loadcontrols = "false"
		_Write_in_Config("loadcontrols", "false")
	endif

	if GuiCtrlRead($Checkbox_allowcommentout) = $GUI_CHECKED Then
		$allowcommentout = "true"
		if _Config_Read("allowcommentout", "true") <> $allowcommentout then $Require_Restart = 1
		_Write_in_Config("allowcommentout", "true")
	Else
		$allowcommentout = "false"
		if _Config_Read("allowcommentout", "true") <> $allowcommentout then $Require_Restart = 1
		_Write_in_Config("allowcommentout", "false")
	endif

	if GuiCtrlRead($Checkbox_enablebackup) = $GUI_CHECKED Then
		$enablebackup = "true"
		_Write_in_Config("enablebackup", "true")
		AdlibUnRegister("_Backup_Files")
		AdlibRegister("_Backup_Files", $backuptime * 60000)
	Else
		$enablebackup = "false"
		_Write_in_Config("enablebackup", "false")
		AdlibUnRegister("_Backup_Files")
	endif

	if GuiCtrlRead($Checkbox_enabledeleteoldbackups) = $GUI_CHECKED Then
		$enabledeleteoldbackups = "true"
		_Write_in_Config("enabledeleteoldbackups", "true")
	Else
		$enabledeleteoldbackups = "false"
		_Write_in_Config("enabledeleteoldbackups", "false")
	endif

	if GuiCtrlRead($Checkbox_disabledebuggui) = $GUI_CHECKED Then
		$showdebuggui = "true"
		_Write_in_Config("showdebuggui", "true")
	Else
		$showdebuggui = "false"
		_Write_in_Config("showdebuggui", "false")
	endif

	if GuiCtrlRead($proxy_enable_checkbox) = $GUI_CHECKED Then
		$Use_Proxy = "true"
		_Write_in_Config("Use_Proxy", "true")
	Else
		$Use_Proxy = "false"
		_Write_in_Config("Use_Proxy", "false")
	endif

	if GuiCtrlRead($Checkbox_savefolding) = $GUI_CHECKED Then
		$savefolding = "true"
		_Write_in_Config("savefolding", "true")
	Else
		$savefolding = "false"
		_Write_in_Config("savefolding", "false")
	endif

	if GuiCtrlRead($setting_tools_bitoperation_enabled_checkbox) = $GUI_CHECKED Then
		$Tools_Bitrechner_aktiviert = "true"
		if _Config_Read("tools_Bitoperation_tester_enabled", "true") <> $Tools_Bitrechner_aktiviert then $Require_Restart = 1
		_Write_in_Config("tools_Bitoperation_tester_enabled", "true")
	Else
		$Tools_Bitrechner_aktiviert = "false"
		if _Config_Read("tools_Bitoperation_tester_enabled", "true") <> $Tools_Bitrechner_aktiviert then $Require_Restart = 1
		_Write_in_Config("tools_Bitoperation_tester_enabled", "false")
	 endif


	if GuiCtrlRead($setting_tools_parametereditor_enabled_checkbox) = $GUI_CHECKED Then
		$Tools_Parameter_Editor_aktiviert = "true"
		if _Config_Read("tools_parameter_editor_enabled", "true") <> $Tools_Parameter_Editor_aktiviert then $Require_Restart = 1
		_Write_in_Config("tools_parameter_editor_enabled", "true")
	Else
		$Tools_Parameter_Editor_aktiviert = "false"
		if _Config_Read("tools_parameter_editor_enabled", "true") <> $Tools_Parameter_Editor_aktiviert then $Require_Restart = 1
		_Write_in_Config("tools_parameter_editor_enabled", "false")
	 endif

	if GuiCtrlRead($setting_tools_obfuscator_enabled_checkbox) = $GUI_CHECKED Then
		$Tools_PELock_Obfuscator_aktiviert = "true"
		if _Config_Read("tools_pelock_obfuscator_enabled", "true") <> $Tools_PELock_Obfuscator_aktiviert then $Require_Restart = 1
		_Write_in_Config("tools_pelock_obfuscator_enabled", "true")
	Else
		$Tools_PELock_Obfuscator_aktiviert = "false"
		if _Config_Read("tools_pelock_obfuscator_enabled", "true") <> $Tools_PELock_Obfuscator_aktiviert then $Require_Restart = 1
		_Write_in_Config("tools_pelock_obfuscator_enabled", "false")
	 endif


	if GuiCtrlRead($Checkbox_use_new_colours) = $GUI_CHECKED Then
		$use_new_au3_colours = "true"
		if _Config_Read("use_new_au3_colours", "false") <> $use_new_au3_colours then $Require_Restart = 1
		_Write_in_Config("use_new_au3_colours", "true")
	Else
		$use_new_au3_colours = "false"
		if _Config_Read("use_new_au3_colours", "false") <> $use_new_au3_colours then $Require_Restart = 1
		_Write_in_Config("use_new_au3_colours", "false")
	endif

   ;DPI
   if _Config_Read("custom_dpi_value", number(_Config_Read("custom_dpi_value", 1))) <> guictrlread($programmeinstellungen_DPI_Slider)/100 then $Require_Restart = 1
   _Write_in_Config("custom_dpi_value", guictrlread($programmeinstellungen_DPI_Slider)/100)


if $registerinexplorer = "true" then
	RegDelete("HKEY_CLASSES_ROOT\AutoIt3Script\Shell\Edit_ISN")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell\Edit_ISN", "", "REG_SZ", _Get_langstr(674))
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell\Edit_ISN\Command", "", "REG_SZ", '"' & @scriptdir & "\Autoit_Studio.exe" & '" "%1"')
Else
	RegDelete("HKEY_CLASSES_ROOT\AutoIt3Script\Shell\Edit_ISN")
	RegDelete("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell\Edit_ISN")
EndIf


if $registerau3files = "true" then
	RegDelete("HKEY_CLASSES_ROOT\AutoIt3Script\Shell\Edit_ISN")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell\Edit_ISN", "", "REG_SZ", _Get_langstr(674))
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell\Edit_ISN\Command", "", "REG_SZ", '"' & @scriptdir & "\Autoit_Studio.exe" & '" "%1"')
	if RegRead ("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell", "") <> "Edit_ISN" then
	_Write_in_Config("SciTE4AutoIt_au3mode", RegRead ("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell", ""))
	EndIf
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell", "", "REG_SZ", "Edit_ISN")
Else
	if RegRead ("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell", "") <> "Edit_ISN" then
	_Write_in_Config("SciTE4AutoIt_au3mode", RegRead ("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell", ""))
	EndIf
	   $au3mode = _Config_Read("SciTE4AutoIt_au3mode", "Run")
   if $au3mode = "" then $au3mode = "Run" ;Falls kein vorheriger Wert gefunden werde..verwende RUN
	  RegWrite("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell", "", "REG_SZ", $au3mode) ;Setze auf default zurück (def Run)
	if $registerinexplorer = "false" then
	RegDelete("HKEY_CLASSES_ROOT\AutoIt3Script\Shell\Edit_ISN")
	RegDelete("HKEY_CURRENT_USER\SOFTWARE\Classes\AutoIt3Script\Shell\Edit_ISN")
	endif
endif

	GUICtrlSetfont($hTreeview, $treefont_size, 400, 0, $treefont_font)
	GUICtrlSetColor($hTreeview, $treefont_colour)
	GUICtrlSetfont($hTreeview2, $treefont_size, 400, 0, $treefont_font)
	GUICtrlSetColor($hTreeview2, $treefont_colour)

   AdlibUnRegister("_ISN_Automatische_Speicherung_starten")
   AdlibUnRegister("_ISN_Automatische_Speicherung_Sekundenevent")


   if $Automatische_Speicherung_Aktiv = "true" then
	  $Automatische_Speicherung_eingabecounter = 0
	 if $Automatische_Speicherung_Modus = "1" Then
		 AdlibRegister("_ISN_Automatische_Speicherung_starten",_TimeToTicks ($Automatische_Speicherung_Timer_Stunden, $Automatische_Speicherung_Timer_Minuten, $Automatische_Speicherung_Timer_Sekunden))
	 Else
		 AdlibRegister("_ISN_Automatische_Speicherung_Sekundenevent",1000)
	  EndIf
   endif


   switch guictrlread($programmeinstellungen_makrosicherheit_slider)

	  case 0
			$Makrosicherheitslevel = "4"
			_Write_in_Config("macro_security_level", "4")

	  case 1
			$Makrosicherheitslevel = "3"
			_Write_in_Config("macro_security_level", "3")

	  case 2
		 	$Makrosicherheitslevel = "2"
			_Write_in_Config("macro_security_level", "2")

	  case 3
		 	 $Makrosicherheitslevel = "1"
			_Write_in_Config("macro_security_level", "1")

	  case 4
		    $Makrosicherheitslevel = "0"
			_Write_in_Config("macro_security_level", "0")
   EndSwitch

	if $Require_Restart = 1 then msgbox(262144 + 64, _Get_langstr(178), _Get_langstr(204), 0, $Config_GUI)

;~ 	$Languagefile = $Combo_Sprachen[_GUICtrlComboBox_GetCurSel($Combo_Sprachen[0]) + 1]
	_Write_ISN_Debug_Console("done", 1, 1, 1, 1)
	if _GUICtrlTab_GetItemCount($htab) > 0 then
		if $Plugin_Handle[_GUICtrlTab_GetCurFocus($hTab)] = -1 then _HIDE_FENSTER_RECHTS($hidefunctionstree)
		endif
	_API_Pfade_abspeichern()
	_Speichere_Weitere_Includes_in_Config()
	_Pfade_fuer_Weitere_Includes_in_Registrierung_uebernehmen()
	_Einstellungen_Toolbar_Layoutstring_generieren_und_abspeichern()
	if $Offenes_Projekt <> "" then _Reload_Ruleslots()
	_Speichere_Farbeinstellungen()
	_Skripteditor_APIs_und_properties_neu_einlesen()
	_Neue_APIs_und_properties_an_Scintilla_controls_senden()
	_Set_Proxyserver()
	_Aktualisiere_Splittercontrols()
	_Aktualisiere_Texte_in_Contextmenues_wegen_Hotkeys()
	_Toggle_autocompletefields()
	_Toolbar_nach_layout_anordnen()
	ShowLineNumbers()
	_Tidy_Einstellungen_speichern()
	if $Offenes_Projekt <> "" then _Reload_Ruleslots()
	guisetstate(@SW_ENABLE, $Config_GUI)
	GUISetState(@sw_HIDE, $Einstellungen_werden_gespeichert_GUI)
	_HIDE_Configgui()
	_Load_Plugins()
	_ISN_aktualisiere_Hotkeys()
	_Write_log(_Get_langstr(214), "000000", "true")
EndFunc

func _set_runbevore_none()
	guictrlsetdata($config_inputstartbefore, "")
EndFunc

func _set_runafter_none()
	guictrlsetdata($config_inputstartafter, "")
EndFunc

func _select_runbefore()
	$var = FileOpenDialog(_Get_langstr(259), @ScriptDir, "All (*.exe)", 3, "", $Config_GUI)
	If @error Then return
	guictrlsetdata($config_inputstartbefore, $var)
EndFunc

func _select_runafter()
	$var = FileOpenDialog(_Get_langstr(259), @ScriptDir, "All (*.exe)", 3, "", $Config_GUI)
	If @error Then return
	guictrlsetdata($config_inputstartafter, $var)
EndFunc

func _select_releasemode()
	;release pfad
	if guictrlread($config_fertigeprojecte_dropdown) = _Get_langstr(413) then
		guictrlsetstate($Input_Release_points, $GUI_ENABLE)
		guictrlsetdata($config_fertigeprojectelabel, _Get_langstr(129))
		guictrlsetdata($Input_Release_Pfad, $Standardordner_Release)
	EndIf

	;release unterordner
	if guictrlread($config_fertigeprojecte_dropdown) = _Get_langstr(414) then
		guictrlsetdata($config_fertigeprojectelabel, _Get_langstr(415))
		guictrlsetdata($Input_Release_Pfad, "Release")
		guictrlsetstate($Input_Release_points, $GUI_DISABLE)
	endif
EndFunc

func _select_backupmode()
	;backup pfad
	if guictrlread($config_backupmode_combo) = _Get_langstr(425) then
		guictrlsetstate($config_baackupmodegivefolder, $GUI_ENABLE)
		guictrlsetdata($Input_Backup_Pfad, $Standardordner_Backups)
		guictrlsetdata($config_backupmode_label, _Get_langstr(128))
	EndIf

	;backup unterordner
	if guictrlread($config_backupmode_combo) = _Get_langstr(426) then
		guictrlsetdata($config_backupmode_label, _Get_langstr(415))
		guictrlsetdata($Input_Backup_Pfad, "Backup")
		guictrlsetstate($config_baackupmodegivefolder, $GUI_DISABLE)
	endif
EndFunc

func _restore_default_release()
	guictrlsetdata($Input_Release_Pfad, $Standardordner_Release)
	guictrlsetdata($config_fertigeprojecte_dropdown, "")
	guictrlsetdata($config_fertigeprojecte_dropdown, _Get_langstr(413) & "|" & _Get_langstr(414), _Get_langstr(413))
	_select_releasemode()
EndFunc

func _restore_default_backup()
	guictrlsetdata($Einstellungen_Backup_Ordnerstruktur_input, "%projectname%\%mday%.%mon%.%year%\%hour%h %min%m")
	guictrlsetdata($Input_deleteoldbackupsafter, "30")
	guictrlsetdata($Input_backuptime, "30")
	guictrlsetdata($Input_Backup_Pfad, $Standardordner_backups)
	guictrlsetdata($config_backupmode_combo, "")
	guictrlsetdata($config_backupmode_combo, _Get_langstr(425) & "|" & _Get_langstr(426), _Get_langstr(425))
	_select_backupmode()
EndFunc



func _Show_Studio_Debug()

   	if _Config_Read("showdebugconsole", "false") = "true" Then
		guictrlsetstate($ISNSTudio_debug_console_checkbox, $GUI_CHECKED)
	Else
		guictrlsetstate($ISNSTudio_debug_console_checkbox, $GUI_UNCHECKED)
	endif



	GUICtrlSetData($ISNSTudio_debug_edit, "")

	$Data = ""
	$Data = _Get_langstr(1) & " - " & _Get_langstr(306) & @crlf
	$Data = $Data & "----------------------------------" & @crlf


    $Data = $Data&@crlf&" - SYSTEM -"& @crlf
	$Data = $Data & "----------------" & @crlf
	$Data = $Data & "OS:" & @tab & @tab & @OSVersion & " " & @OSServicePack & " (" & @OSArch & ")" & @crlf
	$mem = MemGetStats()
	$Data = $Data & "RAM:" & @tab & @tab & round($mem[1] / 1024, 2) & " MB" & @crlf
	$Data = $Data & "WinAPI version:" & @tab & _WinAPI_GetVersion() & @crlf
	$Data = $Data & "Run on monitor:" & @tab & $Runonmonitor & " (Detected: " & $__MonitorList[0][0] & ")" & @crlf
	$Data = $Data & "Run from drive:" & @tab & StringTrimRight(@AutoItExe, stringlen(@AutoItExe) - StringInStr(@AutoItExe, "\")) & @crlf
	if StringInStr(FileGetAttrib(StringTrimRight(@AutoItExe, stringlen(@AutoItExe) - StringInStr(@AutoItExe, "\"))), "C") then
		$ex = "Yes -> ISN cannot be used on compressed drives!!!"
	Else
		$ex = "No"
	EndIf
	$Data = $Data & " |-> compressed:" & @tab & $ex & @crlf


   $Data = $Data&@crlf&" - ISN AUTOIT STUDIO GENERAL -"& @crlf
	$Data = $Data & "----------------" & @crlf
	$Data = $Data & "Studio version:" & @tab & "Version "&$Studioversion & " " & $ERSTELLUNGSTAG & @crlf
	$Data = $Data & "Executable path:" & @tab & @AutoItExe & " (PID " & @AutoItPID & ")" & @crlf
	$Data = $Data & "Startups:" & @tab & @tab & iniread($Configfile, "config", "startups", 0) & @crlf
	if FileExists(@scriptdir & "\portable.dat") then
		$Data = $Data & "Mode:" & @tab & @tab & "Portable" & @crlf
	Else
		$Data = $Data & "Mode:" & @tab & @tab & "Normal" & @crlf
	 endif
	$Data = $Data & "ISN AutoIt version:" & @tab & @AutoItVersion & @crlf
    $Data = $Data & "Current Skin:" & @tab & $skin & @crlf
    $Data = $Data & "ISN DPI scale:" & @tab &$DPI& @crlf
	$Data = $Data & "Languagefile:" & @tab & $Languagefile & @crlf
	if @Compiled then
		$Data = $Data & "Run mode:" & @tab & "Compiled version" & @crlf
	Else
		$Data = $Data & "Run mode:" & @tab & "Source version" & @crlf
	endif
	if IsAdmin() then
		$adm = "Yes"
	Else
		$adm = "No"
	EndIf
	$Data = $Data & "Run ISN as admin:" & @tab & $adm & @crlf






    $Data = $Data&@crlf&" - AUTOIT PATHS -"& @crlf
	$Data = $Data & "----------------" & @crlf
	if FileExists($autoitexe) then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
	$Data = $Data & "Autoit3.exe:" & @tab & $ex & " ("&$autoitexe&")"&@crlf

	if FileExists($autoit2exe) then
		$ex = "OK"
	Else
		$ex = "File not found!"
	 EndIf
	$Data = $Data & "Aut2exe.exe:" & @tab & $ex & " ("&$autoit2exe&")"&@crlf

	if FileExists($helpfile) then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
   $Data = $Data & "AutoIt3Help.exe:" & @tab & $ex & " ("&$helpfile&")"&@crlf

	if FileExists($Au3Checkexe) then
		$ex = "OK"
	Else
		$ex = "File not found!"
	EndIf
   $Data = $Data & "Au3Check.exe:" & @tab & $ex & " ("&$Au3Checkexe&")"&@crlf


	if FileExists($Au3Infoexe) then
		$ex = "OK"
	Else
		$ex = "File not found!"
   EndIf
	$Data = $Data & "Au3Info.exe:" & @tab & $ex & " ("&$Au3Infoexe&")"&@crlf

	if FileExists($Au3Stripperexe) then
		$ex = "OK"
	Else
		$ex = "File not found!"
   EndIf
	$Data = $Data & "AU3Stripper.exe:" & @tab & $ex & " ("&$Au3Stripperexe&")"&@crlf

	if FileExists($Tidyexe) then
		$ex = "OK"
	Else
		$ex = "File not found!"
   EndIf
	$Data = $Data & "Tidy.exe:" & @tab&@tab & $ex & " ("&$Tidyexe&")"&@crlf





    $Data = $Data&@crlf&" - ISN AUTOIT STUDIO PATHS -"& @crlf
	$Data = $Data & "----------------" & @crlf
	$Data = $Data & "%myisndatadir%:" & @tab & _ISN_Variablen_aufloesen($Arbeitsverzeichnis) & @crlf
	$Data = $Data & "Working dir:" & @tab & @WorkingDir & @crlf
	$Data = $Data & "Script dir:" & @tab & @ScriptDir & @crlf
	$Data = $Data & "Project dir:" & @tab & _ISN_Variablen_aufloesen($Projectfolder) & @crlf
	$Data = $Data & "Templates dir:" & @tab & _ISN_Variablen_aufloesen($templatefolder) & @crlf
	$Data = $Data & "Release dir:" & @tab & _ISN_Variablen_aufloesen($releasefolder) & @crlf
	$Data = $Data & "Backup dir:" & @tab & _ISN_Variablen_aufloesen($Backupfolder) & @crlf
	$Data = $Data & "Skins dir:" & @tab & @tab & @scriptdir & "\Data\Skins" & @crlf
	$Data = $Data & "Cache dir:" & @tab & _ISN_Variablen_aufloesen($Arbeitsverzeichnis & "\data\cache") & @crlf
	$Data = $Data & "Plugins dir:" & @tab & _ISN_Variablen_aufloesen($Pluginsdir) & @crlf
    $Data = $Data & "config.ini path:" & @tab & $Configfile & @crlf
    if StringInStr(FileGetAttrib($Configfile), "R") then
		$ex = "No"
	Else
		$ex = "Yes"
	EndIf
	$Data = $Data & "Config writable:" & @tab & $ex & @crlf

	$isn_dir_writable = "No"
	if _Directory_Is_Accessible(@ScriptDir&"\Data") then $isn_dir_writable = "Yes"
	$Data = $Data & "ISN dir writable:" & @tab & $isn_dir_writable & @crlf





    $Data = $Data&@crlf&" - ISN AUTOIT STUDIO PLUGINS -"& @crlf
	$Data = $Data & "----------------" & @crlf
	$Data = $Data & "Loaded Plugins:" & @tab & $Loaded_Plugins & @crlf
    $Data = $Data & "Loaded filetypes:" & @tab & $Loaded_Plugins_filetypes & @crlf









	GUICtrlSetData($ISNSTudio_debug_edit, $Data)
	GUISetState(@SW_SHOW, $ISNSTudio_debug)
	GUISetState(@SW_DISABLE, $Config_GUI)
EndFunc

func _HIDE_Studio_Debug()
   	if GuiCtrlRead($ISNSTudio_debug_console_checkbox) = $GUI_CHECKED Then
		_Write_in_Config("showdebugconsole", "true")
	Else
		_Write_in_Config("showdebugconsole", "false")
	 endif

	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_HIDE, $ISNSTudio_debug)
EndFunc

func _Choose_defaultfont()
	$result = _ChooseFont(guictrlread($darstellung_defaultfont_font), guictrlread($darstellung_defaultfont_size), 0, 0, False, False, False, $Config_GUI)
	if $result = -1 then Return
	guictrlsetdata($darstellung_defaultfont_font, $result[2])
	guictrlsetdata($darstellung_defaultfont_size, $result[3])
endfunc

func _restore_default_font()
	guictrlsetdata($darstellung_defaultfont_font, "Segoe UI")
	guictrlsetdata($darstellung_defaultfont_size, "8.5")
EndFunc

func _restore_treeview_font()
	guictrlsetdata($darstellung_treefont_font, "Segoe UI")
	guictrlsetdata($darstellung_treefont_size, "8.5")
	guictrlsetdata($darstellung_treefont_colour, "0x000000")
	GUICtrlSetBkColor($darstellung_treefont_colour, 0x000000)
	GUICtrlSetColor($darstellung_treefont_colour, _ColourInvert(Execute(0x000000)))
EndFunc

func _Choose_treeviewfont()
	$iColorRef = Hex(String(guictrlread($darstellung_treefont_colour)), 6)
	$iColorRef = '0x' & StringMid($iColorRef, 5, 2) & StringMid($iColorRef, 3, 2) & StringMid($iColorRef, 1, 2)
	$result = _ChooseFont(guictrlread($darstellung_treefont_font), guictrlread($darstellung_treefont_size), $iColorRef, 0, False, False, False, $Config_GUI)
	if $result = -1 then Return
	guictrlsetdata($darstellung_treefont_font, $result[2])
	guictrlsetdata($darstellung_treefont_size, $result[3])
	guictrlsetdata($darstellung_treefont_colour, $result[7])
	GUICtrlSetBkColor($darstellung_treefont_colour, $result[7])
	GUICtrlSetColor($darstellung_treefont_colour, _ColourInvert($result[7]))
endfunc

func _Choose_skripteditorfont()
	$result = _ChooseFont(guictrlread($darstellung_scripteditor_font), guictrlread($darstellung_scripteditor_size), 0, 0, False, False, False, $Config_GUI)
	if $result = -1 then Return
	guictrlsetdata($darstellung_scripteditor_font, $result[2])
	guictrlsetdata($darstellung_scripteditor_size, $result[3])
endfunc



func _Choose_Scripteditor_bg_colour()
	$res = _ChooseColor(2, guictrlread($darstellung_scripteditor_bgcolour), 2, $Config_GUI)
	if $res = -1 then return
	guictrlsetdata($darstellung_scripteditor_bgcolour, $res)
	GUICtrlSetColor($darstellung_scripteditor_bgcolour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_bgcolour, $res)
	if guictrlread($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED then _Farbeinstellungen_Hintergrundfarbe_fuer_alle_uebernehmen()
endfunc

func _Choose_Scripteditor_row_colour()
	$res = _ChooseColor(2, guictrlread($darstellung_scripteditor_rowcolour), 2, $programmeinstellungen_weiter_farbeinstellungen_GUI)
	if $res = -1 then return
	guictrlsetdata($darstellung_scripteditor_rowcolour, $res)
	GUICtrlSetColor($darstellung_scripteditor_rowcolour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_rowcolour, $res)
endfunc

func _Choose_Scripteditor_marc_colour()
	$res = _ChooseColor(2, guictrlread($darstellung_scripteditor_marccolour), 2, $programmeinstellungen_weiter_farbeinstellungen_GUI)
	if $res = -1 then return
	guictrlsetdata($darstellung_scripteditor_marccolour, $res)
	GUICtrlSetColor($darstellung_scripteditor_marccolour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_marccolour, $res)
endfunc

func _Choose_Scripteditor_highlightcolour()
	$res = _ChooseColor(2, guictrlread($darstellung_scripteditor_highlightcolour), 2, $programmeinstellungen_weiter_farbeinstellungen_GUI)
	if $res = -1 then return
	guictrlsetdata($darstellung_scripteditor_highlightcolour, $res)
	GUICtrlSetColor($darstellung_scripteditor_highlightcolour, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_highlightcolour, $res)
endfunc

func _Choose_Scripteditor_cursorcolor()
	$res = _ChooseColor(2, guictrlread($darstellung_scripteditor_cursorcolor), 2, $programmeinstellungen_weiter_farbeinstellungen_GUI)
	if $res = -1 then return
	guictrlsetdata($darstellung_scripteditor_cursorcolor, $res)
	GUICtrlSetColor($darstellung_scripteditor_cursorcolor, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_cursorcolor, $res)
 endfunc

 func _Choose_Scripteditor_errorcolor()
	$res = _ChooseColor(2, guictrlread($darstellung_scripteditor_errorcolor), 2, $programmeinstellungen_weiter_farbeinstellungen_GUI)
	if $res = -1 then return
	guictrlsetdata($darstellung_scripteditor_errorcolor, $res)
	GUICtrlSetColor($darstellung_scripteditor_errorcolor, _ColourInvert(Execute($res)))
	GUICtrlSetBkColor($darstellung_scripteditor_errorcolor, $res)
 endfunc

func _Toggle_Skin()
	if GuiCtrlRead($config_skin_radio2) = $GUI_CHECKED Then
		GUICtrlSetState($config_skin_name, $GUI_ENABLE)
		GUICtrlSetState($config_skin_author, $GUI_ENABLE)
		GUICtrlSetState($config_skin_url, $GUI_ENABLE)
		GUICtrlSetState($config_skin_version, $GUI_ENABLE)
		GUICtrlSetState($config_skin_list, $GUI_ENABLE)
		_load_skindetails()
	Else
		GUICtrlSetState($config_skin_name, $GUI_DISABLE)
		GUICtrlSetState($config_skin_author, $GUI_DISABLE)
		GUICtrlSetState($config_skin_url, $GUI_DISABLE)
		GUICtrlSetState($config_skin_version, $GUI_DISABLE)
		GUICtrlSetState($config_skin_list, $GUI_DISABLE)
		GUICtrlSetdata($config_skin_name, _Get_langstr(142))
		GUICtrlSetdata($config_skin_author, _Get_langstr(132))
		GUICtrlSetdata($config_skin_version, _Get_langstr(131))
		GUICtrlSetdata($config_skin_url, _Get_langstr(485))
		_SetImage($config_skin_pic, @scriptdir & "\data\isn_logo_l.png")
		GUICtrlSetOnEvent($config_skin_url, "")
	endif
endfunc

func _Load_Skins()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($config_skin_list))
	$search = FileFindFirstFile(@scriptdir & "\Data\Skins\*.*")
	If $search = -1 Then
		return
	EndIf
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib(@scriptdir & "\Data\Skins\" & $file),"D") Then
			if FileExists(@scriptdir & "\Data\Skins\" & $file & "\skin.msstyles") then
				_GUICtrlListView_AddItem($config_skin_list, iniread(@scriptdir & "\Data\Skins\" & $file & "\skin.ini", "skin", "name", ""))
				_GUICtrlListView_AddSubItem($config_skin_list, _GUICtrlListView_GetItemCount($config_skin_list) - 1, iniread(@scriptdir & "\Data\Skins\" & $file & "\skin.ini", "skin", "author", ""), 1)
				_GUICtrlListView_AddSubItem($config_skin_list, _GUICtrlListView_GetItemCount($config_skin_list) - 1, $file, 2)
				if $file = $skin then
					_GUICtrlListView_SetItemSelected($config_skin_list, _GUICtrlListView_GetItemCount($config_skin_list) - 1, true, true)
					_load_skindetails()
				endif
			endif
		endif
	WEnd
	FileClose($search)
EndFunc

func _load_skindetails()
	AdlibUnRegister("_load_skindetails")
	if _GUICtrlListView_GetSelectionMark($config_skin_list) = -1 then return
	if FileExists(@scriptdir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.jpg") then
		GUICtrlSetImage($config_skin_pic, @scriptdir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.jpg")
	else
		_SetImage($config_skin_pic, @scriptdir & "\data\isn_logo_l.png")
	EndIf
	GUICtrlSetdata($config_skin_name, _Get_langstr(142) & " " & iniread(@scriptdir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.ini", "skin", "name", ""))
	GUICtrlSetdata($config_skin_author, _Get_langstr(132) & " " & iniread(@scriptdir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.ini", "skin", "author", ""))
	GUICtrlSetdata($config_skin_version, _Get_langstr(131) & " " & iniread(@scriptdir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.ini", "skin", "version", ""))
	GUICtrlSetdata($config_skin_url, _Get_langstr(485) & " " & _Get_langstr(487))
	GUICtrlSetOnEvent($config_skin_url, "_openurl")
endfunc

func _openurl()
	if _GUICtrlListView_GetSelectionMark($config_skin_list) = -1 then return
	ShellExecute(iniread(@scriptdir & "\data\skins\" & _GUICtrlListView_GetItemText($config_skin_list, _GUICtrlListView_GetSelectionMark($config_skin_list), 2) & "\skin.ini", "skin", "url", ""))
endfunc


func _Toggle_Autosave_Modes()
if GuiCtrlRead($Programmeinstellungen_Automatische_Speicherung_Aktivieren_Checkbox) = $GUI_CHECKED Then

   if GuiCtrlRead($Programmeinstellungen_Automatische_Speicherung_Timer_Radio) = $GUI_CHECKED Then
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, $GUI_ENABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, $GUI_ENABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, $GUI_ENABLE)

	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, $GUI_DISABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, $GUI_DISABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, $GUI_DISABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_DISABLE)

   Else
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, $GUI_ENABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, $GUI_ENABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, $GUI_ENABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_ENABLE)

	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, $GUI_DISABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, $GUI_DISABLE)
	  GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, $GUI_DISABLE)
   EndIf


   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox, $GUI_ENABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_Radio, $GUI_ENABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_Radio, $GUI_ENABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox, $GUI_ENABLE)

Else
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_sekunden_input, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_stunden_input, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_sekunden_input, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_au3_Checkbox, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_stunden_input, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_minuten_input, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Timer_Radio, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_Radio, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_einmal_speichern_Checkbox, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_Input_minuten_input, $GUI_DISABLE)
   GUICtrlSetState($Programmeinstellungen_Automatische_Speicherung_nur_aktuellen_tab_Checkbox, $GUI_DISABLE)
endif

EndFunc

func _Toggle_Filetypes_Modes()
if GuiCtrlRead($Einstellungen_Skripteditor_Dateitypen_automatisch_radio) = $GUI_CHECKED Then

	  GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_default_Button, $GUI_DISABLE)
	  GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Remove_Button, $GUI_DISABLE)
	  GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Add_Button, $GUI_DISABLE)
	  GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Listview, $GUI_DISABLE)

   Else
	  GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_default_Button, $GUI_ENABLE)
	  GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Remove_Button, $GUI_ENABLE)
	  GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Add_Button, $GUI_ENABLE)
	  GUICtrlSetState($Einstellungen_Skripteditor_Dateitypen_Listview, $GUI_ENABLE)

   EndIf
EndFunc

func _Toggle_backupmode()

	if GuiCtrlRead($Checkbox_enablebackup) = $GUI_CHECKED Then
		GUICtrlSetState($Input_backuptime, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_enabledeleteoldbackups, $GUI_ENABLE)
		GUICtrlSetState($Input_deleteoldbackupsafter, $GUI_ENABLE)
		GUICtrlSetState($config_backupmode_combo, $GUI_ENABLE)
		GUICtrlSetState($Input_Backup_Pfad, $GUI_ENABLE)
		GUICtrlSetState($config_baackuprestorebutton, $GUI_ENABLE)
		GUICtrlSetState($Einstellungen_Backup_Ordnerstruktur_input, $GUI_ENABLE)
	if guictrlread($config_backupmode_combo) = _Get_langstr(425) then
		guictrlsetstate($config_baackupmodegivefolder, $GUI_ENABLE)
		guictrlsetdata($config_backupmode_label, _Get_langstr(128))
	 else
		guictrlsetdata($config_backupmode_label, _Get_langstr(415))
		guictrlsetstate($config_baackupmodegivefolder, $GUI_DISABLE)
	endif
	Else
		GUICtrlSetState($Input_backuptime, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_enabledeleteoldbackups, $GUI_DISABLE)
		GUICtrlSetState($Input_deleteoldbackupsafter, $GUI_DISABLE)
		GUICtrlSetState($config_backupmode_combo, $GUI_DISABLE)
		GUICtrlSetState($Input_Backup_Pfad, $GUI_DISABLE)
		GUICtrlSetState($config_baackuprestorebutton, $GUI_DISABLE)
		GUICtrlSetState($Einstellungen_Backup_Ordnerstruktur_input, $GUI_DISABLE)
		GUICtrlSetState($config_baackupmodegivefolder, $GUI_DISABLE)
	endif

	if GuiCtrlRead($Checkbox_enablebackup) = $GUI_CHECKED AND GuiCtrlRead($Checkbox_enabledeleteoldbackups) = $GUI_CHECKED Then
		GUICtrlSetState($Input_deleteoldbackupsafter, $GUI_ENABLE)
	Else
		GUICtrlSetState($Input_deleteoldbackupsafter, $GUI_DISABLE)
	endif

endfunc

func _Toggle_autoupdatefields()
	if GuiCtrlRead($Checkbox_enable_autoupdate) = $GUI_CHECKED Then
		GUICtrlSetState($config_autoupdate_time_in_days, $GUI_ENABLE)
	Else
		GUICtrlSetState($config_autoupdate_time_in_days, $GUI_DISABLE)
	endif
EndFunc

func _settings_toggle_tidywithISN()

		if GuiCtrlRead($einstellungen_tidy_ueberdasISNverwalten) = $GUI_CHECKED Then
		GUICtrlSetState($einstellungen_tidy_ini_pfad, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_ini_pfad_button, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_ini_pfad_label, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_input, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Proper, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_Constants, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_Update_variables_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_lowercase, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_uppercase, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_firstseen, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_add, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endfunc_statement_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_ignore, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_remove, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endregion_statement_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_add, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_ignore, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_remove, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_spaces, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_indent_region, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_create_docfile, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_create_docfile_show, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_keepversions_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_keepversions_input, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_backupdir_input, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_removeemptylines_label, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_backupdir_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaveall, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_removeall, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaves1, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_show_consoleinfo_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_inconsole, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_label, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_rundiff_label, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_debugoutput, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_rundiff_input, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_strip, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_always, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_backupdir_button, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_Tidy_rundiff_button, $GUI_ENABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_extrainfo_label, $GUI_ENABLE)
	Else
		GUICtrlSetState($einstellungen_tidy_ini_pfad_button, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_ini_pfad, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_ini_pfad_label, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_input, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Proper, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_Constants, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_Update_variables_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_lowercase, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_uppercase, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_variables_firstseen, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_add, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endfunc_statement_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_ignore, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endfunc_statement_remove, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endregion_statement_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_add, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_ignore, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_endregion_statement_remove, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_Update_spaces, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_indent_region, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_create_docfile, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_create_docfile_show, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_keepversions_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_keepversions_input, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_backupdir_input, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_removeemptylines_label, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_backupdir_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaveall, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_removeall, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_removeemptylines_leaves1, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_show_consoleinfo_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_inconsole, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_label, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_rundiff_label, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_show_consoleinfo_debugoutput, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_rundiff_input, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_strip, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_endwithnewline_always, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_backupdir_button, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_Tidy_rundiff_button, $GUI_DISABLE)
		GUICtrlSetState($einstellungen_tidy_einzug_extrainfo_label, $GUI_DISABLE)
	endif



EndFunc


func _Tidy_Einstellungen_speichern()
if $Verwalte_Tidyeinstellungen_mit_dem_ISN = "false" then return ;Nur speichern wenn Einstellungen vom ISN verwaltet werden!
if _ISN_Variablen_aufloesen($Pfad_zur_TidyINI) = "" then return
Local $Tidy_ini_Path = _ISN_Variablen_aufloesen($Pfad_zur_TidyINI)

if guictrlread($einstellungen_tidy_einzug_input) = "" Then
$res = IniDelete($Tidy_ini_Path,"ProgramSettings","tabchar")
else
$res = IniWrite($Tidy_ini_Path,"ProgramSettings","tabchar",guictrlread($einstellungen_tidy_einzug_input))
endif

if $res = 0 Then
msgbox(262144 + 16, _Get_langstr(984), StringReplace(_Get_langstr(1181),"%1",$Tidy_ini_Path), 0, $Einstellungen_werden_gespeichert_GUI)
Return
EndIf



if guictrlread($Checkbox_Tidy_keepversions_input) = "" Then
IniDelete($Tidy_ini_Path,"ProgramSettings","KeepNVersions")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","KeepNVersions",guictrlread($Checkbox_Tidy_keepversions_input))
endif


if guictrlread($Checkbox_Tidy_backupdir_input) = "" Then
IniDelete($Tidy_ini_Path,"ProgramSettings","backupDir")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","backupDir",guictrlread($Checkbox_Tidy_backupdir_input))
endif


if guictrlread($Checkbox_Tidy_rundiff_input) = "" Then
IniDelete($Tidy_ini_Path,"ProgramSettings","ShowDiffPgm")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","ShowDiffPgm",guictrlread($Checkbox_Tidy_rundiff_input))
endif

if guictrlread($Checkbox_Tidy_Proper) = $GUI_CHECKED Then
IniWrite($Tidy_ini_Path,"ProgramSettings","proper","1")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","proper","0")
endif

if guictrlread($Checkbox_Tidy_Update_Constants) = $GUI_CHECKED Then
IniWrite($Tidy_ini_Path,"ProgramSettings","properconstants","1")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","properconstants","0")
endif

if guictrlread($Checkbox_Tidy_Update_spaces) = $GUI_CHECKED Then
IniWrite($Tidy_ini_Path,"ProgramSettings","delim","1")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","delim","0")
endif

if guictrlread($Checkbox_Tidy_Update_variables_uppercase) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","vars","1")
if guictrlread($Checkbox_Tidy_Update_variables_lowercase) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","vars","2")
if guictrlread($Checkbox_Tidy_Update_variables_firstseen) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","vars","3")

if guictrlread($Checkbox_Tidy_endfunc_statement_add) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","endfunc_comment","1")
if guictrlread($Checkbox_Tidy_endfunc_statement_ignore) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","endfunc_comment","0")
if guictrlread($Checkbox_Tidy_endfunc_statement_remove) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","endfunc_comment","-1")

if guictrlread($Checkbox_Tidy_endregion_statement_add) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","endregion_comment","1")
if guictrlread($Checkbox_Tidy_endregion_statement_ignore) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","endregion_comment","0")
if guictrlread($Checkbox_Tidy_endregion_statement_remove) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","endregion_comment","-1")

if guictrlread($Checkbox_Tidy_indent_region) = $GUI_CHECKED Then
IniWrite($Tidy_ini_Path,"ProgramSettings","region_indent","1")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","region_indent","0")
endif

if guictrlread($Checkbox_Tidy_create_docfile) = $GUI_CHECKED Then
IniWrite($Tidy_ini_Path,"ProgramSettings","Gen_Doc","1")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","Gen_Doc","0")
endif

if guictrlread($Checkbox_Tidy_create_docfile_show) = $GUI_CHECKED Then
IniWrite($Tidy_ini_Path,"ProgramSettings","Gen_Doc_Show","1")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","Gen_Doc_Show","0")
endif

if guictrlread($Checkbox_Tidy_removeemptylines_leaveall) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","Remove_Empty_Lines","0")
if guictrlread($Checkbox_Tidy_removeemptylines_removeall) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","Remove_Empty_Lines","1")
if guictrlread($Checkbox_Tidy_removeemptylines_leaves1) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","Remove_Empty_Lines","2")


if guictrlread($einstellungen_tidy_endwithnewline_always) = $GUI_CHECKED Then
IniWrite($Tidy_ini_Path,"ProgramSettings","End_With_NewLin","1")
else
IniWrite($Tidy_ini_Path,"ProgramSettings","End_With_NewLin","0")
endif

if guictrlread($Checkbox_Tidy_show_consoleinfo_inconsole) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","ShowConsoleInfo","1")
if guictrlread($Checkbox_Tidy_show_consoleinfo_debugoutput) = $GUI_CHECKED Then IniWrite($Tidy_ini_Path,"ProgramSettings","ShowConsoleInfo","9")

endfunc

func _settings_tidy_choosebackupdir()
	$var = FileSelectFolder(_Get_langstr(298), "", 1, "", $Config_GUI)
	FileChangeDir(@scriptdir)
	if $var = "" then return
	GUICtrlSetData($Checkbox_Tidy_backupdir_input, $var)
EndFunc

func _settings_tidy_choosetidyinipath()
	$var = FileSaveDialog(_Get_langstr(187), "", "INI Files (*.ini)", 0, "tidy.ini", $Config_GUI)
	FileChangeDir(@scriptdir)
	if $var = "" then return
	GUICtrlSetData($einstellungen_tidy_ini_pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc

func _settings_tidy_choosediffprogramm()
	$var = FileOpenDialog(_Get_langstr(187), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "(*.exe)", 1 + 2 + 4, "", $Config_GUI)
	FileChangeDir(@scriptdir)
	if $var = "" then return
	If @error Then return
	GUICtrlSetData($Checkbox_Tidy_rundiff_input, $var)
EndFunc


func _Tidy_Einstellungen_einlesen()
	Local $Tidy_ini_Path = _ISN_Variablen_aufloesen($Pfad_zur_TidyINI)

	GUICtrlSetData($einstellungen_tidy_ini_pfad,$Pfad_zur_TidyINI)
	GUICtrlSetData($einstellungen_tidy_einzug_input,iniread($Tidy_ini_Path,"ProgramSettings","tabchar","0"))
	GUICtrlSetData($Checkbox_Tidy_keepversions_input,iniread($Tidy_ini_Path,"ProgramSettings","KeepNVersions","5"))
	GUICtrlSetData($Checkbox_Tidy_backupdir_input,iniread($Tidy_ini_Path,"ProgramSettings","backupDir",""))
	GUICtrlSetData($Checkbox_Tidy_rundiff_input,iniread($Tidy_ini_Path,"ProgramSettings","ShowDiffPgm",""))

	if iniread($Tidy_ini_Path,"ProgramSettings","proper","1") = "1" Then
		guictrlsetstate($Checkbox_Tidy_Proper, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Tidy_Proper, $GUI_UNCHECKED)
	endif

	if iniread($Tidy_ini_Path,"ProgramSettings","properconstants","0") = "1" Then
		guictrlsetstate($Checkbox_Tidy_Update_Constants, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Tidy_Update_Constants, $GUI_UNCHECKED)
	endif

	switch iniread($Tidy_ini_Path,"ProgramSettings","vars","3")
	case "1"
		guictrlsetstate($Checkbox_Tidy_Update_variables_uppercase, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_Update_variables_lowercase, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_Update_variables_firstseen, $GUI_UNCHECKED)

	case "2"
		guictrlsetstate($Checkbox_Tidy_Update_variables_uppercase, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_Update_variables_lowercase, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_Update_variables_firstseen, $GUI_UNCHECKED)

	case "3"
		guictrlsetstate($Checkbox_Tidy_Update_variables_uppercase, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_Update_variables_lowercase, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_Update_variables_firstseen, $GUI_CHECKED)
	endswitch

	if iniread($Tidy_ini_Path,"ProgramSettings","delim","1") = "1" Then
		guictrlsetstate($Checkbox_Tidy_Update_spaces, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Tidy_Update_spaces, $GUI_UNCHECKED)
	endif

	switch iniread($Tidy_ini_Path,"ProgramSettings","endfunc_comment","1")
	case "1"
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_add, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_ignore, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_remove, $GUI_UNCHECKED)

	case "0"
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_add, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_ignore, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_remove, $GUI_UNCHECKED)

	case "-1"
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_add, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_ignore, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_endfunc_statement_remove, $GUI_CHECKED)

	endswitch

	switch iniread($Tidy_ini_Path,"ProgramSettings","endregion_comment","1")
	case "1"
		guictrlsetstate($Checkbox_Tidy_endregion_statement_add, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_endregion_statement_ignore, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_endregion_statement_remove, $GUI_UNCHECKED)

	case "0"
		guictrlsetstate($Checkbox_Tidy_endregion_statement_add, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_endregion_statement_ignore, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_endregion_statement_remove, $GUI_UNCHECKED)

	case "-1"
		guictrlsetstate($Checkbox_Tidy_endregion_statement_add, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_endregion_statement_ignore, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_endregion_statement_remove, $GUI_CHECKED)

	endswitch

	if iniread($Tidy_ini_Path,"ProgramSettings","region_indent","1") = "1" Then
		guictrlsetstate($Checkbox_Tidy_indent_region, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Tidy_indent_region, $GUI_UNCHECKED)
	endif

	if iniread($Tidy_ini_Path,"ProgramSettings","Gen_Doc","0") = "1" Then
		guictrlsetstate($Checkbox_Tidy_create_docfile, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Tidy_create_docfile, $GUI_UNCHECKED)
	endif

	if iniread($Tidy_ini_Path,"ProgramSettings","Gen_Doc_Show","0") = "1" Then
		guictrlsetstate($Checkbox_Tidy_create_docfile_show, $GUI_CHECKED)
	Else
		guictrlsetstate($Checkbox_Tidy_create_docfile_show, $GUI_UNCHECKED)
	endif

	switch iniread($Tidy_ini_Path,"ProgramSettings","Remove_Empty_Lines","0")
	case "0"
		guictrlsetstate($Checkbox_Tidy_removeemptylines_leaveall, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_removeemptylines_removeall, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_removeemptylines_leaves1, $GUI_UNCHECKED)

	case "1"
		guictrlsetstate($Checkbox_Tidy_removeemptylines_leaveall, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_removeemptylines_removeall, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_removeemptylines_leaves1, $GUI_UNCHECKED)

	case "2"
		guictrlsetstate($Checkbox_Tidy_removeemptylines_leaveall, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_removeemptylines_removeall, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_removeemptylines_leaves1, $GUI_CHECKED)

	endswitch

	switch iniread($Tidy_ini_Path,"ProgramSettings","ShowConsoleInfo","1")
	case "1"
		guictrlsetstate($Checkbox_Tidy_show_consoleinfo_inconsole, $GUI_CHECKED)
		guictrlsetstate($Checkbox_Tidy_show_consoleinfo_debugoutput, $GUI_UNCHECKED)

	case "9"
		guictrlsetstate($Checkbox_Tidy_show_consoleinfo_inconsole, $GUI_UNCHECKED)
		guictrlsetstate($Checkbox_Tidy_show_consoleinfo_debugoutput, $GUI_CHECKED)

	endswitch

	if iniread($Tidy_ini_Path,"ProgramSettings","End_With_NewLin","1") = "1" Then
		guictrlsetstate($einstellungen_tidy_endwithnewline_strip, $GUI_UNCHECKED)
		guictrlsetstate($einstellungen_tidy_endwithnewline_always, $GUI_CHECKED)
	Else
		guictrlsetstate($einstellungen_tidy_endwithnewline_strip, $GUI_CHECKED)
		guictrlsetstate($einstellungen_tidy_endwithnewline_always, $GUI_UNCHECKED)
	endif

endfunc


func _Toggle_proxyfields()
	if GuiCtrlRead($proxy_enable_checkbox) = $GUI_CHECKED Then
		GUICtrlSetState($proxy_server_input, $GUI_ENABLE)
		GUICtrlSetState($proxy_port_input, $GUI_ENABLE)
		GUICtrlSetState($proxy_username_input, $GUI_ENABLE)
		GUICtrlSetState($proxy_password_input, $GUI_ENABLE)
	Else
		GUICtrlSetState($proxy_server_input, $GUI_DISABLE)
		GUICtrlSetState($proxy_port_input, $GUI_DISABLE)
		GUICtrlSetState($proxy_username_input, $GUI_DISABLE)
		GUICtrlSetState($proxy_password_input, $GUI_DISABLE)
	endif
EndFunc

func _Set_Proxyserver()
	if $Use_Proxy = "true" Then
		if $proxy_PW = "" then
			$pw = ""
		else
			$pw = BinaryToString(_Crypt_DecryptData ($proxy_PW, "Isn_pRoxy_PW", $CALG_RC4))
;~ 			$pw = _StringEncrypt(0, $proxy_PW, "Isn_pRoxy_PW", 2)
		EndIf
		FtpSetProxy(2, $proxy_server & ":" & $proxy_port, $proxy_username, $pw)
		HttpSetProxy(2, $proxy_server & ":" & $proxy_port, $proxy_username, $pw)
	Else
		FtpSetProxy(0)
		HttpSetProxy(0)
	EndIf
endfunc

func _Reset_Warnmeldungen()
	IniDelete($Configfile, "warnings")
	msgbox(64 + 262144, _Get_langstr(61), _Get_langstr(496), 0, $Config_GUI)
endfunc

func _Reset_letzte_elemente()
	IniDelete($Configfile, "history")
	msgbox(64 + 262144, _Get_langstr(61), _Get_langstr(672), 0, $Config_GUI)
endfunc

func _Aktualisiere_Hotkeyliste()
	_Lade_Tastenkombinationen()
	$Letzte_Makierung = _GUICtrlListView_GetSelectionMark($settings_hotkeylistview)
	if $Letzte_Makierung = -1 then $Letzte_Makierung = 0

	_GUICtrlListView_DeleteAllItems(guictrlgethandle($settings_hotkeylistview))
	_GUICtrlListView_BeginUpdate($settings_hotkeylistview)
	;Öffnen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(508),62)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Oeffnen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Oeffnen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_open", 3)

	;Speichern
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(9), 63)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Speichern), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Speichern, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_save", 3)

	;Speichern unter...
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(725), 63)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Speichern_unter), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Speichern_unter, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_save_as", 3)

	;Speichern (alle Tabs)
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(650),64)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Speichern_Alle_Tabs), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Speichern_Alle_Tabs, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_save_all_tabs", 3)

	;Tab schließen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(80),65)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_tab_schliessen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_tab_schliessen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_closetab", 3)

	;Vorheriger Tab
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(677),66)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_vorheriger_tab), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_vorheriger_tab, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_previoustab", 3)

	;Nächster Tab
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(678),67)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_naechster_tab), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_naechster_tab, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_nexttab", 3)

	;Vollbild
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(457),68)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_vollbild), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_vollbild, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_fullscreen", 3)

	;Auskommentieren
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(328),69)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_auskommentieren), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_auskommentieren, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_commentout", 3)

	;Befehlhilfe
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(679),70)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_befehlhilfe), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_befehlhilfe, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_commandhelp", 3)

	;Springe zu Zeile
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(116),71)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_springezuzeile), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_springezuzeile, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_gotoline", 3)

	;Tidy
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(327),61)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Tidy), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Tidy, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_tidy", 3)

	;Syntaxcheck
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(108),72)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_syntaxcheck), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_syntaxcheck, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_syntaxcheck", 3)

	;compile
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(235),73)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_compile), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_compile, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_compile", 3)

	;compile settings
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(563),74)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_compile_Settings), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_compile_Settings, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_compile_Settings", 3)

	;Skript testen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(82),75)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_testeskript), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_testeskript, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_testscript", 3)

	;Teste Projekt
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(489),76)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Testprojekt), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Testprojekt, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_testproject", 3)

	;Teste Projekt (ohne parameter)
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(488),76)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Testprojekt_ohne_Parameter, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_testprojectwithoutparam", 3)

	;Neue Datei erstellen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(70),77)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Neue_Datei), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Neue_Datei, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_newfile", 3)

	;Suche
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(87),78)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Suche), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Suche, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_search", 3)

	;Makroslot1
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(611),79)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot1), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot1, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot1", 3)

	;Makroslot2
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(612),80)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot2), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot2, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot2", 3)

	;Makroslot3
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(613),81)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot3), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot3, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot3", 3)

	;Makroslot4
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(614),82)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot4), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot4, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot4", 3)

	;Makroslot5
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(615),83)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot5), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot5, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot5", 3)

	;Makroslot6
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(906),84)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot6), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot6, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot6", 3)

	;Makroslot7
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(907),85)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Makroslot7), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Makroslot7, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_macroslot7", 3)

	;Debug zu msgbox
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(727),86)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_debugtomsgbox), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_debugtomsgbox, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_debugtomsgbox", 3)

	;Debug zu console
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(729),86)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_debugtoconsole), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_debugtoconsole, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_debugtoconsole", 3)

	;Erstelle UDF Header
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(730),87)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_erstelleUDFheader), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_erstelleUDFheader, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_createudfheader", 3)

	;AutoItWrapper GUI
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(751),88)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_AutoIt3WrapperGUI), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_AutoIt3WrapperGUI, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_autoit3wrappergui", 3)

	;MsgBoxGenerator
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(608),89)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_msgBoxGenerator), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_msgBoxGenerator, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_msgboxgenerator", 3)

	;Zeile Duplizieren
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(739),90)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_zeile_duplizieren), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_zeile_duplizieren, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_dublicate", 3)

	;Farbtoolbox
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(651),57)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Farbtoolbox), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Farbtoolbox, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_colourtoolbox", 3)

	;Fenster Info Tool
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(609),91)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Fensterinfotool), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Fensterinfotool, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_windowinfotool", 3)

	;Organize Includes
;~ 	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(796))
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_organizeincludes), 1)
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_organizeincludes, 2)
;~ 	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_organizeincludes", 3)

	;Open Include
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(808),38)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Oeffne_Include), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Oeffne_Include, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_openinclude", 3)

	;Bitrechner
	if $Tools_Bitrechner_aktiviert = "true" then
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(813),92)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Bitrechner), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Bitrechner, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bitwise", 3)
	endif

	;Auto Backup
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(893),41)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Automatisches_Backup), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Automatisches_Backup, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_backup", 3)

	;Datei/Ordner umbenennen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(75),93)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Datei_umbenennen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Datei_umbenennen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_renamefile", 3)

	;Weitersuchen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(93),78)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Weitersuchen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Weitersuchen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_nextsearch", 3)

	;Rückwärts Weitersuchen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(903),78)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Rueckwaerts_Weitersuchen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Rueckwaerts_Weitersuchen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_prevsearch", 3)

	;Änderungsprotokolle
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(911),94)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Aenderungsprotokolle), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Aenderungsprotokolle, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_changelogmanager", 3)

	;Fenster unten umschalten
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1011),95)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_unteres_fenster_umschalten), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_unteres_fenster_umschalten, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_togglehideoutputconsole", 3)

	;Fenster links umschalten
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1015),96)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_linkes_fenster_umschalten), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_linkes_fenster_umschalten, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_toggleprojecttree", 3)

	;Fenster rechts umschalten
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1016),97)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_rechtes_fenster_umschalten), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_rechtes_fenster_umschalten, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_togglescripttree", 3)


	;Springe zur Funktion
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1106),100)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Springe_zu_Func), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Springe_zu_Func, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_jumptofunc", 3)

	;Kommentare ausblenden
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1172),103)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_toggle_comments", 3)

	;Zeile nach oben verschieben
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1170),104)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_oben_verschieben), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Zeile_nach_oben_verschieben, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_movelineup", 3)

	;Zeile nach unten verschieben
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1171),105)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_unten_verschieben), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Zeile_nach_unten_verschieben, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_movelinedown", 3)

	;In Dateien Suchen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1189),78)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_In_Dateien_Suchen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_In_Dateien_Suchen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_search_in_files", 3)

	;Parameter Editor
	if $Tools_PELock_Obfuscator_aktiviert = "true" then
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1206),114)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_PElock_Obfuscator), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_PElock_Obfuscator, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_pelock_obfuscator", 3)
	Endif

	;Zeile(n) markieren
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1203),115)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Zeile_Bookmarken), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Zeile_Bookmarken, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bookmark_line", 3)

	;Zeilen markierung löschen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1310),115)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_alle_loeschen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Zeile_Bookmarken_alle_loeschen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bookmark_line_remove_all_bookmarks", 3)

	;Zeilen markierung zum nächsten springen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1308),115)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Naechstes_Bookmark), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Zeile_Bookmarken_Naechstes_Bookmark, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bookmark_jump_next", 3)

	;Zeilen markierung zum vorherigen springen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1309),115)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_bookmark_jump_previous", 3)

	if $Tools_Parameter_Editor_aktiviert = "true" then
    ;Parameter Editor Hotkeys
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037),98)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor", 3)

	;Parameter Editor - Alle Parameter leeren
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037)&" - "&_Get_langstr(1046),98)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_alle_Parameter_leeren), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_alle_Parameter_leeren, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_clear_all_parameters", 3)

	;Parameter Editor - Markierten Parameter leeren
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037)&" - "&_Get_langstr(1044),98)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_leeren), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_markierten_Parameter_leeren, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_clear_selected_parameter", 3)

	;Parameter Editor - Markierten Parameter löschen
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037)&" - "&_Get_langstr(1045),98)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_loeschen), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_markierten_Parameter_loeschen, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_remove_selected_parameter", 3)

	;Parameter Editor - Neuer Parameter
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037)&" - "&_Get_langstr(1043),98)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_neuer_Parameter), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_neuer_Parameter, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_add_new_parameter", 3)

   ;Parameter Editor - Nächsten Parameter
	_GUICtrlListView_AddItem($settings_hotkeylistview, _Get_langstr(1037)&" - "&_Get_langstr(1301),98)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, _Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_naechster_Parameter), 1)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, $Hotkey_Keycode_Parameter_Editor_naechster_Parameter, 2)
	_GUICtrlListView_AddSubItem($settings_hotkeylistview, _GUICtrlListView_GetItemCount($settings_hotkeylistview) - 1, "key_parameter_editor_select_next_parameter", 3)
	Endif


	_GUICtrlListView_RegisterSortCallBack($settings_hotkeylistview)
	_GUICtrlListView_SortItems($settings_hotkeylistview, 0)

	_GUICtrlListView_SetItemSelected($settings_hotkeylistview, $Letzte_Makierung, true, true)
	_GUICtrlListView_EnsureVisible($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview))
	_GUICtrlListView_EndUpdate($settings_hotkeylistview)
   _GUICtrlListView_UnRegisterSortCallBack($settings_hotkeylistview)
EndFunc

func _show_Edit_Hotkey()
	if _GUICtrlListView_GetSelectionMark($settings_hotkeylistview) = -1 then return
	guictrlsetdata($edit_hotkey_funktion_label, _GUICtrlListView_GetItemText($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview), 0))
	guictrlsetdata($edit_hotkey_hotkey, _GUICtrlListView_GetItemText($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview), 1))
	guictrlsetdata($edit_hotkey_keycode, _GUICtrlListView_GetItemText($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview), 2))
	guictrlsetdata($edit_hotkey_section, _GUICtrlListView_GetItemText($settings_hotkeylistview, _GUICtrlListView_GetSelectionMark($settings_hotkeylistview), 3))
	GUISetState(@SW_SHOW, $edit_hotkey_GUI)
	GUISetState(@SW_DISABLE, $Config_GUI)
endfunc

func _save_Edit_Hotkey()
	IniWrite($Configfile, "hotkeys", guictrlread($edit_hotkey_section), guictrlread($edit_hotkey_keycode))
	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_hide, $edit_hotkey_GUI)
	_Aktualisiere_Hotkeyliste()
endfunc

func _hide_Edit_Hotkey()
	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_hide, $edit_hotkey_GUI)
endfunc

func _Set_no_Hotkey()
	guictrlsetdata($edit_hotkey_keycode, "")
	guictrlsetdata($edit_hotkey_hotkey, "")
	_save_Edit_Hotkey()
endfunc

func _Set_Hotkey_to_default()
	IniDelete($Configfile, "hotkeys", guictrlread($edit_hotkey_section))
	_Aktualisiere_Hotkeyliste()
	GUISetState(@SW_ENABLE, $Config_GUI)
	GUISetState(@SW_hide, $edit_hotkey_GUI)
endfunc

func _aendere_Hotkey()
	GUISetState(@SW_SHOW, $warte_auf_tastendruck_GUI)
	GUISetState(@SW_DISABLE, $edit_hotkey_GUI)
	$Plus_zeichen = "+"
	$Kombi_Array = _getKeyKombi()
	if IsArray($Kombi_Array) then
	$Keycode = _ArrayToString($Kombi_Array, $Plus_zeichen)
	$text = _Keycode_zu_Text($Keycode)
	guictrlsetdata($edit_hotkey_keycode, $Keycode)
	guictrlsetdata($edit_hotkey_hotkey, $text)
	endif
	GUISetState(@SW_ENABLE, $edit_hotkey_GUI)
	GUISetState(@SW_HIDE, $warte_auf_tastendruck_GUI)
EndFunc

func _Export_hotkeys()
	$line = FileSaveDialog(_Get_langstr(684), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Hotkeys (*.ini)", 18, "hotkeys.ini", $Config_GUI)
	if $line = "" then Return
	if @Error > 0 then return
	$section = IniReadSection($Configfile, "hotkeys")
	IniWriteSection($line, "hotkeys", $section)
	FileChangeDir(@scriptdir)
	msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $Config_GUI)
EndFunc

func _Import_hotkeys()
	$var = FileOpenDialog(_Get_langstr(683), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Hotkeys (*.ini)", 1 + 2 + 4, "", $Config_GUI)
	FileChangeDir(@scriptdir)
	if $var = "" then return
	If @error Then return
	$section = IniReadSection($var, "hotkeys")
	IniWriteSection($Configfile, "hotkeys", $section)
	FileChangeDir(@scriptdir)
	_Aktualisiere_Hotkeyliste()
	msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(591), 0, $Config_GUI)
EndFunc

func _toggle_Willkommen_Autoload()
	if GuiCtrlRead($Willkommen_autoloadcheckbox) = $GUI_CHECKED Then
		$Autoload = "true"
		_Write_in_Config("autoload", "true")
	Else
		$Autoload = "false"
		_Write_in_Config("autoload", "false")
	endif
endfunc

func _Aktualisiere_Texte_in_Contextmenues_wegen_Hotkeys()
	;Aktualisiere Texte wegen Hotkeys
	;Datei Menü
	_GUICtrlODMenuItemSetText($FileMenu_item1, _Get_langstr(9) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Speichern))
	_GUICtrlODMenuItemSetText($Dateimenue_Oeffnen, _Get_langstr(509) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Oeffnen))
	_GUICtrlODMenuItemSetText($FileMenu_item1c, _Get_langstr(725) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Speichern_unter))
	_GUICtrlODMenuItemSetText($FileMenu_item1b, _Get_langstr(650) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Speichern_Alle_Tabs))
	_GUICtrlODMenuItemSetText($FileMenu_item11, _Get_langstr(457) & @tab & _Keycode_zu_Text($Hotkey_Keycode_vollbild))

	;Menü Projekt
	_GUICtrlODMenuItemSetText($ProjectMenu_item8a, _Get_langstr(50) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt))
	_GUICtrlODMenuItemSetText($ProjectMenu_item8b, _Get_langstr(488) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Testprojekt_ohne_Parameter))
	_GUICtrlODMenuItemSetText($ProjectMenu_item9, _Get_langstr(82) & @tab & _Keycode_zu_Text($Hotkey_Keycode_testeskript))
	_GUICtrlODMenuItemSetText($ProjectMenu_item11a, _Get_langstr(52) & @tab & _Keycode_zu_Text($Hotkey_Keycode_compile))
	_GUICtrlODMenuItemSetText($ProjectMenu_backup_durchfuehren, _Get_langstr(893)&@tab & _Keycode_zu_Text($Hotkey_Keycode_Automatisches_Backup))
	_GUICtrlODMenuItemSetText($ProjectMenu_aenderungsprotokolle, _Get_langstr(911)&@tab & _Keycode_zu_Text($Hotkey_Keycode_Aenderungsprotokolle))

	;Menü Bearbeiten
	_GUICtrlODMenuItemSetText($EditMenu_item7, _Get_langstr(115) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Suche))
	_GUICtrlODMenuItemSetText($EditMenu_item9, _Get_langstr(116) & @tab & _Keycode_zu_Text($Hotkey_Keycode_springezuzeile))
	_GUICtrlODMenuItemSetText($EditMenu_item11, _Get_langstr(328) & @tab & _Keycode_zu_Text($Hotkey_Keycode_auskommentieren))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_duplizieren, _Get_langstr(739) & @tab & _Keycode_zu_Text($Hotkey_Keycode_zeile_duplizieren))
	_GUICtrlODMenuItemSetText($EditMenu_Kommentare_ausblenden,_Get_langstr(1172) & @TAB & _Keycode_zu_Text($Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden))
	_GUICtrlODMenuItemSetText($EditMenu_Zeilen_nach_oben_verschieben,_Get_langstr(1170) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_oben_verschieben))
	_GUICtrlODMenuItemSetText($EditMenu_Zeilen_nach_unten_verschieben,_Get_langstr(1171) & @TAB & _Keycode_zu_Text($Hotkey_Keycode_Zeile_nach_unten_verschieben))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_bookmarken,_Get_langstr(1203) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_bookmarken_naechste_Zeile,_Get_langstr(1308) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Naechstes_Bookmark))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_bookmarken_vorherige_Zeile,_Get_langstr(1309) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark))
	_GUICtrlODMenuItemSetText($EditMenu_zeile_bookmarken_Alle_Entfernen,_Get_langstr(1310) & @TAB & _Keycode_zu_Text($Hotkey_Zeile_Bookmarken_alle_loeschen))


	;Menü Tools
	_GUICtrlODMenuItemSetText($EditMenu_item8, _Get_langstr(108) & @tab & _Keycode_zu_Text($Hotkey_Keycode_syntaxcheck))
	_GUICtrlODMenuItemSetText($EditMenu_item10, _Get_langstr(327) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Tidy))
	_GUICtrlODMenuItemSetText($Tools_menu_debugging_debugtoMsgBox, _Get_langstr(727) & @tab & _Keycode_zu_Text($Hotkey_Keycode_debugtomsgbox))
	_GUICtrlODMenuItemSetText($Tools_menu_debugging_debugtoConsole, _Get_langstr(729) & @tab & _Keycode_zu_Text($Hotkey_Keycode_debugtoconsole))
	_GUICtrlODMenuItemSetText($Tools_menu_createUDFheader, _Get_langstr(730) & @tab & _Keycode_zu_Text($Hotkey_Keycode_erstelleUDFheader))
	_GUICtrlODMenuItemSetText($Tools_menu_item1, _Get_langstr(608) & @tab & _Keycode_zu_Text($Hotkey_Keycode_msgBoxGenerator))
	_GUICtrlODMenuItemSetText($Tools_menu_AutoIt3Wrapper_GUI, _Get_langstr(751) & @tab & _Keycode_zu_Text($Hotkey_Keycode_AutoIt3WrapperGUI))
	_GUICtrlODMenuItemSetText($Tools_menu_item8, _Get_langstr(651) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Farbtoolbox))
	_GUICtrlODMenuItemSetText($Tools_menu_item2, _Get_langstr(609) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Fensterinfotool))
;~ 	_GUICtrlODMenuItemSetText($Tools_menu_organizeincludes, _Get_langstr(796) & @tab & _Keycode_zu_Text($Hotkey_Keycode_organizeincludes))
	_GUICtrlODMenuItemSetText($Tools_menu_bitrechner, _Get_langstr(813) & @tab & _Keycode_zu_Text($Hotkey_Keycode_bitrechner))
	_GUICtrlODMenuItemSetText($Tools_menu_PELock_Obfuscator, _Get_langstr(1206) & @TAB & _Keycode_zu_Text($Hotkey_PElock_Obfuscator))

	;Menü Hilfe
	_GUICtrlODMenuItemSetText($HelpMenu_item1, _Get_langstr(174) & @tab & _Keycode_zu_Text($Hotkey_Keycode_befehlhilfe))

	;Tabmenu
	_GUICtrlODMenuItemSetText($TabContextMenu_Item1, _Get_langstr(9) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Speichern))
	_GUICtrlODMenuItemSetText($TabContextMenu_Item2, _Get_langstr(80) & @tab & _Keycode_zu_Text($Hotkey_Keycode_tab_schliessen))

	;Contextmenü Skripteditor
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_speichern, _Get_langstr(9) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Speichern))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_oeffneHilfe, _Get_langstr(648) & @tab & _Keycode_zu_Text($Hotkey_Keycode_befehlhilfe))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_suche, _Get_langstr(115) & @tab & _Keycode_zu_Text($Hotkey_Keycode_Suche))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_Auskommentieren, _Get_langstr(328) & @tab & _Keycode_zu_Text($Hotkey_Keycode_auskommentieren))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_debugtoMsgBox, _Get_langstr(727) & @tab & _Keycode_zu_Text($Hotkey_Keycode_debugtomsgbox))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_debugtoConsole, _Get_langstr(729) & @tab & _Keycode_zu_Text($Hotkey_Keycode_debugtoconsole))
	_GUICtrlODMenuItemSetText($SCI_EDITOR_CONTEXT_oeffneInclude, _Get_langstr(508)& @tab & _Keycode_zu_Text($Hotkey_Keycode_Oeffne_Include))

	;Menü Ansicht
	_GUICtrlODMenuItemSetText($AnsichtMenu_fenster_unten_umschalten, _Get_langstr(1011) & @tab & _Keycode_zu_Text($Hotkey_Keycode_unteres_fenster_umschalten))
	_GUICtrlODMenuItemSetText($AnsichtMenu_fenster_links_umschalten, _Get_langstr(1015) & @tab & _Keycode_zu_Text($Hotkey_Keycode_linkes_fenster_umschalten))
	_GUICtrlODMenuItemSetText($AnsichtMenu_fenster_rechts_umschalten, _Get_langstr(1016) & @tab & _Keycode_zu_Text($Hotkey_Keycode_rechtes_fenster_umschalten))

	;Parameter Editor
	GUICtrlSetTip ($ParameterEditor_Plus_Button,_Get_langstr(1043)&" ("&_Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_neuer_Parameter)&")")
	GUICtrlSetTip ($ParameterEditor_remove_Button,_Get_langstr(1045)&" ("&_Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_loeschen)&")")
    GUICtrlSetTip ($ParameterEditor_Minus_Button,_Get_langstr(1044)&" ("&_Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_markierten_Parameter_leeren)&")")
    GUICtrlSetTip ($ParameterEditor_ClearAll_Button,_Get_langstr(1046)&" ("&_Keycode_zu_Text($Hotkey_Keycode_Parameter_Editor_alle_Parameter_leeren)&")")
endfunc

func _Toggle_autocompletefields()
	if GuiCtrlRead($Checkbox_disableautocomplete) = $GUI_CHECKED Then
		GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_globalautocomplete, $GUI_UNCHECKED)
		GUICtrlSetState($Checkbox_globalautocomplete, $GUI_DISABLE)
	Else
		GUICtrlSetState($Checkbox_globalautocomplete, $GUI_ENABLE)

		if GuiCtrlRead($Checkbox_globalautocomplete) = $GUI_CHECKED Then
			GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_ENABLE)
		Else
			GUICtrlSetState($Checkbox_globalautocomplete_current_script, $GUI_DISABLE)
		endif
	 endif

   if GuiCtrlRead($Checkbox_hidedebug) = $GUI_UNCHECKED Then
	  GUICtrlSetState($Checkbox_scripteditor_debug_show_buttons_checkbox, $GUI_ENABLE)
	  else
	  GUICtrlSetState($Checkbox_scripteditor_debug_show_buttons_checkbox, $GUI_DISABLE)
   endif

   if GuiCtrlRead($Einstellungen_AutoItIncludes_Verwalten_Checkbox) = $GUI_CHECKED Then
	  GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Listview, $GUI_ENABLE)
	  GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Add_Button, $GUI_ENABLE)
	  GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Remove_Button, $GUI_ENABLE)
	  else
	  GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Listview,  $GUI_DISABLE)
	  GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Add_Button, $GUI_DISABLE)
	  GUICtrlSetState($Einstellungen_AutoItIncludes_Verwalten_Remove_Button,  $GUI_DISABLE)
   endif



EndFunc

func _Pfade_fuer_Weitere_Includes_in_Registrierung_uebernehmen()
if $Zusaetzliche_Include_Pfade_ueber_ISN_verwalten <> "true" then return

local $Fertiger_String_fuer_Reg = ""
$Pfade = _Config_Read("additional_includes_paths", "")
$Pfade_Array = StringSplit($Pfade,"|",2)
if IsArray($Pfade_Array) Then
for $x = 0 to ubound($Pfade_Array)-1
   if $Pfade_Array[$x] = "" then ContinueLoop
   if $Pfade_Array[$x] = "|" then ContinueLoop
   $Fertiger_String_fuer_Reg = $Fertiger_String_fuer_Reg&_ISN_Variablen_aufloesen($Pfade_Array[$x])&";"
next
EndIf
RegWrite ( "HKEY_CURRENT_USER\Software\AutoIt v3\AutoIt", "Include", "REG_SZ", $Fertiger_String_fuer_Reg)
EndFunc

func _Lade_Weitere_Includes_in_Listview()
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Einstellungen_AutoItIncludes_Verwalten_Listview))
$Pfade = _Config_Read("additional_includes_paths", "")
$Pfade_Array = StringSplit($Pfade,"|",2)
_GUICtrlListView_BeginUpdate($Einstellungen_AutoItIncludes_Verwalten_Listview)
if IsArray($Pfade_Array) Then
for $x = 0 to ubound($Pfade_Array)-1
   if $Pfade_Array[$x] = "" then ContinueLoop
   if $Pfade_Array[$x] = "|" then ContinueLoop
 _GUICtrlListView_AddItem($Einstellungen_AutoItIncludes_Verwalten_Listview, $Pfade_Array[$x], 1)
next
EndIf
_GUICtrlListView_EndUpdate($Einstellungen_AutoItIncludes_Verwalten_Listview)
EndFunc

func _Speichere_Weitere_Includes_in_Config()
local $Fertiger_String = ""
for $x = 0 To _GUICtrlListView_GetItemCount($Einstellungen_AutoItIncludes_Verwalten_Listview)
   if _GUICtrlListView_GetItemText ($Einstellungen_AutoItIncludes_Verwalten_Listview,$x) = "" then ContinueLoop
   $Fertiger_String = $Fertiger_String&_GUICtrlListView_GetItemText ($Einstellungen_AutoItIncludes_Verwalten_Listview,$x)&"|"
Next
if StringRight($Fertiger_String,1) = "|" then $Fertiger_String = StringTrimRight($Fertiger_String,1)
_Write_in_Config("additional_includes_paths", $Fertiger_String)
endfunc

func _Einstellungen_Skript_Editor_Dateitypen_in_Listview_Laden()
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Einstellungen_Skripteditor_Dateitypen_Listview))
$Dateityp_Array = StringSplit($Skript_Editor_Dateitypen_Liste,"|",2)
_GUICtrlListView_BeginUpdate($Einstellungen_Skripteditor_Dateitypen_Listview)
if IsArray($Dateityp_Array) Then
for $x = 0 to ubound($Dateityp_Array)-1
   if $Dateityp_Array[$x] = "" then ContinueLoop
   if $Dateityp_Array[$x] = "|" then ContinueLoop
 _GUICtrlListView_AddItem($Einstellungen_Skripteditor_Dateitypen_Listview, $Dateityp_Array[$x], 101)
next
EndIf

_GUICtrlListView_RegisterSortCallBack($Einstellungen_Skripteditor_Dateitypen_Listview)
_GUICtrlListView_SortItems($Einstellungen_Skripteditor_Dateitypen_Listview, 0)
_GUICtrlListView_EndUpdate($Einstellungen_Skripteditor_Dateitypen_Listview)
_GUICtrlListView_UnRegisterSortCallBack($Einstellungen_Skripteditor_Dateitypen_Listview)
endfunc

func _Einstellungen_Skript_Editor_Dateitypen_String_aus_Listview_Laden()
local $Fertiger_String = ""
for $x = 0 To _GUICtrlListView_GetItemCount($Einstellungen_Skripteditor_Dateitypen_Listview)
   if _GUICtrlListView_GetItemText ($Einstellungen_Skripteditor_Dateitypen_Listview,$x) = "" then ContinueLoop
   $Fertiger_String = $Fertiger_String&_GUICtrlListView_GetItemText ($Einstellungen_Skripteditor_Dateitypen_Listview,$x)&"|"
Next
if StringRight($Fertiger_String,1) = "|" then $Fertiger_String = StringTrimRight($Fertiger_String,1)
return $Fertiger_String
endfunc

func _Weitere_Includes_Pfad_hinzufuegen()
$Ordnerpfad = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
if $Ordnerpfad = "" OR @error then Return
FileChangeDir(@ScriptDir)
if not _IsDir($Ordnerpfad) then return
if _WinAPI_PathIsRoot($Ordnerpfad) then return
if _GUICtrlListView_FindText ($Einstellungen_AutoItIncludes_Verwalten_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad),-1) = -1 then _GUICtrlListView_AddItem($Einstellungen_AutoItIncludes_Verwalten_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad), 1)
EndFunc

func _Weitere_Includes_Pfad_entfernen()
if _GUICtrlListView_GetSelectionMark($Einstellungen_AutoItIncludes_Verwalten_Listview) = -1 then return
_GUICtrlListView_DeleteItem($Einstellungen_AutoItIncludes_Verwalten_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_AutoItIncludes_Verwalten_Listview))
_GUICtrlListView_SetItemSelected ($Einstellungen_AutoItIncludes_Verwalten_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_AutoItIncludes_Verwalten_Listview),True ,True)
EndFunc


func _Einstellungen_Skripteditor_Dateityp_entfernen()
if _GUICtrlListView_GetSelectionMark($Einstellungen_Skripteditor_Dateitypen_Listview) = -1 then return
_GUICtrlListView_DeleteItem($Einstellungen_Skripteditor_Dateitypen_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_Skripteditor_Dateitypen_Listview))
_GUICtrlListView_SetItemSelected ($Einstellungen_Skripteditor_Dateitypen_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_Skripteditor_Dateitypen_Listview),True ,True)
EndFunc

func _Einstellungen_Skripteditor_Dateitypen_default()
$Skript_Editor_Dateitypen_Liste = $Skript_Editor_Dateitypen_Standard
_Einstellungen_Skript_Editor_Dateitypen_in_Listview_Laden()
EndFunc

func _Einstellungen_Skripteditor_Dateitypen_hinzufuegen()
$Erweiterung = InputBox ( _Get_langstr(1112), _Get_langstr(1113) , "" , "" ,-1 , -1 , Default ,  Default, 0 , $Config_GUI)
if $Erweiterung = "" OR @error then Return
if $Erweiterung = "exe" then return
$Erweiterung =  StringStripWS ($Erweiterung,3)
$Erweiterung =  StringReplace($Erweiterung,"*.","")
$Erweiterung =  StringReplace($Erweiterung,".","")
if _GUICtrlListView_FindInText ( $Einstellungen_Skripteditor_Dateitypen_Listview, $Erweiterung , -1 , false) <> -1 then return
_GUICtrlListView_AddItem($Einstellungen_Skripteditor_Dateitypen_Listview, $Erweiterung, 101)
EndFunc

func _Farben_Checkboxevent()
for $y = 1 to 16
if (@GUI_CtrlId = Execute("$farben_bold_sh1_"&$y)) OR (@GUI_CtrlId = Execute("$farben_italic_sh1_"&$y)) OR (@GUI_CtrlId = Execute("$farben_underline_sh1_"&$y)) OR (@GUI_CtrlId = Execute("$farben_bold_sh2_"&$y)) OR (@GUI_CtrlId = Execute("$farben_italic_sh2_"&$y)) OR (@GUI_CtrlId = Execute("$farben_underline_sh2_"&$y)) then _Farben_Aktualisiere_Reihe($y)
next
endfunc

func _Farben_event_waehle_vordergrund()
for $y = 1 to 16
if (@GUI_CtrlId = Execute("$farben_vordergrundbt_sh1_"&$y))	then _Einstellungen_waehle_Vordergrundfarbe($y,1)
if (@GUI_CtrlId = Execute("$farben_vordergrundbt_sh2_"&$y))	then _Einstellungen_waehle_Vordergrundfarbe($y,2)
next
endfunc

func _Farben_event_waehle_hintergrund()
for $y = 1 to 16
if (@GUI_CtrlId = Execute("$farben_hintergrundbt_sh1_"&$y))	then _Einstellungen_waehle_Hintergrundfarbe($y,1)
if (@GUI_CtrlId = Execute("$farben_hintergrundbt_sh2_"&$y))	then _Einstellungen_waehle_Hintergrundfarbe($y,2)
next
endfunc



func _Einstellungen_waehle_Vordergrundfarbe($Reihe=0,$Sh=0)
if $Reihe = 0 then Return
if $Sh = 0 then Return
$res = _ChooseColor(2, guictrlread(Execute("$farben_vordergrund_sh"&$Sh&"_"&$Reihe)), 2, $Config_GUI)
if $res = -1 then return
GUICtrlSetBkColor(Execute("$farben_vordergrund_sh"&$Sh&"_"&$Reihe), $res)
GUICtrlSetColor(Execute("$farben_vordergrund_sh"&$Sh&"_"&$Reihe), $res)
GUICtrlSetData(Execute("$farben_vordergrund_sh"&$Sh&"_"&$Reihe), $res)
_Farben_Aktualisiere_Reihe($Reihe)
endfunc

func _Einstellungen_waehle_Hintergrundfarbe($Reihe=0,$Sh=0)
if $Reihe = 0 then Return
if $Sh = 0 then Return
if guictrlread($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED then
_Input_Error_FX($einstellungen_farben_hintergrund_fuer_alle_checkbox)
return
EndIf
$res = _ChooseColor(2, guictrlread(Execute("$farben_hintergrund_sh"&$Sh&"_"&$Reihe)), 2, $Config_GUI)
if $res = -1 then return
GUICtrlSetBkColor(Execute("$farben_hintergrund_sh"&$Sh&"_"&$Reihe), $res)
GUICtrlSetColor(Execute("$farben_hintergrund_sh"&$Sh&"_"&$Reihe), $res)
GUICtrlSetData(Execute("$farben_hintergrund_sh"&$Sh&"_"&$Reihe), $res)
_Farben_Aktualisiere_Reihe($Reihe)
endfunc

func _farbeinstellungen_toggle_hintergrund_fuer_alle()
if guictrlread($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED then
_Farbeinstellungen_Hintergrundfarbe_fuer_alle_uebernehmen()
endif
EndFunc

func _Farbeinstellungen_Hintergrundfarbe_fuer_alle_uebernehmen()
$Farbe = guictrlread($darstellung_scripteditor_bgcolour)
for $y = 1 to 16
GUICtrlSetBkColor(Execute("$farben_hintergrund_sh1_"&$y),$Farbe)
GUICtrlSetColor(Execute("$farben_hintergrund_sh1_"&$y),$Farbe)
GUICtrlSetdata(Execute("$farben_hintergrund_sh1_"&$y),$Farbe)
GUICtrlSetBkColor(Execute("$farben_hintergrund_sh2_"&$y),$Farbe)
GUICtrlSetColor(Execute("$farben_hintergrund_sh2_"&$y),$Farbe)
GUICtrlSetdata(Execute("$farben_hintergrund_sh2_"&$y),$Farbe)
GUICtrlSetColor(Execute("$farben_label_sh1_"&$y),guictrlread(Execute("$farben_vordergrund_sh1_"&$y)))
GUICtrlSetBkColor(Execute("$farben_label_sh1_"&$y),guictrlread(Execute("$farben_hintergrund_sh1_"&$y)))
GUICtrlSetColor(Execute("$farben_label_sh2_"&$y),guictrlread(Execute("$farben_vordergrund_sh2_"&$y)))
GUICtrlSetBkColor(Execute("$farben_label_sh2_"&$y),guictrlread(Execute("$farben_hintergrund_sh2_"&$y)))
next
endfunc


func _Farben_Aktualisiere_Reihe($Reihe=0)
if $Reihe = 0 then return
GUICtrlSetColor(Execute("$farben_label_sh1_"&$Reihe),guictrlread(Execute("$farben_vordergrund_sh1_"&$Reihe)))
GUICtrlSetBkColor(Execute("$farben_label_sh1_"&$Reihe),guictrlread(Execute("$farben_hintergrund_sh1_"&$Reihe)))
GUICtrlSetColor(Execute("$farben_label_sh2_"&$Reihe),guictrlread(Execute("$farben_vordergrund_sh2_"&$Reihe)))
GUICtrlSetBkColor(Execute("$farben_label_sh2_"&$Reihe),guictrlread(Execute("$farben_hintergrund_sh2_"&$Reihe)))


	if guictrlread(Execute("$farben_bold_sh1_"&$Reihe)) = $GUI_CHECKED then
	$Bold1 = 800
	else
	$Bold1 = 400
	endif

	if guictrlread(Execute("$farben_bold_sh2_"&$Reihe)) = $GUI_CHECKED then
	$Bold2 = 800
	else
	$Bold2 = 400
	endif

	$attribute1 = 0
	if guictrlread(Execute("$farben_italic_sh1_"&$Reihe)) = $GUI_CHECKED then $attribute1 = $attribute1+2
	if guictrlread(Execute("$farben_underline_sh1_"&$Reihe)) = $GUI_CHECKED then $attribute1 = $attribute1+4


	$attribute2 = 0
	if guictrlread(Execute("$farben_italic_sh2_"&$Reihe)) = $GUI_CHECKED then $attribute2 = $attribute2+2
	if guictrlread(Execute("$farben_underline_sh2_"&$Reihe)) = $GUI_CHECKED then $attribute2 = $attribute2+4


	GUICtrlSetFont (Execute("$farben_label_sh1_"&$Reihe), 11, $Bold1, $attribute1 , guictrlread($darstellung_scripteditor_font))
	GUICtrlSetFont (Execute("$farben_label_sh2_"&$Reihe), 11, $Bold2, $attribute2 , guictrlread($darstellung_scripteditor_font))
endfunc


func _Einstellungen_Lade_Farben()
for $x = 1 to 16
	$Zulesender_String1 = Execute("$SCE_AU3_STYLE"&$x&"a")
	$Zulesender_String2 = Execute("$SCE_AU3_STYLE"&$x&"b")
	if $Zulesender_String1 <> "" AND $Zulesender_String2 <> "" then
	$Split1 = StringSplit($Zulesender_String1,"|",2)
	$Split2 = StringSplit($Zulesender_String2,"|",2)
	if ubound($Split1)-1 = 4 AND ubound($Split2)-1 = 4 Then ;Nur bei korrekter Anzahl an Splits

	;Label
	GUICtrlSetColor(Execute("$farben_label_sh1_"&$x),_BGR_to_RGB($Split1[0]))
	if guictrlread($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED then
	GUICtrlSetBkColor(Execute("$farben_label_sh1_"&$x),guictrlread($darstellung_scripteditor_bgcolour))
	else
	GUICtrlSetBkColor(Execute("$farben_label_sh1_"&$x),_BGR_to_RGB($Split1[1]))
	endif

	GUICtrlSetColor(Execute("$farben_label_sh2_"&$x),_BGR_to_RGB($Split2[0]))
	if guictrlread($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED then
	GUICtrlSetBkColor(Execute("$farben_label_sh2_"&$x),guictrlread($darstellung_scripteditor_bgcolour))
	else
	GUICtrlSetBkColor(Execute("$farben_label_sh2_"&$x),_BGR_to_RGB($Split2[1]))
	endif

	if $Split1[2] = 1 then
	$Bold1 = 800
	else
	$Bold1 = 400
	endif

	if $Split2[2] = 1 then
	$Bold2 = 800
	else
	$Bold2 = 400
	endif

	$attribute1 = 0
	if $Split1[3] = 1 then $attribute1 = $attribute1+2
	if $Split1[4] = 1 then $attribute1 = $attribute1+4

	$attribute2 = 0
	if $Split2[3] = 1 then $attribute2 = $attribute2+2
	if $Split2[4] = 1 then $attribute2 = $attribute2+4

	GUICtrlSetFont (Execute("$farben_label_sh1_"&$x), 11, $Bold1, $attribute1 , guictrlread($darstellung_scripteditor_font))
	GUICtrlSetFont (Execute("$farben_label_sh2_"&$x), 11, $Bold2, $attribute2 , guictrlread($darstellung_scripteditor_font))

	;Checkboxen
	if $Split1[2] = 1 Then
		guictrlsetstate(Execute("$farben_bold_sh1_"&$x), $GUI_CHECKED)
	Else
		guictrlsetstate(Execute("$farben_bold_sh1_"&$x), $GUI_UNCHECKED)
	endif

	if $Split1[3] = 1 Then
		guictrlsetstate(Execute("$farben_italic_sh1_"&$x), $GUI_CHECKED)
	Else
		guictrlsetstate(Execute("$farben_italic_sh1_"&$x), $GUI_UNCHECKED)
	endif

	if $Split1[4] = 1 Then
		guictrlsetstate(Execute("$farben_underline_sh1_"&$x), $GUI_CHECKED)
	Else
		guictrlsetstate(Execute("$farben_underline_sh1_"&$x), $GUI_UNCHECKED)
	endif

	if $Split2[2] = 1 Then
		guictrlsetstate(Execute("$farben_bold_sh2_"&$x), $GUI_CHECKED)
	Else
		guictrlsetstate(Execute("$farben_bold_sh2_"&$x), $GUI_UNCHECKED)
	endif

	if $Split2[3] = 1 Then
		guictrlsetstate(Execute("$farben_italic_sh2_"&$x), $GUI_CHECKED)
	Else
		guictrlsetstate(Execute("$farben_italic_sh2_"&$x), $GUI_UNCHECKED)
	endif

	if $Split2[4] = 1 Then
		guictrlsetstate(Execute("$farben_underline_sh2_"&$x), $GUI_CHECKED)
	Else
		guictrlsetstate(Execute("$farben_underline_sh2_"&$x), $GUI_UNCHECKED)
	endif

	;Vordergrundfarbe
	GUICtrlSetBkColor(Execute("$farben_vordergrund_sh1_"&$x),_BGR_to_RGB($Split1[0]))
	GUICtrlSetColor(Execute("$farben_vordergrund_sh1_"&$x),_BGR_to_RGB($Split1[0]))
	GUICtrlSetdata(Execute("$farben_vordergrund_sh1_"&$x),_BGR_to_RGB($Split1[0]))
	GUICtrlSetBkColor(Execute("$farben_vordergrund_sh2_"&$x),_BGR_to_RGB($Split2[0]))
	GUICtrlSetColor(Execute("$farben_vordergrund_sh2_"&$x),_BGR_to_RGB($Split2[0]))
	GUICtrlSetdata(Execute("$farben_vordergrund_sh2_"&$x),_BGR_to_RGB($Split2[0]))

	;Hintergrundgrundfarbe
	if guictrlread($einstellungen_farben_hintergrund_fuer_alle_checkbox) = $GUI_CHECKED then
	GUICtrlSetBkColor(Execute("$farben_hintergrund_sh1_"&$x),guictrlread($darstellung_scripteditor_bgcolour))
	GUICtrlSetColor(Execute("$farben_hintergrund_sh1_"&$x),guictrlread($darstellung_scripteditor_bgcolour))
	GUICtrlSetdata(Execute("$farben_hintergrund_sh1_"&$x),guictrlread($darstellung_scripteditor_bgcolour))
	GUICtrlSetBkColor(Execute("$farben_hintergrund_sh2_"&$x),guictrlread($darstellung_scripteditor_bgcolour))
	GUICtrlSetColor(Execute("$farben_hintergrund_sh2_"&$x),guictrlread($darstellung_scripteditor_bgcolour))
	GUICtrlSetdata(Execute("$farben_hintergrund_sh2_"&$x),guictrlread($darstellung_scripteditor_bgcolour))
	else
	GUICtrlSetBkColor(Execute("$farben_hintergrund_sh1_"&$x),_BGR_to_RGB($Split1[1]))
	GUICtrlSetColor(Execute("$farben_hintergrund_sh1_"&$x),_BGR_to_RGB($Split1[1]))
	GUICtrlSetdata(Execute("$farben_hintergrund_sh1_"&$x),_BGR_to_RGB($Split1[1]))
	GUICtrlSetBkColor(Execute("$farben_hintergrund_sh2_"&$x),_BGR_to_RGB($Split2[1]))
	GUICtrlSetColor(Execute("$farben_hintergrund_sh2_"&$x),_BGR_to_RGB($Split2[1]))
	GUICtrlSetdata(Execute("$farben_hintergrund_sh2_"&$x),_BGR_to_RGB($Split2[1]))
	endif

	endif
	endif
Next
endfunc

func _Speichere_Farbeinstellungen()
for $x = 1 to 16
;Reset
$Farbstring_sh1 = ""
$Farbstring_sh2 = ""

;Farben
$Farbstring_sh1 = $Farbstring_sh1&_RGB_to_BGR("0x"&hex(guictrlread(Execute("$farben_vordergrund_sh1_"&$x)),6))&"|"
$Farbstring_sh1 = $Farbstring_sh1&_RGB_to_BGR("0x"&hex(guictrlread(Execute("$farben_hintergrund_sh1_"&$x)),6))&"|"

$Farbstring_sh2 = $Farbstring_sh2&_RGB_to_BGR("0x"&hex(guictrlread(Execute("$farben_vordergrund_sh2_"&$x)),6))&"|"
$Farbstring_sh2 = $Farbstring_sh2&_RGB_to_BGR("0x"&hex(guictrlread(Execute("$farben_hintergrund_sh2_"&$x)),6))&"|"


;Bold
if guictrlread(Execute("$farben_bold_sh1_"&$x)) = $GUI_CHECKED then
$Farbstring_sh1 = $Farbstring_sh1&"1|"
Else
$Farbstring_sh1 = $Farbstring_sh1&"0|"
endif

if guictrlread(Execute("$farben_bold_sh2_"&$x)) = $GUI_CHECKED then
$Farbstring_sh2 = $Farbstring_sh2&"1|"
Else
$Farbstring_sh2 = $Farbstring_sh2&"0|"
endif


;Italic
if guictrlread(Execute("$farben_italic_sh1_"&$x)) = $GUI_CHECKED then
$Farbstring_sh1 = $Farbstring_sh1&"1|"
Else
$Farbstring_sh1 = $Farbstring_sh1&"0|"
endif

if guictrlread(Execute("$farben_italic_sh2_"&$x)) = $GUI_CHECKED then
$Farbstring_sh2 = $Farbstring_sh2&"1|"
Else
$Farbstring_sh2 = $Farbstring_sh2&"0|"
endif

;underline
if guictrlread(Execute("$farben_underline_sh1_"&$x)) = $GUI_CHECKED then
$Farbstring_sh1 = $Farbstring_sh1&"1"
Else
$Farbstring_sh1 = $Farbstring_sh1&"0"
endif

if guictrlread(Execute("$farben_underline_sh2_"&$x)) = $GUI_CHECKED then
$Farbstring_sh2 = $Farbstring_sh2&"1"
Else
$Farbstring_sh2 = $Farbstring_sh2&"0"
endif

;Hole config section
$section_sh1 = ""
$section_sh2 = ""

switch $x
	case 1
		$section_sh1 = "AU3_DEFAULT_STYLE1"
		$section_sh2 = "AU3_DEFAULT_STYLE2"
		$SCE_AU3_STYLE1a = $Farbstring_sh1
		$SCE_AU3_STYLE1b = $Farbstring_sh2
	case 2
		$section_sh1 = "AU3_COMMENT_STYLE1"
		$section_sh2 = "AU3_COMMENT_STYLE2"
		$SCE_AU3_STYLE2a = $Farbstring_sh1
		$SCE_AU3_STYLE2b = $Farbstring_sh2
	case 3
		$section_sh1 = "AU3_COMMENTBLOCK_STYLE1"
		$section_sh2 = "AU3_COMMENTBLOCK_STYLE2"
		$SCE_AU3_STYLE3a = $Farbstring_sh1
		$SCE_AU3_STYLE3b = $Farbstring_sh2
	case 4
		$section_sh1 = "AU3_NUMBER_STYLE1"
		$section_sh2 = "AU3_NUMBER_STYLE2"
		$SCE_AU3_STYLE4a = $Farbstring_sh1
		$SCE_AU3_STYLE4b = $Farbstring_sh2
	case 5
		$section_sh1 = "AU3_FUNCTION_STYLE1"
		$section_sh2 = "AU3_FUNCTION_STYLE2"
		$SCE_AU3_STYLE5a = $Farbstring_sh1
		$SCE_AU3_STYLE5b = $Farbstring_sh2
	case 6
		$section_sh1 = "AU3_KEYWORD_STYLE1"
		$section_sh2 = "AU3_KEYWORD_STYLE2"
		$SCE_AU3_STYLE6a = $Farbstring_sh1
		$SCE_AU3_STYLE6b = $Farbstring_sh2
	case 7
		$section_sh1 = "AU3_MACRO_STYLE1"
		$section_sh2 = "AU3_MACRO_STYLE2"
		$SCE_AU3_STYLE7a = $Farbstring_sh1
		$SCE_AU3_STYLE7b = $Farbstring_sh2
	case 8
		$section_sh1 = "AU3_STRING_STYLE1"
		$section_sh2 = "AU3_STRING_STYLE2"
		$SCE_AU3_STYLE8a = $Farbstring_sh1
		$SCE_AU3_STYLE8b = $Farbstring_sh2
	case 9
		$section_sh1 = "AU3_OPERATOR_STYLE1"
		$section_sh2 = "AU3_OPERATOR_STYLE2"
		$SCE_AU3_STYLE9a = $Farbstring_sh1
		$SCE_AU3_STYLE9b = $Farbstring_sh2
	case 10
		$section_sh1 = "AU3_VARIABLE_STYLE1"
		$section_sh2 = "AU3_VARIABLE_STYLE2"
		$SCE_AU3_STYLE10a = $Farbstring_sh1
		$SCE_AU3_STYLE10b = $Farbstring_sh2
	case 11
		$section_sh1 = "AU3_SENT_STYLE1"
		$section_sh2 = "AU3_SENT_STYLE2"
		$SCE_AU3_STYLE11a = $Farbstring_sh1
		$SCE_AU3_STYLE11b = $Farbstring_sh2
	case 12
		$section_sh1 = "AU3_PREPROCESSOR_STYLE1"
		$section_sh2 = "AU3_PREPROCESSOR_STYLE2"
		$SCE_AU3_STYLE12a = $Farbstring_sh1
		$SCE_AU3_STYLE12b = $Farbstring_sh2
	case 13
		$section_sh1 = "AU3_SPECIAL_STYLE1"
		$section_sh2 = "AU3_SPECIAL_STYLE2"
		$SCE_AU3_STYLE13a = $Farbstring_sh1
		$SCE_AU3_STYLE13b = $Farbstring_sh2
	case 14
		$section_sh1 = "AU3_EXPAND_STYLE1"
		$section_sh2 = "AU3_EXPAND_STYLE2"
		$SCE_AU3_STYLE14a = $Farbstring_sh1
		$SCE_AU3_STYLE14b = $Farbstring_sh2
	case 15
		$section_sh1 = "AU3_COMOBJ_STYLE1"
		$section_sh2 = "AU3_COMOBJ_STYLE2"
		$SCE_AU3_STYLE15a = $Farbstring_sh1
		$SCE_AU3_STYLE15b = $Farbstring_sh2
	case 16
		$section_sh1 = "AU3_UDF_STYLE1"
		$section_sh2 = "AU3_UDF_STYLE2"
		$SCE_AU3_STYLE16a = $Farbstring_sh1
		$SCE_AU3_STYLE16b = $Farbstring_sh2
EndSwitch

;Schreibe in config
_Write_in_Config($section_sh1, $Farbstring_sh1)
_Write_in_Config($section_sh2, $Farbstring_sh2)
next
endfunc

func _farbeinstellungen_auf_Standard_vorbereiten()
_farbeinstellungen_zuruecksetzen()
endfunc

func _farbeinstellungen_fuer_dark_theme_vorbereiten()
	guictrlsetdata($darstellung_scripteditor_font, "Consolas")
	guictrlsetdata($darstellung_scripteditor_size, "10")
	guictrlsetdata($darstellung_scripteditor_bgcolour, "0x1F1F1F")
	GUICtrlSetColor($darstellung_scripteditor_bgcolour, _ColourInvert(Execute(0x1F1F1F)))
	GUICtrlSetBkColor($darstellung_scripteditor_bgcolour, 0x1F1F1F)
	_Write_in_Config("scripteditor_bgcolour", "0x1F1F1F")
	guictrlsetdata($darstellung_scripteditor_rowcolour, "0x585858")
	GUICtrlSetColor($darstellung_scripteditor_rowcolour, _ColourInvert(Execute(0x585858)))
	GUICtrlSetBkColor($darstellung_scripteditor_rowcolour, 0x585858)
	_Write_in_Config("scripteditor_rowcolour", "0x585858")
	guictrlsetdata($darstellung_scripteditor_marccolour, "0xFFFFFF")
	GUICtrlSetColor($darstellung_scripteditor_marccolour, _ColourInvert(Execute(0xFFFFFF)))
	GUICtrlSetBkColor($darstellung_scripteditor_marccolour, 0xFFFFFF)
	_Write_in_Config("scripteditor_marccolour", "0xFFFFFF")
	guictrlsetdata($darstellung_scripteditor_highlightcolour, "0xFFFFFF")
	GUICtrlSetColor($darstellung_scripteditor_highlightcolour, _ColourInvert(Execute(0xFFFFFF)))
	GUICtrlSetBkColor($darstellung_scripteditor_highlightcolour, 0xFFFFFF)
	_Write_in_Config("scripteditor_highlightcolour", "0xFFFFFF")
    guictrlsetdata($darstellung_scripteditor_errorcolor, "0xa50000")
	GUICtrlSetColor($darstellung_scripteditor_errorcolor, _ColourInvert(Execute(0xa50000)))
	GUICtrlSetBkColor($darstellung_scripteditor_errorcolor, 0xa50000)
	_Write_in_Config("scripteditor_errorcolour", "0xa50000")
    guictrlsetdata($darstellung_scripteditor_cursorcolor, "0xFFFFFF")
	GUICtrlSetColor($darstellung_scripteditor_cursorcolor, _ColourInvert(Execute(0xFFFFFF)))
	GUICtrlSetBkColor($darstellung_scripteditor_cursorcolor, 0xFFFFFF)
	_Write_in_Config("scripteditor_caretcolour", "0xFFFFFF")
	GUICtrlSetState($einstellungen_farben_hintergrund_fuer_alle_checkbox,$GUI_CHECKED)
	GUICtrlSetState($Checkbox_use_new_colours,$GUI_UNCHECKED)
	GUICtrlSetdata($darstellung_scripteditor_cursorwidth,1)
	GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio1,$GUI_CHECKED)
	GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio2,$GUI_UNCHECKED)

    GUICtrlSetdata($darstellung_treefont_colour,"0xFFFFFF")
	_Write_in_Config("treefont_colour", "0xFFFFFF")
	$treefont_colour = "0xFFFFFF"



_Write_in_Config("AU3_DEFAULT_STYLE1","0xC8C8C8|0x1F1F1F|0|0|0")
_Write_in_Config("AU3_DEFAULT_STYLE2","0xC8C8C8|0x1F1F1F|0|0|0")
_Write_in_Config("AU3_COMMENT_STYLE1","0x23BC4C|0x1F1F1F|0|1|0")
_Write_in_Config("AU3_COMMENT_STYLE2","0x23BC4C|0x1F1F1F|0|0|0")
_Write_in_Config("AU3_COMMENTBLOCK_STYLE1","0x23BC4C|0x1F1F1F|0|1|0")
_Write_in_Config("AU3_COMMENTBLOCK_STYLE2","0x23BC4C|0x1F1F1F|0|0|0")
_Write_in_Config("AU3_NUMBER_STYLE1","0xB5CEA8|0x1F1F1F|1|1|0")
_Write_in_Config("AU3_NUMBER_STYLE2","0xB5CEA8|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_FUNCTION_STYLE1","0xBD63C5|0x1F1F1F|1|1|0")
_Write_in_Config("AU3_FUNCTION_STYLE2","0xBD63C5|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_KEYWORD_STYLE1","0xD69C4E|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_KEYWORD_STYLE2","0xD69C4E|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_MACRO_STYLE1","0xBD63C5|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_MACRO_STYLE2","0xBD63C5|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_STRING_STYLE1","0x859DD6|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_STRING_STYLE2","0x859DD6|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_OPERATOR_STYLE1","0xDCDCDC|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_OPERATOR_STYLE2","0xDCDCDC|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_VARIABLE_STYLE1","0xB0C94E|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_VARIABLE_STYLE2","0xB0C94E|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_SENT_STYLE1","0xC8C8C8|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_SENT_STYLE2","0xC8C8C8|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_PREPROCESSOR_STYLE1","0x9B9B9B|0x1F1F1F|0|1|0")
_Write_in_Config("AU3_PREPROCESSOR_STYLE2","0x9B9B9B|0x1F1F1F|0|0|0")
_Write_in_Config("AU3_SPECIAL_STYLE1","0xC8C8C8|0x1F1F1F|0|1|0")
_Write_in_Config("AU3_SPECIAL_STYLE2","0xC8C8C8|0x1F1F1F|0|1|0")
_Write_in_Config("AU3_EXPAND_STYLE1","0xC8C8C8|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_EXPAND_STYLE2","0xC8C8C8|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_COMOBJ_STYLE1","0x00FF00|0x1F1F1F|1|1|0")
_Write_in_Config("AU3_COMOBJ_STYLE2","0x00FF00|0x1F1F1F|1|0|0")
_Write_in_Config("AU3_UDF_STYLE1","0xFF8000|0x1F1F1F|0|1|0")
_Write_in_Config("AU3_UDF_STYLE2","0xFF8000|0x1F1F1F|1|0|0")




;Werte neu einlesen
$SCE_AU3_STYLE1a = _Config_Read("AU3_DEFAULT_STYLE1", "0x000000|0xFFFFFF|0|0|0")
$SCE_AU3_STYLE2a = _Config_Read("AU3_COMMENT_STYLE1", "0x339900|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE3a = _Config_Read("AU3_COMMENTBLOCK_STYLE1", "0x009966|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE4a = _Config_Read("AU3_NUMBER_STYLE1", "0xA900AC|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE5a = _Config_Read("AU3_FUNCTION_STYLE1", "0xAA0000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE6a = _Config_Read("AU3_KEYWORD_STYLE1", "0xFF0000|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE7a = _Config_Read("AU3_MACRO_STYLE1", "0xFF33FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE8a = _Config_Read("AU3_STRING_STYLE1", "0xCC9999|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE9a = _Config_Read("AU3_OPERATOR_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE10a = _Config_Read("AU3_VARIABLE_STYLE1", "0x000090|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE11a = _Config_Read("AU3_SENT_STYLE1", "0x0080FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE12a = _Config_Read("AU3_PREPROCESSOR_STYLE1", "0xFF00F0|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE13a = _Config_Read("AU3_SPECIAL_STYLE1", "0xF00FA0|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE14a = _Config_Read("AU3_EXPAND_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE15a = _Config_Read("AU3_COMOBJ_STYLE1", "0xFF0000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE16a = _Config_Read("AU3_UDF_STYLE1", "0xFF8000|0xFFFFFF|0|1|0")


$SCE_AU3_STYLE1b = _Config_Read("AU3_DEFAULT_STYLE2", "0x000000|0xFFFFFF|0|0|0")
$SCE_AU3_STYLE2b = _Config_Read("AU3_COMMENT_STYLE2", "0x339900|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE3b = _Config_Read("AU3_COMMENTBLOCK_STYLE2", "0x009966|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE4b = _Config_Read("AU3_NUMBER_STYLE2", "0xFF0000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE5b = _Config_Read("AU3_FUNCTION_STYLE2", "0x900000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE6b = _Config_Read("AU3_KEYWORD_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE7b = _Config_Read("AU3_MACRO_STYLE2", "0x008080|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE8b = _Config_Read("AU3_STRING_STYLE2", "0x0000FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE9b = _Config_Read("AU3_OPERATOR_STYLE2", "0x0080FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE10b = _Config_Read("AU3_VARIABLE_STYLE2", "0x5A5A5A|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE11b = _Config_Read("AU3_SENT_STYLE2", "0x808080|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE12b = _Config_Read("AU3_PREPROCESSOR_STYLE2", "0x008080|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE13b = _Config_Read("AU3_SPECIAL_STYLE2", "0x3C14DC|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE14b = _Config_Read("AU3_EXPAND_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE15b = _Config_Read("AU3_COMOBJ_STYLE2", "0x993399|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE16b = _Config_Read("AU3_UDF_STYLE2", "0xFF8000|0xFFFFFF|0|1|0")
_Einstellungen_Lade_Farben()
EndFunc



func _farbeinstellungen_zuruecksetzen()
$antwort = msgbox(32+262144+4,_Get_langstr(48),_Get_langstr(892),0,$Config_GUI)
if $antwort = 7 then return
	guictrlsetdata($darstellung_scripteditor_font, "Courier New")
	guictrlsetdata($darstellung_scripteditor_size, "10")
	guictrlsetdata($darstellung_scripteditor_bgcolour, "0xFFFFFF")
	GUICtrlSetColor($darstellung_scripteditor_bgcolour, _ColourInvert(Execute(0xFFFFFF)))
	GUICtrlSetBkColor($darstellung_scripteditor_bgcolour, 0xFFFFFF)
	guictrlsetdata($darstellung_scripteditor_rowcolour, "0xFFFED8")
	GUICtrlSetColor($darstellung_scripteditor_rowcolour, _ColourInvert(Execute(0xFFFED8)))
	GUICtrlSetBkColor($darstellung_scripteditor_rowcolour, 0xFFFED8)
	guictrlsetdata($darstellung_scripteditor_marccolour, "0x3289D0")
	GUICtrlSetColor($darstellung_scripteditor_marccolour, _ColourInvert(Execute(0x3289D0)))
	GUICtrlSetBkColor($darstellung_scripteditor_marccolour, 0x3289D0)
	guictrlsetdata($darstellung_scripteditor_highlightcolour, "0xFF0000")
	GUICtrlSetColor($darstellung_scripteditor_highlightcolour, _ColourInvert(Execute(0xFF0000)))
	GUICtrlSetBkColor($darstellung_scripteditor_highlightcolour, 0xFF0000)
    guictrlsetdata($darstellung_scripteditor_errorcolor, "0xFEBDBD")
	GUICtrlSetColor($darstellung_scripteditor_errorcolor, _ColourInvert(Execute(0xFEBDBD)))
	GUICtrlSetBkColor($darstellung_scripteditor_errorcolor, 0xFEBDBD)
    guictrlsetdata($darstellung_scripteditor_cursorcolor, "0x000000")
	GUICtrlSetColor($darstellung_scripteditor_cursorcolor, _ColourInvert(Execute(0x000000)))
	GUICtrlSetBkColor($darstellung_scripteditor_cursorcolor, 0x000000)
	GUICtrlSetState($einstellungen_farben_hintergrund_fuer_alle_checkbox,$GUI_CHECKED)
	GUICtrlSetState($Checkbox_use_new_colours,$GUI_UNCHECKED)
	GUICtrlSetdata($darstellung_scripteditor_cursorwidth,1)
	GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio1,$GUI_CHECKED)
	GUICtrlSetState($darstellung_scripteditor_cursorstyle_Radio2,$GUI_UNCHECKED)
   GUICtrlSetdata($darstellung_treefont_colour,"0x000000")
   GUICtrlSetBkColor($darstellung_treefont_colour,"0x000000")
   GUICtrlSetColor($darstellung_treefont_colour, _ColourInvert(Execute(0x000000)))
   $treefont_colour = "0x000000"


for $x = 1 to 16

;Hole config section
$section_sh1 = ""
$section_sh2 = ""

switch $x
	case 1
		$section_sh1 = "AU3_DEFAULT_STYLE1"
		$section_sh2 = "AU3_DEFAULT_STYLE2"

	case 2
		$section_sh1 = "AU3_COMMENT_STYLE1"
		$section_sh2 = "AU3_COMMENT_STYLE2"

	case 3
		$section_sh1 = "AU3_COMMENTBLOCK_STYLE1"
		$section_sh2 = "AU3_COMMENTBLOCK_STYLE2"

	case 4
		$section_sh1 = "AU3_NUMBER_STYLE1"
		$section_sh2 = "AU3_NUMBER_STYLE2"

	case 5
		$section_sh1 = "AU3_FUNCTION_STYLE1"
		$section_sh2 = "AU3_FUNCTION_STYLE2"

	case 6
		$section_sh1 = "AU3_KEYWORD_STYLE1"
		$section_sh2 = "AU3_KEYWORD_STYLE2"

	case 7
		$section_sh1 = "AU3_MACRO_STYLE1"
		$section_sh2 = "AU3_MACRO_STYLE2"

	case 8
		$section_sh1 = "AU3_STRING_STYLE1"
		$section_sh2 = "AU3_STRING_STYLE2"

	case 9
		$section_sh1 = "AU3_OPERATOR_STYLE1"
		$section_sh2 = "AU3_OPERATOR_STYLE2"

	case 10
		$section_sh1 = "AU3_VARIABLE_STYLE1"
		$section_sh2 = "AU3_VARIABLE_STYLE2"

	case 11
		$section_sh1 = "AU3_SENT_STYLE1"
		$section_sh2 = "AU3_SENT_STYLE2"

	case 12
		$section_sh1 = "AU3_PREPROCESSOR_STYLE1"
		$section_sh2 = "AU3_PREPROCESSOR_STYLE2"

	case 13
		$section_sh1 = "AU3_SPECIAL_STYLE1"
		$section_sh2 = "AU3_SPECIAL_STYLE2"

	case 14
		$section_sh1 = "AU3_EXPAND_STYLE1"
		$section_sh2 = "AU3_EXPAND_STYLE2"

	case 15
		$section_sh1 = "AU3_COMOBJ_STYLE1"
		$section_sh2 = "AU3_COMOBJ_STYLE2"

	case 16
		$section_sh1 = "AU3_UDF_STYLE1"
		$section_sh2 = "AU3_UDF_STYLE2"
	EndSwitch

IniDelete ($Configfile, "config", $section_sh1)
IniDelete ($Configfile, "config", $section_sh2)
next

;Werte neu einlesen
$SCE_AU3_STYLE1a = _Config_Read("AU3_DEFAULT_STYLE1", "0x000000|0xFFFFFF|0|0|0")
$SCE_AU3_STYLE2a = _Config_Read("AU3_COMMENT_STYLE1", "0x339900|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE3a = _Config_Read("AU3_COMMENTBLOCK_STYLE1", "0x009966|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE4a = _Config_Read("AU3_NUMBER_STYLE1", "0xA900AC|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE5a = _Config_Read("AU3_FUNCTION_STYLE1", "0xAA0000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE6a = _Config_Read("AU3_KEYWORD_STYLE1", "0xFF0000|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE7a = _Config_Read("AU3_MACRO_STYLE1", "0xFF33FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE8a = _Config_Read("AU3_STRING_STYLE1", "0xCC9999|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE9a = _Config_Read("AU3_OPERATOR_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE10a = _Config_Read("AU3_VARIABLE_STYLE1", "0x000090|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE11a = _Config_Read("AU3_SENT_STYLE1", "0x0080FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE12a = _Config_Read("AU3_PREPROCESSOR_STYLE1", "0xFF00F0|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE13a = _Config_Read("AU3_SPECIAL_STYLE1", "0xF00FA0|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE14a = _Config_Read("AU3_EXPAND_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE15a = _Config_Read("AU3_COMOBJ_STYLE1", "0xFF0000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE16a = _Config_Read("AU3_UDF_STYLE1", "0xFF8000|0xFFFFFF|0|1|0")


$SCE_AU3_STYLE1b = _Config_Read("AU3_DEFAULT_STYLE2", "0x000000|0xFFFFFF|0|0|0")
$SCE_AU3_STYLE2b = _Config_Read("AU3_COMMENT_STYLE2", "0x339900|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE3b = _Config_Read("AU3_COMMENTBLOCK_STYLE2", "0x009966|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE4b = _Config_Read("AU3_NUMBER_STYLE2", "0xFF0000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE5b = _Config_Read("AU3_FUNCTION_STYLE2", "0x900000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE6b = _Config_Read("AU3_KEYWORD_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE7b = _Config_Read("AU3_MACRO_STYLE2", "0x008080|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE8b = _Config_Read("AU3_STRING_STYLE2", "0x0000FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE9b = _Config_Read("AU3_OPERATOR_STYLE2", "0x0080FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE10b = _Config_Read("AU3_VARIABLE_STYLE2", "0x5A5A5A|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE11b = _Config_Read("AU3_SENT_STYLE2", "0x808080|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE12b = _Config_Read("AU3_PREPROCESSOR_STYLE2", "0x008080|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE13b = _Config_Read("AU3_SPECIAL_STYLE2", "0x3C14DC|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE14b = _Config_Read("AU3_EXPAND_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE15b = _Config_Read("AU3_COMOBJ_STYLE2", "0x993399|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE16b = _Config_Read("AU3_UDF_STYLE2", "0xFF8000|0xFFFFFF|0|1|0")
_Einstellungen_Lade_Farben()
EndFunc

func _Konfiguration_Exportieren_Zeige_GUI()
GUISetState(@SW_SHOW,$konfiguration_exportiern_GUI)
GUISetState(@SW_DISABLE,$Config_GUI)
endfunc

func _Konfiguration_Exportieren_verstecke_GUI()
GUISetState(@SW_ENABLE,$Config_GUI)
GUISetState(@SW_HIDE,$konfiguration_exportiern_GUI)
endfunc

func _Konfiguration_Exportieren()
_Konfiguration_Exportieren_verstecke_GUI()
$Datei = FileSaveDialog(_Get_langstr(313), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio configuration file (*.ini)", 18, "config.ini", $config_gui)
FileChangeDir(@scriptdir)
if $Datei = "" then Return
if @Error > 0 then return
filecopy($Configfile,$Datei,8+1)
if guictrlread($konfiguration_exportiern_GUI_checkbox) = $GUI_UNCHECKED Then ;Lösche einige Elemente wie Programmpfade usw.
IniDelete ($Datei, "config" , "autoitexe")
IniDelete ($Datei, "config" , "helpfileexe")
IniDelete ($Datei, "config" , "autoit2exe")
IniDelete ($Datei, "config" , "lastproject")
IniDelete ($Datei, "config" , "templatefolder")
IniDelete ($Datei, "config" , "releasefolder")
IniDelete ($Datei, "config" , "projectfolder")
IniDelete ($Datei, "config" , "backupfolder")
IniDelete ($Datei, "config" , "pluginsdir")
IniDelete ($Datei, "history")
endif
IniDelete ($Datei, "config" , "startups")
IniDelete ($Datei, "config" , "SciTE4AutoIt_au3mode")
IniDelete ($Datei, "trophies")	;Trophän nie in die ini exportieren
msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $config_gui)
endfunc

func _Konfiguration_Importieren()
	if $Offenes_Projekt <> "" Then
	msgbox(262144 + 16, _Get_langstr(25), _Get_langstr(930), 0, $config_gui)
	return
	endif
	$var = FileOpenDialog(_Get_langstr(931), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio configuration file (*.ini)", 1 + 2 + 4, "",  $config_gui)
	FileChangeDir(@scriptdir)
	if $var = "" then return
	If @error Then return

	$sections = IniReadSectionNames($var)
	if @error then return
	if not _ArraySearch($sections,"config") then return
	for $x = 1 to $sections[0]
		$Werte_der_Section = IniReadSection($var, $sections[$x])
		for $y = 1 to $Werte_der_Section[0][0]
			iniwrite($Configfile,$sections[$x],$Werte_der_Section[$y][0],$Werte_der_Section[$y][1])
		next
next
msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(929), 0, $config_gui)
_exit() ;Beende das ISN
EndFunc


func _Immer_am_primaeren_monitor_starten_Toggle_Checkbox()
if guictrlread($_Immer_am_primaeren_monitor_starten_checkbox) = $GUI_Checked then
	GUICtrlSetState($darstellung_monitordropdown,$GUI_DISABLE)
Else
	GUICtrlSetState($darstellung_monitordropdown,$GUI_ENABLE)
endif

if guictrlread($programmeinstellungen_Darstellung_HighDPIMode_Checkbox) = $GUI_Checked then
	GUICtrlSetState($programmeinstellungen_Darstellung_WindowsDPIMode_Checkbox,$GUI_ENABLE)
	GUICtrlSetState($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox,$GUI_ENABLE)

	if guictrlread($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox) = $GUI_Checked then
	  	GUICtrlSetState($programmeinstellungen_DPI_Slider,$GUI_ENABLE)
	    GUICtrlSetState($programmeinstellungen_DPI_Slider_Label,$GUI_ENABLE)
    Else
	  	GUICtrlSetState($programmeinstellungen_DPI_Slider,$GUI_DISABLE)
	   GUICtrlSetState($programmeinstellungen_DPI_Slider_Label,$GUI_DISABLE)
    EndIf


Else
	GUICtrlSetState($programmeinstellungen_Darstellung_WindowsDPIMode_Checkbox,$GUI_DISABLE)
	GUICtrlSetState($programmeinstellungen_Darstellung_CustomDPIMode_Checkbox,$GUI_DISABLE)
	GUICtrlSetState($programmeinstellungen_DPI_Slider,$GUI_DISABLE)
	GUICtrlSetState($programmeinstellungen_DPI_Slider_Label,$GUI_DISABLE)
endif


endfunc




func _Einstellungen_Toolbar_ItemID_zu_Listview($handle="",$ID="")
if $handle="" then return
if $ID="" then return

switch $ID

	case "#tbar_newfile#"
	;Neue Datei
	_GUICtrlListView_AddItem($handle, _Get_langstr(70),0)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_newfolder#"
	;Neuer Ordner
	_GUICtrlListView_AddItem($handle, _Get_langstr(71),1)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_importfile#"
	;Dateien importiern
	_GUICtrlListView_AddItem($handle, _Get_langstr(72),2)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_importfolder#"
	;Ordner importiern
	_GUICtrlListView_AddItem($handle, _Get_langstr(455),3)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_export#"
	;Datei exportiern
	_GUICtrlListView_AddItem($handle, _Get_langstr(73),4)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_deletefile#"
	;Datei löschen
	_GUICtrlListView_AddItem($handle, _Get_langstr(74),5)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_refreshprojecttree#"
	;Projektbaum aktualisieren
	_GUICtrlListView_AddItem($handle, _Get_langstr(53),6)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_fullscreen#"
	;Vollbild
	_GUICtrlListView_AddItem($handle, _Get_langstr(457),20)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_sep#"
	;Abstand (Seperator)
	_GUICtrlListView_AddItem($handle, _Get_langstr(957),10)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_testproject#"
	;Projekt testen
	_GUICtrlListView_AddItem($handle, _Get_langstr(489),7)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_compile#"
	;Projekt kompilieren
	_GUICtrlListView_AddItem($handle, _Get_langstr(52),8)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_macros#"
	;Makros
	_GUICtrlListView_AddItem($handle, _Get_langstr(519),22)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_projectproberties#"
	;Projekteigenschaften
	_GUICtrlListView_AddItem($handle, _Get_langstr(51),9)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_save#"
	;Speichern
	_GUICtrlListView_AddItem($handle, _Get_langstr(9),11)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_saveall#"
	;Alle Tabs Speichern
	_GUICtrlListView_AddItem($handle, _Get_langstr(650),29)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_closetab#"
	;Tab schließen
	_GUICtrlListView_AddItem($handle, _Get_langstr(31),14)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_undo#"
	;Rückgängig
	_GUICtrlListView_AddItem($handle, _Get_langstr(55),12)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_redo#"
	;Wiederholen
	_GUICtrlListView_AddItem($handle, _Get_langstr(56),13)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_testscript#"
	;Skript testen
	_GUICtrlListView_AddItem($handle, _Get_langstr(82),15)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_stopproject#"
	;Skript stoppen
	_GUICtrlListView_AddItem($handle, _Get_langstr(106),17)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_search#"
	;suche
	_GUICtrlListView_AddItem($handle, _Get_langstr(87),16)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_syntaxcheck#"
	;Syntaxcheck
	_GUICtrlListView_AddItem($handle, _Get_langstr(108),18)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_tidy#"
	;Tidy
	_GUICtrlListView_AddItem($handle, _Get_langstr(327),19)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_commentout#"
	;Auskommentieren
	_GUICtrlListView_AddItem($handle, _Get_langstr(328),21)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_windowtool#"
	;Fenster Info Tool
	_GUICtrlListView_AddItem($handle, _Get_langstr(609),23)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_macroslot1#"
	;Makroslot1
	_GUICtrlListView_AddItem($handle, _Get_langstr(611),24)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_macroslot2#"
	;Makroslot2
	_GUICtrlListView_AddItem($handle, _Get_langstr(612),25)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_macroslot3#"
	;Makroslot3
	_GUICtrlListView_AddItem($handle, _Get_langstr(613),26)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_macroslot4#"
	;Makroslot4
	_GUICtrlListView_AddItem($handle, _Get_langstr(614),27)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_macroslot5#"
	;Makroslot5
	_GUICtrlListView_AddItem($handle, _Get_langstr(615),28)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_macroslot6#"
	;Makroslot6
	_GUICtrlListView_AddItem($handle, _Get_langstr(906),30)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_macroslot7#"
	;Makroslot7
	_GUICtrlListView_AddItem($handle, _Get_langstr(907),31)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_changelogmanager#"
	;Änderungsprotokolle
	_GUICtrlListView_AddItem($handle, _Get_langstr(911),32)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_settings#"
	;Programmeinstellungen
	_GUICtrlListView_AddItem($handle, _Get_langstr(42),33)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_colortoolbox#"
	;Farbtoolbox
	_GUICtrlListView_AddItem($handle, _Get_langstr(651),34)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_closeproject#"
	;Projekt schließen
	_GUICtrlListView_AddItem($handle, _Get_langstr(41),35)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)

	case "#tbar_plugin1#"
	;Slot für Erweitertes Plugin1
	if _AdvancedISNPlugin_get_name(1) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(1)
	 if StringInStr($Icon,".ico") Then
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(1),_GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	else
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(1),_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
	endif

	case "#tbar_plugin2#"
	;Slot für Erweitertes Plugin2
	if _AdvancedISNPlugin_get_name(2) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(2)
	 if StringInStr($Icon,".ico") Then
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(2),_GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	else
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(2),_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
	endif

	case "#tbar_plugin3#"
	;Slot für Erweitertes Plugin3
	if _AdvancedISNPlugin_get_name(3) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(3)
	 if StringInStr($Icon,".ico") Then
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(3),_GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	else
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(3),_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
	endif

	case "#tbar_plugin4#"
	;Slot für Erweitertes Plugin4
	if _AdvancedISNPlugin_get_name(4) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(4)
	 if StringInStr($Icon,".ico") Then
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(4),_GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	else
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(4),_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
	endif

	case "#tbar_plugin5#"
	;Slot für Erweitertes Plugin5
	if _AdvancedISNPlugin_get_name(5) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(5)
	 if StringInStr($Icon,".ico") Then
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(5),_GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	else
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(5),_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
	endif

	case "#tbar_plugin6#"
	;Slot für Erweitertes Plugin6
	if _AdvancedISNPlugin_get_name(6) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(6)
	 if StringInStr($Icon,".ico") Then
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(6),_GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	else
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(6),_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
	endif

	case "#tbar_plugin7#"
	;Slot für Erweitertes Plugin7
	if _AdvancedISNPlugin_get_name(7) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(7)
	 if StringInStr($Icon,".ico") Then
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(7),_GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	else
	_GUICtrlListView_AddItem($handle, _AdvancedISNPlugin_get_name(7),_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)
	endif

	case "#tbar_projectsettings#"
	;Projekt schließen
	_GUICtrlListView_AddItem($handle, _Get_langstr(1078),36)
	_GUICtrlListView_AddSubItem($handle, _GUICtrlListView_GetItemCount($handle) - 1, $ID, 1)



EndSwitch
EndFunc




func _Toolbar_nach_layout_anordnen()
$Elemente_Array = StringSplit($Toolbarlayout,"|",2)
if not IsArray($Elemente_Array) then return
if @error then return

;Lösche alle Einträge
_GUICtrlToolbar_Destroy($hToolbar)


;Toolbar aufbauen
$hToolbar = _GUICtrlToolbar_Create($StudioFenster)
_GUICtrlToolbar_SetButtonSize ( $hToolbar, 24 * $DPI, 22 * $DPI)
_GUICtrlToolbar_SetImageList($hToolbar, $hToolBarImageListNorm)
_GUICtrlToolbar_SetToolTips($hToolbar, $Toolbar_ToolTip)


for $x = 0 to ubound($Elemente_Array)-1

switch $Elemente_Array[$x]

case "#tbar_newfile#"
	;Neue Datei
	_GUICtrlToolbar_AddButton($hToolbar, $id1, 0, -1, BitOR($BTNS_DROPDOWN, $BTNS_WHOLEDROPDOWN)) ; newfile


case "#tbar_newfolder#"
	;Neuer Ordner
	_GUICtrlToolbar_AddButton($hToolbar, $id2, 1) ; newfolder

	case "#tbar_importfile#"
	;Dateien importiern
	_GUICtrlToolbar_AddButton($hToolbar, $id3, 2) ; import

	case "#tbar_importfolder#"
	;Ordner importiern
	_GUICtrlToolbar_AddButton($hToolbar, $id19, 3) ; importfolder

	case "#tbar_export#"
	;Datei exportiern
	_GuICtrlToolbar_AddButton($hToolbar, $id4, 4) ; export

	case "#tbar_deletefile#"
	;Datei löschen
	_GUICtrlToolbar_AddButton($hToolbar, $id5, 5) ; löschen

	case "#tbar_refreshprojecttree#"
	;Projektbaum aktualisieren
	_GUICtrlToolbar_AddButton($hToolbar, $id6, 6) ; projecttree

	case "#tbar_fullscreen#"
	;Vollbild
	_GUICtrlToolbar_AddButton($hToolbar, $id20, 20) ; fullscreenmode

	case "#tbar_sep#"
	;Abstand (Seperator)
	if $ISN_Dark_Mode = "true" then
	_GUICtrlToolbar_AddButtonSep ($hToolbar, 8) ;sep
	else
	_GUICtrlToolbar_AddButton($hToolbar, -1, 10, default, default, $TBSTATE_INDETERMINATE) ;sep
	endif

	case "#tbar_testproject#"
	;Projekt testen
	_GUICtrlToolbar_AddButton($hToolbar, $id7, 7, -1, BitOR($BTNS_DROPDOWN, $BTNS_WHOLEDROPDOWN)) ; testproject

	case "#tbar_compile#"
	;Projekt kompilieren
	_GUICtrlToolbar_AddButton($hToolbar, $id8, 8, -1, BitOR($BTNS_DROPDOWN, $BTNS_WHOLEDROPDOWN)) ; compile

	case "#tbar_macros#"
	;Makros
	_GUICtrlToolbar_AddButton($hToolbar, $id22, 22) ; projektregeln

	case "#tbar_projectproberties#"
	;Projekteigenschaften
	_GUICtrlToolbar_AddButton($hToolbar, $id9, 9) ; eigenschaften

	case "#tbar_save#"
	;Speichern
	_GUICtrlToolbar_AddButton($hToolbar, $id10, 11) ; speichern

	case "#tbar_saveall#"
	;Alle Tabs Speichern
	_GUICtrlToolbar_AddButton($hToolbar, $id29, 29) ; save all tabs

	case "#tbar_closetab#"
	;Tab schließen
	_GUICtrlToolbar_AddButton($hToolbar, $id13, 14) ; closetab

	case "#tbar_undo#"
	;Rückgängig
	_GUICtrlToolbar_AddButton($hToolbar, $id11, 12) ; undo

	case "#tbar_redo#"
	;Wiederholen
	_GUICtrlToolbar_AddButton($hToolbar, $id12, 13) ; redo

	case "#tbar_testscript#"
	;Skript testen
	_GUICtrlToolbar_AddButton($hToolbar, $id14, 15) ; testscript

	case "#tbar_stopproject#"
	;Skript stoppen
	_GUICtrlToolbar_AddButton($hToolbar, $id15, 17) ; stopscript

	case "#tbar_search#"
	;suche
	_GUICtrlToolbar_AddButton($hToolbar, $id16, 16) ; search

	case "#tbar_syntaxcheck#"
	;Syntaxcheck
	_GUICtrlToolbar_AddButton($hToolbar, $id17, 18) ; syntaxcheck

	case "#tbar_tidy#"
	;Tidy
	_GUICtrlToolbar_AddButton($hToolbar, $id18, 19) ; tidy

	case "#tbar_commentout#"
	;Auskommentieren
	_GUICtrlToolbar_AddButton($hToolbar, $id21, 21) ; comment out

	case "#tbar_windowtool#"
	;Fenster Info Tool
	_GUICtrlToolbar_AddButton($hToolbar, $id23, 23) ; window info tool

	case "#tbar_macroslot1#"
	;Makroslot1
	_GUICtrlToolbar_AddButton($hToolbar, $id24, 24) ; custom rule 1

	case "#tbar_macroslot2#"
	;Makroslot2
	_GUICtrlToolbar_AddButton($hToolbar, $id25, 25) ; custom rule 2

	case "#tbar_macroslot3#"
	;Makroslot3
	_GUICtrlToolbar_AddButton($hToolbar, $id26, 26) ; custom rule 3

	case "#tbar_macroslot4#"
	;Makroslot4
	_GUICtrlToolbar_AddButton($hToolbar, $id27, 27) ; custom rule 4

	case "#tbar_macroslot5#"
	;Makroslot5
	_GUICtrlToolbar_AddButton($hToolbar, $id28, 28) ; custom rule 5

	case "#tbar_macroslot6#"
	;Makroslot6
	_GUICtrlToolbar_AddButton($hToolbar, $Toolbar_makroslot6, 30) ; custom rule 6

	case "#tbar_macroslot7#"
	;Makroslot7
	_GUICtrlToolbar_AddButton($hToolbar, $Toolbar_makroslot7, 31) ; custom rule 7

	case "#tbar_changelogmanager#"
	;Änderungsprotokolle
	_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_aenderungsprotokoll, 32)

	case "#tbar_settings#"
	;Programmeinstellungen
	_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_programmeinstellungen, 33)

   case "#tbar_projectsettings#"
	;Programmeinstellungen
	_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_projekteinstellungen, 36)

	case "#tbar_colortoolbox#"
	;Programmeinstellungen
	_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_Farbtoolbox, 34)

	case "#tbar_closeproject#"
	;Projekt schließen
	_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_closeproject, 35)

	case "#tbar_plugin1#"
	;Slot für Erweitertes Plugin1
	if _AdvancedISNPlugin_get_name(1) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(1)
	 if StringInStr($Icon,".ico") Then
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot1, _GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	Else
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot1, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	endif

	case "#tbar_plugin2#"
	;Slot für Erweitertes Plugin2
	if _AdvancedISNPlugin_get_name(2) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(2)
	 if StringInStr($Icon,".ico") Then
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot2, _GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	Else
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot2, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	endif

	case "#tbar_plugin3#"
	;Slot für Erweitertes Plugin3
	if _AdvancedISNPlugin_get_name(3) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(3)
	 if StringInStr($Icon,".ico") Then
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot3, _GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	Else
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot3, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	endif

	case "#tbar_plugin4#"
	;Slot für Erweitertes Plugin4
	if _AdvancedISNPlugin_get_name(4) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(4)
	 if StringInStr($Icon,".ico") Then
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot4, _GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	Else
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot4, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	endif

	case "#tbar_plugin5#"
	;Slot für Erweitertes Plugin5
	if _AdvancedISNPlugin_get_name(5) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(5)
	 if StringInStr($Icon,".ico") Then
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot5, _GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	Else
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot5, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	endif

	case "#tbar_plugin6#"
	;Slot für Erweitertes Plugin6
	if _AdvancedISNPlugin_get_name(6) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(6)
	 if StringInStr($Icon,".ico") Then
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot6, _GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	Else
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot6, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	endif

	case "#tbar_plugin7#"
	;Slot für Erweitertes Plugin7
	if _AdvancedISNPlugin_get_name(7) <> "" then
	$Icon = _AdvancedISNPlugin_get_Icon(7)
	 if StringInStr($Icon,".ico") Then
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot7, _GUIImageList_AddIcon($hToolBarImageListNorm,$Icon, 0))
	Else
		_GUICtrlToolbar_AddButton($hToolbar, $Toolbarmenu_pluginslot7, _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, $Icon-1))
	endif
	endif

EndSwitch
next

if $Skin_is_used = "true" Then
_GUICtrlToolbar_SetStyleTransparent ( $hToolbar, true )
_GUICtrlToolbar_SetColorScheme($hToolbar, 0xffffff, 0xffffff)
EndIf



EndFunc

func _Einstellungen_Toolbar_Layoutstring_generieren_und_abspeichern()
$Fertiger_String = ""
for $y = 0 to _GUICtrlListView_GetItemCount($einstellungen_toolbar_aktiveelemente_listview)-1
if _GUICtrlListView_GetItemText($einstellungen_toolbar_aktiveelemente_listview,$y,1) = "" then ContinueLoop
$Fertiger_String = $Fertiger_String&_GUICtrlListView_GetItemText($einstellungen_toolbar_aktiveelemente_listview,$y,1)&"|"
next
if StringRight ($Fertiger_String, 1) = "|" then $Fertiger_String = StringTrimRight($Fertiger_String,1)
if $Fertiger_String = "" then $Fertiger_String = $Toolbar_Standardlayout
_Write_in_Config("toolbar_layout", $Fertiger_String)
$Toolbarlayout = $Fertiger_String
endfunc

func _Einstellungen_Toolbar_entferne_Eintrag()
if _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview) = -1 then return
$Item_to_add = 	_GUICtrlListView_GetItemText($einstellungen_toolbar_aktiveelemente_listview,_GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview),1)
_GUICtrlListView_DeleteItem(GUICtrlGetHandle($einstellungen_toolbar_aktiveelemente_listview),_GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview))
if $Item_to_add <> "#tbar_sep#" then _Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,$Item_to_add)
_GUICtrlListView_SetItemSelected($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview),true,true)
EndFunc

func _Einstellungen_Toolbar_Eintrag_hinzufuegen()
if _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_verfuegbareelemente_listview) = -1 then return
$Item_to_add = 	_GUICtrlListView_GetItemText($einstellungen_toolbar_verfuegbareelemente_listview,_GUICtrlListView_GetSelectionMark($einstellungen_toolbar_verfuegbareelemente_listview),1)
if $Item_to_add <> "#tbar_sep#" then _GUICtrlListView_DeleteItem(GUICtrlGetHandle($einstellungen_toolbar_verfuegbareelemente_listview),_GUICtrlListView_GetSelectionMark($einstellungen_toolbar_verfuegbareelemente_listview))
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_aktiveelemente_listview,$Item_to_add)
_GUICtrlListView_SetItemSelected($einstellungen_toolbar_verfuegbareelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_verfuegbareelemente_listview),true,true)
EndFunc

func _Einstellungen_Toolbar_Eintrag_nach_unten()
	if _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview) = -1 then return
	if _GUICtrlListView_GetItemCount($einstellungen_toolbar_aktiveelemente_listview) = 0 then return
	_GUICtrlListView_MoveItems($einstellungen_toolbar_aktiveelemente_listview, 1)
	_GUICtrlListView_EnsureVisible($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview))
	_GUICtrlListView_SetItemSelected($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview), True, true)
endfunc

func _Einstellungen_Toolbar_Eintrag_nach_oben()
	if _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview) = -1 then return
	if _GUICtrlListView_GetItemCount($einstellungen_toolbar_aktiveelemente_listview) = 0 then return
	_GUICtrlListView_MoveItems( $einstellungen_toolbar_aktiveelemente_listview, -1)
	_GUICtrlListView_EnsureVisible($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview))
	_GUICtrlListView_SetItemSelected($einstellungen_toolbar_aktiveelemente_listview, _GUICtrlListView_GetSelectionMark($einstellungen_toolbar_aktiveelemente_listview), True, true)
endfunc

func _Einstellungen_Toolbar_Standard_wiederherstellen()
	$Toolbarlayout = $Toolbar_Standardlayout
	_Einstellungen_Toolbar_Lade_Verfuegbarliste()
	_Einstellungen_Toolbar_Lade_Elemente_aus_Layout()
EndFunc


func _Einstellungen_Toolbar_entferne_Eintrag_aus_verfuegbarliste($ID="")
if $ID = "#tbar_sep#" then Return
if $ID = "" then Return
for $y = 0 to _GUICtrlListView_GetItemCount($einstellungen_toolbar_verfuegbareelemente_listview)-1
if _GUICtrlListView_GetItemText($einstellungen_toolbar_verfuegbareelemente_listview,$y,1) = $ID then _GUICtrlListView_DeleteItem(GUICtrlGetHandle($einstellungen_toolbar_verfuegbareelemente_listview),$y)
next
EndFunc


func _Einstellungen_Toolbar_Lade_Elemente_aus_Layout()
_GUICtrlListView_BeginUpdate($einstellungen_toolbar_aktiveelemente_listview)
_GUICtrlListView_BeginUpdate($einstellungen_toolbar_verfuegbareelemente_listview)
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($einstellungen_toolbar_aktiveelemente_listview))

$Elemente_Array = StringSplit($Toolbarlayout,"|",2)
if not IsArray($Elemente_Array) then return
if @error then return
for $x = 0 to ubound($Elemente_Array)-1
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_aktiveelemente_listview,$Elemente_Array[$x])
_Einstellungen_Toolbar_entferne_Eintrag_aus_verfuegbarliste($Elemente_Array[$x])
next

_GUICtrlListView_endUpdate($einstellungen_toolbar_verfuegbareelemente_listview)
_GUICtrlListView_endUpdate($einstellungen_toolbar_aktiveelemente_listview)
EndFunc



func _Einstellungen_Toolbar_Lade_Verfuegbarliste()
_GUICtrlListView_BeginUpdate($einstellungen_toolbar_verfuegbareelemente_listview)
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($einstellungen_toolbar_verfuegbareelemente_listview))

;Erstelle alles was es so gibt :P
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_newfile#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_newfolder#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_importfile#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_importfolder#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_export#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_deletefile#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_refreshprojecttree#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_fullscreen#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_sep#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_testproject#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_compile#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_macros#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_projectproberties#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_save#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_saveall#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_closetab#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_undo#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_redo#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_testscript#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_stopproject#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_search#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_syntaxcheck#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_commentout#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_windowtool#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_macroslot1#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_macroslot2#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_macroslot3#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_macroslot4#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_macroslot5#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_macroslot6#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_macroslot7#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_changelogmanager#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_settings#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_colortoolbox#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_closeproject#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_plugin1#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_plugin2#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_plugin3#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_plugin4#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_plugin5#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_plugin6#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_plugin7#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_projectsettings#")
_Einstellungen_Toolbar_ItemID_zu_Listview($einstellungen_toolbar_verfuegbareelemente_listview,"#tbar_tidy#")

_GUICtrlListView_EndUpdate($einstellungen_toolbar_verfuegbareelemente_listview)
endfunc

func _AdvancedISNPlugin_get_name($Nummer=0)
if $Nummer = 0 then return ""
Local $pfad = Execute("$Tools_menu_pluginitem"&number($Nummer)&"_exe")
if $pfad = "" then return ""
$pfad = StringTrimRight($pfad,stringlen($pfad)-StringInStr($pfad,"\",0,-1))
if iniread($Pfad&"plugin.ini","plugin","active","0") = "0" then return "" ;Plugin muss aktiviert sein!
$Name = iniread($Pfad&"plugin.ini","plugin","toolsmenudescription",iniread($Pfad&"plugin.ini","plugin","name",_Get_langstr(962)))
return $Name
endfunc

func _AdvancedISNPlugin_get_Icon($Nummer=0)
if $Nummer = 0 then return ""
Local $pfad = Execute("$Tools_menu_pluginitem"&number($Nummer)&"_exe")
if $pfad = "" then return ""
$pfad = StringTrimRight($pfad,stringlen($pfad)-StringInStr($pfad,"\",0,-1))
$Ico = iniread($Pfad&"plugin.ini","plugin","toolsmenuiconid","193")
if StringInStr($Ico,".ico") Then $Ico = $pfad&$Ico
return $Ico
endfunc


func _Zeige_Skriptbaum_Einstellungen()
GUICtrlSetState($config_Sheet_Skriptbaum, $GUI_SHOW)
_Show_Configgui()

endfunc

func _Zeige_Skriptbaum_FilterGUI()
if $Offenes_Projekt = "" then
	msgbox(262144 + 48, _Get_langstr(394), _Get_langstr(966), 0, $config_gui)
	return
endif
$text = iniread($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "scripttreefilter", "")
GUICtrlSetData($skriuptbaum_FilterGUI_Edit,StringReplace($text,"|",@crlf))
GUISetState(@SW_SHOW,$skriuptbaum_FilterGUI)
guisetstate(@SW_DISABLE, $StudioFenster)
guisetstate(@SW_DISABLE, $config_GUI)
endfunc

func _Verstecke_Skriptbaum_FilterGUI()
guisetstate(@SW_ENABLE, $config_GUI)
guisetstate(@SW_ENABLE, $StudioFenster)
GUISetState(@SW_HIDE,$skriuptbaum_FilterGUI)
endfunc

func _Skriptbaum_FilterGUI_OK()
$Text = guictrlread($skriuptbaum_FilterGUI_Edit)
$Text = StringReplace($Text,@crlf,"|")
IniWrite($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "scripttreefilter", $Text)
$Skriptbaum_Filter_Array = StringSplit($Text,"|",2)
_Verstecke_Skriptbaum_FilterGUI()
if $Offenes_Projekt <> "" then AdlibRegister("_Build_Scripttree")
endfunc

func _Toggle_Skripteditor()
	if GuiCtrlRead($Checkbox_hidefunctionstree) = $GUI_UNCHECKED Then
		GUICtrlSetState($skriptbaum_config_checkbox_showforms, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showfunctions, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showincludes, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showlocalvariables, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showglobalvariables, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showregions, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandglobalvariables, $GUI_ENABLE)
		GUICtrlSetState($Checkbox_loadcontrols, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandforms, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandfunctions, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandregions, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandlocalvariables, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandincludes, $GUI_ENABLE)
		GUICtrlSetState($Skriptbaum_config_Filter_Button, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_alphabetisch, $GUI_ENABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_ENABLE)
	Else
		GUICtrlSetState($skriptbaum_config_checkbox_showforms, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showfunctions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showincludes, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showlocalvariables, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showglobalvariables, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_showregions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandglobalvariables, $GUI_DISABLE)
		GUICtrlSetState($Checkbox_loadcontrols, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandforms, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandfunctions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandregions, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandlocalvariables, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_expandincludes, $GUI_DISABLE)
		GUICtrlSetState($Skriptbaum_config_Filter_Button, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_alphabetisch, $GUI_DISABLE)
		GUICtrlSetState($skriptbaum_config_checkbox_bearbeitete_func_markieren, $GUI_DISABLE)
	endif
 endfunc

func _API_Pfade_abspeichern()
local $Fertiger_String = ""

;API Ordner
for $x = 0 To _GUICtrlListView_GetItemCount($Einstellungen_API_Listview)
   if _GUICtrlListView_GetItemText ($Einstellungen_API_Listview,$x) = "%isnstudiodir%\Data\Api" then ContinueLoop
   if _GUICtrlListView_GetItemText ($Einstellungen_API_Listview,$x) = "%myisndatadir%\Data\Api" then ContinueLoop
   if _GUICtrlListView_GetItemText ($Einstellungen_API_Listview,$x) = "" then ContinueLoop
   $Fertiger_String = $Fertiger_String&_GUICtrlListView_GetItemText ($Einstellungen_API_Listview,$x)&"|"
Next
if StringRight($Fertiger_String,1) = "|" then $Fertiger_String = StringTrimRight($Fertiger_String,1)
$Zusaetzliche_API_Ordner = $Fertiger_String
_Write_in_Config("additional_api_folders", $Fertiger_String)

;Properties Ordner
$Fertiger_String = ""
for $x = 0 To _GUICtrlListView_GetItemCount($Einstellungen_Properties_Listview)
   if _GUICtrlListView_GetItemText ($Einstellungen_Properties_Listview,$x) = "%isnstudiodir%\Data\Properties" then ContinueLoop
   if _GUICtrlListView_GetItemText ($Einstellungen_Properties_Listview,$x) = "%myisndatadir%\Data\Properties" then ContinueLoop
   if _GUICtrlListView_GetItemText ($Einstellungen_Properties_Listview,$x) = "" then ContinueLoop
   $Fertiger_String = $Fertiger_String&_GUICtrlListView_GetItemText ($Einstellungen_Properties_Listview,$x)&"|"
Next
if StringRight($Fertiger_String,1) = "|" then $Fertiger_String = StringTrimRight($Fertiger_String,1)
$Zusaetzliche_Properties_Ordner = $Fertiger_String
_Write_in_Config("additional_properties_folders", $Fertiger_String)
EndFunc






func _API_Pfade_in_Listview_Laden()
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Einstellungen_API_Listview))
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Einstellungen_Properties_Listview))
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projekteinstellungen_API_Listview))
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projekteinstellungen_Proberties_Listview))


_GUICtrlListView_BeginUpdate($Einstellungen_API_Listview)
_GUICtrlListView_BeginUpdate($Einstellungen_Properties_Listview)
_GUICtrlListView_BeginUpdate($Projekteinstellungen_API_Listview)
_GUICtrlListView_BeginUpdate($Projekteinstellungen_Proberties_Listview)


;Standard Einträge hinzufügen
_GUICtrlListView_AddItem($Einstellungen_API_Listview, "%isnstudiodir%\Data\Api", 0)
_GUICtrlListView_AddItem($Einstellungen_Properties_Listview, "%isnstudiodir%\Data\Properties", 0)
$item = _GUICtrlListView_AddItem($Projekteinstellungen_API_Listview, "%isnstudiodir%\Data\Api", 106)
 _GUICtrlListView_AddSubItem($Projekteinstellungen_API_Listview,$item, "1",1)
$item = _GUICtrlListView_AddItem($Projekteinstellungen_Proberties_Listview, "%isnstudiodir%\Data\Properties", 106)
 _GUICtrlListView_AddSubItem($Projekteinstellungen_Proberties_Listview,$item, "1",1)

if $Erstkonfiguration_Mode <> "portable" then ;Wird im portable mode nicht angezeigt (Da %myisndatadir% = %isnstudiodir% ist!)
_GUICtrlListView_AddItem($Einstellungen_API_Listview, "%myisndatadir%\Data\Api", 0)
_GUICtrlListView_AddItem($Einstellungen_Properties_Listview, "%myisndatadir%\Data\Properties", 0)
$item = _GUICtrlListView_AddItem($Projekteinstellungen_API_Listview, "%myisndatadir%\Data\Api", 106)
 _GUICtrlListView_AddSubItem($Projekteinstellungen_API_Listview,$item, "1",1)
$item = _GUICtrlListView_AddItem($Projekteinstellungen_Proberties_Listview, "%myisndatadir%\Data\Properties", 106)
 _GUICtrlListView_AddSubItem($Projekteinstellungen_Proberties_Listview,$item, "1",1)
endif

;Benutzerdefinierte Einträge hinzufügen
if $Zusaetzliche_API_Ordner <> "" Then
   $Orner_Array = StringSplit($Zusaetzliche_API_Ordner,"|",2)
   if IsArray($Orner_Array) Then
	  for $index = 0 to ubound($Orner_Array)-1
		 if $Orner_Array[$index] = "" then ContinueLoop
		 if $Orner_Array[$index] = "%isnstudiodir%\Data\Api" then ContinueLoop
		 if $Orner_Array[$index] = "%myisndatadir%\Data\Api" then ContinueLoop
		 _GUICtrlListView_AddItem($Einstellungen_API_Listview, $Orner_Array[$index], 0)
		 $item = _GUICtrlListView_AddItem($Projekteinstellungen_API_Listview, $Orner_Array[$index], 106)
		  _GUICtrlListView_AddSubItem($Projekteinstellungen_API_Listview,$item, "1",1)
	  Next
   Endif
EndIf


if $Zusaetzliche_Properties_Ordner <> "" Then
   $Orner_Array = StringSplit($Zusaetzliche_Properties_Ordner,"|",2)
   if IsArray($Orner_Array) Then
	  for $index = 0 to ubound($Orner_Array)-1
		 if $Orner_Array[$index] = "" then ContinueLoop
		 if $Orner_Array[$index] = "%isnstudiodir%\Data\Properties" then ContinueLoop
		 if $Orner_Array[$index] = "%myisndatadir%\Data\Properties" then ContinueLoop
		 _GUICtrlListView_AddItem($Einstellungen_Properties_Listview, $Orner_Array[$index], 0)
		 $item = _GUICtrlListView_AddItem($Projekteinstellungen_Proberties_Listview, $Orner_Array[$index], 106)
		  _GUICtrlListView_AddSubItem($Projekteinstellungen_Proberties_Listview,$item, "1",1)
	  Next
   Endif
EndIf

_GUICtrlListView_EndUpdate($Einstellungen_API_Listview)
_GUICtrlListView_EndUpdate($Einstellungen_Properties_Listview)
_GUICtrlListView_EndUpdate($Projekteinstellungen_API_Listview)
_GUICtrlListView_EndUpdate($Projekteinstellungen_Proberties_Listview)
endfunc

func _Einstellungen_API_Pfad_entfernen()
if _GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview) = -1 then return
if _GUICtrlListView_GetItemText($Einstellungen_API_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview),0) = "%isnstudiodir%\Data\Api" OR _GUICtrlListView_GetItemText($Einstellungen_API_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview),0) = "%myisndatadir%\Data\Api" Then
   msgbox(262144 + 16, _Get_langstr(25), _Get_langstr(1124), 0, $Config_GUI)
   Return
EndIf
_GUICtrlListView_DeleteItem($Einstellungen_API_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview))
_GUICtrlListView_SetItemSelected ($Einstellungen_API_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_API_Listview),True ,True)
EndFunc

func _Einstellungen_Properties_Pfad_entfernen()
if _GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview) = -1 then return
if _GUICtrlListView_GetItemText($Einstellungen_Properties_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview),0) = "%isnstudiodir%\Data\Properties" OR _GUICtrlListView_GetItemText($Einstellungen_Properties_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview),0) = "%myisndatadir%\Data\Properties" Then
   msgbox(262144 + 16, _Get_langstr(25), _Get_langstr(1124), 0, $Config_GUI)
   Return
EndIf
_GUICtrlListView_DeleteItem($Einstellungen_Properties_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview))
_GUICtrlListView_SetItemSelected ($Einstellungen_Properties_Listview,_GUICtrlListView_GetSelectionMark($Einstellungen_Properties_Listview),True ,True)
EndFunc


Func _Choose_projectfolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Input_Projekte_Pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_projectfolder

Func _Choose_backupfolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Input_Backup_Pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_backupfolder

Func _Choose_releasefolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Input_Release_Pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_releasefolder

Func _Choose_Templatefolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Input_template_Pfad, _ISN_Pfad_durch_Variablen_ersetzen($var))
EndFunc   ;==>_Choose_Templatefolder

Func _Choose_pluginfolder()
	$var = _WinAPI_BrowseForFolderDlg("", _Get_langstr(298), $BIF_RETURNONLYFSDIRS+$BIF_NEWDIALOGSTYLE, 0, 0, $Config_GUI)
	FileChangeDir(@ScriptDir)
	If $var = "" Then Return
	GUICtrlSetData($Einstellungen_Pfade_Pluginpfad_input, _ISN_Pfad_durch_Variablen_ersetzen($var))
 EndFunc   ;==>_Choose_pluginfolder

func _Einstellungen_Properties_Pfad_hinzufuegen()
$Ordnerpfad = FileSelectFolder (_Get_langstr(298),"",7,"",$Config_GUI)
if $Ordnerpfad = "" OR @error then Return
FileChangeDir(@ScriptDir)
if not _IsDir($Ordnerpfad) then return
if _WinAPI_PathIsRoot($Ordnerpfad) then return
if _GUICtrlListView_FindText ($Einstellungen_Properties_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad,1),-1) = -1 then _GUICtrlListView_AddItem($Einstellungen_Properties_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad,1), 0)
EndFunc

func _Einstellungen_API_Pfad_hinzufuegen()
$Ordnerpfad = FileSelectFolder (_Get_langstr(298),"",7,"",$Config_GUI)
if $Ordnerpfad = "" OR @error then Return
FileChangeDir(@ScriptDir)
if not _IsDir($Ordnerpfad) then return
if _WinAPI_PathIsRoot($Ordnerpfad) then return
if _GUICtrlListView_FindText ($Einstellungen_API_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad,1),-1) = -1 then _GUICtrlListView_AddItem($Einstellungen_API_Listview, _ISN_Pfad_durch_Variablen_ersetzen($Ordnerpfad,1), 0)
EndFunc

func _Programmeinstellungen_Farben_Weitere_Einstellungen_GUI_Toggle()
   if BitAND(WinGetState($programmeinstellungen_weiter_farbeinstellungen_GUI), 2) Then
	  GUISetState(@SW_ENABLE,$config_GUI)
	  GUISetState(@SW_HIDE,$programmeinstellungen_weiter_farbeinstellungen_GUI)
   Else
	  GUISetState(@SW_SHOW,$programmeinstellungen_weiter_farbeinstellungen_GUI)
	  GUISetState(@SW_DISABLE,$config_GUI)
   EndIf


endfunc

func _Farbeinstellungen_Exportieren()
	$line = FileSaveDialog(_Get_langstr(1143), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Hotkeys (*.ini)", 18, "ISN AutoIt Studio Color settings.ini", $Config_GUI)
	if $line = "" then Return
	if @Error > 0 then return
	FileChangeDir(@scriptdir)

    _Save_Settings()
	IniWrite($line,"config","scripteditor_font",$scripteditor_font)
	IniWrite($line,"config","scripteditor_size",$scripteditor_size)
	IniWrite($line,"config","scripteditor_bgcolour",$scripteditor_bgcolour)
	IniWrite($line,"config","scripteditor_rowcolour",$scripteditor_rowcolour)
	IniWrite($line,"config","scripteditor_marccolour",$scripteditor_marccolour)
	IniWrite($line,"config","scripteditor_caretcolour",$scripteditor_caretcolour)
	IniWrite($line,"config","scripteditor_caretwidth",$scripteditor_caretwidth)
	IniWrite($line,"config","scripteditor_caretstyle",$scripteditor_caretstyle)
	IniWrite($line,"config","scripteditor_highlightcolour",$scripteditor_highlightcolour)
	IniWrite($line,"config","scripteditor_errorcolour",$scripteditor_errorcolour)
	IniWrite($line,"config","use_new_au3_colours",$use_new_au3_colours)
	IniWrite($line,"config","scripteditor_backgroundcolour_forall",$hintergrundfarbe_fuer_alle_uebernehmen)

	IniWrite($line,"config","AU3_DEFAULT_STYLE1",$SCE_AU3_STYLE1a)
	IniWrite($line,"config","AU3_COMMENT_STYLE1",$SCE_AU3_STYLE2a)
	IniWrite($line,"config","AU3_COMMENTBLOCK_STYLE1",$SCE_AU3_STYLE3a)
	IniWrite($line,"config","AU3_NUMBER_STYLE1",$SCE_AU3_STYLE4a)
	IniWrite($line,"config","AU3_FUNCTION_STYLE1",$SCE_AU3_STYLE5a)
	IniWrite($line,"config","AU3_KEYWORD_STYLE1",$SCE_AU3_STYLE6a)
	IniWrite($line,"config","AU3_MACRO_STYLE1",$SCE_AU3_STYLE7a)
	IniWrite($line,"config","AU3_STRING_STYLE1",$SCE_AU3_STYLE8a)
	IniWrite($line,"config","AU3_OPERATOR_STYLE1",$SCE_AU3_STYLE9a)
	IniWrite($line,"config","AU3_VARIABLE_STYLE1",$SCE_AU3_STYLE10a)
	IniWrite($line,"config","AU3_SENT_STYLE1",$SCE_AU3_STYLE11a)
	IniWrite($line,"config","AU3_PREPROCESSOR_STYLE1",$SCE_AU3_STYLE12a)
	IniWrite($line,"config","AU3_SPECIAL_STYLE1",$SCE_AU3_STYLE13a)
	IniWrite($line,"config","AU3_EXPAND_STYLE1",$SCE_AU3_STYLE14a)
	IniWrite($line,"config","AU3_COMOBJ_STYLE1",$SCE_AU3_STYLE15a)
	IniWrite($line,"config","AU3_UDF_STYLE1",$SCE_AU3_STYLE16a)

	IniWrite($line,"config","AU3_DEFAULT_STYLE2",$SCE_AU3_STYLE1b)
	IniWrite($line,"config","AU3_COMMENT_STYLE2",$SCE_AU3_STYLE2b)
	IniWrite($line,"config","AU3_COMMENTBLOCK_STYLE2",$SCE_AU3_STYLE3b)
	IniWrite($line,"config","AU3_NUMBER_STYLE2",$SCE_AU3_STYLE4b)
	IniWrite($line,"config","AU3_FUNCTION_STYLE2",$SCE_AU3_STYLE5b)
	IniWrite($line,"config","AU3_KEYWORD_STYLE2",$SCE_AU3_STYLE6b)
	IniWrite($line,"config","AU3_MACRO_STYLE2",$SCE_AU3_STYLE7b)
	IniWrite($line,"config","AU3_STRING_STYLE2",$SCE_AU3_STYLE8b)
	IniWrite($line,"config","AU3_OPERATOR_STYLE2",$SCE_AU3_STYLE9b)
	IniWrite($line,"config","AU3_VARIABLE_STYLE2",$SCE_AU3_STYLE10b)
	IniWrite($line,"config","AU3_SENT_STYLE2",$SCE_AU3_STYLE11b)
	IniWrite($line,"config","AU3_PREPROCESSOR_STYLE2",$SCE_AU3_STYLE12b)
	IniWrite($line,"config","AU3_SPECIAL_STYLE2",$SCE_AU3_STYLE13b)
	IniWrite($line,"config","AU3_EXPAND_STYLE2",$SCE_AU3_STYLE14b)
	IniWrite($line,"config","AU3_COMOBJ_STYLE2",$SCE_AU3_STYLE15b)
	IniWrite($line,"config","AU3_UDF_STYLE2",$SCE_AU3_STYLE16b)

    _Show_Configgui()
	msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $config_gui)

EndFunc


func _Farbeinstellungen_Importieren()

    $res = msgbox(262144 + 32 +4, _Get_langstr(48), _Get_langstr(1145), 0, $config_gui)
	If @error Then return
	If $res <> 6 Then return


	$var = FileOpenDialog(_Get_langstr(1144), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio configuration file (*.ini)", 1 + 2 + 4, "",  $config_gui)
	FileChangeDir(@scriptdir)
	if $var = "" then return
	If @error Then return

    _Save_Settings()
	$sections = IniReadSectionNames($var)
	if @error then return
	if not _ArraySearch($sections,"config") then return
	for $x = 1 to $sections[0]
		$Werte_der_Section = IniReadSection($var, $sections[$x])
		for $y = 1 to $Werte_der_Section[0][0]
			iniwrite($Configfile,$sections[$x],$Werte_der_Section[$y][0],$Werte_der_Section[$y][1])
		next
	 next

   $scripteditor_font = _Config_Read("scripteditor_font", "Courier New")
$scripteditor_size = _Config_Read("scripteditor_size", "10")
$scripteditor_bgcolour = _Config_Read("scripteditor_bgcolour", "0xFFFFFF")
$scripteditor_rowcolour = _Config_Read("scripteditor_rowcolour", "0xFFFED8")
$scripteditor_marccolour = _Config_Read("scripteditor_marccolour", "0x3289D0")
$scripteditor_caretcolour = _Config_Read("scripteditor_caretcolour", "0x000000")
$scripteditor_caretwidth = _Config_Read("scripteditor_caretwidth", "1")
$scripteditor_caretstyle = _Config_Read("scripteditor_caretstyle", "1")
$scripteditor_highlightcolour = _Config_Read("scripteditor_highlightcolour", "0xFF0000")
$scripteditor_errorcolour = _Config_Read("scripteditor_errorcolour", "0xFEBDBD")
$use_new_au3_colours = _Config_Read("use_new_au3_colours", "false")
$hintergrundfarbe_fuer_alle_uebernehmen = _Config_Read("scripteditor_backgroundcolour_forall", "true")
$SCE_AU3_STYLE1a = _Config_Read("AU3_DEFAULT_STYLE1", "0x000000|0xFFFFFF|0|0|0")
$SCE_AU3_STYLE2a = _Config_Read("AU3_COMMENT_STYLE1", "0x339900|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE3a = _Config_Read("AU3_COMMENTBLOCK_STYLE1", "0x009966|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE4a = _Config_Read("AU3_NUMBER_STYLE1", "0xA900AC|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE5a = _Config_Read("AU3_FUNCTION_STYLE1", "0xAA0000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE6a = _Config_Read("AU3_KEYWORD_STYLE1", "0xFF0000|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE7a = _Config_Read("AU3_MACRO_STYLE1", "0xFF33FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE8a = _Config_Read("AU3_STRING_STYLE1", "0xCC9999|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE9a = _Config_Read("AU3_OPERATOR_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE10a = _Config_Read("AU3_VARIABLE_STYLE1", "0x000090|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE11a = _Config_Read("AU3_SENT_STYLE1", "0x0080FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE12a = _Config_Read("AU3_PREPROCESSOR_STYLE1", "0xFF00F0|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE13a = _Config_Read("AU3_SPECIAL_STYLE1", "0xF00FA0|0xFFFFFF|0|1|0")
$SCE_AU3_STYLE14a = _Config_Read("AU3_EXPAND_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
$SCE_AU3_STYLE15a = _Config_Read("AU3_COMOBJ_STYLE1", "0xFF0000|0xFFFFFF|1|1|0")
$SCE_AU3_STYLE16a = _Config_Read("AU3_UDF_STYLE1", "0xFF8000|0xFFFFFF|0|1|0")
_Show_Configgui()
msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(591), 0, $config_gui)
EndFunc

func _Darstellung_bewege_DPI_Slider()
GUICtrlSetData($programmeinstellungen_DPI_Slider_Label,GUICtrlRead($programmeinstellungen_DPI_Slider)&" %")
EndFunc

func _Studiofensterposition_speichern()
   If BitAND(WinGetState($Studiofenster, ""), 16) Then return ;Nichts unternehmen wenn Minimiert
   $Studiofenster_pos_array = WinGetPos($Studiofenster)
   $Studiofenster_clientsize_array = WinGetClientSize($Studiofenster)
   if not IsArray($Studiofenster_pos_array) then return
   if not IsArray($Studiofenster_clientsize_array) then return
   _Write_in_Config("studio_x", $Studiofenster_pos_array[0])
   _Write_in_Config("studio_y", $Studiofenster_pos_array[1])
   _Write_in_Config("studio_width", $Studiofenster_clientsize_array[0])
   _Write_in_Config("studio_height", $Studiofenster_clientsize_array[1]+_GUICtrlStatusBar_GetHeight($Studiofenster)+_WinAPI_GetSystemMetrics($SM_CYMENU))
	If BitAND(WinGetState($Studiofenster, ""), 32 ) Then
   _Write_in_Config("studio_maximized", "true")
   else
   _Write_in_Config("studio_maximized", "false")
   endif
endfunc

func _Programmeinstellungen_Tools_Checkbox_event()


if guictrlread($setting_tools_obfuscator_enabled_checkbox) = $GUI_Checked then
	GUICtrlSetState($settings_pelock_key_input,$GUI_ENABLE)
	GUICtrlSetState($settings_pelock_check_key_button,$GUI_ENABLE)
	GUICtrlSetState($settings_pelock_buy_key_button,$GUI_ENABLE)
	GUICtrlSetState($settings_pelock_key_label,$GUI_ENABLE)
	GUICtrlSetState($settings_pelock_keyinfo_label,$GUI_ENABLE)
Else
    GUICtrlSetState($settings_pelock_key_input,$GUI_DISABLE)
	GUICtrlSetState($settings_pelock_check_key_button,$GUI_DISABLE)
	GUICtrlSetState($settings_pelock_buy_key_button,$GUI_DISABLE)
	GUICtrlSetState($settings_pelock_key_label,$GUI_DISABLE)
	GUICtrlSetState($settings_pelock_keyinfo_label,$GUI_DISABLE)
 endif


if guictrlread($setting_tools_parametereditor_enabled_checkbox) = $GUI_Checked then
	GUICtrlSetState($Checkbox_Settings_Auto_ParameterEditor,$GUI_ENABLE)

Else
    GUICtrlSetState($Checkbox_Settings_Auto_ParameterEditor,$GUI_DISABLE)
 endif

EndFunc



func _Import_ICP_Plugin_CMD($Path="")
		_Fadeout_logo()
		GUICtrlSetState($config_Sheet_Plugins, $GUI_SHOW)
	    _Show_Configgui()
		_Try_to_import_ICP_Plugin($Path)
EndFunc


func _Try_to_import_ICP_Plugin($Path="")
   if $Path = "" then return
   local $randomid = random(1,2000,1)

 _show_Loading(_Get_langstr(475),_Get_langstr(23))
 DirCreate($Arbeitsverzeichnis& "\data\Cache\import"&$randomid)
 GUISetState(@SW_disable,$config_gui)


_Loading_Progress(100)

$CurZipSize = 0
_UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "_UnZIP_ServiceFunc")
_UnZIP_SetOptions()
if _UnZIP_Unzip($Path,$Arbeitsverzeichnis & "\data\Cache\import"&$randomid) <> 1 Then
   DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
   _import_ICP_Plugin_Fehler(1)
   return
Endif

$search = FileFindFirstFile($Arbeitsverzeichnis& "\data\Cache\import"&$randomid&"\*.*")
$pluginfolder = FileFindNextFile($search)
$pathtopluginini = $Arbeitsverzeichnis& "\data\Cache\import"&$randomid&"\"&$pluginfolder&"\plugin.ini"
if not FileExists($pathtopluginini) then
   DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
   _import_ICP_Plugin_Fehler(2)
   return
Endif
IniReadSection($pathtopluginini, "plugin")
if @error Then
   DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
   _import_ICP_Plugin_Fehler(3)
   return
EndIf

_Hide_Loading()
$result = msgbox(262144+32+4,_Get_langstr(48),_Get_langstr(1321)&@crlf&@crlf&_Get_langstr(142)&" "& _
iniread($pathtopluginini,"plugin","name","")&@crlf& _
_Get_langstr(131)&" "&iniread($pathtopluginini,"plugin","version","")&@crlf& _
_Get_langstr(132)&" "&iniread($pathtopluginini,"plugin","author","")&@crlf& _
_Get_langstr(133)&" "&iniread($pathtopluginini,"ISNAUTOITSTUDIO","comment","")&@crlf&@crlf&_Get_langstr(1322),0,$config_gui)
if @error or $result = 7 Then
   DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
   _GUICtrlStatusBar_SetText ($Status_bar, "")
   GUISetState(@SW_ENABLE,$config_gui)
   return
EndIf
if $result = 6 Then

	;Check if the plugin already exists...
	if FileExists(_ISN_Variablen_aufloesen($Pluginsdir&"\"&$pluginfolder)) Then
	$exists_result = msgbox(262144+48+4,_Get_langstr(394),StringReplace(_Get_langstr(1334),"%1",iniread($pathtopluginini,"plugin","name","")),0,$config_gui)
	if $exists_result = 6 Then
	DirRemove(_ISN_Variablen_aufloesen($Pluginsdir&"\"&$pluginfolder),1)
	Else
	DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
   _GUICtrlStatusBar_SetText ($Status_bar, "")
   GUISetState(@SW_ENABLE,$config_gui)
   return
	Endif
	EndIf

	  if DirMove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid&"\"&$pluginfolder,_ISN_Variablen_aufloesen($Pluginsdir),1) <> 1 Then
		 msgbox(262144+16,_Get_langstr(25),_Get_langstr(1324),0,$config_gui)
		 _GUICtrlStatusBar_SetText ($Status_bar, "")
		 GUISetState(@SW_ENABLE,$config_gui)
		 RETURN
	  EndIf

	  $result2 = msgbox(262144+32+4,_Get_langstr(48),_Get_langstr(1323),0,$config_gui)
	  if $result2 = 6 Then _ISN_Plugin_aktivieren($pluginfolder)
	  DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
	   _List_Plugins()
	   _load_plugindetails()
	  _GUICtrlStatusBar_SetText ($Status_bar, "")
	  GUISetState(@SW_ENABLE,$config_gui)
endif
endfunc

func _import_ICP_Plugin_Fehler($errorcode = 0)
   msgbox(262144+16,_Get_langstr(25),_Get_langstr(476)&@crlf&@crlf&"Errorcode "&$errorcode,0,$config_gui)
   _load_plugindetails()
   _GUICtrlStatusBar_SetText ($Status_bar, "")
   GUISetState(@SW_ENABLE,$config_gui)
endfunc

Func _ICP_zum_Import_waehlen()
	$var = FileOpenDialog(_Get_langstr(1315), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", _Get_langstr(1319)&" (*.icp)", 3, "", $Config_GUI)
	If @error Then return
	_Try_to_import_ICP_Plugin($var)
 EndFunc

