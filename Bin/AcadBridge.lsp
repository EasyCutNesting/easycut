;;; ------------------------------------------------------------------
;;; AcadBridge.lsp - versione APPUNTI con polling (OpenDCL) 
;;; La pagina HTML copia negli appunti:
;;;     ACADBRIDGE|<id>|<funzione>|<argomento>
;;;     ACADBRIDGE|1792177953334|CatchPaste|2015016 126 1006
;;; Il timer di un form OpenDCL (BRIDGESTART) controlla gli appunti ogni
;;; *BR-INTERVAL* ms. In alternativa BRIDGEINCOLLA fa lo stesso a richiesta.
;;;
;;; Richiede per il polling: runtime OpenDCL e AcadBridge.odcl (progetto
;;; "AcadBridge" con un form "Bridge") nei percorsi di supporto.
;;; ------------------------------------------------------------------
;;; --- Configurazione -----------------------------------------------
(setq *BR-WHITELIST*    '("CatchPaste"))   	; funzioni LISP chiamabili dalla pagina (minuscolo)
(setq *BR-PREFISSO*     "ACADBRIDGE")
(setq *BR-INTERVAL*     500)           		; millisecondi tra un controllo e l'altro
(setq *BR-SCADENZA-MIN* 5)         			; arresto automatico dopo N minuti (nil o 0 = mai)
(setq *BR-RESET-SU-USO* T)         			; T = il conteggio riparte a ogni comando eseguito
											;     (arresto dopo N minuti di INATTIVITA')
											; nil = N minuti dall'avvio, comunque
;;; --- Stato ---------------------------------------------------------
(setq *BR-ULTIMO-ID* nil)
(setq *BR-ESEGUITI*  0)
(setq *BR-ULTIMO*    "(nessuno)")
(setq *BR-ATTIVO*    nil)
(setq *BR-BUSY*      nil)
(setq *BR-INIZIO*    nil)           		; valore di MILLISECS all'avvio (o all'ultimo uso)
;
(defun br-FindEnameBomShape (OrderShape PhaseShape NameShape / LstEnameBom itm Order Phase Name LstRtn)
	;
	; Main +++++
 	;
	(if (and OrderShape PhaseShape NameShape)
		(progn
		
			(setq LstEnameBom (GetLstBlock NameBlockShape$))
			(foreach itm LstEnameBom
				(setq Order (LM:vl-getattributevalue (vlax-ename->vla-object itm) "ORDERSHAPE"))
				(setq Phase (LM:vl-getattributevalue (vlax-ename->vla-object itm) "PHASESHAPE"))
				(setq Name  (LM:vl-getattributevalue (vlax-ename->vla-object itm) "MKSHAPE"))
				(if (and (= (strcase Order T) (strcase OrderShape T))
						 (= (strcase Phase T) (strcase PhaseShape T))
						 (= (strcase Name  T) (strcase NameShape  T))
					)
					(setq LstRtn (append LstRtn (list itm)))
				)
			)
		)
	)
	LstRtn
)
;
(defun CatchPaste (Arg / LstArgs LstEnameBom)

	(if Arg
		(progn
			(setq LstArgs (br-split Arg " "))
			(setq LstEnameBom (br-FindEnameBomShape (car LstArgs) (cadr LstArgs) (caddr LstArgs)))
			(if (= (length lstEnameBom) 1)
			    (ZoomEname (car LstEnameBom) 100)
				(LM:popup "avvertimento" (strcat "Trovato n° " (LM:rtos (length lstEnameBom) 2 0) " pezzi con lo stesso nome") (+ 0 16 4096))
			)
		)
	)
)
;
(defun br-split (s sep / lst p)
	;;; Divide una stringa in una lista usando un separatore
	(while (setq p (vl-string-search sep s))
		(setq lst (cons (substr s 1 p) lst)
			  s   (substr s (+ p 1 (strlen sep)))
		)
	)
	(reverse (cons s lst))
)
;
(defun br-arg-ok (s / ok i c)
;;; Argomento valido: max 200 caratteri, solo lettere, numeri, spazio . - _
	(setq ok (<= (strlen s) 200)
          i  1
	)
	(while (and ok (<= i (strlen s)))
		(setq c  (ascii (substr s i 1))
			  ok 	(or (and (>= c 48) (<= c 57))
						(and (>= c 65) (<= c 90))
						(and (>= c 97) (<= c 122))
						(member c '(32 45 46 95))
					)
			  i     (1+ i)
		)
	)
	(if ok T nil)
)
;
(defun br-leggi-appunti ( / html win cb r)

	;;; Legge il testo dagli appunti. Restituisce una stringa oppure nil.
	(setq html (vl-catch-all-apply 'vlax-create-object '("htmlfile")))
	
	(if (and html (not (vl-catch-all-error-p html)))
		(progn
			(setq r (vl-catch-all-apply
						'(lambda ()
							(setq win (vlax-get-property html 'parentWindow))
							(setq cb  (vlax-get-property win 'clipboardData))
							(vlax-invoke-method cb 'getData "Text")
						)
					)
			)
			;; rilascio degli oggetti ActiveX, in ogni caso
			(foreach o (list cb win html)
				(if (and o (= (type o) 'VLA-OBJECT))
					(vl-catch-all-apply 'vlax-release-object (list o))
				)
			)
			;; normalizzazione del risultato
			(cond
				((vl-catch-all-error-p r) (setq r nil))
				((= (type r) 'STR))
				((= (type r) 'VARIANT)
					(setq r (vl-catch-all-apply 'vlax-variant-value (list r)))
					(if (/= (type r) 'STR) (setq r nil))
				)
				(T 
					(setq r nil)
				)
			)
			r
		)
		nil
	)
)
;
(defun br-parse (txt / parti)
	;;; Scompone il testo: restituisce (id funzione argomento) oppure nil
	;;; se non e' un comando del ponte.
	(if (and txt (> (strlen txt) 0) (<= (strlen txt) 300))
		(progn
			(setq parti (br-split (vl-string-trim " \t\r\n" txt) "|"))
			(if (and (= (length parti) 4) (= (car parti) *BR-PREFISSO*))
				(list (nth 1 parti) (strcase (nth 2 parti) T) (nth 3 parti))
				nil
			)
		)
    nil)
)
;
(defun br-elabora (txt verbose / dati id fn arg r)
	;;; Elabora il testo degli appunti.
	;;; verbose = T  : messaggi anche per appunti vuoti / estranei (comando manuale)
	;;; verbose = nil: silenzioso se non c'e' un comando nuovo (polling)
	(setq dati (br-parse txt))
	(cond
		((not dati)
			(if verbose
				(princ (if (or (not txt) (= txt ""))
						"\n[Bridge] Appunti vuoti o senza testo."
						"\n[Bridge] Gli appunti non contengono un comando del ponte.")
				)
			)
		)
		((= (car dati) *BR-ULTIMO-ID*)
			(if verbose
				(princ "\n[Bridge] Comando gia' elaborato: fai di nuovo clic sul link nella pagina.")
			)
		)
		(T
			(setq id  (car dati)
				  fn  (cadr dati)
				  arg (caddr dati)
			)
			;; segnato subito: anche se viene rifiutato non sara' ripetuto a ogni giro
			(setq *BR-ULTIMO-ID* id)
			(cond
				((not (mapcar '(lambda (x) (strcase x T)) *BR-WHITELIST*))
					(princ (strcat "\n[Bridge] Funzione non consentita: " fn))
				)
				((not (br-arg-ok arg))
					(princ "\n[Bridge] Argomento non valido.")
				)
				(T
					(setq r (vl-catch-all-apply (read fn) (list arg)))
					(if (vl-catch-all-error-p r)
						(princ (strcat "\n[Bridge] Errore in " fn ": "
									(vl-catch-all-error-message r))
						)
						(progn
							(setq 	*BR-ESEGUITI* (1+ *BR-ESEGUITI*)
									*BR-ULTIMO*   (strcat fn "|" arg)
							)
							(if *BR-RESET-SU-USO*
								(setq *BR-INIZIO* (getvar "MILLISECS"))
							)
						)
					)
				)
			)
		)
	)
	(princ)
)
;
(defun br-tick ( / txt)
	;;; Un giro di controllo del polling
	(if (and (not *BR-BUSY*)
             (= (getvar "CMDACTIVE") 0)
		)      ; con un comando in corso riprova al giro dopo
		(progn
			(setq *BR-BUSY* T)
			(setq txt (br-leggi-appunti))
			(if txt
				(vl-catch-all-apply 'br-elabora (list txt nil))
			)
			(setq *BR-BUSY* nil)
		)
	)
	(princ)
)
;
(defun br-ignora-attuale ( / dati)
	;;; All'avvio ignora un eventuale comando vecchio rimasto negli appunti
	(if (setq dati (br-parse (br-leggi-appunti)))
		(setq *BR-ULTIMO-ID* (car dati))
	)
)
;
(defun br-minuti-trascorsi ()
	;;; Minuti trascorsi dall'avvio (o dall'ultimo uso). nil se il polling non e' avviato.
	(if *BR-INIZIO*
		(/ (- (getvar "MILLISECS") *BR-INIZIO*) 60000.0)
	)
)
;
(defun br-scaduto-p ( / m)
	;;; T se il tempo massimo e' scaduto
	(and *BR-SCADENZA-MIN*
		(> *BR-SCADENZA-MIN* 0)
		(setq m (br-minuti-trascorsi))
		(>= m *BR-SCADENZA-MIN*)
	)
)
;
(defun c:AcadBridge/Bridge#OnTimer ( / scaduto)
	;;; Evento del timer del form "Bridge" nel progetto "AcadBridge".
	;;; Il timer scatta una sola volta: va riarmato a ogni evento, anche dopo un errore.
	;;; Se il tempo massimo e' scaduto il polling viene fermato e il timer NON viene riarmato.
	(setq scaduto (vl-catch-all-apply 'br-scaduto-p nil))
	(if (and scaduto (not (vl-catch-all-error-p scaduto)))
		(progn
			(c:BRIDGESTOP)
			(princ (strcat "\n[Bridge] Fermato automaticamente dopo "
                   (rtos *BR-SCADENZA-MIN* 2 0) " minuti. BRIDGESTART per riavviare.")
			)
		)
		(progn
			(vl-catch-all-apply 'br-tick nil)
			(dcl-Form-StartTimer AcadBridge/Bridge *BR-INTERVAL*)
		)
	)
	(princ)
)
;
(defun c:AcadBridge/Bridge#OnInitialize (/ ini)
	(setq ini nil)
)
;
;;; --- Comandi -------------------------------------------------------
;
(defun c:BRIDGESTART ( / Path odcl)
	;; carica il runtime OpenDCL se non c'e' gia'
	(if (not (boundp 'dcl-project-load))
		(command "_OPENDCL")
	)
	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(setq odcl (findfile (strcat Path "\\OpenDCL\\OpenDCLLsp\\ODcl\\AcadBridge.odcl")))
	
	(if odcl
		(progn
			(dcl-Project-Load odcl T)
			(if (boundp 'AcadBridge/Bridge)
				(progn
					(br-ignora-attuale)
					(setq *BR-INIZIO* (getvar "MILLISECS"))
					(dcl-Form-Show AcadBridge/Bridge)               ; form non modale
					(dcl-Form-Hide AcadBridge/Bridge)
					(dcl-Form-StartTimer AcadBridge/Bridge *BR-INTERVAL*)
					(setq *BR-ATTIVO* T)
					(princ "\n[Bridge] Polling avviato.")
				)
				(progn
					(princ (strcat "\n[Bridge] Form 'AcadBridge/Bridge' non definito. File caricato: " odcl))
					(princ "\n[Bridge] Simboli OpenDCL disponibili (progetto/form):")
					(foreach s (vl-remove-if-not
									'(lambda (x) (and (vl-string-search "/" x)
													  (not (vl-string-search "#" x))
												 )
									)
								(atoms-family 1)
								)
								(princ (strcat "\n   " s))
					)
				)
			)
		)
		(princ "\n[Bridge] AcadBridge.odcl non trovato nei percorsi di supporto.")
	)
	(princ)
)
;
(defun c:BRIDGESTOP ()
	(if (and (boundp 'dcl-form-close) (boundp 'AcadBridge/Bridge))
		(vl-catch-all-apply 'dcl-Form-Close (list AcadBridge/Bridge))
	)
	(setq *BR-ATTIVO* nil)
	(princ "\n[Bridge] Polling fermato.")
	(princ)
)
;
(defun c:BRIDGEINCOLLA ()
	;;; Esecuzione a richiesta (senza polling)
	(br-elabora (br-leggi-appunti) T)
	(princ)
)
;
(defun c:BRIDGESTATO ()
	(princ "\n--- AcadBridge (appunti + polling) ---")
	(princ (strcat "\nPolling:    " (if *BR-ATTIVO* "AVVIATO (dall'ultimo BRIDGESTART)" "FERMO")))
	(princ (strcat "\nIntervallo: " (itoa *BR-INTERVAL*) " ms"))
	(princ (strcat "\nScadenza:   "
				(if (and *BR-SCADENZA-MIN* (> *BR-SCADENZA-MIN* 0))
					(strcat (rtos *BR-SCADENZA-MIN* 2 0) " min"
						(if *BR-RESET-SU-USO* " di inattivita'" " dall'avvio")
						(if (and *BR-ATTIVO* (br-minuti-trascorsi))
							(strcat " (trascorsi " (rtos (br-minuti-trascorsi) 2 1) " min)")
							 ""
						)
					)
					"nessuna")
			)
	)
	(princ (strcat "\nFunzioni:   " (apply 'strcat (mapcar '(lambda (x) (strcat x " ")) *BR-WHITELIST*))))
	(princ (strcat "\nEseguiti:   " (itoa *BR-ESEGUITI*)))
	(princ (strcat "\nUltimo:     " *BR-ULTIMO*))
	(princ)
)
;
(defun c:BRIDGEHELP ()
  (princ "\n=== AcadBridge (appunti + polling) - Aiuto ===")
  (princ "\nCOMANDI:")
  (princ "\n  BRIDGESTART      Apre il form e avvia il polling degli appunti")
  (princ "\n  BRIDGESTOP       Chiude il form e ferma il polling")
  (princ "\n  BRIDGEINCOLLA    Esegue a richiesta il comando copiato dalla pagina")
  (princ "\n  BRIDGESTATO      Stato, funzioni consentite, contatore, ultimo comando")
  (princ "\n  BRIDTESTLETTURA  Restituisce il tempo medio di lettura degli appunti")
  (princ "\n  BRIDGEHELP       Mostra questo elenco")
  (princ "\nFUNZIONI CHIAMABILI DALLA PAGINA:")
  (foreach f *BR-WHITELIST* (princ (strcat "\n  " f)))
  (princ "\nFORMATO DEGLI APPUNTI:")
  (princ "\n  ACADBRIDGE|id|funzione|argomento")
  (princ "\nUSO: BRIDGESTART, poi clic sul link Mark nella pagina.")
  (princ)
)
;
(defun c:BRIDTESTLETTURA ( / t0)
  (setq t0 (getvar "MILLISECS"))
  (repeat 20 (br-leggi-appunti))
  (princ (strcat "\nMedia per lettura: "
                 (rtos (/ (- (getvar "MILLISECS") t0) 20.0) 2 1) " ms"))
  (princ)
)