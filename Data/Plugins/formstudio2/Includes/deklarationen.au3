;lese config
Global $__MonitorList[1][5]

_GetMonitors() ;For Multimonitor support
Global $Pfad_zur_Studioconfig = $ISN_AutoIt_Studio_Config_Path



Global $Logo = ""
Global $Arbeitsverzeichnis = $ISN_AutoIt_Studio_Data_Directory
Global $Runonmonitor = iniread($Pfad_zur_Studioconfig, "config", "runonmonitor", "0")
Global $Runonprimarymonitor = iniread($Pfad_zur_Studioconfig, "config", "run_always_on_primary_screen", "true")
Global $Autoitexe = iniread($Pfad_zur_Studioconfig, "config", "autoitexe", "")
Global $Default_font = iniread($Pfad_zur_Studioconfig, "config", "default_font", "Segoe UI")
Global $Default_font_size = iniread($Pfad_zur_Studioconfig, "config", "default_font_size", "8.5")
Global $Default_font_size = iniread($Pfad_zur_Studioconfig, "config", "default_font_size", "8.5")
Global $Current_ISN_Skin = iniread($Pfad_zur_Studioconfig, "config", "skin", "#none#")
Global $Loading1_Ani = ""


;-----------------------------------DPI SCALING-----------------------------------
Global $DPI = 1
if iniread($Pfad_zur_Studioconfig,"config","enable_custom_dpi_value", "false") = "true" then
   $DPI = number(iniread($Pfad_zur_Studioconfig,"config","custom_dpi_value", 1))
Else
   $DPI = _GetDPI() ;Aus Windows hohlen
endif
if iniread($Pfad_zur_Studioconfig,"config","highDPI_mode", "true") <> "true" then $DPI = 1 ;1 = Def 100% value

$tmp_GUI = GUICreate("tmp",625,400,-1,-1,-2134573056,-1)
$Clientsize_diff_client_size_array = WinGetClientSize($tmp_GUI)
$Clientsize_diff_winpos_array = WinGetPos($tmp_GUI)
Global $Clientsize_diff_width = 16, $Clientsize_diff_height = 39 ;Def werte
if IsArray($Clientsize_diff_client_size_array) AND IsArray($Clientsize_diff_winpos_array) then
   $Clientsize_diff_width = $Clientsize_diff_winpos_array[2]-$Clientsize_diff_client_size_array[0]
   $Clientsize_diff_height = $Clientsize_diff_winpos_array[3]-$Clientsize_diff_client_size_array[1]
endif
GUIDelete($tmp_GUI)


Global $GUIMINWID = 640, $GUIMINHT = 480 ;Default für alle Fenster
Global $Setup_GUI_width = (610*$DPI)+$Clientsize_diff_width, $Setup_GUI_height = (671*$DPI)+$Clientsize_diff_height
Global $control_reihenfolge_GUI_width = (645*$DPI)+$Clientsize_diff_width, $control_reihenfolge_GUI_height = (493*$DPI)+$Clientsize_diff_height
Global $Form_bearbeitenGUI_width = (550*$DPI)+$Clientsize_diff_width, $Form_bearbeitenGUI_height = (509*$DPI)+$Clientsize_diff_height
Global $menueditorGUI_width = (866*$DPI)+$Clientsize_diff_width, $menueditorGUI_height = (677*$DPI)+$Clientsize_diff_height


Global $hoehe_des_Controleditors = 707*$DPI
Global $breite_des_Controleditors = 332*$DPI
Global $control_editor_tab_wechselt_mit_maus = 0
Global $Buffer_tabpage=""
Global $dll = DllOpen("user32.dll")
global $user32 = DllOpen("user32.dll")
global $kernel32 = DllOpen("kernel32.dll")
Global $default_style = "0x000000,0xFFFFFF,10,Courier New,0,0,0"
Global Const $RECT = "int Left;int Top;int Right;int Bottom"
Global $Control_Markiert = 0 ;1 = es ist etwas markiert  0 = nichts makiert
Global $Markiertes_Control_ID = "" ;ID des aktuell markierten Controls
Global $Ziehe_Gerade = 0
Global $ISN_Languagefile = ""
Global $ISN_Scriptdir = ""
;Multiselection
Global $Control_Markiert_MULTI = 0
Global $Markierte_Controls_IDs_leer[500]
Global $Markierte_Controls_IDs[500]
Global $Markierte_Controls_Sections[500]
Global $Resize_Oben_Links_Multi[500]
Global $Resize_Oben_Mitte_Multi[500]
Global $Resize_Oben_Rechts_Multi[500]
Global $Resize_Unten_Links_Multi[500]
Global $Resize_Unten_Mitte_Multi[500]
Global $Resize_Unten_Rechts_Multi[500]
Global $Resize_Links_Mitte_Multi[500]
Global $Resize_Rechts_Mitte_Multi[500]
Global $Zwischenablage_Array[1]
Global $Control_Lock_Status_Multi = "0"
Global $ISN_Dark_Mode = "false"
if iniread($Pfad_zur_Studioconfig, "config", "skin", "") = "dark theme" then $ISN_Dark_Mode = "true"
Global $ISN_Hintergrundfarbe = 0xFFFFFF
if $ISN_Dark_Mode = "true" then $ISN_Hintergrundfarbe = 0x4E4E4E
Global $ISN_Schriftfarbe = 0x000000
if $ISN_Dark_Mode = "true" then $ISN_Schriftfarbe = 0xFFFFFF
Global $ISN_Schriftfarbe_titel = 0x003399
if $ISN_Dark_Mode = "true" then $ISN_Schriftfarbe_titel = 0xFFFFFF
Global $GUI_Farbe = 0xFFFFFF
if $ISN_Dark_Mode = "true" then $GUI_Farbe = 0x4E4E4E
Global $Toolbox_Farbe = 0xFFFFFF
if $ISN_Dark_Mode = "true" then $Toolbox_Farbe = 0x5F5F5F
Global $Window_TOP_IMG = $ISN_AutoIt_Studio_EXE_Path&"\Data\wintop.jpg"
Global $Window_Row_Bottom_IMG = $ISN_AutoIt_Studio_EXE_Path&"\Data\row_bottom.jpg"
Global $Window_TOP_IMG_Dark = $ISN_AutoIt_Studio_EXE_Path&"\Data\wintop_dark.png"
Global $Window_Row_Bottom_IMG_Dark = $ISN_AutoIt_Studio_EXE_Path&"\Data\row_bottom_dark.png"

Global $Tab_image_top = @scriptdir&"\Data\tab_white_top.png"
Global $Tab_image_middle = @scriptdir&"\Data\tab_white_middle.png"
Global $Tab_image_middle_active = @scriptdir&"\Data\tab_white_middle_active.png"
Global $Tab_image_bottom = @scriptdir&"\Data\tab_white_bottom.png"
if $ISN_Dark_Mode = "true" then
$Tab_image_top = @scriptdir&"\Data\tab_black_top.png"
$Tab_image_middle = @scriptdir&"\Data\tab_black_middle.png"
$Tab_image_middle_active = @scriptdir&"\Data\tab_black_middle_active.png"
$Tab_image_bottom = @scriptdir&"\Data\tab_black_bottom.png"
EndIf


Global $Leeres_Array[1] ;Leeres Array
_ArrayDelete($Leeres_Array, 0) ;Für leeres Array



Global $Control_Editor_ist_zusammengeklappt = 0
Global $Hoehe_Control_Editor_zusammengeklappt = 28*$DPI
Global $Farbe_Func_Textmode = 0xE0DCFF
if $Current_ISN_Skin = "dark theme" then $Farbe_Func_Textmode = 0x5E569E

Global $Resize_Oben_Links
Global $Resize_Oben_Mitte
Global $Resize_Oben_Rechts
Global $Resize_Unten_Links
Global $Resize_Unten_Rechts
Global $Resize_Unten_Mitte
Global $Resize_Links_Mitte
Global $Resize_Rechts_Mitte

Global $Farbe_Dockstrich = 0x983FEA
Global $Docklabel_X_links
Global $Docklabel_X_rechts
Global $Docklabel_Y_oben
Global $Docklabel_Y_unten
Global $found_x_links = 0
Global $found_x_rechts = 0
Global $found_y_oben = 0
Global $found_y_unten = 0
Global $Dock_Bewegungsraster = 3
Global Const $AC_SRC_ALPHA = 1

DirCreate($Arbeitsverzeichnis & "\Data\Plugins\formstudio2")
Global $Settings_file = $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\settings.ini"
Global $GroesenLimit = iniread($Settings_file, "settings", "sizelimit", "4") ;Ein Control kann nicht kleiner als 4x4 sein
Global $Use_Redraw = iniread($Settings_file, "settings", "redraw", "1")
Global $Use_raster = iniread($Settings_file, "settings", "raster", "1")
Global $AutoITEXE_Path = iniread($Pfad_zur_Studioconfig, "config", "autoitexe", "")
Global $Use_repos = iniread($Settings_file, "settings", "repos", "1")
Global $Draw_grid_in_gui = iniread($Settings_file, "settings", "draw_grid", "0")
Global $Raster = iniread($Settings_file, "settings", "raster_size", "10")
if $Raster < 1 then $Raster = "1"
Global $Show_docklines = iniread($Settings_file, "settings", "showdocklines", "1")
Global $Anordnungsraster = iniread($Settings_file, "settings", "spacing_distance", "5")
Global $Extracode_beim_Testen_Ignorieren = iniread($Settings_file, "settings", "ignore_extracode_when_testing", "0")
Global $Extracode_beim_Designen_Ignorieren = iniread($Settings_file, "settings", "ignore_extracode_when_designing", "0")

Global $FormStudio_Global_Handle_deklaration = iniread($Settings_file, "settings", "Handle_deklaration", "")
Global $FormStudio_Global_Handle_deklaration_const = iniread($Settings_file, "settings", "Handle_deklaration_const", "false")
Global $FormStudio_Global_const_modus = iniread($Settings_file, "settings", "const_modus", "variables")
Global $FormStudio_doubleclick_action = iniread($Settings_file, "settings", "doubleclick_action", "extracode")
Global $Use_ISN_Skin = iniread($Settings_file, "settings", "use_isn_skin", "false")





$ret = DllCall("user32", "long", "GetDoubleClickTime")
Global $dblClickTime = $ret[0]
Global $timer, $clicked = False

Global Const $iPI = 3.1415926535897932384626433832795
Global $Grid_Farbe = 0xE2E2E2
Global $GUI_Editor
DirCreate($Arbeitsverzeichnis & "\Data\Plugins\formstudio2\Cache")
Global $My_Random_ID = random(0, 9999999, 1)
Global $Cache_Datei = $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\Cache\formstudio_cache_" & @mon&@MDAY&@sec & @min & @HOUR & $My_Random_ID & ".dat" ;FÜR MULTIUSER
Global $Cache_Datei2 = $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\Cache\formstudio_cache2_" & @mon&@MDAY&@sec & @min & @HOUR & $My_Random_ID & ".dat" ;FÜR MULTIUSER
Global $Lastsavefile = $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\Cache\formstudio_lastsave_"  & @mon&@MDAY&@sec & @min & @HOUR & $My_Random_ID & ".isf" ;FÜR MULTIUSER
Global $Temp_AU3_File = $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\Cache\temp_" & @mon&@MDAY&@sec & @min & @HOUR & $My_Random_ID & ".au3" ;FÜR MULTIUSER
Global $MenuEditor_tempfile = $Arbeitsverzeichnis & "\Data\Plugins\formstudio2\Cache\tempmenu_" & @mon&@MDAY&@sec & @min & @HOUR & $My_Random_ID & ".ini" ;FÜR MULTIUSER
DIM $Childs
Dim $Array_Menu_temp

if not FileExists($Cache_Datei) then _Leere_INI_Datei_erstellen($Cache_Datei)
if not FileExists($Cache_Datei2) then _Leere_INI_Datei_erstellen($Cache_Datei2)
if not FileExists($MenuEditor_tempfile) then _Leere_INI_Datei_erstellen($MenuEditor_tempfile)
Global $Cache_Datei_Handle = _IniOpenFile($Cache_Datei)
Global $Cache_Datei_Handle2 = _IniOpenFile($Cache_Datei2)
Global $MenuEditor_tempfile_handle = _IniOpenFile($MenuEditor_tempfile)



Global $Generierter_Code_ISF = ""
Global $Generierter_Code_AU3 = ""

Global $AktuelleForm_Speicherdatei = "#new#"
Dim $Positionsarray_aller_Controls[1][1]
Global $aRecords ;dummy
Global $pos ;dummy
Global $Load_Form_Progress ;dummy
Global $Form_bearbeitenGUI ;dummy
Global $StudioFenster_inside ;dummy
Global $drag_dummy_item ;dummy
Global $Load_Form ;dummy
Global $hStatus ;dummy
Global $MiniEditor ;dummy
Global $sci ;dummy
Global $hChild ;dummy
Global $Grid_Handle ;dummy
Global $BGimage
Global $Kopiertes_Item
Global $StyleEditor_CNTRL
Global $ExStyleEditor_CNTRL
Global $StyleEditor_State_CNTRL
Global $TABCONTROL_ID = ""
Global $MENUCONTROL_ID = ""
Global $TOOLBARCONTROL_ID = ""
Global $STATUSBARCONTROL_ID = ""
Global $bindintab = 0
Global $smallIconsdll = $ISN_AutoIt_Studio_EXE_Path&"\Data\smallIcons.dll"



Global Enum $id1 = 1000, $id2, $id3, $id4, $id5, $id6, $id7, $id8, $id9, $id10, $id11, $id12, $id13, $id14, $id15, $id16, $id17, $id18, $id19, $id20, $id21, $id22, $id23
Global Enum $idc1 = 2000, $idc2, $idc3, $idc4, $idc5, $idc6, $idc7, $idc8, $idc9, $idc10, $idc11, $idc12, $idc13, $idc14, $idc15, $idc16, $idc17, $idc18, $idc19, $idc20, $idc21, $idc22, $idc23, $Contextmenu_Anordnung_space_vertically, $Contextmenu_Anordnung_space_horizontally, $Contextmenu_Onclickfunc,$Contextmenu_Textbearbeiten,$Contextmenu_GUIEigenschaften,$Contextmenu_Extracode,$Contextmenu_Tab_Tabitem_Handle
Global Enum $bt1 = 3000, $bt2, $bt3, $bt4, $bt5, $bt6, $bt7, $bt8, $bt9, $bt10, $bt11, $bt12, $bt13, $bt14, $bt15, $bt16, $bt17, $bt18, $bt19, $bt20, $bt21, $bt22
Global $Mausposition_bei_Contextmenue_erscheinen
Global $aStrings[30]

;_______Default-Styles
Global $Default_Button = 1342373888
Global $Default_Label = 1342308608
Global $Default_Input = 1342374016
Global $Default_Checkbox = 1342373891
Global $Default_Radio = 1342373897
Global $Default_Image = 1342308622
Global $Default_Slider = 1342308353
Global $Default_Progress = 1342308352
Global $Default_Icon = 1342374147
Global $Default_Combo = 1342374466
Global $Default_Edit = 1345523908
Global $Default_Group = 1342308359
Global $Default_Listbox = 1350762499
Global $Default_Tab = 1409482816
Global $Default_Date = 1375797252
Global $Default_calendar = 1342242816
Global $Default_listview = 1342373901
Global $Default_softbutton = 1342373888
Global $Default_ip = 1342242816
Global $Default_treeview = 1342242871
;_____
