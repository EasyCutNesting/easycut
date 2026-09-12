;
;(setq EnameLine (car (entsel "\nLinea")))
;(setq EnameArc  (car (entsel "\nArco")))
;(setq PtRotate  (getpoint "\nPunto rotazione"))
;(LineTangentToArc (getpoint "\nPunto rotazione") (car (entsel "\nLinea")) (car (entsel "\nArco")))
(defun Test () 
	(setq Ename1 	(car (entsel "\nEn 1 ")))
	(setq Ename2  	(car (entsel "\nEn 2 ")))
	(setq PtRotate  (getpoint "\nPunto rotazione"))
	(GetPointRotate Ename1 Ename2 PtRotate T)
)
;
;
;
(defun GetPointRotate (Ename1 Ename2 PtRotate Verbose / Rtn)

	(if (and Ename1 Ename2 PtRotate)
		(cond
			((and (= (GetNameEname Ename1) "LINE") 
				  (= (GetNameEname Ename2) "LINE"))
				(setq Rtn (LineTangentLine Ename1 Ename2 PtRotate Verbose))
			)
			((and (= (GetNameEname Ename1) "LINE") 
					(or (= (GetNameEname Ename2) "ARC") (= (GetNameEname Ename2) "CIRCLE")))
				(setq Rtn (LineTangentToArc Ename1 Ename2 PtRotate Verbose))
			)
			((and (or (= (GetNameEname Ename1) "ARC") (= (GetNameEname Ename1) "CIRCLE"))
					(= (GetNameEname Ename2) "LINE"))
				(setq Rtn (ArcTangentToLine Ename2 Ename1 PtRotate Verbose))
			)
		)
	)
	Rtn
)
;
;
;
(defun LineTangentLine (EnameLine1 EnameLine2 PtRotate Verbose / Rtn)

	(if (and EnameLine1 EnameLine2 PtRotate)
		(FindRotation01 EnameLine1 EnameLine2 PtRotate nil)
	)
)
;
;
;			
(defun LineTangentToArc (EnameLine EnameArc PtRotate Verbose / Rtn itm NewObj)
	
	(setq Rtn (RotateTangent PtRotate EnameLine EnameArc nil))
	(if Verbose
		(foreach itm Rtn
			(setq NewObj (vla-copy (vlax-ename->vla-object EnameLine)))
			(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
		)
	)
	Rtn
)
;
;
;
(defun ArcTangentToLine (EnameLine EnameArc PtRotate Verbose / Rtn itm NewObj)
	
	(foreach itm (RotateTangent PtRotate EnameLine EnameArc nil)
		(setq Rtn (append Rtn (list (- 0.0 itm))))
	)
	(if Verbose 
		(foreach itm Rtn
			(setq NewObj (vla-copy (vlax-ename->vla-object EnameArc)))
			(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
		)
	)
	Rtn
)
;
;
;
(defun RotateTangent (PtRotate EnameLine EnameArc Verbose /  CheckRotation
																ModelSpace Center Radius StartPoint EndPoint 
																ObjCircle ObjLineA ObjLineB ParA ParB Ang itm LstAng Rtn)
	

	;
	(defun CheckRotation (PtRotate EnameLine EnameArc LstRotate Verbose / NewObj itm Rtn)
	
		(if (and PtRotate EnameLine EnameArc LstRotate)
			(foreach itm LstRotate
				(setq NewObj (vla-copy (vlax-ename->vla-object EnameLine)))
				(vla-Rotate NewObj (vlax-3d-point PtRotate) itm)
				(if (LM:intersections (vlax-ename->vla-object EnameArc) NewObj acextendnone)
					(setq Rtn (append Rtn (list itm)))
				)
				(if Verbose (getstring "<>"))
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
			(setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object)))
				  Center     (vlax-get (vlax-ename->vla-object EnameArc)  'center)
				  Radius     (vlax-get (vlax-ename->vla-object EnameArc)  'Radius)
				  StartPoint (vlax-get (vlax-ename->vla-object EnameLine) 'StartPoint)
				  EndPoint   (vlax-get (vlax-ename->vla-object EnameLine) 'EndPoint)
			)

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
							
					(foreach itm (LM:intersections ObjCircle ObjLineA acextendnone)
						(setq LstAng (append LstAng (list (- Ang (angle PtRotate itm)))))
					)
					(foreach itm (LM:intersections ObjCircle ObjLineB acextendnone)
						(setq LstAng (append LstAng (list (- Ang (angle PtRotate itm)))))
					)
					(DeleteObject (list ObjLineA ObjLineB ObjCircle))
					;
					; Check
					;
					(setq Rtn (CheckRotation PtRotate EnameLine EnameArc LstAng Verbose))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun FindRotation01 (Ename1 Ename2 PtRotate Verbose / ModelSpace Pa1 Pa2 Pb1 Pb2
														RadiusPa1 RadiusPa2 RadiusPb1 RadiusPb2
														Circle itm
														Pint LstPt itm ang1 ang2 Rtn)
	
		
	(if (and Ename1 Ename2 PtRotate)
		(progn
			(setq modelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
				
			(setq Pa1 (vlax-safearray->list (vlax-variant-value (vla-get-startpoint (vlax-ename->vla-object Ename1)))))
			(setq Pa2 (vlax-safearray->list (vlax-variant-value (vla-get-endpoint   (vlax-ename->vla-object Ename1)))))
			(setq Pb1 (vlax-safearray->list (vlax-variant-value (vla-get-startpoint (vlax-ename->vla-object Ename2)))))
			(setq Pb2 (vlax-safearray->list (vlax-variant-value (vla-get-endpoint   (vlax-ename->vla-object Ename2)))))
			
			(setq RadiusPa1 (distance PtRotate Pa1))
			(setq RadiusPa2 (distance PtRotate Pa2))
			(setq RadiusPb1 (distance PtRotate Pb1))
			(setq RadiusPb2 (distance PtRotate Pb2))
			
			(if (> RadiusPa1 0.0)
				(progn
					(setq Circle (vlax-vla-object->ename (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPa1)))
					(foreach itm (MainVla-IntersectWith Circle Ename2) 
						(setq LstPt (append LstPt (list (list Pa1 itm)))) 
					)
					(DeleteEntity (list Circle))
				)
			)
			
			(if (> RadiusPa2 0.0)
				(progn
					(setq Circle (vlax-vla-object->ename (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPa2)))
					(foreach itm (MainVla-IntersectWith Circle Ename2)
						(setq LstPt (append LstPt (list (list Pa2 itm))))
					)
					(DeleteEntity (list Circle))
				)
			)

			(if (> RadiusPb1 0.0)
				(progn
					(setq Circle (vlax-vla-object->ename (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPb1)))
					(foreach itm (MainVla-IntersectWith Circle Ename1)
						(setq LstPt (append LstPt (list (list itm Pb1))))
					)
					(DeleteEntity (list Circle))
				)
			)
			
			(if (> RadiusPb2 0.0)
				(progn
					(setq Circle (vlax-vla-object->ename (vla-addcircle modelSpace (vlax-3d-point PtRotate) RadiusPb2)))
					(foreach itm (MainVla-IntersectWith Circle Ename1)
						(setq LstPt (append LstPt (list (list itm Pb2))))
					)
					(DeleteEntity (list Circle))
				)
			)

			(foreach itm LstPt
				(setq ang1 (angle PtRotate (car  itm)))
				(setq ang2 (angle PtRotate (cadr itm)))
				(setq Rtn (append Rtn (list (ReconditionAngle (- ang2 ang1)))))
				(if Verbose (vla-rotate (vla-copy (vlax-ename->vla-object Ename1)) (vlax-3d-point PtRotate) (- ang2 ang1)))
			)
		)
	)
	Rtn
)	
;
;
;
