#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <SliderConstants.au3>
#include <GuiSlider.au3>
#include <DateTimeConstants.au3>


Global $Trophy0 = @scriptdir&"\Data\trophy_black.png"
Global $Trophy1 = @scriptdir&"\Data\trophy_bronze.png"
Global $Trophy2 = @scriptdir&"\Data\trophy_silver.png"
Global $Trophy3 = @scriptdir&"\Data\trophy_gold.png"


func _Earn_trophy($trophy,$mode = 1)
if $Studiomodus = 2 then return
if $allow_trophys = "false" then return
if iniread($Configfile,"trophies","TROP"&$trophy,"0") <> 0 then return
while 1
	if WinExists("#TROPHY_ISNAUTOITSTUDIO#") = 0 then exitloop
	sleep(100)
WEnd
SoundPlay(@scriptdir&"\Data\Trophy.mp3",0)
; Load PNG file as GDI bitmap
_GDIPlus_Startup()
$pngSrc = @ScriptDir & "\Data\Trophy.png"
Global $hImageTROP = _GDIPlus_ImageLoadFromFile($pngSrc)

; Extract image width and height from PNG
$width = _GDIPlus_ImageGetWidth($hImageTROP)
$height = _GDIPlus_ImageGetHeight($hImageTROP)

; Create layered window
Global $TROPHYPNG = GUICreate("", $width, $height, 40, 80, $WS_POPUP, $WS_EX_LAYERED,$Studiofenster)
SetBitmap($TROPHYPNG, $hImageTROP, 0)
GUISetState()
WinSetOnTop($TROPHYPNG, "", 1)
SetBitmap($TROPHYPNG, $hImageTROP, 255)
$str = ""
if $trophy = 1 then $str = _Get_langstr(265)
if $trophy = 2 then $str = _Get_langstr(270)
if $trophy = 3 then $str = _Get_langstr(272)
if $trophy = 4 then $str = _Get_langstr(276)
if $trophy = 5 then $str = _Get_langstr(278)
if $trophy = 6 then $str = _Get_langstr(280)
if $trophy = 7 then $str = _Get_langstr(282)
if $trophy = 8 then $str = _Get_langstr(285)
if $trophy = 9 then $str = _Get_langstr(287)
if $trophy = 10 then $str = _Get_langstr(289)
if $trophy = 11 then $str = _Get_langstr(291)
if $trophy = 12 then $str = _Get_langstr(293)
if $trophy = 13 then $str = _Get_langstr(556)
if $trophy = 14 then $str = _Get_langstr(558)


Global $controlGui = GUICreate("#TROPHY_ISNAUTOITSTUDIO#", 300, 50, 65, 90, $WS_POPUP, -1, $TROPHYPNG)
GUISetBkColor(0x3B3F40,$controlGui)
GUICtrlCreatePic("",0,0,50,50,-1,-1)
if $mode = 1 then _SetImage(-1,$Trophy1)
if $mode = 2 then _SetImage(-1,$Trophy2)
if $mode = 3 then _SetImage(-1,$Trophy3)
GUICtrlCreateLabel(_Get_langstr(274),65,4,291,33,-1,-1)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetFont(-1,10,800,default,"Arial")
GUICtrlCreateLabel($str,65,23,291,33,-1,-1)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetFont(-1,14,800,default,"Arial")
GUISetState()




iniwrite($Configfile,"trophies","TROP"&$trophy,"1")
AdlibRegister("_hide_achivgui",3000)

if iniread($Configfile,"trophies","TROP1","0") = 1 AND _
iniread($Configfile,"trophies","TROP2","0") = 1 AND _
iniread($Configfile,"trophies","TROP3","0") = 1 AND _
iniread($Configfile,"trophies","TROP4","0") = 1 AND _
iniread($Configfile,"trophies","TROP5","0") = 1 AND _
iniread($Configfile,"trophies","TROP6","0") = 1 AND _
iniread($Configfile,"trophies","TROP7","0") = 1 AND _
iniread($Configfile,"trophies","TROP8","0") = 1 AND _
iniread($Configfile,"trophies","TROP9","0") = 1 AND _
iniread($Configfile,"trophies","TROP10","0") = 1 AND _
iniread($Configfile,"trophies","TROP11","0") = 1 AND _
iniread($Configfile,"trophies","TROP13","0") = 1 AND _
iniread($Configfile,"trophies","TROP14","0") = 1 Then
_Earn_trophy(12,3)
Else
iniwrite($Configfile,"trophies","TROP12","0")
endif


EndFunc


func _hide_achivgui()
AdlibUnRegister("_hide_achivgui")
GUIDelete($controlGui)
For $i = 255 To 0 Step -5
    SetBitmap($TROPHYPNG, $hImageTROP, $i)
Next
GUIDelete($TROPHYPNG)
_WinAPI_DeleteObject($hImageTROP)
_GDIPlus_Shutdown()
EndFunc


func _Showtrophies()
if $allow_trophys = "false" then
msgbox(262144+16,_Get_langstr(25),_Get_langstr(303),0,$studiofenster)
return
endif


if iniread($Configfile,"trophies","TROP1","0") = 1 AND _
iniread($Configfile,"trophies","TROP2","0") = 1 AND _
iniread($Configfile,"trophies","TROP3","0") = 1 AND _
iniread($Configfile,"trophies","TROP4","0") = 1 AND _
iniread($Configfile,"trophies","TROP5","0") = 1 AND _
iniread($Configfile,"trophies","TROP6","0") = 1 AND _
iniread($Configfile,"trophies","TROP7","0") = 1 AND _
iniread($Configfile,"trophies","TROP8","0") = 1 AND _
iniread($Configfile,"trophies","TROP9","0") = 1 AND _
iniread($Configfile,"trophies","TROP10","0") = 1 AND _
iniread($Configfile,"trophies","TROP11","0") = 1 AND _
iniread($Configfile,"trophies","TROP13","0") = 1 AND _
iniread($Configfile,"trophies","TROP14","0") = 1 Then
_Earn_trophy(12,3)
Else
iniwrite($Configfile,"trophies","TROP12","0")
endif

guictrlsettip($achiv1_icon,_Get_langstr(269))
guictrlsettip($achiv2_icon,_Get_langstr(271))
guictrlsettip($achiv3_icon,_Get_langstr(273))
guictrlsettip($achiv4_icon,_Get_langstr(275))
guictrlsettip($achiv5_icon,_Get_langstr(277))
guictrlsettip($achiv6_icon,_Get_langstr(279))
guictrlsettip($achiv7_icon,_Get_langstr(281))
guictrlsettip($achiv8_icon,_Get_langstr(284))
guictrlsettip($achiv9_icon,_Get_langstr(286))
guictrlsettip($achiv10_icon,_Get_langstr(288))
guictrlsettip($achiv11_icon,_Get_langstr(290))
guictrlsettip($achiv12_icon,_Get_langstr(292))
guictrlsettip($achiv13_icon,_Get_langstr(557))
guictrlsettip($achiv14_icon,_Get_langstr(559))


if iniread($Configfile,"trophies","TROP1","0") = 0 Then
_SetImage($achiv1_icon,$Trophy0)
guictrlsetdata($achiv1_txt,"?")
Else
_SetImage($achiv1_icon,$Trophy1)
guictrlsetdata($achiv1_txt,_Get_langstr(265))
endif

if iniread($Configfile,"trophies","TROP2","0") = 0 Then
_SetImage($achiv2_icon,$Trophy0)
guictrlsetdata($achiv2_txt,"?")
Else
_SetImage($achiv2_icon,$Trophy1)
guictrlsetdata($achiv2_txt,_Get_langstr(270))
endif

if iniread($Configfile,"trophies","TROP3","0") = 0 Then
_SetImage($achiv3_icon,$Trophy0)
guictrlsetdata($achiv3_txt,"?")
Else
_SetImage($achiv3_icon,$Trophy1)
guictrlsetdata($achiv3_txt,_Get_langstr(272))
endif

if iniread($Configfile,"trophies","TROP4","0") = 0 Then
_SetImage($achiv4_icon,$Trophy0)
guictrlsetdata($achiv4_txt,"?")
Else
_SetImage($achiv4_icon,$Trophy1)
guictrlsetdata($achiv4_txt,_Get_langstr(276))
endif

if iniread($Configfile,"trophies","TROP5","0") = 0 Then
_SetImage($achiv5_icon,$Trophy0)
guictrlsetdata($achiv5_txt,"?")
Else
_SetImage($achiv5_icon,$Trophy1)
guictrlsetdata($achiv5_txt,_Get_langstr(278))
endif

if iniread($Configfile,"trophies","TROP6","0") = 0 Then
_SetImage($achiv6_icon,$Trophy0)
guictrlsetdata($achiv6_txt,"?")
Else
_SetImage($achiv6_icon,$Trophy1)
guictrlsetdata($achiv6_txt,_Get_langstr(280))
endif

if iniread($Configfile,"trophies","TROP7","0") = 0 Then
_SetImage($achiv7_icon,$Trophy0)
guictrlsetdata($achiv7_txt,"?")
Else
_SetImage($achiv7_icon,$Trophy2)
guictrlsetdata($achiv7_txt,_Get_langstr(282))
endif

if iniread($Configfile,"trophies","TROP8","0") = 0 Then
_SetImage($achiv8_icon,$Trophy0)
guictrlsetdata($achiv8_txt,"?")
Else
_SetImage($achiv8_icon,$Trophy2)
guictrlsetdata($achiv8_txt,_Get_langstr(285))
endif

if iniread($Configfile,"trophies","TROP9","0") = 0 Then
_SetImage($achiv9_icon,$Trophy0)
guictrlsetdata($achiv9_txt,"?")
Else
_SetImage($achiv9_icon,$Trophy2)
guictrlsetdata($achiv9_txt,_Get_langstr(287))
endif

if iniread($Configfile,"trophies","TROP10","0") = 0 Then
_SetImage($achiv10_icon,$Trophy0)
guictrlsetdata($achiv10_txt,"?")
Else
_SetImage($achiv10_icon,$Trophy3)
guictrlsetdata($achiv10_txt,_Get_langstr(289))
endif

if iniread($Configfile,"trophies","TROP11","0") = 0 Then
_SetImage($achiv11_icon,$Trophy0)
guictrlsetdata($achiv11_txt,"?")
Else
_SetImage($achiv11_icon,$Trophy3)
guictrlsetdata($achiv11_txt,_Get_langstr(291))
endif

if iniread($Configfile,"trophies","TROP12","0") = 0 Then
_SetImage($achiv12_icon,$Trophy0)
guictrlsetdata($achiv12_txt,"?")
Else
_SetImage($achiv12_icon,$Trophy3)
guictrlsetdata($achiv12_txt,_Get_langstr(293))
endif

if iniread($Configfile,"trophies","TROP13","0") = 0 Then
_SetImage($achiv13_icon,$Trophy0)
guictrlsetdata($achiv13_txt,"?")
Else
_SetImage($achiv13_icon,$Trophy1)
guictrlsetdata($achiv13_txt,_Get_langstr(556))
endif

if iniread($Configfile,"trophies","TROP14","0") = 0 Then
_SetImage($achiv14_icon,$Trophy0)
guictrlsetdata($achiv14_txt,"?")
Else
_SetImage($achiv14_icon,$Trophy3)
guictrlsetdata($achiv14_txt,_Get_langstr(558))
endif


guisetstate(@SW_DISABLE,$StudioFenster)
GUISetState(@SW_SHOW,$trophys)
EndFunc

func _hide_trophy()
guisetstate(@SW_ENABLE,$StudioFenster)
GUISetState(@SW_HIDE,$trophys)
endfunc

func _reset_trophys_config()
$answer = msgbox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(555) , 0, $config_GUI)
if $answer = 6 then
IniDelete($Configfile,"trophies")
endif
endfunc

func _reset_trophys()
$state = WinGetState($config_GUI, "")
	If BitAnd($state, 2) Then
		_reset_trophys_config()
		return
	endif
$answer = msgbox(262144 + 32 + 4, _Get_langstr(48), _Get_langstr(555) , 0, $trophys)
if $answer = 6 then
IniDelete($Configfile,"trophies")
endif
_Showtrophies()
endfunc


; I don't like AutoIt's built in ShellExec. I'd rather do the DLL call myself.
Func _ShellExecute($sCmd, $sArg = "", $sFolder = "", $rState = @SW_SHOWNORMAL)
    $aRet = DllCall("shell32.dll", "long", "ShellExecute", _
            "hwnd", 0, _
            "string", "", _
            "string", $sCmd, _
            "string", $sArg, _
            "string", $sFolder, _
            "int", $rState)
    If @error Then Return 0

    $RetVal = $aRet[0]
    If $RetVal > 32 Then
        Return 1
    Else
        Return 0
    EndIf
EndFunc   ;==>_ShellExecute

