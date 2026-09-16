# toggle.ps1
# 一键安装 / 卸载右键菜单「用 Tabby 打开 Claude Code」
#
# 用法:
#   无参数        -> 自动切换 (已安装则卸载, 未安装则安装)
#   -Mode install   强制安装
#   -Mode uninstall 强制卸载
#
# 安装后效果: 在任意文件夹空白处右键 (或右键文件夹图标),
#   -> 点击「用 Tabby 打开 Claude Code」,
#   Tabby 会新开一个 cmd 标签页, 自动 cd 到该文件夹并启动 claude。
#
# 只写入当前用户注册表 (HKCU), 不需要管理员权限。

param(
    [string]$Mode = ""   # "", "install", "uninstall"
)

$ErrorActionPreference = 'Stop'

$label    = '用 Tabby 打开 Claude Code'
$launcher = Join-Path $PSScriptRoot 'open-claude.ps1'

# ---- 定位 Tabby.exe (用于菜单图标, 也顺带校验已安装) ----
$icon = ""
$tabbyCandidates = @(
    "$env:LOCALAPPDATA\Programs\Tabby\Tabby.exe",
    "$env:LOCALAPPDATA\Programs\tabby\Tabby.exe",
    "$env:ProgramFiles\Tabby\Tabby.exe",
    "${env:ProgramFiles(x86)}\Tabby\Tabby.exe"
)
foreach ($c in $tabbyCandidates) {
    if (Test-Path -LiteralPath $c) { $icon = $c; break }
}
if (-not $icon) {
    $cmd = Get-Command tabby.exe -ErrorAction SilentlyContinue
    if ($cmd) { $icon = $cmd.Source }
}

# 两个入口: 文件夹空白处右键(%V) + 文件夹图标右键(%1)
$keyDefs = @(
    @{ Root = 'HKCU:\Software\Classes\Directory\Background\shell\OpenWithTabby'; FolderVar = '%V' },
    @{ Root = 'HKCU:\Software\Classes\Directory\shell\OpenWithTabby';            FolderVar = '%1' }
)

# 旧版脚本留下的键名 (tabby run 那套会崩溃, 顺带清理)
$legacyKeys = @(
    'HKCU:\Software\Classes\Directory\Background\shell\TabbyClaudeCode',
    'HKCU:\Software\Classes\Directory\shell\TabbyClaudeCode'
)

# ---- 判断当前是否已安装 ----
$installed = $false
foreach ($d in $keyDefs) {
    if (Test-Path -LiteralPath $d.Root) { $installed = $true; break }
}

# ---- 决定动作 ----
$doInstall = $false
if     ($Mode -eq 'install')   { $doInstall = $true }
elseif ($Mode -eq 'uninstall') { $doInstall = $false }
else                           { $doInstall = -not $installed }

# ---- 清理旧键名 ----
foreach ($k in $legacyKeys) {
    if (Test-Path -LiteralPath $k) { Remove-Item -LiteralPath $k -Recurse -Force }
}

# ---- 执行 ----
if ($doInstall) {
    if (-not $icon) {
        Write-Host ""
        Write-Host "找不到 Tabby.exe, 请先安装 Tabby Terminal (winget install Eugeny.Tabby)" -ForegroundColor Red
        Write-Host ""
        exit 1
    }
    if (-not (Test-Path -LiteralPath $launcher)) {
        Write-Host ""
        Write-Host "找不到 $launcher, 请确认 open-claude.ps1 与本脚本在同一文件夹" -ForegroundColor Red
        Write-Host ""
        exit 1
    }

    foreach ($d in $keyDefs) {
        $run = 'powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "' +
               $launcher + '" -Folder "' + $d.FolderVar + '"'
        New-Item -Path $d.Root -Force | Out-Null
        New-Item -Path "$($d.Root)\command" -Force | Out-Null
        Set-ItemProperty -Path $d.Root -Name '(Default)' -Value $label
        Set-ItemProperty -Path $d.Root -Name 'Icon' -Value $icon
        Set-ItemProperty -Path "$($d.Root)\command" -Name '(Default)' -Value $run
    }
    Write-Host ""
    Write-Host "已安装 ✓  右键菜单「$label」" -ForegroundColor Green
    Write-Host "  在任意文件夹空白处右键, 或右键文件夹图标, 即可看到该选项"
    Write-Host "  Windows 11 若没看到, 点菜单底部「显示更多选项」(或 Shift+F10)"
    Write-Host ""
} else {
    foreach ($d in $keyDefs) {
        if (Test-Path -LiteralPath $d.Root) { Remove-Item -LiteralPath $d.Root -Recurse -Force }
    }
    Write-Host ""
    Write-Host "已卸载 ✓  右键菜单「$label」已移除" -ForegroundColor Yellow
    Write-Host ""
}
