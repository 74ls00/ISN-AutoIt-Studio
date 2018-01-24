;Globale Variablen für den Helperthread
Global $sProcess = "autoit3"
If @AutoItX64 Then Global $sProcess = $sProcess & "_x64" ; setting to "autoit3_x64.exe" for 64-bit process :)
$sProcess &= '.exe'
Global Const $AC_SRC_ALPHA = 1
Global $Leeres_Array[1] ;Leeres Array
_ArrayDelete($Leeres_Array, 0) ;Für leeres Array
Global $smallIconsdll = @scriptdir & "\data\smallIcons.dll"
Global $bigiconsdll = @scriptdir & "\data\grandIcons.dll"
Global $Skin_is_used = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Skin_is_used")
Global $poCounter ;dummy
Global $_PDH_iCPUCount ;dummy
Global $iProcessID
Global $ISN_Dark_Mode = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$ISN_Dark_Mode")
Global $RUNNING_SCRIPT
Global $aCPUCounters=""
Global $iTotalCPUs=""
Global $hPDHQuery=""
Global $AutoIt3Wrapper_exe_path=""
Global $Clientsize_diff_width = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Clientsize_diff_width")
Global $Clientsize_diff_height = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Clientsize_diff_height")
Global $autoitexe =""
Global $DPI = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$DPI")
Global $starttime
Global $Studioversion
Global $readenpath
Global $readenchangelog
Global $autoupdate_searchtimer
Global $GUIMINWID = 640, $GUIMINHT = 480 ;Default für alle Fenster
Global $Programmupdate_width = 0, $Programmupdate_height = 0
Global $VersionBuild
Global $Erweitertes_debugging = _ISNPlugin_Studio_Config_Read_Value("enhanced_debugging", "false")
Global $starte_Skripts_mit_au3Wrapper = _ISNPlugin_Studio_Config_Read_Value("run_scripts_with_au3wrapper", "false")
Global $showdebuggui = _ISNPlugin_Studio_Config_Read_Value("showdebuggui", "true")
Global $Runonmonitor = _ISNPlugin_Studio_Config_Read_Value("runonmonitor", "1")
Global $Immer_am_primaeren_monitor_starten = _ISNPlugin_Studio_Config_Read_Value("run_always_on_primary_screen", "true")
Global $__MonitorList[1][5]
Global $Default_font = _ISNPlugin_Studio_Config_Read_Value("default_font", "Segoe UI")
Global $Default_font_size = _ISNPlugin_Studio_Config_Read_Value("default_font_size", "8.5")
Global $Fenster_Hintergrundfarbe = 0xFFFFFF
Global $Titel_Schriftfarbe = 0x003399
Global $Schriftfarbe = 0x000000
Global $skin = _ISNPlugin_Studio_Config_Read_Value("skin", "#none#")
_GetMonitors() ;Lese Monitore ($__MonitorList wird dadurch befüllt)
Global $Loading1_Ani = @scriptdir & "\data\isn_loading_1.ani"
Global $Loading2_Ani = @scriptdir & "\data\isn_loading_2.ani"
Global $proxy_server = _ISNPlugin_Studio_Config_Read_Value("proxy_server", "")
Global $proxy_port = _ISNPlugin_Studio_Config_Read_Value("proxy_port", "8080")
Global $proxy_username = _ISNPlugin_Studio_Config_Read_Value("proxy_username", "")
Global $proxy_PW = _ISNPlugin_Studio_Config_Read_Value("proxy_PW", "")
Global $Use_Proxy = _ISNPlugin_Studio_Config_Read_Value("Use_Proxy", "false")

Global $Programmupdate_width = (532*$DPI)+$Clientsize_diff_width, $Programmupdate_height = (430*$DPI)+$Clientsize_diff_height
Global $Changelog_GUI_width = (820*$DPI)+$Clientsize_diff_width, $Changelog_GUI_height = (490*$DPI)+$Clientsize_diff_height



If $ISN_Dark_Mode = "true" Then
	;Setze Farben für Dark Mode
	$Loading1_Ani = $Loading2_Ani
	$Fenster_Hintergrundfarbe = 0x414141
	$Titel_Schriftfarbe = 0xFFFFFF
	$Schriftfarbe = 0xFFFFFF
EndIf