#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Resource\SMITEOptimizerIcon.ico
#AutoIt3Wrapper_Outfile=ResetOptimizer.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****



	#comments-start

		This script is part of the SMITE Optimizer and licensed under the GPL-3.0 License.
		Copyright (C) 2023 - Mario "Meteor Thuri" Schien.

		Contact: MrRangerLP (at) gmx.de
		License: https://www.gnu.org/licenses/gpl-3.0.en.html


		This DevTool wipes all SMITE-Optimizer related registry entries to perform a full-reset!

		Issues:


	#comments-end



RegDelete("HKCU\Software\SMITE Optimizer\")

If @Error Then
	MsgBox(0,"Error","Could not delete registry entries for the SMITE Optimizer." & @CRLF & "Try to launch the reset tool as an administrator." & @CRLF & "The registry entries might also just not exist.")
Else
	MsgBox(0,"Success","Successfully reset the registry entries of the SMITE Optimizer!")
EndIf