;;; ================================================================
;;; SCRAP SHEET
;;; ================================================================
(defun ScrapSheet:FindScrapRectangles (SheetBox LstShape /
                                       ScrapSheet:UniqueSorted
                                       ScrapSheet:FreeIntervals
                                       ScrapSheet:IntersectIntervals
                                       ScrapSheet:InsideAny-p
                                       ScrapSheet:SortScrapRectangles
                                       Tol MinX MaxX MinY MaxY Boxes Bx V XRaw XList Xs
                                       Slabs SlabI SlabJ PrevSlab NextSlab XI XJ Cur Iv LstRect)

	;; Ordina e toglie i duplicati (con tolleranza)
	(defun ScrapSheet:UniqueSorted (Lst Tol / Result V)
		(foreach V (vl-sort Lst '<)
			(if (or (null Result) (> (- V (car Result)) Tol))
				(setq Result (cons V Result))
			)
		)
		(reverse Result)
	)
	;
	;; Intervalli Y liberi (lista di (Y1 . Y2)) della fetta X0..X1.
	;; Boxes: lista di (XMin XMax YMin YMax) ordinata per YMin crescente.
	(defun ScrapSheet:FreeIntervals (X0 X1 Boxes MinY MaxY Tol / Cursor Result Bx Top)
		(setq Cursor MinY)
		(foreach Bx Boxes
			(if (and (< (nth 0 Bx) (- X1 Tol))
					 (> (nth 1 Bx) (+ X0 Tol))
				)
				(progn
					(setq Top (min (nth 2 Bx) MaxY))
					(if (> (- Top Cursor) Tol)
						(setq Result (cons (cons Cursor Top) Result))
					)
					(if (> (nth 3 Bx) Cursor)
						(setq Cursor (nth 3 Bx))
					)
				)
			)
		)
		(if (> (- MaxY Cursor) Tol)
			(setq Result (cons (cons Cursor MaxY) Result))
		)
		(reverse Result)
	)
	;
	;; Intersezione di due liste ordinate di intervalli (solo lunghezza > Tol)
	(defun ScrapSheet:IntersectIntervals (A B Tol / Result Lo Hi)
		(while (and A B)
			(setq Lo (max (caar A) (caar B))
				  Hi (min (cdar A) (cdar B))
			)
			(if (> (- Hi Lo) Tol)
				(setq Result (cons (cons Lo Hi) Result))
			)
			(if (< (cdar A) (cdar B))
				(setq A (cdr A))
				(setq B (cdr B))
			)
		)
		(reverse Result)
	)
	;
	;; T se l'intervallo Iv e' contenuto in uno degli intervalli di Lst
	(defun ScrapSheet:InsideAny-p (Iv Lst Tol / Found)
		(while (and Lst (not Found))
			(if (and (<= (- (caar Lst) Tol) (car Iv))
					 (>= (+ (cdar Lst) Tol) (cdr Iv))
				)
				(setq Found T)
			)
			(setq Lst (cdr Lst))
		)
		Found
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
					((/= A1 A2) (> A1 A2))
					((/= (car P1) (car P2)) (< (car P1) (car P2)))
					((/= (cadr P1) (cadr P2)) (< (cadr P1) (cadr P2)))
					((/= (car (cadr R1)) (car (cadr R2))) (< (car (cadr R1)) (car (cadr R2))))
					(T (< (cadr (cadr R1)) (cadr (cadr R2))))
				)
			)
		)
	)
	;
	; Main ++++
	;
	(setq 	Tol  1e-8
			MinX (cdr (assoc 'MINX SheetBox))
			MaxX (cdr (assoc 'MAXX SheetBox))
			MinY (cdr (assoc 'MINY SheetBox))
			MaxY (cdr (assoc 'MAXY SheetBox))
	)
	;; Normalizza gli shape (min/max una volta sola) e ordina per YMin
	(setq Boxes
		(vl-sort
			(mapcar
				'(lambda (S / P1 P2)
					(setq P1 (car S)
						  P2 (cadr S)
					)
					(list (min (car P1) (car P2))
						  (max (car P1) (car P2))
						  (min (cadr P1) (cadr P2))
						  (max (cadr P1) (cadr P2))
					)
				)
				LstShape
			)
			'(lambda (A B) (< (nth 2 A) (nth 2 B)))
		)
	)
	;; Coordinate X di taglio (solo quelle interne al foglio)
	(setq XRaw (list MinX MaxX))
	(foreach Bx Boxes
		(foreach V (list (nth 0 Bx) (nth 1 Bx))
			(if (and (> V (+ MinX Tol)) (< V (- MaxX Tol)))
				(setq XRaw (cons V XRaw))
			)
		)
	)
	(setq XList (ScrapSheet:UniqueSorted XRaw Tol))
	;; Intervalli liberi di ogni fetta
	(setq Xs XList
		  Slabs nil
	)
	(while (cdr Xs)
		(setq Slabs (cons (ScrapSheet:FreeIntervals (car Xs) (cadr Xs) Boxes MinY MaxY Tol) Slabs)
			  Xs    (cdr Xs)
		)
	)
	(setq Slabs (reverse Slabs))
	;; Sweep: per ogni fetta di partenza allargo la striscia verso destra
	(setq SlabI    Slabs
		  XI       XList
		  PrevSlab nil
          LstRect  nil
	)
	(while SlabI
		(setq Cur   (car SlabI)
			  SlabJ SlabI
			  XJ    (cdr XI)       ; (car XJ) = X destra della striscia
		)
		(while (and SlabJ Cur)
			(setq NextSlab (cadr SlabJ))
			(foreach Iv Cur
				(if (and (not (ScrapSheet:InsideAny-p Iv NextSlab Tol))   ; non estendibile a destra
						 (not (ScrapSheet:InsideAny-p Iv PrevSlab Tol))   ; non estendibile a sinistra
					)
					(setq LstRect
						(cons (list (list (car XI) (car Iv))
									(list (car XJ) (cdr Iv))
									(* (- (car XJ) (car XI)) (- (cdr Iv) (car Iv)))
							)
							LstRect
						)
					)
				)
			)
			(setq SlabJ (cdr SlabJ)
				  XJ    (cdr XJ)
			)
			(if SlabJ
				(setq Cur (ScrapSheet:IntersectIntervals Cur (car SlabJ) Tol))
			)
		)
		(setq PrevSlab (car SlabI)
			  SlabI    (cdr SlabI)
			  XI       (cdr XI)
		)
	)
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
(defun GetRectSheetAndShape (/ Ssel EnameSheet LstShape itm Shape ShapeBox Sheet SheetBox)

	(prompt "\nSelezionare la lamiera..")
	(setq Ssel (ssget "_+.:E:S" (list (list -3 (list (strcat $RgpSheet "," $RgpSheetTarget))))))
	(if Ssel
		(progn
			(setq EnameSheet (GetEnameSheetByDummyEname (ssname Ssel 0)))
			(if EnameSheet
				(progn
					(setq LstShape (GetEnameShapeByEnameSheet EnameSheet "CE"))
					(foreach itm LstShape
						(setq Shape (BoundingBoxLstEname (list itm)))
						(setq ShapeBox (append ShapeBox (list (list (car Shape) (caddr Shape)))))
					)
					(setq Sheet (BoundingBoxLstEname (list EnameSheet)))
					(setq SheetBox
					  (list
						(vl-list* 'MINX (car  (car Sheet)))
						(vl-list* 'MAXX (car  (caddr Sheet)))
						(vl-list* 'MINY (cadr (car Sheet)))
						(vl-list* 'MAXY (cadr (caddr Sheet)))
					  )
					)
					(ScrapSheet:ChoiseScrap SheetBox ShapeBox)
				)
			)
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
;;; Unione booleana di rettangoli (lati // X e Y)
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
