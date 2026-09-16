================================================
  快速打开 Claude Code 使用说明
================================================

本文件夹里配置了以下功能, 帮你省去
"打开终端 -> 输入claude" 的步骤:


【方式一】右键菜单 - Claude Code 官方终端 (cmd)
  - 安装: 双击运行  Install-RightClick-Menu.bat (只需一次)
  - 使用: 在任意文件夹的空白处右键
          -> 点击 "在此文件夹中打开 Claude Code"
  - 效果: 直接在当前文件夹启动 Claude Code (用系统默认终端)


【方式二】便携启动器
  - 文件: Open-Claude-Here.bat
  - 用法1: 把该文件复制到任何文件夹, 双击即可在该文件夹打开 Claude Code
  - 用法2: 把一个文件夹(或文件) 拖到该文件图标上,
           即可在目标文件夹打开 Claude Code


【方式三】用 Tabby Terminal 打开并自动启动 Claude Code (推荐)
  - 目录: tabby-open\ 文件夹里
  - 安装/卸载 (一键切换):
      双击  tabby-open\toggle.bat
      -> 已安装则卸载, 未安装则安装
      (也可以传参数: toggle.bat install / toggle.bat uninstall)
  - 使用: 在任意文件夹的空白处右键 (或右键文件夹图标)
          -> 点击 "用 Tabby 打开 Claude Code"
  - 效果: Tabby 新开一个 cmd 标签页, 自动 cd 到该文件夹并启动 claude
  - 注意: 需要先安装 Tabby Terminal
  - 提示: Windows 11 若右键菜单里没看到, 请点菜单底部 "显示更多选项"
          (或按 Shift+F10)


【方式四】Tabby 便携启动器
  - 文件: tabby-open\Open-Tabby-Claude-Here.bat
  - 用法: 双击本文件, 或把一个文件夹/文件拖到该文件图标上
  - 效果: 同上, 用 Tabby 打开 cmd 并自动启动 Claude Code


【卸载】
  - Claude Code 右键菜单: 双击  Uninstall-RightClick-Menu.bat
  - Tabby 右键菜单: 双击  tabby-open\toggle.bat (再点一次就是卸载)
  - 便携版 bat 直接删除即可


【技术说明 (为什么之前点了没反应)】
  Tabby 1.0.235 的 CLI 子命令 (tabby run/open ...) 存在一个
  stripAnsi 崩溃 bug, 参数在解析阶段就挂掉, 所以旧版脚本
  (Install-Tabby-RightClick-Menu.*) 装的右键菜单点了毫无反应。
  新方案改用 tabby:// URL 协议绕过该 bug:
    tabby://run?command=cmd.exe /c "cd /d <目录> && claude"
  目录用正斜杠、整段命令用引号包住, 才能正确传参。
  如果以后 Tabby 更新修复了 CLI, 旧方案可以直接用, 此目录可删除。


【注意事项】
  1. 需要系统能直接运行 claude 命令
     (你的电脑已通过 npm 安装, 无需再操作)
  2. 右键菜单写入的是"当前用户"注册表 (HKCU),
     不需要管理员权限, 不影响其他用户
  3. 方式三/四 需要先安装 Tabby Terminal
     (你的电脑已安装; 其他电脑可用 winget install Eugeny.Tabby)
