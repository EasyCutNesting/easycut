;
;
(defun GetAngleShape (EnameShape / GetAng01 GetAng02
									 LstCo Pt Num Ang0 Ang1 Ang2 Pmid0 Pmid1 Pmid2 Rtn)

	(defun GetAng01 (DistA DistB DistC)
		(if (and DistA DistB DistC)
			(acos (/ (- (+ (* DistB DistB) (* DistC DistC)) (* Dista DistA)) (* 2.0 DistB DistC)))
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
		(if (setq LstCo (DiscretizeShape EnameShape))
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
			(setq Rtn (LM:ss->ent (ssget "_CP" (DiscretizeShape EnameShape) (list (list -3 (list (strcat $RgpSheet "," $RgpShape)))))))
		    (foreach itm ExcludeEname
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
(defun AlignShape (EnameSheet EnameShape LstOtherShape PMove Border / LstAngle Pprojection PAnchor EnameAnchor Num itm AngRot PtRot Rtn)
	
	(if (and EnameSheet EnameShape PMove Border)
		(progn
			(setq LstAngle 	  (GetAngleShape EnameShape))
			(setq Pprojection (vlax-curve-getclosestpointtoprojection EnameSheet PMove (list 0.0 0.0 1.0)))
			(if (not (equal PMove Pprojection 1e-8))
				(progn
					(setq PAnchor (car (SetAnchor EnameSheet EnameShape PMove Border (DefSideDinamicAlign EnameSheet))))
					(RemoveAnchorPoint)
					(setq EnameAnchor (MakeAnchorPoint PAnchor))
					(setq AngRotate$  (ReconditionAngle (- (angle PAnchor Pprojection) (/ Pi 2.0))))
					
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
									(vlax-3D-point PAnchor))
						(vla-rotate (vlax-ename->vla-object itm)  
									(vlax-3d-point PAnchor) 
									(car Rtn))
					)
				)
			)
		)
	)
	EnameAnchor
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
		(if	(setq LstCo (DiscretizeShape EnameShape))
			(progn
				(setq PAnchor (SetAnchor EnameSheet EnameShape PMove Border (DefSideDinamicAlign EnameSheet)))
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
(defun DinamicAlign (EnameSheet EnameShape Border PMove / *error* startundo endundo acdoc
														  ExtraRotation Off tmp Loop LstMappingColor
														  ObjSheet LstObjShape PtBoxEname EnameAnchor
														  Msg gr1 gr2 Color ColorIn ColorOut LstOtherShape itm Rtn LstEnameCopy)
						
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
	;(RemoveTarget)
	;
	; ++++++++++++++++++++++++++++
	;

	(setq Msg "\r[+/-] for [O]ffset | [</>] for [R]otation | [a/A] for [A]llign | <[E]xit> ")
	
    (if (and EnameSheet EnameShape Border PMove)
		(progn
			
			(setq LstEnameCopy    (CopyShape EnameShape nil))
			(foreach itm LstEnameCopy
				(princ "\n") (princ (assoc 0 (entget itm)))
			)
			(setq EnameShape      (car LstEnameCopy))
			(setq LstOtherShape   (cdr LstEnameCopy))
			(setq ObjSheet        (vlax-ename->vla-object EnameSheet))
			(setq LstObjShape     (LstEname->LstObj LstEnameCopy))
			(setq LstMappingColor (MappingColorShape LstObjShape))
			(setq EnameAnchor     (AlignShape EnameSheet EnameShape LstOtherShape PMove Off))
			(redraw EnameSheet 	  3)
			
			(princ (strcat Msg " [Offset " (LM:rtos Off 2 1) "]"))

            (while Loop

                (setq gr1 (grread t 15 0)
                      gr2 (cadr gr1)
                      gr1 (car  gr1)
                )
				(cond
					(   (member gr1 '(3 5))
						
						(if (CheckIntersectionObjects EnameShape LstEnameCopy)
							(setq Color ColorOut)
							(setq Color ColorIn)
						)
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
								(if (= Color ColorIn)
									(progn
										(setq Loop nil)
										(PutColorShape LstMappingColor)
									)
								)
							)
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
							(   (member gr2 '(082 114))
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
								(setq  EnameAnchor  (AlignShape EnameSheet EnameShape LstOtherShape PMove Off))
								(setq ExtraRotation (NextRotationShape EnameSheet EnameShape LstOtherShape PMove Off "-"))
								(UpDateRotationShape EnameSheet EnameShape LstOtherShape PMove Off ExtraRotation)
							)
							(	(member gr2 '(097))		; press a
								(setq  EnameAnchor  (AlignShape EnameSheet EnameShape LstOtherShape PMove Off))
								(setq ExtraRotation (NextRotationShape EnameSheet EnameShape LstOtherShape PMove Off "+"))
								(UpDateRotationShape EnameSheet EnameShape LstOtherShape PMove Off ExtraRotation)
							)
							; Accept +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							(   (member gr2 '(013 032 069 101)) ; enter space E e
								(setq Loop nil)
								(PutColorShape LstMappingColor)
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
)
;
;
