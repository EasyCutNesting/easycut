@echo off
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Il tuo messaggio', 'Titolo Popup')}"