(defun StartPopupPS (MainText SlaveText / ScriptPath comando)
  
	;; 1. Configura i percorsi (Script e file temporaneo per il PID)
	(setq ScriptPath 				(strcat (getenv "TEMP") "\\EasyCutPopup.ps1"))
	(setq $EasyCutPopupPidPath$ 	(strcat (getenv "TEMP") "\\EasyCutPopup_Pid.txt"))
 
	;; 1.1 Crea il file scriptPath
	(if (MakeScript ScriptPath MainText SlaveText)
		(progn
			;; Rimuove un eventuale vecchio file PID residuo
			(if (findfile $EasyCutPopupPidPath$) (vl-file-delete $EasyCutPopupPidPath$))
			;; 2. Comando pulito accettato dall'antivirus
			(setq comando (strcat "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"" ScriptPath "\""))
			;; 3. Esecuzione nascosta (Parametro 0 = Finestra invisibile)
			(setq $wshShell$ (vlax-create-object "WScript.Shell"))
			(vlax-invoke-method $wshShell$ 'Run comando 0 :vlax-false)
		)
	)
)
;
;
(defun ClosePopupPS ( / fileId pidStr)


	;; 5. RECUPERA IL PID DALL'ARCHIVIO TEMPORANEO E CHIUDI IL POPUP
	(if (findfile $EasyCutPopupPidPath$)
		(progn
			;; Legge il file scritto da PowerShell
			(setq fileId (open $EasyCutPopupPidPath$ "r"))
			(setq pidStr (read-line fileId))
			(close fileId)
      
			;; Chiude il processo in modo mirato tramite il PID estratto
			(vlax-invoke-method $wshShell$ 'Run (strcat "taskkill /f /pid " pidStr) 0 :vlax-false)
      
			;; Cancella il file temporaneo per pulizia
			(vl-file-delete $EasyCutPopupPidPath$)
			;; (princ (strcat "\nPopup con PID " pidStr " chiuso correttamente.\n"))
		)
		(princ "\nErrore: Impossibile trovare il file temporaneo del PID.\n")
	)
	(if $wshShell$
		(progn
			(vlax-release-object $wshShell$)
			(setq $wshShell$ nil)
		)
	)
	(setq $EasyCutPopupPidPath$ nil) 
)
;
;
(defun MakeScriptPS (FileName MainText SlaveText / Stream)
	(setq Stream (open FileName "w"))
	(if Stream
		(progn
			(write-line "$PID | Out-File -FilePath \"$env:TEMP\\EasyCutPopup_Pid.txt\" -Encoding ascii -Force" 					Stream)
			(write-line "Add-Type -AssemblyName PresentationFramework" 															Stream)
			(write-line "# 1. CREAZIONE DELLA FINESTRA (Stile Flat / Frameless)" 												Stream)
			(write-line "$form = New-Object System.Windows.Window" 																Stream)
			(write-line "$form.Width = 420" 																					Stream)
			(write-line "$form.Height = 160" 																					Stream)
			(write-line "$form.WindowStartupLocation = \"CenterScreen\""												 		Stream)
			(write-line "$form.Topmost = $true" 																				Stream)
			(write-line "$form.ResizeMode = \"NoResize\"" 																		Stream)
			(write-line "$form.WindowStyle = \"None\"" 																			Stream)
			(write-line "$form.AllowsTransparency = $true" 																		Stream)
			(write-line "$form.Background = \"Transparent\" # Permette l'arrotondamento degli angoli del bordo" 				Stream)
			(write-line "# 2. CONTENITORE PRINCIPALE (StackPanel per disporre gli elementi in verticale)" 						Stream)
			(write-line "$panel = New-Object System.Windows.Controls.StackPanel" 												Stream)
			(write-line "$panel.VerticalAlignment = \"Center\"" 																Stream)
			(write-line "$panel.Margin = \"25\"" 																				Stream)
			(write-line "# 3. TESTO PRINCIPALE" 																				Stream)
			(write-line "$textTitle = New-Object System.Windows.Controls.TextBlock" 											Stream)
			(write-line (strcat "$textTitle.Text = \"" MainText "\"")															Stream)
			(write-line "$textTitle.FontFamily = \"Segoe UI\"" 																	Stream)
			(write-line "$textTitle.FontSize = 14" 																				Stream)
			(write-line "$textTitle.FontWeight = \"Bold\"" 																		Stream)
			(write-line "$textTitle.Foreground = \"#107C41\" # Verde professionale (cambia in \"#0078D4\" per il blu Windows)" 	Stream)
			(write-line "$textTitle.HorizontalAlignment = \"Center\"" 															Stream)
			(write-line "$textTitle.Margin = \"0,0,0,5\"" 																		Stream)
			(write-line "# 4. SOTTOTESTO"		 																				Stream)
			(write-line "$textSub = New-Object System.Windows.Controls.TextBlock" 												Stream)
			(write-line (strcat "$textSub.Text = \"" SlaveText "\"")															Stream)
			(write-line "$textSub.FontFamily = \"Segoe UI\"" 																	Stream)
			(write-line "$textSub.FontSize = 12" 																				Stream)
			(write-line "$textSub.Foreground = \"#CCCCCC\" # Grigio chiaro per il testo secondario" 							Stream)
			(write-line "$textSub.HorizontalAlignment = \"Center\"" 															Stream)
			(write-line "$textSub.Margin = \"0,0,0,20\"" 																		Stream)
			(write-line "# 5. BARRA DI AVANZAMENTO ANIMATA (Indeterminata)" 													Stream)
			(write-line "$progressBar = New-Object System.Windows.Controls.ProgressBar" 										Stream)
			(write-line "$progressBar.Height = 4" 																				Stream)
			(write-line "$progressBar.IsIndeterminate = $true # Crea l'animazione a scorrimento continuo" 						Stream)
			(write-line "$progressBar.Foreground = \"#107C41\"  # Colore della barra animata" 									Stream)
			(write-line "$progressBar.Background = \"#333333\"  # Sfondo della barra vuota" 									Stream)
			(write-line "$progressBar.BorderThickness = \"0\"" 																	Stream)
			(write-line "# Assemblaggio degli elementi nel pannello" 															Stream)
			(write-line "$null = $panel.Children.Add($textTitle)" 																Stream)
			(write-line "$null = $panel.Children.Add($textSub)" 																Stream)
			(write-line "$null = $panel.Children.Add($progressBar)"		 														Stream)
			(write-line "# 6. BORDO ESTERNO CON ANGOLI ARROTONDATI (Contenitore estetico)" 										Stream)
			(write-line "$border = New-Object System.Windows.Controls.Border" 													Stream)
			(write-line "$border.BorderThickness = \"1\"" 																		Stream)
			(write-line "$border.BorderBrush = \"#444444\"       # Bordo grigio scuro sottile" 									Stream)
			(write-line "$border.Background = \"#1E1E1E\"        # Sfondo antracite scuro (Stile CAD)" 							Stream)
			(write-line "$border.CornerRadius = \"8\"             # Curvatura degli angoli (in pixel)" 							Stream)
			(write-line "$border.Child = $panel" 																				Stream)
			(write-line "# Assegna il bordo alla finestra" 																		Stream)
			(write-line "$form.Content = $border" 																				Stream)
			(write-line "# Mostra la finestra dialog" 																			Stream)
			(write-line "$form.ShowDialog()" 																					Stream)
			(close Stream)
		)
	)
	Stream
)
;
;
(defun c:EseguiMioNesting ( )
  
  ;; 1. Avvia il popup grafico invisibile all'antivirus
  (StartPopup "CONNESSIONE AL SERVER" "... verifica release ...")
  
  ;; Piccola attesa per sicurezza per garantire la scrittura del PID
  (command "_delay" 500) 

  ;; =========================================================================
  ;; 2. INSERISCI QUI IL TUO CODICE REALE DI CALCOLO / NESTING
  ;; =========================================================================
  (princ "\nEsecuzione dell'algoritmo di nesting...")
  
  ;; (TuaFunzioneDiCalcolo) ;; <--- Sostituisci questo commento col tuo codice
  (command "_delay" 4000)   ;; Simulazione del calcolo
  
  ;; =========================================================================

  ;; 3. Chiudi il popup chirurgicamente tramite il PID registrato
  (ClosePopup)
  
  (princ "\nOperazione completata con successo.")
  (princ)
)
