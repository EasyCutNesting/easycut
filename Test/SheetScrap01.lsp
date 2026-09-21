;;; ================================================================
;;; SCRAP SHEET
;;; ================================================================
(defun ScrapSheet:FindScrapRectangles (SheetBox LstShape /  ScrapSheet:AddUnique
															ScrapSheet:SortNumbers
															ScrapSheet:GetCandidateCoordinates
															ScrapSheet:RectanglesOverlap
															ScrapSheet:RectangleFree
															ScrapSheet:RectangleContained-p
															ScrapSheet:RemoveContainedRectangles
															ScrapSheet:SortScrapRectangles
															Coords XList YList X1 X2 Y1 Y2 Rect Area LstRect)

	(defun ScrapSheet:AddUnique (Value Lst)
		(if (member Value Lst)
			Lst
			(cons Value Lst)
		)
	)
	;
	(defun ScrapSheet:SortNumbers (Lst)
	  (vl-sort Lst '(lambda (A B) (< A B)))
	)
	;
	(defun ScrapSheet:GetCandidateCoordinates (SheetBox LstShape / XList YList MinX MaxX MinY MaxY Shape P1 P2)
		;; Coordinate del foglio
		(setq MinX (cdr (assoc 'MINX SheetBox))
			  MaxX (cdr (assoc 'MAXX SheetBox))
			  MinY (cdr (assoc 'MINY SheetBox))
			  MaxY (cdr (assoc 'MAXY SheetBox))
		)
		(setq XList (list MinX MaxX)
			 YList (list MinY MaxY)
		)
		;; Coordinate degli shape rettangolari
		(foreach Shape LstShape
			(setq P1 (nth 0 Shape)
				  P2 (nth 1 Shape)
			)
			(setq XList (ScrapSheet:AddUnique (car P1) XList))
			(setq XList (ScrapSheet:AddUnique (car P2) XList))
			(setq YList (ScrapSheet:AddUnique (cadr P1) YList))
			(setq YList (ScrapSheet:AddUnique (cadr P2) YList))
		)
		(list (ScrapSheet:SortNumbers XList) (ScrapSheet:SortNumbers YList))
	)
	;
	(defun ScrapSheet:RectanglesOverlap (Rect1 Rect2 / A1 B1 A2 B2 X1Min X1Max Y1Min Y1Max X2Min X2Max Y2Min Y2Max)
		(setq A1 (nth 0 Rect1)
			  B1 (nth 1 Rect1)
			  A2 (nth 0 Rect2)
			  B2 (nth 1 Rect2)
		)
		(setq X1Min (min (car A1) (car B1))
			  X1Max (max (car A1) (car B1))
			  Y1Min (min (cadr A1) (cadr B1))
			  Y1Max (max (cadr A1) (cadr B1))

			  X2Min (min (car A2) (car B2))
			  X2Max (max (car A2) (car B2))
			  Y2Min (min (cadr A2) (cadr B2))
			  Y2Max (max (cadr A2) (cadr B2))
		)
		;; Uso di < e >:
		;; se due rettangoli condividono soltanto un bordo,
		;; non vengono considerati sovrapposti.
		(and (< X1Min X2Max) (> X1Max X2Min) (< Y1Min Y2Max) (> Y1Max Y2Min))
	)
	;
	(defun ScrapSheet:RectangleFree (X1 Y1 X2 Y2 LstShape / Candidate Shape Rtn)
		(setq Candidate (list (list X1 Y1) (list X2 Y2)))
		(setq Rtn T)
		(foreach Shape LstShape
			(if (ScrapSheet:RectanglesOverlap Candidate Shape)
				(setq Rtn nil)
			)
		)
	  Rtn
	)
	;
	(defun ScrapSheet:RectangleContained-p (Rect1 Rect2 / A1 B1 A2 B2 X1Min X1Max Y1Min Y1Max X2Min X2Max Y2Min Y2Max)
		(setq A1 (nth 0 Rect1)
			  B1 (nth 1 Rect1)
			  A2 (nth 0 Rect2)
			  B2 (nth 1 Rect2)
		)
		(setq X1Min (min (car A1) (car B1))
			  X1Max (max (car A1) (car B1))
			  Y1Min (min (cadr A1) (cadr B1))
			  Y1Max (max (cadr A1) (cadr B1))

			  X2Min (min (car A2) (car B2))
			  X2Max (max (car A2) (car B2))
			  Y2Min (min (cadr A2) (cadr B2))
			  Y2Max (max (cadr A2) (cadr B2))
		)
		;; Contenimento stretto:
		;; rettangoli uguali non vengono considerati contenuti.
		(and  (<= X2Min X1Min) (<= X1Max X2Max) (<= Y2Min Y1Min) (<= Y1Max Y2Max)
			  (or (< X2Min X1Min) (< X1Max X2Max) (< Y2Min Y1Min) (< Y1Max Y2Max))
		)
	)
	;
	(defun ScrapSheet:RemoveContainedRectangles (LstRect / Result Rect Other Contained)
		(setq Result nil)
		(foreach Rect LstRect
			(setq Contained nil)
			(foreach Other LstRect
				(if  (and
						(not (equal Rect Other 1e-8))
						(ScrapSheet:RectangleContained-p Rect Other)
					)
					(setq Contained T)
				)
			)
			(if (not Contained)
				(setq Result (cons Rect Result))
			)
		)
		Result
	)
	;
	(defun ScrapSheet:SortScrapRectangles (LstRect)
		(vl-sort LstRect
			'(lambda (R1 R2 / A1 A2 P1 P2)
					(setq A1 (caddr R1)
						  A2 (caddr R2)
						  P1 (car R1)
						  P2 (car R2)
					)
					(cond
						;; Prima area decrescente
						((/= A1 A2)
							(> A1 A2)
						)
						;; Poi X iniziale crescente
						((/= (car P1) (car P2))
							(< (car P1) (car P2))
						)
						;; Poi Y iniziale crescente
						((/= (cadr P1) (cadr P2))
							(< (cadr P1) (cadr P2))
						)
						;; Poi X finale crescente
						((/= (car (cadr R1)) (car (cadr R2)))
							(< (car (cadr R1)) (car (cadr R2)))
						)
						;; Infine Y finale crescente
						(T
							(< (cadr (cadr R1)) (cadr (cadr R2)))
						)
					)
			)
		)
	)
	;
	; Main ++++
	;
	(setq LstRect nil)
	;; Coordinate candidate
	(setq Coords (ScrapSheet:GetCandidateCoordinates SheetBox LstShape))
	(setq	XList (nth 0 Coords)
			YList (nth 1 Coords)
	)
	;; Tutte le combinazioni possibili
	(foreach X1 XList
		(foreach X2 XList
			(if (> X2 X1)
				(foreach Y1 YList
					(foreach Y2 YList
						(if (> Y2 Y1)
							;; Verifica che il rettangolo sia libero
							(if (ScrapSheet:RectangleFree X1 Y1 X2 Y2 LstShape)
								(progn
									(setq Area    (* (- X2 X1) (- Y2 Y1)))
									(setq Rect    (list (list X1 Y1) (list X2 Y2) Area))
									(setq LstRect (cons Rect LstRect))
								)
							)
						)
					)
				)
			)
			)
	)
	;; Elimina i rettangoli contenuti in altri rettangoli
	(setq LstRect (ScrapSheet:RemoveContainedRectangles LstRect))
	;; Ordina per area decrescente
	(ScrapSheet:SortScrapRectangles LstRect)
)
;
;
(defun ScrapSheet:DrawScrapRectangle-p (LstRect Color Highlight)
	(foreach itm LstRect
		(ScrapSheet:DrawScrapRectangle itm 3 1)
	)
)
;
;
(defun ScrapSheet:DrawScrapPoligon (LstPoints Color Highlight / itm Pos P1 P2)
	(if LstPoints
		(foreach itm LstPoints
			(setq Pos 0)
			(repeat (- (length itm) 1)
				(setq P1 (nth Pos itm)
					  P2 (nth (1+ Pos) itm)
				)
				(grdraw P1 P2 Color Highlight)
				(setq Pos (1+ Pos))
			)
			(grdraw (last itm) (car itm) Color Highlight)
		)
	)
)
;
;
(defun ScrapSheet:ChoiseScrap (SheetBox LstShape / FindRect ShapeScrap
												   LstRect Loop gr code data LstPos itm LstRects Rtn)

	(defun FindRect (LstRect Pt / Pos P1 P2 X1 X2 Y1 Y2 LstRtn)
		
		(setq Pos 0)
		(repeat (length LstRect)
			(setq 	P1 (nth 0 (nth Pos LstRect))
					P2 (nth 1 (nth Pos LstRect))
					X1 (car P1)
					Y1 (cadr P1)
					X2 (car P2)
					Y2 (cadr P2)
			)
			(if (and (>= (car  Pt) X1)
					 (<= (car  Pt) X2)
					 (>= (cadr Pt) Y1)
					 (<= (cadr Pt) Y2)
				)
				(setq LstRtn (cons Pos LstRtn))
			)
			(setq Pos (1+ Pos))
		)
		LstRtn
	)
	;
	(defun ShapeScrap (Rect / P1 P2 X1 Y2 X2 Y2)
		(setq P1 (nth 0 Rect)
			  P2 (nth 1 Rect)

			  X1 (car P1)
			  Y1 (cadr P1)

			  X2 (car P2)
			  Y2 (cadr P2)
		)
		;; Angoli del rettangolo
		(list (list (list X1 Y1)
					(list X2 Y1)
					(list X2 Y2)
					(list X1 Y2)
		))
	)
	;
	; Main 
	;
	(setq LstRect (ScrapSheet:FindScrapRectangles SheetBox LstShape))
	(setq Loop T)
	
	(while Loop
		(setq gr (grread 't 15 0) code (car gr) data (cadr gr))
		(cond
			((= Code 2)
				(if (member data '(13 32 69 101)) ; enter space E e
					(progn
						(redraw)
						(setq Loop nil)
					)
				)
			)
			((and (member Code '(5 3)) (listp Data))  ; Mouse rolling
				
				(if (= Code 5)
					(progn
						(if (setq LstPos (FindRect LstRect Data))
							(progn
								(redraw)
								(cond 
									((= (length LstPos) 1)
										(setq Rtn (ShapeScrap (nth (car LstPos) LstRect)))
									)
									((> (length LstPos) 1)
										(setq LstRects nil)
										(foreach itm LstPos
											(setq LstRects (append LstRects (list (nth itm LstRect))))
										)
										(setq Rtn (ScrapSheet:rect-sum LstRects))
									)
								)
								(if Rtn (ScrapSheet:DrawScrapPoligon Rtn 3 1))
							)
						)
					)
				)
				
				(if (= Code 3)						  ; Left click mouse
					(progn
						(redraw)
						(setq Loop nil)
						Rtn
					)
				)
			)
		)
	)
)
;
;
(defun ScrapSheet:DrawScrapRectangle (Rect Color Highlight / P1 P2 X1 Y1 X2 Y2)
	(if (and Rect Color Highlight)
		(progn
			(setq P1 (nth 0 Rect)
				  P2 (nth 1 Rect)

				  X1 (car P1)
				  Y1 (cadr P1)

				  X2 (car P2)
				  Y2 (cadr P2)
			)

			;; Angoli del rettangolo
			(setq P1 (list X1 Y1 0.0)
				  P2 (list X2 Y1 0.0)
				  P3 (list X2 Y2 0.0)
				  P4 (list X1 Y2 0.0)
			)

			;; Lato inferiore
			(grdraw P1 P2 Color Highlight)

			;; Lato destro
			(grdraw P2 P3 Color Highlight)

			;; Lato superiore
			(grdraw P3 P4 Color Highlight)

			;; Lato sinistro
			(grdraw P4 P1 Color Highlight)
		)
	)
)
;
;++++++++++++++++++++++++++++++++++++++++++++++++
; Funzione pubblica (ScrapSheet:FindScrapRectangles SheetBox LstShape)
;	(setq SheetBox '((MINX . 0.0) (MAXX . 12.0) (MINY . 0.0) (MAXY . 8.0)))
;	(setq Shape1   '((4.0 2.0) (7.0 4.0)))
;	(setq Shape2   '((8.0 1.0) (11.0 3.0)))	  
;	(setq Shape3   '((6.0 5.0) (9.0 7.0)))
;	(setq LstShape (list Shape1 Shape2 Shape3))
;;; ================================================================
;;; RECTANGLE UNION
;;; ================================================================
;;; ============================================================
;;; SOMMARECT.LSP - Unione booleana di rettangoli (lati // X e Y)
;;; Comando: RectangleUnion
;;; Semplificazioni: rettangoli con lati paralleli agli assi,
;;; risultato senza fori (se ci fossero, i contorni interni
;;; verrebbero comunque disegnati come polilinee separate).
;;;
;;; Metodo: compressione delle coordinate.
;;;  1. Si raccolgono tutte le X e Y dei rettangoli (uniche, ordinate)
;;;  2. Si crea una griglia di celle: cella piena se contenuta
;;;     in almeno un rettangolo
;;;  3. Si estraggono i lati di bordo delle celle piene (orientati)
;;;  4. Si concatenano i lati in contorni chiusi
;;;  5. Si eliminano i vertici allineati
;;; ============================================================
(setq *ScrapSheet-fuzz* 1e-8)
;; Ordina e toglie i duplicati (con tolleranza)
(defun ScrapSheet:uniq-sort (lst / res)
  (foreach v (vl-sort lst '<)
    (if (or (null res) (> (- v (car res)) *ScrapSheet-fuzz*))
      (setq res (cons v res))
    )
  )
  (reverse res)
)

;; Cella (i,j) della griglia: T se piena, nil se vuota o fuori griglia
(defun ScrapSheet:cell (g i j)
  (and (>= i 0) (>= j 0)
       (< i (length g))
       (nth j (nth i g))
  )
)

;; Toglie i vertici intermedi di tratti rettilinei (punti = coppie di indici)
(defun ScrapSheet:simplify (pts / n i p c nx res)
  (setq n (length pts) i 0)
  (repeat n
    (setq p  (nth (rem (+ i n -1) n) pts)
          c  (nth i pts)
          nx (nth (rem (1+ i) n) pts)
    )
    (if (not (or (= (car p) (car c) (car nx))
                 (= (cadr p) (cadr c) (cadr nx))
             )
        )
      (setq res (cons c res))
    )
    (setq i (1+ i))
  )
  (reverse res)
)

;; Funzione principale
;; rects = lista di (xmin ymin xmax ymax)
;; ritorna una lista di contorni; ogni contorno = lista di punti (x y)
(defun ScrapSheet:union (rects / xs ys g col i j cx cy edges e start cur loop out)
  (setq xs (ScrapSheet:uniq-sort (append (mapcar 'car rects) (mapcar 'caddr rects)))
        ys (ScrapSheet:uniq-sort (append (mapcar 'cadr rects) (mapcar 'cadddr rects)))
  )

  ;; 1) griglia di celle piene
  (setq g nil i 0)
  (repeat (1- (length xs))
    (setq col nil
          j   0
          cx  (/ (+ (nth i xs) (nth (1+ i) xs)) 2.0)
    )
    (repeat (1- (length ys))
      (setq cy (/ (+ (nth j ys) (nth (1+ j) ys)) 2.0))
      (setq col
        (cons
          (if (vl-some
                '(lambda (r)
                   (and (< (car r) cx (caddr r))
                        (< (cadr r) cy (cadddr r))
                   )
                 )
                rects
              )
            T
            nil
          )
          col
        )
      )
      (setq j (1+ j))
    )
    (setq g (cons (reverse col) g))
    (setq i (1+ i))
  )
  (setq g (reverse g))

  ;; 2) lati di bordo, orientati in senso antiorario (materiale a sinistra)
  (setq edges nil i 0)
  (repeat (length g)
    (setq j 0)
    (repeat (length (car g))
      (if (ScrapSheet:cell g i j)
        (progn
          (if (not (ScrapSheet:cell g i (1- j)))       ; sotto vuoto
            (setq edges (cons (list (list i j) (list (1+ i) j)) edges)))
          (if (not (ScrapSheet:cell g (1+ i) j))       ; destra vuota
            (setq edges (cons (list (list (1+ i) j) (list (1+ i) (1+ j))) edges)))
          (if (not (ScrapSheet:cell g i (1+ j)))       ; sopra vuoto
            (setq edges (cons (list (list (1+ i) (1+ j)) (list i (1+ j))) edges)))
          (if (not (ScrapSheet:cell g (1- i) j))       ; sinistra vuota
            (setq edges (cons (list (list i (1+ j)) (list i j)) edges)))
        )
      )
      (setq j (1+ j))
    )
    (setq i (1+ i))
  )

  ;; 3) concatenazione dei lati in contorni chiusi
  (while edges
    (setq e     (car edges)
          edges (cdr edges)
          start (car e)
          cur   (cadr e)
          loop  (list start)
    )
    (while (not (equal cur start))
      (setq loop (cons cur loop))
      (setq e (assoc cur edges))          ; lato che parte da cur
      (if e
        (setq edges (vl-remove e edges)
              cur   (cadr e))
        (setq cur start)                  ; sicurezza: non dovrebbe capitare
      )
    )
    ;; 4) semplificazione e conversione indici -> coordinate
    (setq loop (ScrapSheet:simplify (reverse loop)))
    (setq out
      (cons
        (mapcar '(lambda (p) (list (nth (car p) xs) (nth (cadr p) ys))) loop)
        out
      )
    )
  )
  (reverse out)
)
;; ------------------------------------------------------------
;; FUNZIONE PUBBLICA
;; (ScrapSheet:rect-sum rettangoli)
;;   rettangoli : lista di ((xmin ymin) (xmax ymax))
;;                (i due angoli possono essere in qualsiasi ordine)
;;   ritorna    : lista di contorni, ognuno = lista di punti (x y)
;;
;; Esempio:
;;   (rect-sum '(((0 0) (4 2)) ((2 1) (6 5))))
;;   -> (((0 0) (4 0) (4 1) (6 1) (6 5) (2 5) (2 2) (0 2)))
;;
;; Se il risultato e' un solo contorno: (car (rect-sum ...))
;; ------------------------------------------------------------
(defun ScrapSheet:rect-sum (rects)
  (ScrapSheet:union
    (mapcar
      '(lambda (r / p1 p2)
         (setq p1 (car r) p2 (cadr r))
         (list (min (car p1) (car p2))
               (min (cadr p1) (cadr p2))
               (max (car p1) (car p2))
               (max (cadr p1) (cadr p2))
         )
       )
      rects
    )
  )
)
;; Estrae ((xmin ymin) (xmax ymax)) da una LWPOLYLINE rettangolare, altrimenti nil
(defun ScrapSheet:rect-from-ent (ed / pts xs ys)
  (foreach d ed
    (if (= (car d) 10) (setq pts (cons (cdr d) pts)))
  )
  (if (= (length pts) 4)
    (progn
      (setq xs (ScrapSheet:uniq-sort (mapcar 'car pts))
            ys (ScrapSheet:uniq-sort (mapcar 'cadr pts))
      )
      (if (and (= (length xs) 2) (= (length ys) 2))
        (list (list (car xs) (car ys)) (list (cadr xs) (cadr ys)))
      )
    )
  )
)
;; Disegna una polilinea chiusa
(defun ScrapSheet:make-pline (pts layer)
  (entmake
    (append
      (list '(0 . "LWPOLYLINE")
            '(100 . "AcDbEntity")
            (cons 8 layer)
            '(100 . "AcDbPolyline")
            (cons 90 (length pts))
            '(70 . 1)
      )
      (mapcar '(lambda (p) (cons 10 p)) pts)
    )
  )
)
;; Comando
(defun c:RectangleUnion (/ ss i ed r rects skip loops kw)
  (prompt "\nSeleziona i rettangoli (polilinee chiuse a 4 vertici, lati // agli assi): ")
  (if (setq ss (ssget '((0 . "LWPOLYLINE"))))
    (progn
      (setq i 0 skip 0)
      (repeat (sslength ss)
        (setq ed (entget (ssname ss i)))
        (if (setq r (ScrapSheet:rect-from-ent ed))
          (setq rects (cons r rects))
          (setq skip (1+ skip))
        )
        (setq i (1+ i))
      )
      (if (> skip 0)
        (prompt (strcat "\n" (itoa skip) " oggetti ignorati (non sono rettangoli ortogonali)."))
      )
      (if rects
        (progn
          (setq loops (rect-sum rects))
          (foreach l loops (ScrapSheet:make-pline l (getvar "CLAYER")))
          (prompt (strcat "\nCreati " (itoa (length loops)) " contorni."))
          (initget "Si No")
          (setq kw (getkword "\nCancellare i rettangoli originali? [Si/No] <No>: "))
          (if (= kw "Si")
            (progn
              (setq i 0)
              (repeat (sslength ss)
                (if (ScrapSheet:rect-from-ent (entget (ssname ss i)))
                  (entdel (ssname ss i))
                )
                (setq i (1+ i))
              )
            )
          )
        )
        (prompt "\nNessun rettangolo valido selezionato.")
      )
    )
  )
  (princ)
)
;
;
;(prompt "\nCaricato: SOMMARECT (unione booleana di rettangoli).")
;(princ)