#include-once

; ===============================================================================================================================
; <_PDH_TaskMgrSysStats.au3>
;
; Function(s) utilizing PDH Performance Counters to get specific Task Manager System Stats that typically show on
;	Windows' Task Manager. It excludes Process Counters from the 'mix' because there's a whole other interface for those.
;
; Functions:
;	_PDH_TaskMgrSysStatsAddCounters()		; Looks Up & Adds System Stats Counters
;	_PDH_TaskMgrPerfStatsUpdateCounters()	; Updates the TaskMgrSysStats Counters (calls _PDH_UpdateCounters())
;
; Dependencies:
;	<_PDH_PerformanceCounters.au3>	; Core Performance Counters module
;
; See also:
;	<_PDH_ObjectBaseCounters.au3>	; Special Object-based Interface for interacting with Counters
;	<_PDH_ProcessCounters.au3>		; Individual *local* Process Object Interface
;	<_PDH_ProcessAllCounters.au3>	; *ALL* local Processes Object Interface
;	<TestPDH_ObjectTests.au3>		; Example use/tests of the 3 Object Counters modules
;	<TestPDH_ProcessLoop.au3>		; Example use of <_PDH_ProcessAllCounters.au3>
;									;  (for displaying Process Info in a loop)
;	<_PDH_ProcessGetRelatives.au3>	; Uses ObjectBaseCounters to give 'ProcessList' & Child/Parent Process Info
;	<TestPDH_ProcessGetRelatives.au3>	; Test of the <_PDH_ProcessGetRelatives.au3>
;	<TestPDH_TaskManager.au3>		; Test of the <_PDH_TaskMgrSysStats.au3> and <_PDH_ProcessAllCounters.au3>
;									;  ** A very messy W.I.P. currently **;
;	<TestPDH_PerformanceCounters.au3>	; GUI interface to much of <_PDH_PerformanceCounters.au3>
;	<_Process*.au3>		; UDF's gathering alot of information regarding Processes
;	<_WinGetTaskManagerWinList.au3>	; task manager window list, often slightly different that Alt-Tab window list
;
; Reference:
;	'Memory Performance Information (Windows)' on MSDN
;		@ http://msdn.microsoft.com/en-us/library/aa965225%28v=VS.85%29.aspx
;	(Most info is available via Process function calls, however some things aren't
;	 for example: 'Private Working Set' is only available using Performance Counters)
;
; Author: Ascend4nt
; ===============================================================================================================================


; ===============================================================================================================================
; Func _PDH_TaskMgrSysStatsAddCounters($hPDHQueryHandle,$sPCName="",$iExtraCols=0)
;
; Adds the Task Manager System Performance Stats Counters to $hPDHQueryHandle, and puts the Counters in a 2D array
;
;	NOTE: _PDH_Init() must have been called, and a PDH Query Handle must have been obtained (with nothing added to it)
;
; $hPDHQueryHandle = The PDH Query Handle which we will attach Counter Handle(s) to
; $iExtraColumns = # of extra columns to add in addition to the 2 columns allocated for the Counters
;
; The 2D array returned is in this format (non-array elements listed are for info purposes):
;	[0][0]  = # of System Stats Counters (add 1 to index CPU Stats)
;	[0][1]  = # of CPUs +1 ('_Total' element) (of Counter "\Processor(*)\% Processor Time")
;	[1][0]  = [Totals: Handles]	(":230\952\(_Total)" or "\Process(_Total)\Handle Count")
;	[2][0]  = [Totals: Threads]	(":2\250\" or "\System\Threads", same as available as ":230\680\(_Total)" or "\Process(_Total)\Thread Count")
;	[3][0]  = [Totals: Processes] (":2\248\" or "\System\Processes")
;	[4][0]  = [Commit Charge (K): Total]	(":4\26\" or "\Memory\Committed Bytes")  [/ 1024]
;	[5][0]  = [Commit Charge (K): Limit]	(":4\30\" or "\Memory\Commit Limit") [/ 1024]
;				*[Commit Charge (K): Peak] ? (use 'GetPerformanceInfo' to obtain)
;				[Physical Memory (K): Total -> obtain this manually through MemGetStats() -> [1]
;	[6][0]  = [Physical Memory (K): Available] (":4\1380\" or "\Memory\Available KBytes") * also available through MemGetStats() -> [2]
;				*[Physical Memory (K): System Cache] ? (either available through Undocumented functions or 'GetPerformanceInfo' API)
;	  [Kernel Memory (K): Total -> obtain by adding the below two:
;	[7][0]  = [Kernel Memory (K): Paged] (":4\56\" or "\Memory\Pool Paged Bytes") [/ 1024]
;	[8][0]  = [Kernel Memory (K): Nonpaged] (":4\58\" or "\Memory\Pool Nonpaged Bytes") [/ 1024]
; PageFile Usage:
;  Percentages:
;	[9][0]  = Paging File % Usage (":700\702\(_Total)" or "\Paging File(_Total)\% Usage")
;	[10][0] = Paging File PEAK % Usage (":700\704\(_Total)" or "\Paging File(_Total)\% Usage Peak")
;  Sizes:
;	MemGetStats():	Total PageFile size (KB): [3], Available: [4], Used: [3]-[4]
;  CPU % Usage:
;	[11][0] = 1st CPU Usage Counter Handle (":238\6\(*)" or English: "\Processor(*)\% Processor Time")
;	.. through ..
;	[11+#ofCPUs][0] = '_Total' CPU Usage Counter Handle (overall percentage - ex: 4 CPU's, 1 at 100%, this will be 25%)
;	.....
;	[x][1->ExtraColumns] = not set
;
; Returns:
;	True: Array returned (see above format), @error=0
;	Failure: "" with @error set:
;		@error = 1  = invalid parameter
;		@error = 2  = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3  = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4  = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5  = 2nd DLL call successful, but data returned is invalid
;		@error = 7  = non-localized string passed, but invalid format
;		@error = 10 = error occurred adding Counters (removed all)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_TaskMgrSysStatsAddCounters($hPDHQueryHandle,$sPCName="",$iExtraCols=0)
	; Properly initialized?
	If Not $_PDH_bInit Then Return SetError(16,0,False)
	; Check if Query Handle is valid
	If Not IsPtr($hPDHQueryHandle) Or $iExtraCols<0 Then Return SetError(1,0,False)

	Local $iErrCount=0,$iIndex,$aCPUsList,$iCPUsCount

	; Strip first '\' from PC Name, if passed
	If $sPCName<>"" And StringLeft($sPCName,2)="\\" Then $sPCName=StringTrimLeft($sPCName,1)

	; CPU Usage (per processor) (":238\6\(*)" or English: "\Processor(*)\% Processor Time")
	$aCPUsList=_PDH_GetCounterList(":238\6\(*)"&$sPCName)
	If @error Then Return SetError(@error,@extended,"")
	$iCPUsCount=$aCPUsList[0]		; if we wanted just the CPU's, we'd subtract 1 to remove the '_Total' Counter

#cs
	; -----------------------------------------------------------------------------------
	;	System Stats Performance Counters To Be Added
	; -----------------------------------------------------------------------------------
	; [Totals: Handles]	(":230\952\(_Total)" or "\Process(_Total)\Handle Count")
	; [Totals: Threads]	(":2\250\" or "\System\Threads")
	; [Totals: Processes] (":2\248\" or "\System\Processes")
	; [Commit Charge (K): Total]	(":4\26\" or "\Memory\Committed Bytes") [/ 1024]
	; [Commit Charge (K): Limit]	(":4\30\" or "\Memory\Commit Limit") / 1024
	; [Physical Memory (K): Available]  (":4\24\" or "\Memory\Available Bytes") [/1024] (KBytes also available..)
	; [Kernel Memory (K): Paged] (":4\56\" or "\Memory\Pool Paged Bytes") [/ 1024]
	; [Kernel Memory (K): Nonpaged] (":4\58\" or "\Memory\Pool Nonpaged Bytes") [/ 1024]
	; Paging File % Usage (":700\702\(_Total)" or "\Paging File(_Total)\% Usage")
	; Paging File PEAK % Usage (":700\704\(_Total)" or "\Paging File(_Total)\% Usage Peak")
	; -----------------------------------------------------------------------------------
	; + [CPU Usage] * # of CPU's. 	(":238\6\(*)" or English: "\Processor(*)\% Processor Time")
	; -----------------------------------------------------------------------------------
#ce
	Local $aSysStats[10+$iCPUsCount]=[":230\952\(_Total)",":2\250\",":2\248\",":4\26\",":4\30\",":4\24\", _
		":4\56\",":4\58\",":700\702\(_Total)",":700\704\(_Total)"]

	; Add CPU "% Processor Time" strings to $aSysStats array
	For $i=1 To $iCPUsCount
		$aSysStats[$i+9]=$aCPUsList[$i]
	Next

	; Size TMSysStats to encompass all statss + CPU Usage + 1 for 'bottom' row (for count info)
	Dim $aTMSysStats[$iCPUsCount+10+1][2+$iExtraCols]
	$aTMSysStats[0][0]=10			; Count of Stats
	$aTMSysStats[0][1]=$iCPUsCount	; Count of CPU Stats (includes '_Total' element)

	; Add all the Counters
	For $i=0 To 9
		$aTMSysStats[$i+1][0]=_PDH_AddCounter($hPDHQueryHandle,$aSysStats[$i]&$sPCName)
		If @error Then $iErrCount+=1
	Next
	; 2nd loop because CPU "% Processor Time" Wildcard expansion resulted in full formatted strings (with PCName prefixed)
	For $i=10 To $iCPUsCount+9
		$aTMSysStats[$i+1][0]=_PDH_AddCounter($hPDHQueryHandle,$aSysStats[$i])
		If @error Then $iErrCount+=1
	Next

	; Any errors adding counters ruins the party
	If $iErrCount Then
		For $i=1 To $iCPUsCount+10
			_PDH_RemoveCounter($aTMSysStats[$i][0])
		Next
		SetError(10,$iErrCount,"")
	EndIf

	Return $aTMSysStats
EndFunc


; ===============================================================================================================================
; Func _PDH_TaskMgrPerfStatsUpdateCounters($hPDHQueryHandle,ByRef $aTMPerfStats,$bFirstCall=False)
;
; Calls _PDH_UpdateCounters() for a TMPerfStats array generated by _PDH_TaskMgrPerfStatsAddCounters()
;	(Result: updated info)
; *NOTE: also performs KB conversion for items that are displayed in KB
;
; $hPDHQueryHandle = The PDH Query Handle which has the TaskMgr Counter Handle(s) attached to it
; $aTMPerfStats = the array returned from _PDH_TaskMgrPerfStatsAddCounters()
; $bFirstCall = Returns the # of changes in @extended if False, otherwise 0
;
; Returns:
;	Success: True, Array elements [1] updated, @error=0, and @extended=# of changes (if $bFirstCall=False)
;	Failure: False, with @error set:
;		@error = 16 = not initialized
;		@error = 1 = Invalid parameters
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_TaskMgrSysStatsUpdateCounters($hPDHQueryHandle,ByRef $aTMSysStats,$bFirstCall=False)
	Local $tExt
	If Not _PDH_UpdateCounters($hPDHQueryHandle,$aTMSysStats,0,1,-1,-1,1,-1,$bFirstCall) Then Return SetError(@error,@extended,False)
	$tExt=@extended
	; Bytes -> KBytes conversion
	For $i=4 To 8
		$aTMSysStats[$i][1]=Round($aTMSysStats[$i][1]/1024)
	Next
	Return SetError(0,$tExt,True)
EndFunc

#cs
#include <Array.au3>
_PDH_Init()
$hPDHQuery=_PDH_GetNewQueryHandle()
$aArr=_PDH_TaskMgrSysStatsAddCounters($hPDHQuery,"")
_ArrayDisplay($aArr,"_PDH_TaskMgrSysStatsAddCounters")
_PDH_TaskMgrSysStatsUpdateCounters($hPDHQuery,$aArr)
_PDH_TaskMgrSysStatsUpdateCounters($hPDHQuery,$aArr)
_ArrayDisplay($aArr,"_PDH_TaskMgrSysStatsAddCounters Updated")
_PDH_FreeQueryHandle($hPDHQuery)
_PDH_UnInit()
#ce