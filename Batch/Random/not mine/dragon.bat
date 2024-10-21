@echo off

:menu
color 0a
cls
echo DRAGON KILL
echo Choose the number:
echo 1. Start game
echo 2. Exit
set /p menu=
if '%menu%'=='1' (
goto sets
)
if '%menu%'=='2' (
exit
)else goto menu
:sets
cls
set /a money=1000
set /a health=1000
set /a potions=0
set /a damage=2
set /a dd=5
set /a dh=25
set /a moneygain=50
set /a levels=0
set /a new=%dh%+5
:start
cls
echo Money:%money%
echo Health:%health%
echo Number of healing potions:%potions%
echo Choose the number:
echo 1. Venture onward to the dragon
echo 2. Go to Store
echo 3. Go to Title screen
echo 4. Drink heal potion
set /p choose=
if '%choose%'=='1' (
cls
echo DO NOT HOLD THE ENTER KEY
pause
goto fight
)
if '%choose%'=='2' (
goto store
)
if '%choose%'=='3' (
goto menu
)
if '%choose%'=='4' (
goto nextx
)else goto start
:fight
cls
echo Health:%health%
echo Dragon's Health:%new%
echo You have encountered a dragon
pause
cls
echo Press enter to hit the dragon
set /p hit=
set /a new=%new%-%damage%
if %new% LSS 1 (
goto defeat
)
cls
echo Health:%health%
echo Dragon's Health:%new%
echo You have hit the dragon
echo The dragon lost %damage% health
pause
cls
echo The dragon has hit you!
set /a health=%health%-%dd%
if %health% LSS 1 (
goto defeated
)
pause
cls
goto fight

:defeat
cls
set /a dh=%dh%+20
set /a new=%dh%
set /a money=%money%+15
set /a levels=%levels%+1
echo You defeated the dragon and earned $15.
echo Congratz
pause
goto start

:defeated
cls
echo Sorry You died!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo RIP
echo You have killed %levels% dragon
pause
goto menu

:store
cls
echo Money:%money%
echo Welcome to the store!
echo Choose:
echo 1.Sword Upgrade	$700
echo 2.Heal Potion	$30
echo 3.Leave Store
set /p again=
if %again%==1 (
goto buysword
)
if %again%==2 (
goto buyheal
)
if %again%==3 (
goto start
)else goto store</p><p>:buysword
cls
set /a money=%money%-700
if %money% LSS 0 (
echo You cant buy that!
set /a money=%money%+700
pause
goto store
)else (
set /a damage=%damage%+4
echo You have upgraded your sword
pause
goto store
)

:buyheal
cls
set /a money=%money%-30
if %money% LSS 0 (
echo You cant buy that!
set /a money=%money%+30
pause
goto store
)else (
set /a potions=%potions%+1
echo You have bought one heal potion
pause
goto store
)

:nextx
cls
if %potions%==0 (
echo Sorry. You dont have any potions.
pause
goto start
)else (
set /a health=%health%+15
set /a potions=%potions%-1
echo You have used one potion
pause
goto start
)
