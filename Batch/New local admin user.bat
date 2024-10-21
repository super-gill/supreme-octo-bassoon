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
echo ===========================
echo Make a new local admin user
echo ===========================
echo.
set /p name=Username: 
set /p pass=Password: 
net user "%name%" "%pass%" /add
net user "%name%" "%pass%"
net localgroup administrators "%user%" /add
cls
echo ===========================
echo Complete
echo ===========================
ping 127.0.0.1 >nul
echo.
echo.
echo.
echo Press any key to quit
pause >nul
exit

