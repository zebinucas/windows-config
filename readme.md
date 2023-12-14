# windows开发环境配置

这个仓库的文档和配置文件基于windows11

## windows-terminal

- 微软商店下载pwsh作为shell

## 安装scoop

执行以下命令安装scoop

```shell
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
```

如果出现远程地址报错之类的错误，请追加hosts文件的内容

文件路径`C:\Windows\System32\drivers\etc\hosts`

文件内容

```
185.199.108.133  raw.githubusercontent.com
185.199.109.133  raw.githubusercontent.com
185.199.110.133  raw.githubusercontent.com
185.199.111.133  raw.githubusercontent.com
dns1.p08.nsone.net      github.com
dns2.p08.nsone.net      github.com
dns3.p08.nsone.net      github.com
dns4.p08.nsone.net      github.com
ns-1283.awsdns-32.org   github.com
ns-1707.awsdns-21.co.uk github.com
ns-421.awsdns-52.com    github.com
ns-520.awsdns-01.net    github.com
```

## 安装pwsh的主题oh-my-pwsh

```
scoop install oh-my-pwsh
```

on-my-pwsh配置文件以及默认的pwsh配置文件位置

`$HOME\Documents\PowerShell\Profile.ps1`
