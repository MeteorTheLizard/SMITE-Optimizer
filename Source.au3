#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=SMITEOptimizerIcon.ico
#AutoIt3Wrapper_Outfile=SMITE Optimizer 32Bit.exe
#AutoIt3Wrapper_Outfile_x64=SMITE Optimizer 64Bit.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Description=SMITE Optimizer
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Made by MrRangerLP - All Rights Reserved.
#AutoIt3Wrapper_Res_File_Add=Changelog.txt, RT_RCDATA, ChangelogText, 0
#AutoIt3Wrapper_Res_File_Add=CopyrightCredits.txt, RT_RCDATA, CopyrightCreditsText, 0
#AutoIt3Wrapper_Res_File_Add=ProgramFunctions.txt, RT_RCDATA, ProgramFunctionsHelp, 0
#AutoIt3Wrapper_Res_File_Add=RestoringConfiguration.txt, RT_RCDATA, RestoringConfigurationHelp, 0
#AutoIt3Wrapper_Res_File_Add=VariableExplanation.txt, RT_RCDATA, VariableExplanationHelp, 0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ResourcesEx.au3>
#include <Array.au3>
#include <File.au3>
#include <GuiListBox.au3>

;-- VARIABLES
;----------------------------------------------------------------------------

Const $ProgramName = "SMITE Optimizer"
Const $ProgramVersion = "V1.1"
Const $ProgramVersionRE = "1.1" ;- Registry Value


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
			 MsgBox(0,"ERROR!","Could not connect to the Server."& @CRLF & "You can manually check for updates by visiting: www.reddit.com/r/srgg/new" & @CRLF & @CRLF & "You can also disable the automatic update check in the settings.")
		 Else
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


Const $FPSVarsArray[4] = ["bSmoothFrameRate","MinSmoothedFrameRate","MaxSmoothedFrameRate"]
Const $EngineVarsArray[6] = ["MaxParticleResize","MaxParticleResizeWarn","MaxParticleVertexMemory","MinimumPoolSize","MaximumPoolSize"]
Const $WorldVarsArray[36] = ["StaticDecals","DynamicDecals","DecalCullDistanceScale","DynamicLights","DynamicShadows","LightEnvironmentShadows","CompositeDynamicLights","SHSecondaryLighting","DepthOfField","Bloom","bAllowLightShafts","Distortion","DropParticleDistortion","LensFlares","AllowRadialBlur","AllowSubsurfaceScattering","AllowImageReflections","bAllowHighQualityMaterials","SkeletalMeshLODBias","ParticleLODBias","DetailMode","MaxDrawDistanceScale","ShadowFilterQualityBias","MaxShadowResolution","MaxWholeSceneDominantShadowResolution","bAllowWholeSceneDominantShadows","bUseConservativeShadowBounds","bAllowRagdolling","PerfScalingBias","StaticMeshLODBias","bAllowDropShadows","AllowScreenDoorFade","AllowScreenDoorLODFading","bAllowFog","SpeedTreeWind","ShadowTexelsPerPixel"]
Global $EditBoxGUI, $EditBoxGUIButtonRestore = 2,$EditBoxGUIButtonHelp1 = 2, $EditBoxGUIButtonHelp2 = 2, $EditBoxGUIButtonHelp3 = 2, $VarsLabelArray[0]
Const $ConfigBackupPath = "C:\Users\"&@UserName&"\Documents\My Games\Smite\BattleGame\SO Config Backup\"

;- Check if config exists & set their path.
if fileExists("C:\Users\"&@UserName&"\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini") Then ;- Non-steam
   Global $IsSteamUser = 0
   Const $SMITEEngineIniPath = "C:\Users\"&@UserName&"\Documents\My Games\Smite\BattleGame\Config\BattleEngine.ini"
   Const $SMITEBattleSystemSettingsIniPath = "C:\Users\"&@UserName&"\Documents\My Games\Smite\BattleGame\Config\BattleSystemSettings.ini"
Else ;Steam
   if fileExists(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")) = 1 Then
	  Global $IsSteamUser = 1
	  Const $SMITEEngineIniPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")&"\BattleGame\Config\DefaultEngine.ini"
	  Const $SMITEBattleSystemSettingsIniPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 386360\","InstallLocation")&"\BattleGame\Config\DefaultSystemSettings.ini"
   Else
	  MsgBox(0,"ERROR!","Could not find SMITE Configuration."&@CRLF&"Exiting...")
	  Exit
   EndIf
EndIf


;- DRAW GUI FUNCTIONS
;----------------------------------------------------------------------------


Func DrawMainGUI()
   if $IsSteamUser = 1 Then
	  Global $MainGUI = GUICreate($ProgramName&" "&$ProgramVersion&" Steam mode",600,420,-1,-1)
   Else
	  Global $MainGUI = GUICreate($ProgramName&" "&$ProgramVersion,600,420,-1,-1)
   EndIf
	  Global $MainGUIDisclaimerLabel = GUICtrlCreateLabel("IMPORTANT: This program does NOT interact with SMITE directly. It only edits the config which is NOT a banable offense.",5,385,600,25)
   Global $MainGUIGroup = GUICtrlCreateGroup("",5,5,590,379)
      Global $MainGUIApplySettings = GUICtrlCreateButton("Apply settings",400,348,190,30)
   Global $MainGUICheckboxUseRecommendedSettings = GUiCtrlCreateCheckbox("Use recommended settings",403,329,150,17)

   Global $CheckboxApplyFPSSettings = GUICtrlCreateCheckbox("Apply FPS settings", 400,135,105,15)
   Global $CheckboxApplyEngineSettings = GUICtrlCreateCheckbox("Apply Engine Settings",400,293,135,15)


   ;- MENU
   	  Global $Menu = GUICtrlCreateMenu("SO "&$ProgramVersion)
	  Global $MenuRedditLink = GUICtrlCreateMenuItem("Open SRGG Subreddit",$Menu)
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

   ;- SETTINGS GROUPS
	  Global $GroupFPS = GUICtrlCreateGroup("FPS Settings",395,5,200,150)
	  Global $GroupEngine = GUICtrlCreateGroup("Engine Settings",395,163,200,150)
      Global $GroupWorld = GUICtrlCreateGroup("World Settings",5,5,391,379)
	  Global $GroupWorldMid = GUICtrlCreateGroup("",391/2,5,3,379)
	  For $I = 0 To 16 Step 1
		 GUICtrlCreateGroup("",5,32+(20*$I),390,5)
	  Next

   GUISetState()
EndFunc
DrawMainGUI()

Func DrawLabels()
   ;- FPS
	  For $I = 0 To 2 Step 1
		 ReDim $VarsLabelArray[UBound($VarsLabelArray) + 1]
		 $VarsLabelArray[$I] = GUICtrlCreateLabel($FPSVarsArray[$I],400,25+(20*$I),140,15)
			GUICtrlSetBkColor(-1,-2)
	  Next

   ;- Engine
	  For $I = 0 To 4 Step 1
		 ReDim $VarsLabelArray[UBound($VarsLabelArray) + 1]
		 $VarsLabelArray[$I+3] = GUICtrlCreateLabel($EngineVarsArray[$I],400,183+(20*$I),140,15)
			GUICtrlSetBkColor(-1,-2)
	  Next

   ;- World
      For $I = 0 To 35 Step 1
		 ReDim $VarsLabelArray[UBound($VarsLabelArray) + 1]
		 if $I > 17 Then
			$VarsLabelArray[$I+3] = GUICtrlCreateLabel($WorldVarsArray[$I],200,20+(20*($I-18)),140,15)
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
			$VarsLabelArray[$I+3] = GUICtrlCreateLabel($WorldVarsArray[$I],10,20+(20*$I),140,15)
		 EndIf
			GUICtrlSetBkColor(-1,-2)
	  Next
EndFunc
DrawLabels()

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
			   $VarsInputArray[$I+2] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"Engine.Engine",$EngineVarsArray[$I],""),541,182+(20*$I),50,17,8192)
			Else
			   $VarsInputArray[$I+2] = GUICtrlCreateInput(iniRead($SMITEEngineIniPath,"TextureStreaming",$EngineVarsArray[$I],""),541,182+(20*$I),50,17,8192)
			EndIf
		 Next

   ;- World
	  ;- Inputs
		 For $I = 0 To 35 Step 1
			ReDim $VarsInputArray[UBound($VarsInputArray) + 1]
			if $I = 2 Then
			   $VarsInputArray[$I+7] = GUICtrlCreateInput(iniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings",$WorldVarsArray[$I],""),145,19+(20*$I),50,17,8192)
			Else
			   if $I = 18 or $I = 19 or $I = 20 or $I = 21 or $I = 22  or $I = 23 or $I = 24 or $I = 28 or $I = 29 or $I = 35 Then
				  $VarsInputArray[$I+7] = GUICtrlCreateInput(iniRead($SMITEBattleSystemSettingsIniPath,"SystemSettings",$WorldVarsArray[$I],""),343,19+(20*($I-18)),50,17,8192)
			   EndIf
			EndIf
		 Next

	  ;- Buttons
		 For $I = 0 To 35 Step 1
			ReDim $VarsButtonArray[UBound($VarsButtonArray) + 1]
			if $I <> 2 and $I <> 18 and $I <> 19 and $I <> 20 and $I <> 21 and $I <> 22 and $I <> 23 and $I <> 24 and $I <> 28 and $I <> 29 and $I <> 35 Then
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
DrawButtonsAndInputs()


;- PROGRAM FUNCTIONS
;----------------------------------------------------------------------------


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
   Local $SMITEEngineIniPathArray, $SMITEBattleSystemSettingsIniPathArray
   _FileReadToArray($SMITEEngineIniPath,$SMITEEngineIniPathArray)
   _FileReadToArray($SMITEBattleSystemSettingsIniPath,$SMITEBattleSystemSettingsIniPathArray)

   For $Steps = 0 To 2 Step 1 ;- Schritte: FPS, Engine, World
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
   Next

   If FileExists($ConfigBackupPath) = 0 Then
	  DirCreate($ConfigBackupPath)
   EndIf

   if $IsSteamUser = 1 Then
	  FileMove($SMITEEngineIniPath,$ConfigBackupPath&"\DefaultEngine "&@MON&"."&@MDAY&"."&@YEAR&" - "&@HOUR&"."&@MIN&".ini")
	  FileMove($SMITEBattleSystemSettingsIniPath,$ConfigBackupPath&"\DefaultSystemSettings "&@MON&"."&@MDAY&"."&@YEAR&" - "&@HOUR&"."&@MIN&".ini")

	  _FileWriteFromArray($SMITEEngineIniPath,$SMITEEngineIniPathArray,1)
	  _FileWriteFromArray($SMITEBattleSystemSettingsIniPath,$SMITEBattleSystemSettingsIniPathArray,1)
   Else
	  FileMove($SMITEEngineIniPath,$ConfigBackupPath&"\BattleEngine "&@MON&"."&@MDAY&"."&@YEAR&" - "&@HOUR&"."&@MIN&".ini")
	  FileMove($SMITEBattleSystemSettingsIniPath,$ConfigBackupPath&"\BattleSystemSettings "&@MON&"."&@MDAY&"."&@YEAR&" - "&@HOUR&"."&@MIN&".ini")

	  _FileWriteFromArray($SMITEEngineIniPath,$SMITEEngineIniPathArray,1)
	  _FileWriteFromArray($SMITEBattleSystemSettingsIniPath,$SMITEBattleSystemSettingsIniPathArray,1)
   EndIf

   MsgBox(0,"Success!","Applied changes successfully.")
EndFunc


Func GUIDisplay($Var)
   Local $TempVar
   If $Var = 1 Then
	  Global $EditBoxGUI = GUICreate("Changelog",600,420,-3,-63,-1,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$MainGUI)
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, 600, 400,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
		 GUICtrlSetData(-1, _Resource_GetAsString("ChangelogText"))
	  GUISetState()
   EndIf
   If $Var = 2 Then
	  Global $EditBoxGUI = GUICreate("Copyright and Credits",600,420,-3,-63,-1,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$MainGUI)
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, 600, 400,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
		 GUICtrlSetData(-1, _Resource_GetAsString("CopyrightCreditsText"))
	  GUISetState()
   EndIf
   If $Var = 3 Then
	  Global $EditBoxGUI = GUICreate("Restore old configs",600,420,-3,-63,-1,BitOr($WS_EX_TOOLWINDOW,$WS_EX_MDICHILD),$MainGUI)
	  Global $EditBoxGUIList = GUICtrlCreateList("",5,5,590,380)
		 $TempVar = _FileListToArray($ConfigBackupPath,"*",1)
		 For $I = 0 To UBound($TempVar)-1 Step 1
			_GUICtrlListBox_AddString ($EditBoxGUIList, $TempVar[$I])
		 Next
	  Global $EditBoxGUIButtonRestore = GUICtrlCreateButton("Restore",470,380,125,35)
	  Global $EditBoxGUILabelHowTo = GUICtrlCreateLabel("Choose a date and time and restore BattleEngine and BattleSystemSettings.",5,400,450,35)
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
	  Global $EditBoxGUI = GUICreate("Help - Program Functions",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
		 GUICtrlSetData(-1, _Resource_GetAsString("RestoringConfigurationHelp"))
	  GUISetState()
   EndIf
   If $Var = 7 Then
	  Global $EditBoxGUI = GUICreate("Help - Program Functions",@DesktopWidth-400,@DesktopHeight-200,-1,-1,-1,$WS_EX_TOOLWINDOW)
	  Global $EditBoxGUIEdit = GUICtrlCreateEdit("", 0, 0, @DesktopWidth-400, @DesktopHeight-200,BitOr(2048,$WS_HSCROLL,$WS_VSCROLL)) ;- 2048 = $ES_READONLY
		 GUICtrlSetData(-1, _Resource_GetAsString("VariableExplanationHelp"))
	  GUISetState()
   EndIf
EndFunc


Func CloseCGGUI()
   GUIDelete($EditBoxGUI)
   $EditBoxGUI = 0
   If isDeclared("EditBoxGUIButtonRestore") = 1 Then
	  $EditBoxGUIButtonRestore = 2
   EndIf
   If isDeclared("EditBoxGUIButtonHelp1") = 1 Then
	  $EditBoxGUIButtonHelp1 = 2
	  $EditBoxGUIButtonHelp2 = 2
	  $EditBoxGUIButtonHelp3 = 2
   EndIf
   GUISetState(@SW_ENABLE,$MainGUI)
   WinActivate($MainGUI)
EndFunc


;----------------------------------------------------------------------------

While 1
   if $EditBoxGUI = 0 Then
	  Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE, $MenuExit
			Exit

		 Case $MenuRedditLink
			ShellExecute("http://www.reddit.com/r/SRGG/new")
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
			elseif GUICtrlRead($MainGUICheckboxUseRecommendedSettings) = 4 Then
			   For $I = 0 To Ubound($VarsButtonArray)-1 Step 1
				  GUICtrlDelete($VarsButtonArray[$I])
			   Next
			   For $I = 0 To Ubound($VarsInputArray)-1 Step 1
				  GUICtrlDelete($VarsInputArray[$I])
			   Next
			   GUICtrlSetState($CheckboxApplyFPSSettings,4)
			   GUICtrlSetState($CheckboxApplyEngineSettings,4)
			   DrawButtonsAndInputs()
			EndIf
		 Case $MainGUIApplySettings
			ApplySettings()
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
			Case $GUI_EVENT_CLOSE, $MenuExit
			   CloseCGGUI()
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
					 MsgBox(0,"Done","Restored successfully.")
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
					 MsgBox(0,"Done","Restored successfully.")
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