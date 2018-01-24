#include-once

Local $__CB__filesstr="{\rtf1\utf8" & @CRLF & "{\colortbl;" & @CRLF & "}" & @CRLF & @CRLF & "}"
;Local $__CB__filesstr="{\rtf1\utf8"&@CRLF&"{\colortbl;"&@CRLF&"\red0\green0\blue0;"&@CRLF&@CRLF&"}"&@CRLF&@CRLF&"}"




Func _ChatBoxCreate($gui,$txt="",$x=0,$y=0,$w=100,$h=100,$bgc="0xFFFFFF",$readonly=True,$autodetecturl=True)
	Local $ret;RichEdit
	$ret=_GUICtrlRichEdit_Create($gui,"",$x,$y,$w,$h,BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	_GUICtrlRichEdit_AutoDetectURL($ret,$autodetecturl)
	_GUICtrlRichEdit_SetLimitOnText($ret,-1)
	_GUICtrlRichEdit_SetBkColor($ret,$bgc)
	_GUICtrlRichEdit_SetReadOnly($ret,$readonly)
	If $txt<>"" Then _ChatBoxAdd($ret,$txt)
	Return $ret
EndFunc

Func _ChatBoxClear(ByRef $box)
	If Not IsHWnd($box) Then Return SetError(101, 0, False)
	_GUICtrlRichEdit_SetText($box,"")
EndFunc

Func _ChatBoxDestroy(ByRef $box)
	If Not IsHWnd($box) Then Return SetError(101, 0, False)
	_GUICtrlRichEdit_Destroy($box)
EndFunc

Func _ChatBoxAdd(ByRef $box,$txt)
	If Not IsHWnd($box) Then Return SetError(101, 0, False)
	If $txt="" Then Return 0
	$txt=__ChatBoxConvert($txt)
	_GUICtrlRichEdit_AppendTextUTF8($box,$txt)
EndFunc

Func __ChatBoxConvert($txt)
;~     $txt=StringReplace($txt,"{","\{")
;~     $txt=StringReplace($txt,"}","\}")
	$txt = StringReplace($txt, @CRLF, "\line ")
    $txt=StringRegExpReplace($txt,"(?i)\[b\](.*?)\[/b\]","{\\b $1}")
    $txt=StringRegExpReplace($txt,"(?i)\[i\](.*?)\[/i\]","{\\i $1}")
    $txt=StringRegExpReplace($txt,"(?i)\[u\](.*?)\[/u\]","{\\ul $1}")
    $txt=StringRegExpReplace($txt,"(?i)\[s\](.*?)\[/s\]","{\\strike $1}")
    $txt=StringRegExpReplace($txt,"(?i)\[size=(\d+?)\](.*?)\[/size\]","{\\fs$1 $2}")
    Local $aColor = StringRegExp($txt, "(?i)\[c=#([0-9A-Fa-f]{6})\].*?\[/c\]", 3)
    Local $sColor, $iColors

    If Not @error Then
        For $i = 0 To UBound($aColor) - 1
            $sColor &= "\red" & Dec(StringMid($aColor[$i], 1, 2)) & "\green" & Dec(StringMid($aColor[$i], 3, 2)) & "\blue" & Dec(StringMid($aColor[$i], 5, 2)) & ";" & @CRLF
            $iColors += 1
            $txt = StringRegExpReplace($txt, "\[c=#" & $aColor[$i] & "\](.*?)\[/c\]", "\\cf" & $iColors & " $1\\cf0 ")
        Next
    EndIf

    Local $sRTFString = StringMid($__CB__filesstr, 1, StringInStr($__CB__filesstr, "l;" & @CRLF) + 2) & _
            $sColor & _
            StringTrimRight(StringMid($__CB__filesstr, StringInStr($__CB__filesstr, "l;" & @CRLF, 1, 1) + 4), 4) & _
            $txt & _
            "}"

    Return $sRTFString

EndFunc

; ProgAndy ; Edited
Func _GUICtrlRichEdit_AppendTextUTF8($hWnd, $sText)
    If Not IsHWnd($hWnd) Then Return SetError(101, 0, False)
;~     _GUICtrlRichEdit_SetSel($hWnd, -1, -1,true) ; go to end of text

    Local $tSetText = DllStructCreate($tagSETTEXTEX)
    DllStructSetData($tSetText, 1, $ST_SELECTION)
    DllStructSetData($tSetText, 2, 65001)

	Local $iLength = _GUICtrlEdit_GetTextLen($hWnd)
	_GUICtrlEdit_SetSel($hWnd, $iLength, $iLength)


  Local $iRet = _SendMessage($hWnd, $EM_SETTEXTEX, DllStructGetPtr($tSetText), BinaryToString(StringToBinary($sText, 4), 1), 0, "ptr", "STR")
_GUICtrlRichEdit_ScrollLines($hWnd, _GUICtrlRichEdit_GetLineCount($hWnd))


    If Not $iRet Then Return SetError(700, 0, False)
    Return True
EndFunc   ;==>_GUICtrlRichEdit_AppendText


