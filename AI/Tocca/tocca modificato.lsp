;;; ============================================================
;;; TOCCA.LSP - Trasla una polilinea (A) fino al contatto con la
;;;             prima di una lista di polilinee (B1, B2, ...),
;;;             in una direzione data.
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
										(if (setq LstEname (MySsget P_List 7 
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
						
			;(cond
			;	((= Dir 1) (setq d (list  1.0  0.0)))
			;	((= Dir 3) (setq d (list -1.0  0.0)))
			;	((= Dir 2) (setq d (list  0.0  1.0)))
			;	((= Dir 4) (setq d (list  0.0 -1.0)))
			;	;(T
			;	;	(setq ang (getangle "\nAngolo di traslazione: "))
			;	;	(if ang (setq d (list (cos ang) (sin ang))))
			;	;)
			;)
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
(defun MoveShapeAlongArrow (EnameShape / *error* MakeArrowPolar DeletedArrow MakeSolidArrow DefinitionSolidArrow
										 msgLst Loop EnameSheet DimShape LstPointArrow gr code data direction LstArrow
										 InfoMove tt Direction P1 P2 )

	(defun *error* (msg)
		(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
		(DeletedArrow)
		(redraw)
		(DeletedHatchEasyCut)
		(DeleteEntity LstArrow)
		(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
		(princ)
    )
	;
	(defun MakeArrowPolar (DimShape n / LocalDimBox Pmin Pmax Pmid b h half i ang Rtn)
		;; Disegna N frecce disposte in modo polare attorno al centro del box
		(if (and DimShape (numberp n) (> n 0))
			(progn
				(setq Pmin (nth 0 DimShape))
				(setq Pmax (nth 1 DimShape))
				(if (and Pmin Pmax)
					(progn
						(setq Pmid (list (/ (+ (car Pmax) (car Pmin)) 2.0)
										 (/ (+ (cadr Pmax) (cadr Pmin)) 2.0)))
						(setq b (- (car Pmax) (car Pmin)))
						(setq h (- (cadr Pmax) (cadr Pmin)))
						(setq half (/ (max b h) 2.0))
						(setq Pmin (list (- (car Pmid) half) (- (cadr Pmid) half)))
						(setq Pmax (list (+ (car Pmid) half) (+ (cadr Pmid) half)))
						(DeletedArrow)
						(setq i 0)
						(repeat n
							(setq ang (* 2.0 pi (/ (float i) n)))
							(setq Rtn (cons (ArrowGraphPolar ang Pmin Pmax) Rtn))
							(setq i (1+ i))
						)
					)
				)
			)
		)
		(reverse Rtn)
	)	
	;
	(defun DeletedArrow ()
		(redraw)
	)
	;
	(defun MakeSolidArrow (Pa Pb Pc Pd Pe Pf Pg / AppendXdata)
	
		(defun AppendXdata (Ename)
			(entmod  (append (entget Ename) (list (list -3 (list $RgpTrash '(1002 . "{") '(1002 . "}"))))))
			(entupd Ename)
		)
	
		(if (and Pa Pb Pc Pd Pe Pf Pg)
			(list (AppendXdata (LM:MakeSolid Pa Pb Pc Pd))
				  (AppendXdata (LM:MakeSolid Pe Pf Pg Pg))
			)
		)
	)
	;
	(defun DirectionMove (Pc PClick NumArrow / StepRad Ang StartAng Direction )

		(setq StepRad  (/ (* 2.0 pi) NumArrow))
		(setq Ang      (angle Pc PClick))
		(setq StartAng (/ StepRad 2.0))
;		
		(if Ang
			(repeat NumArrow
				(if (and (>= Ang  StartAng)
						 (<= Ang  (+ StartAng StepRad))
					)
					(setq Direction (list (cos StartAng) (sin StartAng)))
					(setq StartAng (+ StartAng StepRad))
				)
			)
		)
		Direction
	)
	;
	;(defun DefinitionSolidArrow (Pt LstPointArrow / itm Rtn StepRad Pos)
	;	(setq DirectionArrow$ nil)
	;	(setq Pos 0)
	;	(setq StepRad (/ (* 2.0 pi) (length LstPointArrow)))
	;	(foreach itm LstPointArrow
	;		(if (MeInsideBPlane (list (nth 0 itm) (nth 1 itm) (nth 3 itm) (nth 5 itm)
	;								  (nth 6 itm) (nth 4 itm) (nth 2 itm))
	;							Pt)
	;			(progn
	;				;(setq Rtn (MakeSolidArrow (nth 0 itm) (nth 1 itm) (nth 2 itm) (nth 3 itm)
	;				;						  (nth 4 itm) (nth 5 itm) (nth 6 itm)))
	;				(setq DirectionArrow$ (list (cos (* Pos StepRad)) (sin (* Pos StepRad))))
	;				;(princ "\n") (princ DirectionArrow$) (princ "\n")
	;			)
	;		)
	;		(setq Pos (1+ Pos))
	;	)
	;	Rtn
	;)
	;
	;
	; Main
	;
	(setq Narrow 8)
	(setq Loop T)
	(setq EnameSheet (GetEnameSheetByEnameShape EnameShape))
	(setq DimShape (ucs-bbox EnameShape))
	(setq MidPoint (mapcar '(lambda (e1 e2) (/ (+ e1 e2) 2.0)) (car DimShape) (cadr DimShape)))
							
	(setq msgLst (strcat "\n<Esc / Enter>"))
	(princ msgLst)
	
    (while Loop
	
		(setq LstPointArrow (MakeArrowPolar DimShape Narrow))
		(setq gr (grread 't 15 0) code (car gr) data (cadr gr))
		(setq direction nil)
		
		(cond
			((= Code 2)
				(if (member data '(13 32 69 101)) ; enter space E e
					(progn
						(redraw)
						;(DeleteEntity LstArrow)
						;   (DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
						(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
						(setq Loop nil)
					)
				)
			)
			((and (member Code '(5 3)) (listp Data))  ; Mouse rolling
				(setq LstPointArrow (MakeArrowPolar DimShape Narrow))
				
				;(if (= Code 5)
				;	(progn
				;		;(DeleteEntity LstArrow)
				;		;   (DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				;		(setq LstArrow (DefinitionDirectionArrow Data LstPointArrow Narrow))
				;	)
				;)
				
				(if (= Code 3)						  ; Left click mouse
					(progn
						(redraw)
						;(princ "\n") (princ DirectionArrow$) 
						(setq Direction (DirectionMove MidPoint Data Narrow))
						;(if DirectionArrow$	(setq direction DirectionArrow$))
					)
				)
			)
		)
		; Action +++++++++++
		(if Direction
			(progn
				;(DeleteEntity LstArrow)
				;   (DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
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
							(MakeArrowPolar DimShape Narrow)
						)
					)
				)
			)
		)
	)
	(princ)
)
;
;; ---- Comando principale ------------------------------------
;
(defun C:TOCCA (/ ea lsb kw ang d DataPos)
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




(princ "\nComando TOCCA caricato.")
(princ)
;
; Test Ssget
;

;
(defun MySsget (pts mode flt / MakeFilter
								 doc ssets ss arr f res old)

	; 	(setq pts '((0.0 0.0 0.0) (1500.0 0.0 0.0) (1500.0 3000.0 0.0) (0.0 1500.0 0.0)))
	;	(my-cp-vla pts 7 (list (cons 0 "LWPOLYLINE") (cons 1001 $RgpShape)))
	;	(my-cp-vla pts 7 '((0 . "LWPOLYLINE") (62 . 2))) ; solo colore giallo



	(defun MakeFilter (pairs / n ft fd)
		(setq n  (length pairs)
			  ft (vlax-make-safearray vlax-vbInteger (cons 0 (1- n)))
			  fd (vlax-make-safearray vlax-vbVariant (cons 0 (1- n)))
		)
		(vlax-safearray-fill ft (mapcar 'car pairs))
		(vlax-safearray-fill fd (mapcar 'cdr pairs))
		(list (vlax-make-variant ft) (vlax-make-variant fd))
	)
	;
	; Main ++++++++
	;
	(setq doc   (vla-get-activedocument (vlax-get-acad-object))
		  ssets (vla-get-selectionsets doc)
	)
	;; elimina un eventuale "TMP" rimasto da una esecuzione precedente
	(setq old (vl-catch-all-apply 'vla-item (list ssets "TMP")))
	(if (not (vl-catch-all-error-p old))
		(vla-delete old)
	)
	(setq ss  (vla-add ssets "TMP")
		  arr (vlax-make-safearray vlax-vbDouble (cons 0 (1- (* 3 (length pts)))))
	)
	(vlax-safearray-fill arr (apply 'append pts))

	(if flt
		(progn
			(setq f (MakeFilter flt))
			(vla-selectbypolygon ss mode (vlax-make-variant arr) (car f) (cadr f))
		)
		(vla-selectbypolygon ss mode (vlax-make-variant arr))
	)
	(vlax-for obj ss
		(setq res (cons (vlax-vla-object->ename obj) res))
	)
	(vla-delete ss)
	(reverse res)
)






