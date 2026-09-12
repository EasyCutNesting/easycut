(defun EseguiEVerificaPS ( / LogPath PathTest FileTest wf Shell Command Process 
                             maxAttesa tempoPassato passoDelay timeoutScaduto status erroreDaMemoria oldEcho)

	(defun MakeTestPS (LogPath  PathTest FileTest FilePs / wf)
		(setq wf (open FilePs "w"))
		(if wf
			(progn
				(write-line "# 1. Forza PowerShell a considerare ogni minimo problema come un errore bloccante" 	wf)
				(write-line "$ErrorActionPreference = \"Stop\""														wf)
				(write-line "try {"																					wf)
				(write-line "# ========================================================================="			wf)
				(write-line "# INSERISCI QUI I TUOI COMANDI REALI"													wf)
				(write-line "# ========================================================================="			wf)
				(write-line "# Esempio 1: Creazione di una cartella"												wf)
				(write-line (strcat "New-Item -Path '" PathTest "' -ItemType Directory -Force") 					wf)
				(write-line "# Esempio 2: Spostamento di un file"													wf)
				(write-line (strcat "Copy-Item -Path '" FileTest "' -Destination '" PathTest "'")					wf)
				(write-line "# ========================================================================="			wf)
				(write-line "# Se lo script arriva qui senza errori, esce comunicando il SUCCESSO (0)"				wf)
				(write-line "Exit 0"																				wf)
				(write-line "}"																						wf)
				(write-line "catch {"																				wf)
				(write-line "	# Crea un file di log nella cartella Temp con data, ora e dettaglio dell'errore" 	wf)
				(write-line (strcat "	$LogPath = '" LogPath "'")													wf)
				(write-line "	$Timestamp = Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""								wf)
				(write-line "	$ErrorMessage = \"[$Timestamp] ERRORE: $($_.Exception.Message)\""					wf)
				(write-line ""																						wf)	
				(write-line "	# Scrive l'errore nel file (crea il file se non esiste, o si appende alla fine)"	wf)
				(write-line "	Out-File -FilePath $LogPath -InputObject $ErrorMessage -Force -Encoding utf8"		wf)
				(write-line ""																						wf)
				(write-line "	# Esce comunque comunicando il FALLIMENTO (1) a Visual LISP"						wf)
				(write-line "	Exit 1"																				wf)
				(write-line "}"																						wf)
				(close wf)
			)
		)
		FilePs
	)
	;
	;Main
	;
	; =========================================================================
	; 1. PREPARAZIONE DEI PERCORSI E DEI FILE TEMPORANEI
	; =========================================================================
  	;; Recupera i percorsi e converti i "\" in "/" per evitare disastri di escape in PowerShell
	(setq LogPath  (vl-string-translate "\\" "/" (strcat (getenv "TEMP") "\\AutoCAD_PS_Error.txt")))
	(setq PathTest (vl-string-translate "\\" "/" (vl-filename-mktemp "test_" (getenv "TEMP") "")))
	(setq FileTest (vl-string-translate "\\" "/" (vl-filename-mktemp)))
  
	;; Crea il file temporaneo di test da copiare
	(setq wf (open FileTest "w"))
	(if wf
		(progn
			(write-line "Test Content" wf)
			(close wf)
			(setq wf nil) ;; <-- CRITICO (Punto 4): Rilascia immediatamente il file sul disco prima che arrivi PowerShell
		)
	)
	; =========================================================================
	; 2. COSTRUZIONE DEL COMANDO POWERSHELL (IN LINEA)
	; =========================================================================
	(setq Command "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File")
	
	;(setq Command 	(strcat	"powershell.exe -NoProfile -WindowStyle Hidden -Command \"& {"
	;						"  $ErrorActionPreference = 'Stop';"
	;						"  try {"
	;						"    New-Item -Path '" PathTest "' -ItemType Directory -Force | Out-Null;"
	;						"    Copy-Item -Path '" FileTest "' -Destination '" PathTest "';"
	;						"    Exit 0;"
	;						"  }"
	;						"  catch {"
	;						"    $LogPath = '" LogPath "';"
	;						"    $Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss';"
	;						"    $ErrorMessage = \\\"[$Timestamp] ERRORE: $($_.Exception.Message)\\\";"
	;						"    try { Out-File -FilePath $LogPath -InputObject $ErrorMessage -Force -Encoding utf8 } catch {}" ;; (Punto 5) Se il file è bloccato, non crashare
	;						"    Write-Error $_.Exception.Message;" ;; Spinge l'errore nello StdErr leggibile in memoria da AutoCAD
	;						"    Exit 1;"
	;						"  }"
	;						"}\""
	;				))

	; =========================================================================
	; 3. ESECUZIONE DEL PROCESSO E CICLO DI ATTESA (CON TIMEOUT)
	; =========================================================================
	;; Disattiva l'eco dei comandi per nascondere il prompt visivo del _.delay
	(setq oldEcho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0) 

	;; Avvia il processo in background
	(setq Shell (vlax-create-object "WScript.Shell"))
	(setq process (vlax-invoke-method Shell 'Exec Command))
  
	;; Configurazione Timeout (Punto 1: Previene il blocco totale di AutoCAD)
	(setq maxAttesa 15000) ; Tempo massimo di attesa (15 secondi)
	(setq tempoPassato 0)  ; Contatore del tempo trascorso
	(setq passoDelay 100)  ; Intervallo di controllo (100 millisecondi)
	(setq timeoutScaduto nil)

	;; Ciclo di monitoraggio dello stato del processo
	(while (and (= (vlax-get-property process 'Status) 0) (not timeoutScaduto))
		(vl-cmdf "_.delay" passoDelay)
		(setq tempoPassato (+ tempoPassato passoDelay))
    
		(if (>= tempoPassato maxAttesa)
			(setq timeoutScaduto t)
		)
	)

	; =========================================================================
	; 4. RECUPERO CODICE DI USCITA ED EVENTUALI ERRORI DALLA MEMORIA (StdErr)
	; =========================================================================
  
	(if timeoutScaduto
		(progn
			(vlax-invoke-method process 'Terminate) ;; Uccide il processo bloccato
			(setq status -1) 
		)
		(progn
			(setq status (vlax-get-property process 'ExitCode))
			;; Se è fallito, leggiamo lo StdErr direttamente dalla memoria RAM (Punto 5)
			(if (/= status 0)
				(progn
					(setq erroreDaMemoria "")
					(while (not (vlax-get-property (vlax-get-property process 'StdErr) 'AtEndOfStream))
						(setq erroreDaMemoria (strcat erroreDaMemoria (vlax-invoke-method (vlax-get-property process 'StdErr) 'ReadLine) "\n"))
					)
				)
			)
		)
	)

	;; Pulizia immediata degli oggetti COM di sistema
	(vlax-release-object shell)
	(vlax-release-object process)
  
	;; Ripristina lo stato originale di AutoCAD
	(setvar "CMDECHO" oldEcho) 

	; =========================================================================
	; 5. GESTIONE E NOTIFICA DEI RISULTATI ALL'UTENTE
	; =========================================================================
	(cond
		((= status 0)
			(alert "COMPLETATO: Lo script PowerShell è andato a buon fine!")
		)
		((= status -1)
			(alert "ERRORE CRITICO: Il processo PowerShell è stato interrotto per TIMEOUT.\nLo script ha impiegato più di 15 secondi o è rimasto appeso.")
		)
		(t
			;; Se abbiamo catturato testo dalla memoria lo mostriamo, altrimenti rimandiamo al file di log
			(if (and erroreDaMemoria (/= erroreDaMemoria ""))
				(alert (strcat "ERRORE DI ATTIVAZIONE POWERSHELL:\n\n" erroreDaMemoria "\nCodice errore di sistema: " (itoa status)))
				(alert (strcat "ERRORE: Lo script interno è fallito.\n\nControlla il file log dettagliato in:\n" LogPath "\n\nCodice di sistema: " (itoa status)))
			)
		)
	)
)
