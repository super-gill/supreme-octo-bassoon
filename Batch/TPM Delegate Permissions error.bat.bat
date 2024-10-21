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
REG ADD HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Protect\Providers\df9d8cd0-1501-11d1-8c7a-00c04fc297eb /v ProtectionPolicy /t REG_DWORD /d 1

