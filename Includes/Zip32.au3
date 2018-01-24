#include-once

Global Const $IDM_REPLACE_NO   = 100
Global Const $IDM_REPLACE_YES  = 102
Global Const $IDM_REPLACE_ALL  = 103
Global Const $IDM_REPLACE_NONE = 104

Global $hZipDll = DllOpen(@scriptdir&"\Data\zip32.dll")
Global $hUnZipDll = DllOpen(@scriptdir&"\Data\unzip32.dll")

Global $hCallBack_ZIPPrint, $hCallBack_ZIPPassword, $hCallBack_ZIPComment, $hCallBack_ZIPProgress

Global $hCallBack_UnZIPPrint, $hCallBack_UnZIPReplace, $hCallBack_UnZIPPassword, $hCallBack_UnZIPMessage, $hCallBack_UnZIPService

Global $aZIPCallBack[9] = [$hCallBack_ZIPPrint, $hCallBack_ZIPPassword, $hCallBack_ZIPComment, $hCallBack_ZIPProgress, _
						   $hCallBack_UnZIPPrint, $hCallBack_UnZIPReplace, $hCallBack_UnZIPPassword, $hCallBack_UnZIPMessage, _
						   $hCallBack_UnZIPService]

Global $RootDir = DllStructCreate("char[256]")
DllStructSetData($RootDir, 1, @ScriptDir)

Global $TempDir = DllStructCreate("char[256]")
DllStructSetData($TempDir, 1, @TempDir)

Global $ZPOPT = DllStructCreate("ptr Date;ptr szRootDir;ptr szTempDir;int fTemp;int fSuffix;int fEncrypt;int fSystem;" & _
								"int fVolume;int fExtra;int fNoDirEntries;int fExcludeDate;int fIncludeDate;int fVerbose;" & _
								"int fQuiet;int fCRLFLF;int fLFCRLF;int fJunkDir;int fGrow;int fForce;int fMove;" & _
								"int fDeleteEntries;int fUpdate;int fFreshen;int fJunkSFX;int fLatestTime;int fComment;" & _
								"int fOffsets;int fPrivilege;int fEncryption;int fRecurse;int fRepair;char fLevel[2]")

DllStructSetData($ZPOPT, "szRootDir", DllStructGetPtr($RootDir))
DllStructSetData($ZPOPT, "szTempDir", DllStructGetPtr($TempDir))
DllStructSetData($ZPOPT, "fTemp", 0)
DllStructSetData($ZPOPT, "fVolume", 0)
DllStructSetData($ZPOPT, "fExtra", 0)
DllStructSetData($ZPOPT, "fVerbose", 1)
DllStructSetData($ZPOPT, "fQuiet", 0)
DllStructSetData($ZPOPT, "fCRLFLF", 0)
DllStructSetData($ZPOPT, "fLFCRLF", 0)
DllStructSetData($ZPOPT, "fGrow", 0)
DllStructSetData($ZPOPT, "fForce", 0)
DllStructSetData($ZPOPT, "fDeleteEntries", 0)
DllStructSetData($ZPOPT, "fJunkSFX", 0)
DllStructSetData($ZPOPT, "fOffsets", 0)
DllStructSetData($ZPOPT, "fRepair", 0)

Global $DCLIST = DllStructCreate("int ExtractOnlyNewer;int SpaceToUnderscore;int PromptToOverwrite;int fQuiet;int ncflag;" & _
								 "int ntflag;int nvflag;int nfflag;int nzflag;int ndflag;int noflag;int naflag;int nZIflag;" & _
								 "int Cflag;int fPrivilege;ptr Zip;ptr ExtractDir")

DllStructSetData($DCLIST, "fQuiet", 1)
DllStructSetData($DCLIST, "ncflag", 0)
DllStructSetData($DCLIST, "nvflag", 0)
DllStructSetData($DCLIST, "naflag", 0)
DllStructSetData($DCLIST, "nZIflag", 0)
DllStructSetData($DCLIST, "Cflag", 1)
DllStructSetData($DCLIST, "fPrivilege", 1)

Global $USERFUNCTIONS = DllStructCreate("ptr print;ptr sound;ptr replace;ptr password;ptr SendApplicationMessage;" & _
										"ptr ServCallBk;ulong TotalSizeComp;ulong TotalSize;ulong CompFactor;ulong NumMembers;" & _
										"ushort cchComment")

; #FUNCTION# =============================================================
; Name............: _Zip_Init
; Description.....: Register user-defined DLL callbacks functions and initialize ZIP functions
; Syntax..........: _Zip_Init($sZIP_PrintFunc, $sZIP_PassFunc, $sZIP_CommentFunc, $sZIP_ServiceFunc)
; Parameter(s)....: $sZIP_PrintFunc - DLL callback Print function
;					$sZIP_PassFunc - DLL callback Password function
;					$sZIP_CommentFunc - DLL callback Comment function
;					$sZIP_ServiceFunc - DLL callback Service function
; Return value(s).: Success - returns 1
;					Failure - Sets @error to 1 and returns 0
; Requirement(s)..: AutoIt 3.2.12.0
; Note(s).........: Tested on Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ========================================================================
Func _Zip_Init($sZIP_PrintFunc, $sZIP_PassFunc, $sZIP_CommentFunc, $sZIP_ServiceFunc)
	$hCallBack_ZIPPrint    = DllCallbackRegister($sZIP_PrintFunc, "int", "str;long")
	$hCallBack_ZIPComment  = DllCallbackRegister($sZIP_CommentFunc, "int", "ptr")
	$hCallBack_ZIPPassword = DllCallbackRegister($sZIP_PassFunc, "int", "ptr;int;ptr;ptr")
	$hCallBack_ZIPProgress = DllCallbackRegister($sZIP_ServiceFunc, "int", "str;long")

	Local $ZIPUSERFUNCTIONS = DllStructCreate("ptr print;ptr comment;ptr password;ptr service")

	DllStructSetData($ZIPUSERFUNCTIONS, "print", DllCallbackGetPtr($hCallBack_ZIPPrint))
	DllStructSetData($ZIPUSERFUNCTIONS, "comment", DllCallbackGetPtr($hCallBack_ZIPComment))
	DllStructSetData($ZIPUSERFUNCTIONS, "password", DllCallbackGetPtr($hCallBack_ZIPPassword))
	DllStructSetData($ZIPUSERFUNCTIONS, "service", DllCallbackGetPtr($hCallBack_ZIPProgress))

	Local $aRet = DllCall($hZipDll, "int", "ZpInit", "ptr", DllStructGetPtr($ZIPUSERFUNCTIONS))

	If $aRet[0] = 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_Zip_Init

; #FUNCTION# =============================================================
; Name............: _ZIP_SetOptions
; Description.....: Sets the options in the zip dll
; Syntax..........: _ZIP_SetOptions([$sDate = 0[, $sEncrypt = 0[, $sSys = 1[, $sEmptyFolder = 0[, $sExcludeDate = 0
;					[, $sIncludeDate = 0[, $sJunkDir = 0[, $sMove = 0[, $sUpdate = 0[, $sFresh = 0[, $sLatestTime = 0
;					[, $sComment = 0[, $sPrivilege = 0[, $sRecurse = 1[, $sLevel = 9]]]]]]]]]]]]]]])
; Parameter(s)....: $sDate - [optional] 0 = (default) Don`t add date, "YYYY-MM-DD" = date to include after
;					+(useful for including/excluding files by date)
;					$sEncrypt - [optional] 0 = (default) Don`t encrypt, 1 = encrypt files
;					$sSys - [optional] 0 = Don`t include System/Hidden Files, 1 = (default) include System/Hidden Files
;					$sEmptyFolder - [optional] 0 = (default) Add empty folder, 1 = don`t add empty folder
;					$sExcludeDate - [optional] 1 = Excluding files later than specified sate, else 0 (default)
;					$sIncludeDate - [optional] 1 = Including files earlier than specified date, else 0 ()
;					$sJunkDir - [optional] 0 = (default) don`t junk directory names, 1 = junk directory names
;					$sMove - [optional] 1 = Delete files added or updated in zip file, else 0 (default)
;					$sUpdate - [optional] 1 = File-overwrite only if newer, else 0 (default)
;					$sFresh - [optional] 1 = File-freshen only if newer, else 0 (default)
;					$sLatestTime [optional] 1 = Set zip file time to time of latest file in it, else 0 (default)
;					$sComment [optional] 1 = Put comment in zip file, else 0 (default)
;					$sPrivilege [optional] 1 = (default) Not save privileges, 0 = save privileges
;					$sRecurse [optional] 1 = (default) Recurse into subdirectories, else 0 (default)
;					$sLevel [optional] Compression level (0 - 9) default is 9 (maximum)
; Return value(s).: Success - returns 1
;					Failure - Sets @error to 1 and returns 0
; Requirement(s)..: AutoIt 3.2.12.0
; Note(s).........: Tested on Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ========================================================================
Func _ZIP_SetOptions($sDate = 0, $sEncrypt = 0, $sSys = 1, $sEmptyFolder = 0, $sExcludeDate = 0, $sIncludeDate = 0, _
					 $sJunkDir = 0, $sMove = 0, $sUpdate = 0, $sFresh = 0, $sLatestTime = 0, $sComment = 0, $sPrivilege = 1, _
					 $sRecurse = 1, $sLevel = 9)

	If $sDate = 0 Then
		DllStructSetData($ZPOPT, "Date", 0)
	Else
		$DateStruct = DllStructCreate("char[12]")
		DllStructSetData($DateStruct, 1, $sDate)
		DllStructSetData($ZPOPT, "Date", DllStructGetPtr($DateStruct, 1))
	EndIf

	DllStructSetData($ZPOPT, "fEncrypt", $sEncrypt)
	DllStructSetData($ZPOPT, "fSystem", $sSys)
	DllStructSetData($ZPOPT, "fNoDirEntries", $sEmptyFolder)
	DllStructSetData($ZPOPT, "fExcludeDate", $sExcludeDate)
	DllStructSetData($ZPOPT, "fIncludeDate", $sIncludeDate)
	DllStructSetData($ZPOPT, "fJunkDir", $sJunkDir)
	DllStructSetData($ZPOPT, "fMove", $sMove)
	DllStructSetData($ZPOPT, "fUpdate", $sUpdate)
	DllStructSetData($ZPOPT, "fFreshen", $sFresh)
	DllStructSetData($ZPOPT, "fLatestTime", $sLatestTime)
	DllStructSetData($ZPOPT, "fComment", $sComment)
	DllStructSetData($ZPOPT, "fPrivilege", $sPrivilege)
	DllStructSetData($ZPOPT, "fRecurse", $sRecurse)
	DllStructSetData($ZPOPT, "fLevel", $sLevel)

	Local $aRet = DllCall($hZipDll, "int", "ZpSetOptions", "ptr", DllStructGetPtr($ZPOPT))
	If $aRet[0] = 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_ZIP_SetOptions

; #FUNCTION# =============================================================
; Name............: _ZIP_Archive
; Description.....: Create ZIP archive
; Syntax..........: _ZIP_Archive($sZIPName, $sFileName)
; Parameter(s)....: $sZIPName - Archive file name
;					$sFileName - File names to zip up
; Return value(s).: Success - Returns 1
;					Failure - Sets @error to 1 and returns 0
; Requirement(s)..: AutoIt 3.2.12.0
; Note(s).........: Tested on Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ========================================================================
Func _ZIP_Archive($sZIPName, $sFileName)
	$FileNameBuff = DllStructCreate("char[256]")
	DllStructSetData($FileNameBuff, 1, $sFileName)

	$aRet = DllCall($hZipDll, "int", "ZpArchive", "int", 1, "str", $sZIPName, "ptr*", DllStructGetPtr($FileNameBuff))
	If $aRet[0] <> 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_ZIP_Archive

; #FUNCTION# =============================================================
; Name............: _UnZIP_Init
; Description.....: Register user-defined DLL callbacks functions
; Syntax..........: _UnZIP_Init($sUnZIP_PrintFunc, $sUnZIP_ReplaceFunc, $sUnZIP_PasswordFunc, $sUnZIP_SendAppMsgFunc,
;					$sUnZIP_ServiceFunc)
; Parameter(s)....: $sUnZIP_PrintFunc - DLL callback Print function
;					$sUnZIP_ReplaceFunc - DLL callback Replace function
;					$sUnZIP_PasswordFunc - DLL callback Password function
;					$sUnZIP_SendAppMsgFunc - DLL callback Application message function
;					$sUnZIP_ServiceFunc - DLL callback Service message function
; Return value(s).: None
; Requirement(s)..: AutoIt 3.2.12.0
; Note(s).........: Tested on Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ========================================================================
Func _UnZIP_Init($sUnZIP_PrintFunc, $sUnZIP_ReplaceFunc, $sUnZIP_PasswordFunc, $sUnZIP_SendAppMsgFunc, $sUnZIP_ServiceFunc)
	$hCallBack_UnZIPPrint = DllCallbackRegister($sUnZIP_PrintFunc, "int", "str;long")
	$hCallBack_UnZIPReplace = DllCallbackRegister($sUnZIP_ReplaceFunc, "int", "str")
	$hCallBack_UnZIPPassword = DllCallbackRegister($sUnZIP_PasswordFunc, "int", "ptr;int;ptr;ptr")
	$hCallBack_UnZIPMessage = DllCallbackRegister($sUnZIP_SendAppMsgFunc, "int", "ulong;ulong;uint;uint;uint;uint;uint;uint;" & _
												  "str;ptr;ptr;ulong;str")
	$hCallBack_UnZIPService = DllCallbackRegister($sUnZIP_ServiceFunc, "int", "str;long")

	DllStructSetData($USERFUNCTIONS, "print", DllCallbackGetPtr($hCallBack_UnZIPPrint))
	DllStructSetData($USERFUNCTIONS, "sound", 0)
	DllStructSetData($USERFUNCTIONS, "replace", DllCallbackGetPtr($hCallBack_UnZIPReplace))
	DllStructSetData($USERFUNCTIONS, "password", DllCallbackGetPtr($hCallBack_UnZIPPassword))
	DllStructSetData($USERFUNCTIONS, "SendApplicationMessage", $hCallBack_UnZIPMessage)
	DllStructSetData($USERFUNCTIONS, "ServCallBk", DllCallbackGetPtr($hCallBack_UnZIPService))
EndFunc   ;==>_UnZIP_Init

; #FUNCTION# =============================================================
; Name............: _UnZIP_SetOptions
; Description.....: Sets the options in the unzip dll
; Syntax..........: _UnZIP_SetOptions($sOnlyNewer = 0, $SpaceUnderScore = 0, $sPromptOverwrite = 0, $sTestZip = 0, $sFresh = 0, _
;					$sComment = 0, $sDirRet = 1, $sOverWrite = 1)
; Parameter(s)....: $sOnlyNewer - [optional] 1 = Extract only newer/new, else 0 (default)
;					$SpaceUnderScore - [optional] 1 = Convert space to underscore, else 0 (default)
;					$sPromptOverwrite - [optional] 1 = Prompt to overwrite required, else 0 (default)
;					$sTestZip - [optional] 1 = Test zip file, else 0 (default)
;					$sFresh - [optional] 1 = Extract only newer over existing, else 0 (default)
;					$sComment - [optional] 1 = Display Zip file comment, else 0 (default)
;					$sDirRet - [optional] 1 = (default) retain (create) subdirectories when extracting, else 0
;					$sOverWrite - [optional] 1 = (default) Overwrite files, else 0
; Return value(s).: None
; Requirement(s)..: AutoIt 3.2.12.0
; Note(s).........: Tested on Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ========================================================================
Func _UnZIP_SetOptions($sOnlyNewer = 0, $SpaceUnderScore = 0, $sPromptOverwrite = 0, $sTestZip = 0, $sFresh = 0, $sComment = 0, _
					   $sDirRet = 1, $sOverWrite = 1)
	DllStructSetData($DCLIST, "ExtractOnlyNewer", $sOnlyNewer)
	DllStructSetData($DCLIST, "SpaceToUnderscore", $SpaceUnderScore)
	DllStructSetData($DCLIST, "PromptToOverwrite", $sPromptOverwrite)
	DllStructSetData($DCLIST, "ntflag", $sTestZip)
	DllStructSetData($DCLIST, "nfflag", $sFresh)
	DllStructSetData($DCLIST, "nzflag", $sComment)
	DllStructSetData($DCLIST, "ndflag", $sDirRet) ;retain (create) subdirectories when extracting
	DllStructSetData($DCLIST, "noflag", $sOverWrite)
EndFunc   ;==>_UnZIP_SetOptions

; #FUNCTION# =============================================================
; Name............: _UnZIP_Unzip
; Description.....: Extract files from Zip archive
; Syntax..........: _UnZIP_Unzip($sZIPName, $sOutput = @ScriptDir, $iFileNumberIncl = 0, $sFileNameIncl = "*.*",
;					$iFileNumberExcl = 0, $FileNameExcl = "*.*")
; Parameter(s)....: $sZIPName - Archive file name
;					$sOutput - [optional] Output directory where files be unpacked, if omitted, then be used current directory
;					$iFileNumberIncl - [optional] Number of files to be included for processing, 0 (default) = all files extracted
;					$sFileNameIncl - [optional] File names to be unarchived, wildcard patterns are recognized, default = *.* (all)
;					$iFileNumberExcl - [optional] Number of files to be excluded from processing, default = 0 (don`t excluding)
;					$FileNameExcl - [optional] File names to be excluded from the unarchiving process, default = ""
; Return value(s).: Success - Returns 1
;					Failure - Sets @error to 1 and returns 0
; Requirement(s)..: AutoIt 3.2.12.0
; Note(s).........: Tested on Windows XP SP2
; Author(s).......: R.Gilman (a.k.a. rasim)
; ========================================================================
Func _UnZIP_Unzip($sZIPName, $sOutput = @ScriptDir, $iFileNumberIncl = 0, $sFileNameIncl = "*.*", $iFileNumberExcl = 0, $FileNameExcl = "")
	Local $ZIP_Buffer = DllStructCreate("char[256]")
	DllStructSetData($ZIP_Buffer, 1, $sZIPName)

	Local $ExtractDir_Buffer = DllStructCreate("char[256]")
	DllStructSetData($ExtractDir_Buffer, 1, $sOutput)

	DllStructSetData($DCLIST, "Zip", DllStructGetPtr($ZIP_Buffer))
	DllStructSetData($DCLIST, "ExtractDir", DllStructGetPtr($ExtractDir_Buffer))

	Local $FileInclude = DllStructCreate("char[256]")
	DllStructSetData($FileInclude, 1, $sFileNameIncl)

	Local $FileExclude = DllStructCreate("char[256]")
	DllStructSetData($FileExclude, 1, $FileNameExcl)

	$aRet = DllCall($hUnZipDll, "int", "Wiz_SingleEntryUnzip", "int", $iFileNumberIncl, "ptr*", DllStructGetPtr($FileInclude), _
					"int", $iFileNumberExcl, "ptr*", DllStructGetPtr($FileExclude), "ptr", DllStructGetPtr($DCLIST), _
					"ptr", DllStructGetPtr($USERFUNCTIONS))

	If $aRet[0] <> 0 Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_UnZIP_Unzip

Func OnAutoItExit()
	If $hZipDll <> -1 Then DllClose($hZipDll)
	If $hUnZipDll <> -1 Then DllClose($hUnZipDll)
	For $i = 0 To UBound($aZIPCallBack) - 1
		If $aZIPCallBack[$i] <> 0 Then DllCallbackFree($aZIPCallBack[0])
	Next
EndFunc   ;OnAutoItExit

func _Reload_Zip()
If $hZipDll <> -1 Then DllClose($hZipDll)
If $hUnZipDll <> -1 Then DllClose($hUnZipDll)
Global $hZipDll = DllOpen(@scriptdir&"\Data\zip32.dll")
Global $hUnZipDll = DllOpen(@scriptdir&"\Data\unzip32.dll")
EndFunc