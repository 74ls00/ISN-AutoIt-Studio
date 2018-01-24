;addons.au3
Global $aINM[1]
; #FUNCTION# =============================================================================================
; Name...........: _ExtractIconToFile
; Description ...: Extract an icon resource from a cpl, dll, exe, icl, ocx to a *.ico file
; Syntax.........: _ExtractIconToFile($sInFile, $iIcon, $sOutIco[, $iPath = 0])
; Parameters ....: $sInFile - Path to file that contains the icon to extract.
;                  $iIcon   - Icon Number to extract, eg; -1 (The first icon starts at -1)
;                  $sOutIco - Full path where to save the extracted icon to, eg; "C:\My Icons\new.ico"
;                  $iPath   - If set to 1 then the extraction path will be created if it doesn't exist.
;                             If left as 0 then if the extraction path doesn't exist it won't be created.
; Return values .: Success  - Return 1 and @error 0
;                  Failure  - Return 0 and @error 1 ~ 12
;                             @error 1 = Invalid $sInFile parameter
;                             @error 2 = Invalid $iIcon parameter
;                             @error 3 = LoadLibrary failed to return a valid ptr
;                             @error 4 = $iIcon does not exist in the $sInFile
;                             @error 5 = Failed to Find RT_GROUP_ICON Resource
;                             @error 6 = Returned RT_GROUP_ICON Resource as 0 bytes
;                             @error 7 = Failed to Load RT_GROUP_ICON Resource
;                             @error 8 = Failed to Lock RT_GROUP_ICON Resource
;                             @error 9 = Failed to create DLL Struct for RT_GROUP_ICON data
;                             @error 10 = Data in DLL Struct is null
;                             @error 11 = Failed to Open output file path
;                             @error 12 = Failed to write file at output path
;                             (Most the error returns were for my own debug purpose)
; Author ........: smashly
; Modified.......:
; Remarks .......: A big Thank You to Siao for the heads up on _ResourceEnumNames & ___EnumResNameProc
;                  Also Thank You to WeaponX for his _StringSplitRegExp
; Related .......:
; Link ..........;
; Example .......; _ExtractIconToFile(@SystemDir & "\shell32.dll", -42, @HomeDrive & "\Extracted.ico")
; ========================================================================================================
Func _ExtractIconToFile($sInFile, $iIcon, $sOutIco, $iPath = 0)
    Local Const $LOAD_LIBRARY_AS_DATAFILE = 0x00000002
    Local Const $RT_ICON = 3
    Local Const $RT_GROUP_ICON = 14
    Local $hInst, $iGN = "", $hFind, $aSize, $hLoad, $hLock, $tRes
    Local $sData, $sHdr, $iOrd, $aHtail, $iCnt, $Offset, $FO, $iCrt = 18

    If $iPath = 1 Then $iCrt = 26
    If Not FileExists($sInFile) Then Return SetError(1, 0, 0)
    If Not IsInt($iIcon) Then Return SetError(2, 0, 0)

    $hInst = _LoadLibraryEx($sInFile, $LOAD_LIBRARY_AS_DATAFILE)
    If Not IsPtr($hInst) Then Return SetError(3, 0, 0)
    _ResourceEnumNames($hInst, $RT_GROUP_ICON)
    For $i = 1 To $aINM[0]
        If $i = StringReplace($iIcon, "-", "") Then
            $iGN = $aINM[$i]
            ExitLoop
        EndIf
    Next
    If $iGN = "" Then
        _FreeLibrary($hInst)
        Return SetError(4, 0, 0)
    EndIf
    $hFind = DllCall("kernel32.dll", "int", "FindResourceA", "int", $hInst, "str", $iGN, "long", $RT_GROUP_ICON)
    If $hFind[0] = 0 Then
        _FreeLibrary($hInst)
        Return SetError(5, 0, 0)
    EndIf
    $aSize = DllCall("kernel32.dll", "dword", "SizeofResource", "int", $hInst, "int", $hFind[0])
    If $aSize[0] = 0 Then
        _FreeLibrary($hInst)
        Return SetError(6, 0, 0)
    EndIf
    $hLoad = DllCall("kernel32.dll", "int", "LoadResource", "int", $hInst, "int", $hFind[0])
    If $hLoad[0] = 0 Then
        _FreeLibrary($hInst)
        Return SetError(7, 0, 0)
    EndIf
    $hLock = DllCall("kernel32.dll", "int", "LockResource", "int", $hLoad[0])
    If $hLock[0] = 0 Then
        _FreeLibrary($hInst)
        Return SetError(8, 0, 0)
    EndIf
    $tRes = DllStructCreate("byte[" & $aSize[0] & "]", $hLock[0])
    If Not IsDllStruct($tRes) Then
        _FreeLibrary($hInst)
        Return SetError(9, 0, 0)
    EndIf
    $sData = DllStructGetData($tRes, 1)
    If $sData = "" Then
        _FreeLibrary($hInst)
        Return SetError(10, 0, 0)
    EndIf
    $sHdr = StringLeft($sData, 14)
    $iOrd = Dec(LTHR("0x" & StringRight(StringLeft($sData, 42), 4))) ;index start of icon in the library
    $aHtail = _StringSplitRegExp(StringTrimLeft($sData, 14), '(.){28}', True)
    $iCnt = $aHtail[0]
    $Offset = ($iCnt * 16) + 6
    For $r = 1 To $aHtail[0]
        $sDByte = Dec(Hex(BitRotate("0x" & StringLeft(StringRight($aHtail[$r], 12), 4), -8), 4))
        $aHtail[$r] = StringTrimRight($aHtail[$r], 4)
        $sHdr &= $aHtail[$r] & LTHR($Offset) & "0000"
        $Offset += $sDByte
    Next
    For $i = 1 To $iCnt
        $hFind = DllCall("kernel32.dll", "int", "FindResourceA", "int", $hInst, "str", "#" & $iOrd, "long", $RT_ICON)
        $aSize = DllCall("kernel32.dll", "dword", "SizeofResource", "int", $hInst, "int", $hFind[0])
        $hLoad = DllCall("kernel32.dll", "int", "LoadResource", "int", $hInst, "int", $hFind[0])
        $hLock = DllCall("kernel32.dll", "int", "LockResource", "int", $hLoad[0])
        $tRes = DllStructCreate("byte[" & $aSize[0] & "]", $hLock[0])
        $sHdr &= StringTrimLeft(DllStructGetData($tRes, 1), 2)
        $iOrd += 1
    Next
    _FreeLibrary($hInst)
    Dim $aINM[1]
    $FO = FileOpen($sOutIco, $iCrt)
    If $FO = -1 Then Return SetError(11, 0, 0)
    $FW = FileWrite($FO, $sHdr)
    If $FW = 0 Then Return SetError(12, 0, 0)
    FileClose($FO)
    Return SetError(0, 0, 1)
EndFunc   ;==>_ExtractIconToFile

; Helper Functions beyond this point

Func LTHR($sNum)
    Return Hex(BitRotate($sNum, -8), 4)
EndFunc   ;==>LTHR

Func _LoadLibraryEx($sFile, $iFlag)
    Local $hInst = DllCall("Kernel32.dll", "hwnd", "LoadLibraryExA", "str", $sFile, "hwnd", 0, "int", $iFlag)
    Return $hInst[0]
EndFunc   ;==>_LoadLibraryEx

Func _FreeLibrary($hModule)
    Local $aRes = DllCall("Kernel32.dll", "hwnd", "FreeLibrary", "hwnd", $hModule)
EndFunc   ;==>_FreeLibrary

Func _StringSplitRegExp($sString, $sPattern, $sIncludeMatch = False, $iCount = 0)
    Local $sReservedPattern = Chr(0), $sTemp, $aResult
    Local $sReplacePattern = $sReservedPattern
    If $sIncludeMatch Then $sReplacePattern = "$0" & $sReplacePattern
    $sTemp = StringRegExpReplace($sString, $sPattern, $sReplacePattern, $iCount)
    If StringRight($sTemp, 1) = $sReservedPattern Then $sTemp = StringTrimRight($sTemp, 1)
    $aResult = StringSplit($sTemp, $sReservedPattern, 1)
    Return $aResult
EndFunc   ;==>_StringSplitRegExp

Func _ResourceEnumNames($hModule, $iType)
    Local $aRet, $IsPtr = IsPtr($hModule), $xCB
    If $IsPtr Then
        $xCB = DllCallbackRegister('___EnumResNameProc', 'int', 'int*;int*;int*;int*')
        $aRet = DllCall('kernel32.dll', 'int', 'EnumResourceNamesW', 'ptr', $hModule, 'int', $iType, 'ptr', DllCallbackGetPtr($xCB), 'ptr', 0) ;???????????????????????????????????????????
        DllCallbackFree($xCB)
    EndIf
EndFunc   ;==>_ResourceEnumNames

Func ___EnumResNameProc($hModule, $pType, $pName, $lParam)
    Local $aSize = DllCall('kernel32.dll', 'int', 'GlobalSize', 'ptr', $pName), $tBuf
    If $aSize[0] Then
        $tBuf = DllStructCreate('wchar[' & $aSize[0] & ']', $pName)
        ReDim $aINM[UBound($aINM) + 1]
        $aINM[0] += 1
        $aINM[UBound($aINM) - 1] = DllStructGetData($tBuf, 1)
    Else
        ReDim $aINM[UBound($aINM) + 1]
        $aINM[0] += 1
        $aINM[UBound($aINM) - 1] = "#" & $pName
    EndIf
    Return 1
EndFunc   ;==>___EnumResNameProc


Func _Extract_icon()
if _GUICtrlListView_GetSelectionMark($Fotos_Thubnails) = -1 then return
_ISNPlugin_send_message_to_ISN("selectfolder")
GUISetState(@SW_DISABLE, $hGUI)
$Nachricht = _ISNPlugin_Wait_for_Message_from_ISN_AutoIt_Studio("selectfolderok",90000000)
GUISetState(@SW_ENABLE, $hGUI)
$path = _ISNPlugin_Messagestring_Get_Element($Nachricht,2)
if $path = "" then return
$iconID = _GUICtrlListView_GetSelectionMark($Fotos_Thubnails)
$ID = $iconID*-1 ;nagate the index
_ExtractIconToFile($imagefile, $ID-1, $path& "\"&$iconID&".ico")
if @error then
msgbox(262144+64,_ISNPlugin_Get_langstring(7),$iconID&".ico "&_ISNPlugin_Get_langstring(6))
Return
endif
msgbox(262144+64,_ISNPlugin_Get_langstring(4),$iconID&".ico "&_ISNPlugin_Get_langstring(5))
endfunc


; #FUNCTION# ====================================================================================================================
; Name...........: _ReduceMemory
; Author ........: w_Outer, Rajesh V R, Prog@ndy
; ===============================================================================================================================
Func _ReduceMemory($iPid = -1)
    If $iPid = -1 Or ProcessExists($iPid) = 0 Then
        Local $ai_GetCurrentProcess = DllCall('kernel32.dll', 'ptr', 'GetCurrentProcess')
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'ptr', $ai_GetCurrentProcess[0])
        Return $ai_Return[0]
    EndIf

    Local $ai_Handle = DllCall("kernel32.dll", 'ptr', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPid)
    Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'ptr', $ai_Handle[0])
    DllCall('kernel32.dll', 'int', 'CloseHandle', 'ptr', $ai_Handle[0])
    Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory
