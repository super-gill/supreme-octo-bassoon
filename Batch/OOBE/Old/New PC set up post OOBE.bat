echo off
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
@echo on
title Post OOBE set up
echo.
echo =======================================================================================================
echo This script assumes you set the local user to BN with no password and the computer is fresh out of OOBE
echo =======================================================================================================
echo.
echo.
echo I need to know what the pc should be called
set /p hostname=Hostname:
cls
echo.
echo =======================================================================================================
echo This script assumes you set the local user to BN with no password and the computer is fresh out of OOBE
echo =======================================================================================================
echo.
echo.
echo I need to know what to set BNs password to
set /p psw=Password: 
cls
echo.
echo =======================================================================================================
echo This script assumes you set the local user to BN with no password and the computer is fresh out of OOBE
echo =======================================================================================================
echo.
echo.
echo Should the PC be joined to an AD Domain?
set /p opt=y or n: 
if %opt%==y goto ddjoin
if %opt%==n goto hibernate
cls
echo.
echo =======================================================================================================
echo This script assumes you set the local user to BN with no password and the computer is fresh out of OOBE
echo =======================================================================================================
echo.
echo.
echo I need the domain admin credentials
set /p adminu=Administrator Username: 
set /p adminp=Administrator Password: 

:ddjoin
cls
echo.
echo =======================================================================================================
echo This script assumes you set the local user to BN with no password and the computer is fresh out of OOBE
echo =======================================================================================================
echo.
echo.
echo I need to know the name of the domain example.local
set /p dd=AD Domain Name: 
netdom join %hostname% /domain:%dd% /UserD:%adminu% /PasswordD:%adminp%
if not errorlevel 1 set /a dderror=1
goto hibernate

:hibernate
cls
echo =======================================================================================================
echo The script is running and will reboot the pc automatically, please wait
echo =======================================================================================================
powercfg.exe /h off
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
powercfg -change -standby-timeout-ac 0
goto localadm

:localadm
cls
echo =======================================================================================================
echo The script is running and will reboot the pc automatically, please wait
echo =======================================================================================================
net user bn %psw% /add
if %errorlevel%==0 goto nousrerror
if %errorlevel% GTR 0 goto usrerror

:nousrerror
cls
echo =======================================================================================================
echo The script is running and will reboot the pc automatically, please wait
echo =======================================================================================================
net localgroup administrators bn /add
if %errorlevel%==0 (goto noadmerror)
if %errorlevel% GTR 0 (goto usrerror)

:usrerror
cls
echo =======================================================================================================
echo The script is running and will reboot the pc automatically, please wait
echo =======================================================================================================
net user bn %psw%
net localgroup administrators bn /add
cls
echo =======================================================================================================
echo The script is running and will reboot the pc automatically, please wait
echo =======================================================================================================
echo.
echo bn already existed but i changed the password give them administrator
ping 127.0.0.1 >nul
goto complete

:noadmerror
cls
echo =======================================================================================================
echo The script is running and will reboot the pc automatically, please wait
echo =======================================================================================================
echo.
echo bn was created and added to local administrators
ping 127.0.0.1 >nul
goto complete

:complete
cls
echo =======================================================================================================
echo The script is running and will reboot the pc automatically, please wait
echo =======================================================================================================
echo.
echo I have set up a user with the username: BN and password: %psw%
ping 127.0.0.1 >nul
echo I have disabled sleep and hibernate
ping 127.0.0.1 >nul
if %dderror% GTR 0 (echo I couldnt deploy the PC) else (if not %dderror%==0 (echo I have deployed the PC)
ping 127.0.0.1 >nul
cls
echo Press any key to reboot . . .
pause >null
shutdown /r /t 0

REM Yet another masterpiece from the venerable Jason Mcdill