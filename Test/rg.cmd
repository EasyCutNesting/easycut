@echo off
cls
setlocal
set EasyCutPathInstaller=%~dp0
set LstStr=;

for /F "tokens=2,*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Autodesk\AutoCAD\R25.0\ACAD-8101:409\Profiles\<<Unnamed Profile>>\General" /v ACAD 2^> nul') do @set AutocadPath=%%b

if "%AutocadPath:~-1%"==";" (  
	REG ADD "HKEY_CURRENT_USER\Software\Autodesk\AutoCAD\R25.0\ACAD-8101:409\Profiles\<<Unnamed Profile>>\General" /v "ACAD" /t REG_SZ /d "%AutocadPath%%EasyCutPathInstaller:~0,-1%%LstStr%" /f
) ELSE (
	REG ADD "HKEY_CURRENT_USER\Software\Autodesk\AutoCAD\R25.0\ACAD-8101:409\Profiles\<<Unnamed Profile>>\General" /v "ACAD" /t REG_SZ /d "%AutocadPath%;%EasyCutPathInstaller:~0,-1%%LstStr%" /f
	echo aggiunto %LstStr%
)
set a=10
