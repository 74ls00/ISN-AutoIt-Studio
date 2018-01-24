#include-once
; ===============================================================================================================================
; <_WinAPI_GetPerformanceInfo.au3>
;
; Function to get System Performance Information (much of what's listed in Task Manager).
;	NOTE: Windows XP or Server 2003 or higher is required. (or at least psapi.dll of those versions)
;
; Functions:
;	_WinAPI_GetPerformanceInfo()
;
; See also:
;	<_WinAPI_GetSystemTimes.au3>
;	<_WinAPI_GetSystemInfo.au3>
;
; Author: Ascend4nt
; ===============================================================================================================================


; ===================================================================================================================
; Func _WinAPI_GetPerformanceInfo($iInfo=-1,$bConvertPagesToBytes=False)
;
; Function to return System Performance Information. Win XP/2003+ O/S required.
;	NOTE: To get the sizes in bytes of information returned as 'pages' (elements 0-9), you must multiply the number
;	  by 'Page Size' (4096 avg). To further convert that to KB, you would do Round($iVal*$iPageSz/1024)
;	  $bConvertPagesToBytes=True will do the multiplication for you
;
; $iInfo = Performance Info to Get. Possible values are:
;	-1 = get ALL Performance info, returns an array
;	 0 = Commit Total - # pages committed by the system
;	 1 = Commit Limit - max # of pages that can be committed w/o changing pagefile size
;	 2 = Commit Peak - greatest # pages committed since last boot
;	 3 = Physical Total - total physical memory, in pages
;	 4 = Physical Available - available physical memory, in pages
;	 5 = System Cache - amount of system cache memory, in pages
;	 6 = Kernel Total - total of paged+nonpaged memory pools, in pages
;	 7 = Kernel Paged - amount in paged kernel pool, in pages
;	 8 = Kernel NonPaged - amount in nonpaged kernel pool, in pages
;	 9 = Page Size - size of a page [in bytes]
;	10 = Handle Count - # of currently open handles
;	11 = Process Count - # of processes currently running
;	12 = Thread Count - # of threads currently running
; $bConvertPagesToBytes = If True, convert page values to byte values before returning
;
; Returns:
;	Success: A single value (values are interpreted based on data (see descriptions)), or an array if $iInfo=-1.
;	 	[0] = Commit Total - # pages committed by the system
;	 	[1] = Commit Limit - max # of pages that can be committed w/o changing pagefile size
;	 	[2] = Commit Peak - greatest # pages committed since last boot
;	 	[3] = Physical Total - total physical memory, in pages
;	 	[4] = Physical Available - available physical memory, in pages
;	 	[5] = System Cache - amount of system cache memory, in pages
;	 	[6] = Kernel Total - total of paged+nonpaged memory pools, in pages
;	 	[7] = Kernel Paged - amount in paged kernel pool, in pages
;	 	[8] = Kernel NonPaged - amount in nonpaged kernel pool, in pages
;	 	[9] = Page Size - size of a page [in bytes]
;		[10]= Handle Count - # of currently open handles
;		[11]= Process Count - # of processes currently running
;		[12]= Thread Count - # of threads currently running
;	Failure: -1 with @error set:
;		@error = 1 = invalid parameter
;		@error = 2 = DLL call error, @extended contains DLLCall()'s error code
;		@error = 3 = Function returned False (failure) - check GetLastError code
;
; Author: Ascend4nt
; ===================================================================================================================

Func _WinAPI_GetPerformanceInfo($iInfo=-1,$bConvertPagesToBytes=False)
	If $iInfo>12 Then Return SetError(1,0,-1)

	Local Const $tagPERFINFO="dword Sz;ulong_ptr CommitTotal;ulong_ptr CommitLimit;ulong_ptr CommitPeak;ulong_ptr PhysicalTotal;ulong_ptr PhysicalAvailable;ulong_ptr SystemCache;ulong_ptr KernelTotal;ulong_ptr KernelPaged;ulong_ptr KernelNonpaged;ulong_ptr PageSize;dword HandleCount;dword ProcessCount;dword ThreadCount"
	Local $iPageSz,$stPerfInfo=DllStructCreate($tagPERFINFO)
	; Avoid any conflict with other psapi.dll files floating around. Win2000+ should have the 'good' version located in @SystemDir
	;	It might be a good idea to revise this and bundle a newer version of psapi.dll if using on pre-XP/2003 O/S's though.
	Local $aRet=DllCall(@SystemDir&"\psapi.dll","bool","GetPerformanceInfo","ptr",DllStructGetPtr($stPerfInfo),"dword",DllStructGetSize($stPerfInfo))
	If @error Then Return SetError(2,@error,-1)
	If Not $aRet[0] Then Return SetError(3,0,-1)
	$iPageSz=DllStructGetData($stPerfInfo,11)
	; Get ALL info?
	If $iInfo<0 Then
		Dim $aPerfInfo[13]
		For $i=0 To 12
			$aPerfInfo[$i]=DllStructGetData($stPerfInfo,$i+2)
		Next
		If $bConvertPagesToBytes Then
			For $i=0 To 8
				$aPerfInfo[$i]*=$iPageSz
			Next
		EndIf
		Return $aPerfInfo
	EndIf
	If $bConvertPagesToBytes And $iInfo<9 Then Return DllStructGetData($stPerfInfo,$iInfo+2)*$iPageSz
	Return DllStructGetData($stPerfInfo,$iInfo+2)
EndFunc

#cs
#include <Array.au3>
$aPerfInfo=_WinAPI_GetPerformanceInfo(-1,True)
If @error Then Exit
; Set it up to show the same values as Task Manager:
$aPerfInfo[0]="CommitTotal: "&Round($aPerfInfo[0]/1024)&" KB"
$aPerfInfo[1]="CommitLimit: "&Round($aPerfInfo[1]/1024)&" KB"
$aPerfInfo[2]="CommitPeak: "&Round($aPerfInfo[2]/1024)&" KB"
$aPerfInfo[3]="PhysicalTotal: "&Round($aPerfInfo[3]/1024)&" KB"
$aPerfInfo[4]="PhysicalAvailable: "&Round($aPerfInfo[4]/1024)&" KB"
$aPerfInfo[5]="SystemCache: "&Round($aPerfInfo[5]/1024)&" KB"
$aPerfInfo[6]="KernelTotal: "&Round($aPerfInfo[6]/1024)&" KB"
$aPerfInfo[7]="KernelPaged: "&Round($aPerfInfo[7]/1024)&" KB"
$aPerfInfo[8]="KernelNonpaged: "&Round($aPerfInfo[8]/1024)&" KB"
$aPerfInfo[9]="PageSize: "&$aPerfInfo[9]&" bytes"
$aPerfInfo[10]="HandleCount: "&$aPerfInfo[10]
$aPerfInfo[11]="ProcessCount: "&$aPerfInfo[11]
$aPerfInfo[12]="ThreadCount: "&$aPerfInfo[12]
_ArrayDisplay($aPerfInfo,"Performance Info")
#ce