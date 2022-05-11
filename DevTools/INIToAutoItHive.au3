


	#comments-start

		This script is part of the SMITE Optimizer and licensed under the GPL-3.0 License.
		Copyright (C) 2020 - Mario "Meteor Thuri" Schien.

		Contact: MrRangerLP (at) gmx.de
		License: https://www.gnu.org/licenses/gpl-3.0.en.html


		This devtool allows you to format a .ini file into a nicely formatted AutoIt array "Hive".
			It requires a perfectly formatted .ini as a base. Any comments "//" "--" and ";" ";;" need to be removed!
			Anything else that might break the AutoIt syntax that has not been accounted for needs to be removed as well.
			After every group, there needs to be at least one empty line. (Except for the last group)
			Empty groups need to be removed as well as they WILL cause formatting problems!

		Issues:
			It does not respect the Line length limit that AutoIt has, meaning some lines might have to be split with an underscore when AutoIt throws an "unterminated string" error.
				^ This Issue is especially annoying when formatting the SystemSettings file as you WILL have to split several lines manually.
			On the very last line before the second last bracket, it puts three ' instead of one.

	#comments-end



#NoTrayIcon
#Include <Array.au3>

HotKeySet("{F5}","_END") ;- Gotta be able to abort y'know?
Func _END()
	Exit
EndFunc

;- Path to the INI that should be used as reference
Global $EngineSettings = "C:\Path\To\Ini.ini"

;- Some vars
Global $EngineSettingsRead = FileReadToArray($EngineSettings)
Global $Bounds = uBound($EngineSettingsRead) - 1 ;- Speed yo
Global $OutputAr[0][0]
Global $1DSize = 0
Global $2DSize = 0
Global $1DStep = 0
Global $2DStep = 0
Global $I = 0
Global $B = 1

;- Make the Array have proper dimensions.

	While ($I < $Bounds)
		Local $VarCount = 0

		If StringLeft($EngineSettingsRead[$I],1) = "[" and StringRight($EngineSettingsRead[$I],1) = "]" Then
			$1DSize = $1DSize + 1
			$I = $I + 1

			While StringInStr($EngineSettingsRead[$I],"=") and ($I < $Bounds)
				$I = $I + 1
				$VarCount = $VarCount + 1
			WEnd

			If $2DSize < $VarCount Then
				$2DSize = $VarCount
			EndIf

			$VarCount = 0
		EndIf

		$I = $I + 1
	WEnd

	ReDim $OutputAr[$1DSize][$2DSize+1]

; ----- ----- ----- ----- -----

;- Convert INI to 2D Array.

	$I = 0

	While ($I < $Bounds)
		If StringLeft($EngineSettingsRead[$I],1) = "[" and StringRight($EngineSettingsRead[$I],1) = "]" Then
			$OutputAr[$1DStep][$2DStep] = $EngineSettingsRead[$I]
			$2DStep = $2DStep + 1
			$I = $I + 1

			While StringInStr($EngineSettingsRead[$I],"=") and ($I <= $Bounds)
				$OutputAr[$1DStep][$2DStep] = $EngineSettingsRead[$I]
				$2DStep = $2DStep + 1

				If $I = $Bounds Then ExitLoop
				$I = $I + 1
			WEnd

			$1DStep = $1DStep + 1
			$2DStep = 0
		EndIf

		$I = $I + 1
	WEnd

; ----- ----- ----- ----- -----

;- Output the Array in AutoIt Code. (Array)

	$I = 0

	ConsoleWrite("Global Const $EngineSettingsClearHive["&$1DSize&"]["&$2DSize + 1&"] = [ _"&@CRLF&@TAB&"[") ;- Initial line.

	While ($I < $1DSize)
		ConsoleWrite("'"&$OutputAr[$I][0]&"',")

		While ($B <= $2DSize)
			If $B = $2DSize Then
				If $I = $1DSize-1 Then
					ConsoleWrite("'"&$OutputAr[$I][$B]&"'] _"&@CRLF&"]"&@CRLF)
				Else
					If $OutputAr[$I][$B] = "" Then
						ConsoleWrite("], _"&@CRLF&@TAB&"[")
						ExitLoop
					EndIf

					ConsoleWrite("'"&$OutputAr[$I][$B]&"'], _"&@CRLF&@TAB&"[")
				EndIf

				ExitLoop
			Else
				If $OutputAr[$I][$B] <> "" Then
					If $OutputAr[$I][$B+1] = "" Then
						ConsoleWrite("'"&$OutputAr[$I][$B]&"'")
					Else
						ConsoleWrite("'"&$OutputAr[$I][$B]&"',")
					EndIf
				EndIf

				$B = $B + 1
			EndIf
		WEnd

		$B = 1
		$I = $I + 1
	WEnd

; ----- ----- ----- ----- -----