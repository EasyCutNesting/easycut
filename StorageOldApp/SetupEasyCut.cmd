::
:: Parte 1
::
@echo off
cls
setlocal

set CurrentUser=HKEY_CURRENT_USER\
set FolderApp=EasyCut
set StartupFileEasyCut=StartEasyCut.lsp
set EasyCutRegistry=Software\EasyCut
set AutoCadRegistry=Software\Autodesk\AutoCAD
set ReleaseFileName="%~dp0Dbase\Release.lsp"
set FileDoc=AcadDoc.lsp
set EasyCutPathInstaller=%~dp0
set /p VersionEasyCut=<%ReleaseFileName%
set Label="EasyCut"
set FileEmpty="0"
set LstStr=;

set AutocadVersion=-
set AutocadSubVersion=-
set AutocadProfiles=-
set AutocadPath=-
set AutocadDrv=-
set PathAcadDoc=-
set FullNameAcadDoc=-

:: Set Esc Color
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
:: Set Date Time ---------------------------------------------------------------------
For /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set mydate=%%a-%%b-%%c)
set mytime=%time:~0,2%-%time:~3,2%-%TIME:~6,2%
rem set Rtn=%mydate%_%mytime%
set MyDt=%MyDate: =%
set MyTm=%MyTime: =%
:: -----------------------------------------------------------------------------------

echo. > %temp%\InstallEasyCut.log

echo:
echo %MyDt% %MyTm%
echo Configurazione EasyCut %VersionEasyCut% 
::
:: Lettura registri di Autocad
::
echo Lettura registri Autocad -----------------------------------------------------------------------------

for /F "tokens=2,*" %%a in ('reg query "%CurrentUser%%AutoCadRegistry%" /v CurVer 2^> nul') do @set AutocadVersion=%%b
if "%AutocadVersion%"=="-" goto AcadErr1

for /F "tokens=2,*" %%a in ('reg query "%CurrentUser%%AutoCadRegistry%\%AutocadVersion%" /v CurVer 2^> nul') do @set AutocadSubVersion=%%b
if "%AutocadSubVersion%"=="-" goto AcadErr2

for /F "tokens=2,*" %%a in ('reg query "%CurrentUser%%AutoCadRegistry%\%AutocadVersion%\%AutocadSubVersion%\Profiles" /ve 2^> nul') do @set AutocadProfiles=%%b
if "%AutocadProfiles%"=="-" goto AcadErr3

for /F "tokens=2,*" %%a in ('reg query "%CurrentUser%%AutoCadRegistry%\%AutocadVersion%\%AutocadSubVersion%\Profiles\%AutocadProfiles%\General" /v ACAD 2^> nul') do @set AutocadPath=%%b
if "%AutocadPath%"=="-" goto AcadErr4

for /F "tokens=2,*" %%a in ('reg query "%CurrentUser%%AutoCadRegistry%\%AutocadVersion%\%AutocadSubVersion%\Profiles\%AutocadProfiles%\General" /v ACADDRV 2^> nul') do @set AutocadDrv=%%b
if "%AutocadDrv%"=="-" (
	set "ListFolders=%AutocadPath%
) else (
set "ListFolders=%AutocadPath%%AutocadDrv%
)

echo:
echo Informazioni Autocad ---------------------------------------------------------------------------------
echo:
echo + Autocad Version    "%AutocadVersion%"
echo + Autocad Subversion "%AutocadSubVersion%"
echo + Autocad Profile    "%AutocadProfiles%"
echo:
echo ------------------------------------------------------------------------------------------------------
::
:: Parte 2
::
echo:
echo Ricerca %FileDoc%  ---------------------------------------------------------------------------------
echo:
:ProcessFolders
::
:: Ricerca AcadDoc.lsp
::
FOR /f "tokens=1* delims=;" %%x IN ("%ListFolders%") DO ( 
             if "%%x" NEQ "" ( 
                  rem  echo %%x
				  :: ------ aggiunto -------------------------------
				  if EXIST "%%x\%FileDoc%" (
					set FullNameAcadDoc=%%x\%FileDoc%
					echo %ESC%[0;32m[  Trovato  ] %%x %ESC%[0m
					) else (
						echo %ESC%[0;31m[Non trovato] %%x %ESC%[0m
					)
					rem echo %%x
				  :: -----------------------------------------------
                  rem for /f "delims=" %%F in ('dir /b /s "%%x\%FileDoc%" 2^>nul') do (set FullNameAcadDoc=%%F)
            )
            if "%%y" NEQ "" (
               set ListFolders=%%y
               goto ProcessFolders
            )
)
echo:
echo - Risultato ----------------------------------------------------------------------------------------
echo:
if "%FullNameAcadDoc%"=="-" (
		echo %ESC%[0;31m[*] File non trovato %FileDoc% %ESC%[0m
		rem echo %ESC%[0;31m[*] Non e' possibile installare EasyCut %FileDoc% %ESC%[0m
	    rem echo %AutocadPath:~-1%
		echo on
		IF NOT EXIST "%UserProfile%\AppData\Roaming\%FolderApp%" mkdir "%UserProfile%\AppData\Roaming\%FolderApp%"
		echo off
		if %errorlevel%==1 (
			echo echo %ESC%[0;31m[+]Impossibile creare %APPDATA%\%FolderApp%%ESC%[0m
			goto Eof
		)
		
		if "%AutocadPath:~-1%"==";" (  
			>nul reg add "%CurrentUser%%AutoCadRegistry%\%AutocadVersion%\%AutocadSubVersion%\Profiles\%AutocadProfiles%\General" /v "ACAD" /t REG_SZ /d "%AutocadPath%%UserProfile%\AppData\Roaming\%FolderApp%%LstStr%" /f
		) ELSE (
			>nul reg add "%CurrentUser%%AutoCadRegistry%\%AutocadVersion%\%AutocadSubVersion%\Profiles\%AutocadProfiles%\General" /v "ACAD" /t REG_SZ /d "%AutocadPath%;%UserProfile%\AppData\Roaming\%FolderApp%%LstStr%" /f
		)	
		if %errorlevel%==1 (
			echo echo %ESC%[0;31m[+]Impossibile aggiornare la variabile PathAutocad%ESC%[0m
			goto Eof
		)
		goto MakeDocFile

	) else (
	  echo %ESC%[0;32m[+]File trovato %FullNameAcadDoc% %ESC%[0m
	  goto NextStep
	)

echo ----------------------------------------------------------------------------------------------------

:AcadErr1
echo %ESC%[0;31m[*] Err1 Autocad non installato [EasyCut non funzionera'] %ESC%[0m
goto Eof
:AcadErr2
echo %ESC%[0;31m[*] Err2 Autocad non installato [EasyCut non funzionera'] %ESC%[0m
goto Eof
:AcadErr3
echo %ESC%[0;31m[*] Err3 Autocad non installato [EasyCut non funzionera'] %ESC%[0m
goto Eof
:AcadErr4
echo %ESC%[0;31m[*] Err4 Autocad non installato [EasyCut non funzionera'] %ESC%[0m
goto Eof
::
:: Parte 3
::
::
:: Creazione AcadDoc.lsp
::
:MakeDocFile
echo. > "%APPDATA%\%FolderApp%\%FileDoc%"
set FullNameAcadDoc=%APPDATA%\%FolderApp%\%FileDoc%
echo %ESC%[0;32m[+]Creato %FullNameAcadDoc%%ESC%[0m
goto NextStep

:NextStep
::
:: Creazione registri di EasyCut
::
>nul reg add "%CurrentUser%%EasyCutRegistry%" /ve /F
if %errorlevel%==1 (
 echo echo %ESC%[0;31m[+]Impossibile aggiungere il registro di EasyCut%ESC%[0m
 goto Eof
)
>nul reg add "%CurrentUser%%EasyCutRegistry%" /v "FirstInstaller" /d "1" /F
if %errorlevel%==1 (
 echo echo %ESC%[0;31m[+]Impossibile aggiungere il registro di EasyCut%ESC%[0m
 goto Eof
)
>nul reg add "%CurrentUser%%EasyCutRegistry%" /v "PathInstaller"  /d "%EasyCutPathInstaller:~0,-1%" /F
if %errorlevel%==1 (
 echo echo %ESC%[0;31m[+]Impossibile aggiungere il registro di EasyCut%ESC%[0m
 goto Eof
)
>nul reg add "%CurrentUser%%EasyCutRegistry%" /v "Version"        /d "%VersionEasyCut%" /F
if %errorlevel%==1 (
 echo echo %ESC%[0;31m[+]Impossibile aggiungere il registro di EasyCut%ESC%[0m
 goto Eof
)

echo %ESC%[0;32m[+]Aggiunto Registri EasyCut%ESC%[0m
echo %ESC%[0;32m[+]Configurato AcadDoc.lsp%ESC%[0m

for %%a in ("%FullNameAcadDoc%") do set PathAcadDoc=%%~dpa
copy "%FullNameAcadDoc%" "%PathAcadDoc%%MyDt%-%MyTm%-%FileDoc%"  > nul

::
:: Controllo l'esistenza di EasyCut sul file AcadDoc.lsp
::
findstr /m "EasyCut" "%FullNameAcadDoc%" >Nul
if %errorlevel%==0 (
rem Stringa trovata
goto :ResetFile
)
if %errorlevel%==1 (
rem echo Stringa non trovata
goto :UpdateFile
)
::
:: Parte 4
::
:ResetFile
:: ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
:: Rimuovo tutte le line che contengono la stringa "EasyCut" nel file AcadDoc.lsp
::
:: ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

echo %ESC%[0;32m[+]Rimozione vecchie installazioni di EasyCut%ESC%[0m

if exist "%FullNameAcadDoc%.work" (del "%FullNameAcadDoc%.work")
findstr /v %Label% "%FullNameAcadDoc%" > "%FullNameAcadDoc%.work"
copy "%FullNameAcadDoc%.work" "%FullNameAcadDoc%" >nul
del "%FullNameAcadDoc%.work"

goto UpdateFile

:UpdateFile
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++
::
:: Aggiungo i comandi di "EasyCut" nel file AcadDoc.lsp
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++

echo %ESC%[0;32m[+]Integrato comandi di EasyCut%ESC%[0m

if exist "%FullNameAcadDoc%.work" (del "%FullNameAcadDoc%.work")
copy "%FullNameAcadDoc%" "%FullNameAcadDoc%.work" >nul

set  CmdA=; Start Load Application                                                             ; EasyCut
set  CmdB=; Build %MyDt% %MyTm%                                                          ; EasyCut
set  CmdC=; Version EasyCut %VersionEasyCut%                                               ; EasyCut
set  CmdD=; End Load Application                                                               ; EasyCut
set  CmdE=(SearchAndAddTrsPth
set  CmdF=(if (not EasyCutRegistryPath$) (load

echo %CmdA% >> "%FullNameAcadDoc%.work"
echo %CmdB% >> "%FullNameAcadDoc%.work"
echo %CmdC% >> "%FullNameAcadDoc%.work"

type "%FullNameAcadDoc%.work" "%~dp0Dbase\SetupAcadDoc.lsp" > "%FullNameAcadDoc%" 2>nul


set EasyCutPathInstaller=%EasyCutPathInstaller:\=\\%
echo %CmdE%  "%EasyCutPathInstaller%...")									             ; EasyCut >> "%FullNameAcadDoc%"
echo %CmdF%  "%EasyCutPathInstaller%Load\\StartEasyCut.lsp" ""))  			             ; EasyCut >> "%FullNameAcadDoc%"
echo %CmdD% >> "%FullNameAcadDoc%

del "%FullNameAcadDoc%.work" >nul

:Eof
echo.
echo Fine configurazione
echo.
pause
endlocal
