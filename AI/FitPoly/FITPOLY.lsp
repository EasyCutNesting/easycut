;;; ------------------------------------------------------------
;;; FITPOLY.LSP
;;; Inserisce una copia di un contorno chiuso (LWPOLYLINE) dentro
;;; una polilinea contenitore chiusa (concava o convessa).
;;; Cerca sulla griglia (e con rotazioni) la posizione valida con
;;; la maggiore distanza minima dai bordi.
;;; Comando: FITPOLY
;;; ------------------------------------------------------------
;; bulge di ogni vertice della LWPOLYLINE
;
(defun fp:acos (x)
  (atan (sqrt (max 0.0 (- 1.0 (* x x)))) x)
)
;
(defun fp:arcpts (p1 p2 b tol / dx dy c th f cen r a0 x phimax q m i a res)
	;; punti INTERNI dell'arco p1->p2 con bulge b (estremi esclusi)
	(setq dx (- (car p2) (car p1))
          dy (- (cadr p2) (cadr p1))
          c  (sqrt (+ (* dx dx) (* dy dy)))
	)
	(if (> c 1e-12)
		(progn
			(setq th  (* 4.0 (atan b))                      ; angolo al centro (con segno)
				  f   (/ (* c (- 1.0 (* b b))) (* 4.0 b))   ; distanza centro dal punto medio
				  cen (list (+ (/ (+ (car p1) (car p2)) 2.0) (* f (/ (- dy) c)))
						    (+ (/ (+ (cadr p1) (cadr p2)) 2.0) (* f (/ dx c))))
				  r   (distance p1 cen)
				  a0  (atan (- (cadr p1) (cadr cen)) (- (car p1) (car cen)))
			)
			;; angolo massimo per sotto-arco: r*(1-cos(phi/2)) <= tol
			(if (>= tol r)
				(setq phimax pi)
				(progn
					(setq x (- 1.0 (/ tol r)))
					(setq phimax (* 2.0 (fp:acos x)))
				)
			)
			(setq q (/ (abs th) phimax)
				  m (fix q)
			)
			(if (< m q) 
				(setq m (1+ m))
			)
			(if (< m 1) 
				(setq m 1)
			)
			(setq i 1)
			(repeat (1- m)
				(setq a (+ a0 (* i (/ th m))))
				(setq res (cons (list (+ (car cen) (* r (cos a))) (+ (cadr cen) (* r (sin a))))	res))
				(setq i (1+ i))
			)
			(reverse res)
		)
	)
)
;
(defun fp:disc (ent tol / pts bls flag closed n nseg i p1 p2 b lst)
	;; discretizzazione completa
	(foreach x (entget ent)
		(cond 
			((= (car x) 10)
				(setq pts (cons (list (cadr x) (caddr x)) pts)
					  bls (cons 0.0 bls)
				)
			)
			((= (car x) 42)
				(setq bls (cons (cdr x) (cdr bls)))
			)
			((= (car x) 70)
				(setq flag (cdr x))
			)
		)
	)
	(setq pts    (reverse pts)
		  bls    (reverse bls)
          closed (= 1 (logand 1 (if flag flag 0)))
		  n      (length pts)
          nseg   (if closed n (1- n))
          i      0
	)
	(repeat nseg
		(setq p1 (nth i pts)
			  p2 (nth (rem (1+ i) n) pts)
			  b  (nth i bls)
		)
		(setq lst (cons p1 lst))
		(if (> (abs b) 1e-9)
			(foreach p (fp:arcpts p1 p2 b tol)
				(setq lst (cons p lst))
			)
		)
		(setq i (1+ i))
	)
	(if (not closed)
		(setq lst (cons (last pts) lst))
	)
	(reverse lst)
)
;
(defun fp:bulges (ent / b)
  (foreach x (entget ent)
    (cond ((= (car x) 10) (setq b (cons 0.0 b)))
          ((= (car x) 42) (setq b (cons (cdr x) (cdr b))))))
  (reverse b))
;
(defun fp:pts (ent)
  (fp:disc ent $ArrowArcDivision)
)
;
(defun fp:center (pl / xs ys)
	;; centro del bounding box di una lista di punti
	(setq xs (mapcar 'car pl) ys (mapcar 'cadr pl))
	(list (/ (+ (apply 'min xs) (apply 'max xs)) 2.0)
          (/ (+ (apply 'min ys) (apply 'max ys)) 2.0)
	)
)
;
(defun fp:xf (pl ang dx dy / ca sa)
	;; ruota di ang attorno all'origine, poi trasla di (dx,dy)
	(setq ca (cos ang) sa (sin ang))
	(mapcar '(lambda (p)
				(list (+ dx (- (* ca (car p)) (* sa (cadr p))))
					  (+ dy (+ (* sa (car p)) (* ca (cadr p))))
				)
			)
			pl
	)
)
;
(defun fp:inside (p pl / x y c a)
	;; punto dentro poligono (ray casting)
	(setq x (car p) y (cadr p) a (last pl))
	(foreach b pl
		(if (and (/= (> (cadr a) y) (> (cadr b) y))
				 (< x (+ (car a)
                 (/ (* (- y (cadr a)) (- (car b) (car a)))
                 (- (cadr b) (cadr a)))))
			)
			(setq c (not c))
		)
		(setq a b)
	)
	c
)
;
(defun fp:cross (a b c)
	;; prodotto vettoriale (b-a) x (c-a)
	(- (* (- (car b) (car a)) (- (cadr c) (cadr a)))
       (* (- (cadr b) (cadr a)) (- (car c) (car a)))
	)
)
;
(defun fp:segx (p1 p2 p3 p4 / d1 d2 d3 d4)
	;; incrocio proprio tra segmenti p1p2 e p3p4
	(setq 	d1 (fp:cross p3 p4 p1)
			d2 (fp:cross p3 p4 p2)
			d3 (fp:cross p1 p2 p3)
			d4 (fp:cross p1 p2 p4)
	)
	(and (< (* d1 d2) 0) (< (* d3 d4) 0))
)
;
(defun fp:anycross (pa pb / a c r)
	;; esiste almeno un incrocio tra i lati dei due poligoni?
	(setq a (last pa))
	(foreach b pa
		(setq c (last pb))
		(foreach d pb
			(if (fp:segx a b c d) (setq r T))
			(setq c d)
		)
		(setq a b)
	)
	r
)
;
(defun fp:dseg (p a b / dx dy t2 u)
	;; distanza punto-segmento
	(setq dx (- (car b) (car a))
          dy (- (cadr b) (cadr a))
          t2 (+ (* dx dx) (* dy dy))
          u  (if (< t2 1e-12)
				0.0
				(/ (+ (* (- (car p) (car a)) dx)
                      (* (- (cadr p) (cadr a)) dy)) t2)
			 )
          u  (max 0.0 (min 1.0 u))
	)
	(distance p (list (+ (car a) (* u dx)) (+ (cadr a) (* u dy))))
)
;
(defun fp:mind (pa pb / m a)
	;; distanza minima dai punti di pa ai lati di pb
	(setq m 1e99)
	(foreach p pa
		(setq a (last pb))
		(foreach b pb
			(setq m (min m (fp:dseg p a b)))
			(setq a b)
		)
	)
	m
)
;
(defun fp:fits (cont cand)
	;; cand sta dentro cont?
	(and (vl-every '(lambda (p) (fp:inside p cont)) cand)
		 (not (fp:anycross cont cand))
	)
)
; ------------------------------------------------------------
(defun c:FITPOLY (/ e1 e2 cont shp ctr mrg n nrot minx miny maxx maxy
                    dx dy ix iy r ang rel cand cl best bx by obj new)
	(setq e1 (car (entsel "\nSeleziona la polilinea contenitore: ")))
	(setq e2 (car (entsel "\nSeleziona il contorno da inserire: ")))
	(if (and e1 e2)
		(progn
			(setq mrg (getdist "\nMargine minimo dai bordi <0>: "))
			(if (not mrg) (setq mrg 0.0))
			(setq n (getint "\nSuddivisioni griglia <40>: "))
			(if (not n) (setq n 40))
			(setq nrot (getint "\nNumero di rotazioni da provare <1>: "))
			(if (not nrot) (setq nrot 1))
			(setq cont (fp:pts e1)
				  shp  (fp:pts e2)
				  ctr  (fp:center shp)
                  shp  (mapcar '(lambda (p) (list (- (car p) (car ctr))
												  (- (cadr p) (cadr ctr))))
                        shp)
				  minx (apply 'min (mapcar 'car cont))
				  maxx (apply 'max (mapcar 'car cont))
				  miny (apply 'min (mapcar 'cadr cont))
				  maxy (apply 'max (mapcar 'cadr cont))
				  dx   (/ (- maxx minx) n)
				  dy   (/ (- maxy miny) n)
				  r    0
			)
			(princ "\nCalcolo in corso...")
			(repeat nrot
				(setq ang (* r (/ (* 2 pi) nrot))
					  rel (fp:xf shp ang 0.0 0.0)
				      ix  0
				)
				(repeat (1+ n)
					(setq iy 0)
					(repeat (1+ n)
						(setq bx   (+ minx (* ix dx))
							  by   (+ miny (* iy dy))
							  cand (fp:xf rel 0.0 bx by)
						)
						(if (fp:fits cont cand)
							(progn
								(setq cl (min (fp:mind cand cont) (fp:mind cont cand)))
								(if (and (>= cl mrg) (or (not best) (> cl (car best))))
									(setq best (list cl bx by ang))
								)
							)
						)
						(setq iy (1+ iy))
					)
					(setq ix (1+ ix))
				)
				(setq r (1+ r))
			)

			(if best
				(progn
					(setq obj (vlax-ename->vla-object e2)
						  new (vla-copy obj)
					)
					(vla-move new
						(vlax-3d-point (list (car ctr) (cadr ctr) 0.0))
						(vlax-3d-point (list (cadr best) (caddr best) 0.0))
					)
					(vla-rotate new
						(vlax-3d-point (list (cadr best) (caddr best) 0.0))
						(cadddr best)
					)
					(princ (strcat "\nInserito. Distanza minima dai bordi: " (rtos (car best) 2 3)))
				)
				(princ "\nNessuna posizione valida trovata (prova margine minore, griglia piu' fitta o altre rotazioni).")
			)
		)
	)
	(princ)
)
;
(defun c:DISCR (/ e tol lst)
	(setq e (car (entsel "\nSeleziona la polilinea: ")))
	(if e
		(progn
			(setq tol (getdist (strcat "\nTolleranza massima arco-corda <" (rtos $ArrowArcDivision 2 3) ">: ")))
			(setq lst (fp:disc e tol))
			(entmakex 	(append
							(list '(0 . "LWPOLYLINE") '(100 . "AcDbEntity") '(100 . "AcDbPolyline")
									(cons 90 (length lst))
									(cons 70 (if (vlax-curve-isclosed e) 1 0))
									'(62 . 1)
							)
							(mapcar '(lambda (p) (cons 10 p)) lst)
						)
			)
			(princ (strcat "\nCreata polilinea con " (itoa (length lst)) " vertici."))
		)
	)
	(princ)
)