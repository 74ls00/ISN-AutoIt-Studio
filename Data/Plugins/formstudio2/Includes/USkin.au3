#include-once
;// This file is a part of the NEEMedia USkin class library.
;// 2005-2006 Never-Ending Media Technology Ltd,co., All Rights Reserved.
;//
;// THIS FILE IS THE PROPERTY OF NEEMEDIA AND IS NOT TO BE
;// RE-DISTRIBUTED BY ANY MEANS WHATSOEVER WITHOUT THE EXPRESSED WRITTEN
;// CONSENT OF NEEMEDIA.
;//
;// THIS CODE CAN ONLY BE USED UNDER THE TERMS AND CONDITIONS OUTLINED
;// IN THE USKIN PRO LICENSE AGREEMENT. NEEMEDIA GRANTS TO
;// YOU (ONE SOFTWARE DEVELOPER) THE LIMITED RIGHT TO USE THIS SOFTWARE ON A
;// SINGLE COMPUTER.
;//
;// CONTACT INFORMATION:
;// support@neemedia.com
;// http://www.neemedia.com
;//
;/////////////////////////////////////////////////////////////////////////////

Global $__USkin_UskinDLL = -1

Func _USkin_LoadDLL($szUSkinDLL = "USkin.dll")
	$__USkin_UskinDLL = DllOpen($szUSkinDLL)
	If $__USkin_UskinDLL<0 Then Return SetError($__USkin_UskinDLL<0,0,False)
	DllCall("kernel32.dll", "handle", "LoadLibraryW", "wstr", $szUSkinDLL)
	Return True
EndFunc

#cs ----------------------------------------------------------------------------
Function Name	:USkinInit
Description		:Init uskin lib and load skin file.
ProtoType		:
	BOOL USkinInit(  LPCTSTR lpszUserName    // user name
	  LPCTSTR lpszRegCode     // sn
	  LPCTSTR lpszFileName    // uskin file name
	);
Parameters		:
	lpszFileName
		[in] uskin file name,path like:neemedia.u3,..\neemedia.u3
	lpszUserName
		[in, opt] user name.default is NULL
	lpszRegCode
		[in, opt] correct sn with user name,default is NULL
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero
#ce
;~ USKIN_API BOOL  __stdcall USkinInit(LPCTSTR lpszUserName,LPCTSTR lpszRegCode,LPCTSTR lpszFileName);

Func _USkin_Init($szFileName , $szUserName = "" , $szRegCode = "")
	If $__USkin_UskinDLL<0 And Not _USkin_LoadDLL() Then Return SetError(1,0,0)
	Local $tpUserName = "ptr", $tpRegCode = "ptr"
	If StringLen($szUserName) Then $tpUserName = "str"
	If StringLen($szRegCode) Then $tpRegCode = "str"

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinInit", $tpUserName, $szUserName, $tpRegCode, $szRegCode, "str", $szFileName)
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc



#cs ----------------------------------------------------------------------------
Function Name	:USkinExit
Description		:Exit uskin lib.free memory that uskin alloced
ProtoType		:
	BOOL USkinExit(  );
Parameters		:
	none
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
;~ USKIN_API BOOL  __stdcall USkinExit();
Func _USkin_Exit()
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinExit")
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc

#cs ----------------------------------------------------------------------------
Function Name	:USkinLoadSkin
Description		:Load skin from file.
ProtoType		:
	BOOL USkinLoadSkin(  LPCTSTR lpszFileName    // USkin file name
	);
Parameters		:
	lpszFileName
		[in] uskin file name£¬support path like:neemedia.u3,..\neemedia.u3
Return values	:
		If the function succeeds, the return value is nonzero. If the function fails, the return value is zero
#ce
;~ USKIN_API BOOL  __stdcall USkinLoadSkin(LPCTSTR lpszFileName);
Func _USkin_LoadSkin($szFileName)
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinLoadSkin", "str", $szFileName)
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc

#cs ----------------------------------------------------------------------------
Function Name	:USkinAboutSkin
Description		:Show skin file's copyright information dialog,such as author,author's email,url.
ProtoType		:
	BOOL USkinAboutSkin(  );
Parameters		:
	none
Return values	:
	none
#ce
;~ USKIN_API void	__stdcall USkinAboutSkin();
Func _USkin_AboutSkin()
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinAboutSkin")
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetMenu
Description		:retrieves the handle to the menu assigned to the given window
ProtoType		:
	HMENU USkinGetMenu(  HWND hWnd    // handle to the window
	);
Parameters		:
	hWnd
		[in] handle to the window
Return values	:
	The return value is the handle to the menu. If the given window has no menu, the return value is NULL.
#ce
;~ USKIN_API HMENU __stdcall USkinGetMenu(HWND hWnd);
Func _USkin_GetMenu($hWnd)
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "ptr", "USkinGetMenu", "hWnd", $hWnd)
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc

#cs ----------------------------------------------------------------------------
Function Name	:USkinUpdateMenuBar
Description		:Update window menubar after modify the menu get from USkinGetMenu.
ProtoType		:
	BOOL USkinUpdateMenuBar(  HWND hWnd    // Handle of window
	);
Parameters		:
	hWnd
		[in] handle of window to update menubar
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
;~ USKIN_API BOOL  __stdcall USkinUpdateMenuBar(HWND hWnd);
Func _USkin_UpdateMenuBar($hWnd)
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinUpdateMenuBar", "hWnd", $hWnd)
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc

#cs ----------------------------------------------------------------------------
Function Name	:USkinApplyColorTheme
Description		:Apply color theme using hue and saturation.
ProtoType		:
	BOOL USkinApplyColorTheme(  float fHue    // hue
		  float fSaturation     // saturation
	);
Parameters		:
	fHue
		[in] hue.value range :0.0f-360.f
	fSaturation
		[in] saturation.value range:0.0f - 1.0f
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
;~ USKIN_API BOOL __stdcall USkinApplyColorTheme(float fHue,float fSaturation);
Func _USkin_ApplyColorTheme($fHue, $fSaturation)
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinApplyColorTheme", "float", $fHue, "float", $fSaturation)
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc

; Prog@ndy
; same as _USkin_ApplyColorTheme but for a RGB-color
Func _USkin_ApplyColorThemeRGB($iRGB)
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)
	Local $HSV = __USkin_RGB2HSV360(Number($iRGB))
	If @error Then Return SetError(3,0,0)
	Local $result = _USkin_ApplyColorTheme($HSV[0],$HSV[1])
	Return SetError(@error,0,$result)
EndFunc

#cs ----------------------------------------------------------------------------
Function Name	:USkinRemoveSkin
Description		:Pause uskin.unlike USkinExit function,this function not exit uskin lib,just change the interface look and feel into windows default look
ProtoType		:
	BOOL USkinRemoveSkin(  );
Parameters		:
	none
Return values	:
	failed return false,otherwise return true
#ce
;~ USKIN_API BOOL  __stdcall USkinRemoveSkin();
Func _USkin_RemoveSkin()
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinRemoveSkin")
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc


#cs ----------------------------------------------------------------------------
Function Name	:USkinRestoreSkin
Description		:After USkinRemoveSkin,call this function to change interface to uskin look and feel.
ProtoType		:
	BOOL USkinRestoreSkin(  );
Parameters		:
	none
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
;~ USKIN_API BOOL  __stdcall USkinRestoreSkin();
Func _USkin_RestoreSkin()
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinRestoreSkin")
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc


; #FUNCTION# ======================================================================================
; Name...........: __USkin_RGB2HSV360
; Description ...: Converts RGB to HSV360
; Syntax.........: _ColorConvertRGBtoHSL($avArray)
; Parameters ....: $avArray - An array containing RGB values in their respective positions
; Return values .: Success - The array containing the HSL values for the inputted RGB values
;                  Failure - 0, sets @error to 1
; Author ........: Ultima
; Modified.......: Prog@ndy
; Remarks .......: See: <a href="http://www.easyrgb.com/math.php?MATH=M18#text18">EasyRGB - Color mathematics and conversion formulas.</a>
; Related .......: _ColorConvertHSLtoRGB
; Link ..........;
; =================================================================================================
Func __USkin_RGB2HSV360($nColor)
	Local $nR = BitAND(BitShift($nColor, 16), 0xFF)
	Local $nG = BitAND(BitShift($nColor, 8), 0xFF)
	Local $nB = BitAND($nColor, 0xFF)

	Local $nMax = $nR
	If $nMax < $nG Then $nMax = $nG
	If $nMax < $nB Then $nMax = $nB

	Local $nMin = $nR
	If $nMin > $nG Then $nMin = $nG
	If $nMin > $nB Then $nMin = $nB


	Local $nMinMaxSum = ($nMax + $nMin)
	Local $nMinMaxDiff = ($nMax - $nMin)

	Local $nH, $nS

	If $nMax = 0 Then
		; Grayscale
		$nS = 0
		$nH = 0
	Else

		$nS = $nMinMaxDiff/$nMax

		; Hue
		Switch $nMax
			Case $nR
				$nH = ($nG - $nB) / (6 * $nMinMaxDiff)
			Case $nG
				$nH = ($nB - $nR) / (6 * $nMinMaxDiff) + 1 / 3
			Case $nB
				$nH = ($nR - $nG) / (6 * $nMinMaxDiff) + 2 / 3
		EndSwitch
		If $nH < 0 Then $nH += 1
		If $nH > 1 Then $nH -= 1



	EndIf

	Local $avReturn[3] = [$nH*360, $nS, $nMax]
	Return $avReturn
EndFunc

;////////////////////////////////////////////////////////////////////////////////
;//-------------------Professional Function List--------------------------------
;//Notes: following function only valide in professional version,
;//       not valide in free version
;//
;////////////////////////////////////////////////////////////////////////////////
#cs
#cs ----------------------------------------------------------------------------
Function Name	:USkinApplyColorThemeByRGB
Description		:Apply color theme using RGB value.
ProtoType		:
	BOOL USkinApplyColorThemeByRGB(  COLORREF clrTheme    // RGB color
	);
Parameters		:
	clrTheme
		[in] RGB color to apply theme
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinApplyColorThemeByRGB(COLORREF clrTheme);

#cs ----------------------------------------------------------------------------
Function Name	:USkinLoadSkinFromBuffer
Description		:Load uskin from buffer and change the interface look and feel.
ProtoType		:
	BOOL USkinLoadSkinFromBuffer(  byte* lpBuffer    // pointer to uskin data in memory
		  UINT nBufferSize     // memory buffer size
	);
Parameters		:
	lpBuffer
		[in] uskin data pointer,take careful use,must pass valid pointer,can be null
	nBufferSize
		[in] memory buffer size
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinLoadSkinFromBuffer(byte* lpBuffer,UINT nBufferSize);

#cs ----------------------------------------------------------------------------
Function Name	:USkinLoadSkinFromResource
Description		:Load uskin from resource and change the interface look and feel.
ProtoType		:
	BOOL USkinLoadSkinFromResource(  HMODULE hInstance    // handle of module
		  LPCTSTR lpszResourceName     // resource name
		LPCTSTR lpszResourceType     // resouce type
	);
Parameters		:
	hInstance
		[in] module handle£¬if hInstance is NULL,will use current module handle as default
	lpszResourceName
		[in] resource name of uskin resource
	lpszResourceType
		[in] resource type
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinLoadSkinFromResource(HMODULE hInstance,LPCTSTR lpszResourceName,LPCTSTR lpszResourceType);

#cs ----------------------------------------------------------------------------
Function Name	:USkinSetMenuItemImage
Description		:Set menu item image.
ProtoType		:
	BOOL USkinSetMenuItemImage(  HWND hWnd    // The handle to the window
		UINT nMenuID     // menu item ID
		HIMAGELIST hImageList     // The handle to the image list
		UINT nImageIndex     // image index
	);
Parameters		:
	hWnd
		[in] The handle to the window,if null USkinSetMenuItemImage will set image list to global menu
	nMenuID
		[in] ID of menu item
	hImageList
		[in] The handle to the image list,if null not set
	nImageIndex
		[in] image index in image list
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinSetMenuItemImage(HWND hWnd,UINT nMenuID,HIMAGELIST hImageList,UINT nImageIndex);

#cs ----------------------------------------------------------------------------
Function Name	:USkinSetMenuItemImageEx
Description		:Set menu item image.
ProtoType		:
	BOOL USkinSetMenuItemImageEx(  HWND hWnd    // The handle to the window
		UINT nMenuID     // menu item's ID
		HIMAGELIST hImageList     // image list handle
		UINT nImageIndex     // image index in image list
		HIMAGELIST hImageListHot     // hilighted state image list handle
		UINT nImageIndexHot     // image index in image list
		HIMAGELIST hImageListDisabled     // disabled state image list handle
		UINT nImageIndexDisabled     // image index in image list
	);
Parameters		:
	hWnd
		[in] The handle to the window,if is null the USkinSetMenuItemImageEx will set global menu item image
	nMenuID
		[in] menu item ID
	hImageList
		[in] The handle to the image list ,if is null ,not set
	nImageIndex
		[in] image index in image list
	hImageListHot
		[in] The handle to the hilighted state image list,if null not set
	nImageIndexHot
		[in] image index in image list
	hImageListDisabled
		[in] The handle to the disabeld state imag list, if null not set
	nImageIndexDisabled
		[in] image index in image list
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinSetMenuItemImageEx(HWND hWnd,UINT nMenuID,HIMAGELIST hImageList,UINT nImageIndex,HIMAGELIST hImageListHot,UINT nImageIndexHot,HIMAGELIST hImageListDisabled,UINT nImageIndexDisabled);

typedef HANDLE HUSKIN;

#cs ----------------------------------------------------------------------------
Function Name	:USkinOpenSkinData
Description		:Open custom define skin object data.
ProtoType		:
	HUSKIN USkinOpenSkinData(  LPCTSTR lpszSkinObjectName    // custom define skin object name
	);
Parameters		:
	lpszSkinObjectName
		[in] custom define uskin object name
Return values	:
	If the function succeeds, the return value is handle of uskin object. If the function fails, the return value is NULL
#ce
USKIN_API HUSKIN __stdcall USkinOpenSkinData(LPCTSTR lpszSkinObjectName);

#cs ----------------------------------------------------------------------------
Function Name	:USkinCloseSkinData
Description		:Close custom skin data.
ProtoType		:
	BOOL USkinCloseSkinData(  HUSKIN hUSkin    // handle to the uskin object
	);
Parameters		:
	hUSkin
		[in] The handle of uskin object
Return values	:
	If the function succeeds, the return value is a handle to the uskin object. If the function fails, the return value is NULL.
#ce
USKIN_API BOOL __stdcall USkinCloseSkinData(HUSKIN hUSkin);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetBool
Description		:Get custom define skin object bool property value.
ProtoType		:
	BOOL USkinGetBool(  HUSKIN hUSkin    // The handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		BOOL* lpValue    //
	);
Parameters		:
	hUSkin
		[in] The handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpValue
		[out] BOOL vlaue pointer
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetBool(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,BOOL* lpValue);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetInt
Description		:Get int property value of uskin object.
ProtoType		:
	BOOL USkinGetInt(  HUSKIN hUSkin    // handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		int* lpValue    //
	);
Parameters		:
	hUSkin
		[in] handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpValue
		[out] int value pointer
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetInt(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,int* lpValue);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetDWORD
Description		:Get custom define skin object DWORD property value.
ProtoType		:
	BOOL USkinGetDWORD(  HUSKIN hUSkin    // The handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		DWORD* lpValue    //
	);
Parameters		:
	hUSkin
		[in] The handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpValue
		[out] DWORD value pointer
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetDWORD(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,DWORD* lpValue);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetDouble
Description		:Get custom define skin object double property value.
ProtoType		:
	BOOL USkinGetDouble(  HUSKIN hUSkin    // The handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		double* lpValue    //
	);
Parameters		:
	hUSkin
		[in] The handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpValue
		[out] double value pointer
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetDouble(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,double* lpValue);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetString
Description		:Get custom define skin object string property value.
ProtoType		:
	BOOL USkinGetString(  HUSKIN hUSkin    // The handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		LPTSTR lpString    // pointer to the string buffer
		UINT nMaxSize    // string buffer max size
	);
Parameters		:
	hUSkin
		[in] The handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpString
		[out] pointer to the string buffer
	nMaxSize
		[in] max size of string buffer
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero
#ce
USKIN_API BOOL __stdcall USkinGetString(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,LPTSTR lpString,UINT nMaxSize);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetEnumString
Description		:Get custom define skin object enum value name.
ProtoType		:
	BOOL USkinGetEnumString(  HUSKIN hUSkin    // The handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		LPTSTR lpString    // pointer to the string buffer
		UINT nMaxSize    //
	);
Parameters		:
	hUSkin
		[in] The handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpString
		[out] pointer to the buffer
	nMaxSize
		[in] string buffer size
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetEnumString(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,LPTSTR  lpString,UINT nMaxSize);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetEnumValue
Description		:Get custom define skin object DWORD property value.
ProtoType		:
	BOOL USkinGetEnumValue(  HUSKIN hUSkin    // The handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		DWORD* lpValue    //
	);
Parameters		:
	hUSkin
		[in] The handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpValue
		[out] DWORD value pointer
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetEnumValue(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,DWORD* lpValue);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetFont
Description		:Get custom define skin object font property vaule.
ProtoType		:
	BOOL USkinGetFont(  HUSKIN hUSkin    // The handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		LOGFONT* lpFont    //
	);
Parameters		:
	hUSkin
		[in] The handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpFont
		[out] LOGFONT value pointer
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetFont(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,LOGFONT* lpLogFont);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetColor
Description		:Get custom define object color property value.
ProtoType		:
	BOOL USkinGetColor(  HUSKIN hUSkin    // The handle to the uskin object
		LPCTSTR lpszSkinPropName    // property name
		COLORREF* lpColor    //
	);
Parameters		:
	hUSkin
		[in] The handle to the uskin object
	lpszSkinPropName
		[in] property name
	lpColor
		[out] COLORREF value pointer
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetColor(HUSKIN hUSkin,LPCTSTR lpszSkinPropName,COLORREF* lpColor);

#cs ----------------------------------------------------------------------------
Function Name	:USkinDrawSkinImageSection
Description		:Draw special skinimagesection with skinpaintoption on DC.
ProtoType		:
	BOOL USkinDrawSkinImageSection(  HUSKIN hUSkin    // Handle to the USkin object
		LPCTSTR lpszSkinPaintOptionResName    // custom skinpaintoption property name
		LPCTSTR lpszSkinImageSectionResName    // custom skinimagesection property name
		HDC hDC    // handle to the device context
		LPRECT lpDrawRect    // rectangle of skinimagesection to be drawn
	);
Parameters		:
	hUSkin
		[in] The handle of uskin object
	lpszSkinPaintOptionResName
		[in] custom skinpaintoption property name
	lpszSkinImageSectionResName
		[in] custom skinimagesection property name
	hDC
		[in] Handle to the device context
	lpDrawRect
		[in] Pointer to a RECT structure that contains the rectangle (in logical coordinates) in which the property is to be drawn
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero
#ce
USKIN_API BOOL __stdcall USkinDrawSkinImageSection(HUSKIN hUSkin,LPCTSTR lpszSkinPaintOptionResName,LPCTSTR lpszSkinImageSectionResName,HDC hDC,LPRECT lpDrawRect);

#cs ----------------------------------------------------------------------------
Function Name	:USkinDrawText
Description		:Draw special textstyle within a rectangle on DC.
ProtoType		:
	BOOL USkinDrawText(  HUSKIN hUSkin    // The handle of USkin object
		LPCTSTR lpszSkinTextStyleResName    // The textstyle property name
		HDC hDC    // handle to the device context
		LPRECT lpTextRect    // text rectangle
		LPCTSTR lpszText    // texted to be drawn,must to a null-terminated string
	);
Parameters		:
	hUSkin
		[in] The handle of USkin object
	lpszSkinTextStyleResName
		[in] The property name. which type must be TEXTEFFECT
	hDC
		[in] Handle to the device context
	lpTextRect
		[in] Pointer to a RECT structure that contains the rectangle (in logical coordinates) in which the text is to be draw
	lpszText
		[in] pointer to the string to be drawn
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinDrawText(HUSKIN hUSkin,LPCTSTR lpszSkinTextStyleResName,HDC hDC,LPRECT lpTextRect,LPCTSTR lpszText);

#cs ----------------------------------------------------------------------------
Function Name	:USkinSetWindowSkin
Description		:Set windows skin.
ProtoType		:
	BOOL USkinSetWindowSkin(  HWND hWnd    // The handle to the window
		LPCTSTR lpszSkinObjectName    // uskin object name
	);
Parameters		:
	hWnd
		[in] The handle to the window
	lpszSkinObjectName
		[in] uskin object name
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero
#ce
USKIN_API BOOL __stdcall USkinSetWindowSkin(HWND hWnd,LPCTSTR lpszSkinObjectName);

#cs ----------------------------------------------------------------------------
Function Name	:USkinEnableWindowSkin
Description		:Enable window support skin.
ProtoType		:
	BOOL USkinEnableWindowSkin(  HWND hWnd    // The handle of window
		BOOL bEnabled    // using uskin
	);
Parameters		:
	hWnd
		[in] The handle of window
	bEnabled
		[in] is window supported uskin
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero
#ce
USKIN_API BOOL __stdcall USkinEnableWindowSkin(HWND hWnd,BOOL bEnabled);

#cs ----------------------------------------------------------------------------
Function Name	:USkinApplyThread
Description		:Apply uskin to thread UI.
ProtoType		:
	BOOL USkinApplyThread(  DWORD dwThreadID    // thread id
	);
Parameters		:
	dwThreadID
		[in] thread id
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinApplyThread(DWORD dwThreadID);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetSysColor
Description		:Get uskin define system color.
ProtoType		:
	COLORREF USkinGetSysColor(  int nIndex    // color index
	);
Parameters		:
	nIndex
		[in] Color Index Value Meaning
Return values	:
	If the function succeeds, the return value is RGB color. If the function fails, the return value is 0.
#ce
USKIN_API COLORREF __stdcall USkinGetSysColor(int nIndex);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetSysColorBrush
Description		:Get uskin define system color brush.
ProtoType		:
	HBRUSH USkinGetSysColorBrush(  int nIndex    // index of brush
	);
Parameters		:
	nIndex
		[in] index of brush Value Meaning

Return values	:
	If the function succeeds, the return value is handle to the brush. If the function fails, the return value is NULL.
#ce
USKIN_API HBRUSH __stdcall USkinGetSysColorBrush(int nIndex);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetWinColor
Description		:Get system color.
ProtoType		:
	COLORREF USkinGetWinColor(  int nIndex    // color index
	);
Parameters		:
	nIndex
		[in] color index Value Meaning
Return values	:
	If the function succeeds, the return value is RGB color. If the function fails, the return value is zero.
#ce
USKIN_API COLORREF __stdcall USkinGetWinColor(int nIndex);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetWinColorBrush
Description		:Get windows system color brush.
ProtoType		:
	HBRUSH USkinGetWinColorBrush(  int nIndex    // index
	);
Parameters		:
	nIndex
		[in] color brush index Value Meaning

Return values	:
	If the function succeeds, the return value is handle to the brush. If the function fails, the return value is NULL
#ce

USKIN_API HBRUSH __stdcall USkinGetWinColorBrush(int nIndex);
#cs ----------------------------------------------------------------------------
Function Name	:USkinDrawFrameControl
Description		:Same as DrawFrameControl, you can see detail in msdn.
ProtoType		:
	BOOL USkinDrawFrameControl(  HDC hDC    // device context
		LPRECT lpRect    // draw rect
		UINT uType    // draw type
		UINT uState    // draw state
	);
Parameters		:
	hDC
		[in] device context
	lpRect
		[in] draw rect
	uType
		[in] draw type
	uState
		[in] draw state
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL	__stdcall USkinDrawFrameControl(HDC hdc,LPRECT lprc,UINT uType,UINT uState);

//New Functions in v2.2
#cs ----------------------------------------------------------------------------
Function Name	:USkinGetWindowSkinObjectText
Description		:Get windows skin object's text property.
ProtoType		:
	BOOL USkinGetWindowSkinObjectText(  HWND hWnd    // Handle of window
		LPCTSTR lpszSkinObjectName    // Skin object name
		LPTSTR lpString    // lpString
		UINT nMaxSize    //
	);
Parameters		:
	hWnd
		[in] Handle of window
	lpszSkinObjectName
		[in] skin object name
	lpString
		[out] string text
	nMaxSize
		[in] max string size
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetWindowSkinObjectText(HWND hWnd,LPCTSTR lpszSkinObjectName,LPTSTR lpString,UINT nMaxSize);

#cs ----------------------------------------------------------------------------
Function Name	:USkinSetWindowSkinObjectText
Description		:Set window skinobject's text property.
ProtoType		:
	BOOL USkinSetWindowSkinObjectText(  HWND hWnd    // handle of window
		LPCTSTR lpszSkinObjectName    // skin object name
		LPTSTR lpString    // text to set
	);
Parameters		:
	hWnd
		[in] handle of window
	lpszSkinObjectName
		[in] skin object name
	lpString
		[in] text to set
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinSetWindowSkinObjectText(HWND hWnd,LPCTSTR lpszSkinObjectName,LPCTSTR lpString);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetWindowSkinObjectRect
Description		:Get window skin object's rect property.
ProtoType		:
	BOOL USkinGetWindowSkinObjectRect(  HWND hWnd    // Handle of window
		LPCTSTR lpszSkinObjectName    // Skin object name
		LPRECT lpRect    //
	);
Parameters		:
	hWnd
		[in] Handle of window
	lpszSkinObjectName
		[in] Skin object name
	lpRect
		[in] RECT value
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL __stdcall USkinGetWindowSkinObjectRect(HWND hWnd,LPCTSTR lpszSkinObjectName,LPRECT lpRect);

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetWindowSkinObjectVisible
Description		:Get window skin object's visible property.
ProtoType		:
	BOOL USkinGetWindowSkinObjectVisible(  HWND hWnd    // Handle of window
		LPCTSTR lpszSkinObjectName    // skin object name
		BOOL* lpbVisible    //
	);
Parameters		:
	hWnd
		[in] handle of window
	lpszSkinObjectName
		[in] skin object name
	lpbVisible
		[out] BOOL* vale to store result
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL _stdcall USkinSetWindowSkinObjectVisible(HWND hWnd,LPCTSTR lpszSkinObjectName,BOOL bVisible);

#cs ----------------------------------------------------------------------------
Function Name	:USkinSetWindowSkinObjectVisible
Description		:Set skin object's visible property that apply to the window.
ProtoType		:
	BOOL USkinSetWindowSkinObjectVisible(  HWND hWnd    // Handle of window
		LPCTSTR lpszSkinObjectName    // SkinObject name
		BOOL bVisible    //
	);
Parameters		:
	hUSkin
		[in] handle of window
	lpszSkinObjectName
		[in] skinobject name
	bVisible
		[in] set skinobject visible
Return values	:
	If the function succeeds, the return value is nonzero. If the function fails, the return value is zero.
#ce
USKIN_API BOOL _stdcall USkinGetWindowSkinObjectVisible(HWND hWnd,LPCTSTR lpszSkinObjectName,BOOL& bVisible);

#ce

;//Error Support
;~ enum EnumUSkinErrorCode
;~ {
;~ 	ueFunctionNotSupport,
;~ 	ueFunctionError
;~ };
Global Enum $ueFunctionNotSupport, $ueFunctionError

#cs ----------------------------------------------------------------------------
Function Name	:USkinGetLastError
Description		:Get last error code.
ProtoType		:
	BOOL USkinGetLastError(
	);
Parameters		:
	none
Return values	:
	Get the result code
#ce
;~ USKIN_API LONG __stdcall USkinGetLastError();
Func _USkin_GetLastError()
	If $__USkin_UskinDLL<0 Then Return SetError(1,0,0)

	Local $result = DllCall($__USkin_UskinDLL, "int", "USkinGetLastError")
	If @error Then Return SetError(2,0,0)
	Return $result[0]
EndFunc

#cs -----------------------------------------------------------------------------
Message Name	:WM_USKINCOMMAND
Description		:this message will raised when click window caption button.
ProtoType		:
	WM_USKINCOMMAND      //
		WPARAMwParam    //
		LPARAMlParam    //

Parameters		:
	wParam
		caption button command id
	lParam
		caption button name
Return values	:
	failed return false,otherwise return true
#ce
;~ #ifndef WM_USKINCOMMAND
;~ 	#define WM_USKINCOMMAND	WM_USER+1001
	Global Const $WM_USKINCOMMAND	= 0x400+1001
;~ #endif

#cs -----------------------------------------------------------------------------
Message Name	:WM_USKINCHANGED
Description		:this message will send when change uskin file or apply color theme to uskin.
ProtoType		:
	WM_USKINCHANGED      //
		WPARAMwParam    //
		LPARAMlParam    //

Parameters		:
	wParam
		0
	lParam
		0
Return values	:
	failed return false,otherwise return true
#ce
;~ #ifndef WM_USKINCHANGED
;~ 	#define WM_USKINCHANGED WM_USER+1005
	Global Const $WM_USKINCHANGED = 0x400+1005
;~ #endif
