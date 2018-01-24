;Globale Variablen

Func _ISN_Skript_Testen()

	GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST_Testscript")
	GUIRegisterMsg($WM_SIZE, "WM_SIZE_Testscript")
	_PDH_Init()


	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($Testscript_file, $szDrive, $szDir, $szFName, $szExt)
	$starttime = _Timer_Init()
	GUICtrlSetData($DEBUGGUI_TITLE, $szFName & $szExt & " - " & _Get_langstr(306))
	GUICtrlSetData($ISN_Debug_Erweitert_Titel, $szFName & $szExt & " - " & _Get_langstr(306))




	If $starte_Skripts_mit_au3Wrapper = "false" Then
		_Show_DebugGUI()
		$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" /ErrorStdOut "' & $Testscript_file & '" ' & $Testscript_file_parameter, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	Else
		$Data = _RunReadStd('"' & FileGetShortName($autoitexe) & '" "' & FileGetShortName($AutoIt3Wrapper_exe_path) & '" /run /prod /ErrorStdOut /in "' & $Testscript_file & '" /UserParams ' & $Testscript_file_parameter, 0, $szDrive & $szDir, @SW_SHOW, 1) ;thx to Anarchon
	EndIf



	If $Erweitertes_debugging = "true" Then
		;Aufräumen nach erweitertem Debuggin
		If FileExists($szDrive & $szDir & $szFName & $szExt) Then FileDelete($szDrive & $szDir & $szFName & $szExt)
		If FileExists($szDrive & $szDir & $szFName & ".txt") Then FileDelete($szDrive & $szDir & $szFName & ".txt")
		If FileExists($szDrive & $szDir & $szFName & "_debug.au3") Then FileDelete($szDrive & $szDir & $szFName & "_debug.au3")
	EndIf

	_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio("$Console_Bluemode", 1)
	_ISNPlugin_Call_Function_in_ISN_AutoIt_Studio("_Write_debug", @CRLF & $szFName & $szExt & " -> Exit Code: " & $Data[1] & @TAB & "(" & _Get_langstr(105) & " " & Round(_Timer_Diff($starttime) / 1000, 2) & " sec)")
	_ISNPlugin_Set_Variable_in_ISN_AutoIt_Studio("$Console_Bluemode", 0)

	_ISNHelper_testscript_exit()


EndFunc   ;==>_ISN_Skript_Testen


Func _ISNThread_initialize($Use_Watch_Guard = "1")
	$hGUI = GUICreate("", 450, 100)

	GUIRegisterMsg(0x004A, "_ISNPlugin_Receive_Message") ;Register _WM_COPYDATA

	Local $Plugin_Timer = 35 ;Wait about 4 Secounds to received an "unlock" command, otherwise it will crash with @error -1

	$GUI_old_Title = WinGetTitle($hGUI) ;Save old Window Title
	WinSetTitle($hGUI, "", "_ISNTHREAD_STARTUP_") ;Set new Title to the Windows, so the ISN AutoIt Studio can find it easily
	GUISetState(@SW_ENABLE, $hGUI) ;Enables the GUI. This also "fixes" the resizing problems at the startup of a plugin. I don´t know why ^^

	For $Timer = 0 To $Plugin_Timer
		Sleep(100)
		If $ISNPlugin_Status <> "locked" Then
			;The plugin is unlocked and can start!

			WinSetTitle($hGUI, "", "ISN_THREAD_" & $hGUI)

			;Set Plugin Variables
			$ISNPlugin_Message_Window_Handle = $hGUI
			$ISN_AutoIt_Studio_Mainwindow_Handle = Ptr(_ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 0)) ;Set the Mainwindow Handle
			$ISN_AutoIt_Studio_PID = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 2) ;Set the ISN AutoIt Studio PID
			$ISN_AutoIt_Studio_EXE_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 3) ;Set the ISN AutoIt Studio EXE Path
			$ISN_AutoIt_Studio_Config_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 4) ;Set the ISN AutoIt Studio config.ini Path
			$ISN_AutoIt_Studio_Languagefile_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 5) ;Set the ISN AutoIt Studio language file Path
			$ISN_AutoIt_Studio_opened_project_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 6) ;Set the path to the currently opened project
			$ISN_AutoIt_Studio_opened_project_Name = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 7) ;Set the name to the currently opened project
			$ISN_AutoIt_Studio_Data_Directory = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 8) ;Set the data directory path
			$ISN_AutoIt_Studio_ISN_file_Path = _ISNPlugin_Messagestring_Get_Element($ISNPlugin_Received_Message_after_unlock, 9) ;Set the path to the project file of the current project

			;...and the LEGACY stuff
			$ISN_AutoIt_Studio_Fensterhandle = $ISN_AutoIt_Studio_Mainwindow_Handle
			$ISN_AutoIt_Studio_Projektpfad = $ISN_AutoIt_Studio_opened_project_Path
			$ISN_AutoIt_Studio_Konfigurationsdatei_Pfad = $ISN_AutoIt_Studio_Config_Path

			;Register the Watch Guard. If the ISN AutoIt Studio crashes, also close the Plugin (check every 60 seconds)
			If $Use_Watch_Guard = "1" Then AdlibRegister("_ISNPlugin_watch_guard", 60 * 1000)

			;Sends the ISN the "unlocked" message
			_ISNPlugin_send_message_to_ISN("unlocked")
			Return 1
		EndIf
	Next

	WinSetTitle($hGUI, "", "") ;Restore old Window Title
	GUIRegisterMsg(0x004A, "") ;Remove MsgRegister

	;No "unlock" command received
	SetError(-1)
	Return -1
EndFunc   ;==>_ISNThread_initialize

Func SetBitmap($hGUI, $hImage, $iOpacity)
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)

	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap


Func _Get_langstr($str)
	$encoding = FileGetEncoding($ISN_AutoIt_Studio_Languagefile_Path)
	If $encoding = $FO_UTF8_NOBOM Or $encoding = $FO_UTF8 Then
		$get = _IniReadEx($ISN_AutoIt_Studio_Languagefile_Path, "ISNAUTOITSTUDIO", "str" & $str, IniRead(@ScriptDir & "\data\language\english.lng", "ISNAUTOITSTUDIO", "str" & $str, "#error#"& $str))
	Else
		$get = IniRead($ISN_AutoIt_Studio_Languagefile_Path, "ISNAUTOITSTUDIO", "str" & $str, IniRead(@ScriptDir & "\data\language\english.lng", "ISNAUTOITSTUDIO", "str" & $str, "#error#"& $str))
	EndIf
	$get = StringReplace($get, "[BREAK]", @CRLF)
	Return $get
EndFunc   ;==>_Get_langstr



Func ExtractIconEx($sIconFile, $nIconID, $ptrIconLarge, $ptrIconSmall, $nIcons)
	Local $nCount = DllCall('shell32.dll', 'int', 'ExtractIconEx', _
			'str', $sIconFile, _
			'int', $nIconID, _
			'ptr', $ptrIconLarge, _
			'ptr', $ptrIconSmall, _
			'int', $nIcons)
	Return $nCount[0]
EndFunc   ;==>ExtractIconEx

Func ImageList_Create($nImageWidth, $nImageHeight, $nFlags, $nInitial, $nGrow)
	Local $hImageList = DllCall('comctl32.dll', 'hwnd', 'ImageList_Create', _
			'int', $nImageWidth, _
			'int', $nImageHeight, _
			'int', $nFlags, _
			'int', $nInitial, _
			'int', $nGrow)
	Return $hImageList[0]
EndFunc   ;==>ImageList_Create

Func ImageList_AddIcon($hIml, $hIcon)
	Local $nIndex = DllCall('comctl32.dll', 'int', 'ImageList_AddIcon', _
			'hwnd', $hIml, _
			'hwnd', $hIcon)
	Return $nIndex[0]
EndFunc   ;==>ImageList_AddIcon

Func ImageList_Destroy($hIml)
	Local $bResult = DllCall('comctl32.dll', 'int', 'ImageList_Destroy', _
			'hwnd', $hIml)
	Return $bResult[0]
EndFunc   ;==>ImageList_Destroy

Func DestroyIcon($hIcon)
	Local $bResult = DllCall('user32.dll', 'int', 'DestroyIcon', _
			'hwnd', $hIcon)
	Return $bResult[0]
EndFunc   ;==>DestroyIcon


Func Button_AddIcon($nID, $sIconFile, $nIconID, $nAlign)
;~ 	$sIconFile = $smallIconsdll
	Local $hIL = ImageList_Create(16, 16, BitOR($ILC_MASK, $ILC_COLOR32), 0, 1)
	Local $stIcon = DllStructCreate("int")
	ExtractIconEx($sIconFile, $nIconID, DllStructGetPtr($stIcon), 0, 1)
	ImageList_AddIcon($hIL, DllStructGetData($stIcon, 1))
	DestroyIcon(DllStructGetData($stIcon, 1))
	Local $stBIL = DllStructCreate("dword;int[4];uint")
	DllStructSetData($stBIL, 1, $hIL)
	DllStructSetData($stBIL, 2, 1, 1)
	DllStructSetData($stBIL, 2, 1, 2)
	DllStructSetData($stBIL, 2, 1, 3)
	DllStructSetData($stBIL, 2, 1, 4)
	DllStructSetData($stBIL, 3, $nAlign)
	GUICtrlSendMsg($nID, $BCM_SETIMAGELIST, 0, DllStructGetPtr($stBIL))
EndFunc   ;==>Button_AddIcon



Func _WinAPI_ShellExtractIcons($icon, $Index, $width, $height)
	Local $Ret = DllCall('shell32.dll', 'int', 'SHExtractIconsW', 'wstr', $icon, 'int', $Index, 'int', $width, 'int', $height, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)
	If @error Or $Ret[0] = 0 Or $Ret[5] = Ptr(0) Then Return SetError(1, 0, 0)
	Return $Ret[5]
EndFunc   ;==>_WinAPI_ShellExtractIcons

Func _SetIconAlpha($hWnd, $sIcon, $iIndex, $iWidth, $iHeight)

	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $iIndex <> 0 Then $iIndex = $iIndex - 1
	Local $hIcon = _WinAPI_ShellExtractIcons($sIcon, $iIndex, $iWidth, $iHeight)

	If $hIcon = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hBitmap, $hObj, $hDC, $hMem, $hSv

	$hDC = _WinAPI_GetDC($hWnd)
	$hMem = _WinAPI_CreateCompatibleDC($hDC)
	$hBitmap = _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
	$hSv = _WinAPI_SelectObject($hMem, $hBitmap)
	_WinAPI_DrawIconEx($hMem, 0, 0, $hIcon, $iWidth, $iHeight, 0, 0, 2)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	_WinAPI_SelectObject($hMem, $hSv)
	_WinAPI_DeleteDC($hMem)
	_WinAPI_DestroyIcon($hIcon)
	_WinAPI_DeleteObject(_SendMessage($hWnd, 0x0172, 0, 0))
	_SendMessage($hWnd, 0x0172, 0, $hBitmap)
	$hObj = _SendMessage($hWnd, 0x0173)
	If $hObj <> $hBitmap Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	Return 1
EndFunc   ;==>_SetIconAlpha


Func WM_NCHITTEST_Testscript($hWnd, $iMsg, $iwParam, $ilParam)
	If IsDeclared("minidebug_GUI_sec") Then
		If $hWnd = $minidebug_GUI_sec And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
	EndIf

	If IsDeclared("minidebug_GUI_main") Then
		If $hWnd = $minidebug_GUI_main And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
	EndIf



EndFunc   ;==>WM_NCHITTEST_Testscript

Func _Testscript_Resize()
   _Testscript_Resize_Labels()
	GUISwitch($Debug_GUI_Extended)
	$ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_Prozess_CPU_Rahmen)
	If IsArray($ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array) Then
		$x = $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[0] + (60 - 8)
		$y = $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[1] + (85 - 52)
		$w = $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[2] - (343 - 8 - 270) - 8
		$h = $ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[3] - (171 - 52 - 110) - 52

		_MG_Graph_optionen_position(1, $Debug_GUI_Extended, Int($x), Int($y), Int($w), Int($h))
		_MG_Graph_Achse_links(1, True, 0, 110, 0, " %", $Schriftfarbe, Default, 9, 30, 0.5)
		_MG_Graph_optionen_allgemein (1, Int($w / 3), 0, 110, 0x000000, 2)
		_MG_Graph_clear(1)
	EndIf

	$ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen)
	If IsArray($ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array) Then
		$x = $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[0] + (60 - 8)
		$y = $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[1] + (85 - 52)
		$w = $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[2] - (343 - 8 - 270) - 8
		$h = $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[3] - (171 - 52 - 110) - 52

		_MG_Graph_optionen_position(2, $Debug_GUI_Extended, Int($x), Int($y), Int($w), Int($h))
		_MG_Graph_Achse_links(2, True, 0, 110, 0, " %", $Schriftfarbe, Default, 9, 30, 0.5)
		_MG_Graph_optionen_allgemein (2, Int($w / 3), 0, 110, 0x000000, 2)
		_MG_Graph_clear(2)

	EndIf

	$ISN_Debug_Erweitert_RAM_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_RAM_Rahmen)
	If IsArray($ISN_Debug_Erweitert_RAM_Rahmen_Array) Then
		$x = $ISN_Debug_Erweitert_RAM_Rahmen_Array[0] + (70 - 8)
		$y = $ISN_Debug_Erweitert_RAM_Rahmen_Array[1] + (85 - 52)
		$w = $ISN_Debug_Erweitert_RAM_Rahmen_Array[2] - (343 - 8 - 260) - 8
		$h = $ISN_Debug_Erweitert_RAM_Rahmen_Array[3] - (171 - 52 - 110) - 52

		_MG_Graph_optionen_position(3, $Debug_GUI_Extended, Int($x), Int($y), Int($w), Int($h))
		_MG_Graph_Achse_links (3, True, 0, 220, 0, " MB", $Schriftfarbe, Default, 9, 40, 0.5)
		_MG_Graph_optionen_allgemein (3, Int($w / 3), 0, 220, 0x000000, 2)
		_MG_Graph_clear(3)

	EndIf

EndFunc   ;==>_Testscript_Resize

func _Testscript_Resize_Labels()

	$ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_Prozess_CPU_Rahmen)
	If IsArray($ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array) Then
	   GUICtrlSetPos($Debug_GUI_Prozess_CPU_Label,$ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[0],($ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[1]+$ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[3])-(22*$DPI),$ISN_Debug_Erweitert_Prozess_CPU_Rahmen_Array[2],22*$DPI)
   EndIf

	$ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_CPU_Gesamt_Rahmen)
	If IsArray($ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array) Then
	   GUICtrlSetPos($Debug_GUI_CPU_Label,$ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[0],($ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[1]+$ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[3])-(22*$DPI),$ISN_Debug_Erweitert_CPU_Gesamt_Rahmen_Array[2],22*$DPI)
   EndIf

	$ISN_Debug_Erweitert_RAM_Rahmen_Array = ControlGetPos($Debug_GUI_Extended, "", $ISN_Debug_Erweitert_RAM_Rahmen)
	If IsArray($ISN_Debug_Erweitert_RAM_Rahmen_Array) Then
	   GUICtrlSetPos($Debug_GUI_Prozess_RAM_Label,$ISN_Debug_Erweitert_RAM_Rahmen_Array[0],($ISN_Debug_Erweitert_RAM_Rahmen_Array[1]+$ISN_Debug_Erweitert_RAM_Rahmen_Array[3])-(22*$DPI),$ISN_Debug_Erweitert_RAM_Rahmen_Array[2],22*$DPI)
	EndIf

EndFunc


Func WM_SIZE_Testscript($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $Debug_GUI_Extended
			_Testscript_Resize_Labels()


	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE_Testscript

Func _ISNHelper_testscript_exit()
	_HIDE_DebugGUI()
	_GDIPlus_Shutdown()
	_PDH_ProcessObjectDestroy($poCounter)
	_PDH_UnInit()
	_USkin_Exit()
	Exit
EndFunc   ;==>_ISNHelper_testscript_exit


;===============================================================================
;
; Function Name:   _RunReadStd()
;
; Description::    Run a specified command, and return the Exitcode, StdOut text and
;                  StdErr text from from it. StdOut and StdErr are @tab delimited,
;                  with blank lines removed.
;
; Parameter(s):    $doscmd: the actual command to run, same as used with Run command
;                  $timeoutSeconds: maximum execution time in seconds, optional, default: 0 (wait forever),
;                  $workingdir: directory in which to execute $doscmd, optional, default: @ScriptDir
;                  $flag: show/hide flag, optional, default: @SW_HIDE
;                  $sDelim: stdOut and stdErr output deliminter, optional, default: @TAB
;                  $nRetVal: return single item from function instead of array, optional, default: -1 (return array)
;
; Requirement(s):  AutoIt 3.2.10.0
;
; Return Value(s): An array with three values, Exit Code, StdOut and StdErr
;
; Author(s):       lod3n
;                  (Thanks to mrRevoked for delimiter choice and non array return selection)
;                  (Thanks to mHZ for _ProcessOpenHandle() and _ProcessGetExitCode())
;                  (MetaThanks to DaveF for posting these DllCalls in Support Forum)
;                  (MetaThanks to JPM for including CloseHandle as needed)
;
;===============================================================================

Func _RunReadStd($doscmd, $timeoutSeconds = 0, $workingdir = @ScriptDir, $flag = @SW_HIDE, $nRetVal = -1, $sDelim = @TAB)
	Local $aReturn, $i_Pid, $h_Process, $i_ExitCode, $sStdOut, $sStdErr, $runTimer
	Dim $aReturn[3]

	; run process with StdErr and StdOut flags
	$runTimer = TimerInit()
	$i_Pid = Run($doscmd, $workingdir, $flag, 6) ; 6 = $STDERR_CHILD+$STDOUT_CHILD
	$RUNNING_SCRIPT = $i_Pid
	GUICtrlSetData($Debug_gui_PID, _Get_langstr(1302) & " " & $i_Pid)
	$Dateil_Text = _Get_langstr(39) & ":" & @CRLF & $Testscript_file & @CRLF & @CRLF & _
			_Get_langstr(1302) & @CRLF & $i_Pid & @CRLF & @CRLF & _
			_Get_langstr(596) & @CRLF & $Testscript_file_parameter
	GUICtrlSetData($Debug_GUI_Details_Label, $Dateil_Text)
	; Get process handle
	Sleep(100) ; or DllCall may fail - experimental
	$h_Process = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', 0x400, 'int', 0, 'int', $i_Pid)

	$iProcessID = $i_Pid


	$hPDHQuery = _PDH_GetNewQueryHandle()
	$aCPUCounters = _PDH_GetCPUCounters($hPDHQuery, "")
	$iTotalCPUs = @extended
	; Get the localized name for "Process"
	$sProcessLocal = _PDH_GetCounterNameByIndex(230, "")

	$poCounter = _PDH_ProcessObjectCreate($sProcess, $iProcessID)
;~ 	ConsoleWrite($poCounter & @CRLF)
	_PDH_ProcessObjectAddCounters($poCounter, "6;180") ; "% Processor Time;Working Set"
	_PDH_ProcessObjectCollectQueryData($poCounter)

	; create tab delimited string containing StdOut text from process
	$aReturn[1] = ""
	$sStdOut = ""
	While 1

		_Refresh_Debug($i_Pid)
		Sleep(500)
		$line = StdoutRead($i_Pid)
		If @error Then ExitLoop
		$sStdOut &= $line
		If $line <> "" Then _ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Write_debug", $line) ;Asynchrones starten einer Func
	WEnd

	; fetch exit code and close process handle
	If IsArray($h_Process) Then
		Sleep(100) ; or DllCall may fail - experimental
		$i_ExitCode = DllCall('kernel32.dll', 'ptr', 'GetExitCodeProcess', 'ptr', $h_Process[0], 'int*', 0)
		If IsArray($i_ExitCode) Then
			$aReturn[0] = $i_ExitCode[2]
		Else
			$aReturn[0] = -1
		EndIf
		Sleep(100) ; or DllCall may fail - experimental
		DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $h_Process[0])
	Else
		$aReturn[0] = -2
	EndIf

	$aReturn[0] = $sStdOut
	$aReturn[1] = $i_ExitCode[2]
	$aReturn[2] = $i_Pid
	Return $aReturn

	; return single item if correctly specified with with $nRetVal
	If $nRetVal <> -1 And $nRetVal >= 0 And $nRetVal <= 2 Then Return $aReturn[$nRetVal]

	; return array with exit code, stdout, and stderr
	Return $aReturn
EndFunc   ;==>_RunReadStd


Func _Refresh_Debug($PID)
	If $showdebuggui = "false" Then Return
	If $PID = "" Then Return
	WinSetOnTop($minidebug_GUI_main, "", 1)
	WinSetOnTop($minidebug_GUI_sec, "", 1)
	$secs = Round(_Timer_Diff($starttime) / 1000, 2)
	If ProcessExists($PID) Then
		$array = _ProcessProperties($PID)
		If $array = "0" Then $array = "-" ;Kann Arbeitsspeicher beim Testen über den AutoIt3 Wrapper nicht anzeigen :(
		GUICtrlSetData($DEBUGGUI_TEXT, $array)
	Else
		GUICtrlSetData($DEBUGGUI_TEXT, _Get_langstr(23))
	EndIf
	GUICtrlSetData($Debug_gui_Laufzeit, _Get_langstr(105) & " " & Sec2Time($secs))
	GUICtrlSetData($Debug_GUI_Details_Laufzeit_Label, _Get_langstr(105) & " " & Sec2Time($secs))

EndFunc   ;==>_Refresh_Debug

Func Sec2Time($nr_sec = 0)
	$sec2time_hour = Int($nr_sec / 3600)
	$sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
	$sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
	Return StringFormat('%02d:%02d:%02d', $sec2time_hour, $sec2time_min, $sec2time_sec)
EndFunc   ;==>Sec2Time

Func _PDH_GetCPUCounters($hPDHQuery, $sPCName = "")
	; Strip first '\' from PC Name, if passed
	If $sPCName <> "" And StringLeft($sPCName, 2) = "\\" Then $sPCName = StringTrimLeft($sPCName, 1)
	; CPU Usage (per processor) (":238\6\(*)" or English: "\Processor(*)\% Processor Time")
	Local $aCPUsList = _PDH_GetCounterList(":238\6\(*)" & $sPCName)
	If @error Then Return SetError(@error, @extended, "")
	; start at element 1 (element 0 countains count), -1 = to-end-of-array
	Local $aCPUCounters = _PDH_AddCountersByArray($hPDHQuery, $aCPUsList, 1, -1)
	If @error Then Return SetError(@error, @extended, "")
	Return SetExtended($aCPUsList[0], $aCPUCounters)
EndFunc   ;==>_PDH_GetCPUCounters

Func _ProcessProperties($Process = "")
	If $showdebuggui = "false" Then Return
	_PDH_CollectQueryData($hPDHQuery)
	if not IsArray($aCPUCounters) then return
	Local $iCounterValue = _PDH_UpdateCounter($hPDHQuery, $aCPUCounters[UBound($aCPUCounters) - 1][1], 0, True)
	Local $aCounterVals = _PDH_ProcessObjectUpdateCounters($poCounter)
	If @error Then
		If @error = 32 Then $bProcessGone = True
	EndIf

	#cs

		$readram = ProcessGetStats ($pid,0)
		$ram = $readram[0]
		If $ram >= 1048576 Then
		$ram = StringFormat('%.3f', Round($ram / 1048576, 3)) & ' MB'
		Else
		$ram = StringFormat('%.1f', Round($ram/ 1024, 0)) & ' KB'
		EndIf

	#ce

	If IsArray($aCounterVals) Then
		$ram = StringFormat('%.3f', Round(($aCounterVals[1] / 1024) / 1000, 3)) & ' KB'
		$ram = StringReplace($ram, ".", ",")


		_MG_Wert_setzen(1, 1, Round($aCounterVals[0] / $_PDH_iCPUCount))
		_MG_Wert_setzen(2, 1, $iCounterValue)
		_MG_Wert_setzen(3, 1, Round(($aCounterVals[1] / 1024) / 1000, 3))
		_MG_Graph_plotten(1)
		_MG_Graph_plotten(2)
		_MG_Graph_plotten(3)
		GUICtrlSetData($Debug_GUI_Prozess_CPU_Label, _Get_langstr(307) & " " & Round($aCounterVals[0] / $_PDH_iCPUCount) & "%")
		GUICtrlSetData($Debug_GUI_CPU_Label, _Get_langstr(1305) & " " & $iCounterValue & " %")
		GUICtrlSetData($Debug_GUI_Prozess_RAM_Label, _Get_langstr(308) & " " & $ram)

		Return (_Get_langstr(307) & " " & Round($aCounterVals[0] / $_PDH_iCPUCount) & "%" & @CRLF & _Get_langstr(308) & " " & $ram)
	EndIf

	#cs
		$wmi = ObjGet("winmgmts:\\.\root\cimv2")
		Local $refresher = ObjCreate("WbemScripting.SWbemRefresher")
		$cols = $refresher.AddEnum($wmi, "Win32_PerfFormattedData_PerfProc_Process" ).ObjectSet
		Sleep(200)
		$refresher.Refresh
		For $proc In $cols
		If ($proc.IDProcess = $pid ) Then
		$ram = $proc.PrivateBytes
		$cpu = $proc.PercentProcessorTime

		If $ram >= 1048576 Then
		$ram = StringFormat('%.3f', Round($ram / 1048576, 3)) & ' MB'
		Else
		$ram = StringFormat('%.1f', Round($ram/ 1024, 1)) & ' KB'
		EndIf
		return (_Get_langstr(307)&" "&$cpu&"%"&"      "&_Get_langstr(308)&" "&$ram)
		EndIf
		Next
		return (_Get_langstr(23))
	#ce
EndFunc   ;==>_ProcessProperties

Func _Show_DebugGUI()
	If $showdebuggui = "false" Then Return
	$x = _ISNPlugin_Studio_Config_Read_Value("debugguiX", (@DesktopWidth - $width) - 10)
	$y = _ISNPlugin_Studio_Config_Read_Value("debugguiY", (@DesktopHeight - $height) - 40)
	If $x > @DesktopWidth - $width Then $x = (@DesktopWidth - $width) - 10
	If $y > @DesktopHeight - $height Then $y = (@DesktopHeight - $height) - 40
	WinMove($minidebug_GUI_sec, "", $x, $y)
	SetBitmap($minidebug_GUI_sec, $hImagedebug, 255)
	_WinAPI_SetLayeredWindowAttributes($minidebug_GUI_main, 0xFFFFFF)
	GUISetState(@SW_SHOW, $minidebug_GUI_main)
EndFunc   ;==>_Show_DebugGUI

Func _HIDE_DebugGUI()
	If $starte_Skripts_mit_au3Wrapper = "true" Then Return
	SetBitmap($minidebug_GUI_sec, $hImagedebug, 0)
	GUISetState(@SW_HIDE, $minidebug_GUI_main)
	$debugpos = WinGetPos($minidebug_GUI_sec)
	If IsArray($debugpos) Then
		_ISNPlugin_Studio_Config_Write_Value("debugguiX", $debugpos[0])
		_ISNPlugin_Studio_Config_Write_Value("debugguiY", $debugpos[1])
	EndIf
 EndFunc   ;==>_HIDE_DebugGUI


Func _STOPSCRIPT()
 	if $ISN_Helper_running <> 1 then return
	 $ISN_Helper_running = 0
	 ProcessClose($RUNNING_SCRIPT)
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Write_debug", @CRLF & "> " & _Get_langstr(107) & " (" & _Get_langstr(105) & " " & Round(_Timer_Diff($starttime) / 1000, 2) & " sec)" & @CRLF)
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Write_log", _Get_langstr(107), "FF0000")
	_ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_run_rule", "#ruletrigger_stopscript#")
	_ISNHelper_testscript_exit()
EndFunc   ;==>_STOPSCRIPT

Func _GUISetIcon($hHandle, $sFile, $iName)
	;Edit by isi360
	Return _SendMessage($hHandle, $WM_SETICON, 1, _WinAPI_ShellExtractIcon($sFile, $iName, 16, 16))
EndFunc   ;==>_GUISetIcon

Func _Testscript_Show_Detail_GUI()
	GUISetState(@SW_SHOW, $Debug_GUI_Extended)
	_HIDE_DebugGUI()
EndFunc   ;==>_Testscript_Show_Detail_GUI

Func _Testscript_Hide_Detail_GUI()
	GUISetState(@SW_HIDE, $Debug_GUI_Extended)
	_Show_DebugGUI()
EndFunc   ;==>_Testscript_Hide_Detail_GUI

Func _Testscript_Graph_erstellen($GUI_HANDLE = "")

	; Graph 1 erstellen (Prozess CPU)
	_MG_Graph_erstellen (1, $GUI_HANDLE, Int(60 * $DPI), Int(85 * $DPI), Int(270 * $DPI), Int(110 * $DPI))
	_MG_Graph_optionen_allgemein (1, Int((270 * $DPI) / 3), 0, 110, 0x000000, 2)
	_MG_Graph_optionen_Plottmodus (1, 1, 1, 1, True)
	_MG_Graph_optionen_Rahmen (1, False, 0x494949, 2)
	_MG_Graph_optionen_Hilfsgitterlinien (1, 1, 10, 10, 1, 0x494949, 100)
	_MG_Graph_Achse_links (1, True, 0, 110, 0, " %", $Schriftfarbe, Default, 9, 30, 0.5)
	_MG_Kanal_optionen (1, 1, 1, 2, 0x00FF00, 0)

	; Graph 2 erstellen (Gesamte CPU)
	_MG_Graph_erstellen (2, $GUI_HANDLE, Int(410 * $DPI), Int(85 * $DPI), Int(270 * $DPI), Int(110 * $DPI))
	_MG_Graph_optionen_allgemein (2, 50 * $DPI, 0, 110, 0x000000, 2)
	_MG_Graph_optionen_Plottmodus (2, 1, 1, 1, True)
	_MG_Graph_optionen_Rahmen (2, False, 0x494949, 2)
	_MG_Graph_optionen_Hilfsgitterlinien (2, 1, 10, 10, 1, 0x494949, 100)
	_MG_Graph_Achse_links (2, True, 0, 110, 0, " %", $Schriftfarbe, Default, 9, 30, 0.5)
	_MG_Kanal_optionen (2, 1, 1, 2, 0x00FF00, 0)

	; Graph 2 erstellen (RAM)
	_MG_Graph_erstellen (3, $GUI_HANDLE, Int(70 * $DPI), Int(265 * $DPI), Int(260 * $DPI), Int(110 * $DPI))
	_MG_Graph_optionen_allgemein (3, 50 * $DPI, 0, 220, 0x000000, 2)
	_MG_Graph_optionen_Plottmodus (3, 1, 1, 1, True)
	_MG_Graph_optionen_Rahmen (3, False, 0x494949, 2)
	_MG_Graph_optionen_Hilfsgitterlinien (3, 1, 10, 10, 1, 0x494949, 100)
	_MG_Graph_Achse_links (3, True, 0, 220, 0, " MB", $Schriftfarbe, Default, 9, 40, 0.5)
	_MG_Kanal_optionen (3, 1, 1, 2, 0x00FF00, 0)

	; Graph 2 mit den aktuellen Einstellungen in der GUI darstellen
	_MG_Graph_initialisieren(1)
	_MG_Graph_initialisieren(2)
	_MG_Graph_initialisieren(3)
EndFunc   ;==>_Testscript_Graph_erstellen


;==================================================================================================
; Function Name:   _ShowMonitorInfo()
; Description::    Show the info in $__MonitorList in a msgbox (line 0 is entire screen)
; Parameter(s):    n/a
; Return Value(s): n/a
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _ShowMonitorInfo()
	If $__MonitorList[0][0] == 0 Then
		_GetMonitors()
	EndIf
	Local $msg = ""
	Local $i = 0
	For $i = 0 To $__MonitorList[0][0]
		$msg &= $i & " - L:" & $__MonitorList[$i][1] & ", T:" & $__MonitorList[$i][2]
		$msg &= ", R:" & $__MonitorList[$i][3] & ", B:" & $__MonitorList[$i][4]
		If $i < $__MonitorList[0][0] Then $msg &= @CRLF
	Next
	MsgBox(0, $__MonitorList[0][0] & " Monitors: ", $msg)
EndFunc   ;==>_ShowMonitorInfo

;==================================================================================================
; Function Name:   _MaxOnMonitor($Title[, $Text = ''[, $Monitor = -1]])
; Description::    Maximize a window on a specific monitor (or the monitor the mouse is on)
; Parameter(s):    $Title   The title of the window to Move/Maximize
;     optional:    $Text    The text of the window to Move/Maximize
;     optional:    $Monitor The monitor to move to (1..NumMonitors) defaults to monitor mouse is on
; Note:            Should probably have specified return/error codes but haven't put them in yet
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _MaxOnMonitor($Title, $text = '', $Monitor = -1)
	_CenterOnMonitor($Title, $text, $Monitor)
	WinSetState($Title, $text, @SW_MAXIMIZE)
EndFunc   ;==>_MaxOnMonitor

;==================================================================================================
; Function Name:   _CenterOnMonitor($Title[, $Text = ''[, $Monitor = -1]])
; Description::    Center a window on a specific monitor (or the monitor the mouse is on)
; Parameter(s):    $Title   The title of the window to Move/Maximize
;     optional:    $Text    The text of the window to Move/Maximize
;     optional:    $Monitor The monitor to move to (1..NumMonitors) defaults to monitor mouse is on
;					$Ignore_primary Ist nur 1 wenn Monitore Identifiziert werden (dadurch wird _get_primary_monitor() übersprungen)
; Note:            Should probably have specified return/error codes but haven't put them in yet
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _CenterOnMonitor($Title, $text = '', $Monitor = -1, $Ignore_primary = 0)
	If $Monitor = -1 Then $Monitor = $Runonmonitor
	If $Immer_am_primaeren_monitor_starten = "true" And $Ignore_primary = 0 Then $Monitor = _get_primary_monitor()
	$hWindow = WinGetHandle($Title, $text)
	If $Monitor > $__MonitorList[0][0] Then $Monitor = 1
	If Not @error Then
		If $Monitor == -1 Then
			$Monitor = _GetMonitorFromPoint()
		ElseIf $__MonitorList[0][0] == 0 Then
			_GetMonitors()
		EndIf
		If ($Monitor > 0) And ($Monitor <= $__MonitorList[0][0]) Then
			; Restore the window if necessary
			Local $WinState = WinGetState($hWindow)
			If BitAND($WinState, 16) Or BitAND($WinState, 32) Then
				WinSetState($hWindow, '', @SW_RESTORE)
			EndIf
			Local $WinSize = WinGetPos($hWindow)
			Local $x = Int(($__MonitorList[$Monitor][3] - $__MonitorList[$Monitor][1] - $WinSize[2]) / 2) + $__MonitorList[$Monitor][1]
			Local $y = Int(($__MonitorList[$Monitor][4] - $__MonitorList[$Monitor][2] - $WinSize[3]) / 2) + $__MonitorList[$Monitor][2]
			WinMove($hWindow, '', $x, $y)
		EndIf
	EndIf
EndFunc   ;==>_CenterOnMonitor




Func _Get_Monitor_Resolution($Monitor = -1)
	Local $array[2]
	If $Immer_am_primaeren_monitor_starten = "true" Then $Monitor = _get_primary_monitor()
	If $Monitor = -1 Then Return
	If $Monitor > $__MonitorList[0][0] Then $Monitor = 1
	If Not @error Then
		If $Monitor == -1 Then
			$Monitor = _GetMonitorFromPoint()
		ElseIf $__MonitorList[0][0] == 0 Then
			_GetMonitors()
		EndIf
		If ($Monitor > 0) And ($Monitor <= $__MonitorList[0][0]) Then
			Local $width = Int(($__MonitorList[$Monitor][3] - $__MonitorList[$Monitor][1]) / 2) * 2
			Local $height = Int(($__MonitorList[$Monitor][4] - $__MonitorList[$Monitor][2])) + $__MonitorList[$Monitor][2]
			$array[0] = $width
			$array[1] = $height
			Return $array
		EndIf
	EndIf
EndFunc   ;==>_Get_Monitor_Resolution



;==================================================================================================
; Function Name:   _GetMonitorFromPoint([$XorPoint = -654321[, $Y = 0]])
; Description::    Get a monitor number from an x/y pos or the current mouse position
; Parameter(s):
;     optional:    $XorPoint X Position or Array with X/Y as items 0,1 (ie from MouseGetPos())
;     optional:    $Y        Y Position
; Note:            Should probably have specified return/error codes but haven't put them in yet,
;                  and better checking should be done on passed variables.
;                  Used to use MonitorFromPoint DLL call, but it didn't seem to always work.
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _GetMonitorFromPoint($XorPoint = 0, $y = 0)
	If @NumParams = 0 Then
		Local $MousePos = MouseGetPos()
		Local $myX = $MousePos[0]
		Local $myY = $MousePos[1]
	ElseIf (@NumParams = 1) And IsArray($XorPoint) Then
		Local $myX = $XorPoint[0]
		Local $myY = $XorPoint[1]
	Else
		Local $myX = $XorPoint
		Local $myY = $y
	EndIf
	If $__MonitorList[0][0] == 0 Then
		_GetMonitors()
	EndIf
	Local $i = 0
	Local $Monitor = 0
	For $i = 1 To $__MonitorList[0][0]
		If ($myX >= $__MonitorList[$i][1]) _
				And ($myX < $__MonitorList[$i][3]) _
				And ($myY >= $__MonitorList[$i][2]) _
				And ($myY < $__MonitorList[$i][4]) Then $Monitor = $i
	Next
	Return $Monitor
EndFunc   ;==>_GetMonitorFromPoint

;==================================================================================================
; Function Name:   _GetMonitors()
; Description::    Load monitor positions
; Parameter(s):    n/a
; Return Value(s): 2D Array of Monitors
;                       [0][0] = Number of Monitors
;                       [i][0] = HMONITOR handle of this monitor.
;                       [i][1] = Left Position of Monitor
;                       [i][2] = Top Position of Monitor
;                       [i][3] = Right Position of Monitor
;                       [i][4] = Bottom Position of Monitor
; Note:            [0][1..4] are set to Left,Top,Right,Bottom of entire screen
;                  hMonitor is returned in [i][0], but no longer used by these routines.
;                  Also sets $__MonitorList global variable (for other subs to use)
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _GetMonitors()
	$__MonitorList[0][0] = 0 ;  Added so that the global array is reset if this is called multiple times
	Local $handle = DllCallbackRegister("_MonitorEnumProc", "int", "hwnd;hwnd;ptr;lparam")
	DllCall("user32.dll", "int", "EnumDisplayMonitors", "hwnd", 0, "ptr", 0, "ptr", DllCallbackGetPtr($handle), "lparam", 0)
	DllCallbackFree($handle)
	Local $i = 0
	For $i = 1 To $__MonitorList[0][0]
		If $__MonitorList[$i][1] < $__MonitorList[0][1] Then $__MonitorList[0][1] = $__MonitorList[$i][1]
		If $__MonitorList[$i][2] < $__MonitorList[0][2] Then $__MonitorList[0][2] = $__MonitorList[$i][2]
		If $__MonitorList[$i][3] > $__MonitorList[0][3] Then $__MonitorList[0][3] = $__MonitorList[$i][3]
		If $__MonitorList[$i][4] > $__MonitorList[0][4] Then $__MonitorList[0][4] = $__MonitorList[$i][4]
	Next
	Return $__MonitorList
EndFunc   ;==>_GetMonitors


;============================================================================================== _NumberAndNameMonitors
; Function Name:    _NumberAndNameMonitors ()
; Description:   Provides the first key elements of a multimonitor system, included the Regedit Keys
; Parameter(s):   None
; Return Value(s):   $NumberAndName [][]
;~        [0][0] total number of video devices
;;       [x][1] name of the device
;;       [x][2] name of the adapter
;;       [x][3] monitor flags (value is returned in Hex str -convert in DEC before use with Bitand)
;;       [x][4] registry key of the device
; Remarks:   the flag value [x][3] can be one of the following
;;       DISPLAY_DEVICE_ATTACHED_TO_DESKTOP  0x00000001
;;             DISPLAY_DEVICE_MULTI_DRIVER       0x00000002
;;            DISPLAY_DEVICE_PRIMARY_DEVICE    0x00000004
;;            DISPLAY_DEVICE_VGA               0x00000010
;;        DISPLAY_MIRROR_DEVICE  0X00000008
;;        DISPLAY_REMOVABLE  0X00000020
;
; Author(s):        Hermano
;===========================================================================================================================
Func _get_primary_monitor()
	Local $aScreenResolution = _DesktopDimensions()
	If Not IsArray($aScreenResolution) Then Return 1
	Return _GetMonitorFromPoint(($aScreenResolution[1] / 2), ($aScreenResolution[2] / 2))
EndFunc   ;==>_get_primary_monitor


;==================================================================================================
; Function Name:   _MonitorEnumProc($hMonitor, $hDC, $lRect, $lParam)
; Description::    Enum Callback Function for EnumDisplayMonitors in _GetMonitors
; Author(s):       xrxca (autoit@forums.xrx.ca)
;==================================================================================================

Func _MonitorEnumProc($hMonitor, $hDC, $lRect, $lParam)
	Local $Rect = DllStructCreate("int left;int top;int right;int bottom", $lRect)
	$__MonitorList[0][0] += 1
	ReDim $__MonitorList[$__MonitorList[0][0] + 1][5]
	$__MonitorList[$__MonitorList[0][0]][0] = $hMonitor
	$__MonitorList[$__MonitorList[0][0]][1] = DllStructGetData($Rect, "left")
	$__MonitorList[$__MonitorList[0][0]][2] = DllStructGetData($Rect, "top")
	$__MonitorList[$__MonitorList[0][0]][3] = DllStructGetData($Rect, "right")
	$__MonitorList[$__MonitorList[0][0]][4] = DllStructGetData($Rect, "bottom")
	Return 1 ; Return 1 to continue enumeration
EndFunc   ;==>_MonitorEnumProc

; #FUNCTION# ====================================================================================================================
; Name ..........: _DesktopDimensions
; Description ...: Returns an array containing information about the primary and virtual monitors.
; Syntax ........: _DesktopDimensions()
; Return values .: Success - Returns a 6-element array containing the following information:
;                  $aArray[0] = Total number of monitors.
;                  $aArray[1] = Width of the primary monitor.
;                  $aArray[2] = Height of the primary monitor.
;                  $aArray[3] = Total width of the desktop including the width of multiple monitors. Note: If no secondary monitor this will be the same as $aArray[2].
;                  $aArray[4] = Total height of the desktop including the height of multiple monitors. Note: If no secondary monitor this will be the same as $aArray[3].
; Author ........: guinness
; Remarks .......: WinAPI.au3 must be included i.e. #include <WinAPI.au3>
; Related .......: @DesktopWidth, @DesktopHeight, _WinAPI_GetSystemMetrics
; Example .......: Yes
; ===============================================================================================================================
Func _DesktopDimensions()
	Local $aReturn = [_WinAPI_GetSystemMetrics($SM_CMONITORS), _ ; Number of monitors.
			_WinAPI_GetSystemMetrics($SM_CXSCREEN), _ ; Width or Primary monitor.
			_WinAPI_GetSystemMetrics($SM_CYSCREEN), _ ; Height or Primary monitor.
			_WinAPI_GetSystemMetrics($SM_CXVIRTUALSCREEN), _ ; Width of the Virtual screen.
			_WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN)] ; Height of the Virtual screen.
	Return $aReturn
EndFunc   ;==>_DesktopDimensions


Func WM_GETMINMAXINFO($hWnd, $msg, $wParam, $lParam)

	$tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)

	Switch $hWnd


	    Case $Changelog_GUI
			DllStructSetData($tagMaxinfo, 7, $Changelog_GUI_width)
			DllStructSetData($tagMaxinfo, 8, $Changelog_GUI_height)

		Case $Update_GUI
			DllStructSetData($tagMaxinfo, 7, $Programmupdate_width)
			DllStructSetData($tagMaxinfo, 8, $Programmupdate_height)

		Case Else
			DllStructSetData($tagMaxinfo, 7, $GUIMINWID) ; min X
			DllStructSetData($tagMaxinfo, 8, $GUIMINHT) ; min Y

	EndSwitch


	Return 0
 EndFunc   ;==>WM_GETMINMAXINFO

Func _ISN_Helper_Nach_Updates_Suchen($Mode = "")
   	GUICtrlSetData($update_newversion, _Get_langstr(334) & " " & _Get_langstr(335))
	GUICtrlSetData($update_prgressbarlabel, "0 %")
	GUICtrlSetData($update_prgressbar, 0)
	GUICtrlSetData($update_log, "")
	GUICtrlSetData($update_status, _Get_langstr(338))
	GUICtrlSetColor($update_status, $Schriftfarbe)
	GUICtrlSetColor($update_currentversion, $Schriftfarbe)
	GUICtrlSetColor($update_newversion, $Schriftfarbe)
	GUICtrlSetState($update_gobutton, $GUI_DISABLE)
	GUICtrlSetState($update_changelog_button, $GUI_DISABLE)
	guictrlsetstate($Loading_logo, $GUI_SHOW)
	GUICtrlSetImage($Loading_logo, $Loading2_Ani)
	Button_AddIcon($update_cancelbutton, $smallIconsdll, 1173, 0)
	GUICtrlSetData($update_cancelbutton, _Get_langstr(8))
    GUICtrlSetData($update_currentversion,_Get_langstr(333) & " " & $Studioversion & " (" & $VersionBuild & ")")
    GUICtrlSetData($Update_gefunden_GUI_aktuelle_Version,_Get_langstr(333) & " " & $Studioversion & " (" & $VersionBuild & ")")
   if $Mode = "normal" Then  GUISetState(@SW_SHOW,$Update_GUI)

   $result = _Beginne_Suche_nach_updates()
   if $Mode <> "normal" Then
	  if $result = 1 then  GUISetState(@SW_SHOW, $Update_gefunden_GUI) ;new update found
	  if $result = 2 OR $result = 0 then _ISNHelper_Updater_exit() ;no new update
   endif

EndFunc

Func _ISN_Helper_Neues_Update_Gefunden_Show_Update_GUI()
   GUISetState(@SW_HIDE,$Update_gefunden_GUI)
   GUISetState(@SW_SHOW,$Update_GUI)
EndFunc


Func _Directory_Is_Accessible($sPath)
	If Not StringInStr(FileGetAttrib($sPath), "D", 2) Then Return SetError(1, 0, 0)
	Local $iEnum = 0
	While FileExists($sPath & "\_test_" & $iEnum)
		$iEnum += 1
	WEnd
	Local $iSuccess = DirCreate($sPath & "\_test_" & $iEnum)
	Switch $iSuccess
		Case 1
			DirRemove($sPath & "\_test_" & $iEnum)
			Return True
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>_Directory_Is_Accessible

func _Debug_zur_ISN_Konsole($String="",$level=2,$break=1,$notime=0,$notitle=0,$Category="")
   if $String = "" then return
   return _ISNPlugin_Call_Async_Function_in_ISN_AutoIt_Studio("_Write_ISN_Debug_Console",$String,$level,$break,$notime,$notitle,$Category)
EndFunc

func _Set_Proxyserver()
	if $Use_Proxy = "true" Then
		if $proxy_PW = "" then
			$pw = ""
		else
			$pw = BinaryToString(_Crypt_DecryptData ($proxy_PW, "Isn_pRoxy_PW", $CALG_RC4))
;~ 			$pw = _StringEncrypt(0, $proxy_PW, "Isn_pRoxy_PW", 2)
		EndIf
		FtpSetProxy(2, $proxy_server & ":" & $proxy_port, $proxy_username, $pw)
		HttpSetProxy(2, $proxy_server & ":" & $proxy_port, $proxy_username, $pw)
	Else
		FtpSetProxy(0)
		HttpSetProxy(0)
	EndIf
endfunc