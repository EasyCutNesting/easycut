rem @echo off
setlocal

For /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set mydate=%%a-%%b-%%c)
set mytime=%time:~0,2%-%time:~3,2%-%TIME:~6,2%
rem set Rtn=%mydate%_%mytime%
set Dt=%MyDate: =%
set Tm=%MyTime: =%
echo %Dt%-%Tm%
pause
endlocal