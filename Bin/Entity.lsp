;
;
;
(defun LM:MakeSolid (p1 p2 p3 p4)
	(entmakex (list (cons 0 "SOLID")
					(cons 10 p1)
					(cons 11 p2)
					(cons 12 p3)
					(cons 13 p4))
	)
)
;
;
(defun LM:Make3DFace (p1 p2 p3 p4)
  (entmakex (list (cons 0 "3DFACE")
                  (cons 10 p1)
                  (cons 11 p2)
                  (cons 12 p3)
                  (cons 13 p4))))
;
;
(defun LM:MakeArc (cen rad sAng eAng)
  (entmakex (list (cons 0 "ARC")
                  (cons 10  cen)
                  (cons 40  rad)
                  (cons 50 sAng)
                  (cons 51 eAng))))
;
;
(defun LM:MakeAttDef (tag prmpt def pt hgt flag)
  (entmakex (list (cons 0 "ATTDEF")
                  (cons 10   pt)
                  (cons 40  hgt)
                  (cons 1   def)
                  (cons 3 prmpt)
                  (cons 2   tag)
                  (cons 70 flag))))
;
;
(defun LM:MakeCircle (cen rad)
  (entmakex (list (cons 0 "CIRCLE")
                  (cons 10 cen)
                  (cons 40 rad))))
;
;
(defun LM:MakeEllipse (cen maj ratio)
  (entmakex (list (cons 0 "ELLIPSE")
                  (cons 100 "AcDbEntity")
                  (cons 100 "AcDbEllipse")
                  (cons 10 cen)
                  (cons 11 maj)
                  (cons 40 ratio)
                  (cons 41 0)
                  (cons 42 (* 2 pi)))))
;
;
(defun LM:MakeInsert (pt Nme)
  (entmakex (list (cons 0 "INSERT")
                  (cons 2 Nme)
                  (cons 10 pt))))
;
;
(defun LM:MakeLine (p1 p2)
  (entmakex (list (cons 0 "LINE")
                  (cons 10 p1)
                  (cons 11 p2))))
;
;
(defun LM:MakeLWPoly (lst cls)
  (entmakex (append (list (cons 0 "LWPOLYLINE")
                          (cons 100 "AcDbEntity")
                          (cons 100 "AcDbPolyline")
                          (cons 90 (length lst))
                          (cons 70 cls))
                    (mapcar (function (lambda (p) (cons 10 p))) lst))))
;
;
(defun LM:MakeM-Text (pt str)
  (entmakex (list (cons 0 "MTEXT")         
                  (cons 100 "AcDbEntity")
                  (cons 100 "AcDbMText")
                  (cons 10 pt)
                  (cons 1 str))))
;
;
(defun LM:MakePoint (pt)
  (entmakex (list (cons 0 "POINT")
                  (cons 10 pt))))
;
;
(defun LM:MakePolyline (lst)
  (entmakex (list (cons 0 "POLYLINE")
                  (cons 10 '(0 0 0))))
  (mapcar
    (function (lambda (p)
                (entmake (list (cons 0 "VERTEX") (cons 10 p))))) lst)
  (entmakex (list (cons 0 "SEQEND")))
 )
;
;
(defun LM:MakeText (pt hgt str)
  (entmakex (list (cons 0 "TEXT")
                  (cons 10  pt)
                  (cons 40 hgt)
                  (cons 1  str))))
;
;
(defun XMakeText (Point TextPart HTextPart WdTextFactor Rotation Position1 Position2 Color)
 
	(if (and Point TextPart HTextPart WdTextFactor Rotation Position1 Position2 Color)
		(vla-put-Color (vlax-ename->vla-object (entmakex  (list (cons 000 "TEXT")
																(cons 100 "AcDbEntity")
																(cons 100 "AcDbText")
																(cons 010 Point)	
																(cons 040 HTextPart)
																(cons 001 TextPart)  
																(cons 050 Rotation)  
																(cons 041 WdTextFactor)  
																(cons 051 0.0)  
																(cons 007 $StyleEasyCut)
																(cons 071 0)  
																(cons 072 Position1) ; 
																(cons 011 (list (+ (nth 0 Point) 1) (nth 1 Point)))	
																(cons 073 Position2)
														))) Color)
	)
)
;
;
(defun LM:MakeTrace (p1 p2 p3 p4)
  (entmakex (list (cons 0 "TRACE")
                  (cons 10 p1)
                  (cons 11 p2)
                  (cons 12 p3)
                  (cons 13 p4))))
;
;
(defun LM:MakexLine (pt vec)
  (entmakex (list (cons 0 "XLINE")
                  (cons 100 "AcDbEntity")
                  (cons 100 "AcDbXline")
                  (cons 10 pt)
                  (cons 11 vec))))
;
;
(defun LM:MakeLayer (Nme)
  (entmake (list (cons 0 "LAYER")
                 (cons 100 "AcDbSymbolTableRecord")
                 (cons 100 "AcDbLayerTableRecord")
                 (cons 2 Nme)
                 (cons 70 0))))
;
;
(defun LM:MakeLayer (Nme Col Ltyp LWgt Plt)
  (entmake (list (cons 0 "LAYER")
                 (cons 100 "AcDbSymbolTableRecord")
                 (cons 100 "AcDbLayerTableRecord")
                 (cons 2  Nme)
                 (cons 70 0)
                 (cons 62 Col)
                 (cons 6 Ltyp)
                 (cons 290 Plt)
                 (cons 370 LWgt))))
;
;
(defun Visibility01 (Ename Flag / DxfCode)
	;
	; Flag T -> visible
	; Flag nil -> not visible
	;
	(if (setq DxfCode (entget Ename))
		(progn
			(if (assoc 60 DxfCode)
				(if Flag
					(setq DxfCode (subst '(60 . 0) (assoc 60 DxfCode) DxfCode))
					(setq DxfCode (subst '(60 . 1) (assoc 60 DxfCode) DxfCode))
				)
				(if Flag
					(setq DxfCode (append DxfCode '((60 . 0))))
					(setq DxfCode (append DxfCode '((60 . 1))))
				)
			)
			(entmod DxfCode) 
			(entupd Ename)
		)
	)
)
;
;
(defun Visibility02 (Ename Flag / Rtn)
	;
	; Flag T -> visible
	; Flag nil -> not visible
	;
	(if (entget Ename)
		(if Flag
			(vla-put-Visible (vlax-ename->vla-object Ename) :vlax-true)
			(vla-put-Visible (vlax-ename->vla-object Ename) :vlax-false)
		)	
	)
)
;
;
(defun MoveDxfCode (LstEname Start End / Point>PointEntmake
										 itm Dx Dy Dz DxfCode Ini Fin New10 New11)
	;
	; LstMode (Point Rotate Hiden ---> T = visible	 nil= not visible)
	;
	;(defun *error* (msg)
	;	(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpSymula))))))
	;	(RemoveBlock "BarEc")
	;	(RemoveBlock "TorchEc")
	;)
	;
	(defun Point>PointEntmake (Pt)
		(if Pt
			(if (= (length Pt) 2)
				(list (car Pt) (cadr Pt) 0.0)
				Pt
			)
		)
	)	
	;
	; Main
	;
	(if (and LstEname Start End)
		(progn
			(setq Start (Point>PointEntmake Start))
			(setq End 	(Point>PointEntmake End))
			(setq Dx (- (car End)  (car Start)))
			(setq Dy (- (cadr End) (cadr Start)))
			(setq DZ (- (caddr End) (caddr Start)))
			
			(foreach itm LstEname
				(setq DxfCode (entget itm))
				(cond
					((= (cdr (assoc 0 DxfCode)) "LINE")
						(setq Ini (cdr (assoc 10 DxfCode)))
						(setq Fin (cdr (assoc 11 DxfCode)))
						(setq New10 (list (+ (car Ini) Dx) (+ (cadr Ini) Dy) (+ (caddr Ini) Dz)))
						(setq New11 (list (+ (car Fin) Dx) (+ (cadr Fin) Dy) (+ (caddr Fin) Dz)))
						(setq DxfCode (subst (cons 10 New10) (assoc 10 DxfCode) DxfCode)) ; insert Poitn
						(setq DxfCode (subst (cons 11 New11) (assoc 11 DxfCode) DxfCode)) ; insert Poitn
					)
					((= (cdr (assoc 0 DxfCode)) "CIRCLE")
						(setq Ini (cdr (assoc 10 DxfCode)))
						(setq New10 (list (+ (car ini) Dx) (+ (cadr ini) Dy) (+ (caddr ini) Dz)))
						(setq DxfCode (subst (cons 10 New10) (assoc 10 DxfCode) DxfCode)) ; insert Poitn
					)
					((= (cdr (assoc 0 DxfCode)) "INSERT")
						(setq Ini (cdr (assoc 10 DxfCode)))
						(setq New10 (list (+ (car ini) Dx) (+ (cadr ini) Dy) (+ (caddr ini) Dz)))
						(setq DxfCode (subst (cons 10 New10) (assoc 10 DxfCode) DxfCode)) ; insert Poitn
					)
				)
				(entmod DxfCode) 
				(entupd itm)
			)
		)
	)
)
;
;
(defun ChangeArc2P (EnameArc PStart PEnd / Pmid Lst LstDxfCode)
	
	(if (and EnameArc PStart PEnd)
		(progn

			(setq Pmid (vlax-curve-getPointAtDist EnameArc (/ (vlax-curve-getDistAtPoint EnameArc (vlax-curve-getEndPoint EnameArc)) 2.0)))
			(setq Lst (LM:3pcircle PStart Pmid PEnd))
			(if (minusp (sin (- (angle PStart PEnd) (angle PStart Pmid))))
                (mapcar 'set '(PStart PEnd) (list PEnd PStart))
            )
			(setq LstDxfCode (entget EnameArc))
			(setq LstDxfCode (subst (cons 010 (car  Lst))               (assoc 010 LstDxfCode) LstDxfCode))
			(setq LstDxfCode (subst (cons 040 (cadr Lst))               (assoc 040 LstDxfCode) LstDxfCode))
			(setq LstDxfCode (subst (cons 050 (angle (car Lst) PStart)) (assoc 050 LstDxfCode) LstDxfCode))
			(setq LstDxfCode (subst (cons 051 (angle (car Lst) PEnd))   (assoc 051 LstDxfCode) LstDxfCode))
			(entmod LstDxfCode)
			(entupd EnameArc) 
		)
	)
)
;
;
(defun ChangeLine2P (EnameLine PStart PEnd / LstDxfCode)
	
	(if (and EnameLine PStart PEnd)
		(progn
			
			(setq LstDxfCode (entget EnameLine))
			(setq LstDxfCode (subst (cons 010 Pstart) (assoc 010 LstDxfCode) LstDxfCode))
			(setq LstDxfCode (subst (cons 011 Pend)   (assoc 011 LstDxfCode) LstDxfCode))
			(entmod LstDxfCode)
			(entupd EnameLine) 
		)
	)
)
;
;
(defun LineToPline (Ssel / var val Rtn)

	(setq 	var '("CMDECHO" "PEDITACCEPT" "QAFLAGS")
			val  (mapcar 'getvar var)
	)
	
	(if ssel
		(progn
			(if (> (sslength Ssel) 0)
				(progn
					(mapcar 'setvar var '(0 0 0))
					(Open_Block_Entity)
					(setq EnameDoubleClickGetInfo$ nil)
					(command "_PEDIT" (ssname Ssel 0) "" "_J" Ssel "" "")
					(setq Rtn (close_Block_Entity))
				)
			)
		)
	)
	(mapcar 'setvar var val)
	Rtn
)
;
;
(defun MultiLineToPline (Ssel Fuzz / var val Rtn)

	
		(setq 	var '("CMDECHO" "PEDITACCEPT" "QAFLAGS")
				val  (mapcar 'getvar var)
		)
		(if Ssel
			(progn
				;(princ (strcat "\nTrovato " (rtos (sslength Ssel) 2 0) " linee compatibili"))
				(if (> (sslength Ssel) 0)
					(progn
						(mapcar 'setvar var '(0 1 0))
						(Open_Block_Entity)
						(setq EnameDoubleClickGetInfo$ nil)
						(command "_.pedit" "_M" Ssel "" "_J" Fuzz "")
						(setq Rtn (close_Block_Entity))
					)
				)
			)
		)
		(mapcar 'setvar var val)
		Rtn
)
;
;
(defun MyPedit (Ssel Fuzz / StorageData 
							RtnData DataLine DataArc
							EnameArc PtStartArc PtEndArc
							EnameLine PtStartLine PtEndLine)

	
	
	;
	(defun StorageData (Ssel / Num Obj StartPoint EndPoint LstLine LstArc)
	
		(if Ssel
			(progn
				(setq Num 0)
			
				(repeat (sslength Ssel)
					(setq Obj (vlax-ename->vla-object (ssname Ssel Num)))
					(cond 
						((= (vlax-get-property Obj 'ObjectName) "AcDbLine")
							(setq StartPoint (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj))))
							(setq EndPoint   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   Obj))))
							(setq LstLine (append LstLine (list (cons (ssname Ssel Num) (list StartPoint EndPoint)))))
						)
						((= (vlax-get-property Obj 'ObjectName) "AcDbArc")
							(setq StartPoint (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj))))
							(setq EndPoint   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   Obj))))
							(setq LstArc (append LstArc (list (cons (ssname Ssel Num) (list StartPoint EndPoint)))))
						)
					)
					(setq Num (1+ Num))
				)
			)
		)
		(list LstLine LstArc)
	)
	
	; Main
	
	(setq RtnData (StorageData Ssel))
	(setq DataLine (car RtnData))
	(setq DataArc  (cadr RtnData))
	
	(if (and DataLine DataArc)
		(progn
			(foreach Arc DataArc

				(setq EnameArc   (car Arc))
				(setq PtStartArc (cadr Arc))
				(setq PtEndArc   (caddr Arc)) 
			
				(foreach Line DataLine
					(setq EnameLine   (car Line))
					(setq PtStartLine (cadr Line))
					(setq PtEndLine   (caddr Line))
					
					(if (<= (distance PtStartArc PtStartLine) Fuzz)
						(vlax-put-property (vlax-ename->vla-object EnameLine) 'StartPoint (vlax-3d-point PtStartArc))
					)
					(if (<= (distance PtStartArc PtEndLine)   Fuzz)
						(vlax-put-property (vlax-ename->vla-object EnameLine) 'EndPoint (vlax-3d-point PtStartArc))
					)
					(if (<= (distance PtEndArc   PtStartLine) Fuzz)
						(vlax-put-property (vlax-ename->vla-object EnameLine) 'StartPoint (vlax-3d-point PtEndArc))
					)
					(if (<= (distance  PtEndArc  PtEndLine)   Fuzz)
						(vlax-put-property (vlax-ename->vla-object EnameLine) 'EndPoint (vlax-3d-point PtEndArc))
					)
				)
			)
		)
	)
	(ForceShapeToPolyline Ssel)
)
;
;
(defun MyPedit3 (Ssel Fuzz / FindContour ChamferEntity MakePolyline
							 Loop Ename SsgetSel Sel Pline itm Rtn1 Rtn2)

	(defun FindContour (Ssel Ename Fuzz / fl in l1 l2 s2 vl)
	 
		(if (and Ssel Ename Fuzz)
			(progn
				(setq s2 (ssadd)
					  l1 (list (vlax-curve-getstartpoint Ename) (vlax-curve-getendpoint Ename))
				)
				(repeat (setq in (sslength Ssel))
					(setq Ename (ssname Ssel (setq in (1- in)))
						  vl (cons (list (vlax-curve-getstartpoint Ename) (vlax-curve-getendpoint Ename) Ename) vl)
					)
				)
				(while
					(progn
						(foreach v vl
							(if (vl-some '(lambda ( p ) (or (equal (car v) p Fuzz) (equal (cadr v) p Fuzz))) l1)
								(setq s2 (ssadd (caddr v) s2)
									  l1 (vl-list* (car v) (cadr v) l1)
									  fl t
								)
								(setq l2 (cons v l2))
							)
						)
						fl
					)
					(setq vl l2 l2 nil fl nil)
				)
				;(sssetfirst nil s2)
				(if s2
					(if (> (sslength s2) 1)
						s2
						nil
					)
				)
			)
		)
		s2
	)
	;
	;
	;
	(defun ChamferEntity (Ssel / TypeEnt StartPt EndPt MidPt MyNth SortEntity LM:3p->bulge
								 LstVxSort LstVx Pos LstVx itm) 
		;
		(defun TypeEnt (EnameEnt)
			(if EnameEnt
				(cdr (assoc 0 (entget EnameEnt)))
			)
		)
		;
		(defun StartPt (EnameEnt)
			(if EnameEnt
				(vlax-get (vlax-ename->vla-object EnameEnt) 'Startpoint)
			)
		)
		;
		(defun EndPt (EnameEnt)
			(if EnameEnt
				(vlax-get (vlax-ename->vla-object EnameEnt) 'Endpoint)
			)
		)
		;
		(defun MidPt (EnameArc)
			(if EnameArc
				(vlax-curve-getPointAtDist EnameArc
					(/ (vlax-curve-getDistAtPoint EnameArc (vlax-curve-getEndPoint EnameArc)) 2.0)
				)
			)
		)
		;
		(defun MyNth (Lst N)
			(if (<= (1+ N) (length Lst))
				(nth N Lst)
			)
		)
		
		;
		(defun SortEntity (LstEname Fuzz / Ps Pe LstEname Find Pos Rtn)
		
			(if LstEname
				(progn
					
					(setq Ps (StartPt (car LstEname)))
					(setq Pe (EndPt   (car LstEname)))

					(cond
						((= (TypeEnt (car LstEname)) "LINE")
							(setq Rtn (list (list Ps Pe)))
						)
						((= (TypeEnt (car LstEname)) "ARC")
							(setq Rtn (list (list Ps (MidPt (car LstEname)) Pe)))
						)
					)
					;(princ "\n Ename ") (princ (car LstEname)) (princ Rtn) (getstring "--")
					(setq LstEname (vl-remove (car LstEname) LstEname))
					(setq Pos 0)
					
					(while LstEname
						
						(cond 
							((equal Pe   (StartPt (nth Pos LstEname)) Fuzz)
								(cond
									((= (TypeEnt (nth Pos LstEname)) "LINE")
										(setq Rtn (append Rtn (list (list (StartPt (nth Pos LstEname)) (EndPt (nth Pos LstEname)))))))
									((= (TypeEnt (nth Pos LstEname)) "ARC")
										(setq Rtn (append Rtn (list (list (StartPt (nth Pos LstEname)) (MidPt (nth Pos LstEname)) (EndPt (nth Pos LstEname)))))))
								)
								(setq Pe (EndPt (nth Pos LstEname)))
								(setq Find T)
							)
							((equal Pe   (EndPt (nth Pos LstEname)) Fuzz)
								(cond
									((= (TypeEnt (nth Pos LstEname)) "LINE")
										(setq Rtn (append Rtn (list (list (EndPt (nth Pos LstEname)) (StartPt (nth Pos LstEname)))))))
									((= (TypeEnt (nth Pos LstEname)) "ARC")
										(setq Rtn (append Rtn (list (list (EndPt (nth Pos LstEname)) (MidPt (nth Pos LstEname)) (StartPt (nth Pos LstEname)))))))
								)
								(setq Pe (StartPt (nth Pos LstEname)))
								(setq Find T)
							)
							((equal Ps   (StartPt (nth Pos LstEname)) Fuzz)
								(cond
									((= (TypeEnt (nth Pos LstEname)) "LINE")
										(setq Rtn (append (list (list (EndPt (nth Pos LstEname)) (StartPt (nth Pos LstEname)))) Rtn)))
									((= (TypeEnt (nth Pos LstEname)) "ARC")
										(setq Rtn (append (list (list (EndPt (nth Pos LstEname)) (MidPt (nth Pos LstEname)) (StartPt (nth Pos LstEname)))) Rtn)))
								)
								(setq Ps (EndPt (nth Pos LstEname)))
								(setq Find T)
							)
							((equal Ps   (EndPt (nth Pos LstEname)) Fuzz)
								(cond
									((= (TypeEnt (nth Pos LstEname)) "LINE")
										(setq Rtn (append (list (list (StartPt (nth Pos LstEname)) (EndPt (nth Pos LstEname)))) Rtn)))
									((= (TypeEnt (nth Pos LstEname)) "ARC")
										(setq Rtn (append (list (list (StartPt (nth Pos LstEname)) (MidPt (nth Pos LstEname)) (EndPt (nth Pos LstEname)))) Rtn)))
								)
							    (setq Ps (StartPt (nth Pos LstEname)))
								(setq Find T)
							)
						)
						
						
						(if Find
							(progn
								;(princ "\n Ename ") (princ (nth Pos LstEname)) (princ Rtn) (getstring "--")
								(setq LstEname (vl-remove (nth Pos LstEname) LstEname))
								(setq Pos 0)
								(setq Find nil)
							)
							(progn
								(setq Pos (1+ Pos))
								(if (not (MyNth LstEname Pos))
									(setq LstEname nil)
								)
							)
						)
					)
				)
			)
			Rtn
		)
		;
		(defun LM:3p->bulge ( pt1 pt2 pt3 )
			((lambda ( a ) (/ (sin a) (cos a))) (/ (+ (- pi (angle pt2 pt1)) (angle pt2 pt3)) 2))
		)
		;
		; Main
		;
		(setq LstVxSort (SortEntity (LM:ss->ent Ssel) $OverlappAcuracyPoint))
		
		(if LstVxSort 
			(progn
				(setq LstVx (list (car LstVxSort )))
				(setq Pos 1)
				(repeat (- (length LstVxSort) 1)
					(cond
						((= (length (nth Pos LstVxSort)) 2)
							(setq LstVx (append LstVx (list (list (last (nth (- Pos 1) LstVxSort))
																		(cadr (nth Pos LstVxSort))))))
						)
						((= (length (nth Pos LstVxSort)) 3)
							(setq LstVx (append LstVx (list (list (last (nth (- Pos 1) LstVxSort))
																		(cadr (nth Pos LstVxSort))
																		(caddr (nth Pos LstVxSort))))))
						)
					)
					(setq Pos (1+ Pos))
				)
				(setq xx LstVx)
				
				(if (< (distance (car (nth 0 LstVx)) (last (nth (- (length LstVx) 1) LstVx))) $MaxOpenPolyline)
					(cond 
						((= (length (nth 0 LstVx)) 2)
							(setq LstVx (append (list (list (last (nth (- (length LstVx) 1) LstVx))
															(cadr (nth 0 LstVx))
													  )
												)
												(cdr LstVx))))
						((= (length (nth 0 LstVx)) 3)
							(setq LstVx (append (list (list (last (nth (- (length LstVx) 1) LstVx))
															(cadr (nth 0 LstVx))
															(caddr (nth 0 LstVx))
													  )
												)
												(cdr LstVx))))
												
					)
				)
				
			)
		)
		LstVx
	)
	;
	;
	;
	(defun MakePolyline (LstVx / MakeCons42 
								 LstLwPoly Pos itm)
	
		(defun MakeCons42 (pt)
			(cond 
				((= (length pt) 2)
					(cons 42 0.0)
				)
				((= (length pt) 3)
					(cons 42 (LM:3p->bulge (car pt) (cadr pt) (caddr pt)))
				)
			)
		)
		;
		(if LstVx
			(progn
				(if (> (distance (car (nth 0 LstVx)) (last (nth (- (length LstVx) 1) LstVx))) 0)
					(setq Closed 0)
					(setq Closed 1)
				)
				
				(setq LstLwPoly (list (cons 0 "LWPOLYLINE")
									  (cons 100 "AcDbEntity")
									  (cons 100 "AcDbPolyline")
									  (cons 90 (length LstVx))
									  (cons 70 Closed)))
				(foreach itm LstVx
					(setq LstLwPoly (append LstLwPoly (list (list 10 (car (car itm)) (cadr (car itm)))
															(cons 40 0.0)
															(cons 41 0.0)
															(MakeCons42 itm))))
				)
				(if (=  Closed 0)
					(cond 
						((= (length (last LstVx)) 2)
							(setq LstLwPoly (append LstLwPoly (list (list 10 (car (cadr (last LstVx))) (cadr (cadr (last LstVx))))															(cons 40 0.0)
																	(cons 41 0.0)
																	(cons 42 0.0))))
						)
						((= (length (last LstVx)) 3)
							(setq LstLwPoly (append LstLwPoly (list (list 10 (car (caddr (last LstVx))) (cadr (caddr (last LstVx))))															(cons 40 0.0)
																	(cons 41 0.0)
																	(cons 42 0.0))))
						)
					)
				)
			)
		)
		(if LstLwPoly (entmakex LstLwPoly))
	)
	;
	; Main
	;
	(if Ssel
		(progn
			(setq Loop T)
			(setq SsgetSel (FilterEntitySelectionByObjectName Ssel (list "AcDbLine" "AcDbArc")))
			
			(while (> (sslength SsgetSel) 0)
			
				(setq Ename (ssname SsgetSel 0))
				(if (setq Sel (FindContour SsgetSel Ename Fuzz))
					(cond 
						((> (sslength Sel) 1)
							(setq LstVx   (ChamferEntity Sel))
							(if LstVx 	  (setq EnamePoly (MakePolyline LstVx)))
							(if EnamePoly (setq Rtn1 (append Rtn1 (list EnamePoly))))
							(foreach itm (LM:ss->ent Sel) (ssdel itm SsgetSel))
						)
						(t
							(foreach itm (LM:ss->ent Sel) (ssdel itm SsgetSel))
							(foreach itm (LM:ss->ent Sel)
								(setq Rtn2 (append Rtn2 (list itm)))
							)
						)
					)
					(progn
						(setq Rtn2 (append Rtn2 (list Ename)))
						(ssdel Ename SsgetSel)
					)
				)
			)
			; Remove entity
			(foreach itm (LM:ss->ent (FilterEntitySelectionByObjectName Ssel (list "AcDbLine" "AcDbArc")))
				(if (not (member itm Rtn2))
					(DeleteEntity (list itm))
				)
			)
		)
	)
	(list Rtn1 Rtn2)
)
;
;
(defun Line&ArcToPline (Ssel Flag / Itm LstTmpCopy Rtn)

	(foreach Itm (LM:ss->ent Ssel) 
		(setq LstTmpCopy (cons (vlax-vla-object->ename (vla-copy (vlax-ename->vla-object Itm))) LstTmpCopy))
	)
	(setq Rtn (LineToPline (LstEname->Ssget LstTmpCopy)))
	
	(cond 
		((car Rtn)
			(if (or (= (vla-get-closed (vlax-ename->vla-object (car Rtn))) :vlax-true)
					(= (- (cdr (assoc 90 (entget (car Rtn)))) 1) (length LstTmpCopy))
				)
				(progn 
					(setq Rtn (car Rtn))
					(if Flag (DeleteSsel Ssel))
				)
				(progn
					(entdel (car Rtn))
					(setq Rtn nil)
					(DeleteEntity LstTmpCopy)
				)
			)
		)
		(t
			(setq Rtn nil)
			(DeleteEntity LstTmpCopy)
		)
	)
	Rtn
)
;
;
;; Gilles Chanteau- 01/01/07
(defun LineAndArc2LwPolyline (LstEname Flag / 	*error* ArcBulge Space
												Norm olst blst dlst plst tlst blg Pline LstObject Rtn)

	;
	(defun *error* (msg)
		(if (/= msg "Function cancelled")
		(princ (strcat "\nError: " msg)))
		(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
		(princ)
	)
	;
	(defun ArcBulge (arc)
		(/ (sin (/ (vla-get-TotalAngle arc) 4))
		(cos (/ (vla-get-TotalAngle arc) 4)))
	)
	;
	; Main
	;
	(if LstEname
		(progn
			(setq Space (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object))))
			(setq LstObject (mapcar '(lambda (x) (vlax-ename->vla-object x)) LstEname))
			(setq olst (mapcar '(lambda (x) (list x (vlax-get x 'StartPoint) (vlax-get x 'EndPoint))) LstObject))
			
			(while olst
				(setq blst nil)
				(if (= (vla-get-ObjectName (caar olst)) "AcDbArc")
					(setq blst (list (cons 0 (ArcBulge (caar olst)))))
				)
				(setq plst (cdar olst)
					  dlst (list (caar olst))
					  olst (cdr olst)
				)
				(while (setq tlst (vl-member-if '(lambda (x) (or (equal (last plst) (cadr x) 1e-9) (equal (last plst) (caddr x) 1e-9)))	olst))
					(if (equal (last plst) (caddar tlst) 1e-9)
						(setq blg -1)
						(setq blg 1)
					)
					(if (= (vla-get-ObjectName (caar tlst)) "AcDbArc")
						(setq blst (cons (cons (1- (length plst)) (* blg (arcbulge (caar tlst)))) blst))
					)
					(setq plst (append plst	(if (minusp blg) (list (cadar tlst)) (list (caddar tlst))))
						  dlst (cons (caar tlst) dlst)
						  olst (vl-remove (car tlst) olst)
					)
				)
				
				;(setq pline (vlax-invoke Space 'addLightWeightPolyline 	(apply 'append 	(mapcar '(lambda (x) (setq x (trans x 0 Norm))	(list (car x) (cadr x)))
				;																							 (reverse (cdr (reverse plst)))))))
				
				(setq Pline (vlax-invoke Space 'addLightWeightPolyline 	(apply 'append 	(mapcar '(lambda (x) x (list (car x) (cadr x)))
																											   (reverse (cdr (reverse plst)))
																						)
																		)
							)
				)
				(vla-put-Closed Pline :vlax-true)
				(mapcar '(lambda (x) (vla-setBulge pline (car x) (cdr x))) blst)
				;(vla-put-Elevation pline (caddr (trans (car plst) 0 Norm)))
				;(vla-put-Normal pline (vlax-3d-point Norm))
				(if Flag (mapcar 'vla-delete dlst))
				(setq Rtn (append Rtn (list Pline)))
			)

		)
	)
	Rtn
)
;
;
(defun ForceShapeToPolyline (Ssel / LstEname itm co nv Dist Rtn Out)

	(if Ssel
		(progn
			(setq LstEname (MultiLineToPline Ssel "0.00000"))
			(foreach itm LstEname
				(if (= (vla-get-closed (vlax-ename->vla-object itm)) :vlax-true)
					(setq Rtn (append Rtn (list itm)))
					(if (< (distance (vlax-curve-getstartpoint itm) (vlax-curve-getendpoint itm)) 1.0)
						(progn
							(vla-put-closed (vlax-ename->vla-object itm) :vlax-true)
							(setq Rtn (append Rtn (list itm)))
						)
						(entdel itm)
					)
				)
			)
		)
	)
	(foreach itm Rtn
		(setq Out (append out (list (PurgePolyline itm))))
	)
	Out
)
;
;
(defun PurgePolyline (Ename)
	(if Ename
		(progn
			(RemoveDuplicatePointLwPolyline Ename)
			(SimpleLwPolyLine Ename nil)
			;(RemoveColinearLwPolyline Ename)
		)
	)
	Ename
)
;
;
(defun RemoveDuplicatePointLwPolyline (Ename / LstDxf Co Num LstCo Close Rtn)

	(if Ename
		(progn
			(setq LstDxf (entget Ename (list "*")))
			(setq Co     (LM:lwvertices (Entget Ename)))
			(setq Num     0)
			
			(repeat (- (length Co) 1)
				(if (> (distance (cdr (assoc 10 (nth Num Co))) (cdr (assoc 10 (nth (+ Num 1) Co)))) 0.01)
					(setq LstCo (append LstCo (nth Num Co)))
				)
				(setq Num (1+ Num))
			)
			(setq LstCo (append LstCo (nth (- (length Co) 1) Co)))
			
			(if (<= (distance (cdr (assoc 10 (nth 0 Co))) (cdr (assoc 10 (nth (- (length Co) 1) Co)))) 0.01)
				(progn
					(setq LstCo (LM:RemoveNth (- (length LstCo) 1)  LstCo))
					(setq LstCo (LM:RemoveNth (- (length LstCo) 1)  LstCo))
					(setq LstCo (LM:RemoveNth (- (length LstCo) 1)  LstCo))
					(setq LstCo (LM:RemoveNth (- (length LstCo) 1)  LstCo))
					(setq Close T)
				)
			)
			
			(setq Rtn (vl-remove-if  '(lambda (pair) (member (car pair) '(10 40 41 42 91 210 -3))) LstDxf))
			(setq Rtn (subst (cons 90 (/ (length LstCo) 4)) (assoc 90 Rtn) Rtn))	; n. vertici	
			(if Close (setq Rtn (subst (cons 70 1) (assoc 70 Rtn) Rtn)))
			
			(setq Rtn (append Rtn LstCo))
			(setq Rtn (append Rtn (list (assoc 210 LstDxf))))
			(if (assoc -3 LstDxf) (setq Rtn (append Rtn (list (assoc -3 LstDxf)))))
			(entmod Rtn)
			(entupd Ename)
			;(entdel Ename)
			;(setq Rtn (entmakex NewLstPoly))
		)
	)
	Ename
)
;
;
(defun MakeBlock (BlockName LstEname Point / itm LstObject Doc BlkObj Array)


	(if (and BlockName LstEname)
		(progn
			(PurgeBlock BlockName)
			(foreach itm LstEname
				(setq LstObject (append LstObject (list (vlax-ename->vla-object itm))))
			)
			(setq Doc (vla-get-activedocument (vlax-get-acad-object)))
			(setq BlkObj (vla-add (vla-get-blocks doc) (vlax-3d-point Point) BlockName))
			(setq Array  (vlax-safearray-fill (vlax-make-safearray vlax-vbObject (cons 0 (1- (length LstObject)))) LstObject))
			(vla-copyobjects doc Array BlkObj)
		)
	)
	BlkObj
)
;
;
(defun MakeWblock (FileName LstEname / itm Acdoc NameSet Ssets Sset Objlist Rtn)
 

	(if (and FileName LstEname)
		(progn
			(setq Acdoc 	(vla-get-activedocument (vlax-get-acad-object)))
			(setq NameSet  	"MY_WBLOCK_SET")
			(setq Ssets 	(vla-get-selectionsets Acdoc))

			(if (vl-catch-all-error-p 
				(vl-catch-all-apply 'vla-item (list Ssets NameSet)))
		
				(setq Sset (vla-add Ssets NameSet))	
				
				(progn
					(vla-delete (vla-item Ssets NameSet))
					(setq Sset (vla-add Ssets NameSet))
				)
			)
			(setq Objlist (LstEname->LstObj LstEname))
			(vla-additems Sset 
				(vlax-safearray-fill 
					(vlax-make-safearray vlax-vbobject (cons 0 (1- (length Objlist)))) 
					Objlist
				)
			)
			(vl-catch-all-error-p (vl-catch-all-apply 'vla-Wblock (list Acdoc FileName Sset)))
		)
	)
)
;
;
(defun c:al-wblock ( / thisdrawing ssets newSet)
	
	(setq thisdrawing (vla-get-activedocument (vlax-get-acad-object)))
	(setq ssets (vla-get-selectionsets thisdrawing))
	
	(if (vl-catch-all-error-p 
		(vl-catch-all-apply 'vla-item (list ssets "$Set")))
		
			(setq newSet (vla-add ssets "$Set"))
		(progn
           	(vla-delete (vla-item ssets "$Set"))
			(setq newSet (vla-add ssets "$Set"))
       
		);progn
	);if

;select all objects in the drawing
(vla-Select newSet acSelectionSetAll)

(vla-WBlock thisdrawing "c:\\tmp\\test.dwg" newSet)

(princ)

);defun
;
;
(defun MakeArc3Pt (P1 P2 P3 / Lst Rtn)

	(if (and P1 P2 P3)
		(progn
			(setq ocs (trans '(0 0 1) 1 0 t))
			(if (setq Lst (LM:3pcircle P1 P2 P3))
				(progn
					(if (minusp (sin (- (angle P1 P3) (angle P1 P2))))
						(mapcar 'set '(P1 P3) (list P3 P1))
					)
					(setq Rtn (entmakex (list 	'(000 . "ARC")
												(cons 010 (trans (car lst) 1 ocs))
												(cons 040 (cadr lst))
												(cons 050 (angle (trans (car lst) 1 ocs) (trans P1 1 ocs)))
												(cons 051 (angle (trans (car lst) 1 ocs) (trans P3 1 ocs)))
												(cons 210 ocs)
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
(defun MakePoint (LstPoint / mspace itm point)
	(if LstPoint
		(progn
			(setq mspace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
			(foreach itm LstPoint
				(setq Rtn (append Rtn (list (vlax-vla-object->ename (vla-AddPoint mspace (vlax-3d-point itm))))))
			)
		)
	)
)
;
;
(defun MakePolyline (LstPoint Close / itm EnamePoly Rtn)
	(if LstPoint
		(progn
			(setq Rtn nil)
			(foreach itm LstPoint
				(setq Rtn (append Rtn (list (list (nth 0 itm) (nth 1 itm)))))
			)
			(setq EnamePoly (entmakex (append	(list 	'(0 . "LWPOLYLINE")
														'(100 . "AcDbEntity")
														'(100 . "AcDbPolyline")
														(cons 90 (length Rtn))
												) ;_ list
												(mapcar (function (lambda (x) (cons 10 x))) Rtn)

										) ;_ append
							) ;_ entmakex		
			)
			(if Close (vla-put-Closed (vlax-ename->vla-object EnamePoly) :vlax-true))
		)
	)
	EnamePoly
)
;
;
(defun MakeRectangle (Origin Width Height)
	(MakePolyline 	(list 	(list 	(car  Origin)
									(cadr Origin)
							)
							(list 	(+ (car Origin) Width)
									(cadr Origin)
							)
							(list 	(+ (car  Origin) Width)
									(+ (cadr Origin) Height)
							)
							(list 	(car  Origin)
									(+ (cadr Origin) Height)
							)
							;(list 	(car  Origin)
							;		(cadr Origin)
							;)
					) T)	
)
;
;
(defun MakeRectangle02 (PtStart PtEnd)
	(MakePolyline 	(list 	(list 	(car  PtStart)
									(cadr PtStart)
							)
							(list 	(car PtEnd)
									(cadr PtStart)
							)
							(list 	(car  PtEnd)
									(cadr PtEnd)
							)
							(list 	(car  PtStart)
									(cadr PtEnd)
							)
					) T)	
)
;
;
(defun MakeDimStyleToSetvar (DimStyleName DimScale DimHtext DimStyleText DimAnnotative / MakeStyleDim
																						 VarDim TmpDimStyleName Rtn
																						 ArrowSize CenterMarkSize DecimalPlaces RoundingValue
																						 DimensionLineSpacing ExtensionAboveDimensionLine ExtensionLineOriginOffset
																						 GapFromDimensionLineToText TextMovement LinearUnitScaleFactor
																						 AngularDecimalPlaces ExtensionDimensionLine NameArrow
																						 ColorDimensionLineAndLeader ColorExtensionLine ColorDimensionText)

; "." closed filled		"_DOT" dot				"_DOTSMALL" dot small	"_DOTBLANK" dot blank		"_ORIGIN" origin indicator				"_ORIGIN2" origin indicator 2
; "_OPEN" open			"_OPEN90" right angle	"_OPEN30" open 30		"_CLOSED" closed			"_SMALL" dot small blank				"_NONE" none
; "_OBLIQUE" oblique	"_BOXFILLED" box filled	"_BOXBLANK" box			"_CLOSEDBLANK" closed blank	"_DATUMFILLED" datum triangle filled	"_DATUMBLANK" datum triangle
; "_INTEGRAL" integral	"_ARCHTICK" architectural tick

	(defun MakeStyleDim (FontTextStyle NameTextStyle TextHeigth TextWidth)

		(if (and FontTextStyle NameTextStyle TextHeigth TextWidth)
			(entmakex
				(list
					(cons 0 "STYLE") 
					(cons 100 "AcDbSymbolTableRecord") 
					(cons 100 "AcDbTextStyleTableRecord") 
					(cons 2 NameTextStyle)	;; Style Name
					(cons 70 0)
					(cons 40 TextHeigth)	;; Fixed text height
					(cons 41 TextWidth)		;; Width Factor
					(cons 50 0.0)			;; Oblique angle
					(cons 71 0)
					(cons 42 2.0)			;; Last height used
					(cons 3 FontTextStyle)	;; Primary font name 
					(cons 4 "")				;;  Big font name
				)
			)
		)
	)
	;
	; Main
	;
	(if (tblsearch "DIMSTYLE" DimStyleName) (alert (strcat "Dim Style " DimStyleName " esistente !")))

	(if (and DimStyleName DimScale DimHtext DimStyleText DimAnnotative (not (tblsearch "DIMSTYLE" DimStyleName)))
		(progn
		
			(setq ArrowSize 					1.5)		; DIMASZ dimensione freccia
			(setq NameArrow 		    "_ARCHTICK")		; DIMBLK nome freccia
			(setq CenterMarkSize				1.0)		; DIMCEN dimensione centro Marker 
			(setq DecimalPlaces					1)			; DIMDEC numero decimali dimensione lineare
			(setq RoundingValue					0.5)		; DIMRND tolleranza dimensione lineare
			(setq LinearUnitScaleFactor			1.0)		; DIMLFAC scala unità lineare
			(setq AngularDecimalPlaces			3)			; DIMADEC numero decimali dimensione angolare
			(setq DimensionLineSpacing			5.0)		; DIMDLI spaziatura nelle quote baseline	
			(setq ExtensionAboveDimensionLine	1.0)		; DIMEXE esetensione sopra la linea di quota
			(setq ExtensionLineOriginOffset		0.0)		; DIMEXO distanza dall'origine quota
			(setq ExtensionDimensionLine		1.0) 		; DIMDLE estensione linea dimensione
			(setq GapFromDimensionLineToText	1.25)		; DIMGAP distanza testo dalla linea di estensione
			(setq ColorDimensionLineAndLeader	1)			; DIMCLRD colore line dimensione e leader
			(setq ColorExtensionLine			1)			; DIMCLRE colore line estensione
			(setq ColorDimensionText			3)			; DIMCLRT colore testo
			(setq TextMovement					0)			; DIMTMOVE 0 Allinea la linea di quota con il relativo testo
															; DIMTMOVE 1 Aggiunge una direttrice quando viene spostato il testo di quota
															; DIMTMOVE 2 Permette di spostare liberamente il testo senza una direttrice

			(if (not (tblsearch "STYLE" DimStyleText))
				(MakeStyleDim "Romans.shx" DimStyleText 0 0.8)
			)
			
			(setq TmpDimStyleName (Random_Str 7))
			(if (= DimAnnotative "0")
				(command "_DimStyle" "_An" "_No"  TmpDimStyleName "" TmpDimStyleName)
				(command "-Dimstyle" "_An" "_Yes" TmpDimStyleName "" TmpDimStyleName) 
			)
			
			(if (= DimAnnotative "0")
				(setvar "DIMSCALE" 	DimScale				)	;>	Dim scale
			)
			(setvar "DIMTXT" 	DimHtext					)	;>	Text height
			(setvar "DIMTXSTY" 	DimStyleText				)	;>	Text style
			(setvar "DIMASSOC" 	1							)	;   Create dimension objects
			(setvar "DIMADEC" 	AngularDecimalPlaces		)	;>	Angular decimal places
			(setvar "DIMALT" 	0							)	;>	Alternate units selected
			(setvar "DIMALTD" 	2							)	;>	Alternate unit decimal places
			(setvar "DIMALTF" 	25.4000						) 	;>	Alternate unit scale factor
			(setvar "DIMALTRND" 0.0000						)	;>	Alternate units rounding value
			(setvar "DIMALTTD" 	2							)	;>	Alternate tolerance decimal places
			(setvar "DIMALTTZ" 	0							) 	;>	Alternate tolerance zero suppression
			(setvar "DIMALTU" 	2							) 	;>	Alternate units
			(setvar "DIMALTZ" 	0							) 	;>	Alternate unit zero suppression
			(setvar "DIMAPOST" 	""							) 	;>	Prefix and suffix for alternate text
			(setvar "DIMATFIT" 	3							) 	;>	Arrow and text fit 
			(setvar "DIMAUNIT"	0							) 	;>	Angular unit format
			(setvar "DIMAZIN" 	0							) 	;>	Angular zero supression
			(setvar "DIMBLK" 	NameArrow					) 	;>	Arrow block name
			(setvar "DIMBLK1" 	"."							) 	;>	First arrow block name
			(setvar "DIMBLK2" 	"."							) 	;>	Second arrow block name
			(setvar "DIMCLRD" 	ColorDimensionLineAndLeader	) 	;>	Dimension line and leader color
			(setvar "DIMCLRE" 	ColorExtensionLine			) 	;>	Extension line color
			(setvar "DIMCLRT" 	ColorDimensionText			)	;>	Dimension text color
			(setvar "DIMDLE" 	ExtensionDimensionLine		)	;>	Dimension line extension
			(setvar "DIMDLI" 	DimensionLineSpacing		)	;>	Dimension line spacing
			(setvar "DIMDSEP" 	"."							)	;>	Decimal separator 
			(setvar "DIMFRAC" 	0							)	;>	Fraction format
			(setvar "DIMJUST" 	0							)	;>	Justification of text on dimension line
			(setvar "DIMLDRBLK" "."							)	;>	Leader block name
			(setvar "DIMLFAC" 	LinearUnitScaleFactor		)	;>	Linear unit scale factor
			(setvar "DIMLIM" 	0							)	;>	Generate dimension limits
			(setvar "DIMLWD" 	-2							)	;>	Dimension line and leader lineweight
			(setvar "DIMLWE" 	-2							)	;>	Extension line lineweight
			(setvar "DIMRND" 	RoundingValue				)	;>	Rounding value 
			(setvar "DIMSAH" 	0							)	;>	Separate arrow blocks
			(setvar "DIMSD1" 	0							) 	;>	Suppress the first dimension line
			(setvar "DIMSD2" 	0							) 	;>	Suppress the second dimension line
			(setvar "DIMSE1" 	0							) 	;>	Suppress the first extension line
			(setvar "DIMSE2" 	0							) 	;>	Suppress the second extension line
			(setvar "DIMSOXD" 	0							) 	;>	Suppress outside dimension lines
			(setvar "DIMTAD" 	1							) 	;>	Place text above the dimension line
			(setvar "DIMTDEC" 	1							) 	;>	Tolerance decimal places
			(setvar "DIMTFAC" 	1.0000						) 	;>	Tolerance text height scaling factor
			(setvar "DIMTIH" 	0							)	;>	Text inside extensions is horizontal
			(setvar "DIMTIX" 	1							)	;>	Place text inside extensions
			(setvar "DIMTM" 	0.0000						)	;>	Minus tolerance
			(setvar "DIMTMOVE" 	TextMovement				)	;>	Text movement
			(setvar "DIMTOFL" 	1							) 	;>	Force line inside extension lines
			(setvar "DIMTOH" 	0							)	;>	Text outside horizontal
			(setvar "DIMTOL" 	0							) 	;>	Tolerance dimensioning
			(setvar "DIMTOLJ" 	1							) 	;>	Tolerance vertical justification
			(setvar "DIMTP" 	0.0000						) 	;>	Plus tolerance 
			(setvar "DIMTSZ" 	0.0000						) 	;>	Tick size
			(setvar "DIMTVP" 	0.0000						) 	;>	Text vertical position
			(setvar "DIMTZIN" 	0							) 	;>	Tolerance zero suppression
			(setvar "DIMUPT" 	0							)	;>	User positioned text
			(setvar "DIMZIN" 	12							) 	;>	Zero suppression
			(setvar "DIMLUNIT" 	2							) 	;>	Unit format
			(setvar "DIMDEC" 	DecimalPlaces				) 	;>	Decimal places
			(setvar "DIMPOST" 	""							) 	;>	Prefix and suffix for dimension text
			(setvar "DIMASZ" 	ArrowSize					) 	;>	Arrow size
			(setvar "DIMCEN" 	CenterMarkSize				) 	;>	Center mark size
			(setvar "DIMEXE" 	ExtensionAboveDimensionLine	) 	;>	Extension above dimension line
			(setvar "DIMEXO" 	ExtensionLineOriginOffset	) 	;>	Extension line origin offset
			(setvar "DIMGAP" 	GapFromDimensionLineToText	) 	;>	Gap from dimension line to text
			(setvar "DIMARCSYM" 		0					)	;>	Controls display of the arc symbol in an arc length dimension.
			(setvar "DIMFIT"			3					)	;>	
			(setvar "DIMFXL"		1.0000					)	;>	Sets the total length of the extension lines starting from the dimension line toward the dimension origin
			(setvar "DIMFXLON"			0					)	;>	Controls whether extension lines are set to a fixed length
			(setvar "DIMJOGANG"		(/ (* 45.0 PI) 180.0)	)	;>	Determines the angle of the transverse segment of the dimension line in a jogged radius dimension
			(setvar "DIMLTEX1"			"."					)	;	Sets the linetype of the first extension line
			(setvar "DIMLTEX2"			"."					)	;	Sets the linetype of the second extension line
			(setvar "DIMLTYPE"			"."					)	;	Sets the linetype of the dimension line
			(setvar "DIMSHO"			1					)	;	Suppress outside dimension lines
			(setvar "DIMTFILL"			1					)	;>	Controls the background of dimension text
			(setvar "DIMTFILLCLR"		0					)	;>	Sets the color for the text background in dimensions
			(setvar "DIMTXTDIRECTION"	0					)	;>	Specifies the reading direction of the dimension text
			(setvar "DIMUNIT"			2					)	;>	
									
			(if (= DimAnnotative "0")
				(command "_DimStyle" "_An" "_No"  DimStyleName "" DimStyleName)
				(command "-Dimstyle" "_An" "_Yes" DimStyleName "" DimStyleName) 
			)
			(setq acdoc (vla-get-activedocument (vlax-get-acad-object)))
			(vl-catch-all-apply 'vla-delete (list (vla-item (vla-get-dimstyles acdoc) TmpDimStyleName)))
			
			(if (tblsearch "DIMSTYLE" DimStyleName)
				(princ (strcat "\n" DimStyleName " is now the current Dimstyle"))
			;	(vla-put-activedimstyle acdoc (vla-item (vla-get-dimstyles acdoc) DimStyleName)
			;	)
			)
			;(RestoreVarDwg Rtn)
		)
	)
)
;
;
(defun MakeDimStyleToEntmake (DimStyleName DimScale DimHtext DimStyleText DimAnnotative / MakeStyleDim acdoc LstDxfDim EnameDim OldDimBlk
																						  ArrowSize CenterMarkSize DecimalPlaces RoundingValue
																						  DimensionLineSpacing ExtensionAboveDimensionLine ExtensionLineOriginOffset
																						  GapFromDimensionLineToText TextMovement LinearUnitScaleFactor
																						  AngularDecimalPlaces ExtensionDimensionLine NameArrow
																						  ColorDimensionLineAndLeader ColorExtensionLine ColorDimensionText)

; "." closed filled		"_DOT" dot				"_DOTSMALL" dot small	"_DOTBLANK" dot blank		"_ORIGIN" origin indicator				"_ORIGIN2" origin indicator 2
; "_OPEN" open			"_OPEN90" right angle	"_OPEN30" open 30		"_CLOSED" closed			"_SMALL" dot small blank				"_NONE" none
; "_OBLIQUE" oblique	"_BOXFILLED" box filled	"_BOXBLANK" box			"_CLOSEDBLANK" closed blank	"_DATUMFILLED" datum triangle filled	"_DATUMBLANK" datum triangle
; "_INTEGRAL" integral	"_ARCHTICK" architectural tick

	(defun MakeStyleDim (FontTextStyle NameTextStyle TextHeigth TextWidth)

		(if (and FontTextStyle NameTextStyle TextHeigth TextWidth)
			(entmakex
				(list
					(cons 0 "STYLE") 
					(cons 100 "AcDbSymbolTableRecord") 
					(cons 100 "AcDbTextStyleTableRecord") 
					(cons 2 NameTextStyle)	;; Style Name
					(cons 70 0)
					(cons 40 TextHeigth)	;; Fixed text height
					(cons 41 TextWidth)		;; Width Factor
					(cons 50 0.0)			;; Oblique angle
					(cons 71 0)
					(cons 42 2.0)			;; Last height used
					(cons 3 FontTextStyle)	;; Primary font name 
					(cons 4 "")				;;  Big font name
				)
			)
		)
	)
	;
	; Main
	;
	;(if (tblsearch "DIMSTYLE" DimStyleName) (alert (strcat "Dim Style " DimStyleName " esistente !")))
	
	(if (and DimStyleName DimScale DimHtext DimStyleText DimAnnotative (not (tblsearch "DIMSTYLE" DimStyleName)))
		(progn

			(setq ArrowSize 					1.5)		; DIMASZ dimensione freccia
			(setq NameArrow 		    "_ARCHTICK")		; DIMBLK nome freccia
			(setq CenterMarkSize				1.0)		; DIMCEN dimensione centro Marker 
			(setq DecimalPlaces					1)			; DIMDEC numero decimali dimensione lineare
			(setq RoundingValue					0.5)		; DIMRND tolleranza dimensione lineare
			(setq LinearUnitScaleFactor			1.0)		; DIMLFAC scala unità lineare
			(setq AngularDecimalPlaces			3)			; DIMADEC numero decimali dimensione angolare
			(setq DimensionLineSpacing			5.0)		; DIMDLI spaziatura nelle quote baseline	
			(setq ExtensionAboveDimensionLine	1.0)		; DIMEXE esetensione sopra la linea di quota
			(setq ExtensionLineOriginOffset		0.0)		; DIMEXO distanza dall'origine quota
			(setq ExtensionDimensionLine		1.0) 		; DIMDLE estensione linea dimensione
			(setq GapFromDimensionLineToText	1.25)		; DIMGAP distanza testo dalla linea di estensione
			(setq ColorDimensionLineAndLeader	1)			; DIMCLRD colore line dimensione e leader
			(setq ColorExtensionLine			1)			; DIMCLRE colore line estensione
			(setq ColorDimensionText			3)			; DIMCLRT colore testo
			(setq TextMovement					0)			; DIMTMOVE 0 Allinea la linea di quota con il relativo testo
															; DIMTMOVE 1 Aggiunge una direttrice quando viene spostato il testo di quota
															; DIMTMOVE 2 Permette di spostare liberamente il testo senza una direttrice
 
			(if (not (tblsearch "STYLE" DimStyleText))
				(MakeStyleDim "Romans.shx" DimStyleText 0 0.8)
			)

			; Create dimblk
			
			(if (not (tblobjname "block" NameArrow))
				(progn
					(setq OldDimBlk (getvar "dimblk"))
					(if (= OldDimBlk "")
						(setq OldDimBlk ".")
					)
					(setvar "dimblk" NameArrow)
					(setvar "dimblk" OldDimBlk)
				)
			)
						
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;		Group code  Dimension variable     Data type     Value range
			;		  3         DIMPOST                string        any
			;		  4         DIMAPOST               string        any
			;		 40         DIMSCALE               real          >= 0.0
			;		 41         DIMASZ                 real          >= 0.0
			;		 42         DIMEXO                 real          >= 0.0
			;		 43         DIMDLI                 real          >= 0.0
			;		 44         DIMEXE                 real          >= 0.0
			;		 45         DIMRND                 real          >= 0.0
			;		 46         DIMDLE                 real          >= 0.0
			;		 47         DIMTP                  real          >= 0.0
			;		 48         DIMTM                  real          >= 0.0
			;		 49         DIMFXL                 real          any value         new 2007
			;		 50         DIMJOGANG              real          0.08727 - 1.5708  new 2007  (5 - 90 degrees)
			;		 69         DIMTFILL               int           0 - 2             new 2007
			;		 70         DIMTFILLCLR            int           0 - 256           new 2007
			;		 71         DIMTOL                 int           0 = off,  1 = on
			;		 72         DIMLIM                 int           0 = off,  1 = on
			;		 73         DIMTIH                 int           0 = off,  1 = on
			;		 74         DIMTOH                 int           0 = off,  1 = on
			;		 75         DIMSE1                 int           0 = off,  1 = on
			;		 76         DIMSE2                 int           0 = off,  1 = on
			;		 77         DIMTAD                 int           0 - 3
			;		 78         DIMZIN                 int           0 - 15
			;		 79         DIMAZIN                int           0 - 15            new
			;		 90         DIMARCSYM              int           0 - 2             new 2007
			;		140         DIMTXT                 real          >= 0.0
			;		141         DIMCEN                 real          any value
			;		142         DIMTSZ                 real          >= 0.0
			;		143         DIMALTF                real          >= 0.0
			;		144         DIMLFAC                real          >= 0.0
			;		145         DIMTVP                 real          >= 0.0
			;		146         DIMTFAC                real          >= 0.0
			;		147         DIMGAP                 real          any value
			;		148         DIMALTRND              real          >= 0.0            new
			;		170         DIMALT                 int           0 = off,  1 = on
			;		171         DIMALTD                int           >= 0
			;		172         DIMTOFL                int           0 = off,  1 = on
			;		173         DIMSAH                 int           0 = off,  1 = on
			;		174         DIMTIX                 int           0 = off,  1 = on
			;		175         DIMSOXD                int           0 = off,  1 = on
			;		176         DIMCLRD                int           0 - 256
			;		177         DIMCLRE                int           0 - 256
			;		178         DIMCLRT                int           0 - 256
			;		179         DIMADEC                int           0 - 8             new
			;		271         DIMDEC                 int           0 - 8
			;		272         DIMTDEC                int           0 - 8
			;		273         DIMALTU                int           1 - 8
			;		274         DIMALTTD               int           0 - 8
			;		275         DIMAUNIT               int           0 - 4
			;		276         DIMFRAC                int           0 - 2             new
			;		277         DIMLUNIT               int           0 - 4             new
			;		278         DIMDSEP                int           (char) any char   new
			;		279         DIMTMOVE               int           0 - 2             new
			;		280         DIMJUST                int           0 - 4
			;		281         DIMSD1                 int           0 = off,  1 = on
			;		282         DIMSD2                 int           0 = off,  1 = on
			;		283         DIMTOLJ                int           0 - 2
			;		284         DIMTZIN                int           0 - 15
			;		285         DIMALTZ                int           0 - 15
			;		286         DIMALTTZ               int           0 - 15
			;		288         DIMUPT                 int           0 = off,  1 = on
			;		289         DIMATFIT               int           0 - 3             new
			;		290         DIMFXLON               int           0 = off,  1 = on  new 2007
			;		294         DIMTXTDIRECTION        int           0 = off,  1 = on  new 2007
			;		340         DIMTXSTY               objectId                        new
			;		341         DIMLDRBLK              objectId                        new
			;		342         DIMBLK                 objectId                        new
			;		343         DIMBLK1                objectId                        new
			;		344         DIMBLK2                objectId                        new
			;		345         DIMLTYPE               objectId                        new 2007
			;		346         DIMLTEX1               objectId                        new 2007
			;		347         DIMLTEX2               objectId                        new 2007
			;		371         DIMLWD                 int           lineweights       new
			;		372         DIMLWE                 int           lineweights       new
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			; Create dimstyle
			(setq LstDxfDim 
					(list
						(cons 0 "DIMSTYLE")								; Table
						(cons 100 "AcDbSymbolTableRecord")				; Subclass marker
						(cons 100 "AcDbDimStyleTableRecord")			; Subclass marker
						(cons 2 DimStyleName)							; Dimstyle name
						(cons 70 0)										; Standard flag

						(cons 3 "")										; DIMPOST			Prefix and suffix for dimension text
						(cons 4 "")										; DIMAPOST			Prefix and suffix for alternate text
						;(cons 5 "_ARCHTICK")							; DIMBLK			Arrow block name
						;(cons 6 "")									; DIMBLK1			First arrow block name
						;(cons 7 "")									; DIMBLK2			Second arrow block name
						
						(cons 40 DimScale)								; DIMSCALE			Dim scale
						(cons 41 ArrowSize)								; DIMASZ			Arrow size
						(cons 42 ExtensionLineOriginOffset)				; DIMEXO			Extension line origin offset
						(cons 43 DimensionLineSpacing)					; DIMDLI			Dimension line spacing
						(cons 44 ExtensionAboveDimensionLine)			; DIMEXE			Extension above dimension line
						(cons 45 RoundingValue)							; DIMRND			Rounding value 
						(cons 46 ExtensionDimensionLine) 				; DIMDLE			Dimension line extension 
						(cons 47 0.0000) 								; DIMTP				Plus tolerance  
						(cons 48 0.0)									; DIMTM 			Minus tolerance
						(cons 49 1.000)									; DIMFXL			Sets the total length of the extension lines starting from the dimension line toward the dimension origin
						(cons 50 (/ (* 45.0 PI) 180.0))					; DIMJOGANG 		Determines the angle of the transverse segment of the dimension line in a jogged radius dimension
						(cons 69 1)										; DIMTFILL			Controls the background of dimension text  
						(cons 70 0)										; DIMTFILLCLR		Sets the color for the text background in dimensions
						(cons 71 0)										; DIMTOL			Tolerance dimensioning
						(cons 72 0)										; DIMLIM			Generate dimension limits
						(cons 73 0)										; DIMTIH			Text inside extensions is horizontal
						(cons 74 0)										; DIMTOH			Text outside horizontal
						(cons 75 0)										; DIMSE1			Suppress the first extension line
						(cons 76 0)										; DIMSE2			Suppress the second extension line
						(cons 77 1)										; DIMTAD			Place text above the dimension line
						(cons 78 12)									; DIMZIN			Zero suppression
						(cons 79 0)										; DIMAZIN			Angular zero supression
						(cons 90 0)										; DIMARCSYM			Controls display of the arc symbol in an arc length dimension.
						
						(cons 140 DimHtext) 							; DIMTXT			Text height
						(cons 141 CenterMarkSize)						; DIMCEN 			Center mark size
						(cons 142 0.0)									; DIMTSZ			Tick size
						(cons 143 25.4)									; DIMALTF			Alternate unit scale factor
						(cons 144 LinearUnitScaleFactor)				; DIMLFAC			Linear unit scale factor
						(cons 145 0.0)									; DIMTVP			Text vertical position
						(cons 146 1.0)									; DIMTFAC			Tolerance text height scaling factor
						(cons 147 GapFromDimensionLineToText)			; DIMGAP			Gap from dimension line to text
						(cons 148 0.0000) 								; DIMALTRND			Alternate units rounding value

						(cons 170 0)									; DIMALT			Alternate units selected
						(cons 171 2)									; DIMALTD			Alternate unit decimal places
						(cons 172 1)									; DIMTOFL			Force line inside extension lines
						(cons 173 0)									; DIMSAH			Separate arrow blocks
						(cons 174 1)									; DIMTIX			Place text inside extensions
						(cons 175 0)									; DIMSOXD			Suppress outside dimension lines
						(cons 176 ColorDimensionLineAndLeader)			; DIMCLRD			Dimension line and leader color
						(cons 177 ColorExtensionLine)					; DIMCLRE			Extension line color
						(cons 178 ColorDimensionText)					; DIMCLRT			Dimension text color
						(cons 179 AngularDecimalPlaces)					; DIMADEC			Angular decimal places

						(cons 270 2)									; DIMUNIT
						(cons 271 DecimalPlaces)						; DIMDEC			Decimal places
						(cons 272 1)									; DIMTDEC			Tolerance decimal places
						(cons 273 2)									; DIMALTU			Alternate units
						(cons 274 2)									; DIMALTTD			Alternate tolerance decimal places
						(cons 275 0)									; DIMAUNIT			Angular unit format
						(cons 276 0)									; DIMFRAC			Fraction format
						(cons 277 2)									; DIMLUNIT			Unit format
						(cons 278 46) 									; DIMDSEP			Decimal separator
						(cons 279 TextMovement)							; DIMTMOVE			Text movement
						(cons 280 0)									; DIMJUST			Justification of text on dimension line
						(cons 281 0)									; DIMSD1			Suppress the first dimension line
						(cons 282 0)									; DIMSD2			Suppress the second dimension line
						(cons 283 1)									; DIMTOLJ			Tolerance vertical justification
						(cons 284 0)									; DIMTZIN			Tolerance zero suppression
						(cons 285 0)									; DIMALTZ			Alternate unit zero suppression
						(cons 286 0)									; DIMALTTZ			Alternate tolerance zero suppression
						(cons 287 3)									; DIMFIT
						(cons 288 0)									; DIMUPT			User positioned text
						(cons 289 3)									; DIMATFIT			Arrow and text fit 
						(cons 290 0)									; DIMFXLON			Controls whether extension lines are set to a fixed length
						(cons 294 0)									; DIMTXTDIRECTION  	Specifies the reading direction of the dimension text

						(cons 340 (tblobjname "style" DimStyleText))	; DIMTXSTY 			Text style
						;(cons 341 (cdr (assoc 330 (entget (tblobjname "block" "_open30"))))) 		; DIMLDRBLK Block for the leader
						(cons 342 (cdr (assoc 330 (entget (tblobjname "block" NameArrow)))))		; DIMBLK
						(cons 343 (cdr (assoc 330 (entget (tblobjname "block" NameArrow)))))		; DIMBLK1
						(cons 344 (cdr (assoc 330 (entget (tblobjname "block" NameArrow)))))		; DIMBLK2

						(cons 371 -2)									; DIMLWD		Dimension line and leader lineweight
						(cons 372 -2)									; DIMLWE		Extension line lineweight
					)
			)
			(if (= DimAnnotative "1")
				(setq LstDxfDim (append LstDxfDim (list	(list -3 (list "AcadAnnotative"
																	(cons 1000 "AnnotativeData")
																	(cons 1002 "{")
																	(cons 1070 1)
																	(cons 1070 1)
																	(cons 1002 "}")
																)
														)
													)
								)
				)
			)
			(setq EnameDim (entmakex LstDxfDim))
			
			(if EnameDim
				(progn
					(setq acdoc (vla-get-activedocument (vlax-get-acad-object)))
					(vla-put-activedimstyle acdoc (vla-item (vla-get-dimstyles acdoc) DimStyleName))
					(princ (strcat "\n" DimStyleName " is now the current Dimstyle"))
				)
			)
		)
	)
	;EnameDim
	(princ)
)
;
;
(defun MakeHatchShape (EnameShape LstEnameInternalShape TypeHatch / acdoc acspc hobj obj1 obj2 obj3)

    ;; Example by Lee Mac 2011  -  www.lee-mac.com

    (setq acdoc (vla-get-activedocument  (vlax-get-acad-object))
          acspc (vlax-get-property acdoc (if (= 1 (getvar 'CVPORT)) 'paperspace 'modelspace))
    )

    ;; Create some test shapes to demonstrate the idea:

    ;(setq obj1
    ;    (vla-addlightweightpolyline acspc
    ;        (vlax-make-variant
    ;            (vlax-safearray-fill (vlax-make-safearray vlax-vbdouble '(0 . 7))
    ;                '(0.0 0.0 3.0 0.0 3.0 1.0 0.0 1.0)
    ;            )
    ;        )
    ;    )
    ;)
    ;(vla-put-closed obj1 :vlax-true)
	
	
	

    ;(setq obj2 (vla-addcircle acspc (vlax-3D-point '(0.5 0.5 0.0)) 0.25))
    ;(setq obj3 (vla-addcircle acspc (vlax-3D-point '(1.5 0.5 0.0)) 0.25))

    ;; Add the Hatch Object:
	
	(setq obj1 (vlax-ename->vla-object EnameShape))
    (setq hobj (vla-addhatch acspc achatchpatterntypepredefined TypeHatch :vlax-true achatchobject))
	

    ;; The Hatch Object is currently volatile, the next step is important:

    (vla-appendouterloop hobj
        (vlax-make-variant
            (vlax-safearray-fill
                (vlax-make-safearray vlax-vbobject '(0 . 0))
                (list obj1)
            )
        )
    )

    ;; Create the Circular void:

	(foreach itm LstEnameInternalShape
		(vla-appendinnerloop hobj
			(vlax-make-variant
				(vlax-safearray-fill
					(vlax-make-safearray vlax-vbobject '(0 . 0))
					(list (vlax-ename->vla-object itm))
				)
			)
		)
	)
    ;(vla-appendinnerloop hobj
    ;    (vlax-make-variant
    ;        (vlax-safearray-fill
    ;            (vlax-make-safearray vlax-vbobject '(0 . 0))
    ;            (list obj3)
    ;        )
    ;    )
    ;)

    (vla-put-patternscale hobj 0.05)

    ;; Finished manipulation of the Hatch boundary, time to evaluate:

    (vla-evaluate hobj)
    ;(princ)
	hobj
)
;
;
(defun FlattLwPolyline (Ename / LstData)
	(if Ename
		(if (= (cdr (assoc 0 (setq LstData (entget Ename)))) "LWPOLYLINE")
			(if (equal (cdr (assoc 210 LstData)) (list 0.0 0.0 1.0))
				(if (not (zerop (cdr (assoc 38 LstData))))
					(progn
						(setq LstData (subst (cons 38 0.0) (assoc 38 LstData) LstData))
						(entmod LstData)
						(entupd Ename)
					)
				)
			)
		)
	)
)
;
;
(defun FlattEntity (Ename / LstData P10 P11)

	(if Ename
		(progn
			(setq LstData (entget Ename))
			(if (equal (assoc 210 LstData) (list 210 0.0 0.0 1.0))
				(cond
					((= (cdr (assoc 0 LstData))"LINE")
						(setq P10 (cdr (assoc 10 LstData)))
						(setq P11 (cdr (assoc 11 LstData)))
						(setq LstData (subst (list 10 (car P10) (cadr P10) 0.0) (assoc 10 LstData) LstData))
						(setq LstData (subst (list 11 (car P11) (cadr P11) 0.0) (assoc 11 LstData) LstData))
						(entmod LstData)
						(entupd Ename)
					)
					((or (= (cdr (assoc 0 LstData))"ARC") 
						 (= (cdr (assoc 0 LstData))"CIRCLE")
						 (= (cdr (assoc 0 LstData))"ELLIPSE")
						)
						(setq P10 (cdr (assoc 10 LstData)))
						(setq LstData (subst (list 10 (car P10) (cadr P10) 0.0) (assoc 10 LstData) LstData))
						(entmod LstData)
						(entupd Ename)
					)
					(t
						(alert (strcat "[FlattEntity] Entita' " (cdr (assoc 0 LstData)) " non riconsciuta"))
					)
				)
			)
		)
	)
)
;
;
(defun ChangeZAxse (Ename / LstData Center AngIni AngFin Zdir NCenter NAngIni NAngFin LstData
							Start End Nstart Nend)
	(if Ename
		(progn
			(setq LstData (entget Ename))
			(if (equal (assoc 210 LstData) (list 210 0.0 0.0 -1.0) 0.001)
				(cond 
					((= (cdr (assoc 0 LstData))"ARC")
						(setq Center (assoc  10 LstData))
						(setq AngIni (assoc  50 LstData))
						(setq AngFin (assoc  51 LstData))
						(setq Zdir   (assoc 210 LstData))
						
						(setq NCenter  (append (list 10) (trans (cdr Center) (cdr Zdir) 0)))
						(setq NAngIni  (cons 50 (- Pi (cdr AngFin))))
						(setq NAngFin  (cons 51 (- Pi (cdr AngIni))))
						
						(setq LstData (subst (list 210 0.0 0.0 1.0) Zdir LstData))
						(setq LstData (subst NCenter Center LstData))
						(setq LstData (subst NAngIni AngIni LstData))
						(setq LstData (subst NAngfin AngFin LstData))
						(entmod LstData)
						(entupd Ename)
						
					)
					((= (cdr (assoc 0 LstData))"LINE")
						(setq Start  (assoc 10 LstData))
						(setq End    (assoc 11 LstData))
						(setq Zdir   (assoc 210 LstData))
						(setq Nstart (append (list 10) (trans (cdr Start) (cdr Zdir) 0)))
						(setq Nend   (append (list 11) (trans (cdr End)   (cdr Zdir) 0)))
						
						(setq LstData (subst (list 210 0.0 0.0 1.0) Zdir LstData))
						(setq LstData (subst Nstart Start LstData))
						(setq LstData (subst Nend   End   LstData))
						(entmod LstData)
						(entupd Ename)
					)
				)
			)
		)
	)
)
;
;
(defun ExplodeLwPolylineAndPolyline (Ssel / MyExplode Itm LstData Cvt LstEname Rtn)


	(defun MyExplode (itm / Rtn)
		(if itm
			(progn
				(Open_Block_Entity)
				(command "_.explode" itm)
				(setq Rtn (Close_Block_Entity))
			)
		)
		Rtn		
	)
	
	(foreach Itm (LM:ss->ent Ssel)
	
		(if (setq LstData (entget Itm))
			(progn
				(cond 
					((= (cdr (assoc 0 LstData))"POLYLINE")
						(Polyline2LwPolyline Itm)
						(setq Cvt T)
					)
					((= (cdr (assoc 0 LstData))"LWPOLYLINE")
						(setq Cvt T)	
					)
				)
				
				(if Cvt
					(if (setq LstEname (MyExplode Itm))
						(setq Rtn (append Rtn LstEname))
					)
					;(if (setq LstEname (mapcar 'vlax-vla-object->ename 
					;						(vlax-safearray->list 	
					;							(vlax-variant-value 	
					;								(vla-Explode (vlax-ename->vla-object Itm))))))
					;	(progn
					;		(DeleteEntity (list Itm))
					;		(setq Rtn (append Rtn LstEname))
					;	)
					;)
				)
				
			
				(setq Cvt nil)
			)
		)
		
		(if (entget Itm) (setq Rtn (append Rtn (list Itm))))
	)
	(LstEname->Ssget Rtn)
)
;
;
(defun RemoveEntityNotLtype (Ssel LstLayer / LstLayer Itm LstData Ltype Layer Rtn)

	(if (and Ssel LstLayer)
		(progn
			
			(foreach Itm (LM:ss->ent Ssel)
			
				(setq LstData (entget Itm))
				
				(cond
					((assoc 6 LstData)
						(setq Ltype (strcase (cdr (assoc 6 LstData))))
					)
					(t 
						(setq Layer (cdr (assoc 8 LstData)))
						(setq Ltype (strcase (cdr (assoc 6 (tblsearch "LAYER" Layer)))))
					)
				)
				(if (member Ltype (mapcar 'strcase LstLayer))
					(setq Rtn (append Rtn (list Itm)))
					(DeleteEntity (list Itm))
				)
			)
		)
	)
	(LstEname->Ssget Rtn)
)
;
;
(defun RemoveAmbiguosEntity (Ssel LstNameEntityToCheck Fuzz / RemoveDotArc RemoveDotLine RemoveDotPolyline RemoveDotLwPolyline RemoveDotCircle RemoveDotEllipse
														      Itm Name LstData LstEname)

	(defun RemoveDotArc (Ename Fuzz / Rtn)
		(if Ename (if (<= (vla-get-ArcLength (vlax-ename->vla-object Ename)) Fuzz) (progn (entdel Ename) (setq Rtn T)) (setq Rtn nil)))
		Rtn
	)
	(defun RemoveDotLine (Ename Fuzz / Rtn)
		(if Ename (if (<= (vla-get-Length (vlax-ename->vla-object Ename)) Fuzz) (progn (entdel Ename) (setq Rtn T)) (setq Rtn nil)))
		Rtn
	)
	(defun RemoveDotPolyline (Ename Fuzz / Rtn)
		(if Ename (if (<= (vla-get-Length (vlax-ename->vla-object Ename)) Fuzz) (progn (entdel Ename) (setq Rtn T)) (setq Rtn nil)))
		Rtn
	)
	(defun RemoveDotLwPolyline (Ename Fuzz / Rtn)
		(if Ename (if (<= (vla-get-Length (vlax-ename->vla-object Ename)) Fuzz) (progn (entdel Ename) (setq Rtn T)) (setq Rtn nil)))
		Rtn
	)
	(defun RemoveDotCircle (Ename Fuzz / Rtn)
		(if Ename (if (<= (vla-get-Radius (vlax-ename->vla-object Ename)) Fuzz) (progn (entdel Ename) (setq Rtn T)) (setq Rtn nil)))
		Rtn
	)
	(defun RemoveDotEllipse (Ename Fuzz / EnameTmp Rtn)
		(if Ename
			(progn 
				(setq EnameTmp (Ellipse2LwPolyline Ename nil))
				;(setq EnameTmp (ACET-GEOM-ELLIPSE-TO-PLINE Ename))
				(if (<= (vla-get-Length (vlax-ename->vla-object EnameTmp)) Fuzz) (progn (entdel Ename) (setq Rtn T)) (setq Rtn nil))
				(entdel EnameTmp)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if (and Ssel LstNameEntityToCheck)
		(foreach Itm (LM:ss->ent Ssel)
			(if (setq LstData (entget Itm))
				(progn
					(setq Name (cdr (assoc 0 LstData)))
					(cond
						((and (= Name "ARC") (member Name LstNameEntityToCheck))
							(if (not (RemoveDotArc Itm Fuzz))        (setq LstEname (append LstEname (list Itm))))
						)
						((and (= Name "LINE") (member Name LstNameEntityToCheck))
							(if (not (RemoveDotLine Itm Fuzz))       (setq LstEname (append LstEname (list Itm))))
						)
						((and (= Name "CIRCLE") (member Name LstNameEntityToCheck))
							(if (not (RemoveDotCircle Itm Fuzz))     (setq LstEname (append LstEname (list Itm))))
						)
						((and (= Name "ELLIPSE") (member Name LstNameEntityToCheck))
							(if (not (RemoveDotEllipse Itm Fuzz))    (setq LstEname (append LstEname (list Itm))))
						)
						((and (= Name "POLYLINE") (member Name LstNameEntityToCheck))
							(if (not (RemoveDotPolyline Itm Fuzz))   (setq LstEname (append LstEname (list Itm))))
						)
						((and (= Name "LWPOLYLINE") (member Name LstNameEntityToCheck))
							(if (not (RemoveDotLwPolyline Itm Fuzz)) (setq LstEname (append LstEname (list Itm))))
						)
						(t 
							(setq LstEname (append LstEname (list Itm)))
						)
					)
				)
			)
		)
	)
	(LstEname->Ssget LstEname)
)
;
;
(defun ax:layer-list (/ lst layer colors color lw)
	;
	;	nome 	 acceso c/scongelato s/bloccato 	colore     	tipoline		spessore linea	plotstyle	stampabile		vport
	;(	("0"	 "On" 	"Thawed" 	 "Not locked" 	"White" 	"Continuous" 	"Default" 		"Color_7" 	"Plottable" 	"Not frozen") 
	;	("A4" 	 "Off" 	"Frozen" 	 "Not locked" 	"9" 		"Continuous"	"Default" 		"Color_9" 	"Not plottable" "Not frozen") 
	;	("Parti" "On" 	"Thawed" 	 "Not locked" 	"175" 		"Continuous" 	"Default" 		"Color_175" "Not plottable" "Not frozen")
	;)
	;
	;
	(setq colors '("Red" "Yellow" "Green" "Cyan" "Blue" "Magenta" "White"))
	(vlax-for layer (vla-get-Layers
                    (vla-get-ActiveDocument
                      (vlax-get-acad-object)
                    )
                  )
		(setq color (vla-get-color layer))
		(if (< color 8) (setq color (nth (1- color) colors)) (setq color (itoa color)))
		(setq lw (vla-get-lineweight layer))
		(if (= lw -3) (setq lw "Default") (setq lw (rtos (/ lw 100.0) 2 2)))
		(setq lst (cons
						(list 	(vla-get-name layer)
								(if (= (vla-get-layeron layer) :vlax-true) "On" "Off")
								(if (= (vla-get-freeze layer) :vlax-true) "Frozen" "Thawed")
								(if (= (vla-get-lock layer) :vlax-true) "Locked" "Not locked")
								color
								(vla-get-linetype layer)
								lw
								(vla-get-plotstylename layer)
								(if (= (vla-get-plottable layer) :vlax-true) "Plottable" "Not plottable")
								(if (= (vla-get-viewportdefault layer) :vlax-true) "Frozen" "Not frozen")
						) lst))
	)
	(vl-sort lst
           (function (lambda (e1 e2)
                       (< (strcase (car e1)) (strcase (car e2)))
                     )
           )
  ) 
)
;
;



;(defun RemoveBlock (BlockName / doc layout i)
;	(setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
;	(vlax-for layout (vla-get-layouts doc)
;		(vlax-for i (vla-get-block layout)
;			(if (and
;					(= (vla-get-objectname i) "AcDbBlockReference")
;					(= (strcase (vla-get-name i)) (strcase BlockName))
;				)
;				(vla-Delete i) 
;			)
;		)
;	)
;	(PurgeBlock BlockName)
;)