Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CONFIGURAZIONE FILE DI SCAMBIO ---
$tempFile = Join-Path $env:TEMP "EasyCutViewer_next.txt"

# Funzione per leggere il file in modo sicuro ed evitare blocchi
function Get-FileContent($path) {
    if ($path -and (Test-Path $path)) {
        return [System.IO.File]::ReadAllText($path)
    }
    return ""
}

# --- GESTIONE ARGOMENTI (Lettura file passato da LISP) ---
$percorsoFileCorrente = ""
if ($args.Count -gt 0) {
    $percorsoFile = $args
    if (Test-Path $percorsoFile) {
        $percorsoFileCorrente = (Get-Item $percorsoFile).FullName
    }
}

# --- VERIFICA SE LO SCRIPT È GIÀ IN ESECUZIONE (MUTEX SISTEMA) ---
$createdNew = $false
$mutex = New-Object System.Threading.Mutex($true, "Global\EasyCutViewerSingleInstanceMutex", [ref]$createdNew)

if (-not $createdNew) {
    if ($percorsoFileCorrente) {
        [System.IO.File]::WriteAllText($tempFile, $percorsoFileCorrente)
    }
    exit
}

if (Test-Path $tempFile) { Remove-Item $tempFile -Force -ErrorAction SilentlyContinue }

# --- GESTIONE CONFIGURAZIONE (Salvataggio Dimensioni) ---
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrEmpty($scriptPath)) { $scriptPath = "." }
$configFile = Join-Path $scriptPath "EasyCutViewerConfig.json"

$formWidth = 600
$formHeight = 450

if (Test-Path $configFile) {
    try {
        $config = Get-Content $configFile -Raw | ConvertFrom-Json
        if ($config.Width -gt 200) { $formWidth = $config.Width }
        if ($config.Height -gt 200) { $formHeight = $config.Height }
    } catch {}
}

# --- CREAZIONE INTERFACCIA GRAFICA ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "EasyCutViewer"
$form.Size = New-Object System.Drawing.Size($formWidth, $formHeight)
$form.StartPosition = "CenterScreen"
$form.Padding = New-Object System.Windows.Forms.Padding(3, 3, 3, 3)

# 1. TextBox principale per il contenuto del file (Dock Fill)
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
# $textBox.Font = New-Object System.Drawing.Font("Segoe UI Light", 10)
$textBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$textBox.Dock = [System.Windows.Forms.DockStyle]::Fill
if ($percorsoFileCorrente) { $textBox.Text = Get-FileContent $percorsoFileCorrente }
$form.Controls.Add($textBox)

# 2. PANNELLO DISTANZIATORE (Dock Top)
$spacer = New-Object System.Windows.Forms.Panel
$spacer.Height = 3  
$spacer.Dock = [System.Windows.Forms.DockStyle]::Top
$form.Controls.Add($spacer)

# 3. TextBox per il nome completo del file (Dock Top)
$txtNomeFile = New-Object System.Windows.Forms.TextBox
$txtNomeFile.Text = $percorsoFileCorrente
$txtNomeFile.ReadOnly = $true
$txtNomeFile.BackColor = [System.Drawing.Color]::LightGray
$txtNomeFile.Font = New-Object System.Drawing.Font("Segoe UI Semilight", 9.5)
$txtNomeFile.Dock = [System.Windows.Forms.DockStyle]::Top
$form.Controls.Add($txtNomeFile)

# --- TIMER PER CONTROLLO NUOVI FILE (Ogni 200ms) ---
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 200 

$timer.Add_Tick({
    if (Test-Path $tempFile) {
        try {
            $nuovoFile = [System.IO.File]::ReadAllText($tempFile).Trim()
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
            
            if ($nuovoFile -and (Test-Path $nuovoFile)) {
                # Aggiorna i dati nel form
                $txtNomeFile.Text = $nuovoFile
                $textBox.Text = Get-FileContent $nuovoFile
                
                # Porta la finestra in primo piano sopra AutoCAD/BricsCAD
                $form.Activate()
                $form.WindowState = [System.Windows.Forms.FormWindowState]::Normal
                
                # SPOSTATO QUI: Rimuove l'evidenziazione blu DOPO che il form è tornato attivo
                $textBox.SelectionStart = 0
                $textBox.SelectionLength = 0
                $txtNomeFile.SelectionStart = 0
                $txtNomeFile.SelectionLength = 0
                
                # Sposta il focus logico sul Form stesso per evitare che le caselle si autoselezionino
                $form.Focus()
            }
        } catch {}
    }
})

# --- EVENTI DEL FORM ---

$form.Add_Shown({
    $form.Focus()
    $textBox.SelectionStart = 0
    $textBox.SelectionLength = 0
    $txtNomeFile.SelectionStart = 0
    $txtNomeFile.SelectionLength = 0
    $timer.Start()
})

$form.Add_FormClosing({
    $timer.Stop()
    $timer.Dispose()
    
    $mutex.ReleaseMutex()
    $mutex.Dispose()
    
    if (Test-Path $tempFile) { Remove-Item $tempFile -Force -ErrorAction SilentlyContinue }

    $currentSettings = @{
        Width  = $form.Width
        Height = $form.Height
    }
    $currentSettings | ConvertTo-Json | Out-File $configFile -Encoding utf8
})

[void]$form.ShowDialog()
