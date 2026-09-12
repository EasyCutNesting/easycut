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
$EasyCutPathInstaller  = $PSScriptRoot
$ReleaseFileName       = Join-Path $EasyCutPathInstaller "Dbase\Release.lsp"

# Nuova destinazione prioritaria richiesta: Cartella \Support locale all'installer
$LocalSupportFolder    = Join-Path $PSScriptRoot "Support"

# Lettura Versione EasyCut
if (Test-Path $ReleaseFileName) {
    $VersionEasyCut = (Get-Content $ReleaseFileName -Raw).Trim()
} else {
    $VersionEasyCut = "?.?.?"
}

# Impostazione Data e Ora
$CurrentDate = Get-Date
$MyDt        = $CurrentDate.ToString("dd-MM-yyyy")
$MyTm        = $CurrentDate.ToString("HH-mm")

Write-Host ""
Write-Host "$MyDt $MyTm"
Write-Host "Configurazione EasyCut $VersionEasyCut"
Write-Host "Lettura registri Autocad -----------------------------------------------------------------------------"

# ++++++++++++++++++++++++++++++
# 2. Lettura Registri AutoCAD
# ++++++++++++++++++++++++++++++
$AutocadVersion = (Get-ItemProperty -Path $AutoCadRegistry -Name CurVer).CurVer
if (-not $AutocadVersion) { Write-Host "[*] Err1.0 AutoCAD non installato" -ForegroundColor Red; pause; exit }

$AutocadSubVersion = (Get-ItemProperty -Path "$AutoCadRegistry\$AutocadVersion" -Name CurVer).CurVer
if (-not $AutocadSubVersion) { Write-Host "[*] Err2.0 AutoCAD non installato" -ForegroundColor Red; pause; exit }

$AutocadProfiles = (Get-ItemProperty -Path "$AutoCadRegistry\$AutocadVersion\$AutocadSubVersion\Profiles" -Name "(Default)")."(Default)"
if (-not $AutocadProfiles) { Write-Host "[*] Err3.0 Profilo AutoCAD non trovato" -ForegroundColor Red; pause; exit }

$GeneralPath = "$AutoCadRegistry\$AutocadVersion\$AutocadSubVersion\Profiles\$AutocadProfiles\General"
$AutocadPath = (Get-ItemProperty -Path $GeneralPath -Name ACAD).ACAD
if (-not $AutocadPath) { Write-Host "[*] Err4.0 Percorso ACAD non trovato" -ForegroundColor Red; pause; exit }

$AutocadDrv  = (Get-ItemProperty -Path $GeneralPath -Name ACADDRV).ACADDRV
if (-not $AutocadDrv) { Write-Host "[*] Err5.0 Percorso ACADDRV non trovato" -ForegroundColor Red; pause; exit }

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

# Array per i file legittimi da mantenere/aggiornare
$FoundAcadDocFiles = @()
# Array per i percorsi EasyCut orfani identificati da eliminare dal registro
$PathsToRemoveFromRegistry = @()

foreach ($Folder in $FoldersList) {
    $CleanFolder = [System.Environment]::ExpandEnvironmentVariables($Folder).Trim()
    $TargetFile  = Join-Path $CleanFolder $FileDoc

    if (Test-Path $TargetFile) {
        # Se il percorso contiene la stringa "EasyCut" o similari
        if ($CleanFolder -match "easy\s*cut") {
            
            # Leggiamo il contenuto per verificare se ha SOLO righe vuote o EasyCut
            $FileContent = Get-Content $TargetFile
            $NonEasyCutLines = $FileContent | Where-Object { $_.Trim() -ne "" -and $_ -notmatch "EasyCut" }
            
            if (-not $NonEasyCutLines) {
                # CANCELLAZIONE: Il file contiene solo vecchie tracce di EasyCut
                Write-Host "[ Eliminato ] Vecchio file EasyCut vuoto/residuo rimosso da: $CleanFolder" -ForegroundColor Magenta
                Remove-Item -Path $TargetFile -Force
                $PathsToRemoveFromRegistry += $CleanFolder
            } else {
                # MANTENIMENTO: Il file contiene codice personalizzato dell'utente, non possiamo cancellarlo
                Write-Host "[ Conservato] Trovato file in cartella EasyCut con codice utente personalizzato: $CleanFolder" -ForegroundColor Yellow
                $FoundAcadDocFiles += $TargetFile
            }
        } else {
            # Percorso standard di AutoCAD (non EasyCut): file considerato legittimo
            $FoundAcadDocFiles += $TargetFile
            Write-Host "[  Trovato  ] $CleanFolder" -ForegroundColor Green
        }
    } else {
        Write-Host "[Non trovato] $CleanFolder" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "- Risultato ----------------------------------------------------------------------------------------"
Write-Host ""

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 4. Creazione / Forzatura del file nella directory locale \Support dell'installer
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Convertiamo il percorso in un path ASSOLUTO e normalizzato per AutoCAD
$AbsoluteSupportFolder = [System.IO.Path]::GetFullPath($LocalSupportFolder)

$LocalTargetFile = Join-Path $AbsoluteSupportFolder $FileDoc
$IsLocalTargetPresent = $FoundAcadDocFiles | Where-Object { $_ -eq $LocalTargetFile }

if (-not $IsLocalTargetPresent) {
    Write-Host "[*] Forzatura creazione file AcadDoc.lsp nella cartella locale \Support..." -ForegroundColor Yellow
    
    # 1. Creazione cartella \Support se mancante
    if (-not (Test-Path $AbsoluteSupportFolder)) {
        New-Item -ItemType Directory -Path $AbsoluteSupportFolder | Out-Null
        if (-not $?) { Write-Host "[*] Errore 4.1: Impossibile creare la cartella Support locale" -ForegroundColor Red; pause; exit }
    }

    # 2. Aggiornamento Registro AutoCAD (Diciamo ad ACAD dove trovare il file inserendo il path alla FINE)
    # Puliamo i vecchi percorsi ed escludiamo eventuali doppioni del nostro percorso assoluto
    $CleanCurrentPaths = $AutocadPath -split ';' | Where-Object { 
        $_.Trim() -ne "" -and [System.Environment]::ExpandEnvironmentVariables($_).Trim() -ne $AbsoluteSupportFolder 
    }
    
    # Ricostruiamo la stringa posizionando la nostra cartella locale alla FINE di tutto
    $NewAcadPath = ($CleanCurrentPaths -join ';') + ";$AbsoluteSupportFolder;"
    Set-ItemProperty -Path $GeneralPath -Name ACAD -Value $NewAcadPath
    if (-not $?) { Write-Host "[*] Errore 4.2: Impossibile registrare la cartella Support nel registro di AutoCAD" -ForegroundColor Red; pause; exit }

    # Sincronizziamo la variabile del percorso di registro e quella della directory principale per la Parte 6
    $AutocadPath = $NewAcadPath
    $PrimaryDirectory = $AbsoluteSupportFolder

    # 3. Creazione del file fisico vuoto
    if (-not (Test-Path $LocalTargetFile)) {
        New-Item -ItemType File -Path $LocalTargetFile -Force | Out-Null
        Write-Host "[+] Creato $LocalTargetFile" -ForegroundColor Green
    }

    # Inseriamo il file in cima all'array come Target principale (Primo file dell'indice)
    $FoundAcadDocFiles = @($LocalTargetFile) + $FoundAcadDocFiles
    Write-Host "[+] AutoCAD è stato configurato per cercare AcadDoc.lsp alla fine dei percorsi, in: $AbsoluteSupportFolder" -ForegroundColor Green
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
# 6. Elaborazione e modifica dei file trovati (Logica Selettiva)
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

# Cartella principale protetta (\Support locale generata in Parte 4)
$PrimaryDirectory = Split-Path $FoundAcadDocFiles

for ($i = 0; $i -lt $FoundAcadDocFiles.Count; $i++) {
    $FileToModify = $FoundAcadDocFiles[$i]
    
    if ($i -eq 0) {
        # ---------------------------------------------------------------------
        # MODIFICA DEL PRIMO FILE (La nostra \Support locale dell'installer)
        # ---------------------------------------------------------------------
        Write-Host "[+] Scrittura configurazione nel target principale: $FileToModify" -ForegroundColor Cyan
        
        # Backup di sicurezza
        $BackupName = "$MyDt-$MyTm-$FileDoc"
        $BackupPath = Join-Path $PrimaryDirectory $BackupName
        Copy-Item -Path $FileToModify -Destination $BackupPath -Force
        
        # Filtro e scrittura del nuovo contenuto
        $ContentLisp = Get-Content $FileToModify
        $CleanContent = $ContentLisp | Where-Object { $_ -notmatch "EasyCut" }
        $FinalContent = $CleanContent + $LispLines
        Set-Content -Path $FileToModify -Value $FinalContent -Encoding ASCII
    } 
    else {
        # ---------------------------------------------------------------------
        # PULIZIA DEI FILE SECONDARI SOPRAVVISSUTI (Nelle cartelle standard)
        # ---------------------------------------------------------------------
        Write-Host "[*] Verifica file secondario in percorso AutoCAD: $FileToModify" -ForegroundColor Yellow
        
        $SecondaryContent = Get-Content $FileToModify
        $NonEasyCutLines = $SecondaryContent | Where-Object { $_.Trim() -ne "" -and $_ -notmatch "EasyCut" }
        
        if (-not $NonEasyCutLines) {
            # Se contiene solo righe EasyCut o righe vuote, lo cancelliamo
            Write-Host "[-] Il file contiene solo vecchie istruzioni EasyCut. Rimozione file." -ForegroundColor Magenta
            Remove-Item -Path $FileToModify -Force
            
            $SecondaryDirectory = Split-Path $FileToModify
            if ($SecondaryDirectory -ne $PrimaryDirectory) { $PathsToRemoveFromRegistry += $SecondaryDirectory }
        } else {
            # Se contiene altro codice utente, lo ripuliamo soltanto senza cancellarlo
            Write-Host "[!] Il file contiene altro codice. Rimuovo solo le righe EasyCut." -ForegroundColor Yellow
            $CleanContent = $SecondaryContent | Where-Object { $_ -notmatch "EasyCut" }
            Set-Content -Path $FileToModify -Value $CleanContent -Encoding ASCII
        }
    }
}

# ---------------------------------------------------------------------
# AGGIORNAMENTO DEL REGISTRO DI AUTOCAD (Rimozione selettiva stringhe EasyCut)
# ---------------------------------------------------------------------
if ($PathsToRemoveFromRegistry.Count -gt 0) {
    Write-Host ""
    Write-Host "[*] Rimozione definitiva dei percorsi EasyCut obsoleti dal registro..." -ForegroundColor Cyan
    
    $CurrentRegistryPaths = $AutocadPath -split ';' | Where-Object { $_ -ne "" }
    $NewRegistryPaths = @()
    
    foreach ($Path in $CurrentRegistryPaths) {
        $CleanRegPath = [System.Environment]::ExpandEnvironmentVariables($Path).Trim()
        
        # Condizioni di cancellazione: segnato per la rimozione, diverso dal principale, e contenente la stringa "EasyCut"
        if ($PathsToRemoveFromRegistry -contains $CleanRegPath -and 
            $CleanRegPath -ne $PrimaryDirectory -and 
            $CleanRegPath -match "easy\s*cut") {
            
            Write-Host "[-] Registro ACAD: Rimosso percorso orfano -> $CleanRegPath" -ForegroundColor Magenta
        } else {
            $NewRegistryPaths += $Path
        }
    }
    
    $UpdatedAcadValue = ($NewRegistryPaths -join ';') + ";"
    Set-ItemProperty -Path $GeneralPath -Name ACAD -Value $UpdatedAcadValue
}

Write-Host ""
Write-Host "Configurazione e ottimizzazione completate su tutti i file." -ForegroundColor Green
Write-Host "Centralizzazione completata nella cartella \Support locale." -ForegroundColor Green
Write-Host "Fine configurazione."
Write-Host ""
pause

