#Include-once
#Include <GDIPlus.au3>

;- Source: https://www.autoitscript.com/forum/topic/202663-gif-animation-cached/
;- Heavily modified and fixed by MeteorTheLizard.

Global $aGIF_Animation[0][18]

_GDIPlus_Startup()


Local Const $__GDIP_PROPERTYTAGFRAMEDELAY = 0x5100

Func _GUICtrlCreateAnimGIF($vSource,$iLeft,$iTop,$iWidth,$iHeight,$iStyle = -1,$iExStyle = -1,$bHandle = False,$vBackGround = 0,$bImage = False,$iCustomDelay = 100)

	If $iStyle = Default Then $iStyle = -1
	If $iExStyle = Default Then $iExStyle = -1
	If $bHandle = Default Then $bHandle = False
	If $vBackGround = Default Then $vBackGround = 0
	If $bImage = Default Then $bImage = False

	Local $iIdx, $idPic, $hImage, $aTime, $iNumberOfFrames, $iType

	If $bHandle Then
		$iType = _GDIPlus_ImageGetType($vSource)

		If @Error Or $iType <> $GDIP_IMAGETYPE_BITMAP Then
			Return SetError(1,0,0)
		EndIf

	ElseIf Not FileExists($vSource) Then
		Return SetError(2,0,0)
	EndIf

	$idPic = GUICtrlCreatePic("",$iLeft,$iTop,$iWidth,$iHeight,$iStyle,$iExStyle)
	If Not $idPic Then Return SetError(3,0,0)

	$hImage = $bHandle ? $vSource : _GDIPlus_ImageLoadFromFile($vSource)
	If @Error Then Return SetError(10 + @Error,0,0)

	$iNumberOfFrames = _GDIPlus_ImageGetFrameCount($hImage,$GDIP_FRAMEDIMENSION_TIME)
	If @Error Then Return SetError(20 + @Error,0,0)

	$aTime = _GDIPlus_ImageGetPropertyItem($hImage,$__GDIP_PROPERTYTAGFRAMEDELAY)
	If @Error Then Return SetError(30 + @Error,0,0)

	If UBound($aTime) - 1 <> $iNumberOfFrames Then
		Return SetError(4,0,0)
	EndIf

	For $i = 0 To UBound($aTime) - 1
		If Not $aTime[$i] Then $aTime[$i] = 5
	Next

	For $iIdx = 0 To UBound($aGIF_Animation) - 1
		If Not $aGIF_Animation[$iIdx][0] Then ExitLoop
	Next


	If $iIdx = UBound($aGIF_Animation) Then
		ReDim $aGIF_Animation[$iIdx + 1][UBound($aGIF_Animation, 2)]
	EndIf

	$aGIF_Animation[$iIdx][1] = $hImage
	$aGIF_Animation[$iIdx][2] = $iNumberOfFrames
	$aGIF_Animation[$iIdx][3] = $aTime
	$aGIF_Animation[$iIdx][4] = 0
	$aGIF_Animation[$iIdx][5] = TimerInit()
	$aGIF_Animation[$iIdx][6] = GUICtrlGetHandle($idPic)
	$aGIF_Animation[$iIdx][7] = _GDIPlus_GraphicsCreateFromHWND($aGIF_Animation[$iIdx][6])
	$aGIF_Animation[$iIdx][8] = $vBackGround
	$aGIF_Animation[$iIdx][9] = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $aGIF_Animation[$iIdx][7])
	$aGIF_Animation[$iIdx][10] = _GDIPlus_ImageGetGraphicsContext($aGIF_Animation[$iIdx][9])
	$aGIF_Animation[$iIdx][11] = $iWidth
	$aGIF_Animation[$iIdx][12] = $iHeight
	$aGIF_Animation[$iIdx][13] = $iLeft
	$aGIF_Animation[$iIdx][14] = $iTop
	$aGIF_Animation[$iIdx][15] = $bImage
	$aGIF_Animation[$iIdx][16] = $iCustomDelay
	$aGIF_Animation[$iIdx][17] = False
	$aGIF_Animation[$iIdx][0] = $idPic


	AdlibRegister(__GIF_Animation_DrawTimer,10)

	Local $Ret[2] = [$idPic, $iIdx]
	Return $Ret

EndFunc

Func _GUICtrlDeleteAnimGIF($idPic)
	For $iIdx = 0 To UBound($aGIF_Animation) - 1
		If $aGIF_Animation[$iIdx][0] = $idPic Then
			$aGIF_Animation[$iIdx][17] = True
			Return 1
		EndIf
	Next

	Return 0
EndFunc


;- Internal

Func __GIF_Animation_DrawTimer()

	For $I = 0 To UBound($aGIF_Animation) - 1
		If $aGIF_Animation[$I][17] Then
			$aGIF_Animation[$I][0] = False
			$aGIF_Animation[$I][17] = False

			_GDIPlus_ImageDispose($aGIF_Animation[$I][1])
			_GDIPlus_GraphicsDispose($aGIF_Animation[$I][7])
			_GDIPlus_GraphicsDispose($aGIF_Animation[$I][10])
			_GDIPlus_BitmapDispose($aGIF_Animation[$I][9])

			GUICtrlDelete($aGIF_Animation[$I][0])
		EndIf
	Next


	Local $aTime

	For $i = 0 To UBound($aGIF_Animation) - 1
		If Not $aGIF_Animation[$i][0] Then ContinueLoop

			$aTime = $aGIF_Animation[$i][3]

		If (TimerDiff($aGIF_Animation[$i][5]) >= $aGIF_Animation[$i][16]) Or (TimerDiff($aGIF_Animation[$i][5]) >= $aTime[$aGIF_Animation[$i][4] + 1] * 10) Then
			__GIF_Animation_DrawFrame($i)
			$aGIF_Animation[$i][4] += 1

			If $aGIF_Animation[$i][4] = $aGIF_Animation[$i][2] Then
				$aGIF_Animation[$i][4] = 0
			EndIf

			$aGIF_Animation[$i][5] = TimerInit()

		EndIf
	Next

EndFunc

Func __GIF_Animation_DrawFrame($iGIF)

	_GDIPlus_ImageSelectActiveFrame($aGIF_Animation[$iGIF][1],$GDIP_FRAMEDIMENSION_TIME,$aGIF_Animation[$iGIF][4])

	Local $hCachedBmp = __GDIPlus_CachedBitmapCreate($aGIF_Animation[$iGIF][10],$aGIF_Animation[$iGIF][1])

	If $aGIF_Animation[$iGIF][8] Then
		If $aGIF_Animation[$iGIF][15] Then
			_GDIPlus_GraphicsDrawImageRectRect($aGIF_Animation[$iGIF][10],$aGIF_Animation[$iGIF][8],$aGIF_Animation[$iGIF][13],$aGIF_Animation[$iGIF][14], _
			$aGIF_Animation[$iGIF][11],$aGIF_Animation[$iGIF][12],0,0,$aGIF_Animation[$iGIF][11],$aGIF_Animation[$iGIF][12])
		Else
			_GDIPlus_GraphicsClear($aGIF_Animation[$iGIF][10],BitOR(0xFF000000,$aGIF_Animation[$iGIF][8]))
		EndIf
	EndIf

	__GDIPlus_GraphicsDrawCachedBitmap($aGIF_Animation[$iGIF][10],$hCachedBmp,0,0)
	_GDIPlus_GraphicsDrawImageRect($aGIF_Animation[$iGIF][7],$aGIF_Animation[$iGIF][9],0,0,$aGIF_Animation[$iGIF][11],$aGIF_Animation[$iGIF][12])
	__GDIPlus_CachedBitmapDispose($hCachedBmp)

EndFunc

Func __GDIPlus_GraphicsDrawCachedBitmap($hGraphics, $hCachedBitmap, $iX, $iY)
	Local $aResult = DllCall($__g_hGDIPDll,"int","GdipDrawCachedBitmap","handle",$hGraphics,"handle",$hCachedBitmap,"int",$iX,"int",$iY)
	If @Error Then Return SetError(@Error,@Extended,False)
	If $aResult[0] Then Return SetError(10,$aResult[0],False)
	Return True
EndFunc

Func __GDIPlus_CachedBitmapCreate($hGraphics, $hBitmap)
	Local $aResult = DllCall($__g_hGDIPDll,"int","GdipCreateCachedBitmap","handle",$hBitmap,"handle",$hGraphics,"handle*",0)
	If @Error Then Return SetError(@Error,@Extended,0)
	If $aResult[0] Then Return SetError(10,$aResult[0],0)
	Return $aResult[3]
EndFunc

Func __GDIPlus_CachedBitmapDispose($hCachedBitmap)
	Local $aResult = DllCall($__g_hGDIPDll,"int","GdipDeleteCachedBitmap","handle",$hCachedBitmap)
	If @Error Then Return SetError(@Error,@Extended,False)
	If $aResult[0] Then Return SetError(10,$aResult[0],False)
	Return True
EndFunc