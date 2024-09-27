@echo off
:: V1.16

:: Release under the GNU GPL V3


::# elevate with native shell by AveYo
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
title Debloat - A bloatware removal tool made in batch by Cramaboule

Set noreboot=%1

cls & echo ======================
echo Remove dirt in Start Menu and do some tweaks
echo ====================== & echo.
for /f %%a in ('REG QUERY HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount /s /k /f placeholdertilecollection') do (reg delete %%a\current /VA /F 2> nul)
REG add HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f 2> nul
:: Show file extensions
REG add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "HideFileExt" /t REG_DWORD /d 0 /f 2> nul
:: Enable Get Latest Updates as soon as available
REG add HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v "IsContinuousInnovationOptedIn" /t REG_DWORD /d 1 /f 2> nul
:: Enable Num Lock
REG add "HKU\.DEFAULT\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 2 /f 2> nul
:: Enable End Task on Taskbar
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings /v TaskbarEndTask /t REG_DWORD /d 1 /f
:: Disable password expire
wmic UserAccount set PasswordExpires=False
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
powershell -command "(\"Microsoft.549981C3F5F10\", \"Microsoft.MicrosoftEdge.Stable\", \"Clipchamp.Clipchamp\", \"Microsoft.MicrosoftSolitaireCollection\", \"Microsoft.BingNews\", \"Microsoft.BingWeather\", \"Microsoft.GamingApp\", \"Microsoft.GetHelp\", \"Microsoft.Getstarted\", \"Microsoft.MicrosoftOfficeHub\", \"Microsoft.People\", \"Microsoft.PowerAutomateDesktop\", \"Microsoft.Todos\", \"Microsoft.WindowsAlarms\", \"Microsoft.WindowsCamera\", \"Microsoft.windowscommunicationsapps\", \"Microsoft.WindowsFeedbackHub\", \"Microsoft.WindowsMaps\", \"Microsoft.WindowsSoundRecorder\", \"Microsoft.WindowsTerminal\", \"Microsoft.Xbox.TCUI\", \"Microsoft.XboxGameOverlay\", \"Microsoft.XboxGamingOverlay\", \"Microsoft.XboxIdentityProvider\", \"Microsoft.XboxSpeechToTextOverlay\", \"Microsoft.YourPhone\", \"Microsoft.ZuneMusic\", \"Microsoft.ZuneVideo\", \"MicrosoftCorporationII.QuickAssist\", \"MicrosoftWindows.Client.WebExperience\", \"MicrosoftTeams\", \"Microsoft.LanguageExperiencePackfr-FR\", \"MicrosoftCorporationII.MicrosoftFamily\", \"Microsoft.MicrosoftStickyNotes\").ForEach{write-host $_ ; Get-AppxPackage -AllUsers -Name $_ | Remove-AppxPackage -AllUsers ; Get-AppxProvisionedPackage -online | where-object PackageName -like $_ | Remove-AppxProvisionedPackage -online}" 2> nul

:: Remove Office 365 Preinstalled. Setup.exe is part of officedeploymenttool_17830-20162.exe
start /Wait %~dp0setup.exe /configure %~dp0uninstall.xml

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
call :WingetUninstall Microsoft.Todos_8wekyb3d8bbwe Microsoft_TO_Do
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

IF /I NOT [%noreboot%] EQU [noreboot] (
	cls
	CHOICE /c YN /M "Do you want to reboot now"
	IF %ERRORLEVEL% == 1 (shutdown -r -f -t 00)
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
-----END CERTIFICATE-----
