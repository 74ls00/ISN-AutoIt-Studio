
func _Toggle_Bitoperation_rechner()
   if $Offenes_Projekt = "" then return
   if $Tools_Bitrechner_aktiviert <> "true" then return
	$state = WinGetState($bitwise_operations_GUI, "")
	If BitAnd($state, 2) Then
		GUISetState(@SW_HIDE,$bitwise_operations_GUI)
	else
		GUISetState(@SW_SHOW,$bitwise_operations_GUI)
	EndIf
EndFunc


Func _BitWisor()
    Local $sRez = "", $sError = "", $sInput = GUICtrlRead($cInput), $aInput, $sOp, $sCalc, $i=0, $aTmp, $sTmp
    $aInput = StringRegExp($sInput, '\A[[:blank:]]*([[:alpha:]]+)[[:blank:]]*\((.+)\)', 1)
    If @error Then
        $sError = _Get_langstr(815)
    Else
        $sInput = $aInput[0] & '(' & $aInput[1] & ')'
        GUICtrlSetData($cInput, $sInput)
        $sOp = StringUpper(StringTrimLeft($aInput[0], 3))
        $sRez = Execute($sInput)
        If @error Then
            $sError = _Get_langstr(815)
        Else
            Switch $aInput[0]
                Case "bitand", "bitor", "bitxor"
                    $aTmp = _SplitParams($aInput[1])
                    For $i = 1 To $aTmp[0]
                        $sTmp &= _HexToBinBase(Execute($aTmp[$i])) & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '   0x' & Hex(Execute($aTmp[$i])) & @CRLF & Chr(1) & @CRLF
                        $sCalc = StringReplace(StringTrimRight($sTmp, 3), Chr(1), $sOp) & _
                                "=" & @CRLF & _
                                _HexToBinBase($sRez) & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '   0x' & Hex($sRez) & @CRLF
                    Next
                Case "bitnot"
                    $sCalc = _HexToBinBase(Execute($aInput[1])) & '   0x' & Hex(Execute($aInput[1])) & @CRLF & _
                            $sOp & @CRLF & _
                            "=" & @CRLF & _
                            _HexToBinBase($sRez) & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '   0x' & Hex($sRez) & @CRLF
                Case "bitshift"
                    $aTmp = _SplitParams($aInput[1])
                    If Execute($aTmp[2]) > 0 Then
                        $sTmp = $sOp & " right by " & Execute($aTmp[2])
                    ElseIf Execute($aTmp[2]) < 0 Then
                        $sTmp = $sOp & " left by " & Abs(Execute($aTmp[2]))
                    Else
                        $sTmp = $sOp & " by 0"
                    EndIf
                    $sCalc = _HexToBinBase(Execute($aTmp[1])) & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '   0x' & Hex(Execute($aTmp[1])) & @CRLF & _
                            $sTmp & @CRLF & _
                            "=" & @CRLF & _
                            _HexToBinBase($sRez) & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '   0x' & Hex($sRez) & @CRLF
                Case "bitrotate"
                    $aTmp = _SplitParams($aInput[1])
                    If UBound($aTmp) = 2 Then
                        ReDim $aTmp[3]
                        $aTmp[2] = 1
                    EndIf
                    If Execute($aTmp[2]) > 0 Then
                        $sTmp = $sOp & " left by " & Execute($aTmp[2])
                    ElseIf Execute($aTmp[2]) < 0 Then
                        $sTmp = $sOp & " right by " & Abs(Execute($aTmp[2]))
                    Else
                        $sTmp = $sOp & " by 0"
                    EndIf
                    If $aTmp[0] < 3 Then $sSize = ' ("W" within 16 bits Default)' ; Default
                    If $aTmp[0] = 3 Then
                        If $aTmp[3] = '"D"' Then $sSize = ' ("D" within 32 bits)'
                        If $aTmp[3] = '"W"' Then $sSize = ' ("W" within 16 bits)'
                        If $aTmp[3] = '"B"' Then $sSize = ' ("B" within 8 bits)'
                    EndIf
                    $sCalc = _HexToBinBase(Execute($aTmp[1])) & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '   0x' & Hex(Execute($aTmp[1])) & @CRLF & _
                            $sTmp & $sSize & @CRLF & _
                            "=" & @CRLF & _
                            _HexToBinBase($sRez) & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '   0x' & Hex($sRez) & @CRLF
                Case Else
                    $sError = _Get_langstr(815)
            EndSwitch
        EndIf
    EndIf
    GUICtrlSetData($cResult, $sRez)
    If $sError <> "" Then
        GUICtrlSetData($cCalc, $sError)
    Else
        GUICtrlSetData($cCalc, $sCalc)
    EndIf
EndFunc
#cs _HexToBinBase()
    Converts a number to binary base string
#ce
Func _HexToBinBase($hex)
    Local $b = ""
    For $i = 1 To 32
        $b = BitAND($hex, 1) & $b
        $hex = BitShift($hex, 1)
    Next
    Return $b
EndFunc
#cs _SplitParams()
    Crappy AutoIt param string parser
    Should choke on quoted commas
    Returns StringSplit-like array
#ce
Func _SplitParams($sParams)
    Local $aParams, $i, $br1, $br2, $aRet[1]
    $aParams = StringSplit($sParams, ",")
    For $i = $aParams[0] To 1 Step -1
        StringReplace($aParams[$i], ")", "")
        $br1 = @extended
        StringReplace($aParams[$i], "(", "")
        $br2 = @extended
        If $br1 <> $br2 Then
            $aParams[$i-1] &= "," & $aParams[$i]
            $aParams[$i] = ""
        EndIf
    Next
    For $i = 1 To $aParams[0]
        If $aParams[$i] <> "" Then
            Redim $aRet[UBound($aRet)+1]
            $aRet[UBound($aRet)-1] = $aParams[$i]
        EndIf
    Next
    $aRet[0] = UBound($aRet)-1
    Return $aRet
EndFunc
#cs _GraphicDrawLines()
    Draws lines, duh
    Params: $cID - control ID from GuiCtrlCreateGraphic
            $aCoords - 1D array containing coordinate pairs ( $a[0]=x0, $a[1]=y0, $a[2]=x1, $a[3]=y1, etc.)
            $iPenSize, $iColor, $iColorBk - line options
#ce
Func _GraphicDrawLines($cID, $aCoords, $iPenSize = 2, $iColor = 0, $iColorBk = -1)
    GUICtrlSetGraphic($cID, $GUI_GR_PENSIZE, $iPenSize)
    GUICtrlSetGraphic($cID, $GUI_GR_COLOR, $iColor, $iColorBk)
    GUICtrlSetGraphic($cID, $GUI_GR_MOVE, $aCoords[0], $aCoords[1])
    For $i = 2 To UBound($aCoords)-1 Step 2
        GUICtrlSetGraphic($cID, $GUI_GR_LINE, $aCoords[$i], $aCoords[$i+1])
    Next
EndFunc