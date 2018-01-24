#include-once

;**********************************************************
; Constants
;**********************************************************

If Not IsDeclared("TVM_GETITEM")			Then	Global Const $TVM_GETITEM				= $TV_FIRST + 12
If Not IsDeclared("TVM_SETITEM")			Then	Global Const $TVM_SETITEM				= $TV_FIRST + 13

;**********************************************************
; Set an item state
;**********************************************************
Func MyCtrlGetItemState($hTV, $nID)
	Local $hWnd = GUICtrlGetHandle($hTV)
	If $hWnd = 0 Then $hWnd = $hTV

	Local $hItem = GUICtrlGetHandle($nID)
	If $hItem = 0 Then $hItem = $nID

	$nState = GetItemState($hWnd, $hItem)

	Switch $nState
		Case 1
			$nState = $GUI_UNCHECKED
		Case 2
			$nState = $GUI_CHECKED
		Case 3
			$nState = $GUI_INDETERMINATE
		Case 4
			$nState = BitOr($GUI_DISABLE, $GUI_UNCHECKED)
		Case 5
			$nState = BitOr($GUI_DISABLE, $GUI_CHECKED)
		Case Else
			Return 0
	EndSwitch

	Return $nState
EndFunc


;**********************************************************
; Get an item state
;**********************************************************
Func MyCtrlSetItemState($hTV, $nID, $nState)
	Local $hWnd = GUICtrlGetHandle($hTV)
	If $hWnd = 0 Then $hWnd = $hTV

	Local $hItem = GUICtrlGetHandle($nID)
	If $hItem = 0 Then $hItem = $nID

	Switch $nState
		Case $GUI_UNCHECKED
			$nState = 1
		Case $GUI_CHECKED
			$nState = 2
		Case $GUI_INDETERMINATE
			$nState = 3
		Case BitOr($GUI_DISABLE, $GUI_UNCHECKED)
			$nState = 4
		Case BitOr($GUI_DISABLE, $GUI_CHECKED)
			$nState = 5
		Case Else
			Return
	EndSwitch

	SetItemState($hWnd, $hItem, $nState)

	CheckChildItems($hWnd, $hItem, $nState)
	CheckParents($hWnd, $hItem, $nState)

EndFunc


;**********************************************************
; MY_WM_NOTIFY
;**********************************************************
Func _WM_NOTIFY_Treeview($hWnd, $nMsg, $wParam, $lParam,$control)
	Local $stNmhdr		= DllStructCreate("dword;int;int", $lParam)
	Local $hWndFrom		= DllStructGetData($stNmhdr, 1)
	Local $nNotifyCode	= DllStructGetData($stNmhdr, 3)
	Local $hItem		= 0


	; Check if its treeview and only NM_CLICK and TVN_KEYDOWN
	If Not BitAnd(GetWindowLong($hWndFrom, $GWL_STYLE), $TVS_CHECKBOXES) Or _
		Not ($nNotifyCode = $NM_CLICK Or $nNotifyCode = $TVN_KEYDOWN) Then Return $GUI_RUNDEFMSG

	If $nNotifyCode = $TVN_KEYDOWN Then
		Local $lpNMTVKEYDOWN = DllStructCreate("dword;int;int;short;uint", $lParam)

		; Check for 'SPACE'-press
		If DllStructGetData($lpNMTVKEYDOWN, 4) <> $VK_SPACE Then Return $GUI_RUNDEFMSG
		$hItem = SendMessage_Tree($hWndFrom, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
	Else
		Local $Point = DllStructCreate("int;int")
;~ 		ControlFocus ( $hWndFrom, "", $control )
		GetCursorPos_Tree($Point)
		ScreenToClient($hWndFrom, $Point)

		; Check if clicked on state icon
		Local $tvHit = DllStructCreate("int[2];uint;dword")
		DllStructSetData($tvHit, 1, DllStructGetData($Point, 1), 1)
		DllStructSetData($tvHit, 1, DllStructGetData($Point, 2), 2)

		$hItem = SendMessage_Tree($hWndFrom, $TVM_HITTEST, 0, DllStructGetPtr($tvHit))

		If Not BitAnd(DllStructGetData($tvHit, 2), $TVHT_ONITEMSTATEICON) Then Return $GUI_RUNDEFMSG
	EndIf

	If $hItem > 0 Then
		Local $nState = GetItemState($hWndFrom, $hItem)

		$bCheckItems = 1

		If $nState = 1 Then
			$nState = 1
		ElseIf $nState = 2 Then
			$nState = 0
		ElseIf $nState = 3 Then
			$nState = 1
		ElseIf $nState > 3 Then
			$nState = $nState - 1
			$bCheckItems = 0
		EndIf

		SetItemState($hWndFrom, $hItem, $nState)

		$nState += 1

		; If item are disabled there is no chance to change it and it's parents/children
		If $bCheckItems Then
			CheckChildItems($hWndFrom, $hItem, $nState)
			CheckParents($hWndFrom, $hItem, $nState)
		EndIf
	EndIf

EndFunc


;**********************************************************
; Helper functions
;**********************************************************
Func CheckChildItems($hWnd, $hItem, $nState)

	Local $hChild = SendMessage_Tree($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $hItem)

	While $hChild > 0
		if GetItemState($hWnd, $hChild) = 5 OR GetItemState($hWnd, $hChild) = 4 then
		   $hChild = SendMessage_Tree($hWnd, $TVM_GETNEXTITEM, $TVGN_NEXT, $hChild)
		   ContinueLoop
		 endif
		SetItemState($hWnd, $hChild, $nState)
		CheckChildItems($hWnd, $hChild, $nState)

		$hChild = SendMessage_Tree($hWnd, $TVM_GETNEXTITEM, $TVGN_NEXT, $hChild)
	WEnd
EndFunc


Func CheckParents($hWnd, $hItem, $nState)

	Local $nTmpState1 = 0, $nTmpState2 = 0
	Local $bDiff = 0
	Local $i = 0

	Local $hParent = SendMessage_Tree($hWnd, $TVM_GETNEXTITEM, $TVGN_PARENT, $hItem)

	If $hParent > 0 Then
		Local $hChild = SendMessage_Tree($hWnd, $TVM_GETNEXTITEM, $TVGN_CHILD, $hParent)

		If $hChild > 0 Then
			Do
				$i = $i + 1

				If $hChild = $hItem Then
					$nTmpState2 = $nState
				Else
					$nTmpState2 = GetItemState($hWnd, $hChild)
				EndIf

				If $i = 1 Then $nTmpState1 = $nTmpState2

				If $nTmpState1 <> $nTmpState2 Then
					$bDiff = 1
					ExitLoop
				EndIf

				$hChild = SendMessage_Tree($hWnd, $TVM_GETNEXTITEM, $TVGN_NEXT, $hChild)
			Until $hChild <= 0

			If $bDiff Then
				SetItemState($hWnd, $hParent, 3)
				$nState = 3
			Else
				SetItemState($hWnd, $hParent, $nState)
			EndIf

		EndIf

		CheckParents($hWnd, $hParent, $nState)
	EndIf
EndFunc


Func SetItemState($hWnd, $hItem, $nState)
	$nState = BitShift($nState, -12)

	Local $tvItem = DllStructCreate("uint;dword;uint;uint;ptr;int;int;int;int;int;int")

	DllStructSetData($tvItem, 1, $TVIF_STATE)
	DllStructSetData($tvItem, 2, $hItem)
	DllStructSetData($tvItem, 3, $nState)
	DllStructSetData($tvItem, 4, $TVIS_STATEIMAGEMASK)

	SendMessage_Tree($hWnd, $TVM_SETITEM, 0, DllStructGetPtr($tvItem))
EndFunc


Func GetItemState($hWnd, $hItem)
	Local $tvItem = DllStructCreate("uint;dword;uint;uint;ptr;int;int;int;int;int;int")

	DllStructSetData($tvItem, 1, $TVIF_STATE)
	DllStructSetData($tvItem, 2, $hItem)
	DllStructSetData($tvItem, 4, $TVIS_STATEIMAGEMASK)

	SendMessage_Tree($hWnd, $TVM_GETITEM, 0, DllStructGetPtr($tvItem))

	Local $nState = DllStructGetData($tvItem, 3)

	$nState = BitAnd($nState, $TVIS_STATEIMAGEMASK)
	$nState = BitShift($nState, 12)

	Return $nState
EndFunc


Func LoadStateImage($hTreeView, $sFile)
	Local $hWnd = GUICtrlGetHandle($hTreeView)
	If $hWnd = 0 Then $hWnd = $hTreeView



;~ 	If @Compiled Then
;~ 		Local $hModule = LoadLibrary_Tree(@ScriptFullPath)
;~ 		$hImageList = ImageList_LoadImage($hModule, "#170", 16, 1, $CLR_NONE, $IMAGE_BITMAP, BitOr($LR_LOADTRANSPARENT, $LR_CREATEDIBSECTION))
;~ 	Else
		$hImageList = ImageList_LoadImage(0, $sFile, 16, 1, $CLR_NONE, $IMAGE_BITMAP, BitOr($LR_LOADFROMFILE, $LR_LOADTRANSPARENT, $LR_CREATEDIBSECTION))
;~ 	EndIf

	SendMessage_Tree($hWnd, $TVM_SETIMAGELIST, $TVSIL_STATE, $hImageList)
	InvalidateRect($hWnd, 0, 1)
EndFunc


;**********************************************************
; Win32-API functions
;**********************************************************
Func SendMessage_Tree($hWnd, $Msg, $wParam, $lParam)
	$nResult = DllCall("user32.dll", "int", "SendMessage", _
											"hwnd", $hWnd, _
											"int", $Msg, _
											"int", $wParam, _
											"int", $lParam)
	Return $nResult[0]
EndFunc


Func GetWindowLong($hWnd, $nIndex)
	$nResult = DllCall("user32.dll", "int", "GetWindowLong", "hwnd", $hWnd, "int", $nIndex)
	Return $nResult[0]
EndFunc


Func GetCursorPos_Tree($Point)
	DllCall("user32.dll", "int", "GetCursorPos", "ptr", DllStructGetPtr($Point))
EndFunc


Func ScreenToClient($hWnd, $Point)
    DllCall("user32.dll", "int", "ScreenToClient", "hwnd", $hWnd, "ptr", DllStructGetPtr($Point))
EndFunc


Func InvalidateRect($hWnd, $lpRect, $bErase)
	DllCall("user32.dll", "int", "InvalidateRect", _
								"hwnd", $hWnd, _
								"ptr", $lpRect, _
								"int", $bErase)
EndFunc


Func LoadLibrary_Tree($sFile)
	Local $hModule = DllCall("kernel32.dll", "hwnd", "LoadLibrary", "str", $sFile)
	Return $hModule[0]
EndFunc


Func ImageList_LoadImage($hInst, $sFile, $cx, $cGrow, $crMask, $uType, $uFlags)
	Local $hImageList = DllCall("comctl32.dll", "hwnd", "ImageList_LoadImage", _
														"hwnd", $hInst, _
														"str", $sFile, _
														"int", $cx, _
														"int", $cGrow, _
														"int", $crMask, _
														"int", $uType, _
														"int", $uFlags)
	Return $hImageList[0]
EndFunc


Func DestroyImageList()
	DllCall("comctl32.dll", "int", "ImageList_Destroy", "hwnd", $hImageList)
EndFunc