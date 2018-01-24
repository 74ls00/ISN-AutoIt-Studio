Global $CurZipSize = 0
Global $UnCompSize = 0


func _Show_Projectman()
_GUICtrlListView_DeleteAllItems(guictrlgethandle($Projektverwaltung_Projektdetails_Listview))
guictrlsetdata($Found_Projects,_Get_langstr(36))
GUISetState(@SW_SHOW,$projectmanager)
GUISetState(@SW_HIDE,$Welcome_GUI)
ScanforProjects_Projectman(_ISN_Variablen_aufloesen($Projectfolder))
ScanforVorlagen(_ISN_Variablen_aufloesen($templatefolder))
endfunc

func _HIDE_Projectman()
GUISetState(@SW_SHOW,$Welcome_GUI)
GUISetState(@SW_HIDE,$projectmanager)
_Load_Projectlist()
endfunc

;Suche nach Projekten
Func ScanforProjects_Projectman($SourceFolder)
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath
	$Count = 0
	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($Projects_Listview_projectman))
	_GUICtrlListView_BeginUpdate($Projects_Listview_projectman)
	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf
		$File = FileFindNextFile($Search)
		If @error Then ExitLoop
		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)
		If StringInStr($FileAttributes,"D") Then
			if FileExists(_Finde_Projektdatei($FullFilePath)) then
			$tmp_isn_file = _Finde_Projektdatei($FullFilePath)
			$tmp = IniReadSection($tmp_isn_file, "ISNAUTOITSTUDIO")
			if not @error then
			$Count = $Count+1
			_GUICtrlListView_AddItem($Projects_Listview_projectman,iniread($tmp_isn_file,"ISNAUTOITSTUDIO","name","#ERROR#"), 39)
			_GUICtrlListView_AddSubItem($Projects_Listview_projectman,_GUICtrlListView_GetItemCount($Projects_Listview_projectman)-1,iniread($tmp_isn_file,"ISNAUTOITSTUDIO","author",""), 1)
			_GUICtrlListView_AddSubItem($Projects_Listview_projectman,_GUICtrlListView_GetItemCount($Projects_Listview_projectman)-1,iniread($tmp_isn_file,"ISNAUTOITSTUDIO","comment",""), 2)
			$folder = stringtrimleft($FullFilePath,stringinstr($FullFilePath,"\",0,-1))
			_GUICtrlListView_AddSubItem($Projects_Listview_projectman,_GUICtrlListView_GetItemCount($Projects_Listview_projectman)-1,$folder, 3)
		endif
		endif
		EndIf
	WEnd
	$Descending = false
	 _GUICtrlListView_SimpleSort($Projects_Listview_projectman, $Descending, 0)
	 _GUICtrlListView_SetItemSelected($Projects_Listview_projectman,-1, false, False)
	_GUICtrlListView_EndUpdate($Projects_Listview_projectman)
guictrlsetdata($Found_Projects,$Count&" "&_Get_langstr(366))
EndFunc

;Suche nach Vrolagen
Func ScanforVorlagen($SourceFolder)
	Local $Search
	Local $File
	Local $FileAttributes
	Local $FullFilePath
	$Count = 0
	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($vorlagen_Listview_projectman))
	_GUICtrlListView_BeginUpdate($vorlagen_Listview_projectman)
	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf
		$File = FileFindNextFile($Search)
		If @error Then ExitLoop
		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)
		If StringInStr($FileAttributes,"D") Then
			if FileExists(_Finde_Projektdatei($FullFilePath)) then
			$tmp_isn_file = _Finde_Projektdatei($FullFilePath)
			$Count = $Count+1
			_GUICtrlListView_AddItem($vorlagen_Listview_projectman,iniread($tmp_isn_file,"ISNAUTOITSTUDIO","name","#ERROR#"), 10)
			$folder = stringtrimleft($FullFilePath,stringinstr($FullFilePath,"\",0,-1))
			_GUICtrlListView_AddSubItem($vorlagen_Listview_projectman,_GUICtrlListView_GetItemCount($vorlagen_Listview_projectman)-1,iniread($tmp_isn_file,"ISNAUTOITSTUDIO","author",""), 1)
			_GUICtrlListView_AddSubItem($vorlagen_Listview_projectman,_GUICtrlListView_GetItemCount($vorlagen_Listview_projectman)-1,$folder, 2)
			endif
		EndIf
	WEnd
	$Descending = false
	_GUICtrlListView_SimpleSort($vorlagen_Listview_projectman, $Descending, 0)
	_GUICtrlListView_SetItemSelected($vorlagen_Listview_projectman,-1, false, False)
	_GUICtrlListView_EndUpdate($vorlagen_Listview_projectman)
guictrlsetdata($Found_Vorlagen,$Count&" "&_Get_langstr(377))
EndFunc


;Lade Details vom Projekt sobald darauf geklickt wird
func _Load_Details_Manager()
AdlibUnRegister("_Load_Details_Manager")
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then return
_GUICtrlListView_BeginUpdate($Projektverwaltung_Projektdetails_Listview)
_GUICtrlListView_DeleteAllItems(guictrlgethandle($Projektverwaltung_Projektdetails_Listview))


$isnpath = _Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)))
$isndatei_name = StringTrimLeft($isnpath,StringInStr($isnpath,"\",0,-1))
$path = stringtrimright($isnpath,stringlen($isnpath)-stringinstr($isnpath,"\",0,-1)+1)
$data = ""
$sizeF = DirGetSize($path,1)
	$files = $sizeF[1]
	$folders = $sizeF[2]
	$sizeF[0] = Round($sizeF[0] / 1024 )
	if $sizeF[0] > 1024 then
		$sizeF[0] = Round($sizeF[0] / 1024)&" MB"
	else
		$sizeF[0] = $sizeF[0]&" KB"
endif
local $timer, $Secs, $Mins, $Hour, $Time
$time = iniread($isnpath,"ISNAUTOITSTUDIO","time","0")
_TicksToTime($time, $Hour, $Mins, $Secs)

$var = IniReadSectionNames($isnpath)
$Anzahl_Makros_im_Projekt = 0
If @error Then
    MsgBox(4096, "", "Error reading .isn file!")
Else
    For $i = 1 To $var[0]
        if StringInStr($var[$i],"#isnrule#") then
			$Anzahl_Makros_im_Projekt = $Anzahl_Makros_im_Projekt+1
		endif
    Next
EndIf



;Projektname
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(368), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","name",""), 1)

;Version
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(217), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","version",""), 1)

;Name der Hauptdatei
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(16), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","mainfile",""), 1)

;Name der Projektdatei
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(1116), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, $isndatei_name, 1)

;Kommentar
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(133), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","comment",""), 1)

;Author
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(369), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","author",""), 1)

;Erstellt am
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(171), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","date",""), 1)

;Erstellt mit Studioversion
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(224), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","studioversion",""), 1)

;Größe
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(220), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, $sizeF[0], 1)

;Anzahl Dateien/Ordner
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(221), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, "("&$files&" "&_Get_langstr(222)&" / "&$folders&" "&_Get_langstr(223)&")", 1)

;Zeit
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(225), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, $Hour&"h "&$Mins&"m "&$Secs&"s", 1)

;Zuletzt geöffnet
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(370), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","lastopendate",""), 1)

;Wie oft geöffnet
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(397), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, iniread($isnpath,"ISNAUTOITSTUDIO","projectopened","")&"x", 1)

;Makros Anzahl
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(707), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, $Anzahl_Makros_im_Projekt, 1)

;Speicherort
_GUICtrlListView_AddItem($Projektverwaltung_Projektdetails_Listview, _Get_langstr(391), 0)
_GUICtrlListView_AddSubItem($Projektverwaltung_Projektdetails_Listview, _GUICtrlListView_GetItemCount($Projektverwaltung_Projektdetails_Listview) - 1, "..\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3), 1)

_GUICtrlListView_EndUpdate($Projektverwaltung_Projektdetails_Listview)
endfunc


;Kopie von Projekt erstellen
func _Copy_project()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf
$isnpath = _Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)))
$path = stringtrimright($isnpath,stringlen($isnpath)-stringinstr($isnpath,"\",0,-1)+1)
$answer = InputBox(_Get_langstr(48), _Get_langstr(372), _GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),0)&" ("&_Get_langstr(373)&")","",Default,Default,Default,Default,0,$projectmanager)
if @error then Return
if FileExists(_ISN_Variablen_aufloesen($Projectfolder&"\"&$answer)) Then
msgbox(262144+16,_Get_langstr(25),_Get_langstr(27),0,$projectmanager)
return
EndIf
$answer = StringReplace($answer,"?","")
$answer = StringReplace($answer,"=","")
$answer = StringReplace($answer,".","")
$answer = StringReplace($answer,",","")
$answer = StringReplace($answer,"\","")
$answer = StringReplace($answer,"/","")
$answer = StringReplace($answer,'"',"")
$answer = StringReplace($answer,"<","")
$answer = StringReplace($answer,">","")
$answer = StringReplace($answer,"|","")
FileChangeDir(@scriptdir)
_FileOperationProgress($path&"\*.*", _ISN_Variablen_aufloesen($Projectfolder&"\"&$answer), 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
If @extended == 1 Then ;ERROR
DirRemove(_ISN_Variablen_aufloesen($Projectfolder&"\"&$answer),1) ;cleanup
Return
EndIf
iniwrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&$answer)),"ISNAUTOITSTUDIO","name",$answer)
iniwrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&$answer)),"ISNAUTOITSTUDIO","date",@MDAY&"."&@mon&"."&@YEAR)
_Show_Projectman()
msgbox(262144+64,_Get_langstr(61),_Get_langstr(374),0,$projectmanager)
endfunc




;Öffne Projekt vom Projektmanager aus
func _Try_to_Open_projectman()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(29),0,$projectmanager)
	Return
EndIf
$PID_Read = iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","opened","")
if ProcessExists($PID_Read) Then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(331),0,$projectmanager)
	Return
endif
_Load_Project_by_Foldername(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)))
EndFunc






;Hauptdatei umbenennen
func _rename_mainfile()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf
$isnpath = _Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)))
$path = stringtrimright($isnpath,stringlen($isnpath)-stringinstr($isnpath,"\",0,-1)+1)
$answer = InputBox(_Get_langstr(48), _Get_langstr(375), iniread($isnpath,"ISNAUTOITSTUDIO","mainfile",""),"",Default,Default,Default,Default,0,$projectmanager)
if $answer = "" then return
if @error then Return
if $answer == iniread($isnpath,"ISNAUTOITSTUDIO","mainfile","") then return
$answer = StringReplace($answer,"?","")
$answer = StringReplace($answer,"=","")
$answer = StringReplace($answer,",","")
$answer = StringReplace($answer,"\","")
$answer = StringReplace($answer,"/","")
$answer = StringReplace($answer,'"',"")
$answer = StringReplace($answer,"<","")
$answer = StringReplace($answer,">","")
$answer = StringReplace($answer,"|","")
FileChangeDir(@scriptdir)
FileMove(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)&"\"&iniread($isnpath,"ISNAUTOITSTUDIO","mainfile","")),_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)&"\"&$answer),9)
iniwrite($isnpath,"ISNAUTOITSTUDIO","mainfile",$answer)
_Show_Projectman()
msgbox(262144+64,_Get_langstr(61),_Get_langstr(376),0,$projectmanager)
endfunc


;Löscht markierte Vorlage
func _delete_template()
if _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(380),0,$projectmanager)
	Return
EndIf
if _GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2) = "default" then ;Schütze default Vorlage
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(379),0,$projectmanager)
	Return
EndIf
$answer = msgbox(262144+32+4,_Get_langstr(48),_Get_langstr(382)&" "&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),0),0,$projectmanager)
if $answer = 6 then
DirRemove(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2)),1)
_Show_Projectman()
endif
EndFunc


;Vorlage umbenennen
func _Rename_template()
if _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(380),0,$projectmanager)
	Return
EndIf
if _GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2) = "default" then ;Schütze default Vorlage
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(720),0,$projectmanager)
	Return
EndIf

$var = InputBox(_Get_langstr(721),_Get_langstr(721),iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2))),"ISNAUTOITSTUDIO","name",""),"",200,150,default,default,-1,$projectmanager)
if $var = "" then return
if @error = 0 then
if $var = iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2))),"ISNAUTOITSTUDIO","name","") then Return
IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2))),"ISNAUTOITSTUDIO","name",$var)
_Show_Projectman()
endif
EndFunc


;Vorlage Autor ändern
func _Rename_autor_template()
if _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(380),0,$projectmanager)
	Return
EndIf

$var = InputBox(_Get_langstr(229),_Get_langstr(229),iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2))),"ISNAUTOITSTUDIO","author",""),"",200,150,default,default,-1,$projectmanager)
if @error = 0 then
if $var = iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2))),"ISNAUTOITSTUDIO","author","") then Return
IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2))),"ISNAUTOITSTUDIO","author",$var)
_Show_Projectman()
endif
EndFunc



;Vorlage im Windows Explorer anzeigen
func _Projektverwaltung_Zeige_Vorlage_im_Windows_Explorer()
if _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(380),0,$projectmanager)
	Return
EndIf

ShellExecute("explorer.exe",FileGetShortName(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2))))
EndFunc



;Öffne Projekt vom Projektmanager aus
func _Try_to_Open_template()
if _GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(380),0,$projectmanager)
	Return
EndIf
$PID_Read = iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2))),"ISNAUTOITSTUDIO","opened","")
if ProcessExists($PID_Read) Then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(331),0,$projectmanager)
	Return
endif
$Templatemode = 1
_show_Loading(_Get_langstr(385),_Get_langstr(23))
GUISetState(@SW_HIDE,$projectmanager)
guictrlsetstate($HD_Logo,$GUI_HIDE)
_Write_log(_Get_langstr(385)&"("&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),0)&")","000000","true","true")
_Loading_Progress(30)
_Load_Project(_ISN_Variablen_aufloesen($templatefolder&"\"&_GUICtrlListView_GetItemText($vorlagen_Listview_projectman,_GUICtrlListView_GetSelectionMark($vorlagen_Listview_projectman),2)))
_Loading_Progress(100)
_GUICtrlTreeView_ExpandOneLevel($hTreeView, $hroot)
_Check_tabs_for_changes()
IniWrite($Pfad_zur_Project_ISN,"ISNAUTOITSTUDIO","opened",@AutoItPID)
GUISetState(@SW_ENABLE,$StudioFenster)
_Hide_Loading()

sleep(200)
_Show_Warning("confirmtemplate",513,_Get_langstr(383),_Get_langstr(384),_Get_langstr(7))
EndFunc

;Kommentar ändern
func _Rename_Comment_manager()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf

$var = InputBox(_Get_langstr(231),_Get_langstr(231),iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","comment",""),"",200,150,default,default,-1,$projectmanager)
if @error = 0 then
if $var = iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","comment","") then Return
IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","comment",$var)
msgbox(262144+64,_Get_langstr(178),_Get_langstr(232),0,$projectmanager)
_Show_Projectman()
endif
EndFunc


;Projektnamen
func _Rename_project_manager()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf

$var = InputBox(_Get_langstr(226),_Get_langstr(226),iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","name",""),"",200,150,default,default,-1,$projectmanager)
if $var = "" then return
if @error = 0 then
if $var = iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","name","") then Return
		$var=StringReplace($var,"|","")
		$var=StringReplace($var,"?","")
		$var=StringReplace($var,"*","")
		$var=StringReplace($var,"\","")
		$var=StringReplace($var,"/","")
		$var=StringReplace($var,'"',"")
		$var=StringReplace($var,"'","")
		if $var = "" then return
		$var2 = msgbox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(804), 0, $projectmanager)

IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","name",$var)
if $var2 = 6 Then
		;Projektordner umbenennen
		if FileExists(_ISN_Variablen_aufloesen($Projectfolder&"\"&$var)) Then
			if _ISN_Variablen_aufloesen($Projectfolder&"\"&$var) <> _ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)) then  msgbox(262144 + 48, _Get_langstr(25), _Get_langstr(805), 0, $projectmanager)
		else
DirMove (_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)), _ISN_Variablen_aufloesen($Projectfolder&"\"&$var), 0 )
		endif
endif
msgbox(262144+64,_Get_langstr(178),_Get_langstr(392),0,$projectmanager)
_Show_Projectman()
endif
EndFunc


;Projektnamen
func _Rename_author_manager()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf

$var = InputBox(_Get_langstr(229),_Get_langstr(229),iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","author",""),"",200,150,default,default,-1,$projectmanager)
if @error = 0 then
if $var = iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","author","") then Return
IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","author",$var)
msgbox(262144+64,_Get_langstr(178),_Get_langstr(230),0,$projectmanager)
_Show_Projectman()
endif
EndFunc


;Projektversion
func _Rename_version_manager()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf

$var = InputBox(_Get_langstr(233),_Get_langstr(233),iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","version",""),"",200,150,default,default,-1,$projectmanager)
if @error = 0 then
if $var = iniread(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","version","") then Return
IniWrite(_Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))),"ISNAUTOITSTUDIO","version",$var)
msgbox(262144+64,_Get_langstr(178),_Get_langstr(234),0,$projectmanager)
_Show_Projectman()
endif
EndFunc

func _Show_new_Template()
	guictrlsetdata($INPUT_VORLAGENAME,"")
	guictrlsetdata($INPUT_VORLAGEAUTHOR,"")
	GUISetState(@SW_SHOW,$TemplateNEU)
	GUISetState(@SW_DISABLE,$projectmanager)
endfunc

func _hide_new_Template()
	GUISetState(@SW_ENABLE,$projectmanager)
	GUISetState(@SW_hide,$TemplateNEU)
endfunc


func _Create_Template()
if guictrlread($INPUT_VORLAGENAME) = "" then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(395),0,$TemplateNEU)
	_Input_Error_FX($INPUT_VORLAGENAME)
	Return
EndIf

$i = guictrlread($INPUT_VORLAGENAME)
if stringinstr($i,"\") OR stringinstr($i,"/") OR stringinstr($i,"?") OR stringinstr($i,":") OR stringinstr($i,"*") OR stringinstr($i,"|") or stringinstr($i,"<") or stringinstr($i,">") or stringinstr($i,"'") or stringinstr($i,'"') then
msgbox(262144+16,_Get_langstr(25),_Get_langstr(396)&@crlf&_Get_langstr(389),0,$TemplateNEU)
Return
EndIf

if guictrlread($INPUT_VORLAGENAME) = "default" then Return
_hide_new_Template()
DirCreate(_ISN_Variablen_aufloesen($templatefolder&"\"&guictrlread($INPUT_VORLAGENAME)))
_Leere_UTF16_Datei_erstellen(_ISN_Variablen_aufloesen($templatefolder&"\"&guictrlread($INPUT_VORLAGENAME)&"\project.isn"))
iniwrite(_ISN_Variablen_aufloesen($templatefolder&"\"&guictrlread($INPUT_VORLAGENAME)&"\project.isn"),"ISNAUTOITSTUDIO","name",guictrlread($INPUT_VORLAGEname))
iniwrite(_ISN_Variablen_aufloesen($templatefolder&"\"&guictrlread($INPUT_VORLAGENAME)&"\project.isn"),"ISNAUTOITSTUDIO","author",guictrlread($INPUT_VORLAGEAUTHOR))
iniwrite(_ISN_Variablen_aufloesen($templatefolder&"\"&guictrlread($INPUT_VORLAGENAME)&"\project.isn"),"ISNAUTOITSTUDIO","mainfile",guictrlread($INPUT_VORLAGEname)&".au3")
_FileCreate(_ISN_Variablen_aufloesen($templatefolder&"\"&guictrlread($INPUT_VORLAGENAME)&"\"&guictrlread($INPUT_VORLAGEname)&".au3"))

_Show_Projectman()
endfunc

func _Export_to_ISP()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf

$line = FileSaveDialog (_Get_langstr(470), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Compressed ISN AutoIt Studio Project (*.isp)" , 18, _GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),0), $projectmanager)
if $line = "" then Return
if @Error > 0 then return

$CurZipSize = 0
$UnCompSize = DirGetSize(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)))
if not StringInStr($line,".isp") then $line=$line&".isp"
if FileExists($line) then FileDelete($line)
GUISetState(@SW_disable,$projectmanager)


Global $RootDir = DllStructCreate("char[256]")
DllStructSetData($RootDir, 1, _ISN_Variablen_aufloesen($Projectfolder))

Global $TempDir = DllStructCreate("char[256]")
DllStructSetData($TempDir, 1, @TempDir)

Global $ZPOPT = DllStructCreate("ptr Date;ptr szRootDir;ptr szTempDir;int fTemp;int fSuffix;int fEncrypt;int fSystem;" & _
								"int fVolume;int fExtra;int fNoDirEntries;int fExcludeDate;int fIncludeDate;int fVerbose;" & _
								"int fQuiet;int fCRLFLF;int fLFCRLF;int fJunkDir;int fGrow;int fForce;int fMove;" & _
								"int fDeleteEntries;int fUpdate;int fFreshen;int fJunkSFX;int fLatestTime;int fComment;" & _
								"int fOffsets;int fPrivilege;int fEncryption;int fRecurse;int fRepair;char fLevel[2]")

DllStructSetData($ZPOPT, "szRootDir", DllStructGetPtr($RootDir))
DllStructSetData($ZPOPT, "szTempDir", DllStructGetPtr($TempDir))
DllStructSetData($ZPOPT, "fTemp", 0)
DllStructSetData($ZPOPT, "fVolume", 0)
DllStructSetData($ZPOPT, "fExtra", 0)
DllStructSetData($ZPOPT, "fVerbose", 1)
DllStructSetData($ZPOPT, "fQuiet", 0)
DllStructSetData($ZPOPT, "fCRLFLF", 0)
DllStructSetData($ZPOPT, "fLFCRLF", 0)
DllStructSetData($ZPOPT, "fGrow", 0)
DllStructSetData($ZPOPT, "fForce", 0)
DllStructSetData($ZPOPT, "fDeleteEntries", 0)
DllStructSetData($ZPOPT, "fJunkSFX", 0)
DllStructSetData($ZPOPT, "fOffsets", 0)
DllStructSetData($ZPOPT, "fRepair", 0)

_Zip_Init("_ZIPPrint", "_ZIPPassword", "_ZIPComment", "_ZIPProgress")
$res = msgbox(262144+4+32,_Get_langstr(48),_Get_langstr(472),0,$projectmanager)
if $res = 6 then
_ZIP_SetOptions(0,1,1,0,0,0,0,0,0,0,0,0,1,1,9)
else
_ZIP_SetOptions(0,0,1,0,0,0,0,0,0,0,0,0,1,1,9)
endif
_show_Loading(_Get_langstr(470),_Get_langstr(23))
_Loading_Progress(10)
$path = _ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)&"\*.*")
$result = _ZIP_Archive($line, $path)
_Loading_Progress(100)
_GUICtrlStatusBar_SetText ($Status_bar, "")
sleep(100)
GUISetState(@SW_ENABLE,$projectmanager)
_Hide_Loading()
FileChangeDir (@scriptdir)
if $result = 1 then msgbox(262144+64,_Get_langstr(61),_Get_langstr(164),0,$projectmanager)
EndFunc








func _Import_project($path="")
if not IsDeclared("path") then $path=""
if $path = "" Then
$var = FileOpenDialog(_Get_langstr(187), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "ISN AutoIt Studio Projects (*.isp;*isn)", 1 + 2+4,"",$projectmanager)
FileChangeDir (@scriptdir)
If @error Then	return
if $var = "" then return
Else
$var = $path
EndIf

GUISetState(@SW_disable,$projectmanager)
_show_Loading(_Get_langstr(475),_Get_langstr(23))



$randomid = random(1,2000,1)
DirCreate($Arbeitsverzeichnis& "\data\Cache\import"&$randomid)
_Loading_Progress(100)

$pathtoisnfile = ""
$folderpath = ""
$foldername= ""
if stringinstr($var,".isp") then
$CurZipSize = 0
_UnZip_Init("_UnZIP_PrintFunc", "UnZIP_ReplaceFunc", "_UnZIP_PasswordFunc", "_UnZIP_SendAppMsgFunc", "_UnZIP_ServiceFunc")
_UnZIP_SetOptions()
$result = _UnZIP_Unzip($var,$Arbeitsverzeichnis & "\data\Cache\import"&$randomid)
$search = FileFindFirstFile($Arbeitsverzeichnis& "\data\Cache\import"&$randomid&"\*.*")
$file = FileFindNextFile($search)

$pathtoisnfile = _Finde_Projektdatei($Arbeitsverzeichnis& "\data\Cache\import"&$randomid&"\"&$file)
$folderpath = $Arbeitsverzeichnis& "\data\Cache\import"&$randomid&"\"&$file
$foldername= $file
$temp = IniReadSection($pathtoisnfile, "ISNAUTOITSTUDIO")
if @error Then
msgbox(262144+16,_Get_langstr(25),_Get_langstr(476),0,$projectmanager)
_GUICtrlStatusBar_SetText ($Status_bar, "")
DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
GUISetState(@SW_ENABLE,$projectmanager)
_Hide_Loading()
return
EndIf
Else ;isn file
$pathtoisnfile = $var
$folderpath = StringTrimRight($var,StringLen($var)-StringInStr($var,"\",0,-1)+1)
$foldername= stringtrimleft($folderpath,stringinstr($folderpath,"\",0,-1))
$temp = IniReadSection($pathtoisnfile, "ISNAUTOITSTUDIO")
if @error Then
msgbox(262144+16,_Get_langstr(25),_Get_langstr(476),0,$projectmanager)
_GUICtrlStatusBar_SetText ($Status_bar, "")
DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
GUISetState(@SW_ENABLE,$projectmanager)
_Hide_Loading()
return
EndIf
EndIf



$answer = msgbox(262144+32+4,_Get_langstr(48),_Get_langstr(477)&@crlf&@crlf&_Get_langstr(5)&" "& _
iniread(_Finde_Projektdatei($folderpath),"ISNAUTOITSTUDIO","name","#ERROR#")&@crlf& _
_Get_langstr(18)&" "&iniread(_Finde_Projektdatei($folderpath),"ISNAUTOITSTUDIO","author","#ERROR#")&@crlf& _
_Get_langstr(171)&" "&iniread(_Finde_Projektdatei($folderpath),"ISNAUTOITSTUDIO","date","#ERROR#")&@crlf& _
_Get_langstr(217)&" "&iniread(_Finde_Projektdatei($folderpath),"ISNAUTOITSTUDIO","version","")&@crlf& _
_Get_langstr(17)&" "&iniread(_Finde_Projektdatei($folderpath),"ISNAUTOITSTUDIO","comment","#ERROR#")&@crlf,0,$projectmanager)
if $answer = 7 Then
DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
_GUICtrlStatusBar_SetText ($Status_bar, "")
GUISetState(@SW_ENABLE,$projectmanager)
_Hide_Loading()
return
endif


if FileExists(_ISN_Variablen_aufloesen($Projectfolder&"\"&$foldername)) then
$res = msgbox(262144+48+4,_Get_langstr(394),_Get_langstr(481),0,$projectmanager)
if $res = 7 then
DirRemove($Arbeitsverzeichnis & "\data\Cache\import"&$randomid,1)
_GUICtrlStatusBar_SetText ($Status_bar, "")
GUISetState(@SW_ENABLE,$projectmanager)
_Hide_Loading()
return
EndIf
endif


$res = _FileOperationProgress($folderpath,_ISN_Variablen_aufloesen($Projectfolder&"\"), 1,  $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)


DirRemove($Arbeitsverzeichnis & "\data\Cache\import"&$randomid,1)
_GUICtrlStatusBar_SetText ($Status_bar, "")
_Loading_Progress(100)
sleep(100)
GUISetState(@SW_ENABLE,$projectmanager)
_Hide_Loading()
ScanforProjects_Projectman(_ISN_Variablen_aufloesen($Projectfolder))
if $res = 1 then msgbox(262144+64,_Get_langstr(61),_Get_langstr(478),0,$projectmanager)
DirRemove($Arbeitsverzeichnis& "\data\Cache\import"&$randomid,1)
EndFunc


func _Open_project_inExplorer()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf

ShellExecute("explorer.exe",FileGetShortName(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3))))
EndFunc


;==========================# ZIP Dll-callback functions #======================================
Func _ZIPPrint($sFile, $sPos)
;~ 	ConsoleWrite("!> _ZIPPrint: " & $sFile & @LF)
EndFunc

Func _ZIPPassword($sPWD, $sX, $sS2, $sName)
	Local $iPass = InputBox(_Get_langstr(48), _Get_langstr(473), "", "*", 300, 150)

	If $iPass = "" Then Return 1

	Local $PassBuff = DllStructCreate("char[256]", $sPWD)
	DllStructSetData($PassBuff, 1, $iPass)
EndFunc

Func _ZIPComment($sComment)
	Local $iComment = InputBox("Archive comment set", "Enter the comment", "", "", 300, 120)
	If $iComment = "" Then Return 1

	Local $CommentBuff = DllStructCreate("char[256]", $sComment)
	DllStructSetData($CommentBuff, 1, $iComment)
EndFunc

Func _ZIPProgress($sName, $sSize)
	$CurZipSize += Number($sSize)
	Local $iPercent = Round(($CurZipSize / $UnCompSize * 100))
	_Loading_Progress($iPercent)
	_GUICtrlStatusBar_SetText ($Status_bar, $sName)
EndFunc


;==========================# UnZIP Dll-callback functions #========================================
Func _UnZIP_PrintFunc($sName, $sPos)
;~ 	ConsoleWrite("---> _UnZIP_PrintFunc: " & $sName & @LF)
EndFunc

Func UnZIP_ReplaceFunc($sReplace)
	If MsgBox(4 + 32, "Overwrite", "File " & $sReplace & " is exists." & @LF & "Do you want to overwrite all file?") = 6 Then
		Return $IDM_REPLACE_ALL
	Else
		Return $IDM_REPLACE_NONE
	EndIf
EndFunc

Func _UnZIP_PasswordFunc($sPWD, $sX, $sS2, $sName)
;~ 	ConsoleWrite("!> UnZIP_PasswordFunc: " & $sPWD & @LF)

	Local $iPass = InputBox(_Get_langstr(474), _Get_langstr(473), "", "*", 300, 150)
	If $iPass = "" Then
		_Reload_Zip()
		return 1
	endif
	if @error then
	_Reload_Zip()
		return 1
	endif


	Local $PassBuff = DllStructCreate("char[256]", $sPWD)
	DllStructSetData($PassBuff, 1, $iPass)
EndFunc

Func _UnZIP_SendAppMsgFunc($sUcsize, $sCsize, $sCfactor, $sMo, $Dy, $sYr, $sHh, $sMm, $sC, $sFname, $sMeth, $sCRC, $fCrypt)
	;ConsoleWrite("!> _UnZIP_SendAppMsgFunc: " & $sUcsize & @LF)
EndFunc

Func _UnZIP_ServiceFunc($sName, $sSize)
	;return 1
	;Return 1 for abort the unzip!
;~ 	GUICtrlSetData($edit, $sName & @CRLF, 1)
	_GUICtrlStatusBar_SetText ($Status_bar, stringreplace($sName,"/","\"))
;~ 	ConsoleWrite("!> Size: " & $sSize & @LF & _
;~ 				 "!> FileName" & $sName & @LF)

EndFunc

func _exportiere_Projektdetails_als_csv()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf

$line = FileSaveDialog(_Get_langstr(740), "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "csv (*.csv)", 18, "export.csv", $projectmanager)
if $line = "" then Return
if @Error > 0 then return
FileChangeDir(@scriptdir)
_GUICtrlListView_SaveCSV($Projektverwaltung_Projektdetails_Listview, $line)
msgbox(262144 + 64, _Get_langstr(61), _Get_langstr(164), 0, $StudioFenster)
endfunc

func _Projektverwaltung_aendere_Hauptdatei()
if _GUICtrlListView_GetSelectionMark($Projects_Listview_projectman) = -1 then
	msgbox(262144+16,_Get_langstr(25),_Get_langstr(170),0,$projectmanager)
	Return
EndIf
$isnpath = _Finde_Projektdatei(_ISN_Variablen_aufloesen($Projectfolder&"\"&_GUICtrlListView_GetItemText($Projects_Listview_projectman,_GUICtrlListView_GetSelectionMark($Projects_Listview_projectman),3)))
$path = stringtrimright($isnpath,stringlen($isnpath)-stringinstr($isnpath,"\",0,-1)+1)
GUICtrlSetOnEvent($Choose_File_GUI_OK,"_Projektverwaltung_aendere_Hauptdatei_OK")
GUICtrlSetOnEvent($Choose_File_GUI_Abbrechen,"_Projektverwaltung_aendere_Hauptdatei_Abbrechen")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Projektverwaltung_aendere_Hauptdatei_Abbrechen",$Choose_File_GUI)
guisetstate(@SW_DISABLE, $projectmanager)
_Projektverwaltung_aendere_Hauptdatei_Choose_File("*.au3;",$path)
EndFunc

func _Projekteigenschaften_aendere_Hauptdatei()
GUICtrlSetOnEvent($Choose_File_GUI_OK,"_Projekteigenschaften_aendere_Hauptdatei_OK")
GUICtrlSetOnEvent($Choose_File_GUI_Abbrechen,"_Projekteigenschaften_aendere_Hauptdatei_abbrechen")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Projekteigenschaften_aendere_Hauptdatei_abbrechen",$Choose_File_GUI)
guisetstate(@SW_DISABLE, $Projekteinstellungen_GUI)
_Projektverwaltung_aendere_Hauptdatei_Choose_File("*.au3;",$Offenes_Projekt)
EndFunc

func _Projekteigenschaften_aendere_Hauptdatei_abbrechen()
	guisetstate(@SW_ENABLE, $Projekteinstellungen_GUI)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview,1) ;Zerstöre Treeview
endfunc


func _Projekteigenschaften_aendere_Hauptdatei_OK()
	if _IsDir(_GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)) then return
	guisetstate(@SW_ENABLE, $Projekteinstellungen_GUI)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	$gelesener_pfad = _GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)
	$isnpath = _Finde_Projektdatei(_GUICtrlTVExplorer_GetRootPath($Choose_File_Treeview))
	$gelesener_pfad = StringReplace($gelesener_pfad,_GUICtrlTVExplorer_GetRootPath($Choose_File_Treeview)&"\","")
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview,1) ;Zerstöre Treeview
	iniwrite($isnpath,"ISNAUTOITSTUDIO","mainfile",$gelesener_pfad)
_Zeige_Projekteinstellungen("projectproberties")
endfunc


Func _Projektverwaltung_aendere_Hauptdatei_Choose_File($Filter = "",$Pfad= "")
	$FilechooseFilter = $Filter
	local $root = ""
	GUICtrlSetData($Choose_File_GUI_Label, _Get_langstr(874))
	GUISwitch($Choose_File_GUI)
	local $AutoIt_Projekte_in_Projektbaum_anzeigen_backup = $AutoIt_Projekte_in_Projektbaum_anzeigen
    $AutoIt_Projekte_in_Projektbaum_anzeigen = "false"
	Global $Choose_File_Treeview = _GUICtrlTVExplorer_Create($Pfad, 10*$DPI, 40*$DPI, 480*$DPI, 355*$DPI, -1, $WS_EX_CLIENTEDGE, $TV_FLAG_SHOWFILESEXTENSION + $TV_FLAG_SHOWFILES + $TV_FLAG_SHOWFOLDERICON + $TV_FLAG_SHOWFILEICON + $TV_FLAG_SHOWLIKEEXPLORER, "_Projecttree_event", $Filter)
	Global $Choose_File_hTreeview = GUICtrlGetHandle($Choose_File_Treeview)
	$AutoIt_Projekte_in_Projektbaum_anzeigen = $AutoIt_Projekte_in_Projektbaum_anzeigen_backup
	GUICtrlSetfont($Choose_File_Treeview, $treefont_size, 400, 0, $treefont_font) ;Schrift
	GUICtrlSetColor($Choose_File_Treeview, $treefont_colour) ;Farbe
	_GUICtrlTVExplorer_Expand($Choose_File_hTreeview)
	GUICtrlSetState($Choose_File_GUI_Mehr,$GUI_HIDE)
	GUISetState(@SW_SHOW, $Choose_File_GUI)
	WinSetOnTop($Choose_File_GUI, "", 1)
EndFunc

func _Projektverwaltung_aendere_Hauptdatei_OK()
	if _IsDir(_GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)) then return
	guisetstate(@SW_ENABLE, $projectmanager)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	$gelesener_pfad = _GUICtrlTVExplorer_GetSelected($Choose_File_Treeview)
	$isnpath = _Finde_Projektdatei(_GUICtrlTVExplorer_GetRootPath($Choose_File_Treeview))
	$gelesener_pfad = StringReplace($gelesener_pfad,_GUICtrlTVExplorer_GetRootPath($Choose_File_Treeview)&"\","")
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview,1) ;Zerstöre Treeview
	iniwrite($isnpath,"ISNAUTOITSTUDIO","mainfile",$gelesener_pfad)
	_Show_Projectman()
endfunc

func _Projektverwaltung_aendere_Hauptdatei_Abbrechen()
	guisetstate(@SW_ENABLE, $projectmanager)
	GUISetState(@SW_HIDE, $Choose_File_GUI)
	_GUICtrlTVExplorer_Destroy($Choose_File_hTreeview,1) ;Zerstöre Treeview
 endfunc

Func _Import_Project_CMD($path="")
   if $path = "" then return
	_Fadeout_logo()
	_Show_Projectman()
	_Import_project($path)
EndFunc