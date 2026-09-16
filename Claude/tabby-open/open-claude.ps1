# open-claude.ps1
# 用 Tabby 打开指定文件夹，并自动在终端里启动 Claude Code
# 用法:
#   powershell -NoProfile -ExecutionPolicy Bypass -File open-claude.ps1 -Folder "C:\某个\文件夹"
#
# 原理: 用 tabby:// URL 协议触发 Tabby 的 run 命令
#   (Tabby 1.0.235 的 CLI 子命令 tabby run ... 有 stripAnsi 崩溃 bug, URL 协议能绕过它)
#   命令: cmd.exe /c "cd /d <正斜杠目录> && claude"
#   (目录必须转成正斜杠, 反斜杠会被 Tabby 的 shell 解析器吞掉)

param(
    [string]$Folder = ""
)

# ---- 1) 定位 Tabby.exe ----
$tabby = ""
$tabbyCandidates = @(
    "$env:LOCALAPPDATA\Programs\Tabby\Tabby.exe",
    "$env:LOCALAPPDATA\Programs\tabby\Tabby.exe",
    "$env:ProgramFiles\Tabby\Tabby.exe",
    "${env:ProgramFiles(x86)}\Tabby\Tabby.exe"
)
foreach ($c in $tabbyCandidates) {
    if (Test-Path -LiteralPath $c) { $tabby = $c; break }
}
if (-not $tabby) {
    $cmd = Get-Command tabby.exe -ErrorAction SilentlyContinue
    if ($cmd) { $tabby = $cmd.Source }
}
if (-not $tabby) {
    [Console]::Error.WriteLine("找不到 Tabby.exe, 请先安装 Tabby Terminal")
    Start-Sleep -Seconds 2
    exit 1
}

# ---- 2) 确定目标文件夹 ----
if (-not $Folder) {
    $Folder = Get-Location
}
$Folder = $Folder.Trim('"').Trim()

# ---- 3) 构造 URL (目录转正斜杠 + 整段命令用引号包住 + URL 编码) ----
$urlFolder = $Folder -replace '\\', '/'
$inner = 'cmd.exe /c "cd /d ' + $urlFolder + ' && claude"'
$encoded = [Uri]::EscapeDataString($inner)
$url = 'tabby://run?command=' + $encoded

# ---- 4) 启动 Tabby ----
Start-Process -FilePath $tabby -ArgumentList $url
