@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-RightClick-Menu.ps1"
if errorlevel 1 (
    echo [ERROR] Installation failed. Check the message above.
    pause
    exit /b 1
)
pause
