#cs
Anpassungen des AutoIt3Wrappers für das ISN AutoIt Studio

Anpassungen:
------------
$SciTE_Dir & "\Tidy\Tidy.exe" 										ERSETZT DURCH 	$Tidy_exe_path
$Tidypgm = $SciTE_Dir & "\tidy\Tidy.exe" 							ERSETZT DURCH 	$Tidypgm = $Tidy_exe_path
$Tidypgmdir = $SciTE_Dir & "\tidy" 									ERSETZT DURCH	$Tidypgmdir = $Tidy_pgmdir

$CurrentAutoIt_InstallDir & "\Au3check.exe"							ERSETZT DURCH	$Au3check_exe_path
$Au3checkpgm = $CurrentAutoIt_InstallDir & "\au3check.exe"			ERSETZT DURCH	$Au3checkpgm = $Au3check_exe_path
$Au3checkpgmdir = $CurrentAutoIt_InstallDir							ERSETZT DURCH	$Au3checkpgmdir = $Au3check_pgmdir

$SciTE_Dir & "\Au3Stripper\Au3Stripper.exe"							ERSETZT DURCH	$Au3Stripper_exe_path
$Au3Stripperpgm = $SciTE_Dir & "\Au3Stripper\Au3Stripper.exe"		ERSETZT DURCH	$Au3Stripperpgm = $Au3Stripper_exe_path
$Au3Stripperpgmdir = $SciTE_Dir & "\Au3Stripper"					ERSETZT DURCH	$Au3Stripperpgmdir = $Au3Stripper_pgmdir

.htm																ERSETZT DURCH	.html
tidy_doc.htm														ERSETZT DURCH	tidy.html
Au3Stripper_doc.htm													ERSETZT DURCH	Au3Stripper.html

Entfernt:
---------
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#AutoIt3Wrapper_Run_After=for %I in ("%in%" "directives.au3") do copy %I "C:\Program Files (x86)\autoit3\SciTE\AutoIt3Wrapper"
#ce

Global $Tidy_exe_path
Global $Tidy_pgmdir

Global $Au3check_exe_path
Global $Au3check_pgmdir

Global $Au3Stripper_exe_path
Global $Au3Stripper_pgmdir

Global $ISN_Configfile
If FileExists(@ScriptDir & "\..\..\portable.dat") Then
	$ISN_Configfile =_PathFull(@ScriptDir & "\..\config.ini")
 Else
	$ISN_Configfile = RegRead("HKEY_CURRENT_USER\Software\ISN AutoIt Studio", "Configfile")
EndIf

;$allow_windows_variables_in_paths
Global $allow_windows_variables_in_paths = IniRead($ISN_Configfile, "config", "allow_windows_variables_in_paths", "true")


;$CurrentAutoIt
$CurrentAutoIt_InstallDir = IniRead($ISN_Configfile, "config", "autoit2exe", "") ;_PathFull(@ScriptDir & "..\..\..")
$CurrentAutoIt_InstallDir = _ISN_Variablen_aufloesen($CurrentAutoIt_InstallDir)
$CurrentAutoIt_InstallDir = StringTrimRight($CurrentAutoIt_InstallDir, StringLen($CurrentAutoIt_InstallDir) - StringInStr($CurrentAutoIt_InstallDir, "\", 0, -1) + 1)
$CurrentAutoIt_InstallDir = StringTrimRight($CurrentAutoIt_InstallDir, StringLen($CurrentAutoIt_InstallDir) - StringInStr($CurrentAutoIt_InstallDir, "\", 0, -1) + 1)


;Tidy
$Tidy_exe_path = _ISN_Variablen_aufloesen(IniRead($ISN_Configfile, "config", "tidyexe", "%isnstudiodir%\Data\Tidy\Tidy.exe"))
$Tidy_pgmdir = StringTrimRight($Tidy_exe_path,StringLen($Tidy_exe_path)-(StringInStr($Tidy_exe_path,"\",0,-1))+1)

;Au3check
$Au3check_exe_path = _ISN_Variablen_aufloesen(IniRead($ISN_Configfile, "config", "au3checkexe", $CurrentAutoIt_InstallDir&"\Au3Check.exe"))
$Au3check_pgmdir = StringTrimRight($Au3check_exe_path,StringLen($Au3check_exe_path)-(StringInStr($Au3check_exe_path,"\",0,-1))+1)

;Au3Stripper
$Au3Stripper_exe_path = _ISN_Variablen_aufloesen(IniRead($ISN_Configfile, "config", "au3stripperexe", "%isnstudiodir%\Data\Au3Stripper\AU3Stripper.exe"))
$Au3Stripper_pgmdir = StringTrimRight($Au3Stripper_exe_path,StringLen($Au3Stripper_exe_path)-(StringInStr($Au3Stripper_exe_path,"\",0,-1))+1)


Func _ISN_Variablen_aufloesen($String = "")
	If $String = "" Then Return ""

	;Variablen
	If StringInStr($String, "%projectname%") Then $String = StringReplace($String, "%projectname%", "")
	If StringInStr($String, "%projectversion%") Then $String = StringReplace($String, "%projectversion%", "")
	If StringInStr($String, "%projectauthor%") Then $String = StringReplace($String, "%projectauthor%", "")


	;Pfade
	If StringInStr($String, "%myisndatadir%") Then $String = StringReplace($String, "%myisndatadir%", _Finde_Arbeitsverzeichnis())
	If StringInStr($String, "%lastcompiledfile_exe%") Then $String = StringReplace($String, "%lastcompiledfile_exe%", "")
	If StringInStr($String, "%lastcompiledfile_source%") Then $String = StringReplace($String, "%lastcompiledfile_source%", "")
	If StringInStr($String, "%projectdir%") Then $String = StringReplace($String, "%projectdir%", "")
	If StringInStr($String, "%isnstudiodir%") Then $String = StringReplace($String, "%isnstudiodir%", _PathFull(@ScriptDir&"..\..\.."))
	If StringInStr($String, "%windowsdir%") Then $String = StringReplace($String, "%windowsdir%", @WindowsDir)
	If StringInStr($String, "%tempdir%") Then $String = StringReplace($String, "%tempdir%", @TempDir)
	If StringInStr($String, "%desktopdir%") Then $String = StringReplace($String, "%desktopdir%", @DesktopDir)
	If StringInStr($String, "%mydocumentsdir%") Then $String = StringReplace($String, "%mydocumentsdir%", @MyDocumentsDir)
	If StringInStr($String, "%filedir%") Then $String = StringReplace($String, "%filedir%", "")
	If StringInStr($String, "%backupdir%") Then $String = StringReplace($String, "%backupdir%", "")
	If StringInStr($String, "%compileddir%") Then $String = StringReplace($String, "%compileddir%", "")

   ;Windows Variablen auflösen
   if $allow_windows_variables_in_paths = "true" then
   $ExpandEnvStrings_old_value = Opt('ExpandEnvStrings')
   Opt('ExpandEnvStrings',1)
   $String = $String
   Opt('ExpandEnvStrings', $ExpandEnvStrings_old_value)
   endif

	Return $String
EndFunc   ;==>_ISN_Variablen_aufloesen


 func _Finde_Arbeitsverzeichnis()
local $szDrive, $szDir, $szFName, $szExt, $pfad
_PathSplit($ISN_Configfile, $szDrive, $szDir, $szFName, $szExt)
$pfad = $szDrive&StringTrimRight($szDir,stringlen($szDir)-StringInStr($szDir,"\Data\",0,-1)+1)
return $pfad
EndFunc