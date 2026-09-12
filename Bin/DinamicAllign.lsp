;
;
(defun GetAngleShape (EnameShape / GetAng01 GetAng02
									 LstCo Pt Num Ang0 Ang1 Ang2 Pmid0 Pmid1 Pmid2 Rtn)

	(defun GetAng01 (Dist_A Dist_B Dist_C)
		(if (and Dist_A Dist_B Dist_C)
			(acos (/ (- (+ (* Dist_B Dist_B) (* Dist_C Dist_C)) (* Dist_A Dist_A)) (* 2.0 Dist_B Dist_C)))
		)
	)
	;
	(defun GetAng02 (PtA PtB PtC)
		(if (and PtA PtB PtC)
			(GetAng01 (distance PtA PtC) (distance PtA PtB) (distance PtB PtC))
		)
	)
	; Main
	(if EnameShape
		;(if (setq LstCo (DiscretizeShape EnameShape))
		(if (setq LstCo (DiscretizeShapeNoControl EnameShape))
			(progn
				
				(setq Pt (LM:ConvexHull (append LstCo (list (car LstCo)))))
				
				(if (not (LM:ListClockwise-p Pt))
					(setq Pt (reverse Pt))
				)

				(setq Num 0)
				
				(repeat (length Pt)
					;(getstring (strcat "< " (LM:rtos Num 2 0) " >"))
					(cond 
						((= Num 0)
							;(getstring "< caso 0 >")
							(setq Ang0 (GetAng02 (nth (- (length Pt) 1) Pt) (car  Pt) (cadr Pt)))
							(setq Ang1 (angle (car Pt) (cadr Pt)))
							(setq Ang2 (GetAng02 (car  Pt) (cadr Pt) (caddr Pt)))
							(setq Pmid0 (mid (nth (- (length Pt) 1) Pt) (car Pt)))
							(setq Pmid1 (mid (car Pt) (cadr Pt)))
							(setq Pmid2 (mid (cadr Pt) (caddr Pt)))

						)
						((= Num (- (length Pt) 2))
							;(getstring "< (- (length Pt) 2) >")
							(setq Ang0 (GetAng02 (nth (- Num 1) Pt) (nth Num Pt) (nth (+ Num 1) Pt)))
							(setq Ang1 (angle (nth Num Pt) (nth (+ Num 1) Pt)))
							(setq Ang2 (GetAng02 (nth Num Pt) (nth (+ Num 1) Pt) (car Pt)))
							(setq Pmid0 (mid (nth (- Num 1) Pt) (nth Num Pt)))
							(setq Pmid1 (mid (nth Num Pt) (nth (+ num 1) Pt)))
							(setq Pmid2 (mid (nth (+ Num 1) Pt) (car Pt)))
						)
						((= Num (- (length Pt) 1))
							;(getstring "< (- (length Pt) 1) >")
							(setq Ang0 (GetAng02 (nth (- Num 1) Pt) (nth Num Pt) (car Pt)))
							(setq Ang1 (angle (nth (+ Num 0) Pt) (car Pt)))
							(setq Ang2 (GetAng02 (nth Num Pt) (car Pt) (cadr Pt)))
							(setq Pmid0 (mid (nth (- Num 1) Pt) (nth Num Pt)))
							(setq Pmid1 (mid (nth Num Pt) (car Pt)))
							(setq Pmid2 (mid (car Pt) (cadr Pt)))
						)
						(t
							;(getstring "< caso T >")
							(setq Ang0 (GetAng02 (nth (- Num 1) Pt) (nth Num Pt) (nth (+ Num 1) Pt)))
							(setq Ang1 (angle (nth Num Pt) (nth (+ Num 1) Pt)))
							(setq Ang2 (GetAng02 (nth Num Pt) (nth (+ Num 1) Pt) (nth (+ Num 2) Pt)))
							(setq Pmid0 (mid (nth (- Num 1) Pt) (nth Num Pt)))
							(setq Pmid1 (mid (nth Num Pt) (nth (+ num 1) Pt)))
							(setq Pmid2 (mid (nth (+ Num 1) Pt) (nth (+ Num 2) Pt)))
						)
					)

					(setq Rtn (append Rtn (list (list Pmid0 Pmid1 Pmid2 Ang0 Ang1 Ang2))))

					(setq Num (1+ Num))
				)
			)
		)
	)
	Rtn
)
;
;
(defun MakeAnchorPoint (pt)
	(if pt
		(entmakex	(list	'(0 . "POINT")
							'(100 . "AcDbEntity")
							'(100 . "AcDbPoint")
							(cons 10 (trans pt 1 0))
							(list -3 (list $RgpTargetPoint '(1002 . "{") '(1002 . "}")))
					)
		)
	)
)
;
;
(defun RemoveAnchorPoint ()
		(DeleteEntity (LM:ss->ent (ssget "_X" (list (cons 0 "POINT") (list -3 (list $RgpTargetPoint))))))
)
;
;
(defun DefSideDinamicAlign (Ename / Rtn)

	(if Ename
		(cond
			((CheckIfEasyCutSheet Ename)
				(setq Rtn 1)
			)
			((= (GetTypeShape Ename) 1)
				(setq Rtn 2)
			)
			((= (GetTypeShape Ename) 2)
				(setq Rtn 1)
			)
		)
	)
	Rtn
)
;
;
(defun SniffStreet (DirectionPoint ExcludeEname / Radius Pt1 Pt2 itm LstData Rtn)
	
	(if DirectionPoint
		(progn
			(setq Radius (getvar 'aperture))
			(setq Pt1 	 (list (- (car DirectionPoint) Radius) (- (cadr DirectionPoint) Radius)))
			(setq Pt2 	 (list (+ (car DirectionPoint) Radius) (+ (cadr DirectionPoint) Radius)))
			(foreach itm (LM:ss->ent (ssget "_C" Pt1 Pt2 (list (list -3 (list (strcat $RgpSheet "," $RgpShape))))))
				(if (not (member itm ExcludeEname))
					(progn
						(setq Pprojection (vlax-curve-getclosestpointtoprojection itm DirectionPoint (list 0.0 0.0 1.0)))
						(setq LstData (append LstData (list (list (distance Pprojection DirectionPoint) itm))))
					)
				)
			)
			(if LstData
				(setq Rtn (cadr (car (vl-sort LstData (function (lambda (e1 e2)  (< (car e1) (car e2))))))))
			)
		)
	)
	Rtn
)
;
;
(defun CheckIntersectionObjects (EnameShape ExcludeEname / itm Rtn)
	(if EnameShape
		(progn
;			(setq Rtn (LM:ss->ent (ssget "_CP" (DiscretizeShape EnameShape) 
			(setq Rtn (LM:ss->ent (ssget "_CP" (DiscretizeShapeNoControl EnameShape) 
												(list (list -3 (list (strcat $RgpSheet "," $RgpShape "," $RgpTiggerOn "," $RgpTiggerOff)))))))
		    (foreach itm (append (list EnameShape) ExcludeEname)
				(setq Rtn (LM:RemoveOnce itm Rtn)) 
			)
		)
	)
	Rtn
)
;
;
(defun ChangeColorLstObj (LstObjShape Color / itm)
	(if Color
		(foreach itm LstObjShape
			(vla-put-color itm Color)
		)
	)
)
;
;
(defun RepositionShape (EnameSheet EnameShape LstOtherShape EnameAnchor PMove Border / Pprojection PAnchor AngRotate itm)
	
	(if (and EnameSheet EnameShape EnameAnchor PMove Border)
		(progn
			(setq Pprojection (vlax-curve-getclosestpointtoprojection EnameSheet PMove (list 0.0 0.0 1.0)))
			
			(if (not (equal PMove Pprojection 1e-8))
				(progn
					(setq PAnchor   (car (SetAnchor EnameSheet EnameShape PMove Border (DefSideDinamicAlign EnameSheet))))
					(setq AngRotate (ReconditionAngle (- (angle PAnchor Pprojection) (/ Pi 2.0))))
					
					(if (not (equal AngRotate AngRotate$))
						(progn
							(foreach itm (append (list EnameShape) (list EnameAnchor) LstOtherShape)
								(vla-rotate (vlax-ename->vla-object itm)  (vlax-3d-point PAnchor) (- AngRotate AngRotate$))
							)
							(setq AngRotate$ AngRotate)
						)
					)
					
					(foreach itm (append (list EnameShape) LstOtherShape (list EnameAnchor))
						(vla-move 	(vlax-ename->vla-object itm) 
									(vlax-3D-point (vlax-get (vlax-ename->vla-object EnameAnchor) 'coordinates)) 
									(vlax-3D-point PAnchor))
					)
				)
			)
		)
	)
)
;
;
(defun ImposeAlignShape (EnameSheet EnameShape LstOtherShape PMove Border / LstAngle Pprojection PAnchor EnameAnchor Num itm AngRot PtRot Rtn)
	
	(if (and EnameSheet EnameShape PMove Border)
		(progn
			(setq LstAngle 	  (GetAngleShape EnameShape))
			(setq Pprojection (vlax-curve-getclosestpointtoprojection EnameSheet PMove (list 0.0 0.0 1.0)))
			(if (not (equal PMove Pprojection 1e-8))
				(progn
					(setq PAnchor (SetAnchor EnameSheet EnameShape PMove Border (DefSideDinamicAlign EnameSheet)))
					;(RemoveAnchorPoint)
					;(setq EnameAnchor (MakeAnchorPoint PAnchor))
					(setq AngRotate$  (ReconditionAngle (- (angle (car PAnchor) Pprojection) (/ Pi 2.0))))
					
					(setq Num 0)
					(foreach itm LstAngle
						
						(setq AngRot (nth 4 itm))
						(setq PtRot  (nth 1 itm))
						(cond
							((not Rtn)
								(setq Rtn (list (- AngRotate$ AngRot) PtRot))
							)
							((<= (abs (- AngRot AngRotate$)) (abs (car Rtn)))
								(setq Rtn (list (- AngRotate$ AngRot) PtRot))
							)
						)
						(setq Num (1+ Num))
					)
					
					(foreach itm (append (list EnameShape) LstOtherShape)
						(vla-move 	(vlax-ename->vla-object itm) 
									(vlax-3D-point (cadr Rtn)) 
									(vlax-3D-point (car PAnchor)))
						(vla-rotate (vlax-ename->vla-object itm)  
									(vlax-3d-point (car PAnchor)) 
									(car Rtn))
					)
				)
			)
		)
	)
	PAnchor
)
;
;
(defun AlignShape (EnameSheet EnameShape LstOtherShape PMove Border ImposeRotation / Pt)
	
	(if (and EnameSheet EnameShape PMove Border)
		(cond 
			(ImposeRotation
				(RemoveAnchorPoint)
				(setq Pt (ExtraRotationShape EnameSheet EnameShape LstOtherShape PMove Border ImposeRotation))
			)
			(t
				(RemoveAnchorPoint)
				(setq Pt (ImposeAlignShape EnameSheet EnameShape LstOtherShape PMove Border))
			)
		)
	)
	(MakeAnchorPoint (car Pt))
)
;
;
(defun mid ( a b )
	;; Midpoint - Lee Mac
	;; Returns the midpoint of two points
    (mapcar (function (lambda ( a b ) (/ (+ a b) 2.0))) a b)
)
;
;
(defun ReconditionAngle (Ang)
	(if Ang
		(angle '(0.0 0.0) (polar '(0.0 0.0) Ang 1.0))
	)
)
;
;
(defun SetAnchor (EnameSheet EnameShape PMove Border Side / Pprojection PM Rtn)

	(if (and EnameSheet EnameShape PMove Border Side)
		(progn
			(setq Pprojection (vlax-curve-getclosestpointtoprojection EnameSheet PMove (list 0.0 0.0 1.0)))
			(if (not (equal PMove Pprojection 1e-8))
				(progn
					(cond 
						((= Side 1) ; internal
							(if (LM:PointInside-p PMove  (vlax-ename->vla-object EnameSheet) nil)
								(setq PM (prol (nth 0 PMove) (nth 1 PMove) (nth 0 Pprojection) (nth 1 Pprojection) 1.0))
								(setq PM (prol (nth 0 PMove) (nth 1 PMove) (nth 0 Pprojection) (nth 1 Pprojection) -1.0))
							)
						)
						((= Side 2) ;external
							(if (not (LM:PointInside-p PMove  (vlax-ename->vla-object EnameSheet) nil))
								(setq PM (prol (nth 0 PMove) (nth 1 PMove) (nth 0 Pprojection) (nth 1 Pprojection) 1.0))
								(setq PM (prol (nth 0 PMove) (nth 1 PMove) (nth 0 Pprojection) (nth 1 Pprojection) -1.0))
							)
						)
					)
					(setq Rtn (prol (nth 0 PM) (nth 1 PM) (nth 0 Pprojection) (nth 1 Pprojection) Border))
				)
			)
		)
	)
	(list Rtn PM)
)
;
;
(defun UpDateRotationShape (EnameSheet EnameShape LstOtherShape PMove Border AngleData / PAnchor AngleRotate PtRotation itm)

	(if (and EnameShape PMove Border AngleData)
		(if (/= (car AngleData) 0.0)
			(progn
				(setq PAnchor (SetAnchor EnameSheet EnameShape PMove Border (DefSideDinamicAlign EnameSheet)))
				(setq AngleRotate (ReconditionAngle (- (car AngleData) Pi)))
				(setq PtRotation  (cadr AngleData))
								
				(foreach itm (append (list EnameShape) LstOtherShape)
					(vla-rotate (vlax-ename->vla-object itm) 
								(vlax-3d-point PtRotation) 
								AngleRotate)
					(vla-move 	(vlax-ename->vla-object itm)
								(vlax-3D-point PtRotation)
								(vlax-3D-point (car PAnchor)))
				)
			)
		)
	)
)
;
;
(defun NextRotationShape (EnameSheet EnameShape LstOtherShape PMove Border Flag / LstAngle Pprojection PAnchor AngRotate Num itm Rtn)

	(if (and EnameSheet EnameShape PMove Border Flag)
		(progn
			(setq LstAngle 	  (GetAngleShape EnameShape))
			(setq Pprojection (vlax-curve-getclosestpointtoprojection EnameSheet PMove (list 0.0 0.0 1.0)))
			(if (not (equal PMove Pprojection 1e-8))
				(progn
					(setq PAnchor     (car (SetAnchor EnameSheet EnameShape PMove Border (DefSideDinamicAlign EnameSheet))))
					(setq AngRotate   (ReconditionAngle (- (angle PAnchor Pprojection) (/ Pi 2.0))))
					(setq Num 0)
					(foreach itm LstAngle
						(if (equal (nth 4 itm) AngRotate  1e-8)
							(if (= Flag "-")
								(setq Rtn (list (nth 3 itm) (nth 0 itm)))
								(setq Rtn (list (- 0.0 (nth 5 itm)) (nth 2 itm)))
							)
						)
						(setq Num (1+ Num))
					)
				)
			)
		)
	)
	Rtn
)
;
;
(defun ExtraRotationShape (EnameSheet EnameShape LstOtherShape PMove Border AngleRotation / RotateAnchor 
																							LstCo Pt EnameConvex CenterConvex 
																							EnameArrow itm PtR PX PAnchor)


	(defun RotateAnchor (P1 P2 AnalizePoint / CosDir itm Tmp Rtn)
		
		(if (and P1 P2 AnalizePoint)
			(progn
				(setq CosDir (DefPiano2P (car P1) (cadr P1) 0.0 (car P2) (cadr P2) 0.0))
				(foreach itm AnalizePoint
					(setq Tmp (append Tmp (list (transl (car itm) (cadr itm) 0.0 CosDir)))) 
				)
				(setq Box	(list 	(apply 'min (mapcar 'car  Tmp))	;	min x
									(apply 'max (mapcar 'car  Tmp))	;	max x
									(apply 'min (mapcar 'cadr Tmp))	;	min y
									(apply 'max (mapcar 'cadr Tmp))	;	max y
							)
				)
				(setq Rtn (transg (nth 1 Box) (/ (+ (nth 2 Box) (nth 3 Box)) 2.0) 0.0 CosDir))
			)
		)
		Rtn
	)
	; Main
	(if (and EnameSheet EnameShape PMove Border AngleRotation)
		;(if	(setq LstCo (DiscretizeShape EnameShape))
		(if	(setq LstCo (DiscretizeShapeNoControl EnameShape))
			(progn
				(setq Pprojection (vlax-curve-getclosestpointtoprojection EnameSheet PMove (list 0.0 0.0 1.0)))
				(setq PAnchor (SetAnchor EnameSheet EnameShape PMove Border (DefSideDinamicAlign EnameSheet)))
				(setq AngRotate$  (ReconditionAngle (- (angle (car PAnchor) Pprojection) (/ Pi 2.0))))
				(setq Pt (LM:ConvexHull (append LstCo (list (car LstCo)))))
				
				(if (not (LM:ListClockwise-p Pt))
					(setq Pt (reverse Pt))
				)
				
				(setq EnameConvex  (MakePolyline Pt T))
				(setq CenterConvex (LM:PolyCentroid EnameConvex))
				(foreach itm (append (list EnameShape) LstOtherShape (list EnameConvex))
					(vla-rotate (vlax-ename->vla-object itm) 
								(vlax-3d-point CenterConvex) 
								AngleRotation)
				)
				
				(foreach itm Pt
					(setq PtR (append PtR (list (dca 	(car CenterConvex) (cadr CenterConvex) 
														(car itm) (cadr itm) AngleRotation))))
				)
				(setq PX (RotateAnchor (car PAnchor) (cadr PAnchor) PtR))				
				
				(if (not (equal PX PAnchor 1e-8))
					(foreach itm (append (list EnameShape) LstOtherShape (list EnameConvex))
						(vla-move (vlax-ename->vla-object itm) 
									(vlax-3D-point PX) 
									(vlax-3D-point (car PAnchor)))
					)
				)
				(DeleteEntity (list EnameConvex))
			)
		)
	)
	PAnchor
)
;
;
(defun MappingColorShape (LstEnameShape / itm Rtn)
	(foreach itm LstEnameShape
		(setq Rtn (append Rtn (list (list itm (vla-get-Color itm)))))
	)
)
;
;
(defun PutColorShape (LstMappingColor / itm)
	(foreach itm LstMappingColor
		(vla-put-Color (car itm) (cadr itm))
	)
)
;
;
(defun DinamicAlign (EnameSheet EnameShape Border PMove ImposeRotation Flag / *error* startundo endundo acdoc
																		ExtraRotation Off tmp Loop LstMappingColor
																		ObjSheet LstObjShape PtBoxEname EnameAnchor
																		Msg gr1 gr2 Color ColorIn ColorOut OldEnameShape LstOtherShape itm Rtn LstEnameCopy)
						
    (defun *error* ( msg )
		(PutColorShape LstMappingColor)
		(DeleteEntity LstEnameCopy)

        (endundo (acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
		;(RemoveTarget)
		(RemoveAnchorPoint)
		(redraw EnameSheet 4)
		(princ)
    )
	;
	(defun startundo ( doc )
		(endundo doc)
		(vla-startundomark doc)
	)
	;
	(defun endundo ( doc )
		(while (= 8 (logand 8 (getvar 'undoctl)))
			(vla-endundomark doc)
		)
	)
	;
	(defun acdoc nil
		(eval (list 'defun 'acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
		(acdoc)
	)
	
	;
	; set var ++++++++++++++++++++
	;
	(startundo (acdoc))
	(setq AngRotate$  	0.0)
    (setq Off 			Border)
	(setq Loop			T)
	(setq ColorIn       3) ; Green
	(setq ColorOut      1) ; Red
	;
	; ++++++++++++++++++++++++++++
	;

	(setq Msg "\r[+/-] for [O]ffset | [</> 45°] for [R]otation | [A]llign | <[E]nter> ")
	
    (if (and EnameSheet EnameShape Border PMove)
		(progn
			(setq OldEnameShape   EnameShape)
			(setq LstEnameCopy    (Copy+Rotate+MirrorShape EnameShape (list (list 0.0 0.0) (list 0.0 0.0) nil nil)))
			(setq EnameShape      (car LstEnameCopy))
			(setq LstOtherShape   (cdr LstEnameCopy))
			(setq ObjSheet        (vlax-ename->vla-object EnameSheet))
			(setq LstObjShape     (LstEname->LstObj LstEnameCopy))
			(setq LstMappingColor (MappingColorShape LstObjShape))
			(setq EnameAnchor     (AlignShape EnameSheet EnameShape LstOtherShape PMove Off ImposeRotation))
			(redraw EnameSheet 	  3)
			
			(princ (strcat Msg " [Offset " (LM:rtos Off 2 1) "]"))

            (while Loop

                (setq gr1 (grread t 15 0)
                      gr2 (cadr gr1)
                      gr1 (car  gr1)
                )
				(cond
					(   (member gr1 '(3 5))
						
						;(if (CheckIntersectionObjects EnameShape LstEnameCopy)
						;	(setq Color ColorOut)
						;	(setq Color ColorIn)
						;)
						(cond
							(   (= 5 gr1)
								(setq PMove gr2)
								
								(if (setq Rtn (SniffStreet PMove LstEnameCopy))
									(progn
										(redraw EnameSheet 4)
										(setq EnameSheet Rtn)
										(redraw EnameSheet 3)
									)
								)
								(RepositionShape   EnameSheet  EnameShape LstOtherShape EnameAnchor PMove Off)
								(ChangeColorLstObj LstObjShape Color)
							)
							(   (= 3 gr1)
								(if (CheckIntersectionObjects EnameShape LstEnameCopy)
									(if (= (LM:popup "avvertimento" "Interferenza contorno\n vuoi proseguire ?" (+ 1 48 4096)) 1)
										(setq Loop nil)
									)
								)
								(if (not Loop)
									(progn
										(PutColorShape LstMappingColor)
										(if Flag (DeleteShape OldEnameShape))
									)
								)
							)
							;(   (= 3 gr1)
							;	(if (/= Color ColorIn)
							;		(if (= (LM:popup "avvertimento" "Interferenza contorno\n vuoi proseguire ?" (+ 1 48 4096)) 1)
							;			(setq Loop nil)
							;		)
							;		(setq Loop nil)
							;	)
							;	(if (not Loop)
							;		(progn
							;			(PutColorShape LstMappingColor)
							;			(if Flag (DeleteShape OldEnameShape))
							;		)
							;	)
							;)
						)
					)
					(   (= 2 gr1)
						(cond
							; Offset +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							(   (member gr2 '(043 061))	;+
								(setq Off (+ Off 1.0))
								(princ (strcat Msg " [Offset " (LM:rtos Off 2 1) "]"))
							)
							(   (member gr2 '(045 095))	;-
								(setq Off (- Off 1.0))
								(princ (strcat Msg " [Offset " (LM:rtos Off 2 1) "]"))
							)
							(   (member gr2 '(079 111))
								(if (setq tmp (getdist (strcat "\nSpecify Offset <" (rtos Off) ">: ")))
									(setq Off tmp)
								)
								(princ (strcat Msg " [Offset " (LM:rtos Off 2 1) "]"))
							)
							; Rotation +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							(   (member gr2 '(044 060)) ;<45°
								(setq ExtraRotation (/ pi 4.0))
								(princ (strcat Msg " [Extra Rotation " (LM:rtos (* (/ ExtraRotation Pi) 180.0) 2 1) "]"))
								(ExtraRotationShape EnameSheet EnameShape LstOtherShape PMove Off ExtraRotation)
							)
							(   (member gr2 '(046 062)) ;>45°
								(setq ExtraRotation (- 0.0 (/ pi 4.0)))
								(princ (strcat Msg " [Extra Rotation " (LM:rtos (* (/ ExtraRotation Pi) 180.0) 2 1) "]"))
								(ExtraRotationShape EnameSheet EnameShape LstOtherShape PMove Off ExtraRotation)
							)
							(   (member gr2 '(082 114)) ; r R
								(if (setq tmp (getreal (strcat Msg " [Extra Rotation ->]")))
									(progn
										(setq ExtraRotation (/ (* tmp pi) 180.0))
										(ExtraRotationShape EnameSheet EnameShape LstOtherShape PMove Off ExtraRotation)
										(princ (strcat Msg " [Extra Rotation " (LM:rtos (* (/ ExtraRotation Pi) 180.0) 2 1) "]"))
									)
								)
							)
							; Allign +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							(	(member gr2 '(065))		; press A
								(setq  EnameAnchor  (AlignShape EnameSheet EnameShape LstOtherShape PMove Off nil))
								(setq ExtraRotation (NextRotationShape EnameSheet EnameShape LstOtherShape PMove Off "-"))
								(UpDateRotationShape EnameSheet EnameShape LstOtherShape PMove Off ExtraRotation)
							)
							(	(member gr2 '(097))		; press a
								(setq  EnameAnchor  (AlignShape EnameSheet EnameShape LstOtherShape PMove Off nil))
								(setq ExtraRotation (NextRotationShape EnameSheet EnameShape LstOtherShape PMove Off "+"))
								(UpDateRotationShape EnameSheet EnameShape LstOtherShape PMove Off ExtraRotation)
							)
							; Accept +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							(   (member gr2 '(013 032 069 101)) ; enter space E e
								(setq Loop nil)
								(PutColorShape LstMappingColor)
								(if Flag (DeleteShape OldEnameShape))
							)
						)
                    )
                )
            )
            (endundo (acdoc))
        )
    )
	(RemoveAnchorPoint)
	(redraw EnameSheet 4)
	LstEnameCopy
)
;
;
(defun 01ECDinamicAllign (/ InfoShape InfoReferenc AngleReference EnameReference x )

	(setq InfoShape nil)
	(while (not InfoShape) 
		(setq InfoShape (entsel "\nControno"))
		(if InfoShape
			(if (not (CheckIfEasyCutShape (car InfoShape)))
				(setq InfoShape nil)
			)
		)
	)
	;(setq EnameSheet (GetEnameSheetByEnameShape EnameShape))
	(initget 1 "Entita Gradi") 
	(setq x (getkword "\nDare l'allineamanto E[ntita] [G]radi")) 
	(cond
		((= x "Entita")
			(setq InfoReference (entsel "\nAllineamento "))
			(if InfoReference
				(if (or (= (cdr (assoc 0 (entget (car InfoReference)))) "LWPOLYLINE")
						(= (cdr (assoc 0 (entget (car InfoReference)))) "LINE")
					)
					(ECDinamicAllign (car InfoShape) (car InfoReference) (cadr InfoShape) (cadr InfoReference))
				)
			)
		)
		((= x "Gradi")
			(setq AngleReference (getreal "\nGradi di rotazione "))
			(if AngleReference
				(progn
					(setq EnameReference (LM:MakeLine (list 0.0 0.0) (polar (list 0.0 0.0) (/ (* AngleReference Pi) 180.0) 1.0)))
					(ECDinamicAllign (car InfoShape) EnameReference (cadr InfoShape) (list 0.0 0.0))
					(DeleteEntity (list EnameReference))
				)
			)
		)
	)
		

)
;
;
(defun ECDinamicAllign (EnameShape EnameReference PtOnShape PtOnReference  / 	GetPointsSgement GetFreeSpaceBoom 
																				CentroidPoint OverLappingShape ShowShape UnShowShape
																				*error* Startundo Endundo Acdoc
																				LstWorkEname
																				Loop ChangeDir
																				LstPtShape LstPtRef msgLst 
																				P1S P2S P3S P1R P2R P3R
																				PcShape PcBoom LstPcShape EnAux LstEnameShape) 
	
	;(if EnameShape
	;	(progn
	;		(SelectShape EnameShape)
	;	)
	;
	(defun GetPointsSgement (Ename PtOn / Vr Co Nv Ini Fin)
		(if (and Ename PtOn)
			(progn
				;(setq Vr  	 (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (trans (osnap PtOnShape "_nea") 1 0)))
				(setq Vr  	 (vlax-curve-getParamAtPoint   (vlax-ename->vla-object Ename) 
														   (vlax-curve-getClosestPointTo (vlax-ename->vla-object Ename) (trans PtOn 1 0) nil)))
				(setq Co 	 (vlax-get (vlax-ename->vla-object Ename) 'coordinates))
				(setq Nv	 (/ (length Co) 2.0))
				(setq Ini    (list (nth (+ (* 2 (fix Vr)) 0) Co) (nth (+ (* 2 (fix Vr)) 1) Co)))
				(if (= (- Nv 1) (fix Vr))
					(setq Fin (list (nth 0 Co) (nth 1 Co)))
					(setq Fin (list (nth (+ (* 2 (+ (fix Vr) 1)) 0) Co) (nth (+ (* 2 (+ (fix Vr) 1)) 1) Co)))
				)
				(setq Rtn (list (TransEcsToWcs Ini Ename) (TransEcsToWcs Fin Ename)))
			)
		)
		Rtn
	)
	;
	(defun GetFreeSpaceBoom (Pt / DistFence DxMargin SxMargin TopMargin BotMargin 
								  DXEname SXEname TopEname  BotEname itm itm1 DxDist SxDist TopDist BotDist
								  DxMin SxMin TopMin BotMin) 					  
								  
	
		(if Pt
			(progn
				(setq DistFence 10000.0)
				(setq DxMargin     15.0)
				(setq SxMargin     15.0)
				(setq TopMargin    15.0)
				(setq BotMargin   291.0)
				(setq DXEname  (LM:MakeLine pt (list (+ (car Pt) DistFence) (cadr Pt))))
				(setq SXEname  (LM:MakeLine pt (list (- (car Pt) DistFence) (cadr Pt))))
				(setq TopEname (LM:MakeLine pt (list (car Pt) (+ (cadr Pt) DistFence))))
				(setq BotEname (LM:MakeLine pt (list (car Pt) (- (cadr Pt) DistFence))))
				
				(foreach itm (LM:ss->ent (ssget "_F" (list Pt (list (+ (car Pt) DistFence) (cadr Pt)))
													 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					(foreach itm1 (MainVla-IntersectWith itm DXEname)
						(setq DxDist (append DxDist (list (distance Pt itm1))))
					)
				)
				(foreach itm (LM:ss->ent (ssget "_F" (list Pt (list (- (car Pt) DistFence) (cadr Pt)))
													 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					(foreach itm1 (MainVla-IntersectWith itm SXEname)
						(setq SxDist (append SxDist (list (distance Pt itm1))))
					)
				)
				(foreach itm (LM:ss->ent (ssget "_F" (list Pt (list (car Pt) (+ (cadr Pt)  DistFence)))
													 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					(foreach itm1 (MainVla-IntersectWith itm TopEname)
						(setq TopDist (append TopDist (list (distance Pt itm1))))
					)
				)
				(foreach itm (LM:ss->ent (ssget "_F" (list Pt (list (car Pt) (- (cadr Pt)  DistFence)))
													 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					(foreach itm1 (MainVla-IntersectWith itm BotEname)
						(setq BotDist (append BotDist (list (distance Pt itm1))))
					)
				)
				
				(DeleteEntity (list DXEname SXEname TopEname BotEname))
				
				(if (and DxDist SxDist TopDist BotDist)
					(progn
						(setq DxMin  (- (apply 'min DxDist)  DxMargin))
						(setq SxMin  (- (apply 'min SxDist)  SxMargin))
						(setq TopMin (- (apply 'min TopDist) TopMargin))
						(setq BotMin (- (apply 'min BotDist) BotMargin))

						(list (list  (- (car Pt) SxMin) (- (cadr Pt) BotMin))
							  (list  (+ (car Pt) DxMin) (- (cadr Pt) BotMin))
							  (list  (+ (car Pt) DxMin) (+ (cadr Pt) TopMin))
							  (list  (- (car Pt) SxMin) (+ (cadr Pt) TopMin))
						)
					)
				)
			)
		)
	)
	
	;
	(defun CentroidPoint (PtList)
		
		(if PtList
			(progn
				(if (null (caddr (car ptlist))) ;test first point for 2D point
					(setq ptlist (mapcar '(lambda (x) (append x '(0.0))) ptlist))
				)
				(mapcar '(lambda (ord)(/ ord (length ptlist) 1.0))
					(list
						(apply '+ (mapcar '(lambda (pt) (car pt)) ptlist))
						(apply '+ (mapcar '(lambda (pt) (cadr pt)) ptlist))
						(apply '+ (mapcar '(lambda (pt) (caddr pt)) ptlist))
					)
				)
			)
		)
	)
	;
	(defun OverLappingShape (EnameRef EnameShape / LstRef LstShp itm)
		(setq LstRef (DiscretizeShapeNoControl EnameRef))
		(setq LstShp (DiscretizeShapeNoControl EnameShape))
		(foreach itm (LM:ss->ent (SelectShape EnameShape))
			(AlignObject (vlax-ename->vla-object itm)
						 (Pt->3dPt (car LstShp)) (Pt->3dPt (cadr LstShp)) (Pt->3dPt (caddr LstShp)) 
						 (Pt->3dPt (car LstRef)) (Pt->3dPt (cadr LstRef)) (Pt->3dPt (caddr LstRef)) nil)
		)
	)
	;
	(defun ShowShape (EnameShape / itm)
		(foreach itm (LM:ss->ent (SelectShape EnameShape))
			(redraw itm 1)
		)
	)
	;
	(defun UnShowShape (EnameShape / itm)
		(foreach itm (LM:ss->ent (SelectShape EnameShape))
			(redraw itm 2)
		)
	)
	;
	(defun AlignShapes+Move (LstEnameShapes P1S P2S P3S P1E P2E P3E PcBoom / itm WorkObject LstWorkEname PcShape)

		(foreach itm LstEnameShape
			(setq WorkObject 	(vla-copy (vlax-ename->vla-object itm)))
			(AlignObject WorkObject (Pt->3dPt P1S) (Pt->3dPt P2S) (Pt->3dPt P3S) (Pt->3dPt P1R) (Pt->3dPt P2R) (Pt->3dPt P3R) nil)
			(setq LstWorkEname (append LstWorkEname (list (vlax-vla-object->ename WorkObject))))
		)
		(setq PcShape (CentroidPoint (BoundingBoxLstEname LstWorkEname)))
		(foreach itm LstWorkEname
			(vla-Move (vlax-ename->vla-object itm) (vlax-3d-point PcShape) (vlax-3d-point PcBoom))
		)
		LstWorkEname
	)
	;
	(defun *error* ( msg )

		(DeleteEntity LstWorkEname)
		(ShowShape EnameShape)
        (endundo (acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
		(princ)
    )
	;
	(defun startundo ( doc )
		(endundo doc)
		(vla-startundomark doc)
	)
	;
	(defun endundo ( doc )
		(while (= 8 (logand 8 (getvar 'undoctl)))
			(vla-endundomark doc)
		)
	)
	;
	(defun acdoc nil
		(eval (list 'defun 'acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
		(acdoc)
	)
	;
	; Main
	;
	;(setq OldEnameShape   EnameShape)
	;(setq LstEnameCopy    (Copy+Rotate+MirrorShape EnameShape (list (list 0.0 0.0) (list 0.0 0.0) nil nil)))
	;(setq EnameShape      (car LstEnameCopy))
	;(setq LstOtherShape   (cdr LstEnameCopy))
	(setq Loop		  T)
	(setq ChangeDir   T)
	(startundo (acdoc))
	
	(cond
		((= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE")
			(setq LstPtShape (GetPointsSgement EnameShape PtOnShape))
		)
		(t
			(alert "Il contorno deve essere una polilinea")
		)
	)
	(cond
		((= (cdr (assoc 0 (entget EnameReference))) "LWPOLYLINE")
			(setq LstPtRef (GetPointsSgement EnameReference PtOnReference))
		)
		((= (cdr (assoc 0 (entget EnameReference))) "LINE")
			(setq LstPtRef (list (cdr (assoc 10 (entget EnameReference))) (cdr (assoc 11 (entget EnameReference)))))
		)
		(t
			(alert "Il riferimento deve essere una linea o una polilinea")
		)
	)

	(setq LstEnameShape (LM:ss->ent (SelectShape EnameShape)))
	
	(setq P1S 		(car LstPtShape))
	(setq P2S 		(cadr LstPtShape))
	(setq P3S 		(per (car P2S) (cadr P2S) (car P1S) (cadr P1S) -1.0))
	(setq P1R 		(car LstPtRef))
	(setq P2R 		(cadr LstPtRef))
	(setq P3R 		(per (car P2R) (cadr P2R) (car P1R) (cadr P1R) -1.0))
	
	(if (not (setq PcBoom (CentroidPoint (GetFreeSpaceBoom PtOnShape))))
		(setq PcBoom (CentroidPoint (BoundingBoxLstEname LstEnameShape)))
	)
	;(setq EnAux (GetEnameShapeByDummyEnameSelect EnameShape))
	;(if (equal EnAux EnameShape)
	;	(setq LstEnameShape (list EnAux))
	;	(setq LstEnameShape (list EnAux EnameShape))
	;)
	

	(if (and LstPtShape LstPtRef PcBoom)
		(progn
		
			(setq msgLst "\n[Tab] cambia allineamento | [Invio] | [E]xit")
			(princ msgLst)
			
			(setq LstWorkEname (AlignShapes+Move LstEnameShape 
												(Pt->3dPt P1S) (Pt->3dPt P2S) (Pt->3dPt P3S) (Pt->3dPt P1R) (Pt->3dPt P2R) (Pt->3dPt P3R) PcBoom))
			(UnShowShape EnameShape)
			
			
			(while Loop

                (setq Gr (grread 't 15 1) Code (car Gr) Data (cadr Gr))
				(if (= Code 2)
					(cond
						;Tab key
						((= Data 009) 	
							(if ChangeDir
								(progn
									(setq P1R (cadr LstPtRef))
									(setq P2R (car  LstPtRef))
									(setq ChangeDir nil)
								)
								(progn
									(setq P1R (car LstPtRef))
									(setq P2R (cadr  LstPtRef))
									(setq ChangeDir T)
								)
							)
							(setq P3R (per (car P2R) (cadr P2R) (car P1R) (cadr P1R) -1.0))
							(DeleteEntity LstWorkEname)
							(setq LstWorkEname (AlignShapes+Move LstEnameShape 
												(Pt->3dPt P1S) (Pt->3dPt P2S) (Pt->3dPt P3S) (Pt->3dPt P1R) (Pt->3dPt P2R) (Pt->3dPt P3R) PcBoom))
						)
						; Enter
						((= Data 013)
							(redraw)
							(setq Loop nil)
							(OverLappingShape (car LstWorkEname) (car LstEnameShape))
							(DeleteEntity LstWorkEname)
							(ShowShape EnameShape)
							(EnameShape->UpdateBlockInfoShape (car LstEnameShape))
						)
					)
				)
			)
		)
	)
)
;
;
(defun WalkPath (EnameStreet LstTorch Sleep Step / 	*error*
													LengthStreet DivideLine StartPt EndPt Obj 
													DistDivide Prg itm itm1  Rtn LastPoint PtFocus)

													 

	
	;
	;
	(defun *error* (msg / Ssel Pos)
	
		(princ "\n---> Esc WalkPath <---")
		(setq Ssel (ssget "X" (list (list -3 (list $RgpSymula)))))
		(setq Pos 0)
		(repeat (sslength Ssel)
			(entdel (ssname Ssel Pos))
			(setq Pos (1+ Pos))
		)
		;(LM:deleteblocks (list "BarEc" "TorchEc"))
	)
	;
	; Main
	;
	(if (and EnameStreet LstTorch Sleep)
		(progn
			; Step
			(setq LengthStreet (vla-get-length (vlax-ename->vla-object EnameStreet)))
			(if (not Step)
				(cond 
					((and (> LengthStreet 0) (<= LengthStreet 150))
						(setq Step 5)
					)
					((and (> LengthStreet 150) (<= LengthStreet 300))
						(setq Step 10)
					)
					((and (> LengthStreet 300) (<= LengthStreet 600))
						(setq Step 11)
					)
					((and (> LengthStreet 600) (<= LengthStreet 900))
						(setq Step 12)
					)
					((and (> LengthStreet 900) (<= LengthStreet 1200))
						(setq Step 13)
					)
					((and (> LengthStreet 1200) (<= LengthStreet 1500))
						(setq Step 14)
					)
					((and (> LengthStreet 1500) (<= LengthStreet 1800))
						(setq Step 15)
					)
					((and (> LengthStreet 1800) (<= LengthStreet 2100))
						(setq Step 16)
					)
					((and (> LengthStreet 2100) (<= LengthStreet 2400))
						(setq Step 17)
					)
					((and (> LengthStreet 2400) (<= LengthStreet 3000))
						(setq Step 18)
					)
					((and (> LengthStreet 3000) (<= LengthStreet 5000))
						(setq Step 19)
					)
					((and (> LengthStreet 5000) (<= LengthStreet 8000))
						(setq Step 20)
					)
					(t
						(setq Step 40)
					)
				)
			)

			(setq DivideLine  	(fix (/ LengthStreet Step)))
			(setq StartPt 	  	(vlax-curve-getStartPoint 	EnameStreet))
			(setq EndPt 	  	(vlax-curve-getEndPoint   	EnameStreet))
			(setq Obj			(vlax-ename->vla-object 	EnameStreet))
			
			(cond
				((= (cdr (assoc 0 (entget EnameStreet))) "LWPOLYLINE")
					(if (> DivideLine 0)
						(progn
							(setq DistDivide 	(/ (vla-get-length Obj) DivideLine))
							(setq Prg 			DistDivide)
							(setq Rtn 			(append Rtn (list StartPt)))
							(repeat (- DivideLine 1)
								(setq Rtn (append Rtn (list (vlax-curve-getPointAtDist Obj Prg))))
								(setq Prg (+ Prg DistDivide))
							)
							(setq Rtn (append Rtn (list EndPt)))
						)
						(setq Rtn (list StartPt EndPt))
					)
				)
				((= (cdr (assoc 0 (entget EnameStreet))) "LINE")
					(if (> DivideLine 0)
						(setq Rtn (append (list StartPt) 
										  (div (car StartPt) (cadr StartPt) (car EndPt) (cadr EndPt) DivideLine)
										  (list EndPt)))
						(setq Rtn (list StartPt EndPt))
					)
				)
			)
			(setq PtFocus (caddr LstTorch))

			(foreach itm (car   LstTorch) (Visibility02 itm T))
			(foreach itm (cadr  LstTorch) (Visibility02 itm T))

			(foreach itm Rtn
				(MoveDxfCode (car  LstTorch) PtFocus (list (car itm) (cadr PtFocus)))
				(MoveDxfCode (cadr LstTorch) PtFocus itm)
				(setq PtFocus itm)
				;(repeat Sleep (redraw EnameStreet 3))
				(repeat Sleep (redraw))
			)
			; reset path torch
			(setq LastPoint PtFocus)
			(setq PtFocus (caddr LstTorch))
			(foreach itm (car   LstTorch) (Visibility02 itm nil))
			(foreach itm (cadr  LstTorch) (Visibility02 itm nil))
			(MoveDxfCode (car  LstTorch) LastPoint (list  (car PtFocus) (cadr LastPoint)))
			(MoveDxfCode (cadr LstTorch) LastPoint PtFocus)
		)
	)
	LastPoint
)
;
(defun test ()
	
	(setq Pt (list 0.0 0.0))
	(repeat 100
		(grdraw pt (list (+ (car pt) 100.0) (cadr pt)) 1)
		(setq pt (list (+ (car pt) 100.0) (cadr pt)))
		(repeat (fix $TimeSymula))
	)
)
