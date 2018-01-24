; ===============================================================================================================================
; ISN Plugin SDK Tools
; ===============================================================================================================================
; This Plugin give you some tools if you want to develope an ISN AutoIt Studio Plugin.
; It also contains the latest SDK (isnautoitstudio_plugin.au3)
; ===============================================================================================================================

;AutoIt Stuff
#NoTrayIcon
Opt("GUICloseOnESC", 0)
Opt("GUIOnEventMode", 1)

;Some Variables
Global $SDK_Version = "1.0"

;Includes 1/2
#include <WinAPIDlg.au3>
#include <GuiEdit.au3>
#include <String.au3>
#include "isnautoitstudio_plugin.au3"
#include "GUI.isf" ;Contains the whole GUI and Includes ($hGUI)


;The Plugin initialization
_ISNPlugin_initialize($Plugin_SDK_GUI)
If @error Then
	MsgBox(16, "Error", "This program is part of the ISN AutoIt Studio and cannot be started separately!")
	Exit ;Plugin can not start without the ISN
EndIf

;Includes 2/2
#include "includes\Addons.au3"
#include "includes\Zip32.au3"


;Show the GUI
GUISetState(@SW_SHOW, $Plugin_SDK_GUI)

;While Loop
While 1
	Sleep(100)
WEnd
