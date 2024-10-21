@ECHO off

echo =========================================================
echo Another FABULOUS jason script for OOBE set up version 0.6
echo =========================================================
echo.
echo.

powercfg.exe /h off
if %errorlevel% GTR 0 set hiberror=1

cls

echo =========================================================
echo Another FABULOUS jason script for OOBE set up version 0.5
echo =========================================================
echo.
echo.
if %hiberror%==1 (
	echo Disabling Hibernate FAILED! ) ELSE (
	echo Hibernate off )

powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
if %errorlevel% GTR 0 set sleeperror=1

cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version 0.5
echo =========================================================
echo.
echo.
if %hiberror%==1 (
	echo Disabling Hibernate FAILED! ) ELSE (
	echo Hibernate off )
if %sleeperror%==1 (
	echo Disabling Sleep FAILED! ) ELSE (
	echo Sleep off )

powercfg -change -standby-timeout-ac 0
if %errorlevel% GTR 0 set screenerror=1

cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version 0.5
echo =========================================================
echo.
echo.
if %hiberror%==1 (
	echo Disabling Hibernate FAILED! ) ELSE (
	echo Hibernate off )
if %sleeperror%==1 (
	echo Disabling Sleep FAILED! ) ELSE (
	echo Sleep off )
if %screenerror%==1 (
	echo Disabling Screen Timeout FAILED! ) ELSE (
	echo Screen Timeout off )

net user bn %psw% Ch1valry
if %errorlevel% GTR 0 set passerror=1


cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version 0.5
echo =========================================================
echo.
echo.
if %hiberror%==1 (
	echo Disabling Hibernate FAILED! ) ELSE (
	echo Hibernate off )
if %sleeperror%==1 (
	echo Disabling Sleep FAILED! ) ELSE (
	echo Sleep off )
if %screenerror%==1 (
	echo Disabling Screen Timeout FAILED! ) ELSE (
	echo Screen Timeout off )
if %screenerror%==1 (
	echo Resetting BN Password FAILED! ) ELSE (
	echo BN Password Reset )
echo Rename the PC

set /P newname=New Computer Name:
set oldname=%computername%
wmic computersystem where name="%computername%" call rename name="%newname%"
if %errorlevel% GTR 0 goto error

cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version 0.5
echo =========================================================
echo.
echo.
if %hiberror%==1 (
	echo Disabling Hibernate FAILED! ) ELSE (
	echo Hibernate off )
if %sleeperror%==1 (
	echo Disabling Sleep FAILED! ) ELSE (
	echo Sleep off )
if %screenerror%==1 (
	echo Disabling Screen Timeout FAILED! ) ELSE (
	echo Screen Timeout off )
if %screenerror%==1 (
	echo Resetting BN Password FAILED! ) ELSE (
	echo BN Password Reset )
echo PC renamed
echo.
echo ========
echo complete
echo ========
echo.
echo Press any key to reboot
pause >nul
shutdown /r /t 0

:error
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version 0.5
echo =========================================================
echo.
echo.
echo ERROR, try running as administrator. The script has not completed :(
ping 127.0.0.1 >nul
echo Press any key to exit
pause >nul
exit