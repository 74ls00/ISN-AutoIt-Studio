;Addons3
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")


Func _Make_Control_from_toolbox()
	AdlibUnRegister("_Make_Control_from_toolbox")
	MouseUp("primary")
	$str = _GUICtrlListView_GetItemText($Toolbox_listview, _GUICtrlListView_GetSelectionMark($Toolbox_listview), 0)
	If $str = _ISNPlugin_Get_langstring(22) Then _new_Control("button")
	If $str = _ISNPlugin_Get_langstring(23) Then _new_Control("label")
	If $str = _ISNPlugin_Get_langstring(24) Then _new_Control("input")
	If $str = _ISNPlugin_Get_langstring(25) Then _new_Control("checkbox")
	If $str = _ISNPlugin_Get_langstring(26) Then _new_Control("radio")
	If $str = _ISNPlugin_Get_langstring(27) Then _new_Control("image")
	If $str = _ISNPlugin_Get_langstring(28) Then _new_Control("slider")
	If $str = _ISNPlugin_Get_langstring(29) Then _new_Control("progress")
	If $str = _ISNPlugin_Get_langstring(31) Then _new_Control("updown")
	If $str = _ISNPlugin_Get_langstring(32) Then _new_Control("icon")
	If $str = _ISNPlugin_Get_langstring(33) Then _new_Control("combo")
	If $str = _ISNPlugin_Get_langstring(34) Then _new_Control("edit")
	If $str = _ISNPlugin_Get_langstring(35) Then _new_Control("group")
	If $str = _ISNPlugin_Get_langstring(36) Then _new_Control("listbox")
	If $str = _ISNPlugin_Get_langstring(38) Then _new_Control("tab")
	If $str = _ISNPlugin_Get_langstring(39) Then _new_Control("date")
	If $str = _ISNPlugin_Get_langstring(40) Then _new_Control("calendar")
	If $str = _ISNPlugin_Get_langstring(41) Then _new_Control("listview")
	If $str = _ISNPlugin_Get_langstring(232) Then _new_Control("dummy")
	If $str = _ISNPlugin_Get_langstring(246) Then _new_Control("graphic")
	If $str = _ISNPlugin_Get_langstring(252) Then _new_Control("toolbar")
	If $str = _ISNPlugin_Get_langstring(124) Then
		If Not @OSType = "WIN32_NT" Then
			MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(135), 0, $Studiofenster)
			Return
		EndIf
		If @OSVersion = "WIN_2000" Or @OSVersion = "WIN_2003" Or @OSVersion = "WIN_XP" Or @OSVersion = "WIN_XPe" Then
			MsgBox(262144 + 16, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(135), 0, $Studiofenster)
			Return
		EndIf
		_new_Control("softbutton")
	EndIf
	If $str = _ISNPlugin_Get_langstring(136) Then _new_Control("ip")
	If $str = _ISNPlugin_Get_langstring(138) Then _new_Control("treeview")
	If $str = _ISNPlugin_Get_langstring(192) Then _new_Control("menu")
	If $str = _ISNPlugin_Get_langstring(214) Then _new_Control("com")
	If $str = _ISNPlugin_Get_langstring(258) Then _new_Control("statusbar")
EndFunc   ;==>_Make_Control_from_toolbox

Func _test_code()

	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_DISABLE, $GUI_Editor)
	_TEST_FORM(1, 0, 1)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
EndFunc   ;==>_test_code





Func _Code_Generieren()
	_ISNPlugin_Get_Variable("$ISN_Languagefile", "$Languagefile", $Mailslot_Handle)
	_ISNPlugin_Get_Variable("$ISN_Scriptdir", "@scriptdir", $Mailslot_Handle)
    Entferne_Makierung() ;Evtl. Markierte Controls demarkieren
	WinSetTitle($ExtracodeGUI, "", _ISNPlugin_Get_langstring(69))
	GUICtrlSetData($ExtracodeGUI_Label, _ISNPlugin_Get_langstring(69))
	GUISetState(@SW_DISABLE, $GUI_Editor)
	GUISetState(@SW_DISABLE, $StudioFenster)
	GUISetState(@SW_DISABLE, $StudioFenster_inside)
	GUISetState(@SW_DISABLE, $Formstudio_controleditor_GUI)


	GUISetState(@SW_HIDE, $GUI_Editor)
	GUISetState(@SW_HIDE, $Formstudio_controleditor_GUI)
	GUICtrlSetData($StudioFenster_inside_Text1, _ISNPlugin_Get_langstring(86) & "...")
	GUICtrlSetData($StudioFenster_inside_Text2, "0 %")
	GUICtrlSetData($StudioFenster_inside_load, 0)
	GUICtrlSetState($StudioFenster_inside_Text1, $GUI_SHOW)
	GUICtrlSetState($StudioFenster_inside_Text2, $GUI_SHOW)
	GUICtrlSetState($StudioFenster_inside_Icon, $GUI_SHOW)
	GUICtrlSetState($StudioFenster_inside_load, $GUI_SHOW)

	_TEST_FORM(0, 1, 0, 1) ;Echter isf Code

	SendMessage($sci, $SCI_CLEARALL, 0, 0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessage($sci, $SCI_SETSAVEPOINT, 0, 0)
	SendMessage($sci, $SCI_CANCEL, 0, 0)
	SendMessage($sci, $SCI_SETUNDOCOLLECTION, 0, 0)
	$data = FileRead($Temp_AU3_File)
	if @error then MsgBox(4096, "Error", $Temp_AU3_File & " read error!" & @error)
	$Generierter_Code_ISF = _UNICODE2ANSI($data)


    SendMessageString($Sci,$SCI_SETTEXT,0,$Generierter_Code_ISF)
	SendMessage($sci, $SCI_SETUNDOCOLLECTION, 1, 0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER, 0, 0)
	SendMessage($sci, $SCI_SETSAVEPOINT, 0, 0)
	SendMessage($sci, $SCI_GOTOPOS, 0, 0)



	GUICtrlSetState($Showcodebt1, $GUI_SHOW)
	GUICtrlSetState($Showcodebt2, $GUI_SHOW)
	GUICtrlSetState($Showcodebt3, $GUI_SHOW)
    ControlSHOW ($ExtracodeGUI, "", $Code_Generieren_umschalttab )
    GUISetOnEvent($GUI_EVENT_CLOSE,"_HIDE_Extracode",$ExtracodeGUI)
    GUICtrlSetOnEvent($Showcodebt1,"_HIDE_Extracode")

	$wipos = WinGetPos($Studiofenster, "")
	$mon = _GetMonitorFromPoint($wipos[0], $wipos[1])
	_CenterOnMonitor($ExtracodeGUI, "", $mon)

	_TEST_FORM(0, 0, 0, 1) ;Alleinstehend

	$data = FileRead($Temp_AU3_File)
	if @error then MsgBox(4096, "Error", $Temp_AU3_File & " read error!" & @error)
	$Generierter_Code_AU3 = _UNICODE2ANSI($data)

	_GUICtrlTab_SetCurSel($Code_Generieren_umschalttab, 0)

	GUICtrlSetState($StudioFenster_inside_Text1, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_Text2, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_Icon, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_load, $GUI_HIDE)
	GUISetState(@SW_SHOW, $ExtracodeGUI)
	GUISetState(@SW_SHOW, $GUI_Editor)
	GUISetState(@SW_SHOW, $Formstudio_controleditor_GUI)
	Sci_SetSelection($Sci, 0, 0)
	If $ISN_Languagefile <> "" Then
		$ISN_Languagefile = $ISN_Scriptdir & "\data\language\" & $ISN_Languagefile
		_ISNPlugin_Starte_Funktion_im_ISN("_Show_Warning", "formstudio_confirmgeneratecodeinfo", 308, IniRead($ISN_Languagefile, "ISNAUTOITSTUDIO", "str61", ""), IniRead($ISN_Languagefile, "ISNAUTOITSTUDIO", "str1012", ""), IniRead($ISN_Languagefile, "ISNAUTOITSTUDIO", "str7", ""))
	EndIf
EndFunc   ;==>_Code_Generieren

Func _Code_generieren_Tab_Event()
	AdlibUnRegister("_Code_generieren_Tab_Event")

	Switch _GUICtrlTab_GetCurSel($Code_Generieren_umschalttab)

		Case 0
			SendMessage($sci, $SCI_CLEARALL, 0, 0)
			 SendMessageString($Sci,$SCI_SETTEXT,0, $Generierter_Code_ISF)

		Case 1
			SendMessage($sci, $SCI_CLEARALL, 0, 0)
			 SendMessageString($Sci,$SCI_SETTEXT,0, $Generierter_Code_AU3)

	EndSwitch

EndFunc   ;==>_Code_generieren_Tab_Event

Func _typereturnicon($type = "")
	Switch $type

		Case "button"
			Return 0

		Case "label"
			Return 1

		Case "input"
			Return 2

		Case "checkbox"
			Return 3

		Case "radio"
			Return 4

		Case "image"
			Return 5

		Case "slider"
			Return 6

		Case "progress"
			Return 7

		Case "updown"
			Return 8

		Case "icon"
			Return 9

		Case "combo"
			Return 10

		Case "edit"
			Return 11

		Case "group"
			Return 12

		Case "listbox"
			Return 13

		Case "tab"
			Return 14

		Case "date"
			Return 15

		Case "calendar"
			Return 16

		Case "listview"
			Return 17

		Case "softbutton"
			Return 18

		Case "ip"
			Return 19

		Case "treeview"
			Return 20

		Case "menu"
			Return 21

		Case "com"
			Return 22

		Case "dummy"
			Return 23

		Case "graphic"
			Return 24

		Case "toolbar"
			Return 25

	EndSwitch
	Return 0
EndFunc   ;==>_typereturnicon

Func _Load_Styles_for_Control($type = "")
	If $type = "" Then
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_style_listview))
		Return
	EndIf
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_style_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($minieditor_style_listview))



	If $type = "button" Or $type = "checkbox" Or $type = "radio" Or $type = "group" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_LEFT", 0)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_RIGHT", 1)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_TOP", 2)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_BOTTOM", 3)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_CENTER", 4)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_DEFPUSHBUTTON", 5)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_MULTILINE", 6)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_BORDER", 7)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_VCENTER", 8)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_ICON", 9)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_BITMAP", 10)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_FLAT", 11)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_NOTIFY", 12)
	EndIf

	If $type = "checkbox" Or $type = "radio" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_RIGHTBUTTON", 0)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_3STATE", 0)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_AUTO3STATE", 0)
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_AUTORADIOBUTTON", 0)
	EndIf


	If $type = "label" Or $type = "icon" Or $type = "image" Or $type = "graphic" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_LEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_RIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_CENTER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_NOPREFIX")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_LEFTNOWORDWRAP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_RIGHTJUST")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_BLACKFRAME")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_BLACKRECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_CENTERIMAGE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_GRAYFRAME")
	    _GUICtrlListView_AddItem($minieditor_style_listview, "$SS_ETCHEDFRAME")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_ETCHEDHORZ")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_ETCHEDVERT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_GRAYRECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_NOTIFY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_SIMPLE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_SUNKEN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_WHITEFRAME")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SS_WHITERECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_CLIPSIBLINGS")

	EndIf


	If $type = "slider" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_AUTOTICKS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_BOTH")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_BOTTOM")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_HORZ")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_VERT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_NOTHUMB")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_NOTICKS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_LEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_RIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBS_TOP")
	EndIf

	If $type = "listview" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_ICON")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_REPORT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SMALLICON")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_LIST")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_EDITLABELS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_NOCOLUMNHEADER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_NOSORTHEADER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SINGLESEL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SHOWSELALWAYS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SORTASCENDING")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_SORTDESCENDING")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LVS_NOLABELWRAP")
	EndIf


	If $type = "progress" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$PBS_SMOOTH")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$PBS_VERTICAL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$PBS_MARQUEE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_BORDER")
	EndIf

	If $type = "updown" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_ALIGNLEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_ALIGNRIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_ARROWKEYS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_HORZ")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_NOTHOUSANDS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$UDS_WRAP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_NUMBER")
	EndIf



	If $type = "input" Or $type = "edit" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_AUTOHSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_AUTOVSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_CENTER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_PASSWORD")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_READONLY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_LOWERCASE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_NOHIDESEL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_NUMBER")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_OEMCONVERT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_MULTILINE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_RIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_UPPERCASE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$ES_WANTRETURN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_VSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_HSCROLL")
	EndIf

	If $type = "combo" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_AUTOHSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_DISABLENOSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_DROPDOWN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_DROPDOWNLIST")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_LOWERCASE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_NOINTEGRALHEIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_OEMCONVERT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_SIMPLE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_SORT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$CBS_UPPERCASE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$WS_VSCROLL")
	EndIf

	If $type = "listbox" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_DISABLENOSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_NOINTEGRALHEIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_NOSEL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_NOTIFY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_SORT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_STANDARD")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$LBS_USETABSTOPS")
	EndIf

	If $type = "treeview" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_HASBUTTONS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_HASLINES")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_LINESATROOT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_DISABLEDRAGDROP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_SHOWSELALWAYS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_RTLREADING")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_NOTOOLTIPS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_CHECKBOXES")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_TRACKSELECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_SINGLEEXPAND")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_FULLROWSELECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_NOSCROLL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TVS_NONEVENHEIGHT")
	EndIf

	If $type = "tab" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_SCROLLOPPOSITE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_BOTTOM")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_RIGHT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_TOOLTIPS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_MULTISELECT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FLATBUTTONS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FORCEICONLEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FORCELABELLEFT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_HOTTRACK")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_VERTICAL")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_BUTTONS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_MULTILINE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_RIGHTJUSTIFY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FIXEDWIDTH")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FOCUSONBUTTONDOWN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_OWNERDRAWFIXED")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TCS_FOCUSNEVER")
	EndIf

	If $type = "date" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_UPDOWN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_SHOWNONE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_LONGDATEFORMAT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_TIMEFORMAT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_RIGHTALIGN")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$DTS_SHORTDATEFORMAT")
	EndIf

	If $type = "calendar" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$MCS_NOTODAY")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$MCS_NOTODAYCIRCLE")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$MCS_WEEKNUMBERS")
	EndIf

	If $type = "softbutton" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$BS_COMMANDLINK")
	EndIf

	If $type = "ip" Then
		;empty
	EndIf

	If $type = "toolbar" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_ALTDRAG")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_FLAT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_LIST")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_REGISTERDROP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_TOOLTIPS")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_TRANSPARENT")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$TBSTYLE_WRAPABLE")
	 EndIf

	If $type = "statusbar" Then
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SBARS_SIZEGRIP")
		_GUICtrlListView_AddItem($minieditor_style_listview, "$SBARS_TOOLTIPS")
	 EndIf


	$Styles_Array = StringSplit(GUICtrlRead($MiniEditor_Style), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_style_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($minieditor_style_listview, $y, True)
			Next
		Next
	EndIf

	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($minieditor_style_listview))
EndFunc   ;==>_Load_Styles_for_Control








Func _Load_states_for_Control($type = "")
	If $type = "" Then
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_state_listview))
		Return
	EndIf
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_state_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($minieditor_state_listview))
	if $type <> "menu" AND $type <> "toolbar" then
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_UNCHECKED", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_CHECKED", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_SHOW", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_HIDE", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_ENABLE", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_DISABLE", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_FOCUS", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_NOFOCUS", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_DEFBUTTON", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_EXPAND", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_ONTOP", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_INDETERMINATE", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_DROPACCEPTED", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_NODROPACCEPTED", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_AVISTART", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_AVISTOP", 0)
	_GUICtrlListView_AddItem($minieditor_state_listview, "$GUI_AVICLOSE", 0)
 EndIf

	$Styles_Array = StringSplit(GUICtrlRead($MiniEditor_ControlState), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_state_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($minieditor_state_listview, $y, True)
			Next
		Next
	EndIf
	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($minieditor_state_listview))
EndFunc   ;==>_Load_states_for_Control




Func _Load_exstyles_for_Control($type = "")
	If $type = "" Then
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_exstyle_listview))
		Return
	EndIf
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($minieditor_exstyle_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($minieditor_exstyle_listview))


	If $type = "listview" Then
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_FULLROWSELECT")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_GRIDLINES")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_HEADERDRAGDROP")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_TRACKSELECT")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_CHECKBOXES")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_BORDERSELECT")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_DOUBLEBUFFER")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_FLATSB")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_MULTIWORKAREAS")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_SNAPTOGRID")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_SUBITEMIMAGES")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$LVS_EX_INFOTIP")
	EndIf


	If $type <> "menu" And $type <> "com" Then
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$WS_EX_CLIENTEDGE", 0)
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$WS_EX_STATICEDGE", 0)
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$WS_EX_ACCEPTFILES", 0)
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$WS_EX_TRANSPARENT", 0)
	EndIf

	If $type = "toolbar" Then
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBSTYLE_EX_DRAWDDARROWS")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBN_DROPDOWN")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBSTYLE_EX_HIDECLIPPEDBUTTONS")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBSTYLE_EX_DOUBLEBUFFER")
		_GUICtrlListView_AddItem($minieditor_exstyle_listview, "$TBSTYLE_EX_MIXEDBUTTONS")
	EndIf

	$Styles_Array = StringSplit(GUICtrlRead($MiniEditor_EXStyle), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_exstyle_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $y, True)
			Next
		Next
	EndIf
	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($minieditor_exstyle_listview))
EndFunc   ;==>_Load_exstyles_for_Control



Func _Load_exstyles_for_GUI()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($gui_setup_exstyle_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($gui_setup_exstyle_listview))
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_ACCEPTFILES", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_MDICHILD", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_APPWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_TOPMOST", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_COMPOSITED", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_CLIENTEDGE", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_TOOLWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_LAYERED", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_WINDOWEDGE", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_CONTEXTHELP", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_DLGMODALFRAME", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_OVERLAPPEDWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_STATICEDGE", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_TRANSPARENT", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$WS_EX_LAYOUTRTL", 0)
	_GUICtrlListView_AddItem($gui_setup_exstyle_listview, "$GUI_WS_EX_PARENTDRAG", 0)


	$Styles_Array = StringSplit(GUICtrlRead($Form_bearbeitenExstyle), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_exstyle_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $y, True)
			Next
		Next
	EndIf

	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($gui_setup_exstyle_listview))
EndFunc   ;==>_Load_exstyles_for_GUI


Func _Load_styles_for_GUI()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($gui_setup_style_listview))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($gui_setup_style_listview))
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_POPUP", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_CAPTION", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_DISABLED", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_SIZEBOX", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_SYSMENU", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_CHILD", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_CLIPCHILDREN", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_CLIPSIBLINGS", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_EX_CLIENTEDGE", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_DLGFRAME", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_BORDER", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_HSCROLL", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_VSCROLL", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_MAXIMIZE", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_MAXIMIZEBOX", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_MINIMIZE", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_MINIMIZEBOX", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_OVERLAPPED", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_OVERLAPPEDWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_POPUPWINDOW", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_THICKFRAME", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$WS_VISIBLE", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$DS_MODALFRAME", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$DS_SETFOREGROUND", 0)
	_GUICtrlListView_AddItem($gui_setup_style_listview, "$DS_CONTEXTHELP", 0)


	$Styles_Array = StringSplit(GUICtrlRead($Form_bearbeitenStyle), "+", 2)
	If IsArray($Styles_Array) Then
		For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_style_listview)
			For $t = 0 To UBound($Styles_Array) - 1
				If $Styles_Array[$t] = _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) Then _GUICtrlListView_SetItemChecked($gui_setup_style_listview, $y, True)
			Next
		Next
	EndIf
	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($gui_setup_style_listview))
EndFunc   ;==>_Load_styles_for_GUI


Func _Rebuild_ExStylestring_for_GUI($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($gui_setup_exstyle_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($Form_bearbeitenExstyle)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_exstyle_listview)
		If _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_exstyle_listview)
		If _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($gui_setup_exstyle_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($gui_setup_exstyle_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($Form_bearbeitenExstyle, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($Form_bearbeitenExstyle, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($gui_setup_exstyle_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, True)
		EndIf
	EndIf
EndFunc   ;==>_Rebuild_ExStylestring_for_GUI

Func _Rebuild_Stylestring_for_GUI($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($gui_setup_style_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($Form_bearbeitenStyle)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_style_listview)
		If _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($gui_setup_style_listview)
		If _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($gui_setup_style_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($gui_setup_style_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($Form_bearbeitenStyle, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($Form_bearbeitenStyle, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($gui_setup_style_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, True)
		EndIf
	 EndIf
EndFunc   ;==>_Rebuild_Stylestring_for_GUI


Func _Rebuild_Stylestring($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_style_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($MiniEditor_Style)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_style_listview)
		If _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_style_listview)
		If _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($minieditor_style_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($minieditor_style_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($MiniEditor_Style, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($MiniEditor_Style, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_style_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, True)
		EndIf
	 EndIf
sleep(50)
	_Mini_Editor_Einstellungen_Uebernehmen()
	 sleep(50)
EndFunc   ;==>_Rebuild_Stylestring



Func _Rebuild_Statestring($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_state_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($MiniEditor_ControlState)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_state_listview)
		If _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_state_listview)
		If _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($minieditor_state_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($minieditor_state_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($MiniEditor_ControlState, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($MiniEditor_ControlState, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_state_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, True)
		EndIf
	 EndIf
	 sleep(50)
	_Mini_Editor_Einstellungen_Uebernehmen()
	sleep(50)
EndFunc   ;==>_Rebuild_Statestring




Func _Rebuild_exstylestring($hit_on_checkbox = 0, $Item = -1)
	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_exstyle_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, True)
		EndIf
	EndIf

	$old_string = GUICtrlRead($MiniEditor_EXStyle)
	$new_stylestring = ""

	;zuerst alle bereits vorhandenen elemente löschen
	$array = StringSplit($old_string, "+", 2)
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_exstyle_listview)
		If _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) = "" Then ContinueLoop
		For $x = 0 To UBound($array) - 1
			If $array[$x] = _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) Then $array[$x] = ""
		Next
	Next
	For $x = 0 To UBound($array) - 1
		If $array[$x] <> "" Then $new_stylestring = $new_stylestring & $array[$x] & "+"
	Next


	;Danach die aktivierten Elemente hinzufügen
	For $y = 0 To _GUICtrlListView_GetItemCount($minieditor_exstyle_listview)
		If _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) = "" Then ContinueLoop
		If _GUICtrlListView_GetItemChecked($minieditor_exstyle_listview, $y) Then $new_stylestring = $new_stylestring & _GUICtrlListView_GetItemText($minieditor_exstyle_listview, $y, 0) & "+"
	Next

	If $new_stylestring = "+" Then GUICtrlSetData($MiniEditor_EXStyle, "")
	If StringRight($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimRight($new_stylestring, 1)
	If StringLeft($new_stylestring, 1) = "+" Then $new_stylestring = StringTrimLeft($new_stylestring, 1)
	GUICtrlSetData($MiniEditor_EXStyle, $new_stylestring)


	;bug?!
	If $hit_on_checkbox = 1 Then
		If $Item = -1 Then Return
		If _GUICtrlListView_GetItemChecked($minieditor_exstyle_listview, $Item) Then
			_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, False)
		Else
			_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, True)
		EndIf
	 EndIf
	 sleep(50)
	_Mini_Editor_Einstellungen_Uebernehmen()
	sleep(50)
EndFunc   ;==>_Rebuild_exstylestring

func _Minieditor_select_allgemein()
   If BitAND(GUICtrlGetState($MiniEditor_textmode_label), $GUI_SHOW) = $GUI_SHOW Then return
   _Minieditor_tab_select(-1)
   _Minieditor_tab_select(0)
endfunc

func _Minieditor_select_aussehen()
    If BitAND(GUICtrlGetState($MiniEditor_Schriftgroese), $GUI_SHOW) = $GUI_SHOW Then return
      _Minieditor_tab_select(-1)
   _Minieditor_tab_select(1)
endfunc

func _Minieditor_select_style()
   If BitAND(GUICtrlGetState($minieditor_style), $GUI_SHOW) = $GUI_SHOW Then return
      _Minieditor_tab_select(-1)
   _Minieditor_tab_select(2)
endfunc

func _Minieditor_select_exstyle()
   If BitAND(GUICtrlGetState($minieditor_exstyle), $GUI_SHOW) = $GUI_SHOW Then return
    _Minieditor_tab_select(-1)
   _Minieditor_tab_select(3)
endfunc

func _Minieditor_select_state()
    If BitAND(GUICtrlGetState($MiniEditor_ControlState), $GUI_SHOW) = $GUI_SHOW Then return
    _Minieditor_tab_select(-1)
   _Minieditor_tab_select(4)
endfunc

func _Minieditor_naechste_seite()
 if $control_editor_tab_wechselt_mit_maus = 1 then return
 $current_page = 0
  If BitAND(GUICtrlGetState($MiniEditor_textmode_label), $GUI_SHOW) = $GUI_SHOW Then $current_page = 0
  If BitAND(GUICtrlGetState($MiniEditor_Schriftgroese), $GUI_SHOW) = $GUI_SHOW Then $current_page = 1
  If BitAND(GUICtrlGetState($minieditor_style), $GUI_SHOW) = $GUI_SHOW Then $current_page = 2
  If BitAND(GUICtrlGetState($minieditor_exstyle), $GUI_SHOW) = $GUI_SHOW Then $current_page = 3
  If BitAND(GUICtrlGetState($MiniEditor_ControlState), $GUI_SHOW) = $GUI_SHOW Then $current_page = 4
  if $current_page > 3 then return
  $control_editor_tab_wechselt_mit_maus = 1
 $current_page = $current_page+1
 GUISetState(@SW_LOCK, $Formstudio_controleditor_GUI) ;Locke die GUI
 _Minieditor_tab_select(-1)
 _Minieditor_tab_select($current_page)
 GUISetState(@SW_UNLOCK, $Formstudio_controleditor_GUI) ;GUI wieder freigeben
 GUISwitch($GUI_Editor)
 sleep(50)
 $control_editor_tab_wechselt_mit_maus = 0
EndFunc

func _Minieditor_vorherige_seite()
 if $control_editor_tab_wechselt_mit_maus = 1 then return
 $current_page = 0
  If BitAND(GUICtrlGetState($MiniEditor_textmode_label), $GUI_SHOW) = $GUI_SHOW Then $current_page = 0
  If BitAND(GUICtrlGetState($MiniEditor_Schriftgroese), $GUI_SHOW) = $GUI_SHOW Then $current_page = 1
  If BitAND(GUICtrlGetState($minieditor_style), $GUI_SHOW) = $GUI_SHOW Then $current_page = 2
  If BitAND(GUICtrlGetState($minieditor_exstyle), $GUI_SHOW) = $GUI_SHOW Then $current_page = 3
  If BitAND(GUICtrlGetState($MiniEditor_ControlState), $GUI_SHOW) = $GUI_SHOW Then $current_page = 4
  if $current_page < 1 then return
  $control_editor_tab_wechselt_mit_maus = 1
 $current_page = $current_page-1
 GUISetState(@SW_LOCK, $Formstudio_controleditor_GUI) ;Locke die GUI
 _Minieditor_tab_select(-1)
 _Minieditor_tab_select($current_page)
 GUISetState(@SW_UNLOCK, $Formstudio_controleditor_GUI) ;GUI wieder freigeben
 GUISwitch($GUI_Editor)
 sleep(50)
 $control_editor_tab_wechselt_mit_maus = 0
EndFunc


Func _Minieditor_tab_select($tab = -1)
	;GUISetState(@SW_LOCK, $Formstudio_controleditor_GUI) ;Locke die GUI
	;ich hasse diese lösung...aber es geht leider nicht anders... :(
	If $tab = -1 Then
	   if IsArray($Control_Editor_Allgemein_Tab) then _Tab_SetImage_with_Text($Control_Editor_Allgemein_Tab[1], $Tab_image_middle,0,_ISNPlugin_Get_langstring(139))
	   if IsArray($Control_Editor_Darstellung_Tab) then _Tab_SetImage_with_Text($Control_Editor_Darstellung_Tab[1], $Tab_image_middle,0,_ISNPlugin_Get_langstring(140))
	   if IsArray($Control_Editor_Style_Tab) then _Tab_SetImage_with_Text($Control_Editor_Style_Tab[1], $Tab_image_middle,0,_ISNPlugin_Get_langstring(96))
	   if IsArray($Control_Editor_ExStyle_Tab) then _Tab_SetImage_with_Text($Control_Editor_ExStyle_Tab[1], $Tab_image_middle,0,_ISNPlugin_Get_langstring(141))
	   if IsArray($Control_Editor_State_Tab) then _Tab_SetImage_with_Text($Control_Editor_State_Tab[1], $Tab_image_middle,0,_ISNPlugin_Get_langstring(142))

		GUICtrlSetState($MiniEditor_Text, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Text_erweitert, $GUI_HIDE)
		GUICtrlSetPos($MiniEditor_Schriftbreite, -9000, -9000)
		GUICtrlSetState($MiniEditor_GETBGButton, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_BGColourTrans, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_BGColour, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Schriftartwahlen, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Textfarbe, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Schriftart, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_IconPfad, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Schriftartstyle, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Schriftgroese, $GUI_HIDE)
		GUICtrlSetPos($MiniEditor_Schriftgroese, -9000, -9000)
		GUICtrlSetState($MiniEditor_Schriftbreite, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Style, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_ClickFunc, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_EXStyle, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_ControlState, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Tooltip, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_GetIconButton, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_ChooseFunc, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt2, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt3, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt4, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt5, $GUI_HIDE)
		GUICtrlSetState($minieditor_style_listview, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Style, $GUI_HIDE)
		GUICtrlSetState($minieditor_exstyle_listview, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_EXStyle, $GUI_HIDE)
		GUICtrlSetState($minieditor_state_listview, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_ControlState, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_text_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_tooltip_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_func_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_tabpage_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_hintergrund_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_bild_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_schriftart_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_atribute_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_farbe_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_groesse_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_schriftbreite_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_text_Radio1_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_textmode_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_IconPfeil1, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_IconPfeil2, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_IconPfeil3, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_IconPfeil4, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Resize_label, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Resize_punktebutton, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Resize_input, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Icon_Index_Input, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Icon_Index_Pfeil, $GUI_HIDE)
		GUICtrlSetState($MiniEditor_Icon_Index_Label, $GUI_HIDE)

		Return
	EndIf

	_Minieditor_tab_select(-1)
	If $tab = 0 Then
	      if IsArray($Control_Editor_Allgemein_Tab) then _Tab_SetImage_with_Text($Control_Editor_Allgemein_Tab[1], $Tab_image_middle_active,0,_ISNPlugin_Get_langstring(139))
		GUICtrlSetState($MiniEditor_textmode_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Text, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Text_erweitert, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_text_Radio1_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Tooltip, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_ClickFunc, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_ChooseFunc, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_text_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_tooltip_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_func_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_tabpage_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Resize_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Resize_input, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Resize_punktebutton, $GUI_SHOW)
		GUICtrlSetData($MiniEditorX, GUICtrlRead($MiniEditorX)) ;fix anzeigebug
		GUICtrlSetData($MiniEditorY, GUICtrlRead($MiniEditorY))
	EndIf

	If $tab = 1 Then
	    if IsArray($Control_Editor_Darstellung_Tab) then _Tab_SetImage_with_Text($Control_Editor_Darstellung_Tab[1], $Tab_image_middle_active,0,_ISNPlugin_Get_langstring(140))
		GUICtrlSetState($MiniEditor_Schriftgroese, $GUI_SHOW)
		GUICtrlSetPos($MiniEditor_Schriftbreite, 129 * $DPI, 335 * $DPI, 162 * $DPI, 20 * $DPI)
		GUICtrlSetData($MiniEditor_Schriftbreite, GUICtrlRead($MiniEditor_Schriftbreite))
		GUICtrlSetPos($MiniEditor_Schriftgroese, 129 * $DPI, 305 * $DPI, 162 * $DPI, 20 * $DPI)
		GUICtrlSetData($MiniEditor_Schriftgroese, GUICtrlRead($MiniEditor_Schriftgroese))
		GUICtrlSetState($MiniEditor_GETBGButton, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_BGColourTrans, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_BGColour, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftartwahlen, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Textfarbe, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftart, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_IconPfad, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftartstyle, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftgroese, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftbreite, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt2, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt3, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt4, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Schriftartwahlenbt5, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_GetIconButton, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_breite_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_b_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_h_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_hintergrund_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_bild_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_schriftart_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_atribute_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_farbe_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_groesse_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_schriftbreite_label, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_IconPfeil1, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_IconPfeil2, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_IconPfeil3, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_IconPfeil4, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Icon_Index_Input, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Icon_Index_Pfeil, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_Icon_Index_Label, $GUI_SHOW)
	EndIf

	If $tab = 2 Then
	   if IsArray($Control_Editor_Style_Tab) then _Tab_SetImage_with_Text($Control_Editor_Style_Tab[1], $Tab_image_middle_active,0,_ISNPlugin_Get_langstring(96))
		GUICtrlSetState($minieditor_style_listview, $GUI_SHOW)
		GUICtrlSetState($minieditor_style, $GUI_SHOW)
	EndIf

	If $tab = 3 Then
	   if IsArray($Control_Editor_ExStyle_Tab) then _Tab_SetImage_with_Text($Control_Editor_ExStyle_Tab[1], $Tab_image_middle_active,0,_ISNPlugin_Get_langstring(141))
		GUICtrlSetState($minieditor_exstyle_listview, $GUI_SHOW)
		GUICtrlSetState($minieditor_exstyle, $GUI_SHOW)
	EndIf

	If $tab = 4 Then
	    if IsArray($Control_Editor_State_Tab) then _Tab_SetImage_with_Text($Control_Editor_State_Tab[1], $Tab_image_middle_active,0,_ISNPlugin_Get_langstring(142))
		GUICtrlSetState($minieditor_state_listview, $GUI_SHOW)
		GUICtrlSetState($MiniEditor_ControlState, $GUI_SHOW)
	EndIf
;	GUISetState(@SW_UNLOCK, $Formstudio_controleditor_GUI) ;gui wieder freigeben
	GUISwitch($GUI_Editor)
EndFunc   ;==>_Minieditor_tab_select







Func _Form_bearbeitenGUI_tab_select($tab = -1)
;	GUISetState(@SW_LOCK, $Form_bearbeitenGUI) ;Locke die GUI
	;ich hasse diese lösung...aber es geht leider nicht anders... :(
	If $tab = -1 Then
		GUICtrlSetState($Form_bearbeitenTitel_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenHandle_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenparentHandle_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenparentHandle_parrent_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenparentHandle_parrent_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenparentHandle_breite_label1, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenparentHandle_breite_label2, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenparentHandle_hoehe_label1, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenparentHandle_hoehe_label2, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenBGColour_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenBGColour_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenBGImage_button1, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenBGImage_button2, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitendeklarationen_labels, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenTitel, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenHandle, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenparentHandle, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenBreite, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenHoehe, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenBGColour, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenBGImage, $GUI_HIDE)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Keine_Radio, $GUI_HIDE)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Global_Radio, $GUI_HIDE)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Local_Radio, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenStyle, $GUI_HIDE)
		GUICtrlSetState($gui_setup_style_listview, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenExstyle, $GUI_HIDE)
		GUICtrlSetState($gui_setup_exstyle_listview, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_xpos_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_ypos_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_fenstertitel_radio1, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_fenstertitel_radio2, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_fenstertitel_pfeil, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_fenster_zentrieren_checkbox, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_xpos_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_ypos_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_konstanten_Variablen_checkbox, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_konstanten_MagicNumbers_checkbox, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_konstanten_Programmeinstellungen_checkbox, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_konstanten_label, $GUI_HIDE)
		GUICtrlSetState($Form_Eigenschaften_Include_Once_Checkbox, $GUI_HIDE)
		GUICtrlSetState($Form_Eigenschaften_Nur_Controls_in_die_isf_Checkbox, $GUI_HIDE)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_Deklarationen_pfeil, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_konstanten_Programmeinstellungen_pfeil, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_konstanten_MagicNumbers_pfeil, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_konstanten_Variablen_pfeil, $GUI_HIDE)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_Default_Radio, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenBreite, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeitenHoehe, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_ypos_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_xpos_input, $GUI_HIDE)
		ControlHide($Form_bearbeitenGUI,"",$Form_bearbeitenBreite_Updown)
		ControlHide($Form_bearbeitenGUI,"",$Form_bearbeitenHoehe_Updown)
		ControlHide($Form_bearbeitenGUI,"",$Form_bearbeiten_ypos_input_Updown)
		ControlHide($Form_bearbeitenGUI,"",$Form_bearbeiten_xpos_input_Updown)
		GUICtrlSetState($Form_bearbeiten_event_mousemove_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_close_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_minimize_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_restore_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_maximize_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_mousemove_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_primarydown_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_primaryup_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_secoundarydown_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_secoundaryup_input , $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_resized_input , $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_dropped_input, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_primarydown_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_close_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_minimize_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_restore_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_maximize_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_dropped_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_primaryup_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_secoundarydown_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_secoundaryup_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_resized_button, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_close_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_minimize_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_restore_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_maximize_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_primarydown_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_primaryup_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_secoundarydown_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_secoundaryup_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_resized_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_dropped_label, $GUI_HIDE)
		GUICtrlSetState($Form_bearbeiten_event_mousemove_label, $GUI_HIDE)


		Return
	EndIf

	_Form_bearbeitenGUI_tab_select(-1)
	If $tab = 0 Then

	    ControlShow($Form_bearbeitenGUI,"",$Form_bearbeitenBreite_Updown)
		ControlShow($Form_bearbeitenGUI,"",$Form_bearbeitenHoehe_Updown)
		ControlShow($Form_bearbeitenGUI,"",$Form_bearbeiten_ypos_input_Updown)
		ControlShow($Form_bearbeitenGUI,"",$Form_bearbeiten_xpos_input_Updown)
		GUICtrlSetState($Form_bearbeiten_xpos_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_ypos_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenTitel_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenHandle_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenparentHandle_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenparentHandle_parrent_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenparentHandle_parrent_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenparentHandle_breite_label1, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenparentHandle_breite_label2, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenparentHandle_hoehe_label1, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenparentHandle_hoehe_label2, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenBGColour_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenBGColour_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenBGImage_button1, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenBGImage_button2, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenTitel, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenHandle, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenparentHandle, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenBreite, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenHoehe, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenBGColour, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeitenBGImage, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_fenstertitel_radio1, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_fenstertitel_radio2, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_fenstertitel_pfeil, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_fenster_zentrieren_checkbox, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_xpos_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_ypos_label, $GUI_SHOW)
	EndIf

	If $tab = 1 Then
		GUICtrlSetState($Form_bearbeitendeklarationen_labels, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_konstanten_Variablen_checkbox, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_konstanten_MagicNumbers_checkbox, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_konstanten_Programmeinstellungen_checkbox, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_konstanten_label, $GUI_SHOW)
		GUICtrlSetState($Form_Eigenschaften_Include_Once_Checkbox, $GUI_SHOW)
		GUICtrlSetState($Form_Eigenschaften_Nur_Controls_in_die_isf_Checkbox, $GUI_SHOW)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Keine_Radio, $GUI_SHOW)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Global_Radio, $GUI_SHOW)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_Handles_Local_Radio, $GUI_SHOW)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_Deklarationen_pfeil, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_konstanten_Programmeinstellungen_pfeil, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_konstanten_MagicNumbers_pfeil, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_konstanten_Variablen_pfeil, $GUI_SHOW)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_Default_Radio, $GUI_SHOW)
	EndIf


	If $tab = 2 Then

		GUICtrlSetState($Form_bearbeiten_event_mousemove_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_close_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_minimize_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_restore_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_maximize_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_mousemove_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_primarydown_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_primaryup_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_secoundarydown_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_secoundaryup_input , $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_resized_input , $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_dropped_input, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_primarydown_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_close_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_minimize_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_restore_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_maximize_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_dropped_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_primaryup_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_secoundarydown_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_secoundaryup_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_resized_button, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_close_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_minimize_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_restore_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_maximize_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_primarydown_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_primaryup_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_secoundarydown_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_secoundaryup_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_resized_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_dropped_label, $GUI_SHOW)
		GUICtrlSetState($Form_bearbeiten_event_mousemove_label, $GUI_SHOW)

	EndIf




	If $tab = 3 Then
		GUICtrlSetState($Form_bearbeitenStyle, $GUI_SHOW)
		GUICtrlSetState($gui_setup_style_listview, $GUI_SHOW)
	EndIf

	If $tab = 4 Then
		GUICtrlSetState($Form_bearbeitenExstyle, $GUI_SHOW)
		GUICtrlSetState($gui_setup_exstyle_listview, $GUI_SHOW)
	EndIf
	;GUISetState(@SW_UNLOCK, $Form_bearbeitenGUI) ;gui wieder freigeben
EndFunc   ;==>_Form_bearbeitenGUI_tab_select

Func _GUIEigenschaften_toggle_zentriereGUI()
	If GUICtrlRead($Form_bearbeiten_fenster_zentrieren_checkbox) = $GUI_CHECKED Then
		GUICtrlSetData($Form_bearbeiten_xpos_input, "-1")
		GUICtrlSetData($Form_bearbeiten_ypos_input, "-1")
		GUICtrlSetState($Form_bearbeiten_xpos_input, $GUI_DISABLE)
		GUICtrlSetState($Form_bearbeiten_ypos_input, $GUI_DISABLE)
	Else
		GUICtrlSetData($Form_bearbeiten_xpos_input, _IniReadEx($Cache_Datei_Handle, "gui", "xpos", "0"))
		GUICtrlSetData($Form_bearbeiten_ypos_input, _IniReadEx($Cache_Datei_Handle, "gui", "ypos", "0"))
		GUICtrlSetState($Form_bearbeiten_xpos_input, $GUI_ENABLE)
		GUICtrlSetState($Form_bearbeiten_ypos_input, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_GUIEigenschaften_toggle_zentriereGUI


func _GUI_Settings_GUI_Events_get_func_button()
If $DEBUG = "true" Then Return ;Nicht im Debug ausführen!
$control = @GUI_CtrlId
	  GUISetState(@SW_DISABLE, $Form_bearbeitenGUI)
	_ISNPlugin_Nachricht_senden("listfuncs")
	$Nachricht = _ISNPlugin_Warte_auf_Nachricht($Mailslot_Handle, "listfuncsok", 90000000)
	  GUISetState(@SW_ENABLE, $Form_bearbeitenGUI)
	$data = _Pluginstring_get_element($Nachricht, 2)
	If $data = "" Then Return

switch $control
   case $Form_bearbeiten_event_close_button
	  GUICtrlSetData($Form_bearbeiten_event_close_input, $data)

   case $Form_bearbeiten_event_minimize_button
	  GUICtrlSetData($Form_bearbeiten_event_minimize_input, $data)

   case $Form_bearbeiten_event_restore_button
	  GUICtrlSetData($Form_bearbeiten_event_restore_input, $data)

   case $Form_bearbeiten_event_maximize_button
	  GUICtrlSetData($Form_bearbeiten_event_maximize_input, $data)

   case $Form_bearbeiten_event_mousemove_button
	  GUICtrlSetData($Form_bearbeiten_event_mousemove_input, $data)

   case $Form_bearbeiten_event_primarydown_button
	  GUICtrlSetData($Form_bearbeiten_event_primarydown_input, $data)

   case $Form_bearbeiten_event_primaryup_button
	  GUICtrlSetData($Form_bearbeiten_event_primaryup_input, $data)

   case $Form_bearbeiten_event_secoundarydown_button
	  GUICtrlSetData($Form_bearbeiten_event_secoundarydown_input, $data)

   case $Form_bearbeiten_event_secoundaryup_button
	  GUICtrlSetData($Form_bearbeiten_event_secoundaryup_input, $data)

   case $Form_bearbeiten_event_resized_button
	  GUICtrlSetData($Form_bearbeiten_event_resized_input, $data)

   case $Form_bearbeiten_event_dropped_button
	  GUICtrlSetData($Form_bearbeiten_event_dropped_input, $data)


EndSwitch

EndFunc


Func _Form_Eigenschaften_Deklaration_Handles_toggle_Radios()
	If GUICtrlRead($Form_Eigenschaften_Deklaration_Handles_Keine_Radio) = $GUI_CHECKED Or GUICtrlRead($Form_Eigenschaften_Deklaration_Default_Radio) = $GUI_CHECKED Then
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_DISABLE)
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_UNCHECKED)
		GUICtrlSetState($Form_bearbeiten_Deklarationen_pfeil, $GUI_DISABLE)
	Else
		GUICtrlSetState($Form_Eigenschaften_Deklaration_als_Const_Deklarieren, $GUI_ENABLE)
		GUICtrlSetState($Form_bearbeiten_Deklarationen_pfeil, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_Form_Eigenschaften_Deklaration_Handles_toggle_Radios


Func _GUIEigenschaften_toggle_Titelmodus()
	If GUICtrlRead($Form_bearbeiten_fenstertitel_radio1) = $GUI_CHECKED Then
	   if $Current_ISN_Skin = "dark theme" AND $Use_ISN_Skin = "true" then
		  GUICtrlSetBkColor($Form_bearbeitenTitel, $ISN_Hintergrundfarbe)
		  Else
		GUICtrlSetBkColor($Form_bearbeitenTitel, 0xFFFFFF)
		endif
	Else
		GUICtrlSetBkColor($Form_bearbeitenTitel, $Farbe_Func_Textmode)
	EndIf
EndFunc   ;==>_GUIEigenschaften_toggle_Titelmodus

Func _MiniEditor_Radio1_select()
	GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_CHECKED)
	GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_UNCHECKED)

   if $Current_ISN_Skin = "dark theme" AND $Use_ISN_Skin = "true" then
		GUICtrlSetBkColor($MiniEditor_Text, $ISN_Hintergrundfarbe)
		GUICtrlSetBkColor($MiniEditor_Tooltip, $ISN_Hintergrundfarbe)
		GUICtrlSetBkColor($MiniEditor_IconPfad, $ISN_Hintergrundfarbe)
	  else
	GUICtrlSetBkColor($MiniEditor_Text, 0xFFFFFF)
	GUICtrlSetBkColor($MiniEditor_Tooltip, 0xFFFFFF)
	GUICtrlSetBkColor($MiniEditor_IconPfad, 0xFFFFFF)
	  Endif
	If GUICtrlRead($MiniEditor_Controltype) = "listview" Then GUICtrlSetOnEvent($MiniEditor_Text_erweitert, "_Listview_Zeige_Spalteneditor")
EndFunc   ;==>_MiniEditor_Radio1_select

Func _MiniEditor_Radio2_select()
	GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_CHECKED)
	GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_UNCHECKED)
	GUICtrlSetBkColor($MiniEditor_Text, $Farbe_Func_Textmode)
	GUICtrlSetBkColor($MiniEditor_Tooltip, $Farbe_Func_Textmode)
	GUICtrlSetBkColor($MiniEditor_IconPfad, $Farbe_Func_Textmode)
	GUICtrlSetOnEvent($MiniEditor_Text_erweitert, "_Zeige_Erweiterten_Text")
EndFunc   ;==>_MiniEditor_Radio2_select



Func _Erstelle_Tabseite($Text,$x,$y)
$Textsize_array = _StringSize($Text,9)
if not IsArray($Textsize_array) then Return
local $Rueckgabe_Array[4]
GUISwitch($Formstudio_controleditor_GUI)

local $tab_top = GUICtrlCreatePic("",$x,$y,25*$DPI,14)
GUICtrlSetState(-1,$GUI_DISABLE)
_SetImage(-1, $Tab_image_top)

local $tab_middle = GUICtrlCreatepic("",$x,($y+14),25*$DPI,($Textsize_array[0]+2)*$DPI)
GUICtrlSetState(-1,$GUI_DISABLE)
_Tab_SetImage_with_Text(-1, $Tab_image_middle,0,$Text)

local $tab_middle_pos = ControlGetPos ($Formstudio_controleditor_GUI, "", $tab_middle)
GUICtrlSetState(-1,$GUI_DISABLE)
if not IsArray($tab_middle_pos) then Return

local $tab_bottom = GUICtrlCreatePic("",$x,($tab_middle_pos[1]+$tab_middle_pos[3]),25*$DPI,21)
GUICtrlSetState(-1,$GUI_DISABLE)
_SetImage(-1, $Tab_image_bottom)

local $tab_middle_clickpart = GUICtrlCreatePic("",($x+3),($y+14),25*$DPI,$Textsize_array[0])
GUICtrlSetCursor ($tab_middle_clickpart, 0)
GUICtrlSetState($tab_middle_clickpart, $GUI_ONTOP)


$Rueckgabe_Array[0] = $tab_top
$Rueckgabe_Array[1] = $tab_middle
$Rueckgabe_Array[2] = $tab_bottom
$Rueckgabe_Array[3] = $tab_middle_clickpart

return  $Rueckgabe_Array
EndFunc


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

; #FUNCTION# ================================================================
; Name...........: GDIPlus_SetAngledText
; Description ...: Adds text to a graphic object at any angle.
; Syntax.........: GDIPlus_SetAngledText($hGraphic, $nText, [$iCentreX, [$iCentreY, [$iAngle , [$nFontName , _
;                                       [$nFontSize, [$iARGB, [$iAnchor]]]]]]] )
; Parameters ....: $hGraphic   - The Graphics object to receive the added text.
;                  $nText      - Text string to be displayed
;                  $iCentreX       - Horizontal coordinate of horixontal centre of the text rectangle        (default =  0 )
;                  $iCentreY        - Vertical coordinate of vertical centre of the text rectangle             (default = 0 )
;                  $iAngle     - The angle which the text will be place in degrees.         (default = "" or blank = 0 )
;                  $nFontName  - The name of the font to be used                      (default = "" or Blank = "Arial" )
;                  $nFontSize  - The font size to be used                                  (default = "" or Blank = 12 )
;                  $iARGB      - Alpha(Transparency), Red, Green and Blue color (0xAARRGGBB) (Default= "" = random color
;                                                                                      or Default = Blank = 0xFFFF00FF )
;                  $iAnchor    - If zero (default) positioning $iCentreX, $iCentreY values refer to centre of text string.
;                                If not zero positioning $iCentreX, $iCentreY values refer to top left corner of text string.
; Return values .: 1
; Author ........: Malkey
; Modified.......:
; Remarks .......: Call _GDIPlus_Startup() before starting this function, and call _GDIPlus_Shutdown()after function ends.
;                  Can enter calculation for Angle Eg. For incline, -ATan($iVDist / $iHDist) * 180 / $iPI , where
;                  $iVDist is Vertical Distance,  $iHDist is Horizontal Distance, and, $iPI is Pi, (an added Global Const).
;                  When used with other graphics, call this function last. The MatrixRotate() may affect following graphics.
; Related .......: _GDIPlus_Startup(), _GDIPlus_Shutdown(), _GDIPlus_GraphicsDispose($hGraphic)
; Link ..........;
; Example .......; Yes
; ========================================================================================
Func GDIPlus_SetAngledText($hGraphic, $nText, $iCentreX = 0, $iCentreY = 0, $iAngle = 0, $nFontName = "Arial", _
        $nFontSize = 12, $iARGB = 0xFFFF00FF, $iAnchor = 0, $ISN_TabMode = 1)
    Local $x, $y, $iX, $iY, $iWidth, $iHeight
    Local $hMatrix, $iXt, $iYt, $hBrush, $hFormat, $hFamily, $hFont, $tLayout

    ; Default values
    If $iAngle = "" Then $iAngle = 0
    If $nFontName = "" Or $nFontName = -1 Then $nFontName = "Arial" ; "Microsoft Sans Serif"
    If $nFontSize = "" Then $nFontSize = 12
    If $iARGB = "" Then ; Randomize ARGB color
        $iARGB = "0xFF" & Hex(Random(0, 255, 1), 2) & Hex(Random(0, 255, 1), 2) & Hex(Random(0, 255, 1), 2)
    EndIf

    $hFormat = _GDIPlus_StringFormatCreate(0)
    $hFamily = _GDIPlus_FontFamilyCreate($nFontName)
    $hFont = _GDIPlus_FontCreate($hFamily, $nFontSize, 0, 3)
    $tLayout = _GDIPlus_RectFCreate($iCentreX, $iCentreY, 0, 0)
    $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $nText, $hFont, $tLayout, $hFormat)
    $iWidth = Ceiling(DllStructGetData($aInfo[0], "Width"))
    $iHeight = Ceiling(DllStructGetData($aInfo[0], "Height"))

    ;Later calculations based on centre of Text rectangle.
    If $iAnchor = 0 Then ; Reference to middle of Text rectangle
        $iX = $iCentreX
        $iY = $iCentreY
    Else ; Referenced centre point moved to top left corner of text string.
        $iX = $iCentreX + (($iWidth - Abs($iHeight * Sin($iAngle * $iPI / 180))) / 2)
		if $ISN_TabMode = 1 then $iX = 16*$DPI
        $iY = $iCentreY + (($iHeight + Abs($iWidth * Sin($iAngle * $iPI / 180))) / 2)
    EndIf

    ;Rotation Matrix
    $hMatrix = _GDIPlus_MatrixCreate()
    _GDIPlus_MatrixRotate($hMatrix, $iAngle, 1)
    _GDIPlus_GraphicsSetTransform($hGraphic, $hMatrix)

    ;x, y are display coordinates of center of width and height of the rectanglular text box.
    ;Top left corner coordinates rotate in a circular path with radius = (width of text box)/2.
    ;Parametric equations for a circle, and adjustments for centre of text box
    $x = ($iWidth / 2) * Cos($iAngle * $iPI / 180) - ($iHeight / 2) * Sin($iAngle * $iPI / 180)
    $y = ($iWidth / 2) * Sin($iAngle * $iPI / 180) + ($iHeight / 2) * Cos($iAngle * $iPI / 180)

    ;Rotation of Coordinate Axes formulae - To display at x and y after rotation, we need to enter the
    ;x an y position values of where they rotated from. This is done by rotating the coordinate axes.
    ;Use $iXt, $iYt in  _GDIPlus_RectFCreate. These x, y values is the position of the rectangular
    ;text box point before rotation. (before translation of the matrix)
    $iXt = ($iX - $x) * Cos($iAngle * $iPI / 180) + ($iY - $y) * Sin($iAngle * $iPI / 180)
    $iYt = -($iX - $x) * Sin($iAngle * $iPI / 180) + ($iY - $y) * Cos($iAngle * $iPI / 180)

    $hBrush = _GDIPlus_BrushCreateSolid($iARGB)
    $tLayout = _GDIPlus_RectFCreate($iXt, $iYt, $iWidth, $iHeight)
    _GDIPlus_GraphicsDrawStringEx($hGraphic, $nText, $hFont, $tLayout, $hFormat, $hBrush)

    ; Clean up resources
    _GDIPlus_MatrixDispose($hMatrix)
    _GDIPlus_FontDispose($hFont)
    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_StringFormatDispose($hFormat)
    _GDIPlus_BrushDispose($hBrush)
    $tLayout = ""
    Return 1
 EndFunc   ;==>GDIPlus_SetAngledText

Func _Tab_SetImage_with_Text($hWnd, $sImage, $hOverlap = 0,$Text="")

    if StringInStr($sImage,".jpg") Then
	  GUICtrlSetImage($hWnd,$sImage)
	  Return
    endif
	$hWnd = _Icons_Control_CheckHandle($hWnd)
	If $hWnd = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $Result, $hImage, $hBitmap, $hFit

	_GDIPlus_Startup()

	$hImage = _GDIPlus_BitmapCreateFromFile($sImage)
	$hFit = _Icons_Control_FitTo($hWnd, $hImage)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hFit)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hFit)

   if $ISN_Dark_Mode <> "true" then
    GDIPlus_SetAngledText($hGraphic, $Text, -3, -10,-90,"Arial",9,0xFF52565E,1)
	else
    GDIPlus_SetAngledText($hGraphic, $Text, -3, -10,-90,"Arial",9,0xFFDEDEDE,1)
   endif

    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hFit)
	_GDIPlus_ImageDispose($hFit)
	_GDIPlus_Shutdown()


	If Not ($hOverlap < 0) Then
		$hOverlap = _Icons_Control_CheckHandle($hOverlap)
	EndIf
	$Result = _Icons_Control_SetImage($hWnd, $hBitmap, $IMAGE_BITMAP, $hOverlap)
	If $Result Then
		$hImage = _SendMessage($hWnd, $__STM_GETIMAGE, $IMAGE_BITMAP, 0)
		If (@error) Or ($hBitmap = $hImage) Then
			$hBitmap = 0
		EndIf
	EndIf
	If $hBitmap Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	Return SetError(1 - $Result, 0, $Result)
 EndFunc

func _coursor_ist_ueber_Tabseiten()
$Cursor_INFO_Control_Editor = GUIGetCursorInfo($Formstudio_controleditor_GUI)
if IsArray($Cursor_INFO_Control_Editor) Then
if $Cursor_INFO_Control_Editor[4] = $Control_Editor_Style_Tab[3] then return true
if $Cursor_INFO_Control_Editor[4] = $Control_Editor_ExStyle_Tab[3] then return true
if $Cursor_INFO_Control_Editor[4] = $Control_Editor_State_Tab[3] then return true
if $Cursor_INFO_Control_Editor[4] = $Control_Editor_Allgemein_Tab[3] then return true
if $Cursor_INFO_Control_Editor[4] = $Control_Editor_Darstellung_Tab[3] then return true

EndIf
return false
endfunc




;Zum umschalten der Tabseiten im Control Editor bei gedrückter STRG-Taste
Func _Mousewheel($hWnd,$iMsg, $iwParam, $ilParam)
    #forceref $hwnd, $iMsg, $ilParam
	If _IsPressed("11", $dll) OR _coursor_ist_ueber_Tabseiten() then
        Local $iDelta = BitShift($iwParam, 16)
        If $iDelta > 0 Then  _Minieditor_vorherige_seite()
        If $iDelta < 0 Then  _Minieditor_naechste_seite()
    Endif
  Return $GUI_RUNDEFMSG
EndFunc


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	$nID = BitAND($iwParam, 0x0000FFFF)
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
	Switch $iCode

		Case $LVN_BEGINDRAG
			If $nID = $Toolbox_listview Then
				MouseUp("primary")
				AdlibRegister("_Make_Control_from_toolbox", 0) ;Geniale Idee um den komischen Drag&Drop Mauszeiger zu vermeiden :P
			EndIf

		Case $TVN_SELCHANGEDW
			If $nID = $menueditor_treeview Then
				_Menu_Editor_Eintrag_waehlen() ;...und wähle dann neues Element
			EndIf

	    Case $LVN_COLUMNCLICK
			Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
			Local $iCol = DllStructGetData($tInfo, "SubItem")
		   If $nID = $control_reihenfolge_GUI_listview Then _Listview_Sortieren($control_reihenfolge_GUI_listview,$iCol)



		Case $NM_CLICK

			If WinActive($ExtracodeGUI) Then AdlibRegister("_Code_generieren_Tab_Event")
			If $nID = $menueditor_treeview Then
				Local $tPOINT = _WinAPI_GetMousePos(True, $hWndFrom)
				Local $iX = DllStructGetData($tPOINT, "X")
				Local $iY = DllStructGetData($tPOINT, "Y")
				Local $hItem = _GUICtrlTreeView_HitTestItem($hWndFrom, $iX, $iY)
				If $hItem <> 0 Then
					_Menu_Editor_uebernehmen(1) ;Speichere zuvor aktuelle Daten...
					_GUICtrlTreeView_SelectItem($hWndFrom, $hItem, $TVGN_CARET)
					_GUICtrlTreeView_SelectItem($menueditor_treeview, $hItem)
					_Menu_Editor_Eintrag_waehlen() ;...und wähle dann neues Element

				EndIf
			EndIf

			If $nID = $minieditor_style_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($minieditor_style_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($minieditor_style_listview, $Item, 0)
						EndIf
						_Rebuild_Stylestring()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_Stylestring(1, $Item)
				EndSwitch
			EndIf

			If $nID = $minieditor_state_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($minieditor_state_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($minieditor_state_listview, $Item, 0)
						EndIf
						_Rebuild_Statestring()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_Statestring(1, $Item)
				EndSwitch
			EndIf

			If $nID = $minieditor_exstyle_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($minieditor_exstyle_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($minieditor_exstyle_listview, $Item, 0)
						EndIf
						_Rebuild_exstylestring()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_exstylestring(1, $Item)
				EndSwitch
			EndIf


			If $nID = $gui_setup_style_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($gui_setup_style_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($gui_setup_style_listview, $Item, 0)
						EndIf
						_Rebuild_Stylestring_for_GUI()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_Stylestring_for_GUI(1, $Item)
				EndSwitch
			EndIf


			If $nID = $gui_setup_exstyle_listview Then
				Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				Local $Item = DllStructGetData($tInfo, "Index")
				If @error Or $Item = -1 Then Return $GUI_RUNDEFMSG

				Local $tTest = DllStructCreate($tagLVHITTESTINFO)
				DllStructSetData($tTest, "X", DllStructGetData($tInfo, "X"))
				DllStructSetData($tTest, "Y", DllStructGetData($tInfo, "Y"))
				Local $iRet = GUICtrlSendMsg($iIDFrom, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
				If @error Or $iRet = -1 Then Return $GUI_RUNDEFMSG
				Switch DllStructGetData($tTest, "Flags")
					Case $LVHT_ONITEMICON, $LVHT_ONITEMLABEL, $LVHT_ONITEM
						If _GUICtrlListView_GetItemChecked($gui_setup_exstyle_listview, $Item) = False Then
							_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, 1)
						Else
							_GUICtrlListView_SetItemChecked($gui_setup_exstyle_listview, $Item, 0)
						EndIf
						_Rebuild_ExStylestring_for_GUI()
					Case $LVHT_ONITEMSTATEICON ;on checkbox
						_Rebuild_ExStylestring_for_GUI(1, $Item)
				EndSwitch
			EndIf




		Case $NM_RCLICK
			If $nID = $Toolbox_listview Then _Make_Control_from_toolbox()
			If $nID = $menueditor_treeview Then
				Local $tPOINT = _WinAPI_GetMousePos(True, $hWndFrom)
				Local $iX = DllStructGetData($tPOINT, "X")
				Local $iY = DllStructGetData($tPOINT, "Y")
				Local $hItem = _GUICtrlTreeView_HitTestItem($hWndFrom, $iX, $iY)
;~ 					If $hItem <> 0 Then
				_GUICtrlTreeView_SelectItem($hWndFrom, $hItem, $TVGN_CARET)
				_GUICtrlTreeView_SelectItem($menueditor_treeview, $hItem)
				_Menu_Editor_Eintrag_waehlen()
				_GUICtrlMenu_TrackPopupMenu($menueditor_treeviewmenu_Handle, $menueditorGUI)
			EndIf

		Case $NM_DBLCLK
			If $nID = $Toolbox_listview Then _Make_Control_from_toolbox()
			If $nID = $ControlList Then
				If _GUICtrlListView_GetItemText($ControlList, _GUICtrlListView_GetSelectionMark($ControlList), 2) = "tab" Then
					Markiere_Control($TABCONTROL_ID)
				Else
					$tabpagee = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle(_GUICtrlListView_GetItemText($ControlList, _GUICtrlListView_GetSelectionMark($ControlList), 3)), "tabpage", "-1")
					If $tabpagee > -1 Then _GUICtrlTab_SetCurFocus(GUICtrlGetHandle($TABCONTROL_ID), Number($tabpagee))
					;Markiere_Control(_GUICtrlListView_GetItemText($ControlList, _GUICtrlListView_GetSelectionMark($ControlList),3))
					_Mark_by_Handle(_GUICtrlListView_GetItemText($ControlList, _GUICtrlListView_GetSelectionMark($ControlList), 3))
				EndIf
				_GUICtrlListView_SetItemSelected($ControlList, _GUICtrlListView_GetSelectionMark($ControlList), True, True)
			EndIf



	EndSwitch


	Return $GUI_RUNDEFMSG
 EndFunc   ;==>WM_NOTIFY



Func _Pruefe_auf_doppelklick()
    if $Control_Markiert_MULTI = 1 then return
    if $Markiertes_Control_ID = 0 then return
    Local $time
    If $clicked Then
        $time = TimerDiff($timer)
    EndIf
    Select
        Case $time > $dblClickTime
            $timer = TimerInit()
            Return
        Case Not $clicked
            $clicked = True
            $timer = TimerInit()
        Case Else
            $clicked = False
			_Control_doubleClick_Event()
    EndSelect
EndFunc


func _Control_doubleClick_Event()
   switch $FormStudio_doubleclick_action
		 case "extracode"
			if $Control_Markiert_MULTI <> 0 then return
			If $Markiertes_Control_ID <> "" Then _Show_Extracode()

		 case "copy"
			if $Control_Markiert_MULTI = 0 AND $Markiertes_Control_ID = "" then return
			copy_item()

		 case "grid"
			if $Control_Markiert_MULTI = 0 AND $Markiertes_Control_ID = "" then return
			_Am_Raster_Ausrichten()

   EndSwitch
EndFunc


Func _Elemente_an_Fesntergroesse_anpassen()
   ;Reihenfolge der Controls
	$control_reihenfolge_GUI_listview_listview_Pos_Array = ControlGetPos($control_reihenfolge_GUI, "", $control_reihenfolge_GUI_listview)
	If Not IsArray($control_reihenfolge_GUI_listview_listview_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($control_reihenfolge_GUI_listview, 0, 30)
	_GUICtrlListView_SetColumnWidth($control_reihenfolge_GUI_listview, 1, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 15)
	_GUICtrlListView_SetColumnWidth($control_reihenfolge_GUI_listview, 2, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 45)
	_GUICtrlListView_SetColumnWidth($control_reihenfolge_GUI_listview, 3, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 30)

   ;Liste aller Controls im Control Editor
	$ControlList_Pos_Array = ControlGetPos($Formstudio_controleditor_GUI, "", $ControlList)
	If Not IsArray($ControlList_Pos_Array) Then Return
	_GUICtrlListView_SetColumnWidth($ControlList, 0, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 20)
	_GUICtrlListView_SetColumnWidth($ControlList, 1, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 20)
	_GUICtrlListView_SetColumnWidth($ControlList, 2, ($control_reihenfolge_GUI_listview_listview_Pos_Array[2] / 100) * 15)


endfunc



Func _Code_GUI_Resize()
	Local $ExtracodeGUI_clientsize = WinGetClientSize($ExtracodeGUI)
	If IsArray($ExtracodeGUI_clientsize) Then WinMove($sci, "", 10*$DPI, 75*$DPI, $ExtracodeGUI_clientsize[0] - ((12 + 10)*$DPI), $ExtracodeGUI_clientsize[1] - ((60 + 76)*$DPI))
EndFunc   ;==>_Makro_Codeausschnitt_GUI_Resize

Func _Form_bearbeitenGUI_Resize()
	Local $Form_bearbeitenGUI_clientsize = WinGetClientSize($Form_bearbeitenGUI)
	If IsArray($Form_bearbeitenGUI_clientsize) Then WinMove($gui_setup_tab, "", 10*$DPI, 60*$DPI, $Form_bearbeitenGUI_clientsize[0] - ((10 + 5)*$DPI), $Form_bearbeitenGUI_clientsize[1] - ((60 + 57)*$DPI))
EndFunc


Func _Menu_Editor_Resize()
	Local $menueditor_vorschau_group_pos = ControlGetPos($menueditorGUI,"",$menueditor_vorschau_group)
	If IsArray($menueditor_vorschau_group_pos) Then WinMove($menueditor_vorschauGUI, "", $menueditor_vorschau_group_pos[0]+5, $menueditor_vorschau_group_pos[1]+17,$menueditor_vorschau_group_pos[2]-10,$menueditor_vorschau_group_pos[3]-23)
	EndFunc

Func _Handle_mit_Dollar_zurueckgeben($handle = "")
   if $handle = "" then return ""
	$handle = StringStripWS($handle,3)
	$handle = StringReplace($handle,"$$","")
	$handle = StringReplace($handle,"$$$","")
	$handle = StringReplace($handle,"$$$$","")
   if stringleft($handle,1) <> "$" then
	  return "$"&$handle
   else
	return $handle
   Endif
EndFunc