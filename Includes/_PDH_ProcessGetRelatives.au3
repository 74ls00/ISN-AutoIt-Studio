#include-once

; ===============================================================================================================================
; <_PDH_ProcessGetRelatives.au3>
;
; Functions to get a Process List, plus Parent & Child process info.
;
; Functions:
;	_PDH_ProcessList()			; retrieves a Process List (name,PID,Parent PID) for the given PC
;	_PDH_ProcessGetParent()		; retrieves the parent Process/ID of the process that spawned the source PID/process
;	_PDH_ProcessGetChildren()	; retrieve an array of processes that were spawned by the source PID/process
;
; Requirements: AutoIT 3.3.6+
;
; Dependencies:
;	<_PDH_ObjectBaseCounters.au3>	; Special Object-based Interface for interacting with Counters
;
; Deeper Dependencies:
;	<_PDH_PerformanceCounters.au3>	; Core Performance Counters module
;	<_WinTimeFunctions.au3>			; FileTime conversions module needed for Time value conversions
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


; ===============================================================================================================================
; Func _PDH_ProcessList($sPCName="")
;
;	Function to get a Process List with Process Name, Process ID, and Parent Process ID #.
;	 Note that the 'Process Name' will be the process name without any '.exe' extension
;		(however, any other extension types will be left alone [ex: "process.tmp"])
;
; $sPCName = (Optional) Computer name to get the Process List from. Format is "\\PCNAME"
;
; Returns:
;	Success: Process List array, @error=0.  Array layout:
;		[0][0]  = # of Processes
;		[$i][0] = Process Name (without '.exe' extension if it had one [see above])
;		[$i][1] = Process ID #
;		[$i][2] = Parent Process ID #
;	Failure: "", @error set:
;		@error = 16 = not initialized (or could not be initialized)
;		@error = -1 = PDH error 'PDH_INVALID_DATA' (0xC0000BC6) Returned in Updating Counters
;		@error = 1 = invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5 = Buffer size 'needed' return does not match passed $iBufSize parameter (unlikely)
;		@error = 6 = # of Counters returned does not match $iNumCounters parameter (unlikely)
;		@error = 7  = non-localized string passed, but invalid format
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessList($sPCName="")
	Local $aProcList,$coProcess,$iErr,$iExt,$bPDHWasInit=True

	If Not $_PDH_bInit Then
		$bPDHWasInit=False
		If Not _PDH_Init() Then Return SetError(@error,@extended,"")
	EndIf

	; Object Base: 230 ("Process"), Counters for Object Base: 784 ("ID Process"), 1410 ("Creating Process ID")
	$coProcess=_PDH_ObjectBaseCreate(230,$sPCName,"784;1410")

	If Not @error Then $aProcList=_PDH_ObjectBaseUpdateCounters($coProcess)
	If @error Then
		$iErr=@error
		$iExt=@extended
		_PDH_ObjectBaseDestroy($coProcess)
		If Not $bPDHWasInit Then _PDH_UnInit()
		Return SetError($iErr,$iExt,"")
	EndIf
	_PDH_ObjectBaseDestroy($coProcess)
	If Not $bPDHWasInit Then _PDH_UnInit()

	ReDim $aProcList[$aProcList[0][0]][3]	; Remove the '_Total' row
	$aProcList[0][0]-=1						; Take off 1 off count (for '_Total' row)

	Return $aProcList
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessGetParent($vProcessID=@AutoItPID,$sPCName="")
;
; Function to get the Parent (creating) Process ID & name of $vProcessID, using PDH Performance Counters
;
; $vProcessID = ID or name of process to get the parent process of
;	NOTE: This can *only* be a Process Name if $sPCName=""
; $sPCName = (Optional) Computer name to look at the Process List on. Format is "\\PCNAME"
;
; Returns:
;	Success: Process Info array, @error = 0.
;		$array[0]=Parent Process name (or "" if the Process no longer exists)
;		$array[1]=Parent Process ID
;	Failure: "", @error set:
;		@error = 16 = not initialized (or could not be initialized)
;		@error = -1 = PDH error 'PDH_INVALID_DATA' (0xC0000BC6) Returned in Updating Counters
;		@error = 1 = invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5 = Buffer size 'needed' return does not match passed $iBufSize parameter (unlikely)
;		@error = 6 = # of Counters returned does not match $iNumCounters parameter (unlikely)
;		@error = 7  = non-localized string passed, but invalid format
;		@error = 20 = Process Name passed, but PCName isn't local (need to send PID # when PCName is passed)
;		@error = 32 = Process ID not located
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessGetParent($vProcessID=@AutoItPID,$sPCName="")
	If Not IsNumber($vProcessID) Then
		If $sPCName<>"" Then Return SetError(20,0,"")	; must be LOCAL in order to allow Process names
		$vProcessID=ProcessExists($vProcessID)
		If $vProcessID=0 Then Return SetError(1,0,"")
	EndIf

	Local $aProcList=_PDH_ProcessList($sPCName)
	If @error Then Return SetError(@error,@extended,"")

	Local $bFound=False,$aProcFound[2]=[0,""]

	; Okay - array is good. Now to find the parent process
	For $i=1 to $aProcList[0][0]
		If $vProcessID=$aProcList[$i][1] Then	; Process match the current row Process ID?
			$bFound=True
			$aProcFound[1]=$aProcList[$i][2]	; Set the parent Process ID
			; And now get that process ID's name if it still exists
			For $i=1 to $aProcList[0][0]
				If $aProcFound[1]=$aProcList[$i][1] Then
					$aProcFound[0]=$aProcList[$i][0]
					ExitLoop
				EndIf
			Next
			ExitLoop
		EndIf
	Next
	If Not $bFound Then Return SetError(32,0,"")
	; If local, check if Process without appended '.exe' exists. If not, just append it
	If $sPCName="" And $aProcFound[0]<>"" And $aProcFound[0]<>"Idle" Then
		If Not ProcessExists($aProcFound[0]) Then $aProcFound[0]&='.exe'
	EndIf
	Return $aProcFound
EndFunc


; ===============================================================================================================================
; Func _PDH_ProcessGetChildren($vProcessID=@AutoItPID,$hPDHQueryHandle=0,$hPDHPIDCounterHandle=0,$hPDHPPIDCounterHandle=0)
;
; Function to get the Process ID('s) and name(s) of $vProcessID's Child Process(es), using PDH Performance Counters
;
; $vProcessID = ID or name of process to get the child process(es) of.
;	NOTE: This can *only* be a Process Name if $sPCName=""
; $sPCName = (Optional) Computer name to look at the Process List on. Format is "\\PCNAME"
;
; Returns:
;	Success: Child Processes Info array, @error = 0, @extended=total # of processes.  Array format:
;	  NOTE: if no child processes, then "" is returned with @error set to 32 (Failure)
;		$array[$i][0]=Child Process name
;		$array[$i][1]=Child Process ID
;	Failure: "", @error set:
;		@error = 16 = not initialized (or could not be initialized)
;		@error = -1 = PDH error 'PDH_INVALID_DATA' (0xC0000BC6) Returned in Updating Counters
;		@error = 1 = invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5 = Buffer size 'needed' return does not match passed $iBufSize parameter (unlikely)
;		@error = 6 = # of Counters returned does not match $iNumCounters parameter (unlikely)
;		@error = 7  = non-localized string passed, but invalid format
;		@error = 20 = Process Name passed, but PCName isn't local (need to send PID # when PCName is passed)
;		@error = 32 = Process ID not located as a Parent Process to any existing Processes
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ProcessGetChildren($vProcessID=@AutoItPID,$sPCName="")
	If Not IsNumber($vProcessID) Then
		If $sPCName<>"" Then Return SetError(20,0,"")	; must be LOCAL in order to allow Process names
		$vProcessID=ProcessExists($vProcessID)
		If $vProcessID=0 Then Return SetError(1,0,"")
	EndIf

	Local $aProcList=_PDH_ProcessList($sPCName)
	If @error Then Return SetError(@error,@extended,"")

	Local $iTotalChildren=0,$bFound=False

	; Initialize the array to the maximum possible # of children
	Dim $aProcFound[$aProcList[0][0]][2]
	$iTotalChildren=0

	; Okay - array is good. Now to find the parent process
	For $i=1 to $aProcList[0][0]
		If $vProcessID=$aProcList[$i][2] Then	; Process ID match the Parent Process ID?
			; Add the child process info
			$aProcFound[$iTotalChildren][0]=$aProcList[$i][0]
			$aProcFound[$iTotalChildren][1]=$aProcList[$i][1]
			$iTotalChildren+=1
		EndIf
	Next

	; No children found?
	If $iTotalChildren=0 Then Return SetError(32,0,"")

	; Resize to the # of children found
	ReDim $aProcFound[$iTotalChildren][2]

	; If local, check if Processes without appended '.exe' exists. If not, just append it
	If $sPCName="" Then
		For $i=0 To $iTotalChildren-1
			If Not ProcessExists($aProcFound[$i][0]) And $aProcFound[$i][0]<>"Idle" Then $aProcFound[$i][0]&='.exe'
		Next
	EndIf
	Return SetExtended($iTotalChildren,$aProcFound)
EndFunc
