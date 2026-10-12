;;; ------------------------------------------------------------------
;;; AcadBridge.lsp - versione APPUNTI con polling (OpenDCL)
;;;
;;; La pagina HTML copia negli appunti:
;;;     ACADBRIDGE|<id>|<funzione>|<argomento>
;;; Il timer di un form OpenDCL (BRIDGESTART) controlla gli appunti ogni
;;; *BR-INTERVAL* ms. In alternativa BRIDGEINCOLLA fa lo stesso a richiesta.
;;;
;;; Richiede per il polling: runtime OpenDCL e AcadBridge.odcl (progetto
;;; "AcadBridge" con un form "Bridge") nei percorsi di supporto.
;;; ------------------------------------------------------------------
;;; --- Configurazione ------------------------------------------------
(setq *BR-WHITELIST* '("myfunc"))   ; funzioni LISP chiamabili dalla pagina (minuscolo)
(setq *BR-PREFISSO*  "ACADBRIDGE")
(setq *BR-INTERVAL*  500)          	; millisecondi tra un controllo e l'altro
;;; --- Stato ---------------------------------------------------------
(setq *BR-ULTIMO-ID* nil)
(setq *BR-ESEGUITI*  0)
(setq *BR-ULTIMO*    "(nessuno)")
(setq *BR-ATTIVO*    nil)
(setq *BR-BUSY*      nil)
;
(defun myfunc (arg)
	(if arg
		(princ arg)
	)
)
;
(defun br-split (s sep / lst p)
	;;; Divide una stringa in una lista usando un separatore
	(while (setq p (vl-string-search sep s))
		(setq 	lst (cons (substr s 1 p) lst)
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
		(setq 	c  (ascii (substr s i 1))
				ok 	(or (and (>= c 48) (<= c 57))
						(and (>= c 65) (<= c 90))
						(and (>= c 97) (<= c 122))
						(member c '(32 45 46 95)))
				i  (1+ i)
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
				(T (setq r nil)))
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
		nil
	)
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
			(setq 	id  (car dati)
					fn  (cadr dati)
					arg (caddr dati)
			)
			;; segnato subito: anche se viene rifiutato non sara' ripetuto a ogni giro
			(setq *BR-ULTIMO-ID* id)
			(cond
				((not (member fn *BR-WHITELIST*))
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
						(setq 	*BR-ESEGUITI* (1+ *BR-ESEGUITI*)
								*BR-ULTIMO*   (strcat fn "|" arg)
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
(defun c:AcadBridge/Bridge#OnTimer (/)
	;;; Evento del timer del form "Bridge" nel progetto "AcadBridge".
	;;; Il timer scatta una sola volta: va riarmato a ogni evento, anche dopo un errore.
	(vl-catch-all-apply 'br-tick nil)
	(dcl-Form-StartTimer AcadBridge/Bridge *BR-INTERVAL*)
	(princ)
)
;
(defun c:AcadBridge/Bridge#OnInitialize (/ ini)
  (setq ini nil)
)
;;; --- Comandi -------------------------------------------------------
(defun c:BRIDGESTART ( / odcl)
	;; carica il runtime OpenDCL se non c'e' gia'
	(if (not (boundp 'dcl-project-load))
		(command "_OPENDCL")
	)
	(if (setq odcl (findfile "AcadBridge.odcl"))
		(progn
			(dcl-Project-Load odcl T)
			(if (boundp 'AcadBridge/Bridge)
				(progn
					(br-ignora-attuale)
					(dcl-Form-Show AcadBridge/Bridge)               ; form non modale
					(dcl-Form-StartTimer AcadBridge/Bridge *BR-INTERVAL*)
					(dcl-Form-Hide AcadBridge/Bridge)
					(setq *BR-ATTIVO* T)
					(princ "\n[Bridge] Polling avviato.")
				)
				(progn
					(princ (strcat "\n[Bridge] Form 'AcadBridge/Bridge' non definito. File caricato: " odcl))
					(princ "\n[Bridge] Simboli OpenDCL disponibili (progetto/form):")
					(foreach s 	(vl-remove-if-not
								   '(lambda (x) (and (vl-string-search "/" x)
													 (not (vl-string-search "#" x)))
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
	(princ (strcat "\nFunzioni:   "
                 (apply 'strcat (mapcar '(lambda (x) (strcat x " ")) *BR-WHITELIST*))))
	(princ (strcat "\nEseguiti:   " (itoa *BR-ESEGUITI*)))
	(princ (strcat "\nUltimo:     " *BR-ULTIMO*))
	(princ)
)
;
(defun c:BRIDGEHELP ()
	(princ "\n=== AcadBridge (appunti + polling) - Aiuto ===")
	(princ "\nCOMANDI:")
	(princ "\n  BRIDGESTART    Apre il form e avvia il polling degli appunti")
	(princ "\n  BRIDGESTOP     Chiude il form e ferma il polling")
	(princ "\n  BRIDGEINCOLLA  Esegue a richiesta il comando copiato dalla pagina")
	(princ "\n  BRIDGESTATO    Stato, funzioni consentite, contatore, ultimo comando")
	(princ "\n  BRIDGEHELP     Mostra questo elenco")
	(princ "\nFUNZIONI CHIAMABILI DALLA PAGINA:")
	(foreach f *BR-WHITELIST* 
		(princ (strcat "\n  " f))
	)
	(princ "\nFORMATO DEGLI APPUNTI:")
	(princ "\n  ACADBRIDGE|id|funzione|argomento")
	(princ "\nUSO: BRIDGESTART, poi clic sul link Mark nella pagina.")
	(princ)
)
(princ "\nAcadBridge (appunti + polling) caricato. BRIDGESTART per il polling, BRIDGEINCOLLA a richiesta.")
(princ)
