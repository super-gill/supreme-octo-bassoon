@ECHO OFF

set ver=0.9

:TPM
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.

echo TPM Reg Key added

REG ADD HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Protect\Providers\df9d8cd0-1501-11d1-8c7a-00c04fc297eb /v ProtectionPolicy /t REG_DWORD /d 1

:hibernate
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added

powercfg.exe /h off

:sleep
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added
echo Hibernate off

powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0

:timeout
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added
echo Hibernate off
echo Sleep off

powercfg -change -standby-timeout-ac 0

:bnacc
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added
echo Hibernate off
echo Sleep off
echo Screen Timeout off

net user bn /add
net user bn %psw% Ch1valry
net localgroup administrators bn /add

:computername
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added
echo Hibernate off
echo Sleep off
echo Screen Timeout off
echo BN Password reset to Ch1valry
echo.
echo Rename the PC
echo.
set /P newname=New Computer Name:
set oldname=%computername%
wmic computersystem where name="%computername%" call rename name="%newname%"

:domaindo
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added
echo Hibernate off
echo Sleep off
echo Screen Timeout off
echo BN Password reset to Ch1valry
echo Domain
echo PC rename to %computername%
echo.
set /P option=Should the PC be domain deployed (yes/no)?
if %option%==yes goto :domaindeploy
if %option%==no goto :end
Echo.
echo Invalid response, Daniel?, choose "yes" or choose "no" GOD DAMN IT DANIEL
echo.
Echo Press any key to try again
pause >nul
cls

goto :domaindo

:domaindeploy
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added
echo Hibernate off
echo Sleep off
echo Screen Timeout off
echo BN Password reset to Ch1valry
echo Domain
echo PC rename to %computername%
echo.
Set /P domainname=Enter the full domain name (domain.local):
echo.
Set /P adminuser=Enter the Admin username:
echo.
Set /P adminpass=Enter the Admin password:

netdom.exe join %computername% /domain:%domainname% /userd:%adminuser% /password:%adminpass%

:end
cls
echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added
echo Hibernate off
echo Sleep off
echo Screen Timeout off
echo BN Password reset to Ch1valry
echo PC renamed to: "%newname%" (requires a reboot)
if %option%==yes echo I will try to deploy the PC to %domainname% but no promises (requires a reboot)
echo.
echo ========
echo complete
echo ========
echo.
echo Press any key to reboot
pause >nul
shutdown /r /t 0
pause >nul