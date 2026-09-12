@echo off

echo Start registry EasyCut

setlocal ENABLEEXTENSIONS
set EasyCutRegistry="HKEY_CURRENT_USER\Software\EasyCut"
set EasyCutPathInstaller=%cd%
set EasyCutPathInfo=%cd%
set EasyCutPathNc=%cd%\ExampleDstv
set EasyCutPathCfg=%LOCALAPPDATA%\EasyCut
set EasyCutFileCfg=setup.cfg
set EasyCutArrayColumn=1
set EasyCutArrayRow=2
set EasyCutSymula=00
set EasyCutSymulaChoiseShape=10
set EasyCutDisplayVersion=1.0
set slash=\

if exist "%EasyCutPathCfg%%slash%%EasyCutFileCfg%" del /f "%EasyCutPathCfg%%slash%%EasyCutFileCfg%"

reg delete %EasyCutRegistry% /f > nul 2> nul

:CreateRegistry
echo Need to Create Specified service with Registry Keys and values
reg add %EasyCutRegistry% /v Version /t REG_SZ /d "%EasyCutDisplayVersion%" > nul
reg add %EasyCutRegistry% /v PathInstaller /t REG_SZ /d "%EasyCutPathInstaller%" > nul
reg add %EasyCutRegistry% /v PathNc /t REG_SZ /d "%EasyCutPathNc%" > nul
reg add %EasyCutRegistry% /v PathInfo /t REG_SZ /d "%EasyCutPathInfo%" > nul
reg add %EasyCutRegistry% /v ArrayColumn /t REG_SZ /d "%EasyCutArrayColumn%" > nul
reg add %EasyCutRegistry% /v ArrayRow /t REG_SZ /d "%EasyCutArrayRow%" > nul
reg add %EasyCutRegistry% /v Symula /t REG_SZ /d "%EasyCutSymula%" > nul
reg add %EasyCutRegistry% /v SymulaChoiseShape /t REG_SZ /d "%EasyCutSymulaChoiseShape%" > nul
reg add %EasyCutRegistry% /v EasyCutPathCfg /t REG_SZ /d "%EasyCutPathCfg%" > nul
reg add %EasyCutRegistry% /v EasyCutFileCfg /t REG_SZ /d "%EasyCutFileCfg%" > nul


echo Finish registry EasyCut
