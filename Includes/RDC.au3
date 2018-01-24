#Region Header

#cs

    Title:          RDC (Read Directory Changes) Wrapper UDF Library for AutoIt3
    Filename:       RDC.au3
    Description:    Assists to monitoring file system for changes
    Author:         Yashied
    Version:        1.0
    Requirements:   AutoIt v3.3.x.x, Developed/Tested on Windows XP Pro Service Pack 2 and Windows 7
    Uses:           None
    Notes:          This library requires RDC.dll/RDC_x64.dll (v1.0.x.x)

                    Link to download:

                        http://www.autoitscript.com/forum/topic/167024-rdc-udf-readdirectorychanges-wrapper/

    Available functions:

        _RDC_CloseDll
        _RDC_Create
        _RDC_Delete
        _RDC_Destroy
        _RDC_EnumRDC
        _RDC_GetCount
        _RDC_GetData
        _RDC_GetDirectory
        _RDC_GetRDCInfo
        _RDC_OpenDll
        _RDC_Resume

    Error codes:

        @Error:

        0 - No error
        1 - DLL not loaded or already loaded
        2 - DLL not found
        3 - Incompatible DLL version
        4 - Unable to load DLL
        5 - Invalid parameter(s)
        6 - Directory not found
        7 - DllCall() error

        @Extended:

        The calling thread's last-error code, ERROR_* (returns only _RDC_Create() and _RDC_GetData() functions)

    Example:

        RDC_Ex_*.au3

#ce

#Include-once

#EndRegion Header

#Region Global Variables and Constants

#cs

Global Const $FILE_NOTIFY_CHANGE_FILE_NAME = 0x0001
Global Const $FILE_NOTIFY_CHANGE_DIR_NAME = 0x0002
Global Const $FILE_NOTIFY_CHANGE_ATTRIBUTES = 0x0004
Global Const $FILE_NOTIFY_CHANGE_SIZE = 0x0008
Global Const $FILE_NOTIFY_CHANGE_LAST_WRITE = 0x0010
Global Const $FILE_NOTIFY_CHANGE_LAST_ACCESS = 0x0020
Global Const $FILE_NOTIFY_CHANGE_CREATION = 0x0040
Global Const $FILE_NOTIFY_CHANGE_SECURITY = 0x0100

Global Const $FILE_ACTION_ADDED = 0x0001
Global Const $FILE_ACTION_REMOVED = 0x0002
Global Const $FILE_ACTION_MODIFIED = 0x0003
Global Const $FILE_ACTION_RENAMED_OLD_NAME = 0x0004
Global Const $FILE_ACTION_RENAMED_NEW_NAME = 0x0005

#ce

Global Const $WM_RDC = 0xA000

#EndRegion Global Variables and Constants

#Region Local Variables and Constants

Global Const $tagRDC_BUFFER = 'ptr Raw;uint Length;bool Ready;bool Wait;int Error;'

Global $_rdc_Data[100][5]
Global $_rdc_Dll = -1

#cs

WARNING: DO NOT CHANGE THIS ARRAY, FOR INTERNAL USE ONLY!

$_rdc_Data[i][0] - ID of the thread (RDC)
          [i][1] - The directory path that is monitored
          [i][2] - RDC_BUFFER structure
          [i][3] - A pointer to the raw data (FNI)
          [i][4] - Reserved

#ce

#EndRegion Local Variables and Constants

#Region Initialization

;~OnAutoItExitRegister('_rdc_Exit')

For $i = 0 To UBound($_rdc_Data) - 1
	$_rdc_Data[$i][0] = -1
Next

#EndRegion Initialization

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_CloseDll
; Description....: Closes a RDC.dll when it's no longer needed.
; Syntax.........: _RDC_CloseDll ( )
; Parameters.....: None
; Return values..: Success - 1.
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library).
; Author.........: Yashied
; Modified.......:
; Remarks........: Before closing DLL delete all RDC threads by using the _RDC_Delete() or _RDC_Destroy() function.
;
; Related........: _RDC_OpenDll
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_CloseDll()
	If Not _rdc_Verify(0, 1) Then
		Return SetError(@Error, 0, 0)
	EndIf
	_RDC_Destroy()
	DllClose($_rdc_Dll)
	Return 1
EndFunc   ;==>_RDC_CloseDll

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_Create
; Description....: Creates RDC thread to retrieve information that describes the changes within the specified directory.
; Syntax.........: _RDC_Create ( $sDir, $fSubtree, $iFilter [, $fWait = 0 [, $hWnd = 0 [, $wParam = 0]]] )
; Parameters.....: $sDir     - The path to the root directory to be monitored. If possible, always specify the full path to the directory.
;                              Also, the function supports the Universal Naming Convention (UNC) path.
;                  $fSubtree - Specifies whether monitors the directory tree rooted at the specified directory, valid values:
;                  |TRUE  - The function monitors all subdirectories in the root directory.
;                  |FALSE - The function monitors only root directory.
;                  $iFilter  - The filter criteria that the function checks to determine whether the event occurred.
;                              This parameter can be one or more of the following values.
;
;                              $FILE_NOTIFY_CHANGE_FILE_NAME (0x0001)
;                              $FILE_NOTIFY_CHANGE_DIR_NAME (0x0002)
;                              $FILE_NOTIFY_CHANGE_ATTRIBUTES (0x0004)
;                              $FILE_NOTIFY_CHANGE_SIZE (0x0008)
;                              $FILE_NOTIFY_CHANGE_LAST_WRITE (0x0010)
;                              $FILE_NOTIFY_CHANGE_LAST_ACCESS (0x0020)
;                              $FILE_NOTIFY_CHANGE_CREATION (0x0040)
;                              $FILE_NOTIFY_CHANGE_SECURITY (0x0100)
;
;                  $fWait    - Specifies whether creates RDC thread in suspended state, valid values:
;                  |TRUE  - The thread creates in suspended state, and does not run until the _RDC_Resume() function is called.
;                  |FALSE - The thread runs immediately if the function succeeds. (Default)
;                  $hWnd     - A handle to the window to receiving WM_RDC (0xA000) messages from RDC thread when the changes occured.
;                              If this parameter is not specified or 0, the message will not be sent. In this case, notice may be
;                              received only in loop mode (see remarks).
;                  $wParam   - The value that RDC thread passes to the window callback function known as "wParam". This parameter
;                              is ignored if the window handle is not specified.
; Return values..: Success   - The identifier (ID) of the newly created RDC thread. This ID is used to calling other functions from this
;                              UDF library, e.g. _RDC_GetData() or _RDC_Delete().
;                  Failure   - (-1) and sets @Error flag to non-zero (see description of the library), @Extended flag may contain the ERROR_* error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: _RDC_Create() creates a new RDC thread for each function call associated with the specified directory. This threads will
;                  live until it's closed by using the _RDC_Delete() or _RDC_Destroy() function, and can not be suspended and resumed
;                  within a script.
;
;                  After the RDC thread has been successfully created, you can receiving information about the changes within the
;                  specified directory in two ways - loop or notification (preferred) modes.
;
;                  In the case of using loop mode, you must call the _RDC_GetData() function in a loop to obtain information about the
;                  changes. Important that the _RDC_GetData() was called as quickly as possible because each call of this function frees the
;                  internal buffer. If was no changes in directory when _RDC_GetData() is called, the function returns an empty array.
;                  If an error occurs, _RDC_GetData() will return an error code (ERROR_*) until the thread will not be deleted by
;                  calling the _RDC_Delete() function.
;
;                  In the case of using notification mode, you must first register the window callback function which will be receive
;                  information about the changes via WM_RDC messages. The "wParam" contains the value is specified in the _RDC_Create()
;                  function, "lParam" contains ID of the RDC thread that sent the message. WM_RDC messages are sent via PostMessage()
;                  function. In response to each WM_RDC message received, you must call the _RDC_GetData() function to obtain the
;                  appropriate data. If _RDC_GetData() returns an error, you must complete the work with this RDC thread and delete
;                  it (if necessary). This RDC thread will no longer send WM_RDC messages.
;
;                  It's important to note that by default RDC thread runs immediately. Sometimes it may be necessary to delay the
;                  start of RDC thread, for example if you want to prepare a GUI for displaying results of monitoring. In this case,
;                  you need to create a thread in suspended state (see above) and then call the _RDC_Resume() function to start
;                  monitoring. For example:
;
;                  $ID = _RDC_Create($sDir, True, $iFilter, False)
;                  If @Error Then
;                      Exit
;                  EndIf
;
;                  ; Create GUI for displaying changes
;
;                  _RDC_Resume($ID)
;
;                  _RDC_Create() supports hot (unsafe) unplugging of removable devices such as USB flash drive, etc. Typically in this
;                  case, _RDC_GetData() returns ERROR_INVALID_HANDLE (6), and RDC thread goes into idle mode until it's deleted by
;                  calling the _RDC_Delete() function.
;
;                  When the RDC thread is no longer needed, delete it using the _RDC_Delete() function. You can call this function at
;                  any time.
;
; Related........: _RDC_Delete, _RDC_Destroy, _RDC_Resume
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_Create($sDir, $fSubtree, $iFilter, $fWait = 0, $hWnd = 0, $wParam = 0)
	If Not _rdc_Verify(0, 1) Then
		Return SetError(@Error, 0, -1)
	EndIf

	Local $ID, $Length, $Result

	If (Not FileExists($sDir)) Or (Not StringInStr(FileGetAttrib($sDir), 'D')) Then
		Return SetError(6, 0, -1)
	EndIf
	$ID = 0
	$Length = UBound($_rdc_Data)
	While 1
		If $ID = $Length Then
			ReDim $_rdc_Data[$Length + 100][UBound($_rdc_Data, 2)]
			For $i = $ID To UBound($_rdc_Data) - 1
				$_rdc_Data[$i][0] = -1
			Next
			ExitLoop
		EndIf
		If $_rdc_Data[$ID][0] = -1 Then
			ExitLoop
		EndIf
		$ID += 1
	Wend
	$Length = 1048576
	$Result = DllCall('kernel32.dll', 'uint', 'GetDriveTypeW', 'wstr', $sDir & '\')
	If @Error Then

	Else
		Switch $Result[0]
			Case 4 ; DRIVE_REMOTE
				$Length = 65536
			Case Else

		EndSwitch
	EndIf
	$_rdc_Data[$ID][1] = $sDir
	$_rdc_Data[$ID][2] = DllStructCreate($tagRDC_BUFFER & 'byte FNI[' & $Length & ']')
	$_rdc_Data[$ID][3] = DllStructGetPtr($_rdc_Data[$ID][2], 'FNI')
	DllStructSetData($_rdc_Data[$ID][2], 'Raw', $_rdc_Data[$ID][3])
	DllStructSetData($_rdc_Data[$ID][2], 'Length', $Length)
	DllStructSetData($_rdc_Data[$ID][2], 'Ready', 0)
	DllStructSetData($_rdc_Data[$ID][2], 'Wait', _rdc_Int($fWait))
	DllStructSetData($_rdc_Data[$ID][2], 'Error', 0)
	$_rdc_Data[$ID][4] = 0
	$Result = DllCall($_rdc_Dll, 'int', 'RDC_Create', 'wstr', $sDir, 'uint', $fSubtree, 'uint', $iFilter, 'ptr', DllStructGetPtr($_rdc_Data[$ID][2]), 'hwnd', $hWnd, 'uint', $WM_RDC, 'wparam', $wParam)
	If (@Error) Or ($Result[0] = -1) Then
		$_rdc_Data[$ID][2] = 0
		$Result = DllCall('kernel32.dll', 'dword', 'GetLastError')
;~		If @Error Then

;~		EndIf
		Return SetError(7, $Result[0], -1)
	EndIf
	$_rdc_Data[$ID][0] = $Result[0]
	Return $ID
EndFunc   ;==>_RDC_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_Delete
; Description....: Deletes the specified RDC thread and releases all resources used by it.
; Syntax.........: _RDC_Delete ( $iID )
; Parameters.....: $iID    - The identifier (ID) of the RDC thread which has returned the _RDC_Create() function.
; Return values..: Success - 1.
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library).
; Author.........: Yashied
; Modified.......:
; Remarks........: _RDC_Delete() must be called for all unused RDC threads that have been created by the _RDC_Create() function.
;
;                  To delete all created RDC threads, use the _RDC_Destroy() function.
;
; Related........: _RDC_Create, _RDC_Destroy, _RDC_Resume
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_Delete($iID)
	If Not _rdc_Verify($iID) Then
		Return SetError(@Error, 0, 0)
	EndIf

	Local $Result = DllCall($_rdc_Dll, 'int', 'RDC_Delete', 'int', $_rdc_Data[$iID][0])

	If (@Error) Or (Not $Result[0]) Then
		Return SetError(7, 0, 0)
	EndIf
	$_rdc_Data[$iID][0] =-1
	$_rdc_Data[$iID][2] = 0
	Return 1
EndFunc   ;==>_RDC_Delete

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_Destroy
; Description....: Deletes all previously created RDC threads and releases the resources they use.
; Syntax.........: _RDC_Destroy ( )
; Parameters.....: None
; Return values..: Success - 1.
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library).
; Author.........: Yashied
; Modified.......:
; Remarks........: A good idea to call the _RDC_Destroy() function before exiting the script.
;
; Related........: _RDC_Create, _RDC_Delete, _RDC_Resume
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_Destroy()
	If Not _rdc_Verify(0, 1) Then
		Return SetError(@Error, 0, 0)
	EndIf
	For $i = 0 To UBound($_rdc_Data) - 1
		If $_rdc_Data[$i][0] <> -1 Then
			_RDC_Delete($i)
		EndIf
	Next
	Return 1
EndFunc   ;==>_RDC_Destroy

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_EnumRDC
; Description....: Enumerates state information about all previously created RDC threads.
; Syntax.........: _RDC_EnumRDC ( )
; Parameters.....: None
; Return values..: Success - The 2D array containing the following information:
;
;                            [0][0] - Number of RDC threads in array (n)
;                            [0][i] - Unused
;
;                            [n][0] - A pointer to the internal buffer containing FILE_NOTIFY_INFORMATION structure.
;                            [n][1] - The size of the internal buffer, in bytes (65536 for network drive and 1048576 otherwise).
;                            [n][2] - The flag of the synchronization status (TRUE or FALSE).
;                            [n][3] - The flag of the suspension status (TRUE or FALSE).
;                            [n][4] - The last-error code (ERROR_*).
;
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library).
; Author.........: Yashied
; Modified.......:
; Remarks........: _RDC_EnumRDC() can be useful for advanced users only, since the data returned by this function contains internal
;                  information which typically is not used in the script.
;
; Related........: _RDC_GetRDCInfo
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_EnumRDC()
	If Not _rdc_Verify(0, 1) Then
		Return SetError(@Error, 0, 0)
	EndIf

	Local $aData[101][5] = [[0]]
	Local $aInfo

	For $i = 0 To UBound($_rdc_Data) - 1
		$aInfo = _RDC_GetRDCInfo($i)
		If Not @Error Then
			_rdc_Inc($aData)
			For $j = 0 To 4
				$aData[$aData[0][0]][$j] = $aInfo[$j]
			Next
		EndIf
	Next
	_rdc_Inc($aData, -1)
	Return $aData
EndFunc   ;==>_RDC_EnumRDC

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_GetCount
; Description....: Returns the number of all previously created RDC threads.
; Syntax.........: _RDC_GetCount ( )
; Parameters.....: None
; Return values..: Success - The number of active RDC threads.
;                  Failure - (-1) and sets @Error flag to non-zero (see description of the library).
; Author.........: Yashied
; Modified.......:
; Remarks........: _RDC_GetCount() returns the number of all RDC threads that have been created by the _RDC_Create() function.
;
; Related........: _RDC_GetData, _RDC_GetDirectory
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_GetCount()
	If Not _rdc_Verify(0, 1) Then
		Return SetError(@Error, 0, -1)
	EndIf

	Local $Count = 0

	For $i = 0 To UBound($_rdc_Data) - 1
		If $_rdc_Data[$i][0] <> -1 Then
			$Count += 1
		EndIf
	Next
	Return $Count
EndFunc   ;==>_RDC_GetCount

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_GetData
; Description....: Reads an information on changes within the directory that associated with the specified RDC thread.
; Syntax.........: _RDC_GetData ( $iID )
; Parameters.....: $iID    - The identifier (ID) of the RDC thread which has returned the _RDC_Create() function.
; Return values..: Success - The 2D array containing the following information:
;
;                            [0][0] - Number of RDC events in array (n)
;                            [0][1] - Unused
;
;                            [n][0] - The type of change that has occurred, it can be only one of the following values.
;
;                                     $FILE_ACTION_ADDED (0x0001)
;                                     $FILE_ACTION_REMOVED (0x0002)
;                                     $FILE_ACTION_MODIFIED (0x0003)
;                                     $FILE_ACTION_RENAMED_OLD_NAME (0x0004)
;                                     $FILE_ACTION_RENAMED_NEW_NAME (0x0005)
;
;                            [n][1] - The file name relative to the root directory.
;
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library), @Extended flag may contain the ERROR_* error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: _RDC_GetData() works synchronously with the RDC thread, and until this function will not be called the next data
;                  will not be obtained. Moreover, _RDC_GetData() frees the internal buffer, that is why the function should be called
;                  as quickly as possible (in loop mode). In notification mode _RDC_GetData() is usually called in response to each
;                  WM_RDC message. If was no changes in monitored directory when _RDC_GetData() is called or RDC thread is in
;                  suspended state, the function returns an empty array (zeroth array element is 0).
;
;                  All data about the changes of file or subdirectory in the root directory comes one after another but the number and
;                  sequence of events depends on the filter criteria that was specified in the _RDC_Create() function. For more
;                  information, see description of the _RDC_Create() function.
;
; Related........: _RDC_GetCount, _RDC_GetDirectory
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_GetData($iID)
	If Not _rdc_Verify($iID) Then
		Return SetError(@Error, 0, 0)
	EndIf

	Local $aData[1][2] = [[0]]
	Local $Error = DllStructGetData($_rdc_Data[$iID][2], 'Error')
	Local $Length = 0, $Offset = 0
	Local $tFNI

	If $Error Then
		Return SetError(7, $Error, 0)
	EndIf
	If Not DllStructGetData($_rdc_Data[$iID][2], 'Ready') Then
		Return $aData
	EndIf
	Do
		$Length += $Offset
		$tFNI = DllStructCreate('dword;dword;dword;wchar[' & (DllStructGetData(DllStructCreate('dword', $_rdc_Data[$iID][3] + $Length + 8), 1) / 2) & ']', $_rdc_Data[$iID][3] + $Length)
		_rdc_Inc($aData)
		$aData[$aData[0][0]][0] = DllStructGetData($tFNI, 4)
		$aData[$aData[0][0]][1] = DllStructGetData($tFNI, 2)
		$Offset = DllStructGetData($tFNI, 1)
	Until Not $Offset
	DllStructSetData($_rdc_Data[$iID][2], 'Ready', 0)
	_rdc_Inc($aData, -1)
	Return $aData
EndFunc   ;==>_RDC_GetData

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_GetDirectory
; Description....: Returns the path to the monitored directory that associated with the specified RDC thread.
; Syntax.........: _RDC_GetDirectory ( $iID )
; Parameters.....: $iID    - The identifier (ID) of the RDC thread which has returned the _RDC_Create() function.
; Return values..: Success - The path to the root directory.
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library), @Extended flag may contain the ERROR_* error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: _RDC_GetDirectory() returns the same path that was specified when calling the _RDC_Create() function. Typically, this
;                  function can be useful when using the notifications mode.
;
; Related........: _RDC_GetCount, _RDC_GetData
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_GetDirectory($iID)
	If Not _rdc_Verify($iID) Then
		Return SetError(@Error, 0, 0)
	EndIf
	Return $_rdc_Data[$iID][1]
EndFunc   ;==>_RDC_GetDirectory

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_GetRDCInfo
; Description....: Returns state information about the specified RDC thread.
; Syntax.........: _RDC_GetRDCInfo ( $iID )
; Parameters.....: $iID    - The identifier (ID) of the RDC thread which has returned the _RDC_Create() function.
; Return values..: Success - The array containing the following information:
;
;                            [0] - A pointer to the internal buffer containing FILE_NOTIFY_INFORMATION structure.
;                            [1] - The size of the internal buffer, in bytes (65536 for network drive and 1048576 otherwise).
;                            [2] - The flag of the synchronization status (TRUE or FALSE).
;                            [3] - The flag of the suspension status (TRUE or FALSE).
;                            [4] - The last-error code (ERROR_*).
;
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library).
; Author.........: Yashied
; Modified.......:
; Remarks........: _RDC_GetRDCInfo() can be useful for advanced users only, since the data returned by this function contains internal
;                  information which typically is not used in the script.
;
; Related........: _RDC_EnumRDC
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_GetRDCInfo($iID)
	If Not _rdc_Verify($iID) Then
		Return SetError(@Error, 0, 0)
	EndIf

	Local $aInfo[5]

	$aInfo[0] = DllStructGetData($_rdc_Data[$iID][2], 'Raw')
	$aInfo[1] = DllStructGetData($_rdc_Data[$iID][2], 'Length')
	$aInfo[2] = DllStructGetData($_rdc_Data[$iID][2], 'Ready')
	$aInfo[3] = DllStructGetData($_rdc_Data[$iID][2], 'Wait')
	$aInfo[4] = DllStructGetData($_rdc_Data[$iID][2], 'Error')
	Return $aInfo
EndFunc   ;==>_RDC_GetRDCInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_OpenDll
; Description....: Opens RDC.dll to use in this library.
; Syntax.........: _RDC_OpenDll ( [$sDLL = ''] )
; Parameters.....: $sDLL   - The path to the DLL file to open. By default is used RDC.dll for 32-bit and RDC_x64.dll for 64-bit
;                            processes from directory containing the running script.
; Return values..: Success - 1.
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library).
; Author.........: Yashied
; Modified.......:
; Remarks........: Note that 64-bit executables cannot load 32-bit DLLs and vice-versa, use the appropriate DLL version.
;
; Related........: _RDC_CloseDll
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_OpenDll($sDLL = '')
	If $_rdc_Dll <>-1 Then
		Return SetError(1, 0, 0)
	EndIf
	If Not $sDLL Then
		If @AutoItX64 Then
			$sDLL = @ScriptDir & '\Data\RDC_x64.dll'
		Else
			$sDLL = @ScriptDir & '\Data\RDC.dll'
		EndIf
	EndIf
	If Not FileExists($sDLL) Then
		Return SetError(2, 0, 0)
	EndIf
	If StringCompare(StringRegExpReplace(FileGetVersion($sDLL), '(\d+\.\d+).*', '\1'), '1.0') Then
		Return SetError(3, 0, 0)
	EndIf
	$_rdc_Dll = DllOpen($sDLL)
	If $_rdc_Dll = -1 Then
		Return SetError(4, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_RDC_OpenDll

; #FUNCTION# ====================================================================================================================
; Name...........: _RDC_Resume
; Description....: Resumes execution of the specified RDC thread to start monitoring.
; Syntax.........: _RDC_Resume ( $iID )
; Parameters.....: $iID    - The identifier (ID) of the RDC thread which has returned the _RDC_Create() function.
; Return values..: Success - 1.
;                  Failure - 0 and sets @Error flag to non-zero (see description of the library).
; Author.........: Yashied
; Modified.......:
; Remarks........: _RDC_Resume() makes sense to call only if the specified RDC thread has been created in suspended state.
;                  The function can be called at any time and only once. All subsequent calls will not give any results and did not
;                  return an error. For more information, see description of the _RDC_Create() function.
;
; Related........: _RDC_Create, _RDC_Delete, _RDC_Destroy
; Link...........:
; Example........:
; ===============================================================================================================================

Func _RDC_Resume($iID)
	If Not _rdc_Verify($iID) Then
		Return SetError(@Error, 0, 0)
	EndIf
	DllStructSetData($_rdc_Data[$iID][2], 'Wait', 0)
	Return 1
EndFunc   ;==>_RDC_Resume

#EndRegion Public Functions

#Region Internal Functions

Func _rdc_Inc(ByRef $aData, $iIncrement = 100)
	If $iIncrement < 0 Then
		ReDim $aData[$aData[0][0] + 1][UBound($aData, 2)]
	Else
		$aData[0][0] += 1
		If $aData[0][0] > UBound($aData) - 1 Then
			ReDim $aData[$aData[0][0] + $iIncrement][UBound($aData, 2)]
		EndIf
	EndIf
EndFunc   ;==>_rdc_Inc

Func _rdc_Int($vValue)
	If $vValue Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_rdc_Int

Func _rdc_Verify($iID, $iFlags = 0x03)
	If BitAND($iFlags, 0x01) Then
		If $_rdc_Dll = -1 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	If BitAND($iFlags, 0x02) Then
		If ($iID < 0) Or ($iID > UBound($_rdc_Data)) Or ($_rdc_Data[$iID][0] = -1) Then
			Return SetError(5, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_rdc_Verify

#EndRegion Internal Functions

#Region AutoIt Exit Functions

Func _rdc_Exit()
	_RDC_Destroy()
EndFunc   ;==>_rdc_Exit

#EndRegion AutoIt Exit Functions
