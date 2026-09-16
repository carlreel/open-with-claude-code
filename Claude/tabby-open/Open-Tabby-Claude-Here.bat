@echo off
chcp 65001 >nul
setlocal
rem Portable launcher: open this folder (or a dropped folder/file) in Tabby and auto-run claude
rem Usage 1: double-click -> open the folder this file is in
rem Usage 2: drag a folder/file onto this file -> open that folder

set "TARGET=%~dp0"
if not "%~1"=="" set "TARGET=%~1"

rem If a file was dropped, resolve to its parent folder
if not exist "%TARGET%\" (
    for %%F in ("%TARGET%") do set "TARGET=%%~dpF"
)

rem Strip trailing backslash so the URL is clean
if "%TARGET:~-1%"=="\" set "TARGET=%TARGET:~0,-1%"

echo Opening in Tabby: %TARGET%
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0open-claude.ps1" -Folder "%TARGET%"
endlocal
