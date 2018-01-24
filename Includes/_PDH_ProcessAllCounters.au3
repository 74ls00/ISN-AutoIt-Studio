#include-once

; ===============================================================================================================================
; <_PDH_ProcessAllCounters.au3>
;
; Functions to simplify working with All *Local* Process Counters.
;	NOTES: Only *ONE* 'Process All' Object is able to be created. There shouldn't really be a reason to use more than one,
;		as all Process Counters can be added/removed to the one instance as needed.
;	 Also, for *other* PC's, _PDH_ObjectBase* functions must be used instead, and with a different approach.
;		(the Process names will be stripped of '.exe' in the lists [other extensions are left as-is])
;
; Functions:
;	_PDH_ProcessAllInit()			; Initializes/Creates a special Process'All' PDH Object with a Wildcard Process Instance
;	_PDH_ProcessAllUnInit()			; UnInitializes/Destroys the Process'All' PDH Object created with _PDH_ProcessAllInit()
;	_PDH_ProcessAllAddCounters()	; Adds Process Counters to the Process'All' PDH Object
;	_PDH_ProcessAllRemoveCounters()	; Removes Process Counters from the Process'All' PDH Object
;	_PDH_ProcessAllCollectQueryData()	; Collects Query Data for attached Counters, but does not grab any values
;										; - Useful for creating a 'baseline' point when certain counters need an initial
;										;   'dummy' collection, followed by a sleep, and the real collection.
;										;   ("% Processor Time" is one example)
;	_PDH_ProcessAllUpdateCounters()	; Update Counters for the Process'All' PDH Object
;
; Dependencies:
;	<_PDH_ObjectBaseCounters.au3>	; Many of the functions here are 'derivatives' or call functions within this module.
;									;  Think of it as a unique form of 'inheritance'
; Deeper Dependencies:
;	<_PDH_PerformanceCounters.au3>	; Core Performance Counters module
;	<_WinTimeFunctions.au3>			; FileTime conversions module needed for Time value conversions
;
; See also:
;	<_PDH_ProcessCounters.au3>		; Individual *local* Process Object Interface
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
;	--------------------	GLOBAL PROCESS-ALL VARIABLES (do NOT touch)	--------------------
; ===================================================================================================================

Global $_PDHPCA_bInit=False, $_PDHPCA_aCounters


; ===================================================================================================================
;	--------------------	MAIN FUNCTIONS	--------------------
; ===================================================================================================================


; ===============================================================================================================================
; Func _PDH_ProcessAllInit($sExtraCounters="",$sSep=';')
;
; Initializes/Creates a special Process'All' PDH Object (special array) based on the 'ObjectBase' common Object/Instance Interface.
;	The 'Instance' for the Object is a Wildcard and as such the 'Updates' will return an array that grows or shrinks
;	 as the number of current Processes do.
;
; $sExtraCounters = Counters to add, separated by $sSep if more than one.
;	These are combined with Process Object and Instance to create full Counter paths
;	*NOTE: Counter # 784 ("ID Process"), or Process ID is added internally (appears as column 1 when Updating)
; $sModifiers = (Optional) Modifier(s) to use in adjusting values returned when updating Counters
;	These are also separated by $sSep if more than one.
; $sSep = Separator character used to split $sExtraCounters and $sModifiers (default: ';')
;
; Returns:
;	Success:  True, with Global Process Counter Array initialized, and @error=0. Global Array format:
;	...........  Row 0 Info:	...........
;		[0][0]=Process Counter Object Index # (name is easily extracted from [1][1])
;		[0][1]=""				; (No Wildcard replacement - ALL instances are required for these functions)
;		[0][2]=""
;		[0][3]=""
;	...........  Row 1 Info:	...........
;		[1][0]=PDH Query Handle
;		[1][1]=Process Counter Path minus Instance & Counter name ("\Process(*)\")
;		[1][2]=""				; PC Name generally, but _PDH_ProcessObject'All' Counter's are based on the *LOCAL* machine
;		[1][3]=# of Counters
;	........... Row 2 Info:	...........
;		[2][0]=Counter Index # for "ID Process"
;		[2][1]=Local Counter Name for "ID Process"
;		[2][2]=ID Process Counter Handle (may change over time)
;		[2][3]=0  (Counter Options)
;	........... Row 3+ (counter info [total in [1][3])	...........
;		[x][0]=Counter Index #
;		[x][1]=Localized Counter Name
;		[x][2]=Counter Handle (may vary over time)
;		[x][3]=##  (Counter Options, optional)
;	Failure: False, with @error set:
;		@error = 16 = PDH not initialized
;		@error = 1  = Invalid parameter
;		@error = 2  = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3  = PDH error, @extended = error code, as well as $_PDH_iLastError
;		@error = 7  = non-localized string passed, but invalid format
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessAllInit($sExtraCounters="",$sModifiers="",$sSep=';')
	If $_PDHPCA_bInit Then Return True
	If $sExtraCounters<>"" Then
		$sExtraCounters=784&$sSep&$sExtraCounters
	Else
		$sExtraCounters=784
	EndIf
	If $sModifiers<>"" Then
		$sModifiers=0&$sSep&$sModifiers
	Else
		$sModifiers=0
	EndIf
	$_PDHPCA_aCounters=_PDH_ObjectBaseCreate(230,"",$sExtraCounters,$sModifiers,$sSep)
	If @error Then Return SetError(@error,@extended,False)
	$_PDHPCA_bInit=True
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessAllUnInit()
;
; UnInitializes the Process'All' PDH Object:
;	Frees the Query handle (releasing attached Counters), invalidates $_PDHPCA_aCounters, and sets 'Init' flag to False
;
; Returns:
;	Success: True with @error=0 and Process'All' PDH Object ($_PDHPCA_aCounters) invalidated (and PDH Query Handle freed)
;	Failure: False, with @error set:
;		@error = 1  = Invalid parameter (unlikely scenario)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessAllUnInit()
	If Not $_PDHPCA_bInit Then Return True
	If Not _PDH_ObjectBaseDestroy($_PDHPCA_aCounters) Then Return SetError(@error,@extended,False)
	$_PDHPCA_bInit=False
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessAllAddCounters($sExtraCounters,$sModifiers="",$sSep=';')
;
; Add Counters to the Process'All' PDH Object (combines Object Base and Instance with Counters to create full Counter Paths)
;
; $sExtraCounters = Counters to add, separated by $sSep if more than one.
;	These are combined with Process Object and Instance to create full Counter paths
;	*NOTE: Counter # 784 ("ID Process"), or Process ID is already added internally (appears as column 1 when Updating)
; $sModifiers = (Optional) Modifier(s) to use in adjusting values returned when updating Counters
;	These are also separated by $sSep if more than one.
; $sSep = Separator character used to split $sExtraCounters and $sModifiers (default: ';')
;
; Returns:
;	Success: True, with @error = 0 and Counters Added.
;	Failure: False with @error set:
;		@error = 16 = PDH not initialized
;		@error = 1 = Invalid parameter or Process'All' object not initialized (with _PDH_ProcessAllInit())
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;		@error = 7 = non-localized string passed, but invalid format
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessAllAddCounters($sExtraCounters,$sModifiers="",$sSep=';')
	If Not $_PDHPCA_bInit Then Return SetError(1,0,False)
	If Not _PDH_ObjectBaseAddCounters($_PDHPCA_aCounters,$sExtraCounters,$sModifiers,$sSep) Then Return SetError(@error,@extended,False)
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessAllRemoveCounters($sKillPCs,$sSep=';')
;
; Remove Counters from the Process'All' PDH Object.
;
; $sKillPCs = Process Counters to remove, separated by $sSep if more than one.
; $sSep = Separator character used to split $sKillPCs (default: ';')
;
; Returns:
;	Success: True, with @error=0, @extended = total Counters removed
;	Failure: False, with @error set:
;		@error = 1 = Invalid parameter or Process'All' object not initialized (with _PDH_ProcessAllInit())
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessAllRemoveCounters($sKillPCs,$sSep=';')
	If Not $_PDHPCA_bInit Then Return SetError(1,0,False)
	If Not _PDH_ObjectBaseRemoveCounters($_PDHPCA_aCounters,$sKillPCs,$sSep,3) Then Return SetError(@error,@extended,False)
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessAllCollectQueryData()
;
; Updates the Counters attached to the 'All Processes' Query Handle - doesn't actually collect the values.
;	Collecting values is done via _PDH_ProcessAllUpdateCounters()
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

Func _PDH_ProcessAllCollectQueryData()
	If Not $_PDHPCA_bInit Then Return SetError(1,0,False)
	; Collect Query Data (update all attached Counter Values).
	If Not _PDH_ObjectBaseCollectQueryData($_PDHPCA_aCounters) Then Return SetError(@error,@extended,False)
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessAllUpdateCounters()
;
; Updates Counters that are part of the Process'All' PDH Object, and returns a 2D Array
;
; Returns:
;	Success: 2D array of Values:
;	  NOTE: Individual Counter errors will set the top row element corresponding to that column to -1
;		[0][0]=# of Counters
;		[0][1->x] = nothing or -1 if error retrieving Counters related to this column (in order Counters added)
;		[$i][0]= Counter Name
;		[$i][1->x] = Counter Values related to these columns (in order Counters added)
;	Failure: "" with @error set:
;		@error = 16 = PDH not initialized
;		@error = 1 = Invalid parameter or Process'All' object not initialized (with _PDH_ProcessAllInit())
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5 = Buffer size 'needed' return does not match passed $iBufSize parameter (unlikely)
;		@error = 6 = # of Counters returned does not match $iNumCounters parameter (unlikely)
;		@error = -1 = PDH error 'PDH_INVALID_DATA' (0xC0000BC6) Returned
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessAllUpdateCounters()
	If Not $_PDHPCA_bInit Or Not IsArray($_PDHPCA_aCounters) Then Return SetError(1,0,"")

	Local $aProcessList,$aRet,$iFailSafe,$stCounterBuffer,$pBuffer

	; Enter a loop to get ProcessList and # Counters until they sync up. (should only be once, but there's a chance..)
	For $iFailSafe=1 To 3
		$_PDHOC_iLookupFileTime=_WinTime_GetSystemTimeAsLocalFileTime()	; collect time of lookup (may be needed for calculations)

		; Call CollectQueryData - 'True' allows it to skip extra checks
		If Not _PDH_CollectQueryData($_PDHPCA_aCounters[1][0],True) Then Return SetError(@error,@extended,"")

		; ProcessList to get and compare names
		$aProcessList=ProcessList()
		If @error Then Return SetError(10,@error,"")

		; 1st call - get required buffer size (use PID counter)
		$aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetFormattedCounterArrayW","ptr",$_PDHPCA_aCounters[2][2], _
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

		; # Counters (in $aRet[4]) should equal ProcessList[0][0]+1  (because the PDH Counters include '_Total' as one of the processes)
		If $aProcessList[0][0]=($aRet[4]-1) Then ExitLoop
	Next
	; Passed 'failsafe' count of loop? (This means couldn't get match)
	If $iFailSafe>3 Then Return SetError(11,0,"")

	; Okay, ProcessList() and Process Counters match up now

	; Redim $aProcessList so it can A.) include the '_Total' 'process', and B.) contain extra counters (beyond PID)
	ReDim $aProcessList[$aProcessList[0][0]+2][$_PDHPCA_aCounters[1][3]+1]	; columns = # counters + 1 for name

	; Set structure size according to results of 1st call
	$stCounterBuffer=DllStructCreate("ubyte["&$aRet[3]&']')
	$pBuffer=DllStructGetPtr($stCounterBuffer)


	; First do Process ID list, the most important for synching-up processes/names
	If Not __PDH_ObjectBaseCounterGetValues($_PDHPCA_aCounters,2,$aRet[3],$pBuffer,$aProcessList,$aRet[4],0) Then Return SetError(@error,@extended,"")
	; Set names and values for items in the list that need names (or adjusting)
	$aProcessList[1][0]="Idle"				; 1st Process is the 'Idle' process
	$aProcessList[$aRet[4]][0]="Total"		; '_Total' if matching Counter names
;~ 	$aProcessList[$aRet[4]][1]=""			; no Process ID value for 'Total', obviously (read as 0, but ignored currently)

	; Then the rest
	For $i=3 To $_PDHPCA_aCounters[1][3]+1
		__PDH_ObjectBaseCounterGetValues($_PDHPCA_aCounters,$i,$aRet[3],$pBuffer,$aProcessList,$aRet[4],$i-1)
		If @error Then $aProcessList[0][$i-1]=-1	; Set [0][col] to -1 to indicate error for list (happens alot with CPU Usage)
	Next
	Return $aProcessList
EndFunc
