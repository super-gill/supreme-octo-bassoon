@echo off

set KEY_NAME=HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search

reg query "%KEY_NAME%" /v "PreventIndexingOutlook" > nul

if %errorlevel% neq 0 (
    reg add "%KEY_NAME%" /v "PreventIndexingOutlook" /t REG_DWORD /d 1 /f
    echo %VALUE_NAME% created under %KEY_NAME%
) else (
    reg add "%KEY_NAME%" /v "PreventIndexingOutlook" /t REG_DWORD /d 1 /f
    echo %VALUE_NAME% updated under %KEY_NAME%
)

echo Done.