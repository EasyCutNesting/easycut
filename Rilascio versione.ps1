# --- CONFIGURAZIONE INIZIALE ---
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ReleaseFileName = Join-Path $ScriptDir "Dbase\Release.lsp"
$OutFolderRelease = Join-Path $ScriptDir "Release\Output"

# Legge la versione dal file lsp
$VersionEasyCut = (Get-Content $ReleaseFileName -First 1).Trim()
$REPO = "EasyCutNesting/easycut"
$Pack = "zip"
$TargetFolder = Join-Path $OutFolderRelease $VersionEasyCut

# Generazione della data mancante
$DataOra = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# --- PULIZIA E CREAZIONE CARTELLA OUTPUT ---
if (Test-Path $TargetFolder) {
    Remove-Item $TargetFolder -Recurse -Force
}
New-Item $TargetFolder -ItemType Directory -Force | Out-Null

# --- ELENCO FILTRI ESCLUSIONE 7-ZIP ---
$Excludes = @(
    "-x!*.md",
    "-x!*.ps1", 
    "-x!.git",
    "-x!*.7z", 
    "-x!*.zip", 
    "-x!*.rar", 
    "-x!*.bat", 
    "-x!*.exe", 
    "-x!*.cmd",
    "-x!DosLib", 
    "-x!RectPack", 
    "-x!DxfNest", 
    "-x!Test",
    "-x!Note", 
    "-x!Source", 
    "-x!Release", 
    "-x!VbaModule",
    "-x!StorageApp", 
    "-x!NewApp", 
    "-x!CncTest", 
    "-x!CnCExample",    
    "-x!StorageOldApp", 
    "-x!Tmp",
    "-xr!*.brx", 
    "-xr!*.zrx", 
    "-xr!*.grx", 
    "-xr!_old_builds", 
    "-xr!.vs"
)

# --- COMPRESSIONE CON 7-ZIP ---
$OutputFile = Join-Path $TargetFolder "EasyCut_$($VersionEasyCut).$Pack"
Write-Host "Compressione multi-volume in corso..." -ForegroundColor Cyan

#& "C:\Program Files\7-Zip\7z.exe" a -v5m -bb3 $OutputFile @Excludes . | Out-Host
$CompressOutput = & "C:\Program Files\7-Zip\7z.exe" a -v5m -bb3 $OutputFile @Excludes .
$CompressOutput | Out-Host

# --- CONTEGGIO FILE DENTRO IL MULTI-VOLUME ---
$FirstVolume = "$OutputFile.001"
Write-Host "Scansione dell'archivio appena generato..." -ForegroundColor Cyan

$7zList = & "C:\Program Files\7-Zip\7z.exe" l $FirstVolume
$cnt = 0
foreach ($line in $7zList) {
    if ($line -match '^\s*\d{4}-\d{2}-\d{2}.*?\s(\d+)\s+files,') {
        $cnt = $Matches[1]
        break
    }
}


# --- OPERAZIONI DI RELEASE ---
Copy-Item (Join-Path $ScriptDir "Load\InstallEasyCut.lsp") $TargetFolder

Set-Location $TargetFolder

$Volumi = @(Get-ChildItem "EasyCut_$($VersionEasyCut).$Pack.0*")
$NumVolumi = $Volumi.Count

Write-Host "Generati con successo $NumVolumi Volumi $Pack." -ForegroundColor Green
Write-Host "Archiviati con successo $cnt file reali nel multi-volume." -ForegroundColor Green

# --- CREAZIONE FILE VERSIONE ---
$VersionString = "$VersionEasyCut $NumVolumi $cnt $DataOra`r`n"
$VersionString += "------------------------------`r`n"
$VersionString += "FILE COMPRESSI:`r`n"
$VersionString += "------------------------------`r`n"
# Aggiunge tutte le righe stampate da 7-Zip
foreach ($line in $CompressOutput) {
    $VersionString += "$line`r`n"
}


[System.IO.File]::WriteAllText((Join-Path (Get-Location) "version.txt"), $VersionString)

# --- GITHUB RELEASE ---
Write-Host "Aggiornamento Release GitHub..." -ForegroundColor Yellow
& gh release delete $VersionEasyCut --repo $REPO --yes 2>$null

$UploadFiles = [System.Collections.Generic.List[string]]::new()
foreach ($Volume in $Volumi) {
    $UploadFiles.Add($Volume.FullName)
}
$UploadFiles.Add((Get-Item "version.txt").FullName)
$UploadFiles.Add((Get-Item "InstallEasyCut.lsp").FullName)

& gh release create $VersionEasyCut $UploadFiles `
    --repo $REPO `
    --title "EasyCut $VersionEasyCut" `
    --notes "Release automatica versione $VersionEasyCut"

Start-Process "chrome.exe" "https://github.com/$REPO/releases/latest"
Set-Location $ScriptDir
Read-Host "Procedura completata. Premi INVIO per uscire"
