#include-once

; ===============================================================================================================================
; <_PDH_ObjectBaseCounters.au3>
;
; Functions to help in getting Counters with one Base Object, and a specific or Wildcard Instance.
;	Generally used to build upon (_PDH_Process and _PDH_ProcessAll use this), but it can also be used on its own.
;
; Functions:
;	_PDH_ObjectBaseCreate()				; Creates a special PDH Object (special array) based on a common Object and Instance.
;	_PDH_ObjectBaseDestroy()			; Destroys the PDH Object created with _PDH_ObjectBaseCreate()
;	_PDH_ObjectBaseAddCounters()		; Adds Counters to the PDH Object
;	_PDH_ObjectBaseRemoveCounters()		; Removes Counters from the PDH Object
;	_PDH_ObjectBaseCollectQueryData()	; Collects Query Data for attached Counters, but does not grab any values
;										; - Useful for creating a 'baseline' point when certain counters need an initial
;										;   'dummy' collection, followed by a sleep, and the real collection.
;										;   ("% Processor Time" is one example)
;	_PDH_ObjectBaseUpdateCounters()		; Update Counters for the given PDH Object
;
; *INTERNAL-ONLY FUNCTIONS*
;	__PDH_ObjectBaseCounterGetValues()	; called by _PDH_ObjectBaseUpdateCounters() for Wildcard Counters
;
; Dependencies:
;	<_PDH_PerformanceCounters.au3>		; Core Performance Counters module
;	<_WinTimeFunctions.au3>				; FileTime conversions module needed for Time value conversions
;
; See also:
;	<_PDH_ProcessCounters.au3>		; Individual *local* Process Object Interface
;	<_PDH_ProcessAllCounters.au3>	; *ALL* local Processes Object Interface
;	<TestPDH_ObjectTests.au3>		; Example use/tests of the 3 Object Counters modules
;	<TestPDH_ProcessLoop.au3>		; Example use of <_PDH_ProcessAllCounters.au3>
;									;  (for displaying Process Info in a loop)
;	<_PDH_ProcessGetRelatives.au3>	; Uses ObjectBaseCounters to give 'ProcessList' & Child/Parent Process Info
;	<TestPDH_ProcessGetRelatives.au3>	; Test of the <_PDH_ProcessGetRelatives.au3>
;	<_PDH_TaskMgrSysStats.au3>		; System Statistics Counters useful in gathering Task-Manager type info
;	<TestPDH_TaskManager.au3>		; Test of the <_PDH_TaskMgrSysStats.au3> and <_PDH_ProcessAllCounters.au3>
;									;  ** A very messy W.I.P. currently **;
;	<TestPDH_PerformanceCounters.au3>	; GUI interface to much of <_PDH_PerformanceCounters.au3>
;
; Author: Ascend4nt
; ===============================================================================================================================


; ===================================================================================================================
;	--------------------	GLOBAL OBJECT COUNTER VARIABLES (for calculations, conversions)	--------------------
; ===================================================================================================================

Global $_PDHOC_iLookupFileTime					; set right before Updating Counters, used mainly for Time Conversions
Global Const $PDH_TIME_CONVERSION=0x80000000	; An option that can be used to convert Elapsed Time to FileTime (-2147483648)


; ===================================================================================================================
;	--------------------	MAIN FUNCTIONS	--------------------
; ===================================================================================================================


; ===============================================================================================================================
; Func _PDH_ObjectBaseCreate($vCounter,$sPCName="",$sAddCounters="",$sModifiers="",$sSep=';',$sWildcardReplace="")
;
; Creates a special Base PDH Object (special array) based on a common Object and Instance.
;	Can be used on its own or with 'derived' UDF's.
;
; $vCounter = Counter Index # (ex: 230, 2) or Counter name (ex: "Process", "System")
; $sPCName = (Optional) PC Name, with '\\' prefix (ex: "\\PCNAME")
; $sAddCounters = (Optional) Counters to add, separated by $sSep if more than one.
;	These are combined with the the Object Base and Instance to create full Counter paths
; $sModifiers = (Optional) Modifier(s) to use in adjusting values returned when updating Counters*
;	*Note these modifiers do not affect single-instance counters (only Wildcard Counters ("*"))
;	These are also separated by $sSep if more than one.
; $sSep = Separator character used to split $sAddCounters and $sModifiers (default: ';')
; $sWildcardReplace = (Optional) Instance name to use to replace the '*' default Wildcard
;
; Returns:
;	Success:  Object-Base Array (with @error=0):
;	...........  Row 0 Info:	...........
;		[0][0]=Counter Object Index # (name is easily extracted from [1][1])
;		[0][1]=Wildcard Replacement (used by some _Object UDF derivatives)
;		[0][2]-[0][3] = Object-specific values
;	...........  Row 1 Info:	...........
;		[1][0]=PDH Query Handle
;		[1][1]=Counter Path minus Instance & Counter name ("\Object(*)\" or "\\PCNAME\Object(*)\")
;		[1][2]=PC Name ("" if Local)
;		[1][3]=# of Counters
;	........... Row 2+ (counter info [total in [1][3])	...........
;		[2][0]=Counter Index #
;		[2][1]=Localized Counter Name
;		[2][2]=Counter Handle
;		[2][3]=Counter Options
;	Failure: "" with @error set:
;		@error = 16 = PDH not initialized
;		@error = 1  = Invalid parameter
;		@error = 2  = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3  = PDH error, @extended = error code, as well as $_PDH_iLastError
;		@error = 7  = non-localized string passed, but invalid format
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ObjectBaseCreate($vCounter,$sPCName="",$sAddCounters="",$sModifiers="",$sSep=';',$sWildcardReplace="")
	; Check that PDH handle has been initialized
	If Not $_PDH_bInit Then Return SetError(16,0,"")

	Dim $aObjArr[2][4]

	; Set numerical representation at [0][0] and ensure $vCounter is localized string (or converted to one)
	If StringIsDigit($vCounter) Then
		$aObjArr[0][0]=Number($vCounter)
		$vCounter=_PDH_GetCounterNameByIndex($vCounter,$sPCName)
	Else
		$aObjArr[0][0]=_PDH_GetCounterIndex($vCounter,$sPCName)
	EndIf
	If $vCounter="" Then Return SetError(1,0,"")
	$aObjArr[0][1]=$sWildcardReplace		; Wildcard replacement (_Object-derivative functions will set this)

	; Build Object 'all' Counter Path (without Instance or Counter Name)
	$aObjArr[1][1]=$sPCName&'\'&$vCounter&"(*)\"
	$aObjArr[1][2]=$sPCName
	$aObjArr[1][3]=0			; initial # of Counters attached to the Query Handle

	; Query Handle
	$aObjArr[1][0]=_PDH_GetNewQueryHandle()
	If @error Then Return SetError(@error,@extended,"")

	; If no Counters passed, or if adding Counters was successful, Return the array
	If $sAddCounters="" Or _PDH_ObjectBaseAddCounters($aObjArr,$sAddCounters,$sModifiers,$sSep) Then Return $aObjArr

	; Failure - free the Query Handle
	Local $iErr=@error,$iExt=@extended
	_PDH_FreeQueryHandle($aObjArr[1][0])

	Return SetError($iErr,$iExt,"")
EndFunc


; ===============================================================================================================================
; Func _PDH_ObjectBaseDestroy(ByRef $aObjArr)
;
; Destroys the PDH Base Object - Frees the Query handle (and releases attached Counters) and invalidates $aObjArr
;
; $aObjArr = Base Object (array) as returned from _PDH_ObjectBaseCreate() - will be invalidated if successful!
;
; Returns:
;	Success: True with @error=0 and Process PDH Object ($aPDHProcess) invalidated (and PDH Query Handle freed)
;	Failure: False, with @error set:
;		@error = 1  = Invalid parameter
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ObjectBaseDestroy(ByRef $aObjArr)
	If Not IsArray($aObjArr) Then Return SetError(1,0,False)
	; Freeing the Query Handle also frees all Counters associated with it
	If IsPtr($aObjArr[1][0]) Then _PDH_FreeQueryHandle($aObjArr[1][0])	; no error-checking (why bother)
	$aObjArr=""
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ObjectBaseAddCounters(ByRef $aObjArr,$sExtraCounters,$sModifiers="",$sSep=';')
;
; Add Counters to the given PDH Base Object (combines Object Base and Instance with Counters to create full Counter Paths)
;
; $aObjArr = Object array as returned from _PDH_ObjectBaseCreate()
; $sExtraCounters = Counters to add, separated by $sSep if more than one.
;	These are combined with the Object Base and Instance to create full Counter paths
; $sModifiers = (Optional) Modifier(s) to use in adjusting values returned when updating Counters*
;	*Note these modifiers do not affect single-instance counters (only Wildcard Counters ("*"))
;	These are also separated by $sSep if more than one.
; $sSep = Separator character used to split $sExtraCounters and $sModifiers (default: ';')
;	NOTE: Removed PCRE at beginning due to problems that might arise with $sSep
;		(using hex values, PCRE reserved symbols, macros like @LF or @CRLF, etc)
;
; Returns:
;	Success: True, @error=0 and Counters added
;	Failure: False, with @error set:
;		@error = 16 = PDH not initialized
;		@error = 1 = Invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;		@error = 7 = non-localized string passed, but invalid format
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ObjectBaseAddCounters(ByRef $aObjArr,$sExtraCounters,$sModifiers="",$sSep=';')
	If Not IsArray($aObjArr) Or $sExtraCounters="" Then Return SetError(1,0,False)
	; If ';' at beginning or end, or more than one ';' in a row, it will give us blank counters
	;	NOTE: Removed the following since we allow $sSep as a parameter (which can make this fail continuously)
;~ 	If StringRegExp($sExtraCounters,"(^"&$sSep&"|("&$sSep&"){2,}|"&$sSep&"$)",0) Then Return SetError(1,0,False)

;~ 	_PDH_DebugWrite("_PDH_ObjectBaseAddCounters entry: $sExtraCounters='"&$sExtraCounters&"', $sModifiers='"&$sModifiers&"', $sSep='"&$sSep)

	Local $i,$iVal=0,$iNewIndex,$aNewOCs,$iAdded=0,$iExtraOCs=0,$iModifiers=1,$sInstanceName,$sPath

	$aNewOCs=StringSplit($sExtraCounters,$sSep,1)
	$iExtraOCs=$aNewOCs[0]

	; Modifiers? (Divide by, alter time, etc)
	If $sModifiers<>"" Then
		$aModifiers=StringSplit($sModifiers,$sSep,1)
		$iModifiers=$aModifiers[0]
		$iVal=$aModifiers[1]
		; More than one, but <> total of new Object Counters?
		If $iModifiers>1 And $iModifiers<>$iExtraOCs Then	; some set, but not all.
			ReDim $aModifiers[$iExtraOCs+1]					; just ReDim the array to equal the same size
		EndIf
	EndIf

	; Resize array to accomodate new stats
	ReDim $aObjArr[$aObjArr[1][3]+2+$iExtraOCs][4]

	; Now add additional Counters to the Query Handle
	$iNewIndex=1
	For $i=$aObjArr[1][3]+2 To $aObjArr[1][3]+$iExtraOCs+1
		If StringIsDigit($aNewOCs[$iNewIndex]) Then
			$aObjArr[$i][0]=Number($aNewOCs[$iNewIndex])
			$aObjArr[$i][1]=_PDH_GetCounterNameByIndex($aNewOCs[$iNewIndex],$aObjArr[1][2])
		Else
			$aObjArr[$i][0]=_PDH_GetCounterIndex($aNewOCs[$iNewIndex],$aObjArr[1][2])	; needed for CPU Usage calculations..
			$aObjArr[$i][1]=$aNewOCs[$iNewIndex]
		EndIf
		$sPath=$aObjArr[1][1]&$aObjArr[$i][1]
		If $aObjArr[0][1]<>"" Then $sPath=StringReplace($sPath,'*',$aObjArr[0][1])
		$aObjArr[$i][2]=_PDH_AddCounter($aObjArr[1][0],$sPath)
		If @error Then
			Local $iErr=@error,$iExt=@extended
			; Remove successfully added counters (1 error ruins the party for everyone!)
			For $i=0 To $iAdded-1
				_PDH_RemoveCounter($aObjArr[$i+$aObjArr[1][3]+2][2])
			Next
			; Resize array back to original size
			ReDim $aObjArr[$aObjArr[1][3]+2][4]
			Return SetError($iErr,$iExt,False)
		EndIf
		If $iModifiers>1 Then
			$aObjArr[$i][3]=$aModifiers[$iNewIndex]
		Else
			$aObjArr[$i][3]=$iVal
		EndIf
		$iAdded+=1
		$iNewIndex+=1
	Next
	; Everything added sucessfully!
	$aObjArr[1][3]+=$iExtraOCs
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ObjectBaseRemoveCounters(ByRef $aObjArr,$sKillOCs,$sSep=';',$iStart=2)
;
; Remove Counters from the given PDH Base Object.
;
; $aObjArr = Object array as returned from _PDH_ObjectBaseCreate()
; $sKillOCs = Counters to remove, separated by $sSep if more than one.
; $sSep = Separator character used to split $sKillOCs (default: ';')
; $iStart = *for INTERNAL USE* - the 1st Counter index to start searching at (default is 2 [start of Counter rows])
;		Used for avoiding removal of *required* Counters (as in _ProcessCounters)
;
; Returns:
;	Success: True, with @error=0, @extended = total Counters removed
;	Failure: False, with @error set:
;		@error = 1 = Invalid parameter
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ObjectBaseRemoveCounters(ByRef $aObjArr,$sKillOCs,$sSep=';',$iStart=2)
	If Not IsArray($aObjArr) Or $sKillOCs="" Or $iStart<2 Or $iStart>$aObjArr[1][3]+1 Then Return SetError(1,0,False)

;~ 	_PDH_DebugWrite("_PDH_ObjectBaseRemoveCounters entry: $sKillOCs='"&$sKillOCs&"', $sSep='"&$sSep)

	Local $i,$i2,$bKill=False,$aKillOCs,$iMoveTo,$aNewArr,$iKillTotal=0

	$aKillOCs=StringSplit($sKillOCs,$sSep,1)

	$aNewArr=$aObjArr	; copy array over. This will save us from shifting the contents of $aObjArray around

	; Now to hunt for and remove Counters from Array
	$iMoveTo=$iStart
	For $i=$iStart To $aObjArr[1][3]+1
		For $i2=1 To $aKillOCs[0]
			If StringIsDigit($aKillOCs[$i2]) Then
				If $aObjArr[$i][0]<>$aKillOCs[$i2] Then ContinueLoop
			Else
				If $aObjArr[$i][1]<>$aKillOCs[$i2] Then ContinueLoop
			EndIf
			; Above checks proved something was equal, so exit loop with $bKill set
			$bKill=True
			ExitLoop
		Next
		If $bKill Then
			_PDH_DebugWrite("Removing Counter #"&$aObjArr[$i][0]&", Counter name: '"&$aObjArr[$i][1]&"' Handle:"&$aObjArr[$i][2])
			_PDH_RemoveCounter($aObjArr[$i][2])
			$iKillTotal+=1
			$bKill=False
		Else
			$aNewArr[$iMoveTo][0]=$aObjArr[$i][0]
			$aNewArr[$iMoveTo][1]=$aObjArr[$i][1]
			$aNewArr[$iMoveTo][2]=$aObjArr[$i][2]
			$aNewArr[$iMoveTo][3]=$aObjArr[$i][3]
			$iMoveTo+=1
		EndIf
	Next
	If $iKillTotal=0 Then Return True
	_PDH_DebugWrite("Total killed:"&$iKillTotal&" (out of "&$aKillOCs[0]&"), $iMoveTo="&$iMoveTo&" Current array size:"&$aObjArr[1][3]+2&", new array size:"&$iMoveTo)
	; Everything that matched was removed.. (no checks for mismatches..)
	ReDim $aNewArr[$iMoveTo][4]	; $iMoveTo is incremented 1 past array in last loop, so this gives correct size
	$aNewArr[1][3]-=$iKillTotal	; set new total # of Counters
	$aObjArr=$aNewArr			; replace Object array with altered one
	Return SetExtended($iKillTotal,True)
EndFunc


; ===============================================================================================================================
; Func _PDH_ObjectBaseCollectQueryData(ByRef $aObjArr)
;
; Updates the Counters attached to a Query Handle - doesn't actually collect the values.
;	Collecting values is done via _PDH_ObjectBaseUpdateCounters()
;
; $aObjArr = Object array as returned from _PDH_ObjectBaseCreate()
;
; Return:
;	Success: True, @error = 0
;	Failure: False, @error set:
;		@error = 16 = PDH not initialized
;		@error = 1 = invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error. @extended contains error, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ObjectBaseCollectQueryData(ByRef $aObjArr)
	If Not IsArray($aObjArr) Or $aObjArr[1][3]=0  Then Return SetError(1,0,"")
	; Collect Query Data (update all attached Counter Values).
	If Not _PDH_CollectQueryData($aObjArr[1][0]) Then Return SetError(@error,@extended,False)
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ObjectBaseUpdateCounters(ByRef $aObjArr,$iIndex=-1)
;
; Update Counters that are part of the PDH Base Object, and return an array or only 1 if $iIndex>-1*
;	*NOTE: If the Base Object is not a Wildcard Counter, $iIndex has no effect, and an array is returned regardless.
;
; $aObjArr = Object array as returned from _PDH_ObjectBaseCreate()
; $iIndex = 0-based Index of Counter to retrieve value for. -1 returns and entire array.
;	NOTE: Wilcard Counters will *always* return an array regardless of the value of this parameter.
;
; Returns:
;	Success: Value or Array based on Instance type. If its an Instance Object, and $iIndex>-1, a Value will be returned.
;	  For Wildcard Instances, or $iIndex=-1, an array will be returned:
;	 Wildcard Instances Array (2D):
;		[0][0]=# of Counters
;		[0][1->x] = nothing or -1 if error retrieving Counters related to this column (in order added)
;		[$i][0]= Counter Name
;		[$i][1->x] = Counter Values related to these columns (in order added)
;	 Instance-specific Array (1D):
;		[0] = 1st Counter Value
;		[1-x] = Next Counter Values
;	Failure: "" with @error set:
;		@error = 16 = PDH not initialized
;		@error = 1 = invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5 = Buffer size 'needed' return does not match passed $iBufSize parameter (unlikely)
;		@error = 6 = # of Counters returned does not match $iNumCounters parameter (unlikely)
;		@error = -1 = PDH error 'PDH_INVALID_DATA' (0xC0000BC6) Returned
;			IMPORTANT: It is recommended to call _PDH_RemoveCounter() when @error = -1 !!
;				(It generally means Counter is no longer valid)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ObjectBaseUpdateCounters(ByRef $aObjArr,$iIndex=-1)
	If Not IsArray($aObjArr) Or $aObjArr[1][3]=0 Or $iIndex+1>=$aObjArr[1][3] Then Return SetError(1,0,"")

	$_PDHOC_iLookupFileTime=_WinTime_GetSystemTimeAsLocalFileTime()	; collect time of lookup (may be needed for calculations)

	; Collect Query Data (update all attached Counter Values).
	If Not _PDH_CollectQueryData($aObjArr[1][0]) Then Return SetError(@error,@extended,"")

; Individual Counters Version

	; Update Counters Individually if Instance name exists
	If $aObjArr[0][1]<>"" Then
		Local $iVal
		Dim $aValues[$aObjArr[1][3]-1]

		If $iIndex<0 Then
			; No error checking here.. but Counter Values will be set to -1 where there are errors
			For $i=0 To $aObjArr[1][3]-1
				$aValues[$i]=_PDH_UpdateCounter($aObjArr[1][0],$aObjArr[$i+2][2],"",True)	; True -> don't recollect Query Data
			Next
			Return $aValues
		Else
			$iVal=_PDH_UpdateCounter($aObjArr[1][0],$aObjArr[$iIndex+2][2],"",True)
			If @error Then Return SetError(@error,@extended,"")
			Return $iVal
		EndIf
	EndIf

; Wildcard Counters Version

	Local $aRet,$stCounterBuffer,$pBuffer

	; 1st call - get required buffer size (use 1st counter)
	$aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetFormattedCounterArrayW","ptr",$aObjArr[2][2], _
		"dword",0x8400,"dword*",0,"dword*",0,"ptr",0)
	If @error Then Return SetError(2,@error,"")

	; Return should be PDH_MORE_DATA (0x800007D2), but on Win2000 'ERROR_SUCCESS' is returned - so check if there's a return size
	If $aRet[0]<>0x800007D2 And Not ($aRet[0]=0 And $aRet[3] And @OSVersion="WIN_2000") Then
		$_PDH_iLastError=$aRet[0]
		; DEBUG
		_PDH_DebugWrite("PdhGetFormattedCounterArrayW 1st call unsuccessful, return:" & Hex($_PDH_iLastError)&", sz:"&$aRet[3]& @CRLF)
		Return SetError(3,$_PDH_iLastError,"")
	EndIf
	; DEBUG:
	;_PDH_DebugWrite("Required buffer size after 1st PdhGetFormattedCounterArrayW call:"&$aRet[3]&" bytes, #counters:"&$aRet[4]&@CRLF)

	; Dim $aCounterArr so it can encompass complete list starting at index #1
	Dim $aCounterArr[$aRet[4]+1][$aObjArr[1][3]+1]		; columns = # counters + 1 for name
	$aCounterArr[0][0]=$aRet[4]		; Set [0][0] to # Counters

	; Set structure size according to results of 1st call
	$stCounterBuffer=DllStructCreate("ubyte["&$aRet[3]&']')
	$pBuffer=DllStructGetPtr($stCounterBuffer)

	; Cycle through and grab all Wildcard Counters
	For $i=2 To $aObjArr[1][3]+1
		__PDH_ObjectBaseCounterGetValues($aObjArr,$i,$aRet[3],$pBuffer,$aCounterArr,$aRet[4],$i-1)
		If @error Then $aCounterArr[0][$i-1]=-1		; Set [0][col] to -1 to indicate error for list
	Next
	Return $aCounterArr
EndFunc


; ===================================================================================================================
;	--------------------	INTERNAL-ONLY!! FUNCTIONS	--------------------
; ===================================================================================================================
#region PDHOBC_INTERNAL_FUNCTIONS


; ===============================================================================================================================
; Func __PDH_ObjectBaseCounterGetValues(ByRef $aObjArr,$iRow,$iBufSize,$pOCBuffer,ByRef $aCounterArr,$iNumCounters,$iColIndex)
;
; Collects Wildcard Counter Values for an array with 1 or more common Object Wildcard Counters (with same instance or '*').
; ** WARNING ** INTERNAL FUNCTION - NO PARAMETER ERROR CHECKING HERE! **
; NOTE: Caller must do some things before calling this function, like call _PDH_CollectQueryData().
;	_PDH_ObjectBaseUpdateCounters() and _PDH_ProcessAllUpdateCounters() are examples of how this function gets used
;
; Returns:
;	Success: True, with $aCounterArr set with values (in $iColIndex). Also Column 0 will be set if $iColIndex=1
;	Failure: False, with @error set:
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 4 = DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5 = Buffer size 'needed' return does not match passed $iBufSize parameter (unlikely)
;		@error = 6 = # of Counters returned does not match $iNumCounters parameter (unlikely)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func __PDH_ObjectBaseCounterGetValues(ByRef $aObjArr,$iRow,$iBufSize,$pOCBuffer, ByRef $aCounterArr,$iNumCounters,$iColIndex)
	; Called once initial params are retrieved. Here we get actual data
	Local $aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetFormattedCounterArrayW","ptr",$aObjArr[$iRow][2], _
		"dword",0x8400,"dword*",$iBufSize,"dword*",0,"ptr",$pOCBuffer)
	If @error Then Return SetError(2,@error,False)

	; PDH Error? (typically PDH_CSTATUS_INVALID_DATA (0xC0000BBA) is returned for new\updated CPU Usage Counters)
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		; DEBUG:
		_PDH_DebugWrite("PdhGetFormattedCounterArrayW 2nd call unsuccessful, return:"&Hex($_PDH_iLastError)&", sz:"&$aRet[3]&", #counters:"&$aRet[4])
		Return SetError(4,$_PDH_iLastError,False)
	EndIf

	If $aRet[3]<>$iBufSize Then Return SetError(5,0,False)

	; DEBUG:
;~ 	_PDH_DebugWrite("PdhGetFormattedCounterArrayW 2nd call successfull, return size:"&$aRet[3]&" bytes, #counters:"&$aRet[4])

	; Mismatch in # counters?
	If $aRet[4]<>$iNumCounters Then Return SetError(6,0,False)

	; According to MSDN sources, the PDH_FMT_COUNTERVALUE_ITEM structure really should be ptr;dword;int64 (as max sized part of union)
	;	However, the embedded PDH_FMT_COUNTERVALUE structure on its own *would* need padding to offset the in64 value, so alone
	;	it would need that padding.  In x64 mode, the same situation should result. May be fixed by v3.3.7.2 struct/endstruct directives
	Local $stCountValueItem,$iCountValueSz=DllStructGetSize(DllStructCreate("ptr;long;dword;int64"))	; get struct size
	Local $iUTC2LocalDelta,$iVal,$iDivisor,$bTimeConv=False
	; Pointer used in pulling\assigning each new structure in the buffer
	Local $pPointer=$pOCBuffer

; Set up $iDivisor or $bTimeConv as necessary:
	$iDivisor=$aObjArr[$iRow][3]
	If BitAND($iDivisor,0x80000000) Then $bTimeConv=True
	$iDivisor=BitAND($iDivisor,0x7FFFFFFF)

	; Set UTC->Local Delta value to lessen DLL calls
	If $bTimeConv Then $iUTC2LocalDelta=_WinTime_GetUTCToLocalFileTimeDelta()

	For $i=1 To $aRet[4]
		$stCountValueItem=DllStructCreate("ptr;long;dword;int64",$pPointer)	; PDH_FMT_COUNTERVALUE_ITEM (see above)
		$pPointer+=$iCountValueSz	; Move pointer to next counter value (PDH_FMT_COUNTERVALUE)

		; Ignoring 2nd *undocumented* member of struct - no idea what it is for

		; Grab Counter Value
		$iVal=DllStructGetData($stCountValueItem,4)
		; Perform necessary conversions
		If $bTimeConv Then
			$iVal=$_PDHOC_iLookupFileTime-($iVal*10000000)+$iUTC2LocalDelta	; Elapsed Time -> Creation Time (FileTime) conversion
		ElseIf $iDivisor Then
			$iVal=Round($iVal/$iDivisor)
		EndIf

		If $iColIndex Then
			; Assign Name from pointer
			If $iColIndex=1 Then $aCounterArr[$i][0]=__PDH_StringGetNullTermMemStr(DllStructGetData($stCountValueItem,1))
			$aCounterArr[$i][$iColIndex]=$iVal
			ContinueLoop
		ElseIf $aObjArr[0][0]=230 Then	  ; Column Index 0 indicates special PID Counter compare (Counter index 230 = "Process")
			If $iVal And $aCounterArr[$i][1]<>$iVal Then
				; If PID doesn't match up, something went wrong somewhere!
				$aCounterArr[$i][0]="?"
				; ProcessList() mismatch: this should *NOT* happen. But this function is currently in the testing phase
				_PDH_DebugWrite("Process ID mismatch found at index "&$i& _
					", Counter PID:"&$iVal&", ProcessList ID:"&$aCounterArr[$i][1]&", name:"&$aCounterArr[$i][0])
			EndIf
		EndIf
	Next
	Return True
EndFunc

#endregion PDHOBC_INTERNAL_FUNCTIONS