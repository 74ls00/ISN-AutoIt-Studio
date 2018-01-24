;----------------------------------------------
;Addons.au3 for ISN Form Studio by ISI360
;----------------------------------------------
;  _MouseTrap help :D
;links,oben, rechts oben, links unten

;----------------------------------------------
;FUNCS
;----------------------------------------------

Func _ISN_Variablen_aufloesen($String = "")
	If $String = "" Then Return ""
	Return _ISNPlugin_Resolve_ISN_AutoIt_Studio_Variable($String)
EndFunc   ;==>_ISN_Variablen_aufloesen


Func _Toggle_Lock_Control()


	If $Control_Markiert_MULTI = 0 Then

		If $Control_Markiert = 0 Then Return
		$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
		If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
		$Locked_Status = _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0)
		If $Locked_Status = 0 Then
			If $Markiertes_Control_ID = $TABCONTROL_ID Then
				_IniWriteEx($Cache_Datei_Handle, "tab", "locked", 1)
			Else
				_IniWriteEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "locked", 1)
			EndIf
			GUICtrlSetImage($Resize_Oben_Links, @ScriptDir & "\Data\Punkt_locked.jpg")
			GUICtrlSetImage($Resize_Oben_Mitte, @ScriptDir & "\Data\Punkt_locked.jpg")
			GUICtrlSetImage($Resize_Oben_Rechts, @ScriptDir & "\Data\Punkt_locked.jpg")
			GUICtrlSetImage($Resize_Unten_Links, @ScriptDir & "\Data\Punkt_locked.jpg")
			GUICtrlSetImage($Resize_Unten_Mitte, @ScriptDir & "\Data\Punkt_locked.jpg")
			GUICtrlSetImage($Resize_Unten_Rechts, @ScriptDir & "\Data\Punkt_locked.jpg")
			GUICtrlSetImage($Resize_Links_Mitte, @ScriptDir & "\Data\Punkt_locked.jpg")
			GUICtrlSetImage($Resize_Rechts_Mitte, @ScriptDir & "\Data\Punkt_locked.jpg")
			If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
				_SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1816 + 1, 16, 16)
			Else
				Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1816, 4)
			EndIf

		Else
			If $Markiertes_Control_ID = $TABCONTROL_ID Then
				_IniWriteEx($Cache_Datei_Handle, "tab", "locked", 0)
			Else
				_IniWriteEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "locked", 0)
			EndIf
			GUICtrlSetImage($Resize_Oben_Links, @ScriptDir & "\Data\Punkt.jpg")
			GUICtrlSetImage($Resize_Oben_Mitte, @ScriptDir & "\Data\Punkt.jpg")
			GUICtrlSetImage($Resize_Oben_Rechts, @ScriptDir & "\Data\Punkt.jpg")
			GUICtrlSetImage($Resize_Unten_Links, @ScriptDir & "\Data\Punkt.jpg")
			GUICtrlSetImage($Resize_Unten_Mitte, @ScriptDir & "\Data\Punkt.jpg")
			GUICtrlSetImage($Resize_Unten_Rechts, @ScriptDir & "\Data\Punkt.jpg")
			GUICtrlSetImage($Resize_Links_Mitte, @ScriptDir & "\Data\Punkt.jpg")
			GUICtrlSetImage($Resize_Rechts_Mitte, @ScriptDir & "\Data\Punkt.jpg")
			If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
				GUICtrlSetState($MiniEditor_lock_Button, $GUI_DISABLE)
				_SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1828 + 1, 16, 16)
				GUICtrlSetState($MiniEditor_lock_Button, $GUI_ENABLE)
			Else
				Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1828, 4)
			EndIf
		EndIf

	Else
		If Not IsArray($Markierte_Controls_IDs) Then Return
		If Not IsArray($Markierte_Controls_Sections) Then Return
		If $Control_Lock_Status_Multi = "" Then $Control_Lock_Status_Multi = 0 ;Wenn verschieden, dann aktivieren

		For $u = 0 To $Markierte_Controls_IDs[0] - 1
			If $Markierte_Controls_Sections[$u] = "" Then ContinueLoop


			If $Control_Lock_Status_Multi = 0 Then
				;Lock für control aktivieren
				_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "locked", "1")
				GUICtrlSetImage($Resize_Oben_Links_Multi[$u], @ScriptDir & "\Data\Punkt_locked.jpg")
				GUICtrlSetImage($Resize_Oben_Mitte_Multi[$u], @ScriptDir & "\Data\Punkt_locked.jpg")
				GUICtrlSetImage($Resize_Oben_Rechts_Multi[$u], @ScriptDir & "\Data\Punkt_locked.jpg")
				GUICtrlSetImage($Resize_Unten_Rechts_Multi[$u], @ScriptDir & "\Data\Punkt_locked.jpg")
				GUICtrlSetImage($Resize_Unten_Mitte_Multi[$u], @ScriptDir & "\Data\Punkt_locked.jpg")
				GUICtrlSetImage($Resize_Unten_Links_Multi[$u], @ScriptDir & "\Data\Punkt_locked.jpg")
				GUICtrlSetImage($Resize_Links_Mitte_Multi[$u], @ScriptDir & "\Data\Punkt_locked.jpg")
				GUICtrlSetImage($Resize_Rechts_Mitte_Multi[$u], @ScriptDir & "\Data\Punkt_locked.jpg")

			Else
				;Lock für control deaktivieren
				_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "locked", "0")
				GUICtrlSetImage($Resize_Oben_Links_Multi[$u], @ScriptDir & "\Data\Punkt.jpg")
				GUICtrlSetImage($Resize_Oben_Mitte_Multi[$u], @ScriptDir & "\Data\Punkt.jpg")
				GUICtrlSetImage($Resize_Oben_Rechts_Multi[$u], @ScriptDir & "\Data\Punkt.jpg")
				GUICtrlSetImage($Resize_Unten_Rechts_Multi[$u], @ScriptDir & "\Data\Punkt.jpg")
				GUICtrlSetImage($Resize_Unten_Mitte_Multi[$u], @ScriptDir & "\Data\Punkt.jpg")
				GUICtrlSetImage($Resize_Unten_Links_Multi[$u], @ScriptDir & "\Data\Punkt.jpg")
				GUICtrlSetImage($Resize_Links_Mitte_Multi[$u], @ScriptDir & "\Data\Punkt.jpg")
				GUICtrlSetImage($Resize_Rechts_Mitte_Multi[$u], @ScriptDir & "\Data\Punkt.jpg")

			EndIf


		Next

		;Setzte Button Status
		If $Control_Lock_Status_Multi = 0 Then
			$Control_Lock_Status_Multi = 1
			If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
				_SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1816 + 1, 16, 16)
			Else
				Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1816, 4)
			EndIf
		Else
			$Control_Lock_Status_Multi = 0
			If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
			   GUICtrlSetState($MiniEditor_lock_Button, $GUI_DISABLE)
				_SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1828 + 1, 16, 16)
				GUICtrlSetState($MiniEditor_lock_Button, $GUI_ENABLE)
			Else
				Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1828, 4)
			EndIf
		EndIf


	EndIf
EndFunc   ;==>_Toggle_Lock_Control

Func _ist_windows_vista_oder_hoeher()
	Switch @OSVersion
		Case "WIN_2000", "WIN_2003", "WIN_XP", "WIN_XPe", "WIN_2003"
			Return 0

	EndSwitch
	Return 1
EndFunc   ;==>_ist_windows_vista_oder_hoeher

Func _ist_windows_8_oder_hoeher()
	Switch @OSVersion
		Case "WIN_2000", "WIN_2003", "WIN_XP", "WIN_XPe", "WIN_VISTA", "WIN_7", "WIN_2003", "WIN_2008"
			Return 0

	EndSwitch
	Return 1
EndFunc   ;==>_ist_windows_8_oder_hoeher

func _Control_Add_ToolTip($Handle,$text)
  _GUIToolTip_AddTool($hToolTip, 0, $text, GUICtrlGetHandle($Handle))
EndFunc


Func Markiere_Controls_EDIT($cntrl = "")
	If $cntrl = "" Then Return
	If $BGimage = $cntrl Then
		Entferne_Makierung()
		Return
	EndIf

	If $Grid_Handle = $cntrl Then
		Entferne_Makierung()
		Return
	EndIf

	If $cntrl = $Markiertes_Control_ID Then Return


	Markiere_Control($cntrl)

EndFunc   ;==>Markiere_Controls_EDIT

Func _resize_elements()
	If Not IsDeclared("studiofenster_inside") Then Return
	If Not IsDeclared("studiofenster") Then Return
	If Not IsDeclared("blue_1") Then Return
	$winpos = WinGetPos($StudioFenster_inside)
	$Groesse_studioFenster = WinGetClientSize($StudioFenster)
	$Groesse_studioFenster_inside = WinGetClientSize($StudioFenster_inside)
	$WinSize = WinGetClientSize($StudioFenster)
	$winpos = WinGetPos($StudioFenster)
	$pos_bluecontrol = ControlGetPos($StudioFenster, "", $blue_1)
	If IsArray($Groesse_studioFenster_inside) Then
		If IsArray($pos_bluecontrol) And IsArray($WinSize) And IsArray($WinSize) Then
			If _ist_windows_8_oder_hoeher() Then
				WinMove($StudioFenster_inside, "", ($pos_bluecontrol[0] + $pos_bluecontrol[2]) + 2, ($winpos[3] - $WinSize[1]) - 2, $WinSize[0] - ($pos_bluecontrol[0] + $pos_bluecontrol[2]), $WinSize[1])
			Else
				WinMove($StudioFenster_inside, "", $winpos[0] + ($pos_bluecontrol[0] + $pos_bluecontrol[2]) + 2, $winpos[1] + ($winpos[3] - $WinSize[1]) - 2, $WinSize[0] - ($pos_bluecontrol[0] + $pos_bluecontrol[2]), $WinSize[1])
			EndIf
			If $Logo <> "" Then GUICtrlSetPos($Logo, 180 * $DPI, $WinSize[1] - 100)
		EndIf
		$Groesse_studioFenster_inside = WinGetClientSize($StudioFenster_inside)
		If IsDeclared("background_pic") Then GUICtrlSetPos($background_pic, 174*$DPI, 0, $Groesse_studioFenster[0] - 100, $Groesse_studioFenster[1])
		If IsDeclared("StudioFenster_inside_load") Then GUICtrlSetPos($StudioFenster_inside_load, ($Groesse_studioFenster_inside[0] / 2) - (283 / 2), ($Groesse_studioFenster_inside[1] / 2) - 10, 283, 20)
		If IsDeclared("StudioFenster_inside_Text1") Then GUICtrlSetPos($StudioFenster_inside_Text1, ($Groesse_studioFenster_inside[0] / 2) - (283 / 2) + 40, ($Groesse_studioFenster_inside[1] / 2) - 40)
		If IsDeclared("StudioFenster_inside_Text2") Then GUICtrlSetPos($StudioFenster_inside_Text2, 0, ($Groesse_studioFenster_inside[1] / 2) + 14, $Groesse_studioFenster_inside[0])
		If IsDeclared("StudioFenster_inside_Icon") Then GUICtrlSetPos($StudioFenster_inside_Icon, ($Groesse_studioFenster_inside[0] / 2) - (283 / 2), ($Groesse_studioFenster_inside[1] / 2) - 45)
		If IsDeclared("Formstudio_controleditor_GUI") Then _WinAPI_SetWindowPos($Formstudio_controleditor_GUI, $HWND_TOP, $winpos[2] - 357, 10, 200, 200, $SWP_NOSIZE)
	EndIf
EndFunc   ;==>_resize_elements


Func _waehle_parentgui()
	_ISNPlugin_Nachricht_senden("listguis")
	GUISetState(@SW_DISABLE, $Form_bearbeitenGUI)
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "listfuncsok", 90000000)
	GUISetState(@SW_ENABLE, $Form_bearbeitenGUI)
	$data = _Pluginstring_get_element($Nachricht, 2)
	If $data = "" Then Return
	If $data = GUICtrlRead($Form_bearbeitenparentHandle) Then Return
	GUICtrlSetData($Form_bearbeitenparentHandle, $data)
EndFunc   ;==>_waehle_parentgui



Func _Pruefe_Ob_Control_an_anderes_andockt_resize($Bewegtes_control = "")
	If _GUICtrlListView_GetItemCount($controllist) = 0 Then Return
	If $Show_docklines <> "1" Then Return
	If $Bewegtes_control = "" Then Return
	If $Control_Markiert_MULTI = 1 Then Return
	$ctrl_pos = ControlGetPos($GUI_Editor, "", $Bewegtes_control)
	If Not IsArray($ctrl_pos) Then Return

	$found_x_links = 0
	$found_x_rechts = 0
	$found_y_oben = 0
	$found_y_unten = 0

	$Clientsize = WinGetClientSize($GUI_Editor)
	$winpos = WinGetPos($GUI_Editor)
	$Windiff_x = ($winpos[2] - $Clientsize[0]) / 2
	$Windiff_y = ($winpos[3] - $Clientsize[1]) / 2

	For $x = 0 To UBound($Positionsarray_aller_Controls) - 1
		If $Positionsarray_aller_Controls[$x][0] = $Bewegtes_control Then ContinueLoop ;Mich selbst nicht miteinbeziehen
		$Pos_M = MouseGetPos()




		If (_ExRound_always($ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1], $Dock_Bewegungsraster)) Or (_ExRound_always($ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $Dock_Bewegungsraster)) Then ;X links

			If _ExRound_always($ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_X_links, $Positionsarray_aller_Controls[$x][1], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $Positionsarray_aller_Controls[$x][1], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			If _ExRound_always($ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_X_links, $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			$found_x_links = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Bewegtes_control))
			$Maus_Differenz_x = Abs((($Pos_M[0] - $Windiff_x) - $ctrl_pos[0]))
			$Maus_Differenz_x = Abs($Maus_Differenz_x - ($Windiff_x))
			If $Maus_Differenz_x > ($Dock_Bewegungsraster * 2) Then
				$found_x_links = 0
			Else
				GUICtrlSetBkColor($Docklabel_X_links, $Farbe_Dockstrich)
				GUICtrlSetState($Docklabel_X_links, $GUI_SHOW)
			EndIf
		EndIf




		If _ExRound_always($ctrl_pos[2] + $ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $Dock_Bewegungsraster) Or _ExRound_always($ctrl_pos[2] + $ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1], $Dock_Bewegungsraster) Then ;X rechts

			If _ExRound_always($ctrl_pos[2] + $ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_X_rechts, ($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3]), 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $ctrl_pos[1], ($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3]) - $ctrl_pos[0], $ctrl_pos[3])
			EndIf


			If _ExRound_always($ctrl_pos[2] + $ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_X_rechts, $Positionsarray_aller_Controls[$x][1], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $ctrl_pos[1], $Positionsarray_aller_Controls[$x][1] - $ctrl_pos[0], $ctrl_pos[3])
			EndIf



			$found_x_rechts = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Bewegtes_control))
			$Maus_Differenz_x = Abs((($Pos_M[0] - $Windiff_x) - ($ctrl_pos[0] + $ctrl_pos[2])))
			$Maus_Differenz_x = Abs($Maus_Differenz_x - ($Windiff_x))
			If $Maus_Differenz_x > ($Dock_Bewegungsraster * 2) Then
				$found_x_rechts = 0
			Else
				GUICtrlSetBkColor($Docklabel_X_rechts, $Farbe_Dockstrich)
				GUICtrlSetState($Docklabel_X_rechts, $GUI_SHOW)
			EndIf
		EndIf



		If _ExRound_always($ctrl_pos[1], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2], $Dock_Bewegungsraster) Or _ExRound_always($ctrl_pos[1], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $Dock_Bewegungsraster) Then ;Y Oben

			If _ExRound_always($ctrl_pos[1], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_y_oben, 0, $Positionsarray_aller_Controls[$x][2], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $Positionsarray_aller_Controls[$x][2], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			If _ExRound_always($ctrl_pos[1], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_y_oben, 0, $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			$found_y_oben = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Bewegtes_control))
			$Maus_Differenz_y = Abs((($Pos_M[1] - $Windiff_y) - $ctrl_pos[1]))
			$Maus_Differenz_y = Abs($Maus_Differenz_y - ($Windiff_y))
			If $Maus_Differenz_y > ($Dock_Bewegungsraster * 2) Then
				$found_y_oben = 0
			Else
				GUICtrlSetBkColor($Docklabel_y_oben, $Farbe_Dockstrich)
				GUICtrlSetState($Docklabel_y_oben, $GUI_SHOW)
			EndIf
		EndIf



		If _ExRound_always($ctrl_pos[1] + $ctrl_pos[3], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2], $Dock_Bewegungsraster) Or _ExRound_always($ctrl_pos[1] + $ctrl_pos[3], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $Dock_Bewegungsraster) Then ;Y unten

			If _ExRound_always($ctrl_pos[1] + $ctrl_pos[3], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_y_unten, 0, $Positionsarray_aller_Controls[$x][2], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $ctrl_pos[1], $ctrl_pos[2], $Positionsarray_aller_Controls[$x][2] - $ctrl_pos[1])
			EndIf

			If _ExRound_always($ctrl_pos[1] + $ctrl_pos[3], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_y_unten, 0, $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $ctrl_pos[1], $ctrl_pos[2], ($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4]) - $ctrl_pos[1])
			EndIf


			$found_y_unten = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Bewegtes_control))
			$Maus_Differenz_y = Abs((($Pos_M[1] - $Windiff_y) - ($ctrl_pos[1] + $ctrl_pos[3])))
			$Maus_Differenz_y = Abs($Maus_Differenz_y - ($Windiff_y))
			If $Maus_Differenz_y > ($Dock_Bewegungsraster * 2) Then
				$found_y_unten = 0
			Else
				GUICtrlSetBkColor($Docklabel_y_unten, $Farbe_Dockstrich)
				GUICtrlSetState($Docklabel_y_unten, $GUI_SHOW)
			EndIf
		EndIf




	Next
	If $found_x_links = 0 Then GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	If $found_x_rechts = 0 Then GUICtrlSetState($Docklabel_x_rechts, $GUI_HIDE)
	If $found_y_oben = 0 Then GUICtrlSetState($Docklabel_y_oben, $GUI_HIDE)
	If $found_y_unten = 0 Then GUICtrlSetState($Docklabel_y_unten, $GUI_HIDE)
EndFunc   ;==>_Pruefe_Ob_Control_an_anderes_andockt_resize













Func _Resize_Control_Oben_Links()
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then Return
	$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	Local $Alte_X = $pos[0]
	Local $Alte_y = $pos[1]
	Local $Alte_Breite = $pos[2]
	Local $Alte_hoehe = $pos[3]
	$Pos_W = WinGetPos($GUI_Editor)
	GUISwitch($GUI_Editor)
	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
	_Positionsarray_aller_Controls_aufbauen()
	$Pos_M2 = MouseGetPos()

	_MouseTrap($Pos_W[0] + 15, $Pos_W[1], $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	While _IsPressed("01", $dll)
		$MousePos = MouseGetPos()
		$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		$dif1 = $Alte_X - $MousePos[0]
		$dif2 = $Alte_y - $MousePos[1]
		$neue_breite = $Alte_Breite + $dif1
		$neue_hoehe = $Alte_hoehe + $dif2
		If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
		If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
		$neue_X = $MousePos[0]
		$neue_Y = $MousePos[1]
		If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
		If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
		If $neue_X < $GroesenLimit Then $neue_Y = $GroesenLimit
		If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
		If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
		If ($MousePos[0] <> $Pos_M2[0]) Or ($MousePos[1] <> $Pos_M2[1]) Then
			If _IsPressed("10", $dll) Then
				$x = $Alte_X - ($neue_hoehe - $Alte_hoehe)
				GUICtrlSetPos($Markiertes_Control_ID, $x, $neue_Y, $neue_hoehe, $neue_hoehe)
			Else
				If $found_x_links = 0 And $found_x_rechts = 0 And $found_y_oben = 0 And $found_y_unten = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $neue_X, $neue_Y, $neue_breite, $neue_hoehe)
				If $found_y_oben = 1 Or $found_y_unten = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $neue_X, $pos[1], $neue_breite)
				If $found_x_links = 1 Or $found_x_rechts = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $neue_Y, $pos[2], $neue_hoehe)
			EndIf
			_Pruefe_Ob_Control_an_anderes_andockt_resize($Markiertes_Control_ID)
			_Aktualisiere_Rahmen()
		EndIf
		$Pos_M2 = $MousePos
		Sleep(20)
	WEnd
	_MouseTrap()
	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)
	_Update_Control_Cache($Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_Lese_MiniEditor($TABCONTROL_ID)
	Else
		_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
	EndIf

EndFunc   ;==>_Resize_Control_Oben_Links

Func _Resize_Control_Nach_Rechts()
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then Return
	$Pos_W = WinGetPos($GUI_Editor)
	GUISwitch($GUI_Editor)
	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
	_Positionsarray_aller_Controls_aufbauen()
	$Pos_M2 = MouseGetPos()
	_MouseTrap($Pos_W[0] + 15, $Pos_W[1], $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	While _IsPressed("01", $dll)
		$MousePos = MouseGetPos()
		$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		$neue_breite = $MousePos[0] - $pos[0]
		If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
		If ($MousePos[0] <> $Pos_M2[0]) Or ($MousePos[1] <> $Pos_M2[1]) Then
			If $found_x_rechts = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1], $neue_breite, $pos[3])
			_Pruefe_Ob_Control_an_anderes_andockt_resize($Markiertes_Control_ID)
			_Aktualisiere_Rahmen()
		EndIf
		$Pos_M2 = $MousePos
		Sleep(20)
	WEnd
	_MouseTrap()
	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)
	_Update_Control_Cache($Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_Lese_MiniEditor($TABCONTROL_ID)
	Else
		_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
	EndIf
EndFunc   ;==>_Resize_Control_Nach_Rechts

Func _Resize_Control_Nach_RechtsOben()
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then Return
	$Pos_W = WinGetPos($GUI_Editor)
	GUISwitch($GUI_Editor)
	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
	_Positionsarray_aller_Controls_aufbauen()
	_MouseTrap($Pos_W[0] + 15, $Pos_W[1], $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	Local $Alte_y = $pos[1]
	Local $Alte_hoehe = $pos[3]
	$Pos_M2 = MouseGetPos()
	While _IsPressed("01", $dll)
		$MousePos = MouseGetPos()
		$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		$dif = $Alte_y - $pos[1]
		$neue_Y = $MousePos[1]
		$neue_hoehe = $Alte_hoehe + $dif
		$neue_breite = $MousePos[0] - $pos[0]
		If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
		If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
		If $neue_Y < $GroesenLimit Then $neue_Y = $GroesenLimit
		If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
		If ($MousePos[0] <> $Pos_M2[0]) Or ($MousePos[1] <> $Pos_M2[1]) Then
			If _IsPressed("10", $dll) Then
				GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $neue_Y, $neue_hoehe, $neue_hoehe)
			Else
				If $found_x_links = 0 And $found_x_rechts = 0 And $found_y_oben = 0 And $found_y_unten = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $neue_Y, $neue_breite, $neue_hoehe)
				If $found_y_oben = 1 Or $found_y_unten = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1], $neue_breite, $pos[3])
				If $found_x_links = 1 Or $found_x_rechts = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $neue_Y, $pos[2], $neue_hoehe)
				_Pruefe_Ob_Control_an_anderes_andockt_resize($Markiertes_Control_ID)
			EndIf
			_Aktualisiere_Rahmen()
		EndIf
		$Pos_M2 = $MousePos
		Sleep(20)
	WEnd
	_MouseTrap()
	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)
	_Update_Control_Cache($Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_Lese_MiniEditor($TABCONTROL_ID)
	Else
		_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
	EndIf
EndFunc   ;==>_Resize_Control_Nach_RechtsOben

Func _Resize_Control_Nach_RechtsUnten()
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then Return
	$Pos_W = WinGetPos($GUI_Editor)
	$Pos_M2 = MouseGetPos()
	GUISwitch($GUI_Editor)
	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
	_Positionsarray_aller_Controls_aufbauen()
	_MouseTrap($Pos_W[0] + 15, $Pos_W[1], $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	While _IsPressed("01", $dll)

		$MousePos = MouseGetPos()
		$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		$neue_breite = $MousePos[0] - $pos[0]
		$neue_hoehe = $MousePos[1] - $pos[1]
		If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
		If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
		If ($MousePos[0] <> $Pos_M2[0]) Or ($MousePos[1] <> $Pos_M2[1]) Then
			If _IsPressed("10", $dll) Then
				GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1], $neue_hoehe, $neue_hoehe)
			Else
				If $found_x_links = 0 And $found_x_rechts = 0 And $found_y_oben = 0 And $found_y_unten = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1], $neue_breite, $neue_hoehe)
				If $found_x_links = 1 Or $found_x_rechts = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1], $pos[2], $neue_hoehe)
				If $found_y_oben = 1 Or $found_y_unten = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1], $neue_breite, $pos[3])
				_Pruefe_Ob_Control_an_anderes_andockt_resize($Markiertes_Control_ID)
			EndIf

			_Aktualisiere_Rahmen()
		EndIf
		$Pos_M2 = $MousePos
		Sleep(20)
	WEnd
	_MouseTrap()
	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)
	_Update_Control_Cache($Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_Lese_MiniEditor($TABCONTROL_ID)
	Else
		_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
	EndIf
EndFunc   ;==>_Resize_Control_Nach_RechtsUnten

Func _Resize_Control_Nach_Unten()
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then Return
	$Pos_W = WinGetPos($GUI_Editor)
	$Pos_M2 = MouseGetPos()
	GUISwitch($GUI_Editor)
	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
	_Positionsarray_aller_Controls_aufbauen()
	_MouseTrap($Pos_W[0] + 15, $Pos_W[1], $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	While _IsPressed("01", $dll)

		$MousePos = MouseGetPos()
		$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		$neue_hoehe = $MousePos[1] - $pos[1]
		If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
		If ($MousePos[0] <> $Pos_M2[0]) Or ($MousePos[1] <> $Pos_M2[1]) Then
			If $found_y_unten = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1], $pos[2], $neue_hoehe)
			_Pruefe_Ob_Control_an_anderes_andockt_resize($Markiertes_Control_ID)
			_Aktualisiere_Rahmen()
		EndIf
		$Pos_M2 = $MousePos
		Sleep(20)
	WEnd
	_MouseTrap()
	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)
	_Update_Control_Cache($Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_Lese_MiniEditor($TABCONTROL_ID)
	Else
		_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
	EndIf
EndFunc   ;==>_Resize_Control_Nach_Unten

Func _Resize_Control_Nach_Oben()
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then Return
	$Pos_W = WinGetPos($GUI_Editor)
	GUISwitch($GUI_Editor)
	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
	_Positionsarray_aller_Controls_aufbauen()
	$Pos_M2 = MouseGetPos()
	_MouseTrap($Pos_W[0] + 15, $Pos_W[1], $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	Local $Alte_y = $pos[1]
	Local $Alte_hoehe = $pos[3]
	While _IsPressed("01", $dll)

		$MousePos = MouseGetPos()
		$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		$dif = $Alte_y - $pos[1]
		$neue_Y = $MousePos[1]
		$neue_hoehe = $Alte_hoehe + $dif
		If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
		If $neue_Y < $GroesenLimit Then $neue_Y = $GroesenLimit
		If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
		If ($MousePos[0] <> $Pos_M2[0]) Or ($MousePos[1] <> $Pos_M2[1]) Then
			If $found_y_oben = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $neue_Y, $pos[2], $neue_hoehe)
			_Pruefe_Ob_Control_an_anderes_andockt_resize($Markiertes_Control_ID)
			_Aktualisiere_Rahmen()
		EndIf
		$Pos_M2 = $MousePos
		Sleep(20)


	WEnd
	_MouseTrap()
	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)
	_Update_Control_Cache($Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_Lese_MiniEditor($TABCONTROL_ID)
	Else
		_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
	EndIf
EndFunc   ;==>_Resize_Control_Nach_Oben



Func _Resize_Control_Nach_Links()
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then Return
	$Pos_W = WinGetPos($GUI_Editor)
	_MouseTrap($Pos_W[0] + 15, $Pos_W[1], $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	Local $Alte_X = $pos[0]
	Local $Alte_Breite = $pos[2]
	$Pos_M2 = MouseGetPos()
	GUISwitch($GUI_Editor)
	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
	_Positionsarray_aller_Controls_aufbauen()

	While _IsPressed("01", $dll)

		$MousePos = MouseGetPos()
		$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		$dif = $Alte_X - $pos[0]
		$neue_X = $MousePos[0]
		$neue_breite = $Alte_Breite + $dif
		If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
		If $neue_X < $GroesenLimit Then $neue_Y = $GroesenLimit
		If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
		If ($MousePos[0] <> $Pos_M2[0]) Or ($MousePos[1] <> $Pos_M2[1]) Then
			If $found_x_links = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $neue_X, $pos[1], $neue_breite)
			_Pruefe_Ob_Control_an_anderes_andockt_resize($Markiertes_Control_ID)
			_Aktualisiere_Rahmen()
		EndIf
		$Pos_M2 = $MousePos
		Sleep(20)

	WEnd
	_MouseTrap()
	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)
	_Update_Control_Cache($Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_Lese_MiniEditor($TABCONTROL_ID)
	Else
		_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
	EndIf
EndFunc   ;==>_Resize_Control_Nach_Links

Func _Resize_Control_Nach_LinksUnten()
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then Return
	$Pos_W = WinGetPos($GUI_Editor)
	_MouseTrap($Pos_W[0] + 15, $Pos_W[1], $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	Local $Alte_X = $pos[0]
	Local $Alte_Breite = $pos[2]
	$Pos_M2 = MouseGetPos()
	GUISwitch($GUI_Editor)
	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
	_Positionsarray_aller_Controls_aufbauen()
	While _IsPressed("01", $dll)

		$MousePos = MouseGetPos()
		$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		$dif = $Alte_X - $pos[0]
		$neue_hoehe = $MousePos[1] - $pos[1]
		If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
		$neue_X = $MousePos[0]
		$neue_breite = $Alte_Breite + $dif
		If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
		If $neue_X < $GroesenLimit Then $neue_Y = $GroesenLimit
		If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
		If ($MousePos[0] <> $Pos_M2[0]) Or ($MousePos[1] <> $Pos_M2[1]) Then
			If _IsPressed("10", $dll) Then
				GUICtrlSetPos($Markiertes_Control_ID, $neue_X, $pos[1], $neue_breite, $neue_breite)
			Else
				If $found_x_links = 0 And $found_x_rechts = 0 And $found_y_oben = 0 And $found_y_unten = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $neue_X, $pos[1], $neue_breite, $neue_hoehe)
				If $found_x_links = 1 Or $found_x_rechts = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1], $pos[2], $neue_hoehe)
				If $found_y_oben = 1 Or $found_y_unten = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $neue_X, $pos[1], $neue_breite, $pos[3])
				_Pruefe_Ob_Control_an_anderes_andockt_resize($Markiertes_Control_ID)
			EndIf
			_Aktualisiere_Rahmen()
		EndIf
		$Pos_M2 = $MousePos
		Sleep(20)

	WEnd
	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)
	_MouseTrap()
	_Update_Control_Cache($Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_Lese_MiniEditor($TABCONTROL_ID)
	Else
		_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
	EndIf
EndFunc   ;==>_Resize_Control_Nach_LinksUnten

Func _ExRound($value = 0, $factor = 0)
	If $Use_raster = 1 Then
		;THE MAGIC GRID :D
		$result = Round($value / $factor) * $factor ;result is 1235
		Return $result
	Else
		Return $value
	EndIf
EndFunc   ;==>_ExRound

Func _ExRound_always($value = 0, $factor = 0)
	;THE MAGIC GRID :D
	$result = Round($value / $factor) * $factor ;result is 1235
	Return $result

EndFunc   ;==>_ExRound_always


; Zeile zu Array hinzufügen
Func _Array2D_Inset($String, ByRef $array, $zeile = 0, $spalte = 0, $trenner = "|")
	$temp = StringSplit($String, $trenner) ; String teilen

	; Testen ob Anzahl der Zeilen ok
	If $zeile + 1 > UBound($array, 1) Then
		ReDim $array[$zeile + 1][UBound($array, 2)]
	EndIf

	; Testen ob Anzahl der Spalten ok
	If $temp[0] + $spalte > UBound($array, 2) Then
		ReDim $array[UBound($array, 1)][$temp[0] + $spalte]
	EndIf

	; Zellen in Array schreiben
	For $x = 0 To $temp[0] - 1
		$array[$zeile][$x + $spalte] = $temp[$x + 1]
	Next
EndFunc   ;==>_Array2D_Inset

Func _Positionsarray_aller_Controls_aufbauen()
	If _GUICtrlListView_GetItemCount($controllist) = 0 Then Return
	If $Show_docklines <> "1" Then Return
	If $Markiertes_Control_ID = "" Then Return
	Local $aktuelle_tabseite = "-1"
	If $TABCONTROL_ID <> "" Then
		$aktuelle_tabseite = _GUICtrlTab_GetCurSel($TABCONTROL_ID)
	EndIf
	Dim $Positionsarray_aller_Controls[1][1]
	For $i = 0 To _GUICtrlListView_GetItemCount($controllist) - 1
		$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle(_GUICtrlListView_GetItemText($controllist, $i, 3)))
		$Control_Tabpage = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle(_GUICtrlListView_GetItemText($controllist, $i, 3)), "tabpage", "-1")
		If $Control_Tabpage <> "-1" And $Control_Tabpage <> $aktuelle_tabseite Then ContinueLoop ;Control befindet sich auf anderer Tabseite
		If IsArray($ctrl_pos) Then _Array2D_Inset(_GUICtrlListView_GetItemText($controllist, $i, 3) & "|" & $ctrl_pos[0] & "|" & $ctrl_pos[1] & "|" & $ctrl_pos[2] & "|" & $ctrl_pos[3], $Positionsarray_aller_Controls, $i, 0)
	Next
EndFunc   ;==>_Positionsarray_aller_Controls_aufbauen




Func _Pruefe_Ob_Control_an_anderes_andockt($Bewegtes_control = "", $XOffset = "", $YOffset = "")
	If _GUICtrlListView_GetItemCount($controllist) = 0 Then Return
	If $Show_docklines <> "1" Then Return
	If $Bewegtes_control = "" Then Return
	If $XOffset = "" Then Return
	If $YOffset = "" Then Return
	If $Control_Markiert_MULTI = 1 Then Return
	$ctrl_pos = ControlGetPos($GUI_Editor, "", $Bewegtes_control)
	If Not IsArray($ctrl_pos) Then Return

	$found_x_links = 0
	$found_x_rechts = 0
	$found_y_oben = 0
	$found_y_unten = 0

	$Clientsize = WinGetClientSize($GUI_Editor)
	$winpos = WinGetPos($GUI_Editor)
	$Windiff_x = ($winpos[2] - $Clientsize[0]) / 2
	$Windiff_y = ($winpos[3] - $Clientsize[1]) / 2

	For $x = 0 To UBound($Positionsarray_aller_Controls) - 1
		If $Positionsarray_aller_Controls[$x][0] = $Bewegtes_control Then ContinueLoop ;Mich selbst nicht miteinbeziehen
		$Pos_M = MouseGetPos()




		If (_ExRound_always($ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1], $Dock_Bewegungsraster)) Or (_ExRound_always($ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $Dock_Bewegungsraster)) Then ;X links

			If _ExRound_always($ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_X_links, $Positionsarray_aller_Controls[$x][1], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $Positionsarray_aller_Controls[$x][1], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			If _ExRound_always($ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_X_links, $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			GUICtrlSetBkColor($Docklabel_X_links, $Farbe_Dockstrich)
			GUICtrlSetState($Docklabel_X_links, $GUI_SHOW)
			$found_x_links = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", $Bewegtes_control)
			$Maus_Differenz_x1 = Abs((($Pos_M[0] - $Windiff_x) - $ctrl_pos[0]))
			$Maus_Differenz_x1 = Abs($Maus_Differenz_x1 - ($XOffset - $Windiff_x))
			If $Maus_Differenz_x1 > ($Dock_Bewegungsraster * 2) Then $found_x_links = 0
		EndIf




		If _ExRound_always($ctrl_pos[2] + $ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $Dock_Bewegungsraster) Or _ExRound_always($ctrl_pos[2] + $ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1], $Dock_Bewegungsraster) Then ;X rechts

			If _ExRound_always($ctrl_pos[2] + $ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_X_rechts, ($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3]), 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, ($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3]) - $ctrl_pos[2], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			If _ExRound_always($ctrl_pos[2] + $ctrl_pos[0], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][1], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_X_rechts, $Positionsarray_aller_Controls[$x][1], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $Positionsarray_aller_Controls[$x][1] - $ctrl_pos[2], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			GUICtrlSetBkColor($Docklabel_X_rechts, $Farbe_Dockstrich)
			GUICtrlSetState($Docklabel_X_rechts, $GUI_SHOW)
			$found_x_rechts = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", $Bewegtes_control)
			$Maus_Differenz_x2 = Abs((($Pos_M[0] - $Windiff_x) - $ctrl_pos[0]))
			$Maus_Differenz_x2 = Abs($Maus_Differenz_x2 - ($XOffset - $Windiff_x))
			If $Maus_Differenz_x2 > ($Dock_Bewegungsraster * 2) Then $found_x_rechts = 0
		EndIf




		If _ExRound_always($ctrl_pos[1], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2], $Dock_Bewegungsraster) Or _ExRound_always($ctrl_pos[1], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $Dock_Bewegungsraster) Then ;Y Oben


			If _ExRound_always($ctrl_pos[1], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_Y_oben, 0, $Positionsarray_aller_Controls[$x][2], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $Positionsarray_aller_Controls[$x][2], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			If _ExRound_always($ctrl_pos[1], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_Y_oben, 0, $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			GUICtrlSetBkColor($Docklabel_Y_oben, $Farbe_Dockstrich)
			GUICtrlSetState($Docklabel_Y_oben, $GUI_SHOW)
			$found_y_oben = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", $Bewegtes_control)
			$Maus_Differenz_y1 = Abs((($Pos_M[1] - $Windiff_y) - $ctrl_pos[1]))
			$Maus_Differenz_y1 = Abs($Maus_Differenz_y1 - ($YOffset - $Windiff_y))
			If $Maus_Differenz_y1 > ($Dock_Bewegungsraster * 2) Then $found_y_oben = 0
		EndIf



		If _ExRound_always($ctrl_pos[1] + $ctrl_pos[3], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2], $Dock_Bewegungsraster) Or _ExRound_always($ctrl_pos[1] + $ctrl_pos[3], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $Dock_Bewegungsraster) Then ;Y unten

			If _ExRound_always($ctrl_pos[1] + $ctrl_pos[3], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_Y_unten, 0, $Positionsarray_aller_Controls[$x][2], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], ($Positionsarray_aller_Controls[$x][2]) - $ctrl_pos[3], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			If _ExRound_always($ctrl_pos[1] + $ctrl_pos[3], $Dock_Bewegungsraster) = _ExRound_always($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $Dock_Bewegungsraster) Then
				GUICtrlSetPos($Docklabel_Y_unten, 0, $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], ($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4]) - $ctrl_pos[3], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			GUICtrlSetBkColor($Docklabel_Y_unten, $Farbe_Dockstrich)
			GUICtrlSetState($Docklabel_Y_unten, $GUI_SHOW)
			$found_y_unten = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", $Bewegtes_control)
			$Maus_Differenz_y2 = Abs((($Pos_M[1] - $Windiff_y) - $ctrl_pos[1]))
			$Maus_Differenz_y2 = Abs($Maus_Differenz_y2 - ($YOffset - $Windiff_y))
			If $Maus_Differenz_y2 > ($Dock_Bewegungsraster * 2) Then $found_y_unten = 0
		EndIf




	Next
	If $found_x_links = 0 Then GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	If $found_x_rechts = 0 Then GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	If $found_y_oben = 0 Then GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	If $found_y_unten = 0 Then GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
EndFunc   ;==>_Pruefe_Ob_Control_an_anderes_andockt


Func _Pruefe_Ob_Control_an_anderes_andockt_exakt($Bewegtes_control = "")
	If _GUICtrlListView_GetItemCount($controllist) = 0 Then Return
	If $Show_docklines <> "1" Then Return
	If $Bewegtes_control = "" Then Return
	If $Control_Markiert_MULTI = 1 Then Return
	$ctrl_pos = ControlGetPos($GUI_Editor, "", $Bewegtes_control)
	If Not IsArray($ctrl_pos) Then Return

	$found_x_links = 0
	$found_x_rechts = 0
	$found_y_oben = 0
	$found_y_unten = 0

	$Clientsize = WinGetClientSize($GUI_Editor)
	$winpos = WinGetPos($GUI_Editor)
	$Windiff_x = ($winpos[2] - $Clientsize[0]) / 2
	$Windiff_y = ($winpos[3] - $Clientsize[1]) / 2

	For $x = 0 To UBound($Positionsarray_aller_Controls) - 1
		If $Positionsarray_aller_Controls[$x][0] = $Bewegtes_control Then ContinueLoop ;Mich selbst nicht miteinbeziehen
		$Pos_M = MouseGetPos()




		If $ctrl_pos[0] = $Positionsarray_aller_Controls[$x][1] Or $ctrl_pos[0] = $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3] Then ;X links

			If $ctrl_pos[0] = $Positionsarray_aller_Controls[$x][1] Then
				GUICtrlSetPos($Docklabel_X_links, $Positionsarray_aller_Controls[$x][1], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $Positionsarray_aller_Controls[$x][1], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			If $ctrl_pos[0] = $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3] Then
				GUICtrlSetPos($Docklabel_X_links, $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			GUICtrlSetBkColor($Docklabel_X_links, $Farbe_Dockstrich)
			GUICtrlSetState($Docklabel_X_links, $GUI_SHOW)
			$found_x_links = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Bewegtes_control))
		EndIf




		If $ctrl_pos[2] + $ctrl_pos[0] = $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3] Or $ctrl_pos[2] + $ctrl_pos[0] = $Positionsarray_aller_Controls[$x][1] Then ;X rechts

			If $ctrl_pos[2] + $ctrl_pos[0] = $Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3] Then
				GUICtrlSetPos($Docklabel_X_rechts, ($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3]), 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, ($Positionsarray_aller_Controls[$x][1] + $Positionsarray_aller_Controls[$x][3]) - $ctrl_pos[2], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			If $ctrl_pos[2] + $ctrl_pos[0] = $Positionsarray_aller_Controls[$x][1] Then
				GUICtrlSetPos($Docklabel_X_rechts, $Positionsarray_aller_Controls[$x][1], 0, 1, 9000)
				GUICtrlSetPos($Bewegtes_control, $Positionsarray_aller_Controls[$x][1] - $ctrl_pos[2], $ctrl_pos[1], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			GUICtrlSetBkColor($Docklabel_X_rechts, $Farbe_Dockstrich)
			GUICtrlSetState($Docklabel_X_rechts, $GUI_SHOW)
			$found_x_rechts = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Bewegtes_control))
		EndIf




		If $ctrl_pos[1] = $Positionsarray_aller_Controls[$x][2] Or $ctrl_pos[1] = $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4] Then ;Y Oben

			If $ctrl_pos[1] = $Positionsarray_aller_Controls[$x][2] Then
				GUICtrlSetPos($Docklabel_Y_oben, 0, $Positionsarray_aller_Controls[$x][2], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $Positionsarray_aller_Controls[$x][2], $ctrl_pos[2], $ctrl_pos[3])
			EndIf


			If $ctrl_pos[1] = $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4] Then
				GUICtrlSetPos($Docklabel_Y_oben, 0, $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			GUICtrlSetBkColor($Docklabel_Y_oben, $Farbe_Dockstrich)
			GUICtrlSetState($Docklabel_Y_oben, $GUI_SHOW)
			$found_y_oben = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Bewegtes_control))
		EndIf



		If $ctrl_pos[1] + $ctrl_pos[3] = $Positionsarray_aller_Controls[$x][2] Or $ctrl_pos[1] + $ctrl_pos[3] = $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4] Then ;Y unten

			If $ctrl_pos[1] + $ctrl_pos[3] = $Positionsarray_aller_Controls[$x][2] Then
				GUICtrlSetPos($Docklabel_Y_unten, 0, $Positionsarray_aller_Controls[$x][2], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], ($Positionsarray_aller_Controls[$x][2]) - $ctrl_pos[3], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			If $ctrl_pos[1] + $ctrl_pos[3] = $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4] Then
				GUICtrlSetPos($Docklabel_Y_unten, 0, $Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4], 9000, 1)
				GUICtrlSetPos($Bewegtes_control, $ctrl_pos[0], ($Positionsarray_aller_Controls[$x][2] + $Positionsarray_aller_Controls[$x][4]) - $ctrl_pos[3], $ctrl_pos[2], $ctrl_pos[3])
			EndIf

			GUICtrlSetBkColor($Docklabel_Y_unten, $Farbe_Dockstrich)
			GUICtrlSetState($Docklabel_Y_unten, $GUI_SHOW)
			$found_y_unten = 1
			$ctrl_pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Bewegtes_control))
		EndIf




	Next
	If $found_x_links = 0 Then GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	If $found_x_rechts = 0 Then GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	If $found_y_oben = 0 Then GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	If $found_y_unten = 0 Then GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
EndFunc   ;==>_Pruefe_Ob_Control_an_anderes_andockt_exakt


Func _DragMe() ;Orginal zum verschieben von 1 Bild von ChaosKeks
	If $Control_Markiert_MULTI = 1 Then Return
	If $Markiertes_Control_ID = "" Then Return
	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then
		While _IsPressed('01', $dll)
			Sleep(100)
		WEnd
		Return ;control is locked
	EndIf
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old
	$Opt_old = Opt('MouseCoordMode', 0)
	$Pos_C = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID) ;$pic)
	$Pos_oldpos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	$Pos_M = MouseGetPos()
	$Pos_M2 = $Pos_M
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]

	$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
	$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
	$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

	$found_x_links = 0
	$found_x_rechts = 0
	$found_y_oben = 0
	$found_y_unten = 0

	GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
	GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
	GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)

	_Positionsarray_aller_Controls_aufbauen()

	_MouseTrap($Pos_W[0] + $x_Offset, $Pos_W[1] + $y_Offset, $Pos_W[0] + $Pos_W[2], $Pos_W[1] + $Pos_W[3])
	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If ($Pos_M[0] <> $Pos_M2[0]) Or ($Pos_M[1] <> $Pos_M2[1]) Then

			If $found_x_links = 0 And $found_x_rechts = 0 And $found_y_oben = 0 And $found_y_unten = 0 Then GUICtrlSetPos($Markiertes_Control_ID, $Pos_M[0] - $x_Offset, $Pos_M[1] - $y_Offset)
			$Pos_CX = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
			If $found_x_links = 1 Or $found_x_rechts = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $Pos_CX[0], $Pos_M[1] - $y_Offset)
			If $found_y_oben = 1 Or $found_y_unten = 1 Then GUICtrlSetPos($Markiertes_Control_ID, $Pos_M[0] - $x_Offset, $Pos_CX[1])
			_Pruefe_Ob_Control_an_anderes_andockt($Markiertes_Control_ID, $x_Offset, $y_Offset)
			_Aktualisiere_Rahmen()

		EndIf
		$Pos_M2 = $Pos_M
		Sleep(20)
	WEnd
	_MouseTrap()

	GUICtrlDelete($Docklabel_X_links)
	GUICtrlDelete($Docklabel_X_rechts)
	GUICtrlDelete($Docklabel_Y_oben)
	GUICtrlDelete($Docklabel_Y_unten)

	$Pos_C = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	If $found_x_links = 1 Or $found_x_rechts = 1 Or $found_y_oben = 1 Or $found_y_unten = 1 Then
		GUICtrlSetPos($Markiertes_Control_ID, $Pos_C[0], $Pos_C[1]) ;Falls ein dock gefunden wurde, nicht rastern
	Else
		If $Pos_oldpos[0] <> $Pos_C[0] And $Pos_oldpos[1] <> $Pos_C[1] Then GUICtrlSetPos($Markiertes_Control_ID, _ExRound($Pos_C[0], $Raster), _ExRound($Pos_C[1], $Raster))
	EndIf

	If ($Pos_C[0] <> $Pos_oldpos[0]) Or ($Pos_C[1] <> $Pos_oldpos[1]) Or ($Pos_C[2] <> $Pos_oldpos[2]) Or ($Pos_C[3] <> $Pos_oldpos[3]) Then
		_Aktualisiere_Rahmen(1)
		_Redraw_Window()
		_Update_Control_Cache($Markiertes_Control_ID)
		If $Markiertes_Control_ID = $TABCONTROL_ID Then _Resize_tabcontent($Pos_oldpos[0], $Pos_oldpos[1])
		If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "type", "") = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $Pos_oldpos[0], $Pos_oldpos[1], $Pos_oldpos[2], $Pos_oldpos[3])
		If $Markiertes_Control_ID = $TABCONTROL_ID Then
			_Lese_MiniEditor($TABCONTROL_ID)
		Else
			_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
		EndIf
	EndIf

	Opt('MouseCoordMode', $Opt_old)

EndFunc   ;==>_DragMe

Func _Redraw_Window()
	If $Use_Redraw = 0 Then Return
	Global $struct = DllStructCreate($Rect)
	DllStructSetData($struct, "Left", @DesktopWidth)
	DllStructSetData($struct, "Top", 1500)
	DllStructSetData($struct, "Right", @DesktopWidth)
	DllStructSetData($struct, "Bottom", 1900)
	Global $Pointer = DllStructGetPtr($struct)
	_WinAPI_RedrawWindow($GUI_Editor, $Pointer)
EndFunc   ;==>_Redraw_Window

Func _Aktualisiere_Rahmen($notooltip = 0)
	If $Markiertes_Control_ID = "" Then Return
	Local $pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	If Not IsArray($pos) Then Return
	If UBound($pos) - 1 < 2 Then Return
	GUICtrlSetPos($Resize_Oben_Links, $pos[0] - 5, $pos[1] - 5)
	;GUICtrlSetState(-1, $GUI_ONTOP)
	GUICtrlSetPos($Resize_Oben_Mitte, $pos[0] + ($pos[2] / 2) - 2.5, $pos[1] - 5)
	GUICtrlSetPos($Resize_Oben_Rechts, $pos[0] + $pos[2], $pos[1] - 5)
	GUICtrlSetPos($Resize_Unten_Links, $pos[0] - 5, $pos[1] + $pos[3])
	GUICtrlSetPos($Resize_Unten_Mitte, $pos[0] + ($pos[2] / 2) - 2.5, $pos[1] + $pos[3])
	GUICtrlSetPos($Resize_Unten_Rechts, $pos[0] + $pos[2], $pos[1] + $pos[3])
	GUICtrlSetPos($Resize_Links_Mitte, $pos[0] - 5, $pos[1] + ($pos[3] / 2) - 2.5)
	GUICtrlSetPos($Resize_Rechts_Mitte, $pos[0] + $pos[2], $pos[1] + ($pos[3] / 2) - 2.5)
	$MousePos = MouseGetPos()
	$size = WinGetPos($GUI_Editor)
	If $notooltip = 0 Then ToolTip("X: " & $pos[0] & "px" & "   Y: " & $pos[1] & "px" & @CRLF & _ISNPlugin_Get_langstring(118) & " " & $pos[2] & "px" & "   " & _ISNPlugin_Get_langstring(227) & " " & $pos[3] & "px", $size[0] + $MousePos[0] + 10, $size[1] + $MousePos[1] + 20)
EndFunc   ;==>_Aktualisiere_Rahmen

Func _Aktualisiere_Rahmen_Multi($idn = "", $control = "")

	$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($control))
	If Not IsArray($pos) Then Return
	GUICtrlSetPos($Resize_Oben_Links_Multi[$idn], $pos[0] - 5, $pos[1] - 5)
	GUICtrlSetPos($Resize_Oben_Mitte_Multi[$idn], $pos[0] + ($pos[2] / 2) - 2.5, $pos[1] - 5)
	GUICtrlSetPos($Resize_Oben_Rechts_Multi[$idn], $pos[0] + $pos[2], $pos[1] - 5)
	GUICtrlSetPos($Resize_Unten_Links_Multi[$idn], $pos[0] - 5, $pos[1] + $pos[3])
	GUICtrlSetPos($Resize_Unten_Mitte_Multi[$idn], $pos[0] + ($pos[2] / 2) - 2.5, $pos[1] + $pos[3])
	GUICtrlSetPos($Resize_Unten_Rechts_Multi[$idn], $pos[0] + $pos[2], $pos[1] + $pos[3])
	GUICtrlSetPos($Resize_Links_Mitte_Multi[$idn], $pos[0] - 5, $pos[1] + ($pos[3] / 2) - 2.5)
	GUICtrlSetPos($Resize_Rechts_Mitte_Multi[$idn], $pos[0] + $pos[2], $pos[1] + ($pos[3] / 2) - 2.5)

EndFunc   ;==>_Aktualisiere_Rahmen_Multi

Func _Ist_Maus_in_einem_Markierten_control()
	If $Control_Markiert_MULTI = 0 Then Return False
	$Opt_old = Opt('MouseCoordMode', 0)
	Local $hMouse = GUIGetCursorInfo($GUI_Editor)
	If @error Then
		Opt('MouseCoordMode', $Opt_old)
		Return False
	EndIf

	If Not IsArray($hMouse) Then
		Opt('MouseCoordMode', $Opt_old)
		Return False
	EndIf

	Local $Maus_ist_im_control = 0
	For $u = 0 To $Markierte_Controls_IDs[0]
		If $hMouse[4] = "" Then ContinueLoop
		If $hMouse[4] = 0 Then ContinueLoop
		If GUICtrlGetHandle($hMouse[4]) = $BGimage Then ContinueLoop
		If GUICtrlGetHandle($hMouse[4]) = $Grid_Handle Then ContinueLoop
		If GUICtrlGetHandle($Markierte_Controls_IDs[$u]) = GUICtrlGetHandle($hMouse[4]) Then $Maus_ist_im_control = 1
		If $Maus_ist_im_control = 1 Then ExitLoop
	Next

;~ ConsoleWrite($Maus_ist_im_control&@crlf)
	Opt('MouseCoordMode', $Opt_old)
	If $Maus_ist_im_control = 0 Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>_Ist_Maus_in_einem_Markierten_control


Func _DragMe_Multi($control) ;Orginal zum verschieben von 1 Bild von ChaosKeks

	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old

	$Opt_old = Opt('MouseCoordMode', 0)

	;prüfe ob min. 1 control bewegt werden darf
	Local $Alles_gelocked = 1
	For $u = 0 To $Markierte_Controls_IDs[0] - 1
		If $Markierte_Controls_Sections[$u] = "" Then ContinueLoop
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "locked", "0") = 0 Then $Alles_gelocked = 0
	Next

	If $Alles_gelocked = 1 Then
		While _IsPressed('01', $dll)
			Sleep(100)
		WEnd
		Opt('MouseCoordMode', $Opt_old)
		Return ;alle gesperrt
	EndIf

	;Control 1 darf nicht gelockt sein. (Dient als referenz)
	$unlocked_index = 1
   For $r = 1 To $Markierte_Controls_IDs[0]
	  $handle = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
	  if $Markierte_Controls_IDs[$r] = $TABCONTROL_ID then $handle = "tab"
	  if _IniReadEx($Cache_Datei_Handle,$handle , "locked", 0) = "1" then
		 $unlocked_index = $unlocked_index+1
	  Else
		 exitloop
	  endif
   next


	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$unlocked_index])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()



	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			GUICtrlSetPos($Markierte_Controls_IDs[$unlocked_index], $Pos_C[0] - ($Pos_M2[0] - $Pos_M[0]), $Pos_M[1] - $y_Offset)
			_Aktualisiere_Rahmen_Multi($unlocked_index-1, $Markierte_Controls_IDs[$unlocked_index])
			For $r = 1 To $Markierte_Controls_IDs[0]
			   if $r = $unlocked_index then ContinueLoop
				$Pos_1 = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$unlocked_index]))
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$newX = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", 0) + ($Pos_1[0] - $Pos_C[0])
				$newY = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", 0) + ($Pos_1[1] - $Pos_C[1])
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $newX, $newY)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd
;~ 	_MouseTrap()




	$Pos_C = ControlGetPos($GUI_Editor, "", $control)
	GUICtrlSetPos($control, $Pos_C[0], $Pos_C[1])
	$Pos_C = ControlGetPos($GUI_Editor, "", $control)
	_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
	_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "x", $Pos_C[0])
	_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "y", $Pos_C[1])

	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_C[0], $Pos_C[1])
		_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = "tab" Then
;~ 		   _Resize_tabcontent(_IniReadEx($Cache_Datei_Handle, "tab", "x", 0), _IniReadEx($Cache_Datei_Handle, "tab", "y", 0)) ;vielleicht irgentwann mal...
			_IniWriteEx($Cache_Datei_Handle, "tab", "x", $Pos_C[0])
			_IniWriteEx($Cache_Datei_Handle, "tab", "y", $Pos_C[1])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_C[0])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_C[1])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	;_Aktualisiere_Rahmen_Multi($id)
	_Redraw_Window()


	Opt('MouseCoordMode', $Opt_old)

EndFunc   ;==>_DragMe_Multi

Func Verstecke_Markierungen()
	If $Control_Markiert_MULTI = 1 Then
		GUISetState(@SW_LOCK, $GUI_Editor)
		If Not IsArray($Markierte_Controls_IDs) Then Return
		For $r = 0 To $Markierte_Controls_IDs[0]
			GUICtrlSetState($Resize_Oben_Links_Multi[$r], $GUI_HIDE)
			GUICtrlSetState($Resize_Oben_Mitte_Multi[$r], $GUI_HIDE)
			GUICtrlSetState($Resize_Oben_Rechts_Multi[$r], $GUI_HIDE)
			GUICtrlSetState($Resize_Unten_Links_Multi[$r], $GUI_HIDE)
			GUICtrlSetState($Resize_Unten_Mitte_Multi[$r], $GUI_HIDE)
			GUICtrlSetState($Resize_Unten_Rechts_Multi[$r], $GUI_HIDE)
			GUICtrlSetState($Resize_Links_Mitte_Multi[$r], $GUI_HIDE)
			GUICtrlSetState($Resize_Rechts_Mitte_Multi[$r], $GUI_HIDE)
		Next
		GUISetState(@SW_UNLOCK, $GUI_Editor)
	EndIf
	If $Control_Markiert = 1 Then

		GUICtrlSetState($Resize_Oben_Links, $GUI_HIDE)
		GUICtrlSetState($Resize_Oben_Mitte, $GUI_HIDE)
		GUICtrlSetState($Resize_Oben_Rechts, $GUI_HIDE)

		GUICtrlSetState($Resize_Unten_Links, $GUI_HIDE)
		GUICtrlSetState($Resize_Unten_Mitte, $GUI_HIDE)
		GUICtrlSetState($Resize_Unten_Rechts, $GUI_HIDE)

		GUICtrlSetState($Resize_Links_Mitte, $GUI_HIDE)
		GUICtrlSetState($Resize_Rechts_Mitte, $GUI_HIDE)

	EndIf
EndFunc   ;==>Verstecke_Markierungen

Func Zeige_Markierungen()
	If $Control_Markiert_MULTI = 1 Then
		GUISetState(@SW_LOCK, $GUI_Editor)
		If Not IsArray($Markierte_Controls_IDs) Then Return
		For $r = 0 To $Markierte_Controls_IDs[0]
			GUICtrlSetState($Resize_Oben_Links_Multi[$r], $GUI_SHOW)
			GUICtrlSetState($Resize_Oben_Mitte_Multi[$r], $GUI_SHOW)
			GUICtrlSetState($Resize_Oben_Rechts_Multi[$r], $GUI_SHOW)
			GUICtrlSetState($Resize_Unten_Links_Multi[$r], $GUI_SHOW)
			GUICtrlSetState($Resize_Unten_Mitte_Multi[$r], $GUI_SHOW)
			GUICtrlSetState($Resize_Unten_Rechts_Multi[$r], $GUI_SHOW)
			GUICtrlSetState($Resize_Links_Mitte_Multi[$r], $GUI_SHOW)
			GUICtrlSetState($Resize_Rechts_Mitte_Multi[$r], $GUI_SHOW)
		Next
		GUISetState(@SW_UNLOCK, $GUI_Editor)
	EndIf
	If $Control_Markiert = 1 Then

		GUICtrlSetState($Resize_Oben_Links, $GUI_SHOW)
		GUICtrlSetState($Resize_Oben_Mitte, $GUI_SHOW)
		GUICtrlSetState($Resize_Oben_Rechts, $GUI_SHOW)

		GUICtrlSetState($Resize_Unten_Links, $GUI_SHOW)
		GUICtrlSetState($Resize_Unten_Mitte, $GUI_SHOW)
		GUICtrlSetState($Resize_Unten_Rechts, $GUI_SHOW)

		GUICtrlSetState($Resize_Links_Mitte, $GUI_SHOW)
		GUICtrlSetState($Resize_Rechts_Mitte, $GUI_SHOW)

	EndIf
EndFunc   ;==>Zeige_Markierungen

Func Entferne_Makierung()

	If $Control_Markiert_MULTI = 1 Then
		GUISetState(@SW_LOCK, $GUI_Editor)
		If Not IsArray($Markierte_Controls_IDs) Then Return
		For $r = 0 To $Markierte_Controls_IDs[0] - 1
			If $Resize_Oben_Links_Multi[$r] = "" Then ContinueLoop
			If GUICtrlGetHandle($Resize_Oben_Links_Multi[$r]) <> 0 Then GUICtrlDelete($Resize_Oben_Links_Multi[$r])
			If GUICtrlGetHandle($Resize_Oben_Mitte_Multi[$r]) <> 0 Then GUICtrlDelete($Resize_Oben_Mitte_Multi[$r])
			If GUICtrlGetHandle($Resize_Oben_Rechts_Multi[$r]) <> 0 Then GUICtrlDelete($Resize_Oben_Rechts_Multi[$r])
			If GUICtrlGetHandle($Resize_Unten_Links_Multi[$r]) <> 0 Then GUICtrlDelete($Resize_Unten_Links_Multi[$r])
			If GUICtrlGetHandle($Resize_Unten_Mitte_Multi[$r]) <> 0 Then GUICtrlDelete($Resize_Unten_Mitte_Multi[$r])
			If GUICtrlGetHandle($Resize_Unten_Rechts_Multi[$r]) <> 0 Then GUICtrlDelete($Resize_Unten_Rechts_Multi[$r])
			If GUICtrlGetHandle($Resize_Links_Mitte_Multi[$r]) <> 0 Then GUICtrlDelete($Resize_Links_Mitte_Multi[$r])
			If GUICtrlGetHandle($Resize_Rechts_Mitte_Multi[$r]) <> 0 Then GUICtrlDelete($Resize_Rechts_Mitte_Multi[$r])
		Next
		$Control_Markiert = 0
		$Markiertes_Control_ID = ""
		$Control_Markiert_MULTI = 0
		$Markierte_Controls_IDs = $Markierte_Controls_IDs_leer
		$Markierte_Controls_Sections = $Markierte_Controls_IDs_leer
		_Lese_MiniEditor()
		GUISetState(@SW_UNLOCK, $GUI_Editor)
	EndIf

	If $Control_Markiert = 1 Then
		_Lese_MiniEditor()
		If _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "none") = "none" Then
			Sleep(0)
		Else
			GUICtrlSetState($BGimage, $GUI_Show)
		EndIf

		If $Control_Markiert = 1 Then
			GUICtrlDelete($Resize_Oben_Links)
			GUICtrlDelete($Resize_Oben_Mitte)
			GUICtrlDelete($Resize_Oben_Rechts)

			GUICtrlDelete($Resize_Unten_Links)
			GUICtrlDelete($Resize_Unten_Mitte)
			GUICtrlDelete($Resize_Unten_Rechts)

			GUICtrlDelete($Resize_Links_Mitte)
			GUICtrlDelete($Resize_Rechts_Mitte)
			_GUICtrlListView_SetItemSelected($controllist, -1, False, False)
		EndIf
		$Control_Markiert = 0
		$Markiertes_Control_ID = ""
		GUISetState()
	EndIf
	$clicked = False ;Doppelklick reset
	_SetStatustext(_ISNPlugin_Get_langstring(46))
EndFunc   ;==>Entferne_Makierung

Func _Rename_tabpage()
	If _GUICtrlTab_GetItemCount($TABCONTROL_ID) = 0 Then Return
	If _IniReadEx($Cache_Datei_Handle, "tab", "locked", "0") = 1 Then
		MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(216), -1, $Studiofenster)
		Return ;ist gesperrt
	EndIf
	GUISetState(@SW_DISABLE, $MiniEditor)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUICtrlSetData($tabseite_umbenennen_textinput, _GUICtrlTab_GetItemText($TABCONTROL_ID, _GUICtrlTab_GetCurSel($TABCONTROL_ID)))
	GUISetState(@SW_SHOW, $formstudio_tabseite_umbenennen)
	If _IniReadEx($Cache_Datei_Handle, "TABPAGE" & _GUICtrlTab_GetCurSel($TABCONTROL_ID) + 1, "textmode", "text") = "text" Then
		GUICtrlSetState($tabseite_umbenennen_radio1, $GUI_CHECKED)
		If $Current_ISN_Skin = "dark theme" And $Use_ISN_Skin = "true" Then
			GUICtrlSetBkColor($tabseite_umbenennen_textinput, $ISN_Hintergrundfarbe)
		Else
			GUICtrlSetBkColor($tabseite_umbenennen_textinput, 0xFFFFFF)
		EndIf
	Else
		GUICtrlSetState($tabseite_umbenennen_radio2, $GUI_CHECKED)
		GUICtrlSetBkColor($tabseite_umbenennen_textinput, $Farbe_Func_Textmode)
	EndIf
EndFunc   ;==>_Rename_tabpage

Func _Handle_fuer_tabpage_festlegen()
	If _GUICtrlTab_GetItemCount($TABCONTROL_ID) = 0 Then Return
	If _IniReadEx($Cache_Datei_Handle, "tab", "locked", "0") = 1 Then
		MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(216), -1, $Studiofenster)
		Return ;ist gesperrt
	EndIf

	$Gelesenes_Handle = _IniReadEx($Cache_Datei_Handle, "TABPAGE" & _GUICtrlTab_GetCurSel($TABCONTROL_ID) + 1, "handle", "")

	GUISetState(@SW_DISABLE, $MiniEditor)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUICtrlSetData($tabseite_handle_festlegen_textinput, $Gelesenes_Handle)
	GUISetState(@SW_SHOW, $formstudio_tabseite_handle_festlegen)
EndFunc   ;==>_Handle_fuer_tabpage_festlegen

Func _Handle_fuer_tabpage_festlegen_Abbrechen()
	GUISetState(@SW_ENABLE, $MiniEditor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $formstudio_tabseite_handle_festlegen)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_Handle_fuer_tabpage_festlegen_Abbrechen

Func _Handle_fuer_tabpage_festlegen_OK()
	_Handle_fuer_tabpage_festlegen_Abbrechen()
	$handle = GUICtrlRead($tabseite_handle_festlegen_textinput)
	If StringInStr($handle, '"') Then $handle = StringReplace($handle, '"', "")
	If StringInStr($handle, "'") Then $handle = StringReplace($handle, "'", "")
	If StringInStr($handle, "&") Then $handle = StringReplace($handle, "&", "")
	If StringInStr($handle, "%") Then $handle = StringReplace($handle, "%", "")
	If StringInStr($handle, "=") Then $handle = StringReplace($handle, "=", "")
	If StringInStr($handle, "?") Then $handle = StringReplace($handle, "?", "")
	If StringInStr($handle, "$") Then $handle = StringReplace($handle, "$", "")
	If StringInStr($handle, " ") Then $handle = StringReplace($handle, " ", "_")
	If StringInStr($handle, ";") Then $handle = StringReplace($handle, ";", "")
	If StringInStr($handle, ".") Then $handle = StringReplace($handle, ".", "")
	If StringInStr($handle, "ß") Then $handle = StringReplace($handle, "ß", "ss")
	If StringInStr($handle, "ä") Then $handle = StringReplace($handle, "ä", "ae")
	If StringInStr($handle, "ö") Then $handle = StringReplace($handle, "ö", "oe")
	If StringInStr($handle, "ü") Then $handle = StringReplace($handle, "ü", "ue")
	_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & _GUICtrlTab_GetCurSel($TABCONTROL_ID) + 1, "handle", $handle)
EndFunc   ;==>_Handle_fuer_tabpage_festlegen_OK



Func _Rename_tabpage_select_radio()
	If GUICtrlRead($tabseite_umbenennen_radio1) = $GUI_CHECKED Then
		If $Current_ISN_Skin = "dark theme" And $Use_ISN_Skin = "true" Then
			GUICtrlSetBkColor($tabseite_umbenennen_textinput, $ISN_Hintergrundfarbe)
		Else
			GUICtrlSetBkColor($tabseite_umbenennen_textinput, 0xFFFFFF)
		EndIf
	Else
		GUICtrlSetBkColor($tabseite_umbenennen_textinput, $Farbe_Func_Textmode)
	EndIf
EndFunc   ;==>_Rename_tabpage_select_radio


Func _Rename_tabpage_Abbrechen()
	GUISetState(@SW_ENABLE, $MiniEditor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $formstudio_tabseite_umbenennen)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_Rename_tabpage_Abbrechen


Func _Rename_tabpage_OK()
	_Rename_tabpage_Abbrechen()
	_GUICtrlTab_SetItemText($TABCONTROL_ID, _GUICtrlTab_GetCurSel($TABCONTROL_ID), GUICtrlRead($tabseite_umbenennen_textinput))
	_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & _GUICtrlTab_GetCurSel($TABCONTROL_ID) + 1, "text", GUICtrlRead($tabseite_umbenennen_textinput))
	If GUICtrlRead($tabseite_umbenennen_radio1) = $GUI_CHECKED Then
		_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & _GUICtrlTab_GetCurSel($TABCONTROL_ID) + 1, "textmode", "text")
	Else
		_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & _GUICtrlTab_GetCurSel($TABCONTROL_ID) + 1, "textmode", "func")
	EndIf
EndFunc   ;==>_Rename_tabpage_OK

Func _Add_Page_to_TAB()
	If _GUICtrlTab_GetItemCount($TABCONTROL_ID) = 0 Then Return
	If _IniReadEx($Cache_Datei_Handle, "tab", "locked", "0") = 1 Then
		MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(216), -1, $Studiofenster)
		Return ;ist gesperrt
	EndIf
	_GUICtrlTab_InsertItem($TABCONTROL_ID, _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0") + 1, "Page " & _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0") + 1)
	_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0") + 1, "page", _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0") + 1)
    _IniWriteEx($Cache_Datei_Handle, "TABPAGE" & _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0") + 1, "text", "Page " & _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0") + 1)
	_IniWriteEx($Cache_Datei_Handle, "tab", "pages", _GUICtrlTab_GetItemCount($TABCONTROL_ID))
	;_GUICtrlTab_SetCurSel($TABCONTROL_ID, _IniReadEx($Cache_Datei_Handle,"tab","pages","0")-1)
	;GUISwitch($GUI_Editor,GUICtrlRead ($TABCONTROL_ID, 1))
	DllCall("user32.dll", "int", "RedrawWindow", "hwnd", $GUI_Editor, "int", 0, "int", 0, "int", 0x1)

EndFunc   ;==>_Add_Page_to_TAB

Func _delete_Tab()
	If _IniReadEx($Cache_Datei_Handle, "tab", "locked", "0") = 1 Then
		MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(216), -1, $Studiofenster)
		Return ;ist gesperrt
	EndIf
	If _GUICtrlTab_GetItemCount($TABCONTROL_ID) = 0 Then Return
	$answer = MsgBox(262144 + 36, _ISNPlugin_Get_langstring(73), _ISNPlugin_Get_langstring(134), -1, $Studiofenster)
	If $answer = 7 Then Return

	GUISwitch($GUI_Editor)
	$olttab_Count = _GUICtrlTab_GetItemCount($TABCONTROL_ID)
	$oldtab = _GUICtrlTab_GetCurSel($TABCONTROL_ID)
	_IniWriteEx($Cache_Datei_Handle, "tab", "pages", Number(_IniReadEx($Cache_Datei_Handle, "tab", "pages", "0")) - 1)
	_GUICtrlTab_DeleteItem($TABCONTROL_ID, _GUICtrlTab_GetCurSel($TABCONTROL_ID))

	;Lese Textmodes
	$String = ""
	For $r = 1 To $olttab_Count
		$String = $String & _IniReadEx($Cache_Datei_Handle, "TABPAGE" & $r, "textmode", "text") & "+"
	Next
	StringTrimRight($String, 1)

	_IniDeleteEx($Cache_Datei_Handle, "TABPAGE" & $oldtab + 1)
	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	If @error Then
		Sleep(0)
	Else
		For $i = 1 To $var[0]
			If _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "") == $oldtab Then
				;Markiere_Control(_IniReadEx($Cache_Datei_Handle,$var[$i],"handle",""))
				_IniDeleteEx($Cache_Datei_Handle, $var[$i])
				_IniDeleteEx($Cache_Datei_Handle2, $var[$i])
			EndIf

			If _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "") > $oldtab Then
				_IniWriteEx($Cache_Datei_Handle, $var[$i], "tabpage", _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "0") - 1)
			EndIf

		Next
	EndIf


	$array = StringSplit($String, "+", 2)
	_ArrayDelete($array, $oldtab - 1) ;Lösche alten Textmode
	;Rebuild Tabsections
	For $currtab = 1 To _GUICtrlTab_GetItemCount($TABCONTROL_ID)
		_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $currtab, "page", $currtab)
		_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $currtab, "text", _GUICtrlTab_GetItemText($TABCONTROL_ID, $currtab - 1))
		_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $currtab, "textmode", $array[$currtab - 1])
	Next

	;Cache Datei niederschreiben
	_IniCloseFileEx($Cache_Datei_Handle)
	_IniCloseFileEx($Cache_Datei_Handle2)
	$Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
	$Cache_Datei_Handle2 = _IniOpenFile($Cache_Datei2)

	$oldfile = $AktuelleForm_Speicherdatei
	FileCopy($Cache_Datei, $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf", 9)
	_Load_from_file($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf")
	FileDelete($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf")
	$AktuelleForm_Speicherdatei = $oldfile

EndFunc   ;==>_delete_Tab

Func _CreateBitmapFromIcon($iBackground, $sIcon, $iIndex, $iWidth, $iHeight)

	Local $hDC, $hBackDC, $hBackSv, $hIcon, $hBitmap

	$hDC = _WinAPI_GetDC(0)
	$hBackDC = _WinAPI_CreateCompatibleDC($hDC)
	$hBitmap = _WinAPI_CreateSolidBitmap(0, $iBackground, $iWidth, $iHeight)
	$hBackSv = _WinAPI_SelectObject($hBackDC, $hBitmap)
	$hIcon = _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
	If Not @error Then
		_WinAPI_DrawIconEx($hBackDC, 0, 0, $hIcon, 0, 0, 0, 0, $DI_NORMAL)
		_WinAPI_DestroyIcon($hIcon)
	EndIf
	_WinAPI_SelectObject($hBackDC, $hBackSv)
	_WinAPI_ReleaseDC(0, $hDC)
	_WinAPI_DeleteDC($hBackDC)
	Return $hBitmap
EndFunc   ;==>_CreateBitmapFromIcon

Func _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)

	Local $hIcon, $tIcon = DllStructCreate('hwnd'), $tID = DllStructCreate('hwnd')
	Local $Ret = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)

	If (@error) Or ($Ret[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf
	$hIcon = DllStructGetData($tIcon, 1)
	If ($hIcon = Ptr(0)) Or (Not IsPtr($hIcon)) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $hIcon
EndFunc   ;==>_WinAPI_PrivateExtractIcon

Func Markiere_Control($control = "")

	If $Control_Markiert_MULTI = 1 Then Return

	If $Control_Markiert = 1 Then Entferne_Makierung()

	If $Control_Markiert = 0 Then

		Local $pos = ControlGetPos($GUI_Editor, "", $control)
		If Not IsArray($pos) Then Return
		If @error = 1 Then Return
		If UBound($pos) - 1 < 2 Then Return

		;Prüfe ob Control in der Cache Ini existiert...ansonsten Return
		$Section = ControlGetHandle($GUI_Editor, "", $control)
		If $control = $TABCONTROL_ID Then $Section = "tab"
		If _IniReadEx($Cache_Datei_Handle, $Section, "id", "#error#") = "#error#" Then Return



		$Markiertes_Control_ID = $control ;@GUI_CtrlId
		_SetStatustext(_ISNPlugin_Get_langstring(90))
		$control = $control ;@GUI_CtrlId
		$Control_Markiert = 1
		GUICtrlSetCursor($control, 9)


		;-1 Fixes:
		If $pos[0] - 5 = -1 Then
			$t = 0
		Else
			$t = $pos[0] - 5
		EndIf
		If $pos[1] - 5 = -1 Then
			$s = 0
		Else
			$s = $pos[1] - 5
		EndIf
		;End
		$oldsec = _GUICtrlTab_GetCurSel($TABCONTROL_ID)

		_GUICtrlTab_SetCurFocus($TABCONTROL_ID, -1)

		Global $Resize_Oben_Links = GUICtrlCreatePic("data\punkt.jpg", $t, $s, 5, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_Resize_Control_Oben_Links")
		GUICtrlSetCursor(-1, 12)
		GUICtrlSetStyle(-1, $Default_Image)
		;Punkte oben
		Global $Resize_Oben_Mitte = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + ($pos[2] / 2) - 2.5, $pos[1] - 5, 5, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Oben")
		GUICtrlSetCursor(-1, 11)
		GUICtrlSetStyle(-1, $Default_Image)
		Global $Resize_Oben_Rechts = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + $pos[2], $pos[1] - 5, 5, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_RechtsOben")
		GUICtrlSetCursor(-1, 10)
		GUICtrlSetStyle(-1, $Default_Image)

		;Punkte unten
		Global $Resize_Unten_Links = GUICtrlCreatePic("data\punkt.jpg", $pos[0] - 5, $pos[1] + $pos[3], 5, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_LinksUnten")
		GUICtrlSetCursor(-1, 10)
		GUICtrlSetStyle(-1, $Default_Image)
		Global $Resize_Unten_Mitte = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + ($pos[2] / 2) - 2.5, $pos[1] + $pos[3], 5, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Unten")
		GUICtrlSetCursor(-1, 11)
		GUICtrlSetStyle(-1, $Default_Image)
		Global $Resize_Unten_Rechts = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + $pos[2], $pos[1] + $pos[3], 5, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_RechtsUnten")
		GUICtrlSetCursor(-1, 12)
		GUICtrlSetStyle(-1, $Default_Image)

		;Punkte mitte
		Global $Resize_Links_Mitte = GUICtrlCreatePic("data\punkt.jpg", $pos[0] - 5, $pos[1] + ($pos[3] / 2) - 2.5, 5, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Links")
		GUICtrlSetCursor(-1, 13)
		GUICtrlSetStyle(-1, $Default_Image)
		Global $Resize_Rechts_Mitte = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + $pos[2], $pos[1] + ($pos[3] / 2) - 2.5, 5, 5)
		GUICtrlSetResizing(-1, $GUI_DOCKALL)
		GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Rechts")
		GUICtrlSetCursor(-1, 13)
		GUICtrlSetStyle(-1, $Default_Image)
		GUISetState()

		_GUICtrlTab_SetCurFocus($TABCONTROL_ID, $oldsec)
		_Lese_MiniEditor($control)

		_Select_Item_IN_List($control)

	EndIf
EndFunc   ;==>Markiere_Control

Func _exit()
	FileDelete($MenuEditor_tempfile)
	FileDelete($Cache_Datei)
	FileDelete($Cache_Datei2)
	FileDelete($Lastsavefile)
	FileDelete($Temp_AU3_File)
	DllClose($dll)
	DllClose($user32)
	DllClose($kernel32)
	_GUIToolTip_Destroy($hToolTip)
	_GUIToolTip_Destroy($menueditorGUI_ToolTip)
	_GUIToolTip_Destroy($control_reihenfolge_GUI_ToolTip)
	_ISNPlugin_beende_Mailslot($Mailslot_Handle)
	_USkin_Exit()
	Exit
EndFunc   ;==>_exit

Func Zentriere_Maus_im_Editor()
	$size = WinGetPos($GUI_Editor)
	MouseMove($size[0] + ($size[2] / 2), $size[1] + ($size[3] / 2), 0)
EndFunc   ;==>Zentriere_Maus_im_Editor

Func _Destroy_Editor()
	if HWnd($GUI_Editor) then GUIDelete($GUI_Editor)
;~ 	GUIDelete($hChild)
EndFunc   ;==>_Destroy_Editor




Func _ColourInvert($code = "")
	Return "0x" & Hex(0xFFFFFF - $code, 6)
EndFunc   ;==>_ColourInvert

Func _Lese_MiniEditor($control = "")
	If $control = "" Then ;Editor leeren
		GUICtrlSetData($MiniEditor_ControlID, "")
		GUICtrlSetData($MiniEditor_Text, "")
		GUICtrlSetData($MiniEditorX, "")
		GUICtrlSetData($MiniEditorY, "")
		GUICtrlSetData($MiniEditor_breite, "")
		GUICtrlSetData($MiniEditor_hoehe, "")
		GUICtrlSetData($MiniEditor_BGColour, "")
		GUICtrlSetData($MiniEditor_ClickFunc, "")
		GUICtrlSetData($MiniEditor_Schriftart, "")
		GUICtrlSetData($MiniEditor_Schriftartstyle, "")
		GUICtrlSetData($MiniEditor_Schriftgroese, "")
		GUICtrlSetData($MiniEditor_Schriftbreite, "")
		GUICtrlSetData($MiniEditor_Textfarbe, "")
		GUICtrlSetData($MiniEditor_Style, "")
		GUICtrlSetData($MiniEditor_EXStyle, "")
		GUICtrlSetData($MiniEditor_ControlState, "")
		GUICtrlSetData($MiniEditor_Controltype, "")
		GUICtrlSetData($MiniEditor_IconPfad, "")
		GUICtrlSetData($MiniEditor_Tooltip, "")
		GUICtrlSetData($MiniEditor_Resize_input, "")
		GUICtrlSetData($MiniEditor_Icon_Index_Input, "")
		If $Current_ISN_Skin = "dark theme" And $Use_ISN_Skin = "true" Then
			GUICtrlSetBkColor($MiniEditor_Text, $ISN_Hintergrundfarbe)
			GUICtrlSetBkColor($MiniEditor_Tooltip, $ISN_Hintergrundfarbe)
			GUICtrlSetBkColor($MiniEditor_IconPfad, $ISN_Hintergrundfarbe)
			GUICtrlSetBkColor($MiniEditor_BGColour, $ISN_Hintergrundfarbe)
		Else
			GUICtrlSetBkColor($MiniEditor_Text, 0xFFFFFF)
			GUICtrlSetBkColor($MiniEditor_Tooltip, 0xFFFFFF)
			GUICtrlSetBkColor($MiniEditor_IconPfad, 0xFFFFFF)
			GUICtrlSetBkColor($MiniEditor_BGColour, 0xFFFFFF)
		EndIf
		GUICtrlSetData($MiniEditor_Tabpagecombo, "")
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_unChecked)
		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_unChecked)
		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio1_label, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Uebernehmen_Button, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Code_Button, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ControlID, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_erweitert, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text, $GUI_DISABLE)
		GUICtrlSetState($MiniEditorX, $GUI_DISABLE)
		GUICtrlSetState($MiniEditorY, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_breite, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_hoehe, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_GETBGButton, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_BGColourTrans, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_BGColour, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartwahlen, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Textfarbe, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftart, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_IconPfad, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Resize_punktebutton, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartstyle, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftgroese, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftbreite, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Style, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ClickFunc, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_EXStyle, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ControlState, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Tooltip, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_GetIconButton, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ChooseFunc, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt2, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt3, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt4, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt5, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Weitere_Aktionen_Button, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Resize_input, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_lock_Button, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Icon_Index_Input, $GUI_DISABLE)

		If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
			_SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1828 + 1, 16, 16)
		Else
			Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1828, 4)
		EndIf
		_Load_Styles_for_Control("")
		_Load_exStyles_for_Control("")
		_Load_states_for_Control("")
		Return
	EndIf

	$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
	If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then ;is locked
		GUICtrlSetImage($Resize_Oben_Links, @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Oben_Mitte, @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Oben_Rechts, @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Unten_Links, @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Unten_Mitte, @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Unten_Rechts, @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Links_Mitte, @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Rechts_Mitte, @ScriptDir & "\Data\Punkt_locked.jpg")
		If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
			_SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1816 + 1, 16, 16)
		Else
			Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1816, 4)
		EndIf
	EndIf

	GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_disable)
	If $control = $TABCONTROL_ID Then
		$Section = "tab"
		GUICtrlSetData($MiniEditor_Tabpagecombo, _ISNPlugin_Get_langstring(63), _ISNPlugin_Get_langstring(63))

	Else
		$Section = ControlGetHandle($GUI_Editor, "", $control)
		If $TABCONTROL_ID <> "" Then
			GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_ENABLE)
			GUICtrlSetData($MiniEditor_Tabpagecombo, _ISNPlugin_Get_langstring(63), _ISNPlugin_Get_langstring(63))
		EndIf
	EndIf

	If $TABCONTROL_ID <> "" And $Markiertes_Control_ID <> $TABCONTROL_ID Then
		GUICtrlSetData($MiniEditor_Tabpagecombo, "")
		;Make Pages
		$pages = _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0")
		$page = 1
		$str = _ISNPlugin_Get_langstring(63) & "|"
		While $page < $pages + 1
			$str = $str & $page & "|"
			$page = $page + 1
		WEnd
		$x = _IniReadEx($Cache_Datei_Handle, $Section, "tabpage", "-1")
		If $x = "-1" Then
			$x = _ISNPlugin_Get_langstring(63)
		Else
			$x = $x + 1
		EndIf

		GUICtrlSetData($MiniEditor_Tabpagecombo, $str, $x)
	EndIf

	GUICtrlSetState($MiniEditor_Weitere_Aktionen_Button, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio1_label, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_lock_Button, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_erweitert, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_ChooseFunc, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_GetIconButton, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_IconPfad, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_ControlState, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_ClickFunc, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_EXStyle, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlenbt2, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlenbt3, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlenbt4, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlenbt5, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Style, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftbreite, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftgroese, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartstyle, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftart, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Tooltip, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Textfarbe, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlen, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_BGColour, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_BGColourTrans, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_GETBGButton, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_hoehe, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_breite, $GUI_ENABLE)
	GUICtrlSetState($MiniEditorY, $GUI_ENABLE)
	GUICtrlSetState($MiniEditorX, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Resize_input, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Resize_punktebutton, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Icon_Index_Input, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_ControlID, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Uebernehmen_Button, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Code_Button, $GUI_ENABLE)
	GUICtrlSetData($MiniEditor_ControlID, _IniReadEx($Cache_Datei_Handle, $Section, "id", "#error#"))
	GUICtrlSetData($MiniEditor_Text, _IniReadEx($Cache_Datei_Handle, $Section, "text", "#error#"))
	GUICtrlSetData($MiniEditorX, _IniReadEx($Cache_Datei_Handle, $Section, "x", "#error#"))
	GUICtrlSetData($MiniEditorY, _IniReadEx($Cache_Datei_Handle, $Section, "y", "#error#"))
	GUICtrlSetData($MiniEditor_breite, _IniReadEx($Cache_Datei_Handle, $Section, "width", "#error#"))
	GUICtrlSetData($MiniEditor_hoehe, _IniReadEx($Cache_Datei_Handle, $Section, "height", "#error#"))
	GUICtrlSetData($MiniEditor_BGColour, _IniReadEx($Cache_Datei_Handle, $Section, "bgcolour", "#error#"))
	If _IniReadEx($Cache_Datei_Handle, $Section, "bgcolour", _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", 0xF0F0F0)) = "" Then
		GUICtrlSetBkColor($MiniEditor_BGColour, 0xFFFFFF)
	Else
		GUICtrlSetBkColor($MiniEditor_BGColour, _IniReadEx($Cache_Datei_Handle, $Section, "bgcolour", _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", 0xF0F0F0)))
	EndIf
	GUICtrlSetData($MiniEditor_ClickFunc, _IniReadEx($Cache_Datei_Handle, $Section, "func", "#error#"))
	GUICtrlSetData($MiniEditor_Schriftart, _IniReadEx($Cache_Datei_Handle, $Section, "font", "#error#"))
;~ guictrlsetdata($MiniEditor_Schriftart_dummy ,_IniReadEx($Cache_Datei_Handle,$section,"font","#error#"))
	GUICtrlSetData($MiniEditor_Schriftartstyle, _IniReadEx($Cache_Datei_Handle, $Section, "fontattribute", "0")) ;schriftstyle
	GUICtrlSetData($MiniEditor_Schriftgroese, _IniReadEx($Cache_Datei_Handle, $Section, "fontsize", "#error#"))
	GUICtrlSetData($MiniEditor_Schriftbreite, _IniReadEx($Cache_Datei_Handle, $Section, "fontstyle", "#error#")) ;schriftbreite
	GUICtrlSetData($MiniEditor_Textfarbe, _IniReadEx($Cache_Datei_Handle, $Section, "textcolour", "#error#"))
	GUICtrlSetBkColor($MiniEditor_Textfarbe, _IniReadEx($Cache_Datei_Handle, $Section, "textcolour", 0xFFFFFF))
	GUICtrlSetData($MiniEditor_Style, _IniReadEx($Cache_Datei_Handle, $Section, "style", "#error#"))
	GUICtrlSetData($MiniEditor_EXStyle, _IniReadEx($Cache_Datei_Handle, $Section, "exstyle", "#error#"))
	GUICtrlSetData($MiniEditor_ControlState, _IniReadEx($Cache_Datei_Handle, $Section, "state", "#error#"))
	GUICtrlSetData($MiniEditor_Controltype, _IniReadEx($Cache_Datei_Handle, $Section, "type", "#error#"))
	GUICtrlSetData($MiniEditor_IconPfad, _IniReadEx($Cache_Datei_Handle, $Section, "bgimage", ""))
	GUICtrlSetData($MiniEditor_Resize_input, _IniReadEx($Cache_Datei_Handle, $Section, "resize", ""))
	GUICtrlSetData($MiniEditor_Tooltip, _IniReadEx($Cache_Datei_Handle, $Section, "tooltip", ""))
	GUICtrlSetData($MiniEditor_Icon_Index_Input, _IniReadEx($Cache_Datei_Handle, $Section, "iconindex", ""))
	GUICtrlSetOnEvent($MiniEditor_Text_erweitert, "_Zeige_Erweiterten_Text")
	If _IniReadEx($Cache_Datei_Handle, $Section, "textmode", "text") = "text" Then
		If GUICtrlRead($MiniEditor_Controltype) = "listview" Then GUICtrlSetOnEvent($MiniEditor_Text_erweitert, "_Listview_Zeige_Spalteneditor")

		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_Checked)
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_unChecked)

		If $Current_ISN_Skin = "dark theme" And $Use_ISN_Skin = "true" Then
			GUICtrlSetBkColor($MiniEditor_Text, $ISN_Hintergrundfarbe)
			GUICtrlSetBkColor($MiniEditor_Tooltip, $ISN_Hintergrundfarbe)
			GUICtrlSetBkColor($MiniEditor_IconPfad, $ISN_Hintergrundfarbe)
		Else
			GUICtrlSetBkColor($MiniEditor_Text, 0xFFFFFF)
			GUICtrlSetBkColor($MiniEditor_Tooltip, 0xFFFFFF)
			GUICtrlSetBkColor($MiniEditor_IconPfad, 0xFFFFFF)
		EndIf
	Else
		GUICtrlSetOnEvent($MiniEditor_Text_erweitert, "_Zeige_Erweiterten_Text")
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_Checked)
		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_unChecked)
		GUICtrlSetBkColor($MiniEditor_Text, $Farbe_Func_Textmode)
		GUICtrlSetBkColor($MiniEditor_Tooltip, $Farbe_Func_Textmode)
		GUICtrlSetBkColor($MiniEditor_IconPfad, $Farbe_Func_Textmode)
	EndIf
	GUICtrlSetColor($MiniEditor_Textfarbe, _ColourInvert(Execute(_IniReadEx($Cache_Datei_Handle, $Section, "textcolour", 0xFFFFFF))))
	GUICtrlSetColor($MiniEditor_BGColour, _ColourInvert(Execute(_IniReadEx($Cache_Datei_Handle, $Section, "bgcolour", 0xFFFFFF))))
	GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio1_label, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_ENABLE)
	If $control = $TABCONTROL_ID Then
		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio1_label, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_erweitert, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text, $GUI_DISABLE)
	EndIf


	If GUICtrlRead($MiniEditor_Controltype) = "menu" Then ;Locke einige Controls bei Menüs
		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio1_label, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Tooltip, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_IconPfad, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartwahlen, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ClickFunc, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ChooseFunc, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ControlID, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Style, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ExStyle, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Resize_input, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Resize_punktebutton, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "com" Then ;Locke einige Controls bei COM-Objekten
		GUICtrlSetState($MiniEditor_Tooltip, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_IconPfad, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartwahlen, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ClickFunc, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ChooseFunc, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Style, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ExStyle, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Resize_input, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Resize_punktebutton, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "toolbar" Or GUICtrlRead($MiniEditor_Controltype) = "statusbar" Then ;Locke einige Controls bei Toolbars
		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio1_label, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Text, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Tooltip, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_IconPfad, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Schriftartwahlen, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ClickFunc, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_ChooseFunc, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Resize_input, $GUI_DISABLE)
		GUICtrlSetState($MiniEditor_Resize_punktebutton, $GUI_DISABLE)
	EndIf

	_Load_Styles_for_Control(GUICtrlRead($MiniEditor_Controltype))
	_Load_exStyles_for_Control(GUICtrlRead($MiniEditor_Controltype))
	_Load_states_for_Control(GUICtrlRead($MiniEditor_Controltype))
;~ 	_Repos_Control_Editor()
EndFunc   ;==>_Lese_MiniEditor

Func Create_Default_Cache()
	_IniWriteEx($Cache_Datei_Handle, "gui", "title", _IniReadEx($Cache_Datei_Handle, "gui", "title", "Form1"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "breite", _IniReadEx($Cache_Datei_Handle, "gui", "breite", "640"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "hoehe", _IniReadEx($Cache_Datei_Handle, "gui", "hoehe", "480"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "style", _IniReadEx($Cache_Datei_Handle, "gui", "style", "-1"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "exstyle", _IniReadEx($Cache_Datei_Handle, "gui", "exstyle", "-1"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "bgcolour", _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "0xF0F0F0"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "bgimage", _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "none"))
EndFunc   ;==>Create_Default_Cache

Func copy_item()
	If Not WinActive($GUI_Editor) Then WinActivate($GUI_Editor)
	If GUISwitch($GUI_Editor) Then
		$Zwischenablage_Array = $Leeres_Array
		If $Markiertes_Control_ID = "" And $Control_Markiert_MULTI = 0 Then Return
		If $Control_Markiert_MULTI = 1 Then

			For $x = 1 To UBound($Markierte_Controls_IDs) - 1
				If $Markierte_Controls_IDs[$x] <> "" Then _ArrayAdd($Zwischenablage_Array, $Markierte_Controls_IDs[$x])
			Next


		Else
			_ArrayAdd($Zwischenablage_Array, $Markiertes_Control_ID)
		EndIf
	EndIf
EndFunc   ;==>copy_item

Func _Pruefe_Aenderungen_vor_dem_schliessen()
	Local $cache_array_file
	Local $savefile_array
	_ISNPlugin_Nachricht_senden("checkchangeswait")
	_IniCloseFileEx($Cache_Datei_Handle)
	_IniCloseFileEx($Cache_Datei_Handle2)
	$Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
	$Cache_Datei_Handle2 = _IniOpenFile($Cache_Datei2)
	_FileReadToArray($Cache_Datei, $cache_array_file)
	_FileReadToArray($Lastsavefile, $savefile_array)
	If IsArray($cache_array_file) And IsArray($savefile_array) Then
		If _ArrayToString($cache_array_file, @CRLF) <> _ArrayToString($savefile_array, @CRLF) Then
			Dim $szDrive, $szDir, $szFName, $szExt
			$TestPath = _PathSplit(FileGetLongName($Filetoopen), $szDrive, $szDir, $szFName, $szExt)
			$result = MsgBox(262144 + 32 + 4, _ISNPlugin_Get_langstring(73), $szFName & $szExt & " " & _ISNPlugin_Get_langstring(165), $Studiofenster)
			If $result = 6 Then _Speichern()
		EndIf
	EndIf
	_ISNPlugin_Nachricht_senden("changesok")
EndFunc   ;==>_Pruefe_Aenderungen_vor_dem_schliessen


Func _Speichern()

   ;Wenn folgende GUIs aktiv sind, NICHT speichern!
   $menueditorGUI_Winstate = WinGetState($menueditorGUI)
   $control_reihenfolge_GUI_Winstate = WinGetState($control_reihenfolge_GUI)
   If BitAND($menueditorGUI_Winstate, 2) OR BitAND($control_reihenfolge_GUI_Winstate, 2) Then
   Return
   Endif





	If $Markiertes_Control_ID <> "" Then _Mini_Editor_Einstellungen_Uebernehmen()

	If $AktuelleForm_Speicherdatei = "#new#" Then
		Return
		GUISetState(@SW_DISABLE, $GUI_Editor)
		GUISetState(@SW_DISABLE, $StudioFenster)
		$i = FileSaveDialog("Speicherort wählen", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Form Studio Projekte (*.isf)", 18, _IniReadEx($Cache_Datei_Handle, "gui", "title", "MyForm"))
		FileChangeDir(@ScriptDir)
		If $i = "" Then
			Sleep(0)
		Else
			$check = $i
			If StringTrimLeft($check, StringLen($check) - 4) = ".isf" Then $i = StringTrimRight($i, 4)
			FileCopy($Cache_Datei, $i & ".isf", 9)
			$AktuelleForm_Speicherdatei = $i & ".isf"
		EndIf

	Else

		;New isf combo file! ;)	(inklude au3 source)
		$file = FileOpen($AktuelleForm_Speicherdatei, 10)
		GUISetState(@SW_DISABLE, $StudioFenster_inside)
		GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
		GUISetState(@SW_DISABLE, $GUI_Editor)
		GUISetState(@SW_DISABLE, $StudioFenster)

		GUISetState(@SW_HIDE, $GUI_Editor)
		GUISetState(@SW_HIDE, $Formstudio_controleditor_GUI)
		GUICtrlSetData($StudioFenster_inside_Text1, _ISNPlugin_Get_langstring(84) & "...")
		GUICtrlSetData($StudioFenster_inside_Text2, "0 %")
		GUICtrlSetData($StudioFenster_inside_load, 0)
		GUICtrlSetState($StudioFenster_inside_Text1, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_Text2, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_Icon, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_load, $GUI_SHOW)


		_TEST_FORM(0, 1)
		FileCopy($Cache_Datei, $Lastsavefile, 9)

		If Not _FileReadToArray($Temp_AU3_File, $aRecords) Then
			Return
		EndIf
		For $x = 1 To $aRecords[0]
			FileWriteLine($file, $aRecords[$x] & @CRLF)
		Next

		FileWriteLine($file, @CRLF)
		FileWriteLine($file, @CRLF)
		FileWriteLine($file, @CRLF)
		FileWriteLine($file, "#cs")
		If Not _FileReadToArray($Cache_Datei, $aRecords) Then
			Return
		EndIf
		For $x = 1 To $aRecords[0]
			FileWriteLine($file, $aRecords[$x] & @CRLF)
		Next
		FileWriteLine($file, "#ce")

		FileClose($file)
		GUICtrlSetState($StudioFenster_inside_Text1, $GUI_HIDE)
		GUICtrlSetState($StudioFenster_inside_Text2, $GUI_HIDE)
		GUICtrlSetState($StudioFenster_inside_Icon, $GUI_HIDE)
		GUICtrlSetState($StudioFenster_inside_load, $GUI_HIDE)
		GUISetState(@SW_ENABLE, $StudioFenster_inside)
		GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
		GUISetState(@SW_ENABLE, $GUI_Editor)
		GUISetState(@SW_ENABLE, $StudioFenster)
		GUISetState(@SW_SHOW, $GUI_Editor)
		GUISetState(@SW_SHOW, $Formstudio_controleditor_GUI)

		WinActivate($GUI_Editor)
		GUISwitch($GUI_Editor)
		;FileCopy(@scriptdir&"\"&$Cache_Datei,$AktuelleForm_Speicherdatei,9)
	EndIf

EndFunc   ;==>_Speichern



Func _Hintergrund_Trans()
	GUICtrlSetData($MiniEditor_BGColour, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetBkColor($MiniEditor_BGColour, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor($MiniEditor_BGColour, 0x000000)
	_Mini_Editor_Einstellungen_Uebernehmen()
EndFunc   ;==>_Hintergrund_Trans

Func _choose_pic()
	If GUICtrlRead($MiniEditor_ControlID) = "" Then Return
	$i = FileOpenDialog("Bild/Icon wählen", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Bilder & Icons (*.jpg;*jpeg;*.bmp;*.ico)", 3, "")
	FileChangeDir(@ScriptDir)
	If $i = "" Then
		GUICtrlSetData($MiniEditor_IconPfad, "")
		Return
	EndIf
	GUICtrlSetData($MiniEditor_IconPfad, $i)
	_Mini_Editor_Einstellungen_Uebernehmen()
EndFunc   ;==>_choose_pic


Func _Editor_Resize_WM($hWnd, $msg, $wParam, $lParam)
	If Not IsDeclared("GUI_Editor") Then Return
	If $hWnd <> $GUI_Editor Then Return
	If _IsPressed("01", $dll) = 1 Then
		$MousePos = MouseGetPos()
		$size = WinGetPos($GUI_Editor)
		$pos = WinGetClientSize($GUI_Editor)
		If $MENUCONTROL_ID <> "" Then
			$Hoehe_Der_Menueleiste = _WinAPI_GetSystemMetrics($SM_CYMENU)
			$pos[1] = $pos[1] + $Hoehe_Der_Menueleiste
		EndIf
		If IsArray($MousePos) And IsArray($size) Then ToolTip(_ISNPlugin_Get_langstring(118) & " " & $pos[0] & "px" & @CRLF & _ISNPlugin_Get_langstring(227) & " " & $pos[1] & "px", $size[0] + $MousePos[0] + 10, $size[1] + $MousePos[1] + 20)
	EndIf
EndFunc   ;==>_Editor_Resize_WM




Func _Update_GUI()
	ToolTip("")
	If Not IsDeclared("GUI_Editor") Then Return
	If Not IsDeclared("BGimage") Then Return
	$pos = WinGetClientSize($GUI_Editor)
	If Not IsArray($pos) Then Return
	If $MENUCONTROL_ID <> "" Then
		$Hoehe_Der_Menueleiste = _WinAPI_GetSystemMetrics($SM_CYMENU)
		$pos[1] = $pos[1] + $Hoehe_Der_Menueleiste
	EndIf
	If _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "none") <> "none" Then GUICtrlSetPos($BGimage, 0, 0, $pos[0], $pos[1])
	_IniWriteEx($Cache_Datei_Handle, "gui", "breite", $pos[0])
	_IniWriteEx($Cache_Datei_Handle, "gui", "hoehe", $pos[1])
	If Not $STATUSBARCONTROL_ID = "" Then _GUICtrlStatusBar_Resize($STATUSBARCONTROL_ID)
EndFunc   ;==>_Update_GUI

Func _waehle_HintergrundFarbe_editGUI()
	$a_colour = _ChooseColor(2, GUICtrlRead($Form_bearbeitenBGColour), 2, $StudioFenster)
	If $a_colour < 0 Then Return
	GUICtrlSetData($Form_bearbeitenBGColour, $a_colour)
	GUICtrlSetBkColor($Form_bearbeitenBGColour, $a_colour)
EndFunc   ;==>_waehle_HintergrundFarbe_editGUI

Func _waehle_Hintergrund_neuGUI()
	$i = FileOpenDialog("Bild/Icon wählen", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Bilder & Icons (*.jpg;*jpeg;*.bmp;)", 3, "")
	FileChangeDir(@ScriptDir)
	If $i = "" Then
		GUICtrlSetData($Form_bearbeitenBGImage, "none")
		Return
	EndIf
	GUICtrlSetData($Form_bearbeitenBGImage, $i)
EndFunc   ;==>_waehle_Hintergrund_neuGUI

Func _Show_Edit_Form()
	If Not FileExists($Cache_Datei) Then
		MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), StringReplace(_ISNPlugin_Get_langstring(225), "%1%", $Cache_Datei))
		Return
	EndIf


	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)

	Switch _IniReadEx($Cache_Datei_Handle, "gui", "const_modus", "default")

		Case "default"
			GUICtrlSetState($Form_bearbeiten_konstanten_Programmeinstellungen_checkbox, $GUI_CHECKED)

		Case "numbers"
			GUICtrlSetState($Form_bearbeiten_konstanten_MagicNumbers_checkbox, $GUI_CHECKED)

		Case "variables"
			GUICtrlSetState($Form_bearbeiten_konstanten_Variablen_checkbox, $GUI_CHECKED)

	EndSwitch


	Switch _IniReadEx($Cache_Datei_Handle, "gui", "Handle_deklaration", "default")

		Case "default"
			GUICtrlSetState($Form_Eigenschaften_Deklaration_Default_Radio, $GUI_CHECKED)

		Case ""
			GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Keine_Radio, $GUI_CHECKED)

		Case "Local"
			GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Local_Radio, $GUI_CHECKED)

		Case "Global"
			GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Global_Radio, $GUI_CHECKED)

	EndSwitch

	GUICtrlSetData($Form_bearbeiten_xpos_input, _IniReadEx($Cache_Datei_Handle, "gui", "xpos", "-1"))
	GUICtrlSetData($Form_bearbeiten_ypos_input, _IniReadEx($Cache_Datei_Handle, "gui", "ypos", "-1"))

	If _IniReadEx($Cache_Datei_Handle, "gui", "title_textmode", "normal") = "normal" Then
		GUICtrlSetState($Form_bearbeiten_fenstertitel_radio1, $GUI_CHECKED)
		GUICtrlSetState($Form_bearbeiten_fenstertitel_radio2, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Form_bearbeiten_fenstertitel_radio1, $GUI_UNCHECKED)
		GUICtrlSetState($Form_bearbeiten_fenstertitel_radio2, $GUI_CHECKED)
	EndIf

	If _IniReadEx($Cache_Datei_Handle, "gui", "center_gui", "true") = "true" Then
		GUICtrlSetState($Form_bearbeiten_fenster_zentrieren_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Form_bearbeiten_fenster_zentrieren_checkbox, $GUI_UNCHECKED)
	EndIf

	If _IniReadEx($Cache_Datei_Handle, "gui", "isf_include_once", "false") = "true" Then
		GUICtrlSetState($Form_Eigenschaften_Include_Once_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Form_Eigenschaften_Include_Once_Checkbox, $GUI_UNCHECKED)
	EndIf

	If _IniReadEx($Cache_Datei_Handle, "gui", "only_controls_in_isf", "false") = "true" Then
		GUICtrlSetState($Form_Eigenschaften_Nur_Controls_in_die_isf_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Form_Eigenschaften_Nur_Controls_in_die_isf_Checkbox, $GUI_UNCHECKED)
	EndIf

	If _IniReadEx($Cache_Datei_Handle, "gui", "Handle_deklaration_const", "true") = "true" Then
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_CHECKED)
	Else
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_UNCHECKED)
	EndIf



	GUICtrlSetData($Form_bearbeitenTitel, _IniReadEx($Cache_Datei_Handle, "gui", "title", "#error#"))
	GUICtrlSetData($Form_bearbeitenHoehe, _IniReadEx($Cache_Datei_Handle, "gui", "hoehe", 640))
	GUICtrlSetData($Form_bearbeitenBreite, _IniReadEx($Cache_Datei_Handle, "gui", "breite", 480))
	GUICtrlSetData($Form_bearbeitenBGImage, _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "#error#"))
	GUICtrlSetData($Form_bearbeitenBGColour, _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "#error#"))
	GUICtrlSetData($Form_bearbeitenparentHandle, _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "parent", "")))
	GUICtrlSetBkColor($Form_bearbeitenBGColour, _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "#error#"))


	GUICtrlSetData($Form_bearbeiten_event_close_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_close", ""))
	GUICtrlSetData($Form_bearbeiten_event_minimize_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_minimize", ""))
	GUICtrlSetData($Form_bearbeiten_event_restore_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_restore", ""))
	GUICtrlSetData($Form_bearbeiten_event_maximize_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_maximize", ""))
	GUICtrlSetData($Form_bearbeiten_event_mousemove_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_mousemove", ""))
	GUICtrlSetData($Form_bearbeiten_event_primarydown_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_primarydown", ""))
	GUICtrlSetData($Form_bearbeiten_event_primaryup_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_primaryup", ""))
	GUICtrlSetData($Form_bearbeiten_event_secoundarydown_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_secoundarydown", ""))
	GUICtrlSetData($Form_bearbeiten_event_secoundaryup_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_secoundaryup", ""))
	GUICtrlSetData($Form_bearbeiten_event_resized_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_resized", ""))
	GUICtrlSetData($Form_bearbeiten_event_dropped_input, _IniReadEx($Cache_Datei_Handle, "gui", "gui_event_dropped", ""))

	$read_style = _IniReadEx($Cache_Datei_Handle, "gui", "style", "-1")
	If $read_style = "-1" Then $read_style = ""
	GUICtrlSetData($Form_bearbeitenStyle, $read_style)

	$read_exstyle = _IniReadEx($Cache_Datei_Handle, "gui", "exstyle", "-1")
	If $read_exstyle = "-1" Then $read_exstyle = ""
	GUICtrlSetData($Form_bearbeitenExStyle, $read_exstyle)
	GUICtrlSetData($Form_bearbeitenHandle, _Handle_mit_Dollar_zurueckgeben(_IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui")))

	$wipos = WinGetPos($Studiofenster, "")
	$mon = _GetMonitorFromPoint($wipos[0], $wipos[1])
	_CenterOnMonitor($Form_bearbeitenGUI, "", $mon)
	_GUIEigenschaften_toggle_zentriereGUI()
	_GUIEigenschaften_toggle_Titelmodus()
	_Form_Eigenschaften_Deklaration_Handles_toggle_Radios()
	_Load_styles_for_GUI()
	_Load_exstyles_for_GUI()
	GUISetState(@SW_SHOW, $Form_bearbeitenGUI)
EndFunc   ;==>_Show_Edit_Form

Func _HIDE_Edit_Form()
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_HIDE, $Form_bearbeitenGUI)
	GUISetState(@SW_SHOW, $StudioFenster)
	GUISetState(@SW_SHOW, $GUI_Editor)

	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_HIDE_Edit_Form

Func _Form_Edit_OK()
	If GUICtrlRead($Form_bearbeitenHandle) = "" Then
		MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(65), 0, $Form_bearbeitenGUI)
		Return
	EndIf

	If GUICtrlRead($Form_bearbeitenTitel) = "" Then
		MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(66), 0, $Form_bearbeitenGUI)
		Return
	EndIf

	If GUICtrlRead($Form_bearbeitenHoehe) = "" Then
		MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(67), 0, $Form_bearbeitenGUI)
		Return
	EndIf

	If GUICtrlRead($Form_bearbeitenBreite) = "" Then
		MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(68), 0, $Form_bearbeitenGUI)
		Return
	EndIf

	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_HIDE, $Form_bearbeitenGUI)

	Local $Handle_dek = ""
	If GUICtrlRead($Form_Eigenschaften_Deklaration_Default_Radio) = $GUI_CHECKED Then $Handle_dek = "default"
	If GUICtrlRead($Form_Eigenschaften_Deklaration_Handles_Global_Radio) = $GUI_CHECKED Then $Handle_dek = "global"
	If GUICtrlRead($Form_Eigenschaften_Deklaration_Handles_Local_Radio) = $GUI_CHECKED Then $Handle_dek = "local"

	Local $const_modus = "default"
	If GUICtrlRead($Form_bearbeiten_konstanten_MagicNumbers_checkbox) = $GUI_CHECKED Then $const_modus = "numbers"
	If GUICtrlRead($Form_bearbeiten_konstanten_Variablen_checkbox) = $GUI_CHECKED Then $const_modus = "variables"

	$require_reload = 0
	Local $xpos = GUICtrlRead($Form_bearbeiten_xpos_input)
	If $xpos = "" Then $xpos = 0
	Local $ypos = GUICtrlRead($Form_bearbeiten_ypos_input)
	If $ypos = "" Then $ypos = 0
	Local $ExStyle = GUICtrlRead($Form_bearbeitenExStyle)
	Local $Style = GUICtrlRead($Form_bearbeitenStyle)
	Local $hoehe = Number(GUICtrlRead($Form_bearbeitenHoehe))
	Local $breite = Number(GUICtrlRead($Form_bearbeitenBreite))
	Local $handle = _Handle_mit_Dollar_zurueckgeben(GUICtrlRead($Form_bearbeitenHandle))
	If $ExStyle = "" Then $ExStyle = -1
	If $Style = "" Then $Style = -1

	If GUICtrlRead($Form_bearbeitenBGImage) <> _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "#error#") Then $require_reload = 1

	_IniWriteEx($Cache_Datei_Handle, "gui", "title", StringReplace(GUICtrlRead($Form_bearbeitenTitel), '"', "'"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "xpos", $xpos)
	_IniWriteEx($Cache_Datei_Handle, "gui", "ypos", $ypos)
	_IniWriteEx($Cache_Datei_Handle, "gui", "hoehe", $hoehe)
	_IniWriteEx($Cache_Datei_Handle, "gui", "breite", $breite)
	_IniWriteEx($Cache_Datei_Handle, "gui", "style", $Style)
	_IniWriteEx($Cache_Datei_Handle, "gui", "exstyle", $ExStyle)
	_IniWriteEx($Cache_Datei_Handle, "gui", "bgimage", GUICtrlRead($Form_bearbeitenBGImage))
	_IniWriteEx($Cache_Datei_Handle, "gui", "bgcolour", GUICtrlRead($Form_bearbeitenBGColour))
	_IniWriteEx($Cache_Datei_Handle, "gui", "handle", $handle)
	_IniWriteEx($Cache_Datei_Handle, "gui", "parent", _Handle_mit_Dollar_zurueckgeben(GUICtrlRead($Form_bearbeitenparentHandle)))
	_IniWriteEx($Cache_Datei_Handle, "gui", "Handle_deklaration", $Handle_dek)
	_IniWriteEx($Cache_Datei_Handle, "gui", "const_modus", $const_modus)

	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_close", GUICtrlRead($Form_bearbeiten_event_close_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_minimize", GUICtrlRead($Form_bearbeiten_event_minimize_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_restore", GUICtrlRead($Form_bearbeiten_event_restore_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_maximize", GUICtrlRead($Form_bearbeiten_event_maximize_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_mousemove", GUICtrlRead($Form_bearbeiten_event_mousemove_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_primarydown", GUICtrlRead($Form_bearbeiten_event_primarydown_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_primaryup", GUICtrlRead($Form_bearbeiten_event_primaryup_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_secoundarydown", GUICtrlRead($Form_bearbeiten_event_secoundarydown_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_secoundaryup", GUICtrlRead($Form_bearbeiten_event_secoundaryup_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_resized", GUICtrlRead($Form_bearbeiten_event_resized_input))
	_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_dropped", GUICtrlRead($Form_bearbeiten_event_dropped_input))


	If GUICtrlRead($Form_bearbeiten_fenstertitel_radio1) = $GUI_CHECKED Then
		_IniWriteEx($Cache_Datei_Handle, "gui", "title_textmode", "normal")
	Else
		_IniWriteEx($Cache_Datei_Handle, "gui", "title_textmode", "func")
	EndIf

	If GUICtrlRead($Form_bearbeiten_fenster_zentrieren_checkbox) = $GUI_CHECKED Then
		_IniWriteEx($Cache_Datei_Handle, "gui", "center_gui", "true")
	Else
		_IniWriteEx($Cache_Datei_Handle, "gui", "center_gui", "false")
	EndIf

	If GUICtrlRead($Form_Eigenschaften_Deklaration_als_Const_Deklarieren) = $GUI_CHECKED Then
		_IniWriteEx($Cache_Datei_Handle, "gui", "Handle_deklaration_const", "true")
	Else
		_IniWriteEx($Cache_Datei_Handle, "gui", "Handle_deklaration_const", "false")
	EndIf

	If GUICtrlRead($Form_Eigenschaften_Include_Once_Checkbox) = $GUI_CHECKED Then
		_IniWriteEx($Cache_Datei_Handle, "gui", "isf_include_once", "true")
	Else
		_IniWriteEx($Cache_Datei_Handle, "gui", "isf_include_once", "false")
	EndIf

	If GUICtrlRead($Form_Eigenschaften_Nur_Controls_in_die_isf_Checkbox) = $GUI_CHECKED Then
		_IniWriteEx($Cache_Datei_Handle, "gui", "only_controls_in_isf", "true")
	Else
		_IniWriteEx($Cache_Datei_Handle, "gui", "only_controls_in_isf", "false")
	EndIf

	$size = WinGetClientSize($GUI_Editor)
	$pos = WinGetPos($GUI_Editor)
	If IsArray($size) And IsArray($pos) Then
		$difX = $pos[2] - $size[0]
		$difY = $pos[3] - $size[1]
		$Hoehe_Der_Menueleiste = 0
		If $MENUCONTROL_ID <> "" Then
			$Hoehe_Der_Menueleiste = _WinAPI_GetSystemMetrics($SM_CYMENU)
		EndIf
		WinMove($GUI_Editor, "", 10, 10, $breite + $difX, $hoehe + $difY - $Hoehe_Der_Menueleiste)
	EndIf

	If $require_reload = 1 Then
		;Cache Datei niederschreiben
		_IniCloseFileEx($Cache_Datei_Handle)
		_IniCloseFileEx($Cache_Datei_Handle2)
		$Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
		$Cache_Datei_Handle2 = _IniOpenFile($Cache_Datei2)

		$filebackup = $AktuelleForm_Speicherdatei
		FileCopy($Cache_Datei, $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf", 9)
		_Load_from_file($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf")
		FileDelete($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf")
		$AktuelleForm_Speicherdatei = $filebackup
		Return
	EndIf

	;falls kein reload erforderlich ist:
	WinSetTitle($GUI_Editor, "", StringReplace(GUICtrlRead($Form_bearbeitenTitel), '"', "'"))
	GUISetBkColor(GUICtrlRead($Form_bearbeitenBGColour), $GUI_Editor)

	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_HIDE, $Form_bearbeitenGUI)
	GUISetState(@SW_SHOW, $StudioFenster)
	GUISetState(@SW_SHOW, $GUI_Editor)

EndFunc   ;==>_Form_Edit_OK

Func _edit_Form_BG_KEIEN()
	GUICtrlSetData($Form_bearbeitenBGImage, "none")
EndFunc   ;==>_edit_Form_BG_KEIEN

Dim $aRecords

Func delete_item()
	If Not WinActive($GUI_Editor) Then WinActivate($GUI_Editor)
	If WinActive($GUI_Editor) Or WinActive($Studiofenster) Then
		If $Markiertes_Control_ID = "" Then Return

		If $Markiertes_Control_ID = $TABCONTROL_ID Then
			$handletodelete = _IniReadEx($Cache_Datei_Handle, "tab", "handle", "#ERROR#")
			$inisection = "tab"
		Else
			$handletodelete = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "handle", "#ERROR#")
			$inisection = GUICtrlGetHandle($Markiertes_Control_ID)
		EndIf

		$TAB_IS_DESTROYED = 0
		$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
		If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
		If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then
			MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(216), -1, $Studiofenster)
			Return ;ist gesperrt
		EndIf
		If $Markiertes_Control_ID = $TABCONTROL_ID Then
			$answer = MsgBox(262144 + 36, _ISNPlugin_Get_langstring(73), _ISNPlugin_Get_langstring(72), -1, $Studiofenster)
			If $answer = 7 Then Return
			_IniDeleteEx($Cache_Datei_Handle, "tab")

			$TABCONTROL_ID = ""
			$TAB_IS_DESTROYED = 1

		EndIf
		WinActivate($GUI_Editor)
		GUISwitch($GUI_Editor)
		If $handletodelete = $MENUCONTROL_ID Then
			$MENUCONTROL_ID = ""
			_GUICtrlMenu_SetMenu($GUI_Editor, 0)
		EndIf

		If _IniReadEx($Cache_Datei_Handle, $Section, "type", "") = "toolbar" Then
			_GUICtrlToolbar_Destroy($TOOLBARCONTROL_ID)
			$TOOLBARCONTROL_ID = ""
		EndIf

		If _IniReadEx($Cache_Datei_Handle, $Section, "type", "") = "statusbar" Then
			_GUICtrlStatusBar_Destroy($STATUSBARCONTROL_ID)
			$STATUSBARCONTROL_ID = ""
		EndIf

		GUICtrlDelete($handletodelete)


		_IniDeleteEx($Cache_Datei_Handle, $inisection)
		_IniDeleteEx($Cache_Datei_Handle2, $inisection)

		$zeile = 0
		While 1
			If _GUICtrlListView_GetItemText($controllist, $zeile, 3) = $handletodelete Then
				_GUICtrlListView_DeleteItem(GUICtrlGetHandle($controllist), $zeile)
				ExitLoop
			EndIf
			$zeile = $zeile + 1
			If $zeile > _GUICtrlListView_GetItemCount($controllist) - 1 Then ExitLoop
		WEnd

		Entferne_Makierung()

		If $TAB_IS_DESTROYED = 1 Then ;delete everything in the tab!!!
			$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
			If @error Then
				Sleep(0)
			Else

				$handletodelete = _IniReadEx($Cache_Datei_Handle, "tab", "handle", "#ERROR#")
				GUICtrlDelete($handletodelete)
				_IniDeleteEx($Cache_Datei_Handle, "tab")
				$zeile = 0
				While 1
					If _GUICtrlListView_GetItemText($controllist, $zeile, 3) = $handletodelete Then
						_GUICtrlListView_DeleteItem(GUICtrlGetHandle($controllist), $zeile)
						ExitLoop
					EndIf
					$zeile = $zeile + 1
					If $zeile > _GUICtrlListView_GetItemCount($controllist) - 1 Then ExitLoop
				WEnd

				For $i = 1 To $var[0]

					If _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "-1") > -1 Then
						$inisection = $var[$i]
						$handletodelete = _IniReadEx($Cache_Datei_Handle, $var[$i], "handle", "#ERROR#")
						GUICtrlDelete($handletodelete)

						_IniDeleteEx($Cache_Datei_Handle, $inisection)
						_IniDeleteEx($Cache_Datei_Handle2, $inisection)

						$zeile = 0
						While 1
							If _GUICtrlListView_GetItemText($controllist, $zeile, 3) = $handletodelete Then
								_GUICtrlListView_DeleteItem(GUICtrlGetHandle($controllist), $zeile)
								ExitLoop
							EndIf
							$zeile = $zeile + 1
							If $zeile > _GUICtrlListView_GetItemCount($controllist) - 1 Then ExitLoop
						WEnd
					EndIf
				Next
			EndIf
		EndIf

	EndIf
EndFunc   ;==>delete_item

Func _ControlID_to_Cache2($ID, $NID)
	Local $order = 0
	If $NID = $TABCONTROL_ID Then
		$Section = "tab"
	Else
		$Section = $ID
	EndIf
	$Text = ""
	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	If IsArray($var) Then $order = $var[0] + 1
	_IniWriteEx($Cache_Datei_Handle2, $ID, "type", _IniReadEx($Cache_Datei_Handle, $Section, "type", ""))
	_IniWriteEx($Cache_Datei_Handle, $ID, "order", _IniReadEx($Cache_Datei_Handle, $Section, "order", $order))
	$Text = _IniReadEx($Cache_Datei_Handle, $Section, "text", "")
	If _IniReadEx($Cache_Datei_Handle, $Section, "type", "") = "menu" Then $Text = ""
	_GUICtrlListView_AddItem($controllist, $Text, _typereturnicon(_IniReadEx($Cache_Datei_Handle, $Section, "type", "")))
	_GUICtrlListView_AddSubItem($controllist, _GUICtrlListView_GetItemCount($controllist) - 1, _IniReadEx($Cache_Datei_Handle, $Section, "id", ""), 1)
	_GUICtrlListView_AddSubItem($controllist, _GUICtrlListView_GetItemCount($controllist) - 1, _IniReadEx($Cache_Datei_Handle, $Section, "type", ""), 2)
	_GUICtrlListView_AddSubItem($controllist, _GUICtrlListView_GetItemCount($controllist) - 1, $NID, 3)
	_GUICtrlListView_AddSubItem($controllist, _GUICtrlListView_GetItemCount($controllist) - 1, _IniReadEx($Cache_Datei_Handle, $Section, "order", $order), 4)
	_Sortiere_Listview($controllist, 4, 1)
EndFunc   ;==>_ControlID_to_Cache2

Func _Update_ControlList($handle = "")
	$zeile = 0
	$Text = ""
	$order = 0
	While 1

		If _GUICtrlListView_GetItemText($controllist, $zeile, 3) = $TABCONTROL_ID Then
			$order = _IniReadEx($Cache_Datei_Handle, "tab", "order", "0")
		Else
			$order = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle(_GUICtrlListView_GetItemText($controllist, $zeile, 3)), "order", "0")
		EndIf
		_GUICtrlListView_SetItem($controllist, $order, $zeile, 4)

		If _GUICtrlListView_GetItemText($controllist, $zeile, 3) = $handle Then
			$type = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($handle), "type", "")
			If $handle = $TABCONTROL_ID Then
				$Text = _IniReadEx($Cache_Datei_Handle, "tab", "text", "")
				_GUICtrlListView_SetItem($controllist, $Text, $zeile)
				_GUICtrlListView_SetItem($controllist, _IniReadEx($Cache_Datei_Handle, "tab", "id", ""), $zeile, 1)
			Else
				$Text = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($handle), "text", "")
				If $type = "menu" Then $Text = ""
				_GUICtrlListView_SetItem($controllist, $Text, $zeile)
				_GUICtrlListView_SetItem($controllist, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($handle), "id", ""), $zeile, 1)
			EndIf
			ExitLoop
		EndIf
		$zeile = $zeile + 1
		If $zeile > _GUICtrlListView_GetItemCount($controllist) - 1 Then ExitLoop
	WEnd
	_Sortiere_Listview($controllist, 4, 1)
EndFunc   ;==>_Update_ControlList

Func _Select_Item_IN_List($handle)
	$zeile = 0
	While 1
		If _GUICtrlListView_GetItemText($controllist, $zeile, 3) = $handle Then
			_GUICtrlListView_SetItemSelected($controllist, $zeile, True, True)
			_GUICtrlListView_SetSelectionMark($controllist, $zeile)
			_GUICtrlListView_EnsureVisible(GUICtrlGetHandle($controllist), $zeile)

			ExitLoop
		EndIf
		$zeile = $zeile + 1
		If $zeile > _GUICtrlListView_GetItemCount($controllist) - 1 Then ExitLoop
	WEnd
EndFunc   ;==>_Select_Item_IN_List

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

Func _Mark_by_Handle($hdnl)
	Markiere_Controls_EDIT(Number($hdnl))
EndFunc   ;==>_Mark_by_Handle

Func LoadCursor($szFileName, $hGuiX)
	$hCursor = DllCall("user32.dll", "hwnd", "LoadCursorFromFile", "str", $szFileName)
	$hCursor = $hCursor[0]
	If $hCursor <> 0 Then DllCall("user32.dll", "hwnd", "SetClassLong", "hwnd", $hGuiX, "int", -12, "hwnd", $hCursor)
EndFunc   ;==>LoadCursor

Func ResetCursor($hGuiX)
	DllCall("user32.dll", "hwnd", "SetClassLong", "hwnd", $hGuiX, "int", -12, "hwnd", 32512)
EndFunc   ;==>ResetCursor

Func contextbugfix()
	$old = Opt("MouseCoordMode", 1)
	AdlibUnRegister("contextbugfix")
	WinMove($hChild, "", MouseGetPos(0), MouseGetPos(1), 1, 1, 1)
	MouseClick("right", Default, Default, 1, 0)
	Opt("MouseCoordMode", $old)
EndFunc   ;==>contextbugfix


Func _Erstelle_Contextmenu($type = "", $GUI = $GUI_Editor)
	$ContextMenu = _GUICtrlMenu_CreatePopup()
	$iconpos = 0

	If $Control_Markiert_MULTI = 1 Then $type = "button"
	If ($type = "icon" Or $type = "image") And $Control_Markiert_MULTI = 0 Then
		_GUICtrlMenu_InsertMenuItem($ContextMenu, 0, _ISNPlugin_Get_langstring(215), $idc23)
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1818, 16, 16))
		$iconpos = $iconpos + 1
	EndIf


	If $type = "menu" And $Control_Markiert_MULTI = 0 Then
		_GUICtrlMenu_InsertMenuItem($ContextMenu, 0, _ISNPlugin_Get_langstring(194), $idc22)
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1915, 16, 16))
		$iconpos = $iconpos + 1
	EndIf


	If $type = "listview" And $Control_Markiert_MULTI = 0 Then
		_GUICtrlMenu_InsertMenuItem($ContextMenu, 0, _ISNPlugin_Get_langstring(184), $idc21)
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1256, 16, 16))
		$iconpos = $iconpos + 1
	EndIf


	If $type = "tab" And $Control_Markiert_MULTI = 0 Then
		_GUICtrlMenu_InsertMenuItem($ContextMenu, 0, _ISNPlugin_Get_langstring(74), $idc4)
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1732, 16, 16))
		$iconpos = $iconpos + 1
		_GUICtrlMenu_InsertMenuItem($ContextMenu, 1, _ISNPlugin_Get_langstring(75), $idc2)
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 823, 16, 16))
		$iconpos = $iconpos + 1
		_GUICtrlMenu_InsertMenuItem($ContextMenu, 2, _ISNPlugin_Get_langstring(230), $Contextmenu_Tab_Tabitem_Handle)
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1096, 16, 16))
		$iconpos = $iconpos + 1
		_GUICtrlMenu_InsertMenuItem($ContextMenu, 3, _ISNPlugin_Get_langstring(76), $idc3)
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 922, 16, 16))
		$iconpos = $iconpos + 1

	EndIf

	If $type <> "" Then
		If $Control_Markiert_MULTI = 0 Then
			If $type <> "tab" And $type <> "menu" Then
				_GUICtrlMenu_InsertMenuItem($ContextMenu, 7, _ISNPlugin_Get_langstring(226), $Contextmenu_Textbearbeiten) ;Text bearbeiten
				_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 671, 16, 16))
				$iconpos = $iconpos + 1
			EndIf

			_GUICtrlMenu_InsertMenuItem($ContextMenu, 8, _ISNPlugin_Get_langstring(150), $Contextmenu_Onclickfunc) ;Onclick func
			_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 303, 16, 16))
			$iconpos = $iconpos + 1

			_GUICtrlMenu_InsertMenuItem($ContextMenu, 9, _ISNPlugin_Get_langstring(20), $Contextmenu_Extracode) ;Extracode
			_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1787, 16, 16))
			$iconpos = $iconpos + 1

			_GUICtrlMenu_InsertMenuItem($ContextMenu, 10, "", 0)
			$iconpos = $iconpos + 1
		EndIf
	EndIf


	If $type <> "" Then
		If $type <> "tab" Then
			_GUICtrlMenu_InsertMenuItem($ContextMenu, 20, _ISNPlugin_Get_langstring(77) & @TAB & "Strg+C", $idc10) ;Kopieren
			_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1087, 16, 16))
			$iconpos = $iconpos + 1
		EndIf
	EndIf

	_GUICtrlMenu_InsertMenuItem($ContextMenu, 21, _ISNPlugin_Get_langstring(78) & @TAB & "Strg+V", $idc11) ;Einfügen
	_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 8, 16, 16))
	$iconpos = $iconpos + 1

	If $type <> "" Then
		_GUICtrlMenu_InsertMenuItem($ContextMenu, 22, _ISNPlugin_Get_langstring(79) & @TAB & "Del", $idc12) ;Entfernen
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1173, 16, 16))
		$iconpos = $iconpos + 1
	EndIf


	If $type <> "" Then
		;--Anordnungs menu

		_GUICtrlMenu_InsertMenuItem($ContextMenu, 23, "", 0)
		$iconpos = $iconpos + 1

		$hSubMenu1 = _GUICtrlMenu_CreatePopup()
		_GUICtrlMenu_AddMenuItem($ContextMenu, _ISNPlugin_Get_langstring(125), 14, $hSubMenu1)
		_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 55, 16, 16))
		$iconpos = $iconpos + 1

		$iconpos_sub = 0
		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 0, _ISNPlugin_Get_langstring(126), $idc13)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1682, 24, 24))
		If $Control_Markiert_MULTI = 0 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 0)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 0)
		EndIf
		$iconpos_sub = $iconpos_sub + 1

		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 1, _ISNPlugin_Get_langstring(127), $idc14)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1684, 24, 24))
		If $Control_Markiert_MULTI = 0 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 1)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 1)
		EndIf
		$iconpos_sub = $iconpos_sub + 1

		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 2, _ISNPlugin_Get_langstring(128), $idc15)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1686, 24, 24))
		If $Control_Markiert_MULTI = 0 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 2)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 2)
		EndIf
		$iconpos_sub = $iconpos_sub + 1

		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 3, _ISNPlugin_Get_langstring(129), $idc16)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1676, 24, 24))
		If $Control_Markiert_MULTI = 0 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 3)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 3)
		EndIf
		$iconpos_sub = $iconpos_sub + 1



		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 4, "", 0)
		$iconpos_sub = $iconpos_sub + 1


		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 5, _ISNPlugin_Get_langstring(222), $Contextmenu_Anordnung_space_vertically)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1873, 24, 24))
		If $Control_Markiert_MULTI = 0 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 5)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 5)
		EndIf
		$iconpos_sub = $iconpos_sub + 1


		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 6, _ISNPlugin_Get_langstring(223), $Contextmenu_Anordnung_space_horizontally)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1876, 24, 24))
		If $Control_Markiert_MULTI = 0 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 6)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 6)
		EndIf
		$iconpos_sub = $iconpos_sub + 1


		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 7, "", 0)
		$iconpos_sub = $iconpos_sub + 1



		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 8, _ISNPlugin_Get_langstring(130), $idc17)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1618, 24, 24))
		If $Control_Markiert_MULTI = 1 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 8)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 8)
		EndIf
		$iconpos_sub = $iconpos_sub + 1

		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 9, _ISNPlugin_Get_langstring(131), $idc18)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1629, 24, 24))
		If $Control_Markiert_MULTI = 1 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 9)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 9)
		EndIf
		$iconpos_sub = $iconpos_sub + 1

		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 10, _ISNPlugin_Get_langstring(132), $idc19)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1208, 24, 24))
		If $Control_Markiert_MULTI = 1 Then
			_GUICtrlMenu_SetItemDisabled($hSubMenu1, 10)
		Else
			_GUICtrlMenu_SetItemEnabled($hSubMenu1, 10)
		EndIf
		$iconpos_sub = $iconpos_sub + 1

		_GUICtrlMenu_InsertMenuItem($hSubMenu1, 11, _ISNPlugin_Get_langstring(133), $idc20)
		_GUICtrlMenu_SetItemBmp($hSubMenu1, $iconpos_sub, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 1427, 24, 24))
		$iconpos_sub = $iconpos_sub + 1
	EndIf


	_GUICtrlMenu_InsertMenuItem($ContextMenu, 24, "", 0)
	$iconpos = $iconpos + 1

	_GUICtrlMenu_InsertMenuItem($ContextMenu, 25, _ISNPlugin_Get_langstring(52), $Contextmenu_GUIEigenschaften) ;GUI Eigenschaften
	_GUICtrlMenu_SetItemBmp($ContextMenu, $iconpos, _CreateBitmapFromIcon(_WinAPI_GetSysColor($COLOR_MENU), $smallIconsdll, 780, 16, 16))
	$iconpos = $iconpos + 1
	;----------

	_GUICtrlMenu_TrackPopupMenu($ContextMenu, $GUI)
	_GUICtrlMenu_DestroyMenu($ContextMenu)

EndFunc   ;==>_Erstelle_Contextmenu

Func MiniEditor_Weitere_Aktionen()
	$type = ""
	If $TABCONTROL_ID = $Markiertes_Control_ID Then
		$type = "tab"
	Else
		$type = _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "type", "")
	EndIf
	_Erstelle_Contextmenu($type, $Formstudio_controleditor_GUI)
EndFunc   ;==>MiniEditor_Weitere_Aktionen


; Handle WM_CONTEXTMENU messages
Func WM_CONTEXTMENU($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hMenu
	Local $ContextMenu
	Local Static $bBuffered
	If Not ($hWnd = $GUI_Editor) Then Return
	If _IsPressed("02", $dll) Then Return
	$type = ""
	$Cursor_INFO = GUIGetCursorInfo($GUI_Editor)
	If Not $Cursor_INFO[4] = 0 Then
		If $TABCONTROL_ID = $Cursor_INFO[4] Then
			$type = "tab"
		Else
			$type = _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Cursor_INFO[4]), "type", "")
		EndIf
		If $Control_Markiert_MULTI = 0 Then
			If $Cursor_INFO[4] <> $Markiertes_Control_ID Then Markiere_Controls_EDIT($Cursor_INFO[4])
		EndIf
	EndIf

	If $Cursor_INFO[4] = $Grid_Handle Or $Cursor_INFO[4] = $BGimage Or $Cursor_INFO[4] = 0 Then
		$type = ""
		Entferne_Makierung()
	EndIf
	$old = Opt("MouseCoordMode", 2)
	$Mausposition_bei_Contextmenue_erscheinen = MouseGetPos()
	Opt("MouseCoordMode", $old)
	_Erstelle_Contextmenu($type, $GUI_Editor)

	$bBuffered = False
	Return True
EndFunc   ;==>WM_CONTEXTMENU

Func _MouseGetPos($hWnd = 0)
	Local $tPoint = DllStructCreate("long X;long Y")
	Local $aResult = DllCall("user32.dll", "bool", "GetCursorPos", "ptr", DllStructGetPtr($tPoint))
	If @error Then Return SetError(@error, @extended, 0)
	If $hWnd Then _WinAPI_ScreenToClient($hWnd, $tPoint)
	Local $aReturn[2]
	$aReturn[0] = DllStructGetData($tPoint, 1)
	$aReturn[1] = DllStructGetData($tPoint, 2)
	Return $aReturn
EndFunc   ;==>_MouseGetPos

Func _Show_Setup()

	GUICtrlSetData($Programmeinstellungen_doppelklick_auf_control_Dropdown, "")
	Local $doubleclick_action = ""
	Switch IniRead($Settings_file, "settings", "doubleclick_action", "extracode")
		Case "none"
			$doubleclick_action = _ISNPlugin_Get_langstring(254)

		Case "extracode"
			$doubleclick_action = _ISNPlugin_Get_langstring(20)

		Case "copy"
			$doubleclick_action = _ISNPlugin_Get_langstring(77)

		Case "grid"
			$doubleclick_action = _ISNPlugin_Get_langstring(133)

	EndSwitch
	GUICtrlSetData($Programmeinstellungen_doppelklick_auf_control_Dropdown, _ISNPlugin_Get_langstring(254) & "|" & _ISNPlugin_Get_langstring(20) & "|" & _ISNPlugin_Get_langstring(133) & "|" & _ISNPlugin_Get_langstring(77), $doubleclick_action)

	If IniRead($Settings_file, "settings", "raster", "1") = "1" Then
		GUICtrlSetState($Raster_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Raster_Checkbox, $GUI_UNCHECKED)
	EndIf

	If IniRead($Settings_file, "settings", "repos", "1") = "1" Then
		GUICtrlSetState($Repos_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Repos_Checkbox, $GUI_UNCHECKED)
	EndIf

	If IniRead($Settings_file, "settings", "draw_grid", "0") = "1" Then
		GUICtrlSetState($Zeige_Raster_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Zeige_Raster_checkbox, $GUI_UNCHECKED)
	EndIf

	If IniRead($Settings_file, "settings", "use_isn_skin", "false") = "true" Then
		GUICtrlSetState($Programmeinstellungen_skin_im_Plugin_Checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Programmeinstellungen_skin_im_Plugin_Checkbox, $GUI_UNCHECKED)
	EndIf


	If IniRead($Settings_file, "settings", "showdocklines", "1") = "1" Then
		GUICtrlSetState($Zeige_Ausrichtungslinien_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Zeige_Ausrichtungslinien_checkbox, $GUI_UNCHECKED)
	EndIf


	If IniRead($Settings_file, "settings", "ignore_extracode_when_testing", "0") = "1" Then
		GUICtrlSetState($Extracode_beim_Testen_Ignorieren_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Extracode_beim_Testen_Ignorieren_checkbox, $GUI_UNCHECKED)
	EndIf

	If IniRead($Settings_file, "settings", "ignore_extracode_when_designing", "0") = "1" Then
		GUICtrlSetState($Extracode_beim_Designen_Ignorieren_checkbox, $GUI_CHECKED)
	Else
		GUICtrlSetState($Extracode_beim_Designen_Ignorieren_checkbox, $GUI_UNCHECKED)
	EndIf


	If IniRead($Settings_file, "settings", "Handle_deklaration_const", "false") = "true" Then
		GUICtrlSetState($Einstellungen_Deklaration_als_Const_Deklarieren, $GUI_CHECKED)
	Else
		GUICtrlSetState($Einstellungen_Deklaration_als_Const_Deklarieren, $GUI_UNCHECKED)
	EndIf

	If IniRead($Settings_file, "settings", "const_modus", "variables") = "variables" Then
		GUICtrlSetState($Einstellungen_konstanten_Variablen_checkbox, $GUI_CHECKED)
		GUICtrlSetState($Einstellungen_konstanten_MagicNumbers_checkbox, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Einstellungen_konstanten_Variablen_checkbox, $GUI_UNCHECKED)
		GUICtrlSetState($Einstellungen_konstanten_MagicNumbers_checkbox, $GUI_CHECKED)
	EndIf

	Switch IniRead($Settings_file, "settings", "Handle_deklaration", "")
		Case ""
			GUICtrlSetState($Einstellungen_Deklaration_Handles_Keine_Radio, $GUI_CHECKED)

		Case "global"
			GUICtrlSetState($Einstellungen_Deklaration_Handles_Global_Radio, $GUI_CHECKED)

		Case "local"
			GUICtrlSetState($Einstellungen_Deklaration_Handles_Local_Radio, $GUI_CHECKED)

	EndSwitch




	GUICtrlSetPos($Groessenlimit_Input, 160 * $DPI, 79 * $DPI, 50 * $DPI, 20 * $DPI)
	WinMove($Groessenlimit_Input, "", 160 * $DPI, 79 * $DPI, 50 * $DPI, 20 * $DPI)

	GUICtrlSetPos($config_rasterupdown, 160 * $DPI, 112 * $DPI, 50 * $DPI, 20 * $DPI)
	WinMove($config_rasterupdown, "", 160 * $DPI, 112 * $DPI, 50 * $DPI, 20 * $DPI)

	GUICtrlSetPos($config_abstandsrasterupdown, 160 * $DPI, 143 * $DPI, 50 * $DPI, 20 * $DPI)
	WinMove($config_abstandsrasterupdown, "", 160 * $DPI, 143 * $DPI, 50 * $DPI, 20 * $DPI)


	GUICtrlSetData($config_abstandsrasterupdown, IniRead($Settings_file, "settings", "spacing_distance", "8"))
	GUICtrlSetData($config_rasterupdown, IniRead($Settings_file, "settings", "raster_size", "10"))
	GUICtrlSetData($Groessenlimit_Input, IniRead($Settings_file, "settings", "sizelimit", "4"))

	GUISetState(@SW_DISABLE, $MiniEditor)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)

	$wipos = WinGetPos($Studiofenster, "")
	$mon = _GetMonitorFromPoint($wipos[0], $wipos[1])
	_CenterOnMonitor($Setup_GUI, "", $mon)
	_einstellungen_radio_event()
	GUISetState(@SW_SHOW, $Setup_GUI)
EndFunc   ;==>_Show_Setup

Func _einstellungen_radio_event()
	If GUICtrlRead($Einstellungen_Deklaration_Handles_Keine_Radio) = $GUI_CHECKED Then
		GUICtrlSetState($Einstellungen_Deklaration_als_Const_Deklarieren, $GUI_DISABLE)
		GUICtrlSetState($Einstellungen_Deklaration_als_Const_Deklarieren, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($Einstellungen_Deklaration_als_Const_Deklarieren, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_einstellungen_radio_event

Func _Hide_Setup()

	Switch GUICtrlRead($Programmeinstellungen_doppelklick_auf_control_Dropdown)
		Case _ISNPlugin_Get_langstring(254) ;none
			IniWrite($Settings_file, "settings", "doubleclick_action", "none")
			$FormStudio_doubleclick_action = "none"

		Case _ISNPlugin_Get_langstring(20) ;extracode
			IniWrite($Settings_file, "settings", "doubleclick_action", "extracode")
			$FormStudio_doubleclick_action = "extracode"

		Case _ISNPlugin_Get_langstring(77) ;copy
			IniWrite($Settings_file, "settings", "doubleclick_action", "copy")
			$FormStudio_doubleclick_action = "copy"

		Case _ISNPlugin_Get_langstring(133) ;grid
			IniWrite($Settings_file, "settings", "doubleclick_action", "grid")
			$FormStudio_doubleclick_action = "grid"

	EndSwitch

	IniWrite($Settings_file, "settings", "sizelimit", GUICtrlRead($Groessenlimit_Input))
	$GroesenLimit = GUICtrlRead($Groessenlimit_Input)

	IniWrite($Settings_file, "settings", "raster_size", GUICtrlRead($config_rasterupdown))
	$raster = GUICtrlRead($config_rasterupdown)

	IniWrite($Settings_file, "settings", "spacing_distance", GUICtrlRead($config_abstandsrasterupdown))
	$Anordnungsraster = GUICtrlRead($config_abstandsrasterupdown)

	If GUICtrlRead($Raster_Checkbox) = $GUI_CHECKED Then
		$Use_raster = 1
		IniWrite($Settings_file, "settings", "raster", "1")
	Else
		$Use_raster = 0
		IniWrite($Settings_file, "settings", "raster", "0")
	EndIf

	If GUICtrlRead($Programmeinstellungen_skin_im_Plugin_Checkbox) = $GUI_CHECKED Then
		$Use_ISN_Skin = "true"
		IniWrite($Settings_file, "settings", "use_isn_skin", "true")
	Else
		$Use_ISN_Skin = "false"
		IniWrite($Settings_file, "settings", "use_isn_skin", "false")
	EndIf


	If GUICtrlRead($Repos_Checkbox) = $GUI_CHECKED Then
		$Use_repos = 1
		IniWrite($Settings_file, "settings", "repos", "1")
	Else
		$Use_repos = 0
		IniWrite($Settings_file, "settings", "repos", "0")
	EndIf

	If GUICtrlRead($Extracode_beim_Testen_Ignorieren_checkbox) = $GUI_CHECKED Then
		$Extracode_beim_Testen_Ignorieren = 1
		IniWrite($Settings_file, "settings", "ignore_extracode_when_testing", "1")
	Else
		$Extracode_beim_Testen_Ignorieren = 0
		IniWrite($Settings_file, "settings", "ignore_extracode_when_testing", "0")
	EndIf

	If GUICtrlRead($Extracode_beim_Designen_Ignorieren_checkbox) = $GUI_CHECKED Then
		$Extracode_beim_Designen_Ignorieren = 1
		IniWrite($Settings_file, "settings", "ignore_extracode_when_designing", "1")
	Else
		$Extracode_beim_Designen_Ignorieren = 0
		IniWrite($Settings_file, "settings", "ignore_extracode_when_designing", "0")
	EndIf


	If GUICtrlRead($Zeige_Raster_checkbox) = $GUI_CHECKED Then
		$Draw_grid_in_gui = 1
		IniWrite($Settings_file, "settings", "draw_grid", "1")
	Else
		$Draw_grid_in_gui = 0
		IniWrite($Settings_file, "settings", "draw_grid", "0")
	EndIf

	If GUICtrlRead($Zeige_Ausrichtungslinien_checkbox) = $GUI_CHECKED Then
		$Show_docklines = 1
		IniWrite($Settings_file, "settings", "showdocklines", "1")
	Else
		$Show_docklines = 0
		IniWrite($Settings_file, "settings", "showdocklines", "0")
	EndIf

	If GUICtrlRead($Einstellungen_konstanten_MagicNumbers_checkbox) = $GUI_CHECKED Then
		$FormStudio_Global_const_modus = "numbers"
		IniWrite($Settings_file, "settings", "const_modus", "numbers")
	Else
		$FormStudio_Global_const_modus = "variables"
		IniWrite($Settings_file, "settings", "const_modus", "variables")
	EndIf


	If GUICtrlRead($Einstellungen_Deklaration_als_Const_Deklarieren) = $GUI_CHECKED Then
		$FormStudio_Global_Handle_deklaration_const = "true"
		IniWrite($Settings_file, "settings", "Handle_deklaration_const", "true")
	Else
		$FormStudio_Global_Handle_deklaration_const = "false"
		IniWrite($Settings_file, "settings", "Handle_deklaration_const", "false")
	EndIf

	If GUICtrlRead($Einstellungen_Deklaration_Handles_Keine_Radio) = $GUI_CHECKED Then
		$FormStudio_Global_Handle_deklaration = ""
		IniWrite($Settings_file, "settings", "Handle_deklaration", "")
	EndIf

	If GUICtrlRead($Einstellungen_Deklaration_Handles_Global_Radio) = $GUI_CHECKED Then
		$FormStudio_Global_Handle_deklaration = "global"
		IniWrite($Settings_file, "settings", "Handle_deklaration", "global")
	EndIf

	If GUICtrlRead($Einstellungen_Deklaration_Handles_Local_Radio) = $GUI_CHECKED Then
		$FormStudio_Global_Handle_deklaration = "local"
		IniWrite($Settings_file, "settings", "Handle_deklaration", "local")
	EndIf

	GUISetState(@SW_ENABLE, $MiniEditor)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $Setup_GUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	GUICtrlDelete($Grid_Handle)
	If $Draw_grid_in_gui = "1" Then _DrawGrid($raster, $Grid_Farbe)
EndFunc   ;==>_Hide_Setup

Func _Set_Studio_Title($file = "none")
	Return
	If $file = "none" Then
		WinSetTitle($StudioFenster, "", "ISN AutoIT Form Studio")
	Else
		WinSetTitle($StudioFenster, "", "ISN AutoIT Form Studio (" & $file & ")")
	EndIf
EndFunc   ;==>_Set_Studio_Title

Func _Delete_Multiitem()
	$DESTROY_TAB_ALSO = 0
	If Not IsArray($Markierte_Controls_IDs) Then Return
	GUISetState(@SW_LOCK, $GUI_Editor)
	For $i = 1 To $Markierte_Controls_IDs[0]

		$inisection = GUICtrlGetHandle($Markierte_Controls_IDs[$i])
		$handletodelete = _IniReadEx($Cache_Datei_Handle, $inisection, "handle", "#ERROR#")
		$Section = GUICtrlGetHandle($Markierte_Controls_IDs[$i])
		If $Markierte_Controls_IDs[$i] = $TABCONTROL_ID Then $Section = "tab"
		If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 1 Then ContinueLoop ;Überspringe gelockte Elemente
		If $handletodelete = $MENUCONTROL_ID Then
			$MENUCONTROL_ID = ""
			_GUICtrlMenu_SetMenu($GUI_Editor, 0)
		EndIf
		GUICtrlDelete($handletodelete)

		_IniDeleteEx($Cache_Datei_Handle, $inisection)
		_IniDeleteEx($Cache_Datei_Handle2, $inisection)
		If $Markierte_Controls_IDs[$i] = $TABCONTROL_ID Then
			If _IniReadEx($Cache_Datei_Handle, "tab", "locked", 0) = 0 Then $DESTROY_TAB_ALSO = 1
		EndIf
		$zeile = 0
		While 1
			If _GUICtrlListView_GetItemText($controllist, $zeile, 3) = $handletodelete Then
				_GUICtrlListView_DeleteItem(GUICtrlGetHandle($controllist), $zeile)
				ExitLoop
			EndIf
			$zeile = $zeile + 1
			If $zeile > _GUICtrlListView_GetItemCount($controllist) - 1 Then ExitLoop
		WEnd

	Next

	;remove tab also
	If $DESTROY_TAB_ALSO = 1 Then
		$handletodelete = _IniReadEx($Cache_Datei_Handle, "tab", "handle", "#ERROR#")
		GUICtrlDelete($handletodelete)
		_IniDeleteEx($Cache_Datei_Handle, "tab")
		$zeilee = 0
		While 1
			If _GUICtrlListView_GetItemText($controllist, $zeilee, 3) = $handletodelete Then
				_GUICtrlListView_DeleteItem(GUICtrlGetHandle($controllist), $zeilee)
				ExitLoop
			EndIf
			$zeilee = $zeilee + 1
			If $zeilee > _GUICtrlListView_GetItemCount($controllist) - 1 Then ExitLoop
		WEnd

		$TABCONTROL_ID = ""
		$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
		If @error Then
;~     MsgBox(16, "", "Die Datei "&$Cache_Datei2&" kann nicht gelesen werden!")
		Else
			For $i = 1 To $var[0]

				If _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "-1") > -1 Then
					$inisection = $var[$i]
					$handletodelete = _IniReadEx($Cache_Datei_Handle, $var[$i], "handle", "#ERROR#")
					If $handletodelete = $MENUCONTROL_ID Then
						$MENUCONTROL_ID = ""
						_GUICtrlMenu_SetMenu($GUI_Editor, 0)
					EndIf
					GUICtrlDelete($handletodelete)

					_IniDeleteEx($Cache_Datei_Handle, $inisection)
					_IniDeleteEx($Cache_Datei_Handle2, $inisection)

					$zeile = 0
					While 1
						If _GUICtrlListView_GetItemText($controllist, $zeile, 3) = $handletodelete Then
							_GUICtrlListView_DeleteItem(GUICtrlGetHandle($controllist), $zeile)
							ExitLoop
						EndIf
						$zeile = $zeile + 1
						If $zeile > _GUICtrlListView_GetItemCount($controllist) - 1 Then ExitLoop
					WEnd
				EndIf
			Next
		EndIf

	EndIf

	Entferne_Makierung()

	GUISetState(@SW_UNLOCK, $GUI_Editor)
EndFunc   ;==>_Delete_Multiitem


Func WM_COMMAND($hWndGUI, $MsgID, $wParam, $lParam)
	$NID = BitAND($wParam, 0x0000FFFF)
	If BitAND(GUICtrlGetState($StudioFenster_inside_Text1), $GUI_SHOW) = $GUI_SHOW Then Return


	;"Klassische" Events
	Switch $wParam


		Case $menueditor_treeviewmenu0
			_Menu_Editor_Neuen_Menuepunkt_hinzufuegen()
		Case $menueditor_treeviewmenu1
			_Menu_Editor_Neuen_untermenuepunkt_hinzufuegen()
		Case $menueditor_treeviewmenu2
			_Menu_Editor_element_loeschen()

		Case $idc22
			_Show_Menueditor()
		Case $idc23
			_Show_ChoosePIC()
		Case $idc2
			_Rename_tabpage()
		Case $Contextmenu_Tab_Tabitem_Handle
			_Handle_fuer_tabpage_festlegen()
		Case $idc21
			_Listview_Zeige_Spalteneditor()
		Case $idc4
			_Add_Page_to_TAB()
		Case $idc3
			_delete_Tab()
		Case $Contextmenu_Textbearbeiten
			_Zeige_Erweiterten_Text()
		Case $Contextmenu_GUIEigenschaften
			_Show_Edit_Form()
		Case $Contextmenu_Extracode
			_Show_Extracode()
		Case $Contextmenu_Onclickfunc
			_Show_Funcs()
		Case $idc10
			copy_item()
		Case $idc11
			paste_item(1)
		Case $idc12
			If $Control_Markiert_MULTI = 0 Then
				delete_item()
			Else
				_Delete_Multiitem()
			EndIf

		Case $idc13
			_Controls_ausrichten_links()
		Case $idc14
			_Controls_ausrichten_rechts()
		Case $idc15
			_Controls_ausrichten_oben()
		Case $idc16
			_Controls_ausrichten_unten()
		Case $idc17
			_Control_horizontal_zentrieren()
		Case $idc18
			_Control_vertical_zentrieren()
		Case $idc19
			_Control_zentrieren()
		Case $idc20
			_Am_Raster_Ausrichten()
		Case $Contextmenu_Anordnung_space_vertically
			_Controls_space_vertically()
		Case $Contextmenu_Anordnung_space_horizontally
			_Controls_space_horizontally()
	EndSwitch




EndFunc   ;==>WM_COMMAND


Func _Controls_space_vertically()
	If $Control_Markiert_MULTI <> 1 Then Return
	$Start_Y = 9999999

	Dim $Positionen_der_controls[1][1]
	For $i = 1 To $Markierte_Controls_IDs[0]
		$data = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "y", 0) ; + _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "height", 0)
		$Start_Y = _Min($Start_Y, Number($data))
		_Array2D_Inset($Markierte_Controls_Sections[$i - 1] & "|" & $Markierte_Controls_IDs[$i] & "|" & $data & "|" & $i, $Positionen_der_controls, $i, 0)
	Next

	;Strings in Zahlen umwandeln und Sortieren
	For $i = 0 To UBound($Positionen_der_controls) - 1
		$Positionen_der_controls[$i][2] = Number($Positionen_der_controls[$i][2])
	Next
	_ArraySort($Positionen_der_controls, 0, 0, 0, 2)

	For $i = 0 To UBound($Positionen_der_controls) - 1
		If $Positionen_der_controls[$i][0] = "" Then ContinueLoop
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Positionen_der_controls[$i][1]))
		If _IniReadEx($Cache_Datei_Handle, $Positionen_der_controls[$i][0], "locked", 0) = 0 Then
			GUICtrlSetPos($Positionen_der_controls[$i][1], $Pos_C[0], $Start_Y, $Pos_C[2], $Pos_C[3])
			_Aktualisiere_Rahmen_Multi($Positionen_der_controls[$i][3] - 1, $Positionen_der_controls[$i][1])
			_IniWriteEx($Cache_Datei_Handle, $Positionen_der_controls[$i][0], "y", $Start_Y)
			$Start_Y = $Start_Y + $Pos_C[3] + Number($Anordnungsraster)
		EndIf
	Next
EndFunc   ;==>_Controls_space_vertically

Func _Controls_space_horizontally()
	If $Control_Markiert_MULTI <> 1 Then Return
	$Start_X = 9999999

	Dim $Positionen_der_controls[1][1]
	For $i = 1 To $Markierte_Controls_IDs[0]
		$data = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "x", 0) ; + _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "height", 0)
		$Start_X = _Min($Start_X, Number($data))
		_Array2D_Inset($Markierte_Controls_Sections[$i - 1] & "|" & $Markierte_Controls_IDs[$i] & "|" & $data & "|" & $i, $Positionen_der_controls, $i, 0)
	Next

	;Strings in Zahlen umwandeln und Sortieren
	For $i = 0 To UBound($Positionen_der_controls) - 1
		$Positionen_der_controls[$i][2] = Number($Positionen_der_controls[$i][2])
	Next
	_ArraySort($Positionen_der_controls, 0, 0, 0, 2)

	For $i = 0 To UBound($Positionen_der_controls) - 1
		If $Positionen_der_controls[$i][0] = "" Then ContinueLoop
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Positionen_der_controls[$i][1]))
		If _IniReadEx($Cache_Datei_Handle, $Positionen_der_controls[$i][0], "locked", 0) = 0 Then
			GUICtrlSetPos($Positionen_der_controls[$i][1], $Start_X, $Pos_C[1], $Pos_C[2], $Pos_C[3])
			_Aktualisiere_Rahmen_Multi($Positionen_der_controls[$i][3] - 1, $Positionen_der_controls[$i][1])
			_IniWriteEx($Cache_Datei_Handle, $Positionen_der_controls[$i][0], "x", $Start_X)
			$Start_X = $Start_X + $Pos_C[2] + Number($Anordnungsraster)
		EndIf
	Next
EndFunc   ;==>_Controls_space_horizontally

Func _Ziehe_Rahmen()
	If $Control_Markiert_MULTI = 1 Then Return
	If $Ziehe_Gerade = 1 Then Return
	$MousePos = MouseGetPos()
	If Not IsArray($MousePos) Then Return
	$StartpunktX = $MousePos[0]
	$StartpunktY = $MousePos[1]
	$Cursor_NFO = GUIGetCursorInfo($GUI_Editor)
	$Ziehe_Gerade = 1
	Verstecke_Markierungen() ;Markierungen zuerst schnell verstecken (und erst später löschen)
	GUISwitch($GUI_Editor)
	$pull_links = GUICtrlCreatePic(@ScriptDir & "\data\rahmen.jpg", $StartpunktX, $StartpunktY, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$pull_oben = GUICtrlCreatePic(@ScriptDir & "\data\rahmen.jpg", $StartpunktX, $StartpunktY, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$pull_rechts = GUICtrlCreatePic(@ScriptDir & "\data\rahmen.jpg", $StartpunktX, $StartpunktY, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	$pull_unten = GUICtrlCreatePic(@ScriptDir & "\data\rahmen.jpg", $StartpunktX, $StartpunktY, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	If $TABCONTROL_ID = "" Then
		$IgnoreTabExept = -1
	Else
		$IgnoreTabExept = _GUICtrlTab_GetCurSel($TABCONTROL_ID)
	EndIf



	While _IsPressed("01", $dll)
		$MousePos = MouseGetPos()

		$winpos = WinGetClientSize($GUI_Editor)

		$pos = ControlGetPos($GUI_Editor, "", $pull_links)
		If Not IsArray($pos) Then Return
		$y = $StartpunktY
		$hoehe = $MousePos[1] - $pos[1]
		If $MousePos[1] < $StartpunktY Then
			$y = $MousePos[1]
			$hoehe = $StartpunktY - $y
		EndIf
		If $y = -1 Then $y = 0
		If $hoehe = -1 Then $hoehe = 0
		GUICtrlSetPos($pull_links, $pos[0], $y, $pos[2], $hoehe)

		$pos = ControlGetPos($GUI_Editor, "", $pull_oben)
		$pos1 = ControlGetPos($GUI_Editor, "", $pull_links)
		$x = $StartpunktX
		$y = $StartpunktY
		$breite = $MousePos[0] - $pos[0]
		If $MousePos[1] < $StartpunktY Then
			$y = $MousePos[1]
		EndIf
		If $MousePos[0] < $StartpunktX Then
			$x = $MousePos[0]
			$breite = $pos1[0] - $MousePos[0]
		EndIf
		If $x = -1 Then $x = 0
		If $y = -1 Then $y = 0
		If $breite = -1 Then $breite = 0
		GUICtrlSetPos($pull_oben, $x, $y, $breite, $pos[3])

		$pos = ControlGetPos($GUI_Editor, "", $pull_links)
		$pos1 = ControlGetPos($GUI_Editor, "", $pull_rechts)
		$pos2 = ControlGetPos($GUI_Editor, "", $pull_oben)
		$y = $StartpunktY
		$hoehe = $MousePos[1] - $pos[1]
		$x = $pos2[0] + $pos2[2]
		If $MousePos[1] < $StartpunktY Then
			$y = $pos[1]
			$hoehe = $pos[3]
		EndIf
		If $MousePos[0] < $StartpunktX Then
			$x = $MousePos[0]
		EndIf
		If $x = -1 Then $x = 0
		If $y = -1 Then $y = 0
		If $hoehe = -1 Then $hoehe = 0
		GUICtrlSetPos($pull_rechts, $x, $y, $pos1[2], $hoehe)

		$pos = ControlGetPos($GUI_Editor, "", $pull_unten)
		$pos1 = ControlGetPos($GUI_Editor, "", $pull_links)
		$x = $StartpunktX
		$breite = $MousePos[0] - $pos[0]
		If $MousePos[0] < $StartpunktX Then
			$x = $MousePos[0]
			$breite = $pos1[0] - $MousePos[0]
		EndIf
		If $x = -1 Then $x = 0
		If $breite = -1 Then $breite = 0
		GUICtrlSetPos($pull_unten, $x, $pos1[1] + $pos1[3], $breite, $pos[3])

		Sleep(10)
	WEnd

	If Not $Markiertes_Control_ID = "" And $Control_Markiert_MULTI = 0 Then _Mini_Editor_Einstellungen_Uebernehmen()

	If IsArray($Cursor_NFO) Then
		If ($Markiertes_Control_ID <> $Cursor_NFO[4]) Then
			Entferne_Makierung()
		EndIf
	EndIf
	If $Markiertes_Control_ID = $Cursor_NFO[4] And $Markiertes_Control_ID <> "" Then
		Zeige_Markierungen()
		GUICtrlDelete($pull_links)
		GUICtrlDelete($pull_oben)
		GUICtrlDelete($pull_unten)
		GUICtrlDelete($pull_rechts)
		$Ziehe_Gerade = 0
		Return
	EndIf


	$pos = ControlGetPos($GUI_Editor, "", $pull_links)
	$pos1 = ControlGetPos($GUI_Editor, "", $pull_oben)
	$pos2 = ControlGetPos($GUI_Editor, "", $pull_rechts)
	$pos3 = ControlGetPos($GUI_Editor, "", $pull_unten)

	If Not IsArray($pos1) Then Return
	If Not IsArray($pos) Then Return
	If Not IsArray($pos2) Then Return
	If Not IsArray($pos3) Then Return

	$ObenLinksX = $pos1[0]
	$ObenLinksY = $pos[1]
	$ObenRechtsX = $pos1[0] + $pos1[2]
	$ObenRechtsY = $pos[1]
	$LinksuntenX = $pos1[0]
	$LinksuntenY = $pos[1] + $pos[3]
	$RechtsuntenX = $pos3[0] + $pos3[2]
	$RechtsuntenY = $pos[1] + $pos[3]

	GUICtrlDelete($pull_links)
	GUICtrlDelete($pull_oben)
	GUICtrlDelete($pull_unten)
	GUICtrlDelete($pull_rechts)

	_ArrayDelete($Markierte_Controls_IDs, 200)
	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	If @error Then
		$counter = 0
	Else
		$counter = 0

		For $i = 1 To $var[0]
			$Markieremich = 0
			If $var[$i] = GUICtrlGetHandle($TABCONTROL_ID) Then $var[$i] = "tab"
			If _IniReadEx($Cache_Datei_Handle, $var[$i], "x", 0) > $ObenLinksX - 1 And _
					_IniReadEx($Cache_Datei_Handle, $var[$i], "x", 0) < $RechtsuntenX + 1 And _
					_IniReadEx($Cache_Datei_Handle, $var[$i], "y", 0) > $ObenLinksY - 1 And _
					_IniReadEx($Cache_Datei_Handle, $var[$i], "y", 0) < $RechtsuntenY + 1 Then $Markieremich = 1

			;Markiere nur controls auf gewähltem tab
			$read = _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", -1)
			If $read <> -1 Then
				If _IniReadEx($Cache_Datei_Handle, $var[$i], "type", "") <> "tab" Then
					If $read <> $IgnoreTabExept Then $Markieremich = 0
				EndIf
			EndIf

			If $Markieremich = 1 Then

				_ArrayInsert($Markierte_Controls_IDs, $counter, _IniReadEx($Cache_Datei_Handle, $var[$i], "handle", 0))
				Markiere_Control_Multi($Markierte_Controls_IDs[$counter], $counter, $var[$i])
				$counter = $counter + 1

			EndIf
		Next

		_ArrayInsert($Markierte_Controls_IDs, 0, $counter)
	EndIf
	_SetStatustext($counter & " " & _ISNPlugin_Get_langstring(80))
	If $counter > 0 Then $Control_Markiert_MULTI = 1
	If $counter = 1 Then ;Switch from Multi to single mode
		$Single_Control = $Markierte_Controls_IDs[1]
		Entferne_Makierung()
		$Control_Markiert_MULTI = 0
		_Mark_by_Handle($Single_Control)
	EndIf

	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	$Ziehe_Gerade = 0

EndFunc   ;==>_Ziehe_Rahmen

Func _Markiere_alle_controls()
	If $Ziehe_Gerade = 1 Then Return
	$Ziehe_Gerade = 1
	$editor_groesse = WinGetClientSize($GUI_Editor)
	$ObenLinksX = 0
	$ObenLinksY = 0
	$ObenRechtsX = $editor_groesse[0]
	$ObenRechtsY = 0
	$LinksuntenX = 0
	$LinksuntenY = $editor_groesse[1]
	$RechtsuntenX = $editor_groesse[0]
	$RechtsuntenY = $editor_groesse[1]

	_ArrayDelete($Markierte_Controls_IDs, 200)
	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	If @error Then
		$counter = 0
	Else
		$counter = 0
		For $i = 1 To $var[0]
			$Markieremich = 0
			If $var[$i] = GUICtrlGetHandle($TABCONTROL_ID) Then $var[$i] = "tab"
			If _IniReadEx($Cache_Datei_Handle, $var[$i], "x", 0) > $ObenLinksX - 1 And _
					_IniReadEx($Cache_Datei_Handle, $var[$i], "x", 0) < $RechtsuntenX + 1 And _
					_IniReadEx($Cache_Datei_Handle, $var[$i], "y", 0) > $ObenLinksY - 1 And _
					_IniReadEx($Cache_Datei_Handle, $var[$i], "y", 0) < $RechtsuntenY + 1 Then $Markieremich = 1

			If $Markieremich = 1 Then
				_ArrayInsert($Markierte_Controls_IDs, $counter, _IniReadEx($Cache_Datei_Handle, $var[$i], "handle", 0))
				Markiere_Control_Multi($Markierte_Controls_IDs[$counter], $counter, $var[$i])
				$counter = $counter + 1

			EndIf
		Next
		_ArrayInsert($Markierte_Controls_IDs, 0, $counter)
	EndIf
	_SetStatustext($counter & " " & _ISNPlugin_Get_langstring(80))
	If $counter > 0 Then $Control_Markiert_MULTI = 1
	If $counter = 1 Then
		Entferne_Makierung()
		$Control_Markiert_MULTI = 0
		_Mark_by_Handle($Markierte_Controls_IDs[1])
	EndIf
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	$Ziehe_Gerade = 0
EndFunc   ;==>_Markiere_alle_controls





Func _Resize_Control_Nach_Rechts_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old

	$Opt_old = Opt('MouseCoordMode', 0)
	;prüfe ob min. 1 control bewegt werden darf
	For $u = 0 To $Markierte_Controls_IDs[0]
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then
			_ArraySwap($Markierte_Controls_Sections, 0, $u)
			_ArraySwap($Markierte_Controls_IDs, 1, $u + 1)
			_ArraySwap($Resize_Oben_Links_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Links_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Links_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Rechts_Mitte_Multi, 0, $u)
		EndIf
	Next
	If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then Return ;alle gesperrt

	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()

	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			$MousePos = MouseGetPos()
			$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
			$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[1])
			If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
			$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
			$neue_breite = $Alte_Breite - ($x_Offset - ($MousePos[0] - $pos[0]))
			$Breiten_Diff = $Alte_Breite - $neue_breite
			If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
			GUICtrlSetPos($Markierte_Controls_IDs[1], $Pos_C[0], $Pos_C[1], $neue_breite)
			_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
			For $r = 2 To $Markierte_Controls_IDs[0]
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
				If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
				$neue_breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0)) - $Breiten_Diff
				If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_W[0], $Pos_W[1], $neue_breite)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd
	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "width", $Pos_C[2])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "width", $Pos_C[2])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	_Redraw_Window()


	Opt('MouseCoordMode', $Opt_old)
EndFunc   ;==>_Resize_Control_Nach_Rechts_Multi


Func _Resize_Control_Nach_Links_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old
	$Opt_old = Opt('MouseCoordMode', 0)
	;prüfe ob min. 1 control bewegt werden darf
	For $u = 0 To $Markierte_Controls_IDs[0]
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then
			_ArraySwap($Markierte_Controls_Sections, 0, $u)
			_ArraySwap($Markierte_Controls_IDs, 1, $u + 1)
			_ArraySwap($Resize_Oben_Links_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Links_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Links_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Rechts_Mitte_Multi, 0, $u)
		EndIf
	Next
	If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then Return ;alle gesperrt

	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()

	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			$MousePos = MouseGetPos()
			$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
			$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[1])
			If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
			$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
			$Alte_X = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "x", 0))
			$neue_X = $Alte_X - ($x_Offset - ($MousePos[0] - $Alte_X))
			$X_Diff = $Alte_X - $neue_X
			$neue_breite = $Alte_Breite + $X_Diff
			$Breiten_Diff = $Alte_Breite - $neue_breite
			If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
			If $neue_X < $GroesenLimit Then $neue_Y = $GroesenLimit
			If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
			GUICtrlSetPos($Markierte_Controls_IDs[1], $neue_X, $Pos_C[1], $neue_breite)
			_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
			For $r = 2 To $Markierte_Controls_IDs[0]
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
				If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
				$Alte_X = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "x", 0))
				$neue_X = $Alte_X - $X_Diff
				$neue_breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0)) - $Breiten_Diff
				$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
				If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
				If $neue_X < $GroesenLimit Then $neue_Y = $GroesenLimit
				If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $neue_X, $Pos_W[1], $neue_breite)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd
	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "x", $Pos_C[0])
			_IniWriteEx($Cache_Datei_Handle, "tab", "width", $Pos_C[2])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_C[0])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "width", $Pos_C[2])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	_Redraw_Window()


	Opt('MouseCoordMode', $Opt_old)
EndFunc   ;==>_Resize_Control_Nach_Links_Multi



Func _Resize_Control_Nach_Unten_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old
	$Opt_old = Opt('MouseCoordMode', 0)
	;prüfe ob min. 1 control bewegt werden darf
	For $u = 0 To $Markierte_Controls_IDs[0]
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then
			_ArraySwap($Markierte_Controls_Sections, 0, $u)
			_ArraySwap($Markierte_Controls_IDs, 1, $u + 1)
			_ArraySwap($Resize_Oben_Links_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Links_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Links_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Rechts_Mitte_Multi, 0, $u)
		EndIf
	Next
	If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then Return ;alle gesperrt

	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()

	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			$MousePos = MouseGetPos()
			$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
			$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[1])
			If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
			$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))
			$neue_hoehe = $Alte_hoehe - ($y_Offset - ($MousePos[1] - $pos[1]))
			$Hoehen_Diff = $Alte_hoehe - $neue_hoehe
			If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
			GUICtrlSetPos($Markierte_Controls_IDs[1], $Pos_C[0], $Pos_C[1], $Pos_C[2], $neue_hoehe)
			_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
			For $r = 2 To $Markierte_Controls_IDs[0]
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
				If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
				$neue_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0)) - $Hoehen_Diff
				If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_W[0], $Pos_W[1], $Pos_W[2], $neue_hoehe)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd
	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "height", $Pos_C[3])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "height", $Pos_C[3])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	_Redraw_Window()


	Opt('MouseCoordMode', $Opt_old)
EndFunc   ;==>_Resize_Control_Nach_Unten_Multi



Func _Resize_Control_Nach_Rechts_Unten_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old

	$Opt_old = Opt('MouseCoordMode', 0)
	;prüfe ob min. 1 control bewegt werden darf
	For $u = 0 To $Markierte_Controls_IDs[0]
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then
			_ArraySwap($Markierte_Controls_Sections, 0, $u)
			_ArraySwap($Markierte_Controls_IDs, 1, $u + 1)
			_ArraySwap($Resize_Oben_Links_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Links_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Links_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Rechts_Mitte_Multi, 0, $u)
		EndIf
	Next
	If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then Return ;alle gesperrt

	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()

	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			$MousePos = MouseGetPos()
			$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
			$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[1])
			If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
			$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
			$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))
			$neue_breite = $Alte_Breite - ($x_Offset - ($MousePos[0] - $pos[0]))
			$neue_hoehe = $Alte_hoehe - ($y_Offset - ($MousePos[1] - $pos[1]))
			$Breiten_Diff = $Alte_Breite - $neue_breite
			$Hoehen_Diff = $Alte_hoehe - $neue_hoehe
			If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
			If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
			GUICtrlSetPos($Markierte_Controls_IDs[1], $Pos_C[0], $Pos_C[1], $neue_breite, $neue_hoehe)
			_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
			For $r = 2 To $Markierte_Controls_IDs[0]
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
				If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
				$neue_breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0)) - $Breiten_Diff
				$neue_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0)) - $Hoehen_Diff
				If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
				If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_W[0], $Pos_W[1], $neue_breite, $neue_hoehe)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd
	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "width", $Pos_C[2])
			_IniWriteEx($Cache_Datei_Handle, "tab", "height", $Pos_C[3])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "width", $Pos_C[2])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "height", $Pos_C[3])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	_Redraw_Window()


	Opt('MouseCoordMode', $Opt_old)
EndFunc   ;==>_Resize_Control_Nach_Rechts_Unten_Multi






Func _Resize_Control_Nach_Oben_Rechts_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old

	$Opt_old = Opt('MouseCoordMode', 0)
	;prüfe ob min. 1 control bewegt werden darf
	For $u = 0 To $Markierte_Controls_IDs[0]
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then
			_ArraySwap($Markierte_Controls_Sections, 0, $u)
			_ArraySwap($Markierte_Controls_IDs, 1, $u + 1)
			_ArraySwap($Resize_Oben_Links_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Links_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Links_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Rechts_Mitte_Multi, 0, $u)
		EndIf
	Next
	If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then Return ;alle gesperrt

	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()

	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			$MousePos = MouseGetPos()
			$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
			$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[1])
			If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
			$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
			$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))
			$Alte_y = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "y", 0))
			$neue_breite = $Alte_Breite - ($x_Offset - ($MousePos[0] - $pos[0]))
			$neue_Y = $Alte_y - ($y_Offset - ($MousePos[1] - $Alte_y))
			$Y_Diff = $Alte_y - $neue_Y
			$neue_hoehe = $Alte_hoehe + $Y_Diff
			$Breiten_Diff = $Alte_Breite - $neue_breite
			$Hoehen_Diff = $Alte_hoehe - $neue_hoehe

			If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
			If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
			If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
			GUICtrlSetPos($Markierte_Controls_IDs[1], $Pos_C[0], $neue_Y, $neue_breite, $neue_hoehe)
			_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
			For $r = 2 To $Markierte_Controls_IDs[0]
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
				If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
				$neue_breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0)) - $Breiten_Diff
				$neue_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0)) + $Y_Diff
				$neue_Y = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "y", 0)) - $Y_Diff
				$Alte_y = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "y", 0))
				$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))

				If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
				If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
				If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_W[0], $neue_Y, $neue_breite, $neue_hoehe)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd

	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "y", $Pos_C[1])
			_IniWriteEx($Cache_Datei_Handle, "tab", "width", $Pos_C[2])
			_IniWriteEx($Cache_Datei_Handle, "tab", "height", $Pos_C[3])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_C[1])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "width", $Pos_C[2])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "height", $Pos_C[3])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	_Redraw_Window()

	Opt('MouseCoordMode', $Opt_old)
EndFunc   ;==>_Resize_Control_Nach_Oben_Rechts_Multi



Func _Resize_Control_Nach_Oben_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old
	$Opt_old = Opt('MouseCoordMode', 0)
	;prüfe ob min. 1 control bewegt werden darf
	For $u = 0 To $Markierte_Controls_IDs[0]
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then
			_ArraySwap($Markierte_Controls_Sections, 0, $u)
			_ArraySwap($Markierte_Controls_IDs, 1, $u + 1)
			_ArraySwap($Resize_Oben_Links_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Links_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Links_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Rechts_Mitte_Multi, 0, $u)
		EndIf
	Next
	If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then Return ;alle gesperrt

	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()

	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			$MousePos = MouseGetPos()
			$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
			$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[1])
			If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
			$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
			$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))
			$Alte_y = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "y", 0))
			$neue_Y = $Alte_y - ($y_Offset - ($MousePos[1] - $Alte_y))
			$Y_Diff = $Alte_y - $neue_Y
			$neue_hoehe = $Alte_hoehe + $Y_Diff
			$Hoehen_Diff = $Alte_hoehe - $neue_hoehe
			If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
			If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
			GUICtrlSetPos($Markierte_Controls_IDs[1], $Pos_C[0], $neue_Y, $Pos_C[2], $neue_hoehe)
			_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
			For $r = 2 To $Markierte_Controls_IDs[0]
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
				If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
				$neue_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0)) + $Y_Diff
				$neue_Y = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "y", 0)) - $Y_Diff
				$Alte_y = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "y", 0))
				$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))

				If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
				If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_W[0], $neue_Y, $Pos_W[2], $neue_hoehe)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd

	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "y", $Pos_C[1])
			_IniWriteEx($Cache_Datei_Handle, "tab", "height", $Pos_C[3])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_C[1])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "height", $Pos_C[3])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	_Redraw_Window()


	Opt('MouseCoordMode', $Opt_old)
EndFunc   ;==>_Resize_Control_Nach_Oben_Multi



Func _Resize_Control_Nach_Links_Oben_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old
	$Opt_old = Opt('MouseCoordMode', 0)
	;prüfe ob min. 1 control bewegt werden darf
	For $u = 0 To $Markierte_Controls_IDs[0]
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then
			_ArraySwap($Markierte_Controls_Sections, 0, $u)
			_ArraySwap($Markierte_Controls_IDs, 1, $u + 1)
			_ArraySwap($Resize_Oben_Links_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Links_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Links_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Rechts_Mitte_Multi, 0, $u)
		EndIf
	Next
	If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then Return ;alle gesperrt

	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()

	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			$MousePos = MouseGetPos()
			$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
			$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[1])
			If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
			$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))
			$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
			$Alte_X = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "x", 0))
			$Alte_y = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "y", 0))
			$neue_X = $Alte_X - ($x_Offset - ($MousePos[0] - $Alte_X))
			$neue_Y = $Alte_y - ($y_Offset - ($MousePos[1] - $Alte_y))
			$X_Diff = $Alte_X - $neue_X
			$Y_Diff = $Alte_y - $neue_Y
			$neue_breite = $Alte_Breite + $X_Diff
			$Breiten_Diff = $Alte_Breite - $neue_breite
			$neue_hoehe = $Alte_hoehe + $Y_Diff
			$Hoehe_Diff = $Alte_hoehe - $neue_hoehe

			If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
			If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
			If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
			If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
			GUICtrlSetPos($Markierte_Controls_IDs[1], $neue_X, $neue_Y, $neue_breite, $neue_hoehe)
			_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
			For $r = 2 To $Markierte_Controls_IDs[0]
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
				If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
				$Alte_X = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "x", 0))
				$Alte_y = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "y", 0))
				$neue_X = $Alte_X - $X_Diff
				$neue_Y = $Alte_y - $Y_Diff
				$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
				$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))
				$neue_breite = $Alte_Breite - $Breiten_Diff
				$neue_hoehe = $Alte_hoehe + $Y_Diff

				If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
				If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
				If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
				If $neue_Y > $Alte_y + $Alte_hoehe Then $neue_Y = $Alte_y + $Alte_hoehe
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $neue_X, $neue_Y, $neue_breite, $neue_hoehe)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd
	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "x", $Pos_C[0])
			_IniWriteEx($Cache_Datei_Handle, "tab", "y", $Pos_C[1])
			_IniWriteEx($Cache_Datei_Handle, "tab", "width", $Pos_C[2])
			_IniWriteEx($Cache_Datei_Handle, "tab", "height", $Pos_C[3])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_C[0])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_C[1])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "width", $Pos_C[2])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "height", $Pos_C[3])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	_Redraw_Window()


	Opt('MouseCoordMode', $Opt_old)
EndFunc   ;==>_Resize_Control_Nach_Links_Oben_Multi







Func _Resize_Control_Nach_Links_Unten_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	Local $Pos_C, $Pos_M, $Pos_M2, $Opt_old
	$Opt_old = Opt('MouseCoordMode', 0)
	;prüfe ob min. 1 control bewegt werden darf
	For $u = 0 To $Markierte_Controls_IDs[0]
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then
			_ArraySwap($Markierte_Controls_Sections, 0, $u)
			_ArraySwap($Markierte_Controls_IDs, 1, $u + 1)
			_ArraySwap($Resize_Oben_Links_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Oben_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Links_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Unten_Rechts_Multi, 0, $u)
			_ArraySwap($Resize_Links_Mitte_Multi, 0, $u)
			_ArraySwap($Resize_Rechts_Mitte_Multi, 0, $u)
		EndIf
	Next
	If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 1 Then Return ;alle gesperrt

	$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1])) ;$pic)

	$Pos_M = MouseGetPos()
	$Pos_W = WinGetPos($GUI_Editor)
	$x_Offset = $Pos_M[0] - $Pos_C[0]
	$y_Offset = $Pos_M[1] - $Pos_C[1]
;~     _MouseTrap($Pos_W[0]+$x_Offset,$Pos_W[1]+$y_Offset,$Pos_W[0]+$Pos_W[2],$Pos_W[1]+$Pos_W[3])
	$Pos_M2 = MouseGetPos()

	While _IsPressed('01', $dll)
		$Pos_M = MouseGetPos()
		If $Pos_M <> $Pos_M2 Then
			$MousePos = MouseGetPos()
			$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
			$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[1])
			If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
			$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))
			$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
			$Alte_X = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "x", 0))
			$neue_X = $Alte_X - ($x_Offset - ($MousePos[0] - $Alte_X))
			$X_Diff = $Alte_X - $neue_X
			$neue_breite = $Alte_Breite + $X_Diff
			$Breiten_Diff = $Alte_Breite - $neue_breite
			$neue_hoehe = $Alte_hoehe - ($y_Offset - ($MousePos[1] - $pos[1]))
			$Hoehe_Diff = $Alte_hoehe - $neue_hoehe

			If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
			If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
			If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
			GUICtrlSetPos($Markierte_Controls_IDs[1], $neue_X, $pos[1], $neue_breite, $neue_hoehe)
			_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
			For $r = 2 To $Markierte_Controls_IDs[0]
				$Pos_W = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
				$INI_Section = GUICtrlGetHandle($Markierte_Controls_IDs[$r])
				If $INI_Section = GUICtrlGetHandle($TABCONTROL_ID) Then $INI_Section = "tab"
				$Alte_X = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "x", 0))
				$neue_X = $Alte_X - $X_Diff
				$Alte_Breite = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "width", 0))
				$Alte_hoehe = Number(_IniReadEx($Cache_Datei_Handle, $INI_Section, "height", 0))
				$neue_breite = $Alte_Breite - $Breiten_Diff
				$neue_hoehe = $Alte_hoehe - $Hoehe_Diff

				If $neue_breite < $GroesenLimit Then $neue_breite = $GroesenLimit
				If $neue_hoehe < $GroesenLimit Then $neue_hoehe = $GroesenLimit
				If $neue_X > $Alte_X + $Alte_Breite Then $neue_X = $Alte_X + $Alte_Breite
				If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[$r], $neue_X, $Pos_W[1], $neue_breite, $neue_hoehe)
				_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			Next
		EndIf
		$Pos_M = $Pos_M2
;~ 		sleep(10)

	WEnd
	For $r = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
		If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "x", $Pos_C[0])
			_IniWriteEx($Cache_Datei_Handle, "tab", "width", $Pos_C[2])
			_IniWriteEx($Cache_Datei_Handle, "tab", "height", $Pos_C[3])
		Else
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_C[0])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "width", $Pos_C[2])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "height", $Pos_C[3])
		EndIf
	Next
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	_Redraw_Window()


	Opt('MouseCoordMode', $Opt_old)
EndFunc   ;==>_Resize_Control_Nach_Links_Unten_Multi


Func Markiere_Control_Multi($control = "", $VID = "", $Section = "")

	If $Control_Markiert = 1 Then Entferne_Makierung()

	$Control_Markiert_MULTI = 3 ;@GUI_CtrlId

	GUICtrlSetCursor($control, 9)
	If $control = $TABCONTROL_ID Then
		$Markierte_Controls_Sections[$VID] = "tab"
	Else
		$Markierte_Controls_Sections[$VID] = $Section
	EndIf

	Local $pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($control))
	If @error = 1 Then Return
	;Punkte oben

	;-1 Fixes:
	If $pos[0] - 5 = -1 Then
		$t = 0
	Else
		$t = $pos[0] - 5
	EndIf
	If $pos[1] - 5 = -1 Then
		$s = 0
	Else
		$s = $pos[1] - 5
	EndIf

	;Punkte oben
	$Resize_Oben_Links_Multi[$VID] = GUICtrlCreatePic("data\punkt.jpg", $t, $s, 5, 5)
	GUICtrlSetCursor(-1, 12)
	GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Links_Oben_Multi")
	GUICtrlSetResizing($Resize_Oben_Links_Multi[$VID], $GUI_DOCKALL)
	GUICtrlSetStyle($Resize_Oben_Links_Multi[$VID], $Default_Image)
	$Resize_Oben_Mitte_Multi[$VID] = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + ($pos[2] / 2) - 2.5, $pos[1] - 5, 5, 5)
	GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Oben_Multi")
	GUICtrlSetCursor(-1, 11)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetStyle(-1, $Default_Image)
	$Resize_Oben_Rechts_Multi[$VID] = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + $pos[2], $pos[1] - 5, 5, 5)
	GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Oben_Rechts_Multi")
	GUICtrlSetCursor(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetStyle(-1, $Default_Image)

	;Punkte unten
	$Resize_Unten_Links_Multi[$VID] = GUICtrlCreatePic("data\punkt.jpg", $pos[0] - 5, $pos[1] + $pos[3], 5, 5)
	GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Links_Unten_Multi")
	GUICtrlSetCursor(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetStyle(-1, $Default_Image)
	$Resize_Unten_Mitte_Multi[$VID] = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + ($pos[2] / 2) - 2.5, $pos[1] + $pos[3], 5, 5)
	GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Unten_Multi")
	GUICtrlSetCursor(-1, 11)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetStyle(-1, $Default_Image)
	$Resize_Unten_Rechts_Multi[$VID] = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + $pos[2], $pos[1] + $pos[3], 5, 5)
	GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Rechts_Unten_Multi")
	GUICtrlSetCursor(-1, 12)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetStyle(-1, $Default_Image)

	;Punkte mitte
	$Resize_Links_Mitte_Multi[$VID] = GUICtrlCreatePic("data\punkt.jpg", $pos[0] - 5, $pos[1] + ($pos[3] / 2) - 2.5, 5, 5)
	GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Links_Multi")
	GUICtrlSetCursor(-1, 13)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetStyle(-1, $Default_Image)
	$Resize_Rechts_Mitte_Multi[$VID] = GUICtrlCreatePic("data\punkt.jpg", $pos[0] + $pos[2], $pos[1] + ($pos[3] / 2) - 2.5, 5, 5)
	GUICtrlSetOnEvent(-1, "_Resize_Control_Nach_Rechts_Multi")
	GUICtrlSetCursor(-1, 13)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetStyle(-1, $Default_Image)

	$Locked_Status = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$VID], "locked", 0)
	If $Locked_Status = 1 Then
		GUICtrlSetImage($Resize_Oben_Links_Multi[$VID], @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Oben_Mitte_Multi[$VID], @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Oben_Rechts_Multi[$VID], @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Unten_Links_Multi[$VID], @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Unten_Mitte_Multi[$VID], @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Unten_Rechts_Multi[$VID], @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Links_Mitte_Multi[$VID], @ScriptDir & "\Data\Punkt_locked.jpg")
		GUICtrlSetImage($Resize_Rechts_Mitte_Multi[$VID], @ScriptDir & "\Data\Punkt_locked.jpg")
	EndIf
	GUISetState()

EndFunc   ;==>Markiere_Control_Multi

Func _Show_Funcs()
	If $DEBUG = "true" Then Return ;Nicht im Debug ausführen!
	If $Control_Markiert = 0 Then Return
	_ISNPlugin_Nachricht_senden("listfuncs")
	AdlibRegister("_Show_Funcs_Warte_auf_Antwort", 500)
EndFunc   ;==>_Show_Funcs

Func _Show_Funcs_Warte_auf_Antwort()
	AdlibUnRegister("_Show_Funcs_Warte_auf_Antwort")
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "listfuncsok", 90000000)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	$data = _Pluginstring_get_element($Nachricht, 2)
	If $data = GUICtrlRead($MiniEditor_ClickFunc) Then Return
	If $data = "" Then Return
	GUICtrlSetData($MiniEditor_ClickFunc, $data)
EndFunc   ;==>_Show_Funcs_Warte_auf_Antwort


Func _waehle_Hintergrund_neuGUI2()
	_ISNPlugin_Nachricht_senden("listpictures")
	AdlibRegister("_waehle_Hintergrund_neuGUI2_Warte_auf_Antwort", 500)
EndFunc   ;==>_waehle_Hintergrund_neuGUI2

Func _waehle_Hintergrund_neuGUI2_Warte_auf_Antwort()
	AdlibUnRegister("_waehle_Hintergrund_neuGUI2_Warte_auf_Antwort")
	GUISetState(@SW_DISABLE, $Form_bearbeitenGUI)
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "listpicturesok", 90000000)
	GUISetState(@SW_ENABLE, $Form_bearbeitenGUI)
	$data = _Pluginstring_get_element($Nachricht, 2)
	If $data = "" Then Return
	If $data = GUICtrlRead($Form_bearbeitenBGImage) Then Return
	GUICtrlSetData($Form_bearbeitenBGImage, $data)
EndFunc   ;==>_waehle_Hintergrund_neuGUI2_Warte_auf_Antwort

Func _Show_ChoosePIC()
	If $DEBUG = "true" Then Return ;Nicht im Debug ausführen!
	If $Control_Markiert = 0 Then Return
	_ISNPlugin_Nachricht_senden("listpictures")
	AdlibRegister("_ChoosePIC_Warte_auf_Antwort", 500)
EndFunc   ;==>_Show_ChoosePIC

Func _ChoosePIC_Warte_auf_Antwort()
	AdlibUnRegister("_ChoosePIC_Warte_auf_Antwort")
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "listpicturesok", 900000000)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	$data = _Pluginstring_get_element($Nachricht, 2)
	If $data = "" Then Return
	If $data = GUICtrlRead($MiniEditor_IconPfad) Then Return
	GUICtrlSetData($MiniEditor_IconPfad, $data)
	_Mini_Editor_Einstellungen_Uebernehmen()
EndFunc   ;==>_ChoosePIC_Warte_auf_Antwort

Func _Show_Extracode_GUI()
	If $DEBUG = "true" Then Return
	$extracode_data = _IniReadEx($Cache_Datei_Handle, "gui", "code", "")
	$extracode_data = _UNICODE2ANSI($extracode_data)
	_ISNPlugin_Nachricht_senden("showextracode" & $Plugin_System_Delimiter & $extracode_data & $Plugin_System_Delimiter & _ISNPlugin_Get_langstring(20) & $Plugin_System_Delimiter & _ISNPlugin_Get_langstring(83))
	AdlibRegister("_GUI_Extracode_auf_Antwort_Warten", 500)
EndFunc   ;==>_Show_Extracode_GUI

Func _Show_Extracode_before_GUI()
	If $DEBUG = "true" Then Return
	$extracode_data = _IniReadEx($Cache_Datei_Handle, "gui", "codebeforegui", "")
	$extracode_data = _UNICODE2ANSI($extracode_data)
	_ISNPlugin_Nachricht_senden("showextracode" & $Plugin_System_Delimiter & $extracode_data & $Plugin_System_Delimiter & _ISNPlugin_Get_langstring(256) & $Plugin_System_Delimiter & _ISNPlugin_Get_langstring(257))
	AdlibRegister("_Vor_GUI_Extracode_auf_Antwort_Warten", 500)
EndFunc   ;==>_Show_Extracode_before_GUI


Func _GUI_Extracode_auf_Antwort_Warten()
	AdlibUnRegister("_GUI_Extracode_auf_Antwort_Warten")
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $Form_bearbeitenGUI)
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "extracodeanswer", 9000000000)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $Form_bearbeitenGUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	$datanstring = _Pluginstring_get_element($Nachricht, 2)
	If $datanstring = "#error#" Then Return
	$datanstring = _ANSI2UNICODE($datanstring)
	_IniWriteEx($Cache_Datei_Handle, "gui", "code", $datanstring)
EndFunc   ;==>_GUI_Extracode_auf_Antwort_Warten

Func _Vor_GUI_Extracode_auf_Antwort_Warten()
	AdlibUnRegister("_Vor_GUI_Extracode_auf_Antwort_Warten")
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $Form_bearbeitenGUI)
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "extracodeanswer", 9000000000)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $Form_bearbeitenGUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	$datanstring = _Pluginstring_get_element($Nachricht, 2)
	If $datanstring = "#error#" Then Return
	$datanstring = _ANSI2UNICODE($datanstring)
	_IniWriteEx($Cache_Datei_Handle, "gui", "codebeforegui", $datanstring)
EndFunc   ;==>_Vor_GUI_Extracode_auf_Antwort_Warten

Func _HIDE_Extracode_GUI()
	$data = Sci_GetLines($Sci)
	$data = StringReplace($data, @CRLF, '[BREAK]', 0)
	_IniWriteEx($Cache_Datei_Handle, "gui", "code", $data)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $Form_bearbeitenGUI)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_HIDE, $ExtracodeGUI)
	GUICtrlSetState($Showcodebt1, $GUI_HIDE)
	GUICtrlSetState($Showcodebt2, $GUI_HIDE)
	GUICtrlSetState($Showcodebt3, $GUI_HIDE)
EndFunc   ;==>_HIDE_Extracode_GUI
;~


Func _Hide_The_Code()
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $ExtracodeGUI)
	GUICtrlSetState($Showcodebt1, $GUI_HIDE)
	GUICtrlSetState($Showcodebt2, $GUI_HIDE)
	GUICtrlSetState($Showcodebt3, $GUI_HIDE)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_Hide_The_Code

Func Sci_SetSelection($Sci, $BeginChar, $EndChar)
	$pos = SendMessage($Sci, $SCI_SETSEL, $BeginChar, $EndChar)
	Return $pos
EndFunc   ;==>Sci_SetSelection

Func Sci_DelLines($Sci)
	SendMessage($Sci, $SCI_CLEARALL, 0, 0)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>Sci_DelLines

Func Sci_AddLines($Sci, $Text, $Line)
	$Oldpos = Sci_GetCurrentLine($Sci)
	If @error Then
		Return 0
	EndIf
	Sci_SetCurrentLine($Sci, $Line)
	If @error Then
		Return 0
	EndIf
	;$LineLenght = StringSplit($Text, "")

   if IniRead(@ScriptDir & "\plugin.ini", "plugin", "language", "#error#") = "china.lng" Then
	$LineLenght = StringSplit(StringRegExpReplace($Text, '[^\x00-\xff]', '00'),"") ;for china only
	Else
	$LineLenght = StringSplit($Text,"")
   endif

	If @error Then
		Return 0
	EndIf
	DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_ADDTEXT, "int", $LineLenght[0], "str", $Text)
	If @error Then
		Return 0
	EndIf
	Sci_SetCurrentLine($Sci, $Oldpos)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>Sci_AddLines

Func Sci_SetCurrentLine($Sci, $Line)
	SendMessage($Sci, $SCI_GOTOLINE, $Line - 1, 0)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>Sci_SetCurrentLine

Func Sci_GetCurrentLine($Sci)
	$pos = SendMessage($Sci, $SCI_GETCURRENTPOS, 0, 0)
	$Line = SendMessage($Sci, $SCI_LINEFROMPOSITION, $pos, 0)
	Return $Line + 1
EndFunc   ;==>Sci_GetCurrentLine

Func _Show_Extracode()
	If $DEBUG = "true" Then Return
	Local $extracode_data = ""
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		$extracode_data = _IniReadEx($Cache_Datei_Handle, "tab", "code", "")
	Else
		$extracode_data = _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "code", "")
	EndIf

	$extracode_data = _UNICODE2ANSI($extracode_data)

	_ISNPlugin_Nachricht_senden("showextracode" & $Plugin_System_Delimiter & $extracode_data & $Plugin_System_Delimiter & _ISNPlugin_Get_langstring(20) & $Plugin_System_Delimiter & _ISNPlugin_Get_langstring(82))
	AdlibRegister("_Extracode_Warte_auf_Antwort", 500)
EndFunc   ;==>_Show_Extracode


Func _Extracode_Warte_auf_Antwort()
	AdlibUnRegister("_Extracode_Warte_auf_Antwort")
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "extracodeanswer", 9000000000)

	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)

	$datenstring = _Pluginstring_get_element($Nachricht, 2)
	$datenstring = String($datenstring)
	If $datenstring = "#error#" Then Return

	$datenstring = _ANSI2UNICODE($datenstring)

	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_IniWriteEx($Cache_Datei_Handle, "tab", "code", $datenstring)
	Else
		_IniWriteEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "code", $datenstring)
	EndIf

EndFunc   ;==>_Extracode_Warte_auf_Antwort


Func _HIDE_Extracode()
	$data = Sci_GetLines($Sci)
	$data = StringReplace($data, @CRLF, '[BREAK]', 0)

	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_IniWriteEx($Cache_Datei_Handle, "tab", "code", $data)
	Else
		_IniWriteEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "code", $data)
	EndIf
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_HIDE, $ExtracodeGUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_HIDE_Extracode

Func Sci_GetLines($Sci)
	Local $Ret, $sText
	$iLen = SendMessage($Sci, $SCI_GETTEXT, 0, 0)
	If @error Then
		Return 0
	EndIf
	$sBuf = DllStructCreate("byte[" & $iLen & "]")
	If @error Then
		Return 0
	EndIf
	$Ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_GETTEXT, "int", $iLen, "ptr", DllStructGetPtr($sBuf))
	If @error Then
		Return 0
	EndIf
	$sText = BinaryToString(DllStructGetData($sBuf, 1))
	$sBuf = 0
	If @error Then
		Return 0
	Else
		If StringRight($sText, 1) = Chr(0) Then $sText = StringTrimRight($sText, 1) ;Added by Michael Michta
		Return $sText
	EndIf
EndFunc   ;==>Sci_GetLines

Func CreateEditor()

	Local $GWL_HINSTANCE = -6
	Local $hLib = LoadLibrary(@ScriptDir & "\data\SciLexer.DLL")

	Local $hInstance = 0
	Global $Sci

	$Sci = CreateWindowEx($WS_EX_CLIENTEDGE, "Scintilla", _
			"TEST", BitOR($WS_CHILD, $WS_VISIBLE, $WS_HSCROLL, $WS_VSCROLL, $WS_TABSTOP, $WS_CLIPCHILDREN), 10, 75, 689, 419, _
			$ExtracodeGUI, 0, $hInstance, 0)
	LoadHiglight(@ScriptDir & "\data\highlighter.au3.txt")
	InitEditor()
EndFunc   ;==>CreateEditor

Func LoadHiglight($file)
	If Not FileExists($file) Then
		MsgBox(16, "Error", "The highlighter file " & $file & " does not exist!")
		Return
	 EndIf

   if IniRead(@ScriptDir & "\plugin.ini", "plugin", "language", "#error#") = "china.lng" Then
	  SendMessage($Sci, $SCI_SETCODEPAGE, 950,0) ;Setzte China Encoding für Scintila 950 (Traditional Chinese Big5)
	  else
	SendMessage($Sci, $SCI_SETCODEPAGE, $SC_CP_UTF8, 0)
   Endif


	$cmdrun = IniRead($file, "", "run", "")
	$cmdbuild = IniRead($file, "", "build", "")
	$cmdcompile = IniRead($file, "", "compile", "")
	SetStyle($STYLE_DEFAULT, IniRead($file, "", "DefaultStyle", $default_style))
	SendMessageString($Sci, $SCI_STYLECLEARALL, 0, 0)

	SendMessageString($Sci, $SCI_SETLEXER, IniRead($file, "", "lex", 0), 0)
	$bits = SendMessageString($Sci, $SCI_GETSTYLEBITSNEEDED, 0, 0)
	SendMessageString($Sci, $SCI_SETSTYLEBITS, $bits, 0)

	$inif = FileRead($file)
	$arr = StringRegExp($inif, "(?m)^style([0-9]+)=(.*)", 3)
	For $i = 0 To UBound($arr) - 1 Step 2
		SetStyle($arr[$i], $arr[$i + 1])
	Next

	$arr = StringRegExp($inif, "(?m)(?s)(?U)^words([0-9]+)=(.*)\r\n\r\n", 3)
	For $i = 0 To UBound($arr) - 1 Step 2
		SendMessageString($Sci, $SCI_SETKEYWORDS, $arr[$i], $arr[$i + 1])
	Next
EndFunc   ;==>LoadHiglight

Func InitEditor()
	SetStyle($STYLE_DEFAULT, $default_style)

	SetProperty($Sci, "fold", "1")
	SetProperty($Sci, "fold.compact", "1")
	SetProperty($Sci, "fold.comment", "1")

	SetProperty($Sci, "fold.preprocessor", "1")
	SendMessageString($Sci, $SCI_SETBUFFEREDDRAW, 1, 0) ; buffered drawing of the text

   if _System_benoetigt_double_byte_character_Support() then
   SendMessage($Sci, $SCI_SETCODEPAGE,  936 ,0) ;Setzte China Encoding für Scintila 936 (Simplified Chinese)
   else
   SendMessage($Sci, $SCI_SETCODEPAGE, $SC_CP_UTF8,0)
   endif



	;----
	ClearCmdKey($Sci, 0x47, $SCMOD_CTRL) ;unbind the default ctrl+g action
	ClearCmdKey($Sci, 0x4E, $SCMOD_CTRL) ;unbind the default ctrl+n action
	ClearCmdKey($Sci, 0x4F, $SCMOD_CTRL) ;unbind the default ctrl+o action
	ClearCmdKey($Sci, 0x53, $SCMOD_CTRL) ;unbind the default ctrl+s action
	ClearCmdKey($Sci, 0x46, $SCMOD_CTRL) ;unbind the default ctrl+f action
	ClearCmdKey($Sci, 0x53, $SCMOD_SHIFT) ;unbind the default shift+s action
	ClearCmdKey($Sci, 0x46, $SCMOD_SHIFT) ;unbind the default shift+f action

EndFunc   ;==>InitEditor

Func ClearCmdKey($Sci, $keycode, $modifier = 0)
	Return SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($modifier, -16) + $keycode, 0) ;
EndFunc   ;==>ClearCmdKey

Func CreateWindowEx($dwExStyle, $lpClassName, $lpWindowName = "", $dwStyle = -1, $x = 0, $y = 0, $nWidth = 0, $nHeight = 0, $hwndParent = 0, $hMenu = 0, $hInstance = 0, $lParm = 0)
	Local $Ret
	If $hInstance = 0 Then
		$Ret = DllCall($user32, "long", "GetWindowLong", "hwnd", $hwndParent, "int", -6)
		$hInstance = $Ret[0]
	EndIf
	$Ret = DllCall($user32, "hwnd", "CreateWindowEx", "long", $dwExStyle, _
			"str", $lpClassName, "str", $lpWindowName, _
			"long", $dwStyle, "int", $x, "int", $y, "int", $nWidth, "int", $nHeight, _
			"hwnd", $hwndParent, "hwnd", $hMenu, "long", $hInstance, "ptr", $lParm)
	If errDllCall(@error, @extended) Then Exit
	Return $Ret[0]
EndFunc   ;==>CreateWindowEx

Func LoadLibrary($lpFileName)
	Local $Ret
	$Ret = DllCall($kernel32, "int", "LoadLibrary", "str", $lpFileName)
	If errDllCall(@error, @extended) Then Exit
	Return $Ret[0]
EndFunc   ;==>LoadLibrary

Func SendMessage($Sci, $msg, $wp, $lp)
	Local $Ret
	$Ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $msg, "int", $wp, "int", $lp)
	Return $Ret[0]
EndFunc   ;==>SendMessage

Func SendMessageString($Sci, $msg, $wp, $str)
	Local $Ret
	$Ret = DllCall($user32, "int", "SendMessageA", "hwnd", $Sci, "int", $msg, "int", $wp, "str", $str)
	Return $Ret[0]
EndFunc   ;==>SendMessageString

Func errDllCall($err, $ext, $erl = @ScriptLineNumber)
	Local $Ret = 0
	If $err <> 0 Then
		ConsoleWrite("(" & $erl & ") := @error:=" & $err & ", @extended:=" & $ext & @LF)
		$Ret = 1
	EndIf
	Return $Ret
EndFunc   ;==>errDllCall

Func SetStyle($Style, $styletxt)
	$astyle = StringSplit($styletxt, ",")

	If UBound($astyle) < 8 Then
		;MsgBox(16,"Warning","Incomplete style definition, skipping..."&@CRLF&$styletxt)
		Return
	EndIf

	SendMessage($Sci, $SCI_STYLESETFORE, $Style, $astyle[1])
	SendMessage($Sci, $SCI_STYLESETBACK, $Style, $astyle[2])
	If $astyle[3] >= 1 Then
		SendMessage($Sci, $SCI_STYLESETSIZE, $Style, $astyle[3])
	EndIf
	If $astyle[4] <> '' Then
		SendMessageString($Sci, $SCI_STYLESETFONT, $Style, $astyle[4])
	EndIf
	SendMessage($Sci, $SCI_STYLESETBOLD, $Style, $astyle[5])
	SendMessage($Sci, $SCI_STYLESETITALIC, $Style, $astyle[6])
	SendMessage($Sci, $SCI_STYLESETUNDERLINE, $Style, $astyle[7])
EndFunc   ;==>SetStyle

Func GetSelLength($Sci)
	$startPosition = SendMessage($Sci, $SCI_GETSELECTIONSTART, 0, 0)
	$endPosition = SendMessage($Sci, $SCI_GETSELECTIONEND, 0, 0)
	$len = $endPosition - $startPosition
	Return $len
EndFunc   ;==>GetSelLength

Func SetProperty($Sci, $property, $value)
	Local $Ret
	If IsInt($property) Then
		$prop_type = "int"
	ElseIf IsString($property) Then
		$prop_type = "str"
	EndIf

	If IsInt($value) Then
		$val_type = "int"
	ElseIf IsString($value) Then
		$val_type = "str"
	EndIf

	$Ret = DllCall($user32, "int", "SendMessageA", "hwnd", $Sci, "int", $SCI_SETPROPERTY, $prop_type, $property, $val_type, $value)
	Return $Ret[0]
EndFunc   ;==>SetProperty

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

Func _waehle_Schriften()
	;COLOREF CONVERTER
	$iColorRef = Hex(String(GUICtrlRead($MiniEditor_Textfarbe)), 6)
	$iColorRef = '0x' & StringMid($iColorRef, 1, 2) & StringMid($iColorRef, 3, 2) & StringMid($iColorRef, 5, 2)
	GUISetState(@SW_DISABLE, $studiofenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	$a_font = _ChooseFont(GUICtrlRead($MiniEditor_Schriftart), GUICtrlRead($MiniEditor_Schriftgroese), $iColorRef, GUICtrlRead($MiniEditor_Schriftbreite), BitAND(GUICtrlRead($MiniEditor_Schriftartstyle), 2), BitAND(GUICtrlRead($MiniEditor_Schriftartstyle), 4), BitAND(GUICtrlRead($MiniEditor_Schriftartstyle), 8), $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	If $a_font < 0 Then Return
	GUICtrlSetData($MiniEditor_Schriftart, $a_font[2])
;~ guictrlsetdata($MiniEditor_Schriftart_dummy,$a_font[2])
	GUICtrlSetData($MiniEditor_Schriftgroese, $a_font[3])
	GUICtrlSetData($MiniEditor_Textfarbe, $a_font[7])
	GUICtrlSetBkColor($MiniEditor_Textfarbe, $a_font[7])
	GUICtrlSetColor($MiniEditor_Textfarbe, _ColourInvert(Execute($a_font[7])))
	GUICtrlSetData($MiniEditor_Schriftbreite, $a_font[4])
	GUICtrlSetData($MiniEditor_Schriftartstyle, $a_font[1])
	_Mini_Editor_Einstellungen_Uebernehmen()
EndFunc   ;==>_waehle_Schriften

Func _waehle_Hintergrund()
	GUISetState(@SW_DISABLE, $studiofenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	$a_colour = _ChooseColor(2, GUICtrlRead($MiniEditor_BGColour), 2, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	If $a_colour < 0 Then Return
	GUICtrlSetData($MiniEditor_BGColour, $a_colour)
	GUICtrlSetBkColor($MiniEditor_BGColour, $a_colour)
	GUICtrlSetColor($MiniEditor_BGColour, _ColourInvert(Execute($a_colour)))
	_Mini_Editor_Einstellungen_Uebernehmen()
EndFunc   ;==>_waehle_Hintergrund

Func _waehle_Fontfarbe()
	GUISetState(@SW_DISABLE, $studiofenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	$a_colour = _ChooseColor(2, GUICtrlRead($MiniEditor_Textfarbe), 2, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	If $a_colour < 0 Then Return
	GUICtrlSetData($MiniEditor_Textfarbe, $a_colour)
	GUICtrlSetBkColor($MiniEditor_Textfarbe, $a_colour)
	GUICtrlSetColor($MiniEditor_Textfarbe, _ColourInvert(Execute($a_colour)))
	_Mini_Editor_Einstellungen_Uebernehmen()
EndFunc   ;==>_waehle_Fontfarbe

Func _Zeige_Erweiterten_Text()
	If GUICtrlRead($MiniEditor_Controltype) = "menu" Then
		_Show_Menueditor()
		Return
	EndIf
	GUICtrlSetData($formstudio_text_edit, "")
	If GUICtrlRead($MiniEditor_Controltype) = "listbox" Or GUICtrlRead($MiniEditor_Controltype) = "combo" Then
		GUICtrlSetData($formstudio_text_edit, StringReplace(GUICtrlRead($MiniEditor_Text), "|", @CRLF))
	Else
		GUICtrlSetData($formstudio_text_edit, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
	EndIf
	GUISetState(@SW_SHOW, $formstudio_text)
	GUISetState(@SW_DISABLE, $studiofenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
EndFunc   ;==>_Zeige_Erweiterten_Text

Func _Verstecke_Erweiterten_Text()
	If GUICtrlRead($MiniEditor_Controltype) = "listbox" Or GUICtrlRead($MiniEditor_Controltype) = "combo" Then
		GUICtrlSetData($MiniEditor_Text, StringReplace(GUICtrlRead($formstudio_text_edit), @CRLF, "|"))
	Else
		GUICtrlSetData($MiniEditor_Text, StringReplace(GUICtrlRead($formstudio_text_edit), @CRLF, "[BREAK]"))
	EndIf
	GUISetState(@SW_ENABLE, $studiofenster)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_HIDE, $formstudio_text)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	_Mini_Editor_Einstellungen_Uebernehmen()
EndFunc   ;==>_Verstecke_Erweiterten_Text

Func _SetStatustext($Text = "")
	If $Text = "" Then Return
	;_GUICtrlStatusBar_SetText ($hStatus, $text)
	_ISNPlugin_Studio_Set_Statusbartext($Text)
EndFunc   ;==>_SetStatustext

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

Func _MaxOnMonitor($Title, $Text = '', $Monitor = -1)
	_CenterOnMonitor($Title, $Text, $Monitor)
	WinSetState($Title, $Text, @SW_MAXIMIZE)
EndFunc   ;==>_MaxOnMonitor

;==================================================================================================
; Function Name:   _CenterOnMonitor($Title[, $Text = ''[, $Monitor = -1]])
; Description::    Center a window on a specific monitor (or the monitor the mouse is on)
; Parameter(s):    $Title   The title of the window to Move/Maximize
;     optional:    $Text    The text of the window to Move/Maximize
;     optional:    $Monitor The monitor to move to (1..NumMonitors) defaults to monitor mouse is on
; Note:            Should probably have specified return/error codes but haven't put them in yet
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _CenterOnMonitor($Title, $Text = '', $Monitor = -1, $Ignore_primary = 0)
	If $Monitor = -1 Then $Monitor = $Runonmonitor
	If $Runonprimarymonitor = "true" And $Ignore_primary = 0 Then $Monitor = _get_primary_monitor()
	$hWindow = WinGetHandle($Title, $Text)
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

Func _Controls_ausrichten_links()
	If $Control_Markiert_MULTI <> 1 Then Return
	$Align_to_x = 9999999999999
	For $i = 1 To $Markierte_Controls_IDs[0]
		$data = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "x", 0)
		$Align_to_x = _Min($Align_to_x, Number($data))
	Next
	For $i = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$i]))
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "locked", 0) = 0 Then
			GUICtrlSetPos($Markierte_Controls_IDs[$i], $Align_to_x, $Pos_C[1], $Pos_C[2], $Pos_C[3])
			_Aktualisiere_Rahmen_Multi($i - 1, $Markierte_Controls_IDs[$i])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "x", $Align_to_x)
		EndIf
	Next
EndFunc   ;==>_Controls_ausrichten_links

Func _Controls_ausrichten_rechts()
	If $Control_Markiert_MULTI <> 1 Then Return
	$Align_to_x = 0
	For $i = 1 To $Markierte_Controls_IDs[0]
		$data = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "x", 0) + _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "width", 0)
		$Align_to_x = _Max($Align_to_x, Number($data))
	Next
	For $i = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$i]))
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "locked", 0) = 0 Then
			GUICtrlSetPos($Markierte_Controls_IDs[$i], $Align_to_x - $Pos_C[2], $Pos_C[1], $Pos_C[2], $Pos_C[3])
			_Aktualisiere_Rahmen_Multi($i - 1, $Markierte_Controls_IDs[$i])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "x", $Align_to_x - $Pos_C[2])
		EndIf
	Next
EndFunc   ;==>_Controls_ausrichten_rechts

Func _Controls_ausrichten_oben()
	If $Control_Markiert_MULTI <> 1 Then Return
	$Align_to_y = 9999999999999
	For $i = 1 To $Markierte_Controls_IDs[0]
		$data = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "y", 0)
		$Align_to_y = _Min($Align_to_y, Number($data))
	Next
	For $i = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$i]))
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "locked", 0) = 0 Then
			GUICtrlSetPos($Markierte_Controls_IDs[$i], $Pos_C[0], $Align_to_y, $Pos_C[2], $Pos_C[3])
			_Aktualisiere_Rahmen_Multi($i - 1, $Markierte_Controls_IDs[$i])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "y", $Align_to_y)
		EndIf
	Next
EndFunc   ;==>_Controls_ausrichten_oben

Func _Controls_ausrichten_unten()
	If $Control_Markiert_MULTI <> 1 Then Return
	$Align_to_y = 0
	For $i = 1 To $Markierte_Controls_IDs[0]
		$data = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "y", 0) + _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "height", 0)
		$Align_to_y = _Max($Align_to_y, Number($data))
	Next
	For $i = 1 To $Markierte_Controls_IDs[0]
		$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$i]))
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "locked", 0) = 0 Then
			GUICtrlSetPos($Markierte_Controls_IDs[$i], $Pos_C[0], $Align_to_y - $Pos_C[3], $Pos_C[2], $Pos_C[3])
			_Aktualisiere_Rahmen_Multi($i - 1, $Markierte_Controls_IDs[$i])
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$i - 1], "y", $Align_to_y - $Pos_C[3])
		EndIf
	Next
EndFunc   ;==>_Controls_ausrichten_unten

Func _Add_control_to_Multiselection($handle)
	;if $Control_Markiert_MULTI = 0 	then return
	If $handle = $BGimage Then Return
	If $handle = $Grid_Handle Then Return
	_ArraySearch($Markierte_Controls_IDs, $handle)
	If Not @error = 6 Then Return ;Bereits markiert

	$Marked_before = $Markierte_Controls_IDs[0]
	$New_counter = $Marked_before + 1
	If $handle = $TABCONTROL_ID Then
		$type = "tab"
	Else
		$type = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($handle), "type", "")
	EndIf

	If $type = "tab" Then
		_ArrayInsert($Markierte_Controls_IDs, $New_counter, $TABCONTROL_ID)
	Else
		_ArrayInsert($Markierte_Controls_IDs, $New_counter, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($handle), "handle", 0))
	EndIf
	$Markierte_Controls_IDs[0] = $New_counter
	Markiere_Control_Multi($Markierte_Controls_IDs[$New_counter], $New_counter - 1, GUICtrlGetHandle($handle))
	_SetStatustext($New_counter & " " & _ISNPlugin_Get_langstring(80))
	$Control_Markiert_MULTI = 1
	_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
EndFunc   ;==>_Add_control_to_Multiselection

Func _Switch_from_singe_to_multiselection_mode($to_add)
	If $Control_Markiert_MULTI = 1 Then Return
	If $Markiertes_Control_ID = "" Then Return
	$old = $Markiertes_Control_ID
	Entferne_Makierung()
	$Control_Markiert = 0
	$Control_Markiert_MULTI = 0
	$Markierte_Controls_IDs = $Markierte_Controls_IDs_leer
	$Markierte_Controls_Sections = $Markierte_Controls_IDs_leer
	_Add_control_to_Multiselection($old)
	;_Add_control_to_Multiselection($to_add)
	$Control_Markiert = 0
	$Control_Markiert_MULTI = 1

EndFunc   ;==>_Switch_from_singe_to_multiselection_mode

Func _Control_horizontal_zentrieren()
	If $Control_Markiert_MULTI = 1 Then Return
	If $Markiertes_Control_ID = "" Then Return
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		If _IniReadEx($Cache_Datei_Handle, "tab", "locked", 0) = 1 Then Return
	Else
		If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "locked", 0) = 1 Then Return
	EndIf

	$Align_to_y = 0
	$Align_to_x = 0
	$control_pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	$WinSize = WinGetClientSize($GUI_Editor)

	$Align_to_x = ($WinSize[0] / 2) - ($control_pos[2] / 2)
	$Align_to_y = $control_pos[1]

	GUICtrlSetPos($Markiertes_Control_ID, $Align_to_x, $Align_to_y, $control_pos[2], $control_pos[3])
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_IniWriteEx($Cache_Datei_Handle, "tab", "y", $Align_to_y)
		_IniWriteEx($Cache_Datei_Handle, "tab", "x", $Align_to_x)
		_Resize_tabcontent($control_pos[0], $control_pos[1])
	Else
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "y", $Align_to_y)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "x", $Align_to_x)
		If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "type", "") = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $control_pos[0], $control_pos[1], $control_pos[2], $control_pos[3])
	EndIf
	_Aktualisiere_Rahmen(1)
	_Lese_MiniEditor($Markiertes_Control_ID)
EndFunc   ;==>_Control_horizontal_zentrieren

Func _Control_vertical_zentrieren()
	If $Control_Markiert_MULTI = 1 Then Return
	If $Markiertes_Control_ID = "" Then Return
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		If _IniReadEx($Cache_Datei_Handle, "tab", "locked", 0) = 1 Then Return
	Else
		If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "locked", 0) = 1 Then Return
	EndIf
	$Align_to_y = 0
	$Align_to_x = 0
	$control_pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	$WinSize = WinGetClientSize($GUI_Editor)

	$Align_to_x = $control_pos[0]
	$Align_to_y = ($WinSize[1] / 2) - ($control_pos[3] / 2)

	GUICtrlSetPos($Markiertes_Control_ID, $Align_to_x, $Align_to_y, $control_pos[2], $control_pos[3])
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_IniWriteEx($Cache_Datei_Handle, "tab", "y", $Align_to_y)
		_IniWriteEx($Cache_Datei_Handle, "tab", "x", $Align_to_x)
		_Resize_tabcontent($control_pos[0], $control_pos[1])
	Else
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "y", $Align_to_y)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "x", $Align_to_x)
		If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "type", "") = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $control_pos[0], $control_pos[1], $control_pos[2], $control_pos[3])
	EndIf
	_Aktualisiere_Rahmen(1)
	_Lese_MiniEditor($Markiertes_Control_ID)
EndFunc   ;==>_Control_vertical_zentrieren

Func _Control_zentrieren()
	If $Control_Markiert_MULTI = 1 Then Return
	If $Markiertes_Control_ID = "" Then Return
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		If _IniReadEx($Cache_Datei_Handle, "tab", "locked", 0) = 1 Then Return
	Else
		If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "locked", 0) = 1 Then Return
	EndIf
	$Align_to_y = 0
	$Align_to_x = 0
	$control_pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
	$WinSize = WinGetClientSize($GUI_Editor)
	$Align_to_x = ($WinSize[0] / 2) - ($control_pos[2] / 2)
	$Align_to_y = ($WinSize[1] / 2) - ($control_pos[3] / 2)
	GUICtrlSetPos($Markiertes_Control_ID, $Align_to_x, $Align_to_y, $control_pos[2], $control_pos[3])
	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		_IniWriteEx($Cache_Datei_Handle, "tab", "y", $Align_to_y)
		_IniWriteEx($Cache_Datei_Handle, "tab", "x", $Align_to_x)
		_Resize_tabcontent($control_pos[0], $control_pos[1])
	Else
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "y", $Align_to_y)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "x", $Align_to_x)
		If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "type", "") = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $control_pos[0], $control_pos[1], $control_pos[2], $control_pos[3])
	EndIf
	_Aktualisiere_Rahmen(1)
	_Lese_MiniEditor($Markiertes_Control_ID)
EndFunc   ;==>_Control_zentrieren

Func _Am_Raster_Ausrichten()
	If $Control_Markiert_MULTI = 0 Then

		$Align_to_y = 0
		$Align_to_x = 0
		If $Markiertes_Control_ID = $TABCONTROL_ID Then
			If _IniReadEx($Cache_Datei_Handle, "tab", "locked", 0) = 1 Then Return
		Else
			If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "locked", 0) = 1 Then Return
		EndIf
		$control_pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		GUICtrlSetPos($Markiertes_Control_ID, Round($control_pos[0] / $raster) * $raster, Round($control_pos[1] / $raster) * $raster)
		$control_pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
		If $Markiertes_Control_ID = $TABCONTROL_ID Then
			_IniWriteEx($Cache_Datei_Handle, "tab", "y", $control_pos[1])
			_IniWriteEx($Cache_Datei_Handle, "tab", "x", $control_pos[0])
		Else
			_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "y", $control_pos[1])
			_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "x", $control_pos[0])
		EndIf
		_Aktualisiere_Rahmen(1)
		_Lese_MiniEditor($Markiertes_Control_ID)

	Else

		For $r = 1 To $Markierte_Controls_IDs[0]
			If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 1 Then ContinueLoop
			$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
			GUICtrlSetPos($Markierte_Controls_IDs[$r], Round($Pos_C[0] / $raster) * $raster, Round($Pos_C[1] / $raster) * $raster)
			_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
			$Pos_C = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
			If $Markierte_Controls_Sections[$r - 1] = GUICtrlGetHandle($TABCONTROL_ID) Then
				_IniWriteEx($Cache_Datei_Handle, "tab", "x", $Pos_C[0])
				_IniWriteEx($Cache_Datei_Handle, "tab", "y", $Pos_C[1])
			Else
				_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_C[0])
				_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_C[1])
			EndIf
		Next

	EndIf
EndFunc   ;==>_Am_Raster_Ausrichten

Func _Resize_tabcontent($x = 0, $y = 0)
	If $Use_repos = 0 Then Return
	$Pos_Now = ControlGetPos($GUI_Editor, "", $TABCONTROL_ID)
	$Diff_x = $Pos_Now[0] - $x
	$Diff_y = $Pos_Now[1] - $y
	If $Diff_x = 0 And $Diff_y = 0 Then Return
	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	If @error Then
		Sleep(0)
	Else
		For $i = 1 To $var[0]
			If _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "-1") <> "-1" Then
				$handle = _IniReadEx($Cache_Datei_Handle, $var[$i], "handle", "")
				If $handle = $TABCONTROL_ID Then ContinueLoop
				If $handle = "" Then ContinueLoop
				$Pos_tmp = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($handle))
				GUICtrlSetPos($handle, $Pos_tmp[0] + $Diff_x, $Pos_tmp[1] + $Diff_y)
				_IniWriteEx($Cache_Datei_Handle, $var[$i], "x", $Pos_tmp[0] + $Diff_x)
				_IniWriteEx($Cache_Datei_Handle, $var[$i], "y", $Pos_tmp[1] + $Diff_y)
			EndIf
		Next
	EndIf
EndFunc   ;==>_Resize_tabcontent

Func _Resize_groupcontent($grouphandle = "", $x = 0, $y = 0, $width = 0, $height = 0)
	If $Use_repos = 0 Then Return
	$Pos_Now = ControlGetPos($GUI_Editor, "", $grouphandle)
	$Diff_x = $Pos_Now[0] - $x
	$Diff_y = $Pos_Now[1] - $y
	$Meine_Tab_ID = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($grouphandle), "tabpage", "-1")
	If $Diff_x = 0 And $Diff_y = 0 Then Return
	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	If @error Then
		Sleep(0)
	Else
		For $i = 1 To $var[0]
			$readen_X = _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "0")
			$readen_y = _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "0")
			$readen_width = _IniReadEx($Cache_Datei_Handle, $var[$i], "width", "0")
			$readen_height = _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "0")

			If ($readen_X > $x) And ($readen_X < $x + $width) And ($readen_X + $readen_width < $x + $width) And ($readen_y > $y) And ($readen_y < $y + $height) And ($readen_y + $readen_height < $y + $height) Then ;move only controls in the group
				$handle = _IniReadEx($Cache_Datei_Handle, $var[$i], "handle", "")
				If $handle = $grouphandle Then ContinueLoop
				If $handle = "" Then ContinueLoop
				If $Meine_Tab_ID <> _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "-1") Then ContinueLoop ;Bewege nur controls am selben Tab wie ich
				$Pos_tmp = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($handle))
				GUICtrlSetPos($handle, $Pos_tmp[0] + $Diff_x, $Pos_tmp[1] + $Diff_y)
				_IniWriteEx($Cache_Datei_Handle, $var[$i], "x", $Pos_tmp[0] + $Diff_x)
				_IniWriteEx($Cache_Datei_Handle, $var[$i], "y", $Pos_tmp[1] + $Diff_y)
			EndIf
		Next
	EndIf
EndFunc   ;==>_Resize_groupcontent

Func _Controls_in_Group_auf_Tab_verschieben($grouphandle = "", $alte_Seite = "", $Neue_Seite = "")
	If $grouphandle = "" Then Return
	If $alte_Seite = "" Then Return
	If $Neue_Seite = "" Then Return
	If $Use_repos = "0" Then Return
	$Meine_Tab_ID = $alte_Seite
	$Pos_Now = ControlGetPos($GUI_Editor, "", $grouphandle)
	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	If @error Then
		Sleep(0)
	Else
		For $i = 1 To $var[0]
			$readen_X = _IniReadEx($Cache_Datei_Handle, $var[$i], "x", "0")
			$readen_y = _IniReadEx($Cache_Datei_Handle, $var[$i], "y", "0")
			$readen_width = _IniReadEx($Cache_Datei_Handle, $var[$i], "width", "0")
			$readen_height = _IniReadEx($Cache_Datei_Handle, $var[$i], "height", "0")

			If ($readen_X > $Pos_Now[0]) And ($readen_X < $Pos_Now[0] + $Pos_Now[2]) And ($readen_X + $readen_width < $Pos_Now[0] + $Pos_Now[2]) And ($readen_y > $Pos_Now[1]) And ($readen_y < $Pos_Now[1] + $Pos_Now[3]) And ($readen_y + $readen_height < $Pos_Now[1] + $Pos_Now[3]) Then ;Betrifft nur controls IM group
				$handle = _IniReadEx($Cache_Datei_Handle, $var[$i], "handle", "")
				If $handle = $grouphandle Then ContinueLoop
				If $handle = "" Then ContinueLoop
				If $Meine_Tab_ID <> _IniReadEx($Cache_Datei_Handle, $var[$i], "tabpage", "-1") Then ContinueLoop ;Nur controls am selben Tab wie ich
				_IniWriteEx($Cache_Datei_Handle, $var[$i], "tabpage", $Neue_Seite)
			EndIf
		Next
	EndIf
EndFunc   ;==>_Controls_in_Group_auf_Tab_verschieben



Func GUICtrlCreatePng($hWnd, $sPath, $iX, $iY) ; SEuBo
	_GDIPlus_Startup()
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend, $hGUI
	Local $hImage = _GDIPlus_ImageLoadFromFile($sPath), $iWidth = _GDIPlus_ImageGetWidth($hImage), $iHeight = _GDIPlus_ImageGetHeight($hImage)
	$hGUI = GUICreate("", $iWidth, $iHeight, $iX, $iY, 0x80000000, BitOR(0x40, 0x80000, $WS_EX_TRANSPARENT), $hWnd)
	$cLabel = GUICtrlCreateLabel("", 0, 0, $iWidth, $iHeight)
	GUICtrlSetBkColor(-1, -2)
	GUISetState(@SW_SHOWNOACTIVATE, $hGUI)
	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate("int X;int Y")
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", $iWidth)
	DllStructSetData($tSize, "Y", $iHeight)
	$tSource = DllStructCreate("int X;int Y")
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate("byte Op;byte Flags;byte Alpha;byte Format")
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", 255)
	DllStructSetData($tBlend, "Format", 1)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
	GUISwitch($hWnd)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
	Return $hGUI
EndFunc   ;==>GUICtrlCreatePng

;(c) by BuckMaster

Func _DrawGrid($Length, $GridColor)
	GUISwitch($GUI_Editor)
	$hPos = WinGetPos($GUI_Editor)
	$hWidth = $hPos[2]
	$hHeight = $hPos[3]
	$Grid_Handle = GUICtrlCreateGraphic(0, 0, $hWidth, $hHeight)
	For $i = $Length To @DesktopWidth Step $Length
		GUICtrlSetGraphic($Grid_Handle, $GUI_GR_COLOR, $GridColor)
		GUICtrlSetGraphic($Grid_Handle, $GUI_GR_MOVE, $i, 0)
		GUICtrlSetGraphic($Grid_Handle, $GUI_GR_LINE, $i, 0)
		GUICtrlSetGraphic($Grid_Handle, $GUI_GR_LINE, $i, @DesktopHeight)
	Next
	For $i = $Length To @DesktopHeight Step $Length
		GUICtrlSetGraphic($Grid_Handle, $GUI_GR_COLOR, $GridColor)
		GUICtrlSetGraphic($Grid_Handle, $GUI_GR_MOVE, 0, $i)
		GUICtrlSetGraphic($Grid_Handle, $GUI_GR_LINE, 0, $i)
		GUICtrlSetGraphic($Grid_Handle, $GUI_GR_LINE, @DesktopWidth, $i)
	Next
	GUICtrlSetState($Grid_Handle, $GUI_DISABLE)
	Return $Grid_Handle
EndFunc   ;==>_DrawGrid

;===============================================================================
; Function Name:    _GUICtrlListView_MoveItems()
; Description:      Move selected item(s) in ListView Up or Down.
;
; Parameter(s):     $hWnd               - Window handle of ListView control (can be a Title).
;                   $vListView          - The ID/Handle/Class of ListView control.
;                   $iDirection         - [Optional], define in what direction item(s) will move:
;                                            1 (default) - item(s) will move Next.
;                                           -1 item(s) will move Back.
;                   $sIconsFile         - Icon file to set image for the items (only for internal usage).
;                   $iIconID_Checked    - Icon ID in $sIconsFile for checked item(s).
;                   $iIconID_UnChecked  - Icon ID in $sIconsFile for Unchecked item(s).
;
; Requirement(s):   #include <GuiListView.au3>, AutoIt 3.2.10.0.
;
; Return Value(s):  On seccess - Move selected item(s) Next/Back.
;                   On failure - Return "" (empty string) and set @error as following:
;                                                                  1 - No selected item(s).
;                                                                  2 - $iDirection is wrong value (not 1 and not -1).
;                                                                  3 - Item(s) can not be moved, reached last/first item.
;
; Note(s):          * This function work with external ListView Control as well.
;                   * If you select like 15-20 (or more) items, moving them can take a while :( (depends on how many items moved).
;
; Author(s):        G.Sandler a.k.a CreatoR (http://creator-lab.ucoz.ru)
;===============================================================================

Func _GUICtrlListView_MoveItems($hWnd, $vListView, $iDirection = 1, $sIconsFile = "", $iIconID_Checked = 0, $iIconID_UnChecked = 0)
	Local $hListView = $vListView
	If Not IsHWnd($hListView) Then $hListView = ControlGetHandle($hWnd, "", $hListView)

	Local $aSelected_Indices = _GUICtrlListView_GetSelectedIndices($hListView, 1)
	If UBound($aSelected_Indices) < 2 Then Return SetError(1, 0, "")
	If $iDirection <> 1 And $iDirection <> -1 Then Return SetError(2, 0, "")

	Local $iTotal_Items = ControlListView($hWnd, "", $hListView, "GetItemCount")
	Local $iTotal_Columns = ControlListView($hWnd, "", $hListView, "GetSubItemCount")

	Local $iUbound = UBound($aSelected_Indices) - 1, $iNum = 1, $iStep = 1
	Local $iCurrent_Index, $iUpDown_Index, $sCurrent_ItemText, $sUpDown_ItemText
	Local $iCurrent_Index, $iCurrent_CheckedState, $iUpDown_CheckedState

	If ($iDirection = -1 And $aSelected_Indices[1] = 0) Or _
			($iDirection = 1 And $aSelected_Indices[$iUbound] = $iTotal_Items - 1) Then Return SetError(3, 0, "")

	ControlListView($hWnd, "", $hListView, "SelectClear")

	Local $aOldSelected_IDs[1]
	Local $iIconsFileExists = FileExists($sIconsFile)

	If $iIconsFileExists Then
		For $i = 1 To $iUbound
			ReDim $aOldSelected_IDs[UBound($aOldSelected_IDs) + 1]
			_GUICtrlListView_SetItemSelected($hListView, $aSelected_Indices[$i], True)
			$aOldSelected_IDs[$i] = GUICtrlRead($vListView)
			_GUICtrlListView_SetItemSelected($hListView, $aSelected_Indices[$i], False)
		Next
		ControlListView($hWnd, "", $hListView, "SelectClear")
	EndIf

	If $iDirection = 1 Then
		$iNum = $iUbound
		$iUbound = 1
		$iStep = -1
	EndIf

	For $i = $iNum To $iUbound Step $iStep
		$iCurrent_Index = $aSelected_Indices[$i]
		$iUpDown_Index = $aSelected_Indices[$i] + 1
		If $iDirection = -1 Then $iUpDown_Index = $aSelected_Indices[$i] - 1

		$iCurrent_CheckedState = _GUICtrlListView_GetItemChecked($hListView, $iCurrent_Index)
		$iUpDown_CheckedState = _GUICtrlListView_GetItemChecked($hListView, $iUpDown_Index)

		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index)

		For $j = 0 To $iTotal_Columns - 1
			$sCurrent_ItemText = _GUICtrlListView_GetItemText($hListView, $iCurrent_Index, $j)
			$sUpDown_ItemText = _GUICtrlListView_GetItemText($hListView, $iUpDown_Index, $j)

;~             _GUICtrlListView_SetItemText($hListView, $iUpDown_Index, $sCurrent_ItemText, $j)
			_GUICtrlListView_SetItem($hListView, $sCurrent_ItemText, $iUpDown_Index, $j, _typereturnicon(_GUICtrlListView_GetItemText($hListView, $iCurrent_Index, 1)))
;~             _GUICtrlListView_SetItemText($hListView, $iCurrent_Index, $sUpDown_ItemText, $j)
			_GUICtrlListView_SetItem($hListView, $sUpDown_ItemText, $iCurrent_Index, $j, _typereturnicon(_GUICtrlListView_GetItemText($hListView, $iUpDown_Index, 1)))
		Next

		_GUICtrlListView_SetItemChecked($hListView, $iUpDown_Index, $iCurrent_CheckedState)
		_GUICtrlListView_SetItemChecked($hListView, $iCurrent_Index, $iUpDown_CheckedState)

		If $iIconsFileExists Then
			If $iCurrent_CheckedState = 1 Then
				GUICtrlSetImage(GUICtrlRead($vListView), $sIconsFile, $iIconID_Checked, 0)
			Else
				GUICtrlSetImage(GUICtrlRead($vListView), $sIconsFile, $iIconID_UnChecked, 0)
			EndIf

			If $iUpDown_CheckedState = 1 Then
				GUICtrlSetImage($aOldSelected_IDs[$i], $sIconsFile, $iIconID_Checked, 0)
			Else
				GUICtrlSetImage($aOldSelected_IDs[$i], $sIconsFile, $iIconID_UnChecked, 0)
			EndIf
		EndIf

		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index, 0)
	Next

	For $i = 1 To UBound($aSelected_Indices) - 1
		$iUpDown_Index = $aSelected_Indices[$i] + 1
		If $iDirection = -1 Then $iUpDown_Index = $aSelected_Indices[$i] - 1
		_GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index)
	Next
	ControlFocus($hWnd, "", $hListView)
	_GUICtrlListView_SetSelectionMark($hListView, $iUpDown_Index)
EndFunc   ;==>_GUICtrlListView_MoveItems

Func _Zeige_Control_Reihenfolge_GUI()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($control_reihenfolge_GUI_listview))
	_GUICtrlListView_BeginUpdate($control_reihenfolge_GUI_listview)

	$var = _IniReadSectionNamesEx($Cache_Datei_Handle2)
	$var = _sortiere_Controls_nach_Order($var)
	If IsArray($var) Then
		For $x = 1 To $var[0]
			If $var[$x] = GUICtrlGetHandle($TABCONTROL_ID) Then ContinueLoop ;Tab kommt NICHT in die Liste...
			If $var[$x] = GUICtrlGetHandle($MENUCONTROL_ID) Then ContinueLoop ;..und Menü auch nicht!
			_GUICtrlListView_AddItem($control_reihenfolge_GUI_listview, "", _typereturnicon(_IniReadEx($Cache_Datei_Handle, $var[$x], "type", "")))
			_GUICtrlListView_AddSubItem($control_reihenfolge_GUI_listview, _GUICtrlListView_GetItemCount($control_reihenfolge_GUI_listview) - 1, _IniReadEx($Cache_Datei_Handle, $var[$x], "type", ""), 1)
			_GUICtrlListView_AddSubItem($control_reihenfolge_GUI_listview, _GUICtrlListView_GetItemCount($control_reihenfolge_GUI_listview) - 1, _IniReadEx($Cache_Datei_Handle, $var[$x], "text", ""), 2)
			_GUICtrlListView_AddSubItem($control_reihenfolge_GUI_listview, _GUICtrlListView_GetItemCount($control_reihenfolge_GUI_listview) - 1, _IniReadEx($Cache_Datei_Handle, $var[$x], "id", ""), 3)
			_GUICtrlListView_AddSubItem($control_reihenfolge_GUI_listview, _GUICtrlListView_GetItemCount($control_reihenfolge_GUI_listview) - 1, $var[$x], 4)

		Next
	EndIf
	_GUICtrlListView_EndUpdate($control_reihenfolge_GUI_listview)
	_GUICtrlListView_RegisterSortCallBack($control_reihenfolge_GUI_listview)
	_Elemente_an_Fesntergroesse_anpassen()
	GUISetState(@SW_DISABLE, $MiniEditor)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_SHOW, $control_reihenfolge_GUI)
EndFunc   ;==>_Zeige_Control_Reihenfolge_GUI

Func _Listview_Sortieren($control = "", $column = 0)
	If $control = "" Then Return
	_GUICtrlListView_SortItems($control, $column)
EndFunc   ;==>_Listview_Sortieren


Func _Control_Reihenfolge_Abbrechen()
	_GUICtrlListView_UnRegisterSortCallBack($control_reihenfolge_GUI_listview)
	GUISetState(@SW_ENABLE, $MiniEditor)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $control_reihenfolge_GUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_Control_Reihenfolge_Abbrechen

Func _Control_Reihenfolge_verschiebe_nach_unten()
	If _GUICtrlListView_GetSelectionMark($control_reihenfolge_GUI_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($control_reihenfolge_GUI_listview) = 0 Then Return
	_GUICtrlListView_MoveItems($control_reihenfolge_GUI, $control_reihenfolge_GUI_listview, 1)
	_GUICtrlListView_EnsureVisible($control_reihenfolge_GUI_listview, _GUICtrlListView_GetSelectionMark($control_reihenfolge_GUI_listview))
	_GUICtrlListView_SetItemSelected($control_reihenfolge_GUI_listview, _GUICtrlListView_GetSelectionMark($control_reihenfolge_GUI_listview), True, True)
EndFunc   ;==>_Control_Reihenfolge_verschiebe_nach_unten

Func _Control_Reihenfolge_verschiebe_nach_oben()
	If _GUICtrlListView_GetSelectionMark($control_reihenfolge_GUI_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($control_reihenfolge_GUI_listview) = 0 Then Return
	_GUICtrlListView_MoveItems($control_reihenfolge_GUI, $control_reihenfolge_GUI_listview, -1)
	_GUICtrlListView_EnsureVisible($control_reihenfolge_GUI_listview, _GUICtrlListView_GetSelectionMark($control_reihenfolge_GUI_listview))
	_GUICtrlListView_SetItemSelected($control_reihenfolge_GUI_listview, _GUICtrlListView_GetSelectionMark($control_reihenfolge_GUI_listview), True, True)
EndFunc   ;==>_Control_Reihenfolge_verschiebe_nach_oben

Func _Control_Reihenfolge_OK()
	If _GUICtrlListView_GetItemCount($control_reihenfolge_GUI_listview) <> 0 Then
		For $x = 0 To _GUICtrlListView_GetItemCount($control_reihenfolge_GUI_listview) - 1
			$Section = _GUICtrlListView_GetItemText($control_reihenfolge_GUI_listview, $x, 4)
			_IniWriteEx($Cache_Datei_Handle, $Section, "order", $x)
		Next
	EndIf
	_Control_Reihenfolge_Abbrechen()
	_Update_ControlList()
EndFunc   ;==>_Control_Reihenfolge_OK

Func _Finde_Arbeitsverzeichnis()
	Dim $szDrive, $szDir, $szFName, $szExt
	$Pfad = $Pfad_zur_Studioconfig
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($Pfad, $szDrive, $szDir, $szFName, $szExt)
	$Pfad = $szDrive & StringTrimRight($szDir, StringLen($szDir) - StringInStr($szDir, "\Data\", 0, -1) + 1)
	Return $Pfad
EndFunc   ;==>_Finde_Arbeitsverzeichnis

Func _Listview_Zeige_Spalteneditor()
	If GUICtrlRead($MiniEditor_Text_Radio2) = $GUI_Checked Then
		_Zeige_Erweiterten_Text()
		Return
	EndIf
	_Lade_Spalten_in_Spalteneditor()
	GUISetState(@SW_DISABLE, $MiniEditor)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_SHOW, $formstudio_listview_SpalteneditorGUI)
EndFunc   ;==>_Listview_Zeige_Spalteneditor

Func _Listview_Verstecke_Spalteneditor()
	GUISetState(@SW_ENABLE, $MiniEditor)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $formstudio_listview_SpalteneditorGUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_Listview_Verstecke_Spalteneditor


Func _Lade_Spalten_in_Spalteneditor()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($spalteneditor_listview))
	$Spalten = GUICtrlRead($MiniEditor_Text)
	If $Spalten = "" Then Return
	$Split = StringSplit($Spalten, "|", 2)
	If IsArray($Split) Then
		For $x = 0 To UBound($Split) - 1
			_GUICtrlListView_AddItem($spalteneditor_listview, $Split[$x])
		Next
	EndIf
	GUICtrlSetData($spalteneditor_neuespalte_input, "")
	GUICtrlSetState($spalteneditor_neuespalte_input, $GUI_FOCUS)
EndFunc   ;==>_Lade_Spalten_in_Spalteneditor

Func _Spalteneditor_verschiebe_Spalte_nach_unten()
	If _GUICtrlListView_GetSelectionMark($spalteneditor_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($spalteneditor_listview) = 0 Then Return
	_GUICtrlListView_MoveItems($formstudio_listview_SpalteneditorGUI, $spalteneditor_listview, 1)
	_GUICtrlListView_EnsureVisible($spalteneditor_listview, _GUICtrlListView_GetSelectionMark($spalteneditor_listview))
	_GUICtrlListView_SetItemSelected($spalteneditor_listview, _GUICtrlListView_GetSelectionMark($spalteneditor_listview), True, True)
EndFunc   ;==>_Spalteneditor_verschiebe_Spalte_nach_unten

Func _Spalteneditor_verschiebe_Spalte_nach_oben()
	If _GUICtrlListView_GetSelectionMark($spalteneditor_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($spalteneditor_listview) = 0 Then Return
	_GUICtrlListView_MoveItems($formstudio_listview_SpalteneditorGUI, $spalteneditor_listview, -1)
	_GUICtrlListView_EnsureVisible($spalteneditor_listview, _GUICtrlListView_GetSelectionMark($spalteneditor_listview))
	_GUICtrlListView_SetItemSelected($spalteneditor_listview, _GUICtrlListView_GetSelectionMark($spalteneditor_listview), True, True)
EndFunc   ;==>_Spalteneditor_verschiebe_Spalte_nach_oben

Func _Spalteneditor_neue_Spalte_einfuegen()
	$Spalten_name = GUICtrlRead($spalteneditor_neuespalte_input)
	If $Spalten_name = "" Then Return
	$Index = _GUICtrlListView_AddItem($spalteneditor_listview, $Spalten_name)
	_GUICtrlListView_EnsureVisible($spalteneditor_listview, $Index)
	GUICtrlSetData($spalteneditor_neuespalte_input, "")
EndFunc   ;==>_Spalteneditor_neue_Spalte_einfuegen

Func _Spalteneditor_OK()
	_Listview_Verstecke_Spalteneditor()
	$Spaltenstring = ""
	For $x = 0 To _GUICtrlListView_GetItemCount($spalteneditor_listview) - 1
		$Spaltenstring = $Spaltenstring & _GUICtrlListView_GetItemText($spalteneditor_listview, $x) & "|"
	Next
	If StringTrimLeft($Spaltenstring, StringLen($Spaltenstring) - 1) = "|" Then $Spaltenstring = StringTrimRight($Spaltenstring, 1)
	GUICtrlSetData($MiniEditor_Text, $Spaltenstring)
	_Listview_Erneuere_Spalten($Markiertes_Control_ID, $Spaltenstring)
	_IniWriteEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "text", $Spaltenstring)
EndFunc   ;==>_Spalteneditor_OK


Func _Spalteneditor_Spalte_loeschen()
	If _GUICtrlListView_GetSelectionMark($spalteneditor_listview) = -1 Then Return
	If _GUICtrlListView_GetItemCount($spalteneditor_listview) = 0 Then Return
	_GUICtrlListView_DeleteItem(GUICtrlGetHandle($spalteneditor_listview), _GUICtrlListView_GetSelectionMark($spalteneditor_listview))
EndFunc   ;==>_Spalteneditor_Spalte_loeschen

Func _Listview_Erneuere_Spalten($handle = "", $Splatenstring = "")
	If $handle = "" Then Return
	;Lösche alle Spalten...
	While _GUICtrlListView_GetColumnCount($handle) > 0
		_GUICtrlListView_DeleteColumn($handle, 0)
	WEnd
	;..und baue sie neu auf
	$Spalten = GUICtrlRead($MiniEditor_Text)
	If $Spalten = "" Then Return
	$Split = StringSplit($Spalten, "|", 2)
	If IsArray($Split) Then
		For $x = 0 To UBound($Split) - 1
			_GUICtrlListView_AddColumn($handle, $Split[$x])
		Next
	EndIf
EndFunc   ;==>_Listview_Erneuere_Spalten


Func __WinAPI_ShellExtractIcons($sIcon, $iIndex, $iWidth, $iHeight)
	Local $Ret = DllCall('shell32.dll', 'int', 'SHExtractIconsW', 'wstr', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)
	If (@error) Or ($Ret[0] = 0) Or ($Ret[5] = Ptr(0)) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $Ret[5]
EndFunc   ;==>__WinAPI_ShellExtractIcons



Func __SetIconAlpha($hWnd, $sIcon, $iIndex, $iWidth, $iHeight)
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	Local $hIcon = __WinAPI_ShellExtractIcons($sIcon, $iIndex, $iWidth, $iHeight)
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
EndFunc   ;==>__SetIconAlpha

; #FUNCTION# ============================================================================================================================
; Name...........: _ProcessGetWindow
;
; Description ...: Returns an array of HWNDs containing all windows owned by the process $p_PID, or optionally a single "best guess."
;
; Syntax.........: _ProcessGetWindow( $p_PID [, $p_ReturnBestGuess = False ])
;
; Parameters ....: $p_PID - The PID of the process you want the Window for.
;                  $p_ReturnBestGuess - If True, function will return only 1 reult on a best-guess basis.
;                                           The "Best Guess" is the VISIBLE window owned by $p_PID with the longest title.
;
; Return values .: Success      - Return $_array containing HWND info.
;                                       $_array[0] = Number of results
;                                       $_array[n] = HWND of Window n
;
;                  Failure      - Returns 0
;
;                  Error        - Returns -1 and sets @error
;                                            1 - Requires a non-zero number.
;                                            2 - Process does not exist
;                                            3 - WinList() Error
;
; Author ........: Andrew Bobulsky, contact: RulerOf <at that public email service provided by Google>.
; Remarks .......: The reverse of WinGetProcess()
; =======================================================================================================================================

Func _ProcessGetWindow($p_PID, $p_ReturnBestGuess = False)

	Local $p_ReturnVal[1] = [0]

	Local $p_WinList = WinList()

	If @error Then ;Some Error handling
		SetError(3)
		Return -1
	EndIf

	If $p_PID = 0 Then ;Some Error handling
		SetError(1)
		Return -1
	EndIf

	If ProcessExists($p_PID) = 0 Then ;Some Error handling
		ConsoleWrite("_ProcessGetWindow: Process " & $p_PID & " doesn't exist!" & @CRLF)
		SetError(2)
		Return -1
	EndIf

	For $i = 1 To $p_WinList[0][0] Step 1
		Local $w_PID = WinGetProcess($p_WinList[$i][1])

		; ConsoleWrite("Processing Window: " & Chr(34) & $p_WinList[$i][0] & Chr(34) & @CRLF & " with HWND: " & $p_WinList[$i][1] & @CRLF & " and PID: " & $w_PID & @CRLF)

		If $w_PID = $p_PID Then
			;ConsoleWrite("Match: HWND " & $p_WinList[$i][1] & @CRLF)
			$p_ReturnVal[0] += 1
			_ArrayAdd($p_ReturnVal, $p_WinList[$i][1])
		EndIf
	Next

	If $p_ReturnVal[0] > 1 Then

		If $p_ReturnBestGuess Then

			Do

				Local $i_State = WinGetState($p_ReturnVal[2])
				Local $i_StateLongest = WinGetState($p_ReturnVal[1])

				Select
					Case BitAND($i_State, 2) And BitAND($i_StateLongest, 2) ;If they're both visible
						If StringLen(WinGetTitle($p_ReturnVal[2])) > StringLen(WinGetTitle($p_ReturnVal[1])) Then ;And the new one has a longer title
							_ArrayDelete($p_ReturnVal, 1) ;Delete the "loser"
							$p_ReturnVal[0] -= 1 ;Decrement counter
						Else
							_ArrayDelete($p_ReturnVal, 2) ;Delete the failed challenger
							$p_ReturnVal[0] -= 1
						EndIf

					Case BitAND($i_State, 2) And Not BitAND($i_StateLongest, 2) ;If the new one's visible and the old one isn't
						_ArrayDelete($p_ReturnVal, 1) ;Delete the old one
						$p_ReturnVal[0] -= 1 ;Decrement counter

					Case Else ;Neither window is visible, let's just keep the first one.
						_ArrayDelete($p_ReturnVal, 2)
						$p_ReturnVal[0] -= 1

				EndSelect

			Until $p_ReturnVal[0] = 1

		EndIf

		Return $p_ReturnVal

	ElseIf $p_ReturnVal[0] = 1 Then
		Return $p_ReturnVal ;Only 1 window.
	Else
		Return 0 ;Window not found.
	EndIf
EndFunc   ;==>_ProcessGetWindow

Func _Resize_uncheck_all()
	GUICtrlSetState($formstudio_resizing_GUI_DOCKAUTO, $GUI_UNCHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKLEFT, $GUI_UNCHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKRIGHT, $GUI_UNCHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKHCENTER, $GUI_UNCHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKTOP, $GUI_UNCHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKBOTTOM, $GUI_UNCHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKVCENTER, $GUI_UNCHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKWIDTH, $GUI_UNCHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKHEIGHT, $GUI_UNCHECKED)
EndFunc   ;==>_Resize_uncheck_all

Func _SHOW_Resize_Form()
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)

	_Resize_uncheck_all()

	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKAUTO) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKAUTO, $GUI_CHECKED)
	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKLEFT) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKLEFT, $GUI_CHECKED)
	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKRIGHT) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKRIGHT, $GUI_CHECKED)
	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKHCENTER) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKHCENTER, $GUI_CHECKED)
	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKTOP) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKTOP, $GUI_CHECKED)
	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKBOTTOM) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKBOTTOM, $GUI_CHECKED)
	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKVCENTER) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKVCENTER, $GUI_CHECKED)
	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKWIDTH) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKWIDTH, $GUI_CHECKED)
	If BitAND(GUICtrlRead($MiniEditor_Resize_input), $GUI_DOCKHEIGHT) Then GUICtrlSetState($formstudio_resizing_GUI_DOCKHEIGHT, $GUI_CHECKED)


	GUISetState(@SW_SHOW, $formstudio_resizing_GUI)
EndFunc   ;==>_SHOW_Resize_Form


Func _formstudio_resizing_docksize()
	_Resize_uncheck_all()
	GUICtrlSetState($formstudio_resizing_GUI_DOCKWIDTH, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKHEIGHT, $GUI_CHECKED)
EndFunc   ;==>_formstudio_resizing_docksize

Func _formstudio_resizing_dockall()
	_Resize_uncheck_all()
	GUICtrlSetState($formstudio_resizing_GUI_DOCKLEFT, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKTOP, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKWIDTH, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKHEIGHT, $GUI_CHECKED)
EndFunc   ;==>_formstudio_resizing_dockall

Func _formstudio_resizing_dockmenubar()
	_Resize_uncheck_all()
	GUICtrlSetState($formstudio_resizing_GUI_DOCKTOP, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKHEIGHT, $GUI_CHECKED)
EndFunc   ;==>_formstudio_resizing_dockmenubar

Func _formstudio_resizing_dockborders()
	_Resize_uncheck_all()
	GUICtrlSetState($formstudio_resizing_GUI_DOCKLEFT, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKRIGHT, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKTOP, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKBOTTOM, $GUI_CHECKED)
EndFunc   ;==>_formstudio_resizing_dockborders

Func _formstudio_resizing_dockstatebar()
	_Resize_uncheck_all()
	GUICtrlSetState($formstudio_resizing_GUI_DOCKHEIGHT, $GUI_CHECKED)
	GUICtrlSetState($formstudio_resizing_GUI_DOCKBOTTOM, $GUI_CHECKED)
EndFunc   ;==>_formstudio_resizing_dockstatebar

Func _formstudio_resizing_OK()
	$Style = 0
	If GUICtrlRead($formstudio_resizing_GUI_DOCKAUTO) = $GUI_CHECKED Then $Style = $Style + 1
	If GUICtrlRead($formstudio_resizing_GUI_DOCKLEFT) = $GUI_CHECKED Then $Style = $Style + 2
	If GUICtrlRead($formstudio_resizing_GUI_DOCKRIGHT) = $GUI_CHECKED Then $Style = $Style + 4
	If GUICtrlRead($formstudio_resizing_GUI_DOCKHCENTER) = $GUI_CHECKED Then $Style = $Style + 8
	If GUICtrlRead($formstudio_resizing_GUI_DOCKTOP) = $GUI_CHECKED Then $Style = $Style + 32
	If GUICtrlRead($formstudio_resizing_GUI_DOCKBOTTOM) = $GUI_CHECKED Then $Style = $Style + 64
	If GUICtrlRead($formstudio_resizing_GUI_DOCKVCENTER) = $GUI_CHECKED Then $Style = $Style + 128
	If GUICtrlRead($formstudio_resizing_GUI_DOCKWIDTH) = $GUI_CHECKED Then $Style = $Style + 256
	If GUICtrlRead($formstudio_resizing_GUI_DOCKHEIGHT) = $GUI_CHECKED Then $Style = $Style + 512

	If $Style = 0 Then $Style = ""
	GUICtrlSetData($MiniEditor_Resize_input, $Style)
	_HIDE_Resize_Form()
EndFunc   ;==>_formstudio_resizing_OK


Func _HIDE_Resize_Form()
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_HIDE, $formstudio_resizing_GUI)
	GUISetState(@SW_SHOW, $StudioFenster)
	GUISetState(@SW_SHOW, $GUI_Editor)

	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_HIDE_Resize_Form

Func _Sortiere_Listview($Listview = "", $Colum = "-1", $Direction = "-1")
	If $Listview = "" Then Return
	If $Colum = "-1" Then $Colum = GUICtrlGetState($Listview)
	If $Direction <> "-1" Then
		_GUICtrlListView_UnRegisterSortCallBack($Listview)
;~ 		_Sortiere_Listview($Listview, $Colum)
	EndIf
	_GUICtrlListView_RegisterSortCallBack($Listview)
	_GUICtrlListView_SortItems($Listview, $Colum)
EndFunc   ;==>_Sortiere_Listview

Func _ControlEditor_zusammenklappen()
	If $Control_Editor_ist_zusammengeklappt = 0 Then
		$Control_Editor_ist_zusammengeklappt = 1
		GUICtrlSetData($Control_Editor_collapse_label, "+")
		_WinAPI_SetWindowPos($Formstudio_controleditor_GUI, $HWND_TOP, 1, 1, $breite_des_Controleditors, $Hoehe_Control_Editor_zusammengeklappt, $SWP_NOMOVE)
	Else
		$Control_Editor_ist_zusammengeklappt = 0
		GUICtrlSetData($Control_Editor_collapse_label, "-")
		_WinAPI_SetWindowPos($Formstudio_controleditor_GUI, $HWND_TOP, 1, 1, $breite_des_Controleditors, $hoehe_des_Controleditors, $SWP_NOMOVE)
	EndIf
EndFunc   ;==>_ControlEditor_zusammenklappen


Func _Input_Setze_Hilfetext($control = "", $String = "")
	If _ist_windows_vista_oder_hoeher() Then
		GUICtrlSendMsg($control, 0x1501, False, $String)
	Else
		GUICtrlSendMsg($control, 0x1501, False, " " & $String)
	EndIf
EndFunc   ;==>_Input_Setze_Hilfetext



Func _Style_in_fertiges_Format_ausgeben($Style = "", $for_testing_only = 0)
	$Modus = "variables"
	If _IniReadEx($Cache_Datei_Handle, "gui", "const_modus", "default") = "default" Then
		$Modus = $FormStudio_Global_const_modus
	Else
		$Modus = _IniReadEx($Cache_Datei_Handle, "gui", "const_modus", "variables")
	EndIf

	If $for_testing_only = 1 Then
		;Midicild aus ExStyle Filtern, falls Getestet wird
		If StringInStr($Style, "$WS_EX_MDICHILD+") Then $Style = StringReplace($Style, "$WS_EX_MDICHILD+", "")
		If StringInStr($Style, "$WS_EX_MDICHILD +") Then $Style = StringReplace($Style, "$WS_EX_MDICHILD +", "")
		If StringInStr($Style, "+$WS_EX_MDICHILD") Then $Style = StringReplace($Style, "+$WS_EX_MDICHILD", "")
		If StringInStr($Style, "+ $WS_EX_MDICHILD") Then $Style = StringReplace($Style, "+ $WS_EX_MDICHILD", "")
		If StringInStr($Style, "$WS_EX_MDICHILD") Then $Style = StringReplace($Style, "$WS_EX_MDICHILD", "")
		If $Style = "" Then Return "-1"
	EndIf


	If $Modus = "variables" Then
		$Style = $Style
		If StringInStr($Style, "+") Then
			$Style = StringReplace($Style, "+", ",")
			$Style = "BitOr(" & $Style & ")"
		EndIf

	Else
		$Style = Execute($Style)
	EndIf

	Return $Style
EndFunc   ;==>_Style_in_fertiges_Format_ausgeben

Func _UNICODE2ANSI($sString = "")
   If _System_benoetigt_double_byte_character_Support() Then Return $sString
;~    if $autoit_editor_encoding <> "2" then return $sString
	; Convert UTF8 to ANSI to insert into DB

	; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
	; ProgAndy
	; Make ANSI-string representation out of UTF-8

	Local Const $SF_ANSI = 1
	Local Const $SF_UTF8 = 4
	Return BinaryToString(StringToBinary($sString, $SF_UTF8), $SF_ANSI)
EndFunc   ;==>_UNICODE2ANSI

Func _ANSI2UNICODE($sString = "")
   If _System_benoetigt_double_byte_character_Support() Then Return $sString
;~    if $autoit_editor_encoding <> "2" then return $sString
	; Extract ANSI and convert to UTF8 to display

	; http://www.autoitscript.com/forum/index.php?showtopic=85496&view=findpost&p=614497
	; ProgAndy
	; convert ANSI-UTF8 representation to ANSI/Unicode

	Local Const $SF_ANSI = 1
	Local Const $SF_UTF8 = 4
	Return BinaryToString(StringToBinary($sString, $SF_ANSI), $SF_UTF8)
EndFunc   ;==>_ANSI2UNICODE



Func _Leere_INI_Datei_erstellen($Pfad = "")
	$handle = FileOpen($Pfad, 10)
	FileClose($handle)
EndFunc   ;==>_Leere_INI_Datei_erstellen

Func _ProcessGetLocation($iPID)
	Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
	If $aProc[0] = 0 Then Return SetError(1, 0, '')
	Local $vStruct = DllStructCreate('int[1024]')
	DllCall('psapi.dll', 'int', 'EnumProcessModules', 'hwnd', $aProc[0], 'ptr', DllStructGetPtr($vStruct), 'int', DllStructGetSize($vStruct), 'int_ptr', 0)
	Local $aReturn = DllCall('psapi.dll', 'int', 'GetModuleFileNameEx', 'hwnd', $aProc[0], 'int', DllStructGetData($vStruct, 1), 'str', '', 'int', 2048)
	If StringLen($aReturn[3]) = 0 Then Return SetError(2, 0, '')
	Return $aReturn[3]
EndFunc   ;==>_ProcessGetLocation

Func _ISN_Pfeil_ID_aus_smallicons_DLL()
	If $ISN_Dark_Mode = "true" Then
		Return 1922
	Else
		Return 1910
	EndIf
EndFunc   ;==>_ISN_Pfeil_ID_aus_smallicons_DLL

Func _WinAPI_ShellExtractIcons($icon, $Index, $width, $height)
	Local $Ret = DllCall('shell32.dll', 'int', 'SHExtractIconsW', 'wstr', $icon, 'int', $Index, 'int', $width, 'int', $height, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)
	If @error Or $Ret[0] = 0 Or $Ret[5] = Ptr(0) Then Return SetError(1, 0, 0)
	Return $Ret[5]
EndFunc   ;==>_WinAPI_ShellExtractIcons

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


Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
    switch $hWnd

	case $ExtracodeGUI
	   _Code_GUI_Resize()

	case $Form_bearbeitenGUI
	   _Form_bearbeitenGUI_Resize()

	case $menueditorGUI
	   _Menu_Editor_Resize()

	EndSwitch
   Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE



Func _System_benoetigt_double_byte_character_Support()
;True = Chinesische Systeme

switch _WinAPI_GetSystemDefaultLCID()

case 2052 ;zh-cn
   return true

case 3076 ;zh-hk
   return true

case 5124 ;zh-mo
   return true

case 4100 ;zh-sg
   return true

case 1028 ;zh-tw
   return true

case 1041 ;ja
   return true

case 1042 ;ko
   return true

EndSwitch

return false ;Nicht benötigt (zb. für deutsche oder englische systeme)
EndFunc


Func WM_GETMINMAXINFO($hWnd, $msg, $wParam, $lParam)

	$tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)

	Switch $hWnd

		Case $GUI_Editor
			DllStructSetData($tagMaxinfo, 7, 0)
			DllStructSetData($tagMaxinfo, 8, 0)

		Case $Studiofenster
			DllStructSetData($tagMaxinfo, 7, 0)
			DllStructSetData($tagMaxinfo, 8, 0)

		Case $StudioFenster_inside
			DllStructSetData($tagMaxinfo, 7, 0)
			DllStructSetData($tagMaxinfo, 8, 0)

		Case $Setup_GUI
			DllStructSetData($tagMaxinfo, 7, $Setup_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $Setup_GUI_height)

		Case $control_reihenfolge_GUI
			DllStructSetData($tagMaxinfo, 7, $control_reihenfolge_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $control_reihenfolge_GUI_height)

		Case $Form_bearbeitenGUI
			DllStructSetData($tagMaxinfo, 7, $Form_bearbeitenGUI_width)
			DllStructSetData($tagMaxinfo, 8, $Form_bearbeitenGUI_height)

		Case $menueditorGUI
			DllStructSetData($tagMaxinfo, 7, $menueditorGUI_width)
			DllStructSetData($tagMaxinfo, 8, $menueditorGUI_height)


		Case Else
			DllStructSetData($tagMaxinfo, 7, $GUIMINWID) ; min X
			DllStructSetData($tagMaxinfo, 8, $GUIMINHT) ; min Y

	EndSwitch


	Return 0
 EndFunc   ;==>WM_GETMINMAXINFO

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

 Func GUIRadioSetColor(ByRef $CtrlID,$iColor,$iBkColor="0xF1EDED")
    	$CtrlHWnd = $CtrlID
    	If Not IsHWnd($CtrlHWnd) Then $CtrlHWnd = GUICtrlGetHandle($CtrlID)
    	$aParent = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $CtrlHWnd)
    	$aCPos = ControlGetPos($aParent[0],"",$CtrlID)
    	$sOldT = GUICtrlRead($CtrlID,1)
    	GUICtrlDelete($CtrlID)
    	DllCall('uxtheme.dll', 'none', 'SetThemeAppProperties', 'int', 0)
    	$CtrlID = GUICtrlCreateRadio($sOldT,$aCPos[0],$aCPos[1],$aCPos[2],$aCPos[3])
		_Control_set_DPI_Scaling($CtrlID)
    	GUICtrlSetColor(-1,$iColor)
    	GUICtrlSetBkColor(-1,$iBkColor)
    	DllCall('uxtheme.dll', 'none', 'SetThemeAppProperties', 'int', 7)

EndFunc