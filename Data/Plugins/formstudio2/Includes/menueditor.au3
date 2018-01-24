;Der Menü Editor


Func _Menu_Editor_Childs_loeschen($item)
	$item = _GUICtrlTreeView_GetFirstChild($menueditor_treeview, $item)
	If $item = 0 Then Return 0
	While 1
		_Menu_Editor_Childs_loeschen($item)
		$tInfo = DllStructCreate($tagLVFINDINFO)
		DllStructSetData($tInfo, "Flags", $LVFI_STRING)
		$zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo, $item)
		If $zeile <> -1 Then
			_GUICtrlListView_DeleteItem(GUICtrlGetHandle($menueditor_listview), $zeile)
		EndIf
		$item = _GUICtrlTreeView_GetNextChild($menueditor_treeview, $item)
		If $item = 0 Then ExitLoop
	WEnd
EndFunc   ;==>_Menu_Editor_Childs_loeschen


Func _Menu_Editor_element_loeschen()
	If _GUICtrlTreeView_GetSelection($menueditor_treeview) = 0 Then Return
	$tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_STRING)
	$zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo, _GUICtrlTreeView_GetSelection($menueditor_treeview))
	If $zeile = -1 Then Return
	_GUICtrlListView_DeleteItem(GUICtrlGetHandle($menueditor_listview), $zeile)
	_Menu_Editor_Childs_loeschen(_GUICtrlTreeView_GetSelection($menueditor_treeview))
	_GUICtrlTreeView_BeginUpdate($menueditor_treeview)
	_GUICtrlTreeView_Delete($menueditor_treeview, _GUICtrlTreeView_GetSelection($menueditor_treeview))
	_GUICtrlTreeView_EndUpdate($menueditor_treeview)
	_Menu_Editor_Eintrag_waehlen()
	_Menu_Editor_Aktualisiere_Vorschau()
EndFunc   ;==>_Menu_Editor_element_loeschen

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menu_Editor_Aktualisiere_Vorschau
; Description ...: Baut anhand des Treeview eine Vorschau-Menüleiste
; Syntax.........: _Menu_Editor_Aktualisiere_Vorschau()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menu_Editor_Aktualisiere_Vorschau()
	_GUICtrlMenu_DestroyMenu($MenuEditor_Vorschaumenue)
	$MenuEditor_Vorschaumenue = _GUICtrlMenu_CreateMenu()
	$item = _GUICtrlTreeView_GetFirstItem($menueditor_treeview)
	If $item = 0 Then
		_Menueditor_Clear()
		Return
	EndIf
	While 1
		_GUICtrlMenu_AddMenuItem($MenuEditor_Vorschaumenue, _GUICtrlTreeView_GetText($menueditor_treeview, $item), 0, _Menu_Editor_Vorschau_nach_Childs_Durchsuchen($item))
		$item = _GUICtrlTreeView_GetNextSibling($menueditor_treeview, $item)
		If $item = 0 Then ExitLoop
	WEnd
	If _GUICtrlTreeView_GetCount($menueditor_treeview) = 0 Then
		_Menueditor_Clear()
	Else
		_GUICtrlMenu_SetMenu($menueditor_vorschauGUI, $MenuEditor_Vorschaumenue)
	EndIf
EndFunc   ;==>_Menu_Editor_Aktualisiere_Vorschau

Func _Menu_Editor_Vorschau_nach_Childs_Durchsuchen($item)
	$item = _GUICtrlTreeView_GetFirstChild($menueditor_treeview, $item)
	If $item = 0 Then Return 0
	$Menu = _GUICtrlMenu_CreateMenu()
	While 1
		$tInfo = DllStructCreate($tagLVFINDINFO)
		DllStructSetData($tInfo, "Flags", $LVFI_STRING)
		$zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo, $item)
		If $zeile <> -1 Then
			$Text = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 3)
			$radioitem = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 8)
			$checked = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 9)
			$iconmode = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 4)
			$iconpath = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 5)
			$iconid = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 7)
			If $iconid = "" Then $iconid = 0



			$handle = _GUICtrlMenu_AddMenuItem($Menu, $Text, 0, _Menu_Editor_Vorschau_nach_Childs_Durchsuchen($item))
			If $radioitem = "1" Then _GUICtrlMenu_CheckRadioItem($Menu, $handle, $handle, $handle, True)
			If $checked = "1" Then _GUICtrlMenu_SetItemChecked($Menu, $handle, True, True)
			If $iconmode <> "0" Then
				If $iconmode = "1" Then $iconid = 0
				_GUICtrlMenu_SetItemBmp($Menu, $handle, _CreateBitmapFromIcon(_WinAPI_GetSysColor(4), $iconpath, $iconid, 16, 16), False)
			EndIf

		EndIf
		$item = _GUICtrlTreeView_GetNextSibling($menueditor_treeview, $item)
		If $item = 0 Then ExitLoop
	WEnd
	Return $Menu
EndFunc   ;==>_Menu_Editor_Vorschau_nach_Childs_Durchsuchen


Func _Handle_Zeichenkorrektur($string = "")
	$string = StringReplace($string, " ", "_")
	$string = StringReplace($string, "?", "")
	$string = StringReplace($string, "!", "")
	$string = StringReplace($string, "/", "")
	$string = StringReplace($string, "\", "")
	$string = StringReplace($string, "'", "")
	$string = StringReplace($string, '"', "")
	$string = StringReplace($string, "|", "")
	$string = StringReplace($string, "-", "")
	$string = StringReplace($string, ".", "")
	$string = StringReplace($string, ":", "")
	$string = StringReplace($string, ";", "")
	$string = StringReplace($string, ",", "")
	$string = StringReplace($string, "$$", "")
	$string = StringReplace($string, "$$$", "")
	$string = StringReplace($string, "$$$$", "")
	$string = StringReplace($string, "<", "")
	$string = StringReplace($string, ">", "")
	$string = StringReplace($string, "(", "")
	$string = StringReplace($string, ")", "")
	$string = StringReplace($string, "&", "")
	$string = StringReplace($string, "%", "")
	$string = StringReplace($string, "§", "")
	$string = StringReplace($string, "=", "")
	$string = StringReplace($string, "^", "")
	$string = StringReplace($string, "°", "")
	Return $string
EndFunc   ;==>_Handle_Zeichenkorrektur

Func _Menu_Editor_uebernehmen_event()
_Menu_Editor_uebernehmen()
EndFunc

func _MenuEditor_Erstelle_Zufallshandle()
$String = "MenuItem"&random(1,2000,1)
return $String
EndFunc


; #FUNCTION# ;===============================================================================
;
; Name...........: _Menu_Editor_uebernehmen
; Description ...: Übernimmt änderungen eines Items in die unsichtbare Listview
; Syntax.........: _Menu_Editor_uebernehmen()
; Parameters ....: $nicht_neu_einlesen	-Wenn 1 wird das Item nach dem übernehmen nicht neu eingelesen
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Menu_Editor_uebernehmen($nicht_neu_einlesen=0)
	If _GUICtrlTreeView_GetSelection($menueditor_treeview) = 0 Then Return
	$tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_STRING)
	$zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo, _GUICtrlTreeView_GetSelection($menueditor_treeview))
	If $zeile = -1 Then Return
	$handle = _Handle_mit_Dollar_zurueckgeben(_Handle_Zeichenkorrektur(GUICtrlRead($menueditor_handle_input)))
	if $handle = "" then $handle = _MenuEditor_Erstelle_Zufallshandle()
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, $handle, 1)

	$Textmode = "text"
	If GUICtrlRead($menueditor_text_radio1) = $GUI_CHECKED Then
		$Textmode = "text"
	Else
		$Textmode = "func"
	EndIf
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, $Textmode, 2)

	$iconmode = 0
	If GUICtrlRead($menueditor_Icon_Radio2) = $GUI_CHECKED Then $iconmode = 1
	If GUICtrlRead($menueditor_Icon_Radio3) = $GUI_CHECKED Then $iconmode = 2
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, $iconmode, 4)


	$radioitem = "0"
	If GUICtrlRead($menueditor_Radio_Checkbox) = $GUI_CHECKED Then
		$radioitem = "1"
	Else
		$radioitem = "0"
	EndIf
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, $radioitem, 8)

	$checked = "0"
	If GUICtrlRead($menueditor_Checked_Checkbox) = $GUI_CHECKED Then
		$checked = "1"
	Else
		$checked = "0"
	EndIf
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, $checked, 9)


	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, GUICtrlRead($menueditor_Icondatei_input), 5)
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _Handle_mit_Dollar_zurueckgeben(GUICtrlRead($menueditor_Icon_variable_input)), 6)
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, GUICtrlRead($menueditor_IconID_input), 7)
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, GUICtrlRead($menueditor_func_input), 10)

	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, GUICtrlRead($menueditor_text_input), 3)
	_GUICtrlTreeView_SetText($menueditor_treeview, _GUICtrlTreeView_GetSelection($menueditor_treeview), GUICtrlRead($menueditor_text_input))
	_Menu_Editor_Aktualisiere_Vorschau()
	if $nicht_neu_einlesen = 0 then _Menu_Editor_Eintrag_waehlen()
EndFunc   ;==>_Menu_Editor_uebernehmen

Func _Menu_editor_Toggle_Textmode()
	If GUICtrlRead($menueditor_text_radio1) = $GUI_CHECKED Then
		GUICtrlSetBkColor($menueditor_text_input, $ISN_Hintergrundfarbe)
	Else
		GUICtrlSetBkColor($menueditor_text_input, $Farbe_Func_Textmode)
	EndIf
EndFunc   ;==>_Menu_editor_Toggle_Textmode

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menu_Editor_Eintrag_waehlen
; Description ...: Wird ausgeführt sobald ein Item im Treeview ausgewählt wird
; Syntax.........: _Menu_Editor_Eintrag_waehlen()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menu_Editor_Eintrag_waehlen()

	If _GUICtrlTreeView_GetSelection($menueditor_treeview) = 0 Then
		_Menueditor_Set_State(-1)
		Return
	EndIf
	_Menueditor_Set_State()
	$tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_STRING)
	$zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo, _GUICtrlTreeView_GetSelection($menueditor_treeview))
	If $zeile = -1 Then Return
	_GUICtrlListView_SetItemSelected($menueditor_listview, $zeile, True, True)
	If _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 2) = "text" Then
		GUICtrlSetState($menueditor_text_radio1, $GUI_CHECKED)
		GUICtrlSetState($menueditor_text_radio2, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($menueditor_text_radio1, $GUI_UNCHECKED)
		GUICtrlSetState($menueditor_text_radio2, $GUI_CHECKED)
	EndIf


	$iconmode = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 4)
	If $iconmode = "0" Then
		GUICtrlSetState($menueditor_Icon_Radio1, $GUI_CHECKED)
		GUICtrlSetState($menueditor_Icon_Radio2, $GUI_UNCHECKED)
		GUICtrlSetState($menueditor_Icon_Radio3, $GUI_UNCHECKED)
	EndIf
	If $iconmode = "1" Then
		GUICtrlSetState($menueditor_Icon_Radio2, $GUI_CHECKED)
		GUICtrlSetState($menueditor_Icon_Radio1, $GUI_UNCHECKED)
		GUICtrlSetState($menueditor_Icon_Radio3, $GUI_UNCHECKED)
	EndIf
	If $iconmode = "2" Then
		GUICtrlSetState($menueditor_Icon_Radio3, $GUI_CHECKED)
		GUICtrlSetState($menueditor_Icon_Radio1, $GUI_UNCHECKED)
		GUICtrlSetState($menueditor_Icon_Radio2, $GUI_UNCHECKED)
	EndIf

	$radioitem = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 8)
	If $radioitem = "0" Then
		GUICtrlSetState($menueditor_Radio_Checkbox, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($menueditor_Radio_Checkbox, $GUI_CHECKED)
	EndIf

	$checked = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 9)
	If $checked = "0" Then
		GUICtrlSetState($menueditor_Checked_Checkbox, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($menueditor_Checked_Checkbox, $GUI_CHECKED)
	EndIf

	GUICtrlSetData($menueditor_Icondatei_input, _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 5))
	GUICtrlSetData($menueditor_Icon_variable_input, _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 6))
	GUICtrlSetData($menueditor_IconID_input, _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 7))
	GUICtrlSetData($menueditor_handle_input, _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 1))
	GUICtrlSetData($menueditor_text_input, _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 3))
	GUICtrlSetData($menueditor_func_input, _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 10))
	_Menu_editor_Toggle_Textmode()
	_Menueditor_Set_State()
EndFunc   ;==>_Menu_Editor_Eintrag_waehlen


Func _Menu_Editor_neuer_listvieweintrag($handle)
	$row = _GUICtrlListView_AddItem($menueditor_listview, $handle)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "", 1)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "text", 2)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "Mein Text", 3)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "0", 4)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "", 5)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "", 6)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "", 7)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "0", 8)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "0", 9)
	_GUICtrlListView_AddSubItem($menueditor_listview, $row, "", 10)
	Return $row
EndFunc   ;==>_Menu_Editor_neuer_listvieweintrag


Func _Menu_Editor_Neuen_Menuepunkt_hinzufuegen()
	_Menu_Editor_uebernehmen(0)
	_GUICtrlTreeView_BeginUpdate($menueditor_treeview)
	$handle = GUICtrlCreateTreeViewItem("Mein Text", $menueditor_treeview)
	_Menu_Editor_neuer_listvieweintrag(GUICtrlGetHandle($handle))
	_GUICtrlTreeView_SelectItem($menueditor_treeview, $handle, $TVGN_CARET)
	_Menu_Editor_Aktualisiere_Vorschau()
	_GUICtrlTreeView_EndUpdate($menueditor_treeview)
	_Menu_Editor_Eintrag_waehlen()
EndFunc   ;==>_Menu_Editor_Neuen_Menuepunkt_hinzufuegen

Func _Menu_Editor_Neuen_Untermenuepunkt_hinzufuegen()
	_Menu_Editor_uebernehmen(0)
	If _GUICtrlTreeView_GetSelection($menueditor_treeview) = 0 Then Return
	_GUICtrlTreeView_BeginUpdate($menueditor_treeview)
	$handle = _GUICtrlTreeView_AddChild($menueditor_treeview, _GUICtrlTreeView_GetSelection($menueditor_treeview), "Mein Text")
	_Menu_Editor_neuer_listvieweintrag($handle)
	_GUICtrlTreeView_SelectItem($menueditor_treeview, $handle, $TVGN_CARET)
	_GUICtrlTreeView_EndUpdate($menueditor_treeview)
	_Menu_Editor_Aktualisiere_Vorschau()
	_Menu_Editor_Eintrag_waehlen()
EndFunc   ;==>_Menu_Editor_Neuen_Untermenuepunkt_hinzufuegen





Func TV_ItemMove($dir);;; Moves Treeview  Items
	$item = _GUICtrlTreeView_GetSelection($menueditor_treeview)
	If $item = 0 Then
		Return;;==> return from function
	EndIf

	$itemText = _GUICtrlTreeView_GetText($menueditor_treeview, $item)
	$itemPA = _GUICtrlTreeView_GetParentHandle($menueditor_treeview, $item)



	;; check and prepare to move up
	If $dir = "up" Then;;new UdF - item will be inserted after, so get prev of prev
		$itemToPrev = _GUICtrlTreeView_GetPrevSibling($menueditor_treeview, $item)
		$itemTo = _GUICtrlTreeView_GetPrevSibling($menueditor_treeview, $itemToPrev)
		If $itemPA = 0 Then;; get the first sibiling item
			$itemFirstSib = _GUICtrlTreeView_GetFirstItem($menueditor_treeview)
		Else
			$itemFirstSib = _GUICtrlTreeView_GetFirstChild($menueditor_treeview, $itemPA)
		EndIf
		If $itemFirstSib = $item Then;; first item can not moved up
			Return;;==> return from function
		EndIf
	EndIf

	;; check and prepare to move down
	If $dir = "dn" Then; item will be inserted after, so get next
		$itemTo = _GUICtrlTreeView_GetNextSibling($menueditor_treeview, $item)
		$itemToNext = _GUICtrlTreeView_GetNextSibling($menueditor_treeview, $item)
		$itemLastSib = _GUICtrlTreeView_GetLastChild($menueditor_treeview, $itemPA)
		If $itemLastSib = $item Or $itemTo = 0 Then
			Return;;==> return from function
		EndIf
	EndIf

	;; check and prepare to move left
	If $dir = "left" Then
		$itemLevel = _GUICtrlTreeView_Level($menueditor_treeview, $item)
		$itemLevelPa = $itemLevel - 1
		If $itemLevel = 0 Then
			Return;;==> return from function
		EndIf
		$itemTo = $itemPA
	EndIf

	;; check and prepare to move right
	If $dir = "right" Then
		$itemLevel = _GUICtrlTreeView_Level($menueditor_treeview, $item)
		If $itemLevel = 0 Then
			$itemFirstSib = _GUICtrlTreeView_GetFirstItem($menueditor_treeview)
		Else
			$itemFirstSib = _GUICtrlTreeView_GetFirstChild($menueditor_treeview, $itemPA)
		EndIf
		If $item = $itemFirstSib Then
			Return;;==> return from function
		EndIf
		$itemTo = _GUICtrlTreeView_GetPrevSibling($menueditor_treeview, $item)
	EndIf

	;;check for children and get it
	$itemIsParent = _GUICtrlTreeView_GetChildCount($menueditor_treeview, $item);0 = no childs
	If $itemIsParent > 0 Then
		$itemLevel = _GUICtrlTreeView_Level($menueditor_treeview, $item)
		$Childs = GetTree($item, $itemLevel, $itemText)
	EndIf

	;; start to move
	If $dir = "dn" And $itemToNext = $itemLastSib Then
		$itemInsert = _GUICtrlTreeView_Add($menueditor_treeview, $item, $itemText)
	ElseIf $dir = "up" And $itemToPrev = $itemFirstSib Then
		$itemInsert = _GUICtrlTreeView_AddFirst($menueditor_treeview, $itemToPrev, $itemText)
	ElseIf $dir = "right" Then
		$itemInsert = _GUICtrlTreeView_AddChild($menueditor_treeview, $itemTo, $itemText)
	ElseIf $dir = "left" And $itemLevelPa > 0 Then
		$itemPaPa = _GUICtrlTreeView_GetParentHandle($menueditor_treeview, $itemPA)
		$itemInsert = _GUICtrlTreeView_InsertItem($menueditor_treeview, $itemText, $itemPaPa, $itemPA)
	Else
		If $dir = "left" Then $itemPA = 0
		$itemInsert = _GUICtrlTreeView_InsertItem($menueditor_treeview, $itemText, $itemPA, $itemTo)
	EndIf
	_Menu_Editor_ID_Aktualisieren($item, $itemInsert)
	_GUICtrlTreeView_Delete($menueditor_treeview, $item)

	;; add Childs from selected Item to Inserted Item
	If $itemIsParent > 0 Then
		Dim $hNode[50]
		$aChilds = StringSplit($Childs, ";")
		For $i = 1 To $aChilds[0] - 1
			$level = $aChilds[$i]
			$itemText = $aChilds[$i + 1]
			If $level = $itemLevel Then
				$hNode[$level] = $itemInsert
			Else
				$between_str = _StringBetween($itemText, "[", "]")
				If IsArray($between_str) Then
					$hNode[$level] = _GUICtrlTreeView_AddChild($menueditor_treeview, $hNode[$level - 1], $between_str[0])
					_Menu_Editor_ID_Aktualisieren($between_str[1], $hNode[$level])
				EndIf
			EndIf
			$i += 1
		Next
		$Childs = ""
	EndIf
	_GUICtrlTreeView_Expand($menueditor_treeview, $itemInsert)
	_GUICtrlTreeView_SelectItem($menueditor_treeview, $itemInsert)

	_Menu_Editor_Aktualisiere_Vorschau()
EndFunc   ;==>TV_ItemMove



Func _Menu_Editor_ID_Aktualisieren($alt = "", $neu = "")
	If $alt = "" Then Return
	If $neu = "" Then Return
	$tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_STRING)
;~ $zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo,$alt)
	$zeile = _GUICtrlListView_FindInText($menueditor_listview, $alt)
	If $zeile = -1 Then Return
	_GUICtrlListView_SetItemText($menueditor_listview, $zeile, $neu, 0)
EndFunc   ;==>_Menu_Editor_ID_Aktualisieren


Func GetTree($item, $itemLevel, $itemText);; Get the Tree of Children
	$itemLevelPa = $itemLevel
	Do
		$Childs &= $itemLevel & ";[" & $itemText & "][" & $item & "];"; &@lf
		$item = _GUICtrlTreeView_GetNext($menueditor_treeview, $item)
		$itemLevel = _GUICtrlTreeView_Level($menueditor_treeview, $item)
		$itemText = _GUICtrlTreeView_GetText($menueditor_treeview, $item)
	Until $itemLevel <= $itemLevelPa; or $itemText = 0
	;MsgBox(0,"",$Childs)
	Return $Childs
EndFunc   ;==>GetTree

Func _Menu_Editor_Treeview_Zeige_kontextmenue()
	_GUICtrlMenu_TrackPopupMenu($menueditor_treeviewmenu_Handle, $menueditorGUI)
EndFunc   ;==>_Menu_Editor_Treeview_Zeige_kontextmenue

Func _Menu_Editor_Treeview_nach_oben_verschieben()
	TV_ItemMove("up")
EndFunc   ;==>_Menu_Editor_Treeview_nach_oben_verschieben

Func _Menu_Editor_Treeview_nach_unten_verschieben()
	TV_ItemMove("dn")
EndFunc   ;==>_Menu_Editor_Treeview_nach_unten_verschieben

Func _Menu_Editor_Treeview_nach_links_verschieben()
	TV_ItemMove("left")
EndFunc   ;==>_Menu_Editor_Treeview_nach_links_verschieben

Func _Menu_Editor_Treeview_nach_rechts_verschieben()
	TV_ItemMove("right")
EndFunc   ;==>_Menu_Editor_Treeview_nach_rechts_verschieben

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menu_Editor_Save_Treeview_to_INI_Childs_Durchsuchen
; Description ...: Speichert die Items in die temp. INI Datei
; Syntax.........: _Menu_Editor_Save_Treeview_to_INI_Childs_Durchsuchen()
; Parameters ....: $item			- Root Item
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Diese Funktion kann sich selbst aufrufen um weitere Childs zu speichern
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menu_Editor_Save_Treeview_to_INI_Childs_Durchsuchen($item)
	$Root_Item = $item
	$item = _GUICtrlTreeView_GetFirstChild($menueditor_treeview, $item)
	Local $Parents_String = "-1"
	_IniWriteEx($MenuEditor_tempfile_handle, $Root_Item, "childs", $Parents_String)
	If $item = 0 Then Return 0
	$Parents_String = "" ;reset
	While 1
		$tInfo = DllStructCreate($tagLVFINDINFO)
		DllStructSetData($tInfo, "Flags", $LVFI_STRING)
		$zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo, $item)
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "handle", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 1))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "textmode", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 2))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "text", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 3))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "iconmode", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 4))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "iconpath", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 5))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "iconvarible", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 6))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "iconid", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 7))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "radio", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 8))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "checked", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 9))
		_IniWriteEx($MenuEditor_tempfile_handle, $item, "func", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 10))
		$Parents_String = $Parents_String & $item & "|"
		_Menu_Editor_Save_Treeview_to_INI_Childs_Durchsuchen($item)
		$item = _GUICtrlTreeView_GetNextSibling($menueditor_treeview, $item)
		If $item = 0 Then ExitLoop
	WEnd
	If StringTrimLeft($Parents_String, StringLen($Parents_String) - 1) = "|" Then $Parents_String = StringTrimRight($Parents_String, 1)
	_IniWriteEx($MenuEditor_tempfile_handle, $Root_Item, "childs", $Parents_String)
	_IniCloseFileEx($MenuEditor_tempfile_handle)
	$MenuEditor_tempfile_handle = _IniOpenFile($MenuEditor_tempfile)
	Return $Parents_String
EndFunc   ;==>_Menu_Editor_Save_Treeview_to_INI_Childs_Durchsuchen




; #FUNCTION# ;===============================================================================
;
; Name...........: _Menu_editor_Save_Treeview_to_INI
; Description ...: Speichert das Menü in eine temp. .ini und erzeugt daraus den INIString der an den Controleditor übergeben wird
; Syntax.........: _Menu_editor_Save_Treeview_to_INI()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird aufgerufen wenn der Menüeditor gezeigt wird
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menu_editor_Save_Treeview_to_INI()
	FileDelete($MenuEditor_tempfile)
	Local $zeile = -1
	$item = _GUICtrlTreeView_GetFirstItem($menueditor_treeview)
	Local $Order_String = ""
	While 1
		$tInfo = DllStructCreate($tagLVFINDINFO)
		DllStructSetData($tInfo, "Flags", $LVFI_STRING)
		$zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo, $item)
		If $zeile <> -1 Then
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "handle", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 1))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "textmode", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 2))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "text", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 3))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "iconmode", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 4))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "iconpath", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 5))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "iconvarible", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 6))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "iconid", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 7))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "radio", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 8))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "checked", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 9))
			_IniWriteEx($MenuEditor_tempfile_handle, $item, "func", _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 10))
			$Order_String = $Order_String & $item & "|"

			_Menu_Editor_Save_Treeview_to_INI_Childs_Durchsuchen($item)
		EndIf
		$item = _GUICtrlTreeView_GetNextSibling($menueditor_treeview, $item)
		If $item = 0 Then ExitLoop
	WEnd
	If StringTrimLeft($Order_String, StringLen($Order_String) - 1) = "|" Then $Order_String = StringTrimRight($Order_String, 1)
	_IniWriteEx($MenuEditor_tempfile_handle, "root", "order", $Order_String)
	_IniCloseFileEx($MenuEditor_tempfile_handle)
   $MenuEditor_tempfile_handle = _IniOpenFile($MenuEditor_tempfile)
	_FileReadToArray($MenuEditor_tempfile, $Array_Menu_temp)
	If IsArray($Array_Menu_temp) Then
		_ArrayDelete($Array_Menu_temp, 0)
		$Fertiger_String = _ArrayToString($Array_Menu_temp, "[MBREAK]")
		GUICtrlSetData($MiniEditor_Text, $Fertiger_String)
	EndIf
	If _GUICtrlTreeView_GetCount($menueditor_treeview) = 0 Then GUICtrlSetData($MiniEditor_Text, "")
	FileDelete($MenuEditor_tempfile)

EndFunc   ;==>_Menu_editor_Save_Treeview_to_INI


; #FUNCTION# ;===============================================================================
;
; Name...........: _Menu_editor_Lade_aus_INIString
; Description ...: Baut Treeview und Menüstruktur aus einem INIString auf
; Syntax.........: _Menu_editor_Lade_aus_INIString()
; Parameters ....: $string			- INIString
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird aufgerufen wenn der Menüeditor mit OK verlassen wird
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menu_editor_Lade_aus_INIString($string = "")
	$Datei = $MenuEditor_tempfile
	$INITEXT = ""
	_IniCloseFileEx($MenuEditor_tempfile_handle)
	FileDelete($Datei)
	if not FileExists($MenuEditor_tempfile) then _Leere_INI_Datei_erstellen($MenuEditor_tempfile)
	If $string = "" Then Return
	$INITEXT = StringReplace($string, "[MBREAK]", @CRLF)
	$file = FileOpen($Datei, 2) ;Erstelle Cache-INI aus String und arbeite damit
	If $file = -1 Then
		Return
	EndIf
	FileWrite($file, $INITEXT)
	FileClose($file)

   $MenuEditor_tempfile_handle = _IniOpenFile($MenuEditor_tempfile)

	$INI_SECTIONS_ARRAY = _IniReadSectionNamesEx($MenuEditor_tempfile_handle)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($menueditor_listview))
	_GUICtrlTreeView_DeleteAll($menueditor_treeview)
	_GUICtrlTreeView_BeginUpdate($menueditor_treeview)
	_GUICtrlListView_BeginUpdate($menueditor_listview)
	If Not IsArray($INI_SECTIONS_ARRAY) Then Return
	_ArrayDelete($INI_SECTIONS_ARRAY, 0)

	;Schritt 1: Erstelle Root Einträge
	$RootString = _IniReadEx($MenuEditor_tempfile_handle, "root", "order", "")
	If $RootString = "" Then Return
	If StringTrimLeft($RootString, StringLen($RootString) - 1) = "|" Then $RootString = StringTrimRight($RootString, 1)
	$RootSplit = StringSplit($RootString, "|", 2)
	If Not IsArray($RootSplit) Then Return
	For $y = 0 To UBound($RootSplit) - 1
		$handle = GUICtrlCreateTreeViewItem("Mein Text", $menueditor_treeview)
		$zeile = _Menu_Editor_neuer_listvieweintrag(GUICtrlGetHandle($handle)) ;Raw
		$Text = _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "text", "Mein Text")
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, $Text, 3)
		_GUICtrlTreeView_SetText($menueditor_treeview, $handle, $Text)

		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "handle", ""), 1)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "textmode", "text"), 2)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "iconmode", "0"), 4)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "iconpath", ""), 5)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "iconvarible", ""), 6)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "iconid", ""), 7)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "radio", "0"), 8)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "checked", "0"), 9)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "func", ""), 10)


		_Menu_editor_Lade_aus_INIString_Lade_Childs(GUICtrlGetHandle($handle), _IniReadEx($MenuEditor_tempfile_handle, $RootSplit[$y], "childs", "-1"))
	Next
	_Menu_Editor_Aktualisiere_Vorschau() ;Menü anhand des Treeviews aufbauen
	_GUICtrlTreeView_EndUpdate($menueditor_treeview)
	_GUICtrlListView_EndUpdate($menueditor_listview)

EndFunc   ;==>_Menu_editor_Lade_aus_INIString

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menu_editor_Lade_aus_INIString_Lade_Childs
; Description ...: LÃ¤dt Childs die im Childstring angegeben wurden zum angegebenen Rootitem
; Syntax.........: _Menu_editor_Lade_aus_INIString_Lade_Childs()
; Parameters ....: $rootitem			- An dieses Item werden die Childs gehängt
;                  $Childsstring		- Der Childstring
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Diese Funktion kann sich selbst aufrufen (für weitere Childs)
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menu_editor_Lade_aus_INIString_Lade_Childs($rootitem = "", $Childsstring = "")
	$Datei = $MenuEditor_tempfile
	If $rootitem = "" Then Return
	If $Childsstring = "-1" Then Return
	If $Childsstring = "" Then Return
	If $rootitem = "root" Then Return
	If StringTrimLeft($Childsstring, StringLen($Childsstring) - 1) = "|" Then $Childsstring = StringTrimRight($Childsstring, 1)
	$ChildsstringSplit = StringSplit($Childsstring, "|", 2)
	If Not IsArray($ChildsstringSplit) Then Return
	For $x = 0 To UBound($ChildsstringSplit) - 1
		$Text = _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "text", "")

		$handle = _GUICtrlTreeView_AddChild($menueditor_treeview, $rootitem, $Text)
		$zeile = _Menu_Editor_neuer_listvieweintrag($handle)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, $Text, 3)

		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "handle", ""), 1)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "textmode", "text"), 2)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "iconmode", "0"), 4)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "iconpath", ""), 5)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "iconvarible", ""), 6)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "iconid", ""), 7)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "radio", "0"), 8)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "checked", "0"), 9)
		_GUICtrlListView_SetItemText($menueditor_listview, $zeile, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "func", ""), 10)

		_Menu_editor_Lade_aus_INIString_Lade_Childs($handle, _IniReadEx($MenuEditor_tempfile_handle, $ChildsstringSplit[$x], "childs", "-1"))
	Next
EndFunc   ;==>_Menu_editor_Lade_aus_INIString_Lade_Childs

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menueditor_Clear
; Description ...: Löscht alle Einträge im Treeview und in der versteckten Listview
; Syntax.........: _Menueditor_Clear()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menueditor_Clear()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($menueditor_listview))
	_GUICtrlTreeView_DeleteAll($menueditor_treeview)
	_GUICtrlMenu_SetMenu($menueditor_vorschauGUI, 0)
	_GUICtrlMenu_SetMenu($GUI_Editor, 0)
EndFunc   ;==>_Menueditor_Clear

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menueditor_radioevent
; Description ...: Sperrt bzw. befreit einige Controls im Menüeditor wenn zb. im Treeview nichts gewählt ist
; Syntax.........: _Menueditor_radioevent()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird nur von den Radioboxen im Menüeditor verwendet als überleitung zur Funktion _Menueditor_Set_State
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menueditor_radioevent()
	_Menueditor_Set_State()
EndFunc   ;==>_Menueditor_radioevent

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menueditor_Set_State
; Description ...: Sperrt bzw. befreit einige Controls im Menüeditor wenn zb. im Treeview nichts gewählt ist
; Syntax.........: _Menueditor_Set_State()
; Parameters ....: $state			- Zeige Controls (Alles <> 1 verstecke Controls)
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Wird auch von den Radioboxen im Menüeditor verwendet wenn auf ein Radio geklickt wird (durch die Funktion _Menueditor_radioevent)
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menueditor_Set_State($state = 1) ;1 = enable controls | <> 1 disable all
	If $state = 1 Then
		GUICtrlSetState($menueditor_text_input, $GUI_ENABLE)

		GUICtrlSetState($menueditor_text_radio1, $GUI_ENABLE)
		GUICtrlSetState($menueditor_text_radio2, $GUI_ENABLE)
		GUICtrlSetState($menueditor_handle_input, $GUI_ENABLE)

		If GUICtrlRead($menueditor_Icon_Radio1) = $GUI_CHECKED Then
			GUICtrlSetState($menueditor_Icondatei_input, $GUI_DISABLE)
			GUICtrlSetState($menueditor_IconID_input, $GUI_DISABLE)
			GUICtrlSetState($menueditor_Icon_variable_input, $GUI_DISABLE)
			GUICtrlSetState($menueditor_Icondatei_button, $GUI_DISABLE)
		EndIf

		If GUICtrlRead($menueditor_Icon_Radio2) = $GUI_CHECKED Then
			GUICtrlSetState($menueditor_Icondatei_input, $GUI_ENABLE)
			GUICtrlSetState($menueditor_IconID_input, $GUI_DISABLE)
			GUICtrlSetState($menueditor_Icon_variable_input, $GUI_DISABLE)
			GUICtrlSetState($menueditor_Icondatei_button, $GUI_ENABLE)
		EndIf

		If GUICtrlRead($menueditor_Icon_Radio3) = $GUI_CHECKED Then
			GUICtrlSetState($menueditor_Icondatei_input, $GUI_ENABLE)
			GUICtrlSetState($menueditor_IconID_input, $GUI_ENABLE)
			GUICtrlSetState($menueditor_Icon_variable_input, $GUI_ENABLE)
			GUICtrlSetState($menueditor_Icondatei_button, $GUI_ENABLE)
		EndIf


		GUICtrlSetState($menueditor_Icon_Radio1, $GUI_ENABLE)
		GUICtrlSetState($menueditor_Icon_Radio2, $GUI_ENABLE)
		GUICtrlSetState($menueditor_Icon_Radio3, $GUI_ENABLE)
		GUICtrlSetState($menueditor_Radio_Checkbox, $GUI_ENABLE)
		GUICtrlSetState($menueditor_Checked_Checkbox, $GUI_ENABLE)
		GUICtrlSetState($menueditor_uebernehmen_button, $GUI_ENABLE)
		GUICtrlSetState($menueditor_fuer_alle_button, $GUI_ENABLE)
		GUICtrlSetState($menueditor_func_input, $GUI_ENABLE)
		GUICtrlSetState($menueditor_func_button, $GUI_ENABLE)
	Else
		GUICtrlSetData($menueditor_text_input, "")
		GUICtrlSetData($menueditor_Icondatei_input, "")
		GUICtrlSetData($menueditor_handle_input, "")
		GUICtrlSetData($menueditor_IconID_input, "")
		GUICtrlSetData($menueditor_func_input, "")
		GUICtrlSetData($menueditor_Icon_variable_input, "")
		GUICtrlSetState($menueditor_text_input, $GUI_DISABLE)
		GUICtrlSetState($menueditor_Icondatei_input, $GUI_DISABLE)
		GUICtrlSetState($menueditor_text_radio1, $GUI_DISABLE)
		GUICtrlSetState($menueditor_text_radio2, $GUI_DISABLE)
		GUICtrlSetState($menueditor_handle_input, $GUI_DISABLE)
		GUICtrlSetState($menueditor_IconID_input, $GUI_DISABLE)
		GUICtrlSetState($menueditor_Icon_variable_input, $GUI_DISABLE)
		GUICtrlSetState($menueditor_Icon_Radio1, $GUI_DISABLE)
		GUICtrlSetState($menueditor_Icon_Radio2, $GUI_DISABLE)
		GUICtrlSetState($menueditor_Icon_Radio3, $GUI_DISABLE)
		GUICtrlSetState($menueditor_Radio_Checkbox, $GUI_DISABLE)
		GUICtrlSetState($menueditor_Checked_Checkbox, $GUI_DISABLE)
		GUICtrlSetState($menueditor_uebernehmen_button, $GUI_DISABLE)
		GUICtrlSetState($menueditor_fuer_alle_button, $GUI_DISABLE)
		GUICtrlSetState($menueditor_Icondatei_button, $GUI_DISABLE)
		GUICtrlSetState($menueditor_func_input, $GUI_DISABLE)
		GUICtrlSetState($menueditor_func_button, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_Menueditor_Set_State

; #FUNCTION# ;===============================================================================
;
; Name...........: _Show_Menueditor
; Description ...: Zeigt den Menüeditor und lädt Menüleiste aus dem INIString der aus dem Controleditor geholt wird
; Syntax.........: _Show_Menueditor()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Show_Menueditor()
    if _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "locked", 0) = 1 then
		MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(216), -1, $Studiofenster)
		return ;ist gesperrt
	endif
	GUISetState(@SW_DISABLE, $MiniEditor)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	$IniString = GUICtrlRead($MiniEditor_Text)
	If $IniString <> "" Then
		_Menu_editor_Lade_aus_INIString($IniString)
	Else
		_Menueditor_Clear()
	EndIf
	_Menueditor_Set_State(-1)
	GUISetState(@SW_SHOW, $menueditorGUI)
	_Menu_Editor_Resize()
	;WinMove($menueditor_vorschauGUI,"",16*$DPI,504*$DPI,834*$DPI,108*$DPI)
	GUISetState(@SW_SHOW, $menueditor_vorschauGUI)
	WinActivate($menueditorGUI)
EndFunc   ;==>_Show_Menueditor

; #FUNCTION# ;===============================================================================
;
; Name...........: _Save_and_hide_menueditor
; Description ...: Versteckt den Menüeditor und erstellt den INI-String der im Control Editor unter Text/Data abgelegt wird
; Syntax.........: _Save_and_hide_menueditor()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Aufgerufen durch den "OK" Button im Menüeditor
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Save_and_hide_menueditor()
	_Menu_Editor_uebernehmen()
	_Hide_Menueditor()
	_Menu_editor_Save_Treeview_to_INI()
	If _GUICtrlTreeView_GetCount($menueditor_treeview) = 0 Then
		_Menueditor_Clear()
	Else
		_GUICtrlMenu_SetMenu($GUI_Editor, $MenuEditor_Vorschaumenue)
	EndIf
	_Mini_Editor_Einstellungen_Uebernehmen()
EndFunc   ;==>_Save_and_hide_menueditor

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menueditor_Datei_auswaehlen
; Description ...: Zeigt ein Dateiauswahlfenster an
; Syntax.........: _Menueditor_Datei_auswaehlen()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Aufgerufen durch den "..." Button bei Icon-Datei
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menueditor_Datei_auswaehlen()
	$var = FileOpenDialog(_ISNPlugin_Get_langstring(213), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Icon files (*.ico;*.dll)", 1 + 2 + 4, "", $menueditorGUI )
	FileChangeDir(@scriptdir)
	if $var = "" then return
	If @error Then return
	GUICtrlSetData($menueditor_Icondatei_input,$var)
EndFunc   ;==>_Menueditor_Datei_auswaehlen

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menueditor_uebernehmen_fuer
; Description ...: Öffnet ein Fenster indem gewählt werden kann welche Elemente für alle anderen übernommen werden sollen
; Syntax.........: _Menueditor_uebernehmen_fuer()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Aufgerufen durch den Button im Menüeditor
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menueditor_uebernehmen_fuer()
GUICtrlSetState($menueditor_fueralleGUI_Iconpfad_checkbox,$GUI_UNCHECKED)
GUICtrlSetState($menueditor_fueralleGUI_IconID_checkbox,$GUI_UNCHECKED)
GUICtrlSetState($menueditor_fueralleGUI_text_checkbox,$GUI_UNCHECKED)
GUICtrlSetState($menueditor_fueralleGUI_Eigenschaften_checkbox,$GUI_UNCHECKED)
GUISetState(@SW_SHOW,$menueditor_fueralleuebernehmen_GUI)
GUISetState(@SW_DISABLE, $menueditorGUI)

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menueditor_uebernehmen_fuer_verstecken
; Description ...: Versteckt das "Für alle übernehmen.." Fenster ohne Änderungen vorzunehmen
; Syntax.........: _Menueditor_uebernehmen_fuer_verstecken()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menueditor_uebernehmen_fuer_verstecken()
GUISetState(@SW_ENABLE, $menueditorGUI)
GUISetState(@SW_HIDE,$menueditor_fueralleuebernehmen_GUI)
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _Menueditor_uebernehmen_fuer_Speichern
; Description ...: Übernimmt die gewählten Einträge auf alle Anderen Elemente
; Syntax.........: _Menueditor_uebernehmen_fuer_Speichern()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Menueditor_uebernehmen_fuer_Speichern()
_Menu_Editor_uebernehmen()
$tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_STRING)
$zeile = _GUICtrlListView_FindItem($menueditor_listview, -1, $tInfo, _GUICtrlTreeView_GetSelection($menueditor_treeview))
$Textmode = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 2)
$Text = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 3)
$Iconmode = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 4)
$Iconpath = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 5)
$Iconvariable = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 6)
$IconID = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 7)
$Radio = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 8)
$Checked = _GUICtrlListView_GetItemText($menueditor_listview, $zeile, 9)

for $x = 0 to _GUICtrlListView_GetItemCount($menueditor_listview)
if guictrlread($menueditor_fueralleGUI_text_checkbox) = $GUI_CHECKED then
$Handle = _GUICtrlListView_GetItemText($menueditor_listview, $x, 0)
_GUICtrlListView_SetItemText($menueditor_listview, $x, $Textmode, 2)
_GUICtrlListView_SetItemText($menueditor_listview, $x, $Text, 3)
_GUICtrlTreeView_SetText($menueditor_treeview, $Handle, $Text)
endif

if guictrlread($menueditor_fueralleGUI_Iconpfad_checkbox) = $GUI_CHECKED then
_GUICtrlListView_SetItemText($menueditor_listview, $x, $Iconmode, 4)
_GUICtrlListView_SetItemText($menueditor_listview, $x, $Iconpath, 5)
_GUICtrlListView_SetItemText($menueditor_listview, $x, $Iconvariable, 6)
EndIf

if guictrlread($menueditor_fueralleGUI_IconID_checkbox) = $GUI_CHECKED then _GUICtrlListView_SetItemText($menueditor_listview, $x, $IconID, 7)

if guictrlread($menueditor_fueralleGUI_Eigenschaften_checkbox) = $GUI_CHECKED then
_GUICtrlListView_SetItemText($menueditor_listview, $x, $Radio, 8)
_GUICtrlListView_SetItemText($menueditor_listview, $x, $Checked, 9)
endif
next

_Menueditor_uebernehmen_fuer_verstecken()
_Menu_Editor_Aktualisiere_Vorschau()
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _Hide_Menueditor()
; Description ...: Versteckt den Menüeditor ohne den INIString im Controleditor zu verändern
; Syntax.........: _Hide_Menueditor()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Aufgerufen durch den Abbrechen Button im Menüeditor
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================
Func _Hide_Menueditor()
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_HIDE, $menueditorGUI)
	GUISetState(@SW_HIDE, $menueditor_vorschauGUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_Hide_Menueditor




func _HIDE__MenuEditor_IconUDF()
GUISetState(@SW_SHOW, $menueditorGUI)
GUISetState(@SW_HIDE, $ExtracodeGUI)
endfunc



func _MenuEditor_Show_IconUDF()
   winsettitle($ExtracodeGUI, "", _ISNPlugin_Get_langstring(200))
	GUICtrlSetData($ExtracodeGUI_Label, _ISNPlugin_Get_langstring(200))

	SendMessage($sci, $SCI_CLEARALL, 0, 0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessage($sci, $SCI_SETSAVEPOINT, 0, 0)
	SendMessage($sci, $SCI_CANCEL, 0, 0)
	SendMessage($sci, $SCI_SETUNDOCOLLECTION, 0, 0)
	If Not _FileReadToArray(@scriptdir&"\Data\UDF_menuicons.au3", $aRecords) Then
		return
	EndIf
	$data = _ArrayToString($aRecords, @crlf, 1)

	SendMessageString($sci, $SCI_APPENDTEXT, StringLen($data), $data)
	SendMessage($sci, $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessage($sci, $SCI_SETSAVEPOINT, 0, 0)
	SendMessage($sci, $SCI_GOTOPOS, 0, 0)

	guictrlsetstate($Showcodebt1, $GUI_SHOW)
	guictrlsetstate($Showcodebt2, $GUI_HIDE)
	guictrlsetstate($Showcodebt3, $GUI_HIDE)
	ControlHide ($ExtracodeGUI, "", $Code_Generieren_umschalttab )
	GUICtrlSetOnEvent($Showcodebt1,"_HIDE__MenuEditor_IconUDF")
	 GUISetOnEvent($GUI_EVENT_CLOSE,"_HIDE__MenuEditor_IconUDF",$ExtracodeGUI)


	$wipos = WinGetPos($Studiofenster, "")
	$mon = _GetMonitorFromPoint($wipos[0], $wipos[1])
	_CenterOnMonitor($ExtracodeGUI, "", $mon)



	GUISetState(@SW_HIDE, $menueditorGUI)
	GUISetState(@SW_SHOW, $ExtracodeGUI)
   Sci_SetSelection($Sci, 0, 0)
 endfunc


 Func _Menueditor_Func_auswaehlen()
	If $DEBUG = "true" Then Return ;Nicht im Debug ausführen!
	If $Control_Markiert = 0 Then Return
	GUISetState(@SW_DISABLE, $menueditorGUI)
	_ISNPlugin_Nachricht_senden("listfuncs")
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "listfuncsok", 90000000)
	GUISetState(@SW_ENABLE, $menueditorGUI)
	WinActivate($menueditorGUI)
	GUISwitch($menueditorGUI)
	$data = _Pluginstring_get_element($Nachricht, 2)
	If $data = GUICtrlRead($menueditor_func_input) Then Return
	If $data = "" Then Return
	GUICtrlSetData($menueditor_func_input, $data)
EndFunc   ;==>_Show_Funcs