

Func _StringSplitCRLF($sText, $sDelimeter = "<##BREAK##>")
	Local $sTemp = StringReplace($sText, @CRLF, $sDelimeter)
	Return StringSplit($sTemp, $sDelimeter, 3)
EndFunc ;==>_StringSplitCRLF

func _Pruefe_Filter($str = "")
if $str = "" then return "true"
if not IsArray($Skriptbaum_Filter_Array) then return "false"
if ubound($Skriptbaum_Filter_Array) < 1 then return "false"
_ArraySort($Skriptbaum_Filter_Array)
$res = _ArrayBinarySearch($Skriptbaum_Filter_Array, $str)
;~ $res = _ArraySearch($Skriptbaum_Filter_Array, $str)
if $res <> -1 then return "true" ;Element ist im filter
return "false" ;Element ist nicht im filter
EndFunc


func _Skriptbaum_aktualisieren()
  AdlibRegister("_Build_Scripttree")
EndFunc

func _Build_Scripttree($rootname="", $nr=-1)
	AdlibUnRegister("_Build_Scripttree")
	if _GUICtrlTab_GetItemCount($htab) < 0 then return
	if _GUICtrlTab_GetCurFocus($htab) = -1 then return
	if not IsDeclared("rootname") then $rootname = stringtrimleft($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], stringinstr($Datei_pfad[_GUICtrlTab_GetCurFocus($htab)], "\", 0, -1))
	if not IsDeclared("nr") then $nr = _GUICtrlTab_GetCurFocus($htab)
	if not stringinstr($Datei_pfad[$nr],"."&$Autoitextension) then return
    GUICtrlSetState($Skriptbaum_Aktualisieren_Button,$GUI_DISABLE)
	_UDF_Funktionen_aus_Skript_Auslesen_und_zum_Autocomplete_hinzufuegen()
	if $hidefunctionstree = "true" then return

	_GUICtrlTreeView_BeginUpdate($hTreeview2)
	_Save_Scripttree()
;~ 	if $Can_open_new_tab = 1 then _Save_Scripttree()
	Local $UDF_Funcs_Keywoardstring = ""
	Local $Globalvariables_Array[1]
	Local $localvariables_Array[1]
	Local $functions_Array[1]
	Local $includes_Array[1]
	Local $regions_Array[1]
	Local $Last_CE = 0

   if _GUICtrlTreeView_GetSelection ($hTreeview2) <> 0 Then
	  $Skriptbaum_markiertes_Element_vor_Reload = _GUICtrlTreeView_GetText ($hTreeview2, _GUICtrlTreeView_GetSelection($hTreeview2))
   Else
	  $Skriptbaum_markiertes_Element_vor_Reload = ""
   Endif
;~ 	msgbox(0,"j",$FILE_CACHE[1])

   _GUICtrlTreeView_DeleteAll($hTreeView2)
   _GUICtrlTreeView_Add($hTreeview2, $hTreeview2, _Get_langstr(1036), 39, 39)
 _GUICtrlTreeView_EndUpdate($hTreeview2)

   _GUICtrlTreeView_BeginUpdate($hTreeview2)
	_GUICtrlTreeView_DeleteAll($hTreeView2)

	$hRoot2 = _GUICtrlTreeView_Add($hTreeview2, $hTreeview2, $rootname, 10, 10)
	$Skriptbaum_Projekt_root = _GUICtrlTreeView_Add($hTreeview2, $hTreeview2, _Get_langstr(1081), 39, 39)

	if $showfunctions = "true" then global $functiontree = _GUICtrlTreeView_AddChild($hTreeView2, $hRoot2, _Get_langstr(83))
	if $showglobalvariables = "true" then global $globalvariablestree = _GUICtrlTreeView_AddChild($hTreeView2, $hRoot2, _Get_langstr(84))
	if $showlocalvariables = "true" then global $localvariablestree = _GUICtrlTreeView_AddChild($hTreeView2, $hRoot2, _Get_langstr(416))
	if $showincludes = "true" then global $includestree = _GUICtrlTreeView_AddChild($hTreeView2, $hRoot2, _Get_langstr(324))
	if $showregions = "true" then global $regionstree = _GUICtrlTreeView_AddChild($hTreeView2, $hRoot2, _Get_langstr(433))
	if $showforms = "true" AND $Studiomodus = 1 then global $hroot_forms = _GUICtrlTreeView_AddChild($hTreeView2, $Skriptbaum_Projekt_root, _Get_langstr(323))



	;first build the RAW arrays
;~ 	$temp = $FILE_CACHE[$nr]
	$temp = Sci_GetText($SCE_EDITOR[$nr])
	if $autoit_editor_encoding = "2" then $temp= _ANSI2UNICODE($temp)
	$temp = StringReplace($temp, ", _" & @crlf, ",")
	$textarray = _StringSplitCRLF($temp)
	$old_prozent = 0
	for $i = 0 to UBound($textarray) - 1


		$prozent = ($i / (UBound($textarray) - 1)) * 100
		$prozent = Number($prozent)
		$prozent = int($prozent)
		if $prozent > 100 or $prozent < 0 then $prozent = 0

;~ 		if $old_prozent <> $prozent then _GUICtrlStatusBar_SetText($Status_bar, _Get_langstr(510)&" ("&$prozent&" %)")
		$old_prozent = $prozent
		if $textarray[$i] = "" then ContinueLoop
		if StringStripWS ($textarray[$i],3) = @TAB then ContinueLoop
		if StringStripWS ($textarray[$i],3) = @crlf then ContinueLoop
		if StringStripWS ($textarray[$i],3) = "#ce" then
			$Last_CE = 0
		endif
		if StringStripWS ($textarray[$i],3) = "#cs" then
			$Last_CE = 1
			ContinueLoop
		 endif
		if $Last_CE = 1 then ContinueLoop

		;funcs
		while StringInStr($textarray[$i], "func ")
			if not StringInStr($textarray[$i], "(") then exitloop
			if not StringInStr($textarray[$i], ")") AND NOT StringInStr($textarray[$i], "_") then exitloop
			if StringInStr($textarray[$i], ";") then ;falls auskommentiert
				if StringInStr($textarray[$i], ";") < StringInStr($textarray[$i], "func ") then exitloop
			endif
			$txt = StringTrimLeft($textarray[$i], stringinstr($textarray[$i], "func ") + 4)
			$txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, "(") + 1)
			$txt = StringStripWS($txt, 3)
			if StringInStr($txt,",") then exitloop
			if _Pruefe_Filter($txt) = "true" then exitloop
			if StringInStr($txt, "(") OR StringInStr($txt, ")") OR StringInStr($txt, "=") then exitloop
			_ArrayAdd($functions_Array, $txt)
			$UDF_Funcs_Keywoardstring = $UDF_Funcs_Keywoardstring&$txt&" "
			exitloop
		wend

		;globale variablen
		while StringInStr($textarray[$i], "global ")
			if not StringInStr($textarray[$i], "$") then exitloop
			if not StringInStr($textarray[$i], "global") then exitloop
			if StringInStr($textarray[$i], ";") then ;falls auskommentiert
				if StringInStr($textarray[$i], ";") < StringInStr($textarray[$i], "global ") then exitloop
				endif

			;lösche alles was sich nach dem ersten = Zeichen befindet
			$to_edit = $textarray[$i]
			if StringInStr($to_edit, "=") then  $to_edit = StringTrimRight($to_edit,(stringlen($to_edit)-StringInStr($to_edit,"="))+1)
			$to_edit = StringStripWS($to_edit, 3)
			if not StringInStr($to_edit, "global ") then exitloop

			;lösche alles was sich in Kalmmern befindet
			$to_edit = StringStripWS($to_edit, 3)
			while stringinstr($to_edit, "(") AND stringinstr($to_edit, ")")
				$to_remove = _StringBetween($to_edit, "(", ")")
				if $to_remove[0] = "" then exitloop
				for $r = 0 to UBound($to_remove) - 1
					$to_edit = StringReplace($to_edit, $to_remove[$r], "")
				next
			 wend
			 ;Und auch in Eckigen Klammern
			 while stringinstr($to_edit, "[") AND stringinstr($to_edit, "]")
				$to_remove = _StringBetween($to_edit, "[", "]")
				if $to_remove[0] = "" then exitloop
				for $r = 0 to UBound($to_remove) - 1
					$to_edit = StringReplace($to_edit, "["&$to_remove[$r]&"]", "")
				next
			 wend


			if $to_edit = "" then exitloop
			if $to_edit = @crlf then exitloop
			;Splitte beistriche
			$spliiter = StringSplit($to_edit, ",", 2)
			for $e = 0 to UBound($spliiter) - 1
				$txt = $spliiter[$e]
				$txt = StringReplace($txt, "const ", "")
				$txt = StringReplace($txt, "enum ", "")
				$txt = StringReplace($txt, "dim ", "")
				if not stringinstr($txt, "$") then ContinueLoop
				if stringinstr($txt, "global ") then $txt = StringTrimLeft($txt, stringinstr($txt, "global ") + 6)
				if stringinstr($txt, ";") then $txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, ";") + 1)
				if StringInStr($txt, "=") then $txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, "=") + 1)
				$txt = StringStripWS($txt, 3)
				if _Pruefe_Filter($txt) = "true" then exitloop
				if $txt <> "" AND StringTrimRight($txt, stringlen($txt) - 1) = "$" then _ArrayAdd($Globalvariables_Array, $txt)
			next
			exitloop
		wend

		;lokale variablen
		while StringInStr($textarray[$i], "local ")
			if not StringInStr($textarray[$i], "$") then exitloop
			if not StringInStr($textarray[$i], "local") then exitloop
			if StringInStr($textarray[$i], ";") then ;falls auskommentiert
				if StringInStr($textarray[$i], ";") < StringInStr($textarray[$i], "local ") then exitloop
				endif

			;lösche alles was sich nach dem ersten = Zeichen befindet
			$to_edit = $textarray[$i]
			if StringInStr($to_edit, "=") then  $to_edit = StringTrimRight($to_edit,(stringlen($to_edit)-StringInStr($to_edit,"="))+1)
			$to_edit = StringStripWS($to_edit, 3)
			if not StringInStr($to_edit, "local ") then exitloop

			;lösche alles was sich in Kalmmern befindet
			$to_edit = StringStripWS($to_edit, 3)
			while stringinstr($to_edit, "(") AND stringinstr($to_edit, ")")
				$to_remove = _StringBetween($to_edit, "(", ")")
				if $to_remove[0] = "" then exitloop
				for $r = 0 to UBound($to_remove) - 1
					$to_edit = StringReplace($to_edit, $to_remove[$r], "")
				next
			 wend
			  ;Und auch in Eckigen Klammern
			 while stringinstr($to_edit, "[") AND stringinstr($to_edit, "]")
				$to_remove = _StringBetween($to_edit, "[", "]")
				if $to_remove[0] = "" then exitloop
				for $r = 0 to UBound($to_remove) - 1
					$to_edit = StringReplace($to_edit, "["&$to_remove[$r]&"]", "")
				next
			 wend


			if $to_edit = "" then exitloop
			if $to_edit = @crlf then exitloop
			;Splitte beistriche
			$spliiter = StringSplit($to_edit, ",", 2)
			for $e = 0 to UBound($spliiter) - 1
				$txt = $spliiter[$e]
				$txt = StringReplace($txt, "const ", "")
				$txt = StringReplace($txt, "enum ", "")
				$txt = StringReplace($txt, "dim ", "")
				if not stringinstr($txt, "$") then ContinueLoop
				if stringinstr($txt, "local ") then $txt = StringTrimLeft($txt, stringinstr($txt, "local ") + 5)
				if stringinstr($txt, ";") then $txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, ";") + 1)
				if StringInStr($txt, "=") then $txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, "=") + 1)
				$txt = StringStripWS($txt, 3)
				if _Pruefe_Filter($txt) = "true" then exitloop
				if $txt <> "" AND StringTrimRight($txt, stringlen($txt) - 1) = "$" then _ArrayAdd($localvariables_Array, $txt)
			next
			exitloop
		wend

		;includes
		while StringInStr($textarray[$i], "#include")
			if not stringInStr($textarray[$i], ".") then exitloop
			if stringInStr($textarray[$i], "-once") then exitloop
			$txt = $textarray[$i]
			if StringInStr($txt, ";") then ;falls auskommentiert
				if StringInStr($txt, ";") < StringInStr($txt, "#include") then exitloop
			endif
			if stringInStr($txt, "<") then $txt = StringTrimleft($txt, stringinstr($txt, "<") - 1)
			if stringInStr($txt, "'") then $txt = StringTrimleft($txt, stringinstr($txt, "'") - 1)
			if stringInStr($txt, '"') then $txt = StringTrimleft($txt, stringinstr($txt, '"') - 1)
			if stringInStr($txt, ">") then $txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, ">"))
			if stringInStr($txt, '"') then $txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, '"', 0, -1))
			if stringInStr($txt, "'") then $txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, "'", 0, -1))
			$txt = StringStripWS($txt, 3)
			if stringInStr($txt, "(") then exitloop
			if stringInStr($txt, ")") then exitloop
			if $txt = "" then exitloop
			if $txt = " " then exitloop
			if _Pruefe_Filter($txt) = "true" then exitloop
			_ArrayAdd($includes_Array, $txt)
			exitloop
		wend

		;regions
		while StringInStr($textarray[$i], "#region ")
			if StringInStr($textarray[$i], ";") then ;falls auskommentiert
				if StringInStr($textarray[$i], ";") < StringInStr($textarray[$i], "#region ") then exitloop
			endif
			$txt = StringTrimLeft($textarray[$i], stringinstr($textarray[$i], "#region ") + 7)
			if StringInStr($txt, ";") then $txt = StringTrimright($txt, stringlen($txt) - stringinstr($txt, ";") + 1)
			$txt = StringStripWS($txt, 3)
			if StringInStr(StringStripWS($textarray[$i], 3), "#region ") > 1 then exitloop ;#region muss am anfang der Zeile stehen

			if $txt = "" then exitloop
			if $txt = " " then exitloop
			if _Pruefe_Filter($txt) = "true" then exitloop
			_ArrayAdd($regions_Array, $txt)
			exitloop
		wend

	next

	;Remove first line of the arrays
	_ArrayDelete($functions_Array, 0)
	_ArrayDelete($Globalvariables_Array, 0)
	_ArrayDelete($localvariables_Array, 0)
	_ArrayDelete($includes_Array, 0)
	_ArrayDelete($regions_Array, 0)
	_GUICtrlTreeView_BeginUpdate($hTreeview2)

	;---------------------------------------------------------------------------------------------------------------------------

	;Add items to Scripttree
	if $showfunctions = "true" AND IsArray($functions_Array) then
		$functions_Array = _Array_Remove_Duplicates_and_Count($functions_Array)
		if $Skriptbaum_Funcs_alphabetisch_sortieren = "true" then _ArraySort($functions_Array)
		for $x = 0 to UBound($functions_Array) - 1
			$item = _GUICtrlTreeView_AddChild($hTreeView2, $functiontree, $functions_Array[$x], 19, 19)
;~ 			if _Element_im_Skript_besitzt_Kommentar($functions_Array[$x],"func") = true then _GUICtrlTreeView_SetBold($hTreeView2, $item, True)
		next
	endif

	if $showglobalvariables = "true" AND IsArray($Globalvariables_Array) then
		$Globalvariables_Array = _Array_Remove_Duplicates_and_Count($Globalvariables_Array)
		_ArraySort($Globalvariables_Array)
		for $x = 0 to UBound($Globalvariables_Array) - 1
			$item = _GUICtrlTreeView_AddChild($hTreeView2, $globalvariablestree, $Globalvariables_Array[$x], 18, 18)
;~ 			if _Element_im_Skript_besitzt_Kommentar($Globalvariables_Array[$x],"global") = true then _GUICtrlTreeView_SetBold($hTreeView2, $item, True)
		next
	 endif


	if $showlocalvariables = "true" AND IsArray($localvariables_Array) then
		$localvariables_Array = _Array_Remove_Duplicates_and_Count($localvariables_Array)
		_ArraySort($localvariables_Array)
		for $x = 0 to UBound($localvariables_Array) - 1
			$item = _GUICtrlTreeView_AddChild($hTreeView2, $localvariablestree, $localvariables_Array[$x], 18, 18)
;~ 			if _Element_im_Skript_besitzt_Kommentar($localvariables_Array[$x],"local") = true then _GUICtrlTreeView_SetBold($hTreeView2, $item, True)
		next
	endif

	if $showincludes = "true" AND IsArray($includes_Array) then
		$includes_Array = _Array_Remove_Duplicates_and_Count($includes_Array)
		_ArraySort($includes_Array)
		for $x = 0 to UBound($includes_Array) - 1
			$item = _GUICtrlTreeView_AddChild($hTreeView2, $includestree, $includes_Array[$x], 38, 38)
;~ 			if _Element_im_Skript_besitzt_Kommentar($includes_Array[$x],"include") = true then _GUICtrlTreeView_SetBold($hTreeView2, $item, True)
		next
	endif

	if $showregions = "true" AND IsArray($regions_Array) then
		$regions_Array = _Array_Remove_Duplicates_and_Count($regions_Array)
		_ArraySort($regions_Array)
		for $x = 0 to UBound($regions_Array) - 1
			$item = _GUICtrlTreeView_AddChild($hTreeView2, $regionstree, $regions_Array[$x], 45, 45)
;~ 			if _Element_im_Skript_besitzt_Kommentar($regions_Array[$x],"region") = true then _GUICtrlTreeView_SetBold($hTreeView2, $item, True)
		next
	endif


	;Nur im Projektmodus
	if $showforms = "true" AND $Studiomodus = 1 then
		;List all Formhandles
		dim $ALL_CODE
		dim $tmp_CODE
		Dim $aRecords
		dim $str
		local $aList[90][90]
		$FILES = _Skripteditor_hole_Inludes($Offenes_Projekt&"\"&iniread($Pfad_zur_Project_ISN, "ISNAUTOITSTUDIO", "mainfile", "#ERROR#"),".isf")
		if not IsArray($FILES) then return
		For $x = 0 To $FILES[0] ;UBound($FILES)-1

			if FileExists($FILES[$X]) then
				$rea = iniread($FILES[$X], "gui", "handle", "#ERROR#")
				if $rea = "#ERROR#" then
					_Write_ISN_Debug_Console("Error while reading the GUI handle from an .isf file [" & StringReplace($FILES[$X],"\","\\") & "]", 3)
					ContinueLoop
				endif
				if $X > 89 then exitloop
				$aList[$X][0] = _Handle_mit_Dollar_zurueckgeben($rea)
				$aList[$X][1] = $FILES[$X]
			endif
		Next

		_ArraySort($aList)
		if UBound($aList, 1) - 1 > 0 then
			For $i = 0 to UBound($aList, 1) - 1 Step + 1
				if $aList[$i][0] = "const" then ContinueLoop
				if $aList[$i][0] = "" then ContinueLoop
				if _Pruefe_Filter($aList[$i][0]) = "true" then ContinueLoop
				local $hnd = _GUICtrlTreeView_AddChild($hTreeView2, $hroot_forms, $aList[$i][0], 12, 12)
;~ 				if IniRead ($Pfad_zur_Project_ISN, $aList[$i][0], "comment", "" ) <> "" then _GUICtrlTreeView_SetBold($hTreeView2, $hnd, True)

				if $loadcontrols = "true" then
					$varreaden = IniReadSectionNames($aList[$i][1])
					If @error Then
;~     MsgBox(4096, "", "Error while reading")
						_Write_ISN_Debug_Console("Error while reading handles from an .isf file [" & $aList[$i][1] & "]", 3)
					Else
						For $z = 1 To $varreaden[0]
							if $varreaden[$z] = "gui" then ContinueLoop
							$read = iniread($aList[$i][1], $varreaden[$z], "id", "")
							$type = iniread($aList[$i][1], $varreaden[$z], "type", "")
							if $read = "" AND $type <> "menu" then ContinueLoop
							if $type = "menu" Then
								;Füge ggf. erstelle Menüs hinzu
								$data = iniread($aList[$i][1], $varreaden[$z], "text", "")
								if $data = "" then ContinueLoop
								$Split = StringSplit($data,"[MBREAK]",3)
								if IsArray($Split) then
								for $j = 0 to ubound($Split)-1
								if _Pruefe_Filter($Split[$j]) = "true" then ContinueLoop
								if StringInStr($Split[$j],"handle=") then _GUICtrlTreeView_AddChild($hTreeView2, $hnd, _Handle_mit_Dollar_zurueckgeben(StringReplace($Split[$j],"handle=",""))& " (" & $type & ")", _return_formicon($type), _return_formicon($type))
								next
								endif

							else
							if _Pruefe_Filter("$" & $read) = "true" then ContinueLoop
							 _GUICtrlTreeView_AddChild($hTreeView2, $hnd, _Handle_mit_Dollar_zurueckgeben($read) & " (" & $type & ")", _return_formicon($type), _return_formicon($type))
							endif

						Next
					EndIf
				endif

			Next
		EndIf
	endif

	_GUICtrlTreeView_ExpandOneLevel($hTreeView2, $hRoot2)
	_GUICtrlTreeView_ExpandOneLevel($hTreeView2, $Skriptbaum_Projekt_root)
	if $showfunctions = "true" AND $expandfunctions = "true" then _GUICtrlTreeView_ExpandOneLevel($hTreeView2, $functiontree)
	if $showglobalvariables = "true" AND $expandglobalvariables = "true" then _GUICtrlTreeView_ExpandOneLevel($hTreeView2, $globalvariablestree)
	if $showlocalvariables = "true" AND $expandlocalvariables = "true" then _GUICtrlTreeView_ExpandOneLevel($hTreeView2, $localvariablestree)
	if $showincludes = "true" AND $expandincludes = "true" then _GUICtrlTreeView_ExpandOneLevel($hTreeView2, $includestree)
	if $showregions = "true" AND $expandregions = "true" then _GUICtrlTreeView_ExpandOneLevel($hTreeView2, $regionstree)
	if $showforms = "true" AND $expandforms = "true" then _GUICtrlTreeView_ExpandOneLevel($hTreeView2, $hroot_forms)
	_Rebuild_Scripttree()
	_GUICtrlTreeView_EndUpdate($hTreeview2)
	 GUICtrlSetState($Skriptbaum_Aktualisieren_Button,$GUI_ENABLE)

	 ;Versuche zuletzt markiertes Elment wieder zu markieren
	 if $Skriptbaum_markiertes_Element_vor_Reload <> "" then
		$find_result = _GUICtrlTreeView_FindItem ( $hTreeview2, $Skriptbaum_markiertes_Element_vor_Reload)
		 if $find_result <> 0 then _GUICtrlTreeView_SelectItem ( $hTreeview2, $find_result)
	 Endif
EndFunc

Func _Array_Remove_Duplicates_and_Count(ByRef $aData, $mode=1, $sepChar=",") ; mode: 1 = 1D Rückgabe , 2 = 2D Rückgabe

    If Not IsArray($aData) Then Return -1 ; wichtig: bitte Rückgabe dieser Funktion prüfen bevor weiter gearbeitet wird...

    Local $aNew[ubound($aData)][2] ; für 2D Rückgabe // geändert: array wird am schluß neu dimensioniert!
    Local $aNew1D[1] ; für 1D Rückgabe
    Local $sTemp=$sepChar ; string verkettung des ergebnis arrays für schnelle unique prüfung
    Local $j=0 ; zahl der unique treffer


    ; Anmerkung: Der Vergleich sollt vielleicht doch nicht case sensitiv sein, da ansonsten gleichnamige Variablen mit anderer Schreibweise nicht erkannt werden, daher wieder auf not casesensitiv geändert, ist aber ein wenig langsamer...
    For $i=0 To UBound($aData)-1
        If StringInStr($sTemp,$sepChar & $aData[$i] & $sepChar,0,-1) Then ; stringprüfung arbeitet schneller als große arrays zu durchlaufen und "viele" strings zu vergleichen // geändert: sepchar muss nun ganze Variable umschließen
            For $k=0 To UBound($aNew)-1 ; bei bereits vorhandenen einträgen müssen wir zwangsweise die bisherigen suchergebnisse durchlaufen um den korrekten index zu finden
                If $aNew[$k][0]=$aData[$i] Then
                    $aNew[$k][1]+=1
                    ExitLoop
                EndIf
            Next
        Else
            $aNew[$j][0] = $aData[$i]
            $aNew[$j][1] = 1
            $sTemp &= $aData[$i] & $sepChar
            $j += 1
            ;ReDim $aNew[$j+1][2] ; geändert: wäre lahm, wurde im thread denke ich damals auch erwähnt...
        EndIf
    Next
    ReDim $aNew[$j][2] ; geändert: array wird erst zum schluß auf richtige Größe gebracht, performanter....

    ;If UBound($aNew) > 1 Then ReDim $aNew[UBound($aNew)-1][2]

    ; sofern zwingend ein 1D Array als Ausgabe benötigt wird muss das neue Array noch einmal durchlaufen werden:
    if $mode = 1 Then
        ReDim $aNew1D[UBound($aNew)]
        For $i=0 To UBound($aNew)-1
            If $aNew[$i][1] > 1 Then
                $aNew1D[$i]=$aNew[$i][0] & "  { " & $aNew[$i][1] & "x }"
            Else
                $aNew1D[$i]=$aNew[$i][0]
            EndIf
        Next
        $aNew=$aNew1D
    EndIf

    Return $aNew
EndFunc




func _Rebuild_Scripttree_func($child)
   	if $child = $globalvariablestree then return ;Im Global nicht weitersuchen da dort eh nichts aufgeklappt werden kann
   	if $child = $localvariablestree then return ;Im local nicht weitersuchen da dort eh nichts aufgeklappt werden kann
   	if $child = $functiontree then return ;Im Func  nicht weitersuchen da dort eh nichts aufgeklappt werden kann
   	if $child = $regionstree then return ;Im Region  nicht weitersuchen da dort eh nichts aufgeklappt werden kann
   	if $child = $includestree then return ;Im Includes nicht weitersuchen da dort eh nichts aufgeklappt werden kann
	for $x = 0 to _GUICtrlTreeView_GetChildCount($hTreeView2, $child)
		$res = _ArraySearch($Scripttree_Treeview_Expanded_Array, _GUICtrlTreeView_GetText($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x)))
		if $res <> -1 then
			if _GUICtrlTreeView_GetChildren($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x)) = True Then
				_GUICtrlTreeView_ExpandOneLevel($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x))
				if _GUICtrlTreeView_GetText($hTreeView2, $hRoot2) = _GUICtrlTreeView_GetText($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x)) then return
				_Rebuild_Scripttree_func(_GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x))
			endif
		endif
	next
EndFunc

func _Rebuild_Scripttree()
	if $hidefunctionstree = "true" then return
;~ 	_ArrayDisplay($Scripttree_Treeview_Expanded_Array)
	_Rebuild_Scripttree_func($hRoot2)
EndFunc

func _Save_Scripttree_scan($child)
    if $child = $globalvariablestree then return ;Im Global nicht weitersuchen da dort eh nichts aufgeklappt werden kann
   	if $child = $localvariablestree then return ;Im local nicht weitersuchen da dort eh nichts aufgeklappt werden kann
   	if $child = $functiontree then return ;Im Func  nicht weitersuchen da dort eh nichts aufgeklappt werden kann
   	if $child = $regionstree then return ;Im Region  nicht weitersuchen da dort eh nichts aufgeklappt werden kann
   	if $child = $includestree then return ;Im Includes nicht weitersuchen da dort eh nichts aufgeklappt werden kann
	Local $x = 0
	for $x = 0 to _GUICtrlTreeView_GetChildCount($hTreeView2, $child)
		if _GUICtrlTreeView_GetExpanded($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x)) = true then
			if _GUICtrlTreeView_GetText($hTreeView2, $hRoot2) = _GUICtrlTreeView_GetText($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x)) then ContinueLoop
			$Scripttree_Treeview_Expanded_Array[$found] = _GUICtrlTreeView_GetText($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x))
			$found = $found + 1
			if _GUICtrlTreeView_GetChildren($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x)) = True Then
				if _GUICtrlTreeView_GetText($hTreeView2, $hRoot2) = _GUICtrlTreeView_GetText($hTreeView2, _GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x)) then return
				_Save_Scripttree_scan(_GUICtrlTreeView_GetItemByIndex($hTreeView2, $child, $x))
			endif
		endif
	next
;~ 		_ArrayDisplay($Scripttree_Treeview_Expanded_Array)
EndFunc

func _Save_Scripttree()
	if $hidefunctionstree = "true" then return
	_Clear_Scripttree_Rebuild()
	$found = 0
	_Save_Scripttree_scan($hRoot2)
endfunc
