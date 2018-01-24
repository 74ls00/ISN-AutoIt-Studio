#include-once
; ===============================================================================================================================
; <_WinAPI_GetSystemInfo.au3>
;
; Simple DLL call to get system information.
;
; Function:
;	_WinAPI_GetSystemInfo()
;
; See also:
;	<_CPURegistryInfo.au3>
;	<CompareCPUProcessorCount.au3>
;	<_ProcessorGetLogicalInfo.au3>
;	EnvGet("NUMBER_OF_PROCESSORS")	[see below]
;
; Other WinAPI calls to get Processor Info:
;	GetLogicalProcessorInformation	[unfortunately available only on Win XP w/SP3 and higher]
;	IsProcessorFeaturePresent (get processor features information)
;
; Other ways to obtain Processor Information:
;	Utilizing the CPUID instruction (through Assembly code) in conjunction with Intel/AMD CPUID code
;	%NUMBER_OF_PROCESSORS%  Environment variable: Number of Processors (physical, not logical, again)
;		EnvGet("NUMBER_OF_PROCESSORS")
;
; On Win2000+, you can use:
;	"HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\"
;		[one subkey for each physical processor, and inside the 1st key (and some inside subsequent ones is)]:
;			Speed, Features set, Processor Name, Identifier, etc.
;
; Note that this will also return 'logical' processors counted as physical ones.
; 	See @ http://support.microsoft.com/kb/888282
;
; On Win NT and Win 2000, it appears the OS 'views' the # CPU's as separate even if one is hyperthreading.
;  On Win 95-Me, it only utilizes one CPU, so it doesn't matter anyway..
; 	See @ http://blogs.msdn.com/oldnewthing/archive/2004/09/13/228780.aspx
;		More info @ http://blogs.msdn.com/oldnewthing/archive/2005/12/16/504659.aspx
;
; Misc. See-Also functions:
;	<_WinAPI_GetPerformanceInfo.au3>
;	<_WinAPI_GetSystemTimes.au3>
;
; Author: Ascend4nt
; ===============================================================================================================================


; ===============================================================================================================================
; Func _WinAPI_GetSystemInfo($iInformation=-1)
;
; Retrieves an array of system information, or just one item based on parameter
;
; $iInformation = The piece of information you would like to collect, or -1 for an entire array:
; 	1 = Processor Architecture [0 = Intel, 6 = Itanium64, 9 = x64 (AMD or Intel), 0xFFFF = Unknown]
; 	2 = Page Size
;	3 = Minimum Application Address
;	4 = Maximum Application Address
;	5 = Active Processor Mask - Set Bits indicate processor has been 'configured into the system' (MSDN)
;		[Bit 0 = processor # 0, Bit 31 = processor 31
;	6 = Number of Processors [not the same as 'Logical Processors']
;	7 = Processor Type [386 = Intel 386, 486 = "" 486, 586 = Pentium, 2200 = Itanium64, 8664 = AMD x8664 (?)
;	8 = Allocation Granularity ("granularity for the starting address at which virtual memory can be allocated" - MSDN)
;	9 = Processor Level (1 for Itanium64, otherwise for Processor Architecture 0 it represents CPU-vendor-specific info)
;	10 = Processor Revision (no clue - check out http://msdn.microsoft.com/en-us/library/ms724958(VS.85).aspx)
;
; Return:
;	Success: @error=0, and either a 10-element array filled in the order described above #1 at element [0], #10 at [9],
;		or a # associated with $iInformation
;	Failure: -1 return, @error is set:
;		@error = 1 = invalid parameter (out of range)
;		@error = 2 = DLL call error
;
; Other WinAPI calls to get Processor Info:
;	GetLogicalProcessorInformation	[unfortunately available only on Win XP w/SP3 and higher]
;	IsProcessorFeaturePresent (get processor features information)
;
; Other ways to obtain Processor Information:
;	%NUMBER_OF_PROCESSORS%  Environment variable: Number of Processors (physical, not logical, again)
;		EnvGet("NUMBER_OF_PROCESSORS")
;
; On Win2000+, you can use:
;	"HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\"
;		[one subkey for each physical processor, and inside the 1st key (and some inside subsequent ones is)]:
;			Speed, Features set, Processor Name, Identifier, etc.
;
; Note that this will also return 'logical' processors counted as physical ones.
; See http://support.microsoft.com/kb/888282
;
; Author: Ascend4nt
; ===============================================================================================================================

Func _WinAPI_GetSystemInfo_ISN($iInformation=-1)
	If $iInformation<>-1 And ($iInformation<1 Or $iInformation>10) Then Return SetError(1,0,-1)
	Local $aRet,$stSystemInfo=DllStructCreate("ushort;short;dword;ptr;ptr;ulong_ptr;dword;dword;dword;short;short")

	; If we are running in 32-bit mode on a 64-bit OS, we need to call a different API function
	If Not @AutoItX64 And @OSArch<>"X86" Then
		$aRet=DllCall("kernel32.dll","none","GetNativeSystemInfo","ptr",DllStructGetPtr($stSystemInfo))
	Else
		$aRet=DllCall("kernel32.dll","none","GetSystemInfo","ptr",DllStructGetPtr($stSystemInfo))
	EndIf

	If @error Then Return SetError(2,@error,-1)

	If $iInformation<>-1 Then
		If $iInformation==1 Then Return DllStructGetData($stSystemInfo,1)
		Return DllStructGetData($stSystemInfo,$iInformation+1)
	EndIf
	Local $aSysInfo[10]
	$aSysInfo[0]=DllStructGetData($stSystemInfo,1)
	For $i=1 To 9
		$aSysInfo[$i]=DllStructGetData($stSystemInfo,$i+2)
	Next
#cs
	; Full feature display:

	MsgBox(64,"System Info", _
		"Processor Architecture:"&$aSysInfo[0]&@CRLF& _
		"Page Size:"&$aSysInfo[1]&@CRLF& _
		"Minimum Application Address:"&$aSysInfo[2]&@CRLF& _
		"Maximum Application Address:"&$aSysInfo[3]&@CRLF& _
		"Active Processor Mask:"&Hex($aSysInfo[4])&@CRLF& _
		"Number of Processors:"&$aSysInfo[5]&@CRLF& _
		"Processor Type:"&$aSysInfo[6]&@CRLF& _
		"Allocation Granularity:"&$aSysInfo[7]&@CRLF& _
		"Processor Level:"&Hex($aSysInfo[8])&@CRLF& _
		"Processor Revision:"&Hex($aSysInfo[9]))

#ce
	Return $aSysInfo
EndFunc

;~ _WinAPI_GetSystemInfo()
