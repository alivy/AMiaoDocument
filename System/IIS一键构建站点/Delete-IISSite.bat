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

:: 定义站点和应用程序池名称
set "siteName=DACore"
set "siteAppPool=DACore"

:: 删除站点
%windir%\system32\inetsrv\appcmd list site /name:%siteName% >nul 2>&1
if %errorlevel% equ 0 (
    %windir%\system32\inetsrv\appcmd delete site /site.name:%siteName%
    if %errorlevel% neq 0 (
        echo 删除站点失败
        pause
        exit /b
    )
) else (
    echo 站点 '%siteName%' 不存在
)

:: 删除应用程序池
%windir%\system32\inetsrv\appcmd list apppool /name:%siteAppPool% >nul 2>&1
if %errorlevel% equ 0 (
    %windir%\system32\inetsrv\appcmd delete apppool /apppool.name:%siteAppPool%
    if %errorlevel% neq 0 (
        echo 删除应用程序池失败
        pause
        exit /b
    )
) else (
    echo 应用程序池 '%siteAppPool%' 不存在
)

echo 站点 '%siteName%' 和应用程序池 '%siteAppPool%' 已成功删除。

pause