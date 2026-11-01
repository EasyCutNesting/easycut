;;; ============================================================
;;; Trasla una polilinea (A) fino al contatto con la
;;; prima di una lista di polilinee (B1, B2, ...),
;;; in una direzione data.
;;;
;;; Prima del calcolo vero e proprio, la lista di B viene
;;; filtrata: se un B piu' vicino ad A, lungo la direzione di
;;; moto, "fa ombra" (copre interamente) a un B piu' lontano,
;;; quest'ultimo viene escluso dal controllo, perche' A
;;; incontrerebbe comunque prima l'altro. L'ombra e' calcolata
;;; in modo esatto (non solo min/max), quindi funziona anche se
;;; i B sono poligoni concavi con "vuoti" nella proiezione.
;;;
;;; Vale per poligoni (A e B) concavi o convessi, con lati
;;; comunque inclinati. Le polilinee con archi (bulge) non sono
;;; supportate e vengono scartate in selezione.
;;;
;;; Comando: TOCCA
;;;   1. seleziona il poligono da spostare (A)
;;;   2. seleziona uno o piu' poligoni fissi (B), INVIO per finire
;;;   3. scegli la direzione: X+ X- Y+ Y- oppure Angolo
;;; ============================================================
(setq *tc-eps* 1e-9)
;
(defun tc:cross (u v)
	;; ---- Prodotto vettoriale 2D --------------------------------
	(- (* (car u) (cadr v)) (* (cadr u) (car v)))
)
;
(defun tc:project (pt v)
	;; ---- Prodotto scalare 2D (proiezione di un punto su un asse) -
	(+ (* (car pt) (car v)) (* (cadr pt) (cadr v)))
)
;
(defun tc:verts (en / pts)
	;; ---- Vertici 2D di una LWPOLYLINE --------------------------
	(foreach g (entget en)
		(if (= (car g) 10)
			(setq pts (cons (list (cadr g) (caddr g)) pts))
		)
	)
	(reverse pts)
)
;
(defun tc:has-bulge (en)
	;; ---- Controllo: solo segmenti rettilinei -------------------
	(vl-some
		'(lambda (g) (and (= (car g) 42) (> (abs (cdr g)) 1e-12)))
		(entget en)
	)
)
;
(defun tc:edges (pts / res n i)
	;; ---- Lati del poligono (sempre chiuso): lista di (q1 q2) ---
	(setq n (length pts) i 0)
	(repeat n
		(setq res (cons (list (nth i pts) (nth (rem (1+ i) n) pts)) res))
		(setq i (1+ i))
	)
	(reverse res)
)
;
(defun tc:orient (edges / a)
	;; ---- Orientamento di un poligono dai suoi lati:
	;;      +1.0 antiorario, -1.0 orario ---------------------------
	(setq a 0.0)
	(foreach ed edges
		(setq a (+ a (tc:cross (car ed) (cadr ed))))
	)
	(if (>= a 0.0) 1.0 -1.0)
)
;
(defun tc:ray (pts edges d / best q1 q2 e den w tt s sgn)
	;; ---- Distanza minima tt>=0 per cui un vertice di 'pts',
	;;      spostato di tt*d, tocca un lato di 'edges' (raggio da
	;;      un punto, usato per il calcolo del contatto finale). --
	(setq sgn (tc:orient edges))
	(foreach ed edges
		(setq q1  (car ed)
			  q2  (cadr ed)
			  e   (list (- (car q2) (car q1)) (- (cadr q2) (cadr q1)))
			  den (tc:cross d e)
		)
		(if (> (abs den) *tc-eps*)
			(foreach p pts
				(setq w  (list (- (car q1) (car p)) (- (cadr q1) (cadr p)))
					  tt (/ (tc:cross w e) den)
					  s  (/ (tc:cross w d) den)
				)
				(if (and (>= tt (- *tc-eps*))
						 (>= s  (- *tc-eps*))
						 (<= s  (+ 1.0 *tc-eps*))
						 ;; contatto gia' in atto (tt ~ 0): vale solo se
						 ;; la direzione d entra nell'interno del poligono
						 (or (> tt *tc-eps*)
							 (> (* sgn (tc:cross e d)) *tc-eps*)
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
(defun tc:distance2 (va edges-a vb edges-b d / r1 r2 dneg)
	;; ---- Distanza di traslazione di A verso d fino al contatto
	;;      con un B, dati vertici/lati gia' calcolati di entrambi.
	;;      Ritorna nil se non c'e' mai contatto in quella direzione.
	(setq dneg 	 (list (- (car d)) (- (cadr d)))
			r1   (tc:ray va edges-b d)      ; vertici A -> lati B
			r2   (tc:ray vb edges-a dneg)   ; vertici B -> lati A
	)
	(cond
		((and r1 r2) (min r1 r2))
		(r1 r1)
		(r2 r2)
	)
)
;
(defun tc:min-projection (verts dir / m v)
	;; ---- Minima proiezione dei vertici su una direzione --------
	(foreach pt verts
		(setq v (tc:project pt dir))
		(if (or (null m) (< v m)) (setq m v))
	)
	m
)
;
(defun tc:edge-crosses-line (p0 d q1 q2 / e den w s)
	;; ---- Un segmento (q1 q2) attraversa la retta infinita che
	;;      passa per p0 con direzione d? (solo per il test di
	;;      presenza di materiale, non calcola la distanza). ------
	(setq e   (list (- (car q2) (car q1)) (- (cadr q2) (cadr q1)))
		  den (tc:cross d e)
	)
	(if (> (abs den) *tc-eps*)
		(progn
			(setq w (list (- (car q1) (car p0)) (- (cadr q1) (cadr p0))))
			(setq s (/ (tc:cross w d) den))
			(if (and (>= s (- *tc-eps*)) (<= s (+ 1.0 *tc-eps*))) T)
		)
	)
)
;
(defun tc:point-on-p (p pm)
	;; ---- Punto sulla retta perpendicolare p, a distanza pm
	;;      dall'origine lungo l'asse p (d-coordinata nulla). ------
	(list (* (car p) pm) (* (cadr p) pm))
)
;
(defun tc:dedupe (sorted / out)
	;; ---- Elimina duplicati da una lista di numeri GIA' ordinata -
	(foreach v sorted
		(if (or (null out) (> (- v (car out)) *tc-eps*))
			(setq out (cons v out))
		)
	)
	(reverse out)
)
;
(defun tc:shadow-intervals (verts edges d p / breaks sorted n i a b pm p0 material ivs)
	;; ---- "Ombra reale" di un poligono lungo l'asse perpendicolare
	;;      p, rispetto alla direzione di moto d: lista di
	;;      intervalli (a . b) dove esiste davvero del contorno,
	;;      con eventuali buchi se il poligono e' concavo. ---------
	(setq breaks nil)
	(foreach pt verts 
		(setq breaks (cons (tc:project pt p) breaks))
	)
	(setq sorted (tc:dedupe (vl-sort breaks '<)))
	(setq n (length sorted) i 0 ivs nil)
	(while (< i (1- n))
		(setq a (nth i sorted) b (nth (1+ i) sorted))
		(if (> (- b a) *tc-eps*)
			(progn
				(setq pm (/ (+ a b) 2.0)
					  p0 (tc:point-on-p p pm)
					  material nil
				)
				(foreach ed edges
					(if (and (not material)
						(tc:edge-crosses-line p0 d (car ed) (cadr ed)))
						(setq material T)
					)
				)
				(if material (setq ivs (cons (cons a b) ivs)))
			)
		)
		(setq i (1+ i))
	)
	(tc:merge-intervals (reverse ivs))
)
;
(defun tc:merge-intervals (ivs / sorted out last)
	;; ---- Unisce una lista di intervalli (a . b) sovrapposti o
	;;      adiacenti in una lista minima ordinata e disgiunta. ----
	(setq sorted (vl-sort ivs '(lambda (x y) (< (car x) (car y)))))
	(foreach iv sorted
		(if (and last (<= (car iv) (+ (cdr last) *tc-eps*)))
			(setq last (cons (car last) (max (cdr last) (cdr iv))))
			(progn
				(if last (setq out (cons last out)))
				(setq last iv)
			)
		)
	)
	(if last 
		(setq out (cons last out))
	)
	(reverse out)
)
;
(defun tc:interval-covered-p (iv covering)
	;; ---- Un intervallo (a . b) e' interamente contenuto nella
	;;      lista 'covering' (gia' unita/ordinata)? ----------------
	(vl-some
		'(lambda (c)
			(and (<= (car c) (+ (car iv) *tc-eps*))
				 (>= (cdr c) (- (cdr iv) *tc-eps*))
			)
		)
		covering
	)
)
;
(defun tc:shadow-covered-p (shadow covering)
	;; ---- Tutti gli intervalli di 'shadow' sono coperti da
	;;      'covering'? Lista vuota => non coperto (si mantiene). --
	(and shadow (vl-every '(lambda (iv) (tc:interval-covered-p iv covering)) shadow))
)
;
(defun tc:pick (msg / sel en)
	;; ---- Selezione di una singola LWPOLYLINE valida ------------
	(while (not en)
		(setq sel (entsel msg))
		(cond
			((null sel) 
				(setq en 'annulla)
			)
			((/= (cdr (assoc 0 (entget (car sel)))) "LWPOLYLINE")
				(princ "\nL'oggetto non e' una LWPOLYLINE.")
			)
			((tc:has-bulge (car sel))
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
(defun tc:pick-many (msg / result sel en stop)
	;; ---- Selezione di piu' LWPOLYLINE valide, INVIO per finire --
	(setq result nil stop nil)
	(while (not stop)
		(setq sel (entsel (strcat "\n" msg " (INVIO per terminare): ")))
		(cond
			((null sel) 
				(setq stop T)
			)
			(T
				(setq en (car sel))
				(cond
					((/= (cdr (assoc 0 (entget en))) "LWPOLYLINE")
						(princ "\nL'oggetto non e' una LWPOLYLINE, ignorato."))
					((tc:has-bulge en)
						(princ "\nPolilinea con archi, non supportata, ignorata.")
					)
					((member en result)
						(princ "\nGia' selezionato.")
					)
					(T (setq result (cons en result))
						(princ (strcat "\n -> " (itoa (length result)) " selezionato/i."))
					)
				)
			)
		)
	)
	(reverse result)
)
;
(defun tc:MoveShape (EnameShape InfoMove / tt Direction)
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
(defun tc:FenceShapeToShape (EnameMainShape LstEnameCheckShape Direction Verbose / 
								p va edges-a en verts edges dmin
								shadow results coverage kept item tt best Rtn)

	(if (and EnameMainShape LstEnameCheckShape Direction)
		(progn
			(setq p (list (- (cadr Direction)) (car Direction)))
			(setq va      (tc:verts EnameMainShape)
				  edges-a (tc:edges va)
			)
			;; --- dati per ciascun B: verts, edges, dmin, ombra ---
			(setq results nil)
			(foreach en LstEnameCheckShape
				(setq verts  (tc:verts en)
					  edges  (tc:edges verts)
					  dmin   (tc:min-projection verts Direction)
					  shadow (tc:shadow-intervals verts edges Direction p)
				)
				(setq results (cons (list en verts edges dmin shadow) results))
			)
			(setq results (reverse results))
			;; --- ordina per dmin crescente: il piu' vicino ad A prima,
			;;     lungo la direzione di moto ----------------------
			(setq results
				(vl-sort results '(lambda (x y) (< (nth 3 x) (nth 3 y))))
			)
			;; --- filtro: scarta i B la cui ombra e' interamente
			;;     coperta da quella dei B piu' vicini gia' accettati
			(setq coverage nil kept nil)
			(foreach item results
				(setq shadow (nth 4 item))
				(if (tc:shadow-covered-p shadow coverage)
					(if Verbose
						(princ	(strcat "\n  - escluso (handle " (cdr (assoc 5 (entget (car item)))) "): in ombra."))
					)
					(progn
						(setq kept (cons item kept))
						(if shadow
							(setq coverage (tc:merge-intervals (append coverage shadow)))
						)
					)
				)
			)
			(setq kept (reverse kept))
			(if Verbose
				(princ	(strcat "\n" (itoa (length LstEnameCheckShape)) " poligoni B, "
									 (itoa (length kept)) " da verificare dopo il filtro d'ombra.")
				)
			)
			;; --- calcolo del contatto solo sui B superstiti ------
			(setq best nil)
			
			(foreach item kept
				;(princ "\n")
				;(princ edges-a)
				;(princ "\n")
				(setq tt (tc:distance2 va edges-a (nth 1 item) (nth 2 item) Direction))
				(if (and tt (or (null best) (< tt (cdr best))))
					(setq best (cons (car item) tt))
				)
			)
			(cond
				((null best)
					(if Verbose
						(princ "\nNessun contatto possibile in questa direzione.")
					)
				)
				(T
					(setq tt (cdr best))
					(if (> tt 0.0)
						(setq Rtn (list tt Direction))
					)
					(if Verbose
						(princ (strcat "\nContatto con handle " (cdr (assoc 5 (entget (car best)))) " - traslato di " (rtos tt 2 6) " unita'."))
					)
				)
			)
		)
	)
	Rtn
)
;
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
; +++++++++++++++++++++
;
(defun FenceSelect05 (EnameShape EnameSheet DirLst / SelectionShape
								 			         Margin EnameOffset SelShape 
												     Grp NotIncludeList itm MoveShape MoveSheet Rtn)
	;
	(defun SelectionShape (EnameShape EnameSheet DirLst Debug /
							Shp:Corners Shp:ToUV Shp:ToXY Shp:IntSeg
							Shp:ClipHalf Shp:ClipRect Shp:Dedup Shp:Area Shp:SortCCW
							Len CosA SinA SheetBox ShapeUV SheetUV
							uMinShape vMinShape vMaxShape uMaxSheet
							P_List ActiveZoom SS i n en Rtn)
		;; DirLst = (cos sin) di un vettore che indica dove "avanza" la ricerca (in WCS)
		;; (1 0) = destra, (0 1) = su, (-1 0) = sinistra, (0 -1) = giu
		;; Viene normalizzato internamente.
		;; Debug = T disegna il poligono usato da ssget e attende un input
		(defun Shp:Corners (Dim / p1 p3)
			;; Angoli (4 punti) di un bounding box [min ... max]
			(setq p1 (car Dim) p3 (caddr Dim))
			(list p1 (list (car p3) (cadr p1)) p3 (list (car p1) (cadr p3)))
		)
		;
		(defun Shp:ToUV (P CosA SinA)
			;; Mondo -> locale (u = lungo la direzione, v = perpendicolare)
			(list (+ (* (car P) CosA) (* (cadr P) SinA))
				  (- (* (cadr P) CosA) (* (car P) SinA)))
		)
		;
		(defun Shp:ToXY (U V CosA SinA)
			;; Locale -> mondo
			(list (- (* U CosA) (* V SinA))
				  (+ (* U SinA) (* V CosA)))
		)
		;
		(defun Shp:IntSeg (A B k c / d tt)
			;; Intersezione del segmento A-B con la retta coordinata[k] = c (k: 0 = X, 1 = Y)
			(setq d (- (nth k B) (nth k A)))
			(if (< (abs d) 1e-12)
				A
				(progn
					(setq tt (/ (- c (nth k A)) d))
					(list (+ (car  A) (* tt (- (car  B) (car  A))))
						  (+ (cadr A) (* tt (- (cadr B) (cadr A)))))
				)
			)
		)
		;
		(defun Shp:ClipHalf (Poly k c s / out prev inP inC)
			;; Taglia Poly contro un semipiano. s = +1 tiene coord >= c, s = -1 tiene coord <= c
			(setq prev (last Poly))
			(foreach cur Poly
				(setq inP (>= (* s (- (nth k prev) c)) 0.0)
					  inC (>= (* s (- (nth k cur)  c)) 0.0)
				)
				(cond
					((and inP inC)
						(setq out (cons cur out)))
					((and inP (not inC))
						(setq out (cons (Shp:IntSeg prev cur k c) out)))
					((and (not inP) inC)
						(setq out (cons cur (cons (Shp:IntSeg prev cur k c) out))))
				)
				(setq prev cur)
			)
			(reverse out)
		)
		;
		(defun Shp:ClipRect (Poly Box / xmn ymn xmx ymx)
			;; Sutherland-Hodgman contro un bbox (formato di BoundingBoxLstEname)
			(setq xmn (car  (car   Box)) ymn (cadr (car   Box))
				  xmx (car  (caddr Box)) ymx (cadr (caddr Box))
			)
			(foreach h (list (list 0 xmn 1.0) (list 0 xmx -1.0)
                       (list 1 ymn 1.0) (list 1 ymx -1.0))
				(if Poly
					(setq Poly (Shp:ClipHalf Poly (car h) (cadr h) (caddr h)))
				)
			)
			Poly
		)
		;
		(defun Shp:Dedup (Poly Tol / out)
			;; Elimina vertici consecutivi duplicati (il clipping puo generarne)
			(foreach p Poly
				(if (or (null out) (> (distance p (car out)) Tol))
					(setq out (cons p out))
				)
			)
			(if (and (cdr out) (<= (distance (car out) (last out)) Tol))
				(setq out (cdr out))
			)
			(reverse out)
		)
		;
		(defun Shp:Area (Poly / a prev)
			;; Area con segno (formula di Gauss)
			(setq a 0.0 prev (last Poly))
			(foreach p Poly
				(setq a (+ a (- (* (car prev) (cadr p)) (* (car p) (cadr prev))))
					  prev p
				)
			)
			(/ a 2.0)
		)
		;
		(defun Shp:SortCCW (Poly / cx cy n)
			;; Ordina i vertici di un poligono convesso in senso antiorario
			(setq n  (float (length Poly))
				  cx (/ (apply '+ (mapcar 'car  Poly)) n)
				  cy (/ (apply '+ (mapcar 'cadr Poly)) n)
			)
			(mapcar 'cdr
				(vl-sort
					(mapcar '(lambda (p) (cons (atan (- (cadr p) cy) (- (car p) cx)) p)) Poly)
					'(lambda (a b) (< (car a) (car b)))
				)
			)
		)
		;
		; Main ******
		;
		(if (and EnameSheet EnameShape DirLst)
			(progn
				;; Direzione normalizzata
				(setq Len (sqrt (+ (* (car DirLst)  (car DirLst))
								   (* (cadr DirLst) (cadr DirLst))))
				)
				(if (> Len 1e-9)
					(progn
						(setq CosA (/ (car  DirLst) Len)
							  SinA (/ (cadr DirLst) Len)
						)
						(setq SheetBox (BoundingBoxLstEname (list EnameSheet)))
						(setq ShapeUV (mapcar '(lambda (p) (Shp:ToUV p CosA SinA))
											(Shp:Corners (BoundingBoxLstEname (list EnameShape))))
							  SheetUV (mapcar '(lambda (p) (Shp:ToUV p CosA SinA))
											(Shp:Corners SheetBox))
						)
						(setq uMinShape (apply 'min (mapcar 'car  ShapeUV))
							  vMinShape (apply 'min (mapcar 'cadr ShapeUV))
							  vMaxShape (apply 'max (mapcar 'cadr ShapeUV))
							  uMaxSheet (apply 'max (mapcar 'car  SheetUV))
						)
						;; Lo shape deve stare prima del bordo lontano del foglio,
						;; altrimenti il rettangolo si ribalta
						(if (> uMaxSheet uMinShape)
							(progn
								;; Rettangolo in WCS
								(setq P_List
									(list (Shp:ToXY uMinShape vMinShape CosA SinA)
										  (Shp:ToXY uMaxSheet vMinShape CosA SinA)
										  (Shp:ToXY uMaxSheet vMaxShape CosA SinA)
										  (Shp:ToXY uMinShape vMaxShape CosA SinA))
								)
								;; Clipping sul foglio (WCS), poi pulizia e ordinamento
								(setq P_List (Shp:ClipRect P_List SheetBox))
								(if P_List
									(setq P_List (Shp:SortCCW (Shp:Dedup P_List 1e-4)))
								)
								;; Poligono valido solo con almeno 3 vertici e area non nulla
								(if (and (>= (length P_List) 3)
										 (> (abs (Shp:Area P_List)) 1e-6)
									)
									(progn
										;; WCS -> UCS (richiesto da ssget e grdraw)
										(setq P_List (mapcar '(lambda (p) (trans (list (car p) (cadr p) 0.0) 0 1))
										      P_List)
										)
										; ------ blocco ZOOM ----
										;(if (not (AreaInView-p (car SheetBox) (caddr SheetBox)))
										;	(progn
										;		(ZoomWindow01 (car SheetBox) (caddr SheetBox))
										;		(setq ActiveZoom T)
										;	)
										;)
										;---------------------------------------------------------------------------
										(if Debug ;; disegna i punti realmente passati a ssget
											(progn
												(setq n (length P_List) i 0)
												(repeat n
													(grdraw (nth i P_List) (nth (rem (1+ i) n) P_List) 1 1)
													(setq i (1+ i))
												)
												(getstring "<>")
												(redraw)
											)
										)
										
										;(if (setq SS (ssget "_CP" P_List
										;				 (list (cons 0 "LWPOLYLINE") (list -3 (list $RgpShape)))
										;			 )
										;	)
										;	(progn
										;		(setq i (sslength SS))
										;		(while (> i 0)
										;			(setq i  (1- i)
										;				  en (ssname SS i)
										;			)
										;			(if (= (GetTypeShape en) 1)
										;				(setq Rtn (cons en Rtn))
										;			)
										;		)
										;	)
										;)
										(if (setq LstEname (EA:Ssget P_List 7 
																	(list (cons 0 "LWPOLYLINE") (cons 1001 $RgpShape))))
											(foreach en LstEname
												(if (= (GetTypeShape en) 1)
													(setq Rtn (cons en Rtn))
												)
											)
										)
										; -------------------------------------------------------------------------
										;(if ActiveZoom
										;	(ZoomPrevius01)
										;)
									)
								)
							)
						)
					)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if (and EnameShape EnameSheet DirLst)
		(progn
			(setq Margin 0.5)
			(setq EnameOffset 		(car (OffsetShapeDelimitated EnameShape (- $MargineAccosto Margin))))
			(setq LstShapeToCheck	(SelectionShape EnameOffset EnameSheet DirLst nil))
			(setq LstShapeToCheck	(vl-remove EnameShape LstShapeToCheck))
						
			(setq MoveShape (tc:FenceShapeToShape EnameOffset LstShapeToCheck DirLst nil))
			(setq MoveSheet (ti:FenceShapeToSheet EnameOffset EnameSheet      DirLst nil))
			(setq Rtn
				(cond
					((and MoveShape MoveSheet)
						(if (< (car MoveShape) (car MoveSheet)) 
							(list (- (car MoveShape) Margin) (cadr MoveShape)) 
							(list (- (car MoveSheet) Margin) (cadr MoveSheet))
						)
					)
					(MoveShape
						(list (- (car MoveShape) Margin) (cadr MoveShape))
					)
					(MoveSheet
						(list (- (car MoveSheet) Margin) (cadr MoveSheet))
					)
				)
			)
			(if EnameOffset (entdel EnameOffset))
		)
	)
	Rtn
)
;
; ---- Comando principale ------------------------------------
;
(defun C:TOCCACONT (/ ea lsb kw ang d DataPos)
	(setq ea (tc:pick "\nSeleziona il poligono da spostare (A): "))
	(if ea
		(progn
			(setq lsb (tc:pick-many "Seleziona i poligoni fissi (B)"))
			(if lsb
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
					(setq DataPos (tc:FenceShapeToShape ea lsb d T))
					(tc:MoveShape ea DataPos)
				)
				(princ "\nNessun poligono B selezionato.")
			)
		)
	)
	(princ)
)
;
;
(defun C:TOCCALAM (/ ea eb va edges-a vb edges-b kw ang d)

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
;
;
(defun ToolMove (/ *error* MakeArrowPolar DirectionMove
					FreeMovePosition FreePosition FreeCopyPosition
					FreeMirrorPosition FreeRotatePosition FreeLeanOnPosition
					EnameShape Narrow msgLst Loop EnameSheet DimShape MidPoint
					Gr Code Data Direction Move Free Rotate Mirror New Copy Lean_on Nesting 
					DirectionArrow InfoMove tt P1 P2 )

	(defun *error* (msg)
		(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
		(redraw)
		(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
		(princ)
    )
	;
	(defun MakeArrowPolar (DimShape n AngleEvidence / Pmin Pmax Pmid b h half i ang Rtn col evAng)

		;; Angolo da evidenziare, ricavato da (cosangle sinangle)
		(setq evAng (if (and AngleEvidence (= (length AngleEvidence) 2))
						(angle '(0.0 0.0) AngleEvidence)
					)
		)
		(if (and DimShape (numberp n) (> n 0))
			(progn
				(setq Pmin (nth 0 DimShape)
					  Pmax (nth 1 DimShape)
				)
				(if (and Pmin Pmax)
					(progn
						(setq Pmid (list (/ (+ (car  Pmax) (car  Pmin)) 2.0)
									     (/ (+ (cadr Pmax) (cadr Pmin)) 2.0))
							  b    (- (car Pmax) (car Pmin))
							  h    (- (cadr Pmax) (cadr Pmin))
							  half (/ (max b h) 2.0)
							  Pmin (list (- (car Pmid) half) (- (cadr Pmid) half))
							  Pmax (list (+ (car Pmid) half) (+ (cadr Pmid) half))
						)
						(redraw)
						(setq i 0)
						(repeat n
							(setq ang (* 2.0 pi (/ (float i) n)))
							;; stesso angolo -> colore di evidenza (1 = rosso), altrimenti 7
							(setq col (if (and evAng (equal ang evAng 1e-6)) 1 7))
							(setq Rtn (cons (ArrowGraphPolar ang Pmin Pmax col) Rtn))
							(setq i (1+ i))
						)
					)
				)
			)
		)
		(reverse Rtn)
	)	
	;
	(defun DirectionMove (Pc PClick NumArrow / StepRad Ang Idx Dir)
		(if (and (> NumArrow 0)
				 (> (distance Pc PClick) 1e-9)
			)
			(progn
				(setq StepRad (/ (* 2.0 pi) NumArrow)
					  Ang     (angle Pc PClick)
					  ;; indice del settore più vicino, con wrap-around
					  Idx     (rem (fix (+ (/ Ang StepRad) 0.5)) NumArrow)
					  Dir     (* Idx StepRad)
				)
				(list (cos Dir) (sin Dir))
			)
		)
	)
	;
	(defun FreeMovePosition (EnameShape / Ssel PtStart PtEnd EnameCheck Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				(setq Ssel    (SelectShape EnameShape))
				(setq PtStart (EnameCenter EnameShape))
				(setq PtEnd   (DragMove Ssel PtStart))
				(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtStart PtEnd nil nil)))
				(while (CheckIntersectionObjects EnameCheck (LM:ss->ent Ssel))
					(alert "Sovapposizione")
					(DeleteEntity (list EnameCheck))
					(setq PtEnd (DragMove Ssel PtStart))
					(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtStart PtEnd nil nil)))
				)
				(DeleteEntity (list EnameCheck))
				(setq Rtn (car (Move+Rotate+MirrorShape EnameShape (list PtStart PtEnd nil nil))))
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)
	;
	(defun FreePosition (EnameShape / Shape PtStart PtEnd Rotation Mirror Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				
				;(setq Shape 	  (DiscretizeShape EnameShape))
				(setq Shape 	  (DiscretizeShapeNoControl EnameShape))
				(setq PtStart     (EnameCenter EnameShape))
				(setq Rtn         (DinamicPositionLowGraphics Shape nil 1.0))	; Shape PtEnd Rotation Mirror
				(if Rtn
					(progn
						(setq Shape 	  (nth 0 Rtn))
						(setq PtEnd		  (nth 1 Rtn))
						(setq Rotation	  (nth 2 Rtn))
						(setq Mirror      (nth 3 Rtn))
						(setq Rtn (Move+Rotate+MirrorShape EnameShape (list PtStart PtEnd Rotation Mirror)))
					)
				)
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)
	;
	(defun FreeCopyPosition (EnameShape / Ssel PtStart PtEnd EnameCheck Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				(setq Ssel    (SelectShape EnameShape))
				(setq PtStart (EnameCenter EnameShape))
				(setq PtEnd   (DragMove Ssel PtStart))
				(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtStart PtEnd nil nil)))
				(while (CheckIntersectionObjects EnameCheck nil)
					(alert "Sovapposizione")
					(DeleteEntity (list EnameCheck))
					(setq PtEnd (DragMove Ssel PtStart))
					(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtStart PtEnd nil nil)))
				)
				(DeleteEntity (list EnameCheck))
				(setq Rtn (car (Copy+Rotate+MirrorShape EnameShape (list PtStart PtEnd nil nil))))
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)

	;
	(defun FreeMirrorPosition (EnameShape / Ssel PtStart PtEnd EnameCheck Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				(setq Ssel    (SelectShape EnameShape))
				(setq PtStart (EnameCenter EnameShape))
				(setq PtEnd   (DragMirror Ssel PtStart))
				(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtEnd PtEnd nil (angle PtStart PtEnd))))
				(while (CheckIntersectionObjects EnameCheck (LM:ss->ent Ssel))
					(alert "Sovapposizione")
					(DeleteEntity (list EnameCheck))
					(setq PtEnd (DragMirror Ssel PtStart))
					(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtEnd PtEnd nil (angle PtStart PtEnd))))
				)
				(DeleteEntity (list EnameCheck))
				(setq Rtn (car (Move+Rotate+MirrorShape EnameShape (list PtEnd PtEnd nil (angle PtStart PtEnd)))))
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)
	;
	(defun FreeRotatePosition (EnameShape / Ssel PtStart PtEnd EnameCheck Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				(setq Ssel    (SelectShape EnameShape))
				(setq PtStart (EnameCenter EnameShape))
				(setq PtEnd   (DragRotate Ssel PtStart))
				(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtEnd PtEnd (angle PtStart PtEnd) nil)))
				(while (CheckIntersectionObjects EnameCheck (LM:ss->ent Ssel))
					(alert "Sovapposizione")
					(DeleteEntity (list EnameCheck))
					(setq PtEnd (DragMirror Ssel PtStart))
					(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtEnd PtEnd (angle PtStart PtEnd) nil )))
				)
				(DeleteEntity (list EnameCheck))
				(setq Rtn (car (Move+Rotate+MirrorShape EnameShape (list PtEnd PtEnd (angle PtStart PtEnd) nil))))
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)
	;
	(defun FreeLeanOnPosition (EnameShape / *error* Loop PtRotate ActOsmode Rtn)
	
		(defun *error* (msg)
			(setvar "osmode" ActOsmode)
		)
		;
		(if EnameShape
			(progn
				(setq ActOsmode  (getvar "OSMODE"))
				(setvar "osmode" 39)
				(prompt "\nPunto di rotazione ")
				(setq Loop T)
				(while Loop
					(if (setq PtRotate (getpoint))
						(setq Loop nil)
					)
				)
				(setvar "osmode" ActOsmode)
				(if PtRotate
					(progn
						(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
						(setq Rtn (LeanOn EnameShape PtRotate))
						(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
					)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq Narrow 8)
	(setq Loop T)
	(setq msgLst (strcat "\r[L]ibero | [M]uovi | [R]uota | [S]pecchia | [C]opia | [N]uova selezione | [A]ppoggia | [D]ummy Nesting <Esc / Enter>"))
	(princ msgLst)
    (while Loop
	
		(setq Direction nil)
		(setq Move 		nil)
		(setq Free 		nil)
		(setq Rotate 	nil)
		(setq Mirror 	nil)
		(setq New 		nil)
		(setq Copy 		nil)
		(setq Lean_on 	nil)
		(setq Nesting 	nil)
	
		(if (not EnameShape)
			(progn
				(prompt "\nSagoma da muovere ")
				(if (setq EnameShape (SselSelectShape))
					(progn
						(setq DimShape (ucs-bbox EnameShape))
						(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
						(setq EnameSheet (GetEnameSheetByEnameShape EnameShape))
						(if (not EnameSheet)
							(progn
								(alert "Manca la lamiera")
								(exit)
							)
						)
					)
				)
				(princ msgLst)
			)
		)
		(MakeArrowPolar DimShape Narrow DirectionArrow)
		(setq Gr (grread 't 15 0) Code (car gr) Data (cadr gr))
		(cond
			((= Code 2)
				(cond
					((or (= Data 76) (= Data 108)) 	; Libero (tasto l/L)
						(setq Free T)
					)
					((or (= Data 77) (= Data 109)) 	; Muovi (tasto m/M)
						(setq Move T)
					)
					((or (= Data 99) (= Data 67)) 	; duplica contorno (tasto c/C)
						(setq Copy T)
					)
					((or (= Data 82) (= Data 114)) 	; rotazione	(tasto r/R)
						(setq Rotate T)
					)
					((or (= Data 83) (= Data 115)) 	; specchia	(tasto s/S)
						(setq Mirror T)
					)
					((or (= Data 78) (= Data 110))	; nuovo (tasto N)
						(setq New T)
					)
					((or (= Data 65) (= Data 97))	; appoggiare (tasto A/a)
						(setq Lean_on T)
					)
					((or (= Data 68) (= Data 100))	; (tasto D o d)
						(setq Nesting T)
						(redraw)
					)
					((member Data '(13 32 69 101)) ; enter space E e
						(redraw)
						(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
						(setq loop nil)
					)
				)
			)
			((= Code 5)
				(setq DirectionArrow (DirectionMove MidPoint Data Narrow)) ; Rolling Mouse
			)
			((= Code 3)
				(redraw)
				(setq Direction (DirectionMove MidPoint Data Narrow)) ; Clik left
			)
		)
		; Action +++++++++++
		(if Direction
			(progn
				(setq InfoMove (FenceSelect05 EnameShape EnameSheet direction))
				(princ msgLst)
				(if InfoMove
					(if (>= (car InfoMove) $MargineAccosto)
						(progn
							(setq tt        (car  InfoMove))
							(setq Direction (cadr InfoMove))
							(setq P1 (list 0.0 0.0 0.0)
								  P2 (list (* tt (car Direction)) (* tt (cadr Direction)) 0.0)
							)
							(setq EnameShape (car (Move+Rotate+MirrorShape EnameShape (list P1 P2 nil nil))))
							(setq DimShape (ucs-bbox EnameShape))
							(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
						)
					)
				)
			)
		)
		(if Free
			(progn
				(redraw)
				(setq EnameShape (car (FreePosition EnameShape)))
				(setq DimShape (ucs-bbox EnameShape))
				(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
				(MakeArrowPolar DimShape Narrow DirectionArrow)
				(princ msgLst)
			)
		)
		(if Move
			(progn
			(redraw)
				(setq EnameShape (FreeMovePosition EnameShape))
				(setq DimShape (ucs-bbox EnameShape))
				(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
				(MakeArrowPolar DimShape Narrow DirectionArrow)
				(princ msgLst)
			)
		)
		(if Rotate
			(progn
				(redraw)
				(setq EnameShape (FreeRotatePosition EnameShape))
				(setq DimShape (ucs-bbox EnameShape))
				(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
				(MakeArrowPolar DimShape Narrow DirectionArrow)
				(princ msgLst)
			)
		)
		(if Mirror
			(progn
				(redraw)
				(setq EnameShape (FreeMirrorPosition EnameShape))
				(setq DimShape (ucs-bbox EnameShape))
				(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
				(MakeArrowPolar DimShape Narrow DirectionArrow)
				(princ msgLst)
			)
		)
		(if Copy
			(progn
				(redraw)
				(setq EnameShape (FreeCopyPosition EnameShape))
				(setq DimShape (ucs-bbox EnameShape))
				(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
				(MakeArrowPolar DimShape Narrow DirectionArrow)
				(princ msgLst)
			)
		)
		(if New
			(progn
				(redraw)
				(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
				(setq EnameShape nil)
			)
		)
		(if Lean_on
			(progn
				(redraw)
				(setq EnameShape (FreeLeanOnPosition EnameShape))
				(setq DimShape (ucs-bbox EnameShape))
				(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
				(MakeArrowPolar DimShape Narrow DirectionArrow)
				(princ msgLst)
			)
		)
		(if nesting
			(progn
				(redraw)
				(setq EnameShape (car (DummyNesting EnameShape T)))
				(setq DimShape (ucs-bbox EnameShape))
				(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
				(MakeArrowPolar DimShape Narrow DirectionArrow)
				(princ msgLst)
			)
		)
	)
	(princ)
)
;
;






