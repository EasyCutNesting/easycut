;;; ==========================================================================
;;; ALGORITMO NO-FIT POLYGON (NFP) PER POLIGONI CONVESSI IN AUTOLISP
;;; Crea il poligono di vincolo per evitare la sovrapposizione tra due forme.
;;; ==========================================================================

(vl-load-com)

;;; Funzione per calcolare i vettori dei lati di un poligono ordinato in senso antiorario
(defun get-vectors (pts / i p1 p2 vist)
  (setq i 0)
  (while (< i (length pts))
    (setq p1 (nth i pts))
    (setq p2 (nth (rem (1+ i) (length pts)) pts))
    (setq vist (cons (list (- (car p2) (car p1)) (- (cadr p2) (cadr p1))) vist))
    (setq i (1+ i))
  )
  (reverse vist)
)

;;; Calcola l'angolo di un vettore rispetto all'asse X (0 to 2PI)
(defun vec-angle (v)
  (vla-get-angle (vlax-3d-point '(0 0 0)) (vlax-3d-point v)) ; Sfrutta le funzioni ActiveX di AutoCAD
)

;;; Funzione Principale: Calcola l'NFP di due liste di punti convesse (Antiorarie)
;;; PolyA: Poligono Stazionario fissa sul punto (0,0)
;;; PolyB: Poligono Orbitante (il punto di riferimento di B genererà l'NFP)
(defun c:CalcolaNFP ( / ss1 ss2 ptsA ptsB vecA vecB all-vecs start-pt nfp-pts cur-pt)
  
  ;; 1. Selezione delle due polilinee in AutoCAD
  (setq entA (car (entsel "\nSeleziona il Poligono Stazionario (A): ")))
  (setq entB (car (entsel "\nSeleziona il Poligono Orbitante (B): ")))
  
  (if (and entA entB)
    (progn
      ;; Estrarre i vertici delle polilinee (converte in punti 2D XY)
      (setq ptsA (mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget entA))))
      (setq ptsB (mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget entB))))
      
      ;; 2. Generazione dei vettori dei lati
      ;; Per la somma di Minkowski standard, i vettori di B devono essere invertiti (moltiplicati per -1)
      (setq vecA (get-vectors ptsA))
      (setq vecB (mapcar '(lambda (v) (list (- (car v)) (- (cadr v)))) (get-vectors ptsB)))
      
      ;; 3. Unione dei vettori e ordinamento in base all'angolo polare (0 -> 2PI)
      (setq all-vecs (append vecA vecB))
      (setq all-vecs 
        (vl-sort all-vecs 
          '(lambda (v1 v2) (< (atan (cadr v1) (car v1)) (atan (cadr v2) (car v2))))
        )
      )
      
      ;; 4. Calcolo del Punto di Partenza dell'NFP (Somma dei punti più in basso a sinistra)
      ;; Trova il punto più basso di A e il più alto invertito di B
      (setq pA_min (car (vl-sort ptsA '(lambda (p1 p2) (if (= (cadr p1) (cadr p2)) (< (car p1) (car p2)) (< (cadr p1) (cadr p2)))))))
      (setq pB_max (car (vl-sort ptsB '(lambda (p1 p2) (if (= (cadr p1) (cadr p2)) (> (car p1) (car p2)) (> (cadr p1) (cadr p2)))))))
      
      ;; Il punto iniziale dell'NFP unisce il riferimento geometrico dei due minimi/massimi relativi
      (setq start-pt (list (- (car pA_min) (car pB_max)) (- (cadr pA_min) (cadr pB_max))))
      
      ;; 5. Ricostruzione del Poligono NFP integrando i vettori ordinati
      (setq cur-pt start-pt)
      (setq nfp-pts (list cur-pt))
      
      (foreach v all-vecs
        (setq cur-pt (list (+ (car cur-pt) (car v)) (+ (cadr cur-pt) (cadr v))))
        (setq nfp-pts (cons cur-pt nfp-pts))
      )
      (setq nfp-pts (reverse nfp-pts))
      
      ;; 6. Disegno del No-Fit Polygon risultante in AutoCAD come Polilinea rossa
      (command "_._pline")
      (foreach pt nfp-pts (command pt))
      (command "_c")
      
      ;; Cambia il colore dell'ultimo oggetto creato in Rosso per distinguerlo
      (vla-put-color (vlax-ename->vla-object (entlast)) 1) 
      
      (princ "\nNo-Fit Polygon (NFP) generato con successo in rosso.")
    )
    (princ "\nSelezione non valida.")
  )
  (princ)
)

;;; ==========================================================================
;;; ROUTINE DI NESTING AUTOMATICO (BOTTOM-LEFT) IN AUTOLISP
;;; Ordina i pezzi per area e li posiziona sul foglio partendo da in basso a sinistra.
;;; ==========================================================================

(vl-load-com)

;;; Funzione di utilità per calcolare l'area di una polilinea tramite ActiveX
(defun get-area (ename)
  (vlax-get-property (vlax-ename->vla-object ename) 'Area)
)

;;; Funzione di utilità per ottenere il Bounding Box (ingombro minimo) di un oggetto
(defun get-bounding-box (ename / minpoint maxpoint)
  (vla-GetBoundingBox (vlax-ename->vla-object ename) 'minpoint 'maxpoint)
  (list (vlax-safearray->list minpoint) (vlax-safearray->list maxpoint))
)

;;; Sposta un'entità da un punto di origine a un punto di destinazione
(defun move-entity (ename from-pt to-pt)
  (vla-move (vlax-ename->vla-object ename) (vlax-3d-point from-pt) (vlax-3d-point to-pt))
)

;;; FUNZIONE PRINCIPALE DI NESTING
(defun c:EseguiNesting ( / foglio ssPezzi i ent listaPezzi bboxFoglio minFoglio maxFoglio larghFoglio altFoglio curX curY rigaMaxAlt bboxPezzo dimP)
  
  (setvar "CMDECHO" 0)
  
  ;; 1. Selezione del Foglio e dei Pezzi
  (setq foglio (car (entsel "\nSeleziona il rettangolo del FOGLIO di materiale: ")))
  (if (not foglio) (exit))
  
  (princ "\nSeleziona i PEZZI da disporre (Polilinee): ")
  (setq ssPezzi (ssget '((0 . "LWPOLYLINE"))))
  
  (if (and foglio ssPezzi)
    (progn
      ;; 2. Estrazione dati del foglio (punto di origine in basso a sinistra)
      (setq bboxFoglio (get-bounding-box foglio))
      (setq minFoglio (car bboxFoglio))   ; Angolo in basso a sinistra del foglio
      (setq maxFoglio (cadr bboxFoglio))
      (setq larghFoglio (- (car maxFoglio) (car minFoglio)))
      (setq altFoglio (- (cadr maxFoglio) (cadr minFoglio)))
      
      ;; 3. Creazione lista dei pezzi ed ordinamento decrescente per Area (Greedy Approach)
      (setq i 0)
      (setq listaPezzi '())
      (while (< i (sslength ssPezzi))
        (setq ent (ssname ssPezzi i))
        (setq listaPezzi (cons ent listaPezzi))
        (setq i (1+ i))
      )
      
      ;; Ordina i pezzi dal più grande al più piccolo per ottimizzare lo spazio iniziale
      (setq listaPezzi (vl-sort listaPezzi '(lambda (e1 e2) (> (get-area e1) (get-area e2)))))
      
      ;; 4. Algoritmo di posizionamento Bottom-Left (Griglia Euristica Avanzata)
      ;; Inizializza i puntatori di inserimento relativi all'origine del foglio
      (setq curX (car minFoglio))
      (setq curY (cadr minFoglio))
      (setq rigaMaxAlt 0.0) ; Tiene traccia del pezzo più alto nella riga corrente
      
      (princ "\nElaborazione del Nesting in corso...")
      
      (foreach pezzo listaPezzi
        ;; Ottiene l'ingombro del pezzo corrente
        (setq bboxPezzo (get-bounding-box pezzo))
        (setq pMin (car bboxPezzo))
        (setq dimP (list (- (car (cadr bboxPezzo)) (car pMin)) (- (cadr (cadr bboxPezzo)) (cadr pMin)))) ; (Larghezza Altezza)
        
        ;; Verifica se il pezzo ci sta nella riga corrente del foglio
        (if (> (+ curX (car dimP)) (car maxFoglio))
          (progn
            ;; Se supera la larghezza, va a capo alla riga successiva
            (setq curX (car minFoglio))
            (setq curY (+ curY rigaMaxAlt))
            (setq rigaMaxAlt 0.0))
        )
        
        ;; Controllo di sicurezza: il pezzo supera l'altezza massima del foglio?
        (if (> (+ curY (cadr dimP)) (cadr maxFoglio))
          (progn
            (princ (strcat "\n[Attenzione] Spazio insufficiente sul foglio per il pezzo: ")) ; (hl-ename pezzo)))
          )
          (progn
            ;; Muove il pezzo dalla sua posizione originale alla posizione calcolata sul foglio
            (move-entity pezzo pMin (list curX curY 0.0))
            
            ;; Aggiorna la coordinata X per il prossimo pezzo
            (setq curX (+ curX (car dimP)))
            
            ;; Aggiorna l'altezza massima della riga corrente se il pezzo è più alto dei precedenti
            (if (> (cadr dimP) rigaMaxAlt)
              (setq rigaMaxAlt (cadr dimP))
            )
          )
        )
      )
      (princ "\nNesting completato.")
    )
    (princ "\nSelezione non valida o nessun pezzo trovato.")
  )
  
  (setvar "CMDECHO" 1)
  (princ)
)

(princ "\nRoutine caricata. Digita EseguiNesting per avviare il posizionamento.")
(princ)





;;; ==========================================================================
;;; INTEGRAZIONE DEEPNEST CLI CON FILE DI CONFIGURAZIONE JSON
;;; Scrive il file JSON, esporta il DXF e lancia il calcolo in background.
;;; ==========================================================================

(defun c:NestingDeepNestCLI ( / pathCLI fileDXF fileJSON fileOut larghezza altezza spacing rotations f)
  (vl-load-com)
  (setvar "CMDECHO" 0)

  ;; 1. CONFIGURAZIONE DEI PERCORSI (Adatta questi percorsi al tuo sistema)
  (setq pathCLI  "C:\\Users\\adl20\\Downloads\\Deepnest-master\\main.js")              ; Percorso dello script CLI di DeepNest
  (setq fileDXF  "C:\\Tmp\\deepnest_input.dxf")          ; DXF temporaneo inviato a DeepNest
  (setq fileJSON "C:\\Tmp\\deepnest_config.json")       ; JSON generato al volo da AutoLISP
  (setq fileOut  "C:\\Tmp\\deepnest_output.dxf")         ; DXF finale restituito da DeepNest

  ;; 2. RICHIESTA PARAMETRI LAMIERA ALL'UTENTE (Valori di default impostati)
  (setq larghezza  (getreal "\nInserisci LARGHEZZA lamiera (mm) <3000>: "))
  (if (not larghezza) (setq larghezza 3000.0))
  
  (setq altezza    (getreal "\nInserisci ALTEZZA lamiera (mm) <1500>: "))
  (if (not altezza) (setq altezza 1500.0))
  
  (setq spacing    (getreal "\nDistanza minima tra i pezzi (mm) <5>: "))
  (if (not spacing) (setq spacing 5.0))
  
  (setq rotations  (getint "\nNumero di rotazioni per pezzo (2 o 4) <4>: "))
  (if (not rotations) (setq rotations 4))

  ;; 3. GENERAZIONE DINAMICA DEL FILE JSON
  (setq f (open fileJSON "w"))
  (if f
    (progn
      (write-line "{" f)
      (write-line (strcat "  \"sheetWidth\": " (rtos larghezza 2 2) ",") f)
      (write-line (strcat "  \"sheetHeight\": " (rtos altezza 2 2) ",") f)
      (write-line (strcat "  \"sheetSpacing\": " (rtos spacing 2 2) ",") f)
      (write-line (strcat "  \"spaceByPart\": " (rtos spacing 2 2) ",") f)
      (write-line (strcat "  \"rotations\": " (itoa rotations) ",") f)
      (write-line "  \"useHoles\": true" f)
      (write-line "}" f)
      (close f)
      (princ "\nFile di configurazione JSON generato correttamente.")
    )
    (progn
      (princ "\nErrore: Impossibile scrivere il file JSON nella cartella specificata.")
      (exit)
    )
  )

  ;; 4. ESPORTAZIONE DEI PEZZI SELEZIONATI IN DXF
  (princ "\nSeleziona i pezzi (polilinee) da inviare al Nesting: ")
  (setq ssPezzi (ssget '((0 . "LWPOLYLINE"))))
  (if ssPezzi
    (progn
      ;; Forza l'esportazione in versione DXF 2010 (più compatibile con DeepNest)
      (command "_._dxfout" fileDXF "_O" ssPezzi "" "_V" "2010" "")
      
      ;; 5. COMPOSIZIONE DELLA RIGA DI COMANDO ED ESECUZIONE VIA CMD
      ;; Nota: Usiamo Node per lanciare lo script principale passando i flag corretti
      (setq rigaComando (strcat "node \"" pathCLI "\" --input \"" fileDXF "\" --config \"" fileJSON "\" --output \"" fileOut "\""))
      
      (princ "\nAvvio di DeepNest CLI in corso... Attendi il termine del calcolo.")
      ;; Esegue cmd.exe. /c chiude la finestra DOS al termine. /min la avvia ridotta a icona.
      (startapp "cmd.exe" (strcat "/c " rigaComando))
      
      ;; 6. NOTA DI CHIUSURA
      (princ "\nProcesso inviato in background. Verifica la cartella C:\\Temp per il file di output.")
    )
    (princ "\nNessun pezzo selezionato. Operazione annullata.")
  )

  (setvar "CMDECHO" 1)
  (princ)
)

(princ "\nComando caricato. Digita NestingDeepNestCLI per iniziare.")
(princ)
