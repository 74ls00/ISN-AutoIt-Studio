#include-once

; ===============================================================================================================================
; <_PDH_PerformanceCounters.au3>
;
; Functions to Initialize, Get, Update, Collect Values, and Uninitialize PDH Performance Counters
;	Performance Counters are performance information reported from the current PC or a Networked PC
;	encompassing Process, Processor, Network, System, .NET, Hardware, and other Performance Data
;
;	version 2011.05.28
;
; AutoIT version requirements: Minimum: AutoIT v3.3.6.0 (3.2.12.1 Unicode if alter DLLCall/Struct types)
;	OS: Windows 2000+
;
; TO DO: Test Registry functions on Remote PC's.
;
; Functions:
;	_PDH_RegistryCheck()	; Checks if Performance Counters are enabled in the Registry (Returns True if they are)
;
; * NOTE * - The following 2 functions require ADMINISTRATOR privileges and *MAY* require a reboot depending on O/S
;	_PDH_RegistryEnable()	; Enables Performance Counters via the Registry (requires ADMIN privileges)
;	_PDH_RegistryDisable()	; Disables Performance Counters via the Registry (requires ADMIN privileges)
;
;	_PDH_Init()				; Initialize PDH.DLL handle, get CPU count, & verify registry key settings are correct
;	_PDH_UnInit()			; Release PDH.DLL handle & restore registry key settings
;	_PDH_ValidatePath()		; Function to check if a Counter path is valid or not
;	_PDH_ConnectMachine()	; Connects to another PC/Machine.  Not really required unless adding to the dropdown list for
;							;  _PDH_BrowseCounters(). Otherwise, the Browse Counters dialog does accept manual PC entry.
;	_PDH_BrowseCounters()	; Displays the "Browse Performance Counters" dialog box and allows selection
;	_PDH_GetCounterList()	; Returns an array OR 'multi-string' of counter paths (used in calling _PDH_AddCounter())
;	_PDH_GetNewQueryHandle()	; Get a new PDH Query Handle
;	_PDH_FreeQueryHandle()		; Free PDH Query Handle
;	_PDH_AddCounter()			; Add a Counter to a PDH Query Handle
;	_PDH_AddCountersByArray()	; Adds Counters to a PDH Query Handle using paths in an array
;								; (as returned by _PDH_GetCounterList()), returns 2-D array [path & Counter Handle]
;	_PDH_AddCountersByMultiStr()	; Adds Counters to a PDH Query Handle using paths passed in a 'Multi String'
;									;  (i.e. a string with multiple paths, separated by $sSepChar (ex: 'str1|str2|str3')
;	_PDH_AddCountersByWildcardPath() ; Wrapper - one call achieves GetCounterList() & AddCountersByArray()
;	_PDH_RemoveCounter()			; Removes a Counter Handle from a PDH Query Handle
;	_PDH_CounterNameToNonLocalStr()	; Converts a *full* Counter path to a non-localized generic string for use
;									;  with _PDH_AddCounter*() and _PDH_GetCounterList() functions.
;									; RESOLVES LOCALIZED<->NONLOCALIZED COUNTER PORTABILITY ISSUES
;	_PDH_GetCounterInfo()		; Retrieves a formatted string of information about the given PDH Counter
;	_PDH_CollectQueryData()		; Function used before or during 'UpdateCounter' calls (this updates Counter values *internally*)
;								;  Use *outside* of 'UpdateCounter' functions allows one to grab each Counter separately
;								;  without having to re-collect the data (see $bGrabValueOnly in 'UpdateCounter' functions)
;	_PDH_UpdateCounter()		; Update Counter(s) attached to a PDH Query Handle and Returns new Value of *ONE* Counter
;	_PDH_UpdateWildcardCounter(); Updates Wildcard Counter(s) attached to a PDH Query Handle, returns 2D array of new values
;	_PDH_UpdateCounters()		; Updates Array of Counters attached to a PDH Query Handle inserting current Values,
;								;  and optionally, Delta Values.  A 2D array must be passed by Reference.
;								;  The only required columns are 'Counter Handle' and 'Value', both of which can be in any column
;								;	same as the start/end rows.  'Counter Name' and 'Delta Value' columns are also optional
;	_PDH_GetCounterValueByPath()	; Wrapper - Adds a Counter, Grabs the counter value, Removes Counter, Returns Value
;
; *Mostly* for Internal-Use functions (but can be called given the caller knows what's what):
;	_PDH_GetCounterNameByIndex() ; Gets a Counter or Object name by Index #.  (used by _PDH_AddCounter*, _PDH_GetCounterList)
;	_PDH_GetCounterIndex()		; Gets the Counter or Object Index #. (used by _PDH_CounterNameToNonLocalStr())
;
; INTERNAL-ONLY functions:
;	_PDH_DebugWrite()				; Writes debug output to Console if $PDH_DEBUGLOG>=1
;	_PDH_DebugWriteErr()			; Writes debug error output to Console if $PDH_DEBUGLOG>=2
;	__PDH_RegistryToggle()			; Sets, clears, or checks state of Registry values pertaining to Performance Counters' availability
;	__PDH_LocalizeCounter()			; Converts 'non-localized' string to a Full (localized) Counter Path. Used by 3 functions
;	__PDH_StringGetNullTermMemStr()	; Grabs a zero-terminated string where the length is unknown
;
; Dependencies:
;	<_WinAPI_GetSystemInfo_ISN.au3>		; System basic info, used for CPU count info
;
; See also:
;	<TestPDH_PerformanceCounters.au3>	; GUI interface to much of <_PDH_PerformanceCounters.au3>
;	<_PDH_ObjectBaseCounters.au3>	; Special Object-based Interface for interacting with Counters
;	<_PDH_ProcessCounters.au3>		; Individual *Local* Process Object Interface
;	<_PDH_ProcessAllCounters.au3>	; *ALL* Local-Processes Object Interface
;	<TestPDH_ObjectTests.au3>		; Example use/tests of the 3 Object Counters modules
;	<TestPDH_ProcessLoop.au3>		; Example use of <_PDH_ProcessAllCounters.au3>
;									;  (for displaying Process Info in a loop)
;	<_PDH_ProcessGetRelatives.au3>	; Uses ObjectBaseCounters to give 'ProcessList' & Child/Parent Process Info
;	<TestPDH_ProcessGetRelatives.au3>	; Test of the <_PDH_ProcessGetRelatives.au3>
;	<_PDH_TaskMgrSysStats.au3>		; System Statistics Counters useful in gathering Task-Manager type info
;	<TestPDH_TaskManager.au3>		; Test of the <_PDH_TaskMgrSysStats.au3> and <_PDH_ProcessAllCounters.au3>
;									;  ** A very messy W.I.P. currently **;
;	<_ProcessRegPerfCounters.au3>	; started, but never finished (too slow and complex)
;	[CpuUsage_src].zip 				; Registry Performance Counters C++ code
;
; NOTES:
;	Performance Counters Registry Key Values which affect Performance Counter availability:
;
;	 Key: HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib
;	 Value: Disable Performance Counters
;
;	 Key: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfOS\Performance
;	  Value: Disable Performance Counters
;
;	 Key: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfProc\Performance
;	  Value: Disable Performance Counters
;
; 	If _PDH_Init() doesn't have write access to HKLM branch and one/all are set to non-zero,
;	 functions would probably return 'PDH_CSTATUS_NO_OBJECT' if these Values are set to 1,
;		and _PDH_Init() wasn't able to change them. (It may take a reboot between changing them though...)
;
; Additional:
;	Processes ending in .EXE are reported\looked up *without* the ending .EXE
;		(i.e. svchost.exe = svchost, or svchost#0 (and #1 etc - depending on # of instances) )
;	Processes ending in *ANYTHING* else RETAIN their .ext (example: more.com, scrnsave.scr,Creative_Audio_Engine_Cleanup.0001)
;		Wildcard Counters may help, but there are modules bundled now that handle Process Counters effectively.
;
;	There's a service you can start at the 'Run' prompt named 'perfmon.msc'.. doesn't seem to do a whole lot, though..?
;
; References (see _PDH_PerformanceCounter_Notes.txt and _PDH_Error_Codes.txt for PDH error codes)
;
; Author: Ascend4nt
; ===============================================================================================================================


; ===============================================================================================================================
;  --------------------  GLOBAL PDH VALUES  --------------------
; ===============================================================================================================================

; Used in all _PDH calls (though 1st 2 not necessary for _PDH_BrowseCounters(),_PDH_GetCounterList())
Global $_PDH_hDLLHandle=-1,$_PDH_bInit=False,$_PDH_iLastError=0

; Available after a call to _PDH_UpdateCounters()
Global $_PDH_aInvalidHandles[1]=[0]

; Registry modification variables
Global $_PDH_REG_MODIFIED,$_PDH_RESTORE_REG

; Used by _PDH_UpdateCounters (and other functions that adjust Counter results by # CPU's). Initialized by Init()
Global $_PDH_iCPUCount

; Used to toggle Console-Output to one of 3 modes: 0=completely Off, 1=Report Errors only, >1=Report ALL
Global $PDH_DEBUGLOG=1


; ===================================================================================================================
;	--------------------	INTERNAL FUNCTIONS	--------------------
; ===================================================================================================================


; ===============================================================================================================================
; Func _PDH_DebugWrite($sString,$bAddCRLF=True)
; + Func _PDH_DebugWriteErr($sString,$bAddCRLF=True)
;
; Simple functions to replace 'ConsoleWrite' that allows Debug output to be silenced (see $PDH_DEBUGLOG)
;	(also could be saved to a log)
;
; $sString = string to output (if $PDH_DEBUGLOG=True)
; $bAddCRLF = Add @CRLF to output? True in most cases
;
; Returns: nothing
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_DebugWrite($sString,$bAddCRLF=True,$bErr=False)
	; Less than 2 -> don't report on non-error related events
	If $PDH_DEBUGLOG<2 Then Return
	If $bAddCRLF Then $sString&=@CRLF
	ConsoleWrite($sString)
EndFunc

;~

Func _PDH_DebugWriteErr($sString,$bAddCRLF=True)
	If $PDH_DEBUGLOG<1 Then Return
	If $bAddCRLF Then $sString&=@CRLF
	ConsoleWriteError($sString)
EndFunc


; ===============================================================================================================================
; Func __PDH_RegistryToggle($bEnable,$sPCName='')
;
; Multi-purpose function for testing, setting, or clearing the relevant Registry keys pertaining to Performance Counters.
;	A re-boot may be necessary for certain O/S's when Performance Counters are enabled or disabled.
;	(That is why this function was separated from the _PDH_Init() code, plus it looks cleaner)
;
; $bEnable = If 1, enable performance counters. If 0, disable. If -1, check if Performance Counters are enabled
; $sPCName = *optional* value -> the machine name, prefixed as normal with '\\' (Example: '\\PCNAME')
;
; Returns:
;	Success: True with @extended = # of changes, or just 1 (if $bEnable=-1) with @extended=0
;	Failure: False and @error set:
;		@error =  1 = invalid parameter ($sPCName)
;		@error = -1 = Performance Counters are disabled (return is a string - only if $bEnable=-1)
;		@error = 16 = error setting/clearing a registry value that needed to be altered. @extended contains RegWrite() error
;
; Author: Ascend4nt
; ===============================================================================================================================

Func __PDH_RegistryToggle($bEnable,$sPCName='')
	If Not IsString($sPCName) Then Return SetError(1,0,False)

	If $sPCName<>'' Then $sPCName&='\'

	; Performance Counter Registry values. If non-zero for 'Disable Performance Counters', Performance Counters are disabled
	Local $PDH_RegValues[3][3]=[ [$sPCName&"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib",''], _
		[$sPCName&"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfOS\Performance",''], _
		[$sPCName&"HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfProc\Performance",''] ]
	Local Const $PDH_DisableValue="Disable Performance Counters"

	Local $iSetVal,$iErr=0,$iChanged=0
	If $bEnable Then
		$iSetVal=0
	Else
		$iSetVal=1
	EndIf

	; Check important 'Disable Performance Counter' Values, and check/set/clear Performance Counters if possible
	For $i=0 To 2
		$PDH_RegValues[$i][1]=RegRead($PDH_RegValues[$i][0],$PDH_DisableValue)
		If @error Then $PDH_RegValues[$i][1]=0	; would be set to "", but we'll force an integer
		; If ENABLING - check if the key is there and set to a non-zero #, then attempt to set the value to 0
		;	If DISABLING - check that either the key *isn't* there, or that it is set to non-zero
		If ($bEnable And $PDH_RegValues[$i][1] And IsInt($PDH_RegValues[$i][1])) Or ($bEnable=0 And $PDH_RegValues[$i][1]=0) Then
			; Just checking? Too bad - Performance counters are disabled somewhere
			If $bEnable=-1 Then
				_PDH_DebugWriteErr("Performance Counters disabled, Registry Key: '"&$PDH_RegValues[$i][0]&"'")
				Return SetError(-1,0,False)
			EndIf
			; Write the registry value (either enable or disable)
			RegWrite($PDH_RegValues[$i][0],$PDH_DisableValue,"REG_DWORD",$iSetVal)
			$iErr=@error
			If $iErr Then ExitLoop
			$iChanged+=1
		EndIf
	Next

	If $bEnable=-1 Then Return 1	; Called with special 'just-checking' value - return 'Performance Counters enabled'

	; @error set by previous loop? - RegWrite() failed
	If $iErr Then
		; Reset any 'Disable Performance Counter' registry keys that were modified
		For $i=0 To 2
			; If the key was there and set to non-zero, we need to restore it to the original value
			If ($bEnable And $PDH_RegValues[$i][1] And IsInt($PDH_RegValues[$i][1])) Or ($bEnable=0 And $PDH_RegValues[$i][1]=0) Then
				RegWrite($PDH_RegValues[$i][0],$PDH_DisableValue,"REG_DWORD",$PDH_RegValues[$i][1])
			EndIf
		Next
		Return SetError(16,$iErr,False)
	EndIf

	Return SetExtended($iChanged,True)
EndFunc


; ===============================================================================================================================
; Func __PDH_LocalizeCounter($sNonLocalizedCounter)
;
; Internal function for converting from non-localized counter string to a localized Full Counter Path
;	WARNING: Do NOT call directly! It is assumed this will be called by one of the regular functions.
;
; $sNonLocalizedCounter = Counter in the :##\##(x)\PCNAME format. See _PDH_CounterNameToNonLocalStr
;
; Returns:
;	Success: Full Counter String
;	Failure: "" with @error = 7 (invalid format)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func __PDH_LocalizeCounter($sNonLocalizedCounter)
	Local $aSplitPath,$sPCName=""
	; Split counter up to individual components
	$aSplitPath=StringSplit(StringTrimLeft($sNonLocalizedCounter,1),"\",0)
	If @error Or $aSplitPath[0]<3 Then Return SetError(7,0,"")
	; Machine name?
	If $aSplitPath[0]>3 And $aSplitPath[4]<>"" Then $sPCName='\\'&$aSplitPath[4]
	; Assemble localized counter name
	Return $sPCName&'\'&_PDH_GetCounterNameByIndex(Int($aSplitPath[1]),$sPCName)&$aSplitPath[3]& _
		'\'&_PDH_GetCounterNameByIndex(Int($aSplitPath[2]),$sPCName)
EndFunc


; ===============================================================================================================================
; Func __PDH_StringGetNullTermMemStr($pStringPtr)
;
; Function to grab a null-terminated string from a memory location where the string size and end-of-buffer are undefined.
;	This avoids a few problems:
;	 1. Trying to grab *too* much memory (possibly resulting in access violations)
;	 2. Converting from a 'byte' buffer to a 'wchar' one (of the right size).
;	 3. Getting an offset to the data *after* the string.
;		Either use:
;			'(@extended+1)*2 for # of bytes including null-term. ([stringlen+1(null-term)*2 (*2 for Unicode two-byte size)])
;			 or if alternate function used, '(StringLen($sRet)+1)*2' (stringlen+1(null-term)*2)
;
; NOTE: While listed on MSDN as requiring Windows XP/2003+, these function(s) are in fact available on Windows 2000 (no SP).
;
; Returns:
;	Success: String or "" if 0-length, @error=0, @extended=string-length
;	Failure: "", with @error set:
;		@error = 1 = invalid parameter or pointer is 0
;		@error = 2 = DLLCall error (see @extended for DLLCall @error code)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func __PDH_StringGetNullTermMemStr($pStringPtr)
	If Not IsPtr($pStringPtr) Or $pStringPtr=0 Then Return SetError(1,0,"")
	; Get length of null-terminated string	; alternative: lstrcpynW (needs a different approach though)
	Local $aRet=DllCall("kernel32.dll","int","lstrlenW","ptr",$pStringPtr)
	If @error Then Return SetError(2,@error,"")
	If $aRet[0]=0 Then Return ""	; not an error, just a zero-length string
	; Set buffer size to string size and use pointer so that we can extract it into a variable
	Local $stString=DllStructCreate("wchar["&$aRet[0]&"]",$pStringPtr)
	Return SetExtended($aRet[0],DllStructGetData($stString,1))
EndFunc


; ===================================================================================================================
;	--------------------	MAIN FUNCTIONS	--------------------
; ===================================================================================================================


; ===============================================================================================================================
; Func _PDH_RegistryCheck($sPCName='')
;
; Checks to see if Performance Counters are enabled in the registry.
;
; $sPCName = *optional* value -> the machine name, prefixed as normal with '\\' (Example: '\\PCNAME')
;
; Returns:
;	Success: True = enabled, False with @error=0 = disabled
;	Failure: False, with @error set:
;		@error =  1 = invalid parameter ($sPCName)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_RegistryCheck($sPCName='')
	If __PDH_RegistryToggle(-1,$sPCName) Then Return True
	Return SetError(@error,@extended,False)
EndFunc


; ===============================================================================================================================
; Func _PDH_RegistryEnable($sPCName='')
;
; Enables Performance Counters via the Registry. (default on most machines is enabled)
;	NOTE: Requires ADMINISTRATOR Privileges, as it alters keys in the HKLM branch.
;
; $sPCName = *optional* value -> the machine name, prefixed as normal with '\\' (Example: '\\PCNAME')
;
; Returns:
;	Success: True with @extended = # of changes
;	Failure: False and @error set:
;		@error =  1 = invalid parameter ($sPCName)
;		@error = 16 = error setting/clearing a registry value that needed to be altered. @extended contains RegWrite() error
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_RegistryEnable($sPCName='')
	Local $vRet=__PDH_RegistryToggle(1,$sPCName)
	Return SetError(@error,@extended,$vRet)
EndFunc


; ===============================================================================================================================
; Func _PDH_RegistryDisable($sPCName='')
;
; Disables Performance Counters via the Registry.
;	NOTE: Requires ADMINISTRATOR Privileges, as it alters keys in the HKLM branch.
;
; $sPCName = *optional* value -> the machine name, prefixed as normal with '\\' (Example: '\\PCNAME')
;
; Returns:
;	Success: True with @extended = # of changes
;	Failure: False and @error set:
;		@error =  1 = invalid parameter ($sPCName)
;		@error = 16 = error setting/clearing a registry value that needed to be altered. @extended contains RegWrite() error
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_RegistryDisable($sPCName='')
	Local $vRet=__PDH_RegistryToggle(0,$sPCName)
	Return SetError(@error,@extended,$vRet)
EndFunc


; ===============================================================================================================================
; Func _PDH_Init($bForceCountersOn=False,$bRestoreRegStateOnExit=False)
;
; Simple call to 'initialize' PDH calling. Basically just Loads and sets the handle to the PDH.DLL,
;	AND clears any 'Disable Performance Counter' Registry values
;	REQUIRED since all handles obtained via PDH calls will be invalidated if it is not DLLOpen()'ed,
;	and probably won't work if those Reg values are set to non-zero
;
; $bForceCountersOn = If True, will attempt to enable Performance Counters through the registry.
;	Note that this requires ADMIN rights, and may require a reboot on certain O/S's.
;	If False, the function will fail if Performance Counters are disabled in the Registry.
; $bRestoreRegStateOnExit = If True, and $bForceCountersOn = True, the state of the Registry is restored on exit
;	If either is False, this parameter isn't used.
;
; NOTE: Opening the PDH.DLL and obtaining a PDH Query Handle creates a small file in the @TempDir named something like:
;	Perflib_Perfdata_xxx.dat
;  This file is typically small (~16 KB), so it's not a concern. And it is automatically deleted after _PDH_UnInit().
;
; Returns:
;	Success: True
;	Failure: False, with @error set:
;		@error =  1 = invalid parameter ($sPCName)
;		@error = 16 = Could not initialize (due to Registry settings). If $bForceCountersOn=True, might not be running as ADMIN
;			If Running as ADMIN, and $bForceCountersOn=True, then @extended=RegWrite() error
;		@error = 32 = Could not open PDH.DLL
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_Init($bForceCountersOn=False,$bRestoreRegStateOnExit=False)
	; Already initialized?
	If $_PDH_bInit Then Return True

	; Clear Reg Flags
	$_PDH_REG_MODIFIED=0
	$_PDH_RESTORE_REG=0
	; Check if Performance Counters are enabled in the Registry:
	If Not __PDH_RegistryToggle(-1) Then
;~ 		_PDH_DebugWriteErr("Performance Counters found to be disabled in registry..")
		If Not $bForceCountersOn Or Not IsAdmin() Then Return SetError(16,0,False)
		If Not __PDH_RegistryToggle(1) Then Return SetError(@error,@extended,False)
		$_PDH_REG_MODIFIED=1
		If $bRestoreRegStateOnExit Then $_PDH_RESTORE_REG=1
	EndIf

;~ 	Performance Counters are enabled... Now grab a handle to PDH.DLL

	; NOTE: It is ABSOLUTELY REQUIRED to Open this handle while using PDH counter collection data
	;	Otherwise, all handles retrieved by Queries become invalid!
	$_PDH_hDLLHandle=DllOpen("pdh.dll")
	; Error opening?
	If $_PDH_hDLLHandle=-1 Then
		; Reset Registry if modified
		If $_PDH_RESTORE_REG Then
;~ 			_PDH_DebugWrite("Resetting registry..")
			If Not __PDH_RegistryToggle(0) Then Return SetError(@error,@extended,False)
		EndIf
		Return SetError(32,0,False)
	EndIf

	; GET # of CPU's
	$_PDH_iCPUCount=_WinAPI_GetSystemInfo_ISN(6)
	If @error Then
		$_PDH_iCPUCount=EnvGet("NUMBER_OF_PROCESSORS")
		If $_PDH_iCPUCount="" Then
			$_PDH_iCPUCount=1
		Else
			$_PDH_iCPUCount=Int($_PDH_iCPUCount)
		EndIf
	EndIf
	_PDH_DebugWrite("CPU count result:" & $_PDH_iCPUCount)

	; Good to go - set 'initialized' flag to True
	$_PDH_bInit=True
	; And setup exit routine in case programmer forgets to call it/exits unexpectedly
	OnAutoItExitRegister("_PDH_UnInit")
	Return True
EndFunc


; ===============================================================================================================================
;  Func _PDH_UnInit($hPDHQueryHandle=-1)
;
; Simple call to 'uninitialize' all PDH data and disable it from being used (another 'Init' will be required otherwise)
;	Basically 1. Closes the given PDH Query Handle (if valid) and 2. Unloads and resets the PDH.DLL handle.
;	This is not *technically* required since AutoIT automatically closes any open DLL's, which also invalidates
;	the PDH Query Handle, but it's good practice to clean up like this.
;	Oh, and 3. Resets the relevant Registry values if they were changed (which is *not* done automatically by AutoIT)
;
; $hPDHQueryHandle = (optional) PDH Query Handle to close/free before closing DLL. -1 = none
;	Note that this is *NOT* set to 0 (invalidated) like a direct call to _PDH_FreeQueryHandle() would do
;
; Returns: None (assume success!)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_UnInit($hPDHQueryHandle=-1)
	If Not $_PDH_bInit Then Return True	; If not initialized, nothing to Uninitialize

	; Free Query Handle (if valid). We don't care if there was an error, since we will be closing DLL
	If @NumParams Then
	   if IsDeclared("hPDHQueryHandle") then
	   _PDH_FreeQueryHandle($hPDHQueryHandle)	; The check for @NumParams is important in an On-Exit function!
	   Endif
    endif

	DllClose($_PDH_hDLLHandle)	; Close the DLL

	; If requested, reset any Performance Counter registry keys that were modified. No error checking here
	If $_PDH_RESTORE_REG Then __PDH_RegistryToggle(0)

	; Reset variables
	$_PDH_hDLLHandle=-1
	$_PDH_bInit=False

	OnAutoItExitUnregister("_PDH_UnInit")	; Unregister self as an on-exit function
	Return
EndFunc


; ===============================================================================================================================
; Func _PDH_ValidatePath($sCounterPath)
;
; Function to check a Counter Path and return whether it is valid or not.
;
; $sCounterPath = Counter Path (of the format returned by _PDH_BrowseCounters(). Examples:
;	Format with network path: "\\<PCNAME>\Process(ProcessName)\% Processor Time")
;	Actual Value (on local PC): "\Process(Idle)\% Processor Time"
;
; Return:
;	Success: True (or False if invalid, with @error=0, @extended=PDH return code [as does $_PDH_iLastError)
;	Failure: False with @error set:
;		@error = 1 = invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 7 = non-localized string passed, but invalid format
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ValidatePath($sCounterPath)
	Local $aRet,$tErr,$hPDHDLL

	If Not IsString($sCounterPath) Then Return SetError(1,0,False)

	; Unlike other functions, getting a counter list doesn't require initialization,
	;	though it doesn't hurt (especially if Disable Performance Counters is set)
	If Not $_PDH_bInit Then
		$hPDHDLL="pdh.dll"
	Else
		$hPDHDLL=$_PDH_hDLLHandle
	EndIf

	; Non-localized string? Create localized string and add it.
	If StringLeft($sCounterPath,1)=':' Then
		$sCounterPath=__PDH_LocalizeCounter($sCounterPath)
		If @error Then Return SetError(@error,0,"")
		_PDH_DebugWrite("Localized counter (from non-localized string):"&$sCounterPath)
	EndIf

	$aRet=DllCall($_PDH_hDLLHandle,"long","PdhValidatePathW","wstr",$sCounterPath)

	; DLL call error?
	If @error Then
		; Only needed to allow _PDH_DebugWrite() msg (which resets @error)
		$tErr=@error
		_PDH_DebugWriteErr("Path '"&$sCounterPath&"' caused a DLL-Call error")
		Return SetError(2,$tErr,False)
	EndIf

	; PDH return code? Then *most* likely not a valid path (there are some rare exceptions but they aren't likely to occur)
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("Path '"&$sCounterPath&"', per PdhValidatePathW, is invalid (or has too many wildcards)! [Return code: "&Hex($_PDH_iLastError)&']')
		Return SetExtended($_PDH_iLastError, False)
	EndIf
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_ConnectMachine($sPCName)
;
; Connects to a given machine (PC).  Not necessary for any function really, because the PC Name can be part of the path.
;	However, _PDH_BrowseCounters() will not show other PC's in its drop-down list unless they are connected to
;	 first using this function.  (An alternative of course is just to manually enter the PC Name in the PC box)
;
; $sPCName =  PC/Machine name of the format: "\\PCNAME"
;
; Returns:
;	Success: True, @error=0
;	Failure: False, and @error set:
;		@error = 16 = not initialized, and _PDH_Init() call failed
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error (@extended contains error, also $_PDH_iLastError)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_ConnectMachine($sPCName)
	; Check that PDH handle has been initialized
	If Not $_PDH_bInit Then Return SetError(16,0,False)
	If Not IsString($sPCName) Or $sPCName="" Then Return SetError(1,0,False)
	Local $aRet=DllCall($_PDH_hDLLHandle,"long","PdhConnectMachineW","wstr",$sPCName)
	If @error Then Return SetError(2,@error,False)
	; PDH return code? Then PDH error (could be invalid PC name, or PC doesn't support remote registry connections/performancec monitoring)
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("Machine '"&$sPCName&"' was not able to be connected to. [Return code: "&Hex($_PDH_iLastError)&']')
		Return SetError(3,$_PDH_iLastError, False)
	EndIf
	Return True
EndFunc


; ====================================================================================================================================
; Func _PDH_BrowseCounters($sTitle="",$hWnd=0,$iDetailLvl=4,$bAllowRemotePCs=True,$bAllowMultipleSel=False,$bAllowCostlyObjects=False)
;
; Displays a Browse Counters Dialog Box, allowing user to select one or more counters to add to the query. (MSDN)
;	Returns a Counter Selection String, or "" if user cancelled out of Dialog (or error occurred)
;
; $sTitle = If not "", then the Title to display on top of the "Browse Performance Counters" box
; $hWnd = (optional) Parent Window
; $iDetailLvl = Initial Browser Display mode: 1 (NOVICE), 2 (ADVANCED), 3 (EXPERT), 4 (WIZARD)
; $bAllowRemotePCs = If True/non-zero, allows selection of other PC's. If False/0, only allows counter lookup on current PC
; $bAllowMultipleSel = If True, an array will be returned of selection(s). If False, only the first (topmost) selection is returned
;	NOTE: The ability to limit a selection to one item was broken with Vista+ O/S's (see info regarding flag 2 below), so
;	 we have to allow the user to select multiple items, but with this parameter set to False, we disregard the others
; $bAllowCostlyObjects = If True, resource-intensive counters will be displayed. Default is False.
;	NOTE that these objects may require heavy CPU/memory usage!
;
; Returns:
;	Success: If $bAllowMultipleSel=False, the topmost selected Counter string is returned (wildcard or not). (@error=0)
;		If $bAllowMultipleSel=True, an array is returned (@error=0):
;		[0] = # of Counters
;		[x] = Counter path(s)
;	Failure: "" Empty String, and @error set:
;		@error = -1 = Nothing returned, even though API call returned as though a selection had been made
;		@error = 0  = User cancelled out of Dialog Box
;		@error = 2  = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3  = PDH error code, with @extended set, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ====================================================================================================================================

Func _PDH_BrowseCounters($sTitle="",$hWnd=0,$iDetailLvl=4,$bAllowRemotePCs=True,$bAllowMultipleSel=False,$bAllowCostlyObjects=False)
	Local $hPDHDLL,$aRet,$iBCFlags,$hPDHBCCallback,$sReturnStr="",$aReturnArr[2]
	Local $stCounterSelectBuffer,$stBrowseDlgConfig,$stTitle

	; Unlike other functions, getting a counter list doesn't require initialization,
	;	though it doesn't hurt (especially if Disable Performance Counters is set)
	If Not $_PDH_bInit Then
		$hPDHDLL="pdh.dll"
	Else
		$hPDHDLL=$_PDH_hDLLHandle
	EndIf

;~ 	_PDH_DebugWrite("_PDH_BrowseCounters() call, PDH DLL 'handle' (or just 'pdh.dll'):" & $hPDHDLL)
#cs
	; ------------------------------------------------------------------------------------------------------------------
	; - Browse Counters Flags -
	;
	; 1 = Include Instance Index (#x and/or /x) for multiple instances that occur of a given object
	; 2 = Allow only a single counter selection/add (NOTE: Vista+: prevents wildcarding last part of path!)
	; 4 = Allow only a single counter selection per dialog, prevents 'Add' and 'Close' buttons from being displayed
	; 8 = Local counters only (local computer). Otherwise, this allows selection of network counters
	; 16 = Wildcard Instances (allows the user to select 'All Instances' which returns a wildcard string)
	; 32 = Hide Detail Box (not set = allows user to change the detail level of counters displayed)
	; 64 = Initialize Path - uses szReturnPath's value (not set here) to highlight an initial selection
	; 128 = Disable Machine Selection - If set, user cannot access remote machine counters
	; 256 = Include Costly Objects - If set, Counters that take a LOT of time/memory to process will be shown
	; 512 = If set, a. Only Performance Objects will be shown (Instances and Individual Counters are not shown)
	;		b. Return will include wildcard characters for instance name and counter IF the
	;		  object is a multi-instance object
	; MSDN (on +512):
	;  ..For example, if the "Process" object is selected, the dialog returns the string "\Process(*)\*".
	;  If the object is a single instance object, the path contains a wildcard character for counter only.
	;  For example, "\System\*". You can then pass the path to PdhExpandWildCardPath to retrieve a list
	;  of actual paths for the object.
	; ------------------------------------------------------------------------------------------------------------------
;
	; ------------------------------------------------------------------------------------------------------------------
	; Notes:
	; * Vista+ O/S: adding 2 (single counter selection/add) causes blank-string returns (with 'success' result)
	;	  for counters with wildcard at end of path
	; * not adding 16 (Wildcard Instances) causes crashes (wth!?) when wildcards are selected (at least on Win7..)
	; * not adding 4 (multi-counter selection toggle) causes failure on return, because a Callback function must
	;	  be in place which processes each string individually.  This can be done, but would be better if user could
	;	  see & interact with (including removing) chosen counters. Too much work IMO for this function.
	; * +64 (Initialize Path) - fails in practice, at least Vista+, so it's useless (would be nice if it worked though!)
	; * +256 (costly objects) - not recommended
	; ------------------------------------------------------------------------------------------------------------------
#ce
	$iBCFlags=1+4+16	; cross-O/S-safe values
	If Not $bAllowRemotePCs Then $iBCFlags+=8	; forces user to select counters from the local PC only
	If $bAllowCostlyObjects Then $iBCFlags+=256	; requires more resources (possibly CPU/memory) to monitor these!

	; Create the return buffer. PDH_MAX_COUNTER_PATH size is (2048). We create a buffer of 65536 (64K) to allow for multiple paths (default)
	$stCounterSelectBuffer=DllStructCreate("byte[131072]")	; 65536 wchars
#cs
	; Set an initial path? - Fails, at least on Vista+
	If $sDefCounter<>'' Then
;~ 		DllStructSetData($stCounterSelectBuffer,1,$sDefCounter)
		; For "byte[]" structure definitions, this would be needed:
		DllStructSetData($stCounterSelectBuffer,1,StringToBinary($sDefCounter,2))
		$iBCFlags+=64	; flag that an initial path is in the output buffer
	EndIf
#ce
	; Create the main PDH_BROWSE_DLG_CONFIG structure:
	;	iFlagMask,hWndOwner,szDataSource,szReturnPathBuffer,cchReturnPathLength,pCallBack,dwCallBackArg,CallBackStatus,szDialogBoxCaption
	$stBrowseDlgConfig=DllStructCreate("dword;hwnd;ptr;ptr;dword;ptr;dword_ptr;long;dword;ptr")
	; Set the data members appropriately (structure is zero-filled on creation, so no need to re-set the ones commented out)
	DllStructSetData($stBrowseDlgConfig,1,$iBCFlags) ; Flags
 	DllStructSetData($stBrowseDlgConfig,2,$hWnd)	; HWndOwner (NULL or parent GUI)
;~ 	Log files aren't currently supported, as I have no need for them, nor has anyone requested this functionality
;~ 	DllStructSetData($stBrowseDlgConfig,3,0)		; DataSource (NULL = don't use log file)
	DllStructSetData($stBrowseDlgConfig,4,DllStructGetPtr($stCounterSelectBuffer))	; (out) ReturnPathBuffer
	DllStructSetData($stBrowseDlgConfig,5,2048)		; cchReturnPathLen max
;~ 	DllStructSetData($stBrowseDlgConfig,6,0)	; Callback function (NULL is fine)
;~ 	DllStructSetData($stBrowseDlgConfig,7,0)	; callback parameter
;~ 	DllStructSetData($stBrowseDlgConfig,8,0)	; (out) Callback Status (PDH_STATUS=ERROR_SUCCESS(0))

;  -  Detail Levels  -  (these only affect *Initial* view, user can then change to another level)
	Switch $iDetailLvl
		Case 1
			$iDetailLvl=0x64	; NOVICE (PERF_DETAIL_NOVICE)
		Case 2
			$iDetailLvl=0xC8	; ADVANCED (PERF_DETAIL_ADVANCED)
		Case 3
			$iDetailLvl=0x012C	; EXPERT (PERF_DETAIL_EXPERT)
		Case Else				; aka 'Case 4' (default if invalid param)
			$iDetailLvl=0x0190	; WIZARD (PERF_DETAIL_WIZARD)
	EndSwitch

	DllStructSetData($stBrowseDlgConfig,9,$iDetailLvl)

	; User didn't specify a caption?  On most O/S's, setting DialogBoxCaption to NULL resulted in the following string by default,
	;	but with Win7 it doesn't appear to put anything but "s" (?!), so now it is forced to the old default string:
	If $sTitle='' Then $sTitle="Browse Performance Counters"

	$stTitle=DllStructCreate("wchar["&(StringLen($sTitle)+1)&']')
	DllStructSetData($stTitle,1,$sTitle)
	DllStructSetData($stBrowseDlgConfig,10,DllStructGetPtr($stTitle))	; Dialog Box caption

	; Make the call
	$aRet=DllCall($hPDHDLL,"long","PdhBrowseCountersW","ptr",DllStructGetPtr($stBrowseDlgConfig))
	If @error Then Return SetError(2,@error,'')

	If $aRet[0] Then
		; PDH_DIALOG_CANCELLED (0x800007D9)? - Then no selection was made
		If $aRet[0]=0x800007D9 Then
			_PDH_DebugWriteErr("_PDH_Browse_Counters Dialog Cancelled, returning empty string")
			Return ''
		EndIf
		; Otherwise unknown error
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("PdhBrowseCountersW non-zero error code:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,'')
	EndIf
	; Grab the selection string(s). User can select multiple strings due to inability to use flag 2 on Vista+ O/S's
	;  Steps: convert Binary to Unicode string, then get rid of double-Unicode-null's, and replace single ones with @LF
	$sReturnStr=StringReplace(StringReplace(BinaryToString(DllStructGetData($stCounterSelectBuffer,1),2),ChrW(0)&ChrW(0),''),ChrW(0),@LF)
	;  Strip last @LF (present if multiple items selected)
	If StringRight($sReturnStr,1)=@LF Then $sReturnStr=StringTrimRight($sReturnStr,1)
	; DEBUG
	_PDH_DebugWrite("Selected Counter(s) from _PDH_Browse_Counters:"&@CRLF&$sReturnStr)
	If $sReturnStr='' Then Return SetError(-1,0,'')		; Unknown problem if string is blank
	$aReturnArr=StringSplit($sReturnStr,@LF,1)
	; Return array or (first) Counter string?
	If $bAllowMultipleSel Then Return $aReturnArr
	Return $aReturnArr[1]
EndFunc


; ===============================================================================================================================
; Func _PDH_GetCounterList($sCounterWildcardPath,$bReturnAsString=False)
;
; Return an array of Counters, OR a string (based on 2nd param) of them, based on matches to the Wildcard path.
;	NOTE: If a PC Name was not part of the Wildcard path, the local PC Name may be prefixed to expanded strings
;
; $sCounterWildcardPath = The Wildcard path, obviously.
;		Example use: "\Process(*)\% Processor Time"
; $bReturnAsString = If True, the List will be returned as a string, If False (default), as an array
;	NOTE: The returned string will contain NULL terms - except for the last element of the string.
;		This makes it easy enough to do a StringSplit() of your own (using ChrW(0))
;
; Returns:
;	Success: Either a 1D array of Counter paths, with bottom element equaling total count. @error=0,
;		OR (if $bReturnAsString==True), a string of NULL-term separated Counter paths (last NULL is stripped though)
;	Failure: A 1-element array containing '0', with @error set:
;		@error = 1 = invalid parameter
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5 = 2nd DLL call successful, but data returned is invalid
;		@error = 7 = non-localized string passed, but invalid format
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_GetCounterList($sCounterWildcardPath,$bReturnAsString=False)
	Local $aRet,$stExpandedPathList
	Local $hPDHDLL,$iBufSize,$sCounterList,$aCounterList[1]=[0]

	If Not IsString($sCounterWildcardPath) Then Return SetError(1,0,$aCounterList)

	; Unlike other functions, getting a counter list doesn't require initialization,
	;	though it doesn't hurt (especially if Disable Performance Counters is set)
	If Not $_PDH_bInit Then
		$hPDHDLL="pdh.dll"
	Else
		$hPDHDLL=$_PDH_hDLLHandle
	EndIf

	_PDH_DebugWrite("_PDH_GetCounterList() call, $sCounterWildcardPath='" & $sCounterWildcardPath & _
		"', PDH DLL 'handle' (or just 'pdh.dll'):" & $hPDHDLL)

	; Non-localized string? Create localized string and add it.
	If StringLeft($sCounterWildcardPath,1)=':' Then
		$sCounterWildcardPath=__PDH_LocalizeCounter($sCounterWildcardPath)
		If @error Then Return SetError(@error,0,"")
		_PDH_DebugWrite("Localized *wildcard* counter (from non-localized string):"&$sCounterWildcardPath)
	EndIf

	; 1st call to PdhExpandWildCardPathW - get required buffer size
	$aRet=DllCall($hPDHDLL,"long","PdhExpandWildCardPathW","ptr",ChrW(0), _
		"wstr",$sCounterWildcardPath,"ptr",ChrW(0),"dword*",$iBufSize,"dword",0)
	If @error Then Return SetError(2,@error,$aCounterList)	; DLL Call error

	; Return should be PDH_MORE_DATA (0x800007D2)
	If $aRet[0]<>0x800007D2 Then
		$_PDH_iLastError=$aRet[0]
		; DEBUG
		_PDH_DebugWriteErr("PdhExpandWildCardPathW 1st call unsuccessful, return:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,$aCounterList)
	EndIf

	; Grab required buffer size
	$iBufSize=$aRet[4]

	; For Win2000 (no SP), from tests, the buffer size reported on 1st call is 1 less than what it is on 2nd call!
	If @OSVersion="WIN_2000" Then $iBufSize+=1

	; DEBUG
	;_PDH_DebugWrite("_PDH_GetCounterList: PdhExpandWildCardPathW initial call successful, BufSize required:" & $iBufSize)

	; Setup a buffer (bytes because pulling a multi-NULL-terminated Unicode string out is impossible with wchars)
	$stExpandedPathList=DllStructCreate("byte["&($iBufSize*2)&']')

	; 2nd call to PdhExpandWildCardPathW - fill buffer with expanded PDH Paths
	$aRet=DllCall($hPDHDLL,"long","PdhExpandWildCardPathW","ptr",ChrW(0), _
		"wstr",$sCounterWildcardPath,"ptr",DllStructGetPtr($stExpandedPathList),"dword*",$iBufSize,"dword",0)
	If @error Then Return SetError(2,@error,$aCounterList)	; DLL Call Error

	; PDH Error?
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		; DEBUG
		_PDH_DebugWriteErr("PdhExpandWildCardPathW 2nd call unsuccessful, return:" & Hex($_PDH_iLastError))
		; This shouldn't occur on 2nd call (but did originally with Win2000 due to issues with PDH.DLL)
		;	should be fixed now (*unless* perhaps theres a rare case where more counters were added between calls?)
		If $aRet[0]=0x800007D2 Then
			_PDH_DebugWriteErr("PdhExpandWildCardPathW 2nd call returned 'PDH_MORE_DATA'. 1st reported Bufsize:" & $iBufSize & _
				", 2nd call's Bufsize:" & $aRet[4])
		EndIf
		Return SetError(4,$_PDH_iLastError,$aCounterList)
	EndIf

	; GET UNICODE STRING
	$sCounterList=BinaryToString(DllStructGetData($stExpandedPathList,1),2)

	; DEBUG INFO
;~ 	_PDH_DebugWrite("_PDH_GetCounterList: PdhExpandWildCardPathW 2nd Call successful, 1st reported Bufsize (adjusted+1 on Win2K systems):" & $iBufSize & _
;~ 		", 2nd call's Bufsize (should match):" & $aRet[4])
		; &", String Size:"&StringLen($sCounterList))	; String Length *always* matches DLL struct's size

	; Are there *still* wildcards left in the pattern [at the end of path sections]? Then it will not work, not even with further expansion
	If StringRegExp($sCounterList,"\*(\)|\\|$)") Then
		; DEBUG
		_PDH_DebugWriteErr("There are still * wildcards left after a call to PdhExpandWildCardPathW!"&@CRLF& _
			"Original wildcard path:"&$sCounterWildcardPath)	;&", Results:"&@CRLF& _
			;StringReplace($sCounterList,ChrW(0),@CRLF))
		Return SetError(1,0,$aCounterList)
	EndIf

	Local $iStrip=0
	; Check last 2 characters of string. If they are NULL values, add them to be stripped
	;	(This saves us from having to ReDim the array later, which would otherwise always happen)
	If StringRight($sCounterList,1)=ChrW(0) Then $iStrip=1
	; For Win 2000 (non-service-pack) systems, and if they decide to put double NULL-terms later:
	If StringMid($sCounterList,$iBufSize-1,1)=ChrW(0) Then $iStrip+=1

	; Did user opt to be returned a string?
	If $bReturnAsString Then
		Return StringTrimRight($sCounterList,$iStrip)
	Else
		; SPLIT string by NULL-TERMS and put into ARRAY
		$aCounterList=StringSplit(StringTrimRight($sCounterList,$iStrip),ChrW(0),1)

		; Counter list successfully split into an array?
		If Not @error Then
			_PDH_DebugWrite("_PDH_GetCounterList() call success, returning a "&$aCounterList[0]&"-element array")
			Return $aCounterList
		Else
			; @error from StringSplit. Must be invalid data
			Dim $aCounterList[1]
			$aCounterList[0]=0
			; DEBUG
			_PDH_DebugWriteErr("PdhExpandWildCardPathW data invalid")
			Return SetError(5,0,$aCounterList)
		EndIf
	EndIf
EndFunc


; ===============================================================================================================================
; Func _PDH_GetNewQueryHandle($iUserInfo=0)
;
; Returns a new PDH Query Handle - necessary for adding Counters to
;		(which can then be used to get performance info)
;
; $iUserInfo = (pointer-sized) Identifier that is retrieved on _PDH_GetCounterInfo calls (dwQueryUserData)
;
; Success: Returns non-zero handle
; Failure: Returns 0 with @error set:
;	@error = 16 = not initialized, and _PDH_Init() call failed
;	@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;	@error = 3 = PDH error (@extended contains error, also $_PDH_iLastError)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_GetNewQueryHandle($iUserInfo=0)
	; 1st check that PDH handle has been initialized
	If Not $_PDH_bInit Then
		If Not _PDH_Init() Then Return SetError(@error,0,0)
	EndIf

	; PdhOpenQuery: Create a PDH Query Handle
	Local $aRet=DllCall($_PDH_hDLLHandle,"long","PdhOpenQueryW","ptr",0,"dword_ptr",$iUserInfo,"ptr*",Ptr(0))
	If @error Then Return SetError(2,@error,0)	; DLL Call Error
	; PDH error?
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("_PDH_GetNewQueryHandle call returned with PDH error:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,0)
	EndIf
	_PDH_DebugWrite("_PDH_GetNewQueryHandle Call succeeded, return:" &$aRet[0]& _
		",param1:"&$aRet[1]&",param2:"&$aRet[2]&",handle:" & $aRet[3])
	; Return handle
	Return $aRet[3]
EndFunc


; ===============================================================================================================================
; Func _PDH_FreeQueryHandle(ByRef $hPDHQueryHandle)
;
; Function to free/close/release a PDH Query Handle and linked Counter Handles. Also invalidates passed handle (sets to 0)
;
; $hPDHQueryHandle = PDH Query Handle
;
; Returns:
;	Success: True, with the passed Query handle invalidated (set to 0)
;	Failure: False, with @error set:
;		@error = 16 = not initialized
;		@error = 1 = Invalid handle (0 or -1)
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_FreeQueryHandle(ByRef $hPDHQueryHandle)
	; Invalid handle?
	If Not IsPtr($hPDHQueryHandle) Then Return SetError(1,0,False)
	; Check that PDH handle has been initialized
	If Not $_PDH_bInit Then Return SetError(16,0,False)

	; Close the Query Handle
	Local $aRet=DllCall($_PDH_hDLLHandle,"long","PdhCloseQuery","ptr",$hPDHQueryHandle)
	If @error Then Return SetError(2,@error,False)	; DLL Call error
	; PDH Error?
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("PdhCloseQuery DLL call unsuccessful for handle: "&Hex($hPDHQueryHandle)&", return:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,False)
	EndIf
;~ 	_PDH_DebugWrite("PdhCloseQuery DLL call successful")
	$hPDHQueryHandle=0
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_AddCounter($hPDHQueryHandle,$sCounterPath,$iUserInfo=0)
;
; Adds the given Counter to the PDH Query Handle, and returns the Counter Handle
;
; $hPDHQueryHandle = PDH Query Handle, obviously
; $sCounterPath = Counter Path (of the format returned by _PDH_BrowseCounters(). Examples:
;	Format with network path: "\\<PCNAME>\Process(ProcessName)\% Processor Time")
;	Actual Value (on local PC): "\Process(Idle)\% Processor Time"
;
;	NOTE: (No longer a warning): Wildcard use is now allowed and in some circumstances, encouraged
;		Using Wildcards in $sCounterPath will add ALL items matching the wildcard into ONE Counter handle)
;		Benefits of using wildcards: each update will grow or shrink the # of matching counter data,
;		automatically discarding dead Counters and adding new ones.
;		Also, counter names with #x or parentheses (when not paired like "(t)") no longer become an issue
;		and also there will be no #1, #2, etc appended to them.
;
; $iUserInfo = Optional User-defined (pointer-sized) value. This value becomes part of the counter information
;		and can be retrieved by accessing the dwUserData member of the PDH_COUNTER_INFO structure
;		returned from a 'PdhGetCounterInfo' call, (per MSDN).
;
; Returns:
;	Success: non-zero Counter Handle, @error=0
;	Failure: 0, @error set:
;		@error = 16 = not initialized
;		@error = 1 = Invalid handle (0 or -1)
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;		@error = 7 = non-localized string passed, but invalid format
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_AddCounter($hPDHQueryHandle,$sCounterPath,$iUserInfo=0)
	If Not $_PDH_bInit Then Return SetError(16,0,0)
	; Check if its a valid Query Handle
	If Not IsPtr($hPDHQueryHandle) Then Return SetError(1,0,0)
;~ 	_PDH_DebugWrite("_PDH_AddCounter called w/ Handle (" &$hPDHQueryHandle&") Adding: '" &$sCounterPath & "' w/ param to associate:" & $iParam)

	; Non-localized string? Create localized string and add it.
	If StringLeft($sCounterPath,1)=':' Then
		$sCounterPath=__PDH_LocalizeCounter($sCounterPath)
		If @error Then Return SetError(@error,0,"")
		_PDH_DebugWrite("Localized counter (from non-localized string):"&$sCounterPath)
	EndIf

	Local $aRet=DllCall($_PDH_hDLLHandle,"long","PdhAddCounterW","ptr",$hPDHQueryHandle, _
		"wstr",$sCounterPath,"dword_ptr",$iUserInfo,"ptr*",Ptr(0))
	If @error Then Return SetError(2,@error,0)	; DLL call error?

	; PDH error?
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("PdhAddCounterW error [path:'"&$sCounterPath&"'], return:" & Hex($_PDH_iLastError))
		; DEBUG CALL (optional) - Validate Path.
;~ 		$aRet=DllCall($_PDH_hDLLHandle,"long","PdhValidatePathW","wstr",$sCounterPath)
;~ 		If Not @error And IsArray($aRet) And Not $aRet[0] Then _PDH_DebugWrite("Path validated!")
		Return SetError(3,$_PDH_iLastError,0)
	EndIf
	_PDH_DebugWrite("PdhAddCounterW success for path '"&$sCounterPath&"', handle:"&$aRet[4])

	; Return Counter Handle
	Return $aRet[4]
EndFunc


; ===============================================================================================================================
; Func _PDH_AddCountersByArray($hPDHQueryHandle,Const ByRef $aCounterArray,$iStart=0,$iEnd=-1,$iBottomRows=0,$iExtraColumns=0)
;
; Function to add counters from a 1-Dimensional array to a PDH Query Handle, and return the results in a 2D array.
;	Ideally used after a call to _PDH_GetCounterList().
;
; $hPDHQueryHandle = PDH Query Handle, obviously
; $aCounterArray = an array of strings returned by _PDH_GetCounterList() or formatted in the same way so
;	that they will yield a handle from _PDH_AddCounter() [see notes on $sCounterPath]
; $iStart = 1st position in array to start at. For arrays with a bottom count element, like those
;	returned by _PDH_GetCounterList(), this should be 1 (but it can be anywhere, so long as the data there is valid)
; $iEnd = last position in array to stop at. -1 (default) means end-of-array.
; $iBottomRows = If non-zero, the # indicates the extra rows that will be created at the bottom of the array
;	If non-zero, element [0][0] will be set to # Counter Handles
;	NOTE that the # Counter Handles will *only* equal the array size if $iBottomRows == 1
; $iExtraColumns = If non-zero, the # indicates the extra columns that will be allocated for the array
;	(thus saving on any ReDim's outside of the functino)
;
; Returns:
;	Success: 2-Dimensional array, @error=0,@extended=# of failures (if any)
;		array[x][0] = path, array[x][1] = Counter Handle
;	Failure: 2-Dimensional array with 1 row, 2 columns, set to 0, and @error set:
;		@error = 16 = not initialized
;		@error = 1 = Invalid parameters
;		@error = 8 = COMPLETE failure for entire array (all calls failed) (@extended=total count)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_AddCountersByArray($hPDHQueryHandle, Const ByRef $aCounterArray,$iStart=0,$iEnd=-1,$iBottomRows=0,$iColumns=0)
	Local $iFailures=0,$iReturnIndex,$aCountersReturn[1][2]=[[0,0]]
	If Not $_PDH_bInit Then Return SetError(16,0,$aCountersReturn)
	; Check parameters. 1Dimensional Array?, $iBottomRows<0?
	If Not IsArray($aCounterArray) Or UBound($aCounterArray,0)>1 Or $iBottomRows<0 Or $iColumns<0 Then Return SetError(1,0,$aCountersReturn)
	; Check if its a valid Query Handle
	If Not IsPtr($hPDHQueryHandle) Then Return SetError(1,0,$aCountersReturn)

	If $iEnd=-1 Then $iEnd=UBound($aCounterArray)-1
	; Everything within bounds and in right order?
	If $iStart<0 Or $iStart>$iEnd Or $iEnd>UBound($aCounterArray)-1 Then Return SetError(1,0,$aCountersReturn)

	; Size the array (including # of bottom rows) & extra columns
	Dim $aCountersReturn[$iEnd-$iStart+1+$iBottomRows][2+$iColumns]
	; Set the count of Counter Handles at [0][0] if additional rows requested
	;	NOTE that this will equal the array size *ONLY* if $iBottomRows = 1 !!
	If $iBottomRows Then $aCountersReturn[0][0]=$iEnd-$iStart+1

	; Set the index to start adding data to Return array (0-based offset)
	$iReturnIndex=$iBottomRows
	; Iterate through array, Copying strings and Adding Counter Handles
	For $i=$iStart To $iEnd
		$aCountersReturn[$iReturnIndex][0]=$aCounterArray[$i]
		$aCountersReturn[$iReturnIndex][1]=_PDH_AddCounter($hPDHQueryHandle,$aCounterArray[$i])
		If @error Then $iFailures+=1
		$iReturnIndex+=1
	Next
	; COMPLETE failure on ALL 'AddCounter' calls?
	If $iFailures=($iEnd-$iStart+1) Then
		Dim $aCountersReturn[1][2]
		$aCountersReturn[0][0]=0
		Return SetError(8,$iFailures,$aCountersReturn)
	EndIf
	Return SetExtended($iFailures,$aCountersReturn)
EndFunc


; ===============================================================================================================================
; Func _PDH_AddCountersByMultiStr($hPDHQueryHandle,Const ByRef $sMultiStr,$sSepChar,$iBottomRows=0,$iColumns=0)
;
; An alternative way to add Counters to a PDH Query Handle. This function does a StringSplit() based on
;	the passed String, then passes this to _PDH_AddCountersByArray(), and returns that function's resultant 2D array.
;
; $hPDHQueryHandle = PDH Query Handle, obviously
; $sMultiStr = String with multiple Counter paths, split by $sSepChar
; $sSepChar = the character that separates the counter paths. This character must *NOT* be at the end of the string
;	(as this will cause an additional element in the StringSplit() array to be created)
;	ChrW(0) would be default, as this is what's returned by a call to _PDH_GetCounterList($sStr,TRUE)
; $iBottomRows = If non-zero, the # indicates the extra rows that will be created at the bottom of the resultant array
;	If non-zero, element [0][0] will be set to # Counter Handles
;	NOTE that the # Counter Handles will *only* equal the array size if $iBottomRows == 1
; $iExtraColumns = If non-zero, the # indicates the extra columns that will be allocated for the resultant array
;	(thus saving on any ReDim's outside of the functino)
;
; Returns:
;	Success: 2-Dimensional array, @error=0,@extended=# of failures (if any)
;		array[x][0] = path, array[x][1] = Counter Handle
;	Failure: 2-Dimensional array with 1 row, 2 columns, set to 0, and @error set:
;		@error = 16 = not initialized
;		@error = 1 = Invalid parameters
;		@error = 8 = COMPLETE failure for entire array (all calls failed) (@extended=total count)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_AddCountersByMultiStr($hPDHQueryHandle, Const ByRef $sMultiStr,$sSepChar,$iBottomRows=0,$iColumns=0)
	Local $aCounterList[1][2]=[[0,0]]

	; Check 1 parameter. Rest of checks are done by _PDH_AddCountersByArray()
	If Not IsString($sMultiStr) Then Return SetError(1,0,$aCounterList)

	; SPLIT string by $sSepChar and put into ARRAY
	$aCounterList=StringSplit($sMultiStr,$sSepChar,1)

	; Counter list successfully split into an array?
	If Not @error Then
		_PDH_DebugWrite("_PDH_AddCountersByMultiStr() StringSplit() success, returning a "&$aCounterList[0]&"-element array")
		Return _PDH_AddCountersByArray($hPDHQueryHandle,$aCounterList,1,-1,$iBottomRows,$iColumns)
	Else
		; @error from StringSplit. Must be invalid param
		Dim $aCounterList[1][2]
		$aCounterList[0][0]=0
		; DEBUG
		_PDH_DebugWriteErr("_PDH_AddCountersByMultiStr() StringSplit() resulted in no data (invalid param)")
		Return SetError(1,0,$aCounterList)
	EndIf
EndFunc


; ===============================================================================================================================
; Func _PDH_AddCountersByWildcardPath($hPDHQueryHandle,$sCounterWildcardPath,$iBottomRows=0,$iColumns=0)
;
; Gets a list of counters, adds them to the PDH Query Handle, and puts them in an array (which it returns)
;	(basically a wrapper function for a couple of calls)
;
; $hPDHQueryHandle = PDH Query Handle, obviously
; $sCounterWildcardPath = The Wildcard path, obviously.
;		Example use: "\Process(*)\% Processor Time"
; $iBottomRows = If non-zero, the # indicates the extra rows that will be created at the bottom of the array
;	If non-zero, element [0][0] will be set to # Counter Handles
;	NOTE that the # Counter Handles will *only* equal the array size if $iBottomRows == 1
; $iExtraColumns = If non-zero, the # indicates the extra columns that will be allocated for the array
;	(thus saving on any ReDim's outside of the functino)
;
; Returns:
;	Success: 2-Dimensional array, @error=0,@extended=# of failures (if any)
;		array[x][0] = path, array[x][1] = Counter Handle
;	Failure: 2-Dimensional array with 1 row, 2 columns, set to 0, and @error set:
;			NOTE: error codes 2-5 are specific to the call to _PDH_GetCounterList()
;		@error = 16 = not initialized
;		@error = 1 = Invalid parameters
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 5 = 2nd DLL call successful, but data returned is invalid
;			NOTE: error code 8 is specific to _PDH_AddCountersByArray()
;		@error = 8 = COMPLETE failure for entire array (all calls failed) (@extended=total count)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_AddCountersByWildcardPath($hPDHQueryHandle,$sCounterWildcardPath,$iBottomRows=0,$iColumns=0)
	If Not $_PDH_bInit Then Return SetError(16,0,False)
	; Check if its a valid Query Handle
	If Not IsPtr($hPDHQueryHandle) Then Return SetError(1,0,False)

	Local $aCountersReturn[1][2]=[[0,0]]

	_PDH_DebugWrite("_PDH_AddCountersByWildcardPath called")

	Local $aCounterList=_PDH_GetCounterList($sCounterWildcardPath)
	If @error Or $aCounterList[0]=0 Then
		Local $iErr=@error,$iExt=@extended	; (save due to DEBUG-Write call)
		; DEBUG
		_PDH_DebugWriteErr("_PDH_AddCountersByWildcardPath call to PDH_GetCounterList failed")
		Return SetError($iErr,$iExt,$aCountersReturn)
	EndIf
	_PDH_DebugWrite("_PDH_AddCountersByWildcardPath call to PDH_GetCounterList succeeded, now returning _PDH_AddCountersByArray")
	$aCountersReturn=_PDH_AddCountersByArray($hPDHQueryHandle,$aCounterList,1,-1,$iBottomRows,$iColumns)
	Return SetError(@error,@extended,$aCountersReturn)
EndFunc


; ===============================================================================================================================
; Func _PDH_RemoveCounter(ByRef $hPDHCounterHandle)
;
; Removes a Counter from its Query Handle, and invalidates it (sets it to 0).
;	Note that just the Counter Handle is necessary for the call. (Internally it knows to which Query Handle it belongs)
;
; $hPDHCounterHandle = Counter Handle, as returned by _PDH_AddCounter() or _PDH_AddCountersByArray()
;	NOTE: The handle will be invalidated (set to 0) if successfull
;
; Return:
;	Success: True, @error = 0, and Counter Handle invalidated (set to 0)
;	Failure: False, @error set:
;		@error = 16 = not initialized
;		@error = 1 = invalid handle
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_RemoveCounter(ByRef $hPDHCounterHandle)
	If Not $_PDH_bInit Then Return SetError(16,0,False)
	; Check if its a valid Counter Handle
	If Not IsPtr($hPDHCounterHandle) Then Return SetError(1,0,False)

;~ 	DEBUG
	_PDH_DebugWrite("_PDH_RemoveCounter called w/ Counter Handle (" &$hPDHCounterHandle&')')

	Local $aRet=DllCall($_PDH_hDLLHandle,"long","PdhRemoveCounter","ptr",$hPDHCounterHandle)
	If @error Then Return SetError(2,@error,False)	; DLL call error

	; PDH error?
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("PdhRemoveCounter error, return:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,False)
	EndIf
;~ 	DEBUG
	;_PDH_DebugWrite("_PDH_RemoveCounter call completed successfully")
	$hPDHCounterHandle=0	; invalidate the handle
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_CounterNameToNonLocalStr($sCounterPath,$bKeepPCName=False)
;
; Takes a Counter path string and creates a generic non-localized string from it (using the below format)
;	Format output: ':Object#\Counter#\' + optional '(Instance)' + optional '\PCNAME'
;		Examples: ':230\6\(Idle)\PCNAME' (based on English counter path '\\PCNAME\Process(Idle)\% Processor Time')
;			':238\6\(0)' (based on English counter path '\Processor(0)\% Processor Time')
;			':2\250\' (based on English counter path '\System\Threads'
;			':2\250\\PCNAME'  (same as above, but with PCNAME [2nd backslash mandatory, 3rd is only needed when PCNAME added])
;
; $sCounterPath = *FULL* Counter path (with or without PC NAME). Format on entry must be of the standard types:
;	"\\PCNAME\Object(Instance)\Counter', '\Object(Instance)\Counter', or '\Object\Counter'
;	NOTES: 'Instance' can be '*' for wildcard. It can also optionally have a #x appended or /x prefixed (for extra instances)
;	  'Object' and 'Counter' can also be a wildcard, though I don't believe 'Object(Instance)' can both be wildcards.
; $bKeepPCName = If True, the PC Name will remain a part of the 'non-localized' string.  Not recommended for portability reasons.
;
; Returns:
;	Success: 'Non-localized' string (see above for format)
;	Failure: "" with @error set:
;		@error = 1 = invalid path
;		@error = 2 = DLL call error, @extended = DLLCall error code (see AutoIT help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_CounterNameToNonLocalStr($sCounterPath,$bKeepPCName=False)
	Local $aCounterElements,$sNeutralStr
	; Original PCRE for below [with look-ahead] (but now proper path format is enforced, so the starting \ is required)
	;	"(\\\\[^\\]+(?=\\))?\\?([^\\\(]+)?\(?([^\)]+)?\)?\\(.*)",1)

	; Break counter path down to 4 elements: Machine name (optional), Object Name, Instance Name (optional), Counter Name
	$aCounterElements=StringRegExp($sCounterPath,"(\\\\[^\\]+)?\\([^\\\(]+)?(\([^\)]+\))?\\(.*)",1)
	; Not formatted properly?
	If @error Then Return SetError(1,0,"")
#cs
	; [0] = Machine Name (or "" if not present)
	; [1] = Object Name (MUST be present for real string)
	; [2] = Instance Name (or "" if not present) - inside Object Name portion of path (if present)
	; [3] = Counter Name (MUST be present)
#ce
	$aCounterElements[1]=_PDH_GetCounterIndex($aCounterElements[1],$aCounterElements[0])
	If @error Then Return SetError(@error,@extended,"")
	$aCounterElements[3]=_PDH_GetCounterIndex($aCounterElements[3],$aCounterElements[0])
	If @error Then Return SetError(@error,@extended,"")

	$sNeutralStr=':'&$aCounterElements[1]&'\'&$aCounterElements[3]&'\'&$aCounterElements[2]
	; Strip one '\' off of the PC name before adding it
	If $bKeepPCName And $aCounterElements[0]<>"" Then $sNeutralStr&=StringTrimLeft($aCounterElements[0],1)
	Return $sNeutralStr
EndFunc


; ===============================================================================================================================
; Func _PDH_GetCounterNameByIndex($iIndex,$sPCName="")
;
; Function to get the name of a Counter or Object based on its index #
;  Ideal for use in place of hardcoded paths when using a different language.
;	Note that both the Object AND Counter index need to be queried separately, and then assembled together.
;
; $iIndex = index of the Counter. (hopefully these remain consistent throughout O/S versions!)
; $sPCName = *optional* parameter. If included, the machine name is extracted from the passed
;	string (which can be a full Counter path).  Machine name is of the format: "\\PCNAME"
;
; Return:
;	Success: Counter name, @error = 0
;	Failure: "", @error set:
;		@error = 2 = DLL call error, @extended = DLLCall error code (see AutoIT help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_GetCounterNameByIndex($iIndex,$sPCName="")
	Local $hPDHDLL,$aRet,$sMachineParamType,$vMachineParam

	; Unlike other functions, getting a counter index doesn't require initialization,
	;	though it doesn't hurt (especially if Disable Performance Counters is set)
	If Not $_PDH_bInit Then
		$hPDHDLL="pdh.dll"
	Else
		$hPDHDLL=$_PDH_hDLLHandle
	EndIf
	_PDH_DebugWrite("_PDH_GetCounterNameByIndex() call, Index:"&$iIndex&" [optional] Machine Name:"&$sPCName&", PDH DLL 'handle' (or just 'pdh.dll'):" &$hPDHDLL)

	; Extract Machine Name (optional). All other parts of path (if included) are cleared
	$vMachineParam=StringRegExpReplace($sPCName,"(\\\\[^\\]+)?(\\?.*)","$1")

	If $vMachineParam="" Then
		$vMachineParam=0
		$sMachineParamType="ptr"
	Else
		_PDH_DebugWrite("_PDH_GetCounterNameByIndex Machine name: "&$vMachineParam)
		$sMachineParamType="wstr"
	EndIf

	$aRet=DllCall($hPDHDLL,"long","PdhLookupPerfNameByIndexW",$sMachineParamType,$vMachineParam,"dword",$iIndex,"wstr","","dword*",65536)
	If @error Then Return SetError(2,@error,"")

	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("_PDH_GetCounterNameByIndex non-zero error code:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,"")
	EndIf
;~ 	_PDH_DebugWrite("_PDHGetCounterIndex results: Index:"&$aRet[3])
	Return $aRet[3]
EndFunc


; ===============================================================================================================================
; Func _PDH_GetCounterIndex($sCounterOrObject,$sPCName="")
;
; Function to get the index # of a Counter or an Object.
;  Ideal for hardcoded paths that need to be translated to another language.
;	!!! Note that the Counter or Object name here must *NOT* be prefixed with a '\'!!!
;
;	Also note that Counters like '% Processor Time' will give only one numerical value, but can be used
;	 with multiple Objects (Processor, Process).  This is why this function is better off used indirectly
;	 via _PDH_CounterNameToNonLocalStr() to convert each object for you.
;
; $sCounterOrObject = Counter or Object name (*without* '\'. Examples: 'Process', '% Processor Time')
; $sPCName = *optional* value -> the machine name, prefixed as normal with '\\' (Example: '\\PCNAME')
;
; Return:
;	Success: Counter #, @error = 0
;	Failure: -1, @error set:
;		@error = 1 = Counter Path invalid
;		@error = 2 = DLL call error, @extended = DLLCall error code (see AutoIT help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_GetCounterIndex($sCounterOrObject,$sPCName="")
	Local $hPDHDLL,$aRet,$sMachineParamType

	; Unlike other functions, getting a counter index doesn't require initialization,
	;	though it doesn't hurt (especially if Disable Performance Counters is set)
	If Not $_PDH_bInit Then
		$hPDHDLL="pdh.dll"
	Else
		$hPDHDLL=$_PDH_hDLLHandle
	EndIf
	_PDH_DebugWrite("_PDHGetCounterIndex() call, Counter or Object Name:'"&$sCounterOrObject&"', Machine Name (optional):'"&$sPCName&"', PDH DLL 'handle' (or just 'pdh.dll'):" &$hPDHDLL)

	If $sPCName="" Then
		$sPCName=0
		$sMachineParamType="ptr"
	Else
		$sMachineParamType="wstr"
	EndIf

	$aRet=DllCall($hPDHDLL,"long","PdhLookupPerfIndexByNameW",$sMachineParamType,$sPCName,"wstr",$sCounterOrObject,"dword*",0)
	If @error Then Return SetError(2,@error,-1)

	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("_PDHGetCounterIndex non-zero error code:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,-1)
	EndIf
	_PDH_DebugWrite("_PDHGetCounterIndex results: Index:"&$aRet[3])
	Return $aRet[3]
EndFunc


; ===============================================================================================================================
; Func _PDH_GetCounterInfo($hPDHCounterHandle)
;
; Retrieves a string of information about the PDH Counter passed (by Handle)
;
; $hPDHCounterHandle = Counter Handle, as returned by _PDH_AddCounter() or _PDH_AddCountersByArray()
;
; Returns:
;	Success: Array of information:
;		[0]  = Counter Type
;		[1]  = Counter Status
;		[2]  = Scale Factor
;		[3]  = Default Scale
;		[4]  = Counter User Data (passed when _PDH_AddCounter*() called)
;		[5]  = Query User (passed when _PDH_GetNewQueryHandle() called)
;		[6]  = Full Counter Path
;		[7]  = Machine Name (if available)
;		[8]  = Object Name
;		[9]  = Instance Name (if available)
;		[10] = Parent Instance Name (if available)
;		[11] = Instance Index (0 means no index)
;		[12] = Counter Name
;		[13] = Counter Explanation Text
;	Failure: "", @error set:
;		@error = 16 = not initialized
;		@error = 1 = invalid PDH Counter Handle
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_GetCounterInfo($hPDHCounterHandle)
	If Not $_PDH_bInit Then Return SetError(16,0,"")
	If Not IsPtr($hPDHCounterHandle) Then Return SetError(1,0,"")

	Local $aRet,$iBufSize
	Local $stCounterBuffer,$stCounterInfo

	; Initial call to get size
	$aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetCounterInfoW","ptr",$hPDHCounterHandle,"bool",True,"dword*",0,"ptr",0)
	If @error Then Return SetError(2,@error,"")	; DLL Call error

	; Return should be PDH_MORE_DATA (0x800007D2) unless on Windows 2000 which returns 0 but sets $aRet[3] with a size
	If $aRet[0]<>0x800007D2 Or ($aRet[0]=0 And $aRet[3]=0) Then
		$_PDH_iLastError=$aRet[0]
;~ 		DEBUG
		_PDH_DebugWriteErr("PdhGetCounterInfoW 1st call unsuccessful, return:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,"")
	EndIf

	; Grab required buffer size (in bytes)
	$iBufSize=$aRet[3]
;~ 	DEBUG
	;_PDH_DebugWrite("PdhGetCounterInfoW 1st call successful, Required Buffer Size:" & $iBufSize)

	; Setup buffer (size is in bytes)
	$stCounterBuffer=DllStructCreate("byte["&$iBufSize&"]")

	; 2nd call to get data
	$aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetCounterInfoW","ptr",$hPDHCounterHandle,"bool",True,"dword*", _
		$iBufSize,"ptr",DllStructGetPtr($stCounterBuffer))
	If @error Then Return SetError(2,@error,"")	; DLL Call error

	; PDH Error?
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
;~ 		DEBUG
		_PDH_DebugWriteErr("PdhGetCounterInfoW 2nd call unsuccessful, return:" & Hex($_PDH_iLastError))
		Return SetError(4,$_PDH_iLastError,"")
	EndIf

;~ 	DEBUG
	_PDH_DebugWrite("PdhGetCounterInfoW 2nd call successful, 1st Reported BufSize:" & $iBufSize & _
		", Return Size (should match)" & $aRet[3])

#cs
	; ----------------------------------------------------------------------------------------------------------
	; PDH_COUNTER_INFO structure. First portion is straightforward, until alignment at end of union (on x86)
	;  Size, Counter Type, Version (not used [but set]), Counter Status, Scale Factor, Default Scale Factor,
	;	Counter User Data, Query User Data, Counter Full Path (ptr), Data Item Path (ptr), Counter Path (ptr),
	;	Machine Name (ptr), Object Name (ptr), Instance Name (ptr), Parent Instance (ptr), Instance Index #,
	;	Counter Name (ptr), Explanation Text (ptr)
	; ----------------------------------------------------------------------------------------------------------
#ce
	Local $tagPDH_COUNTER_INFO="dword;dword;dword;long;long;long;dword_ptr;dword_ptr;ptr;ptr;ptr;ptr;ptr;dword;ptr"

	; For 32-bit mode, PDH_COUNTER_PATH_ELEMENTS is the largest part of union at 28 bytes, requiring a 'Filler' member
	;	but in x64 mode, its PDH_DATA_ITEM_PATH_ELEMENTS (or inline struct [same elements]) at 48 bytes, so the union Filler is not needed
	If Not @AutoItX64 Then $tagPDH_COUNTER_INFO&=";dword Filler"
	;	Final piece of structure before Data Buffer/String Data
	$tagPDH_COUNTER_INFO&=";ptr ExplainText"
;~ 	_PDH_DebugWrite("PDH_COUNTER_INFO Structure size without appended data:"&DllStructGetSize(DllStructCreate($tagPDH_COUNTER_INFO)))

	; Skip the buffer part (we have pointers inside the structure to null-term strings in $stCounterBuffer that we'll use instead)
	$stCounterInfo=DllStructCreate($tagPDH_COUNTER_INFO,DllStructGetPtr($stCounterBuffer))

	; Create and fill the Return structure (order is listed in header)
	Dim $aCounterInfo[14]
	$aCounterInfo[0]=DllStructGetData($stCounterInfo,2)
	For $i=1 To 5
		$aCounterInfo[$i]=DllStructGetData($stCounterInfo,$i+3)
	Next
	; Grab null-terminated strings using pointers
	For $i=6 To 10
		$aCounterInfo[$i]=__PDH_StringGetNullTermMemStr(DllStructGetData($stCounterInfo,$i+3))
	Next
	$aCounterInfo[11]=DllStructGetData($stCounterInfo,14)
	$aCounterInfo[12]=__PDH_StringGetNullTermMemStr(DllStructGetData($stCounterInfo,15))
	$aCounterInfo[13]=__PDH_StringGetNullTermMemStr(DllStructGetData($stCounterInfo,"ExplainText"))

	Return $aCounterInfo
EndFunc


; ===============================================================================================================================
; Func _PDH_CollectQueryData($hPDHQueryHandle,$bSkipChecks=False)
;
; Updates the Counters attached to a Query Handle - doesn't actually collect the values.
;	Collecting values is done via _PDH_UpdateCounter() or _PDH_UpdateWildcardCounter()
;	(using API call PdhGetFormattedCounterValue or PdhGetFormattedCounterArrayW)
;
; $hPDHQueryHandle = The handle for the Query which has Counter Handle(s) attached to it
; $bSkipChecks = **NOTE: FOR INTERNAL USE - DO NOT CHANGE FOR EXTERNAL CALLS!**
;		This skips parameter checks. It's original intention was for internal-use only,
;		so it was typically always 'True', but since it can be useful outside of other _PDH_ functions,
;		the option was added and set to False to allow regular Param/Init checks & extra error info)
;
; Return:
;	Success: True, @error = 0
;	Failure: False, @error set:
;		@error = 16 = not initialized
;		@error = 1 = invalid PDH Query Handle or PDH Counter Handle
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error. @extended contains error, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_CollectQueryData($hPDHQueryHandle,$bSkipChecks=False)
	If Not $bSkipChecks Then
		; Properly initialized?
		If Not $_PDH_bInit Then Return SetError(16,0,False)
		; Check if Query Handle is valid
		If Not IsPtr($hPDHQueryHandle) Then Return SetError(1,0,False)
	EndIf
	Local $aRet=DllCall($_PDH_hDLLHandle,"long","PdhCollectQueryData","ptr",$hPDHQueryHandle)
	If @error Then Return SetError(2,@error,False)	; DLL Call error
	; PDH error?
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		_PDH_DebugWriteErr("PdhCollectQueryData error, return:" & Hex($_PDH_iLastError))
		Return SetError(3,$_PDH_iLastError,False)
	EndIf
	Return True
EndFunc


; ===============================================================================================================================
; Func _PDH_UpdateCounter($hPDHQueryHandle,$hPDHCounterHandle,$sCounterPath="",$bGrabValueOnly=False)
;
; Function to update (all) counters under the given Query Handle, but only return 1 Counter's Value.
;	NOTE: Do not call this multiple times in a row - call _PDH_CollectQueryData() 1st, then call this
;	  with the last paramter set to True.
;
; $hPDHQueryHandle = The handle for the Query which has Counter Handle(s) attached to it
; $hPDHCounterHandle = Counter Handle, as returned by _PDH_AddCounter() or _PDH_AddCountersByArray()
; $sCounterPath = The counter path. If passed as a parameter, it will allow the function to
;	perform division on CPU Usage counters, and write debug info with _PDH_DebugWrite. While not necessary,
;	its good to set this up for automatic CPU usage division. OPTIONALLY,
;	*WHEN* it is known beforehand that CPU usage is being looked for, then this can be set to -2
;	which indicates to this function to do the CPU division regardless
; $bGrabValueOnly = When a PDHQueryHandle has been updated already, and only individual Counter Handle
;	values need to be extracted - use this to avoid additional calls to PdhCollectQueryData
;	(avoids sticky issues with multiple Counters under one Query handle, & also speeds things up by avoiding extra calls)
;
; Returns:
;	Success: Counter value, @error = 0
;	Failure: -1, @error set:
;		@error = 16 = not initialized
;		@error = 1 = invalid PDH Query Handle or PDH Counter Handle
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = -1 = PDH error 'PDH_INVALID_DATA' (0xC0000BC6) Returned
;			IMPORTANT: It is recommended to call _PDH_RemoveCounter() when @error = -1 !!
;				(It generally means Counter is no longer valid)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_UpdateCounter($hPDHQueryHandle,$hPDHCounterHandle,$sCounterPath="",$bGrabValueOnly=False)
	; Properly initialized?
	If Not $_PDH_bInit Then Return SetError(16,0,-1)
	; Check if Counter Handle is valid
	If Not IsPtr($hPDHCounterHandle) Then Return SetError(1,0,-1)

	; Called with request to just grab the counter value only?
	If Not $bGrabValueOnly Then
		; Check if Query Handle is valid
		If Not IsPtr($hPDHQueryHandle) Then Return SetError(1,0,-1)
		; Call CollectQueryData - 'True' means no checks necessary
		If Not _PDH_CollectQueryData($hPDHQueryHandle,True) Then Return SetError(@error,@extended,-1)
	EndIf

	Local $stCounterValue=DllStructCreate("long;int64")	; PDH_FMT_COUNTERVALUE  (can also change to long;double)
#cs
	;-----------------------------------------------------
	;  -  Format Options  -
	;	PDH_FMT_LONG	0x00000100 (long-32bit)
	;	PDH_FMT_DOUBLE	0x00000200 (double float)
	;	PDH_FMT_LARGE	0x00000400 <- my choice (int64)
	; 	( + )
	;	PDH_FMT_NOSCALE		0x00001000
	;	PDH_FMT_NOCAP100	0x00008000 <- also my choice (requires division for CPU usage results tho)
	;	PDH_FMT_1000		0x00002000
	;-----------------------------------------------------
#ce
	Local $aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetFormattedCounterValue","ptr",$hPDHCounterHandle,"dword",0x8400, _
		"dword*",0,"ptr",DllStructGetPtr($stCounterValue))
	If @error Then Return SetError(2,@error,-1)

	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		; PDH_INVALID_DATA? (0xC0000BC6). If CStatus also is PDH_CSTATUS_NO_INSTANCE (0x800007D1), counter no longer exists
		If $aRet[0]=0xC0000BC6 And DllStructGetData($stCounterValue,1)=0x800007D1 Then
			_PDH_DebugWriteErr("Invalid Data (invalid handle) message for Handle:" & $hPDHCounterHandle & _
				", Path [if passed]:" &$sCounterPath)
			Return SetError(-1,$_PDH_iLastError,-1)
		EndIf
		_PDH_DebugWriteErr("Error Calling PdhGetFormattedCounterValue for Handle:"&$hPDHCounterHandle& _
			", Path [if passed]:" &$sCounterPath&", Return:" & Hex($_PDH_iLastError))

		Return SetError(4,$_PDH_iLastError,-1)
	EndIf
	; Test for % Processor Usage (#6) Counters and adjust accordingly (Thread (#232) or Process (#230) only)
	If $sCounterPath=-2 Or ($sCounterPath<>"" And StringRegExp($sCounterPath,"(:23(0|2)\\6|(Thread|Process)\([^%]+%)",0)) Then _
		Return Round(DllStructGetData($stCounterValue,2) / $_PDH_iCPUCount)

	Return DllStructGetData($stCounterValue,2)
EndFunc


; ===============================================================================================================================
; Func _PDH_UpdateWildcardCounter($hPDHQueryHandle,$hPDHCounterHandle,$sCounterWildcardPath="",$bGrabValueOnly=False))
;
; Accesses an array of Counter values when a Counter Handle was retrieved through a wildcard value,
;	returns an array of Counter names & values.
;
; $hPDHQueryHandle = The handle for the Query which has Counter Handle(s) attached to it
; $hPDHCounterHandle = Counter Handle, as returned by _PDH_AddCounter()
;	NOTE: !!! MUST BE A WILDCARD COUNTER !!! (a counter initialized with a * in any one of its path's positions)
; $sCounterWildcardPath = The wildcard path used for this counter. This isn't necessary, but if not present,
;	will not do the necessary division when a CPU usage Counter is involved - however:
;	*WHEN* it is known beforehand that CPU usage is being looked for, then this can be set to -2
;	which indicates to this function to do the CPU division regardless
;	*ALSO*, for bytes-to-KBytes division (or KBytes-to-MBytes), -3 can be passed
;		AND -4 for bytes-to-MBytes
; $bGrabValueOnly = When a PDHQueryHandle has been updated already, and only individual Counter
;	Handle values need to be extracted - use this to avoid additional calls to PdhCollectQueryData
;	(can help in cases where the data may change between calls, and also speeds things up by avoiding extra calls)
;
; Returns:
;	Success: Array of Counter values with the following format (@error = 0):
;		[0][0]  = count of items
;		[$i][0] = Counter Name
;		[$i][1] = Counter Value
;	Failure: [0][0]=0, @error set:
;		@error = 16 = not initialized
;		@error = 1 = invalid PDH Query Handle or PDH Counter Handle
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = 1st DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;		@error = 4 = 2nd DLL call PDH error. @extended contains error, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_UpdateWildcardCounter($hPDHQueryHandle,$hPDHCounterHandle,$sCounterWildcardPath="",$bGrabValueOnly=False)
	Local $aValueArray[1][2]=[[0,0]]
	; Properly initialized?
	If Not $_PDH_bInit Then Return SetError(16,0,$aValueArray)
	; Check if Counter Handle is valid
	If Not IsPtr($hPDHCounterHandle) Then Return SetError(1,0,$aValueArray)
	; Called with request to just grab the counter value only?
	If Not $bGrabValueOnly Then
		; Check if Query Handle is valid
		If Not IsPtr($hPDHQueryHandle) Then Return SetError(1,0,$aValueArray)
		; Call CollectQueryData - 'True' means no checks necessary
		If Not _PDH_CollectQueryData($hPDHQueryHandle,True) Then Return SetError(@error,@extended,$aValueArray)
;~ 		_PDH_DebugWrite("CollectQueryData succeeded")
	EndIf

	Local $aRet,$stCounterBuffer,$stCountValueItem,$iCountValueSz,$pPointer,$iDivisor=0

	; 1st call - get required buffer size
	$aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetFormattedCounterArrayW","ptr",$hPDHCounterHandle, _
		"dword",0x8400,"dword*",0,"dword*",0,"ptr",0)
	If @error Then Return SetError(2,@error,$aValueArray)

	; Return should be PDH_MORE_DATA (0x800007D2), but on Win2000 'ERROR_SUCCESS' is returned - so check if there's a return size
	If $aRet[0]<>0x800007D2 And Not ($aRet[0]=0 And $aRet[3] And @OSVersion="WIN_2000") Then
		$_PDH_iLastError=$aRet[0]
		; DEBUG
		_PDH_DebugWriteErr("PdhGetFormattedCounterArrayW 1st call unsuccessful, return:" & Hex($_PDH_iLastError)&", sz:"&$aRet[3])
		Return SetError(3,$_PDH_iLastError,$aValueArray)
	EndIf

	; DEBUG:
	_PDH_DebugWrite("Required buffer size after 1st PdhGetFormattedCounterArrayW call:"&$aRet[3]&" bytes, #counters:"&$aRet[4])

	; Set structure size according to results of 1st call
	$stCounterBuffer=DllStructCreate("byte["&$aRet[3]&']')

	; 2nd call - get actual data
	$aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetFormattedCounterArrayW","ptr",$hPDHCounterHandle, _
		"dword",0x8400,"dword*",$aRet[3],"dword*",0,"ptr",DllStructGetPtr($stCounterBuffer))
	If @error Then Return SetError(2,@error,$aValueArray)

	; PDH Error? (typically PDH_CSTATUS_INVALID_DATA (0xC0000BBA) is returned for new\updated CPU Usage Counters)
	If $aRet[0] Then
		$_PDH_iLastError=$aRet[0]
		; DEBUG:
		_PDH_DebugWriteErr("PdhGetFormattedCounterArrayW 2nd call unsuccessful, return:"&Hex($_PDH_iLastError)&", sz:"&$aRet[3]&", #counters:"&$aRet[4])
		Return SetError(4,$_PDH_iLastError,$aValueArray)
	EndIf
	;_PDH_DebugWrite("PdhGetFormattedCounterArrayW 2nd call successfull, return size:"&$aRet[3]&" bytes, #counters:"&$aRet[4])

	; Size array accordingly. 2 columns: 1 for Instance name, 1 for value [skipping 'status' because it isnt used here]
	Dim $aValueArray[$aRet[4]+1][2]=[[$aRet[4],0]]

;	Determine if we need to do division on the results (better to just pass a number to divide by?)
	If $sCounterWildcardPath=-2 Or ($sCounterWildcardPath<>"" And StringRegExp($sCounterWildcardPath,"(:23(0|2)\\6|(Thread|Process)\([^%]+%)",0)) Then
		$iDivisor=$_PDH_iCPUCount	; CPU Count (for % Processor Usage (#6) Counters [Thread (#232) or Process (#230) only])
	ElseIf $sCounterWildcardPath=-3 Then
		$iDivisor=1024		; Bytes-To-KBytes, or KBytes-to-MBytes
	ElseIf $sCounterWildcardPath=-4 Then
		$iDivisor=1048576	; Bytes-To-MBytes	[1024*1024 = 1048576]  or KByte to GBytes
	EndIf

	; According to MSDN sources, the PDH_FMT_COUNTERVALUE_ITEM structure really should be ptr;dword;int64 (as max sized part of union)
	;	However, the embedded PDH_FMT_COUNTERVALUE structure on its own *would* need padding to offset the in64 value, so alone
	;	it would need that padding.  In x64 mode, the same situation results
	$iCountValueSz=DllStructGetSize(DllStructCreate("ptr;long;dword;int64"))	; get PDH_FMT_COUNTERVALUE_ITEM structure size

	; Pointer used in pulling\assigning each new structure in the buffer
	$pPointer=DllStructGetPtr($stCounterBuffer,1)

	; Move through the buffer filled with PDH_FMT_COUNTERVALUE_ITEM structures
	For $i=1 To $aRet[4]
		$stCountValueItem=DllStructCreate("ptr;long;dword;int64",$pPointer)	; PDH_FMT_COUNTERVALUE_ITEM (see above)

		; Assign Name from pointer
		$aValueArray[$i][0]=__PDH_StringGetNullTermMemStr(DllStructGetData($stCountValueItem,1))

		; Ignoring 2nd *undocumented* member of struct - no idea what it is for

		; Assign Counter Value
		$aValueArray[$i][1]=DllStructGetData($stCountValueItem,4)

;~ 		; Assign Status [optional]	-> through testing, always 0 *unless* 0xC0000BBA PDH error returned above,
;~ 		;	in which case the counters would all be Status code: 0xC0000BBA. (which won't happen since we return on error)
;~ 		$aValueArray[$i][2]=DllStructGetData($stCountValueItem,3)

;~ 		; DEBUG:
;~ 		If DllStructGetData($stCountValueItem,3) Then _
;~ 			_PDH_DebugWrite("Non-zero status found for Counter '"&$aValueArray[$i][0]&"':"&Hex(DllStructGetData($stCountValueItem,3)))

		If $iDivisor Then $aValueArray[$i][1]=Round($aValueArray[$i][1]/$iDivisor)	; divide if required

		; DEBUG:
;~ 		_PDH_DebugWrite("Name of item#"&$i&":" & $aValueArray[$i][0]&", Status:"&Hex(DllStructGetData($stCountValueItem,3))& _
;~ 		",Value:"&$aValueArray[$i][1]&", Sizeof stucture:" & DllStructGetSize($stCountValueItem)& _
;~ 			", Extra bits:"&DllStructGetData($stCountValueItem,2))	; (extra seems to always = 0...)

		$pPointer+=$iCountValueSz	; Move pointer to next counter value (PDH_FMT_COUNTERVALUE)
	Next

	; Return value array
	Return $aValueArray
EndFunc


; ===============================================================================================================================
; Func _PDH_UpdateCounters($hPDHQueryHandle,ByRef $aPDHCountersArray,$iHandleIndex,$iCountIndex,$iStrIndex=-1,$iDeltaIndex=-1, _
;	$iStart=1,$iEnd=-1,$bFirstCall=False)
;
; Updates Counter Values and delta changes for an array of PDH Counters.
;	It also adjusts processor usage % to account for # of processors. Should match Task Manager values now
;
; $hPDHQueryHandle = The handle for the Query which has all the Counter Handles attached to it
; $aPDHCountersArray = Array of Counters, Counter Handles, Counter Values, & Delta change data
;		This is passed by REFERENCE so that this function can directly alter the values
; $iHandleIndex = column index of Counter Handles in array [This is set to 0 and Removed when a Counter becomes invalid!]
; $iCountIndex = column index of where Counter value data is stored
; $iStrIndex = IF >0, the column index of where the string is (which may be adjusted as below)
;	*** SPECIAL OPTIONS *** If passed a negative number instead, this function will do:
;	For: -2 value, the Counter will be treated as a CPU usage related counter & adjusted accordingly
;	For: -3 value, the Counter will be divided by 1024 (for Byte-to-KByte & KByte-to-MByte op's)
;	For: -4 value, the Counter will be divided by 1048576 (for Byte-to-MByte op's)
; $iDeltaIndex = IF >0 the column index of where the delta value should be stored
; $iStart = 1st position in array to start at. For arrays with a bottom count element, like those
;	containing counts/headers, this should be >0 (but it can be anywhere, so long as the data there is valid)
; $iEnd = last position in array to stop at. -1 (default) means end-of-array.
; $bFirstCall = If True, the 'delta change data' will be initialized/reinitialized to 0,
;	otherwise, it contains the change since last call
;
; Returns:
;	Success: True, with @extended = # of changes since last call, @error = # of invalidated handles
;		NOTE: any processes that have ended will have their data (columns 1-3) set to 0,
;			and 1st column will be prefixed with "[Dead Counter Handle]:"
;	Failure: False, with @error set:
;		@error = 16 = not initialized
;		@error = 1 = Invalid parameters
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;
; ADDITIONAL: $_PDH_aInvalidHandles[0]=#invalidated handles (or 0 for none), & size = # invalid handles +1 (bottom element)
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_UpdateCounters($hPDHQueryHandle, ByRef $aPDHCountersArray,$iHandleIndex,$iCountIndex,$iStrIndex=-1,$iDeltaIndex=-1, _
	$iStart=1,$iEnd=-1,$bFirstCall=False)
	; Set this initially so that immediate Returns can rely on this being 1 element = 0
	Dim $_PDH_aInvalidHandles[1]=[0]
	; Checked by _PDH_CollectQueryData():
	;	If Not $_PDH_bInit Then Return SetError(16,0,False)

	; Check array parameter. Requires a 2D array.
	If Not IsArray($aPDHCountersArray) Or UBound($aPDHCountersArray,0)<2 Then Return SetError(1,0,False)

	Local $iArrayColumns,$aRet,$stCounterValue,$iNewVal,$iChangesCount=0,$iDivisor=0

	$iArrayColumns=UBound($aPDHCountersArray,2)

	; Check indexes are within bounds
	If $iHandleIndex<0 Or $iHandleIndex>$iArrayColumns Or $iCountIndex<0 Or $iCountIndex>$iArrayColumns Or _
		$iStrIndex>$iArrayColumns Or $iDeltaIndex>$iArrayColumns Then Return SetError(1,0,False)

	If $iEnd=-1 Then $iEnd=UBound($aPDHCountersArray)-1
	; Everything within bounds and in right order?
	If $iStart<0 Or $iStart>$iEnd Or $iEnd>UBound($aPDHCountersArray)-1 Then Return SetError(1,0,False)

	; 'False' to allow checks for invalid params/Init
	If Not _PDH_CollectQueryData($hPDHQueryHandle,False) Then Return SetError(@error,@extended,False)

	Dim $_PDH_aInvalidHandles[UBound($aPDHCountersArray)+1]
	$_PDH_aInvalidHandles[0]=0
	$stCounterValue=DllStructCreate("long;int64")	; PDH_FMT_COUNTERVALUE (can also change to long;double)

;	Determine if we need to do division on the results (better to just pass a number to divide by?)
	If $iStrIndex=-2 Then
		$iDivisor=$_PDH_iCPUCount	; CPU Count (for % Processor Usage (#6) Counters [Thread (#232) or Process (#230) only])
	ElseIf $iStrIndex=-3 Then
		$iDivisor=1024		; Bytes-To-KBytes, or KBytes-to-MBytes
	ElseIf $iStrIndex=-4 Then
		$iDivisor=1048576	; Bytes-To-MBytes	[1024*1024 = 1048576] or KByte to GBytes
	EndIf

	For $i=$iStart To $iEnd
		; Make sure it hasn't been invalidated 1st
		If IsPtr($aPDHCountersArray[$i][$iHandleIndex]) Then
#cs
			;-----------------------------------------------------
			;  -  Format Options  -
			;	PDH_FMT_LONG	0x00000100 (long-32bit)
			;	PDH_FMT_DOUBLE	0x00000200 (double float)
			;	PDH_FMT_LARGE	0x00000400 <- my choice (int64)
			; 	( + )
			;	PDH_FMT_NOSCALE		0x00001000
			;	PDH_FMT_NOCAP100	0x00008000 <- also my choice (requires division for CPU usage results tho)
			;	PDH_FMT_1000		0x00002000
			;-----------------------------------------------------
#ce
			$aRet=DllCall($_PDH_hDLLHandle,"long","PdhGetFormattedCounterValue","ptr",$aPDHCountersArray[$i][$iHandleIndex],"dword",0x8400, _
				"dword*",0,"ptr",DllStructGetPtr($stCounterValue))

			If @error Then
				; DLL Call error.. hmm..
				If $iStrIndex>=0 Then
					_PDH_DebugWriteErr("DLL Call error ("&@error&") at item("&$aPDHCountersArray[$i][$iStrIndex]&") (index #" &$i&")")
				Else
					_PDH_DebugWriteErr("DLL Call error ("&@error&") at index #" &$i&", Handle:"&$aPDHCountersArray[$i][$iHandleIndex])
				EndIf
			ElseIf $aRet[0] Then
				$_PDH_iLastError=$aRet[0]
				; PDH_INVALID_DATA? (0xC0000BC6). If CStatus also is PDH_CSTATUS_NO_INSTANCE (0x800007D1), counter no longer exists
				If $aRet[0]=0xC0000BC6 And DllStructGetData($stCounterValue,1)=0x800007D1 Then
					$_PDH_aInvalidHandles[0]+=1
					If $iStrIndex>=0 Then
						_PDH_DebugWriteErr("Invalid Data (invalid handle) message for (" & $aPDHCountersArray[$i][$iStrIndex] & _
							"), Total Invalids this call:" & $_PDH_aInvalidHandles[0])
						;	Not a great way to handle the situation, but the Counter handle is invalidated below
						$aPDHCountersArray[$i][$iStrIndex]="[Dead Counter Handle]:" & $aPDHCountersArray[$i][$iStrIndex]
					Else
						_PDH_DebugWriteErr("Invalid data message at index #" &$i&", Handle:"&$aPDHCountersArray[$i][$iHandleIndex])
					EndIf
					; Make a 'Remove Counter' call to remove it from PDH Query Handle
					_PDH_RemoveCounter($aPDHCountersArray[$i][$iHandleIndex])
					_PDH_DebugWriteErr("_PDH_RemoveCounter() call completed (for PDH error 'PDH_INVALID_DATA (0xC0000BC6)')")

					$_PDH_aInvalidHandles[$_PDH_aInvalidHandles[0]]=$i
					$aPDHCountersArray[$i][$iHandleIndex]=0	; Invalidate handle
					$aPDHCountersArray[$i][$iCountIndex]=0	; Set Counter value to 0
					If $iDeltaIndex>=0 Then $aPDHCountersArray[$i][$iDeltaIndex]=-1	; Signal that this is a change in status
				Else
					; DEBUG
					If $iStrIndex>=0 Then
						_PDH_DebugWriteErr("Error Calling PdhGetFormattedCounterValue for ("&$aPDHCountersArray[$i][$iStrIndex]& _
							"), Return:" & Hex($_PDH_iLastError) & " CStatus:"&Hex(DllStructGetData($stCounterValue,1)))
					Else
						_PDH_DebugWriteErr("Error calling PdhGetFormattedCounterValue at index #" &$i& _
							", Handle:"&$aPDHCountersArray[$i][$iHandleIndex]&", Return:"&Hex($_PDH_iLastError)& " CStatus:"&Hex(DllStructGetData($stCounterValue,1)))
					EndIf
				EndIf
			Else
				$iNewVal=DllStructGetData($stCounterValue,2)

				; Common return: PDH_CSTATUS_VALID_DATA (0) = data is valid, but unchanged since last read
				;	Also common:  PDH_CSTATUS_INVALID_DATA  0xC0000BBA
				If DllStructGetData($stCounterValue,1) Then _
					_PDH_DebugWriteErr("PdhGetFormattedCounterValue non-0 status for handle #" & $i & ":" & Hex(DllStructGetData($stCounterValue,1)))
				; Check for Return of PDH_CSTATUS_NEW_DATA (1)? Nah - never seems to occur!

				; Divide if required
				If $iDivisor Then
					$iNewVal=Round($iNewVal/$iDivisor)
				ElseIf $iStrIndex>=0 And StringRegExp($aPDHCountersArray[$i][$iStrIndex],"(:23(0|2)\\6|(Thread|Process)\([^%]+%)",0) Then
					$iNewVal=Round($iNewVal/$_PDH_iCPUCount)
				EndIf

				If $aPDHCountersArray[$i][$iCountIndex]<>$iNewVal And Not $bFirstCall Then
					; Increase # of changes
					$iChangesCount+=1
					#cs
					; DEBUG
					_PDH_DebugWrite("PdhGetFormattedCounterValue change for (" & $aPDHCountersArray[$i][$iStrIndex]&"):"& _
						"Previous Value:" & $aPDHCountersArray[$i][$iCountIndex] & _
						", Delta change:" & ($iNewVal-$aPDHCountersArray[$i][$iCountIndex]) & _
						", New value:" & $iNewVal)
					#ce
					; Capture Delta Change
					If $iDeltaIndex>=0 Then	$aPDHCountersArray[$i][$iDeltaIndex]=$iNewVal-$aPDHCountersArray[$i][$iCountIndex]
				Else
					; No change since last call (delta = 0)
					If $iDeltaIndex>=0 Then $aPDHCountersArray[$i][$iDeltaIndex]=0
				EndIf
				; Capture new value
				$aPDHCountersArray[$i][$iCountIndex]=$iNewVal
			EndIf
		ElseIf $iDeltaIndex>=0 And $aPDHCountersArray[$i][$iDeltaIndex]=-1 Then
		; Counter was invalidated last call, now reset it's delta to 0
			$aPDHCountersArray[$i][$iDeltaIndex]=0
			$iChangesCount+=1	; do we count this? Sure why not
		EndIf
	Next
	; DEBUG
;~ 	_PDH_DebugWrite("Number of counter changes this call:" & $iChangesCount)

	ReDim $_PDH_aInvalidHandles[$_PDH_aInvalidHandles[0]+1]
	$_PDH_aInvalidHandles[0]=$_PDH_aInvalidHandles[0]
	Return SetError($_PDH_aInvalidHandles[0],$iChangesCount,True)
EndFunc


; ===============================================================================================================================
; Func _PDH_GetCounterValueByPath($hPDHQueryHandle,$sCounterPath)
;
; Function to quickly grab a counter value by a path without having to manually add it and remove it.
;	(Basically a wrapper).
;	It does the following:
;		1. If Query Handle is invalid (-1 or 0), it will make a new one
;		2. It will add the Counter (by path) to the Query Handle
;		3. It will grab the current value of the Counter
;		4. It will either a.) Remove the Counter or B) if it created a new Query Handle, it will destroy the Query Handle
;		5. It will return the value obtained from the Counter (or -1 if an error occurred somewhere - see below)
;
; $hPDHQueryHandle = PDH Query Handle, obviously
; $sCounterPath = Counter Path (of the format returned by _PDH_BrowseCounters(). Examples:
;	Format with network path: "\\<PCNAME>\Process(ProcessName)\% Processor Time")
;	Actual Value (on local PC): "\Process(Idle)\% Processor Time"
;
; Return:
;	Success: Counter value, @error = 0
;	Failure: -1, @error set (& possibly @extended):
;		@error = 16 = not initialized
;		@error = 1 = Invalid handle (0 or -1), and could not create a new one (@extended = 1)
;		@error = 2 = DLL Call error, @extended=DLLCall error (see AutoIt Help)
;		@error = 3 = PDH error, @extended = error code, as well as $_PDH_iLastError
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _PDH_GetCounterValueByPath($hPDHQueryHandle,$sCounterPath)
	If Not $_PDH_bInit Then Return SetError(16,0,-1)
	Local $tErr,$bNewQueryHandleCreated=False
	; Check if its a valid Query Handle. If not, we can try to grab one for this call only
	If Not IsPtr($hPDHQueryHandle) Then
		$hPDHQueryHandle=_PDH_GetNewQueryHandle()
		If @error Then Return SetError(@error,1,-1)
		$bNewQueryHandleCreated=True
	EndIf
	Local $hPDHCounterHandle=_PDH_AddCounter($hPDHQueryHandle,$sCounterPath)
	If @error Then
		$tErr=@error
		If $bNewQueryHandleCreated Then	_PDH_FreeQueryHandle($hPDHQueryHandle)
		Return SetError($tErr,0,-1)
	EndIf
	Local $iVal=_PDH_UpdateCounter($hPDHQueryHandle,$hPDHCounterHandle,$sCounterPath)
	$tErr=@error
	If $bNewQueryHandleCreated Then
		_PDH_FreeQueryHandle($hPDHQueryHandle)
	Else
		_PDH_RemoveCounter($hPDHCounterHandle)
	EndIf
	Return SetError($tErr,0,$iVal)
EndFunc
