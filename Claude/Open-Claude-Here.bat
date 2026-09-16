@echo off
chcp 65001 >nul
setlocal

rem ============================================================
rem  快捷启动 Claude Code (便携版)
rem  用法:
rem    1. 双击本文件 -> 在它所在的文件夹打开 Claude Code
rem    2. 把一个文件夹/文件拖到本文件图标上 -> 在那个文件夹打开
rem ============================================================

set "TARGET=%~dp0"
if not "%~1"=="" set "TARGET=%~1"

rem 如果拖进来的是一个文件, 则定位到它所在的文件夹
if not exist "%TARGET%\" (
    for %%F in ("%TARGET%") do set "TARGET=%%~dpF"
)

cd /d "%TARGET%" >nul 2>&1
if errorlevel 1 (
    echo [错误] 无法进入文件夹: %TARGET%
    pause
    exit /b 1
)

where claude >nul 2>&1
if errorlevel 1 (
    echo [错误] 找不到 claude 命令, 请先安装:
    echo        npm install -g @anthropic-ai/claude-code
    pause
    exit /b 1
)

echo 正在启动 Claude Code: %TARGET%
claude %*
if errorlevel 1 (
    echo.
    echo Claude 已退出 (代码 %errorlevel%)
    pause
)
