
func _Show_Changelog()
	GUICtrlSetData($Changelog_GUI_Edit, "")
	guictrlsetdata($Changelog_GUI_Edit, @crlf & _Get_langstr(660) & @crlf & StringReplace($readenchangelog, "[BREAK]", @crlf) & @crlf)
	GUISetState(@SW_SHOW, $Changelog_GUI)
	GUISetState(@SW_Disable, $Update_GUI)
EndFunc

func _Hide_Changelog()
	GUISetState(@SW_ENABLE, $Update_GUI)
	GUISetState(@SW_HIDE, $Changelog_GUI)
EndFunc



func _Beginne_Suche_nach_updates()

    if FileExists($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web") then FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")

	;Teste Internetverbindung
	guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(339))
	sleep(1000) ;Waiting
	_Debug_zur_ISN_Konsole("Searching for Updates...", 1)
	if ping("www.google.com", 1000) Then
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(7) & @crlf)
	Else
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(817) & @crlf)
		_Debug_zur_ISN_Konsole("|--> Ping 1 test failed! (www.google.com)", 2)
	endif

	;Teste Verbindung zu isnetwork.at
	guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(341))
	if ping("www.isnetwork.at", 1000) Then
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(7) & @crlf)
	Else
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(817) & @crlf)
		_Debug_zur_ISN_Konsole("|--> Ping 2 test failed! (www.isnetwork.at)", 2)
	endif

	;Hole textfile
	guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(337))
	GUICtrlSetData($update_status, _Get_langstr(337))
	dircreate($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache")
	$result = Download_File("http://www.isnetwork.at/ISNUPDATE/isnupdate.web", $ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web")
	if $result == -2 Then
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(25) & @crlf)
		GUICtrlSetData($update_newversion, _Get_langstr(334) & " ?")
		GUICtrlSetData($update_status, _Get_langstr(340))
		GUICtrlSetColor($update_status, 0xFF0000)
		GUICtrlSetImage($Loading_logo, $bigiconsdll, 180)
		Button_AddIcon($update_cancelbutton, $smallIconsdll, 314, 0)
		GUICtrlSetData($update_cancelbutton, _Get_langstr(249))
		_Debug_zur_ISN_Konsole("|--> Error while searching for updates!", 3)
		return 0
	Else
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(7) & " (" & $result & " Bytes " & _Get_langstr(345) & ")" & @crlf)
	endif

	;Analysiere Textfile
	guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(346))
	if not FileExists($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web") Then
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(25) & @crlf)
		GUICtrlSetData($update_newversion, _Get_langstr(334) & " ?")
		GUICtrlSetData($update_status, _Get_langstr(340))
		GUICtrlSetColor($update_status, 0xFF0000)
		GUICtrlSetImage($Loading_logo, $bigiconsdll, 180)
		Button_AddIcon($update_cancelbutton, $smallIconsdll, 314, 0)
		GUICtrlSetData($update_cancelbutton, _Get_langstr(249))
		_Debug_zur_ISN_Konsole("|--> Error while searching for updates!", 3)
		return 0
	Else
		$readenbuild = iniread($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web", "ISNAUTOITSTUDIO", "build", "0")
		$readenversion = iniread($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web", "ISNAUTOITSTUDIO", "version", "?")
		$readenpath = iniread($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web", "ISNAUTOITSTUDIO", "path", "?")
		$readenchangelog = iniread($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web", "ISNAUTOITSTUDIO", "changelog", "")

		if $readenbuild > $VersionBuild Then
			GUICtrlSetData($update_status, _Get_langstr(344))
			guictrlsetdata($update_newversion, _Get_langstr(334) & " " & $readenversion & " (" & $readenbuild & ")")
			guictrlsetdata($Update_gefunden_GUI_gefundene_Version, _Get_langstr(334) & " " & $readenversion & " (" & $readenbuild & ")")
			GUICtrlSetColor($Update_gefunden_GUI_aktuelle_Version, 0xFF0000)
			GUICtrlSetColor($update_currentversion, 0xFF0000)
			GUICtrlSetColor($update_status, 0xFF0000)
			guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(7) & @crlf & @crlf)
			guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(343) & " " & $readenversion & " (" & $readenbuild & ")" & @crlf)
			GUICtrlSetState($update_gobutton, $GUI_ENABLE)
			GUICtrlSetState($update_changelog_button, $GUI_ENABLE)
			GUICtrlSetImage($Loading_logo, $bigiconsdll, 513)
			_Debug_zur_ISN_Konsole("|--> New update found! (" & $readenbuild & ")", 2)
			FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web")
			return 1
		Else
			guictrlsetdata($update_newversion, _Get_langstr(334) & " " & $readenversion & " (" & $readenbuild & ")")
			guictrlsetdata($Update_gefunden_GUI_gefundene_Version, _Get_langstr(334) & " " & $readenversion & " (" & $readenbuild & ")")
			guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(7) & @crlf & @crlf)
			guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(342) & @crlf)
			GUICtrlSetData($update_status, _Get_langstr(342))
			GUICtrlSetColor($update_currentversion, 0x0B9C04)
			GUICtrlSetColor($Update_gefunden_GUI_aktuelle_Version, 0x0B9C04)
			GUICtrlSetColor($update_status, 0x0B9C04)
			GUICtrlSetState($update_gobutton, $GUI_DISABLE)
			GUICtrlSetImage($Loading_logo, $bigiconsdll, 9)
			Button_AddIcon($update_cancelbutton, $smallIconsdll, 314, 0)
			GUICtrlSetData($update_cancelbutton, _Get_langstr(249))
			_ISNPlugin_Studio_Config_Write_Value("autoupdate_lastdate", _NowCalcDate())
			_Debug_zur_ISN_Konsole("|--> No update found!", 1)
			FileDelete(@scriptdir & "\Data\Cache\isnupdate.web")
			return 2
		EndIf
	endif

EndFunc

Func _ISN_AutoIt_Studio_Install_Update($file="")
	if $file = "" then return

		 ;Und los gehts..als erstes laufende ISN instanzen beenden
		 _ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Exit_Force")
		 GUISetState(@SW_HIDE, $Update_GUI)
		 GUISetState(@SW_SHOW,$Update_Warte_GUI)
		 Opt("WinTitleMatchMode", 2)
		 sleep(1000)
		 For $tieout = 30000 To 0 Step -100
		 if ProcessExists ("Autoit_Studio.exe") = 0 AND ProcessExists ($ISN_AutoIt_Studio_PID) = 0 then exitloop
		 sleep(100)
		 Next
		 Opt("WinTitleMatchMode", 1)
		 ProcessClose("Autoit_Studio.exe")
		 sleep(1000)
		 $Zu_entpackendes_Archiv = $file
		 $Zielpfad = @ScriptDir
		 $Runafter = @scriptdir&"\Autoit_Studio.exe /finishupdate"
		 $Killbefore = "Autoit_Studio.exe"

		 if not _Directory_Is_Accessible(@scriptdir&"\Data") Then
			;Wir benötigen Admin Rechte um das Update zu installieren...da hilft uns die ISN_Adme.exe
			ShellExecute(@scriptdir&'\Data\ISN_Adme.exe','"/runasadmin '&FileGetShortName(@scriptdir&"\update_installer.exe")&'" "/source '&$Zu_entpackendes_Archiv&'" "/destination '&$Zielpfad&'" "/runafter '&$Runafter&'" "/killbefore '&$Killbefore&'" "/languagefile '&$ISN_AutoIt_Studio_Languagefile_Path&'"',@scriptdir&"\Data")
		Else
			;Admin Rechte sind nicht nötig
			ShellExecute(@scriptdir&"\update_installer.exe",'"/source '&$Zu_entpackendes_Archiv&'" "/destination '&$Zielpfad&'" "/runafter '&$Runafter&'" "/killbefore '&$Killbefore&'" "/languagefile '&$ISN_AutoIt_Studio_Languagefile_Path&'"',@scriptdir&"\Data")
		 Endif
		 if @error then Msgbox(262144+16,_Get_langstr(25),_Get_langstr(359),0)

		_GDIPlus_Shutdown()
		 _USkin_Exit()
		 Exit
EndFunc


func _Do_update()
    GUICtrlSetImage($Loading_logo, $Loading2_Ani)
	guictrlsetstate($Loading_logo, $GUI_SHOW)
	GUICtrlSetState($update_gobutton, $GUI_DISABLE)
	GUICtrlSetState($update_changelog_button, $GUI_DISABLE)
	FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
	guictrlsetdata($update_log, guictrlread($update_log) & @crlf & _Get_langstr(348))
	GUICtrlSetData($update_status, _Get_langstr(348))
	GUICtrlSetColor($update_status, $Schriftfarbe)
	sleep(1500) ;Waiting
	DLLCAll("user32.dll", "int", "RedrawWindow", "hwnd", $Update_GUI, "int", 0, "int", 0, "int", 0x1)
	_Debug_zur_ISN_Konsole("|--> Downloading updatefile...", 1, 0)
	$result = Download_File($readenpath, $ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
	if $result == -2 Then
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(25) & @crlf)
		GUICtrlSetData($update_status, _Get_langstr(340))
		GUICtrlSetColor($update_status, 0xFF0000)
		GUICtrlSetImage($Loading_logo, $bigiconsdll, 180)
		_Debug_zur_ISN_Konsole("ERROR", 3, 1, 1, 1)
		return
	Else
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(7) & " (" & round($result / 1024, 0) & " KB " & _Get_langstr(345) & ")" & @crlf)
		GUICtrlSetState($update_cancelbutton, $GUI_DISABLE)
		guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(352))
		_ISNPlugin_Studio_Config_Write_Value("autoupdate_lastdate", _NowCalcDate())
		$localsize = FileGetSize($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
		$websize = $result
		sleep(500)
		if $localsize == $websize Then
			guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(7) & @crlf)
			_Debug_zur_ISN_Konsole("done", 1, 1, 1, 1)
			GUICtrlSetImage($Loading_logo, $bigiconsdll, 9)

			msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(349), 0, $Update_GUI)
			_ISN_AutoIt_Studio_Install_Update($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
			return
		Else
			guictrlsetdata($update_log, guictrlread($update_log) & _Get_langstr(25) & @crlf)
			GUICtrlSetData($update_status, _Get_langstr(340))
			GUICtrlSetColor($update_status, 0xFF0000)
			GUICtrlSetImage($Loading_logo, $bigiconsdll, 180)
			GUICtrlSetState($update_cancelbutton, $GUI_ENABLE)
			return
		EndIf
	endif
endfunc


Func Download_File($Source, $Dest)
	GUICtrlSetData($update_prgressbar, 0)
	$sUrl = $Source
	$sPath = $Dest
	If FileExists($sPath) Then
		FileDelete($Dest)
	 EndIf
	$iFileSize = InetGetSize($sUrl,1)
	$hDL = InetGet($sUrl, $sPath, 1, 1)
	Do
		$aInfo = InetGetInfo($hDL)
		$a = GUIGetCursorInfo($Update_GUI)
		if $a[4] = $update_cancelbutton AND $a[2] = 1 then
			InetClose($hDL)
			ExitLoop
		EndIf

		$iPercent = Round($aInfo[0] / $iFileSize * 100, 0)
		If $iPercent <> GUICtrlRead($update_prgressbar) Then
			GUICtrlSetData($update_prgressbar, $iPercent)
			GUICtrlSetData($update_prgressbarlabel, $iPercent & " %")
		EndIf
		Sleep(150)
	Until $aInfo[2]
	If $aInfo[3] Then
		;GUICtrlSetData($idHinweis, "erfolgreich heruntergeladen!")
		; MsgBox(0, "Fertig!", $sUrl & " wurde erfolgreich heruntergeladen!")
		GUICtrlSetData($update_prgressbar, 0)
		GUICtrlSetData($update_prgressbarlabel, "0 %")
		return $iFileSize
	Else
		; GUICtrlSetData($idHinweis, "Download nicht erfolgreich, Internetverbindung prüfen")
		; MsgBox(0, "Fehler", $sUrl & "Internetverbindung prüfen!")
		GUICtrlSetData($update_prgressbar, 0)
		GUICtrlSetData($update_prgressbarlabel, "0 %")
		return -2
	EndIf
	InetClose($hDL)
 EndFunc ;==>Download


Func _ISNHelper_Updater_exit()
   	GUISetState(@SW_HIDE, $Update_GUI)
	FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\isnupdate.web")
	FileDelete($ISN_AutoIt_Studio_Data_Directory & "\Data\Cache\update.web")
	_GDIPlus_Shutdown()
	_USkin_Exit()
	Exit
 EndFunc


 ; #FUNCTION# ;===============================================================================
;
; Name...........: _Auto_Update_jetzt_nicht
; Description ...: Blendet das Fenster "Update verfügbar" aus. Der Timer wird dabei NICHT wiedergestartet
; Syntax.........: _Auto_Update_jetzt_nicht()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: -> Nächste Prüfung ist beim erneuten Programmstart
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Auto_Update_jetzt_nicht()
	GUISetState(@SW_HIDE, $Update_gefunden_GUI)
	;Der Timer wird hier bewusst nicht mehr gestartet da die Meldung sonst wieder erscheinen würde -> Nächste erinnerung ist beim erneuten Programmstart
	_ISNHelper_Updater_exit()
EndFunc   ;==>_Auto_Update_jetzt_nicht

; #FUNCTION# ;===============================================================================
;
; Name...........: _Auto_Update_in_X_Tagen_erinnern
; Description ...: Blendet das Fenster "Update verfügbar" aus und setzte den letzten erfolgreichen Suchvorgang auf das aktuelle Datum.
; Syntax.........: _Auto_Update_in_X_Tagen_erinnern()
; Parameters ....: none
; Return values .: none
; Author ........: ISI360
; Modified.......:
; Remarks .......: Der Timer wird dabei NICHT wiedergestartet
; Related .......:
; Link ..........: http://www.isnetwork.at
; Example .......: No
;
; ;==========================================================================================

Func _Auto_Update_in_X_Tagen_erinnern()
	GUISetState(@SW_HIDE, $Update_gefunden_GUI)
	;Der Timer wird hier bewusst nicht mehr gestartet da die Meldung sonst wieder erscheinen würde -> Nächste erinnerung ist in X Tagen
	_ISNPlugin_Studio_Config_Write_Value("autoupdate_lastdate", _NowCalcDate()) ;Suche wieder in X Tagen...
	_ISNHelper_Updater_exit()
EndFunc   ;==>_Auto_Update_in_X_Tagen_erinnern
