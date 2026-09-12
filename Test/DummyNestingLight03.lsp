; programma interessante NESTED MOVE (lee mac)
;
;
;
(defun CtlStep ()
	(if (not PrgCtrl$) (setq PrgCtrl$ 1))
	(princ (strcat "\n --- Step -->" (LM:rtos PrgCtrl$ 2 0) " <---"))
	(setq PrgCtrl$ (1+ PrgCtrl$))
)
;
;
;
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
									Shape PtStart PtEnd Rotation Mirror
									Rtn PosData
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
	(if EnameShape
		(progn

			(setq Shape 	  (DiscretizeShape EnameShape))
			(setq PtStart     (EnameCenter EnameShape))
			(setq Rtn         (DinamicPositionLowGraphics Shape nil))	; Shape PtEnd Rotation Mirror
			(setq Shape 	  (nth 0 Rtn))
			(setq PtEnd		  (nth 1 Rtn))
			(setq Rotation	  (nth 2 Rtn))
			(setq Mirror      (nth 3 Rtn))
		   ; Zoom To .............
			(if (ssget "_CP" Shape)
					(setq PosData (entsel "<Allineato a ...>"))
			)
			(if PosData
				(DinamicAlign (car PosData) EnameShape $MargineAccosto (cadr PosData) Rotation)
				(CopyShape EnameShape (list PtStart PtEnd Rotation Mirror))
			)
		)
	)	
)
;
;
;
(defun GraphicsShape (LstPoint ColorRotation / LstPt)
	;
	(if (and LstPoint ColorRotation)
		(DrawLowGraphics (append LstPoint (list (nth 0 LstPoint))) ColorRotation)
	)
)
;
;
;
(defun DinamicPositionLowGraphics (Shape AnchorShape / *error* PrintData DeletePrintData
													ColorShape StepRotate Loop StepAngle
													MinX MaxX MinY MaxY
													RadiusRule PtStart PtEnd PointData ViewSize_htxt Mirror
													msgLst Loop Gr Code Data Rtn
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
	
	(if Shape
		(progn
			(setq MinX (apply 'min (mapcar 'car  Shape)))
			(setq MaxX (apply 'max (mapcar 'car  Shape)))
			(setq MinY (apply 'min (mapcar 'cadr Shape)))
			(setq MaxY (apply 'max (mapcar 'cadr Shape)))		
			(setq RadiusRule  	 (/ (distance (list MinX MinY) (list MaxX MaxY)) 2.0))
			(setq PtStart 		 (list (/ (+ MinX MaxX) 2.0) (/ (+ MinY MaxY) 2.0)))
			(setq PointData 	 (list (+ (car PtStart) RadiusRule) (cadr PtStart)))
			(setq ViewSize_htxt  (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
			(setq Mirror 	 nil)
			
			(if AnchorShape
				(setq PtEnd PtStart)
			)

			(setq msgLst (list 	(strcat "[Tab]90" (chr 176) 
										" | [<]45" (chr 176) " | [>]-45" (chr 176)  
										" | [+]" (rtos StepRotate 2 1) (chr 176) " | [-]" (rtos StepRotate 2 1) (chr 176) 
										" | [V]ista posteriore | [Enter] | [E]xit")
								(strcat "[Tab]90" (chr 176) 
										" | [<]45" (chr 176) " | [>]-45" (chr 176)  
										" | [+]" (rtos StepRotate 2 1) (chr 176) " | [-]" (rtos StepRotate 2 1) (chr 176) 
										" | [V]ista anteriore | [Enter] | [E]xit")
						 ))
										
			(princ (strcat "\n" (car msgLst)))	
			
		
			(while Loop

				(setq Gr (grread 't 15 1) Code (car Gr) Data (cadr Gr))
				
				(cond
					((= Code 2)
						(cond
							;Tab key
							((= Data 009) 						
								(setq StepAngle (+ StepAngle (/ (* 90.0 pi) 180.0)))
								(if (equal (ReconditionAngle StepAngle) 0.0 1e-8) (setq StepAngle 0.0))
								(if (not AnchorShape)
									(setq Shape (RotatePoint Shape PtEnd   (/ (* 90.0 pi) 180.0)))
									(setq Shape (RotatePoint Shape PtStart (/ (* 90.0 pi) 180.0)))
								)
							)
							;<45°
							((= Data 060)						
								(setq StepAngle (+ StepAngle (/ (* 45.0 pi) 180.0)))
								(if (equal (ReconditionAngle StepAngle) 0.0 1e-8) (setq StepAngle 0.0))
								(if (not AnchorShape)
									(setq Shape (RotatePoint Shape PtEnd   (/ (* 45.0 pi) 180.0)))
									(setq Shape (RotatePoint Shape PtStart (/ (* 45.0 pi) 180.0)))
								)
							)
							;>-45°
							((= Data 062)						
								(setq StepAngle (+ StepAngle (/ (* (- 0.0 45.0) pi) 180.0)))
								(if (equal (ReconditionAngle StepAngle) 0.0 1e-8) (setq StepAngle 0.0))
								(if (not AnchorShape)
									(setq Shape (RotatePoint Shape PtEnd   (/ (* (- 0.0 45.0) pi) 180.0)))
									(setq Shape (RotatePoint Shape PtStart (/ (* (- 0.0 45.0) pi) 180.0)))
								)
							)
							; +
							((= Data 043)						
								(setq StepAngle (+ StepAngle (/ (* StepRotate pi) 180.0)))
								(if (equal (ReconditionAngle StepAngle) 0.0 1e-8) (setq StepAngle 0.0))
								(if (not AnchorShape)
									(setq Shape (RotatePoint Shape PtEnd   (/ (* StepRotate pi) 180.0)))
									(setq Shape (RotatePoint Shape PtStart (/ (* StepRotate pi) 180.0)))
								)
							)
							; -
							((= Data 045)	
								(setq StepAngle (- StepAngle (/ (* StepRotate pi) 180.0)))
								(if (equal (ReconditionAngle StepAngle) 0.0 1e-8) (setq StepAngle 0.0))						
								(if (not AnchorShape)
									(setq Shape (RotatePoint Shape PtEnd   (/ (* (- 0.0 StepRotate) pi) 180.0)))
									(setq Shape (RotatePoint Shape PtStart (/ (* (- 0.0 StepRotate) pi) 180.0)))
								)
							)
							;V v
							((member Data '(086 118))
							
								(if Mirror
									(progn
										(princ (strcat "\r" (car msgLst)))
										(setq Mirror nil)
									)
									(progn
										(princ (strcat "\r" (cadr msgLst)))										
										(setq Mirror T)
									)
								)
								
								(if (not AnchorShape)
									(setq Shape (MirrorPoint Shape PtEnd   (/ pi 2.0)))
									(setq Shape (MirrorPoint Shape PtStart (/ pi 2.0)))
								)
							)
							; Enter
							((= Data 013)
								(redraw)
								(DeletePrintData)
								(setq Rtn (list Shape PtEnd StepAngle Mirror))
								(setq Loop nil)
							)
						)
					)
					; Mouse rolling
					((and (member Code '(5 3)) (listp Data))
						
						(setq PtEnd Data)
						
						(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
						
						(if (not AnchorShape) (setq PtEnd Data))
							(setq Shape (TraslatePoint Shape PtStart PtEnd))						
							(redraw)
							(GraphicsShape Shape 1)
							(PolarRuler PtEnd RadiusRule)
							(setq PointData (list (+ (car PtEnd) RadiusRule) (cadr PtEnd)))
							(PrintData (rtos (* (/ StepAngle pi) 180.0) 2 5) PointData ViewSize_htxt)
						(if (not AnchorShape) (setq PtStart Data))
					
						; Left click mouse
						
						(if (= Code 3)
							(progn
								(redraw)
								(DeletePrintData)
								(setq Rtn (list Shape PtEnd StepAngle Mirror))
								(setq Loop nil)
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
;
;
(defun DinamicRotateLowGraphics (EnameShape StepRotate / *error* PrintData DeletePrintData RefreshGraphics
														ColorShape StepRotate Loop StepAngle ViewCtr
														BoxEname PtRotate ViewSize_htxt msgLst ObjCopy
														gr code data NewViewCtr Go)


	(defun *error* (msg)
		(princ msg)
		(vla-delete ObjCopy)
		(DeletePrintData)
		(DeletedHatchEasyCut)
		(redraw)
		(princ)
    )
	;
	(defun PrintData (info pstart htesto / pglo offsetx offsety)
	
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
		;(redraw)
		(setq Sset (ssget "_X" (list (cons 67 0) (cons 8 $LayerDinamicInfoEasyCut)))); selection set for Entities to delete
        (if Sset
		    (repeat (setq nE (sslength Sset))
               (DeleteEntity (list (ssname Sset (setq nE (1- nE)))))
			)
        )		
    )
	;
	(defun RefreshGraphics (Shape PtRotate AngleRotate Htxt PtData)
	
		(if (and EnameShape PtRotate AngleRotate)
			(progn
				(vla-rotate Shape (vlax-3d-point PtRotate) AngleRotate)
				(vla-highlight Shape :vlax-true)
				(DeletePrintData)
				(PrintData (rtos (* (/ AngleRotate pi) 180.0) 2 5) PtData Htxt)
			)
		)
	)
	;
	; Main 
	;
	(setq ColorShape 	1)
	;(setq StepRotate 	1.0)
	(setq Loop 			T)
	(setq StepAngle 	0.0)
	(setq ViewCtr 		(getvar "viewctr"))
	
	(if EnameShape
		(progn
			(setq BoxEname 		(BoundingBoxLstEname (list EnameShape)))
			(setq PtRotate 		(car (div (car (car BoxEname)) (cadr (car BoxEname)) (car (caddr BoxEname)) (cadr (caddr BoxEname)) 1)))
			(setq RadiusRule  	(/ (distance (car BoxEname) (caddr BoxEname)) 2.0))
			(setq PtData		(list (+ (car PtRotate) RadiusRule) (cadr PtRotate))) 
			(setq ViewSize_htxt     (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
		
			(PolarRuler PtRotate RadiusRule)
			(PrintData (rtos StepAngle 2 5) PtData ViewSize_htxt)

			(setq msgLst (strcat "\n[Tab]90" (chr 176) " [<]45" (chr 176) " [>]-45" (chr 176)  " [+]" (rtos StepRotate 2 1) (chr 176) " [-]" (rtos StepRotate 2 1) (chr 176) " [Enter]ok" " [Esc]esci"))
			(princ msgLst)	
			(setq ObjCopy (vla-copy (vlax-ename->vla-object EnameShape)))
			(vla-highlight ObjCopy :vlax-true)
			
			(while Loop

				(setq gr (grread 't 15 1) code (car gr) data (cadr gr))
				;(princ "\n") (princ gr)
				(setq go nil)
				(cond
				
					((and (= code 2) (= data 9))   				; ----------------------------------------> Tab key						
						(setq StepAngle (+ StepAngle (/ (* 90.0 pi) 180.0))) (setq Go T)
						(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))
					)	
					((and (= code 2) (= data 60))   				; ----------------------------------------> <						
						(setq StepAngle (+ StepAngle (/ (* 45.0 pi) 180.0))) (setq Go T)
						(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))
					)
					((and (= code 2) (= data 62))   				; ----------------------------------------> >						
						(setq StepAngle (+ StepAngle (/ (* (- 0.0 45.0) pi) 180.0))) (setq Go T)
						(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))
					)
					((and (= code 2) (= data 43))  				; ----------------------------------------> press +						
						(setq StepAngle (+ StepAngle (/ (* StepRotate pi) 180.0))) (setq Go T)
						(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))
					)
					((and (= code 2) (= data 45))  				; ----------------------------------------> press -	
						(setq StepAngle (- StepAngle (/ (* StepRotate pi) 180.0))) (setq Go T)
						(if (> StepAngle (* 2.0 pi)) (setq StepAngle (- StepAngle (* 2.0 pi))))						
					)
					((and (= code 5) (listp data)) 				; ----------------------------------------> Mouse rolling
						(vla-highlight ObjCopy :vlax-true)
						(setq NewViewCtr (getvar "viewctr"))			
						(if (not (equal NewViewCtr ViewCtr))	; ----------------------------------------> Zoom
							(progn
								(redraw)
								(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
								(DeletePrintData)
								(PrintData (rtos (* (/ StepAngle pi) 180.0) 2 5) PtData ViewSize_htxt)
								(PolarRuler PtRotate (/ (distance (car BoxEname) (caddr BoxEname)) 2.0))
							)
						)
						(setq ViewCtr NewViewCtr)
					)
					((and (= code 2) (= data 13))   			; ----------------------------------------> Enter -	
						(redraw)
						(vla-delete ObjCopy)
						(DeletePrintData)
						(setq Rtn (list PtRotate StepAngle))
						(setq Loop nil)
					)
				)
				
				(if Go
					(progn
						(vla-delete ObjCopy)
						(setq ObjCopy (vla-copy (vlax-ename->vla-object EnameShape)))
						(RefreshGraphics ObjCopy PtRotate StepAngle ViewSize_htxt PtData)
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
(defun OverlayShape (EnameSheet EnameShape / IncidenceAngle CheckOverlayInterference 
								   		     CheckIntersection TestOverlay00 TestOverlay01 TestOverlay02 TestOverlay03 TestOverlay04
											 Rtn)
	
	;
	;
	;
	(defun IncidenceAngle (Pt1Start Pt1End Pt2Start Pt2End)
	
		(setq Ang1 (angle Pt1Start Pt1End))
		(setq Ang2 (angle Pt2Start Pt2End))
		(- Ang1 Ang2)
	
	)
	;
	;
	;
	(defun CheckOverlayInterference (EnameShape EnameSheet PtStart PtEnd Rotate / CopyShape Rtn)
						
		(if (and EnameShape EnameSheet PtStart PtEnd Rotate)
			(progn
				(setq CopyShape (vlax-vla-object->ename (vla-Copy (vlax-ename->vla-object EnameShape))))
				(vla-move (vlax-ename->vla-object CopyShape) (vlax-3d-point PtStart) (vlax-3d-point PtEnd))
				(vla-Rotate (vlax-ename->vla-object CopyShape) (vlax-3d-point PtEnd) Rotate)
										
				(if (< (CheckIntersection EnameSheet CopyShape) 0)
					(setq Rtn T)
				)
				(DeleteEntity (list CopyShape))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun CheckIntersection (Ename1 Ename2)
			(vlax-safearray-get-u-bound 
					(vlax-variant-value 
							(vla-IntersectWith (vlax-ename->vla-object Ename1) 
											   (vlax-ename->vla-object Ename2)
											   acExtendNone)) 1)
	)
	;
	;
	;
	(defun TestOverlay00 (EnameSheet EnameShape / LocalDimBoxSheet LocalDimBoxShape CenterSheet CenterShape Rtn)
	
		(if (and EnameSheet EnameShape)
			(progn
				(setq LocalDimBoxSheet (ucs-bbox EnameSheet))
				(setq LocalDimBoxShape (ucs-bbox EnameShape))
				(setq CenterSheet (list (/ (+ (nth 0 (nth 0 LocalDimBoxSheet)) (nth 0 (nth 1 LocalDimBoxSheet))) 2.0)
								        (/ (+ (nth 1 (nth 0 LocalDimBoxSheet)) (nth 1 (nth 1 LocalDimBoxSheet))) 2.0)
								  )
				)
				(setq CenterShape (list (/ (+ (nth 0 (nth 0 LocalDimBoxShape)) (nth 0 (nth 1 LocalDimBoxShape))) 2.0)
										(/ (+ (nth 1 (nth 0 LocalDimBoxShape)) (nth 1 (nth 1 LocalDimBoxShape))) 2.0)
								  )
				)
				

				(if (CheckOverlayInterference EnameShape EnameSheet CenterShape CenterSheet 0.0)
					(setq Rtn (list (list 0.0 CenterShape CenterSheet)))
					(if (CheckOverlayInterference EnameShape EnameSheet CenterShape CenterSheet (/ (* 90.0 pi) 180.0))
						(setq Rtn (list (list (/ (* 90.0 pi) 180.0) CenterShape CenterSheet)))
					
					)
				)
				
			)
		)
		Rtn
	)
	;
	;
	;
	(defun TestOverlay01 (EnameSheet EnameShape / GravitySheet GravityShape Rtn)
	
		(if (and EnameSheet EnameShape)
			(progn
				(setq GravitySheet (GetGravityCenter EnameSheet))
				(setq GravityShape (GetGravityCenter EnameShape))
				
				(if (and GravitySheet GravityShape)
					(progn 
						(if (CheckOverlayInterference EnameShape EnameSheet GravityShape GravitySheet 0.0)
							(setq Rtn (list (list 0.0 GravityShape GravitySheet)))
							(if (CheckOverlayInterference EnameShape EnameSheet CenterShape CenterSheet (/ (* 90.0 pi) 180.0))
								(setq Rtn (list (list (/ (* 90.0 pi) 180.0) CenterShape CenterSheet)))
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
	(defun TestOverlay02 (EnameSheet EnameShape / GravitySheet GravityShape
												  OffsetEnameShape LstCoordShape LstCoordSheet
												  ContaCoordShape ContaCoordSheet
												  Pt1Master Pt2Master
												  Pt1Slave Pt2Slave AngRotate Rtn)
			
		(if (and EnameSheet EnameShape)
			(progn
				
				(setq GravitySheet (GetGravityCenter EnameSheet))
				(setq GravityShape (GetGravityCenter EnameShape))	
				
				(setq OffsetEnameShape  (OffsetShape EnameShape 0.5))
				(setq LstCoordShape  	(LM:lwvertices (entget OffsetEnameShape)))
				(setq LstCoordSheet  	(LM:lwvertices (entget EnameSheet)))
				(setq LstCoordShape 	(append LstCoordShape (list (nth 0 LstCoordShape))))
				(setq LstCoordSheet 	(append LstCoordSheet (list (nth 0 LstCoordSheet))))
				
				(DeleteEntity (list OffsetEnameShape))
				(setq ContaCoordSheet 0)
			
				(repeat (- (length LstCoordSheet) 1)
				
					(setq ContaCoordShape 0)
					(setq Pt1Master 	(cdr (assoc 10 (nth (+ 0 ContaCoordSheet) LstCoordSheet))))
					(setq Pt2Master 	(cdr (assoc 10 (nth (+ 1 ContaCoordSheet) LstCoordSheet))))
							
					(repeat (- (length LstCoordShape) 1)
						
						(setq Pt1Slave 	 (cdr (assoc 10 (nth (+ 0 ContaCoordShape) LstCoordShape))))
						(setq Pt2Slave 	 (cdr (assoc 10 (nth (+ 1 ContaCoordShape) LstCoordShape))))
						
						(setq AngRotate 	(IncidenceAngle Pt1Master Pt2Master Pt1Slave Pt2Slave))
						
						(if (CheckOverlayInterference EnameShape EnameSheet GravityShape GravitySheet AngRotate)
							(setq Rtn (append Rtn (list (list AngRotate GravityShape GravitySheet))))
						)
						(setq ContaCoordShape (1+ ContaCoordShape))
					)
					(setq ContaCoordSheet (1+ ContaCoordSheet))		
				)
			)
		)		
		Rtn
	)
	;
	;	
	;
	(defun TestOverlay03 (EnameSheet EnameShape StepAngle / GravitySheet GravityShape AngScan Rtn)
			
		
		(setq StepAngle (/ (* StepAngle pi) 180.0))
		
		(if (and EnameSheet EnameShape)
			(progn
				(setq GravitySheet (GetGravityCenter EnameSheet))
				(setq GravityShape (GetGravityCenter EnameShape))
				
				(if (and GravitySheet GravityShape)
					(progn
						
						(setq AngScan 0.0)
						(while (<= AngScan (* 2.0 pi))
						
							(if (CheckOverlayInterference EnameShape EnameSheet GravityShape GravitySheet AngScan)
								(setq Rtn (append Rtn (list (list AngScan GravityShape GravitySheet))))
							)
							
							(setq AngScan (+ AngScan StepAngle))
							
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
	(defun TestOverlay04 (EnameSheet EnameShape StepDist / OffsetEnameShape LstCoordShape LstCoordSheet
														   ContaCoordShape ContaCoordSheet
														   PtNew NdivSeg PtDivMaster ItmDiv
														   Pt1Master Pt2Master
													       Pt1Slave Pt2Slave AngRotate Rtn)
			
		(if (and EnameSheet EnameShape StepDist)
			(progn
								
				(setq OffsetEnameShape  (OffsetShape EnameShape 0.5))
				(setq LstCoordShape  	(LM:lwvertices (entget OffsetEnameShape)))
				;(setq LstCoordShape  	(LM:lwvertices (entget EnameShape)))
				(setq LstCoordSheet  	(LM:lwvertices (entget EnameSheet)))

				(princ "\n")
				(princ "\nPercorrenza Shape ") (princ (ClockWeisEname EnameShape))
				(princ "\nPercorrenza Sheet ") (princ (ClockWeisEname EnameSheet))
				(princ "\n")


				(setq LstCoordShape 	(append LstCoordShape (list (nth 0 LstCoordShape))))
				(setq LstCoordSheet 	(append LstCoordSheet (list (nth 0 LstCoordSheet))))
				
				
				(DeleteEntity (list OffsetEnameShape))
				(setq ContaCoordSheet 0)
			
				(repeat (- (length LstCoordSheet) 1)
				
					;(princ "\nMaster--->") (princ ContaCoordSheet)
					
					(setq ContaCoordShape 0)
					(setq Pt1Master 	(cdr (assoc 10 (nth (+ 0 ContaCoordSheet) LstCoordSheet))))
					(setq Pt2Master 	(cdr (assoc 10 (nth (+ 1 ContaCoordSheet) LstCoordSheet))))
							
					;(princ "\nP1 Master ") (princ Pt1Master)
					;(princ "\nP2 Master ") (princ Pt2Master)
						
					(repeat (- (length LstCoordShape) 1)
						
						;(princ "\nSlave--->") (princ ContaCoordShape)
														
						(setq Pt1Slave 	 (cdr (assoc 10 (nth (+ 0 ContaCoordShape) LstCoordShape))))
						(setq Pt2Slave 	 (cdr (assoc 10 (nth (+ 1 ContaCoordShape) LstCoordShape))))
						
						
						;(princ "\nP1 Slave ") (princ Pt1Slave)
						;(princ "\nP2 Slave ") (princ Pt2Slave)
						
						(if (>= (distance Pt1Master Pt2Master) (distance Pt1Slave Pt2Slave))
							(progn
								(setq AngRotate 	(IncidenceAngle Pt1Master Pt2Master Pt1Slave Pt2Slave))
								;(princ "\n StepDist ") (princ StepDist)
								
								(setq PtNew 		(prol (nth 0 Pt1Master) (nth 1 Pt1Master)
														  (nth 0 Pt2Master) (nth 1 Pt2Master) (* -1.0 (distance Pt1Slave Pt2Slave))))
								(setq NdivSeg   	(fix (/ (distance Pt1Master PtNew) StepDist)))
								(setq PtDivMaster   (div (nth 0 Pt1Master) (nth 1 Pt1Master) (nth 0 PtNew) (nth 1 PtNew)  NdivSeg))
								(setq PtDivMaster	(cons Pt1Master PtDivMaster))
								(setq PtDivMaster	(append PtDivMaster (list PtNew)))
								;(princ "\n Rotazione ") (princ (* (/ AngRotate pi) 180.0))
														
								(foreach ItmDiv PtDivMaster
								
									(if (CheckOverlayInterference EnameShape EnameSheet Pt1Slave ItmDiv AngRotate)
										(setq Rtn (append Rtn (list (list AngRotate Pt1Slave ItmDiv))))
									)
								)
							)
						)
						
						(setq AngRotate 	(IncidenceAngle Pt1Master Pt2Master Pt1Slave Pt2Slave))
						(setq NdivSeg   	(fix (/ (distance Pt1Master Pt2Master) StepDist)))
						(if (> NdivSeg 0)
							(progn
								(setq PtDivMaster   (div (nth 0 Pt1Master) (nth 1 Pt1Master) (nth 0 Pt2Master) (nth 1 Pt2Master) NdivSeg))
								(setq PtDivMaster	(cons Pt1Master PtDivMaster))
								(setq PtDivMaster	(append PtDivMaster (list Pt2Master)))
								(foreach ItmDiv PtDivMaster
									(if (CheckOverlayInterference EnameShape EnameSheet Pt1Slave ItmDiv AngRotate)
										(setq Rtn (append Rtn (list (list AngRotate Pt1Slave ItmDiv))))
									)
								)
							)
						)
						
						(setq ContaCoordShape (1+ ContaCoordShape))
					)
					(setq ContaCoordSheet (1+ ContaCoordSheet))		
				)
			)
		)		
		Rtn
	)
	;
	; Main
	;
	(if (and EnameSheet EnameShape)
		(progn
		
			(setq SheetLightWeight (nth 0 (CheckPoly EnameSheet)))
			(setq ShapeLightWeight (nth 0 (CheckPoly EnameShape)))
			
			(if (/= SheetLightWeight ShapeLightWeight)
				(RevLwpline EnameSheet)
			)
			(setq Rtn nil)
			(if (not Rtn) (progn (princ "\n--> TestOverlay00") (setq Rtn (TestOverlay00 EnameSheet EnameShape))))
			(if (not Rtn) (progn (princ "\n--> TestOverlay01") (setq Rtn (TestOverlay01 EnameSheet EnameShape))))
			;(if (not Rtn) (progn (princ "\n--> TestOverlay02") (setq Rtn (TestOverlay02 EnameSheet EnameShape))))
			;(if (not Rtn) (progn (princ "\n--> TestOverlay03") (setq Rtn (TestOverlay03 EnameSheet EnameShape 1.0))))
			(if (not Rtn) (progn (princ "\n--> TestOverlay04") (setq Rtn (TestOverlay04 EnameSheet EnameShape 10.0))))
			
		)
	)
	Rtn
)
;
;
;