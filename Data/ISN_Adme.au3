#cs
	---------------------------------------------------
	___  __                        ___       __
	|  (_  |\ |    /\     _|_  _   | _|_   (_ _|_      _| o  _
	_|_ __) | \|   /--\ |_| |_ (_) _|_ |_   __) |_ |_| (_| | (_)

	---------------------------------------------------
	ISN ADME (Administrator Elevation)
	---------------------------------------------------

	This tool is used to execute commands or functions in the ISN AutoIt Studio with Administrator rights. The User Account Control (UAC) is displayed in this process.

	These is used for example for the ISN update process::
	The ISN AutoIt Studio (non admin) runs this exe with the needed parameters -> UAC requests Admin rights -> This exe can execute the wished command with Admin rights.
	Every parameter must set under Quotes! (For example: "/runasadmin cmd.exe")
	---------------------------------------------------
#ce

#NoTrayIcon
#RequireAdmin

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=../autoitstudioicon_red.ico
#AutoIt3Wrapper_Res_Comment=https://www.isnetwork.at
#AutoIt3Wrapper_Res_Description=ISN AutoIt Studio Admin Elevation
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=ISI360
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_Field=ProductName|ISN AutoIt Studio Admin Elevation
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Res_HiDpi=Y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

If Not IsArray($CmdLine) Then Exit
If $CmdLine[0] = 0 Then
	MsgBox(16 + 262144, "ISN AutoIt Studio Admin Elevation - Error", "This Program can only be used within the ISN AutoIt Studio!", 0)
	Exit ;Es müssen Parameter angegeben werden!
EndIf

Global $Programmpfad = ""
Global $result = 0

;CMD Befehle
If IsArray($CmdLine) Then
	For $x = 1 To $CmdLine[0]

		;/runasadmin
		If StringInStr($CmdLine[$x], "/runasadmin ") Then
			$Programmpfad = StringStripWS(StringReplace($CmdLine[$x], "/runasadmin ", ""), 3)
		EndIf

		;/execute
		If StringInStr($CmdLine[$x], "/execute ") Then
			$Command_to_execute = StringStripWS(StringReplace($CmdLine[$x], "/execute ", ""), 3)
			If $Command_to_execute <> "" Then
				$result = Execute($Command_to_execute)
				Exit Int($result)
			EndIf
		EndIf

	Next
EndIf

If $Programmpfad = "" Then
	MsgBox(16 + 262144, "ISN AutoIt Studio Admin Elevation - Error", "Error while executing the command! (Code 0)", 0)
	Exit 0
EndIf

;Programm mit Adminrechten starten
$parameter = ""

For $x = 1 To $CmdLine[0]
	If StringInStr($CmdLine[$x], "/runasadmin ") Then ContinueLoop
	$parameter = $parameter & '"' & $CmdLine[$x] & '" '
Next

$result = Run($Programmpfad & " " & $parameter)
If @error Then
	MsgBox(16 + 262144, "ISN AutoIt Studio Admin Elevation - Error", "Error while executing the command! (Code 1)", 0)
	Exit 0
EndIf

;Programm beenden
Exit Int($result)
