(defun GetEnt ()
	(car (entsel))
)
;
;
;
(defun GetObj ()
	(vlax-ename->vla-object (car (entsel)))
)
;
;
;
(defun GetLstRegapp ( / f a Rtn)
	(setq f t)
	(while (setq a (tblnext "appid" f))
		(if f (setq f nil))
		(setq Rtn (cons (cdr (assoc 2 a)) Rtn))
	)
	Rtn
)
;
; Check  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun CheckSameIdShape (/ Id Rtn LstId)
	(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape)))))
		(setq Id (cdr (nth 3  (nth 1 (assoc -3 (entget itm (list "*")))))))
		(if (assoc Id LstId)
			(setq Rtn (append Rtn (append (assoc Id LstId) (list itm))))
			(setq LstId (append LstId (list (list (cdr (nth 3  (nth 1 (assoc -3 (entget itm (list "*")))))) itm))))
		)
	)
	Rtn
)
;
;
;
(defun CheckSameIdSheet (/ Id Rtn LstId)
	(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpSheet)))))
		(setq Id (cdr (nth 3  (nth 1 (assoc -3 (entget itm (list "*")))))))
		(if (assoc Id LstId)
			(setq Rtn (append Rtn (append (assoc Id LstId) (list itm))))
			(setq LstId (append LstId (list (list (cdr (nth 3  (nth 1 (assoc -3 (entget itm (list "*")))))) itm))))
		)
	)
	Rtn
)
;
;
;
(defun CheckIfEasyCutShape (Ename / Rtn)

		(if Ename
			(if (assoc -3 (entget Ename (list "*")))
				(if (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpShape)
					(setq Rtn T)
				)
			)
		)
		Rtn
)
;
;
;
(defun CheckIfEasyCutTrigger (Ename / Rtn)

		(if Ename
			(if (assoc -3 (entget Ename (list "*")))
				(if (or (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpTiggerOn)
						(= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpTiggerOff)				
					)
					(setq Rtn T)
				)
			)
		)
		Rtn
)
;
;
;
(defun CheckIfEasyCutShapeMemeber (Ename / Rtn)

		(if Ename
			(if (assoc -3 (entget Ename (list "*")))
				(if (or (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpShape)
						(= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpTiggerOn)
						(= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpTiggerOff)				
					)
					(setq Rtn T)
				)
			)
		)
		Rtn
)
;
;
;
(defun CheckIfEasyCutSheet (Ename / Rtn)
	
		(if Ename
			(if (assoc -3 (entget Ename (list "*")))
				(if (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpSheet)
					(setq Rtn T)
				)
			)
		)
		Rtn

)
;
;
;
(defun CheckIfEasyCutSheetMember (Ename / Rtn)
	

		(if Ename
			(if (assoc -3 (entget Ename (list "*")))
				(if (or (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpSheet)
						(= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpSheetTarget)
					)
					(setq Rtn T)
				)
			)
		)
		Rtn
)
;
;
;
(defun CheckIfBlockShape (Ename / Obj Rtn)


	(if Ename
		(if (assoc -3 (entget Ename (list "*")))
			(if (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpShapeTarget)
				(if (= (vla-get-ObjectName (vlax-ename->vla-object Ename)) "AcDbBlockReference")
					(if (= (vlax-get-property (vlax-ename->vla-object Ename) (if (vlax-property-available-p (vlax-ename->vla-object Ename) 'effectivename) 'effectivename 'name)) NameBlockShape$)
						(setq Rtn T)
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
(defun CheckIfBlockLogo (Ename / Obj Rtn)

	(if Ename
		(progn
			(setq Obj (vlax-ename->vla-object Ename))
			(if (= (vla-get-ObjectName Obj) "AcDbBlockReference")
				(if (= (vlax-get-property Obj (if (vlax-property-available-p Obj 'effectivename) 'effectivename 'name)) (vl-filename-base FileBlockLogo$))
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
(defun CheckIfBlockBarCode (Ename / Obj NameBlock Rtn)

	(if Ename
		(progn
			(setq Obj (vlax-ename->vla-object Ename))
			(if (= (vla-get-ObjectName Obj) "AcDbBlockReference")
				(if (setq NameBlock (vlax-get-property Obj (if (vlax-property-available-p Obj 'effectivename) 'effectivename 'name)))
					(if (> (strlen NameBlock) 11)
						(if (= (substr NameBlock 1 11) "BARCODE128_") 
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
(defun CheckIfBlockShapeTmp (Ename / Obj Rtn)

	(if Ename
		(if (assoc -3 (entget Ename (list "*")))
			(if (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpShapeTarget)
				(if (= (vla-get-ObjectName (vlax-ename->vla-object Ename)) "AcDbBlockReference")
					(if (= (vlax-get-property (vlax-ename->vla-object Ename) (if (vlax-property-available-p (vlax-ename->vla-object Ename) 'effectivename) 'effectivename 'name)) NameBlockShapeTmp$)
						(setq Rtn T)
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
(defun CheckIfBlockSheet (Ename / Rtn)

	(if Ename
		(if (assoc -3 (entget Ename (list "*")))
			(if (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) $RgpSheetTarget)
				(setq Rtn T)
			)
		)
	)
	Rtn
)
;
;
;
(defun CheckIfPaperSpace (Ename / Rtn)

		(if Ename
			(if (= (cdr (assoc 67 (entget Ename))) 1)
				(setq Rtn T)
			)
		)
		Rtn
)
;
; Shape Query  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetSurfaceShape (LstEnameShape / itm MaxMin LstGrossSurface LstNetSurface)
	(if LstEnameShape
		(progn
			(foreach itm LstEnameShape
				(setq 	MaxMin 			(BoundingBoxLstEname (list itm))
						LstGrossSurface (append LstGrossSurface (list (* (distance (car MaxMin) (cadr MaxMin)) (distance (cadr MaxMin) (caddr MaxMin)))))
						LstNetSurface 	(append LstNetSurface   (list (vla-get-area (vlax-ename->vla-object itm))))
				)
			)
			(list 	(apply 'min	LstGrossSurface)
					(apply 'max	LstGrossSurface)
					(apply 'min	LstNetSurface)
					(apply 'max	LstNetSurface)
			))
	)
)
;
;
;
(defun GetAssocIdEnameShspe (/ itm Rtn)
	(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape)))))
		(setq Rtn (append Rtn (list (list (cdr (nth 3  (nth 1 (assoc -3 (entget itm (list "*")))))) itm))))
	)
	Rtn
)
;
;
(defun GetEnameShapeById (Id / SselShape ContaShape NotFind IdShape Rtn)

	(if Id
		(progn
			(setq SselShape (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape)))))
			(setq ContaShape 0)
			(setq NotFind T)
			(if SselShape
				(while (and NotFind (< ContaShape (sslength SselShape)))
					(setq IdShape (cdr (nth 3  (nth 1 (assoc -3 (entget (ssname SselShape ContaShape) (list "*")))))))
					(if (= Id IdShape)
						(progn
							(setq Rtn (ssname SselShape ContaShape))
							(setq NotFind nil)
						)
					)
					(setq ContaShape (1+ ContaShape))
					
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameShapeByDummyEnameSelect (EnameDummy / GrpLst itm Rtn)
	
	(if EnameDummy
		(if (setq GrpLst (Gnames EnameDummy))
			(foreach itm (Genames (nth 0 GrpLst))
				(if (= (GetTypeShape (cdr itm)) 1)
					(setq Rtn (cdr itm))
				)	
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameInternalShapeByDummyEnameSelect (EnameDummy / GrpLst LstEnameGroup itm Rtn)
	
	(if EnameDummy
		(progn
			(setq GrpLst (Gnames EnameDummy))
			(if GrpLst
				(progn
					(setq LstEnameGroup (Genames (nth 0 GrpLst)))
					(foreach itm LstEnameGroup
						(if (= (GetTypeShape (cdr itm)) 2)
							(setq Rtn (append Rtn (list (cdr itm))))
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
(defun GetEnameShapeByEnameInternalShape (EnameInternalShape / Ssel conta Rtn DataShape)


	(if EnameInternalShape
		(progn
			(setq Ssel (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape)))))
			(if Ssel
				(progn	
					(setq conta 0)
					(setq Rtn nil)
					(while (and (null Rtn) (< conta (sslength Ssel)))
					
						(setq DataShape (GetDataShape (ssname Ssel conta)))
						(if DataShape
							(if (= (nth 0 DataShape) "CE")
								(if (PoligonInsidePoligon (ssname Ssel conta) EnameInternalShape)
									(setq Rtn (ssname Ssel conta))
								)
							)
						)
						(setq conta (1+ conta))
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
(defun GetEnameShapeByEnameTrigger (EnameTrigger / CirclePoint LstEnameToSelectionSet MergeSelectionSet 
												   Fuzz P1 P2 Rtn)
	
	(defun CirclePoint (Pt Npt Radius / DivAng Num Rtn)
		(if (and Pt Radius NPt)
			(progn
				(setq DivAng (/ (* 2 Pi) Npt))
				(setq Num 0)
				(repeat Npt
					(setq Rtn (append Rtn (list (polar Pt (* DivAng Num) Radius))))
					(setq Num (1+ Num))
				)
			)
		)
		Rtn
	)
	;
	(defun LstEnameToSelectionSet (LstEname / itm Rtn)
		(if LstEname
			(progn
				(setq Rtn (ssadd))
				(foreach itm LstEname
					(ssadd itm Rtn)
				)
			)
		)
		Rtn
	)
	;
	(defun MergeSelectionSet (LstSsel / Ssel itm Rtn)
		(foreach Ssel LstSsel
			(foreach itm (LM:ss->ent Ssel)
				(setq Rtn (cons itm Rtn))
			)
		)
		(LstEnameToSelectionSet Rtn)
	)
	;
	; Main
	;
	(if EnameTrigger
		(setq 	Fuzz 0.5
				P1  (vlax-safearray->list (vlax-variant-value (vla-get-startpoint (vlax-ename->vla-object EnameTrigger))))
				P2  (vlax-safearray->list (vlax-variant-value (vla-get-endpoint   (vlax-ename->vla-object EnameTrigger))))
				Rtn (MergeSelectionSet (list (ssget "_CP" (CirclePoint P1 4 Fuzz) $FilterList)
											 (ssget "_CP" (CirclePoint P2 4 Fuzz) $FilterList)))
		)
	)
	;(vla-highlight (vlax-ename->vla-object (ssname Rtn 0)) :vlax-true)
	(if Rtn 
			(if (or	(/= (car (gnames (ssname Rtn 0))) (car (gnames EnameTrigger)))
					(/= (GetIdShape (ssname Rtn 0))   (GetIdTrigger EnameTrigger)))
				nil
				(ssname Rtn 0)
			)
	)
)
;
;
;
(defun GetEnameShapeByEnameBlockShape (EnameBlockShape / IdShape SselShape Num Loop Rtn)

	(if (CheckIfBlockShape EnameBlockShape)
		(progn
			(setq IdShape	(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "IDSHAPE"))
			(setq SselShape	(ssget "_X" (list (cons 67 0) (cons 0  "LWPOLYLINE") (list -3 (list $RgpShape)))))
			(setq Num 0)
			(setq Loop T)
			(if (and IdShape SselShape)
				(while Loop
					(if (= (GetIdShape (ssname SselShape Num)) IdShape)
						(progn
							(setq Rtn (ssname SselShape Num))
							(vla-highlight (vlax-ename->vla-object Rtn) :vlax-true)
							(setq Loop nil)
						)
					)
					(setq Num (1+ Num))
					(if (= Num (sslength SselShape))
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
(defun GetLstIdAndEnameShape (/ SselShape Num Rtn)

	(setq Num 0)
	(if (setq SselShape	(ssget "_X" (list (cons 67 0) (cons 0  "LWPOLYLINE") (list -3 (list $RgpShape)))))
		(repeat (sslength SselShape)
			(setq Rtn (append Rtn (list (list (GetIdShape (ssname SselShape Num)) (ssname SselShape Num)))))
			(setq num (1+ Num))
		)
	)
	Rtn
)
;
;
;
(defun GetDataShape (EnameShape / Rtn TypShape IdShape JouShape NameShape CutComp ComShape 
								  PhaseShape MatShape TkShape DateShape SlTime ExTime InTime TgTime TotTime Timing Quantita)
		
		(if EnameShape
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (and (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
						 (= (length (nth 1 (assoc -3 (entget EnameShape (list "*"))))) 14))
						(progn
							(setq 	TypShape    (cdr (nth 2  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["CE"] ["CI"]
									IdShape     (cdr (nth 3  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["123456789"]
									JouShape    (cdr (nth 4  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["0"]["2"]["3"]
									NameShape   (cdr (nth 5  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["PIPPO"]
									CutComp     (cdr (nth 6  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["0"]["1"]["2"]["3"]
									ComShape    (cdr (nth 7  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["C2018032"]
									PhaseShape  (cdr (nth 8  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["P100"]
									MatShape    (cdr (nth 9  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["S355J0"]
									TkShape     (cdr (nth 10 (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["10"]
									DateShape   (cdr (nth 11 (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["10/11/2018"]
									Timing		(GetTimingCutOnlyShape EnameShape)
									Quantita    (cdr (nth 12 (nth 1 (assoc -3 (entget EnameShape (list "*"))))))  ;	["100"]
							)
							(cond
								((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
									(setq LenghtCut (vla-get-Circumference (vlax-ename->vla-object EnameShape)))
								)
								((= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE")
									(setq LenghtCut (vlax-curve-getDistAtParam (vlax-ename->vla-object EnameShape)
													(vlax-curve-getendparam (vlax-ename->vla-object EnameShape))))
								)
								(t
									(setq LenghtCut (vla-get-length (vlax-ename->vla-object EnameShape)))
								)
							)
							
							(setq 	SlTime  (nth 0 Timing)
									ExTime  (nth 1 Timing)
									InTime  (nth 2 Timing)
									TgTime  (nth 3 Timing)
									TotTime (+ ExTime InTime TgTime)
							)
							(setq   minuti  (fix SlTime)
									secondi (* (- SlTime minuti) 60.0)
									SlTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
							
									minuti  (fix ExTime)
									secondi (* (- ExTime minuti) 60.0)
									ExTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
									
									minuti  (fix InTime)
									secondi (* (- InTime minuti) 60.0)
									InTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")

									minuti  (fix TgTime)
									secondi (* (- TgTime minuti) 60.0)
									TgTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
									
									minuti  (fix TotTime)
									secondi (* (- TotTime minuti) 60.0)
									TotTime (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
									
									;Rtn (list TypShape IdShape JouShape NameShape CutComp LenghtCut (SeTime ExTime InTime TotTime) ComShape PhaseShape MatShape TkShape DateShape)
									Rtn (list TypShape
											  IdShape
											  JouShape
											  NameShape
											  CutComp
											  (rtos LenghtCut 2 2)
											  (list SlTime ExTime InTime TgTime TotTime)
											  ComShape
											  PhaseShape
											  MatShape
											  TkShape
											  DateShape
											  Quantita
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
(defun GetDimensionShape (EnameDummyShape / EnamShape Width Height Rtn)

	(setq Rtn (list (list 0.0 0.0) (list 0.0 0.0)))
	(if EnameDummyShape
		(progn
			(setq EnamShape EnameDummyShape)
				(vla-getboundingbox (vlax-ename->vla-object EnamShape) 'mnl 'mxl)
				(setq Width   (abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
				(setq Height  (abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
				(setq Rtn (list Width Height))
			
			
			(setq EnamShape (GetEnameShapeByDummyEnameSelect EnameDummyShape))
				(vla-getboundingbox (vlax-ename->vla-object EnamShape) 'mnl 'mxl)
				(setq Width   (abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
				(setq Height  (abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
				(setq Rtn (list Rtn (list Width Height)))
		)
	)
	Rtn
)
;
;
;
(defun GetDimensionDummy (EnameDummyShape / EnamShape Width Height Rtn)

	(if EnameDummyShape
		(progn
			(vla-getboundingbox (vlax-ename->vla-object EnameDummyShape) 'mnl 'mxl)
			(setq Width   (abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
			(setq Height  (abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
			(setq Rtn (list Width Height))
		)	
	)
	Rtn
)
;
;
;
(defun GetOriginShape (EnameDummyShape / Rtn)
		(if EnameDummyShape
			(progn
				(setq EnamShape (GetEnameShapeByDummyEnameSelect EnameDummyShape))
				(vla-getboundingbox (vlax-ename->vla-object EnamShape) 'mnl 'mxl)
				(setq Rtn (vlax-safearray->list mnl))
			)
		)
		Rtn
)
;
;
;
(defun GetTypeShape (EnameDummy / TypEnt Flag)

	;ritorna :	-1 errore
	;			0  non è un contorno trattato
	;			1  è un controno esterno
	;			2  è un contorno interno
	;			3  è un attacco entra
	;			4  è un attacco esci
	
	(setq Flag -1)
	(if EnameDummy	
		(progn
			(if (assoc -3 (entget EnameDummy (list "*")))
				(progn
					(setq TypEnt (nth 0 (nth 1 (assoc -3 (entget EnameDummy (list "*"))))))
					(setq Flag 0)
					(cond
						;((= TypEnt "PIATTO")
						((= TypEnt $RgpShape)
							(if (= (cdr (nth 2 (nth 1 (assoc -3 (entget EnameDummy (list "*")))))) "CE") (setq Flag 1))
							(if (= (cdr (nth 2 (nth 1 (assoc -3 (entget EnameDummy (list "*")))))) "CI") (setq Flag 2))
						)
						((= TypEnt $RgpTiggerOn)
							(setq Flag 3)
						)
						((= TypEnt $RgpTiggerOff)
							(setq Flag 4)
						)
						(t
							(setq Flag 0)
						)
					)
				)
			)
		)
	)
	Flag
)
;
;
;
(defun GetEnameShapeByEnameSheet (EnameSheet FilterShape / Shape CheckZoom itm LstOut)

	; FilterShape = "CE+CI" External/Internal Shape
	;				"CE" External Shape
	;				"CI" Internal Shape
	;				"TR" Trigger
	;				"CE+CI+TR"
	;				"FILTERSETUP"
	

	(if EnameSheet
		(progn
			(setq CheckZoom (VisibleEname EnameSheet))
			;(setq Shape 	(DiscretizeShape EnameSheet))
			(setq Shape 	(DiscretizeShapeNoControl EnameSheet))
			
			(cond 
				((= FilterShape "CE")
					(foreach itm (LM:ss->ent (ssget "_CP" Shape (list (cons 0 "LWPOLYLINE") (list -3 (list $RgpShape)))))
						(if (= (GetTypeShape itm) 1)
							(setq LstOut (append LstOut (list itm)))
						)
					)
				)
				((= FilterShape "CI")
					(foreach itm (LM:ss->ent (ssget "_CP" Shape (list (cons 0 "LWPOLYLINE") (list -3 (list $RgpShape)))))
						(if (= (GetTypeShape itm) 2)
							(setq LstOut (append LstOut (list itm)))
						)
					)
				)
				((= FilterShape "TR")
					(setq LstOut (LM:ss->ent (ssget "_CP" Shape (list (list -3 (list (strcat $RgpTiggerOn "," $RgpTiggerOff)))))))
				)
				((= FilterShape "CE+CI")
					(setq LstOut (LM:ss->ent (ssget "_CP" Shape (list (list -3 (list $RgpShape))))))
				)
				((= FilterShape "CE+CI+TR")
					(setq LstOut (LM:ss->ent (ssget "_CP" Shape (list (list -3 (list (strcat $RgpShape "," $RgpTiggerOn "," $RgpTiggerOff)))))))
				)
				((= FilterShape "FILTERSETUP")
					(setq LstOut (LM:ss->ent (SsgetWithFilterSetup "_CP" Shape (GetDataSelectWithFilterSetup))))
				)
			)
			(ZoomPrevius CheckZoom)
		)
	)
	LstOut
)
;
;
;
(defun GetShapeByGroup (Group / LstEname itm LstOut)


	(if Group
		(progn
			(setq LstEname (genames Group))
			(foreach itm LstEname
				(if (= (nth 0 (nth 1 (assoc -3 (entget (cdr itm) (list "*"))))) $RgpShape)
					(setq LstOut (append LstOut (list (cdr itm))))
				)
			)
			(setq LstOut (SortArea LstOut 1))
		)
	)
	LstOut
)
;
;
;
(defun GetLstExternalShape (/ itm Rtn)

	(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 0 "LWPOLYLINE") (list -3 (list $RgpShape)))))
		(if (= (GetTypShape itm) "CE")
			(setq Rtn(append Rtn (list itm)))
		)
	)
	Rtn
)
;
;
;
(defun GetListEnameShapeTable (/ itm LstIdShape Rtn)
	
	(foreach itm (GetLstBlockBomShapeByRgp $RgpShapeTarget NameBlockShape$)
		(setq LstIdShape (append LstIdShape (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "IDSHAPE"))))
	)
	(foreach itm (GetLstExternalShape)
		(if (member (GetIdShape itm) LstIdShape)
			(setq Rtn (append Rtn (list itm)))
		)
	)
	Rtn
)
;
;
;
(defun GetEnameShapeByFence (SselDummy DistFence / FilterEname minmax Pmid LstTmp itm itm1 _Min _Max Ssel LstCheck Rtn)

	(defun FilterEname (Ssel SselDummy / LstSsel LstChk itm itm1 ObjOffset Shape LstEname Chk LstIn LstOut)
		
	
		(setq LstSsel (LM:ss->ent Ssel))
		(setq LstChk  (LM:ss->ent SselDummy))
		
		(if LstSsel
			(foreach itm LstSsel
				(if (= (GetTypeShape itm) 1)
					(progn
						(setq ObjOffset (nth 0 (vlax-safearray->list 
													(vlax-variant-value 
														(vla-Offset (vlax-ename->vla-object itm) $ArrowArcDivision)))))
						(if (< (vla-get-area ObjOffset) (vla-get-area (vlax-ename->vla-object itm)))
							(progn
								(vla-Delete ObjOffset)
								(setq ObjOffset (nth 0 (vlax-safearray->list 
															(vlax-variant-value 
																(vla-Offset (vlax-ename->vla-object itm) (* $ArrowArcDivision -1.0))))))
							)	
						)
						(ZoomEname (vlax-vla-object->ename ObjOffset) 100.0)
						
							;(setq Shape (DiscretizeShape (vlax-vla-object->ename ObjOffset)))
							(setq Shape (DiscretizeShapeNoControl (vlax-vla-object->ename ObjOffset)))
							(vla-Delete ObjOffset)

							(if (setq LstEname (LM:ss->ent (ssget "_WP" Shape)))
								(foreach itm1 LstChk
									(if (member itm1 LstEname)
										(progn
											(if (assoc itm LstIn)
												(setq LstIn (subst (append (assoc itm LstIn) (list itm1))
																 (assoc itm LstIn)
																  LstIn))
												(setq LstIn (append LstIn (list (list itm itm1))))
											)
											(setq LstChk (LM:RemoveOnce itm1 LstChk))
										)
									)
								)
							)
							
						(ZoomPrevius01)
					)
				)
			)
		)
		
		(if LstChk
			(setq LstOut LstChk)
		)
		
		(list LstIn LstOut)
	)
	;
	; Main +++++ 
	;
	(if (and SselDummy DistFence)
		(progn
			(setq MinMax (LM:SSBoundingBox SselDummy))
			(setq Pmid 	(list 	(/ (+ (nth 0 (nth 0 MinMax)) (nth 0 (nth 2 MinMax))) 2.0)
								(/ (+ (nth 1 (nth 0 MinMax)) (nth 1 (nth 2 MinMax))) 2.0)
						))
			(ZoomWindow01 	(list (- (car (nth 0 MinMax)) 1.0)           (- (cadr (nth 0 MinMax)) 1.0))
							(list (+ (car (nth 2 MinMax)) DistFence 1.0) (+ (cadr (nth 2 MinMax)) DistFence 1.0)))
							
					(foreach itm (LM:ss->ent SselDummy)
							(vla-getboundingbox (vlax-ename->vla-object itm) '_Min '_Max)
							(setq Pmid   	(list (/ (+ (nth 0 (vlax-safearray->list _Min)) (nth 0 (vlax-safearray->list _Max))) 2.0)
												  (/ (+ (nth 1 (vlax-safearray->list _Min)) (nth 1 (vlax-safearray->list _Max))) 2.0)
											))

							(setq LstTmp nil)
							(foreach itm1 (LM:ss->ent (ssget "_F" (list Pmid (list (+ (car Pmid) DistFence) (cadr Pmid)))
																  (list (cons 0 "LwPolyline") (list -3 (list $RgpShape)))))
								(if (= (GetTypeShape itm1) 1)
									(setq LstTmp (append LstTmp (list itm1)))
								)
							)

											
							;(if Ssel (setq LstCheck (cons (ssname Ssel 0) LstCheck)))
							(if LstTmp (setq LstCheck (cons (car LstTmp) LstCheck)))
					)
			(ZoomPrevius01)
			(setq Rtn (FilterEname (LstEname->Ssget LstCheck) SselDummy))
		)
	)
	Rtn
)
;
; Fast Shape Query  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetTypShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 2  (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["CE"] ["CI"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetIdShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 3  (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["123456789"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetJouShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 4  (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["0"]["2"]["3"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetNameShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 5  (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["PIPPO"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetCutShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 6  (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["0"]["1"]["2"]["3"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetComShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 7  (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["C2018032"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetPhaseShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 8  (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["P100"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetMatShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 9  (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["S355J0"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetTkShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 10 (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["10"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetDateShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 11 (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["10/11/2018"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetTimingShape (EnameShape / Timing SlTime ExTime InTime TgTime TgSTime TotTime minuti secondi Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(progn
						(setq 	Timing   (GetTimingCutOnlyShape EnameShape))
						(setq 	SlTime   (nth 0 Timing)
								ExTime   (nth 1 Timing)
								InTime   (nth 2 Timing)
								TgTime   (nth 3 Timing)
								TgSTime  (nth 4 Timing)
								TotTime  (+ ExTime InTime TgTime)
						)
						(setq   minuti  (fix SlTime)
								secondi (* (- SlTime minuti) 60.0)
								SlTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
							
								minuti  (fix ExTime)
								secondi (* (- ExTime minuti) 60.0)
								ExTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
									
								minuti  (fix InTime)
								secondi (* (- InTime minuti) 60.0)
								InTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")

								minuti  (fix TgTime)
								secondi (* (- TgTime minuti) 60.0)
								TgTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")

								minuti  (fix TgSTime)
								secondi (* (- TgSTime minuti) 60.0)
								TgSTime  (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
								
								minuti  (fix TotTime)
								secondi (* (- TotTime minuti) 60.0)
								TotTime (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
									
							    Rtn (list SlTime ExTime InTime TgTime TgSTime TotTime)
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
(defun GetQtaShape (EnameShape / Rtn)
	(if EnameShape
		(progn
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					(setq Rtn (cdr (nth 12 (nth 1 (assoc -3 (entget EnameShape (list "*")))))))  ;	["100"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetTimingCutOnlyShape (EnameDummyShape / SpeedCut LstLength Rtn)
	
		(setq Rtn (list 0.0 0.0 0.0 0.0))
		(if EnameDummyShape
			(progn
				(setq SpeedCut    (GetSpeedCut    EnameDummyShape))
				(setq LstLength   (GetLengthShape EnameDummyShape))
				(setq Rtn (list	(/ (nth 0 LstLength) SpeedCut) ; Select Ename
								(/ (nth 1 LstLength) SpeedCut) ; External Shape
								(/ (nth 2 LstLength) SpeedCut) ; Internal Shape
								(/ (nth 3 LstLength) SpeedCut) ; Total Trigger Shape
								(/ (nth 4 LstLength) SpeedCut) ; Select Trigger Shape
						  )
				)
			)
		)
		Rtn
)
;
;
;
(defun GetTimingCut (EnameShape / Rtn SpeedCut LstEname TotalPerimeter Perimeter TotalLengthTrigger LengthTrigger Timing minuti secondi itm)

	(if EnameShape
		(progn
			(setq Rtn (list 0.0 0.0))
			(setq SpeedCut (GetSpeedCut EnameShape))
			(setq LstEname (GetExpertEnameShape&Trigger EnameShape 6))
			(setq TotalPerimeter 0.0)
			(setq TotalLengthTrigger 0.0)
			(setq LengthTrigger 0.0)
			
			(foreach itm (nth 0 LstEname)
				(setq Perimeter (GetLengthEname itm))
				(setq TotalPerimeter (+ TotalPerimeter Perimeter))
			)
			
			(foreach itm (nth 1 LstEname)
				
				(if (not (null (nth 0 itm)))
					(setq LengthTrigger (GetLengthEname (nth 0 itm)))
				)
				(if (not (null (nth 1 itm)))
					(setq LengthTrigger (GetLengthEname (nth 1 itm)))
				)
				
				(setq TotalLengthTrigger (+ TotalLengthTrigger LengthTrigger))
			)
			(setq Rtn (+ (/ TotalPerimeter SpeedCut) (/ TotalLengthTrigger SpeedCut)))
		)
	)
	Rtn
)
;
;
;
(defun GetLengthShape (EnameDummyShape / PerimeterSelectShape PerimeterExternalShape PerimeterTrigger TotPerimeter
                                         PerimeterInternalShape PerimeterTriggerSelect LstEnameShape EnameTrigger EnameShape itm)

	(setq PerimeterSelectShape   0.0)
	(setq PerimeterExternalShape 0.0)
	(setq PerimeterInternalShape 0.0)
	(setq PerimeterTrigger       0.0)
	(setq PerimeterTriggerSelect 0.0)
	
	
	(if EnameDummyShape
		(progn
			
			(setq PerimeterSelectShape   	(GetLengthEname EnameDummyShape))
			(setq EnameShape 				(GetEnameShapeByDummyEnameSelect EnameDummyShape))
			(setq PerimeterExternalShape   	(GetLengthEname EnameShape))
			
			(setq LstEnameShape (GetEnameInternalShapeByDummyEnameSelect EnameDummyShape))
			(foreach itm LstEnameShape
				(setq PerimeterInternalShape (+ PerimeterInternalShape (GetLengthEname itm)))
			)
			
			(setq EnameTrigger (GetEnameTriggerByDummyEnameSelect EnameDummyShape))
			(foreach itm EnameTrigger
				(setq PerimeterTrigger (+ PerimeterTrigger (GetLengthEname itm)))
			)
			
			(setq EnameTrigger (GetEnameTriggerByEnameShape EnameDummyShape))
			(if (setq itm (nth 0 EnameTrigger)) (setq PerimeterTriggerSelect (+ PerimeterTriggerSelect (GetLengthEname itm))))
			(if (setq itm (nth 1 EnameTrigger)) (setq PerimeterTriggerSelect (+ PerimeterTriggerSelect (GetLengthEname itm))))
			
			(setq TotPerimeter (+ PerimeterExternalShape PerimeterInternalShape PerimeterTrigger))
		)
	)
	(list PerimeterSelectShape PerimeterExternalShape PerimeterInternalShape PerimeterTrigger PerimeterTriggerSelect TotPerimeter)
)
;
;
;
(defun GetAreaShape (EnameDummyShape / AreaSelect AreaExternalShape AreaInternalShape EnameShape LstEnameShape itm)

	(setq AreaExternalShape 0.0)
	(setq AreaInternalShape 0.0)
	
	(if EnameDummyShape
		(progn
			(setq AreaSelect 		 (vla-get-Area (vlax-ename->vla-object EnameDummyShape)))
			(setq EnameShape 	     (GetEnameShapeByDummyEnameSelect EnameDummyShape))
			(setq AreaExternalShape  (vla-get-Area (vlax-ename->vla-object EnameShape)))
			
			(setq LstEnameShape      (GetEnameInternalShapeByDummyEnameSelect EnameDummyShape))
			(foreach itm LstEnameShape
				(setq AreaInternalShape (+ AreaInternalShape (vla-get-Area (vlax-ename->vla-object itm))))
			)
		)
	)
	(list AreaSelect AreaExternalShape AreaInternalShape)
)
;
;
;
(defun GetWeightShape (EnameDummyShape / SelectWeight GrossWeight NetWeight Area Thik)

	(setq SelectWeight 0.0)
	(setq GrossWeight  0.0)
	(setq NetWeight    0.0)
	
	(if EnameDummyShape
		(progn
			(setq Area (GetAreaShape EnameDummyShape))
			(setq Thik (atof (GetTkShape EnameDummyShape)))
			
			(setq SelectWeight (* (/ (car Area)  1000000.0) Thik 7.85))
			(setq GrossWeight  (* (/ (cadr Area)  1000000.0) Thik 7.85))
			(setq NetWeight    (* (/ (caddr Area) 1000000.0) Thik 7.85))
		)
	)
	(list SelectWeight GrossWeight NetWeight)
)
;
; Trigger Query  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetEnameTriggerByEnameShape (EnameShape / IdShape GrpLst LstEnameGroup itm Rtn Entra Esci)

	(if EnameShape
		(progn
			(setq IdShape (GetIdShape EnameShape))
			(setq GrpLst (Gnames EnameShape))
			(if GrpLst
				(progn
					(setq LstEnameGroup (Genames (nth 0 GrpLst)))
					(foreach itm LstEnameGroup
						(setq itm (cdr itm))
						
						
						
						(if (and (not (equal itm EnameShape)) 
								 (= IdShape (GetIdTrigger itm))
						         (= (GetTypeShape itm) 3)
							)
							(setq Entra itm)
						)
						(if (and (not (equal itm EnameShape)) 
								 (= IdShape (GetIdTrigger itm))
							     (= (GetTypeShape itm) 4)
							)
							(setq Esci itm)
						)
						
					)
					(setq Rtn (list Entra Esci))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameTriggerByDummyEnameSelect (EnameDummy / GrpLst LstEnameGroup itm Rtn)
	
	(if EnameDummy
		(progn
			(setq GrpLst (Gnames EnameDummy))
			(if GrpLst
				(progn
					(setq LstEnameGroup (Genames (nth 0 GrpLst)))
					(foreach itm LstEnameGroup
						(if (or (= (GetTypeShape (cdr itm)) 3)
							    (= (GetTypeShape (cdr itm)) 4)
							)
							(setq Rtn (append Rtn (list (cdr itm))))
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
(defun GetIdTrigger (EnameTrigger / Rtn)

		(if EnameTrigger
			(if (assoc -3 (entget EnameTrigger (list "*")))
				(progn
					
					(if (= (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))) $RgpTiggerOn)
						(setq Rtn (cdr (nth 2 (nth 1 (assoc -3 (entget EnameTrigger (list "*")))))))
					)
					(if (= (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))) $RgpTiggerOff)
						(setq Rtn (cdr (nth 2 (nth 1 (assoc -3 (entget EnameTrigger (list "*")))))))
					)
				)
			)
		)
		Rtn
)	
;
;
;
(defun GetDataTrigger (EnameTrigger / IdTrigger Segno TypeP)
		(if EnameTrigger
			(if (assoc -3 (entget EnameTrigger (list "*")))
				(progn
					;(if (= (nth 0 (nth 1 (assoc -3(entget EnameTrigger (list "*"))))) "PIATTO")
					(if (or (= (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))) $RgpTiggerOn)
							(= (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))) $RgpTiggerOff)
						)
						(setq IdTrigger (cdr (nth 2 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))))
								Segno   (cdr (nth 3 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))))
								TypeP        (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*")))))
						)
					)
				)
			)
		)
		(list IdTrigger Segno TypeP)
)
;
;
;
(defun GetEnameTriggerByIdShape (IdShape / Ssel conta LstOut Rtn)

		(if IdShape
			(progn
			
				(setq EnameTriggerOn 	(cdr (assoc Id $ListIdTriggerOn)))
				(setq EnameTriggerOff 	(cdr (assoc Id $ListIdTriggerOff)))
				(setq Rtn (list EnameTriggerOn EnameTriggerOf))
				
				(if (or (null EnameTriggerOn) (null EnameTriggerOff))
					(progn
						(setq Ssel (ssget "_X" (list (cons 67 0) (list -3 (list (strcat $RgpTiggerOn "," (strcat $RgpTiggerOff)))))))
						(if Ssel	
							(progn
								(setq conta 0)
								(setq LstOut nil)
						
								(repeat (sslength Ssel)
									(setq DataTrigger (GetDataTrigger (ssname Ssel conta)))
									(if (= (nth 0 DataTrigger) IdShape)
										(setq LstOut (append LstOut (list (list (nth 2 DataTrigger) (ssname Ssel conta)))))
									)
									(setq conta (1+ conta))
								)
						
								(cond
						
									((> (length LstOut) 2)
										(setq Rtn -1)
									)
								
									((= (length LstOut) 2)
										(if (= (nth 0 (nth 0 LstOut)) "ENTRA")
											(setq Rtn (list (nth 1 (nth 0 LstOut)) (nth 1 (nth 1 LstOut))))
											(setq Rtn (list (nth 1 (nth 1 LstOut)) (nth 1 (nth 0 LstOut))))
										)	
									)
									((= (length LstOut) 1)
										(if (= (nth 0 (nth 0 LstOut)) "ENTRA")
											(setq Rtn (list (nth 1 (nth 0 LstOut)) nil))
											(setq Rtn (list nil (nth 1 (nth 0 LstOut))))
										)	
									)
									((= (length LstOut) 0)
										(setq Rtn (list nil nil))
									)
								)
							)
							(setq Rtn (list nil nil))
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
(defun GetListEnameTriggerByIdGroup (IdGroup / itm Rtn)

	(if IdGroup
		(foreach itm (Genames IdGroup)
			(if (or (= (GetTypeShape (cdr itm)) 3)
					(= (GetTypeShape (cdr itm)) 4)
				)
				(setq Rtn (append Rtn (list (cdr itm))))
			)	
		)
	)
	Rtn
)
;
;
;
(defun GetCommonPointTrigger (EnameTriggerIn EnameTriggerOut / P1 P2 P3 P4 itm Accuracy Rtn)

	(setq Accuracy 0.01)
	(if (and EnameTriggerIn EnameTriggerOut)
		(progn
			(setq P1 (vlax-get (vlax-ename->vla-object EnameTriggerIn)  'Startpoint))
			(setq P2 (vlax-get (vlax-ename->vla-object EnameTriggerIn)  'Endpoint))
			(setq P3 (vlax-get (vlax-ename->vla-object EnameTriggerOut) 'Startpoint))
			(setq P4 (vlax-get (vlax-ename->vla-object EnameTriggerOut) 'Endpoint))
			
			(foreach itm (CombineList (list P1 P2 P3 P4) 2)
				(if (equal (car itm) (cadr itm) Accuracy)
					(setq Rtn (append Rtn (car itm)))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetContactPointTriggerOnShape (EnameShape EnameTriggerIn EnameTriggerOut / P1 P2 PContact1 PContact2 Accuracy Rtn)
 

	(setq Accuracy 0.01)
	
	(if (and EnameShape EnameTriggerIn EnameTriggerOut)
		(progn
			(setq P1 (vlax-get (vlax-ename->vla-object EnameTriggerIn)  'Startpoint))
			(setq P2 (vlax-get (vlax-ename->vla-object EnameTriggerIn)  'Endpoint))
			(cond 
				((<= (distance (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape)  P1) P1) Accuracy)
					(setq PContact1 (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape) P1))
				)
				((<= (distance (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape)  P2) P2) Accuracy)
					(setq PContact1 (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape) P2))
				)
				(t
					(setq PContact1 nil)
				)
			)
			(setq P1 (vlax-get (vlax-ename->vla-object EnameTriggerOut)  'Startpoint))
			(setq P2 (vlax-get (vlax-ename->vla-object EnameTriggerOut)  'Endpoint))
			(cond 
				((<= (distance (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape) P1) P1) Accuracy)
					(setq PContact2 (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape) P1))
				)
				((<= (distance (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape) P2) P2) Accuracy)
					(setq PContact2 (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape) P2))
				)
				(t
					(setq PContact2 nil)
				)
			)
			(cond 
				((and PContact1 PContact2)
					(setq Rtn (list PContact1 PContact2))
				)
				(PContact1
					(setq Rtn (list PContact1 nil))
				)
				(PContact2
					(setq Rtn (list nil PContact2))
				)
				(t 
					(setq Rtn (list nil nil))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetContactPointAndShapeByTrigger (EnameTrigger1 EnameTrigger2 / EqualList
																	   P1 P2 P3 P4 Ssel1 Ssel2 Ssel3 Ssel4 Aperture)
 

	(defun EqualList ( l1 l2 )
		(if (and l1 l2)
			(equal (vl-sort l1 '<) (vl-sort l2 '<))
		)
	)

	(setq Aperture 0.1)
	(if (and EnameTrigger1 EnameTrigger2)
		(progn
			(setq P1 (vlax-get (vlax-ename->vla-object EnameTrigger1) 'Startpoint))
			(setq P2 (vlax-get (vlax-ename->vla-object EnameTrigger1) 'Endpoint))
			(setq P3 (vlax-get (vlax-ename->vla-object EnameTrigger2) 'Startpoint))
			(setq P4 (vlax-get (vlax-ename->vla-object EnameTrigger2) 'Endpoint))
			(setq Ssel1 (ssget "_C" (list (- (car P1) Aperture) (- (cadr P1) Aperture)) (list (+ (car P1) Aperture) (+ (cadr P1) Aperture)) (list (list -3 (list $RgpShape)))))
			(setq Ssel2 (ssget "_C" (list (- (car P2) Aperture) (- (cadr P2) Aperture)) (list (+ (car P2) Aperture) (+ (cadr P2) Aperture)) (list (list -3 (list $RgpShape)))))
			(setq Ssel3 (ssget "_C" (list (- (car P3) Aperture) (- (cadr P3) Aperture)) (list (+ (car P3) Aperture) (+ (cadr P3) Aperture)) (list (list -3 (list $RgpShape)))))
			(setq Ssel4 (ssget "_C" (list (- (car P4) Aperture) (- (cadr P4) Aperture)) (list (+ (car P4) Aperture) (+ (cadr P4) Aperture)) (list (list -3 (list $RgpShape)))))
			(cond 
				((EqualList (LM:ss->ent Ssel1) (LM:ss->ent Ssel3))
					(list P1 P3 (LM:ss->ent Ssel1))
				)
				((EqualList (LM:ss->ent Ssel1) (LM:ss->ent Ssel4))
					(list P1 P4 (LM:ss->ent Ssel1))
				)
				((EqualList (LM:ss->ent Ssel2) (LM:ss->ent Ssel3))
					(list P2 P3 (LM:ss->ent Ssel2))
				)
				((EqualList (LM:ss->ent Ssel2) (LM:ss->ent Ssel4))
					(list P2 P4 (LM:ss->ent Ssel2))
				)
			)
		)
	)
)
;
;
;
(defun GetContactEnameTriggerByDummyShape (DummyShape / Fuzz AcuracyContact
														CheckZoom MinMax itm Pstart Pend PstartNear PendNear Rtn)
	(setq Fuzz 1.0)
	(setq AcuracyContact 1.0)
	(if DummyShape
		(progn
			(setq CheckZoom (VisibleEname DummyShape))
				(setq MinMax (BoundingBoxLstEname (list DummyShape)))
				
				(foreach itm (LM:ss->ent (setq Ssel (ssget "_C" (list (- (car  (car MinMax))   Fuzz)
																	  (- (cadr (car MinMax))   Fuzz)) 
																(list (+ (car  (caddr MinMax)) Fuzz)
																	  (+ (cadr (caddr MinMax)) Fuzz))
																(list (list -3 (list (strcat $RgpTiggerOn "," (strcat $RgpTiggerOff))))))))

					(setq Pstart     (vlax-get (vlax-ename->vla-object itm) 'StartPoint))
					(setq Pend       (vlax-get (vlax-ename->vla-object itm) 'EndPoint))
					(setq PstartNear (vlax-curve-getclosestpointto DummyShape Pstart t))
					(setq PendNear   (vlax-curve-getclosestpointto DummyShape Pend t))
					
					(if (equal PstartNear Pstart AcuracyContact)
						(progn
							(setq Pstart PstartNear)
							(setq Rtn (cons itm Rtn))
						)
					)
					(if (equal PendNear Pend AcuracyContact)
						(progn
							(setq Pend PendNear)
							(setq Rtn (cons itm Rtn))
						)
					)
					(ChangePointOfContactTrigger itm Pstart Pend)
				)
			(ZoomPrevius CheckZoom)
		)
	)
	Rtn
)
;
; Shape & Trigger Query  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetExpertEnameShape&Trigger (EnameShape TypeInfo / EShape IdShape LstEnameTrigger LstShape itm Rtn)

	;
	;	1	Only External Shape			
	;	2	Only External Shape + Trigger	
	;	3	Only InternalShape
	;	4	Only InternalShape + Trigger +++++
	;	5	Total Shape
	;	6	Total Shape + Trigger +++++
	;	7	Only select Shape
	;	8	Only select Shape + Trigger
	;
	(if (and EnameShape TypeInfo (CheckIfEasyCutShapeMemeber EnameShape))
		(progn
			(cond
				((= TypeInfo 1) 														; Only External Shape
					(setq Rtn (GetEnameShapeByDummyEnameSelect EnameShape))
				)
				((= TypeInfo 2) 														; Only External Shape + Trigger
					(setq EShape 	 		(GetEnameShapeByDummyEnameSelect EnameShape))
					(setq LstEnameTrigger 	(GetEnameTriggerByEnameShape EnameShape))
					(setq Rtn (list EShape LstEnameTrigger))
					
				)
				((= TypeInfo 3) 														; Only InternalShape
					(setq Rtn (GetEnameInternalShapeByDummyEnameSelect EnameShape))
				)
				((= TypeInfo 4) 														; Only InternalShape + Trigger
					(setq LstShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
					(setq LstEnameTrigger nil)
					(foreach itm LstShape
						(setq LstEnameTrigger 	(append LstEnameTrigger (list (GetEnameTriggerByEnameShape itm))))
					
					)
					(setq Rtn (list LstShape LstEnameTrigger))
				)
				((= TypeInfo 5) 														; Total Shape
					(setq EShape 	(GetEnameShapeByDummyEnameSelect EnameShape))
					(setq LstShape 	(GetEnameInternalShapeByDummyEnameSelect EnameShape))
					(if LstShape
						(setq Rtn (cons EShape LstShape))
						(setq Rtn (list EShape))
					)
				)
				((= TypeInfo 6) 														; Total Shape + Trigger
					(setq EShape 	(GetEnameShapeByDummyEnameSelect EnameShape))
					(setq LstShape 	(GetEnameInternalShapeByDummyEnameSelect EnameShape))
					(if LstShape
						(setq Rtn (cons EShape LstShape))
						(setq Rtn (list EShape))
					)
					(setq LstEnameTrigger nil)
					(foreach itm Rtn
						(setq LstEnameTrigger 	(append LstEnameTrigger (list (GetEnameTriggerByEnameShape itm))))
					)
					(setq Rtn (list Rtn LstEnameTrigger))
				)
				((= TypeInfo 7) 														; Only select Shape
					(setq Rtn EnameShape)
				)
				((= TypeInfo 8) 														; Only select Shape + Trigger
					(setq LstEnameTrigger 	(GetEnameTriggerByEnameShape EnameShape))
					(setq Rtn (list EnameShape LstEnameTrigger))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameShape&TriggerByContour (EnameShape / Radius Density DensityPoint CheckZoom Ssel LstEnameChecked itm LstArea Rtn1 Rtn2)

	;
	;
	;
	;(setq MSecStart (getvar "MILLISECS"))
	(if EnameShape
		(progn
			(setq DensityPoint 50)
			
			(cond 
				((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
					(setq Radius (cdr (assoc 40 (entget EnameShape))))
					(setq Density (fix (/ (* 2.0 pi) (* (acos (/ (- Radius $ArrowArcDivision) Radius)) 2.0))))
					(if (> Density $ArrowArcDivision) (setq DensityPoint Density))
				)
				((setq Data (IsLwPolylineCircle EnameShape))
					(setq Radius (cadr Data))
					(setq Density (fix (/ (* 2.0 pi) (* (acos (/ (- Radius $ArrowArcDivision) Radius)) 2.0))))
					(if (> Density $ArrowArcDivision) (setq DensityPoint Density))
				)
			)
			
			
			(setq CheckZoom (VisibleEname EnameShape))
				(setq Ssel  (ssget "_WP" (LM:ent->pts EnameShape DensityPoint) (list (list -3 (list (strcat $RgpShape "," $RgpTiggerOn "," $RgpTiggerOff))))))
			(ZoomPrevius CheckZoom)			
			
			(setq LstEnameChecked (LM:ss->ent Ssel))
			(if (not (member EnameShape LstEnameChecked)) (setq LstEnameChecked (cons EnameShape LstEnameChecked)))
			
			(foreach itm LstEnameChecked
				(cond
					((CheckIfEasyCutShape itm)
						(setq LstArea (append LstArea (list (list (vla-get-area (vlax-ename->vla-object itm)) itm))))
					)
					((CheckIfEasyCutTrigger itm)
						(setq Rtn2 (cons itm Rtn2))
					)
				)
			)
			
			(setq LstArea (vl-sort LstArea (function (lambda (e1 e2)  (< (car e1) (car e2))))))					
			(foreach itm LstArea
					(setq Rtn1 (cons (cadr itm) Rtn1))
			)
			(foreach itm (GetContactEnameTriggerByDummyShape EnameShape)
				(if (not (member itm Rtn2))	(setq Rtn2 (cons itm Rtn2)))
			)
			
		)
	)
	;(princ "\nBenchMark  GetLineMessageShape ") (princ (/ (- (getvar "MILLISECS")  MSecStart) 1000.0))
	(list Rtn1 Rtn2)
)
;
;
;
(defun GetEntityForShape (Ename / DensityPoint Radius Density Ssel LstEnameChecked itm LstArea Rtn)

	(if Ename
		(progn
			(setq DensityPoint 50)
			
			(cond 
				((= (cdr (assoc 0 (entget Ename))) "CIRCLE")
					(setq Radius (cdr (assoc 40 (entget Ename))))
					(setq Density (fix (/ (* 2.0 pi) (* (acos (/ (- Radius $ArrowArcDivision) Radius)) 2.0))))
					(if (> Density $ArrowArcDivision) (setq DensityPoint Density))
				)
				((setq Data (IsLwPolylineCircle Ename))
					(setq Radius (cadr Data))
					(setq Density (fix (/ (* 2.0 pi) (* (acos (/ (- Radius $ArrowArcDivision) Radius)) 2.0))))
					(if (> Density $ArrowArcDivision) (setq DensityPoint Density))
				)
			)
				
			(setq CheckZoom (VisibleEname Ename))
			
				(setq Ssel (ssget "_WP" (LM:ent->pts Ename DensityPoint) $FilterList))
				(setq LstEnameChecked (LM:ss->ent Ssel))
				(if (not (member Ename LstEnameChecked)) (setq LstEnameChecked (append (list Ename) LstEnameChecked)))
				
			(ZoomPrevius CheckZoom)			
	
			(foreach itm LstEnameChecked
				(setq LstArea (append LstArea (list (list (vla-get-area (vlax-ename->vla-object itm)) itm))))
			)
			(setq LstArea (vl-sort LstArea (function (lambda (e1 e2)  (< (car e1) (car e2))))))					
			(foreach itm LstArea
				(setq Rtn (cons (cadr itm) Rtn))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameShape&TriggerByGroup (Group / LstEname itm Rtn LstGrp)

	(if Group
		(progn
			(setq LstEname (genames Group))
			(if LstEname
				(progn
					(foreach itm LstEname
						(setq Rtn (append Rtn (list (cdr itm))))
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
(defun GetDataSelectWithFilterSetup (/ IncludeHole 
						               Rtn Hole LstMinHole LstMaxHole Num a)
	;
	;
	;
	(defun IncludeHole (/ Num itm mind maxd _min _max Rtn)
		
		(setq Num 0)
		(foreach itm $CutOffarray
			(if (= (caddr itm) 1)
				(progn
					(setq mind (car itm) maxd (cadr itm))
					(setq _min (append _min (list Num)))
					(setq _max (append _max (list mind)))
					(setq Num maxd)
				)
			)
		)
		(if _min
			(progn
				(setq _min (append _min (list Num)))
				(setq _max (append _max (list 1000000)))
				(setq Rtn (list _min _max))
			)
		)
		Rtn
	)
	;
	;
	;
	(setq Rtn "")
	(if (setq Hole (IncludeHole))
		(if (= (length (car Hole)) (length (cadr Hole)))
			(progn
				(setq LstMinHole (car  Hole))
				(setq LstMaxHole (cadr Hole))
				(setq Num 0)
				(repeat (length LstMinHole)
					(if (and (= (nth Num LstMinHole) 0) (= (nth Num LstMaxHole) 0))
						(setq a nil)
						(progn
							(setq Rtn (strcat Rtn "(-4 . \"<AND\") (0 . \"CIRCLE\") "))
							(setq Rtn (strcat Rtn "(-4 . \"<AND\") (-4 . \">\") (40 . " (LM:Rtos (/ (nth Num LstMinHole) 2.0) 2 3) ") (-4 . \"AND>\")"))
							(setq Rtn (strcat Rtn "(-4 . \"<AND\") (-4 . \"<\") (40 . " (LM:Rtos (/ (nth Num LstMaxHole) 2.0) 2 3) ") (-4 . \"AND>\")"))
							(setq Rtn (strcat Rtn "(-4 . \"AND>\")"))
						)
					)
					(setq Num (1+ Num))
				)
			)
		)
	)
	
	(if (/= Rtn "")
		(setq Rtn (strcat "((-4 . \"<OR\")" Rtn "(0 . \"ELLIPSE\") (0 . \"LWPOLYLINE\") (-4 . \"OR>\") (-3 (\"" $RgpShape "\")))"))
		(setq Rtn (strcat "((-4 . \"<OR\") (0 . \"ELLIPSE\") (0 . \"CIRCLE\") (0 . \"LWPOLYLINE\") (-4 . \"OR>\") (-3 (\"" $RgpShape "\")))"))
	)
	(read Rtn)
)
;
;
;
(defun GetLstIdShapeWithEnameTriggerOnSheet (EnameSheet / CheckZoom Sheet Ssel Num DataTrigger IdShape TypeTrigger Rtn)

	(if EnameSheet
		(progn
		
			(setq CheckZoom (VisibleEname EnameSheet))
			;(setq Sheet (DiscretizeShape EnameSheet))
			(setq Sheet (DiscretizeShapeNoControl EnameSheet))
			(setq Ssel (ssget "_CP" Sheet (list (list -3 (list (strcat $RgpTiggerOn "," (strcat $RgpTiggerOff)))))))
			
			(if Ssel
				(progn
					(setq Num 0)
					(repeat (sslength Ssel)
						
						(setq DataTrigger (GetDataTrigger (ssname Ssel Num)))
						
						(if (assoc (nth 0 DataTrigger) Rtn)
							(progn
								(setq IdShape     (nth 0 DataTrigger))
								(setq TypeTrigger (nth 2 DataTrigger))
								
								(if (= TypeTrigger "ENTRA")
									(setq Rtn (subst (list IdShape (ssname Ssel Num) (nth 2 (assoc (nth 0 DataTrigger) Rtn))) 
													 (assoc (nth 0 DataTrigger) Rtn) Rtn)
									)
									(setq Rtn (subst (list IdShape (nth 1 (assoc (nth 0 DataTrigger) Rtn)) (ssname Ssel Num)) 
													 (assoc (nth 0 DataTrigger) Rtn) Rtn)
									)
								)
							)
							
							(progn
								(if (= (nth 2 DataTrigger) "ENTRA")
									(setq Rtn (append Rtn (list (list (nth 0 DataTrigger) (ssname Ssel Num) nil))))
									(setq Rtn (append Rtn (list (list (nth 0 DataTrigger) nil (ssname Ssel Num)))))
								)
							)
						)
							
						(setq Num (1+ Num))
					)
				)
			)
			(ZoomPrevius CheckZoom)
		)
	)
	Rtn
)
;
; Shape Sheet Query  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetAssocIdEnameSheet (/ itm Rtn)
	(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpSheet)))))
		(setq Rtn (append Rtn (list (list (cdr (nth 3  (nth 1 (assoc -3 (entget itm (list "*")))))) itm))))
	)
	Rtn
)
;
;
;
(defun GetTypeSequnce (EnameSheet / Rtn)
	(if (setq EnameSheet (GetEnameSheetByDummyEname EnameSheet))
		(if (assoc -3 (entget EnameSheet (list "*")))
			(if (= (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)
				(if (> (length (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) 7)
					(setq Rtn (cdr (nth 6 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetSequenceGroupOnSheet (EnameSheet / LstXdata Loop Num conta Data Rtn)

	(if EnameSheet
		(progn
			; informazioni estese della lamiera piu' percorso di taglio
			; (-3 ("LAMIERA" (1002 . "{") 
			;                   (1000 . nome lamiera  			-valore stringa-)
			;                   (1000 . id lamiera    			-valore stringa-)
			;                   (1000 . spessore lamiera    	-valore stringa-)
			;                   (1000 . qualita lamiera    		-valore stringa-)
			;                   (1000 . tipo sequenza 	    	-valore stringa-)
			;                   (1000 . nome gruppo contorno 1  -valore stringa-)
			;                   (1000 . nome gruppo contorno 2  -valore stringa-)
			;                   (1000 . nome gruppo contorno 3  -valore stringa-)
			;                   (1002 . "}") 
			;     )
			; )			
			(if (CheckIfEasyCutSheetMember EnameSheet)
				(progn
					(setq Loop T)
					(setq Num 6)
					(setq LstXdata (nth 1 (assoc -3 (entget EnameSheet (list "*")))))
					(while loop 
						(setq Data (cdr (nth Num LstXdata)))
						
						(if (= Data "}")
							(setq Loop nil)
							(setq Rtn (append Rtn (list Data)))
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
;
(defun GetEnameEasyCutByDummyEname (EnameDummy / Rtn)

	(if EnameDummy
		(cond
			((CheckIfPaperSpace EnameDummy)								; -1 Entità non significativa
				(setq Rtn (list -1 EnameDummy))	
			)
			((CheckIfEasyCutShape EnameDummy)							; 100 Modifico il contorno e aggiorno il blocco shape
				(setq Rtn (list 100 EnameDummy))								
			)
			((CheckIfEasyCutTrigger EnameDummy)							; 100 Modifico il contorno e aggiorno il blocco shape
				(if (setq Tmp (GetEnameShapeByEnameTrigger EnameDummy))
					(setq Rtn (list 100 Tmp))
				)
			)
			((CheckIfBlockShape EnameDummy)								; 101 Modifico gli attributi del blocco shape e aggiorno il contorno
				(setq Rtn (list 101 EnameDummy))
			)
			((CheckIfEasyCutSheet EnameDummy)							; 200 Modifico la lamiera e aggiorno il blocco sheet
				(setq Rtn (list 200 EnameDummy))
			)
			((CheckIfBlockSheet EnameDummy)								; 201 Modifico gli attributi del blocco sheet e aggiorno la lamiera
				(setq Rtn (list 201 EnameDummy))
			)
			((or (= (cdr (assoc 0 (entget EnameDummy))) "LWPOLYLINE")	; 0   Nuovo contorno o lamiera
				 (= (cdr (assoc 0 (entget EnameDummy))) "POLYLINE")
				 (= (cdr (assoc 0 (entget EnameDummy))) "CIRCLE")
				 (= (cdr (assoc 0 (entget EnameDummy))) "ELLIPSE")
			 )
			  (setq Rtn (list 0 EnameDummy))
			)
			(t 
				(setq Rtn (list -1 EnameDummy))							; -1 Entità non significativa
			)
		)
	)
	Rtn
)
;
; General Query +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetEnameById (Id / SselShape SselTriggerOn SselTriggerOff ContaShape ContaTriggerOn ContaTriggerOff NotFind
						  IdShape IdTriggerOn IdTriggerOff EnameShape EnameTriggerOn EnameTriggerOff)

	
	(if Id
		(progn

			(setq EnameShape	 	(cdr (assoc Id $ListIdShape)))
			(setq EnameTriggerOn 	(cdr (assoc Id $ListIdTriggerOn)))
			(setq EnameTriggerOff 	(cdr (assoc Id $ListIdTriggerOff)))

			(if (null EnameShape)
				(progn
		
					(setq SselShape      (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape)))))
					(setq SselTriggerOn  (ssget "_X" (list (cons 67 0) (list -3 (list $RgpTiggerOn)))))
					(setq SselTriggerOff (ssget "_X" (list (cons 67 0) (list -3 (list $RgpTiggerOff)))))
			
					(setq ContaShape 0)
					(setq ContaTriggerOn 0)
					(setq ContaTriggerOff 0)
			
					; contorno interno / esterno
					(setq NotFind T)
					(if SselShape
						(while (and NotFind (< ContaShape (sslength SselShape)))
							(setq IdShape (cdr (nth 3  (nth 1 (assoc -3 (entget (ssname SselShape ContaShape) (list "*")))))))
							(if (= Id IdShape)
								(progn
									(setq EnameShape (ssname SselShape ContaShape))
									(setq NotFind nil)
								)
							)
							(setq ContaShape (1+ ContaShape))
					
						)
					)
					; attacco entra
					(setq NotFind T)
					(if SselTriggerOn
						(while (and NotFind (< ContaTriggerOn (sslength SselTriggerOn)))
							(setq IdTriggerOn (cdr (nth 2  (nth 1 (assoc -3 (entget (ssname SselTriggerOn ContaTriggerOn) (list "*"))))))) 
							(if (= Id IdTriggerOn)
								(progn
									(setq EnameTriggerOn (ssname SselTriggerOn ContaTriggerOn))
									(setq NotFind nil)
								)
							)
							(setq ContaTriggerOn (1+ ContaTriggerOn))
						)
					)
					; attacco esci
					(setq NotFind T)
					(if SselTriggerOff
						(while (and NotFind (< ContaTriggerOff (sslength SselTriggerOff)))
							(setq IdTriggerOff (cdr (nth 2  (nth 1 (assoc -3 (entget (ssname SselTriggerOff ContaTriggerOff) (list "*"))))))) 
							(if (= Id IdTriggerOff)
								(progn
									(setq EnameTriggerOff (ssname SselTriggerOff ContaTriggerOff))
									(setq NotFind nil)
								)
							)
							(setq ContaTriggerOff (1+ ContaTriggerOff))
						)
					)
				)
			)
		)
	)
	(list EnameShape EnameTriggerOn EnameTriggerOff)
)
;
;
;
(defun GetLengthEname (EnameEntity / Rtn)
	
	(setq Rtn 0.0)
	(if EnameEntity
		(cond
			((= (cdr (assoc 0 (entget EnameEntity))) "CIRCLE")
				(setq Rtn (vla-get-Circumference (vlax-ename->vla-object EnameEntity)))
			)
			((= (cdr (assoc 0 (entget EnameEntity))) "ELLIPSE")
				(setq Rtn (vlax-curve-getDistAtParam (vlax-ename->vla-object EnameEntity) (* 2.0 pi)))
			)
			((= (cdr (assoc 0 (entget EnameEntity))) "LWPOLYLINE")
				(setq Rtn (vla-get-Length (vlax-ename->vla-object EnameEntity)))
			)
			((= (cdr (assoc 0 (entget EnameEntity))) "ARC")
				(setq Rtn (vla-get-ArcLength (vlax-ename->vla-object EnameEntity)))
			)
			((= (cdr (assoc 0 (entget EnameEntity))) "LINE")
				(setq Rtn (vla-get-Length (vlax-ename->vla-object EnameEntity)))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetLstIdEntity (/ Ssel Conta Rtn)
		
	(setq Ssel (ssget "_X" (list (cons 67 0) (list -3 (list (strcat $RgpShape "," $RgpTiggerOn "," $RgpTiggerOff))))))
	(setq Conta 0)
	(if Ssel
		(repeat (sslength Ssel) 
			(setq Rtn (append Rtn (list (cdr (nth 3  (nth 1 (assoc -3 (entget (ssname Ssel Conta) (list "*")))))))))
			(setq Conta (1+ Conta))
		)
	)
	Rtn
)
;
;
;
(defun SsgetWithFilterSetup (TypeSelect LstData FilterSetup / Ssel Rtn Num)
	
	(setq Ssel nil)
	;
	; preselect ++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(cond	
		((and TypeSelect LstData)
			(setq Ssel  (ssget TypeSelect LstData FilterSetup))
		)
		((and TypeSelect (not LstData))
			(setq Ssel  (ssget TypeSelect FilterSetup))
		)
		((and (not TypeSelect) (not LstData))
			(setq Ssel  (ssget FilterSetup))
		)
	)
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	
	(if (= $CutOffIrregularShape 1)
		(if Ssel
			(progn
				(setq Rtn (ssadd)) 
				(setq Num 0)
				(repeat (sslength Ssel)
					(setq Ename (ssname Ssel Num))
					(cond
						((= (GetTypShape Ename) "CE")
							(ssadd Ename Rtn)
						)
						((and (= (GetTypShape Ename) "CI")
							 (/= (cdr (assoc 0 (entget Ename))) "LWPOLYLINE"))
							(ssadd Ename Rtn)
						)
					)
					(setq Num (1+ Num))
				)
			)
		)
		(setq Rtn Ssel)
	)
	Rtn
)
;
;
;
(defun GetLstEnameOnSheetWithFilterSetup(EnameSheet / Sheet Ssel CheckZoom Rtn)
	(if EnameSheet
		(progn
		
			(setq CheckZoom (VisibleEname EnameSheet))
			;(setq Sheet (DiscretizeShape EnameSheet))
			(setq Sheet (DiscretizeShapeNoControl EnameSheet))
			(setq Ssel  (SsgetWithFilterSetup "_CP" Sheet (GetDataSelectWithFilterSetup)))
			(if Ssel    (setq Rtn (LM:ss->ent Ssel)))
			(ZoomPrevius CheckZoom)
		)
	)
	Rtn
)
;
; Speed Query +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetSpeedCut (EnameShape / TkShape Rtn itm thk speed)

	(if EnameShape
		(if (assoc -3 (entget EnameShape (list "*")))
			(if (and (=  (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)
					 (= (length (nth 1 (assoc -3 (entget EnameShape (list "*"))))) 14))
				(progn
					(setq TkShape (cdr (nth 10 (nth 1 (assoc -3 (entget EnameShape (list "*")))))))		
					(setq Rtn $SpeedCut)
					(foreach itm $SpeedCutArray
						(if (= (caddr itm) 1)
							(progn
								(setq thk (car itm)
									speed (cadr itm)
								)
								(if (= (atof TkShape) thk)
									(setq Rtn speed)
								)
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
(defun GetSpeedCutByThickness (StrThickness / TkShape Rtn itm thk speed)

	(if StrThickness
		(progn
			(setq Rtn $SpeedCut)
			(foreach itm $SpeedCutArray
				(if (= (caddr itm) 1)
					(progn
						(setq thk (car itm)
							speed (cadr itm)
						)
						(if (= (atof StrThickness) thk)
								(setq Rtn speed)
						)
					)
				)
			)
		)
	)
	Rtn
)
;
; BarCode Query +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetDataBarCode ( / Rtn itm)


	(foreach itm $BarCodeArray

		(if (= (nth 2 itm) 1)
			(progn
		
				(cond
					((= (nth 1 itm) -1)
						(setq Rtn (append Rtn (list (list -1 (nth 0 itm)))))
					)
					(t
						(setq Rtn (append Rtn (list (list (nth 1 itm) (nth 0 itm)))))
					)
				)
			)
		)
	)
	Rtn
)
;
; BlockShape Query ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetLstBlockBomShapeByRgp (RgpShapeTarget NameBlock / Rtn)

	(if (and RgpShapeTarget NameBlock)
		(foreach itm (LM:ss->ent (ssget "_X" (list '(67 . 0) '(0 . "INSERT") (append (list -3) (list (list RgpShapeTarget))))))
			(if (= (strcase (LM:al-effectivename itm)) (strcase NameBlock))
				(setq Rtn (append Rtn (list itm)))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameBlockShapeById (Id / Ssel Conta Find Rtn)

	(if Id
		(progn
			(setq Ssel      (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShapeTarget)))))
			(setq Conta 0)
			(setq Find T)
			(if Ssel
				(while (and Find (< Conta (sslength Ssel)))
					(if (= Id (LM:vl-getattributevalue (vlax-ename->vla-object (ssname Ssel Conta)) "IDSHAPE"))
						(progn
							(setq Rtn (ssname Ssel Conta))
							(setq Find nil)
						)
					)
					(setq Conta (1+ Conta))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetAssocEnameShapeWithEnameBom (/ NthNil
										 SselBom itm MaxMin LstStorage PosShape LoopShape
										 EnameShape Rtn)

	(defun NthNil (Lst Pos)
		(if (= Pos (length Lst))
			nil
			(nth Pos Lst)
		)
	)
	;
	; Main
	;
	(if (setq SselBom (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShapeTarget)))))
		(ZoomSsel SselBom 100.0)
	)
	(foreach itm (LM:ss->ent SselBom)

		(setq MaxMin 		  (BoundingBoxLstEname (list itm)))
		(setq LstStorage      (LM:ss->ent (ssget "_C" (car MaxMin) (caddr MaxMin) 
													  (list '(0 . "LWPOLYLINE") (cons 67 0) (list -3 (list $RgpShape))))))
		(setq PosShape  0)
		(setq LoopShape T)
		
		(while LoopShape
			(if (setq EnameShape (NthNil LstStorage PosShape))
				(if (= (GetTypeShape EnameShape) 1)
					(progn
						(setq Rtn (append Rtn (list (list EnameShape itm))))
						(setq LoopShape nil)
					)
				)
				(setq LoopShape nil)
			)
			(setq PosShape (1+ PosShape))
		)
			
	)
	(ZoomPrevius01)
	Rtn
)
;
;
;
(defun GetEnameBlockShapeByEnameShape (EnameShape / NthNil 
													PosBom PosShape LstBoom LoopBoom CheckZoom EnameBoom MaxMin LstEnameShape LoopShape Shape Rtn)

	(defun NthNil (Lst Pos)
		(if (= Pos (length Lst))
			nil
			(nth Pos Lst)
		)
	)
	;
	; Main
	;
	(if EnameShape
		(progn
			(if (setq LstBoom (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShapeTarget))))))
				(setq LoopBoom T)
			)
			(setq PosBom   0)
			(while LoopBoom
			
				(if (setq EnameBoom (NthNil LstBoom PosBom))
					(setq MaxMin 	(BoundingBoxLstEname (list EnameBoom)))
					(setq LoopBoom 	nil)
				)
				
				(if EnameBoom
					(progn
						
						(setq CheckZoom (VisibleEname EnameBoom))
						(if (setq LstEnameShape (LM:ss->ent (ssget "_C" (car MaxMin) (caddr MaxMin) (list (cons 67 0) (list -3 (list $RgpShape))))))
							(setq LoopShape T)
							(setq LoopShape nil)
						)
						(setq PosShape 0)
						(while LoopShape
							(if (setq Shape (NthNil LstEnameShape PosShape))
								(if (equal Shape EnameShape)
									(setq Rtn EnameBoom)
								)
								(setq LoopShape nil)
							)
							(setq PosShape (1+ PosShape))
						)
						(ZoomPrevius CheckZoom)	
					)
				)
				(setq PosBom (1+ PosBom))
			)
		)
	)
	Rtn
)
;
;
;
(defun BlockInfoShapeByEnameShape (EnameShape / DataInfoShape LstBlk itm Rtn)

	(if EnameShape
		(progn
			(setq DataInfoShape (GetDataShape EnameShape))
			
			;0  TypShape
			;1  IdShape 
			;2  JouShape 
			;3  NameShape 
			;4  CutComp 
			;5  LenghtCut 
			;6  (SeTime ExTime InTime TotTime) 
			;7  ComShape 
			;8  PhaseShape 
			;9	MatShape
			;10	TkShape 
			;11	DateShape
			;12	QtaShape)
			
			(if DataInfoShape
				(progn
					;(setq LstBlk (GetLstBlock "BlockShape01"))
					(setq LstBlk (GetLstBlock NameBlockShape$))

					(foreach itm LstBlk
					
						(if (= (LM:vl-getattributevalue (vlax-ename->vla-object itm) "IDSHAPE") (nth 1 DataInfoShape))
							(setq Rtn itm)
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
(defun GetInfoBlockShape (EnameBlockShape / IdShape OrderShape PhaseShape MkShape TkShape LengthShape HeightShape MatShape LastModifyShape
								       PerimeterShape WeigthShape TypeShape JouShape CompShape TimeCutShape QtaShape Rtn)



	(if EnameBlockShape
		(progn
				(setq IdShape	 		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "IDSHAPE"))
				(setq OrderShape		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "ORDERSHAPE"))
				(setq PhaseShape		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "PHASESHAPE"))
				(setq MkShape			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "MKSHAPE"))
				(setq TkShape			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "TKSHAPE"))
				(setq LengthShape		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "LENGTHSHAPE"))
				(setq HeightShape		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "HEIGHTSHAPE"))
				(setq MatShape			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "MATSHAPE"))
				(setq LastModifyShape	(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "LASTMODIFYSHAPE"))
				(setq PerimeterShape	(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "PERIMETERSHAPE"))
				(setq WeigthShape		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "WEIGTHSHAPE"))
				(setq TypeShape			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "TYPESHAPE"))
				(setq JouShape			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "JOUSHAPE"))
				(setq CompShape			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "COMPSHAPE"))
				(setq TimeCutShape		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "TIMECUTSHAPE"))
				(setq QtaShape			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockShape) "QTASHAPE"))

				(setq Rtn (list IdShape OrderShape PhaseShape MkShape TkShape LengthShape HeightShape
								MatShape LastModifyShape PerimeterShape WeigthShape TypeShape JouShape CompShape TimeCutShape QtaShape)								
				)
		)
	)
	Rtn
)
;
; 
;
(defun GetEnameBlockByFence (SselDummy NameBomBlock DistFence / minmax Ssel1 Ssel2 Ssel3 Ssel4 Ssel5 Ssel6 Ssel7 Ssel8 Rtn)

	
	(if (and SselDummy NameBomBlock DistFence)
		(progn
			(setq minmax	(LM:SSBoundingBox SselDummy))
			(ZoomWindow01 (list (- (car (nth 0 minmax)) DistFence 500) (- (cadr (nth 0 minmax)) DistFence 500))
						  (list (+ (car (nth 2 minmax)) DistFence 500) (+ (cadr (nth 2 minmax)) DistFence 500)))
			
			(if (and (setq Ssel1 (ssget "_F" (list 	(nth 0 minmax) (list (- (car (nth 0 minmax)) DistFence) (cadr (nth 0 minmax))))
											 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					 (setq Ssel2 (ssget "_F" (list 	(nth 0 minmax) (list (car (nth 0 minmax)) (- (cadr (nth 0 minmax)) DistFence))) 
											 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					 (setq Ssel3 (ssget "_F" (list 	(nth 1 minmax) (list (car (nth 1 minmax)) (- (cadr (nth 1 minmax)) DistFence))) 
											 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					 (setq Ssel4 (ssget "_F" (list 	(nth 1 minmax) (list (+ (car (nth 1 minmax)) DistFence) (cadr (nth 1 minmax))))
											 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))											 
					 (setq Ssel5 (ssget "_F" (list 	(nth 2 minmax) (list (+ (car (nth 2 minmax)) DistFence) (cadr (nth 2 minmax))))
											 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))											 
					 (setq Ssel6 (ssget "_F" (list 	(nth 2 minmax) (list (car (nth 2 minmax)) (+ (cadr (nth 2 minmax)) DistFence))) 
											 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					 (setq Ssel7 (ssget "_F" (list 	(nth 3 minmax) (list (car (nth 3 minmax)) (+ (cadr (nth 3 minmax)) DistFence))) 
											 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
					 (setq Ssel8 (ssget "_F" (list 	(nth 3 minmax) (list (- (car (nth 3 minmax)) DistFence) (cadr (nth 3 minmax))))
											 (list (cons 0 "INSERT") (list -3 (list $RgpShapeTarget)))))
				)
				(if (ListEqual (list (ssname Ssel1 0) (ssname Ssel2 0) 
									 (ssname Ssel3 0) (ssname Ssel4 0) 
									 (ssname Ssel5 0) (ssname Ssel6 0)
									 (ssname Ssel7 0) (ssname Ssel8 0))
					)
					(if (= (strcase (LM:al-effectivename (ssname Ssel1 0))) (strcase NameBomBlock))
						(setq Rtn (ssname Ssel1 0))
					)
				)
			)
			(ZoomPrevius01)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameBlockLogo (EnameBlockShape / minmax Ssel i Ename Rtn)
	
	(if EnameBlockShape
		(progn
			(setq minmax	 (BoundingBoxLstEname (list EnameBlockShape)))
			(ZoomWindow01 	 (nth 0 minmax) (nth 2 minmax))
			(setq Ssel (ssget "_W" (nth 0 minmax) (nth 2 minmax) '((0 . "INSERT"))))
			(ZoomPrevius01)
			(if Ssel
				(repeat (setq i (sslength Ssel))
					(setq Ename (ssname Ssel (setq i (1- i))))
					(if (CheckIfBlockLogo Ename) (setq Rtn Ename))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameBlockBarCode (EnameBlockShape / minmax Ssel i Ename Rtn)
	
	(if EnameBlockShape
		(progn
			(setq minmax	 (BoundingBoxLstEname (list EnameBlockShape)))
			(ZoomWindow01 	 (nth 0 minmax) (nth 2 minmax))
			(setq Ssel (ssget "_W" (nth 0 minmax) (nth 2 minmax) '((0 . "INSERT"))))
			(ZoomPrevius01)
			(if Ssel
				(repeat (setq i (sslength Ssel))
					(setq Ename (ssname Ssel (setq i (1- i))))
					(if (CheckIfBlockBarCode Ename) (setq Rtn Ename))
				)
			)
		)
	)
	Rtn
)
;
; Sheet Query +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetEnameSheetByDummyEname (DummyEname / Rtn)

	(if (CheckIfEasyCutSheetMember DummyEname)
		(cond
			((CheckIfEasyCutSheet DummyEname)
				(setq Rtn DummyEname)
			)
			((CheckIfBlockSheet DummyEname)
				(setq Rtn (GetEnameSheetById (vl-remove-blanks (nth 0 (GetInfoBlockSheet DummyEname)))))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameSheet (/ itm Rtn)

	(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpSheet)))))
		(setq Rtn (append Rtn (list itm)))
	)
	Rtn
)
;
;
;
(defun GetListIdSheet (/ Ssel conta Rtn)

	(setq Ssel (ssget "_X" (list (cons 67 0) (list -3 (list $RgpSheet)))))
	(if Ssel
		(progn	
			(setq conta 0)
			(repeat (sslength Ssel)
				(setq Rtn (append Rtn (list (cdr (nth 3 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))))
				(setq conta (1+ conta))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetListNameSheet (/ Ssel conta Rtn)

	(setq Ssel (ssget "_X" (list (cons 67 0) (list -3 (list $RgpSheet)))))
	(if Ssel
		(progn	
			(setq conta 0)
			(repeat (sslength Ssel)
				(setq Rtn (append Rtn (list (cdr (nth 2 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))))
				;
				;(princ (cdr (nth 2 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))
				;(ZoomEname (ssname Ssel conta) 100)
				;(getstring)
				;
				(setq conta (1+ conta))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetOriginSheet (EnameSheet / Rtn)
		(if EnameSheet
			(progn
				(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
				(setq Rtn (vlax-safearray->list mnl))
			)
		)
		Rtn
)
;
;
;
(defun GetDimensionSheet (EnameSheet / Rtn Width Height Rtn)
		(if EnameSheet
			(progn
				(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
				(setq Width   		(abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
				(setq Height  		(abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
				(setq Rtn 			(list Width Height))
			)
		)
		Rtn
)
;
;
;
(defun GetEnameSheetById (Id / SselSheet ContaSheet NotFind IdSheet Rtn)

	(if Id
		(progn
			(setq SselSheet (ssget "_X" (list (cons 67 0) (cons 0  "LWPOLYLINE") (list -3 (list $RgpSheet)))))
			(setq ContaSheet 0)
			(setq NotFind T)
			(if SselSheet
				(while (and NotFind (< ContaSheet (sslength SselSheet)))
					(setq IdSheet (cdr (nth 3  (nth 1 (assoc -3 (entget (ssname SselSheet ContaSheet) (list "*")))))))
					(if (= Id IdSheet)
						(progn
							(setq Rtn (ssname SselSheet ContaSheet))
							(setq NotFind nil)
						)
					)
					(setq ContaSheet (1+ ContaSheet))
					
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameSheetByName (NameSheet / tp_ent rag Ssel conta Name Rtn)

	(if NameSheet
		(progn
			(setq tp_ent (cons '0 "LwPolyline")                            
				  rag 	 (append (list -3) (list (list $RgpSheet)))      
				  Ssel   (ssget "X" (list tp_ent rag))
			)
			(if Ssel
				(progn
					(setq conta 0)
					; (-3 ("LAMIERA" (1002 . "{") 
					;                   (1000 . nome lamiera  		-valore stringa-)
					;                   (1000 . id lamiera    		-valore stringa-)
					;                   (1000 . spessore lamiera    -valore stringa-)
					;                   (1002 . "}") 
					;     )
					; )
					(repeat (sslength Ssel)
						
						(setq Name (cdr (nth 2 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))
						(if (= (strcase NameSheet T) (strcase Name T))
							(setq Rtn (ssname Ssel conta))
						)
						(setq conta (1+ conta))
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
(defun GetIdSheet (EnameSheet / Rtn)
	(if EnameSheet
		(progn
			(if (assoc -3 (entget EnameSheet (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)
					(setq Rtn (cdr (nth 3 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))  ;	["GGGGG"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetNameSheet (EnameSheet / Rtn)
	(if EnameSheet
		(progn
			(if (assoc -3 (entget EnameSheet (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)
					(setq Rtn (cdr (nth 2 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))  ;	["GGGGG"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetMatSheet (EnameSheet / Rtn)
	(if EnameSheet
		(progn
			(if (assoc -3 (entget EnameSheet (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)
					(setq Rtn (cdr (nth 5 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))  ;	["GGGGG"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetTkSheet (EnameSheet / Rtn)
	(if EnameSheet
		(progn
			(if (assoc -3 (entget EnameSheet (list "*")))
				(if (=  (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)
					(setq Rtn (cdr (nth 4 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))  ;	["GGGGG"]
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetDataSheetByName (NameSheet / 	Ssel conta Rtn Name IdSheet ThickSheet EnameSheet pmnl pmxl
										Widthsheet HeightSheet SurfaceSheet WeightSheet MatSheet)

	(setq Ssel (ssget "_X" (list (cons 67 0) (list -3 (list $RgpSheet)))))
	(if Ssel
		(progn	
			(setq conta 0)
			(repeat (sslength Ssel)
				(setq Name (cdr (nth 2 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))
				(if (= (strcase Name T) (strcase NameSheet T))
					(progn
						(setq IdSheet 	 (cdr (nth 3 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))
						(setq ThickSheet (cdr (nth 4 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))
						(setq MatSheet   (cdr (nth 5 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))
						(setq EnameSheet (ssname Ssel conta))
						(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
						(setq pmnl (vlax-safearray->list mnl))
						(setq pmxl (vlax-safearray->list mxl))
						(setq Widthsheet   (rtos (abs (- (nth 0 pmxl) (nth 0 pmnl))) 2 2))
						(setq HeightSheet  (rtos (abs (- (nth 1 pmxl) (nth 1 pmnl))) 2 2))
						(setq SurfaceSheet (rtos (/ (vla-get-area (vlax-ename->vla-object (ssname Ssel conta))) 1000000.0) 2 2))
						(setq WeightSheet  (rtos (* (* 7.85 (atof SurfaceSheet)) (atof ThickSheet)) 2 2))
						(setq Rtn (list IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet))
					)
				)
				(setq conta (1+ conta))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetDataSheetByEname (EnameSheet / Rtn IdSheet ThickSheet pmnl pmxl Widthsheet HeightSheet SurfaceSheet WeightSheet MatSheet)

	(if EnameSheet
		(if (assoc -3 (entget EnameSheet (list "*")))
			(if (= (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)
				(progn
					(setq NameSheet  (cdr (nth 2 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))
					(setq IdSheet 	 (cdr (nth 3 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))
					(setq ThickSheet (cdr (nth 4 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))
					(setq MatSheet   (cdr (nth 5 (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))
					(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
					(setq pmnl (vlax-safearray->list mnl))
					(setq pmxl (vlax-safearray->list mxl))
					(setq Widthsheet   (rtos (abs (- (nth 0 pmxl) (nth 0 pmnl))) 2 2))
					(setq HeightSheet  (rtos (abs (- (nth 1 pmxl) (nth 1 pmnl))) 2 2))
					(setq SurfaceSheet (rtos (/ (vla-get-area (vlax-ename->vla-object EnameSheet)) 1000000.0) 2 2))
					(setq WeightSheet  (rtos (* (* 7.85 (atof SurfaceSheet)) (atof ThickSheet)) 2 2))
					(setq Rtn (list IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameSheetByEnameShape (EnameShape / LstSheet Loop EnameSheet Num ChkZoom Num Rtn)

	
	(if EnameShape
		(progn

			(if (setq LstSheet (LM:ss->ent (ssget "X" (list (list -3 (list $RgpSheet))))))
				(setq Loop T)
			)

			(setq Num 0)
			(while Loop
				(setq ChkZoom (VisibleEname (nth Num LstSheet)))
					;(if (member EnameShape (LM:ss->ent (ssget "_CP" (DiscretizeShape (nth Num LstSheet)) (list (list -3 (list $RgpShape))))))
					(if (member EnameShape (LM:ss->ent (ssget "_CP" (DiscretizeShapeNoControl (nth Num LstSheet)) (list (list -3 (list $RgpShape))))))
						(progn
							(setq EnameSheet (nth Num LstSheet))
							(setq Loop nil)
						)
					)
					(setq Num (1+ Num))
					(if (= Num (length LstSheet)) (setq Loop nil))
				(ZoomPrevius ChkZoom)
			)
			
			(if (PoligonInsidePoligon EnameSheet EnameShape)
				(setq Rtn EnameSheet)
				(setq Rtn nil)
			)
		)
	)
	;(vla-regen (vla-get-activedocument (vlax-get-acad-object)) acActiveViewport)
	Rtn
)
;
;
;
(defun GetEnameSheetByFence (DummyEnameShape DistFence / minmax tp_ent rag Ssel1 Ssel2 Ssel3 Ssel4 Ssel5 Ssel6 Ssel7 Ssel8 Rtn)

	
	(if (and DummyEnameShape DistFence)
		(progn
			(setq EnameShape (GetEnameShapeByDummyEnameSelect DummyEnameShape))
			(setq minmax	 (BoundingBoxLstEname (list EnameShape)))
			(ZoomWindow01 	 (list (- (car (nth 0 minmax)) DistFence 500) (- (cadr (nth 0 minmax)) DistFence 500))
							 (list (+ (car (nth 2 minmax)) DistFence 500) (+ (cadr (nth 2 minmax)) DistFence 500)))

			(setq tp_ent (cons '0 "LwPolyline")                      
				  rag 	 (append (list -3) (list (list $RgpSheet)))      
			)
								
			(if (and (setq Ssel1 (ssget "_F" (list 	(nth 0 minmax) (list (- (car (nth 0 minmax)) DistFence) (cadr (nth 0 minmax))))
											 (list tp_ent rag)))
					 (setq Ssel2 (ssget "_F" (list 	(nth 0 minmax) (list (car (nth 0 minmax)) (- (cadr (nth 0 minmax)) DistFence))) 
											 (list tp_ent rag)))
					 (setq Ssel3 (ssget "_F" (list 	(nth 1 minmax) (list (car (nth 1 minmax)) (- (cadr (nth 1 minmax)) DistFence))) 
											 (list tp_ent rag)))
					 (setq Ssel4 (ssget "_F" (list 	(nth 1 minmax) (list (+ (car (nth 1 minmax)) DistFence) (cadr (nth 1 minmax))))
											 (list tp_ent rag)))
					 (setq Ssel5 (ssget "_F" (list 	(nth 2 minmax) (list (+ (car (nth 2 minmax)) DistFence) (cadr (nth 2 minmax))))
											 (list tp_ent rag)))
					 (setq Ssel6 (ssget "_F" (list 	(nth 2 minmax) (list (car (nth 2 minmax)) (+ (cadr (nth 2 minmax)) DistFence))) 
											 (list tp_ent rag)))
					 (setq Ssel7 (ssget "_F" (list 	(nth 3 minmax) (list (car (nth 3 minmax)) (+ (cadr (nth 3 minmax)) DistFence))) 
											 (list tp_ent rag)))
					 (setq Ssel8 (ssget "_F" (list 	(nth 3 minmax) (list (- (car (nth 3 minmax)) DistFence) (cadr (nth 3 minmax))))
											 (list tp_ent rag)))
				)
				(if (ListEqual (list (ssname Ssel1 0) (ssname Ssel2 0) 
									 (ssname Ssel3 0) (ssname Ssel4 0) 
									 (ssname Ssel5 0) (ssname Ssel6 0)
									 (ssname Ssel7 0) (ssname Ssel8 0))
					)
					(setq Rtn (ssname Ssel1 0))
				)
			)
			(ZoomPrevius01)
		)
	)
	Rtn
)
;
; BlockSheet Query ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GetLstBlockBomSheetByRgp ( / Sselect i Rtn)

	(LM:ss->ent (ssget "_X" (list '(67 . 0) '(0 . "INSERT") (append (list -3) (list (list $RgpSheetTarget))))))
)
;
;
;
(defun GetEnameBlockSheetByEnameSheet (EnameSheet / LstEnameBlock Loop Num MaxMin Ssel CheckZoom Rtn)
	(if EnameSheet	
		(progn
			(if (setq LstEnameBlock (GetLstBlockBomSheetByRgp))
				(setq Loop T)
				(setq Loop nil)
			)
			(setq Num 1)
			(while Loop 
				(setq MaxMin (BoundingBoxLstEname (list (nth (- Num 1) LstEnameBlock))))
				(setq CheckZoom (VisibleEname EnameSheet))
				(if (setq Ssel (ssget "_C" (car MaxMin) (caddr MaxMin) (list (list -3 (list $RgpSheet)))))
					(if (and (= (sslength Ssel) 1) (equal EnameSheet (ssname Ssel 0)))
						(setq Rtn (nth (- Num 1) LstEnameBlock))
					)
				)
				(ZoomPrevius CheckZoom)
				(if (or Rtn (= (length LstEnameBlock) Num))	(setq Loop nil))
				(setq Num (1+ Num))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetEnameBlockSheetById (Id / Ssel Conta NotFind IdSheet Rtn)

	(if Id
		(progn
			(setq Ssel      (ssget "_X" (list (cons 67 0) (list -3 (list $RgpSheetTarget)))))
			(setq Conta 0)
			(setq NotFind T)
			(if Ssel
				(while (and NotFind (< Conta (sslength Ssel)))
					(setq IdSheet (LM:vl-getattributevalue (vlax-ename->vla-object (ssname Ssel Conta)) "ID_SHEET"))
					(if (= Id IdSheet)
						(progn
							(setq Rtn (ssname Ssel Conta))
							(setq NotFind nil)
						)
					)
					(setq Conta (1+ Conta))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetInfoBlockSheet (EnameBlockSheet / IdSheet NameSheet TkSheet DimSheet MatSheet Rtn)



	(if EnameBlockSheet
		(progn
				(setq IdSheet	 		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockSheet) "ID_SHEET"))
				(setq NameSheet	 		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockSheet) "NAME_SHEET"))
				(setq TkSheet			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockSheet) "THICKNESS_SHEET"))
				(setq DimSheet			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockSheet) "DIMENSION_SHEET"))
				(setq MatSheet			(LM:vl-getattributevalue (vlax-ename->vla-object EnameBlockSheet) "MATERIAL_SHEET"))

				(setq Rtn (list IdSheet NameSheet TkSheet DimSheet MatSheet))
		)
	)
	Rtn
)
;
;
;
(defun GetEnameSortByTypeByEnameBlockShape (EnameBlock / minmax Ssel Ename Rtn0	Rtn1 Rtn2 Rtn3 Rtn4 Rtn5 Rtn6)

	(if EnameBlock
		(progn
			(setq minmax	(BoundingBoxLstEname (list EnameBlock)))
			(setq CheckZoom (VisibleEname EnameBlock))
			(setq Ssel (ssget "_C" (nth 0 minmax) (nth 2 minmax)))
			(ZoomPrevius CheckZoom)
			
			(foreach Ename (LM:ss->ent Ssel) 
				(cond
					; Shape
					((CheckIfEasyCutShape Ename)
						(setq Rtn0 (append Rtn0 (list Ename)))
					)
					((CheckIfEasyCutTrigger Ename)
						(setq Rtn1 (append Rtn1 (list Ename)))
					)
					((CheckIfBlockShape Ename)
						(setq Rtn2 (append Rtn2 (list Ename)))
					)
					((CheckIfBlockLogo Ename)
						(setq Rtn3 (append Rtn3 (list Ename)))
					)
					((CheckIfBlockBarCode Ename)
						(setq Rtn4 (append Rtn4 (list Ename)))
					)
					((CheckIfBlockShapeTmp Ename)
						(setq Rtn5 (append Rtn5 (list Ename)))
					)
					; Other
					(t
						(setq Rtn6 (append Rtn6 (list Ename)))
					)
				)
			)
		)
	)
	(list 	Rtn0	; -> Shape 	
			Rtn1	; -> Trigger 	
			Rtn2 	; -> BlockShape	
			Rtn3 	; -> BlockLogo
			Rtn4	; -> BlockBarCode 			
			Rtn5 	; -> BlockShapeTmp
			Rtn6 	; -> Other
	)
)
;
; Find Shape
;
(defun FindEnameBomShape (OrderShape PhaseShape NameShape / CheckVal
															LstEnameBom Split itm Order Phase Name LstRtn)
	;
	(defun CheckVal (Value Range / RangeControl ValueControl itm Rtn)
		
		(if (and Value Range)
			(progn
				(setq RangeControl (vl-list->string (vl-remove 32 (vl-string->list Range))))
				(setq ValueControl (vl-list->string (vl-remove 32 (vl-string->list Value))))
			
				(cond 
					((= RangeControl "<>")
						(setq Rtn T)
					)
					(t
						(foreach itm (LM:str->lst RangeControl ",")
							(if (= (strcase itm) (strcase ValueControl))
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
	; Main
 	;
	(setq Split "|")
	(if (and OrderShape PhaseShape NameShape)
		(progn
		
			(setq LstEnameBom (GetLstBlock NameBlockShape$))
			
			(StartProgressBarDcl "$progbarsearch$" (length LstEnameBom))
			(StartProgressBar    "Ricerca marca"   (length LstEnameBom))
			
			(foreach itm LstEnameBom

				(UpDateProgressBar)
				(UpDateProgressBarDcl "$progbarsearch$")
			
				(setq Order (LM:vl-getattributevalue (vlax-ename->vla-object itm) "ORDERSHAPE"))
				(setq Phase (LM:vl-getattributevalue (vlax-ename->vla-object itm) "PHASESHAPE"))
				(setq Name  (LM:vl-getattributevalue (vlax-ename->vla-object itm) "MKSHAPE"))

				(if (and (CheckVal Order OrderShape) 
						 (CheckVal Phase PhaseShape) 
						 (CheckVal Name  NameShape)
					)
					(if (assoc (strcat Order Split Phase Split Name) LstRtn)
						(setq LstRtn (subst (append (assoc (strcat Order Split Phase Split Name) LstRtn) (list itm))
											(assoc (strcat Order Split Phase Split Name) LstRtn)
											LstRtn
									 )
						)
						(setq LstRtn (append LstRtn (list (list (strcat Order Split Phase Split Name) itm))))
					)					
				)
			)
			(ClearProgressBar)
			(if LstRtn (setq LstRtn (vl-sort LstRtn (function (lambda (e1 e2)  (< (car e1) (car e2)))))))
		)
	)
	LstRtn
)
;
;
;
(defun FindEnameShape (OrderShape PhaseShape NameShape / CheckVal
														 LstEname Split itm Order Phase Name LstRtn)
	;
	(defun CheckVal (Value Range / RangeControl ValueControl itm Rtn)
		
		(if (and Value Range)
			(progn
				(setq RangeControl (vl-list->string (vl-remove 32 (vl-string->list Range))))
				(setq ValueControl (vl-list->string (vl-remove 32 (vl-string->list Value))))
			
				(cond 
					((= RangeControl "<>")
						(setq Rtn T)
					)
					(t
						(foreach itm (LM:str->lst RangeControl ",")
							(if (= (strcase itm) (strcase ValueControl))
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
	; Main
 	;
	(setq Split "|")
	(if (and OrderShape PhaseShape NameShape)
		(progn

			(setq LstEname (GetLstExternalShape))
			
			(StartProgressBarDcl "$progbarsearch$" (length LstEname))
			(StartProgressBar    "Ricerca marca"   (length LstEname))

			(foreach itm LstEname
			
				(UpDateProgressBar)
				(UpDateProgressBarDcl "$progbarsearch$")

				(setq Order (GetComShape   itm))
				(setq Phase (GetPhaseShape itm))
				(setq Name  (GetNameShape  itm))

				(if (and (CheckVal Order OrderShape) 
						 (CheckVal Phase PhaseShape) 
						 (CheckVal Name  NameShape)
					)
					(if (assoc (strcat Order Split Phase Split Name) LstRtn)
						(setq LstRtn (subst (append (assoc (strcat Order Split Phase Split Name) LstRtn) (list itm))
											(assoc (strcat Order Split Phase Split Name) LstRtn)
											LstRtn
									 )
						)
						(setq LstRtn (append LstRtn (list (list (strcat Order Split Phase Split Name) itm))))
					)					
				)
			)
			(ClearProgressBar)
			(if LstRtn (setq LstRtn (vl-sort LstRtn (function (lambda (e1 e2)  (< (car e1) (car e2)))))))
		)
	)
	LstRtn
)
;
;
;
(defun FindShapeOnSheet (LstEnameSheet OrderShape PhaseShape NameShape / CheckVal
																	     Order Phase Name
																	     LstSheet LstEnameShape LstTmp EnameShape EnameSheet Split LstRtn)

	;OrderShape = "C872,C873" 	 or 	"<>"
	;PhaseShape = "1,2" 		 or 	"<>"
	;NameShape  = "0122,173-245" or 	"<>"
	;Return ((EnameSheet ("Com|Phase|Name" EnameShape EnameShape) ("Com|Phase|Name" EnameShape EnameShape) ....) (EnameSheet ("Com|Phase|Name" EnameShape EnameShape)))
	
	(defun CheckVal (Value Range / RangeControl ValueControl itm Rtn)
		
		(if (and Value Range)
			(progn
				(setq RangeControl (vl-list->string (vl-remove 32 (vl-string->list Range))))
				(setq ValueControl (vl-list->string (vl-remove 32 (vl-string->list Value))))
			
				(cond 
					((= RangeControl "<>")
						(setq Rtn T)
					)
					(t
						(foreach itm (LM:str->lst RangeControl ",")
							(if (= (strcase itm) (strcase ValueControl))
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
	; Main
	;

	(setq Split "|")
	(if (and OrderShape PhaseShape NameShape LstEnameSheet)
		(progn
			(StartProgressBarDcl "$progbarsearch$" (length LstEnameSheet))
			(StartProgressBar    "Ricerca marca"   (length LstEnameSheet))

			(foreach EnameSheet LstEnameSheet
				(setq LstTmp (append LstTmp (list (list (GetNameSheet EnameSheet) EnameSheet))))
			)
			(setq LstSheet (vl-sort LstTmp (function (lambda (e1 e2)  (< (car e1) (car e2))))))
			
			(foreach EnameSheet LstSheet
			
				(UpDateProgressBar)
				(UpDateProgressBarDcl "$progbarsearch$")
				
				(setq LstEnameShape (GetEnameShapeByEnameSheet (cadr EnameSheet) "CE"))
				(setq LstTmp nil)
				
				(foreach EnameShape LstEnameShape
					
					(setq Order (GetComShape   EnameShape))
					(setq Phase (GetPhaseShape EnameShape))
					(setq Name  (GetNameShape  EnameShape))
					
					(if (and (CheckVal Order OrderShape) 
							 (CheckVal Phase PhaseShape) 
							 (CheckVal Name  NameShape)
						)
						(if (assoc (strcat Order Split Phase Split Name) LstTmp)
							(setq LstTmp (subst (append (assoc (strcat Order Split Phase Split Name) LstTmp) (list EnameShape))
												(assoc (strcat Order Split Phase Split Name) LstTmp)
												LstTmp
										 )
							)
							(setq LstTmp (append LstTmp (list (list (strcat Order Split Phase Split Name) EnameShape))))
						)
					)
				)
				
				(if LstTmp
					(progn
						(setq LstTmp (vl-sort LstTmp (function (lambda (e1 e2)  (< (car e1) (car e2))))))
						(setq LstRtn (append LstRtn (list (cons (cadr EnameSheet) LstTmp))))
					)
				)
			)
			(ClearProgressBar)
		)
	)
	LstRtn
)
;
;
; 
(defun OutputSearch01 (LstFoundSearch LayoutName / 	Pos MaxCopyColumn Sheet EnameRule EnameBlock LstCopyEname Mark Ename RtnCopy
													PosCopy Width Height itm MaxH Num MarginX MarginY)

	(if (and LstFoundSearch LayoutName)
		(progn
			;LstFoundSearch -> ((EnameSheet ("Com|Phase|Name" EnameShape EnameShape) ("Com|Phase|Name" EnameShape EnameShape) ....) (EnameSheet ("Com|Phase|Name" EnameShape EnameShape)))
			(SetupLayout)
			(NewLayout    		LayoutName)
			(DeleteObjectLayout LayoutName)
			(ChangeLayout 		LayoutName)
			
			(setq Pos (list 0.0 0.0))
			(setq MaxCopyColumn 10)
			(setq MarginX	 800.0)
			(setq MarginY 	1500.0)

			(setq Num 			 1)
			(setq MaxH 			 0)

			(StartProgressBar    "OutputSearch"   (length LstFoundSearch))
			;(StartProgressBarDcl "$progbarotput$" (length LstFoundSearch))
			
			
			(foreach Sheet LstFoundSearch
			
				;(UpDateProgressBarDcl "$progbarotput$")
				(UpDateProgressBar)
				
				;(setq EnameRule  (GetEnameRuleByEnameSheet (car Sheet)))
				(setq EnameBlock (GetEnameBlockSheetById   (GetIdSheet (car Sheet))))
				;(setq LstCopyEname (list (car Sheet) EnameRule EnameBlock))
				(setq LstCopyEname (list (car Sheet) EnameBlock))
				
				(foreach Mark (cdr Sheet)
					(foreach Ename (cdr Mark)
						(setq LstCopyEname (append LstCopyEname (list Ename)))
					)
				)
				
				(setq RtnCopy	(CopyToLayout LstCopyEname LayoutName))
				(setq PosCopy   (LM:SSBoundingBox (LstEname->Ssget RtnCopy)))
				
				(setq Width  (abs (- (car  (car   PosCopy)) (car  (cadr PosCopy)))))
				(setq Height (abs (- (cadr (caddr PosCopy)) (cadr (cadr PosCopy)))))	
				
				;(alert (strcat (rtos Width 2 0) "*" (rtos Height 2 0)))
				
				(foreach itm RtnCopy
					(vla-move (vlax-ename->vla-object itm) (vlax-3d-point (car PosCopy)) (vlax-3d-point Pos))
				)
			
				(setq MaxH (max MaxH Height))
				(setq Num (1+ Num))
				
				(if (> (- Num 1) MaxCopyColumn)
					(progn
						(setq Pos (list 0.0 (+ (cadr Pos) MaxH MarginY)))
						(setq Num 1)
						(setq MaxH 0)
					)
					(setq Pos (list (+ (car Pos) Width MarginX) (cadr Pos)))
				)
			)
			(ClearProgressBar)
			(vla-ZoomExtents (vlax-get-acad-object))
		)
	)
)
;
;
;
(defun OutputSearch02 (LstFoundSearch LayoutName / Pos MaxCopyColumn MarginX MarginY Scale Num MaxH Sheet EnameRule EnameBlock DimSheet
													Width Height Center LstVpEname view)
	
	(SetupLayout)
	(if (and LstFoundSearch LayoutName)
		(progn
			(SetupLayout)
			(NewLayout    		LayoutName)
			(DeleteObjectLayout LayoutName)
			(ChangeLayout 		LayoutName)
			(gc)
			
			(setq Pos 			(list 0.0 0.0))
			(setq MaxCopyColumn 10)
			(setq Scale 		0.1) ; 1:10
			(setq MarginX 		(* 800.0  Scale))
			(setq MarginY 		(* 1500.0 Scale))

			(setq Num 			 1)
			(setq MaxH 			 0)

			(StartProgressBar    "OutputSearch"   (length LstFoundSearch))

			(foreach Sheet LstFoundSearch

				(UpDateProgressBar)

				;(setq EnameRule  (GetEnameRuleByEnameSheet (car Sheet)))
				(setq EnameBlock (GetEnameBlockSheetById   (GetIdSheet (car Sheet))))
				:(setq DimSheet   (LM:SSBoundingBox (LstEname->Ssget (list EnameRule EnameBlock (car Sheet)))))
				(setq DimSheet   (LM:SSBoundingBox (LstEname->Ssget (list EnameBlock (car Sheet)))))
				
				(setq Width  (* (abs (- (car (car DimSheet))    (car (cadr DimSheet))))  Scale))
				(setq Height (* (abs (- (cadr (caddr DimSheet)) (cadr (cadr DimSheet))))  Scale))
				
				(setq Center (list (+ (car Pos) (/ Width 2.0)) (+ (cadr Pos) (/ Height 2.0))))
				(setq LstVpEname (append LstVpEname (list (CreateViewPort Center Width Height Scale))))
				(MakeViewSheet (car Sheet))
				(setq MaxH (max MaxH Height))
				(setq Num (1+ Num))
				
				(if (= (- Num 1) MaxCopyColumn)
					(progn
						(setq Pos (list 0.0 (+ (cadr Pos) MaxH MarginY)))
						(setq Num 1)
						(setq MaxH 0)
					)
					(setq Pos (list (+ (car Pos) Width MarginX) (cadr Pos)))
				)
			)
			(ClearProgressBar)
			;
			
			(vla-ZoomExtents (vlax-get-acad-object))
			(StartProgressBar    "OutputSearch2"   (length LstFoundSearch))
			(setq Num 0)
			(foreach Sheet LstFoundSearch
				(UpDateProgressBar)
				(setq view (tblsearch "view" (GetIdSheet (car Sheet))))
				(setview view (cdr (assoc 69 (entget (nth Num LstVpEname)))))
				(DeleteViews (GetIdSheet (car Sheet)))
				(vla-put-visible (vlax-ename->vla-object (nth Num LstVpEname))       :vlax-false) 
				(vla-put-displaylocked (vlax-ename->vla-object (nth Num LstVpEname)) :vlax-true)
				(redraw (nth Num LstVpEname) 1)
				(setq Num (1+ Num))
			)
			;(vla-Regen (vla-get-activedocument (vlax-get-acad-object)) acAllViewports)
			(ClearProgressBar)
		)
	)
)
;
;
;
(defun OutputSearch03 (LstFoundSearch LayoutName / Pos MaxCopyColumn MarginX MarginY Scale Num MaxH Sheet EnameBlock DimSheet
												   Width Height Center LstVpEname view)
	
	(SetupLayout)
	(if (and LstFoundSearch LayoutName)
		(progn
			(SetupLayout)
			(DeleteLayout       LayoutName)
			(NewLayout    		LayoutName)
			;(DeleteObjectLayout LayoutName)
			(ChangeLayout 		LayoutName)
			(exit)
			;(gc)
			;(ClearProgressBar)
		)
	)
)
;
;
