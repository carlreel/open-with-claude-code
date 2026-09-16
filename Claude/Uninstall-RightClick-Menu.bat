@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Uninstall-RightClick-Menu.ps1"
if errorlevel 1 (
    echo [ERROR] Uninstall failed. Check the message above.
    pause
    exit /b 1
)
pause
