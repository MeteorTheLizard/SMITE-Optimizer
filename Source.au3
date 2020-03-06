#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=SMITEOptimizerIcon.ico
#AutoIt3Wrapper_Outfile=SMITE Optimizer 32Bit.exe
#AutoIt3Wrapper_Outfile_x64=SMITE Optimizer 64Bit.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Description=SMITE Optimizer
#AutoIt3Wrapper_Res_Fileversion=1.2.2.0
#AutoIt3Wrapper_Res_LegalCopyright=Made by MrRangerLP - All Rights Reserved.
#AutoIt3Wrapper_Res_File_Add=Changelog.txt, RT_RCDATA, ChangelogText, 0
#AutoIt3Wrapper_Res_File_Add=CopyrightCredits.txt, RT_RCDATA, CopyrightCreditsText, 0
#AutoIt3Wrapper_Res_File_Add=ProgramFunctions.txt, RT_RCDATA, ProgramFunctionsHelp, 0
#AutoIt3Wrapper_Res_File_Add=RestoringConfiguration.txt, RT_RCDATA, RestoringConfigurationHelp, 0
#AutoIt3Wrapper_Res_File_Add=VariableExplanation.txt, RT_RCDATA, VariableExplanationHelp, 0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


;-- INCLUDES (These get Trimmed by Au3Stripper)
;----------------------------------------------------------------------------

#include <Array.au3>
#include <File.au3>
#include <GuiListBox.au3>
#include <GUIConstants.au3>
#include <ResourcesEx.au3>
#include <GuiComboBox.au3>

;----------------------------------------------------------------------------

;-- VARIABLES
;----------------------------------------------------------------------------

Const $ProgramName = "SMITE Optimizer"
Const $ProgramVersion = "V1.2.2"
Const $ProgramVersionRE = "1.2.2" ;- Registry Value

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
Global Const $TextureVarsArray[9] = ["World","Character","Terrain","NPC","Weapon","Vehicle","Shadows","Skybox","Effects"]
Global $EditBoxGUI, $EditBoxGUIButtonRestore = 2,$EditBoxGUIButtonDeleteBackups = 2, $EditBoxGUIButtonHelp1 = 2, $EditBoxGUIButtonHelp2 = 2, $EditBoxGUIButtonHelp3 = 2, $DebugGUIButtonResetConfig = 2, $MainGUIDrawn = false, $RestoreGUIAlive = false
Global Const $ConfigBackupPath = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders","Personal")&"\My Games\SMITE Config Backup\"

;Indexer (World,Character etc) - Quality Level - Contents
Global Const $TextureQualityHive[9][9][4] = _
	[	_
		[ _	;World
			[ _ ;Best
				"TEXTUREGROUP_World=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=2048,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_World=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=1821,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_World=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=1594,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_World=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=1367,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_World=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=1140,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_World=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=913,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_World=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=686,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_World=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=459,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_World=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=2,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""] _
		],[ _ ;Character
			[ _ ;Best
				"TEXTUREGROUP_Character=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_Character=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_Character=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_Character=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_Character=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_Character=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_Character=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_Character=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_Character=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_CharacterSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""] _
		],[ _ ;Terrain
			[ _ ;Best
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=512,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=3641,MaxLODSizeTexturePack=3641,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=3641,MaxLODSizeTexturePack=3641,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=456,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=3186,MaxLODSizeTexturePack=3186,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=3186,MaxLODSizeTexturePack=3186,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=400,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=2731,MaxLODSizeTexturePack=2731,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=2731,MaxLODSizeTexturePack=2731,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=344,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=2276,MaxLODSizeTexturePack=2276,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=2276,MaxLODSizeTexturePack=2276,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=288,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=232,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=1366,MaxLODSizeTexturePack=1366,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=1366,MaxLODSizeTexturePack=1366,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=176,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=1,MaxLODSize=911,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=1,MaxLODSize=911,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=120,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_Terrain_Heightmap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Terrain_Weightmap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WorldDetail=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""] _
		],[ _ ;NPC
			[ _ ;Best
				"TEXTUREGROUP_NPC=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_NPC=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_NPC=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_NPC=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_NPC=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_NPC=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_NPC=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_NPC=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_NPC=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_NPCSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""] _
		],[ _ ;Weapon
			[ _ ;Best
				"TEXTUREGROUP_Weapon=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=128,MaxLODSize=512,MaxLODSizeTexturePack=512,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_Weapon=(MinLODSize=114,MaxLODSize=456,MaxLODSizeTexturePack=456,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=114,MaxLODSize=456,MaxLODSizeTexturePack=456,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=114,MaxLODSize=456,MaxLODSizeTexturePack=456,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_Weapon=(MinLODSize=100,MaxLODSize=400,MaxLODSizeTexturePack=400,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=100,MaxLODSize=400,MaxLODSizeTexturePack=400,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=100,MaxLODSize=400,MaxLODSizeTexturePack=400,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_Weapon=(MinLODSize=86,MaxLODSize=344,MaxLODSizeTexturePack=344,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=86,MaxLODSize=344,MaxLODSizeTexturePack=344,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=86,MaxLODSize=344,MaxLODSizeTexturePack=344,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_Weapon=(MinLODSize=72,MaxLODSize=288,MaxLODSizeTexturePack=288,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=72,MaxLODSize=288,MaxLODSizeTexturePack=288,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=72,MaxLODSize=288,MaxLODSizeTexturePack=288,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_Weapon=(MinLODSize=58,MaxLODSize=232,MaxLODSizeTexturePack=232,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=58,MaxLODSize=232,MaxLODSizeTexturePack=232,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=58,MaxLODSize=232,MaxLODSizeTexturePack=232,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_Weapon=(MinLODSize=44,MaxLODSize=176,MaxLODSizeTexturePack=176,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=44,MaxLODSize=176,MaxLODSizeTexturePack=176,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=44,MaxLODSize=176,MaxLODSizeTexturePack=176,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_Weapon=(MinLODSize=30,MaxLODSize=120,MaxLODSizeTexturePack=120,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=30,MaxLODSize=120,MaxLODSizeTexturePack=120,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=30,MaxLODSize=120,MaxLODSizeTexturePack=120,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_Weapon=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_WeaponSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""] _
		],[ _ ;Vehicle
			[ _ ;Best
				"TEXTUREGROUP_Vehicle=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=256,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_Vehicle=(MinLODSize=228,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=456,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=228,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_Vehicle=(MinLODSize=200,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=400,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=200,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_Vehicle=(MinLODSize=172,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=344,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=172,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_Vehicle=(MinLODSize=144,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=288,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=144,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_Vehicle=(MinLODSize=116,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=232,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=116,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_Vehicle=(MinLODSize=88,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=176,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=88,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_Vehicle=(MinLODSize=60,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=120,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=60,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_Vehicle=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleNormalMap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_VehicleSpecular=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				""] _
		],[ _ ;Shadows
			[ _ ;Best
				"TEXTUREGROUP_Lightmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=512,MaxLODSize=2048,MaxLODSizeTexturePack=2048,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=256,MaxLODSize=4096,MaxLODSizeTexturePack=4096,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_Lightmap=(MinLODSize=456,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=456,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=228,MaxLODSize=3641,MaxLODSizeTexturePack=3641,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_Lightmap=(MinLODSize=400,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=400,MaxLODSize=1594,MaxLODSizeTexturePack=1594,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=200,MaxLODSize=3186,MaxLODSizeTexturePack=3186,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_Lightmap=(MinLODSize=344,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=344,MaxLODSize=1367,MaxLODSizeTexturePack=1367,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=172,MaxLODSize=2731,MaxLODSizeTexturePack=2731,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_Lightmap=(MinLODSize=288,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=288,MaxLODSize=1140,MaxLODSizeTexturePack=1140,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=144,MaxLODSize=2276,MaxLODSizeTexturePack=2276,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_Lightmap=(MinLODSize=232,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=232,MaxLODSize=913,MaxLODSizeTexturePack=913,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=116,MaxLODSize=1821,MaxLODSizeTexturePack=1821,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_Lightmap=(MinLODSize=176,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=176,MaxLODSize=686,MaxLODSizeTexturePack=686,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=88,MaxLODSize=1366,MaxLODSizeTexturePack=1366,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_Lightmap=(MinLODSize=120,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=120,MaxLODSize=459,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=60,MaxLODSize=911,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_Lightmap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_Shadowmap=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,NumStreamedMips=3,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_ImageBasedReflection=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_Blur5)", _
				""] _
		],[ _ ;Skybox
			[ _ ;Best
				"TEXTUREGROUP_Skybox=(MinLODSize=2048,MaxLODSize=2048,MaxLODSizeTexturePack=8192,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_Skybox=(MinLODSize=1821,MaxLODSize=1821,MaxLODSizeTexturePack=7282,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_Skybox=(MinLODSize=1594,MaxLODSize=1594,MaxLODSizeTexturePack=6372,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_Skybox=(MinLODSize=1367,MaxLODSize=1367,MaxLODSizeTexturePack=5462,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_Skybox=(MinLODSize=1140,MaxLODSize=1140,MaxLODSizeTexturePack=4552,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_Skybox=(MinLODSize=913,MaxLODSize=913,MaxLODSizeTexturePack=3642,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_Skybox=(MinLODSize=686,MaxLODSize=686,MaxLODSizeTexturePack=2732,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_Skybox=(MinLODSize=459,MaxLODSize=459,MaxLODSizeTexturePack=1822,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_Skybox=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				"", _
				""] _
		],[ _ ;Effects
			[ _ ;Best
				"TEXTUREGROUP_Effects=(MinLODSize=256,MaxLODSize=1024,MaxLODSizeTexturePack=2048,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=256,MaxLODSize=512,MaxLODSizeTexturePack=1024,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""], _
				[ _ ;Very High
				"TEXTUREGROUP_Effects=(MinLODSize=228,MaxLODSize=911,MaxLODSizeTexturePack=1821,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=228,MaxLODSize=456,MaxLODSizeTexturePack=911,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""], _
				[ _ ;High
				"TEXTUREGROUP_Effects=(MinLODSize=200,MaxLODSize=798,MaxLODSizeTexturePack=1594,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=200,MaxLODSize=400,MaxLODSizeTexturePack=798,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""], _
				[ _ ;Medium
				"TEXTUREGROUP_Effects=(MinLODSize=172,MaxLODSize=685,MaxLODSizeTexturePack=1367,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=172,MaxLODSize=344,MaxLODSizeTexturePack=685,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""], _
				[ _ ;Low
				"TEXTUREGROUP_Effects=(MinLODSize=144,MaxLODSize=572,MaxLODSizeTexturePack=1140,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=144,MaxLODSize=288,MaxLODSizeTexturePack=572,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""], _
				[ _ ;Very Low
				"TEXTUREGROUP_Effects=(MinLODSize=116,MaxLODSize=459,MaxLODSizeTexturePack=913,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=116,MaxLODSize=232,MaxLODSizeTexturePack=459,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""], _
				[ _ ;Absolute Worst
				"TEXTUREGROUP_Effects=(MinLODSize=88,MaxLODSize=346,MaxLODSizeTexturePack=686,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=88,MaxLODSize=176,MaxLODSizeTexturePack=346,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""], _
				[ _ ;Potato
				"TEXTUREGROUP_Effects=(MinLODSize=60,MaxLODSize=233,MaxLODSizeTexturePack=459,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=60,MaxLODSize=120,MaxLODSizeTexturePack=233,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""], _
				[ _ ;N64 Graphics, but 64 times worse
				"TEXTUREGROUP_Effects=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=1,LODBiasTexturePack=0,MinMagFilter=Linear,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"TEXTUREGROUP_EffectsNotFiltered=(MinLODSize=0,MaxLODSize=0,MaxLODSizeTexturePack=0,LODBias=0,LODBiasTexturePack=0,MinMagFilter=Aniso,MipFilter=Linear,MipGenSettings=TMGS_SimpleAverage)", _
				"", _
				""] _
		] _
	]

;- CONFIG INIT AND CHECK
;----------------------------------------------------------------------------

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

	  Global $MenuHelp = GUICtrlCreateMenu("Help")
		 Global $MenuHelpItem = GUICtrlCreateMenuItem("Help",$MenuHelp)
		 Global $MenuDebugItem = GUICtrlCreateMenuItem("Debug",$MenuHelp)

   ;- SETTINGS GROUPS
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
   ;- FPS
	  For $I = 0 To 2 Step 1
		 GUICtrlCreateLabel($FPSVarsArray[$I],600,25+(20*$I),140,15)
			GUICtrlSetBkColor(-1,-2)
	  Next

   ;- Engine
	  For $I = 0 To 4 Step 1
		 GUICtrlCreateLabel($EngineVarsArray[$I],600,130+(20*$I),140,15)
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

	;- Texture
      For $I = 0 To 8 Step 1
		GUICtrlCreateLabel($TextureVarsArray[$I]&" Quality: ",400,20+(36*$I),190,15)
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
			   $VarsButtonArray[$I] = GUICtrlCreateButton("TRUE",741,24,50,17)
			Else
			   $VarsButtonArray[$I] = GUICtrlCreateButton("FALSE",741,24,50,17)
			EndIf
		 Next
	  ;- Inputs
		 For $I = 0 To 1 Step 1
			ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
			$VarsInputArray[$I] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"Engine.GameEngine",$FPSVarsArray[$I+1],""),741,44+(20*$I),50,17,8192)
		 Next

   ;- Engine
	  ;- Inputs
		 For $I = 0 To 4 Step 1
			ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
			If $I < 3 Then
			   $VarsInputArray[$I+2] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"Engine.Engine",$EngineVarsArray[$I],""),741,130+(20*$I),50,17,8192)
			Else
			   $VarsInputArray[$I+2] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"TextureStreaming",$EngineVarsArray[$I],""),741,130+(20*$I),50,17,8192)
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

	;- Texture
		;- Combobox
			Global $TextureCombos[9]
			Local $TypeOptions = "Best|Very High|High|Medium|Low|Very Low|Absolute Worst|Potato|N64 Graphics, but 64 times worse"
			For $I = 0 To 8 Step 1
				$TextureCombos[$I] = GUICtrlCreateCombo("",400,35+(36*$I),190,13,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
				GUICtrlSetData(-1,$TypeOptions)
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
   GUISetState(@SW_DISABLE,$MainGUI)
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

   ;- Inputs
	  For $I = 0 To UBound($VarsInputArrayTemp)-1 Step 1
		 GUICtrlSetData($VarsInputArrayTemp[$I],$ArrayInput[$I])
	  Next

   ;- Buttons
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

   For $Steps = 0 To 4 Step 1 ;- Steps: FPS, Engine, World, Client, Texture
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

	if GUICtrlRead($CheckboxApplyClientSettings) = 1 Then
		  if $Steps = 3 Then ;Client
			 For $Bla = 0 To UBound($SMITEBattleSystemSettingsIniPathArray)-1 Step 1
				For $I = 0 To UBound($ClientVarsArray)-1 Step 1
				   if StringRegExp($SMITEBattleSystemSettingsIniPathArray[$Bla],"\A"&$ClientVarsArray[$I]&"[=]") <> 0 Then
						 if GUICtrlRead($CheckboxUseDirectX11) = 1  Then
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
			If $Steps = 4 Then ;Texture
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
	  Global $EditBoxGUI = GUICreate("Restore old configs",800,420,0,-69,-1,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$MainGUI)
	  Global $EditBoxGUIList = GUICtrlCreateList("",5,5,790,380)
		 $TempVar = _FileListToArray($ConfigBackupPath,"*",1)
		 For $I = 0 To UBound($TempVar)-1 Step 1
			_GUICtrlListBox_AddString ($EditBoxGUIList, $TempVar[$I])
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