# 移除右键菜单: 在此文件夹中打开 Claude Code

$ErrorActionPreference = 'SilentlyContinue'

Remove-Item -Path 'HKCU:\Software\Classes\Directory\Background\shell\ClaudeCode' -Recurse -Force
Remove-Item -Path 'HKCU:\Software\Classes\Directory\shell\ClaudeCode' -Recurse -Force

Write-Host ""
Write-Host "已移除右键菜单 ""在此文件夹中打开 Claude Code""" -ForegroundColor Green
Write-Host ""
