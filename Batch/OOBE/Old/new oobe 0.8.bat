@ECHO OFF

set ver=0.9

echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.

echo TPM Reg Key added

REG ADD HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Protect\Providers\df9d8cd0-1501-11d1-8c7a-00c04fc297eb /v ProtectionPolicy /t REG_DWORD /d 1

cls

echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added

powercfg.exe /h off

cls

echo =========================================================
echo Another FABULOUS jason script for OOBE set up version %ver%
echo =========================================================
echo.
echo.
echo TPM Reg Key added
echo Hibernate off

powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0

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

set /P newname=New Computer Name:
set oldname=%computername%
wmic computersystem where name="%computername%" call rename name="%newname%"

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
echo.
echo ========
echo complete
echo ========
echo.
echo Press any key to reboot
pause >nul
shutdown /r /t 0
pause >nul