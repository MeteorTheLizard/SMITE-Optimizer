


	#comments-start

		This script is part of the SMITE Optimizer and licensed under the GPL-3.0 License.
		Copyright (C) 2024 - Mario "Meteor Thuri" Schien.

		Contact: MrRangerLP (at) gmx.de
		License: https://www.gnu.org/licenses/gpl-3.0.en.html


		This devtool extracts groups and keynames from freshly generated .ini files and puts them in a list that is then used to generate a base array which acts as a hive replacement.
		The base array is used to restore values in the check integrity process to ensure the smite optimizer can change the values that it needs to change.
		I'm not gonna win any awards with this script, too tired. -Meteor


		Issues:
			The output isn't perfect. Empty group lines have to be removed and the row count needs to be adjusted accordingly.
			This script was made in a rush to fix a program-breaking bug.
			TEXTUREGROUP_ settings are only relevant for [SystemSettings] and can be removed from all other groups.

	#comments-end



#NoTrayIcon
#Include <Array.au3>
#Include <File.au3>

Local $iSettingsCount = 88 + 7 ;- I'm too tired to figure out why this is needed.
Local $aModifiers[$iSettingsCount] = [ _
	"AllowD3D11", _
	"AllowImageReflections", _
	"AllowImageReflectionShadowing", _
	"bAllowDropShadows", _
	"bAllowHighQualityMaterials", _
	"bAllowLightShafts", _
	"bAllowRagdolling", _
	"bAllowWholeSceneDominantShadows", _
	"bJumpEnabled", _
	"Bloom", _
	"Borderless", _
	"bSmoothFrameRate", _
	"bUseConservativeShadowBounds", _
	"bUseLowQualMaterials", _
	"CompositeDynamicLights", _
	"DepthOfField", _
	"DetailMode", _
	"DirectionalLightmaps", _
	"Distortion", _
	"DropParticleDistortion", _
	"DynamicDecals", _
	"DynamicLights", _
	"DynamicShadows", _
	"FilteredDistortion", _
	"FogVolumes", _
	"Fullscreen", _
	"FullscreenWindowed", _
	"FXAAQuality", _
	"LensFlares", _
	"LightEnvironmentShadows", _
	"LoadMapTimeLimit", _
	"MaxActiveDecals", _
	"MaxAnisotropy", _
	"MaxChannels", _
	"MaxFilterBlurSampleCount", _
	"MaximumPoolSize", _
	"MaxSmoothedFrameRate", _
	"MinDesiredFrameRate", _
	"MinimumPoolSize", _
	"MinSmoothedFrameRate", _
	"MotionBlur", _
	"MotionBlurPause", _
	"MotionBlurSkinning", _
	"ParticleLODBias", _
	"PerfScalingBias", _
	"PreferD3D11", _
	"ResX", _
	"ResY", _
	"ScreenPercentage", _
	"SHSecondaryLighting", _
	"SpeedTreeFronds", _
	"SpeedTreeLeaves", _
	"SpeedTreeLODBias", _
	"SpeedTreeWind", _
	"StaticDecals", _
	"TargetFrameRate", _
	"TEXTUREGROUP_Bokeh", _
	"TEXTUREGROUP_Character", _
	"TEXTUREGROUP_CharacterNormalMap", _
	"TEXTUREGROUP_CharacterSpecular", _
	"TEXTUREGROUP_Effects", _
	"TEXTUREGROUP_EffectsNotFiltered", _
	"TEXTUREGROUP_ImageBasedReflection", _
	"TEXTUREGROUP_Lightmap", _
	"TEXTUREGROUP_NPC", _
	"TEXTUREGROUP_NPCNormalMap", _
	"TEXTUREGROUP_NPCSpecular", _
	"TEXTUREGROUP_Shadowmap", _
	"TEXTUREGROUP_Skybox", _
	"TEXTUREGROUP_Terrain_Heightmap", _
	"TEXTUREGROUP_Terrain_Weightmap", _
	"TEXTUREGROUP_Vehicle", _
	"TEXTUREGROUP_VehicleNormalMap", _
	"TEXTUREGROUP_VehicleSpecular", _
	"TEXTUREGROUP_Weapon", _
	"TEXTUREGROUP_WeaponNormalMap", _
	"TEXTUREGROUP_WeaponSpecular", _
	"TEXTUREGROUP_World", _
	"TEXTUREGROUP_WorldDetail", _
	"TEXTUREGROUP_WorldNormalMap", _
	"TEXTUREGROUP_WorldSpecular", _
	"UnbatchedDecals", _
	"UpscaleScreenPercentage", _
	"UseD3D11Beta", _
	"UseDX11", _
	"UseDynamicStreaming", _
	"UseVsync", _
	"VsyncPresentInterval" _
]


Local $sBaseSystemSettings = "C:\Users\RX1500x-METEOR\Desktop\BattleSystemSettings.ini"
Local $sBaseEngineSettings = "C:\Users\RX1500x-METEOR\Desktop\BattleEngine.ini"
Local $sBaseGameSettings = "C:\Users\RX1500x-METEOR\Desktop\BattleGame.ini"


;- SystemSettings

Local $aReadArray[0]
	_FileReadToArray($sBaseGameSettings,$aReadArray,$FRTA_NOCOUNT)


Local $aReturnTable[1][$iSettingsCount]

;- Retrieve all existing groups

Local $iSize = 1

For $I = 0 To uBound($aReadArray) - 1 Step 1
	If StringLeft($aReadArray[$I],1) = "[" Then

		If $I >= uBound($aReturnTable,1) Then
			$iSize = $iSize + 1
			ReDim $aReturnTable[$iSize][$iSettingsCount]
		EndIf

		$aReturnTable[$iSize - 1][0] = $aReadArray[$I]

	EndIf
Next


;- Iterate through all the keys and find its groups, add the keys to the appropriate rows

For $I = 0 To $iSettingsCount - 1 Step 1

	Local $iLen = StringLen($aModifiers[$I])

	For $A = uBound($aReadArray) - 1 To 0 Step -1

		If StringLeft($aReadArray[$A],$iLen) = $aModifiers[$I] Then ;- We found the KeyName in the file


			;- We found it so we keep going until we hit a group

			For $B = $A To 0 Step -1

				If StringLeft($aReadArray[$B],1) = "[" Then ;- We hit the group it belongs to

					For $C = 0 To uBound($aReturnTable,1) - 1 Step 1 ;- Find the row from the ReturnTable that the group belongs to

						If $aReturnTable[$C][0] = $aReadArray[$B] Then ;- Row found

							For $D = 1 To $iSettingsCount - 1 Step 1 ;- Find free column to fill in KeyName
								If $aReturnTable[$C][$D] = "" Then
									$aReturnTable[$C][$D] = $aModifiers[$I]
									ExitLoop(3)
								EndIf
							Next
						EndIf
					Next


					ExitLoop

				EndIf
			Next
		EndIf
	Next
Next

; ----- ----- ----- ----- -----

;- Output the Array in AutoIt Code. (Array)

	$I = 0
	Local $1DSize = uBound($aReturnTable,1) - 1
	Local $2DSize = uBound($aReturnTable,2) - 1

	ConsoleWrite("Global Const $GameSettingsClearHive["&$1DSize&"]["&$2DSize + 1&"] = [ _"&@CRLF&@TAB&"[") ;- Initial line.

	While ($I < $1DSize)
		ConsoleWrite("'"&$aReturnTable[$I][0]&"',")

		While ($B <= $2DSize)
			If $B = $2DSize Then
				If $I = $1DSize-1 Then
					ConsoleWrite("'"&$aReturnTable[$I][$B]&"'] _"&@CRLF&"]"&@CRLF)
				Else
					If $aReturnTable[$I][$B] = "" Then
						ConsoleWrite("], _"&@CRLF&@TAB&"[")
						ExitLoop
					EndIf

					ConsoleWrite("'"&$aReturnTable[$I][$B]&"'], _"&@CRLF&@TAB&"[")
				EndIf

				ExitLoop
			Else
				If $aReturnTable[$I][$B] <> "" Then
					If $aReturnTable[$I][$B+1] = "" Then
						ConsoleWrite("'"&$aReturnTable[$I][$B]&"'")
					Else
						ConsoleWrite("'"&$aReturnTable[$I][$B]&"',")
					EndIf
				EndIf

				$B = $B + 1
			EndIf
		WEnd

		$B = 1
		$I = $I + 1
	WEnd

; ----- ----- ----- ----- -----
