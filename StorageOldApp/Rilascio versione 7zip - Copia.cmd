@echo off
setlocal
set ReleaseFileName="%~dp0Dbase\Release.lsp"
set OutFolderRelease=%~dp0Release\Output
set /p VersionEasyCut=<%ReleaseFileName%
set USER=ftp@easycutproject
set PASS=Xby983pbUXRX
set URL=ftp.easycutproject.altervista.org/EasyCut/Download

rem Check Out directory -------------------------------------------------------------------
if exist "%OutFolderRelease%\%VersionEasyCut%" rd /s /q "%OutFolderRelease%\%VersionEasyCut%"
md "%OutFolderRelease%\%VersionEasyCut%"
rem del EasyCut_%VersionEasyCut%.7z.0* >nul
rem ------------------------------------------------------------------------------------------

rem Compress file ----------------------------------------------------------------------------
"C:\Program Files\7-Zip\7z.exe" a -v5m "%OutFolderRelease%\%VersionEasyCut%\EasyCut_%VersionEasyCut%.7z" "-x!DOSLib 9.0\" -x!*.7z -x!*.zip -x!*.rar -x!*.bat -x!*.exe -x!Test\ -x!Example\ -x!Note\ -x!Source\ -x!Release\ -x!VbaModule\ -x!StorageApp\ -x!NewApp -x!CncTest "-x!NestClient_Enhanced\" -x!OldApps\ -x!Tmp\ -x!.git\
rem Clear directory server --------------------------------------------------------------------------------------
curl -s -u %USER%:%PASS% ftp://%URL%/ | findstr . > lista_file.txt 
for /f "tokens=9" %%f in (lista_file.txt) do (
    echo remove: ftp://%URL%/EasyCut/Download/%%f
    curl -s -u %USER%:%PASS% ftp://%URL%/ -Q "DELE /EasyCut/Download/%%f" >nul 2>&1
)
del lista_file.txt
rem -------------------------------------------------------------------------------------------------------------

rem Copy new version on server ----------------------------------------------------------------------------------
cd "%OutFolderRelease%\%VersionEasyCut%"
for /f %%A in ('dir /s /b /a-d ^| find /c /v ""') do set cnt=%%A
echo %VersionEasyCut% %cnt% > version.txt
for %%f in (EasyCut_%VersionEasyCut%.7z.0*) do (
    echo copy: ftp://%URL%/EasyCut/Download/%%f
    curl.exe -u %USER%:%PASS% -T %%f "ftp://%URL%/" >nul 2>&1
)
echo copy: ftp://%URL%/EasyCut/Download/version.txt
curl.exe -u %USER%:%PASS% -T "version.txt" "ftp://%URL%/" >nul 2>&1
rem -------------------------------------------------------------------------------------------------------------
pause
endlocal

