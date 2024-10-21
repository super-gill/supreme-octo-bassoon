@echo off
choice /? >nul 2>&1 || goto nokey
color 0b
mode con cols=28 lines=24
::Wasif Batch PingPong
::Batch Game


:load
call :Logo
:menu
Cls
echo/
echo/
echo/ PingPong v 1 by Wasif
echo/ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo/ ÚÄÄ¿ ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo/ ³1.³ ³Play Pong   ³
echo/ ÀÄÄÙ ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo/ ÚÄÄ¿ ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo/ ³2.³ ³How to Play ³
echo/ ÀÄÄÙ ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo/ ÚÄÄ¿ ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo/ ³3.³ ³Exit Game   ³
echo/ ÀÄÄÙ ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo/
choice /c 123 /n
if %errorlevel% equ 1 goto vars
if %errorlevel% equ 2 goto help
if %errorlevel% equ 3 goto end
:vars
setlocal enabledelayedexpansion
set LimX=18
set LimY=16
set TBound=3
set LBound=1
set /a RBound=%LimX%-1
set /a BBound=%LimY%-3
set NLevels=1

:init
for /l %%a in (0,1,%LimX%) do (
for /l %%b in (0,1,%LimY%) do (
set X%%aY%%b= ))
set Ball=O
set Bound=Û
set Block= 
set Line=Û
set Lost=ù

:Levels
set /a L+=1
Call :Level%L%
Call :Graphic
set P%L%=%Movs%
if "%LOS%"=="True" Goto :Lost
if "%NXL%"=="True" Goto :End
if "%L%"=="%NLevels%" Goto :Win
ping -n 1 0.0.0.0 >nul
Goto :Init

:Graphic
Call :Clear
cls
for /l %%d in (0,1,%LimY%) do (
for /l %%e in (0,1,%LimX%) do (
set Lin_%%d=!Lin_%%d!!X%%eY%%d!))
echo.
echo.   PingPong v 1 by Wasif
echo.
echo.    PC:%PPC%     Player:%Points%
echo.   ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
for /l %%f in (0,1,%LimY%) do (echo.   º!Lin_%%f!º)
echo.   ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
rem pause >nul
call :%Action%
if "%PPC%"=="10" (Set LOS=True&set NXL=True)
if "%NXL%"=="True" (Goto :Eof)
Goto :Graphic

:Paused
CHOICE /C:WADX /N >nul
if "%errorlevel%"=="1" (set Action=Playing)
if "%errorlevel%"=="2" (call :LeftA)
if "%errorlevel%"=="3" (call :RightA)
if "%errorlevel%"=="4" (set NXL=True)
Call :MovPC "%CurPos%"
Goto :Eof

:Playing
CHOICE /C:WADX /N /T:1 /D:W >nul
if "%errorlevel%"=="1" (set Action=Playing)
if "%errorlevel%"=="2" (call :LeftB)
if "%errorlevel%"=="3" (call :RightB)
if "%errorlevel%"=="4" (set NXL=True)
Call :MovBall
Call :MovPC "%CurPos%"
Goto :Eof


:RightA
if ["%Table%"]==["%MaxTable%"] (Goto :Eof)
for /f "tokens=1,5 delims=," %%u in ("%Table%") do (
call :MovAX+ "%%u" "%%v" TB "!%%u!"
call set NewTable=!TB!,%Table%
for /f "tokens=1-5 delims=," %%t in ("!NewTable!") do (set NewTable=%%t,%%u,%%v,%%w,%%x)
set Table=!NewTable!
call :MovAX+ "%CurPos%" "%CurPos%" CurPos "!%CurPos%!"
)
Goto :Eof

:MovAX+
for /f "tokens=1,2 delims=X,Y" %%p in ("%~1") do (
set /a MovX=%%p+1
call set NMovX=%%X!MovX!Y%%q%%
if "!NMovX!"=="%Bound%" (Goto :Eof)
if "!NMovX!"==" " (
set %~2= 
set X!MovX!Y%%q=%~4
set %3=X!MovX!Y%%q))
Goto :Eof

:RightB
if ["%Table%"]==["%MaxTable%"] (Goto :Eof)
for /f "tokens=1,5 delims=," %%u in ("%Table%") do (
call :MovAX+ "%%u" "%%v" TB "!%%u!"
call set NewTable=!TB!,%Table%
for /f "tokens=1-5 delims=," %%t in ("!NewTable!") do (set NewTable=%%t,%%u,%%v,%%w,%%x)
set Table=!NewTable!)
Goto :Eof

:LeftA
if ["%Table%"]==["%MinTable%"] (Goto :Eof)
for /f "tokens=1,5 delims=," %%u in ("%Table%") do (
call :MovAX- "%%v" "%%u" TB "!%%v!"
call set NewTable=%Table%,!TB!
for /f "tokens=2-6 delims=," %%t in ("!NewTable!") do (set NewTable=%%t,%%u,%%v,%%w,%%x)
set Table=!NewTable!
call :MovAX- "%CurPos%" "%CurPos%" CurPos "!%CurPos%!"
)
Goto :Eof

:LeftB
if ["%Table%"]==["%MinTable%"] (Goto :Eof)
for /f "tokens=1,5 delims=," %%u in ("%Table%") do (
call :MovAX- "%%v" "%%u" TB "!%%v!"
call set NewTable=%Table%,!TB!
for /f "tokens=2-6 delims=," %%t in ("!NewTable!") do (set NewTable=%%t,%%u,%%v,%%w,%%x)
set Table=!NewTable!)
Goto :Eof

:MovAX-
for /f "tokens=1,2 delims=X,Y" %%p in ("%~1") do (
set /a MovX=%%p-1
call set NMovX=%%X!MovX!Y%%q%%
if "!NMovX!"=="%Bound%" (Goto :Eof)
if "!NMovX!"==" " (
set %~2= 
set X!MovX!Y%%q=%~4
set %3=X!MovX!Y%%q))
Goto :Eof

:MovPC
for /f "tokens=1,2 delims=X,Y" %%p in ("%~1") do (
for /l %%x in (%LBound%,1,%RBound%) do (set X%%xY2= )
set /a PCL=%%p-2
set /a PCR=%%p+2
for /l %%s in (!PCL!,1,!PCR!) do (set X%%sY2=%Bound%))
Goto :Eof

:MovBall
set EOM=False
Call :%NextMov% "%CurPos%"
if "%EOM%"=="True" Goto :Eof
Goto :MovBall

:Diag1
for /f "tokens=1,2 delims=X,Y" %%p in ("%~1") do (
set /a MovX=%%p+1
set /a MovY=%%q+1
call set NMovXY=%%X!MovX!Y!MovY!%%

if "!NMovXY!"=="%Bound%" (
if "%%q"=="%BBound%" (set NextMov=Diag3)
if "%%p"=="%RBound%" (set NextMov=Diag4)
Goto :Eof)

if "!NMovXY!"==" " (
set %~1= 
set X!MovX!Y!MovY!=%Ball%
set CurPos=X!MovX!Y!MovY!
set EOM=True)
)

if "!NMovXY!"=="%Lost%" (
set %~1= 
set /a PPC+=1
call :Reset
set EOM=True)
)
Goto :Eof

::Movement Diagonal2
:Diag2
for /f "tokens=1,2 delims=X,Y" %%p in ("%~1") do (
set /a MovX=%%p-1
set /a MovY=%%q-1
call set NMovXY=%%X!MovX!Y!MovY!%%

if "!NMovXY!"=="%Bound%" (
if "%%q"=="%TBound%" (set NextMov=Diag4)
if "%%p"=="%LBound%" (set NextMov=Diag3)
Goto :Eof)

if "!NMovXY!"==" " (
set %~1= 
set X!MovX!Y!MovY!=%Ball%
set CurPos=X!MovX!Y!MovY!
set EOM=True)
)

if "!NMovXY!"=="%Lost%" (
set %~1= 
set /a Points+=1
call :Reset
set EOM=True)
)
Goto :Eof

:Diag3
for /f "tokens=1,2 delims=X,Y" %%p in ("%~1") do (
set /a MovX=%%p+1
set /a MovY=%%q-1
call set NMovXY=%%X!MovX!Y!MovY!%%

if "!NMovXY!"=="%Bound%" (
if "%%q"=="%TBound%" (set NextMov=Diag1)
if "%%p"=="%RBound%" (set NextMov=Diag2)
Goto :Eof)

if "!NMovXY!"==" " (
set %~1= 
set X!MovX!Y!MovY!=%Ball%
set CurPos=X!MovX!Y!MovY!
set EOM=True)
)

if "!NMovXY!"=="%Lost%" (
set %~1= 
set /a Points+=1
call :Reset
set EOM=True)
)
Goto :Eof

:Diag4
for /f "tokens=1,2 delims=X,Y" %%p in ("%~1") do (
set /a MovX=%%p-1
set /a MovY=%%q+1
call set NMovXY=%%X!MovX!Y!MovY!%%

if "!NMovXY!"=="%Bound%" (
if "%%q"=="%BBound%" (set NextMov=Diag2)
if "%%p"=="%LBound%" (set NextMov=Diag1)
Goto :Eof)

if "!NMovXY!"==" " (
set %~1= 
set X!MovX!Y!MovY!=%Ball%
set CurPos=X!MovX!Y!MovY!
set EOM=True)
)

if "!NMovXY!"=="%Lost%" (
set %~1= 
set /a PPC+=1
call :Reset
set EOM=True)
)
Goto :Eof

:Clear
for /l %%m in (0,1,%LimY%) do (set Lin_%%m=)
Goto :Eof

:Reset
set CurPos=X8Y13
set Table=X10Y14,X9Y14,X8Y14,X7Y14,X6Y14
for /l %%h in (1,1,17) do (set X%%hY14= )
for %%k in (%Init%) do (set %%k=%Line%)
for /f "tokens=1 delims=," %%j in ("%Init%") do (set %%j=%Ball%)
set Action=Paused
Goto :Eof

:Lost
cls
echo You lost!
choice /n /m "Play again?(Y/N)?"
if errorlevel 1 goto menu
msg * You Lost !

:End
msg * Thx for Playing PingPong v1 by Wasif
endlocal
exit /b 0


:Level1
set Movs=0
set Points=0
set PPC=0
set CurPos=X8Y13
set Table=X10Y14,X9Y14,X8Y14,X7Y14,X6Y14
set MaxTable=X17Y14,X16Y14,X15Y14,X14Y14,X13Y14
set MinTable=X5Y14,X4Y14,X3Y14,X2Y14,X1Y14
set Init=X8Y13,X6Y14,X7Y14,X8Y14,X9Y14,X10Y14
set Lives=3
set Dir=N
set Action=Paused
set NextMov=Diag3
for /l %%e in (%LBound%,1,%RBound%) do (set X%%eY1=.)
for /l %%f in (6,1,10) do (set X%%fY2=%Bound%)
for %%k in (%Init%) do (set %%k=%Line%)
for /f "tokens=1 delims=," %%j in ("%Init%") do (set %%j=%Ball%)
for /l %%i in (0,1,%LimX%) do (
set X0Y%%i=%Bound%
set X%LimX%Y%%i=%Bound%
set X%%iY0=%Bound%
set X%%iY%LimY%=%Bound%)
rem for /l %%l in (2,1,16) do (set X%%lY2=%Block%)
rem for /l %%m in (4,1,14) do (set X%%mY3=%Block%)
rem for /l %%n in (6,1,12) do (set X%%nY4=%Block%)
rem for /l %%o in (8,1,10) do (set X%%oY5=%Block%)
for /l %%r in (1,1,17) do (set X%%rY15=%Lost%)
Goto :Eof


:Logo
cls
echo.
echo. °°°°°°°°°°°°°°°°°°°°°°°°°°
echo. °°°°°°°°°°°°°°°°°°°°°°°°°°
echo. °ÛÛÛÛ°°Û°°ÛÛ°°°Û°°°ÛÛÛÛ°°°
echo. °Û°°Û°°Û°°Û°Û°°Û°°Û°°°°°°°
echo. °Û°°Û°°Û°°Û°°Û°Û°°Û°°°°°°°
echo. °ÛÛÛÛ°°Û°°Û°°Û°Û°°Û°°ÛÛ°°°
echo. °Û°°°°°Û°°Û°°°ÛÛ°°Û°°°Û°°°
echo. °Û°°°°°Û°°Û°°°°Û°°°ÛÛÛÛ°°°
echo. °°°°°°°°°°°±°°°°°°°°°°°°°°
echo. °°°°°°°°°°±°°±°°°°°°°°°°°°
echo. °°°°°°°°°±°°±°°°±°°°°°°°°°
echo. °ÛÛÛÛ°°²²°°±ÛÛ°±°Û°°ÛÛÛÛ°°
echo. °Û°°Û°²ÛÛ²±°Û°Û°°Û°Û°°°°°°
echo. °Û°°Û°ÛÛÛÛ°°Û±°Û°Û°Û°°°°°°
echo. °ÛÛÛÛ°ÛÛÛÛ°±Û°°Û°Û°Û°°°ÛÛ°
echo. °Û°°°°²ÛÛ²±°Û°°°ÛÛ°Û°°°°Û°
echo. °Û°°°°°²²°°°Û°°°°Û°°ÛÛÛÛ°°
echo. °°°ÛÛÛÛÛÛÛ°°°°°°°°°°°°°°°°
echo. °°°°°°°°°°°°°°°°°°°°°°°°°°
echo. °°°°°: Wasif Hasan :°°°°°°
echo. °°°°°  Corp.  2018  °°°°°°
echo. °°°°°°°°°°°°°°°°°°°°°°°°°°
pause >nul
Goto :Eof


:NoKey
mode con cols=96 lines=39
cls
echo ERROR: This game requires the CHOICE command, but it is missing.
echo Game aborted. :(
echo(
echo A 16 bit port of CHOICE.EXE from FREEDOS is available at
echo http://winsupport.org/utilities/freedos-choice.html
echo(
echo A 32 bit version from ??? suitable for 64 bit machines is available at
echo http://hp.vector.co.jp/authors/VA007219/dkclonesup/choice.html
echo(
pause >nul
exit /b 1

:help
Cls
echo/
echo/
echo/ How to Play Batch Pong?
echo/
echo/ Use keys W,A,D,X
echo/
echo/ W = Move the ball forward
echo/ A = Move the ball left 
echo/ D = Move the ball right
echo/ X = Back to Menu
echo/
echo/ 
Pause >nul
Goto :Menu
