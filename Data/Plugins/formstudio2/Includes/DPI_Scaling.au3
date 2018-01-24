;DPI_Scaling.au3

;DPI Func
Func _GetDPI()
	Local $hDC = _WinAPI_GetDC(0)
	Local $DPI = _WinAPI_GetDeviceCaps($hDC, 90) ;$LOGPIXELSY
	_WinAPI_ReleaseDC(0, $hDC)

	Select
		Case $DPI = 0
			$DPI = 1
		Case $DPI < 84
			$DPI /= 105
		Case $DPI < 121
			$DPI /= 96
		Case $DPI < 145
			$DPI /= 95
		Case Else
			$DPI /= 94
	EndSelect

	Return Round($DPI, 2)
EndFunc   ;==>_GetDPI

; #FUNCTION# ====================================================================================================================
; Name ..........: _Fenster_Resizen_und_zentrieren
; Description ...:
; Syntax ........: _Fenster_Resizen_und_zentrieren($win, $txt [, $width=Default [, $height=Default]])
; Parameters ....: $win                 - An unknown value.
;                  $txt                 - A dll struct value.
;                  $width               - [optional] An AutoIt controlID. Default is Default.
;                  $height              - [optional] A handle value. Default is Default.
; Return values .: None
; Author ........: Christian Faderl
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Fenster_Resizen_und_zentrieren($win, $txt, $width = Default, $height = Default)
	Local $size = WinGetClientSize($win, $txt)
	If Not ($width = Default) Then $size[0] = $width
	If Not ($height = Default) Then $size[1] = $height
	Local $x = (@DesktopWidth / 2) - ($size[0] / 2)
	Local $y = (@DesktopHeight / 2) - ($size[1] / 2)
	If $x < 0 Then $x = 0
	If $y < 0 Then $y = 0
	Return WinMove($win, $txt, $x, $y, $size[0], $size[1]) ; second winmove
EndFunc   ;==>_Fenster_Resizen_und_zentrieren


Func _Control_set_DPI_Scaling($handle = "",$no_resize=false)
	If $handle = "" Then Return
    if $DPI == 1 then return ;Bei 100% gibt´s nichts zu tun
	If IsHWnd($handle) Then

		$fenster_positionen = WinGetpos($handle)
		$fenster_ClientSize = WinGetClientSize($handle)

		If IsArray($fenster_positionen) AND IsArray($fenster_ClientSize) Then

		$Client_size_dif_Width = $fenster_positionen[2]-$fenster_ClientSize[0]
		$Client_size_dif_height = $fenster_positionen[3]-$fenster_ClientSize[1]

		_Fenster_Resizen_und_zentrieren($handle, "", ($fenster_ClientSize[0] * $DPI)+$Client_size_dif_Width, ($fenster_ClientSize[1] * $DPI)+$Client_size_dif_height)

		EndIf
	 Else
		$handle = GUICtrlGetHandle($handle)
		$control_positionen = ControlGetPos($handle, "", $handle)
		If IsArray($control_positionen) Then
		    if $no_resize Then
			   GUICtrlSetPos(_WinAPI_GetDlgCtrlID($handle), $control_positionen[0] * $DPI, $control_positionen[1] * $DPI)
			Else
			   GUICtrlSetPos(_WinAPI_GetDlgCtrlID($handle), $control_positionen[0] * $DPI, $control_positionen[1] * $DPI, $control_positionen[2] * $DPI, $control_positionen[3] * $DPI)
			EndIf

		EndIf

	EndIf
EndFunc   ;==>_Control_set_DPI_Scaling

Func _Fenster_Hintergrundgrafiken_einfuegen_UpdateGUI($handle = "")
	If $handle = "" Then Return
	$fenster_positionen = WinGetClientSize($handle)
	If IsArray($fenster_positionen) Then
		guictrlcreatepic(@scriptdir&"\Data\Images\update.jpg",0,0,$fenster_positionen[0],$fenster_positionen[1],-1,$GUI_WS_EX_PARENTDRAG)
		GUICtrlSetState(-1,$GUI_DISABLE)
	EndIf
EndFunc