@echo off
:: Forza lo script a posizionarsi nella cartella in cui si trova
cd /d "%~dp0"
:: Avvia il terminale PowerShell bypassando le restrizioni di esecuzione di Windows
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "Rilascio versione.ps1"
