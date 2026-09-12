; programma interessante NESTED MOVE (lee mac)
;
;
;
(defun CtlStep ()
	(if (not PrgCtrl$) (setq PrgCtrl$ 1))
	(princ (strcat "\n --- Step -->" (LM:rtos PrgCtrl$ 2 0) " <---"))
	(setq PrgCtrl$ (1+ PrgCtrl$))
)

(defun test1 ()
	(prompt "\nSagoma da inserire ")
	(setq EnameShape (SselSelectShape))
	(setq Data  (entsel "<Allineato a ...>"))
	(setq Border 20.0)
	(DinamicAlign (car Data) EnameShape Border (cadr Data))
)

(defun FineTunning ( / EnameShape)
	(prompt "\nSagoma da inserire ")
	(setq EnameShape (SselSelectShape))
	(if EnameShape
		(DummyNesting EnameShape)
	)
)
;
;
;
(defun DummyNesting ( EnameShape / *error* PrintData DeletePrintData
									ColorShape BoxEname RadiusRule Shape PtStart PtEnd PointData Loop StepAngle
									Gr Code Data Rtn ViewSize_htxt PosData
								)

	;
	;
	;
	(defun *error* (msg)
		(DeletePrintData)
		(princ)
    )
	;
	(defun PrintData (info pstart htesto / pglo offsetx offsety)
		
		(DeleteEntity (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 8 $LayerDinamicInfoEasyCut)))))
 
 
		(setq 	offsetx (*  htesto 2.0)
				offsety (*  htesto 2.0)
				pglo (trans (list (+ (car pstart) offsetx) (+ (cadr pstart) offsety)) 1 0)
				info (strcat "\n{\\Fromans|c0;\\W0.8;\\C1;Rotazione\t\\C252;" info)
				info 	(entmakex (list
                                (cons 0 "MTEXT")                              
                                (cons 100 "AcDbEntity")
                                (cons 100 "AcDbMText")
                                (cons 8   $LayerDinamicInfoEasyCut)
                                (cons 1  info)
                                (cons 10 pglo)
                                (cons 40 htesto)
                                (cons 50 0.0)
                                (cons 62 71)
                                (cons 71 1)
                                (cons 90 3)
								(cons 63 9)
								(cons 421 13158600)
								(cons 441 9434636)
                                ;(cons 63 256)
                                ;(cons 45 1.2)
                                (cons 210 (list 0.0 0.0 1.0))
                                (cons 11 (list 1.0 0.0 0.0))
                            )
					)
		)
    )
	;
	(defun DeletePrintData (/ Sset nE)
		(DeleteEntity (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 8 $LayerDinamicInfoEasyCut)))))    
	)
	;
	;
	; MAIN  +++++++++++++
	;
	(setq ColorShape  1)
	(setq StepAngle 0.0)
	(setq Loop T )
	
	(if EnameShape
		(progn

			(setq BoxEname 	  (BoundingBoxLstEname (list EnameShape)))
			(setq RadiusRule  (/ (distance (car BoxEname) (caddr BoxEname)) 2.0))
			(setq Shape 	  (DiscretizeShape EnameShape))
			(setq PtStart 	  (car (div (car (car BoxEname)) (cadr (car BoxEname)) (car (caddr BoxEname)) (cadr (caddr BoxEname)) 1)))
			(setq PointData   (list (+ (car PtStart) RadiusRule) (cadr PtStart))) 
			
			(setq msgLst (strcat "\r[R]otate [M]irror"))
			(princ msgLst)
			
			(while Loop
			
				(setq Gr (grread 't 15 1) Code (car Gr) Data (cadr Gr))
				
				(cond
					((= Code 2)
						(cond
							; rotazione	(tasto r/R)
							((member Data '(082 114)) 	
								(setq Rtn 	    (DinamicRotateLowGraphics EnameShape nil StepAngle))
								(setq StepAngle (cadr Rtn))
								(princ msgLst)
							)
							; specchia (tasto m/M)
							((member Data '(077 109))		
								(setq Rtn 	    (DinamicMirrorLowGraphics EnameShape nil))
							)
						)
					)
					; Mouse rolling
					((and (= Code 5) (listp Data))
						(setq PtEnd Data)
						(redraw)
						(GraphicsRotationTraslate Shape PtStart PtEnd StepAngle 1)	
						(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
						(setq PointData (list (+ (car PtEnd) RadiusRule) (cadr PtEnd)))
						;(PrintData (rtos (* (/ StepAngle pi) 180.0) 2 5) PointData ViewSize_htxt)
						(PolarRuler PtEnd RadiusRule)
					)
					; Left click mouse
					((and (= Code 3) (listp Data))  							
						(redraw)
						(DeletePrintData)
						(setq PtEnd Data)
						; Zoom To .............
						(if (ssget "_CP" (GraphicsRotationTraslate Shape PtStart PtEnd StepAngle ColorShape))
							(setq PosData (entsel "<Allineato a ...>"))
						)
						(if PosData
							(DinamicAlign (car PosData) EnameShape $MargineAccosto (cadr PosData) StepAngle)
							(CopyShape EnameShape (list PtStart PtEnd StepAngle))
						)
						(setq Loop nil)
					)
				)
			)
		)
	)	
)
;
;
;
(defun CopyShape (EnameShape LstPos / itm Obj Start End Rot Rtn)

	(if EnameShape
		(progn
			(if LstPos
				(progn
					(setq Start (car LstPos))
					(setq End	(cadr LstPos))
					(setq Rot	(caddr LstPos))
				)
			)
			(foreach itm (LM:ss->ent (SelectShape EnameShape))
				;(princ "\n Copy ") (princ (assoc 0 (entget itm))) (princ itm)
				(setq Obj (vla-Copy (vlax-ename->vla-object itm)))
				(if LstPos
					(progn
						(vla-rotate Obj (vlax-3d-point Start) Rot)
						(vla-Move Obj (vlax-3d-point Start) (vlax-3d-point End))
					)
				)
				(setq Rtn (append Rtn (list (vlax-vla-object->ename Obj))))
			)
			(setq Rtn (CloneShape Rtn))
		)
	)
	Rtn
)
;
;
;
(defun GraphicsRotationTraslate (LstPoint PtStart PtEnd Rotation ColorRotation / Dca RotatePoint TraslatePoint LstPt)


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
	;
	;
	(defun TraslatePoint (LstPoint PtStart PtEnd / itm Rtn DeltaX DeltaY)
		
		(if (and LstPoint PtStart PtEnd)
			(progn
				(setq DeltaX (- (nth 0 PtEnd) (nth 0 PtStart)))
				(setq DeltaY (- (nth 1 PtEnd) (nth 1 PtStart)))
				
				(foreach itm LstPoint
				
					(setq Rtn (append Rtn (list (list (+ (nth 0 itm ) DeltaX)
										              (+ (nth 1 itm ) DeltaY)
										        )))
					)
				)
			)
		)
		Rtn
	)

	;
	;
	;
	(if (and LstPoint PtStart PtEnd Rotation ColorRotation)
		(progn
			(setq LstPt (TraslatePoint LstPoint PtStart PtEnd))
			(setq LstPt (RotatePoint   LstPt PtEnd Rotation))
			(DrawLowGraphics (append LstPt (list (nth 0 LstPt))) ColorRotation)
		)
	)
	(append LstPt (list (nth 0 LstPt)))
)
;
;
;
(defun MirrorShape (LstPoint Px AngleMirror / ReflectedPoint 
												 Pt LstPt)

	(defun ReflectedPoint (Pa Pb LstPt / itm Rtn)
		(foreach itm LstPt
			(setq Rtn (append Rtn (list (polar pa (- (* 2 (angle pa pb)) (angle pa itm)) (distance pa itm)))))
		)
	)
	;
	;
	(if (and LstPoint Px AngleMirror)
		(progn
			(setq Pt         (polar Px AngleMirror 1.0))
			(setq LstPt      (ReflectedPoint Px Pt LstPoint))
		)
	)
	LstPt
)
;
;
;
(defun GraphicsMove (LstPoint ColorRotation / LstPt)
	;
	(if (and LstPoint ColorRotation)
		(DrawLowGraphics (append LstPoint (list (nth 0 LstPoint))) ColorRotation)
	)
)
;
;
;
(defun TraslateShape (LstPoint PtStart PtEnd / TraslatePoint LstPt)

	;
	(defun TraslatePoint (LstPoint PtStart PtEnd / itm Rtn DeltaX DeltaY)
		
		(if (and LstPoint PtStart PtEnd)
			(progn
				(setq DeltaX (- (nth 0 PtEnd) (nth 0 PtStart)))
				(setq DeltaY (- (nth 1 PtEnd) (nth 1 PtStart)))
				
				(foreach itm LstPoint
				
					(setq Rtn (append Rtn (list (list (+ (nth 0 itm ) DeltaX)
										              (+ (nth 1 itm ) DeltaY)
										        )))
					)
				)
			)
		)
		Rtn
	)
	;
	;
	(if (and EnameShape PtStart PtEnd)
			(setq LstPt    (TraslatePoint LstPoint PtStart PtEnd))
	)
	LstPt
)
;
;
;
(defun DinamicMirrorLowGraphics (EnameShape AnchorShape / 	*error* PrintData DeletePrintData 
															ColorShape StepRotate Loop StepAngle
															BoxEname RadiusRule PtStart PointData ViewSize_htxt Shape Rtn
														)

	
	(defun *error* (msg)
		(princ msg)
		(DeletePrintData)
		(DeletedHatchEasyCut)
		(redraw)
		(princ)
    )
	;
	(defun PrintData (info pstart htesto / pglo offsetx offsety)
		
		(DeleteEntity (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 8 $LayerDinamicInfoEasyCut)))))
 
 
		(setq 	offsetx (*  htesto 2.0)
				offsety (*  htesto 2.0)
				pglo (trans (list (+ (car pstart) offsetx) (+ (cadr pstart) offsety)) 1 0)
				info (strcat "\n{\\Fromans|c0;\\W0.8;\\C1;Rotazione\t\\C252;" info)
				info 	(entmakex (list
                                (cons 0 "MTEXT")                              
                                (cons 100 "AcDbEntity")
                                (cons 100 "AcDbMText")
                                (cons 8   $LayerDinamicInfoEasyCut)
                                (cons 1  info)
                                (cons 10 pglo)
                                (cons 40 htesto)
                                (cons 50 0.0)
                                (cons 62 71)
                                (cons 71 1)
                                (cons 90 3)
								(cons 63 9)
								(cons 421 13158600)
								(cons 441 9434636)
                                ;(cons 63 256)
                                ;(cons 45 1.2)
                                (cons 210 (list 0.0 0.0 1.0))
                                (cons 11 (list 1.0 0.0 0.0))
                            )
					)
		)
    )
	;
	(defun DeletePrintData (/ Sset nE)
		(DeleteEntity (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 8 $LayerDinamicInfoEasyCut)))))    
    )
	;
	; Main 
	;
	(setq ColorShape 	1)
	(setq StepRotate 	1.0)
	(setq Loop 			T)
	(setq StepAngle  	0.0)

	(if EnameShape
		(progn
			(setq BoxEname 		(BoundingBoxLstEname (list EnameShape)))
			(setq RadiusRule  	(/ (distance (car BoxEname) (caddr BoxEname)) 2.0))
			(setq PtStart 		(car (div (car (car BoxEname)) (cadr (car BoxEname)) (car (caddr BoxEname)) (cadr (caddr BoxEname)) 1)))
			(setq Shape         (DiscretizeShape EnameShape))
			(if AnchorShape
				(setq PtEnd PtStart)
			)
			(setq msgLst (strcat "\n[M]irror X | [m]irror Y | [Enter] | [E]xit"))
			(princ msgLst)	
		
			(while Loop

				(setq Gr (grread 't 15 1) Code (car Gr) Data (cadr Gr))
			
				(cond
					((= Code 2)
						(cond
							;Mirror X
							((= Data 077)
								(if (not AnchorShape)
									(setq Shape (MirrorShape Shape PtEnd   0.0))
									(setq Shape (MirrorShape Shape PtStart 0.0))
								)
							)
							;Mirror Y
							((= Data 109)						
								(if (not AnchorShape)
									(setq Shape (MirrorShape Shape PtEnd   (/ Pi 2.0)))
									(setq Shape (MirrorShape Shape PtStart (/ Pi 2.0)))
								)
							)
							; Enter
							((= Data 013)
								(redraw)
								(DeletePrintData)
								(setq Loop nil)
							)
						)
					)
					; Mouse rolling
					((and (= Code 5) (listp Data))
					
						(if (not AnchorShape) (setq PtEnd Data))
							(setq Shape (TraslateShape Shape PtStart PtEnd))
							(redraw)
							(GraphicsMove Shape 1)
							(PolarRuler PtEnd RadiusRule)
						(if (not AnchorShape) (setq PtStart Data))
					)
					; Left click mouse
					((and (= Code 3) (listp Data)) 
						(redraw)
						(DeletePrintData)
						(setq Loop nil)
					)
				)
			)
		)
	)
)
;
;
;
(defun DinamicRotateLowGraphics (EnameShape AnchorShape StartAngle / *error* PrintData DeletePrintData
																	ColorShape StepRotate Loop StepAngle
																	BoxEname PtStart PtEnd PointData RadiusRule ViewSize_htxt Shape msgLst
																	Gr Code Data
																	Rtn
																	)


	(defun *error* (msg)
		(princ msg)
		(DeletePrintData)
		(DeletedHatchEasyCut)
		(redraw)
		(princ)
    )
	;
	(defun PrintData (info pstart htesto / pglo offsetx offsety)
		
		(DeleteEntity (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 8 $LayerDinamicInfoEasyCut)))))
 
 
		(setq 	offsetx (*  htesto 2.0)
				offsety (*  htesto 2.0)
				pglo (trans (list (+ (car pstart) offsetx) (+ (cadr pstart) offsety)) 1 0)
				info (strcat "\n{\\Fromans|c0;\\W0.8;\\C1;Rotazione\t\\C252;" info)
				info 	(entmakex (list
                                (cons 0 "MTEXT")                              
                                (cons 100 "AcDbEntity")
                                (cons 100 "AcDbMText")
                                (cons 8   $LayerDinamicInfoEasyCut)
                                (cons 1  info)
                                (cons 10 pglo)
                                (cons 40 htesto)
                                (cons 50 0.0)
                                (cons 62 71)
                                (cons 71 1)
                                (cons 90 3)
								(cons 63 9)
								(cons 421 13158600)
								(cons 441 9434636)
                                ;(cons 63 256)
                                ;(cons 45 1.2)
                                (cons 210 (list 0.0 0.0 1.0))
                                (cons 11 (list 1.0 0.0 0.0))
                            )
					)
		)
    )
	;
	(defun DeletePrintData (/ Sset nE)
		(DeleteEntity (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 8 $LayerDinamicInfoEasyCut)))))    
    )
	;
	; Main 
	;
	(setq ColorShape 	1)
	(setq StepRotate 	1.0)
	(setq Loop 			T)
	(setq StepAngle  	StartAngle)
	
	(if EnameShape
		(progn
			(setq BoxEname 		(BoundingBoxLstEname (list EnameShape)))
			(setq RadiusRule  	(/ (distance (car BoxEname) (caddr BoxEname)) 2.0))
			(setq PtStart 		(car (div (car (car BoxEname)) (cadr (car BoxEname)) (car (caddr BoxEname)) (cadr (caddr BoxEname)) 1)))
			(setq PointData 	(list (+ (car PtStart) RadiusRule) (cadr PtStart))) 
			(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
			(setq Shape 		(DiscretizeShape EnameShape))
			

			(setq msgLst (strcat "\n[Tab]90" (chr 176) " [<]45" (chr 176) " [>]-45" (chr 176)  " [+]" (rtos StepRotate 2 1) (chr 176) " [-]" (rtos StepRotate 2 1) (chr 176) " [Enter]" " [E]xit"))
			(princ msgLst)	
			
			;(GraphicsRotationTraslate Shape PtStart PtStart StepAngle 1)	
			;(PolarRuler PointData RadiusRule)
			;(PrintData (rtos (* (/ StepAngle pi) 180.0) 2 5) PointData ViewSize_htxt)
			
			(while Loop

				(setq Gr (grread 't 15 1) Code (car Gr) Data (cadr Gr))
				
				(cond
					((= Code 2)
						(cond
							;Tab key
							((= Data 009) 						
								(setq StepAngle (+ StepAngle (/ (* 90.0 pi) 180.0)))
								(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))
							)
							;<
							((= Data 060)						
								(setq StepAngle (+ StepAngle (/ (* 45.0 pi) 180.0)))
								(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))
							)
							;>
							((= Data 062)						
								(setq StepAngle (+ StepAngle (/ (* (- 0.0 45.0) pi) 180.0)))
								(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))
							)
							; +
							((= Data 043)						
								(setq StepAngle (+ StepAngle (/ (* StepRotate pi) 180.0)))
								(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))
							)
							; -
							((= Data 045)	
								(setq StepAngle (- StepAngle (/ (* StepRotate pi) 180.0)))
								(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))						
							)
							; Enter
							((= Data 013)
								(redraw)
								(DeletePrintData)
								(if AnchorShape	
									(setq Rtn (list PtStart StepAngle))
									(setq Rtn (list PtEnd   StepAngle))
								)
								(setq Loop nil)
							)
						)
					)
					; Mouse rolling
					((and (= Code 5) (listp Data))
						(setq PtEnd Data)
						(redraw)
						
						(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
						
						(if (not AnchorShape)
							(progn
								(GraphicsRotationTraslate Shape PtStart PtEnd StepAngle 1)				
								(PolarRuler PtEnd RadiusRule)
								(setq PointData (list (+ (car PtEnd) RadiusRule) (cadr PtEnd)))
								(PrintData (rtos (* (/ StepAngle pi) 180.0) 2 5) PointData ViewSize_htxt)
							)
							(progn
								(GraphicsRotationTraslate Shape PtStart PtStart StepAngle 1)				
								(PolarRuler PtStart RadiusRule)
								(PrintData (rtos (* (/ StepAngle pi) 180.0) 2 5) PointData ViewSize_htxt)
							)
						)
					)
					; Left click mouse
					((and (= Code 3) (listp Data)) 
						(redraw)
						(DeletePrintData)
						(if AnchorShape	
							(setq Rtn (list PtStart StepAngle))
							(setq Rtn (list Data    StepAngle))
						)
						(setq Loop nil)
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
;(GetSheetBoundary (list 800.0 475.0) 1600.0 950.0 0.0)
;(setq PtInsert (list 800.0 475.0))
;(setq WidthShape 1600.0)
;(setq HeightShape 950.0)
;(setq AngleRotation 0.0)
;
(defun GetSheetBoundary (PtInsert WidthShape HeightShape AngleRotation / 
						 XMinVer YMinVer XMaxVer YMaxVer EnameShape EnameSheet ResultSheet Sheet Shape LstDummy Rtn)
	;
	; main
	;
	(if (and PtInsert WidthShape HeightShape AngleRotation)
		(progn
			(setq XMinVer (- (nth 0 PtInsert) (/ WidthShape 2.0))
				  YMinVer (- (nth 1 PtInsert) (/ HeightShape 2.0))
				  XMaxVer (+ (nth 0 PtInsert) (/ WidthShape 2.0))
				  YMaxVer (+ (nth 1 PtInsert) (/ HeightShape 2.0))
			)
			(setq EnameShape (MakePolyline  (list (list XMinVer YMinVer)
												  (list XMaxVer YMinVer)
												  (list XMaxVer YMaxVer)
												  (list XMinVer YMaxVer)
											) T )
			)
			(vla-Rotate (vlax-ename->vla-object EnameShape) (vlax-3d-point PtInsert) AngleRotation)
			
			(if (setq EnameSheet (LM:ss->ent (ssget "_CP" (DiscretizeShape EnameShape) (list (list -3 (list $RgpSheet))))))
				(setq ResultSheet (BooleanShape (car EnameSheet) 1 EnameShape))
			)
			(if (not ResultSheet)
				(setq ResultSheet (list EnameShape))
				(DeleteEntity (list EnameShape))
			)
			
			(foreach Sheet ResultSheet
				(setq LstDummy (append LstDummy (list Sheet)))
				(foreach Shape  (LM:ss->ent (ssget "_CP" (DiscretizeShape Sheet) (list (list -3 (list $RgpShape)))))
					(setq LstDummy (append LstDummy (list Sheet)))
					(setq Sheet (BooleanShape Sheet 2 Shape))
					(setq Sheet (car Sheet))
				)
				(setq Rtn (cons Sheet Rtn)) 
			)
			(foreach itm LstDummy
				(if (not (member itm Rtn)) (DeleteEntity (list itm))) 
			)
		)
	)
	Rtn
)
;
;
;
(defun BooleanShape (Ename1 Action Ename2 / Go1 Go2 EnameRegion1 EnameRegion2 Go1 Go2 Rtn)

	;acUnion			0
	;acIntersection		1
	;acSubtraction		2
	
	(if (and (= (type Ename1) 'ENAME) (= (type Ename2) 'ENAME) Action)
		(progn
			(cond 
				((= (vlax-get-property (vlax-ename->vla-object Ename1) 'ObjectName) "AcDbPolyline")
					(if (= (vla-get-closed (vlax-ename->vla-object Ename1)) :vlax-true)
						(setq Go1 T)
					)
				)
				((= (vlax-get-property (vlax-ename->vla-object Ename1) 'ObjectName) "AcDbCircle")
					(setq Go1 T)
				)
				((= (vlax-get-property (vlax-ename->vla-object Ename1) 'ObjectName) "AcDbEllipse")
					(setq Go1 T)
				)
			)
			
			(cond 
				((= (vlax-get-property (vlax-ename->vla-object Ename2) 'ObjectName) "AcDbPolyline")
					(if (= (vla-get-closed (vlax-ename->vla-object Ename2)) :vlax-true)
						(setq Go2 T)
					)
				)
				((= (vlax-get-property (vlax-ename->vla-object Ename2) 'ObjectName) "AcDbCircle")
					(setq Go2 T)
				)
				((= (vlax-get-property (vlax-ename->vla-object Ename2) 'ObjectName) "AcDbEllipse")
					(setq Go2 T)
				)
			)
		)
	)
	
	(if (and Go1 Go2)
		(progn
			(setq EnameRegion1 (AddRegion Ename1))
			(setq EnameRegion2 (AddRegion Ename2))
			
			(vla-boolean (vlax-ename->vla-object EnameRegion1) Action (vlax-ename->vla-object EnameRegion2))
			
			(cond
				((= Action 0)
					(setq Rtn (RegionToPolyLine EnameRegion1 T))
				)
				((= Action 1)
					(if (entget EnameRegion1) 
						(setq Rtn (RegionToPolyLine EnameRegion1 T))
					)
				)
				((= Action 2)
					(if (entget EnameRegion1) 
						(setq Rtn (RegionToPolyLine EnameRegion1 T))
					)
				)
			)
		)
	)
	Rtn
)
;