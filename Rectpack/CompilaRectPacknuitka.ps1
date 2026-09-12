# Note +++++++++++++
# Aprire il terminale
# eseguire ./CompilaRectPack.ps1
param (
    # Cartella finale dove vuoi l'applicazione pronta all'uso
    [string]$OutputDir = "C:\EasyCutNesting Beta\Apps\RectPack"
)

$ScriptName = "RectPack.py"
$AppName = "RectPack"

# 1. Controllo dei prerequisiti (Nuitka deve essere installato)
if (-not (Get-Command nuitka -ErrorAction SilentlyContinue)) {
    Write-Error "ERRORE: Nuitka non è installato o non è nel PATH di sistema."
    Write-Host "Installalo eseguendo: pip install nuitka" -ForegroundColor Yellow
    exit
}

# --- COPIA AUTOMATICA DELL'ICONA DALLA RADICE A _INTERNAL ---
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

# 2. Ripulitura della vecchia directory di destinazione finale e build locali
Write-Host "[1/4] Ripulitura delle directory di destinazione e build vecchie..." -ForegroundColor Cyan
if (Test-Path $OutputDir) {
    Write-Host "Eliminazione di: $OutputDir" -ForegroundColor Yellow
    Remove-Item -Path $OutputDir -Recurse -Force
}
New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null

# Rimuove la cartella .dist precedente di Nuitka usando il percorso assoluto
$NuitkaDist = Join-Path $PSScriptRoot "RectPack.dist"
$NuitkaBuild = Join-Path $PSScriptRoot "RectPack.build"

if (Test-Path $NuitkaDist) { Remove-Item -Recurse -Force $NuitkaDist }
if (Test-Path $NuitkaBuild) { Remove-Item -Recurse -Force $NuitkaBuild }

# 3. Esecuzione di Nuitka con i tuoi parametri + Icona
Write-Host "[2/4] Avvio di Nuitka per $ScriptName..." -ForegroundColor Cyan

# I percorsi dei file sono stati resi assoluti per evitare errori di PowerShell
$FullScriptPath = Join-Path $PSScriptRoot $ScriptName

nuitka --standalone `
       --enable-plugin=tk-inter `
       --clean-cache=all `
       --windows-console-mode=disable `
       --windows-company-name="EasyCut" `
       --windows-product-name="EasyCutNesting" `
       --windows-file-description="RectPack Tool" `
       --windows-file-version="1.0.0.0" `
       --windows-icon-from-ico=$IconaSorgente `
       $FullScriptPath

if ($LASTEXITCODE -ne 0) {
    Write-Error "ERRORE: Nuitka ha riscontrato un problema durante la compilazione."
    exit
}

# 4. Spostamento dei file compilati nella cartella finale
Write-Host "[3/4] Spostamento dei file generati in: $OutputDir" -ForegroundColor Cyan

if (Test-Path $NuitkaDist) {
    # Copia il contenuto della build .dist nella cartella finale
    Copy-Item -Path "$NuitkaDist\*" -Destination $OutputDir -Recurse -Force
    
    # Crea manualmente la cartella _internal dentro la destinazione finale e vi copia l'icona
    $FinalInternalDir = Join-Path $OutputDir "_internal"
    if (-not (Test-Path $FinalInternalDir)) {
        New-Item -Path $FinalInternalDir -ItemType Directory -Force | Out-Null
    }
    Copy-Item -Path $IconaSorgente -Destination (Join-Path $FinalInternalDir "EasyCut.ico") -Force
    
    Write-Host "Operazione completata con successo! File pronti in $OutputDir" -ForegroundColor Green
} else {
    Write-Error "ERRORE: Cartella di output di Nuitka non trovata in $NuitkaDist"
    exit
}

# 5. Pulizia dei file temporanei locali di build
Write-Host "[4/4] Pulizia dei file temporanei di compilazione locali..." -ForegroundColor Cyan
if (Test-Path $NuitkaDist) { Remove-Item -Path $NuitkaDist -Recurse -Force }
if (Test-Path $NuitkaBuild) { Remove-Item -Path $NuitkaBuild -Recurse -Force }

Write-Host "Tutti i file temporanei rimossi. Cartella pulita!" -ForegroundColor Green
