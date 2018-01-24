; ===============================================================================================================================
; ISN AutoIt Studio Plugin
; ===============================================================================================================================

;AutoIt Stuff
#NoTrayIcon
Opt("GUICloseOnESC", 0)
Opt("GUIOnEventMode", 1)

;Includes
#include <WindowsConstants.au3>
#include "isnautoitstudio_plugin.au3"

;Demo GUI
$hgui = GUICreate("Demo", 800, 600, -1, -1, $WS_POPUP, BitOr($WS_EX_CLIENTEDGE,$WS_EX_TOOLWINDOW))
GUICtrlCreateLabel("My new plugin!",10,10,200,50)

;The Plugin initialization
_ISNPlugin_initialize($hgui)
If @error Then
	MsgBox(16, "Error", "This program is part of the ISN AutoIt Studio and cannot be started separately!")
	Exit ;Plugin can not start without the ISN
EndIf

;Show the GUI
GUISetState(@SW_SHOW, $hgui)

;While Loop
While 1
	Sleep(100)
WEnd
