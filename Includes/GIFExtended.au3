;- This script is part of the SMITE Optimizer, which is licensed under the GNU General Public License v3.0.
;- Certain conditions apply for using this script in your work. Read the license linked below.
;- https://github.com/MeteorTheLizard/SMITE-Optimizer/blob/master/LICENSE
;- Made by MeteorTheLizard (C) 2023.


#Include-once
#Include <GDIPlus.au3>


OnAutoItExitRegister("__GIFExtended_ShutDown")

Func __GIFExtended_ShutDown()
	AdlibUnRegister(__GIFExtended_Internal_Draw)
	_GDIPlus_Shutdown()
EndFunc


Local $iArraySize = 15
Global $__g_GIFExtended_aStoreCache[0][$iArraySize]

Local $bGDIStarted = False
Local $iLastIndex = 0


Func GUICtrlCreateGIF($obj_Source,$iLeft,$iTop,$iWidth,$iHeight,$iFrameCount,$iDelay,$bResource = False)

	If Not $bGDIStarted Then
		$bGDIStarted = True

		_GDIPlus_Startup()
	EndIf


	ReDim $__g_GIFExtended_aStoreCache[$iLastIndex + 1][$iArraySize]

	$__g_GIFExtended_aStoreCache[$iLastIndex][0] = $iLeft
	$__g_GIFExtended_aStoreCache[$iLastIndex][1] = $iTop
	$__g_GIFExtended_aStoreCache[$iLastIndex][2] = $iWidth
	$__g_GIFExtended_aStoreCache[$iLastIndex][3] = $iHeight
	$__g_GIFExtended_aStoreCache[$iLastIndex][4] = $iFrameCount
	$__g_GIFExtended_aStoreCache[$iLastIndex][5] = $iDelay
	$__g_GIFExtended_aStoreCache[$iLastIndex][6] = $bResource
	$__g_GIFExtended_aStoreCache[$iLastIndex][7] = False


	Local $ctrlDummy = GUICtrlCreatePic($sEmpty,$iLeft,$iTop,$iWidth,$iHeight)

	Local $obj_Image = $bResource ? $obj_Source : _GDIPlus_ImageLoadFromFile($obj_Source)
	$__g_GIFExtended_aStoreCache[$iLastIndex][8] = $obj_Image

	$__g_GIFExtended_aStoreCache[$iLastIndex][9] = _GDIPlus_GraphicsCreateFromHWND(GUICtrlGetHandle($ctrlDummy))
	$__g_GIFExtended_aStoreCache[$iLastIndex][10] = _GDIPlus_BitmapCreateFromGraphics($iWidth,$iHeight,$__g_GIFExtended_aStoreCache[$iLastIndex][9])
	$__g_GIFExtended_aStoreCache[$iLastIndex][11] = _GDIPlus_ImageGetGraphicsContext($__g_GIFExtended_aStoreCache[$iLastIndex][10])
	$__g_GIFExtended_aStoreCache[$iLastIndex][12] = $ctrlDummy
	$__g_GIFExtended_aStoreCache[$iLastIndex][13] = 0
	$__g_GIFExtended_aStoreCache[$iLastIndex][14] = TimerInit()


	AdlibRegister(__GIFExtended_Internal_Draw,10)


	Local $Ret[2] = [$ctrlDummy,$iLastIndex]

		$iLastIndex = $iLastIndex + 1

	Return $Ret

EndFunc


Func GUICtrlDeleteGIF($ctrl)
	For $I = 0 To $iLastIndex - 1 Step 1
		If $__g_GIFExtended_aStoreCache[$I][12] = $ctrl Then
			$__g_GIFExtended_aStoreCache[$I][7] = True
			ExitLoop
		EndIf
	Next
EndFunc


Func __GIFExtended_Internal_Draw()


	For $I = 0 To $iLastIndex - 1 Step 1
		If $__g_GIFExtended_aStoreCache[$I][7] Then ;- Leak. Array is not being cleared.
			$__g_GIFExtended_aStoreCache[$I][7] = False

			_GDIPlus_ImageDispose($__g_GIFExtended_aStoreCache[$I][8])
			_GDIPlus_GraphicsDispose($__g_GIFExtended_aStoreCache[$I][9])
			_GDIPlus_GraphicsDispose($__g_GIFExtended_aStoreCache[$I][11])
			_GDIPlus_BitmapDispose($__g_GIFExtended_aStoreCache[$I][10])

			GUICtrlDelete($__g_GIFExtended_aStoreCache[$I][12])


			For $B = 0 To $iArraySize - 1 Step 1
				If $B = 7 Then ContinueLoop

				$__g_GIFExtended_aStoreCache[$I][$B] = NULL
			Next


			$__g_GIFExtended_aStoreCache[$I][12] = False

		EndIf
	Next


	For $I = 0 To $iLastIndex - 1 Step 1
		If $__g_GIFExtended_aStoreCache[$I][12] = False Then ContinueLoop


		If TimerDiff($__g_GIFExtended_aStoreCache[$I][14]) >= $__g_GIFExtended_aStoreCache[$I][5] Then

			_GDIPlus_ImageSelectActiveFrame($__g_GIFExtended_aStoreCache[$I][8],$GDIP_FRAMEDIMENSION_TIME,$__g_GIFExtended_aStoreCache[$I][13])
			_GDIPlus_GraphicsDrawImageRect($__g_GIFExtended_aStoreCache[$I][9],$__g_GIFExtended_aStoreCache[$I][8],0,0,$__g_GIFExtended_aStoreCache[$I][2],$__g_GIFExtended_aStoreCache[$I][3])


			$__g_GIFExtended_aStoreCache[$I][13] = $__g_GIFExtended_aStoreCache[$I][13] + 1

			If $__g_GIFExtended_aStoreCache[$I][13] > $__g_GIFExtended_aStoreCache[$I][4] Then
				$__g_GIFExtended_aStoreCache[$I][13] = 1
			EndIf


			$__g_GIFExtended_aStoreCache[$I][14] = TimerInit()

		EndIf
	Next

EndFunc