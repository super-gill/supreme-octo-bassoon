@echo off
cls

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :start
) else (
    echo Please run this script as an administrator.
    echo Exiting...
    pause >nul
    exit
)
title Set BN password
echo.
echo =======================================================================================================
echo Set the BN password
echo =======================================================================================================
echo.
echo.
echo I need to know what to set BNs password to
set /p psw=#### 
net user bn /add
net user bn %psw%
net localgroup administrators bn /add
exit