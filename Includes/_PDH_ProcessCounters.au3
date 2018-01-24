#include-once

; ===============================================================================================================================
; <_PDH_ProcessCounters.au3>
;
; Functions to help in getting Process Counters, making PDH Performance Counters easier to work with for Individual Processes.
;
; Main Functions:
;	_PDH_ProcessObjectCreate()			; Creates a special Process PDH Object with a Self-regulating Special Process Instance
;	_PDH_ProcessObjectDestroy()			; Destroys the Process PDH Object created with _PDH_ProcessObjectCreate()
;	_PDH_ProcessObjectAddCounters()		; Adds Process Counters to the given Process PDH Object
;	_PDH_ProcessObjectRemoveCounters()	; Removes Process Counters from the given Process PDH Object
;	_PDH_ProcessObjectCollectQueryData() ; Collects Query Data for attached Counters, but does not grab any values
;										; - Useful for creating a 'baseline' point when certain counters need an initial
;										;   'dummy' collection, followed by a sleep, and the real collection.
;										;   ("% Processor Time" is one example)
;	_PDH_ProcessObjectUpdateCounters()	; Update Counters for the given Process PDH Object
;
; Wrapper Functions:
;	_PDH_ProcessObjectGetPID()			; Simply pulls the Process ID from the Process Object array
;	_PDH_ProcessObjectGetName()			; Simply pulls the Process Name from the Process Object array
;
; Informational Function:
;	_PDH_ProcessGetInstanceName()		; Gets the Instance Name based on a Process name & PID (generally used internally)
;
; *INTERNAL-ONLY Functions*:
;	__PDHPO_VerifyInstance()	; Called by _PDH_Process* functions to check/re-establish correct Instance name/Counters
;
; Dependencies:
;	<_PDH_ObjectBaseCounters.au3>	; Many of the functions here are 'derivatives' or call functions within this module.
;									;  Think of it as a unique form of 'inheritance'
; Deeper Dependencies:
;	<_PDH_PerformanceCounters.au3>	; Core Performance Counters module
;	<_WinTimeFunctions.au3>			; FileTime conversions module needed for Time value conversions
;
; See also:
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
;	--------------------	INTERNAL-ONLY!! FUNCTIONS	--------------------
; ===================================================================================================================


; ===============================================================================================================================
; Func __PDHPO_VerifyInstance(ByRef $aPDHProcess)
;
; Verifies the current Process PDH Object's 'Instance' name is still the same by looking up the Instance name and comparing.
;	If its the same, it returns True. If not, it will re-assign the new Instance name, Remove all Counters and re-add them
;	back on, thus re-establishing the correct PDH Object.
;	**NOTE, however, that if the Process was closed (@error=32, return of False), the Process PDH Object is invalidated
;	 (and the PDH Query Handle is freed)
;
; $aPDHProcess = Process Stat array returned from _PDH_ProcessObjectCreate()
; $sProcess = process name (*without* path)
; $iProcessID = process ID of process name.  If "Idle" or "_Total" process, set to 0.
;				IF unknown, use -1.  HOWEVER - this will only return the 1st found instance of the process!
;
; Returns:
;	Success: True, with @error = 0. If there was a change in Instance, $aPDHProcess's 'Instance' and Counters are reset
;	Failure: False with @error set (and if @error=32, $aPDHProcess destroyed*):
;		@error = 16 = PDH not initialized
;		@error = 1 = Invalid handle or parameter
;		@error = 32 = process does not exist or couldn't be found in ProcessList*
;			*IMPORTANT!! - $aPDHProcess is invalidated if @error=32 (and the PDH Query Handle is freed)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func __PDHPO_VerifyInstance(ByRef $aPDHProcess)
	Local $sInstanceName,$iErr,$iReAttached,$sPathNew
	$sInstanceName=_PDH_ProcessGetInstanceName($aPDHProcess[0][2],$aPDHProcess[0][3])
	If $sInstanceName=$aPDHProcess[0][1] Then Return True
	$iErr=@error
	_PDH_DebugWrite("Difference in instance names detected. Old instance: '"&$aPDHProcess[0][1]&"' New: '"&$sInstanceName&"' @error="&@error)
	$sPathNew=StringReplace($aPDHProcess[1][1],'*',$sInstanceName)
	$aPDHProcess[0][1]=$sInstanceName
	; Two loops - outer one in case re-adding a Counter caused an error after some counters were re-added
	While 1
		$iReAttached=0
		For $i=2 To $aPDHProcess[1][3]+1
			_PDH_RemoveCounter($aPDHProcess[$i][2])
			If $iErr=0 Then
				$aPDHProcess[$i][2]=_PDH_AddCounter($aPDHProcess[1][0],$sPathNew&$aPDHProcess[$i][1])
				$iErr=@error
				If $iErr And $iReAttached Then ContinueLoop 2	; Error, but some were re-attached - restart loop and remove attached ones
				$iReAttached+=1
			EndIf
		Next
		If $iErr Then
			_PDH_FreeQueryHandle($aPDHProcess[1][0])
			$aPDHProcess=""				; invalidate array
			Return SetError(32,0,False)	; Process no longer in existence, all counters Removed
		EndIf
		; All counters re-added :)
		Return SetExtended($iReAttached,True)
	WEnd
EndFunc


; ===================================================================================================================
;	--------------------	MAIN FUNCTIONS	--------------------
; ===================================================================================================================


; ===============================================================================================================================
; Func _PDH_ProcessGetInstanceName($sProcess,$iProcessID)
;
; Function to get the 'Instance name' for a Process.  Because of the unusual format of Counters, the
;	Instance name must be derived from the entry in the current ProcessList, and a special '#x' needs to be appended
;	to the first part of the Process filename. (svchost#1, autoit3#2, and so forth). Any processes with an ".exe"
;	extension will have the extension stripped in Counter Instances, while all other processes retain their extension.
;
;	NOTE!! The process being grabbed should *NOT* have unmatching parentheses in the name:
;		NO GOOD: ")(", ")", "(".  GOOD: '(thisisfine)'.
;		(its highly unlikely that you'll ever see a process like that, but such a process name *is* possible to create)
;
; $sProcess = process name (*without* path)
; $iProcessID = process ID of process name.  If "Idle" or "_Total" process, set this to 0.
;			IF unknown, pass ProcessExists($sProcess).  HOWEVER - this will only give the 1st found instance of the process!
;
; Returns:
;	Success: Instance name, with @error = 0
;	Failure: "" with @error set:
;		@error = 1 = Invalid parameter
;		@error = 32 = process does not exist or couldn't be found in ProcessList
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessGetInstanceName($sProcess,$iProcessID)
	If Not IsString($sProcess) Or $sProcess="" Or Not IsNumber($iProcessID) Then Return SetError(1,0,"")

	Local $aProcList,$sInstanceName,$bHasNumberDigit

	; Build the instance name

	; Strip the .exe from a process name (as it is in instances) - PCRE ensures it isn't an 'in-between' (i.e. 'proc.exe.tmp')
	$sInstanceName=StringRegExpReplace($sProcess,"(?i).exe$","")

	; If '#x' is a part of the name, we need to note it and later append a '#x' to the end of instance name
	$bHasNumberDigit=StringRegExp($sInstanceName,'#\d')

	; Allow special cases of the 'Idle' process and '_Total'  "Processes"
	If $sProcess<>"Idle" And $sProcess<>"_Total" Then	; And $sProcess<>"System" Then	; "System" does show up as a process #

		; Now to find the correct instance index #
		$aProcList=ProcessList($sProcess)
		If @error Or $aProcList[0][0]=0 Then Return SetError(32,0,"")

		; We need to find the instance index # if more than one of the same process
		;	(the Instance #'s match up with the order in which Processes were created - the same order ProcessList returns them)
		If $aProcList[0][0]>1 Then
			For $i=1 To $aProcList[0][0]
				If $aProcList[$i][1]=$iProcessID Then ExitLoop
			Next
			If $i>$aProcList[0][0] Then Return SetError(32,0,"")
			; Instance indexes start at #1 for the 2nd instance. The first does not need an index # (unless it has a #x, in which case its #0)
			$i-=1
			; If not the first instance, append the index # (e.g. "svchost#4"),
			;	OR append #0 if '#x' is already a part of the name ("MyProgramIs#1" should be converted to "MyProgramIs#1#0")
			If $i Or $bHasNumberDigit Then $sInstanceName&="#"&$i
		Else
			; One instance, but is it the right one?
			If $aProcList[1][1]<>$iProcessID Then Return SetError(32,0,"")
			; Append #0 if string contains #x already
			If $bHasNumberDigit Then $sInstanceName&="#0"
		EndIf
	EndIf
	Return $sInstanceName
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessObjectCreate($sProcess,$iProcessID)
;
; Creates a special Process PDH Object (special array) based on the 'ObjectBase' common Object/Instance Interface.
;	The 'Instance' for the Object is based on both the process name and Process ID# that is passed, and can vary
;	 throughout the course of the Process PDH Object's life (along with the Counters).  Management of this is handled
;	 internally, so all the caller needs to do is to focus on calling the normal functions.
;
;	NOTE!! The process being grabbed should *NOT* have unmatching parentheses in the name:
;		NO GOOD: ")(", ")", "(".  GOOD: '(thisisfine)'
;		(its highly unlikely that you'll ever see a process like that, but such a process name *is* possible to create)
;
; $sProcess = process name (*without* path). This must be on the *local* PC!
; $iProcessID = process ID of process name.  If "Idle" or "_Total" process, set this to 0.
;			IF unknown, pass ProcessExists($sProcess).  HOWEVER - this will only give the 1st found instance of the process!
;
; Returns:
;	Success:  Process-Object Array (with @error=0):
;	...........  Row 0 Info:	...........
;		[0][0]=Process Counter Object Index # (name is easily extracted from [1][1])
;		[0][1]=Process Instance Name (may vary over time)
;		[0][2]=Process Name
;		[0][3]=Process ID #
;	...........  Row 1 Info:	...........
;		[1][0]=PDH Query Handle
;		[1][1]=Process Counter Path minus Instance & Counter name ("\Process(*)\")
;		[1][2]=""				; PC Name generally, but _PDH_ProcessObject Counter's are based on the *LOCAL* machine
;		[1][3]=# of Counters
;	........... Row 2 Info:	...........
;		[2][0]=Counter Index # for "ID Process"
;		[2][1]=Local Counter Name for "ID Process"
;		[2][2]=ID Process Counter Handle (may change over time)
;		[2][3]=0  (Counter Options, not implemented in single-Process functions)
;	........... Row 3+ (counter info [total in [1][3])	...........
;		[x][0]=Counter Index #
;		[x][1]=Localized Counter Name
;		[x][2]=Counter Handle (may vary over time)
;		[x][3]=0  (Counter Options, not implemented in single-Process functions)
;	Failure: "" with @error set:
;		@error = 16 = PDH not initialized
;		@error = 1  = Invalid parameter
;		@error = 2  = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3  = PDH error, @extended = error code, as well as $_PDH_iLastError
;		@error = 7  = non-localized string passed, but invalid format
;		@error = 32 = process does not exist or couldn't be found in ProcessList
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessObjectCreate($sProcess,$iProcessID)
	If Not IsString($sProcess) Or $sProcess="" Or Not IsNumber($iProcessID) Then Return SetError(1,0,"")

	Local $sInstanceName,$aPDHProcess

	; Get the current instance name for the Process
	$sInstanceName=_PDH_ProcessGetInstanceName($sProcess,$iProcessID)
	If @error Then Return SetError(@error,@extended,"")

	$aPDHProcess=_PDH_ObjectBaseCreate(230,"",784,0,';',$sInstanceName)
	If @error Then Return SetError(@error,@extended,"")

	; Now that the Base Object fields are all set, finish filling in Process-specific fields
	$aPDHProcess[0][2]=$sProcess
	$aPDHProcess[0][3]=$iProcessID
	Return $aPDHProcess
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessObjectDestroy(ByRef $aPDHProcess)
;
; Destroys the Process PDH Object - Frees the Query handle (releasing attached Counters) and invalidates $aPDHProcess
;
; $aPDHProcess = Process PDH Object (array) returned from _PDH_ProcessObjectCreate() - invalidated if successful!
;
; Returns:
;	Success: True with @error=0 and Process PDH Object ($aPDHProcess) invalidated (and PDH Query Handle freed)
;	Failure: False, with @error set:
;		@error = 1  = Invalid parameter
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessObjectDestroy(ByRef $aPDHProcess)
	If Not _PDH_ObjectBaseDestroy($aPDHProcess) Then Return SetError(@error,@extended,False)
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessObjectAddCounters(ByRef $aPDHProcess,$sExtraCounters,$sSep=';')
;
; Add Counters to the given Process PDH Object (combines Object Base and Instance with Counters to create full Counter Paths)
;	*IMPORTANT!! - If @error=32, $aPDHProcess is invalidated (and the PDH Query Handle is freed)
;
; $aPDHProcess = Process PDH Object (array) returned from _PDH_ProcessObjectCreate()
; $sExtraCounters = Counters to add, separated by $sSep if more than one.
;	These are combined with Process Object and Instance to create full Counter paths
; $sSep = Separator character used to split $sExtraCounters (default: ';')
;
; Returns:
;	Success: True, with @error = 0 and Counters Added.
;		Also, if there was a change in Instance, $aPDHProcess's 'Instance' and Counters are reset
;	Failure: False with @error set (and if @error=32, $aPDHProcess destroyed*):
;		@error = 16 = PDH not initialized
;		@error = 1 = Invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;		@error = 7 = non-localized string passed, but invalid format
;		@error = 32 = process does not exist or couldn't be found in ProcessList*
;			*IMPORTANT!! - If @error=32, $aPDHProcess is invalidated (and the PDH Query Handle is freed)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessObjectAddCounters(ByRef $aPDHProcess,$sExtraCounters,$sSep=';')
	If Not IsArray($aPDHProcess) Or $sExtraCounters="" Then Return SetError(1,0,False)

	; Verify instance name matches 1st! If not, remove and re-add counters before continuing (or if process is dead, stop)
	If Not __PDHPO_VerifyInstance($aPDHProcess) Then Return SetError(@error,@extended,False)
	_PDH_DebugWrite("__PDHPO_VerifyInstance called, @extended="&@extended)

	If Not _PDH_ObjectBaseAddCounters($aPDHProcess,$sExtraCounters,"",$sSep) Then Return SetError(@error,@extended,False)
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessObjectRemoveCounters(ByRef $aPDHProcess,$sKillPCs,$sSep=';')
;
; Remove Counters from the given Process PDH Object.
;
; $aPDHProcess = Process PDH Object (array) returned from _PDH_ProcessObjectCreate()
; $sKillPCs = Process Counters to remove, separated by $sSep if more than one.
; $sSep = Separator character used to split $sKillPCs (default: ';')
;
; Returns:
;	Success: True, with @error=0, @extended = total Counters removed
;	Failure: False, with @error set:
;		@error = 1 = Invalid parameter
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessObjectRemoveCounters(ByRef $aPDHProcess,$sKillPCs,$sSep=';')
	If Not _PDH_ObjectBaseRemoveCounters($aPDHProcess,$sKillPCs,$sSep,3) Then Return SetError(@error,@extended,False)
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessObjectCollectQueryData(ByRef $aPDHProcess)
;
; Updates the Counters attached to the Process Object's Query Handle - doesn't actually collect the values.
;	Collecting values is done via _PDH_ProcessObjectUpdateCounters()
;
; $aPDHProcess = Process PDH Object (array) returned from _PDH_ProcessObjectCreate()
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

Func _PDH_ProcessObjectCollectQueryData(ByRef $aPDHProcess)
	; Collect Query Data (update all attached Counter Values).
	If Not _PDH_ObjectBaseCollectQueryData($aPDHProcess) Then Return SetError(@error,@extended,False)
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessObjectUpdateCounters(ByRef $aPDHProcess,$iIndex=-1)
;
; Update Counters that are part of the Process PDH Object, and return a Value or Array (if $iIndex=-1)
;	*IMPORTANT!! - If @error=32, $aPDHProcess is invalidated (and the PDH Query Handle is freed)
;
; $aPDHProcess = Process PDH Object (array) returned from _PDH_ProcessObjectCreate()
; $iIndex = 0-based Index of Counter to retrieve value for. -1 returns and entire array.
;
; Returns:
;	Success: Individual Counter Value, or array of ALL values if $iIndex<0, with @error = 0
;	 Array returned when $iIndex=-1:
;		[0] = 1st Counter Value
;		[1-x] = Next Counter Values
;	  NOTE: On arrays, individual error checks are not done.  However, array elements will be set to -1 if an error occurred
;	   Also, If there was a change in Instance, $aPDHProcess's 'Instance' and Counters are reset
;	Failure: "" with @error set (and if @error=32, $aPDHProcess destroyed*):
;		@error = 16 = PDH not initialized
;		@error = 1 = invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = -1 = PDH error 'PDH_INVALID_DATA' (0xC0000BC6) Returned
;		@error = 32 = process does not exist or couldn't be found in ProcessList*
;			*IMPORTANT!! - If @error=32, $aPDHProcess is invalidated (and the PDH Query Handle is freed)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessObjectUpdateCounters(ByRef $aPDHProcess,$iIndex=-1)
	If Not IsArray($aPDHProcess) Or $iIndex+1>=$aPDHProcess[1][3] Or $aPDHProcess[1][3]=1 Then Return SetError(1,0,"")

	Local $iPID,$iVal,$iErr,$iExt
	Dim $aValues[$aPDHProcess[1][3]-1]

	; Maximum of two tries to CollectQueryData and update the counter
	For $i=1 To 2
		; Leaving 4th param set to False allows this to additionally call _PDH_CollectQueryData()
		$iPID=_PDH_UpdateCounter($aPDHProcess[1][0],$aPDHProcess[2][2])
		; Counter changed Process it is monitoring? (instance index # change). Or -1 returned from _PDH_UpdateCounter()
		If $iPID<>$aPDHProcess[0][3] Then
			$iErr=@error
			$iExt=@extended
			If Not __PDHPO_VerifyInstance($aPDHProcess) Then Return SetError(@error,@extended,"")
			ContinueLoop
		EndIf
		; Everything should be kosher
		ExitLoop
	Next
	If $i>2 Then Return SetError($iErr,$iExt,"")	; 2 full cycles and no success ($i incremented past 2 stops loop)

	If $iIndex<0 Then
		; No error checking here.. but Counter Values will be set to -1 where there are errors
		For $i=0 To $aPDHProcess[1][3]-2
			$aValues[$i]=_PDH_UpdateCounter($aPDHProcess[1][0],$aPDHProcess[$i+3][2],"",True)
		Next
		Return $aValues
	Else
		$iVal=_PDH_UpdateCounter($aPDHProcess[1][0],$aPDHProcess[$iIndex+3][2],"",True)
		If @error Then Return SetError(@error,@extended,"")
		Return $iVal
	EndIf
EndFunc


; ===================================================================================================================
;	--------------------	WRAPPER FUNCTIONS	--------------------
; ===================================================================================================================


; ===============================================================================================================================
; Func _PDH_ProcessObjectGetPID(Const ByRef $aPDHProcess)
;
; Simply returns the Process ID # of the given Process Object.
;
; $aPDHProcess = Process PDH Object (array) returned from _PDH_ProcessObjectCreate()
;
; Returns:
;	Success: Process ID #, with @error=0
;	Failure: 0 with @error set:
;		@error = 1 = invalid parameter
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessObjectGetPID(Const ByRef $aPDHProcess)
	If Not IsArray($aPDHProcess) Then Return SetError(1,0,0)
	Return $aPDHProcess[0][3]
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessObjectGetName(Const ByRef $aPDHProcess)
;
; Simply returns the Process Name of the given Process Object.
;
; $aPDHProcess = Process PDH Object (array) returned from _PDH_ProcessObjectCreate()
;
; Returns:
;	Success: Process Name, with @error=0
;	Failure: "" with @error set:
;		@error = 1 = invalid parameter
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessObjectGetName(Const ByRef $aPDHProcess)
	If Not IsArray($aPDHProcess) Then Return SetError(1,0,"")
	Return $aPDHProcess[0][2]
EndFunc
