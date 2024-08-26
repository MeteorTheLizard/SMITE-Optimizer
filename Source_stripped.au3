#NoTrayIcon
If _SingleTon("SMITE_Optimizer",1) = 0 Then
Local $WinList = WinList()
For $I = 0 To uBound($WinList) - 1 Step 1
If StringLeft($WinList[$I][0],17) = "SMITE Optimizer (" Then
WinActivate($WinList[$I][0])
ExitLoop
EndIf
Next
Exit
EndIf
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $HWND_NOTOPMOST = -2
Global Const $HWND_TOP = 0
Global Const $HWND_TOPMOST = -1
Global Const $SWP_NOSIZE = 0x0001
Global Const $SWP_NOMOVE = 0x0002
Global Const $SWP_NOREDRAW = 0x0008
Global Const $SWP_NOACTIVATE = 0x0010
Global Const $DIR_REMOVE = 1
Global Const $NUMBER_DOUBLE = 3
Global Const $MB_OK = 0
Global Const $MB_YESNO = 4
Global Const $IDYES = 6
Global Const $STR_NOCASESENSEBASIC = 2
Global Const $STR_STRIPLEADING = 1
Global Const $STR_STRIPTRAILING = 2
Global Const $STR_STRIPALL = 8
Global Const $STR_CHRSPLIT = 0
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Const $STR_REGEXPARRAYGLOBALMATCH = 3
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, $ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
Global Enum $ARRAYUNIQUE_NOCOUNT, $ARRAYUNIQUE_COUNT
Global Enum $ARRAYUNIQUE_AUTO, $ARRAYUNIQUE_FORCE32, $ARRAYUNIQUE_FORCE64, $ARRAYUNIQUE_MATCH, $ARRAYUNIQUE_DISTINCT
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
If $iStart = Default Then $iStart = 0
If $sDelim_Item = Default Then $sDelim_Item = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
Local $hDataType = 0
Switch $iForce
Case $ARRAYFILL_FORCE_INT
$hDataType = Int
Case $ARRAYFILL_FORCE_NUMBER
$hDataType = Number
Case $ARRAYFILL_FORCE_PTR
$hDataType = Ptr
Case $ARRAYFILL_FORCE_HWND
$hDataType = Hwnd
Case $ARRAYFILL_FORCE_STRING
$hDataType = String
Case $ARRAYFILL_FORCE_BOOLEAN
$hDataType = "Boolean"
EndSwitch
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
ReDim $aArray[$iDim_1 + 1]
$aArray[$iDim_1] = $vValue
Return $iDim_1
EndIf
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
$hDataType = 0
Else
Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
If UBound($aTmp, $UBOUND_ROWS) = 1 Then
$aTmp[0] = $vValue
EndIf
$vValue = $aTmp
EndIf
Local $iAdd = UBound($vValue, $UBOUND_ROWS)
ReDim $aArray[$iDim_1 + $iAdd]
For $i = 0 To $iAdd - 1
If String($hDataType) = "Boolean" Then
Switch $vValue[$i]
Case "True", "1"
$aArray[$iDim_1 + $i] = True
Case "False", "0", ""
$aArray[$iDim_1 + $i] = False
EndSwitch
ElseIf IsFunc($hDataType) Then
$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
Else
$aArray[$iDim_1 + $i] = $vValue[$i]
EndIf
Next
Return $iDim_1 + $iAdd - 1
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
Local $iValDim_1, $iValDim_2 = 0, $iColCount
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
$hDataType = 0
Else
Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
Local $aTmp[$iValDim_1][0], $aSplit_2
For $i = 0 To $iValDim_1 - 1
$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iColCount = UBound($aSplit_2)
If $iColCount > $iValDim_2 Then
$iValDim_2 = $iColCount
ReDim $aTmp[$iValDim_1][$iValDim_2]
EndIf
For $j = 0 To $iColCount - 1
$aTmp[$i][$j] = $aSplit_2[$j]
Next
Next
$vValue = $aTmp
EndIf
If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
For $iWriteTo_Index = 0 To $iValDim_1 - 1
For $j = 0 To $iDim_2 - 1
If $j < $iStart Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
ElseIf $j - $iStart > $iValDim_2 - 1 Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
Else
If String($hDataType) = "Boolean" Then
Switch $vValue[$iWriteTo_Index][$j - $iStart]
Case "True", "1"
$aArray[$iWriteTo_Index + $iDim_1][$j] = True
Case "False", "0", ""
$aArray[$iWriteTo_Index + $iDim_1][$j] = False
EndSwitch
ElseIf IsFunc($hDataType) Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
Else
$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
EndIf
EndIf
Next
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS) - 1
EndFunc
Func _ArrayConcatenate(ByRef $aArrayTarget, Const ByRef $aArraySource, $iStart = 0)
If $iStart = Default Then $iStart = 0
If Not IsArray($aArrayTarget) Then Return SetError(1, 0, -1)
If Not IsArray($aArraySource) Then Return SetError(2, 0, -1)
Local $iDim_Total_Tgt = UBound($aArrayTarget, $UBOUND_DIMENSIONS)
Local $iDim_Total_Src = UBound($aArraySource, $UBOUND_DIMENSIONS)
Local $iDim_1_Tgt = UBound($aArrayTarget, $UBOUND_ROWS)
Local $iDim_1_Src = UBound($aArraySource, $UBOUND_ROWS)
If $iStart < 0 Or $iStart > $iDim_1_Src - 1 Then Return SetError(6, 0, -1)
Switch $iDim_Total_Tgt
Case 1
If $iDim_Total_Src <> 1 Then Return SetError(4, 0, -1)
ReDim $aArrayTarget[$iDim_1_Tgt + $iDim_1_Src - $iStart]
For $i = $iStart To $iDim_1_Src - 1
$aArrayTarget[$iDim_1_Tgt + $i - $iStart] = $aArraySource[$i]
Next
Case 2
If $iDim_Total_Src <> 2 Then Return SetError(4, 0, -1)
Local $iDim_2_Tgt = UBound($aArrayTarget, $UBOUND_COLUMNS)
If UBound($aArraySource, $UBOUND_COLUMNS) <> $iDim_2_Tgt Then Return SetError(5, 0, -1)
ReDim $aArrayTarget[$iDim_1_Tgt + $iDim_1_Src - $iStart][$iDim_2_Tgt]
For $i = $iStart To $iDim_1_Src - 1
For $j = 0 To $iDim_2_Tgt - 1
$aArrayTarget[$iDim_1_Tgt + $i - $iStart][$j] = $aArraySource[$i][$j]
Next
Next
Case Else
Return SetError(3, 0, -1)
EndSwitch
Return UBound($aArrayTarget, $UBOUND_ROWS)
EndFunc
Func _ArrayDelete(ByRef $aArray, $vRange)
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
If IsArray($vRange) Then
If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
Else
Local $iNumber, $aSplit_1, $aSplit_2
$vRange = StringStripWS($vRange, 8)
$aSplit_1 = StringSplit($vRange, ";")
$vRange = ""
For $i = 1 To $aSplit_1[0]
If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
$aSplit_2 = StringSplit($aSplit_1[$i], "-")
Switch $aSplit_2[0]
Case 1
$vRange &= $aSplit_2[1] & ";"
Case 2
If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
$iNumber = $aSplit_2[1] - 1
Do
$iNumber += 1
$vRange &= $iNumber & ";"
Until $iNumber = $aSplit_2[2]
EndIf
EndSwitch
Next
$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
EndIf
For $i = 1 To $vRange[0]
$vRange[$i] = Number($vRange[$i])
Next
If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
Local $iCopyTo_Index = 0
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
For $i = 1 To $vRange[0]
$aArray[$vRange[$i]] = ChrW(0xFAB1)
Next
For $iReadFrom_Index = 0 To $iDim_1
If $aArray[$iReadFrom_Index] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $iReadFrom_Index <> $iCopyTo_Index Then
$aArray[$iCopyTo_Index] = $aArray[$iReadFrom_Index]
EndIf
$iCopyTo_Index += 1
EndIf
Next
ReDim $aArray[$iDim_1 - $vRange[0] + 1]
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
For $i = 1 To $vRange[0]
$aArray[$vRange[$i]][0] = ChrW(0xFAB1)
Next
For $iReadFrom_Index = 0 To $iDim_1
If $aArray[$iReadFrom_Index][0] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $iReadFrom_Index <> $iCopyTo_Index Then
For $j = 0 To $iDim_2
$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFrom_Index][$j]
Next
EndIf
$iCopyTo_Index += 1
EndIf
Next
ReDim $aArray[$iDim_1 - $vRange[0] + 1][$iDim_2 + 1]
Case Else
Return SetError(2, 0, False)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS)
EndFunc
Func _ArrayInsert(ByRef $aArray, $vRange, $vValue = "", $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
If $vValue = Default Then $vValue = ""
If $iStart = Default Then $iStart = 0
If $sDelim_Item = Default Then $sDelim_Item = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
Local $hDataType = 0
Switch $iForce
Case $ARRAYFILL_FORCE_INT
$hDataType = Int
Case $ARRAYFILL_FORCE_NUMBER
$hDataType = Number
Case $ARRAYFILL_FORCE_PTR
$hDataType = Ptr
Case $ARRAYFILL_FORCE_HWND
$hDataType = Hwnd
Case $ARRAYFILL_FORCE_STRING
$hDataType = String
EndSwitch
Local $aSplit_1, $aSplit_2
If IsArray($vRange) Then
If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
Else
Local $iNumber
$vRange = StringStripWS($vRange, 8)
$aSplit_1 = StringSplit($vRange, ";")
$vRange = ""
For $i = 1 To $aSplit_1[0]
If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
$aSplit_2 = StringSplit($aSplit_1[$i], "-")
Switch $aSplit_2[0]
Case 1
$vRange &= $aSplit_2[1] & ";"
Case 2
If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
$iNumber = $aSplit_2[1] - 1
Do
$iNumber += 1
$vRange &= $iNumber & ";"
Until $iNumber = $aSplit_2[2]
EndIf
EndSwitch
Next
$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
EndIf
For $i = 1 To $vRange[0]
$vRange[$i] = Number($vRange[$i])
Next
If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
For $i = 2 To $vRange[0]
If $vRange[$i] < $vRange[$i - 1] Then Return SetError(3, 0, -1)
Next
Local $iCopyTo_Index = $iDim_1 + $vRange[0]
Local $iInsertPoint_Index = $vRange[0]
Local $iInsert_Index = $vRange[$iInsertPoint_Index]
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
ReDim $aArray[$iDim_1 + $vRange[0] + 1]
For $iReadFromIndex = $iDim_1 To 0 Step -1
$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
$iCopyTo_Index -= 1
$iInsert_Index = $vRange[$iInsertPoint_Index]
While $iReadFromIndex = $iInsert_Index
$aArray[$iCopyTo_Index] = $vValue
$iCopyTo_Index -= 1
$iInsertPoint_Index -= 1
If $iInsertPoint_Index < 1 Then ExitLoop 2
$iInsert_Index = $vRange[$iInsertPoint_Index]
WEnd
Next
Return $iDim_1 + $vRange[0] + 1
EndIf
ReDim $aArray[$iDim_1 + $vRange[0] + 1]
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
$hDataType = 0
Else
Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
If UBound($aTmp, $UBOUND_ROWS) = 1 Then
$aTmp[0] = $vValue
$hDataType = 0
EndIf
$vValue = $aTmp
EndIf
For $iReadFromIndex = $iDim_1 To 0 Step -1
$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
$iCopyTo_Index -= 1
$iInsert_Index = $vRange[$iInsertPoint_Index]
While $iReadFromIndex = $iInsert_Index
If $iInsertPoint_Index <= UBound($vValue, $UBOUND_ROWS) Then
If IsFunc($hDataType) Then
$aArray[$iCopyTo_Index] = $hDataType($vValue[$iInsertPoint_Index - 1])
Else
$aArray[$iCopyTo_Index] = $vValue[$iInsertPoint_Index - 1]
EndIf
Else
$aArray[$iCopyTo_Index] = ""
EndIf
$iCopyTo_Index -= 1
$iInsertPoint_Index -= 1
If $iInsertPoint_Index = 0 Then ExitLoop 2
$iInsert_Index = $vRange[$iInsertPoint_Index]
WEnd
Next
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(6, 0, -1)
Local $iValDim_1, $iValDim_2
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(7, 0, -1)
$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
$hDataType = 0
Else
$aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
StringReplace($aSplit_1[0], $sDelim_Item, "")
$iValDim_2 = @extended + 1
Local $aTmp[$iValDim_1][$iValDim_2]
For $i = 0 To $iValDim_1 - 1
$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
For $j = 0 To $iValDim_2 - 1
$aTmp[$i][$j] = $aSplit_2[$j]
Next
Next
$vValue = $aTmp
EndIf
If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(8, 0, -1)
ReDim $aArray[$iDim_1 + $vRange[0] + 1][$iDim_2]
For $iReadFromIndex = $iDim_1 To 0 Step -1
For $j = 0 To $iDim_2 - 1
$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFromIndex][$j]
Next
$iCopyTo_Index -= 1
$iInsert_Index = $vRange[$iInsertPoint_Index]
While $iReadFromIndex = $iInsert_Index
For $j = 0 To $iDim_2 - 1
If $j < $iStart Then
$aArray[$iCopyTo_Index][$j] = ""
ElseIf $j - $iStart > $iValDim_2 - 1 Then
$aArray[$iCopyTo_Index][$j] = ""
Else
If $iInsertPoint_Index - 1 < $iValDim_1 Then
If IsFunc($hDataType) Then
$aArray[$iCopyTo_Index][$j] = $hDataType($vValue[$iInsertPoint_Index - 1][$j - $iStart])
Else
$aArray[$iCopyTo_Index][$j] = $vValue[$iInsertPoint_Index - 1][$j - $iStart]
EndIf
Else
$aArray[$iCopyTo_Index][$j] = ""
EndIf
EndIf
Next
$iCopyTo_Index -= 1
$iInsertPoint_Index -= 1
If $iInsertPoint_Index = 0 Then ExitLoop 2
$iInsert_Index = $vRange[$iInsertPoint_Index]
WEnd
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS)
EndFunc
Func _ArrayReverse(ByRef $aArray, $iStart = 0, $iEnd = 0)
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If Not IsArray($aArray) Then Return SetError(1, 0, 0)
If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
If Not UBound($aArray) Then Return SetError(4, 0, 0)
Local $vTmp, $iUBound = UBound($aArray) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
$vTmp = $aArray[$i]
$aArray[$i] = $aArray[$iEnd]
$aArray[$iEnd] = $vTmp
$iEnd -= 1
Next
Return 1
EndFunc
Func _ArraySort(ByRef $aArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0, $iPivot = 0)
If $iDescending = Default Then $iDescending = 0
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If $iSubItem = Default Then $iSubItem = 0
If $iPivot = Default Then $iPivot = 0
If Not IsArray($aArray) Then Return SetError(1, 0, 0)
Local $iUBound = UBound($aArray) - 1
If $iUBound = -1 Then Return SetError(5, 0, 0)
If $iEnd = Default Then $iEnd = 0
If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
If $iStart < 0 Or $iStart = Default Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iPivot Then
__ArrayDualPivotSort($aArray, $iStart, $iEnd)
Else
__ArrayQuickSort1D($aArray, $iStart, $iEnd)
EndIf
If $iDescending Then _ArrayReverse($aArray, $iStart, $iEnd)
Case 2
If $iPivot Then Return SetError(6, 0, 0)
Local $iSubMax = UBound($aArray, $UBOUND_COLUMNS) - 1
If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)
If $iDescending Then
$iDescending = -1
Else
$iDescending = 1
EndIf
__ArrayQuickSort2D($aArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
Case Else
Return SetError(4, 0, 0)
EndSwitch
Return 1
EndFunc
Func __ArrayQuickSort1D(ByRef $aArray, Const ByRef $iStart, Const ByRef $iEnd)
If $iEnd <= $iStart Then Return
Local $vTmp
If($iEnd - $iStart) < 15 Then
Local $vCur
For $i = $iStart + 1 To $iEnd
$vTmp = $aArray[$i]
If IsNumber($vTmp) Then
For $j = $i - 1 To $iStart Step -1
$vCur = $aArray[$j]
If($vTmp >= $vCur And IsNumber($vCur)) Or(Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
$aArray[$j + 1] = $vCur
Next
Else
For $j = $i - 1 To $iStart Step -1
If(StringCompare($vTmp, $aArray[$j]) >= 0) Then ExitLoop
$aArray[$j + 1] = $aArray[$j]
Next
EndIf
$aArray[$j + 1] = $vTmp
Next
Return
EndIf
Local $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)], $bNum = IsNumber($vPivot)
Do
If $bNum Then
While($aArray[$L] < $vPivot And IsNumber($aArray[$L])) Or(Not IsNumber($aArray[$L]) And StringCompare($aArray[$L], $vPivot) < 0)
$L += 1
WEnd
While($aArray[$R] > $vPivot And IsNumber($aArray[$R])) Or(Not IsNumber($aArray[$R]) And StringCompare($aArray[$R], $vPivot) > 0)
$R -= 1
WEnd
Else
While(StringCompare($aArray[$L], $vPivot) < 0)
$L += 1
WEnd
While(StringCompare($aArray[$R], $vPivot) > 0)
$R -= 1
WEnd
EndIf
If $L <= $R Then
$vTmp = $aArray[$L]
$aArray[$L] = $aArray[$R]
$aArray[$R] = $vTmp
$L += 1
$R -= 1
EndIf
Until $L > $R
__ArrayQuickSort1D($aArray, $iStart, $R)
__ArrayQuickSort1D($aArray, $L, $iEnd)
EndFunc
Func __ArrayQuickSort2D(ByRef $aArray, Const ByRef $iStep, Const ByRef $iStart, Const ByRef $iEnd, Const ByRef $iSubItem, Const ByRef $iSubMax)
If $iEnd <= $iStart Then Return
Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $bNum = IsNumber($vPivot)
Do
If $bNum Then
While($iStep *($aArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($aArray[$L][$iSubItem])) Or(Not IsNumber($aArray[$L][$iSubItem]) And $iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
$L += 1
WEnd
While($iStep *($aArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($aArray[$R][$iSubItem])) Or(Not IsNumber($aArray[$R][$iSubItem]) And $iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
$R -= 1
WEnd
Else
While($iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
$L += 1
WEnd
While($iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
$R -= 1
WEnd
EndIf
If $L <= $R Then
For $i = 0 To $iSubMax
$vTmp = $aArray[$L][$i]
$aArray[$L][$i] = $aArray[$R][$i]
$aArray[$R][$i] = $vTmp
Next
$L += 1
$R -= 1
EndIf
Until $L > $R
__ArrayQuickSort2D($aArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
__ArrayQuickSort2D($aArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc
Func __ArrayDualPivotSort(ByRef $aArray, $iPivot_Left, $iPivot_Right, $bLeftMost = True)
If $iPivot_Left > $iPivot_Right Then Return
Local $iLength = $iPivot_Right - $iPivot_Left + 1
Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
If $iLength < 45 Then
If $bLeftMost Then
$i = $iPivot_Left
While $i < $iPivot_Right
$j = $i
$iAi = $aArray[$i + 1]
While $iAi < $aArray[$j]
$aArray[$j + 1] = $aArray[$j]
$j -= 1
If $j + 1 = $iPivot_Left Then ExitLoop
WEnd
$aArray[$j + 1] = $iAi
$i += 1
WEnd
Else
While 1
If $iPivot_Left >= $iPivot_Right Then Return 1
$iPivot_Left += 1
If $aArray[$iPivot_Left] < $aArray[$iPivot_Left - 1] Then ExitLoop
WEnd
While 1
$k = $iPivot_Left
$iPivot_Left += 1
If $iPivot_Left > $iPivot_Right Then ExitLoop
$iA1 = $aArray[$k]
$iA2 = $aArray[$iPivot_Left]
If $iA1 < $iA2 Then
$iA2 = $iA1
$iA1 = $aArray[$iPivot_Left]
EndIf
$k -= 1
While $iA1 < $aArray[$k]
$aArray[$k + 2] = $aArray[$k]
$k -= 1
WEnd
$aArray[$k + 2] = $iA1
While $iA2 < $aArray[$k]
$aArray[$k + 1] = $aArray[$k]
$k -= 1
WEnd
$aArray[$k + 1] = $iA2
$iPivot_Left += 1
WEnd
$iLast = $aArray[$iPivot_Right]
$iPivot_Right -= 1
While $iLast < $aArray[$iPivot_Right]
$aArray[$iPivot_Right + 1] = $aArray[$iPivot_Right]
$iPivot_Right -= 1
WEnd
$aArray[$iPivot_Right + 1] = $iLast
EndIf
Return 1
EndIf
Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
$iE3 = Ceiling(($iPivot_Left + $iPivot_Right) / 2)
$iE2 = $iE3 - $iSeventh
$iE1 = $iE2 - $iSeventh
$iE4 = $iE3 + $iSeventh
$iE5 = $iE4 + $iSeventh
If $aArray[$iE2] < $aArray[$iE1] Then
$t = $aArray[$iE2]
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
If $aArray[$iE3] < $aArray[$iE2] Then
$t = $aArray[$iE3]
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
If $aArray[$iE4] < $aArray[$iE3] Then
$t = $aArray[$iE4]
$aArray[$iE4] = $aArray[$iE3]
$aArray[$iE3] = $t
If $t < $aArray[$iE2] Then
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
EndIf
If $aArray[$iE5] < $aArray[$iE4] Then
$t = $aArray[$iE5]
$aArray[$iE5] = $aArray[$iE4]
$aArray[$iE4] = $t
If $t < $aArray[$iE3] Then
$aArray[$iE4] = $aArray[$iE3]
$aArray[$iE3] = $t
If $t < $aArray[$iE2] Then
$aArray[$iE3] = $aArray[$iE2]
$aArray[$iE2] = $t
If $t < $aArray[$iE1] Then
$aArray[$iE2] = $aArray[$iE1]
$aArray[$iE1] = $t
EndIf
EndIf
EndIf
EndIf
Local $iLess = $iPivot_Left
Local $iGreater = $iPivot_Right
If(($aArray[$iE1] <> $aArray[$iE2]) And($aArray[$iE2] <> $aArray[$iE3]) And($aArray[$iE3] <> $aArray[$iE4]) And($aArray[$iE4] <> $aArray[$iE5])) Then
Local $iPivot_1 = $aArray[$iE2]
Local $iPivot_2 = $aArray[$iE4]
$aArray[$iE2] = $aArray[$iPivot_Left]
$aArray[$iE4] = $aArray[$iPivot_Right]
Do
$iLess += 1
Until $aArray[$iLess] >= $iPivot_1
Do
$iGreater -= 1
Until $aArray[$iGreater] <= $iPivot_2
$k = $iLess
While $k <= $iGreater
$iAk = $aArray[$k]
If $iAk < $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
ElseIf $iAk > $iPivot_2 Then
While $aArray[$iGreater] > $iPivot_2
$iGreater -= 1
If $iGreater + 1 = $k Then ExitLoop 2
WEnd
If $aArray[$iGreater] < $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $aArray[$iGreater]
$iLess += 1
Else
$aArray[$k] = $aArray[$iGreater]
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
$aArray[$iPivot_Left] = $aArray[$iLess - 1]
$aArray[$iLess - 1] = $iPivot_1
$aArray[$iPivot_Right] = $aArray[$iGreater + 1]
$aArray[$iGreater + 1] = $iPivot_2
__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 2, True)
__ArrayDualPivotSort($aArray, $iGreater + 2, $iPivot_Right, False)
If($iLess < $iE1) And($iE5 < $iGreater) Then
While $aArray[$iLess] = $iPivot_1
$iLess += 1
WEnd
While $aArray[$iGreater] = $iPivot_2
$iGreater -= 1
WEnd
$k = $iLess
While $k <= $iGreater
$iAk = $aArray[$k]
If $iAk = $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
ElseIf $iAk = $iPivot_2 Then
While $aArray[$iGreater] = $iPivot_2
$iGreater -= 1
If $iGreater + 1 = $k Then ExitLoop 2
WEnd
If $aArray[$iGreater] = $iPivot_1 Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iPivot_1
$iLess += 1
Else
$aArray[$k] = $aArray[$iGreater]
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
EndIf
__ArrayDualPivotSort($aArray, $iLess, $iGreater, False)
Else
Local $iPivot = $aArray[$iE3]
$k = $iLess
While $k <= $iGreater
If $aArray[$k] = $iPivot Then
$k += 1
ContinueLoop
EndIf
$iAk = $aArray[$k]
If $iAk < $iPivot Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $iAk
$iLess += 1
Else
While $aArray[$iGreater] > $iPivot
$iGreater -= 1
WEnd
If $aArray[$iGreater] < $iPivot Then
$aArray[$k] = $aArray[$iLess]
$aArray[$iLess] = $aArray[$iGreater]
$iLess += 1
Else
$aArray[$k] = $iPivot
EndIf
$aArray[$iGreater] = $iAk
$iGreater -= 1
EndIf
$k += 1
WEnd
__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 1, True)
__ArrayDualPivotSort($aArray, $iGreater + 1, $iPivot_Right, False)
EndIf
EndFunc
Func _ArrayUnique(Const ByRef $aArray, $iColumn = 0, $iBase = 0, $iCase = 0, $iCount = $ARRAYUNIQUE_COUNT, $iIntType = $ARRAYUNIQUE_AUTO)
If $iColumn = Default Then $iColumn = 0
If $iBase = Default Then $iBase = 0
If $iCase = Default Then $iCase = 0
If $iCount = Default Then $iCount = $ARRAYUNIQUE_COUNT
If $iIntType = Default Then $iIntType = $ARRAYUNIQUE_AUTO
If UBound($aArray, $UBOUND_ROWS) = 0 Then Return SetError(1, 0, 0)
Local $iDims = UBound($aArray, $UBOUND_DIMENSIONS), $iNumColumns = UBound($aArray, $UBOUND_COLUMNS)
If $iDims > 2 Then Return SetError(2, 0, 0)
If $iBase < 0 Or $iBase > 1 Or(Not IsInt($iBase)) Then Return SetError(3, 0, 0)
If $iCase < 0 Or $iCase > 1 Or(Not IsInt($iCase)) Then Return SetError(3, 0, 0)
If $iCount < 0 Or $iCount > 1 Or(Not IsInt($iCount)) Then Return SetError(4, 0, 0)
If $iIntType < 0 Or $iIntType > 4 Or(Not IsInt($iIntType)) Then Return SetError(5, 0, 0)
If $iColumn < 0 Or($iNumColumns = 0 And $iColumn > 0) Or($iNumColumns > 0 And $iColumn >= $iNumColumns) Then Return SetError(6, 0, 0)
If $iIntType = $ARRAYUNIQUE_AUTO Then
Local $bInt, $sVarType
If $iDims = 1 Then
$bInt = IsInt($aArray[$iBase])
$sVarType = VarGetType($aArray[$iBase])
Else
$bInt = IsInt($aArray[$iBase][$iColumn])
$sVarType = VarGetType($aArray[$iBase][$iColumn])
EndIf
If $bInt And $sVarType = "Int64" Then
$iIntType = $ARRAYUNIQUE_FORCE64
Else
$iIntType = $ARRAYUNIQUE_FORCE32
EndIf
EndIf
ObjEvent("AutoIt.Error", __ArrayUnique_AutoErrFunc)
Local $oDictionary = ObjCreate("Scripting.Dictionary")
$oDictionary.CompareMode = Number(Not $iCase)
Local $vElem, $sType, $vKey, $bCOMError = False
For $i = $iBase To UBound($aArray) - 1
If $iDims = 1 Then
$vElem = $aArray[$i]
Else
$vElem = $aArray[$i][$iColumn]
EndIf
Switch $iIntType
Case $ARRAYUNIQUE_FORCE32
$oDictionary.Item($vElem)
If @error Then
$bCOMError = True
ExitLoop
EndIf
Case $ARRAYUNIQUE_FORCE64
$sType = VarGetType($vElem)
If $sType = "Int32" Then
$bCOMError = True
ExitLoop
EndIf
$vKey = "#" & $sType & "#" & String($vElem)
If Not $oDictionary.Item($vKey) Then
$oDictionary($vKey) = $vElem
EndIf
Case $ARRAYUNIQUE_MATCH
$sType = VarGetType($vElem)
If StringLeft($sType, 3) = "Int" Then
$vKey = "#Int#" & String($vElem)
Else
$vKey = "#" & $sType & "#" & String($vElem)
EndIf
If Not $oDictionary.Item($vKey) Then
$oDictionary($vKey) = $vElem
EndIf
Case $ARRAYUNIQUE_DISTINCT
$vKey = "#" & VarGetType($vElem) & "#" & String($vElem)
If Not $oDictionary.Item($vKey) Then
$oDictionary($vKey) = $vElem
EndIf
EndSwitch
Next
Local $aValues, $j = 0
If $bCOMError Then
Return SetError(7, 0, 0)
ElseIf $iIntType <> $ARRAYUNIQUE_FORCE32 Then
Local $aValues[$oDictionary.Count]
For $vKey In $oDictionary.Keys()
$aValues[$j] = $oDictionary($vKey)
If StringLeft($vKey, 5) = "#Ptr#" Then
$aValues[$j] = Ptr($aValues[$j])
EndIf
$j += 1
Next
Else
$aValues = $oDictionary.Keys()
EndIf
If $iCount Then
_ArrayInsert($aValues, 0, $oDictionary.Count)
EndIf
Return $aValues
EndFunc
Func __ArrayUnique_AutoErrFunc()
EndFunc
Global Const $FC_OVERWRITE = 1
Global Const $FC_CREATEPATH = 8
Global Const $FO_READ = 0
Global Const $FO_OVERWRITE = 2
Global Const $FO_CREATEPATH = 8
Global Const $FO_BINARY = 16
Global Const $FD_FILEMUSTEXIST = 1
Global Const $FD_PATHMUSTEXIST = 2
Global Const $FRTA_NOCOUNT = 0
Global Const $FRTA_COUNT = 1
Global Const $FRTA_INTARRAYS = 2
Global Const $FRTA_ENTIRESPLIT = 4
Global Const $FLTA_FILESFOLDERS = 0
Global Const $FLTAR_FILESFOLDERS = 0
Global Const $FLTAR_FILES = 1
Global Const $FLTAR_NOHIDDEN = 4
Global Const $FLTAR_NOSYSTEM = 8
Global Const $FLTAR_NOLINK = 16
Global Const $FLTAR_NORECUR = 0
Global Const $FLTAR_RECUR = 1
Global Const $FLTAR_NOSORT = 0
Global Const $FLTAR_RELPATH = 1
Global Const $FLTAR_FULLPATH = 2
Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = $FLTA_FILESFOLDERS, $bReturnPath = False)
Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""
$sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\"
If $iFlag = Default Then $iFlag = $FLTA_FILESFOLDERS
If $bReturnPath Then $sFullPath = $sFilePath
If $sFilter = Default Then $sFilter = "*"
If Not FileExists($sFilePath) Then Return SetError(1, 0, 0)
If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
If Not($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)
Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
If @error Then Return SetError(4, 0, 0)
While 1
$sFileName = FileFindNextFile($hSearch)
If @error Then ExitLoop
If($iFlag + @extended = 2) Then ContinueLoop
$sFileList &= $sDelimiter & $sFullPath & $sFileName
WEnd
FileClose($hSearch)
If $sFileList = "" Then Return SetError(4, 0, 0)
Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter)
EndFunc
Func _FileListToArrayRec($sFilePath, $sMask = "*", $iReturn = $FLTAR_FILESFOLDERS, $iRecur = $FLTAR_NORECUR, $iSort = $FLTAR_NOSORT, $iReturnPath = $FLTAR_RELPATH)
If Not FileExists($sFilePath) Then Return SetError(1, 1, "")
If $sMask = Default Then $sMask = "*"
If $iReturn = Default Then $iReturn = $FLTAR_FILESFOLDERS
If $iRecur = Default Then $iRecur = $FLTAR_NORECUR
If $iSort = Default Then $iSort = $FLTAR_NOSORT
If $iReturnPath = Default Then $iReturnPath = $FLTAR_RELPATH
If $iRecur > 1 Or Not IsInt($iRecur) Then Return SetError(1, 6, "")
Local $bLongPath = False
If StringLeft($sFilePath, 4) == "\\?\" Then
$bLongPath = True
EndIf
Local $sFolderSlash = ""
If StringRight($sFilePath, 1) = "\" Then
$sFolderSlash = "\"
Else
$sFilePath = $sFilePath & "\"
EndIf
Local $asFolderSearchList[100] = [1]
$asFolderSearchList[1] = $sFilePath
Local $iHide_HS = 0, $sHide_HS = ""
If BitAND($iReturn, $FLTAR_NOHIDDEN) Then
$iHide_HS += 2
$sHide_HS &= "H"
$iReturn -= $FLTAR_NOHIDDEN
EndIf
If BitAND($iReturn, $FLTAR_NOSYSTEM) Then
$iHide_HS += 4
$sHide_HS &= "S"
$iReturn -= $FLTAR_NOSYSTEM
EndIf
Local $iHide_Link = 0
If BitAND($iReturn, $FLTAR_NOLINK) Then
$iHide_Link = 0x400
$iReturn -= $FLTAR_NOLINK
EndIf
Local $iMaxLevel = 0
If $iRecur < 0 Then
StringReplace($sFilePath, "\", "", 0, $STR_NOCASESENSEBASIC)
$iMaxLevel = @extended - $iRecur
EndIf
Local $sExclude_List = "", $sExclude_List_Folder = "", $sInclude_List = "*"
Local $aMaskSplit = StringSplit($sMask, "|")
Switch $aMaskSplit[0]
Case 3
$sExclude_List_Folder = $aMaskSplit[3]
ContinueCase
Case 2
$sExclude_List = $aMaskSplit[2]
ContinueCase
Case 1
$sInclude_List = $aMaskSplit[1]
EndSwitch
Local $sInclude_File_Mask = ".+"
If $sInclude_List <> "*" Then
If Not __FLTAR_ListToMask($sInclude_File_Mask, $sInclude_List) Then Return SetError(1, 2, "")
EndIf
Local $sInclude_Folder_Mask = ".+"
Switch $iReturn
Case 0
Switch $iRecur
Case 0
$sInclude_Folder_Mask = $sInclude_File_Mask
EndSwitch
Case 2
$sInclude_Folder_Mask = $sInclude_File_Mask
EndSwitch
Local $sExclude_File_Mask = ":"
If $sExclude_List <> "" Then
If Not __FLTAR_ListToMask($sExclude_File_Mask, $sExclude_List) Then Return SetError(1, 3, "")
EndIf
Local $sExclude_Folder_Mask = ":"
If $iRecur Then
If $sExclude_List_Folder Then
If Not __FLTAR_ListToMask($sExclude_Folder_Mask, $sExclude_List_Folder) Then Return SetError(1, 4, "")
EndIf
If $iReturn = 2 Then
$sExclude_Folder_Mask = $sExclude_File_Mask
EndIf
Else
$sExclude_Folder_Mask = $sExclude_File_Mask
EndIf
If Not($iReturn = 0 Or $iReturn = 1 Or $iReturn = 2) Then Return SetError(1, 5, "")
If Not($iSort = 0 Or $iSort = 1 Or $iSort = 2) Then Return SetError(1, 7, "")
If Not($iReturnPath = 0 Or $iReturnPath = 1 Or $iReturnPath = 2) Then Return SetError(1, 8, "")
If $iHide_Link Then
Local $tFile_Data = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & "dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
Local $hDLL = DllOpen('kernel32.dll'), $aDLL_Ret
EndIf
Local $asReturnList[100] = [0]
Local $asFileMatchList = $asReturnList, $asRootFileMatchList = $asReturnList, $asFolderMatchList = $asReturnList
Local $bFolder = False, $hSearch = 0, $sCurrentPath = "", $sName = "", $sRetPath = ""
Local $iAttribs = 0, $sAttribs = ''
Local $asFolderFileSectionList[100][2] = [[0, 0]]
While $asFolderSearchList[0] > 0
$sCurrentPath = $asFolderSearchList[$asFolderSearchList[0]]
$asFolderSearchList[0] -= 1
Switch $iReturnPath
Case 1
$sRetPath = StringReplace($sCurrentPath, $sFilePath, "")
Case 2
If $bLongPath Then
$sRetPath = StringTrimLeft($sCurrentPath, 4)
Else
$sRetPath = $sCurrentPath
EndIf
EndSwitch
If $iHide_Link Then
$aDLL_Ret = DllCall($hDLL, 'handle', 'FindFirstFileW', 'wstr', $sCurrentPath & "*", 'struct*', $tFile_Data)
If @error Or Not $aDLL_Ret[0] Then
ContinueLoop
EndIf
$hSearch = $aDLL_Ret[0]
Else
$hSearch = FileFindFirstFile($sCurrentPath & "*")
If $hSearch = -1 Then
ContinueLoop
EndIf
EndIf
If $iReturn = 0 And $iSort And $iReturnPath Then
__FLTAR_AddToList($asFolderFileSectionList, $sRetPath, $asFileMatchList[0] + 1)
EndIf
$sAttribs = ''
While 1
If $iHide_Link Then
$aDLL_Ret = DllCall($hDLL, 'int', 'FindNextFileW', 'handle', $hSearch, 'struct*', $tFile_Data)
If @error Or Not $aDLL_Ret[0] Then
ExitLoop
EndIf
$sName = DllStructGetData($tFile_Data, "FileName")
If $sName = ".." Or $sName = "." Then
ContinueLoop
EndIf
$iAttribs = DllStructGetData($tFile_Data, "FileAttributes")
If $iHide_HS And BitAND($iAttribs, $iHide_HS) Then
ContinueLoop
EndIf
If BitAND($iAttribs, $iHide_Link) Then
ContinueLoop
EndIf
$bFolder = False
If BitAND($iAttribs, 16) Then
$bFolder = True
EndIf
Else
$bFolder = False
$sName = FileFindNextFile($hSearch, 1)
If @error Then
ExitLoop
EndIf
If $sName = ".." Or $sName = "." Then
ContinueLoop
EndIf
$sAttribs = @extended
If StringInStr($sAttribs, "D") Then
$bFolder = True
EndIf
If StringRegExp($sAttribs, "[" & $sHide_HS & "]") Then
ContinueLoop
EndIf
EndIf
If $bFolder Then
Select
Case $iRecur < 0
StringReplace($sCurrentPath, "\", "", 0, $STR_NOCASESENSEBASIC)
If @extended < $iMaxLevel Then
ContinueCase
EndIf
Case $iRecur = 1
If Not StringRegExp($sName, $sExclude_Folder_Mask) Then
__FLTAR_AddToList($asFolderSearchList, $sCurrentPath & $sName & "\")
EndIf
EndSelect
EndIf
If $iSort Then
If $bFolder Then
If StringRegExp($sName, $sInclude_Folder_Mask) And Not StringRegExp($sName, $sExclude_Folder_Mask) Then
__FLTAR_AddToList($asFolderMatchList, $sRetPath & $sName & $sFolderSlash)
EndIf
Else
If StringRegExp($sName, $sInclude_File_Mask) And Not StringRegExp($sName, $sExclude_File_Mask) Then
If $sCurrentPath = $sFilePath Then
__FLTAR_AddToList($asRootFileMatchList, $sRetPath & $sName)
Else
__FLTAR_AddToList($asFileMatchList, $sRetPath & $sName)
EndIf
EndIf
EndIf
Else
If $bFolder Then
If $iReturn <> 1 And StringRegExp($sName, $sInclude_Folder_Mask) And Not StringRegExp($sName, $sExclude_Folder_Mask) Then
__FLTAR_AddToList($asReturnList, $sRetPath & $sName & $sFolderSlash)
EndIf
Else
If $iReturn <> 2 And StringRegExp($sName, $sInclude_File_Mask) And Not StringRegExp($sName, $sExclude_File_Mask) Then
__FLTAR_AddToList($asReturnList, $sRetPath & $sName)
EndIf
EndIf
EndIf
WEnd
If $iHide_Link Then
DllCall($hDLL, 'int', 'FindClose', 'ptr', $hSearch)
Else
FileClose($hSearch)
EndIf
WEnd
If $iHide_Link Then
DllClose($hDLL)
EndIf
If $iSort Then
Switch $iReturn
Case 2
If $asFolderMatchList[0] = 0 Then Return SetError(1, 9, "")
ReDim $asFolderMatchList[$asFolderMatchList[0] + 1]
$asReturnList = $asFolderMatchList
__ArrayDualPivotSort($asReturnList, 1, $asReturnList[0])
Case 1
If $asRootFileMatchList[0] = 0 And $asFileMatchList[0] = 0 Then Return SetError(1, 9, "")
If $iReturnPath = 0 Then
__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList)
__ArrayDualPivotSort($asReturnList, 1, $asReturnList[0])
Else
__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList, 1)
EndIf
Case 0
If $asRootFileMatchList[0] = 0 And $asFolderMatchList[0] = 0 Then Return SetError(1, 9, "")
If $iReturnPath = 0 Then
__FLTAR_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList)
$asReturnList[0] += $asFolderMatchList[0]
ReDim $asFolderMatchList[$asFolderMatchList[0] + 1]
_ArrayConcatenate($asReturnList, $asFolderMatchList, 1)
__ArrayDualPivotSort($asReturnList, 1, $asReturnList[0])
Else
Local $asReturnList[$asFileMatchList[0] + $asRootFileMatchList[0] + $asFolderMatchList[0] + 1]
$asReturnList[0] = $asFileMatchList[0] + $asRootFileMatchList[0] + $asFolderMatchList[0]
__ArrayDualPivotSort($asRootFileMatchList, 1, $asRootFileMatchList[0])
For $i = 1 To $asRootFileMatchList[0]
$asReturnList[$i] = $asRootFileMatchList[$i]
Next
Local $iNextInsertionIndex = $asRootFileMatchList[0] + 1
__ArrayDualPivotSort($asFolderMatchList, 1, $asFolderMatchList[0])
Local $sFolderToFind = ""
For $i = 1 To $asFolderMatchList[0]
$asReturnList[$iNextInsertionIndex] = $asFolderMatchList[$i]
$iNextInsertionIndex += 1
If $sFolderSlash Then
$sFolderToFind = $asFolderMatchList[$i]
Else
$sFolderToFind = $asFolderMatchList[$i] & "\"
EndIf
Local $iFileSectionEndIndex = 0, $iFileSectionStartIndex = 0
For $j = 1 To $asFolderFileSectionList[0][0]
If $sFolderToFind = $asFolderFileSectionList[$j][0] Then
$iFileSectionStartIndex = $asFolderFileSectionList[$j][1]
If $j = $asFolderFileSectionList[0][0] Then
$iFileSectionEndIndex = $asFileMatchList[0]
Else
$iFileSectionEndIndex = $asFolderFileSectionList[$j + 1][1] - 1
EndIf
If $iSort = 1 Then
__ArrayDualPivotSort($asFileMatchList, $iFileSectionStartIndex, $iFileSectionEndIndex)
EndIf
For $k = $iFileSectionStartIndex To $iFileSectionEndIndex
$asReturnList[$iNextInsertionIndex] = $asFileMatchList[$k]
$iNextInsertionIndex += 1
Next
ExitLoop
EndIf
Next
Next
EndIf
EndSwitch
Else
If $asReturnList[0] = 0 Then Return SetError(1, 9, "")
ReDim $asReturnList[$asReturnList[0] + 1]
EndIf
Return $asReturnList
EndFunc
Func __FLTAR_AddFileLists(ByRef $asTarget, $asSource_1, $asSource_2, $iSort = 0)
ReDim $asSource_1[$asSource_1[0] + 1]
If $iSort = 1 Then __ArrayDualPivotSort($asSource_1, 1, $asSource_1[0])
$asTarget = $asSource_1
$asTarget[0] += $asSource_2[0]
ReDim $asSource_2[$asSource_2[0] + 1]
If $iSort = 1 Then __ArrayDualPivotSort($asSource_2, 1, $asSource_2[0])
_ArrayConcatenate($asTarget, $asSource_2, 1)
EndFunc
Func __FLTAR_AddToList(ByRef $aList, $vValue_0, $vValue_1 = -1)
If $vValue_1 = -1 Then
$aList[0] += 1
If UBound($aList) <= $aList[0] Then ReDim $aList[UBound($aList) * 2]
$aList[$aList[0]] = $vValue_0
Else
$aList[0][0] += 1
If UBound($aList) <= $aList[0][0] Then ReDim $aList[UBound($aList) * 2][2]
$aList[$aList[0][0]][0] = $vValue_0
$aList[$aList[0][0]][1] = $vValue_1
EndIf
EndFunc
Func __FLTAR_ListToMask(ByRef $sMask, $sList)
If StringRegExp($sList, "\\|/|:|\<|\>|\|") Then Return 0
$sList = StringReplace(StringStripWS(StringRegExpReplace($sList, "\s*;\s*", ";"), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING)), ";", "|")
$sList = StringReplace(StringReplace(StringRegExpReplace($sList, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
$sMask = "(?i)^(" & $sList & ")\z"
Return 1
EndFunc
Func _FileReadToArray($sFilePath, ByRef $vReturn, $iFlags = $FRTA_COUNT, $sDelimiter = "")
$vReturn = 0
If $iFlags = Default Then $iFlags = $FRTA_COUNT
If $sDelimiter = Default Then $sDelimiter = ""
Local $bExpand = True
If BitAND($iFlags, $FRTA_INTARRAYS) Then
$bExpand = False
$iFlags -= $FRTA_INTARRAYS
EndIf
Local $iEntire = $STR_CHRSPLIT
If BitAND($iFlags, $FRTA_ENTIRESPLIT) Then
$iEntire = $STR_ENTIRESPLIT
$iFlags -= $FRTA_ENTIRESPLIT
EndIf
Local $iNoCount = 0
If $iFlags <> $FRTA_COUNT Then
$iFlags = $FRTA_NOCOUNT
$iNoCount = $STR_NOCOUNT
EndIf
If $sDelimiter Then
Local $aLines = FileReadToArray($sFilePath)
If @error Then Return SetError(@error, 0, 0)
Local $iDim_1 = UBound($aLines) + $iFlags
If $bExpand Then
Local $iDim_2 = UBound(StringSplit($aLines[0], $sDelimiter, $iEntire + $STR_NOCOUNT))
Local $aTemp_Array[$iDim_1][$iDim_2]
Local $iFields, $aSplit
For $i = 0 To $iDim_1 - $iFlags - 1
$aSplit = StringSplit($aLines[$i], $sDelimiter, $iEntire + $STR_NOCOUNT)
$iFields = UBound($aSplit)
If $iFields <> $iDim_2 Then
Return SetError(3, 0, 0)
EndIf
For $j = 0 To $iFields - 1
$aTemp_Array[$i + $iFlags][$j] = $aSplit[$j]
Next
Next
If $iDim_2 < 2 Then Return SetError(4, 0, 0)
If $iFlags Then
$aTemp_Array[0][0] = $iDim_1 - $iFlags
$aTemp_Array[0][1] = $iDim_2
EndIf
Else
Local $aTemp_Array[$iDim_1]
For $i = 0 To $iDim_1 - $iFlags - 1
$aTemp_Array[$i + $iFlags] = StringSplit($aLines[$i], $sDelimiter, $iEntire + $iNoCount)
Next
If $iFlags Then
$aTemp_Array[0] = $iDim_1 - $iFlags
EndIf
EndIf
$vReturn = $aTemp_Array
Else
If $iFlags Then
Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
If $hFileOpen = -1 Then Return SetError(1, 0, 0)
Local $sFileRead = FileRead($hFileOpen)
FileClose($hFileOpen)
If StringLen($sFileRead) Then
$vReturn = StringRegExp(@LF & $sFileRead, "(?|(\N+)\z|(\N*)(?:\R))", $STR_REGEXPARRAYGLOBALMATCH)
$vReturn[0] = UBound($vReturn) - 1
Else
Return SetError(2, 0, 0)
EndIf
Else
$vReturn = FileReadToArray($sFilePath)
If @error Then
$vReturn = 0
Return SetError(@error, 0, 0)
EndIf
EndIf
EndIf
Return 1
EndFunc
Func _FileWriteFromArray($sFilePath, Const ByRef $aArray, $iBase = Default, $iUBound = Default, $sDelimiter = "|")
Local $iReturn = 0
If Not IsArray($aArray) Then Return SetError(2, 0, $iReturn)
Local $iDims = UBound($aArray, $UBOUND_DIMENSIONS)
If $iDims > 2 Then Return SetError(4, 0, 0)
Local $iLast = UBound($aArray) - 1
If $iUBound = Default Or $iUBound > $iLast Then $iUBound = $iLast
If $iBase < 0 Or $iBase = Default Then $iBase = 0
If $iBase > $iUBound Then Return SetError(5, 0, $iReturn)
If $sDelimiter = Default Then $sDelimiter = "|"
Local $hFileOpen = $sFilePath
If IsString($sFilePath) Then
$hFileOpen = FileOpen($sFilePath, $FO_OVERWRITE)
If $hFileOpen = -1 Then Return SetError(1, 0, $iReturn)
EndIf
Local $iError = 0
$iReturn = 1
Switch $iDims
Case 1
For $i = $iBase To $iUBound
If Not FileWrite($hFileOpen, $aArray[$i] & @CRLF) Then
$iError = 3
$iReturn = 0
ExitLoop
EndIf
Next
Case 2
Local $sTemp = ""
For $i = $iBase To $iUBound
$sTemp = $aArray[$i][0]
For $j = 1 To UBound($aArray, $UBOUND_COLUMNS) - 1
$sTemp &= $sDelimiter & $aArray[$i][$j]
Next
If Not FileWrite($hFileOpen, $sTemp & @CRLF) Then
$iError = 3
$iReturn = 0
ExitLoop
EndIf
Next
EndSwitch
If IsString($sFilePath) Then FileClose($hFileOpen)
Return SetError($iError, 0, $iReturn)
EndFunc
Global Const $CBS_AUTOHSCROLL = 0x40
Global Const $CBS_DROPDOWNLIST = 0x3
Global Const $CB_DELETESTRING = 0x144
Global Const $CB_GETDROPPEDSTATE = 0x157
Global Const $CB_INSERTSTRING = 0x14A
Global Const $CB_SELECTSTRING = 0x14D
Global Const $CBN_CLOSEUP = 8
Global Const $CBN_DROPDOWN = 7
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
Local $aCall = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
If @error Then Return SetError(@error, @extended, "")
If $iReturn >= 0 And $iReturn <= 4 Then Return $aCall[$iReturn]
Return $aCall
EndFunc
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagGDIPRECTF = "struct;float X;float Y;float Width;float Height;endstruct"
Global Const $tagGDIPSTARTUPINPUT = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $tagGDIPIMAGECODECINFO = "byte CLSID[16];byte FormatID[16];ptr CodecName;ptr DllName;ptr FormatDesc;ptr FileExt;" & "ptr MimeType;dword Flags;dword Version;dword SigCount;dword SigSize;ptr SigPattern;ptr SigMask"
Global Const $tagGUID = "struct;ulong Data1;ushort Data2;ushort Data3;byte Data4[8];endstruct"
Global Const $tagSECURITY_ATTRIBUTES = "dword Length;ptr Descriptor;bool InheritHandle"
Global $__g_vEnum, $__g_vExt = 0
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $IMAGE_BITMAP = 0
Global Const $IMAGE_ICON = 1
Global Const $IMAGE_CURSOR = 2
Global Const $IMAGE_ENHMETAFILE = 3
Global Const $LR_DEFAULTCOLOR = 0x0000
Func _WinAPI_FreeLibrary($hModule)
Local $aCall = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hModule)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _WinAPI_GetDlgCtrlID($hWnd)
Local $aCall = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_GetModuleHandle($sModuleName)
If $sModuleName = "" Then $sModuleName = Null
Local $aCall = DllCall("kernel32.dll", "handle", "GetModuleHandleW", "wstr", $sModuleName)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_GetString($pString, $bUnicode = True)
Local $iLength = _WinAPI_StrLen($pString, $bUnicode)
If @error Or Not $iLength Then Return SetError(@error + 10, @extended, '')
Local $tString = DllStructCreate(($bUnicode ? 'wchar' : 'char') & '[' &($iLength + 1) & ']', $pString)
If @error Then Return SetError(@error, @extended, '')
Return SetExtended($iLength, DllStructGetData($tString, 1))
EndFunc
Func _WinAPI_GetVersion()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aCall = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return Number(DllStructGetData($tOSVI, 2) & "." & DllStructGetData($tOSVI, 3), $NUMBER_DOUBLE)
EndFunc
Func _WinAPI_LoadImage($hInstance, $sImage, $iType, $iXDesired, $iYDesired, $iLoad)
Local $aCall, $sImageType = "int"
If IsString($sImage) Then $sImageType = "wstr"
$aCall = DllCall("user32.dll", "handle", "LoadImageW", "handle", $hInstance, $sImageType, $sImage, "uint", $iType, "int", $iXDesired, "int", $iYDesired, "uint", $iLoad)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_StrLen($pString, $bUnicode = True)
Local $W = ''
If $bUnicode Then $W = 'W'
Local $aCall = DllCall('kernel32.dll', 'int', 'lstrlen' & $W, 'struct*', $pString)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func __Inc(ByRef $aData, $iIncrement = 100)
Select
Case UBound($aData, $UBOUND_COLUMNS)
If $iIncrement < 0 Then
ReDim $aData[$aData[0][0] + 1][UBound($aData, $UBOUND_COLUMNS)]
Else
$aData[0][0] += 1
If $aData[0][0] > UBound($aData) - 1 Then
ReDim $aData[$aData[0][0] + $iIncrement][UBound($aData, $UBOUND_COLUMNS)]
EndIf
EndIf
Case UBound($aData, $UBOUND_ROWS)
If $iIncrement < 0 Then
ReDim $aData[$aData[0] + 1]
Else
$aData[0] += 1
If $aData[0] > UBound($aData) - 1 Then
ReDim $aData[$aData[0] + $iIncrement]
EndIf
EndIf
Case Else
Return 0
EndSelect
Return 1
EndFunc
Func _WinAPI_GUIDFromString($sGUID)
Local $tGUID = DllStructCreate($tagGUID)
If Not _WinAPI_GUIDFromStringEx($sGUID, $tGUID) Then Return SetError(@error, @extended, 0)
Return $tGUID
EndFunc
Func _WinAPI_GUIDFromStringEx($sGUID, $tGUID)
Local $aCall = DllCall("ole32.dll", "long", "CLSIDFromString", "wstr", $sGUID, "struct*", $tGUID)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _WinAPI_StringFromGUID($tGUID)
Local $aCall = DllCall("ole32.dll", "int", "StringFromGUID2", "struct*", $tGUID, "wstr", "", "int", 40)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, "")
Return SetExtended($aCall[0], $aCall[2])
EndFunc
Func _WinAPI_DeleteObject($hObject)
Local $aCall = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Global Const $GWL_STYLE = 0xFFFFFFF0
Func _WinAPI_GetClassName($hWnd)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Local $aCall = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hWnd, "wstr", "", "int", 4096)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, '')
Return SetExtended($aCall[0], $aCall[2])
EndFunc
Func _WinAPI_GetWindowLong($hWnd, $iIndex)
Local $sFuncName = "GetWindowLongW"
If @AutoItX64 Then $sFuncName = "GetWindowLongPtrW"
Local $aCall = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex)
If @error Or Not $aCall[0] Then Return SetError(@error + 10, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_InvalidateRect($hWnd, $tRECT = 0, $bErase = True)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Local $aCall = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $hWnd, "struct*", $tRECT, "bool", $bErase)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _WinAPI_SetWindowPos($hWnd, $hAfter, $iX, $iY, $iCX, $iCY, $iFlags)
Local $aCall = DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hWnd, "hwnd", $hAfter, "int", $iX, "int", $iY, "int", $iCX, "int", $iCY, "uint", $iFlags)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _WinAPI_UpdateWindow($hWnd)
Local $aCall = DllCall("user32.dll", "bool", "UpdateWindow", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _GUICtrlComboBox_DeleteString($hWnd, $iIndex)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Return _SendMessage($hWnd, $CB_DELETESTRING, $iIndex)
EndFunc
Func _GUICtrlComboBox_GetDroppedState($hWnd)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Return _SendMessage($hWnd, $CB_GETDROPPEDSTATE) <> 0
EndFunc
Func _GUICtrlComboBox_InsertString($hWnd, $sText, $iIndex = -1)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Return _SendMessage($hWnd, $CB_INSERTSTRING, $iIndex, $sText, 0, "wparam", "wstr")
EndFunc
Func _GUICtrlComboBox_SelectString($hWnd, $sText, $iIndex = -1)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Return _SendMessage($hWnd, $CB_SELECTSTRING, $iIndex, $sText, 0, "wparam", "wstr")
EndFunc
Global Const $BS_ICON = 0x0040
Global Const $BS_BITMAP = 0x0080
Global Const $BM_GETIMAGE = 0xF6
Global Const $BM_SETIMAGE = 0xF7
Global Const $ES_READONLY = 2048
Global Const $ES_WANTRETURN = 4096
Global Const $ES_NUMBER = 8192
Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_DISABLE = 128
Global Const $GUI_DOCKLEFT = 0x0002
Global Const $GUI_DOCKRIGHT = 0x0004
Global Const $GUI_DOCKHCENTER = 0x0008
Global Const $GUI_DOCKTOP = 0x0020
Global Const $GUI_DOCKBOTTOM = 0x0040
Global Const $GUI_DOCKVCENTER = 0x0080
Global Const $GUI_DOCKWIDTH = 0x0100
Global Const $GUI_DOCKHEIGHT = 0x0200
Global Const $GUI_DOCKSIZE = 0x0300
Global Const $GUI_DOCKBORDERS = 0x0066
Global Const $GUI_BKCOLOR_TRANSPARENT = -2
Global Const $LBS_NOINTEGRALHEIGHT = 0x00000100
Global Const $LB_ADDSTRING = 0x0180
Global Const $LB_RESETCONTENT = 0x0184
Global Const $SS_CENTER = 0x1
Global Const $SS_RIGHT = 0x2
Global Const $SS_ICON = 0x3
Global Const $SS_BITMAP = 0xE
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SIZEBOX = 0x00040000
Global Const $WS_VSCROLL = 0x00200000
Global Const $WS_BORDER = 0x00800000
Global Const $WS_POPUP = 0x80000000
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $WS_EX_TOPMOST = 0x00000008
Global Const $WM_COMMAND = 0x0111
Global Const $GMEM_MOVEABLE = 0x0002
Func _WinAPI_SetLastError($iErrorCode, Const $_iCallerError = @error, Const $_iCallerExtended = @extended)
DllCall("kernel32.dll", "none", "SetLastError", "dword", $iErrorCode)
Return SetError($_iCallerError, $_iCallerExtended, Null)
EndFunc
Func _MemGlobalAlloc($iBytes, $iFlags = 0)
Local $aCall = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $iFlags, "ulong_ptr", $iBytes)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _MemGlobalLock($hMemory)
Local $aCall = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hMemory)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _MemGlobalUnlock($hMemory)
Local $aCall = DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hMemory)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _MemMoveMemory($pSource, $pDest, $iLength)
DllCall("kernel32.dll", "none", "RtlMoveMemory", "struct*", $pDest, "struct*", $pSource, "ulong_ptr", $iLength)
If @error Then Return SetError(@error, @extended)
EndFunc
Global Const $RT_ANICURSOR = 21
Global Const $RT_BITMAP = 2
Global Const $RT_CURSOR = 1
Global Const $RT_FONT = 8
Global Const $RT_ICON = 3
Global Const $RT_MENU = 4
Global Const $RT_RCDATA = 10
Global Const $RT_STRING = 6
Global Const $LOAD_LIBRARY_AS_DATAFILE = 0x02
Func _WinAPI_IsBadReadPtr($pAddress, $iLength)
Local $aCall = DllCall('kernel32.dll', 'bool', 'IsBadReadPtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _WinAPI_IsBadWritePtr($pAddress, $iLength)
Local $aCall = DllCall('kernel32.dll', 'bool', 'IsBadWritePtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _WinAPI_MoveMemory($pDestination, $pSource, $iLength)
If _WinAPI_IsBadReadPtr($pSource, $iLength) Then Return SetError(10, @extended, 0)
If _WinAPI_IsBadWritePtr($pDestination, $iLength) Then Return SetError(11, @extended, 0)
DllCall('ntdll.dll', 'none', 'RtlMoveMemory', 'struct*', $pDestination, 'struct*', $pSource, 'ulong_ptr', $iLength)
If @error Then Return SetError(@error, @extended, 0)
Return 1
EndFunc
Global Const $SND_MEMORY = 0x00000004
Global Const $SND_NODEFAULT = 0x00000002
Global Const $SND_RESOURCE = 0x00040004
Global Const $SND_SYNC = 0x00000000
Global Const $SND_SYSTEM_NOSTOP = 0x00200010
Func _WinAPI_PlaySound($sSound, $iFlags = $SND_SYSTEM_NOSTOP, $hInstance = 0)
Local $sTypeOfSound = 'ptr'
If $sSound Then
If IsString($sSound) Then
$sTypeOfSound = 'wstr'
EndIf
Else
$sSound = 0
$iFlags = 0
EndIf
Local $aCall = DllCall('winmm.dll', 'bool', 'PlaySoundW', $sTypeOfSound, $sSound, 'handle', $hInstance, 'dword', $iFlags)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _WinAPI_DestroyIcon($hIcon)
Local $aCall = DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hIcon)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _WinAPI_DestroyCursor($hCursor)
Local $aCall = DllCall('user32.dll', 'bool', 'DestroyCursor', 'handle', $hCursor)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_FindResource($hInstance, $sType, $sName)
Local $sTypeOfType = 'int', $sTypeOfName = 'int'
If IsString($sType) Then
$sTypeOfType = 'wstr'
EndIf
If IsString($sName) Then
$sTypeOfName = 'wstr'
EndIf
Local $aCall = DllCall('kernel32.dll', 'handle', 'FindResourceW', 'handle', $hInstance, $sTypeOfName, $sName, $sTypeOfType, $sType)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_FindResourceEx($hInstance, $sType, $sName, $iLanguage)
Local $sTypeOfType = 'int', $sTypeOfName = 'int'
If IsString($sType) Then
$sTypeOfType = 'wstr'
EndIf
If IsString($sName) Then
$sTypeOfName = 'wstr'
EndIf
Local $aCall = DllCall('kernel32.dll', 'handle', 'FindResourceExW', 'handle', $hInstance, $sTypeOfType, $sType, $sTypeOfName, $sName, 'ushort', $iLanguage)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_LoadString($hInstance, $iStringID)
Local $aCall = DllCall("user32.dll", "int", "LoadStringW", "handle", $hInstance, "uint", $iStringID, "wstr", "", "int", 4096)
If @error Or Not $aCall[0] Then Return SetError(@error + 10, @extended, "")
Return SetExtended($aCall[0], $aCall[3])
EndFunc
Func _WinAPI_LoadLibraryEx($sFileName, $iFlags = 0)
Local $aCall = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileName, "ptr", 0, "dword", $iFlags)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_LoadResource($hInstance, $hResource)
Local $aCall = DllCall('kernel32.dll', 'handle', 'LoadResource', 'handle', $hInstance, 'handle', $hResource)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_LockResource($hData)
Local $aCall = DllCall('kernel32.dll', 'ptr', 'LockResource', 'handle', $hData)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_SizeOfResource($hInstance, $hResource)
Local $aCall = DllCall('kernel32.dll', 'dword', 'SizeofResource', 'handle', $hInstance, 'handle', $hResource)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _GUICtrlListBox_AddString($hWnd, $sText)
If Not IsString($sText) Then $sText = String($sText)
If IsHWnd($hWnd) Then
Return _SendMessage($hWnd, $LB_ADDSTRING, 0, $sText, 0, "wparam", "wstr")
Else
Return GUICtrlSendMsg($hWnd, $LB_ADDSTRING, 0, $sText)
EndIf
EndFunc
Func _GUICtrlListBox_ResetContent($hWnd)
If IsHWnd($hWnd) Then
_SendMessage($hWnd, $LB_RESETCONTENT)
Else
GUICtrlSendMsg($hWnd, $LB_RESETCONTENT, 0, 0)
EndIf
EndFunc
Func _Singleton($sOccurrenceName, $iFlag = 0)
Local Const $ERROR_ALREADY_EXISTS = 183
Local Const $SECURITY_DESCRIPTOR_REVISION = 1
Local $tSecurityAttributes = 0
If BitAND($iFlag, 2) Then
Local $tSecurityDescriptor = DllStructCreate("byte;byte;word;ptr[4]")
Local $aCall = DllCall("advapi32.dll", "bool", "InitializeSecurityDescriptor", "struct*", $tSecurityDescriptor, "dword", $SECURITY_DESCRIPTOR_REVISION)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then
$aCall = DllCall("advapi32.dll", "bool", "SetSecurityDescriptorDacl", "struct*", $tSecurityDescriptor, "bool", 1, "ptr", 0, "bool", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then
$tSecurityAttributes = DllStructCreate($tagSECURITY_ATTRIBUTES)
DllStructSetData($tSecurityAttributes, 1, DllStructGetSize($tSecurityAttributes))
DllStructSetData($tSecurityAttributes, 2, DllStructGetPtr($tSecurityDescriptor))
DllStructSetData($tSecurityAttributes, 3, 0)
EndIf
EndIf
EndIf
Local $aHandle = DllCall("kernel32.dll", "handle", "CreateMutexW", "struct*", $tSecurityAttributes, "bool", 1, "wstr", $sOccurrenceName)
If @error Then Return SetError(@error, @extended, 0)
Local $aLastError = DllCall("kernel32.dll", "dword", "GetLastError")
If @error Then Return SetError(@error, @extended, 0)
If $aLastError[0] = $ERROR_ALREADY_EXISTS Then
If BitAND($iFlag, 1) Then
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $aHandle[0])
If @error Then Return SetError(@error, @extended, 0)
Return SetError($aLastError[0], $aLastError[0], 0)
Else
Exit -1
EndIf
EndIf
Return $aHandle[0]
EndFunc
Func _IsPressed($sHexKey, $vDLL = "user32.dll")
Local $aCall = DllCall($vDLL, "short", "GetAsyncKeyState", "int", "0x" & $sHexKey)
If @error Then Return SetError(@error, @extended, False)
Return BitAND($aCall[0], 0x8000) <> 0
EndFunc
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Func _WinAPI_CreateStreamOnHGlobal($hGlobal = 0, $bDeleteOnRelease = True)
Local $aCall = DllCall('ole32.dll', 'long', 'CreateStreamOnHGlobal', 'handle', $hGlobal, 'bool', $bDeleteOnRelease, 'ptr*', 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[3]
EndFunc
Func _WinAPI_ReleaseStream($pStream)
Local $aCall = DllCall('oleaut32.dll', 'long', 'DispCallFunc', 'ptr', $pStream, 'ulong_ptr', 8 *(1 + @AutoItX64), 'uint', 4, 'ushort', 23, 'uint', 0, 'ptr', 0, 'ptr', 0, 'str', '')
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return 1
EndFunc
Func _WinAPI_AddFontMemResourceEx($pData, $iSize)
Local $aCall = DllCall('gdi32.dll', 'handle', 'AddFontMemResourceEx', 'ptr', $pData, 'dword', $iSize, 'ptr', 0, 'dword*', 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetExtended($aCall[4], $aCall[0])
EndFunc
Func _WinAPI_DeleteEnhMetaFile($hEmf)
Local $aCall = DllCall('gdi32.dll', 'bool', 'DeleteEnhMetaFile', 'handle', $hEmf)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func _WinAPI_EnumDisplayMonitors($hDC = 0, $tRECT = 0)
Local $hEnumProc = DllCallbackRegister('__EnumDisplayMonitorsProc', 'bool', 'handle;handle;ptr;lparam')
Dim $__g_vEnum[101][2] = [[0]]
Local $aCall = DllCall('user32.dll', 'bool', 'EnumDisplayMonitors', 'handle', $hDC, 'struct*', $tRECT, 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', 0)
If @error Or Not $aCall[0] Or Not $__g_vEnum[0][0] Then
$__g_vEnum = @error + 10
EndIf
DllCallbackFree($hEnumProc)
If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)
__Inc($__g_vEnum, -1)
Return $__g_vEnum
EndFunc
Func _WinAPI_GetPosFromRect($tRECT)
Local $aRet[4]
For $i = 0 To 3
$aRet[$i] = DllStructGetData($tRECT, $i + 1)
If @error Then Return SetError(@error, @extended, 0)
Next
For $i = 2 To 3
$aRet[$i] -= $aRet[$i - 2]
Next
Return $aRet
EndFunc
Func _WinAPI_MonitorFromWindow($hWnd, $iFlag = 1)
Local $aCall = DllCall('user32.dll', 'handle', 'MonitorFromWindow', 'hwnd', $hWnd, 'dword', $iFlag)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Func _WinAPI_RemoveFontMemResourceEx($hFont)
Local $aCall = DllCall('gdi32.dll', 'bool', 'RemoveFontMemResourceEx', 'handle', $hFont)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
Func __EnumDisplayMonitorsProc($hMonitor, $hDC, $pRECT, $lParam)
#forceref $hDC, $lParam
__Inc($__g_vEnum)
$__g_vEnum[$__g_vEnum[0][0]][0] = $hMonitor
If Not $pRECT Then
$__g_vEnum[$__g_vEnum[0][0]][1] = 0
Else
$__g_vEnum[$__g_vEnum[0][0]][1] = DllStructCreate($tagRECT)
If Not _WinAPI_MoveMemory(DllStructGetPtr($__g_vEnum[$__g_vEnum[0][0]][1]), $pRECT, 16) Then Return 0
EndIf
Return 1
EndFunc
Func _WinAPI_SetWindowLong($hWnd, $iIndex, $iValue)
_WinAPI_SetLastError(0)
Local $sFuncName = "SetWindowLongW"
If @AutoItX64 Then $sFuncName = "SetWindowLongPtrW"
Local $aCall = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex, "long_ptr", $iValue)
If @error Then Return SetError(@error, @extended, 0)
Return $aCall[0]
EndFunc
Global Const $GDIP_PXF32ARGB = 0x0026200A
Global Const $GDIP_FRAMEDIMENSION_TIME = "{6AEDBD6D-3FB5-418A-83A6-7F45229DC872}"
Global $__g_hGDIPBrush = 0
Global $__g_hGDIPDll = 0
Global $__g_hGDIPPen = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True
Func _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphics)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromGraphics", "int", $iWidth, "int", $iHeight, "handle", $hGraphics, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[4]
EndFunc
Func _GDIPlus_BitmapCreateFromHBITMAP($hBitmap, $hPal = 0)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "handle", $hBitmap, "handle", $hPal, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[3]
EndFunc
Func _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iPixelFormat = $GDIP_PXF32ARGB, $iStride = 0, $pScan0 = 0)
Local $aCall = DllCall($__g_hGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "int", $iPixelFormat, "struct*", $pScan0, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[6]
EndFunc
Func _GDIPlus_BitmapCreateFromStream($pStream)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromStream", "ptr", $pStream, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[2]
EndFunc
Func _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap, $iARGB = 0xFF000000)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateHBITMAPFromBitmap", "handle", $hBitmap, "handle*", 0, "dword", $iARGB)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[2]
EndFunc
Func _GDIPlus_BitmapDispose($hBitmap)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_BrushCreateSolid($iARGB = 0xFF000000)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateSolidFill", "int", $iARGB, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[2]
EndFunc
Func _GDIPlus_BrushDispose($hBrush)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDeleteBrush", "handle", $hBrush)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_Encoders()
Local $iCount = _GDIPlus_EncodersGetCount()
Local $iSize = _GDIPlus_EncodersGetSize()
Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tCodec, $aInfo[$iCount + 1][14]
$aInfo[0][0] = $iCount
For $iI = 1 To $iCount
$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
$aInfo[$iI][3] = _WinAPI_GetString(DllStructGetData($tCodec, "CodecName"))
$aInfo[$iI][4] = _WinAPI_GetString(DllStructGetData($tCodec, "DllName"))
$aInfo[$iI][5] = _WinAPI_GetString(DllStructGetData($tCodec, "FormatDesc"))
$aInfo[$iI][6] = _WinAPI_GetString(DllStructGetData($tCodec, "FileExt"))
$aInfo[$iI][7] = _WinAPI_GetString(DllStructGetData($tCodec, "MimeType"))
$aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
$aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
$aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
$aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
$aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
$aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
$pBuffer += DllStructGetSize($tCodec)
Next
Return $aInfo
EndFunc
Func _GDIPlus_EncodersGetCLSID($sFileExtension)
Local $aEncoders = _GDIPlus_Encoders()
If @error Then Return SetError(@error, 0, "")
For $iI = 1 To $aEncoders[0][0]
If StringInStr($aEncoders[$iI][6], "*." & $sFileExtension) > 0 Then Return $aEncoders[$iI][1]
Next
Return SetError(-1, -1, "")
EndFunc
Func _GDIPlus_EncodersGetCount()
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
If @error Then Return SetError(@error, @extended, -1)
If $aCall[0] Then Return SetError(10, $aCall[0], -1)
Return $aCall[1]
EndFunc
Func _GDIPlus_EncodersGetSize()
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
If @error Then Return SetError(@error, @extended, -1)
If $aCall[0] Then Return SetError(10, $aCall[0], -1)
Return $aCall[2]
EndFunc
Func _GDIPlus_FontCreate($hFamily, $fSize, $iStyle = 0, $iUnit = 3)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateFont", "handle", $hFamily, "float", $fSize, "int", $iStyle, "int", $iUnit, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[5]
EndFunc
Func _GDIPlus_FontDispose($hFont)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDeleteFont", "handle", $hFont)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_FontFamilyCreate($sFamily, $pCollection = 0)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateFontFamilyFromName", "wstr", $sFamily, "ptr", $pCollection, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[3]
EndFunc
Func _GDIPlus_FontFamilyDispose($hFamily)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDeleteFontFamily", "handle", $hFamily)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsCreateFromHWND($hWnd)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateFromHWND", "hwnd", $hWnd, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[2]
EndFunc
Func _GDIPlus_GraphicsDispose($hGraphics)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $nX, $nY, $nW, $nH)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDrawImageRect", "handle", $hGraphics, "handle", $hImage, "float", $nX, "float", $nY, "float", $nW, "float", $nH)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsDrawRect($hGraphics, $nX, $nY, $nWidth, $nHeight, $hPen = 0)
__GDIPlus_PenDefCreate($hPen)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDrawRectangle", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight)
__GDIPlus_PenDefDispose()
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $tLayout, $hFormat, $hBrush)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDrawString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, "struct*", $tLayout, "handle", $hFormat, "handle", $hBrush)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsFillRect($hGraphics, $nX, $nY, $nWidth, $nHeight, $hBrush = 0)
__GDIPlus_BrushDefCreate($hBrush)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipFillRectangle", "handle", $hGraphics, "handle", $hBrush, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight)
__GDIPlus_BrushDefDispose()
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_ImageDispose($hImage)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hImage)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_ImageGetGraphicsContext($hImage)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipGetImageGraphicsContext", "handle", $hImage, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[2]
EndFunc
Func _GDIPlus_ImageLoadFromFile($sFileName)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipLoadImageFromFile", "wstr", $sFileName, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[2]
EndFunc
Func _GDIPlus_ImageSaveToFile($hImage, $sFileName)
Local $sExt = __GDIPlus_ExtractFileExt($sFileName)
Local $sCLSID = _GDIPlus_EncodersGetCLSID($sExt)
If $sCLSID = "" Then Return SetError(-1, 0, False)
Local $bRet = _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sCLSID, 0)
Return SetError(@error, @extended, $bRet)
EndFunc
Func _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sEncoder, $tParams = 0)
Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipSaveImageToFile", "handle", $hImage, "wstr", $sFileName, "struct*", $tGUID, "struct*", $tParams)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_ImageSelectActiveFrame($hImage, $sDimensionID, $iFrameIndex)
Local $tGUID = _WinAPI_GUIDFromString($sDimensionID)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipImageSelectActiveFrame", "handle", $hImage, "struct*", $tGUID, "uint", $iFrameIndex)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_PenCreate($iARGB = 0xFF000000, $nWidth = 1, $iUnit = 2)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreatePen1", "dword", $iARGB, "float", $nWidth, "int", $iUnit, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[4]
EndFunc
Func _GDIPlus_PenDispose($hPen)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDeletePen", "handle", $hPen)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_RectFCreate($nX = 0, $nY = 0, $nWidth = 0, $nHeight = 0)
Local $tRECTF = DllStructCreate($tagGDIPRECTF)
DllStructSetData($tRECTF, "X", $nX)
DllStructSetData($tRECTF, "Y", $nY)
DllStructSetData($tRECTF, "Width", $nWidth)
DllStructSetData($tRECTF, "Height", $nHeight)
Return $tRECTF
EndFunc
Func _GDIPlus_Shutdown()
If $__g_hGDIPDll = 0 Then Return SetError(-1, -1, False)
$__g_iGDIPRef -= 1
If $__g_iGDIPRef = 0 Then
DllCall($__g_hGDIPDll, "none", "GdiplusShutdown", "ulong_ptr", $__g_iGDIPToken)
DllClose($__g_hGDIPDll)
$__g_hGDIPDll = 0
EndIf
Return True
EndFunc
Func _GDIPlus_Startup($sGDIPDLL = Default, $bRetDllHandle = False)
$__g_iGDIPRef += 1
If $__g_iGDIPRef > 1 Then Return True
If $sGDIPDLL = Default Then $sGDIPDLL = "gdiplus.dll"
$__g_hGDIPDll = DllOpen($sGDIPDLL)
If $__g_hGDIPDll = -1 Then
$__g_iGDIPRef = 0
Return SetError(1, 2, False)
EndIf
Local $sVer = FileGetVersion($sGDIPDLL)
$sVer = StringSplit($sVer, ".")
If $sVer[1] > 5 Then $__g_bGDIP_V1_0 = False
Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
Local $tToken = DllStructCreate("ulong_ptr Data")
DllStructSetData($tInput, "Version", 1)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
$__g_iGDIPToken = DllStructGetData($tToken, "Data")
If $bRetDllHandle Then Return $__g_hGDIPDll
Return SetExtended($sVer[1], True)
EndFunc
Func _GDIPlus_StringFormatCreate($iFormat = 0, $iLangID = 0)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipCreateStringFormat", "int", $iFormat, "word", $iLangID, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aCall[0] Then Return SetError(10, $aCall[0], 0)
Return $aCall[3]
EndFunc
Func _GDIPlus_StringFormatDispose($hFormat)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipDeleteStringFormat", "handle", $hFormat)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_StringFormatSetAlign($hStringFormat, $iFlag)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipSetStringFormatAlign", "handle", $hStringFormat, "int", $iFlag)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func _GDIPlus_StringFormatSetLineAlign($hStringFormat, $iStringAlign)
Local $aCall = DllCall($__g_hGDIPDll, "int", "GdipSetStringFormatLineAlign", "handle", $hStringFormat, "int", $iStringAlign)
If @error Then Return SetError(@error, @extended, False)
If $aCall[0] Then Return SetError(10, $aCall[0], False)
Return True
EndFunc
Func __GDIPlus_BrushDefCreate(ByRef $hBrush)
If $hBrush = 0 Then
$__g_hGDIPBrush = _GDIPlus_BrushCreateSolid()
$hBrush = $__g_hGDIPBrush
EndIf
EndFunc
Func __GDIPlus_BrushDefDispose($iCurError = @error, $iCurExtended = @extended)
If $__g_hGDIPBrush <> 0 Then
_GDIPlus_BrushDispose($__g_hGDIPBrush)
$__g_hGDIPBrush = 0
EndIf
Return SetError($iCurError, $iCurExtended)
EndFunc
Func __GDIPlus_ExtractFileExt($sFileName, $bNoDot = True)
Local $iIndex = __GDIPlus_LastDelimiter(".\:", $sFileName)
If($iIndex > 0) And(StringMid($sFileName, $iIndex, 1) = '.') Then
If $bNoDot Then
Return StringMid($sFileName, $iIndex + 1)
Else
Return StringMid($sFileName, $iIndex)
EndIf
Else
Return ""
EndIf
EndFunc
Func __GDIPlus_LastDelimiter($sDelimiters, $sString)
Local $sDelimiter, $iN
For $iI = 1 To StringLen($sDelimiters)
$sDelimiter = StringMid($sDelimiters, $iI, 1)
$iN = StringInStr($sString, $sDelimiter, $STR_NOCASESENSEBASIC, -1)
If $iN > 0 Then Return $iN
Next
EndFunc
Func __GDIPlus_PenDefCreate(ByRef $hPen)
If $hPen = 0 Then
$__g_hGDIPPen = _GDIPlus_PenCreate()
$hPen = $__g_hGDIPPen
EndIf
EndFunc
Func __GDIPlus_PenDefDispose($iCurError = @error, $iCurExtended = @extended)
If $__g_hGDIPPen <> 0 Then
_GDIPlus_PenDispose($__g_hGDIPPen)
$__g_hGDIPPen = 0
EndIf
Return SetError($iCurError, $iCurExtended)
EndFunc
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
If $__g_GIFExtended_aStoreCache[$I][7] Then
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
Global Const $INET_FORCERELOAD = 1
Global Const $INET_IGNORESSL = 2
Global Const $INET_DOWNLOADBACKGROUND = 1
Func _GUICtrlMenu_DestroyMenu($hMenu)
Local $aCall = DllCall("user32.dll", "bool", "DestroyMenu", "handle", $hMenu)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
OnAutoItExitRegister(_GDIPlus_Shutdown)
OnAutoItExitRegister(_Resource_DestroyAll)
_GDIPlus_Startup()
Global Enum $RESOURCE_ERROR_NONE, $RESOURCE_ERROR_FINDRESOURCE, $RESOURCE_ERROR_INVALIDCONTROLID, $RESOURCE_ERROR_INVALIDCLASS, $RESOURCE_ERROR_INVALIDRESOURCENAME, $RESOURCE_ERROR_INVALIDRESOURCETYPE, $RESOURCE_ERROR_LOCKRESOURCE, $RESOURCE_ERROR_LOADBITMAP, $RESOURCE_ERROR_LOADCURSOR, $RESOURCE_ERROR_LOADICON, $RESOURCE_ERROR_LOADIMAGE, $RESOURCE_ERROR_LOADLIBRARY, $RESOURCE_ERROR_LOADSTRING, $RESOURCE_ERROR_SETIMAGE
Global Const $RESOURCE_SS_ENHMETAFILE = 0xF
Global Const $RESOURCE_SS_REALSIZECONTROL = 0x40
Global Const $RESOURCE_STM_GETIMAGE = 0x0173
Global Const $RESOURCE_STM_SETIMAGE = 0x0172
Global Const $RESOURCE_LANG_DEFAULT = 0
Global Enum $RESOURCE_RT_BITMAP = 1000, $RESOURCE_RT_ENHMETAFILE, $RESOURCE_RT_FONT
Global Enum $RESOURCE_POS_H, $RESOURCE_POS_W, $RESOURCE_POS_MAX
Global Const $RESOURCE_STORAGE_GUID = 'CA37F1E6-04D1-11E4-B340-4B0AE3E253B6'
Global Enum $RESOURCE_STORAGE, $RESOURCE_STORAGE_FIRSTINDEX
Global Enum $RESOURCE_STORAGE_ID, $RESOURCE_STORAGE_INDEX, $RESOURCE_STORAGE_RESETCOUNT, $RESOURCE_STORAGE_UBOUND
Global Enum $RESOURCE_STORAGE_DLL, $RESOURCE_STORAGE_CASTRESTYPE, $RESOURCE_STORAGE_LENGTH, $RESOURCE_STORAGE_PTR, $RESOURCE_STORAGE_RESLANG, $RESOURCE_STORAGE_RESNAMEORID, $RESOURCE_STORAGE_RESTYPE, $RESOURCE_STORAGE_MAX, $RESOURCE_STORAGE_ADD, $RESOURCE_STORAGE_DESTROY, $RESOURCE_STORAGE_DESTROYALL, $RESOURCE_STORAGE_GET
Global Enum $RESOURCE_WINGETPOS_XPOS, $RESOURCE_WINGETPOS_YPOS, $RESOURCE_WINGETPOS_WIDTH, $RESOURCE_WINGETPOS_HEIGHT
Func _Resource_DestroyAll()
Return __Resource_Storage($RESOURCE_STORAGE_DESTROYALL, Null, Null, Null, Null, Null, Null, Null)
EndFunc
Func _Resource_GetAsBitmap($sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default)
Local $hHBITMAP = 0, $hBitmap = _Resource_GetAsImage($sResNameOrID, $iResType, $sDllOrExePath)
Local $iError = @error
Local $iLength = @extended
If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
$hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
If @error Then
$iError = $RESOURCE_ERROR_LOADBITMAP
Else
_GDIPlus_BitmapDispose($hBitmap)
$hBitmap = 0
EndIf
EndIf
If $iError <> $RESOURCE_ERROR_NONE Then $hHBITMAP = 0
Return SetError($iError, $iLength, $hHBITMAP)
EndFunc
Func _Resource_GetAsCursor($sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default)
Local $hCursor = __Resource_Get($sResNameOrID, $iResType, $RESOURCE_LANG_DEFAULT, $sDllOrExePath, $RT_CURSOR)
Local $iError = @error
Local $iLength = @extended
If $iError <> $RESOURCE_ERROR_NONE Then $hCursor = 0
Return SetError($iError, $iLength, $hCursor)
EndFunc
Func _Resource_GetAsBytes($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDllOrExePath = Default)
Local $pResource = __Resource_Get($sResNameOrID, $iResType, $iResLang, $sDllOrExePath, $RT_RCDATA)
Local $iError = @error
Local $iLength = @extended
Local $dBytes = Binary(Null)
If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
Local $tBuffer = DllStructCreate('byte array[' & $iLength & ']', $pResource)
$dBytes = DllStructGetData($tBuffer, 'array')
EndIf
Return SetError($iError, $iLength, $dBytes)
EndFunc
Func _Resource_GetAsIcon($sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default)
Local $hIcon = __Resource_Get($sResNameOrID, $iResType, $RESOURCE_LANG_DEFAULT, $sDllOrExePath, $RT_ICON)
Local $iError = @error
Local $iLength = @extended
If $iError <> $RESOURCE_ERROR_NONE Then $hIcon = 0
Return SetError($iError, $iLength, $hIcon)
EndFunc
Func _Resource_GetAsImage($sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default)
If $iResType = Default Then $iResType = $RT_RCDATA
Local $iError = $RESOURCE_ERROR_LOADIMAGE, $iLength = 0, $hBitmap = 0
Switch $iResType
Case $RT_BITMAP
Local $hHBITMAP = __Resource_Get($sResNameOrID, $RT_BITMAP, 0, $sDllOrExePath, $RT_BITMAP)
$iError = @error
$iLength = @extended
If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBITMAP)
If @error Then
$iError = $RESOURCE_ERROR_LOADIMAGE
Else
EndIf
EndIf
Case Else
Local $pResource = __Resource_Get($sResNameOrID, $iResType, 0, $sDllOrExePath, $RT_RCDATA)
$iError = @error
$iLength = @extended
If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
$hBitmap = __Resource_ConvertToBitmap($pResource, $iLength)
EndIf
EndSwitch
Return SetError($iError, $iLength, $hBitmap)
EndFunc
Func _Resource_GetAsString($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDllOrExePath = Default)
Local $iError = $RESOURCE_ERROR_LOADSTRING, $iLength = 0, $sString = ''
Switch $iResType
Case $RT_RCDATA
Local $dBytes = _Resource_GetAsBytes($sResNameOrID, $iResType, $iResLang, $sDllOrExePath)
$iError = @error
$iLength = @extended
If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
Local Enum $BINARYTOSTRING_NONE, $BINARYTOSTRING_ANSI, $BINARYTOSTRING_UTF16LE, $BINARYTOSTRING_UTF16BE, $BINARYTOSTRING_UTF8
Local $iStart = $BINARYTOSTRING_NONE, $iUTFEncoding = $BINARYTOSTRING_ANSI
Local Const $sUTF8 = '0xEFBBBF', $sUTF16BE = '0xFEFF', $sUTF16LE = '0xFFFE', $sUTF32BE = '0x0000FEFF', $sUTF32LE = '0xFFFE0000'
Local $iUTF8 = BinaryLen($sUTF8), $iUTF16BE = BinaryLen($sUTF16BE), $iUTF16LE = BinaryLen($sUTF16LE), $iUTF32BE = BinaryLen($sUTF32BE), $iUTF32LE = BinaryLen($sUTF32LE)
Select
Case BinaryMid($dBytes, 1, $iUTF32BE) = $sUTF32BE
$iStart = $iUTF32BE
$iUTFEncoding = $BINARYTOSTRING_ANSI
Case BinaryMid($dBytes, 1, $iUTF32LE) = $sUTF32LE
$iStart = $iUTF32LE
$iUTFEncoding = $BINARYTOSTRING_ANSI
Case BinaryMid($dBytes, 1, $iUTF16BE) = $sUTF16BE
$iStart = $iUTF16BE
$iUTFEncoding = $BINARYTOSTRING_UTF16BE
Case BinaryMid($dBytes, 1, $iUTF16LE) = $sUTF16LE
$iStart = $iUTF16LE
$iUTFEncoding = $BINARYTOSTRING_UTF16LE
Case BinaryMid($dBytes, 1, $iUTF8) = $sUTF8
$iStart = $iUTF8
$iUTFEncoding = $BINARYTOSTRING_UTF8
EndSelect
$iStart += 1
$iLength = $iLength + 1 - $iStart
$sString = BinaryToString(BinaryMid($dBytes, $iStart), $iUTFEncoding)
EndIf
$dBytes = 0
Case $RT_STRING
$sString = __Resource_Get($sResNameOrID, $iResType, $iResLang, $sDllOrExePath, $iResType)
$iError = @error
$iLength = @extended
EndSwitch
Return SetError($iError, $iLength, $sString)
EndFunc
Func _Resource_LoadFont($sResNameOrID, $iResLang = Default, $sDllOrExePath = Default)
Local $pResource = __Resource_Get($sResNameOrID, $RT_FONT, $iResLang, $sDllOrExePath, $RT_FONT)
Local $iError = @error
Local $iLength = @extended
If $iError = $RESOURCE_ERROR_NONE Then
Local $hFont = _WinAPI_AddFontMemResourceEx($pResource, $iLength)
__Resource_Storage($RESOURCE_STORAGE_ADD, $sDllOrExePath, $hFont, $sResNameOrID, $RESOURCE_RT_FONT, $iResLang, $RESOURCE_RT_FONT, $iLength)
$hFont = 0
EndIf
Return SetError($iError, $iLength, $pResource)
EndFunc
Func _Resource_LoadSound($sResNameOrID, $iFlags = $SND_SYNC, $sDllOrExePath = Default)
Local $bIsInternal = False, $bReturn = False
Local $hInstance = __Resource_LoadModule($sDllOrExePath, $bIsInternal)
If Not $hInstance Then Return SetError($RESOURCE_ERROR_LOADLIBRARY, 0, $bReturn)
Local $dSound = _Resource_GetAsBytes($sResNameOrID)
Local $iLength = @extended
If Not $iLength Then
$bReturn = _WinAPI_PlaySound($sResNameOrID, BitOR($SND_RESOURCE, $iFlags), $hInstance)
Else
Local $sAlign_Buffer = '00', $sHeader_1 = '0x52494646', $sHeader_2 = '57415645666D74201E0000005500020044AC0000581B0000010000000C00010002000000B600010071056661637404000000640E060064617461'
Local $sMp3 = StringTrimLeft(Binary($dSound), StringLen('00'))
Local Const $iByte = 8
Local $iMp3Size = StringRegExpReplace(Hex($iLength, $iByte), '(..)(..)(..)(..)', '$4$3$2$1')
Local $iWavSize = StringRegExpReplace(Hex($iLength + 63, $iByte), '(..)(..)(..)(..)', '$4$3$2$1')
Local $sHybridWav = $sHeader_1 & $iWavSize & $sHeader_2 & $iMp3Size & $sMp3
If Mod($iMp3Size, 2) Then
$sHybridWav &= $sAlign_Buffer
EndIf
Local $tWAV = DllStructCreate('byte array[' & BinaryLen($sHybridWav) & ']')
DllStructSetData($tWAV, 'array', $sHybridWav)
$iFlags = BitOR($SND_MEMORY, $SND_NODEFAULT, $iFlags)
$bReturn = _WinAPI_PlaySound(DllStructGetPtr($tWAV), $iFlags, $hInstance)
EndIf
__Resource_UnloadModule($hInstance, $bIsInternal)
Return $bReturn
EndFunc
Func _Resource_SaveToFile($sFilePath, $sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $bCreatePath = Default, $sDllOrExePath = Default)
Local $bReturn = False, $iCreatePath =(IsBool($bCreatePath) And $bCreatePath ? $FO_CREATEPATH : 0), $iError = $RESOURCE_ERROR_NONE, $iLength = 0
If $iResType = Default Then $iResType = $RT_RCDATA
If $iResType = $RT_BITMAP Then
Local $hImage = _Resource_GetAsImage($sResNameOrID, $iResType)
$iError = @error
$iLength = @extended
If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
FileClose(FileOpen($sFilePath, BitOR($FO_OVERWRITE, $FO_BINARY, $iCreatePath)))
$bReturn = _GDIPlus_ImageSaveToFile($hImage, $sFilePath)
_GDIPlus_ImageDispose($hImage)
EndIf
Else
Local $dBytes = _Resource_GetAsBytes($sResNameOrID, $iResType, $iResLang, $sDllOrExePath)
$iError = @error
$iLength = @extended
If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
Local $hFileOpen = FileOpen($sFilePath, BitOR($FO_OVERWRITE, $FO_BINARY, $iCreatePath))
If $hFileOpen > -1 Then
$bReturn = True
FileWrite($hFileOpen, $dBytes)
FileClose($hFileOpen)
EndIf
EndIf
EndIf
Return SetError($iError, $iLength, $bReturn)
EndFunc
Func _Resource_SetToCtrlID($iCtrlID, $sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default, $bResize = Default)
If $iResType = Default Then $iResType = $RT_RCDATA
Local $aWinGetPos = 0, $bDestroy = True, $bReturn = False, $iError = $RESOURCE_ERROR_INVALIDRESOURCETYPE, $iLength = 0, $vReturn = False
Local $hWnd = 0
__Resource_GetCtrlId($hWnd, $iCtrlID)
Switch $iResType
Case $RT_BITMAP, $RT_RCDATA
If StringStripWS($sResNameOrID, $STR_STRIPALL) = '' Or String($sResNameOrID) = '0' Then
$bReturn = __Resource_SetToCtrlID($iCtrlID, 0, $RT_BITMAP, True, False)
$iError = @error
Else
Local $hHBITMAP = _Resource_GetAsBitmap($sResNameOrID, $iResType, $sDllOrExePath)
$iError = @error
$iLength = @extended
If $iError = $RESOURCE_ERROR_NONE And $iLength > 0 Then
$bReturn = __Resource_SetToCtrlID($iCtrlID, $hHBITMAP, $RT_BITMAP, $bDestroy, $bResize)
$iError = @error
If $bReturn Then
If _WinAPI_GetVersion() >= 6.0 Then
$bReturn = _WinAPI_DeleteObject($hHBITMAP) > 0
$vReturn = $bReturn
Else
__Resource_Storage($RESOURCE_STORAGE_ADD, $sDllOrExePath, $hHBITMAP, $sResNameOrID, $iResType, Null, $iResType, $iLength)
$vReturn = $hHBITMAP
EndIf
EndIf
EndIf
EndIf
Case $RT_CURSOR
If StringStripWS($sResNameOrID, $STR_STRIPALL) = '' Or String($sResNameOrID) = '0' Then
$bReturn = __Resource_SetToCtrlID($iCtrlID, 0, $RT_CURSOR, True, False)
$iError = @error
Else
$bDestroy = False
Local $hCursor = 0
If $bResize Then
$aWinGetPos = WinGetPos($hWnd)
If Not @error Then
Local $aPos[$RESOURCE_POS_MAX]
$aPos[$RESOURCE_POS_H] = $aWinGetPos[$RESOURCE_WINGETPOS_HEIGHT]
$aPos[$RESOURCE_POS_W] = $aWinGetPos[$RESOURCE_WINGETPOS_WIDTH]
If $aPos[$RESOURCE_POS_H] = 0 And $aPos[$RESOURCE_POS_W] = 0 Then
GUICtrlSetImage($iCtrlID, @AutoItExe, 0)
$aWinGetPos = WinGetPos($hWnd)
If Not @error Then
$aPos[$RESOURCE_POS_H] = $aWinGetPos[$RESOURCE_WINGETPOS_HEIGHT]
$aPos[$RESOURCE_POS_W] = $aWinGetPos[$RESOURCE_WINGETPOS_WIDTH]
EndIf
EndIf
$hCursor = __Resource_Get($sResNameOrID, $RT_CURSOR, $RESOURCE_LANG_DEFAULT, $sDllOrExePath, $RT_CURSOR, $aPos)
$iError = @error
$iLength = @extended
EndIf
Else
$hCursor = _Resource_GetAsCursor($sResNameOrID, $iResType, $sDllOrExePath)
$iError = @error
$iLength = @extended
EndIf
If $iError = $RESOURCE_ERROR_NONE Then
$bReturn = __Resource_SetToCtrlID($iCtrlID, $hCursor, $RT_CURSOR, $bDestroy, $bResize)
EndIf
$hCursor = 0
$vReturn = $bReturn
EndIf
Case $RT_ICON
If StringStripWS($sResNameOrID, $STR_STRIPALL) = '' Or String($sResNameOrID) = '0' Then
$bReturn = __Resource_SetToCtrlID($iCtrlID, 0, $RT_ICON, True, False)
$iError = @error
Else
$bDestroy = False
Local $hIcon = 0
If $bResize Then
__Resource_GetCtrlId($hWnd, $iCtrlID)
$aWinGetPos = WinGetPos($hWnd)
If Not @error Then
Local $aPos[$RESOURCE_POS_MAX]
$aPos[$RESOURCE_POS_H] = $aWinGetPos[$RESOURCE_WINGETPOS_HEIGHT]
$aPos[$RESOURCE_POS_W] = $aWinGetPos[$RESOURCE_WINGETPOS_WIDTH]
If $aPos[$RESOURCE_POS_H] = 0 And $aPos[$RESOURCE_POS_W] = 0 Then
GUICtrlSetImage($iCtrlID, @AutoItExe, 0)
$aWinGetPos = WinGetPos($hWnd)
If Not @error Then
$aPos[$RESOURCE_POS_H] = $aWinGetPos[$RESOURCE_WINGETPOS_HEIGHT]
$aPos[$RESOURCE_POS_W] = $aWinGetPos[$RESOURCE_WINGETPOS_WIDTH]
EndIf
EndIf
$hIcon = __Resource_Get($sResNameOrID, $RT_ICON, $RESOURCE_LANG_DEFAULT, $sDllOrExePath, $RT_ICON, $aPos)
$iError = @error
$iLength = @extended
EndIf
Else
$hIcon = _Resource_GetAsIcon($sResNameOrID, $iResType, $sDllOrExePath)
$iError = @error
$iLength = @extended
EndIf
If $iError = $RESOURCE_ERROR_NONE Then
$bReturn = __Resource_SetToCtrlID($iCtrlID, $hIcon, $RT_ICON, $bDestroy, $bResize)
EndIf
$hIcon = 0
$vReturn = $bReturn
EndIf
EndSwitch
Return SetError($iError, $iLength, $vReturn)
EndFunc
Func __Resource_ConvertToBitmap($pResource, $iLength)
Local $hData = _MemGlobalAlloc($iLength, $GMEM_MOVEABLE)
Local $pData = _MemGlobalLock($hData)
_MemMoveMemory($pResource, $pData, $iLength)
_MemGlobalUnlock($hData)
Local $pStream = _WinAPI_CreateStreamOnHGlobal($hData)
Local $hBitmap = _GDIPlus_BitmapCreateFromStream($pStream)
_WinAPI_ReleaseStream($pStream)
Return $hBitmap
EndFunc
Func __Resource_Destroy($pResource, $iResType)
Local $bReturn = False
Switch $iResType
Case $RT_ANICURSOR, $RT_CURSOR
$bReturn = _WinAPI_DeleteObject($pResource) > 0
If Not $bReturn Then
$bReturn = _WinAPI_DestroyCursor($pResource) > 0
EndIf
Case $RT_BITMAP
$bReturn = _WinAPI_DeleteObject($pResource) > 0
Case $RT_FONT
$bReturn = True
Case $RT_ICON
$bReturn = _WinAPI_DeleteObject($pResource) > 0
If Not $bReturn Then
$bReturn = _WinAPI_DestroyIcon($pResource) > 0
EndIf
Case $RT_MENU
$bReturn = _GUICtrlMenu_DestroyMenu($pResource) > 0
Case $RT_STRING
$bReturn = True
Case $RESOURCE_RT_BITMAP
$bReturn = _GDIPlus_BitmapDispose($pResource) > 0
Case $RESOURCE_RT_ENHMETAFILE
$bReturn = _WinAPI_DeleteEnhMetaFile($pResource) > 0
Case $RESOURCE_RT_FONT
$bReturn = _WinAPI_RemoveFontMemResourceEx($pResource) > 0
Case Else
$bReturn = True
EndSwitch
If Not IsBool($bReturn) Then $bReturn = $bReturn > 0
Return $bReturn
EndFunc
Func __Resource_Get($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDllOrExePath = Default, $iCastResType = Default, $aPos = Null)
If $iResType = $RT_RCDATA And StringStripWS($sResNameOrID, $STR_STRIPALL) = '' Then Return SetError($RESOURCE_ERROR_INVALIDRESOURCENAME, 0, Null)
If $iCastResType = Default Then $iCastResType = $iResType
If $iResLang = Default Then $iResLang = $RESOURCE_LANG_DEFAULT
If $iResType = Default Then $iResType = $RT_RCDATA
Local $iError = $RESOURCE_ERROR_NONE, $iLength = 0, $vResource = __Resource_Storage($RESOURCE_STORAGE_GET, $sDllOrExePath, Null, $sResNameOrID, $iResType, $iResLang, $iCastResType, Null)
$iLength = @extended
If $vResource Then
Return SetError($iError, $iLength, $vResource)
EndIf
Local $bIsInternal = False
Local $hInstance = __Resource_LoadModule($sDllOrExePath, $bIsInternal)
If Not $hInstance Then Return SetError($RESOURCE_ERROR_LOADLIBRARY, 0, 0)
Local $hResource =(($iResLang <> $RESOURCE_LANG_DEFAULT) ? _WinAPI_FindResourceEx($hInstance, $iResType, $sResNameOrID, $iResLang) : _WinAPI_FindResource($hInstance, $iResType, $sResNameOrID))
If @error <> $RESOURCE_ERROR_NONE Then $iError = $RESOURCE_ERROR_FINDRESOURCE
If $iError = $RESOURCE_ERROR_NONE Then
If $aPos = Null Then
Local $aTemp[$RESOURCE_POS_MAX] = [0, 0]
$aPos = $aTemp
$aTemp = 0
$aPos[$RESOURCE_POS_H] = 0
$aPos[$RESOURCE_POS_W] = 0
EndIf
$iLength = _WinAPI_SizeOfResource($hInstance, $hResource)
Switch $iCastResType
Case $RT_ANICURSOR, $RT_CURSOR
$vResource = _WinAPI_LoadImage($hInstance, $sResNameOrID, $IMAGE_CURSOR, $aPos[$RESOURCE_POS_W], $aPos[$RESOURCE_POS_H], $LR_DEFAULTCOLOR)
If @error <> $RESOURCE_ERROR_NONE Or Not $vResource Then $iError = $RESOURCE_ERROR_LOADCURSOR
Case $RT_BITMAP
$vResource = _WinAPI_LoadImage($hInstance, $sResNameOrID, $IMAGE_BITMAP, $aPos[$RESOURCE_POS_W], $aPos[$RESOURCE_POS_H], $LR_DEFAULTCOLOR)
If @error <> $RESOURCE_ERROR_NONE Or Not $vResource Then $iError = $RESOURCE_ERROR_LOADBITMAP
Case $RT_ICON
$vResource = _WinAPI_LoadImage($hInstance, $sResNameOrID, $IMAGE_ICON, $aPos[$RESOURCE_POS_W], $aPos[$RESOURCE_POS_H], $LR_DEFAULTCOLOR)
If @error <> $RESOURCE_ERROR_NONE Or Not $vResource Then $iError = $RESOURCE_ERROR_LOADICON
Case $RT_STRING
$vResource = _WinAPI_LoadString($hInstance, $sResNameOrID)
$iLength = @extended
If @error <> $RESOURCE_ERROR_NONE Then $iError = $RESOURCE_ERROR_LOADSTRING
Case Else
Local $hData = _WinAPI_LoadResource($hInstance, $hResource)
$vResource = _WinAPI_LockResource($hData)
$hData = 0
If Not $vResource Then $iError = $RESOURCE_ERROR_LOCKRESOURCE
EndSwitch
If $iError = $RESOURCE_ERROR_NONE Then
__Resource_Storage($RESOURCE_STORAGE_ADD, $sDllOrExePath, $vResource, $sResNameOrID, $iResType, $iResLang, $iCastResType, $iLength)
Else
$vResource = Null
EndIf
EndIf
__Resource_UnloadModule($hInstance, $bIsInternal)
Return SetError($iError, $iLength, $vResource)
EndFunc
Func __Resource_GetCtrlId(ByRef $hWnd, ByRef $iCtrlID)
If $iCtrlID = Default Or $iCtrlID <= 0 Or Not IsInt($iCtrlID) Then $iCtrlID = -1
$hWnd = GUICtrlGetHandle($iCtrlID)
If $hWnd And $iCtrlID = -1 Then
$iCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
EndIf
Return True
EndFunc
Func __Resource_GetLastImage($iCtrlID, $hResource, $sClassName, ByRef $hPrevious, ByRef $iPreviousResType)
$hPrevious = 0
$iPreviousResType = 0
Local $aGetImage = 0, $bReturn = True, $iMsg_Get = 0
Switch $sClassName
Case 'Button'
Local $aButton = [[$IMAGE_BITMAP, $RT_BITMAP], [$IMAGE_ICON, $RT_ICON]]
$aGetImage = $aButton
$aButton = 0
$iMsg_Get = $BM_GETIMAGE
Case 'Static'
Local $aStatic = [[$IMAGE_BITMAP, $RT_BITMAP], [$IMAGE_CURSOR, $RT_CURSOR], [$IMAGE_ENHMETAFILE, $RESOURCE_RT_ENHMETAFILE], [$IMAGE_ICON, $RT_ICON]]
$aGetImage = $aStatic
$aStatic = 0
$iMsg_Get = $RESOURCE_STM_GETIMAGE
Case Else
$bReturn = False
EndSwitch
If $bReturn Then
Local Enum $eWPARAM, $eRESTYPE
For $i = 0 To UBound($aGetImage) - 1
$hPrevious = GUICtrlSendMsg($iCtrlID, $iMsg_Get, $aGetImage[$i][$eWPARAM], 0)
If $hPrevious <> 0 And $hPrevious <> $hResource Then
$iPreviousResType = $aGetImage[$i][$eRESTYPE]
ExitLoop
EndIf
Next
EndIf
Return $bReturn
EndFunc
Func __Resource_LoadModule(ByRef $sDllOrExePath, ByRef $bIsInternal)
$bIsInternal =($sDllOrExePath = Default Or $sDllOrExePath = -1)
If Not $bIsInternal And Not StringRegExp($sDllOrExePath, '\.(?:cpl|dll|exe)$') Then
$bIsInternal = True
EndIf
Return($bIsInternal ? _WinAPI_GetModuleHandle(Null) : _WinAPI_LoadLibraryEx($sDllOrExePath, $LOAD_LIBRARY_AS_DATAFILE))
EndFunc
Func __Resource_UnloadModule(ByRef $hInstance, ByRef $bIsInternal)
Local $bReturn = True
If $bIsInternal And $hInstance Then
$bReturn = _WinAPI_FreeLibrary($hInstance)
EndIf
Return $bReturn
EndFunc
Func __Resource_SetToCtrlID($iCtrlID, $hResource, $iResType, $bDestroy, $bResize)
Local $bReturn = False, $iError = $RESOURCE_ERROR_SETIMAGE
Local $hWnd = 0
__Resource_GetCtrlId($hWnd, $iCtrlID)
$iError = $RESOURCE_ERROR_INVALIDCONTROLID
If $hWnd And $iCtrlID > 0 Then
Local $aStyles[0]
$bReturn = True
$iError = $RESOURCE_ERROR_NONE
Local $iMsg_Set = 0, $iStyle = 0, $wParam = 0
Local $sClassName = _WinAPI_GetClassName($iCtrlID)
Switch $sClassName
Case 'Button'
Local $aButtonStyles = [$BS_BITMAP, $BS_ICON]
$aStyles = $aButtonStyles
$aButtonStyles = 0
$iMsg_Set = $BM_SETIMAGE
Switch $iResType
Case $RT_BITMAP
$iStyle = $BS_BITMAP
$wParam = $IMAGE_BITMAP
$bResize = False
Case $RT_ICON
$iStyle = $BS_ICON
$wParam = $IMAGE_ICON
$bResize = False
Case Else
$bReturn = False
$iError = $RESOURCE_ERROR_INVALIDRESOURCETYPE
EndSwitch
Case 'Static'
Local $aStaticStyles = [$SS_BITMAP, $SS_ICON, $RESOURCE_SS_ENHMETAFILE]
$aStyles = $aStaticStyles
$aStaticStyles = 0
$iMsg_Set = $RESOURCE_STM_SETIMAGE
Switch $iResType
Case $RT_BITMAP
$iStyle = $SS_BITMAP
$wParam = $IMAGE_BITMAP
Case $RT_CURSOR
$iStyle = $SS_ICON
$wParam = $IMAGE_CURSOR
Case $RESOURCE_RT_ENHMETAFILE
$iStyle = $RESOURCE_SS_ENHMETAFILE
$wParam = $IMAGE_ENHMETAFILE
Case $RT_ICON
$iStyle = $SS_ICON
$wParam = $IMAGE_ICON
Case Else
$bReturn = False
$iError = $RESOURCE_ERROR_INVALIDRESOURCETYPE
EndSwitch
Case Else
$bReturn = False
$iError = $RESOURCE_ERROR_INVALIDCLASS
EndSwitch
If $bReturn Then
Local $iCurrentStyle = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
If Not @error Then
For $i = 0 To UBound($aStyles) - 1
If BitAND($aStyles[$i], $iCurrentStyle) Then
$iCurrentStyle = BitXOR($iCurrentStyle, $aStyles[$i])
EndIf
Next
If $bResize Then
_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($iCurrentStyle, $RESOURCE_SS_REALSIZECONTROL, $iStyle))
Else
_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($iCurrentStyle, $iStyle))
EndIf
EndIf
Local $hPrevious = 0, $iPreviousResType = 0
__Resource_GetLastImage($iCtrlID, $hResource, $sClassName, $hPrevious, $iPreviousResType)
GUICtrlSendMsg($iCtrlID, $iMsg_Set, $wParam, $hResource)
If $iPreviousResType Then
__Resource_Destroy($hPrevious, $iPreviousResType)
__Resource_Storage($RESOURCE_STORAGE_DESTROY, Null, $hPrevious, Null, Null, Null, Null, Null)
If $bDestroy = Default Or $bDestroy Then
__Resource_Destroy($hResource, $iResType)
__Resource_Storage($RESOURCE_STORAGE_DESTROY, Null, $hResource, Null, Null, Null, Null, Null)
EndIf
_WinAPI_InvalidateRect($hWnd, 0, True)
_WinAPI_UpdateWindow($hWnd)
Else
$bReturn = False
$iError = $RESOURCE_ERROR_SETIMAGE
EndIf
EndIf
EndIf
Return SetError($iError, 0, $bReturn)
EndFunc
Func __Resource_Storage($iAction, $sDllOrExePath, $pResource, $sResNameOrID, $iResType, $iResLang, $iCastResType, $iLength)
Local Static $aStorage[$RESOURCE_STORAGE_FIRSTINDEX][$RESOURCE_STORAGE_MAX]
Local $bReturn = False
Switch $iAction
Case $RESOURCE_STORAGE_ADD
If Not($aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_ID] = $RESOURCE_STORAGE_GUID) Then
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_ID] = $RESOURCE_STORAGE_GUID
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] = 0
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] = 0
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] = $RESOURCE_STORAGE_FIRSTINDEX
EndIf
If Not($pResource = Null) And Not __Resource_Storage($RESOURCE_STORAGE_GET, $sDllOrExePath, Null, $sResNameOrID, $iResType, $iResLang, $iCastResType, Null) Then
$bReturn = True
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] += 1
If $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] >= $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] Then
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] = Ceiling($aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] * 1.3)
ReDim $aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND]][$RESOURCE_STORAGE_MAX]
EndIf
$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_DLL] = $sDllOrExePath
$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_PTR] = $pResource
$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_RESLANG] = $iResLang
$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_RESNAMEORID] = $sResNameOrID
$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_RESTYPE] = $iResType
$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_CASTRESTYPE] = $iCastResType
$aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]][$RESOURCE_STORAGE_LENGTH] = $iLength
EndIf
Case $RESOURCE_STORAGE_DESTROY
Local $iDestoryCount = 0, $iDestoryed = 0
For $i = $RESOURCE_STORAGE_FIRSTINDEX To $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]
If Not($aStorage[$i][$RESOURCE_STORAGE_PTR] = Null) Then
If $aStorage[$i][$RESOURCE_STORAGE_PTR] = $pResource Or($aStorage[$i][$RESOURCE_STORAGE_DLL] = $sDllOrExePath And $aStorage[$i][$RESOURCE_STORAGE_RESNAMEORID] = $sResNameOrID And $aStorage[$i][$RESOURCE_STORAGE_RESTYPE] = $iResType And $aStorage[$i][$RESOURCE_STORAGE_CASTRESTYPE] = $iCastResType) Then
$bReturn = __Resource_Storage_Destroy($aStorage, $i)
If $bReturn Then
$iDestoryed += 1
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] += 1
EndIf
$iDestoryCount += 1
EndIf
EndIf
Next
$bReturn = $iDestoryCount = $iDestoryed
If $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] >= 20 Then
Local $iIndex = 0
For $i = $RESOURCE_STORAGE_FIRSTINDEX To $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]
If Not($aStorage[$i][$RESOURCE_STORAGE_PTR] = Null) Then
$iIndex += 1
For $j = 0 To $RESOURCE_STORAGE_MAX - 1
$aStorage[$iIndex][$j] = $aStorage[$i][$j]
Next
EndIf
Next
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] = $iIndex
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] = 0
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] = $iIndex + $RESOURCE_STORAGE_FIRSTINDEX
ReDim $aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND]][$RESOURCE_STORAGE_MAX]
EndIf
Case $RESOURCE_STORAGE_DESTROYALL
$bReturn = True
For $i = $RESOURCE_STORAGE_FIRSTINDEX To $aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX]
__Resource_Storage_Destroy($aStorage, $i)
Next
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_INDEX] = 0
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_RESETCOUNT] = 0
$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND] = $RESOURCE_STORAGE_FIRSTINDEX
ReDim $aStorage[$aStorage[$RESOURCE_STORAGE][$RESOURCE_STORAGE_UBOUND]][$RESOURCE_STORAGE_MAX]
Case $RESOURCE_STORAGE_GET
Local $iExtended = 0, $pReturn = Null
Return SetExtended($iExtended, $pReturn)
EndSwitch
Return $bReturn
EndFunc
Func __Resource_Storage_Destroy(ByRef $aStorage, $iIndex)
Local $bReturn = False
If Not($aStorage[$iIndex][$RESOURCE_STORAGE_PTR] = Null) Then
$bReturn = __Resource_Destroy($aStorage[$iIndex][$RESOURCE_STORAGE_PTR], $aStorage[$iIndex][$RESOURCE_STORAGE_RESTYPE])
If $bReturn Then
$aStorage[$iIndex][$RESOURCE_STORAGE_PTR] = Null
$aStorage[$iIndex][$RESOURCE_STORAGE_RESLANG] = Null
$aStorage[$iIndex][$RESOURCE_STORAGE_RESNAMEORID] = Null
$aStorage[$iIndex][$RESOURCE_STORAGE_RESTYPE] = Null
EndIf
EndIf
Return $bReturn
EndFunc
If Not ObjEvent("AutoIt.Error") Then
Global Const $_Zip_COMErrorHandler = ObjEvent("AutoIt.Error", "_Zip_COMErrorFunc")
EndIf
Func _Zip_AddItem($sZipFile, $sItem, $sDestDir = "", $iFlag = 21)
If Not _Zip_DllChk() Then Return SetError(@error, 0, 0)
If Not _IsFullPath($sZipFile) Then Return SetError(3, 0, 0)
If Not _IsFullPath($sItem) Then Return SetError(4, 0, 0)
If Not FileExists($sItem) Then Return SetError(5, 0, 0)
If _IsFullPath($sDestDir) Then Return SetError(6, 0, 0)
$sItem = _Zip_PathStripSlash($sItem)
$sDestDir = _Zip_PathStripSlash($sDestDir)
Local $sNameOnly = _Zip_PathNameOnly($sItem)
Local $iOverwrite = 0
If BitAND($iFlag, 1) Then
$iOverwrite = 1
$iFlag -= 1
EndIf
Local $sTest = $sNameOnly
If $sDestDir <> "" Then $sTest = $sDestDir & "\" & $sNameOnly
Local $itemExists = _Zip_ItemExists($sZipFile, $sTest)
If @error Then Return SetError(7, 0, 0)
If $itemExists Then
If @extended Then
Return SetError(8, 0, 0)
Else
If $iOverwrite Then
_Zip_InternalDelete($sZipFile, $sTest)
If @error Then Return SetError(10, 0, 0)
Else
Return SetError(9, 0, 0)
EndIf
EndIf
EndIf
Local $sTempFile = ""
If $sDestDir <> "" Then
$sTempFile = _Zip_AddPath($sZipFile, $sDestDir)
If @error Then Return SetError(11, 0, 0)
EndIf
Local $oNS = _Zip_GetNameSpace($sZipFile, $sDestDir)
$oNS.CopyHere($sItem, $iFlag)
Do
Sleep(250)
Until IsObj($oNS.ParseName($sNameOnly))
If $sTempFile <> "" Then
_Zip_InternalDelete($sZipFile, $sDestDir & "\" & $sTempFile)
If @error Then Return SetError(12, 0, 0)
EndIf
Return 1
EndFunc
Func _Zip_COMErrorFunc()
EndFunc
Func _Zip_Create($sFileName, $iOverwrite = 0)
If FileExists($sFileName) And Not $iOverwrite Then Return SetError(1, 0, 0)
Local $hFp = FileOpen($sFileName, 2 + 8 + 16)
If $hFp = -1 Then Return SetError(2, 0, 0)
FileWrite($hFp, Binary("0x504B0506000000000000000000000000000000000000"))
FileClose($hFp)
Return $sFileName
EndFunc
Func _Zip_ItemExists($sZipFile, $sItem)
If Not _Zip_DllChk() Then Return SetError(@error, 0, 0)
If Not _IsFullPath($sZipFile) Then Return SetError(3, 0, 0)
Local $sPath = ""
$sItem = _Zip_PathStripSlash($sItem)
If StringInStr($sItem, "\") Then
$sPath = _Zip_PathPathOnly($sItem)
$sItem = _Zip_PathNameOnly($sItem)
EndIf
Local $oNS = _Zip_GetNameSpace($sZipFile, $sPath)
If Not IsObj($oNS) Then Return SetError(4, 0, 0)
Local $oItem = $oNS.ParseName($sItem)
If IsObj($oItem) Then Return SetExtended(Number($oItem.IsFolder), 1)
Return 0
EndFunc
Func _IsFullPath($sPath)
If StringInStr($sPath, ":\") Then
Return True
Else
Return False
EndIf
EndFunc
Func _Zip_AddPath($sZipFile, $sPath)
If Not _Zip_DllChk() Then Return SetError(@error, 0, 0)
If Not _IsFullPath($sZipFile) Then Return SetError(3, 0, 0)
Local $oNS = _Zip_GetNameSpace($sZipFile)
If Not IsObj($oNS) Then Return SetError(4, 0, 0)
$sPath = _Zip_PathStripSlash($sPath)
Local $sNewPath = "", $sFileName = ""
If $sPath <> "" Then
Local $aDir = StringSplit($sPath, "\"), $oTest
For $i = 1 To $aDir[0]
$oTest = $oNS.ParseName($aDir[$i])
If IsObj($oTest) Then
If Not $oTest.IsFolder Then Return SetError(5, 0, 0)
$oNS = $oTest.GetFolder
Else
Local $sTempDir = _Zip_CreateTempDir()
If @error Then Return SetError(6, 0, 0)
Local $oTemp = _Zip_GetNameSpace($sTempDir)
For $i = $i To $aDir[0]
$sNewPath &= $aDir[$i] & "\"
Next
DirCreate($sTempDir & "\" & $sNewPath)
$sFileName = _Zip_CreateTempName()
$sNewPath &= $sFileName
FileClose(FileOpen($sTempDir & "\" & $sNewPath, 2 + 8))
$oNS.CopyHere($oTemp.Items())
Do
Sleep(250)
Until _Zip_ItemExists($sZipFile, $sNewPath)
DirRemove($sTempDir, 1)
ExitLoop
EndIf
Next
EndIf
Return $sFileName
EndFunc
Func _Zip_CreateTempDir()
Local $s_TempName
Do
$s_TempName = ""
While StringLen($s_TempName) < 7
$s_TempName &= Chr(Random(97, 122, 1))
WEnd
$s_TempName = @TempDir & "\~" & $s_TempName & ".tmp"
Until Not FileExists($s_TempName)
If Not DirCreate($s_TempName) Then Return SetError(1, 0, 0)
Return $s_TempName
EndFunc
Func _Zip_CreateTempName()
Local $GUID = DllStructCreate("dword Data1;word Data2;word Data3;byte Data4[8]")
DllCall("ole32.dll", "int", "CoCreateGuid", "ptr", DllStructGetPtr($GUID))
Local $ret = DllCall("ole32.dll", "int", "StringFromGUID2", "ptr", DllStructGetPtr($GUID), "wstr", "", "int", 40)
If @error Then Return SetError(1, 0, "")
Return StringRegExpReplace($ret[2], "[}{-]", "")
EndFunc
Func _Zip_DllChk()
If Not FileExists(@SystemDir & "\zipfldr.dll") Then Return SetError(1, 0, 0)
If Not RegRead("HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}", "") Then Return SetError(2, 0, 0)
Return 1
EndFunc
Func _Zip_GetNameSpace($sZipFile, $sPath = "")
If Not _Zip_DllChk() Then Return SetError(@error, 0, 0)
If Not _IsFullPath($sZipFile) Then Return SetError(3, 0, 0)
Local $oApp = ObjCreate("Shell.Application")
Local $oNS = $oApp.NameSpace($sZipFile)
If Not IsObj($oNS) Then Return SetError(4, 0, 0)
If $sPath <> "" Then
Local $aPath = StringSplit($sPath, "\")
Local $oItem
For $i = 1 To $aPath[0]
$oItem = $oNS.ParseName($aPath[$i])
If Not IsObj($oItem) Then Return SetError(5, 0, 0)
$oNS = $oItem.GetFolder
If Not IsObj($oNS) Then Return SetError(6, 0, 0)
Next
EndIf
Return $oNS
EndFunc
Func _Zip_InternalDelete($sZipFile, $sFileName)
If Not _Zip_DllChk() Then Return SetError(@error, 0, 0)
If Not _IsFullPath($sZipFile) Then Return SetError(3, 0, 0)
Local $sPath = ""
$sFileName = _Zip_PathStripSlash($sFileName)
If StringInStr($sFileName, "\") Then
$sPath = _Zip_PathPathOnly($sFileName)
$sFileName = _Zip_PathNameOnly($sFileName)
EndIf
Local $oNS = _Zip_GetNameSpace($sZipFile, $sPath)
If Not IsObj($oNS) Then Return SetError(4, 0, 0)
Local $oFolderItem = $oNS.ParseName($sFileName)
If Not IsObj($oFolderItem) Then Return SetError(5, 0, 0)
Local $sTempDir = _Zip_CreateTempDir()
If @error Then Return SetError(6, 0, 0)
Local $oApp = ObjCreate("Shell.Application")
$oApp.NameSpace($sTempDir).MoveHere($oFolderItem, 20)
DirRemove($sTempDir, 1)
$oFolderItem = $oNS.ParseName($sFileName)
If IsObj($oFolderItem) Then
Return SetError(7, 0, 0)
Else
Return 1
EndIf
EndFunc
Func _Zip_PathNameOnly($sPath)
Return StringRegExpReplace($sPath, ".*\\", "")
EndFunc
Func _Zip_PathPathOnly($sPath)
Return StringRegExpReplace($sPath, "^(.*)\\.*?$", "${1}")
EndFunc
Func _Zip_PathStripSlash($sString)
Return StringRegExpReplace($sString, "(^\\+|\\+$)", "")
EndFunc
Local $sMetricsServer = "https://metrics-so.meteorthelizard.com/"
Local $bMetricsReachable = False
Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET",$sMetricsServer & "418",False)
$oHTTP.Send()
If $oHTTP.Status == 200 Then
$bMetricsReachable = True
EndIf
$oHTTP = NULL
Func fSendMetric($sType)
If not $bMetricsReachable or(not @Compiled and $sType <> "event_running_uncompiled") Then Return
Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET",$sMetricsServer & $sType,False)
$oHTTP.setRequestHeader("User-Agent","SMITE_SO/1.0")
$oHTTP.Option(4) = 13056
$oHTTP.Send()
$oHTTP = NULL
EndFunc
Func LoadImageResource($Ctrl,$PathDir,$ResourceName)
If FileExists($PathDir) Then
GUICtrlSetImage($Ctrl,$PathDir)
Else
_Resource_SetToCtrlID($Ctrl,$ResourceName)
EndIf
EndFunc
AutoItSetOption("GUIOnEventMode",1)
AutoItSetOption("MouseCoordMode",0)
AutoItSetOption("MustDeclareVars",1)
Global Const $MainResourcePath = @ScriptDir & "\Resource\"
Global $ProgramName = "SMITE Optimizer (X84)"
If @AutoItX64 == 1 Then $ProgramName = "SMITE Optimizer (X64)"
Global Const $ProgramVersion = "1.3.7.9"
Global Const $ScrW = @DesktopWidth
Global Const $ScrH = @DesktopHeight
Global Const $MinWidth = 810
Global Const $MinHeight = 450
Global Const $sEmpty = ""
Global Const $ChangelogText = _Resource_GetAsString("ChangelogText")
_Resource_LoadFont("MainFont")
If @Error and @Compiled Then
fSendMetric("error_font_code10")
MsgBox(0,"Error!","Critical error while loading the fonts! Code: 010")
Exit
EndIf
_Resource_LoadFont("MenuFont")
If @Error and @Compiled Then
fSendMetric("error_font_code11")
MsgBox(0,"Error!","Critical error while loading the fonts! Code: 011")
Exit
EndIf
_Resource_LoadFont("InttFont")
If @Error and @Compiled Then
fSendMetric("error_font_code21")
MsgBox(0,"Error!","Critical error while loading the fonts! Code: 021")
Exit
EndIf
_Resource_LoadFont("ResCFont")
If @Error and @Compiled Then
fSendMetric("error_font_code22")
MsgBox(0,"Error!","Critical error while loading the fonts! Code: 022")
Exit
EndIf
If not @Compiled Then
fSendMetric("event_running_uncompiled")
EndIf
Global Const $MainFontName = "Monofonto"
Global Const $MenuFontName = "Montserrat"
Global Const $InttFontName = "PT Root UI Bold"
Global Const $ResCFontName = "Lambda"
Global $MenuSelected = 1
Global $MainGUIMaximizedState = False
Global $MainGUIButtonMaximize = NULL
Global $MainGUITitleBarBG = NULL
Global $GUIMoreOptionsTitleBarBG = NULL
Global $MainGUIMenuBackground = NULL
Global $NotificationGUI = NULL
Global $GUIMoreOptions = NULL
Global $ProcessUI = NULL
Global $ProcessingRequest = False
Global $ResPromptGUI = NULL
Global $HomeSimpleComboResLastIndex
Global $HomeAdvancedComboResLastIndex
Global $UpdateTimer = NULL
Global $UpdateColorState = False
Global $bDiscordIconState = False
Global $DiscordFlashTimer = NULL
Global $bShouldFlashDiscordIcon = False
Local $sRegRead = RegRead("HKCU\Software\SMITE Optimizer\","bShouldFlashDiscord")
If @Error and $sRegRead <> "1" Then
$bShouldFlashDiscordIcon = True
$DiscordFlashTimer = TimerInit()
EndIf
Global $MainGUIHomeDiscoveryDrawn = False
Global $HoverBGDrawn = False
Global $HoverImageDrawn = False
Global $LastMousePosX, $LastMousePosY
Global $HoverTimer = NULL
Global $DisplayHoverBG = 0
Global $DisplayHoverImage = 0
Global $LastHoverID = 0
Global $HoverID = 0
Global $HoverTipAlpha = 0
Global $JustTabbedBackIn = -1
Global $SupressHoverImage = False
Global $HelpIsAnimating = False
Global $MenuPopupState = False
Global $LastReadScrResSimple
Global $LastScreenResScaleSimple
Global $LastReadScrResAdvanced
Global $LastScreenResScaleAdvanced
Global $MainGUIButtonCloseBool = False
Global $MainGUIButtonMaximizeBool = False
Global $MainGUIButtonMinimizeBool = False
Global $MainGUIButtonDiscordBool = False
Global $HomeIconHoverHideBool = False
Global $FixesIconHoverHideBool = False
Global $RCIconHoverHideBool = False
Global $DonateIconHoverHideBool = False
Global $bTriedToShowDonateBanner = False
Global $ChangelogIconHoverHideBool = False
Global $CopyrightIconHoverHideBool = False
Global $DebugIconHoverHideBool = False
Global $SteamBtnHoverHideBool = False
Global $EGSBtnHoverHideBool = False
Global $LegacyBtnHoverHideBool = False
Global $ViewOnlineChangesBtnHoverBool = False
Global $WebsiteOpenHoverBool = False
Global $LicenseLabelHoverBool = False
Global $SourceLabelHoverBool = False
Global $AutoItLicenseLabelHoverBool = False
Global $PrivacyPolicyLabelHoverBool = False
Global $GDPRLabelHoverBool = False
Global $WebsiteMetricsLabelHoverBool = False
Global $iCurrentFrameCopyrightGIF = 0
Global $MainGUICopyrightAnimatedLogoID = NULL
Global $MainGUIDebugLabelHoverBool = False
Global $MainGUIDebugDumpInfoHoverBool = False
Global $Bool_DisplaySetupError = False
Global $cAccentColor = 0xC11F1F
Global $cBackgroundColor = 0x00
Global $cTextColor = 0xF3F6FB
Global $cTextShadowColor = 0x00
Global $cURLColor = 0x4F89EA
Global $cURLHoverColor = 0x0645AD
Global $sDiscordURL = "https://discord.gg/h2g7R9rt7F"
Global $sAlert = ""
fInitHives()
Global $Version = RegRead("HKCU\Software\SMITE Optimizer\","ProgramVersion")
If @Error = 0 and $Version <= "1.2.2" Then
fSendMetric("event_oldversion_compat")
RegDelete("HKCU\Software\SMITE Optimizer\","BlockDonations")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPath")
RegDelete("HKCU\Software\SMITE Optimizer\","DonateInfoStatus")
RegDelete("HKCU\Software\SMITE Optimizer\","PerformUpdate")
RegDelete("HKCU\Software\SMITE Optimizer\","UpdateCheck")
RegDelete("HKCU\Software\SMITE Optimizer\","ProgramPath")
EndIf
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigVerifyIntegrityOnApply")
Global $bProperClose = RegRead("HKCU\Software\SMITE Optimizer\","NotClosedProperly")
If not @Error Then
fSendMetric("error_notclosed_properly")
MsgBox(0,"Information","SMITE Optimizer did not close properly. If you experience issues when applying the settings, we recommend disabling the integrity check in the debug tab." & @CRLF & @CRLF & "We also recommend checking out the 'common issues' in the debug tab for help.")
EndIf
Global $CheckForUpdates = RegRead("HKCU\Software\SMITE Optimizer\","ConfigCheckForUpdates")
If @Error Then $CheckForUpdates = "1"
Global $SettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
If @Error Then $SettingsPath = $sEmpty
Global $SystemSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
If @Error Then $SystemSettingsPath = $sEmpty
Global $GameSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathGame")
If @Error Then $GameSettingsPath = $sEmpty
Global $ProgramState = RegRead("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
If @Error Then $ProgramState = $sEmpty
Global $ProgramHomeState = RegRead("HKCU\Software\SMITE Optimizer\","ConfigSimpleOrAdvanced")
If @Error Then $ProgramHomeState = "Simple"
Global $ConfigBackupPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigBackupPath")
If @Error Then $ConfigBackupPath = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders","Personal")&"\My Games\SMITE\Backups\"
Global $ProgramHomeHelpState = RegRead("HKCU\Software\SMITE Optimizer\","ConfigShowHints")
If @Error Then $ProgramHomeHelpState = 1
If(($SettingsPath = $sEmpty or $SystemSettingsPath = $sEmpty or $GameSettingsPath = $sEmpty) or not FileExists($SettingsPath) or not FileExists($SystemSettingsPath) or not FileExists($GameSettingsPath)) and RegRead("HKCU\Software\SMITE Optimizer\","ProgramVersion") <> $sEmpty Then
fSendMetric("error_missing_config_files")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathGame")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
$SettingsPath = $sEmpty
$SystemSettingsPath = $sEmpty
$GameSettingsPath = $sEmpty
$ProgramState = $sEmpty
EndIf
RegWrite("HKCU\Software\SMITE Optimizer\","ProgramVersion","REG_SZ",$ProgramVersion)
If FileExists(@TempDir & "/SO_UpdatedVer.exe") Then FileDelete(@TempDir & "/SO_UpdatedVer.exe")
Local $GLOBAL_MAIN_GUI
Local $Win_Min_ResizeX = 145
Local $Win_Min_ResizeY = 45
Func _GUI_EnableDragAndResize($mGUI,$GUI_WIDTH,$GUI_HEIGHT,$Min_ResizeX = $Win_Min_ResizeX,$Min_ResizeY = $Win_Min_ResizeY)
Global $GLOBAL_MAIN_GUI = $mGUI, $Win_Min_ResizeX = $Min_ResizeX, $Win_Min_ResizeY = $Min_ResizeY
GUIRegisterMsg(0x0024,"INTERNAL_WM_GETMINMAXINFO")
GUIRegisterMsg(0x0084,"INTERNAL_WM_NCHITTEST")
GUIRegisterMsg(0x0083,"INTERNAL_WM_NCCALCSIZE")
GUIRegisterMsg(0x0201,"INTERNAL_WM_LBUTTONDOWN")
GUIRegisterMsg(0x0005,"INTERNAL_WM_SIZING")
GUIRegisterMsg(0x0086,"INTERNAL_WM_NCACTIVATE")
WinMove($mGUI,$sEmpty,Default,Default,$GUI_WIDTH,$GUI_HEIGHT)
EndFunc
Func _GUI_DragAndResizeUpdate($mGUI,$Min_ResizeX = $Win_Min_ResizeX,$Min_ResizeY = $Win_Min_ResizeY)
Global $GLOBAL_MAIN_GUI = $mGUI, $Win_Min_ResizeX = $Min_ResizeX, $Win_Min_ResizeY = $Min_ResizeY
GUIRegisterMsg(0x0024,"INTERNAL_WM_GETMINMAXINFO")
GUIRegisterMsg(0x0084,"INTERNAL_WM_NCHITTEST")
GUIRegisterMsg(0x0083,"INTERNAL_WM_NCCALCSIZE")
GUIRegisterMsg(0x0201,"INTERNAL_WM_LBUTTONDOWN")
GUIRegisterMsg(0x0005,"INTERNAL_WM_SIZING")
GUIRegisterMsg(0x0086,"INTERNAL_WM_NCACTIVATE")
EndFunc
Func _GUI_EnableDrag($mGUI,$GUI_WIDTH,$GUI_HEIGHT,$Min_ResizeX = $Win_Min_ResizeX,$Min_ResizeY = $Win_Min_ResizeY)
Global $GLOBAL_MAIN_GUI = $mGUI, $Win_Min_ResizeX = $Min_ResizeX, $Win_Min_ResizeY = $Min_ResizeY
GUIRegisterMsg(0x0201,"INTERNAL_WM_LBUTTONDOWN")
GUIRegisterMsg(0x0086,"INTERNAL_WM_NCACTIVATE")
WinMove($mGUI,$sEmpty,Default,Default,$GUI_WIDTH,$GUI_HEIGHT)
EndFunc
Func INTERNAL_WM_NCACTIVATE($hWnd)
If $hWnd = $GLOBAL_MAIN_GUI Then Return -1
EndFunc
Func INTERNAL_WM_SIZING($hWnd)
If $hWnd = $GLOBAL_MAIN_GUI and WinGetState($GLOBAL_MAIN_GUI) = 47 Then
Local $WorkingSize = _GetDesktopWorkArea_Main($GLOBAL_MAIN_GUI)
Local $aWinPos = WinGetPos($GLOBAL_MAIN_GUI)
_WinAPI_SetWindowPos($GLOBAL_MAIN_GUI,$HWND_TOP,$aWinPos[0]-1,$aWinPos[1]-1,$WorkingSize[2],$WorkingSize[3],$SWP_NOREDRAW)
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize2NoActivate.jpg","Maximize2NoActivate")
$MainGUIMaximizedState = True
EndIf
EndFunc
Func INTERNAL_WM_GETMINMAXINFO($hWnd,$iMsg,$wParam,$lParam)
Local $tMinMaxInfo = DllStructCreate("int;int;int;int;int;int;int;int;int;dword",$lParam)
Local $WorkingSize = _GetDesktopWorkArea_Main($GLOBAL_MAIN_GUI)
DllStructSetData($tMinMaxInfo,3,$WorkingSize[2])
DllStructSetData($tMinMaxInfo,4,$WorkingSize[3])
DllStructSetData($tMinMaxInfo,5,$WorkingSize[0]+1)
DllStructSetData($tMinMaxInfo,6,$WorkingSize[1]+1)
DllStructSetData($tMinMaxInfo,7,$Win_Min_ResizeX)
DllStructSetData($tMinMaxInfo,8,$Win_Min_ResizeY)
FixCopyrightGIFPosition()
Return 0
EndFunc
Func INTERNAL_WM_NCCALCSIZE($hWnd)
If $hWnd = $GLOBAL_MAIN_GUI Then Return 0
Return 'GUI_RUNDEFMSG'
EndFunc
Local $WasChanged = False
Func INTERNAL_WM_NCHITTEST($hWnd)
If $hWnd = $GLOBAL_MAIN_GUI Then
Local $iSide = 0, $iTopBot = 0, $CurSorInfo = 0
Local $mPos = MouseGetPos()
Local $aWinPos = WinGetPos($GLOBAL_MAIN_GUI)
Local $aCurInfo = GUIGetCursorInfo($GLOBAL_MAIN_GUI)
If not @Error Then
If $aCurInfo[0] < 3 Then $iSide = 1
If $aCurInfo[0] > $aWinPos[2] - 3 Then $iSide = 2
If $aCurInfo[1] < 3 Then $iTopBot = 3
If $aCurInfo[1] > $aWinPos[3] - 3 Then $iTopBot = 6
$CurSorInfo = $iSide + $iTopBot
EndIf
If $mPos[0] >=($aWinPos[0] + 2) and $mPos[0] <=($aWinPos[0] + $aWinPos[2] - 2) and $mPos[1] >=($aWinPos[1] + 2) and $mPos[1] <=($aWinPos[1] + 25) Then
GUISetCursor(2,1)
EndIf
If WinGetState($GLOBAL_MAIN_GUI) <> 47 Then
If $aCurInfo[4] = 0 Then
Local $Return_HT = 2, $Set_Cursor = 2
Switch $CurSorInfo
Case 1
$Set_Cursor = 13
$Return_HT = 10
Case 2
$Set_Cursor = 13
$Return_HT = 11
Case 3
$Set_Cursor = 11
$Return_HT = 12
Case 4
$Set_Cursor = 12
$Return_HT = 13
Case 5
$Set_Cursor = 10
$Return_HT = 14
Case 6
$Set_Cursor = 11
$Return_HT = 15
Case 7
$Set_Cursor = 10
$Return_HT = 16
Case 8
$Set_Cursor = 12
$Return_HT = 17
EndSwitch
$WasChanged = True
GUISetCursor($Set_Cursor,1)
Return $Return_HT
EndIf
EndIf
EndIf
If $WasChanged Then
GUISetCursor(2,1)
$WasChanged = False
EndIf
Return "GUI_RUNDEFMSG"
EndFunc
Func INTERNAL_WM_LBUTTONDOWN($hWnd)
If $DisplayHoverImage <> 0 and $HoverImageDrawn Then
$DisplayHoverImage = 0
WinMove($HoverInfoGUI,$sEmpty,-$ScrW * 2,-$ScrH * 2,0,0)
$HoverImageDrawn = False
EndIf
If $hWnd = $GLOBAL_MAIN_GUI and WinGetState($GLOBAL_MAIN_GUI) <> 47 Then
Local $aCurInfo = GUIGetCursorInfo($GLOBAL_MAIN_GUI)
If $aCurInfo[4] = $MainGUITitleBarBG or $aCurInfo[4] = $GUIMoreOptionsTitleBarBG Then
If $bTriedToShowDonateBanner Then
UndoMenuHoverState()
EndIf
DllCall("user32.dll","int","ReleaseCapture")
DllCall("user32.dll","long","SendMessage","hwnd",$GLOBAL_MAIN_GUI,"int",0x00A1,"int",2,"int",0)
EndIf
EndIf
EndFunc
Func _GetDesktopWorkArea_Main($hWnd)
Local $MonitorSizePos[4], $MonitorNumber = 1
$MonitorSizePos[0] = 0
$MonitorSizePos[1] = 0
$MonitorSizePos[2] = @DesktopWidth
$MonitorSizePos[3] = @DesktopHeight
Local $aPos, $MonitorList = _WinAPI_EnumDisplayMonitors()
If @Error Then Return $MonitorSizePos
If IsArray($MonitorList) Then
ReDim $MonitorList[$MonitorList[0][0] + 1][5]
For $i = 1 To $MonitorList[0][0]
$aPos = _WinAPI_GetPosFromRect($MonitorList[$i][1])
For $j = 0 To 3
$MonitorList[$i][$j + 1] = $aPos[$j]
Next
Next
EndIf
Local $GUI_Monitor = _WinAPI_MonitorFromWindow($hWnd)
Local $Taskbar_Monitor = _WinAPI_MonitorFromWindow(WinGetHandle("[CLASS:Shell_TrayWnd]"))
For $iM = 1 To $MonitorList[0][0] Step 1
If $MonitorList[$iM][0] = $GUI_Monitor Then
$MonitorSizePos[0] = 0
$MonitorSizePos[1] = 0
$MonitorSizePos[2] = $MonitorList[$iM][3]
$MonitorSizePos[3] = $MonitorList[$iM][4]
$MonitorNumber = $iM
EndIf
Next
Local $TaskBarAutoHide = DllCall("shell32.dll","int","SHAppBarMessage","int",0x00000004,"ptr*",0)
If not @Error Then
$TaskBarAutoHide = $TaskBarAutoHide[0]
Else
$TaskBarAutoHide = 0
EndIf
If $Taskbar_Monitor = $GUI_Monitor Then
Local $TaskBarPos = WinGetPos("[CLASS:Shell_TrayWnd]")
If @Error Then Return $MonitorSizePos
If $TaskBarPos[0] = $MonitorList[$MonitorNumber][1] - 2 or $TaskBarPos[1] = $MonitorList[$MonitorNumber][2] - 2 Then
$TaskBarPos[0] = $TaskBarPos[0] + 2
$TaskBarPos[1] = $TaskBarPos[1] + 2
$TaskBarPos[2] = $TaskBarPos[2] - 4
$TaskBarPos[3] = $TaskBarPos[3] - 4
EndIf
If $TaskBarPos[0] = $MonitorList[$MonitorNumber][1] - 2 or $TaskBarPos[1] = $MonitorList[$MonitorNumber][2] - 2 Then
$TaskBarPos[0] = $TaskBarPos[0] + 2
$TaskBarPos[1] = $TaskBarPos[1] + 2
$TaskBarPos[2] = $TaskBarPos[2] - 4
$TaskBarPos[3] = $TaskBarPos[3] - 4
EndIf
If $TaskBarPos[2] = $MonitorSizePos[2] Then
If $TaskBarAutoHide = 1 Then
If($TaskBarPos[1] > 0) Then
$MonitorSizePos[3] -= 1
Else
$MonitorSizePos[1] += 1
$MonitorSizePos[3] -= 1
EndIf
Return $MonitorSizePos
EndIf
$MonitorSizePos[3] = $MonitorSizePos[3] - $TaskBarPos[3]
If $TaskBarPos[0] = $MonitorList[$MonitorNumber][1] and $TaskBarPos[1] = $MonitorList[$MonitorNumber][2] Then $MonitorSizePos[1] = $TaskBarPos[3]
Else
If $TaskBarAutoHide = 1 Then
If $TaskBarPos[0] > 0 Then
$MonitorSizePos[2] -= 1
Else
$MonitorSizePos[0] += 1
$MonitorSizePos[2] -= 1
EndIf
Return $MonitorSizePos
EndIf
$MonitorSizePos[2] = $MonitorSizePos[2] - $TaskBarPos[2]
If $TaskBarPos[0] = $MonitorList[$MonitorNumber][1] and $TaskBarPos[1] = $MonitorList[$MonitorNumber][2] Then $MonitorSizePos[0] = $TaskBarPos[2]
EndIf
EndIf
Return $MonitorSizePos
EndFunc
OnAutoItExitRegister("ProperExit")
Local $bProperOnce = False
Func ProperExit()
If not $bProperOnce Then
$bProperOnce = True
fSendMetric("event_exit")
EndIf
If IsDeclared("IndexerPID") Then ProcessClose($IndexerPID)
If FileExists(@TempDir & "\SO_Index.bat") Then FileDelete(@TempDir & "\SO_Index.bat")
If FileExists(@TempDir & "\SO_Index.txt") Then FileDelete(@TempDir & "\SO_Index.txt")
If FileExists(@TempDir & "\GPL_License.txt") Then FileDelete(@TempDir & "\GPL_License.txt")
If FileExists(@TempDir & "\AutoIt_License.txt") Then FileDelete(@TempDir & "\AutoIt_License.txt")
If FileExists(@TempDir & "\CommonIssues.txt") Then FileDelete(@TempDir & "\CommonIssues.txt")
RegDelete("HKCU\Software\SMITE Optimizer\","NotClosedProperly")
__GIFExtended_ShutDown()
_GDIPlus_Shutdown()
Exit
EndFunc
Global $SplashScreenGUI = GUICreate($ProgramName,600,125,-1,-1,$WS_POPUP)
Local $SplashScreenGUIAnimationStart, $SplashScreenGUIAnimationLoop, $iCtrl
If @Compiled Then
Local $aRet = GUICtrlCreateGIF( _Resource_GetAsImage("SO_StartGIF") ,0,0,600,100,90,10,True)
$SplashScreenGUIAnimationStart = $aRet[0]
$iCtrl = $aRet[1]
Else
Local $aRet = GUICtrlCreateGIF($MainResourcePath & "Splash_Start.gif",0,0,600,100,90,10)
$SplashScreenGUIAnimationStart = $aRet[0]
$iCtrl = $aRet[1]
EndIf
Global $SplashScreenGUIProgress = GUiCtrlCreateProgress(0,100,600,25)
GUICtrlSetColor(-1,$cAccentColor)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",$sEmpty,"wstr",$sEmpty)
Global $SplashScreenGUILabelStatusBG = GUICtrlCreateLabelTransparentBG("Initializing..",1,106,600,20,$SS_CENTER)
GUICtrlSetColor(-1,$cTextShadowColor)
Global $SplashScreenGUILabelStatus = GUICtrlCreateLabelTransparentBG("Initializing..",0,105,600,20,$SS_CENTER)
GUISetState(@SW_SHOWNOACTIVATE,$SplashScreenGUI)
_WinAPI_SetWindowPos($SplashScreenGUI,$HWND_TOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
_WinAPI_SetWindowPos($SplashScreenGUI,$HWND_NOTOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
Func SplashScreenWriteStatus($Progress,$Text)
If not IsDeclared("SplashScreenGUI") Then Return
If $SplashScreenGUI <> NULL Then
GUICtrlSetData($SplashScreenGUIProgress,$Progress)
GUICtrlSetData($SplashScreenGUILabelStatusBG,$Text)
GUICtrlSetData($SplashScreenGUILabelStatus,$Text)
EndIf
EndFunc
Local $bSpawnedAnim = False
While True
If $__g_GIFExtended_aStoreCache[$iCtrl][13] = 88 and not $bSpawnedAnim Then
$bSpawnedAnim = True
If @Compiled Then
$SplashScreenGUIAnimationLoop = GUICtrlCreateGIF( _Resource_GetAsImage("SO_LoopGIF") ,0,0,600,100,90,10,True)[0]
Else
$SplashScreenGUIAnimationLoop = GUICtrlCreateGIF($MainResourcePath & "Splash_Loop.gif",0,0,600,100,90,10)[0]
EndIf
EndIf
If $__g_GIFExtended_aStoreCache[$iCtrl][13] >= 89 and $bSpawnedAnim Then
GUICtrlDeleteGIF($SplashScreenGUIAnimationStart)
ExitLoop
EndIf
WEnd
fSendMetric("event_start")
Func _IniMem_Read($s_ini,$s_Section,$s_key,$s_default = $sEmpty)
$s_ini = StringSplit($s_ini,@CRLF)
For $x = 1 To $s_ini[0]
If $s_ini[$x] = "[" & $s_Section & "]" Then ExitLoop
Next
If $x < $s_ini[0] Then
For $i = $x+1 To $s_ini[0]
If StringLeft($s_ini[$i],1) = "[" and StringRight($s_ini[$i],1) = "]" Then ExitLoop
If $s_ini[$i] = $sEmpty Then ContinueLoop
If StringLeft($s_ini[$i],StringLen($s_key)) = $s_key Then
$s_default = StringTrimLeft($s_ini[$i],StringLen($s_key) + 1)
ExitLoop
EndIf
Next
EndIf
If StringLeft($s_default,1) = '"' Then $s_default = StringTrimLeft($s_default,1)
If StringRight($s_default,1) = '"' Then $s_default = StringTrimRight($s_default,1)
Return $s_default
EndFunc
Global $UpdateAvailable = False
If $CheckForUpdates = "1" Then SplashScreenWriteStatus(25,"Checking for Updates")
fSendMetric("updater_init")
Local $agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0"
Local $sUpdateProvider = "update-so.meteorthelizard.com"
SplashScreenWriteStatus(25,"Checking for Updates (update-so.meteorthelizard.com)")
Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET","https://update-so.meteorthelizard.com/update.ini",False)
$oHTTP.setRequestHeader("User-Agent",$agent)
$oHTTP.Option(4) = 13056
$oHTTP.Send()
Local $UpdateGet = $oHTTP.ResponseText
$oHTTP = NULL
If not $UpdateGet Then
fSendMetric("error_updater_mtl_failed")
SplashScreenWriteStatus(25,"Checking for Updates (meteorthelizard.github.io)")
Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET","https://meteorthelizard.github.io/SMITE-Optimizer-Update/",False)
$oHTTP.setRequestHeader("User-Agent",$agent)
$oHTTP.Option(4) = 13056
$oHTTP.Send()
$UpdateGet = $oHTTP.ResponseText
$oHTTP = NULL
$sUpdateProvider = "meteorthelizard.github.io"
If not $UpdateGet Then
fSendMetric("error_updater_github_failed")
SplashScreenWriteStatus(25,"Checking for Updates (pastebin.com)")
Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET","https://pastebin.com/raw/SXnHTU9H",False)
$oHTTP.setRequestHeader("User-Agent",$agent)
$oHTTP.Option(4) = 13056
$oHTTP.Send()
$UpdateGet = $oHTTP.ResponseText
$oHTTP = NULL
$sUpdateProvider = "pastebin.com"
If not $UpdateGet Then
fSendMetric("error_updater_failed_connect")
MsgBox($MB_OK,"Error","Could not connect to the update servers.")
WinActivate($SplashScreenGUI)
EndIf
EndIf
EndIf
If $UpdateGet Then
fSendMetric("updater_retrieve_success")
$UpdateGet = BinaryToString($UpdateGet)
Local $RemoteVersion = _IniMem_Read($UpdateGet,"Version","Version",$ProgramVersion)
Local $RemoteDownload32 = _IniMem_Read($UpdateGet,"Download","Download32",$sEmpty)
Local $RemoteDownload64 = _IniMem_Read($UpdateGet,"Download","Download64",$sEmpty)
Local $RemoteMessage = _IniMem_Read($UpdateGet,"Message","Message",$sEmpty)
Local $RemoteAlert = _IniMem_Read($UpdateGet,"Alert","Alert",$sEmpty)
Local $RemoteURL = _IniMem_Read($UpdateGet,"URL","URL",$sEmpty)
If $RemoteAlert <> $sEmpty Then
$sAlert = $RemoteAlert
EndIf
If $RemoteURL <> $sEmpty Then
$sDiscordURL = $RemoteURL
EndIf
If $RemoteVersion > $ProgramVersion Then
$UpdateTimer = TimerInit()
$UpdateAvailable = True
Local $ForceUpdate = RegRead("HKCU\Software\SMITE Optimizer\","DebugForceUpdate")
If @Error Then
$ForceUpdate = False
Else
$ForceUpdate = True
EndIf
If $CheckForUpdates = "1" or $ForceUpdate Then
fSendMetric("updater_can_update")
RegDelete("HKCU\Software\SMITE Optimizer\","DebugForceUpdate")
RegWrite("HKCU\Software\SMITE Optimizer\","UpdateProvider",$sUpdateProvider)
SplashScreenWriteStatus(0,"Preparing to download an update..")
Local $NewFileSize, $NewFile
If @AutoItX64 = 1 Then
$NewFileSize = INetGetSize($RemoteDownload64,$INET_FORCERELOAD)
$NewFile = INetGet($RemoteDownload64,@TempDir & "/SO_UpdatedVer.exe",BitOr($INET_FORCERELOAD,$INET_IGNORESSL),$INET_DOWNLOADBACKGROUND)
Else
$NewFileSize = INetGetSize($RemoteDownload32,$INET_FORCERELOAD)
$NewFile = INetGet($RemoteDownload32,@TempDir & "/SO_UpdatedVer.exe",BitOr($INET_FORCERELOAD,$INET_IGNORESSL),$INET_DOWNLOADBACKGROUND)
EndIf
Local $LastPercent = 0
Local $Percent = 0
Do
Local $Bytes = INetGetInfo($NewFile,0)
$Percent = Floor((100 / $NewFileSize) * $Bytes)
If $Percent <> $LastPercent Then
SplashScreenWriteStatus($Percent,"Downloading Update ( "&$Percent&"% - " & Floor($Bytes/1024) & " / " & Floor($NewFileSize/1024) & " KB. )")
$LastPercent = $Percent
EndIf
Sleep(10)
Until INetGetInfo($NewFile,2)
INetClose($NewFile)
If FileExists(@TempDir & "/SO_UpdatedVer.exe") Then
fSendMetric("updater_preparing_for_update")
FileWrite(@TempDir & "\SO_Update.bat","CHCP 65001"&@CRLF&"@echo off"&@CRLF&"Cls"&@CRLF&"timeout /t 0.5 /nobreak"&@CRLF&'del "'&@ScriptFullPath&'" /f /q'&@CRLF&'copy /Y "'&@TempDir & '\SO_UpdatedVer.exe"'&' "'&@ScriptFullPath&'" >nul'&@CRLF&'start "" "'&@ScriptFullPath&'"'&@CRLF&'del "'&@TempDir & "\SO_Update.bat"&'" /f /q'&@CRLF&"Exit")
If FileExists(@TempDir & "\SO_Update.bat") Then
Run(@TempDir & "\SO_Update.bat",$sEmpty,@SW_HIDE)
Exit
Else
fSendMetric("error_updater_code7")
MsgBox($MB_OK,"Error","There was an unexpected error during the update process. Code: 007"&@CRLF&"If this error is persistent, please try to update manually.")
WinActivate($SplashScreenGUI)
EndIf
Else
fSendMetric("error_updater_code6")
MsgBox($MB_OK,"Error","There was an unexpected error during the update process. Code: 006"&@CRLF&"If this error is persistent, please try to update manually.")
WinActivate($SplashScreenGUI)
EndIf
EndIf
EndIf
EndIf
Local $WindowsUIFont = "Segoe UI"
If @OSVersion <> "WIN_VISTA" and @OSVersion <> "WIN_7" and @OSVersion <> "WIN_8" and @OSVersion <> "WIN_81" and @OSVersion <> "WIN_10" and @OSVersion <> "WIN_11" Then
$WindowsUIFont = $MenuFontName
EndIf
Func GUICtrlCreateLabelTransparentBG($Text,$X = 0,$Y = 0,$Size_X = 0,$Size_Y = 0,$Style = Default)
Local $Obj = GUICtrlCreateLabel($Text,$X,$Y,$Size_X,$Size_Y,$Style)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,$cTextColor)
GUICtrlSetFont(-1,Default,Default,Default,$MainFontName,BitOr(4,5))
Return $Obj
EndFunc
Func GUICtrlCreateCheckboxTransparentBG($X = 0,$Y = 0,$Size_X = 0,$Size_Y = 0)
Local $Obj = GUICtrlCreateCheckbox($sEmpty,$X,$Y,$Size_X,$Size_Y)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
Return $Obj
EndFunc
Func GUICtrlCreateComboNoTheme($Str,$X = 0,$Y = 0,$Size_X = 0,$Size_Y = 0,$Style = $sEmpty)
Local $Obj = GUICtrlCreateCombo($Str,$X,$Y,$Size_X,$Size_Y,$Style)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetFont(-1,9,Default,Default,$InttFontName,BitOr(4,5))
Return $Obj
EndFunc
Func GUICtrlCreateInputSO($sStr,$iX,$iY,$iSize_X,$iSize_Y,$iStyle = $sEmpty)
Local $Obj = GUICtrlCreateInput($sStr,$iX,$iY,$iSize_X,$iSize_Y,$iStyle)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetFont(-1,9,Default,Default,$InttFontName,BitOr(4,5))
Return $Obj
EndFunc
Func GUICtrlCreateButtonSO($GUI,$sStr,$X,$Y,$W,$H,$cBackgroundColor = $cBackgroundColor,$cTextColor = $cTextColor,$cAccentColor = $cAccentColor)
Local $Obj = _SOCtrlButtons_Create($GUI,$sStr,$X,$Y,$W,$H,$cBackgroundColor,$cTextColor,$WindowsUIFont,8,1,$cAccentColor)
Return $Obj
EndFunc
SplashScreenWriteStatus(100,"Loading Interface")
Global $MenuStartPos = 41
Func CreateMenuObject($Name,$State = False)
Local $Array[3]
Local $HoverIDVar = GUICtrlCreatePic($sEmpty,5,$MenuStartPos-5,43,40)
LoadImageResource($HoverIDVar,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
GUICtrlSetOnEvent($HoverIDVar,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Local $IconVar = GUICtrlCreatePic($sEmpty,10,$MenuStartPos,30,30)
LoadImageResource($IconVar,$MainResourcePath & $Name&"IconInactive.jpg",$Name&"IconInactive")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetStyle(-1,$WS_EX_TOPMOST)
$Array[0] = $HoverIDVar
$Array[1] = $IconVar
If not $State Then
Local $IconSelectorVar = GUICtrlCreatePic($sEmpty,0,$MenuStartPos-5,5,40)
LoadImageResource($IconSelectorVar,$MainResourcePath & "MenuSelector.jpg","MenuSelector")
GUICtrlSetOnEvent($IconVar,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetStyle(-1,$WS_EX_TOPMOST)
GUICtrlSetState(-1,$GUI_HIDE)
$Array[2] = $IconSelectorVar
EndIf
$MenuStartPos =($MenuStartPos + 40)
Return $Array
EndFunc
Func DrawMainGUI()
Global $MainGUI = GUICreate($ProgramName,$MinWidth,$MinHeight,-$ScrW,-$ScrH,BitOR($WS_SIZEBOX,$WS_MINIMIZEBOX,$WS_MAXIMIZEBOX))
_GUI_EnableDragAndResize($MainGUI,$MinWidth,$MinHeight,$MinWidth,$MinHeight)
GUISetBkColor(0x2D2D2D)
GUICtrlSetDefColor($cTextColor,$MainGUI)
GUICtrlSetDefBkColor($cBackgroundColor,$MainGUI)
Global $MainGUITitleBarBG = GUICtrlCreatePic($sEmpty,2,34,$MinWidth-4,$MinHeight - 36)
LoadImageResource($MainGUITitleBarBG,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
GUICtrlSetResizing(-1,$GUI_DOCKBORDERS)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUITitleBarBG = GUICtrlCreatePic($sEmpty,2,2,$MinWidth-2,34)
LoadImageResource($MainGUITitleBarBG,$MainResourcePath & "TopBar.jpg","TopBar")
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUIMenuTitleIcon = GUICtrlCreatePic($sEmpty,18,9,16,16)
LoadImageResource($MainGUIMenuTitleIcon,$MainResourcePath & "SMITEOptimizerIcon.jpg","SMITEOptimizerIcon")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIMenuTitle = GUICtrlCreateLabelTransparentBG($ProgramName,50,9,130,15)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
Global $MainGUIButtonClose = GUICtrlCreatePic($sEmpty,$MinWidth - 34,0,34,34)
LoadImageResource($MainGUIButtonClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
GUICtrlSetOnEvent($MainGUIButtonClose,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIButtonMaximize = GUICtrlCreatePic($sEmpty,$MinWidth - 68,0,34,34)
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize1NoActivate.jpg","Maximize1NoActivate")
GUICtrlSetOnEvent($MainGUIButtonMaximize,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIButtonMinimize = GUICtrlCreatePic($sEmpty,$MinWidth - 102,0,34,34)
LoadImageResource($MainGUIButtonMinimize,$MainResourcePath & "MinimizeNoActivate.jpg","MinimizeNoActivate")
GUICtrlSetOnEvent($MainGUIButtonMinimize,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIButtonDiscord = GUICtrlCreatePic($sEmpty,$MinWidth - 140,2,38,32)
LoadImageResource($MainGUIButtonDiscord,$MainResourcePath & "DiscordIconInActive.jpg","DiscordIconInActive")
GUICtrlSetOnEvent($MainGUIButtonDiscord,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Local $Text = "Discovery"
If $ProgramState <> $sEmpty Then $Text = $ProgramState
Global $MainGUILabelProgramState = GUICtrlCreateLabelTransparentBG("("&$Text&" mode)",-1000,17,-1,25,$SS_RIGHT)
Local $Width = ControlGetPos($MainGUI,$sEmpty,$MainGUILabelProgramState)[2] + 25
GUICtrlSetPos(-1,$MinWidth - $Width - 144,17,$Width,25)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
Local $Text = "v"&$ProgramVersion
If $UpdateAvailable Then $Text = "(Update available) v"&$ProgramVersion
Global $MainGUILabelVersion = GUICtrlCreateLabelTransparentBG($Text,-1000,3,-1,14,$SS_RIGHT)
Local $Width = ControlGetPos($MainGUI,$sEmpty,$MainGUILabelVersion)[2] + 25
GUICtrlSetPos(-1,$MinWidth - $Width - 146,3,$Width,14)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
Global $MainGUIMenuBackground = GUICtrlCreatePic($sEmpty,0,36,50,$MinHeight - 164)
LoadImageResource($MainGUIMenuBackground,$MainResourcePath & "MenuBG.jpg","MenuBG")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetState(-1,$GUI_DISABLE)
Local $Obj = CreateMenuObject("Home")
Global $HomeIconHover = $Obj[0], $HomeIcon = $Obj[1], $HomeIconSelector = $Obj[2]
GUICtrlSetState($HomeIconSelector,$GUI_SHOW)
Local $Obj = CreateMenuObject("Fixes")
Global $FixesIconHover = $Obj[0], $FixesIcon = $Obj[1], $FixesIconSelector = $Obj[2]
GUICtrlSetState($FixesIconSelector,$GUI_HIDE)
Local $Obj = CreateMenuObject("RestoreConfigs")
Global $RCIconHover = $Obj[0], $RCIcon = $Obj[1], $RCIconSelector = $Obj[2]
$MenuStartPos =($MenuStartPos + 2)
Local $MenuSeperator = GUICtrlCreatePic($sEmpty,0,$MenuStartPos-7,48,2)
LoadImageResource($MenuSeperator,$MainResourcePath & "MenuSelectorHorizontal.jpg","MenuSelectorHorizontal")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Local $Obj = CreateMenuObject("Donate")
Global $DonateIconHover = $Obj[0], $DonateIcon = $Obj[1], $DonateIconSelector = $Obj[2]
Local $Obj = CreateMenuObject("Changelog")
Global $ChangelogIconHover = $Obj[0], $ChangelogIcon = $Obj[1], $ChangelogIconSelector = $Obj[2]
Local $Obj = CreateMenuObject("Copyright")
Global $CopyrightIconHover = $Obj[0], $CopyrightIcon = $Obj[1], $CopyrightIconSelector = $Obj[2]
$MenuStartPos =($MenuStartPos + 2)
Local $MenuSeperator = GUICtrlCreatePic($sEmpty,0,$MenuStartPos-7,48,2)
LoadImageResource($MenuSeperator,$MainResourcePath & "MenuSelectorHorizontal.jpg","MenuSelectorHorizontal")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Local $Obj = CreateMenuObject("Debug")
Global $DebugIconHover = $Obj[0], $DebugIcon = $Obj[1], $DebugIconSelector = $Obj[2]
InitGUI()
GUICtrlDeleteGIF($SplashScreenGUIAnimationLoop)
GUIDelete($SplashScreenGUI)
$SplashScreenGUI = NULL
WinMove($MainGUI,$sEmpty,$ScrW/2 -($MinWidth/2),$ScrH/2 -($MinHeight/2))
GUISetState(@SW_SHOWNOACTIVATE,$MainGUI)
If $Bool_DisplaySetupError Then
fSendMetric("error_not_launched_smite_before")
DisplayErrorMessage("Please make sure to launch the game at least once before using the program!" & @CRLF & @CRLF & "Choosing anything before doing that will cause problems!",$MainGUI,"IMPORTANT!")
EndIf
If $sAlert <> $sEmpty Then
Local $bShouldDisplay = RegRead("HKCU\Software\SMITE Optimizer\","sLastAlert")
If $bShouldDisplay <> $sAlert Then
fSendMetric("event_displayed_developer_message")
DisplayErrorMessage($sAlert,$MainGUI,"Message from the developers!")
RegWrite("HKCU\Software\SMITE Optimizer\","sLastAlert","REG_SZ",$sAlert)
EndIf
EndIf
EndFunc
DrawMainGUI()
Func InitGUI()
Global $MainGUIHomeHelpBackground = GUICtrlCreatePic($sEmpty,-$MinWidth,-$MinHeight,1,1)
LoadImageResource($MainGUIHomeHelpBackground,$MainResourcePath & "HelpHoverBG.jpg","HelpHoverBG")
GUICtrlSetState(-1,$GUI_DISABLE)
Global $HoverInfoGUI = GUICreate($sEmpty,0,0,0,0,$WS_POPUP,$WS_EX_TOOLWINDOW,$MainGUI)
Global $MainGUIHomeHelpImage = GUICtrlCreatePic($sEmpty,0,0)
LoadImageResource($MainGUIHomeHelpImage,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
GUICtrlSetState(-1,$GUI_DISABLE)
Global $HoverInfoGUIImageAnimation = NULL
GUISetState(@SW_SHOWNOACTIVATE,$HoverInfoGUI)
GUISwitch($MainGUI)
Global $MainGUIHomeLabelWelcome = GUICtrlCreateLabelTransparentBG("Thank you for choosing the SMITE Optimizer!",152,65,700,30)
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,18,500,Default,$MenuFontName)
Global $MainGUIHomeLabelGetStarted = GUICtrlCreateLabelTransparentBG("Please select the launcher you used to install SMITE on your system.",227,100,700,30)
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIHomePicBtnSteam = GUICtrlCreatePic($sEmpty,110,150,300,100)
LoadImageResource($MainGUIHomePicBtnSteam,$MainResourcePath & "SteamBtnInActive.jpg","SteamBtnInActive")
GUICtrlSetOnEvent($MainGUIHomePicBtnSteam,"SetupPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIHomePicBtnEGS = GUICtrlCreatePic($sEmpty,450,150,300,100)
LoadImageResource($MainGUIHomePicBtnEGS,$MainResourcePath & "EGSBtnInActive.jpg","EGSBtnInActive")
GUICtrlSetOnEvent($MainGUIHomePicBtnEGS,"SetupPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIHomePicBtnLegacy = GUICtrlCreatePic($sEmpty,279,265,300,100)
LoadImageResource($MainGUIHomePicBtnLegacy,$MainResourcePath & "LegacyBtnInActive.jpg","LegacyBtnInActive")
GUICtrlSetOnEvent($MainGUIHomePicBtnLegacy,"SetupPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIHomeButtonMoreOptions = GUICtrlCreateButtonSO($MainGUI,"More Options",379,379,100,25)
GUICtrlSetOnEvent($MainGUIHomeButtonMoreOptions,"SetupPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
If not(FileExists(@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleEngine.ini") and FileExists(@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini") and FileExists(@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleGame.ini") ) Then
If not(FileExists("C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini") and FileExists("C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini") and FileExists("C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleGame.ini") ) Then
$Bool_DisplaySetupError = True
EndIf
EndIf
Global $MainGUIHomeButtonApply = GUICtrlCreateButtonSO($MainGUI,"Apply changes",696,401,100,35)
GUICtrlSetOnEvent($MainGUIHomeButtonApply,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIHomeButtonFixConfig = GUICtrlCreateButtonSO($MainGUI,"Verify and repair",696-105,401,100,35)
GUICtrlSetOnEvent($MainGUIHomeButtonFixConfig,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIHomeSwitchModeSimple = GUICtrlCreateRadio($sEmpty,10,404,13,13)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetOnEvent($MainGUIHomeSwitchModeSimple,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
If $ProgramHomeState = "Simple" Then GUICtrlSetState(-1,$GUI_CHECKED)
Global $MainGUIHomeLabelModeSimple = GUICtrlCreateLabelTransparentBG("Simple",27,403,-1,13)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIHomeSwitchModeAdvanced = GUICtrlCreateRadio($sEmpty,10,422,13,13)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetOnEvent($MainGUIHomeSwitchModeAdvanced,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
If $ProgramHomeState = "Advanced" Then GUICtrlSetState(-1,$GUI_CHECKED)
Global $MainGUIHomeLabelModeAdvanced = GUICtrlCreateLabelTransparentBG("Advanced",27,422,-1,13)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIHomeButtonUseMaxPerformance = GUICtrlCreateButtonSO($MainGUI,"Use high performance settings",157,401,200,35)
GUICtrlSetOnEvent($MainGUIHomeButtonUseMaxPerformance,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIHomeButtonRestoreDefaults = GUICtrlCreateButtonSO($MainGUI,"Restore default settings",362,401,150,35)
GUICtrlSetOnEvent($MainGUIHomeButtonRestoreDefaults,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIHomeCheckboxDisplayHints = GUICtrlCreateCheckboxTransparentBG(160,384,13,13)
GUICtrlSetOnEvent($MainGUIHomeCheckboxDisplayHints,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$ProgramHomeHelpState)
Global $MainGUIHomeLabelDisplayHints = GUICtrlCreateLabelTransparentBG("Show help",178,384,-1,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Internal_ProcessScreenRes()
Local $TypeOptions = "Best|High|Medium|Low|Very Low|Minimum|Potato|Lowest Possible"
Local $WindowOptions = "Fullscreen|Borderless Window|Windowed"
Global $MainGUIHomeSimpleLabelWorldQuality = GUICtrlCreateLabelTransparentBG("World Quality",100,74,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboWorldQuality = GUICtrlCreateComboNoTheme($sEmpty,100,88,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeSimpleLabelCharacterQuality = GUICtrlCreateLabelTransparentBG("Character Quality",100,114,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboCharacterQuality = GUICtrlCreateComboNoTheme($sEmpty,100,128,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeSimpleLabelShadowQuality = GUICtrlCreateLabelTransparentBG("Shadow Quality",100,154,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboShadowQuality = GUICtrlCreateComboNoTheme($sEmpty,100,168,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeSimpleLabelSkyQuality = GUICtrlCreateLabelTransparentBG("Sky Quality",100,194,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboSkyQuality = GUICtrlCreateComboNoTheme($sEmpty,100,208,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeSimpleLabelEffectsParticleQuality = GUICtrlCreateLabelTransparentBG("Effects Quality",100,234,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboEffectsParticleQuality = GUICtrlCreateComboNoTheme($sEmpty,100,248,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeSimpleLabelMaxFPS = GUICtrlCreateLabelTransparentBG("Desired FPS (Uncap)",100,274,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleInputMaxFPS = GUICtrlCreateInputSO($sEmpty,100,288,190,21)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetLimit(-1,3)
Global $MainGUIHomeSimpleLabelScreenRes = GUICtrlCreateLabelTransparentBG("Resolution",300,74,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboScreenRes = GUICtrlCreateComboNoTheme($sEmpty,300,88,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$AvailableResolutionsStr)
GUICtrlSetFont(-1,9,Default,Default,$ResCFontName,BitOr(4,5))
Global $MainGUIHomeSimpleLabelScreenResScale = GUICtrlCreateLabelTransparentBG("Resolution Scale",300,114,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleSliderScreenResScale = GUICtrlCreateSlider(300,128,190,21)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetLimit(-1,200,50)
Global $MainGUIHomeSimpleInputScreenResScale = GUICtrlCreateInputSO($sEmpty,500,128,40,21,$ES_READONLY)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelWindowmode = GUICtrlCreateLabelTransparentBG("Window Type",300,154,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboWindowmode = GUICtrlCreateComboNoTheme($sEmpty,300,168,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$WindowOptions)
Global $MainGUIHomeSimpleLabelAntialiasing = GUICtrlCreateLabelTransparentBG("Anti-Aliasing (FXAA)",300,194,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboAntialiasing = GUICtrlCreateComboNoTheme($sEmpty,300,208,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,"High|Medium|Low|Off")
Global $MainGUIHomeSimpleLabelMaxAnisotropy = GUICtrlCreateLabelTransparentBG("Anisotropic Filter Level",300,234,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboMaxAnisotropy = GUICtrlCreateComboNoTheme($sEmpty,300,248,190,21,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,"16x|8x|4x|2x|Off")
Global $MainGUIHomeSimpleLabelDetailMode = GUICtrlCreateLabelTransparentBG("DetailMode",300,274,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboDetailMode = GUICtrlCreateComboNoTheme($sEmpty,300,288,190,21,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,"0|1|2")
Global $MainGUIHomeSimpleCheckboxVSync = GUICtrlCreateCheckboxTransparentBG(595,84,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelVSync = GUICtrlCreateLabelTransparentBG("Use Vertical Synchronisation",613,88,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleCheckboxRagdollPhysics = GUICtrlCreateCheckboxTransparentBG(595,104,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelRagdollPhysics = GUICtrlCreateLabelTransparentBG("Use Ragdoll Physics",613,108,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleCheckboxDirectX11 = GUICtrlCreateCheckboxTransparentBG(595,124,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelDirectX11 = GUICtrlCreateLabelTransparentBG("Use DirectX11",613,128,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxDirectX11,$GUI_DISABLE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxDirectX11,$GUI_CHECKED)
Global $MainGUIHomeSimpleCheckboxBloom = GUICtrlCreateCheckboxTransparentBG(595,152,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelBloom = GUICtrlCreateLabelTransparentBG("Bloom",613,156,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleCheckboxDecals = GUICtrlCreateCheckboxTransparentBG(595,172,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelDecals = GUICtrlCreateLabelTransparentBG("Decals",613,176,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleCheckboxDynamicLightShadows = GUICtrlCreateCheckboxTransparentBG(595,192,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelDynamicLightShadows = GUICtrlCreateLabelTransparentBG("Dynamic Lights and Shadows",613,196,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleCheckboxLensflares = GUICtrlCreateCheckboxTransparentBG(595,212,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelLensflares = GUICtrlCreateLabelTransparentBG("Lensflares",613,216,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleCheckboxReflections = GUICtrlCreateCheckboxTransparentBG(595,232,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelReflections = GUICtrlCreateLabelTransparentBG("Reflections",613,236,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleCheckboxHighQualityMats = GUICtrlCreateCheckboxTransparentBG(595,252,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleLabelHighQualityMats = GUICtrlCreateLabelTransparentBG("Uncompressed Textures",613,256,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelWorldQuality = GUICtrlCreateLabelTransparentBG("World Quality",55,39,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboWorldQuality = GUICtrlCreateComboNoTheme($sEmpty,55,53,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelCharacterQuality = GUICtrlCreateLabelTransparentBG("Character Quality",55,79,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboCharacterQuality = GUICtrlCreateComboNoTheme($sEmpty,55,93,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelTerrainQuality = GUICtrlCreateLabelTransparentBG("Terrain Quality",55,119,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboTerrainQuality = GUICtrlCreateComboNoTheme($sEmpty,55,133,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelNPCQuality = GUICtrlCreateLabelTransparentBG("NPC Quality",55,159,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboNPCQuality = GUICtrlCreateComboNoTheme($sEmpty,55,173,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelWeaponQuality = GUICtrlCreateLabelTransparentBG("Weapon Quality",55,199,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboWeaponQuality = GUICtrlCreateComboNoTheme($sEmpty,55,213,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelVehicleQuality = GUICtrlCreateLabelTransparentBG("Vehicle Quality",55,239,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboVehicleQuality = GUICtrlCreateComboNoTheme($sEmpty,55,253,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelShadowsQuality = GUICtrlCreateLabelTransparentBG("Shadow Quality",55,279,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboShadowsQuality = GUICtrlCreateComboNoTheme($sEmpty,55,293,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelParticleQualityLevel = GUICtrlCreateLabelTransparentBG("Particle Quality Level",55,319,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboParticleQualityLevel = GUICtrlCreateComboNoTheme($sEmpty,55,333,190,21,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,"Best|High|Medium|Low")
Global $MainGUIHomeAdvancedLabelSkyQuality = GUICtrlCreateLabelTransparentBG("Sky Quality",255,39,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboSkyQuality = GUICtrlCreateComboNoTheme($sEmpty,255,53,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelEffectsParticleQuality = GUICtrlCreateLabelTransparentBG("Effects Quality",255,79,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboEffectsParticleQuality = GUICtrlCreateComboNoTheme($sEmpty,255,93,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$TypeOptions)
Global $MainGUIHomeAdvancedLabelScreenRes = GUICtrlCreateLabelTransparentBG("Resolution",255,119,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboScreenRes = GUICtrlCreateComboNoTheme($sEmpty,255,133,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$AvailableResolutionsStr)
GUICtrlSetFont(-1,9,Default,Default,$ResCFontName,BitOr(4,5))
Global $MainGUIHomeAdvancedLabelScreenResScale = GUICtrlCreateLabelTransparentBG("Resolution Scale",255,159,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedSliderScreenResScale = GUICtrlCreateSlider(255,173,190,21)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetLimit(-1,200,50)
Global $MainGUIHomeAdvancedInputScreenResScale = GUICtrlCreateInputSO($sEmpty,455,173,40,21,$ES_READONLY)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelWindowmode = GUICtrlCreateLabelTransparentBG("Window Type",255,199,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboWindowmode = GUICtrlCreateComboNoTheme($sEmpty,255,213,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$WindowOptions)
Global $MainGUIHomeAdvancedLabelAntialiasing = GUICtrlCreateLabelTransparentBG("Anti-Aliasing (FXAA)",255,239,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboAntialiasing = GUICtrlCreateComboNoTheme($sEmpty,255,253,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,"High|Medium|Low|Off")
Global $MainGUIHomeAdvancedLabelMaxAnisotropy = GUICtrlCreateLabelTransparentBG("Anisotropic Filter Level",255,279,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboMaxAnisotropy = GUICtrlCreateComboNoTheme($sEmpty,255,293,190,21,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,"16x|8x|4x|2x|Off")
Global $MainGUIHomeAdvancedLabelMaxFPS = GUICtrlCreateLabelTransparentBG("Desired FPS (Uncap)",255,319,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedInputMaxFPS = GUICtrlCreateInputSO($sEmpty,255,333,190,21)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetLimit(-1,3)
Global $MainGUIHomeAdvancedCheckboxSpeedTreeWind = GUICtrlCreateCheckboxTransparentBG(455,49,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelSpeedTreeWind = GUICtrlCreateLabelTransparentBG("SpeedTree Wind",473,52,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxSpeedTreeLeaves = GUICtrlCreateCheckboxTransparentBG(455,69,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelSpeedTreeLeaves = GUICtrlCreateLabelTransparentBG("SpeedTree Leaves",473,72,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxSpeedTreeFronds = GUICtrlCreateCheckboxTransparentBG(455,89,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelSpeedTreeFronds = GUICtrlCreateLabelTransparentBG("SpeedTree Fronds",473,92,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelSpeedTreeLODBias = GUICtrlCreateLabelTransparentBG("SpeedTree LOD Bias",455,116,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboSpeedTreeLODBias = GUICtrlCreateComboNoTheme($sEmpty,455,133,110,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,"0|1|2")
Global $MainGUIHomeAdvancedLabelDetailMode = GUICtrlCreateLabelTransparentBG("DetailMode",515,163,100,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedComboDetailMode = GUICtrlCreateComboNoTheme($sEmpty,515,179,85,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,"0|1|2")
Global $MainGUIHomeAdvancedCheckboxVSync = GUICtrlCreateCheckboxTransparentBG(455,209,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelVSync = GUICtrlCreateLabelTransparentBG("Use Vertical Sync.",473,213,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxPhysX = GUICtrlCreateCheckboxTransparentBG(455,229,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelPhysX = GUICtrlCreateLabelTransparentBG("Use Ragdoll Physics",473,233,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxDX11 = GUICtrlCreateCheckboxTransparentBG(455,249,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelDX11 = GUICtrlCreateLabelTransparentBG("Use DirectX11",473,253,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDX11,$GUI_DISABLE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDX11,$GUI_CHECKED)
Global $MainGUIHomeAdvancedCheckboxBloom = GUICtrlCreateCheckboxTransparentBG(455,269,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelBloom = GUICtrlCreateLabelTransparentBG("Bloom",473,273,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxLensflares = GUICtrlCreateCheckboxTransparentBG(455,289,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelLensflares = GUICtrlCreateLabelTransparentBG("Lensflares",473,293,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxReflections = GUICtrlCreateCheckboxTransparentBG(455,309,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelReflections = GUICtrlCreateLabelTransparentBG("Reflections",473,313,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxUncText = GUICtrlCreateCheckboxTransparentBG(455,329,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelUncText = GUICtrlCreateLabelTransparentBG("Uncompressed Textures",473,333,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxLightShafts = GUICtrlCreateCheckboxTransparentBG(620,49,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelLightShafts = GUICtrlCreateLabelTransparentBG("Light Shafts",638,53,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxFogVolumes = GUICtrlCreateCheckboxTransparentBG(620,69,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelFogVolumes = GUICtrlCreateLabelTransparentBG("Fog Volumes",638,72,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxDistortion = GUICtrlCreateCheckboxTransparentBG(620,89,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelDistortion = GUICtrlCreateLabelTransparentBG("Distortion",638,93,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxFilteredDistortion = GUICtrlCreateCheckboxTransparentBG(620,109,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelFilteredDistortion = GUICtrlCreateLabelTransparentBG("Filtered Distortion",638,113,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxDropShadows = GUICtrlCreateCheckboxTransparentBG(620,129,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelDropShadows = GUICtrlCreateLabelTransparentBG("Drop Shadows",638,133,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxWholeSceneShadows = GUICtrlCreateCheckboxTransparentBG(620,149,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelWholeSceneShadows = GUICtrlCreateLabelTransparentBG("Whole Scene Dominant Shadows",638,153,170,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxConservShadowBounds = GUICtrlCreateCheckboxTransparentBG(620,169,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelConservShadowBounds = GUICtrlCreateLabelTransparentBG("Conservative Shadow Bounds",638,173,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxLightEnvShadows = GUICtrlCreateCheckboxTransparentBG(620,189,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelLightEnvShadows = GUICtrlCreateLabelTransparentBG("Light Environment Shadows",638,193,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxStaticDecals = GUICtrlCreateCheckboxTransparentBG(620,209,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelStaticDecals = GUICtrlCreateLabelTransparentBG("Static Decals",638,213,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxDynamicDecals = GUICtrlCreateCheckboxTransparentBG(620,229,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelDynamicDecals = GUICtrlCreateLabelTransparentBG("Dynamic Decals",638,233,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxUnbatchedDecals = GUICtrlCreateCheckboxTransparentBG(620,249,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelUnbatchedDecals = GUICtrlCreateLabelTransparentBG("Unbatched Decals",638,253,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxDynamicLights = GUICtrlCreateCheckboxTransparentBG(620,269,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelDynamicLights = GUICtrlCreateLabelTransparentBG("Dynamic Lights",638,273,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxCompDynamicLights = GUICtrlCreateCheckboxTransparentBG(620,289,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelCompDynamicLights = GUICtrlCreateLabelTransparentBG("Composite Dynamic Lights",638,293,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxSHSecondaryLighting = GUICtrlCreateCheckboxTransparentBG(620,309,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelSHSecondaryLighting = GUICtrlCreateLabelTransparentBG("SH Secondary Lighting",638,313,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedCheckboxDynamicShadows = GUICtrlCreateCheckboxTransparentBG(620,329,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedLabelDynamicShadows = GUICtrlCreateLabelTransparentBG("Dynamic Shadows",638,333,160,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Internal_LoadSettingCookies(False,False,True)
GUICtrlSetData($MainGUIHomeSimpleInputScreenResScale,GUICtrlRead($MainGUIHomeSimpleSliderScreenResScale)&"%")
GUICtrlSetData($MainGUIHomeAdvancedInputScreenResScale,GUICtrlRead($MainGUIHomeAdvancedSliderScreenResScale)&"%")
Global $MainGUIFixesLabelMaxFPS = GUICtrlCreateLabelTransparentBG("Desired FPS (Uncap)",80,64,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIFixesInputMaxFPS = GUICtrlCreateInputSO("150",80,78,190,21)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetLimit(-1,3)
Global $MainGUIFixesLabelAudioFix = GUICtrlCreateLabelTransparentBG("Audio Channels",80,104,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIFixesComboAudioFix = GUICtrlCreateComboNoTheme("32",80,118,190,21,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1,"64|128|256|512")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIFixesCheckboxDisableJump = GUICtrlCreateCheckboxTransparentBG(80,154,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIFixesLabelDisableJump = GUICtrlCreateLabelTransparentBG("Disable Jumping",98,158,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIFixesCheckboxDisableFog = GUICtrlCreateCheckboxTransparentBG(80,174,15,21)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIFixesLabelDisableFog = GUICtrlCreateLabelTransparentBG("Disable Fog",98,178,140,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIFixesButtonCreateQuicklaunch = GUICtrlCreateButtonSO($MainGUI,"Create quicklaunch bypass",386,401,150,35)
GUICtrlSetOnEvent($MainGUIFixesButtonCreateQuicklaunch,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIFixesButtonInstallLegacy = GUICtrlCreateButtonSO($MainGUI,"Install legacy launcher",541,401,150,35)
GUICtrlSetOnEvent($MainGUIFixesButtonInstallLegacy,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIFixesButtonApply = GUICtrlCreateButtonSO($MainGUI,"Apply fixes",696,401,100,35)
GUICtrlSetOnEvent($MainGUIFixesButtonApply,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIFixesButtonExportHUD = GUICtrlCreateButtonSO($MainGUI,"Export HUD settings",596,101,150,35)
GUICtrlSetOnEvent($MainGUIFixesButtonExportHUD,"Internal_ExportSettings")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIFixesButtonImportHUD = GUICtrlCreateButtonSO($MainGUI,"Import HUD settings",596,141,150,35)
GUICtrlSetOnEvent($MainGUIFixesButtonImportHUD,"Internal_ImportSettings")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIFixesButtonRepairEAC = GUICtrlCreateButtonSO($MainGUI,"Repair EasyAntiCheat",386,361,150,35)
GUICtrlSetOnEvent($MainGUIFixesButtonRepairEAC,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Local $Int_Settings = RegRead("HKCU\Software\SMITE Optimizer\","ConfigCookieFixes")
If not @Error Then
Local $Split = StringSplit($Int_Settings,"|")
_ArrayDelete($Split,0)
GUICtrlSetData($MainGUIFixesInputMaxFPS,$Split[0])
GUICtrlSetData($MainGUIFixesComboAudioFix,$Split[1])
GUICtrlSetState($MainGUIFixesCheckboxDisableJump,Internal_ConvertMagicNumber($Split[2]))
If uBound($Split) > 3 Then
GUICtrlSetState($MainGUIFixesCheckboxDisableFog,Internal_ConvertMagicNumber($Split[3]))
EndIf
EndIf
Global $MainGUIRestoreConfigurationsListFiles = GUICtrlCreateList($sEmpty,57,43,746,239,BitOR($WS_BORDER,$WS_VSCROLL,$LBS_NOINTEGRALHEIGHT))
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
Internal_UpdateRestoreConfigList()
Global $MainGUIRestoreConfigurationsLabelBackupPath = GUICtrlCreateLabelTransparentBG("Backup Path:",5,410,75,13)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsInputBackupPath = GUICtrlCreateInputSO($ConfigBackupPath,5,425,700,20,$ES_READONLY)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
Global $MainGUIRestoreConfigurationsButtonChangeBackupPath = GUICtrlCreateButtonSO($MainGUI,"Change..",709,424,97,22)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonChangeBackupPath,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsButtonOpenBackupPath = GUICtrlCreateButtonSO($MainGUI,"Open directory",709,399,97,22)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonOpenBackupPath,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsButtonRestoreSelected = GUICtrlCreateButtonSO($MainGUI,"Restore selected",704,284,100,35)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonRestoreSelected,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsButtonRemoveSelected = GUICtrlCreateButtonSO($MainGUI,"Delete selected",601,284,100,35)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonRemoveSelected,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsButtonRefreshList = GUICtrlCreateButtonSO($MainGUI,"Refresh list",498,284,100,25)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonRefreshList,"Internal_UpdateRestoreConfigList")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsCheckboxAskForConfirmation = GUICtrlCreateCheckboxTransparentBG(610,325,15,15)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_CHECKED)
Global $MainGUIRestoreConfigurationsLabelAskForConfirmation = GUICtrlCreateLabelTransparentBG("Ask to confirm action?",630,326,125,15)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsLabelBackupInfo = GUICtrlCreateLabelTransparentBG("Backups of your configuration files are created automagically for you."&@CRLF&"The dates shown are in the following format: DD_MM_YYYY_HH_MM_SS."&@CRLF&"Day, month, year, hour, minute, seconds.",57,283,425,41)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Local $Year = 2024
Global $MainGUIChangelogRichEdit = GUICtrlCreateEdit($ChangelogText,55,41,$MinWidth-60,$MinHeight-46,BitOr($ES_READONLY,$WS_VSCROLL))
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
Global $MainGUIChangelogButtonViewOnlineBG = GUICtrlCreatePic($sEmpty,2,365,48,40)
LoadImageResource($MainGUIChangelogButtonViewOnlineBG,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
GUICtrlSetOnEvent($MainGUIChangelogButtonViewOnlineBG,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIChangelogButtonViewOnline = GUICtrlCreatePic($sEmpty,12,370,30,30)
LoadImageResource($MainGUIChangelogButtonViewOnline,$MainResourcePath & "ChangelogIconInActive.jpg","ChangelogIconInActive")
GUICtrlSetOnEvent($MainGUIChangelogButtonViewOnline,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetStyle(-1,$WS_EX_TOPMOST)
Global $MainGUICopyrightAnimatedLogo
Global $MainGUICopyrightLabelInfo = GUICtrlCreateLabelTransparentBG("A project brought to life by MeteorTheLizard in 2017 and still being maintained in "&$Year&".",88,160,730,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,12,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelLicense = GUICtrlCreateLabelTransparentBG('SMITE Optimizer v1.3 and newer are licensed under the "GNU GPL-3.0" License.',195,189,735,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelLicense2 = GUICtrlCreateLabelTransparentBG("Earlier versions than 1.3 may not be copied, shared, modified, or distributed without permission.",143,207,615,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelCopyright = GUICtrlCreateLabelTransparentBG('SMITE Optimizer Version 1.0 - 1.2.2, Copyright (C) 2019 - Mario "Meteor Thuri" Schien.',177,234,600,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelCopyright2 = GUICtrlCreateLabelTransparentBG('SMITE Optimizer Version 1.3 and newer, Copyright (C) '&$Year&' - Mario "Meteor Thuri" Schien.',161,252,600,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelSMITECopyright = GUICtrlCreateLabelTransparentBG("SMITE(R), Battleground of the Gods(TM) Copyright (C) "&$Year&" Hi-Rez Studios, Inc. All rights reserved.",134,270,600,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelLogoCopyright = GUICtrlCreateLabelTransparentBG("Logos used are subject to copyright and were used under the 'Fair Use' agreement.",181,288,600,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelContact = GUICtrlCreateLabelTransparentBG("contact@meteorthelizard.com",103,317,250,20)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,11,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelWebsite = GUICtrlCreateLabelTransparentBG("https://www.meteorthelizard.com",103,337,250,20)
GUICtrlSetOnEvent($MainGUICopyrightLabelWebsite,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,11,500,Default,$MenuFontName)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetCursor(-1,0)
Global $MainGUICopyrightPicBGLeft = GUICtrlCreatePic($sEmpty,95,361,224,50)
LoadImageResource($MainGUICopyrightPicBGLeft,$MainResourcePath & "CopyrightFooterBGLeft.jpg","CopyrightFooterBGLeft")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUICopyrightLabelVersionFooter = GUICtrlCreateLabelTransparentBG("SMITE Optimizer Version "&$ProgramVersion,103,362,250,18)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,11,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelLicenseLink = GUICtrlCreateLabelTransparentBG("License",102,386,70,23)
GUICtrlSetOnEvent($MainGUICopyrightLabelLicenseLink,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUICopyrightLabelSourceLink = GUICtrlCreateLabelTransparentBG("Source",193,386,65,23)
GUICtrlSetOnEvent($MainGUICopyrightLabelSourceLink,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUICopyrightPicBGRight = GUICtrlCreatePic($sEmpty,368,361,347,50)
LoadImageResource($MainGUICopyrightPicBGRight,$MainResourcePath & "CopyrightFooterBGRight.jpg","CopyrightFooterBGRight")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUICopyrightLabelAutoItCopyright = GUICtrlCreateLabelTransparentBG("AutoIt v3 Copyright (C) 2023 AutoIt Consulting Ltd.",373,365,375,18)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,10,500,Default,$MenuFontName)
Global $MainGUICopyrightLabelAutoitLicenseLink = GUICtrlCreateLabelTransparentBG("AutoIt v3 License",537,386,170,23)
GUICtrlSetOnEvent($MainGUICopyrightLabelAutoitLicenseLink,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUICopyrightLabelPrivacyPolicy = GUICtrlCreateLabelTransparentBG("Privacy Policy",461,312,100,20)
GUICtrlSetOnEvent($MainGUICopyrightLabelPrivacyPolicy,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,11,500,Default,$MenuFontName)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetCursor(-1,0)
Global $MainGUICopyrightLabelGDPR = GUICtrlCreateLabelTransparentBG("GDPR",578,312,45,20)
GUICtrlSetOnEvent($MainGUICopyrightLabelGDPR,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,11,500,Default,$MenuFontName)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetCursor(-1,0)
Global $MainGUICopyrightLabelWebsiteMetrics = GUICtrlCreateLabelTransparentBG("View SO-Metrics Online",455,338,175,20)
GUICtrlSetOnEvent($MainGUICopyrightLabelWebsiteMetrics,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,11,500,Default,$MenuFontName)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetCursor(-1,0)
Local $TempN = @AutoItExe
$TempN = StringSplit($TempN,"\")
If not IsDeclared("SysInfoRead") Then
Local $PID = Run("wmic cpu get name /value",$sEmpty,$sEmpty,0x2)
Global $SysInfoRead
Do
$SysInfoRead &= StdoutRead($PID)
Until @Error
$SysInfoRead = StringTrimLeft(StringStripWS($SysInfoRead,3),5)
Local $objWMIService = ObjGet("winmgmts:\\.\root\CIMV2")
Global $SysInfoOutput
Local $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_DisplayConfiguration","WQL",0x10 + 0x20)
If IsObj($colItems) Then
For $objItem In $colItems
$SysInfoOutput = $objItem.DeviceName
Next
Endif
EndIf
Global $MainGUIDebugPicDebugFooterFooter = GUICtrlCreatePic($sEmpty,60,258,360,181)
LoadImageResource($MainGUIDebugPicDebugFooterFooter,$MainResourcePath & "DebugFooter.jpg","DebugFooter")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUIDebugLabelReportABug = GUICtrlCreateLabelTransparentBG("Report a bug",67,408,120,24)
GUICtrlSetOnEvent($MainGUIDebugLabelReportABug,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUIDebugLabelCreateDebugInfo = GUICtrlCreateLabelTransparentBG("Create debug dump",212,408,178,24)
GUICtrlSetOnEvent($MainGUIDebugLabelCreateDebugInfo,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,$cURLColor)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUIDebugEditSystemInfo = GUICtrlCreateEdit($TempN[uBound($TempN)-1]&" PID("&@AutoItPID&")"&@CRLF&@UserName&" | ( "&@OSVersion&" "&@OSArch&" )"&@CRLF&"CPU: "&$SysInfoRead&@CRLF&regRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment","NUMBER_OF_PROCESSORS")&" Thread(s) @ "&RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~MHz")&" MHz | Architecture: "&@CPUArch&@CRLF&"RAM: "&Floor((MemGetStats()[1]/1000000))&" GB | ( "&Round((MemGetStats()[1]/1000000),2)&" GB )"&@CRLF&"GPU: "&$SysInfoOutput&@CRLF&"Mainboard: "&regRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS","BaseBoardManufacturer")&" | "&regRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS","BaseBoardProduct")& @CRLF &"Last BIOS update: "&regRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS","BIOSReleaseDate"),67,261,400,144,BitOr($ES_READONLY,$ES_WANTRETURN),0)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
Local $DebugEngineSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
If @Error Then $DebugEngineSettingsPath = "Not yet defined"
Global $MainGUIDebugLabelEngineSettings = GUICtrlCreateLabelTransparentBG("EngineSettings: "&$DebugEngineSettingsPath,55,40,750,40)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
Local $DebugSystemSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
If @Error Then $DebugSystemSettingsPath = "Not yet defined"
Global $MainGUIDebugLabelSystemSettings = GUICtrlCreateLabelTransparentBG("SystemSettings: "&$DebugSystemSettingsPath,55,80,750,35)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
Local $DebugGameSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathGame")
If @Error Then $DebugGameSettingsPath = "Not yet defined"
Global $MainGUIDebugLabelGameSettings = GUICtrlCreateLabelTransparentBG("GameSettings: "&$DebugGameSettingsPath,55,120,750,35)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
Local $DebugConfigBackupPath = $ConfigBackupPath
If $ConfigBackupPath = $sEmpty Then $DebugConfigBackupPath = "Not yet defined"
Global $MainGUIDebugLabelConfigBackupPath = GUICtrlCreateLabelTransparentBG("Backup Path: "&$DebugConfigBackupPath,55,160,750,35)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
Global $MainGUIDebugButtonCommonIssues = GUICtrlCreateButtonSO($MainGUI,"Common issues",646,300,130,25)
GUICtrlSetOnEvent($MainGUIDebugButtonCommonIssues,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIDebugButtonResetConfigPaths = GUICtrlCreateButtonSO($MainGUI,"Reset configuration paths",626,401,170,35)
GUICtrlSetOnEvent($MainGUIDebugButtonResetConfigPaths,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIDebugCheckboxCheckForUpdates = GUICtrlCreateCheckboxTransparentBG(627,383,13,13)
GUICtrlSetOnEvent($MainGUIDebugCheckboxCheckForUpdates,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
If $CheckForUpdates = "1" Then GUICtrlSetState($MainGUIDebugCheckboxCheckForUpdates,$GUI_CHECKED)
Global $MainGUIDebugLabelCheckForUpdates = GUICtrlCreateLabelTransparentBG("Automatic updates",646,383,150,13)
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIDebugButtonPerformUpdate = NULL
If $UpdateAvailable Then
fSendMetric("event_automaticupdates_aredisabled")
$MainGUIDebugButtonPerformUpdate = GUICtrlCreateButtonSO($MainGUI,"Perform Update",514,401,100,35)
GUICtrlSetOnEvent($MainGUIDebugButtonPerformUpdate,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
EndIf
If $SettingsPath = $sEmpty or $SystemSettingsPath = $sEmpty or $ProgramState = $sEmpty Then
$MainGUIHomeDiscoveryDrawn = True
UnDrawMainGUIHome()
Else
UnDrawMainGUIHomeConfigDiscovery()
EndIf
UnDrawMainGUIFixes(True)
UnDrawMainGUIRestoreConfigs()
UnDrawMainGUIChangelog()
UnDrawMainGUICopyright()
UnDrawMainGUIDebug()
If $ProgramHomeState = "Simple" Then
UnDrawMainGUIHomeAdvanced()
ElseIf $ProgramHomeState = "Advanced" Then
UnDrawMainGUIHomeSimple()
EndIf
Global $MenuHoverGUI = GUICreate("SO_HOVERGUI",100,50,100,50,$WS_POPUP,$WS_EX_TOOLWINDOW)
GUISwitch($MenuHoverGUI)
GUISetBkColor(0x525252,$MenuHoverGUI)
Global $MainGUIMenuHoverText = GUICtrlCreateLabelTransparentBG($sEmpty,-90,-42,90,42)
GUICtrlSetFont(-1,25,500,0,$MenuFontName)
GUICtrlSetColor(-1,$cTextShadowColor)
Global $MainGUIMenuHoverDBan = GUICtrlCreatePic($sEmpty,0,0,300,80)
LoadImageResource($MainGUIMenuHoverDBan,$MainResourcePath & "DonateBanner.jpg","DonateBanner")
GUICtrlSetState(-1,$GUI_HIDE)
GUISetState(@SW_HIDE,$MenuHoverGUI)
GUISwitch($MainGUI)
EndFunc
Func DrawMainGUIHomeConfigDiscovery()
GUICtrlSetState($MainGUIHomeLabelWelcome,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeLabelGetStarted,$GUI_SHOW)
GUICtrlSetState($MainGUIHomePicBtnSteam,$GUI_SHOW)
GUICtrlSetState($MainGUIHomePicBtnEGS,$GUI_SHOW)
GUICtrlSetState($MainGUIHomePicBtnLegacy,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeButtonMoreOptions,$GUI_SHOW)
$MainGUIHomeDiscoveryDrawn = True
EndFunc
Func UnDrawMainGUIHomeConfigDiscovery()
GUICtrlSetState($MainGUIHomeLabelWelcome,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeLabelGetStarted,$GUI_HIDE)
GUICtrlSetState($MainGUIHomePicBtnSteam,$GUI_HIDE)
GUICtrlSetState($MainGUIHomePicBtnEGS,$GUI_HIDE)
GUICtrlSetState($MainGUIHomePicBtnLegacy,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeButtonMoreOptions,$GUI_HIDE)
$MainGUIHomeDiscoveryDrawn = False
EndFunc
Func DrawMainGUIHome()
GUICtrlSetState($MainGUIHomeButtonApply,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeButtonFixConfig,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSwitchModeSimple,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeLabelModeSimple,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSwitchModeAdvanced,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeLabelModeAdvanced,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeButtonUseMaxPerformance,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeButtonRestoreDefaults,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeCheckboxDisplayHints,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeLabelDisplayHints,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeHelpBackground,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeHelpImage,$GUI_SHOW)
If $ProgramHomeState = "Simple" Then
DrawMainGUIHomeSimple()
ElseIf $ProgramHomeState = "Advanced" Then
DrawMainGUIHomeAdvanced()
EndIf
EndFunc
Func UnDrawMainGUIHome()
GUICtrlSetState($MainGUIHomeButtonApply,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeButtonFixConfig,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSwitchModeSimple,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeLabelModeSimple,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSwitchModeAdvanced,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeLabelModeAdvanced,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeButtonUseMaxPerformance,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeButtonRestoreDefaults,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeCheckboxDisplayHints,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeLabelDisplayHints,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeHelpBackground,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeHelpImage,$GUI_HIDE)
GUICtrlSetPos($MainGUIHomeHelpBackground,-$MinWidth,-$MinHeight,1,1)
$HoverBGDrawn = False
WinMove($HoverInfoGUI,$sEmpty,-$ScrW*2,-$ScrH*2,0,0)
$HoverImageDrawn = False
If $ProgramHomeState = "Simple" Then
UnDrawMainGUIHomeSimple()
ElseIf $ProgramHomeState = "Advanced" Then
UnDrawMainGUIHomeAdvanced()
EndIf
EndFunc
Func DrawMainGUIHomeSimple()
GUICtrlSetState($MainGUIHomeSimpleLabelWorldQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboWorldQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelCharacterQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboCharacterQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelShadowQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboShadowQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelSkyQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboSkyQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelEffectsParticleQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboEffectsParticleQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelScreenRes,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboScreenRes,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelWindowmode,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboWindowmode,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelScreenResScale,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleSliderScreenResScale,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleInputScreenResScale,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelMaxFPS,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleInputMaxFPS,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelAntialiasing,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboAntialiasing,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelMaxAnisotropy,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboMaxAnisotropy,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelDetailMode,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleComboDetailMode,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxVSync,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelVSync,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxRagdollPhysics,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelRagdollPhysics,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxDirectX11,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelDirectX11,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxBloom,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelBloom,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxDecals,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelDecals,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxDynamicLightShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelDynamicLightShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxLensflares,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelLensflares,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxReflections,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelReflections,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleCheckboxHighQualityMats,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeSimpleLabelHighQualityMats,$GUI_SHOW)
EndFunc
Func UnDrawMainGUIHomeSimple()
GUICtrlSetState($MainGUIHomeSimpleLabelWorldQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboWorldQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelCharacterQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboCharacterQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelShadowQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboShadowQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelSkyQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboSkyQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelEffectsParticleQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboEffectsParticleQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelScreenRes,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboScreenRes,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelWindowmode,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboWindowmode,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelScreenResScale,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleSliderScreenResScale,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleInputScreenResScale,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelMaxFPS,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleInputMaxFPS,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelAntialiasing,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboAntialiasing,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelMaxAnisotropy,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboMaxAnisotropy,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelDetailMode,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleComboDetailMode,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxVSync,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelVSync,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxRagdollPhysics,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelRagdollPhysics,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxDirectX11,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelDirectX11,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxBloom,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelBloom,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxDecals,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelDecals,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxDynamicLightShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelDynamicLightShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxLensflares,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelLensflares,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxReflections,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelReflections,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleCheckboxHighQualityMats,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeSimpleLabelHighQualityMats,$GUI_HIDE)
EndFunc
Func DrawMainGUIHomeAdvanced()
GUICtrlSetState($MainGUIHomeAdvancedLabelWorldQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboWorldQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelCharacterQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboCharacterQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelTerrainQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboTerrainQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelNPCQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboNPCQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelWeaponQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboWeaponQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelVehicleQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboVehicleQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelShadowsQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboShadowsQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelParticleQualityLevel,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboParticleQualityLevel,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelSkyQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboSkyQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelEffectsParticleQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboEffectsParticleQuality,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelScreenRes,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboScreenRes,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelScreenResScale,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedSliderScreenResScale,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedInputScreenResScale,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelWindowmode,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboWindowmode,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelAntialiasing,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboAntialiasing,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelMaxAnisotropy,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboMaxAnisotropy,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelMaxFPS,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedInputMaxFPS,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeWind,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelSpeedTreeWind,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeLeaves,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelSpeedTreeLeaves,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeFronds,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelSpeedTreeFronds,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelSpeedTreeLODBias,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboSpeedTreeLODBias,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelDetailMode,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedComboDetailMode,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxVSync,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelVSync,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxPhysX,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelPhysX,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDX11,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelDX11,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxBloom,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelBloom,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLensflares,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelLensflares,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxReflections,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelReflections,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxUncText,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelUncText,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLightEnvShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelLightEnvShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLightShafts,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelLightShafts,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxFogVolumes,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelFogVolumes,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDistortion,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelDistortion,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxFilteredDistortion,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelFilteredDistortion,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDropShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelDropShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxWholeSceneShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelWholeSceneShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxConservShadowBounds,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelConservShadowBounds,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxStaticDecals,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelStaticDecals,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicDecals,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelDynamicDecals,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxUnbatchedDecals,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelUnbatchedDecals,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicLights,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelDynamicLights,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxCompDynamicLights,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelCompDynamicLights,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSHSecondaryLighting,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelSHSecondaryLighting,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicShadows,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeAdvancedLabelDynamicShadows,$GUI_SHOW)
EndFunc
Func UnDrawMainGUIHomeAdvanced()
GUICtrlSetState($MainGUIHomeAdvancedLabelWorldQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboWorldQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelCharacterQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboCharacterQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelTerrainQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboTerrainQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelNPCQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboNPCQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelWeaponQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboWeaponQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelVehicleQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboVehicleQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelShadowsQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboShadowsQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelParticleQualityLevel,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboParticleQualityLevel,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelSkyQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboSkyQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelEffectsParticleQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboEffectsParticleQuality,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelScreenRes,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboScreenRes,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelScreenResScale,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedSliderScreenResScale,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedInputScreenResScale,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelWindowmode,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboWindowmode,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelAntialiasing,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboAntialiasing,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelMaxAnisotropy,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboMaxAnisotropy,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelMaxFPS,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedInputMaxFPS,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeWind,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelSpeedTreeWind,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeLeaves,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelSpeedTreeLeaves,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeFronds,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelSpeedTreeFronds,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelSpeedTreeLODBias,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboSpeedTreeLODBias,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelDetailMode,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedComboDetailMode,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxVSync,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelVSync,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxPhysX,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelPhysX,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDX11,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelDX11,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxBloom,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelBloom,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLensflares,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelLensflares,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxReflections,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelReflections,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxUncText,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelUncText,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLightEnvShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelLightEnvShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLightShafts,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelLightShafts,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxFogVolumes,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelFogVolumes,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDistortion,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelDistortion,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxFilteredDistortion,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelFilteredDistortion,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDropShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelDropShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxWholeSceneShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelWholeSceneShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxConservShadowBounds,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelConservShadowBounds,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxStaticDecals,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelStaticDecals,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicDecals,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelDynamicDecals,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxUnbatchedDecals,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelUnbatchedDecals,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicLights,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelDynamicLights,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxCompDynamicLights,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelCompDynamicLights,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSHSecondaryLighting,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelSHSecondaryLighting,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicShadows,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeAdvancedLabelDynamicShadows,$GUI_HIDE)
EndFunc
Func DrawMainGUIFixes()
GUICtrlSetState($MainGUIFixesLabelMaxFPS,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesInputMaxFPS,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesLabelAudioFix,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesComboAudioFix,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesCheckboxDisableJump,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesLabelDisableJump,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesCheckboxDisableFog,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesLabelDisableFog,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesButtonCreateQuicklaunch,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesButtonInstallLegacy,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesButtonApply,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesButtonImportHUD,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesButtonExportHUD,$GUI_SHOW)
GUICtrlSetState($MainGUIFixesButtonRepairEAC,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeCheckboxDisplayHints,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeLabelDisplayHints,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeHelpBackground,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeHelpImage,$GUI_SHOW)
EndFunc
Func UnDrawMainGUIFixes($bBool = False)
GUICtrlSetState($MainGUIFixesLabelMaxFPS,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesInputMaxFPS,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesLabelAudioFix,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesComboAudioFix,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesCheckboxDisableJump,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesLabelDisableJump,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesCheckboxDisableFog,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesLabelDisableFog,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesButtonCreateQuicklaunch,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesButtonInstallLegacy,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesButtonApply,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesButtonImportHUD,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesButtonExportHUD,$GUI_HIDE)
GUICtrlSetState($MainGUIFixesButtonRepairEAC,$GUI_HIDE)
If not $bBool Then
GUICtrlSetState($MainGUIHomeCheckboxDisplayHints,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeLabelDisplayHints,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeHelpBackground,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeHelpImage,$GUI_HIDE)
EndIf
EndFunc
Func DrawMainGUIRestoreConfigs()
GUICtrlSetState($MainGUIRestoreConfigurationsListFiles,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsLabelBackupPath,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsInputBackupPath,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonChangeBackupPath,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonOpenBackupPath,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonRestoreSelected,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonRemoveSelected,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonRefreshList,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsCheckboxAskForConfirmation,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsLabelAskForConfirmation,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsLabelBackupInfo,$GUI_SHOW)
GUICtrlSetState($MainGUIRestoreConfigurationsCheckboxAskForConfirmation,$GUI_CHECKED)
EndFunc
Func UnDrawMainGUIRestoreConfigs()
GUICtrlSetState($MainGUIRestoreConfigurationsListFiles,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsLabelBackupPath,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsInputBackupPath,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonChangeBackupPath,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonOpenBackupPath,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonRestoreSelected,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonRemoveSelected,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsButtonRefreshList,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsCheckboxAskForConfirmation,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsLabelAskForConfirmation,$GUI_HIDE)
GUICtrlSetState($MainGUIRestoreConfigurationsLabelBackupInfo,$GUI_HIDE)
EndFunc
Func DrawMainGUIChangelog()
ControlFocus($MainGUI,$sEmpty,$MainGUIChangelogRichEdit)
GUICtrlSetState($MainGUIChangelogRichEdit,$GUI_SHOW)
GUICtrlSetState($MainGUIChangelogButtonViewOnlineBG,$GUI_SHOW)
GUICtrlSetState($MainGUIChangelogButtonViewOnline,$GUI_SHOW)
EndFunc
Func UnDrawMainGUIChangelog()
GUICtrlSetState($MainGUIChangelogRichEdit,$GUI_HIDE)
GUICtrlSetState($MainGUIChangelogButtonViewOnlineBG,$GUI_HIDE)
GUICtrlSetState($MainGUIChangelogButtonViewOnline,$GUI_HIDE)
EndFunc
Func DrawMainGUICopyright()
GUISwitch($MainGUI)
Local $iGIFID, $aRet
If @Compiled Then
$aRet = GUICtrlCreateGIF( _Resource_GetAsImage("SO_LoopGIF") ,130,50,600,100,90,10,True)
Else
$aRet = GUICtrlCreateGIF($MainResourcePath & "Splash_Loop.gif",130,50,600,100,90,10)
EndIf
$MainGUICopyrightAnimatedLogo = $aRet[0]
$MainGUICopyrightAnimatedLogoID = $aRet[1]
$__g_GIFExtended_aStoreCache[$MainGUICopyrightAnimatedLogoID][13] = $iCurrentFrameCopyrightGIF
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlSetState($MainGUICopyrightLabelInfo,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelLicense,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelLicense2,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelCopyright,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelCopyright2,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelSMITECopyright,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelLogoCopyright,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelContact,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelWebsite,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightPicBGLeft,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelVersionFooter,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelLicenseLink,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelSourceLink,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightPicBGRight,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelAutoItCopyright,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelAutoitLicenseLink,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelPrivacyPolicy,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelGDPR,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelWebsiteMetrics,$GUI_SHOW)
EndFunc
Func UnDrawMainGUICopyright()
$iCurrentFrameCopyrightGIF = $__g_GIFExtended_aStoreCache[$MainGUICopyrightAnimatedLogoID][13]
GUICtrlDeleteGIF($MainGUICopyrightAnimatedLogo)
GUICtrlSetState($MainGUICopyrightLabelInfo,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelLicense,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelLicense2,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelCopyright,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelCopyright2,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelSMITECopyright,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelLogoCopyright,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelContact,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelWebsite,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightPicBGLeft,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelVersionFooter,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelLicenseLink,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelSourceLink,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightPicBGRight,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelAutoItCopyright,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelAutoitLicenseLink,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelPrivacyPolicy,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelGDPR,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelWebsiteMetrics,$GUI_HIDE)
EndFunc
Func DrawMainGUIDebug()
GUICtrlSetState($MainGUIDebugLabelEngineSettings,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugLabelSystemSettings,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugLabelGameSettings,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugLabelConfigBackupPath,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugEditSystemInfo,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugButtonCommonIssues,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugButtonResetConfigPaths,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugCheckboxCheckForUpdates,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugLabelCheckForUpdates,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugLabelReportABug,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugLabelCreateDebugInfo,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugPicDebugFooterFooter,$GUI_SHOW)
If $MainGUIDebugButtonPerformUpdate <> NULL Then GUICtrlSetState($MainGUIDebugButtonPerformUpdate,$GUI_SHOW)
EndFunc
Func UnDrawMainGUIDebug()
GUICtrlSetState($MainGUIDebugLabelEngineSettings,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugLabelSystemSettings,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugLabelGameSettings,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugLabelConfigBackupPath,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugEditSystemInfo,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugButtonCommonIssues,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugButtonResetConfigPaths,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugCheckboxCheckForUpdates,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugLabelCheckForUpdates,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugLabelReportABug,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugLabelCreateDebugInfo,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugPicDebugFooterFooter,$GUI_HIDE)
If $MainGUIDebugButtonPerformUpdate <> NULL Then GUICtrlSetState($MainGUIDebugButtonPerformUpdate,$GUI_HIDE)
EndFunc
Global $LastMenu = "Home"
Func ToggleMenuState($State)
If $HoverBGDrawn Then
GUICtrlSetPos($MainGUIHomeHelpBackground,-$MinWidth,-$MinHeight,1,1)
$HoverBGDrawn = False
ElseIf $HoverImageDrawn Then
WinMove($HoverInfoGUI,$sEmpty,-$ScrW*2,-$ScrH*2,0,0)
$HoverImageDrawn = False
EndIf
If $LastMenu = "Home" Then
GUICtrlSetState($HomeIconSelector,$GUI_HIDE)
UnDrawMainGUIHomeConfigDiscovery()
UnDrawMainGUIHome()
ElseIf $LastMenu = "Fixes" Then
GUICtrlSetState($FixesIconSelector,$GUI_HIDE)
UnDrawMainGUIFixes()
ElseIf $LastMenu = "RestoreConfigs" Then
GUICtrlSetState($RCIconSelector,$GUI_HIDE)
UnDrawMainGUIRestoreConfigs()
ElseIf $LastMenu = "Donate" Then
GUICtrlSetState($DonateIconSelector,$GUI_HIDE)
UnDrawMainGUIDonate()
ElseIf $LastMenu = "Changelog" Then
GUICtrlSetState($ChangelogIconSelector,$GUI_HIDE)
UnDrawMainGUIChangelog()
ElseIf $LastMenu = "Copyright" Then
GUICtrlSetState($CopyrightIconSelector,$GUI_HIDE)
UnDrawMainGUICopyright()
ElseIf $LastMenu = "Debug" Then
GUICtrlSetState($DebugIconSelector,$GUI_HIDE)
UnDrawMainGUIDebug()
EndIf
Switch $State
Case "Home"
GUICtrlSetState($HomeIconSelector,$GUI_SHOW)
If $SettingsPath = $sEmpty or $SystemSettingsPath = $sEmpty or $GameSettingsPath = $sEmpty or $ProgramState = $sEmpty Then
DrawMainGUIHomeConfigDiscovery()
Else
DrawMainGUIHome()
EndIf
$LastMenu = "Home"
Case "Fixes"
GUICtrlSetState($FixesIconSelector,$GUI_SHOW)
DrawMainGUIFixes()
$LastMenu = "Fixes"
Case "RestoreConfigs"
GUICtrlSetState($RCIconSelector,$GUI_SHOW)
DrawMainGUIRestoreConfigs()
$LastMenu = "RestoreConfigs"
Case "Donate"
GUICtrlSetState($DonateIconSelector,$GUI_SHOW)
DrawMainGUIDonate()
$LastMenu = "Donate"
Case "Changelog"
GUICtrlSetState($ChangelogIconSelector,$GUI_SHOW)
DrawMainGUIChangelog()
$LastMenu = "Changelog"
Case "Copyright"
GUICtrlSetState($CopyrightIconSelector,$GUI_SHOW)
DrawMainGUICopyright()
$LastMenu = "Copyright"
Case "Debug"
GUICtrlSetState($DebugIconSelector,$GUI_SHOW)
DrawMainGUIDebug()
$LastMenu = "Debug"
EndSwitch
EndFunc
Func MenuHoverState($Text,$PosY,$SizeX,$TPosY)
Local $aWinPos = WinGetPos($MainGUI)
If $Text <> "DBan" Then
WinMove($MenuHoverGUI,$sEmpty,$aWinPos[0] + 50,$aWinPos[1] + $PosY,$SizeX,40)
Else
WinMove($MenuHoverGUI,$sEmpty,$aWinPos[0] + 50,$aWinPos[1] + $PosY,$SizeX,80)
EndIf
GUISetState(@SW_SHOWNOACTIVATE,$MenuHoverGUI)
_WinAPI_SetWindowPos($MenuHoverGUI,$HWND_TOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
_WinAPI_SetWindowPos($MenuHoverGUI,$HWND_NOTOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
If $Text <> "DBan" Then
GUICtrlSetState($MainGUIMenuHoverDBan,$GUI_HIDE)
GUICtrlSetData($MainGUIMenuHoverText,$Text)
GUICtrlSetColor($MainGUIMenuHoverText,$cTextColor)
GUICtrlSetPos($MainGUIMenuHoverText,7,0,$SizeX,40)
Else
GUICtrlSetState($MainGUIMenuHoverDBan,$GUI_SHOW)
GUICtrlSetData($MainGUIMenuHoverText,$sEmpty)
GUICtrlSetColor($MainGUIMenuHoverText,0x00)
GUICtrlSetPos($MainGUIMenuHoverText,-1000,0,0,0)
EndIf
$MenuPopupState = True
EndFunc
Func UndoMenuHoverState()
GUISetState(@SW_HIDE,$MenuHoverGUI)
GUICtrlSetPos($MainGUIMenuHoverText,-$ScrW*2,-$ScrH*2)
GUICtrlSetData($MainGUIMenuHoverText,$sEmpty)
GUICtrlSetState($MainGUIMenuHoverDBan,$GUI_HIDE)
$MenuPopupState = False
EndFunc
Func HideErrorMessage()
If $NotificationGUI <> NULL Then
GUIDelete($NotificationGUI)
$NotificationGUI = NULL
If $GUIMoreOptions <> NULL Then
GUISetState(@SW_ENABLE,$GUIMoreOptions)
Else
GUISetState(@SW_ENABLE,$MainGUI)
WinActivate($MainGUI)
EndIf
EndIf
EndFunc
Func DisplayErrorMessage($Message,$Parent = $MainGUI,$Header = "ERROR!")
HideErrorMessage()
_WinAPI_SetWindowPos($MainGUI,$HWND_TOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
_WinAPI_SetWindowPos($MainGUI,$HWND_NOTOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
If $GUIMoreOptions <> NULL Then
_WinAPI_SetWindowPos($GUIMoreOptions,$HWND_TOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
_WinAPI_SetWindowPos($GUIMoreOptions,$HWND_NOTOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
EndIf
GUISetState(@SW_DISABLE,$Parent)
Local $WinPos = WinGetPos($Parent)
Global $NotificationGUI = GUICreate("SO_NOTIFICATION_GUI",400,150,$WinPos[0] +($WinPos[2]/2)-200,$WinPos[1] +($WinPos[3]/2)-75,$WS_POPUP,$WS_EX_TOOLWINDOW)
GUISetBkColor($cBackgroundColor)
Local $NotificationGUIBG = GUICtrlCreatePic($sEmpty,0,0,400,150)
LoadImageResource($NotificationGUIBG,$MainResourcePath & "NotificationBG.jpg","NotificationBG")
GUICtrlSetOnEvent($NotificationGUIBG,"HideErrorMessage")
Local $NotificationGUILabelMessage = GUICtrlCreateLabelTransparentBG($Header&@CRLF&@CRLF&$Message,5,3,390,140)
GUICtrlSetOnEvent($NotificationGUILabelMessage,"HideErrorMessage")
GUICtrlSetFont(-1,10,Default,Default,$MenuFontName)
Local $NotificationGUILabelDismiss = GUICtrlCreateLabelTransparentBG("Click to dismiss",5,132,390,13)
GUICtrlSetOnEvent($NotificationGUILabelDismiss,"HideErrorMessage")
GUICtrlSetFont(-1,10,Default,Default,$MenuFontName)
GUISetState(@SW_SHOW,$NotificationGUI)
GUISwitch($Parent)
If @OSVersion = "WIN_XP" or @OSVersion = "WIN_XPe" Then _Resource_LoadSound("WIN_XP",0)
If @OSVersion = "WIN_VISTA" or @OSVersion = "WIN_7" or @OSVersion = "WIN_8" or @OSVersion = "WIN_81" Then _Resource_LoadSound("ErrorWIN_7_8",0)
If @OSVersion = "WIN_10" Then _Resource_LoadSound("ErrorWIN_10",0)
If @OSVersion = "WIN_11" Then _Resource_LoadSound("ErrorWIN_11",0)
EndFunc
Func ReturnToMainGUI()
GUISwitch($MainGUI)
_GUI_DragAndResizeUpdate($MainGUI,$MinWidth,$MinHeight)
GUIDelete($GUIMoreOptions)
$GUIMoreOptions = NULL
GUISetState(@SW_ENABLE,$MainGUI)
WinActivate($MainGUI)
EndFunc
Func GetDriveLetters()
Local $Temp = DriveGetDrive("fixed")
_ArrayDelete($Temp,0)
Local $Ret[0]
For $I = 0 To uBound($Temp) -1 Step 1
ReDim $Ret[uBound($Ret)+1]
$Ret[$I] = StringUpper(StringLeft($Temp[$I],1))
Next
Return $Ret
EndFunc
Func FixCopyrightGIFPosition()
If IsDeclared("LastMenu") and $LastMenu = "Copyright" Then
GUISwitch($MainGUI)
Local $Temp = GUICtrlCreatePic($sEmpty,130,50,99999,100)
LoadImageResource($Temp,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Local $aPos = WinGetClientSize($MainGUI)
GUICtrlSetPos($MainGUICopyrightAnimatedLogo,$aPos[0] / 2 - 275,50,600,100)
GUICtrlDelete($Temp)
EndIf
EndFunc
Func VerifyAndStoreConfigPath($State,$PathSettings,$PathSystemSettings,$PathGameSettings)
If FileExists($PathSettings) and FileExists($PathSystemSettings) and FileExists($PathGameSettings) Then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigProgramState","REG_SZ",$State)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ",$PathSettings)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ",$PathSystemSettings)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathGame","REG_SZ",$PathGameSettings)
Return True
EndIf
Return False
EndFunc
Func SetupPressLogic()
Local $sDefaultEnginePath = @MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleEngine.ini"
Local $sDefaultSystemPath = @MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini"
Local $sDefaultGamePath = @MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleGame.ini"
Local $sDefaultEnginePathOneDrive = "C:\Users\" & @UserName & "\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini"
Local $sDefaultSystemPathOneDrive = "C:\Users\" & @UserName & "\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini"
Local $sDefaultGamePathOneDrive = "C:\Users\" & @UserName & "\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleGame.ini"
Local $Found = False
Switch @GUI_CtrlId
Case $MainGUIHomePicBtnSteam
$Found = VerifyAndStoreConfigPath("Steam",$sDefaultEnginePath,$sDefaultSystemPath,$sDefaultGamePath)
If not $Found Then
$Found = VerifyAndStoreConfigPath("Steam",$sDefaultEnginePathOneDrive,$sDefaultSystemPathOneDrive,$sDefaultGamePathOneDrive)
If $Found Then
DisplayErrorMessage("Config files are located in " & '"/OneDrive/"' & " settings may not apply correctly! For more information, check 'Common Issues' in the debug tab!",$MainGUI,"Warning!")
Else
DisplayErrorMessage("Could not find configuration files!")
EndIf
EndIf
Case $MainGUIHomePicBtnEGS
$Found = VerifyAndStoreConfigPath("Epic Games Store",$sDefaultEnginePath,$sDefaultSystemPath,$sDefaultGamePath)
If not $Found Then
$Found = VerifyAndStoreConfigPath("Epic Games Store",$sDefaultEnginePathOneDrive,$sDefaultSystemPathOneDrive,$sDefaultGamePathOneDrive)
If $Found Then
DisplayErrorMessage("Config files are located in " & '"/OneDrive/"' & " settings may not apply correctly! For more information, check 'Common Issues' in the debug tab!",$MainGUI,"Warning!")
Else
DisplayErrorMessage("Could not find configuration files!")
EndIf
EndIf
Case $MainGUIHomePicBtnLegacy
$Found = VerifyAndStoreConfigPath("Legacy",$sDefaultEnginePath,$sDefaultSystemPath,$sDefaultGamePath)
If not $Found Then
$Found = VerifyAndStoreConfigPath("Legacy",$sDefaultEnginePathOneDrive,$sDefaultSystemPathOneDrive,$sDefaultGamePathOneDrive)
If $Found Then
DisplayErrorMessage("Config files are located in " & '"/OneDrive/"' & " settings may not apply correctly! For more information, check 'Common Issues' in the debug tab!",$MainGUI,"Warning!")
Else
DisplayErrorMessage("Could not find configuration files!")
EndIf
EndIf
Case $MainGUIHomeButtonMoreOptions
If $GUIMoreOptions <> NULL Then GUIDelete($GUIMoreOptions)
GUISetState(@SW_DISABLE,$MainGUI)
Local $WinPos = WinGetPos($MainGUI)
Global $GUIMoreOptions = GUICreate("SO_MOREOPTIONS",600,300,$WinPos[0] +($WinPos[2]/2)-300,$WinPos[1] +($WinPos[3]/2)-150,BitOR($WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$WS_POPUP),$WS_EX_TOOLWINDOW)
GUISwitch($GUIMoreOptions)
_GUI_EnableDrag($GUIMoreOptions,600,300)
GUISetBkColor($cBackgroundColor)
GUICtrlSetDefColor($cTextColor,$GUIMoreOptions)
GUICtrlSetDefBkColor($cBackgroundColor,$GUIMoreOptions)
Local $Pic = GUICtrlCreatePic($sEmpty,0,34,600,266)
LoadImageResource($Pic,$MainResourcePath & "MoreOptionsBG.jpg","MoreOptionsBG")
GUICtrlSetResizing(-1,$GUI_DOCKBORDERS)
GUICtrlSetState(-1,$GUI_DISABLE)
Local $Pic = GUICtrlCreatePic($sEmpty,18,9,16,16)
LoadImageResource($Pic,$MainResourcePath & "\SMITEOptimizerIcon.jpg","SMITEOptimizerIcon")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlCreateLabelTransparentBG("More Options",50,9,75,15)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$MainFontName)
Local $GUIMoreOptionsClose = GUICtrlCreatePic($sEmpty,566,0,34,34)
LoadImageResource($GUIMoreOptionsClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
Local $GUIMoreOptionsASearch = GUICtrlCreatePic($sEmpty,34,112,250,110)
LoadImageResource($GUIMoreOptionsASearch,$MainResourcePath & "ASearchBtnInActive.jpg","ASearchBtnInActive")
Local $GUIMoreOptionsMSearch = GUICtrlCreatePic($sEmpty,316,112,250,110)
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
GUISetState(@SW_SHOW,$GUIMoreOptions)
Local $CloseState = False
Local $ASearchState = False
Local $MSearchState = False
While True
Local $CursorInfo = GUIGetCursorInfo($GUIMoreOptions)
If(WinGetTitle("[active]") = "SO_MOREOPTIONS" or WinGetTitle("[active]") = "SO_NOTIFICATION_GUI") and @Error = 0 Then
If $NotificationGUI <> NULL Then
If _IsPressed("01") Then
GUIDelete($NotificationGUI)
$NotificationGUI = NULL
GUISetState(@SW_ENABLE,$GUIMoreOptions)
_WinAPI_SetWindowPos($MainGUI,$HWND_TOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
_WinAPI_SetWindowPos($MainGUI,$HWND_NOTOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
WinActivate($GUIMoreOptions)
EndIf
Else
If _IsPressed("1B") Then
ReturnToMainGUI()
ExitLoop(1)
EndIf
Switch $CursorInfo[4]
Case $GUIMoreOptionsClose
If not $CloseState Then
LoadImageResource($GUIMoreOptionsClose,$MainResourcePath & "CloseActivate.jpg","CloseActivate")
$CloseState = True
If $ASearchState Then
LoadImageResource($GUIMoreOptionsASearch,$MainResourcePath & "ASearchBtnInActive.jpg","ASearchBtnInActive")
$ASearchState = False
ElseIf $MSearchState Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
$MSearchState = False
EndIf
EndIf
If _IsPressed("01") Then
ReturnToMainGUI()
ExitLoop
EndIf
Case $GUIMoreOptionsASearch
If not $ASearchState Then
LoadImageResource($GUIMoreOptionsASearch,$MainResourcePath & "ASearchBtnActive.jpg","ASearchBtnActive")
$ASearchState = True
If $CloseState Then
LoadImageResource($GUIMoreOptionsClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
$CloseState = False
ElseIf $MSearchState Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
$MSearchState = False
EndIf
EndIf
If _IsPressed("01") Then
GUIDelete($GUIMoreOptions)
WinActivate($MainGUI)
Local $WinPos = WinGetPos($MainGUI)
$GUIMoreOptions = GUICreate("SO_SCANFILES",400,250,$WinPos[0] +($WinPos[2]/2)-200,$WinPos[1] +($WinPos[3]/2)-125,BitOR($WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$WS_POPUP),$WS_EX_TOOLWINDOW)
GUISwitch($GUIMoreOptions)
GUISetBkColor($cBackgroundColor)
GUICtrlSetDefColor($cTextColor,$GUIMoreOptions)
GUICtrlSetDefBkColor($cBackgroundColor,$GUIMoreOptions)
Local $Pic = GUICtrlCreatePic($sEmpty,0,34,400,216)
LoadImageResource($Pic,$MainResourcePath & "ScanFilesBG.jpg","ScanFilesBG")
GUICtrlSetResizing(-1,$GUI_DOCKBORDERS)
GUICtrlSetState(-1,$GUI_DISABLE)
Local $Pic = GUICtrlCreatePic($sEmpty,18,9,16,16)
LoadImageResource($Pic,$MainResourcePath & "SMITEOptimizerIcon.jpg","SMITEOptimizerIcon")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlCreateLabelTransparentBG("Automatic search",50,9,100,15)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$MainFontName)
Local $GUIMoreOptionsLabelScanState = GUICtrlCreateLabelTransparentBG($sEmpty,99,124,400,50)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,20,Default,Default,$MainFontName)
Local $GUIMoreOptionsClose = GUICtrlCreatePic($sEmpty,366,0,34,34)
LoadImageResource($GUIMoreOptionsClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
GUISetState(@SW_SHOW,$GUIMoreOptions)
Local $FixedDrives = GetDriveLetters()
Local $CloseState = False
Local $ScanState = False
Local $DriveIndex = 0
Global $IndexerPID = 0
While True
Local $CursorInfo = GUIGetCursorInfo($GUIMoreOptions)
If WinGetTitle("[active]") = "SO_SCANFILES" and @Error = 0 Then
If _IsPressed("1B") Then
ReturnToMainGUI()
ExitLoop(2)
EndIf
Switch $CursorInfo[4]
Case $GUIMoreOptionsClose
If not $CloseState Then
LoadImageResource($GUIMoreOptionsClose,$MainResourcePath & "CloseActivate.jpg","CloseActivate")
$CloseState = True
EndIf
If _IsPressed("01") Then
If IsDeclared("IndexerPID") and $IndexerPID <> 0 Then
ProcessClose($IndexerPID)
If FileExists(@TempDir & "\SO_Index.bat") Then FileDelete(@TempDir & "\SO_Index.bat")
If FileExists(@TempDir & "\SO_Index.txt") Then FileDelete(@TempDir & "\SO_Index.txt")
ReturnToMainGUI()
ExitLoop(2)
Else
ReturnToMainGUI()
ExitLoop(2)
EndIf
EndIf
Case Else
If $CloseState Then
LoadImageResource($GUIMoreOptionsClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
$CloseState = False
EndIf
EndSwitch
Sleep(10)
Else
If WinGetTitle("[active]") = $ProgramName Then WinActivate($GUIMoreOptions)
Sleep(100)
EndIf
If not $ScanState Then
GUICtrlSetPos($GUIMoreOptionsLabelScanState,82,124,400,50)
GUICtrlSetData($GUIMoreOptionsLabelScanState,"Indexing drive "&$FixedDrives[$DriveIndex]&":\")
If FileExists(@TempDir & "\SO_Index.bat") Then FileDelete(@TempDir & "\SO_Index.bat")
If FileExists(@TempDir & "\SO_Index.txt") Then FileDelete(@TempDir & "\SO_Index.txt")
FileWrite(@TempDir & "\SO_Index.bat","CHCP 65001"&@CRLF&"@echo off"&@CRLF&"Cls"&@CRLF&$FixedDrives[$DriveIndex]&":"&@CRLF&"cd.."&@CRLF&"dir /s /b /a:-d /o:n > "&@TempDir&"\SO_Index.txt")
If not FileExists(@TempDir & "\SO_Index.bat") Then
fSendMetric("error_autosearch_nobat")
ReturnToMainGUI()
DisplayErrorMessage("Failed to write index batch file!")
ExitLoop(2)
EndIf
$IndexerPID = Run(@TempDir & "\SO_Index.bat",$sEmpty,@SW_HIDE)
If @Error <> 0 Then
fSendMetric("error_autosearch_run")
ReturnToMainGUI()
DisplayErrorMessage("An error occurred when attempting to run the index function.")
ExitLoop(2)
EndIf
$ScanState = True
ElseIf not ProcessExists($IndexerPID) Then
GUICtrlSetPos($GUIMoreOptionsLabelScanState,11,124,400,50)
GUICtrlSetData($GUIMoreOptionsLabelScanState,"Processing index of drive "&$FixedDrives[$DriveIndex]&":\")
If not FileExists(@TempDir&"\SO_Index.txt") Then
fSendMetric("error_autosearch_read")
ReturnToMainGUI()
DisplayErrorMessage("Failed to read index output!")
ExitLoop(2)
EndIf
$DriveIndex = $DriveIndex + 1
If $DriveIndex > uBound($FixedDrives)-1 Then
fSendMetric("error_autosearch_nofiles")
ReturnToMainGUI()
DisplayErrorMessage("Could not find any configuration files on your system.")
ExitLoop(2)
EndIf
Local $File = FileReadToArray(@TempDir & "\SO_Index.txt")
If @Error <> 0 Then
fSendMetric("error_autosearch_readindex")
ReturnToMainGUI()
DisplayErrorMessage("Failed to read index output!")
ExitLoop(2)
EndIf
Local $SettingsEnginePath, $SettingsSystemPath, $SettingsGamePath
For $I = 0 To uBound($File) - 1 Step 1
If StringRight($File[$I],16) = "BattleEngine.ini" Then
$SettingsEnginePath = $File[$I]
ElseIf StringRight($File[$I],24) = "BattleSystemSettings.ini" Then
$SettingsSystemPath = $File[$I]
ElseIf StringRight($File[$I],14) = "BattleGame.ini" Then
$SettingsGamePath = $File[$I]
EndIf
If $SettingsEnginePath <> $sEmpty and $SettingsSystemPath <> $sEmpty and $SettingsGamePath <> $sEmpty Then ExitLoop
Next
If $SettingsEnginePath <> $sEmpty and $SettingsSystemPath <> $sEmpty and $SettingsGamePath <> $sEmpty Then
fSendMetric("event_autosearch_success")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigProgramState","REG_SZ","Custom Files")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ",$SettingsEnginePath)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ",$SettingsSystemPath)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathGame","REG_SZ",$SettingsGamePath)
If FileExists(@TempDir & "\SO_Index.bat") Then FileDelete(@TempDir & "\SO_Index.bat")
If FileExists(@TempDir & "\SO_Index.txt") Then FileDelete(@TempDir & "\SO_Index.txt")
$Found = True
ReturnToMainGUI()
ExitLoop(2)
EndIf
$ScanState = False
EndIf
WEnd
EndIf
Case $GUIMoreOptionsMSearch
If not $MSearchState Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnActive.jpg","MSearchBtnActive")
$MSearchState = True
If $CloseState Then
LoadImageResource($GUIMoreOptionsClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
$CloseState = False
ElseIf $ASearchState Then
LoadImageResource($GUIMoreOptionsASearch,$MainResourcePath & "ASearchBtnInActive.jpg","ASearchBtnInActive")
$ASearchState = False
EndIf
EndIf
If _IsPressed("01") Then
Local $FileSettings = FileOpenDialog("Please select BattleEngine.ini","C:\Users\" & @UserName & "\Documents\My Games\SMITE\BattleGame\Config","INI Files (*.ini)",BitOr($FD_FILEMUSTEXIST,$FD_PATHMUSTEXIST),"BattleEngine.ini")
If @Error = 0 Then
If StringLower(StringRight($FileSettings,16)) <> "battleengine.ini" Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
$MSearchState = False
DisplayErrorMessage("Invalid file selected!",$GUIMoreOptions)
Else
Local $FileSystemSettings = FileOpenDialog("Please select BattleSystemSettings.ini","C:\Users\" & @UserName & "\Documents\My Games\SMITE\BattleGame\Config","INI Files (*.ini)",BitOr($FD_FILEMUSTEXIST,$FD_PATHMUSTEXIST),"BattleSystemSettings.ini")
If @Error = 0 Then
If StringLower(StringRight($FileSystemSettings,24)) <> "battlesystemsettings.ini" Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
$MSearchState = False
DisplayErrorMessage("Invalid file selected!",$GUIMoreOptions)
Else
Local $FileGameSettings = FileOpenDialog("Please select BattleGame.ini","C:\Users\" & @UserName & "\Documents\My Games\SMITE\BattleGame\Config","INI Files (*.ini)",BitOr($FD_FILEMUSTEXIST,$FD_PATHMUSTEXIST),"BattleGame.ini")
If @Error = 0 Then
If StringLower(StringRight($FileGameSettings,14)) <> "battlegame.ini" Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
$MSearchState = False
DisplayErrorMessage("Invalid file selected!",$GUIMoreOptions)
Else
$Found = True
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigProgramState","REG_SZ","Custom Files")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ",$FileSettings)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ",$FileSystemSettings)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathGame","REG_SZ",$FileGameSettings)
ReturnToMainGUI()
ExitLoop
EndIf
EndIf
EndIf
EndIf
EndIf
EndIf
EndIf
Case Else
If $CloseState Then
LoadImageResource($GUIMoreOptionsClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
$CloseState = False
ElseIf $ASearchState Then
LoadImageResource($GUIMoreOptionsASearch,$MainResourcePath & "ASearchBtnInActive.jpg","ASearchBtnInActive")
$ASearchState = False
ElseIf $MSearchState Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
$MSearchState = False
EndIf
EndSwitch
EndIf
Sleep(10)
Else
If WinGetTitle("[active]") = $ProgramName Then WinActivate($GUIMoreOptions)
Sleep(100)
EndIf
WEnd
EndSwitch
If not $Found Then Return
fSendMetric("event_configfiles_foundsuccess")
$ProgramState = RegRead("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
$SettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
$SystemSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
$GameSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathGame")
Local $Text = "Discovery"
If $ProgramState <> $sEmpty Then $Text = $ProgramState
Local $WinWidth = WinGetPos($MainGUI)[2]
GUISwitch($MainGUI)
GUICtrlDelete($MainGUILabelProgramState)
Global $MainGUILabelProgramState = GUICtrlCreateLabelTransparentBG("("&$Text&" mode)",-1000,17,-1,25,$SS_RIGHT)
Local $Width = ControlGetPos($MainGUI,$sEmpty,$MainGUILabelProgramState)[2] + 25
GUICtrlSetPos(-1,$MinWidth - $Width - 144,17,$Width,25)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
Local $Text = "Discovery"
If $ProgramState <> $sEmpty Then $Text = $ProgramState
GUICtrlSetData($MainGUIDebugLabelEngineSettings,"EngineSettings: "&$SettingsPath)
GUICtrlSetData($MainGUIDebugLabelSystemSettings,"SystemSettings: "&$SystemSettingsPath)
GUICtrlSetData($MainGUIDebugLabelGameSettings,"GameSettings: "&$GameSettingsPath)
UnDrawMainGUIHomeConfigDiscovery()
DrawMainGUIHome()
EndFunc
Func ButtonPressLogic()
Switch @GUI_CtrlId
Case $MainGUIButtonClose
ProperExit()
Case $MainGUIButtonMaximize
If $MainGUIMaximizedState Then
WinSetState($MainGUI,$sEmpty,@SW_RESTORE)
$MainGUIMaximizedState = False
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize1NoActivate.jpg","Maximize1NoActivate")
FixCopyrightGIFPosition()
Else
WinSetState($MainGUI,$sEmpty,@SW_MAXIMIZE)
$MainGUIMaximizedState = True
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize2NoActivate.jpg","Maximize2NoActivate")
FixCopyrightGIFPosition()
EndIf
Case $MainGUIButtonMinimize
WinSetState($MainGUI,$sEmpty,@SW_MINIMIZE)
Case $MainGUIButtonDiscord
fSendMetric("action_discord_pressed")
ShellExecute($sDiscordURL)
RegWrite("HKCU\Software\SMITE Optimizer\","bShouldFlashDiscord","REG_SZ","1")
$bShouldFlashDiscordIcon = False
Case $HomeIcon, $HomeIconHover
If $MenuSelected <> 1 Then
$MenuSelected = 1
ToggleMenuState("Home")
EndIf
Case $FixesIcon, $FixesIconHover
If $MenuSelected <> 2 Then
$MenuSelected = 2
ToggleMenuState("Fixes")
EndIf
Case $RCIcon, $RCIconHover
If $MenuSelected <> 3 Then
$MenuSelected = 3
ToggleMenuState("RestoreConfigs")
EndIf
Case $DonateIcon, $DonateIconHover
fSendMetric("action_donate_mtl_pressed")
ShellExecute("https://donate.meteorthelizard.com")
Case $ChangelogIcon, $ChangelogIconHover
If $MenuSelected <> 5 Then
$MenuSelected = 5
ToggleMenuState("Changelog")
EndIf
Case $CopyrightIcon, $CopyrightIconHover
If $MenuSelected <> 6 Then
$MenuSelected = 6
ToggleMenuState("Copyright")
EndIf
Case $DebugIcon, $DebugIconHover
If $MenuSelected <> 7 Then
$MenuSelected = 7
ToggleMenuState("Debug")
EndIf
Case $MainGUIHomeButtonApply
fSendMetric("action_applyconfig_pressed")
Internal_ProcessRequest(True)
Case $MainGUIHomeButtonFixConfig
fSendMetric("action_verify_pressed")
Internal_ProcessRequest()
Case $MainGUIHomeSwitchModeSimple
If GUICtrlRead($MainGUIHomeSwitchModeSimple) = $GUI_CHECKED and $ProgramHomeState <> "Simple" Then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigSimpleOrAdvanced","REG_SZ","Simple")
GUICtrlSetState($MainGUIHomeSwitchModeAdvanced,$GUI_UNCHECKED)
UnDrawMainGUIHome()
$ProgramHomeState = "Simple"
DrawMainGUIHome()
EndIf
Case $MainGUIHomeSwitchModeAdvanced
If GUICtrlRead($MainGUIHomeSwitchModeAdvanced) = $GUI_CHECKED and $ProgramHomeState <> "Advanced" Then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigSimpleOrAdvanced","REG_SZ","Advanced")
GUICtrlSetState($MainGUIHomeSwitchModeSimple,$GUI_UNCHECKED)
UnDrawMainGUIHome()
$ProgramHomeState = "Advanced"
DrawMainGUIHome()
EndIf
Case $MainGUIHomeButtonRestoreDefaults
fSendMetric("action_defaults_pressed")
Internal_LoadSettingCookies(True)
Case $MainGUIHomeButtonUseMaxPerformance
fSendMetric("action_maxperformance_pressed")
Internal_LoadSettingCookies(True,True)
Case $MainGUIHomeCheckboxDisplayHints
Local $CDHState = GUICtrlRead($MainGUIHomeCheckboxDisplayHints)
$ProgramHomeHelpState = $CDHState
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigShowHints","REG_SZ",$CDHState)
If $CDHState == $GUI_UNCHECKED Then
fSendMetric("action_helptips_disabled")
Else
fSendMetric("action_helptips_enabled")
EndIf
If $ProgramHomeHelpState = $GUI_UNCHECKED Then
GUICtrlSetPos($MainGUIHomeHelpBackground,-$MinWidth,-$MinHeight,1,1)
$HoverBGDrawn = False
WinMove($HoverInfoGUI,$sEmpty,-$ScrW*2,-$ScrH*2,0,0)
$HoverImageDrawn = False
EndIf
Case $MainGUIFixesButtonCreateQuicklaunch
fSendMetric("action_quicklaunch_pressed")
Internal_CreateQuicklaunchBypass()
Case $MainGUIFixesButtonInstallLegacy
fSendMetric("action_installlegacy_pressed")
Internal_InstallLegacyLauncher()
Case $MainGUIFixesButtonApply
fSendMetric("action_applyfixes_pressed")
Internal_ProcessRequest(True,True)
Case $MainGUIFixesButtonRepairEAC
Internal_FixEAC()
Case $MainGUIRestoreConfigurationsButtonChangeBackupPath
Local $Folder = FileSelectFolder("Select a new Folder:",$ConfigBackupPath)
If StringLen($Folder) <=(260 - 18 - 21) Then
If @Error = 0 and FileExists($Folder) Then
$Folder = $Folder & "\"
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigBackupPath","REG_SZ",$Folder)
$ConfigBackupPath = $Folder
GUICtrlSetData($MainGUIRestoreConfigurationsInputBackupPath,$Folder)
EndIf
Else
DisplayErrorMessage("The selected path is too long!")
EndIf
Case $MainGUIRestoreConfigurationsButtonOpenBackupPath
ShellExecute($ConfigBackupPath)
Case $MainGUIRestoreConfigurationsButtonRemoveSelected
Local $TPath = GUICtrlRead($MainGUIRestoreConfigurationsListFiles)
If $TPath = "No backups available." or $TPath = $sEmpty Then Return
Local $AskC = GUICtrlRead($MainGUIRestoreConfigurationsCheckboxAskForConfirmation)
Local $MsgB
If $AskC = $GUI_CHECKED Then
$MsgB = MsgBox($MB_YESNO,"Confirm action","Are you sure that you want to delete this backup?"&@CRLF&"This cannot be undone!")
Else
$MsgB = $IDYES
EndIf
If $MsgB = $IDYES Then
Local $Error = DirRemove($ConfigBackupPath&$TPath,$DIR_REMOVE)
If $Error = 0 Then
fSendMetric("error_restorebackup_filesgone")
DisplayErrorMessage("The selected backup could not be deleted!"&@CRLF&"It appears it was already deleted by another program, or maybe by you?")
EndIf
Internal_UpdateRestoreConfigList()
EndIf
Case $MainGUIRestoreConfigurationsButtonRestoreSelected
Local $TPath = GUICtrlRead($MainGUIRestoreConfigurationsListFiles)
If $TPath = "No backups available." or $TPath = $sEmpty Then Return
Local $AskC = GUICtrlRead($MainGUIRestoreConfigurationsCheckboxAskForConfirmation)
Local $MsgB
If $AskC = $GUI_CHECKED Then
$MsgB = MsgBox($MB_YESNO,"Confirm action","Are you sure that you want to restore this backup?"&@CRLF&"This will overwrite your game configuration files!"&@CRLF&"This cannot be undone!")
Else
$MsgB = $IDYES
EndIf
If $MsgB = $IDYES Then
fSendMetric("action_restore_backup")
If not FileExists($ConfigBackupPath&$TPath&"\Engine.ini") or not FileExists($ConfigBackupPath&$TPath&"\SystemSettings.ini") or not FileExists($ConfigBackupPath&$TPath&"\GameSettings.ini") Then
fSendMetric("error_restorebackup_code9")
DisplayErrorMessage("Attempted to restore the backup, but it appears to be missing or corrupt! Code: 009")
Internal_UpdateRestoreConfigList()
Else
Local $CopySucc = FileCopy($ConfigBackupPath&$TPath&"\Engine.ini",$SettingsPath,$FC_OVERWRITE)
If $CopySucc = 0 Then
fSendMetric("error_restorebackup_code1")
DisplayErrorMessage("There was an error copying one of the files! (Engine) Code: 001")
Else
Local $CopySucc = FileCopy($ConfigBackupPath&$TPath&"\SystemSettings.ini",$SystemSettingsPath,$FC_OVERWRITE)
If $CopySucc = 0 Then
fSendMetric("error_restorebackup_code2")
DisplayErrorMessage("There was an error copying one of the files! (System) Code: 002")
Else
Local $CopySucc = FileCopy($ConfigBackupPath&$TPath&"\GameSettings.ini",$GameSettingsPath,$FC_OVERWRITE)
If $CopySucc = 0 Then
fSendMetric("error_restorebackup_code12")
DisplayErrorMessage("There was an error copying one of the files! (Game) Code: 012")
Else
fSendMetric("event_restorebackup_success")
DirRemove($ConfigBackupPath&$TPath,$DIR_REMOVE)
Internal_UpdateRestoreConfigList()
EndIf
EndIf
EndIf
EndIf
EndIf
Case $MainGUIChangelogButtonViewOnline, $MainGUIChangelogButtonViewOnlineBG
fSendMetric("action_changelog_pressed")
ShellExecute("https://github.com/MeteorTheLizard/SMITE-Optimizer/commits/master")
Case $MainGUICopyrightLabelWebsite
fSendMetric("action_visit_website")
ShellExecute("https://meteorthelizard.com")
Case $MainGUICopyrightLabelLicenseLink
_Resource_SaveToFile(@TempDir & "\GPL_License.txt","GPL_License")
If FileExists(@TempDir & "\GPL_License.txt") Then ShellExecute(@TempDir & "\GPL_License.txt")
Case $MainGUICopyrightLabelSourceLink
fSendMetric("action_visit_github")
ShellExecute("https://github.com/MeteorTheLizard/SMITE-Optimizer")
Case $MainGUICopyrightLabelAutoitLicenseLink
_Resource_SaveToFile(@TempDir & "\AutoIt_License.txt","AutoIt_License")
If FileExists(@TempDir & "\AutoIt_License.txt") Then ShellExecute(@TempDir & "\AutoIt_License.txt")
Case $MainGUICopyrightLabelPrivacyPolicy
_Resource_SaveToFile(@TempDir & "\Privacy_Policy.txt","Privacy_Policy")
If FileExists(@TempDir & "\Privacy_Policy.txt") Then ShellExecute(@TempDir & "\Privacy_Policy.txt")
Case $MainGUICopyrightLabelGDPR
_Resource_SaveToFile(@TempDir & "\GDPR.txt","GDPR")
If FileExists(@TempDir & "\GDPR.txt") Then ShellExecute(@TempDir & "\GDPR.txt")
Case $MainGUICopyrightLabelWebsiteMetrics
ShellExecute($sMetricsServer)
Case $MainGUIDebugButtonCommonIssues
fSendMetric("action_commonissues_pressed")
_Resource_SaveToFile(@TempDir & "\CommonIssues.txt","CommonIssues")
If FileExists(@TempDir & "\CommonIssues.txt") Then ShellExecute(@TempDir & "\CommonIssues.txt")
Case $MainGUIDebugCheckboxCheckForUpdates
Local $CDHState = GUICtrlRead($MainGUIDebugCheckboxCheckForUpdates)
If $CDHState <> $GUI_CHECKED Then
fSendMetric("action_automatic_updates_disabled")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigCheckForUpdates","REG_SZ","0")
Else
fSendMetric("action_automatic_updates_enabled")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigCheckForUpdates")
EndIf
Case $MainGUIDebugButtonPerformUpdate
fSendMetric("action_manualupdate_pressed")
RegWrite("HKCU\Software\SMITE Optimizer\","DebugForceUpdate","REG_SZ","1")
Run(@ScriptFullPath)
Exit
Case $MainGUIDebugLabelReportABug
fSendMetric("action_reportabug_pressed")
ShellExecute("https://github.com/MeteorTheLizard/SMITE-Optimizer/issues")
Case $MainGUIDebugLabelCreateDebugInfo
Local $sDirSelect = FileSelectFolder("Choose a folder to save the debug dump into",@DesktopDir)
If not @Error Then
GUISwitch($MainGUI)
Local $LabelDebugDumpWorking = GUICtrlCreateLabelTransparentBG("Creating debug dump..",65,220,400,55)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
DirRemove(@TempDir & "\optimizerdebugdump",$DIR_REMOVE)
Sleep(350)
DirCreate(@TempDir & "\optimizerdebugdump")
If not @Error Then
GUICtrlSetData($LabelDebugDumpWorking,"Retrieving information from system box")
FileWrite(@TempDir & "\optimizerdebugdump\systeminfobox.txt",GUICtrlRead($MainGUIDebugEditSystemInfo))
GUICtrlSetData($LabelDebugDumpWorking,"Retrieving configured file paths")
Local $Str_Path1 = GUICtrlRead($MainGUIDebugLabelEngineSettings)
Local $Str_Path2 = GUICtrlRead($MainGUIDebugLabelSystemSettings)
Local $Str_Path3 = GUICtrlRead($MainGUIDebugLabelGameSettings)
Local $Str_Path4 = GUICtrlRead($MainGUIDebugLabelConfigBackupPath)
FileWrite(@TempDir & "\optimizerdebugdump\paths.txt",$Str_Path1 & @CRLF & $Str_Path2 & @CRLF & $Str_Path3 & @CRLF & $Str_Path4)
GUICtrlSetData($LabelDebugDumpWorking,"Retrieving game launch logs")
DirCreate(@TempDir & "\optimizerdebugdump\logs\launch")
FileCopy("C:\Users\" & @UserName &"\Documents\My Games\SMITE\BattleGame\Logs\*.log",@TempDir & "\optimizerdebugdump\logs\launch\",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy("C:\Users\" & @UserName &"\OneDrive\Documents\My Games\SMITE\BattleGame\Logs\*.log",@TempDir & "\optimizerdebugdump\logs\launch\",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
GUICtrlSetData($LabelDebugDumpWorking,"Retrieving game configuration files")
FileCopy($SettingsPath,@TempDir & "\optimizerdebugdump\config\EngineSettings.ini",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy($SystemSettingsPath,@TempDir & "\optimizerdebugdump\config\SystemSettings.ini",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy($GameSettingsPath,@TempDir & "\optimizerdebugdump\config\GameSettings.ini",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
If FileExists(@TempDir & "\optimizerdebugdump\config\GameSettings.ini") Then
Local $Read[0]
_FileReadToArray(@TempDir & "\optimizerdebugdump\config\GameSettings.ini",$Read)
Local $aFilter[9] = [ "LoginName", "LoginPwd", "SaveLoginName", "m_bKeepLoggedIn", "m_dwLastLoginPortalId", "m_dwLastLoginAccountId", "m_sLastLoginAccessToken", "m_sLastLoginAccessTokenExpiration" ]
For $I = 0 To uBound($aFilter) - 1 Step 1
Local $iLen = StringLen($aFilter[$I])
For $B = 0 To uBound($Read) - 1 Step 1
If StringLeft($Read[$B],$iLen) = $aFilter[$I] Then
$Read[$B] = ";{INFORMATION REPLACED FOR SECURITY REASONS}"
ExitLoop
EndIf
Next
Next
_FileWriteFromArray(@TempDir & "\optimizerdebugdump\config\GameSettings.ini",$Read)
EndIf
GUICtrlSetData($LabelDebugDumpWorking,"Retrieving EasyAntiCheat logs")
FileCopy("C:\Users\" & @UserName & "\AppData\Roaming\EasyAntiCheat\*.log",@TempDir & "\optimizerdebugdump\logs\*.log",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy("C:\Users\" & @UserName & "\AppData\Roaming\EasyAntiCheat\140\*.log",@TempDir & "\optimizerdebugdump\logs\*.log",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
GUICtrlSetData($LabelDebugDumpWorking,"Retrieving registry values")
Local $sData = $sEmpty
For $i = 1 To 100 Step 1
Local $sVar = RegEnumVal("HKCU\SOFTWARE\SMITE Optimizer\", $i)
If @Error Then ContinueLoop
$sData = $sData & $sVar & " = " & RegRead("HKCU\SOFTWARE\SMITE Optimizer\",$sVar) & @CRLF
Next
FileWrite(@TempDir & "\optimizerdebugdump\reg-values.txt",$sData)
GUICtrlSetData($LabelDebugDumpWorking,"Retrieving dxdiag information")
ShellExecute("dxdiag",'/dontskip /whql:off /t "' & @TempDir & '\optimizerdebugdump\dxdiag.txt"')
While ProcessExists("dxdiag.exe")
WEnd
GUICtrlSetData($LabelDebugDumpWorking,"Creating archive")
local $file_Zip = _Zip_Create($sDirSelect & "\SMITE_Optimizer_Debug.zip",1)
_Zip_AddItem($file_Zip,@TempDir & "\optimizerdebugdump\")
DirRemove(@TempDir & "\optimizerdebugdump",$DIR_REMOVE)
GUICtrlDelete($LabelDebugDumpWorking)
fSendMetric("action_debugdump_created")
MsgBox(0,"Success","Debug dump successfully created!")
EndIf
EndIf
Case $MainGUIDebugButtonResetConfigPaths
GUISetState(@SW_DISABLE,$MainGUI)
Local $Msg = MsgBox($MB_YESNO,"Confirm action","Are you sure that you want to reset the configuration paths?",Default,$MainGUI)
If $Msg == $IDYES Then
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathGame")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
$SettingsPath = $sEmpty
$SystemSettingsPath = $sEmpty
$GameSettingsPath = $sEmpty
$ProgramState = $sEmpty
Local $WinWidth = WinGetPos($MainGUI)[2]
GUICtrlDelete($MainGUILabelProgramState)
Global $MainGUILabelProgramState = GUICtrlCreateLabelTransparentBG("(Discovery mode)",-1000,17,-1,25,$SS_RIGHT)
Local $Width = ControlGetPos($MainGUI,$sEmpty,$MainGUILabelProgramState)[2] + 25
GUICtrlSetPos(-1,$MinWidth - $Width - 144,17,$Width,25)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,9,Default,Default,$WindowsUIFont)
GUICtrlSetData($MainGUIDebugLabelEngineSettings,"EngineSettings: Not yet defined")
GUICtrlSetData($MainGUIDebugLabelSystemSettings,"SystemSettings: Not yet defined")
GUICtrlSetData($MainGUIDebugLabelGameSettings,"GameSettings: Not yet defined")
fSendMetric("action_configpaths_reset")
$MenuSelected = 1
ToggleMenuState("Home")
EndIf
GUISetState(@SW_ENABLE,$MainGUI)
EndSwitch
EndFunc
Func Internal_ProcessScreenRes()
Global $AvailableResolutions[0]
Global $AvailableResolutionsStr
_ArrayAdd($AvailableResolutions,"800 x 600")
_ArrayAdd($AvailableResolutions,"1024 x 768")
_ArrayAdd($AvailableResolutions,"1280 x 960")
_ArrayAdd($AvailableResolutions,"1400 x 1050")
_ArrayAdd($AvailableResolutions,"1440 x 1080")
_ArrayAdd($AvailableResolutions,"1600 x 1200")
_ArrayAdd($AvailableResolutions,"1280 x 720")
_ArrayAdd($AvailableResolutions,"1366 x 768")
_ArrayAdd($AvailableResolutions,"1600 x 900")
_ArrayAdd($AvailableResolutions,"1920 x 1080")
_ArrayAdd($AvailableResolutions,"2560 x 1440")
_ArrayAdd($AvailableResolutions,"3840 x 2160")
_ArrayAdd($AvailableResolutions,"7680 x 4320")
_ArrayAdd($AvailableResolutions,"1280 x 800")
_ArrayAdd($AvailableResolutions,"1440 x 900")
_ArrayAdd($AvailableResolutions,"1680 x 1050")
_ArrayAdd($AvailableResolutions,"1920 x 1200")
_ArrayAdd($AvailableResolutions,"2560 x 1600")
_ArrayAdd($AvailableResolutions,"3840 x 2400")
_ArrayAdd($AvailableResolutions,"2560 x 1080")
_ArrayAdd($AvailableResolutions,"3440 x 1440")
_ArrayAdd($AvailableResolutions,"3840 x 1600")
_ArrayAdd($AvailableResolutions,"5120 x 2160")
_ArrayAdd($AvailableResolutions,"3840 x 1080")
_ArrayAdd($AvailableResolutions,"5120 x 1440")
$AvailableResolutions = _ArrayUnique($AvailableResolutions)
_ArrayDelete($AvailableResolutions,0)
Local $aTempPixels[0][2]
For $I = 0 To uBound($AvailableResolutions) - 1 Step 1
ReDim $aTempPixels[$I + 1][2]
$aTempPixels[$I][0] = $AvailableResolutions[$I]
Local $aSplit = StringSplit($aTempPixels[$I][0]," x ",1)
If uBound($aSplit) > 2 Then $aTempPixels[$I][1] =(Number($aSplit[1]) * Number($aSplit[2]))
Next
_ArraySort($aTempPixels,Default,Default,Default,1)
For $I = 0 To uBound($aTempPixels) - 1 Step 1
$AvailableResolutions[$I] = $aTempPixels[$I][0]
Next
_ArrayInsert($AvailableResolutions,0,@DesktopWidth & " x " & @DesktopHeight)
Local $bErrorFlag = False
Local $sReadX = RegRead("HKCU\Software\SMITE Optimizer\","Custom_ResX")
If @Error Then $bErrorFlag = True
Local $sReadY = RegRead("HKCU\Software\SMITE Optimizer\","Custom_ResY")
If @Error Then $bErrorFlag = True
If Not $bErrorFlag Then
$sReadX = Floor(Abs(Number($sReadX)))
$sReadX =($sReadX < 800 ? 800 : $sReadX > 15360 ? 15360 : $sReadX)
$sReadY = Floor(Abs(Number($sReadY)))
$sReadY =($sReadY < 600 ? 600 : $sReadY > 8640 ? 8640 : $sReadY)
_ArrayInsert($AvailableResolutions,1,"Custom (" & $sReadX & " x " & $sReadY & ")")
Else
_ArrayInsert($AvailableResolutions,1,"Custom")
EndIf
For $I = 0 To uBound($AvailableResolutions) - 1 Step 1
$AvailableResolutionsStr = $AvailableResolutionsStr & $AvailableResolutions[$I] & "|"
Next
EndFunc
Func Internal_ChooseCustomRes()
If $ResPromptGUI <> NULL Then
GUIDelete($ResPromptGUI)
EndIf
_WinAPI_SetWindowPos($MainGUI,$HWND_TOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
_WinAPI_SetWindowPos($MainGUI,$HWND_NOTOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
GUISetState(@SW_DISABLE,$MainGUI)
Local $WinPos = WinGetPos($MainGUI)
Global $ResPromptGUI = GUICreate("SO_RESSELECT",300,150,$WinPos[0] +($WinPos[2]/2)-150,$WinPos[1] +($WinPos[3]/2)-75,BitOR($WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$WS_POPUP),$WS_EX_TOOLWINDOW)
GUISwitch($ResPromptGUI)
_GUI_EnableDrag($ResPromptGUI,300,150)
GUISetBkColor($cBackgroundColor)
GUICtrlSetDefColor($cTextColor,$ResPromptGUI)
GUICtrlSetDefBkColor($cBackgroundColor,$ResPromptGUI)
Local $Pic = GUICtrlCreatePic($sEmpty,0,34,300,116)
LoadImageResource($Pic,$MainResourcePath & "ChooseResBG.jpg","ChooseResBG")
GUICtrlSetState(-1,$GUI_DISABLE)
Local $Pic = GUICtrlCreatePic($sEmpty,18,9,16,16)
LoadImageResource($Pic,$MainResourcePath & "\SMITEOptimizerIcon.jpg","SMITEOptimizerIcon")
GUICtrlCreateLabelTransparentBG("Choose resolution",50,9,105,15)
GUICtrlSetFont(-1,9,Default,Default,$MainFontName)
GUICtrlCreateLabelTransparentBG("Width",66,45,50,15)
GUICtrlSetFont(-1,9,Default,Default,$MainFontName)
Local $sRead = RegRead("HKCU\Software\SMITE Optimizer\","Custom_ResX")
$sRead = Floor(Abs(Number($sRead)))
$sRead =($sRead < 800 ? 800 : $sRead > 15360 ? 15360 : $sRead)
Local $ResX = GUICtrlCreateInputSO($sRead,65,64,75,25,$ES_NUMBER)
GUICtrlCreateLabelTransparentBG("Height",161,45,50,15)
GUICtrlSetFont(-1,9,Default,Default,$MainFontName)
Local $sRead = RegRead("HKCU\Software\SMITE Optimizer\","Custom_ResY")
$sRead = Floor(Abs(Number($sRead)))
$sRead =($sRead < 600 ? 600 : $sRead > 8640 ? 8640 : $sRead)
Local $ResY = GUICtrlCreateInputSO($sRead,160,64,75,25,$ES_NUMBER)
Local $Cancel = GUICtrlCreateButtonSO($ResPromptGUI,"Cancel",65,101,75,35)
Local $Apply = GUICtrlCreateButtonSO($ResPromptGUI,"Apply",160,101,75,35)
Local $ResPromptGUIClose = GUICtrlCreatePic($sEmpty,266,0,34,34)
LoadImageResource($ResPromptGUIClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
GUISetState(@SW_SHOW,$ResPromptGUI)
Local $CloseState = False
Local $bReturnFlag = False
While True
Local $CursorInfo = GUIGetCursorInfo($ResPromptGUI)
If WinGetTitle("[active]") = "SO_RESSELECT" Then
If _IsPressed("1B") Then
ExitLoop
EndIf
Switch $CursorInfo[4]
Case $ResPromptGUIClose
If not $CloseState Then
LoadImageResource($ResPromptGUIClose,$MainResourcePath & "CloseActivate.jpg","CloseActivate")
$CloseState = True
EndIf
If _IsPressed("01") Then
If $ProgramHomeState = "Simple" Then
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,$HomeSimpleComboResLastIndex)
ElseIf $ProgramHomeState = "Advanced" Then
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,$HomeAdvancedComboResLastIndex)
EndIf
ExitLoop
EndIf
Case $Apply
If _IsPressed("01") Then
While _IsPressed("01")
Sleep(10)
WEnd
Local $iX = GUICtrlRead($ResX)
$iX = Floor(Abs(Number($iX)))
$iX =($iX < 800 ? 800 : $iX > 15360 ? 15360 : $iX)
Local $iY = GUICtrlRead($ResY)
$iY = Floor(Abs(Number($iY)))
$iY =($iY < 600 ? 600 : $iY > 8640 ? 8640 : $iY)
RegWrite("HKCU\Software\SMITE Optimizer\","Custom_ResX","REG_SZ",$iX)
RegWrite("HKCU\Software\SMITE Optimizer\","Custom_ResY","REG_SZ",$iY)
Local $sSet = "Custom (" & $iX & " x " & $iY & ")"
_GUICtrlComboBox_DeleteString($MainGUIHomeSimpleComboScreenRes,1)
_GUICtrlComboBox_InsertString($MainGUIHomeSimpleComboScreenRes,$sSet,1)
If $ProgramHomeState = "Simple" Then
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,$sSet,1)
$LastReadScrResSimple = GUICtrlRead($MainGUIHomeSimpleComboScreenRes)
EndIf
_GUICtrlComboBox_DeleteString($MainGUIHomeAdvancedComboScreenRes,1)
_GUICtrlComboBox_InsertString($MainGUIHomeAdvancedComboScreenRes,$sSet,1)
If $ProgramHomeState = "Advanced" Then
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,$sSet,1)
$LastReadScrResAdvanced = GUICtrlRead($MainGUIHomeAdvancedComboScreenRes)
EndIf
$bReturnFlag = True
ExitLoop
EndIf
Case $Cancel
If _IsPressed("01") Then
While _IsPressed("01")
Sleep(10)
WEnd
If $ProgramHomeState = "Simple" Then
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,$HomeSimpleComboResLastIndex)
ElseIf $ProgramHomeState = "Advanced" Then
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,$HomeAdvancedComboResLastIndex)
EndIf
ExitLoop
EndIf
Case Else
If $CloseState Then
LoadImageResource($ResPromptGUIClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
$CloseState = False
EndIf
EndSwitch
Sleep(10)
Else
If WinGetTitle("[active]") = $ProgramName Then WinActivate($ResPromptGUI)
Sleep(100)
EndIf
WEnd
GUISwitch($MainGUI)
_GUI_DragAndResizeUpdate($MainGUI,$MinWidth,$MinHeight)
GUIDelete($ResPromptGUI)
$ResPromptGUI = NULL
GUISetState(@SW_ENABLE,$MainGUI)
WinActivate($MainGUI)
Return $bReturnFlag
EndFunc
Func Internal_ConvertMagicNumber($Number)
If $Number = "En" or $Number = $GUI_CHECKED Then
Return $GUI_CHECKED
ElseIf $Number = "Di" or $Number = $GUI_UNCHECKED Then
Return $GUI_UNCHECKED
EndIf
EndFunc
Func Internal_ConvertMagicNumberSave($Number)
If $Number = $GUI_CHECKED Then
Return "En"
ElseIf $Number = $GUI_UNCHECKED Then
Return "Di"
EndIf
EndFunc
Func Internal_SaveSettingCookie()
Local $Int_Settings
If $ProgramHomeState = "Simple" Then
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboWorldQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboCharacterQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboShadowQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboSkyQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboEffectsParticleQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleInputMaxFPS) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboScreenRes) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleSliderScreenResScale) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboWindowmode) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboAntialiasing) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboMaxAnisotropy) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeSimpleComboDetailMode) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxVSync)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxRagdollPhysics)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxDirectX11)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxBloom)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxDecals)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxDynamicLightShadows)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxLensflares)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxReflections)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeSimpleCheckboxHighQualityMats))
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigCookieSimple","REG_SZ",$Int_Settings)
ElseIf $ProgramHomeState = "Advanced" Then
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboWorldQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboCharacterQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboTerrainQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboNPCQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboWeaponQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboVehicleQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboShadowsQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboParticleQualityLevel) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboSkyQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboEffectsParticleQuality) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboScreenRes) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedSliderScreenResScale) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboWindowmode) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboAntialiasing) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboMaxAnisotropy) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedInputMaxFPS) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxSpeedTreeWind)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxSpeedTreeLeaves)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxSpeedTreeFronds)) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboSpeedTreeLODBias) & "|"
$Int_Settings = $Int_Settings & GUICtrlRead($MainGUIHomeAdvancedComboDetailMode) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxVSync)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxPhysX)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxDX11)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxBloom)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxLensflares)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxReflections)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxUncText)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxLightShafts)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxFogVolumes)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxDistortion)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxFilteredDistortion)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxDropShadows)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxWholeSceneShadows)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxConservShadowBounds)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxLightEnvShadows)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxStaticDecals)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxDynamicDecals)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxUnbatchedDecals)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxDynamicLights)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxCompDynamicLights)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxSHSecondaryLighting)) & "|"
$Int_Settings = $Int_Settings & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIHomeAdvancedCheckboxDynamicShadows))
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigCookieAdvanced","REG_SZ",$Int_Settings)
EndIf
Local $Settings_Fixes = $sEmpty
$Settings_Fixes = $Settings_Fixes & GUICtrlRead($MainGUIFixesInputMaxFPS) & "|"
$Settings_Fixes = $Settings_Fixes & GUICtrlRead($MainGUIFixesComboAudioFix) & "|"
$Settings_Fixes = $Settings_Fixes & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIFixesCheckboxDisableJump)) & "|"
$Settings_Fixes = $Settings_Fixes & Internal_ConvertMagicNumberSave(GUICtrlRead($MainGUIFixesCheckboxDisableFog))
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigCookieFixes","REG_SZ",$Settings_Fixes)
EndFunc
Func Internal_LoadSettingCookies($Bool = False,$Performance = False,$InitBool = False)
Local $Int_Settings
If $ProgramHomeState = "Simple" or $InitBool Then
If not $Performance Then
$Int_Settings = RegRead("HKCU\Software\SMITE Optimizer\","ConfigCookieSimple")
If @Error or $Bool Then
$Int_Settings = "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "150|" & $AvailableResolutions[0] & "|" & "100|" & "Fullscreen|" & "High|" & "16x|" & "2|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED
EndIf
Else
$Int_Settings = "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & "300|" & $AvailableResolutions[0] & "|" & "100|" & "Fullscreen|" & "Off|" & "Off|" & "0|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED
EndIf
Local $Split = StringSplit($Int_Settings,"|")
_ArrayDelete($Split,0)
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboWorldQuality,$Split[0])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboCharacterQuality,$Split[1])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboShadowQuality,$Split[2])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboSkyQuality,$Split[3])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboEffectsParticleQuality,$Split[4])
Local $sLowerRead = StringLower($Split[5])
If $sLowerRead == "inf" or $sLowerRead == "nan" or StringInStr($sLowerRead,"e",0) <> 0 Then
$Split[5] = 999
EndIf
GUICtrlSetData($MainGUIHomeSimpleInputMaxFPS,$Split[5])
Local $Res
RegRead("HKCU\Software\SMITE Optimizer\","ConfigCookieSimple")
If @Error Then
$Res = _GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,@DesktopWidth & " x " & @DesktopHeight)
Else
If StringLeft($Split[6],6) <> "Custom" Then
$Res = _GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,$Split[6])
Else
Local $sReadX = RegRead("HKCU\Software\SMITE Optimizer\","Custom_ResX")
$sReadX = Floor(Abs(Number($sReadX)))
$sReadX =($sReadX < 800 ? 800 : $sReadX > 15360 ? 15360 : $sReadX)
Local $sReadY = RegRead("HKCU\Software\SMITE Optimizer\","Custom_ResY")
$sReadY = Floor(Abs(Number($sReadY)))
$sReadY =($sReadY < 600 ? 600 : $sReadY > 8640 ? 8640 : $sReadY)
$Res = _GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,"Custom (" & $sReadX & " x " & $sReadY & ")")
EndIf
If $Res = -1 Then
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,@DesktopWidth & " x " & @DesktopHeight)
EndIf
EndIf
GUICtrlSetData($MainGUIHomeSimpleSliderScreenResScale,$Split[7])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboWindowmode,$Split[8])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboAntialiasing,$Split[9])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboMaxAnisotropy,$Split[10])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboDetailMode,$Split[11])
GUICtrlSetState($MainGUIHomeSimpleCheckboxVSync,Internal_ConvertMagicNumber($Split[12]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxRagdollPhysics,Internal_ConvertMagicNumber($Split[13]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxBloom,Internal_ConvertMagicNumber($Split[15]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxDecals,Internal_ConvertMagicNumber($Split[16]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxDynamicLightShadows,Internal_ConvertMagicNumber($Split[17]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxLensflares,Internal_ConvertMagicNumber($Split[18]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxReflections,Internal_ConvertMagicNumber($Split[19]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxHighQualityMats,Internal_ConvertMagicNumber($Split[20]))
$LastReadScrResSimple = GUICtrlRead($MainGUIHomeSimpleComboScreenRes)
$HomeSimpleComboResLastIndex = $LastReadScrResSimple
EndIf
If $ProgramHomeState = "Advanced" or $InitBool Then
If not $Performance Then
$Int_Settings = RegRead("HKCU\Software\SMITE Optimizer\","ConfigCookieAdvanced")
If @Error or $Bool Then
$Int_Settings = "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & $AvailableResolutions[0] & "|" & "100|" & "Fullscreen|" & "High|" & "16x|" & "150|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & "2|" & "2|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED
EndIf
Else
$Int_Settings = "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & "Best|" & "Low|" & "Low|" & "Low|" & "Low|" & $AvailableResolutions[0] & "|" & "100|" & "Fullscreen|" & "Off|" & "Off|" & "300|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & "0|" & "0|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED
EndIf
Local $Split = StringSplit($Int_Settings,"|")
_ArrayDelete($Split,0)
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboWorldQuality,$Split[0])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboCharacterQuality,$Split[1])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboTerrainQuality,$Split[2])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboNPCQuality,$Split[3])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboWeaponQuality,$Split[4])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboVehicleQuality,$Split[5])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboShadowsQuality,$Split[6])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboParticleQualityLevel,$Split[7])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboSkyQuality,$Split[8])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboEffectsParticleQuality,$Split[9])
Local $Res
RegRead("HKCU\Software\SMITE Optimizer\","ConfigCookieAdvanced")
If @Error Then
$Res = _GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,@DesktopWidth & " x " & @DesktopHeight)
Else
If StringLeft($Split[10],6) <> "Custom" Then
$Res = _GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,$Split[10])
Else
Local $sReadX = RegRead("HKCU\Software\SMITE Optimizer\","Custom_ResX")
$sReadX = Floor(Abs(Number($sReadX)))
$sReadX =($sReadX < 800 ? 800 : $sReadX > 15360 ? 15360 : $sReadX)
Local $sReadY = RegRead("HKCU\Software\SMITE Optimizer\","Custom_ResY")
$sReadY = Floor(Abs(Number($sReadY)))
$sReadY =($sReadY < 600 ? 600 : $sReadY > 8640 ? 8640 : $sReadY)
$Res = _GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,"Custom (" & $sReadX & " x " & $sReadY & ")")
EndIf
If $Res = -1 Then
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,@DesktopWidth & " x " & @DesktopHeight)
EndIf
EndIf
GUICtrlSetData($MainGUIHomeAdvancedSliderScreenResScale,$Split[11])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboWindowmode,$Split[12])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboAntialiasing,$Split[13])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboMaxAnisotropy,$Split[14])
Local $sLowerRead = StringLower($Split[15])
If $sLowerRead == "inf" or $sLowerRead == "nan" or StringInStr($sLowerRead,"e",0) <> 0 Then
$Split[15] = 999
EndIf
GUICtrlSetData($MainGUIHomeAdvancedInputMaxFPS,$Split[15])
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeWind,Internal_ConvertMagicNumber($Split[16]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeLeaves,Internal_ConvertMagicNumber($Split[17]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeFronds,Internal_ConvertMagicNumber($Split[18]))
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboSpeedTreeLODBias,$Split[19])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboDetailMode,$Split[20])
GUICtrlSetState($MainGUIHomeAdvancedCheckboxVSync,Internal_ConvertMagicNumber($Split[21]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxPhysX,Internal_ConvertMagicNumber($Split[22]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxBloom,Internal_ConvertMagicNumber($Split[24]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLensflares,Internal_ConvertMagicNumber($Split[25]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxReflections,Internal_ConvertMagicNumber($Split[26]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxUncText,Internal_ConvertMagicNumber($Split[27]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLightShafts,Internal_ConvertMagicNumber($Split[28]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxFogVolumes,Internal_ConvertMagicNumber($Split[29]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDistortion,Internal_ConvertMagicNumber($Split[30]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxFilteredDistortion,Internal_ConvertMagicNumber($Split[31]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDropShadows,Internal_ConvertMagicNumber($Split[32]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxWholeSceneShadows,Internal_ConvertMagicNumber($Split[33]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxConservShadowBounds,Internal_ConvertMagicNumber($Split[34]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxLightEnvShadows,Internal_ConvertMagicNumber($Split[35]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxStaticDecals,Internal_ConvertMagicNumber($Split[36]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicDecals,Internal_ConvertMagicNumber($Split[37]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxUnbatchedDecals,Internal_ConvertMagicNumber($Split[38]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicLights,Internal_ConvertMagicNumber($Split[39]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxCompDynamicLights,Internal_ConvertMagicNumber($Split[40]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSHSecondaryLighting,Internal_ConvertMagicNumber($Split[41]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDynamicShadows,Internal_ConvertMagicNumber($Split[42]))
$LastReadScrResAdvanced = GUICtrlRead($MainGUIHomeAdvancedComboScreenRes)
$HomeSimpleComboResLastIndex = $LastReadScrResAdvanced
EndIf
EndFunc
Func Internal_UpdateRestoreConfigList()
_GUICtrlListBox_ResetContent($MainGUIRestoreConfigurationsListFiles)
Local $aFileList2D[0][2]
Local $FileList = _FileListToArray($ConfigBackupPath,"*",2)
_ArrayDelete($FileList,0)
ReDim $aFileList2D[uBound($FileList)][2]
For $I = uBound($FileList) - 1 To 0 Step -1
If not FileExists($ConfigBackupPath & $FileList[$I] & "/Engine.ini") or not FileExists($ConfigBackupPath & $FileList[$I] & "/SystemSettings.ini") or not FileExists($ConfigBackupPath & $FileList[$I] & "/GameSettings.ini") Then
_ArrayDelete($FileList,$I)
Else
$aFileList2D[$I][0] = $FileList[$I]
Local $aStr = StringSplit($FileList[$I],"_")
$aFileList2D[$I][1] = $aStr[3] & $aStr[2] & $aStr[1] & $aStr[4] & $aStr[5] & $aStr[6]
EndIf
Next
_ArraySort($aFileList2D,1,Default,Default,1)
Local $FileCount = uBound($aFileList2D,1)
If $FileCount = 0 Then
_GUICtrlListBox_AddString($MainGUIRestoreConfigurationsListFiles,"No backups available.")
Else
For $I = 0 To $FileCount - 1 Step 1
_GUICtrlListBox_AddString($MainGUIRestoreConfigurationsListFiles,$aFileList2D[$I][0])
Next
EndIf
EndFunc
Func Internal_CreateConfigBackup()
fSendMetric("event_configbackup_create")
Local $SubPath = $ConfigBackupPath & @MDAY & "_" & @MON & "_" & @YEAR & "_" & @HOUR & "_" & @MIN & "_" & @SEC
Local $CreateDir = DirCreate($SubPath)
If $CreateDir = 0 Then Return False
Local $FileCopy = FileCopy($SettingsPath,$SubPath & "\Engine.ini",1)
If $FileCopy = 0 Then Return False
Local $FileCopy = FileCopy($SystemSettingsPath,$SubPath & "\SystemSettings.ini",1)
If $FileCopy = 0 Then Return False
Local $FileCopy = FileCopy($GameSettingsPath,$SubPath & "\GameSettings.ini",1)
If $FileCopy = 0 Then Return False
Internal_UpdateRestoreConfigList()
Return True
EndFunc
Func Interal_VerifyAndFixConfiguration($FileReadArray,$Hive)
For $I = uBound($FileReadArray) - 1 To 0 Step -1
$FileReadArray[$I] = StringReplace($FileReadArray[$I],@CR,$sEmpty)
$FileReadArray[$I] = StringReplace($FileReadArray[$I],@LF,$sEmpty)
Next
For $I = uBound($FileReadArray) - 1 To 0 Step -1
Local $sLeft1 = StringLeft($FileReadArray[$I],1)
If $sLeft1 = ";" Or $sLeft1 = "/" Or $sLeft1 = "#" Or $sLeft1 = $sEmpty Then
_ArrayDelete($FileReadArray,$I)
EndIf
Next
Local $iStartBounds =(uBound($FileReadArray) - 1)
For $I = $iStartBounds To 0 Step -1
If StringLeft($FileReadArray[$I],1) = "[" Then
If($I > 0 And StringLeft($FileReadArray[$I-1],1) = "[") Then
_ArrayDelete($FileReadArray,$I-1)
ElseIf $I = $iStartBounds Then
_ArrayDelete($FileReadArray,$I)
EndIf
EndIf
Next
Local $aGroups[0]
For $I = 0 To uBound($FileReadArray) - 1 Step 1
If StringLeft($FileReadArray[$I],1) = "[" Then
Local $iSize = uBound($aGroups)
ReDim $aGroups[$iSize + 1]
$aGroups[$iSize] = $FileReadArray[$I]
EndIf
Next
Local $aGroupDupes[0]
For $I = 0 To uBound($aGroups) - 1 Step 1
For $B =($I + 1) To uBound($aGroups) - 1 Step 1
If $aGroups[$I] = $aGroups[$B] Then
For $C = 0 To uBound($aGroupDupes) - 1 Step 1
If $aGroupDupes[$C] = $aGroups[$B] Then
ExitLoop(2)
EndIf
Next
Local $iSize = uBound($aGroupDupes)
ReDim $aGroupDupes[$iSize + 1]
$aGroupDupes[$iSize] = $aGroups[$I]
ExitLoop
EndIf
Next
Next
Local $aCachedRanges[0]
Local $iBounds =(uBound($FileReadArray) - 1)
For $I = 0 To uBound($aGroupDupes) - 1 Step 1
Local $iLastOccurance = 0
For $A = $iBounds To 0 Step -1
If $FileReadArray[$A] = $aGroupDupes[$I] Then
$iLastOccurance =($A - 1)
ExitLoop
EndIf
Next
For $A = 0 To $iLastOccurance Step 1
If $FileReadArray[$A] = $aGroupDupes[$I] Then
Local $IEnd = $iLastOccurance
For $B =($A + 1) To $iLastOccurance Step 1
If StringLeft($FileReadArray[$B],1) = "[" Then
$IEnd =($B - 1)
ExitLoop
EndIf
Next
Local $iSize = uBound($aCachedRanges)
ReDim $aCachedRanges[$iSize + 1]
$aCachedRanges[$iSize] =($A & "-" & $IEnd)
EndIf
Next
Next
For $I = uBound($aCachedRanges) - 1 To 0 Step -1
_ArrayDelete($FileReadArray,$aCachedRanges[$I])
Next
For $I = 0 To uBound($Hive,1) - 1 Step 1
Local $sGroup = $Hive[$I][0]
If $sGroup = "" Then
ExitLoop
EndIf
Local $iBounds = uBound($FileReadArray) - 1
For $B = 0 To $iBounds Step 1
If $FileReadArray[$B] = $sGroup Then
ExitLoop
ElseIf $B = $iBounds Then
_ArrayAdd($FileReadArray,$sGroup)
EndIf
Next
Next
_ArrayAdd($FileReadArray,"")
For $I = 0 To uBound($Hive,1) - 1 Step 1
Local $sGroup = $Hive[$I][0]
If $sGroup = "" Then
ExitLoop
EndIf
For $B = 1 To uBound($Hive,2) - 1 Step 1
Local $sKeyName = $Hive[$I][$B]
Local $iLen = StringLen($sKeyName)
If $sKeyName = "" or $iLen = 0 Then
ExitLoop
EndIf
Local $bGroupFound = False
Local $iGroupStart
For $C = 0 To uBound($FileReadArray) - 1 Step 1
If $FileReadArray[$C] = $sGroup Then
$bGroupFound = True
$iGroupStart = $C+1
ExitLoop
EndIf
Next
If $bGroupFound Then
For $C = $iGroupStart To 2^31 Step 1
If $C >(uBound($FileReadArray) - 1) Then
ExitLoop
EndIf
If StringLeft($FileReadArray[$C],$iLen) = $sKeyName Then
ExitLoop
EndIf
If StringLeft($FileReadArray[$C],1) = "[" Or StringLeft($FileReadArray[$C],1) = "" Then
_ArrayInsert($FileReadArray,$iGroupStart,$sKeyName&"=")
ExitLoop
EndIf
Next
EndIf
Next
Next
For $I = uBound($FileReadArray) - 1 To 1 Step -1
If $I > 1 and StringLeft($FileReadArray[$I],1) = "[" Then
_ArrayInsert($FileReadArray,$I,"")
EndIf
Next
Return $FileReadArray
EndFunc
Func Internal_GetQualityLevel($Data)
Local $Ret = 3
Switch $Data
Case "Best"
$Ret = 0
Case "High"
$Ret = 1
Case "Medium"
$Ret = 2
Case "Low"
$Ret = 3
Case "Very Low"
$Ret = 4
Case "Minimum"
$Ret = 5
Case "Potato"
$Ret = 6
Case "Lowest Possible"
$Ret = 7
EndSwitch
Return $Ret
EndFunc
Func Internal_ApplyKey($Array,$KeyName,$KeyValue)
Local $KeyLength = StringLen($KeyName)
For $A = 0 To uBound($Array) - 1 Step 1
If StringLeft($Array[$A],$KeyLength) = $KeyName Then
$Array[$A] = $KeyName&$KeyValue
EndIf
Next
Return $Array
EndFunc
Func Internal_ApplySystemKey($Array,$KeyName,$KeyValue)
Local $KeyLength = StringLen($KeyName)
Local $FoundGroup = False
For $A = 0 To uBound($Array) - 1 Step 1
If not $FoundGroup Then
If $Array[$A] = "[SystemSettings]" Then
$FoundGroup = True
EndIf
ElseIf StringLeft($Array[$A],$KeyLength) = $KeyName Then
$Array[$A] = $KeyName&$KeyValue
ElseIf $FoundGroup And StringLeft($Array[$A],1) = "[" Then
ExitLoop
EndIf
Next
Return $Array
EndFunc
Func Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
For $I = 0 To 3 Step 1
If $TextureQualityHive[$HSubIndex][$Quality][$I] = $sEmpty Then ExitLoop
Local $VarStart = StringInStr($TextureQualityHive[$HSubIndex][$Quality][$I],"=")
Local $SubKeyname = StringLeft($TextureQualityHive[$HSubIndex][$Quality][$I],$VarStart)
Local $SubKeyvar = StringMid($TextureQualityHive[$HSubIndex][$Quality][$I],$VarStart+1)
Local $KeyLength = StringLen($SubKeyname)
Local $FoundGroup = False
For $A = 0 To uBound($Array) - 1 Step 1
If not $FoundGroup Then
If $Array[$A] = "[SystemSettings]" Then
$FoundGroup = True
EndIf
ElseIf StringLeft($Array[$A],$KeyLength) = $SubKeyname Then
$Array[$A] = $TextureQualityHive[$HSubIndex][$Quality][$I]
ExitLoop
EndIf
Next
Next
Return $Array
EndFunc
Func Internal_CheckboxToStrBool($Checkbox)
Local $Read = GUICtrlRead($Checkbox)
If $Read = $GUI_CHECKED Then Return "True"
Return "False"
EndFunc
Func Internal_ApplyChanges($Array,$State)
If $State = "EngineSettings" Then
If $ProgramHomeState = "Simple" Then
Local $RRead = GUICtrlRead($MainGUIHomeSimpleInputMaxFPS)
If $RRead < 30 Then $RRead = 30
Local $sLowerRead = StringLower($RRead)
If $sLowerRead = "inf" or $sLowerRead = "nan" or StringInStr($sLowerRead,"e",0) <> 0 Then
$RRead = 999
EndIf
$Array = Internal_ApplyKey($Array,"bSmoothFrameRate=","True")
$Array = Internal_ApplyKey($Array,"MinDesiredFrameRate=",$RRead/2)
$Array = Internal_ApplyKey($Array,"MinSmoothedFrameRate=",$RRead/2)
$Array = Internal_ApplyKey($Array,"MaxSmoothedFrameRate=",$RRead)
ElseIf $ProgramHomeState = "Advanced" Then
Local $RRead = GUICtrlRead($MainGUIHomeAdvancedInputMaxFPS)
If $RRead < 30 Then $RRead = 30
Local $sLowerRead = StringLower($RRead)
If $sLowerRead = "inf" or $sLowerRead = "nan" or StringInStr($sLowerRead,"e",0) <> 0 Then
$RRead = 999
EndIf
$Array = Internal_ApplyKey($Array,"bSmoothFrameRate=","True")
$Array = Internal_ApplyKey($Array,"MinDesiredFrameRate=",$RRead/2)
$Array = Internal_ApplyKey($Array,"MinSmoothedFrameRate=",$RRead/2)
$Array = Internal_ApplyKey($Array,"MaxSmoothedFrameRate=",$RRead)
EndIf
$Array = Internal_ApplyKey($Array,"MaximumPoolSize=","0")
$Array = Internal_ApplyKey($Array,"MinimumPoolSize=","255")
$Array = Internal_ApplyKey($Array,"LoadMapTimeLimit=","1")
$Array = Internal_ApplyKey($Array,"UseDynamicStreaming=","True")
fSendMetric("event_applychanges_engine_complete")
ElseIf $State = "SystemSettings" Then
$Array = Internal_ApplySystemKey($Array,"DepthOfField=","False")
$Array = Internal_ApplySystemKey($Array,"DirectionalLightmaps=","True")
$Array = Internal_ApplySystemKey($Array,"MotionBlur=","False")
$Array = Internal_ApplySystemKey($Array,"MotionBlurPause=","False")
$Array = Internal_ApplySystemKey($Array,"MotionBlurSkinning=","1")
$Array = Internal_ApplySystemKey($Array,"MaxFilterBlurSampleCount=","4")
If $ProgramHomeState = "Simple" Then
Local $Quality = GUICtrlRead($MainGUIHomeSimpleComboWorldQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 0
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
$HSubIndex = 2
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
If $Quality > 2 Then
$Array = Internal_ApplySystemKey($Array,"SpeedTreeWind=","False")
$Array = Internal_ApplySystemKey($Array,"SpeedTreeLeaves=","False")
$Array = Internal_ApplySystemKey($Array,"SpeedTreeFronds=","False")
$Array = Internal_ApplySystemKey($Array,"SpeedTreeLODBias=","0")
$Array = Internal_ApplySystemKey($Array,"bAllowLightShafts=","False")
$Array = Internal_ApplySystemKey($Array,"FogVolumes=","False")
$Array = Internal_ApplySystemKey($Array,"Distortion=","False")
$Array = Internal_ApplySystemKey($Array,"FilteredDistortion=","False")
Else
$Array = Internal_ApplySystemKey($Array,"SpeedTreeWind=","True")
$Array = Internal_ApplySystemKey($Array,"SpeedTreeLeaves=","True")
$Array = Internal_ApplySystemKey($Array,"SpeedTreeFronds=","True")
$Array = Internal_ApplySystemKey($Array,"SpeedTreeLODBias=","2")
$Array = Internal_ApplySystemKey($Array,"bAllowLightShafts=","True")
$Array = Internal_ApplySystemKey($Array,"FogVolumes=","True")
$Array = Internal_ApplySystemKey($Array,"Distortion=","True")
$Array = Internal_ApplySystemKey($Array,"FilteredDistortion=","True")
EndIf
Local $Quality = GUICtrlRead($MainGUIHomeSimpleComboCharacterQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 1
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $HSubIndex = 3
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $HSubIndex = 4
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $HSubIndex = 5
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeSimpleComboShadowQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 6
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
If $Quality > 2 Then
$Array = Internal_ApplySystemKey($Array,"bAllowDropShadows=","False")
$Array = Internal_ApplySystemKey($Array,"bAllowWholeSceneDominantShadows=","False")
$Array = Internal_ApplySystemKey($Array,"bUseConservativeShadowBounds=","False")
$Array = Internal_ApplySystemKey($Array,"LightEnvironmentShadows=","False")
Else
$Array = Internal_ApplySystemKey($Array,"bAllowDropShadows=","True")
$Array = Internal_ApplySystemKey($Array,"bAllowWholeSceneDominantShadows=","True")
$Array = Internal_ApplySystemKey($Array,"bUseConservativeShadowBounds=","True")
$Array = Internal_ApplySystemKey($Array,"LightEnvironmentShadows=","True")
EndIf
Local $Quality = GUICtrlRead($MainGUIHomeSimpleComboSkyQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 7
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeSimpleComboEffectsParticleQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 8
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
If $Quality = 0 Then
$Array = Internal_ApplySystemKey($Array,"DropParticleDistortion=","False")
$Array = Internal_ApplySystemKey($Array,"ParticleLODBias=","0")
$Array = Internal_ApplySystemKey($Array,"PerfScalingBias=","0")
ElseIf $Quality = 1 Then
$Array = Internal_ApplySystemKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySystemKey($Array,"ParticleLODBias=","1")
$Array = Internal_ApplySystemKey($Array,"PerfScalingBias=","0.1")
ElseIf $Quality = 2 Then
$Array = Internal_ApplySystemKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySystemKey($Array,"ParticleLODBias=","2")
$Array = Internal_ApplySystemKey($Array,"PerfScalingBias=","0.2")
ElseIf $Quality >= 3 Then
$Array = Internal_ApplySystemKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySystemKey($Array,"ParticleLODBias=","10")
$Array = Internal_ApplySystemKey($Array,"PerfScalingBias=","0.2")
EndIf
Local $RRead = GUICtrlRead($MainGUIHomeSimpleComboScreenRes)
Local $SplitC = StringSplit($RRead,"x")
_ArrayDelete($SplitC,0)
$SplitC[0] = StringReplace($SplitC[0],"Custom (",$sEmpty)
Local $ScreenResX = Number($SplitC[0])
Local $ScreenResY = Number($SplitC[1])
$Array = Internal_ApplySystemKey($Array,"ResX=",$ScreenResX)
$Array = Internal_ApplySystemKey($Array,"ResY=",$ScreenResY)
Local $Mode = GUICtrlRead($MainGUIHomeSimpleComboWindowmode)
If $Mode = "Fullscreen" Then
$Array = Internal_ApplySystemKey($Array,"Fullscreen=","True")
$Array = Internal_ApplySystemKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplySystemKey($Array,"Borderless=","False")
ElseIf $Mode = "Borderless Window" Then
$Array = Internal_ApplySystemKey($Array,"Fullscreen=","False")
$Array = Internal_ApplySystemKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplySystemKey($Array,"Borderless=","True")
ElseIf $Mode = "Windowed" Then
$Array = Internal_ApplySystemKey($Array,"Fullscreen=","False")
$Array = Internal_ApplySystemKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplySystemKey($Array,"Borderless=","False")
EndIf
Local $RsEn = GUICtrlRead($MainGUIHomeSimpleSliderScreenResScale)
If $RsEn <> 100 Then
$Array = Internal_ApplySystemKey($Array,"ScreenPercentage=",$RsEn)
$Array = Internal_ApplySystemKey($Array,"UpscaleScreenPercentage=","True")
Else
$Array = Internal_ApplySystemKey($Array,"ScreenPercentage=","100")
$Array = Internal_ApplySystemKey($Array,"UpscaleScreenPercentage=","False")
EndIf
$Array = Internal_ApplySystemKey($Array,"UseDX11=","True")
$Array = Internal_ApplySystemKey($Array,"AllowD3D11=","True")
$Array = Internal_ApplySystemKey($Array,"PreferD3D11=","True")
$Array = Internal_ApplySystemKey($Array,"UseD3D11Beta=","True")
Local $AARead = GUICtrlRead($MainGUIHomeSimpleComboAntialiasing)
If $AARead = "Off" Then
$AARead = 0
ElseIf $AARead = "Low" Then
$AARead = 1
ElseIf $AARead = "Medium" Then
$AARead = 2
ElseIf $AARead = "High" Then
$AARead = 3
EndIf
$Array = Internal_ApplySystemKey($Array,"FXAAQuality=",$AARead)
Local $AFRead = GUICtrlRead($MainGUIHomeSimpleComboMaxAnisotropy)
If $AFRead = "Off" Then
$AFRead = "0"
Else
$AFRead = StringReplace($AFRead,"x",$sEmpty)
EndIf
$Array = Internal_ApplySystemKey($Array,"MaxAnisotropy=",$AFRead)
Local $DecalsRead = GUICtrlRead($MainGUIHomeSimpleCheckboxDecals)
$Array = Internal_ApplySystemKey($Array,"MaxActiveDecals=","0")
If $DecalsRead = $GUI_UNCHECKED Then
$Array = Internal_ApplySystemKey($Array,"StaticDecals=","False")
$Array = Internal_ApplySystemKey($Array,"DynamicDecals=","False")
$Array = Internal_ApplySystemKey($Array,"UnbatchedDecals=","False")
ElseIf $DecalsRead = $GUI_CHECKED Then
$Array = Internal_ApplySystemKey($Array,"StaticDecals=","True")
$Array = Internal_ApplySystemKey($Array,"DynamicDecals=","True")
$Array = Internal_ApplySystemKey($Array,"UnbatchedDecals=","True")
EndIf
Local $DASRead = GUICtrlRead($MainGUIHomeSimpleCheckboxDynamicLightShadows)
If $DASRead = $GUI_UNCHECKED Then
$Array = Internal_ApplySystemKey($Array,"DynamicLights=","False")
$Array = Internal_ApplySystemKey($Array,"CompositeDynamicLights=","False")
$Array = Internal_ApplySystemKey($Array,"SHSecondaryLighting=","False")
$Array = Internal_ApplySystemKey($Array,"DynamicShadows=","False")
ElseIf $DASRead = $GUI_CHECKED Then
$Array = Internal_ApplySystemKey($Array,"DynamicLights=","True")
$Array = Internal_ApplySystemKey($Array,"CompositeDynamicLights=","True")
$Array = Internal_ApplySystemKey($Array,"SHSecondaryLighting=","True")
$Array = Internal_ApplySystemKey($Array,"DynamicShadows=","True")
EndIf
Local $ReflectionsRead = GUICtrlRead($MainGUIHomeSimpleCheckboxReflections)
If $ReflectionsRead = $GUI_UNCHECKED Then
$Array = Internal_ApplySystemKey($Array,"AllowImageReflections=","False")
$Array = Internal_ApplySystemKey($Array,"AllowImageReflectionShadowing=","False")
ElseIf $ReflectionsRead = $GUI_CHECKED Then
$Array = Internal_ApplySystemKey($Array,"AllowImageReflections=","True")
$Array = Internal_ApplySystemKey($Array,"AllowImageReflectionShadowing=","True")
EndIf
Local $FPSRead = GUICtrlRead($MainGUIHomeSimpleInputMaxFPS)
If $FPSRead < 30 Then $FPSRead = 30
Local $sLowerRead = StringLower($FPSRead)
If $sLowerRead = "inf" or $sLowerRead = "nan" or StringInStr($sLowerRead,"e",0) <> 0 Then
$FPSRead = 999
EndIf
$Array = Internal_ApplySystemKey($Array,"TargetFrameRate=",$FPSRead)
Local $DetailModeRead = GUICtrlRead($MainGUIHomeSimpleComboDetailMode)
$Array = Internal_ApplySystemKey($Array,"DetailMode=",$DetailModeRead)
Local $UseVsyncRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxVSync)
$Array = Internal_ApplySystemKey($Array,"UseVsync=",$UseVsyncRead)
$Array = Internal_ApplySystemKey($Array,"VsyncPresentInterval=","1")
Local $PhysXRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxRagdollPhysics)
$Array = Internal_ApplySystemKey($Array,"bAllowRagdolling=",$PhysXRead)
Local $BloomRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxBloom)
$Array = Internal_ApplySystemKey($Array,"Bloom=",$BloomRead)
Local $LensFlareRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxLensflares)
$Array = Internal_ApplySystemKey($Array,"LensFlares=",$LensFlareRead)
Local $UncompTextRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxHighQualityMats)
$Array = Internal_ApplySystemKey($Array,"bAllowHighQualityMaterials=",$UncompTextRead)
$Array = Internal_ApplySystemKey($Array,"bUseLowQualMaterials=",not $UncompTextRead)
ElseIf $ProgramHomeState = "Advanced" Then
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboWorldQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 0
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboCharacterQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 1
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboTerrainQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 2
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboNPCQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 3
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboWeaponQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 4
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboVehicleQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 5
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboShadowsQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 6
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboSkyQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 7
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $Quality = GUICtrlRead($MainGUIHomeAdvancedComboEffectsParticleQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 8
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
Local $PQ_LevelRead = GUICtrlRead($MainGUIHomeAdvancedComboParticleQualityLevel)
If $PQ_LevelRead = "Best" Then
$Array = Internal_ApplySystemKey($Array,"DropParticleDistortion=","False")
$Array = Internal_ApplySystemKey($Array,"ParticleLODBias=","0")
$Array = Internal_ApplySystemKey($Array,"PerfScalingBias=","0")
ElseIf $PQ_LevelRead = "High" Then
$Array = Internal_ApplySystemKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySystemKey($Array,"ParticleLODBias=","1")
$Array = Internal_ApplySystemKey($Array,"PerfScalingBias=","0.1")
ElseIf $PQ_LevelRead = "Medium" Then
$Array = Internal_ApplySystemKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySystemKey($Array,"ParticleLODBias=","2")
$Array = Internal_ApplySystemKey($Array,"PerfScalingBias=","0.2")
ElseIf $PQ_LevelRead = "Low" Then
$Array = Internal_ApplySystemKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySystemKey($Array,"ParticleLODBias=","10")
$Array = Internal_ApplySystemKey($Array,"PerfScalingBias=","0.2")
EndIf
Local $RRead = GUICtrlRead($MainGUIHomeAdvancedComboScreenRes)
Local $SplitC = StringSplit($RRead,"x")
_ArrayDelete($SplitC,0)
$SplitC[0] = StringReplace($SplitC[0],"Custom (",$sEmpty)
Local $ScreenResX = Number($SplitC[0])
Local $ScreenResY = Number($SplitC[1])
$Array = Internal_ApplySystemKey($Array,"ResX=",$ScreenResX)
$Array = Internal_ApplySystemKey($Array,"ResY=",$ScreenResY)
Local $Mode = GUICtrlRead($MainGUIHomeAdvancedComboWindowmode)
If $Mode = "Fullscreen" Then
$Array = Internal_ApplySystemKey($Array,"Fullscreen=","True")
$Array = Internal_ApplySystemKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplySystemKey($Array,"Borderless=","False")
ElseIf $Mode = "Borderless Window" Then
$Array = Internal_ApplySystemKey($Array,"Fullscreen=","False")
$Array = Internal_ApplySystemKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplySystemKey($Array,"Borderless=","True")
ElseIf $Mode = "Windowed" Then
$Array = Internal_ApplySystemKey($Array,"Fullscreen=","False")
$Array = Internal_ApplySystemKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplySystemKey($Array,"Borderless=","False")
EndIf
Local $RsEn = GUICtrlRead($MainGUIHomeAdvancedSliderScreenResScale)
If $RsEn <> 100 Then
$Array = Internal_ApplySystemKey($Array,"ScreenPercentage=",$RsEn)
$Array = Internal_ApplySystemKey($Array,"UpscaleScreenPercentage=","True")
Else
$Array = Internal_ApplySystemKey($Array,"ScreenPercentage=","100")
$Array = Internal_ApplySystemKey($Array,"UpscaleScreenPercentage=","False")
EndIf
Local $AARead = GUICtrlRead($MainGUIHomeAdvancedComboAntialiasing)
If $AARead = "Off" Then
$AARead = 0
ElseIf $AARead = "Low" Then
$AARead = 1
ElseIf $AARead = "Medium" Then
$AARead = 2
ElseIf $AARead = "High" Then
$AARead = 3
EndIf
$Array = Internal_ApplySystemKey($Array,"FXAAQuality=",$AARead)
Local $AFRead = GUICtrlRead($MainGUIHomeAdvancedComboMaxAnisotropy)
If $AFRead = "Off" Then
$AFRead = "0"
Else
$AFRead = StringReplace($AFRead,"x",$sEmpty)
EndIf
$Array = Internal_ApplySystemKey($Array,"MaxAnisotropy=",$AFRead)
$Array = Internal_ApplySystemKey($Array,"UseDX11=","True")
$Array = Internal_ApplySystemKey($Array,"AllowD3D11=","True")
$Array = Internal_ApplySystemKey($Array,"PreferD3D11=","True")
$Array = Internal_ApplySystemKey($Array,"UseD3D11Beta=","True")
Local $ReflectionsRead = GUICtrlRead($MainGUIHomeAdvancedCheckboxReflections)
If $ReflectionsRead = $GUI_UNCHECKED Then
$Array = Internal_ApplySystemKey($Array,"AllowImageReflections=","False")
$Array = Internal_ApplySystemKey($Array,"AllowImageReflectionShadowing=","False")
ElseIf $ReflectionsRead = $GUI_CHECKED Then
$Array = Internal_ApplySystemKey($Array,"AllowImageReflections=","True")
$Array = Internal_ApplySystemKey($Array,"AllowImageReflectionShadowing=","True")
EndIf
Local $FPSRead = GUICtrlRead($MainGUIHomeAdvancedInputMaxFPS)
If $FPSRead < 30 Then $FPSRead = 30
Local $sLowerRead = StringLower($FPSRead)
If $sLowerRead = "inf" or $sLowerRead = "nan" or StringInStr($sLowerRead,"e",0) <> 0 Then
$FPSRead = 999
EndIf
$Array = Internal_ApplySystemKey($Array,"TargetFrameRate=",$FPSRead)
Local $UseVsyncRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxVSync)
$Array = Internal_ApplySystemKey($Array,"UseVsync=",$UseVsyncRead)
$Array = Internal_ApplySystemKey($Array,"VsyncPresentInterval=","1")
Local $PhysXRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxPhysX)
$Array = Internal_ApplySystemKey($Array,"bAllowRagdolling=",$PhysXRead)
Local $BloomRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxBloom)
$Array = Internal_ApplySystemKey($Array,"Bloom=",$BloomRead)
Local $SpeedTreeWindRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxSpeedTreeWind)
$Array = Internal_ApplySystemKey($Array,"SpeedTreeWind=",$SpeedTreeWindRead)
Local $SpeedTreeLeavesRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxSpeedTreeLeaves)
$Array = Internal_ApplySystemKey($Array,"SpeedTreeLeaves=",$SpeedTreeLeavesRead)
Local $SpeedTreeFrondsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxSpeedTreeFronds)
$Array = Internal_ApplySystemKey($Array,"SpeedTreeFronds=",$SpeedTreeFrondsRead)
Local $SpeedTreeLODBiasRead = GUICtrlRead($MainGUIHomeAdvancedComboSpeedTreeLODBias)
$Array = Internal_ApplySystemKey($Array,"SpeedTreeLODBias=",$SpeedTreeLODBiasRead)
Local $DetailModeRead = GUICtrlRead($MainGUIHomeAdvancedComboDetailMode)
$Array = Internal_ApplySystemKey($Array,"DetailMode=",$DetailModeRead)
Local $LensflaresRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxLensflares)
$Array = Internal_ApplySystemKey($Array,"LensFlares=",$LensflaresRead)
Local $LightEnvShadowsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxLightEnvShadows)
$Array = Internal_ApplySystemKey($Array,"LightEnvironmentShadows=",$LightEnvShadowsRead)
Local $LightShaftsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxLightShafts)
$Array = Internal_ApplySystemKey($Array,"bAllowLightShafts=",$LightShaftsRead)
Local $FogVolumesRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxFogVolumes)
$Array = Internal_ApplySystemKey($Array,"FogVolumes=",$FogVolumesRead)
Local $DistortionRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDistortion)
$Array = Internal_ApplySystemKey($Array,"Distortion=",$DistortionRead)
Local $FilteredDistortionRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxFilteredDistortion)
$Array = Internal_ApplySystemKey($Array,"FilteredDistortion=",$FilteredDistortionRead)
Local $DropShadowsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDropShadows)
$Array = Internal_ApplySystemKey($Array,"bAllowDropShadows=",$DropShadowsRead)
Local $WholeSceneShadowsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxWholeSceneShadows)
$Array = Internal_ApplySystemKey($Array,"bAllowWholeSceneDominantShadows=",$WholeSceneShadowsRead)
Local $ConservShadowBoundsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxConservShadowBounds)
$Array = Internal_ApplySystemKey($Array,"bUseConservativeShadowBounds=",$ConservShadowBoundsRead)
Local $StaticDecalsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxStaticDecals)
$Array = Internal_ApplySystemKey($Array,"StaticDecals=",$StaticDecalsRead)
Local $DynamicDecalsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDynamicDecals)
$Array = Internal_ApplySystemKey($Array,"DynamicDecals=",$DynamicDecalsRead)
Local $UnbatchedDecalsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxUnbatchedDecals)
$Array = Internal_ApplySystemKey($Array,"UnbatchedDecals=",$UnbatchedDecalsRead)
Local $DynamicLightsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDynamicLights)
$Array = Internal_ApplySystemKey($Array,"DynamicLights=",$DynamicLightsRead)
Local $CompositeDynamicLightsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxCompDynamicLights)
$Array = Internal_ApplySystemKey($Array,"CompositeDynamicLights=",$CompositeDynamicLightsRead)
Local $SHSecondaryLightingRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxSHSecondaryLighting)
$Array = Internal_ApplySystemKey($Array,"SHSecondaryLighting=",$SHSecondaryLightingRead)
Local $DynamicShadowsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDynamicShadows)
$Array = Internal_ApplySystemKey($Array,"DynamicShadows=",$DynamicShadowsRead)
Local $UncompTextRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxUncText)
$Array = Internal_ApplySystemKey($Array,"bAllowHighQualityMaterials=",$UncompTextRead)
$Array = Internal_ApplySystemKey($Array,"bUseLowQualMaterials=",not $UncompTextRead)
EndIf
fSendMetric("event_applychanges_system_complete")
ElseIf $State = "GameSettings" Then
EndIf
Return $Array
EndFunc
Func Internal_ApplyFixes($Array,$State)
If $State = "EngineSettings" Then
Local $RRead = GUICtrlRead($MainGUIFixesInputMaxFPS)
If $RRead < 30 Then $RRead = 30
Local $sLowerRead = StringLower($RRead)
If $sLowerRead = "inf" or $sLowerRead = "nan" or StringInStr($sLowerRead,"e",0) <> 0 Then
$RRead = 999
EndIf
$Array = Internal_ApplyKey($Array,"bSmoothFrameRate=","True")
$Array = Internal_ApplyKey($Array,"MinDesiredFrameRate=",$RRead/2)
$Array = Internal_ApplyKey($Array,"MinSmoothedFrameRate=",$RRead/2)
$Array = Internal_ApplyKey($Array,"MaxSmoothedFrameRate=",$RRead)
Local $RRead = GUICtrlRead($MainGUIFixesComboAudioFix)
If $RRead < 32 or $RRead > 512 Then
$RRead = 32
EndIf
$Array = Internal_ApplyKey($Array,"MaxChannels=",$RRead)
fSendMetric("event_applyfixes_engine_complete")
ElseIf $State = "SystemSettings" Then
Local $FPSRead = GUICtrlRead($MainGUIFixesInputMaxFPS)
If $FPSRead < 30 Then $FPSRead = 30
Local $sLowerRead = StringLower($FPSRead)
If $sLowerRead = "inf" or $sLowerRead = "nan" or StringInStr($sLowerRead,"e",0) <> 0 Then
$FPSRead = 999
EndIf
$Array = Internal_ApplySystemKey($Array,"TargetFrameRate=",$FPSRead)
Local $bFogState = GUICtrlRead($MainGUIFixesCheckboxDisableFog)
If $bFogState = $GUI_CHECKED Then
$Array = Internal_ApplySystemKey($Array,"bAllowFog=","False")
$Array = Internal_ApplySystemKey($Array,"FogVolumes=","False")
$Array = Internal_ApplySystemKey($Array,"MobileFog=","False")
$Array = Internal_ApplySystemKey($Array,"MobileHeightFog=","False")
Else
$Array = Internal_ApplySystemKey($Array,"bAllowFog=","True")
$Array = Internal_ApplySystemKey($Array,"FogVolumes=","True")
$Array = Internal_ApplySystemKey($Array,"MobileFog=","True")
$Array = Internal_ApplySystemKey($Array,"MobileHeightFog=","True")
EndIf
fSendMetric("event_applyfixes_system_complete")
ElseIf $State = "GameSettings" Then
Local $bJumpState = GUICtrlRead($MainGUIFixesCheckboxDisableJump)
If $bJumpState = $GUI_CHECKED Then
$Array = Internal_ApplyKey($Array,"bJumpEnabled=","False")
Else
$Array = Internal_ApplyKey($Array,"bJumpEnabled=","True")
EndIf
fSendMetric("event_applyfixes_game_complete")
EndIf
Return $Array
EndFunc
Func Internal_ProcessHandleError($Message,$Bool = True)
GUIDelete($ProcessUI)
GUISetState(@SW_ENABLE,$MainGUI)
WinActivate($MainGUI)
If $Bool Then DisplayErrorMessage($Message)
$ProcessingRequest = False
EndFunc
Func Internal_ProcessRequest($Bool = False,$FixesBool = False)
If ProcessExists("smite.exe") Then
fSendMetric("error_applywhen_smiterunning")
DisplayErrorMessage("Cannot apply settings while SMITE is running!")
Return
EndIf
If $SettingsPath = $sEmpty or $SystemSettingsPath = $sEmpty or $GameSettingsPath = $sEmpty Then
fSendMetric("error_applywith_noconfigpaths")
DisplayErrorMessage("Cannot apply settings; discover the configuration files first!")
Return
EndIf
If $ProcessingRequest Then Return
$ProcessingRequest = True
RegWrite("HKCU\Software\SMITE Optimizer\","NotClosedProperly","REG_SZ","1")
$HoverTipAlpha = 0
WinSetTrans($HoverInfoGUI,$sEmpty,$HoverTipAlpha)
Internal_SaveSettingCookie()
_WinAPI_SetWindowPos($MainGUI,$HWND_TOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
_WinAPI_SetWindowPos($MainGUI,$HWND_NOTOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
GUISetState(@SW_DISABLE,$MainGUI)
Local $WinPos = WinGetPos($MainGUI)
Global $ProcessUI = GUICreate("SO_PROCESSING",400,150,$WinPos[0] +($WinPos[2]/2)-200,$WinPos[1] +($WinPos[3]/2)-75,$WS_POPUP,$WS_EX_TOOLWINDOW)
GUISetBkColor($cBackgroundColor)
Local $ProcessUIBG = GUICtrlCreatePic($sEmpty,0,0,400,150)
LoadImageResource($ProcessUIBG,$MainResourcePath & "NotificationBG.jpg","NotificationBG")
Local $ProcessUILabelMainStatus = GUICtrlCreateLabelTransparentBG("Processing..",5,0,300,30)
GUICtrlSetFont(-1,20,500,Default,$MainFontName)
Local $ProcessUILabelCATC = GUICtrlCreateLabelTransparentBG("(Click to continue)",105,4,250,30)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetState(-1,$GUI_HIDE)
Local $ProcessUILabelStatusBackup = GUICtrlCreateLabelTransparentBG("[X] Creating backup",5,35,300,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUILabelStatusRead = GUICtrlCreateLabelTransparentBG("[X] Reading files",5,50,300,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUILabelStatusVerify = GUICtrlCreateLabelTransparentBG("[X] Verifying and repairing integrity",5,65,300,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUILabelStatusApply = GUICtrlCreateLabelTransparentBG("[X] Applying settings",5,80,300,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUILabelStatusSave = GUICtrlCreateLabelTransparentBG("[X] Saving",5,95,300,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUIProgress = GUICtrlCreateProgress(5,120,390,25)
GUICtrlSetColor(-1,0xFF0000)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUISetState(@SW_SHOW,$ProcessUI)
GUISwitch($ProcessUI)
Local $PState = 0
While True
Local $CursorInfo = GUIGetCursorInfo($ProcessUI)
If $PState = 0 Then
Local $Success = Internal_CreateConfigBackup()
If not $Success Then
fSendMetric("error_configbackup_code3")
Internal_ProcessHandleError("There was an error creating the configuration backup! (Not successful) Code: 003")
ExitLoop
EndIf
GUICtrlSetData($ProcessUIProgress,20)
GUICtrlSetColor($ProcessUILabelStatusBackup,0x00FF00)
GUICtrlSetData($ProcessUILabelStatusBackup,"[✓] Creating backup")
$PState = $PState + 1
ElseIf $PState = 1 Then
Local $EngineFile
Local $SystemFile
Local $GameFile
Local $EngineFileFallback[1]
Local $SystemFileFallback[1]
Local $GameFileFallback[1]
_FileReadToArray($SettingsPath,$EngineFile,$FRTA_NOCOUNT)
If not IsArray($EngineFile) Then $EngineFile = $EngineFileFallback
_FileReadToArray($SystemSettingsPath,$SystemFile,$FRTA_NOCOUNT)
If not IsArray($SystemFile) Then $SystemFile = $SystemFileFallback
_FileReadToArray($GameSettingsPath,$GameFile,$FRTA_NOCOUNT)
If not IsArray($GameFile) Then $GameFile = $GameFileFallback
GUICtrlSetData($ProcessUIProgress,40)
GUICtrlSetColor($ProcessUILabelStatusRead,0x00FF00)
GUICtrlSetData($ProcessUILabelStatusRead,"[✓] Reading files")
$PState = $PState + 1
ElseIf $PState = 2 Then
Local $EngineSF = Interal_VerifyAndFixConfiguration($EngineFile,$EngineSettingsClearHive)
Local $SystemSF = Interal_VerifyAndFixConfiguration($SystemFile,$SystemSettingsClearHive)
Local $GameSF = Interal_VerifyAndFixConfiguration($GameFile,$GameSettingsClearHive)
GUICtrlSetData($ProcessUIProgress,60)
GUICtrlSetColor($ProcessUILabelStatusVerify,0x00FF00)
GUICtrlSetData($ProcessUILabelStatusVerify,"[✓] Verifying and repairing integrity")
$PState = $PState + 1
ElseIf $PState = 3 Then
If $Bool Then
If not $FixesBool Then
$EngineSF = Internal_ApplyChanges($EngineSF,"EngineSettings")
$SystemSF = Internal_ApplyChanges($SystemSF,"SystemSettings")
$GameSF = Internal_ApplyChanges($GameSF,"GameSettings")
Else
$EngineSF = Internal_ApplyFixes($EngineSF,"EngineSettings")
$SystemSF = Internal_ApplyFixes($SystemSF,"SystemSettings")
$GameSF = Internal_ApplyFixes($GameSF,"GameSettings")
EndIf
GUICtrlSetData($ProcessUIProgress,80)
GUICtrlSetColor($ProcessUILabelStatusApply,0x00FF00)
GUICtrlSetData($ProcessUILabelStatusApply,"[✓] Applying settings")
Else
GUICtrlSetData($ProcessUIProgress,80)
GUICtrlSetColor($ProcessUILabelStatusApply,0x0000FF)
GUICtrlSetData($ProcessUILabelStatusApply,"[X] Applying settings (Skipped)")
EndIf
$PState = $PState + 1
ElseIf $PState = 4 Then
FileDelete($SettingsPath)
FileDelete($SystemSettingsPath)
_FileWriteFromArray($SettingsPath,$EngineSF)
If @Error <> 0 Then
fSendMetric("error_writeconfig_code4")
Internal_ProcessHandleError("There was an error when writing to the configuration files! (Engine) Code: 004"&@CRLF&"Make sure the configuration files can be written to (Check read only status)")
ExitLoop
EndIf
_FileWriteFromArray($SystemSettingsPath,$SystemSF)
If @Error <> 0 Then
fSendMetric("error_writeconfig_code5")
Internal_ProcessHandleError("There was an error when writing to the configuration files! (System) Code: 005"&@CRLF&"Make sure the configuration files can be written to (Check read only status)")
ExitLoop
EndIf
_FileWriteFromArray($GameSettingsPath,$GameSF)
If @Error <> 0 Then
fSendMetric("error_writeconfig_code13")
Internal_ProcessHandleError("There was an error when writing to the configuration files! (Game) Code: 013"&@CRLF&"Make sure the configuration files can be written to (Check read only status)")
ExitLoop
EndIf
GUICtrlSetData($ProcessUIProgress,100)
GUICtrlSetColor($ProcessUILabelStatusSave,0x00FF00)
GUICtrlSetData($ProcessUILabelStatusSave,"[✓] Saving")
GUICtrlSetState($ProcessUILabelMainStatus,$GUI_HIDE)
GUICtrlSetState($ProcessUILabelCATC,$GUI_SHOW)
$PState = $PState + 1
EndIf
If WinGetTitle("[active]") = "SO_PROCESSING" and @Error = 0 Then
Switch $CursorInfo[4]
Case $ProcessUIBG, $ProcessUILabelMainStatus, $ProcessUILabelCATC, $ProcessUILabelStatusBackup, $ProcessUILabelStatusRead, $ProcessUILabelStatusVerify, $ProcessUILabelStatusApply, $ProcessUILabelStatusSave, $ProcessUIProgress
If $PState = 5 and _IsPressed("01") Then
Internal_ProcessHandleError($sEmpty,False)
ExitLoop
EndIf
EndSwitch
Sleep(10)
Else
If WinGetTitle("[active]") = $ProgramName Then WinActivate($ProcessUI)
Sleep(100)
EndIf
WEnd
RegDelete("HKCU\Software\SMITE Optimizer\","NotClosedProperly")
EndFunc
Func Internal_ExportSettings()
GUISetState(@SW_DISABLE,$MainGUI)
Local $S_Title = $ProgramName & " HUD Configuration Exporter"
Local $GUI_ExportSettings = GUICreate($S_Title,320,80,-1,-1,$WS_POPUP,$WS_EX_TOOLWINDOW)
GUISwitch($GUI_ExportSettings)
GUISetBkColor($cAccentColor,$GUI_ExportSettings)
Local $GUI_LabelInfo = GUICtrlCreateLabelTransparentBG("Select which HUD to export:",7,5,313,35)
GUICtrlSetFont(-1,12,Default,Default,$WindowsUIFont)
Local $GUI_ButtonClassic = GUICtrlCreateButtonSO($MainGUI,"Classic",5,40,100,35,$cAccentColor,$cTextColor,$cBackgroundColor)
Local $GUI_ButtonNew = GUICtrlCreateButtonSO($MainGUI,"New",110,40,100,35,$cAccentColor,$cTextColor,$cBackgroundColor)
Local $GUI_ButtonCancel = GUICtrlCreateButtonSO($MainGUI,"Cancel",215,40,100,35,$cAccentColor,$cTextColor,$cBackgroundColor)
GUISetState()
Local $GameFile
_FileReadToArray($GameSettingsPath,$GameFile,$FRTA_NOCOUNT)
If not IsArray($GameFile) Then
fSendMetric("error_exporthud1_code19")
DisplayErrorMessage("Could not read EngineGame.ini Code: 19")
Return
EndIf
Local $S_ExportData = $sEmpty
Local $S_ExportData_2 = $sEmpty
Local $S_ExportData_3 = $sEmpty
While True
Local $CursorInfo = GUIGetCursorInfo($GUI_ExportSettings)
If WinGetTitle("[active]") = $S_Title and @Error = 0 Then
If _IsPressed("1B") Then
ExitLoop(1)
EndIf
If _IsPressed("01") Then
While _IsPressed("01")
Sleep(10)
WEnd
Switch $CursorInfo[4]
Case $GUI_ButtonClassic
For $I = 0 To uBound($GameFile) - 1 Step 1
If StringLeft($GameFile[$I],18) == "TransformSettings=" Then
$S_ExportData = $GameFile[$I]
ExitLoop
EndIf
Next
If $S_ExportData == $sEmpty Then
fSendMetric("error_exporthud2_code19")
DisplayErrorMessage("Could not read EngineGame.ini Code: 19")
ExitLoop(1)
EndIf
ExitLoop(1)
Case $GUI_ButtonNew
For $I = 0 To uBound($GameFile) - 1 Step 1
If StringLeft($GameFile[$I],20) == "TransformSettingsV2=" Then
$S_ExportData = $GameFile[$I]
ExitLoop
EndIf
Next
For $I = 0 To uBound($GameFile) - 1 Step 1
If StringLeft($GameFile[$I],27) == "NewHudTransformSettingsKBM=" Then
$S_ExportData_2 = $GameFile[$I]
ExitLoop
EndIf
Next
For $I = 0 To uBound($GameFile) - 1 Step 1
If StringLeft($GameFile[$I],27) == "NewHudTransformSettingsGMP=" Then
$S_ExportData_3 = $GameFile[$I]
ExitLoop
EndIf
Next
If $S_ExportData == $sEmpty or $S_ExportData_2 == $sEmpty or $S_ExportData_3 == $sEmpty Then
fSendMetric("error_exporthud3_code19")
DisplayErrorMessage("Could not read EngineGame.ini Code: 19")
ExitLoop(1)
EndIf
ExitLoop(1)
Case $GUI_ButtonCancel
ExitLoop(1)
EndSwitch
EndIf
Sleep(10)
Else
If WinGetTitle("[active]") = $ProgramName Then WinActivate($GUI_ExportSettings)
Sleep(100)
EndIf
WEnd
If $S_ExportData_2 <> $sEmpty Then
Local $ExportPath = FileSelectFolder("Choose a directory to save the file.",@DesktopDir)
If not @Error and $ExportPath <> $sEmpty Then
FileDelete($ExportPath & "/Export_NewHUD.ini")
Sleep(100)
If @Error Then
fSendMetric("error_newexporthud_notsaved")
DisplayErrorMessage("Something went wrong while saving." & @CRLF & "If the file already exists, delete it, then try to create it again.")
Return
EndIf
FileWrite($ExportPath & "/Export_NewHUD.ini",$S_ExportData & @CRLF & $S_ExportData_2 & @CRLF & $S_ExportData_3)
If @Error Then
fSendMetric("error_newexporthud_notsaved")
DisplayErrorMessage("Something went wrong while saving." & @CRLF & "If the file already exists, delete it, then try to create it again.")
Return
EndIf
fSendMetric("event_newexporthud_success")
MsgBox(0,"Success!","New HUD settings were exported to:" & @CRLF & $ExportPath)
EndIf
ElseIf $S_ExportData <> $sEmpty Then
Local $ExportPath = FileSelectFolder("Choose a directory to save the file.",@DesktopDir)
If not @Error and $ExportPath <> $sEmpty Then
FileDelete($ExportPath & "/Export_ClassicHUD.ini")
Sleep(100)
If @Error Then
fSendMetric("error_classicexporthud_notsaved")
DisplayErrorMessage("Something went wrong while saving." & @CRLF & "If the file already exists, delete it, then try to create it again.")
Return
EndIf
FileWrite($ExportPath & "/Export_ClassicHUD.ini",$S_ExportData)
If @Error Then
fSendMetric("error_classicexporthud_notsaved")
DisplayErrorMessage("Something went wrong while saving." & @CRLF & "If the file already exists, delete it, then try to create it again.")
Return
EndIf
fSendMetric("event_classicexporthud_success")
MsgBox(0,"Success!","Classic HUD settings were exported to:" & @CRLF & $ExportPath)
EndIf
EndIf
GUIDelete($GUI_ExportSettings)
GUISwitch($MainGUI)
GUISetState(@SW_ENABLE,$MainGUI)
WinActivate($MainGUI)
EndFunc
Func Internal_ImportSettings()
If ProcessExists("smite.exe") Then
fSendMetric("error_hudimportwhen_smiterunning")
DisplayErrorMessage("Cannot import HUD settings while SMITE is running!")
Return
EndIf
Local $FileSelected = FileOpenDialog("Choose Export_ClassicHUD.ini or Export_NewHUD.ini",@DesktopDir,".INI Files (*.ini)",BitOr($FD_FILEMUSTEXIST,$FD_PATHMUSTEXIST))
If not @Error and $FileSelected <> $sEmpty Then
Local $sFileName
Local $bFound = False
For $I = StringLen($FileSelected) To 1 Step -1
Local $sStr = StringLower(StringMid($FileSelected,$I,$I))
If $sStr == "export_classichud.ini" or $sStr == "export_newhud.ini" Then
$sFileName = StringMid($FileSelected,$I)
$bFound = True
ExitLoop
EndIf
Next
Local $bContentFine = False
Local $bFoundClassic = False
Local $bFoundV2 = False
Local $bFoundKBM = False
Local $bFoundGMP = False
Local $sDataClassic
Local $sDataV2
Local $sDataV2KBM
Local $sDataV2GMP
If $bFound Then
Local $aExtracted[0]
_FileReadToArray($FileSelected,$aExtracted,$FRTA_NOCOUNT)
If not IsArray($aExtracted) Then
fSendMetric("error_hudimport1_code20")
DisplayErrorMessage("Could not read the supplied file! Code: 20")
Return
EndIf
For $I = 0 To uBound($aExtracted) - 1 Step 1
If StringLeft($aExtracted[$I],18) == "TransformSettings=" Then
$bFoundClassic = True
$sDataClassic = $aExtracted[$I]
ElseIf StringLeft($aExtracted[$I],20) == "TransformSettingsV2=" Then
$bFoundV2 = True
$sDataV2 = $aExtracted[$I]
ElseIf StringLeft($aExtracted[$I],27) == "NewHudTransformSettingsKBM=" Then
$bFoundKBM = True
$sDataV2KBM = $aExtracted[$I]
ElseIf StringLeft($aExtracted[$I],27) == "NewHudTransformSettingsGMP=" Then
$bFoundGMP = True
$sDataV2GMP = $aExtracted[$I]
EndIf
Next
If $bFoundClassic or($bFoundV2 and $bFoundKBM and $bFoundGMP) Then
$bContentFine = True
Else
fSendMetric("error_hudimport2_code20")
DisplayErrorMessage("Could not read the supplied file! Code: 20")
Return
EndIf
EndIf
If $bContentFine Then
Internal_CreateConfigBackup()
Local $GameFile
_FileReadToArray($GameSettingsPath,$GameFile,$FRTA_NOCOUNT)
If not IsArray($GameFile) Then
fSendMetric("error_hudimport3_code20")
DisplayErrorMessage("Could not read EngineGame.ini Code: 20")
Return
EndIf
For $I = 0 To uBound($GameFile) - 1 Step 1
If $bFoundClassic and StringLeft($GameFile[$I],18) == "TransformSettings=" Then
$GameFile[$I] = $sDataClassic & @CRLF
ElseIf $bFoundV2 and StringLeft($GameFile[$I],20) == "TransformSettingsV2=" Then
$GameFile[$I] = $sDataV2 & @CRLF
ElseIf $bFoundKBM and StringLeft($GameFile[$I],27) == "NewHudTransformSettingsKBM=" Then
$GameFile[$I] = $sDataV2KBM & @CRLF
ElseIf $bFoundKBM and StringLeft($GameFile[$I],27) == "NewHudTransformSettingsGMP=" Then
$GameFile[$I] = $sDataV2GMP & @CRLF
EndIf
Next
_FileWriteFromArray($GameSettingsPath,$GameFile)
If not @Error Then
fSendMetric("event_importhud_success")
MsgBox(0,"Success!","HUD Configuration imported and applied successfully!")
EndIf
EndIf
EndIf
EndFunc
Func Internal_CreateQuicklaunchBypass()
MsgBox(0,$ProgramName,'Patch 11.4 removed "-nosteam" and "-noepic" functionality which broke this feature.' & @CRLF & "It cannot be restored to a working state.")
EndFunc
Func Internal_InstallLegacyLauncher()
MsgBox(0,$ProgramName,'Patch 11.4 removed "-nosteam" and "-noepic" functionality which broke this feature.' & @CRLF & "It cannot be restored to a working state.")
EndFunc
Func Internal_FixEAC()
If @OSVersion <> "WIN_XP" and IsAdmin() == 0 Then
MsgBox($MB_OK,"Information","SMITE Optimizer needs administrator privileges to repair EasyAntiCheat!")
Return
EndIf
fSendMetric("action_fixes_eac")
Local $aFileList = _FileListToArrayRec("C:\Users\" & @UserName & "\AppData\Roaming\EasyAntiCheat","*.eac",$FLTAR_FILES,$FLTAR_RECUR,Default,$FLTAR_FULLPATH)
_ArrayDelete($aFileList,0)
For $I = 0 To uBound($aFileList) - 1 Step 1
Local $bSucc = FileDelete($aFileList[$I])
If Not $bSucc Then
fSendMetric("error_fixes_eac_filedel")
DisplayErrorMessage("Error",$MainGUI,"Failed to delete: " & @CRLF & $aFileList[$I] & @CRLF & "Cannot continue.")
Return
EndIf
Next
Local $sPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")
If @Error Or $sPath = $sEmpty Then
$sPath = "C:\Program Files (x86)\Steam\steamapps\common\SMITE"
EndIf
If not FileExists($sPath) Then
$sPath = "C:\ProgramData\Epic\EpicGamesLauncher\Data\Manifests"
Local $Files = _FileListToArray($sPath,"*.item",1,True)
_ArrayDelete($Files,0)
For $I = 0 To uBound($Files) - 1 Step 1
Local $Read = FileReadToArray($Files[$I])
For $B = 0 To uBound($Read) - 1 Step 1
Local $Str = StringLeft($Read[$B],20)
If $Str == @TAB&'"InstallLocation": ' and StringInStr($Read[$B],"SMITE",0,1) <> 0 Then
Local $NewStr = StringReplace($Read[$B],"\\","\")
$NewStr = StringReplace($NewStr,'"InstallLocation": "',$sEmpty)
$NewStr = StringReplace($NewStr,'",',$sEmpty)
$NewStr = StringReplace($NewStr,@TAB,$sEmpty)
$sPath = $NewStr
ExitLoop(2)
EndIf
Next
Next
If not FileExists($sPath) Then
fSendMetric("error_fixes_eac_nogame")
DisplayErrorMessage("Error",$MainGUI,"Failed to retrieve game location!")
Return
EndIf
EndIf
$sPath = $sPath & "\EasyAntiCheat\EasyAntiCheat_EOS_Setup.exe"
If not FileExists($sPath) Then
fSendMetric("error_fixes_eac_nosetup_eos")
$sPath = $sPath & "\EasyAntiCheat\EasyAntiCheat_Setup.exe"
If not FileExists($sPath) Then
fSendMetric("error_fixes_eac_nosetup_both")
DisplayErrorMessage("Error",$MainGUI,"Failed to retrieve location of EasyAntiCheat installer!")
Return
EndIf
EndIf
ShellExecuteWait($sPath,"uninstall f71b1231985f48d1af3de723e0a6acdd")
ShellExecuteWait($sPath,"install f71b1231985f48d1af3de723e0a6acdd")
RunWait(@ComSpec & " /c " & 'sc config "EasyAntiCheat" start= demand',$sEmpty,@SW_HIDE)
fSendMetric("action_fixes_eac_success")
MsgBox(0,"Information","Repaired EasyAntiCheat successfully.")
EndFunc
Func InRange2D($MousePos,$X_Start,$Y_Start,$X_End,$Y_End)
If $DisplayHoverBG <> 1 Then
Local $XOffset
If $ProgramHomeState = "Simple" Then
$XOffset = ControlGetPos($MainGUI,$sEmpty,$MainGUIHomeSimpleComboWorldQuality)[0]
ElseIf $ProgramHomeState = "Advanced" Then
$XOffset = ControlGetPos($MainGUI,$sEmpty,$MainGUIHomeAdvancedComboWorldQuality)[0]
EndIf
$X_Start = $X_Start - 100 + $XOffset
$X_End = $X_End - 100 + $XOffset
If($MousePos[0] >= $X_Start and $MousePos[0] <= $X_End) and($MousePos[1] >= $Y_Start and $MousePos[1] <= $Y_End) Then
$DisplayHoverBG = 1
Return True
EndIf
EndIf
Return False
EndFunc
Func DisplayHoverImage($X,$Y,$X_Size,$Y_Size,$Image,$X_Pic,$Y_Pic,$X_Size_Pic,$Y_Size_Pic,$IsAnimated = False)
If($DisplayHoverBG = 1 and not $HoverBGDrawn) or $HoverID <> $X+$Y Then
Local $XOffset
If $MenuSelected = 2 Then
$XOffset = -100 + ControlGetPos($MainGUI,$sEmpty,$MainGUIFixesLabelMaxFPS)[0]
ElseIf $ProgramHomeState = "Simple" Then
$XOffset = -100 + ControlGetPos($MainGUI,$sEmpty,$MainGUIHomeSimpleComboWorldQuality)[0]
ElseIf $ProgramHomeState = "Advanced" Then
$XOffset = -100 + ControlGetPos($MainGUI,$sEmpty,$MainGUIHomeAdvancedComboWorldQuality)[0]
EndIf
GUICtrlSetPos($MainGUIHomeHelpBackground,$X + $XOffset,$Y,$X_Size,$Y_Size)
$HoverBGDrawn = True
$HoverID = $X + $Y
ElseIf $DisplayHoverImage = 1 Then
Local $WinPos = WinGetPos($MainGUI)
Local $XOffset
If $MenuSelected = 2 Then
$XOffset = -100 + ControlGetPos($MainGUI,$sEmpty,$MainGUIFixesInputMaxFPS)[0]
ElseIf $ProgramHomeState = "Simple" Then
$XOffset = -100 + ControlGetPos($MainGUI,$sEmpty,$MainGUIHomeSimpleComboWorldQuality)[0]
ElseIf $ProgramHomeState = "Advanced" Then
$XOffset = -100 + ControlGetPos($MainGUI,$sEmpty,$MainGUIHomeAdvancedComboWorldQuality)[0]
EndIf
WinMove($HoverInfoGUI,$sEmpty,$WinPos[0] + $X_Pic + $XOffset,$WinPos[1] + $Y_Pic,$X_Size_Pic,$Y_Size_Pic)
If $IsAnimated Then
If $HoverInfoGUIImageAnimation <> NULL Then
GUICtrlDeleteGIF($HoverInfoGUIImageAnimation)
$HoverInfoGUIImageAnimation = NULL
EndIf
GUISwitch($HoverInfoGUI)
Local $StrippedImageStr = StringReplace($Image,@ScriptDir,$sEmpty)
$StrippedImageStr = StringReplace($StrippedImageStr,"\Resource\HelpText/",$sEmpty)
$StrippedImageStr = StringReplace($StrippedImageStr,".gif",$sEmpty)
Local $iFrameCount = 32
If $StrippedImageStr = "DetailMode" Then
$iFrameCount = 20
EndIf
If @Compiled Then
$HoverInfoGUIImageAnimation = GUICtrlCreateGIF( _Resource_GetAsImage($StrippedImageStr & "GIF") ,0,0,$X_Size_Pic,$Y_Size_Pic,$iFrameCount,100,True)[0]
Else
$HoverInfoGUIImageAnimation = GUICtrlCreateGIF($Image,0,0,$X_Size_Pic,$Y_Size_Pic,$iFrameCount,100)[0]
EndIf
GUISwitch($MainGUI)
$HelpIsAnimating = True
Else
WinSetTrans($HoverInfoGUI,$sEmpty,0)
GUICtrlSetPos($MainGUIHomeHelpImage,0,0,$X_Size_Pic,$Y_Size_Pic)
Local $StrippedImageStr = StringReplace($Image,@ScriptDir,$sEmpty)
$StrippedImageStr = StringReplace($StrippedImageStr,"\Resource\HelpText/",$sEmpty)
$StrippedImageStr = StringReplace($StrippedImageStr,".jpg",$sEmpty)
LoadImageResource($MainGUIHomeHelpImage,$Image,$StrippedImageStr)
WinSetTrans($HoverInfoGUI,$sEmpty,$HoverTipAlpha)
If $HelpIsAnimating Then
If $HoverInfoGUIImageAnimation <> NULL Then
GUICtrlDeleteGIF($HoverInfoGUIImageAnimation)
$HoverInfoGUIImageAnimation = NULL
EndIf
$HelpIsAnimating = False
EndIf
EndIf
$DisplayHoverImage = -1
$HoverImageDrawn = True
EndIf
EndFunc
GUIRegisterMsg($WM_COMMAND,"Internal_HideHelpPopupOnComboChange")
Func Internal_HideHelpPopupOnComboChange($hWnd,$msg,$wParam)
Local $nNotifyCode = BitShift($wParam,16)
Switch $nNotifyCode
Case $CBN_DROPDOWN
$DisplayHoverImage = -2
$SupressHoverImage = True
Case $CBN_CLOSEUP
$DisplayHoverImage = 0
$SupressHoverImage = False
EndSwitch
Return $GUI_RUNDEFMSG
EndFunc
Func _FixMenuSwitch()
If $MainGUIButtonCloseBool Then
UndoMenuHoverState()
LoadImageResource($MainGUIButtonClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
$MainGUIButtonCloseBool = False
ElseIf $MainGUIButtonMaximizeBool Then
UndoMenuHoverState()
If $MainGUIMaximizedState Then
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize2NoActivate.jpg","Maximize2NoActivate")
Else
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize1NoActivate.jpg","Maximize1NoActivate")
EndIf
$MainGUIButtonMaximizeBool = False
ElseIf $MainGUIButtonMinimizeBool Then
UndoMenuHoverState()
LoadImageResource($MainGUIButtonMinimize,$MainResourcePath & "MinimizeNoActivate.jpg","MinimizeNoActivate")
$MainGUIButtonMinimizeBool = False
ElseIf $MainGUIButtonDiscordBool Then
UndoMenuHoverState()
LoadImageResource($MainGUIButtonDiscord,$MainResourcePath & "DiscordIconInActive.jpg","DiscordIconInActive")
$MainGUIButtonDiscordBool = False
ElseIf $HomeIconHoverHideBool Then
UndoMenuHoverState()
LoadImageResource($HomeIconHover,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($HomeIcon,$MainResourcePath & "HomeIconInactive.jpg","HomeIconInactive")
$HomeIconHoverHideBool = False
ElseIf $FixesIconHoverHideBool Then
UndoMenuHoverState()
LoadImageResource($FixesIconHover,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($FixesIcon,$MainResourcePath & "FixesIconInactive.jpg","FixesIconInactive")
$FixesIconHoverHideBool = False
ElseIf $RCIconHoverHideBool Then
UndoMenuHoverState()
LoadImageResource($RCIconHover,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($RCIcon,$MainResourcePath & "RestoreConfigsIconInactive.jpg","RestoreConfigsIconInactive")
$RCIconHoverHideBool = False
ElseIf $DonateIconHoverHideBool Then
UndoMenuHoverState()
LoadImageResource($DonateIconHover,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($DonateIcon,$MainResourcePath & "DonateIconInactive.jpg","DonateIconInactive")
$DonateIconHoverHideBool = False
ElseIf $ChangelogIconHoverHideBool Then
UndoMenuHoverState()
LoadImageResource($ChangelogIconHover,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($ChangelogIcon,$MainResourcePath & "ChangelogIconInactive.jpg","ChangelogIconInactive")
$ChangelogIconHoverHideBool = False
ElseIf $CopyrightIconHoverHideBool Then
UndoMenuHoverState()
LoadImageResource($CopyrightIconHover,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($CopyrightIcon,$MainResourcePath & "CopyrightIconInactive.jpg","CopyrightIconInactive")
$CopyrightIconHoverHideBool = False
ElseIf $DebugIconHoverHideBool Then
UndoMenuHoverState()
LoadImageResource($DebugIconHover,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($DebugIcon,$MainResourcePath & "DebugIconInactive.jpg","DebugIconInactive")
$DebugIconHoverHideBool = False
ElseIf $ViewOnlineChangesBtnHoverBool Then
UndoMenuHoverState()
LoadImageResource($MainGUIChangelogButtonViewOnlineBG,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($MainGUIChangelogButtonViewOnline,$MainResourcePath & "ChangelogIconInActive.jpg","ChangelogIconInActive")
$ViewOnlineChangesBtnHoverBool = False
ElseIf $WebsiteOpenHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelWebsite,$cURLColor)
GUICtrlSetFont($MainGUICopyrightLabelWebsite,11,500,Default,$MenuFontName)
$WebsiteOpenHoverBool = False
ElseIf $LicenseLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelLicenseLink,$cURLColor)
GUICtrlSetFont($MainGUICopyrightLabelLicenseLink,15,500,Default,$MainFontName)
$LicenseLabelHoverBool = False
ElseIf $SourceLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelSourceLink,$cURLColor)
GUICtrlSetFont($MainGUICopyrightLabelSourceLink,15,500,Default,$MainFontName)
$SourceLabelHoverBool = False
ElseIf $AutoItLicenseLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelAutoitLicenseLink,$cURLColor)
GUICtrlSetFont($MainGUICopyrightLabelAutoitLicenseLink,15,500,Default,$MainFontName)
$AutoItLicenseLabelHoverBool = False
ElseIf $PrivacyPolicyLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelPrivacyPolicy,$cURLColor)
GUICtrlSetFont($MainGUICopyrightLabelPrivacyPolicy,11,500,Default,$MenuFontName)
$PrivacyPolicyLabelHoverBool = False
ElseIf $GDPRLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelGDPR,$cURLColor)
GUICtrlSetFont($MainGUICopyrightLabelGDPR,11,500,Default,$MenuFontName)
$GDPRLabelHoverBool = False
ElseIf $WebsiteMetricsLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelWebsiteMetrics,$cURLColor)
GUICtrlSetFont($MainGUICopyrightLabelWebsiteMetrics,11,500,Default,$MenuFontName)
$WebsiteMetricsLabelHoverBool = False
ElseIf $MainGUIDebugLabelHoverBool Then
GUICtrlSetColor($MainGUIDebugLabelReportABug,$cURLColor)
GUICtrlSetFont($MainGUIDebugLabelReportABug,15,500,Default,$MainFontName)
$MainGUIDebugLabelHoverBool = False
ElseIf $MainGUIDebugDumpInfoHoverBool Then
GUICtrlSetColor($MainGUIDebugLabelCreateDebugInfo,$cURLColor)
GUICtrlSetFont($MainGUIDebugLabelCreateDebugInfo,15,500,Default,$MainFontName)
$MainGUIDebugDumpInfoHoverBool = False
ElseIf $SteamBtnHoverHideBool Then
LoadImageResource($MainGUIHomePicBtnSteam,$MainResourcePath & "SteamBtnInActive.jpg","SteamBtnInActive")
$SteamBtnHoverHideBool = False
ElseIf $EGSBtnHoverHideBool Then
LoadImageResource($MainGUIHomePicBtnEGS,$MainResourcePath & "EGSBtnInActive.jpg","EGSBtnInActive")
$EGSBtnHoverHideBool = False
ElseIf $LegacyBtnHoverHideBool Then
LoadImageResource($MainGUIHomePicBtnLegacy,$MainResourcePath & "LegacyBtnInActive.jpg","LegacyBtnInActive")
$LegacyBtnHoverHideBool = False
EndIf
EndFunc
While True
Local $CursorInfo = GUIGetCursorInfo($MainGUI)
If WinGetTitle("[active]") = $ProgramName and @Error = 0 Then
If not $bTriedToShowDonateBanner Then
Local $regRead = RegRead("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
If not @Error Then
$bTriedToShowDonateBanner = True
If Random(1,4,1) = 3 Then
MenuHoverState("DBan",138,300,0)
EndIf
EndIf
EndIf
If $UpdateAvailable Then
If TimerDiff($UpdateTimer) > 750 Then
$UpdateTimer = TimerInit()
If $UpdateColorState Then
GUICtrlSetColor($MainGUILabelVersion,0xFF0000)
$UpdateColorState = False
Else
GUICtrlSetColor($MainGUILabelVersion,$cTextColor)
$UpdateColorState = True
EndIf
EndIf
Endif
If $bShouldFlashDiscordIcon Then
If TimerDiff($DiscordFlashTimer) > 750 Then
$DiscordFlashTimer = TimerInit()
If $bDiscordIconState Then
LoadImageResource($MainGUIButtonDiscord,$MainResourcePath & "DiscordIconActive.jpg","DiscordIconActive")
$bDiscordIconState = False
Else
LoadImageResource($MainGUIButtonDiscord,$MainResourcePath & "DiscordIconInActive.jpg","DiscordIconInActive")
$bDiscordIconState = True
EndIf
EndIf
Endif
If $ProgramHomeState = "Simple" Then
If _GUICtrlComboBox_GetDroppedState($MainGUIHomeSimpleComboScreenRes) = False Then
Local $ReadScrResSimple = GUICtrlRead($MainGUIHomeSimpleComboScreenRes)
If $ReadScrResSimple <> $LastReadScrResSimple Then
Local $bReturnFlag = False
If StringLeft($ReadScrResSimple,6) = "Custom" Then
$HomeSimpleComboResLastIndex = $LastReadScrResSimple
$bReturnFlag = Internal_ChooseCustomRes()
EndIf
If Not $bReturnFlag Then $LastReadScrResSimple = $ReadScrResSimple
EndIf
EndIf
Local $ReadScreenResSimple = GUICtrlRead($MainGUIHomeSimpleSliderScreenResScale)&"%"
If $ReadScreenResSimple <> $LastScreenResScaleSimple Then
GUICtrlSetData($MainGUIHomeSimpleInputScreenResScale,$ReadScreenResSimple)
$LastScreenResScaleSimple = $ReadScreenResSimple
EndIf
ElseIf $ProgramHomeState = "Advanced" Then
If _GUICtrlComboBox_GetDroppedState($MainGUIHomeAdvancedComboScreenRes) = False Then
Local $ReadScrResAdvanced = GUICtrlRead($MainGUIHomeAdvancedComboScreenRes)
If $ReadScrResAdvanced <> $LastReadScrResAdvanced Then
Local $bReturnFlag = False
If StringLeft($ReadScrResAdvanced,6) = "Custom" Then
$HomeAdvancedComboResLastIndex = $LastReadScrResAdvanced
$bReturnFlag = Internal_ChooseCustomRes()
EndIf
If Not $bReturnFlag Then $LastReadScrResAdvanced = $ReadScrResAdvanced
EndIf
EndIf
Local $ReadScreenResAdvanced = GUICtrlRead($MainGUIHomeAdvancedSliderScreenResScale)&"%"
If $ReadScreenResAdvanced <> $LastScreenResScaleAdvanced Then
GUICtrlSetData($MainGUIHomeAdvancedInputScreenResScale,$ReadScreenResAdvanced)
$LastScreenResScaleAdvanced = $ReadScreenResAdvanced
EndIf
EndIf
If($ProgramHomeHelpState = 1 and $MenuSelected = 1 and not $MainGUIHomeDiscoveryDrawn) or($ProgramHomeHelpState = 1 and $MenuSelected == 2) Then
If $JustTabbedBackIn = 0 Then $JustTabbedBackIn = 3
Local $MousePos = MouseGetPos()
$DisplayHoverBG = 0
If not $SupressHoverImage Then
If($MousePos[0] <> $LastMousePosX or $MousePos[1] <> $LastMousePosY) or $JustTabbedBackIn > 1 Then
If $JustTabbedBackIn > 1 Then $JustTabbedBackIn = $JustTabbedBackIn -1
$HoverTimer = TimerInit()
$LastMousePosX = $MousePos[0]
$LastMousePosY = $MousePos[1]
If($HoverImageDrawn and $HoverBGDrawn) and $HoverID <> $LastHoverID Then
$DisplayHoverImage = 1
$LastHoverID = $HoverID
ElseIf(not $HoverImageDrawn or not $HoverBGDrawn) Then
If $HoverTipAlpha <= 0 Then
$DisplayHoverImage = 0
Else
$DisplayHoverImage = -2
EndIf
EndIf
ElseIf TimerDiff($HoverTimer) > 400 and $DisplayHoverImage <> -1 Then
$DisplayHoverImage = 1
$LastHoverID = $HoverID
EndIf
If $MenuSelected == 2 Then
If InRange2D($MousePos,120,61,320,104) Then
DisplayHoverImage(95,61,200,42,$MainResourcePath & "HelpText/Desired_FPS.jpg",300,40,345,238)
ElseIf InRange2D($MousePos,120,101,320,144) Then
DisplayHoverImage(95,101,200,42,$MainResourcePath & "HelpText/Audio_Channels.jpg",300,40,345,317)
ElseIf InRange2D($MousePos,120,153,320,176) Then
DisplayHoverImage(95,153,200,23,$MainResourcePath & "HelpText/Disable_Jumping.jpg",300,40,345,184)
ElseIf InRange2D($MousePos,120,173,320,196) Then
DisplayHoverImage(95,173,200,23,$MainResourcePath & "HelpText/Disable_Fog.jpg",300,40,345,184)
EndIf
ElseIf $ProgramHomeState = "Simple" Then
If InRange2D($MousePos,95,71,295,114) Then
DisplayHoverImage(95,71,200,43,$MainResourcePath & "HelpText/World_Quality_Simple.jpg",300,40,600,350)
ElseIf InRange2D($MousePos,95,111,295,154) Then
DisplayHoverImage(95,111,200,43,$MainResourcePath & "HelpText/Character_Quality_Simple.jpg",300,40,600,350)
ElseIf InRange2D($MousePos,95,151,295,194) Then
DisplayHoverImage(95,151,200,43,$MainResourcePath & "HelpText/Shadow_Quality_Simple.jpg",300,40,600,350)
ElseIf InRange2D($MousePos,95,191,295,234) Then
DisplayHoverImage(95,191,200,43,$MainResourcePath & "HelpText/Sky_Quality.jpg",300,40,400,350)
ElseIf InRange2D($MousePos,95,231,295,274) Then
DisplayHoverImage(95,231,200,43,$MainResourcePath & "HelpText/Effects_Quality_Simple.jpg",300,40,600,350)
ElseIf InRange2D($MousePos,95,271,295,314) Then
DisplayHoverImage(95,271,200,43,$MainResourcePath & "HelpText/Desired_FPS.jpg",300,40,345,238)
ElseIf InRange2D($MousePos,295,71,495,114) Then
DisplayHoverImage(295,71,200,43,$MainResourcePath & "HelpText/Resolution.jpg",500,40,345,339)
ElseIf InRange2D($MousePos,295,111,545,154) Then
DisplayHoverImage(295,111,250,43,$MainResourcePath & "HelpText/Resolution_Scale.jpg",550,40,345,300)
ElseIf InRange2D($MousePos,295,151,495,194) Then
DisplayHoverImage(295,151,200,43,$MainResourcePath & "HelpText/Window_Type.jpg",500,40,345,300)
ElseIf InRange2D($MousePos,295,191,495,234) Then
DisplayHoverImage(295,191,200,43,$MainResourcePath & "HelpText/Anti_Aliasing.jpg",500,40,400,350)
ElseIf InRange2D($MousePos,295,231,495,274) Then
DisplayHoverImage(295,231,200,43,$MainResourcePath & "HelpText/Anisotropic_Filtering.jpg",500,40,400,350)
ElseIf InRange2D($MousePos,295,271,495,314) Then
DisplayHoverImage(295,271,200,43,$MainResourcePath & "HelpText/DetailMode.gif",500,40,400,350,True)
ElseIf InRange2D($MousePos,590,83,790,103) Then
DisplayHoverImage(590,83,200,23,$MainResourcePath & "HelpText/Vertical_Synchronisation.jpg",240,40,345,300)
ElseIf InRange2D($MousePos,590,103,790,126) Then
DisplayHoverImage(590,103,200,23,$MainResourcePath & "HelpText/Ragdoll_Physics.gif",185,40,400,286,True)
ElseIf InRange2D($MousePos,590,123,790,146) Then
DisplayHoverImage(590,123,200,23,$MainResourcePath & "HelpText/DirectX_11.jpg",240,40,345,159)
ElseIf InRange2D($MousePos,590,151,790,174) Then
DisplayHoverImage(590,151,200,23,$MainResourcePath & "HelpText/Bloom.jpg",185,40,400,350)
ElseIf InRange2D($MousePos,590,171,790,194) Then
DisplayHoverImage(590,171,200,23,$MainResourcePath & "HelpText/Decals_Simple.jpg",240,40,345,300)
ElseIf InRange2D($MousePos,590,191,790,214) Then
DisplayHoverImage(590,191,200,23,$MainResourcePath & "HelpText/Dynamic_Lights_and_Shadows.jpg",240,40,345,300)
ElseIf InRange2D($MousePos,590,211,790,234) Then
DisplayHoverImage(590,211,200,23,$MainResourcePath & "HelpText/Lensflares.jpg",240,40,345,300)
ElseIf InRange2D($MousePos,590,231,790,254) Then
DisplayHoverImage(590,231,200,23,$MainResourcePath & "HelpText/Reflections.jpg",240,40,345,300)
ElseIf InRange2D($MousePos,590,251,790,274) Then
DisplayHoverImage(590,251,200,23,$MainResourcePath & "HelpText/Uncompressed_Textures.jpg",240,40,345,280)
EndIf
ElseIf $ProgramHomeState = "Advanced" Then
If InRange2D($MousePos,95,36,295,79) Then
DisplayHoverImage(95,36,200,43,$MainResourcePath & "HelpText/World_Quality.jpg",300,40,400,350)
ElseIf InRange2D($MousePos,95,76,295,119) Then
DisplayHoverImage(95,76,200,43,$MainResourcePath & "HelpText/Character_Quality.jpg",300,40,400,350)
ElseIf InRange2D($MousePos,95,116,295,159) Then
DisplayHoverImage(95,116,200,43,$MainResourcePath & "HelpText/Terrain_Quality.jpg",300,40,400,350)
ElseIf InRange2D($MousePos,95,156,295,199) Then
DisplayHoverImage(95,156,200,43,$MainResourcePath & "HelpText/NPC_Quality.jpg",300,40,400,217)
ElseIf InRange2D($MousePos,95,196,295,239) Then
DisplayHoverImage(95,196,200,43,$MainResourcePath & "HelpText/Weapon_Quality.jpg",300,40,400,217)
ElseIf InRange2D($MousePos,95,236,295,279) Then
DisplayHoverImage(95,236,200,43,$MainResourcePath & "HelpText/Vehicle_Quality.jpg",300,40,400,217)
ElseIf InRange2D($MousePos,95,276,295,319) Then
DisplayHoverImage(95,276,200,43,$MainResourcePath & "HelpText/Shadow_Quality.jpg",300,40,400,350)
ElseIf InRange2D($MousePos,95,316,295,359) Then
DisplayHoverImage(95,316,200,43,$MainResourcePath & "HelpText/Particle_Quality.jpg",300,40,400,350)
ElseIf InRange2D($MousePos,295,36,495,79) Then
DisplayHoverImage(295,36,200,43,$MainResourcePath & "HelpText/Sky_Quality.jpg",500,40,400,350)
ElseIf InRange2D($MousePos,295,76,495,119) Then
DisplayHoverImage(295,76,200,43,$MainResourcePath & "HelpText/Effects_Quality.jpg",500,40,400,350)
ElseIf InRange2D($MousePos,295,116,495,159) Then
DisplayHoverImage(295,116,200,43,$MainResourcePath & "HelpText/Resolution.jpg",500,40,345,339)
ElseIf InRange2D($MousePos,295,156,545,199) Then
DisplayHoverImage(295,156,250,43,$MainResourcePath & "HelpText/Resolution_Scale.jpg",550,40,345,300)
ElseIf InRange2D($MousePos,295,196,495,239) Then
DisplayHoverImage(295,196,200,43,$MainResourcePath & "HelpText/Window_Type.jpg",500,40,345,300)
ElseIf InRange2D($MousePos,295,236,495,279) Then
DisplayHoverImage(295,236,200,43,$MainResourcePath & "HelpText/Anti_Aliasing.jpg",500,40,400,350)
ElseIf InRange2D($MousePos,295,276,495,319) Then
DisplayHoverImage(295,276,200,43,$MainResourcePath & "HelpText/Anisotropic_Filtering.jpg",500,40,400,350)
ElseIf InRange2D($MousePos,295,316,495,359) Then
DisplayHoverImage(295,316,200,43,$MainResourcePath & "HelpText/Desired_FPS.jpg",500,40,345,238)
ElseIf InRange2D($MousePos,495,48,660,71) Then
DisplayHoverImage(495,48,165,23,$MainResourcePath & "HelpText/SpeedTree_Wind.jpg",145,40,345,300)
ElseIf InRange2D($MousePos,495,68,660,91) Then
DisplayHoverImage(495,68,165,23,$MainResourcePath & "HelpText/SpeedTree_Leaves.jpg",145,40,345,300)
ElseIf InRange2D($MousePos,495,88,660,111) Then
DisplayHoverImage(495,88,165,23,$MainResourcePath & "HelpText/SpeedTree_Fronds.jpg",145,40,345,300)
ElseIf InRange2D($MousePos,495,111,615,159) Then
DisplayHoverImage(495,111,120,48,$MainResourcePath & "HelpText/SpeedTree_LOD_Bias.jpg",145,40,345,300)
ElseIf InRange2D($MousePos,555,159,650,207) Then
DisplayHoverImage(555,159,95,48,$MainResourcePath & "HelpText/DetailMode.gif",150,40,400,350,True)
ElseIf InRange2D($MousePos,495,208,660,231) Then
DisplayHoverImage(495,208,165,23,$MainResourcePath & "HelpText/Vertical_Synchronisation.jpg",145,40,345,300)
ElseIf InRange2D($MousePos,495,228,660,251) Then
DisplayHoverImage(495,228,165,23,$MainResourcePath & "HelpText/Ragdoll_Physics.gif",95,40,400,286,True)
ElseIf InRange2D($MousePos,495,248,660,271) Then
DisplayHoverImage(495,248,165,23,$MainResourcePath & "HelpText/DirectX_11.jpg",145,40,345,159)
ElseIf InRange2D($MousePos,495,268,660,291) Then
DisplayHoverImage(495,268,165,23,$MainResourcePath & "HelpText/Bloom.jpg",95,40,400,350)
ElseIf InRange2D($MousePos,495,288,660,311) Then
DisplayHoverImage(495,288,165,23,$MainResourcePath & "HelpText/Lensflares.jpg",145,40,345,300)
ElseIf InRange2D($MousePos,495,308,660,331) Then
DisplayHoverImage(495,308,165,23,$MainResourcePath & "HelpText/Reflections.jpg",145,40,345,300)
ElseIf InRange2D($MousePos,495,328,660,351) Then
DisplayHoverImage(495,328,165,23,$MainResourcePath & "HelpText/Uncompressed_Textures.jpg",145,40,345,280)
ElseIf InRange2D($MousePos,660,48,845,71) Then
DisplayHoverImage(660,48,192,23,$MainResourcePath & "HelpText/Light_Shafts.jpg",310,40,345,300)
ElseIf InRange2D($MousePos,660,68,845,91) Then
DisplayHoverImage(660,68,192,23,$MainResourcePath & "HelpText/Fog_Volumes.jpg",310,40,345,300)
ElseIf InRange2D($MousePos,660,88,845,111) Then
DisplayHoverImage(660,88,192,23,$MainResourcePath & "HelpText/Distortion.jpg",310,40,345,162)
ElseIf InRange2D($MousePos,660,108,845,131) Then
DisplayHoverImage(660,108,192,23,$MainResourcePath & "HelpText/Filtered_Distortion.jpg",310,40,345,179)
ElseIf InRange2D($MousePos,660,128,845,151) Then
DisplayHoverImage(660,128,192,23,$MainResourcePath & "HelpText/Drop_Shadows.jpg",310,40,345,242)
ElseIf InRange2D($MousePos,660,148,845,171) Then
DisplayHoverImage(660,148,192,23,$MainResourcePath & "HelpText/Dominant_Shadows.jpg",310,40,345,242)
ElseIf InRange2D($MousePos,660,168,845,191) Then
DisplayHoverImage(660,168,192,23,$MainResourcePath & "HelpText/Conservative_Shadow_Bounds.jpg",310,40,345,127)
ElseIf InRange2D($MousePos,660,188,845,211) Then
DisplayHoverImage(660,188,192,23,$MainResourcePath & "HelpText/Light_Environment_Shadows.jpg",310,40,345,223)
ElseIf InRange2D($MousePos,660,208,845,231) Then
DisplayHoverImage(660,208,192,23,$MainResourcePath & "HelpText/Static_Decals.jpg",310,40,345,300)
ElseIf InRange2D($MousePos,660,228,845,251) Then
DisplayHoverImage(660,228,192,23,$MainResourcePath & "HelpText/Dynamic_Decals.jpg",310,40,345,300)
ElseIf InRange2D($MousePos,660,248,845,271) Then
DisplayHoverImage(660,248,192,23,$MainResourcePath & "HelpText/Unbatched_Decals.jpg",310,40,345,300)
ElseIf InRange2D($MousePos,660,268,845,291) Then
DisplayHoverImage(660,268,192,23,$MainResourcePath & "HelpText/Dynamic_Lights.jpg",310,40,345,300)
ElseIf InRange2D($MousePos,660,288,845,311) Then
DisplayHoverImage(660,288,192,23,$MainResourcePath & "HelpText/Composite_Dynamic_Lights.jpg",310,40,345,300)
ElseIf InRange2D($MousePos,660,308,845,331) Then
DisplayHoverImage(660,308,192,23,$MainResourcePath & "HelpText/SH_Secondary_Lighting.jpg",310,40,345,223)
ElseIf InRange2D($MousePos,660,328,845,351) Then
DisplayHoverImage(660,328,192,23,$MainResourcePath & "HelpText/Dynamic_Shadows.jpg",255,40,400,350)
EndIf
EndIf
EndIf
If $DisplayHoverBG = 0 and $HoverBGDrawn Then
GUICtrlSetPos($MainGUIHomeHelpBackground,-$MinWidth,-$MinHeight,1,1)
$HoverBGDrawn = False
ElseIf $DisplayHoverImage = 0 and $HoverImageDrawn Then
WinMove($HoverInfoGUI,$sEmpty,-$ScrW*2,-$ScrH*2,0,0)
$HoverImageDrawn = False
EndIf
If $DisplayHoverImage = -1 and $HoverTipAlpha < 255 Then
$HoverTipAlpha = $HoverTipAlpha + 8.5
ElseIf $DisplayHoverImage = -2 and $HoverTipAlpha > 0 Then
$HoverTipAlpha = $HoverTipAlpha - 8.5
EndIf
If $HoverTipAlpha >= 0 and $HoverTipAlpha <= 255 Then
WinSetTrans($HoverInfoGUI,$sEmpty,$HoverTipAlpha)
EndIf
EndIf
Switch $CursorInfo[4]
Case $MainGUIButtonClose
If $MainGUIButtonCloseBool = False Then
_FixMenuSwitch()
LoadImageResource($MainGUIButtonClose,$MainResourcePath & "CloseActivate.jpg","CloseActivate")
$MainGUIButtonCloseBool = True
EndIf
Case $MainGUIButtonMaximize
If $MainGUIButtonMaximizeBool = False Then
_FixMenuSwitch()
If $MainGUIMaximizedState Then
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize2Activate.jpg","Maximize2Activate")
Else
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize1Activate.jpg","Maximize1Activate")
EndIf
$MainGUIButtonMaximizeBool = True
EndIf
Case $MainGUIButtonMinimize
If $MainGUIButtonMinimizeBool = False Then
_FixMenuSwitch()
LoadImageResource($MainGUIButtonMinimize,$MainResourcePath & "MinimizeActivate.jpg","MinimizeActivate")
$MainGUIButtonMinimizeBool = True
EndIf
Case $MainGUIButtonDiscord
If $MainGUIButtonDiscordBool = False Then
_FixMenuSwitch()
LoadImageResource($MainGUIButtonDiscord,$MainResourcePath & "DiscordIconActive.jpg","DiscordIconActive")
$MainGUIButtonDiscordBool = True
EndIf
Case $HomeIconHover, $HomeIcon
If $HomeIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Home",36,116,35)
LoadImageResource($HomeIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($HomeIcon,$MainResourcePath & "HomeIconActive.jpg","HomeIconActive")
$HomeIconHoverHideBool = True
EndIf
Case $FixesIconHover, $FixesIcon
If $FixesIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Fixes",76,98,75)
LoadImageResource($FixesIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($FixesIcon,$MainResourcePath & "FixesIconActive.jpg","FixesIconActive")
$FixesIconHoverHideBool = True
EndIf
Case $RCIconHover, $RCIcon
If $RCIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Restore Configuration",116,383,115)
LoadImageResource($RCIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($RCIcon,$MainResourcePath & "RestoreConfigsIconActive.jpg","RestoreConfigsIconActive")
$RCIconHoverHideBool = True
EndIf
Case $DonateIconHover, $DonateIcon
If $DonateIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Donate",158,137,157)
LoadImageResource($DonateIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($DonateIcon,$MainResourcePath & "DonateIconActive.jpg","DonateIconActive")
$DonateIconHoverHideBool = True
EndIf
Case $ChangelogIconHover, $ChangelogIcon
If $ChangelogIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Changelog",198,193,197)
LoadImageResource($ChangelogIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($ChangelogIcon,$MainResourcePath & "ChangelogIconActive.jpg","ChangelogIconActive")
$ChangelogIconHoverHideBool = True
EndIf
Case $CopyrightIconHover, $CopyrightIcon
If $CopyrightIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Copyright",238,181,237)
LoadImageResource($CopyrightIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($CopyrightIcon,$MainResourcePath & "CopyrightIconActive.jpg","CopyrightIconActive")
$CopyrightIconHoverHideBool = True
EndIf
Case $DebugIconHover, $DebugIcon
If $DebugIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Debug",280,124,279)
LoadImageResource($DebugIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($DebugIcon,$MainResourcePath & "DebugIconActive.jpg","DebugIconActive")
$DebugIconHoverHideBool = True
EndIf
Case $MainGUIChangelogButtonViewOnline, $MainGUIChangelogButtonViewOnlineBG
If $ViewOnlineChangesBtnHoverBool = False Then
_FixMenuSwitch()
MenuHoverState("View on GitHub",365,274,365)
LoadImageResource($MainGUIChangelogButtonViewOnlineBG,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($MainGUIChangelogButtonViewOnline,$MainResourcePath & "ChangelogIconActive.jpg","ChangelogIconActive")
$ViewOnlineChangesBtnHoverBool = True
EndIf
Case $MainGUICopyrightLabelWebsite
If $WebsiteOpenHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelWebsite,$cURLHoverColor)
GUICtrlSetFont($MainGUICopyrightLabelWebsite,11,500,4,$MenuFontName)
$WebsiteOpenHoverBool = True
EndIf
Case $MainGUICopyrightLabelLicenseLink
If $LicenseLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelLicenseLink,$cURLHoverColor)
GUICtrlSetFont($MainGUICopyrightLabelLicenseLink,15,500,4,$MainFontName)
$LicenseLabelHoverBool = True
EndIf
Case $MainGUICopyrightLabelSourceLink
If $SourceLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelSourceLink,$cURLHoverColor)
GUICtrlSetFont($MainGUICopyrightLabelSourceLink,15,500,4,$MainFontName)
$SourceLabelHoverBool = True
EndIf
Case $MainGUICopyrightLabelAutoitLicenseLink
If $AutoItLicenseLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelAutoitLicenseLink,$cURLHoverColor)
GUICtrlSetFont($MainGUICopyrightLabelAutoitLicenseLink,15,500,4,$MainFontName)
$AutoItLicenseLabelHoverBool = True
EndIf
Case $MainGUICopyrightLabelPrivacyPolicy
If $PrivacyPolicyLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelPrivacyPolicy,$cURLHoverColor)
GUICtrlSetFont($MainGUICopyrightLabelPrivacyPolicy,11,500,4,$MenuFontName)
$PrivacyPolicyLabelHoverBool = True
EndIf
Case $MainGUICopyrightLabelGDPR
If $GDPRLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelGDPR,$cURLHoverColor)
GUICtrlSetFont($MainGUICopyrightLabelGDPR,11,500,4,$MenuFontName)
$GDPRLabelHoverBool = True
EndIf
Case $MainGUICopyrightLabelWebsiteMetrics
If $WebsiteMetricsLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelWebsiteMetrics,$cURLHoverColor)
GUICtrlSetFont($MainGUICopyrightLabelWebsiteMetrics,11,500,4,$MenuFontName)
$WebsiteMetricsLabelHoverBool = True
EndIf
Case $MainGUIDebugLabelReportABug
If $MainGUIDebugLabelHoverBool = False Then
GUICtrlSetColor($MainGUIDebugLabelReportABug,$cURLHoverColor)
GUICtrlSetFont($MainGUIDebugLabelReportABug,15,500,4,$MainFontName)
$MainGUIDebugLabelHoverBool = True
EndIf
Case $MainGUIDebugLabelCreateDebugInfo
If $MainGUIDebugDumpInfoHoverBool = False Then
GUICtrlSetColor($MainGUIDebugLabelCreateDebugInfo,$cURLHoverColor)
GUICtrlSetFont($MainGUIDebugLabelCreateDebugInfo,15,500,4,$MainFontName)
$MainGUIDebugDumpInfoHoverBool = True
EndIf
Case $MainGUIHomePicBtnSteam
If $SteamBtnHoverHideBool = False and $NotificationGUI == NULL Then
_FixMenuSwitch()
LoadImageResource($MainGUIHomePicBtnSteam,$MainResourcePath & "SteamBtnActive.jpg","SteamBtnActive")
$SteamBtnHoverHideBool = True
EndIf
Case $MainGUIHomePicBtnEGS
If $EGSBtnHoverHideBool = False and $NotificationGUI == NULL Then
_FixMenuSwitch()
LoadImageResource($MainGUIHomePicBtnEGS,$MainResourcePath & "EGSBtnActive.jpg","EGSBtnActive")
$EGSBtnHoverHideBool = True
EndIf
Case $MainGUIHomePicBtnLegacy
If $LegacyBtnHoverHideBool = False and $NotificationGUI == NULL Then
_FixMenuSwitch()
LoadImageResource($MainGUIHomePicBtnLegacy,$MainResourcePath & "LegacyBtnActive.jpg","LegacyBtnActive")
$LegacyBtnHoverHideBool = True
EndIf
Case Else
_FixMenuSwitch()
EndSwitch
Sleep(10)
Else
If $MenuPopupState Then _FixMenuSwitch()
$JustTabbedBackIn = 0
Sleep(100)
EndIf
WEnd
#Au3Stripper_Off
#Region
Func fInitHives()
Global Const $EngineSettingsClearHive[9][95] = [ ['[Engine.Engine]','bSmoothFrameRate','MaxSmoothedFrameRate','MinSmoothedFrameRate'], ['[Engine.GameEngine]','bSmoothFrameRate','MaxSmoothedFrameRate','MinSmoothedFrameRate'], ['[Engine.Client]','MinDesiredFrameRate'], ['[XAudio2.XAudio2Device]','MaxChannels'], ['[ALAudio.ALAudioDevice]','MaxChannels'], ['[CoreAudio.CoreAudioDevice]','MaxChannels'], ['[TextureStreaming]','LoadMapTimeLimit','UseDynamicStreaming'], ['[UnrealEd.EditorEngine]','bSmoothFrameRate','MaxSmoothedFrameRate','MinSmoothedFrameRate'] ]
Global Const $SystemSettingsClearHive[21][95] = [ ['[SystemSettings]','AllowD3D11','AllowImageReflections','AllowImageReflections','AllowImageReflectionShadowing','bAllowDropShadows','bAllowHighQualityMaterials','bAllowLightShafts','bAllowRagdolling','bAllowWholeSceneDominantShadows','Bloom','Borderless','bUseConservativeShadowBounds','bUseLowQualMaterials','CompositeDynamicLights','DepthOfField','DetailMode','DirectionalLightmaps','Distortion','DropParticleDistortion','DynamicDecals','DynamicLights','DynamicShadows','FilteredDistortion','FogVolumes','Fullscreen','Fullscreen','FullscreenWindowed','FXAAQuality','LensFlares','LightEnvironmentShadows','MaxActiveDecals','MaxAnisotropy','MaxFilterBlurSampleCount','MotionBlur','MotionBlur','MotionBlur','MotionBlurPause','MotionBlurSkinning','ParticleLODBias','PerfScalingBias','PreferD3D11','ResX','ResY','ScreenPercentage','SHSecondaryLighting','SpeedTreeFronds','SpeedTreeLeaves','SpeedTreeLODBias','SpeedTreeWind','StaticDecals','TargetFrameRate','TEXTUREGROUP_Bokeh','TEXTUREGROUP_Character','TEXTUREGROUP_Character','TEXTUREGROUP_Character','TEXTUREGROUP_CharacterNormalMap','TEXTUREGROUP_CharacterSpecular','TEXTUREGROUP_Effects','TEXTUREGROUP_Effects','TEXTUREGROUP_EffectsNotFiltered','TEXTUREGROUP_ImageBasedReflection','TEXTUREGROUP_Lightmap','TEXTUREGROUP_NPC','TEXTUREGROUP_NPC','TEXTUREGROUP_NPC','TEXTUREGROUP_NPCNormalMap','TEXTUREGROUP_NPCSpecular','TEXTUREGROUP_Shadowmap','TEXTUREGROUP_Skybox','TEXTUREGROUP_Terrain_Heightmap','TEXTUREGROUP_Terrain_Weightmap','TEXTUREGROUP_Vehicle','TEXTUREGROUP_Vehicle','TEXTUREGROUP_Vehicle','TEXTUREGROUP_VehicleNormalMap','TEXTUREGROUP_VehicleSpecular','TEXTUREGROUP_Weapon','TEXTUREGROUP_Weapon','TEXTUREGROUP_Weapon','TEXTUREGROUP_WeaponNormalMap','TEXTUREGROUP_WeaponSpecular','TEXTUREGROUP_World','TEXTUREGROUP_World','TEXTUREGROUP_World','TEXTUREGROUP_World','TEXTUREGROUP_WorldDetail','TEXTUREGROUP_WorldNormalMap','TEXTUREGROUP_WorldSpecular','UnbatchedDecals','UpscaleScreenPercentage','UseD3D11Beta','UseDX11','UseVsync','VsyncPresentInterval'], ['[SystemSettingsBucket1]','AllowImageReflections','bAllowDropShadows','bAllowHighQualityMaterials','bAllowLightShafts','bAllowRagdolling','bAllowWholeSceneDominantShadows','Bloom','bUseConservativeShadowBounds','bUseLowQualMaterials','CompositeDynamicLights','DepthOfField','DetailMode','DirectionalLightmaps','Distortion','DropParticleDistortion','DynamicDecals','DynamicLights','DynamicShadows','FXAAQuality','LensFlares','LightEnvironmentShadows','MaxAnisotropy','MotionBlur','ParticleLODBias','PerfScalingBias','ScreenPercentage','SHSecondaryLighting','SpeedTreeLODBias','SpeedTreeWind','StaticDecals','UnbatchedDecals'], ['[SystemSettingsBucket2]','AllowImageReflections','bAllowDropShadows','bAllowHighQualityMaterials','bAllowLightShafts','bAllowRagdolling','bAllowWholeSceneDominantShadows','Bloom','bUseConservativeShadowBounds','bUseLowQualMaterials','CompositeDynamicLights','DepthOfField','DetailMode','DirectionalLightmaps','Distortion','DropParticleDistortion','DynamicDecals','DynamicLights','DynamicShadows','FXAAQuality','LensFlares','LightEnvironmentShadows','MaxAnisotropy','MotionBlur','ParticleLODBias','PerfScalingBias','ScreenPercentage','SHSecondaryLighting','SpeedTreeLODBias','SpeedTreeWind','StaticDecals','UnbatchedDecals'], ['[SystemSettingsBucket3]','AllowImageReflections','bAllowDropShadows','bAllowHighQualityMaterials','bAllowLightShafts','bAllowRagdolling','bAllowWholeSceneDominantShadows','Bloom','bUseConservativeShadowBounds','bUseLowQualMaterials','CompositeDynamicLights','DepthOfField','DetailMode','DirectionalLightmaps','Distortion','DropParticleDistortion','DynamicDecals','DynamicLights','DynamicShadows','FXAAQuality','LensFlares','LightEnvironmentShadows','MaxAnisotropy','MotionBlur','ParticleLODBias','PerfScalingBias','ScreenPercentage','SHSecondaryLighting','SpeedTreeLODBias','SpeedTreeWind','StaticDecals','UnbatchedDecals'], _
['[SystemSettingsBucket4]','AllowImageReflections','bAllowDropShadows','bAllowHighQualityMaterials','bAllowLightShafts','bAllowRagdolling','bAllowWholeSceneDominantShadows','Bloom','bUseConservativeShadowBounds','bUseLowQualMaterials','CompositeDynamicLights','DepthOfField','DetailMode','DirectionalLightmaps','Distortion','DropParticleDistortion','DynamicDecals','DynamicLights','DynamicShadows','FXAAQuality','LensFlares','LightEnvironmentShadows','MaxAnisotropy','MotionBlur','ParticleLODBias','PerfScalingBias','ScreenPercentage','SHSecondaryLighting','SpeedTreeLODBias','SpeedTreeWind','StaticDecals','UnbatchedDecals'], ['[SystemSettingsBucket5]','AllowImageReflections','bAllowDropShadows','bAllowHighQualityMaterials','bAllowLightShafts','bAllowRagdolling','bAllowWholeSceneDominantShadows','Bloom','bUseConservativeShadowBounds','bUseLowQualMaterials','CompositeDynamicLights','DepthOfField','DetailMode','DirectionalLightmaps','Distortion','DropParticleDistortion','DynamicDecals','DynamicLights','DynamicShadows','FXAAQuality','LensFlares','LightEnvironmentShadows','MaxAnisotropy','MotionBlur','ParticleLODBias','PerfScalingBias','ScreenPercentage','SHSecondaryLighting','SpeedTreeLODBias','SpeedTreeWind','StaticDecals','UnbatchedDecals'], ['[SystemSettingsScreenshot]','CompositeDynamicLights','MaxAnisotropy'], ['[SystemSettingsSplitScreen2]','bAllowLightShafts','bAllowWholeSceneDominantShadows','DetailMode'], ['[SystemSettingsMobile]','bAllowLightShafts','Bloom','DepthOfField','DirectionalLightmaps','Distortion','DropParticleDistortion','DynamicDecals','DynamicLights','DynamicShadows','FilteredDistortion','Fullscreen','MaxAnisotropy','MaxFilterBlurSampleCount','MotionBlur','MotionBlur','MotionBlurPause','SHSecondaryLighting','StaticDecals','UnbatchedDecals'], ['[SystemSettingsMobilePreviewer]','Fullscreen'], ['[SystemSettingsFlash]','bAllowLightShafts','Bloom','DepthOfField','DirectionalLightmaps','Distortion','DynamicShadows','FilteredDistortion','MotionBlur','MotionBlur','MotionBlurPause'], ['[SystemSettingsIPhone3GS]','DetailMode','LensFlares'], ['[SystemSettingsIPhone4]','LensFlares'], ['[SystemSettingsIPhone4S]','bAllowLightShafts','DynamicShadows'], ['[SystemSettingsIPhone5]','bAllowLightShafts','DynamicShadows'], ['[SystemSettingsIPodTouch4]','LensFlares'], ['[SystemSettingsIPodTouch5]','bAllowLightShafts','DynamicShadows'], ['[SystemSettingsIPad2]','bAllowLightShafts','DynamicShadows'], ['[SystemSettingsIPad3]','bAllowLightShafts','DynamicShadows'], ['[SystemSettingsIPad4]','bAllowLightShafts','DynamicShadows'], ['[SystemSettingsIPadMini]','bAllowLightShafts','DynamicShadows'] ]
Global Const $GameSettingsClearHive[1][95] = [ ['[TgGame.TgClientSettings]','bJumpEnabled'] ]
Global Const $TextureQualityHive[9][8][4] = [	_
[ [ "TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1,LODBias=2048,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=512,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=2,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=64,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=64,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=32,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_WorldNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"] ],[ [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""] ],[ [ "TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_NPC=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Lightmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", "TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)"], [ _
"TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", "TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", "TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", "TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_Lightmap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", "TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_Lightmap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", "TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_Lightmap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_Shadowmap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", "TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_Lightmap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", "TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)"] ],[ [ "TEXTUREGROUP_Skybox=(MinLODSize=2048,MaxLODSize=2048,MaxLODSizeTexturePack=8192,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1024,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1024,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=512,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""] ],[ [ "TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ _
"TEXTUREGROUP_Effects=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""] ] ]
EndFunc
#EndRegion
