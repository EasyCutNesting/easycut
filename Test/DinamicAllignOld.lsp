;(vla-put-insertionpoint (vlax-ename->vla-object (getent))  (vlax-3D-point '(0.0 20.0)))
(defun GetAngleShape (EnameShape / LstCo Pt Num Rtn)
	(if EnameShape
		(if (setq LstCo (DiscretizeShape EnameShape))
			(progn
				(setq Pt (LM:ConvexHull LstCo))
				;(setq EnameConvex 	(entmakex
				;						(append
				;							(list
				;								'(000 . "LWPOLYLINE")
				;								'(100 . "AcDbEntity")
				;								'(100 . "AcDbPolyline")
				;								 (cons 90 (length Pt))
				;								'(070 . 1)
				;							)
				;							(mapcar '(lambda ( x ) (cons 10 x)) Pt)
				;						)
				;					)
				;)
				(setq Num 0)
				(setq Pt (append Pt (list (car Pt))))
				
				(repeat (- (length Pt) 1)
					(setq Rtn (append Rtn (list (angle (nth (+ Num 0) Pt) (nth (+ Num 1) Pt)))))
					(setq Num (1+ Num))
				)
				
			)
		)
	)
	Rtn
)
;
;
;
(defun ChangeInsertPoint (EnameBlock NewPt / acdoc acblk lst p1 p2 obj)
	
	(if EnameBlock
		(progn
			(setq acdoc (vla-get-ActiveDocument (vlax-get-acad-object))
				  acblk (vla-get-blocks acdoc)
				  lst   (entget EnameBlock)
			)
			(setq p1 (vlax-3D-point NewPt)
				  p2 (vlax-3D-point '(0. 0. 0.))
            )
			
			(vlax-for obj (vla-item acblk (setq bn (cdr (assoc 2 lst)))) (vla-Move obj p1 p2))
			(vla-regen acdoc acAllViewports)
		)
	)
)
;
;
;
(defun CheckIntersection (Obj1 Obj2)
		(vlax-safearray-get-u-bound 
				(vlax-variant-value 
						(vla-IntersectWith Obj1 
										   Obj2
										   acExtendNone)) 1)
)
;
;
;
(defun ChangeColorBlock (ObjBlock Color / blk x doc)
	(if (and ObjBlock Color)
		(progn
			(setq doc (vla-get-activedocument (vlax-get-acad-object)))
			(setq blk (vla-item (vla-get-blocks doc) (vla-get-Effectivename ObjBlock)))
			(vlax-for x blk
				(vla-put-color x Color)
			)
		)
	)
)
;
;
;
(defun DinamicAlign (EnameSheet EnameShape AnchorPoint Border / *error* startundo endundo acdoc
																rot off ocs fac pi2 ObjSheet ObjShape
																NameBlock CopyShape ObjBlock
																msg gr1 gr2 pt1 pt2 pt3 dis px ColorBlock ObjExploded tmp
																NthVal LstCoordShape)
						
    (defun *error* ( msg )
	
		(DeleteObject ObjExploded)
        (vla-delete   ObjBlock)
		(PurgeBlock   NameBlock)
		
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
	
	; set var
	(startundo (acdoc))
	(setq rot 0.0)
    (setq off Border)
	(setq ocs (trans '(0 0 1) 1 0 t))
	(setq fac 1.0)
	(setq pi2 (/ pi -2.0))
	(setq NthVal 0)
	
	
    (if (and EnameSheet EnameShape AnchorPoint Border)
		(progn
			(setq LstAngle (GetAngleShape EnameShape))
			(setq ObjSheet (vlax-ename->vla-object EnameSheet))
			(setq ObjShape (vlax-ename->vla-object EnameShape))
			(setq NameBlock "$tmp")
			(setq CopyShape (vla-copy ObjShape))
			(setq ObjBlock  (vlax-ename->vla-object (Obj2Blk NameBlock AnchorPoint (LstObj->Ssget (list CopyShape)))))

            (setq msg (princ "\n[+/-] for [O]ffset | [</>] for [R]otation | [Tab] | <[E]xit>: "))

            (while
                (progn
                    (setq gr1 (grread t 15 0)
                          gr2 (cadr gr1)
                          gr1 (car  gr1)
                    )
                    (cond
                        (   (member gr1 '(3 5))
                            (setq pt2 gr2
                                  pt1 (vlax-curve-getclosestpointtoprojection EnameSheet pt2 ocs)
                            )
                            (if (not (equal pt1 pt2 1e-8))
                                (progn
									(if (LM:PointInside-p pt2 ObjSheet nil)
										(setq pt2 (prol (nth 0 pt2) (nth 1 pt2) (nth 0 pt1) (nth 1 pt1) 1.0))
									)
												 
									(setq pt3 (prol (nth 0 pt2) (nth 1 pt2) (nth 0 pt1) (nth 1 pt1) off))
									
									(vla-move ObjBlock (vla-get-insertionpoint ObjBlock) (vlax-3D-point pt3))
									;(vla-put-rotation ObjBlock (+ (angle pt1 pt2) rot pi2))
									(vla-put-rotation ObjBlock (+ (angle pt1 pt2) pi2))
									(if (< (CheckIntersection ObjBlock ObjSheet) 0)
										(setq ColorBlock 3)
										(setq ColorBlock 1)
									)
									(ChangeColorBlock ObjBlock ColorBlock)
                                )
                            )
                            (cond
                                (   (= 5 gr1))
                                (   (= 3 gr1)
									(if (= ColorBlock 3)
										(progn
											(DeleteObject ObjExploded)
											(setq ObjExploded (vlax-safearray->list (vlax-variant-value (vla-explode ObjBlock))))
										)
										(setq oa|mtp T)
									)
								)
                            )
                        )
                        (   (= 2 gr1)
                            (cond
                                (   (member gr2 '(043 061))	;+
                                    (setq off (+ off 1.0))
                                )
                                (   (member gr2 '(045 095))	;-
                                    (setq off (- off 1.0))
                                )
                                (   (member gr2 '(044 060)) ;<45°
                                    (setq Rot (/ pi 4.0))
									(setq LstAngle (mapcar  '(lambda (x) (- x Rot)) LstAngle))
									(setq ObjBlock (RotateEntityBlock ObjBlock Rot))
                                )
                                (   (member gr2 '(046 062)) ;>45°
                                    (setq Rot (- 0.0 (/ pi 4.0)))
									(setq LstAngle (mapcar  '(lambda (x) (- x Rot)) LstAngle))
									(setq ObjBlock (RotateEntityBlock ObjBlock Rot))
                                )
                                (   (member gr2 '(013 032 069 101)) ; enter space E e
                                    nil
                                )
                                (   (member gr2 '(082 114))
                                    (if (setq tmp (getreal (strcat "\nSpecify Rotation <" (rtos (/ (* Rot 180) pi) 2 3) ">: ")))
										(progn
											(setq Rot (/ (* tmp pi) 180.0))
											(setq LstAngle (mapcar  '(lambda (x) (+ x Rot)) LstAngle))
											(setq ObjBlock (RotateEntityBlock ObjBlock Rot))
										)
									)
                                    (princ msg)
                                )
                                (   (member gr2 '(079 111))
                                    (if (setq tmp (getdist (strcat "\nSpecify Offset <" (rtos off) ">: ")))
 										(setq off tmp)
                                    )
                                    (princ msg)
                                )
								(	(member gr2 '(009))		; press Tab
									(setq Rot (- (* 2.0 pi) (nth NthVal LstAngle)))
									(setq ObjBlock (RotateEntityBlock ObjBlock Rot))
									(setq LstAngle (mapcar  '(lambda (x) (- x (nth NthVal LstAngle))) LstAngle))

									(setq NthVal   (1+ NthVal))
									(if (= NthVal (length LstAngle))
										(setq NthVal 0)
									)
									(princ "\n") (princ LstAngle) (princ "\nEsco")
								
								)
                                (   t   )
                            )
                        )
                        (   (member gr1 '(011 025))
                            nil
                        )
                        (   t   )
                    )
                )
            )
            (vla-delete  ObjBlock)
			(PurgeBlock NameBlock)
            (endundo (acdoc))
        )
    )
    ObjExploded
)
;
;
;
(defun MakeXline (p1 p2)
	(if (and p1 p2)
		(entmakex	(list	'(0 . "XLINE")
							'(8 . "XLINE")
							'(100 . "AcDbEntity")
							'(100 . "AcDbXline")
							(cons 10 (trans p1 1 0))
							(cons 11 (trans p2 1 0))
                    )
        )
	)
)
;
;
;
(defun RepositionShape (EnameSheet EnameShape Pt)
	
	(if (and EnameSheet EnameShape Pt)
		(progn
			(setq P2 (vlax-curve-getclosestpointtoprojection EnameSheet P2 (list 0.0 0.0 1.0)))
			(if (not (equal Pt P2 1e-8))
				(progn
					(if (setq Xline (MakeXline Pt P2))
						(progn
							(if (setq LstInt (MainVla-IntersectWith EnameShape Xline))
								(progn
									(setq MinDist (MinumunDistance P2 LstInt))
								)
							)
						)
					)
				)
			)
		)
	)
)
				

(defun RotateEntityBlock (ObjBlock AngleRotate / Pt Rot NameBlock ObjExploded itm l1 l2 DataCircle Rtn)

	(if (and ObjBlock AngleRotate)
		(progn
			(setq Pt  (vla-get-insertionpoint ObjBlock))
			(setq Rot (vla-get-rotation ObjBlock))
			(vla-put-rotation ObjBlock 0.0) 
			
			(setq NameBlock (vla-get-EffectiveName ObjBlock))
			
			(setq ObjExploded (vlax-safearray->list (vlax-variant-value (vla-explode ObjBlock))))
			(foreach itm ObjExploded
                (setq l1 (DiscretizeShape (vlax-vla-object->ename itm)))
                (setq l2 (LM:ConvexHull (append l2 l1)))
			)
			(setq DataCircle (LM:MinEncCircle l2)) ;(car  DataCircle) Center (cadr DataCircle)  Radius
           	(foreach itm ObjExploded
				(vla-rotate itm (vlax-3d-point (car DataCircle)) AngleRotate)
			)
			(vla-delete ObjBlock)
			(PurgeBlock NameBlock)
			(setq Rtn (vlax-ename->vla-object (obj2blk NameBlock 
													  (vlax-safearray->list (vlax-variant-value Pt))
													  (LstObj->Ssget ObjExploded))))
			(vla-put-rotation Rtn Rot)
		)
	)
	Rtn
)

(defun LM:MinEncCircle ( lst / _sub )
 
    (defun _sub ( p1 p2 l1 / a1 a2 l2 p3 p4 )
        (setq l2 (LM:RemoveWithFuzz (list p1 p2) l1 1e-8)
              p3 (car l2)
              a1 (LM:GetInsideAngle p1 p3 p2)
        )
        (foreach p4 (cdr l2)
            (if (< (setq a2 (LM:GetInsideAngle p1 p4 p2)) a1)
                (setq p3 p4 a1 a2)
            )
        )
        (cond
            (   (<= (/ pi 2.0) a1)
                (list (mid p1 p2) (/ (distance p1 p2) 2.0))
            )
            (   (vl-some
                    (function
                        (lambda ( a b c )
                            (if (< (/ pi 2.0) (LM:GetInsideAngle a b c)) (_sub a c l1))
                        )
                    )
                    (list p1 p1 p2) (list p2 p3 p1) (list p3 p2 p3)
                )
            )
            (   (LM:3PCircle p1 p2 p3)   )
        )
    )
 
    (
        (lambda ( lst )
            (cond
                (   (< (length lst) 2)
                    nil
                )
                (   (< (length lst) 3)
                    (list (apply 'mid lst) (/ (apply 'distance lst) 2.0))
                )
                (   (_sub (car lst) (cadr lst) lst)   )
            )
        )
        (LM:ConvexHull lst)
    )
)

(defun LM:RemoveWithFuzz ( l1 l2 fz )
    (vl-remove-if
        (function
            (lambda ( a )
                (vl-some
                    (function (lambda ( b ) (equal a b fz)))
                    l1
                )
            )
        )
        l2
    )
)
 
;; Get Inside Angle  -  Lee Mac
;; Returns the smaller angle subtended by three points with vertex at p2
 
(defun LM:GetInsideAngle ( p1 p2 p3 )
    (   (lambda ( a ) (min a (- (+ pi pi) a)))
        (rem (+ pi pi (- (angle p2 p1) (angle p2 p3))) (+ pi pi))
    )
)
 
 
;; Midpoint - Lee Mac
;; Returns the midpoint of two points
 
(defun mid ( a b )
    (mapcar (function (lambda ( a b ) (/ (+ a b) 2.0))) a b)
)

