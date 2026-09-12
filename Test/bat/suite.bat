@echo OFF

echo Start Suite EasyCut

setlocal ENABLEEXTENSIONS
set StartEasyCut=StartEasyCut.lsp
set EasyCutPathInstaller=%cd%
set Slash=\
rem -----------------------------------------------
set REG_NAME=HKEY_CURRENT_USER\Software\Autodesk\AutoCAD
set KEY_VERSION=CurVer
FOR /F "usebackq skip=2 tokens=1-2*" %%A IN (`REG QUERY %REG_NAME% /v %KEY_VERSION% 2^>nul`) DO (set ValueVersion=%%C)
rem -----------------------------------------------
set REG_NAME=%REG_NAME%%Slash%%ValueVersion%
set KEY_NAME=CurVer
if defined ValueVersion (
FOR /F "usebackq skip=2 tokens=1-2*" %%A IN (`REG QUERY %REG_NAME% /v %KEY_NAME% 2^>nul`) DO (set ValueInternalVersion=%%C)
) else (
Goto Status1
)
rem -----------------------------------------------
rem set REG_NAME=%REG_NAME%%Slash%%ValueInternalVersion%%Slash%Profiles
rem if defined ValueInternalVersion (
rem FOR /F "usebackq skip=2 tokens=1-2*" %%A IN (`REG QUERY %REG_NAME% /ve 2^>nul`) DO (set ValueProfileName=%%C)	
rem ) else (
rem Goto Status2
rem )
rem -----------------------------------------------
set REG_NAME=%REG_NAME%%Slash%%ValueInternalVersion%%Slash%Profiles
Reg export %REG_NAME% %LOCALAPPDATA%%Slash%Autocad.txt /y >nul
for /f "skip=3 tokens=*" %%a in ('type %LOCALAPPDATA%%Slash%Autocad.txt') do (
 	set ValueProfileName=%%a
	goto next
)
:next
set ValueProfileName=%ValueProfileName:~2%
rem echo.%ValueProfileName%
set REG_NAME=%REG_NAME%%Slash%%ValueProfileName%%Slash%Dialogs\Appload\Startup
set REG_NAME=%REG_NAME:<=[%
set REG_NAME=%REG_NAME:>=]%
set REG_NAME=%REG_NAME:"=%
set "REG_NAME=%REG_NAME:[=<%"
set "REG_NAME=%REG_NAME:]=>%"
rem echo."%REG_NAME%"

rem -----------------------------------------------
rem set REG_NAME="%REG_NAME%%Slash%%ValueProfileName%%Slash%Dialogs%Slash%Appload%Slash%Startup"
set KEY_NAME=NumStartup
if defined ValueProfileName (
FOR /F "usebackq skip=2 tokens=1-2*" %%A IN (`REG QUERY "%REG_NAME%" /v %KEY_NAME% 2^>nul`) DO (set ValueKey=%%C)	
) else (
Goto Status3
)

rem -----------------------------------------------
if defined ValueKey (
set /a Rtn=%ValueKey%+1
) else (
Goto Status4
)
rem -----------------------------------------------

set Suite=%Rtn%Startup
set File="%EasyCutPathInstaller%%Slash%%StartEasyCut%"

echo Autocad Version           %ValueVersion%
echo Autocad Internal Version  %ValueInternalVersion%
echo Autocad Profile           %ValueProfileName%
echo Suite                     %Suite%
echo File loaded               %file%

rem echo Added new file to Suite Autocad
reg add "%REG_NAME%" /v %Suite% /t REG_SZ /d %file% > nul
reg delete "%REG_NAME%" /v %KEY_NAME% /f > nul
reg add "%REG_NAME%" /v %KEY_NAME% /t REG_SZ /d %Rtn% > nul
goto Finish


:Status1
echo Autocad Release missing
goto Finish
:Status2
echo Autocad Version missing
goto Finish
:Status3
echo Autocad Profile missing
goto Finish
:Status4
echo Autocad Suite Startup missing
goto Finish
:Finish
echo Finish Suite EasyCut