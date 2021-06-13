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
Global Const $DIR_REMOVE= 1
Global Const $MB_OK = 0
Global Const $MB_YESNO = 4
Global Const $IDYES = 6
Global Const $STR_NOCASESENSEBASIC = 2
Global Const $STR_STRIPALL = 8
Global Const $STR_CHRSPLIT = 0
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Const $STR_REGEXPARRAYGLOBALMATCH = 3
Global Const $_ARRAYCONSTANT_SORTINFOSIZE = 11
Global $__g_aArrayDisplay_SortInfo[$_ARRAYCONSTANT_SORTINFOSIZE]
Global Const $_ARRAYCONSTANT_tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($nItem1, $nItem2, $hWnd)
If $__g_aArrayDisplay_SortInfo[3] = $__g_aArrayDisplay_SortInfo[4] Then
If Not $__g_aArrayDisplay_SortInfo[7] Then
$__g_aArrayDisplay_SortInfo[5] *= -1
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
Else
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
$__g_aArrayDisplay_SortInfo[6] = $__g_aArrayDisplay_SortInfo[3]
Local $sVal1 = __ArrayDisplay_GetItemText($hWnd, $nItem1, $__g_aArrayDisplay_SortInfo[3])
Local $sVal2 = __ArrayDisplay_GetItemText($hWnd, $nItem2, $__g_aArrayDisplay_SortInfo[3])
If $__g_aArrayDisplay_SortInfo[8] = 1 Then
If(StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
If(StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
EndIf
Local $nResult
If $__g_aArrayDisplay_SortInfo[8] < 2 Then
$nResult = 0
If $sVal1 < $sVal2 Then
$nResult = -1
ElseIf $sVal1 > $sVal2 Then
$nResult = 1
EndIf
Else
$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
EndIf
$nResult = $nResult * $__g_aArrayDisplay_SortInfo[5]
Return $nResult
EndFunc
Func __ArrayDisplay_GetItemText($hWnd, $iIndex, $iSubItem = 0)
Local $tBuffer = DllStructCreate("wchar Text[4096]")
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
DllStructSetData($tItem, "SubItem", $iSubItem)
DllStructSetData($tItem, "TextMax", 4096)
DllStructSetData($tItem, "Text", $pBuffer)
If IsHWnd($hWnd) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1073, "wparam", $iIndex, "struct*", $tItem)
Else
Local $pItem = DllStructGetPtr($tItem)
GUICtrlSendMsg($hWnd, 0x1073, $iIndex, $pItem)
EndIf
Return DllStructGetData($tBuffer, "Text")
EndFunc
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
Global Const $CB_SELECTSTRING = 0x14D
Global Const $CBN_CLOSEUP = 8
Global Const $CBN_DROPDOWN = 7
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
If @error Then Return SetError(@error, @extended, "")
If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
Return $aResult
EndFunc
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
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
Global Const $__WINVER = __WINVER()
Func _WinAPI_FreeLibrary($hModule)
Local $aResult = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hModule)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_GetDlgCtrlID($hWnd)
Local $aResult = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetModuleHandle($sModuleName)
Local $sModuleNameType = "wstr"
If $sModuleName = "" Then
$sModuleName = 0
$sModuleNameType = "ptr"
EndIf
Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_LoadImage($hInstance, $sImage, $iType, $iXDesired, $iYDesired, $iLoad)
Local $aResult, $sImageType = "int"
If IsString($sImage) Then $sImageType = "wstr"
$aResult = DllCall("user32.dll", "handle", "LoadImageW", "handle", $hInstance, $sImageType, $sImage, "uint", $iType, "int", $iXDesired, "int", $iYDesired, "uint", $iLoad)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
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
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc
Func _WinAPI_GUIDFromString($sGUID)
Local $tGUID = DllStructCreate($tagGUID)
_WinAPI_GUIDFromStringEx($sGUID, $tGUID)
If @error Then Return SetError(@error + 10, @extended, 0)
Return $tGUID
EndFunc
Func _WinAPI_GUIDFromStringEx($sGUID, $tGUID)
Local $aResult = DllCall("ole32.dll", "long", "CLSIDFromString", "wstr", $sGUID, "struct*", $tGUID)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_StringFromGUID($tGUID)
Local $aResult = DllCall("ole32.dll", "int", "StringFromGUID2", "struct*", $tGUID, "wstr", "", "int", 40)
If @error Or Not $aResult[0] Then Return SetError(@error, @extended, "")
Return SetExtended($aResult[0], $aResult[2])
EndFunc
Func _WinAPI_WideCharToMultiByte($vUnicode, $iCodePage = 0, $bRetNoStruct = True, $bRetBinary = False)
Local $sUnicodeType = "wstr"
If Not IsString($vUnicode) Then $sUnicodeType = "struct*"
Local $aResult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $iCodePage, "dword", 0, $sUnicodeType, $vUnicode, "int", -1, "ptr", 0, "int", 0, "ptr", 0, "ptr", 0)
If @error Or Not $aResult[0] Then Return SetError(@error + 20, @extended, "")
Local $tMultiByte = DllStructCreate((($bRetBinary) ?("byte") :("char")) & "[" & $aResult[0] & "]")
$aResult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $iCodePage, "dword", 0, $sUnicodeType, $vUnicode, "int", -1, "struct*", $tMultiByte, "int", $aResult[0], "ptr", 0, "ptr", 0)
If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")
If $bRetNoStruct Then Return DllStructGetData($tMultiByte, 1)
Return $tMultiByte
EndFunc
Func _WinAPI_DeleteObject($hObject)
Local $aResult = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Global Const $GWL_STYLE = 0xFFFFFFF0
Func _WinAPI_GetClassName($hWnd)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Local $aResult = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hWnd, "wstr", "", "int", 4096)
If @error Or Not $aResult[0] Then Return SetError(@error, @extended, '')
Return SetExtended($aResult[0], $aResult[2])
EndFunc
Func _WinAPI_GetWindowLong($hWnd, $iIndex)
Local $sFuncName = "GetWindowLongW"
If @AutoItX64 Then $sFuncName = "GetWindowLongPtrW"
Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex)
If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_InvalidateRect($hWnd, $tRECT = 0, $bErase = True)
Local $aResult = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $hWnd, "struct*", $tRECT, "bool", $bErase)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_SetWindowPos($hWnd, $hAfter, $iX, $iY, $iCX, $iCY, $iFlags)
Local $aResult = DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hWnd, "hwnd", $hAfter, "int", $iX, "int", $iY, "int", $iCX, "int", $iCY, "uint", $iFlags)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_UpdateWindow($hWnd)
Local $aResult = DllCall("user32.dll", "bool", "UpdateWindow", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
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
Func _WinAPI_SetLastError($iErrorCode, Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
DllCall("kernel32.dll", "none", "SetLastError", "dword", $iErrorCode)
Return SetError($_iCurrentError, $_iCurrentExtended, Null)
EndFunc
Func _MemGlobalAlloc($iBytes, $iFlags = 0)
Local $aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $iFlags, "ulong_ptr", $iBytes)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _MemGlobalLock($hMemory)
Local $aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hMemory)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _MemGlobalUnlock($hMemory)
Local $aResult = DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hMemory)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
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
Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadReadPtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Func _WinAPI_IsBadWritePtr($pAddress, $iLength)
Local $aRet = DllCall('kernel32.dll', 'bool', 'IsBadWritePtr', 'struct*', $pAddress, 'uint_ptr', $iLength)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
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
Local $aRet = DllCall('winmm.dll', 'bool', 'PlaySoundW', $sTypeOfSound, $sSound, 'handle', $hInstance, 'dword', $iFlags)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Func _WinAPI_DestroyIcon($hIcon)
Local $aResult = DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hIcon)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_DestroyCursor($hCursor)
Local $aRet = DllCall('user32.dll', 'bool', 'DestroyCursor', 'handle', $hCursor)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_FindResource($hInstance, $sType, $sName)
Local $sTypeOfType = 'int', $sTypeOfName = 'int'
If IsString($sType) Then
$sTypeOfType = 'wstr'
EndIf
If IsString($sName) Then
$sTypeOfName = 'wstr'
EndIf
Local $aRet = DllCall('kernel32.dll', 'handle', 'FindResourceW', 'handle', $hInstance, $sTypeOfName, $sName, $sTypeOfType, $sType)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_FindResourceEx($hInstance, $sType, $sName, $iLanguage)
Local $sTypeOfType = 'int', $sTypeOfName = 'int'
If IsString($sType) Then
$sTypeOfType = 'wstr'
EndIf
If IsString($sName) Then
$sTypeOfName = 'wstr'
EndIf
Local $aRet = DllCall('kernel32.dll', 'handle', 'FindResourceExW', 'handle', $hInstance, $sTypeOfType, $sType, $sTypeOfName, $sName, 'ushort', $iLanguage)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_LoadString($hInstance, $iStringID)
Local $aResult = DllCall("user32.dll", "int", "LoadStringW", "handle", $hInstance, "uint", $iStringID, "wstr", "", "int", 4096)
If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")
Return SetExtended($aResult[0], $aResult[3])
EndFunc
Func _WinAPI_LoadLibraryEx($sFileName, $iFlags = 0)
Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileName, "ptr", 0, "dword", $iFlags)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_LoadResource($hInstance, $hResource)
Local $aRet = DllCall('kernel32.dll', 'handle', 'LoadResource', 'handle', $hInstance, 'handle', $hResource)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_LockResource($hData)
Local $aRet = DllCall('kernel32.dll', 'ptr', 'LockResource', 'handle', $hData)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_SizeOfResource($hInstance, $hResource)
Local $aRet = DllCall('kernel32.dll', 'dword', 'SizeofResource', 'handle', $hInstance, 'handle', $hResource)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return $aRet[0]
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
Local $aRet = DllCall("advapi32.dll", "bool", "InitializeSecurityDescriptor", "struct*", $tSecurityDescriptor, "dword", $SECURITY_DESCRIPTOR_REVISION)
If @error Then Return SetError(@error, @extended, 0)
If $aRet[0] Then
$aRet = DllCall("advapi32.dll", "bool", "SetSecurityDescriptorDacl", "struct*", $tSecurityDescriptor, "bool", 1, "ptr", 0, "bool", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aRet[0] Then
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
Local $aReturn = DllCall($vDLL, "short", "GetAsyncKeyState", "int", "0x" & $sHexKey)
If @error Then Return SetError(@error, @extended, False)
Return BitAND($aReturn[0], 0x8000) <> 0
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
Local $aReturn = DllCall('ole32.dll', 'long', 'CreateStreamOnHGlobal', 'handle', $hGlobal, 'bool', $bDeleteOnRelease, 'ptr*', 0)
If @error Then Return SetError(@error, @extended, 0)
If $aReturn[0] Then Return SetError(10, $aReturn[0], 0)
Return $aReturn[3]
EndFunc
Func _WinAPI_ReleaseStream($pStream)
Local $aReturn = DllCall('oleaut32.dll', 'long', 'DispCallFunc', 'ptr', $pStream, 'ulong_ptr', 8 *(1 + @AutoItX64), 'uint', 4, 'ushort', 23, 'uint', 0, 'ptr', 0, 'ptr', 0, 'str', '')
If @error Then Return SetError(@error, @extended, 0)
If $aReturn[0] Then Return SetError(10, $aReturn[0], 0)
Return 1
EndFunc
Func _WinAPI_SetWindowLong($hWnd, $iIndex, $iValue)
_WinAPI_SetLastError(0)
Local $sFuncName = "SetWindowLongW"
If @AutoItX64 Then $sFuncName = "SetWindowLongPtrW"
Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex, "long_ptr", $iValue)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_AddFontMemResourceEx($pData, $iSize)
Local $aRet = DllCall('gdi32.dll', 'handle', 'AddFontMemResourceEx', 'ptr', $pData, 'dword', $iSize, 'ptr', 0, 'dword*', 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetExtended($aRet[4], $aRet[0])
EndFunc
Func _WinAPI_DeleteEnhMetaFile($hEmf)
Local $aRet = DllCall('gdi32.dll', 'bool', 'DeleteEnhMetaFile', 'handle', $hEmf)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Func _WinAPI_EnumDisplayMonitors($hDC = 0, $tRECT = 0)
Local $hEnumProc = DllCallbackRegister('__EnumDisplayMonitorsProc', 'bool', 'handle;handle;ptr;lparam')
Dim $__g_vEnum[101][2] = [[0]]
Local $aRet = DllCall('user32.dll', 'bool', 'EnumDisplayMonitors', 'handle', $hDC, 'struct*', $tRECT, 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', 0)
If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
$__g_vEnum = @error + 10
EndIf
DllCallbackFree($hEnumProc)
If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)
__Inc($__g_vEnum, -1)
Return $__g_vEnum
EndFunc
Func _WinAPI_GetPosFromRect($tRECT)
Local $aResult[4]
For $i = 0 To 3
$aResult[$i] = DllStructGetData($tRECT, $i + 1)
If @error Then Return SetError(@error, @extended, 0)
Next
For $i = 2 To 3
$aResult[$i] -= $aResult[$i - 2]
Next
Return $aResult
EndFunc
Func _WinAPI_MonitorFromWindow($hWnd, $iFlag = 1)
Local $aRet = DllCall('user32.dll', 'handle', 'MonitorFromWindow', 'hwnd', $hWnd, 'dword', $iFlag)
If @error Then Return SetError(@error, @extended, 0)
Return $aRet[0]
EndFunc
Func _WinAPI_RemoveFontMemResourceEx($hFont)
Local $aRet = DllCall('gdi32.dll', 'bool', 'RemoveFontMemResourceEx', 'handle', $hFont)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
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
Global Const $INET_FORCERELOAD = 1
Global Const $INET_IGNORESSL = 2
Global Const $INET_DOWNLOADBACKGROUND = 1
Func _INetGetSource($sURL, $bString = True)
Local $sString = InetRead($sURL, $INET_FORCERELOAD)
Local $iError = @error, $iExtended = @extended
If $bString = Default Or $bString Then $sString = BinaryToString($sString)
Return SetError($iError, $iExtended, $sString)
EndFunc
Global Const $hGIFDLL__KERNEL32 = DllOpen("kernel32.dll")
Global Const $hGIFDLL__USER32 = DllOpen("user32.dll")
Global Const $hGIFDLL__GDI32 = DllOpen("gdi32.dll")
Global Const $hGIFDLL__COMCTL32 = DllOpen("comctl32.dll")
Global Const $hGIFDLL__OLE32 = DllOpen("ole32.dll")
Global Const $hGIFDLL__GDIPLUS = DllOpen("gdiplus.dll")
Global $sGIF__ASSOCSTRING_INTERNAL = ";"
Func _GIF_DeleteGIF($iGIFId, $fDelCtrl = True)
Local $pGIF = _GIF_GetGIFAssoc($iGIFId)
Local $tGIF = DllStructCreate("handle GIFThread;" & "ptr CodeBuffer;" & "hwnd ControlHandle;" & "handle ImageList;" & "bool ExitFlag;", $pGIF)
Local $hGIFThread = DllStructGetData($tGIF, "GIFThread")
If $hGIFThread Then
_GIF_ResumeThread($hGIFThread)
DllStructSetData($tGIF, "ExitFlag", 1)
_GIF_WaitForSingleObject($hGIFThread)
_GIF_CloseHandle($hGIFThread)
EndIf
Local $pCodeBuffer = DllStructGetData($tGIF, "CodeBuffer")
If $pCodeBuffer Then _GIF_MemGlobalFree($pCodeBuffer)
Local $hImageList = DllStructGetData($tGIF, "ImageList")
If $hImageList Then _GIF_ImageList_Destroy($hImageList)
_GIF_MemGlobalFree($pGIF)
_GIF_DeleteObject(GUICtrlSendMsg($iGIFId, 370, 0, 0))
If $fDelCtrl Then GUICtrlDelete($iGIFId)
$sGIF__ASSOCSTRING_INTERNAL = StringReplace($sGIF__ASSOCSTRING_INTERNAL, $iGIFId & "|" & $pGIF & ";", "")
Return 1
EndFunc
Func _GIF_ExitAnimation($iGIFId)
Local $pGIF = _GIF_GetGIFAssoc($iGIFId)
Local $tGIF = DllStructCreate("handle GIFThread;" & "ptr CodeBuffer;" & "hwnd ControlHandle;" & "handle ImageList;" & "bool ExitFlag;" & "bool Transparent;" & "dword CurrentFrame;", $pGIF)
Local $hGIFThread = DllStructGetData($tGIF, "GIFThread")
If $hGIFThread Then
_GIF_ResumeThread($hGIFThread)
DllStructSetData($tGIF, "ExitFlag", 1)
_GIF_WaitForSingleObject($hGIFThread)
_GIF_CloseHandle($hGIFThread)
DllStructSetData($tGIF, "GIFThread", 0)
EndIf
Local $pCodeBuffer = DllStructGetData($tGIF, "CodeBuffer")
If $pCodeBuffer Then _GIF_MemGlobalFree($pCodeBuffer)
DllStructSetData($tGIF, "CodeBuffer", 0)
Local $hImageList = DllStructGetData($tGIF, "ImageList")
If $hImageList Then _GIF_ImageList_Destroy($hImageList)
DllStructSetData($tGIF, "ImageList", 0)
DllStructSetData($tGIF, "CurrentFrame", 0)
GUICtrlSetState($iGIFId, GUICtrlGetState($iGIFId))
Return 1
EndFunc
Func _GIF_PauseAnimation($iGIFId)
Local $pGIF = _GIF_GetGIFAssoc($iGIFId)
Local $tGIF = DllStructCreate("handle GIFThread;", $pGIF)
Local $hGIFThread = DllStructGetData($tGIF, "GIFThread")
If Not $hGIFThread Then Return SetExtended(1, 1)
If _GIF_SuspendThread($hGIFThread) Then _GIF_ResumeThread($hGIFThread)
Return 1
EndFunc
Func _GIF_ResumeAnimation($iGIFId)
Local $pGIF = _GIF_GetGIFAssoc($iGIFId)
Local $tGIF = DllStructCreate("handle GIFThread;", $pGIF)
Local $hGIFThread = DllStructGetData($tGIF, "GIFThread")
If Not $hGIFThread Then Return SetExtended(1, 1)
If _GIF_ResumeThread($hGIFThread) = 2 Then _GIF_SuspendThread($hGIFThread)
Return 1
EndFunc
Func _GUICtrlCreateGIF($vGIF, $vAdditionalData, $iLeft, $iTop, $iWidth = Default, $iHeight = Default, $iRenderingStyle = Default, $iForcedARGB = Default, $hGIFControl = 0)
If $iWidth = -1 Then $iWidth = Default
If $iHeight = -1 Then $iHeight = Default
Local $vData
If IsBinary($vGIF) Then
$vData = $vGIF
Else
If $vAdditionalData Then
Local $aData = StringSplit($vAdditionalData, ";", 2)
If UBound($aData) < 3 Then ReDim $aData[3]
$vData = _GIF_ResourceGetAsRaw($vGIF, $aData[0], $aData[1], $aData[2])
If @error Then
$vData = $vGIF
Else
If $aData[0] = 2 Then $vData = _GIF_MakeBitmapFromRT_BITMAP($vData)
EndIf
Else
$vData = $vGIF
EndIf
EndIf
Local $iWidthDef, $iHeightDef
If Not IsKeyword($iWidthDef) = 1 Then $iWidthDef = $iWidth
If Not IsKeyword($iHeightDef) = 1 Then $iHeightDef = $iHeight
Local $pGIF = _GIF_Create_pGIF($vData, $iWidthDef, $iHeightDef, $hGIFControl, $iLeft, $iTop, $iForcedARGB)
If @error Then
$vData = FileRead($vData)
$pGIF = _GIF_Create_pGIF($vData, $iWidthDef, $iHeightDef, $hGIFControl, $iLeft, $iTop, $iForcedARGB)
If @error Then
$pGIF = _GIF_Create_pGIF(Binary($vGIF), $iWidthDef, $iHeightDef, $hGIFControl, $iLeft, $iTop, $iForcedARGB)
If @error Then Return SetError(1, @extended = True, 0)
EndIf
EndIf
Local $tGIF = DllStructCreate("handle GIFThread;" & "ptr CodeBuffer;" & "hwnd ControlHandle;" & "handle ImageList;" & "bool ExitFlag;" & "bool Transparent;" & "dword CurrentFrame;" & "dword NumberOfFrames;", $pGIF)
Local $iFrameCount = DllStructGetData($tGIF, "NumberOfFrames")
$tGIF = DllStructCreate("handle GIFThread;" & "ptr CodeBuffer;" & "hwnd ControlHandle;" & "handle ImageList;" & "bool ExitFlag;" & "bool Transparent;" & "dword CurrentFrame;" & "dword NumberOfFrames;" & "dword FrameDelay[" & $iFrameCount & "];", $pGIF)
GUICtrlSetResizing($hGIFControl, 802)
DllStructSetData($tGIF, "ControlHandle", GUICtrlGetHandle($hGIFControl))
If $iFrameCount = 1 Then
$sGIF__ASSOCSTRING_INTERNAL &= $hGIFControl & "|" & $pGIF & ";"
Return SetExtended(1, $hGIFControl)
EndIf
Local $iSizeCodeBuffer = 157
If @AutoItX64 Then $iSizeCodeBuffer = 220
Local $pCodeBuffer = _GIF_MemGlobalAlloc($iSizeCodeBuffer, 64)
If @error Then Return SetError(2, 0, $hGIFControl)
DllStructSetData($tGIF, "CodeBuffer", $pCodeBuffer)
_GIF_VirtualProtect($pCodeBuffer, $iSizeCodeBuffer, 64)
If @error Then Return SetError(3, 0, $hGIFControl)
Local $tCodeBuffer = DllStructCreate("byte[" & $iSizeCodeBuffer & "]", $pCodeBuffer)
Local $pImageList_DrawEx = _GIF_GetAddress(_GIF_GetModuleHandle("comctl32.dll"), "ImageList_DrawEx")
If @error Then Return SetError(4, 1, $hGIFControl)
Local $pSleep = _GIF_GetAddress(_GIF_GetModuleHandle("kernel32.dll"), "Sleep")
If @error Then Return SetError(4, 2, $hGIFControl)
Local $pGetPixel = _GIF_GetAddress(_GIF_GetModuleHandle("gdi32.dll"), "GetPixel")
If @error Then Return SetError(4, 3, $hGIFControl)
Local $hUser32 = _GIF_GetModuleHandle("user32.dll")
Local $pGetDC = _GIF_GetAddress($hUser32, "GetDC")
If @error Then Return SetError(4, 4, $hGIFControl)
Local $pReleaseDC = _GIF_GetAddress($hUser32, "ReleaseDC")
If @error Then Return SetError(4, 5, $hGIFControl)
Local $hImageList = DllStructGetData($tGIF, "ImageList")
Local $hControl = DllStructGetData($tGIF, "ControlHandle")
Local $iStyle
If $iRenderingStyle = Default Then
$iStyle = 1
If DllStructGetData($tGIF, "Transparent") Then $iStyle = 0
Else
$iStyle = $iRenderingStyle
EndIf
If @AutoItX64 Then
DllStructSetData($tCodeBuffer, 1, "0x" & "4883EC" & _GIF_SwapEndian(88, 1) & "" & "4831F6" & "" & "" & "8BC6" & "A3" & _GIF_SwapEndian(DllStructGetPtr($tGIF, "CurrentFrame"), 8) & "" & "48B9" & _GIF_SwapEndian($hControl, 8) & "48B8" & _GIF_SwapEndian($pGetDC, 8) & "FFD0" & "" & "4889C3" & "" & "49C7C0" & _GIF_SwapEndian(0, 4) & "BA" & _GIF_SwapEndian(0, 4) & "4889C1" & "48B8" & _GIF_SwapEndian($pGetPixel, 8) & "FFD0" & "" & "3D" & _GIF_SwapEndian(-1, 4) & "75" & _GIF_SwapEndian(2, 1) & "8BC7" & "" & "8BF8" & "" & "89442438" & "B8" & _GIF_SwapEndian($iStyle, 4) & "89442448" & "4989D8" & "49C7C1" & _GIF_SwapEndian(0, 4) & "89F2" & "48B9" & _GIF_SwapEndian($hImageList, 8) & "" & "48B8" & _GIF_SwapEndian($pImageList_DrawEx, 8) & "FFD0" & "" & "4889DA" & "48B9" & _GIF_SwapEndian($hControl, 8) & "48B8" & _GIF_SwapEndian($pReleaseDC, 8) & "FFD0" & "" & "A1" & _GIF_SwapEndian(DllStructGetPtr($tGIF, "ExitFlag"), 8) & "85C0" & "75" & _GIF_SwapEndian(46, 1) & "" & "48BB" & _GIF_SwapEndian(DllStructGetPtr($tGIF, "FrameDelay"), 8) & "488B0CB3" & "48B8" & _GIF_SwapEndian($pSleep, 8) & "FFD0" & "" & "FFC6" & "" & "81FE" & _GIF_SwapEndian($iFrameCount, 4) & "" & "74" & _GIF_SwapEndian(5, 1) & "E9" & _GIF_SwapEndian(-200, 4) & "E9" & _GIF_SwapEndian(-208, 4) & "" & "4831C0" & "4883C4" & _GIF_SwapEndian(88, 1) & "C3" )
Else
DllStructSetData($tCodeBuffer, 1, "0x" & "" & "33F6" & "" & "" & "8BC6" & "A3" & _GIF_SwapEndian(DllStructGetPtr($tGIF, "CurrentFrame"), 4) & "68" & _GIF_SwapEndian($iStyle, 4) & "68" & _GIF_SwapEndian(-1, 4) & "" & "68" & _GIF_SwapEndian($hControl, 4) & "B8" & _GIF_SwapEndian($pGetDC, 4) & "FFD0" & "" & "8BD8" & "" & "68" & _GIF_SwapEndian(0, 4) & "68" & _GIF_SwapEndian(0, 4) & "53" & "B8" & _GIF_SwapEndian($pGetPixel, 4) & "FFD0" & "" & "3D" & _GIF_SwapEndian(-1, 4) & "75" & _GIF_SwapEndian(2, 1) & "8BC7" & "" & "8BF8" & "" & "50" & "68" & _GIF_SwapEndian(0, 4) & "68" & _GIF_SwapEndian(0, 4) & "68" & _GIF_SwapEndian(0, 4) & "68" & _GIF_SwapEndian(0, 4) & "53" & "56" & "68" & _GIF_SwapEndian($hImageList, 4) & "" & "B8" & _GIF_SwapEndian($pImageList_DrawEx, 4) & "FFD0" & "" & "53" & "68" & _GIF_SwapEndian($hControl, 4) & "B8" & _GIF_SwapEndian($pReleaseDC, 4) & "FFD0" & "" & "A1" & _GIF_SwapEndian(DllStructGetPtr($tGIF, "ExitFlag"), 4) & "85C0" & "75" & _GIF_SwapEndian(35, 1) & "" & "BB" & _GIF_SwapEndian(DllStructGetPtr($tGIF, "FrameDelay"), 4) & "8B0CB3" & "51" & "B8" & _GIF_SwapEndian($pSleep, 4) & "FFD0" & "" & "46" & "" & "81FE" & _GIF_SwapEndian($iFrameCount, 4) & "" & "74" & _GIF_SwapEndian(5, 1) & "E9" & _GIF_SwapEndian(-147, 4) & "E9" & _GIF_SwapEndian(-154, 4) & "" & "33C0" & "C3" )
EndIf
Local $hThread = _GIF_CreateThread($pCodeBuffer)
If @error Then Return SetError(5, 0, $hGIFControl)
DllStructSetData($tGIF, "GIFThread", $hThread)
_GIF_InvalidateRect(_GIF_GetParent($hControl))
$sGIF__ASSOCSTRING_INTERNAL &= $hGIFControl & "|" & $pGIF & ";"
Return $hGIFControl
EndFunc
Func _GUICtrlSetGIF($iControld, $vGIF, $vAdditionalData = Default, $iRenderingStyle = Default, $iForcedARGB = Default)
Local $aCtrlPos = WinGetPos(GUICtrlGetHandle($iControld))
If @error Then Return SetError(6, 0, False)
If $vAdditionalData = Default Then $vAdditionalData = ""
If $aCtrlPos[2] = 0 Then $aCtrlPos[2] = Default
If $aCtrlPos[3] = 0 Then $aCtrlPos[3] = Default
_GIF_DeleteGIF($iControld, False)
_GUICtrlCreateGIF($vGIF, $vAdditionalData, $aCtrlPos[0], $aCtrlPos[1], $aCtrlPos[2], $aCtrlPos[3], $iRenderingStyle, $iForcedARGB, $iControld)
Return SetError(@error, @extended, Not @error)
EndFunc
Func _GIF_CloseHandle($hHandle)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "bool", "CloseHandle", "handle", $hHandle)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_WaitForSingleObject($hHandle, $iMiliSec = -1)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "dword", "WaitForSingleObject", "handle", $hHandle, "dword", $iMiliSec)
If @error Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_CreateThread($pAddress)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "CreateThread", "ptr", 0, "dword_ptr", 0, "ptr", $pAddress, "ptr", 0, "dword", 0, "dword*", 0)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_SuspendThread($hTread)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "dword", "SuspendThread", "handle", $hTread)
If @error Or $aCall[0] = -1 Then Return SetError(1, 0, -1)
Return $aCall[0]
EndFunc
Func _GIF_ResumeThread($hTread)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "dword", "ResumeThread", "handle", $hTread)
If @error Or $aCall[0] = -1 Then Return SetError(1, 0, -1)
Return $aCall[0]
EndFunc
Func _GIF_VirtualProtect($pAddress, $iSize, $iProtection)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "bool", "VirtualProtect", "ptr", $pAddress, "dword_ptr", $iSize, "dword", $iProtection, "dword*", 0)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_GetAddress($hModule, $vFuncName)
Local $sType = "str"
If IsNumber($vFuncName) Then $sType = "int"
Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GetProcAddress", "handle", $hModule, $sType, $vFuncName)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_GetModuleHandle($vModule = 0)
Local $sType = "wstr"
If Not $vModule Then $sType = "ptr"
Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GetModuleHandleW", $sType, $vModule)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_InvalidateRect($hWnd, $pRect = 0, $fErase = True)
Local $aCall = DllCall($hGIFDLL__USER32, "bool", "InvalidateRect", "hwnd", $hWnd, "ptr", $pRect, "bool", $fErase)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_GetParent($hWnd)
Local $aCall = DllCall($hGIFDLL__USER32, "hwnd", "GetParent", "hwnd", $hWnd)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_Create_pGIF($bBinary, ByRef $iWidth, ByRef $iHeight, ByRef $hGIFControl, $iLeft = 0, $iTop = 0, $iARGB = Default)
If $iARGB = Default Then $iARGB = 0xFF000000
Local $hGDIP
Local $hMemGlobal
Local $pBitmap, $iWidthReal, $iHeightReal
If IsBinary($bBinary) Then
$pBitmap = _GIF_CreateBitmapFromBinaryImage($hGDIP, $hMemGlobal, $bBinary, $iWidthReal, $iHeightReal)
Else
$pBitmap = _GIF_CreateBitmapFromFile($hGDIP, $bBinary, $iWidthReal, $iHeightReal)
EndIf
If @error Then
Local $iErr = @error
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
Return SetError(1, $iErr, 0)
EndIf
Local $fDoResize
If $iWidth = Default Then
$iWidth = $iWidthReal
Else
$fDoResize = True
EndIf
If $iHeight = Default Then
$iHeight = $iHeightReal
Else
$fDoResize = True
EndIf
Local $iFrameDimensionsCount = _GIF_GdipImageGetFrameDimensionsCount($pBitmap)
If @error Then
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
Return SetError(2, 0, 0)
EndIf
Local $tGUID = DllStructCreate("dword;word;word;byte[8]")
Local $pGUID = DllStructGetPtr($tGUID)
_GIF_GdipImageGetFrameDimensionsList($pBitmap, $pGUID, $iFrameDimensionsCount)
If @error Then
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
Return SetError(3, 0, 0)
EndIf
Local $iFrameCount = _GIF_GdipImageGetFrameCount($pBitmap, $pGUID)
If @error Then
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
Return SetError(4, 0, 0)
EndIf
Local $pGIF = _GIF_MemGlobalAlloc(4 *(8 + 4 * @AutoItX64 + $iFrameCount), 64)
If @error Then
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
Return SetError(3, 0, 0)
EndIf
Local $tGIF = DllStructCreate("handle GIFThread;" & "ptr CodeBuffer;" & "hwnd ControlHandle;" & "handle ImageList;" & "bool ExitFlag;" & "bool Transparent;" & "dword CurrentFrame;" & "dword NumberOfFrames;" & "dword FrameDelay[" & $iFrameCount & "];", $pGIF)
DllStructSetData($tGIF, "GIFThread", 0)
DllStructSetData($tGIF, "ControlHandle", 0)
DllStructSetData($tGIF, "ExitFlag", 0)
DllStructSetData($tGIF, "CurrentFrame", 0)
DllStructSetData($tGIF, "NumberOfFrames", $iFrameCount)
Local $fNewControl = False
If Not $hGIFControl Then
$fNewControl = True
$hGIFControl = GUICtrlCreatePic("", $iLeft, $iTop, $iWidth, $iHeight)
EndIf
If $iFrameCount = 1 Then
Local $hGIFBitmap = _GIF_GdipCreateHBITMAPFromBitmap($pBitmap, $iARGB)
If $fDoResize Then _GIF_ResizeBitmap($hGIFBitmap, $iWidth, $iHeight)
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
_GIF_DeleteObject(GUICtrlSendMsg($hGIFControl, 370, 0, $hGIFBitmap))
_GIF_DeleteObject($hGIFBitmap)
Return $pGIF
EndIf
Local $hImageList = _GIF_ImageList_Create($iWidth, $iHeight, 32, $iFrameCount)
If @error Then
If $fNewControl Then GUICtrlDelete($hGIFControl)
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal, $pGIF)
Return SetError(4, 0, 0)
EndIf
DllStructSetData($tGIF, "ImageList", $hImageList)
Local $hBitmap
For $j = 0 To $iFrameCount - 1
_GIF_GdipImageSelectActiveFrame($pBitmap, $pGUID, $j)
If @error Then ContinueLoop
$hBitmap = _GIF_GdipCreateHBITMAPFromBitmap($pBitmap, $iARGB)
If $fDoResize Then _GIF_ResizeBitmap($hBitmap, $iWidth, $iHeight)
_GIF_ImageList_Add($hImageList, $hBitmap)
If $j = 0 Then
_GIF_DeleteObject(GUICtrlSendMsg($hGIFControl, 370, 0, $hBitmap))
_GIF_DeleteObject($hBitmap)
EndIf
_GIF_DeleteObject($hBitmap)
Next
Local $iPropertyItemSize = _GIF_GdipGetPropertyItemSize($pBitmap, 0x5100)
If @error Then
If $fNewControl Then GUICtrlDelete($hGIFControl)
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal, $pGIF)
Return SetError(5, 0, 0)
EndIf
Local $tRawPropItem = DllStructCreate("byte[" & $iPropertyItemSize & "]")
_GIF_GdipGetPropertyItem($pBitmap, 0x5100, $iPropertyItemSize, DllStructGetPtr($tRawPropItem))
If @error Then
If $fNewControl Then GUICtrlDelete($hGIFControl)
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal, $pGIF)
Return SetError(6, 0, 0)
EndIf
Local $tPropItem = DllStructCreate("int Id;" & "dword Length;" & "word Type;" & "ptr Value", DllStructGetPtr($tRawPropItem))
Local $iSize = DllStructGetData($tPropItem, "Length") / 4
Local $tPropertyData = DllStructCreate("dword[" & $iSize & "]", DllStructGetData($tPropItem, "Value"))
Local $iDelay
For $j = 1 To $iFrameCount
$iDelay = DllStructGetData($tPropertyData, 1, $j) * 10
If Not $iDelay Then $iDelay = 130
If $iDelay < 50 Then $iDelay = 50
DllStructSetData($tGIF, "FrameDelay", $iDelay, $j)
Next
Local $fTransparent = True
Local $iPixelColor = _GIF_GdipBitmapGetPixel($pBitmap, 0, 0)
If BitShift($iPixelColor, 24) Then $fTransparent = False
DllStructSetData($tGIF, "Transparent", $fTransparent)
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
Return $pGIF
EndFunc
Func _GIF_CreateStreamOnHGlobal($hGlobal, $iFlag = 1)
Local $aCall = DllCall($hGIFDLL__OLE32, "long", "CreateStreamOnHGlobal", "handle", $hGlobal, "int", $iFlag, "ptr*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[3]
EndFunc
Func _GIF_GetObject($hObject, $iSize, $pObject)
Local $aCall = DllCall($hGIFDLL__GDI32, "int", "GetObject", "handle", $hObject, "int", $iSize, "ptr", $pObject)
If @error Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_DeleteObject($hObject)
Local $aCall = DllCall($hGIFDLL__GDI32, "bool", "DeleteObject", "handle", $hObject)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_ImageList_Create($iWidth, $iHeight, $iFlag, $iInitial, $iGrow = 0)
Local $aCall = DllCall($hGIFDLL__COMCTL32, "handle", "ImageList_Create", "int", $iWidth, "int", $iHeight, "dword", $iFlag, "int", $iInitial, "int", $iGrow)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_ImageList_Add($hImageList, $hBitmap)
Local $aCall = DllCall($hGIFDLL__COMCTL32, "int", "ImageList_Add", "handle", $hImageList, "handle", $hBitmap, "handle", 0)
If @error Or $aCall[0] = -1 Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_ImageList_Destroy($hImageList)
Local $aCall = DllCall($hGIFDLL__COMCTL32, "bool", "ImageList_Destroy", "handle", $hImageList)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_CreateBitmapFromFile(ByRef $hGDIP, $sFile, ByRef $iWidth, ByRef $iHeight)
$hGDIP = _GIF_GdiplusStartup()
If @error Then Return SetError(1, 0, 0)
Local $pBitmap = _GIF_GdipLoadImageFromFile($sFile)
If @error Then
_GIF_GdiplusShutdown($hGDIP)
Return SetError(2, 0, 0)
EndIf
_GIF_GdipGetImageDimension($pBitmap, $iWidth, $iHeight)
If @error Then
_GIF_FreeGdipAndMem($pBitmap, $hGDIP)
Return SetError(3, 0, 0)
EndIf
Return $pBitmap
EndFunc
Func _GIF_CreateBitmapFromBinaryImage(ByRef $hGDIP, ByRef $hMemGlobal, $bBinary, ByRef $iWidth, ByRef $iHeight)
$bBinary = Binary($bBinary)
Local $iSize = BinaryLen($bBinary)
$hMemGlobal = _GIF_MemGlobalAlloc($iSize, 2)
If @error Then Return SetError(1, 0, 0)
Local $pMemory = _GIF_MemGlobalLock($hMemGlobal)
If @error Then
_GIF_MemGlobalFree($hMemGlobal)
Return SetError(2, 0, 0)
EndIf
Local $tBinary = DllStructCreate("byte[" & $iSize & "]", $pMemory)
DllStructSetData($tBinary, 1, $bBinary)
Local $pStream = _GIF_CreateStreamOnHGlobal($pMemory, 0)
If @error Then
_GIF_MemGlobalFree($hMemGlobal)
Return SetError(3, 0, 0)
EndIf
_GIF_MemGlobalUnlock($pMemory)
$hGDIP = _GIF_GdiplusStartup()
If @error Then
_GIF_MemGlobalFree($hMemGlobal)
Return SetError(4, 0, 0)
EndIf
Local $pBitmap = _GIF_GdipCreateBitmapFromStream($pStream)
If @error Then
_GIF_GdiplusShutdown($hGDIP)
_GIF_MemGlobalFree($hMemGlobal)
Return SetError(5, 0, 0)
EndIf
_GIF_GdipGetImageDimension($pBitmap, $iWidth, $iHeight)
If @error Then
_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
Return SetError(6, 0, 0)
EndIf
DllCallAddress("dword", DllStructGetData(DllStructCreate("ptr QueryInterface; ptr AddRef; ptr Release;", DllStructGetData(DllStructCreate("ptr pObj;", $pStream), "pObj")), "Release"), "ptr", $pStream)
Return $pBitmap
EndFunc
Func _GIF_ResizeBitmap(ByRef $hBitmap, $iNewWidth, $iNewHeight)
Local $tBMP = DllStructCreate("long Type;long Width;long Height;long WidthBytes;word Planes;word BitsPixel;ptr Bits;")
_GIF_GetObject($hBitmap, DllStructGetSize($tBMP), DllStructGetPtr($tBMP))
Local $pBitmap = _GIF_GdipCreateBitmapFromScan0(DllStructGetData($tBMP, "Width"), DllStructGetData($tBMP, "Height"), DllStructGetData($tBMP, "WidthBytes"), 0x26200A, DllStructGetData($tBMP, "Bits"))
_GIF_GdipImageRotateFlip($pBitmap, 6)
Local $pNewBitmap = _GIF_GdipCreateBitmapFromScan0($iNewWidth, $iNewHeight)
Local $hGraphics = _GIF_GdipGetImageGraphicsContext($pNewBitmap)
_GIF_GdipDrawImageRect($hGraphics, $pBitmap, 0, 0, $iNewWidth, $iNewHeight)
Local $hNewBitmap = _GIF_GdipCreateHBITMAPFromBitmap($pNewBitmap)
_GIF_GdipDisposeImage($pBitmap)
_GIF_GdipDeleteGraphics($hGraphics)
_GIF_DeleteObject($hBitmap)
_GIF_GdipDisposeImage($pNewBitmap)
$hBitmap = $hNewBitmap
Return 1
EndFunc
Func _GIF_GdiplusStartup()
Local $tGdiplusStartupInput = DllStructCreate("dword GdiplusVersion;" & "ptr DebugEventCallback;" & "int SuppressBackgroundThread;" & "int SuppressExternalCodecs")
DllStructSetData($tGdiplusStartupInput, "GdiplusVersion", 1)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdiplusStartup", "dword_ptr*", 0, "ptr", DllStructGetPtr($tGdiplusStartupInput), "ptr", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[1]
EndFunc
Func _GIF_GdiplusShutdown($hGDIP)
DllCall($hGIFDLL__GDIPLUS, "none", "GdiplusShutdown", "dword_ptr", $hGDIP)
EndFunc
Func _GIF_GdipDisposeImage($hImage)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipDisposeImage", "handle", $hImage)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_GdipGetImageDimension($pBitmap, ByRef $iWidth, ByRef $iHeight)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipGetImageDimension", "ptr", $pBitmap, "float*", 0, "float*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
$iWidth = $aCall[2]
$iHeight = $aCall[3]
EndFunc
Func _GIF_GdipImageGetFrameDimensionsCount($pBitmap)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageGetFrameDimensionsCount", "ptr", $pBitmap, "dword*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[2]
EndFunc
Func _GIF_GdipImageGetFrameDimensionsList($pBitmap, $pGUID, $iFrameDimensionsCount)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageGetFrameDimensionsList", "ptr", $pBitmap, "ptr", $pGUID, "dword", $iFrameDimensionsCount)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_GdipImageGetFrameCount($pBitmap, $pGUID)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageGetFrameCount", "ptr", $pBitmap, "ptr", $pGUID, "dword*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[3]
EndFunc
Func _GIF_GdipImageSelectActiveFrame($pBitmap, $pGUID, $iFrameIndex)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageSelectActiveFrame", "ptr", $pBitmap, "ptr", $pGUID, "dword", $iFrameIndex)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_GdipGetPropertyItemSize($pBitmap, $iPropID)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipGetPropertyItemSize", "ptr", $pBitmap, "ptr", $iPropID, "dword*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[3]
EndFunc
Func _GIF_GdipGetPropertyItem($pBitmap, $iPropID, $iSize, $pBuffer)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipGetPropertyItem", "ptr", $pBitmap, "dword", $iPropID, "dword", $iSize, "ptr", $pBuffer)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_GdipBitmapGetPixel($pBitmap, $iX, $iY)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipBitmapGetPixel", "ptr", $pBitmap, "int", $iX, "int", $iY, "dword*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[4]
EndFunc
Func _GIF_GdipLoadImageFromFile($sFile)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipLoadImageFromFile", "wstr", $sFile, "ptr*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[2]
EndFunc
Func _GIF_GdipCreateBitmapFromScan0($iWidth, $iHeight, $iStride = 0, $iPixelFormat = 0x26200A, $pScan0 = 0)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "dword", $iPixelFormat, "ptr", $pScan0, "ptr*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[6]
EndFunc
Func _GIF_GdipCreateBitmapFromStream($pStream)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipCreateBitmapFromStream", "ptr", $pStream, "ptr*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[2]
EndFunc
Func _GIF_GdipCreateHBITMAPFromBitmap($pBitmap, $iARGB = 0xFF000000)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipCreateHBITMAPFromBitmap", "ptr", $pBitmap, "handle*", 0, "dword", $iARGB)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[2]
EndFunc
Func _GIF_GdipGetImageGraphicsContext($hImage)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipGetImageGraphicsContext", "ptr", $hImage, "ptr*", 0)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[2]
EndFunc
Func _GIF_GdipDrawImageRect($hGraphics, $hImage, $iX, $iY, $iWidth, $iHeight)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipDrawImageRectI", "ptr", $hGraphics, "ptr", $hImage, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_GdipDeleteGraphics($hGraphics)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipDeleteGraphics", "handle", $hGraphics)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_GdipImageRotateFlip($hImage, $iType)
Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageRotateFlip", "handle", $hImage, "dword", $iType)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_FreeGdipAndMem($pBitmap = 0, $hGDIP = 0, $hMem = 0, $pGIF = 0)
If $pBitmap Then _GIF_GdipDisposeImage($pBitmap)
If $hGDIP Then _GIF_GdiplusShutdown($hGDIP)
If $hMem Then _GIF_MemGlobalFree($hMem)
If $pGIF Then _GIF_MemGlobalFree($pGIF)
EndFunc
Func _GIF_MemGlobalAlloc($iSize, $iFlag)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "GlobalAlloc", "dword", $iFlag, "dword_ptr", $iSize)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_MemGlobalFree($hMem)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GlobalFree", "handle", $hMem)
If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _GIF_MemGlobalLock($hMem)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GlobalLock", "handle", $hMem)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_MemGlobalUnlock($hMem)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "bool", "GlobalUnlock", "handle", $hMem)
If @error Then Return SetError(1, 0, 0)
If $aCall[0] Or _GIF_GetLastError() Then Return $aCall[0]
Return 1
EndFunc
Func _GIF_GetLastError()
Local $aCall = DllCall($hGIFDLL__KERNEL32, "dword", "GetLastError")
If @error Then Return SetError(1, 0, -1)
Return $aCall[0]
EndFunc
Func _GIF_FindResourceEx($hModule, $vResType, $vResName, $iResLang = 0)
Local $sTypeType = "wstr"
If $vResType == Number($vResType) Then $sTypeType = "int"
Local $sNameType = "wstr"
If $vResName == Number($vResName) Then $sNameType = "int"
Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "FindResourceExW", "handle", $hModule, $sTypeType, $vResType, $sNameType, $vResName, "int", $iResLang)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_SizeofResource($hModule, $hResource)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "int", "SizeofResource", "handle", $hModule, "handle", $hResource)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_LoadResource($hModule, $hResource)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "LoadResource", "handle", $hModule, "handle", $hResource)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_LockResource($hResource)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "LockResource", "handle", $hResource)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_LoadLibraryEx($sModule, $iFlag = 0)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "LoadLibraryExW", "wstr", $sModule, "handle", 0, "dword", $iFlag)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_FreeLibrary($hModule)
Local $aCall = DllCall($hGIFDLL__KERNEL32, "bool", "FreeLibrary", "handle", $hModule)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _GIF_ResourceGetAsRaw($sModule, $vResType, $vResName, $iResLang = 0)
Local $hModule = _GIF_LoadLibraryEx($sModule, 2)
If @error Then Return SetError(1, 0, "")
Local $hResource = _GIF_FindResourceEx($hModule, $vResType, $vResName, $iResLang)
If @error Then
_GIF_FreeLibrary($hModule)
Return SetError(2, 0, "")
EndIf
Local $iSizeOfResource = _GIF_SizeofResource($hModule, $hResource)
If @error Then
_GIF_FreeLibrary($hModule)
Return SetError(3, 0, "")
EndIf
$hResource = _GIF_LoadResource($hModule, $hResource)
If @error Then
_GIF_FreeLibrary($hModule)
Return SetError(4, 0, "")
EndIf
Local $pResource = _GIF_LockResource($hResource)
If @error Then
_GIF_FreeLibrary($hModule)
Return SetError(5, 0, "")
EndIf
Local $tBinary = DllStructCreate("byte[" & $iSizeOfResource & "]", $pResource)
Local $bBinary = DllStructGetData($tBinary, 1)
_GIF_FreeLibrary($hModule)
Return $bBinary
EndFunc
Func _GIF_MakeBitmapFromRT_BITMAP($bBinary)
Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
DllStructSetData($tBinary, 1, $bBinary)
Local $iHeaderSize = DllStructGetData(DllStructCreate("dword HeaderSize", DllStructGetPtr($tBinary)), "HeaderSize")
Local $tBitmap, $iMultiplier
Switch $iHeaderSize
Case 40
$tBitmap = DllStructCreate("dword HeaderSize;" & "dword Width;" & "dword Height;" & "word Planes;" & "word BitPerPixel;" & "dword CompressionMethod;" & "dword Size;" & "dword Hresolution;" & "dword Vresolution;" & "dword Colors;" & "dword ImportantColors", DllStructGetPtr($tBinary))
$iMultiplier = 4
Case 12
$tBitmap = DllStructCreate("dword HeaderSize;" & "word Width;" & "word Height;" & "word Planes;" & "word BitPerPixel", DllStructGetPtr($tBinary))
$iMultiplier = 3
Case Else
Return SetError(1, 0, 0)
EndSwitch
Local $iExponent = DllStructGetData($tBitmap, "BitPerPixel")
Local $tDIB = DllStructCreate("align 2;char Identifier[2];" & "dword BitmapSize;" & "short;" & "short;" & "dword BitmapOffset;" & "byte Body[" & BinaryLen($bBinary) & "]")
DllStructSetData($tDIB, "Identifier", "BM")
DllStructSetData($tDIB, "BitmapSize", BinaryLen($bBinary) + 14)
Local $iRawBitmapSize = DllStructGetData($tBitmap, "Size")
If $iRawBitmapSize Then
DllStructSetData($tDIB, "BitmapOffset", BinaryLen($bBinary) - $iRawBitmapSize + 14)
Else
If $iExponent = 24 Then
DllStructSetData($tDIB, "BitmapOffset", $iHeaderSize + 14)
Else
Local $iWidth = DllStructGetData($tBitmap, "Width")
Local $iHeight = DllStructGetData($tBitmap, "Height")
$iRawBitmapSize = 4 * Floor(($iWidth * $iExponent + 31) / 32) * $iHeight
Local $iOffset1 = BinaryLen($bBinary) - $iRawBitmapSize + 14
Local $iOffset2 = 2 ^ $iExponent * $iMultiplier + $iHeaderSize + 14
If $iOffset2 < $iOffset1 Then
DllStructSetData($tDIB, "BitmapOffset", $iOffset2)
Else
DllStructSetData($tDIB, "BitmapOffset", $iOffset1 - 2)
EndIf
EndIf
EndIf
DllStructSetData($tDIB, "Body", $bBinary)
Return DllStructGetData(DllStructCreate("byte[" & DllStructGetSize($tDIB) & "]", DllStructGetPtr($tDIB)), 1)
EndFunc
Func _GIF_SwapEndian($iValue, $iSize = 0)
If $iSize Then
Local $sPadd = "00000000"
Return Hex(BinaryMid($iValue, 1, $iSize)) & StringLeft($sPadd, 2 *($iSize - BinaryLen($iValue)))
EndIf
Return Hex(Binary($iValue))
EndFunc
Func _GIF_GetGIFAssoc($iGIFId)
Local $aArray = StringRegExp($sGIF__ASSOCSTRING_INTERNAL, "(?i);" & $iGIFId & "\|(.*?);", 3)
If @error Then Return 0
Return Ptr($aArray[0])
EndFunc
Global $__g_hGDIPDll = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True
Func _GDIPlus_BitmapCreateFromHBITMAP($hBitmap, $hPal = 0)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "handle", $hBitmap, "handle", $hPal, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[3]
EndFunc
Func _GDIPlus_BitmapCreateFromStream($pStream)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromStream", "ptr", $pStream, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[2]
EndFunc
Func _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap, $iARGB = 0xFF000000)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateHBITMAPFromBitmap", "handle", $hBitmap, "handle*", 0, "dword", $iARGB)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[2]
EndFunc
Func _GDIPlus_BitmapDispose($hBitmap)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_Encoders()
Local $iCount = _GDIPlus_EncodersGetCount()
Local $iSize = _GDIPlus_EncodersGetSize()
Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tCodec, $aInfo[$iCount + 1][14]
$aInfo[0][0] = $iCount
For $iI = 1 To $iCount
$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
$aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
$aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
$aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
$aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
$aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
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
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
If @error Then Return SetError(@error, @extended, -1)
If $aResult[0] Then Return SetError(10, $aResult[0], -1)
Return $aResult[1]
EndFunc
Func _GDIPlus_EncodersGetSize()
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
If @error Then Return SetError(@error, @extended, -1)
If $aResult[0] Then Return SetError(10, $aResult[0], -1)
Return $aResult[2]
EndFunc
Func _GDIPlus_ImageDispose($hImage)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hImage)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
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
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveImageToFile", "handle", $hImage, "wstr", $sFileName, "struct*", $tGUID, "struct*", $tParams)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
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
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
$__g_iGDIPToken = DllStructGetData($tToken, "Data")
If $bRetDllHandle Then Return $__g_hGDIPDll
Return SetExtended($sVer[1], True)
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
Func _GUICtrlMenu_DestroyMenu($hMenu)
Local $aResult = DllCall("user32.dll", "bool", "DestroyMenu", "handle", $hMenu)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
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
If $__WINVER >= 0x0600 Then
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
Global Const $ProgramVersion = "1.3.1.5"
Global Const $ScrW = @DesktopWidth
Global Const $ScrH = @DesktopHeight
Global Const $MinWidth = 810
Global Const $MinHeight = 450
Global Const $sEmpty = ""
Global Const $ChangelogText = _Resource_GetAsString("ChangelogText")
Local $LoadFont = _Resource_LoadFont("MainFont")
If @Error and @Compiled Then
MsgBox(0,"Error!","Critical error while loading the fonts! Code: 010")
Exit
EndIf
Local $LoadFont = _Resource_LoadFont("MenuFont")
If @Error and @Compiled Then
MsgBox(0,"Error!","Critical error while loading the fonts! Code: 011")
Exit
EndIf
Global Const $MainFontName = "Monofonto"
Global Const $MenuFontName = "Kirsty Rg"
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
Global $UpdateTimer = NULL
Global $UpdateColorState = False
Global $MainGUIHomeDiscoveryDrawn = False
Global $HoverBGDrawn = False
Global $HoverImageDrawn = False
Global $LastMousePosX, $LastMousePosY
Global $HoverTimer = TimerInit()
Global $DisplayHoverBG = 0
Global $DisplayHoverImage = 0
Global $LastHoverID = 0
Global $HoverID = 0
Global $HoverTipAlpha = 0
Global $JustTabbedBackIn = -1
Global $SupressHoverImage = False
Global $HelpIsAnimating = False
Global $MenuPopupState = False
Global $MainGUIButtonCloseBool = False
Global $MainGUIButtonMaximizeBool = False
Global $MainGUIButtonMinimizeBool = False
Global $HomeIconHoverHideBool = False
Global $RCIconHoverHideBool = False
Global $DonateIconHoverHideBool = False
Global $ChangelogIconHoverHideBool = False
Global $CopyrightIconHoverHideBool = False
Global $DebugIconHoverHideBool = False
Global $SteamBtnHoverHideBool = False
Global $EGSBtnHoverHideBool = False
Global $LegacyBtnHoverHideBool = False
Global $PayPalBtnHoverHideBool = False
Global $PatreonBtnHoverHideBool = False
Global $ViewOnlineChangesBtnHoverBool = False
Global $AnimatedLogoBool = False
Global $LicenseLabelHoverBool = False
Global $SourceLabelHoverBool = False
Global $AutoItLicenseLabelHoverBool = False
Global $MainGUIDebugLabelHoverBool = False
Global $MainGUIDebugDumpInfoHoverBool = False
Global $Version = RegRead("HKCU\Software\SMITE Optimizer\","ProgramVersion")
If @Error = 0 and $Version <= "1.2.2" Then
RegDelete("HKCU\Software\SMITE Optimizer\","BlockDonations")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPath")
RegDelete("HKCU\Software\SMITE Optimizer\","DonateInfoStatus")
RegDelete("HKCU\Software\SMITE Optimizer\","PerformUpdate")
RegDelete("HKCU\Software\SMITE Optimizer\","UpdateCheck")
RegDelete("HKCU\Software\SMITE Optimizer\","ProgramPath")
EndIf
RegWrite("HKCU\Software\SMITE Optimizer\","ProgramVersion","REG_SZ",$ProgramVersion)
If FileExists(@TempDir & "/SO_UpdatedVer.exe") Then FileDelete(@TempDir & "/SO_UpdatedVer.exe")
Global $CheckForUpdates = RegRead("HKCU\Software\SMITE Optimizer\","ConfigCheckForUpdates")
If @Error Then $CheckForUpdates = "1"
Global $SettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
If @Error Then $SettingsPath = $sEmpty
Global $SystemSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
If @Error Then $SystemSettingsPath = $sEmpty
Global $ProgramState = RegRead("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
If @Error Then $ProgramState = $sEmpty
Global $ProgramHomeState = RegRead("HKCU\Software\SMITE Optimizer\","ConfigSimpleOrAdvanced")
If @Error Then $ProgramHomeState = "Simple"
Global $ConfigBackupPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigBackupPath")
If @Error Then $ConfigBackupPath = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders","Personal")&"\My Games\SMITE\Backups\"
Global $ProgramHomeHelpState = RegRead("HKCU\Software\SMITE Optimizer\","ConfigShowHints")
If @Error Then $ProgramHomeHelpState = 1
If($SettingsPath <> $sEmpty and $SystemSettingsPath <> $sEmpty) and(not FileExists($SettingsPath) or not FileExists($SystemSettingsPath)) Then
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
$SettingsPath = $sEmpty
$SystemSettingsPath = $sEmpty
$ProgramState = $sEmpty
MsgBox($MB_OK,"Error","Could not find file(s) at the saved location(s)"&@CRLF&"You will have to tell the program where to find them again.")
EndIf
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
Local $WorkingSize = _GetDesktopWorkArea($GLOBAL_MAIN_GUI)
Local $aWinPos = WinGetPos($GLOBAL_MAIN_GUI)
_WinAPI_SetWindowPos($GLOBAL_MAIN_GUI,$HWND_TOP,$aWinPos[0]-1,$aWinPos[1]-1,$WorkingSize[2],$WorkingSize[3],$SWP_NOREDRAW)
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize2NoActivate.jpg","Maximize2NoActivate")
$MainGUIMaximizedState = True
EndIf
EndFunc
Func INTERNAL_WM_GETMINMAXINFO($hWnd,$iMsg,$wParam,$lParam)
Local $tMinMaxInfo = DllStructCreate("int;int;int;int;int;int;int;int;int;dword",$lParam)
Local $WorkingSize = _GetDesktopWorkArea($GLOBAL_MAIN_GUI)
DllStructSetData($tMinMaxInfo,3,$WorkingSize[2])
DllStructSetData($tMinMaxInfo,4,$WorkingSize[3])
DllStructSetData($tMinMaxInfo,5,$WorkingSize[0]+1)
DllStructSetData($tMinMaxInfo,6,$WorkingSize[1]+1)
DllStructSetData($tMinMaxInfo,7,$Win_Min_ResizeX)
DllStructSetData($tMinMaxInfo,8,$Win_Min_ResizeY)
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
If $hWnd = $GLOBAL_MAIN_GUI and WinGetState($GLOBAL_MAIN_GUI) <> 47 Then
Local $aCurInfo = GUIGetCursorInfo($GLOBAL_MAIN_GUI)
If $aCurInfo[4] = $MainGUITitleBarBG or $aCurInfo[4] = $GUIMoreOptionsTitleBarBG Then
DllCall("user32.dll","int","ReleaseCapture")
DllCall("user32.dll","long","SendMessage","hwnd",$GLOBAL_MAIN_GUI,"int",0x00A1,"int",2,"int",0)
EndIf
EndIf
EndFunc
Func _GetDesktopWorkArea($hWnd)
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
If $TaskBarPos[0] = $MonitorList[$MonitorNumber][1] - 2 Or $TaskBarPos[1] = $MonitorList[$MonitorNumber][2] - 2 Then
$TaskBarPos[0] = $TaskBarPos[0] + 2
$TaskBarPos[1] = $TaskBarPos[1] + 2
$TaskBarPos[2] = $TaskBarPos[2] - 4
$TaskBarPos[3] = $TaskBarPos[3] - 4
EndIf
If $TaskBarPos[0] = $MonitorList[$MonitorNumber][1] - 2 Or $TaskBarPos[1] = $MonitorList[$MonitorNumber][2] - 2 Then
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
Func ProperExit()
If IsDeclared("IndexerPID") Then ProcessClose($IndexerPID)
If FileExists(@TempDir & "\SO_Index.bat") Then FileDelete(@TempDir & "\SO_Index.bat")
If FileExists(@TempDir & "\SO_Index.txt") Then FileDelete(@TempDir & "\SO_Index.txt")
If FileExists(@TempDir & "\GPL_License.txt") Then FileDelete(@TempDir & "\GPL_License.txt")
If FileExists(@TempDir & "\AutoIt_License.txt") Then FileDelete(@TempDir & "\AutoIt_License.txt")
Exit
EndFunc
Global $SplashScreenGUI = GUICreate($ProgramName,600,125,-1,-1,$WS_POPUP)
GUICtrlSetBkColor(-1,0x00)
Global $SplashScreenGUIAnimation
If @Compiled Then
$SplashScreenGUIAnimation = _GUICtrlCreateGIF(@AutoItExe,"RES;SO_LogoGIF",0,0,600,100)
Else
$SplashScreenGUIAnimation = _GUICtrlCreateGIF($MainResourcePath & "SO_Logo.gif","",0,0,600,100)
EndIf
Global $SplashScreenGUIProgress = GUiCtrlCreateProgress(0,100,600,25)
GUICtrlSetColor(-1, 0xFF0000)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",$sEmpty,"wstr",$sEmpty)
Global $SplashScreenGUILabelStatusBG = GUICtrlCreateLabelTransparentBG("Loading..",1,106,600,20,$SS_CENTER)
Global $SplashScreenGUILabelStatus = GUICtrlCreateLabelTransparentBG("Loading..",0,105,600,20,$SS_CENTER)
GUICtrlSetColor(-1,0xFFC3C3)
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
Local $UpdateGet = _INetGetSource("https://meteorthelizard.github.io/SMITE-Optimizer-Update/index.html",True)
If @Error Then $UpdateGet = _INetGetSource("https://pastebin.com/raw/SXnHTU9H",True)
If @Error Then
MsgBox($MB_OK,"Error","Could not connect to the Update Servers.")
WinActivate($SplashScreenGUI)
Else
Local $RemoteVersion = _IniMem_Read($UpdateGet,"Version","Version",$ProgramVersion)
Local $RemoteDownload32 = _IniMem_Read($UpdateGet,"Download","Download32","")
Local $RemoteDownload64 = _IniMem_Read($UpdateGet,"Download","Download64","")
Local $RemoteMessage = _IniMem_Read($UpdateGet,"Message","Message","")
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
RegDelete("HKCU\Software\SMITE Optimizer\","DebugForceUpdate")
SplashScreenWriteStatus(0,"Downloading Update (0%)")
Local $NewFileSize, $NewFile
If @AutoItX64 = 1 Then
$NewFileSize = INetGetSize($RemoteDownload64,@TempDir & "/SO_UpdatedVer.exe")
$NewFile = INetGet($RemoteDownload64,@TempDir & "/SO_UpdatedVer.exe",BitOr($INET_FORCERELOAD,$INET_IGNORESSL),$INET_DOWNLOADBACKGROUND)
Else
$NewFileSize = INetGetSize($RemoteDownload32,@TempDir & "/SO_UpdatedVer.exe")
$NewFile = INetGet($RemoteDownload32,@TempDir & "/SO_UpdatedVer.exe",BitOr($INET_FORCERELOAD,$INET_IGNORESSL),$INET_DOWNLOADBACKGROUND)
EndIf
Local $TotalSize = Round($NewFileSize / 1024)
Local $LastPercent = 0
Do
Local $Bytes = Round(INetGetInfo($NewFile,0))
Local $Percent = Round($TotalSize / $NewFileSize * 100000)
If $Percent <> $LastPercent Then
SplashScreenWriteStatus(0,"Downloading Update ("&$Percent&"%)")
$LastPercent = $Percent
EndIf
Sleep(10)
Until INetGetInfo($NewFile,2)
If FileExists(@TempDir & "/SO_UpdatedVer.exe") Then
FileWrite(@TempDir & "\SO_Update.bat","CHCP 65001"&@CRLF&"@echo off"&@CRLF&"Cls"&@CRLF&"timeout /t 0.5 /nobreak"&@CRLF&'del "'&@ScriptFullPath&'" /f /q'&@CRLF&'copy /Y "'&@TempDir & '\SO_UpdatedVer.exe"'&' "'&@ScriptFullPath&'" >nul'&@CRLF&'start "" "'&@ScriptFullPath&'"'&@CRLF&'del "'&@TempDir & "\SO_Update.bat"&'" /f /q'&@CRLF&"Exit")
If FileExists(@TempDir & "\SO_Update.bat") Then
Run(@TempDir & "\SO_Update.bat",$sEmpty,@SW_HIDE)
Exit
Else
MsgBox($MB_OK,"Error","There was an unexpected error during the update process. Code: 007"&@CRLF&"If this error is persistent, please try and update manually.")
WinActivate($SplashScreenGUI)
EndIf
Else
MsgBox($MB_OK,"Error","There was an unexpected error during the update process. Code: 006"&@CRLF&"If this error is persistent, please try and update manually.")
WinActivate($SplashScreenGUI)
EndIf
EndIf
EndIf
EndIf
Global Const $EngineSettingsClearHive[107][181] = [ ['[URL]','Protocol=unreal','Name=Player','Map=lobbymap','LocalMap=lobbymap','LocalOptions=','TransitionMap=Entry','MapExt=tgm','EXEName=unreal.exe','DebugEXEName=DEBUG-unreal.exe','SaveExt=usa','Port=7000','PeerPort=7778','GameName=Smite','GameNameShort=Smite','MenuLevel=lobbymap'], ['[Engine.ScriptPackages]','EngineNativePackages=Core','EngineNativePackages=Engine','EngineNativePackages=GFxUI','EngineNativePackages=IpDrv','EngineNativePackages=GameFramework','NetNativePackages=IpDrv','NetNativePackages=WinDrv','EditorPackages=UnrealEd','ScaleformEditorPackages=GFxUIEditor','EngineNativePackages=PlatformCommon','EngineNativePackages=TgGame','NativePackages=TgClientBase','NativePackages=TgClient','NativePackages=BattleGame','NativePackages=BattleClient','EditorPackages=TgEditor','EditorPackages=BattleEditor','NonNativePackages=TgGameContent','EngineNativePackages=Vivox'], _
['[Engine.Engine]','NetworkDevice=PlatformCommon.PComNetDriver','FallbackNetworkDevice=IpDrv.TcpNetDriver','ConsoleClassName=Engine.Console','GameViewportClientClassName=TgClient.TgGameViewportClient','LocalPlayerClassName=Engine.LocalPlayer','DataStoreClientClassName=Engine.DataStoreClient','Language=INT','bAllowMatureLanguage=False','GameEngine=TgGame.TgGameEngine','EditorEngine=TgEditor.TgEditorEngine','UnrealEdEngine=TgEditor.TgEditorEngine','Client=WinDrv.WindowsClient','Render=Render.Render','Input=Engine.Input','Canvas=Engine.Canvas','TinyFontName=EngineFonts.TinyFont','SmallFontName=EngineFonts.SmallFont','MediumFontName=EngineFonts.SmallFont','LargeFontName=EngineFonts.SmallFont','SubtitleFontName=EngineFonts.SmallFont','WireframeMaterialName=EngineDebugMaterials.WireframeMaterial','DefaultMaterialName=EngineMaterials.DefaultMaterial','DefaultDecalMaterialName=EngineMaterials.DefaultDecalMaterial','DefaultTextureName=EngineMaterials.DefaultDiffuse','EmissiveTexturedMaterialName=EngineMaterials.EmissiveTexturedMaterial','GeomMaterialName=EngineDebugMaterials.GeomMaterial','DefaultFogVolumeMaterialName=EngineMaterials.FogVolumeMaterial','TickMaterialName=EditorMaterials.Tick_Mat','CrossMaterialName=EditorMaterials.Cross_Mat','DefaultUICaretMaterialName=EngineMaterials.BlinkingCaret','SceneCaptureReflectActorMaterialName=EngineMaterials.ScreenMaterial','SceneCaptureCubeActorMaterialName=EngineMaterials.CubeMaterial','ScreenDoorNoiseTextureName=EngineMaterials.Good64x64TilingNoiseHighFreq','ImageGrainNoiseTextureName=EngineMaterials.Good64x64TilingNoiseHighFreq','RandomAngleTextureName=EngineMaterials.RandomAngles','RandomNormalTextureName=EngineMaterials.RandomNormal2','RandomMirrorDiscTextureName=EngineMaterials.RandomMirrorDisc','WeightMapPlaceholderTextureName=EngineMaterials.WeightMapPlaceholderTexture','LightMapDensityTextureName=EngineMaterials.DefaultWhiteGrid','LightMapDensityNormalName=EngineMaterials.DefaultNormal','LevelColorationLitMaterialName=EngineDebugMaterials.LevelColorationLitMaterial','LevelColorationUnlitMaterialName=EngineDebugMaterials.LevelColorationUnlitMaterial','LightingTexelDensityName=EngineDebugMaterials.MAT_LevelColorationLitLightmapUVs','ShadedLevelColorationUnlitMaterialName=EngineDebugMaterials.ShadedLevelColorationUnlitMaterial','ShadedLevelColorationLitMaterialName=EngineDebugMaterials.ShadedLevelColorationLitMaterial','RemoveSurfaceMaterialName=EngineMaterials.RemoveSurfaceMaterial','VertexColorMaterialName=EngineDebugMaterials.VertexColorMaterial','VertexColorViewModeMaterialName_ColorOnly=EngineDebugMaterials.VertexColorViewMode_ColorOnly','VertexColorViewModeMaterialName_AlphaAsColor=EngineDebugMaterials.VertexColorViewMode_AlphaAsColor','VertexColorViewModeMaterialName_RedOnly=EngineDebugMaterials.VertexColorViewMode_RedOnly','VertexColorViewModeMaterialName_GreenOnly=EngineDebugMaterials.VertexColorViewMode_GreenOnly','VertexColorViewModeMaterialName_BlueOnly=EngineDebugMaterials.VertexColorViewMode_BlueOnly','HeatmapMaterialName=EngineDebugMaterials.HeatmapMaterial','BoneWeightMaterialName=EngineDebugMaterials.BoneWeightMaterial','TangentColorMaterialName=EngineDebugMaterials.TangentColorMaterial','MobileEmulationMasterMaterialName=MobileEngineMaterials.MobileMasterMaterial','EditorBrushMaterialName=EngineMaterials.EditorBrushMaterial','DefaultPhysMaterialName=EngineMaterials.DefaultPhysicalMaterial','LandscapeHolePhysMaterialName=EngineMaterials.LandscapeHolePhysicalMaterial','TextureStreamingBoundsMaterialName=EditorMaterials.Utilities.TextureStreamingBounds_MATInst','TerrainErrorMaterialName=EngineDebugMaterials.MaterialError_Mat','ProcBuildingSimpleMaterialName=EngineBuildings.ProcBuildingSimpleMaterial','BuildingQuadStaticMeshName=EngineBuildings.BuildingQuadMesh','ProcBuildingLODColorTexelsPerWorldUnit=0.075','ProcBuildingLODLightingTexelsPerWorldUnit=0.015','MaxProcBuildingLODColorTextureSize=1024','MaxProcBuildingLODLightingTextureSize=256','UseProcBuildingLODTextureCropping=True','ForcePowerOfTwoProcBuildingLODTextures=True','bCombineSimilarMappings=False', _
'MaxRMSDForCombiningMappings=6.0','ImageReflectionTextureSize=1024','TerrainMaterialMaxTextureCount=16','TerrainTessellationCheckCount=6','TerrainTessellationCheckBorder=2.0','TerrainTessellationCheckDistance=4096.0','BeginUPTryCount=200000','bStaticDecalsEnabled=True','bDynamicDecalsEnabled=True','bForceStaticTerrain=False','LightingOnlyBrightness=(R=0.3,G=0.3,B=0.3,A=1.0)','LightComplexityColors=(R=0,G=0,B=0,A=1)','LightComplexityColors=(R=0,G=255,B=0,A=1)','LightComplexityColors=(R=63,G=191,B=0,A=1)','LightComplexityColors=(R=127,G=127,B=0,A=1)','LightComplexityColors=(R=191,G=63,B=0,A=1)','LightComplexityColors=(B=0,G=0,R=255,A=1)','ShaderComplexityColors=(R=0.0,G=1.0,B=0.127,A=1.0)','ShaderComplexityColors=(R=0.0,G=1.0,B=0.0,A=1.0)','ShaderComplexityColors=(R=0.046,G=0.52,B=0.0,A=1.0)','ShaderComplexityColors=(R=0.215,G=0.215,B=0.0,A=1.0)','ShaderComplexityColors=(R=0.52,G=0.046,B=0.0,A=1.0)','ShaderComplexityColors=(R=0.7,G=0.0,B=0.0,A=1.0)','ShaderComplexityColors=(R=1.0,G=0.0,B=0.0,A=1.0)','ShaderComplexityColors=(R=1.0,G=0.0,B=0.5,A=1.0)','ShaderComplexityColors=(R=1.0,G=0.9,B=0.9,A=1.0)','MaxPixelShaderAdditiveComplexityCount=900','TimeBetweenPurgingPendingKillObjects=30.000000','MaxTimeBetweenPurgingPendingKillObjects=30.000000','GarbageCollectionDelayMinimumMemoryMB=512','bUseTextureStreaming=True','bUseBackgroundLevelStreaming=True','bSubtitlesEnabled=True','bSubtitlesForcedOff=False','ScoutClassName=TgGame.TgAIScout','DefaultPostProcessName=TgPostProcess.PostProcess.PP_Hit','DefaultUIScenePostProcessName=EngineMaterials.DefaultUIPostProcess','ThumbnailSkeletalMeshPostProcessName=EngineMaterials.DefaultThumbnailPostProcess','ThumbnailParticleSystemPostProcessName=EngineMaterials.DefaultThumbnailPostProcess','ThumbnailMaterialPostProcessName=EngineMaterials.DefaultThumbnailPostProcess','DefaultSoundName=EngineSounds.WhiteNoise','bOnScreenKismetWarnings=False','bEnableKismetLogging=False','bUseRecastNavMesh=True','bAllowDebugViewmodesOnConsoles=False','CameraRotationThreshold=45.0','CameraTranslationThreshold=10000','PrimitiveProbablyVisibleTime=8.0','PercentUnoccludedRequeries=0.125','MaxOcclusionPixelsFraction=0.1','MinTextureDensity=0.0','IdealTextureDensity=13.0','MaxTextureDensity=55.0','MinLightMapDensity=0.0','IdealLightMapDensity=0.05','MaxLightMapDensity=0.2','RenderLightMapDensityGrayscaleScale=1.0','RenderLightMapDensityColorScale=1.0','bRenderLightMapDensityGrayscale=False','LightMapDensityVertexMappedColor=(R=0.65,G=0.65,B=0.25,A=1.0)','LightMapDensitySelectedColor=(R=1.0,G=0.2,B=1.0,A=1.0)','bDisablePhysXHardwareSupport=True','DemoRecordingDevice=Engine.DemoRecDriver','bPauseOnLossOfFocus=False','MaxFluidNumVerts=1048576','FluidSimulationTimeLimit=30.0','MaxParticleResize=1024','MaxParticleResizeWarn=10240','bCheckParticleRenderSize=True','MaxParticleVertexMemory=131972','NetClientTicksPerSecond=200','MaxTrackedOcclusionIncrement=0.10','TrackedOcclusionStepSize=0.10','MipFadeInSpeed0=0.3','MipFadeOutSpeed0=0.1','MipFadeInSpeed1=2.0','MipFadeOutSpeed1=1.0','StatColorMappings=(StatName="AverageFPS",ColorMap=((In=15.0,Out=(R=255)),(In=30,Out=(R=255,G=255)),(In=45.0,Out=(G=255))))','StatColorMappings=(StatName="Frametime",ColorMap=((In=1.0,Out=(G=255)),(In=25.0,Out=(G=255)),(In=29.0,Out=(R=255,G=255)),(In=33.0,Out=(R=255))))','StatColorMappings=(StatName="Streaming fudge factor",ColorMap=((In=0.0,Out=(G=255)),(In=1.0,Out=(G=255)),(In=2.5,Out=(R=255,G=255)),(In=5.0,Out=(R=255)),(In=10.0,Out=(R=255))))','PhysXGpuHeapSize=32','PhysXMeshCacheSize=8','bShouldGenerateSimpleLightmaps=False','bUseNormalMapsForSimpleLightMaps=True','bSmoothFrameRate=True','MinSmoothedFrameRate=22','MaxSmoothedFrameRate=62','bCheckForMultiplePawnsSpawnedInAFrame=False','NumPawnsAllowedToBeSpawnedInAFrame=2','DefaultSelectedMaterialColor=(R=0.04,G=0.02,B=0.24,A=1.0)','DefaultHoveredMaterialColor=(R=0.02,G=0.02,B=0.02,A=1.0)','bEnableOnScreenDebugMessages=False','AllowScreenDoorFade=True','AllowScreenDoorLODFading=False','AllowNvidiaStereo3d=False','EnableMatineePostProcessMaterialParam=False', _
'IgnoreSimulatedFuncWarnings=Tick','NearClipPlane=10.0','bUseStreamingPause=False','bKeepAllMaterialQualityLevelsLoaded=False','bAllowTimeLapseDriver=False','bUsePostProcessEffects=False','bRenderTerrainCollisionAsOverlay=False','TimeAsyncLoadingBlocksGarbageCollection=10.000000','AllowShadowVolumes=True','bEnableColorClear=False','UseStreaming=True','PeerNetworkDevice=PlatformCommon.PComNetDriver','bSuppressMapWarnings=True','bUseDestColorFix=True'], ['[PlatformInterface]','CloudStorageInterfaceClassName=','FacebookIntegrationClassName=','InGameAdManagerClassName='], ['[Engine.StreamingMovies]','RenderPriorityPS3=1001','SuspendGameIO=True'], ['[Engine.ISVHacks]','bInitializeShadersOnDemand=False','DisableATITextureFilterOptimizationChecks=True','UseMinimalNVIDIADriverShaderOptimization=True','PumpWindowMessagesWhenRenderThreadStalled=False'], ['[Engine.GameEngine]','MaxDeltaTime=0','bSmoothFrameRate=True','MinSmoothedFrameRate=22.000000','MaxSmoothedFrameRate=150.000000','bClearAnimSetLinkupCachesOnLoadMap=True','LocalPlayerClassName=TgGame.TgLocalPlayer','bUseSound=True','bUseTextureStreaming=True','bUseBackgroundLevelStreaming=True','bSubtitlesEnabled=True','bSubtitlesForcedOff=False','bForceStaticTerrain=False','bForceCPUSkinning=False','bUsePostProcessEffects=True','bOnScreenKismetWarnings=True','bEnableKismetLogging=False','bAllowMatureLanguage=False','bEnableVSMShadows=False','bEnableBranchingPCFShadows=False','bRenderTerrainCollisionAsOverlay=False','bDisablePhysXHardwareSupport=True','bPauseOnLossOfFocus=False','DefaultPostProcessName=TgPostProcess.PostProcess.PP_Hit','ThumbnailSkeletalMeshPostProcessName=EngineMaterials.DefaultThumbnailPostProcess','ThumbnailParticleSystemPostProcessName=EngineMaterials.DefaultThumbnailPostProcess','ThumbnailMaterialPostProcessName=EngineMaterials.DefaultThumbnailPostProcess','DefaultUIScenePostProcessName=EngineMaterials.DefaultUIPostProcess','TimeBetweenPurgingPendingKillObjects=30.000000','TimeAsyncLoadingBlocksGarbageCollection=10.000000','MaxTimeBetweenPurgingPendingKillObjects=30.000000','ScoutClassName=Engine.Scout','ShadowFilterRadius=2.000000','DepthBias=0.012000','ModShadowFadeDistanceExponent=0.200000','CameraRotationThreshold=45.000000','CameraTranslationThreshold=1600.000000','PrimitiveProbablyVisibleTime=8.000000','PercentUnoccludedRequeries=0.125000','ShadowVolumeLightRadiusThreshold=1000.000000','ShadowVolumePrimitiveScreenSpacePercentageThreshold=0.250000','MaxParticleResize=1024','MaxParticleResizeWarn=10240','BeginUPTryCount=200000'], ['[Engine.DemoRecDriver]','AllowDownloads=True','DemoSpectatorClass=TgGame.TgDemoRecSpectator','MaxClientRate=25000','ConnectionTimeout=15.0','InitialConnectTimeout=30.0','AckTimeout=1.0','KeepAliveTime=1.0','SimLatency=0','RelevantTimeout=5.0','SpawnPrioritySeconds=1.0','ServerTravelPause=4.0','NetServerMaxTickRate=27','LanServerMaxTickRate=30','MaxRewindPoints=400','RewindPointInterval=30.0','NumRecentRewindPoints=120','ProtectedRewindPointInterval=1800','MaxEventPoints=0','EventPointInterval=3.0','MinEventBuffer=3.0'], ['[Engine.StartupPackages]','bSerializeStartupPackagesFromMemory=True','bFullyCompressStartupPackages=False','Package=EngineMaterials','Package=EngineDebugMaterials','Package=EngineSounds','Package=EngineFonts','Package=TgSoundModes','Package=GOD_CommonAssets','Package=FX_GEN','Package=FX_GEN_Fire','Package=FX_GEN_Diamond','Package=FX_Common','Package=MDL_PseudoMesh','Package=AUD_UI','Package=TgPostProcess','Package=SoundClassesAndModes'], ['[Engine.PackagesToForceCookPerMap]','Map=Conquest_P_S6','Package=FX_GC_S6','Map=CH11_P','Package=FX_AD11_General','Package=AUD_UI.Ability'], _
['[Core.System]','MaxObjectsNotConsideredByGC=60000','SizeOfPermanentObjectPool=0','StaleCacheDays=30','MaxStaleCacheSize=10','MaxOverallCacheSize=30','PackageSizeSoftLimit=800','AsyncIOBandwidthLimit=0','CachePath=..\Cache','CacheExt=.uxx','Paths=..\..\Engine\Content','ScriptPaths=..\..\BattleGame\Script','FRScriptPaths=..\..\BattleGame\Script','CutdownPaths=..\..\BattleGame\CutdownPackages','CutdownPaths=..\..\BattleGame\Script','ScreenShotPath=..\..\BattleGame\ScreenShots','LocalizationPaths=..\..\Engine\Localization','Extensions=upk','Extensions=u','Extensions=umap','SaveLocalizedCookedPackagesInSubdirectories=False','TextureFileCacheExtension=tfc','bDisablePromptToRebuildScripts=False','Suppress=Dev','Suppress=DevAbsorbFuncs','Suppress=DevAnim','Suppress=DevAssetDataBase','Suppress=DevAudio','Suppress=DevAudioVerbose','Suppress=DevBind','Suppress=DevBsp','Suppress=DevCamera','Suppress=DevCollision','Suppress=DevCompile','Suppress=DevComponents','Suppress=DevConfig','Suppress=DevCooking','Suppress=DevCrossLevel','Suppress=DevDataStore','Suppress=DevDecals','Suppress=DevFaceFX','Suppress=DevGFxUI','Suppress=DevGFxUIWarning','Suppress=DevGarbage','Suppress=DevKill','Suppress=DevLevelTools','Suppress=DevLightmassSolver','Suppress=DevLoad','Suppress=DevMovie','Suppress=DevNavMesh','Suppress=DevNavMeshWarning','Suppress=DevNetTraffic','Suppress=DevNetTrafficDetail','Suppress=DevOnline','Suppress=DevPath','Suppress=DevReplace','Suppress=DevSHA','Suppress=DevSave','Suppress=DevShaders','Suppress=DevShadersDetailed','Suppress=DevSound','Suppress=DevStats','Suppress=DevStreaming','Suppress=DevTick','Suppress=DevUI','Suppress=DevUIAnimation','Suppress=DevUIFocus','Suppress=DevUIStates','Suppress=DevUIStyles','Suppress=DevMCP','Suppress=DevHTTP','Suppress=DevHttpRequest','Suppress=DevBeacon','Suppress=DevBeaconGame','Suppress=DevOnlineGame','Suppress=DevMatchmaking','Suppress=DevMovieCapture','Suppress=GameStats','Suppress=Init','Suppress=Input','Suppress=Inventory','Suppress=Localization','Suppress=LocalizationWarning','Suppress=PlayerManagement','Suppress=PlayerMove','Suppress=DevReplication','Suppress=TgDevGFxUIVerbose','Suppress=AILog','Extensions=tgm','PurgeCacheDays=30','SavePath=..\..\BattleGame\Save','SeekFreePCPaths=..\..\BattleGame\CookedPC','SeekFreePCExtensions=upk','SeekFreePCExtensions=tgm','SeekFreePCExtensions=u','Paths=..\..\BattleGame\Content','Paths=..\..\BattleGame\GUI\Shared','Paths=..\..\BattleGame\GUI\PC','Paths=..\..\BattleGame\Script','Paths=..\..\BattleGame\__Trashcan','CutdownPaths=..\..\Engine\Content','BakeMapPaths=..\..\BattleGame\Content','BakeMapPaths=..\..\BattleGame\Baked','RunBakedPaths=..\..\BattleGame\Baked','LocalizationPaths=..\..\BattleGame\Localization'], ['[Engine.Client]','DisplayGamma=2.2','MinDesiredFrameRate=35.000000','InitialButtonRepeatDelay=0.2','ButtonRepeatDelay=0.1'], ['[WinDrv.WindowsClient]','AudioDeviceClass=XAudio2.XAudio2Device','MinAllowableResolutionX=800','MinAllowableResolutionY=600','MaxAllowableResolutionX=0','MaxAllowableResolutionY=0','MinAllowableRefreshRate=0','MaxAllowableRefreshRate=0','ParanoidDeviceLostChecking=1','AllowJoystickInput=1'], ['[WinDrv.HttpRequestWindowsMcp]','AppID=UDK','AppSecret=Your_app_secret_here'], ['[XAudio2.XAudio2Device]','MaxChannels=32','CommonAudioPoolSize=0','MinCompressedDurationGame=1.5','MinCompressedDurationEditor=4','LowPassFilterResonance=0.9','DefaultAudioDevice='], ['[ALAudio.ALAudioDevice]','MaxChannels=32','CommonAudioPoolSize=0','MinCompressedDurationGame=5','MinCompressedDurationEditor=4','LowPassFilterResonance=0.9','UseEffectsProcessing=True','TimeBetweenHWUpdates=15','MinOggVorbisDurationGame=5','MinOggVorbisDurationEditor=4','DeviceName=Generic Software'], ['[CoreAudio.CoreAudioDevice]','MaxChannels=32','CommonAudioPoolSize=0','MinCompressedDurationGame=5','MinCompressedDurationEditor=4','LowPassFilterResonance=0.9'], ['[Engine.Player]','ConfiguredInternetSpeed=25000','ConfiguredLanSpeed=25000','PP_DesaturationMultiplier=1.0','PP_HighlightsMultiplier=1.0','PP_MidTonesMultiplier=1.0','PP_ShadowsMultiplier=1.0'], _
['[IpDrv.TcpNetDriver]','AllowDownloads=False','AllowPeerConnections=False','AllowPeerVoice=False','ConnectionTimeout=25.0','InitialConnectTimeout=500.0','LoadingConnectionTimeout=200.0','AckTimeout=1.0','KeepAliveTime=0.2','MaxClientRate=24000','MaxInternetClientRate=24000','RelevantTimeout=5.0','SpawnPrioritySeconds=1.0','ServerTravelPause=4.0','NetServerMaxTickRate=27','LanServerMaxTickRate=35','DownloadManagers=IpDrv.HTTPDownload','DownloadManagers=Engine.ChannelDownload','NetConnectionClassName=PlatformCommon.PComNetConn','InitialHandshakeTimeout=45.0','P2PConnectionTimeout=10.0','PeerNetConnectionClassName=PlatformCommon.PComNetConn'], ['[OnlineSubsystemSteamworks.IpNetDriverSteamworks]','NetConnectionClassName=OnlineSubsystemSteamworks.IpNetConnectionSteamworks','bSteamSocketsOnly=False'], ['[IpServer.UdpServerQuery]','GameName=ut'], ['[IpDrv.UdpBeacon]','DoBeacon=True','BeaconTime=0.50','BeaconTimeout=5.0','BeaconProduct=ut','ServerBeaconPort=8777','BeaconPort=9777'], ['[TextureStreaming]','MinTextureResidentMipCount=7','PoolSize=158','MemoryMargin=20','MemoryLoss=0','HysteresisLimit=20','DropMipLevelsLimit=16','StopIncreasingLimit=12','StopStreamingLimit=8','MinEvictSize=10','MinFudgeFactor=0.5','FudgeFactorIncreaseRateOfChange=0.5','FudgeFactorDecreaseRateOfChange=-0.4','MinRequestedMipsToConsider=11','MinTimeToGuaranteeMinMipCount=2','MaxTimeToGuaranteeMinMipCount=12','UseTextureFileCache=False','LoadMapTimeLimit=20.0','LightmapStreamingFactor=0.04','ShadowmapStreamingFactor=0.04','MaxLightmapRadius=2000.0','AllowStreamingLightmaps=True','TextureFileCacheBulkDataAlignment=1','UsePriorityStreaming=True','bAllowSwitchingStreamingSystem=False','UseDynamicStreaming=True','bEnableAsyncDefrag=False','bEnableAsyncReallocation=False','MaxDefragRelocations=256','MaxDefragDownShift=128','BoostPlayerTextures=3.0','TemporalAAMemoryReserve=4.0','MenuLevelPoolBoost=60'], ['[StreamByURL]','PostLoadPause=6.0'], _
['[UnrealEd.EditorEngine]','LocalPlayerClassName=TgEditor.TgEditorPlayer','bSubtitlesEnabled=True','GridEnabled=True','SnapScaleEnabled=True','ScaleGridSize=5','SnapVertices=False','SnapDistance=10.000000','GridSize=(X=16.000000,Y=16.000000,Z=16.000000)','RotGridEnabled=True','RotGridSize=(Pitch=1024,Yaw=1024,Roll=1024)','GameCommandLine=-log','FOVAngle=90.000000','GodMode=True','AutoSaveDir=..\..\BattleGame\Content\Autosaves','InvertwidgetZAxis=True','UseAxisIndicator=True','MatineeCurveDetail=0.1','Client=WinDrv.WindowsClient','CurrentGridSz=4','bUseMayaCameraControls=True','bPrefabsLocked=True','HeightMapExportClassName=TerrainHeightMapExporterTextT3D','EditorOnlyContentPackages=EditorMeshes','EditorOnlyContentPackages=EditorMaterials','EditorOnlyContentPackages=EditorResources','EditorOnlyContentPackages=EditorLandscapeResources','EditorOnlyContentPackages=EditorShellMaterials','EditorOnlyContentPackages=MobileEngineMaterials','EditPackagesInPath=..\..\Development\Src','EditPackages=Core','EditPackages=Engine','EditPackages=IpDrv','EditPackages=GFxUI','EditPackages=AkAudio','EditPackages=GameFramework','EditPackages=UnrealEd','EditPackages=GFxUIEditor','EditPackages=WinDrv','EditPackages=OnlineSubsystemPC','EditPackages=OnlineSubsystemSteamworks','EditPackages=OnlineSubsystemDiscord','EditPackages=OnlineSubsystemEpic','EditPackages=OnlineSubsystemDingo','EditPackages=OnlineSubsystemNP','EditPackages=OnlineSubsystemNintendo','bBuildReachSpecs=False','bGroupingActive=True','bCustomCameraAlignEmitter=True','CustomCameraAlignEmitterDistance=100.0','bDrawSocketsInGMode=False','bSmoothFrameRate=False','MinSmoothedFrameRate=5','MaxSmoothedFrameRate=120','FarClippingPlane=0','TemplateMapFolders=..\..\Engine\Content\Maps\Templates','UseOldStyleMICEditorGroups=True','EditPackagesOutPath=..\..\BattleGame\Script','FRScriptOutputPath=..\..\BattleGame\Script','GFxImportDirectory=Flash','GFxImportSaveDirectory=GUI\PC\GFx\','EditPackages=PlatformCommon','EditPackages=TgGame','EditPackages=TgClientBase','EditPackages=TgClient','EditPackages=TgEditor','EditPackages=BattleGame','EditPackages=BattleClient','EditPackages=BattleEditor','EditPackages=TgGameContent','EditPackages=Vivox','InEditorGameURLOptions=?quickstart=1?numplay=1?Team=1?ReloadAssemblyFile=0?RunDBExport=0?RunBehaviorExport=0?Platform=PC','bOnScreenKismetWarnings=True'], ['[UnrealEd.UnrealEdEngine]','AutoSaveIndex=0','PackagesToBeFullyLoadedAtStartup=EditorMaterials','PackagesToBeFullyLoadedAtStartup=EditorMeshes','PackagesToBeFullyLoadedAtStartup=EditorResources','PackagesToBeFullyLoadedAtStartup=EngineMaterials','PackagesToBeFullyLoadedAtStartup=EngineFonts','PackagesToBeFullyLoadedAtStartup=EngineResources','PackagesToBeFullyLoadedAtStartup=Engine_MI_Shaders','PackagesToBeFullyLoadedAtStartup=MapTemplateIndex'], ['[Engine.DataStoreClient]','GlobalDataStoreClasses=Engine.UIDataStore_GameResource','GlobalDataStoreClasses=Engine.UIDataStore_Fonts','GlobalDataStoreClasses=Engine.UIDataStore_Registry','GlobalDataStoreClasses=Engine.UIDataStore_InputAlias'], ['[DevOptions.Shaders]','AutoReloadChangedShaders=True','bAllowMultiThreadedShaderCompile=True','bAllowDistributedShaderCompile=False','bAllowDistributedShaderCompileForBuildPCS=False','NumUnusedShaderCompilingThreads=1','ThreadedShaderCompileThreshold=1','MaxShaderJobBatchSize=30','PrecompileShadersJobThreshold=40000','bDumpShaderPDBs=False','bPromptToRetryFailedShaderCompiles=True'], ['[DevOptions.Debug]','ShowSelectedLightmap=False'], ['[StatNotifyProviders]','BinaryFileStatNotifyProvider=True','XmlStatNotifyProvider=False','CsvStatNotifyProvider=False','StatsNotifyProvider_UDP=True','PIXNamedCounterProvider=False','StatsNotifyProvider_Windows=False'], ['[StatNotifyProviders.StatNotifyProvider_UDP]','ListenPort=13000'], ['[RemoteControl]','SuppressRemoteControlAtStartup=False'], ['[LogFiles]','PurgeLogsDays=14','LogTimes=True'], _
['[AnimationCompression]','CompressCommandletVersion=3','DefaultCompressionAlgorithm=AnimationCompressionAlgorithm_RemoveLinearKeys','TranslationCompressionFormat=0','RotationCompressionFormat=1','AlternativeCompressionThreshold=1.f','ForceRecompression=False','bOnlyCheckForMissingSkeletalMeshes=False','KeyEndEffectorsMatchName=IK','KeyEndEffectorsMatchName=eye','KeyEndEffectorsMatchName=weapon','KeyEndEffectorsMatchName=hand','KeyEndEffectorsMatchName=attach','KeyEndEffectorsMatchName=camera'], ['[IpDrv.OnlineSubsystemCommonImpl]','MaxLocalTalkers=1','MaxRemoteTalkers=16','bIsUsingSpeechRecognition=False'], ['[IpDrv.OnlineGameInterfaceImpl]','LanAnnouncePort=14001','LanQueryTimeout=5.0'], ['[OnlineSubsystemLive.OnlineSubsystemLive]','LanAnnouncePort=14001','VoiceNotificationDelta=0.2'], ['[OnlineSubsystemDingo.OnlineSubsystemDingo]','VoiceNotificationDelta=0.2'], ['[Engine.StaticMeshCollectionActor]','bCookOutStaticMeshActors=True','MaxStaticMeshComponents=100'], ['[Engine.StaticLightCollectionActor]','bCookOutStaticLightActors=True','MaxLightComponents=100'], ['[LiveSock]','bUseVDP=True','bUseSecureConnections=True','MaxDgramSockets=64','MaxStreamSockets=16','DefaultRecvBufsizeInK=256','DefaultSendBufsizeInK=256','SystemLinkPort=14000'], ['[CustomStats]','LD=Streaming fudge factor','LD=FrameTime','LD=Terrain Smooth Time','LD=Terrain Render Time','LD=Decal Render Time','LD=Terrain Triangles','LD=Decal Triangles','LD=Decal Draw Calls','LD=Static Mesh Tris','LD=Skel Mesh Tris','LD=Skel Verts CPU Skin','LD=Skel Verts GPU Skin','LD=30+ FPS','LD=Total CPU rendering time','LD=Total GPU rendering time','LD=Occluded primitives','LD=Projected shadows','LD=Visible static mesh elements','LD=Visible dynamic primitives','LD=Texture Pool Size','LD=Physical Memory Used','LD=Virtual Memory Used','LD=Audio Memory Used','LD=Texture Memory Used','LD=360 Texture Memory Used','LD=Animation Memory','LD=Vertex Lighting Memory','LD=StaticMesh Vertex Memory','LD=StaticMesh Index Memory','LD=SkeletalMesh Vertex Memory','LD=SkeletalMesh Index Memory','LD=Decal Vertex Memory','LD=Decal Index Memory','LD=Decal Interaction Memory','MEMLEAN=Virtual Memory Used','MEMLEAN=Audio Memory Used','MEMLEAN=Animation Memory','MEMLEAN=FaceFX Cur Mem','MEMLEAN=Vertex Lighting Memory','MEMLEAN=StaticMesh Vertex Memory','MEMLEAN=StaticMesh Index Memory','MEMLEAN=SkeletalMesh Vertex Memory','MEMLEAN=SkeletalMesh Index Memory','MEMLEAN=Decal Vertex Memory','MEMLEAN=Decal Index Memory','MEMLEAN=Decal Interaction Memory','MEMLEAN=VertexShader Memory','MEMLEAN=PixelShader Memory','GameThread=Async Loading Time','GameThread=Audio Update Time','GameThread=FrameTime','GameThread=HUD Time','GameThread=Input Time','GameThread=Kismet Time','GameThread=Move Actor Time','GameThread=RHI Game Tick','GameThread=RedrawViewports','GameThread=Script time','GameThread=Tick Time','GameThread=Update Components Time','GameThread=World Tick Time','GameThread=Async Work Wait','GameThread=PerFrameCapture','GameThread=DynamicLightEnvComp Tick','Mobile=ES2 Draw Calls','Mobile=ES2 Draw Calls (UP)','Mobile=ES2 Triangles Drawn','Mobile=ES2 Triangles Drawn (UP)','Mobile=ES2 Program Count','Mobile=ES2 Program Count (PP)','Mobile=ES2 Program Changes','Mobile=ES2 Uniform Updates (Bytes)','Mobile=ES2 Base Texture Binds','Mobile=ES2 Detail Texture Binds','Mobile=ES2 Lightmap Texture Binds','Mobile=ES2 Environment Texture Binds','Mobile=ES2 Bump Offset Texture Binds','Mobile=Frustum Culled primitives','Mobile=Statically occluded primitives','SplitScreen=Processed primitives','SplitScreen=Mesh draw calls','SplitScreen=Mesh Particles','SplitScreen=Particle Draw Calls'], _
['[MemorySplitClassesToTrack]','Class=AnimSequence','Class=AudioComponent','Class=AudioDevice','Class=BrushComponent','Class=CylinderComponent','Class=DecalComponent','Class=DecalManager','Class=DecalMaterial','Class=Font','Class=Level','Class=Material','Class=MaterialInstanceConstant','Class=MaterialInstanceTimeVarying','Class=Model','Class=ModelComponent','Class=MorphTarget','Class=NavigationMeshBase','Class=ParticleModule','Class=ParticleSystemComponent','Class=PathNode','Class=ProcBuilding_SimpleLODActor','Class=RB_BodyInstance','Class=RB_BodySetup','Class=ReachSpec','Class=Sequence','Class=SkeletalMesh','Class=SkeletalMeshComponent','Class=SoundCue','Class=SoundNode','Class=SoundNodeWave','Class=StaticMesh','Class=StaticMeshActor','Class=StaticMeshCollectionActor','Class=StaticMeshComponent','Class=Terrain','Class=TerrainComponent','Class=Texture2D','Class=UIRoot'], ['[MemLeakCheckExtraExecsToRun]','Cmd=obj list class=StaticMesh -Alphasort -DetailedInfo','Cmd=obj list class=StaticMeshActor -ALPHASORT -DetailedInfo','Cmd=obj list class=StaticMeshCollectionActor -ALPHASORT -DetailedInfo','Cmd=obj list class=TextureMovie -Alphasort -DetailedInfo','Cmd=obj list class=Level -ALPHASORT -DetailedInfo','Cmd=lightenv list volumes','Cmd=lightenv list transition','Cmd=ListThreads'], ['[ConfigCoalesceFilter]','FilterOut=BattleEngine.ini','FilterOut=BattleEditor.ini','FilterOut=BattleInput.ini','FilterOut=BattleLightmass.ini','FilterOut=BattleGame.ini','FilterOut=BattleGameDedicatedServer.ini','FilterOut=BattleUI.ini','FilterOut=BattleSystemSettings.ini','FilterOut=BattleEngineG4WLive.ini','FilterOut=BattleEngineG4WLiveDedicatedServer.ini','FilterOut=BattleEngineNoLive.ini','FilterOut=BattleEngineNoLiveDedicatedServer.ini','FilterOut=BattleEditorKeyBindings.ini','FilterOut=BattleEditorUserSettings.ini','FilterOut=BattleEngineGameSpy.ini','FilterOut=BattleEngineSteamworks.ini','FilterOut=BattleEngineDiscord.ini','FilterOut=Descriptions.int','FilterOut=Editor.int','FilterOut=EditorTips.int','FilterOut=UnrealEd.int','FilterOut=WinDrv.int','FilterOut=XWindow.int','FilterOut=GfxUIEditor.int','FilterOut=Properties.int'], ['[TaskPerfTracking]','bUseTaskPerfTracking=False','RemoteConnectionIP=10.1.10.83','ConnectionString=Provider=sqloledb;Data Source=DB-02;Initial Catalog=EngineTaskPerf;Trusted_Connection=Yes','RemoteConnectionStringOverride=Data Source=DB-02;Initial Catalog=EngineTaskPerf;Integrated Security=True;Pooling=False;Asynchronous Processing=True;Network Library=dbmssocn'], ['[FPSChartTracking]','ShouldTrackFPSWhenNonInteractive=False'], ['[TaskPerfMemDatabase]','bUseTaskPerfMemDatabase=False','RemoteConnectionIP=10.1.10.83','ConnectionString=Provider=sqloledb;Data Source=DEVDB-01;Initial Catalog=PerfMem;Trusted_Connection=Yes','RemoteConnectionStringOverride=Data Source=DEVDB-01;Initial Catalog=PerfMem;Integrated Security=True;Pooling=True;Asynchronous Processing=True;Network Library=dbmssocn'], ['[MemoryPools]','FLightPrimitiveInteractionInitialBlockSize=512','FModShadowPrimitiveInteractionInitialBlockSize=512'], ['[MobileMaterialCookSettings]','SkinningOnlyMaterials=','NoLightmapOnlyMaterials='], ['[Engine.PhysicsLODVerticalEmitter]','ParticlePercentage=100'], ['[Engine.OnlineSubsystem]','NamedInterfaceDefs=(InterfaceName="RecentPlayersList",InterfaceClassName="Engine.OnlineRecentPlayersList")','AsyncMinCompletionTime=0.0'], ['[Engine.OnlineRecentPlayersList]','MaxRecentPlayers=100','MaxRecentParties=5'], ['[VoIP]','VolumeThreshold=0.2','bHasVoiceEnabled=True'], ['[FullScreenMovie]','bForceNoMovies=False','StartupMovies=GAPeach_Console.swf'], ['[IPDrv.WebConnection]','MaxValueLength=512','MaxLineLength=4096'], ['[IPDrv.WebServer]','ApplicationPaths[0]=/ServerAdmin','ApplicationPaths[1]=/images','ListenPort=80','MaxConnections=18','ExpirationSeconds=86400','bEnabled=False'], ['[IPDrv.WebResponse]','IncludePath=/Web','CharSet=iso-8859-1'], ['[AnimNotify]','Trail_MaxSampleRate=200.0'], ['[Engine.UIDataStore_OnlinePlayerData]','PartyChatProviderClassName=Engine.UIDataProvider_OnlinePartyChatList'], _
['[Engine.LocalPlayer]','AspectRatioAxisConstraint=AspectRatio_MaintainYFOV'], ['[MobileSupport]','bShouldCachePVRTCTextures=False','bShouldCacheATITCTextures=False','bShouldCacheETCTextures=False','bShouldCacheFlashTextures=False','bShouldFlattenMaterials=True','FlattenedTextureResolutionBias=0','UDKRemotePort=41765','UDKRemotePortPIE=41766'], ['[Engine.GameViewportClient]','bDebugNoGFxUI=False'], ['[ContentComparisonReferenceTypes]','+Class=AnimSet','+Class=SkeletalMesh','+Class=SoundCue','+Class=StaticMesh','+Class=ParticleSystem','+Class=Texture2D'], ['[UnitTesting]','UnitTestPath=..\..\Engine\UnitTests','UnitTestPackageName=UnitTestPackage'], ['[Engine.HttpFactory]','HttpRequestClassName=WinDrv.HttpRequestWindows'], ['[IpDrv.OnlineImageDownloaderWeb]','MaxSimultaneousDownloads=8'], ['[IpDrv.McpServiceConfig]','Protocol=http','Domain=localhost:8888'], ['[IpDrv.McpServiceBase]','McpConfigClassName=IpDrv.McpServiceConfig'], ['[IpDrv.McpServerTimeBase]','McpServerTimeClassName=IpDrv.McpServerTimeManager'], ['[IpDrv.McpServerTimeManager]','TimeStampUrl=/timestamp'], ['[IpDrv.McpGroupsBase]','McpGroupsManagerClassName=IpDrv.McpGroupsManager'], ['[IpDrv.McpGroupsManager]','CreateGroupUrl=/groupcreate','DeleteGroupUrl=/groupdelete','QueryGroupsUrl=/grouplist','QueryGroupMembersUrl=/groupmembers','AddGroupMembersUrl=/groupmembers','RemoveGroupMembersUrl=/groupmembers','DeleteGroupUrl=/groupdelete','DeleteAllGroupsUrl=/groupdeletebyownerid','QueryGroupInvitesUrl=/groupinvite','AcceptGroupInviteUrl=/groupinvite','RejectGroupInviteUrl=/groupinvite'], ['[IpDrv.McpMessageBase]','McpMessageManagerClassName=IpDrv.McpMessageManager'], ['[IpDrv.McpMessageManager]','CompressionType=MMCT_LZO','CreateMessageUrl=/messagecreate','DeleteMessageUrl=/messagedelete','QueryMessagesUrl=/messagelist','QueryMessageContentsUrl=/messagecontents'], ['[IpDrv.McpIdMappingBase]','McpIdMappingClassName=IpDrv.McpIdMappingManager'], ['[IpDrv.McpIdMappingManager]','AddMappingUrl=/useraddaccountmapping','QueryMappingUrl=/userresolveaccountmappings'], ['[IpDrv.McpUserManagerBase]','McpUserManagerClassName=IpDrv.McpUserManager'], ['[IpDrv.McpUserManager]','RegisterUserMcpUrl=/registerusermcp','RegisterUserFacebookUrl=/registeruserfacebook','QueryUserUrl=/userstatus','QueryUsersUrl=/usermultiplestatus','DeleteUserUrl=/deleteuser','McpAuthUrl=/authenticateusermcp','FacebookAuthUrl=/authenticateuserfacebook'], ['[IpDrv.McpUserCloudFileDownload]','EnumerateCloudFilesUrl=/cloudstoragelist','ReadCloudFileUrl=/cloudstoragecontents','WriteCloudFileUrl=/cloudstoragesave','DeleteCloudFileUrl=/cloudstoragedelete'], ['[IpDrv.McpClashMobBase]','McpClashMobClassName=IpDrv.McpClashMobManager'], ['[IpDrv.McpClashMobManager]','ChallengeListUrl=/challengelist','ChallengeStatusUrl=/challengestatus','ChallengeMultiStatusUrl=/challengemultiplestatus','AcceptChallengeUrl=/acceptchallenge','UpdateChallengeProgressUrl=/updatechallenge','UpdateRewardProgressUrl=/updatereward'], ['[IpDrv.McpManagedValueManagerBase]','McpManagedValueManagerClassName=IpDrv.McpManagedValueManager'], ['[IpDrv.McpManagedValueManager]','CreateSaveSlotUrl=/createvalues','ReadSaveSlotUrl=/listvalues','UpdateValueUrl=/updatevalue','DeleteValueUrl=/deletevalue'], ['[IpDrv.McpUserInventoryBase]','McpUserInventoryClassName=IpDrv.McpUserInventoryManager'], ['[IpDrv.McpUserInventoryManager]','CreateSaveSlotUrl=/createsaveslot','DeleteSaveSlotUrl=/deletesaveslot','ListSaveSlotUrl=/listsaveslot','ListItemsUrl=/listitems','PurchaseItemUrl=/purchaseitem','SellItemUrl=/sellitem','EarnItemUrl=/earnitem','ConsumeItemUrl=/consumeitem','DeleteItemUrl=/deleteitem','IapRecordUrl=/recordiap'], ['[IpDrv.McpClashMobFileDownload]','RequestFileURL=/challengefile'], ['[IpDrv.OnlineTitleFileDownloadWeb]','RequestFileURL=/downloadfile','RequestFileListURL=/listfiles','TimeOut=10.0'], ['[OnlineSubsystem]','PollingIntervalInMs=50','bAllowAsyncBlocking=True','DebugTaskDelayInMs=0'], ['[SubstanceAir]','MipCountAfterCooking=7','MemBudgetMb=2048','FreeCore=0','bForceTextureBaking=False','bInstallTimeGeneration=False'], _
['[Engine.SupportedShaderPlatforms]','DX9=True','DX11=True'], ['[Cooker.GeneralOptions]','HirezShaderStoragePlatforms=pc','HirezShaderStoragePlatforms=pcconsole','HirezShaderStoragePlatforms=mac','HirezShaderStoragePlatforms=macconsole','bUseTFCsForNonSeekfreePackages=True','DisallowedLocalizationPlatforms=pc','DisallowedLocalizationPlatforms=pcconsole','DisallowedLocalizationPlatforms=mac','DisallowedLocalizationPlatforms=macconsole','DisallowedLocalizationPlatforms=pcserver','CreateAnimNotifyDataPlatforms=pc','CreateAnimNotifyDataPlatforms=pcconsole','CreateAnimNotifyDataPlatforms=pcserver','CreateAnimNotifyDataPlatforms=mac','CreateAnimNotifyDataPlatforms=macconsole'], ['[Windows.StandardUser]','MyDocumentsSubDirName=Smite'], ['[Engine.AdditionalLaunchMaps]','Map=Faction_Arena_S7_P','Map=Chinese_Joust_S7_P','Map=Arena_Tutorial_V3_Short_P'], ['[Engine.AdditionalLaunchBots]','Bot=Neith','Bot=Ra','Bot=Ymir','Bot=Odin','Bot=Guan_Yu','Bot=Thor','Bot=Anubis','Bot=Hercules','Bot=Artemis','Bot=Kali','Bot=Sobek','Bot=Fenrir'], ['[TgGame.TgDistributionFloatSoundAttenuation]','AttenuationGroups=(GroupName=Sm_foley,AttenuationDistance=1600.0)','AttenuationGroups=(GroupName=Lg_foley,AttenuationDistance=3200.0)','AttenuationGroups=(GroupName=Melee_hit,AttenuationDistance=6400.0)','AttenuationGroups=(GroupName=Sm_gun,AttenuationDistance=4800.0)','AttenuationGroups=(GroupName=Med_gun,AttenuationDistance=12800.0)','AttenuationGroups=(GroupName=Lg_gun,AttenuationDistance=48000.0)','AttenuationGroups=(GroupName=Sm_exp,AttenuationDistance=14400.0)','AttenuationGroups=(GroupName=Med_exp,AttenuationDistance=80000.0)','AttenuationGroups=(GroupName=Lg_exp,AttenuationDistance=144000.0)'], ['[Engine.SeqAct_CrowdSpawner]','m_CrowdSpawnNumMultiplier=1.0','m_bCrowdShadows=True'], ['[Engine.AudioDevice]','DefaultAudioComponentClassName=TgGame.TgAudioComponent'], ['[Engine.FractureManager]','FSMPartPoolSize=0'], ['[GFxUI.GFxEngine]','ForceGarbageCollectUponReleaseTextures=LoginBackground_ID3'], ['[OnlineSubsystemEpic.OnlineSubsystemEpic]','LogLevel=600','ProductId=f71b1231985f48d1af3de723e0a6acdd','SandboxId=076207fa2b5c4803a636af606c3c28b7','ClientId=bf659e4ce1264fd9ad93c83eba001914','DeploymentId=e03ac5a2b3444159b50aded07f1ed69b'], ['[OnlineSubsystemSteamworks.OnlineSubsystemSteamworks]','DefaultSessionTemplateName=Game','PartySessionTemplateName=Party','bHasVoiceEnabled=False'], ['[Vivox]','Enabled=True','ResetMutePreferencePerChannel=False','CheckOSSPermissions=False','AutoVAD=False'], ['[HavokNavMesh]','bLoadOnClient=False'], ['[Experimental]','bUnloadUIScenesOnTransition=True','ParticleDynamicDataRingBufferSizeMB=16','ParticleBulkDataCollapseThreshold=0.2','bSpecialFxCanUseEmitterPool=True','bAllowDeferredParticleTicking=True','bParticleSystemOuterGCOptimization=True','bPassthroughAimArray=True'], ['[Discord]','AppID=511658855466401793','RichPresenceAppId=511658855466401793','RichPresenceDefaultLargeIcon=smitelogo','RichPresenceDefaultSmallIcon='], ['[IniVersion]','0=1595803092.000000','1=1595799760.000000'] ]
Global Const $SystemSettingsClearHive[35][244] = [ _
['[SystemSettings]','MaxActiveDecals=0','GameSettingsVersion=-1','StaticDecals=True','DynamicDecals=True','UnbatchedDecals=True','DecalCullDistanceScale=1.000000','DynamicLights=True','DynamicShadows=True','LightEnvironmentShadows=True','CompositeDynamicLights=True','SHSecondaryLighting=True','DirectionalLightmaps=True','MotionBlur=False','MotionBlurPause=True','MotionBlurSkinning=1','DepthOfField=True','AmbientOcclusion=False','Bloom=True','bAllowLightShafts=True','Distortion=True','FilteredDistortion=True','DropParticleDistortion=False','bMergeModulatedShadows=False','bAllowDownsampledTranslucency=False','SpeedTreeLeaves=True','SpeedTreeFronds=True','OnlyStreamInTextures=False','LensFlares=True','FogVolumes=True','FogAccumulationDownsampleFactor=1','FloatingPointRenderTargets=True','OneFrameThreadLag=True','UseVsync=False','AllowDoubleRenderFrames=False','ModulatedShadowStartFadeDistance=0.000000','ModulatedShadowFullyFadeDistance=0.000000','VsyncPresentInterval=1','UseCinematicMipCalculations=True','bUseTripleBuffering=False','UpscaleScreenPercentage=True','Fullscreen=True','FullscreenWindowed=False','MeshScreenPixelAreaThreshold=16.000000','OctreeScreenPixelAreaThreshold=0.000000','AllowOpenGL=False','AllowRadialBlur=True','UseDX11=True','UseD3D11Beta=False','bAllowTexturePack=True','AllowSubsurfaceScattering=False','AllowImageReflections=True','AllowImageReflectionShadowing=True','bAllowSeparateTranslucency=False','bAllowPostprocessMLAA=False','bAllowHighQualityMaterials=True','MaxFilterBlurSampleCount=16','SkeletalMeshLODBias=0','ParticleLODBias=0','DetailMode=2','MaxDrawDistanceScale=1.200000','ShadowFilterQualityBias=1','MaxAnisotropy=16','MaxMultisamples=1','bAllowD3D9MSAA=False','bAllowTemporalAA=False','TemporalAA_MinDepth=500.000000','TemporalAA_StartDepthVelocityScale=100.000000','MinShadowResolution=32','MinPreShadowResolution=8','MaxShadowResolution=512','MobileShadowTextureResolution=1120','MaxWholeSceneDominantShadowResolution=4096','ShadowFadeResolution=128','PreShadowFadeResolution=16','ShadowFadeExponent=0.250000','ScreenPercentage=100.000000','SceneCaptureStreamingMultiplier=1.000000','ShadowTexelsPerPixel=2.000000','PreShadowResolutionFactor=0.500000','bEnableBranchingPCFShadows=False','bAllowHardwareShadowFiltering=False','TessellationAdaptivePixelsPerTriangle=48.000000','bEnableForegroundShadowsOnWorld=False','bEnableForegroundSelfShadowing=False','bAllowWholeSceneDominantShadows=True','bUseConservativeShadowBounds=False','ShadowFilterRadius=2.000000','ShadowDepthBias=0.012000','PerObjectShadowTransition=60.000000','PerSceneShadowTransition=600.000000','CSMSplitPenumbraScale=0.500000','CSMSplitSoftTransitionDistanceScale=4.000000','CSMSplitDepthBiasScale=0.500000','CSMMinimumFOV=40.000000','CSMFOVRoundFactor=4.000000','UnbuiltWholeSceneDynamicShadowRadius=20000.000000','UnbuiltNumWholeSceneDynamicShadowCascades=3','WholeSceneShadowUnbuiltInteractionThreshold=50','bAllowFracturedDamage=True','NumFracturedPartsScale=1.000000','FractureDirectSpawnChanceScale=1.000000','FractureRadialSpawnChanceScale=1.000000','FractureCullDistanceScale=1.000000','bForceCPUAccessToGPUSkinVerts=False','bDisableSkeletalInstanceWeights=False','HighPrecisionGBuffers=False','AllowSecondaryDisplays=False','SecondaryDisplayMaximumWidth=1280','SecondaryDisplayMaximumHeight=720','AllowLogitechLedSdk=True','AllowPerFrameSleep=True','AllowPerFrameYield=True','MobileFeatureLevel=0','MobileFog=True','MobileHeightFog=False','MobileSpecular=True','MobileBumpOffset=True','MobileNormalMapping=True','MobileEnvMapping=True','MobileRimLighting=True','MobileColorBlending=True','MobileColorGrading=False','MobileVertexMovement=True','MobileOcclusionQueries=False','MobileGlobalGammaCorrection=False','MobileAllowGammaCorrectionWorldOverride=True','MobileAllowDepthPrePass=False','MobileGfxGammaCorrection=False','MobileLODBias=-0.5','MobileBoneCount=75','MobileBoneWeightCount=2','MobileUsePreprocessedShaders=True','MobileFlashRedForUncachedShaders=False','MobileWarmUpPreprocessedShaders=True','MobileCachePreprocessedShaders=False', _
'MobileProfilePreprocessedShaders=False','MobileUseCPreprocessorOnShaders=True','MobileLoadCPreprocessedShaders=True','MobileSharePixelShaders=True','MobileShareVertexShaders=True','MobileShareShaderPrograms=True','MobileEnableMSAA=False','MobileContentScaleFactor=1.0','MobileVertexScratchBufferSize=150','MobileIndexScratchBufferSize=10','MobileLightShaftScale=2.0','MobileLightShaftFirstPass=0.5','MobileLightShaftSecondPass=1.0','MobileModShadows=True','MobileTiltShift=False','MobileMaxMemory=300','MobilePostProcessBlurAmount=32.0','bMobileUsingHighResolutionTiming=True','MobileTiltShiftPosition=0.5','MobileTiltShiftFocusWidth=0.3','MobileTiltShiftTransitionWidth=0.5','MobileMaxShadowRange=500.0','MobileBloomTint=(R=1.0,G=0.75,B=0.0,A=1.0)','MobileClearDepthBetweenDPG=False','MobileSceneDepthResolveForShadows=True','MobileLandscapeLodBias=0','MobileUseShaderGroupForStartupObjects=False','MobileMinimizeFogShaders=False','MobileFXAAQuality=0','ApexLODResourceBudget=1000000000000000000000.0','ApexDestructionMaxChunkIslandCount=2500','ApexDestructionMaxShapeCount=0','ApexDestructionMaxChunkSeparationLOD=1.0','ApexDestructionMaxActorCreatesPerFrame=-1','ApexDestructionMaxFracturesProcessedPerFrame=-1','ApexDestructionSortByBenefit=True','ApexGRBEnable=False','ApexGRBGPUMemSceneSize=128','ApexGRBGPUMemTempDataSize=128','ApexGRBMeshCellSize=7.5','ApexGRBNonPenSolverPosIterCount=9','ApexGRBFrictionSolverPosIterCount=3','ApexGRBFrictionSolverVelIterCount=3','ApexGRBSkinWidth=0.025','ApexGRBMaxLinearAcceleration=1000000.0','bEnableParallelAPEXClothingFetch=True','bApexClothingAsyncFetchResults=False','ApexClothingAvgSimFrequencyWindow=60','ApexClothingAllowAsyncCooking=True','ApexClothingAllowApexWorkBetweenSubsteps=False','TargetFrameRate=60','TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)', _
'TEXTUREGROUP_Cinematic=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Skybox=(MinLODSize=2048,MaxLODSize=2048,MaxLODSizeTexturePack=8192,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Lightmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Shadowmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)','TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_UIStreamable=(MinLODSize=1,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)','bAllowRagdolling=True','bAllowParticleSystemPerfBias=True','bAllowPerfThrottling=False','PerfScalingFramerateStart=30.000000','PerfScalingFramerateRange=20.000000','PerfScalingMaxReduction=0.600000','PerfScalingBias=0.000000','Borderless=False','StaticMeshLODBias=0','bAllowDropShadows=True','SpeedTreeLODBias=0','bUseLowQualMaterials=False','bUseSpectatorTextureSettings=False','TexturePoolSize=900','AllowD3D11=True','PreferD3D11=False','FXAAQuality=0','AllowScreenDoorFade=True','AllowScreenDoorLODFading=True','MaterialQualityLevel=0','SettingsVersion=11','SpeedTreeWind=True','TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)', _
'TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_WorldDetail=(MinLODSize=512,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_ColorLookupTable=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=1,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)','TEXTUREGROUP_TitleScreenPreview=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=1,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)'], _
['[SystemSettingsBucket1]','BasedOn=SystemSettings','StaticDecals=False','DynamicDecals=False','UnbatchedDecals=True','DecalCullDistanceScale=0.4','DynamicShadows=False','LightEnvironmentShadows=False','MotionBlur=False','DepthOfField=False','AmbientOcclusion=False','Bloom=False','bAllowLightShafts=False','Distortion=False','DropParticleDistortion=True','LensFlares=False','AllowRadialBlur=False','bAllowSeparateTranslucency=False','bAllowPostprocessMLAA=False','bAllowHighQualityMaterials=False','SkeletalMeshLODBias=1','DetailMode=0','MaxDrawDistanceScale=0.8','MaxAnisotropy=0','MaxShadowResolution=256','MaxWholeSceneDominantShadowResolution=256','ScreenPercentage=100.000000','ShadowTexelsPerPixel=2.0','bAllowWholeSceneDominantShadows=False','bUseConservativeShadowBounds=True','bAllowFracturedDamage=False','FractureCullDistanceScale=0.25','DynamicLights=False','bAllowDropShadows=False','CompositeDynamicLights=False','SHSecondaryLighting=False','DirectionalLightmaps=True','bAllowParticleSystemPerfBias=True','bAllowParticleSystemPerfThrottling=True','AllowSubsurfaceScattering=False','AllowImageReflections=False','StaticMeshLODBias=1','ParticleLODBias=10','PerfScalingBias=0.2','ShadowFilterQualityBias=-1','MaxMultisamples=1','FXAAQuality=0','bAllowRagdolling=False','SpeedTreeLODBias=2','AllowScreenDoorFade=False','AllowScreenDoorLODFading=False','bUseLowQualMaterials=True','TexturePoolSize=450','MaterialQualityLevel=1','SpeedTreeWind=False','FogAccumulationDownsampleFactor=2','TEXTUREGROUP_World=(MinLODSize=64,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=64,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldSpecular=(MinLODSize=32,MaxLODSize=256,LODBias=3,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Vehicle=(MinLODSize=128,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=128,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=128,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Cinematic=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Effects=(MinLODSize=64,MaxLODSize=256,LODBias=2,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=64,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Skybox=(MinLODSize=256,MaxLODSize=256,LODBias=3,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UIStreamable=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=-1)','TEXTUREGROUP_Lightmap=(MinLODSize=128,MaxLODSize=512,LODBias=3,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Shadowmap=(MinLODSize=128,MaxLODSize=512,LODBias=3,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=3)','TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=1024,LODBias=1,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=256,LODBias=1,MinMagFilter=linear,MipFilter=point)', _
'TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,LODBias=1,MinMagFilter=linear,MipFilter=linear,MipGenSettings=TMGS_Blur5)','TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,LODBias=1,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_NPC=(MinLODSize=128,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_NPCNormalMap=(MinLODSize=128,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_NPCSpecular=(MinLODSize=128,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=256,LODBias=3,MinMagFilter=aniso,MipFilter=point)'], _
['[SystemSettingsBucket2]','BasedOn=SystemSettings','StaticDecals=False','DynamicDecals=False','UnbatchedDecals=True','DecalCullDistanceScale=0.5','DynamicShadows=False','LightEnvironmentShadows=False','MotionBlur=False','DepthOfField=False','AmbientOcclusion=False','Bloom=False','bAllowLightShafts=False','Distortion=False','DropParticleDistortion=True','LensFlares=False','AllowRadialBlur=False','bAllowSeparateTranslucency=False','bAllowPostprocessMLAA=False','bAllowHighQualityMaterials=False','SkeletalMeshLODBias=1','DetailMode=0','MaxDrawDistanceScale=0.9','MaxAnisotropy=0','MaxShadowResolution=512','MaxWholeSceneDominantShadowResolution=512','ScreenPercentage=100.000000','ShadowTexelsPerPixel=2.0','bAllowWholeSceneDominantShadows=False','bUseConservativeShadowBounds=True','bAllowFracturedDamage=False','FractureCullDistanceScale=0.5','DynamicLights=True','bAllowDropShadows=True','CompositeDynamicLights=True','SHSecondaryLighting=False','DirectionalLightmaps=True','bAllowParticleSystemPerfBias=True','bAllowParticleSystemPerfThrottling=True','AllowSubsurfaceScattering=False','AllowImageReflections=False','StaticMeshLODBias=1','ParticleLODBias=2','PerfScalingBias=0.2','ShadowFilterQualityBias=-1','MaxMultisamples=1','FXAAQuality=0','bAllowRagdolling=False','SpeedTreeLODBias=2','AllowScreenDoorFade=False','AllowScreenDoorLODFading=False','bUseLowQualMaterials=True','TexturePoolSize=450','MaterialQualityLevel=1','SpeedTreeWind=False','FogAccumulationDownsampleFactor=2','TEXTUREGROUP_World=(MinLODSize=64,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldSpecular=(MinLODSize=64,MaxLODSize=256,LODBias=3,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Cinematic=(MinLODSize=128,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Effects=(MinLODSize=128,MaxLODSize=512,LODBias=2,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=128,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Skybox=(MinLODSize=512,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UIStreamable=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=-1)','TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=3)','TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=1024,LODBias=0,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=linear,MipFilter=point)', _
'TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,LODBias=0,MinMagFilter=linear,MipFilter=linear,MipGenSettings=TMGS_Blur5)','TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_NPC=(MinLODSize=128,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_NPCNormalMap=(MinLODSize=128,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_NPCSpecular=(MinLODSize=128,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=256,LODBias=3,MinMagFilter=aniso,MipFilter=point)'], _
['[SystemSettingsBucket3]','BasedOn=SystemSettings','StaticDecals=True','DynamicDecals=True','UnbatchedDecals=True','DecalCullDistanceScale=0.6','DynamicShadows=False','LightEnvironmentShadows=True','MotionBlur=False','DepthOfField=True','AmbientOcclusion=False','Bloom=True','bAllowLightShafts=False','Distortion=True','DropParticleDistortion=True','LensFlares=True','AllowRadialBlur=True','bAllowSeparateTranslucency=False','bAllowPostprocessMLAA=False','bAllowHighQualityMaterials=True','SkeletalMeshLODBias=0','DetailMode=1','MaxDrawDistanceScale=1.0','MaxAnisotropy=4','MaxShadowResolution=512','MaxWholeSceneDominantShadowResolution=1280','ScreenPercentage=100.000000','ShadowTexelsPerPixel=2.0','bAllowWholeSceneDominantShadows=True','bUseConservativeShadowBounds=False','bAllowFracturedDamage=True','FractureCullDistanceScale=1.0','DynamicLights=True','bAllowDropShadows=True','CompositeDynamicLights=True','SHSecondaryLighting=True','DirectionalLightmaps=True','bAllowParticleSystemPerfBias=True','bAllowParticleSystemPerfThrottling=True','AllowSubsurfaceScattering=False','AllowImageReflections=False','StaticMeshLODBias=0','ParticleLODBias=1','PerfScalingBias=0.1','ShadowFilterQualityBias=0','MaxMultisamples=1','FXAAQuality=0','bAllowRagdolling=True','SpeedTreeLODBias=2','AllowScreenDoorFade=True','AllowScreenDoorLODFading=True','bUseLowQualMaterials=False','TexturePoolSize=450','MaterialQualityLevel=2','SpeedTreeWind=True','TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=512,LODBias=2,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Cinematic=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Effects=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Skybox=(MinLODSize=1024,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UIStreamable=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=-1)','TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=3)','TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=1024,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=aniso,MipFilter=point)', _
'TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear,MipGenSettings=TMGS_Blur5)','TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)'], _
['[SystemSettingsBucket4]','BasedOn=SystemSettings','StaticDecals=True','DynamicDecals=True','UnbatchedDecals=True','DecalCullDistanceScale=0.8','DynamicShadows=True','LightEnvironmentShadows=True','MotionBlur=False','DepthOfField=True','AmbientOcclusion=False','Bloom=True','bAllowLightShafts=True','Distortion=True','DropParticleDistortion=False','LensFlares=True','AllowRadialBlur=True','bAllowSeparateTranslucency=False','bAllowPostprocessMLAA=False','bAllowHighQualityMaterials=True','SkeletalMeshLODBias=0','DetailMode=2','MaxDrawDistanceScale=1.1','MaxAnisotropy=4','MaxShadowResolution=512','MaxWholeSceneDominantShadowResolution=2048','ScreenPercentage=100.000000','ShadowTexelsPerPixel=2.0','bAllowWholeSceneDominantShadows=True','bUseConservativeShadowBounds=False','bAllowFracturedDamage=True','FractureCullDistanceScale=1.5','DynamicLights=True','bAllowDropShadows=True','CompositeDynamicLights=True','SHSecondaryLighting=True','DirectionalLightmaps=True','bAllowParticleSystemPerfBias=True','bAllowParticleSystemPerfThrottling=True','AllowSubsurfaceScattering=False','AllowImageReflections=True','StaticMeshLODBias=0','ParticleLODBias=0','PerfScalingBias=0.0','ShadowFilterQualityBias=0','MaxMultisamples=1','FXAAQuality=0','bAllowRagdolling=True','SpeedTreeLODBias=1','AllowScreenDoorFade=True','AllowScreenDoorLODFading=True','bUseLowQualMaterials=False','TexturePoolSize=450','MaterialQualityLevel=0','SpeedTreeWind=True','TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=2,LODBiasTexturePack=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Cinematic=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Skybox=(MinLODSize=1024,MaxLODSize=2048,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UIStreamable=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=-1)','TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=3)','TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=1024,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=aniso,MipFilter=point)', _
'TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear,MipGenSettings=TMGS_Blur5)','TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=1024,LODBias=0,MinMagFilter=aniso,MipFilter=point)'], _
['[SystemSettingsBucket5]','BasedOn=SystemSettings','StaticDecals=True','DynamicDecals=True','UnbatchedDecals=True','DecalCullDistanceScale=1.0','DynamicShadows=True','LightEnvironmentShadows=True','MotionBlur=False','DepthOfField=True','AmbientOcclusion=False','Bloom=True','bAllowLightShafts=True','Distortion=True','DropParticleDistortion=False','LensFlares=True','AllowRadialBlur=True','bAllowSeparateTranslucency=False','bAllowPostprocessMLAA=False','bAllowHighQualityMaterials=True','SkeletalMeshLODBias=0','DetailMode=2','MaxDrawDistanceScale=1.2','MaxAnisotropy=16','MaxShadowResolution=512','MaxWholeSceneDominantShadowResolution=4096','ScreenPercentage=100.000000','ShadowTexelsPerPixel=2.0','bAllowWholeSceneDominantShadows=True','bUseConservativeShadowBounds=False','bAllowFracturedDamage=True','FractureCullDistanceScale=2.0','DynamicLights=True','bAllowDropShadows=True','CompositeDynamicLights=True','SHSecondaryLighting=True','DirectionalLightmaps=True','bAllowParticleSystemPerfBias=True','bAllowParticleSystemPerfThrottling=True','AllowSubsurfaceScattering=False','AllowImageReflections=True','StaticMeshLODBias=0','ParticleLODBias=0','PerfScalingBias=0.0','ShadowFilterQualityBias=1','MaxMultisamples=4','FXAAQuality=0','bAllowRagdolling=True','SpeedTreeLODBias=0','AllowScreenDoorFade=True','AllowScreenDoorLODFading=True','bUseLowQualMaterials=False','TexturePoolSize=900','MaterialQualityLevel=0','SpeedTreeWind=True','TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=2,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=1024,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=512,MaxLODSize=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Cinematic=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Skybox=(MinLODSize=2048,MaxLODSize=2048,MaxLODSizeTexturePack=4098,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_UIStreamable=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=-1)','TEXTUREGROUP_Lightmap=(MinLODSize=512,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Shadowmap=(MinLODSize=512,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear,NumStreamedMips=3)', _
'TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=1024,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear,MipGenSettings=TMGS_Blur5)','TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WorldDetail=(MinLODSize=512,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)'], _
['[SystemSettingsScreenshot]','BasedOn=SystemSettings','MaxAnisotropy=16','ShadowFilterQualityBias=1','MinShadowResolution=16','ShadowFadeResolution=1','MinPreShadowResolution=16','PreShadowFadeResolution=1','ShadowTexelsPerPixel=4.0f','PreShadowResolutionFactor=1.0','MaxShadowResolution=4096','MaxWholeSceneDominantShadowResolution=4096','CompositeDynamicLights=False','TEXTUREGROUP_World=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WorldSpecular=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Character=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Weapon=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Vehicle=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Cinematic=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Effects=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Skybox=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Lightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Shadowmap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=-1000,MinMagFilter=aniso,MipFilter=linear)'], ['[SystemSettingsEditor]','BasedOn=SystemSettingsBucket5'], ['[SystemSettingsSplitScreen2]','BasedOn=SystemSettings','bAllowWholeSceneDominantShadows=False','bAllowLightShafts=False','DetailMode=1'], ['[SystemSettingsMobile]','BasedOn=SystemSettings','Fullscreen=True','DirectionalLightmaps=False','DynamicLights=False','SHSecondaryLighting=False','StaticDecals=True','DynamicDecals=False','UnbatchedDecals=False','MotionBlur=False','MotionBlurPause=False','DepthOfField=False','AmbientOcclusion=False','Bloom=False','Distortion=False','FilteredDistortion=False','DropParticleDistortion=True','FloatingPointRenderTargets=False','MaxAnisotropy=2','bAllowLightShafts=False','MobileModShadows=False','MobileClearDepthBetweenDPG=False','MaxFilterBlurSampleCount=4','DynamicShadows=False','MobileMaxMemory=300','MobileLandscapeLodBias=0','AllowRadialBlur=False'], ['[SystemSettingsMobilePreviewer]','BasedOn=SystemSettingsMobile','Fullscreen=False'], _
['[SystemSettingsMobileTextureBias]','BasedOn=SystemSettingsMobile','TEXTUREGROUP_World=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WorldSpecular=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Character=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Weapon=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Vehicle=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Cinematic=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Effects=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=linear,MipFilter=point)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Skybox=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Lightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Shadowmap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=3)','TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=256,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=1,MinMagFilter=aniso,MipFilter=point)'], ['[SystemSettingsAndroid]','BasedOn=SystemSettingsMobileTextureBias'], ['[SystemSettingsAndroid_Performance1_MemoryLow]','BasedOn=SystemSettingsMobileTextureBias','MobileFeatureLevel=1','MobileFog=False','MobileSpecular=False','MobileBumpOffset=False','MobileNormalMapping=False','MobileEnvMapping=False','MobileRimLighting=False','MobileContentScaleFactor=0.9375'], ['[SystemSettingsAndroid_Performance2_MemoryLow]','BasedOn=SystemSettingsMobileTextureBias','MobileBumpOffset=False','MobileNormalMapping=False','MobileContentScaleFactor=0.9375'], ['[SystemSettingsAndroid_Performance1_Memory1024]','BasedOn=SystemSettingsMobile','MobileFeatureLevel=1','MobileFog=False','MobileSpecular=False','MobileBumpOffset=False','MobileNormalMapping=False','MobileEnvMapping=False','MobileRimLighting=False','MobileContentScaleFactor=0.9375'], ['[SystemSettingsAndroid_Performance2_Memory1024]','BasedOn=SystemSettingsMobile','MobileBumpOffset=False','MobileNormalMapping=False','MobileContentScaleFactor=0.9375'], ['[SystemSettingsFlash]','BasedOn=SystemSettingsMobileTextureBias','MotionBlur=False','MotionBlurPause=False','DepthOfField=False','AmbientOcclusion=False','Bloom=False','Distortion=False','FilteredDistortion=False','bAllowLightShafts=False','MobileModShadows=True','DynamicShadows=True','MobileClearDepthBetweenDPG=True','DirectionalLightmaps=False','MobileHeightFog=False'], _
['[SystemSettingsIPhone]','BasedOn=SystemSettingsMobileTextureBias','bMobileUsingHighResolutionTiming=False'], ['[SystemSettingsIPhone3GS]','BasedOn=SystemSettingsMobileTextureBias','LensFlares=False','DetailMode=1','MobileEnableMSAA=True','MobileMaxMemory=100','bMobileUsingHighResolutionTiming=False','MobileLandscapeLodBias=2'], ['[SystemSettingsIPhone4]','BasedOn=SystemSettingsMobile','MobileContentScaleFactor=2.0','LensFlares=False','bMobileUsingHighResolutionTiming=False','MobileLandscapeLodBias=1'], ['[SystemSettingsIPhone4S]','BasedOn=SystemSettingsMobile','MobileEnableMSAA=True','bAllowLightShafts=True','MobileModShadows=True','DynamicShadows=False','ShadowDepthBias=0.025','MobileContentScaleFactor=2.0','MaxShadowResolution=256','MobileShadowTextureResolution=256'], ['[SystemSettingsIPhone5]','BasedOn=SystemSettingsMobile','MobileEnableMSAA=True','bAllowLightShafts=True','MobileModShadows=True','DynamicShadows=False','ShadowDepthBias=0.025','MobileContentScaleFactor=2.0','MaxShadowResolution=256','MobileShadowTextureResolution=1024','AllowRadialBlur=True'], ['[SystemSettingsIPodTouch4]','BasedOn=SystemSettingsMobileTextureBias','MobileContentScaleFactor=2.0','LensFlares=False','MobileMaxMemory=100','bMobileUsingHighResolutionTiming=False','MobileLandscapeLodBias=2'], ['[SystemSettingsIPodTouch5]','BasedOn=SystemSettingsMobile','MobileEnableMSAA=True','bAllowLightShafts=True','MobileModShadows=True','DynamicShadows=False','ShadowDepthBias=0.025','MobileContentScaleFactor=2.0','MaxShadowResolution=256','MobileShadowTextureResolution=256'], ['[SystemSettingsIPad]','BasedOn=SystemSettingsMobileTextureBias','MobileFeatureLevel=1','MobileFog=False','MobileSpecular=False','MobileBumpOffset=False','MobileNormalMapping=False','MobileEnvMapping=False','MobileRimLighting=False','MobileMaxMemory=100','bMobileUsingHighResolutionTiming=False','MobileLandscapeLodBias=1','MobileContentScaleFactor=0.9375'], ['[SystemSettingsIPad2]','BasedOn=SystemSettingsMobile','MobileEnableMSAA=False','bAllowLightShafts=True','MobileModShadows=True','DynamicShadows=False','ShadowDepthBias=0.016','MobileContentScaleFactor=1.0','MaxShadowResolution=256','MobileShadowTextureResolution=256'], ['[SystemSettingsIPad3]','BasedOn=SystemSettingsMobile','MobileEnableMSAA=False','bAllowLightShafts=True','MobileModShadows=True','DynamicShadows=True','ShadowDepthBias=0.016','MobileContentScaleFactor=1.40625','MaxShadowResolution=256','MobileShadowTextureResolution=256','MobileMaxMemory=500'], ['[SystemSettingsIPad4]','BasedOn=SystemSettingsMobile','MobileEnableMSAA=False','bAllowLightShafts=True','MobileModShadows=True','DynamicShadows=True','ShadowDepthBias=0.016','MobileContentScaleFactor=2.0','MaxShadowResolution=512','MobileShadowTextureResolution=512','MobileMaxMemory=500','AllowRadialBlur=True'], ['[SystemSettingsIPadMini]','BasedOn=SystemSettingsMobile','MobileEnableMSAA=False','bAllowLightShafts=True','MobileModShadows=True','DynamicShadows=False','ShadowDepthBias=0.016','MobileContentScaleFactor=1.0','MaxShadowResolution=256','MobileShadowTextureResolution=256'], ['[SystemSettingsIPad2_Detail]','BasedOn=SystemSettingsIPad2'], ['[OpenAutomateBenchmarks]','Benchmark=NightAndDayMap','Benchmark=DM-Deck?CauseEvent=FlyThrough'], _
['[TextureSettingsSpectator]','TEXTUREGROUP_World=(MinLODSize=128,MaxLODSize=128,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WorldNormalMap=(MinLODSize=128,MaxLODSize=128,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WorldSpecular=(MinLODSize=128,MaxLODSize=128,LODBias=2,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Character=(MinLODSize=128,MaxLODSize=512,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_CharacterNormalMap=(MinLODSize=128,MaxLODSize=512,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_CharacterSpecular=(MinLODSize=128,MaxLODSize=512,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=512,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=2048,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_VehicleNormalMap=(MinLODSize=512,MaxLODSize=2048,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=2048,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Cinematic=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,LODBias=1,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Skybox=(MinLODSize=2048,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_UI=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_UIStreamable=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=point,NumStreamedMips=-1)','TEXTUREGROUP_Lightmap=(MinLODSize=512,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Shadowmap=(MinLODSize=512,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear,NumStreamedMips=3)','TEXTUREGROUP_RenderTarget=(MinLODSize=1,MaxLODSize=2048,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_MobileFlattened=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_ProcBuilding_Face=(MinLODSize=1,MaxLODSize=1024,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_ProcBuilding_LightMap=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,LODBias=0,MinMagFilter=aniso,MipFilter=linear,MipGenSettings=TMGS_Blur5)','TEXTUREGROUP_Bokeh=(MinLODSize=1,MaxLODSize=256,LODBias=0,MinMagFilter=linear,MipFilter=linear)','TEXTUREGROUP_NPC=(MinLODSize=128,MaxLODSize=512,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_NPCNormalMap=(MinLODSize=128,MaxLODSize=512,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_NPCSpecular=(MinLODSize=128,MaxLODSize=512,LODBias=0,MinMagFilter=aniso,MipFilter=linear)','TEXTUREGROUP_WorldDetail=(MinLODSize=128,MaxLODSize=128,LODBias=0,MinMagFilter=aniso,MipFilter=linear)'], ['[IniVersion]','0=1595803092.000000','1=1595799763.000000'], ['[SettingsCheck]','Initialized=True'] ]
Global Const $TextureQualityHive[9][8][4] = [ [ [ "TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1,LODBias=2048,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=512,MaxLODSize=4096,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=2,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=64,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=64,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=32,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_WorldNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"], [ "TEXTUREGROUP_World=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)"] ],[ [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""] ],[ [ "TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_NPC=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=256,MaxLODSizeTexturePack=256,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Lightmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""] ],[ [ "TEXTUREGROUP_Skybox=(MinLODSize=2048,MaxLODSize=2048,MaxLODSizeTexturePack=8192,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ _
"TEXTUREGROUP_Skybox=(MinLODSize=1024,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1024,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=512,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=3,LODBiasTexturePack=3,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", "", ""] ],[ [ "TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=1,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=64,MaxLODSize=64,MaxLODSizeTexturePack=64,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=32,MaxLODSize=32,MaxLODSizeTexturePack=32,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=16,MaxLODSize=16,MaxLODSizeTexturePack=16,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ _
"TEXTUREGROUP_Effects=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Linear,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=1,MaxLODSize=1,MaxLODSizeTexturePack=1,LODBias=2,LODBiasTexturePack=2,MinMagFilter=Aniso,MipFilter=Point,MipGenSettings=TMGS_SimpleAverage)", "", ""] ] ]
Func GUICtrlCreateLabelTransparentBG($Text,$X = 0,$Y = 0,$Size_X = 0,$Size_Y = 0,$Style = Default)
Local $Label = GUICtrlCreateLabel($Text,$X,$Y,$Size_X,$Size_Y,$Style)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1,Default,Default,Default,$MainFontName)
Return $Label
EndFunc
Func GUICtrlCreateCheckboxTransparentBG($X = 0,$Y = 0,$Size_X = 0,$Size_Y = 0)
Local $Checkbox = GUICtrlCreateCheckbox($sEmpty,$X,$Y,$Size_X,$Size_Y)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
Return $Checkbox
EndFunc
Func GUICtrlCreateComboNoTheme($Str,$X = 0,$Y = 0,$Size_X = 0,$Size_Y = 0,$Style = "")
Local $Combo = GUICtrlCreateCombo($Str,$X,$Y,$Size_X,$Size_Y,$Style)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
Return $Combo
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
GUICtrlSetDefColor(0xFFFFFF,$MainGUI)
GUICtrlSetDefBkColor(0x00,$MainGUI)
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
GUICtrlSetFont(-1,9,Default,Default,$MainFontName)
Global $MainGUIButtonClose = GUICtrlCreatePic($sEmpty,$MinWidth-34,0,34,34)
LoadImageResource($MainGUIButtonClose,$MainResourcePath & "CloseNoActivate.jpg","CloseNoActivate")
GUICtrlSetOnEvent($MainGUIButtonClose,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIButtonMaximize = GUICtrlCreatePic($sEmpty,$MinWidth-(34*2),0,34,34)
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize1NoActivate.jpg","Maximize1NoActivate")
GUICtrlSetOnEvent($MainGUIButtonMaximize,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIButtonMinimize = GUICtrlCreatePic($sEmpty,$MinWidth-(34*3),0,34,34)
LoadImageResource($MainGUIButtonMinimize,$MainResourcePath & "MinimizeNoActivate.jpg","MinimizeNoActivate")
GUICtrlSetOnEvent($MainGUIButtonMinimize,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Local $Text = "Discovery"
If $ProgramState <> $sEmpty Then $Text = $ProgramState
Global $MainGUILabelProgramState = GUICtrlCreateLabelTransparentBG("("&$Text&" mode)",-1000,18,-1,14,$SS_RIGHT)
Local $Width = ControlGetPos($MainGUI,"",$MainGUILabelProgramState)[2] + 25
GUICtrlSetPos(-1,$MinWidth - $Width - 102,18,$Width,14)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Local $Text = "v"&$ProgramVersion
If $UpdateAvailable Then $Text = "(Update Available) v"&$ProgramVersion
Global $MainGUILabelVersion = GUICtrlCreateLabelTransparentBG($Text,-1000,4,-1,14,$SS_RIGHT)
Local $Width = ControlGetPos($MainGUI,"",$MainGUILabelVersion)[2] + 25
GUICtrlSetPos(-1,$MinWidth - $Width - 105,4,$Width,14)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIMenuBackground = GUICtrlCreatePic($sEmpty,0,36,50,$MinHeight-204)
LoadImageResource($MainGUIMenuBackground,$MainResourcePath & "MenuBG.jpg","MenuBG")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetState(-1,$GUI_DISABLE)
Local $Obj = CreateMenuObject("Home")
Global $HomeIconHover = $Obj[0], $HomeIcon = $Obj[1], $HomeIconSelector = $Obj[2]
GUICtrlSetState($HomeIconSelector,$GUI_SHOW)
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
_GIF_ExitAnimation($SplashScreenGUIAnimation)
GUIDelete($SplashScreenGUI)
$SplashScreenGUI = NULL
WinMove($MainGUI,$sEmpty,$ScrW/2 -($MinWidth/2),$ScrH/2 -($MinHeight/2))
GUISetState(@SW_SHOWNOACTIVATE,$MainGUI)
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
Global $HoverInfoGUIImageAnimation
If @Compiled Then
$HoverInfoGUIImageAnimation = _GUICtrlCreateGIF(@AutoItExe,"RES;PreloadGIF",0,0,0,0)
Else
$HoverInfoGUIImageAnimation = _GUICtrlCreateGIF($MainResourcePath & "Preload.gif",Default,0,0,0,0)
EndIf
_GIF_PauseAnimation($HoverInfoGUIImageAnimation)
GUICtrlSetState(-1,$GUI_DISABLE)
GUISetState(@SW_SHOWNOACTIVATE,$HoverInfoGUI)
GUISwitch($MainGUI)
Global $MainGUIHomeLabelWelcome = GUICtrlCreateLabelTransparentBG("Welcome! Thank you for choosing the SMITE Optimizer!",93,65,700,30)
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,20,500,Default,$MainFontName)
Global $MainGUIHomeLabelGetStarted = GUICtrlCreateLabelTransparentBG("Please select which Game Launcher you used to install SMITE on your System.",205,100,700,30)
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
Global $MainGUIHomeButtonMoreOptions = GUICtrlCreateButton("More Options",379,379,100,25)
GUICtrlSetOnEvent($MainGUIHomeButtonMoreOptions,"SetupPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetBkColor(-1,0x00F)
GUICtrlSetColor(-1,0xFFFFFF)
Global $MainGUIHomeLabelLogoCopyright = GUICtrlCreateLabelTransparentBG("Logos shown are subject to Copyright and are Trademarked by their respective companies and were used under the 'Fair Use' agreement.",5,430,850,16)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MainFontName)
Global $MainGUIHomeButtonApply = GUICtrlCreateButton("Apply Changes",696,401,100,35)
GUICtrlSetOnEvent($MainGUIHomeButtonApply,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIHomeButtonFixConfig = GUICtrlCreateButton("Verify and Repair",696-105,401,100,35)
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
Global $MainGUIHomeButtonUseMaxPerformance = GUICtrlCreateButton("Use high performance Settings",157,401,200,35)
GUICtrlSetOnEvent($MainGUIHomeButtonUseMaxPerformance,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIHomeButtonRestoreDefaults = GUICtrlCreateButton("Restore default Settings",362,401,150,35)
GUICtrlSetOnEvent($MainGUIHomeButtonRestoreDefaults,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIHomeCheckboxDisplayHints = GUICtrlCreateCheckboxTransparentBG(160,384,13,13)
GUICtrlSetOnEvent($MainGUIHomeCheckboxDisplayHints,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$ProgramHomeHelpState)
Global $MainGUIHomeLabelDisplayHints = GUICtrlCreateLabelTransparentBG("Show Help",178,384,-1,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $AvailableResolutions[0]
Local $AvailableResolutionsStr
Local $objWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")
Local $colItems = $objWMIService.ExecQuery("Select * from CIM_VideoControllerResolution")
Sleep(10)
For $objItem in $colItems
Local $Count = uBound($AvailableResolutions)
ReDim $AvailableResolutions[$Count+1]
$AvailableResolutions[$Count] = StringLeft($objItem.SettingID,StringInStr($objItem.SettingID,"x",0,2)-2)
Next
If uBound($AvailableResolutions) = 0 Then
MsgBox($MB_OK,"Error!","A fatal error has occured. Code: 008"&@CRLF&"You will only be able to select your current screen resolution."&@CRLF&"Restarting the program might fix this.")
ReDim $AvailableResolutions[1]
$AvailableResolutions[0] = @DesktopWidth&"x"&@DesktopHeight
Else
For $I = uBound($AvailableResolutions)-1 To 0 Step -1
If StringLeft($AvailableResolutions[$I],StringInStr($AvailableResolutions[$I],"x")-1) < 800 or StringMid($AvailableResolutions[$I],StringInStr($AvailableResolutions[$I],"x")+2) < 600 Then
_ArrayDelete($AvailableResolutions,$I)
EndIf
Next
$AvailableResolutions = _ArrayUnique($AvailableResolutions)
_ArrayDelete($AvailableResolutions,0)
_ArraySort($AvailableResolutions,1,default,default,default,2)
If $AvailableResolutions[0] = "800 x 600" Then
_ArrayDelete($AvailableResolutions,0)
_ArrayAdd($AvailableResolutions,"800 x 600")
EndIf
EndIf
For $I = 0 To uBound($AvailableResolutions) - 1 Step 1
$AvailableResolutionsStr = $AvailableResolutionsStr & $AvailableResolutions[$I]&"|"
Next
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
Global $MainGUIHomeSimpleInputMaxFPS = GUICtrlCreateInput($sEmpty,100,288,190,21)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetLimit(-1,3)
Global $MainGUIHomeSimpleLabelScreenRes = GUICtrlCreateLabelTransparentBG("Resolution",300,74,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleComboScreenRes = GUICtrlCreateComboNoTheme($sEmpty,300,88,190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetData(-1,$AvailableResolutionsStr)
Global $MainGUIHomeSimpleLabelScreenResScale = GUICtrlCreateLabelTransparentBG("Resolution Scale",300,114,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeSimpleSliderScreenResScale = GUICtrlCreateSlider(300,128,190,21)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetLimit(-1,200,50)
Global $MainGUIHomeSimpleInputScreenResScale = GUICtrlCreateInput($sEmpty,500,128,40,21,$ES_READONLY)
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
If @OSVersion = "WIN_XP" or @OSVersion = "WIN_VISTA" or @OSVersion = "WIN_XPe" or @OSVersion = "WIN_2008R2" or @OSVersion = "WIN_2008" or @OSVersion = "WIN_2003" Then
GUICtrlSetState($MainGUIHomeSimpleCheckboxDirectX11,$GUI_DISABLE)
EndIf
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
Global $MainGUIHomeSimpleLabelHighQualityMats = GUICtrlCreateLabelTransparentBG("Use Uncompressed Textures",613,256,235,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $LastScreenResScaleSimple
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
Global $MainGUIHomeAdvancedLabelScreenResScale = GUICtrlCreateLabelTransparentBG("Resolution Scale",255,159,200,13)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIHomeAdvancedSliderScreenResScale = GUICtrlCreateSlider(255,173,190,21)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetLimit(-1,200,50)
Global $MainGUIHomeAdvancedInputScreenResScale = GUICtrlCreateInput($sEmpty,455,173,40,21,$ES_READONLY)
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
Global $MainGUIHomeAdvancedInputMaxFPS = GUICtrlCreateInput($sEmpty,255,333,190,21)
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
If @OSVersion = "WIN_XP" or @OSVersion = "WIN_VISTA" or @OSVersion = "WIN_XPe" or @OSVersion = "WIN_2008R2" or @OSVersion = "WIN_2008" or @OSVersion = "WIN_2003" Then
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDX11,$GUI_DISABLE)
EndIf
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
Global $MainGUIHomeAdvancedLabelUncText = GUICtrlCreateLabelTransparentBG("Use Uncompressed Textu.",473,333,140,13)
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
Global $LastScreenResScaleAdvanced
GUICtrlSetData($MainGUIHomeSimpleInputScreenResScale,GUICtrlRead($MainGUIHomeSimpleSliderScreenResScale)&"%")
GUICtrlSetData($MainGUIHomeAdvancedInputScreenResScale,GUICtrlRead($MainGUIHomeAdvancedSliderScreenResScale)&"%")
Global $MainGUIRestoreConfigurationsListFiles = GUICtrlCreateList($sEmpty,57,43,746,239,BitOR($WS_BORDER,$WS_VSCROLL,$LBS_NOINTEGRALHEIGHT))
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
Internal_UpdateRestoreConfigList()
Global $MainGUIRestoreConfigurationsLabelBackupPath = GUICtrlCreateLabelTransparentBG("Backup Path:",5,410,75,13)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsInputBackupPath = GUICtrlCreateInput($ConfigBackupPath,5,425,700,20,$ES_READONLY)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
Global $MainGUIRestoreConfigurationsButtonChangeBackupPath = GUICtrlCreateButton("Change..",709,424,97,22)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonChangeBackupPath,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetBkColor(-1,0x00F)
GUICtrlSetColor(-1,0xFFFFFF)
Global $MainGUIRestoreConfigurationsButtonOpenBackupPath = GUICtrlCreateButton("Open Directory",709,399,97,22)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonOpenBackupPath,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetBkColor(-1,0x00F)
GUICtrlSetColor(-1,0xFFFFFF)
Global $MainGUIRestoreConfigurationsButtonRestoreSelected = GUICtrlCreateButton("Restore Selected",704,284,100,35)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonRestoreSelected,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetBkColor(-1,0x00F)
GUICtrlSetColor(-1,0xFFFFFF)
Global $MainGUIRestoreConfigurationsButtonRemoveSelected = GUICtrlCreateButton("Delete Selected",601,284,100,35)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonRemoveSelected,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetBkColor(-1,0x00F)
GUICtrlSetColor(-1,0xFFFFFF)
Global $MainGUIRestoreConfigurationsButtonRefreshList = GUICtrlCreateButton("Refresh list",498,284,100,25)
GUICtrlSetOnEvent($MainGUIRestoreConfigurationsButtonRefreshList,"Internal_UpdateRestoreConfigList")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetBkColor(-1,0x00F)
GUICtrlSetColor(-1,0xFFFFFF)
Global $MainGUIRestoreConfigurationsCheckboxAskForConfirmation = GUICtrlCreateCheckboxTransparentBG(610,325,15,15)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_CHECKED)
Global $MainGUIRestoreConfigurationsLabelAskForConfirmation = GUICtrlCreateLabelTransparentBG("Ask to confirm action?",630,326,125,15)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $MainGUIRestoreConfigurationsLabelBackupInfo = GUICtrlCreateLabelTransparentBG("Backups of your configuration files are created automagically for you."&@CRLF&"Dates shown are in the following format: DD/MM/YYYY."&@CRLF&"The other numbers are the time at which the backup was made.",57,283,425,41)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Local $Year = 2021
Global $MainGUIDonateButtonPaypal = GUICtrlCreatePic($sEmpty,136,168,250,110)
LoadImageResource($MainGUIDonateButtonPaypal,$MainResourcePath & "PayPalBtnInActive.jpg","PayPalBtnInActive")
GUICtrlSetOnEvent($MainGUIDonateButtonPaypal,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIDonateButtonPatreon = GUICtrlCreatePic($sEmpty,474,168,250,110)
LoadImageResource($MainGUIDonateButtonPatreon,$MainResourcePath & "PatreonBtnInActive.jpg","PatreonBtnInActive")
GUICtrlSetOnEvent($MainGUIDonateButtonPatreon,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIDonateLabelInfo = GUICtrlCreateLabelTransparentBG("Feeling generous? This is the place where you can show your appreciation for the project!",74,92,850,30)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,12,500,Default,$MainFontName)
Global $MainGUIDonateLabelInfo2 = GUICtrlCreateLabelTransparentBG("Thank you for your interest in donating. Any support is always greatly appreciated! <3",85,332,850,30)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,12,500,Default,$MainFontName)
Global $MainGUIDonateLabelLogoCopyrightPatreon = GUICtrlCreateLabelTransparentBG('Patreon (C) '&$Year&' Patreon, Inc. Logo and Wordmark used with permission as defined in "Brand Guidelines".',5,412,850,16)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,10,500,Default,$MainFontName)
Global $MainGUIDonateLabelLogoCopyrightPayPal = GUICtrlCreateLabelTransparentBG('PayPal (C) 1999-'&$Year&' PayPal. All Rights reserved. Logo used with permission as defined in "PayPal'&"'s trademarks"&'".',5,430,850,16)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,10,500,Default,$MainFontName)
Global $MainGUIChangelogRichEdit = GUICtrlCreateEdit($ChangelogText,55,41,$MinWidth-60,$MinHeight-46,BitOr($ES_READONLY,$WS_VSCROLL))
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
Global $MainGUIChangelogButtonViewOnlineBG = GUICtrlCreatePic($sEmpty,2,344,48,40)
LoadImageResource($MainGUIChangelogButtonViewOnlineBG,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
GUICtrlSetOnEvent($MainGUIChangelogButtonViewOnlineBG,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIChangelogButtonViewOnline = GUICtrlCreatePic($sEmpty,12,349,30,30)
LoadImageResource($MainGUIChangelogButtonViewOnline,$MainResourcePath & "ChangelogIconInActive.jpg","ChangelogIconInActive")
GUICtrlSetOnEvent($MainGUIChangelogButtonViewOnline,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
GUICtrlSetStyle(-1,$WS_EX_TOPMOST)
Global $MainGUICopyrightAnimatedLogo
If @Compiled Then
$MainGUICopyrightAnimatedLogo = _GUICtrlCreateGIF(@AutoItExe,"RES;SO_LogoGIF",130,50,600,100)
Else
$MainGUICopyrightAnimatedLogo = GUICtrlCreatePic($sEmpty,130,50,600,100)
LoadImageResource($MainGUICopyrightAnimatedLogo,$MainResourcePath & "SO_Logo.jpg","SO_Logo")
EndIf
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
_GIF_PauseAnimation($MainGUICopyrightAnimatedLogo)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUICopyrightPicLogo = GUICtrlCreatePic($sEmpty,130,50,600,100)
LoadImageResource($MainGUICopyrightPicLogo,$MainResourcePath & "SO_Logo.jpg","SO_Logo")
GUICtrlSetResizing(-1,$GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUICopyrightLabelInfo = GUICtrlCreateLabelTransparentBG("A Project brought to life by Meteor (MrRangerLP) in 2017 and still being worked on in "&$Year&"",69,160,730,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,12,500,Default,$MainFontName)
Global $MainGUICopyrightLabelLicense = GUICtrlCreateLabelTransparentBG('This Project is licensed under the "GNU GPL-3.0" License. Do note that only version 1.3 and above fall under this license.',64,194,735,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MainFontName)
Global $MainGUICopyrightLabelLicense2 = GUICtrlCreateLabelTransparentBG("Earlier versions are subject to Copyright (C) and may not be copied, shared, modified, or distributed.",124,213,615,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MainFontName)
Global $MainGUICopyrightLabelCopyright = GUICtrlCreateLabelTransparentBG('SMITE Optimizer Version 1.0 - 1.2.2 Copyright (C) 2019 - Mario "Meteor Thuri" Schien.',175,248,600,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MainFontName)
Global $MainGUICopyrightLabelCopyright2 = GUICtrlCreateLabelTransparentBG('SMITE Optimizer Version 1.3 and above Copyright (C) '&$Year&' - Mario "Meteor Thuri" Schien.',169,266,600,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MainFontName)
Global $MainGUICopyrightLabelSMITECopyright = GUICtrlCreateLabelTransparentBG("SMITE(R), Battleground of the Gods(TM) Copyright (C) "&$Year&" Hi-Rez Studios, INC. All rights reserved.",133,284,600,18)
GUICtrlSetResizing(-1,$GUI_DOCKHCENTER + $GUI_DOCKVCENTER + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetFont(-1,9,500,Default,$MainFontName)
Global $MainGUICopyrightLabelContact = GUICtrlCreateLabelTransparentBG("Contact: MrRangerLP (at) gmx.de",103,337,250,20)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,11,500,Default,$MainFontName)
Global $MainGUICopyrightPicBGLeft = GUICtrlCreatePic($sEmpty,95,361,219,50)
LoadImageResource($MainGUICopyrightPicBGLeft,$MainResourcePath & "CopyrightFooterBGLeft.jpg","CopyrightFooterBGLeft")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUICopyrightLabelVersionFooter = GUICtrlCreateLabelTransparentBG("SMITE Optimizer Version "&$ProgramVersion,103,362,250,18)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,11,500,Default,$MainFontName)
Global $MainGUICopyrightLabelLicenseLink = GUICtrlCreateLabelTransparentBG("License",102,386,70,23)
GUICtrlSetOnEvent($MainGUICopyrightLabelLicenseLink,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,0x4F89EA)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUICopyrightLabelSourceLink = GUICtrlCreateLabelTransparentBG("Source",193,386,65,23)
GUICtrlSetOnEvent($MainGUICopyrightLabelSourceLink,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,0x4F89EA)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUICopyrightPicBGRight = GUICtrlCreatePic($sEmpty,342,361,373,50)
LoadImageResource($MainGUICopyrightPicBGRight,$MainResourcePath & "CopyrightFooterBGRight.jpg","CopyrightFooterBGRight")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUICopyrightLabelAutoItCopyright = GUICtrlCreateLabelTransparentBG("AutoIt v3 Copyright (C) 2019 AutoIt Consulting Ltd.",352,365,375,18)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetFont(-1,10,500,Default,$MainFontName)
Global $MainGUICopyrightLabelAutoitLicenseLink = GUICtrlCreateLabelTransparentBG("AutoIt v3 License",537,386,170,23)
GUICtrlSetOnEvent($MainGUICopyrightLabelAutoitLicenseLink,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,0x4F89EA)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
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
Global $MainGUIDebugPicDebugFooterFooter = GUICtrlCreatePic($sEmpty,60,308,360,131)
LoadImageResource($MainGUIDebugPicDebugFooterFooter,$MainResourcePath & "DebugFooter.jpg","DebugFooter")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUIDebugLabelReportABug = GUICtrlCreateLabelTransparentBG("Report a Bug",67,408,120,24)
GUICtrlSetOnEvent($MainGUIDebugLabelReportABug,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,0x4F89EA)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUIDebugLabelCreateDebugInfo = GUICtrlCreateLabelTransparentBG("Create debug dump",212,408,178,24)
GUICtrlSetOnEvent($MainGUIDebugLabelCreateDebugInfo,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetColor(-1,0x4F89EA)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetCursor(-1,0)
Global $MainGUIDebugEditSystemInfo = GUICtrlCreateEdit($TempN[uBound($TempN)-1]&" PID("&@AutoItPID&")"&@CRLF&@UserName&" | ( "&@OSVersion&" "&@OSArch&" )"&@CRLF&"CPU: "&$SysInfoRead&@CRLF&regRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment","NUMBER_OF_PROCESSORS")&" Thread(s) @ "&RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~MHz")&" MHz | Architecture: "&@CPUArch&@CRLF&"RAM: "&Floor((MemGetStats()[1]/1000000))&" GB | ( "&Round((MemGetStats()[1]/1000000),2)&" GB )"&@CRLF&"GPU: "&$SysInfoOutput&@CRLF&"Mainboard: "&regRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS","BaseBoardManufacturer")&" | "&regRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS","BaseBoardProduct")&" | Last BIOS update: "&regRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\BIOS","BIOSReleaseDate"),67,311,400,94,BitOr($ES_READONLY,$ES_WANTRETURN),0)
DllCall("UxTheme.dll","int","SetWindowTheme","hwnd",GUICtrlGetHandle(-1),"wstr",0,"wstr",0)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
Local $DebugEngineSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
If @Error Then $DebugEngineSettingsPath = "Not yet defined"
Global $MainGUIDebugLabelEngineSettings = GUICtrlCreateLabelTransparentBG("EngineSettings: "&$DebugEngineSettingsPath,55,40,750,40)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Local $DebugSystemSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
If @Error Then $DebugSystemSettingsPath = "Not yet defined"
Global $MainGUIDebugLabelSystemSettings = GUICtrlCreateLabelTransparentBG("SystemSettings: "&$DebugSystemSettingsPath,55,80,750,35)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Local $DebugConfigBackupPath = $ConfigBackupPath
If $ConfigBackupPath = $sEmpty Then $DebugConfigBackupPath = "Not yet defined"
Global $MainGUIDebugLabelConfigBackupPath = GUICtrlCreateLabelTransparentBG("Backup Path: "&$DebugConfigBackupPath,55,120,750,35)
GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $MainGUIDebugButtonResetConfigPaths = GUICtrlCreateButton("Reset Configuration Paths",626,401,170,35)
GUICtrlSetOnEvent($MainGUIDebugButtonResetConfigPaths,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetBkColor(-1,0x00F)
GUICtrlSetColor(-1,0xFFFFFF)
Global $MainGUIDebugCheckboxCheckForUpdates = GUICtrlCreateCheckboxTransparentBG(627,383,13,13)
GUICtrlSetOnEvent($MainGUIDebugCheckboxCheckForUpdates,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
If $CheckForUpdates = "1" Then GUICtrlSetState($MainGUIDebugCheckboxCheckForUpdates,$GUI_CHECKED)
Global $MainGUIDebugLabelCheckForUpdates = GUICtrlCreateLabelTransparentBG("Perform Automatic Updates",646,383,150,13)
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
Global $MainGUIDebugButtonPerformUpdate = NULL
If $UpdateAvailable Then
$MainGUIDebugButtonPerformUpdate = GUICtrlCreateButton("Perform Update",540,401,100,35)
GUICtrlSetOnEvent($MainGUIDebugButtonPerformUpdate,"ButtonPressLogic")
GUICtrlSetResizing(-1,$GUI_DOCKBOTTOM + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetBkColor(-1,0x00F)
GUICtrlSetColor(-1,0xFFFFFF)
EndIf
If $SettingsPath = $sEmpty or $SystemSettingsPath = $sEmpty or $ProgramState = $sEmpty Then
$MainGUIHomeDiscoveryDrawn = True
UnDrawMainGUIHome()
Else
UnDrawMainGUIHomeConfigDiscovery()
EndIf
UnDrawMainGUIRestoreConfigs()
UnDrawMainGUIDonate()
UnDrawMainGUIChangelog()
UnDrawMainGUICopyright()
UnDrawMainGUIDebug()
If $ProgramHomeState = "Simple" Then
UnDrawMainGUIHomeAdvanced()
ElseIf $ProgramHomeState = "Advanced" Then
UnDrawMainGUIHomeSimple()
EndIf
Global $MainGUIMenuHoverInfo = GUICtrlCreatePic($sEmpty,-90,-42,90,42)
LoadImageResource($MainGUIMenuHoverInfo,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
GUICtrlSetState(-1,$GUI_DISABLE)
Global $MainGUIMenuHoverText = GUICtrlCreateLabelTransparentBG($sEmpty,-90,-42,90,42)
GUICtrlSetFont(-1,25,500,0,$MenuFontName)
GUICtrlSetColor(-1,0x00)
EndFunc
Func DrawMainGUIHomeConfigDiscovery()
GUICtrlSetState($MainGUIHomeLabelWelcome,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeLabelGetStarted,$GUI_SHOW)
GUICtrlSetState($MainGUIHomePicBtnSteam,$GUI_SHOW)
GUICtrlSetState($MainGUIHomePicBtnEGS,$GUI_SHOW)
GUICtrlSetState($MainGUIHomePicBtnLegacy,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeButtonMoreOptions,$GUI_SHOW)
GUICtrlSetState($MainGUIHomeLabelLogoCopyright,$GUI_SHOW)
$MainGUIHomeDiscoveryDrawn = True
EndFunc
Func UnDrawMainGUIHomeConfigDiscovery()
GUICtrlSetState($MainGUIHomeLabelWelcome,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeLabelGetStarted,$GUI_HIDE)
GUICtrlSetState($MainGUIHomePicBtnSteam,$GUI_HIDE)
GUICtrlSetState($MainGUIHomePicBtnEGS,$GUI_HIDE)
GUICtrlSetState($MainGUIHomePicBtnLegacy,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeButtonMoreOptions,$GUI_HIDE)
GUICtrlSetState($MainGUIHomeLabelLogoCopyright,$GUI_HIDE)
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
Func DrawMainGUIDonate()
GUICtrlSetState($MainGUIDonateButtonPaypal,$GUI_SHOW)
GUICtrlSetState($MainGUIDonateButtonPatreon,$GUI_SHOW)
GUICtrlSetState($MainGUIDonateLabelInfo,$GUI_SHOW)
GUICtrlSetState($MainGUIDonateLabelInfo2,$GUI_SHOW)
GUICtrlSetState($MainGUIDonateLabelLogoCopyrightPatreon,$GUI_SHOW)
GUICtrlSetState($MainGUIDonateLabelLogoCopyrightPayPal,$GUI_SHOW)
EndFunc
Func UnDrawMainGUIDonate()
GUICtrlSetState($MainGUIDonateButtonPaypal,$GUI_HIDE)
GUICtrlSetState($MainGUIDonateButtonPatreon,$GUI_HIDE)
GUICtrlSetState($MainGUIDonateLabelInfo,$GUI_HIDE)
GUICtrlSetState($MainGUIDonateLabelInfo2,$GUI_HIDE)
GUICtrlSetState($MainGUIDonateLabelLogoCopyrightPatreon,$GUI_HIDE)
GUICtrlSetState($MainGUIDonateLabelLogoCopyrightPayPal,$GUI_HIDE)
EndFunc
Func DrawMainGUIChangelog()
ControlFocus($MainGUI,"",$MainGUIChangelogRichEdit)
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
_GIF_PauseAnimation($MainGUICopyrightAnimatedLogo)
GUICtrlSetState($MainGUICopyrightPicLogo,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelInfo,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelLicense,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelLicense2,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelCopyright,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelCopyright2,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelSMITECopyright,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelContact,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightPicBGLeft,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelVersionFooter,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelLicenseLink,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelSourceLink,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightPicBGRight,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelAutoItCopyright,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightLabelAutoitLicenseLink,$GUI_SHOW)
EndFunc
Func UnDrawMainGUICopyright()
GUICtrlSetState($MainGUICopyrightAnimatedLogo,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightPicLogo,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelInfo,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelLicense,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelLicense2,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelCopyright,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelCopyright2,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelSMITECopyright,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelContact,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightPicBGLeft,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelVersionFooter,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelLicenseLink,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelSourceLink,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightPicBGRight,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelAutoItCopyright,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightLabelAutoitLicenseLink,$GUI_HIDE)
EndFunc
Func DrawMainGUIDebug()
GUICtrlSetState($MainGUIDebugLabelEngineSettings,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugLabelSystemSettings,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugLabelConfigBackupPath,$GUI_SHOW)
GUICtrlSetState($MainGUIDebugEditSystemInfo,$GUI_SHOW)
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
GUICtrlSetState($MainGUIDebugLabelConfigBackupPath,$GUI_HIDE)
GUICtrlSetState($MainGUIDebugEditSystemInfo,$GUI_HIDE)
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
If $SettingsPath = $sEmpty or $SystemSettingsPath = $sEmpty or $ProgramState = $sEmpty Then
DrawMainGUIHomeConfigDiscovery()
Else
DrawMainGUIHome()
EndIf
$LastMenu = "Home"
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
GUICtrlSetPos($MainGUIMenuHoverInfo,50,$PosY,$SizeX,40)
GUICtrlSetData($MainGUIMenuHoverText,$Text)
GUICtrlSetPos($MainGUIMenuHoverText,57,$TPosY,$SizeX,40)
$MenuPopupState = True
EndFunc
Func UndoMenuHoverState()
GUICtrlSetPos($MainGUIMenuHoverInfo,-$ScrW*2,-$ScrH*2)
GUICtrlSetPos($MainGUIMenuHoverText,-$ScrW*2,-$ScrH*2)
GUICtrlSetData($MainGUIMenuHoverText,$sEmpty)
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
Func DisplayErrorMessage($Message,$Parent = $MainGUI)
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
GUISetBkColor(0x000000)
Local $NotificationGUIBG = GUICtrlCreatePic($sEmpty,0,0,400,150)
LoadImageResource($NotificationGUIBG,$MainResourcePath & "NotificationBG.jpg","NotificationBG")
GUICtrlSetOnEvent($NotificationGUIBG,"HideErrorMessage")
Local $NotificationGUILabelMessage = GUICtrlCreateLabelTransparentBG("ERROR!"&@CRLF&@CRLF&$Message,5,3,390,140)
GUICtrlSetOnEvent($NotificationGUILabelMessage,"HideErrorMessage")
GUICtrlSetColor(-1,0xF0F4F9)
GUICtrlSetFont(-1,10,Default,Default,$MainFontName)
Local $NotificationGUILabelDismiss = GUICtrlCreateLabelTransparentBG("Click to dismiss",5,132,390,13)
GUICtrlSetOnEvent($NotificationGUILabelDismiss,"HideErrorMessage")
GUICtrlSetColor(-1,0xF0F4F9)
GUICtrlSetFont(-1,10,Default,Default,$MainFontName)
GUISetState(@SW_SHOW,$NotificationGUI)
GUISwitch($Parent)
If @OSVersion = "WIN_XP" or @OSVersion = "WIN_XPe" Then _Resource_LoadSound("WIN_XP",0)
If @OSVersion = "WIN_VISTA" or @OSVersion = "WIN_7" or @OSVersion = "WIN_8" or @OSVersion = "WIN_81" Then _Resource_LoadSound("ErrorWIN_7_8",0)
If @OSVersion = "WIN_10" Then _Resource_LoadSound("ErrorWIN_10",0)
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
Func VerifyAndStoreConfigPath($State,$PathSettings,$PathSystemSettings)
If FileExists($PathSettings) and FileExists($PathSystemSettings) Then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigProgramState","REG_SZ",$State)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ",$PathSettings)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ",$PathSystemSettings)
Return True
EndIf
Return False
EndFunc
Func SetupPressLogic()
Local $Found = False
Switch @GUI_CtrlId
Case $MainGUIHomePicBtnSteam
$Found = VerifyAndStoreConfigPath("Steam",@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleEngine.ini",@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini")
If not $Found Then
$Found = VerifyAndStoreConfigPath("Steam","C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini","C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini")
If not $Found Then
$Found = VerifyAndStoreConfigPath("Steam",RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")&"\BattleGame\Config\DefaultEngine.ini",RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")&"\BattleGame\Config\DefaultSystemSettings.ini")
If not $Found Then DisplayErrorMessage("Could not find Configuration files for a SMITE Steam installation. Perhaps it was not installed through Steam?")
EndIf
EndIf
Case $MainGUIHomePicBtnEGS
$Found = VerifyAndStoreConfigPath("Epic Games Store",@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleEngine.ini",@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini")
If not $Found Then
$Found = VerifyAndStoreConfigPath("Epic Games Store","C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini","C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini")
If not $Found Then
Local $Is64 = $sEmpty
If @OSArch = "X64" Then $Is64 = "WOW6432Node\"
Local $EpicProgramData = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\"&$Is64&"Epic Games\EpicGamesLauncher\","AppDataPath")&"Manifests\"
Local $Files = _FileListToArray($EpicProgramData,"*.item",1,True)
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
$EpicProgramData = $NewStr & "\BattleGame\Config\"
ExitLoop(2)
EndIf
Next
Next
If FileExists($EpicProgramData) Then $Found = VerifyAndStoreConfigPath("Epic Games Store",$EpicProgramData&"DefaultEngine.ini",$EpicProgramData&"DefaultSystemSettings.ini")
If not $Found Then DisplayErrorMessage("Could not find Configuration files for a SMITE Epic Games Store installation. Perhaps it was not installed through the Epic Games Store?")
EndIf
EndIf
Case $MainGUIHomePicBtnLegacy
$Found = VerifyAndStoreConfigPath("Legacy",@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleEngine.ini",@MyDocumentsDir & "\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini")
If not $Found Then
$Found = VerifyAndStoreConfigPath("Legacy","C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini","C:\Users\"&@UserName&"\OneDrive\Documents\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini")
If not $Found Then DisplayErrorMessage("Could not find Configuration files for a Legacy installation. Perhaps you do not have the old and unavailable launcher?")
EndIf
Case $MainGUIHomeButtonMoreOptions
If $GUIMoreOptions <> NULL Then GUIDelete($GUIMoreOptions)
GUISetState(@SW_DISABLE,$MainGUI)
Local $WinPos = WinGetPos($MainGUI)
Global $GUIMoreOptions = GUICreate("SO_MOREOPTIONS",600,300,$WinPos[0] +($WinPos[2]/2)-300,$WinPos[1] +($WinPos[3]/2)-150,BitOR($WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$WS_POPUP),$WS_EX_TOOLWINDOW)
_GUI_EnableDrag($GUIMoreOptions,600,300)
GUISetBkColor(0x00)
GUICtrlSetDefColor(0xFFFFFF,$GUIMoreOptions)
GUICtrlSetDefBkColor(0x00,$GUIMoreOptions)
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
GUISetBkColor(0x00)
GUICtrlSetDefColor(0xFFFFFF,$GUIMoreOptions)
GUICtrlSetDefBkColor(0x00,$GUIMoreOptions)
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
Sleep(1)
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
ReturnToMainGUI()
DisplayErrorMessage("Failed to write index batch file!")
ExitLoop(2)
EndIf
$IndexerPID = Run(@TempDir & "\SO_Index.bat",$sEmpty,@SW_HIDE)
If @Error <> 0 Then
ReturnToMainGUI()
DisplayErrorMessage("An error occured when attempting to run the index function.")
ExitLoop(2)
EndIf
$ScanState = True
ElseIf not ProcessExists($IndexerPID) Then
GUICtrlSetPos($GUIMoreOptionsLabelScanState,35,124,400,50)
GUICtrlSetData($GUIMoreOptionsLabelScanState,"Processing index of drive "&$FixedDrives[$DriveIndex]&":\")
If not FileExists(@TempDir&"\SO_Index.txt") Then
ReturnToMainGUI()
DisplayErrorMessage("Failed to read index output!")
ExitLoop(2)
EndIf
$DriveIndex = $DriveIndex + 1
If $DriveIndex > uBound($FixedDrives)-1 Then
ReturnToMainGUI()
DisplayErrorMessage("Could not find any configuration files on your system.")
ExitLoop(2)
EndIf
Local $File = FileReadToArray(@TempDir & "\SO_Index.txt")
If @Error <> 0 Then
ReturnToMainGUI()
DisplayErrorMessage("Failed to read index output!")
ExitLoop(2)
EndIf
Local $SettingsEnginePath
Local $SettingsSystemPath
For $I = 0 To uBound($File) - 1 Step 1
If StringRight($File[$I],16) = "BattleEngine.ini" or StringRight($File[$I],17) = "DefaultEngine.ini" Then
$SettingsEnginePath = $File[$I]
ElseIf StringRight($File[$I],24) = "BattleSystemSettings.ini" or StringRight($File[$I],25) = "DefaultSystemSettings.ini" Then
$SettingsSystemPath = $File[$I]
EndIf
If $SettingsEnginePath <> $sEmpty and $SettingsSystemPath <> $sEmpty Then ExitLoop
Next
If $SettingsEnginePath <> $sEmpty and $SettingsSystemPath <> $sEmpty Then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigProgramState","REG_SZ","Custom Files")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ",$SettingsEnginePath)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ",$SettingsSystemPath)
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
Local $FileSettings = FileOpenDialog("Please Select BattleEngine.ini or DefaultEngine.ini",@DesktopDir,"INI Files (*.ini)",BitOr($FD_FILEMUSTEXIST,$FD_PATHMUSTEXIST),"BattleEngine.ini")
If @Error = 0 Then
If StringLower(StringRight($FileSettings,16)) <> "battleengine.ini" and StringLower(StringRight($FileSettings,17)) <> "defaultengine.ini" Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
$MSearchState = False
DisplayErrorMessage("Invalid file selected!",$GUIMoreOptions)
Else
Local $FileSystemSettings = FileOpenDialog("Please Select BattleSystemSettings.ini or DefaultSystemSettings.ini",@DesktopDir,"INI Files (*.ini)",BitOr($FD_FILEMUSTEXIST,$FD_PATHMUSTEXIST),"BattleSystemSettings.ini")
If @Error = 0 Then
If StringLower(StringRight($FileSystemSettings,24)) <> "battlesystemsettings.ini" and StringLower(StringRight($FileSystemSettings,25)) <> "defaultsystemsettings.ini" Then
LoadImageResource($GUIMoreOptionsMSearch,$MainResourcePath & "MSearchBtnInActive.jpg","MSearchBtnInActive")
$MSearchState = False
DisplayErrorMessage("Invalid file selected!",$GUIMoreOptions)
Else
$Found = True
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigProgramState","REG_SZ","Custom Files")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ",$FileSettings)
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ",$FileSystemSettings)
ReturnToMainGUI()
ExitLoop
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
Sleep(1)
Else
If WinGetTitle("[active]") = $ProgramName Then WinActivate($GUIMoreOptions)
Sleep(100)
EndIf
WEnd
EndSwitch
If not $Found Then Return
$ProgramState = RegRead("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
$SettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
$SystemSettingsPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
Local $Text = "Discovery"
If $ProgramState <> $sEmpty Then $Text = $ProgramState
Local $WinWidth = WinGetPos($MainGUI)[2]
GUICtrlDelete($MainGUILabelProgramState)
$MainGUILabelProgramState = GUICtrlCreateLabelTransparentBG("("&$Text&" mode)",-1000,18,-1,14,$SS_RIGHT)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Local $Width = ControlGetPos($MainGUI,"",$MainGUILabelProgramState)[2] + 25
GUICtrlSetPos(-1,$WinWidth - $Width - 102,18,$Width,14)
Local $Text = "Discovery"
If $ProgramState <> $sEmpty Then $Text = $ProgramState
GUICtrlSetData($MainGUIDebugLabelEngineSettings,"EngineSettings: "&$SettingsPath)
GUICtrlSetData($MainGUIDebugLabelSystemSettings,"SystemSettings: "&$SystemSettingsPath)
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
Else
WinSetState($MainGUI,$sEmpty,@SW_MAXIMIZE)
$MainGUIMaximizedState = True
LoadImageResource($MainGUIButtonMaximize,$MainResourcePath & "Maximize2NoActivate.jpg","Maximize2NoActivate")
EndIf
Case $MainGUIButtonMinimize
WinSetState($MainGUI,$sEmpty,@SW_MINIMIZE)
Case $HomeIcon, $HomeIconHover
If $MenuSelected <> 1 Then
$MenuSelected = 1
ToggleMenuState("Home")
EndIf
Case $RCIcon, $RCIconHover
If $MenuSelected <> 2 Then
$MenuSelected = 2
ToggleMenuState("RestoreConfigs")
EndIf
Case $DonateIcon, $DonateIconHover
If $MenuSelected <> 3 Then
$MenuSelected = 3
ToggleMenuState("Donate")
EndIf
Case $ChangelogIcon, $ChangelogIconHover
If $MenuSelected <> 4 Then
$MenuSelected = 4
ToggleMenuState("Changelog")
EndIf
Case $CopyrightIcon, $CopyrightIconHover
If $MenuSelected <> 5 Then
$MenuSelected = 5
ToggleMenuState("Copyright")
EndIf
Case $DebugIcon, $DebugIconHover
If $MenuSelected <> 6 Then
$MenuSelected = 6
ToggleMenuState("Debug")
EndIf
Case $MainGUIHomeButtonApply
Internal_ProcessRequest(True)
Case $MainGUIHomeButtonFixConfig
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
Internal_LoadSettingCookies(True)
Case $MainGUIHomeButtonUseMaxPerformance
Internal_LoadSettingCookies(True,True)
Case $MainGUIHomeCheckboxDisplayHints
Local $CDHState = GUICtrlRead($MainGUIHomeCheckboxDisplayHints)
$ProgramHomeHelpState = $CDHState
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigShowHints","REG_SZ",$CDHState)
If $ProgramHomeHelpState = $GUI_UNCHECKED Then
GUICtrlSetPos($MainGUIHomeHelpBackground,-$MinWidth,-$MinHeight,1,1)
$HoverBGDrawn = False
WinMove($HoverInfoGUI,$sEmpty,-$ScrW*2,-$ScrH*2,0,0)
$HoverImageDrawn = False
EndIf
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
DisplayErrorMessage("The selected path is to long!")
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
If $Error = 0 Then DisplayErrorMessage("The selected Backup could not be deleted!"&@CRLF&"It appears it was already deleted by another program, or maybe you?")
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
If not FileExists($ConfigBackupPath&$TPath&"\Engine.ini") or not FileExists($ConfigBackupPath&$TPath&"\SystemSettings.ini") Then
DisplayErrorMessage("Attempted to restore backup but it appears to be missing or corrupted! Code: 009")
Internal_UpdateRestoreConfigList()
Else
Local $CopySucc = FileCopy($ConfigBackupPath&$TPath&"\Engine.ini",$SettingsPath,$FC_OVERWRITE)
If $CopySucc = 0 Then
DisplayErrorMessage("There was an error copying one of the files! Code: 001")
Else
Local $CopySucc = FileCopy($ConfigBackupPath&$TPath&"\SystemSettings.ini",$SystemSettingsPath,$FC_OVERWRITE)
If $CopySucc = 0 Then
DisplayErrorMessage("There was an error copying one of the files! Code: 002")
Else
DirRemove($ConfigBackupPath&$TPath,$DIR_REMOVE)
Internal_UpdateRestoreConfigList()
EndIf
EndIf
EndIf
EndIf
Case $MainGUIDonateButtonPaypal
ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=2NKTRNN5BTHHG")
LoadImageResource($MainGUIDonateButtonPaypal,$MainResourcePath & "PayPalBtnInActive.jpg","PayPalBtnInActive")
Case $MainGUIDonateButtonPatreon
ShellExecute("https://www.patreon.com/SMITEOptimizer")
LoadImageResource($MainGUIDonateButtonPatreon,$MainResourcePath & "PatreonBtnInActive.jpg","PatreonBtnInActive")
Case $MainGUIChangelogButtonViewOnline, $MainGUIChangelogButtonViewOnlineBG
ShellExecute("https://github.com/MeteorTheLizard/SMITE-Optimizer/commits/master")
Case $MainGUICopyrightLabelLicenseLink
_Resource_SaveToFile(@TempDir & "\GPL_License.txt","GPL_License")
If FileExists(@TempDir & "\GPL_License.txt") Then ShellExecute(@TempDir & "\GPL_License.txt")
Case $MainGUICopyrightLabelSourceLink
ShellExecute("https://github.com/MeteorTheLizard/SMITE-Optimizer")
Case $MainGUICopyrightLabelAutoitLicenseLink
_Resource_SaveToFile(@TempDir & "\AutoIt_License.txt","AutoIt_License")
If FileExists(@TempDir & "\AutoIt_License.txt") Then ShellExecute(@TempDir & "\AutoIt_License.txt")
Case $MainGUIDebugCheckboxCheckForUpdates
Local $CDHState = GUICtrlRead($MainGUIDebugCheckboxCheckForUpdates)
If $CDHState <> $GUI_CHECKED Then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigCheckForUpdates","REG_SZ","0")
Else
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigCheckForUpdates")
EndIf
Case $MainGUIDebugButtonPerformUpdate
RegWrite("HKCU\Software\SMITE Optimizer\","DebugForceUpdate","REG_SZ","1")
Run(@ScriptFullPath)
Exit
Case $MainGUIDebugLabelReportABug
ShellExecute("https://github.com/MeteorTheLizard/SMITE-Optimizer/issues")
Case $MainGUIDebugLabelCreateDebugInfo
Local $sDirSelect = FileSelectFolder("Choose a folder to save the debug dump into",@DesktopDir)
If Not @Error Then
DirRemove(@TempDir & "\optimizerdebugdump",$DIR_REMOVE)
Sleep(350)
DirCreate(@TempDir & "\optimizerdebugdump")
If Not @Error Then
FileWrite(@TempDir & "\optimizerdebugdump\systeminfobox.txt",GUICtrlRead($MainGUIDebugEditSystemInfo))
DirCreate(@TempDir & "\optimizerdebugdump\logs\launch")
FileCopy("C:\Users\" & @UserName &"\Documents\My Games\SMITE\BattleGame\Logs\*.log",@TempDir & "\optimizerdebugdump\logs\launch\",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy("C:\Users\" & @UserName &"\OneDrive\Documents\My Games\SMITE\BattleGame\Logs\*.log",@TempDir & "\optimizerdebugdump\logs\launch\",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy($SettingsPath,@TempDir & "\optimizerdebugdump\config\EngineSettings.ini",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy($SystemSettingsPath,@TempDir & "\optimizerdebugdump\config\SystemSettings.ini",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy("C:\Users\" & @UserName & "\AppData\Roaming\EasyAntiCheat\*.log",@TempDir & "\optimizerdebugdump\logs\*.log",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
FileCopy("C:\Users\" & @UserName & "\AppData\Roaming\EasyAntiCheat\140\*.log",@TempDir & "\optimizerdebugdump\logs\*.log",BitOr($FC_OVERWRITE,$FC_CREATEPATH))
ShellExecute("dxdiag",'/dontskip /whql:off /t "' & @TempDir & '\optimizerdebugdump\dxdiag.txt"')
While ProcessExists("dxdiag.exe")
WEnd
local $file_Zip = _Zip_Create($sDirSelect & "\SMITE_Optimizer_Debug.zip",1)
_Zip_AddItem($file_Zip,@TempDir & "\optimizerdebugdump\")
DirRemove(@TempDir & "\optimizerdebugdump",$DIR_REMOVE)
MsgBox(0,"Success","Debug dump successfully created!")
EndIf
EndIf
Case $MainGUIDebugButtonResetConfigPaths
GUISetState(@SW_DISABLE,$MainGUI)
Local $Msg = MsgBox($MB_YESNO,"Confirm action","Are you sure that you want to reset the configuration paths?",Default,$MainGUI)
If $Msg == $IDYES Then
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigProgramState")
$SettingsPath = $sEmpty
$SystemSettingsPath = $sEmpty
$ProgramState = $sEmpty
Local $WinWidth = WinGetPos($MainGUI)[2]
GUICtrlDelete($MainGUILabelProgramState)
$MainGUILabelProgramState = GUICtrlCreateLabelTransparentBG("(Discovery mode)",-1000,18,-1,14,$SS_RIGHT)
GUICtrlSetResizing(-1,$GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Local $Width = ControlGetPos($MainGUI,"",$MainGUILabelProgramState)[2] + 25
GUICtrlSetPos(-1,$WinWidth - $Width - 102,18,$Width,14)
GUICtrlSetData($MainGUIDebugLabelEngineSettings,"EngineSettings: Not yet defined")
GUICtrlSetData($MainGUIDebugLabelSystemSettings,"SystemSettings: Not yet defined")
$MenuSelected = 1
ToggleMenuState("Home")
EndIf
GUISetState(@SW_ENABLE,$MainGUI)
EndSwitch
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
$Int_Settings = "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & "300|" & $AvailableResolutions[0] & "|" & "100|" & "Fullscreen|" & "Off|" & "Off|" & "0|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED
EndIf
Local $Split = StringSplit($Int_Settings,"|")
_ArrayDelete($Split,0)
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboWorldQuality,$Split[0])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboCharacterQuality,$Split[1])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboShadowQuality,$Split[2])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboSkyQuality,$Split[3])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboEffectsParticleQuality,$Split[4])
GUICtrlSetData($MainGUIHomeSimpleInputMaxFPS,$Split[5])
Local $Res = _GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,$Split[6])
If $Res = -1 Then _GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboScreenRes,$AvailableResolutions[0])
GUICtrlSetData($MainGUIHomeSimpleSliderScreenResScale,$Split[7])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboWindowmode,$Split[8])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboAntialiasing,$Split[9])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboMaxAnisotropy,$Split[10])
_GUICtrlComboBox_SelectString($MainGUIHomeSimpleComboDetailMode,$Split[11])
GUICtrlSetState($MainGUIHomeSimpleCheckboxVSync,Internal_ConvertMagicNumber($Split[12]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxRagdollPhysics,Internal_ConvertMagicNumber($Split[13]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxDirectX11,Internal_ConvertMagicNumber($Split[14]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxBloom,Internal_ConvertMagicNumber($Split[15]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxDecals,Internal_ConvertMagicNumber($Split[16]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxDynamicLightShadows,Internal_ConvertMagicNumber($Split[17]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxLensflares,Internal_ConvertMagicNumber($Split[18]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxReflections,Internal_ConvertMagicNumber($Split[19]))
GUICtrlSetState($MainGUIHomeSimpleCheckboxHighQualityMats,Internal_ConvertMagicNumber($Split[20]))
EndIf
If $ProgramHomeState = "Advanced" or $InitBool Then
If not $Performance Then
$Int_Settings = RegRead("HKCU\Software\SMITE Optimizer\","ConfigCookieAdvanced")
If @Error or $Bool Then
$Int_Settings = "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & "Best|" & $AvailableResolutions[0] & "|" & "100|" & "Fullscreen|" & "High|" & "16x|" & "150|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & "2|" & "2|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED & "|" & $GUI_CHECKED
EndIf
Else
$Int_Settings = "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & "Low|" & $AvailableResolutions[0] & "|" & "100|" & "Fullscreen|" & "Off|" & "Off|" & "300|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & "0|" & "0|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_CHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED & "|" & $GUI_UNCHECKED
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
Local $Res = _GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,$Split[10])
If $Res = -1 Then _GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboScreenRes,$AvailableResolutions[0])
GUICtrlSetData($MainGUIHomeAdvancedSliderScreenResScale,$Split[11])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboWindowmode,$Split[12])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboAntialiasing,$Split[13])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboMaxAnisotropy,$Split[14])
GUICtrlSetData($MainGUIHomeAdvancedInputMaxFPS,$Split[15])
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeWind,Internal_ConvertMagicNumber($Split[16]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeLeaves,Internal_ConvertMagicNumber($Split[17]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxSpeedTreeFronds,Internal_ConvertMagicNumber($Split[18]))
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboSpeedTreeLODBias,$Split[19])
_GUICtrlComboBox_SelectString($MainGUIHomeAdvancedComboDetailMode,$Split[20])
GUICtrlSetState($MainGUIHomeAdvancedCheckboxVSync,Internal_ConvertMagicNumber($Split[21]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxPhysX,Internal_ConvertMagicNumber($Split[22]))
GUICtrlSetState($MainGUIHomeAdvancedCheckboxDX11,Internal_ConvertMagicNumber($Split[23]))
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
EndIf
EndFunc
Func Internal_UpdateRestoreConfigList()
_GUICtrlListBox_ResetContent($MainGUIRestoreConfigurationsListFiles)
Local $FileList = _FileListToArray($ConfigBackupPath,"*",2)
_ArrayDelete($FileList,0)
For $I = uBound($FileList)-1 To 0 Step -1
If not FileExists($ConfigBackupPath&$FileList[$I]&"/Engine.ini") or not FileExists($ConfigBackupPath&$FileList[$I]&"/Systemsettings.ini") Then
_ArrayDelete($FileList,$I)
EndIf
Next
_ArrayReverse($FileList)
Local $FileCount = uBound($FileList)
If $FileCount = 0 Then
_GUICtrlListBox_AddString($MainGUIRestoreConfigurationsListFiles,"No backups available.")
Else
For $I = 0 To $FileCount-1 Step 1
_GUICtrlListBox_AddString($MainGUIRestoreConfigurationsListFiles,$FileList[$I])
Next
EndIf
EndFunc
Func Internal_CreateConfigBackup()
Local $SubPath = $ConfigBackupPath & @MDAY & "_" & @MON & "_" & @YEAR & "_" & @HOUR & "_" & @MIN & "_" & @SEC
Local $CreateDir = DirCreate($SubPath)
If $CreateDir = 0 Then Return False
Local $FileCopy = FileCopy($SettingsPath,$SubPath & "\Engine.ini",1)
If $FileCopy = 0 Then Return False
Local $FileCopy = FileCopy($SystemSettingsPath,$SubPath & "\SystemSettings.ini",1)
If $FileCopy = 0 Then Return False
Internal_UpdateRestoreConfigList()
Return True
EndFunc
Func Interal_VerifyAndFixConfiguration($FileReadArray,$Hive)
Local $HiveX = uBound($Hive,1)
Local $HiveY = uBound($Hive,2)
For $I = 0 To uBound($FileReadArray) - 1 Step 1
Local $C = StringInStr($FileReadArray[$I],"=TRUE")
If not @Error and $C <> 0 Then
$FileReadArray[$I] = StringLeft($FileReadArray[$I],$C)&"True"
ContinueLoop
EndIf
Local $C = StringInStr($FileReadArray[$I],"=true")
If not @Error and $C <> 0 Then
$FileReadArray[$I] = StringLeft($FileReadArray[$I],$C)&"True"
EndIf
Next
For $I = 0 To uBound($FileReadArray) - 1 Step 1
Local $C = StringInStr($FileReadArray[$I],"=FALSE")
If not @Error and $C <> 0 Then
$FileReadArray[$I] = StringLeft($FileReadArray[$I],$C)&"False"
ContinueLoop
EndIf
Local $C = StringInStr($FileReadArray[$I],"=false")
If not @Error and $C <> 0 Then
$FileReadArray[$I] = StringLeft($FileReadArray[$I],$C)&"False"
EndIf
Next
Local $ToRemove[0]
For $I = 0 To uBound($FileReadArray) - 1 Step 1
Local $Bounds = uBound($FileReadArray) - 1
If StringLeft($FileReadArray[$I],1) = "[" and StringRight($FileReadArray[$I],1) = "]" Then
For $B = $I+1 To $Bounds Step 1
If($B+1) > $Bounds Then ExitLoop
If StringLeft($FileReadArray[$B+1],1) = "[" and StringRight($FileReadArray[$B+1],1) = "]" Then ExitLoop
If $FileReadArray[$B] = $sEmpty and not(($I+1) > $Bounds or StringLeft($FileReadArray[$B+1],1) = "[" and StringRight($FileReadArray[$B+1],1) = "]") Then
Local $Count = uBound($ToRemove)
ReDim $ToRemove[$Count+1]
$ToRemove[$Count] = $B - $Count
EndIf
Next
EndIf
Next
For $I = 0 To uBound($ToRemove) - 1 Step 1
_ArrayDelete($FileReadArray,$ToRemove[$I])
Next
For $I = uBound($FileReadArray) - 1 To 0 Step -1
If $FileReadArray[$I] <> $sEmpty and not StringInStr($FileReadArray[$I],"=") and not(StringLeft($FileReadArray[$I],1) = "[" and StringRight($FileReadArray[$I],1) = "]") Then
_ArrayDelete($FileReadArray,$I)
EndIf
Next
For $I = uBound($FileReadArray) - 1 To 0 Step -1
If StringLeft($FileReadArray[$I],1) = "[" and StringRight($FileReadArray[$I],1) = "]" Then
If $FileReadArray[$I+1] = $sEmpty Then
_ArrayDelete($FileReadArray,$I)
EndIf
EndIf
Next
Local $ToRemove[0]
For $I = 0 To uBound($FileReadArray) - 1 Step 1
Local $Bounds = uBound($FileReadArray) - 1
If StringLeft($FileReadArray[$I],1) = "[" and StringRight($FileReadArray[$I],1) = "]" Then
For $B = $I+1 To $Bounds Step 1
If($B+1) > $Bounds Then ExitLoop
If StringLeft($FileReadArray[$B+1],1) = "[" and StringRight($FileReadArray[$B+1],1) = "]" Then ExitLoop
If $FileReadArray[$B] = $sEmpty and not(($I+1) > $Bounds or StringLeft($FileReadArray[$B+1],1) = "[" and StringRight($FileReadArray[$B+1],1) = "]") Then
Local $Count = uBound($ToRemove)
ReDim $ToRemove[$Count+1]
$ToRemove[$Count] = $B - $Count
EndIf
Next
EndIf
Next
For $I = 0 To uBound($ToRemove) - 1 Step 1
_ArrayDelete($FileReadArray,$ToRemove[$I])
Next
Local $I = 0
Local $DuplicatesHandled[0][2]
While($I < $HiveX)
Local $Key = $Hive[$I][0]
Local $Start = 0, $End = 0
For $Z = 0 To uBound($FileReadArray) - 1 Step 1
If StringInStr($FileReadArray[$Z],$Key) Then
$Start = $Z+1
Local $CCCount = uBound($FileReadArray) - 1
For $AZ = $Z+1 To $CCCount Step 1
If(StringLeft($FileReadArray[$AZ],1) = "[" and StringRight($FileReadArray[$AZ],1) = "]") or $AZ = $CCCount Then
$End = $AZ
ExitLoop(2)
EndIf
Next
EndIf
Next
If $Start <> 0 and $End <> 0 Then
Local $Insertions = 0
For $B = 1 To $HiveY-1 Step 1
If $Hive[$I][$B] = $sEmpty Then ExitLoop
Local $HiveKName = StringMid($Hive[$I][$B],1,StringInStr($Hive[$I][$B],"="))
Local $HiveKLength = StringLen($HiveKName)
Local $KeyExists = False
For $C = $Start To $End Step 1
If StringLeft($FileReadArray[$C],$HiveKLength) = $HiveKName Then
$KeyExists = True
ExitLoop
EndIf
Next
If not $KeyExists Then
_ArrayInsert($FileReadArray,$Start,$HiveKName&StringMid($Hive[$I][$B],$HiveKLength+1))
$Insertions = $Insertions + 1
EndIf
Next
For $SP = $Start To $End + $Insertions Step 1
Local $EqualStart = StringInStr($FileReadArray[$SP],"=")
If $EqualStart = 0 Then ContinueLoop
Local $KeyName = StringLeft($FileReadArray[$SP],$EqualStart)
Local $DidWeHandleThatOneAlready = False
For $ZA = 0 To uBound($DuplicatesHandled) - 1 Step 1
If $DuplicatesHandled[$ZA][0] = $Hive[$I][0] and $DuplicatesHandled[$ZA][1] = $KeyName Then
$DidWeHandleThatOneAlready = True
ExitLoop
EndIf
Next
If not $DidWeHandleThatOneAlready Then
Local $DuplicateCount = 0
For $A = 0 To $HiveY-1 Step 1
If $Hive[$I][$A] = $sEmpty Then ExitLoop
If StringLeft($Hive[$I][$A],StringInStr($Hive[$I][$A],"=")) = $KeyName Then
$DuplicateCount = $DuplicateCount + 1
EndIf
Next
If $DuplicateCount > 1 Then
Local $Count = uBound($DuplicatesHandled)
ReDim $DuplicatesHandled[$Count+1][2]
$DuplicatesHandled[$Count][0] = $Key
$DuplicatesHandled[$Count][1] = $KeyName
Local $KeyValuesInHive[0]
For $A = 0 To $HiveY-1 Step 1
If $Hive[$I][$A] = $sEmpty Then ExitLoop
If StringLeft($Hive[$I][$A],StringInStr($Hive[$I][$A],"=")) = $KeyName Then
Local $RCount = uBound($KeyValuesInHive)
ReDim $KeyValuesInHive[$RCount+1]
$KeyValuesInHive[$RCount] = $Hive[$I][$A]
EndIf
Next
Local $AddedDuplicates = 0
For $Tarantel = 0 To uBound($KeyValuesInHive) - 1 Step 1
Local $DoesItExistInSuppliedGroup = False
For $A = $Start To $End+$AddedDuplicates Step 1
If $FileReadArray[$A] = $KeyValuesInHive[$Tarantel] Then
$DoesItExistInSuppliedGroup = True
ExitLoop
EndIf
Next
If not $DoesItExistInSuppliedGroup Then
_ArrayInsert($FileReadArray,$Start,$KeyValuesInHive[$Tarantel])
$AddedDuplicates = $AddedDuplicates + 1
EndIf
Next
Else
Local $INIGroupDuplicates = 0
For $A = $Start To $End Step 1
If StringLeft($FileReadArray[$A],StringInStr($FileReadArray[$A],"=")) = $KeyName Then
$INIGroupDuplicates = $INIGroupDuplicates + 1
EndIf
Next
If $INIGroupDuplicates > 1 Then
Local $Removals = 0
For $A = 0 To $INIGroupDuplicates-2 Step 1
For $Dup = $End-$Removals To $Start Step -1
If StringLeft($FileReadArray[$Dup],StringInStr($FileReadArray[$Dup],"=")) = $KeyName Then
_ArrayDelete($FileReadArray,$Dup)
$Removals = $Removals + 1
ExitLoop
EndIf
Next
Next
EndIf
EndIf
EndIf
Next
ElseIf $Start = 0 Then
For $IDK = 0 To $HiveY - 1 Step 1
If $Hive[$I][$IDK] = $sEmpty Then
_ArrayInsert($FileReadArray,$IDK,$sEmpty)
ExitLoop
EndIf
_ArrayInsert($FileReadArray,$IDK,$Hive[$I][$IDK])
Next
EndIf
$I = $I + 1
WEnd
For $I = uBound($FileReadArray) - 1 To 1 Step -1
If $I = 0 Then ExitLoop
If StringLeft($FileReadArray[$I],1) = "[" and StringRight($FileReadArray[$I],1) = "]" and $FileReadArray[$I-1] <> $sEmpty Then
_ArrayInsert($FileReadArray,$I,$sEmpty)
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
Func Internal_ApplySingleKey($Array,$KeyName,$KeyValue)
Local $KeyLength = StringLen($KeyName)
Local $FoundGroup = False
For $A = 0 To uBound($Array) - 1 Step 1
If not $FoundGroup Then
If $Array[$A] = "[SystemSettings]" Then
$FoundGroup = True
EndIf
ElseIf StringLeft($Array[$A],$KeyLength) = $KeyName Then
$Array[$A] = $KeyName&$KeyValue
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
Local $RRead = GUICtrlRead($MainGUIHomeSimpleInputMaxFPS)
If $RRead < 30 Then $RRead = 30
$Array = Internal_ApplyKey($Array,"bSmoothFrameRate=","True")
$Array = Internal_ApplyKey($Array,"MinDesiredFrameRate=",$RRead/2)
$Array = Internal_ApplyKey($Array,"MinSmoothedFrameRate=",$RRead/2)
$Array = Internal_ApplyKey($Array,"MaxSmoothedFrameRate=",$RRead)
$Array = Internal_ApplyKey($Array,"MaximumPoolSize=","0")
$Array = Internal_ApplyKey($Array,"MinimumPoolSize=","255")
$Array = Internal_ApplyKey($Array,"LoadMapTimeLimit=","1")
$Array = Internal_ApplyKey($Array,"UseDynamicStreaming=","True")
ElseIf $State = "SystemSettings" Then
$Array = Internal_ApplyKey($Array,"DepthOfField=","False")
$Array = Internal_ApplyKey($Array,"DirectionalLightmaps=","True")
$Array = Internal_ApplyKey($Array,"MotionBlur=","False")
$Array = Internal_ApplyKey($Array,"MotionBlurPause=","False")
$Array = Internal_ApplyKey($Array,"MotionBlurSkinning=","1")
$Array = Internal_ApplyKey($Array,"MaxFilterBlurSampleCount=","4")
If $ProgramHomeState = "Simple" Then
Local $Quality = GUICtrlRead($MainGUIHomeSimpleComboWorldQuality)
$Quality = Internal_GetQualityLevel($Quality)
Local $HSubIndex = 0
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
$HSubIndex = 2
$Array = Internal_ApplySubkeys($Array,$HSubIndex,$Quality)
If $Quality > 2 Then
$Array = Internal_ApplyKey($Array,"SpeedTreeWind=","False")
$Array = Internal_ApplyKey($Array,"SpeedTreeLeaves=","False")
$Array = Internal_ApplyKey($Array,"SpeedTreeFronds=","False")
$Array = Internal_ApplyKey($Array,"SpeedTreeLODBias=","0")
$Array = Internal_ApplyKey($Array,"bAllowLightShafts=","False")
$Array = Internal_ApplyKey($Array,"FogVolumes=","False")
$Array = Internal_ApplyKey($Array,"Distortion=","False")
$Array = Internal_ApplyKey($Array,"FilteredDistortion=","False")
Else
$Array = Internal_ApplyKey($Array,"SpeedTreeWind=","True")
$Array = Internal_ApplyKey($Array,"SpeedTreeLeaves=","True")
$Array = Internal_ApplyKey($Array,"SpeedTreeFronds=","True")
$Array = Internal_ApplyKey($Array,"SpeedTreeLODBias=","2")
$Array = Internal_ApplyKey($Array,"bAllowLightShafts=","True")
$Array = Internal_ApplyKey($Array,"FogVolumes=","True")
$Array = Internal_ApplyKey($Array,"Distortion=","True")
$Array = Internal_ApplyKey($Array,"FilteredDistortion=","True")
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
$Array = Internal_ApplyKey($Array,"bAllowDropShadows=","False")
$Array = Internal_ApplyKey($Array,"bAllowWholeSceneDominantShadows=","False")
$Array = Internal_ApplyKey($Array,"bUseConservativeShadowBounds=","False")
$Array = Internal_ApplyKey($Array,"LightEnvironmentShadows=","False")
Else
$Array = Internal_ApplyKey($Array,"bAllowDropShadows=","True")
$Array = Internal_ApplyKey($Array,"bAllowWholeSceneDominantShadows=","True")
$Array = Internal_ApplyKey($Array,"bUseConservativeShadowBounds=","True")
$Array = Internal_ApplyKey($Array,"LightEnvironmentShadows=","True")
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
$Array = Internal_ApplySingleKey($Array,"DropParticleDistortion=","False")
$Array = Internal_ApplySingleKey($Array,"ParticleLODBias=","0")
$Array = Internal_ApplySingleKey($Array,"PerfScalingBias=","0")
ElseIf $Quality = 1 Then
$Array = Internal_ApplySingleKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySingleKey($Array,"ParticleLODBias=","1")
$Array = Internal_ApplySingleKey($Array,"PerfScalingBias=","0.1")
ElseIf $Quality = 2 Then
$Array = Internal_ApplySingleKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySingleKey($Array,"ParticleLODBias=","2")
$Array = Internal_ApplySingleKey($Array,"PerfScalingBias=","0.2")
ElseIf $Quality >= 3 Then
$Array = Internal_ApplySingleKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySingleKey($Array,"ParticleLODBias=","10")
$Array = Internal_ApplySingleKey($Array,"PerfScalingBias=","0.2")
EndIf
Local $RRead = GUICtrlRead($MainGUIHomeSimpleComboScreenRes)
Local $SplitC = StringSplit($RRead,"x")
_ArrayDelete($SplitC,0)
Local $ScreenResX = StringReplace($SplitC[0]," ",$sEmpty)
Local $ScreenResY = StringReplace($SplitC[1]," ",$sEmpty)
$Array = Internal_ApplyKey($Array,"ResX=",$ScreenResX)
$Array = Internal_ApplyKey($Array,"ResY=",$ScreenResY)
Local $Mode = GUICtrlRead($MainGUIHomeSimpleComboWindowmode)
If $Mode = "Fullscreen" Then
$Array = Internal_ApplyKey($Array,"Fullscreen=","True")
$Array = Internal_ApplyKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplyKey($Array,"Borderless=","False")
ElseIf $Mode = "Borderless Window" Then
$Array = Internal_ApplyKey($Array,"Fullscreen=","False")
$Array = Internal_ApplyKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplyKey($Array,"Borderless=","True")
ElseIf $Mode = "Windowed" Then
$Array = Internal_ApplyKey($Array,"Fullscreen=","False")
$Array = Internal_ApplyKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplyKey($Array,"Borderless=","False")
EndIf
Local $RsEn = GUICtrlRead($MainGUIHomeSimpleSliderScreenResScale)
If $RsEn <> 100 Then
$Array = Internal_ApplyKey($Array,"ScreenPercentage=",$RsEn)
$Array = Internal_ApplyKey($Array,"UpscaleScreenPercentage=","True")
Else
$Array = Internal_ApplyKey($Array,"ScreenPercentage=","100")
$Array = Internal_ApplyKey($Array,"UpscaleScreenPercentage=","False")
EndIf
Local $DX11Read = GUICtrlRead($MainGUIHomeSimpleCheckboxDirectX11)
If @OSVersion = "WIN_XP" or @OSVersion = "WIN_VISTA" or @OSVersion = "WIN_XPe" or @OSVersion = "WIN_2008R2" or @OSVersion = "WIN_2008" or @OSVersion = "WIN_2003" Then $DX11Read = "False"
If $DX11Read = $GUI_UNCHECKED Then
$Array = Internal_ApplyKey($Array,"UseDX11=","False")
$Array = Internal_ApplyKey($Array,"AllowD3D11=","False")
$Array = Internal_ApplyKey($Array,"PreferD3D11=","False")
$Array = Internal_ApplyKey($Array,"UseD3D11Beta=","False")
ElseIf $DX11Read = $GUI_CHECKED Then
$Array = Internal_ApplyKey($Array,"UseDX11=","True")
$Array = Internal_ApplyKey($Array,"AllowD3D11=","True")
$Array = Internal_ApplyKey($Array,"PreferD3D11=","True")
$Array = Internal_ApplyKey($Array,"UseD3D11Beta=","True")
EndIf
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
$Array = Internal_ApplyKey($Array,"FXAAQuality=",$AARead)
Local $AFRead = GUICtrlRead($MainGUIHomeSimpleComboMaxAnisotropy)
If $AFRead = "Off" Then
$AFRead = "0"
Else
$AFRead = StringReplace($AFRead,"x",$sEmpty)
EndIf
$Array = Internal_ApplyKey($Array,"MaxAnisotropy=",$AFRead)
Local $DecalsRead = GUICtrlRead($MainGUIHomeSimpleCheckboxDecals)
$Array = Internal_ApplyKey($Array,"MaxActiveDecals=","0")
If $DecalsRead = $GUI_UNCHECKED Then
$Array = Internal_ApplyKey($Array,"StaticDecals=","False")
$Array = Internal_ApplyKey($Array,"DynamicDecals=","False")
$Array = Internal_ApplyKey($Array,"UnbatchedDecals=","False")
ElseIf $DecalsRead = $GUI_CHECKED Then
$Array = Internal_ApplyKey($Array,"StaticDecals=","True")
$Array = Internal_ApplyKey($Array,"DynamicDecals=","True")
$Array = Internal_ApplyKey($Array,"UnbatchedDecals=","True")
EndIf
Local $DASRead = GUICtrlRead($MainGUIHomeSimpleCheckboxDynamicLightShadows)
If $DASRead = $GUI_UNCHECKED Then
$Array = Internal_ApplyKey($Array,"DynamicLights=","False")
$Array = Internal_ApplyKey($Array,"CompositeDynamicLights=","False")
$Array = Internal_ApplyKey($Array,"SHSecondaryLighting=","False")
$Array = Internal_ApplyKey($Array,"DynamicShadows=","False")
ElseIf $DASRead = $GUI_CHECKED Then
$Array = Internal_ApplyKey($Array,"DynamicLights=","True")
$Array = Internal_ApplyKey($Array,"CompositeDynamicLights=","True")
$Array = Internal_ApplyKey($Array,"SHSecondaryLighting=","True")
$Array = Internal_ApplyKey($Array,"DynamicShadows=","True")
EndIf
Local $ReflectionsRead = GUICtrlRead($MainGUIHomeSimpleCheckboxReflections)
If $ReflectionsRead = $GUI_UNCHECKED Then
$Array = Internal_ApplyKey($Array,"AllowImageReflections=","False")
$Array = Internal_ApplyKey($Array,"AllowImageReflectionShadowing=","False")
ElseIf $ReflectionsRead = $GUI_CHECKED Then
$Array = Internal_ApplyKey($Array,"AllowImageReflections=","True")
$Array = Internal_ApplyKey($Array,"AllowImageReflectionShadowing=","True")
EndIf
Local $FPSRead = GUICtrlRead($MainGUIHomeSimpleInputMaxFPS)
If $FPSRead < 30 Then $FPSRead = 30
$Array = Internal_ApplyKey($Array,"TargetFrameRate=",$FPSRead)
Local $DetailModeRead = GUICtrlRead($MainGUIHomeSimpleComboDetailMode)
$Array = Internal_ApplyKey($Array,"DetailMode=",$DetailModeRead)
Local $UseVsyncRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxVSync)
$Array = Internal_ApplyKey($Array,"UseVsync=",$UseVsyncRead)
$Array = Internal_ApplyKey($Array,"VsyncPresentInterval=","1")
Local $PhysXRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxRagdollPhysics)
$Array = Internal_ApplyKey($Array,"bAllowRagdolling=",$PhysXRead)
Local $BloomRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxBloom)
$Array = Internal_ApplyKey($Array,"Bloom=",$BloomRead)
Local $LensFlareRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxLensflares)
$Array = Internal_ApplyKey($Array,"LensFlares=",$LensFlareRead)
Local $UncompTextRead = Internal_CheckboxToStrBool($MainGUIHomeSimpleCheckboxHighQualityMats)
$Array = Internal_ApplyKey($Array,"bAllowHighQualityMaterials=",$UncompTextRead)
$Array = Internal_ApplyKey($Array,"bUseLowQualMaterials=",not $UncompTextRead)
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
$Array = Internal_ApplySingleKey($Array,"DropParticleDistortion=","False")
$Array = Internal_ApplySingleKey($Array,"ParticleLODBias=","0")
$Array = Internal_ApplySingleKey($Array,"PerfScalingBias=","0")
ElseIf $PQ_LevelRead = "High" Then
$Array = Internal_ApplySingleKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySingleKey($Array,"ParticleLODBias=","1")
$Array = Internal_ApplySingleKey($Array,"PerfScalingBias=","0.1")
ElseIf $PQ_LevelRead = "Medium" Then
$Array = Internal_ApplySingleKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySingleKey($Array,"ParticleLODBias=","2")
$Array = Internal_ApplySingleKey($Array,"PerfScalingBias=","0.2")
ElseIf $PQ_LevelRead = "Low" Then
$Array = Internal_ApplySingleKey($Array,"DropParticleDistortion=","True")
$Array = Internal_ApplySingleKey($Array,"ParticleLODBias=","10")
$Array = Internal_ApplySingleKey($Array,"PerfScalingBias=","0.2")
EndIf
Local $RRead = GUICtrlRead($MainGUIHomeAdvancedComboScreenRes)
Local $SplitC = StringSplit($RRead,"x")
_ArrayDelete($SplitC,0)
Local $ScreenResX = StringReplace($SplitC[0]," ",$sEmpty)
Local $ScreenResY = StringReplace($SplitC[1]," ",$sEmpty)
$Array = Internal_ApplyKey($Array,"ResX=",$ScreenResX)
$Array = Internal_ApplyKey($Array,"ResY=",$ScreenResY)
Local $Mode = GUICtrlRead($MainGUIHomeAdvancedComboWindowmode)
If $Mode = "Fullscreen" Then
$Array = Internal_ApplyKey($Array,"Fullscreen=","True")
$Array = Internal_ApplyKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplyKey($Array,"Borderless=","False")
ElseIf $Mode = "Borderless Window" Then
$Array = Internal_ApplyKey($Array,"Fullscreen=","False")
$Array = Internal_ApplyKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplyKey($Array,"Borderless=","True")
ElseIf $Mode = "Windowed" Then
$Array = Internal_ApplyKey($Array,"Fullscreen=","False")
$Array = Internal_ApplyKey($Array,"FullscreenWindowed=","False")
$Array = Internal_ApplyKey($Array,"Borderless=","False")
EndIf
Local $RsEn = GUICtrlRead($MainGUIHomeAdvancedSliderScreenResScale)
If $RsEn <> 100 Then
$Array = Internal_ApplyKey($Array,"ScreenPercentage=",$RsEn)
$Array = Internal_ApplyKey($Array,"UpscaleScreenPercentage=","True")
Else
$Array = Internal_ApplyKey($Array,"ScreenPercentage=","100")
$Array = Internal_ApplyKey($Array,"UpscaleScreenPercentage=","False")
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
$Array = Internal_ApplyKey($Array,"FXAAQuality=",$AARead)
Local $AFRead = GUICtrlRead($MainGUIHomeAdvancedComboMaxAnisotropy)
If $AFRead = "Off" Then
$AFRead = "0"
Else
$AFRead = StringReplace($AFRead,"x",$sEmpty)
EndIf
$Array = Internal_ApplyKey($Array,"MaxAnisotropy=",$AFRead)
Local $DX11Read = GUICtrlRead($MainGUIHomeAdvancedCheckboxDX11)
If @OSVersion = "WIN_XP" or @OSVersion = "WIN_VISTA" or @OSVersion = "WIN_XPe" or @OSVersion = "WIN_2008R2" or @OSVersion = "WIN_2008" or @OSVersion = "WIN_2003" Then $DX11Read = "False"
If $DX11Read = $GUI_UNCHECKED Then
$Array = Internal_ApplyKey($Array,"UseDX11=","False")
$Array = Internal_ApplyKey($Array,"AllowD3D11=","False")
$Array = Internal_ApplyKey($Array,"PreferD3D11=","False")
$Array = Internal_ApplyKey($Array,"UseD3D11Beta=","False")
ElseIf $DX11Read = $GUI_CHECKED Then
$Array = Internal_ApplyKey($Array,"UseDX11=","True")
$Array = Internal_ApplyKey($Array,"AllowD3D11=","True")
$Array = Internal_ApplyKey($Array,"PreferD3D11=","True")
$Array = Internal_ApplyKey($Array,"UseD3D11Beta=","True")
EndIf
Local $ReflectionsRead = GUICtrlRead($MainGUIHomeAdvancedCheckboxReflections)
If $ReflectionsRead = $GUI_UNCHECKED Then
$Array = Internal_ApplyKey($Array,"AllowImageReflections=","False")
$Array = Internal_ApplyKey($Array,"AllowImageReflectionShadowing=","False")
ElseIf $ReflectionsRead = $GUI_CHECKED Then
$Array = Internal_ApplyKey($Array,"AllowImageReflections=","True")
$Array = Internal_ApplyKey($Array,"AllowImageReflectionShadowing=","True")
EndIf
Local $FPSRead = GUICtrlRead($MainGUIHomeAdvancedInputMaxFPS)
If $FPSRead < 30 Then $FPSRead = 30
$Array = Internal_ApplyKey($Array,"TargetFrameRate=",$FPSRead)
Local $UseVsyncRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxVSync)
$Array = Internal_ApplyKey($Array,"UseVsync=",$UseVsyncRead)
$Array = Internal_ApplyKey($Array,"VsyncPresentInterval=","1")
Local $PhysXRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxPhysX)
$Array = Internal_ApplyKey($Array,"bAllowRagdolling=",$PhysXRead)
Local $BloomRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxBloom)
$Array = Internal_ApplyKey($Array,"Bloom=",$BloomRead)
Local $SpeedTreeWindRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxSpeedTreeWind)
$Array = Internal_ApplyKey($Array,"SpeedTreeWind=",$SpeedTreeWindRead)
Local $SpeedTreeLeavesRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxSpeedTreeLeaves)
$Array = Internal_ApplyKey($Array,"SpeedTreeLeaves=",$SpeedTreeLeavesRead)
Local $SpeedTreeFrondsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxSpeedTreeFronds)
$Array = Internal_ApplyKey($Array,"SpeedTreeFronds=",$SpeedTreeFrondsRead)
Local $SpeedTreeLODBiasRead = GUICtrlRead($MainGUIHomeAdvancedComboSpeedTreeLODBias)
$Array = Internal_ApplyKey($Array,"SpeedTreeLODBias=",$SpeedTreeLODBiasRead)
Local $DetailModeRead = GUICtrlRead($MainGUIHomeAdvancedComboDetailMode)
$Array = Internal_ApplyKey($Array,"DetailMode=",$DetailModeRead)
Local $LensflaresRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxLensflares)
$Array = Internal_ApplyKey($Array,"LensFlares=",$LensflaresRead)
Local $LightEnvShadowsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxLightEnvShadows)
$Array = Internal_ApplyKey($Array,"LightEnvironmentShadows=",$LightEnvShadowsRead)
Local $LightShaftsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxLightShafts)
$Array = Internal_ApplyKey($Array,"bAllowLightShafts=",$LightShaftsRead)
Local $FogVolumesRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxFogVolumes)
$Array = Internal_ApplyKey($Array,"FogVolumes=",$FogVolumesRead)
Local $DistortionRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDistortion)
$Array = Internal_ApplyKey($Array,"Distortion=",$DistortionRead)
Local $FilteredDistortionRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxFilteredDistortion)
$Array = Internal_ApplyKey($Array,"FilteredDistortion=",$FilteredDistortionRead)
Local $DropShadowsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDropShadows)
$Array = Internal_ApplyKey($Array,"bAllowDropShadows=",$DropShadowsRead)
Local $WholeSceneShadowsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxWholeSceneShadows)
$Array = Internal_ApplyKey($Array,"bAllowWholeSceneDominantShadows=",$WholeSceneShadowsRead)
Local $ConservShadowBoundsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxConservShadowBounds)
$Array = Internal_ApplyKey($Array,"bUseConservativeShadowBounds=",$ConservShadowBoundsRead)
Local $StaticDecalsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxStaticDecals)
$Array = Internal_ApplyKey($Array,"StaticDecals=",$StaticDecalsRead)
Local $DynamicDecalsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDynamicDecals)
$Array = Internal_ApplyKey($Array,"DynamicDecals=",$DynamicDecalsRead)
Local $UnbatchedDecalsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxUnbatchedDecals)
$Array = Internal_ApplyKey($Array,"UnbatchedDecals=",$UnbatchedDecalsRead)
Local $DynamicLightsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDynamicLights)
$Array = Internal_ApplyKey($Array,"DynamicLights=",$DynamicLightsRead)
Local $CompositeDynamicLightsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxCompDynamicLights)
$Array = Internal_ApplyKey($Array,"CompositeDynamicLights=",$CompositeDynamicLightsRead)
Local $SHSecondaryLightingRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxSHSecondaryLighting)
$Array = Internal_ApplyKey($Array,"SHSecondaryLighting=",$SHSecondaryLightingRead)
Local $DynamicShadowsRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxDynamicShadows)
$Array = Internal_ApplyKey($Array,"DynamicShadows=",$DynamicShadowsRead)
Local $UncompTextRead = Internal_CheckboxToStrBool($MainGUIHomeAdvancedCheckboxUncText)
$Array = Internal_ApplyKey($Array,"bAllowHighQualityMaterials=",$UncompTextRead)
$Array = Internal_ApplyKey($Array,"bUseLowQualMaterials=",not $UncompTextRead)
EndIf
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
Func Internal_ProcessRequest($Bool = False)
If ProcessExists("smite.exe") Then
DisplayErrorMessage("Cannot apply settings while SMITE is running!")
Return
EndIf
If $ProcessingRequest Then Return
$ProcessingRequest = True
$HoverTipAlpha = 0
WinSetTrans($HoverInfoGUI,$sEmpty,$HoverTipAlpha)
Internal_SaveSettingCookie()
_WinAPI_SetWindowPos($MainGUI,$HWND_TOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
_WinAPI_SetWindowPos($MainGUI,$HWND_NOTOPMOST,0,0,0,0,BitOR($SWP_NOACTIVATE,$SWP_NOMOVE,$SWP_NOSIZE))
GUISetState(@SW_DISABLE,$MainGUI)
Local $WinPos = WinGetPos($MainGUI)
Global $ProcessUI = GUICreate("SO_PROCESSING",400,150,$WinPos[0] +($WinPos[2]/2)-200,$WinPos[1] +($WinPos[3]/2)-75,$WS_POPUP,$WS_EX_TOOLWINDOW)
GUISetBkColor(0x000000)
Local $ProcessUIBG = GUICtrlCreatePic($sEmpty,0,0,400,150)
LoadImageResource($ProcessUIBG,$MainResourcePath & "NotificationBG.jpg","NotificationBG")
Local $ProcessUILabelMainStatus = GUICtrlCreateLabelTransparentBG("Processing..",5,0,200,30)
GUICtrlSetFont(-1,20,500,Default,$MainFontName)
GUICtrlSetColor(-1,0xFFFFFF)
Local $ProcessUILabelCATC = GUICtrlCreateLabelTransparentBG("(Click to continue)",121,4,250,30)
GUICtrlSetFont(-1,15,500,Default,$MainFontName)
GUICtrlSetColor(-1,0xFFFFFF)
GUICtrlSetState(-1,$GUI_HIDE)
Local $ProcessUILabelStatusBackup = GUICtrlCreateLabelTransparentBG("[X] Creating backup",5,35,200,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUILabelStatusRead = GUICtrlCreateLabelTransparentBG("[X] Reading files",5,50,200,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUILabelStatusVerify = GUICtrlCreateLabelTransparentBG("[X] Verifying and repairing integrity",5,65,250,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUILabelStatusApply = GUICtrlCreateLabelTransparentBG("[X] Applying settings",5,80,200,30)
GUICtrlSetColor(-1,0xFF0000)
Local $ProcessUILabelStatusSave = GUICtrlCreateLabelTransparentBG("[X] Saving",5,95,200,30)
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
Internal_ProcessHandleError("There was an error creating the configuration backup! Code: 003")
ExitLoop
EndIf
GUICtrlSetData($ProcessUIProgress,20)
GUICtrlSetColor($ProcessUILabelStatusBackup,0x00FF00)
GUICtrlSetData($ProcessUILabelStatusBackup,"[✓] Creating backup")
$PState = $PState + 1
ElseIf $PState = 1 Then
Local $EngineFile
Local $SystemFile
Local $EngineFileFallback[1]
Local $SystemFileFallback[1]
_FileReadToArray($SettingsPath,$EngineFile,$FRTA_NOCOUNT)
If not IsArray($EngineFile) Then $EngineFile = $EngineFileFallback
_FileReadToArray($SystemSettingsPath,$SystemFile,$FRTA_NOCOUNT)
If not IsArray($SystemFile) Then $SystemFile = $SystemFileFallback
GUICtrlSetData($ProcessUIProgress,40)
GUICtrlSetColor($ProcessUILabelStatusRead,0x00FF00)
GUICtrlSetData($ProcessUILabelStatusRead,"[✓] Reading files")
$PState = $PState + 1
ElseIf $PState = 2 Then
Local $EngineSF = Interal_VerifyAndFixConfiguration($EngineFile,$EngineSettingsClearHive)
Local $SystemSF = Interal_VerifyAndFixConfiguration($SystemFile,$SystemSettingsClearHive)
GUICtrlSetData($ProcessUIProgress,60)
GUICtrlSetColor($ProcessUILabelStatusVerify,0x00FF00)
GUICtrlSetData($ProcessUILabelStatusVerify,"[✓] Verifying and repairing integrity")
$PState = $PState + 1
ElseIf $PState = 3 Then
If $Bool Then
$EngineSF = Internal_ApplyChanges($EngineSF,"EngineSettings")
$SystemSF = Internal_ApplyChanges($SystemSF,"SystemSettings")
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
Internal_ProcessHandleError("There was an error when writing the configuration files! Code: 004"&@CRLF&"If you are on a Virtual Machine then you're out of luck. Sorry!")
ExitLoop
EndIf
_FileWriteFromArray($SystemSettingsPath,$SystemSF)
If @Error <> 0 Then
Internal_ProcessHandleError("There was an error when writing the configuration files! Code: 005"&@CRLF&"If you are on a Virtual Machine then you're out of luck. Sorry!")
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
Sleep(1)
Else
If WinGetTitle("[active]") = $ProgramName Then WinActivate($ProcessUI)
Sleep(100)
EndIf
WEnd
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
If $ProgramHomeState = "Simple" Then
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
If $ProgramHomeState = "Simple" Then
$XOffset = -100 + ControlGetPos($MainGUI,$sEmpty,$MainGUIHomeSimpleComboWorldQuality)[0]
ElseIf $ProgramHomeState = "Advanced" Then
$XOffset = -100 + ControlGetPos($MainGUI,$sEmpty,$MainGUIHomeAdvancedComboWorldQuality)[0]
EndIf
WinMove($HoverInfoGUI,$sEmpty,$WinPos[0] + $X_Pic + $XOffset,$WinPos[1] + $Y_Pic,$X_Size_Pic,$Y_Size_Pic)
If $IsAnimated Then
GUICtrlSetPos($HoverInfoGUIImageAnimation,0,0,$X_Size_Pic,$Y_Size_Pic)
If @Compiled Then
Local $StrippedImageStr = StringReplace($Image,@ScriptDir,$sEmpty)
$StrippedImageStr = StringReplace($StrippedImageStr,"\Resource\HelpText/",$sEmpty)
$StrippedImageStr = StringReplace($StrippedImageStr,".gif",$sEmpty)
_GUICtrlSetGIF($HoverInfoGUIImageAnimation,@AutoItExe,"RES;"&$StrippedImageStr&"GIF")
Else
_GUICtrlSetGIF($HoverInfoGUIImageAnimation,$Image)
EndIf
GUICtrlSetState($HoverInfoGUIImageAnimation,$GUI_SHOW)
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
GUICtrlSetState($HoverInfoGUIImageAnimation,$GUI_HIDE)
_GIF_PauseAnimation($HoverInfoGUIImageAnimation)
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
ElseIf $HomeIconHoverHideBool Then
UndoMenuHoverState()
LoadImageResource($HomeIconHover,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($HomeIcon,$MainResourcePath & "HomeIconInactive.jpg","HomeIconInactive")
$HomeIconHoverHideBool = False
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
ElseIf $PayPalBtnHoverHideBool Then
LoadImageResource($MainGUIDonateButtonPaypal,$MainResourcePath & "PayPalBtnInActive.jpg","PayPalBtnInActive")
$PayPalBtnHoverHideBool = False
ElseIf $PatreonBtnHoverHideBool Then
LoadImageResource($MainGUIDonateButtonPatreon,$MainResourcePath & "PatreonBtnInActive.jpg","PatreonBtnInActive")
$PatreonBtnHoverHideBool = False
ElseIf $ViewOnlineChangesBtnHoverBool Then
UndoMenuHoverState()
LoadImageResource($MainGUIChangelogButtonViewOnlineBG,$MainResourcePath & "MenuItemBG.jpg","MenuItemBG")
LoadImageResource($MainGUIChangelogButtonViewOnline,$MainResourcePath & "ChangelogIconInActive.jpg","ChangelogIconInActive")
$ViewOnlineChangesBtnHoverBool = False
ElseIf $AnimatedLogoBool Then
GUICtrlSetState($MainGUICopyrightPicLogo,$GUI_SHOW)
GUICtrlSetState($MainGUICopyrightAnimatedLogo,$GUI_HIDE)
_GIF_PauseAnimation($MainGUICopyrightAnimatedLogo)
$AnimatedLogoBool = False
ElseIf $LicenseLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelLicenseLink,0x4F89EA)
GUICtrlSetFont($MainGUICopyrightLabelLicenseLink,15,500,Default,$MainFontName)
$LicenseLabelHoverBool = False
ElseIf $SourceLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelSourceLink,0x4F89EA)
GUICtrlSetFont($MainGUICopyrightLabelSourceLink,15,500,Default,$MainFontName)
$SourceLabelHoverBool = False
ElseIf $AutoItLicenseLabelHoverBool Then
GUICtrlSetColor($MainGUICopyrightLabelAutoitLicenseLink,0x4F89EA)
GUICtrlSetFont($MainGUICopyrightLabelAutoitLicenseLink,15,500,Default,$MainFontName)
$AutoItLicenseLabelHoverBool = False
ElseIf $MainGUIDebugLabelHoverBool Then
GUICtrlSetColor($MainGUIDebugLabelReportABug,0x4F89EA)
GUICtrlSetFont($MainGUIDebugLabelReportABug,15,500,Default,$MainFontName)
$MainGUIDebugLabelHoverBool = False
ElseIf $MainGUIDebugDumpInfoHoverBool Then
GUICtrlSetColor($MainGUIDebugLabelCreateDebugInfo,0x4F89EA)
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
If $UpdateAvailable Then
If TimerDiff($UpdateTimer) > 750 Then
$UpdateTimer = TimerInit()
If $UpdateColorState Then
GUICtrlSetColor($MainGUILabelVersion,0xFF0000)
$UpdateColorState = False
Else
GUICtrlSetColor($MainGUILabelVersion,0xFFFFFF)
$UpdateColorState = True
EndIf
EndIf
Endif
If $ProgramHomeState = "Simple" Then
Local $ReadScreenResSimple = GUICtrlRead($MainGUIHomeSimpleSliderScreenResScale)&"%"
If $ReadScreenResSimple <> $LastScreenResScaleSimple Then
GUICtrlSetData($MainGUIHomeSimpleInputScreenResScale,$ReadScreenResSimple)
$LastScreenResScaleSimple = $ReadScreenResSimple
EndIf
ElseIf $ProgramHomeState = "Advanced" Then
Local $ReadScreenResAdvanced = GUICtrlRead($MainGUIHomeAdvancedSliderScreenResScale)&"%"
If $ReadScreenResAdvanced <> $LastScreenResScaleAdvanced Then
GUICtrlSetData($MainGUIHomeAdvancedInputScreenResScale,$ReadScreenResAdvanced)
$LastScreenResScaleAdvanced = $ReadScreenResAdvanced
EndIf
EndIf
If $ProgramHomeHelpState = 1 and $MenuSelected = 1 and not $MainGUIHomeDiscoveryDrawn Then
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
If $ProgramHomeState = "Simple" Then
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
DisplayHoverImage(295,71,200,43,$MainResourcePath & "HelpText/Resolution.jpg",500,40,345,185)
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
DisplayHoverImage(590,123,200,23,$MainResourcePath & "HelpText/DirectX_11.jpg",240,40,345,300)
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
DisplayHoverImage(295,116,200,43,$MainResourcePath & "HelpText/Resolution.jpg",500,40,345,185)
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
DisplayHoverImage(495,248,165,23,$MainResourcePath & "HelpText/DirectX_11.jpg",145,40,345,300)
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
DisplayHoverImage(660,88,192,23,$MainResourcePath & "HelpText/Distortion.jpg",310,40,345,300)
ElseIf InRange2D($MousePos,660,108,845,131) Then
DisplayHoverImage(660,108,192,23,$MainResourcePath & "HelpText/Filtered_Distortion.jpg",310,40,345,242)
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
DisplayHoverImage(660,248,192,23,$MainResourcePath & "HelpText/Unbatched_Decals.jpg",310,40,345,127)
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
Case $HomeIconHover, $HomeIcon
If $HomeIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Home",36,92,37)
LoadImageResource($HomeIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($HomeIcon,$MainResourcePath & "HomeIconActive.jpg","HomeIconActive")
$HomeIconHoverHideBool = True
EndIf
Case $RCIconHover, $RCIcon
If $RCIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Restore Configuration",76,351,76)
LoadImageResource($RCIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($RCIcon,$MainResourcePath & "RestoreConfigsIconActive.jpg","RestoreConfigsIconActive")
$RCIconHoverHideBool = True
EndIf
Case $DonateIconHover, $DonateIcon
If $DonateIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Donate",118,118,119)
LoadImageResource($DonateIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($DonateIcon,$MainResourcePath & "DonateIconActive.jpg","DonateIconActive")
$DonateIconHoverHideBool = True
EndIf
Case $ChangelogIconHover, $ChangelogIcon
If $ChangelogIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Changelog",158,167,158)
LoadImageResource($ChangelogIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($ChangelogIcon,$MainResourcePath & "ChangelogIconActive.jpg","ChangelogIconActive")
$ChangelogIconHoverHideBool = True
EndIf
Case $CopyrightIconHover, $CopyrightIcon
If $CopyrightIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Copyright",198,165,197)
LoadImageResource($CopyrightIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($CopyrightIcon,$MainResourcePath & "CopyrightIconActive.jpg","CopyrightIconActive")
$CopyrightIconHoverHideBool = True
EndIf
Case $DebugIconHover, $DebugIcon
If $DebugIconHoverHideBool = False Then
_FixMenuSwitch()
MenuHoverState("Debug",240,103,240)
LoadImageResource($DebugIconHover,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($DebugIcon,$MainResourcePath & "DebugIconActive.jpg","DebugIconActive")
$DebugIconHoverHideBool = True
EndIf
Case $MainGUIDonateButtonPaypal
If $PayPalBtnHoverHideBool = False Then
_FixMenuSwitch()
LoadImageResource($MainGUIDonateButtonPaypal,$MainResourcePath & "PayPalBtnActive.jpg","PayPalBtnActive")
$PayPalBtnHoverHideBool = True
EndIf
Case $MainGUIDonateButtonPatreon
If $PatreonBtnHoverHideBool = False Then
_FixMenuSwitch()
LoadImageResource($MainGUIDonateButtonPatreon,$MainResourcePath & "PatreonBtnActive.jpg","PatreonBtnActive")
$PatreonBtnHoverHideBool = True
EndIf
Case $MainGUIChangelogButtonViewOnline, $MainGUIChangelogButtonViewOnlineBG
If $ViewOnlineChangesBtnHoverBool = False Then
_FixMenuSwitch()
MenuHoverState("View Changes Online",344,320,344)
LoadImageResource($MainGUIChangelogButtonViewOnlineBG,$MainResourcePath & "HoverMenuBG.jpg","HoverMenuBG")
LoadImageResource($MainGUIChangelogButtonViewOnline,$MainResourcePath & "ChangelogIconActive.jpg","ChangelogIconActive")
$ViewOnlineChangesBtnHoverBool = True
EndIf
Case $MainGUICopyrightPicLogo, $MainGUICopyrightAnimatedLogo
If $AnimatedLogoBool = False Then
GUICtrlSetState($MainGUICopyrightPicLogo,$GUI_HIDE)
GUICtrlSetState($MainGUICopyrightAnimatedLogo,$GUI_SHOW)
_GIF_ResumeAnimation($MainGUICopyrightAnimatedLogo)
$AnimatedLogoBool = True
EndIf
Case $MainGUICopyrightLabelLicenseLink
If $LicenseLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelLicenseLink,0x0645AD)
GUICtrlSetFont($MainGUICopyrightLabelLicenseLink,15,500,4,$MainFontName)
$LicenseLabelHoverBool = True
EndIf
Case $MainGUICopyrightLabelSourceLink
If $SourceLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelSourceLink,0x0645AD)
GUICtrlSetFont($MainGUICopyrightLabelSourceLink,15,500,4,$MainFontName)
$SourceLabelHoverBool = True
EndIf
Case $MainGUICopyrightLabelAutoitLicenseLink
If $AutoItLicenseLabelHoverBool = False Then
GUICtrlSetColor($MainGUICopyrightLabelAutoitLicenseLink,0x0645AD)
GUICtrlSetFont($MainGUICopyrightLabelAutoitLicenseLink,15,500,4,$MainFontName)
$AutoItLicenseLabelHoverBool = True
EndIf
Case $MainGUIDebugLabelReportABug
If $MainGUIDebugLabelHoverBool = False Then
GUICtrlSetColor($MainGUIDebugLabelReportABug,0x0645AD)
GUICtrlSetFont($MainGUIDebugLabelReportABug,15,500,4,$MainFontName)
$MainGUIDebugLabelHoverBool = True
EndIf
Case $MainGUIDebugLabelCreateDebugInfo
If $MainGUIDebugDumpInfoHoverBool = False Then
GUICtrlSetColor($MainGUIDebugLabelCreateDebugInfo,0x0645AD)
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
Sleep(1)
Else
If $MenuPopupState Then _FixMenuSwitch()
$JustTabbedBackIn = 0
Sleep(100)
EndIf
WEnd
