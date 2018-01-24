;Alle wichtige Variablen für das ISN

;Schönes Grün: GUICtrlSetBkColor(-1,0xAAEE99)
;Schönes Orange: GUICtrlSetBkColor(-1,0xEEaa44)

;ISN Debug Console Const
;Syntax: $String,$level=2,$break=1,$notime=0,$notitle=0
Global const $ISN_Debug_Console_Errorlevel_Text_only = 0
Global const $ISN_Debug_Console_Errorlevel_Info = 1
Global const $ISN_Debug_Console_Errorlevel_Warning = 2
Global const $ISN_Debug_Console_Errorlevel_Critical = 3
Global const $ISN_Debug_Console_Linebreak = 1
Global const $ISN_Debug_Console_No_Linebreak = 0
Global const $ISN_Debug_Console_Insert_Time = 0
Global const $ISN_Debug_Console_No_Time = 1
Global const $ISN_Debug_Console_No_Title = 1
Global const $ISN_Debug_Console_Insert_Title = 0
Global const $ISN_Debug_Console_Category_Plugin = "plugin"
Global const $ISN_Debug_Console_Category_Hotkey = "hotkey"


Global $ISN_Studio_Plugin_Last_Received_Message = ""

Global Const $ISN_Helper_Testscript = 0
Global Const $ISN_Helper_Updater = 1
Global Const $ISN_Helper_Handle = 0
Global Const $ISN_Helper_PID = 1
Global $ISN_Helper_Threads[2][3]
$ISN_Helper_Threads[0][0] = "testscript"
$ISN_Helper_Threads[1][0] = "updater"


;-----------------------------------Allgemein-----------------------------------
Global $hGUI, $iX_Min = 0, $iX_Max = 0, $iY_Min = 0, $iY_Max = 0
Global $DesktopDimensions_Array = _DesktopDimensions()
if IsArray($DesktopDimensions_Array) then
   $iX_Max = $DesktopDimensions_Array[3]-50
   $iY_Max = $DesktopDimensions_Array[4]-50
EndIf
Global $Configfile = ""
if FileExists(@scriptdir&"\portable.dat") then
$Configfile = @scriptdir & "\data\config.ini"
Else
$Configfile = RegRead ("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Configfile")
FileDelete(@scriptdir&"\portable.dat")
endif



;-----------------------------------DPI SCALING-----------------------------------
Global $DPI = 1
if _Config_Read("enable_custom_dpi_value", "false") = "true" then
   $DPI = number(_Config_Read("custom_dpi_value", 1))
Else
   $DPI = _GetDPI() ;Aus Windows hohlen
endif
if _Config_Read("highDPI_mode", "true") <> "true" then $DPI = 1 ;1 = Def 100% value
Global $Titel_DPI_Dif = 0
if $DPI <> 1 then $Titel_DPI_Dif = $DPI*3


;Minimale Fenstergrößen (Angaben im DPI Wert 1 (100%))
;Berechne client size unterschiede
$tmp_GUI = GUICreate("tmp",625,400,-1,-1,BitOr($WS_POPUP,$WS_CAPTION,$WS_SIZEBOX,$WS_MAXIMIZEBOX),-1)
$Clientsize_diff_client_size_array = WinGetClientSize($tmp_GUI)
$Clientsize_diff_winpos_array = WinGetPos($tmp_GUI)
Global $Clientsize_diff_width = 16, $Clientsize_diff_height = 39 ;Def werte
if IsArray($Clientsize_diff_client_size_array) AND IsArray($Clientsize_diff_winpos_array) then
   $Clientsize_diff_width = $Clientsize_diff_winpos_array[2]-$Clientsize_diff_client_size_array[0]
   $Clientsize_diff_height = $Clientsize_diff_winpos_array[3]-$Clientsize_diff_client_size_array[1]
endif
GUIDelete($tmp_GUI)
Global Const $Plugin_System_Delimiter = "|-ISN-|"
Global $Current_Language_Array = ""
Global $Fallback_Language_Array = ""
Global $Autoit_Studio_Helper_exe = @scriptdir&"\Autoit_Studio_Helper.exe"
Global $GUIMINWID = 640, $GUIMINHT = 480 ;Default für alle Fenster
Global $Programmeinstellungen_width = (1013*$DPI)+$Clientsize_diff_width, $Programmeinstellungen_height = (710*$DPI)+$Clientsize_diff_height
Global $Neues_Projekt_width = (474*$DPI)+$Clientsize_diff_width, $Neues_Projekt_height = (645*$DPI)+$Clientsize_diff_height
Global $Projektverwaltung_width = (997*$DPI)+$Clientsize_diff_width, $Projektverwaltung_height = (720*$DPI)+$Clientsize_diff_height
Global $Projekteinstellungen_width = (1081*$DPI)+$Clientsize_diff_width, $Projekteinstellungen_height = (668*$DPI)+$Clientsize_diff_height
Global $Makros_width = (804*$DPI)+$Clientsize_diff_width, $Makros_height = (454*$DPI)+$Clientsize_diff_height
Global $Weitere_Farben_width = (401*$DPI)+$Clientsize_diff_width, $Weitere_Farben_height = (371*$DPI)+$Clientsize_diff_height
Global $Suchen_und_ersetzen_width = (510*$DPI)+$Clientsize_diff_width, $Suchen_und_ersetzen_height = (200*$DPI)+$Clientsize_diff_height
Global $Skriptbaumfilter_width = (639*$DPI)+$Clientsize_diff_width,$Skriptbaumfilter_height = (511*$DPI)+$Clientsize_diff_height
Global $Startparameter_width = (604*$DPI)+$Clientsize_diff_width,$Startparameter_height = (299*$DPI)+$Clientsize_diff_height
Global $makro_waehlen_width =( 524*$DPI)+$Clientsize_diff_width,$makro_waehlen_height = (381*$DPI)+$Clientsize_diff_height
Global $makro_bearbeiten_width = (958*$DPI)+$Clientsize_diff_width,$makro_bearbeiten_height = (480*$DPI)+$Clientsize_diff_height
Global $aenderungsprotokolle_width = (899*$DPI)+$Clientsize_diff_width,$aenderungsprotokolle_height = (639*$DPI)+$Clientsize_diff_height
Global $aenderungsprotokolle_neuer_eintrag_width = (625*$DPI)+$Clientsize_diff_width,$aenderungsprotokolle_neuer_eintrag_height = (400*$DPI)+$Clientsize_diff_height
Global $aenderungsprotokolle_bericht_width = (1024*$DPI)+$Clientsize_diff_width, $aenderungsprotokolle_bericht_height = (724*$DPI)+$Clientsize_diff_height
Global $bugtracker_width = (800*$DPI)+$Clientsize_diff_width, $bugtracker_height = (500*$DPI)+$Clientsize_diff_height
Global $parameter_editor_width = (635*$DPI)+$Clientsize_diff_width, $parameter_editor_height = (581*$DPI)+$Clientsize_diff_height
Global $Funclist_GUI_width = (359*$DPI)+$Clientsize_diff_width, $Funclist_GUI_height = (485*$DPI)+$Clientsize_diff_height
Global $ISNSTudio_debug_width = (540*$DPI)+$Clientsize_diff_width, $ISNSTudio_debug_height = (501*$DPI)+$Clientsize_diff_height
Global $pelock_obfuscator_GUI_width = (897*$DPI)+$Clientsize_diff_width,$pelock_obfuscator_GUI_height = (686*$DPI)+$Clientsize_diff_height
Global $ExecuteCommandRuleConfig_GUI_width = (566*$DPI)+$Clientsize_diff_width, $ExecuteCommandRuleConfig_GUI_height = (150*$DPI)+$Clientsize_diff_height
Global $TemplateNEU_width = (350*$DPI)+$Clientsize_diff_width, $TemplateNEU_height = (220*$DPI)+$Clientsize_diff_height
Global $ToDo_Liste_neuer_eintrag_GUI_width = (625*$DPI)+$Clientsize_diff_width, $ToDo_Liste_neuer_eintrag_GUI_height = (400*$DPI)+$Clientsize_diff_height
Global $ToDoList_Manager_width = (985*$DPI)+$Clientsize_diff_width, $ToDoList_Manager_height = (606*$DPI)+$Clientsize_diff_height
Global $macro_runscriptGUI_width = (594*$DPI)+$Clientsize_diff_width, $macro_runscriptGUI_height = (432*$DPI)+$Clientsize_diff_height
Global $rulecompileconfig_gui_width = (606*$DPI)+$Clientsize_diff_width, $rulecompileconfig_gui_height = (376*$DPI)+$Clientsize_diff_height
Global $rule_fileoperation_configgui_width = (610*$DPI)+$Clientsize_diff_width, $rule_fileoperation_configgui_height = (380*$DPI)+$Clientsize_diff_height
Global $msgboxcreator_rule_width = (454*$DPI)+$Clientsize_diff_width, $msgboxcreator_rule_height = (637*$DPI)+$Clientsize_diff_height
Global $runfile_config_width = (466*$DPI)+$Clientsize_diff_width, $runfile_config_height = (363*$DPI)+$Clientsize_diff_height
Global $parameter_GUI_rule_width = (604*$DPI)+$Clientsize_diff_width, $parameter_GUI_rule_height = (305*$DPI)+$Clientsize_diff_height
Global $addlog_GUI_width = (547*$DPI)+$Clientsize_diff_width, $addlog_GUI_height = (316*$DPI)+$Clientsize_diff_height
Global $stausbar_Set_GUI_width = (604*$DPI)+$Clientsize_diff_width, $stausbar_Set_GUI_height = (155*$DPI)+$Clientsize_diff_height
Global $Tabseite_hoehe = 24
Global $Linker_Splitter_Y_default = 70
Global $Linker_Splitter_X_default = 15
Global $Mittlerer_Splitter_Y_default = 55
Global $Rechter_Splitter_X_default = 80

;-----------------------------------DIVERSES-----------------------------------
Global $Leeres_Array[1] ;Leeres Array
_ArrayDelete($Leeres_Array, 0) ;Für leeres Array

Global $Arbeitsverzeichnis = "";Wichtig ab Version 0.9 -> Hier "arbeitet" das ISN (Konfiguration, alle cache Dateien, Standardpfad für projekte und co.)
if FileExists(@scriptdir&"\portable.dat") Then
Global $Arbeitsverzeichnis = @scriptdir
Else
Global $Arbeitsverzeichnis = _Finde_Arbeitsverzeichnis()
endif
Global $Standardordner_Plugins = "%myisndatadir%\Data\Plugins"
Global $Standardordner_Projects = "%myisndatadir%\Projects"
Global $Standardordner_Backups = "%myisndatadir%\Backups"
Global $Standardordner_Release = "%myisndatadir%\Release"
Global $Standardordner_Templates = "%myisndatadir%\Templates"
$Erstkonfiguration_Mode = ""
if FileExists(@scriptdir&"\portable.dat") Then
Global $Erstkonfiguration_Mode = "portable" ;normal oder portable modus für erstkonfiguration
Else
Global $Erstkonfiguration_Mode = "normal" ;normal oder portable modus für erstkonfiguration
endif
Global $__MonitorList[1][5]
Global $Pfad_zur_Project_ISN = "" ;Pfad zur .isn Datei des Projektes (vormals project.isn)
Global $smallIconsdll = @scriptdir & "\data\smallIcons.dll"

Global $ISN_IconsDLL = @scriptdir & "\data\Test.dll"

Global $AutoIt3Wrapper_exe_path = @scriptdir&"\Data\AutoIt3Wrapper\AutoIt3Wrapper.au3"
Global $foldingfile = $Arbeitsverzeichnis & "\data\cache\folding.ini"
Global $bigiconsdll = @scriptdir & "\data\grandIcons.dll"
Global $Cachefile = $Arbeitsverzeichnis & "\data\cache\cache" & int(random(123)) & ".dat" ;For Multisession
Global $Backupcache = $Arbeitsverzeichnis & "\data\cache\backup" & int(random(123)) & ".dat" ;For Multisession
Global $Offenes_Projekt = "" ;Pfad zum Geöffneten Projekt
Global $Offenes_Projekt_name = "" ;Name des geöffneten Projektes
Global $Studiofenster = "" ;dummy
Global $Templatemode = 0 ;1 wenn template bearbeitet wird
Global $Tempmode = 0 ;1 wenn in einem Temporären Projekt gearbeitet wird
Global $XButton_Location = @ScriptDir & "\Data"
Global $Pos_M2 = MouseGetPos()
Global $Offene_tabs = 0
Global $Auto_Update_Timer_Handle
Global $start
Global $n = 0
Global $Tabswitch_last_Tab = 0
Global $Aktuell_aktiver_Tab = 0
Global $Last_Used_Scintilla_Control = ""
Global $ISN_Restart_initiated = 0
Global $hImageList = 0
Global $Starte_Auskommentierung = 0
Global $MousePos = True
Global $clickspeed = RegRead("HKEY_CURRENT_USER\Control Panel\Mouse", "DoubleClickSpeed")
Global $SCE_EDITOR[30] ;max 30 Tabs
Global $Plugin_Handle[30] ;max 30 Tabs
Global $Plugins_Cachefile_Virtual_INI = _IniVirtual_Initial("") ;Virtuelle Ini Datei für normale Plugins
Global $Type3_Plugins_Virtual_INI = _IniVirtual_Initial("") ;Virtuelle Ini Datei für Type3 Plugins
Global $Type3_Plugin_Handles[9][2] ;max 10 Type 3 Plugins
Global $new_projectvorlage_combo_ARRAY[100]
Global $neue_Datei_erstellen_Vorlagendatei_combo_ARRAY[100]
Global $FILE_CACHE[30]
Global $Datei_pfad[30]
Global $Combo_Sprachen[20]
Global Const $HTTP_STATUS_OK = 200
Global $Can_open_new_tab = 1 ;Wenn 1 kann ein neuer Tab geöffnet werden, bei 0 nicht
Global $Tabs_closing = 0 ;Wenn 1 werden gerade alle tabs geschlossen
Global $Autoitextension = "au3"
Global $aStrings[40]
Global Const $Delim = '\', $Delim1 = '|'
Global $dll = DllOpen("user32.dll")
Global $user32 = DllOpen("user32.dll")
Global $kernel32 = DllOpen("kernel32.dll")
Global $hlStart, $hlEnd, $sCallTip
Global Enum $MARGIN_SCRIPT_NUMBER = 0, $MARGIN_SCRIPT_ICON, $MARGIN_SCRIPT_FOLD
Global $Splitter_Breite = 5 ;Breite eines Controlsplitters
Global $Splitter_Rand = 3 ;Rand zwischen einem Control und dem Controlsplitter
Global $Splitter_Minimale_Groesse = 100 ;Minimale Groesse die ein Control im Splittersystem haben kann
Global Enum $id1 = 6000, $id2, $id3, $id4, $id5, $id6, $id7, $id8, $id9, $id10, $id11, $id12, $id13, $id14, $id15, $id16, $id17, $id18, $id19, $id20, $id21, $id22, $id23, $id24, $id25, $id26, $id27, $id28, $id29,$Toolbar_makroslot6,$Toolbar_makroslot7, $Kontextmenu_tempau3file, $Toolbarmenu1, $Toolbarmenu2, $Toolbarmenu3, $Toolbarmenu4, $Toolbarmenu5, $Toolbarmenu_project1, $Toolbarmenu_project2, $Toolbarmenu_project3, $Toolbarmenu_compile1, $Toolbarmenu_compile2, $Toolbarmenu_compile_daten_waehlen, $Toolbarmenu_aenderungsprotokoll,$Toolbarmenu_programmeinstellungen,$Toolbarmenu_Farbtoolbox,$Toolbarmenu_closeproject,$Toolbarmenu_pluginslot1,$Toolbarmenu_pluginslot2,$Toolbarmenu_pluginslot3,$Toolbarmenu_pluginslot4,$Toolbarmenu_pluginslot5,$Toolbarmenu_pluginslot6,$Toolbarmenu_pluginslot7,$Toolbarmenu_pluginslot8,$Toolbarmenu_pluginslot9,$Toolbarmenu_pluginslot10,$Toolbarmenu_projekteinstellungen
Global $Def_PluginPic = @scriptdir & "\data\plugin.png"
Global $FilechooseFilter = ""
Global $TROPHYPNG = ""
Global $SciteKeyWord
Global $SCI_sCallTip_Array
Global $ID_Holder_For_ruleiconconfig = 0
Global $Idle_Timer
Global $FindInFile_iPID
Global $pos ;dummy
Global $Config_GUI ;dummy
Global $hReBar ;dummy
Global $Choose_File_Treeview ;dummy
Global $Input_config_au3exe ;dummy
Global $Input_config_au2exe ;dummy
Global $Input_config_Au3Checkexe ;dummy
Global $Input_config_Au3Stripperexe ;dummy
Global $Input_config_Tidyexe ;dummy
Global $Input_config_Au3Infoexe ;dummy
Global $Input_config_helpfile ;dummy
Global $hroot ;dummy
Global $Maus_ueber_Item ;dummy
Global $hroot2 ;dummy
Global $hroot3 ;dummy
Global $Choose_File_hTreeview ;dummy
Global $Welcome_GUI ;dummy
Global $Credits_Srollbox ;dummy
Global $Funclist_GUI ;dummy
Global $CreditsGUI ;dummy
Global $CreditsGUI2 ;dummy
Global $Hyperlink_Old_Control
Global $Listview_Drag_aktiv = 0
Global $Hyperlink_unterstrichen = 0
Global $functiontree ;dummy
Global $globalvariablestree ;dummy
Global $includestree ;dummy
Global $regionstree ;dummy
Global $localvariablestree ;dummy
Global $hroot_forms ;dummy
Global $UDF_Keywords ;dummy
Global $special_Keywords ;dummy
Global $hWndGUI ;dummy
Global $MsgID ;dummy
Global $ilParam ;dummy
Global $hTreeview ;dummy
Global $starttime ;dummy
Global $poCounter ;dummy
Global $_PDH_iCPUCount ;dummy
Global $HSplitter_1 ;dummy
Global $HSplitter_2 ;dummy
Global $VSplitter_1 ;dummy
Global $VSplitter_2 ;dummy
Global $Status_bar ;dummy
Global $Debug_log ;dummy
Global $ToDo_Liste_Kategorie_loaschen_Combo
Global $TreeviewContextMenu_Item_PELock_Obfuscator ;dummy
Global $TreeviewContextMenu ;dummy
Global $TreeviewContextMenu_makroslot1 = "";dummy
Global $TreeviewContextMenu_makroslot2 = "" ;dummy
Global $TreeviewContextMenu_makroslot3 = "" ;dummy
Global $TreeviewContextMenu_makroslot4 = "" ;dummy
Global $TreeviewContextMenu_makroslot5 = "" ;dummy
Global $TreeviewContextMenu_makroslot6 = "" ;dummy
Global $TreeviewContextMenu_makroslot7 = "" ;dummy
Global $Finde_Element_im_Skript_letztes_Wort
Global $Finde_Element_im_Skript_letzte_Position
Global $Hotkey_Keycode_Speichern
Global $Hotkey_Keycode_Speichern_unter
Global $Hotkey_Keycode_Speichern_Alle_Tabs
Global $Hotkey_Keycode_Tidy
Global $Hotkey_Keycode_tab_schliessen
Global $Hotkey_Keycode_vorheriger_tab
Global $Hotkey_Keycode_naechster_tab
Global $Hotkey_Keycode_vollbild
Global $Hotkey_Keycode_auskommentieren
Global $Hotkey_Keycode_befehlhilfe
Global $Hotkey_Keycode_springezuzeile
Global $Hotkey_Keycode_zeigefehler
Global $Hotkey_Keycode_syntaxcheck
Global $Hotkey_Keycode_zeile_duplizieren
Global $Hotkey_Keycode_compile
Global $Hotkey_Keycode_compile_Settings
Global $Hotkey_Keycode_testeskript
Global $Hotkey_Keycode_Suche
Global $Hotkey_Keycode_Testprojekt
Global $Hotkey_Keycode_Testprojekt_ohne_Parameter
Global $Hotkey_Keycode_Neue_Datei
Global $Hotkey_Keycode_Oeffnen
Global $Hotkey_Keycode_Makroslot1
Global $Hotkey_Keycode_Makroslot2
Global $Hotkey_Keycode_Makroslot3
Global $Hotkey_Keycode_Makroslot4
Global $Hotkey_Keycode_Makroslot5
Global $Hotkey_Keycode_Makroslot6
Global $Hotkey_Keycode_Makroslot7
Global $Hotkey_Keycode_debugtomsgbox
Global $Hotkey_Keycode_debugtoconsole
Global $Hotkey_Keycode_erstelleUDFheader
Global $Hotkey_Keycode_msgBoxGenerator
Global $Hotkey_Keycode_AutoIt3WrapperGUI
Global $Hotkey_Keycode_Farbtoolbox
Global $Hotkey_Keycode_Fensterinfotool
Global $Hotkey_Keycode_organizeincludes
Global $Hotkey_Keycode_Automatisches_Backup
Global $Hotkey_Keycode_bitrechner
Global $Hotkey_Keycode_Oeffne_Include
Global $Hotkey_Keycode_Datei_umbenennen
Global $Hotkey_Keycode_Weitersuchen
Global $Hotkey_Keycode_Rueckwaerts_Weitersuchen
Global $Hotkey_Keycode_Aenderungsprotokolle
Global $TreeviewContextMenu_Item1
Global $TreeviewContextMenu_Oeffnen_Mit
Global $TreeviewContextMenu_Oeffnen_Mit_Script_Editor
Global $TreeviewContextMenu_Oeffnen_Mit_Windows
Global $TreeviewContextMenu_Item2
Global $TreeviewContextMenu_Item3
Global $TreeviewContextMenu_Item4
Global $TreeviewContextMenu_Item9
Global $TreeviewContextMenu_Item10
Global $TreeviewContextMenu_Item5
Global $TreeviewContextMenu_Item7
Global $TreeviewContextMenu_Item6
Global $TreeviewContextMenu_Item6a
Global $TreeviewContextMenu_Item8_Item2
Global $TreeviewContextMenu_Item8_Item1
Global $TreeviewContextMenu_Item8_a
Global $TreeviewContextMenu_temp_au3_file
Global $TreeviewContextMenu_Item8_b
Global $TreeviewContextMenu_Item8_c
Global $TreeviewContextMenu_Item8_d
Global $TreeviewContextMenu_Item_Projektbaum_aktualisieren
Global $TreeviewContextMenu_Item_Kompilieren
Global $TreeviewContextMenu_Item_Jetzt_Kompilieren
Global $TreeviewContextMenu_Item_Makro_kompilieren_neu
Global $TreeviewContextMenu_Item_Makro_kompilieren_bestehend
Global $SCI_Autocompletelist_backup
Global $Changelog_Section = "ISNPROJECT_CHANGELOGDATA"
Global $Benoetigte_Zeit = 0 ;Benötigte Zeit in ms des zuletzt geschlossenen Projektes
Global $Pixstring = "" ;Nummern für Pixmaps
Global $Letzter_Hotkey = "" ;Zuletzt gedrückter Hotkey (internal use)
Global $readenchangelog
Global $SCIE_letzter_calltipp ;Letzter Calltip des au3 Editors (benötigt für farbauswahl)
Global $SCIE_letzte_pos ;Letzte Pos des Calltips (benötigt für farbauswahl)
Global $SCIE_letzte_zeile ;Letzte gewählte zeile des au3 Editors (benötigt zum killen der farbauswahl falls sich zeile ändert)
Global $Tidy_is_running = 0
Global $Console_Bluemode = 0 ;wenn 1 wird der standaarttext in blauer farbe geschrieben
Global $tagSCNotification = "int;int;int;int;int;int;int;ptr;int;int;int;int;int;int;int;int;int;int;int"
Global $controlGui = ""
Global $hImageTROP = ""
Global $Parameter_Editor_Laedt_gerade_text = 0
Global $found = 0
Global $iItem
Global $Parameter_Editor_Startpos = 0
Global $Parameter_Editor_Endpos = 0
Global $Parameter_SCE_HANDLE = ""
Global $marker_handle = ""
Global $Name_der_Func_die_bearbeitet_wird = ""
Global $Skriptbaum_markiertes_Element_vor_Reload = ""
Global Const $AC_SRC_ALPHA = 1
Global $Tbar = GUICtrlCreateDummy() ; dummy control to receive toolbar events
Global $TbarMenu = GUICtrlCreateDummy() ; dummy control to receive toolbar button dropdown menu events
Global Const $TBDDRET_DEFAULT = 0
Global Const $TBDDRET_NODEFAULT = 1
Global Const $TBDDRET_TREATPRESSED = 2
Global $Treeview_include_handle ;wird benötigt für contextmenü
Global $_OPT_FIND_WRAPAROUND = True
Global $findWhat = ""
Global $last_scripttree_jumptosearch = ""
Global $reverseDirection = False
Global $showWarnings = False
Global $flags = 0
Global $SKRIPT_LAUEFT = 0 ;1 Wenn skript oder Projekt gestartet wurde
GLOBAL $RUNNING_SCRIPT ;PID des laufenden skripts
Global $Control_Flashes = 0 ;1 wenn ein error gerade in einem input angezeigt wird (s. _Input_Error_FX() )
Global $Project_timer ;Zeit die am Projekt gearbeitet wird
Global $Projekt_Timer_pausiert = 0 ;1 wenn der Timer gerade Pausiert ist (Wenn zb. das ISN nicht aktiv ist)
Global $Pause_time = 0 ;Zeit indem das ISN nicht aktiv ist
global $OLD_Y = 0
global $OLD_X = 0
global $Loaded_Plugins = 0
global $Loaded_Plugins_filetypes = ""
global $IS_HIDDEN_RECHTS = 0
global $IS_HIDDEN_UNTEN = 0
Global $F4_Fehler_aktuelle_Zeile = 0
global $Fenster_unten_durch_toggle_versteckt = 0
Global $Geheimcount = 0
Global $Fulscreen_Mode = 0
Global $Kompilieren_laeuft = 0
Global $FilechooseFilter = ""
Global $Treeview_Search_LastSearch = ""
Global $Treeview_Search_count = 0
Global $gaDropFiles[1], $str = ""
Global $Monitor_Aufloesung[2]
Global $Toggle_Leftside = 0
Global $Toggle_rightside = 0
Global $Projektbaum_Treeview_Expanded_Array[200]
Global $Scripttree_Treeview_Expanded_Array[200]
Global $Projektbaum_Treeview_Expanded_Array_empty[200]
Global $AllWords_empty[9000000]
Global Const $SCI_DEFAULTKEYWORDDIR = @ScriptDir & "\Data\Properties\" ;"C:\Programme\AutoIt3\SciTE\Properties\"
Global Const $SCI_DEFAULTCALLTIPDIR = @ScriptDir & "\Data\Api\" ;"C:\Programme\AutoIt3\SciTE\api\"
Global Const $SCI_DEFAULTABBREVDIR = @ScriptDir & "\Data\Properties\" ;@UserProfileDir
Global $SCI_hlStart, $SCI_hlEnd, $SCI_sCallTip, $SCI_sCallTipFoundIndices, $SCI_sCallTipSelectedIndice, $SCI_sCallTipPos
Global $SCI_sCallTip_Array[1], $SCI_AUTOCLIST[1], $SCI_ABBREVFILE
Global $au3_keywords_functions
Global $au3_keywords_udfs
Global $UDF_Keywords
Global $special_Keywords
Global $au3_keywords_keywords
Global $au3_keywords_macros
Global $au3_keywords_preprocessor
Global $au3_keywords_special
Global $au3_keywords_sendkeys
Global $au3_keywords_abbrev
Global $autoit3wrapper_keywords_special
Global $ISN_Hotkey_Hook_aktiv = 0
Global $sPCName = "" ; "\\PCNAME"
Global $sProcess = "autoit3"
If @AutoItX64 Then Global $sProcess = $sProcess & "_x64" ; setting to "autoit3_x64.exe" for 64-bit process :)
$sProcess &= '.exe'
Global $size_before_resize
Global $ahIcons[30], $ahLabels[30]
Global $iStartIndex = 1, $iCntRow, $iCntCol, $iCurIndex
Global $sFilename = $smallIconsdll ; Default file is "shell32.dll"
Global $iOrdinal = -1
Global $Studiomodus = 1 ;In welchem Modus läuft ISN (Projektmodus oder Editormodus), 1=Projekt; 2=Editor
Global $Weitere_Dateien_Kompilieren_GUI_Treeview
Global $Weitere_Dateien_Kompilieren_GUI_hTreeview
Global $Automatische_Speicherung_eingabecounter = 0
Global $RDC_Main_Thread = 0
Global $RDC_sEvents = ''
Global $KeyWordList[7][7] = [['If', 'EndIf'], ['While', 'WEnd'], ['For', 'Next'], ['Do', 'Until'], ['Select', 'EndSelect'], ['Func', 'EndFunc'], ['Switch', 'EndSwitch']]
;Set Backupdir for Tidy (bugfix)
$alter_tidy_eintrag = iniread(@scriptdir & "\Data\Tidy\tidy.ini", "ProgramSettings", "backupDir", "")
if $alter_tidy_eintrag = @scriptdir & "\Data\Tidy\Backup" then iniwrite(@scriptdir & "\Data\Tidy\tidy.ini", "ProgramSettings", "backupDir", "")
if $alter_tidy_eintrag = "I:\autoit\ProjektX\ISN AutoIt Studio\Data\Tidy\Backup " then iniwrite(@scriptdir & "\Data\Tidy\tidy.ini", "ProgramSettings", "backupDir", "")
Global $Toolbars_Aktuelles_Layout = "" ;Möglich sind: none, au3, text, plugin
Global $Springe_zu_Func_Letzte_Suche = ""
Global $Springe_zu_Func_Letzte_Pos = ""

;Platzhalternamen für Type 3 Plugins
Global $Plugin_Platzhalter_Parametereditor = "parametereditor"
Global $Plugin_Platzhalter_Projekteigenschaften = "projectproperties"




;TODO
Global $Plugin_Platzhalter_MSGBoxGenerator = "msgboxgenerator"
Global $Plugin_Platzhalter_UDFHeadererstellen = "createudfheader"
Global $Plugin_Platzhalter_TidySource = "tidysource"
Global $Plugin_Platzhalter_Farbtoolbox = "colortoolbox"
Global $Plugin_Platzhalter_Syntaxcheck = "au3syntaxcheck"
Global $Plugin_Platzhalter_SeiteDrucken = "printpage"
Global $Plugin_Platzhalter_KompilierenEinstellungen = "compilesettings"
Global $Plugin_Platzhalter_ProjektKompilieren = "compileproject"
Global $Plugin_Platzhalter_BackupErstellen = "makebackup"




Global $Readen_Parameter_String

Global $History_Projekte_Array[7] ;Zuletzt verwendete Elemente im Startscreen
Global $Zuletzt_Verwendete_Dateien_Temp_Array[10] ;Zuletzt verwendete Dateien (Wird nur zur ablage benötigt)
Global $Codeausschnitt_Startline = 0
Global $Codeausschnitt_Endline = 0
Global $cInput, $cResult, $cCalc, $cArrowDown, $cArrowUp, $cBtnDo, $cLbl
Global $aArrowDown[16] = [1,15,16,30,31,15,25,15,25,1,8,1,8,15,1,15]
Global $aArrowUp[16] = [1,15,16,0,31,15,25,15,25,30,8,30,8,15,1,15]
Global $letztes_Suchwort = ""
Global $Projektbaum_ist_bereit = 1 ;1 wenn Projektbaum bereit ist, 0 wenn zb. gerade eine Datei umbenannt wird -> verhintert zb. ENTER im Projektbaum
Global $Creditsmusik = _SoundOpen(@ScriptDir&"\Data\credits.mp3")
Global $Credits_Scrollgeschwindigkeit = 1
Global $Temp_ID_Holder = 0 ;hält die aktions ID bis actionsconfig beendet wird
Global $Temp_Button_ID_HOLDER = 0 ;hält die @GUI_CtrlId bei Extendedpaths
Global $Regel_lauft = 0 ;1 wenn gerade eine Regel ausgeführt wird
Global $Zuletzt_Kompilierte_Datei_Pfad_exe = "" ;Dateipfad der zuletzt kompilierten Datei (.exe Datei)
Global $Zuletzt_Kompilierte_Datei_Pfad_au3 = "" ;Dateipfad der zuletzt kompilierten Datei (.au3 Datei)
Global $Skriptbaum_Filter_Array
Global $Action_Selection_combo_ARRAY[1]
Global $Trigger_Selection_combo_ARRAY[1]
Global $Tools_menu_seperator = ""
Global $Tools_menu_pluginitem1 = ""
Global $Tools_menu_pluginitem2 = ""
Global $Tools_menu_pluginitem3 = ""
Global $Tools_menu_pluginitem4 = ""
Global $Tools_menu_pluginitem5 = ""
Global $Tools_menu_pluginitem6 = ""
Global $Tools_menu_pluginitem7 = ""
Global $Tools_menu_pluginitem8 = ""
Global $Tools_menu_pluginitem9 = ""
Global $Tools_menu_pluginitem10 = ""
Global $Tools_menu_pluginitem1_exe = ""
Global $Tools_menu_pluginitem2_exe = ""
Global $Tools_menu_pluginitem3_exe = ""
Global $Tools_menu_pluginitem4_exe = ""
Global $Tools_menu_pluginitem5_exe = ""
Global $Tools_menu_pluginitem6_exe = ""
Global $Tools_menu_pluginitem7_exe = ""
Global $Tools_menu_pluginitem8_exe = ""
Global $Tools_menu_pluginitem9_exe = ""
Global $Tools_menu_pluginitem10_exe = ""
Global $Section_Trigger1 = "#ruletrigger_afteropenproject#"
Global $Section_Trigger2 = "#ruletrigger_aftercompile#"
Global $Section_Trigger3 = "#ruletrigger_aftersave#"
Global $Section_Trigger4 = "#ruletrigger_aftertidy#"
Global $Section_Trigger5 = "#ruletrigger_afterau3check#"
Global $Section_Trigger6 = "#ruletrigger_beforecloseproject#"
Global $Section_Trigger7 = "#ruletrigger_afteropenfile#"
Global $Section_Trigger8 = "#ruletrigger_afterclosetab#"
Global $Section_Trigger9 = "#ruletrigger_beforetesting#"
Global $Section_Trigger10 = "#ruletrigger_stopscript#"
Global $Section_Trigger11 = "#ruletrigger_scripterror#"
Global $Section_Trigger12 = "#ruletrigger_ruleslot1#"
Global $Section_Trigger13 = "#ruletrigger_ruleslot2#"
Global $Section_Trigger14 = "#ruletrigger_ruleslot3#"
Global $Section_Trigger15 = "#ruletrigger_ruleslot4#"
Global $Section_Trigger16 = "#ruletrigger_ruleslot5#"
Global $Section_Trigger17 = "#ruletrigger_ruleslot6#"
Global $Section_Trigger18 = "#ruletrigger_ruleslot7#"
Global $Section_Trigger19_compilefile = "#ruletrigger_aftercompilefile#"
Global $Section_Trigger20_beforecompileproject = "#ruletrigger_beforecompileproject#"
Global $Section_Trigger21_beforecompilefile = "#ruletrigger_beforecompilefile#"


Global $Key_Action1 = "setstatusbartext"
Global $Key_Action2 = "sleep"
Global $Key_Action3 = "minimizestudio"
Global $Key_Action4 = "fileoperation"
Global $Key_Action5 = "runfile"
Global $Key_Action6 = "compilefile"
Global $Key_Action7 = "closeproject"
Global $Key_Action8 = "openexternalfile"
Global $Key_Action9 = "msgbox"
Global $Key_Action10 = "executecommand"
Global $Key_Action11 = "setstartparams"
Global $Key_Action12 = "addlog"
Global $Key_Action13 = "backup"
Global $Key_Action14 = "insertautoitcode"
Global $Key_Action15 = "changeprojectversion"
Global $Key_Action16 = "runscript"

Global $Programmvariablen = "%projectdir%|%compileddir%|%isnstudiodir%|%windowsdir%|%tempdir%|%desktopdir%|%backupdir%|%mydocumentsdir%|%projectversion%|%filedir%|%lastcompiledfile_exe%|%lastcompiledfile_source%|%projectname%|%projectauthor%|%myisndatadir%"
Global $Variablen_Ordnerstruktur = "%projectversion%|%projectname%|%projectauthor%"

;-----------------------------------Konfiguration-----------------------------------
Global $allow_windows_variables_in_paths = _Config_Read("allow_windows_variables_in_paths", "true")
Global $Studio_x_position = _Config_Read("studio_x", "-1")
Global $Studio_y_position = _Config_Read("studio_y", "-1")
Global $Studio_width_position = _Config_Read("studio_width", "-1")
Global $Studio_height_position = _Config_Read("studio_height", "-1")
Global $enablelogo = _Config_Read("enablelogo", "true")
Global $Runonmonitor = _Config_Read("runonmonitor", "1")
Global $fullscreenmode = _Config_Read("fullscreenmode", "false")
Global $Default_font = _Config_Read("default_font", "Segoe UI")
Global $Default_font_size = _Config_Read("default_font_size", "8.5")
Global $treefont_font = _Config_Read("treefont_font", "Segoe UI")
Global $treefont_size = _Config_Read("treefont_size", "8.5")
Global $treefont_colour = _Config_Read("treefont_colour", "0x000000")
Global $proxy_server = _Config_Read("proxy_server", "")
Global $proxy_port = _Config_Read("proxy_port", "8080")
Global $proxy_username = _Config_Read("proxy_username", "")
Global $proxy_PW = _Config_Read("proxy_PW", "")
Global $Use_Proxy = _Config_Read("Use_Proxy", "false")
Global $SHOW_DEBUG_CONSOLE = _Config_Read("showdebugconsole", "false") ;FOR DEBUGGING
Global $Save_Mode = _Config_Read("safemode", "false") ;disable all plugins
Global $Languagefile = _Config_Read("language", "german.lng")
Global $Languagefile_full_path = @scriptdir & "\data\language\" & $Languagefile
RegWrite ("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "plugin_language", "REG_SZ", $Languagefile)


;Templatedir
Global $templatefolder = _Config_Read("templatefolder", $Standardordner_Templates)
if $templatefolder = "Templates" then ;Fix für alte versionen -> Reset auf neuen Default mit variablen
_Write_in_Config("templatefolder", $Standardordner_Templates)
$templatefolder = $Standardordner_Templates
Endif

;Releasedir
Global $releasemode = _Config_Read("releasemode", "1")
Global $releasefolder = _Config_Read("releasefolder", $Standardordner_Release)
if $releasefolder = "Release" AND $releasemode = "1" then ;Fix für alte versionen -> Reset auf neuen Default mit variablen
_Write_in_Config("releasefolder", $Standardordner_Release)
$releasefolder = $Standardordner_Release
Endif

;Projectdir
Global $Projectfolder = _Config_Read("projectfolder", $Standardordner_Projects)
if $Projectfolder = "Projects" then ;Fix für alte versionen -> Reset auf neuen Default mit variablen
_Write_in_Config("projectfolder", $Standardordner_Projects)
$Projectfolder = $Standardordner_Projects
Endif

;Backupdir
Global $backupmode = _Config_Read("backupmode", "1")
Global $Backupfolder = _Config_Read("backupfolder", $Standardordner_Backups)
if $Backupfolder = "Backups" AND $backupmode = "1" then ;Fix für alte versionen -> Reset auf neuen Default mit variablen
_Write_in_Config("backupfolder", $Standardordner_Backups)
$Backupfolder = $Standardordner_Backups
Endif

;Pluginsdir
Global $Pluginsdir = _Config_Read("pluginsdir", $Standardordner_Plugins)
if $Pluginsdir = @scriptdir&"\Data\Plugins" OR $Pluginsdir = "Data\Plugins" then ;Fix für alte versionen -> Reset auf neuen Default mit variablen
_Write_in_Config("pluginsdir", "%isnstudiodir%\Data\Plugins")
$Pluginsdir = "%isnstudiodir%\Data\Plugins"
Endif
if not FileExists(_ISN_Variablen_aufloesen($Pluginsdir)) then DirCreate(_ISN_Variablen_aufloesen($Pluginsdir))

Global $List_of_active_plugins = _Config_Read("active_plugins", "fileviewer|formstudio2")
Global $AskExit = _Config_Read("askexit", "true")
Global $Autoload = _Config_Read("autoload", "false")
Global $createtemplatefolders = _Config_Read("createtemplatefolders", "true")
Global $LastProject = _Config_Read("lastproject", "")
Global $helpfile = _ISN_Variablen_aufloesen(_Config_Read("helpfileexe", ""))
Global $autoit2exe = _ISN_Variablen_aufloesen(_Config_Read("autoit2exe", ""))
Global $autoitexe = _ISN_Variablen_aufloesen(_Config_Read("autoitexe", ""))
Global $Au3Infoexe = _ISN_Variablen_aufloesen(_Config_Read("au3infoexe", ""))
Global $Au3Checkexe = _ISN_Variablen_aufloesen(_Config_Read("au3checkexe", ""))
Global $Au3Stripperexe = _ISN_Variablen_aufloesen(_Config_Read("au3stripperexe", ""))
Global $Tidyexe = _ISN_Variablen_aufloesen(_Config_Read("tidyexe", ""))
Global $Pfad_zur_TidyINI = _Config_Read("tidy_ini_path", "")
Global $autoloadmainfile = _Config_Read("autoloadmainfile", "true")
Global $registerau3files = _Config_Read("registerau3files", "false")
Global $registerisnfiles = _Config_Read("registerisnfiles", "true")
Global $registerispfiles = _Config_Read("registerispfiles", "true")
Global $registericpfiles = _Config_Read("registericpfiles", "true")
Global $hideprogramlog = _Config_Read("hideprogramlog", "false")
Global $hidefunctionstree = _Config_Read("hidefunctionstree", "false")
Global $hidedebug = _Config_Read("hidedebug", "false")
Global $globalautocomplete = _Config_Read("globalautocomplete", "true")
Global $disableautocomplete = _Config_Read("disableautocomplete", "false")
Global $disableintelisense = _Config_Read("disableintelisense", "false")
Global $showlines = _Config_Read("showlines", "true")
Global $enablebackup = _Config_Read("enablebackup", "true")
Global $backuptime = _Config_Read("backuptime", "30") ;in minuten
Global $enabledeleteoldbackups = _Config_Read("enabledeleteoldbackups", "true")
Global $deleteoldbackupsafter = _Config_Read("deleteoldbackupsafter", "30") ;Tage
Global $showdebuggui = _Config_Read("showdebuggui", "true")
Global $allow_trophys = _Config_Read("trophys", "true")
Global $drawicons = _Config_Read("drawicons", "true")
Global $closeaction = _Config_Read("closeaction", "close")
Global $loadcontrols = _Config_Read("loadcontrols", "false")
Global $allowcommentout = _Config_Read("allowcommentout", "true")
Global $runbefore = _Config_Read("runbefore", "")
Global $runafter = _Config_Read("runafter", "")
Global $showfunctions = _Config_Read("showfunctions", "true")
Global $Skriptbaum_Funcs_alphabetisch_sortieren = _Config_Read("scripttree_sort_funcs_alphabetical", "true")
Global $expandfunctions = _Config_Read("expandfunctions", "true")
Global $showglobalvariables = _Config_Read("showglobalvariables", "true")
Global $expandglobalvariables = _Config_Read("expandglobalvariables", "true")
Global $showlocalvariables = _Config_Read("showlocalvariables", "true")
Global $expandlocalvariables = _Config_Read("expandlocalvariables", "false")
Global $showincludes = _Config_Read("showincludes", "true")
Global $expandincludes = _Config_Read("expandincludes", "false")
Global $showforms = _Config_Read("showforms", "true")
Global $expandforms = _Config_Read("expandforms", "false")
Global $showregions = _Config_Read("showregions", "true")
Global $expandregions = _Config_Read("expandregions", "true")
Global $savefolding = _Config_Read("savefolding", "false")
Global $registerinexplorer = _Config_Read("registerinexplorer", "false")
Global $enable_autoupdate = _Config_Read("enable_autoupdate", "true")
Global $Update_Kanal = _Config_Read("update_channel", "stable") ;beziehe stable oder beta updates für das ISN
Global $autoupdate_searchtimer = _Config_Read("autoupdate_searchtimer", "14") ;Tage
Global $globalautocomplete_current_script = _Config_Read("globalautocomplete_current_script", "false")
Global $autoit_editor_encoding = _Config_Read("autoit_editor_encoding", "2") ;1 = ansi; 2 = utf8
Global $protect_files_from_external_modification = _Config_Read("protect_files_from_external_modification", "true")
Global $Erweitertes_debugging = _Config_Read("enhanced_debugging", "false") ;True wenn im Menü Tools -> Debbuging -> Debbuging aktiviert ist
Global $lade_zuletzt_geoeffnete_Dateien = _Config_Read("restore_old_tabs", "false")
Global $verwende_intelimark = _Config_Read("enable_intelimark", "true")
Global $Autobackup_Ordnerstruktur = _Config_Read("backup_folderstructure", "%projectname%\%mday%.%mon%.%year%\%hour%h %min%m")
Global $Pfade_bei_Programmstart_automatisch_suchen = _Config_Read("search_au3paths_on_startup", "false")
Global $AutoIt_Projekte_in_Projektbaum_anzeigen = _Config_Read("show_projects_in_projecttree", "false")
Global $Immer_am_primaeren_monitor_starten = _Config_Read("run_always_on_primary_screen", "true")
Global $Toolbar_Standardlayout = "#tbar_newfile#|#tbar_newfolder#|#tbar_importfile#|#tbar_importfolder#|#tbar_export#|#tbar_deletefile#|#tbar_refreshprojecttree#|#tbar_fullscreen#|#tbar_sep#|#tbar_testproject#|#tbar_compile#|#tbar_macros#|#tbar_projectsettings#|#tbar_sep#|#tbar_save#|#tbar_saveall#|#tbar_closetab#|#tbar_undo#|#tbar_redo#|#tbar_sep#|#tbar_testscript#|#tbar_stopproject#|#tbar_sep#|#tbar_search#|#tbar_syntaxcheck#|#tbar_commentout#|#tbar_windowtool#|#tbar_sep#|#tbar_macroslot1#|#tbar_macroslot2#|#tbar_macroslot3#|#tbar_macroslot4#|#tbar_macroslot5#|#tbar_macroslot6#|#tbar_macroslot7#"
Global $Toolbarlayout = _Config_Read("toolbar_layout",$Toolbar_Standardlayout)
Global $starte_Skripts_mit_au3Wrapper = _Config_Read("run_scripts_with_au3wrapper", "false")
Global $Verwalte_Tidyeinstellungen_mit_dem_ISN = _Config_Read("useisntoconfigtidy", "false")
Global $Zeige_Buttons_neben_Debug_Fenster = _Config_Read("debugbuttons", "true")
Global $SkriptEditor_Doppelklick_ParameterEditor = _Config_Read("scripteditor_doubleclickparametereditor", "false")
Global $Zusaetzliche_Include_Pfade_ueber_ISN_verwalten = _Config_Read("manage_additional_includes_with_ISN", "false")
Global $AutoEnd_Keywords = _Config_Read("autoend_keywords", "true")
Global $Auto_dollar_for_declarations = _Config_Read("auto_dollar_for_declarations", "false")
Global $Makrosicherheitslevel = _Config_Read("macro_security_level", "1") ;0 = aus ; 1=niedrig; 2=mittel; 3=hoch; 4=verbieten
Global $Alte_Fensterposition_verwenden = _Config_Read("isn_save_window_position", "false")
Global $Bearbeitende_Function_im_skriptbaum_markieren = _Config_Read("select_current_func_in_scripttree", "false")
Global $Skript_Editor_Autocomplete_UDF_ab_zweitem_Zeichen = _Config_Read("autocomplete_udf_require_two_chars", "false")

Global $Automatische_Speicherung_Aktiv = _Config_Read("auto_save_enabled", "true")
Global $Automatische_Speicherung_Nur_Skript_Tabs_Sichern = _Config_Read("auto_save_only_script_tabs", "false")
Global $Automatische_Speicherung_Nur_aktuellen_Tabs_Sichern = _Config_Read("auto_save_only_current_tab", "false")
Global $Automatische_Speicherung_Modus = _Config_Read("auto_save_mode", "1") ;1 nach timer, 2 nach eingabe
Global $Automatische_Speicherung_Eingabe_Nur_einmal_sichern = _Config_Read("auto_save_once_mode", "true")
Global $Automatische_Speicherung_Timer_Sekunden = _Config_Read("auto_save_timer_secounds", "0")
Global $Automatische_Speicherung_Timer_Minuten = _Config_Read("auto_save_timer_minutes", "5")
Global $Automatische_Speicherung_Timer_Stunden = _Config_Read("auto_save_timer_hours", "0")
Global $Automatische_Speicherung_Eingabe_Sekunden = _Config_Read("auto_save_input_secounds", "0")
Global $Automatische_Speicherung_Eingabe_Minuten = _Config_Read("auto_save_input_minutes", "1")
Global $Automatische_Speicherung_Eingabe_Stunden = _Config_Read("auto_save_input_hours", "0")
Global $Skript_Editor_Dateitypen_Standard = $Autoitextension&"|bat|htm|html|xml|isn|txt|ini"
Global $Skript_Editor_Dateitypen_Liste = _Config_Read("scripteditor_filetypes", $Skript_Editor_Dateitypen_Standard)
Global $Skript_Editor_Automatische_Dateitypen = _Config_Read("scripteditor_auto_manage_filetypes", "true")
Global $Zusaetzliche_API_Ordner = _Config_Read("additional_api_folders", "")
Global $Zusaetzliche_Properties_Ordner = _Config_Read("additional_properties_folders", "")

;Tools
Global $Tools_Bitrechner_aktiviert = _Config_Read("tools_Bitoperation_tester_enabled", "true") ;Bit-Operation Tester Tool
Global $Tools_Parameter_Editor_aktiviert = _Config_Read("tools_parameter_editor_enabled", "true") ;Parameter Editor
Global $Tools_PELock_Obfuscator_aktiviert = _Config_Read("tools_pelock_obfuscator_enabled", "true") ;PE-Lock Obfuscator Tool


;Deklarationen für Skripteditorfarben
Global $scripteditor_font = _Config_Read("scripteditor_font", "Courier New")
Global $scripteditor_size = _Config_Read("scripteditor_size", "10")
Global $scripteditor_bgcolour = _Config_Read("scripteditor_bgcolour", "0xFFFFFF")
Global $scripteditor_rowcolour = _Config_Read("scripteditor_rowcolour", "0xFFFED8")
Global $scripteditor_marccolour = _Config_Read("scripteditor_marccolour", "0x3289D0")
Global $scripteditor_caretcolour = _Config_Read("scripteditor_caretcolour", "0x000000")
Global $scripteditor_caretwidth = _Config_Read("scripteditor_caretwidth", "1")
Global $scripteditor_caretstyle = _Config_Read("scripteditor_caretstyle", "1")
Global $scripteditor_highlightcolour = _Config_Read("scripteditor_highlightcolour", "0xFF0000")
Global $scripteditor_errorcolour = _Config_Read("scripteditor_errorcolour", "0xFEBDBD")
Global $use_new_au3_colours = _Config_Read("use_new_au3_colours", "false")
Global $hintergrundfarbe_fuer_alle_uebernehmen = _Config_Read("scripteditor_backgroundcolour_forall", "true")
;Syntax: Vordergrund | Hintergrund | Bold | Italic | Underline
;a = Style1 (alt) b = Style2 (neu)
Global $SCE_AU3_STYLE1a = _Config_Read("AU3_DEFAULT_STYLE1", "0x000000|0xFFFFFF|0|0|0")
Global $SCE_AU3_STYLE2a = _Config_Read("AU3_COMMENT_STYLE1", "0x339900|0xFFFFFF|0|1|0")
Global $SCE_AU3_STYLE3a = _Config_Read("AU3_COMMENTBLOCK_STYLE1", "0x009966|0xFFFFFF|0|1|0")
Global $SCE_AU3_STYLE4a = _Config_Read("AU3_NUMBER_STYLE1", "0xA900AC|0xFFFFFF|1|1|0")
Global $SCE_AU3_STYLE5a = _Config_Read("AU3_FUNCTION_STYLE1", "0xAA0000|0xFFFFFF|1|1|0")
Global $SCE_AU3_STYLE6a = _Config_Read("AU3_KEYWORD_STYLE1", "0xFF0000|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE7a = _Config_Read("AU3_MACRO_STYLE1", "0xFF33FF|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE8a = _Config_Read("AU3_STRING_STYLE1", "0xCC9999|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE9a = _Config_Read("AU3_OPERATOR_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE10a = _Config_Read("AU3_VARIABLE_STYLE1", "0x000090|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE11a = _Config_Read("AU3_SENT_STYLE1", "0x0080FF|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE12a = _Config_Read("AU3_PREPROCESSOR_STYLE1", "0xFF00F0|0xFFFFFF|0|1|0")
Global $SCE_AU3_STYLE13a = _Config_Read("AU3_SPECIAL_STYLE1", "0xF00FA0|0xFFFFFF|0|1|0")
Global $SCE_AU3_STYLE14a = _Config_Read("AU3_EXPAND_STYLE1", "0x0000FF|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE15a = _Config_Read("AU3_COMOBJ_STYLE1", "0xFF0000|0xFFFFFF|1|1|0")
Global $SCE_AU3_STYLE16a = _Config_Read("AU3_UDF_STYLE1", "0xFF8000|0xFFFFFF|0|1|0")


Global $SCE_AU3_STYLE1b = _Config_Read("AU3_DEFAULT_STYLE2", "0x000000|0xFFFFFF|0|0|0")
Global $SCE_AU3_STYLE2b = _Config_Read("AU3_COMMENT_STYLE2", "0x339900|0xFFFFFF|0|1|0")
Global $SCE_AU3_STYLE3b = _Config_Read("AU3_COMMENTBLOCK_STYLE2", "0x009966|0xFFFFFF|0|1|0")
Global $SCE_AU3_STYLE4b = _Config_Read("AU3_NUMBER_STYLE2", "0xFF0000|0xFFFFFF|1|1|0")
Global $SCE_AU3_STYLE5b = _Config_Read("AU3_FUNCTION_STYLE2", "0x900000|0xFFFFFF|1|1|0")
Global $SCE_AU3_STYLE6b = _Config_Read("AU3_KEYWORD_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE7b = _Config_Read("AU3_MACRO_STYLE2", "0x008080|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE8b = _Config_Read("AU3_STRING_STYLE2", "0x0000FF|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE9b = _Config_Read("AU3_OPERATOR_STYLE2", "0x0080FF|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE10b = _Config_Read("AU3_VARIABLE_STYLE2", "0x5A5A5A|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE11b = _Config_Read("AU3_SENT_STYLE2", "0x808080|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE12b = _Config_Read("AU3_PREPROCESSOR_STYLE2", "0x008080|0xFFFFFF|0|1|0")
Global $SCE_AU3_STYLE13b = _Config_Read("AU3_SPECIAL_STYLE2", "0x3C14DC|0xFFFFFF|0|1|0")
Global $SCE_AU3_STYLE14b = _Config_Read("AU3_EXPAND_STYLE2", "0xFF0000|0xFFFFFF|1|0|0")
Global $SCE_AU3_STYLE15b = _Config_Read("AU3_COMOBJ_STYLE2", "0x993399|0xFFFFFF|1|1|0")
Global $SCE_AU3_STYLE16b = _Config_Read("AU3_UDF_STYLE2", "0xFF8000|0xFFFFFF|0|1|0")



;Farbeinstellungen ISN
Global $skin = _Config_Read("skin", "#none#")
Global $ISN_Dark_Mode = _Config_Read("isn_dark_mode", "false")
Global $Skin_is_used = "false"
if $skin = "dark theme" then $ISN_Dark_Mode = "true"
if $skin <> "" AND $skin <> "#none#" then $Skin_is_used = "true"
Global $Fenster_Hintergrundfarbe = 0xFFFFFF
Global $Titel_Schriftfarbe = 0x003399
Global $Schriftfarbe = 0x000000
Global $Skriptbaum_Header_Hintergrundfarbe = 0xF0F0F0
Global $Skriptbaum_Header_Schriftfarbe = 0x686868
Global $Skriptbaum_Suchfeld_Hintergrundfarbe = 0xFFFFFF
Global $Skriptbaum_Suchfeld_Schriftfarbe = 0x000000
Global $Programmlog_Hintergrundfarbe = 0xF0F0F0
Global $Loading1_Ani = @scriptdir & "\data\isn_loading_1.ani"
Global $Loading2_Ani = @scriptdir & "\data\isn_loading_2.ani"
if $ISN_Dark_Mode = "true" then $Loading1_Ani = $Loading2_Ani

if $ISN_Dark_Mode = "true" Then
;Setze Farben für Dark Mode
$Fenster_Hintergrundfarbe = 0x414141
$Titel_Schriftfarbe = 0xFFFFFF
$Schriftfarbe = 0xFFFFFF
$Skriptbaum_Header_Hintergrundfarbe = 0x5F5F5F
$Skriptbaum_Header_Schriftfarbe = 0xFFFFFF
$Skriptbaum_Suchfeld_Hintergrundfarbe = 0x656565
$Skriptbaum_Suchfeld_Schriftfarbe = 0xFFFFFF
$Programmlog_Hintergrundfarbe = 0x414141
endif




func _Finde_Arbeitsverzeichnis()
$pfad = $Configfile
Dim $szDrive, $szDir, $szFName, $szExt
$TestPath = _PathSplit($pfad, $szDrive, $szDir, $szFName, $szExt)
$pfad = $szDrive&StringTrimRight($szDir,stringlen($szDir)-StringInStr($szDir,"\Data\",0,-1)+1)
return $pfad
EndFunc


;-----------------------------------Pixmaps-----------------------------------
Global $Pixmap_violet_struct = DllStructCreate("char["&StringLen($Pixmap_violet)+1&"]")
DllStructSetData($Pixmap_violet_struct, 1, $Pixmap_violet)

Global $Pixmap_blue_struct = DllStructCreate("char["&StringLen($Pixmap_blue)+1&"]")
DllStructSetData($Pixmap_blue_struct, 1, $Pixmap_blue)

Global $Pixmap_UDF_struct = DllStructCreate("char["&StringLen($Pixmap_udf)+1&"]")
DllStructSetData($Pixmap_UDF_struct, 1, $Pixmap_udf)

Global $Pixmap_varaiblen_struct = DllStructCreate("char["&StringLen($Pixmap_varaiblen)+1&"]")
DllStructSetData($Pixmap_varaiblen_struct, 1, $Pixmap_varaiblen)

Global $Pixmap_macros_struct = DllStructCreate("char["&StringLen($Pixmap_macros)+1&"]")
DllStructSetData($Pixmap_macros_struct, 1, $Pixmap_macros)

Global $Pixmap_preprocessor_struct = DllStructCreate("char["&StringLen($Pixmap_preprocessor)+1&"]")
DllStructSetData($Pixmap_preprocessor_struct, 1, $Pixmap_preprocessor)

Global $Pixmap_red_struct = DllStructCreate("char["&StringLen($Pixmap_red)+1&"]")
DllStructSetData($Pixmap_red_struct, 1, $Pixmap_red)


;-----------------------------------PELock Obfuscator-----------------------------------
Global $Pelock_Obfuscator_API_URL = "https://www.pelock.com/api/autoit-obfuscator/v1"
Global $Pelock_Obfuscator_More_Infos_URL = "https://www.pelock.com/products/autoit-obfuscator"
Global $Pelock_Obfuscator_Buy_Key_URL = "https://www.pelock.com/products/autoit-obfuscator/buy"



;-----------------------------------Hotkeys-----------------------------------
;Lade Tastenkombinationen (Hotkey Keycodes)
_Lade_Tastenkombinationen()
func _Lade_Tastenkombinationen()
Global $Hotkey_Keycode_Mittlere_Maustaste = "04" ;Mittlere Maustaste (zum direkten schlißen der Tabs)
Global $Hotkey_Keycode_Speichern = iniread($Configfile, "hotkeys", "key_save", "11+53") ;strg+s
Global $Hotkey_Keycode_Speichern_unter = iniread($Configfile, "hotkeys", "key_save_as", "") ;Leer
Global $Hotkey_Keycode_Speichern_Alle_Tabs = iniread($Configfile, "hotkeys", "key_save_all_tabs", "") ;Leer
Global $Hotkey_Keycode_Tidy = iniread($Configfile, "hotkeys", "key_tidy", "11+54") ;strg+t
Global $Hotkey_Keycode_tab_schliessen = iniread($Configfile, "hotkeys", "key_closetab", "11+57") ;strg+w
Global $Hotkey_Keycode_vorheriger_tab = iniread($Configfile, "hotkeys", "key_previoustab", "11+09+10") ;strgshift+tab
Global $Hotkey_Keycode_naechster_tab = iniread($Configfile, "hotkeys", "key_nexttab", "11+09") ;strg+tab
Global $Hotkey_Keycode_vollbild = iniread($Configfile, "hotkeys", "key_fullscreen", "7A") ;F11
Global $Hotkey_Keycode_auskommentieren = iniread($Configfile, "hotkeys", "key_commentout", "11+51") ;CRLT+Q
Global $Hotkey_Keycode_befehlhilfe = iniread($Configfile, "hotkeys", "key_commandhelp", "70") ;F1
Global $Hotkey_Keycode_springezuzeile = iniread($Configfile, "hotkeys", "key_gotoline", "11+47") ;CRLT+G
Global $Hotkey_Keycode_zeigefehler = iniread($Configfile, "hotkeys", "key_finderror", "73") ;F4
Global $Hotkey_Keycode_syntaxcheck = iniread($Configfile, "hotkeys", "key_syntaxcheck", "11+74") ;crtl+F5
Global $Hotkey_Keycode_zeile_duplizieren = iniread($Configfile, "hotkeys", "key_dublicate", "11+44") ;crtl+D
Global $Hotkey_Keycode_unteres_fenster_umschalten = iniread($Configfile, "hotkeys", "key_togglehideoutputconsole", "77") ;F8
Global $Hotkey_Keycode_compile = iniread($Configfile, "hotkeys", "key_compile", "76") ;F7
Global $Hotkey_Keycode_compile_Settings = iniread($Configfile, "hotkeys", "key_compile_Settings", "10+76") ;Shift+F7
Global $Hotkey_Keycode_testeskript = iniread($Configfile, "hotkeys", "key_testscript", "78") ;F9
Global $Hotkey_Keycode_Suche = iniread($Configfile, "hotkeys", "key_search", "11+46") ;STRG+F
Global $Hotkey_Keycode_Testprojekt = iniread($Configfile, "hotkeys", "key_testproject", "74") ;F5
Global $Hotkey_Keycode_Testprojekt_ohne_Parameter = iniread($Configfile, "hotkeys", "key_testprojectwithoutparam", "75") ;F6
Global $Hotkey_Keycode_Neue_Datei = iniread($Configfile, "hotkeys", "key_newfile", "11+4E") ;CRLT+N
Global $Hotkey_Keycode_Oeffnen = iniread($Configfile, "hotkeys", "key_open", "11+4F") ;CRLT+O
Global $Hotkey_Keycode_Makroslot1 = iniread($Configfile, "hotkeys", "key_macroslot1", "") ;Leer
Global $Hotkey_Keycode_Makroslot2 = iniread($Configfile, "hotkeys", "key_macroslot2", "") ;Leer
Global $Hotkey_Keycode_Makroslot3 = iniread($Configfile, "hotkeys", "key_macroslot3", "") ;Leer
Global $Hotkey_Keycode_Makroslot4 = iniread($Configfile, "hotkeys", "key_macroslot4", "") ;Leer
Global $Hotkey_Keycode_Makroslot5 = iniread($Configfile, "hotkeys", "key_macroslot5", "") ;Leer
Global $Hotkey_Keycode_Makroslot6 = iniread($Configfile, "hotkeys", "key_macroslot6", "") ;Leer
Global $Hotkey_Keycode_Makroslot7 = iniread($Configfile, "hotkeys", "key_macroslot7", "") ;Leer
Global $Hotkey_Keycode_debugtomsgbox = iniread($Configfile, "hotkeys", "key_debugtomsgbox", "11+10+44") ;STRG+SHIFT+D
Global $Hotkey_Keycode_debugtoconsole = iniread($Configfile, "hotkeys", "key_debugtoconsole", "11+12+44") ;STRG+ALT+D
Global $Hotkey_Keycode_erstelleUDFheader = iniread($Configfile, "hotkeys", "key_createudfheader", "11+12+48") ;STRG+ALT+H
Global $Hotkey_Keycode_msgBoxGenerator = iniread($Configfile, "hotkeys", "key_msgboxgenerator", "12+57") ;ALT+W
Global $Hotkey_Keycode_AutoIt3WrapperGUI = iniread($Configfile, "hotkeys", "key_autoit3wrappergui", "") ;AutoIt3WrapperGUI
Global $Hotkey_Keycode_Farbtoolbox = iniread($Configfile, "hotkeys", "key_colourtoolbox", "") ;Farbtoolbox
Global $Hotkey_Keycode_Fensterinfotool = iniread($Configfile, "hotkeys", "key_windowinfotool", "") ;Fenster Info Tool
Global $Hotkey_Keycode_organizeincludes = iniread($Configfile, "hotkeys", "key_organizeincludes", "11+12+10+49") ;organizeincludes Ctrl+Shift+Alt+I
Global $Hotkey_Keycode_Oeffne_Include = iniread($Configfile, "hotkeys", "key_openinclude", "11+49") ;STRG+I
Global $Hotkey_Keycode_Bitrechner = iniread($Configfile, "hotkeys", "key_bitwise", "") ;Leer (Bit rechner)
Global $Hotkey_Keycode_Automatisches_Backup = iniread($Configfile, "hotkeys", "key_backup", "") ;Leer (Backup starten)
Global $Hotkey_Keycode_Datei_umbenennen = iniread($Configfile, "hotkeys", "key_renamefile", "71") ;F2
Global $Hotkey_Keycode_Weitersuchen = iniread($Configfile, "hotkeys", "key_nextsearch", "72") ;F3
Global $Hotkey_Keycode_Rueckwaerts_Weitersuchen = iniread($Configfile, "hotkeys", "key_prevsearch", "10+72") ;Shift+F3
Global $Hotkey_Keycode_Aenderungsprotokolle = iniread($Configfile, "hotkeys", "key_changelogmanager", "") ;Leer
Global $Hotkey_Keycode_ToDo_Liste = iniread($Configfile, "hotkeys", "key_todolistmanager", "") ;Leer
Global $Hotkey_Keycode_linkes_fenster_umschalten = iniread($Configfile, "hotkeys", "key_toggleprojecttree", "12+25") ;ALT+Pfeil links
Global $Hotkey_Keycode_rechtes_fenster_umschalten = iniread($Configfile, "hotkeys", "key_togglescripttree", "12+27") ;ALT+Pfeil rechts
Global $Hotkey_Keycode_Springe_zu_Func = iniread($Configfile, "hotkeys", "key_jumptofunc", "11+4A") ;STRG+J
Global $Hotkey_Keycode_Springe_zu_Func_zurueck = $Hotkey_Keycode_Springe_zu_Func&"+10" ;STRG+SHIFT+J
Global $Hotkey_Keycode_Zeile_nach_oben_verschieben = iniread($Configfile, "hotkeys", "key_movelineup", "11+10+26") ;STRG+SHIFT+Pfeil oben
Global $Hotkey_Keycode_Zeile_nach_unten_verschieben = iniread($Configfile, "hotkeys", "key_movelinedown", "11+10+28") ;STRG+SHIFT+Pfeil unten
Global $Hotkey_SCI_Kommentare_ausblenden_bzw_einblenden = iniread($Configfile, "hotkeys", "key_toggle_comments", "") ;Leer
Global $Hotkey_Keycode_In_Dateien_Suchen = iniread($Configfile, "hotkeys", "key_search_in_files", "11+10+46") ;STRG+SHIFT+F In Dateien suchen
Global $Hotkey_Zeile_Bookmarken_Naechstes_Bookmark = iniread($Configfile, "hotkeys", "key_bookmark_jump_next", "71") ;F2 Zum nächsten bookmark springen
Global $Hotkey_Zeile_Bookmarken_Vorheriges_Bookmark = iniread($Configfile, "hotkeys", "key_bookmark_jump_previous", "10+71") ;Shift+F2 Zum vorherigen bookmark springen
Global $Hotkey_Zeile_Bookmarken = iniread($Configfile, "hotkeys", "key_bookmark_line", "11+71") ;STRG+F2 Zeile bookmarken
Global $Hotkey_Zeile_Bookmarken_alle_loeschen = iniread($Configfile, "hotkeys", "key_bookmark_line_remove_all_bookmarks", "") ;Alle bookmarks löschen
Global $Hotkey_PElock_Obfuscator = iniread($Configfile, "hotkeys", "key_pelock_obfuscator", "") ;PELock Obfuscator
Global $Hotkey_Keycode_Parameter_Editor = iniread($Configfile, "hotkeys", "key_parameter_editor", "") ;Leer
Global $Hotkey_Keycode_Parameter_Editor_alle_Parameter_leeren = iniread($Configfile, "hotkeys", "key_parameter_editor_clear_all_parameters", "10+2E") ;SHIFT+Entf
Global $Hotkey_Keycode_Parameter_Editor_markierten_Parameter_leeren = iniread($Configfile, "hotkeys", "key_parameter_editor_clear_selected_parameter", "11+2E") ;STRG+Entf
Global $Hotkey_Keycode_Parameter_Editor_naechster_Parameter = iniread($Configfile, "hotkeys", "key_parameter_editor_select_next_parameter", "0D") ;Enter
Global $Hotkey_Keycode_Parameter_Editor_neuer_Parameter = iniread($Configfile, "hotkeys", "key_parameter_editor_add_new_parameter", "11+0D") ;Strg+Enter
Global $Hotkey_Keycode_Parameter_Editor_markierten_Parameter_loeschen = iniread($Configfile, "hotkeys", "key_parameter_editor_remove_selected_parameter", "11+10+2E") ;Strg+Shift+Del
endfunc



 Func _ISN_Send_Message_to_Plugin($hGUI = "", $Message = "", $nolog = 0)
	If $hGUI = "" Then Return ""
	If $Message = "" Then Return ""
	  $Message = $Studiofenster&$Plugin_System_Delimiter&$Message
     Local $tCOPYDATA, $tMsg
    if $nolog = 0 then _Write_ISN_Debug_Console("ISN sends a message to a plugin: "&$Message, $ISN_Debug_Console_Errorlevel_Info,$ISN_Debug_Console_Linebreak,$ISN_Debug_Console_Insert_Time,$ISN_Debug_Console_Insert_Title,$ISN_Debug_Console_Category_Plugin)
    $Message = StringToBinary($Message,4) ;Nachricht wird binär übertragen (wegen Encoding)
    $tMsg = DllStructCreate("char[" & StringLen($Message) + 1 & "]")
    DllStructSetData($tMsg, 1, $Message)
    $tCOPYDATA = DllStructCreate("dword;dword;ptr")
    DllStructSetData($tCOPYDATA, 2, StringLen($Message) + 1)
    DllStructSetData($tCOPYDATA, 3, DllStructGetPtr($tMsg))
    $Ret = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hGUI, "int", 0x004A, "wparam", 0, "lparam", DllStructGetPtr($tCOPYDATA))
    If (@error) Or ($Ret[0] = -1) Then Return 0
    Return 1
EndFunc