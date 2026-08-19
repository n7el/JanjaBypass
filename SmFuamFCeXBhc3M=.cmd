@echo off
chcp 65001 >nul
title vsfd janja kkkkkk
setlocal enabledelayedexpansion

echo Bypassing...

taskkill /F /IM Discord.exe >nul 2>&1
taskkill /F /IM DiscordPTB.exe >nul 2>&1
taskkill /F /IM DiscordCanary.exe >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "181.39.25.196:8118" /f >nul

set "FOUND_ANY="

if exist "%LOCALAPPDATA%\Discord\Update.exe" (
    start "" "%LOCALAPPDATA%\Discord\Update.exe" --processStart Discord.exe
    set "FOUND_ANY=1"
)
if exist "%LOCALAPPDATA%\DiscordCanary\Update.exe" (
    start "" "%LOCALAPPDATA%\DiscordCanary\Update.exe" --processStart DiscordCanary.exe
    set "FOUND_ANY=1"
)
if exist "%LOCALAPPDATA%\DiscordPTB\Update.exe" (
    start "" "%LOCALAPPDATA%\DiscordPTB\Update.exe" --processStart DiscordPTB.exe
    set "FOUND_ANY=1"
)

if not defined FOUND_ANY (
    goto FINALIZAR
)

:VERIFICACAO
timeout /t 1 /nobreak >nul

for /f "usebackq tokens=*" %%A in (`powershell -NoProfile -Command "$names = @('Discord','DiscordCanary','DiscordPTB'); $running = Get-Process -Name $names -ErrorAction SilentlyContinue; if (-not $running) { 'READY' } else { $ready = $running | Where-Object { $_.MainWindowTitle -and $_.MainWindowTitle -notmatch 'Update|Updater' }; if ($ready) { 'READY' } else { 'WAIT' } }"`) do set "STATUS=%%A"

if not "!STATUS!"=="READY" (
    goto VERIFICACAO
)

:FINALIZAR
timeout /t 1 /nobreak >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul

powershell -NoProfile -Command "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null; $found = Get-StartApps | Where-Object { $_.Name -match 'Discord' -or $_.AppID -match 'Discord' } | Select-Object -First 1; $appId = if ($found) { $found.AppID } else { 'com.squirrel.Discord.Discord' }; $tmpl = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02); $t = $tmpl.GetElementsByTagName('text'); $t.Item(0).AppendChild($tmpl.CreateTextNode('Bypass Concluído^!')) | Out-Null; $t.Item(1).AppendChild($tmpl.CreateTextNode('Será necessário aplicar o bypass novamente após fechar o Discord para reativar as funções.')) | Out-Null; $toast = [Windows.UI.Notifications.ToastNotification]::new($tmpl); [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show($toast);"

endlocal