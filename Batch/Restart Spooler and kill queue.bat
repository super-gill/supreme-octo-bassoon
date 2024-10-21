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
title Restart Spooler
echo.
echo. Restart Spooler, run this as admin
echo.
net stop spooler
if exist C:\Windows\System32\spool\PRINTERS del /S C:\Windows\System32\spool\PRINTERS\*
net start spooler
cls

