;- https://github.com/crackman2


#Region ;- Resolution List

;- Stores the raw list of resolutions
Local $aResolutionList[0][3]

;- Stores the final, formatted strings to be displayed in the combobox
;  this will also be used to extract width and height to be written into the config
Global $cm2_RL_aResolutionStringList[0]


;- Adding entries manually sucks and is unmaintainable
;  so we don't
Func __cm2_RL_AddEntry($sAspectRatio, $iWidth, $iHeight)
	Local $iSize = UBound($aResolutionList)
	ReDim $aResolutionList[$iSize + 1][3]
	$aResolutionList[$iSize][0] = $sAspectRatio
	$aResolutionList[$iSize][1] = $iWidth
	$aResolutionList[$iSize][2] = $iHeight
EndFunc   ;==>__cm2_RL_AddEntry


; 4:3 Aspect Ratio Resolutions
__cm2_RL_AddEntry("(4:3)",    800,  600)
__cm2_RL_AddEntry("(4:3)",   1024,  768)
__cm2_RL_AddEntry("(4:3)",   1152,  864)
__cm2_RL_AddEntry("(4:3)",   1280,  960)
__cm2_RL_AddEntry("(4:3)",   1400, 1050)
__cm2_RL_AddEntry("(4:3)",   1600, 1200)
__cm2_RL_AddEntry("(4:3)",   2048, 1536)
__cm2_RL_AddEntry("(4:3)",   3200, 2400)

; 16:9 Aspect Ratio Resolutions
__cm2_RL_AddEntry("(16:9)",  1176,  664)
__cm2_RL_AddEntry("(16:9)",  1280,  720)
__cm2_RL_AddEntry("(16:9)",  1360,  768)
__cm2_RL_AddEntry("(16:9)",  1366,  768)
__cm2_RL_AddEntry("(16:9)",  1600,  900)
__cm2_RL_AddEntry("(16:9)",  1920, 1080)
__cm2_RL_AddEntry("(16:9)",  2560, 1440)
__cm2_RL_AddEntry("(16:9)",  3200, 1800)
__cm2_RL_AddEntry("(16:9)",  3840, 2160)
__cm2_RL_AddEntry("(16:9)",  5120, 2880)
__cm2_RL_AddEntry("(16:9)",  7680, 4320)

; 16:10 Aspect Ratio Resolutions
__cm2_RL_AddEntry("(16:10)", 1280,  800)
__cm2_RL_AddEntry("(16:10)", 1440,  900)
__cm2_RL_AddEntry("(16:10)", 1680, 1050)
__cm2_RL_AddEntry("(16:10)", 1920, 1200)
__cm2_RL_AddEntry("(16:10)", 2560, 1600)
__cm2_RL_AddEntry("(16:10)", 3840, 2400)

; 21:9 Aspect Ratio Resolutions
__cm2_RL_AddEntry("(21:9)",  2560, 1080)
__cm2_RL_AddEntry("(21:9)",  3440, 1440)
__cm2_RL_AddEntry("(21:9)",  5120, 2160)

; 21:9 Aspect Ratio Resolutions
__cm2_RL_AddEntry("(32:9)",  3840, 1080)
__cm2_RL_AddEntry("(32:9)",  5120, 1440)


;- To format the final strings to be entered into the array
Func __cm2_RL_Spacer($iAmount)
	Local $sResult = ""
	For $I = 0 To $iAmount
		$sResult &= " "
	Next
	Return $sResult
EndFunc   ;==>__cm2_RL_Spacer


;- After the resolutons are added to the array, we filter the ones that don't fit within desktop resolution and add them to the list that will be displayed in the combobox
Func __cm2_RL_FilterResolutions($iMaxWidth, $iMaxHeight)
	Local $iSize = 1

	For $iIterate = 0 To UBound($aResolutionList) - 1
		If ($aResolutionList[$iIterate][1] <= $iMaxWidth) And ($aResolutionList[$iIterate][2] <= $iMaxHeight) Then
			Local $iSpacerSizeRes = 9 - StringLen($aResolutionList[$iIterate][1] & "x" & $aResolutionList[$iIterate][2])
			Local $iSpacerSizeAsp = 7 - StringLen($aResolutionList[$iIterate][0])

			ReDim $aResolutionStringList[$iSize]
			$aResolutionStringList[$iSize - 1] = $aResolutionList[$iIterate][0] & _
					__cm2_RL_Spacer($iSpacerSizeRes + $iSpacerSizeAsp) & _
					$aResolutionList[$iIterate][1] & "x" & _
					$aResolutionList[$iIterate][2]

			If ($aResolutionList[$iIterate][1] == $iMaxWidth) And ($aResolutionList[$iIterate][2] == $iMaxHeight) Then
				$aResolutionStringList[$iSize - 1] &= " (native)" ;- Native resolution is marked as such
			EndIf
			ConsoleWrite($aResolutionStringList[$iSize - 1] & @CRLF)

			$iSize += 1
		EndIf
	Next
EndFunc   ;==>__cm2_RL_FilterResolutions


;- Extract the actual numbers from strings that may contain "(4:3)" or "(native)"
Func __cm2_RL_ExtractRes(ByRef $sSplitX, ByRef $sSplitY)
	Local $sX
	Local $sY

	For $I = StringLen($sSplitX) To 1 Step -1
		If StringMid($sSplitX, $I, 1) <> ")" Then
			$sX &= StringMid($sSplitX, $I, 1)
		Else
			ExitLoop
		EndIf
	Next
	$sX = StringReverse($sX)

	For $I = 1 To StringLen($sSplitY)
		If StringMid($sSplitY, $I, 1) <> "(" Then
			$sY &= StringMid($sSplitY, $I, 1)
		Else
			ExitLoop
		EndIf
	Next

	$sSplitX = $sX
	$sSplitY = $sY
EndFunc   ;==>__cm2_RL_ExtractRes

#EndRegion