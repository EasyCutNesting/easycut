# Note +++++++++++++
# Aprire il terminale
# eseguire ./CompilaDxfNest.ps1
# Prepara il parametro per la cartella di destinazione. 
# Se non specifichi nulla quando lo lanci, userà il percorso di default indicato sotto.
param (
    [string]$OutputDir = "C:\EasyCutNesting Beta\Apps\DxfNest"
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SolutionName = Join-Path $ScriptDir "DXFnest-main\DXFnest.sln"
# $SolutionName = "DXFnest-main\DXFnest.sln"

# 1. Ricerca dinamica di MSBuild usando vswhere.exe
Write-Host "Ricerca di Visual Studio in corso..." -ForegroundColor Cyan
$VsWherePath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$MsBuildPath = ""

if (Test-Path $VsWherePath) {
    # Trova la cartella di installazione della versione più recente di Visual Studio
    $VsInstallPath = & $VsWherePath -latest -property installationPath
    if ($VsInstallPath) {
        $MsBuildPath = Join-Path $VsInstallPath "MSBuild\Current\Bin\MSBuild.exe"
        # Controllo di sicurezza per versioni meno recenti di VS
        if (-not (Test-Path $MsBuildPath)) {
            $MsBuildPath = Join-Path $VsInstallPath "MSBuild\15.0\Bin\MSBuild.exe"
        }
    }
}

# Se vswhere fallisce, prova i percorsi hardcoded standard
if (-not (Test-Path $MsBuildPath)) {
    $PathsToTry = @(
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\Msbuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\Msbuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\Msbuild\Current\Bin\MSBuild.exe"
    )
    foreach ($Path in $PathsToTry) {
        if (Test-Path $Path) { $MsBuildPath = $Path; break }
    }
}

if (-not (Test-Path $MsBuildPath)) {
    Write-Error "ERRORE: MSBuild non trovato. Verifica che il Carico di lavoro '.NET Desktop Development' sia installato in Visual Studio."
    exit
}

Write-Host "MSBuild trovato in: $MsBuildPath" -ForegroundColor Green

# 2. Ripulitura della directory di destinazione
Write-Host "[1/4] Ripulitura della directory di destinazione..." -ForegroundColor Cyan
if (Test-Path $OutputDir) {
    Write-Host "Eliminazione di: $OutputDir" -ForegroundColor Yellow
    Remove-Item -Path $OutputDir -Recurse -Force
}
New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null

# 3. Compilazione con MSBuild
Write-Host "[2/4] Ripristino dei pacchetti NuGet..." -ForegroundColor Cyan
& $MsBuildPath $SolutionName -t:restore

if ($LASTEXITCODE -ne 0) {
    Write-Error "ERRORE: La compilazione ha riscontrato dei problemi."
    exit
}

Write-Host "[3/4] Avvio compilazione di $SolutionName (Modalità Release)..." -ForegroundColor Cyan
& $MsBuildPath $SolutionName -p:Configuration=Release -p:Platform="Any CPU"

# 4. Copia dei nuovi file generati in: OutputDir
Write-Host "[4/4] Copia dei nuovi file generati in: $OutputDir" -ForegroundColor Cyan
# $SourceDir = "DXFnest-main\DXFnest\bin\Release"
$SourceDir = Join-Path $ScriptDir "DXFnest-main\DXFnest\bin\Release"

if (Test-Path $SourceDir) {
    Copy-Item -Path "$SourceDir\*" -Destination $OutputDir -Recurse -Force
    Write-Host "Operazione completata con successo! File copiati in $OutputDir" -ForegroundColor Green
} else {
    Write-Error "ERRORE: Cartella dei file compilati non trovata in $SourceDir"
}
