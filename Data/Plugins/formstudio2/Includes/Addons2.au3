;----------------------------------------------
;Addons2.au3 for ISN AutoIT Form-Studio by ISI360
;----------------------------------------------
Func _Update_Control_Cache_for_Tab($dummy, $type = "#look#")
	If $TABCONTROL_ID = "" Then Return
	If $dummy = $TABCONTROL_ID Then Return

	If $type = "#look#" Then
		If $dummy = $TABCONTROL_ID Then
			$read = _IniReadEx($Cache_Datei_Handle, "tab", "type", "error")
			$dummy = $TABCONTROL_ID
		Else
			$read = _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "type", "error")
		EndIf
		If $read = "error" Then
			MsgBox(16, "Error", _ISNPlugin_Get_langstring(44))
		Else
			$type = $read
		EndIf
	EndIf

	$tabid = _GUICtrlTab_GetCurSel($TABCONTROL_ID)
	_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tabpage", $tabid)

EndFunc   ;==>_Update_Control_Cache_for_Tab



Func _Update_Control_Cache($dummy, $type = "#look#")
	ToolTip("")
	If $type = "#look#" Then
		If $dummy = $TABCONTROL_ID Then
			$read = _IniReadEx($Cache_Datei_Handle, "tab", "type", "error")
			$dummy = $TABCONTROL_ID
		Else
			$read = _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "type", "error")
		EndIf
		If $read = "error" Then
			MsgBox(16, "Error", _ISNPlugin_Get_langstring(44))
		Else
			$type = $read
		EndIf
	EndIf


	GUICtrlSetResizing($dummy, $GUI_DOCKALL)
	_IniWriteEx($Cache_Datei_Handle, "gui", "title", _IniReadEx($Cache_Datei_Handle, "gui", "title", "Form1"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "breite", _IniReadEx($Cache_Datei_Handle, "gui", "breite", "640"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "hoehe", _IniReadEx($Cache_Datei_Handle, "gui", "hoehe", "480"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "style", _IniReadEx($Cache_Datei_Handle, "gui", "style", "-1"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "exstyle", _IniReadEx($Cache_Datei_Handle, "gui", "exstyle", "-1"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "bgcolour", _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "0xFFFFFF"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "bgimage", _IniReadEx($Cache_Datei_Handle, "gui", "bgimage", "none"))
	_IniWriteEx($Cache_Datei_Handle, "gui", "handle", _IniReadEx($Cache_Datei_Handle, "gui", "handle", "hgui"))

	_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
	_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "locked", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "locked", 0)) ;locked bei jedem control!
	_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "resize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "resize", "")) ;resize bei jedem control!


	If $type = "softbutton" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "code", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "code", 'DllCall("user32.dll", "UINT", "SendMessage", "handle", GUICtrlGetHandle($control_handle), "UINT", $BCM_SETNOTE, "ptr*", 0, "wstr", "You can edit this text/icon under Extracode!")[BREAK]DllCall("user32.dll", "UINT", "SendMessage", "handle", GUICtrlGetHandle($control_handle), "UINT", $BCM_SETSHIELD, "ptr*", 0, "BOOL",false)'))
	Else
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "code", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "code", "")) ;Code bei jedem Control!
	EndIf

	If $type = "button" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "button")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "label" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "label")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", "-2"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf


	If $type = "input" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "input")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", "$WS_EX_CLIENTEDGE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "checkbox" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "checkbox")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", GUICtrlRead($dummy, 1))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "")))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "radio" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "radio")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", GUICtrlRead($dummy, 1))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "")))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "image" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "image")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf


	If $type = "slider" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "slider")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf


	If $type = "progress" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "progress")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf


	If $type = "updown" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "updown")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", "$WS_EX_CLIENTEDGE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "icon" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "icon")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "combo" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "combo")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", "Mein Text"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "edit" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "edit")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "group" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "group")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, "gui", "bgcolour", "")))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf



	If $type = "listbox" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "listbox")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", "$WS_EX_CLIENTEDGE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf


	If $type = "dummy" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "dummy")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "graphic" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "graphic")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	 EndIf


	If $type = "tab" Then
		_IniWriteEx($Cache_Datei_Handle, "tab", "type", "tab")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, "tab", "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, "tab", "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, "tab", "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, "tab", "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, "tab", "text", "")
		_IniWriteEx($Cache_Datei_Handle, "tab", "tooltip", _IniReadEx($Cache_Datei_Handle, "tab", "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, "tab", "pages", _GUICtrlTab_GetItemCount($TABCONTROL_ID))
		_IniWriteEx($Cache_Datei_Handle, "tab", "state", _IniReadEx($Cache_Datei_Handle, "tab", "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, "tab", "style", _IniReadEx($Cache_Datei_Handle, "tab", "style", ""))
		_IniWriteEx($Cache_Datei_Handle, "tab", "exstyle", _IniReadEx($Cache_Datei_Handle, "tab", "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, "tab", "textcolour", _IniReadEx($Cache_Datei_Handle, "tab", "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, "tab", "bgcolour", _IniReadEx($Cache_Datei_Handle, "tab", "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, "tab", "font", _IniReadEx($Cache_Datei_Handle, "tab", "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, "tab", "fontsize", _IniReadEx($Cache_Datei_Handle, "tab", "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, "tab", "fontstyle", _IniReadEx($Cache_Datei_Handle, "tab", "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, "tab", "fontattribute", _IniReadEx($Cache_Datei_Handle, "tab", "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, "tab", "id", _IniReadEx($Cache_Datei_Handle, "tab", "id", "tab"))
		_IniWriteEx($Cache_Datei_Handle, "tab", "func", _IniReadEx($Cache_Datei_Handle, "tab", "func", ""))
		_IniWriteEx($Cache_Datei_Handle, "tab", "bgimage", _IniReadEx($Cache_Datei_Handle, "tab", "bgimage", ""))

		_IniWriteEx($Cache_Datei_Handle, "tab", "handle", $dummy) ;aktuelles handle bei jedem control!
		_IniWriteEx($Cache_Datei_Handle, "tab", "code", _IniReadEx($Cache_Datei_Handle, "tab", "code", "")) ;Code bei jedem Control!

		;Create Pages in Cache
		If _GUICtrlTab_GetItemCount($TABCONTROL_ID) > 0 Then
			$Tabs = _GUICtrlTab_GetItemCount($TABCONTROL_ID)

			While $Tabs > 0
				_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $Tabs, "page", $Tabs)
				_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $Tabs, "text", _GUICtrlTab_GetItemText($TABCONTROL_ID, $Tabs - 1))
				$Tabs = $Tabs - 1
			WEnd
		EndIf
	EndIf



	If $type = "date" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "date")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "calendar" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "calendar")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", "$WS_EX_CLIENTEDGE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "listview" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "listview")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])


		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", "$WS_EX_CLIENTEDGE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf


	If $type = "softbutton" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "softbutton")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", "$BS_COMMANDLINK"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf


	If $type = "ip" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "ip")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", "$WS_EX_CLIENTEDGE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", "ip" & Random(0, 100, 1)))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "treeview" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "treeview")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", "")
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", "$WS_EX_CLIENTEDGE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "menu" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "menu")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf

	If $type = "com" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "com")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", "obj" & Random(0, 100, 1)))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	 EndIf

	  If $type = "graphic" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "graphic")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", "$GUI_SHOW+$GUI_ENABLE"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	 EndIf

   If $type = "toolbar" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "toolbar")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", "$TBSTYLE_FLAT"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", "toolbar"& Random(0, 100, 1)))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	 EndIf

	  If $type = "statusbar" Then
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "type", "statusbar")
		$pos = ControlGetPos($GUI_Editor, "", $dummy)
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "x", $pos[0])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "y", $pos[1])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "width", $pos[2])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "height", $pos[3])
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "text", StringReplace(GUICtrlRead($dummy), @CRLF, "[BREAK]"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tooltip", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "state", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "style", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "exstyle", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "textcolour", "0x000000"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgcolour", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "font", "MS Sans Serif"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontsize", "8"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontstyle", "400"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "fontattribute", "0"))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "func", ""))
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "bgimage", ""))
	EndIf
EndFunc   ;==>_Update_Control_Cache



;__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
Func _Mini_Editor_Einstellungen_Uebernehmen_Multi()
	If $Control_Markiert_MULTI = 0 Then Return
	If Not IsArray($Markierte_Controls_IDs) Then Return
	If Not IsArray($Markierte_Controls_Sections) Then Return

;~ _ArrayDisplay($Markierte_Controls_Sections)

	For $u = 0 To $Markierte_Controls_IDs[0]
		If $Markierte_Controls_Sections[$u] = "" Then ContinueLoop
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "locked", "0") = 1 Then ContinueLoop ;Gelockte Controls ignorieren
		$control_type = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "type", "")
		$control = _WinAPI_GetDlgCtrlID($Markierte_Controls_Sections[$u])
		If $Markierte_Controls_Sections[$u] = "tab" Then $control = $TABCONTROL_ID
		If $control_type = "menu" Then ContinueLoop ;Einige Controls Ignorieren
		If $control_type = "toolbar" Then ContinueLoop ;Einige Controls Ignorieren
		If $control_type = "statusbar" Then ContinueLoop ;Einige Controls Ignorieren


	  $Text_fuer_control = GUICtrlRead($MiniEditor_Text)
	  If StringInStr($Text_fuer_control, '"') Then
	   $Text_fuer_control = StringReplace(GUICtrlRead($MiniEditor_Text), '"', "'")
	  endif

		If GUICtrlRead($MiniEditor_Text) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "text", $Text_fuer_control)
		If GUICtrlRead($MiniEditorX) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "x", GUICtrlRead($MiniEditorX))
		If GUICtrlRead($MiniEditorY) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "y", GUICtrlRead($MiniEditorY))
		If GUICtrlRead($MiniEditor_breite) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "width", GUICtrlRead($MiniEditor_breite))
		If GUICtrlRead($MiniEditor_hoehe) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "height", GUICtrlRead($MiniEditor_hoehe))
		If GUICtrlRead($MiniEditor_ClickFunc) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "func", GUICtrlRead($MiniEditor_ClickFunc))
		If GUICtrlRead($MiniEditor_Resize_input) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "resize", GUICtrlRead($MiniEditor_Resize_input))
		If GUICtrlRead($MiniEditor_Textfarbe) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "textcolour", GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "bgcolour", GUICtrlRead($MiniEditor_BGColour))
		If GUICtrlRead($MiniEditor_Schriftart) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "font", GUICtrlRead($MiniEditor_Schriftart))
		If GUICtrlRead($MiniEditor_Schriftbreite) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontstyle", GUICtrlRead($MiniEditor_Schriftbreite))
		If GUICtrlRead($MiniEditor_Schriftartstyle) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontattribute", GUICtrlRead($MiniEditor_Schriftartstyle))
		If GUICtrlRead($MiniEditor_Schriftgroese) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontsize", GUICtrlRead($MiniEditor_Schriftgroese))
		If GUICtrlRead($MiniEditor_Tooltip) <> "" Then _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "tooltip", GUICtrlRead($MiniEditor_Tooltip))

		If GUICtrlRead($MiniEditor_Text_Radio1) = $GUI_CHECKED OR GUICtrlRead($MiniEditor_Text_Radio2) = $GUI_CHECKED Then
		   If GUICtrlRead($MiniEditor_Text_Radio1) = $GUI_CHECKED Then
		  _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "textmode", "text")
		  else
		  _IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "textmode", "func")
		  endif
	    endif


		If GUICtrlRead($MiniEditor_Tabpagecombo) <> "" And $Markierte_Controls_Sections[$u] <> "tab" Then
			$tabpage = GUICtrlRead($MiniEditor_Tabpagecombo)
			If $tabpage = _ISNPlugin_Get_langstring(63) Then $tabpage = "-1"
			If $tabpage <> "-1" Then $tabpage = $tabpage - 1
			_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "tabpage", $tabpage)
		EndIf


		;Control Anpassen
		If $control_type <> "menu" And $control_type <> "com" Then GUICtrlSetData($control, StringReplace(_IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "text", ""), "[BREAK]", @CRLF))
		GUICtrlSetPos($control, _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "x", 0), _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "y", 0), _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "width", 0), _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "height", 0))
		If $control_type <> "button" And $control_type <> "menu" And $control_type <> "softbutton" And $control_type <> "com" Then GUICtrlSetColor($control, _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "textcolour", 0x000000))
		If $control_type <> "button" And $control_type <> "menu" And $control_type <> "softbutton" And $control_type <> "com" And _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "bgcolour", "") <> "" Then GUICtrlSetBkColor($control, _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "bgcolour", ""))
		If $control_type <> "menu" And $control_type <> "softbutton" And $control_type <> "com" Then GUICtrlSetFont($control, _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontsize", "8"), _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontstyle", "400"), _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontattribute", "0"), _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "font", ""))
		If $control_type <> "menu" And $control_type <> "softbutton" And $control_type <> "com" Then _Control_Add_ToolTip($control, _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "tooltip", ""))

		;Rahmen aktualisieren
		If $Markierte_Controls_Sections[$u] = "tab" Then
			_Aktualisiere_Rahmen_Multi($u, $TABCONTROL_ID)
		Else
			_Aktualisiere_Rahmen_Multi($u, _WinAPI_GetDlgCtrlID($Markierte_Controls_Sections[$u]))
		EndIf
	Next

	;Prüfe zum schluss ob Änderungen an Tabseiten vorgenommen wurden
	If $TABCONTROL_ID <> "" Then
		$tabpage = GUICtrlRead($MiniEditor_Tabpagecombo)
		If $tabpage = _ISNPlugin_Get_langstring(63) Then $tabpage = "-1"
		If $tabpage <> "-1" Then $tabpage = $tabpage - 1
		If $Buffer_tabpage <> $tabpage And GUICtrlRead($MiniEditor_Tabpagecombo) <> "" Then
			$filebackup = $AktuelleForm_Speicherdatei

			;Cache Datei niederschreiben
			_IniCloseFileEx($Cache_Datei_Handle)
			_IniCloseFileEx($Cache_Datei_Handle2)
			$Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
			$Cache_Datei_Handle2 = _IniOpenFile($Cache_Datei2)

			FileCopy($Cache_Datei, $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf", 9)
			_Load_from_file($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf")
			FileDelete($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf")
			$AktuelleForm_Speicherdatei = $filebackup
			$Control_Markiert_MULTI = 0
		EndIf
	EndIf

EndFunc   ;==>_Mini_Editor_Einstellungen_Uebernehmen_Multi




Func _Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
	If $Control_Markiert_MULTI = 0 Then Return
	If Not IsArray($Markierte_Controls_IDs) Then Return
	If Not IsArray($Markierte_Controls_Sections) Then Return
	GUICtrlSetState($MiniEditor_Uebernehmen_Button, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Weitere_Aktionen_Button, $GUI_ENABLE)



	;Controls vergleichen

	Local $Control_Section = $Markierte_Controls_Sections[0]
	If $Control_Section = "tab" Then $Control_Section = $Markierte_Controls_Sections[1]

	Local $Buffer_Text = _IniReadEx($Cache_Datei_Handle, $Control_Section, "text", "")
	Local $Buffer_TextMode = _IniReadEx($Cache_Datei_Handle, $Control_Section, "textmode", "text")
	Local $Buffer_X = _IniReadEx($Cache_Datei_Handle, $Control_Section, "x", "0")
	Local $Buffer_Y = _IniReadEx($Cache_Datei_Handle, $Control_Section, "y", "0")
	Local $Buffer_Height = _IniReadEx($Cache_Datei_Handle, $Control_Section, "height", "0")
	Local $Buffer_width = _IniReadEx($Cache_Datei_Handle, $Control_Section, "width", "0")
	Local $Buffer_Tooltip = _IniReadEx($Cache_Datei_Handle, $Control_Section, "tooltip", "")
	Local $Buffer_Func = _IniReadEx($Cache_Datei_Handle, $Control_Section, "func", "")
	Local $Buffer_Resize = _IniReadEx($Cache_Datei_Handle, $Control_Section, "resize", "")
	Local $Buffer_Font = _IniReadEx($Cache_Datei_Handle, $Control_Section, "font", "")
	Local $Buffer_Fontattribute = _IniReadEx($Cache_Datei_Handle, $Control_Section, "fontattribute", "")
	Local $Buffer_textcolour = _IniReadEx($Cache_Datei_Handle, $Control_Section, "textcolour", "")
	Local $Buffer_fontsize = _IniReadEx($Cache_Datei_Handle, $Control_Section, "fontsize", "")
	Local $Buffer_fontstyle = _IniReadEx($Cache_Datei_Handle, $Control_Section, "fontstyle", "")
	Local $Buffer_bgcolour = _IniReadEx($Cache_Datei_Handle, $Control_Section, "bgcolour", "")
	Local $Buffer_locked = _IniReadEx($Cache_Datei_Handle, $Control_Section, "locked", "0")
	$Buffer_tabpage = _IniReadEx($Cache_Datei_Handle, $Control_Section, "tabpage", "-1")
	For $u = 0 To $Markierte_Controls_IDs[0]-1
		If $Markierte_Controls_Sections[$u] = "" Then ContinueLoop
		If $Buffer_locked <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "locked", "0") Then $Buffer_locked = ""
		If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "locked", "0") = 1 Then ContinueLoop ;Gelockte Controls ignorieren
		$control_type = _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "type", "")
		If $control_type = "menu" Then ContinueLoop ;Einige Controls Ignorieren
		If $control_type = "toolbar" Then ContinueLoop ;Einige Controls Ignorieren
		If $control_type = "statusbar" Then ContinueLoop ;Einige Controls Ignorieren

		If $Buffer_Text <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "text", "") Then $Buffer_Text = ""
		If $Buffer_TextMode <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "textmode", "text") Then $Buffer_TextMode = ""
		If $Buffer_X <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "x", "0") Then $Buffer_X = ""
		If $Buffer_Y <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "y", "0") Then $Buffer_Y = ""
		If $Buffer_Height <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "height", "0") Then $Buffer_Height = ""
		If $Buffer_width <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "width", "0") Then $Buffer_width = ""
		If $Buffer_Tooltip <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "tooltip", "0") Then $Buffer_Tooltip = ""
		If $Buffer_Func <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "func", "") Then $Buffer_Func = ""
		If $Buffer_Resize <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "resize", "") Then $Buffer_Resize = ""
		If $Buffer_Font <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "font", "") Then $Buffer_Font = ""
		If $Buffer_Fontattribute <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontattribute", "") Then $Buffer_Fontattribute = ""
		If $Buffer_textcolour <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "textcolour", "") Then $Buffer_textcolour = ""
		If $Buffer_fontsize <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontsize", "") Then $Buffer_fontsize = ""
		If $Buffer_fontstyle <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "fontstyle", "") Then $Buffer_fontstyle = ""
		If $Markierte_Controls_Sections[$u] <> "tab" And $Buffer_tabpage <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "tabpage", "-1") Then $Buffer_tabpage = ""
		If $Buffer_bgcolour <> _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "bgcolour", "") Then $Buffer_bgcolour = ""


	Next

   ;Alle Controls gelocked
   Local $Alles_gelocked = 1
   For $u = 0 To $Markierte_Controls_IDs[0]-1
	  If $Markierte_Controls_Sections[$u] = "" Then ContinueLoop
	  If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$u], "locked", "0") = 0 Then $Alles_gelocked = 0
   next

   if $Alles_gelocked = 1 Then
	 $Buffer_Text = ""
	 $Buffer_TextMode = ""
	 $Buffer_X = ""
	 $Buffer_Y =""
	 $Buffer_Height = ""
	 $Buffer_width = ""
	 $Buffer_Tooltip = ""
	 $Buffer_Func = ""
	 $Buffer_Resize = ""
	 $Buffer_Font = ""
	 $Buffer_Fontattribute = ""
	 $Buffer_textcolour = ""
	 $Buffer_fontsize = ""
	 $Buffer_fontstyle = ""
	$Buffer_bgcolour = ""
	$Buffer_locked =""
	$Buffer_tabpage =""
   EndIf


	;Text
	GUICtrlSetData($MiniEditor_Text, $Buffer_Text)
	GUICtrlSetState($MiniEditor_Text, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_erweitert, $GUI_ENABLE)

	;Text Mode
	GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_unChecked)
	GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_unChecked)
	GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio1_label, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Text_Radio2_label, $GUI_ENABLE)
	  if $Current_ISN_Skin = "dark theme" AND $Use_ISN_Skin = "true" then
		GUICtrlSetBkColor($MiniEditor_Text, $ISN_Hintergrundfarbe)
		GUICtrlSetBkColor($MiniEditor_Tooltip, $ISN_Hintergrundfarbe)
		GUICtrlSetBkColor($MiniEditor_IconPfad, $ISN_Hintergrundfarbe)
	  else
		GUICtrlSetBkColor($MiniEditor_Text, 0xFFFFFF)
		GUICtrlSetBkColor($MiniEditor_Tooltip, 0xFFFFFF)
		GUICtrlSetBkColor($MiniEditor_IconPfad, 0xFFFFFF)
	  Endif
	Switch $Buffer_TextMode

		Case "text"
			GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_Checked)
			GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_unChecked)

		Case "func"
			GUICtrlSetState($MiniEditor_Text_Radio2, $GUI_Checked)
			GUICtrlSetState($MiniEditor_Text_Radio1, $GUI_unChecked)
			GUICtrlSetBkColor($MiniEditor_Text, $Farbe_Func_Textmode)
			GUICtrlSetBkColor($MiniEditor_Tooltip, $Farbe_Func_Textmode)
			GUICtrlSetBkColor($MiniEditor_IconPfad, $Farbe_Func_Textmode)
	EndSwitch


	;X
	GUICtrlSetData($MiniEditorX, $Buffer_X)
	GUICtrlSetState($MiniEditorX, $GUI_ENABLE)

	;Y
	GUICtrlSetData($MiniEditorY, $Buffer_Y)
	GUICtrlSetState($MiniEditorY, $GUI_ENABLE)

	;Breite
	GUICtrlSetData($MiniEditor_breite, $Buffer_width)
	GUICtrlSetState($MiniEditor_breite, $GUI_ENABLE)

	;Höhe
	GUICtrlSetData($MiniEditor_hoehe, $Buffer_Height)
	GUICtrlSetState($MiniEditor_hoehe, $GUI_ENABLE)

	;ToolTip
	GUICtrlSetData($MiniEditor_Tooltip, $Buffer_Tooltip)
	GUICtrlSetState($MiniEditor_Tooltip, $GUI_ENABLE)

	;Func
	GUICtrlSetData($MiniEditor_ClickFunc, $Buffer_Func)
	GUICtrlSetState($MiniEditor_ClickFunc, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_ChooseFunc, $GUI_ENABLE)

	;Resize
	GUICtrlSetData($MiniEditor_Resize_input, $Buffer_Resize)
	GUICtrlSetState($MiniEditor_Resize_input, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Resize_punktebutton, $GUI_ENABLE)

	;Font
	GUICtrlSetData($MiniEditor_Schriftart, $Buffer_Font)
	GUICtrlSetState($MiniEditor_Schriftart, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlen, $GUI_ENABLE)

	;Fontattribute
	GUICtrlSetData($MiniEditor_Schriftartstyle, $Buffer_Fontattribute)
	GUICtrlSetState($MiniEditor_Schriftartstyle, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlenbt2, $GUI_ENABLE)

	;Textcolour
	GUICtrlSetData($MiniEditor_Textfarbe, $Buffer_textcolour)
	GUICtrlSetBkColor($MiniEditor_BGColour, 0xFFFFFF)
	If $Buffer_textcolour <> "" Then
		GUICtrlSetBkColor($MiniEditor_Textfarbe, $Buffer_textcolour)
		GUICtrlSetColor($MiniEditor_Textfarbe, _ColourInvert(Execute($Buffer_textcolour)))
	EndIf
	GUICtrlSetState($MiniEditor_Textfarbe, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlenbt3, $GUI_ENABLE)

	;Fontsize
	GUICtrlSetData($MiniEditor_Schriftgroese, $Buffer_fontsize)
	GUICtrlSetState($MiniEditor_Schriftgroese, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlenbt4, $GUI_ENABLE)

	;fontstyle (Breite)
	GUICtrlSetData($MiniEditor_Schriftbreite, $Buffer_fontstyle)
	GUICtrlSetState($MiniEditor_Schriftbreite, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_Schriftartwahlenbt5, $GUI_ENABLE)

	;bgcolour
	GUICtrlSetData($MiniEditor_BGColour, $Buffer_bgcolour)
	GUICtrlSetBkColor($MiniEditor_BGColour, 0xFFFFFF)
	If $Buffer_bgcolour <> "" Then
		GUICtrlSetBkColor($MiniEditor_BGColour, $Buffer_bgcolour)
		GUICtrlSetColor($MiniEditor_BGColour, _ColourInvert(Execute($Buffer_bgcolour)))
	EndIf
	GUICtrlSetState($MiniEditor_BGColour, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_GETBGButton, $GUI_ENABLE)
	GUICtrlSetState($MiniEditor_BGColourTrans, $GUI_ENABLE)

    ;Locked
	GUICtrlSetState($MiniEditor_lock_Button, $GUI_ENABLE)
   	If $Buffer_locked = "1" Then
	  If $Current_ISN_Skin <> "#none#" AND $Use_ISN_Skin = "true" Then
	   _SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1816 + 1, 16, 16)
	  Else
	  Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1816,4)
	  endif
	  $Control_Lock_Status_Multi = "1"
   EndIf
   If $Buffer_locked = "0" Then
	  	  If $Current_ISN_Skin <> "#none#" AND $Use_ISN_Skin = "true" Then
	   _SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1828 + 1, 16, 16)
	  Else
	  Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1828,4)
	  endif
	  $Control_Lock_Status_Multi = "0"
   EndIf
    If $Buffer_locked = "" Then
	  If $Current_ISN_Skin <> "#none#" AND $Use_ISN_Skin = "true" Then
	   _SetIconAlpha($MiniEditor_lock_Button, $smallIconsdll, 1922 + 1, 16, 16)
	  Else
	  Button_AddIcon($MiniEditor_lock_Button, $smallIconsdll, 1922,4)
	  endif
	  $Control_Lock_Status_Multi = ""
   EndIf


	;Tabseiten
	If $TABCONTROL_ID <> "" Then
		GUICtrlSetState($MiniEditor_Tabpagecombo, $GUI_ENABLE)
		GUICtrlSetData($MiniEditor_Tabpagecombo, "")
		;Make Pages
		$pages = _IniReadEx($Cache_Datei_Handle, "tab", "pages", "0")
		$page = 1
		$str = _ISNPlugin_Get_langstring(63) & "|"
		While $page < $pages + 1
			$str = $str & $page & "|"
			$page = $page + 1
		WEnd
		$x = $Buffer_tabpage
		If $Buffer_tabpage <> "" Then
			If $x = "-1" Then
				$x = _ISNPlugin_Get_langstring(63)
			Else
				$x = $x + 1
			EndIf
		EndIf
		GUICtrlSetData($MiniEditor_Tabpagecombo, $str, $x)
	EndIf
EndFunc   ;==>_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren






Func _Mini_Editor_Einstellungen_Uebernehmen()
	If $Control_Markiert_MULTI = 1 Then
		_Mini_Editor_Einstellungen_Uebernehmen_Multi()
		Return
	EndIf


	If $Markiertes_Control_ID = "" Then Return
	If _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "locked", 0) = 1 Then Return
	$dummy = $Markiertes_Control_ID
	$pos = ControlGetPos($GUI_Editor, "", $dummy)





	$Testmode = 3
	;Keine Leerzeichen in der ID ;)
	$new_ID = StringReplace(GUICtrlRead($MiniEditor_ControlID), " ", "_", 0, 0)
	GUICtrlSetData($MiniEditor_ControlID, $new_ID)
	;End

	;Kein Leerer State
;~ if guictrlread($MiniEditor_ControlState) = "" then guictrlsetdata($MiniEditor_ControlState,"$GUI_SHOW+$GUI_ENABLE")
	;end

	;Keine Lerzeichen u.s.w in der ID
	If GUICtrlRead($MiniEditor_ControlID) = "" And GUICtrlRead($MiniEditor_Controltype) = "tab" Then GUICtrlSetData($MiniEditor_ControlID, "tab") ;Tab MUSS eine ID haben
	If GUICtrlRead($MiniEditor_ControlID) = "" And GUICtrlRead($MiniEditor_Controltype) = "toolbar" Then GUICtrlSetData($MiniEditor_ControlID, "toolbar"& Random(0, 100, 1)) ;Toolbar MUSS eine ID haben
	If GUICtrlRead($MiniEditor_ControlID) = "" And GUICtrlRead($MiniEditor_Controltype) = "ip" Then GUICtrlSetData($MiniEditor_ControlID, "ip" & Random(0, 100, 1)) ;IP-Adressenfeld MUSS eine ID haben
	If GUICtrlRead($MiniEditor_ControlID) = "" And GUICtrlRead($MiniEditor_Controltype) = "com" Then GUICtrlSetData($MiniEditor_ControlID, "obj" & Random(0, 100, 1)) ;COM-Objekt MUSS eine ID haben
    $Text_fuer_control = GUICtrlRead($MiniEditor_Text)
	If StringInStr($Text_fuer_control, '"') Then
	   $Text_fuer_control = StringReplace(GUICtrlRead($MiniEditor_Text), '"', "'")
	   GUICtrlSetData($MiniEditor_Text, $Text_fuer_control)
    endif



	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), " ", "_"))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "?", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "!", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "/", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "\", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "'", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), '"', ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "|", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "-", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), ".", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), ":", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), ";", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), ",", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "<", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), ">", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "(", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), ")", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "&", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "%", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "§", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "=", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "^", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "°", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "$$", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "$$$", ""))
	GUICtrlSetData($MiniEditor_ControlID, StringReplace(GUICtrlRead($MiniEditor_ControlID), "$$$$", ""))
	if GUICtrlRead($MiniEditor_ControlID) <> "" And StringLeft(GUICtrlRead($MiniEditor_ControlID),1) <> "$" then GUICtrlSetData($MiniEditor_ControlID, "$"&GUICtrlRead($MiniEditor_ControlID))


	GUICtrlSetBkColor($MiniEditor_Textfarbe, GUICtrlRead($MiniEditor_Textfarbe))
	GUICtrlSetColor($MiniEditor_Textfarbe, _ColourInvert(Execute(GUICtrlRead($MiniEditor_Textfarbe))))

	If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($MiniEditor_BGColour, GUICtrlRead($MiniEditor_BGColour))
	If GUICtrlRead($MiniEditor_BGColour) <> "-2" Then
		GUICtrlSetColor($MiniEditor_BGColour, _ColourInvert(Execute(GUICtrlRead($MiniEditor_BGColour))))
	Else
		GUICtrlSetColor($MiniEditor_BGColour, 0x000000)
	EndIf
	;end


	If $Markiertes_Control_ID = $TABCONTROL_ID Then
		$section = "tab"
	Else
		$section = GUICtrlGetHandle($dummy)
	EndIf

	$oldtappage = _IniReadEx($Cache_Datei_Handle, $section, "tabpage", "-1")
	$towrite = GUICtrlRead($MiniEditor_Tabpagecombo)
	If $towrite = "" Then $towrite = "-1"
	If $towrite = _ISNPlugin_Get_langstring(63) Then $towrite = "-1"
	If $towrite <> "-1" Then $towrite = $towrite - 1

	_IniWriteEx($Cache_Datei_Handle, $section, "tabpage", $towrite)
	_IniWriteEx($Cache_Datei_Handle, $section, "x", GUICtrlRead($MiniEditorX))
	_IniWriteEx($Cache_Datei_Handle, $section, "y", GUICtrlRead($MiniEditorY))
	_IniWriteEx($Cache_Datei_Handle, $section, "width", GUICtrlRead($MiniEditor_breite))
	_IniWriteEx($Cache_Datei_Handle, $section, "height", GUICtrlRead($MiniEditor_hoehe))
	_IniWriteEx($Cache_Datei_Handle, $section, "text", $Text_fuer_control)
	_IniWriteEx($Cache_Datei_Handle, $section, "tooltip", GUICtrlRead($MiniEditor_Tooltip))
	_IniWriteEx($Cache_Datei_Handle, $section, "state", GUICtrlRead($MiniEditor_ControlState))
	_IniWriteEx($Cache_Datei_Handle, $section, "style", GUICtrlRead($MiniEditor_Style))
	_IniWriteEx($Cache_Datei_Handle, $section, "exstyle", GUICtrlRead($MiniEditor_ExStyle))
	_IniWriteEx($Cache_Datei_Handle, $section, "textcolour", GUICtrlRead($MiniEditor_Textfarbe))
	_IniWriteEx($Cache_Datei_Handle, $section, "bgcolour", GUICtrlRead($MiniEditor_BGColour))
	_IniWriteEx($Cache_Datei_Handle, $section, "font", GUICtrlRead($MiniEditor_Schriftart))
	_IniWriteEx($Cache_Datei_Handle, $section, "fontsize", GUICtrlRead($MiniEditor_Schriftgroese))
	_IniWriteEx($Cache_Datei_Handle, $section, "fontattribute", GUICtrlRead($MiniEditor_Schriftartstyle))
	_IniWriteEx($Cache_Datei_Handle, $section, "fontstyle", GUICtrlRead($MiniEditor_Schriftbreite))
	_IniWriteEx($Cache_Datei_Handle, $section, "id", GUICtrlRead($MiniEditor_ControlID))
	_IniWriteEx($Cache_Datei_Handle, $section, "func", GUICtrlRead($MiniEditor_ClickFunc))
	_IniWriteEx($Cache_Datei_Handle, $section, "bgimage", GUICtrlRead($MiniEditor_IconPfad))
	_IniWriteEx($Cache_Datei_Handle, $section, "iconindex", GUICtrlRead($MiniEditor_Icon_Index_Input))
	_IniWriteEx($Cache_Datei_Handle, $section, "resize", GUICtrlRead($MiniEditor_Resize_input))


	If GUICtrlRead($MiniEditor_Text_Radio1) = $GUI_CHECKED Then
		_IniWriteEx($Cache_Datei_Handle, $section, "textmode", "text")
	Else
		_IniWriteEx($Cache_Datei_Handle, $section, "textmode", "func")
	EndIf



	If GUICtrlRead($MiniEditor_Controltype) = "button" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute(Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetImage($dummy, _Return_Workdir() & GUICtrlRead($MiniEditor_IconPfad), Number(GUICtrlRead($MiniEditor_Icon_Index_Input)))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
		If GUICtrlRead($MiniEditor_IconPfad) = "" Then
			_SendMessage(GUICtrlGetHandle($dummy), $BM_SETIMAGE, $IMAGE_ICON, 0)
		Else
			GUICtrlSetImage($dummy, _Return_Workdir(GUICtrlRead($MiniEditor_IconPfad)) & GUICtrlRead($MiniEditor_IconPfad), Number(GUICtrlRead($MiniEditor_Icon_Index_Input)))
		EndIf
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "label" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Label + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "input" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_input + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "checkbox" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Checkbox + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
		If GUICtrlRead($MiniEditor_IconPfad) = "" Then
			_SendMessage(GUICtrlGetHandle($dummy), $BM_SETIMAGE, $IMAGE_ICON, 0)
		Else
			GUICtrlSetImage($dummy, _Return_Workdir(GUICtrlRead($MiniEditor_IconPfad)) & GUICtrlRead($MiniEditor_IconPfad), Number(GUICtrlRead($MiniEditor_Icon_Index_Input)))
		EndIf
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "radio" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Radio + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "image" Then
		If GUICtrlRead($MiniEditor_IconPfad) = "" Then
			GUICtrlSetImage($dummy, @ScriptDir & "\data\dummy.jpg")
		Else
			GUICtrlSetImage($dummy, _Return_Workdir(GUICtrlRead($MiniEditor_IconPfad)) & GUICtrlRead($MiniEditor_IconPfad), Number(GUICtrlRead($MiniEditor_Icon_Index_Input)))
		EndIf

		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Image + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "slider" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Slider + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "progress" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Progress + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "updown" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_input + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "icon" Then
		If GUICtrlRead($MiniEditor_IconPfad) = "" Then
			GUICtrlSetImage($dummy, @ScriptDir & "\data\dummy.ico")
		Else
			GUICtrlSetImage($dummy, _Return_Workdir(GUICtrlRead($MiniEditor_IconPfad)) & GUICtrlRead($MiniEditor_IconPfad), Number(GUICtrlRead($MiniEditor_Icon_Index_Input)))
		EndIf


		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Icon + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "combo" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_combo + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "edit" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Edit + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "group" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_Group + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "listbox" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_listbox + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "tab" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_tab + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "date" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_date + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "calendar" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_calendar + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "listview" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_listview + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "softbutton" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_softbutton + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetImage($dummy, _Return_Workdir() & GUICtrlRead($MiniEditor_IconPfad))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "ip" Then
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_ip + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "treeview" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetData($dummy, StringReplace(GUICtrlRead($MiniEditor_Text), "[BREAK]", @CRLF))
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		GUICtrlSetColor($dummy, GUICtrlRead($MiniEditor_Textfarbe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute($Default_treeview + Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "menu" OR GUICtrlRead($MiniEditor_Controltype) = "dummy" OR GUICtrlRead($MiniEditor_Controltype) = "graphic" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute(Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	EndIf

	If GUICtrlRead($MiniEditor_Controltype) = "com" Then
		GUICtrlSetData($dummy, "")
		GUICtrlSetPos($dummy, GUICtrlRead($MiniEditorX), GUICtrlRead($MiniEditorY), GUICtrlRead($MiniEditor_breite), GUICtrlRead($MiniEditor_hoehe))
		If GUICtrlRead($MiniEditor_BGColour) <> "" Then GUICtrlSetBkColor($dummy, GUICtrlRead($MiniEditor_BGColour))
		GUICtrlSetFont($dummy, GUICtrlRead($MiniEditor_Schriftgroese), GUICtrlRead($MiniEditor_Schriftbreite), GUICtrlRead($MiniEditor_Schriftartstyle), GUICtrlRead($MiniEditor_Schriftart))
		GUICtrlSetStyle($dummy, Execute(Execute(GUICtrlRead($MiniEditor_Style))), Execute(Execute(GUICtrlRead($MiniEditor_ExStyle))))
		GUICtrlSetState($dummy, Execute(GUICtrlRead($MiniEditor_ControlState)))
		_Control_Add_ToolTip($dummy, GUICtrlRead($MiniEditor_Tooltip))
	 EndIf


	;Apply Extracode
	If _IniReadEx($Cache_Datei_Handle, $section, "code", "") <> "" AND GUICtrlRead($MiniEditor_Controltype) <> "tab" Then
		$red = _IniReadEx($Cache_Datei_Handle, $section, "code", "")
		$red = StringReplace($red, "$control_handle", _IniReadEx($Cache_Datei_Handle, $section, "handle", ""))
		$data_array = StringSplit($red, "[BREAK]", 1)
		If IsArray($data_array) AND $Extracode_beim_Designen_Ignorieren = 0 Then
			For $r = 1 To $data_array[0]
			   if StringInStr($data_array[$r],"guictrldelete") then ContinueLoop
				Execute($data_array[$r])
			Next
		EndIf
	EndIf


	If GUICtrlRead($MiniEditor_Controltype) = "tab" Then _Resize_tabcontent($pos[0], $pos[1])
	If GUICtrlRead($MiniEditor_Controltype) = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $pos[0], $pos[1], $pos[2], $pos[3])
	_Update_ControlList($dummy)
	;WinActivate($GUI_Editor)
	;GUISwitch ( $GUI_Editor )
	_Aktualisiere_Rahmen()

	ToolTip("")
	If $oldtappage <> $towrite Then
		If GUICtrlRead($MiniEditor_Controltype) = "group" Then _Controls_in_Group_auf_Tab_verschieben($dummy, $oldtappage, $towrite) ;Controls im Group mitverschieben
		$filebackup = $AktuelleForm_Speicherdatei

		   ;Cache Datei niederschreiben
			_IniCloseFileEx($Cache_Datei_Handle)
			_IniCloseFileEx($Cache_Datei_Handle2)
			$Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
			$Cache_Datei_Handle2 = _IniOpenFile($Cache_Datei2)

		FileCopy($Cache_Datei, $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf", 9)
		_Load_from_file($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf")
		FileDelete($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\temp.isf")
		$AktuelleForm_Speicherdatei = $filebackup
	EndIf

EndFunc   ;==>_Mini_Editor_Einstellungen_Uebernehmen


;__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

Func WM_MOVE($hWnd, $Msg, $wParam, $lParam)

	$pos_formeditorfenster_inside = WinGetPos($Studiofenster_inside)
	$pos_formeditorfenster_inside_client = WinGetClientSize($Studiofenster_inside)
;~ 	$hoehe_des_Controleditors = 724
;~ 	$size_studiofenster = WinGetClientSize($studiofenster)
;~ 	if $size_studiofenster[1] < $hoehe_des_Controleditors  then $hoehe_des_Controleditors=405
	If IsArray($pos_formeditorfenster_inside) Then
		If $Control_Editor_ist_zusammengeklappt = 0 Then
			_WinAPI_SetWindowPos($Formstudio_controleditor_GUI, $HWND_TOP, $pos_formeditorfenster_inside[2] - ($breite_des_Controleditors+25), 7, $breite_des_Controleditors, $hoehe_des_Controleditors, $SWP_NOACTIVATE)
		Else
			_WinAPI_SetWindowPos($Formstudio_controleditor_GUI, $HWND_TOP, $pos_formeditorfenster_inside[2] - ($breite_des_Controleditors+25), 7, $breite_des_Controleditors, $Hoehe_Control_Editor_zusammengeklappt, $SWP_NOACTIVATE)
		EndIf
	EndIf
EndFunc   ;==>WM_MOVE


Func _Load_from_file($Datei)
   Local $file = _IniOpenFile($Datei)
	$AktuelleForm_Speicherdatei = $Datei
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ControlList))
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($ControlList))
   _IniCloseFileEx($Cache_Datei_Handle)
   _IniCloseFileEx($Cache_Datei_Handle2)
	FileDelete($Cache_Datei)
	FileDelete($Cache_Datei2)
	if not FileExists($Cache_Datei) then _Leere_INI_Datei_erstellen($Cache_Datei)
    if not FileExists($Cache_Datei2) then _Leere_INI_Datei_erstellen($Cache_Datei2)
	$Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
    $Cache_Datei_Handle2 = _IniOpenFile($Cache_Datei2)

	Entferne_Makierung()


	$THERE_IS_A_TAB = 0
	If Not _FileReadToArray($Datei, $aRecords) Then
		Return
	 EndIf
	For $x = 1 To $aRecords[0]
		If StringInStr($aRecords[$x], "type=tab") > 0 Then $THERE_IS_A_TAB = 1
	Next

	$var = _IniReadSectionNamesEx($file)
	$anzahl = 0

	If @error Then
		MsgBox(16, _ISNPlugin_Get_langstring(48), "Die Datei " & $Datei & " kann nicht gelesen werden!")
	Else
		For $i = 1 To $var[0]
			$anzahl = $anzahl + 1
		Next
	EndIf


	$var = _IniReadSectionNamesEx($file)


	If @error Then
		MsgBox(16, _ISNPlugin_Get_langstring(48), "Die Datei " & $Datei & " kann nicht gelesen werden!")
	Else

		GUISetState(@SW_HIDE, $Form_bearbeitenGUI)
		GUISetState(@SW_HIDE, $Formstudio_controleditor_GUI)
		GUISetState(@SW_HIDE, $GUI_Editor)
		_Destroy_Editor()

	    GUISwitch($Studiofenster)
		$GUI_Editor = GUICreate(_IniReadEx($file, "gui", "title", "Form1"), _IniReadEx($file, "gui", "breite", 640), _IniReadEx($file, "gui", "hoehe", 480), 8000, 8000, BitOR($WS_CAPTION, $WS_POPUP, $WS_SIZEBOX))
		GUISwitch($GUI_Editor) ;VMWare Bugfix
		If $Draw_grid_in_gui = "1" Then _DrawGrid($Raster, $Grid_Farbe)

		GUIRegisterMsg($WM_MOVE, 'WM_MOVE')
		GUIRegisterMsg($WM_SIZE, "_Editor_Resize_WM")

		If _IniReadEx($file, "gui", "bgimage", "none") = "none" Then GUISetBkColor(_IniReadEx($file, "gui", "bgcolour", 0xF0F0F0))
;~ $hChild = GUICreate("", 1, 1, -900, -900, $WS_POPUP, $WS_EX_MDICHILD, $GUI_Editor)
		GUISetOnEvent($GUI_EVENT_RESIZED, "_Update_GUI", $GUI_Editor)
		_WinAPI_SetParent($GUI_Editor, $StudioFenster_inside)

;~ $nExStyle = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", $GUI_Editor, "int", 0xEC)
;~ DllCall("user32.dll", "int", "SetWindowLong", "hwnd", $GUI_Editor, "int", 0xEC, "int", BitOR($nExStyle[0], $WS_EX_MDICHILD))
;~ DllCall("user32.dll", "int", "SetParent", "hwnd", $GUI_Editor, "hwnd", $StudioFenster_inside)



		If _IniReadEx($file, "gui", "bgimage", "none") = "none" Then
			;sleep(0)
		Else
			$Testmode = 3
			If FileExists(_Return_Workdir(_IniReadEx($file, "gui", "bgimage", "")) & _IniReadEx($file, "gui", "bgimage", "none")) = 0 Then MsgBox(262160, _ISNPlugin_Get_langstring(48), StringReplace(_ISNPlugin_Get_langstring(176), "%1", _IniReadEx($file, "gui", "bgimage", "none")), 0, $Studiofenster)
			Global $BGimage = GUICtrlCreatePic(_Return_Workdir(_IniReadEx($file, "gui", "bgimage", "")) & _IniReadEx($file, "gui", "bgimage", "none"), 0, 0, _IniReadEx($file, "gui", "breite", 640), _IniReadEx($file, "gui", "hoehe", 480), $WS_CLIPSIBLINGS)
;~ GuiCtrlSetState($BGimage,$GUI_ONTOP)
			GUICtrlSetState($BGimage, $GUI_DISABLE)
			_IniWriteEx($Cache_Datei_Handle, "gui", "bgimage", _IniReadEx($file, "gui", "bgimage", "none"))
		EndIf



		;Apply Extracode for GUI
		If _IniReadEx($file, "gui", "code", "") <> "" Then
			$red = _IniReadEx($file, "gui", "code", "")
			$red = StringReplace($red, "$gui_handle", $GUI_Editor)
			$data_array = StringSplit($red, "[BREAK]", 1)
			$string = ""
			If IsArray($data_array) AND $Extracode_beim_Designen_Ignorieren = 0 Then
				For $r = 1 To $data_array[0]
					Execute($data_array[$r])
				Next
			EndIf
		EndIf



		;TAB-------------------------------------------------------------------------
		If $THERE_IS_A_TAB = 1 Then
			$varT = _IniReadSectionNamesEx($file)
			If @error Then
				;sleep(0)
			Else
				For $r = 1 To $varT[0]

					If _IniReadEx($file, $varT[$r], "type", "") = "tab" Then

						$dummy = GUICtrlCreateTab(_IniReadEx($file, "tab", "x", 0), _IniReadEx($file, "tab", "y", 0), _IniReadEx($file, "tab", "width", 0), _IniReadEx($file, "tab", "height", 0))
						GUICtrlSetState($dummy, $GUI_ONTOP)
						$TABCONTROL_ID = $dummy
						_Control_Add_ToolTip($dummy, _IniReadEx($file, "tab", "tooltip", ""))
						GUICtrlSetState($dummy, _IniReadEx($file, "tab", "state", ""))
						GUICtrlSetColor($dummy, _IniReadEx($file, "tab", "textcolour", ""))
						GUICtrlSetBkColor($dummy, _IniReadEx($file, "tab", "bgcolour", ""))
						GUICtrlSetStyle($dummy, Execute($Default_tab + Execute(_IniReadEx($file, "tab", "style", ""))), Execute(_IniReadEx($file, "tab", "exstyle", "")))
						GUICtrlSetFont($dummy, _IniReadEx($file, "tab", "fontsize", ""), _IniReadEx($file, "tab", "fontstyle", ""), _IniReadEx($file, "tab", "fontattribute", ""), _IniReadEx($file, "tab", "font", ""))
						GUICtrlSetState($dummy, Execute(_IniReadEx($file, "tab", "state", "")))
						$aData1 = _IniReadSectionEx($file, "tab")
						_IniWriteSectionEx($Cache_Datei_Handle, "tab", $aData1)
						_IniWriteEx($Cache_Datei_Handle, "tab", "handle", $dummy) ;aktuelles handle bei jedem control!
						;_ControlID_to_Cache2( Guictrlgethandle($dummy),$dummy)
						GUICtrlSetResizing($dummy, $GUI_DOCKALL)

						;Make Pages
						$pages = _IniReadEx($file, $varT[$r], "pages", "0")

						$u = 1
						While $u < $pages + 1
							_GUICtrlTab_InsertItem($dummy, _IniReadEx($file, "TABPAGE" & $u, "page", "#error#") - 1, _IniReadEx($file, "TABPAGE" & $u, "text", "#error#"))
							$u = $u + 1
						WEnd
						_GUICtrlTab_SetCurFocus($TABCONTROL_ID, -1)
						;_Update_Control_Cache($dummy,"tab")
						_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
						_SetStatustext(_ISNPlugin_Get_langstring(89) & " (tab, ID:" & GUICtrlGetHandle($dummy) & ")")
						_IniWriteEx($Cache_Datei_Handle, "tab", "handle", $dummy) ;aktuelles handle bei jedem control!
						_IniWriteEx($Cache_Datei_Handle, "tab", "code", _IniReadEx($Cache_Datei_Handle, "tab", "code", "")) ;Code bei jedem Control!
						_IniWriteEx($Cache_Datei_Handle, "tab", "order", _IniReadEx($Cache_Datei_Handle, "tab", "order", "0")) ;Order bei jedem Control!
						_IniWriteEx($Cache_Datei_Handle, "tab", "resize", _IniReadEx($Cache_Datei_Handle, "tab", "resize", "")) ;Resize

						;Create Pages in Cache
						If _GUICtrlTab_GetItemCount($TABCONTROL_ID) > 0 Then
							$Tabs = _GUICtrlTab_GetItemCount($TABCONTROL_ID)

							While $Tabs > 0
								_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $Tabs, "page", $Tabs)
								_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $Tabs, "text", _GUICtrlTab_GetItemText($TABCONTROL_ID, $Tabs - 1))
								_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $Tabs, "textmode", _IniReadEx($file, "TABPAGE" & $Tabs, "textmode", "text"))
								_IniWriteEx($Cache_Datei_Handle, "TABPAGE" & $Tabs, "handle", _IniReadEx($file, "TABPAGE" & $Tabs, "handle", ""))
								$Tabs = $Tabs - 1
							WEnd
						EndIf



						GUISetState()


					EndIf


				Next

			EndIf

		EndIf




		;UpdateCache

		_IniWriteEx($Cache_Datei_Handle, "gui", "Handle_deklaration", _IniReadEx($file, "gui", "Handle_deklaration", "default"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "Handle_deklaration_const", _IniReadEx($file, "gui", "Handle_deklaration_const", "default"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "title", _IniReadEx($file, "gui", "title", "Form1"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "breite", _IniReadEx($file, "gui", "breite", "640"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "hoehe", _IniReadEx($file, "gui", "hoehe", "480"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "style", _IniReadEx($file, "gui", "style", "-1"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "exstyle", _IniReadEx($file, "gui", "exstyle", "-1"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "bgcolour", _IniReadEx($file, "gui", "bgcolour", "0xF0F0F0"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "bgimage", _IniReadEx($file, "gui", "bgimage", "none"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "handle", _IniReadEx($file, "gui", "handle", "hgui"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "parent", _IniReadEx($file, "gui", "parent", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "code", _IniReadEx($file, "gui", "code", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "codebeforegui", _IniReadEx($file, "gui", "codebeforegui", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "xpos", _IniReadEx($file, "gui", "xpos", "-1"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "ypos", _IniReadEx($file, "gui", "ypos", "-1"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "center_gui", _IniReadEx($file, "gui", "center_gui", "true"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "title_textmode", _IniReadEx($file, "gui", "title_textmode", "normal"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "isf_include_once", _IniReadEx($file, "gui", "isf_include_once", "false"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "only_controls_in_isf", _IniReadEx($file, "gui", "only_controls_in_isf", "false"))
		_IniWriteEx($Cache_Datei_Handle, "gui", "const_modus", _IniReadEx($file, "gui", "const_modus", "default"))



		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_close", _IniReadEx($file, "gui", "gui_event_close", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_minimize", _IniReadEx($file, "gui", "gui_event_minimize", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_restore", _IniReadEx($file, "gui", "gui_event_restore", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_maximize", _IniReadEx($file, "gui", "gui_event_maximize", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_mousemove", _IniReadEx($file, "gui", "gui_event_mousemove", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_primarydown", _IniReadEx($file, "gui", "gui_event_primarydown", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_primaryup", _IniReadEx($file, "gui", "gui_event_primaryup", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_secoundarydown", _IniReadEx($file, "gui", "gui_event_secoundarydown", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_secoundaryup", _IniReadEx($file, "gui", "gui_event_secoundaryup", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_resized", _IniReadEx($file, "gui", "gui_event_resized", ""))
		_IniWriteEx($Cache_Datei_Handle, "gui", "gui_event_dropped", _IniReadEx($file, "gui", "gui_event_dropped", ""))
		;End
		;GUISetOnEvent ( $GUI_EVENT_SECONDARYDOWN, "Entferne_Makierung" , $GUI_Editor )






		GUICtrlSetState($StudioFenster_inside_Text1, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_Text2, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_Icon, $GUI_SHOW)
		GUICtrlSetState($StudioFenster_inside_load, $GUI_SHOW)




		$to_add_Pro_Element = 110 / ($anzahl)
		$fortschritt = 0 ; 0 %
		GUICtrlSetData($StudioFenster_inside_load, $fortschritt)

;~ 		WinActivate($GUI_Editor)
		GUISwitch($GUI_Editor)
		$var = _IniReadSectionNamesEx($file)

		For $i = 1 To $var[0]

			$type = _IniReadEx($file, $var[$i], "type", "#error#")


			If $THERE_IS_A_TAB = 1 Then

				If _IniReadEx($file, $var[$i], "tabpage", "-1") = "-1" Then
					_GUICtrlTab_SetCurFocus(GUICtrlGetHandle($TABCONTROL_ID), -1)
				Else
					_GUICtrlTab_SetCurFocus(GUICtrlGetHandle($TABCONTROL_ID), _IniReadEx($file, $var[$i], "tabpage", "-1"))


				EndIf
			EndIf

			If $type = "#error#" Then ContinueLoop



			If $type = "button" Then
				$dummy = GUICtrlCreateButton(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				If _IniReadEx($file, $var[$i], "bgimage", "") <> "" Then
					$Testmode = 3
				EndIf
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetImage($dummy, _Return_Workdir(_IniReadEx($file, $var[$i], "bgimage", "")) & _IniReadEx($file, $var[$i], "bgimage", ""), _IniReadEx($file, $var[$i], "iconindex", "-1"))
			EndIf

			If $type = "dummy" Then
				$dummy = GUICtrlCreateButton("", _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				Button_AddIcon($dummy, $smallIconsdll, 590, 4)
				GUICtrlSetImage($dummy, _Return_Workdir(_IniReadEx($file, $var[$i], "bgimage", "")) & _IniReadEx($file, $var[$i], "bgimage", ""))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
			EndIf


			If $type = "graphic" Then
				$dummy = GUICtrlCreateButton("", _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				Button_AddIcon($dummy, $smallIconsdll, 471, 4)
				GUICtrlSetImage($dummy, _Return_Workdir(_IniReadEx($file, $var[$i], "bgimage", "")) & _IniReadEx($file, $var[$i], "bgimage", ""))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
			EndIf


			If $type = "label" Then
				$dummy = GUICtrlCreateLabel(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_Label + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
			EndIf




			If $type = "input" Then
				$dummy = GUICtrlCreateInput(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_input + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "checkbox" Then
				$dummy = GUICtrlCreateCheckbox(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_Checkbox + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				If _IniReadEx($file, $var[$i], "bgimage", "") <> "" Then GUICtrlSetImage($dummy, _Return_Workdir(_IniReadEx($file, $var[$i], "bgimage", "")) & _IniReadEx($file, $var[$i], "bgimage", ""), _IniReadEx($file, $var[$i], "iconindex", ""))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "radio" Then
				$dummy = GUICtrlCreateRadio(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_radio + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "image" Then
				$fileimage = @ScriptDir & "\data\dummy.jpg"
				If _IniReadEx($file, $var[$i], "bgimage", "") <> "" Then
					$Testmode = 3
					$fileimage = _Return_Workdir(_IniReadEx($file, $var[$i], "bgimage", "")) & _IniReadEx($file, $var[$i], "bgimage", "")
					If FileExists($fileimage) = 0 Then
						$fileimage = @ScriptDir & "\data\dummy.jpg"
						if _IniReadEx($file, $var[$i], "textmode", "text") = "text" then MsgBox(262160, _ISNPlugin_Get_langstring(48), StringReplace(_ISNPlugin_Get_langstring(176), "%1", _IniReadEx($file, $var[$i], "bgimage", "")), 0, $Studiofenster)
					EndIf
				EndIf
				$dummy = GUICtrlCreatePic($fileimage, _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_image + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf


			If $type = "slider" Then
				$dummy = GUICtrlCreateSlider(_IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetData($dummy, _IniReadEx($file, $var[$i], "text", ""))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_slider + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "progress" Then
				$dummy = GUICtrlCreateProgress(_IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetData($dummy, _IniReadEx($file, $var[$i], "text", ""))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_progress + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "updown" Then
				$dummy = GUICtrlCreateInput(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_Input + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "icon" Then
				$fileimage = @ScriptDir & "\data\dummy.ico"
				If _IniReadEx($file, $var[$i], "bgimage", "") <> "" Then
					$Testmode = 3
					$fileimage = _Return_Workdir(_IniReadEx($file, $var[$i], "bgimage", "")) & _IniReadEx($file, $var[$i], "bgimage", "")
					If FileExists($fileimage) = 0 Then
						$fileimage = @ScriptDir & "\data\dummy.ico"
						if _IniReadEx($file, $var[$i], "textmode", "text") = "text" then MsgBox(262160, _ISNPlugin_Get_langstring(48), StringReplace(_ISNPlugin_Get_langstring(176), "%1", _IniReadEx($file, $var[$i], "bgimage", "")), 0, $studiofenster)
					EndIf
				 EndIf

				$dummy = GUICtrlCreateIcon($fileimage, _IniReadEx($file, $var[$i], "iconindex", ""), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_icon + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "combo" Then
				$dummy = GUICtrlCreateCombo("", _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetData(-1, StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_Combo + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf


			If $type = "edit" Then
				$dummy = GUICtrlCreateEdit(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_Edit + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "group" Then
				$dummy = GUICtrlCreateGroup(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_Group + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "listbox" Then
				$dummy = GUICtrlCreateList("", _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetData($dummy,StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_listbox + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "date" Then
				$dummy = GUICtrlCreateDate(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_date + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "calendar" Then
				$dummy = GUICtrlCreateMonthCal(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_calendar + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "listview" Then
				$dummy = GUICtrlCreateListView(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_listview + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf


			If $type = "softbutton" Then
				$dummy = GUICtrlCreateButton(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0), $BS_COMMANDLINK)
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_softbutton + Execute(_IniReadEx($file, $var[$i], "style", "$BS_COMMANDLINK"))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "ip" Then
				$dummy = GUICtrlCreateInput(StringReplace(_IniReadEx($file, $var[$i], "text", "-"), "[BREAK]", @CRLF), _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_ip + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "treeview" Then
				$dummy = GUICtrlCreateTreeView(_IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				GUICtrlSetState($dummy, _IniReadEx($file, $var[$i], "state", ""))
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				GUICtrlSetStyle($dummy, Execute($Default_treeview + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "menu" Then
				$dummy = GUICtrlCreateButton("", _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				$MENUCONTROL_ID = $dummy
				Button_AddIcon($dummy, $smallIconsdll, 1915, 4)
				GUICtrlSetColor($dummy, _IniReadEx($file, $var[$i], "textcolour", ""))
				If _IniReadEx($file, $var[$i], "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($file, $var[$i], "bgcolour", ""))
				If _IniReadEx($file, $var[$i], "text", "") <> "" Then
					_Menu_editor_Lade_aus_INIString(_IniReadEx($file, $var[$i], "text", ""))
					_GUICtrlMenu_SetMenu($GUI_Editor, $MenuEditor_Vorschaumenue)
				EndIf
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
				_Control_Add_ToolTip($dummy, _IniReadEx($file, $var[$i], "tooltip", ""))
			EndIf


			If $type = "com" Then
				$dummy = GUICtrlCreateButton("", _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				Button_AddIcon($dummy, $smallIconsdll, 1176, 4)
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			EndIf

			If $type = "toolbar" Then
				$dummy = GUICtrlCreateButton("", _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				Button_AddIcon(-1, $smallIconsdll, 1919, 4)
				$TOOLBARCONTROL_ID = _GUICtrlToolbar_Create($GUI_Editor)
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			 EndIf

			If $type = "statusbar" Then
				$dummy = GUICtrlCreateButton("", _IniReadEx($file, $var[$i], "x", 0), _IniReadEx($file, $var[$i], "y", 0), _IniReadEx($file, $var[$i], "width", 0), _IniReadEx($file, $var[$i], "height", 0))
				Button_AddIcon(-1, $smallIconsdll, 1920, 4)
				$STATUSBARCONTROL_ID = _GUICtrlStatusBar_Create($GUI_Editor)
				GUICtrlSetFont($dummy, _IniReadEx($file, $var[$i], "fontsize", ""), _IniReadEx($file, $var[$i], "fontstyle", ""), _IniReadEx($file, $var[$i], "fontattribute", ""), _IniReadEx($file, $var[$i], "font", ""))
				GUICtrlSetState($dummy, Execute(_IniReadEx($file, $var[$i], "state", "")))
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($file, $var[$i], "style", ""))), Execute(_IniReadEx($file, $var[$i], "exstyle", "")))
				$aData1 = _IniReadSectionEx($file, $var[$i])
				_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
				_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", $dummy) ;aktuelles handle bei jedem control!
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				GUICtrlSetResizing($dummy, $GUI_DOCKALL)
			 EndIf


			;Apply Extracode
			If _IniReadEx($file, $var[$i], "code", "") <> "" AND $type <> "tab" Then
				$red = _IniReadEx($file, $var[$i], "code", "")
				$red = StringReplace($red, "$control_handle", _IniReadEx($file, $var[$i], "handle", ""))
				$data_array = StringSplit($red, "[BREAK]", 1)
				If IsArray($data_array) AND $Extracode_beim_Designen_Ignorieren = 0 Then
					For $r = 1 To $data_array[0]
						if StringInStr($data_array[$r],"guictrldelete") then ContinueLoop
						Execute($data_array[$r])
					Next
				EndIf
			EndIf


			If $THERE_IS_A_TAB = 1 Then

				_Update_Control_Cache_for_Tab($dummy, $type)
			EndIf


			$fortschritt = $fortschritt + $to_add_Pro_Element
			GUICtrlSetData($StudioFenster_inside_load, $fortschritt)
			If $fortschritt < 100 Then GUICtrlSetData($StudioFenster_inside_Text2, Int($fortschritt) & " %")
			_SetStatustext(_ISNPlugin_Get_langstring(89) & " (" & $type & ", ID: " & GUICtrlGetHandle($dummy) & ")")

		Next
	EndIf
	If $THERE_IS_A_TAB = 1 Then
		_GUICtrlTab_SetCurFocus($TABCONTROL_ID, 0)
		GUICtrlSetState($dummy, $GUI_ONTOP)
	EndIf



	_Lese_MiniEditor()
;~ winmove($GUI_Editor,"",10,10)
	_WinAPI_SetWindowPos($GUI_Editor, $HWND_TOP, 10, 10, 200, 200, $SWP_SHOWWINDOW + $SWP_NOSIZE)
	GUICtrlSetData($StudioFenster_inside_Text2, "100 %")
	GUICtrlSetData($StudioFenster_inside_load, 100)
	GUISetState(@SW_ENABLE, $StudioFenster)
	GUICtrlSetState($StudioFenster_inside_Text1, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_Text2, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_Icon, $GUI_HIDE)
	GUICtrlSetState($StudioFenster_inside_load, $GUI_HIDE)
	GUISetState(@SW_ENABLE, $GUI_Editor)
	GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)
	GUISetState(@SW_ENABLE, $StudioFenster_inside)
	GUISetState(@SW_SHOWNOACTIVATE, $StudioFenster_inside)
;~ GUISetState(@SW_SHOW,$hChild)
	GUISetState(@SW_SHOWNOACTIVATE, $Formstudio_controleditor_GUI)

	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($ControlList))
;~ WinActivate($StudioFenster)
	FileCopy($Cache_Datei, $Lastsavefile, 9)
	GUISwitch($GUI_Editor)
	_SetStatustext(_ISNPlugin_Get_langstring(46))
	_IniCloseFileEx($Cache_Datei_Handle)
	$Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
   FileCopy($Cache_Datei, $Lastsavefile, 9)
EndFunc   ;==>_Load_from_file


;__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________


Func paste_def($dummy = "", $quelle = "")
	If $quelle = "" Then Return
	If $dummy = "" Then Return
	$Pos_C = ControlGetPos($GUI_Editor, "", $dummy)
;~ GUICtrlSetPos($dummy,_ExRound($Pos_C[0],$Raster), _ExRound($Pos_C[1],$Raster))

	#cs
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "textcolour",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"textcolour",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "bgcolour",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"bgcolour",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "func",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"func",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "style",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"style",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "exstyle",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"exstyle",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "bgimage",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"bgimage",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "font",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"font",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "state",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"state",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "fontsize",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"fontsize",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "fontstyle",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"fontstyle",""))
		_IniWriteEx($Cache_Datei_Handle,Guictrlgethandle($dummy), "code",_IniReadEx($Cache_Datei_Handle,GuiCtrlGetHandle($Zwischenablage_Array[$durchlauf]),"code",""))
	#ce

	$aData1 = _IniReadSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle))
	_IniWriteSectionEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), $aData1)
	_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "id", "") ;reset ID handle
	_IniDeleteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "order") ;reset Sortierung
	_Control_Add_ToolTip($dummy, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "tooltip", ""))
	GUICtrlSetColor($dummy, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "textcolour", ""))
	If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "bgcolour", "") <> "" Then GUICtrlSetBkColor($dummy, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "bgcolour", ""))
	GUICtrlSetFont($dummy, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "fontsize", ""), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "fontstyle", ""), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "fontattribute", ""), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "font", ""))
	GUICtrlSetState($dummy, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($quelle), "state", ""))
EndFunc   ;==>paste_def

Func paste_item($Use_Contextpos = 0)
	If Not IsArray($Zwischenablage_Array) Then Return
	If $Zwischenablage_Array[0] = "" Then Return
	If Not WinActive($GUI_Editor) Then WinActivate($GUI_Editor)
	If WinActive($GUI_Editor) Then

		Local $Neue_Controls_Array = $Leeres_Array
		$old = Opt("MouseCoordMode", 2)
		$mousepos = MouseGetPos()
		Opt("MouseCoordMode", $old)

		$X_Differenz = $mousepos[0] - Number(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[0]), "x", 0))
		$Y_Differenz = $mousepos[1] - Number(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[0]), "y", 0))
		$oldtab = _GUICtrlTab_GetCurSel($TABCONTROL_ID)

		For $durchlauf = 0 To UBound($Zwischenablage_Array) - 1

			If $Zwischenablage_Array[$durchlauf] = "" Then ContinueLoop
			If $Zwischenablage_Array[$durchlauf] = $TABCONTROL_ID Then ContinueLoop


			$bindintab = 0


			If ($Markiertes_Control_ID = $TABCONTROL_ID) Or (_IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "tabpage", "-1") > -1) Then
				$bindintab = 1
				If $oldtab = -1 Then _GUICtrlTab_SetCurFocus($TABCONTROL_ID, 0)
			Else
				_GUICtrlTab_SetCurFocus($TABCONTROL_ID, -1)
			EndIf


			$type = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "type", "")
			If $type = "" Then ContinueLoop
			If $type = "menu" Then ContinueLoop
			If $type = "tab" Then ContinueLoop
			$winpos = WinGetPos($GUI_Editor)
			$dummy = ""

			If $Use_Contextpos = 1 Then
				If Not IsArray($Mausposition_bei_Contextmenue_erscheinen) Then
					$Mausposition_bei_Contextmenue_erscheinen = $mousepos
				Else
					$mousepos[0] = $Mausposition_bei_Contextmenue_erscheinen[0]
					$mousepos[1] = $Mausposition_bei_Contextmenue_erscheinen[1]
				EndIf
			EndIf





			If IsArray($winpos) And IsArray($mousepos) Then
				If $mousepos[0] > $winpos[2] Then $mousepos[0] = $winpos[2] - 70
				If $mousepos[0] < 0 Then $mousepos[0] = 70
				If $mousepos[1] > $winpos[3] Then $mousepos[1] = $winpos[3] - 70
				If $mousepos[1] < 0 Then $mousepos[1] = 70
				$control_x_pos = Number(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "x", 0)) + $X_Differenz
				$control_y_pos = Number(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "y", 0)) + $Y_Differenz
			EndIf



			If $type = "button" Then
				$dummy = GUICtrlCreateButton(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "button")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "dummy" Then
				$dummy = GUICtrlCreatebutton("", $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				Button_AddIcon($dummy, $smallIconsdll, 590, 4)
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "dummy")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			 EndIf

			If $type = "label" Then
				$dummy = GUICtrlCreateLabel(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_label + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "label")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "input" Then
				$dummy = GUICtrlCreateInput(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_input + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "input")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "checkbox" Then
				$dummy = GUICtrlCreateCheckbox(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_checkbox + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "checkbox")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "radio" Then
				$dummy = GUICtrlCreateRadio(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_radio + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "radio")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "image" Then

				If FileExists(_Return_Workdir(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "")) & _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "")) = 1 And _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "") <> "" Then
					$i = _Return_Workdir(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "")) & _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "-")
				Else
					$i = @ScriptDir & "\data\dummy.jpg"
				EndIf


				$dummy = GUICtrlCreatePic($i, $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))

				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_image + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "image")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "slider" Then
				$dummy = GUICtrlCreateSlider($control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_slider + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "slider")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "progress" Then
				$dummy = GUICtrlCreateProgress($control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_progress + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "progress")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "updown" Then
				$dummy = GUICtrlCreateInput(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_input + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "updown")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "icon" Then
				If FileExists(_Return_Workdir(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "")) & _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "")) And _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "") <> "" Then
					$i = _Return_Workdir(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "")) & _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "bgimage", "")
				Else
					$i = @ScriptDir & "\data\dummy.ico"
				EndIf

				$dummy = GUICtrlCreateIcon($i, -1, $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				_Update_Control_Cache($dummy, "icon")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)

			EndIf

			If $type = "combo" Then
				$dummy = GUICtrlCreateCombo("", $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				GUICtrlSetData(-1, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_combo + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "combo")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "edit" Then
				$dummy = GUICtrlCreateEdit(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_edit + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "edit")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "group" Then
				$dummy = GUICtrlCreateGroup(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				_Update_Control_Cache($dummy, "group")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "listbox" Then
				$dummy = GUICtrlCreateList(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				_Update_Control_Cache($dummy, "listbox")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "date" Then
				$dummy = GUICtrlCreateDate(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				_Update_Control_Cache($dummy, "date")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "calendar" Then
				$dummy = GUICtrlCreateMonthCal(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				_Update_Control_Cache($dummy, "calendar")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "listview" Then
				$dummy = GUICtrlCreateListView(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				_Update_Control_Cache($dummy, "listview")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "softbutton" Then
				$dummy = GUICtrlCreateButton(StringReplace(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), "[BREAK]", @CRLF), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0), $BS_COMMANDLINK)
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				_Update_Control_Cache($dummy, "softbutton")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "ip" Then
				$dummy = GUICtrlCreateInput(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "text", "-"), $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_ip + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "ip")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "treeview" Then
				$dummy = GUICtrlCreateTreeView($control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				_Update_Control_Cache($dummy, "treeview")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
			EndIf

			If $type = "com" Then
				$dummy = GUICtrlCreateButton("", $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "com")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				Button_AddIcon($dummy, $smallIconsdll, 1176, 4)
			 EndIf

			If $type = "graphic" Then
				$dummy = GUICtrlCreateButton("", $control_x_pos, $control_y_pos, _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "width", 0), _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "height", 0))
				paste_def($dummy, $Zwischenablage_Array[$durchlauf])
				GUICtrlSetStyle($dummy, Execute($Default_Button + Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "style", ""))), Execute(_IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Zwischenablage_Array[$durchlauf]), "exstyle", "")))
				_Update_Control_Cache($dummy, "graphic")
				_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
				Button_AddIcon($dummy, $smallIconsdll, 471, 4)
			EndIf

			If $dummy <> "" Then _ArrayAdd($Neue_Controls_Array, $dummy)

			;Apply Extracode
			If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "code", "") <> "" AND $type <> "tab" Then
				$red = _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "code", "")
				$red = StringReplace($red, "$control_handle", _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "handle", ""))
				$data_array = StringSplit($red, "[BREAK]", 1)
				If IsArray($data_array) AND $Extracode_beim_Designen_Ignorieren = 0 Then
					For $r = 1 To $data_array[0]
					   if StringInStr($data_array[$r],"guictrldelete") then ContinueLoop
						Execute($data_array[$r])
					Next
				EndIf
			EndIf


			If $type = "tab" Then ContinueLoop
			If $type = "#error#" Then ContinueLoop

			If $bindintab = 1 Then _Update_Control_Cache_for_Tab($dummy, $type)
		Next
	EndIf
	_GUICtrlTab_SetCurFocus($TABCONTROL_ID, $oldtab)
	Entferne_Makierung()
	If UBound($Neue_Controls_Array) = 1 Then
		Markiere_Controls_EDIT($Neue_Controls_Array[0])
	Else
		$Markierte_Controls_IDs = $Markierte_Controls_IDs_leer
		$Markierte_Controls_Sections = $Markierte_Controls_IDs_leer
		For $u = 0 To UBound($Neue_Controls_Array) - 1
			_Add_control_to_Multiselection($Neue_Controls_Array[$u])
		Next
		$Control_Markiert = 0
		$Control_Markiert_MULTI = 1
	EndIf
EndFunc   ;==>paste_item

;___BUTTONICONS__

Func Button_AddIcon($nID, $sIconFile, $nIconID, $nAlign)
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




Func ImageList_Create($nImageWidth, $nImageHeight, $nFlags, $nInitial, $nGrow)
	Local $hImageList = DllCall('comctl32.dll', 'hwnd', 'ImageList_Create', _
			'int', $nImageWidth, _
			'int', $nImageHeight, _
			'int', $nFlags, _
			'int', $nInitial, _
			'int', $nGrow)
	Return $hImageList[0]
EndFunc   ;==>ImageList_Create


Func ImageList_AddIcon($hIml, $hIcon)
	Local $nIndex = DllCall('comctl32.dll', 'int', 'ImageList_AddIcon', _
			'hwnd', $hIml, _
			'hwnd', $hIcon)
	Return $nIndex[0]
EndFunc   ;==>ImageList_AddIcon


Func ImageList_Destroy($hIml)
	Local $bResult = DllCall('comctl32.dll', 'int', 'ImageList_Destroy', _
			'hwnd', $hIml)
	Return $bResult[0]
EndFunc   ;==>ImageList_Destroy


Func ExtractIconEx($sIconFile, $nIconID, $ptrIconLarge, $ptrIconSmall, $nIcons)
	Local $nCount = DllCall('shell32.dll', 'int', 'ExtractIconEx', _
			'str', $sIconFile, _
			'int', $nIconID, _
			'ptr', $ptrIconLarge, _
			'ptr', $ptrIconSmall, _
			'int', $nIcons)
	Return $nCount[0]
EndFunc   ;==>ExtractIconEx


Func DestroyIcon($hIcon)
	Local $bResult = DllCall('user32.dll', 'int', 'DestroyIcon', _
			'hwnd', $hIcon)
	Return $bResult[0]
EndFunc   ;==>DestroyIcon

;___END__BUTTONICONS__


Func _new_Control($control, $nomove = 0)


	WinActivate($GUI_Editor)
	GUISwitch($GUI_Editor)
	$bindintab = 0
	$oldtabb = -1
	$oldtabb = _GUICtrlTab_GetCurSel($TABCONTROL_ID)
	If $Markiertes_Control_ID = $TABCONTROL_ID Or _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID), "tabpage", "-1") > -1 Then
		If _GUICtrlTab_GetCurSel($TABCONTROL_ID) = -1 Then _GUICtrlTab_SetCurFocus($TABCONTROL_ID, 0)
		$bindintab = 1

	Else

		_GUICtrlTab_SetCurFocus($TABCONTROL_ID, -1)
	EndIf
	If Not $TABCONTROL_ID = "" And $Markiertes_Control_ID = "" Then

		_GUICtrlTab_SetCurFocus($TABCONTROL_ID, -1)
	EndIf
	;_______________________________________________________________________________________
	If $control = "button" Then
		$dummy = GUICtrlCreateButton(_ISNPlugin_Get_langstring(49), 0, 0, 100, 30)
		GUICtrlSetStyle($dummy, $Default_Button)
	EndIf

	If $control = "label" Then
		$dummy = GUICtrlCreateLabel(_ISNPlugin_Get_langstring(49), 0, 0, 50, 15)
		GUICtrlSetStyle($dummy, $Default_Label)
	EndIf

	If $control = "input" Then
		$dummy = GUICtrlCreateInput(_ISNPlugin_Get_langstring(49), 0, 0, 150, 20)
		GUICtrlSetStyle($dummy, $Default_Input)
	EndIf

	If $control = "checkbox" Then
		$dummy = GUICtrlCreateCheckbox(_ISNPlugin_Get_langstring(49), 0, 0, 150, 20)
		GUICtrlSetStyle($dummy, $Default_Checkbox)
	EndIf

	If $control = "radio" Then
		$dummy = GUICtrlCreateRadio(_ISNPlugin_Get_langstring(49), 0, 0, 150, 20)
		GUICtrlSetStyle($dummy, $Default_Radio)
	EndIf

	If $control = "image" Then
		$dummy = GUICtrlCreatePic(@ScriptDir & "\data\dummy.jpg", 0, 0, 50, 50)
		;$i = _TargetQueryStyles($GUI_Editor, "", $dummy)
		;ConsoleWrite($i[0])
		GUICtrlSetStyle($dummy, $Default_Image)
	EndIf

	If $control = "slider" Then
		$dummy = GUICtrlCreateSlider(0, 0, 200, 30)
		;$i = _TargetQueryStyles($GUI_Editor, "", $dummy)
		;ConsoleWrite($i[0])
		GUICtrlSetStyle($dummy, $Default_slider)
	EndIf

	If $control = "progress" Then
		$dummy = GUICtrlCreateProgress(0, 0, 200, 20)
		;$i = _TargetQueryStyles($GUI_Editor, "", $dummy)
		;ConsoleWrite($i[0])
		GUICtrlSetStyle($dummy, $Default_progress)
	EndIf

	If $control = "updown" Then
		$dummy = GUICtrlCreateInput("0", 0, 0, 50, 20)
		GUICtrlSetStyle($dummy, $Default_Input)
	EndIf

	If $control = "icon" Then
		$dummy = GUICtrlCreateIcon(@ScriptDir & "\data\dummy.ico", -1, 0, 0, 48, 48)
		GUICtrlSetStyle($dummy, $Default_Icon)
	EndIf

	If $control = "combo" Then
		$dummy = GUICtrlCreateCombo(_ISNPlugin_Get_langstring(49), 0, 0, 150, 20)
		;$i = _TargetQueryStyles($GUI_Editor, "", $dummy)
		;ConsoleWrite($i[0])
		GUICtrlSetStyle($dummy, $Default_Combo)
	EndIf

	If $control = "edit" Then
		$dummy = GUICtrlCreateEdit(_ISNPlugin_Get_langstring(49), 0, 0, 200, 150)
		GUICtrlSetStyle($dummy, $Default_Edit)
	EndIf

	If $control = "group" Then
		$dummy = GUICtrlCreateGroup(_ISNPlugin_Get_langstring(49), 0, 0, 200, 150)
		GUICtrlSetStyle($dummy, $Default_Group)
	EndIf

	If $control = "listbox" Then
		$dummy = GUICtrlCreateList("", 0, 0, 200, 150)
		GUICtrlSetStyle($dummy, $Default_Listbox)
	EndIf

	If $control = "tab" Then
		If Not $TABCONTROL_ID = "" Then
			MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(47), 0, $Studiofenster)
			Return
		EndIf


		$dummy = GUICtrlCreateTab(0, 0, 200, 150)
		GUICtrlSetState(-1, $GUI_ONTOP)
		$TABCONTROL_ID = $dummy
		_GUICtrlTab_InsertItem($TABCONTROL_ID, 0, "Page 1")
		_GUICtrlTab_SetCurFocus($TABCONTROL_ID, -1)
		GUICtrlSetStyle($dummy, $Default_Tab)
	EndIf



	If $control = "date" Then
		$dummy = GUICtrlCreateDate("2011/01/01 00:00:00", 0, 0, 186, 21)
		GUICtrlSetStyle($dummy, $Default_Date)
	EndIf

	If $control = "calendar" Then
		$dummy = GUICtrlCreateMonthCal(@YEAR & "/" & @MON & "/" & @MDAY, 0, 0, 180, 164)
		GUICtrlSetStyle($dummy, $Default_calendar)
	EndIf

	If $control = "listview" Then
		$dummy = GUICtrlCreateListView(_ISNPlugin_Get_langstring(49), 0, 24, 180, 164)
		GUICtrlSetStyle($dummy, $Default_listview)
	EndIf


	If $control = "softbutton" Then
		$dummy = GUICtrlCreateButton(_ISNPlugin_Get_langstring(49), 0, 0, 250, 100, $BS_COMMANDLINK)
		DllCall("user32.dll", "UINT", "SendMessage", "handle", GUICtrlGetHandle($dummy), "UINT", $BCM_SETNOTE, "ptr*", 0, "wstr", "You can edit this text/icon under Extracode!")
		DllCall("user32.dll", "UINT", "SendMessage", "handle", GUICtrlGetHandle($dummy), "UINT", $BCM_SETSHIELD, "ptr*", 0, "BOOL", False)
		GUICtrlSetStyle($dummy, $Default_softbutton + $BS_COMMANDLINK)
	EndIf

	If $control = "ip" Then
		$dummy = GUICtrlCreateInput("0.0.0.0", 0, 0, 150, 20)
		GUICtrlSetStyle($dummy, $Default_IP)
	EndIf

	If $control = "treeview" Then
		$dummy = GUICtrlCreateTreeView(0, 24, 180, 164)
		GUICtrlSetStyle($dummy, $Default_treeview, 512)
	EndIf

	If $control = "menu" Then
		If Not $MENUCONTROL_ID = "" Then
			MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(195), 0, $Studiofenster)
			Return
		EndIf

		$dummy = GUICtrlCreateButton("", 0, 0, 25, 25)
		Button_AddIcon(-1, $smallIconsdll, 1915, 4)
		GUICtrlSetStyle($dummy, $Default_Button)
		$MENUCONTROL_ID = $dummy
	EndIf


	If $control = "com" Then
		$dummy = GUICtrlCreateButton("", 0, 0, 100, 100)
		Button_AddIcon(-1, $smallIconsdll, 1176, 4)
		GUICtrlSetStyle($dummy, $Default_Button)
	EndIf

	If $control = "dummy" Then
		$dummy = GUICtrlCreateButton("", 0, 0, 25, 25)
		Button_AddIcon(-1, $smallIconsdll, 590, 4)
		GUICtrlSetStyle($dummy, $Default_Button)
	EndIf

	If $control = "toolbar" Then
		If Not $TOOLBARCONTROL_ID = "" Then
			MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(253), 0, $Studiofenster)
			Return
		EndIf

		$dummy = GUICtrlCreateButton("", 0, 0, 25, 25)
		Button_AddIcon(-1, $smallIconsdll, 1919, 4)
		GUICtrlSetStyle($dummy, $Default_Button)
		$TOOLBARCONTROL_ID = _GUICtrlToolbar_Create($GUI_Editor)
	 EndIf


	If $control = "graphic" Then
	   $dummy = GUICtrlCreateButton("", 0, 0, 25, 25)
		Button_AddIcon(-1, $smallIconsdll, 471, 4)
		GUICtrlSetStyle($dummy, $Default_Button)
	EndIf

	If $control = "statusbar" Then

		 If Not $STATUSBARCONTROL_ID = "" Then
			MsgBox(262160, _ISNPlugin_Get_langstring(48), _ISNPlugin_Get_langstring(259), 0, $Studiofenster)
			Return
		 EndIf

		$dummy = GUICtrlCreateButton("", 0, 0, 25, 25)
		Button_AddIcon(-1, $smallIconsdll, 1920, 4)
		GUICtrlSetStyle($dummy, $Default_Button)
		$STATUSBARCONTROL_ID = _GUICtrlStatusBar_Create($GUI_Editor)
	EndIf


	GUICtrlSetResizing($dummy, $GUI_DOCKALL)
	;_______________________________________________________________________________________
	$coords = WinGetPos($GUI_Editor)
	_SetStatustext(_ISNPlugin_Get_langstring(45))
	_MouseTrap($coords[0], $coords[1], $coords[0] + $coords[2], $coords[1] + $coords[3])


	While 1
		$mousepos = MouseGetPos()
		GUICtrlSetPos($dummy, $mousepos[0], $mousepos[1])
		If _IsPressed("01", $dll) Or _IsPressed("02", $dll) Then ExitLoop
		If $nomove = 1 Then ExitLoop
		Sleep(20)
	WEnd
	_MouseTrap()


	$Pos_C = ControlGetPos($GUI_Editor, "", $dummy)
	GUICtrlSetPos($dummy, _ExRound($Pos_C[0], 20), _ExRound($Pos_C[1], 20))
;~ sleep(100)
	_SetStatustext(_ISNPlugin_Get_langstring(46))
	_Update_Control_Cache($dummy, $control)
	_ControlID_to_Cache2(GUICtrlGetHandle($dummy), $dummy)
	If $bindintab = 1 Then
		_Update_Control_Cache_for_Tab($dummy, $control)
	Else
		_IniWriteEx($Cache_Datei_Handle, GUICtrlGetHandle($dummy), "tabpage", "-1")
	EndIf

	If $oldtabb > -1 Then _GUICtrlTab_SetCurFocus($TABCONTROL_ID, $oldtabb)
	_Redraw_Window()
	Sleep(100)
	Markiere_Controls_EDIT($dummy)
EndFunc   ;==>_new_Control

