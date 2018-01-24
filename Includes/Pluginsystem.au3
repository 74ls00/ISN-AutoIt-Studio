;Pluginsystem.au3

func _Lock_Plugintabs($State = "lock")
    If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
   If $Offenes_Projekt = "" Then Return
   if $State = "lock" Then
	  GUISetState (@SW_DISABLE ,$QuickView_GUI)
	  for $index = 0 to ubound($Plugin_Handle)-1
		 if $Plugin_Handle[$index] = "" then ContinueLoop
		 if $Plugin_Handle[$index] = "-1" then ContinueLoop
		WinSetState (HWnd($Plugin_Handle[$index]), "", @SW_DISABLE)
		GUISetState (@SW_DISABLE ,HWnd($SCE_EDITOR[$index]))
	  next
   Else
	  GUISetState (@SW_ENABLE ,$QuickView_GUI)
	  for $index = 0 to ubound($Plugin_Handle)-1
		 if $Plugin_Handle[$index] = "" then ContinueLoop
		 if $Plugin_Handle[$index] = "-1" then ContinueLoop
		WinSetState (HWnd($Plugin_Handle[$index]), "", @SW_ENABLE)
		GUISetState (@SW_ENABLE ,HWnd($SCE_EDITOR[$index]))
	  next
   endif
Endfunc

Func _Plugin_Get_Unlockstring($pluginfolder="")
  return "unlock"&$Plugin_System_Delimiter&@AutoItPID&$Plugin_System_Delimiter&@WorkingDir&$Plugin_System_Delimiter&$Configfile&$Plugin_System_Delimiter&$Languagefile_full_path&$Plugin_System_Delimiter&$Offenes_Projekt&$Plugin_System_Delimiter&$Offenes_Projekt_name&$Plugin_System_Delimiter&$Arbeitsverzeichnis&$Plugin_System_Delimiter&$Pfad_zur_Project_ISN&$Plugin_System_Delimiter&$pluginfolder
EndFunc

Func _open_plugintab($pluginexe, $file="", $Advanced_Plugin = 0)
	if $file = "" then Return

   Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
   _PathSplit($pluginexe, $sDrive, $sDir, $sFileName, $sExtension)


   $workingdir = _WinAPI_PathRemoveBackslash($sDrive&$sDir)


   If $Advanced_Plugin = 1 And (IniRead($workingdir & "\plugin.ini", "plugin", "isnplaceholders", "") <> "" OR IniRead($workingdir & "\plugin.ini", "plugin", "notab_mode", "0") = "1"  ) Then
	  ;Es soll ein Type 3 Plugin gestartet werden
	  $Can_open_new_tab = 1
	  _Starte_Type3_Plugin($pluginexe, "toolbar", IniRead($workingdir & "\plugin.ini", "plugin", "waitforplugintoexit", "0"))
	  return
   endif

	If Not FileExists($pluginexe) And Not FileExists(StringReplace($pluginexe, ".exe", ".au3")) Then
		MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1033), "%1", $pluginexe), 0, $StudioFenster)
		$Can_open_new_tab = 1
		GUISetCursor(2, 0, $studiofenster)
		Return
	EndIf

   if $Advanced_Plugin = 0 then
	If Not FileExists($file) Then
		MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1033), "%1", $file), 0, $StudioFenster)
		$Can_open_new_tab = 1
		GUISetCursor(2, 0, $studiofenster)
		Return
	EndIf
   EndIf


	If $Advanced_Plugin = 1 And IniRead($workingdir & "\plugin.ini", "plugin", "exclusiv", "0") <> "0" Then
		Local $alreadyopen
		$res = _ArraySearch($Datei_pfad, $pluginexe)
		If $res <> -1 Then
			$alreadyopen = $res
		Else
			$alreadyopen = -1
		EndIf
		If $alreadyopen <> -1 Then
			_GUICtrlTab_ActivateTabX($hTab, $alreadyopen, 0)
			_Show_Tab($alreadyopen)
			_Redraw_Window($Plugin_Handle[$alreadyopen])
			$Can_open_new_tab = 1
			Return
		EndIf
	EndIf

	GUISetCursor(1, 0, $studiofenster)
	_Write_log(_Get_langstr(36) & " " & StringTrimLeft($file, StringInStr($file, "\", 0, -1)))
	If Not FileExists($pluginexe) Then
		If Not FileExists($autoitexe) Then MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(300), 0, $studiofenster)
		$pluginexe = $autoitexe & ' "' & StringReplace($pluginexe, ".exe", ".au3")&'"'
	EndIf
	If $Advanced_Plugin = 0 Then
		$Plugin_PID = Run($pluginexe & ' "' & FileGetShortName($file) & '"', $workingdir);, @SW_HIDE )
	Else
		$Plugin_PID = Run($pluginexe, $workingdir);, @SW_HIDE )
	EndIf
	_Write_ISN_Debug_Console("Open new plugin tab with PID " & $Plugin_PID & "...", 1)
	_Write_ISN_Debug_Console("|--> Plugin to run: "&$pluginexe, 1)
	_Write_ISN_Debug_Console("|--> File to open: "&$file, 1)



   Local $Versuche_zum_suchen = 50
   local $Plugin_WindowHandle
	While 1
	   $Versuche_zum_suchen = $Versuche_zum_suchen-1

	   $Plugin_WindowHandle = WinGetHandle ("_ISNPLUGIN_STARTUP_","")
	   if not @error then exitloop

	    If $Versuche_zum_suchen < 30 AND NOT BitAND(WinGetState($ISN_warte_auf_Plugin, ""), 2) Then GUISetState(@SW_SHOW,$ISN_warte_auf_Plugin)

	    ;Letzter Versuch
		If $Versuche_zum_suchen < 1 Then
			_Write_ISN_Debug_Console("|--> Plugin could not be started! (No message returned from the plugin!)", 3)
			GUISetState(@SW_HIDE,$ISN_warte_auf_Plugin)
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(310), 0, $StudioFenster)
			ProcessClose($Plugin_PID)
			$Can_open_new_tab = 1
			GUISetCursor(2, 0, $studiofenster)
			Return
		 EndIf

		 sleep(100)
   WEnd
   GUISetState(@SW_HIDE,$ISN_warte_auf_Plugin)
   _ISN_Send_Message_to_Plugin($Plugin_WindowHandle,_Plugin_Get_Unlockstring(_ISN_Variablen_aufloesen($Pluginsdir&"\"&$sFileName))) ;Sende Unlock Nachricht inkl. wichtige Startvariablen an das Plugin
	_Write_ISN_Debug_Console("|--> 'unlock' message sent to plugin!", 1)

	$Plugin_Handle[$Offene_tabs] = Ptr($Plugin_WindowHandle) ;Empfangenes Handle in Pointer umwandeln
 	$SCE_EDITOR[$Offene_tabs] = GUICreate("", 0, 0, -99000, -99000, $WS_POPUP, $WS_EX_MDICHILD+$WS_EX_LAYERED,$Studiofenster)
   GUISetBkColor(0xFFEFFA, $SCE_EDITOR[$Offene_tabs])
   _WinAPI_SetLayeredWindowAttributes($SCE_EDITOR[$Offene_tabs], 0xFFEFFA, 255) ;komplett unsichtbares dummy gui
	GUISetCursor(1, 0, $Plugin_Handle[$Offene_tabs])
	GUICtrlSetState($HD_Logo, $GUI_HIDE)
	;Resize
	$tabsize = ControlGetPos($StudioFenster, "", $htab)
	$htab_wingetpos_array = WinGetPos(GUICtrlGetHandle($htab))
	If $Plugin_Handle[$Offene_tabs] = -1 Then
	   ;Scintilla
		$y = $tabsize[1] + $Tabseite_hoehe
		$x = $tabsize[0] + 4
	Else
		 ;Plugin
		 $y = $htab_wingetpos_array[1] + $Tabseite_hoehe
		 $x = $htab_wingetpos_array[0] + 4
	  EndIf


   _WinAPI_SetWindowPos($SCE_EDITOR[$Offene_tabs],  $HWND_TOPMOST  , $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_NOACTIVATE )
   _WinAPI_SetWindowPos($SCE_EDITOR[$Offene_tabs], _WinAPI_GetWindow(WinGetHandle($Studiofenster),$GW_HWNDNEXT) , $x, $y, $tabsize[2] - 10, $tabsize[3] - $Tabseite_hoehe - 4, $SWP_SHOWWINDOW+$SWP_NOACTIVATE )
	$plugsize = WinGetPos($SCE_EDITOR[$Offene_tabs])


   _Write_ISN_Debug_Console("|--> Bind plugin in the ISN AutoIt Studio GUI...", 1)
    _WinAPI_SetParent($Plugin_Handle[$Offene_tabs], $SCE_EDITOR[$Offene_tabs])
	_WinAPI_SetWindowPos($Plugin_Handle[$Offene_tabs],  $HWND_TOP  , 0, 0, $plugsize[2], $plugsize[3], $SWP_SHOWWINDOW+$SWP_NOACTIVATE)
   if _GUICtrlTab_GetCurFocus($htab) <> $Tabswitch_last_Tab then $Tabswitch_last_Tab = _GUICtrlTab_GetCurFocus($htab)




	_HIDE_FENSTER_RECHTS("true")
	_HIDE_FENSTER_UNTEN("true")



   $Icon = IniRead($sDrive&$sDir&"plugin.ini", "plugin", "toolsmenuiconid", "193")
   $tabname =  IniRead($sDrive&$sDir&"plugin.ini", "plugin", "tabdescription","")
   if $tabname = "" then $tabname = StringTrimLeft($file, StringInStr($file, "\", 0, -1))
   if IniRead($sDrive&$sDir&"plugin.ini", "plugin", "toolsmenudescription","") = "" Then
   _GUICtrlTab_InsertItem($hTab, $Offene_tabs, $tabname)
   else
   $tabname = IniRead($sDrive&$sDir&"plugin.ini", "plugin", "tabdescription", IniRead($sDrive&$sDir&"plugin.ini", "plugin", "name", ""))
   if $Advanced_Plugin = 0 then $tabname = StringTrimLeft($file, StringInStr($file, "\", 0, -1))&" - "&$tabname
	_GUICtrlTab_InsertItem($hTab, $Offene_tabs, $tabname)
	Endif

   if IniRead($sDrive&$sDir&"plugin.ini", "plugin", "tabdescription","") = "" Then
	  _GUICtrlTab_SetItemImage($hTab, $Offene_tabs, _return_FileIcon(StringTrimLeft($File, StringInStr($File, ".", 1, -1))))
   Else
	    If StringInStr($Icon, ".ico") Then
			_GUICtrlTab_SetItemImage($hTab, $Offene_tabs, _GUIImageList_AddIcon($hImage, $sDrive&$sDir&$Icon, 0))
		Else
			_GUICtrlTab_SetItemImage($hTab, $Offene_tabs, _GUIImageList_AddIcon($hImage, $smallIconsdll, $Icon - 1))
		EndIf
   endif


    ;Tabhöhe bestimmen
	$Tab_Rect = _GUICtrlTab_GetItemRect ($htab, $Offene_tabs)
	if IsArray($Tab_Rect) then $Tabseite_hoehe = $Tab_Rect[3]+(4*$DPI)

	$Datei_pfad[$Offene_tabs] = $file
	_GUICtrlTab_ActivateTabX($hTab, $Offene_tabs, 0)


 	_Show_Tab($Offene_tabs,1)

	_Check_Buttons(0)


	;_WINDOW_REBUILD()
	_Write_ISN_Debug_Console("|--> Tab successfully created!", 1)

	$Offene_tabs = $Offene_tabs + 1
	$Can_open_new_tab = 1
	_run_rule($Section_Trigger7)
	GUISetCursor(2, 0, $studiofenster)
;~ 	if $Offene_tabs - 1 > 0 then _WinAPI_RedrawWindow($Plugin_Handle[$Offene_tabs - 1])
;~ 	if $Offene_tabs - 1 > 0 then _WinAPI_RedrawWindow($SCE_EDITOR[$Offene_tabs - 1])
	If $Offene_tabs - 1 > -1 Then GUISetCursor(2, 0, $Plugin_Handle[$Offene_tabs - 1])

EndFunc   ;==>_open_plugintab


Func _Close_Tab_plugin($nr)
	If _GUICtrlTab_GetItemCount($htab) = 0 Then Return
   local $GUICtrlTab_GetCurFocus = _GUICtrlTab_GetCurFocus($htab)

    GUISetCursor(1, 0, $studiofenster)
	_Write_ISN_Debug_Console("Closing plugin tab " & $nr & " (Window Handle " & $Plugin_Handle[$nr] & ")...", 2)
	$Can_open_new_tab = 0
	$PID = WinGetProcess($Plugin_Handle[$nr])
	_Write_log(_Get_langstr(38) & " (" & _GUICtrlTab_GetItemText($htab, $nr) & ")")



	;Prüfe noch auf Änderungen vor dem Beenden des Plugins (zb. im Formstudio)
   _ISN_Send_Message_to_Plugin($Plugin_Handle[$nr],"checkchanges")
   _ISN_Wait_for_Message_from_Plugin($Plugin_Handle[$nr],"changesok",900000)
	_ISN_Send_Message_to_Plugin($Plugin_Handle[$nr],"exit") ;Exit an Plugin senden

	GUIDelete($SCE_EDITOR[$nr])
	_GUICtrlTab_DeleteItem($htab, $nr)
	For $i = $nr To $Offene_tabs Step +1
		$SCE_EDITOR[$i] = $SCE_EDITOR[$i + 1]
		$Plugin_Handle[$i] = $Plugin_Handle[$i + 1]
		$Datei_pfad[$i] = $Datei_pfad[$i + 1]
		$FILE_CACHE[$i] = $FILE_CACHE[$i + 1]
	Next
	$Offene_tabs = $Offene_tabs - 1
	_GUICtrlTab_ActivateTabX($htab, $Offene_tabs - 1)
	$tab = _GUICtrlTab_GetCurFocus($htab)
	if $tab <> -1 then _Show_Tab($tab)
	AdlibRegister("_Check_Buttons", 0)

	If _GUICtrlTab_GetItemCount($htab) > 0 And _GUICtrlTab_GetCurFocus($htab) <> -1 Then _Redraw_Window($SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
	Sleep(200)
	If ProcessExists($PID) Then
		Sleep(300)
		_Write_ISN_Debug_Console("|--> Killing Process PID " & $PID, 2)
		$r = ProcessClose($PID) ;Falls bis dahin nicht gschlossen...
		If $r = 0 Then
			If @error = 1 Then _Write_ISN_Debug_Console("|--> OpenProcess failed", 3)
			If @error = 2 Then _Write_ISN_Debug_Console("|--> AdjustTokenPrivileges Failed", 3)
			If @error = 3 Then _Write_ISN_Debug_Console("|--> TerminateProcess Failed", 3)
			If @error = 4 Then _Write_ISN_Debug_Console("|--> Cannot verify if process exists", 3)
		EndIf
	EndIf
	_Write_ISN_Debug_Console("|--> Plugin tab successfully closed!", 1)
	$Can_open_new_tab = 1
	GUISetCursor(2, 0, $studiofenster)
	WinActivate($StudioFenster)
	;_Redraw_Window($SCE_EDITOR[_GUICtrlTab_GetCurFocus($hTab)])
EndFunc   ;==>_Close_Tab_plugin

Func _Starte_Type3_Plugin($pluginexe, $Platzhaltername = "", $Warte_bis_Plugin_Beendet_ist = 0)

	Local $Handle_nr = "-1"
	Local $Exit_code = -1
	Local $Parameter_Listview_als_Array
	Local $Parameter_Listview_als_String
  if $Can_open_new_tab = 0 then return
	_Pruefe_ob_Type3_Plugins_noch_aktiv_sind()
	If Not FileExists($pluginexe) And Not FileExists(StringReplace($pluginexe, ".exe", ".au3")) Then
		MsgBox(262144 + 16, _Get_langstr(25), StringReplace(_Get_langstr(1033), "%1", $pluginexe), 0, $StudioFenster)
		GUISetCursor(2, 0, $studiofenster)
		$Can_open_new_tab = 1
		Return
	EndIf

   Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
   _PathSplit($pluginexe, $sDrive, $sDir, $sFileName, $sExtension)

   $workingdir = _WinAPI_PathRemoveBackslash($sDrive&$sDir)



	;Starte Plugin
	If Not FileExists($pluginexe) Then
		If Not FileExists($autoitexe) Then MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(300), 0, $studiofenster)
		$pluginexe = $autoitexe & ' "' & StringReplace($pluginexe, ".exe", ".au3")&'"'
	EndIf


   ;Prüfe Exclusivität
   if IniRead($workingdir & "\plugin.ini", "plugin", "exclusiv", "0") <> "0" Then
	  For $x = 0 To UBound($Type3_Plugin_Handles) - 1
		 If $Type3_Plugin_Handles[$x][1] = $pluginexe then
		 GUISetCursor(2, 0, $studiofenster)
	   $Can_open_new_tab = 1
	   _Write_ISN_Debug_Console("|--> Plugin could not be started! (Another instance is already running and exclusiv mode is ON!)", 3)
		Return
		Endif
	  Next
   endif


	For $x = 0 To UBound($Type3_Plugin_Handles) - 1
		If $Type3_Plugin_Handles[$x][0] = "" Then
			$Handle_nr = $x
			ExitLoop
		EndIf
	Next
	If $Handle_nr = "-1" Then Return ;Mehr als 10 Type 3 Plugins sind nicht drinnen


	$Plugin_PID = Run($pluginexe & " " & $Platzhaltername, $workingdir) ;Plugin starten und $Platzhaltername als Parameter übergeben -> Dadurch kann das Plugin unterscheiden wodurch es gestartet wurde
	_Write_ISN_Debug_Console("Try to open new Type 3 plugin with PID " & $Plugin_PID & "...", 1)
   _Write_ISN_Debug_Console("|--> Plugin to run: "&$pluginexe, 1)

   Local $Versuche_zum_suchen = 50
   local $Plugin_WindowHandle
	While 1
	   $Versuche_zum_suchen = $Versuche_zum_suchen-1

	   $Plugin_WindowHandle = WinGetHandle ("_ISNPLUGIN_STARTUP_","")
	   if not @error then exitloop

	    If $Versuche_zum_suchen < 30 AND NOT BitAND(WinGetState($ISN_warte_auf_Plugin, ""), 2) Then GUISetState(@SW_SHOW,$ISN_warte_auf_Plugin)

	    ;Letzter Versuch
		If $Versuche_zum_suchen < 1 Then
			_Write_ISN_Debug_Console("|--> Plugin could not be started! (No message returned from the plugin!)", 3)
			GUISetState(@SW_HIDE,$ISN_warte_auf_Plugin)
			MsgBox(262144 + 16, _Get_langstr(25), _Get_langstr(310), 0, $StudioFenster)
			ProcessClose($Plugin_PID)
			Return
		 EndIf

		 sleep(100)
	  WEnd
	$Plugin_WindowHandle = $Plugin_WindowHandle
   GUISetState(@SW_HIDE,$ISN_warte_auf_Plugin)
   _ISN_Send_Message_to_Plugin($Plugin_WindowHandle,"unlock"&$Plugin_System_Delimiter&@AutoItPID&$Plugin_System_Delimiter&@WorkingDir&$Plugin_System_Delimiter&$Configfile&$Plugin_System_Delimiter&$Languagefile_full_path&$Plugin_System_Delimiter&$Offenes_Projekt&$Plugin_System_Delimiter&$Offenes_Projekt_name&$Plugin_System_Delimiter&$Arbeitsverzeichnis&$Plugin_System_Delimiter&$Pfad_zur_Project_ISN) ;Sende Unlock Nachricht inkl. wichtige Startvariablen an das Plugin
   _ISN_Wait_for_Message_from_Plugin($Plugin_WindowHandle,"unlocked",5000)



	$Type3_Plugin_Handles[$Handle_nr][0] = ptr($Plugin_WindowHandle)
	$Type3_Plugin_Handles[$Handle_nr][1] = $pluginexe
	_Write_ISN_Debug_Console("|--> 'unlock' message sent to plugin!", 1)
	_Write_ISN_Debug_Console("|--> " & $Plugin_WindowHandle & " is the handle of the new plugin.", 1)




	Switch $Platzhaltername

		Case $Plugin_Platzhalter_Parametereditor
			$Parameter_Listview_als_Array = _GUICtrlListView_CreateArray($ParameterEditor_ListView)
			If IsArray($Parameter_Listview_als_Array) Then
				$Parameter_Listview_als_String = _ArrayToString($Parameter_Listview_als_Array, ":rowdelim:", Default, Default, ":coldelim:")
			EndIf

			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$Readen_Parameter_String", $Readen_Parameter_String)
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$Readen_Parameter_Array", $Parameter_Listview_als_String)
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$Readen_Command_Calltipp", GUICtrlRead($ParameterEditor_CallTipp_Label))
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Scintilla_Startpos", $Parameter_Editor_Startpos)
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Scintilla_Endpos", $Parameter_Editor_Endpos)
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Scintilla_Handle", $SCE_EDITOR[_GUICtrlTab_GetCurFocus($htab)])
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$Readen_Command_Name", GUICtrlRead($ParameterEditor_ParameterTitel))

		 Case $Plugin_Platzhalter_Projekteigenschaften
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Name", _GUICtrlListView_GetItemText ($Project_Properties_listview, 0, 1)) ;Projektname
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Version", _GUICtrlListView_GetItemText ($Project_Properties_listview, 2, 1)) ;Version
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Mainfile_Name", _GUICtrlListView_GetItemText ($Project_Properties_listview, 3, 1)) ;Name der Hauptdatei
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Comment", _GUICtrlListView_GetItemText ($Project_Properties_listview, 4, 1)) ;Kommentar
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Author", _GUICtrlListView_GetItemText ($Project_Properties_listview, 5, 1)) ;Autor
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Creation_Date", _GUICtrlListView_GetItemText ($Project_Properties_listview, 6, 1)) ;Erstellungs Datum
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Studioversion", _GUICtrlListView_GetItemText ($Project_Properties_listview, 7, 1)) ;Erstellt mit ISN AuotIt Studio Version X
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Size", _GUICtrlListView_GetItemText ($Project_Properties_listview, 8, 1)) ;Größe des Projektes
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Files_and_Folders", _GUICtrlListView_GetItemText ($Project_Properties_listview, 9, 1)) ;Anzahl der Dateien und Ordner im Projekt
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Time", _GUICtrlListView_GetItemText ($Project_Properties_listview, 10, 1)) ;Zeit des Projektes
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Open_Count", _GUICtrlListView_GetItemText ($Project_Properties_listview, 11, 1)) ;Wie oft geöffnet
			_ISN_Set_Variable_in_Plugin($Plugin_WindowHandle, "$ISN_Project_Macros_Count", _GUICtrlListView_GetItemText ($Project_Properties_listview, 12, 1)) ;Makros



	EndSwitch

	If $Warte_bis_Plugin_Beendet_ist = 1 Then
		guisetstate(@SW_DISABLE, $StudioFenster)
		;Öffne Prozess Handle
		$h_Process = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', 0x400, 'int', 0, 'int', $Plugin_PID)

		;Warte bis Plugin beendet wird
		While ProcessExists($Plugin_PID)
			Sleep(100)
		WEnd

		;Hole Exit Code
		$i_ExitCode = DllCall('kernel32.dll', 'ptr', 'GetExitCodeProcess', 'ptr', $h_Process[0], 'int*', 0)
		If IsArray($i_ExitCode) Then
			$Exit_code = $i_ExitCode[2]
		Else
			$Exit_code = -1
		EndIf
		Sleep(100) ; or DllCall may fail - experimental
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $h_Process[0])
		guisetstate(@SW_ENABLE, $StudioFenster)
		$Can_open_new_tab = 1
		Return $Exit_code
	Else
		 $Can_open_new_tab = 1
		Return -1
	EndIf
EndFunc   ;==>_Starte_Type3_Plugin


Func _Pruefe_ob_Type3_Plugins_noch_aktiv_sind()
	If Not IsArray($Type3_Plugin_Handles) Then Return
	For $x = 0 To UBound($Type3_Plugin_Handles) - 1
		If $Type3_Plugin_Handles[$x][0] = "" Then ContinueLoop
		If Not WinExists($Type3_Plugin_Handles[$x][0]) Then
			_Write_ISN_Debug_Console("Type 3 Plugin with Handle " & $Type3_Plugin_Handles[$x][0] & " disconnected!", 1)
			$Type3_Plugin_Handles[$x][0] = "" ;Falls nicht mehr aktiv gib Slot für neues Plugin frei
			$Type3_Plugin_Handles[$x][1] = "" ;Falls nicht mehr aktiv gib Slot für neues Plugin frei

		EndIf
	Next
EndFunc   ;==>_Pruefe_ob_Type3_Plugins_noch_aktiv_sind


Func _Type3_Plugin_in_Virtuelle_INI_eintragen($Plugin_Pfad = "", $Plugin_EXE = "")
	If $Plugin_Pfad = "" Then Return
	If $Plugin_EXE = "" Then Return
	$gelesene_Platzhalter = IniRead($Plugin_Pfad & "\plugin.ini", "plugin", "isnplaceholders", "")
	If $gelesene_Platzhalter = "" Then Return ;Keine Platzhalter -> Fehler

	$Platzhalter_Array = StringSplit($gelesene_Platzhalter, "|", 2)
	For $x = 0 To UBound($Platzhalter_Array) - 1
		If $Platzhalter_Array[$x] = "" Then ContinueLoop
		If $Platzhalter_Array[$x] = "|" Then ContinueLoop
		;Werte eintragen
		_IniVirtual_Write($Type3_Plugins_Virtual_INI, $Platzhalter_Array[$x], "exe", $Plugin_EXE)
	Next
EndFunc   ;==>_Type3_Plugin_in_Virtuelle_INI_eintragen


Func _Pruefe_auf_Type3_Plugin($Platzhaltername = "")
	if $Platzhaltername = "" Then Return "false"
   if $Can_open_new_tab = 0 then return -1
	$Plugin_EXE = _IniVirtual_Read($Type3_Plugins_Virtual_INI, $Platzhaltername, "exe", "")
	If $Plugin_EXE <> "" Then
		$Plugin_INI_Pfad = StringTrimRight($Plugin_EXE, StringLen($Plugin_EXE) - StringInStr($Plugin_EXE, "\", 0, -1)) & "plugin.ini"
		$Ruechgabe_wert = _Starte_Type3_Plugin($Plugin_EXE, $Platzhaltername, IniRead($Plugin_INI_Pfad, "plugin", "waitforplugintoexit", "0"))
		Return $Ruechgabe_wert
	Else
		Return -1
	EndIf
EndFunc   ;==>_Pruefe_auf_Type3_Plugin


Func _Laufende_Type3_Plugins_Beenden()
	For $x = 0 To UBound($Type3_Plugin_Handles) - 1
		If $Type3_Plugin_Handles[$x][0] = "" Then ContinueLoop
		;Prüfe Änderungen
		_ISN_Send_Message_to_Plugin($Type3_Plugin_Handles[$x][0] , "checkchanges")
		_ISN_Wait_for_Message_from_Plugin($Type3_Plugin_Handles[$x][0] , "changesok", 60000000)

		;Plugin Beenden
		_ISN_Send_Message_to_Plugin($Type3_Plugin_Handles[$x][0] , "exit")
	Next
EndFunc   ;==>_Laufende_Type3_Plugins_Beenden

Func _Kille_Laufende_Type3_Plugins()
	_Pruefe_ob_Type3_Plugins_noch_aktiv_sind()
	For $x = 0 To UBound($Type3_Plugin_Handles) - 1
		If $Type3_Plugin_Handles[$x][0] = "" Then ContinueLoop
		If WinExists($Type3_Plugin_Handles[$x][0]) Then
			_Write_ISN_Debug_Console("Killing Type 3 Plugin with handle " & $Type3_Plugin_Handles[$x][0], 2)
			ProcessClose($Type3_Plugin_Handles[$x][0]) ;Kille Prozess falls Plugin immer noch nicht beendet hat
		 EndIf
	  $Type3_Plugin_Handles[$x][0] = ""
	  $Type3_Plugin_Handles[$x][1] = ""
	Next
EndFunc   ;==>_Kille_Laufende_Type3_Plugins


;==========================================================================================
;
; Name...........: _ISNPlugin_ArrayStringToArray
; Description ...: Wandelt einen ArrayString aus dem ISN in ein richtiges Array (1D oder 2D) um.
; Syntax.........: _ISNPlugin_ArrayStringToArray($sString, $sDelim4Rows, $sDelim4Cols)
; Parameters ....: $sString = ArrayString aus dem ISN
;                  $sDelim4Rows = Delimiter für Zeilen
;                  $sDelim4Cols = Delimiter für Spalten
; Return values .: Array (1D oder 2D)
; Author ........: guinness
; Modified.......: ISI360
; Remarks .......: Das ISN kann Arrays nicht direkt in ein Plugin senden. Daher werden Arrays zuvor in einen String umgewandelt. Im Plugin muss dieser ArrayString dann wieder in ein Array umgewandelt werden.
;==========================================================================================
Func _ISNPlugin_ArrayStringToArray($sString = "", $sDelim4Rows = ":rowdelim:", $sDelim4Cols = ":coldelim:")
	If $sString = "" Then Return
	Local $aArray = StringSplit($sString, $sDelim4Rows, 3) ; Split to get rows
	Local $iBound = UBound($aArray)

	Local $aRet[$iBound][2], $aTemp, $iOverride = 0
	For $i = 0 To $iBound - 1
		$aTemp = StringSplit($aArray[$i], $sDelim4Cols, 3) ; Split to get row items
		If Not @error Then
			If $aTemp[0] > $iOverride Then
				$iOverride = $aTemp[0]
				ReDim $aRet[$iBound][$iOverride] ; Add columns to accomodate more items
			EndIf
		EndIf

		For $j = 1 To $aTemp[0]
			$aRet[$i][$j - 1] = $aTemp[$j] ; Populate each row
		Next
	Next
	If $iOverride <= 1 Then $aRet = $aArray ; Array contains single row or column

	Return $aRet
EndFunc   ;==>_ISNPlugin_ArrayStringToArray



;==========================================================================================
;
; Name...........: _Pluginstring_get_element
; Description ...: Gibt das gewünschte Element aus einem Plugin Nachrichtenstring zurück
; Syntax.........: _Pluginstring_get_element($string,$Element)
; Parameters ....: $string - NAchricht aus dem Plugin
;                  $Element - Welches Element zurückgegeben werden soll (zero based index)
; Return values .: Text
;                  ""         - Fehler
; Author ........: ISI360
; Modified.......:
; Remarks .......: zb. _Pluginstring_get_element("123|test|xyz",1) würde "test" zurückgeben
;                 [0] = Absende PID des Plugins
;                 [1] = Befehl
;                 [2] = Data
;==========================================================================================
Func _Pluginstring_get_element($String = "", $Element = 0)
	$Split = StringSplit($String, $Plugin_System_Delimiter, 3)
	If Not IsArray($Split) Then Return ""
	If $Element > UBound($Split) - 1 Then Return ""
	Return $Split[$Element]
EndFunc   ;==>_Pluginstring_get_element




Func _ISN_Set_Variable_in_Plugin($hGUI = "", $Varname = "", $Value = "")
	If $hGUI = "" Then Return ""
	If $Varname = "" Then Return ""
	If $Value = "" Then Return ""
	If IsArray($Value) Then
		;Array
		$array_string = _ArrayToString($Value, ":rowdelim:", Default, Default, ":coldelim:")
		_ISN_Send_Message_to_Plugin($hGUI, "isn_set_var_in_plugin" & $Plugin_System_Delimiter & $Varname & $Plugin_System_Delimiter & $array_string)
	Else
		;Variable
		_ISN_Send_Message_to_Plugin($hGUI, "isn_set_var_in_plugin" & $Plugin_System_Delimiter & $Varname & $Plugin_System_Delimiter & $Value)
	EndIf
	Local $result = _ISN_Wait_for_Message_from_Plugin($hGUI,"isn_set_var_in_plugin", 5000)
	If @error Or $result = 0 Then
		Return -1
		SetError(-1)
	EndIf
	Return _Pluginstring_get_element($result, 2)
 EndFunc   ;==>_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio





Func _ISN_Wait_for_Message_from_Plugin($Plugin_Window = "",$Message = "", $Timeout = 1500)
   if $Plugin_Window = "" then return
   if $Message = "" then return
   if $Timeout = "" then return
	While 1


	   if $ISN_Studio_Plugin_Last_Received_Message <> "" Then
		   if _Pluginstring_get_element($ISN_Studio_Plugin_Last_Received_Message, 0) = $Plugin_Window AND StringLower(_Pluginstring_get_element($ISN_Studio_Plugin_Last_Received_Message, 1)) = StringLower($Message) then exitloop
	   EndIf

		$Timeout = $Timeout - 100
		if not WinExists($Plugin_Window) then $Timeout = -1 ;Plugin ist abgestürzt?!
		If $Timeout < 0 Then ExitLoop
		Sleep(100)

	WEnd
	If $Timeout < 0 Then
	   Return -1
	   SetError(-1)
    Endif
	return $ISN_Studio_Plugin_Last_Received_Message
 EndFunc

 Func _istPluginfensteraktiv()
	If $Offenes_Projekt = "" Then Return False

   ;Prüfe zuerst Type3 Plugins
   if not IsArray($Type3_Plugin_Handles) then return false
   For $x = 0 To UBound($Type3_Plugin_Handles) - 1
	  if $Type3_Plugin_Handles[$x][0] = "" then ContinueLoop
	  if $Type3_Plugin_Handles[$x][0] = WinGetHandle("[ACTIVE]") OR _WinAPI_GetAncestor(WinGetHandle("[ACTIVE]"), $GA_ROOTOWNER) = $Type3_Plugin_Handles[$x][0] then return true
   next

	If _GUICtrlTab_GetItemCount($htab) > 0 Then
		If _GUICtrlTab_GetCurFocus($htab) = -1 Then Return False
		If $Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)] = -1 Then Return False
		If WinGetProcess(WinGetHandle("[ACTIVE]")) = WinGetProcess($Plugin_Handle[_GUICtrlTab_GetCurFocus($htab)]) Then Return True
   EndIf

	Return False
EndFunc   ;==>_istPluginfensteraktiv

 Func AutoIt_Fenster_ist_aktiv()
	If $Offenes_Projekt = "" Then Return False
$active_Process = _WinAPI_ProcessGetFilename(WinGetProcess ("[ACTIVE]"))
If $active_Process = "AutoIt3.exe" OR $active_Process = "AutoIt3_x64.exe" OR $active_Process = "Autoit_Studio_Helper.exe" then return true

	Return False
EndFunc   ;==>_istPluginfensteraktiv



Func _ISN_Send_Message_to_all_Plugins($Message = "")
If $Offenes_Projekt = "" Then Return
If $Message = "" then return

;Tab Plugins
   if not IsArray($Plugin_Handle) then return
   For $x = 0 To UBound($Plugin_Handle) - 1
	  if $Plugin_Handle[$x] = "" then ContinueLoop
	  if $Plugin_Handle[$x] = "-1" then ContinueLoop
	  if WinExists($Plugin_Handle[$x]) then _ISN_Send_Message_to_Plugin($Plugin_Handle[$x],$Message)
   next

;Type 3 Plugins
   if not IsArray($Type3_Plugin_Handles) then return
   For $x = 0 To UBound($Type3_Plugin_Handles) - 1
	  if $Type3_Plugin_Handles[$x][0] = "" then ContinueLoop
	  if WinExists($Type3_Plugin_Handles[$x][0]) then _ISN_Send_Message_to_Plugin($Type3_Plugin_Handles[$x][0],$Message)
   next

EndFunc

func _Reset_all_Helperthreads()

   	;Helper Threads resetten
			$ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_Handle] = ""
			$ISN_Helper_Threads[$ISN_Helper_Testscript][$ISN_Helper_PID] = ""

Endfunc

Func _ISN_Call_Function_in_Plugin($hGUI = "", $funcname = "", $param1 = "", $param2 = "", $param3 = "", $param4 = "", $param5 = "", $param6 = "", $param7 = "")
	If $hGUI = "" Then Return 0
	If $funcname = "" Then Return 0
	$Parameter = ""
	If $param1 <> "" Then $Parameter = $Parameter & $param1 & $Plugin_System_Delimiter
	If $param2 <> "" Then $Parameter = $Parameter & $param2 & $Plugin_System_Delimiter
	If $param3 <> "" Then $Parameter = $Parameter & $param3 & $Plugin_System_Delimiter
	If $param4 <> "" Then $Parameter = $Parameter & $param4 & $Plugin_System_Delimiter
	If $param5 <> "" Then $Parameter = $Parameter & $param5 & $Plugin_System_Delimiter
	If $param6 <> "" Then $Parameter = $Parameter & $param6 & $Plugin_System_Delimiter
	If $param7 <> "" Then $Parameter = $Parameter & $param7
	If $Parameter <> "" Then $Parameter = $Plugin_System_Delimiter & $Parameter
	_ISN_Send_Message_to_Plugin($hGUI,"callfunc_in_plugin" & $Plugin_System_Delimiter & $funcname & $Parameter)
	Local $result = _ISN_Wait_for_Message_from_Plugin($hGUI, "callfunc_in_plugin", 5000)
	If @error Or $result = "" Then
		Return ""
		SetError(-1)
	EndIf
	Return _Pluginstring_get_element($result, 3)
 EndFunc   ;==>_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio


Func _ISN_Call_Async_Function_in_Plugin($hGUI = "", $funcname = "", $param1 = "", $param2 = "", $param3 = "", $param4 = "", $param5 = "", $param6 = "", $param7 = "")
	If $hGUI = "" Then Return 0
	If $funcname = "" Then Return 0
	$Parameter = ""
	If $param1 <> "" Then $Parameter = $Parameter & $param1 & $Plugin_System_Delimiter
	If $param2 <> "" Then $Parameter = $Parameter & $param2 & $Plugin_System_Delimiter
	If $param3 <> "" Then $Parameter = $Parameter & $param3 & $Plugin_System_Delimiter
	If $param4 <> "" Then $Parameter = $Parameter & $param4 & $Plugin_System_Delimiter
	If $param5 <> "" Then $Parameter = $Parameter & $param5 & $Plugin_System_Delimiter
	If $param6 <> "" Then $Parameter = $Parameter & $param6 & $Plugin_System_Delimiter
	If $param7 <> "" Then $Parameter = $Parameter & $param7
	If $Parameter <> "" Then $Parameter = $Plugin_System_Delimiter & $Parameter
	_ISN_Send_Message_to_Plugin($hGUI,"callasyncfunc_in_plugin" & $Plugin_System_Delimiter & $funcname & $Parameter)
	Return 1
 EndFunc   ;==>_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio


Func _Load_Plugins()
	FileDelete($Cachefile)
	Local $Liste_der_Erweiterten_Plugins = ""
	$Loaded_Plugins_filetypes = ""
	Local $ISN_Plugins_Standard = "%isnstudiodir%\Data\Plugins"
	$Loaded_Plugins = 0
	$Count = 0
	$Plugins_Cachefile_Virtual_INI = _IniVirtual_Initial("")
	$Type3_Plugins_Virtual_INI = _IniVirtual_Initial("") ;Type 3 Array leeren


	;Default Plugins Dir (Im Portable Mode egtl. nicht Nötig)
	if _ISN_Variablen_aufloesen($Pluginsdir) <> _ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins") then
	$Search = FileFindFirstFile(_ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\*.*"))
	if not @error then
	While 1
		$file = FileFindNextFile($Search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib(_ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file)), "D") Then
			If FileExists(_ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file & "\plugin.ini")) And _Ist_Plugin_aktiv($file) Then
			$Loaded_Plugins = $Loaded_Plugins + 1

			;Falls Plugin im Tools Menü eingetragen werden soll
			If IniRead(_ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file & "\plugin.ini"), "plugin", "toolsmenudescription", "") <> "" Then
						;Plugin ist im Tools Menü erwünscht
						$Liste_der_Erweiterten_Plugins = $Liste_der_Erweiterten_Plugins & _ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file & "\" & $file & ".exe") & "|" ;Zusätzlich zu den Erweiterten hinzufügen
			 EndIf


			;Falls Plugin einen Platzhalter besitzt -> Type 3 Plugin
			If IniRead(_ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file & "\plugin.ini"), "plugin", "isnplaceholders", "") <> "" Then
				  _Type3_Plugin_in_Virtuelle_INI_eintragen(_ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file), _ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file & "\" & $file & ".exe"))
			EndIf

				;Dateitypen eintragen (Nur bei Type 1 und 2)
				If IniRead(_ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file & "\plugin.ini"), "plugin", "filetypes", "") <> "" Then
				$filetypes = IniRead(_ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file & "\plugin.ini"), "plugin", "filetypes", "") & "|"
				$Loaded_Plugins_filetypes = $Loaded_Plugins_filetypes&$filetypes
				If $filetypes <> "" And $filetypes <> "|" Then
					While StringLen($filetypes) > 0
						$Datei = StringTrimRight($filetypes, (StringLen($filetypes) - StringInStr($filetypes, "|")) + 1)
						_IniVirtual_Write($Plugins_Cachefile_Virtual_INI, $Datei, "program", _ISN_Variablen_aufloesen($ISN_Plugins_Standard & "\" & $file & "\" & $file & ".exe")) ;Fals exe nicht gefunden wird, wird versucht die au3 zu starten
						$filetypes = StringTrimLeft($filetypes, StringInStr($filetypes, "|"))

					WEnd
				 EndIf
				 Endif
			EndIf
		EndIf
	WEnd
	FileClose($Search)
	Endif
	Endif


	;User Plugins Dir
	$Search = FileFindFirstFile(_ISN_Variablen_aufloesen($Pluginsdir & "\*.*"))
	if not @error then
	While 1
		$file = FileFindNextFile($Search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file)), "D") Then
			If FileExists(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini")) And _Ist_Plugin_aktiv($file) Then
			$Loaded_Plugins = $Loaded_Plugins + 1

			;Falls Plugin im Tools Menü eingetragen werden soll
			If IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "toolsmenudescription", "") <> "" Then
						;Plugin ist im Tools Menü erwünscht
						$Liste_der_Erweiterten_Plugins = $Liste_der_Erweiterten_Plugins & _ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\" & $file & ".exe") & "|" ;Zusätzlich zu den Erweiterten hinzufügen
			 EndIf


			;Falls Plugin einen Platzhalter besitzt -> Type 3 Plugin
			If IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "isnplaceholders", "") <> "" Then
				  _Type3_Plugin_in_Virtuelle_INI_eintragen(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file), _ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\" & $file & ".exe"))
			EndIf

				;Dateitypen eintragen (Nur bei Type 1 und 2)
				If IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "filetypes", "") <> "" Then
				$filetypes = IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "filetypes", "") & "|"
				$Loaded_Plugins_filetypes = $Loaded_Plugins_filetypes&$filetypes
				If $filetypes <> "" And $filetypes <> "|" Then
					While StringLen($filetypes) > 0
						$Datei = StringTrimRight($filetypes, (StringLen($filetypes) - StringInStr($filetypes, "|")) + 1)
						_IniVirtual_Write($Plugins_Cachefile_Virtual_INI, $Datei, "program", _ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\" & $file & ".exe")) ;Fals exe nicht gefunden wird, wird versucht die au3 zu starten
						$filetypes = StringTrimLeft($filetypes, StringInStr($filetypes, "|"))

					WEnd
				 EndIf
				 Endif
			EndIf
		EndIf
	WEnd
	FileClose($Search)
	Endif


	_Erweiterte_Plugins_Erstelle_Menue($Liste_der_Erweiterten_Plugins) ;Lade erweiterte Plugins

EndFunc   ;==>_Load_Plugins

Func _Ist_Plugin_aktiv($Ordnername = "")
$List_of_active_plugins_array = StringSplit($List_of_active_plugins,"|",2)
if not IsArray($List_of_active_plugins_array) then return false
for $count = 0 to ubound($List_of_active_plugins_array)-1
   if $List_of_active_plugins_array[$count] = "" then ContinueLoop
   if StringLower($List_of_active_plugins_array[$count]) = StringLower($Ordnername) then return true
next
return false
EndFunc


 Func _ISN_Plugin_aktivieren($Ordnername = "")
if $Ordnername = "" then return false
;Prüfe zuerst ob es nicht schon aktiv ist
$List_of_active_plugins_array = StringSplit($List_of_active_plugins,"|",2)
if IsArray($List_of_active_plugins_array) then
for $count = 0 to ubound($List_of_active_plugins_array)-1
   if $List_of_active_plugins_array[$count] = "" then ContinueLoop
   if StringLower($List_of_active_plugins_array[$count]) = StringLower($Ordnername) then return false ;Bereits aktiv
next
Endif
if StringRight($List_of_active_plugins,1) = "|" then $List_of_active_plugins = StringTrimRight($List_of_active_plugins,1)
$List_of_active_plugins = $List_of_active_plugins&"|"&$Ordnername
if StringLeft($List_of_active_plugins,1) = "|" then $List_of_active_plugins = StringTrimLeft($List_of_active_plugins,1)
if StringRight($List_of_active_plugins,1) = "|" then $List_of_active_plugins = StringTrimRight($List_of_active_plugins,1)
_Write_in_Config("active_plugins", $List_of_active_plugins)
return $List_of_active_plugins
EndFunc


Func _ISN_Plugin_deaktivieren($Ordnername = "")
if $Ordnername = "" then return false
Local $Neuer_Pluginstring = ""
Local $Plugin_Ordner = _ISN_Variablen_aufloesen($Pluginsdir)
Local $Plugin_Ordner_ISN = _ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins")
;Prüfe zuerst ob es überhaupt aktiv ist
$List_of_active_plugins_array = StringSplit($List_of_active_plugins,"|",2)
if not IsArray($List_of_active_plugins_array) then return false ;Nicht aktiv
$found_index = _ArraySearch ($List_of_active_plugins_array, $Ordnername)
if @error then return false ;Nicht aktiv
_ArrayDelete($List_of_active_plugins_array,$found_index) ;Löschen

;String bauen, und prüfen ob Plugins überhaupt noch existieren
for $count = 0 to ubound($List_of_active_plugins_array)-1
   if $List_of_active_plugins_array[$count] = "" then ContinueLoop
   if not FileExists($Plugin_Ordner&"\"&$List_of_active_plugins_array[$count]) AND not FileExists($Plugin_Ordner_ISN&"\"&$List_of_active_plugins_array[$count]) then ContinueLoop
   $Neuer_Pluginstring = $Neuer_Pluginstring&$List_of_active_plugins_array[$count]&"|"
next
if StringLeft($Neuer_Pluginstring,1) = "|" then $Neuer_Pluginstring = StringTrimLeft($Neuer_Pluginstring,1)
if StringRight($Neuer_Pluginstring,1) = "|" then $Neuer_Pluginstring = StringTrimRight($Neuer_Pluginstring,1)
$List_of_active_plugins = $Neuer_Pluginstring
_Write_in_Config("active_plugins", $List_of_active_plugins)
return $List_of_active_plugins
EndFunc


func _Pluginsordner_an_neuen_Standardordner_verschieben()
   $Quelle = _ISN_Variablen_aufloesen($Pluginsdir)
   $Ziel = _ISN_Variablen_aufloesen($Standardordner_Plugins)
   if not DirCreate($Ziel) then return
   if _FileOperationProgress($Quelle&"\*.*", $Ziel, 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION) = 1 Then
		 if not _Directory_Is_Accessible($Quelle) Then
			;Wir benötigen Admin Rechte um das alte Plugins verzeichnis zu löschen
			ShellExecuteWait(@scriptdir&'\Data\ISN_Adme.exe','"/execute FileRecycle('&"'"&$Quelle&"'"&')"',@scriptdir&"\Data")
		Else
			;Admin Rechte sind nicht nötig
		   FileRecycle($Quelle)
		 Endif
  if FileExists($Quelle) then MsgBox(262144 + 16, _Get_langstr(25),StringReplace(_Get_langstr(1312),"%1",$Quelle),0)
   $Pluginsdir = $Standardordner_Plugins
  _Write_in_Config("pluginsdir", $Pluginsdir)
   MsgBox(262144+64, _Get_langstr(61), _Get_langstr(1283),0)
  endif
EndFunc


Func _Plugins_ordner_pruefen()
if FileExists(@scriptdir&"\portable.dat") Then return
if _Config_Read("pluginsdir", "") = "" Then ;Wir haben noch kein Plugins dir...
	if FileExists(@ScriptDir&"\Data\Plugins") Then
		   $Pluginsdir = "%isnstudiodir%\Data\Plugins"
			_Write_in_Config("pluginsdir","%isnstudiodir%\Data\Plugins")
	Else
		   $Pluginsdir = $Standardordner_Plugins
			_Write_in_Config("pluginsdir", $Pluginsdir)
	Endif
Endif
if _ISN_Variablen_aufloesen($Pluginsdir) = @ScriptDir&"\Data\Plugins" Then
   if iniread($Configfile,"warnings","confirmpluginsdir","0") = 0 Then
	 MsgBox(262144 + 64, _Get_langstr(48),StringReplace(_Get_langstr(1314),"%1",_ISN_Variablen_aufloesen($Standardordner_Plugins)),0)
	 iniwrite($Configfile,"warnings","confirmpluginsdir","1")
	$Pluginsdir = $Standardordner_Plugins
	_Write_in_Config("pluginsdir", $Pluginsdir)
	DirCreate(_ISN_Variablen_aufloesen($Pluginsdir))
	_ISN_Update_Installer_aus_Package_installieren() ;Installer Updaten
   endif
Endif
EndFunc


Func _List_Plugins()
	;Neu ab 1.06. Es gibt das alte Plugins dir im ISN Verzeichnis, und ein eigenes Benutzerverzeichnis für die User Plugins
	;Das Standardverzeichnis kann nicht geändert werden.
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Pugins_Listview))

	;Suche im ISN Dir (Standard Ordner, diese Plugins gelten für alle user)
	$Search = FileFindFirstFile(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\*.*"))
	If $Search = -1 Then
		Return
	EndIf
	While 1
		$file = FileFindNextFile($Search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file)), "D") Then
			If FileExists(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file & "\plugin.ini")) Then
				$filetypes = IniRead(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file & "\plugin.ini"), "plugin", "filetypes", "") & "|"
				$IconPfad = IniRead(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file & "\plugin.ini"), "plugin", "toolsmenuiconid", "193")
				If StringInStr($IconPfad, ".ico") Then
					_GUICtrlListView_AddItem($Pugins_Listview, IniRead(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file & "\plugin.ini"), "plugin", "name", ""), _GUIImageList_AddIcon($hToolBarImageListNorm, _ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file & "\" & $IconPfad), 0))
				Else
					_GUICtrlListView_AddItem($Pugins_Listview, IniRead(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file & "\plugin.ini"), "plugin", "name", ""), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, Number($IconPfad) - 1))
				EndIf
				_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, IniRead(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file & "\plugin.ini"), "plugin", "version", ""), 1)
				_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, StringReplace(IniRead(_ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins\" & $file & "\plugin.ini"), "plugin", "filetypes", ""), "|", ", "), 2)
				If _Ist_Plugin_aktiv($file) Then
					_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, _Get_langstr(136), 3)

				Else
					_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, _Get_langstr(137), 3)
				EndIf
				_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, $file, 4)
				_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, "%isnstudiodir%\Data\Plugins\"&$file, 5)
			EndIf
		EndIf
	WEnd
	FileClose($Search)


	;Suche im User Plugins Dir
	if _ISN_Variablen_aufloesen($Pluginsdir) <> _ISN_Variablen_aufloesen("%isnstudiodir%\Data\Plugins") then
	$Search = FileFindFirstFile(_ISN_Variablen_aufloesen($Pluginsdir & "\*.*"))
	If $Search = -1 Then
		Return
	EndIf
	While 1
		$file = FileFindNextFile($Search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file)), "D") Then
			If FileExists(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini")) Then
				$filetypes = IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "filetypes", "") & "|"
				$IconPfad = IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "toolsmenuiconid", "193")
				If StringInStr($IconPfad, ".ico") Then
					_GUICtrlListView_AddItem($Pugins_Listview, IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "name", ""), _GUIImageList_AddIcon($hToolBarImageListNorm, _ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\" & $IconPfad), 0))
				Else
					_GUICtrlListView_AddItem($Pugins_Listview, IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "name", ""), _GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, Number($IconPfad) - 1))
				EndIf
				_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "version", ""), 1)
				_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, StringReplace(IniRead(_ISN_Variablen_aufloesen($Pluginsdir & "\" & $file & "\plugin.ini"), "plugin", "filetypes", ""), "|", ", "), 2)
				If _Ist_Plugin_aktiv($file) Then
					_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, _Get_langstr(136), 3)

				Else
					_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, _Get_langstr(137), 3)
				EndIf
				_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, $file, 4)
				_GUICtrlListView_AddSubItem($Pugins_Listview, _GUICtrlListView_GetItemCount($Pugins_Listview) - 1, $Pluginsdir & "\" & $file, 5)
			EndIf
		EndIf
	WEnd
	FileClose($Search)
	Endif

EndFunc   ;==>_List_Plugins

Func _load_plugindetails()
	AdlibUnRegister("_load_plugindetails")
	If _GUICtrlListView_GetSelectionMark($Pugins_Listview) = -1 Then
		GUICtrlSetState($Plugin_Button, $GUI_DISABLE)
		GUICtrlSetState($Plugin_Button2, $GUI_DISABLE)
		GUICtrlSetData($Plugin_name, _Get_langstr(142))
		GUICtrlSetData($Plugin_author, _Get_langstr(132))
		GUICtrlSetData($Plugin_version, _Get_langstr(131))
		GUICtrlSetData($Plugin_comment, _Get_langstr(133))
		GUICtrlSetData($Config_Plugin_dateitypen_label, _Get_langstr(1057))
		GUICtrlSetData($Config_Plugin_verwendeteplatzhalter_label, _Get_langstr(1055))
		GUICtrlSetImage($Plugin_ico,"")
		_SetImage($Plugin_pic, $Def_PluginPic)
		Return
	EndIf
	GUICtrlSetState($Plugin_Button, $GUI_ENABLE)
	GUICtrlSetState($Plugin_Button2, $GUI_ENABLE)
	$foldername = _GUICtrlListView_GetItemText($Pugins_Listview, _GUICtrlListView_GetSelectionMark($Pugins_Listview), 4)
	$folder_path = _GUICtrlListView_GetItemText($Pugins_Listview, _GUICtrlListView_GetSelectionMark($Pugins_Listview), 5)
	$plugin_ini_pfad = _ISN_Variablen_aufloesen($folder_path & "\plugin.ini")

	GUICtrlSetData($Plugin_name, _Get_langstr(142) & " " & IniRead($plugin_ini_pfad, "plugin", "name", ""))
	GUICtrlSetData($Plugin_author, _Get_langstr(132) & " " & IniRead($plugin_ini_pfad, "plugin", "author", ""))
	GUICtrlSetData($Plugin_version, _Get_langstr(131) & " " & IniRead($plugin_ini_pfad, "plugin", "version", ""))
	GUICtrlSetData($Plugin_comment, _Get_langstr(133) & " " & IniRead($plugin_ini_pfad, "plugin", "comment", ""))
	GUICtrlSetData($Config_Plugin_dateitypen_label, _Get_langstr(1057) & " " & StringReplace(IniRead($plugin_ini_pfad, "plugin", "filetypes", ""), "|", ", "))
	GUICtrlSetData($Config_Plugin_verwendeteplatzhalter_label, _Get_langstr(1055) & " " & StringReplace(IniRead($plugin_ini_pfad, "plugin", "isnplaceholders", ""), "|", ", "))

    ;Plugin picture
	$pic = _ISN_Variablen_aufloesen($folder_path & "\plugin.jpg")
    if not FileExists($pic) then $pic = _ISN_Variablen_aufloesen($folder_path & "\plugin.png")
    if not FileExists($pic) then $pic = _ISN_Variablen_aufloesen($folder_path & "\" &IniRead($plugin_ini_pfad, "plugin", "toolsmenuiconid", "#error#"))
	If FileExists($pic) Then
		 if StringInStr($pic,".ico") Then
			GUICtrlSetImage($Plugin_ico,$pic)
			_SetImage($Plugin_pic, "")
		 else
			GUICtrlSetImage($Plugin_ico,"")
			_SetImage($Plugin_pic, $pic)
		 Endif

	Else
	   GUICtrlSetImage($Plugin_ico,"")
		_SetImage($Plugin_pic, $Def_PluginPic)
	EndIf

	If _Ist_Plugin_aktiv($foldername) Then
		GUICtrlSetData($Plugin_Button, _Get_langstr(140))
		Button_AddIcon($Plugin_Button, $smallIconsdll, 1173, 0)
	Else
		GUICtrlSetData($Plugin_Button, _Get_langstr(141))
		Button_AddIcon($Plugin_Button, $smallIconsdll, 314, 0)
	EndIf

EndFunc   ;==>_load_plugindetails

Func _Toggle_Pluginstatus()
	If _GUICtrlListView_GetSelectionMark($Pugins_Listview) = -1 Then Return
	$oldsec = _GUICtrlListView_GetSelectionMark($Pugins_Listview)
	$foldername = _GUICtrlListView_GetItemText($Pugins_Listview, _GUICtrlListView_GetSelectionMark($Pugins_Listview), 4)
	If _Ist_Plugin_aktiv($foldername) Then
		_ISN_Plugin_deaktivieren($foldername)
	Else
		_ISN_Plugin_aktivieren($foldername)
	EndIf
	_List_Plugins()
	_GUICtrlListView_SetItemSelected($Pugins_Listview, $oldsec, True, True)
	_load_plugindetails()


EndFunc   ;==>_Toggle_Pluginstatus

Func _Delete_Plugin()
	If _GUICtrlListView_GetSelectionMark($Pugins_Listview) = -1 Then Return
	$plng = _GUICtrlListView_GetItemText($Pugins_Listview, _GUICtrlListView_GetSelectionMark($Pugins_Listview), 4)
	$plng_path = _GUICtrlListView_GetItemText($Pugins_Listview, _GUICtrlListView_GetSelectionMark($Pugins_Listview), 5)
	$plugin_ini_pfad = _ISN_Variablen_aufloesen($plng_path & "\plugin.ini")
	if $plng = "fileviewer" OR $plng = "formstudio2" OR $plng = "PLUGIN SDK" Then
	  MsgBox(262144 + 16, _Get_langstr(25),_Get_langstr(1329),0,$Config_GUI)
	 return
	EndIf
	$i = MsgBox(262144 + 4 + 32, _Get_langstr(48), _Get_langstr(144) & @CRLF & @CRLF & _Get_langstr(142) & " " & IniRead($plugin_ini_pfad, "plugin", "name", "") & @CRLF & _Get_langstr(132) & " " & IniRead($plugin_ini_pfad, "plugin", "author", "") & @CRLF & _Get_langstr(131) & " " & IniRead($plugin_ini_pfad, "plugin", "version", ""), 0, $Config_GUI)
	If $i = 6 Then
	   _ISN_Plugin_deaktivieren($plng)
		if not DirRemove(_ISN_Variablen_aufloesen($plng_path), 1) Then
			MsgBox(262144 + 16, _Get_langstr(25),StringReplace(_Get_langstr(1312),"%1",_ISN_Variablen_aufloesen($plng_path)),0,$Config_GUI)
		 EndIf
		_List_Plugins()
		_load_plugindetails()
	EndIf
 EndFunc   ;==>_Delete_Plugin



Func _ISN_Update_Installer_aus_Package_installieren()
   if FileExists(@scriptdir&"\Data\Packages\update_installer.zip") Then
	  $CurZipSize = 0
	  _UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "_UnZIP_ServiceFunc")
	  _UnZIP_SetOptions()
	  return _UnZIP_Unzip(@scriptdir&"\Data\Packages\update_installer.zip",@scriptdir)
   Endif
endfunc