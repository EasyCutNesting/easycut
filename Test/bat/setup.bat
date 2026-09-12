@echo off
cls
echo **** Start Setup EasyCut
setlocal ENABLEEXTENSIONS
set REG_NAME=HKEY_CURRENT_USER\Software\Autodesk\AutoCAD
set EasyCutPathInstaller=%cd%
set Slash=\

REG QUERY %REG_NAME% > nul 2> nul
if %ERRORLEVEL% EQU 1 goto step1

tasklist /FI "IMAGENAME eq acad.exe" 2> nul | find /I /N "acad.exe" > nul
if %ERRORLEVEL% EQU 0 goto step2

call "%EasyCutPathInstaller%%Slash%registry.bat"
call "%EasyCutPathInstaller%%Slash%suite.bat"
echo **** Finish Setup EasyCut
goto finish
:step1
echo. +++++++++++++++++++++++++++++++++++++++++
echo. +                                       +
echo. +        Autocad non installato         +
echo. +                                       +
echo. +++++++++++++++++++++++++++++++++++++++++
goto finish
:step2
echo. +++++++++++++++++++++++++++++++++++++++++
echo. +                                       +
echo. + Chiudere autocad ed eseguire il setup +
echo. +                                       +
echo. +++++++++++++++++++++++++++++++++++++++++
goto finish


:finish

