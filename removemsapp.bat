@echo off
:: V1.23

:: Release under the GNU GPL V3

setlocal EnableDelayedExpansion

::# self elevate with native shell by AveYo
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
title Debloat - A bloatware removal tool made in batch by Cramaboule

Set param1=%1
Set param2=%2
Set Temp2=0
Set Temp1=0

IF /I [%param1%] EQU [noreboot] Set "Temp2=1"
IF /I [%param2%] EQU [noreboot] Set "Temp2=1"

IF /I [%param1%] EQU [restarted] Set "Temp1=1"
IF /I [%param2%] EQU [restarted] Set "Temp1=1"

cd "%~dp0"
IF %Temp1% NEQ 1 (
	echo uninstall Terminal
	powershell -command "Get-AppxPackage -AllUsers -Name Microsoft.WindowsTerminal | Remove-AppxPackage -AllUsers ; Get-AppxProvisionedPackage -online | where-object PackageName -like Microsoft.WindowsTerminal | Remove-AppxProvisionedPackage -online" 2> nul
	IF %Temp2% EQU 1 (
	start %~nx0 restarted noreboot
	exit
	) ELSE (
	start %~nx0 restarted
	exit
	)
)

cls & echo ======================
echo Remove dirt in Start Menu and do some tweaks
echo ====================== & echo.
for /f %%a in ('REG QUERY HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount /s /k /f placeholdertilecollection') do (reg delete %%a\current /VA /F 2> nul)
:: Disable Get Even More Out of Windows
REG add HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f 2> nul
:: Disable bitlocker
REG add HKLM\SOFTWARE\Policies\Microsoft\Windows\EnhancedStorageDevices /v "TCGSecurityActivationDisabled" /t REG_DWORD /d 1 /f 2> nul
REG add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\BitLocker /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f 2> nul
:: Show file extensions
REG add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "HideFileExt" /t REG_DWORD /d 0 /f 2> nul
:: Enable Get Latest Updates as soon as available
REG add HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v "IsContinuousInnovationOptedIn" /t REG_DWORD /d 1 /f 2> nul
:: Enable Num Lock
REG add "HKU\.DEFAULT\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 2 /f 2> nul
:: Enable End Task on Taskbar
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings /v TaskbarEndTask /t REG_DWORD /d 1 /f
:: Disable password expire
net accounts /maxpwage:unlimited
:: do not put screen and pc to sleep
powercfg /change monitor-timeout-ac 0 2> nul
powercfg /change monitor-timeout-dc 0 2> nul
powercfg /change standby-timeout-ac 0 2> nul
powercfg /change standby-timeout-dc 0 2> nul

echo.
echo ======================
echo Changing Menu, TaskBar and Start Menu...
echo ====================== & echo.

reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "TaskbarAl" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "TaskbarMn" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "TaskbarDa" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Search /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f 2> nul
reg add HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /ve /d "" /f 2> nul
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v "LegacyDefaultPrinterMode" /t REG_DWORD /d 1 /f 2> nul

:: Make you own start2.bin if you wish as explain here: https://superuser.com/a/1690893/996827
certutil -decode %0 "%~dp0start2.bin"
xcopy "%~dp0start2.bin" "C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" /y 2> nul
xcopy "%~dp0start2.bin" "%LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" /y 2> nul
del "%~dp0start2.bin"

del C:\Users\Public\Desktop\* /F /Q
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" 2> nul
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\ /F /V FavoritesResolve /T REG_BINARY /D 3b0300004c0000000114020000000000c0000000000000468300800020000000bc8b6c93ad01da01db547a93ad01da015cf4e1fbd161d801970100000000000001000000000000000000000000000000a0013a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000009d8db41e3e00da013b645d4e3e00da0181c27393ad01da01140056003100000000005257535311005461736b42617200400009000400efbe5057b374525753532e000000d2a301000000010000000000000000000000000000007f4042005400610073006b00420061007200000016000e01320097010000a754662a200046494c4545587e312e4c4e4b00007c0009000400efbe52575353525753532e000000fc4e0100000008000000000000000000520000000000a413a200460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00220000001e00efbe02005500730065007200500069006e006e006500640000001c00120000002b00efbedb547a93ad01da011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c000000a40000001c000000010000001c0000002d00000000000000a30000001100000003000000d17dbc801000000000433a5c55736572735c41646d696e6973747261746f725c417070446174615c526f616d696e675c4d6963726f736f66745c496e7465726e6574204578706c6f7265725c517569636b204c61756e63685c557365722050696e6e65645c5461736b4261725c46696c65204578706c6f7265722e6c6e6b000060000000030000a058000000000000006465736b746f702d7665683134727500620c54cc7cd9604cbd73b8c13a208843778f36218c6dee11a20e080027a38204620c54cc7cd9604cbd73b8c13a208843778f36218c6dee11a20e080027a3820445000000090000a03900000031535053b1166d44ad8d7048a748402ea43d788c1d000000680000000048000000b6d08a154cd49a4192b0f918a2e54d95000000000000000000000000 2> nul
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\ /F /V Favorites /T REG_BINARY /D 00a00100003a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000009d8db41e3e00da013b645d4e3e00da0181c27393ad01da01140056003100000000005257535311005461736b42617200400009000400efbe5057b374525753532e000000d2a301000000010000000000000000000000000000007f4042005400610073006b00420061007200000016000e01320097010000a754662a200046494c4545587e312e4c4e4b00007c0009000400efbe52575353525753532e000000fc4e0100000008000000000000000000520000000000a413a200460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00220000001e00efbe02005500730065007200500069006e006e006500640000001c00120000002b00efbedb547a93ad01da011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c000000ff 2> nul
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\ /V FavoritesChanges /T REG_QWORD /D 1 /F 2> nul
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\ /V FavoritesVersion /T REG_QWORD /D 3 /F 2> nul
taskkill /f /im explorer.exe & start explorer.exe 2> nul

echo ======================
echo Install winget
echo ====================== & echo.

rem installing dependies and Winget
rem check if Winget is already installed
FOR /F %%g IN ('winget -v') do (SET version=%%g)
echo %version%
SET "result=%version:~1%"
SET minwingetversion=1.7
if %result% LEQ %minwingetversion% (
	call :InstallWinget
)

cls & echo ======================
echo Remove packages first stage. Please Wait...
echo ====================== & echo.

::Prevents bloatware applications from returning and removes Start Menu suggestions               
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "ContentDeliveryAllowed" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "PreInstalledAppsEnabled" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 1 /f 2> nul
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 1 /f 2> nul
REG DELETE HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate /VA /F
REG DELETE HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate /VA /F

echo OneDrive
TASKKILL /f /im OneDrive.exe 2>nul
%systemroot%\System32\OneDriveSetup.exe /uninstall 2> nul
%systemroot%\SysWOW64\OneDriveSetup.exe /uninstall 2> nul
powershell -command "(\"Microsoft.549981C3F5F10\", \"MSTeams\", \"Microsoft.MicrosoftEdge.Stable\", \"Clipchamp.Clipchamp\", \"Microsoft.MicrosoftSolitaireCollection\", \"Microsoft.BingNews\", \"Microsoft.BingWeather\", \"Microsoft.GamingApp\", \"Microsoft.GetHelp\", \"Microsoft.Getstarted\", \"Microsoft.MicrosoftOfficeHub\", \"Microsoft.People\", \"Microsoft.PowerAutomateDesktop\", \"Microsoft.Todos\", \"Microsoft.WindowsAlarms\", \"Microsoft.WindowsCamera\", \"Microsoft.windowscommunicationsapps\", \"Microsoft.WindowsFeedbackHub\", \"Microsoft.WindowsMaps\", \"Microsoft.WindowsSoundRecorder\", \"Microsoft.Xbox.TCUI\", \"Microsoft.XboxGameOverlay\", \"Microsoft.XboxGamingOverlay\", \"Microsoft.XboxIdentityProvider\", \"Microsoft.XboxSpeechToTextOverlay\", \"Microsoft.YourPhone\", \"Microsoft.ZuneMusic\", \"Microsoft.ZuneVideo\", \"MicrosoftCorporationII.QuickAssist\", \"MicrosoftWindows.Client.WebExperience\", \"MicrosoftTeams\", \"Microsoft.LanguageExperiencePackfr-FR\", \"MicrosoftCorporationII.MicrosoftFamily\", \"Microsoft.MicrosoftStickyNotes\").ForEach{write-host $_ ; Get-AppxPackage -AllUsers -Name $_ | Remove-AppxPackage -AllUsers ; Get-AppxProvisionedPackage -online | where-object PackageName -like $_ | Remove-AppxProvisionedPackage -online}" 2> nul

:: Remove Outlook For Windows by https://github.com/matej137/OutlookRemover
Echo Removing New Outlook For Windows
mkdir %appdata%\NewOutlook
if %PROCESSOR_ARCHITECTURE%==AMD64 copy "%~dp0AppxManifest.xml" %appdata%\NewOutlook
if %PROCESSOR_ARCHITECTURE%==x86 copy "%~dp0AppxManifestx86.xml" %appdata%\NewOutlook\AppxManifest.xml
if %PROCESSOR_ARCHITECTURE%==ARM64 copy "%~dp0AppxManifest-ARM64.xml" %appdata%\NewOutlook\AppxManifest.xml
powershell "New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1 -Force" >NUL 2>NUL
echo Uninstalling the original version (reffer to readme for errors/red text)
powershell "get-appxpackage -allusers Microsoft.OutlookForWindows | Remove-AppxPackage -allusers"
echo installing the patched one (Errors are bad now)
powershell add-appxpackage -register "'%appdata%\NewOutlook\AppxManifest.xml'"
echo done !

:: Remove Office 365 Preinstalled. Setup.exe is part of officedeploymenttool_17830-20162.exe
Echo Removing Office 365 Preinstalled
start /Wait "" /b "%~dp0setup.exe" /configure "%~dp0uninstall.xml"
echo done !
ping 127.0.0.1 -n 3 >nul 2>&1

cls & echo ======================
echo Remove packages segond stage. Please Wait...
echo ====================== & echo.
winget -v
echo.
::Cortana
call :WingetUninstall cortana Cortana

::Skype
call :WingetUninstall skype Skype

::Camera
call :WingetUninstall Microsoft.WindowsCamera_8wekyb3d8bbwe Camera

::Sketch
::call :WingetUninstall Microsoft.ScreenSketch_8wekyb3d8bbwe Sketch

::Xbox Applications
call :WingetUninstall Microsoft.GamingApp_8wekyb3d8bbwe Xbox_1/7
call :WingetUninstall Microsoft.XboxApp_8wekyb3d8bbwe Xbox_2/7
call :WingetUninstall Microsoft.Xbox.TCUI_8wekyb3d8bbwe Xbox_3/7
call :WingetUninstall Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe Xbox_4/7
call :WingetUninstall Microsoft.XboxIdentityProvider_8wekyb3d8bbwe Xbox_5/7
call :WingetUninstall Microsoft.XboxGamingOverlay_8wekyb3d8bbwe Xbox_6/7
call :WingetUninstall Microsoft.XboxGameOverlay_8wekyb3d8bbwe Xbox_7/7
::Groove Music
call :WingetUninstall Microsoft.ZuneMusic_8wekyb3d8bbwe Groove_Music

::Feedback Hub
call :WingetUninstall Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe Feedback Hub

::Microsoft-Tips
call :WingetUninstall Microsoft.Getstarted_8wekyb3d8bbwe Microsoft-Tips

:: 3D Viewer
call :WingetUninstall 9NBLGGH42THS 3D_Viewer

:: 3D Builder
call :WingetUninstall Microsoft.3DBuilder_8wekyb3d8bbwe 3D_Builder

:: MS Solitaire
call :WingetUninstall Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe MS_Solitaire

:: Paint-3D
call :WingetUninstall 9NBLGGH5FV99 Paint-3D

:: Weather 
call :WingetUninstall Microsoft.BingWeather_8wekyb3d8bbwe Weather 

:: Mail / Calendar
call :WingetUninstall microsoft.windowscommunicationsapps_8wekyb3d8bbwe Mail/Calendar

::Your Phone
call :WingetUninstall Microsoft.YourPhone_8wekyb3d8bbwe Phone

::People
call :WingetUninstall Microsoft.People_8wekyb3d8bbwe People

::MS Pay 
call :WingetUninstall Microsoft.Wallet_8wekyb3d8bbwe MS_Pay 

::MS Maps
call :WingetUninstall Microsoft.WindowsMaps_8wekyb3d8bbwe MS_Maps

::OneNote
call :WingetUninstall Microsoft.Office.OneNote_8wekyb3d8bbwe OneNote

::MS Office
call :WingetUninstall Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe MS_Office

::Voice Recorder
call :WingetUninstall Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe Voice_Recorder

::Movies & TV
call :WingetUninstall Microsoft.ZuneVideo_8wekyb3d8bbwe MoviesTV

::Mixed Reality-Portal
call :WingetUninstall Microsoft.MixedReality.Portal_8wekyb3d8bbwe Mixed_Reality-Portal

::Sticky Notes...
call :WingetUninstall Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe Sticky_Notes

::Get Help
call :WingetUninstall Microsoft.GetHelp_8wekyb3d8bbwe Get_Help

::OneDrive
call :WingetUninstall Microsoft.OneDrive OneDrive

::Calculator
:: call :WingetUninstall Microsoft.WindowsCalculator_8wekyb3d8bbwe Calculator

::Outlook for Microsoft
call :WingetUninstall Microsoft.OutlookForWindows_8wekyb3d8bbwe Outlook_for_Microsoft

::copilot
call :WingetUninstall Microsoft.Copilot_8wekyb3d8bbwe Copilot

::Windows 11 Bloatware
:: Different games
call :WingetUninstall 26720RandomSaladGamesLLC.3899848563C1F_kx24dqmazqk8j Games1
call :WingetUninstall 26720RandomSaladGamesLLC.Spades_kx24dqmazqk8j Games2
call :WingetUninstall Google.PlayGames.Beta Games3
call :WingetUninstall AD2F1837.OMENCommandCenter_v10z8vjag6ke6 Games4
:: Messages opérateur Windows
call :WingetUninstall Microsoft.Messaging_8wekyb3d8bbwe MessagesoperatorWindows
:: print 3D
call :WingetUninstall Microsoft.Print3D_8wekyb3d8bbwe print_3D
:: One Connect
call :WingetUninstall Microsoft.OneConnect_8wekyb3d8bbwe One_Connect
::Microsoft TO Do
call :WingetUninstall Microsoft.Todos_8wekyb3d8bbwe Microsoft_to_Do
::Power Automate
call :WingetUninstall Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe Power_Automate
::Bing News
call :WingetUninstall Microsoft.BingNews_8wekyb3d8bbwe Bing_News
::Microsoft Teams
call :WingetUninstall MicrosoftTeams_8wekyb3d8bbwe Microsoft_Teams
::Microsoft Family
call :WingetUninstall MicrosoftCorporationII.MicrosoftFamily_8wekyb3d8bbwe Microsoft_Family
::Quick Assist
call :WingetUninstall MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe Quick _Assist
::Dev Home
call :WingetUninstall Microsoft.DevHome Dev_Home
::Microsoft Whiteboard
call :WingetUninstall Microsoft.Whiteboard_8wekyb3d8bbwe Microsoft_Whiteboard
::Third-Party Preinstalled bloat
:: Disney+
call :WingetUninstall disney+ Disney+
:: LinkedIn
call :WingetUninstall 7EE7776C.LinkedInforWindows_w1wdnht996qgy LinkedIn
:: Camo Studio
call :WingetUninstall ReincubateLtd.CamoStudio_9bq3v28c93p4r Camo_Studio
::Dropbox - offre promotionnelle
call :WingetUninstall C27EB4BA.DropboxOEM_xbfy0k16fey96 Dropbox
::Clipchamp
call :WingetUninstall Clipchamp.Clipchamp_yxz26nhyzhsrt Clipchamp
::WhatsApp
call :WingetUninstall 5319275A.WhatsAppDesktop_cv1g1gvanyjgm WhatsApp
::Spotify Music
call :WingetUninstall SpotifyAB.SpotifyMusic_zpdnekdrzrea0 Spotify_Music
::Microsoft Store
::call :WingetUninstall Microsoft.WindowsStore_8wekyb3d8bbwe Microsoft_Store
:: Other stuff
::call :WingetUninstall Microsoft.HEVCVideoExtension_8wekyb3d8bbwe HEVCVideoExtension
call :WingetUninstall Microsoft.LanguageExperiencePackfr-FR_8wekyb3d8bbwe LanguageExperiencePackfr-FR
::call :WingetUninstall Microsoft.RawImageExtension_8wekyb3d8bbwe RawImageExtension
call :WingetUninstall Microsoft.StorePurchaseApp_8wekyb3d8bbwe StorePurchaseApp
::call :WingetUninstall Microsoft.VP9VideoExtensions_8wekyb3d8bbwe VP9VideoExtensions
::call :WingetUninstall Microsoft.WebMediaExtensions_8wekyb3d8bbwe WebMediaExtensions
call :WingetUninstall Microsoft.WindowsAlarms_8wekyb3d8bbwe Windows_Alarms
call :WingetUninstall Microsoft.WindowsCamera_8wekyb3d8bbwe Windows_Camera
call :WingetUninstall MicrosoftWindows.Client.WebExperiencecw5n1h2txyewy Web_Experience
:: PC Health tool
call :WingetUninstall {6A2A8076-135F-4F55-BB02-DED67C8C6934} PC_Health_tool
:: Microsoft Update Health Tool
call :WingetUninstall {80F1AF52-7AC0-42A3-9AF0-689BFB271D1D} Microsoft_Update_Health_Tool

:: Sometimes it is not installed
::reinstall Windows Store
wsreset -i
:: Screen Capture
winget install --id 9MZ95KL8MR0L --accept-source-agreements --silent --accept-package-agreements
::Paint
winget install --id 9PCFS5B6T72H --accept-source-agreements --silent --accept-package-agreements
::Calulator
winget install --id 9WZDNCRFHVN5 --accept-source-agreements --silent --accept-package-agreements
::Photo
winget install --id 9WZDNCRFJBH4 --accept-source-agreements --silent --accept-package-agreements
::Notepad
winget install --id 9MSMLRH6LZF3 --accept-source-agreements --silent --accept-package-agreements
:: Upgrade All
::winget upgrade --all

IF %Temp2% NEQ 1 (
	cls
	CHOICE /c YN /M "Do you want to reboot now"
	IF !ERRORLEVEL! == 1 (shutdown -r -f -t 00)
	cls & echo Done. Thank you for using this tool. ==== Reboot is recommended ====& echo. 
	pause
)

exit 0
exit /B

:InstallWinget
powershell -command $ProgressPreference = 'SilentlyContinue' ; ^
	write-host 'Downloading Winget and dependies' ; ^
	(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx', 'Microsoft.VCLibs.x64.14.00.Desktop.appx') ; ^
	(New-Object System.Net.WebClient).DownloadFile('https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3', 'microsoft.ui.xaml.2.7.3.nupkg.zip') ; ^
	(New-Object System.Net.WebClient).DownloadFile('https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle', 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle') ; ^
	write-host 'Installing Winget and dependies' ; ^
	Expand-Archive -Path '.\microsoft.ui.xaml.2.7.3.nupkg.zip' -Force ; ^
	Add-AppXPackage -Path '.\microsoft.ui.xaml.2.7.3.nupkg\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx' ; ^
	Add-AppXPackage -Path '.\Microsoft.VCLibs.x64.14.00.Desktop.appx' ; ^
	Add-AppXPackage -Path '.\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' 2> nul
exit /B

:WingetUninstall
Echo Uninstall %2
winget uninstall %1 --accept-source-agreements --silent --force --purge >nul 2>&1
exit /B

:: this is the start2.bin file.
:: make your own if you wish as explained here: https://superuser.com/a/1690893/996827
:: to encode a file: certutil -encode start2.bin start2.txt
:: to decode it: certutil -decode start2.txt start2.bin

-----BEGIN CERTIFICATE-----
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
eHWubXWfCW4ILuOI
-----END CERTIFICATE-----
