@echo off
:: 1. Avvia un'istanza pulita del Blocco Note in background
start "" notepad.exe

:: 2. Attende una frazione di secondo che si carichi la finestra
timeout /t 1 /nobreak >nul

:: 3. Usa PowerShell per inviare la combinazione tasti per aprire il file (Simula Ctrl+O e scrive il percorso)
powershell -Command "$wshell = New-Object -ComObject Wscript.Shell; $wshell.AppActivate('Blocco note'); Start-Sleep -Milliseconds 200; $wshell.SendKeys('^o'); Start-Sleep -Milliseconds 400; $wshell.SendKeys('C:\EasyCutNesting Beta\Test\ToolsExcel.lsp{ENTER}')"
