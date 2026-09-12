$PID | Out-File -FilePath "C:\EasyCutNesting Beta\Test\popup_pid.txt" -Encoding ascii -Force
Add-Type -AssemblyName PresentationFramework

# 1. CREAZIONE DELLA FINESTRA (Stile Flat / Frameless)
$form = New-Object System.Windows.Window
$form.Width = 420
$form.Height = 160
$form.WindowStartupLocation = "CenterScreen"
$form.Topmost = $true
$form.ResizeMode = "NoResize"
$form.WindowStyle = "None"
$form.AllowsTransparency = $true
$form.Background = "Transparent" # Permette l'arrotondamento degli angoli del bordo

# 2. CONTENITORE PRINCIPALE (StackPanel per disporre gli elementi in verticale)
$panel = New-Object System.Windows.Controls.StackPanel
$panel.VerticalAlignment = "Center"
$panel.Margin = "25"

# 3. TESTO PRINCIPALE
$textTitle = New-Object System.Windows.Controls.TextBlock
$textTitle.Text = "ELABORAZIONE DATI"
$textTitle.FontFamily = "Segoe UI"
$textTitle.FontSize = 14
$textTitle.FontWeight = "Bold"
$textTitle.Foreground = "#107C41" # Verde professionale (cambia in "#0078D4" per il blu Windows)
$textTitle.HorizontalAlignment = "Center"
$textTitle.Margin = "0,0,0,5"

# 4. SOTTOTESTO
$textSub = New-Object System.Windows.Controls.TextBlock
$textSub.Text = "Calcolo del nesting in corso... Attendere prego."
$textSub.FontFamily = "Segoe UI"
$textSub.FontSize = 12
$textSub.Foreground = "#CCCCCC" # Grigio chiaro per il testo secondario
$textSub.HorizontalAlignment = "Center"
$textSub.Margin = "0,0,0,20"

# 5. BARRA DI AVANZAMENTO ANIMATA (Indeterminata)
$progressBar = New-Object System.Windows.Controls.ProgressBar
$progressBar.Height = 4
$progressBar.IsIndeterminate = $true # Crea l'animazione a scorrimento continuo
$progressBar.Foreground = "#107C41"  # Colore della barra animata
$progressBar.Background = "#333333"  # Sfondo della barra vuota
$progressBar.BorderThickness = "0"

# Assemblaggio degli elementi nel pannello
$null = $panel.Children.Add($textTitle)
$null = $panel.Children.Add($textSub)
$null = $panel.Children.Add($progressBar)

# 6. BORDO ESTERNO CON ANGOLI ARROTONDATI (Contenitore estetico)
$border = New-Object System.Windows.Controls.Border
$border.BorderThickness = "1"
$border.BorderBrush = "#444444"       # Bordo grigio scuro sottile
$border.Background = "#1E1E1E"        # Sfondo antracite scuro (Stile CAD)
$border.CornerRadius = "8"             # Curvatura degli angoli (in pixel)
$border.Child = $panel

# Assegna il bordo alla finestra
$form.Content = $border

# Mostra la finestra dialog
$form.ShowDialog()
