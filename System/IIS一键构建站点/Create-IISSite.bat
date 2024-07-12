@echo off

:: 设置控制台编码为 UTF-8
chcp 65001 > nul

reg add "HKCU\Console\%SystemRoot%_system32_cmd.exe" /v "FaceName" /t REG_SZ /d "Consolas" /f > nul

:: 检查是否以管理员权限运行
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo 请以管理员身份运行此脚本
    pause
    exit /b
)

:: 定义站点参数
set "siteName=DACore"
set "sitePath=C:\inetpub\wwwroot\DACore"
set "sitePort=8080"
set "siteAppPool=DACoreAppPool"

:: 检查站点文件夹是否存在
if not exist "%sitePath%" (
    mkdir "%sitePath%"
)

:: 创建应用程序池
%windir%\system32\inetsrv\appcmd add apppool /name:%siteAppPool%
if %errorlevel% neq 0 (
    echo 创建应用程序池失败
    pause
    exit /b
)

:: 设置应用程序池的 .NET 版本（可选）
%windir%\system32\inetsrv\appcmd set apppool /apppool.name:%siteAppPool% /managedRuntimeVersion:v4.0
if %errorlevel% neq 0 (
    echo 设置应用程序池的 .NET 版本失败
    pause
    exit /b
)

:: 删除可能已存在的站点
%windir%\system32\inetsrv\appcmd delete site /name:%siteName% >nul 2>&1

:: 创建新的IIS站点
%windir%\system32\inetsrv\appcmd add site /name:%siteName% /physicalPath:%sitePath% /bindings:http/*:%sitePort%:
if %errorlevel% neq 0 (
    echo 创建IIS站点失败
    pause
    exit /b
)

:: 将应用程序池分配给站点
%windir%\system32\inetsrv\appcmd set site /site.name:"%siteName%" /[path='/'].applicationPool:"%siteAppPool%"
if %errorlevel% neq 0 (
    echo 分配应用程序池%siteAppPool%失败
    pause
    exit /b
)


echo IIS站点 '%siteName%' 已成功创建并运行在端口 %sitePort%。

pause