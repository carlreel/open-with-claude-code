# 安装右键菜单: 在此文件夹中打开 Claude Code
# 只写入当前用户注册表 (HKCU), 无需管理员权限

$ErrorActionPreference = 'Stop'

$label = '在此文件夹中打开 Claude Code'
$icon  = "$env:SystemRoot\System32\cmd.exe"

# ---- 1) 文件夹空白处右键 ----
$bg = 'HKCU:\Software\Classes\Directory\Background\shell\ClaudeCode'
New-Item -Path $bg -Force | Out-Null
New-Item -Path "$bg\command" -Force | Out-Null
Set-ItemProperty -Path $bg -Name '(Default)' -Value $label
Set-ItemProperty -Path $bg -Name 'Icon' -Value $icon
Set-ItemProperty -Path "$bg\command" -Name '(Default)' -Value 'cmd.exe /k cd /d "%V" && claude'

# ---- 2) 文件夹图标右键 ----
$dir = 'HKCU:\Software\Classes\Directory\shell\ClaudeCode'
New-Item -Path $dir -Force | Out-Null
New-Item -Path "$dir\command" -Force | Out-Null
Set-ItemProperty -Path $dir -Name '(Default)' -Value $label
Set-ItemProperty -Path $dir -Name 'Icon' -Value $icon
Set-ItemProperty -Path "$dir\command" -Name '(Default)' -Value 'cmd.exe /k cd /d "%1" && claude'

Write-Host ""
Write-Host "安装完成! 现在可以:" -ForegroundColor Green
Write-Host "  1. 在任意文件夹的空白处右键 -> ""$label"""
Write-Host "  2. 或右键文件夹图标 -> ""$label"""
Write-Host ""
Write-Host "提示: Windows 11 若在右键菜单里没看到, 请点菜单底部 ""显示更多选项"" (或按 Shift+F10)"
Write-Host ""
