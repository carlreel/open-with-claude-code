@echo off
chcp 65001 >nul
rem One-click toggle: install / uninstall the "Open Claude Code in Tabby" right-click menu
rem Double-click = toggle (installed -> uninstall, not installed -> install)
rem Optional args: install | uninstall
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0toggle.ps1" %*
pause
