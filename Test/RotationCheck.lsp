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
			((and (= (GetNameEname Ename1) "LINE") 
				  (= (GetNameEname Ename2) "LINE"))
				(setq Rtn (RotateLineToLine Ename1 Ename2 PtRotate Verbose)) 
			)
			((and (= (GetNameEname Ename1) "LINE") (= (GetNameEname Ename2) "ARC"))
				(setq Rtn (RotateLineToArc Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "ARC") (= (GetNameEname Ename2) "LINE"))
				(setq Rtn (RotateArcToLine Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "LINE") (= (GetNameEname Ename2) "CIRCLE"))
				(setq Rtn (RotateLineToCircle Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "CIRCLE") (= (GetNameEname Ename2) "LINE"))
				(setq Rtn (RotateCircleToLine Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "CIRCLE") (= (GetNameEname Ename2) "CIRCLE"))
				(setq Rtn (RotateCircleToCircle Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "CIRCLE") (= (GetNameEname Ename2) "ARC"))
				(setq Rtn (RotateCircleToArc Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "ARC") (= (GetNameEname Ename2) "CIRCLE"))
				(setq Rtn (RotateArcToCircle Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "ARC") (= (GetNameEname Ename2) "ARC"))
				(setq Rtn (RotateArcToArc Ename1 Ename2 PtRotate Verbose))
			)
		)
	)
	(vl-sort (LM:UniqueFuzz (mapcar 'ReconditionAngle Rtn) (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0)) '<)
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
			)
			
			;(setq Rtn (LM:UniqueFuzz Rtn (/ (* EasyCutAccuracyAngleRotation$ pi) 180.0))) 
			
			(if Verbose 
				(foreach itm Rtn
					(vla-rotate (vla-copy (vlax-ename->vla-object EnameLine1)) (vlax-3d-point PtRotate) itm)
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
							
					;(foreach itm (LM:intersections ObjCircle ObjLineA acextendnone)
					(foreach itm (IntersectionsFuzz ObjCircle ObjLineA AccuracyIntersection)
						(setq LstAng (append LstAng (list (- Ang (angle PtRotate itm)))))
					)
					;(foreach itm (LM:intersections ObjCircle ObjLineB acextendnone)
					(foreach itm (IntersectionsFuzz ObjCircle ObjLineB AccuracyIntersection)
						(setq LstAng (append LstAng (list (- Ang (angle PtRotate itm)))))
					)
					(DeleteObject (list ObjLineA ObjLineB ObjCircle))
				)
			)
			;
			(if (= Mode 2)
				(foreach itm (CheckRotation EnameLine EnameArc PtRotate LstAng AccuracyIntersection)
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
