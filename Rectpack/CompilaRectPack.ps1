# Note +++++++++++++
# Aprire il terminale
# eseguire ./CompilaRectPack.ps1
param (
    # Cartella finale dove vuoi l'applicazione pronta all'uso
    [string]$OutputDir = "C:\EasyCutNesting Beta\Apps\RectPack"
)

$ScriptName = "RectPack.py"
$AppName = "RectPack"

# 1. Controllo dei prerequisiti (PyInstaller deve essere installato)
if (-not (Get-Command pyinstaller -ErrorAction SilentlyContinue)) {
    Write-Error "ERRORE: PyInstaller non è installato o non è nel PATH di sistema."
    Write-Host "Installalo eseguendo: pip install pyinstaller" -ForegroundColor Yellow
    exit
}

# --- NUOVO: COPIA AUTOMATICA DELL'ICONA DALLA RADICE A _INTERNAL ---
$IconaSorgente = Join-Path $PSScriptRoot "EasyCut.ico"
$LocalInternalDir = Join-Path $PSScriptRoot "_internal"
$LocalIconPath = Join-Path $LocalInternalDir "EasyCut.ico"

# Controlla se l'icona esiste nella cartella principale (dove c'è lo script)
if (-not (Test-Path $IconaSorgente)) {
    Write-Error "ERRORE: Impossibile trovare il file 'EasyCut.ico' nella cartella principale!"
    Write-Host "Assicurati che l'icona sia posizionata in: $IconaSorgente" -ForegroundColor Yellow
    exit
}

# Se la cartella _internal locale non esiste, la crea
if (-not (Test-Path $LocalInternalDir)) {
    New-Item -Path $LocalInternalDir -ItemType Directory -Force | Out-Null
    Write-Host "Cartella _internal creata automaticamente." -ForegroundColor Cyan
}

# Copia l'icona dalla cartella principale dentro _internal
Copy-Item -Path $IconaSorgente -Destination $LocalIconPath -Force
Write-Host "Icona copiata con successo dentro _internal per la compilazione." -ForegroundColor Green
# -------------------------------------------------------------------

# 2. Ripulitura della vecchia directory di destinazione finale
Write-Host "[1/4] Ripulitura della directory di destinazione..." -ForegroundColor Cyan
if (Test-Path $OutputDir) {
    Write-Host "Eliminazione di: $OutputDir" -ForegroundColor Yellow
    Remove-Item -Path $OutputDir -Recurse -Force
}
New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null

# 3. Esecuzione di PyInstaller con i tuoi parametri
Write-Host "[2/4] Avvio di PyInstaller per $ScriptName..." -ForegroundColor Cyan

# Esecuzione con i percorsi corretti e protetti per PowerShell
# pyinstaller --clean --noconsole --onedir --add-data "$LocalIconPath;." --icon="$LocalIconPath" --name=$AppName $ScriptName
# pyinstaller --clean --noconsole --onedir --add-data "$LocalIconPath;_internal" --icon="$LocalIconPath" --name=$AppName $ScriptName
pyinstaller --clean --onedir --noupx --add-data "$LocalIconPath;_internal" --icon="$LocalIconPath" --name=$AppName $ScriptName

if ($LASTEXITCODE -ne 0) {
    Write-Error "ERRORE: PyInstaller ha riscontrato un problema durante la generazione dell'eseguibile."
    exit
}

# 4. Spostamento dei file compilati nella cartella finale particolare
Write-Host "[3/4] Spostamento dei file generati in: $OutputDir" -ForegroundColor Cyan
$SourceDir = "dist\$AppName"

if (Test-Path $SourceDir) {
    # Copia il contenuto della build nella tua cartella finale
    Copy-Item -Path "$SourceDir\*" -Destination $OutputDir -Recurse -Force
    Write-Host "Operazione completata con successo! File pronti in $OutputDir" -ForegroundColor Green
} else {
    Write-Error "ERRORE: Cartella di output di PyInstaller non trovata in $SourceDir"
    exit
}

# 5. Pulizia facoltativa dei file temporanei locali di build
Write-Host "[4/4] Pulizia dei file temporanei di compilazione locali..." -ForegroundColor Cyan
if (Test-Path "build") { Remove-Item -Path "build" -Recurse -Force }
if (Test-Path "dist") { Remove-Item -Path "dist" -Recurse -Force }
if (Test-Path "$AppName.spec") { Remove-Item -Path "$AppName.spec" -Force }

Write-Host "Tutti i file temporanei rimossi. Cartella pulita!" -ForegroundColor Green
