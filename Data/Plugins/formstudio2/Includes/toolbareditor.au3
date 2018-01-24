#include "..\Forms\Formstudio_ToolbarEditor.isf"
Opt("GUIOnEventMode", 1) ;0=disabled, 1=OnEvent mode enabled

GUISetState()



Func _Menu_Editor_Aktualisiere_Vorschau()
	_GUICtrlMenu_DestroyMenu($MenuEditor_Vorschaumenue)
	$MenuEditor_Vorschaumenue = _GUICtrlMenu_CreateMenu()
	$item = _GUICtrlTreeView_GetFirstItem($menueditor_treeview)
	If $item = 0 Then
		_Menueditor_Clear()
		Return
	EndIf
	While 1
		_GUICtrlMenu_AddMenuItem($MenuEditor_Vorschaumenue, _GUICtrlTreeView_GetText($menueditor_treeview, $item), 0, _Menu_Editor_Vorschau_nach_Childs_Durchsuchen($item))
		$item = _GUICtrlTreeView_GetNextSibling($menueditor_treeview, $item)
		If $item = 0 Then ExitLoop
	WEnd
	If _GUICtrlTreeView_GetCount($menueditor_treeview) = 0 Then
		_Menueditor_Clear()
	Else
		_GUICtrlMenu_SetMenu($menueditor_vorschauGUI, $MenuEditor_Vorschaumenue)
	EndIf
 EndFunc   ;==>_Menu_Editor_Aktualisiere_Vorschau


func _exit()
   Exit
endfunc

while 1
	Sleep(100)

wend