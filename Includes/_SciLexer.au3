#include-once






Func Sci_CreateEditor($Hwnd, $X,$Y,$W,$H) ; The return value is the hwnd of the window, and can be used for Win.. functions
	$Sci = CreateEditor($Hwnd,$X,$Y,$W,$H)
	If @error Then
		Return 0
	EndIf
	;InitEditor($Sci)
	If @error Then
		Return 0
	Else
		Return $Sci
	EndIf
EndFunc


; |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

Func Sci_DelLines($Sci)
	SendMessage($Sci, $SCI_CLEARALL, 0, 0)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc


Func Sci_AddLines($Sci, $Text,$Line)
	$Oldpos = Sci_GetCurrentLine($Sci)
	If @error Then
		Return 0
	EndIf
	Sci_SetCurrentLine($Sci, $Line)
	If @error Then
		Return 0
	 EndIf

	if $Languagefile = "china.lng" Then
	$LineLenght = StringSplit(StringRegExpReplace($Text, '[^\x00-\xff]', '00'),"") ;for china only
	Else
	$LineLenght = StringSplit($Text,"")
	endif

	If @error Then
		Return 0
	 EndIf
	DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_ADDTEXT, "int", $LineLenght[0], "str", $Text)
	If @error Then
		Return 0
	EndIf
	Sci_SetCurrentLine($Sci, $Oldpos)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func Sci_GetText($Sci)
	Local $ret, $sText
	$iLen = SendMessage($Sci, $SCI_GETTEXT, 0, 0)
	If @error Then
		Return 0
	EndIf
	$sBuf = DllStructCreate("byte[" & $iLen & "]")
	If @error Then
		Return 0
	EndIf
	$ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_GETTEXT, "int", $iLen, "ptr", DllStructGetPtr($sBuf))
	If @error Then
		Return 0
	EndIf
	$sText = BinaryToString(DllStructGetData($sBuf, 1))
	$sBuf = 0
	If @error Then
		Return 0
	Else
		Return $sText
	EndIf
EndFunc

Func Sci_GetLine($Sci, $Line)

	Local $ret, $sText
	$iLen = SendMessage($Sci, $SCI_GETLINE, $Line, 0)
	If @error Then
		Return 0
	EndIf
	$sBuf = DllStructCreate("byte[" & $iLen & "]")
	;If @error Then
	;	Return 0
	;EndIf
	$ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_GETLINE, "int", $Line, "ptr", DllStructGetPtr($sBuf))
	If @error Then
		Return 0
	EndIf
	$sText = BinaryToString(DllStructGetData($sBuf, 1))
	$sBuf = 0
	If @error Then
		Return 0
	Else
		Return $sText
	EndIf

EndFunc

Func Sci_GetLines($Sci)
	Local $ret, $sText
	$iLen = SendMessage($Sci, $SCI_GETTEXT, 0, 0)
	If @error Then
		Return 0
	EndIf
	$sBuf = DllStructCreate("byte[" & $iLen & "]")
	If @error Then
		Return 0
	EndIf
	$ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_GETTEXT, "int", $iLen, "ptr", DllStructGetPtr($sBuf))
	If @error Then
		Return 0
	EndIf
	$sText = BinaryToString(DllStructGetData($sBuf, 1))
	$sBuf = 0
	If @error Then
		Return 0
	Else
		If StringRight($sText, 1) = Chr(0) Then $sText = StringTrimRight($sText, 1) ;Added by Michael Michta
		Return $sText
	EndIf
EndFunc

Func Sci_InsertText($Sci, $Pos, $Text)
	Return SendMessageString($Sci, $SCI_INSERTTEXT, $Pos, $Text)
EndFunc

Func Sci_GetLenght($Sci)
	Return SendMessage($Sci, $SCI_GETLENGTH, 0, 0)
EndFunc

Func Sci_SetZoom($Sci, $Zoom)
	SendMessage($Sci, $SCI_SETZOOM, $Zoom-1, 0)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func Sci_GetZoom($Sci)
	$Zoom = SendMessage($Sci, $SCI_GETZOOM, 0, 0)
	Return $Zoom+1
EndFunc


Func Sci_GetCurrentPos($Sci)
	$Pos = SendMessage($Sci, $SCI_GETCURRENTPOS, 0, 0)
	Return $Pos
EndFunc

Func Sci_SetCurrentPos($Sci, $Char)
	SendMessage($Sci, $SCI_GOTOPOS, $Char, 0)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func Sci_GetLineFromPos($Sci, $Pos)

	Return SendMessage($Sci, $SCI_LINEFROMPOSITION, $Pos, 0)

EndFunc

Func Sci_GetLineStartPos($Sci, $Line)

	Return SendMessage($Sci, $SCI_POSITIONFROMLINE, $Line, 0)

EndFunc

Func Sci_VisibleFirst($Sci)

	Return SendMessage($Sci, $SCI_GETFIRSTVISIBLELINE, 0, 0)

EndFunc

Func Sci_VisibleLines($Sci)

	Return SendMessage($Sci, $SCI_LINESONSCREEN, 0, 0)

EndFunc

Func Sci_SelectAll($Sci)

	Return SendMessage($Sci, $SCI_SELECTALL, 0, 0)

EndFunc

Func Sci_GetLineEndPos($Sci, $Line)

	Return SendMessage($Sci, $SCI_GETLINEENDPOSITION, $Line, 0)

EndFunc

Func Sci_GetLineLenght($Sci, $Line)

	Return SendMessage($Sci, $SCI_LINELENGTH, $Line, 0)

EndFunc

Func Sci_GetLineCount($Sci)

	Return SendMessage($Sci, $SCI_GETLINECOUNT, 0, 0)

EndFunc

Func Sci_SetCurrentLine($Sci, $Line)
	SendMessage($Sci, $SCI_GOTOLINE, $Line-1, 0)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func Sci_GetCurrentLine($Sci)
	$Pos = SendMessage($Sci, $SCI_GETCURRENTPOS, 0, 0)
	$Line = SendMessage($Sci, $SCI_LINEFROMPOSITION, $Pos, 0)
	Return $Line+1
EndFunc

Func Sci_GetChar($Sci, $Pos)
	Return ChrW(SendMessage($Sci, $SCI_GETCHARAT, $Pos, 0))
EndFunc

Func Sci_SetSelection($Sci, $BeginChar, $EndChar)
	$Pos = SendMessage($Sci, $SCI_SETSEL, $BeginChar, $EndChar)
	Return $Pos
EndFunc

Func Sci_GetSelection($Sci)
	Local $Return[2]
	$Return[0] = SendMessage($Sci, $SCI_GETSELECTIONSTART, 0, 0)
	$Return[1] = SendMessage($Sci, $SCI_GETSELECTIONEND, 0, 0)
	Return $Return
EndFunc

Func Sci_SetSelectionColor($Sci, $Color, $State=True)

	Return SendMessage($Sci, $SCI_SETSELFORE, $State, $Color)

EndFunc

Func Sci_SetSelectionBkColor($Sci, $Color, $State=True)

	Return SendMessage($Sci, $SCI_SETSELBACK, $State, $Color)

EndFunc

Func Sci_SetSelectionAlpha($Sci, $Trans)

	Return SendMessage($Sci, $SCI_SETSELALPHA, $Trans, 0)

EndFunc

Func Sci_Search($Sci, $sSearch, $iStartPos=0, $iEndPos=0)

	If Not $iEndPos Then $iEndPos = Sci_GetLenght($Sci)

	SendMessage($Sci, $SCI_SETTARGETSTART, $iStartPos, 0)
	SendMessage($Sci, $SCI_SETTARGETEND, $iEndPos, 0)

	Return SendMessageString($Sci, $SCI_SEARCHINTARGET, StringLen($sSearch), $sSearch)
EndFunc

Func Sci_Cut($Sci)

	Return SendMessage($Sci, $SCI_CUT, 0, 0)

EndFunc

Func Sci_Copy($Sci)

	Return SendMessage($Sci, $SCI_COPY, 0, 0)

EndFunc

Func Sci_Paste($Sci)

	Return SendMessage($Sci, $SCI_PASTE, 0, 0)

EndFunc

Func Sci_Undo($Sci)

	Return SendMessage($Sci, $SCI_UNDO, 0, 0)

EndFunc

Func Sci_Redo($Sci)

	Return SendMessage($Sci, $SCI_REDO, 0, 0)

EndFunc

Func Sci_BeginUndoAction($Sci)

	Return SendMessage($Sci, $SCI_BEGINUNDOACTION, 0, 0)

EndFunc

Func Sci_EndUndoAction($Sci)

	Return SendMessage($Sci, $SCI_ENDUNDOACTION, 0, 0)

EndFunc

Func Sci_EmptyUndoBuffer($Sci)

	Return SendMessage($Sci, $SCI_EMPTYUNDOBUFFER, 0, 0)

EndFunc

Func Sci_GetCurrentWord($Sci)
	Local $Return

	$CurrentPos = Sci_GetCurrentPos($Sci)
	$Line = Sci_GetLineFromPos($Sci, $CurrentPos)
	$Text = Sci_GetLine($Sci, $Line)
	$Return = Sci_GetChar($Sci, $CurrentPos)

	if $Return and $Return <> " " and $Return <> @TAB and $Return <> @LF And $Return <> @CR Then

		$i = 1
		While 1

			$Get = Sci_GetChar($Sci, $CurrentPos-$i)
			$Char = $Get


			If $Get And $Char <> " " and $Char <> @TAB and $Char <> @LF And $Char <> @CR Then
				$Return = $Char & $Return
			Else
				ExitLoop
			EndIf

			$i += 1

		WEnd

		$i = 1

		While 1

			$Get = Sci_GetChar($Sci, $CurrentPos+$i)
			$Char = $Get

			If $Get And $Char <> " " and $Char <> @TAB and $Char <> @LF And $Char <> @CR Then
				$Return &= $Char
			Else
				ExitLoop
			EndIf

			$i += 1

		WEnd

		Return $Return

	Else
		Return ""
	EndIf

EndFunc

Func Sci_StyleApply($Sci, $iStyle, $iStartPos, $iLenght)
	SendMessage($Sci, $SCI_STARTSTYLING, $iStartPos, 0x1f)
	Return SendMessage($Sci, $SCI_SETSTYLING, $iLenght, $iStyle)
EndFunc

Func Sci_StyleSet($Sci, $iStyle, $iColor=-1, $iBkColor=-1, $iBold=-1, $iItalic=-1, $iUnderline=-1, $sFont=-1, $iFontSize=-1, $iHotspot=-1)

	If $iColor <> -1 Then SendMessage($Sci, $SCI_STYLESETFORE, $iStyle, $iColor)
	If $iBkColor <> -1 Then SendMessage($Sci, $SCI_STYLESETBACK, $iStyle, $iBkColor)
	If $iBold <> -1 Then SendMessage($Sci, $SCI_STYLESETBOLD, $iStyle, $iBold)
	If $iItalic <> -1 Then SendMessage($Sci, $SCI_STYLESETITALIC, $iStyle, $iItalic)
	If $iUnderline <> -1 Then SendMessage($Sci, $SCI_STYLESETUNDERLINE, $iStyle, $iUnderline)
	If $sFont <> -1 Then SendMessageString($Sci, $SCI_STYLESETFONT, $iStyle, $sFont)
	If $iFontSize <> -1 Then SendMessage($Sci,$SCI_STYLESETSIZE, $iStyle, $iFontSize)
	If $iHotspot <> -1 Then SendMessage($Sci,$SCI_STYLESETHOTSPOT, $iStyle, $iHotspot)

	Return 1

EndFunc

Func Sci_StyleClearAll($Sci)
	Return SendMessage($Sci, $SCI_STYLECLEARALL, 0, 0)
EndFunc

Func Sci_GetStyleAt($Sci, $iPos)
	Return SendMessage($Sci, $SCI_GETSTYLEAT, $iPos, 0)
EndFunc

Func Sci_SetLexer($Sci, $iLexer)
	Return SendMessage($Sci, $SCI_SETLEXER, $iLexer, 0)
EndFunc

Func Sci_GetLexer($Sci)
	Return SendMessage($Sci, $SCI_GETLEXER, 0, 0)
EndFunc

Func Sci_CalltipShow($Sci, $iPos, $sText)

	Return SendMessageString($Sci, $SCI_CALLTIPSHOW, $iPos, $sText)

EndFunc

Func Sci_CalltipActive($Sci)
	Return SendMessage($Sci, $SCI_CALLTIPACTIVE, 0, 0)
EndFunc

Func Sci_CalltipCancel($Sci)
	Return SendMessage($Sci, $SCI_CALLTIPCANCEL, 0, 0)
EndFunc

Func Sci_CalltipHighlight($Sci, $iStartPos, $iEndPos)
	Return SendMessage($Sci, $SCI_CALLTIPSETHLT, $iStartPos, $iEndPos)
EndFunc

Func Sci_CalltipPos($Sci)
	Return SendMessage($Sci, $SCI_CALLTIPPOSSTART, 0, 0)
EndFunc

Func Sci_AutoCompleteActive($Sci)
	Return SendMessage($Sci, $SCI_AUTOCACTIVE, 0,0)
EndFunc

Func Sci_AutoCompleteCancel($Sci)
	Return SendMessage($Sci, $SCI_AUTOCCANCEL, 0,0)
EndFunc

Func Sci_AutoCompleteShow($Sci, $iLen, $sWords)
	SendMessageString($Sci, $SCI_AUTOCSHOW, $iLen, $sWords)
EndFunc

Func Sci_LineWrapSetMode($Sci, $iMode)
	Return SendMessage($Sci, $SCI_SETWRAPMODE, $iMode,0)
EndFunc

Func Sci_LineWrapSetIndent($Sci, $iMode)
	Return SendMessage($Sci, $SCI_SETWRAPVISUALFLAGS, $iMode,0)
EndFunc

Func Sci_LineWrapSetIndentLocation($Sci, $iLocation)
	Return SendMessage($Sci, $SCI_SETWRAPVISUALFLAGSLOCATION, $iLocation,0)
EndFunc

Func Sci_SetSavePoint($Sci)
	Return SendMessage($Sci, $SCI_SETSAVEPOINT, 0,0)
EndFunc

Func Sci_GetModify($Sci)
	Return SendMessage($Sci, $SCI_GETMODIFY, 0,0)
EndFunc

Func Sci_SetAnchor($Sci, $iPos)
	Return SendMessage($Sci, $SCI_SETANCHOR, $iPos,0)
EndFunc

Func Sci_SetCurrentPosEx($Sci, $iPos)
	Return SendMessage($Sci, $SCI_SETCURRENTPOS, $iPos,0)
EndFunc

Func Sci_ReplaceSel($Sci, $sText)
	SendMessageString($Sci, $SCI_REPLACESEL, 0, $sText)
EndFunc

Func Sci_CallTipSetHltColor($Sci, $iColor)
	Return SendMessage($Sci, $SCI_CALLTIPSETFOREHLT, $iColor,0)
EndFunc

Func Sci_CallTipSetColor($Sci, $iColor)
	Return SendMessage($Sci, $SCI_CALLTIPSETFORE, $iColor,0)
EndFunc

Func Sci_CallTipSetBkColor($Sci, $iColor)
	Return SendMessage($Sci, $SCI_CALLTIPSETBACK, $iColor,0)
EndFunc

Func Sci_SelectionSetBkColor($Sci, $iColor, $iUse=True)
	Return SendMessage($Sci, $SCI_SETSELBACK, $iUse, $iColor)
EndFunc

Func Sci_SelectionSetColor($Sci, $iColor, $iUse=True)
	Return SendMessage($Sci, $SCI_SETSELFORE, $iUse, $iColor)
EndFunc

Func Sci_SelectionSetAlpha($Sci, $iAlpha)
	Return SendMessage($Sci, $SCI_SETSELALPHA, $iAlpha, 0)
EndFunc

Func Sci_SelectionGetAlpha($Sci)
	Return SendMessage($Sci, $SCI_GETSELALPHA, 0, 0)
EndFunc

Func Sci_CaretSetColor($Sci, $iColor)
	Return SendMessage($Sci, $SCI_SETCARETFORE, $iColor, 0)
EndFunc

Func Sci_CaretGetColor($Sci)
	Return SendMessage($Sci, $SCI_GETCARETFORE, 0, 0)
EndFunc

Func Sci_CaretSetWidth($Sci, $iWidth)
	Return SendMessage($Sci, $SCI_SETCARETWIDTH, $iWidth, 0)
EndFunc

Func Sci_CaretGetWidth($Sci)
	Return SendMessage($Sci, $SCI_GETCARETWIDTH, 0, 0)
EndFunc

Func Sci_FoldingShowLines($Sci, $iStart, $iEnd)
	Return SendMessage($Sci, $SCI_SHOWLINES, $iStart, $iEnd)
EndFunc

Func Sci_FoldingHideLines($Sci, $iStart, $iEnd)
	Return SendMessage($Sci, $SCI_HIDELINES, $iStart, $iEnd)
EndFunc

Func Sci_FoldingToggleFold($Sci, $iLine)
	Return SendMessage($Sci, $SCI_TOGGLEFOLD, $iLine, 0)
EndFunc

; -----------------------------------------------------------------------------------------------------------------------------------------------
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;================================================================================================================================================
;  SciLexer Functions	|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;================================================================================================================================================
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;------------------------------------------------------------------------------------------------------------------------------------------------


Func CreateWindowEx($dwExStyle, $lpClassName, $lpWindowName = "", $dwStyle = -1, $X = 0, $Y = 0, $nWidth = 0, $nHeight = 0, $hwndParent = 0, $hMenu = 0, $hInstance = 0, $lParm = 0)
	Local $ret
	If $hInstance = 0 Then
		$ret = DllCall($user32, "long", "GetWindowLong", "hwnd", $hwndParent, "int", -6)
		$hInstance = $ret[0]
	EndIf
	$ret = DllCall($user32, "hwnd", "CreateWindowEx", "long", $dwExStyle, _
			"str", $lpClassName, "str", $lpWindowName, _
			"long", $dwStyle, "int", $X, "int", $Y, "int", $nWidth, "int", $nHeight, _
			"hwnd", $hwndParent, "hwnd", $hMenu, "long", $hInstance, "ptr", $lParm)
	If @error Then Return 0
	Return $ret[0]
EndFunc   ;==>CreateWindowEx

Func LoadLibrary($lpFileName)
	Local $ret
	$ret = DllCall($kernel32, "int", "LoadLibrary", "str", $lpFileName)

	If @error Then Return 0

	$hLib = $ret[0]

	Return $ret[0]
EndFunc   ;==>LoadLibrary

Func SendMessage($hwnd, $msg, $wp, $lp)
	Local $ret
	$ret = DllCall($user32, "long", "SendMessageA", "long", $hwnd, "int", $msg, "int", $wp, "int", $lp)
	If @error Then
		SetError(1)
		Return 0
	Else
		SetError(0)
		Return $ret[0]
	EndIf

EndFunc   ;==>SendMessage

Func SendMessageString($hwnd, $msg, $wp, $str)
	Local $ret
	$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $hwnd, "int", $msg, "int", $wp, "str", $str)
	if not IsArray($ret) then return ""
	Return $ret[0]
EndFunc   ;==>SendMessageString

Func CreateEditor($Hwnd, $X,$Y,$W,$H)
	Local $GWL_HINSTANCE = -6
	Local $hLib = LoadLibrary(@scriptdir&"\Data\SciLexer.DLL")
	If @error Then
		Return 0
	EndIf

	local $Sci
	$Sci = CreateWindowEx($WS_EX_CLIENTEDGE, "Scintilla", _
			"SciLexer", BitOR($WS_CHILD, $WS_VISIBLE, $WS_HSCROLL, $WS_VSCROLL),  $X,$Y,$W,$H, _
			$Hwnd, 0, 0, 0) ;Removed  $WS_TABSTOP with 0.95 BETA
	;If @error Then
	;	Return 0
	;EndIf
	;$aiSize = WinGetClientSize($Hwnd)
	If @error Then
		Return 0
	Else

		If not IsHWnd($Sci) Then $Sci = HWnd($Sci)

		Return $Sci
	EndIf
EndFunc   ;==>CreateEditor


Func InitEditor($Sci)
	SendMessage($Sci, $SCI_SETLEXER, $SCLEX_AU3, 0)
	Local $bits = SendMessage($Sci, $SCI_GETSTYLEBITSNEEDED, 0, 0)
	SendMessage($Sci, $SCI_SETSTYLEBITS, $bits, 0)

	SendMessage($Sci, $SCI_SETTABWIDTH, 4, 0)
	SendMessage($Sci, $SCI_SETINDENTATIONGUIDES, True, 0)
#cs
	SendMessage($Sci, $SCI_SETZOOM, IniRead($ScintillaDir & "\config.ini", "Settings", "Zoom", -1), 0)

	SendMessageString($Sci, $SCI_SETKEYWORDS, 0, FileRead($ScintillaDir & "\Keywords.txt"))
	SendMessageString($Sci, $SCI_SETKEYWORDS, 1, FileRead($ScintillaDir & "\Functions.txt"))
	SendMessageString($Sci, $SCI_SETKEYWORDS, 2, FileRead($ScintillaDir & "\Macros.txt"))
	SendMessageString($Sci, $SCI_SETKEYWORDS, 3, FileRead($ScintillaDir & "\SendKeys.txt"))
	SendMessageString($Sci, $SCI_SETKEYWORDS, 4, FileRead($ScintillaDir & "\PreProcessor.txt"))
	SendMessageString($Sci, $SCI_SETKEYWORDS, 5, FileRead($ScintillaDir & "\Special.txt"))
	;SendMessageString($Sci, $SCI_SETKEYWORDS, 6,"simple scilexer UDF by Kip")
	SendMessageString($Sci, $SCI_SETKEYWORDS, 7, FileRead($ScintillaDir & "\UDFs.txt"))
#ce
	SendMessage($Sci, $SCI_SETMARGINTYPEN, $MARGIN_SCRIPT_NUMBER, $SC_MARGIN_NUMBER)
	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_NUMBER, SendMessageString($Sci, $SCI_TEXTWIDTH, $STYLE_LINENUMBER, "_99999"))

	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 16)

	SendMessage($Sci, $SCI_AUTOCSETSEPARATOR, Asc(@CR), 0)
	SendMessage($Sci, $SCI_AUTOCSETIGNORECASE, True, 0)

	SetStyle($Sci, $STYLE_DEFAULT, 0x000000, 0xFFFFFF, 10, "Courier New")
	SendMessage($Sci, $SCI_STYLECLEARALL, 0, 0)

	SetStyle($Sci, $STYLE_BRACEBAD, 0x009966, 0xFFFFFF, 0, "", 0, 1)

	SetStyle($Sci, $SCE_AU3_DEFAULT, 0x000000, 0xFFFFFF)
	SetStyle($Sci, $SCE_AU3_COMMENT, 0x339900, 0xFFFFFF)
	SetStyle($Sci, $SCE_AU3_COMMENTBLOCK, 0x009966, 0xFFFFFF)
	SetStyle($Sci, $SCE_AU3_NUMBER, 0xA900AC, 0xFFFFFF, 0, "", 1)

	SetStyle($Sci, $SCE_AU3_FUNCTION, 0xAA0000, 0xFFFFFF, 0, "", 1, 1)

	SetStyle($Sci, $SCE_AU3_KEYWORD, 0xFF0000, 0xFFFFFF, 0, "", 1)
	SetStyle($Sci, $SCE_AU3_MACRO, 0xFF33FF, 0xFFFFFF, 0, "", 1)
	SetStyle($Sci, $SCE_AU3_STRING, 0xCC9999, 0xFFFFFF, 0, "", 1)
	SetStyle($Sci, $SCE_AU3_OPERATOR, 0x0000FF, 0xFFFFFF, 0, "", 1)
	SetStyle($Sci, $SCE_AU3_VARIABLE, 0x000090, 0xFFFFFF, 0, "", 1)
	SetStyle($Sci, $SCE_AU3_SENT, 0x0080FF, 0xFFFFFF, 0, "", 1)

	SetStyle($Sci, $SCE_AU3_PREPROCESSOR, 0xFF00F0, 0xFFFFFF, 0, "", 0, 0)
	SetStyle($Sci, $SCE_AU3_SPECIAL, 0xF00FA0, 0xFFFFFF, 0, "", 0, 1)
	SetStyle($Sci, $SCE_AU3_EXPAND, 0x0000FF, 0xFFFFFF, 0, "", 1)
	SetStyle($Sci, $SCE_AU3_COMOBJ, 0xFF0000, 0xFFFFFF, 0, "", 1, 1)
	SetStyle($Sci, $SCE_AU3_UDF, 0xFF8000, 0xFFFFFF, 0, "", 1, 1)

	SetProperty($Sci, "fold", "1")
	SetProperty($Sci, "fold.compact", "1")
	SetProperty($Sci, "fold.comment", "1")
	SetProperty($Sci, "fold.preprocessor", "1")


	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 0); fold margin width=0

	SendMessage($Sci, $SCI_SETMARGINTYPEN, $MARGIN_SCRIPT_FOLD, $SC_MARGIN_SYMBOL)
	SendMessage($Sci, $SCI_SETMARGINMASKN, $MARGIN_SCRIPT_FOLD, $SC_MASK_FOLDERS)
	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 20)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDER, $SC_MARK_ARROW)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPEN, $SC_MARK_ARROWDOWN)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEREND, $SC_MARK_ARROW)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERMIDTAIL, $SC_MARK_TCORNER)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPENMID, $SC_MARK_ARROWDOWN)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERSUB, $SC_MARK_VLINE)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERTAIL, $SC_MARK_LCORNER)
	SendMessage($Sci, $SCI_SETFOLDFLAGS, 16, 0)
	SendMessage($Sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDER, 0xFFFFFF)
	SendMessage($Sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERSUB, 0x808080)
	SendMessage($Sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEREND, 0x808080)
	SendMessage($Sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEREND, 0xFFFFFF)
	SendMessage($Sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERTAIL, 0x808080)
	SendMessage($Sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDERMIDTAIL, 0x808080)
	SendMessage($Sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDER, 0x808080)
	SendMessage($Sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEROPEN, 0xFFFFFF)
	SendMessage($Sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEROPEN, 0x808080)
	SendMessage($Sci, $SCI_MARKERSETFORE, $SC_MARKNUM_FOLDEROPENMID, 0xFFFFFF)
	SendMessage($Sci, $SCI_MARKERSETBACK, $SC_MARKNUM_FOLDEROPENMID, 0x808080)
	SendMessage($Sci, $SCI_SETMARGINSENSITIVEN, $MARGIN_SCRIPT_FOLD, 1)

	SendMessage($Sci, $SCI_MARKERSETBACK, 0, 0x0000FF)

	;GUIRegisterMsg(0x004E, "WM_NOTIFY")

	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>InitEditor

Func SetProperty($hwnd, $property, $value, $int1 = False, $int2 = False)
	Local $ret
	If $int1 And $int2 Then
		$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $hwnd, "int", $SCI_SETPROPERTY, "int", $property, "int", $value)
	ElseIf Not $int1 And Not $int2 Then
		$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $hwnd, "int", $SCI_SETPROPERTY, "str", $property, "str", $value)
	ElseIf $int1 And Not $int2 Then
		$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $hwnd, "int", $SCI_SETPROPERTY, "int", $property, "str", $value)
	ElseIf Not $int1 And $int2 Then
		$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $hwnd, "int", $SCI_SETPROPERTY, "str", $property, "int", $value)
	EndIf
	Return $ret[0]
EndFunc   ;==>SetProperty

Func WM_NOTIFY_Credits($hWndGUI, $MsgID, $wParam, $lParam)

	Local $tagNMHDR = DllStructCreate("int;int;int;int;int;int;int;ptr;int;int;int;int;int;int;int;int;int;int;int", $lParam)

	$hWndFrom = DllStructGetData($tagNMHDR, 1)
	$IdFrom = DllStructGetData($tagNMHDR, 2)
	$Event = DllStructGetData($tagNMHDR, 3)
	$Position = DllStructGetData($tagNMHDR, 4)
	$Ch = DllStructGetData($tagNMHDR, 5)
	$Modifiers = DllStructGetData($tagNMHDR, 6)
	$ModificationType = DllStructGetData($tagNMHDR, 7)
	$Char = DllStructGetData($tagNMHDR, 8)
	$Length = DllStructGetData($tagNMHDR, 9)
	$LinesAdded = DllStructGetData($tagNMHDR, 10)
	$Message = DllStructGetData($tagNMHDR, 11)
	$uptr_t = DllStructGetData($tagNMHDR, 12)
	$sptr_t = DllStructGetData($tagNMHDR, 13)
	$Line = DllStructGetData($tagNMHDR, 14)
	$FoldLevelNow = DllStructGetData($tagNMHDR, 15)
	$FoldLevelPrev = DllStructGetData($tagNMHDR, 16)
	$Margin = DllStructGetData($tagNMHDR, 17)
	$ListType = DllStructGetData($tagNMHDR, 18)
	$X = DllStructGetData($tagNMHDR, 19)
	$Y = DllStructGetData($tagNMHDR, 20)

	Return $GUI_RUNDEFMSG

EndFunc   ;==>WM_NOTIFY


Func SetStyle($Sci, $style, $fore, $back, $size = 0, $font = "", $bold = 0, $italic = 0, $underline = 0)
	SendMessage($Sci, $SCI_STYLESETFORE, $style, $fore)
	SendMessage($Sci, $SCI_STYLESETBACK, $style, $back)
	If $size >= 1 Then
		SendMessage($Sci, $SCI_STYLESETSIZE, $style, $size)
	EndIf
	If $font <> '' Then
		SendMessageString($Sci, $SCI_STYLESETFONT, $style, $font)
	EndIf


	SendMessage($Sci, $SCI_STYLESETBOLD, $style, $bold)
	SendMessage($Sci, $SCI_STYLESETITALIC, $style, $italic)
	SendMessage($Sci, $SCI_STYLESETUNDERLINE, $style, $underline)
EndFunc   ;==>SetStyle

Func _Sci_DebugWindowStyle($Sci)


SendMessage($Sci, $SCI_SETLEXER, $SCLEX_ERRORLIST, 0)
SendMessage($Sci, $SCI_SETSTYLEBITS, SendMessage($Sci, $SCI_GETSTYLEBITSNEEDED, 0, 0), 0)

_RemoveHotKeys($Sci)

	;Setze Kodierung
if $autoit_editor_encoding = "2" then
   if _System_benoetigt_double_byte_character_Support() then
   SendMessage($Sci, $SCI_SETCODEPAGE,  936 ,0) ;Setzte China Encoding für Scintila 936 (Simplified Chinese)
   else
   SendMessage($Sci, $SCI_SETCODEPAGE, $SC_CP_UTF8,0)
   endif
Endif

SetStyle($Sci, $STYLE_DEFAULT, _RGB_to_BGR($Schriftfarbe), _RGB_to_BGR($scripteditor_bgcolour), $scripteditor_size,$scripteditor_font)

SendMessage($Sci, $SCI_STYLECLEARALL, 0, 0)

SendMessage($Sci, $SCI_SETINDENTATIONGUIDES, False, 0)
SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 0)

SendMessage($Sci, $SCI_AUTOCSETSEPARATOR, Asc(@CR), 0)
SendMessage($Sci, $SCI_AUTOCSETIGNORECASE, True, 0)

;~ SetStyle($Sci, 0, _Rev(0xFF0000), 0xFFFFFF, 0, "", 1); Will color normal text
SetStyle($Sci, 4, _Rev(0x0000FF), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 0); Blue Info Text
if $ISN_Dark_Mode = "true" then SetStyle($Sci, 4, _Rev($Schriftfarbe), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 0) ;Blue Info Text (Dark Mode)
SetStyle($Sci, 10, _Rev(0xFF0000), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1) ;Red Error text
SetStyle($Sci, 11, _Rev(0x007F00), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1); Green info text
SetStyle($Sci, 12, _Rev(0xFF8800), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1); Yellow warning text
SetStyle($Sci, 3, _Rev(0xFF0000), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1) ;Clickable errors
SetStyle($Sci, 9, _Rev(0xFF00FF), _RGB_to_BGR($scripteditor_bgcolour), 0, "", 1); Pink text, I don't know but scite seems to display it so I wanted too as well

;mark color
Sci_SetSelectionAlpha($Sci, 70)
Sci_SetSelectionBkColor($Sci, _RGB_to_BGR($scripteditor_marccolour),true)

;autoscrollbar für seeehr lange zeilen ;)
SendMessage($Sci, $SCI_SETSCROLLWIDTHTRACKING, True, 0)



;~ SendMessage($Sci, $SCI_SETSCROLLWIDTH, 1, 0)
If @error Then Return 0
Return 1
EndFunc ;==>_Sci_DebugWindowStyle


; #FUNCTION# ====================================================================================================================
; Name ..........: _Rev
; Description ...: Reverses the color bits
; Syntax ........: _Rev($iColor)
; Parameters ....: $iColor - Hex color value.
; Return values .: None
; Author ........: Trancexx
; Modified ......: ApudAngelorum
; ===============================================================================================================================
Func _Rev($Color)
If IsString($Color) Then Return Dec(Hex(BinaryMid(Dec(StringReplace($Color, "0x", "")), 1, 3)))
Return Dec(Hex(BinaryMid($Color, 1, 3)))
EndFunc ;==>_Rev

Func _RemoveHotKeys($Sci)
Local $BitShift = BitShift($SCMOD_CTRL, -16)
    SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x44, 0); Ctrl + D
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x44, 0); Ctrl + SHIFT + D
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x45, 0); Ctrl + E
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x45, 0); Ctrl + SHIFT + E
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x47, 0); Ctrl + G
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x47, 0); Ctrl + SHIFT + G
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4E, 0); Ctrl + N
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4E, 0); Ctrl + SHIFT + N
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4F, 0); Ctrl + O
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4F, 0); Ctrl + SHIFT + O
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x53, 0); Ctrl + S
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x53, 0); Ctrl + SHIFT + S
    SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x50, 0); Ctrl + P
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x50, 0); Ctrl + SHIFT + P
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x46, 0); Ctrl + F
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x46, 0); Ctrl + SHIFT + F
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x54, 0); Ctrl + T
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x54, 0); Ctrl + SHIFT + T
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x57, 0); Ctrl + W
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x57, 0); Ctrl + SHIFT + W
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x51, 0); Ctrl + Q
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x51, 0); Ctrl + SHIFT + Q
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x42, 0); Ctrl + B
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x42, 0); Ctrl + SHIFT + B
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x48, 0); Ctrl + H
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x48, 0); Ctrl + SHIFT + H
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x49, 0); Ctrl + I
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x49, 0); Ctrl + SHIFT + I
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x4A, 0); Ctrl + J
	SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + BitShift($SCMOD_SHIFT, -16) + 0x4A, 0); Ctrl + SHIFT + J
Return
EndFunc


