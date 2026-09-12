;     
;     !COS_DIR$
;     ((1119.14 160.961 91.6606)
;     (0.666667 -0.666667 -0.333333)
;     (0.745356 0.596285 0.298142)
;     (0.0 -0.447214 0.894427))
;     
;     (transl 0.0 0.0 0.0 cos_dir$)
;     (-608.233 -957.464 -10.0)
;     
;     (transl 1.0 0.0 0.0 cos_dir$)
;     (-607.566 -956.719 -10.0)
;     
;     (transl 0 1 0 cos_dir$)
;     (-608.9 -956.868 -10.4472)
;     
;     (transl 0 0 1 cos_dir$)
;     (-608.566 -957.166 -9.10557)
;     
;     -607.566 - (- 608.233) = 0.667
;     -956.719 - (- 957.464) = 0.745
;     -10.0    - (- 10.0)    = 0.0 
;     
;     -608.900 - (- 608.233) = -0.667
;     -956.608 - (- 957.464) =  0.596
;     -10.4472 - (- 10.0)    = -0.4472
;     
;     -608.566 - (- 608.233) = -0.3333
;     -957.166 - (- 957.464) =  0.298
;     -9.10557 - (- 10.0)    =  0.8944
;     
;     
;     UCS2WCSMatrix
;     ((0.666667 -0.666667 -0.333333 -608.233)
;      (0.745356 0.596285 0.298142 -957.464) 
;      (0.0 -0.447214 0.894427 -10.0)
;	   (0 0 0 1))
;      
;      
;     WCS2UCSMatrix
;      ((0.666667 0.745356 0.0 1119.14)
;      (-0.666667 0.596285 -0.447214 160.961) 
;      (-0.333333 0.298142 0.894427 91.6606)
;	   (0 0 0 1))
;     
;
(defun c:test(/ p1 p2 p3)
     
     	(setq p1 (trans (getpoint "\nP1..") 1 0))
     	(setq p2 (trans (getpoint "\nP2..") 1 0))
     	(setq p3 (trans (getpoint "\nP3..") 1 0))
     	(setq UW (MyUCS2WCSMatrix p1 p2 p3))
        (setq WU (MyWCS2UCSMatrix p1 p2 p3))
)
;
; PUNTI
;
(defun asin ( x )
		;; ArcSine  -  Lee Mac
		;; Args: -1 <= x <= 1
		(if (<= -1.0 x 1.0)
			(atan x (sqrt (- 1.0 (* x x))))
		)
)
;	
(defun acos (val / a alfa)
	;01/02/92
	;procedura ACOS.LSP   (calcola l'arco coseno)
	;
	;sottoprocedure chiamate : nessuna
	;
	;dato di output          :variabile contenente il valore dell'arcoseno

	(atan (sqrt (- 1 (* val val))) val)
)
;
;
(defun tan ( x )
    (if (not (equal 0.0 (cos x) 1e-10))
        (/ (sin x) (cos x))
    )
)
;
;
(defun ang_x (x1 y1 x2 y2 / modulo ang fuzz)
	(angle (list x1 y1) (list x2 y2)) 
)
;
;
(defun Quad (Value)
	(if Value
		(* Value Value)
	)
)
;
;
(defun prol (x1 y1 x2 y2 lung / x y ang punto)
	;05/02/92
	;procedura PROL.LSP   (prolungamento di una retta)
	;
	;sottoprocedure chiamate : ANG_X.LSP
	;
	;dato di output          : variabile contenente la lista del valore X e Y
    (setq ang (ang_x x1 y1 x2 y2))
    (setq x (+ x2 (* lung (cos ang))))
    (setq y (+ y2 (* lung (sin ang))))
    (setq punto (list x y))
)
;
;
(defun per (x1 y1 x2 y2 dist / x y alfa punto)
	;05/02/92
	;procedura PER.LSP       (calcola un punto perpendicoloare all'ultimo punto)
	;sottoprocedure chiamate :ANG_X.LSP
	;
	;dato di output          : variabile contenente la lista del valore X e Y
    (setq alfa (+ (/ pi 2) (ang_x x1 y1 x2 y2)))
    (setq x (+ x2 (* dist (cos alfa))))
    (setq y (+ y2 (* dist (sin alfa))))
    (setq punto (list x y))
)
;
;
(defun par (x1 y1 x2 y2 dist / xa ya xb yb punto1 punto2 punti)

	;05/02/92
	;procedura PAR.LSP       (calcola due punti paralleli della retta)
	;sottoprocedure chiamate :ANG_X.LSP
	;
	;dato di output          : variabile di ritorno contenente i valori
	;                          X1 Y1 iniziali
	;                          X2 Y2 finali della retta parallela
	(setq alfa (+ (/ pi 2) (ang_x x1 y1 x2 y2)) 
		  xa (+ x1 (* dist (cos alfa))) 
		  ya (+ y1 (* dist (sin alfa))) 
	 	  xb (+ x2 (* dist (cos alfa))) 
		  yb (+ y2 (* dist (sin alfa))) 
		  punto1 (list xa ya) 
		  punto2 (list xb yb) 
		  punti (list punto1 punto2)
    )
)
;
;
(defun div (x1 y1 x2 y2 n_punti / i x y Rtn)
	;05/02/92
	;procedura DIV.LSP   (divisione di una retta)
	;N.B : il parametro N_PUNTI deve essere passato come numero intero
	;                                                           ------
	;dato di output    : variabile contenente la lista dei punti trovati es:
	;                   ( (X1 Y1) (X2 Y2) (Xn Yn) )
	(setq i 0)
	(repeat n_punti
		(setq i (+ 1 i))
		(cond 
			((= (- x2 x1) 0)
				(setq x x1)
				(setq y (+ y1 (* i (/ (- y2 y1) (+ 1.0 n_punti)))))
			)
			((= (- y2 y1) 0)
				(setq y y1)
				(setq x (+ x1 (* i (/ (- x2 x1) (+ 1.0 n_punti)))))
			)
			((and (/= (- x2 x1) 0) (/= (- y2 y1) 0) )
				(setq x (+ x1 (* i (/ (- x2 x1) (+ 1.0 n_punti)))))
				(setq y (+ y1 (* i (/ (- y2 y1) (+ 1.0 n_punti)))))
			)
		)
		(setq Rtn (append Rtn (list (list x y 0.0))))
	)
)
;
;
(defun DivNoZero (x1 y1 x2 y2 n_punti / i x y Rtn)
	;05/02/92
	;procedura DIV.LSP   (divisione di una retta)
	;N.B : il parametro N_PUNTI deve essere passato come numero intero
	;                                                           ------
	;dato di output    : variabile contenente la lista dei punti trovati es:
	;                   ( (X1 Y1) (X2 Y2) (Xn Yn) )
	(setq i 0)
	(repeat n_punti
		(setq i (+ 1 i))
		(cond 
			((= (- x2 x1) 0)
				(setq x x1)
				(setq y (+ y1 (* i (/ (- y2 y1) (+ 1.0 n_punti)))))
			)
			((= (- y2 y1) 0)
				(setq y y1)
				(setq x (+ x1 (* i (/ (- x2 x1) (+ 1.0 n_punti)))))
			)
			((and (/= (- x2 x1) 0) (/= (- y2 y1) 0) )
				(setq x (+ x1 (* i (/ (- x2 x1) (+ 1.0 n_punti)))))
				(setq y (+ y1 (* i (/ (- y2 y1) (+ 1.0 n_punti)))))
			)
		)
		(setq Rtn (append Rtn (list (list x y))))
	)
)
;
;
(defun dcp (x1 y1 x2 y2 ang n_pt / delta_alfa alfa_x conta
                                   dist d_x d_y pt_lista alfa)
	;
	; divisione di una porzione di circonferenza determinta da un angolo
	; con n. punti
	;
	; x1 .......= x centro raggio
	; y1 .......= y centro raggio
	; x2 .......= x punto nella circonferenza
	; y2 .......= y punto nella circonferenza
	; ang ......= angolo che determina una porzione di circonferenza in radianti
	; n_pt .....= numero di punti da introdurre nella circonfernza (intero)
	;
	;
	(setq 	delta_alfa (/ ang (+ 1 n_pt))
			alfa_x (ang_x x1 y1 x2 y2)
			conta 1
			pt_lista nil
	)
	(repeat n_pt
		(setq 	alfa (+ alfa_x (* conta delta_alfa))
				dist (sqrt (+ (* (- x2 x1) (- x2 x1))
							  (* (- y2 y1) (- y2 y1))
							)
					 )
				d_x (+ x1 (* dist (cos alfa)))
				d_y (+ y1 (* dist (sin alfa)))
				pt_lista (append pt_lista (list (list d_x d_y)))
				conta (+ 1 conta)
		)
	)
	(setq pt_lista pt_lista)
)
;
;
(defun dca (x1 y1 x2 y2 ang / alfa_x alfa dist d_x d_y pt)
	;
	; divisione di una porzione di circonferenza con un angolo
	;             
	; x1 .......= x centro raggio
	; y1 .......= y centro raggio
	; x2 .......= x punto nella circonferenza
	; y2 .......= y punto nella circonferenza
	; ang ......= angolo di divisione della circonferenza partendo da x2 y2
	;                                                             
	;
	(setq alfa_x (ang_x x1 y1 x2 y2)
		  alfa (+ alfa_x ang)
		  dist (sqrt (+ (* (- x2 x1) (- x2 x1))
						(* (- y2 y1) (- y2 y1))
					 )
				)
		  d_x (+ x1 (* dist (cos alfa)))
		  d_y (+ y1 (* dist (sin alfa)))
	)
	(setq pt (list d_x d_y))
)
;
;
(defun LM:inters-circle-circle ( c1 r1 c2 r2 / n d1 x z )
    (if
        (and
            (< (setq d1 (distance c1 c2)) (+ r1 r2))
            (< (abs (- r1 r2)) d1)
        )
        (progn
            (setq n  (mapcar '- c2 c1)
                  c1 (trans c1 0 n)
                  z  (/ (- (+ (* r1 r1) (* d1 d1)) (* r2 r2)) (+ d1 d1))
            )
            (if (equal z r1 1e-8)
                (list (trans (list (car c1) (cadr c1) (+ (caddr c1) z)) n 0))
                (progn
                    (setq x (sqrt (- (* r1 r1) (* z z))))
                    (list
                        (trans (list (- (car c1) x) (cadr c1) (+ (caddr c1) z)) n 0)
                        (trans (list (+ (car c1) x) (cadr c1) (+ (caddr c1) z)) n 0)
                    )
                )
            )
        )
    )
)
;
;
(defun MyUCS2WCSMatrix (p1g p2g p3g / cos_dir origin xAxis yAxis zAxis rtn)

	(if (and p1g p2g p3g)
		(progn
		
			(if (= (length p1g) 2) (setq p1g (list (car p1g) (cadr p1g) 0.0)))
			(if (= (length p2g) 2) (setq p2g (list (car p2g) (cadr p2g) 0.0)))
			(if (= (length p3g) 2) (setq p3g (list (car p3g) (cadr p3g) 0.0)))
			
			(setq cos_dir (DefPiano (nth 0 p1g) (nth 1 p1g) (nth 2 p1g)
									(nth 0 p2g) (nth 1 p2g) (nth 2 p2g)
									(nth 0 p3g) (nth 1 p3g) (nth 2 p3g)
						  )
			)
			(setq origin (transl 0.0 0.0 0.0 cos_dir)
				  xAxis  (nth 1 cos_dir)
				  yAxis  (nth 2 cos_dir)
				  zAxis  (nth 3 cos_dir)
			)
			(setq rtn (append (list (list (nth 0 xAxis)  (nth 1 xAxis) (nth 2 xAxis) (nth 0 origin)))
							  (list (list (nth 0 yAxis)  (nth 1 yAxis) (nth 2 yAxis) (nth 1 origin)))
							  (list (list (nth 0 zAxis)  (nth 1 zAxis) (nth 2 zAxis) (nth 2 origin)))
							  (list (list 0.0 0.0 0.0 1.0))
					  )
			)
		)
	)
	rtn
)	
;
;
(defun MyWCS2UCSMatrix (p1g p2g p3g / cos_dir origin xAxis yAxis zAxis rtn)

	(if (and p1g p2g p3g)
		(progn

			(if (= (length p1g) 2) (setq p1g (list (car p1g) (cadr p1g) 0.0)))
			(if (= (length p2g) 2) (setq p2g (list (car p2g) (cadr p2g) 0.0)))
			(if (= (length p3g) 2) (setq p3g (list (car p3g) (cadr p3g) 0.0)))
		
			(setq cos_dir (DefPiano (nth 0 p1g) (nth 1 p1g) (nth 2 p1g)
									(nth 0 p2g) (nth 1 p2g) (nth 2 p2g)
									(nth 0 p3g) (nth 1 p3g) (nth 2 p3g)
						  )
			)
			(setq origin (transl 0.0 0.0 0.0 cos_dir)
				  xAxis  (transl 1.0 0.0 0.0 cos_dir)
				  yAxis  (transl 0.0 1.0 0.0 cos_dir)
				  zAxis  (transl 0.0 0.0 1.0 cos_dir)
			)
			(setq rtn (append   (list (list (- (nth 0 xAxis) (nth 0 origin)) (- (nth 1 xAxis) (nth 1 origin)) (- (nth 2 xAxis) (nth 2 origin)) (nth 0 (nth 0 cos_dir))))
								(list (list (- (nth 0 yAxis) (nth 0 origin)) (- (nth 1 yAxis) (nth 1 origin)) (- (nth 2 yAxis) (nth 2 origin)) (nth 1 (nth 0 cos_dir))))
								(list (list (- (nth 0 zAxis) (nth 0 origin)) (- (nth 1 zAxis) (nth 1 origin)) (- (nth 2 zAxis) (nth 2 origin)) (nth 2 (nth 0 cos_dir))))
								(list (list 0.0 0.0 0.0 1.0))
					  )
			)
		)
	)
	rtn		 
)
;
;
(defun SaveUcs (NameUcs / *error* 
						  ucsorg ucsxdir ucsydir currUCS)

	(defun *error* (msg)
		(alert (strcat "[SaveUcs] " msg))
	)
	;
	;(if NameUcs
	;	(vla-add (vla-get-UserCoordinateSystems (vla-get-ActiveDocument (vlax-get-acad-object)))
	;							(vlax-3d-point (trans '(0.0 0.0 0.0) 1 0))
	;							(vlax-3d-point (trans '(1.0 0.0 0.0) 1 0))
	;							(vlax-3d-point (trans '(0.0 1.0 0.0) 1 0))
	;							NameUcs
	;	)
	;)
	(if NameUcs
		(progn

			(setq ucsorg  (getvar "UCSORG"))
			(setq ucsxdir (getvar "UCSXDIR"))
			(setq ucsydir (getvar "UCSYDIR"))

			(setq currUCS (vla-Add (vla-get-UserCoordinateSystems (vla-get-ActiveDocument (vlax-get-acad-object))) 
									(vlax-3d-point (list 0.0 0.0 0.0))
									(vlax-3d-point ucsxdir) 
									(vlax-3d-point ucsydir) 
									NameUcs))
			(vla-put-origin currUCS (vlax-3d-point ucsorg))
		)
	)
)
;
;
(defun ortho_y_axis (Porigin Xaxis Yaxis / UcsDir Pori Xaxe Yaxe)

		(setq Pori Porigin
			  Xaxe Xaxis
		      Yaxe Yaxis
		)
		
		(if (= (type Porigin) 'VARIANT)   (setq Pori (vlax-safearray->list (vlax-variant-value Pori))))
		(if (= (type Xaxis)   'VARIANT)   (setq Xaxe (vlax-safearray->list (vlax-variant-value Xaxe))))
		(if (= (type Yaxis)   'VARIANT)   (setq Yaxe (vlax-safearray->list (vlax-variant-value Yaxe))))
		
		(setq UcsDir (Defpiano (nth 0 Pori) (nth 1 Pori) (nth 2 Pori)
							   (nth 0 Xaxe) (nth 1 Xaxe) (nth 2 Xaxe)
							   (nth 0 Yaxe) (nth 1 Yaxe) (nth 2 Yaxe)
					 )
		)
		(vlax-3d-point (TransG   0.0 1.0 0.0 UcsDir))
) 
;
;
(defun GetUcsName ( / UCS Names) 
	(while (setq UCS (tblnext "UCS" (not Names))) 
		(setq Names (cons (cdr (assoc 2 UCS)) Names)) 
	)
	(reverse Names) 
)
;
;
(defun UCSWorld (UcsName)
	(vla-put-ActiveUCS (vla-get-ActiveDocument (vlax-get-acad-object))
		(vla-add (vla-get-usercoordinatesystems (vla-get-ActiveDocument (vlax-get-acad-object)))
					(vlax-3D-point '(0. 0. 0.))
					(vlax-3D-point '(1. 0. 0.))
					(vlax-3D-point '(0. 1. 0.)) UcsName)
	)
)
;
;
(defun SetUcs (p1glo p2glo p3glo UcsName / origin xAxis yAxis neworigin newxAxis newyAxis doc UCSs newUCS)

	(if (and p1glo p2glo p3glo UcsName)
		(progn
			(setq origin p1glo
				  xAxis  p2glo
				  yAxis  p3glo
				  
				  newxAxis (list (- (nth 0 xAxis) (nth 0 origin)) (- (nth 1 xAxis) (nth 1 origin)) (- (nth 2 xAxis) (nth 2 origin)))
				  newyAxis (list (- (nth 0 yAxis) (nth 0 origin)) (- (nth 1 yAxis) (nth 1 origin)) (- (nth 2 yAxis) (nth 2 origin)))
		  
				  neworigin (vlax-3d-point (list 0.0 0.0 0.0))
				  newxAxis  (vlax-3d-point newxAxis)
				  newyAxis  (vlax-3d-point newyAxis)
				  newyAxis  (ortho_y_axis neworigin newxAxis newyAxis)
			)
			(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
			(setq UCSs (vla-get-UserCoordinateSystems doc))

			
			(setq NewUcs (vla-Add UCSs neworigin newxAxis newyAxis UcsName))
			(vla-put-origin NewUcs (vlax-3d-point origin))
			(vla-put-ActiveUCS doc NewUcs)
		)
	)
)
;
;
(defun SetUcs2P (p1glo p2glo UcsName / p3glo)

	(if (and p1glo p2glo UcsName)
		(progn
			(if (= (length p1glo) 2) (setq p1glo (list (car p1glo) (cadr p1glo) 0.0)))
			(if (= (length p2glo) 2) (setq p2glo (list (car p2glo) (cadr p2glo) 0.0)))
			
			(setq p3glo (per (car p2glo) (cadr p2glo) (car p1glo) (cadr p1glo) (- 0.0 1.0)))
			(SetUcs p1glo p2glo (list (car p3glo) (cadr p3glo) 0.0) UcsName)
		)
	)
)
;
;
(defun RestoreUcs (NameUcs / doc objUCS )
	(if NameUcs
		(progn
			(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
			(vlax-for objUCS (vla-get-UserCoordinateSystems doc)
				(if (equal (strcase (vla-get-name objUCS)) (strcase NameUcs))
					(vla-put-ActiveUCS doc objUCS)
				)
			) 
		)
	)
)
;
;
(defun DeleteUCS (NameUcs / objUCS)

	(if NameUcs
		(vlax-for objUCS (vla-get-UserCoordinateSystems (vla-get-ActiveDocument (vlax-get-acad-object)))
			;(princ "\n") (princ (strcase (vla-get-name objUCS)))
			(if (equal (strcase (vla-get-name objUCS))
					   (strcase NameUcs)
				)
				;(command "_UCS" "_D" (strcase NameUcs))
				(vla-delete objUCS)
			)
		) 
	)
)
;
;
(defun OriginUCS (Po NameUcs / Doc UcsActive Origin)

	(if (and NameUcs Po)
		(progn
			(setq Doc (vla-get-activedocument (vlax-get-acad-object)))
			(if (= (vlax-variant-value (vla-getvariable doc "UCSNAME")) NameUcs)
				(progn
					(setq UcsActive (vla-get-activeucs Doc))
					(setq Origin (vlax-3d-point Po))
					(vla-put-origin UcsActive Origin)
					(vla-put-activeucs Doc UcsActive)
					;(my_command (list "_UCS" "_O" (trans Po 0 1)))
				)
			)
		)
	)
)
;
;
(defun UcsRotateZ (Rad NameUcs / P0 P1 P2)

	(if Rad
		(progn
			(setq P0 (list 0.0 0.0))
			(setq P1 (polar P0 Rad 1.0))
			(setq P2 (per (car P1) (cadr P1) (car P0) (cadr P0) (- 0.0 1.0)))			
			(SetUcs (trans P0 1 0) (trans P1 1 0) (trans P2 1 0) NameUcs)
		)
	)
)
;
;
(defun ArbitraryAxis (p1 p2 / z rtn)

	(if (and p1 p2)
		(progn
			(setq z (mapcar '- p2 p1))
			(setq rtn (mapcar '(lambda ( v ) (trans v z 0 t))
				'(
					(1.0 0.0 0.0)
					(0.0 1.0 0.0)
					(0.0 0.0 1.0)
				)
			))
		)
	)
	rtn
)
;
;
(defun Rpt (P0 P1 Ang  / Rtn)

		(if (and P0 P1 Ang)
			(setq Rtn (list (+ (car  P0) (* (distance P0 P1) (cos (+ (angle P0 P1) Ang))))
						    (+ (cadr P0) (* (distance P0 P1) (sin (+ (angle P0 P1) Ang))))
					  )
			)
		)
		Rtn
)
;
;
(defun MyUcsAlignToUcs (Ucs / Preci Rtn)
	
	(if Ucs
		(progn
			(setq Preci 0.01)
			(cond 
				((equal (reverse (cdr (reverse (getvar "UCSXDIR")))) (Rpt '(0.0 0.0) (nth 1 Ucs) 0.0)        Preci)
					(setq Rtn 1)
				)
				((equal (reverse (cdr (reverse (getvar "UCSXDIR")))) (Rpt '(0.0 0.0) (nth 1 Ucs) (/ pi 2.0)) Preci)
					(setq Rtn 2)
				)
				((equal (reverse (cdr (reverse (getvar "UCSXDIR")))) (Rpt '(0.0 0.0) (nth 1 Ucs) pi)         Preci)
					(setq Rtn 3)
				)
				((equal (reverse (cdr (reverse (getvar "UCSXDIR")))) (Rpt '(0.0 0.0) (nth 1 Ucs) (/ (* pi 3.0) 2.0)) Preci)
					(setq Rtn 4)
				)
				((equal (reverse (cdr (reverse (getvar "UCSYDIR")))) (Rpt '(0.0 0.0) (nth 2 Ucs) 0.0)        Preci)
					(setq Rtn 11)
				)
				((equal (reverse (cdr (reverse (getvar "UCSYDIR")))) (Rpt '(0.0 0.0) (nth 2 Ucs) (/ pi 2.0)) Preci)
					(setq Rtn 12)
				)
				((equal (reverse (cdr (reverse (getvar "UCSYDIR")))) (Rpt '(0.0 0.0) (nth 2 Ucs) pi)         Preci)
					(setq Rtn 13)
				)
				((equal (reverse (cdr (reverse (getvar "UCSYDIR")))) (Rpt '(0.0 0.0) (nth 2 Ucs) (/ (* pi 3.0) 2.0)) Preci)
					(setq Rtn 14)
				)
			)
		)
	)
	Rtn
)
;
;
(defun ChkAlignUcs (Ucs1 Ucs2 / Preci Rtn)
	
	(setq Preci 0.01)
	(if (and Ucs1 Ucs2)
		(cond 
			((or (equal (reverse (cdr (reverse (nth 1 Ucs1)))) (Rpt '(0.0 0.0) (nth 1 Ucs2) 0.0)        Preci)
				 (equal (reverse (cdr (reverse (nth 2 Ucs1)))) (Rpt '(0.0 0.0) (nth 1 Ucs2) 0.0)        Preci))
				 (setq Rtn 1)
			)
			((or (equal (reverse (cdr (reverse (nth 1 Ucs1)))) (Rpt '(0.0 0.0) (nth 1 Ucs2) (/ pi 2.0)) Preci)
				 (equal (reverse (cdr (reverse (nth 2 Ucs1)))) (Rpt '(0.0 0.0) (nth 1 Ucs2) (/ pi 2.0)) Preci))
				 (setq Rtn 2)
			)
			((or (equal (reverse (cdr (reverse (nth 1 Ucs1)))) (Rpt '(0.0 0.0) (nth 1 Ucs2) pi)         Preci)
				 (equal (reverse (cdr (reverse (nth 2 Ucs1)))) (Rpt '(0.0 0.0) (nth 1 Ucs2) pi)         Preci))
				(setq Rtn 3)
			)
			((or (equal (reverse (cdr (reverse (nth 1 Ucs1)))) (Rpt '(0.0 0.0) (nth 1 Ucs2) (/ (* pi 3.0) 2.0)) Preci)
				 (equal (reverse (cdr (reverse (nth 2 Ucs1)))) (Rpt '(0.0 0.0) (nth 1 Ucs2) (/ (* pi 3.0) 2.0)) Preci))
				(setq Rtn 4)
			)
		)
	)
	Rtn
)	 
;
;
(defun Ucs_X_Direction (P1glo P2Glo / UcsDir P3glo)

		(if (and P1glo P2glo)
			(progn
				(setq UcsDir  (cons P1glo (ArbitraryAxis P1glo P2glo)))
				(setq P3glo   (TransG (nth 0 (nth 1 UcsDir))
									  (nth 1 (nth 1 UcsDir))
									  (nth 2 (nth 1 UcsDir)) UcsDir))
				(setq UcsDir  (DefPiano (nth 0 P1glo) (nth 1 P1glo) (nth 2 P1glo)
									    (nth 0 P2glo) (nth 1 P2glo) (nth 2 P2glo)
									    (nth 0 P3glo) (nth 1 P3glo) (nth 2 P3glo)))
			)
		)
		UcsDIr
)
;
;
(defun Ucs_X_Direction_Complanar (P1glo P2Glo / UcsDir P1Loc P2Loc P3Loc ZControl P3glo)
		
		(if (and P1glo P2glo)
			(progn
			
				(setq UcsDir (Get_Cos_Dir)
					  P1Loc (TransL (nth 0 P1Glo) (nth 1 P1Glo) (nth 2 P1Glo) UcsDir)
					  P2Loc (TransL (nth 0 P2Glo) (nth 1 P2Glo) (nth 2 P2Glo) UcsDir)
				)
				
				(if (equal (abs (- (nth 2 P1Loc) (nth 2 P2Loc))) 0.0 1e-10)
					(progn
						(setq  P3Loc    (Per (nth 0 P2Loc) (nth 1 P2Loc) (nth 0 P1Loc) (nth 1 P1Loc) -1.0)
						       ZControl (nth 2 P1Loc)
						       P3Glo    (TransG (nth 0 P3Loc) (nth 1 P3Loc) ZControl UcsDir) 
							   UcsDir   (DefPiano (nth 0 P1glo) (nth 1 P1glo) (nth 2 P1glo)
							                      (nth 0 P2glo) (nth 1 P2glo) (nth 2 P2glo)
									              (nth 0 P3glo) (nth 1 P3glo) (nth 2 P3glo))
						)
					)
				)
			)
		)
		UcsDIr
)
;
; 
(defun ObjectUcs (EnameObject / Insertion Normal_Axe Rotation Axis UcsDir XDir YDir adoc regUCS EnObj RandomUcsName)
	
	(if (and EnameObject)
		(progn
		
			(setq RandomUcsName (random_str 9))
			(while (tblsearch "UCS" RandomUcsName)
				(setq RandomUcsName (random_str 9))
			)
			
			(if (= (type EnameObject) 'ENAME)
				(setq EnObj (vlax-ename->vla-object EnameObject))
				(setq EnObj EnObj)
			)

			(cond
			
				((= (vla-get-objectname EnObj) "AcDbBlockReference")
				
					(setq   Insertion  (vlax-get EnObj 'InsertionPoint)
							Normal_Axe (vlax-get EnObj 'Normal)
							Rotation   (vlax-get EnObj 'Rotation)
							Axis       (ArbitraryAxis (list 0.0 0.0 0.0) Normal_Axe)
							UcsDir     (DefPiano 0.0 0.0 0.0
												(nth 0 (nth 0 Axis))
												(nth 1 (nth 0 Axis))
												(nth 2 (nth 0 Axis))
												(nth 0 (nth 1 Axis))
												(nth 1 (nth 1 Axis))
												(nth 2 (nth 1 Axis))
										)
							XDir       (Transg   (cos rotation) (sin rotation) 0.0 UcsDir)
							YDir       (Transg   (* -1 (sin rotation)) (cos rotation) 0 UcsDir)
			
							adoc       (vla-get-activedocument (vlax-get-acad-object))
							regUCS     (vla-add (vla-get-usercoordinateSystems adoc)
												(vlax-3D-point '(0 0 0))
												(vlax-3D-point XDir)
												(vlax-3D-point YDir)
												RandomUcsName
										)
					)
					(vla-put-origin regUCS (vlax-3d-point insertion 0 1))
					(vla-put-activeUCS adoc regUCS)
				)
			)
		)
	)
	RandomUcsName
)
;
;
(defun ChangeNormalPoint (/ Screen Object SsgetList conta layer)

	(UcsView1 "StructuraUcsNormal")
	
	;(setq Screen (VpCoords)
	;	  Object (cons '0 "Point")                            
	;	  SsgetList (ssget "_C" (nth 0 Screen) (nth 1 Screen) (list Object))
	;)
	
	(setq  Object (cons '0 "Point")                            
		   SsgetList (ssget "_X" (list Object))
	)
	
	(if SsgetList
		(progn
			(setq conta 0)
			(vla-put-lock (vla-item (vla-get-layers (vla-get-activedocument (vlax-get-acad-object))) layer4$) :vlax-false)

			(repeat (sslength SsgetList)
					(setq ename (ssname SsgetList conta))
					(vlax-safearray->list (vlax-variant-value (vlax-get-property (vlax-ename->vla-object ename) 'normal)))
					(vlax-put-property (vlax-ename->vla-object ename) 'normal (vlax-3D-point  (trans '(0 0 1) 1 0 T)))
					;(vla-update (vlax-ename->vla-object ename))
					(setq conta (1+ conta))
			)
			(vla-put-lock (vla-item (vla-get-layers (vla-get-activedocument (vlax-get-acad-object))) layer4$) :vlax-true)
		)
	)
)
;
;
(defun UcsView1(NameUcs / Axis doc UCSs NewUcs Twist UcsDir XDir YDir)
		
		
		(setq 	Axis (ArbitraryAxis (trans '(0 0 0) 1 0)
					 (trans (getvar "viewdir") 1 0))
				
				doc  (vla-get-ActiveDocument (vlax-get-acad-object))
				UCSs (vla-get-UserCoordinateSystems doc)

				NewUcs (vla-Add UCSs (vlax-3D-point '(0 0 0))
									 (vlax-3d-point (nth 0 Axis))
									 (vlax-3d-point (nth 1 Axis)) NameUcs)
		)
		(vla-put-ActiveUCS doc NewUcs)
		
		
		(setq Twist (* (getvar "VIEWTWIST") -1.0)
			  UcsDir	(Get_Cos_Dir)
			  XDir      (Transg   (cos Twist) (sin Twist) 0.0 UcsDir)
			  YDir      (Transg   (* -1 (sin Twist)) (cos Twist) 0 UcsDir)
			  
			  doc       (vla-get-activedocument (vlax-get-acad-object))
			  UCSs 		(vla-get-UserCoordinateSystems doc)
			  NewUcs 	(vla-Add UCSs (vlax-3D-point '(0 0 0))
													  (vlax-3D-point XDir)
													  (vlax-3D-point YDir) NameUcs)
		)
		(vla-put-ActiveUCS doc NewUcs)	
		
)
;
;
(defun UcsView ( / uuccss osnapcor ang_twist)
    ;
    ; uuccss +++++++
    ;
    (defun uuccss(/ tar dir osnapcor)
      (setq tar (getvar "VIEWCTR"))
      (setq dir (getvar "VIEWDIR"))
      (setq osnapcor (getvar "OSMODE"))
      (setvar "OSMODE" 0)
      (command "_UCS" "_ZA" tar dir)
      (setvar "OSMODE" osnapcor)
    )
    (uuccss)
    (uuccss)
    (setq osnapcor (getvar "OSMODE"))
    (setq ang_twist (/ (* (getvar "VIEWTWIST") 180.0) PI))
    (setvar "OSMODE" 0)
    (command "_UCS" "_Z" (* -1.0 ang_twist))
    (setvar "OSMODE" osnapcor)
)
;
;
(defun SetUcsPaperSpace (p1g p2g p3g / objUCS origin xAxis yAxis doc UCSs)

	; devi essere in modalita Paper Space
	
	(setq origin (vlax-3d-point p1g)
		  xAxis  (vlax-3d-point p2g)
		  yAxis  (vlax-3d-point p3g)
		  yAxis  (ortho_y_axis origin xAxis yAxis)
		  doc    (vla-get-ActiveDocument (vlax-get-acad-object))
		  UCSs   (vla-get-UserCoordinateSystems doc)
		  objUCS (vla-Add UCSs origin xAxis yAxis Ucs_Pspace$)
	)
	(vla-put-ActiveUCS doc objUCS)
)
;
;
(defun DefPiano2P (x1 y1 z1 x2 y2 z2 / p3 Rtn)

	(if (and x1 y1 z1 x2 y2 z2)
		(progn
			(setq p3 (per x2 y2 x1 y1 (- 0.0 1.0)))
			(setq Rtn (DefPiano x1 y1 z1 x2 y2 z2 (car p3) (cadr p3) 0.0))
		)
	)
	Rtn
)
;
;
(defun Pt->3dPt (Pt / Rtn)
	(if (= (length Pt) 2) 
		(setq Rtn (list (car Pt) (cadr Pt) 0.0))
		(setq Rtn Pt)
	)
)
;
;
(defun 3dPt->Pt (Pt)
	
	(if (= (length Pt) 3)
		(if (zerop (caddr Pt))
			(list (car Pt) (cadr Pt))
			Pt
		)
		Pt
	)
)
;
;
(defun DefPianoPt (Pt1 Pt2 Pt3)
	(if (and Pt1 Pt2 Pt3)
		(progn
			(setq Pt1 (Pt->3dPt Pt1)) 
			(setq Pt2 (Pt->3dPt Pt2))
			(setq Pt3 (Pt->3dPt Pt3))
			(DefPiano (car Pt1) (cadr Pt1) (caddr Pt1)
					  (car Pt2) (cadr Pt2) (caddr Pt2)
					  (car Pt3) (cadr Pt3) (caddr Pt3)		
			)
		)
	)
)
;
;
(defun DefPiano (x1 y1 z1 x2 y2 z2 x3 y3 z3 / Xorigine Yorigine Zorigine
                                              DeltaX DeltaY DeltaZ DeltaLung
                                              T11 T21 T31
                                              T12 T22 T32
                                              T13 T23 T33
                                              AAA cos_dir)
;
; procedura per il calcolo dei coseni direttori e degli assi di riferimento
; locali e le coordinate dell'origine del sistema locale partendo da tre
; punti nello spazio
;
  (setq T11 nil T21 nil T31 nil)
  (setq T12 nil T22 nil T32 nil)
  (setq T13 nil T23 nil T33 nil)
;
; coordinate della nuova origine (1^ punto)
;
  (setq Xorigine x1
        Yorigine y1
        Zorigine z1
  )
;
; coseni direttori dell'asse x locale
;
  (setq DeltaX (- x2 x1)
        DeltaY (- y2 y1)
        DeltaZ (- z2 z1)
  )
  (setq DeltaLung (sqrt (+ (* DeltaX DeltaX)
                           (* DeltaY DeltaY)
                           (* DeltaZ DeltaZ)
                        )
                   )
  )
  (if (= DeltaLung 0)
      (progn 
         (gest_err 14 "") 
         ;(set_ucs_viewport)
         (exit)
      )
      (progn
         (setq
             T11 (/ DeltaX DeltaLung)
             T21 (/ DeltaY DeltaLung)
             T31 (/ DeltaZ DeltaLung)
         )
      )
  )
;
; coseni direttori del secondo segmento del piano (1^ e 3^ punto)
;
  (setq DeltaX (- x3 x1)
        DeltaY (- y3 y1)
        DeltaZ (- z3 z1)
  )
  (setq DeltaLung (sqrt (+ (* DeltaX DeltaX)
                           (* DeltaY DeltaY)
                           (* DeltaZ DeltaZ)
                        )
                   )
  )
  (if (= DeltaLung 0)
       (progn 
          (gest_err 15 "") 
          ;(set_ucs_viewport)
          (exit)
       )
       (progn
         (setq T12 (/ DeltaX DeltaLung)
               T22 (/ DeltaY DeltaLung)
               T32 (/ DeltaZ DeltaLung)
         )
       )
  )
;
; coseni direttori dell'asse z locale
;
  (if (and (/= T11 nil) (/= T12 nil))
     (progn
       (setq T13 (- (* T21 T32) (* T31 T22))
             T23 (- (* T31 T12) (* T11 T32))
             T33 (- (* T11 T22) (* T21 T12))
       )
       (setq AAA (+ (* T13 T13) (* T23 T23) (* T33 T33)
                 )
       )
     )
  )
  (if (and (/= AAA 0) (/= AAA nil))
       (progn
         (setq DeltaLung (/ 1 (sqrt AAA))
               T13 (* T13 DeltaLung)
               T23 (* T23 DeltaLung)
               T33 (* T33 DeltaLung)
         )
       )
  )
;
; coseni direttori dell'asse y locale
;
  (if (and (/= T21 nil) (/= T12 nil))
       (progn
         (setq T12 (- (* T23 T31) (* T33 T21))
               T22 (- (* T33 T11) (* T13 T31))
               T32 (- (* T13 T21) (* T23 T11))
         )
         (setq AAA (+ (* T12 T12) (* T22 T22) (* T32 T32)
                   )
         )
       )
  )
  (if (and (/= AAA 0) (/= AAA nil))
       (progn
         (setq DeltaLung (/ 1 (sqrt AAA))
               T12 (* T12 DeltaLung)
               T22 (* T22 DeltaLung)
               T32 (* T32 DeltaLung)
         )
       )
  )
  (if (and (/= T11 nil) (/= T12 nil) (/= T13 nil))
      (setq cos_dir (list (list Xorigine Yorigine Zorigine)
                          (list T11 T21 T31)
                          (list T12 T22 T32)
                          (list T13 T23 T33)
                    )
      )
      (setq cos_dir nil)
  )
)
;
;
(defun Get_Cos_Dir (/ ucsx ucsy orig T11 T21 T31 T12 T22 T32 T13 T23 T33 cos_dir)
;
  (setq ucsx (getvar "UCSXDIR"))
  (setq ucsy (getvar "UCSYDIR"))
  (setq orig (getvar "UCSORG"))
;  
  (setq T11 (nth 0 ucsx)
        T21 (nth 1 ucsx)
        T31 (nth 2 ucsx)

        T12 (nth 0 ucsy)
        T22 (nth 1 ucsy)
        T32 (nth 2 ucsy)
;
        T13 (- (* T21 T32) (* T31 T22))
        T23 (- (* T31 T12) (* T11 T32))
        T33 (- (* T11 T22) (* T21 T12))
  )
   (setq cos_dir (list orig
                       (list T11 T21 T31)
                       (list T12 T22 T32)
                       (list T13 T23 T33)
                 )
   )
)
;
;
(defun TransGPt (Pt dir_cos)
	(if (and Pt dir_cos)
		(progn
			(if (= (length Pt) 2)
				(TransG (car Pt) (cadr Pt) 0.0 dir_cos)
				(TransG (car Pt) (cadr Pt) (caadr Pt) dir_cos)
			)
		)
	)
)
;
;
(defun TransG (x1 y1 z1 dir_cos / X0 Y0 Z0
                                  T11 T21 T31
                                  T12 T22 T32
                                  T13 T23 T33
                                  x y z punto)
;
; procedura per la conversione delle coordinate locali a globali
; x1 y1 z1 ...: coordinata globale da convertire
; dir_cos ....: lista  ( (X Y Z) (T11 T21 T31)  <--
;                                (T12 T22 T32)  <-- coseni direttor
;                                (T13 T23 T33)  <--
;                      )
;
(setq X0 (nth 0 (nth 0 dir_cos)))
(setq Y0 (nth 1 (nth 0 dir_cos)))
(setq Z0 (nth 2 (nth 0 dir_cos)))
  (setq T11 (nth 0 (nth 1 dir_cos)))
  (setq T21 (nth 1 (nth 1 dir_cos)))
  (setq T31 (nth 2 (nth 1 dir_cos)))
    (setq T12 (nth 0 (nth 2 dir_cos)))
    (setq T22 (nth 1 (nth 2 dir_cos)))
    (setq T32 (nth 2 (nth 2 dir_cos)))
      (setq T13 (nth 0 (nth 3 dir_cos)))
      (setq T23 (nth 1 (nth 3 dir_cos)))
      (setq T33 (nth 2 (nth 3 dir_cos)))
;
(setq x (+ (* T11 x1) (* T12 y1) (* T13 z1) X0))
(setq y (+ (* T21 x1) (* T22 y1) (* T23 z1) Y0))
(setq z (+ (* T31 x1) (* T32 y1) (* T33 z1) Z0))
(setq punto (list x y z))
)
;
;
(defun TransLPt (Pt dir_cos)
	(if (and Pt dir_cos)
		(progn
			(if (= (length Pt) 2)
				(TransL (car Pt) (cadr Pt) 0.0       dir_cos)
				(TransL (car Pt) (cadr Pt) (caddr Pt) dir_cos)
			)
		)
	)
)
;
;
(defun TransLPtNoZero (Pt dir_cos)
	(if (and Pt dir_cos)
		(if (= (length Pt) 2)
			(reverse (cdr (reverse (TransL (car Pt) (cadr Pt) 0.0        dir_cos))))
			(reverse (cdr (reverse (TransL (car Pt) (cadr Pt) (caddr Pt) dir_cos))))
		)
	)
)
;
;
(defun TransGPtNoZero (Pt dir_cos)
	(if (and Pt dir_cos)
		(if (= (length Pt) 2)
			(reverse (cdr (reverse (TransG (car Pt) (cadr Pt) 0.0        dir_cos))))
			(reverse (cdr (reverse (TransG (car Pt) (cadr Pt) (caddr Pt) dir_cos))))
		)
	)
)
;
;
(defun TransL (x1 y1 z1 cos_dir / X0 Y0 Z0
                                  T11 T21 T31
                                  T12 T22 T32
                                  T13 T23 T33
                                  x y z punto)
;
; procedura per la conversione delle coordinate globali a locali
; x1 y1 z1 ...: coordinata globale da convertire
; dir_cos ....: lista  ( (X Y Z) (T11 T21 T31)  <--
;                                (T12 T22 T32)  <-- coseni direttori
;                                (T13 T23 T33)  <--
;                      )
;
(setq X0 (nth 0 (nth 0 cos_dir)))
(setq Y0 (nth 1 (nth 0 cos_dir)))
(setq Z0 (nth 2 (nth 0 cos_dir)))
  (setq T11 (nth 0 (nth 1 cos_dir)))
  (setq T21 (nth 1 (nth 1 cos_dir)))
  (setq T31 (nth 2 (nth 1 cos_dir)))
    (setq T12 (nth 0 (nth 2 cos_dir)))
    (setq T22 (nth 1 (nth 2 cos_dir)))
    (setq T32 (nth 2 (nth 2 cos_dir)))
      (setq T13 (nth 0 (nth 3 cos_dir)))
      (setq T23 (nth 1 (nth 3 cos_dir)))
      (setq T33 (nth 2 (nth 3 cos_dir)))
;
(setq x (+ (* T11 (- x1 X0)) (* T21 (- y1 Y0)) (* T31 (- z1 Z0))))
(setq y (+ (* T12 (- x1 X0)) (* T22 (- y1 Y0)) (* T32 (- z1 Z0))))
(setq z (+ (* T13 (- x1 X0)) (* T23 (- y1 Y0)) (* T33 (- z1 Z0))))
(setq punto (list x y z))
)
;
;
(defun TransEcsToWcs (PtEcs EnameShape)
	(if (and PtEcs EnameShape)
		(trans (list (car PtEcs) (cadr PtEcs) (cdr (assoc 38 (entget EnameShape)))) (cdr (assoc 210 (entget EnameShape))) 0)
	)
)
;
;
(defun TransWcsToEcs (PtWcs EnameShape)
	(if (and PtWcs EnameShape)
		(trans (trans PtWcs 1 0) 0 (cdr (assoc 210 (entget EnameShape))))
	)
)
;
;
(defun TransLstPointTo (LstPt Flag / itm Rtn)

	(foreach itm LstPt
		(if (= Flag 1)
			(setq Rtn (append (list (trans itm 0 1)) Rtn)) 
			(setq Rtn (append (list (trans itm 1 0)) Rtn))
		)
	)
	Rtn
)
;
;
(defun MTransLstPointTo (LstPt Flag UcsName / itm Rtn)

	(foreach itm LstPt
		
		(if (= (length itm) 2)
			(setq itm (append itm (list 0.0)))
		)

		(if (= Flag 1)
			(setq Rtn (append Rtn (list (transl (car itm) (cadr itm) (caddr itm) UcsName))))
			(setq Rtn (append Rtn (list (transg (car itm) (cadr itm) (caddr itm) UcsName))))
		)
	)
	Rtn
)
;
;
(defun ExportUcsDirVport (HandleVport Cos_Dir / Dec FileW)


		(if (and HandleVport Cos_Dir)
			(progn
				(setq Dec 20)
				(setq FileW (open (strcat (getvar "XLOADPATH")  HandleVport ".ucs") "w"))
				(if FileW
					(princ (strcat 	(rtos (nth 0 (nth 0 Cos_Dir)) 2 Dec) "*"			
									(rtos (nth 1 (nth 0 Cos_Dir)) 2 Dec) "*"
									(rtos (nth 2 (nth 0 Cos_Dir)) 2 Dec) "*"
									(rtos (nth 0 (nth 1 Cos_Dir)) 2 Dec) "*"			
									(rtos (nth 1 (nth 1 Cos_Dir)) 2 Dec) "*"
									(rtos (nth 2 (nth 1 Cos_Dir)) 2 Dec) "*"
									(rtos (nth 0 (nth 2 Cos_Dir)) 2 Dec) "*"			
									(rtos (nth 1 (nth 2 Cos_Dir)) 2 Dec) "*"
									(rtos (nth 2 (nth 2 Cos_Dir)) 2 Dec) "*"
									(rtos (nth 0 (nth 3 Cos_Dir)) 2 Dec) "*"			
									(rtos (nth 1 (nth 3 Cos_Dir)) 2 Dec) "*"
									(rtos (nth 2 (nth 3 Cos_Dir)) 2 Dec)
							) FileW
					)
				)
				(close FileW)
			)
		)
)
;
;
(defun ImportUcsDirVport (HandleVport / FileR Line LineSplit Doc UCSs NewUcs)

	(if HandleVport
		(progn
			(setq FileR (open (strcat (getvar "XLOADPATH")  HandleVport ".ucs") "r"))
			(if FileR
				(progn
					(if (setq Line (read-line FileR))
						(setq LineSplit (splitxt Line "*"))
					)
				)
			)
			(close FileR)
			(if LineSplit
				(progn
					(setq 	Doc  (vla-get-ActiveDocument (vlax-get-acad-object))
							UCSs (vla-get-UserCoordinateSystems Doc)
							NewUcs (vla-Add UCSs (vlax-3D-point '(0 0 0))
										(vlax-3d-point (list (atof (nth 3 LineSplit)) (atof (nth 4 LineSplit)) (atof (nth 5 LineSplit))))
										(vlax-3d-point (list (atof (nth 6 LineSplit)) (atof (nth 7 LineSplit)) (atof (nth 8 LineSplit))))
										Ucs_Window$)
					)
					(vla-put-ActiveUCS Doc NewUcs)
					(vla-put-origin NewUcs (vlax-3d-point (list (atof (nth 0 LineSplit)) (atof (nth 1 LineSplit)) (atof (nth 2 LineSplit)))))
					(vla-put-activeUCS Doc NewUcs)
				)
			)
		)
	)
)
;
;
(defun c:random_plan ()

	(setq x_p1 (atof (random_str 9)))
	(while (= x_p1 (setq y_p1 (atof (random_str 9)))))
	(while (= y_p1 (setq z_p1 (atof (random_str 9)))))

	(while (= z_p1 (setq x_p2 (atof (random_str 9)))))
	(while (= x_p2 (setq y_p2 (atof (random_str 9)))))
	(while (= y_p2 (setq z_p2 (atof (random_str 9)))))

	(while (= z_p2 (setq x_p3 (atof (random_str 9)))))
	(while (= x_p3 (setq y_p3 (atof (random_str 9)))))
	(while (= y_p3 (setq z_p3 (atof (random_str 9)))))

	(command "_UCS" "_3p" (list x_p1 y_p1 z_p1) (list x_p2 y_p2 z_p2) (list x_p3 y_p3 z_p3))

)
;
;
(defun AlignObject (obj p1start p2start p3start p1end p2end p3end Flag / Overlay_Ucs100 Rotate_Object
																		  cos_obj p1 p2 p3 p4
																		  Angle_Rotation Rtn
																		  CosDir)



	(defun Overlay_Ucs100 (p1m p2m p3m p1s p2s p3s / CosDirM CosDirS normalM_z 
													 axeM_x axeM_z
													 axeS_x axeS_z
													 axeS->M_x axeS->M_z
													 RxS RxM Rx
													 RyS RyM Ry
													 RzS RzM Rz pxS pzS)
		
			(if (and p1m p2m p3m p1s p2s p3s)
				(progn
					
					(setq 
						  CosDirM (defpiano (nth 0 p1m) (nth 1 p1m) (nth 2 p1m)	
											(nth 0 p2m) (nth 1 p2m) (nth 2 p2m)
											(nth 0 p3m) (nth 1 p3m) (nth 2 p3m)
								  )
						  CosDirS (defpiano (nth 0 p1s) (nth 1 p1s) (nth 2 p1s)	
											(nth 0 p2s) (nth 1 p2s) (nth 2 p2s)
											(nth 0 p3s) (nth 1 p3s) (nth 2 p3s)
								  )
						  normalM_z (transg 0.0 0.0 1000.0 CosDirM)							  		  
						  
						  CosDirM (list (list 0.0 0.0 0.0) (nth 1 CosDirM) (nth 2 CosDirM) (nth 3 CosDirM))
						  CosDirS (list (list 0.0 0.0 0.0) (nth 1 CosDirS) (nth 2 CosDirS) (nth 3 CosDirS))
								  
						  axeM_x   (nth 1 CosDirM)
						  axeM_z   (nth 3 CosDirM)							  
						  
						  axeS_x   (nth 1 CosDirS)
						  axeS_z   (nth 3 CosDirS)

						  axeS->M_x  (transl (nth 0 axeS_x) (nth 1 axeS_x) (nth 2 axeS_x) CosDirM)
						  axeS->M_z  (transl (nth 0 axeS_z) (nth 1 axeS_z) (nth 2 axeS_z) CosDirM)
						  
						  RxS  (ang_x 0.0 0.0 (nth 1 axeS->M_z) (nth 2 axeS->M_z))
						  RxM  (/ (* 90.0 pi) 180.0) 
						  Rx (- RxM RxS)
						  ;
						  ; ruoto il piano sull' asse X
						  ;
						  pxS (dca 0.0 0.0 (nth 1 axeS->M_x) (nth 2 axeS->M_x) Rx)
						  pzS (dca 0.0 0.0 (nth 1 axeS->M_z) (nth 2 axeS->M_z) Rx)
						 
						  axeS->M_x (list (nth 0 axeS->M_x) (nth 0 pxS) (nth 1 pxS))
						  axeS->M_z (list (nth 0 axeS->M_z) (nth 0 pzS) (nth 1 pzS))
						  
						  RyS  (ang_x 0.0 0.0 (nth 0 axeS->M_z) (nth 2 axeS->M_z))
						  RyM  (/ (* 90.0 pi) 180.0) 
						  Ry (- RyM RyS)
						  
						  ;
						  ; ruoto il piano sull' asse Y
						  ;
						  pxS (dca 0.0 0.0 (nth 0 axeS->M_x) (nth 2 axeS->M_x) Ry)
						  
						  axeS->M_x (list (nth 0 pxS) (nth 1 axeS->M_x) (nth 1 pxS))
						  
						  RzS  (ang_x 0.0 0.0 (nth 0 axeS->M_x) (nth 1 axeS->M_x))
						  
						  RzM  0.0
						  Rz (- RzM RzS)
					)
				)
			)
			(list Rx (* Ry -1.0) Rz normalM_z)
			
	)
	;
	;
	;
	(defun Rotate_Object (obj pa pb ang)

		(if (and obj pa pb ang)
			(progn
			
				(and (= (type obj) 'ENAME)
					(setq obj (vlax-ename->vla-object obj))
				)
				
				(vla-rotate3d obj (vlax-3d-point pa) (vlax-3d-point pb) ang)
			
			)
		)
	)
	;
	; Main
	;
	(if (and obj p1start p2start p3start p1end p2end p3end)
		(progn
			
			(if (= (length p1start) 2) (setq p1start (list (car p1start) (cadr p1start) 0.0)))
			(if (= (length p2start) 2) (setq p2start (list (car p2start) (cadr p2start) 0.0)))
			(if (= (length p3start) 2) (setq p3start (list (car p3start) (cadr p3start) 0.0)))

			(if (= (length p1end) 2) (setq p1end (list (car p1end) (cadr p1end) 0.0)))
			(if (= (length p2end) 2) (setq p2end (list (car p2end) (cadr p2end) 0.0)))
			(if (= (length p3end) 2) (setq p3end (list (car p3end) (cadr p3end) 0.0)))

			(setq Angle_Rotation (overlay_ucs100 p1end p2end p3end p1start p2start p3start))
		
			(and (= (type obj) 'ENAME)
				(setq obj (vlax-ename->vla-object obj))
			)
			
			(if Flag (setq Rtn (vla-copy obj)) (setq Rtn obj))
			
			(vla-move Rtn (vlax-3d-point p1start) (vlax-3d-point p1end))
		
			
	        (setq CosDir (DefPiano (nth 0 p1end) (nth 1 p1end) (nth 2 p1end)	
						           (nth 0 p2end) (nth 1 p2end) (nth 2 p2end)
								   (nth 0 p3end) (nth 1 p3end) (nth 2 p3end)
						 )
				  p1     (transg 0.0 0.0 0.0 CosDir)
				  p2     (transg 1.0 0.0 0.0 CosDir)
				  p3     (transg 0.0 1.0 0.0 CosDir)
				  p4     (transg 0.0 0.0 1.0 CosDir)
			      					  		  
		    )
			
		    ;(getstring "\nRuota X")
			(Rotate_Object Rtn (list (nth 0 p1) (nth 1 p1) (nth 2 p1))
							   (list (nth 0 p2) (nth 1 p2) (nth 2 p2))
					           (nth 0 Angle_Rotation))
							   
		    ;(getstring "\nRuota Y")
		    (Rotate_Object Rtn (list (nth 0 p1) (nth 1 p1) (nth 2 p1))
							   (list (nth 0 p3) (nth 1 p3) (nth 2 p3))
							   (nth 1 Angle_Rotation))
							   
		    ;(getstring "\nRuota Z")
		    (Rotate_Object Rtn (list (nth 0 p1) (nth 1 p1) (nth 2 p1))
						       (list (nth 0 p4) (nth 1 p4) (nth 2 p4))
						       (nth 2 Angle_Rotation))
							   
			(setq Rtn (vlax-vla-object->ename Rtn))
		)
	)
    Rtn
)
;
;
(defun TangentToArc (arc pt / mid tmp)

	;; TangentToArc (gile)
	;; Returns the tangent points list from the given point to the arc (or circle)
	;;
	;; Arguments
	;; arc: an arc or circle (vla-object)
	;; pt: a 3d point

	(setq	mid (mapcar '(lambda (x1 x2) (/ (+ x1 x2) 2.))
				(vlax-get arc 'Center)
				pt
			)
			tmp (vla-AddCircle (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object))) (vlax-3d-point mid) (distance mid pt))
	)
	(if (setq int (vlax-invoke arc 'IntersectWith tmp acExtendNone))
		(setq int
			(cons
				(list (car int) (cadr int) (caddr int))
				(if (cdddr int)
					(list (list (nth 3 int) (nth 4 int) (nth 5 int)))
				)
			)
		)
	)
	(vla-Delete tmp)
	int
)
;
;
(defun RotatePoint (LstPoint Px Rotation / itm Rtn)

	(if (and LstPoint Px Rotation)
		(foreach itm LstPoint
			(setq Rtn (append Rtn (list (Dca (car Px) (cadr Px) (car itm) (cadr itm) Rotation))))
		)
	)
	Rtn
)
;
;
(defun MidPoint (p1 p2)
	(mapcar (function (lambda (e1 e2) (/ (+ e1 e2) 2.))) p1 p2)
)
;
;
(defun MirrorPoint (LstPoint Px AngleMirror / ReflectedPoint 
											  Rtn)

	(defun ReflectedPoint (Pa Pb LstPt / itm Rtn)
		(foreach itm LstPt
			(setq Rtn (append Rtn (list (polar pa (- (* 2 (angle pa pb)) (angle pa itm)) (distance pa itm)))))
		)
	)
	;
	;
	(if (and LstPoint Px AngleMirror)
		(setq Rtn (ReflectedPoint Px (polar Px AngleMirror 1.0) LstPoint))
	)
	Rtn
)
;
;
(defun TraslatePoint (LstPoint PtStart PtEnd / itm Rtn DeltaX DeltaY)

	;
	(if (and LstPoint PtStart PtEnd)
		(progn
			(setq DeltaX (- (car PtEnd) (car PtStart)))
			(setq DeltaY (- (cadr PtEnd) (cadr PtStart)))
				
			(foreach itm LstPoint
				(setq Rtn (append Rtn (list (list (+ (car itm ) DeltaX)
									              (+ (cadr itm ) DeltaY)))))
			)
		)
	)
	Rtn
)
;
;
(defun IntersectionsFuzz (ob1 ob2 Accuracy / lst PtInt itm Rtn)

	
    (if (and (vlax-method-applicable-p ob1 'intersectwith)
             (vlax-method-applicable-p ob2 'intersectwith)
             (setq lst (vlax-invoke ob1 'intersectwith ob2 acextendboth))
        )
        (repeat (/ (length lst) 3)
            (setq PtInt (cons (list (car lst) (cadr lst) (caddr lst)) PtInt)
                  lst (cdddr lst)
            )
        )
    )
	(foreach itm PtInt
		(if (and (equal (vlax-curve-getClosestPointTo (vlax-vla-object->ename ob1) itm) itm Accuracy)
			     (equal (vlax-curve-getClosestPointTo (vlax-vla-object->ename ob2) itm) itm Accuracy)
			)
				(setq Rtn (append Rtn (list itm)))
		)
	)
    (reverse Rtn)
)
;
; Carnot
;
(defun CarnotAng (P1 P2 P3 / acos _a _b _c)
	;
	;           P2
	;           +
	;         / | \
	;    b  /       \  a
	;     /           \
	;	 +-------------+
	;	 P1    c        p3
	;
	(defun acos (num)
		(cond
			((equal num 1 1e-9) 0.0)
			((equal num -1 1e-9) pi)
			((< -1 num 1)
				(atan (sqrt (- 1 (expt num 2))) num)
			)
		)
	)
	(if (and P1 P2 P3)
		(progn
			(if (> (setq _c (distance P1 P3)) 0.0)
				(if (>  (setq _b (distance P1 P2)) 0.0)
					(if (> 	(setq _a (distance P2 P3)) 0.0)
						(acos (/ (- (+ (* _a _a) (* _b _b)) (* _c _c)) (* 2.0 _a _b)))
					)
				)
			)
		)
	)
)