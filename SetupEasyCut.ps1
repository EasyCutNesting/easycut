# =================================================================================
# PARTE 1: Inizializzazione, Variabili e Lettura Registri AutoCAD
# =================================================================================

# Disabilita l'output di errore non gestito e pulisce la console
$ErrorActionPreference = "SilentlyContinue"
Clear-Host

# Definizione delle variabili d'ambiente e percorsi di registro
$CurrentUser            = "HKCU:\"
$FolderApp              = "EasyCut"
$StartupFileEasyCut     = "StartEasyCut.lsp"
$EasyCutRegistry        = "Software\EasyCut"
$AutoCadRegistry        = "Software\Autodesk\AutoCAD"

# Identificazione dinamica della cartella dello script corrente (sostituisce %~dp0)
$ScriptPath             = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ReleaseFileName        = Join-Path $ScriptPath "Dbase\Release.lsp"

$FileDoc                = "AcadDoc.lsp"
$EasyCutPathInstaller   = $ScriptPath

# Lettura sicura della versione dal file di Release
$VersionEasyCut         = (Get-Content -Path $ReleaseFileName -ErrorAction SilentlyContinue).Trim()

$Label                  = "EasyCut"
$FileEmpty              = "0"
$LstStr                 = ";"

# Inizializzazione delle variabili di AutoCAD
$AutocadVersion         = "-"
$AutocadSubVersion      = "-"
$AutocadProfiles        = "-"
$AutocadPath            = "-"
$AutocadDrv             = "-"
$PathAcadDoc            = "-"
$FullNameAcadDoc        = "-"

# Impostazione Data e Ora (Ottimizzato Get-Date a una sola chiamata)
$CurrentDate = Get-Date
$MyDt        = $CurrentDate.ToString("dd-MM-yyyy")
$MyTm        = $CurrentDate.ToString("HH-mm")


# Creazione del file di Log nella directory Temp dell'utente
$TempLog = Join-Path $env:TEMP "InstallEasyCut.log"
"" | Out-File -FilePath $TempLog -Encoding ascii

Write-Host ""
Write-Host "$MyDt $MyTm"
Write-Host "Configurazione EasyCut $VersionEasyCut"
Write-Host ""
Write-Host "Lettura registri Autocad -----------------------------------------------------------------------------"

# 1. Lettura CurVer principale
$RegMainPath = Join-Path $CurrentUser $AutoCadRegistry
$AutocadVersion = (Get-ItemProperty -Path $RegMainPath -Name CurVer -ErrorAction SilentlyContinue).CurVer
if (-not $AutocadVersion) { throw "AcadErr1" }

# 2. Lettura CurVer secondaria (SubVersion)
$RegSubPath = Join-Path $RegMainPath $AutocadVersion
$AutocadSubVersion = (Get-ItemProperty -Path $RegSubPath -Name CurVer -ErrorAction SilentlyContinue).CurVer
if (-not $AutocadSubVersion) { throw "AcadErr2" }

# 3. Lettura Profilo di Default
$RegProfilePath = "$RegSubPath\$AutocadSubVersion\Profiles"
$AutocadProfiles = (Get-ItemProperty -Path $RegProfilePath -Name "(default)" -ErrorAction SilentlyContinue)."(default)"
if (-not $AutocadProfiles) { throw "AcadErr3" }

# 4. Lettura del percorso ACAD generale
$RegGeneralPath = "$RegProfilePath\$AutocadProfiles\General"
$AutocadPath = (Get-ItemProperty -Path $RegGeneralPath -Name ACAD -ErrorAction SilentlyContinue).ACAD
if (-not $AutocadPath) { throw "AcadErr4" }

# 5. Lettura del percorso ACADDRV e composizione della lista cartelle
$AutocadDrv = (Get-ItemProperty -Path $RegGeneralPath -Name ACADDRV -ErrorAction SilentlyContinue).ACADDRV
if (-not $AutocadDrv) {
    $ListFolders = $AutocadPath
} else {
    $ListFolders = "$AutocadPath;$AutocadDrv"
}

# Output riepilogativo delle informazioni rilevate
Write-Host ""
Write-Host "Informazioni Autocad ---------------------------------------------------------------------------------"
Write-Host ""
Write-Host "+ Autocad Version    `"$AutocadVersion`""
Write-Host "+ Autocad Subversion `"$AutocadSubVersion`""
Write-Host "+ Autocad Profile    `"$AutocadProfiles`""
Write-Host ""
Write-Host "------------------------------------------------------------------------------------------------------"

# =================================================================================
# PARTE 2: Rimozione Vecchie Installazioni dal Registro ACAD e Scansione Unicita'
# =================================================================================

Write-Host ""
Write-Host "Pulizia Registro ed Esame Percorsi ACAD ---------------------------------------------------------------"
Write-Host ""

# Definisce il percorso esatto della chiave del registro di AutoCAD
$RegGeneralPath = "HKCU:\$AutoCadRegistry\$AutocadVersion\$AutocadSubVersion\Profiles\$AutocadProfiles\General"

# Suddivide tutti i percorsi registrati in ACAD
$RawFolders = $AutocadPath.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)

# Filtra la lista: esclude a monte QUALSIASI vecchio percorso che contenga la parola "EasyCut"
$CleanedFolders = @()
$RegistryChanged = $false

foreach ($Path in $RawFolders) {
    if ($Path -match "EasyCut") {
        Write-Host "[-] Registro: Rimosso vecchio puntamento rimasto in ACAD -> $Path" -ForegroundColor Yellow
        $RegistryChanged = $true
    } else {
        $CleanedFolders += $Path
    }
}

# Se sono state trovate e rimosse vecchie installazioni nel registro, aggiorna la chiave ACAD
if ($RegistryChanged) {
    $AutocadPath = ($CleanedFolders -join ";") + ";"
    try {
        Set-ItemProperty -Path $RegGeneralPath -Name "ACAD" -Value $AutocadPath -Force
        Write-Host "[+] Registro ACAD ripulito correttamente dalle vecchie installazioni." -ForegroundColor Green
    } catch {
        Write-Host "[-] Errore: Impossibile aggiornare la chiave di registro durante la pulizia." -ForegroundColor Red
    }
    
    # Aggiorna anche la lista dei folder da scansionare per la ricerca del file lsp
    if (-not $AutocadDrv) {
        $ListFolders = $AutocadPath
    } else {
        $ListFolders = "$AutocadPath;$AutocadDrv"
    }
}

Write-Host ""
Write-Host "Ricerca $FileDoc  ---------------------------------------------------------------------------------"
Write-Host ""

$FolderList = $ListFolders.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)
$FoundCount = 0

foreach ($Folder in $FolderList) {
    $CleanFolder = $Folder.Trim().Trim('"')
    if ($CleanFolder) {
        $CheckFilePath = Join-Path $CleanFolder $FileDoc

        if (Test-Path -Path $CheckFilePath -PathType Leaf) {
            $FoundCount++
            
            # REGOLA 1: Il primo file trovato viene eletto come file unico e ufficiale
            if ($FoundCount -eq 1) {
                $FullNameAcadDoc = $CheckFilePath
                Write-Host "[  Trovato  ] $CleanFolder" -ForegroundColor Green
            } else {
                # REGOLA 1: I file duplicati successivi vengono disattivati rinominandoli in .old
                try {
                    Rename-Item -Path $CheckFilePath -NewName "$FileDoc.old" -Force
                    Write-Host "[  Conflitto ] Rilevato file duplicato in $CleanFolder -> Rinominato in .old" -ForegroundColor Yellow
                } catch {
                    Write-Host "[  Errore   ] Impossibile rimuovere duplicato in $CleanFolder" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "[Non trovato] $CleanFolder" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "- Risultato ----------------------------------------------------------------------------------------"
Write-Host ""

# Se non è stato trovato nessun file AcadDoc.lsp valido in tutto il sistema
if ($FullNameAcadDoc -eq "-") {
    Write-Host "[*] File non trovato $FileDoc (Verra' creato un unico file nuovo)" -ForegroundColor Red
    
	#$AppDataFolder = Join-Path $env:APPDATA "$FolderApp\Support"
	$AppDataFolder = Join-Path  $ScriptPath "\Support"

    if (-not (Test-Path -Path $AppDataFolder)) {
        try {
            New-Item -ItemType Directory -Path $AppDataFolder -Force | Out-Null
        } catch {
            Write-Host "[+]Impossibile creare $AppDataFolder" -ForegroundColor Red
            return
        }
    }

    # Prepara il nuovo tracciato accodando la nuova cartella pulita
    if ($AutocadPath.EndsWith(";")) {
        $NewAcadPath = "$AutocadPath$AppDataFolder$LstStr"
    } else {
        $NewAcadPath = "$AutocadPath;$AppDataFolder$LstStr"
    }

    try {
        Set-ItemProperty -Path $RegGeneralPath -Name "ACAD" -Value $NewAcadPath -Force
    } catch {
        Write-Host "[+]Impossibile aggiornare la variabile PathAutocad" -ForegroundColor Red
        return
    }

    $GoToMakeDocFile = $true

} else {
    Write-Host "[+]File unico identificato: $FullNameAcadDoc" -ForegroundColor Green
    $GoToNextStep = $true
}

Write-Host "----------------------------------------------------------------------------------------------------"

# Gestione eccezioni dei registri (dalla Parte 1)
trap {
    $ErrorMessage = $_.Exception.Message
    switch ($ErrorMessage) {
        "AcadErr1" { Write-Host "[*] Err1 Autocad non installato [EasyCut non funzionera']" -ForegroundColor Red; break }
        "AcadErr2" { Write-Host "[*] Err2 Autocad non installato [EasyCut non funzionera']" -ForegroundColor Red; break }
        "AcadErr3" { Write-Host "[*] Err3 Autocad non installato [EasyCut non funzionera']" -ForegroundColor Red; break }
        "AcadErr4" { Write-Host "[*] Err4 Autocad non installato [EasyCut non funzionera']" -ForegroundColor Red; break }
        default    { Write-Host "[*] Errore generico di configurazione: $ErrorMessage" -ForegroundColor Red }
    }
    return
}

# =================================================================================
# PARTE 3: Creazione/Gestione AcadDoc.lsp e Scrittura Registri EasyCut
# =================================================================================

if ($GoToMakeDocFile) {
	# $FullNameAcadDoc = Join-Path $env:APPDATA "$FolderApp\Support\$FileDoc"
    $FullNameAcadDoc = Join-Path $AppDataFolder "$FileDoc"
    try {
        "" | Out-File -FilePath $FullNameAcadDoc -Encoding ascii -Force
        Write-Host "[+]Creato file unico in: $FullNameAcadDoc" -ForegroundColor Green
        $GoToNextStep = $true
    } catch {
        Write-Host "[-]Impossibile creare il file $FileDoc" -ForegroundColor Red
        return
    }
}

if ($GoToNextStep) {
    $FullRegEasyCutPath = "HKCU:\$EasyCutRegistry"

    try {
        if (-not (Test-Path -Path $FullRegEasyCutPath)) {
            New-Item -Path "HKCU:\Software" -Name "EasyCut" -Force | Out-Null
        }
        
        Set-ItemProperty -Path $FullRegEasyCutPath -Name "(default)" -Value "" -Force
        Set-ItemProperty -Path $FullRegEasyCutPath -Name "FirstInstaller" -Value "1" -Force
        
        $CleanInstallerPath = $EasyCutPathInstaller.TrimEnd('\')
        Set-ItemProperty -Path $FullRegEasyCutPath -Name "PathInstaller" -Value $CleanInstallerPath -Force
        Set-ItemProperty -Path $FullRegEasyCutPath -Name "Version" -Value $VersionEasyCut -Force

        Write-Host "[+]Aggiunto Registri EasyCut" -ForegroundColor Green
        Write-Host "[+]Configurato AcadDoc.lsp" -ForegroundColor Green
    } catch {
        Write-Host "[+]Impossibile aggiungere il registro di EasyCut" -ForegroundColor Red
        return
    }

    # Backup dell'unico file AcadDoc.lsp prima di iniettare le modifiche
    $PathAcadDoc = Split-Path -Parent $FullNameAcadDoc
    $BackupFileName = "$MyDt-$MyTm-$FileDoc"
    $BackupFullPath = Join-Path $PathAcadDoc $BackupFileName

    try {
        Copy-Item -Path $FullNameAcadDoc -Destination $BackupFullPath -Force
    } catch {
        Write-Host "[-]Impossibile creare la copia di backup di $FileDoc" -ForegroundColor Red
    }

    if (Test-Path -Path $FullNameAcadDoc) {
        $FileContent = Get-Content -Path $FullNameAcadDoc -Raw
        
        if ($FileContent -match "EasyCut") {
            $GoToResetFile = $true
        } else {
            $GoToUpdateFile = $true
        }
    }
}

# =================================================================================
# PARTE 4: Reset del File, Integrazione Comandi AutoLISP e Chiusura
# =================================================================================

if ($GoToResetFile) {
    Write-Host "[+]Rimozione vecchie installazioni di EasyCut" -ForegroundColor Green
    
    if (Test-Path -Path $FullNameAcadDoc) {
        $CleanedContent = Get-Content -Path $FullNameAcadDoc | Where-Object { $_ -notmatch $Label }
        $CleanedContent | Out-File -FilePath $FullNameAcadDoc -Encoding ascii -Force
    }
    $GoToUpdateFile = $true
}

if ($GoToUpdateFile) {
    Write-Host "[+]Integrato comandi di EasyCut" -ForegroundColor Green

    $CmdA = "; Start Load Application                                                             ; EasyCut"
    $CmdB = "; Build $MyDt $MyTm                                                          ; EasyCut"
    $CmdC = "; Version EasyCut $VersionEasyCut                                               ; EasyCut"
    $CmdD = "; End Load Application                                                               ; EasyCut"
    $CmdE = "(SearchAndAddTrsPth"
    $CmdF = "(if (not EasyCutRegistryPath$) (load"

    $CurrentLines = @()
    if (Test-Path -Path $FullNameAcadDoc) {
        $CurrentLines = Get-Content -Path $FullNameAcadDoc
    }

    $NewContent = @()
    $NewContent += $CurrentLines
    $NewContent += $CmdA
    $NewContent += $CmdB
    $NewContent += $CmdC

    $SetupLspPath = Join-Path $ScriptPath "Dbase\SetupAcadDoc.lsp"
    if (Test-Path -Path $SetupLspPath) {
        $NewContent += Get-Content -Path $SetupLspPath
    }

    $LispInstallerPath = $EasyCutPathInstaller -replace '\\', '\\'

    # Sostituito con stringhe letterali ad apice singolo per evitare errori di parsing con i doppi apici LISP
    $NewContent += "$CmdE  `"$LispInstallerPath...`")									             ; EasyCut"
    $NewContent += $CmdF + '  "' + $LispInstallerPath + '\\Load\\StartEasyCut.lsp" ""))  			             ; EasyCut'
    $NewContent += $CmdD

    $NewContent | Out-File -FilePath $FullNameAcadDoc -Encoding ascii -Force
}

Write-Host ""
Write-Host "Fine configurazione. Pulizia chiavi ACAD ed esecuzione Regola 1 completata con successo."
Write-Host ""

Read-Host "Premere INVIO per uscire..."

