# ++++++++++++++++++++++++++++++
# 1. Inizializzazione Variabili
# ++++++++++++++++++++++++++++++
# =================================================================================
# Configurazione EasyCut - Script di Installazione Globale PowerShell
# =================================================================================
$ErrorActionPreference = "SilentlyContinue"
Clear-Host

$FolderApp             = "EasyCut"
$FileDoc               = "AcadDoc.lsp"
$EasyCutRegistry       = "HKCU:\Software\EasyCut"
$AutoCadRegistry       = "HKCU:\Software\Autodesk\AutoCAD"
$EasyCutPathInstaller  = $PSScriptRoot + "\"  
$ReleaseFileName       = Join-Path $EasyCutPathInstaller "Dbase\Release.lsp"

# Lettura Versione EasyCut
if (Test-Path $ReleaseFileName) {
    $VersionEasyCut = (Get-Content $ReleaseFileName -Raw).Trim()
} else {
    $VersionEasyCut = "?.?.?"
}

# Impostazione Data e Ora
$MyDt = (Get-Date).ToString("dd-MM-yyyy")
$MyTm = (Get-Date).ToString("HH-mm")

Write-Host ""
Write-Host "$MyDt $MyTm"
Write-Host "Configurazione EasyCut $VersionEasyCut"
Write-Host "Lettura registri Autocad -----------------------------------------------------------------------------"


# ++++++++++++++++++++++++++++++
# 2. Lettura Registri AutoCAD
# ++++++++++++++++++++++++++++++
$AutocadVersion = (Get-ItemProperty -Path $AutoCadRegistry -Name CurVer).CurVer
if (-not $AutocadVersion) { Write-Host "[*] Err1 AutoCAD non installato" -ForegroundColor Red; pause; exit }

$AutocadSubVersion = (Get-ItemProperty -Path "$AutoCadRegistry\$AutocadVersion" -Name CurVer).CurVer
if (-not $AutocadSubVersion) { Write-Host "[*] Err2 AutoCAD non installato" -ForegroundColor Red; pause; exit }

$AutocadProfiles = (Get-ItemProperty -Path "$AutoCadRegistry\$AutocadVersion\$AutocadSubVersion\Profiles" -Name "(Default)")."(Default)"
if (-not $AutocadProfiles) { Write-Host "[*] Err3 AutoCAD non installato" -ForegroundColor Red; pause; exit }

$GeneralPath = "$AutoCadRegistry\$AutocadVersion\$AutocadSubVersion\Profiles\$AutocadProfiles\General"
$AutocadPath = (Get-ItemProperty -Path $GeneralPath -Name ACAD).ACAD
if (-not $AutocadPath) { Write-Host "[*] Err4 AutoCAD non installato" -ForegroundColor Red; pause; exit }

$AutocadDrv  = (Get-ItemProperty -Path $GeneralPath -Name ACADDRV).ACADDRV
if (-not $AutocadDrv) { Write-Host "[*] Err5 AutoCAD non installato" -ForegroundColor Red; pause; exit }

Write-Host ""
Write-Host "Informazioni Autocad ---------------------------------------------------------------------------------"
Write-Host ""
Write-Host " + Autocad Version:    $AutocadVersion"
Write-Host " + Autocad Subversion: $AutocadSubVersion"
Write-Host " + Autocad Profile:    $AutocadProfiles"
Write-Host ""
Write-Host "------------------------------------------------------------------------------------------------------"

# +++++++++++++++++++++++++++++++++++++++++++++++++
# 3. Analisi e Ricerca di TUTTI i file AcadDoc.lsp
# +++++++++++++++++++++++++++++++++++++++++++++++++
Write-Host ""
Write-Host "Ricerca $FileDoc ---------------------------------------------------------------------------------"
Write-Host ""

$RawFolders = "$AutocadPath;$AutocadDrv"
$FoldersList = $RawFolders -split ';' | Where-Object { $_ -ne "" }

# Inizializziamo un array per raccogliere TUTTI i file trovati
$FoundAcadDocFiles = @()

foreach ($Folder in $FoldersList) {
    $CleanFolder = [System.Environment]::ExpandEnvironmentVariables($Folder).Trim()
    $TargetFile  = Join-Path $CleanFolder $FileDoc

    if (Test-Path $TargetFile) {
        $FoundAcadDocFiles += $TargetFile
        Write-Host "[  Trovato  ] $CleanFolder" -ForegroundColor Green
    } else {
        Write-Host "[Non trovato] $CleanFolder" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "- Risultato ----------------------------------------------------------------------------------------"
Write-Host ""
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 4. Se non è stato trovato NESSUN file, ne creiamo uno nel Roaming di default
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if ($FoundAcadDocFiles.Count -eq 0) {
    Write-Host "[*] Nessun file trovato. Creazione percorso di Roaming..." -ForegroundColor Red
    
    $RoamingAppFolder = Join-Path $env:APPDATA $FolderApp
    if (-not (Test-Path $RoamingAppFolder)) {
        New-Item -ItemType Directory -Path $RoamingAppFolder | Out-Null
        if (-not $?) { Write-Host "[+] Impossibile creare la cartella $RoamingAppFolder" -ForegroundColor Red; pause; exit }
    }

    # Aggiornamento Registro AutoCAD (Aggiunta percorso EasyCut)
    $NewAcadPath = if ($AutocadPath -match ";$") { "$AutocadPath$RoamingAppFolder;" } else { "$AutocadPath;$RoamingAppFolder;" }
    Set-ItemProperty -Path $GeneralPath -Name ACAD -Value $NewAcadPath
    if (-not $?) { Write-Host "[+] Impossibile aggiornare la variabile PathAutocad" -ForegroundColor Red; pause; exit }

    # Creazione file vuoto AcadDoc.lsp e inserimento nell'elenco di modifica
    $DefaultFile = Join-Path $RoamingAppFolder $FileDoc
    New-Item -ItemType File -Path $DefaultFile -Force | Out-Null
    $FoundAcadDocFiles += $DefaultFile
    Write-Host "[+] Creato $DefaultFile" -ForegroundColor Green
}
# ++++++++++++++++++++++++++++++++
# 5. Creazione Registri di EasyCut
# ++++++++++++++++++++++++++++++++
if (-not (Test-Path $EasyCutRegistry)) { New-Item -Path $EasyCutRegistry -Force | Out-Null }
Set-ItemProperty -Path $EasyCutRegistry -Name "FirstInstaller" -Value "1" -Type String
Set-ItemProperty -Path $EasyCutRegistry -Name "PathInstaller"  -Value $EasyCutPathInstaller -Type String
Set-ItemProperty -Path $EasyCutRegistry -Name "Version"        -Value $VersionEasyCut -Type String
Write-Host "[+] Aggiunto Registri EasyCut" -ForegroundColor Green
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 6. Elaborazione e modifica di OGNI file trovato nell'array
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
$EscapedPath = $EasyCutPathInstaller.Replace("\", "\\")

# Prepariamo le linee LISP comuni da aggiungere
$LispLines = @(
    "; Start Load Application                                                             ; EasyCut"
    "; Build $MyDt $MyTm                                                          ; EasyCut"
    "; Version EasyCut $VersionEasyCut                                               ; EasyCut"
)
$SetupLispFile = Join-Path $EasyCutPathInstaller "Dbase\SetupAcadDoc.lsp"
if (Test-Path $SetupLispFile) { $LispLines += Get-Content $SetupLispFile }
$LispLines += "(SearchAndAddTrsPth  `"$($EscapedPath)...`")                                              ; EasyCut"
$LispLines += "(if (not EasyCutRegistryPath$) (load  `"$($EscapedPath)Load\\StartEasyCut.lsp`" `"`"))                         ; EasyCut"
$LispLines += "; End Load Application                                                               ; EasyCut"

foreach ($FileToModify in $FoundAcadDocFiles) {
    Write-Host "[+] Elaborazione in corso: $FileToModify" -ForegroundColor Cyan
    
    # Crea il Backup specifico per questo file nella sua stessa cartella
    $BackupName = "$MyDt-$MyTm-$FileDoc"
    $BackupPath = Join-Path (Split-Path $FileToModify) $BackupName
    Copy-Item -Path $FileToModify -Destination $BackupPath -Force
    
    # Legge, pulisce e integra le nuove istruzioni EasyCut
    $ContentLisp = Get-Content $FileToModify
    $CleanContent = $ContentLisp | Where-Object { $_ -notmatch "EasyCut" }
    
    $FinalContent = $CleanContent + $LispLines
    Set-Content -Path $FileToModify -Value $FinalContent -Encoding UTF8
}

Write-Host ""
Write-Host "Configurato AcadDoc.lsp su tutti i file rilevati." -ForegroundColor Green
Write-Host "Fine configurazione."
Write-Host ""
pause
