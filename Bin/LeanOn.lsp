;
;
(defun LeanOn ( EnameShape PtRotate / *error* ReplicateItmList
									  ActOsmode DataRotate Shape loop Ntab msgLst
									  gr code data Rtn)

	;
	;
	;
	(defun *error* (msg)
		(setvar "osmode" ActOsmode)
    )
	;
	;
	(defun ReplicateItmList (Lst n / Rtn)
		(repeat n
			(setq Rtn (append Rtn Lst))
		)
	)
	;
	; Main +++++
	; 
	(setq ActOsmode  (getvar "OSMODE"))
	
	(if (and EnameShape PtRotate)
		(setq DataRotate (CalcLeanOn EnameShape PtRotate))
	)
	
	(if DataRotate
		(progn
			(princ "\n-----[") (princ DataRotate) (princ "]-----\n")
			(setq Shape 	 (DiscretizeShapeNoControl EnameShape))			
			(setq DataRotate (ReplicateItmList DataRotate 30))
			
			(setq loop T)
			(setq Ntab 0)
			(setq msgLst (strcat "\r[R]uota | [Enter] | [E]xit"))
			(princ msgLst)
			(while loop

				(setq gr (grread 't 15 1) code (car gr) data (cadr gr))

				(cond
					((and (= code 5) (listp data))           								; Mouse rolling  
						(GraphicsRotation Shape PtRotate (nth Ntab DataRotate) $ColorSymula)
					)
					((or (= data 82) (= data 114)) 											; rotazione (tasto r/R)
						(setq Ntab (1+ Ntab)) 
						(redraw)
						(GraphicsRotation Shape PtRotate (nth Ntab DataRotate) $ColorSymula)
					)
					((= data 13) 															; enter
						(redraw)
						(setq Rtn (car (Move+Rotate+MirrorShape EnameShape (list PtRotate PtRotate (nth Ntab DataRotate) nil))))
						(setq loop nil)
					)
				)
			)
		)
		(setq Rtn EnameShape)
	)
	Rtn
)
;
;(FindRotationShape (car (entsel "\nContorno da ruotare")) (car (entsel "\nOstacolo")) (getpoint "\nPunto di rotazione") T)
;
(defun FindRotationShape (EnameShape EnameCheck PtRotate Verbose / Rtn)
	
	(if (and EnameShape EnameCheck PtRotate)
		(cond
			((CheckIfEasyCutShape EnameCheck)
				(FindRotationShapeToShape EnameShape EnameCheck PtRotate Verbose)
			)
			((CheckIfEasyCutSheet EnameCheck)
				(FindRotationShapeToSheet EnameShape EnameCheck PtRotate Verbose)
			)
			(t
				nil
			)
		)
	)
)
;
;(FindRotationShapeToShape (car (entsel "\nContorno da ruotare")) (car (entsel "\nOstacolo")) (getpoint "\nPunto di rotazione") T)
;
(defun FindRotationShapeToSheet (EnameShape EnameCheck PtRotate Verbose / CheckRotatePoint
																		  PosPointRotate LstLineShape LstLineCheck itm1 itm2 
																		  LstCheckAngle Rtn)

	(defun CheckRotatePoint (PtCheck EnameCheck / Rtn)

		(if (and PtCheck EnameCheck)
			; Rtn 1 in Shape
			; Rtn 2 Into Shape
			; Rtn 3 out Shape
			(cond 
				((equal (vlax-curve-getclosestpointto (vlax-ename->vla-object EnameCheck) PtCheck) PtCheck 1e-8)
					(setq Rtn 1)
				)
				((LM:PointInside-p PtCheck (vlax-ename->vla-object EnameCheck) nil)
					(setq Rtn 2)
				)
				(T
					(setq Rtn 3)
				)
			)
		)
		Rtn
	)
	;
	; Main ++++
	;
	(if (and EnameShape EnameCheck PtRotate)
		(progn
			;(setq PosPointRotate (CheckRotatePoint PtRotate EnameCheck))
			;
			;(cond 
			;	((or (= PosPointRotate 1) (= PosPointRotate 2))
					(setq LstLineShape (mapcar 'vlax-vla-object->ename (LwPolyToSegment EnameShape nil))) 
					(setq LstLineCheck (mapcar 'vlax-vla-object->ename (LwPolyToSegment EnameCheck nil)))
					
						(foreach itm1 LstLineShape
							(foreach itm2 LstLineCheck
								(setq LstCheckAngle (append LstCheckAngle (GetPointRotate itm1 itm2 PtRotate nil)))
							)
						)
						
					(DeleteEntity LstLineShape)
					(DeleteEntity LstLineCheck)
					
					(setq Rtn (PurgeRotation EnameShape EnameCheck PtRotate (LM:UniqueFuzz LstCheckAngle (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0))))
			;	)
			;	((= PosPointRotate 2)
			;		(setq Rtn nil)
			;	)
			;)
		)
	)

	(if Verbose 
		(foreach itm1 Rtn
			(setq ObjCopy (vla-copy (vlax-ename->vla-object EnameShape)))
			(vla-rotate ObjCopy (vlax-3d-point PtRotate) itm1)
			(getstring "<>")
			(DeleteEntity (list (vlax-vla-object->ename ObjCopy)))
		)
	)
	Rtn

)	
;
;
;
(defun FindRotationShapeToShape (EnameShape EnameCheck PtRotate Verbose / CheckRotatePoint
																		  PosPointRotate LstLineShape LstLineCheck itm1 itm2 
																		  LstCheckAngle Rtn)
	;
	(defun CheckRotatePoint (PtCheck EnameCheck / Rtn)

		(if (and PtCheck EnameCheck)
			; Rtn 1 in Shape
			; Rtn 2 Into Shape
			; Rtn 3 out Shape
			(cond 
				((equal (vlax-curve-getclosestpointto (vlax-ename->vla-object EnameCheck) PtCheck) PtCheck 1e-8)
					(setq Rtn 1)
				)
				((LM:PointInside-p PtCheck (vlax-ename->vla-object EnameCheck) nil)
					(setq Rtn 2)
				)
				(T
					(setq Rtn 3)
				)
			)
		)
		Rtn
	)
	;
	; Main ++++
	;
	(if (and EnameShape EnameCheck PtRotate)
		(progn
			;(setq PosPointRotate (CheckRotatePoint PtRotate EnameCheck))
			;
			;(cond 
			;	((or  (= PosPointRotate 1) (= PosPointRotate 3))
					(setq LstLineShape (mapcar 'vlax-vla-object->ename (LwPolyToSegment EnameShape nil))) 
					(setq LstLineCheck (mapcar 'vlax-vla-object->ename (LwPolyToSegment EnameCheck nil)))
					
						(foreach itm1 LstLineShape
							(foreach itm2 LstLineCheck
								;(setq LstCheckAngle (append LstCheckAngle (FindRotation itm1 itm2 PtRotate nil)))
								(setq LstCheckAngle (append LstCheckAngle (GetPointRotate itm1 itm2 PtRotate nil)))
							)
						)
						
					(DeleteEntity LstLineShape)
					(DeleteEntity LstLineCheck)
					
					(setq Rtn (PurgeRotation EnameShape EnameCheck PtRotate (LM:UniqueFuzz LstCheckAngle (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0))))
			;	)
			;	((= PosPointRotate 2)
			;		(setq Rtn nil)
			;	)
			;)
		)
	)

	(if Verbose 
		(foreach itm1 Rtn
			(setq ObjCopy (vla-copy (vlax-ename->vla-object EnameShape)))
			(vla-rotate ObjCopy (vlax-3d-point PtRotate) itm1)
		
			(getstring "<>")
			(DeleteEntity (list (vlax-vla-object->ename ObjCopy)))
		)
	)

	Rtn
)
;
;
;
(defun PurgeRotation (EnameShape EnameCheck PtRotate LstCheckAngle / PurgeRotationShapeToShape PurgeRotationShapeToSheet AccuracyArea)
	
	;
	(defun PurgeRotationShapeToShape (EnameShape EnameCheck PtRotate LstCheckAngle AccuracyArea / AccuracyIntersection PtInt
																								  CheckArea itm ObjCopy EnameRegion1 EnameRegion2 Rtn)
	
		(if (and EnameShape EnameCheck PtRotate LstCheckAngle)
			(progn
			
				(if (= (GetTypShape EnameCheck) "CE")
					(setq CheckArea (+ (vla-get-area (vlax-ename->vla-object EnameShape)) 
									   (vla-get-area (vlax-ename->vla-object EnameCheck))))
					(setq CheckArea (- (vla-get-area (vlax-ename->vla-object EnameCheck))
									   (vla-get-area (vlax-ename->vla-object EnameShape))))
				)
					
				(foreach itm LstCheckAngle
					(setq ObjCopy (vla-copy (vlax-ename->vla-object EnameShape)))
					(vla-rotate ObjCopy (vlax-3d-point PtRotate) itm)
					
					;(getstring "<>")
					
					(setq EnameRegion1 (AddRegion EnameCheck))
					(setq EnameRegion2 (AddRegion (vlax-vla-object->ename ObjCopy)))
					;(setq EnameRegion2 (AddRegion EnameCheck))

					(if (= (GetTypShape EnameCheck) "CE")
						(vla-boolean (vlax-ename->vla-object EnameRegion1) 0 (vlax-ename->vla-object EnameRegion2))
						(vla-boolean (vlax-ename->vla-object EnameRegion1) 2 (vlax-ename->vla-object EnameRegion2))
					)
					;(trace equal)
					(if (equal CheckArea (vla-get-area (vlax-ename->vla-object EnameRegion1)) AccuracyArea)
						(setq Rtn (append Rtn (list itm)))
					)
					;(untrace equal)
					;(getstring "><")
					
					
					(DeleteEntity (list (vlax-vla-object->ename ObjCopy)))
					(DeleteEntity (list EnameRegion1))
				)
			)
		)
		Rtn
	)
	;
	(defun PurgeRotationShapeToSheet (EnameShape EnameCheck PtRotate LstCheckAngle AccuracyArea / CheckArea itm ObjCopy EnameRegion1 EnameRegion2 Rtn)
	
		(if (and EnameShape EnameCheck PtRotate LstCheckAngle)
			(progn
				(setq CheckArea (- (vla-get-area (vlax-ename->vla-object EnameCheck))
								   (vla-get-area (vlax-ename->vla-object EnameShape))))
					
				(foreach itm LstCheckAngle
					(setq ObjCopy (vla-copy (vlax-ename->vla-object EnameShape)))
					(vla-rotate ObjCopy (vlax-3d-point PtRotate) itm)
					
					(setq EnameRegion1 (AddRegion EnameCheck))
					(setq EnameRegion2 (AddRegion (vlax-vla-object->ename ObjCopy)))
					
					(vla-boolean (vlax-ename->vla-object EnameRegion1) 2 (vlax-ename->vla-object EnameRegion2))

					(if (equal CheckArea (vla-get-area (vlax-ename->vla-object EnameRegion1)) AccuracyArea)
						(setq Rtn (append Rtn (list itm)))
					)
						
					(DeleteEntity (list (vlax-vla-object->ename ObjCopy)))
					(DeleteEntity (list EnameRegion1))
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq AccuracyArea 0.5)
	(if (and EnameShape EnameCheck PtRotate LstCheckAngle)
		(cond
			((CheckIfEasyCutShape EnameCheck)
				(PurgeRotationShapeToShape EnameShape EnameCheck PtRotate LstCheckAngle AccuracyArea)
			)
			((CheckIfEasyCutSheet EnameCheck)
				(PurgeRotationShapeToSheet EnameShape EnameCheck PtRotate LstCheckAngle AccuracyArea)
			)
			(t
				nil
			)
		)
	)
)
;
;(CalcLeanOn (car (entsel "\nContorno da ruotare")) (getpoint "\nPunto di rotazione"))
;
(defun CalcLeanOn (EnameShape PtRotate / LstEnameCatch LstCheckAngle itm itm1 LstEnameCopy Flag LstTmp Rtn)

	;
	(defun ChangeGeometryShape (LstEnameShape / itm re-draw nohide Rtn)
	
		(defun re-draw (lst)
			(mapcar (function (lambda (x) (vla-put-visible (vlax-ename->vla-object x) :vlax-true))) lst)
		)
		(defun nohide (/ itm)
			(foreach itm (LM:ss->ent (ssget "X"))
				(vla-put-visible (vlax-ename->vla-object itm) :vlax-true)
				(princ "\n") (princ (vla-get-visible (vlax-ename->vla-object itm))) (princ (assoc 0 (entget itm)))
			)
		)
		;
		(foreach itm LstEnameShape
			(cond
				((CheckIfEasyCutShape itm)
					(cond
						((= (GetTypShape itm) "CE")
							;(setq Rtn (append Rtn (CloneShape (list (CloneEname itm (OffsetShape02 itm $MargineAccosto) "----")))))
							(setq Rtn (append Rtn (CloneShape (list (CloneEname itm (GeneralOffset itm $MargineAccosto) "----")))))
						)
						((= (GetTypShape itm) "CI")
							;(setq Rtn (append Rtn (CloneShape (list (CloneEname itm (OffsetShape02 itm (- 0.0 $MargineAccosto)) "----")))))
							(setq Rtn (append Rtn (CloneShape (list (CloneEname itm (GeneralOffset itm (- 0.0 $MargineAccosto)) "----")))))
						)
					)
				)
				((CheckIfEasyCutSheet itm)
					;(setq Rtn (append Rtn (list (CloneSheet itm (OffsetShape02 itm (- 0.0 $MargineAccosto))))))
					(setq Rtn (append Rtn (list (CloneSheet itm (GeneralOffset itm (- 0.0 $MargineAccosto))))))
				)
			)
		)
		(re-draw Rtn)
		Rtn
	)
	;
	; Main +++++
	;
	(if (and EnameShape PtRotate)
		(progn
			(setq LstEnameCatch (CatchEnameShape EnameShape PtRotate nil))
			(setq LstEnameCatch (ChangeGeometryShape LstEnameCatch))

			(StartProgressBar "Controllo segmenti :" (length LstEnameCatch))
			(foreach itm LstEnameCatch
				(setq LstCheckAngle (append LstCheckAngle (FindRotationShape EnameShape itm PtRotate nil)))
				(UpDateProgressBar)
			)
			(ClearProgressBar)
			(setq LstCheckAngle (LM:UniqueFuzz LstCheckAngle (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0)))
			
			(foreach itm (LM:UniqueFuzz LstCheckAngle (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0))
				(setq Flag T)
				(foreach itm1 LstEnameCatch
					(if (null (PurgeRotation EnameShape itm1 PtRotate (list itm)))
						(setq Flag nil)
					)
				)
				(if Flag (setq Rtn (append Rtn (list itm))))
			)
			
			(mapcar 'entdel LstEnameCatch)
			(if Rtn (setq Rtn (vl-sort (LM:UniqueFuzz Rtn (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0)) '<)))
		)
	)
	Rtn
)
;
;
;
(defun GraphicsRotation (LstPoint PtRotate Rotation ColorRotation / Dca RotatePoint LstRotate CrossRotationDim)


	(defun Dca (x1 y1 x2 y2 ang / alfa_x alfa dist d_x d_y Rtn)
	
		(setq alfa_x (ang_x x1 y1 x2 y2)
			  alfa (+ alfa_x ang)
			  dist (sqrt (+ (* (- x2 x1) (- x2 x1))
                            (* (- y2 y1) (- y2 y1))
                         )
                   )
              d_x (+ x1 (* dist (cos alfa)))
              d_y (+ y1 (* dist (sin alfa)))
       )
       (setq Rtn (list d_x d_y))
	)
	;
	;
	;
	(defun RotatePoint (LstPoint PtRotate Ang / itm Rtn)
		
		(if (and LstPoint PtRotate Ang)
			(foreach itm LstPoint
				
				(setq Rtn (append Rtn (list (Dca (nth 0 PtRotate) (nth 1 PtRotate) (nth 0 itm) (nth 1 itm) Ang))))
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq CrossRotationDim 50.0)
	(if (and LstPoint PtRotate Rotation ColorRotation)
		(progn
			(setq LstRotate (RotatePoint LstPoint PtRotate Rotation))
			(DrawLowGraphics (append LstRotate (list (nth 0 LstRotate))) ColorRotation)
			; Cross Rotation +++
			(grdraw (list (- (car PtRotate) (/ CrossRotationDim 2.0)) (cadr PtRotate))
					(list (+ (car PtRotate) (/ CrossRotationDim 2.0)) (cadr PtRotate)) ColorRotation 1)
			(grdraw (list (car PtRotate) (- (cadr PtRotate) (/ CrossRotationDim 2.0)))
					(list (car PtRotate) (+ (cadr PtRotate) (/ CrossRotationDim 2.0)))  ColorRotation 1)
		)
	)
)
;
;
;
(defun DrawLowGraphics (LstPt Color / conta ps pe)

	(setq conta 0)
	(if (and LstPt Color)
		(repeat (- (length LstPt) 1)
			(setq ps (nth conta LstPt)  pe (nth (1+ conta) LstPt) conta (1+ conta))
			(grdraw ps pe Color 1)
		)
	)
)
;
;(CatchEnameShape (car (entsel "\Contorno da ruotare")) (getpoint "\nPunto di rotazione") T)
;
(defun CatchEnameShape (EnameShape PtRotate Verbose / SelectEnameChatch
													  LstEnameSelect itm
													  LstInternalShape LstExternalShape EnameInternalShape EnameSheet Rtn)

	;
	(defun SelectEnameChatch (EnameShape PtRotate Verbose / itm LstDistance MaxRadius MinRadius 
															ModelSpace Circle1 Circle2 CoExt CoInt ChechZoom Ssel LstEnameShape Rtn)
	
		(if (and EnameShape PtRotate)
			(progn
				
				(foreach itm (get_vertices_dummy02 EnameShape 10.0)
					(setq LstDistance (append LstDistance (list (distance PtRotate itm))))
				)
				(setq MaxRadius  (apply 'max LstDistance))
				(setq MinRadius  (apply 'min LstDistance))
				(setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
				(setq Circle1    (vlax-vla-object->ename (vla-addcircle ModelSpace (vlax-3d-point PtRotate) (+ MaxRadius (* $MargineAccosto 2.0)))))
				(setq CoExt      (DiscretizeCircle Circle1))
			
				(if (> MinRadius 1.0)
					(progn
						(setq Circle2  (vlax-vla-object->ename (vla-addcircle ModelSpace (vlax-3d-point PtRotate) MinRadius)))
						(setq CoInt    (DiscretizeCircle Circle2))
					)
				)

				(setq ChechZoom (VisibleEname Circle1))
		
				(if Verbose (getstring "<>"))
					(DeleteEntity (list Circle1))
					(if Circle2 (DeleteEntity (list Circle2)))
		
			
				(setq Ssel (ssget "_CP" CoExt $FilterList))
			
				(if Verbose 
					(progn
						(princ (strcat "\nNumero entita selezionata " (rtos (sslength ssel) 2 0)))
						(foreach itm (LM:ss->ent Ssel)
							(princ "\n") (princ (assoc 0 (entget itm)))
						)
					)
				)
			
				(if (and (null (LM:PointInside-p PtRotate (vlax-ename->vla-object EnameShape) T)) CoInt)
					(foreach itm (LM:ss->ent (ssget "_WP" CoInt $FilterList))
						(ssdel itm Ssel)
					)
				)
				
				(setq LstEnameShape (LM:ss->ent (SelectShape EnameShape)))
				(foreach itm (LM:ss->ent Ssel)
					(if (not (member itm LstEnameShape))
						(setq Rtn (append Rtn (list itm)))
					)
				)
			)
		)
		Rtn
	)
	;
	; Main ++++
	;
	(if (and EnameShape PtRotate)
		(progn
			(setq LstEnameSelect (SelectEnameChatch EnameShape PtRotate Verbose))
			(foreach itm LstEnameSelect
				(cond
					((= (GetTypShape itm) "CE")
					(setq LstExternalShape (append LstExternalShape (list itm)))
					)
					((= (GetTypShape itm) "CI")
						(if (>=  (vla-get-area (vlax-ename->vla-object itm))
								 (vla-get-area (vlax-ename->vla-object EnameShape))
							)
							(if (PoligonInsidePoligon itm EnameShape) (setq EnameInternalShape itm))
						)
					)
					((CheckIfEasyCutSheet itm)
						(setq EnameSheet itm)
					)
				)
			)
			;
			; Check if EnameShape is inside an InternalShape ++++++++++++++
			;
			;(princ "\nEnameInternalShape ") (princ EnameInternalShape)
			;(princ "\nEnameSheet         ") (princ EnameSheet)
			
			(cond
				((not (null EnameInternalShape))
					(foreach itm LstExternalShape
						(if (PoligonInsidePoligon EnameInternalShape itm)
							(setq Rtn (append Rtn (list itm)))
						)
					)
					;(princ "\n**") (princ Rtn)	(princ "**\n")
					(setq Rtn (append Rtn (list EnameInternalShape)))
				)
				((not (null EnameSheet))
					(foreach itm LstExternalShape
						(if (PoligonInsidePoligon EnameSheet itm)
							(setq Rtn (append Rtn (list itm)))
						)
					)
					;(princ "\n***") (princ Rtn)	(princ "***\n")
					(setq Rtn (append Rtn (list EnameSheet)))
				)
				(t 
					(setq Rtn LstExternalShape)
					;(princ "\n****") (princ Rtn)	(princ "****\n")
				)
			)

			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			
			(if Verbose
				(foreach itm Rtn
					(vla-highlight (vlax-ename->vla-object itm) :vlax-true)
				)
			)
			(ZoomPrevius ChechZoom)
		)
	)
	Rtn
)
;
;
;
(defun PointOfConctat (EnameShape EnameCheck / i_pts conta Rtn)
	
	(if (and EnameShape EnameCheck)
		(progn
			(setq i_pts  (vlax-variant-value (vla-IntersectWith (vlax-ename->vla-object EnameShape)
																(vlax-ename->vla-object EnameCheck)
																acExtendNone)))
			(setq conta 0)
			(if (> (vlax-safearray-get-u-bound i_pts 1) 0)
				(repeat (/ (length (vlax-safearray->list i_pts)) 3)
						(setq Rtn (append Rtn (list (list (nth (+ 0 conta) (vlax-safearray->list i_pts))
														  (nth (+ 1 conta) (vlax-safearray->list i_pts))
													      (nth (+ 2 conta) (vlax-safearray->list i_pts))
													)
											  )
								  )
						)
						(setq conta (+ 3 conta))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun CheckIntersectionsListEntity (LstEnt / CheckOverlap
                                              i j entA entB objA objB intPt RtnLstEnt)

	(defun CheckOverlap (objA objB / minA maxA minB maxB)
		(vla-GetBoundingBox objA 'minA 'maxA)
		(vla-GetBoundingBox objB 'minB 'maxB)
		(and
			(equal (vlax-safearray-get-element minA 0) (vlax-safearray-get-element minB 0) 1e-4)
			(equal (vlax-safearray-get-element maxA 0) (vlax-safearray-get-element maxB 0) 1e-4)
			(equal (vlax-safearray-get-element minA 1) (vlax-safearray-get-element minB 1) 1e-4)
			(equal (vlax-safearray-get-element maxA 1) (vlax-safearray-get-element maxB 1) 1e-4)
		)
	)
  
	(setq i 0)
	;; Ciclo principale: scorre la lista fino al penultimo elemento
	(while (< i (1- (length LstEnt)))
		(setq entA (nth i LstEnt))
		(setq objA (vlax-ename->vla-object entA))
    
		(setq j (1+ i))
		;; Ciclo secondario: confronta l'oggetto A con tutti i successivi
		(while (< j (length LstEnt))
		(setq entB (nth j LstEnt))
		(setq objB (vlax-ename->vla-object entB))
      
		(setq intPt (vlax-variant-value (vla-IntersectWith objA objB acExtendNone)))

		;; CORREZIONE 1 e 2: Estrazione corretta del Safearray dalla Variante e controllo su > -1
		(if (and intPt (> (vlax-safearray-get-u-bound intPt 1) -1))
			;; Conflitto geometrico rilevato
			(setq RtnLstEnt (cons (list entA entB) RtnLstEnt))
            ;; VERIFICA SOVRAPPOSIZIONE PERFETTA
			(if (CheckOverlap objA objB)
				(setq RtnLstEnt (cons (list entA entB) RtnLstEnt))
			)
		)
		(setq j (1+ j))
		)
		(setq i (1+ i))
	)
    ;; Ripristina l'ordine corretto della lista accumulata con cons
	(reverse RtnLstEnt)
)
;
;
;
(defun MainVla-IntersectWith (Ename1 Ename2 / i_pts conta Rtn)
	
		(if (and Ename1 Ename2)
			(progn
				(setq i_pts  (vlax-variant-value (vla-IntersectWith (vlax-ename->vla-object Ename1)
																	(vlax-ename->vla-object Ename2) acExtendNone)))
				(setq conta 0)
				(if (> (vlax-safearray-get-u-bound i_pts 1) 0)
					(repeat (/ (length (vlax-safearray->list i_pts)) 3)
						(setq Rtn (append Rtn (list (list (nth (+ 0 conta) (vlax-safearray->list i_pts))
														  (nth (+ 1 conta) (vlax-safearray->list i_pts))
													      (nth (+ 2 conta) (vlax-safearray->list i_pts))
											  ))
								  )
						)
						(setq conta (+ 3 conta))
					)
				)
				
				(if Rtn (setq Rtn (LM:UniqueFuzz Rtn 1e-5)))
				
			)
		)
		;(if Rtn (if (= (length Rtn) 1) (setq Rtn (nth 0 Rtn))) Rtn)
		Rtn
)
;
;
;
(defun PoligonInsidePoligon (EnameMaster EnameCheck / OffsetMaster ChkZoom Shape Rtn)
	
	(if (and EnameMaster EnameCheck)
		(progn
		
			(setq OffsetMaster  (OffsetShape EnameMaster 1.0))				
			(setq ChkZoom (VisibleEname OffsetMaster))						
				(setq Shape (LM:ent->pts OffsetMaster 50))					
				(vla-Delete (vlax-ename->vla-object OffsetMaster))			
				(if (member EnameCheck (LM:ss->ent (ssget "_WP" Shape)))	
					(setq Rtn T)
				)
			(ZoomPrevius ChkZoom)	
		)
	)
	Rtn			
)
;
;
;
(defun PoligonInsidePoligon02 (EnameMaster EnameCheck / ChkZoom Shape Rtn)
	
	(if (and EnameMaster EnameCheck)
		(progn
			(cond
				((and (= (vlax-get-property (vlax-ename->vla-object EnameMaster) 'ObjectName) "AcDbCircle")
					  (= (vlax-get-property (vlax-ename->vla-object EnameCheck)  'ObjectName) "AcDbCircle")
				 )
				 (setq Rtn (CircleInsideCircle EnameMaster EnameCheck))
				)
				(t 
					(if (>= (vlax-get (vlax-ename->vla-object EnameMaster) 'area) (vlax-get (vlax-ename->vla-object EnameCheck) 'area))
						(progn
							(setq ChkZoom (VisibleEnameWithCathArea EnameMaster 10.0))
								(setq Shape (LM:ent->pts EnameMaster 50))
								(if (member EnameCheck (LM:ss->ent (ssget "_WP" Shape)))
									(setq Rtn T)
								)
							(ZoomPrevius ChkZoom)
						)
					)
				)
			)
		)
	)
	Rtn			
)
;
;
;
(defun CircleInsideCircle (EnameMaster EnameSlave / CenterMaster CenterSlave RadiusMaster RadiusSlave)
	(if (and EnameMaster EnameSlave)
		(progn
			(setq CenterMaster (vlax-get (vlax-ename->vla-object EnameMaster) 'center))
			(setq CenterSlave  (vlax-get (vlax-ename->vla-object EnameSlave)  'center))
			(setq RadiusMaster (vlax-get (vlax-ename->vla-object EnameMaster) 'radius))
			(setq RadiusSlave  (vlax-get (vlax-ename->vla-object EnameSlave)  'radius))
			(<= (+ (distance CenterMaster CenterSlave) RadiusSlave) RadiusMaster)
		)
	)
)
;
;
;
(defun MeInsideBPlane (Bpl Pnt / IntCnt IntPnt PntLst PntExt)

	(setq 	IntCnt 0
			PntLst (append (cdr Bpl) (list (car Bpl)))
			PntExt (list	(+ 1E3 (apply 'max (mapcar 'car Bpl)))
							(+ 1E3 (apply 'max (mapcar 'cadr Bpl)))
							(caddr Pnt)
					)
	)
	(mapcar
		'(lambda (p1 p2)
			(if (and
					(setq IntPnt (inters Pnt PntExt p1 p2 T))
					(not (equal p1 IntPnt 1E-12))
				)
				(setq IntCnt (1+ IntCnt))
			)
		) Bpl PntLst
	)
	(not (zerop (rem IntCnt 2)))
)
;
;
;
(defun OffsetShape (EnameShape OfsT / CheckOffset
									  ObjOffset EnameOffset Surface Rtn ObjOffset1 ObjOffset2 Surface1 Surface2)

	
	(defun CheckOffset (EnameShape OfsT / LstEnameOffset o Rtn1 Rtn2)

		(if (not (vl-catch-all-error-p (setq o (vl-catch-all-apply 'vla-offset (list (vlax-ename->vla-object EnameShape) (abs OfsT))))))
			(progn
				(setq LstEnameOffset (vlax-safearray->list (vlax-variant-value o)))
				(if (= (length LstEnameOffset) 1)
					(setq Rtn1 T)
				)
				(foreach itm LstEnameOffset
					(vla-Delete itm)
				)
			)
		)
		(if (not (vl-catch-all-error-p (setq o (vl-catch-all-apply 'vla-offset (list (vlax-ename->vla-object EnameShape) (- 0.0 (abs OfsT)))))))
			(progn
				(setq LstEnameOffset (vlax-safearray->list (vlax-variant-value o)))
				(if (= (length LstEnameOffset) 1)
					(setq Rtn2 T)
				)
				(foreach itm LstEnameOffset
					(vla-Delete itm)
				)
			)
		)
		(list Rtn1 Rtn2)
	)
	;
	;
	;
	(if (and EnameShape OfsT)
		(progn
			(if (/= OfsT 0)
				(progn
				
					(setq Surface (vla-get-area (vlax-ename->vla-object EnameShape)))
					(setq Rtn     (CheckOffset EnameShape OfsT))
					
					(if (car Rtn)
						(setq ObjOffset1 (car (vlax-safearray->list (vlax-variant-value (vla-Offset (vlax-ename->vla-object EnameShape) (abs OfsT)))))
							  Surface1   (vla-get-area ObjOffset1)
						)
					)
					(if (cadr Rtn)
						(setq ObjOffset2 (car (vlax-safearray->list (vlax-variant-value (vla-Offset (vlax-ename->vla-object EnameShape) (- 0.0 (abs OfsT))))))
							  Surface2   (vla-get-area ObjOffset2)
						)
					)
					

					(if (> OfsT 0)
						(cond
							((and (numberp Surface1) (numberp Surface2))
								(if (> Surface1 Surface2)
									(progn
										(setq EnameOffset (vlax-vla-object->ename ObjOffset1))
										(vla-Delete ObjOffset2)
									)
									(progn
										(setq EnameOffset (vlax-vla-object->ename ObjOffset2))
										(vla-Delete ObjOffset1)
									)
								)
							)
							((and (numberp Surface1) (not (numberp Surface2)))
								(if (> Surface1 Surface)
									(setq EnameOffset (vlax-vla-object->ename ObjOffset1))
									(vla-Delete ObjOffset1)
								)
							)
							((and (numberp Surface2) (not (numberp Surface1)))
								(if (> Surface2 Surface)
									(setq EnameOffset (vlax-vla-object->ename ObjOffset2))
									(vla-Delete ObjOffset2)
								)
							)
						)
					)
					(if (< OfsT 0)
						(cond
							((and (numberp Surface1) (numberp Surface2))
								(if (< Surface1 Surface2)
									(progn
										(setq EnameOffset (vlax-vla-object->ename ObjOffset1))
										(vla-Delete ObjOffset2)
									)
									(progn
										(setq EnameOffset (vlax-vla-object->ename ObjOffset2))
										(vla-Delete ObjOffset1)
									)
								)
							)
							((and (numberp Surface1) (not (numberp Surface2)))
								(if (< Surface1 Surface)
									(setq EnameOffset (vlax-vla-object->ename ObjOffset1))
									(vla-Delete ObjOffset1)
								)
							)
							((and (numberp Surface2) (not (numberp Surface1)))
								(if (< Surface2 Surface)
									(setq EnameOffset (vlax-vla-object->ename ObjOffset2))
									(vla-Delete ObjOffset2)
								)
							)
						)
					)
				)
			)
		)
	)
	EnameOffset
)
;
;
;
(defun OffsetShape02 (EnameShape OfsT / Offset GetEnameOffsetExpansion GetEnameOffsetContraction
										Clock LstOffset LstEnameOffset Rtn)

	
	(defun Offset (EnameShape OfsT Clock / Nc EPoly LstEnameOffset)

		(setq Nc OfsT)
		(if (and EnameShape OfsT Clock)
			(progn
				(if (= Clock 3)
					(setq Nc (- 0.0 Nc))
				)
				(setq EPoly (MakePolyline (DiscretizeShapeNoControl EnameShape) T))
				(if (not (vl-catch-all-error-p (setq o (vl-catch-all-apply 'vla-offset (list (vlax-ename->vla-object EPoly) Nc)))))
					(setq LstEnameOffset (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value o))))
				)
				(entdel EPoly)
			)
		)
		LstEnameOffset
	)
	;
	(defun GetEnameOffsetExpansion (EnameShape LstEnameOffset / itm LstArea Rtn)
		(if (and EnameShape LstEnameOffset)
			(progn
				(foreach itm LstEnameOffset (setq LstArea (append LstArea (list (list (vla-get-area (vlax-ename->vla-object itm)) itm)))))
				(setq LstArea (vl-sort LstArea (function (lambda (e1 e2)  (> (car e1) (car e2))))))
				(if (> (car (car LstArea)) (vla-get-area (vlax-ename->vla-object EnameShape)))
					(progn
						(setq Rtn (cadr (car LstArea)))
						(foreach itm (cdr LstArea) (entdel (cadr itm)))
					)
					(foreach itm LstEnameOffset (entdel itm))
				)
			)
		)
		Rtn
	)
	;
	(defun GetEnameOffsetContraction (EnameShape LstEnameOffset / Rtn)
		(if (and EnameShape LstEnameOffset)
			(if (and (= (length LstEnameOffset) 1)
					 (< (vla-get-area (vlax-ename->vla-object (car LstEnameOffset))) (vla-get-area (vlax-ename->vla-object EnameShape)))
				)
				(setq Rtn (car LstEnameOffset))
				(foreach itm LstEnameOffset (entdel itm))
			)
		)
		Rtn
	)
	;
	; Main 
	;
	(setq Clock          (ClockWeisEname EnameShape))
	(setq LstEnameOffset (Offset EnameShape OfsT Clock))
	
	(if LstEnameOffset
		(if (> OfsT 0) ; Expand
			(setq Rtn (GetEnameOffsetExpansion   EnameShape LstEnameOffset))
			(setq Rtn (GetEnameOffsetContraction EnameShape LstEnameOffset))
		)
	)
	Rtn
)
;
;
;
(defun OffsetShape03 (EnameShape OfsT / LstVert EnameTmp Jou Oft Rtn)

	;	Antioraria	>0 Aumenta
	;	Oraria		>0 Diminuisce
	;	Antioraria	<0 Diminuisce
	;	Oraria		<0 Aumenta
	
	
	(if (and EnameShape OfsT)
		(progn
	
			(setq LstVert   (DiscretizeShapeNoControl EnameShape))
			(setq LstVert   (LM:ConvexHull LstVert))
			(setq EnameTmp  (LM:MakeLWPoly LstVert 1))
			(setq Jou 		(ClockWeisEname EnameShape))	; 2 percorrenza Anti Oraria	3 percorrenza Oraria
			
			(cond
				((> OfsT 0.0) ; gonfia
					(cond 
						; antioraria
						((= Jou 2) (setq Oft OfsT))
						; oraria
						((= Jou 3) (setq Oft OfsT))
					)
				)
				((< OfsT 0.0) ; sgonfia
					(cond 
						; antioraria
						((= Jou 2) (setq Oft OfsT))
						; oraria
						((= Jou 3) (setq Oft OfsT))
					)
				)
			)
			;(princ "\n") (princ Oft) (princ "\n")
			(if (not (vl-catch-all-error-p (setq LstOffset (vl-catch-all-apply 'vla-offset (list (vlax-ename->vla-object EnameTmp) Oft)))))
				(setq Rtn (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value LstOffset))))
			)
			(DeleteEntity (list EnameTmp))
		)
	)
	(if Rtn (car Rtn))
)
;
;
;
(defun GeneralOffset (Ename OfsT / RtnOffset)

	(if (not (setq RtnOffset (OffsetShape02 Ename OfsT)))
			 (setq RtnOffset (OffsetShape03 Ename OfsT))
	)
	RtnOffset
)
;
;
;
(defun OffsetShapeDelimitated (EnameShape DimOffset / Offset1 Offset2 PtOff Rtn)
	(if EnameShape
		(progn
			(setq Offset1	(GeneralOffset EnameShape DimOffset))
			(setq PtOff		(BoundingBoxLstEname (list EnameShape)))
			(setq Offset2	(MakeRectangle (list (- (car (car PtOff)) DimOffset) (- (cadr (car PtOff)) DimOffset))
							(+ (distance (car PtOff) (cadr PtOff)) DimOffset DimOffset)
							(+ (distance (cadr PtOff) (caddr PtOff)) DimOffset DimOffset)))
			(setq Rtn		(BooleanShape Offset1 1 Offset2))
			(DeleteEntity (list Offset1 Offset2))
		)
	)
	Rtn
)
;
; Rotation Check ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun Test (/ Ename1 Ename2 PtRotate) 
	(setq Ename1 	(car (entsel "\nEn 1 ")))
	(setq Ename2  	(car (entsel "\nEn 2 ")))
	(setq PtRotate  (getpoint "\nPunto rotazione"))
	(GetPointRotate Ename1 Ename2 PtRotate T)
)
;
;(defun Test1 (/ Ename1 Ename2) 
;	(setq Ename1 	  (car (entsel "\nEn 1 ")))
;	(setq Ename2  	  (car (entsel "\nEn 2 ")))
;	
;	(IntersectionsFuzz (vlax-ename->vla-object Ename1) (vlax-ename->vla-object Ename2) 1e-8) 
;	(LM:intersections (vlax-ename->vla-object Ename1) (vlax-ename->vla-object Ename2) acextendnone)
;)
;
;
(defun GetPointRotate (Ename1 Ename2 PtRotate Verbose / Rtn)

	(if (and Ename1 Ename2 PtRotate)
		(cond
			((and (= (GetNameEname Ename1) "LINE") 		(= (GetNameEname Ename2) "LINE"))
				(setq Rtn (RotateLineToLine Ename1 Ename2 PtRotate Verbose)) 
			)
			((and (= (GetNameEname Ename1) "LINE") 		(= (GetNameEname Ename2) "ARC"))
				(setq Rtn (RotateLineToArc Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "ARC") 		(= (GetNameEname Ename2) "LINE"))
				(setq Rtn (RotateArcToLine Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "LINE") 		(= (GetNameEname Ename2) "CIRCLE"))
				(setq Rtn (RotateLineToCircle Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "CIRCLE") 	(= (GetNameEname Ename2) "LINE"))
				(setq Rtn (RotateCircleToLine Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "CIRCLE") 	(= (GetNameEname Ename2) "CIRCLE"))
				(setq Rtn (RotateCircleToCircle Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "CIRCLE")	(= (GetNameEname Ename2) "ARC"))
				(setq Rtn (RotateCircleToArc Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "ARC")		(= (GetNameEname Ename2) "CIRCLE"))
				(setq Rtn (RotateArcToCircle Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "ARC") 		(= (GetNameEname Ename2) "ARC"))
				(setq Rtn (RotateArcToArc Ename1 Ename2 PtRotate Verbose))
			)
		)
	)
	;(vl-sort (LM:UniqueFuzz (mapcar 'ReconditionAngle Rtn) (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0)) '<)
)
;
;
(defun RotateLineToLine (EnameLine1 EnameLine2 PtRotate Verbose)
	(if (and EnameLine1 EnameLine2 PtRotate)
		(SegmentRotation EnameLine1 EnameLine2 PtRotate Verbose)
	)
)
;
;
(defun RotateLineToArc (EnameLine EnameArc PtRotate Verbose)
	(if (and EnameLine EnameArc PtRotate)
		(append (TangentRotationArc EnameLine EnameArc PtRotate Verbose 1)
				(SecantRotationOnArc  EnameLine EnameArc PtRotate Verbose 1))
	)
)
;
;
(defun RotateArcToLine (EnameArc EnameLine PtRotate Verbose)
	(if (and EnameLine EnameArc PtRotate)
		(append (TangentRotationArc EnameLine EnameArc PtRotate Verbose 2)
				(SecantRotationOnArc  EnameLine EnameArc PtRotate Verbose 2))
	)
)
;
;
(defun RotateLineToCircle (EnameLine EnameCircle PtRotate Verbose)
	(if (and EnameLine EnameCircle PtRotate)
		(append (TangentRotationArc EnameLine EnameCircle PtRotate Verbose 1)
				(SecantRotationOnCircle  EnameLine EnameCircle PtRotate Verbose 1))
	)
)
;
;
(defun RotateCircleToLine (EnameCircle EnameLine PtRotate Verbose)
	(if (and EnameLine EnameCircle PtRotate)
		(append (TangentRotationArc EnameLine EnameCircle PtRotate Verbose 2)
				(SecantRotationOnCircle  EnameLine EnameCircle PtRotate Verbose 2))
	)
)
;
;
(defun RotateCircleToCircle (EnameCircle1 EnameCircle2 PtRotate Verbose)
	(if (and EnameCircle1 EnameCircle2 PtRotate)
		(TangentRotationCircle EnameCircle1 EnameCircle2 PtRotate Verbose)
	)
)
;
;
(defun RotateArcToCircle (EnameArc EnameCircle PtRotate Verbose)
	(if (and EnameArc EnameCircle PtRotate)
		(append (TangentRotationCircle EnameArc EnameCircle PtRotate Verbose)
				(SecantRotationOnCircle EnameArc EnameCircle PtRotate Verbose 1)
		)
	)
)
;
;
(defun RotateCircleToArc (EnameCircle EnameArc PtRotate Verbose)
	(if (and EnameCircle EnameArc PtRotate)
		(append (TangentRotationCircle EnameCircle EnameArc PtRotate Verbose)
				(SecantRotationOnCircle EnameArc EnameCircle PtRotate Verbose 2)
		)
	)
)
;
;
(defun RotateArcToArc (EnameArc1 EnameArc2 PtRotate Verbose)
	(if (and EnameArc1 EnameArc2 PtRotate)
		(append (TangentRotationCircle EnameArc1 EnameArc2 PtRotate Verbose)
				(SecantRotationOnArc EnameArc1 EnameArc2 PtRotate Verbose 1))
	)
)
;
;
(defun SegmentRotation (EnameLine1 EnameLine2 PtRotate Verbose / AccuracyIntersection ModelSpace Pa1 Pa2 Pb1 Pb2
																 RadiusPa1 RadiusPa2 RadiusPb1 RadiusPb2
																 Circle itm
																 Pint LstPt itm ang1 ang2 Rtn)
	(if (and Ename1 Ename2 PtRotate)
		(progn
			(setq AccuracyIntersection 1e-8)
			(setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
				
			(setq Pa1 (vlax-get (vlax-ename->vla-object EnameLine1) 'StartPoint)
			      Pa2 (vlax-get (vlax-ename->vla-object EnameLine1) 'EndPoint)
			      Pb1 (vlax-get (vlax-ename->vla-object EnameLine2) 'StartPoint)
			      Pb2 (vlax-get (vlax-ename->vla-object EnameLine2) 'EndPoint))
			
			(setq RadiusPa1 (distance PtRotate Pa1)
			      RadiusPa2 (distance PtRotate Pa2)
			      RadiusPb1 (distance PtRotate Pb1)
			      RadiusPb2 (distance PtRotate Pb2))
			
			(if (> RadiusPa1 0.0)
				(progn
					(setq Circle (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPa1))
					(foreach itm (IntersectionsFuzz Circle (vlax-ename->vla-object EnameLine2) AccuracyIntersection) 
						(setq LstPt (append LstPt (list (list Pa1 itm)))) 
					)
					(DeleteObject (list Circle))
				)
			)
			
			(if (> RadiusPa2 0.0)
				(progn
					(setq Circle (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPa2))
					(foreach itm (IntersectionsFuzz Circle (vlax-ename->vla-object EnameLine2) AccuracyIntersection)
						(setq LstPt (append LstPt (list (list Pa2 itm))))
					)
					(DeleteObject (list Circle))
				)
			)

			(if (> RadiusPb1 0.0)
				(progn
					(setq Circle (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPb1))
					(foreach itm (IntersectionsFuzz Circle (vlax-ename->vla-object EnameLine1) AccuracyIntersection)
						(setq LstPt (append LstPt (list (list itm Pb1))))
					)
					(DeleteObject (list Circle))
				)
			)
			
			(if (> RadiusPb2 0.0)
				(progn
					(setq Circle (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPb2))
					(foreach itm (IntersectionsFuzz Circle (vlax-ename->vla-object EnameLine1) AccuracyIntersection)
						(setq LstPt (append LstPt (list (list itm Pb2))))
					)
					(DeleteObject (list Circle))
				)
			)

			(foreach itm LstPt 
				(setq ang1 (angle PtRotate (car  itm)))
				(setq ang2 (angle PtRotate (cadr itm)))
				(setq Rtn (append Rtn (list (ReconditionAngle (- ang2 ang1)))))
				;(setq Rtn (append Rtn (list (list (ReconditionAngle (- ang2 ang1)) (cadr  itm)))))
			)
			
			;(setq Rtn (LM:UniqueFuzz Rtn (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0))) 
			
			(if Verbose 
				(foreach itm Rtn
					(vla-rotate (vla-copy (vlax-ename->vla-object EnameLine1)) (vlax-3d-point PtRotate) itm)
					;(vla-rotate (vla-copy (vlax-ename->vla-object EnameLine1)) (vlax-3d-point PtRotate) (car itm))
					;(vla-AddPoint ModelSpace (vlax-3d-point (cadr itm)))
				)
			)
		)
	)
	Rtn
)
;
;
(defun TangentRotationArc (EnameLine EnameArc PtRotate Verbose Mode / CheckRotation
																	  ModelSpace AccuracyIntersection Center Radius StartPoint EndPoint 
																	  ObjCircle ObjLineA ObjLineB ParA ParB Ang itm LstAng Rtn)
	
	;
	(defun CheckRotation (EnameLine EnameArc PtRotate LstRotate AccuracyIntersection / NewObj itm PtInt Rtn)
		
		(if (and EnameLine EnameArc PtRotate LstRotate AccuracyIntersection)
			(foreach itm LstRotate
				(setq NewObj (vla-copy (vlax-ename->vla-object EnameLine)))
				(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
				;(if (setq PtInt (LM:intersections (vlax-ename->vla-object EnameArc) NewObj acextendnone))
				(if (setq PtInt (IntersectionsFuzz (vlax-ename->vla-object EnameArc) NewObj AccuracyIntersection))
					(if (= (length PtInt) 1)
						(setq Rtn (append Rtn (list itm)))
						;(setq Rtn (append Rtn (list (list itm (car PtInt)))))
					)
				)
				(DeleteObject (list NewObj))
			)
		)
		Rtn
	)
	;
	; Main +++
	;
	(if (and PtRotate EnameLine EnameArc)
		(progn
			(setq AccuracyIntersection 1e-8
				  ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))
				  Center     (vlax-get (vlax-ename->vla-object EnameArc)  'center)
				  Radius     (vlax-get (vlax-ename->vla-object EnameArc)  'Radius)
				  StartPoint (vlax-get (vlax-ename->vla-object EnameLine) 'StartPoint)
				  EndPoint   (vlax-get (vlax-ename->vla-object EnameLine) 'EndPoint)
			)
			;
			; Control Tangent Point
			;
			(if (and (> (distance PtRotate Center) 0.0)
					 (> Radius 0.0)
					 (> (distance StartPoint EndPoint) 0.0))
				(progn
					(setq ObjCircle (vla-AddCircle ModelSpace (vlax-3d-point PtRotate) (distance PtRotate Center))
					      ParA (Par (car StartPoint) (cadr StartPoint) (car EndPoint) (cadr EndPoint) Radius)
					      Parb (Par (car StartPoint) (cadr StartPoint) (car EndPoint) (cadr EndPoint) (- 0.0 Radius))
					      ObjLineA  (vla-addline ModelSpace (vlax-3d-point (car ParA)) (vlax-3d-point (cadr ParA)))
					      ObjLineB  (vla-addline ModelSpace (vlax-3d-point (car ParB)) (vlax-3d-point (cadr ParB)))
					      Ang  		(angle PtRotate Center)
					)
							
					(foreach itm (IntersectionsFuzz ObjCircle ObjLineA AccuracyIntersection)
						(setq LstAng (append LstAng (list (- Ang (angle PtRotate itm)))))
					)
					(foreach itm (IntersectionsFuzz ObjCircle ObjLineB AccuracyIntersection)
						(setq LstAng (append LstAng (list (- Ang (angle PtRotate itm)))))
					)
					(DeleteObject (list ObjLineA ObjLineB ObjCircle))
				)
			)
			;
			(if (= Mode 2)
				(foreach itm (CheckRotation EnameLine EnameArc PtRotate LstAng AccuracyIntersection)
					;(setq Rtn (append Rtn (list (list (- 0.0 (car itm)) (car (RotatePoint (list (cadr itm)) PtRotate (- 0.0 (car itm))))))))
					(setq Rtn (append Rtn (list (- 0.0 itm))))
				)
				(setq Rtn (CheckRotation EnameLine EnameArc PtRotate LstAng AccuracyIntersection))				
			)
			(if Verbose 
				(foreach itm Rtn
					(if (= Mode 2)
						(vla-rotate (vla-copy (vlax-ename->vla-object EnameArc))  (vlax-3d-point PtRotate) itm)
						(vla-rotate (vla-copy (vlax-ename->vla-object EnameLine)) (vlax-3d-point PtRotate) itm)
					)
					;(vla-AddPoint ModelSpace (vlax-3d-point (cadr itm)))
				)
			)
		)
	)
	Rtn
)
;
;
(defun SecantRotationOnArc (Ename1 Ename2 PtRotate Verbose Mode / CheckRotation
															      AccuracyIntersection NewObj itm Rtn)


	(defun CheckRotation (Ename1 Ename2 PtRotate LstRotate AccuracyIntersection / Pa1 Pa2 NewObj itm PtInt Rtn)

		(if (and Ename1 Ename2 PtRotate LstRotate AccuracyIntersection)
			(foreach itm LstRotate
				(setq NewObj (vla-copy (vlax-ename->vla-object Ename1)))
				(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
				(if (= (GetNameEname (vlax-vla-object->ename NewObj)) "ARC")
					(setq Pa1 (vlax-get (vlax-ename->vla-object (vlax-vla-object->ename NewObj)) 'StartPoint)
					      Pa2 (vlax-get (vlax-ename->vla-object (vlax-vla-object->ename NewObj)) 'EndPoint)
					)
					(setq Pa1 (vlax-get (vlax-ename->vla-object Ename2) 'StartPoint)
						  Pa2 (vlax-get (vlax-ename->vla-object Ename2) 'EndPoint)
					)
				)

				(if (setq PtInt (IntersectionsFuzz (vlax-ename->vla-object Ename2) NewObj AccuracyIntersection))
					(if (= (length PtInt) 1)
						(setq Rtn (append Rtn (list itm)))
						(if (and Pa1 Pa2)
							(if (and (or (equal Pa1 (car  PtInt) AccuracyIntersection)
										 (equal Pa2 (car  PtInt) AccuracyIntersection))
									 (or (equal Pa1 (cadr PtInt) AccuracyIntersection)
										 (equal Pa2 (cadr PtInt) AccuracyIntersection))
								)
								(setq Rtn (append Rtn (list itm)))
							)
						)
					)
				)
				(DeleteObject (list NewObj))
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq AccuracyIntersection 1e-8)
	(cond
		((= Mode 1)
			(setq Rtn (CheckRotation Ename1 Ename2 PtRotate 
							(SegmentRotation Ename1 Ename2 PtRotate nil) AccuracyIntersection))
			(if Verbose 
				(foreach itm Rtn
					(setq NewObj (vla-copy (vlax-ename->vla-object Ename1)))
					(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
				)
			)
		)
		((= Mode 2)
			(setq Rtn (CheckRotation Ename2 Ename1 PtRotate 
							(SegmentRotation Ename2 Ename1 PtRotate nil) AccuracyIntersection))
			(if Verbose 
				(foreach itm Rtn
					(setq NewObj (vla-copy (vlax-ename->vla-object Ename2)))
					(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
				)
			)
		)
	)
	Rtn
)
;
;
(defun SecantRotationOnCircle (EnameLine EnameCircle PtRotate Verbose Mode / CheckRotation
																		     AccuracyIntersection ModelSpace Pa1 Pa2 RadiusPa1 RadiusPa2
																		     Circle LstPt LstRotate itm NewObj Rtn)

	
	(defun CheckRotation (Ename1 Ename2 PtRotate LstRotate AccuracyIntersection / NewObj itm PtInt Rtn)

		(if (and Ename1 Ename2 PtRotate LstRotate AccuracyIntersection)
			(foreach itm LstRotate
				(setq NewObj (vla-copy (vlax-ename->vla-object Ename1)))
				(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
				(if (setq PtInt (IntersectionsFuzz (vlax-ename->vla-object Ename2) NewObj AccuracyIntersection))
					(if (= (length PtInt) 1)
						(setq Rtn (append Rtn (list itm)))
					)
				)
				;(getstring "-----")
				(DeleteObject (list NewObj))
			)
		)
		Rtn
	)	
	;
	; Main
	;
	(if (and EnameLine EnameCircle PtRotate Mode)
		(progn
			(setq AccuracyIntersection 1e-8
				  ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))
				  Pa1 (vlax-get (vlax-ename->vla-object EnameLine) 'StartPoint)
				  Pa2 (vlax-get (vlax-ename->vla-object EnameLine) 'EndPoint)
				  RadiusPa1 (distance PtRotate Pa1)
			      RadiusPa2 (distance PtRotate Pa2)
			)
			
			(if (> RadiusPa1 0.0)
				(progn
					(setq Circle (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPa1))
					(foreach itm (IntersectionsFuzz Circle (vlax-ename->vla-object EnameCircle) AccuracyIntersection) 
						(setq LstPt (append LstPt (list (list Pa1 itm)))) 
					)
					;(getstring "++++")
					(DeleteObject (list Circle))
				)
			)
			
			(if (> RadiusPa2 0.0)
				(progn
					(setq Circle (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPa2))
					(foreach itm (IntersectionsFuzz Circle (vlax-ename->vla-object EnameCircle) AccuracyIntersection)
						(setq LstPt (append LstPt (list (list Pa2 itm))))
					)
					;(getstring "++++")
					(DeleteObject (list Circle))
				)
			)
			(foreach itm LstPt 
				(setq ang1 (angle PtRotate (car  itm)))
				(setq ang2 (angle PtRotate (cadr itm)))
				(if (= Mode 1)
					(setq LstRotate (append LstRotate (list (ReconditionAngle (- ang2 ang1)))))
					(setq LstRotate (append LstRotate (list (ReconditionAngle (- 0.0 (- ang2 ang1))))))
				)
			)
			
			(if (= Mode 1)
				(setq Rtn (CheckRotation EnameLine EnameCircle PtRotate LstRotate AccuracyIntersection))
				(setq Rtn (CheckRotation EnameCircle EnameLine PtRotate LstRotate AccuracyIntersection))
			)
				
			(foreach itm Rtn
				(if (= Mode 1)
					(setq NewObj (vla-copy (vlax-ename->vla-object EnameLine)))
					(setq NewObj (vla-copy (vlax-ename->vla-object EnameCircle)))
				)
				(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
			)
		)
	)
	Rtn
)
;
;
(defun TangentRotationCircle (EnameArc1 EnameArc2 PtRotate Verbose / GetAng01 CheckRotation
																     AccuracyIntersection Center1 Center2 Radius1 Radius2 
																     AngTg1 AngTg2 Ang1 Ang2 Rtn)

	;
	(defun GetAng01 (Dist_A Dist_B Dist_C / Arg Rtn)
		(if (and Dist_A Dist_B Dist_C)
			(progn
				(setq Arg (/ (- (+ (* Dist_B Dist_B) (* Dist_C Dist_C)) (* Dist_A Dist_A)) (* 2.0 Dist_B Dist_C)))
				(if (and (>= Arg 0.0) (<= Arg 1.0))
					(setq Rtn (acos Arg))
				)
			)
		)
		Rtn
	)
	;
	(defun CheckRotation (EnameArc1 EnameArc2 PtRotate LstRotate AccuracyIntersection / NewObj itm Rtn)
	
		(if (and EnameArc1 EnameArc2 PtRotate LstRotate AccuracyIntersection)
			(foreach itm LstRotate
				(setq NewObj (vla-copy (vlax-ename->vla-object EnameArc1)))
				(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
				(if (IntersectionsFuzz (vlax-ename->vla-object EnameArc2) NewObj AccuracyIntersection)
					(setq Rtn (append Rtn (list itm)))
				)
				(DeleteObject (list NewObj))
			)
		)
		Rtn
	)
	;
	; Main +++
	;
	(if (and EnameArc1 EnameArc2 PtRotate)
		(progn
			(setq AccuracyIntersection 1e-8
				  Center1     (vlax-get (vlax-ename->vla-object EnameArc1)  'center)
				  Center2     (vlax-get (vlax-ename->vla-object EnameArc2)  'center)
				  Radius1     (vlax-get (vlax-ename->vla-object EnameArc1)  'Radius)
				  Radius2     (vlax-get (vlax-ename->vla-object EnameArc2)  'Radius)
			)
			(setq AngTg1 (GetAng01 (+ Radius1 Radius2) (distance PtRotate Center1) (distance PtRotate Center2)))
			(setq AngTg2 (GetAng01 (- Radius1 Radius2) (distance PtRotate Center1) (distance PtRotate Center2)))
			(setq Ang1   (angle PtRotate Center1))
			(setq Ang2   (angle PtRotate Center2))
			(if AngTg1   (setq Rtn (append Rtn (list (+ (- Ang2 Ang1) AngTg1) (- (- Ang2 Ang1) AngTg1)))))
			(if AngTg2   (setq Rtn (append Rtn (list (+ (- Ang2 Ang1) AngTg2) (- (- Ang2 Ang1) AngTg2)))))
			(setq Rtn    (CheckRotation EnameArc1 EnameArc2 PtRotate Rtn AccuracyIntersection))

			(if Verbose
				(foreach itm Rtn
					(setq NewObj (vla-copy (vlax-ename->vla-object EnameArc1)))
					(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
				)
			)
		)
	)
	Rtn
)
;
;

;
;


