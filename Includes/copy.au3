;~ #region - wFunc: Values that indicate which operation to perform.
;~ Global Const $FO_COPY = 0x0002
;~ Global Const $FO_DELETE = 0x0003
;~ Global Const $FO_MOVE = 0x0001
;~ Global Const $FO_RENAME = 0x0004
;~ #endregion - wFunc: Values that indicate which operation to perform.

;~ #region - fFlags: Flags that control the file operation.
;~ Global Const $FOF_ALLOWUNDO = 0x0040     ;~ Preserve undo information, if possible. Operations can be undone only from the same process that performed the original operation. If, despite earlier warnings against doing so, pFrom does not contain fully-qualified path and file names, this flag is ignored.
;~ Global Const $FOF_CONFIRMMOUSE = 0x0002    ;~ Not used.
;~ Global Const $FOF_FILESONLY = 0x0080     ;~ Perform the operation only on files (not on folders) if a wildcard file name (*.*) is specified.
;~ Global Const $FOF_MULTIDESTFILES = 0x0001     ;~ The pTo member specifies multiple destination files (one for each source file in pFrom) rather than one directory where all source files are to be deposited.
;~ Global Const $FOF_NOCONFIRMATION = 0x0010     ;~ Respond with Yes to All for any dialog box that is displayed.
;~ Global Const $FOF_NOCONFIRMMKDIR = 0x0200     ;~ Do not ask the user to confirm the creation of a new directory if the operation requires one to be created.
;~ Global Const $FOF_NO_CONNECTED_ELEMENTS = 0x2000    ;~ Version 5.0. Do not move connected files as a group. Only move the specified files.
;~ Global Const $FOF_NOCOPYSECURITYATTRIBS = 0x0800    ;~ Version 4.71. Do not copy the security attributes of the file. The destination file receives the security attributes of its new folder.
;~ Global Const $FOF_NOERRORUI = 0x0400     ;~ Do not display a dialog to the user if an error occurs.
;~ Global Const $FOF_NORECURSEREPARSE = 0x8000    ;~ Not used.
;~ Global Const $FOF_NORECURSION = 0x1000     ;~ Only perform the operation in the local directory. Don't operate recursively into subdirectories, which is the default behavior.
;~ Global Const $FOF_NO_UI = "To-Do..."     ;~ Version 6.0.6060 (Windows Vista). Perform the operation silently, presenting no user interface (UI) to the user. This is equivalent to FOF_SILENT | FOF_NOCONFIRMATION | FOF_NOERRORUI | FOF_NOCONFIRMMKDIR.
;~ Global Const $FOF_RENAMEONCOLLISION = 0x0008     ;~ Give the file being operated on a new name in a move, copy, or rename operation if a file with the target name already exists at the destination.
;~ Global Const $FOF_SILENT = 0x0004     ;~ Do not display a progress dialog box.
;~ Global Const $FOF_SIMPLEPROGRESS = 0x0100     ;~ Display a progress dialog box but do not show individual file names as they are operated on.
;~ Global Const $FOF_WANTMAPPINGHANDLE = 0x0020     ;~ If FOF_RENAMEONCOLLISION is specified and any files were renamed, assign a name mapping object that contains their old and new names to the hNameMappings member. This object must be freed using SHFreeNameMappings when it is no longer needed.
;~ Global Const $FOF_WANTNUKEWARNING = 0x4000     ;~ Version 5.0. Send a warning if a file is being permanently destroyed during a delete operation rather than recycled. This flag partially overrides FOF_NOCONFIRMATION.
;~ #endregion - fFlags: Flags that control the file operation.

;~ #region - Return Values.
Global Const $DE_SAMEFILE = 0x71
Global Const $DE_MANYSRC1DEST = 0x72
Global Const $DE_DIFFDIR = 0x73
Global Const $DE_ROOTDIR = 0x74
Global Const $DE_OPCANCELLED = 0x75
Global Const $DE_DESTSUBTREE = 0x76
Global Const $DE_ACCESSDENIEDSRC = 0x78
Global Const $DE_PATHTOODEEP = 0x79
Global Const $DE_MANYDEST = 0x7A
Global Const $DE_INVALIDFILES = 0x7C
Global Const $DE_DESTSAMETREE = 0x7D
Global Const $DE_FLDDESTISFILE = 0x7E
Global Const $DE_FILEDESTISFLD = 0x80
Global Const $DE_FILENAMETOOLONG = 0x81
Global Const $DE_DEST_IS_CDROM = 0x82
Global Const $DE_DEST_IS_DVD = 0x83
Global Const $DE_DEST_IS_CDRECORD = 0x84
Global Const $DE_FILE_TOO_LARGE = 0x85
Global Const $DE_SRC_IS_CDROM = 0x86
Global Const $DE_SRC_IS_DVD = 0x87
Global Const $DE_SRC_IS_CDRECORD = 0x88
Global Const $DE_ERROR_MAX = 0xB7
Global Const $ERRORONDEST = 0x10000
;~ #endregion - Return Values.

#cs ----------------------------------------------------------------------------
	UDF Name..........:    _FileOperationProgress
	UDF Version.......:    1.0
	Change Date.......:    2007-08-02
	UDF Description...:    Executes a file operation with Wndows file operation dialog.

	Author(s).........:    teh_hahn
	Company...........:    none
	URL...............: none

	Parameter(s)......: To-Do...
	Return Value......:    Success:    Returns 1
	Failure:    Returns 0
	When the function fails @error contains extended information:
	To-Do...
	AutoIt Version....:    3.2.4.9
	Note(s)...........:    - Version 1 by SumTingWong on 2006-05-26.
	- Version 2 updated by lod3n on 2007-06-05.
	- Not finished yet...
#ce ----------------------------------------------------------------------------


Func _FileOperationProgress(Const $source, Const $S_DEST = "", Const $I_CREATEDIR = 0, Const $HEX_MODE = 0x0002, Const $HEX_FLAGS = 0x0000)
	Local $objShell = 0
	Local $objFolder = 0
	Local $objScripting = 0
	Local $shfileopstruct = 0
	Local $pFrom = 0
	Local $pTo = 0
	Local $a_dllresult
	Local $uncserver
	Local $uncfolder


	if StringInStr($source, "?") OR StringInStr($source, "=") OR StringInStr($source, ",") OR StringInStr($source, "/") OR StringInStr($source, '"') OR StringInStr($source, "<") OR StringInStr($source, ">") OR StringInStr($source, "|")  then
	   SetError(20)
	   return (0)
    endif

	if StringInStr($S_DEST, "?") OR StringInStr($S_DEST, "=") OR StringInStr($S_DEST, ",") OR StringInStr($S_DEST, "/") OR StringInStr($S_DEST, '"') OR StringInStr($S_DEST, "<") OR StringInStr($S_DEST, ">") OR StringInStr($S_DEST, "|")  then
	   SetError(20)
	   return (0)
    endif

	#Region - This part isn't perfect yet. Would be better with DLLStruct...
	$objShell = ObjCreate("Shell.Application")
	If $objShell == 0 Then
		SetError(@error, 4)
		Return (0)
	EndIf

	If _WinAPI_PathIsUNC($S_DEST) Then
		$uncserver = StringTrimRight($S_DEST, StringLen($S_DEST) - StringInStr($S_DEST, "\", 0, 4))
		If StringRight($uncserver, 1) = "\" Then $uncserver = StringTrimRight($uncserver, 1)
		$objFolder = $objShell.NameSpace($uncserver) ;~ Checking if drive exists.
	Else
		$objFolder = $objShell.NameSpace(StringLeft($S_DEST, 2)) ;~ Checking if drive exists.
	EndIf
	If IsObj($objFolder) == 0 Then
		SetError(@error, 6)
		Return (0)
	EndIf



	If $I_CREATEDIR == 1 Then
		If _WinAPI_PathIsUNC($S_DEST) Then
			$uncfolder = StringReplace($S_DEST, $uncserver, "")
			If StringLeft($uncfolder, 1) = "\" Then $uncfolder = StringTrimLeft($uncfolder, 1)
			$objFolder.NewFolder($uncfolder)
		Else
			$objFolder.NewFolder(StringTrimLeft($S_DEST, 3))
		EndIf


	EndIf


	$objScripting = ObjCreate("Scripting.FileSystemObject") ;~ Creating destination folder on drive.
	If $objScripting == 0 Then
		SetError(@error, 5)
		Return (0)
	EndIf

	If $objScripting.FolderExists($S_DEST) = False Then ;~ Checking if destination does not exist.#
		SetError(@error, 7)
		Return (0)
	EndIf
	#EndRegion - This part isn't perfect yet. Would be better with DLLStruct...

	$shfileopstruct = DllStructCreate("int;uint;ptr;ptr;uint;int;ptr;ptr")
	If @error <> 0 Then
		SetError(@error, 3)
		Return (0)
	EndIf

	DllStructSetData($shfileopstruct, 1, 0) ;~ hwnd
	DllStructSetData($shfileopstruct, 2, $HEX_MODE) ;~ wFunc

	#Region - pFrom
	$pFrom = DllStructCreate("char[" & StringLen($source) + 2 & "]")
	DllStructSetData($pFrom, 1, $source)
	For $i = 1 To StringLen($source) + 2
		If DllStructGetData($pFrom, 1, $i) = 10 Then
			DllStructSetData($pFrom, 1, 0, $i)
		EndIf
	Next
	DllStructSetData($pFrom, 1, 0, StringLen($source) + 2)
	DllStructSetData($shfileopstruct, 3, DllStructGetPtr($pFrom))
	#EndRegion - pFrom

	#Region - pTo
	$pTo = DllStructCreate("char[" & StringLen($S_DEST) + 2 & "]")
	DllStructSetData($pTo, 1, $S_DEST)
	DllStructSetData($pTo, 1, 0, StringLen($S_DEST) + 2)
	DllStructSetData($shfileopstruct, 4, DllStructGetPtr($pTo))
	#EndRegion - pTo

	DllStructSetData($shfileopstruct, 5, $HEX_FLAGS) ;~ fFlags
	DllStructSetData($shfileopstruct, 6, 0) ;~ fAnyOperationsAborted
	DllStructSetData($shfileopstruct, 7, 0) ;~ hNameMappings
	DllStructSetData($shfileopstruct, 8, 0) ;~ lpszProgressTitle

	$a_dllresult = DllCall("shell32.dll", "int", "SHFileOperation", "ptr", DllStructGetPtr($shfileopstruct))
	If @error <> 0 Then
		SetError(@error, 2)
		Return (0)
	EndIf

	$shfileopstruct = 0
	$pFrom = 0
	$pTo = 0

	If $a_dllresult[0] <> 0 Then
		SetError($a_dllresult[0], 1)
		Return (0)
	EndIf

	Return (1)
EndFunc   ;==>_FileOperationProgress


Func _SHFileOperationErrorDecode(Const $HEX_ERROR)
	Switch Hex($HEX_ERROR)
		Case $DE_SAMEFILE
			Return ("The source and destination files are the same file.")
		Case $DE_MANYSRC1DEST
			Return ("Multiple file paths were specified in the source buffer, but only one destination file path.")
		Case $DE_DIFFDIR
			Return ("Rename operation was specified but the destination path is a different directory. Use the move operation instead.")
		Case $DE_ROOTDIR
			Return ("The source is a root directory, which cannot be moved or renamed.")
		Case $DE_OPCANCELLED
			Return ("The operation was cancelled by the user, or silently cancelled if the appropriate flags were supplied to SHFileOperation.")
		Case $DE_DESTSUBTREE
			Return ("The destination is a subtree of the source.")
		Case $DE_ACCESSDENIEDSRC
			Return ("Security settings denied access to the source.")
		Case $DE_PATHTOODEEP
			Return ("The source or destination path exceeded or would exceed MAX_PATH.")
		Case $DE_MANYDEST
			Return ("The operation involved multiple destination paths, which can fail in the case of a move operation.")
		Case $DE_INVALIDFILES
			Return ("The path in the source or destination or both was invalid.")
		Case $DE_DESTSAMETREE
			Return ("The source and destination have the same parent folder.")
		Case $DE_FLDDESTISFILE
			Return ("The destination path is an existing file.")
		Case $DE_FILEDESTISFLD
			Return ("The destination path is an existing folder.")
		Case $DE_FILENAMETOOLONG
			Return ("The name of the file exceeds MAX_PATH.")
		Case $DE_DEST_IS_CDROM
			Return ("The destination is a read-only CD-ROM, possibly unformatted.")
		Case $DE_DEST_IS_DVD
			Return ("The destination is a read-only DVD, possibly unformatted.")
		Case $DE_DEST_IS_CDRECORD
			Return ("The destination is a writable CD-ROM, possibly unformatted.")
		Case $DE_FILE_TOO_LARGE
			Return ("The file involved in the operation is too large for the destination media or file system.")
		Case $DE_SRC_IS_CDROM
			Return ("The source is a read-only CD-ROM, possibly unformatted.")
		Case $DE_SRC_IS_DVD
			Return ("The source is a read-only DVD, possibly unformatted.")
		Case $DE_SRC_IS_CDRECORD
			Return ("The source is a writable CD-ROM, possibly unformatted.")
		Case $DE_ERROR_MAX
			Return ("MAX_PATH was exceeded during the operation.")
		Case $ERRORONDEST
			Return ("An unspecified error occurred on the destination.")
		Case $DE_ROOTDIR
			Return ("Destination is a root directory and cannot be renamed.")
		Case 0x00
			Return ("Successful.")
		Case Else
			Return ("Unknown ErrorCode: " & Hex($HEX_ERROR))
	EndSwitch
EndFunc   ;==>_SHFileOperationErrorDecode

#cs
	_FileOperationProgress("C:\temp", "F:\was", 1, $FO_COPY, $FOF_SIMPLEPROGRESS + $FOF_NOCONFIRMATION)
	If @extended == 1 Then
	MsgBox(64, "_SHFileOperationErrorDecode", "Decode: " & _SHFileOperationErrorDecode(@error))
	EndIf
	Exit(0)
#ce
