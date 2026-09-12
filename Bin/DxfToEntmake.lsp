;(Dxf2Entity "C:\\Users\\adl20\\EasyCut\\Output\\Nesting\\RectPack_0.dxf" (getpoint) nil)
(defun Dxf2Entity (FileName PtInsert Stream / MakeLine     MakeArc 
											  MakeCircle   MakeLwPolyline
											  MakePolyline MakeEllipse 
											  MakeSpline   NextStep 	  
											  ValidateEntity ValidateOutput
											  StremRead FoundEntities Line Loop Ename MaxMinCatch itm LstEname LineRead
											  LstUnmanagedEname NLine NArc NCircle NPoly NElli NSpline Nerr1 Nerr2 Nerr3)


	(defun MakeLine (/ LstRecord Line1 Line2 Vx Vy Vz)
	
		(setq LstRecord (append LstRecord (list (cons 0 "LINE"))))
		(setq LstRecord (append LstRecord (list (cons 8 "0"))))
	
		(while (and (setq Line1 (read-line StremRead)) (setq Line2 (read-line StremRead))
					(/= (vl-string-trim " " Line1) "0") (/= (vl-string-trim " " Line1) "1001")
				)
			(cond
				((= (vl-string-trim " " Line1) "10") (setq Vx (atof Line2)))
				((= (vl-string-trim " " Line1) "20") (setq Vy (atof Line2)))
				((= (vl-string-trim " " Line1) "30") (setq Vz (atof Line2))
					(setq LstRecord	(append	LstRecord (list (cons 10 (list Vx Vy Vz)))))
				)
				((= (vl-string-trim " " Line1) "11") (setq Vx (atof Line2)))
				((= (vl-string-trim " " Line1) "21") (setq Vy (atof Line2)))
				((= (vl-string-trim " " Line1) "31") (setq Vz (atof Line2))
					(setq LstRecord	(append	LstRecord (list (cons 11 (list Vx Vy Vz)))))
				)
			)
		)
		;; Se abbiamo incontrato il codice 0,
		;; Line2 contiene già il nome della prossima entità, se 1001 prossimo step
		(if Line1
			(cond
				((= (vl-string-trim " " Line1) "0")
					(setq Ename (strcase (vl-string-trim " " Line2)))
				)
				((= (vl-string-trim " " Line1) "1001")
					(setq Ename (NextStep))
				)
				(T 
					(setq Ename nil)
				)
			)
			(setq Ename nil)
		)	
		;(if Line1
		;	(if (= (vl-string-trim " " Line1) "0")
		;		(setq Ename (strcase (vl-string-trim " " Line2)))
		;		(setq Ename nil)
		;	)
		;	(setq Ename nil)
		;)
		
		(if (ValidateEntity "LINE" LstRecord)
			(if (setq Rtn (entmakex LstRecord))
				Rtn
				-1 ; errore creazione dell'entità
			)
			-2 ; dati insufficienti
		)
	)
	;
	(defun MakeArc (/ LstRecord Line1 Line2 Vx Vy Vz)
	
		(setq LstRecord (append LstRecord (list (cons 0 "ARC"))))
		(setq LstRecord (append LstRecord (list (cons 8 "0"))))

		(while (and (setq Line1 (read-line StremRead)) (setq Line2 (read-line StremRead))
					(/= (vl-string-trim " " Line1) "0") (/= (vl-string-trim " " Line1) "1001")
				)
			(cond
				((= (vl-string-trim " " Line1) "10") (setq Vx (atof Line2)))
				((= (vl-string-trim " " Line1) "20") (setq Vy (atof Line2)))
				((= (vl-string-trim " " Line1) "30") (setq Vz (atof Line2))
					(setq LstRecord	(append	LstRecord (list (cons 10 (list Vx Vy Vz)))))
				)
				((= (vl-string-trim " " Line1) "40")
					(setq LstRecord (append LstRecord (list (cons 40 (atof Line2)))))
				)
				((= (vl-string-trim " " Line1) "50")
					(setq LstRecord (append LstRecord (list (cons 50 (/ (* (atof Line2) pi) 180.0)))))
				)
				((= (vl-string-trim " " Line1) "51")
					(setq LstRecord (append LstRecord (list (cons 51 (/ (* (atof Line2) pi) 180.0)))))
				)
			)
		)
		;; Se abbiamo incontrato il codice 0,
		;; Line2 contiene già il nome della prossima entità, se 1001 prossimo step
		(if Line1
			(cond
				((= (vl-string-trim " " Line1) "0")
					(setq Ename (strcase (vl-string-trim " " Line2)))
				)
				((= (vl-string-trim " " Line1) "1001")
					(setq Ename (NextStep))
				)
				(T 
					(setq Ename nil)
				)
			)
			(setq Ename nil)
		)	
		;(if Line1
		;	(if (= (vl-string-trim " " Line1) "0")
		;		(setq Ename (strcase (vl-string-trim " " Line2)))
		;		(setq Ename nil)
		;	)
		;	(setq Ename nil)
		;)
		
		(if (ValidateEntity "ARC" LstRecord)
			(if (setq Rtn (entmakex LstRecord))
				Rtn
				-1 ; errore creazione dell'entità
			)
			-2 ; dati insufficienti
		)
	)
	;
	(defun MakeCircle (/ LstRecord Line1 Line2 Vx Vy Vz)

		(setq LstRecord (append LstRecord (list (cons 0 "CIRCLE"))))
		(setq LstRecord (append LstRecord (list (cons 8 "0"))))
	
		(while (and (setq Line1 (read-line StremRead)) (setq Line2 (read-line StremRead))
					(/= (vl-string-trim " " Line1) "0") (/= (vl-string-trim " " Line1) "1001")
				)
			(cond
				((= (vl-string-trim " " Line1) "10") (setq Vx (atof Line2)))
				((= (vl-string-trim " " Line1) "20") (setq Vy (atof Line2)))
				((= (vl-string-trim " " Line1) "30") (setq Vz (atof Line2))
					(setq LstRecord	(append	LstRecord (list (cons 10 (list Vx Vy Vz)))))
				)
				((= (vl-string-trim " " Line1) "40")
					(setq LstRecord (append LstRecord (list (cons 40 (atof Line2)))))
				)
			)
		)
		;; Se abbiamo incontrato il codice 0,
		;; Line2 contiene già il nome della prossima entità, se 1001 prossimo step
		(if Line1
			(cond
				((= (vl-string-trim " " Line1) "0")
					(setq Ename (strcase (vl-string-trim " " Line2)))
				)
				((= (vl-string-trim " " Line1) "1001")
					(setq Ename (NextStep))
				)
				(T 
					(setq Ename nil)
				)
			)
			(setq Ename nil)
		)	
		;(if Line1
		;	(if (= (vl-string-trim " " Line1) "0")
		;		(setq Ename (strcase (vl-string-trim " " Line2)))
		;		(setq Ename nil)
		;	)
		;	(setq Ename nil)
		;)
		
		(if (ValidateEntity "CIRCLE" LstRecord)
			(if (setq Rtn (entmakex LstRecord))
				Rtn
				-1 ; errore creazione dell'entità
			)
			-2 ; dati insufficienti
		)
	)
	;
	(defun MakeLwPolyline (/ LstRecord Line1 Line2 Vx Vy)
	
		(setq LstRecord (append LstRecord (list (cons 0 "LWPOLYLINE"))))
		(setq LstRecord (append LstRecord (list (cons 8 "0"))))
		(setq LstRecord (append LstRecord (list (cons 100 "AcDbEntity"))))
		(setq LstRecord (append LstRecord (list (cons 100 "AcDbPolyline"))))

		(while (and (setq Line1 (read-line StremRead)) (setq Line2 (read-line StremRead))
					(/= (vl-string-trim " " Line1) "0") (/= (vl-string-trim " " Line1) "1001")
				)
				(cond
					((= (vl-string-trim " " Line1) "90") (setq LstRecord (append LstRecord (list (cons 90 (atoi Line2))))))
					((= (vl-string-trim " " Line1) "70") (setq LstRecord (append LstRecord (list (cons 70 (atoi Line2))))))
					((= (vl-string-trim " " Line1) "38") (setq LstRecord (append LstRecord (list (cons 38 (atof Line2))))))
					((= (vl-string-trim " " Line1) "39") (setq LstRecord (append LstRecord (list (cons 39 (atof Line2))))))
					((= (vl-string-trim " " Line1) "10") (setq Vx (atof Line2)))
					((= (vl-string-trim " " Line1) "20") (setq Vy (atof Line2))
						(setq LstRecord (append LstRecord (list (cons 10 (list Vx Vy)))))
					)
					((= (vl-string-trim " " Line1) "40") (setq LstRecord (append LstRecord (list (cons 40 (atof Line2))))))
					((= (vl-string-trim " " Line1) "41") (setq LstRecord (append LstRecord (list (cons 41 (atof Line2))))))
					((= (vl-string-trim " " Line1) "42") (setq LstRecord (append LstRecord (list (cons 42 (atof Line2))))))
				)
		)
		;; Se abbiamo incontrato il codice 0,
		;; Line2 contiene già il nome della prossima entità, se 1001 prossimo step
		(if Line1
			(cond
				((= (vl-string-trim " " Line1) "0")
					(setq Ename (strcase (vl-string-trim " " Line2)))
				)
				((= (vl-string-trim " " Line1) "1001")
					(setq Ename (NextStep))
				)
				(T 
					(setq Ename nil)
				)
			)
			(setq Ename nil)
		)	
		;(if Line1
		;	(if (= (vl-string-trim " " Line1) "0")
		;		(setq Ename (strcase (vl-string-trim " " Line2)))
		;		(setq Ename nil)
		;	)
		;	(setq Ename nil)
		;)
		
		(if (ValidateEntity "LWPOLYLINE" LstRecord)
			(if (setq Rtn (entmakex LstRecord))
				Rtn
				-1 ; errore creazione dell'entità
			)
			-2 ; dati insufficienti
		)
	)
	;
	(defun MakePolyline (/ LstRecord Line1 Line2 Flags Elevation
						   Vx Vy Vz Bulge VertexCount PolylineOK Rtn)

		(setq LstRecord nil)
		(setq Flags 0)
		(setq Elevation 0.0)
		(setq VertexCount 0)
		(setq PolylineOK T)

		;; ============================================================
		;; LETTURA HEADER POLYLINE
		;; ============================================================
		(while (and (setq Line1 (read-line StremRead)) (setq Line2 (read-line StremRead))
					(/= (vl-string-trim " " Line1) "0") (/= (vl-string-trim " " Line1) "1001")
				)
			(cond
				((= (vl-string-trim " " Line1) "70") (setq Flags (atoi Line2))) ;; Flag POLYLINE
				((= (vl-string-trim " " Line1) "30") (setq Elevation (atof Line2))) ;; Elevazione
			)
		)
		;; ============================================================
		;; VERIFICA PROSSIMA ENTITA'
		;; Deve essere VERTEX
		;; ============================================================
		(if (and Line1 Line2 (= (vl-string-trim " " Line1) "0") (= (strcase (vl-string-trim " " Line2)) "VERTEX"))
			(progn
				;; ----------------------------------------------------
				;; Verifica tipo POLYLINE
				;;
				;; 8  = 3D POLYLINE
				;; 16 = polygon mesh
				;; 64 = polyface mesh
				;; ----------------------------------------------------
				(if (or	(/= (logand Flags 8) 0)
						(/= (logand Flags 16) 0)
						(/= (logand Flags 64) 0)
					)
					(setq PolylineOK nil)
				)
				(if PolylineOK
					(progn
						;; =================================================
						;; COSTRUZIONE HEADER LWPOLYLINE
						;; =================================================
						(setq LstRecord
							(list
								(cons 0 "LWPOLYLINE")
								(cons 100 "AcDbEntity")
								(cons 8 "0")
								(cons 100 "AcDbPolyline")
								(cons 90 0)
								(cons 70 (logand Flags 1))
								(cons 38 Elevation)
							)
						)
						(setq Ename	(strcase (vl-string-trim " " Line2)))
						;; =================================================
						;; LETTURA VERTEX
						;; =================================================
						(while (= Ename "VERTEX")
							(setq Vx nil)
							(setq Vy nil)
							(setq Vz 0.0)
							(setq Bulge 0.0)
							;; ---------------------------------------------
							;; Lettura dati VERTEX
							;; ---------------------------------------------
							(while
								(and (setq Line1 (read-line StremRead))	(setq Line2 (read-line StremRead))
									(/= (vl-string-trim " " Line1) "0")	(/= (vl-string-trim " " Line1) "1001")
								)
								(cond
									((= (vl-string-trim " " Line1) "10") (setq Vx (atof Line2)))
									((= (vl-string-trim " " Line1) "20") (setq Vy (atof Line2)))
									((= (vl-string-trim " " Line1) "30") (setq Vz (atof Line2)))
									;; Bulge
									((= (vl-string-trim " " Line1) "42") (setq Bulge (atof Line2)))
								)
							)
							;; ---------------------------------------------
							;; Aggiunge VERTEX alla LWPOLYLINE
							;; ---------------------------------------------
							(if (and Vx Vy)
								(progn
									(setq LstRecord	(append	LstRecord (list	(cons 10 (list Vx Vy)))))
									;; Mantiene l'eventuale arco
									(if (/= Bulge 0.0)
										(setq LstRecord	(append LstRecord (list	(cons 42 Bulge))))
									)
									(setq VertexCount (1+ VertexCount))
								)
							)
							;; ---------------------------------------------
							;; Line1 = 0
							;; Line2 = prossima entità
							;; ---------------------------------------------
							(if (and Line1 Line2)
								(setq Ename	(strcase (vl-string-trim " " Line2)))
								(setq Ename nil)
							)
						)
						;; =================================================
						;; Aggiorna numero effettivo dei vertici
						;; =================================================
						(setq LstRecord
							(subst (cons 90 VertexCount) (assoc 90 LstRecord) LstRecord)
						)
						;; =================================================
						;; SEQEND
						;; =================================================
						(if (= Ename "SEQEND")
							(setq Ename (NextStep))
						)
						;; =================================================
						;; CREAZIONE LWPOLYLINE
						;; =================================================
						(if (> VertexCount 1)
							(if (not (setq Rtn (entmakex LstRecord)))
								-1 ; errore creazione dell'entità
							)
							-2 ; dati insufficienti
						)

					)
					;; ==================================================
					;; POLYLINE NON SUPPORTATA
					;; ==================================================
					(progn
						(princ "\nPOLYLINE 3D/MESH esclusa dall'import.")
						;; In questo punto Ename = "VERTEX".
						;; Bisogna saltare tutta la struttura fino
						;; alla prossima entità.
						(setq Ename (NextStep))
					)
				)
			)
			;; ========================================================
			;; POLYLINE senza VERTEX
			;; ========================================================
			(progn
				(if Line2 (setq Ename (strcase (vl-string-trim " " Line2)))
					(setq Ename nil)
				)
			)
		)
		Rtn
	)
	;
	(defun MakeEllipse (/ LstRecord Line1 Line2 Vx Vy Vz)
	
		(setq LstRecord (append LstRecord (list (cons 0 "ELLIPSE"))))
		(setq LstRecord (append LstRecord (list (cons 8 "0"))))
		(setq LstRecord (append LstRecord (list (cons 100 "AcDbEntity"))))
		(setq LstRecord (append LstRecord (list (cons 100 "AcDbEllipse"))))

		(while (and (setq Line1 (read-line StremRead)) (setq Line2 (read-line StremRead))
					(/= (vl-string-trim " " Line1) "0") (/= (vl-string-trim " " Line1) "1001")
				)
			(cond
				; Centro X Y Z
				((= (vl-string-trim " " Line1) "10") (setq Vx (atof Line2)))
				((= (vl-string-trim " " Line1) "20") (setq Vy (atof Line2)))
				((= (vl-string-trim " " Line1) "30") (setq Vz (atof Line2))
					(setq LstRecord	(append	LstRecord (list (cons 10 (list Vx Vy Vz)))))
				)
				; Vettore asse maggiore X Y Z
				((= (vl-string-trim " " Line1) "11") (setq Vx (atof Line2)))
				((= (vl-string-trim " " Line1) "21") (setq Vy (atof Line2)))
				((= (vl-string-trim " " Line1) "31") (setq Vz (atof Line2))
					(setq LstRecord	(append LstRecord (list	(cons 11 (list Vx Vy Vz)))))
				)
				; Rapporto asse minore / asse maggiore
				((= (vl-string-trim " " Line1) "40")
					(setq LstRecord (append	LstRecord (list	(cons 40 (atof Line2)))))
				)
				; Parametro iniziale
				((= (vl-string-trim " " Line1) "41")
					(setq LstRecord	(append LstRecord (list	(cons 41 (atof Line2)))))
				)
				; Parametro finale
				((= (vl-string-trim " " Line1) "42")
					(setq LstRecord (append LstRecord (list	(cons 42 (atof Line2)))))
				)
			)
		)
		;; Se abbiamo incontrato il codice 0,
		;; Line2 contiene già il nome della prossima entità, se 1001 prossimo step
		(if Line1
			(cond
				((= (vl-string-trim " " Line1) "0")
					(setq Ename (strcase (vl-string-trim " " Line2)))
				)
				((= (vl-string-trim " " Line1) "1001")
					(setq Ename (NextStep))
				)
				(T 
					(setq Ename nil)
				)
			)
			(setq Ename nil)
		)	
		;(if Line1
		;	(if (= (vl-string-trim " " Line1) "0")
		;		(setq Ename (strcase (vl-string-trim " " Line2)))
		;		(setq Ename nil)
		;	)
		;	(setq Ename nil)
		;)
		
		(if (ValidateEntity "ELLIPSE" LstRecord)
			(if (setq Rtn (entmakex LstRecord))
				Rtn
				-1 ; errore creazione dell'entità
			)
			-2 ; dati insufficienti
		)
	)
	;
	(defun MakeSpline (/ LstRecord Line1 Line2
						 Flags Degree KnotCount ControlCount FitCount Spatial
						 Knot Vx Vy Vz
						 FitX FitY FitZ)


		;
		; Main ++++++
		;
		(setq LstRecord (append LstRecord (list (cons 0 "SPLINE"))))
		(setq LstRecord (append LstRecord (list (cons 8 "0"))))
		(setq LstRecord (append LstRecord (list (cons 100 "AcDbEntity"))))
		(setq LstRecord (append LstRecord (list (cons 100 "AcDbSpline"))))

		(while
			(and (setq Line1 (read-line StremRead)) (setq Line2 (read-line StremRead))
				(/= (vl-string-trim " " Line1) "0")	(/= (vl-string-trim " " Line1) "1001")
			)
			(cond
				;; ====================================================
				;; Flags
				;; ====================================================
				((= (vl-string-trim " " Line1) "70")
					(setq Flags (atoi Line2))
					(setq LstRecord	(append	LstRecord (list (cons 70 Flags))))
				)
				;; ====================================================
				;; Degree
				;; ====================================================
				((= (vl-string-trim " " Line1) "71")
					(setq Degree (atoi Line2))
					(setq LstRecord	(append	LstRecord (list (cons 71 Degree))))
				)

				;; ====================================================
				;; Number of knots
				;; ====================================================
				((= (vl-string-trim " " Line1) "72")
					(setq KnotCount (atoi Line2))
					(setq LstRecord	(append	LstRecord (list (cons 72 KnotCount))))
				)
				;; ====================================================
				;; Number of control points
				;; ====================================================
				((= (vl-string-trim " " Line1) "73")
					(setq ControlCount (atoi Line2))
					(setq LstRecord	(append	LstRecord (list (cons 73 ControlCount))))
				)
				;; ====================================================
				;; Number of fit points
				;; ====================================================
				((= (vl-string-trim " " Line1) "74")
					(setq FitCount (atoi Line2))
					(setq LstRecord	(append	LstRecord (list (cons 74 FitCount))))
				)
				;; ====================================================
				;; Knot
				;; ====================================================
				((= (vl-string-trim " " Line1) "40")
					(setq Knot (atof Line2))
					(setq LstRecord	(append	LstRecord (list (cons 40 Knot))))
				)
				;; ====================================================
				;; Weight
				;; ====================================================
				((= (vl-string-trim " " Line1) "41")
					(setq Knot (atof Line2))
					(setq LstRecord	(append LstRecord (list (cons 41 Knot))))
				)
				;; ====================================================
				;; Control point X
				;; ====================================================
				((= (vl-string-trim " " Line1) "10")
					(setq Vx (atof Line2))
				)
				;; ====================================================
				;; Control point Y
				;; ====================================================
				((= (vl-string-trim " " Line1) "20")
					(setq Vy (atof Line2))
				)
				;; ====================================================
				;; Control point Z
				;; ====================================================
				((= (vl-string-trim " " Line1) "30")
					(setq Vz (atof Line2))
					(if (> (abs Vz) 1e-8)
						(setq Spatial T)
					)
					(setq LstRecord	(append	LstRecord (list (cons 10 (list Vx Vy Vz)))))
				)
				;; ====================================================
				;; Fit point X
				;; ====================================================
				((= (vl-string-trim " " Line1) "11")
					(setq FitX (atof Line2))
				)
				;; ====================================================
				;; Fit point Y
				;; ====================================================
				((= (vl-string-trim " " Line1) "21")
					(setq FitY (atof Line2))
				)
				;; ====================================================
				;; Fit point Z
				;; ====================================================
				((= (vl-string-trim " " Line1) "31")
					(setq FitZ (atof Line2))
					(setq LstRecord	(append	LstRecord (list (cons 11 (list FitX FitY FitZ)))))
				)
			)
		)
		;; ============================================================
		;; Se abbiamo incontrato il codice 0,
		;; Line2 contiene già il nome della prossima entità, se 1001 prossimo step
		;; ============================================================
		(if Line1
			(cond
				((= (vl-string-trim " " Line1) "0")
					(setq Ename (strcase (vl-string-trim " " Line2)))
				)
				((= (vl-string-trim " " Line1) "1001")
					(setq Ename (NextStep))
				)
				(T 
					(setq Ename nil)
				)
			)
			(setq Ename nil)
		)	
		;(if Line1
		;	(if (= (vl-string-trim " " Line1) "0")
		;		(setq Ename (strcase (vl-string-trim " " Line2)))
		;		(setq Ename nil)
		;	)
		;	(setq Ename nil)
		;)
		;; ============================================================
		;; Validazione e creazione
		;; ============================================================
		(if Spatial
			-3 ; SPLINE spaziale
			(if (ValidateEntity "SPLINE" LstRecord)
				(if (setq Rtn (entmakex LstRecord))
					Rtn
					-1 ; errore creazione dell'entità
				)
				-2 ; dati insufficienti
			)
		)
	)	
	;
	(defun NextStep (/ Line1 Line2)
		(while
			(and
				(setq Line1 (read-line StremRead))
				(setq Line2 (read-line StremRead))
				(/= (vl-string-trim " " Line1) "0")
			)
		)
		(if (and Line1 Line2)
			(strcase (vl-string-trim " " Line2))
			nil
		)
	)
	;
	(defun ValidateOutput (OutputMake / EntityName)
		(cond 
			((= (type OutputMake) 'ENAME)
				(cond
					((= (strcase (cdr (assoc 0 (entget OutputMake)))) "LINE")
						(setq NLine (1+ NLine))
						(setq LstEname (append LstEname (list OutputMake)))
					)
					((= (strcase (cdr (assoc 0 (entget OutputMake)))) "ARC")
						(setq NArc (1+ NArc))
						(setq LstEname (append LstEname (list OutputMake)))
					)
					((= (strcase (cdr (assoc 0 (entget OutputMake)))) "CIRCLE")
						(setq NCircle (1+ NCircle))
						(setq LstEname (append LstEname (list OutputMake)))
					)
					((= (strcase (cdr (assoc 0 (entget OutputMake)))) "LWPOLYLINE")
						(setq NPoly (1+ NPoly))
						(setq LstEname (append LstEname (list OutputMake)))
					)
					((= (strcase (cdr (assoc 0 (entget OutputMake)))) "ELLIPSE")
						(setq NElli (1+ NElli))
						(setq LstEname (append LstEname (list OutputMake)))
					)
					((= (strcase (cdr (assoc 0 (entget OutputMake)))) "SPLINE")
						(setq NSpline (1+ NSpline))
						(if ECSpline2Polyline$
							(if (setq OutputMake (Spline2LwPolyline OutputMake ECSpline2PolylineToll$ T))
								(setq LstEname (append LstEname (list OutputMake)))
							)
						)
					)
				)
			)
			(if (= (type OutputMake) 'STR)
				(if (not (member OutputMake LstUnmanagedEname))
					(setq LstUnmanagedEname (append LstUnmanagedEname (list OutputMake)))
				)
			)
			((= Rtn -1)
				(setq Nerr1 (1+ Nerr1))
			)
			((= Rtn -2)
				(setq Nerr2 (1+ Nerr2))
			)
			((= Rtn -3)
				(setq Nerr3 (1+ Nerr3))
			)
		)
	)
	;
	(defun ValidateEntity (EntityType LstRecord / P10 P11 P40 P41 P42 P50 P51)
		(cond
			;; ============================================================
			;; LINE
			;; ============================================================
			((= EntityType "LINE")
				(setq P10 (cdr (assoc 10 LstRecord)))
				(setq P11 (cdr (assoc 11 LstRecord)))
				(and (listp P10) (= (length P10) 3)
					 (listp P11) (= (length P11) 3)
				)
			)
			;; ============================================================
			;; ARC
			;; ============================================================
			((= EntityType "ARC")
				(setq P10 (cdr (assoc 10 LstRecord)))
				(setq P40 (cdr (assoc 40 LstRecord)))
				(setq P50 (cdr (assoc 50 LstRecord)))
				(setq P51 (cdr (assoc 51 LstRecord)))
				(and (listp P10)  (= (length P10) 3)
					 (numberp P40)(> P40 0.0)
					 (numberp P50)
					 (numberp P51)
				)
			)

			;; ============================================================
			;; CIRCLE
			;; ============================================================
			((= EntityType "CIRCLE")
				(setq P10 (cdr (assoc 10 LstRecord)))
				(setq P40 (cdr (assoc 40 LstRecord)))

				(and (listp P10)  (= (length P10) 3)
					(numberp P40) (> P40 0.0)
				)
			)

			;; ============================================================
			;; ELLIPSE
			;; ============================================================
			((= EntityType "ELLIPSE")
				(setq P10 (cdr (assoc 10 LstRecord)))
				(setq P11 (cdr (assoc 11 LstRecord)))
				(setq P40 (cdr (assoc 40 LstRecord)))
				(setq P41 (cdr (assoc 41 LstRecord)))
				(setq P42 (cdr (assoc 42 LstRecord)))

				(and (listp P10)  (= (length P10) 3)
					 (listp P11)  (= (length P11) 3)
					 (numberp P40) (> P40 0.0)
					 (numberp P41) (>= P41 0.0)
					 (numberp P42) (>= P42 P41)
				)
			)
			;; ============================================================
			;; Entità non gestita dalla validazione
			;; ============================================================
			(T T)
		)
	)
	;
	(defun StdOutput (ImportFileDxf Stream / FileName Stream)
		
		(if (not Stream)
			(progn
				(princ "\nImportFileDxf ") (princ ImportFileDxf)
				(princ "\nNLine         ") (princ (LM:rtos NLine   2 0  ))
				(princ "\nNArc          ") (princ (LM:rtos NArc    2 0  ))
				(princ "\nNCircle       ") (princ (LM:rtos NCircle 2 0  ))
				(princ "\nNPoly         ") (princ (LM:rtos NPoly   2 0  ))
				(princ "\nNElli         ") (princ (LM:rtos NElli   2 0  ))
				(princ "\nNSpline       ") (princ (LM:rtos NSpline 2 0  ))
				(if ECSpline2Polyline$
					(if (> NSpline 0) (princ (strcat "[DxfToEntmake] n. spline -> polyline        " (LM:rtos NSpline 2 0))))
					(if (> NSpline 0) (princ (strcat "[DxfToEntmake] n. spline                    " (LM:rtos NSpline 2 0))))
				)
				(princ "\nLstUnmanagedEname ") (princ LstUnmanagedEname)
				(foreach itm LstUnmanagedEname
					(princ "\nUnmanagedEname ") (princ itm)
				)
				(princ "\nNErr1         ") (princ (LM:rtos NErr1   2 0  ))
				(princ "\nNErr2         ") (princ (LM:rtos NErr2   2 0  ))
				(princ "\nNErr3         ") (princ (LM:rtos NErr2   2 0  ))
			)
		)
		
		
		(if (and ImportFileDxf Stream)
			(progn

				(write-line "[DxfToEntmake] +----------------------------------------------------------------------------+" Stream)
				(write-line "[DxfToEntmake] Riepilogo import Dxf" 															Stream)
				(write-line (strcat "[DxfToEntmake] File importato " ImportFileDxf) 										Stream)
				(write-line "[DxfToEntmake] Entita' importate" 																Stream)
				
				(if (> NLine   0) (write-line (strcat "[DxfToEntmake] n. line                      " (LM:rtos NLine 2 0  ))	Stream))
				(if (> NArc    0) (write-line (strcat "[DxfToEntmake] n. archi                     " (LM:rtos NArc 2 0   ))	Stream))
				(if (> NCircle 0) (write-line (strcat "[DxfToEntmake] n. cerchi                    " (LM:rtos NCircle 2 0))	Stream))
				(if (> NPoly   0) (write-line (strcat "[DxfToEntmake] n. polyline                  " (LM:rtos NPoly 2 0  ))	Stream))
				(if (> NElli   0) (write-line (strcat "[DxfToEntmake] n. ellissi                   " (LM:rtos NElli 2 0  ))	Stream))
				(if ECSpline2Polyline$
					(if (> NSpline 0) (write-line (strcat "[DxfToEntmake] n. spline -> polyline        " (LM:rtos NSpline 2 0))	Stream))
					(if (> NSpline 0) (write-line (strcat "[DxfToEntmake] n. spline                    " (LM:rtos NSpline 2 0))	Stream))
				)
				(foreach itm LstUnmanagedEname
					(write-line (strcat "[DxfToEntmake] entita' non gestita " itm)	Stream)
				)
				(if (> Nerr1   0) (write-line (strcat "[DxfToEntmake] n. errori creazione entita'  " (LM:rtos Nerr1 2 0)	Stream)))
				(if (> Nerr2   0) (write-line (strcat "[DxfToEntmake] n. errori dati insufficienti " (LM:rtos Nerr1 2 0)	Stream)))
				(if (> Nerr3   0) (write-line (strcat "[DxfToEntmake] n. errori Spline spaziale    " (LM:rtos Nerr1 2 0)	Stream)))
				(write-line "[DxfToEntmake] +----------------------------------------------------------------------------+" Stream)
			)
		)
	)
	;
	; Main ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(setq StremRead (open FileName "r"))
	(setq FoundEntities nil)
	
	(while (and	(not FoundEntities)	(setq LineRead (read-line StremRead)))
		(if (= (strcase (vl-string-trim " " LineRead)) "ENTITIES")
			(setq FoundEntities T)
		)
	)
	(if FoundEntities
		(progn
			(setq Line  (read-line StremRead)) ; 0
			(setq Ename (strcase (vl-string-trim " " (read-line StremRead))))
			(setq Loop T)

			(setq LstEname 			nil)
			(setq LstUnmanagedEname nil)
			(setq NLine    0)
			(setq NArc     0)
			(setq NCircle  0)
			(setq NPoly    0)
			(setq NSpline  0)
			(setq NElli    0)
			(setq Nerr1    0)
			(setq Nerr2    0)
			(setq Nerr3    0)

			(while Loop
				;(princ (strcat "\n" Ename))
				(cond
					((= Ename "LINE")
						(setq Rtn (MakeLine))
						(ValidateOutput Rtn)
					)
					((= Ename "ARC")
						(setq Rtn (MakeArc))
						(ValidateOutput Rtn)
					)
					((= Ename "CIRCLE")
						(setq Rtn (MakeCircle))
						(ValidateOutput Rtn)
					)
					((= Ename "ELLIPSE")
						(setq Rtn (MakeEllipse))
						(ValidateOutput Rtn)
					)
					((= Ename "LWPOLYLINE")
						(setq Rtn (MakeLwPolyline))
						(ValidateOutput Rtn)
					)
					((= Ename "POLYLINE")
						(setq Rtn (MakePolyline))
						(ValidateOutput Rtn)
					)
					((= Ename "SPLINE")
						(setq Rtn (MakeSpline))
						(ValidateOutput Rtn)
					)
					((= Ename "ENDSEC")
						(setq Loop nil)
					)
					(T
						;; entità non gestita
						;(princ (strcat "\nEname " Ename " esclusa dall'import"))
						(ValidateOutput Ename)
						(setq Ename (NextStep))
						(if (null Ename) (setq Loop nil))
					)
				)
				;; EOF / nessuna prossima entità
				(if (null Ename)
					(setq Loop nil)
				)				
			)
		)
	)
	(close StremRead)
	
	(if (and PtInsert LstEname)
		(progn
			(setq MaxMinCatch (LM:SSBoundingBox (LstEname->Ssget LstEname)))
			(foreach itm (LstEname->LstObj LstEname)
				(vla-move itm (vlax-3d-point (nth 0 MaxMinCatch)) (vlax-3d-point PtInsert))		
			)
		)
	)
	(StdOutput FileName Stream)
	LstEname
)
;



