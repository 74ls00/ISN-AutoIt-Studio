;Macroeditor for ISN


Func _Build_Rulelist()
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($listview_projectrules))
_GUICtrlListView_BeginUpdate($listview_projectrules)
if not FileExists($Pfad_zur_Project_ISN) then return
$var = IniReadSectionNames($Pfad_zur_Project_ISN)
$count = 0
If @error Then
    MsgBox(4096, "", "Error reading .isn file!")
Else
    For $i = 1 To $var[0]
        if StringInStr($var[$i],"#isnrule#") then
			$count = $count+1
			_GUICtrlListView_AddItem($listview_projectrules,iniread($Pfad_zur_Project_ISN,$var[$i],"name","#ERROR#"),52)
			if iniread($Pfad_zur_Project_ISN,$var[$i],"status","active") = "active" then
			_GUICtrlListView_AddSubItem($listview_projectrules,_GUICtrlListView_GetItemCount($listview_projectrules)-1,_Get_langstr(136), 1)
			else
			_GUICtrlListView_AddSubItem($listview_projectrules,_GUICtrlListView_GetItemCount($listview_projectrules)-1,_Get_langstr(137), 1)
			endif
			_GUICtrlListView_AddSubItem($listview_projectrules,_GUICtrlListView_GetItemCount($listview_projectrules)-1,$var[$i], 2)

		endif
    Next
EndIf
$direction = false
_GUICtrlListView_SimpleSort($listview_projectrules,$direction, 0)
_GUICtrlListView_SetSelectionMark($listview_projectrules,-1)
_GUICtrlListView_SetItemSelected($listview_projectrules,-1,false,false)
_GUICtrlListView_EndUpdate($listview_projectrules)

_GUICtrlListView_CopyAllItems(GUICtrlGetHandle($listview_projectrules), GUICtrlGetHandle($makro_auswaehlen_listview)) ;Kopiere Makro-Liste in die Makro Auswählen GUI
EndFunc

func _Show_Ruleeditor()
_Build_Rulelist()
GUISetState(@SW_SHOW,$ruleseditor)
guisetstate(@SW_DISABLE, $StudioFenster)

EndFunc

func _Hide_Ruleeditor()
guisetstate(@SW_ENABLE, $StudioFenster)
GUISetState(@SW_Hide,$ruleseditor)
_Check_Buttons(0)
_rezize()
_Reload_Ruleslots()
EndFunc


func _Show_new_rule_form($nrr=0)
;~ if not IsDeclared("nr") then $nr = 0
if $nrr == 0 then
	guictrlsetdata($new_rule_title,_Get_langstr(520))
	WinSetTitle($newrule_GUI,"",_Get_langstr(520))
	$nrr = "#isnrule#"&@year&@mon&@mday&@min&@sec&Random(0,200,1)
	guictrlsetdata($rule_ID,$nrr)
Else
	guictrlsetdata($new_rule_title,_Get_langstr(523))
	WinSetTitle($newrule_GUI,"",_Get_langstr(523))
	guictrlsetdata($rule_ID,$nrr)
endif
guictrlsetdata($rule_name_input,iniread($Pfad_zur_Project_ISN,$nrr,"name",""))
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($new_rule_triggerlist))
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($new_rule_actionlist))

;load triggerlist if possible
$triggers = iniread($Pfad_zur_Project_ISN,$nrr,"triggers","")
$triggers_array = StringSplit ($triggers, "|",2)
for $u = 0 to ubound($triggers_array)-1
if $triggers_array[$u] <> "" then
_GUICtrlListView_AddItem($new_rule_triggerlist,_get_triggername_by_section($triggers_array[$u]),53)
_GUICtrlListView_AddSubItem($new_rule_triggerlist,_GUICtrlListView_GetItemCount($new_rule_triggerlist)-1,$triggers_array[$u], 1)
endif
next

_Reload_Actionlist()
GUISetState(@SW_SHOW,$newrule_GUI)
GUISetState(@SW_Hide,$ruleseditor)

endfunc

func _Neues_Makro_Abbrechen()
IniReadSection ($Pfad_zur_Project_ISN, guictrlread($rule_ID))
if @error=1 then
		$to_delete = guictrlread($rule_ID)
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
		_Show_Ruleeditor()
		GUISetState(@SW_hide,$newrule_GUI)
	Else
		_Speichere_Neue_Regel()
endif
endfunc




func _Add_Trigger_to_list()


;Nur eine Regel Pro Regelslot
$x = $Trigger_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($Trigger_Combolist)]
if $x = $Section_Trigger12 OR $x = $Section_Trigger13 OR $x = $Section_Trigger14 OR $x = $Section_Trigger15 OR $x = $Section_Trigger16 OR $x = $Section_Trigger17 OR $x = $Section_Trigger18 then
$sections = IniReadSection($Pfad_zur_Project_ISN,$x)
If not @error Then
	msgbox(262144 + 16, _Get_langstr(25), _Get_langstr(616), 0, $choose_trigger)
Return
endif
endif


;falls schon in der liste -> irgnore
$iI = _GUICtrlListView_FindText($new_rule_triggerlist,guictrlread($Trigger_Combolist))
if $iI = -1 then
_GUICtrlListView_AddItem($new_rule_triggerlist,guictrlread($Trigger_Combolist),53)
_GUICtrlListView_AddSubItem($new_rule_triggerlist,_GUICtrlListView_GetItemCount($new_rule_triggerlist)-1,$Trigger_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($Trigger_Combolist)] , 1)
IniWrite($Pfad_zur_Project_ISN, $Trigger_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($Trigger_Combolist)], guictrlread($rule_ID), "")
EndIf
_close_Add_Trigger()
if $iI = -1 then
if guictrlread($Trigger_Combolist) = _Get_langstr(611) then _Show_Set_Ruleslot_icon(1)
if guictrlread($Trigger_Combolist) = _Get_langstr(612) then _Show_Set_Ruleslot_icon(2)
if guictrlread($Trigger_Combolist) = _Get_langstr(613) then _Show_Set_Ruleslot_icon(3)
if guictrlread($Trigger_Combolist) = _Get_langstr(614) then _Show_Set_Ruleslot_icon(4)
if guictrlread($Trigger_Combolist) = _Get_langstr(615) then _Show_Set_Ruleslot_icon(5)
if guictrlread($Trigger_Combolist) = _Get_langstr(906) then _Show_Set_Ruleslot_icon(6)
if guictrlread($Trigger_Combolist) = _Get_langstr(907) then _Show_Set_Ruleslot_icon(7)
EndIf

endfunc

func _close_Add_Trigger()
GUISetState(@SW_ENABLE,$newrule_GUI)
GUISetState(@SW_HIDE,$choose_trigger)
endfunc

func _delete_trigger_from_list()
if _GUICtrlListView_GetSelectionMark($new_rule_triggerlist) = -1 then return
if _GUICtrlListView_GetItemCount($new_rule_triggerlist) = 0 then return
IniDelete($Pfad_zur_Project_ISN, _GUICtrlListView_GetItemText($new_rule_triggerlist,_GUICtrlListView_GetSelectionMark($new_rule_triggerlist),1), guictrlread($rule_ID))
_GUICtrlListView_DeleteItem(GUICtrlGetHandle($new_rule_triggerlist), _GUICtrlListView_GetSelectionMark($new_rule_triggerlist))
endfunc

func _Speichere_Neue_Regel()
if guictrlread($rule_name_input) = "" then
_Input_Error_FX($rule_name_input)
return
EndIf
if iniread($Pfad_zur_Project_ISN,guictrlread($rule_ID),"status","") = "" then IniWrite($Pfad_zur_Project_ISN,guictrlread($rule_ID),"status","active")
IniWrite($Pfad_zur_Project_ISN,guictrlread($rule_ID),"name",guictrlread($rule_name_input))
$triggerstring = ""
for $i = 0 to _GUICtrlListView_GetItemCount($new_rule_triggerlist)-1
$triggerstring = $triggerstring&_GUICtrlListView_GetItemText($new_rule_triggerlist,$i,1)&"|"
next
IniWrite($Pfad_zur_Project_ISN,guictrlread($rule_ID),"triggers",$triggerstring)
_Show_Ruleeditor()
GUISetState(@SW_hide,$newrule_GUI)
_Earn_trophy(13,1)
endfunc

func _Editiere_Regel()
if _GUICtrlListView_GetSelectionMark($listview_projectrules) = -1 then return
if _GUICtrlListView_GetItemCount($listview_projectrules) = 0 then return
_Show_new_rule_form(_GUICtrlListView_GetItemText($listview_projectrules,_GUICtrlListView_GetSelectionMark($listview_projectrules),2))
endfunc

func _Show_new_rule_event()
_Show_new_rule_form(0)
endfunc




func _Rule_toggle_active()
if _GUICtrlListView_GetSelectionMark($listview_projectrules) = -1 then return
if _GUICtrlListView_GetItemCount($listview_projectrules) = 0 then return
$old_sec = _GUICtrlListView_GetSelectionMark($listview_projectrules)
if Iniread($Pfad_zur_Project_ISN, _GUICtrlListView_GetItemText($listview_projectrules,_GUICtrlListView_GetSelectionMark($listview_projectrules),2),"status","active") = "active" Then
Iniwrite($Pfad_zur_Project_ISN, _GUICtrlListView_GetItemText($listview_projectrules,_GUICtrlListView_GetSelectionMark($listview_projectrules),2),"status","inactive")
else
Iniwrite($Pfad_zur_Project_ISN, _GUICtrlListView_GetItemText($listview_projectrules,_GUICtrlListView_GetSelectionMark($listview_projectrules),2),"status","active")
endif
_Build_Rulelist()
_GUICtrlListView_SetItemSelected($listview_projectrules,$old_sec,true,true)
_load_ruledetails()
endfunc

func _load_ruledetails()
if _GUICtrlListView_GetSelectionMark($listview_projectrules) = -1 then
	GUICtrlSetData($btn_toggle_rulestatus,_Get_langstr(514))
	return
endif
if _GUICtrlListView_GetItemCount($listview_projectrules) = 0 then return
if _GUICtrlListView_GetItemText($listview_projectrules,_GUICtrlListView_GetSelectionMark($listview_projectrules),1) = _Get_langstr(136) then
GUICtrlSetData($btn_toggle_rulestatus,_Get_langstr(514))
Button_AddIcon($btn_toggle_rulestatus, $smallIconsdll, 1173,0)
else
GUICtrlSetData($btn_toggle_rulestatus,_Get_langstr(515))
Button_AddIcon($btn_toggle_rulestatus, $smallIconsdll, 314,0)
EndIf
endfunc









func _close_Add_action()
GUISetState(@SW_ENABLE,$newrule_GUI)
GUISetState(@SW_HIDE,$choose_action_GUI)
endfunc


func _Add_action_to_list_event()
_Add_action_to_list("")
endfunc

func _Add_action_to_list($Action_ID="")
$new_taskid = @mday&@min&@sec&random(0,300,1)
if $Action_ID = "" then
_Config_Ruleaction($Action_Selection_combo_ARRAY[_GUICtrlComboBox_GetCurSel($action_Combolist)],$new_taskid)
Else
 _Config_Ruleaction($Action_ID,$new_taskid)
endif
endfunc

func _Reload_Actionlist()
_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($new_rule_actionlist))
_GUICtrlListView_BeginUpdate($new_rule_actionlist)

;load actionlist
$actions_string = iniread($Pfad_zur_Project_ISN,guictrlread($rule_ID),"actions","")
$actions_array = StringSplit ($actions_string, "|",2)
for $u = 0 to ubound($actions_array)-1
if $actions_array[$u] <> "" then
_GUICtrlListView_AddItem($new_rule_actionlist,_get_actionname_by_section($actions_array[$u]),54)
_GUICtrlListView_AddSubItem($new_rule_actionlist,_GUICtrlListView_GetItemCount($new_rule_actionlist)-1,_get_details_by_section($actions_array[$u]), 1)
_GUICtrlListView_AddSubItem($new_rule_actionlist,_GUICtrlListView_GetItemCount($new_rule_actionlist)-1,$actions_array[$u], 2)
endif
next

_GUICtrlListView_endUpdate($new_rule_actionlist)

endfunc


func _Move_actionitem_up()
if _GUICtrlListView_GetSelectionMark($new_rule_actionlist) = -1 then return
if _GUICtrlListView_GetItemCount($new_rule_actionlist) = 0 then return
_GUICtrlListView_MoveItems($new_rule_actionlist, -1)
_GUICtrlListView_EnsureVisible($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist))
_GUICtrlListView_SetItemSelected($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist),True,true)
$actionstring = ""
for $i = 0 to _GUICtrlListView_GetItemCount($new_rule_actionlist)-1
$actionstring = $actionstring&_GUICtrlListView_GetItemText($new_rule_actionlist,$i,2)&"|"
next
IniWrite($Pfad_zur_Project_ISN,guictrlread($rule_ID),"actions",$actionstring)
EndFunc

func _Move_actionitem_down()
if _GUICtrlListView_GetSelectionMark($new_rule_actionlist) = -1 then return
if _GUICtrlListView_GetItemCount($new_rule_actionlist) = 0 then return
_GUICtrlListView_MoveItems($new_rule_actionlist, 1)
_GUICtrlListView_EnsureVisible($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist))
_GUICtrlListView_SetItemSelected($new_rule_actionlist, _GUICtrlListView_GetSelectionMark($new_rule_actionlist),True,true)
$actionstring = ""
for $i = 0 to _GUICtrlListView_GetItemCount($new_rule_actionlist)-1
$actionstring = $actionstring&_GUICtrlListView_GetItemText($new_rule_actionlist,$i,2)&"|"
next
IniWrite($Pfad_zur_Project_ISN,guictrlread($rule_ID),"actions",$actionstring)
EndFunc

func _edit_action()
if _GUICtrlListView_GetSelectionMark($new_rule_actionlist) = -1 then return
if _GUICtrlListView_GetItemCount($new_rule_actionlist) = 0 then return
$section = _GUICtrlListView_GetItemText($new_rule_actionlist,_GUICtrlListView_GetSelectionMark($new_rule_actionlist),2)
$action = StringTrimRight($section,stringlen($section)-stringinstr($section,"[")+1)
$action_ID = _StringBetween($section, '[', ']')
_Config_Ruleaction($action,$action_ID[0])
EndFunc

func _remove_action()
if _GUICtrlListView_GetSelectionMark($new_rule_actionlist) = -1 then return
if _GUICtrlListView_GetItemCount($new_rule_actionlist) = 0 then return
$section = _GUICtrlListView_GetItemText($new_rule_actionlist,_GUICtrlListView_GetSelectionMark($new_rule_actionlist),2)
$action = StringTrimRight($section,stringlen($section)-stringinstr($section,"[")+1)
$action_ID = _StringBetween($section, '[', ']')
switch $action
case $Key_Action1
inidelete($Pfad_zur_Project_ISN,guictrlread($rule_ID),"statusbar_string["&$action_ID[0]&"]")
case $Key_Action2
inidelete($Pfad_zur_Project_ISN,guictrlread($rule_ID),"sleep_time["&$action_ID[0]&"]")
case $Key_Action4
inidelete($Pfad_zur_Project_ISN,guictrlread($rule_ID),"fileoperation_mode["&$action_ID[0]&"]")
inidelete($Pfad_zur_Project_ISN,guictrlread($rule_ID),"fileoperation_source["&$action_ID[0]&"]")
inidelete($Pfad_zur_Project_ISN,guictrlread($rule_ID),"fileoperation_target["&$action_ID[0]&"]")
inidelete($Pfad_zur_Project_ISN,guictrlread($rule_ID),"fileoperation_mustconfirm["&$action_ID[0]&"]")



EndSwitch
_GUICtrlListView_DeleteItem(GUICtrlGetHandle($new_rule_actionlist),_GUICtrlListView_GetSelectionMark($new_rule_actionlist))
$actionstring = ""
for $i = 0 to _GUICtrlListView_GetItemCount($new_rule_actionlist)-1
$actionstring = $actionstring&_GUICtrlListView_GetItemText($new_rule_actionlist,$i,2)&"|"
next
IniWrite($Pfad_zur_Project_ISN,guictrlread($rule_ID),"actions",$actionstring)
_Reload_Actionlist()
EndFunc

func _Export_Rules()
$line = FileSaveDialog(_Get_langstr(589), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Macros (*.ini)", 18,"Macro.ini", $ruleseditor)
if $line = "" then Return
if @Error > 0 then return
$source = $Pfad_zur_Project_ISN
$des = $line
$var = IniReadSectionNames($source)
If @error Then
    MsgBox(4096, "", "Error while reading project file (*.isn)")
	return
Else
    For $i = 1 To $var[0]
        if stringinstr($var[$i],"#ruletrigger") OR stringinstr($var[$i],"#isnrule#") Then
			$data = IniReadSection ($source,$var[$i])
			IniWriteSection ($des, $var[$i], $data)
		endif
    Next
EndIf
FileChangeDir(@scriptdir)
msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $ruleseditor)
EndFunc

func _import_Rules()
	$var = FileOpenDialog(_Get_langstr(590), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Macro (*.ini)", 1 + 2 + 4, "", $ruleseditor)
	FileChangeDir(@scriptdir)
	If @error Then return
	if $var = "" then return

$source =$var
$des = $Pfad_zur_Project_ISN
$var = IniReadSectionNames($source)
If @error Then
    MsgBox(4096, "", "Error while reading .ini")
	return
Else
    For $i = 1 To $var[0]
        if stringinstr($var[$i],"#ruletrigger") OR stringinstr($var[$i],"#isnrule#") Then
			$data = IniReadSection ($source,$var[$i])
			IniWriteSection ($des, $var[$i], $data)
		endif
    Next
EndIf
FileChangeDir(@scriptdir)
_Build_Rulelist()
msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(591), 0, $ruleseditor)
EndFunc
;===============================================================================
; Function Name:    _GUICtrlListView_MoveItems()
; Description:      Moves Up or Down selected item(s) in ListView.
;
; Parameter(s):     $hListView          - ControlID or Handle of ListView control.
;                   $iDirection         - Define in what direction item(s) will move:
;                                           -1 - Move Up.
;                                            1 - Move Down.
;
; Requirement(s):   AutoIt 3.3.0.0
;
; Return Value(s):  On seccess - Move selected item(s) Up/Down and return 1.
;                   On failure - Return "" (empty string) and set @error as following:
;                                                                  1 - No selected item(s).
;                                                                  2 - $iDirection is wrong value (not 1 and not -1).
;                                                                  3 - Item(s) can not be moved, reached last/first item.
;
; Note(s):          * If you select like 15-20 (or more) items, moving them can take a while :( (second or two).
;
; Author(s):        G.Sandler a.k.a CreatoR
;===============================================================================
Func _GUICtrlListView_MoveItems($hListView, $iDirection)
    Local $aSelected_Indices = _GUICtrlListView_GetSelectedIndices($hListView, 1)

    If UBound($aSelected_Indices) < 2 Then Return SetError(1, 0, "")
    If $iDirection <> 1 And $iDirection <> -1 Then Return SetError(2, 0, "")

    Local $iTotal_Items = _GUICtrlListView_GetItemCount($hListView)
    Local $iTotal_Columns = _GUICtrlListView_GetColumnCount($hListView)

    Local $iUbound = UBound($aSelected_Indices)-1, $iNum = 1, $iStep = 1

    Local $iCurrent_Index, $iUpDown_Index, $sCurrent_ItemText, $sUpDown_ItemText
    Local $iCurrent_Index, $iCurrent_CheckedState, $iUpDown_CheckedState
    Local $iImage_Current_Index, $iImage_UpDown_Index

    If ($iDirection = -1 And $aSelected_Indices[1] = 0) Or _
        ($iDirection = 1 And $aSelected_Indices[$iUbound] = $iTotal_Items-1) Then Return SetError(3, 0, "")

    ControlListView($hListView, "", "", "SelectClear")

    If $iDirection = 1 Then
        $iNum = $iUbound
        $iUbound = 1
        $iStep = -1
    EndIf

    For $i = $iNum To $iUbound Step $iStep
        $iCurrent_Index = $aSelected_Indices[$i]
        $iUpDown_Index = $aSelected_Indices[$i]+1
        If $iDirection = -1 Then $iUpDown_Index = $aSelected_Indices[$i]-1

        $iCurrent_CheckedState = _GUICtrlListView_GetItemChecked($hListView, $iCurrent_Index)
        $iUpDown_CheckedState = _GUICtrlListView_GetItemChecked($hListView, $iUpDown_Index)

        _GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index)

        For $j = 0 To $iTotal_Columns-1
            $sCurrent_ItemText = _GUICtrlListView_GetItemText($hListView, $iCurrent_Index, $j)
            $sUpDown_ItemText = _GUICtrlListView_GetItemText($hListView, $iUpDown_Index, $j)

            If _GUICtrlListView_GetImageList($hListView, 1) <> 0 Then
                $iImage_Current_Index = _GUICtrlListView_GetItemImage($hListView, $iCurrent_Index, $j)
                $iImage_UpDown_Index = _GUICtrlListView_GetItemImage($hListView, $iUpDown_Index, $j)

                _GUICtrlListView_SetItemImage($hListView, $iCurrent_Index, $iImage_UpDown_Index, $j)
                _GUICtrlListView_SetItemImage($hListView, $iUpDown_Index, $iImage_Current_Index, $j)
            EndIf

            _GUICtrlListView_SetItemText($hListView, $iUpDown_Index, $sCurrent_ItemText, $j)
            _GUICtrlListView_SetItemText($hListView, $iCurrent_Index, $sUpDown_ItemText, $j)
        Next

        _GUICtrlListView_SetItemChecked($hListView, $iUpDown_Index, $iCurrent_CheckedState)
        _GUICtrlListView_SetItemChecked($hListView, $iCurrent_Index, $iUpDown_CheckedState)

        _GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index, 0)
    Next

    For $i = 1 To UBound($aSelected_Indices)-1
        $iUpDown_Index = $aSelected_Indices[$i]+1
        If $iDirection = -1 Then $iUpDown_Index = $aSelected_Indices[$i]-1
        _GUICtrlListView_SetItemSelected($hListView, $iUpDown_Index)
    Next

	 _GUICtrlListView_SetSelectionMark($hListView, $iUpDown_Index)
    Return 1
EndFunc

 func _edit_trigger()
if _GUICtrlListView_GetSelectionMark($new_rule_triggerlist) = -1 then return
if _GUICtrlListView_GetItemCount($new_rule_triggerlist) = 0 then return
$text =  _GUICtrlListView_GetItemText($new_rule_triggerlist,_GUICtrlListView_GetSelectionMark($new_rule_triggerlist),0)
switch $text

case _Get_langstr(611)
	_Show_Set_Ruleslot_icon(1)
	return

case _Get_langstr(612)
	_Show_Set_Ruleslot_icon(2)
	return

case _Get_langstr(613)
	_Show_Set_Ruleslot_icon(3)
	return

case _Get_langstr(614)
	_Show_Set_Ruleslot_icon(4)
	return

case _Get_langstr(615)
	_Show_Set_Ruleslot_icon(5)
	return

case _Get_langstr(906)
	_Show_Set_Ruleslot_icon(6)
	return

case _Get_langstr(907)
	_Show_Set_Ruleslot_icon(7)
	return

EndSwitch
msgbox(262144 + 64, _Get_langstr(178), _Get_langstr(549), 0, $newrule_GUI)
endfunc


func _make_icon_default()
if $ID_Holder_For_ruleiconconfig = 1 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot1","1")
if $ID_Holder_For_ruleiconconfig = 2 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot2","909")
if $ID_Holder_For_ruleiconconfig = 3 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot3","1020")
if $ID_Holder_For_ruleiconconfig = 4 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot4","1130")
if $ID_Holder_For_ruleiconconfig = 5 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot5","1241")
if $ID_Holder_For_ruleiconconfig = 6 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot6","1345")
if $ID_Holder_For_ruleiconconfig = 7 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot7","1456")
_Show_Set_Ruleslot_icon($ID_Holder_For_ruleiconconfig)
endfunc

func _Show_Set_Ruleslot_icon($slot = 1)
	$ID_Holder_For_ruleiconconfig = $slot
	GUISetState(@SW_DISABLE, $newrule_GUI)
	if $ID_Holder_For_ruleiconconfig = 1 then $read = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot1","1")
	if $ID_Holder_For_ruleiconconfig = 2 then $read = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot2","909")
	if $ID_Holder_For_ruleiconconfig = 3 then $read = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot3","1020")
	if $ID_Holder_For_ruleiconconfig = 4 then $read = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot4","1130")
	if $ID_Holder_For_ruleiconconfig = 5 then $read = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot5","1241")
	if $ID_Holder_For_ruleiconconfig = 6 then $read = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot6","1345")
	if $ID_Holder_For_ruleiconconfig = 7 then $read = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot7","1456")
	GUICtrlSetImage($ruleslot_ico_preview,$smallIconsdll,$read)

	if iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","ruleslot"&$ID_Holder_For_ruleiconconfig&"_projecttreecontext","0") = 0 then
	GUICtrlSetState($choose_ruleslot_checkboxprojecttree,$GUI_UNCHECKED)
	else
	GUICtrlSetState($choose_ruleslot_checkboxprojecttree,$GUI_CHECKED)
	endif

	GUISetState(@sw_show, $choose_ruleslot_icon)
endfunc

func _Hide_Ruleslot_icon()
	if guictrlread($choose_ruleslot_checkboxprojecttree) = $GUI_CHECKED Then
	IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","ruleslot"&$ID_Holder_For_ruleiconconfig&"_projecttreecontext","1")
	Else
	IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","ruleslot"&$ID_Holder_For_ruleiconconfig&"_projecttreecontext","0")
	endif
	GUISetState(@SW_ENABLE, $newrule_GUI)
	GUISetState(@SW_HIDE, $choose_ruleslot_icon)
endfunc

func _select_icon()
	GUISetState(@SW_DISABLE, $choose_ruleslot_icon)
	$iStartIndex = 1
	if $ID_Holder_For_ruleiconconfig = 1 then $iStartIndex = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot1","1")
	if $ID_Holder_For_ruleiconconfig = 2 then $iStartIndex = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot2","909")
	if $ID_Holder_For_ruleiconconfig = 3 then $iStartIndex = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot3","1020")
	if $ID_Holder_For_ruleiconconfig = 4 then $iStartIndex = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot4","1130")
	if $ID_Holder_For_ruleiconconfig = 5 then $iStartIndex = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot5","1241")
	if $ID_Holder_For_ruleiconconfig = 6 then $iStartIndex = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot6","1345")
	if $ID_Holder_For_ruleiconconfig = 7 then $iStartIndex = iniread($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot7","1456")
	$Selected_Icon = -1
	Icons_GUIUpdate()
	GUISetState(@sw_show, $gui_select_icon)
EndFunc

func _select_icons_next()
$iStartIndex = $iStartIndex + 30
Icons_GUIUpdate()
EndFunc

func _select_icons_prev()
$iStartIndex = $iStartIndex - 30
if $iStartIndex < 1 then $iStartIndex = 1
Icons_GUIUpdate()
EndFunc

Func Icons_GUIUpdate()
	For $iCntRow = 0 To 4
		For $iCntCol = 0 To 5
			$iCurIndex = $iCntRow * 6 + $iCntCol
			GUICtrlSetImage($ahIcons[$iCurIndex], $sFilename, $iOrdinal * ($iCurIndex + $iStartIndex))
			If $iOrdinal = -1 Then
				GUICtrlSetData($ahLabels[$iCurIndex], -($iCurIndex + $iStartIndex))
			Else
				GUICtrlSetData($ahLabels[$iCurIndex], '"' & ($iCurIndex + $iStartIndex) & '"')
			EndIf
		Next
	Next
	; This is because we don't want negative values
	If $iStartIndex = 1 Then
		GUICtrlSetState($hPrev, $GUI_DISABLE)
	Else
		GUICtrlSetState($hPrev, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_GUIUpdate

func _Makroslot_Icon_Abbrechen()
	GUISetState(@SW_ENABLE, $choose_ruleslot_icon)
	GUISetState(@SW_HIDE, $gui_select_icon)
endfunc


func _hit_icon()
	$read = guictrlread(@GUI_CtrlId)
	$read = StringReplace($read,"-","")
	$read = number($read)
	GUISetState(@SW_ENABLE, $choose_ruleslot_icon)
	GUISetState(@SW_HIDE, $gui_select_icon)
	if $ID_Holder_For_ruleiconconfig = 1 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot1",$read)
	if $ID_Holder_For_ruleiconconfig = 2 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot2",$read)
	if $ID_Holder_For_ruleiconconfig = 3 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot3",$read)
	if $ID_Holder_For_ruleiconconfig = 4 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot4",$read)
	if $ID_Holder_For_ruleiconconfig = 5 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot5",$read)
	if $ID_Holder_For_ruleiconconfig = 6 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot6",$read)
	if $ID_Holder_For_ruleiconconfig = 7 then IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","icon_ruleslot7",$read)
	GUICtrlSetImage($ruleslot_ico_preview,$smallIconsdll,$read)
endfunc

func _ISN_execute_macroslot_01()
if $Offenes_Projekt = "" then return
If _run_rule($Section_Trigger12) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
endfunc

func _ISN_execute_macroslot_02()
if $Offenes_Projekt = "" then return
If _run_rule($Section_Trigger13) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
endfunc

func _ISN_execute_macroslot_03()
if $Offenes_Projekt = "" then return
If _run_rule($Section_Trigger14) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
endfunc

func _ISN_execute_macroslot_04()
if $Offenes_Projekt = "" then return
If _run_rule($Section_Trigger15) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
endfunc

func _ISN_execute_macroslot_05()
if $Offenes_Projekt = "" then return
If _run_rule($Section_Trigger16) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
endfunc

func _ISN_execute_macroslot_06()
if $Offenes_Projekt = "" then return
If _run_rule($Section_Trigger17) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
endfunc

func _ISN_execute_macroslot_07()
if $Offenes_Projekt = "" then return
If _run_rule($Section_Trigger18) = 0 Then MsgBox(262144 + 64, _Get_langstr(61), _Get_langstr(618), 0, $Studiofenster)
endfunc

