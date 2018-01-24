#cs ----------------------------------------------------------------------------
	imgviewer.au3 plugin for ISN AUTOIT STUDIO
	v.0.5
#ce ----------------------------------------------------------------------------

;Autoit Wrapper
#AutoIt3Wrapper_Res_Fileversion=0.52
#AutoIt3Wrapper_Res_ProductVersion=0.52
#AutoIt3Wrapper_Res_LegalCopyright=ISI360
#AutoIt3Wrapper_Res_Description=Simple File Viewer Plugin
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=ProductName|Simple File Viewer
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_HiDpi=Y


#NoTrayIcon
Opt("GUICloseOnESC", 0) ;1=ESC  closes, 0=ESC won't close
Opt("GUIResizeMode", 802) ;0=no resizing, <1024 special resizing

If $CmdLine[0] = 0 Then Exit
Global $imagefile = $CmdLine[1]
Global $filetype = StringTrimLeft($imagefile, StringInStr($imagefile, "."))

#include <GuiStatusBar.au3>
#include <Includes\isnautoitstudio_plugin.au3>
#include <File.au3>
#include <includes\USkin.au3>
#include <WindowsConstants.au3>
#include <Includes\GUIScrollbars_Ex.au3>
#include "GUI.isf"

_ISNPlugin_initialize($hGUI)
If @error Or $CmdLine[0] = 0 Then
	MsgBox(16, "Error", "This program is part of the ISN AutoIt Studio and cannot be started separately!")
	Exit ;ISN spricht nicht mit mir...ich werde nicht gebraucht :(
EndIf


Global $Current_ISN_Skin = IniRead($ISN_AutoIt_Studio_Config_Path, "config", "skin", "#none#")
Global $hImage, $hGraphic, $hImage1
Global $videoPath, $oIE, $o_Plyr, $s_PlayerObjId, $msg, $gui, $width, $height, $oCtrl, $pos, $w, $h
Global $ISN_Hintergrundfarbe = 0xFFFFFF
Global $ISN_Schriftfarbe = 0x000000

;Skin auch im Plugin Anwenden
_Uskin_LoadDLL($ISN_AutoIt_Studio_EXE_Path & "\Data\USkin.dll")
If $Current_ISN_Skin <> "#none#" Then
	If Not FileExists(_PathFull($ISN_AutoIt_Studio_EXE_Path & "\Data\Skins\" & $Current_ISN_Skin)) Then $Current_ISN_Skin = "#none#"
	$pfad = _PathFull($ISN_AutoIt_Studio_EXE_Path & "\Data\Skins\" & $Current_ISN_Skin & "\skin.msstyles")
	If $Current_ISN_Skin <> "#none#" Then
		_USkin_Init($pfad) ;skin zuweisen
	EndIf
EndIf

#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <StructureConstants.au3>
#include <Includes\addons.au3>
#include <IE.au3>
#include <StaticConstants.au3>

$ISN_Hintergrundfarbe = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Fenster_Hintergrundfarbe")
$ISN_Schriftfarbe = _ISNPlugin_Get_Variable_from_ISN_AutoIt_Studio("$Schriftfarbe")
GUICtrlSetColor($statusbar,$ISN_Schriftfarbe)

If $filetype = "dll" Then
	GUICtrlSetState($tabpage_dll, $GUI_SHOW)
	GUICtrlSetBkColor($Fotos_Thubnails, $ISN_Hintergrundfarbe)
	GUICtrlSetColor($Fotos_Thubnails, $ISN_Schriftfarbe)
	_GUICtrlListView_AddColumn($Fotos_Thubnails, "ico", 200)
	_GUICtrlListView_SetView($Fotos_Thubnails, 0)
	Global $FotoshImageList = _GUIImageList_Create(32, 32, 5, 3)
	;Clear list
	_GUIImageList_Remove($FotoshImageList, -1)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Fotos_Thubnails))
	_GUICtrlListView_BeginUpdate($Fotos_Thubnails)
	$PicID = 1
	$Limiter = 5 ;Bei 5 leeren icons, abbruch!
	$iconcounter = 1
	_GUIImageList_AddIcon($FotoshImageList, $imagefile, 0, True)
	_GUICtrlListView_SetImageList($Fotos_Thubnails, $FotoshImageList, 0)
	_GUICtrlListView_AddItem($Fotos_Thubnails, "0", 0)
	For $iCntRow = 0 To 9999999
		$res = _GUIImageList_AddIcon($FotoshImageList, $imagefile, $PicID, True)
		If $res = 0 Or $res = -1 Then
			$Limiter = $Limiter - 1
			If $Limiter < 1 Then ExitLoop
		EndIf
		If Not $res = 0 Then
			_GUICtrlListView_SetImageList($Fotos_Thubnails, $FotoshImageList, 0)
			_GUICtrlListView_AddItem($Fotos_Thubnails, $PicID, $PicID)
			$iconcounter = $iconcounter + 1
			GUICtrlSetData($statusbar, _ISNPlugin_Get_langstring(2) & " " & "(" & $iconcounter & ")...")
		EndIf
		$PicID = $PicID + 1
	Next
	_GUICtrlListView_SetIconSpacing($Fotos_Thubnails, 70, 0)
	_GUICtrlListView_EndUpdate($Fotos_Thubnails)
	GUICtrlSetData($statusbar, $iconcounter & " " & _ISNPlugin_Get_langstring(1))
EndIf


If $filetype = "ico" Or $filetype = "bmp" Or $filetype = "jpg" Or $filetype = "jpeg" Then
	GUICtrlSetState($tabpage_image, $GUI_SHOW)
	If $filetype = "ico" Then
		GUICtrlCreateIcon($imagefile, -1, 2, 2)
	Else
		GUICtrlCreatePic($imagefile, 2, 2, 0, 0)
	EndIf
EndIf


If $filetype = "mp3" Or $filetype = "wav" Or $filetype = "wave" Or $filetype = "ogg" Or $filetype = "avi" Or $filetype = "divx" Or $filetype = "mpeg" Or $filetype = "mpg" Or $filetype = "wmv" Then
	GUICtrlSetData($statusbar, FileGetLongName($imagefile))
	GUICtrlSetState($tabpage_audio, $GUI_SHOW)
	$pos = WinGetClientSize($hGUI)
	Local $blank, $oDoc, $oBody, $oBodyStyle, $IEReadyState, $o_Plyr
	Global $oIE = _IECreateEmbedded()
	Global $oCtrl = GUICtrlCreateObj($oIE, 0, 19, $pos[0], $pos[1])
	_IENavigate($oIE, "about:blank", 1)
	_IELoadWait($oIE, 180, 4000)
	Do
		Sleep(50)
		$oDoc = $oIE.document
	Until IsObj($oDoc)
	Sleep(25)
	$oBody = $oDoc.body
	$oBody.scroll = "no"
	$oBodyStyle = $oBody.style
	;   $oBodyStyle.overflow = "hidden"
	$oBodyStyle.margin = "0px"
	$oBodyStyle.border = "0px"
	$oBodyStyle.padding = "0px"
	$oBodyStyle.background = "#000000"
	Global $o_Plyr = $oDoc.createElement("OBJECT")
	With $o_Plyr
		.id = $s_PlayerObjId
		.style.margin = "0px"
		.style.border = "0px"
		.style.padding = "0px"
		.style.width = $pos[0]
		.style.height = $pos[1] - 19
		.classid = "clsid:6BF52A52-394A-11D3-B153-00C04F79FAA6"
		.uiMode = "full" ; invisible, none, mini, full
		.StretchToFit = "true"
		.enabled = "true"
		.enableContextMenu = "False"
		.url = $imagefile
	EndWith
	$oBody.appendChild($o_Plyr)

EndIf



GUISetState(@SW_SHOW, $hGUI)
_ReduceMemory(@AutoItPID)

_ISNPlugin_Register_ISN_Event($ISN_AutoIt_Studio_Event_Resize, "_Resize")
_ISNPlugin_Register_ISN_Event($ISN_AutoIt_Studio_Event_Exit_Plugin, "_exit")



Func _Resize()
	$pos = WinGetClientSize($hGUI)
	GUICtrlSetPos($Fotos_Thubnails, 0, 20, $pos[0], $pos[1] - 20)
	If IsObj($o_Plyr) Then
		GUICtrlSetPos($oCtrl, 0, 20, $pos[0], $pos[1] - 20)
		GUICtrlSetPos($oIE, 0, 20, $pos[0], $pos[1] - 20)
		$o_Plyr.style.width = $pos[0]
		$o_Plyr.style.height = $pos[1] - 19
	EndIf
EndFunc   ;==>_Resize

Func _exit()
	If $filetype = "mp3" Or $filetype = "wav" Or $filetype = "wave" Or $filetype = "ogg" Or $filetype = "avi" Or $filetype = "divx" Or $filetype = "mpeg" Or $filetype = "mpg" Or $filetype = "wmv" Then
;~ $o_Plyr.controls.stop()
;~ $oCtrl.close()
;~ _IEQuit ($oIE)
;~ ProcessClose(@autoitpid)

	EndIf
	_USkin_Exit()
	Exit
EndFunc   ;==>_exit


While 1

	$msg = GUIGetMsg()
	Switch $msg

		Case $item1
			_Extract_icon()

		Case $GUI_EVENT_CLOSE
			_exit()
	EndSwitch
WEnd

Exit
