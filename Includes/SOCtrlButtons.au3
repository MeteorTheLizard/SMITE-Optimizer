;- This script is part of the SMITE Optimizer, which is licensed under the GNU General Public License v3.0.
;- Certain conditions apply for using this script in your work. Read the license linked below.
;- https://github.com/MeteorTheLizard/SMITE-Optimizer/blob/master/LICENSE
;- Made by MeteorTheLizard (C) 2023.


#Include-once
#Include <GDIPlus.au3>


OnAutoItExitRegister("__SOCtrlButtons_ShutDown")

Func __SOCtrlButtons_ShutDown()
	_GDIPlus_Shutdown()
EndFunc


Local $bGDIStarted = False


Func _SOCtrlButtons_Create($GUI,$sText,$iLeft,$iTop,$iWidth,$iHeight,$obj_BGColor,$obj_FontC,$sFont = "Segoe UI",$iFontsize = 10,$iFontStyle = 1,$obj_Color = "0xFFFFFF")

	If Not $bGDIStarted Then
		$bGDIStarted = True

		_GDIPlus_Startup()
	EndIf


	$obj_BGColor = "0xFF" & Hex($obj_BGColor,6)
	$obj_FontC = "0xFF" & Hex($obj_FontC,6)
	$obj_Color = "0xFF" & Hex($obj_Color,6)


	Local $obj_Graphic1 = _GDIPlus_BitmapCreateFromScan0($iWidth,$iHeight,$GDIP_PXF32ARGB)
	Local $obj_Graphic0 = _GDIPlus_ImageGetGraphicsContext($obj_Graphic1)

	Local $obj_Family = _GDIPlus_FontFamilyCreate($sFont)

	Local $obj_Format = _GDIPlus_StringFormatCreate()

		_GDIPlus_StringFormatSetAlign($obj_Format,1)
		_GDIPlus_StringFormatSetLineAlign($obj_Format,1)


	Local $cFontColor = _GDIPlus_BrushCreateSolid($obj_FontC)
	Local $cFrameColor = _GDIPlus_PenCreate($obj_Color,2)
	Local $cBGColor = _GDIPlus_BrushCreateSolid($obj_BGColor)


	Local $obj_Font = _GDIPlus_FontCreate($obj_Family,$iFontsize,$iFontStyle)
	Local $obj_Layout = _GDIPlus_RectFCreate(0,0,$iWidth,$iHeight)

	_GDIPlus_GraphicsFillRect($obj_Graphic0,0,0,$iWidth,$iHeight,$cBGColor)
	_GDIPlus_GraphicsDrawRect($obj_Graphic0,0,0,$iWidth,$iHeight,$cFrameColor)
	_GDIPlus_GraphicsDrawStringEx($obj_Graphic0,$sText,$obj_Font,$obj_Layout,$obj_Format,$cFontColor)


	Local $obj_Button = GUICtrlCreatePic($sEmpty,$iLeft,$iTop,$iWidth,$iHeight)

		_WinAPI_DeleteObject(GUICtrlSendMsg($obj_Button,0x0172,0, _GDIPlus_BitmapCreateHBITMAPFromBitmap($obj_Graphic1) ))

	GUICtrlSetResizing($obj_Button,$GUI_DOCKSIZE)


	_GDIPlus_FontDispose($obj_Font)
	_GDIPlus_FontFamilyDispose($obj_Family)
	_GDIPlus_StringFormatDispose($obj_Format)
	_GDIPlus_BrushDispose($cFontColor)
	_GDIPlus_BrushDispose($cBGColor)
	_GDIPlus_PenDispose($cFrameColor)
	_GDIPlus_GraphicsDispose($obj_Graphic0)
	_GDIPlus_BitmapDispose($obj_Graphic1)


	Return $obj_Button

EndFunc