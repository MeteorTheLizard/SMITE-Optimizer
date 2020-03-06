#NoTrayIcon
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $STR_NOCASESENSEBASIC = 2
Global Const $STR_STRIPLEADING = 1
Global Const $STR_STRIPTRAILING = 2
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
Global Const $FO_READ = 0
Global Const $FO_OVERWRITE = 2
Global Const $FRTA_NOCOUNT = 0
Global Const $FRTA_COUNT = 1
Global Const $FRTA_INTARRAYS = 2
Global Const $FRTA_ENTIRESPLIT = 4
Global Const $FLTA_FILESFOLDERS = 0
Global Const $FLTAR_FILESFOLDERS = 0
Global Const $FLTAR_NOHIDDEN = 4
Global Const $FLTAR_NOSYSTEM = 8
Global Const $FLTAR_NOLINK = 16
Global Const $FLTAR_NORECUR = 0
Global Const $FLTAR_NOSORT = 0
Global Const $FLTAR_RELPATH = 1
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
If $sName = ".." Then
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
Func _FileWriteToLine($sFilePath, $iLine, $sText, $bOverWrite = False, $bFill = False)
If $bOverWrite = Default Then $bOverWrite = False
If $bFill = Default Then $bFill = False
If Not FileExists($sFilePath) Then Return SetError(2, 0, 0)
If $iLine <= 0 Then Return SetError(4, 0, 0)
If Not(IsBool($bOverWrite) Or $bOverWrite = 0 Or $bOverWrite = 1) Then Return SetError(5, 0, 0)
If Not IsString($sText) Then
$sText = String($sText)
If $sText = "" Then Return SetError(6, 0, 0)
EndIf
If Not IsBool($bFill) Then Return SetError(7, 0, 0)
Local $aArray = FileReadToArray($sFilePath)
If @error Then Local $aArray[0]
Local $iUBound = UBound($aArray) - 1
If $bFill Then
If $iUBound < $iLine Then
ReDim $aArray[$iLine]
$iUBound = $iLine - 1
EndIf
Else
If($iUBound + 1) < $iLine Then Return SetError(1, 0, 0)
EndIf
$aArray[$iLine - 1] =($bOverWrite ? $sText : $sText & @CRLF & $aArray[$iLine - 1])
Local $sData = ""
For $i = 0 To $iUBound
$sData &= $aArray[$i] & @CRLF
Next
$sData = StringTrimRight($sData, StringLen(@CRLF))
Local $hFileOpen = FileOpen($sFilePath, FileGetEncoding($sFilePath) + $FO_OVERWRITE)
If $hFileOpen = -1 Then Return SetError(3, 0, 0)
FileWrite($hFileOpen, $sData)
FileClose($hFileOpen)
Return 1
EndFunc
Global Const $LB_ADDSTRING = 0x0180
Global Const $LB_GETCURSEL = 0x0188
Global Const $LB_GETTEXT = 0x0189
Global Const $LB_GETTEXTLEN = 0x018A
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
If @error Then Return SetError(@error, @extended, "")
If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
Return $aResult
EndFunc
Global Const $tagGDIPSTARTUPINPUT = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $IMAGE_BITMAP = 0
Global Const $IMAGE_ICON = 1
Global Const $IMAGE_CURSOR = 2
Global Const $LR_DEFAULTCOLOR = 0x0000
Global Const $__WINVER = __WINVER()
Func _WinAPI_FreeLibrary($hModule)
Local $aResult = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hModule)
If @error Then Return SetError(@error, @extended, False)
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
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
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
Func _WinAPI_DeleteObject($hObject)
Local $aResult = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
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
Func _GUICtrlListBox_GetCurSel($hWnd)
If IsHWnd($hWnd) Then
Return _SendMessage($hWnd, $LB_GETCURSEL)
Else
Return GUICtrlSendMsg($hWnd, $LB_GETCURSEL, 0, 0)
EndIf
EndFunc
Func _GUICtrlListBox_GetText($hWnd, $iIndex)
Local $tText = DllStructCreate("wchar Text[" & _GUICtrlListBox_GetTextLen($hWnd, $iIndex) + 1 & "]")
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
_SendMessage($hWnd, $LB_GETTEXT, $iIndex, $tText, 0, "wparam", "struct*")
Return DllStructGetData($tText, "Text")
EndFunc
Func _GUICtrlListBox_GetTextLen($hWnd, $iIndex)
If IsHWnd($hWnd) Then
Return _SendMessage($hWnd, $LB_GETTEXTLEN, $iIndex)
Else
Return GUICtrlSendMsg($hWnd, $LB_GETTEXTLEN, $iIndex, 0)
EndIf
EndFunc
Global Const $CBS_AUTOHSCROLL = 0x40
Global Const $CBS_DROPDOWNLIST = 0x3
Global Const $CB_SELECTSTRING = 0x14D
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_HSCROLL = 0x00100000
Global Const $WS_VSCROLL = 0x00200000
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_POPUP = 0x80000000
Global Const $WS_EX_MDICHILD = 0x00000040
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $GUI_SS_DEFAULT_GUI = BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
Func _WinAPI_DeleteEnhMetaFile($hEmf)
Local $aRet = DllCall('gdi32.dll', 'bool', 'DeleteEnhMetaFile', 'handle', $hEmf)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Func _WinAPI_RemoveFontMemResourceEx($hFont)
Local $aRet = DllCall('gdi32.dll', 'bool', 'RemoveFontMemResourceEx', 'handle', $hFont)
If @error Then Return SetError(@error, @extended, False)
Return $aRet[0]
EndFunc
Global $__g_hGDIPDll = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True
Func _GDIPlus_BitmapDispose($hBitmap)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
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
Func _GUICtrlMenu_DestroyMenu($hMenu)
Local $aResult = DllCall("user32.dll", "bool", "DestroyMenu", "handle", $hMenu)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
OnAutoItExitRegister(_GDIPlus_Shutdown)
OnAutoItExitRegister(_Resource_DestroyAll)
_GDIPlus_Startup()
Global Enum $RESOURCE_ERROR_NONE, $RESOURCE_ERROR_FINDRESOURCE, $RESOURCE_ERROR_INVALIDCONTROLID, $RESOURCE_ERROR_INVALIDCLASS, $RESOURCE_ERROR_INVALIDRESOURCENAME, $RESOURCE_ERROR_INVALIDRESOURCETYPE, $RESOURCE_ERROR_LOCKRESOURCE, $RESOURCE_ERROR_LOADBITMAP, $RESOURCE_ERROR_LOADCURSOR, $RESOURCE_ERROR_LOADICON, $RESOURCE_ERROR_LOADIMAGE, $RESOURCE_ERROR_LOADLIBRARY, $RESOURCE_ERROR_LOADSTRING, $RESOURCE_ERROR_SETIMAGE
Global Const $RESOURCE_LANG_DEFAULT = 0
Global Enum $RESOURCE_RT_BITMAP = 1000, $RESOURCE_RT_ENHMETAFILE, $RESOURCE_RT_FONT
Global Enum $RESOURCE_POS_H, $RESOURCE_POS_W, $RESOURCE_POS_MAX
Global Const $RESOURCE_STORAGE_GUID = 'CA37F1E6-04D1-11E4-B340-4B0AE3E253B6'
Global Enum $RESOURCE_STORAGE, $RESOURCE_STORAGE_FIRSTINDEX
Global Enum $RESOURCE_STORAGE_ID, $RESOURCE_STORAGE_INDEX, $RESOURCE_STORAGE_RESETCOUNT, $RESOURCE_STORAGE_UBOUND
Global Enum $RESOURCE_STORAGE_DLL, $RESOURCE_STORAGE_CASTRESTYPE, $RESOURCE_STORAGE_LENGTH, $RESOURCE_STORAGE_PTR, $RESOURCE_STORAGE_RESLANG, $RESOURCE_STORAGE_RESNAMEORID, $RESOURCE_STORAGE_RESTYPE, $RESOURCE_STORAGE_MAX, $RESOURCE_STORAGE_ADD, $RESOURCE_STORAGE_DESTROY, $RESOURCE_STORAGE_DESTROYALL, $RESOURCE_STORAGE_GET
Func _Resource_DestroyAll()
Return __Resource_Storage($RESOURCE_STORAGE_DESTROYALL, Null, Null, Null, Null, Null, Null, Null)
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
Func _GUICtrlComboBox_SelectString($hWnd, $sText, $iIndex = -1)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Return _SendMessage($hWnd, $CB_SELECTSTRING, $iIndex, $sText, 0, "wparam", "wstr")
EndFunc
Const $ProgramName = "SMITE Optimizer"
Const $ProgramVersion = "V1.2.2"
Const $ProgramVersionRE = "1.2.2"
If RegRead("HKCU\Software\SMITE Optimizer\","PerformUpdate") = "TRUE" Then
InetGet(IniRead(@TempDir & "\SMITE OptimizerVersion.ini","Download","Download","NotFound"),@TempDir & "\Update.exe",1,0)
If @Error Then
MsgBox(0,"ERROR!","There was a problem downloading the file :(")
RegWrite("HKCU\Software\SMITE Optimizer\","PerformUpdate","REG_SZ","FALSE")
Run(RegRead("HKCU\Software\SMITE Optimizer\","ProgramPath"))
Exit
EndIf
FileDelete(RegRead("HKCU\Software\SMITE Optimizer\","ProgramPath"))
FileMove(@TempDir & "\Update.exe",RegRead("HKCU\Software\SMITE Optimizer\","ProgramPath"))
RegWrite("HKCU\Software\SMITE Optimizer\","PerformUpdate","REG_SZ","FALSE")
Run(RegRead("HKCU\Software\SMITE Optimizer\","ProgramPath"))
Exit
ElseIf FileExists(@TempDir & "\SMITE OptimizerVersion.ini") or FileExists(@TempDir & "\SMITE OptimizerUpdt.exe") Then
FileDelete(@TempDir & "\SMITE OptimizerVersion.ini")
FileDelete(@TempDir & "\SMITE OptimizerUpdt.exe")
FileDelete(@TempDir & "\Update.exe")
EndIf
If RegRead("HKCU\Software\SMITE Optimizer\","ProgramPath") <> @ScriptFullPath Then
RegWrite("HKCU\Software\SMITE Optimizer\","ProgramPath","REG_SZ",@ScriptFullPath)
RegWrite("HKCU\Software\SMITE Optimizer\","UpdateCheck","REG_SZ","TRUE")
RegWrite("HKCU\Software\SMITE Optimizer\","PerformUpdate","REG_SZ","FALSE")
EndIf
If RegRead("HKCU\Software\SMITE Optimizer\","ProgramVersion") <> $ProgramVersionRE Then
RegWrite("HKCU\Software\SMITE Optimizer\","ProgramVersion","REG_SZ",$ProgramVersionRE)
EndIf
If RegRead("HKCU\Software\SMITE Optimizer\","UpdateCheck") = "TRUE" Then
Local $Ini = InetGet("https://pastebin.com/raw/SXnHTU9H",@TempDir & "\SMITE OptimizerVersion.ini")
Local $UpdtMsgBox
if $Ini = 0 Then
MsgBox(0,"ERROR!","Could not connect to the Server."& @CRLF & "You can manually check for updates by visiting: www.reddit.com/r/SMITEOptimizer" & @CRLF & @CRLF & "You can also disable the automatic update check in the settings.")
Else
Global $UpdaterVersionVar = IniRead(@TempDir & "\SMITE OptimizerVersion.ini","Version","Version","")
If IniRead(@TempDir & "\SMITE OptimizerVersion.ini","Version","Version","") > $ProgramVersionRE Then
$DownloadLink = IniRead(@TempDir & "\SMITE OptimizerVersion.ini","Download","Download","NotFound")
$UpdtMsgBox = MsgBox(4,"Information","A new version was found! (V"&IniRead(@TempDir & "\SMITE OptimizerVersion.ini","Version","Version","")&")"&@CRLF&"Update info: "&IniRead(@TempDir & "\SMITE OptimizerVersion.ini","Message","Message","")&@CRLF&"Download now?")
EndIf
If $UpdtMsgBox = 6 Then
FileCopy(@ScriptFullPath,@TempDir & "\SMITE OptimizerUpdt.exe")
RegWrite("HKCU\Software\SMITE Optimizer\","PerformUpdate","REG_SZ","TRUE")
Run(@TempDir & "\SMITE OptimizerUpdt.exe")
Exit
Else
FileDelete(@TempDir & "\SMITE OptimizerVersion.ini")
EndIf
EndIf
Run("RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess " & 8)
EndIf
Global Const $FPSVarsArray[4] = ["bSmoothFrameRate","MinSmoothedFrameRate","MaxSmoothedFrameRate"]
Global Const $EngineVarsArray[6] = ["MaxParticleResize","MaxParticleResizeWarn","MaxParticleVertexMemory","MinimumPoolSize","MaximumPoolSize"]
Global Const $WorldVarsArray[36] = ["StaticDecals","DynamicDecals","DecalCullDistanceScale","DynamicLights","DynamicShadows","LightEnvironmentShadows","CompositeDynamicLights","SHSecondaryLighting","DepthOfField","Bloom","bAllowLightShafts","Distortion","DropParticleDistortion","LensFlares","AllowRadialBlur","AllowSubsurfaceScattering","AllowImageReflections","bAllowHighQualityMaterials","SkeletalMeshLODBias","ParticleLODBias","DetailMode","MaxDrawDistanceScale","ShadowFilterQualityBias","MaxShadowResolution","MaxWholeSceneDominantShadowResolution","bAllowWholeSceneDominantShadows","bUseConservativeShadowBounds","bAllowRagdolling","PerfScalingBias","StaticMeshLODBias","bAllowDropShadows","AllowScreenDoorFade","AllowScreenDoorLODFading","SpeedTreeWind","ShadowTexelsPerPixel","Fog (Conquest and other)"]
Global Const $ClientVarsArray[3] = ["AllowD3D11","PreferD3D11","UseD3D11Beta"]
Global Const $TextureVarsArray[9] = ["World","Character","Terrain","NPC","Weapon","Vehicle","Shadows","Skybox","Effects"]
Global $EditBoxGUI, $EditBoxGUIButtonRestore = 2,$EditBoxGUIButtonDeleteBackups = 2, $EditBoxGUIButtonHelp1 = 2, $EditBoxGUIButtonHelp2 = 2, $EditBoxGUIButtonHelp3 = 2, $DebugGUIButtonResetConfig = 2, $MainGUIDrawn = false, $RestoreGUIAlive = false
Global Const $ConfigBackupPath = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders","Personal")&"\My Games\SMITE Config Backup\"
Global Const $TextureQualityHive[9][9][4] = [ [ [ "TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_World=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=1821,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_World=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=1594,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_World=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=1367,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_World=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=1140,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_World=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=913,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_World=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=686,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_World=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=459,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_World=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_Character=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Character=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_CharacterSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=512,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=3641,MaxLODSizeTexturePack=3641,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=3641,MaxLODSizeTexturePack=3641,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=456,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=3186,MaxLODSizeTexturePack=3186,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=3186,MaxLODSizeTexturePack=3186,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=400,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=2731,MaxLODSizeTexturePack=2731,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=2731,MaxLODSizeTexturePack=2731,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=344,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=2276,MaxLODSizeTexturePack=2276,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=2276,MaxLODSizeTexturePack=2276,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=288,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=232,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=1366,MaxLODSizeTexturePack=1366,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=1366,MaxLODSizeTexturePack=1366,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=176,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=911,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=911,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=120,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WorldDetail=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_NPC=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_NPC=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_NPC=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_NPCSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=114,MaxLODSize=456,MaxLODSizeTexturePack=456,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=114,MaxLODSize=456,MaxLODSizeTexturePack=456,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=114,MaxLODSize=456,MaxLODSizeTexturePack=456,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=100,MaxLODSize=400,MaxLODSizeTexturePack=400,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=100,MaxLODSize=400,MaxLODSizeTexturePack=400,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=100,MaxLODSize=400,MaxLODSizeTexturePack=400,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=86,MaxLODSize=344,MaxLODSizeTexturePack=344,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=86,MaxLODSize=344,MaxLODSizeTexturePack=344,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=86,MaxLODSize=344,MaxLODSizeTexturePack=344,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=72,MaxLODSize=288,MaxLODSizeTexturePack=288,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=72,MaxLODSize=288,MaxLODSizeTexturePack=288,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=72,MaxLODSize=288,MaxLODSizeTexturePack=288,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=58,MaxLODSize=232,MaxLODSizeTexturePack=232,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=58,MaxLODSize=232,MaxLODSizeTexturePack=232,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=58,MaxLODSize=232,MaxLODSizeTexturePack=232,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_Weapon=(MinLODSize=44,MaxLODSize=176,MaxLODSizeTexturePack=176,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=44,MaxLODSize=176,MaxLODSizeTexturePack=176,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=44,MaxLODSize=176,MaxLODSizeTexturePack=176,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=30,MaxLODSize=120,MaxLODSizeTexturePack=120,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=30,MaxLODSize=120,MaxLODSizeTexturePack=120,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=30,MaxLODSize=120,MaxLODSizeTexturePack=120,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Weapon=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_WeaponSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=228,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=456,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=228,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=200,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=400,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=200,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=172,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=344,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=172,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ _
"TEXTUREGROUP_Vehicle=(MinLODSize=144,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=288,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=144,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=116,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=232,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=116,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=88,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=176,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=88,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=60,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=120,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=60,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""], [ "TEXTUREGROUP_Vehicle=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_VehicleSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", ""] ],[ [ "TEXTUREGROUP_Lightmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=456,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=456,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=228,MaxLODSize=3641,MaxLODSizeTexturePack=3641,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ _
"TEXTUREGROUP_Lightmap=(MinLODSize=400,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=400,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=200,MaxLODSize=3186,MaxLODSizeTexturePack=3186,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=344,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=344,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=172,MaxLODSize=2731,MaxLODSizeTexturePack=2731,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=288,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=288,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=144,MaxLODSize=2276,MaxLODSizeTexturePack=2276,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=232,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=232,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=116,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=176,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=176,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=88,MaxLODSize=1366,MaxLODSizeTexturePack=1366,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=120,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=120,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=60,MaxLODSize=911,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""], [ "TEXTUREGROUP_Lightmap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_Shadowmap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_ImageBasedReflection=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", ""] ],[ [ _
"TEXTUREGROUP_Skybox=(MinLODSize=2048,MaxLODSize=2048,MaxLODSizeTexturePack=8192,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1821,MaxLODSize=1821,MaxLODSizeTexturePack=7282,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1594,MaxLODSize=1594,MaxLODSizeTexturePack=6372,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1367,MaxLODSize=1367,MaxLODSizeTexturePack=5462,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=1140,MaxLODSize=1140,MaxLODSizeTexturePack=4552,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=913,MaxLODSize=913,MaxLODSizeTexturePack=3642,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=686,MaxLODSize=686,MaxLODSizeTexturePack=2732,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=459,MaxLODSize=459,MaxLODSizeTexturePack=1822,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""], [ "TEXTUREGROUP_Skybox=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", "", ""] ],[ [ "TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""], [ "TEXTUREGROUP_Effects=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", "", ""] ] ]
RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
if @Error <> 0 or RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine") = "" then
Global $TempInitGUI = GUICreate("SMITE Optimizer - Configuration Discovery",600,275,-1,-1)
Global $TempInitGUIInfoLabel = GUICtrlCreateLabel("Welcome, thank you for using the SMITE Optimizer! It appears that this is your first time starting this program."&@CRLF&"Please help the program discover your configuration files. You can choose the paths manually or let the program search them."&@CRLF&"Please note that, no matter what you click, the program is smart enough to handle problems, so you can't do anything wrong.",5,5,590,(13*3))
GUICtrlSetBkColor(-1,-2)
Global $TempInitGUIButtonSelector1 = GUICtrlCreateButton("Choose paths manually",13,50,165,23)
Global $TempInitGUIButtonSelector2 = GUICtrlCreateButton("Non-Steam Mode",13,75,165,23)
Global $TempInitGUIButtonSelector3 = GUICtrlCreateButton("Steam Mode",13,100,165,23)
Global $TempInitGUIButtonSelector4 = GUICtrlCreateButton("Let the program search for them",13,125,165,23)
Global $TempInitGUILabelSelector1Info = GUICtrlCreateLabel("< Lets you choose the paths manually.",185,53,300,13)
Global $TempInitGUILabelSelector2Info = GUICtrlCreateLabel("< If you have SMITE installed without the use of STEAM, select this",185,53+26,375,13)
Global $TempInitGUILabelSelector3Info = GUICtrlCreateLabel("< If you have SMITE installed through STEAM, select this",185,104,375,13)
Global $TempInitGUILabelSelector4Info = GUICtrlCreateLabel("< Select this if you have no clue of what is going on",185,129,375,13)
GUICtrlSetBkColor(-1,-2)
Global $TempInitGUILabelPathSelectorInfo = GUICtrlCreateLabel("Please input the paths: ",5,(175-13-5),300,13)
Global $TempInitGUIInputBattle = GUICtrlCreateInput("BattleEngine.ini OR DefaultEngine.ini ..",5,175,525,20,2048)
Global $TempInitGUIInputSystem = GUICtrlCreateInput("BattleSystemSettings.ini OR DefaultSystemSettings.ini ..",5,200,525,20,2048)
Global $TempInitGUIButtonBattle = GUICtrlCreateButton("Select..",530,175,70,20)
Global $TempInitGUIButtonSystem = GUICtrlCreateButton("Select..",530,200,70,20)
Global $TempInitGUIButtonDone = GUICtrlCreateButton("Done",2,223,100,50)
Global $TempInitGUILabelScan = GUICtrlCreateLabel("Scanning for Configs... (This can take a while)",115,160,400,50)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetFont(-1,14)
Global $TempInitGUILabelScanInfo = GUICtrlCreateLabel("While you are waiting, why not enjoy the sunshine? .. mhm i should have guessed, there is no sun for you right now huh?"&@CRLF&"Okay, i got a better idea, i'm just gonna put my favorite poem here. 'Light and darkness, live and death, flora and fauna,"&@CRLF&"parts of reality, parts of life. To find yourself, alive.' .. Stunningly beautiful no? Well, it's not my favorite poem, it's a poem i just"&@CRLF&"came up with. If i'm being honest i'm not even sure if that classifies as a poem... But what do i know... i'm just a hobby"&@CRLF&"programmer trying to make you feel comfortable while waiting. Okay.. idk what to say anymore so i'm just gonna fill the rest with"&@CRLF&"sample text.. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore",5,190,-1,-1)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetState($TempInitGUILabelPathSelectorInfo,32)
GUICtrlSetState($TempInitGUIInputBattle,32)
GUICtrlSetState($TempInitGUIInputSystem,32)
GUICtrlSetState($TempInitGUIButtonBattle,32)
GUICtrlSetState($TempInitGUIButtonSystem,32)
GUICtrlSetState($TempInitGUIButtonDone,32)
GUICtrlSetState($TempInitGUILabelScan,32)
GUICtrlSetState($TempInitGUILabelScanInfo,32)
GUISetState(@SW_SHOW)
While WinGetHandle($TempInitGUI) <> 0
Switch GUIGetMsg()
Case -3
Exit
Case $TempInitGUIButtonSelector1
GUICtrlSetState($TempInitGUILabelPathSelectorInfo,16)
GUICtrlSetState($TempInitGUIInputBattle,16)
GUICtrlSetState($TempInitGUIInputSystem,16)
GUICtrlSetState($TempInitGUIButtonBattle,16)
GUICtrlSetState($TempInitGUIButtonSystem,16)
GUICtrlSetState($TempInitGUIButtonDone,16)
Case $TempInitGUIButtonBattle
Local $TempVar = FileOpenDialog("Select BattleEngine.ini OR DefaultEngine.ini",@DesktopDir,"Configuration Files (*.ini)",1)
if FileExists($TempVar) Then
Local $SStart = StringLen($TempVar), $SEnd = 0
For $I = StringLen($TempVar) To 1 Step -1
if StringMid($TempVar,$I,1) == "\" Then
$SEnd = $I
ExitLoop
EndIf
Next
if StringMid($TempVar,$SEnd+1,$SStart) = "BattleEngine.ini" or StringMid($TempVar,$SEnd+1,$SStart) = "DefaultEngine.ini" Then
GUICtrlSetData($TempInitGUIInputBattle,$TempVar)
Else
MsgBox(0,"ERROR!","It appears you selected the wrong file.")
EndIf
EndIf
Case $TempInitGUIButtonSystem
Local $TempVar = FileOpenDialog("Select BattleSystemSettings.ini OR DefaultSystemSettings.ini",@DesktopDir,"Configuration Files (*.ini)",1)
if FileExists($TempVar) Then
Local $SStart = StringLen($TempVar), $SEnd = 0
For $I = StringLen($TempVar) To 1 Step -1
if StringMid($TempVar,$I,1) == "\" Then
$SEnd = $I
ExitLoop
EndIf
Next
if StringMid($TempVar,$SEnd+1,$SStart) = "BattleSystemSettings.ini" or StringMid($TempVar,$SEnd+1,$SStart) = "DefaultSystemSettings.ini" Then
GUICtrlSetData($TempInitGUIInputSystem,$TempVar)
Else
MsgBox(0,"ERROR!","It appears you selected the wrong file.")
EndIf
EndIf
Case $TempInitGUIButtonDone
if FileExists(GUICtrlRead($TempInitGUIInputBattle)) and FileExists(GUICtrlRead($TempInitGUIInputSystem)) then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ",GUICtrlRead($TempInitGUIInputBattle))
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ",GUICtrlRead($TempInitGUIInputSystem))
GUIDelete($TempInitGUI)
CheckConfigPath()
Else
MsgBox(0,"ERROR!","Something went wrong, the paths seem to be incorrect.")
EndIf
Case $TempInitGUIButtonSelector2
if FileExists("C:\Users\"&@UserName&"\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini") and FileExists("C:\Users\"&@UserName&"\Documents\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini") Then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ","C:\Users\"&@UserName&"\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ","C:\Users\"&@UserName&"\Documents\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini")
GUIDelete($TempInitGUI)
CheckConfigPath()
Else
MsgBox(0,"ERROR!","Could not find non-steam configuration files.")
EndIf
Case $TempInitGUIButtonSelector3
if fileExists(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")) = 1 Then
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ",RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")&"\BattleGame\Config\DefaultEngine.ini")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ",RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")&"\BattleGame\Config\DefaultSystemSettings.ini")
GUIDelete($TempInitGUI)
CheckConfigPath()
Else
MsgBox(0,"ERROR!","It seems like your game is not installed through STEAM or uses non-steam configuration files.")
EndIf
Case $TempInitGUIButtonSelector4
GUICtrlSetState($TempInitGUILabelPathSelectorInfo,32)
GUICtrlSetState($TempInitGUIInputBattle,32)
GUICtrlSetState($TempInitGUIInputSystem,32)
GUICtrlSetState($TempInitGUIButtonBattle,32)
GUICtrlSetState($TempInitGUIButtonSystem,32)
GUICtrlSetState($TempInitGUIButtonDone,32)
GUICtrlSetState($TempInitGUILabelScan,16)
GUICtrlSetState($TempInitGUILabelScanInfo,16)
ScanForConfigs()
GUICtrlSetState($TempInitGUILabelPathSelectorInfo,16)
GUICtrlSetState($TempInitGUIInputBattle,16)
GUICtrlSetState($TempInitGUIInputSystem,16)
GUICtrlSetState($TempInitGUIButtonBattle,16)
GUICtrlSetState($TempInitGUIButtonSystem,16)
GUICtrlSetState($TempInitGUIButtonDone,16)
GUICtrlSetState($TempInitGUILabelScan,32)
GUICtrlSetState($TempInitGUILabelScanInfo,32)
EndSwitch
Sleep(1)
WEnd
Else
CheckConfigPath()
EndIf
Func CheckConfigPath()
if fileExists(RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")) Then
Local $TempVar = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
Local $SStart = StringLen($TempVar), $SEnd = 0
For $I = StringLen($TempVar) To 1 Step -1
if StringMid($TempVar,$I,1) == "\" Then
$SEnd = $I
ExitLoop
EndIf
Next
if StringMid($TempVar,$SEnd+1,$SStart) = "BattleEngine.ini" Then
Global $IsSteamUser = 0
Else
Global $IsSteamUser = 1
EndIf
Global $SMITEEngineIniPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
Global $SMITEBattleSystemSettingsIniPath = RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
if $MainGUIDrawn = false then
DrawMainGUI()
DrawLabels()
DrawButtonsAndInputs()
EndIf
Return 0
Else
MsgBox(0,"ERROR!","There was a problem reading the configuration files. It seems like they are invalid or do not exist anymore."&@CRLF&"Running Configuration Discovery...")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathEngine","REG_SZ","")
RegWrite("HKCU\Software\SMITE Optimizer\","ConfigPathSystem","REG_SZ","")
ShellExecute(@ScriptFullPath)
Exit
EndIf
EndFunc
Func ScanForConfigs()
Local $PathPrefixTemp = DriveGetDrive("fixed")
For $I = 1 To UBound($PathPrefixTemp)-1 Step 1
Local $TempReccurTest = _FileListToArrayRec($PathPrefixTemp[$I],"Smite",2,1,1,2)
For $B = 1 To UBound($TempReccurTest)-1 Step 1
if fileExists($TempReccurTest[$B]&"\BattleGame\Config\BattleEngine.ini") or fileExists($TempReccurTest[$B]&"\BattleGame\Config\DefaultEngine.ini") Then
if fileExists($TempReccurTest[$B]&"\BattleGame\Config\BattleEngine.ini") then
GUICtrlSetData($TempInitGUIInputBattle,$TempReccurTest[$B]&"\BattleGame\Config\BattleEngine.ini")
GUICtrlSetData($TempInitGUIInputSystem,$TempReccurTest[$B]&"\BattleGame\Config\BattleSystemSettings.ini")
Return 0
ElseIf fileExists($TempReccurTest[$B]&"\BattleGame\Config\DefaultEngine.ini") Then
GUICtrlSetData($TempInitGUIInputBattle,$TempReccurTest[$B]&"\BattleGame\Config\DefaultEngine.ini")
GUICtrlSetData($TempInitGUIInputSystem,$TempReccurTest[$B]&"\BattleGame\Config\DefaultSystemSettings.ini")
Return 0
EndIf
EndIf
Next
Next
MsgBox(0,"ERROR!","Could not find SMITE Configuration."&@CRLF&"Perhaps you don't have the game installed?")
ShellExecute(@ScriptFullPath)
Exit
EndFunc
Func DrawMainGUI()
Global $MainGUIDrawn = true
if $IsSteamUser = 1 Then
Global $MainGUI = GUICreate($ProgramName&" "&$ProgramVersion&" Steam mode",800,420,-1,-1)
Else
Global $MainGUI = GUICreate($ProgramName&" "&$ProgramVersion,800,420,-1,-1)
EndIf
GUICtrlCreateLabel("IMPORTANT: This program does NOT interact with SMITE directly. It only edits the config which is NOT a bannable offense.",5,385,600,25)
GUICtrlSetBkColor(-1,-2)
GUICtrlCreateGroup("",5,5,590,379)
Global $MainGUIApplySettings = GUICtrlCreateButton("Apply settings",600,348,190,30)
Global $MainGUICheckboxUseRecommendedSettings = GUiCtrlCreateCheckbox("Use recommended settings",603,329,150,17)
Global $CheckboxApplyFPSSettings = GUICtrlCreateCheckbox("Apply FPS settings", 600,85,105,15)
Global $CheckboxApplyEngineSettings = GUICtrlCreateCheckbox("Apply Engine Settings",600,230,135,15)
Global $CheckboxApplyClientSettings = GUICtrlCreateCheckbox("Apply Client Settings",600,305,135,15)
Global $CheckboxUseDirectX11 = GUICtrlCreateCheckbox("Use DirectX11",600,265,135,15)
Global $CheckboxApplyTextureSettings = GUICtrlCreateCheckbox("Apply Texture Settings",400,365,135,15)
Global $Menu = GUICtrlCreateMenu("SO "&$ProgramVersion)
Global $MenuRedditLink = GUICtrlCreateMenuItem("Open the SO Subreddit",$Menu)
Global $MenuChangelog= GUICtrlCreateMenuItem("Changelog",$Menu)
Global $MenuCopyrightCredits = GUICtrlCreateMenuItem("Copyright and Credits",$Menu)
Global $MenuExit = GUICtrlCreateMenuItem("Exit",$Menu)
Global $MenuSettings = GUICtrlCreateMenu("Settings")
Global $MenuSettingsUpdateCheckOnOff = GUICtrlCreateMenuItem("Update Check On/Off",$MenuSettings)
Global $MenuSettingsRestoreConfig = GUICtrlCreateMenuItem("Restore Configuration",$MenuSettings)
Global $MenuDonate = GUICtrlCreateMenu("Donate")
Global $MenuDonateItem = GUICtrlCreateMenuItem("Donate",$MenuDonate)
Global $MenuHelp = GUICtrlCreateMenu("Help")
Global $MenuHelpItem = GUICtrlCreateMenuItem("Help",$MenuHelp)
Global $MenuDebugItem = GUICtrlCreateMenuItem("Debug",$MenuHelp)
GUICtrlCreateGroup("FPS Settings",595,5,200,100)
GUICtrlCreateGroup("Engine Settings",595,110,200,140)
GUICtrlCreateGroup("World Settings",5,5,391,379)
GUICtrlCreateGroup("Client Settings",595,250,200,75)
GUICtrlCreateGroup("Texture Settings",395,5,200,379)
GUICtrlCreateGroup("",391/2,5,3,379)
For $I = 0 To 16 Step 1
GUICtrlCreateGroup("",5,32+(20*$I),390,5)
Next
GUISetState()
EndFunc
Func DrawLabels()
For $I = 0 To 2 Step 1
GUICtrlCreateLabel($FPSVarsArray[$I],600,25+(20*$I),140,15)
GUICtrlSetBkColor(-1,-2)
Next
For $I = 0 To 4 Step 1
GUICtrlCreateLabel($EngineVarsArray[$I],600,130+(20*$I),140,15)
GUICtrlSetBkColor(-1,-2)
Next
For $I = 0 To 35 Step 1
if $I > 17 Then
GUICtrlCreateLabel($WorldVarsArray[$I],200,20+(20*($I-18)),140,15)
if $I = 24 Then
GUICtrlSetTip(-1,"MaxWholeSceneDominantShadowResolution")
EndIf
if $I = 25 Then
GUICtrlSetTip(-1,"bAllowWholeSceneDominantShadows")
EndIf
if $I = 26 Then
GUICtrlSetTip(-1,"bUseConservativeShadowBounds")
EndIf
Else
GUICtrlCreateLabel($WorldVarsArray[$I],10,20+(20*$I),140,15)
EndIf
GUICtrlSetBkColor(-1,-2)
Next
For $I = 0 To 8 Step 1
GUICtrlCreateLabel($TextureVarsArray[$I]&" Quality: ",400,20+(36*$I),190,15)
GUICtrlSetBkColor(-1,-2)
Next
EndFunc
Func DrawButtonsAndInputs()
Global $VarsButtonArray[0], $VarsInputArray[0]
For $I = 0 To 0 Step 1
ReDim $VarsButtonArray[UBound($VarsButtonArray) + 1]
if iniRead($SMITEEngineIniPath,"Engine.GameEngine",$FPSVarsArray[$I],"") = "TRUE" Then
$VarsButtonArray[$I] = GUICtrlCreateButton("TRUE",741,24,50,17)
Else
$VarsButtonArray[$I] = GUICtrlCreateButton("FALSE",741,24,50,17)
EndIf
Next
For $I = 0 To 1 Step 1
ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
$VarsInputArray[$I] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"Engine.GameEngine",$FPSVarsArray[$I+1],""),741,44+(20*$I),50,17,8192)
Next
For $I = 0 To 4 Step 1
ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
If $I < 3 Then
$VarsInputArray[$I+2] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"Engine.Engine",$EngineVarsArray[$I],""),741,130+(20*$I),50,17,8192)
Else
$VarsInputArray[$I+2] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"TextureStreaming",$EngineVarsArray[$I],""),741,130+(20*$I),50,17,8192)
EndIf
Next
For $I = 0 To 34 Step 1
ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
if $I = 2 Then
$VarsInputArray[$I+7] = GUICtrlCreateInput(iniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings",$WorldVarsArray[$I],""),145,19+(20*$I),50,17,8192)
Else
if $I = 18 or $I = 19 or $I = 20 or $I = 21 or $I = 22 or $I = 23 or $I = 24 or $I = 28 or $I = 29 or $I = 34 Then
$VarsInputArray[$I+7] = GUICtrlCreateInput(iniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings",$WorldVarsArray[$I],""),343,19+(20*($I-18)),50,17,8192)
EndIf
EndIf
Next
For $I = 0 To 35 Step 1
ReDim $VarsButtonArray[UBound($VarsButtonArray) + 1]
if $I <> 2 and $I <> 18 and $I <> 19 and $I <> 20 and $I <> 21 and $I <> 22 and $I <> 23 and $I <> 24 and $I <> 28 and $I <> 29 and $I <> 34 Then
if $I < 18 Then
if iniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings",$WorldVarsArray[$I],"") = "TRUE" Then
$VarsButtonArray[$I+1] = GUICtrlCreateButton("TRUE",145,19+(20*$I),50,17)
Else
$VarsButtonArray[$I+1] = GUICtrlCreateButton("FALSE",145,19+(20*$I),50,17)
EndIf
Else
if iniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings",$WorldVarsArray[$I],"") = "TRUE" Then
$VarsButtonArray[$I+1] = GUICtrlCreateButton("TRUE",343,19+(20*($I-18)),50,17)
Else
$VarsButtonArray[$I+1] = GUICtrlCreateButton("FALSE",343,19+(20*($I-18)),50,17)
EndIf
EndIf
EndIf
Next
Global $TextureCombos[9]
Local $TypeOptions = "Best|Very High|High|Medium|Low|Very Low|Absolute Worst|Potato|N64 Graphics, but 64 times worse"
For $I = 0 To 8 Step 1
$TextureCombos[$I] = GUICtrlCreateCombo("",400,35+(36*$I),190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1,$TypeOptions)
Next
Global $VarsInputArrayTemp = $VarsInputArray
Global $VarsButtonArrayTemp = $VarsButtonArray
For $I = UBound($VarsInputArrayTemp) - 1 To 0 Step -1
If $VarsInputArrayTemp[$I] = "" Then
_ArrayDelete($VarsInputArrayTemp, $I)
EndIf
Next
For $I = UBound($VarsButtonArrayTemp) - 1 To 0 Step -1
If $VarsButtonArrayTemp[$I] = "" Then
_ArrayDelete($VarsButtonArrayTemp, $I)
EndIf
Next
EndFunc
Func DrawDebugGUI()
Global $DebugGUI = GUICreate("Debug...",500,125,-1,-1,($GUI_SS_DEFAULT_GUI - $WS_MINIMIZEBOX))
If $IsSteamUser = 1 Then
$DebugGUIConfigPathLabel = GUICtrlCreateLabel("DefaultEngine: "&RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine"),10,10,-1,13)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetTip(-1,"DefaultEngine: "&RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine"))
$DebugGUIConfigPathLabel2 = GUICtrlCreateLabel("DefaultSystemSettings: "&RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem"),10,25)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetTip(-1,"DefaultSystemSettings: "&RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem"))
Else
$DebugGUIConfigPathLabel = GUICtrlCreateLabel("BattleEngine: "&RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine"),10,10,-1,13)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetTip(-1,"BattleEngine: "&RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathEngine"))
$DebugGUIConfigPathLabel2 = GUICtrlCreateLabel("BattleSystemSettings: "&RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem"),10,25)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetTip(-1,"BattleSystemSettings: "&RegRead("HKCU\Software\SMITE Optimizer\","ConfigPathSystem"))
EndIf
Local $IsSteamModeOn
if $IsSteamUser = 1 Then
$IsSteamModeOn = "True"
Else
$IsSteamModeOn = "False"
EndIf
$DebugGUISteamModeLabel = GUICtrlCreateLabel("SteamMode = "&$IsSteamModeOn,10,40)
GUICtrlSetBkColor(-1,-2)
if IsDeclared("UpdaterVersionVar") Then
$DebugGUIUpdateVar = GUICtrlCreateLabel("Update Check:   Updater Version: "&$UpdaterVersionVar&"   Current Version: "&$ProgramVersionRE,10,55)
GUICtrlSetBkColor(-1,-2)
Else
$DebugGUIUpdateVar = GUICtrlCreateLabel("Update Check:   Updater Version: Failed to connect.   Current Version: "&$ProgramVersionRE,10,55)
GUICtrlSetBkColor(-1,-2)
EndIf
$DebugGUIButtonResetConfig = GUICtrlCreateButton("Reset Config Paths",390,92)
GUISetState(@SW_SHOW,$DebugGUI)
GUISetState(@SW_DISABLE,$MainGUI)
EndFunc
Func RedrawButtonsAndInputs()
For $I = 0 To Ubound($VarsButtonArray)-1 Step 1
GUICtrlDelete($VarsButtonArray[$I])
Next
For $I = 0 To Ubound($VarsInputArray)-1 Step 1
GUICtrlDelete($VarsInputArray[$I])
Next
For $I = 0 To 8 Step 1
GUICtrlDelete($TextureCombos[$I])
Next
GUICtrlSetState($CheckboxApplyFPSSettings,4)
GUICtrlSetState($CheckboxApplyEngineSettings,4)
GUICtrlSetState($CheckboxApplyTextureSettings,4)
DrawButtonsAndInputs()
GUICtrlSetState($MainGUICheckboxUseRecommendedSettings,4)
EndFunc
Func UseRecommendedSettings()
Local $ArrayInput[18] = [60,300,512,5120,900,0,0,0.4,1,10,0,0.8,1,256,256,0.2,1,0]
Local $ArrayButton[26] = ["TRUE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","TRUE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE"]
For $I = 0 To UBound($VarsInputArrayTemp)-1 Step 1
GUICtrlSetData($VarsInputArrayTemp[$I],$ArrayInput[$I])
Next
For $I = 0 To UBound($VarsButtonArrayTemp)-1 Step 1
GUICtrlSetData($VarsButtonArrayTemp[$I],$ArrayButton[$I])
Next
For $I = 0 To 8 Step 1
if $I = 7 Then
_GUICtrlComboBox_SelectString($TextureCombos[$I],"Very Low")
Else
_GUICtrlComboBox_SelectString($TextureCombos[$I],"Medium")
EndIf
Next
GUICtrlSetState($CheckboxApplyFPSSettings,1)
GUICtrlSetState($CheckboxApplyEngineSettings,1)
GUICtrlSetState($CheckboxApplyTextureSettings,1)
EndFunc
Func ApplySettings()
GUICtrlSetData($MainGUIApplySettings,"Working...")
GUISetState(@SW_DISABLE,$MainGUI)
if $IsSteamUser = 1 Then
if FileReadLine($SMITEEngineIniPath,1) <> "; SMITE Optimizer Fixed INT" Then
if IniRead($SMITEEngineIniPath,"Engine.Engine","bSmoothFrameRate","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"Engine.Engine","bSmoothFrameRate","TRUE")
EndIf
if IniRead($SMITEEngineIniPath,"Engine.Engine","MinSmoothedFrameRate","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"Engine.Engine","MinSmoothedFrameRate","150")
EndIf
if IniRead($SMITEEngineIniPath,"Engine.Engine","MaxSmoothedFrameRate","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"Engine.Engine","MaxSmoothedFrameRate","300")
EndIf
if IniRead($SMITEEngineIniPath,"Engine.Engine","MaxParticleVertexMemory","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"Engine.Engine","MaxParticleVertexMemory","131972")
EndIf
if IniRead($SMITEEngineIniPath,"UnrealEd.EditorEngine","bSmoothFrameRate","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"UnrealEd.EditorEngine","bSmoothFrameRate","TRUE")
EndIf
if IniRead($SMITEEngineIniPath,"UnrealEd.EditorEngine","MinSmoothedFrameRate","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"UnrealEd.EditorEngine","MinSmoothedFrameRate","150")
EndIf
if IniRead($SMITEEngineIniPath,"UnrealEd.EditorEngine","MaxSmoothedFrameRate","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"UnrealEd.EditorEngine","MaxSmoothedFrameRate","300")
EndIf
if IniRead($SMITEEngineIniPath,"TextureStreaming","MaximumPoolSize","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"TextureStreaming","MaximumPoolSize","0")
EndIf
if IniRead($SMITEEngineIniPath,"TextureStreaming","MinimumPoolSize","ERROR") = "ERROR" Then
IniWrite($SMITEEngineIniPath,"TextureStreaming","MinimumPoolSize","225")
EndIf
_FileWriteToLine($SMITEEngineIniPath,1,"; SMITE Optimizer Fixed INT")
EndIf
if FileReadLine($SMITEBattleSystemSettingsIniPath,1) <> "; SMITE Optimizer Fixed INT" Then
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings","DynamicLights","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettings","DynamicLights","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings","CompositeDynamicLights","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettings","CompositeDynamicLights","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings","AllowSubsurfaceScattering","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettings","AllowSubsurfaceScattering","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings","AllowImageReflections","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettings","AllowImageReflections","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings","ParticleLODBias","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettings","ParticleLODBias","10")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings","ShadowFilterQualityBias","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettings","ShadowFilterQualityBias","-1")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsScreenshot","CompositeDynamicLights","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsScreenshot","CompositeDynamicLights","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsScreenshot","ShadowFilterQualityBias","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsScreenshot","ShadowFilterQualityBias","-1")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsScreenshot","MaxShadowResolution","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsScreenshot","MaxShadowResolution","256")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsScreenshot","ShadowTexelsPerPixel","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsScreenshot","ShadowTexelsPerPixel","0")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","StaticDecals","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","StaticDecals","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","DynamicDecals","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","DynamicDecals","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","DynamicLights","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","DynamicLights","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","DepthOfField","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","DepthOfField","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","Bloom","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","Bloom","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","Distortion","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","Distortion","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","DropParticleDistortion","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","DropParticleDistortion","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","AllowRadialBlur","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsMobile","AllowRadialBlur","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsFlash","DepthOfField","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsFlash","DepthOfField","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsFlash","Bloom","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsFlash","Bloom","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsFlash","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsFlash","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsFlash","Distortion","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsFlash","Distortion","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsSplitScreen2","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsSplitScreen2","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsSplitScreen2","DetailMode","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsSplitScreen2","DetailMode","2")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsSplitScreen2","bAllowWholeSceneDominantShadows","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsSplitScreen2","bAllowWholeSceneDominantShadows","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone3GS","LensFlares","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone3GS","LensFlares","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone3GS","DetailMode","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone3GS","DetailMode","2")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone4","LensFlares","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone4","LensFlares","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone4S","DynamicShadows","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone4S","DynamicShadows","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone4S","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone4S","bAllowLightShafts","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone4S","MaxShadowResolution","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone4S","MaxShadowResolution","256")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone5","DynamicShadows","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone5","DynamicShadows","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone5","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone5","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone5","AllowRadialBlur","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone5","AllowRadialBlur","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone5","MaxShadowResolution","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPhone5","MaxShadowResolution","256")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPodTouch4","LensFlares","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPodTouch4","LensFlares","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPodTouch5","DynamicShadows","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPodTouch5","DynamicShadows","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPodTouch5","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPodTouch5","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPodTouch5","MaxShadowResolution","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPodTouch5","MaxShadowResolution","256")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad2","DynamicShadows","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad2","DynamicShadows","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad2","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad2","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad2","MaxShadowResolution","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad2","MaxShadowResolution","256")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad3","DynamicShadows","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad3","DynamicShadows","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad3","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad3","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad3","MaxShadowResolution","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad3","MaxShadowResolution","256")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad4","DynamicShadows","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad4","DynamicShadows","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad4","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad4","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad4","AllowRadialBlur","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad4","AllowRadialBlur","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad4","MaxShadowResolution","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPad4","MaxShadowResolution","256")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPadMini","DynamicShadows","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPadMini","DynamicShadows","FALSE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPadMini","bAllowLightShafts","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPadMini","bAllowLightShafts","TRUE")
EndIf
if IniRead($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPadMini","MaxShadowResolution","ERROR") = "ERROR" Then
IniWrite($SMITEBattleSystemSettingsIniPath,"SystemSettingsIPadMini","MaxShadowResolution","256")
EndIf
_FileWriteToLine($SMITEBattleSystemSettingsIniPath,1,"; SMITE Optimizer Fixed INT")
EndIf
EndIf
Local $SMITEEngineIniPathArray, $SMITEBattleSystemSettingsIniPathArray
_FileReadToArray($SMITEEngineIniPath,$SMITEEngineIniPathArray)
_FileReadToArray($SMITEBattleSystemSettingsIniPath,$SMITEBattleSystemSettingsIniPathArray)
For $Steps = 0 To 4 Step 1
if GUICtrlRead($CheckboxApplyFPSSettings) = 1 Then
if $Steps = 0 Then
For $Bla = 0 To UBound($SMITEEngineIniPathArray)-1 Step 1
For $I = 0 To UBound($FPSVarsArray)-1 Step 1
if StringRegExp($SMITEEngineIniPathArray[$Bla],"\A"&$FPSVarsArray[$I]&"[=]") <> 0 Then
if $I < 1 Then
$SMITEEngineIniPathArray[$Bla] = $FPSVarsArray[$I]&"="&GUICtrlRead($VarsButtonArray[$I])
Else
$SMITEEngineIniPathArray[$Bla] = $FPSVarsArray[$I]&"="&GUICtrlRead($VarsInputArray[$I-1])
EndIf
EndIf
Next
Next
EndIf
EndIf
if GUICtrlRead($CheckboxApplyEngineSettings) = 1 Then
if $Steps = 1 Then
For $Bla = 0 To UBound($SMITEEngineIniPathArray)-1 Step 1
For $I = 0 To UBound($EngineVarsArray)-1 Step 1
if StringRegExp($SMITEEngineIniPathArray[$Bla],"\A"&$EngineVarsArray[$I]&"[=]") <> 0 Then
$SMITEEngineIniPathArray[$Bla] = $EngineVarsArray[$I]&"="&GUICtrlRead($VarsInputArray[$I+2])
EndIf
Next
Next
EndIf
EndIf
if $Steps = 2 Then
For $Bla = 0 To UBound($SMITEBattleSystemSettingsIniPathArray)-1 Step 1
For $I = 0 To UBound($WorldVarsArray)-1 Step 1
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$Bla],"\A"&$WorldVarsArray[$I]&"[=]") <> 0 Then
if $I = 2 or $I = 18 or $I = 19 or $I = 20 or $I = 21 or $I = 22 or $I = 23 or $I = 24 or $I = 28 or $I = 29 or $I = 35 Then
$SMITEBattleSystemSettingsIniPathArray[$Bla] = $WorldVarsArray[$I]&"="&GUICtrlRead($VarsInputArray[$I+7])
Else
$SMITEBattleSystemSettingsIniPathArray[$Bla] = $WorldVarsArray[$I]&"="&GUICtrlRead($VarsButtonArray[$I+1])
EndIf
EndIf
Next
Next
EndIf
if GUICtrlRead($VarsButtonArrayTemp[25]) = "TRUE" Then
For $I = 0 To UBound($SMITEBattleSystemSettingsIniPathArray)-1 Step 1
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$I],"\A"&"bAllowFog"&"[=]") <> 0 Then
$SMITEBattleSystemSettingsIniPathArray[$I] = "bAllowFog=TRUE"
EndIf
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$I],"\A"&"FogVolumes"&"[=]") <> 0 Then
$SMITEBattleSystemSettingsIniPathArray[$I] = "FogVolumes=TRUE"
EndIf
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$I],"\A"&"FogAccumulationDownsampleFactor"&"[=]") <> 0 Then
$SMITEBattleSystemSettingsIniPathArray[$I] = "FogAccumulationDownsampleFactor=2"
EndIf
Next
ElseIf GUICtrlRead($VarsButtonArrayTemp[25]) = "FALSE" Then
For $I = 0 To UBound($SMITEBattleSystemSettingsIniPathArray)-1 Step 1
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$I],"\A"&"bAllowFog"&"[=]") <> 0 Then
$SMITEBattleSystemSettingsIniPathArray[$I] = "bAllowFog=FALSE"
EndIf
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$I],"\A"&"FogVolumes"&"[=]") <> 0 Then
$SMITEBattleSystemSettingsIniPathArray[$I] = "FogVolumes=FALSE"
EndIf
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$I],"\A"&"FogAccumulationDownsampleFactor"&"[=]") <> 0 Then
$SMITEBattleSystemSettingsIniPathArray[$I] = "FogAccumulationDownsampleFactor=0"
EndIf
Next
EndIf
if GUICtrlRead($CheckboxApplyClientSettings) = 1 Then
if $Steps = 3 Then
For $Bla = 0 To UBound($SMITEBattleSystemSettingsIniPathArray)-1 Step 1
For $I = 0 To UBound($ClientVarsArray)-1 Step 1
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$Bla],"\A"&$ClientVarsArray[$I]&"[=]") <> 0 Then
if GUICtrlRead($CheckboxUseDirectX11) = 1 Then
$SMITEBattleSystemSettingsIniPathArray[$Bla] = $ClientVarsArray[$I]&"="&"True"
Else
$SMITEBattleSystemSettingsIniPathArray[$Bla] = $ClientVarsArray[$I]&"="&"False"
EndIf
EndIf
Next
Next
EndIf
EndIf
if GUICtrlRead($CheckboxApplyTextureSettings) = 1 Then
If $Steps = 4 Then
For $Indexer = 0 To 8 Step 1
Local $QualityLevel = -1
if GUICtrlRead($TextureCombos[$Indexer]) = "Best" then
$QualityLevel = 0
ElseIf GUICtrlRead($TextureCombos[$Indexer]) = "Very High" then
$QualityLevel = 1
ElseIf GUICtrlRead($TextureCombos[$Indexer]) = "High" then
$QualityLevel = 2
ElseIf GUICtrlRead($TextureCombos[$Indexer]) = "Medium" then
$QualityLevel = 3
ElseIf GUICtrlRead($TextureCombos[$Indexer]) = "Low" then
$QualityLevel = 4
ElseIf GUICtrlRead($TextureCombos[$Indexer]) = "Very Low" then
$QualityLevel = 5
ElseIf GUICtrlRead($TextureCombos[$Indexer]) = "Absolute Worst" then
$QualityLevel = 6
ElseIf GUICtrlRead($TextureCombos[$Indexer]) = "Potato" then
$QualityLevel = 7
ElseIf GUICtrlRead($TextureCombos[$Indexer]) = "N64 Graphics, but 64 times worse" then
$QualityLevel = 8
Else
ContinueLoop
EndIf
If $QualityLevel = -1 Then
ContinueLoop
Else
For $Bla = 0 To UBound($SMITEBattleSystemSettingsIniPathArray)-1 Step 1
For $Settings = 0 To 3 Step 1
Local $FindStr = $TextureQualityHive[$Indexer][$QualityLevel][$Settings]
if $FindStr == "" then
ContinueLoop
EndIf
if StringRight($SMITEBattleSystemSettingsIniPathArray[$Bla],15) <> StringRight($FindStr,15) then
ContinueLoop
EndIf
local $TrimmedSearch = ""
For $AZBIDK = StringLen($FindStr) To 1 Step -1
if StringMid($FindStr,$AZBIDK,1) = "=" then
$TrimmedSearch = StringTrimRight($FindStr,(StringLen($FindStr)-$AZBIDK))
ContinueLoop
EndIf
Next
if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$Bla],"\A"&$TrimmedSearch) <> 0 Then
$SMITEBattleSystemSettingsIniPathArray[$Bla] = $FindStr
EndIf
Next
Next
EndIf
Next
EndIf
EndIf
Next
If FileExists($ConfigBackupPath) = 0 Then
DirCreate($ConfigBackupPath)
EndIf
if $IsSteamUser = 1 Then
FileMove($SMITEEngineIniPath,$ConfigBackupPath&"\DefaultEngine "&@MON&"."&@MDAY&"."&@YEAR&" - "&@HOUR&"."&@MIN&".ini")
FileMove($SMITEBattleSystemSettingsIniPath,$ConfigBackupPath&"\DefaultSystemSettings "&@MON&"."&@MDAY&"."&@YEAR&" - "&@HOUR&"."&@MIN&".ini")
Else
FileMove($SMITEEngineIniPath,$ConfigBackupPath&"\BattleEngine "&@MON&"."&@MDAY&"."&@YEAR&" - "&@HOUR&"."&@MIN&".ini")
FileMove($SMITEBattleSystemSettingsIniPath,$ConfigBackupPath&"\BattleSystemSettings "&@MON&"."&@MDAY&"."&@YEAR&" - "&@HOUR&"."&@MIN&".ini")
EndIf
_FileWriteFromArray($SMITEEngineIniPath,$SMITEEngineIniPathArray,1)
_FileWriteFromArray($SMITEBattleSystemSettingsIniPath,$SMITEBattleSystemSettingsIniPathArray,1)
if fileExists($SMITEEngineIniPath) = 1 and fileExists($SMITEBattleSystemSettingsIniPath) = 1 Then
MsgBox(0,"Success!","Applied changes successfully.")
Else
MsgBox(0,"Uh oh","Something went wrong.")
EndIf
GUICtrlSetData($MainGUIApplySettings,"Apply settings")
GUISetState(@SW_ENABLE,$MainGUI)
WinActivate($MainGUI)
RedrawButtonsAndInputs()
EndFunc
Func GUIDisplay($Var)
Local $TempVar
If $Var = 1 Then
Global $EditBoxGUI = GUICreate("Changelog",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetData(-1, _Resource_GetAsString("ChangelogText"))
GUISetState()
EndIf
If $Var = 2 Then
Global $EditBoxGUI = GUICreate("Copyright and Credits",600,420,-1,-1,-1,$WS_EX_TOOLWINDOW)
Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetData(-1, _Resource_GetAsString("CopyrightCreditsText"))
GUISetState()
EndIf
If $Var = 3 Then
Global $RestoreGUIAlive = true
Global $EditBoxGUI = GUICreate("Restore old configs",800,420,0,-69,-1,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$MainGUI)
Global $EditBoxGUIList = GUICtrlCreateList("",5,5,790,380)
$TempVar = _FileListToArray($ConfigBackupPath,"*",1)
For $I = 0 To UBound($TempVar)-1 Step 1
_GUICtrlListBox_AddString($EditBoxGUIList, $TempVar[$I])
Next
Global $EditBoxGUIButtonDeleteBackups = GUICtrlCreateButton("Delete all backups",5,375,125,20)
Global $EditBoxGUIButtonRestore = GUICtrlCreateButton("Restore",670,380,125,35)
if $IsSteamUser = 1 Then
Global $EditBoxGUILabelHowTo = GUICtrlCreateLabel("Choose a date and time and restore DefaultEngine and DefaultSystemSettings.",5,400,450,35)
GUICtrlSetBkColor(-1,-2)
Else
Global $EditBoxGUILabelHowTo = GUICtrlCreateLabel("Choose a date and time and restore BattleEngine and BattleSystemSettings.",5,400,450,35)
GUICtrlSetBkColor(-1,-2)
EndIf
GUICtrlSetBkColor(-1,-2)
GUISetState()
EndIf
If $Var = 4 Then
Global $EditBoxGUI = GUICreate("",400,70,-3+200,-65+150,-1,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$MainGUI)
Global $EditBoxGUIHelpLabel = GUICtrlCreateLabel("Available help:",5,5,395,25)
GUICtrlSetBkColor(-1,-2)
GUICtrlSetFont(-1,15)
Global $EditBoxGUIButtonHelp1 = GUICtrlCreateButton("Program Functions",5,30,125,35)
Global $EditBoxGUIButtonHelp2 = GUICtrlCreateButton("Restoring Configurations",137,30,125,35)
Global $EditBoxGUIButtonHelp3 = GUICtrlCreateButton("Variable Explanation",270,30,125,35)
GUICtrlSetBkColor(-1,-2)
GUISetState()
EndIf
If $Var = 5 Then
Global $EditBoxGUI = GUICreate("Help - Program Functions",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetData(-1, _Resource_GetAsString("ProgramFunctionsHelp"))
GUISetState()
EndIf
If $Var = 6 Then
Global $EditBoxGUI = GUICreate("Help - Restoring Configuration",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetData(-1, _Resource_GetAsString("RestoringConfigurationHelp"))
GUISetState()
EndIf
If $Var = 7 Then
Global $EditBoxGUI = GUICreate("Help - Variable Explanation",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetData(-1, _Resource_GetAsString("VariableExplanationHelp"))
GUISetState()
EndIf
GUICtrlCreateButton("",-5000,-5000,1,1)
GUICtrlSetState(-1,256)
WinActivate($EditBoxGUI)
EndFunc
Func CloseGUIDisplay()
GUIDelete($EditBoxGUI)
$EditBoxGUI = 0
If isDeclared("EditBoxGUIButtonRestore") = 1 or isDeclared("EditBoxGUIButtonHelp1") = 1 Then
$EditBoxGUIButtonDeleteBackups = 2
$EditBoxGUIButtonRestore = 2
$EditBoxGUIButtonHelp1 = 2
$EditBoxGUIButtonHelp2 = 2
$EditBoxGUIButtonHelp3 = 2
EndIf
GUISetState(@SW_ENABLE,$MainGUI)
WinActivate($MainGUI)
if $RestoreGUIAlive = true Then
RedrawButtonsAndInputs()
$RestoreGUIAlive = false
EndIf
EndFunc
While 1
if $EditBoxGUI = 0 and $MainGUIDrawn = true Then
Switch GUIGetMsg()
Case -3, $MenuExit
if isDeclared("DebugGUI") Then
if $DebugGUI = -5 Then
Exit
Else
GUIDelete($DebugGUI)
$DebugGUI = -5
$DebugGUIButtonResetConfig = 2
GUISetState(@SW_ENABLE,$MainGUI)
WinActivate($MainGUI)
EndIf
Else
Exit
EndIf
Case $MenuRedditLink
ShellExecute("https://www.reddit.com/r/SMITEOptimizer/new")
Case $MenuDonateItem
ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=2NKTRNN5BTHHG")
Case $MenuChangelog
GUISetState(@SW_DISABLE,$MainGUI)
GUIDisplay(1)
Case $MenuCopyrightCredits
GUISetState(@SW_DISABLE,$MainGUI)
GUIDisplay(2)
Case $MenuSettingsRestoreConfig
GUISetState(@SW_DISABLE,$MainGUI)
GUIDisplay(3)
Case $MainGUICheckboxUseRecommendedSettings
if GUICtrlRead($MainGUICheckboxUseRecommendedSettings) = 1 Then
UseRecommendedSettings()
ElseIf GUICtrlRead($MainGUICheckboxUseRecommendedSettings) = 4 Then
RedrawButtonsAndInputs()
EndIf
Case $MainGUIApplySettings
ApplySettings()
RedrawButtonsAndInputs()
Case $MenuSettingsUpdateCheckOnOff
if RegRead("HKCU\Software\SMITE Optimizer\","UpdateCheck") = "TRUE" Then
RegWrite("HKCU\Software\SMITE Optimizer\","UpdateCheck","REG_SZ","FALSE")
MsgBox(0,"Information","Automatic update check turned off.")
Else
RegWrite("HKCU\Software\SMITE Optimizer\","UpdateCheck","REG_SZ","TRUE")
MsgBox(0,"Information","Automatic update check turned on.")
EndIf
Case $MenuHelpItem
GUISetState(@SW_DISABLE,$MainGUI)
GUIDisplay(4)
Case $MenuDebugItem
if IsDeclared("DebugGUI") = 0 or $DebugGUI = -5 Then
DrawDebugGUI()
Elseif IsDeclared("DebugGUI") = 1 Then
GUIDelete($DebugGUI)
$DebugGUI = -5
$DebugGUIButtonResetConfig = 2
EndIf
Case $DebugGUIButtonResetConfig
Local $MsgBoxConfigReset = MsgBox(4,"Information","Are you sure you want to reset the config paths?")
if $MsgBoxConfigReset = 6 Then
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathEngine")
RegDelete("HKCU\Software\SMITE Optimizer\","ConfigPathSystem")
ShellExecute(@ScriptFullPath)
Exit
EndIf
Case $VarsButtonArrayTemp[0]
if GUICtrlRead($VarsButtonArrayTemp[0]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[0],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[0],"TRUE")
EndIf
Case $VarsButtonArrayTemp[1]
if GUICtrlRead($VarsButtonArrayTemp[1]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[1],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[1],"TRUE")
EndIf
Case $VarsButtonArrayTemp[2]
if GUICtrlRead($VarsButtonArrayTemp[2]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[2],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[2],"TRUE")
EndIf
Case $VarsButtonArrayTemp[3]
if GUICtrlRead($VarsButtonArrayTemp[3]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[3],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[3],"TRUE")
EndIf
Case $VarsButtonArrayTemp[4]
if GUICtrlRead($VarsButtonArrayTemp[4]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[4],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[4],"TRUE")
EndIf
Case $VarsButtonArrayTemp[5]
if GUICtrlRead($VarsButtonArrayTemp[5]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[5],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[5],"TRUE")
EndIf
Case $VarsButtonArrayTemp[6]
if GUICtrlRead($VarsButtonArrayTemp[6]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[6],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[6],"TRUE")
EndIf
Case $VarsButtonArrayTemp[7]
if GUICtrlRead($VarsButtonArrayTemp[7]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[7],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[7],"TRUE")
EndIf
Case $VarsButtonArrayTemp[8]
if GUICtrlRead($VarsButtonArrayTemp[8]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[8],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[8],"TRUE")
EndIf
Case $VarsButtonArrayTemp[9]
if GUICtrlRead($VarsButtonArrayTemp[9]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[9],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[9],"TRUE")
EndIf
Case $VarsButtonArrayTemp[10]
if GUICtrlRead($VarsButtonArrayTemp[10]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[10],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[10],"TRUE")
EndIf
Case $VarsButtonArrayTemp[11]
if GUICtrlRead($VarsButtonArrayTemp[11]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[11],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[11],"TRUE")
EndIf
Case $VarsButtonArrayTemp[12]
if GUICtrlRead($VarsButtonArrayTemp[12]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[12],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[12],"TRUE")
EndIf
Case $VarsButtonArrayTemp[13]
if GUICtrlRead($VarsButtonArrayTemp[13]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[13],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[13],"TRUE")
EndIf
Case $VarsButtonArrayTemp[14]
if GUICtrlRead($VarsButtonArrayTemp[14]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[14],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[14],"TRUE")
EndIf
Case $VarsButtonArrayTemp[15]
if GUICtrlRead($VarsButtonArrayTemp[15]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[15],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[15],"TRUE")
EndIf
Case $VarsButtonArrayTemp[16]
if GUICtrlRead($VarsButtonArrayTemp[16]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[16],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[16],"TRUE")
EndIf
Case $VarsButtonArrayTemp[17]
if GUICtrlRead($VarsButtonArrayTemp[17]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[17],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[17],"TRUE")
EndIf
Case $VarsButtonArrayTemp[18]
if GUICtrlRead($VarsButtonArrayTemp[18]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[18],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[18],"TRUE")
EndIf
Case $VarsButtonArrayTemp[19]
if GUICtrlRead($VarsButtonArrayTemp[19]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[19],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[19],"TRUE")
EndIf
Case $VarsButtonArrayTemp[20]
if GUICtrlRead($VarsButtonArrayTemp[20]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[20],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[20],"TRUE")
EndIf
Case $VarsButtonArrayTemp[21]
if GUICtrlRead($VarsButtonArrayTemp[21]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[21],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[21],"TRUE")
EndIf
Case $VarsButtonArrayTemp[22]
if GUICtrlRead($VarsButtonArrayTemp[22]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[22],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[22],"TRUE")
EndIf
Case $VarsButtonArrayTemp[23]
if GUICtrlRead($VarsButtonArrayTemp[23]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[23],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[23],"TRUE")
EndIf
Case $VarsButtonArrayTemp[24]
if GUICtrlRead($VarsButtonArrayTemp[24]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[24],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[24],"TRUE")
EndIf
Case $VarsButtonArrayTemp[25]
if GUICtrlRead($VarsButtonArrayTemp[25]) = "TRUE" Then
GUICtrlSetData($VarsButtonArrayTemp[25],"FALSE")
Else
GUICtrlSetData($VarsButtonArrayTemp[25],"TRUE")
EndIf
EndSwitch
EndIf
if isDeclared("EditBoxGUI") <> 0 Then
if $EditBoxGUI <> 0 Then
Switch GuiGetMsg()
Case -3, $MenuExit
CloseGUIDisplay()
Case $EditBoxGUIButtonDeleteBackups
if MsgBox(4,"Confirm..","Are you sure you want to delete all of your config backups?") = 6 then
DirRemove($ConfigBackupPath,1)
DirCreate($ConfigBackupPath)
CloseGUIDisplay()
GUIDisplay(3)
EndIf
Case $EditBoxGUIButtonRestore
if $IsSteamUser = 1 Then
if _GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)) <> "" Then
if StringInStr(_GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)),"DefaultEngine") <> 0 Then
FileDelete($SMITEEngineIniPath)
FileCopy($ConfigBackupPath&_GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)),$SMITEEngineIniPath,1)
EndIf
if StringInStr(_GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)),"DefaultSystemSettings") <> 0 Then
FileDelete($SMITEBattleSystemSettingsIniPath)
FileCopy($ConfigBackupPath&_GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)),$SMITEBattleSystemSettingsIniPath,1)
EndIf
if @Error = 0 then
MsgBox(0,"Done","Restored successfully.")
Else
MsgBox(0,"Error","Looks like there was a problem.")
EndIf
EndIf
Else
if _GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)) <> "" Then
if StringInStr(_GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)),"BattleEngine") <> 0 Then
FileDelete($SMITEEngineIniPath)
FileCopy($ConfigBackupPath&_GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)),$SMITEEngineIniPath,1)
EndIf
if StringInStr(_GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)),"BattleSystemSettings") <> 0 Then
FileDelete($SMITEBattleSystemSettingsIniPath)
FileCopy($ConfigBackupPath&_GUICtrlListBox_GetText($EditBoxGUIList,_GUICtrlListBox_GetCurSel($EditBoxGUIList)),$SMITEBattleSystemSettingsIniPath,1)
EndIf
if @Error = 0 then
MsgBox(0,"Done","Restored successfully.")
Else
MsgBox(0,"Error","Looks like there was a problem.")
EndIf
EndIf
EndIf
Case $EditBoxGUIButtonHelp1
GUIDelete($EditBoxGUI)
GUIDisplay(5)
Case $EditBoxGUIButtonHelp2
GUIDelete($EditBoxGUI)
GUIDisplay(6)
Case $EditBoxGUIButtonHelp3
GUIDelete($EditBoxGUI)
GUIDisplay(7)
EndSwitch
EndIf
EndIf
WEnd
