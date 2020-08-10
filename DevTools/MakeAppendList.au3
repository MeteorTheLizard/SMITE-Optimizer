#NoTrayIcon

;- This script creates a resource append list.
;- The code is rather meh but it works for my use case so whatever.

#Include <Array.au3>
#Include <File.au3>

HotKeySet("{F5}","_END")
Func _END()
	Exit
EndFunc

Global Const $TrimmedPaths[1] = ["HelpText\"]
Global Const $TrimmedExts[6] = ["jpg","jpeg","gif","wav","mp3","txt"]
Global Const $MainResourcePath = "" ;- Path to Resource folder.

Local $RetStr = ""
Local $Files = _FileListToArrayRec($MainResourcePath,"*",0,1,0,1)
_ArrayDelete($Files,0) ;- Remove count.

For $I = 0 To uBound($Files) - 1 Step 1
	Local $NewStr

	For $B = 0 To 5 Step 1
		If StringRight($Files[$I],StringLen($TrimmedExts[$B])) = $TrimmedExts[$B] Then
			$NewStr = StringTrimRight($Files[$I],StringLen($TrimmedExts[$B])+1)
			ExitLoop
		EndIf
	Next

	For $B = 0 To 0 Step 1
		If StringLeft($NewStr,StringLen($TrimmedPaths[$B])) = $TrimmedPaths[$B] Then
			$NewStr = StringTrimLeft($NewStr,StringLen($TrimmedPaths[$B]))
			ExitLoop
		EndIf
	Next

	$RetStr = $RetStr & "#AutoIt3Wrapper_Res_File_Add=" & $Files[$I] & ", RT_RCDATA, "&$NewStr&", 0" & @CRLF
Next

ConsoleWrite($RetStr&@CRLF) ;- Return