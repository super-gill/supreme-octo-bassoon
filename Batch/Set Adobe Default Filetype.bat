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
title Set default filetype for PDF documents
cls
echo --------------------------------------------------------------------------------
echo Input the full directory to the exe of the application using ""
echo ie "C:\program files\adobe\launcher\adobe.exe"
echo --------------------------------------------------------------------------------
set /p dir=Directory:
echo off
ftype AcroExch.Document.DC=%dir% "%1"
exit

