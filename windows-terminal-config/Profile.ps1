# 使用utf8编码
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# 使用oh-my-posh主题
& ([ScriptBlock]::Create((oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\kushal.omp.json" --print) -join "`n"))


# 使用starship时自定义的头
# function Invoke-Starship-PreCommand {
#   $host.ui.Write("`e]0; PS> $env:USERNAME@$env:COMPUTERNAME`: $pwd `a")
#   $host.ui.Write("🚀 Hello Jia")
# }

# 使用starship主题
# Invoke-Expression (&starship init powershell)

# 设置默认打开位置
# Set-Location F:\

# powershell初始化加载 PSReadLine 模块
Import-Module PSReadLine

# 删除默认的连接（强制删除）
Remove-Alias ls -Force
Remove-Alias sl -Force

# 使用历史记录进行脚本提示
Set-PSReadLineOption -PredictionSource History

#tab菜单选择以及上下键补全以及emacs模式
Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# alt在windows中有特殊用途，这里使用ctrl键代替
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function ForwardWord

# 添加快捷键ctrl+f打开fzf并且cd进去，ctrl+e打开fzf用vim打开文件
Set-PSReadlineKeyHandler -Chord "Ctrl+f" -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert('cd "$(fzf)\.."')
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadlineKeyHandler -Chord "Ctrl+e" -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert('$fzfAndVim = fzf ; cd $fzfAndVim\.. ; vim ($fzfAndVim -split "\\" | tail -1)')
 # [Microsoft.PowerShell.PSConsoleReadLine]::Insert('cd "$(fzf)\.."')
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# 自定义函数添加ls的颜色
function Color-List($str) {
    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase-bor [System.Text.RegularExpressions.RegexOptions]::Compiled)
    $fore = $Host.UI.RawUI.ForegroundColor
    $compressed = New-Object System.Text.RegularExpressions.Regex('\.(zip|tar|gz|rar|jar|war|7z)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex('\.(exe|bat|cmd|py|ps1|psm1|vbs|rb|reg|sh|zsh)$', $regex_opts)
    $code_files = New-Object System.Text.RegularExpressions.Regex('\.(ini|csv|log|xml|yml|json|java|c|cpp|css|sass|js|ts|jsx|tsx|vue)$', $regex_opts)
    $head_files = New-Object System.Text.RegularExpressions.Regex('\.(h)$', $regex_opts)
    $itemList = @()
    Invoke-Expression ("Get-ChildItem" + " " + $str) | ForEach-Object {
        $item = New-Object object
        if ($_.GetType().Name -eq 'DirectoryInfo') 
        {
            $item | Add-Member NoteProperty name ("`e[34m" + $_.name) # 目录名称蓝色
        }
        elseif ($compressed.IsMatch($_.Name)) 
        {
            $item | Add-Member NoteProperty name ("`e[31m" + $_.name) # 压缩文件红色
        }
        elseif ($executable.IsMatch($_.Name))
        {
            $item | Add-Member NoteProperty name ("`e[36m" + $_.name) # 可执行文件青色
        }
        elseif ($code_files.IsMatch($_.Name))
        {
            $item | Add-Member NoteProperty name ("`e[33m" + $_.name) # 代码文件黄色
        }
        elseif ($head_files.IsMatch($_.Name))
        {
            $item | Add-Member NoteProperty name ("`e[32m" + $_.name) # 头文件绿色
        }
        else
        {
            $item | Add-Member NoteProperty name ("`e[37m" + $_.name) # 其他文件默认白色
        } 
        $itemList += $item
    }
    echo $itemList | Format-Wide -AutoSize # 格式化输出
}

# 类似软链接
function ls {Color-List "-Exclude .*"}
function ll {Color-List "$args"}

# 设置默认的代理端口
$env:http_proxy="http://127.0.0.1:7890"
$env:https_proxy="http://127.0.0.1:7890"