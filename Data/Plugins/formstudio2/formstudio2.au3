;----------------------------------------------
;ISN Form Studio 2 by ISI360
;----------------------------------------------
;Autoit Wrapper
#AutoIt3Wrapper_Res_Fileversion=2.73
#AutoIt3Wrapper_Res_ProductVersion=2.73
#AutoIt3Wrapper_Res_LegalCopyright=ISI360
#AutoIt3Wrapper_Res_Description=ISN Form Studio 2 Plugin
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=ProductName|ISN Form Studio 2
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_HiDpi=Y



Global $Programmversion = "Version 2.73"
Global $DEBUG = "false" ;Falls das FormStudio ohne ISN getestet wird (Formstudio kann mit ESC geschlossen werden)


#include "includes\isnautoitstudio_plugin.au3"
Global $Mailslot_Handle = _ISNPlugin_erstelle_Mailslot() ;Erstellt für das Plugin einen Mailslot wodurch das Plugin mit dem ISN komunizieren kann.
If @error Then
	MsgBox(48 + 262144, "Error", "Mailslot für dieses Plugin konnte nicht erstellt werden!")
	Exit
EndIf





;AutoIt Optionen
Opt("GUIResizeMode", 802) ;0=no resizing, <1024 special resizing
Opt("GUIOnEventMode", 1) ;0=disabled, 1=OnEvent mode enabled
Opt("MouseCoordMode", 2) ;1=absolute, 0=relative, 2=client
Opt("GUICoordMode", 1) ;1=absolute, 0=relative, 2=cell
Opt("GUICloseOnESC", 0)
If $DEBUG = "true" Then
	Opt("GUICloseOnESC", 1) ;1=ESC  closes, 0=ESC won't close*
	OnAutoItExitRegister("_exit")
EndIf

;Sicherheitsstufe, falls der User versucht das FormStudio ohne ISN zu starten
If $DEBUG <> "true" Then
	#NoTrayIcon
	If $CmdLine[0] = 0 Then
		MsgBox(16, "Fehler (Error)", "Dieses Programm ist Teil des ISN AutoIt Studios und kann nicht alleine gestartet werden!" & @CRLF & @CRLF & "This program is part of the ISN AutoIt Studio and cannot be started separately!")
		Exit
	EndIf
	Global $Filetoopen = $CmdLine[1]
EndIf

If $DEBUG = "true" Then Global $Filetoopen = "C:\Users\" & @UserName & "\Google Drive\ISN AutoIt Studio\Projects\Testprojekt 2\forms\was.isf"
;~ if $DEBUG = "true" then Global $Filetoopen = "C:\Users\isi\Google Drive\ISN AutoIt Studio\Projects\PC Aufbereitungs Tool\Forms\test_gui.isf"


#include <GuiStatusBar.au3>
#include "includes\IniEx.au3"
#include "includes\USkin.au3"

;Prüfe ob die zu öffnende datei auch wirklich existiert
If Not FileExists($Filetoopen) Then
	MsgBox(16, "Error", "Cannot open file!" & @CRLF & @CRLF & $Filetoopen & @CRLF & @CRLF & "Form Studio 2 will exit now!")
	Exit
EndIf

#include <WindowsConstants.au3>
#include <WinAPI.au3>


$StudioFenster = GUICreate("ISN FormStudio 2", @DesktopWidth - 200, @DesktopHeight - 200, -1, -1, $WS_POPUP, BitOR($WS_EX_CLIENTEDGE, $WS_EX_TOOLWINDOW))
If $DEBUG = "false" Then
	If _ISNPlugin_Warte_auf_ISN_und_initialisiere_Kommunikation($Mailslot_Handle, $StudioFenster) = 0 Then ;Wichtig! Dadurch wird der Kommunikationsaufbau abgeschlossen!
		MsgBox(16, "Fehler (Error)", "Kommunikation mit dem ISN nicht möglich! (Unable to communicate with the ISN!)")
		Exit ;ISN spricht nicht mit mir...ich werde nicht gebraucht :(
	EndIf
 EndIf

#include "includes\deklarationen.au3"
If $DEBUG <> "true" Then _WinAPI_SetWindowPos($StudioFenster, $HWND_TOPMOST, 9000, 9000, @DesktopWidth - 200, @DesktopHeight - 200, $SWP_SHOWWINDOW)
$p = WinGetClientSize($StudioFenster, "")
guiswitch($StudioFenster)
$background_pic = GUICtrlCreatePic(@ScriptDir & "\data\background.jpg", 174* $DPI, 0, $p[0] - 100, $p[1], $WS_CLIPSIBLINGS)
GUICtrlSetState($background_pic, 128)
GUISetFont($Default_font_size, 400, 0, $Default_font, $StudioFenster)
If $ISN_Dark_Mode = "true" Then GUICtrlSetImage($background_pic, @ScriptDir & "\data\background_dark.jpg")
If $ISN_Dark_Mode = "true" Then GUISetBkColor($GUI_Farbe, $StudioFenster)

;Skin auch im Plugin Anwenden
_Uskin_LoadDLL($ISN_AutoIt_Studio_EXE_Path & "\Data\USkin.dll")
If $Use_ISN_Skin = "true" Then
	If Not FileExists(_PathFull($ISN_AutoIt_Studio_EXE_Path & "\Data\Skins\" & $Current_ISN_Skin)) Then $Current_ISN_Skin = "#none#"
	$pfad = _PathFull($ISN_AutoIt_Studio_EXE_Path & "\Data\Skins\" & $Current_ISN_Skin & "\skin.msstyles")
	If $Current_ISN_Skin <> "#none#" Then
		_USkin_Init($pfad) ;skin zuweisen
	EndIf
EndIf



$Groesse_studioFenster = WinGetClientSize($StudioFenster)
If IsArray($Groesse_studioFenster) Then GUICtrlSetPos($background_pic, 174*$DPI, 0, $Groesse_studioFenster[0] - 100, $Groesse_studioFenster[1])
$Loading1_Ani = _ISNPlugin_Get_Variable_From_ISN_AutoIt_Studio("$Loading1_Ani")


;Includes
#include <GUIConstantsEx.au3>
#include "includes\DPI_Scaling.au3"
#include <Constants.au3>
#include <String.au3>
#include <GuiEdit.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include "includes\scintilla.h.au3"
#include <GuiToolbar.au3>
#include <GuiImageList.au3>
#include <StructureConstants.au3>
#include <Misc.au3>
#include <ProgressConstants.au3>
#include <ButtonConstants.au3>
#include <GuiToolTip.au3>
#include <Color.au3>
#include <GuiComboBox.au3>
#include <WinAPILocale.au3>
#include <ScrollBarConstants.au3>
#include <GuiSlider.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include <GuiListView.au3>
#include <file.au3>
#include <ClipBoard.au3>
#include <TabConstants.au3>
#include <ComboConstants.au3>
#include <GuiTab.au3>
#include <DateTimeConstants.au3>
#include <GuiMenu.au3>
#include <GDIPlus.au3>
#include <Timers.au3>
#include <Math.au3>
#include <ListboxConstants.au3>
#include <GuiIPAddress.au3>
#include <UpdownConstants.au3>
#include "includes\GUIScrollbars_Ex.au3"
#include "includes\Icons.au3"


Global $hToolTip = _GUIToolTip_Create($Studiofenster) ;Globaler Tooltip Handler


$posW = WinGetPos($StudioFenster)
;Erstelle die GUI
$Side1_PIC = GUICtrlCreatePic(@ScriptDir &"\data\side.jpg", 0, 0, 168 * $DPI, @DesktopHeight)
If $ISN_Dark_Mode = "true" Then GUICtrlSetImage($Side1_PIC, "")
GUICtrlSetState(-1, $GUI_DISABLE)
$blue_1 = GUICtrlCreatePic(@ScriptDir &"\data\blue.jpg", 168 * $DPI, 0, 6 * $DPI, @DesktopHeight)
If $ISN_Dark_Mode = "true" Then GUICtrlSetImage($blue_1, @ScriptDir & "\data\grey.jpg")
GUICtrlSetState(-1, $GUI_DISABLE)



; Add Icons from system DLL shell32.dll to ImageList
$hToolBarImageListNorm = _GUIImageList_Create(16, 16, 5, 3)
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1794) ;button
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1813) ;label
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 795) ;input
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1360) ;checkbox
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1174) ;radio
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1818) ;image
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1824) ;slider
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1819) ;progress
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1163) ;updown
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1081) ;icon
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1798) ;combo
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 91) ;edit
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1809) ;group
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1814) ;listbox
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1077) ;tab
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1802) ;date
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1795) ;calendar
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1815) ;listview
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1189) ;softbutton
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1432) ;ip
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1716) ;treeview
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1915) ;menu
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1176) ;com object
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 590) ;dummy
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 471) ;graphic
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1919) ;toolbar
_GUIImageList_AddIcon($hToolBarImageListNorm, $smallIconsdll, 1920) ;statusbar

;Add Controls in Toolbox

If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
	GUICtrlCreatePic("", 5, 5, 25, 24, $SS_NOTIFY + $SS_CENTERIMAGE, $WS_EX_CLIENTEDGE)
	_SetIconAlpha(-1, $smallIconsdll, 1301 + 1, 16, 16)
Else
	GUICtrlCreateButton("", 5, 5, 25, 24) ;Save
	Button_AddIcon(-1, $smallIconsdll, 1301, 4)
EndIf
_Control_set_DPI_Scaling(-1)
_Control_Add_ToolTip(-1,_ISNPlugin_Get_langstring(84))
GUICtrlSetOnEvent(-1, "_Speichern")
GUICtrlSetResizing(-1, $GUI_DOCKALL)

If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
	GUICtrlCreatePic("", 32, 5, 25, 24, $SS_NOTIFY + $SS_CENTERIMAGE, $WS_EX_CLIENTEDGE)
	_SetIconAlpha(-1, $smallIconsdll, 220 + 1, 16, 16)
Else
	GUICtrlCreateButton("", 32, 5, 25, 24) ;Test form
	Button_AddIcon(-1, $smallIconsdll, 220, 4)
EndIf
_Control_set_DPI_Scaling(-1)
_Control_Add_ToolTip(-1,_ISNPlugin_Get_langstring(85))
GUICtrlSetOnEvent(-1, "_test_code")
GUICtrlSetResizing(-1, $GUI_DOCKALL)

If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
	GUICtrlCreatePic("", 59, 5, 25, 24, $SS_NOTIFY + $SS_CENTERIMAGE, $WS_EX_CLIENTEDGE)
	_SetIconAlpha(-1, $ISN_AutoIt_Studio_EXE_Path&"\autoitstudioicon.ico", 0, 16, 16)
Else
	GUICtrlCreateButton("", 59, 5, 25, 24) ;Code
	Button_AddIcon(-1, $ISN_AutoIt_Studio_EXE_Path&"\autoitstudioicon.ico", 0, 4)
EndIf
_Control_set_DPI_Scaling(-1)
_Control_Add_ToolTip(-1,_ISNPlugin_Get_langstring(86))
GUICtrlSetOnEvent(-1, "_Code_Generieren")
GUICtrlSetResizing(-1, $GUI_DOCKALL)

If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
	GUICtrlCreatePic("", 86, 5, 24, 24, $SS_NOTIFY + $SS_CENTERIMAGE, $WS_EX_CLIENTEDGE)
	_SetIconAlpha(-1, $smallIconsdll, 780 + 1, 16, 16)
Else
	GUICtrlCreateButton("", 86, 5, 24, 24) ;GUI eigenschaft
	Button_AddIcon(-1, $smallIconsdll, 780, 4)
EndIf
_Control_set_DPI_Scaling(-1)
_Control_Add_ToolTip(-1,_ISNPlugin_Get_langstring(87))
GUICtrlSetOnEvent(-1, "_Show_Edit_Form")
GUICtrlSetResizing(-1, $GUI_DOCKALL)

If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
	GUICtrlCreatePic("", 113, 5, 25, 24, $SS_NOTIFY + $SS_CENTERIMAGE, $WS_EX_CLIENTEDGE)
	_SetIconAlpha(-1, $smallIconsdll, 479 + 1, 16, 16)
Else
	GUICtrlCreateButton("", 113, 5, 25, 24) ;Reihenfolge der Controls
	Button_AddIcon(-1, $smallIconsdll, 479, 4)
EndIf
_Control_set_DPI_Scaling(-1)
_Control_Add_ToolTip(-1,_ISNPlugin_Get_langstring(175))
GUICtrlSetOnEvent(-1, "_Zeige_Control_Reihenfolge_GUI")
GUICtrlSetResizing(-1, $GUI_DOCKALL)

If $Current_ISN_Skin <> "#none#" And $Use_ISN_Skin = "true" Then
	GUICtrlCreatePic("", 140, 5, 25, 24, $SS_NOTIFY + $SS_CENTERIMAGE, $WS_EX_CLIENTEDGE)
	_SetIconAlpha(-1, $smallIconsdll, 1082 + 1, 16, 16)
Else
	GUICtrlCreateButton("", 140, 5, 25, 24) ;setup
	Button_AddIcon(-1, $smallIconsdll, 1082, 4)
EndIf
_Control_set_DPI_Scaling(-1)
_Control_Add_ToolTip(-1,_ISNPlugin_Get_langstring(119))
GUICtrlSetOnEvent(-1, "_Show_Setup")
GUICtrlSetResizing(-1, $GUI_DOCKALL)

GUICtrlCreateGroup("", 5, 28, 160, 10) ;Sep
_Control_set_DPI_Scaling(-1)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$Toolbox_listview = GUICtrlCreateListView("", 5 * $DPI, 45 * $DPI, 160 * $DPI, 540 * $DPI, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL, $LVS_NOCOLUMNHEADER))
GUICtrlSetResizing(-1, $GUI_DOCKALL)
_GUICtrlListView_SetExtendedListViewStyle($Toolbox_listview, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES), $LVS_EX_UNDERLINEHOT)
_GUICtrlListView_InsertColumn($Toolbox_listview, 0, "", 150)
If $ISN_Dark_Mode = "true" Then
	GUICtrlSetBkColor($Toolbox_listview, $Toolbox_Farbe)
	GUICtrlSetColor($Toolbox_listview, 0xFFFFFF)
 EndIf


If _ist_windows_vista_oder_hoeher() And $ISN_Dark_Mode <> "true" Then _GUICtrlListView_EnableGroupView($Toolbox_listview) ;Groupview nur ab win Vista
_GUICtrlListView_SetImageList($Toolbox_listview, $hToolBarImageListNorm, 1)
_GUICtrlListView_JustifyColumn($Toolbox_listview, 0, 2)
_GUICtrlListView_InsertGroup($Toolbox_listview, -1, 0, "") ;Standard
_GUICtrlListView_SetGroupInfo($Toolbox_listview, 0, _ISNPlugin_Get_langstring(21), 1, $LVGS_COLLAPSIBLE)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(22), 0) ;button
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 0, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(23), 1) ;label
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 1, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(24), 2) ;input
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 2, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(25), 3) ;checkbox
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 3, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(26), 4) ;radio
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 4, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(27), 5) ;image
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 5, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(28), 6) ;slider
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 6, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(29), 7) ;progress
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 7, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(31), 8) ;updown
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 8, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(32), 9) ;icon
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 9, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(33), 10) ;combo
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 10, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(34), 11) ;edit
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 11, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(35), 12) ;group
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 12, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(36), 13) ;listbox
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 13, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(138), 20) ;treeview
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 14, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(232), 23) ;dummy
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 15, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(246), 24) ;Graphic
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 16, 0)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(258), 26) ;Statusbar
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 17, 0)



_GUICtrlListView_InsertGroup($Toolbox_listview, -1, 1, "")
_GUICtrlListView_SetGroupInfo($Toolbox_listview, 1, _ISNPlugin_Get_langstring(37), 1, $LVGS_COLLAPSIBLE) ;Erweiterte

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(38), 14) ;tab
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 18, 1)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(39), 15) ;date
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 19, 1)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(40), 16) ;calendar
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 20, 1)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(41), 17) ;listview
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 21, 1)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(124), 18) ;softbutton
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 22, 1)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(192), 21) ;Menu
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 23, 1)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(136), 19) ;ip
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 24, 1)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(214), 22) ;COM-Object
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 25, 1)

_GUICtrlListView_AddItem($Toolbox_listview, _ISNPlugin_Get_langstring(252), 25) ;Toolbar
_GUICtrlListView_SetItemGroupID($Toolbox_listview, 26, 1)

GUISetOnEvent($GUI_EVENT_CLOSE, "_exit", $StudioFenster)
$size = WinGetPos($StudioFenster)
GUISetState(@SW_SHOWNOACTIVATE, $StudioFenster)
GUISetState(@SW_DISABLE, $GUI_Editor)
GUISetState(@SW_DISABLE, $StudioFenster)


$winsize = WinGetClientSize($StudioFenster)
$winpos = WinGetPos($StudioFenster)
$pos = ControlGetPos($StudioFenster, "", $blue_1)


;Logo links unten
; create pic control last
If IsArray($winpos) And IsArray($winsize) Then
	_GDIPlus_Startup()
	$hImage1 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\data\logo.png")
	$Logo = GUICtrlCreatePic('', 180 * $DPI, $winsize[1] - 100, _GDIPlus_ImageGetWidth($hImage1), _GDIPlus_ImageGetHeight($hImage1))
	GUICtrlSetState($Logo, $GUI_HIDE)
	$hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage1)
	_WinAPI_DeleteObject(GUICtrlSendMsg($Logo, 0x0172, 0, $hBMP1))
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_Shutdown()
EndIf



If _ist_windows_8_oder_hoeher() Then
	$StudioFenster_inside = GUICreate("inside", 0, 600, 0, 0, $WS_POPUP, $WS_EX_LAYERED, $StudioFenster)
	_WinAPI_SetParent($StudioFenster_inside, $StudioFenster)
Else
	$StudioFenster_inside = GUICreate("inside", 0, 600, 0, 0, $WS_POPUP, $WS_EX_MDICHILD + $WS_EX_LAYERED, $StudioFenster)
EndIf
GUICtrlCreateInput("", -7000, 12, 212, 26, -1, -1) ;Dummy, sonst funktioniert das scrolling nicht!
$Groesse_studioFenster_inside = WinGetClientSize($StudioFenster_inside, "")
GUISetBkColor(0xFFFFF0, $StudioFenster_inside)
If IsArray($winpos) And IsArray($pos) Then _WinAPI_SetWindowPos($StudioFenster_inside, $HWND_NOTOPMOST, $winpos[0] + ($pos[0] + $pos[2]) + 2, $winpos[1] + ($winpos[3] - $winsize[1]) - 2, $winsize[0] - ($pos[0] + $pos[2]), $winsize[1], $SWP_SHOWWINDOW)
_WinAPI_SetLayeredWindowAttributes($StudioFenster_inside, 0xFFFFF0, 255)
$StudioFenster_inside_Text1 = GUICtrlCreateLabel(_ISNPlugin_Get_langstring(51), 75 * $DPI, 12 * $DPI, 212 * $DPI, 26 * $DPI, -1, -1)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetFont(-1, 12, 700, Default, $Default_font)
If $ISN_Dark_Mode = "true" Then GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, "-2")
$StudioFenster_inside_Icon = GUICtrlCreateIcon($Loading1_Ani, -1, 20 * $DPI, 13 * $DPI, 32, 32)
GUICtrlSetState(-1, $GUI_HIDE)
$StudioFenster_inside_load = GUICtrlCreateProgress(0, 0, 283 * $DPI, 10 * $DPI, -1, -1)
GUICtrlSetState(-1, $GUI_HIDE)
$StudioFenster_inside_Text2 = GUICtrlCreateLabel("", 75 * $DPI, 12 * $DPI, 212 * $DPI, 26 * $DPI, $SS_CENTER, -1)
GUICtrlSetFont(-1, 12, 400, Default, $Default_font)
If $ISN_Dark_Mode = "true" Then GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, "-2")
GUICtrlSetState(-1, $GUI_HIDE)




;Die restlichen Includes
#include "includes\Forms.au3"
#include "includes\Addons2.au3"
#include "includes\Addons3.au3"
#include "includes\Addons.au3"
#include "includes\converter.au3"
#include "includes\menueditor.au3"




_SetStatustext(_ISNPlugin_Get_langstring(46))
Create_Default_Cache()
$iLastTab1 = 0 ;starttab von editforms


_Minieditor_tab_select(0)
_Form_bearbeitenGUI_tab_select(0)
_Elemente_an_Fesntergroesse_anpassen()

;~ $GUI_Editor = GUICreate("Form1", 640, 480, 10, 10, BitOR($WS_CAPTION, $WS_POPUP, $WS_SIZEBOX), -1,$Studiofenster) ;Dummygui die wieder gelöscht wird

If $Draw_grid_in_gui = "1" Then _DrawGrid($Raster, $Grid_Farbe)


GUISetState(@SW_SHOWNOACTIVATE, $StudioFenster_inside)
_resize_elements()


_Load_from_file($Filetoopen) ;Lade die .isf Datei

_GUIScrollbars_Generate($StudioFenster_inside, 3000, 2000)
GUICtrlSetState($Logo, $GUI_SHOW)

If $DEBUG = "false" Then
	_ISNPlugin_Get_Variable("$ISN_Hintergrundfarbe", "$Fenster_Hintergrundfarbe", $Mailslot_Handle)
	_ISNPlugin_Get_Variable("$ISN_Schriftfarbe", "$Schriftfarbe", $Mailslot_Handle)
	_ISNPlugin_Get_Variable("$ISN_Dark_Mode", "$ISN_Dark_Mode", $Mailslot_Handle)
EndIf

GUISetState(@SW_ENABLE, $GUI_Editor)
GUISetState(@SW_ENABLE, $StudioFenster)
GUISetState(@SW_ENABLE, $StudioFenster_inside)
GUISetState(@SW_ENABLE, $Formstudio_controleditor_GUI)




;Registriere Windows Messages
GUIRegisterMsg($WM_CONTEXTMENU, "WM_CONTEXTMENU")
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_MOUSEWHEEL, "_Mousewheel")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")
GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")



;setze Hilfetexte für einige Inputs
_Input_Setze_Hilfetext($MiniEditor_ControlState, _ISNPlugin_Get_langstring(242))
_Input_Setze_Hilfetext($MiniEditor_Style, _ISNPlugin_Get_langstring(242))
_Input_Setze_Hilfetext($MiniEditor_ExStyle, _ISNPlugin_Get_langstring(242))
_Input_Setze_Hilfetext($Form_bearbeitenStyle, _ISNPlugin_Get_langstring(242))
_Input_Setze_Hilfetext($Form_bearbeitenExstyle, _ISNPlugin_Get_langstring(242))


;WinActivate($GUI_Editor)
GUISwitch($GUI_Editor)
GUISetState(@SW_SHOWNOACTIVATE, $Formstudio_controleditor_GUI)
GUISetState(@SW_SHOWNOACTIVATE, $GUI_Editor)
;if not _ist_windows_8_oder_hoeher() then _WinAPI_RedrawWindow($StudioFenster)

;Events für das ISN Registrieren
_ISNPlugin_Register_ISN_Event($ISN_AutoIt_Studio_Event_Exit_Plugin,"_exit")
_ISNPlugin_Register_ISN_Event($ISN_AutoIt_Studio_Event_Save_Command,"_SPEICHERN")
_ISNPlugin_Register_ISN_Event($ISN_AutoIt_Studio_Event_Check_Changes_before_Exit,"_Pruefe_Aenderungen_vor_dem_schliessen")
_ISNPlugin_Register_ISN_Event($ISN_AutoIt_Studio_Event_Resize,"_resize_elements")





While 1
	Local $Pos_oldpos
	Sleep(10)

	$winsize = WinGetClientSize($StudioFenster)
	$winpos = WinGetPos($StudioFenster)
	$pos_bluecontrol = ControlGetPos($StudioFenster, "", $blue_1)
    $Studiofenster_State = WinGetState($StudioFenster)
	If BitAND($Studiofenster_State, 4) Then
			   GUISetState(@SW_ENABLE, $GUI_Editor)
			Else
			   GUISetState(@SW_DISABLE, $GUI_Editor)
	EndIf

	If IsArray($pos_bluecontrol) And IsArray($winsize) And IsArray($winsize) Then
		If _ist_windows_8_oder_hoeher() Then
			WinMove($StudioFenster_inside, "", ($pos_bluecontrol[0] + $pos_bluecontrol[2]) + 2, ($winpos[3] - $winsize[1]) - 2, $winsize[0] - ($pos_bluecontrol[0] + $pos_bluecontrol[2]), $winsize[1])
		Else
			WinMove($StudioFenster_inside, "", $winpos[0] + ($pos_bluecontrol[0] + $pos_bluecontrol[2]) + 2, $winpos[1] + ($winpos[3] - $winsize[1]) - 2, $winsize[0] - ($pos_bluecontrol[0] + $pos_bluecontrol[2]), $winsize[1])
		EndIf
		If $Logo <> "" Then GUICtrlSetPos($Logo, 180 * $DPI, $winsize[1] - 100)
	EndIf

	$iCurrTab1 = _GUICtrlTab_GetCurFocus($gui_setup_tab)
	; If the Tab has changed
	If $iCurrTab1 <> $iLastTab1 Then
		; Store the value for future comparisons
		$iLastTab1 = $iCurrTab1
		; Show/Hide controls as required
		_Form_bearbeitenGUI_tab_select($iCurrTab1)
	EndIf

	$Cursor_INFO = GUIGetCursorInfo($GUI_Editor)

	If _IsPressed("01", $dll) And WinActive($GUI_Editor) And IsArray($Cursor_INFO) Then
		_Pruefe_auf_doppelklick() ;Doppelkick auf Control prüfen
		_WinAPI_SetWindowPos($GUI_Editor, $HWND_BOTTOM, 200, 200, 200, 200, $SWP_NOSIZE + $SWP_NOACTIVATE + $SWP_NOMOVE)
		If $Control_Markiert_MULTI = 1 And _IsPressed("11", $dll) = 0 Then
;~ 				sleep(150)
			If _IsPressed("01", $dll) = 0 Then
				Entferne_Makierung()
			EndIf
		EndIf


;~ ;Erster Check ob es sich nicht doch um zb. ein Combo handelt -> Get Parent vom Edit
		If $Cursor_INFO[4] = "" Then
			$tPoint = _WinAPI_GetMousePos()
			$Clicked_Handle = _WinAPI_GetParent(_WinAPI_WindowFromPoint($tPoint))
			If $Clicked_Handle <> 0 Then
				$Cursor_INFO[4] = _WinAPI_GetDlgCtrlID($Clicked_Handle)
			EndIf
		EndIf

		If $Cursor_INFO[4] = "" Then
			If $Markiertes_Control_ID = "" And $Ziehe_Gerade = 0 Then _Ziehe_Rahmen()
			If _IsPressed("01", $dll) And _Ist_Maus_in_einem_Markierten_control() = False Then
				If $Markiertes_Control_ID <> "" Or $Control_Markiert_MULTI = 1 Then _Mini_Editor_Einstellungen_Uebernehmen()
;~ 			if $Control_Markiert_MULTI = 1 AND _IsPressed("01", $dll) AND _Ist_Maus_in_einem_Markierten_control() = false then
				Entferne_Makierung()
				ContinueLoop
			EndIf


		Else

			If _IsPressed("11", $dll) And $Control_Markiert_MULTI = 0 And Not $Markiertes_Control_ID = "" Then _Switch_from_singe_to_multiselection_mode($Cursor_INFO[4])
			If _IsPressed("11", $dll) And $Control_Markiert_MULTI = 1 Then
				_Add_control_to_Multiselection($Cursor_INFO[4])
				ContinueLoop
			EndIf
			If $Control_Markiert_MULTI = 1 And _Ist_Maus_in_einem_Markierten_control() = True Then _DragMe_Multi($Cursor_INFO[4])




			If _IsPressed("11", $dll) = 0 And $Control_Markiert_MULTI = 1 And $Markiertes_Control_ID = "" And _IsPressed("01", $dll) Then Entferne_Makierung()
			If $Control_Markiert = 0 Or $Cursor_INFO[4] <> $Markiertes_Control_ID Then

				If $Markiertes_Control_ID <> "" Then _Mini_Editor_Einstellungen_Uebernehmen()


				Markiere_Controls_EDIT($Cursor_INFO[4])
				Sleep(50)

			Else
				_DragMe()
			EndIf
		EndIf
;~ 		if _IsPressed("01", $dll) AND $Cursor_INFO[4] = $BGimage AND $Ziehe_Gerade = 0 then _Ziehe_Rahmen()
;~ 		if _IsPressed("01", $dll) AND $Cursor_INFO[4] = $Grid_Handle AND $Ziehe_Gerade = 0 then _Ziehe_Rahmen()
		If IsHWnd($GUI_Editor) Then

			If _IsPressed("01", $dll) And $Cursor_INFO[4] <> $Markiertes_Control_ID And (_IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Cursor_INFO[4]), "id", "#error#") = "#error#" Or _IniReadEx($Cache_Datei_Handle, ControlGetHandle($GUI_Editor, "", $Cursor_INFO[4]), "id", "#error#") = "") And $Ziehe_Gerade = 0 Then _Ziehe_Rahmen()
		EndIf
	EndIf

	If WinActive($GUI_Editor) Then
		If _IsPressed("11", $dll) And _IsPressed("41", $dll) Then ;STRG+A
			_Markiere_alle_controls()
			While _IsPressed("11", $dll) And _IsPressed("41", $dll)
				Sleep(10)
			WEnd
		EndIf
	EndIf

	If WinActive($GUI_Editor) And ($Control_Markiert = 1 Or $Control_Markiert_MULTI = 1) Then
		If _IsPressed("43", $dll) Then
			copy_item()
			While _IsPressed("43", $dll)
				Sleep(10)
			WEnd
		EndIf

		;Feintuning bei gedrückter STRG Taste
		If _IsPressed("11", $dll) Then
			$val = 1
		Else
			$val = $Raster
		EndIf

		;Move Control Right
		If _IsPressed("27", $dll) Then
			$Pos_oldpos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
			$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
			$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
			$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
			$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

			GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
			GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
			GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
			GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
			_Positionsarray_aller_Controls_aufbauen()

			While (_IsPressed("27", $dll))
				If $Control_Markiert_MULTI = 0 Then
					$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
					$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
					If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
					If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 0 Then
						GUICtrlSetPos($Markiertes_Control_ID, $pos[0] + $val, $pos[1])
						_Pruefe_Ob_Control_an_anderes_andockt_exakt($Markiertes_Control_ID)
					EndIf
					_Aktualisiere_Rahmen()
				Else
					$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
					If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[1], $pos[0] + $val, $pos[1], $pos[2], $pos[3])
					_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
					$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
					_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "x", $pos[0])
					_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "y", $pos[1])
					For $r = 2 To $Markierte_Controls_IDs[0]
						$Pos_w = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
						If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then
							GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_w[0] + $val, $Pos_w[1])
							_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
							$Pos_w = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
							_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_w[0])
							_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_w[1])
						EndIf
					Next
				EndIf
				Sleep(100)
			WEnd
			If $Control_Markiert_MULTI = 0 Then

				_Update_Control_Cache($Markiertes_Control_ID)
				If $Markiertes_Control_ID = $TABCONTROL_ID Then _Resize_tabcontent($Pos_oldpos[0], $Pos_oldpos[1])
				If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "type", "") = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $Pos_oldpos[0], $Pos_oldpos[1], $Pos_oldpos[2], $Pos_oldpos[3])
				If $Markiertes_Control_ID = $TABCONTROL_ID Then
					_Lese_MiniEditor($TABCONTROL_ID)
				Else
					_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
				EndIf
			Else
				_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
			EndIf
			GUICtrlDelete($Docklabel_X_links)
			GUICtrlDelete($Docklabel_X_rechts)
			GUICtrlDelete($Docklabel_Y_oben)
			GUICtrlDelete($Docklabel_Y_unten)
		EndIf

		;Move Control UP
		If _IsPressed("26", $dll) Then
			$Pos_oldpos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
			$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
			$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
			$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
			$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

			GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
			GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
			GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
			GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
			_Positionsarray_aller_Controls_aufbauen()

			While (_IsPressed("26", $dll))
				If $Control_Markiert_MULTI = 0 Then
					$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
					$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
					If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
					If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 0 Then
						GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1] - $val)
						_Pruefe_Ob_Control_an_anderes_andockt_exakt($Markiertes_Control_ID)
					EndIf
					_Aktualisiere_Rahmen()

				Else
					$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
					If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[1], $pos[0], $pos[1] - $val, $pos[2], $pos[3])
					_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
					$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
					_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "x", $pos[0])
					_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "y", $pos[1])
					For $r = 2 To $Markierte_Controls_IDs[0]
						$Pos_w = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
						If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then
							GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_w[0], $Pos_w[1] - $val)
							_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
							$Pos_w = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
							_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_w[0])
							_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_w[1])
						EndIf
					Next

				EndIf
				Sleep(100)
			WEnd

			If $Control_Markiert_MULTI = 0 Then
				_Update_Control_Cache($Markiertes_Control_ID)
				If $Markiertes_Control_ID = $TABCONTROL_ID Then _Resize_tabcontent($Pos_oldpos[0], $Pos_oldpos[1])
				If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "type", "") = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $Pos_oldpos[0], $Pos_oldpos[1], $Pos_oldpos[2], $Pos_oldpos[3])
				If $Markiertes_Control_ID = $TABCONTROL_ID Then
					_Lese_MiniEditor($TABCONTROL_ID)
				Else
					_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
				EndIf
			Else
				_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
			EndIf
			GUICtrlDelete($Docklabel_X_links)
			GUICtrlDelete($Docklabel_X_rechts)
			GUICtrlDelete($Docklabel_Y_oben)
			GUICtrlDelete($Docklabel_Y_unten)
		EndIf

		;Move Control DOWN
		If _IsPressed("28", $dll) Then
			$Pos_oldpos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
			$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
			$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
			$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
			$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

			GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
			GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
			GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
			GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
			_Positionsarray_aller_Controls_aufbauen()

			While (_IsPressed("28", $dll))
				If $Control_Markiert_MULTI = 0 Then
					$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
					$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
					If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
					If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 0 Then
						GUICtrlSetPos($Markiertes_Control_ID, $pos[0], $pos[1] + $val)
						_Pruefe_Ob_Control_an_anderes_andockt_exakt($Markiertes_Control_ID)
					EndIf
					_Aktualisiere_Rahmen()
				Else
					$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
					If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[1], $pos[0], $pos[1] + $val, $pos[2], $pos[3])
					_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
					$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
					_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "x", $pos[0])
					_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "y", $pos[1])
					For $r = 2 To $Markierte_Controls_IDs[0]
						$Pos_w = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
						If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then
							GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_w[0], $Pos_w[1] + $val)
							_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
							$Pos_w = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
							_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_w[0])
							_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_w[1])
						EndIf
					Next
				EndIf
				Sleep(100)
			WEnd
			If $Control_Markiert_MULTI = 0 Then
				_Update_Control_Cache($Markiertes_Control_ID)
				If $Markiertes_Control_ID = $TABCONTROL_ID Then _Resize_tabcontent($Pos_oldpos[0], $Pos_oldpos[1])
				If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "type", "") = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $Pos_oldpos[0], $Pos_oldpos[1], $Pos_oldpos[2], $Pos_oldpos[3])
				If $Markiertes_Control_ID = $TABCONTROL_ID Then
					_Lese_MiniEditor($TABCONTROL_ID)
				Else
					_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
				EndIf
			Else
				_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
			EndIf
			GUICtrlDelete($Docklabel_X_links)
			GUICtrlDelete($Docklabel_X_rechts)
			GUICtrlDelete($Docklabel_Y_oben)
			GUICtrlDelete($Docklabel_Y_unten)
		EndIf

		;Move Control Left
		If _IsPressed("25", $dll) Then
			$Pos_oldpos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)

			$Docklabel_X_links = GUICtrlCreateLabel("", 10, 10, 1, 9000)
			$Docklabel_X_rechts = GUICtrlCreateLabel("", 10, 10, 1, 9000)
			$Docklabel_Y_oben = GUICtrlCreateLabel("", 10, 10, 9000, 1)
			$Docklabel_Y_unten = GUICtrlCreateLabel("", 10, 10, 9000, 1)

			GUICtrlSetState($Docklabel_X_links, $GUI_HIDE)
			GUICtrlSetState($Docklabel_X_rechts, $GUI_HIDE)
			GUICtrlSetState($Docklabel_Y_oben, $GUI_HIDE)
			GUICtrlSetState($Docklabel_Y_unten, $GUI_HIDE)
			_Positionsarray_aller_Controls_aufbauen()

			While (_IsPressed("25", $dll))
				If $Control_Markiert_MULTI = 0 Then
					$pos = ControlGetPos($GUI_Editor, "", $Markiertes_Control_ID)
					$Section = ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID)
					If $Markiertes_Control_ID = $TABCONTROL_ID Then $Section = "tab"
					If _IniReadEx($Cache_Datei_Handle, $Section, "locked", 0) = 0 Then
						GUICtrlSetPos($Markiertes_Control_ID, $pos[0] - $val, $pos[1])
						_Pruefe_Ob_Control_an_anderes_andockt_exakt($Markiertes_Control_ID)
					EndIf
					_Aktualisiere_Rahmen()
				Else
					$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
					If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "locked", 0) = 0 Then GUICtrlSetPos($Markierte_Controls_IDs[1], $pos[0] - $val, $pos[1], $pos[2], $pos[3])
					_Aktualisiere_Rahmen_Multi(0, $Markierte_Controls_IDs[1])
					$pos = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[1]))
					_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "x", $pos[0])
					_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[0], "y", $pos[1])
					For $r = 2 To $Markierte_Controls_IDs[0]
						$Pos_w = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
						If _IniReadEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "locked", 0) = 0 Then
							GUICtrlSetPos($Markierte_Controls_IDs[$r], $Pos_w[0] - $val, $Pos_w[1])
							_Aktualisiere_Rahmen_Multi($r - 1, $Markierte_Controls_IDs[$r])
							$Pos_w = ControlGetPos($GUI_Editor, "", GUICtrlGetHandle($Markierte_Controls_IDs[$r]))
							_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "x", $Pos_w[0])
							_IniWriteEx($Cache_Datei_Handle, $Markierte_Controls_Sections[$r - 1], "y", $Pos_w[1])
						EndIf
					Next
				EndIf
				Sleep(100)
			WEnd
			If $Control_Markiert_MULTI = 0 Then
				_Update_Control_Cache($Markiertes_Control_ID)
				If $Markiertes_Control_ID = $TABCONTROL_ID Then _Resize_tabcontent($Pos_oldpos[0], $Pos_oldpos[1])
				If _IniReadEx($Cache_Datei_Handle, GUICtrlGetHandle($Markiertes_Control_ID), "type", "") = "group" Then _Resize_groupcontent($Markiertes_Control_ID, $Pos_oldpos[0], $Pos_oldpos[1], $Pos_oldpos[2], $Pos_oldpos[3])
				If $Markiertes_Control_ID = $TABCONTROL_ID Then
					_Lese_MiniEditor($TABCONTROL_ID)
				Else
					_Lese_MiniEditor(ControlGetHandle($GUI_Editor, "", $Markiertes_Control_ID))
				EndIf
			Else
				_Mini_Editor_Einstellungen_Multi_Felder_Aktivieren()
			EndIf
			GUICtrlDelete($Docklabel_X_links)
			GUICtrlDelete($Docklabel_X_rechts)
			GUICtrlDelete($Docklabel_Y_oben)
			GUICtrlDelete($Docklabel_Y_unten)
		EndIf

		;Lösche
		If _IsPressed("2E", $dll) Then
			If $Control_Markiert_MULTI = 0 Then
				delete_item()
			Else
				_Delete_Multiitem()
			EndIf
		EndIf

	EndIf

	;V
	If _IsPressed("56", $dll) And WinActive($GUI_Editor) Then
		;Entferne_Makierung()
		paste_item()
		While _IsPressed("56", $dll)
			Sleep(10)
		WEnd
	EndIf

WEnd
