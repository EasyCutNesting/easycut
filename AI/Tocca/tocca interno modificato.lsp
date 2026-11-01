;;; ============================================================
;;; TOCCA_INTERNO.LSP - Trasla una polilinea A, posizionata
;;;             ALL'INTERNO del contorno di una polilinea B,
;;;             fino al contatto con il bordo interno di B,
;;;             in una direzione data.
;;;
;;; Esempio d'uso: A e' un oggetto/stanza/sagoma dentro un
;;; perimetro B, e si vuole sapere di quanto puo' traslare
;;; prima di toccare la parete (il contorno) di B.
;;;
;;; Script autonomo, non dipende da TOCCA.LSP.
;;;
;;; Comando: TOCCAINT
;;;   1. seleziona il poligono interno da spostare (A)
;;;   2. seleziona il poligono contenitore (B)
;;;   3. scegli la direzione: X+ X- Y+ Y- oppure Angolo
;;;
;;; Vale per poligoni (A e B) concavi o convessi, lati inclinati.
;;; Le polilinee con archi (bulge) non sono supportate.
;;; ============================================================
(setq *ti-eps* 1e-9)
;
(defun ti:cross (u v)
	;; ---- Prodotto vettoriale 2D --------------------------------
	(- (* (car u) (cadr v)) (* (cadr u) (car v)))
)
;
(defun ti:verts (en / pts)
	;; ---- Vertici 2D di una LWPOLYLINE --------------------------
	(foreach g (entget en)
		(if (= (car g) 10)
			(setq pts (cons (list (cadr g) (caddr g)) pts))
		)
	)
	(reverse pts)
)
;
(defun ti:has-bulge (en)
	;; ---- Controllo: solo segmenti rettilinei -------------------
	(vl-some
		'(lambda (g) (and (= (car g) 42) (> (abs (cdr g)) 1e-12)))
		(entget en)
	)
)
;
(defun ti:edges (pts / res n i)
	;; ---- Lati del poligono (sempre chiuso): lista di (q1 q2) ---
	(setq n (length pts) i 0)
	(repeat n
		(setq res (cons (list (nth i pts) (nth (rem (1+ i) n) pts)) res))
		(setq i (1+ i))
	)
	(reverse res)
)
;
(defun ti:point-inside-p (pt edges / cnt x y p1 p2 x1 y1 x2 y2 xinters)
	;; ---- Un punto e' dentro il poligono definito da 'edges'?
	;;      Crossing-number test (raggio orizzontale verso +X),
	;;      valido anche per poligoni concavi. --------------------
	(setq cnt 0 x (car pt) y (cadr pt))
	(foreach ed edges
		(setq p1 (car ed) p2 (cadr ed)
			  x1 (car p1) y1 (cadr p1)
			  x2 (car p2) y2 (cadr p2)
		)
		(if (and (/= y1 y2)
				 (>= y (min y1 y2))
				 (<  y (max y1 y2))
			)
			(progn
				(setq xinters (+ x1 (/ (* (- y y1) (- x2 x1)) (- y2 y1))))
				(if (> xinters (+ x *ti-eps*)) (setq cnt (1+ cnt)))
			)
		)
	)
	(= (rem cnt 2) 1)
)
;
(defun ti:contained-p (va edges-b)
	;; ---- Tutti i vertici di A sono dentro B? Ritorna T/nil ------
	(vl-every '(lambda (p) (ti:point-inside-p p edges-b)) va)
)
;
(defun ti:orient (edges / a)
	;; ---- Orientamento di un poligono dai suoi lati:
	;;      +1.0 antiorario, -1.0 orario ---------------------------
	(setq a 0.0)
	(foreach ed edges
		(setq a (+ a (ti:cross (car ed) (cadr ed))))
	)
	(if (>= a 0.0) 1.0 -1.0)
)
;
(defun ti:ray (pts edges d ext / best q1 q2 e den w tt s sgn cr)
	;; ext = T  : 'edges' e' il contenitore B, il contatto a zero blocca
	;;            solo se d punta verso l'ESTERNO del poligono.
	;; ext = nil: 'edges' e' A, il contatto a zero blocca solo se d
	;;            entra nell'INTERNO del poligono.
	(setq sgn (ti:orient edges))
	(foreach ed edges
		(setq q1  (car ed)
			  q2  (cadr ed)
			  e   (list (- (car q2) (car q1)) (- (cadr q2) (cadr q1)))
			  den (ti:cross d e)
		)
		(if (> (abs den) *ti-eps*)
			(foreach p pts
				(setq w  (list (- (car q1) (car p)) (- (cadr q1) (cadr p)))
					  tt (/ (ti:cross w e) den)
					  s  (/ (ti:cross w d) den)
					  cr (* sgn (ti:cross e d))
				)
				(if (and (>= tt (- *ti-eps*))
						 (>= s  (- *ti-eps*))
						 (<= s  (+ 1.0 *ti-eps*))
						 ;; contatto gia' in atto (tt ~ 0): vale solo se
						 ;; il movimento attraversa il bordo di B
						 (or (> tt *ti-eps*)
							 (if ext
								 (< cr (- *ti-eps*))
								 (> cr *ti-eps*)
							 )
						 )
					)
					(setq tt   (max tt 0.0)
						  best (if best (min best tt) tt)
					)
				)
			)
		)
	)
	best
)
;
(defun ti:distance (va edges-a vb edges-b d / r1 r2 dneg)
	;; ---- Distanza di traslazione di A, verso d, fino al contatto
	;;      col bordo interno di B. Combina entrambe le direzioni
	;;      di raggio (vertici di A contro lati di B, e viceversa),
	;;      cosi' funziona anche se B e' concavo (es. A si incastra
	;;      in una rientranza). Ritorna nil se non c'e' contatto. --
	(setq dneg 	 (list (- (car d)) (- (cadr d)))
			r1   (ti:ray va edges-b d    T)      ; vertici A -> lati B
			r2   (ti:ray vb edges-a dneg nil)    ; vertici B -> lati A
	)
	(cond
		((and r1 r2) (min r1 r2))
		(r1 r1)
		(r2 r2)
	)
)
;
(defun ti:pick (msg / sel en)
	;; ---- Selezione di una LWPOLYLINE valida --------------------
	(while (not en)
		(setq sel (entsel msg))
		(cond
			((null sel) 
				(setq en 'annulla)
			)
			((/= (cdr (assoc 0 (entget (car sel)))) "LWPOLYLINE")
				(princ "\nL'oggetto non e' una LWPOLYLINE.")
			)
			((ti:has-bulge (car sel))
				(princ "\nLa polilinea contiene archi: non supportata.")
			)
			(T 
				(setq en (car sel))
			)
		)
	)
	(if (= en 'annulla) nil en)
)
;
(defun ti:MoveShape (EnameShape InfoMove / tt Direction)
	(if (and EnameShape InfoMove)
		(progn
			;(princ "\nDato 1") (princ (car  InfoMove))
			;(princ "\nDato 2") (princ (cadr InfoMove))
			(setq tt        (car  InfoMove))
			(setq Direction (cadr InfoMove))
			(vla-move	(vlax-ename->vla-object EnameShape)
						(vlax-3d-point '(0.0 0.0 0.0))
						(vlax-3d-point (list (* tt (car Direction)) (* tt (cadr Direction)) 0.0))
			)
		)
	)
)
;
(defun ti:FenceShapeToSheet (EnameShape EnameSheet Direction Verbose / 
							 va edges-a vb edges-b tt ok Rtn)
	
	(if (and EnameShape EnameSheet Direction)
		(progn
			(setq 	va      (ti:verts EnameShape)
					edges-a (ti:edges va)
					vb      (ti:verts EnameSheet)
					edges-b (ti:edges vb)
			)
			;; --- verifica che A sia davvero dentro B -----------------
			(setq ok (ti:contained-p va edges-b))
			(if (and (not ok) Verbose)
				(princ "\nAttenzione: almeno un vertice di A risulta FUORI dal contorno di B. Il calcolo prosegue comunque, ma il risultato va verificato.")
			)
			(setq tt (ti:distance va edges-a vb edges-b Direction))
			(cond
				((null tt)
					(if Verbose
						(princ "\nNessun contatto trovato con il bordo di B in questa direzione.")
					)
				)
				(T
					(if (> tt 0.0)
						(setq Rtn (list tt Direction))
					)
					(if Verbose
						(princ (strcat "\nTraslato di " (rtos tt 2 6) " unita' fino al contatto con B."))
					)
				)
			)
		)
	)
	Rtn
)
;
;; ---- Comando principale ------------------------------------
;
(defun C:TOCCAINT (/ ea eb va edges-a vb edges-b kw ang d)

	(if (and (setq ea (ti:pick "\nSeleziona il poligono interno da spostare (A): "))
			 (setq eb (ti:pick "\nSeleziona il poligono contenitore (B): "))
		)
		(progn
			(initget "X+ X- Y+ Y- Angolo")
			(setq kw (getkword "\nDirezione [X+/X-/Y+/Y-/Angolo] <X+>: "))
			(if (null kw) (setq kw "X+"))
			(cond
				((= kw "X+") (setq d (list  1.0  0.0)))
				((= kw "X-") (setq d (list -1.0  0.0)))
				((= kw "Y+") (setq d (list  0.0  1.0)))
				((= kw "Y-") (setq d (list  0.0 -1.0)))
				(T
					(setq ang (getangle "\nAngolo di traslazione: "))
					(if ang (setq d (list (cos ang) (sin ang))))
				)
			)
			(setq DataPos (ti:FenceShapeToSheet ea eb d T))
			(if DataPos
				(ti:MoveShape ea DataPos)
			)
		)
		(princ "\nNessun poligono selezionato.")
	)
	(princ)
)
(princ "\nComando TOCCAINT caricato.")
(princ)
