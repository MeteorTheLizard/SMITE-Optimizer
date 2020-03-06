#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=SMITEOptimizerIcon.ico
#AutoIt3Wrapper_Outfile=SMITE Optimizer 32Bit.exe
#AutoIt3Wrapper_Outfile_x64=SMITE Optimizer 64Bit.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Description=SMITE Optimizer
#AutoIt3Wrapper_Res_Fileversion=1.2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Made by MrRangerLP - All Rights Reserved.
#AutoIt3Wrapper_Res_File_Add=Changelog.txt, RT_RCDATA, ChangelogText, 0
#AutoIt3Wrapper_Res_File_Add=CopyrightCredits.txt, RT_RCDATA, CopyrightCreditsText, 0
#AutoIt3Wrapper_Res_File_Add=ProgramFunctions.txt, RT_RCDATA, ProgramFunctionsHelp, 0
#AutoIt3Wrapper_Res_File_Add=RestoringConfiguration.txt, RT_RCDATA, RestoringConfigurationHelp, 0
#AutoIt3Wrapper_Res_File_Add=VariableExplanation.txt, RT_RCDATA, VariableExplanationHelp, 0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;-- INCLUDES
;----------------------------------------------------------------------------

;- Array.au3
   Func _ArrayDelete(ByRef $aArray, $vRange)
	  If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	  Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	  If IsArray($vRange) Then
		If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
	  Else
		; Expand range
		Local $iNumber, $aSplit_1, $aSplit_2
		$vRange = StringStripWS($vRange, 8)
		$aSplit_1 = StringSplit($vRange, ";")
		$vRange = ""
		For $i = 1 To $aSplit_1[0]
			; Check for correct range syntax
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
	  ; Remove rows
	  Local $iCopyTo_Index = 0
	  Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			; Loop through array flagging elements to be deleted
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]] = ChrW(0xFAB1)
			Next
			; Now copy rows to keep to fill deleted rows
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
			; Loop through array flagging elements to be deleted
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]][0] = ChrW(0xFAB1)
			Next
			; Now copy rows to keep to fill deleted rows
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

;- File.au3
   Func _FileReadToArray($sFilePath, ByRef $vReturn, $iFlags = $FRTA_COUNT, $sDelimiter = "")
	  ; Clear the previous contents
	  $vReturn = 0

	  If $iFlags = Default Then $iFlags = $FRTA_COUNT
	  If $sDelimiter = Default Then $sDelimiter = ""

	  ; Set "array of arrays" flag
	  Local $bExpand = True
	  If BitAND($iFlags, $FRTA_INTARRAYS) Then
		$bExpand = False
		$iFlags -= $FRTA_INTARRAYS
	  EndIf
	  ; Set delimiter flag
	  Local $iEntire = $STR_CHRSPLIT
	  If BitAND($iFlags, $FRTA_ENTIRESPLIT) Then
		$iEntire = $STR_ENTIRESPLIT
		$iFlags -= $FRTA_ENTIRESPLIT
	  EndIf
	  ; Set row count and split count flags
	  Local $iNoCount = 0
	  If $iFlags <> $FRTA_COUNT Then
		$iFlags = $FRTA_NOCOUNT
		$iNoCount = $STR_NOCOUNT
	  EndIf

	  ; Check delimiter
	  If $sDelimiter Then
		; Read file into an array
		Local $aLines = FileReadToArray($sFilePath)
		If @error Then Return SetError(@error, 0, 0)

		; Get first dimension and add count if required
		Local $iDim_1 = UBound($aLines) + $iFlags
		; Check type of return array
		If $bExpand Then ; All lines have same number of fields
			; Count fields in first line
			Local $iDim_2 = UBound(StringSplit($aLines[0], $sDelimiter, $iEntire + $STR_NOCOUNT))
			; Size array
			Local $aTemp_Array[$iDim_1][$iDim_2]
			; Declare the variables
			Local $iFields, _
					$aSplit
			; Loop through the lines
			For $i = 0 To $iDim_1 - $iFlags - 1
				; Split each line as required
				$aSplit = StringSplit($aLines[$i], $sDelimiter, $iEntire + $STR_NOCOUNT)
				; Count the items
				$iFields = UBound($aSplit)
				If $iFields <> $iDim_2 Then
					; Return error
					Return SetError(3, 0, 0)
				EndIf
				; Fill this line of the array
				For $j = 0 To $iFields - 1
					$aTemp_Array[$i + $iFlags][$j] = $aSplit[$j]
				Next
			Next
			; Check at least 2 columns
			If $iDim_2 < 2 Then Return SetError(4, 0, 0)
			; Set dimension count
			If $iFlags Then
				$aTemp_Array[0][0] = $iDim_1 - $iFlags
				$aTemp_Array[0][1] = $iDim_2
			EndIf
		Else ; Create "array of arrays"
			; Size array
			Local $aTemp_Array[$iDim_1]
			; Loop through the lines
			For $i = 0 To $iDim_1 - $iFlags - 1
				; Split each line as required
				$aTemp_Array[$i + $iFlags] = StringSplit($aLines[$i], $sDelimiter, $iEntire + $iNoCount)
			Next
			; Set dimension count
			If $iFlags Then
				$aTemp_Array[0] = $iDim_1 - $iFlags
			EndIf
		EndIf
		; Return the array
		$vReturn = $aTemp_Array
	  Else ; 1D
		If $iFlags Then
			Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
			If $hFileOpen = -1 Then Return SetError(1, 0, 0)
			Local $sFileRead = FileRead($hFileOpen)
			FileClose($hFileOpen)

			If StringLen($sFileRead) Then
				$vReturn = StringRegExp(@LF & $sFileRead, "(?|(\N+)\z|(\N*)(?:\R))", 3)
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
	  ; Check if we have a valid array as an input.
	  If Not IsArray($aArray) Then Return SetError(2, 0, $iReturn)

	  ; Check the number of dimensions is no greater than a 2d array.
	  Local $iDims = UBound($aArray, $UBOUND_DIMENSIONS)
	  If $iDims > 2 Then Return SetError(4, 0, 0)

	  ; Determine last entry of the array.
	  Local $iLast = UBound($aArray) - 1
	  If $iUBound = Default Or $iUBound > $iLast Then $iUBound = $iLast
	  If $iBase < 0 Or $iBase = Default Then $iBase = 0
	  If $iBase > $iUBound Then Return SetError(5, 0, $iReturn)
	  If $sDelimiter = Default Then $sDelimiter = "|"

	  ; Open output file for overwrite by default, or use input file handle if passed.
	  Local $hFileOpen = $sFilePath
	  If IsString($sFilePath) Then
		$hFileOpen = FileOpen($sFilePath, $FO_OVERWRITE)
		If $hFileOpen = -1 Then Return SetError(1, 0, $iReturn)
	  EndIf

	  ; Write array data to file.
	  Local $iError = 0
	  $iReturn = 1 ; Set the return value to true.
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

	  ; Close file only if specified by a string path.
	  If IsString($sFilePath) Then FileClose($hFileOpen)

	  ; Return the results.
	  Return SetError($iError, 0, $iReturn)
   EndFunc
   Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = $FLTA_FILESFOLDERS, $bReturnPath = False)
	  Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""

	  ; Check parameters for the Default keyword or they meet a certain criteria
	  $sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\" ; Ensure a single trailing backslash
	  If $iFlag = Default Then $iFlag = $FLTA_FILESFOLDERS
	  If $bReturnPath Then $sFullPath = $sFilePath
	  If $sFilter = Default Then $sFilter = "*"

	  ; Check if the directory exists
	  If Not FileExists($sFilePath) Then Return SetError(1, 0, 0)
	  If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
	  If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)
	  Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
	  If @error Then Return SetError(4, 0, 0)
	  While 1
		$sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If ($iFlag + @extended = 2) Then ContinueLoop
		$sFileList &= $sDelimiter & $sFullPath & $sFileName
	  WEnd
	  FileClose($hSearch)
	  If $sFileList = "" Then Return SetError(4, 0, 0)
	  Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter,2)
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

	   Local $iHide_HS = 0, _
			   $sHide_HS = ""
	   If BitAND($iReturn, 4) Then
		   $iHide_HS += 2
		   $sHide_HS &= "H"
		   $iReturn -= 4
	   EndIf
	   If BitAND($iReturn, 8) Then
		   $iHide_HS += 4
		   $sHide_HS &= "S"
		   $iReturn -= 8
	   EndIf

	   Local $iHide_Link = 0
	   If BitAND($iReturn, 16) Then
		   $iHide_Link = 0x400
		   $iReturn -= 16
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

	   If Not ($iReturn = 0 Or $iReturn = 1 Or $iReturn = 2) Then Return SetError(1, 5, "")
	   If Not ($iSort = 0 Or $iSort = 1 Or $iSort = 2) Then Return SetError(1, 7, "")
	   If Not ($iReturnPath = 0 Or $iReturnPath = 1 Or $iReturnPath = 2) Then Return SetError(1, 8, "")

	   If $iHide_Link Then
		   Local $tFile_Data = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & _
				   "dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
		   Local $hDLL = DllOpen('kernel32.dll'), $aDLL_Ret
	   EndIf

	   Local $asReturnList[100] = [0]
	   Local $asFileMatchList = $asReturnList, $asRootFileMatchList = $asReturnList, $asFolderMatchList = $asReturnList
	   Local $bFolder = False, _
			   $hSearch = 0, _
			   $sCurrentPath = "", $sName = "", $sRetPath = ""
	   Local $iAttribs = 0, _
			   $sAttribs = ''
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
						   If Not StringRegExp($sName, $sExclude_Folder_Mask) Then ; Add folder unless excluded
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
	   $sList = StringReplace(StringStripWS(StringRegExpReplace($sList, "\s*;\s*", ";"), $STR_STRIPLEADING + $STR_STRIPTRAILING), ";", "|")
	   $sList = StringReplace(StringReplace(StringRegExpReplace($sList, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
	   $sMask = "(?i)^(" & $sList & ")\z"
	   Return 1
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
	   If (($aArray[$iE1] <> $aArray[$iE2]) And ($aArray[$iE2] <> $aArray[$iE3]) And ($aArray[$iE3] <> $aArray[$iE4]) And ($aArray[$iE4] <> $aArray[$iE5])) Then
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
		   If ($iLess < $iE1) And ($iE5 < $iGreater) Then
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
   Func _FileWriteToLine($sFilePath, $iLine, $sText, $bOverWrite = False)
	   If $iLine <= 0 Then Return SetError(4, 0, 0)
	   If Not IsString($sText) Then
		   $sText = String($sText)
		   If $sText = "" Then Return SetError(6, 0, 0)
	   EndIf
	   If $bOverWrite = Default Then $bOverWrite = False
	   If Not (IsBool($bOverWrite) Or $bOverWrite = 0 Or $bOverWrite = 1) Then Return SetError(5, 0, 0) ; For old versions.
	   If Not FileExists($sFilePath) Then Return SetError(2, 0, 0)

	   Local $aArray = FileReadToArray($sFilePath)
	   Local $iUBound = UBound($aArray) - 1
	   If ($iUBound + 1) < $iLine Then Return SetError(1, 0, 0)

	   Local $hFileOpen = FileOpen($sFilePath, FileGetEncoding($sFilePath) + $FO_OVERWRITE)
	   If $hFileOpen = -1 Then Return SetError(3, 0, 0)

	   Local $sData = ""
	   $iLine -= 1
	   For $i = 0 To $iUBound
		   If $i = $iLine Then
			   If $bOverWrite Then
				   If $sText Then $sData &= $sText & @CRLF
			   Else
				   $sData &= $sText & @CRLF & $aArray[$i] & @CRLF
			   EndIf
		   ElseIf $i < $iUBound Then
			   $sData &= $aArray[$i] & @CRLF
		   ElseIf $i = $iUBound Then
			   $sData &= $aArray[$i]
		   EndIf
	   Next

	   FileWrite($hFileOpen, $sData)
	   FileClose($hFileOpen)
	   Return 1
   EndFunc

;- GuiListBox.au3
   Func _GUICtrlListBox_GetText($hWnd, $iIndex)
	  Local $tText = DllStructCreate("wchar Text[" & _GUICtrlListBox_GetTextLen($hWnd, $iIndex) + 1 & "]")
	  If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	  _SendMessage($hWnd, 0x0189, $iIndex, $tText, 0, "wparam", "struct*")
	  Return DllStructGetData($tText, "Text")
   EndFunc
   Func _GUICtrlListBox_GetTextLen($hWnd, $iIndex)
	  If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, 0x018A, $iIndex)
	  Else
		Return GUICtrlSendMsg($hWnd, 0x018A, $iIndex, 0)
	  EndIf
   EndFunc
   Func _GUICtrlListBox_AddString($hWnd, $sText)
	  If Not IsString($sText) Then $sText = String($sText)

	  If IsHWnd($hWnd) Then
		 Return _SendMessage($hWnd, 0x0180, 0, $sText, 0, "wparam", "wstr")
	  Else
		 Return GUICtrlSendMsg($hWnd, 0x0180, 0, $sText)
	  EndIf
   EndFunc
   Func _GUICtrlListBox_GetCurSel($hWnd)
	  If IsHWnd($hWnd) Then
		 Return _SendMessage($hWnd, 0x0188)
	  Else
		 Return GUICtrlSendMsg($hWnd, 0x0188, 0, 0)
	  EndIf
   EndFunc

#include <ResourcesEx.au3>

;----------------------------------------------------------------------------

;-- VARIABLES
;----------------------------------------------------------------------------

Const $ProgramName = "SMITE Optimizer"
Const $ProgramVersion = "V1.2.0"
Const $ProgramVersionRE = "1.2.0" ;- Registry Value

   ;- UPDATER
   ;------------------------------------------------------------

	  ;- Updating process part 2, (This is run while in @TempDir)
	  ;------------------------------

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

	  ;------------------------------

	  ;-Write Config to Registry.
	  ;------------------------------

	  If RegRead("HKCU\Software\SMITE Optimizer\","ProgramPath") <> @ScriptFullPath Then
		 RegWrite("HKCU\Software\SMITE Optimizer\","ProgramPath","REG_SZ",@ScriptFullPath)
		 RegWrite("HKCU\Software\SMITE Optimizer\","UpdateCheck","REG_SZ","TRUE")
		 RegWrite("HKCU\Software\SMITE Optimizer\","PerformUpdate","REG_SZ","FALSE")
	  EndIf

	  If RegRead("HKCU\Software\SMITE Optimizer\","ProgramVersion") <> $ProgramVersionRE Then
		 RegWrite("HKCU\Software\SMITE Optimizer\","ProgramVersion","REG_SZ",$ProgramVersionRE)
	  EndIf

	  ;------------------------------

	  ;- Check for Updates
	  ;------------------------------

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
			If $UpdtMsgBox = 6 Then ;- Update process 1
			   FileCopy(@ScriptFullPath,@TempDir & "\SMITE OptimizerUpdt.exe")
			   RegWrite("HKCU\Software\SMITE Optimizer\","PerformUpdate","REG_SZ","TRUE")
			   Run(@TempDir & "\SMITE OptimizerUpdt.exe")
			   Exit
			Else
			   FileDelete(@TempDir & "\SMITE OptimizerVersion.ini")
			EndIf
		 EndIf

		 Run("RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess " & 8) ;- This is to prevent Internet Explorer / Edge to download the .ini file from cache. (Therefor the .ini file will always be up-to-date)
	  EndIf

	  ;------------------------------

   ;------------------------------------------------------------

Global Const $FPSVarsArray[4] = ["bSmoothFrameRate","MinSmoothedFrameRate","MaxSmoothedFrameRate"]
Global Const $EngineVarsArray[6] = ["MaxParticleResize","MaxParticleResizeWarn","MaxParticleVertexMemory","MinimumPoolSize","MaximumPoolSize"]
Global Const $WorldVarsArray[36] = ["StaticDecals","DynamicDecals","DecalCullDistanceScale","DynamicLights","DynamicShadows","LightEnvironmentShadows","CompositeDynamicLights","SHSecondaryLighting","DepthOfField","Bloom","bAllowLightShafts","Distortion","DropParticleDistortion","LensFlares","AllowRadialBlur","AllowSubsurfaceScattering","AllowImageReflections","bAllowHighQualityMaterials","SkeletalMeshLODBias","ParticleLODBias","DetailMode","MaxDrawDistanceScale","ShadowFilterQualityBias","MaxShadowResolution","MaxWholeSceneDominantShadowResolution","bAllowWholeSceneDominantShadows","bUseConservativeShadowBounds","bAllowRagdolling","PerfScalingBias","StaticMeshLODBias","bAllowDropShadows","AllowScreenDoorFade","AllowScreenDoorLODFading","SpeedTreeWind","ShadowTexelsPerPixel","Fog (Conquest and other)"]
Global Const $ClientVarsArray[3] = ["AllowD3D11","PreferD3D11","UseD3D11Beta"]
Global $EditBoxGUI, $EditBoxGUIButtonRestore = 2,$EditBoxGUIButtonDeleteBackups = 2, $EditBoxGUIButtonHelp1 = 2, $EditBoxGUIButtonHelp2 = 2, $EditBoxGUIButtonHelp3 = 2, $DebugGUIButtonResetConfig = 2, $MainGUIDrawn = false, $RestoreGUIAlive = false
Global Const $ConfigBackupPath = "C:\Users\"&@UserName&"\Documents\My Games\SMITE Config Backup\"

;- CONFIG INIT AND CHECK
;----------------------------------------------------------------------------

RegRead("HKCU\Software\SMITE Optimizer\","DonateInfoStatus")
if @Error <> 0 or RegRead("HKCU\Software\SMITE Optimizer\","DonateInfoStatus") = "" Then
   RegWrite("HKCU\Software\SMITE Optimizer\","DonateInfoStatus","REG_SZ","0")
   RegWrite("HKCU\Software\SMITE Optimizer\","BlockDonations","REG_SZ","false")
   Global $BlockDonations = "False"
Else
   Global $BlockDonations = RegRead("HKCU\Software\SMITE Optimizer\","BlockDonations")
EndIf

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
   For $I = 1 To UBound($PathPrefixTemp)-1 Step 1 ;Scan all drives for BattleConfigs
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

;- DRAW GUI FUNCTIONS
;----------------------------------------------------------------------------

Func DrawMainGUI()
   Global $MainGUIDrawn = true
   if $IsSteamUser = 1 Then
	  Global $MainGUI = GUICreate($ProgramName&" "&$ProgramVersion&" Steam mode",600,420,-1,-1)
   Else
	  Global $MainGUI = GUICreate($ProgramName&" "&$ProgramVersion,600,420,-1,-1)
   EndIf
   GUICtrlCreateLabel("IMPORTANT: This program does NOT interact with SMITE directly. It only edits the config which is NOT a bannable offense.",5,385,600,25)
	  GUICtrlSetBkColor(-1,-2)
   GUICtrlCreateGroup("",5,5,590,379)
   Global $MainGUIApplySettings = GUICtrlCreateButton("Apply settings",400,348,190,30)
   Global $MainGUICheckboxUseRecommendedSettings = GUiCtrlCreateCheckbox("Use recommended settings",403,329,150,17)

   Global $CheckboxApplyFPSSettings = GUICtrlCreateCheckbox("Apply FPS settings", 400,85,105,15)
   Global $CheckboxApplyEngineSettings = GUICtrlCreateCheckbox("Apply Engine Settings",400,230,135,15)
   Global $CheckboxApplyClientSettings = GUICtrlCreateCheckbox("Apply Client Settings",400,305,135,15)
   Global $CheckboxUseDirectX11 = GUICtrlCreateCheckbox("Use DirectX11",400,265,135,15)


   ;- MENU
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
		 Global $MenuBlockDonationInfo = GUICtrlCreateMenuItem("Block Donation Info",$MenuDonate)

	  Global $MenuHelp = GUICtrlCreateMenu("Help")
		 Global $MenuHelpItem = GUICtrlCreateMenuItem("Help",$MenuHelp)
		 Global $MenuDebugItem = GUICtrlCreateMenuItem("Debug",$MenuHelp)

   ;- SETTINGS GROUPS
	  GUICtrlCreateGroup("FPS Settings",395,5,200,100)
	  GUICtrlCreateGroup("Engine Settings",395,110,200,140)
      GUICtrlCreateGroup("World Settings",5,5,391,379)
      GUICtrlCreateGroup("Client Settings",395,250,200,75)
		 GUICtrlCreateGroup("",391/2,5,3,379)
	  For $I = 0 To 16 Step 1
		 GUICtrlCreateGroup("",5,32+(20*$I),390,5)
	  Next

   GUISetState()
EndFunc

Func DrawLabels()
   ;- FPS
	  For $I = 0 To 2 Step 1
		 GUICtrlCreateLabel($FPSVarsArray[$I],400,25+(20*$I),140,15)
			GUICtrlSetBkColor(-1,-2)
	  Next

   ;- Engine
	  For $I = 0 To 4 Step 1
		 GUICtrlCreateLabel($EngineVarsArray[$I],400,130+(20*$I),140,15)
			GUICtrlSetBkColor(-1,-2)
	  Next

   ;- World
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
EndFunc

Func DrawButtonsAndInputs()
   Global $VarsButtonArray[0], $VarsInputArray[0]

   ;- FPS
	  ;- Buttons
		 For $I = 0 To 0 Step 1
			ReDim $VarsButtonArray[UBound($VarsButtonArray) + 1]
			if iniRead($SMITEEngineIniPath,"Engine.GameEngine",$FPSVarsArray[$I],"") = "TRUE" Then
			   $VarsButtonArray[$I] = GUICtrlCreateButton("TRUE",541,24,50,17)
			Else
			   $VarsButtonArray[$I] = GUICtrlCreateButton("FALSE",541,24,50,17)
			EndIf
		 Next
	  ;- Inputs
		 For $I = 0 To 1 Step 1
			ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
			$VarsInputArray[$I] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"Engine.GameEngine",$FPSVarsArray[$I+1],""),541,44+(20*$I),50,17,8192)
		 Next

   ;- Engine
	  ;- Inputs
		 For $I = 0 To 4 Step 1
			ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
			If $I < 3 Then
			   $VarsInputArray[$I+2] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"Engine.Engine",$EngineVarsArray[$I],""),541,130+(20*$I),50,17,8192)
			Else
			   $VarsInputArray[$I+2] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"TextureStreaming",$EngineVarsArray[$I],""),541,130+(20*$I),50,17,8192)
			EndIf
		 Next

   ;- World
	  ;- Inputs
		 For $I = 0 To 34 Step 1
			ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
			if $I = 2 Then
			   $VarsInputArray[$I+7] = GUICtrlCreateInput(iniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings",$WorldVarsArray[$I],""),145,19+(20*$I),50,17,8192)
			Else
			   if $I = 18 or $I = 19 or $I = 20 or $I = 21 or $I = 22  or $I = 23 or $I = 24 or $I = 28 or $I = 29 or $I = 34 Then
				  $VarsInputArray[$I+7] = GUICtrlCreateInput(iniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings",$WorldVarsArray[$I],""),343,19+(20*($I-18)),50,17,8192)
			   EndIf
			EndIf
		 Next

	  ;- Buttons
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

   Global $VarsInputArrayTemp = $VarsInputArray
   Global $VarsButtonArrayTemp = $VarsButtonArray
   ;- Empty blanks from TEMP arrays
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
EndFunc

;- PROGRAM FUNCTIONS
;----------------------------------------------------------------------------

Func RedrawButtonsAndInputs()
   For $I = 0 To Ubound($VarsButtonArray)-1 Step 1
	  GUICtrlDelete($VarsButtonArray[$I])
   Next
   For $I = 0 To Ubound($VarsInputArray)-1 Step 1
	  GUICtrlDelete($VarsInputArray[$I])
   Next
   GUICtrlSetState($CheckboxApplyFPSSettings,4)
   GUICtrlSetState($CheckboxApplyEngineSettings,4)
   DrawButtonsAndInputs()
   GUICtrlSetState($MainGUICheckboxUseRecommendedSettings,4)
EndFunc

Func UseRecommendedSettings()
   Local $ArrayInput[18] = [60,300,512,5120,900,0,0,0.4,1,10,0,0.8,1,256,256,0.2,1,0]
   Local $ArrayButton[26] = ["TRUE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","TRUE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE"]

   ;- Inputs
	  For $I = 0 To UBound($VarsInputArrayTemp)-1 Step 1
		 GUICtrlSetData($VarsInputArrayTemp[$I],$ArrayInput[$I])
	  Next

   ;- Buttons
	  For $I = 0 To UBound($VarsButtonArrayTemp)-1 Step 1
		 GUICtrlSetData($VarsButtonArrayTemp[$I],$ArrayButton[$I])
	  Next

   GUICtrlSetState($CheckboxApplyFPSSettings,1)
   GUICtrlSetState($CheckboxApplyEngineSettings,1)
EndFunc

Func ApplySettings()
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

   For $Steps = 0 To 3 Step 1 ;- Schritte: FPS, Engine, World, Client
	  if GUICtrlRead($CheckboxApplyFPSSettings) = 1 Then
		 if $Steps = 0 Then ;- FPS
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
		 if $Steps = 1 Then ;- ENGINE
			For $Bla = 0 To UBound($SMITEEngineIniPathArray)-1 Step 1
			   For $I = 0 To UBound($EngineVarsArray)-1 Step 1
				  if StringRegExp($SMITEEngineIniPathArray[$Bla],"\A"&$EngineVarsArray[$I]&"[=]") <> 0 Then
					 $SMITEEngineIniPathArray[$Bla] = $EngineVarsArray[$I]&"="&GUICtrlRead($VarsInputArray[$I+2])
				  EndIf
			   Next
			Next
		 EndIf
	  EndIf

	  if $Steps = 2 Then ;- World
		 For $Bla = 0 To UBound($SMITEBattleSystemSettingsIniPathArray)-1 Step 1
			For $I = 0 To UBound($WorldVarsArray)-1 Step 1
			   if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$Bla],"\A"&$WorldVarsArray[$I]&"[=]") <> 0 Then
				  if $I = 2 or $I = 18 or $I = 19 or $I = 20 or $I = 21 or $I = 22  or $I = 23 or $I = 24 or $I = 28 or $I = 29 or $I = 35 Then
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

	  if $Steps = 3 Then ;Client
		 For $Bla = 0 To UBound($SMITEBattleSystemSettingsIniPathArray)-1 Step 1
			For $I = 0 To UBound($ClientVarsArray)-1 Step 1
			   if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$Bla],"\A"&$ClientVarsArray[$I]&"[=]") <> 0 Then
				  if GUICtrlRead($CheckboxApplyClientSettings) = 1 Then
					 if GUICtrlRead($CheckboxUseDirectX11) = 1  Then
						$SMITEBattleSystemSettingsIniPathArray[$Bla] = $ClientVarsArray[$I]&"="&"True"
					 Else
						$SMITEBattleSystemSettingsIniPathArray[$Bla] = $ClientVarsArray[$I]&"="&"False"
					 EndIf
				  EndIf
			   EndIf
			Next
		 Next
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
	  if RegRead("HKCU\Software\SMITE Optimizer\","DonateInfoStatus") = "0" Then
		 RegWrite("HKCU\Software\SMITE Optimizer\","DonateInfoStatus","REG_SZ","1")
	  ElseIf RegRead("HKCU\Software\SMITE Optimizer\","DonateInfoStatus") = "1" Then
		 Local $MsgBox = MsgBox(1,"Information","Do you like the program?"&@CRLF&"Consider donating to help out a free-time Developer!"&@CRLF&"I would highly appreciate it! :3")
		 if $MsgBox = 1 Then
			ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=2NKTRNN5BTHHG")
		 EndIf
		 RegWrite("HKCU\Software\SMITE Optimizer\","DonateInfoStatus","REG_SZ","2")
	  ElseIf RegRead("HKCU\Software\SMITE Optimizer\","DonateInfoStatus") = "2" Then
		 if $BlockDonations = "False" then
			Local $MsgBox = MsgBox(1,"Information","Do you like the program?"&@CRLF&"Consider donating to help out a free-time Developer!"&@CRLF&"I would highly appreciate it! :3"&@CRLF&@CRLF&"You can disable this message:"&@CRLF&"Menu > Donations > Block Donation Info")
			if $MsgBox = 1 Then
			   ShellExecute("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=2NKTRNN5BTHHG")
			EndIf
		 EndIf
	  EndIf
   Else
	  MsgBox(0,"Uh oh","Something went wrong.")
   EndIf

   RedrawButtonsAndInputs()
EndFunc

Func GUIDisplay($Var)
   Local $TempVar

   If $Var = 1 Then
	  Global $EditBoxGUI = GUICreate("Changelog",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
		 GUICtrlSetData(-1, _Resource_GetAsString("ChangelogText"))
	  GUISetState()
   EndIf
   If $Var = 2 Then
	  Global $EditBoxGUI = GUICreate("Copyright and Credits",600,420,-1,-1,-1,$WS_EX_TOOLWINDOW)
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
		 GUICtrlSetData(-1, _Resource_GetAsString("CopyrightCreditsText"))
	  GUISetState()
   EndIf
   If $Var = 3 Then
	  Global $RestoreGUIAlive = true
	  Global $EditBoxGUI = GUICreate("Restore old configs",600,420,-3,-63,-1,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$MainGUI)
	  Global $EditBoxGUIList = GUICtrlCreateList("",5,5,590,380)
		 $TempVar = _FileListToArray($ConfigBackupPath,"*",1)
		 For $I = 0 To UBound($TempVar)-1 Step 1
			_GUICtrlListBox_AddString ($EditBoxGUIList, $TempVar[$I])
		 Next
	  Global $EditBoxGUIButtonDeleteBackups = GUICtrlCreateButton("Delete all backups",5,375,125,20)
	  Global $EditBoxGUIButtonRestore = GUICtrlCreateButton("Restore",470,380,125,35)
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
	  Global $EditBoxGUI = GUICreate("",400,70,-3+100,-65+150,-1,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$MainGUI)
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
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
		 GUICtrlSetData(-1, _Resource_GetAsString("ProgramFunctionsHelp"))
	  GUISetState()
   EndIf
   If $Var = 6 Then
	  Global $EditBoxGUI = GUICreate("Help - Restoring Configuration",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
		 GUICtrlSetData(-1, _Resource_GetAsString("RestoringConfigurationHelp"))
	  GUISetState()
   EndIf
   If $Var = 7 Then
	  Global $EditBoxGUI = GUICreate("Help - Variable Explanation",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
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

;----------------------------------------------------------------------------

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
		 Case $MenuBlockDonationInfo
			if RegRead("HKCU\Software\SMITE Optimizer\","BlockDonations") = "True" Then
			   RegWrite("HKCU\Software\SMITE Optimizer\","BlockDonations","REG_SZ","False")
			   $BlockDonations = "False"
			   MsgBox(0,"Information","Donation info will no longer be blocked.")
			Else
			   RegWrite("HKCU\Software\SMITE Optimizer\","BlockDonations","REG_SZ","True")
			   $BlockDonations = "True"
			   MsgBox(0,"Information","I can understand that you block this, i really do.")
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