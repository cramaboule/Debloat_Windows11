@echo off
:: V1.6


::# elevate with native shell by AveYo
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)
title Debloat - A bloatware removal tool made in batch by Cramaboule

cls & echo ======================
echo Remove dirt in Start Menu and do some tweaks
echo ====================== & echo.
for /f %%a in ('REG QUERY HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount /s /k /f placeholdertilecollection') do (reg delete %%a\current /VA /F 2> nul)
REG add HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f 2> nul
:: Show file extensions
REG add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "HideFileExt" /t REG_DWORD /d 0 /f 2> nul
:: Enable Get Latest Updates as soon as available
REG add HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v "IsContinuousInnovationOptedIn" /t REG_DWORD /d 1 /f 2> nul

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
:: Make you own start2.bin if you wish as explain here: https://superuser.com/a/1690893/996827
xcopy "%~dp0start2.bin" "C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" /y 2> nul
xcopy "%~dp0start2.bin" "%LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" /y 2> nul
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

::installing dependies and Winget
:: check if Winget is already installed
winget -v 2> nul
IF %ERRORLEVEL% NEQ 0 (
	powershell -command "$ProgressPreference = 'SilentlyContinue' ; write-host "Downloading and Installing dependies" ; Invoke-WebRequest -Uri  https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile .\Microsoft.VCLibs.x64.14.00.Desktop.appx ; Invoke-WebRequest -Uri  https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile .\microsoft.ui.xaml.2.7.3.nupkg.zip ; Expand-Archive -Path .\microsoft.ui.xaml.2.7.3.nupkg.zip -Force ; Add-AppXPackage -Path .\microsoft.ui.xaml.2.7.3.nupkg\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx; Add-AppXPackage -Path .\Microsoft.VCLibs.x64.14.00.Desktop.appx ; write-host "Installing Winget" ;  Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.7.10582/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile .\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle ; Add-AppXPackage -Path .\MicrosoftDesktopAppInstaller_8wekyb3d8bbwe.msixbundle" 2> nul
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

echo OneDrive
TASKKILL /f /im OneDrive.exe 2>nul
%systemroot%\System32\OneDriveSetup.exe /uninstall 2> nul
%systemroot%\SysWOW64\OneDriveSetup.exe /uninstall 2> nul
powershell -command "(\"Microsoft.549981C3F5F10\", \"Microsoft.MicrosoftEdge.Stable\", \"Clipchamp.Clipchamp\", \"Microsoft.MicrosoftSolitaireCollection\", \"Microsoft.BingNews\", \"Microsoft.BingWeather\", \"Microsoft.GamingApp\", \"Microsoft.GetHelp\", \"Microsoft.Getstarted\", \"Microsoft.MicrosoftOfficeHub\", \"Microsoft.People\", \"Microsoft.PowerAutomateDesktop\", \"Microsoft.Todos\", \"Microsoft.WindowsAlarms\", \"Microsoft.WindowsCamera\", \"Microsoft.windowscommunicationsapps\", \"Microsoft.WindowsFeedbackHub\", \"Microsoft.WindowsMaps\", \"Microsoft.WindowsSoundRecorder\", \"Microsoft.WindowsTerminal\", \"Microsoft.Xbox.TCUI\", \"Microsoft.XboxGameOverlay\", \"Microsoft.XboxGamingOverlay\", \"Microsoft.XboxIdentityProvider\", \"Microsoft.XboxSpeechToTextOverlay\", \"Microsoft.YourPhone\", \"Microsoft.ZuneMusic\", \"Microsoft.ZuneVideo\", \"MicrosoftCorporationII.QuickAssist\", \"MicrosoftWindows.Client.WebExperience\", \"MicrosoftTeams\", \"Microsoft.LanguageExperiencePackfr-FR\", \"MicrosoftCorporationII.MicrosoftFamily\", \"Microsoft.MicrosoftStickyNotes\").ForEach{write-host $_ ; Get-AppxPackage -AllUsers -Name $_ | Remove-AppxPackage -AllUsers ; Get-AppxProvisionedPackage -online | where-object PackageName -like $_ | Remove-AppxProvisionedPackage -online}" 2> nul

cls & echo ======================
echo Remove packages segond stage. Please Wait...
echo ====================== & echo.
winget -v
echo.
::Cortana
winget uninstall cortana --accept-source-agreements --silent

::Skype
winget uninstall skype --accept-source-agreements --silent

::Camera
winget uninstall Microsoft.WindowsCamera_8wekyb3d8bbwe --accept-source-agreements --silent

::Sketch
::winget uninstall Microsoft.ScreenSketch_8wekyb3d8bbwe --accept-source-agreements --silent

::Xbox Applications
winget uninstall Microsoft.GamingApp_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.XboxApp_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.Xbox.TCUI_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.XboxIdentityProvider_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.XboxGamingOverlay_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.XboxGameOverlay_8wekyb3d8bbwe --accept-source-agreements --silent

::Groove Music
winget uninstall Microsoft.ZuneMusic_8wekyb3d8bbwe --accept-source-agreements --silent

::Feedback Hub
winget uninstall Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe --accept-source-agreements --silent

::Microsoft-Tips...
winget uninstall Microsoft.Getstarted_8wekyb3d8bbwe --accept-source-agreements --silent

::3D Viewer
winget uninstall 9NBLGGH42THS --accept-source-agreements --silent

:: 3D Builder
winget uninstall Microsoft.3DBuilder_8wekyb3d8bbwe --accept-source-agreements --silent

::MS Solitaire
winget uninstall Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe --accept-source-agreements --silent

::Paint-3D
winget uninstall 9NBLGGH5FV99 --accept-source-agreements --silent

::Weather 
winget uninstall Microsoft.BingWeather_8wekyb3d8bbwe --accept-source-agreements --silent

::Mail / Calendar
winget uninstall microsoft.windowscommunicationsapps_8wekyb3d8bbwe --accept-source-agreements --silent

::Your Phone
winget uninstall Microsoft.YourPhone_8wekyb3d8bbwe --accept-source-agreements --silent

::People
winget uninstall Microsoft.People_8wekyb3d8bbwe --accept-source-agreements --silent

::MS Pay 
winget uninstall Microsoft.Wallet_8wekyb3d8bbwe --accept-source-agreements --silent

::MS Maps
winget uninstall Microsoft.WindowsMaps_8wekyb3d8bbwe --accept-source-agreements --silent

::OneNote
winget uninstall Microsoft.Office.OneNote_8wekyb3d8bbwe --accept-source-agreements --silent

::MS Office
winget uninstall Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe --accept-source-agreements --silent

::Voice Recorder
winget uninstall Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe --accept-source-agreements --silent

::Movies & TV
winget uninstall Microsoft.ZuneVideo_8wekyb3d8bbwe --accept-source-agreements --silent

::Mixed Reality-Portal
winget uninstall Microsoft.MixedReality.Portal_8wekyb3d8bbwe --accept-source-agreements --silent

::Sticky Notes...
winget uninstall Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe --accept-source-agreements --silent

::Get Help
winget uninstall Microsoft.GetHelp_8wekyb3d8bbwe --accept-source-agreements --silent

::OneDrive
winget uninstall Microsoft.OneDrive --accept-source-agreements --silent

::Calculator
:: winget uninstall Microsoft.WindowsCalculator_8wekyb3d8bbwe --accept-source-agreements --silent

::Outlook for Microsoft
winget uninstall Microsoft.OutlookForWindows_8wekyb3d8bbwe --accept-source-agreements --silent


::Windows 11 Bloatware
:: Different games
winget uninstall 26720RandomSaladGamesLLC.3899848563C1F_kx24dqmazqk8j --accept-source-agreements --silent
winget uninstall 26720RandomSaladGamesLLC.Spades_kx24dqmazqk8j --accept-source-agreements --silent
winget uninstall Google.PlayGames.Beta --accept-source-agreements --silent
winget uninstall AD2F1837.OMENCommandCenter_v10z8vjag6ke6 --accept-source-agreements --silent
:: Outlook for Windows
winget uninstall Microsoft.OutlookForWindows_8wekyb3d8bbwe --accept-source-agreements --silent
:: Messages opérateur Windows
winget uninstall Microsoft.Messaging_8wekyb3d8bbwe --accept-source-agreements --silent
:: print 3D
winget uninstall Microsoft.Print3D_8wekyb3d8bbwe --accept-source-agreements --silent
:: One Connect
winget uninstall Microsoft.OneConnect_8wekyb3d8bbwe --accept-source-agreements --silent
::Microsoft TO Do
winget uninstall Microsoft.Todos_8wekyb3d8bbwe --accept-source-agreements --silent
::Power Automate
winget uninstall Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe --accept-source-agreements --silent
::Bing News
winget uninstall Microsoft.BingNews_8wekyb3d8bbwe --accept-source-agreements --silent
::Microsoft Teams
winget uninstall MicrosoftTeams_8wekyb3d8bbwe --accept-source-agreements --silent
::Microsoft Family
winget uninstall MicrosoftCorporationII.MicrosoftFamily_8wekyb3d8bbwe --accept-source-agreements --silent
::Quick Assist
winget uninstall MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe --accept-source-agreements --silent
::Power Automate
winget uninstall Microsoft.DevHome --accept-source-agreements --silent
::Microsoft Whiteboard
winget uninstall Microsoft.Whiteboard_8wekyb3d8bbwe --accept-source-agreements --silent
::Third-Party Preinstalled bloat
:: Disney+
winget uninstall disney+ --accept-source-agreements --silent
:: LinkedIn
winget uninstall 7EE7776C.LinkedInforWindows_w1wdnht996qgy --accept-source-agreements --silent
:: Camo Studio
winget uninstall ReincubateLtd.CamoStudio_9bq3v28c93p4r --accept-source-agreements --silent
::Dropbox - offre promotionnelle
winget uninstall C27EB4BA.DropboxOEM_xbfy0k16fey96 --accept-source-agreements --silent
::Clipchamp
winget uninstall Clipchamp.Clipchamp_yxz26nhyzhsrt --accept-source-agreements --silent
::WhatsApp
winget uninstall 5319275A.WhatsAppDesktop_cv1g1gvanyjgm --accept-source-agreements --silent
::Spotify Music
winget uninstall SpotifyAB.SpotifyMusic_zpdnekdrzrea0 --accept-source-agreements --silent
::Microsoft Store
::winget uninstall Microsoft.WindowsStore_8wekyb3d8bbwe --accept-source-agreements --silent
:: Other stuff
::winget uninstall Microsoft.HEVCVideoExtension_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.LanguageExperiencePackfr-FR_8wekyb3d8bbwe --accept-source-agreements --silent
::winget uninstall Microsoft.RawImageExtension_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.StorePurchaseApp_8wekyb3d8bbwe --accept-source-agreements --silent
::winget uninstall Microsoft.VP9VideoExtensions_8wekyb3d8bbwe --accept-source-agreements --silent
::winget uninstall Microsoft.WebMediaExtensions_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.WindowsAlarms_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall Microsoft.WindowsCamera_8wekyb3d8bbwe --accept-source-agreements --silent
winget uninstall MicrosoftWindows.Client.WebExperiencecw5n1h2txyewy --accept-source-agreements --silent
:: PC Health tool
winget uninstall {6A2A8076-135F-4F55-BB02-DED67C8C6934} --accept-source-agreements --silent
:: Microsoft Update Health Tool
winget uninstall {80F1AF52-7AC0-42A3-9AF0-689BFB271D1D} --accept-source-agreements --silent

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


cls
CHOICE /c YN /M "Do you want to reboot now"
if %ERRORLEVEL% == 1 (shutdown -r -f -t 00)

cls & echo Done. Thank you for using this tool. ==== Reboot is recommended ====& echo. 
pause
exit
