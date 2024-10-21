@echo off
mode con: cols=65 lines=15
color 81
set /a date=date /T
ser /a time=time /T

:top
cls
title Guess my PIN
set /a PIN=%random% %% 9000+1000
set /a guesses=0
echo =============================================================
echo 			Guess my 4 digit PIN
echo =============================================================
echo.
echo.
set /p name=Player Name: 

:start
echo.
set /p guess=Guess:
echo.
if %guess%==cheat goto cheat
if %guess%==gfy goto uwotm8
if %guess% GTR %PIN% echo Lower!
if %guess% LSS %PIN% echo Higher!
if %guess%==%PIN% if %guesses%==1 goto realwin
if %guess%==%PIN% goto fakewin
set /a guesses=%guesses%+1
goto start

:fakewin
cls
echo =============================================================
echo 			Guess my 4 digit PIN
echo =============================================================
echo.
echo You guessed my PIN!
echo it took you %guesses% guesses!
echo %name% - %guesses% >> "c:\users\%username%\documents\score.txt"
echo.
echo [Y] Yes
echo [N] No
echo.
set /p again=Again?
echo.
if %again%==Y (goto top) else if %again%==N (goto exit) else if %again%==y (goto top) else if %again%==n (goto exit) else (goto error)
goto start

:realwin
cls
echo =============================================================
echo 			Guess my 4 digit PIN
echo =============================================================
echo.
echo HOLY CRAP YOU DID IT IN ONE, we wont ask how ;)
echo You are clearly a god among men
echo %date% %time% - %name% - %guesses% >> "c:\users\%username%\documents\score.txt"
echo.
echo Try again?
echo [Y] Yes
echo [N] No
echo.
set /p again=Again?
echo.
if %again%==Y (goto top) else if %again%==N (goto exit) else if %again%==y (goto top) else if %again%==n (goto exit) else (goto error)
goto start

:uwotm8
cls
echo =============================================================
echo 			Guess my 4 digit PIN
echo =============================================================
echo.
echo.
echo.
echo.
echo.
echo =============================================================
echo 			YOU  FAKING  WOT  M8
echo =============================================================
ping 127.0.0.1 >n
echo =============================================================
echo 		  	  DEPLOYING CRYPTO
echo =============================================================
ping 127.0.0.1 >n
echo.
echo 0%%
ping 127.0.0.1 >n
echo 20%%
ping 127.0.0.1 >n
echo 40%%
ping 127.0.0.1 >n
echo 60%%
ping 127.0.0.1 >n
echo =============================================================
echo 			YOU FAKING SORRY YET?
echo =============================================================
ping 127.0.0.1 >n
echo 80%%
ping 127.0.0.1 >n
echo =============================================================
echo 	  OH U SO LUCKY, IT NO WORK. BE LESS MEAN NEXT TIME!
echo =============================================================
ping 127.0.0.1 >n
cls
goto top

:error
cls
echo =============================================================
echo 			Guess my 4 digit PIN
echo =============================================================
echo.
echo.
echo.
echo Something went wrong, try again :(
ping 127.0.0.1 >n
goto top

:exit
cls

echo =============================================================
echo 			Guess my 4 digit PIN
echo =============================================================
echo.
echo.
echo Thanks for playing
echo.
echo =============================================================
echo made by LORD RAFFERTY ROCKET ESQUIRE MSP GCSE BSC SSC VETERAN
echo =============================================================
ping 127.0.0.1 >nul
start c:\users\%username%\documents\score.txt
ping 127.0.0.1 >nul
exit

:cheat
cls
echo =============================================================
echo 			Guess my 4 digit PIN
echo =============================================================
echo.
echo Cheaters never prosper!, the PIN is %PIN%
ping 127.0.0.1 >nul
set /a guesses=%guesses%+1
goto start

