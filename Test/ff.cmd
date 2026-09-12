@echo off

echo.%2 | findstr /C:"%1" 1>nul

if %errorlevel% NEQ 1 (
  echo. stringa trovata
) ELSE (
  echo. stringa non trovata
)
%UserProfile%\AppData\Roaming\Autodesk\AutoCAD 2025\R25.0\enu\support;C:\Program Files\Autodesk\AutoCAD 2025\support;C:\Program Files\Autodesk\AutoCAD 2025\support\en-US;C:\Program Files\Autodesk\AutoCAD 2025\fonts;C:\Program Files\Autodesk\AutoCAD 2025\help;C:\Program Files\Autodesk\AutoCAD 2025\Express;C:\Program Files\Autodesk\AutoCAD 2025\support\color;