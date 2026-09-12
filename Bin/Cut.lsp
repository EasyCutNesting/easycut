; (vl-bt)
; 
;(setvar "pickstyle" 0)
;(setvar "pickstyle" 1)
;
; $ListIdShape				lista ID Shape
; $ListIdTriggerOn			lista ID Trigger On
; $ListIdTriggerOff 		lista Id Trigger Off
; $ListGroupShape	 		lista Group Shape
;
; Variabili globali
;
;(setq $SpeedCut 500)				; velocità taglio mm / min+
;(setq $ColorShapeOra  	 1)			; colore contorno esterno orario
;(setq $ColorShapeAntiOra 2)		; colore contorno esterno antiorario
;(setq $ColorHoleOra 	 3)			; colore contorno interno orario
;(setq $ColorHoleAntiOra  4)		; colore contorno interno antiorario
;(setq $ColorCircle 		 5)		; colore contorno interno circolari
;(setq $ColorEllipse 	 6)			; colore contorno interno ellittici
;(setq $ArrowArcDivision  1.0)     	; freccia massima per il calcolo della divisione dell'arco / cerchio

;(setq $FilterList  '((-4 . "<OR") (0 . "LwPolyline") (0 . "Circle") (0 . "Ellipse") (0 . "Polyline") (-4 . "OR>")))
;(setq $TriggerList '((-4 . "<OR") (0 . "Arc") (0 . "Line") (-4 . "OR>")))
;(setq $RgpSheet       "LAMIERA")
;(setq $RgpSheetTarget "LAM_TRG")
;(setq $RgpShape       "PIATTO")
;(setq $RgpTiggerOn    "ENTRA")
;(setq $RgpTiggeroff   "ESCI")
;
;
;
(defun ZoomHandle (IdHandle)
	(if IdHandle
		(if (handent IdHandle)
			(progn
				(ZoomEname (handent IdHandle) 100)
				(handent IdHandle)
			)
		)
	)
)
;
;
;
(defun c:Prc ()
	(setvar "pickstyle" 0)
	(setq rtn (CheckPoly (car (entsel))))
	(if (= (nth 0 rtn) 2) (princ "\nPercorrenza Antioraria"))
	(if (= (nth 0 rtn) 3) (princ "\nPercorrenza Oraria"))
	(princ)
)
;
;
;
(defun C:rev(/ shape)
	(setvar "pickstyle" 0)
	(setq shape (car (entsel)))
	(RevLwpline shape)
	;(setq rtn (AssignNameShape shape (list "****")))
)
;
; stacca il gruppo all'ename
;
(defun DetatchGroupToEname (eName / GetDxfGroup
									grpData grpObject eObject items itm)

	(defun GetDxfGroup (eName / eData grpData)
		(if (and (setq eData (entget eName))
             	 (setq grpData (assoc 330 eData))
                 (setq grpData (entget (cdr grpData)))
                 (eq (cdr (assoc 0 grpData)) "GROUP")
			)
			grpData)
	)
	(foreach itm (Gnames ename)
		(if (setq grpData (GetDxfGroup eName))
			(progn
				(setq eObject     (vlax-ename->vla-object eName)
					  grpObject   (vlax-ename->vla-object (cdar grpData))
					  items       (vlax-make-safearray vlax-vbObject '(0 . 0))
				)
				(vlax-safearray-put-element items 0 eObject)
				(vla-RemoveItems grpObject (vlax-make-variant items))
			)
		)
	)
)
;
; stacca le entita estese all'ename
;
(defun DetatchInfoEname (Ename  / entlst tmplst)

	(setq entlst (entget Ename (list "*")))
	(foreach memb (cdr (assoc -3 entlst))
		(setq 	tmplst (cons -3 (list (cons (car memb) nil)))
				entlst (subst tmplst (assoc -3 entlst) entlst)
				entlst (entmod entlst)
		)
	)
	(princ)
)
;
;
;
(defun Region2Polyline (EnameRegion Flag / :Region2Polyline $RtnGlobal)
	;
	(defun :Region2Polyline (EnameRegion Flag / Norm LstExpl itm)
		(if EnameRegion
			(progn
				;(setq Norm 		(vlax-get 	 (vlax-ename->vla-object EnameRegion) 'Normal))
				(setq LstExpl 	    (mapcar '(lambda (x) (vlax-vla-object->ename x))
														 (vlax-invoke (vlax-ename->vla-object EnameRegion) 'Explode)))
				(cond 
					( (vl-every '(lambda (x) (or (= (vla-get-ObjectName (vlax-ename->vla-object x)) "AcDbLine") 
												 (= (vla-get-ObjectName (vlax-ename->vla-object x)) "AcDbArc"))) LstExpl)
					  (setq $RtnGlobal (append $RtnGlobal (MyPedit (LstEname->Ssget LstExpl) 0.01)))
					  (if Flag (entdel EnameRegion))
					)
					(t 
						(foreach itm LstExpl
							(cond 
								((= (vla-get-ObjectName (vlax-ename->vla-object itm)) "AcDbRegion")
									(:Region2Polyline itm Flag)
								)
								((= (vla-get-ObjectName (vlax-ename->vla-object itm)) "AcDbCircle")
									(setq Rtn (Circle2LwPolyline itm Flag))
								)
								((= (vla-get-ObjectName (vlax-ename->vla-object itm)) "AcDbEllipse")
									(setq Rtn (Ellipse2LwPolyline itm Flag))
								)
							)
						)
					)
				)
			)
		)
	)
	;
	; Main ++++++++++++++
	;
	(setq $RtnGlobal nil)
	(if EnameRegion
		(:Region2Polyline EnameRegion Flag)
	)
	(if Flag (DeleteEntity (list EnameRegion)))
	$RtnGlobal
)
;
; obsoleta
;
(defun RegionToPolyLine (EnameRegion Flag / SplitSsget
											itm LstEname LstEnameExploded RtnSplitSsel Rtn1 Rtn2 Rtn3 Rtn)

	(defun SplitSsget (LstEname / itm Rtn1 Rtn2 Rtn3)
	
		(setq Rtn1 (ssadd)) ; Line and Arc
		(setq Rtn2 (ssadd)) ; Circle
		(setq Rtn3 (ssadd)) ; Ellipse
		
		(foreach itm LstEname
			(cond 
				((or (= (cdr (assoc 0 (entget itm))) "LINE") (= (cdr (assoc 0 (entget itm))) "ARC" ))
					(ssadd itm Rtn1)
				)
				((= (cdr (assoc 0 (entget itm))) "CIRCLE")
					(ssadd itm Rtn2)
				)
				((= (cdr (assoc 0 (entget itm))) "ELLIPSE")
					(ssadd itm Rtn3)
				)
			)
		)
		(list Rtn1 Rtn2 Rtn3)
	)
	;
	; Main 
	;
	(if EnameRegion
		(progn
		
			(Open_Block_Entity)
				(ExplodeRegion EnameRegion)
			(setq LstEname (Close_Block_Entity))
			
			; purge sub region ++++++++++++++++++++++++++++++++++++++++++
			(foreach itm LstEname
				(if (= (cdr (assoc 0 (entget itm))) "REGION") 
					(entdel itm)
					(setq LstEnameExploded (cons itm LstEnameExploded))
				)
			)
			; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			
			(setq RtnSplitSsel (SplitSsget LstEnameExploded))
			
			(setq Rtn1 (MultiLineToPline (nth 0 RtnSplitSsel) 0.01))		; Line and Circle
			
			(foreach itm (LM:ss->ent (nth 1 RtnSplitSsel))
				(setq Rtn2 (append Rtn2 (list (Circle2LwPolyline itm T))))	; Circle
			)
			
			(foreach itm (LM:ss->ent (nth 2 RtnSplitSsel))
				(setq Rtn3 (append Rtn3 (list (Ellipse2LwPolyline itm T))))	; Ellipse
			)
			
			(if Rtn1 (setq Rtn Rtn1))
			(if Rtn2 (setq Rtn (append Rtn Rtn2)))
			(if Rtn1 (setq Rtn (append Rtn Rtn3)))
			
			(if (and Rtn Flag)
				(entdel EnameRegion)
			)
		)
	)
	Rtn
)
;
;
;
(defun ExplodeRegion (EnameRegion / LstEname itm)

	(if EnameRegion
		(progn
			(setq LstEname (mapcar 'vlax-vla-object->ename 
								(vlax-safearray->list (vlax-variant-value 
										(vla-Explode (vlax-ename->vla-object EnameRegion))))))
			(foreach itm LstEname
				(if (= (cdr (assoc 0 (entget itm))) "REGION")
					(ExplodeRegion itm)
				)
			)
		)
	)
)
;
;
;
(defun AddRegion (EnameLwPoly / doc obj catchit Rtn)

	(if EnameLwPoly
		(progn
			(setq obj (vlax-ename->vla-object EnameLwPoly)
				  doc (vla-get-activedocument (vlax-get-acad-object))
			)
			(if (not (vl-catch-all-error-p
						(vl-catch-all-apply
							'(lambda ()
								(vlax-invoke
									(if (vlax-method-applicable-p doc 'objectidtoobject32)
										(vla-objectidtoobject32 doc (vla-get-ownerid32 obj))
										(vla-objectidtoobject   doc (vla-get-ownerid   obj))
									)
									'addregion (list obj)
								)
							)
						)
					)
				)
				(setq Rtn (entlast))
			)
		)
	)
	Rtn
)
;
;(setq catchit (vl-catch-all-apply '/ '(50 0)))
;
(defun GetGravityCenter (EnameShape / GetCentroid EnameRegion Rtn)

	;(defun AddRegion (EnameLwPoly / doc obj Rtn)
	;
	;	(if EnameLwPoly
	;		(progn
	;			(setq obj (vlax-ename->vla-object EnameLwPoly)
	;				  doc (vla-get-activedocument (vlax-get-acad-object))
	;			)
	;			(vlax-invoke
	;				(if (vlax-method-applicable-p doc 'objectidtoobject32)
	;					(vla-objectidtoobject32 doc (vla-get-ownerid32 obj))
	;					(vla-objectidtoobject   doc (vla-get-ownerid   obj))
	;				)
	;				'addregion (list obj)
	;			)
	;			(setq Rtn (entlast))
	;		)
	;	)
	;	Rtn
	;)
	;
	;
	;
	(defun GetCentroid (EnameRegion / Rtn)
		(if EnameRegion
			(setq Rtn (vlax-safearray->list (vlax-variant-value (vla-get-centroid (vlax-ename->vla-object EnameRegion)))))
		)
		Rtn
	)
	;
	;
	;	
	(if EnameShape
		(progn
			(cond
				( (or (= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE")
					  (= (cdr (assoc 0 (entget EnameShape))) "POLYLINE"))
				  
					(setq EnameRegion (AddRegion EnameShape))
					(if EnameRegion
						(progn 
							(setq Rtn (GetCentroid EnameRegion))
							(entdel EnameRegion)
						)
					)
				)
				( (or (= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
				      (= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE"))
				
					(setq Rtn  (vlax-safearray->list (vlax-variant-value (vla-get-center (vlax-ename->vla-object EnameShape)))))
				)
				((= (cdr (assoc 0 (entget EnameShape))) "REGION")
				
					(setq Rtn (GetCentroid EnameRegion))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun CreateRegion (LstEname TypeAction / subtract_region list_region ent LstArea TmpLst)

	
	;
	(defun subtract_region (ename_list / a lstobj sol)
		(foreach a ename_list
			(setq lstobj (cons (vlax-ename->vla-object a) lstobj))
		)
		(setq lstobj (reverse lstobj))
		(if (> (length ename_list) 1)
			(progn
				(setq sol (car lstobj) 
					  lstobj (cdr lstobj)
				)
				(while lstobj
					(vla-boolean sol acSubtraction (car lstobj))
					(setq lstobj (cdr lstobj))
				)
			)
		)
	)	
	;(vla-boolean (GetObj) acIntersection (GetObj))
	(defun union_region (ename_list / a lstobj sol)
		(foreach a ename_list
			(setq lstobj (cons (vlax-ename->vla-object a) lstobj))
		)
		(setq lstobj (reverse lstobj))
		(if (> (length ename_list) 1)
			(progn
				(setq sol (car lstobj) 
					  lstobj (cdr lstobj)
				)
				(while lstobj
					(vla-boolean sol acUnion (car lstobj))
					(setq lstobj (cdr lstobj))
				)
			)
		)
	)	
	;
	; Main
	;
	(if LstEname
		(progn
			(setq list_region nil)
			(foreach ent LstEname
				(cond 
					((or (= (cdr (assoc 0 (entget ent))) "LWPOLYLINE")
						 (= (cdr (assoc 0 (entget ent))) "ELLIPSE")
						 (= (cdr (assoc 0 (entget ent))) "CIRCLE")
					 )
					 (setq list_region (append list_region (list (AddRegion ent))))
					)
				)
			)
			(if list_region
				(progn
					(setq LstArea nil)
					(foreach Itm list_region
						(setq LstArea (append LstArea (list (list (vla-get-area (vlax-ename->vla-object Itm)) Itm))))
					)
					(setq TmpLst (vl-sort LstArea (function (lambda (e1 e2)  (> (car e1) (car e2))))))									
					(setq LstArea nil)
					(foreach Itm TmpLst
						(setq LstArea (append LstArea (list (nth 1 Itm))))
					)
					
					;(Open_Block_Entity)
					(cond
						((= TypeAction "-")
							(subtract_region LstArea)
						)
						((= TypeAction "+")
							(union_region LstArea)
						)
					)
					;(setq out (Close_Block_Entity))
					;(if (not out)
						(setq out (nth 0 LstArea))
					;)
				)
			)
		)
	)
	out
)
;
;(AssignNameShape (getent) '("10403" "1" "-" "-" "-" "10" "31/10/2020" "5"))
;
(defun AssignNameShape (EnameShape RecordList / ColorShapeOra ColorShapeAntiOra ColorHoleOra ColorHoleAntiOra ColorCircle ColorEllipse
												Num itm TypShape Journey ultent xd_list nuova_entita GrName)
							
						
	
							
	; 	RecordList lista atributi stringa
		
	;	nome piatto
	;	compensazione taglio
	;	nome commessa
	;	nome fase
	;	nome qualita
	;	spessore
	;	ultima modifica
	;	quantità
	
	(setq ColorShapeOra  	$ColorShapeOra)
	(setq ColorShapeAntiOra $ColorShapeAntiOra)
	(setq ColorHoleOra		$ColorHoleOra)
	(setq ColorHoleAntiOra 	$ColorHoleAntiOra)
	(setq ColorCircle 		$ColorCircle)
	(setq ColorEllipse 		$ColorEllipse)
	
	(if (and EnameShape RecordList)
		(progn

			(setq Num 0)

			;(foreach itm (nth 0 (GetEnameShape&TriggerByContour EnameShape))		; <-------- Shape
			(foreach itm (GetEntityForShape EnameShape)
				(cond
					((= Num 0)
						(setq TypShape "CE")
					)
					(t
						(setq TypShape "CI")
					)
				)
				
				(cond
					((= (cdr (assoc 0 (entget itm))) "LWPOLYLINE")
						(setq Journey (ClockWeisEname  itm))
					)
					((or (= (cdr (assoc 0 (entget itm))) "CIRCLE")		; solo per contorni interni
						 (= (cdr (assoc 0 (entget itm))) "ELLIPSE")) 	; solo per contorni interni
							(setq Journey 2)
					)
				)
				(cond
					((= TypShape "CE")
						(if (= Journey 3) (vla-put-Color (vlax-ename->vla-object itm) ColorShapeOra))	
						(if (= Journey 2) (vla-put-Color (vlax-ename->vla-object itm) ColorShapeAntiOra))
					)
					((= TypShape "CI")
						(if (= Journey 3) (vla-put-Color (vlax-ename->vla-object itm) ColorHoleOra))
						(if (= Journey 2) (vla-put-Color (vlax-ename->vla-object itm) ColorHoleAntiOra))
					)
				)
				;
				; Xdata +++++++++++++++++++++++++++++++++++++++
				;
				(setq ultent (entget itm)
				      xd_list (list '(1002 . "}"))
				)
				(foreach itm1 (reverse RecordList)
					(setq xd_list (cons (cons 1000 itm1) xd_list))
				)
				(setq xd_list (cons (cons 1000 (rtos Journey 2 0)) xd_list)	; percorrenza   ["0"]["2"]["3"]
					  xd_list (cons (cons 1000 (Random_Str 9))     xd_list)	; id pezzo      ["123456789"]
					  xd_list (cons (cons 1000 TypShape)           xd_list)	; tipo contorno ["CE"] ["CI"]
					  xd_list (cons '(1002 . "{")                  xd_list)
					  xd_list (cons $RgpShape xd_list)
					  xd_list (list -3 xd_list)
					  nuova_entita (append ultent (list xd_list))
				)
				(setq Num (1+ Num))
				
				(entmod nuova_entita)
				(entupd itm)
				
				;
				; end Xdata ++++++++++++++++++++++++++++++++++++
				;
				
			)
		)
	)
	(setq GrName (Random_Str 9))
	(AssignGroupNameShape EnameShape GrName)
	EnameShape
)
;
;
;
(defun AssignGroupNameShape (EnameDummyShape GrName / LstEname itm LstGroup grp l)
	
	(if EnameDummyShape
		(progn
		
			(setq LstEname (GetEnameShape&TriggerByContour EnameDummyShape))
			;
			; elimino tutti i gruppi del contorno ++++++++++++++++++++++
			;
			(foreach itm (nth 0 LstEname)		; <-------- Shape
				(setq LstGroup (gnames itm)) 
				(foreach grp LstGroup
					(DeleteGroupbyName grp)
				)
			)
			(foreach itm (nth 1 LstEname)		; <-------- Trigger
				(setq LstGroup (gnames itm)) 
				(foreach grp LstGroup
					(DeleteGroupbyName grp)
				)
			)
			;
			; ricreo il gruppo +++++++++++++++++++++++++++++++++++++++++
			;
			(setq l nil)						; <-------- Shape
			(foreach  itm (nth 0 LstEname)
				(DetatchGroupToEname itm)
				(setq l (cons (vlax-ename->vla-object itm) l))
			)
			(if (nth 0 LstEname)
				(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) GrName) 'appenditems l)	
			)
			(setq l nil)						; <-------- Trigger
			(foreach  itm (nth 1 LstEname)
				(DetatchGroupToEname itm)
				(setq l (cons (vlax-ename->vla-object itm) l))
			)
			(if (nth 1 LstEname)
				(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) GrName) 'appenditems l)	
			)
			(ChDescGroup GrName $RgpShape)
			;(PurgeAllGroupUnentity)
		)
	)
)
;
;
;
(defun CheckInternalShape (EnameInternalShape Fuzz Update / CheckTrggerOnShape CheckUnionTrigger
													        Shape CheckZoom Ssel1 Ssel2 Num LstEnameShape LstEnameTrigger LstDelete Ck1 Ck2 Ck3 Rtn)


	(defun CheckTriggerOnShape (LstEnameShape LstEnameTrigger Fuzz / NumI EnameTrigger EnameShape Pstart Pend LstBadTrigger Rtn)
		
		(if (and LstEnameShape LstEnameTrigger)
			(progn
				(setq LstEnameShape   (mapcar 'vlax-ename->vla-object LstEnameShape))
				(setq LstEnameTrigger (mapcar 'vlax-ename->vla-object LstEnameTrigger))
				(setq LstBadTrigger LstEnameTrigger)
				
				(setq NumI 0)
				(foreach EnameTrigger LstEnameTrigger
					(setq Pstart (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint EnameTrigger))))
					(setq Pend   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint EnameTrigger))))
				
					(setq Find nil)
					(foreach EnameShape LstEnameShape
					
						(if (or (equal (vlax-curve-getClosestPointTo EnameShape Pstart) Pstart Fuzz)
								(equal (vlax-curve-getClosestPointTo EnameShape Pend)   Pend Fuzz)
							)
							(progn
								(setq NumI (1+ NumI))
								(setq LstBadTrigger (vl-remove EnameTrigger LstBadTrigger))
							)
						)
					)
					
				)
				
				(if (= NumI  (length LstEnameTrigger))
					(setq Rtn T)
				)
			)
		)
		(if (not LstEnameTrigger)
			(setq Rtn T)
		)
		(list Rtn (mapcar 'vlax-vla-object->ename LstBadTrigger))
	)
	;
	;
	;
	(defun CheckUnionTrigger (LstEnameTrigger Fuzz / Combine NumI Ename1 Ename2 LstBadTrigger Rtn)
	
		(if LstEnameTrigger
			(progn
				(setq LstEnameTrigger (mapcar 'vlax-ename->vla-object LstEnameTrigger))
				(setq LstBadTrigger LstEnameTrigger)
				
				(setq NumI 0)
				(setq Combine (CombineList LstEnameTrigger 2))
				(foreach itm Combine
					(setq Ename1 (car  itm))
					(setq Ename2 (cadr itm))
					(if (or (equal (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Ename1)))
								   (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Ename2))) Fuzz)
							(equal (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Ename1)))
								   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Ename2)))   Fuzz)
							(equal (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Ename1)))
								   (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Ename2))) Fuzz)
							(equal (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Ename1)))
								   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Ename2)))   Fuzz)
						)
						(progn
							(setq LstBadTrigger (vl-remove Ename1 LstBadTrigger))
							(setq LstBadTrigger (vl-remove Ename2 LstBadTrigger))
							(setq NumI (1+ NumI))
						)
					)
				)

				(if (= NumI (/ (length LstEnameTrigger) 2.0))
					(setq Rtn T)
				)
			)
			(setq Rtn T)
		)
		(list Rtn (mapcar 'vlax-vla-object->ename LstBadTrigger))
	)
	;
	;
	;
	(defun CheckPoligonInsidePoligon (LstEnameShape / Combine itm LstBadShape Rtn)
	
		(setq Rtn T)
		(if LstEnameShape
			(progn
				(setq Combine (CombineList LstEnameShape 2))
				(foreach itm Combine
					(if (PoligonInsidePoligon (car itm) (cadr itm))
						(setq LstBadShape (append (list (cadr itm)))
							  Rtn nil
						)
					)
					(if (PoligonInsidePoligon (cadr itm) (car itm))
						(setq LstBadShape (append (list (car itm)))
							  Rtn nil
						)
					)
				)
			)
		)
		(list Rtn LstBadShape)
	)
	;
	;
	;
	(if EnameInternalShape
		(progn
			
			(setq Shape (LM:ent->pts EnameInternalShape 50))
			(setq CheckZoom (VisibleEname EnameInternalShape))
				(setq Ssel1 (ssget "_CP" Shape $FilterList))
				(setq Ssel2 (ssget "_CP" Shape $TriggerList))
			(ZoomPrevius CheckZoom)
			
			(setq Num 0)
			(if Ssel1
				(repeat (sslength Ssel1)
					(setq LstEnameShape (append LstEnameShape (list (ssname Ssel1 Num))))
					(setq Num (1+ Num))
				)
			)
			(setq Num 0)
			(if Ssel2
				(repeat (sslength Ssel2)
					(setq LstEnameTrigger (append LstEnameTrigger (list (ssname Ssel2 Num))))
					(setq Num (1+ Num))
				)
			)
			
			(setq Ck1 (CheckTriggerOnShape LstEnameShape LstEnameTrigger Fuzz))
			(setq Ck2 (CheckUnionTrigger LstEnameTrigger Fuzz))
			(setq Ck3 (CheckPoligonInsidePoligon LstEnameShape))
			(if (= (sslength Ssel1) 1)
				(if (car Ck1)
					(if (car Ck2)
						(if (car Ck3)
							(setq Rtn T)
							(LM:popup "Errore [CheckInternalShape]" "Contorno interno su interno" (+ 0 16 4096))
						)
					)	
				)
			)

			(if (not Rtn)
				(if Update
					(progn
						(setq LstDelete (LM:ListUnion (cadr Ck1) (cadr Ck2)))
						(setq LstDelete (LM:ListUnion LstDelete  (cadr Ck3)))

						(mapcar 'entdel LstDelete)
						;(setq Rtn T)
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
(defun CheckExternalShape (EnameExternalShape Fuzz Update / CheckTrggerOnShape CheckUnionTrgger CheckGroupShape GetEnameShape&TriggerByContourExtended
														    LstEname LstEnameShape LstEnameTrigger Ck1 Ck2 Ck3 LstDelete Rtn)

	
	(defun CheckTriggerOnShape (LstEnameShape LstEnameTrigger Fuzz / NumI EnameTrigger EnameShape Pstart Pend LstBadTrigger Rtn)
		
		(if (and LstEnameShape LstEnameTrigger)
			(progn
				(setq LstEnameShape   (mapcar 'vlax-ename->vla-object LstEnameShape))
				(setq LstEnameTrigger (mapcar 'vlax-ename->vla-object LstEnameTrigger))
				(setq LstBadTrigger LstEnameTrigger)
				
				(setq NumI 0)
				(foreach EnameTrigger LstEnameTrigger
					(setq Pstart (vlax-safearray->list (vlax-variant-value (vla-get-startpoint EnameTrigger))))
					(setq Pend   (vlax-safearray->list (vlax-variant-value (vla-get-endpoint EnameTrigger))))
				
					(setq Find nil)
					(foreach EnameShape LstEnameShape
					
						(if (or (equal (vlax-curve-getclosestpointto EnameShape Pstart) Pstart Fuzz)
								(equal (vlax-curve-getclosestpointto EnameShape Pend)   Pend Fuzz)
							)
							(progn
								(setq NumI (1+ NumI))
								(setq LstBadTrigger (vl-remove EnameTrigger LstBadTrigger))
							)
						)
					)
					
				)
				
				(if (= NumI  (length LstEnameTrigger))
					(setq Rtn T)
				)
			)
		)
		(if (not LstEnameTrigger)
			(setq Rtn T)
		)
		(list Rtn (mapcar 'vlax-vla-object->ename LstBadTrigger))
	)
	;
	;
	;
	(defun CheckUnionTrigger (LstEnameTrigger Fuzz / Combine NumI Ename1 Ename2 LstBadTrigger Rtn)
	
		(if LstEnameTrigger
			(progn
				(setq LstEnameTrigger (mapcar 'vlax-ename->vla-object LstEnameTrigger))
				(setq LstBadTrigger LstEnameTrigger)
				
				(setq NumI 0)
				(setq Combine (CombineList LstEnameTrigger 2))
				(foreach itm Combine
					(setq Ename1 (car  itm))
					(setq Ename2 (cadr itm))
					(if (or (equal (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Ename1)))
								   (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Ename2))) Fuzz)
							(equal (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Ename1)))
								   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Ename2)))   Fuzz)
							(equal (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Ename1)))
								   (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Ename2))) Fuzz)
							(equal (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Ename1)))
								   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Ename2)))   Fuzz)
						)
						(progn
							(setq LstBadTrigger (vl-remove Ename1 LstBadTrigger))
							(setq LstBadTrigger (vl-remove Ename2 LstBadTrigger))
							(setq NumI (1+ NumI))
						)
					)
				)

				(if (= NumI (/ (length LstEnameTrigger) 2.0))
					(setq Rtn T)
				)
			)
			(setq Rtn T)
		)
		(list Rtn (mapcar 'vlax-vla-object->ename LstBadTrigger))
	)
	;
	;
	;
	(defun CheckGroupShape (LstEnameShape LstEnameTrigger / itm NameGroup LstGroupName Rtn)
		
		;
		; controllo i contorni +++++++
		;
		(setq Rtn T)
		(foreach itm LstEnameShape
			(setq NameGroup (gnames itm))
			(if NameGroup
				(if (not (member (car NameGroup) LstGroupName))
					(setq LstGroupName (append LstGroupName (list (car NameGroup))))
				)
				(setq Rtn nil)
			)	
		)
		(if Rtn
			(progn
				;
				; controllo gli attacchi +++++++
				;
				(foreach itm LstEnameTrigger
					(setq NameGroup (gnames itm))
					(if NameGroup
						(if (not (member (car NameGroup) LstGroupName))
							(setq LstGroupName (append LstGroupName (list (car NameGroup))))
						)
						(setq Rtn nil)
					)	
				)
			)
		)
		
		(if (and Rtn (= (length LstGroupName) 1))
			(setq Rtn T)
			(setq Rtn nil)
		)
		
		Rtn
	)
	;
	;
	;
	(defun CheckPoligonInsidePoligon (LstEnameShape / Combine itm LstBadShape Rtn)
		
		(setq Rtn T)
		(if LstEnameShape
			(progn
				(setq Combine (CombineList LstEnameShape 2))
				(foreach itm Combine
					(if (PoligonInsidePoligon (car itm) (cadr itm))
						(setq LstBadShape (append (list (cadr itm)))
							  Rtn nil
						)
					)
					(if (PoligonInsidePoligon (cadr itm) (car itm))
						(setq LstBadShape (append (list (car itm)))
							  Rtn nil
						)
					)
				)
			)
		)
		(list Rtn LstBadShape)
	)
	;
	;
	;
	(defun GetEnameShape&TriggerByContourExtended (EnameShape / LstEname LstGrp itm)
	
		(if EnameShape
			(progn
				(setq LstEname (GetEnameShape&TriggerByContour EnameShape))

				; controllo se ci sono attacchi esterni al contorno esterno
	
				(setq LstGrp (mapcar 'cdr (Genames (car (Gnames EnameShape)))))
				(foreach itm LstGrp
					(if (CheckIfEasyCutTrigger itm)
						(if (not (member itm (nth 1 LstEname)))
							(setq LstEname (list (nth 0 LstEname) (append (nth 1 LstEname) (list itm))))
						)
					)
				)
			)
		)
		LstEname
	)
	;
	; Main
	;
	(if EnameExternalShape
		(progn
		
			(setq LstEname (GetEnameShape&TriggerByContourExtended EnameExternalShape))
			
			(if (IntegrityGeometricalShape (car LstEname))
				(progn
					(setq LstEnameShape   (nth 0 LstEname))
					(setq LstEnameTrigger (nth 1 LstEname))
						
					(setq Ck1 (CheckTriggerOnShape LstEnameShape LstEnameTrigger Fuzz))
					(if (not (car Ck1)) (LM:popup "Errore" "Attacchi su contorno [CheckExternalShape]" (+ 0 16 4096)))
					(setq Ck2 (CheckUnionTrigger LstEnameTrigger Fuzz))
					(if (not (car Ck2)) (LM:popup "Errore" "Attacchi entra esci [CheckExternalShape]" (+ 0 16 4096)))
					;(setq Ck3 (CheckPoligonInsidePoligon (cdr LstEnameShape)))
					;(if (not (car Ck3)) (LM:popup "Errore [CheckExternalShape]" "Contorno interno su interno" (+ 0 16 4096)))
					
					
					(if (CheckGroupShape LstEnameShape LstEnameTrigger)		; controllo nome gruppi non congruenti passato
						(if (car Ck1)										; controllo geometrico attacchi su contorno passato
							(if (car Ck2)									; controllo geometrico attacchi entra esci passato
								;(if (car Ck3)								; controllo geometrico contorno interno su interno passato
								;	(setq Rtn T)
								;)
								(setq Rtn T)
							)
						)
					)
					
					(if (not Rtn)
						(if Update
							(progn
								(setq LstDelete (LM:ListUnion (cadr Ck1) (cadr Ck2)))
								(setq LstDelete (LM:ListUnion LstDelete  (cadr Ck3)))
								
								(mapcar 'entdel LstDelete)
								;(setq Rtn T)
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
(defun Spline2LwPolyline (Ename Tolerance DelSpline / SplineGetPoints 
													  SplinePointLineDistance
													  StartParam EndParam StartDist EndDist Points Rtn)


	(defun SplineGetPoints (Ename Dist1 Dist2 Tolerance / P1 P2	DistM PM D Left Right)

		(setq P1 (vlax-curve-getPointAtDist Ename Dist1))
		(setq P2 (vlax-curve-getPointAtDist Ename Dist2))
		(if (and P1 P2)
			(progn
				(setq DistM (/ (+ Dist1 Dist2) 2.0))
				(setq PM	(vlax-curve-getPointAtDist Ename DistM))
				;; Distanza del punto medio dalla corda
				(setq D	(SplinePointLineDistance PM P1 P2))
				(if (<= D Tolerance)
					;; ------------------------------------------------
					;; Errore accettabile:
					;; il tratto può essere rappresentato da una linea
					;; ------------------------------------------------
					(list P1 P2)
					;; ------------------------------------------------
					;; Errore troppo elevato:
					;; dividiamo il tratto
					;; ------------------------------------------------
					(progn
						(setq Left  (SplineGetPoints Ename Dist1 DistM Tolerance))
						(setq Right (SplineGetPoints Ename DistM Dist2 Tolerance))
						;; Evita di duplicare il punto centrale
						(append	(reverse (cdr (reverse Left))) Right)
					)
				)
			)
		)
	)
	;
	(defun SplinePointLineDistance (P P1 P2 / DX DY PX PY TT X Y)

		(setq DX (- (car P2)  (car P1)))
		(setq DY (- (cadr P2) (cadr P1)))
		(setq PX (- (car P)   (car P1)))
		(setq PY (- (cadr P)  (cadr P1)))
		(setq TT
			(if (> (+ (* DX DX) (* DY DY)) 1e-20)
				(/ (+ (* PX DX) (* PY DY))
				   (+ (* DX DX) (* DY DY))
				)
				0.0
			)
		)
		(setq TT (max 0.0 (min 1.0 TT)))
		(setq X (+ (car P1) (* TT DX)))
		(setq Y (+ (cadr P1) (* TT DY)))
		(distance
			(list (car P) (cadr P))
			(list X Y)
		)
	)
	;
	; Main
	;
	(if (and Ename
			 (setq StartParam (vlax-curve-getStartParam Ename))
			 (setq EndParam   (vlax-curve-getEndParam Ename))
			 (> EndParam StartParam)
		)
		(progn
			(setq StartDist	(vlax-curve-getDistAtParam Ename StartParam))
			(setq EndDist   (vlax-curve-getDistAtParam Ename EndParam))
			;; Costruisce i punti adattivamente
			(setq Points (SplineGetPoints Ename	StartDist EndDist Tolerance))
			(if (> (length Points) 1)
				(progn
					;; Creazione LWPOLYLINE
					(setq Rtn (entmakex (append (list	'(0 . "LWPOLYLINE")	
														'(8 . "0")  
														'(100 . "AcDbEntity") '(100 . "AcDbPolyline")
														(cons 90 (length Points))
														'(70 . 0) '(43 . 0.0))
														(mapcar	'(lambda (P) (cons 10 (list (car P) (cadr P))))	Points))
							)
					)
					(if (and Rtn DelSpline) (DeleteEntity (list Ename)))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun Circle2LwPolyline (EnameCircle Flag / cmde csel cir cdata cctr crad cextdir pdata)
  
  (setq cir EnameCircle
		cdata (entget cir (list "*"))
        cctr (cdr (assoc 10 cdata))
        crad (cdr (assoc 40 cdata))
        cextdir (assoc 210 cdata)
  )
  (setq pdata (vl-remove-if-not '(lambda (x) (member (car x) '(67 410 8 62 6 48 370 39))) cdata)
		pdata  (append '((0 . "LWPOLYLINE") (100 . "AcDbEntity"))  pdata 
						'((100 . "AcDbPolyline") (90 . 2) (70 . 1) (43 . 0.0))
						(list (cons 38 (caddr cctr))
							  (cons 10 (list (- (car cctr) crad) (cadr cctr)))
							  '(40 . 0.0) '(41 . 0.0) '(42 . 1)
							  (cons 10 (list (+ (car cctr) crad) (cadr cctr)))
							  '(40 . 0.0) '(41 . 0.0) '(42 . 1)
								cextdir
						)
				)
  )
  (if (assoc -3 cdata ) (setq pdata (append pdata (list (assoc -3 cdata)))))
  
  (if Flag (entdel cir))
  (entmakex pdata)
)
;
;
;
(defun CircleLwpolyline (Radius Center)

	(if (and Radius Center)
		(entmakex 	(append '((0 . "LWPOLYLINE") (100 . "AcDbEntity") (100 . "AcDbPolyline"))
						'((90 . 2) (70 . 1) (43 . 0.0) (38 . 0.0))
						(list 
							  (cons 10 (list (- (car Center) Radius) (cadr Center)))
							 '(40 . 0.0) '(41 . 0.0) '(42 . 1) '(91 . 0)
							  (cons 10 (list (+ (car Center) Radius) (cadr Center)))
							 '(40 . 0.0) '(41 . 0.0) '(42 . 1) '(91 . 0)
							 '(210 0.0 0.0 1.0)
						)
					)		
		)
	)
)
;
;
;
(defun IsLwPolylineDummyCircle (EnamePoly Fuzz / MinPt MaxPt MidPt Pc Shape Num Radius RadiusControl itm Rtn Rad) 

	(if EnamePoly
		(progn
			(vla-getboundingbox (vlax-ename->vla-object EnamePoly) 'minpoint 'maxpoint)
			(setq MinPt (vlax-safearray->list minpoint))
			(setq MaxPt (vlax-safearray->list maxpoint))
			(if (equal (abs (- (car MaxPt) (car MinPt))) (abs (- (cadr MaxPt) (cadr MinPt))) Fuzz)
				(progn
					(setq MidPt (div (car MinPt) (cadr MinPt) (car MaxPt) (cadr MaxPt) 1))
					(setq Pc	(car MidPt))
					(setq Shape (get_vertices_dummy EnamePoly 0.05))
					(setq RadiusControl (distance Pc (car Shape)))
			
					(setq Rtn T)
					(foreach itm Shape
						(setq Radius (distance itm Pc))
						
						(if (not (equal Radius RadiusControl Fuzz))
							(setq Rtn nil)
							(setq Rad Radius)
						)
					)
				)
			)
		)
	)
	(if Rtn 
		(list Rad Pc)
		nil
	)
)
;
;
;
(defun IsLwPolylineCircle (EnamePoly / GetRadiusCenterPolyline Rtn)

	
	(defun GetRadiusCenterPolyline (EnamePoly / Vertex Conta P1 P2 Bu Rtn Center Radius)
	
		(if EnamePoly
			(progn
				(setq Vertex (LM:lwvertices (entget EnamePoly)))
				(setq Rtn T)
				(setq Conta 0)
				
				(if (equal (assoc 10 (car Vertex)) (assoc 10 (last Vertex)) $CenterCirclePolyline)
					(setq Vertex (reverse (cdr (reverse Vertex))))
				)
				
				
				(repeat (length Vertex)
					(if (< (1+ conta) (length Vertex))
						(progn
							(setq P1 (cdr (assoc 10 (nth (+ Conta 0) Vertex))))
							(setq P2 (cdr (assoc 10 (nth (+ Conta 1) Vertex))))
							(setq Bu (cdr (assoc 42 (nth (+ Conta 0) Vertex))))
						)
						(progn
							(setq P1 (cdr (assoc 10 (last Vertex))))
							(setq P2 (cdr (assoc 10 (car  Vertex))))
							(setq Bu (cdr (assoc 42 (last Vertex))))
						)
					)
				
					(if (/= Bu 0.0)
						(if (= Conta 0)
							(progn
								(setq Center (LM:bulgecentre P1 P2 Bu))
								(setq Radius (LM:bulgeradius P1 P2 Bu))
							)
							(if (not (equal Center (LM:bulgecentre P1 P2 Bu) $CenterCirclePolyline))
								(setq Rtn nil)
							)
						)
						(setq Rtn nil)
					)
					(setq Conta (1+ Conta))
				)
			)
		)
		(if Rtn
			(list Center Radius)
			nil
		)
	)
	;
	;
	;
	(if EnamePoly
		(if (= (cdr (assoc 0 (entget EnamePoly))) "LWPOLYLINE")
			(setq Rtn (GetRadiusCenterPolyline EnamePoly))
		)
	)
	Rtn
)
;
;
;
(defun IsLwComplanar (Ename / LstData Rtn)
	(if Ename
		(if (= (cdr (assoc 0 (setq LstData (entget Ename)))) "LWPOLYLINE")
			(progn
				(if (and (zerop (cdr (assoc 38 LstData)))
						 (equal (cdr (assoc 210 LstData)) (list 0.0 0.0 1.0))
					)
					(setq Rtn T)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun IsClosed (Ename Flag / Rtn co)

	(if Ename
		(if (= (cdr (assoc 0 (entget Ename))) "LWPOLYLINE")
			(if (vlax-curve-isClosed (vlax-ename->vla-object Ename))
				(setq Rtn T)
				(if Flag
					(progn
						(setq co (LM:lwvertices (entget Ename)))
						(if (equal (cdr (assoc 10 (car co))) (cdr (assoc 10 (car (reverse co)))) 0.1)
							(setq Rtn T)
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
(defun IsRegularPolygon (EnamePolyLine / Fuzz Rtn Vtx)

	(setq Rtn T)
	(setq Fuzz 0.1)
	
	; chech bulge ++++++
	(foreach Itm (LM:lwvertices (entget EnamePolyLine))
		(if (/= (cdr (assoc 42 Itm)) 0.0)
			(setq Rtn nil)
		)
	)
	; chech perimeter ++++++
	(if Rtn
		(progn
			(setq Vtx (LM:lwvertices (entget EnamePolyLine)))
			(if (= (vla-get-closed (vlax-ename->vla-object EnamePolyLine)) :vlax-true)
				(if (not (equal (* (distance (cdr (assoc 10 (nth 0 Vtx))) 
								             (cdr (assoc 10 (nth 1 Vtx)))) 
											 (length Vtx)) (vla-get-Length (vlax-ename->vla-object EnamePolyLine)) Fuzz))
					(setq Rtn nil)
				)
				(setq Rtn nil)
			)
		)
	)
	Rtn
)
;
;
;
(defun LwPolyline2Circle (EnamePoly Flag / GetRadiusCenterPolyline DataPoly Center Radius Pdata Cdata LstDxf Rtn)
  

	;
	;
	;
	(setq DataPoly (IsLwPolylineCircle EnamePoly))
	;(setq LstDxf   (entget EnamePoly (list "*")))
	
	
	(if DataPoly
		(progn
			(setq Center (car DataPoly))
			(setq Radius (cadr DataPoly))
			
			(setq Pdata (entget EnamePoly  (list "*")))
			(setq Cdata (vl-remove-if-not '(lambda (x) (member (car x) '(67 410 8 62 6 48 370 39))) Pdata))
			
			
			(setq cdata (append 	'((0 . "CIRCLE") (100 . "AcDbEntity"))
									Cdata
									(list 	'(100 . "AcDbCircle")
											(list 10 (car Center) (cadr Center) (cdr (assoc 38 Pdata)))
											(cons 40 Radius)
											(assoc 210 Pdata)
									)
						)
			)
			(if (assoc -3 Pdata ) (setq cdata (append cdata (list (assoc -3 Pdata )))))
			
			(setq Rtn (entmakex cdata))
			(if Rtn (if Flag (entdel EnamePoly)))
		)
	)
	Rtn
)
;
;
;
(defun Polyline2LwPolyline (EnamePoly)
	(command "_ConvertPoly" "_Light" EnamePoly "")
)
;
;
;
(defun Ellipse2LwPolyline (Ename Flag / *error* ElliToPoly 
										acdoc Rtn)

	(defun *error* (msg)
		(princ msg)
		(vla-endUndoMark acdoc)
	)
	;
	(defun ElliToPoly (el / ang<2pi 3dTo2dPt tan sublist k*bulge 
								  cl norm cen elv pt0 pt1 pt2 pt3 pt4 ac0
								  ac4 a04 a02 a24 bsc0 bsc2 bsc3 bsc4 plst blst spt spa
								  fspa srat ept epa fepa erat n)

		(defun ang<2pi (ang)
			(if (and (<= 0 ang) (< ang (* 2 pi)))
				ang
				(ang<2pi (rem (+ ang (* 2 pi)) (* 2 pi)))
			)
		)
		;
		(defun 3dTo2dPt (pt) (list (car pt) (cadr pt)))
		;
		(defun tan (a) (/ (sin a) (cos a)))
		;
		(defun sublist (lst start leng / n r)
			(if (or (not leng) (< (- (length lst) start) leng))
				(setq leng (- (length lst) start))
			)
			(setq n (+ start leng))
			(while (< start n)
				(setq r (cons (nth (setq n (1- n)) lst) r))
			)
		)
		;
		(defun k*bulge (b k / a)
			(setq a (atan b))
			(/ (sin (* k a)) (cos (* k a)))
		)
		;
		; Main
		;
		(setq	;cl   (= (ang<2pi (vla-get-StartAngle el)) (ang<2pi (vla-get-EndAngle el)))
			cl   (equal (vlax-get el 'Startpoint) (vlax-get el 'Endpoint) 1e-6)
			norm (vlax-get el 'Normal)
			cen  (trans (vlax-get el 'Center) 0 norm)
			elv  (caddr cen)
			cen  (3dTo2dPt cen)
			pt0  (mapcar '+ (trans (vlax-get el 'MajorAxis) 0 norm) cen)
			ac0  (angle cen pt0)
			pt4  (mapcar '+ cen (trans (vlax-get el 'MinorAxis) 0 norm))
			pt2  (3dTo2dPt (trans (vlax-curve-getPointAtparam el (/ pi 4.)) 0 norm))
			ac4  (angle cen pt4)
			a04  (angle pt0 pt4)
			a02  (angle pt0 pt2)
			a24  (angle pt2 pt4)
			bsc0 (/ (ang<2pi (- a02 ac4)) 2.)
			bsc2 (/ (ang<2pi (- a04 a02)) 2.)
			bsc3 (/ (ang<2pi (- a24 a04)) 2.)
			bsc4 (/ (ang<2pi (- (+ ac0 pi) a24)) 2.)
			pt1  (inters pt0 (polar pt0 (+ ac0 (/ pi 2.) bsc0) 1.)
						 pt2 (polar pt2 (+ a02 bsc2) 1.)
						 nil)
			pt3  (inters pt2 (polar pt2 (+ a04 bsc3) 1.)
						 pt4 (polar pt4 (+ a24 bsc4) 1.)
						 nil)
			plst (list pt4 pt3 pt2 pt1 pt0)
			blst (mapcar '(lambda (b) (tan (/ b 2.)))
					 (list bsc4 bsc3 bsc2 bsc0)
				 )
		)
		(foreach b blst
			(setq blst (cons b blst))
		)
		(foreach b blst
			(setq blst (cons b blst))
		)
		(foreach p (cdr plst)
			(setq ang  (angle cen p)
				  plst (cons (polar cen (+ ang (* 2 (- ac4 ang))) (distance cen p)) plst)
			)
		)
		(foreach p (cdr plst)
			(setq ang  (angle cen p)
				  plst (cons (polar cen (+ ang (* 2 (- ac0 ang))) (distance cen p))	plst)
			)
		)
		(setq pl
			(vlax-invoke
				(vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object)))
				'AddLightWeightPolyline
				(apply 'append (setq	plst (reverse (if cl (cdr plst) plst))))
			)
		)
		(vlax-put pl 'Normal norm)
		(vla-put-Elevation pl elv)
		(mapcar '(lambda (i v) (vla-SetBulge pl i v))
		  '(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)
		  blst
		)
		(if cl
			(vla-put-Closed pl :vlax-true)
			(progn
				(setq spt	(vlax-curve-getClosestPointTo pl (vlax-get el 'Startpoint))
					  spa	(vlax-curve-getParamAtPoint pl spt)
					  fspa 	(fix spa)
					  ept	(vlax-curve-getClosestPointTo pl (vlax-get el 'Endpoint))
					  epa	(vlax-curve-getParamAtPoint pl ept)
					  fepa 	(fix epa)
					  n	 	0
				)
				(cond
					((equal spt (trans pt0 norm 0) 1e-9)
						(if (= epa fepa)
							(setq plst (sublist plst 0 (1+ fepa))
								  blst (sublist blst 0 (1+ fepa))
							)
							(setq erat (/ (- (vlax-curve-getDistAtParam pl epa)	(vlax-curve-getDistAtParam pl fepa))
										  (- (vlax-curve-getDistAtParam pl (rem (1+ fepa) 17)) (vlax-curve-getDistAtParam pl fepa))
										)
								  plst (append (sublist plst 0 (1+ fepa)) (list (3dTo2dPt (trans ept 0 norm))))
								  blst (append (sublist blst 0 (1+ fepa)) (list (k*bulge (nth fepa blst) erat)))
							)
						)
					)
					((equal ept (trans pt0 norm 0) 1e-9)
						(if (= spa fspa)
							(setq plst (sublist plst fspa nil)
								  blst (sublist blst fspa nil)
							)
							(setq srat (/ (- (vlax-curve-getDistAtParam pl (rem (1+ fspa) 17)) (vlax-curve-getDistAtParam pl spa))
										  (- (vlax-curve-getDistAtParam pl (rem (1+ fspa) 17)) (vlax-curve-getDistAtParam pl fspa))
										)
								  plst (cons (3dTo2dPt (trans spt 0 norm)) (sublist plst (1+ fspa) nil))
								  blst (cons (k*bulge (nth fspa blst) srat) (sublist blst (1+ fspa) nil))
							)
						)
					)
					(T
						(setq srat (/ (- (vlax-curve-getDistAtParam pl (rem (1+ fspa) 17)) (vlax-curve-getDistAtParam pl spa))
									  (- (vlax-curve-getDistAtParam pl (rem (1+ fspa) 17)) (vlax-curve-getDistAtParam pl fspa))
									)
							  erat (/ (- (vlax-curve-getDistAtParam pl epa) (vlax-curve-getDistAtParam pl fepa))
									  (- (vlax-curve-getDistAtParam pl (rem (1+ fepa) 17)) (vlax-curve-getDistAtParam pl fepa))
									)
						)
						(if (< epa spa)
							(setq plst 	(append (if (= spa fspa) 
													(sublist plst fspa nil) 
													(cons (3dTo2dPt (trans spt 0 norm)) (sublist plst (1+ fspa) nil))
												)
												(cdr (sublist plst 0 (1+ fepa))) (if (/= epa fepa)
																					 (list (3dTo2dPt (trans ept 0 norm)))
																				)
										)
								  blst 	(append (if (= spa fspa)
													(sublist blst fspa nil)
													(cons (k*bulge (nth fspa blst) srat) (sublist blst (1+ fspa) nil))
												)
												(sublist blst 0 fepa) (if (= epa fepa)
																		  (list (nth fepa blst))
																		  (list (k*bulge (nth fepa blst) erat))
																		)
										)
							)
							(setq plst (append	(if (= spa fspa)
													(sublist plst fspa (1+ (- fepa fspa)))
													(cons (3dTo2dPt (trans spt 0 norm)) (sublist plst (1+ fspa) (- fepa fspa)))
												)
												(list (3dTo2dPt (trans ept 0 norm)))
										)
								  blst (append 	(if (= spa fspa)
													(sublist blst fspa (- fepa fspa))
													(cons (k*bulge (nth fspa blst) srat) (sublist blst (1+ fspa) (- fepa fspa)))
												)
												(if (= epa fepa)
													(list (nth fepa blst))
													(list (k*bulge (nth fepa blst) erat))
												)
										)
							)
						)
					)
				)
				(vlax-put pl 'Coordinates (apply 'append plst))
				(foreach b blst
					(vla-SetBulge pl n b)
					(setq n (1+ n))
				)
			)
		)
		pl
	)
	;
	; Main
	;
	(setq acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(if (= (cdr (assoc 0 (entget Ename))) "ELLIPSE")
		(progn
			(vla-StartUndoMark acdoc)
			(if (setq Rtn (ElliToPoly (vlax-ename->vla-object Ename)))
				(if Flag (entdel Ename))
			)
			(vla-EndUndoMark acdoc)
		)
	)
	(if Rtn 
		(vlax-vla-object->ename Rtn)
		nil
	)
)
;
;
;
(defun LwPolylineToSegmentPolyline (EnamePoly Flag / Rtn)

	(if EnamePoly
		(progn
			;(setq Rtn (MakePolyline (DiscretizeShape EnamePoly) T))
			(setq Rtn (MakePolyline (DiscretizeShapeNoControl EnamePoly) T))
			(if (and Rtn Flag)
				(entdel EnamePoly)
			)
		)
	)
	Rtn
)
;
;
;
(defun CheckPoly (Ename / co nv Rtn Foo Test1 Test2 Test3 Test4)

	
	; Rtn 	-1 	non è una polilinea
	;		 0	polylinea aperta
	;		 1	polylinea con vertici duplicati
	;		 2	polylinea anti oraria
	;		 3	polylinea oraria
	;		 4	polylinea 1° e ultimo vertice coincidente
	;		 5	polylinea autointersecante
	

	
	(if (= (cdr (assoc 0 (entget Ename))) "LWPOLYLINE")
		(progn
			(setq co (LM:lwvertices (entget Ename)))
			(setq nv (length co))
			(setq Foo 0.01)
			(if (TestVerticesOverlapping Ename) (setq Test1 T))												; vertici sovrapposti
			(setq Test2 (CheckSelfIntersectShape Ename)) 													; polilinea autointersecante
			(setq Test3 (<= (distance (cdr (assoc 10 (nth 0 co))) (cdr (assoc 10 (nth (- nv 1) co)))) Foo))	; primo e ultimo punto coincidenti
			(setq Test4 (= (vla-get-closed  (vlax-ename->vla-object Ename)) :vlax-false)) 					; polilinea chiusa
			
			
			(cond
				((= Test1 T)
					(setq Rtn 1)		; 1	polylinea con vertici duplicati
				)
				((= Test2 T)
					(setq Rtn 5)		; 5	polylinea autointersecante
				)
				((= Test3 T)
					(setq Rtn 4)		; 4	polylinea 1° e ultimo vertice coincidente
				)
				((= Test4 T)
					(setq Rtn 0)		; 0	polylinea aperta
				)
				(t
					(if (not Test4)
						(cond
							((= nv 2)
								(cond
									((> (cdr (assoc 42 (nth 0 co))) 0) (setq Rtn 2)) 	; 2 percorrenza Anti Oraria
									((< (cdr (assoc 42 (nth 0 co))) 0) (setq Rtn 3)) 	; 3 percorrenza Oraria
									((> (cdr (assoc 42 (nth 1 co))) 0) (setq Rtn 2)) 	; 2 percorrenza Anti Oraria
									((< (cdr (assoc 42 (nth 1 co))) 0) (setq Rtn 3)) 	; 3 percorrenza Oraria
								)
							)
							((> nv 2)
								(if (ClockWeis (vlax-get (vlax-ename->vla-object Ename) 'coordinates))
								(setq Rtn 3)	; 3 percorrenza Oraria
								(setq Rtn 2)	; 2 percorrenza Anti Oraria
								)
							)
						)
					)
				)
			)
				
				
			;(if Test
			;	(progn
			;		(setq rtn 1)															; polylinea con vertici duplicati
			;		(if (<= (distance (cdr (assoc 10 (nth 0 co))) (cdr (assoc 10 (nth (- nv 1) co)))) 0.01)
			;			(setq rtn 4) 														; primo e ultimo segmento coincidenti
			;		)
			;	)			
			;	(progn
			;		
			;		(if (= (vla-get-closed  (vlax-ename->vla-object Ename)) :vlax-true)
			;			(progn
			;				(cond
			;					((= nv 2)
			;						(cond
			;							((> (cdr (assoc 42 (nth 0 co))) 0) (setq rtn 2)) 	; percorrenza Anti Oraria
			;							((< (cdr (assoc 42 (nth 0 co))) 0) (setq rtn 3)) 	; percorrenza Oraria
			;							((> (cdr (assoc 42 (nth 1 co))) 0) (setq rtn 2)) 	; percorrenza Anti Oraria
			;							((< (cdr (assoc 42 (nth 1 co))) 0) (setq rtn 3)) 	; percorrenza Oraria
			;						)
			;					)
			;					((> nv 2)
			;						(if (ClockWeis (vlax-get (vlax-ename->vla-object Ename) 'coordinates))
			;							(setq rtn 3)
			;							(setq rtn 2)
			;						)
			;					)
			;				)
			;			)
			;			(progn	
			;				(setq rtn 0) 													; polylinea aperta
			;			)
			;		)
			;	)
			;)
		)
		(setq Rtn -1)	; -1 	non è una polilinea
	)
	(list Rtn)
)
;
;
;
(defun ClockWeisEname (EnamePoly / co nv Rtn)

	
	(if (= (cdr (assoc 0 (entget EnamePoly))) "LWPOLYLINE")
		(progn
			(if (= (vla-get-closed  (vlax-ename->vla-object EnamePoly)) :vlax-true)
				(progn
					(setq co (LM:lwvertices (entget EnamePoly)))
					(setq nv (length co))
					(cond
						((= nv 2)
							(cond
								((> (cdr (assoc 42 (nth 0 co))) 0) (setq Rtn 2)) 	; 2 percorrenza Anti Oraria
								((< (cdr (assoc 42 (nth 0 co))) 0) (setq Rtn 3)) 	; 3 percorrenza Oraria
								((> (cdr (assoc 42 (nth 1 co))) 0) (setq Rtn 2)) 	; 2 percorrenza Anti Oraria
								((< (cdr (assoc 42 (nth 1 co))) 0) (setq Rtn 3)) 	; 3 percorrenza Oraria
							)
						)
						((> nv 2)
							(if (ClockWeis (vlax-get (vlax-ename->vla-object EnamePoly) 'coordinates))
							(setq Rtn 3)	; 3 percorrenza Oraria
							(setq Rtn 2)	; 2 percorrenza Anti Oraria
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
(defun ClockWeis (Coords / conta lst Rtn) 

	(if Coords
		(progn
			(setq conta 0)
			(setq lst nil)
		
			(repeat (/ (length Coords) 2)
				(setq lst (append lst (list (list (nth conta Coords) (nth (1+ conta) Coords)) ))
					conta (+ 2 conta)
				)
			)
			(setq Rtn (LM:ListClockwise-p lst))
		)
	)
	Rtn
)
;
;
;
(defun RevLwpline (e / footer done vertices header flag)
  ;reverse lightweight polyline
  
  (if e
	(progn
		;(alert "Entro")
		(foreach item (reverse (entget e))
			
			(cond
				((not done)
					(cond
						((= (car item) 40)
							(setq footer (cons (cons 41 (cdr item)) footer)      ;swap width
								  done t
							)
						)
						((= (car item) 41)
							(setq footer (cons (cons 40 (cdr item)) footer))     ;swap width
						)
						((= (car item) 42)
							(setq footer (cons (cons 42 (- (cdr item))) footer)) ;negate bulge
						)
						((= (car item) 210)
							(setq footer (cons item footer))
						)
					)
				)
			
				((= (car item) 10)
					(setq vertices (cons item vertices))
				)
				((= (car item) 40)
					(setq vertices (cons (cons 41 (cdr item)) vertices))     ;swap width
				)
				((= (car item) 41)
					(setq vertices (cons (cons 40 (cdr item)) vertices))     ;swap width
				)
				((= (car item) 42)
					(setq vertices (cons (cons 42 (- (cdr item))) vertices)) ;negate bulge
				)
				(t (setq header (cons item header)))
			)
		)
		(setq flag (assoc 70 header))
		(if (< (cdr flag) 128)                 ;turn on linetype generation
			(setq header (subst (cons 70 (+ (cdr flag) 128)) flag header))
		)
		(entmod (append header (reverse vertices) footer))
	)
  )
)
;
;
;
(defun TestVerticesOverlapping (EnameShape / e i s Rtn)

	(defun LM:ListDupesFuzz ( l f / c r x )
		(while l
			(setq x (car l)
				  c (length l)
				  l (vl-remove-if '(lambda ( y ) (equal x y f)) (cdr l))
			)
			(if (< (length l) (1- c))
				(setq r (cons x r))
			)
		)
		(reverse r)
	)
	;
	;
	;
	(if EnameShape
		(foreach x
			(LM:ListDupesFuzz
					(vl-remove-if-not '(lambda ( x ) (= 10 (car x)))
						(setq e (entget EnameShape))
					)
					1e-8
			)
			;(command "_.zoom" "_Object"
			;	(entmakex
			;		(list
			;			'(0 . "CIRCLE")
			;			'(8 . "Duplicate-Vertices") ;; Layer
			;			x
			;			'(40 . 1.0) ;; Radius
			;			'(62 . 1) ;; Colour
			;			(assoc 210 e)
			;		)
			;	)
			;	""
			;)
			(setq Rtn (append Rtn (list x)))
			;(princ "\nPremi un tasto per il prossimo duplicato...")
			;(grread)
		)
	)
	Rtn
)
;
;
;
(defun RemoveDuplicateVertexLwPolyLine (EnamePolyline Fuzz / a n lst e1 e2 Rtn)

	(if EnamePolyline
		(progn
			(setq n 0)
			(setq e1 (entget EnamePolyline))
			(repeat (length e1)
					(setq a (nth n e1))
					(cond
						((not (equal 10 (car a) Fuzz))
							(setq e2 (cons a e2))
						)
						((not (equal (car lst) a Fuzz))
							(setq lst (cons a lst)
								  e2  (cons a e2)
							)
						)
					)
					(setq n (+ n 1))
			)
			(setq e2 (reverse e2))
			(if (and e2	(not (equal e1 e2)) lst)
				(progn
					(if (equal 1 (length lst))
						(progn
							(entdel (cdr (assoc -1 e1)))
							(setq e2 nil)
						)
						(progn
							(setq e2 (subst (cons 90 (length lst)) (assoc 90 e2) e2))
							(entmod e2)
							(setq Rtn T)
						)
					)
				)
				(setq Rtn nil)
			)
			e2
		)
	)
	Rtn
)
;
;
;
(defun movevertex (polyline vertex coord / vlapt)
		
		; la coordinata è espressa in valore OCS
		(setq vlapt (vlax-make-safearray vlax-vbdouble '(0 . 1)))
		(setq coord (list (nth 0 coord) (nth 1 coord)))
		(vlax-safearray-fill vlapt coord)
		(vla-put-Coordinate polyline vertex vlapt)
)
;
;
;
(defun DiscretizeCircle (EnameCircle)

	;
	; estraggo i punti di controllo
	;
	(if EnameCircle 
		(GetPtDivCircle (vlax-ename->vla-object EnameCircle))
	)
)
;
;
;
(defun DiscretizeCircumscribedCircle (EnameCircle)

	;
	; estraggo i punti di controllo
	;
	(if EnameCircle 
		(GetPtDivCircumscribedCircle (vlax-ename->vla-object EnameCircle))
	)
)
;
;
;
(defun DiscretizeShape (EnameShape / CoLwPl itm bulge Spara ObArc Out ContaV InfoShape LastPt)

	;(terpri) (princ (entget EnameShape)) (terpri)
	(if (= (vla-get-closed (vlax-ename->vla-object EnameShape)) :vlax-false)
		(vla-put-closed (vlax-ename->vla-object EnameShape) :vlax-true)
	)
	
	(setq InfoShape (CheckPoly EnameShape))
	(if (and (/= (nth 0 InfoShape) 2) (/= (nth 0 InfoShape) 3))
		(progn
			(alert "Polilinea con problemi [DiscretizeShape]")
			(exit)
		)
	)
	
	
	(setq CoLwPl 	(LM:lwvertices (entget EnameShape)))
	(if (/= (cdr (assoc 42 (nth (- (length CoLwPl) 1) CoLwPl))) 0)
			(setq LastPt (list (list (nth 0 (nth 0 CoLwPl)) (cons 40 0.0) (cons 41 0.0) (cons 42 0.0)))
				  CoLwPl (append CoLwPl LastPt)
			)
	)
	;
	; estraggo i punti di controllo
	;
	(setq ContaV 0)
	(setq Spara nil)
	(foreach itm CoLwPl
	
		(setq bulge (cdr (assoc 42 itm)))
		(if (/= bulge 0) ; -> arco
			(progn
			
				(setq Spara (append Spara (list (cdr (nth 0 itm))))
					  ObArc (LwPBulgeToArc (cdr (nth 0 (nth (+ 0 ContaV) CoLwPl))) 
										   (cdr (nth 0 (nth (+ 1 ContaV) CoLwPl))) bulge)
										   
				      Out 	(GetPtDivArc ObArc)
				)
				(vla-Delete ObArc)
				(if Out
					(progn
						(if (< bulge 0) (setq out (reverse out)))
						(setq Spara (append Spara Out))
					)
				)
			)
		)
		
	    (if (not (member (cdr (nth 0 itm)) Spara))
			(setq Spara (append Spara (list (cdr (nth 0 itm)))))
		)
		
		(setq ContaV (1+ ContaV))
	)
	Spara
)
;
;
;
(defun DiscretizeShapeNoControl (EnameShape / Clock CoLwPl itm bulge VertX ObArc Out ContaV InfoShape LastPt)

	;(setq Clock 	(ClockWeisEname EnameShape))
	(setq CoLwPl 	(LM:lwvertices (entget EnameShape)))

	(if (/= (cdr (assoc 42 (nth (- (length CoLwPl) 1) CoLwPl))) 0)
		(setq LastPt (list (list (nth 0 (nth 0 CoLwPl)) (cons 40 0.0) (cons 41 0.0) (cons 42 0.0)))
			  CoLwPl (append CoLwPl LastPt)
		)
	)
	;
	; estraggo i punti di controllo
	;
	(setq ContaV 0)
	(foreach itm CoLwPl
	
		(setq bulge (cdr (assoc 42 itm)))
		
		(if (/= bulge 0) ; -> arco
			(progn
			
				(setq VertX (append VertX (list (cdr (nth 0 itm))))
					  ObArc (LwPBulgeToArc (cdr (nth 0 (nth (+ 0 ContaV) CoLwPl))) 
										   (cdr (nth 0 (nth (+ 1 ContaV) CoLwPl))) bulge)
										   
				      Out 	(GetPtDivArc ObArc)
				)
				(vla-Delete ObArc)
				
				(if Out
					(progn
						(if (< bulge 0)	(setq out (reverse out)))
						(setq VertX (append VertX Out))
					)
				)
			)
		)
		
	    (if (not (member (cdr (nth 0 itm)) VertX))
			(setq VertX (append VertX (list (cdr (nth 0 itm)))))
		)
		
		(setq ContaV (1+ ContaV))
	)
	VertX
)
;
;
;
(defun InfillingShape (EnameShape Discretize Preci / LstCoo Pos Pstart Pend Nd Rtn)
			
		
		(setq LstCoo (DiscretizeShapeNoControl EnameShape))
		
		; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		(setq LstCoo (append LstCoo (list (car LstCoo))))
		(setq Pos 0)
	
		(repeat (1- (length LstCoo))
			
			(setq Pstart (nth Pos      LstCoo))
			(setq Pend   (nth (1+ Pos) LstCoo))
			(setq Rtn    (append Rtn (list Pstart)))
			
			
			(if (and 	(> (abs (- (car  Pstart) (car  Pend))) Preci)  	; Retta inclinata
						(> (abs (- (cadr Pstart) (cadr Pend))) Preci)	;
				)
				(progn
					(setq Nd 	 (fix (/ (distance Pstart Pend) Discretize)))
					(if (= Nd 0)
						(setq Rtn (append Rtn   (DivNoZero (car Pstart) (cadr Pstart) (car Pend) (cadr Pend) 1)))
						(setq Rtn (append Rtn   (DivNoZero (car Pstart) (cadr Pstart) (car Pend) (cadr Pend) Nd)))
					)
				)
				(setq Rtn (append Rtn   (DivNoZero (car Pstart) (cadr Pstart) (car Pend) (cadr Pend) 1)))
			)
			(setq Pos (1+ Pos))
		)
		Rtn
)
;
;
;
(defun InfillingPoligon (LstCoo Discretize Preci / LstCoo Pos Pstart Pend Nd Rtn)
	
		;(setq Preci 0.001)
		(if (> (distance (car LstCoo) (last LstCoo)) Preci)
			(setq LstCoo (append LstCoo (list (car LstCoo))))
		)
		
		(setq Pos 0)
		(repeat (1- (length LstCoo))
			
			(setq Pstart (nth Pos      LstCoo))
			(setq Pend   (nth (1+ Pos) LstCoo))
			(setq Rtn    (append Rtn (list Pstart)))
			
			(if (and 	(> (abs (- (car  Pstart) (car  Pend))) Preci) 	; Retta inclinata
						(> (abs (- (cadr Pstart) (cadr Pend))) Preci)	;
				)
				(progn
					(setq Nd (fix (/ (distance Pstart Pend) Discretize)))
					(if (= Nd 0)
						(setq Rtn (append Rtn  (DivNoZero (car Pstart) (cadr Pstart) (car Pend) (cadr Pend) 1)))
						(setq Rtn (append Rtn  (DivNoZero (car Pstart) (cadr Pstart) (car Pend) (cadr Pend) Nd)))
					)
				)
				(setq Rtn (append Rtn   (DivNoZero (car Pstart) (cadr Pstart) (car Pend) (cadr Pend) 1)))
			)
			(setq Pos (1+ Pos))
		)
		Rtn
)
;
;
;
(defun FenceSelect04 (EnameShape EnameSheet Dir / ArrowSelection SelectionShape FilterPointDirection
								 			      MoveSegment Dec Inc EnameOffset ModelSpace PtShape DimSheet XminSheet YminSheet XmaxSheet YmaxSheet SelShape 
												  Grp NotIncludeList Num itm Point MinDist Rtn)
	;
	(defun ArrowSelection (Arrow SelShape Point / Num conta i_pts px Rtn)
			
		(if (and Arrow SelShape)
			(progn
				(setq Num 0)
				(repeat (sslength SelShape)
					(setq conta 0)
					(setq i_pts  (vlax-variant-value (vla-IntersectWith (vlax-ename->vla-object Arrow) (vlax-ename->vla-object (ssname SelShape Num)) acExtendNone)))
					(if (> (vlax-safearray-get-u-bound i_pts 1) 0)
						(repeat (/ (length (vlax-safearray->list i_pts)) 3)
							(setq px    (list (nth (+ conta 0) (vlax-safearray->list i_pts))
											  (nth (+ conta 1) (vlax-safearray->list i_pts))
									    )
								  Rtn (append Rtn (list (distance px Point)))
								  conta (+ conta 3)
							)
						)
					)
					(setq Num (1+ Num))
				)
			)
		)
		(if Rtn (car (vl-sort Rtn '<)))
	)
	;
	(defun SelectionShape (EnameSheet EnameShape Dir / 	Margin
														DimSheet DimShape 
														XminShape YminShape XmaxShape YmaxShape XminSheet YminSheet XmaxSheet YmaxSheet Rtn)

		(if (and EnameSheet EnameShape Dir)
			(progn
				;(ZoomEname EnameSheet 100.0)
				(setq Margin 10.0)
				(setq DimSheet  (BoundingBoxLstEname (list EnameSheet)))
				(setq DimShape	(BoundingBoxLstEname (list EnameShape)))
				
				(setq XminShape	(car  (car  DimShape)) 
					  YminShape	(cadr (car  DimShape))
					  XmaxShape	(car  (caddr DimShape))
					  YmaxShape	(cadr (caddr DimShape))
				)
				(setq XminSheet	(car  (car  DimSheet))
					  YminSheet	(cadr (car  DimSheet))
					  XmaxSheet (car  (caddr DimSheet))
					  YmaxSheet	(cadr (caddr DimSheet))
				)
				(cond 
					((= Dir 1)
						(ZoomWindow01 	(list (- XminShape Margin) (- YminShape Margin)) 
										(list (+ XmaxSheet Margin) (+ YmaxShape Margin)))
						(setq Rtn (ssget "_C" (list XminShape YminShape) (list XmaxSheet YmaxShape) '((0 . "LWPOLYLINE"))))
						(ZoomPrevius01)
					)
					((= Dir 2) 
						(ZoomWindow01 	(list (- XminShape Margin) (- YminShape Margin)) 
										(list (+ XmaxShape Margin) (+ YmaxSheet Margin)))
						(setq Rtn (ssget "_C" (list XminShape YminShape) (list XmaxShape YmaxSheet) '((0 . "LWPOLYLINE"))))
						(ZoomPrevius01)
					)
					((= Dir 3) 
						(ZoomWindow01 	(list (- XminSheet Margin) (- YminShape Margin)) 
										(list (+ XmaxShape Margin) (+ YmaxShape Margin)))
						(setq Rtn (ssget "_C" (list XminSheet YminShape) (list XmaxShape YmaxShape) '((0 . "LWPOLYLINE"))))
						(ZoomPrevius01)
					)
					((= Dir 4) 
						(ZoomWindow01 	(list (- XminShape Margin) (- YminSheet Margin))
										(list (- XmaxShape Margin) (- YmaxShape Margin)))
						(setq Rtn (ssget "_C" (list XminShape YminSheet) (list XmaxShape YmaxShape) '((0 . "LWPOLYLINE"))))
						(ZoomPrevius01)
					)
				)
				
			)
		)
		(if Error
			nil
			Rtn
		)
	)
	;
	(defun FilterPointDirection (Arrow EnameShape / Rtn)
	
		(if (and ObjArrow EnameShape)
			(if (= (vlax-safearray-get-u-bound (vlax-variant-value (vla-IntersectWith (vlax-ename->vla-object Arrow) 
																					  (vlax-ename->vla-object EnameShape) acExtendNone)) 1) -1)
				(setq Rtn T)
				;(if (= (vlax-safearray-get-u-bound (vlax-variant-value (vla-IntersectWith (vlax-ename->vla-object Arrow) 
				;																	  (vlax-ename->vla-object EnameShape) acExtendNone)) 1) 2)
				;	(setq Rtn T)
				;)
			)
		)
		Rtn
	)
	;
	;
	; Main
	;
	(if (and EnameShape EnameSheet Dir)
		(progn
			(setq MoveSegment 	    1.0)
			(setq Dec 			   0.95)
			(setq Inc 		(- 1.0 Dec))
			;(setq MgSec 				 1.0)
			;(setq EnameOffset 			(GeneralOffset EnameShape (* Dec $MargineAccosto)))
			(setq EnameOffset 		(car (OffsetShapeDelimitated EnameShape (* Dec $MargineAccosto))))
			
			(setq ModelSpace 		(vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
			(setq PtShape	 		(get_vertices_dummy02 EnameOffset 10.0))
			(setq DimSheet   		(BoundingBoxLstEname (list EnameSheet)))
			(setq XminSheet	 		(car  (car  DimSheet)))
			(setq YminSheet	 		(cadr (car  DimSheet)))
			(setq XmaxSheet  		(car  (caddr DimSheet)))
			(setq YmaxSheet	 		(cadr (caddr DimSheet)))
			(setq SelShape   		(SelectionShape EnameSheet EnameOffset Dir))
			(setq Grp 				(gnames EnameShape))
			(setq NotIncludeList 	(GetEnameShape&TriggerByGroup (nth 0 Grp)))
			(setq NotIncludeList 	(append NotIncludeList (list EnameOffset))) 	
			; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			(foreach itm (LM:ss->ent SelShape)
				(if (member itm NotIncludeList)	(ssdel itm SelShape))
			)
			; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			(setq Num 0)
			(foreach  Point PtShape
				(cond 
					((= Dir 1) (setq ObjArrow (vla-addline ModelSpace (vlax-3d-point (+ (car Point) MoveSegment) (cadr Point)) (vlax-3d-point XmaxSheet (cadr Point) )))) 
					((= Dir 2) (setq ObjArrow (vla-addline ModelSpace (vlax-3d-point (car Point) (+ (cadr Point) MoveSegment)) (vlax-3d-point (car Point) YmaxSheet  ))))
					((= Dir 3) (setq ObjArrow (vla-addline ModelSpace (vlax-3d-point (- (car Point) MoveSegment) (cadr Point)) (vlax-3d-point XminSheet (cadr Point) ))))
					((= Dir 4) (setq ObjArrow (vla-addline ModelSpace (vlax-3d-point (car Point) (- (cadr Point) MoveSegment)) (vlax-3d-point (car Point) YminSheet  ))))
				)
				(if (FilterPointDirection (vlax-vla-object->ename ObjArrow) EnameOffset)
					(progn
						(setq Num (1+ Num))
						
						;(princ "\n") (princ (LM:ss->ent SelShape)) (princ "\n")
						
						(setq MinDist (ArrowSelection (vlax-vla-object->ename ObjArrow) SelShape Point))
						(if MinDist   (setq Rtn (append Rtn (list MinDist))))
					)
				)
				;(getstring "<>")
				(vla-delete ObjArrow)
			)
			;(princ "\nNumero vertici contorno ") (princ (length PtShape)) (princ "   vrertici controllati n. ") (princ Num) (princ "\n")
			(if Rtn (setq Rtn (- (car (vl-sort Rtn '<)) (* Inc $MargineAccosto))))
			(if EnameOffset (entdel EnameOffset))
		)
	)
	  Rtn
)
;
;
;
(defun MoveShapeAlongArrow (EnameShape / *error* MakeArrow DeletedArrow MakeSolidArrow DefinitionSolidArrow
										 msgLst Loop EnameSheet LstPointArrow gr code data direction LstArrow
										 Minval P1 P2 )

	(defun *error* (msg)
		(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
		(DeletedArrow)
		(redraw)
		(DeletedHatchEasyCut)
		(DeleteEntity LstArrow)
		(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
		(princ)
    )
	;
	(defun MakeArrow (EnameShape / LocalDimBox Pmin Pmax)
		
		(if EnameShape
			(progn
				(DeletedArrow)
				(setq LocalDimBox (ucs-bbox EnameShape))
				(setq Pmin (nth 0 LocalDimBox))
				(setq Pmax (nth 1 LocalDimBox))		
				(ArrowGraph 1 Pmin Pmax)
				(ArrowGraph 2 Pmin Pmax)
				(ArrowGraph 3 Pmin Pmax)
				(ArrowGraph 4 Pmin Pmax)
				(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-true)
				(append (list (ArrowGraph 1 Pmin Pmax)) (list (ArrowGraph 2 Pmin Pmax))
						(list (ArrowGraph 3 Pmin Pmax)) (list (ArrowGraph 4 Pmin Pmax)))
			)
		)
	)
	;
	(defun DeletedArrow ()
		(redraw)
	)
	;
	(defun MakeSolidArrow (Pa Pb Pc Pd Pe Pf Pg / AppendXdata)
	
		(defun AppendXdata (Ename)
			(entmod  (append (entget Ename) (list (list -3 (list $RgpTrash '(1002 . "{") '(1002 . "}"))))))
			(entupd Ename)
		)
	
		(if (and Pa Pb Pc Pd Pe Pf Pg)
			(list (AppendXdata (LM:MakeSolid Pa Pb Pc Pd))
				  (AppendXdata (LM:MakeSolid Pe Pf Pg Pg))
			)
		)
	)
	;
	(defun DefinitionSolidArrow (Pt LstPointArrow / itm Rtn Pos)
		(setq DirectionArrow$ nil)
		(setq Pos 0)
		(foreach itm LstPointArrow
			(setq Pos (1+ Pos))
			(if (MeInsideBPlane (list (nth 0 itm) (nth 1 itm) (nth 3 itm) (nth 5 itm)
									  (nth 6 itm) (nth 4 itm) (nth 2 itm))
								Pt)
				(progn
					(setq Rtn (MakeSolidArrow (nth 0 itm) (nth 1 itm) (nth 2 itm) (nth 3 itm)
											  (nth 4 itm) (nth 5 itm) (nth 6 itm)))
					(setq DirectionArrow$ Pos)
			
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq Loop T)
	(setq EnameSheet (GetEnameSheetByEnameShape EnameShape))
	(setq msgLst (strcat "\n<Esc / Enter>"))
	(princ msgLst)
	
    (while Loop
	
		
		(setq LstPointArrow (MakeArrow EnameShape))

		(setq gr (grread 't 15 0) code (car gr) data (cadr gr))
		(setq direction nil)
		
		
		(cond
			((= Code 2)
				(if (member data '(13 32 69 101)) ; enter space E e
					(progn
						(redraw)
						;(DeleteEntity LstArrow)
						(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
						(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
						(setq Loop nil)
					)
				)
			)
			((and (member Code '(5 3)) (listp Data))  ; Mouse rolling
				(setq LstPointArrow (MakeArrow EnameShape))
				
				(if (= Code 5)
					(progn
						;(DeleteEntity LstArrow)
						(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
						(setq LstArrow (DefinitionSolidArrow Data LstPointArrow))
					)
				)
				
				(if (= Code 3)						  ; Left click mouse
					(progn
						(redraw)
						;(princ "\n") (princ DirectionArrow$) 
						(if DirectionArrow$	(setq direction DirectionArrow$))
					)
				)
			)
		)
		; Action +++++++++++
		(if direction
			(progn
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq Minval (FenceSelect04 EnameShape EnameSheet direction))
				(princ msgLst)
				(if Minval
					(if (> Minval $MargineAccosto)
						(progn
							(cond
								((= direction 1) (setq P1 (list 0.0 0.0 0.0) P2 (list Minval 0.0 0.0)))
								((= direction 2) (setq P1 (list 0.0 0.0 0.0) P2 (list 0.0 Minval 0.0)))
								((= direction 3) (setq P1 (list 0.0 0.0 0.0) P2 (list (* Minval -1.0) 0.0 0.0)))
								((= direction 4) (setq P1 (list 0.0 0.0 0.0) P2 (list 0.0 (* Minval -1.0) 0.0)))
							)
							(setq EnameShape (car (Move+Rotate+MirrorShape EnameShape (list P1 P2 nil nil))))
							(MakeArrow EnameShape)
						)
					)
				)
			)
		)
	)
	(princ)
)
;
;
;
(defun ToolMove(/ *error*  MakeArrow DeletedArrow FreeMovePosition FreeCopyPosition FreeMirrorPosition FreeRotatePosition FreeLeanOnPosition
				  EnameShape msgLst EnameSheet loop gr code data LstPointArrow LstArrow
				  direction free move rotate mirror new copy nesting
				  Minval P1 P2)

	;
	(defun *error* (msg)
		(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
		(DeletedArrow)
		(redraw)
		(DeletedHatchEasyCut)
		(DeleteEntity LstArrow)
		(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
		;(if (>= (AcadVersion) 2015)
		;	(command-s "_undo" "")
		;	(command "_undo" "")
		;)
		(princ)
    )
	;
	(defun MakeArrow (EnameShape / LocalDimBox Pmin Pmax)
		
		(if EnameShape
			(progn
				(DeletedArrow)
				(setq LocalDimBox (ucs-bbox EnameShape))
				(setq Pmin (nth 0 LocalDimBox))
				(setq Pmax (nth 1 LocalDimBox))		
				(ArrowGraph 1 Pmin Pmax)
				(ArrowGraph 2 Pmin Pmax)
				(ArrowGraph 3 Pmin Pmax)
				(ArrowGraph 4 Pmin Pmax)
				(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-true)
				(append (list (ArrowGraph 1 Pmin Pmax)) (list (ArrowGraph 2 Pmin Pmax))
						(list (ArrowGraph 3 Pmin Pmax)) (list (ArrowGraph 4 Pmin Pmax)))
			)
		)
	)
	;
	(defun DeletedArrow ()
		(redraw)
	)
	;
	(defun FreeMovePosition (EnameShape / Ssel PtStart PtEnd EnameCheck Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				(setq Ssel    (SelectShape EnameShape))
				(setq PtStart (EnameCenter EnameShape))
				(setq PtEnd   (DragMove Ssel PtStart))
				(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtStart PtEnd nil nil)))
				(while (CheckIntersectionObjects EnameCheck (LM:ss->ent Ssel))
					(alert "Sovapposizione")
					(DeleteEntity (list EnameCheck))
					(setq PtEnd (DragMove Ssel PtStart))
					(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtStart PtEnd nil nil)))
				)
				(DeleteEntity (list EnameCheck))
				(setq Rtn (car (Move+Rotate+MirrorShape EnameShape (list PtStart PtEnd nil nil))))
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)
	;
	(defun FreePosition (EnameShape / Shape PtStart PtEnd Rotation Mirror Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				
				;(setq Shape 	  (DiscretizeShape EnameShape))
				(setq Shape 	  (DiscretizeShapeNoControl EnameShape))
				(setq PtStart     (EnameCenter EnameShape))
				(setq Rtn         (DinamicPositionLowGraphics Shape nil 1.0))	; Shape PtEnd Rotation Mirror
				(if Rtn
					(progn
						(setq Shape 	  (nth 0 Rtn))
						(setq PtEnd		  (nth 1 Rtn))
						(setq Rotation	  (nth 2 Rtn))
						(setq Mirror      (nth 3 Rtn))
						(setq Rtn (Move+Rotate+MirrorShape EnameShape (list PtStart PtEnd Rotation Mirror)))
					)
				)
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)
	;
	(defun FreeCopyPosition (EnameShape / Ssel PtStart PtEnd EnameCheck Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				(setq Ssel    (SelectShape EnameShape))
				(setq PtStart (EnameCenter EnameShape))
				(setq PtEnd   (DragMove Ssel PtStart))
				(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtStart PtEnd nil nil)))
				(while (CheckIntersectionObjects EnameCheck nil)
					(alert "Sovapposizione")
					(DeleteEntity (list EnameCheck))
					(setq PtEnd (DragMove Ssel PtStart))
					(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtStart PtEnd nil nil)))
				)
				(DeleteEntity (list EnameCheck))
				(setq Rtn (car (Copy+Rotate+MirrorShape EnameShape (list PtStart PtEnd nil nil))))
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)

	;
	(defun FreeMirrorPosition (EnameShape / Ssel PtStart PtEnd EnameCheck Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				(setq Ssel    (SelectShape EnameShape))
				(setq PtStart (EnameCenter EnameShape))
				(setq PtEnd   (DragMirror Ssel PtStart))
				(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtEnd PtEnd nil (angle PtStart PtEnd))))
				(while (CheckIntersectionObjects EnameCheck (LM:ss->ent Ssel))
					(alert "Sovapposizione")
					(DeleteEntity (list EnameCheck))
					(setq PtEnd (DragMirror Ssel PtStart))
					(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtEnd PtEnd nil (angle PtStart PtEnd))))
				)
				(DeleteEntity (list EnameCheck))
				(setq Rtn (car (Move+Rotate+MirrorShape EnameShape (list PtEnd PtEnd nil (angle PtStart PtEnd)))))
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)
	;
	(defun FreeRotatePosition (EnameShape / Ssel PtStart PtEnd EnameCheck Rtn)
		(if EnameShape
			(progn
				(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
				(setq Ssel    (SelectShape EnameShape))
				(setq PtStart (EnameCenter EnameShape))
				(setq PtEnd   (DragRotate Ssel PtStart))
				(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtEnd PtEnd (angle PtStart PtEnd) nil)))
				(while (CheckIntersectionObjects EnameCheck (LM:ss->ent Ssel))
					(alert "Sovapposizione")
					(DeleteEntity (list EnameCheck))
					(setq PtEnd (DragMirror Ssel PtStart))
					(setq EnameCheck (Copy+Rotate+MirrorDummy EnameShape (list PtEnd PtEnd (angle PtStart PtEnd) nil )))
				)
				(DeleteEntity (list EnameCheck))
				(setq Rtn (car (Move+Rotate+MirrorShape EnameShape (list PtEnd PtEnd (angle PtStart PtEnd) nil))))
				(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
			)
		)
		Rtn
	)
	;
	(defun FreeLeanOnPosition (EnameShape / *error* Loop PtRotate ActOsmode Rtn)
	
		(defun *error* (msg)
			(setvar "osmode" ActOsmode)
		)
		;
		(if EnameShape
			(progn
				(setq ActOsmode  (getvar "OSMODE"))
				(setvar "osmode" 39)
				(prompt "\nPunto di rotazione ")
				(setq Loop T)
				(while Loop
					(if (setq PtRotate (getpoint))
						(setq Loop nil)
					)
				)
				(setvar "osmode" ActOsmode)
				(if PtRotate
					(progn
						(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
						(setq Rtn (LeanOn EnameShape PtRotate))
						(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
					)
				)
			)
		)
		Rtn
	)
	;
	(defun MakeSolidArrow (Pa Pb Pc Pd Pe Pf Pg / AppendXdata)

		(defun AppendXdata (Ename)
			(entmod  (append (entget Ename) (list (list -3 (list $RgpTrash '(1002 . "{") '(1002 . "}"))))))
			(entupd Ename)
		)

		(if (and Pa Pb Pc Pd Pe Pf Pg)
			(list 	(AppendXdata (LM:MakeSolid Pa Pb Pc Pd))
					(AppendXdata (LM:MakeSolid Pe Pf Pg Pg))
			)
		)
	)
	;
	(defun DefinitionSolidArrow (Pt LstPointArrow / itm Rtn Pos)
		(setq DirectionArrow$ nil)
		(setq Pos 0)
		(foreach itm LstPointArrow
			(setq Pos (1+ Pos))
			(if (MeInsideBPlane (list (nth 0 itm) (nth 1 itm) (nth 3 itm) (nth 5 itm)
									  (nth 6 itm) (nth 4 itm) (nth 2 itm))
								Pt)
				(progn
					(setq Rtn (MakeSolidArrow (nth 0 itm) (nth 1 itm) (nth 2 itm) (nth 3 itm)
											  (nth 4 itm) (nth 5 itm) (nth 6 itm)))
					(setq DirectionArrow$ Pos)
					
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq Loop T)
	;(setq msgLst (strcat "\r[<>]arrow move | [L]ibero | [M]uovi | [R]uota | [S]pecchia | [C]opia | [N]uovo | [A]ppoggia | [D]ummy Nesting"))
	(setq msgLst (strcat "\r[L]ibero | [M]uovi | [R]uota | [S]pecchia | [C]opia | [N]uovo | [A]ppoggia | [D]ummy Nesting <Esc / Enter>"))
	
    (while loop

		; Input Data
		(if (not EnameShape)
			(progn
				(prompt "\nSagoma da muovere ")
				(if (setq EnameShape (SselSelectShape))
					(progn
						(setq EnameSheet (GetEnameSheetByEnameShape EnameShape))
						(if (not EnameSheet)
							(progn
								(alert "Manca la lamiera")
								(exit)
							)
						)
					)
				)
				(setq LstPointArrow (MakeArrow EnameShape))
				(princ msgLst)
			)
		)
		(setq gr (grread 't 15 2) code (car gr) data (cadr gr))
		
		(setq direction nil)
		(setq move 		nil)
		(setq free 		nil)
		(setq rotate 	nil)
		(setq mirror 	nil)
		(setq new 		nil)
		(setq copy 		nil)
		(setq lean_on 	nil)
		(setq nesting 	nil)
		
		(cond
			((= Code 2)
				(cond
					;((= data 54) 					; sposta Dx
					;	(setq direction 1)
					;)
					;((= data 56) 					; sposta Alto
					;	(setq direction 2)
					;)
					;((= data 52) 					; sposta Sx
					;	(setq direction 3)
					;)
					;((= data 50) 					; sposta Basso
					;	(setq direction 4)
					;)
					((or (= data 76) (= data 108)) 	; Libero (tasto l/L)
						(setq free 1)
					)
					((or (= data 77) (= data 109)) 	; Muovi (tasto m/M)
						(setq move 1)
					)
					((or (= data 99) (= data 67)) 	; duplica contorno (tasto c/C)
						(setq copy 1)
					)
					((or (= data 82) (= data 114)) 	; rotazione	(tasto r/R)
						(setq rotate 1)
					)
					((or (= data 83) (= data 115)) 	; specchia	(tasto s/S)
						(setq mirror 1)
					)
					((or (= data 78) (= data 110))	; nuovo (tasto N)
						(setq new 1)
					)
					((or (= data 65) (= data 97))	; appoggiare (tasto A/a)
						(setq lean_on 1)
					)
					((or (= data 68) (= data 100))	; (tasto D o d)
						(setq nesting 1)
						(redraw)
					)
					((member data '(13 32 69 101)) ; enter space E e
						(redraw)
						;(DeleteEntity LstArrow)
						(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
						(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
						(setq loop nil)
					)
				)
			)
			((and (member Code '(5 3)) (listp Data))  ; Mouse rolling
				(setq LstPointArrow (MakeArrow EnameShape))
				
				(if (= Code 5)
					(progn
						;(DeleteEntity LstArrow)
						(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
						(setq LstArrow (DefinitionSolidArrow Data LstPointArrow))
					)
				)
				
				(if (= Code 3)						  ; Left click mouse
					(progn
						(redraw)
						;(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
						;(setq loop nil)
						(if DirectionArrow$	(setq direction DirectionArrow$))
					)
				)
			)
		)
		; Action +++++++++++
		(if direction
			(progn
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq Minval (FenceSelect04 EnameShape EnameSheet direction))
				(princ msgLst)
				(if Minval
					(if (> Minval $MargineAccosto)
						(progn
							(cond
								((= direction 1) (setq P1 (list 0.0 0.0 0.0) P2 (list Minval 0.0 0.0)))
								((= direction 2) (setq P1 (list 0.0 0.0 0.0) P2 (list 0.0 Minval 0.0)))
								((= direction 3) (setq P1 (list 0.0 0.0 0.0) P2 (list (* Minval -1.0) 0.0 0.0)))
								((= direction 4) (setq P1 (list 0.0 0.0 0.0) P2 (list 0.0 (* Minval -1.0) 0.0)))
							)
							(setq EnameShape (car (Move+Rotate+MirrorShape EnameShape (list P1 P2 nil nil))))
						)
					)
				)
				(MakeArrow EnameShape)
			)
		)
		(if free
			(progn
				(redraw)
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq EnameShape (car (FreePosition EnameShape)))
				(MakeArrow EnameShape)
				(princ msgLst)
			)
		)
		(if move
			(progn
				(redraw)
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq EnameShape (FreeMovePosition EnameShape))
				(MakeArrow EnameShape)
				(princ msgLst)
			)
		)
		(if rotate
			(progn
				(redraw)
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq EnameShape (FreeRotatePosition EnameShape))
				(MakeArrow EnameShape)
				(princ msgLst)
			)
		)
		(if mirror
			(progn
				(redraw)
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq EnameShape (FreeMirrorPosition EnameShape))
				(MakeArrow EnameShape)
				(princ msgLst)
			)
		)
		(if copy
			(progn
				(redraw)
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq EnameShape (FreeCopyPosition EnameShape))
				(MakeArrow EnameShape)
				(princ msgLst)
			)
		)
2		(if new
			(progn
				(redraw)
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(vla-highlight (vlax-ename->vla-object EnameShape) :vlax-false)
				(setq EnameShape nil)
			)
		)
		(if lean_on
			(progn
				(redraw)
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq EnameShape (FreeLeanOnPosition EnameShape))
				(MakeArrow EnameShape)
				(princ msgLst)
			)
		)
		(if nesting
			(progn
				(redraw)
				;(DeleteEntity LstArrow)
				(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpTrash))))))
				(setq EnameShape (car (DummyNesting EnameShape T)))
				(MakeArrow EnameShape)
				(princ msgLst)
			)
		)
	)
	(princ)
)
;
;
;
(defun CloneShape (LstEnameShape / PurgeEntity UpdateIdShape
								   itm Ename LstObj GrName Rtn)
	;
	(defun PurgeEntity (Ename LstDxfCode / LstDxfEname itm  Data Rtn)
		
		;(setq LstDxfCode (list -1 5 102 330))
		
		(if Ename
			(progn
				(setq LstDxfEname (entget Ename (list "*")))
				(foreach itm LstDxfCode
					(while (setq Data (assoc itm LstDxfEname))
						(setq LstDxfEname (LM:RemoveNth (FindNthValToList LstDxfEname Data 1) LstDxfEname))
					)
				)
				(entdel ename)
				(setq Rtn (entmakex LstDxfEname))
			)
		)
		Rtn
	)
	;
	(defun UpdateIdShape (LstEnameShape / itm itm1 IdItm LstChk Ename RecordList xd_list Jou Typ)
	
	
		(foreach itm LstEnameShape
			
			(cond
				((= (CheckIfEasyCutShape itm) T)
					(setq IdItm (GetIdShape itm))
				)
				
				((=	(CheckIfEasyCutTrigger itm) T)
					(setq IdItm (GetIdTrigger itm))
				)
			)
			(if IdItm
				(if (assoc IdItm LstChk)
					(setq LstChk (subst (append (assoc IdItm LstChk) (list itm)) (assoc IdItm LstChk) LstChk))
					(setq LstChk (append LstChk (list (list IdItm itm))))
				)
			)
		)
		; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		(foreach itm LstChk
			(setq IdItm (Random_Str 9))
			(foreach Ename (cdr itm)
				(cond
					((= (CheckIfEasyCutShape Ename) T)
						(setq RecordList	(list	(GetNameShape	Ename) 		;nome piatto
													(GetCutShape	Ename) 		;compensazione taglio
													(GetComShape	Ename)		;nome commessa
													(GetPhaseShape	Ename) 		;nome fase
													(GetMatShape	Ename) 		;nome qualita
													(GetTkShape		Ename)		;spessore
													(Today)						;ultima modifica
													(GetQtaShape	Ename))) 	;quantita
						(setq Jou 					(GetJouShape 	Ename))
						(setq Typ					(GetTypShape 	Ename))

						(DetatchInfoEname Ename)
						(setq xd_list (list '(1002 . "}")))
						(foreach itm1 (reverse RecordList)
							(setq xd_list (cons (cons 1000 itm1) xd_list))
						)
						(setq xd_list (cons (cons 1000 Jou)		xd_list)	; percorrenza   ["0"]["2"]["3"]
							  xd_list (cons (cons 1000 IdItm)   xd_list)	; id pezzo      ["123456789"]
							  xd_list (cons (cons 1000 Typ)     xd_list)	; tipo contorno ["CE"] ["CI"]
							  xd_list (cons '(1002 . "{")       xd_list)
							  xd_list (cons $RgpShape 			xd_list)
							  xd_list (list -3 					xd_list)
						)
						(entmod (append (entget Ename) (list xd_list)))
						(entupd Ename)
					)
					((=	(CheckIfEasyCutTrigger Ename) T)
						(setq RecordList (GetDataTrigger Ename)) ; ("193689053" "*" "ENTRA")
						(setq xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 (cadr RecordList)) xd_list)
							  xd_list (cons (cons 1000 IdItm) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons (caddr RecordList) xd_list)
							  xd_list (list -3 xd_list)
						)
					)
				)
				(entmod (append (entget Ename) (list xd_list)))
				(entupd Ename)
			)
		)
	)
	;
	; Main
	;
	(if LstEnameShape
		(progn
			(foreach itm LstEnameShape
				(setq Ename  (PurgeEntity itm (list -1 5 102 330)))
				(setq LstObj (append LstObj (list (vlax-ename->vla-object Ename))))
			)
			;
			; assign group name ++++++++
			;
			(setq GrName (Random_Str 9))
			(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) GrName) 'appenditems LstObj)
			;
			; assign id name ++++++++
			;
			(UpdateIdShape (mapcar 'vlax-vla-object->ename LstObj))
			(setq Rtn (LstObj->LstEname LstObj))
		)
	)
	Rtn
)
;
;
;
(defun CloneEname (EnameMaster EnameClone NewId / DataShape DataTrigger ultent xd_list LstData
												  TypShape IdShape JouShape NameShape CutComp ComShape 
												  PhaseShape MatShape TkShape DateShape Quantita Segno TypeP)

	(if (and EnameMaster EnameClone NewId)
		(progn
				
			(if (assoc -3 (entget EnameMaster (list "*")))
				(cond
					((= (nth 0 (nth 1 (assoc -3 (entget EnameMaster (list "*"))))) $RgpShape)
						(setq LstData (nth 1  (assoc -3 (entget EnameMaster (list "*")))))
						(setq 	TypShape    (cdr (nth 2  LstData))  ;	["CE"] ["CI"]
								IdShape     (cdr (nth 3  LstData))  ;	["123456789"]
								JouShape    (cdr (nth 4  LstData))  ;	["0"]["2"]["3"]
								NameShape   (cdr (nth 5  LstData))  ;	["PIPPO"]
								CutComp     (cdr (nth 6  LstData))  ;	["0"]["1"]["2"]["3"]
								ComShape    (cdr (nth 7  LstData))  ;	["C2018032"]
								PhaseShape  (cdr (nth 8  LstData))  ;	["P100"]
								MatShape    (cdr (nth 9  LstData))  ;	["S355J0"]
								TkShape     (cdr (nth 10 LstData))  ;	["10"]
								DateShape   (cdr (nth 11 LstData))  ;	["10/11/2018"]
								Quantita    (cdr (nth 12 LstData))  ;	["100"]
						)					

						(setq ultent (entget EnameClone)
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 Quantita)	 xd_list)		; Quantita    	["100"]
							  xd_list (cons (cons 1000 DateShape)	 xd_list)		; DateShape   	["10/11/2018"]
							  xd_list (cons (cons 1000 TkShape)		 xd_list)		; TkShape     	["10"]
							  xd_list (cons (cons 1000 MatShape)	 xd_list)		; MatShape    	["S355J0"]
							  xd_list (cons (cons 1000 PhaseShape)	 xd_list)		; PhaseShape  	["P100"]
							  xd_list (cons (cons 1000 ComShape)	 xd_list)		; ComShape    	["C2018032"]
							  xd_list (cons (cons 1000 CutComp)	 	 xd_list)		; CutComp     	["0"]["1"]["2"]["3"]
							  xd_list (cons (cons 1000 NameShape)	 xd_list)		; NameShape   	["PIPPO"]
							  xd_list (cons (cons 1000 JouShape)	 xd_list)		; percorrenza   ["0"]["2"]["3"]
							  ;xd_list (cons (cons 1000 (Random_Str 9)) xd_list)	; id pezzo      ["123456789"]
							  xd_list (cons (cons 1000 NewId)		 xd_list)		; id pezzo      ["123456789"]
							  xd_list (cons (cons 1000 TypShape)     xd_list)		; tipo contorno ["CE"] ["CI"]
							  xd_list (cons '(1002 . "{")            xd_list)
							  xd_list (cons $RgpShape xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append ultent (list xd_list))
						)
						(entmod nuova_entita)
						(entupd EnameClone)
					)
					
					((or (= (nth 0 (nth 1 (assoc -3 (entget EnameMaster (list "*"))))) $RgpTiggerOn)
					     (= (nth 0 (nth 1 (assoc -3 (entget EnameMaster (list "*"))))) $RgpTiggerOff))
						
						(setq LstData (nth 1  (assoc -3 (entget EnameMaster (list "*")))))
						(setq 	Segno (cdr (nth 3 LstData))
								TypeP (nth 0 LstData)
						)
						
						(setq 	ultent (entget EnameClone)
								xd_list (list '(1002 . "}"))
								xd_list (cons (cons 1000 Segno) 	xd_list)
								;xd_list (cons (cons 1000 (Random_Str 9)) xd_list)
								xd_list (cons (cons 1000 NewId)		xd_list)
								xd_list (cons '(1002 . "{") 		xd_list)
								xd_list (cons TypeP 				xd_list)
								xd_list (list -3 					xd_list)
								nuova_entita (append ultent (list 	xd_list))
						)
						(entmod nuova_entita)
						(entupd EnameClone)
					)
				)
			)
		)
	)
)
;
;
;
(defun CloneShapeByGroupName (GroupName / LstShape LstTrigger EnameShape DataShape itm LstGroup LstGrpName LstEnameGrp Grp OldIdShape NewIdShape)

	(if GroupName
		(progn
			(setq LstEname (Genames GroupName))
			
			(foreach itm LstEname
				(cond
					((= (CheckIfEasyCutShape (cdr itm)) T)
						(setq LstShape (append LstShape (list (cdr itm))))
					)
				
					((=	(CheckIfEasyCutTrigger (cdr itm)) T)
						(setq LstTrigger (append LstTrigger (list (cdr itm))))
					)
				)
			)
			;
			; Contorni
			;
			(foreach EnameShape LstShape
				(setq DataShape (GetDataShape EnameShape))
				(if DataShape
					(progn
						; 0	TypShape   					*  ["CE"] ["CI"]		CE contorno esterno / CI contorno interno
						; 1	IdShape    					*  ["123456789"]		nome contorno -valore string-)
						; 2	JouShape   					*  ["0"] ["2"] ["3"]	percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
						; 3	NameShape  					*  ["PIPPO"]			nome piatto
						; 4	CutComp    					*  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto 2 dx / 3 sx
						; 5	(rtos LenghtCut 2 2)		*  ["100.3"]  			lunghezza taglio
						; 6	(list Timing Extime Intime)	*  ["10 min 5 sec" "2 min 3 sec" "12 min 8 sec"] tempo di taglio
						; 7	ComShape   					*  ["C2018032"]  	 	nome commessa
						; 8	PhaseShape 					*  ["P100"]  	 	    nome fase
						; 9	MatShape   					*  ["S355J0"] 	 	    nome qualita'
						;10	TkShape    					*  ["10"]  	 	        spessore
						;11	DateShape  					*  ["10/11/2018"]  	 	ultima modifica
						;12	QtaShape  					*  ["100"]	  	 		ultima modifica
						
						(setq OldIdShape (nth 1 DataShape))
						(setq NewIdShape (Random_Str 9))
						
						(ChangeRecordShape EnameShape 2  NewIdShape)
						(ChangeRecordShape EnameShape 10 (Today))
						;
						; Attacchi
						;
						(foreach EnameTrigger LstTrigger
							(setq DataTrigger (GetDataTrigger EnameTrigger))
							; DataTrigger = IdTrigger Segno Type
							(if DataTrigger
								(progn
									;1	IdTrigger     ["123456789"]	        	nome attacco -valore string-)
									;2	JouTrigger    ["-"] ["+"] ["*"] 		percorrenza attacco raggio [-/+] se "*" rettilineo
									(if (= (nth 0 DataTrigger) OldIdShape)
										(ChangeRecordTrigger EnameTrigger 1 NewIdShape)
									)
								)
							)
						)						
					)
				)
			)
			;
			; Attacchi
			;
			;
			; cambio i gruppi anonimi creati dalla copia in normali 
			;
			(setq LstGrp (GetAnonymousGroup))
			(foreach itm LstGrp
			    (setq GrName (Random_Str 9))
				(ChangeNameGroup GrName itm)
				(ChDescGroup GrName $RgpShape)
				(AnonymousToNormalgroup GrName)
			)
			(PurgeAllGroupUnentity)
		)
	)
)
;
;
;
;(defun CheckSelfIntersectShape (Ename / CheckSelfIntersect CheckOffset Rtn)
;
;	(defun CheckSelfIntersect (EnamePoly / pltyp plobj plverts plints)
;		
;		(setq 	pltyp (cdr (assoc 0 (entget EnamePoly)))
;				plobj (vlax-ename->vla-object EnamePoly)
;				plverts (length (safearray-value (variant-value (vla-get-Coordinates plobj))))
;				plints (/ (length (safearray-value (variant-value (vla-intersectwith plobj plobj acExtendNone)))) 3)
;		)
;		(setq plverts (/ plverts (if (= pltyp "LWPOLYLINE") 2 3)))
;		(if (vlax-curve-isClosed EnamePoly)
;				(< plverts plints)
;				(if (equal (vlax-curve-getStartPoint EnamePoly) (vlax-curve-getEndPoint EnamePoly) 1e-8); else - open
;					(<= plverts plints)
;					(<= plverts (1+ plints))
;				)
;		)
;	)
;	
;	(defun CheckOffset (EnamePoly / LstVal Rtn Obj itm NvObj Check CheckObj)
;	
;		(setq LstVal (list 0.05 -0.05))
;		(setq Rtn nil)
;		(if EnamePoly
;			(progn
;				(setq Obj 	(vlax-ename->vla-object EnamePoly))
;				(setq NvObj (length (safearray-value (variant-value (vla-get-Coordinates Obj)))))
;				(foreach itm LstVal
;					(if (= (type (setq Check (vl-catch-all-apply 'vla-offset (list Obj itm)))) 'variant)
;						(DeleteObject (vlax-safearray->list (vlax-variant-value Check)))
;						(setq Rtn T)
;					)
;				)
;			)
;		)
;		Rtn
;	)
;	
;	(if (and (not (CheckSelfIntersect Ename)) (not (CheckOffset Ename)))
;		(setq Rtn nil)
;		(setq Rtn T)
;	)
;	Rtn
;)
;
;
(defun CheckSelfIntersectShape (ename / LWP:_intersect LWP:_unique LWP:_pts
										obj parts n i j closed tol
										o1 o2 raw pts res)



	(defun LWP:_intersect (o1 o2 / r)

		(setq r
			(vl-catch-all-apply
				'vla-IntersectWith
				(list o1 o2 acExtendNone)
			)
		)
		(if (vl-catch-all-error-p r)
			nil
			r
		)
	)
	;
	;
	(defun LWP:_unique (lst tol / p out)

		(foreach p lst
			(if (not
					(vl-some
						'(lambda (q) (equal p q tol))
						out
					)
				)
				(setq out (cons p out))
			)
		)

		(reverse out)
	)
	;
	;
	(defun LWP:_pts (v / LWP:_unwrap
						 l out)

		(defun LWP:_unwrap (v)
			(cond
				((null v) nil)
				;; error ActiveX
				((vl-catch-all-error-p v) nil)
				;; Variant wrapper
				((= (type v) 'VARIANT)
					(LWP:_unwrap (vlax-variant-value v)))
					;; SAFEARRAY
				((= (type v) 'SAFEARRAY)
					(if (and v
						(>= (vlax-safearray-get-u-bound v 1)
							(vlax-safearray-get-l-bound v 1)))
						(vlax-safearray->list v)
						nil
					)
				)
				;; already list
				((listp v) v)
				(T nil)
			)
		)
		;
		; Main +++++
		;
		(setq l (LWP:_unwrap v))
		(if (and l (listp l))
			(progn
				(while (and l (>= (length l) 3))
					(setq out
						(cons
							(list (car l) (cadr l) (caddr l))
							out
						)
					)
					(setq l (cdddr l))
				)
				(reverse out)
			)
			nil
		)
	)	
	;
	; Main
	;
	(setq tol 1e-8)

	(setq obj (vlax-ename->vla-object ename))
	(setq closed (= :vlax-true (vla-get-Closed obj)))

	;; explode in memory
	(setq parts (vlax-safearray->list (vlax-variant-value (vla-Explode obj))))
	(setq n (length parts))
	(setq i 0)

	(while (< i n)

		(setq j (+ i 2))

		(while (< j n)

			(setq o1 (nth i parts))
			(setq o2 (nth j parts))

			;; skip adiacenti
			(if (not
				(or (= (abs (- i j)) 1)
					(and closed
						(= (min i j) 0)
						(= (max i j) (1- n)))))

					(progn

						;; safe intersect
						(setq raw (LWP:_intersect o1 o2))
						;; safe unwrap → points
						(setq pts (LWP:_pts raw))
						;; accumulate
						(if pts
							(foreach p pts
								(setq res (cons p res))
							)
						)
					)
			)
			(setq j (1+ j))
		)

		(setq i (1+ i))
	)
	;; cleanup
	(foreach o parts (vla-delete o))
	;; final unique
	(LWP:_unique res tol)
)
;
;
;
(defun CheckOverlappingShape (EnameShape / LstOffset Enameoffset Error Shape CheckZoom Ssel conta PointIntersect)
	(if EnameShape
		(progn
			(setq LstOffset (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value (vla-Offset (vlax-ename->vla-object EnameShape) $ArrowArcDivision)))))
			(setq LstOffset (SortArea LstOffset 1))
			
			(if (> (vla-get-area (vlax-ename->vla-object (car LstOffset))) (vla-get-area (vlax-ename->vla-object EnameShape)))
				(progn
					(setq Enameoffset (car LstOffset))
					(DeleteEntity (cdr LstOffset))
				)
				(progn
					(setq LstOffset (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value (vla-Offset (vlax-ename->vla-object EnameShape) (* $ArrowArcDivision -1.0))))))	
					(setq LstOffset (SortArea LstOffset 1))
					(if (> (vla-get-area (vlax-ename->vla-object (car LstOffset))) (vla-get-area (vlax-ename->vla-object EnameShape)))
						(progn
							(setq Enameoffset (car LstOffset))
							(DeleteEntity (cdr LstOffset))
						)
						(setq Error -1)
					)
				)
			)
			(if (not Error)
				(progn
					;(setq Shape (DiscretizeShape Enameoffset))
					(setq Shape (DiscretizeShapeNoControl Enameoffset))
					(setq CheckZoom (VisibleEname Enameoffset))
					(vla-Delete (vlax-ename->vla-object Enameoffset))
					(setq Ssel (ssget "_CP" Shape $FilterList))
					(ZoomPrevius CheckZoom)	
					(if Ssel	
						(progn
							(setq conta 0)
							(repeat (sslength Ssel)
								(if (not (equal (ssname Ssel conta) EnameShape))
									(progn
										(setq PointIntersect (MainVla-IntersectWith EnameShape (ssname Ssel conta)))
										(if PointIntersect (setq Rtn (append Rtn (list PointIntersect))))
									)							
								)	
								(setq conta (1+ conta))
							)
						)
					)
				)
			)
		)
	)
	(if Error
		Error
		Rtn
	)
)
;
;
;
;(defun CheckOverlappingShape (EnameShape / ObjOffset EnameOffset Shape CheckZoom Ssel conta itm PointIntersect Rtn)
;	
;	(if EnameShape
;		(progn
;			(setq ObjOffset (nth 0 (vlax-safearray->list (vlax-variant-value (vla-Offset (vlax-ename->vla-object EnameShape) $ArrowArcDivision)))))
;			
;			(if (< (vla-get-area ObjOffset) (vla-get-area (vlax-ename->vla-object EnameShape)))
;				(progn
;					(vla-Delete ObjOffset)
;					(setq Enameoffset (vlax-vla-object->ename (nth 0 (vlax-safearray->list (vlax-variant-value (vla-Offset (vlax-ename->vla-object EnameShape) (* $ArrowArcDivision -1.0)))))))
;				)	
;				(setq Enameoffset (vlax-vla-object->ename ObjOffset))
;			)	
;	
;			(setq Shape (DiscretizeShape Enameoffset))
;				
;			(setq CheckZoom (VisibleEname Enameoffset))
;				(vla-Delete (vlax-ename->vla-object Enameoffset))
;				(setq Ssel (ssget "_CP" Shape $FilterList))
;			(ZoomPrevius CheckZoom)			
;	
;			(if Ssel	
;				(progn
;					(setq conta 0)
;					(repeat (sslength Ssel)
;						(if (not (equal (ssname Ssel conta) EnameShape))
;							(progn
;								(setq PointIntersect (MainVla-IntersectWith EnameShape (ssname Ssel conta)))
;								(if PointIntersect (setq Rtn (append Rtn (list PointIntersect))))
;							)							
;						)	
;						(setq conta (1+ conta))
;					)
;				)
;			)			
;		)
;	)
;	Rtn
;)
;
;
;
(defun CheckGroupList ( / GrLst itm itm1 Id Rc LstSubGrp LstCheck Dscpnt LstEname Rtn)
	;	-1 = nessun grupo trovato
	;	 0 = gruppi con contorni e attacchi non congruenti es. 1 controno + 1 attacco senza uscita / ingresso 
	;	 1 = ok
	;    la condizione e soddisfatta quando  abbiamo un controno senza attacchi o un controno con attacchi in ingresso e uscita
	
	(PurgeAllGroupUnentity)
	(setq GrLst (GroupList))
	(if (not GrLst)
		(setq Rtn -1)
		(setq Rtn 1)
	)
	
	(foreach itm  GrLst
		(setq Dscpnt (Gdescription itm))
		(if (= Dscpnt $RgpShape)
			(progn
				(setq LstSubGrp nil)
				(setq LstEname (genames itm))
				(foreach itm1 LstEname

					(if (= (nth 0 (nth 1 (assoc -3 (entget (cdr itm1) (list "*"))))) $RgpShape)
						(setq Id (cdr (nth 3 (nth 1 (assoc -3 (entget (cdr itm1) (list "*")))))))
					)
					(if (= (nth 0 (nth 1 (assoc -3(entget (cdr itm1) (list "*"))))) $RgpTiggerOn)
						(setq Id (cdr (nth 2 (nth 1 (assoc -3 (entget (cdr itm1) (list "*")))))))
					)
					(if (= (nth 0 (nth 1 (assoc -3(entget (cdr itm1) (list "*"))))) $RgpTiggerOff)
						(setq Id (cdr (nth 2 (nth 1 (assoc -3 (entget (cdr itm1) (list "*")))))))
					)
					
					(if (assoc Id LstSubGrp)
						(progn
							(setq Rc (append (assoc Id LstSubGrp) (list (cdr itm1))))
							(setq LstSubGrp (subst Rc (assoc Id LstSubGrp) LstSubGrp))
						)
						(setq LstSubGrp (append LstSubGrp (list (list Id (cdr itm1)))))
					)
				)
				
				;(princ LstSubGrp)
				
				(foreach itm1 LstSubGrp
					(setq LstCheck (cdr itm1))
					;(princ LstCheck) (terpri)
					(if	(and (/= (length LstCheck) 1) (/= (length LstCheck) 3))
						(progn
							(setq Rtn 0)
							(foreach itm LstCheck
								(redraw itm 3)
							)
						)
					)
				)
			)
			(setq Rtn -1)
		)
	)
	Rtn
)	
;
;
;
(defun ListId->EnameDelete ()

	(setq $ListIdShape 		nil)
	(setq $ListIdTriggerOn 	nil)
	(setq $ListIdTriggerOff nil)
)
;
;
;
(defun ListId->EnameCreate (/ SselShape SselTriggerOn SselTriggerOff Conta Ename Id)

	(setq SselShape      (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape)))))
	(setq SselTriggerOn  (ssget "_X" (list (cons 67 0) (list -3 (list $RgpTiggerOn)))))
	(setq SselTriggerOff (ssget "_X" (list (cons 67 0) (list -3 (list $RgpTiggerOff)))))
	(setq $ListIdShape 		nil)
	(setq $ListIdTriggerOn 	nil)
	(setq $ListIdTriggerOff nil)
	
	(if SselShape
		(progn
			(setq Conta 0)
			(repeat (sslength SselShape)
				(setq Ename (ssname SselShape Conta))
				(setq Id (cdr (nth 3  (nth 1 (assoc -3 (entget Ename (list "*")))))))
				(setq $ListIdShape (append $ListIdShape (list (cons Id Ename))))
				(setq Conta (1+ Conta))
			)
		)
	)
	(if SselTriggerOn
		(progn
			(setq Conta 0)
			(repeat (sslength SselTriggerOn)
				(setq Ename (ssname SselTriggerOn Conta))
				(setq Id (cdr (nth 2  (nth 1 (assoc -3 (entget Ename (list "*")))))))
				(setq $ListIdTriggerOn (append $ListIdTriggerOn (list (cons Id Ename))))
				(setq Conta (1+ Conta))
			)
		)
	)
	(if SselTriggerOff
		(progn
			(setq Conta 0)
			(repeat (sslength SselTriggerOff)
				(setq Ename (ssname SselTriggerOff Conta))
				(setq Id (cdr (nth 2  (nth 1 (assoc -3 (entget Ename (list "*")))))))
				(setq $ListIdTriggerOff (append $ListIdTriggerOff (list (cons Id Ename))))
				(setq Conta (1+ Conta))
			)
		)
	)
)
;
;
;
(defun SselSelectShape ( / Ssel GrpLst LstEnameGroup itm TypShape Rtn)
		(setq Ssel (ssget "_+.:E:S" (list (list -3 (list (strcat $RgpShape "," $RgpTiggerOn "," $RgpTiggerOff))))))
		(if Ssel
			(progn
				(setq GrpLst (Gnames (ssname Ssel 0)))
				(if GrpLst (setq LstEnameGroup (Genames (nth 0 GrpLst))))
				(if LstEnameGroup
					(foreach itm LstEnameGroup
						;(vla-highlight (vlax-ename->vla-object (cdr itm)) :vlax-true)
						(setq TypShape (cdr (nth 2 (nth 1 (assoc -3 (entget (cdr itm) (list "*")))))))
						(if (= TypShape "CE")
							(setq Rtn (cdr itm))
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
(defun LoopSelectShape (/ GetSizeAperture GetEnameMember UnHighlight *error*
						Loop ViewSizeApertura Gr Code Data EnameMember LstEname)

    ;
    ; *error* ++++++++++++++++++
    ;
    (defun *error* (msg)
     
	  (UnHighlight LstEname)

      (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
          (princ (strcat "\n** Error: " msg " **")))
      (princ)
    )
	;
	(defun GetSizeAperture (/ SS VS PB SWP SHP AR WSD PPDU BOX)

		(setq 	SS (getvar "SCREENSIZE") 	; screen size in pixels
				VS (getvar "VIEWSIZE") 		; screen height in drawing units
				PB (getvar "pickbox") 		; get current pickbox size
				SWP (car SS) 				; width of screen in pixels
				SHP (cadr SS) 				; height of screen in pixels
				AR (/ SWP SHP) 				; aspect ratio width/height
				WSD (* VS AR) 				; width of screen dwg units = ratio times height
				PPDU (/ WSD SWP) 			; pixels per drawing unit
				BOX (/ (* VS (* 2 PB)) SHP) ; drawing units per pixel
		)
		;(command "._polygon" "4" (getvar "viewctr") "_c" (/ box 2))
		BOX
	)
	;
	(defun GetEnameMember (Ssel / GrpLst LstEnameGroup itm TypShape Rtn)

		(if Ssel
			(progn
				(setq GrpLst (Gnames (ssname Ssel 0)))
				(if GrpLst (setq LstEnameGroup (Genames (nth 0 GrpLst))))
				(if LstEnameGroup
					(foreach itm LstEnameGroup
						(vla-highlight (vlax-ename->vla-object (cdr itm)) :vlax-true)
						(setq TypShape (cdr (nth 2 (nth 1 (assoc -3 (entget (cdr itm) (list "*")))))))
						(if (= TypShape "CE")
							(setq Rtn (cdr itm))
						)
					)
				)	
			)
		)
		Rtn
	)
	;
	(defun UnHighlight (LstEnamePicked / itm itm1)
		(foreach itm LstEnamePicked
			(foreach itm1 (Genames (car (Gnames itm)))
				(vla-highlight (vlax-ename->vla-object (cdr itm1)) :vlax-false)
			)
		)
	)
	;
	; Main
	;
	(setq Loop T)
	(while Loop
		(setq ViewSizeApertura (GetSizeAperture))
		(setq Gr (grread t 15 2) Code (car Gr) Data (cadr Gr))
		
		(cond
			((and (= Code 2) (= Data 013)) ; Enter
				(setq Loop nil)
				(UnHighlight LstEname)
			)
			((= Code 3) 
				(if (setq EnameMember  (GetEnameMember (ssget "_C" (list (- (nth 0 Data) (/ ViewSizeApertura 2.0)) 
																		 (- (nth 1 Data) (/ ViewSizeApertura 2.0))) 
																   (list (+ (nth 0 Data) (/ ViewSizeApertura 2.0)) 
																         (+ (nth 1 Data) (/ ViewSizeApertura 2.0))))))				
					(setq LstEname (append LstEname (list EnameMember)))
				)
			)
		)
	)
	LstEname
)
;
;
;
(defun SortArea (LstEname Mode / itm area LstArea LstOut)
	
	(if (and LstEname Mode)
		(progn
			(foreach itm LstEname
				(setq area    (vla-get-area (vlax-ename->vla-object itm))
				      LstArea (append LstArea (list (list area itm)))
				)
			)
			(cond
				((= Mode 1)
					(setq LstArea (vl-sort LstArea (function (lambda (e1 e2)  (> (car e1) (car e2))))))
				)
				((= Mode -1)
					(setq LstArea (vl-sort LstArea (function (lambda (e1 e2)  (< (car e1) (car e2))))))
				)
			)
			(foreach itm LstArea
				(setq LstOut (append LstOut (list (nth 1 itm))))
			)		
		)
	)
)
;
;
;
;(defun SortAreaNearTo (LstEname Origin / PtCheck Loop Pos EnameTrigger PtCommon LstCheck LstRtn)
;		
;	(if (and LstEname Origin)
;		(progn
;			(setq PtCheck Origin)
;	
;			(while LstEname
;				(setq Pos 0)
;				(repeat (length LstEname)
;			
;					(setq EnameTrigger 	(GetEnameTriggerByEnameShape (nth Pos LstEname)))
;					(setq PtCommon 		(GetCommonPointTrigger (nth 0 EnameTrigger) (nth 1 EnameTrigger)))
;					(setq LstCheck 		(append LstCheck (list (list (distance PtCommon PtCheck) (nth Pos LstEname) PtCommon))))
;					(setq Pos (1+ Pos))
;				)
;			
;				(setq LstCheck 	(vl-sort LstCheck (function (lambda (e1 e2)  (< (car e1) (car e2))))))
;				(setq PtCheck 	(caddr (car LstCheck)))
;				(setq LstRtn 	(append LstRtn (list (cadr (car LstCheck)))))
;				(setq LstEname  (vl-remove (cadr (car LstCheck)) LstEname))
;				(setq LstCheck 	nil)
;			)	
;		)
;	)
;	LstRtn
;)
;
;
;
;(defun SortAreaNearTo (LstEname Origin / PtCheck itm EnameTrigger PtCommon LstCheck LstRtn)
;		
;	(if (and LstEname Origin)
;		(progn
;			(setq PtCheck Origin)
;			(foreach itm LstEname
;				(setq EnameTrigger 	(GetEnameTriggerByEnameShape itm))
;				(if (and (car EnameTrigger) (cadr EnameTrigger))
;					(progn
;						(setq PtCommon 		(GetCommonPointTrigger (nth 0 EnameTrigger) (nth 1 EnameTrigger)))
;						(setq LstCheck 		(append LstCheck (list (list (distance (list (car PtCommon) (cadr PtCommon)) PtCheck) itm))))
;					)
;					(princ "\nManca attacco") 
;				)
;			)
;			(foreach itm (vl-sort LstCheck (function (lambda (e1 e2)  (< (car e1) (car e2)))))
;				(setq LstRtn (append LstRtn (list (cadr itm))))
;			)	
;		)
;	)
;	LstRtn
;)
;
;
;
(defun SortAreaNearTo (LstEname Origin / GetOriginTrigger GetMinDist
										 Rtn LstRtn LstEname Origin)
		
	
	(defun GetOriginTrigger (Ename / EnameTrigger PtCommon)
		(if Ename
			(progn
				(setq EnameTrigger 	(GetEnameTriggerByEnameShape Ename))
				(if (and (car EnameTrigger) (cadr EnameTrigger))
					(progn
						(setq PtCommon 	(GetCommonPointTrigger (nth 0 EnameTrigger) (nth 1 EnameTrigger)))
						(list (car PtCommon) (cadr PtCommon))
					)
				)
			)
		)
	)
	;
	(defun GetMinDist (LstEname Origin / Itm PtRif LstCheck)
		(if (and LstEname Origin)
			(progn
				(foreach Itm LstEname
					(setq PtRif (GetOriginTrigger Itm))
					(if PtRif
						(setq LstCheck 	(append LstCheck (list (list Itm (distance Origin PtRif) PtRif))))
					)
				)
				(car (vl-sort LstCheck (function (lambda (e1 e2)  (< (cadr e1) (cadr e2))))))
			)
		)
	)
	;
	; Main
	;
	(if (and LstEname Origin)
		(repeat (length LstEname)
			(if (setq Rtn (GetMinDist LstEname Origin))
				(progn
					(setq LstRtn (append LstRtn (list (car Rtn))))
					(setq LstEname (vl-remove (car Rtn) LstEname))
					(setq Origin (caddr Rtn))
				)
			)
		)
	)
	LstRtn
)
;
; 
;
(defun SortAreaXY (LstEname / LstPoint EnameTrigger PtCommon itm)
	
		(foreach itm LstEname
			(setq EnameTrigger 	(GetEnameTriggerByEnameShape itm))
			(setq PtCommon 		(GetCommonPointTrigger (nth 0 EnameTrigger) (nth 1 EnameTrigger)))
			(setq LstPoint		(append LstPoint (list PtCommon)))
		)
		(SortEnameXY LstEname LstPoint "XY" 0.01)
)
;
; (SortEnameXY (list (car (entsel)) (car (entsel))) (list '(1 1) '(10 1)) "XY" 0.01)
;
(defun SortEnameXY (LstEname LstPoint Mode Fuzz / Comp Func Rtn)

	(defun Comp (opr1 item1 opr2 item2)
		(if (equal (item2 a) (item2 b) fuzz)
			(opr1 (item1 a) (item1 b))
			(opr2 (item2 a) (item2 b))
		)
	)
	;
	; Main
	;
	(if (and LstEname LstPoint Mode Fuzz)
		(progn
			(setq Func 	(cond
							((= Mode "XY"  )	'(lambda (a b) (Comp < car < cadr)))
							((= Mode "X-Y" ) 	'(lambda (a b) (Comp < car > cadr)))
							((= Mode "-XY" ) 	'(lambda (a b) (Comp > car < cadr)))
							((= Mode "-X-Y")	'(lambda (a b) (Comp > car > cadr)))
							((= Mode "YX"  )	'(lambda (a b) (Comp < cadr < car)))
							((= Mode "Y-X" ) 	'(lambda (a b) (Comp < cadr > car)))
							((= Mode "-YX" ) 	'(lambda (a b) (Comp > cadr < car)))
							((= Mode "-Y-X") 	'(lambda (a b) (Comp > cadr > car)))
							(t '(lambda (a b) t))
						)
			)
			(setq Rtn (mapcar '(lambda (idx) (nth idx LstEname)) (vl-sort-i LstPoint Func)))
		)
	)
	Rtn	
)
;
;
;
(defun SortXY (LstPt Mode Fuzz / Comp Func Rtn)
	; (sort-XY (list '(10 1) '(5 1) '(1 2) '(2 1) '(100 20)) "XY" 0.01)
	(defun Comp (opr1 item1 opr2 item2)
		(if (equal (item2 a) (item2 b) fuzz)
			(opr1 (item1 a) (item1 b))
			(opr2 (item2 a) (item2 b))
		)
	)
	;
	; Main
	;
	(if (and LstPt Mode Fuzz)
		(progn
			(setq Func 	(cond
							((= Mode "XY"  )	'(lambda (a b) (Comp < car < cadr)))
							((= Mode "X-Y" ) 	'(lambda (a b) (Comp < car > cadr)))
							((= Mode "-XY" ) 	'(lambda (a b) (Comp > car < cadr)))
							((= Mode "-X-Y")	'(lambda (a b) (Comp > car > cadr)))
							((= Mode "YX"  )	'(lambda (a b) (Comp < cadr < car)))
							((= Mode "Y-X" ) 	'(lambda (a b) (Comp < cadr > car)))
							((= Mode "-YX" ) 	'(lambda (a b) (Comp > cadr < car)))
							((= Mode "-Y-X") 	'(lambda (a b) (Comp > cadr > car)))
							(t '(lambda (a b) t))
						)
			)
			(setq Rtn (vl-sort LstPt Func))
		)
	)
	Rtn
)
;
;
;
(defun SelectShape (EnameShape / ExShape InShape TrShape Rtn LstGrp LstEname itm)

	;GetTypeShape (EnameDummy / TypEnt Flag)
	;
	;ritorna :	-1 errore
	;			0  non è un contorno trattato
	;			1  è un controno esterno
	;			2  è un contorno interno
	;			3  è un attacco entra
	;			4  è un attacco esci
	(if EnameShape
		(progn
			
			(setq LstGrp (gnames EnameShape))
			(if LstGrp (setq LstEname (genames (nth 0 LstGrp))))
			
			(if LstEname
				(progn
					
					(foreach itm LstEname
						(if (= (GetTypeShape (cdr itm)) 1)
							(setq ExShape (cdr itm))
						)
						(if (= (GetTypeShape (cdr itm)) 2)
							(setq InShape (cons (cdr itm) InShape))
						)
						(if (or (= (GetTypeShape (cdr itm)) 3) (= (GetTypeShape (cdr itm)) 4))
							(setq TrShape (cons (cdr itm) TrShape))
						)
					)
					
					(setq Rtn (ssadd))
					(foreach itm (append (list ExShape) InShape TrShape (GetEnameHatchEasyCut))	
						(ssadd itm Rtn)
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
(defun DeleteShape (EnameShape / itm)
	(foreach itm (LM:ss->ent (SelectShape EnameShape))
		(DeleteEntity (list itm))
	)
)
;
;
;
(defun Move+Rotate+MirrorDummy (EnameDummy LstPos / PtStart PtEnd AngRot AngMirr Obj Rtn)

	(if (and EnameDummy LstPos)
		(progn
			(setq PtStart	(car    LstPos))
			(setq PtEnd		(cadr   LstPos))
			(setq AngRot	(caddr  LstPos))
			(setq AngMirr	(cadddr LstPos))
			
			(setq Obj (vlax-ename->vla-object EnameDummy))
			(vla-Move Obj (vlax-3d-point PtStart) (vlax-3d-point PtEnd))

			(if AngRot (vla-rotate Obj (vlax-3d-point PtEnd) AngRot))
			(if AngMirr
				(progn
					(setq Obj (vla-mirror Obj (vlax-3d-point PtEnd) (vlax-3d-point (polar PtEnd AngMirr 1.0))))
					(DeleteEntity (list EnameDummy))
				)
			)
				
			(setq Rtn (vlax-vla-object->ename Obj))
		)
	)
	Rtn
)
;
;
;
(defun Move+Rotate+MirrorShape (EnameShape LstPos / itm Rtn)

	(if (and EnameShape LstPos)
		(foreach itm (LM:ss->ent (SelectShape EnameShape))
			(setq Rtn (append Rtn (list (Move+Rotate+MirrorDummy itm LstPos))))
		)
	)
	(CloneShape Rtn)
)
;
;
;
(defun Copy+Rotate+MirrorDummy (EnameDummy LstPos / PtStart PtEnd AngRot AngMirr Obj Rtn)

	(if (and EnameDummy LstPos)
		(progn
		
			(setq PtStart 	(car    LstPos))
			(setq PtEnd		(cadr   LstPos))
			(setq AngRot	(caddr  LstPos))
			(setq AngMirr	(cadddr LstPos))

			(setq Obj (vla-Copy (vlax-ename->vla-object EnameDummy)))
			(vla-Move Obj (vlax-3d-point PtStart) (vlax-3d-point PtEnd))

			(if AngRot (vla-rotate Obj (vlax-3d-point PtEnd) AngRot))
		
			(if AngMirr
				(progn
					(setq Rtn (vlax-vla-object->ename (vla-mirror Obj (vlax-3d-point PtEnd) (vlax-3d-point (polar PtEnd AngMirr 1.0)))))
					(DeleteEntity (list (vlax-vla-object->ename Obj)))
				)
				(setq Rtn (vlax-vla-object->ename Obj))
			)
		)
	)
	Rtn
)
;
;
;
(defun Copy+Rotate+MirrorShape (EnameShape LstPos / itm Rtn)

	(if (and EnameShape LstPos)
		(foreach itm (LM:ss->ent (SelectShape EnameShape))
			(setq Rtn (append Rtn (list (Copy+Rotate+MirrorDummy itm LstPos))))
		)
	)
	(CloneShape Rtn)
)
;
;
;
(defun GetDivArc1 (r i / L S)
	; restituisce lo sviluppo dell'arco imponenedo un rapporto i e un raggio r noto
	(setq L (/ (* 8.0 i r) (+ (* 4 (* i i)) 1.0)))
	(setq S (* (* (atan(/ (/ L 2.0) r)) 2.0) r))
)
;
;
;
(defun GetDivArc2 (r f / L S)
	; restituisce lo sviluppo dell'arco imponenedo una freccia max f e un raggio r noto
	(if (>= (* r r) (* (- f r) (- f r)))
		(progn
			(setq L (sqrt (* (- (* r r) (* (- f r) (- f r))) 4.0)))
			(if (> (setq S (* (* (atan(/ (/ L 2.0) r)) 2.0) r)) f)
				S
			)
		)
		nil
	)
)
;
;
;
(defun GetPtDivCircumscribedArc (ObjArc / Radius Center StartAngle EndAngle ModelSpace Obj Rtn)

	(if ObjArc
		(progn
			(setq Radius 	 (vla-get-Radius ObjArc))
			(setq Center     (vlax-get ObjArc 'center))
			(setq StartAngle (vlax-get ObjArc 'StartAngle))
			(setq EndAngle   (vlax-get ObjArc 'EndAngle))
			
			(setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
			(setq Obj     	 (vla-addArc ModelSpace (vlax-3d-point Center) (+ Radius $ArrowArcDivision) StartAngle EndAngle))
			(if (setq Rtn 	 (GetPtDivArc Obj))
				(setq Rtn 	 (append (list (vlax-get Obj 'StartPoint)) Rtn (list (vlax-get Obj 'EndPoint))))
			)
			(DeleteObject 	 (list Obj))
			;(MakePolyline Rtn nil)
		)
	)
	Rtn	
)
;
;
;
(defun GetPtDivCircumscribedCircle (ObjCircle / Radius Center ModelSpace Obj Rtn)

	(if ObjCircle
		(progn
			(setq Radius 	 (vla-get-Radius ObjCircle))
			(setq Center     (vlax-get ObjCircle 'center))
			(setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
			(setq Obj     	 (vla-addcircle ModelSpace (vlax-3d-point Center) (+ Radius $ArrowArcDivision)))
			(setq Rtn 		 (GetPtDivCircle Obj))
			(DeleteObject 	 (list Obj))
			;(MakePolyline Rtn T)
		)
	)
	Rtn	
)
;
;
;
(defun GetPtDivCircle (ObjCircle / Radius Center DistDivide Ndiv AngDiv StepAng Rtn)

	(if ObjCircle
		(progn
			(setq Radius 	 	(vla-get-Radius ObjCircle)
				  Center     	(vlax-get ObjCircle 'center)
				  DistDivide 	(GetDivArc2 Radius $ArrowArcDivision)
				  Ndiv		 	(fix (/ (vla-get-Circumference ObjCircle) DistDivide))
			)
			(if (> Ndiv 0)
				(progn
					(setq AngDiv  (/ (* 2.0 Pi) Ndiv)
						  StepAng 0.0
					)
					(repeat Ndiv
						(setq Rtn (append Rtn (list (polar Center StepAng Radius))))
						(setq StepAng (+ StepAng AngDiv))
					)
					;(MakePolyline Rtn T)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetPtDivArc (ObjArc / LgArc Radius DistDivide Ndi Prg Out)

	(if ObjArc
		(progn
			(setq LgArc  	(vla-get-ArcLength ObjArc)
				  Radius 	(vla-get-Radius ObjArc)
			)
			(if (setq DistDivide (GetDivArc2 Radius $ArrowArcDivision))
				(progn
					(setq Ndi (fix (/ LgArc DistDivide)))
					(if (= Ndi 0) 
						(setq Ndi 1) 
						(setq Ndi (1+ Ndi))
					)
					(setq DistDivide (/ LgArc Ndi)
						  Prg DistDivide
					)
					(repeat (- Ndi 1)
						(if (not Out)
							(setq Out (list (vlax-curve-getPointAtDist ObjArc Prg)))
							(setq Out (append Out (list (vlax-curve-getPointAtDist ObjArc Prg))))
						)
						(setq Prg (+ Prg DistDivide))
					)
					Out
				)
			)
		)
	)
)
;
;
;
(defun LwPBulgeToArc ( p1 p2 b / a c r ms)

    (setq a (* 2 (atan b))
          r (/ (distance p1 p2) 2 (sin a))
          c (polar p1 (+ (- (/ pi 2) a) (angle p1 p2)) r)
		  ms (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object)))
    )
	(if (minusp b)
		(vla-addArc ms (vlax-3d-point c) (abs r) (angle c p2) (angle c p1))
		(vla-addArc ms (vlax-3d-point c) (abs r) (angle c p1) (angle c p2))
	)
)
;
;
;
(defun GetBarCode (Enameshape / DataShape Width Height LstDataBarCode itm StrBarCode)

	(if EnameShape
		(progn
			(setq DataShape (GetDataShape Enameshape))
			(if DataShape
				(progn
					;$LstDataBarCode	"------"			
					;					"ID CONTORNO"		(nth 1 LstInfoShape)
					;					"COMMESSA"			(nth 7 LstInfoShape)
					;					"FASE"				(nth 8 LstInfoShape)
					;					"MARCA" 			(nth 3 LstInfoShape)
					;					"SPESSORE" 			(nth 10 LstInfoShape)
					;					"LUNGHEZZA"			(rtos WidthShape 2 1) 
					;					"LARGHEZZA" 		(rtos HeightShape 2 1)	
					;					"PERIMETRO" 		(rtos LenghtCut 2 1)
					;					"MATERIALE" 		(nth 9 LstInfoShape)
					;					"PESO" 				(rtos (* (/ (vla-get-area   (vlax-ename->vla-object (nth 0 LstEnameShape))) 1000000.0) (atof (nth 10 LstInfoShape)) 7.85) 2 2)
					;					"CONTORNO" 			"Esterno"
					;					"PERCORRENZA"		Percorrenza 
					;					"COMPENSAZIONE"		Compensa 
					;					"TEMPO TAGLIO"		(nth 0 (nth 6 LstInfoShape)) 
					;					"ULTIMA MODIFICA"	(Today)
					
					(vla-getboundingbox (vlax-ename->vla-object Enameshape) 'mnl 'mxl)
					(setq Width   		(abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
					(setq Height  		(abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
					
					(cond 
						((= (nth 2 DataShape) "0") (setq Percorrenza "Contorno Aperto"))
						((= (nth 2 DataShape) "2") (setq Percorrenza "Antioraria"))
						((= (nth 2 DataShape) "3") (setq Percorrenza "Oraria"))
					)
					(cond 
						((= (nth 4 DataShape) "0") (setq Compensa "Nessuna"))
						((= (nth 4 DataShape) "1") (setq Compensa "Automatica"))
						((= (nth 4 DataShape) "2") (setq Compensa "Destra"))
						((= (nth 4 DataShape) "3") (setq Compensa "Sinistra"))
					)
					(setq LstDataBarCode 	(list 	"------"
											(nth 1 DataShape)
											(nth 7 DataShape)
											(nth 8 DataShape)
											(nth 3 DataShape)
											(nth 10 DataShape)
											(rtos Width 2 1) 
											(rtos Height 2 1)	
											(rtos (GetLengthEname Enameshape) 2 1)
											(nth 9 DataShape)
											(rtos (* (/ (vla-get-area   (vlax-ename->vla-object Enameshape)) 1000000.0) (atof (nth 10 DataShape)) 7.85) 2 2)
											"Esterno"
											Percorrenza 
											Compensa 
											(nth 0 (nth 6 DataShape)) 
											(nth 11 DataShape)
										)
					)

					(setq LstBarCode (GetDataBarCode))
					; composizione Codice a Barre
					;((-1 96) (1 124) (2 124) (4 0) (-1 96))
					(setq StrBarCode "")
					(foreach itm LstBarCode
						(cond 
							((= (nth 0 itm) -1)
								(setq StrBarCode (strcat StrBarCode (chr (nth 1 itm))))
							)
							(t
								(setq StrBarCode (strcat StrBarCode (nth (nth 0 itm) LstDataBarCode) (chr (nth 1 itm))))
							)
						)
					)
				)
			)
		)
	)
	StrBarCode
)
;
;
;
(defun LwPolyToSegment (EnameLwPoly Flag / ObjArr)

	(if EnameLwPoly
		(progn
			(setq variant (vlax-variant-value (vla-Explode (vlax-ename->vla-object EnameLwPoly))))
			(if (safearray-value variant)
				(progn
					(setq ObjArr (vlax-safearray->list variant))
					(if Flag (DeleteEntity (list EnameLwPoly)))
				)
			)
		)
	)
	ObjArr
)
;
;
;
(defun c:tarc()

	(setvar "pickstyle" 0)
	(setq ent (entsel "\nChek Segmento "))
	
	(setq vr  		(vlax-curve-getParamAtPoint (vlax-ename->vla-object (car ent)) (trans (osnap (cadr ent) "_nea") 1 0)))
	(setq bulge 	(vla-getbulge (vlax-ename->vla-object (car ent)) (fix vr)))
	(setq coordsecs (vlax-get (vlax-ename->vla-object (car ent)) 'coordinates))
	(setq nv		(/ (length coordsecs) 2.0))
	(setq iniecs    (list (nth (+ (* 2 (fix vr)) 0) coordsecs)
						  (nth (+ (* 2 (fix vr)) 1) coordsecs)))
	(if (= (- nv 1) (fix vr))
		(setq finecs (list (nth 0 coordsecs)
				           (nth 1 coordsecs)
				     )
		)
		(setq finecs (list (nth (+ (* 2 (+ (fix vr) 1)) 0) coordsecs)
			  	           (nth (+ (* 2 (+ (fix vr) 1)) 1) coordsecs)
				     )
		)
	)
	(princ "\nParam              :") (princ vr)
	(princ "\nBulge              :") (princ bulge)
	(princ "\nNumero Vertici     :") (princ nv)
	(princ "\nCoord ini seg ECS  :") (princ iniecs)
	(princ "\nCoord fin seg ECS  :") (princ finecs)
	(princ)
	
)
;
;
;
(defun Random_Str ( Nnm / LM:rand Loop _cdate_ _mantissa_)
	;
	; procedura per il calcolo casuale di una stringa
	;
	
	(defun LM:rand ( / a c m )
		(setq m   4294967296.0
			  a   1664525.0
			  c   1013904223.0
			 $xn (rem (+ c (* a (cond ($xn) ((getvar 'date))))) m)
		)
		(/ $xn m)
	)
	
	(if (not $out_random_str$) (setq $out_random_str$ "0"))
	(setq Loop T)
	(while Loop
		(setq _cdate_    (LM:rand))
		(setq _mantissa_ (nth 1 (splitxt (LM:rtos _cdate_ 2 Nnm) ".")))
		(if (= (strlen _mantissa_) Nnm)
				(if (/=	(- (atoi _mantissa_) (atoi $out_random_str$)) 0)
					(setq Loop nil)
				)
			)
	)
	
	(setq $out_random_str$ _mantissa_)
	
	;(rtos (* (atoi out_random_str) (LM:rand)) 2 0)
)
;
;
;
(defun area01 (lista_x lista_y / sup i ii nr x_i y_i x_ii y_ii a)
;
; procedura per il calcolo dell'area di una superfice
;                                                    
	(setq sup 0
			i    0
			ii   0
			nr (length lista_x)
	)
	(repeat nr        
		(if (= (+ ii 1) nr)
			(setq ii 0)
			(setq ii (+ 1 ii))
		)                  
		(setq x_i  (nth i lista_x)
			  y_ii (nth ii lista_y) 
			  x_ii (nth ii lista_x)
			  y_i  (nth i lista_y) 
			  i (+ 1 i)
		)
     (setq a (/ (- (* x_i y_ii) (* x_ii y_i)) 2.0)
           sup (+ sup a)
     )
  )
  sup
)
;
;
;
