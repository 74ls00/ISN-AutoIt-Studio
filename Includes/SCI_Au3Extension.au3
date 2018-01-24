#include-once
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <WinAPI.au3>



Global Const $tagCharacterRange = "long cpMin; long cpMax"

Global Const $tagRangeToFormat = _
		"hwnd hdc;" & _ ;        // The HDC (device context) we print to
		"hwnd hdcTarget;" & _ ;  // The HDC we use for measuring (may be same as hdc)
		"int rc[4];" & _ ;        // Rectangle in which to print
		"int rcPage[4];" & _ ;    // Physically printable page size
		"long chrg[2]" ;  //CharacterRange: Range of characters to print

#cs
Global Const $tagSCNotification = "hwnd hWndFrom;int IDFrom;int Code;" & _
		"int position;" & _ ;  // SCN_STYLENEEDED, SCN_DOUBLECLICK, SCN_MODIFIED, SCN_DWELLSTART, SCN_DWELLEND, SCN_CALLTIPCLICK, SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK
		"int ch;" & _             ;// SCN_CHARADDED, SCN_KEY
		"int modifiers;" & _      ;// SCN_KEY, SCN_DOUBLECLICK, SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK
		"int modificationType;" & _ ;// SCN_MODIFIED
		"ptr text;" & _  ;const char *text ;// SCN_MODIFIED, SCN_USERLISTSELECTION, SCN_AUTOCSELECTION
		"int length;" & _         ;// SCN_MODIFIED
		"int linesAdded;" & _     ;// SCN_MODIFIED
		"int message;" & _        ;// SCN_MACRORECORD
		"dword wParam;" & _      ;// SCN_MACRORECORD
		"dword lParam;" & _      ;// SCN_MACRORECORD
		"int line;" & _           ;// SCN_MODIFIED, SCN_DOUBLECLICK
		"int foldLevelNow;" & _   ;// SCN_MODIFIED
		"int foldLevelPrev;" & _  ;// SCN_MODIFIED
		"int margin;" & _         ;// SCN_MARGINCLICK
		"int listType;" & _       ;// SCN_USERLISTSELECTION, SCN_AUTOCSELECTION
		"int x;" & _              ;// SCN_DWELLSTART, SCN_DWELLEND
		"int y;" ;// SCN_DWELLSTART, SCN_DWELLEND
;~ };
#ce


Func SCI_CreateEditorAu3($hWnd, $X, $Y, $W, $H, $CalltipPath = $SCI_DEFAULTCALLTIPDIR, $KeyWordDir = $SCI_DEFAULTKEYWORDDIR, $AbbrevDir = $SCI_DEFAULTABBREVDIR, $RegisterWM_NOTIFY = True) ; The return value is the hwnd of the window, and can be used for Win.. functions
	Local $Sci = SCI_CreateEditor($hWnd, $X, $Y, $W, $H)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf


			SCI_InitEditorAu3($Sci, $CalltipPath, $KeyWordDir, $AbbrevDir)


	If @error Then
		Return SetError(2, 0, 0)
	Else
		;If $RegisterWM_NOTIFY = True Then GUIRegisterMsg(0x4E, "_WM_NOTIFY")
		Return $Sci
	EndIf


EndFunc   ;==>SCI_CreateEditorAu3
; Prog@ndy
Func SCI_SetText($Sci,$Text)
	Return SendMessageString($Sci,$SCI_SETTEXT,0,$Text)
EndFunc
; Prog@ndy
Func SCI_GetTextLen($Sci)
	Local $iLen = SendMessage($Sci, $SCI_GETTEXT, 0, 0)
	If @error Then Return SetError(1, 0, 0)
	Return $iLen
EndFunc   ;==>SCI_GetTextLen

#cs
; changed form SCI_GetLines
Func SCI_GetText($Sci)
	Local $ret, $sText, $iLen, $sBuf
	$iLen = SendMessage($Sci, $SCI_GETTEXT, 0, 0)
	If @error Then
		Return SetError(1,0,"")
	EndIf
	$sBuf = DllStructCreate("byte[" & $iLen & "]")
	If @error Then
		Return SetError(2,0,"")
	EndIf
	$ret = DllCall($user32, "long", "SendMessageA", "long", $Sci, "int", $SCI_GETTEXT, "int", $iLen, "ptr", DllStructGetPtr($sBuf))
	If @error Then
		Return SetError(3,0,"")
	EndIf
	$sText = BinaryToString(DllStructGetData($sBuf, 1))
	$sBuf = 0
	If @error Then
		Return SetError(4,0,"")
	Else
		Return $sText
	EndIf
EndFunc
#ce
; Author: Prog@ndy

Func SCI_GetSelectionText($Sci="")
   local $Text = ""
   	$start = SendMessage($Sci, $SCI_GETSELECTIONSTART, 0, 0)
	$end = SendMessage($Sci, $SCI_GETSELECTIONEND, 0, 0)
	$Text = SCI_GetTextRange($Sci, $start, $end)
	Return $Text
 EndFunc   ;==>SCI_GETTEXTRANGE



Func SCI_GetTextRange($Sci, $start, $end)
	If $start > $end Then Return SetError(1, 0, "")
	Local $textRange = DllStructCreate($tagCharacterRange & "; ptr TextPtr; char Text[" & $end - $start + 1 & "]")
	DllStructSetData($textRange, 1, $start)
	DllStructSetData($textRange, 2, $end)
	DllStructSetData($textRange, 3, DllStructGetPtr($textRange, 4))
	SendMessage($Sci, $SCI_GETTEXTRANGE, 0, DllStructGetPtr($textRange))
	Return DllStructGetData($textRange, "Text")
EndFunc   ;==>SCI_GETTEXTRANGE

; Changed by Prog@ndy
Func SCI_GetCurrentWordEx($Sci, $onlyWordCharacters = 1, $CHARADDED = 0)
	Local $CurrentPos = SCI_GetCurrentPos($Sci)
	$CurrentPos -= ($CHARADDED = True)
	Return SCI_GetWordFromPos($Sci, $CurrentPos, $onlyWordCharacters)
EndFunc   ;==>SCI_GetCurrentWordEx
; Author: Prog@ndy
Func SCI_GetWordPositions($Sci, $CurrentPos, $onlyWordCharacters = 1)
	Local $Return[2] = [-1, -1]
	$Return[0] = SendMessage($Sci, $SCI_WORDSTARTPOSITION, $CurrentPos, $onlyWordCharacters)
	$Return[1] = SendMessage($Sci, $SCI_WORDENDPOSITION, $CurrentPos, $onlyWordCharacters)
	Return $Return
EndFunc   ;==>SCI_GetWordPositions
; Author: Prog@ndy
Func SCI_GetWordFromPos($Sci, $CurrentPos, $onlyWordCharacters = 1)
;~ 	Local $Return, $i, $Get, $char

;~ 	Local $CurrentPos = SCI_GetCurrentPos($Sci)
;~ 	$CurrentPos -= ($CHARADDED = True)
	Local $start = SendMessage($Sci, $SCI_WORDSTARTPOSITION, $CurrentPos, $onlyWordCharacters)
	Local $end = SendMessage($Sci, $SCI_WORDENDPOSITION, $CurrentPos, $onlyWordCharacters)
	Return SCI_GETTEXTRANGE($Sci, $start, $end)

EndFunc   ;==>SCI_GetWordFromPos


func _Script_Editor_properties_Einlesen($Ordner = "")
if $Ordner = "" then return
$Ordner = _WinAPI_PathAddBackslash ($Ordner)
if not FileExists($Ordner) then return
Local $SciteKeyWord_handle = FileFindFirstFile($Ordner & "\*.keywords.properties")
Local $file
While 1
		$file = FileFindNextFile($SciteKeyWord_handle)
		If @error Then ExitLoop
		If StringRight($SciteKeyWord, 2) <> @CRLF Then $SciteKeyWord &= @CRLF
		$SciteKeyWord &= FileRead($Ordner & $file)
WEnd

;User abbreviations 1/2
Local $SciteKeyWord_handle = FileFindFirstFile($Ordner & "\*abbrev.properties")
Local $file
While 1
		$file = FileFindNextFile($SciteKeyWord_handle)
		If @error Then ExitLoop
		If StringRight($SCI_ABBREVFILE, 2) <> @CRLF Then $SCI_ABBREVFILE &= @CRLF
		$SCI_ABBREVFILE &= FileRead($Ordner & $file)
WEnd


;User abbreviations 2/2
Local $SciteKeyWord_handle = FileFindFirstFile($Ordner & "\au3.keywords*abbreviations.properties")
Local $file
While 1
		$file = FileFindNextFile($SciteKeyWord_handle)
		If @error Then ExitLoop
		 Local $au3_keywords_abbrev_read = FileRead($Ordner & $file)
		 If StringLen($au3_keywords_abbrev_read) Then
		$au3_keywords_abbrev_read = StringRegExpReplace($au3_keywords_abbrev_read, "(\w)(\r\n)", "$1 $2")
		$au3_keywords_abbrev_read = StringSplit($au3_keywords_abbrev_read, " " & @CRLF, 1)
		For $i = 0 To UBound($au3_keywords_abbrev_read) - 1
			$PART = StringLeft($au3_keywords_abbrev_read[$i], 26)
			Select
				Case StringInStr($PART, "au3.keywords.abbrev=", 0, 1, 1)
					$au3_keywords_abbrev &= StringReplace(StringTrimLeft($au3_keywords_abbrev_read[$i], StringLen("au3.keywords.abbrev=")), "\" & @CRLF, @CRLF)&" "
			    Case StringInStr($PART, "au3.keywords.userabbrev=", 0, 1, 1)
					$au3_keywords_abbrev &= StringReplace(StringTrimLeft($au3_keywords_abbrev_read[$i], StringLen("au3.keywords.userabbrev=")), "\" & @CRLF, @CRLF)&" "
			EndSelect
		Next
	EndIf
WEnd

EndFunc

func _Script_Editor_APIs_Einlesen($Ordner="")
if $Ordner = "" then return
   $Ordner = _WinAPI_PathAddBackslash ($Ordner)
   if not FileExists($Ordner) then return
	Local $ExtraAPIs = FileFindFirstFile($Ordner & "\au3.*.api")
	Local $file
	While 1
		$file = FileFindNextFile($ExtraAPIs)
		If @error Then ExitLoop
		If StringRight($SCI_sCallTip_Array, 2) <> @CRLF Then $SCI_sCallTip_Array &= @CRLF
		$SCI_sCallTip_Array &= FileRead($Ordner & $file)

	WEnd
	FileClose($ExtraAPIs)
EndFunc


Func _Skripteditor_APIs_und_properties_neu_einlesen()
$SciteKeyWord = "" ;Reset
$SCI_sCallTip_Array = "" ;Reset
$SCI_ABBREVFILE = "" ;Reset
$au3_keywords_abbrev = "" ;Reset

;~ $SCI_ABBREVFILE = FileRead($SCI_DEFAULTABBREVDIR & "abbrev.properties")

;Properties Dateien aufbereiten
   _Script_Editor_properties_Einlesen($SCI_DEFAULTKEYWORDDIR) ;Default Pfad einlesen
   if $Erstkonfiguration_Mode <> "portable" AND $Arbeitsverzeichnis <> @scriptdir then  _Script_Editor_properties_Einlesen($Arbeitsverzeichnis&"\Data\Properties") ;2ten default Pfad einlesen

;Weitere Pfade aus den Programmeinstellungen
if $Zusaetzliche_Properties_Ordner <> "" Then
   $Orner_Array = StringSplit($Zusaetzliche_Properties_Ordner,"|",2)
   if IsArray($Orner_Array) Then
	  for $index = 0 to ubound($Orner_Array)-1
		 if $Orner_Array[$index] = "" then ContinueLoop
		 if $Orner_Array[$index] = "%isnstudiodir%\Data\Properties" then ContinueLoop
		 if $Orner_Array[$index] = "%myisndatadir%\Data\Properties" then ContinueLoop
		 _Script_Editor_properties_Einlesen(_ISN_Variablen_aufloesen($Orner_Array[$index]))
	  Next
   Endif
EndIf

;Weitere Projektspezifische Pfade (properties)
if $Offenes_Projekt <> "" Then
 $Projekt_properties_Pfade = _ProjectISN_Config_Read("additional_properties_folders","")
 if $Projekt_properties_Pfade <> "" then
   $Orner_Array = StringSplit($Projekt_properties_Pfade,"|",2)
	  if IsArray($Orner_Array) Then
		 for $index = 0 to ubound($Orner_Array)-1
			if $Orner_Array[$index] = "" then ContinueLoop
			if $Orner_Array[$index] = "%isnstudiodir%\Data\Properties" then ContinueLoop
			if $Orner_Array[$index] = "%myisndatadir%\Data\Properties" then ContinueLoop
			_Script_Editor_properties_Einlesen(_ISN_Variablen_aufloesen($Orner_Array[$index]))
		 Next
	  Endif
   Endif
endif



If StringLen($SciteKeyWord) Then
		$SciteKeyWord = StringRegExpReplace($SciteKeyWord, "(\w)(\r\n)", "$1 $2")
		$SciteKeyWord = StringSplit($SciteKeyWord, " " & @CRLF, 1)
		Local $PART
;~ 	$SCI_AUTOCLIST = ""

		For $i = 0 To UBound($SciteKeyWord) - 1
			$PART = StringLeft($SciteKeyWord[$i], 36)
			Select
				Case StringInStr($PART, "au3.keywords.functions=", 0, 1, 1)
					$au3_keywords_functions = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.functions=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "au3.keywords.udfs=", 0, 1, 1)
					$au3_keywords_udfs = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.udfs=")), "\" & @CRLF, @CRLF)
;~ 					SendMessageString($Sci, $SCI_SETKEYWORDS, 7, $tempText)
					$UDF_Keywords = $UDF_Keywords&$au3_keywords_udfs&" "

				Case StringInStr($PART, "au3.keywords.keywords=", 0, 1, 1)
					$au3_keywords_keywords = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.keywords=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "au3.keywords.macros=", 0, 1, 1)
					$au3_keywords_macros = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.macros=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "au3.keywords.preprocessor=", 0, 1, 1)
					$au3_keywords_preprocessor = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.preprocessor=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "au3.keywords.special=", 0, 1, 1)
					$au3_keywords_special = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.special=")), "\" & @CRLF, @CRLF)
					$special_Keywords = $special_Keywords&$au3_keywords_special&" "

				Case StringInStr($PART, "au3.keywords.sendkeys=", 0, 1, 1)
					$au3_keywords_sendkeys = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("au3.keywords.sendkeys=")), "\" & @CRLF, @CRLF)


				Case StringInStr($PART, "autoit3wrapper.keywords.special=", 0, 1, 1)
					$autoit3wrapper_keywords_special = StringReplace(StringTrimLeft($SciteKeyWord[$i], StringLen("autoit3wrapper.keywords.special=")), "\" & @CRLF, @CRLF)
					$special_Keywords = $special_Keywords&$autoit3wrapper_keywords_special&" "

				Case Else
					$tempText = Ptr(123456)
			EndSelect
;~ 		If Not IsPtr($tempText) Then $SCI_AUTOCLIST &= $tempText & " "
		Next
	EndIf


	$UDF_Keywords = StringReplace($UDF_Keywords,@tab,"")
	$UDF_Keywords = StringReplace($UDF_Keywords,@CRLF," ")
	$UDF_Keywords = StringReplace($UDF_Keywords,"  "," ")



	$special_Keywords = StringReplace($special_Keywords,@tab,"")
	$special_Keywords = StringReplace($special_Keywords,@CRLF," ")
	$special_Keywords = StringReplace($special_Keywords,"  "," ")






   ;API Dateien aufbereiten
	$SCI_sCallTip_Array = FileRead($SCI_DEFAULTCALLTIPDIR & "\au3.api")

   if $Erstkonfiguration_Mode <> "portable" AND $Arbeitsverzeichnis <> @scriptdir then  _Script_Editor_APIs_Einlesen($Arbeitsverzeichnis&"\Data\Api") ;2ten default Pfad einlesen

	;Weitere Pfade aus den Programmeinstellungen
if $Zusaetzliche_API_Ordner <> "" Then
   $Orner_Array = StringSplit($Zusaetzliche_API_Ordner,"|",2)
   if IsArray($Orner_Array) Then
	  for $index = 0 to ubound($Orner_Array)-1
		 if $Orner_Array[$index] = "" then ContinueLoop
		 if $Orner_Array[$index] = "%isnstudiodir%\Data\Api" then ContinueLoop
		 if $Orner_Array[$index] = "%myisndatadir%\Data\Api" then ContinueLoop
			_Script_Editor_APIs_Einlesen(_ISN_Variablen_aufloesen($Orner_Array[$index]))
	  Next
   Endif
EndIf

;Weitere Projektspezifische Pfade (API)
if $Offenes_Projekt <> "" Then
 $Projekt_API_Pfade = _ProjectISN_Config_Read("additional_api_folders","")
 if $Projekt_API_Pfade <> "" then
   $Orner_Array = StringSplit($Projekt_API_Pfade,"|",2)
	  if IsArray($Orner_Array) Then
		 for $index = 0 to ubound($Orner_Array)-1
			if $Orner_Array[$index] = "" then ContinueLoop
			if $Orner_Array[$index] = "%isnstudiodir%\Data\Api" then ContinueLoop
			if $Orner_Array[$index] = "%myisndatadir%\Data\Api" then ContinueLoop
			_Script_Editor_APIs_Einlesen(_ISN_Variablen_aufloesen($Orner_Array[$index]))
		 Next
	  Endif
   Endif
endif


   _Script_Editor_APIs_Einlesen($SCI_DEFAULTCALLTIPDIR) ;Default Pfad einlesen
   If StringRight($SCI_sCallTip_Array, 2) = @CRLF Then StringTrimRight($SCI_sCallTip_Array, 2)
	$SCI_sCallTip_Array = StringSplit($SCI_sCallTip_Array, @CRLF, 1)



	Global $SCI_AUTOCLIST[UBound($SCI_sCallTip_Array)] = [UBound($SCI_sCallTip_Array) - 1]
	Local $temp
		For $i = 1 To $SCI_AUTOCLIST[0]

		$temp = StringRegExp($SCI_sCallTip_Array[$i], "\A([#@]?\w+)", 1)


		If Not @error Then $SCI_AUTOCLIST[$i] = $temp[0]&_Return_Pixnumber($temp[0])

		Next

	ArraySortUnique($SCI_AUTOCLIST, 0, 1)
	Global $SCI_Autocompletelist_backup = $SCI_AUTOCLIST ;Backup Orginal List

endfunc


;modified by Prog@ndy
Func SCI_InitEditorAu3($Sci, $CalltipPath = $SCI_DEFAULTCALLTIPDIR, $KeyWordDir = $SCI_DEFAULTKEYWORDDIR, $AbbrevDir = $SCI_DEFAULTABBREVDIR)
	If $CalltipPath = "" Or $CalltipPath = Default Or IsNumber($CalltipPath) Then $CalltipPath = $SCI_DEFAULTCALLTIPDIR
	If $KeyWordDir = "" Or $KeyWordDir = Default Or IsNumber($KeyWordDir) Then $KeyWordDir = $SCI_DEFAULTKEYWORDDIR
	If $AbbrevDir = "" Or $AbbrevDir = Default Or IsNumber($AbbrevDir) Then $AbbrevDir = $SCI_DEFAULTABBREVDIR

	SendMessage($Sci, $SCI_SETLEXER, $SCLEX_AU3, 0)

	Local $bits = SendMessage($Sci, $SCI_GETSTYLEBITSNEEDED, 0, 0)
	SendMessage($Sci, $SCI_SETSTYLEBITS, $bits, 0)

	SendMessage($Sci, $SCI_SETTABWIDTH, 4, 0)
	SendMessage($Sci, $SCI_SETINDENTATIONGUIDES, 1, 0)


 	SendMessage($Sci, $SCI_SETZOOM, IniRead($Configfile, "Settings", "scripteditor_zoom", -1), 0)






;properties und APIs setzen
SendMessageString($Sci, $SCI_SETKEYWORDS, 0, $au3_keywords_keywords)
SendMessageString($Sci, $SCI_SETKEYWORDS, 1, $au3_keywords_functions)
SendMessageString($Sci, $SCI_SETKEYWORDS, 2, $au3_keywords_macros)
SendMessageString($Sci, $SCI_SETKEYWORDS, 3, $au3_keywords_sendkeys)
SendMessageString($Sci, $SCI_SETKEYWORDS, 4, $au3_keywords_preprocessor)
SendMessageString($Sci, $SCI_SETKEYWORDS, 5, $special_Keywords)
SendMessageString($Sci, $SCI_SETKEYWORDS, 6, $au3_keywords_abbrev)
SendMessageString($Sci, $SCI_SETKEYWORDS, 7, $UDF_Keywords)



   If $showlines = "false" then
		SendMessage($sci,$SCI_SETMARGINWIDTHN, 0, 0)
	Else
		$pixelWidth = SendMessageString($sci,$SCI_TEXTWIDTH, $STYLE_LINENUMBER, "999999")
		SendMessage($sci,$SCI_SETMARGINWIDTHN, 0, $pixelWidth);
   EndIf

	;Setze Kodierung
if $autoit_editor_encoding = "2" then
   if _System_benoetigt_double_byte_character_Support() then
   SendMessage($Sci, $SCI_SETCODEPAGE,  936 ,0) ;Setzte China Encoding für Scintila 936 (Simplified Chinese)
   else
   SendMessage($Sci, $SCI_SETCODEPAGE, $SC_CP_UTF8,0)
   endif
Endif


;SendMessage($Sci,$SCI_STYLESETCHARACTERSET,$STYLE_DEFAULT,$SC_CHARSET_DEFAULT);



	SendMessage($Sci, $SCI_SETMARGINTYPEN, $MARGIN_SCRIPT_NUMBER, $SC_MARGIN_NUMBER)
;~ 	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_NUMBER, SendMessageString($Sci, $SCI_TEXTWIDTH, $STYLE_LINENUMBER, "_99999"))

	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_ICON, 16)

	SendMessage($Sci, $SCI_AUTOCSETSEPARATOR, Asc(@CR), 0)
	SendMessage($Sci, $SCI_AUTOCSETIGNORECASE, true, 0)
	SendMessage($Sci, $SCI_AUTOCSETAUTOHIDE, true, 0)






	$r = _ColorGetRed($scripteditor_bgcolour)
	$g = _ColorGetGreen($scripteditor_bgcolour)
	$b = _ColorGetBlue($scripteditor_bgcolour)
	$bgclr = "0x"&hex($b,2)&hex($g,2)&hex($r,2)
	SetStyle($Sci, $STYLE_DEFAULT, 0x000000, $bgclr, $scripteditor_size,$scripteditor_font)
	SendMessage($Sci, $SCI_STYLECLEARALL, 0, 0)

	SetStyle($Sci, $STYLE_BRACEBAD, 0x009966, 0xFFFFFF, 0, "", 0, 1)

	;Spezial settings für Dark Mode (Line numbers farben usw.)
   if $ISN_Dark_Mode = "true" then
   SetStyle($Sci, $STYLE_LINENUMBER, 0xADACAA, $Fenster_Hintergrundfarbe, 0, "", 0, 1)
   SendMessage($Sci,$SCI_SETFOLDMARGINCOLOUR,$Fenster_Hintergrundfarbe,0)
   SendMessage($Sci, $SCI_CALLTIPSETBACK, _RGB_to_BGR($Fenster_Hintergrundfarbe),0)
   SendMessage($Sci, $SCI_CALLTIPSETFOREHLT, _RGB_to_BGR(0xFF5757),0)
   SendMessage($Sci, $SCI_CALLTIPSETFORE, _RGB_to_BGR(0xADACAA),0)
   endif





;Farbeinstellungen für AU3-Code
;$fore, $back, $size = 0, $font = "", $bold = 0, $italic = 0, $underline = 0)
if $use_new_au3_colours = "true" then
;Neuer Farbstiel
$Split = StringSplit($SCE_AU3_STYLE1b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_DEFAULT, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE2b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_COMMENT, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE3b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_COMMENTBLOCK, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE4b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_NUMBER, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE5b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_FUNCTION, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE6b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_KEYWORD, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE7b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_MACRO, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE8b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_STRING, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE9b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_OPERATOR, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE10b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_VARIABLE, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE11b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_SENT, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE12b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_PREPROCESSOR, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE13b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_SPECIAL, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE14b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_EXPAND, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE15b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_COMOBJ, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE16b,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_UDF, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
else
$Split = StringSplit($SCE_AU3_STYLE1a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_DEFAULT, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE2a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_COMMENT, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE3a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_COMMENTBLOCK, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE4a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_NUMBER, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE5a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_FUNCTION, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE6a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_KEYWORD, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE7a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_MACRO, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE8a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_STRING, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE9a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_OPERATOR, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE10a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_VARIABLE, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE11a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_SENT, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE12a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_PREPROCESSOR, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE13a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_SPECIAL, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE14a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_EXPAND, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE15a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_COMOBJ, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
$Split = StringSplit($SCE_AU3_STYLE16a,"|",2)
if ubound($Split)-1 = 4 then SetStyle($Sci, $SCE_AU3_UDF, $Split[0], $Split[1],0,"",$Split[2],$Split[3],$Split[4])
EndIf



    SetProperty($Sci, "fold", "1")
	SetProperty($Sci, "fold.compact", "0")
	SetProperty($Sci, "fold.comment", "1")
	SetProperty($Sci, "fold.preprocessor", "1")


	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 0); fold margin width=0



	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDER, $SC_MARK_ARROW)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPEN, $SC_MARK_BOXMINUS)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEREND, $SC_MARK_ARROW)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERMIDTAIL, $SC_MARK_TCORNER)
	SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPENMID, $SC_MARK_BOXMINUS)
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

;~     SendMessage($Sci_handle, $SCI_CLEARCMDKEY,0x0D, 0); Enter sperren



    SendMessage($Sci, $SCI_CLEARCMDKEY, BitShift($SCMOD_CTRL, -16) + 0x56, 0); Ctrl + V (We use our own paste function)
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

	SendMessage($Sci, $SCI_MARKERDEFINE, 0, $SC_MARK_SHORTARROW)
	SendMessage($Sci, $SCI_MARKERDEFINE, 1, $SC_MARK_BACKGROUND)
	SendMessage($Sci, $SCI_MARKERDEFINE, 2, $SC_MARK_SHORTARROW)
	SendMessage($Sci, $SCI_MARKERSETBACK, 0, 0x0000FF); error or warning
	SendMessage($Sci, $SCI_MARKERSETBACK, 1, 0xE6E5FF); error or warning bg colour
	SendMessage($Sci, $SCI_MARKERSETBACK, 2, 0x03C724); 'mark all' in search win
	SendMessage($Sci, $SCI_SETMARGINSENSITIVEN, $MARGIN_SCRIPT_FOLD, 1)
	SendMessage($Sci, $SCI_UsePopup, 0, 0) ;disable context menu




	SendMessage($Sci, $SCI_MARKERSETBACK, 0, 0x0000FF)
	SendMessage($Sci, $SCI_StyleSetFore, $Style_IndentGuide, 0xC0C0C0);Farbe der INDENTATIONGUIDES
	SendMessage($Sci, $SCI_SETCARETFORE, _RGB_to_BGR($scripteditor_caretcolour), 0);Farbe Caret (Coursor)
	SendMessage($Sci, $SCI_SETCARETWIDTH, $scripteditor_caretwidth, 0);Caret Breite
	SendMessage($Sci, $SetCaretStyle, $scripteditor_caretstyle, 0);Caret Style






;~ 	SendMessage($Sci, $SCI_AUTOCSETAUTOHIDE, false, 0)



	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 0); fold margin width=0
	SendMessage($Sci, $SCI_SETMARGINTYPEN, $MARGIN_SCRIPT_FOLD, $SC_MARGIN_SYMBOL)
	SendMessage($Sci, $SCI_SETMARGINMASKN, $MARGIN_SCRIPT_FOLD, $SC_MASK_FOLDERS)
	SendMessage($Sci, $SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD, 20)




SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDER, $SC_MARK_BOXPLUS);
SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPEN, $SC_MARK_BOXMINUS);
SendMessage($Sci, $SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEREND, $SC_MARK_EMPTY);

;mark color
Sci_SetSelectionAlpha($Sci, 70)
Sci_SetSelectionBkColor($Sci, _RGB_to_BGR($scripteditor_marccolour),true)


;current line color
SendMessage($Sci, $SCI_SETCARETLINEBACK, _RGB_to_BGR($scripteditor_rowcolour), 0) ;BGR
SendMessage($Sci, $SCI_SETCARETLINEVISIBLE,1,0)

;autoscrollbar für seeehr lange zeilen ;)
SendMessage($Sci, $SCI_SETSCROLLWIDTHTRACKING, True, 0)

;Pixmaps
SendMessage($Sci, $SCI_CLEARREGISTEREDIMAGES, 0, 0)	;Lösche Pixmaps

SendMessage($Sci, $SCI_REGISTERIMAGE, 1, DllStructGetPtr($Pixmap_violet_struct, 1)) ;Funktionen
SendMessage($Sci, $SCI_REGISTERIMAGE, 2, DllStructGetPtr($Pixmap_UDF_struct, 1)) ;UDF
SendMessage($Sci, $SCI_REGISTERIMAGE, 3, DllStructGetPtr($Pixmap_blue_struct, 1)) ;Keywoards
SendMessage($Sci, $SCI_REGISTERIMAGE, 4, DllStructGetPtr($Pixmap_macros_struct, 1)) ;macros
SendMessage($Sci, $SCI_REGISTERIMAGE, 5, DllStructGetPtr($Pixmap_preprocessor_struct, 1)) ;preprocessor
SendMessage($Sci, $SCI_REGISTERIMAGE, 6, DllStructGetPtr($Pixmap_red_struct, 1)) ;special
SendMessage($Sci, $SCI_REGISTERIMAGE, 15, DllStructGetPtr($Pixmap_varaiblen_struct, 1)) ;Variablen

	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>SCI_InitEditorAu3

;Prog@ndy, modified _ArraySearch
Func ArraySearchAll(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iPartialfromBeginning = 0, $iForward = 1, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	If $vValue = "" And $iPartialfromBeginning = True Then Return SetError(8, 0, -1)

	; Direction (flip if $iForward = 0)
	Local $iStep = 1
	If Not $iForward Then
		Local $iTmp = $iStart
		$iStart = $iEnd
		$iEnd = $iTmp
		$iStep = -1
	EndIf
	Local $ResultsArray[$iUBound + 1], $ResultIndex = 0
	Local $iLenValue = StringLen($vValue)
	; Search
	Switch UBound($avArray, 0)
		Case 1 ; 1D array search
			If Not $iPartialfromBeginning Then
				For $i = $iStart To $iEnd Step $iStep
					If $avArray[$i] = $vValue Then
						$ResultsArray[$ResultIndex] = $i
						$ResultIndex += 1
					EndIf
				Next
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringLeft($avArray[$i], $iLenValue) = $vValue Then
						$ResultsArray[$ResultIndex] = $i
						$ResultIndex += 1
					EndIf
				Next
			EndIf
		Case 2 ; 2D array search
			Local $iUBoundSub = UBound($avArray, 2) - 1
			If $iSubItem < 0 Then $iSubItem = 0
			If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub

			If Not $iPartialfromBeginning Then
				For $i = $iStart To $iEnd Step $iStep
					If $avArray[$i][$iSubItem] = $vValue Then
						$ResultsArray[$ResultIndex] = $i
						$ResultIndex += 1
					EndIf
				Next
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringLeft($avArray[$i][$iSubItem], $iLenValue) = $vValue Then
						$ResultsArray[$ResultIndex] = $i
						$ResultIndex += 1
					EndIf
				Next
			EndIf
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch

	If $ResultIndex = 0 Then Return SetError(6, 0, -1)
	ReDim $ResultsArray[$ResultIndex]
	Return $ResultsArray
EndFunc   ;==>ArraySearchAll

; Author: Prog@ndy
; If the equal entries are one after the other, delete them :)
Func ArraySortUnique(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	Local $ret = _ArraySort($avArray, $iDescending, $iStart, $iEnd, $iSubItem)
	If @error Then Return SetError(@error, 0, $ret)
    if not IsArray($avArray) then return
	Local $ResultIndex = 1, $ResultArray[UBound($avArray)]
	$ResultArray[0] = $avArray[0]
	For $i = 1 To UBound($avArray) - 1
		If Not ($avArray[$i] = $avArray[$i - 1]) Then
			$ResultArray[$ResultIndex] = $avArray[$i]
			$ResultIndex += 1
		EndIf
	Next
	ReDim $ResultArray[$ResultIndex]
	$avArray = $ResultArray
	Return 1
EndFunc   ;==>ArraySortUnique

func _Return_Pixnumber($string = "")
if $use_new_au3_colours = "true" then
if $string = "abs" then $Pixstring = "?1" ;funcs
if $string = "_array1dtohistogram" then $Pixstring = "?2" ;udfs
if $string = "and" then $Pixstring = "?3" ;keywords
if $string = "@appdatacommondir" then $Pixstring = "?4" ;macros
if $string = "#ce" then $Pixstring = "?5" ;preprocessor
if $string = "#AutoIt3Wrapper_Add_Constants" then $Pixstring = "?6" ;preprocessor
if $string = "#endregion" then $Pixstring = "?6" ;special
if $string = "{!}" then $Pixstring = "" ;back to normal
Else
if $string = "abs" then $Pixstring = "?3" ;funcs
if $string = "_array1dtohistogram" then $Pixstring = "?2" ;udfs
if $string = "and" then $Pixstring = "?3" ;keywords
if $string = "@appdatacommondir" then $Pixstring = "?1" ;macros
if $string = "#ce" then $Pixstring = "?1" ;preprocessor
if $string = "#AutoIt3Wrapper_Add_Constants" then $Pixstring = "?4" ;preprocessor
if $string = "#endregion" then $Pixstring = "?4" ;special
if $string = "{!}" then $Pixstring = "" ;back to normal
endif
return $Pixstring
EndFunc
