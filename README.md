# SMITE-Optimizer

A simple and lightweight program to easily change the configuration files for [SMITE](https://www.smitegame.com/) PC on windows.

<img align="center" src="https://i.imgur.com/MHnpb0L.png" />

## License

This program is licensed under the **GNU General Public License v3.0**. [Click here for more info](https://github.com/MeteorTheLizard/SMITE-Optimizer/blob/master/LICENSE).

Earlier versions than V1.3 do **NOT** fall under this license and therefor may not be copied, shared, modified or distributed.

Contact: MrRangerLP@gmx.de

## How to install

- Head over to the [releases](https://github.com/MeteorTheLizard/SMITE-Optimizer/releases) page and download the latest corresponding .exe file for your system. If you are running a 32bit version of windows, download the 32bit version of the SMITE Optimizer. If you're using a 64bit version of windows, download the 64bit version of the SMITE Optimizer.

## Using the program

- After having downloaded the executeable you can put it anywhere you want.
- Launch the program. If this is your first time running the program it should now take you through the configuration discovery. Simply follow the steps provided by the program to complete this step.
- After the program has discovered where your games' configuration files are located, you may start changing things. If you're unsure about each individual option, it is recommended to use the recommended settings. Simply check the bottom right checkbox saying "use recommended settings" and hit "apply settings". After the program has successfully completed this step, you are good to go.
 
 ## Bug Reporting
 
 You may create an **issue** on the [issues](https://github.com/MeteorTheLizard/SMITE-Optimizer/issues) page to report a bug.
 You may suggest features there as well.
 
 **Remember to describe your issue as good as you can, including screenshots or short recordings of your issue helps greatly.**
 
 ## Supporting the project
 
 If you feel generous or the need to give something in return, you can either contribute to the project by improving the code and creating **pull requests** or by [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=2NKTRNN5BTHHG), alternatively we also have a [patreon](https://www.patreon.com/SMITEOptimizer)!
 
 Any kind of support is greatly appreciated!
 
 ## Compiling the Source.au3
 
[Get AutoIt Here](https://www.autoitscript.com/site/autoit-script-editor/downloads/)
 
If you downloaded a version earlier than **V1.3** you have to manually download the ResourceEx.au3 include and put it into your autoit/includes folder. After that, everything should work just fine.

If your version of the SMITE Optimizer came with said include, you still have to install it manually in your autoit/includes folder in order to be able to compile the executable.
 
 ## FAQ (Ported from reddit /r/SMITEOptimizer)
 Q: Is it safe to use this program?

* A: Yes, as stated by HiRez [here](https://www.reddit.com/r/Smite/comments/3dxx60/small_but_effective_performance_tweaksfix/cta21vi/) "You will not get banned for editing the INI's ever", and that is all this program does.

Q: I used the recommended settings and the god models look weird (Thanks to /u/TheGloriousFire)

* A: That's because **SkeletalMeshLODBias** and **StaticMeshLODBias** are not set to **0** on the recommended settings. Set both of those value to 0 to fix this.

Q: A lot of particles are missing, like ability effects and so on.

* A: That is a side effect, since we are limiting the particles and decals that can be displayed, i can't remember exactly what variables cause this but it is fixable.

Q: When i start the program windows tells me it is not safe to use.

* A: That is because the file is not signed, windows treats every unsigned .exe file from a different computer as potentially harmful. Unfortunately i do not have the ability to sign AutoIt scripts.

Q: My Antivirus says this program is potentially harmful or a virus.

* A: A common problem with AutoIt scripts, please go [here (outdated link)]() to report this problem to me. I will then get in contact with the Antivirus provider.

Q: The game no longer starts after optimizing it.

* A: Your game config files are corrupt. Open the launcher > Click on the gear > clear game settings. Start the game, close it. Re-optimize. And everything should work again. (Alternatively you can use the In-built feature to restore your configurations, however optimizations won't work)
