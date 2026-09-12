;
; Variabili globali
;
;(setq $MargineAccosto 5.0)			; margine accosto contorno
;(setq $LgSegEntra 25.0)			; lunghezza attacco rettilineo in entrata
;(setq $LgSegEsci  30.0)			; lunghezza attatto rettilineo in uscita
;(setq $SvArcEntra 15.0)			; lunghezza attacco circolare in entrata
;(setq $SvArcEsci  20.0)			; lunghezza attacco circolare in uscita
;(setq $RaggioEntra 10.0)			; raggio attacco circolare in entrata
;(setq $RaggioEsci 8.0) 			; raggio attacco circolare in uscita
;(setq $ColorEntra 60)				; colore attacco in entrata
;(setq $ColorEsci 140)		    	; colore attacco in uscita
;
;
;
;
(defun RemoveTriggerByEnameShape (EnameShape)
	(DeleteEntity (GetEnameTriggerByEnameShape EnameShape))
)
;
;
(defun DeleteTrigger(/ Sselect)
	;(setq Sselect (ssget (list (list -3 (list (strcat $RgpShape "," $RgpTiggerOn "," $RgpTiggerOff))))))
	(if (setq Sselect (ssget (list (list -3 (list (strcat $RgpTiggerOn "," $RgpTiggerOff))))))
		(DeleteSsel Sselect)
	)
	;(DeleteTrigger Sselect)
	Sselect
)
;
;
;
(defun SheetTrigger (/ Ssel EnameSheet)

	(prompt "\nSelezionare la lamiera")
	(setq Ssel (ssget "_+.:E:S" (list (list -3 (list (strcat $RgpSheet "," $RgpSheetTarget))))))
	(if Ssel	
		(progn
			(setq EnameSheet (GetEnameSheetByDummyEname (ssname Ssel 0)))
			(AutoTriggerSheet EnameSheet)
		)
		(alert "Lamiera non riconosciuta")
	)
)
;
;
;
(defun CheckTriggerOnList (EnameShape LstCheck / Rtn IdShape Check)

	(if EnameShape
		(if LstCheck
			(progn
				(setq IdShape (GetIdShape EnameShape))
				(if (setq Check (assoc IdShape LstCheck))
					(cond
						((and   (nth 1 Check) 
								(null (nth 2 Check)))
							(setq Rtn 2)
						)
						((and 	(null (nth 1 Check)) 
								(nth 2 Check))
							(setq Rtn 3)
						)
						((and 	(nth 1 Check)
								(nth 2 Check))
							(setq Rtn 4)
						)
					)
					(setq Rtn 1)
				)
			)
			(setq Rtn 1)
		)
	)
	Rtn
)
;
;
;
(defun CheckTrigger (EnameShape / Rtn IdShape EnameTrigger)
	
	;
	;
	; Rtn 	1 attacco in entrata assente  / attacco in uscita assente
	;		2 attacco in entrata presente / attacco in uscita assente
	;		3 attacco in entrata assente  / attacco in uscita presente
	;		4 attacco in entrata presente / attacco in uscita presente
	;
	(if EnameShape
		(progn
			(setq EnameTrigger  (GetEnameTriggerByEnameShape EnameShape))
			;(setq IdShape 		(GetIdShape EnameShape))
			;(setq EnameTrigger 	(GetEnameTriggerByIdShape IdShape))
			(if (listp EnameTrigger)
				(progn
					(cond
						((and (null (nth 0 EnameTrigger)) 
							  (null (nth 1 EnameTrigger)))
							(setq Rtn 1)
						)
						((and       (nth 0 EnameTrigger) 
							  (null (nth 1 EnameTrigger)))
							(setq Rtn 2)
						)
						((and (null (nth 0 EnameTrigger)) 
							        (nth 1 EnameTrigger))
							(setq Rtn 3)
						)
						((and (nth 0 EnameTrigger)
							  (nth 1 EnameTrigger))
							(setq Rtn 4)
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
(defun AutoTriggerSheet (EnameSheet / Num CheckZoom Sheet Ssel LstCheckTrigger LstEnameOutShape LstEnameInShape itm)


	(if EnameSheet
		(progn
			(setq Num 0)
			(setq CheckZoom 		(VisibleEname EnameSheet))
			;(setq Sheet 			(DiscretizeShape EnameSheet))
			(setq Sheet 			(DiscretizeShapeNoControl EnameSheet))
			;(setq Ssel  			(ssget "_CP" Sheet (GetDataSelectWithFilterSetup)))
			(setq Ssel  			(SsgetWithFilterSetup "_CP" Sheet (GetDataSelectWithFilterSetup)))
			(setq LstCheckTrigger   (GetLstIdShapeWithEnameTriggerOnSheet EnameSheet))
			(if Ssel
				(progn
					(repeat (sslength Ssel)
						(if (= (GetTypShape (ssname Ssel Num)) "CE")
							(setq LstEnameOutShape (append LstEnameOutShape (list (ssname Ssel Num))))
							(setq LstEnameInShape  (append LstEnameInShape  (list (ssname Ssel Num))))
						)
						(setq Num (1+ Num))
					)
					

					(StartProgressBar "Attacchi Controno Esterno :" (length LstEnameOutShape))
					(setq Num 1)
					(foreach itm LstEnameOutShape
						(UpDateProgressBar)
						(if (= (CheckTriggerOnList itm LstCheckTrigger) 1)
							(progn
								(ZoomEname itm 100.0)
								(MakeAutoTriggerExternalShape itm)
							)
						)
						(setq Num (1+ Num))
					)
					(ClearProgressBar)
					

					(StartProgressBar "Attacchi Controno Interno :" (length LstEnameInShape))
					(setq Num 1)
					(foreach itm LstEnameInShape
						(UpDateProgressBar)
						(if (= (CheckTriggerOnList itm LstCheckTrigger) 1)
							(progn
								(ZoomEname itm 100.0)
								(MakeAutoTriggerInternalShape itm)
							)
						)
						(setq Num (1+ Num))
					)
					(ClearProgressBar)
				)
			)
			(ZoomPrevius CheckZoom)
		)
	)
)
;
;
;
(defun AutoTrigger (/ EnameShape Rtn)
	(setvar "pickstyle" 0)
	(setq EnameShape (entsel "\nContorno "))
	(if EnameShape
		(if (CheckIfEasyCutShape (car EnameShape))
			(progn
				(setq Rtn T)
				(MakeAutoTrigger (car EnameShape))
				(setq Rtn nil)
			)
			(alert "Non e' un contorno")
		)
	)
	Rtn
)
;
;
;
(defun MakeAutoTrigger (EnameShape / ExternalShape InternalShape RtnZoom itm)

	;(princ "\n --->") (princ Rtn) (princ "<---")
	
	(if EnameShape
		(progn
			(setq ExternalShape (GetEnameShapeByDummyEnameSelect 		 EnameShape))
			(setq InternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
			(setq RtnZoom (VisibleEname ExternalShape))
			
			(if (= (CheckTrigger ExternalShape) 1)
				(progn
					(ZoomEname ExternalShape 30.0)
					(MakeAutoTriggerExternalShape ExternalShape)
				)
			)
			
			(foreach itm InternalShape
				(if (= (CheckTrigger itm) 1)
					(progn
						(ZoomEname itm 30.0)
						(MakeAutoTriggerInternalShape itm)
					)
				)
			)
				
			(ZoomPrevius RtnZoom)
		)
	)
)
;
;
;
(defun CheckInCut (EnameInternalShape / itm mind maxd dia Rtn)
		
	;
	;
	;	
	(defun GetRadiusLwPolyline (Ename / LstCoord conta ContaBlg p1 p2 Blg CenterPoint itm1 itm2 Rtn Next)
		
		(if Ename
			(progn
			
				(setq Rtn (nth 0 (CheckPoly Ename)))
				; Rtn 	-1 	non è una polilinea
				;		 0	polylinea aperta
				;		 1	polylinea con vertici duplicati
				;		 2	polylinea anti oraria
				;		 3	polylinea oraria
				;		 4	polylinea 1° e ultimo vertice coincidente 
				
				(cond
					((= Rtn -1)
						(setq Next nil)
					)
					((= Rtn 0)
						(setq Next nil)
					)
					((= Rtn 1)
						(setq Next nil)
					)
					((= Rtn 2)
						(setq Next T)
						(setq LstCoord (LM:lwvertices (entget Ename)))
						(setq LstCoord (append LstCoord (list (nth 0 LstCoord))))
					)
					((= Rtn 3)
						(setq Next T)
						(setq LstCoord (LM:lwvertices (entget Ename)))
						(setq LstCoord (append LstCoord (list (nth 0 LstCoord))))
					)
					((= Rtn 4)
						(setq Next T)
						(setq LstCoord (LM:lwvertices (entget Ename)))
					)
					(t (setq Next nil))
				)
					
						
				(if Next
					(progn
						(setq conta 0)
						(setq ContaBlg 0)
				
						(repeat (- (length LstCoord) 1)
							(setq p1   (cdr (assoc 10 (nth (+ 0 conta) LstCoord))))
							(setq p2   (cdr (assoc 10 (nth (+ 1 conta) LstCoord))))
							(setq Blg  (cdr (assoc 42 (nth (+ 0 conta) LstCoord))))
					
							(if (= Blg 0.0) 
								(setq ContaBlg (1+ ContaBlg))
								(setq CenterPoint (append CenterPoint (list (LM:bulgecentre p1 p2 Blg))))
							)
					
							(setq conta (1+ conta))
						)
						(if (> ContaBlg 1)
							(setq Rtn nil)
							(progn
								(setq Rtn T)
								(foreach itm1 CenterPoint
									(foreach itm2 CenterPoint
										(if (null (MyEqualPoint itm1 itm2 0.01))
											(setq Rtn nil)
										)
									)
								)
								(if Rtn
									(setq Rtn (distance p1 (nth 0 CenterPoint)))
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
	(if EnameInternalShape
		(progn
			(setq Rtn T)
			(foreach itm $CutOffarray
				(if (= (caddr itm) 1)
					(progn
						(setq mind (car itm)
							  maxd (cadr itm)
							  dia nil
						)
						
						(cond 
							((= (cdr (assoc 0 (entget EnameInternalShape))) "CIRCLE")
								(setq dia (* 2.0 (vla-get-Radius (vlax-ename->vla-object EnameInternalShape))))
							)
							((= (cdr (assoc 0 (entget EnameInternalShape))) "LWPOLYLINE")
								(if (setq Radius (GetRadiusLwPolyline EnameInternalShape))
									(setq dia (* 2.0 Radius))
								)
							)
							(t nil)
						)
						
						(if dia
							(if (and (>= dia mind) (<= dia maxd)) (setq Rtn nil))
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
(defun ChangePointOfContactTrigger (EnameTrigger Pstart Pend)
	
	(if (and EnameTrigger Pstart Pend)
		(cond 
			((= (cdr (assoc 0 (entget EnameTrigger))) "ARC")
				(ChangeArc2P EnameTrigger PStart Pend)
			)
			((= (cdr (assoc 0 (entget EnameTrigger))) "LINE")
				(ChangeLine2P EnameTrigger PStart Pend)
			)
		)
	)
)
;
;
;
(defun MakeAutoTriggerExternalShape (EnameExternalShape / PointOnSet)
	
	(if EnameExternalShape
		(progn
			(setq PointOnSet (vlax-curve-getPointAtParam (vlax-ename->vla-object EnameExternalShape) 0.5))
			(PointTriggerInOutLineOnOff3 EnameExternalShape PointOnSet)
		)
	)
)
;
;
;
(defun MakeAutoTriggerInternalShape (EnameInternalShape / Center PointOnSet)

	(if EnameInternalShape
		(if (CheckInCut EnameInternalShape)
			(progn
				(cond 
					((= (cdr (assoc 0 (entget EnameInternalShape))) "CIRCLE")
						(setq Center     (vlax-get (vlax-ename->vla-object EnameInternalShape) 'center))
						(setq PointOnSet (list (+ (car Center) (vlax-get (vlax-ename->vla-object EnameInternalShape) 'radius)) (cadr Center)))
					)
					((= (cdr (assoc 0 (entget EnameInternalShape))) "LWPOLYLINE")
						(setq PointOnSet (vlax-curve-getPointAtParam (vlax-ename->vla-object EnameInternalShape) 0.5))
					)
				)
				(PointTriggerInOutLineOnOff3 EnameInternalShape PointOnSet)
			)
		)
	)
)
;
;
;
(defun ManualTrigger (/ *error* MyEntsel
						SaveOsmode PtTrigger EnameShape TypTrigger LstTrigger)

	(defun *error* (msg)
		(setvar 'osmode SaveOsmode)
	)
	;
	(defun MyEntsel (PtPoint / Aperture LstEname)
	
		(setq Aperture 0.5)
		(setq LstEname (LM:ss->ent (ssget "_C" (list (- (car  PtPoint) (/ Aperture 2.0))
										 			 (- (cadr PtPoint) (/ Aperture 2.0)))
											   (list (+ (car  PtPoint) (/ Aperture 2.0))
													 (+ (cadr PtPoint) (/ Aperture 2.0)))
											   (list (cons 67 0) (list -3 (list $RgpShape)))
								    )))
		(if (= (length LstEname) 1)
			(car LstEname)
			nil
		)
	)
	;
	(setvar "pickstyle" 0)	
	(setq SaveOsmode (getvar 'osmode))
	(setvar 'osmode 561) ; Endpoint / Midpoint / Quadrant / Nearest
	
	(if (setq PtTrigger (trans (getpoint  "\nPunto attacco") 1 0))
		(if (setq EnameShape (MyEntsel PtTrigger))
			(progn
				(initget 1 "1 2 3")
				(setq TypTrigger (getkword "\n\nTipo attacco [1] Rettilineo / [2] Arco Tangente] / [3] Perpendicolare]"))
			)
			(alert "Puntare un contorno")
		)
	)
	(setvar 'osmode SaveOsmode)
	(if TypTrigger
		(if (CheckIfEasyCutShape EnameShape)
			(progn
				(setq LstTrigger (GetEnameTriggerByEnameShape EnameShape))
				(if (MakeManualTrigger EnameShape PtTrigger (atoi TypTrigger) (GetTypeShape EnameShape) 1)
					(DeleteEntity LstTrigger)
				)
			)
		)
	)
)
;
;
;
(defun MakeManualTrigger(EnameShape PtTrigger TypTrigger TypeShape Verbose / LstTrigger Rtn)

	(if (and EnameShape PtTrigger TypTrigger)
		(cond
			((= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE")
				(cond 
					((= TypeShape 1) 							; 1  è un controno esterno
						(setq LstTrigger (StartTrigger_OutLine TypTrigger EnameShape PtTrigger Verbose))
					) 
					((= TypeShape 2) 							; 2  è un controno interno
						(setq LstTrigger (StartTrigger_InLine  TypTrigger EnameShape PtTrigger Verbose))
					)
				)
			)
			((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
				(cond
					((= TypTrigger 3)
						(setq LstTrigger (PointTriggerInOutLineOnOff3 EnameShape PtTrigger))
					)
					(t 
						(setq LstTrigger (PointTriggerOnCircle TypTrigger EnameShape PtTrigger Verbose))
					)
				)
			)
			((= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE")
				(setq LstTrigger (PointTriggerOnEllipse TypTrigger EnameShape PtTrigger Verbose))
			)
		)
	)
	(if (and (car LstTrigger) (cadr LstTrigger))
		(setq Rtn (list (vlax-vla-object->ename (car LstTrigger)) (vlax-vla-object->ename (cadr LstTrigger))))
		(progn
			(DeleteObject LstTrigger)
			(setq Rtn nil)
		)
	)
)
;
;
;
(defun StartTrigger_OutLine (TypeOnSet EnameShape PointOnSet Verbose / vr CoShp nv InfoShape Pc FinEntra FinEsci ArEntra ArEsci Rtn Pe Pu)
		
		;(setq IdGroup (gnames EnameShape))
		;(if (and TypeOnSet EnameShape PointOnSet Verbose IdGroup)
		(if (and TypeOnSet EnameShape PointOnSet Verbose)
			(progn

				(cond
					((= TypeOnSet 1)
						(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (osnap PointOnSet "_end,_int"))) ; tipo rettilineo
					)
					((= TypeOnSet 2)
						(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (osnap PointOnSet "_near")))	  ; tipo tangente
					)
					((= TypeOnSet 3)
						(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (osnap PointOnSet "_near")))	  ; tipo tangente
					)
				)
				;(if (= TypeOnSet 1)
				;	(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (osnap PointOnSet "_end,_int"))) ; tipo rettilineo
				;	(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (osnap PointOnSet "_near")))	  ; tipo tangente
				;)
				
				(setq CoShp      (LM:lwvertices (entget EnameShape)))
				(setq nv		 (length CoShp))
				(setq InfoShape  (CheckPoly EnameShape))
				
				(if (= (fix vr) nv) (setq vr 0))
				
				(setq Pc         (cdr (nth 0 (nth (fix vr) CoShp))))
				(setq ArEntra    (cdr (nth 3 (nth (fix vr) CoShp))))
				
				(cond 
					((= (- nv 1) (fix vr))
						(setq FinEntra  (cdr (nth 0 (nth 0 CoShp))))
						(setq FinEsci   (cdr (nth 0 (nth (fix (1- vr)) CoShp))))
						(setq ArEsci    (cdr (nth 3 (nth (fix (1- vr)) CoShp))))
					)
					((= (fix vr) 0)
						(setq FinEntra  (cdr (nth 0 (nth (fix (1+ vr)) CoShp))))
						(setq FinEsci   (cdr (nth 0 (nth (fix (1- nv)) CoShp))))
						(setq ArEsci    (cdr (nth 3 (nth (fix (1- nv)) CoShp))))
					)	
					(t
						(setq FinEntra  (cdr (nth 0 (nth (fix (1+ vr)) CoShp))))
						(setq FinEsci   (cdr (nth 0 (nth (fix (1- vr)) CoShp))))
						(setq ArEsci    (cdr (nth 3 (nth (fix (1- vr)) CoShp))))
					)
				)
				(if (= Verbose 1)
					(progn
						(princ "\n**************************************************************")
						(princ "\nParam              :") (princ vr)
						(princ "\nContorno           :Esterno") 
						(princ "\nNumero Vertici     :") (princ nv)
						(princ "\nCoord Entra        :") (princ Pc) (princ ArEntra) (princ FinEntra)
						(princ "\nCoord Esci         :") (princ Pc) (princ ArEsci)  (princ FinEsci)
						(princ "\nPercorrenza        :") (princ (nth 0 InfoShape))
						(princ "\n**************************************************************")
					)
				)
				;
				; grafica attacchi coincidenti
				;
				(cond	
					((= TypeOnSet 1) ; attacco tangente rettilineo
						(setq Pe (PointTriggerOn1  EnameShape Pc FinEntra ArEntra))
						; attacco uscita
						(setq Pu (PointTriggerOff1 EnameShape Pc FinEsci  ArEsci))
					)
					((= TypeOnSet 2) ; attacco tangente circolare
						(setq PNear (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape)  PointOnSet))
						(setq Pe (PointTriggerOn2  EnameShape PNear Pc FinEntra ArEntra (nth 0 InfoShape)))
						; attacco uscita
						(setq Pu (PointTriggerOff2 EnameShape PNear Pc FinEntra ArEntra (nth 0 InfoShape)))
					)
					((= TypeOnSet 3) ; attacco perpendicolare rettilineo
						(setq PNear (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape)  PointOnSet))
						(if (setq Rtn (PointTriggerInOutLineOnOff3 EnameShape PNear))
							(progn
								(setq Pe (car Rtn))
								(setq Pu (cadr Rtn))
							)
						)
					)
				)
			)
		)
		(list Pe Pu)
)
;
;
;
(defun StartTrigger_InLine (TypeOnSet EnameShape PointOnSet Verbose / vr CoShp nv InfoShape Pc FinEntra FinEsci ArEntra ArEsci Rtn Pe Pu)

		;(setq IdGroup (gnames EnameShape))
		;(if (and TypeOnSet EnameShape PointOnSet Verbose IdGroup)
		(if (and TypeOnSet EnameShape PointOnSet Verbose)
			(progn
			
				(cond
					((= TypeOnSet 1)
						(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (osnap PointOnSet "_end,_int"))) ; tipo rettilineo
					)
					((= TypeOnSet 2)
						(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (osnap PointOnSet "_near")))	  ; tipo tangente
					)
					((= TypeOnSet 3)
						(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (osnap PointOnSet "_near")))	  ; tipo tangente
					)
				)
				
				(setq CoShp      (LM:lwvertices (entget EnameShape)))
				(setq nv		 (length CoShp))
				(setq InfoShape  (CheckPoly EnameShape))
				
				(if (= (fix vr) nv) (setq vr 0))
				
				(setq Pc         (cdr (nth 0 (nth (fix vr) CoShp))))
				(setq ArEntra    (cdr (nth 3 (nth (fix vr) CoShp))))
				
				(cond 
					((= (- nv 1) (fix vr))
						(setq FinEntra  (cdr (nth 0 (nth 0 CoShp))))
						(setq FinEsci   (cdr (nth 0 (nth (fix (1- vr)) CoShp))))
						(setq ArEsci    (cdr (nth 3 (nth (fix (1- vr)) CoShp))))
					)
					((= (fix vr) 0)
						(setq FinEntra  (cdr (nth 0 (nth (fix (1+ vr)) CoShp))))
						(setq FinEsci   (cdr (nth 0 (nth (fix (1- nv)) CoShp))))
						(setq ArEsci    (cdr (nth 3 (nth (fix (1- nv)) CoShp))))
					)	
					(t
						(setq FinEntra  (cdr (nth 0 (nth (fix (1+ vr)) CoShp))))
						(setq FinEsci   (cdr (nth 0 (nth (fix (1- vr)) CoShp))))
						(setq ArEsci    (cdr (nth 3 (nth (fix (1- vr)) CoShp))))
					)
				)
				(if (= Verbose 1)
					(progn
						(princ "\n**************************************************************")
						(princ "\nParam              :") (princ vr)
						(princ "\nContorno           :Interno") 
						(princ "\nNumero Vertici     :") (princ nv)
						(princ "\nCoord Entra        :") (princ Pc) (princ ArEntra) (princ FinEntra)
						(princ "\nCoord Esci         :") (princ Pc) (princ ArEsci)  (princ FinEsci)
						(princ "\nPercorrenza        :") (princ (nth 0 InfoShape))
						(princ "\n**************************************************************")
					)
				)
				;
				; grafica attacchi coincidenti
				;
				(cond	
					((= TypeOnSet 1) ; attacco tangente rettilineo
						(setq Pe (PointTriggerInLineOn1  EnameShape Pc FinEntra ArEntra))
						(setq Pu (PointTriggerInLineOff1 EnameShape Pc FinEsci   ArEsci))
					)
					((= TypeOnSet 2) ; attacco tangente circolare
						(setq PNear (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape)  PointOnSet))
						(setq Pe (PointTriggerInLineOn2  EnameShape PNear Pc FinEntra ArEntra (nth 0 InfoShape)))
						(setq Pu (PointTriggerInLineOff2 EnameShape PNear Pc FinEntra ArEntra (nth 0 InfoShape)))
					)
					((= TypeOnSet 3) ; attacco perpendicolare rettilineo
						(setq PNear (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape)  PointOnSet))
						(if (setq Rtn (PointTriggerInOutLineOnOff3 EnameShape PointOnSet))
							(progn
								(setq Pe (car Rtn))
								(setq Pu (cadr Rtn))
							)
						)
					)
				)
			)
		)
		
	(list Pe Pu)
)
;
;
; Attacchi contorno esterno
;
;
(defun PointTriggerOn1 (EnameShape Pstart Pdir Bulge / p1 px ModelSpace ObLine LgSeg ColorEntra ObArc IdShape xd_list nuova_entita IdGroup)

		; punto di attacco tangente rettilineo
		
		
		(setq LgSeg $LgSegEntra)			; lunghezza attacco rettilineo in entrata
		(setq ColorEntra $ColorEntra)		; colore attacco circolare in entrata
		
		(if (= Bulge 0.0) 		; <-- retta
			(setq p1 (prol (nth 0 Pdir) (nth 1 Pdir) (nth 0 Pstart) (nth 1 Pstart) LgSeg))
			(progn			 	; <-- arco
				(setq px (LM:bulgecentre PStart Pdir Bulge))
				(if (> Bulge 0) (setq LgSeg (* LgSeg -1.0)))
				(setq p1 (per (nth 0 px) (nth 1 px) (nth 0 Pstart) (nth 1 Pstart) LgSeg))
			)
		)
		;
		; controllo se il punto di attacco è all'interno della sagoma di taglio
		;
		(if (not (LM:PointInside-p p1 (vlax-ename->vla-object EnameShape) nil))
			(progn
				
				(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObLine (vla-AddLine modelSpace (vlax-3d-point p1) (vlax-3d-point Pstart)))
				
				
				; aggancio le entità estese 
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObLine ColorEntra)
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 "*") xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOn xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObLine)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObLine))				
						
						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLine))
					)
				)
			)
		)
		ObLine
)
;
;
;
(defun PointTriggerOn2 (EnameShape PNear Pstart Pdir Bulge Journey / LgSeg RgSeg ColorEntra rad px ang AIniEn AFinEn ModelSpace ObArc Pcrlt segno IdGroup)


		;
		;	inserimento attacco arco tangente circolare
		;
		;	PNear	= punto di attacco
		;	Pstart	= punto inizio arco
		;	Pdir	= punto fine arco
		;	Bulge	= bulge
		;	Journey	= percorrenza
		
		
		(setq LgSeg $SvArcEntra)			; lunghezza attacco circolare in entrata
		(setq RgSeg $RaggioEntra)			; raggio attacco circolare in entrata
		(setq ColorEntra $ColorEntra)		; colore attacco circolare in entrata
		
		(setq rad (/ LgSeg RgSeg))			; radianti sviluppo
		
		(if (/= bulge 0.0)
			(setq px (LM:bulgecentre PStart Pdir Bulge))
		)
		
		(cond 
			((= Journey 2) ; percorrenza antioraria
				(cond 
					((> Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
					((< Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
					((= Bulge 0.0)
						(setq p1 (per (nth 0 PStart) (nth 1 PStart) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear)))
				(setq AIniEn ang)
				(setq AFinEn (+ ang rad))
				(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear) rad))
			)
			((= Journey 3) ; percorrenza oraria
				(cond 
					((> Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
					((< Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
					((= Bulge 0.0)
						(setq p1 (per (nth 0 PStart) (nth 1 PStart) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear)))
				(setq AIniEn (- ang rad))
				(setq AFinEn ang)
				(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear) (* rad -1.0)))
			)
		)
		;
		; controllo se il punto di attacco è all'interno della sagoma di taglio
		;
		(if (not (LM:PointInside-p Pcrlt (vlax-ename->vla-object EnameShape) nil))
			(progn
				(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObArc 	 (vla-addarc ModelSpace (vlax-3d-point p1) RgSeg AIniEn AFinEn)) 
				

				; aggancio le entità estese 
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObArc ColorEntra)
						(if (= Journey 2) (setq segno "-"))	; percorrenza antioraria
						(if (= Journey 3) (setq segno "+"))	; percorrenza oraria
					
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 segno) xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOn xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObArc)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObArc))				

						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObArc))
					)
				)
			)
		)
		ObArc
)
;
;
;
(defun PointTriggerOff1 (EnameShape Pstart Pdir Bulge / p1 px ModelSpace ObLine LgSeg ColorEsci)
			
		; punto di attacco tangente rettilineo				
		
		(setq LgSeg $LgSegEsci)			; lunghezza attacco rettilineo in uscita
		(setq ColorEsci $ColorEsci)		; colore attacco rettilineo in uscita
		
		(if (= Bulge 0.0) 		; <-- retta
			(setq p1 (prol (nth 0 Pdir) (nth 1 Pdir) (nth 0 PStart) (nth 1 Pstart) LgSeg))
			(progn 				; <-- arco
				(setq px (LM:bulgecentre Pdir Pstart Bulge))
				(if (< Bulge 0) (setq LgSeg (* LgSeg -1.0)))
				(setq p1 (per (nth 0 px) (nth 1 px) (nth 0 Pstart) (nth 1 Pstart) LgSeg))
			)
		)
		(if (not (LM:PointInside-p p1 (vlax-ename->vla-object EnameShape) nil))
			(progn
				(setq modelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObLine (vla-AddLine modelSpace (vlax-3d-point Pstart) (vlax-3d-point p1)))
				

				; aggancio le entità estese 
				
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObLine ColorEsci)
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 "*") xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOff xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObLine)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObLine))
				
						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLine))
					)
				)
			)
		)
		ObLine
)
;
;
;
(defun PointTriggerOff2 (EnameShape PNear Pstart Pdir Bulge Journey / LgSeg RgSeg ColorEntra rad px ang AIniEs AFinEs ModelSpace ObArc Pcrlt segno IdGroup)


		;
		;	inserimento attacco arco tangente circolare
		;
		;	PNear	= punto di attacco
		;	Pstart	= punto inizio arco
		;	Pdir	= punto fine arco
		;	Bulge	= bulge
		;	Journey	= percorrenza
		
		
		(setq LgSeg $SvArcEsci)			; lunghezza attacco circolare in uscita
		(setq RgSeg $RaggioEsci)		; raggio attacco circolare in uscita
		(setq ColorEsci $ColorEsci)		; colore attacco circolare in uscita
		
		(setq rad (/ LgSeg RgSeg))		; radianti sviluppo
		(if (/= bulge 0.0)
			(setq px (LM:bulgecentre PStart Pdir Bulge))
		)
		
		(cond 
			((= Journey 2) ; percorrenza antioraria
			
				(cond 
					((> Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
					((< Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
					((= Bulge 0.0)
						(setq p1 (per (nth 0 PStart) (nth 1 PStart) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear)))
				(setq AIniES (- ang rad))
				(setq AFinES ang)
				(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear) (* rad -1.0)))
			)
			((= Journey 3) ; percorrenza oraria
			
				(cond 
					((> Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
					((< Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
					((= Bulge 0.0)
						(setq p1 (per (nth 0 PStart) (nth 1 PStart) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear)))
				(setq AIniES ang)
				(setq AFinES (+ ang rad))
				(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear) rad))
			)
		)
		(if (not (LM:PointInside-p Pcrlt (vlax-ename->vla-object EnameShape) nil))
			(progn
				(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObArc 	 (vla-addarc ModelSpace (vlax-3d-point p1) RgSeg AIniEs AFinEs))
				

				; aggancio le entità estese 
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObArc ColorEsci)
						(if (= Journey 2) (setq segno "-"))	; percorrenza antioraria
						(if (= Journey 3) (setq segno "+"))	; percorrenza oraria
				
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 segno) xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOff xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObArc)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObArc))		

						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObArc))
					)
				)
			)
		)
		ObArc
)
;
;
;
(defun PointTriggerOnCircle (TypeOnSet EnameShape PointOnSet Verbose / PointOnTriggerOnArc PoinyOnTriggerOffArc PointOnTriggerOnSeg PointOnTriggerOffSeg
																	   DataInfo CenterPoint Radius PointOnCircle 
																	   EnameTriggerIn EnameTriggerOut )
	;
	;
	;
	(defun PointOnTriggerOnArc  (EnameShape PStart Journey TypeContour / LgSeg RgSeg Color rad RgbTrg CenterPoint p1 ang AIni AFin Pcrlt
																		 ModelSpace ObArc IdShape IdGroup segno xd_list nuova_entita CheckPoint GoOn)

		(if (and EnameShape PStart Journey TypeContour)
		
			(progn
				(setq LgSeg $SvArcEntra)			; lunghezza attacco circolare in entrata
				(setq RgSeg $RaggioEntra)			; raggio attacco circolare in entrata
				(setq Color $ColorEntra)			; colore attacco circolare in entrata
				(setq rad (/ LgSeg RgSeg))			; radianti sviluppo
				(setq RgbTrg $RgpTiggerOn)			; raggruppamento attacco in entrata
				
				(setq CenterPoint  (vlax-safearray->list (vlax-variant-value (vla-get-center (vlax-ename->vla-object EnameShape)))))

				(cond 
					((= TypeContour "CE")
						(setq p1  (prol (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 PStart) (nth 1 PStart) RgSeg))
					)
					((= TypeContour "CI")
						(setq p1  (prol (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 PStart) (nth 1 PStart) (- 0.0 RgSeg)))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart)))
				(cond
					((= Journey "3") 		; percorrenza oraria  
						(setq AIni ang)
						(setq AFin (+ ang rad))
						(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart) rad))								
					)
					((= Journey "2")		; percorrenza antioraria
						(setq AIni (- ang rad))
						(setq AFin ang)
						(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart) (* rad -1.0)))
					)
				)
				;
				; controllo se il punto di attacco è all'interno della sagoma di taglio
				;
				;(setq CheckPoint (LM:PointInside-p Pcrlt (vlax-ename->vla-object EnameShape) nil))
				
				(if (> (distance CenterPoint Pcrlt) (vla-get-radius (vlax-ename->vla-object EnameShape)))
					(setq CheckPoint nil)
					(setq CheckPoint T)
				)
					
				
				(cond 
					((= TypeContour "CE")
						(if (null CheckPoint)
							(setq GoOn T)
						)
					)
					((= TypeContour "CI")
						(if CheckPoint
							(setq GoOn T)							
						)
					)
				)
				(if GoOn
					(progn
						(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
						(setq ObArc 	 (vla-addarc ModelSpace (vlax-3d-point p1) RgSeg AIni AFin)) 
						

						; aggancio le entità estese 
						(if (setq IdShape (GetIdShape EnameShape))
							(progn
								(vla-put-Color   ObArc Color)
								(if (= Journey "2") (setq segno "+"))	; percorrenza antioraria
								(if (= Journey "3") (setq segno "-"))	; percorrenza oraria
								
								(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 segno) xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons RgbTrg xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObArc)) (list xd_list))
								)
								(entmod nuova_entita)
								(entupd (vlax-vla-object->ename ObArc))				

								; assegno il gruppo 
								(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObArc))
							)
						)
					)
				)
			)
		)
		ObArc
	)
	;
	;
	;
	(defun PointOnTriggerOffArc (EnameShape PStart Journey TypeContour / LgSeg RgSeg Color rad RgbTrg CenterPoint p1 ang AIni AFin Pcrlt
																		 ModelSpace ObArc segno IdShape IdGroup xd_list nuova_entita CheckPoint GoOn)
	
		(if (and EnameShape PStart Journey TypeContour)
			(progn
				(setq LgSeg $SvArcEsci)			; lunghezza attacco circolare in uscita
				(setq RgSeg $RaggioEsci)		; raggio attacco circolare in uscita
				(setq Color $ColorEsci)			; colore attacco circolare in uscita
				(setq rad (/ LgSeg RgSeg))		; radianti sviluppo
				(setq RgbTrg $RgpTiggerOff)		; raggruppamento attacco in uscita
				
				(setq CenterPoint  (vlax-safearray->list (vlax-variant-value (vla-get-center (vlax-ename->vla-object EnameShape)))))

				(cond 
					((= TypeContour "CE")
						(setq p1  (prol (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 PStart) (nth 1 PStart) RgSeg))
					)
					((= TypeContour "CI")
						(setq p1  (prol (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 PStart) (nth 1 PStart) (- 0.0 RgSeg)))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart)))
				(cond 
					((= Journey "3") ; percorrenza oraria
						(setq AIni (- ang rad))
						(setq AFin ang)
						(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart) (* rad -1.0)))
					)
					((= Journey "2") ; percorrenza antioraria
						(setq AIni ang)
						(setq AFin (+ ang rad))
						(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart) rad))
					)
				)
				;
				; controllo se il punto di attacco è all'interno della sagoma di taglio
				;
				;(setq CheckPoint (LM:PointInside-p Pcrlt (vlax-ename->vla-object EnameShape) nil))
				
				(if (> (distance CenterPoint Pcrlt) (vla-get-radius (vlax-ename->vla-object EnameShape)))
					(setq CheckPoint nil)
					(setq CheckPoint T)
				)
				
				
				(cond 
					((= TypeContour "CE")
						(if (null CheckPoint)
							(setq GoOn T)
						)
					)
					((= TypeContour "CI")
						(if CheckPoint
							(setq GoOn T)							
						)
					)
				)
				(if GoOn
					(progn				
						(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
						(setq ObArc 	 (vla-addarc ModelSpace (vlax-3d-point p1) RgSeg AIni AFin))
						

						; aggancio le entità estese 
						(if (setq IdShape (GetIdShape EnameShape))
							(progn
								(vla-put-Color   ObArc Color)
								(if (= Journey "2") (setq segno "+"))	; percorrenza antioraria
								(if (= Journey "3") (setq segno "-"))	; percorrenza oraria
								
								(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 segno) xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons RgbTrg xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObArc)) (list xd_list))
								)
								(entmod nuova_entita)
								(entupd (vlax-vla-object->ename ObArc))		
	
								; assegno il gruppo 
								(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObArc))
							)
						)
					)
				)
			)
		)
		ObArc
	)
	;
	;
	;
	(defun PointOnTriggerOnSeg  (EnameShape Pstart Journey TypeContour / LgSeg Color RgbTrg CenterPoint p1 
																		 ModelSpace ObLine IdShape IdGroup xd_list nuova_entita CheckPoint GoOn)
	
		(if (and EnameShape PStart Journey TypeContour)
			(progn
				(setq LgSeg $LgSegEntra)			; lunghezza attacco rettilineo in entrata
				(setq Color $ColorEntra)			; colore attacco circolare in entrata
				(setq RgbTrg $RgpTiggerOn)			; raggruppamento attacco in entrata
				
				(setq CenterPoint  (vlax-safearray->list (vlax-variant-value (vla-get-center (vlax-ename->vla-object EnameShape)))))
				
				(cond
					((= Journey "2")		; percorrenza antioraria  
						(setq p1  (per (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 Pstart) (nth 1 Pstart) (- 0.0 LgSeg)))						
					)
					((= Journey "3") 		; percorrenza oraria
						(setq p1  (per (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 Pstart) (nth 1 Pstart) LgSeg))
					)
				)
				;
				; controllo se il punto di attacco è all'interno della sagoma di taglio
				;
				(setq CheckPoint (LM:PointInside-p p1 (vlax-ename->vla-object EnameShape) nil))
				(cond 
					((= TypeContour "CE")
						(if (null CheckPoint)
							(setq GoOn T)
						)
					)
					((= TypeContour "CI")
						(if CheckPoint
							(setq GoOn T)							
						)
					)
				)
				(if GoOn
					(progn				
						(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
						(setq ObLine (vla-AddLine modelSpace (vlax-3d-point p1) (vlax-3d-point Pstart)))
						
				
						; aggancio le entità estese 
						(if (setq IdShape (GetIdShape EnameShape))
							(progn
								(vla-put-Color   ObLine Color)
								(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 "*") xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons RgbTrg xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObLine)) (list xd_list))
								)
								(entmod nuova_entita)
								(entupd (vlax-vla-object->ename ObLine))				
								; assegno il gruppo 
								(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLine))
							)
						)
					)
				)
			)
		)
		ObLine
	)
	;
	;
	;
	(defun PointOnTriggerOffSeg (EnameShape PStart Journey TypeContour / LgSeg Color RgbTrg CenterPoint p1 
																		 ModelSpace ObLine IdShape IdGroup xd_list nuova_entita CheckPoint GoOn)
	
		(if (and EnameShape PStart Journey TypeContour)
			(progn
				(setq LgSeg $LgSegEsci)			; lunghezza attacco rettilineo in uscita
				(setq Color $ColorEsci)			; colore attacco circolare in uscita
				(setq RgbTrg $RgpTiggerOff)		; raggruppamento attacco in uscita
				
				(setq CenterPoint  (vlax-safearray->list (vlax-variant-value (vla-get-center (vlax-ename->vla-object EnameShape)))))
				
				(cond
					((= Journey "2")		; percorrenza antioraria  
						(setq p1  (per (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 Pstart) (nth 1 Pstart) LgSeg))					
					)
					((= Journey "3") 		; percorrenza oraria
						(setq p1  (per (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 Pstart) (nth 1 Pstart) (- 0.0 LgSeg)))
					)
				)
				;
				; controllo se il punto di attacco è all'interno della sagoma di taglio
				;
				(setq CheckPoint (LM:PointInside-p p1 (vlax-ename->vla-object EnameShape) nil))
				(cond 
					((= TypeContour "CE")
						(if (null CheckPoint)
							(setq GoOn T)
						)
					)
					((= TypeContour "CI")
						(if CheckPoint
							(setq GoOn T)							
						)
					)
				)
				(if GoOn
					(progn				
						(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
						(setq ObLine (vla-AddLine modelSpace (vlax-3d-point p1) (vlax-3d-point Pstart)))
						
				
						; aggancio le entità estese 
						(if (setq IdShape (GetIdShape EnameShape))
							(progn
								(vla-put-Color   ObLine Color)
								(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 "*") xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons RgbTrg xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObLine)) (list xd_list))
								)
								(entmod nuova_entita)
								(entupd (vlax-vla-object->ename ObLine))				
								; assegno il gruppo 
								(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLine))
							)
						)
					)
				)
			)
		)
		ObLine
	)
	;
	; Main
	;
	(if (and TypeOnSet EnameShape PointOnSet Verbose)
		(progn
			(setq DataInfo 	(GetDataShape EnameShape))
			
						; 0	TypShape   					*  ["CE"] ["CI"]		CE contorno esterno / CI contorno interno
						; 1	IdShape    					*  ["123456789"]		nome contorno -valore string-)
						; 2	JouShape   					*  ["0"] ["2"] ["3"]	percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
						; 3	NameShape  					*  ["PIPPO"]			nome piatto
						; 4	CutComp    					*  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto 2 dx / 3 sx
						; 5	(rtos LenghtCut 2 2)		*  ["100.3"]  			lunghezza taglio
						; 6	(list Extime Intime TotTime)*  ["10 min 5 sec" "2 min 3 sec" "12 min 8 sec"] tempo di taglio
						; 7	ComShape   					*  ["C2018032"]  	 	nome commessa
						; 8	PhaseShape 					*  ["P100"]  	 	    nome fase
						; 9	MatShape   					*  ["S355J0"] 	 	    nome qualita'
						;10	TkShape    					*  ["10"]  	 	        spessore
						;11	DateShape  					*  ["10/11/2018"]  	 	ultima modifica
						
			(if (= Verbose 1)
				(progn
					(princ "\n**************************************************************")
					(princ "\nParam              :") (princ "Circle Contour")
					(princ "\nNumero Vertici     :") (princ "0")
					(princ "\nPercorrenza        :") (princ (nth 2 DataInfo))
					(princ "\nTipo contorno      :") (princ (nth 0 DataInfo))
					(princ "\n**************************************************************")
				)
			)
			
			(setq CenterPoint  (vlax-safearray->list (vlax-variant-value (vla-get-center (vlax-ename->vla-object EnameShape)))))
			(setq Radius (vla-get-radius (vlax-ename->vla-object EnameShape)))
			(setq PointOnCircle (prol (nth 0 PointOnSet) (nth 1 PointOnSet) (nth 0 CenterPoint) (nth 1 CenterPoint) (- 0.0 Radius)))
			

			(cond 
				((= TypeOnSet 1) ;	1 = attacco retilineo tangente
					(if (null (setq EnameTriggerIn  (PointOnTriggerOnSeg  EnameShape PointOnCircle (nth 2 DataInfo) (nth 0 DataInfo))))
						(LM:popup "Errore" "Punto attacco in entrata dentro il contorno" (+ 0 16 4096)))
					(if (null (setq EnameTriggerOut (PointOnTriggerOffSeg EnameShape PointOnCircle (nth 2 DataInfo) (nth 0 DataInfo))))
						(LM:popup "Errore" "Punto attacco in uscita dentro il contorno" (+ 0 16 4096)))
				)
				((= TypeOnSet 2) ;	2 = attacco circolare tangente
					(if (null (setq EnameTriggerIn  (PointOnTriggerOnArc   EnameShape PointOnCircle (nth 2 DataInfo) (nth 0 DataInfo))))
						(LM:popup "Errore" "Punto attacco in entrata dentro il contorno" (+ 0 16 4096)))
					(if (null (setq EnameTriggerOut (PointOnTriggerOffArc  EnameShape PointOnCircle (nth 2 DataInfo) (nth 0 DataInfo))))
						(LM:popup "Errore" "Punto attacco in uscita dentro il contorno" (+ 0 16 4096)))
				)
			)
		)
	)
	(list EnameTriggerIn EnameTriggerOut)
)
;
;
;
(defun PointTriggerOnEllipse (TypeOnSet EnameShape PointOnSet Verbose / PointOnTriggerOnArc PoinyOnTriggerOffArc PointOnTriggerOnSeg PointOnTriggerOffSeg
																	    DataEllipse DataInfo PointOnEllipse
																		EnameTriggerIn EnameTriggerOut)
	;
	;
	;
	(defun PointOnTriggerOnArc  (EnameShape PStart Journey TypeContour / LgSeg RgSeg Color rad RgbTrg CenterPoint p1 ang AIni AFin Pcrlt PtEllipse
																		 ModelSpace ObArc IdShape IdGroup segno xd_list nuova_entita CheckPoint GoOn)

		(if (and EnameShape PStart Journey TypeContour)
		
			(progn
				(setq LgSeg $SvArcEntra)			; lunghezza attacco circolare in entrata
				(setq RgSeg $RaggioEntra)			; raggio attacco circolare in entrata
				(setq Color $ColorEntra)			; colore attacco circolare in entrata
				(setq rad (/ LgSeg RgSeg))			; radianti sviluppo
				(setq RgbTrg $RgpTiggerOn)			; raggruppamento attacco in entrata
				
				(setq PtEllipse (TangentPointEllipse EnameShape PStart))
				(setq CenterPoint (nth 0 PtEllipse))
				(setq PStart      (nth 1 PtEllipse))
				
				(cond 
					((= TypeContour "CE")
						(setq p1  (prol (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 PStart) (nth 1 PStart) RgSeg))
					)
					((= TypeContour "CI")
						(setq p1  (prol (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 PStart) (nth 1 PStart) (- 0.0 RgSeg)))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart)))
				
				
				
				(cond
					((= Journey "3") 		; percorrenza oraria 
						(setq AIni ang)
						(setq AFin (+ ang rad))
						(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart) rad))								
					)
					((= Journey "2")		; percorrenza antioraria
						(setq AIni (- ang rad))
						(setq AFin ang)
						(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart) (* rad -1.0)))
					)
				)
				;
				; controllo se il punto di attacco è all'interno della sagoma di taglio
				;
				(setq CheckPoint (LM:PointInside-p Pcrlt (vlax-ename->vla-object EnameShape) nil))
				(cond 
					((= TypeContour "CE")
						(if (null CheckPoint)
							(setq GoOn T)
						)
					)
					((= TypeContour "CI")
						(if CheckPoint
							(setq GoOn T)							
						)
					)
				)
				(if GoOn
					(progn
						(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
						(setq ObArc 	 (vla-addarc ModelSpace (vlax-3d-point p1) RgSeg AIni AFin)) 
						

						; aggancio le entità estese 
						(if (setq IdShape (GetIdShape EnameShape))
							(progn
								(vla-put-Color   ObArc Color)
								(if (= Journey "2") (setq segno "+"))	; percorrenza antioraria
								(if (= Journey "3") (setq segno "-"))	; percorrenza oraria
								
								(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 segno) xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons RgbTrg xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObArc)) (list xd_list))
								)
								(entmod nuova_entita)
								(entupd (vlax-vla-object->ename ObArc))				

								; assegno il gruppo 
								(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObArc))
							)
						)
					)
				)
			)
		)
		ObArc
	)
	;
	;
	;
	(defun PointOnTriggerOffArc (EnameShape PStart Journey TypeContour / LgSeg RgSeg Color rad RgbTrg CenterPoint p1 ang AIni AFin Pcrlt PtEllipse
																		 ModelSpace ObArc segno IdShape IdGroup xd_list nuova_entita CheckPoint GoOn)
	
		(if (and EnameShape PStart Journey TypeContour)
			(progn
				(setq LgSeg $SvArcEsci)			; lunghezza attacco circolare in uscita
				(setq RgSeg $RaggioEsci)		; raggio attacco circolare in uscita
				(setq Color $ColorEsci)			; colore attacco circolare in uscita
				(setq rad (/ LgSeg RgSeg))		; radianti sviluppo
				(setq RgbTrg $RgpTiggerOff)		; raggruppamento attacco in uscita

				(setq PtEllipse (TangentPointEllipse EnameShape PStart))
				(setq CenterPoint (nth 0 PtEllipse))
				(setq PStart      (nth 1 PtEllipse))
				
				(cond 
					((= TypeContour "CE")
						(setq p1  (prol (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 PStart) (nth 1 PStart) RgSeg))
					)
					((= TypeContour "CI")
						(setq p1  (prol (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 PStart) (nth 1 PStart) (- 0.0 RgSeg)))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart)))
				(cond 
					((= Journey "3") ; percorrenza oraria
						(setq AIni (- ang rad))
						(setq AFin ang)
						(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart) (* rad -1.0)))
					)
					((= Journey "2") ; percorrenza antioraria
						(setq AIni ang)
						(setq AFin (+ ang rad))
						(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PStart) (nth 1 PStart) rad))
					)
				)
				;
				; controllo se il punto di attacco è all'interno della sagoma di taglio
				;
				(setq CheckPoint (LM:PointInside-p Pcrlt (vlax-ename->vla-object EnameShape) nil))
				(cond 
					((= TypeContour "CE")
						(if (null CheckPoint)
							(setq GoOn T)
						)
					)
					((= TypeContour "CI")
						(if CheckPoint
							(setq GoOn T)							
						)
					)
				)
	
				(if GoOn
					(progn				
						(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
						(setq ObArc 	 (vla-addarc ModelSpace (vlax-3d-point p1) RgSeg AIni AFin))
						

						; aggancio le entità estese 
						(if (setq IdShape (GetIdShape EnameShape))
							(progn
								(vla-put-Color   ObArc Color)
								(if (= Journey "2") (setq segno "+"))	; percorrenza antioraria
								(if (= Journey "3") (setq segno "-"))	; percorrenza oraria
				
								(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 segno) xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons RgbTrg xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObArc)) (list xd_list))
								)
								(entmod nuova_entita)
								(entupd (vlax-vla-object->ename ObArc))		

								; assegno il gruppo 
								(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObArc))
							)
						)
					)
				)
			)
		)
		ObArc
	)
	;
	;
	;
	(defun PointOnTriggerOnSeg  (EnameShape Pstart Journey TypeContour / LgSeg Color RgbTrg CenterPoint p1 PtEllipse
																		 ModelSpace ObLine IdShape IdGroup xd_list nuova_entita CheckPoint GoOn)
	
		(if (and EnameShape PStart Journey TypeContour)
			(progn
				(setq LgSeg $LgSegEntra)			; lunghezza attacco rettilineo in entrata
				(setq Color $ColorEntra)			; colore attacco circolare in entrata
				(setq RgbTrg $RgpTiggerOn)			; raggruppamento attacco in entrata
				
				(setq PtEllipse (TangentPointEllipse EnameShape PStart))
				(setq CenterPoint (nth 0 PtEllipse))
				(setq PStart      (nth 1 PtEllipse))
				
				(cond
					((= Journey "2")		; percorrenza antioraria  
						(setq p1  (per (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 Pstart) (nth 1 Pstart) (- 0.0 LgSeg)))						
					)
					((= Journey "3") 		; percorrenza oraria
						(setq p1  (per (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 Pstart) (nth 1 Pstart) LgSeg))
					)
				)
				;
				; controllo se il punto di attacco è all'interno della sagoma di taglio
				;
				(setq CheckPoint (LM:PointInside-p p1 (vlax-ename->vla-object EnameShape) nil))
				(cond 
					((= TypeContour "CE")
						(if (null CheckPoint)
							(setq GoOn T)
						)
					)
					((= TypeContour "CI")
						(if CheckPoint
							(setq GoOn T)							
						)
					)
				)
				(if GoOn
					(progn				
						(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
						(setq ObLine (vla-AddLine modelSpace (vlax-3d-point p1) (vlax-3d-point Pstart)))
						
				
						; aggancio le entità estese 
						(if (setq IdShape (GetIdShape EnameShape))
							(progn
								(vla-put-Color   ObLine Color)
								(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 "*") xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons RgbTrg xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObLine)) (list xd_list))
								)
								(entmod nuova_entita)
								(entupd (vlax-vla-object->ename ObLine))				
								; assegno il gruppo 
								(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLine))
							)
						)
					)
				)
			)
		)
		ObLine
	)
	;
	;
	;
	(defun PointOnTriggerOffSeg (EnameShape PStart Journey TypeContour / LgSeg Color RgbTrg CenterPoint p1 PtEllipse
																		 ModelSpace ObLine IdShape IdGroup xd_list nuova_entita CheckPoint GoOn)
	
		(if (and EnameShape PStart Journey TypeContour)
			(progn
				(setq LgSeg $LgSegEsci)			; lunghezza attacco rettilineo in uscita
				(setq Color $ColorEsci)			; colore attacco circolare in uscita
				(setq RgbTrg $RgpTiggerOff)		; raggruppamento attacco in uscita
				
				(setq PtEllipse (TangentPointEllipse EnameShape PStart))
				(setq CenterPoint (nth 0 PtEllipse))
				(setq PStart      (nth 1 PtEllipse))
								
				(cond
					((= Journey "2")		; percorrenza antioraria  
						(setq p1  (per (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 Pstart) (nth 1 Pstart) LgSeg))					
					)
					((= Journey "3") 		; percorrenza oraria
						(setq p1  (per (nth 0 CenterPoint) (nth 1 CenterPoint) (nth 0 Pstart) (nth 1 Pstart) (- 0.0 LgSeg)))
					)
				)
				;
				; controllo se il punto di attacco è all'interno della sagoma di taglio
				;
				(setq CheckPoint (LM:PointInside-p p1 (vlax-ename->vla-object EnameShape) nil))
				(cond 
					((= TypeContour "CE")
						(if (null CheckPoint)
							(setq GoOn T)
						)
					)
					((= TypeContour "CI")
						(if CheckPoint
							(setq GoOn T)							
						)
					)
				)
				(if GoOn
					(progn				
						(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
						(setq ObLine (vla-AddLine modelSpace (vlax-3d-point p1) (vlax-3d-point Pstart)))
						
				
						; aggancio le entità estese 
						(if (setq IdShape (GetIdShape EnameShape))
							(progn
								(vla-put-Color   ObLine Color)
								(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 "*") xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons RgbTrg xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObLine)) (list xd_list))
								)
								(entmod nuova_entita)
								(entupd (vlax-vla-object->ename ObLine))				
								; assegno il gruppo 
								(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLine))
							)
						)
					)
				)
			)
		)
		ObLine
	)
	;
	; Main
	;
	(if (and TypeOnSet EnameShape PointOnSet Verbose)
		(progn
			(setq DataInfo 	(GetDataShape EnameShape))
			
						; 0	TypShape   					*  ["CE"] ["CI"]		CE contorno esterno / CI contorno interno
						; 1	IdShape    					*  ["123456789"]		nome contorno -valore string-)
						; 2	JouShape   					*  ["0"] ["2"] ["3"]	percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
						; 3	NameShape  					*  ["PIPPO"]			nome piatto
						; 4	CutComp    					*  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto 2 dx / 3 sx
						; 5	(rtos LenghtCut 2 2)		*  ["100.3"]  			lunghezza taglio
						; 6	(list Extime Intime TotTime)*  ["10 min 5 sec" "2 min 3 sec" "12 min 8 sec"] tempo di taglio
						; 7	ComShape   					*  ["C2018032"]  	 	nome commessa
						; 8	PhaseShape 					*  ["P100"]  	 	    nome fase
						; 9	MatShape   					*  ["S355J0"] 	 	    nome qualita'
						;10	TkShape    					*  ["10"]  	 	        spessore
						;11	DateShape  					*  ["10/11/2018"]  	 	ultima modifica

					
			(if (= Verbose 1)
				(progn
					(princ "\n**************************************************************")
					(princ "\nParam              :") (princ "Ellipse Contour")
					(princ "\nNumero Vertici     :") (princ "0")
					(princ "\nPercorrenza        :") (princ (nth 2 DataInfo))
					(princ "\nTipo contorno      :") (princ (nth 0 DataInfo))
					(princ "\n**************************************************************")
				)
			)
						
			(setq DataEllipse (GetDataEllipse EnameShape))
			;   0        1         2        3      4       5           6         7      8        9
			; center majoraxis minoraxis startpt endpt MajorRadius MinorRadius Focus9 PtFocus1 PtFocus2	
			(setq PointOnEllipse (nth 1 (TangentPointEllipse EnameShape PointOnSet)))		
			
			
			(cond 
				((= TypeOnSet 1) ;	1 = attacco retilineo tangente
					(if (null (setq EnameTriggerIn  (PointOnTriggerOnSeg   EnameShape PointOnEllipse (nth 2 DataInfo) (nth 0 DataInfo))))
						(LM:popup "Errore" "Punto attacco in entrata dentro il contorno" (+ 0 16 4096)))
					(if (null (setq EnameTriggerOut (PointOnTriggerOffSeg  EnameShape PointOnEllipse (nth 2 DataInfo) (nth 0 DataInfo))))
						(LM:popup "Errore" "Punto attacco in uscita dentro il contorno" (+ 0 16 4096)))
				)
				((= TypeOnSet 2) ;	2 = attacco circolare tangente
					(if (null (setq EnameTriggerIn  (PointOnTriggerOnArc   EnameShape PointOnEllipse (nth 2 DataInfo) (nth 0 DataInfo))))
						(LM:popup "Errore" "Punto attacco in entrata dentro il contorno" (+ 0 16 4096)))
					(if (null (setq EnameTriggerOut (PointOnTriggerOffArc  EnameShape PointOnEllipse (nth 2 DataInfo) (nth 0 DataInfo))))
						(LM:popup "Errore" "Punto attacco in uscita dentro il contorno" (+ 0 16 4096)))
				)
			)
		)
	)
	(list EnameTriggerIn EnameTriggerOut)
)
;
;
; Attacchi contorno interno 
;
;
(defun PointTriggerInLineOn1 (EnameShape Pstart Pdir Bulge / p1 px ModelSpace ObLine LgSeg ColorEntra ObArc IdGroup)

		; punto di attacco tangente rettilineo
		
		(setq LgSeg $LgSegEntra)			; lunghezza attacco rettilineo in entrata
		(setq ColorEntra $ColorEntra)		; colore attacco circolare in entrata
		
		(if (= Bulge 0.0) 		; <-- retta
			(setq p1 (prol (nth 0 Pdir) (nth 1 Pdir) (nth 0 Pstart) (nth 1 Pstart) LgSeg))
			(progn			 	; <-- arco
				(setq px (LM:bulgecentre PStart Pdir Bulge))
				(if (> Bulge 0) (setq LgSeg (* LgSeg -1.0)))
				(setq p1 (per (nth 0 px) (nth 1 px) (nth 0 Pstart) (nth 1 Pstart) LgSeg))
			)
		)
		;
		; controllo se il punto di attacco è all'interno della sagoma di taglio
		;
		(if (LM:PointInside-p p1 (vlax-ename->vla-object EnameShape) nil)
			(progn
				(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObLine (vla-AddLine modelSpace (vlax-3d-point p1) (vlax-3d-point Pstart)))
				
				
				; aggancio le entità estese 
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObLine ColorEntra)
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 "*") xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOn xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObLine)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObLine))				

						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLine))
				
					)
				)
			)
		)
		ObLine
)
;
;
;
(defun PointTriggerInLineOff1 (EnameShape Pstart Pdir Bulge / p1 px ModelSpace ObLine LgSeg ColorEsci IdGroup)
			
		; punto di attacco tangente rettilineo				
		
		(setq LgSeg $LgSegEsci)			; lunghezza attacco rettilineo in uscita
		(setq ColorEsci $ColorEsci)		; colore attacco rettilineo in uscita
		
		(if (= Bulge 0.0) 		; <-- retta
			(setq p1 (prol (nth 0 Pdir) (nth 1 Pdir) (nth 0 PStart) (nth 1 Pstart) LgSeg))
			(progn 				; <-- arco
				(setq px (LM:bulgecentre Pdir Pstart Bulge))
				(if (< Bulge 0) (setq LgSeg (* LgSeg -1.0)))
				(setq p1 (per (nth 0 px) (nth 1 px) (nth 0 Pstart) (nth 1 Pstart) LgSeg))
			)
		)
		(if (LM:PointInside-p p1 (vlax-ename->vla-object EnameShape) nil)
			(progn
				(setq modelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObLine (vla-AddLine modelSpace  (vlax-3d-point Pstart) (vlax-3d-point p1)))
				

				; aggancio le entità estese 
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObLine ColorEsci)
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 "*") xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOff xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObLine)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObLine))				

						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLine))
					)
				)
			)
		)
		ObLine
)
;
;
;
(defun PointTriggerInLineOn2 (EnameShape PNear Pstart Pdir Bulge Journey / LgSeg RgSeg ColorEntra rad px ang AIniEn AFinEn ModelSpace ObArc Pcrlt segno IdGroup)


		;
		;	inserimento attacco arco tangente circolare
		;
		;	PNear	= punto di attacco
		;	Pstart	= punto inizio arco
		;	Pdir	= punto fine arco
		;	Bulge	= bulge
		;	Journey	= percorrenza
		
		
		(setq LgSeg $SvArcEntra)			; lunghezza attacco circolare in entrata
		(setq RgSeg $RaggioEntra)			; raggio attacco circolare in entrata
		(setq ColorEntra $ColorEntra)		; colore attacco circolare in entrata
		
		(setq rad (/ LgSeg RgSeg))			; radianti sviluppo
		
		(if (/= bulge 0.0)
			(setq px (LM:bulgecentre PStart Pdir Bulge))
		)
		
		(cond 
			((= Journey 2) ; percorrenza antioraria
				(cond 
					((> Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
					((< Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
					((= Bulge 0.0)
						(setq p1 (per (nth 0 PStart) (nth 1 PStart) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear)))
				(setq AIniEn (- ang rad))
				(setq AFinEn ang)
				(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear) (* rad -1.0)))
				
			)
			((= Journey 3) ; percorrenza oraria
				(cond 
					((> Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
					((< Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
					((= Bulge 0.0)
						(setq p1 (per (nth 0 PStart) (nth 1 PStart) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear)))
				(setq AIniEn ang)
				(setq AFinEn (+ ang rad))
				(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear) rad))
			)
		)
		;
		; controllo se il punto di attacco è all'interno della sagoma di taglio
		;
		(if (LM:PointInside-p Pcrlt (vlax-ename->vla-object EnameShape) nil)
			(progn
				(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObArc 	 (vla-addarc ModelSpace (vlax-3d-point p1) RgSeg AIniEn AFinEn)) 
				

				; aggancio le entità estese 
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObArc ColorEntra)
						(if (= Journey 2) (setq segno "+"))	; percorrenza antioraria
						(if (= Journey 3) (setq segno "-"))	; percorrenza oraria
							
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 segno) xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOn xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObArc)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObArc))				
		
						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObArc))
					)
				)
			)
		)
		ObArc
)
;
;
;
(defun PointTriggerInLineOff2 (EnameShape PNear Pstart Pdir Bulge Journey / LgSeg RgSeg ColorEntra rad px ang AIniEs AFinEs ModelSpace ObArc Pcrlt segno IdGroup)


		;
		;	inserimento attacco arco tangente circolare
		;
		;	PNear	= punto di attacco
		;	Pstart	= punto inizio arco
		;	Pdir	= punto fine arco
		;	Bulge	= bulge
		;	Journey	= percorrenza
		
		
		(setq LgSeg $SvArcEsci)			; lunghezza attacco circolare in uscita
		(setq RgSeg $RaggioEsci)		; raggio attacco circolare in uscita
		(setq ColorEsci $ColorEsci)		; colore attacco circolare in uscita
		
		(setq rad (/ LgSeg RgSeg))		; radianti sviluppo
		(if (/= bulge 0.0)
			(setq px (LM:bulgecentre PStart Pdir Bulge))
		)
		
		(cond 
			((= Journey 2) ; percorrenza antioraria
			
				(cond 
					((> Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
					((< Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
					((= Bulge 0.0)
						(setq p1 (per (nth 0 PStart) (nth 1 PStart) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear)))
				(setq AIniES ang)
				(setq AFinES (+ ang rad))
				(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear) rad))
			)
			((= Journey 3) ; percorrenza oraria
			
				(cond 
					((> Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) RgSeg))
					)
					((< Bulge 0.0)
						(setq p1 (prol (nth 0 px) (nth 1 px) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
					((= Bulge 0.0)
						(setq p1 (per (nth 0 PStart) (nth 1 PStart) (nth 0 PNear) (nth 1 PNear) (* RgSeg -1.0)))
					)
				)
				(setq ang (ang_x (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear)))
				(setq AIniES (- ang rad))
				(setq AFinES ang)
				(setq Pcrlt (dca (nth 0 p1) (nth 1 p1) (nth 0 PNear) (nth 1 PNear) (* rad -1.0)))
			)
		)
		(if (LM:PointInside-p Pcrlt (vlax-ename->vla-object EnameShape) nil)
			(progn
				(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObArc 	 (vla-addarc ModelSpace (vlax-3d-point p1) RgSeg AIniEs AFinEs))
				

				; aggancio le entità estese 
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObArc ColorEsci)
						(if (= Journey 2) (setq segno "+"))	; percorrenza antioraria
						(if (= Journey 3) (setq segno "-"))	; percorrenza oraria
	
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 segno) xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOff xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObArc)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObArc))				

						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObArc))
					)
				)
			)
		)
		ObArc
)
;
; Funzioni ellisse
;
(defun GetDataEllipse (EnameEllipse / center majoraxis minoraxis startpt endpt MajorRadius MinorRadius Focus PtFocus1 PtFocus Rtn)

	(if EnameEllipse
		(progn
			(setq center      (vlax-safearray->list (vlax-variant-value (vlax-get-property (vlax-ename->vla-object EnameEllipse) 'center))))    ; punto in WCS
			(setq majoraxis   (vlax-safearray->list (vlax-variant-value (vlax-get-property (vlax-ename->vla-object EnameEllipse) 'MajorAxis)))) ; punto in WCS 
			(setq minoraxis   (vlax-safearray->list (vlax-variant-value (vlax-get-property (vlax-ename->vla-object EnameEllipse) 'MinorAxis)))) ; punto in WCS
			(setq startpt     (vlax-safearray->list (vlax-variant-value (vlax-get-property (vlax-ename->vla-object EnameEllipse) 'StartPoint)))); punto in WCS
            (setq endpt       (vlax-safearray->list (vlax-variant-value (vlax-get-property (vlax-ename->vla-object EnameEllipse) 'EndPoint))))  ; punto in WCS
			(setq MajorRadius (vlax-get-property (vlax-ename->vla-object EnameEllipse) 'MajorRadius)) 
			(setq MinorRadius (vlax-get-property (vlax-ename->vla-object EnameEllipse) 'MinorRadius))
			(setq Focus       (sqrt (- (* MajorRadius MajorRadius) (* MinorRadius MinorRadius))))
			(setq PtFocus1    (prol (nth 0 startpt) (nth 1 startpt) (nth 0 center) (nth 1 center) (- 0.0 Focus)))
			(setq PtFocus2    (prol (nth 0 startpt) (nth 1 startpt) (nth 0 center) (nth 1 center) (+ 0.0 Focus)))
			(setq Rtn (list center majoraxis minoraxis startpt endpt MajorRadius MinorRadius Focus PtFocus1 PtFocus2))
		)
	)
	Rtn
)
;
;
;
(defun TangentPointEllipse (EnameEllipse PtCheck / Dist PtEllipse DataEllipse PtA PtB PtC Rtn)
	
	(if (and EnameEllipse PtCheck)
		(progn
			(setq Dist        (vlax-curve-getDistAtPoint (vlax-ename->vla-object EnameEllipse) (osnap PtCheck "_near")))
			(setq PtEllipse   (vlax-curve-getPointAtDist (vlax-ename->vla-object EnameEllipse) Dist))
			(setq DataEllipse (GetDataEllipse EnameEllipse))
			;   0        1         2        3      4       5           6         7      8        9
			; center majoraxis minoraxis startpt endpt MajorRadius MinorRadius Focus PtFocus1 PtFocus2
			
			(setq PtA (prol (nth 0 (nth 8 DataEllipse)) (nth 1 (nth 8 DataEllipse))
							(nth 0 PtEllipse) (nth 1 PtEllipse) (- 0.0 1000.0)))
			(setq PtB (prol (nth 0 (nth 9 DataEllipse)) (nth 1 (nth 9 DataEllipse))
							(nth 0 PtEllipse) (nth 1 PtEllipse) (- 0.0 1000.0)))
			(setq PtC (nth 0 (div  (nth 0 PtA) (nth 1 PtA) (nth 0 PtB) (nth 1 PtB) 1)))
			;(command "_Point" PtC)
			;(command "_Point" PtEllipse)
			(setq Rtn (list PtC PtEllipse))
		)
	)
	Rtn
)
;
;
;
(defun Test (/ EnameShape PointOnSet)
	(setq Data (entsel))
	(if Data
		(progn
			(setq EnameShape (car Data))
			(setq PointOnSet (cadr Data))
			(PointTriggerInOutLineOnOff3 EnameShape (osnap PointOnSet "_near"))
		)
	)
)
;
;
(defun PointTriggerInOutLineOnOff3 (EnameShape PointOnSet / CheckPointOnSet ValidatePointTrigger MakeTrigger
														    Center PointOnSet LgTr Loop1 Ptr Rtn Nv Loop2 Param)


	(defun CheckPointOnSet (EnameSape PointOnSet LengthTrigger / Center Rtn)
		(if (and EnameSape PointOnSet LengthTrigger)
			(if (= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
				(progn
					(setq Center (vlax-get (vlax-ename->vla-object EnameShape) 'center))
					(setq Rtn    (prol (car Center) (cadr Center) (car PointOnSet) (cadr PointOnSet) (- 0.0 LengthTrigger)))
				)	
				(setq Rtn (PointPerpToShape EnameShape PointOnSet LengthTrigger))
			)
		)
		(ValidatePointTrigger EnameShape (GetTypeShape EnameShape) PointOnSet Rtn Rtn)
	)
	;
	;
	(defun ValidatePointTrigger (EnameShape TypShape PointOnSet Ps Pe / ModelSpace ObLineOn ObLineOff Rtn)
	
		(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
		(if (and EnameShape TypShape PointOnSet Ps Pe)
			(progn
				(setq ObLineOn  (vla-AddLine modelSpace (vlax-3d-point Ps) (vlax-3d-point PointOnSet) ))
				(setq ObLineOff (vla-AddLine modelSpace (vlax-3d-point PointOnSet) (vlax-3d-point Pe)))
				(if (and (= (length (MainVla-IntersectWith EnameShape (vlax-vla-object->ename ObLineOn))) 1)
						 (= (length (MainVla-IntersectWith EnameShape (vlax-vla-object->ename ObLineOff))) 1)
					)
					(cond 
						((= TypShape 1) ; 1  è un controno esterno
							(if (and (null (LM:PointInside-p Ps (vlax-ename->vla-object EnameShape) nil))
									 (null (LM:PointInside-p Pe (vlax-ename->vla-object EnameShape) nil))
								)
								(setq Rtn (list ObLineOn ObLineOff))
								(DeleteObject (list ObLineOn ObLineOff))
							)
						)
						((= TypShape 2) ; 2  è un controno interno
							(if (and (LM:PointInside-p Ps (vlax-ename->vla-object EnameShape) nil)
									 (LM:PointInside-p Pe (vlax-ename->vla-object EnameShape) nil)
								)
								(setq Rtn (list ObLineOn ObLineOff))
								(DeleteObject (list ObLineOn ObLineOff))
							)
						)
					)
					(DeleteObject (list ObLineOn ObLineOff))
				)
			)
		)
		Rtn
	)
	;
	;
	(defun MakeTrigger (EnameShape ObLineOn ObLineOff / IdShape IdGroup xd_list nuova_entita)
	
		(if (and EnameShape ObLineOn ObLineOff)
			(progn
				; aggancio le entità estese 
				(if (setq IdShape (GetIdShape EnameShape))
					(progn
						(vla-put-Color   ObLineOn $ColorEntra)
						(setq IdGroup (nth 0 (gnames EnameShape))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 "*") xd_list)
									  xd_list (cons (cons 1000 IdShape) xd_list)
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons $RgpTiggerOn xd_list)
									  xd_list (list -3 xd_list)
									  nuova_entita (append (entget (vlax-vla-object->ename ObLineOn)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObLineOn))				
						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLineOn))

						; aggancio le entità estese 
						(vla-put-Color   ObLineOff $ColorEsci)
						(setq IdGroup (nth 0 (gnames EnameShape))
							  xd_list (list '(1002 . "}"))
							  xd_list (cons (cons 1000 "*") xd_list)
							  xd_list (cons (cons 1000 IdShape) xd_list)
							  xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpTiggerOff xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append (entget (vlax-vla-object->ename ObLineOff)) (list xd_list))
						)
						(entmod nuova_entita)
						(entupd (vlax-vla-object->ename ObLineOff))				
						; assegno il gruppo 
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list ObLineOff))
					)
				)
			)
		)
	)
	;
	; Main
	;
	(setq Loop1 T)
	(setq LengthTrigger $LgSegEntra)
	
	
	(if (and EnameShape PointOnSet)
		(if (not (setq Rtn (CheckPointOnSet EnameShape PointOnSet LengthTrigger)))
			(cond 
				((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")	; e' un contorno interno
		
					(setq Center     (vlax-get (vlax-ename->vla-object EnameShape) 'center))
					(setq PointOnSet (list (+ (car Center) (vlax-get (vlax-ename->vla-object EnameShape) 'radius)) (cadr Center)))
					(setq LgTr LengthTrigger)
		
					(while Loop1
						(setq Ptr (list (- (car PointOnSet) LgTr) (cadr PointOnSet)))
						(if (setq Rtn (ValidatePointTrigger EnameShape 2 PointOnSet Ptr Ptr))
							(setq Loop1 nil)
							(progn
								(setq LgTr (- LgTr 1.0))
								(if (<= LgTr 0.0)
									(setq Loop1 nil)
								)
							)
						)
					)
				)
				(t 
					(setq Nv (/ (length  (vlax-get (vlax-ename->vla-object EnameShape) 'coordinates)) 2.0))
					(setq Loop1 T)
					(setq LgTr LengthTrigger)
				
					(while Loop1
						(setq Loop2 T)
						(setq Param 0.5)
						(while Loop2
							(setq PointOnSet (vlax-curve-getPointAtParam (vlax-ename->vla-object EnameShape) Param))
							(setq Ptr (PointPerpToShape EnameShape PointOnSet LgTr))
							(if (setq Rtn (ValidatePointTrigger EnameShape (GetTypeShape EnameShape) PointOnSet Ptr Ptr))
								(setq Loop2 nil)
								(progn
									(setq Param (+ Param 1.0))
									(if (> (fix Param) (- Nv 1))
										(setq Loop2 nil)
									)	
								)
							)
						)
						(if Rtn 
							(setq Loop1 nil)
							(progn
								(setq LgTr (- LgTr 1.0))
								(if (<= LgTr 0.0)
									(setq Loop1 nil)
								)
							)
						)
					)
				)
			)
		)
	)
	(if Rtn (MakeTrigger EnameShape (car Rtn) (cadr Rtn)))
)
;
;
(defun PointPerpToShape (EnameShape PointOnSet LengthTrigger / TypShape Px vr CoShp nv InfoShape Start End Bulge Px)
		

		(if (and EnameShape PointOnSet LengthTrigger)
			(progn
				(setq TypShape 	 (GetTypeShape EnameShape)) ; 1  è un controno esterno / 2  è un contorno interno
				(setq vr         (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) PointOnSet))	  ; tipo tangente
				(setq CoShp      (LM:lwvertices (entget EnameShape)))
				(setq nv		 (length CoShp))
				(setq InfoShape  (CheckPoly EnameShape)) ; 2 = polylinea anti oraria / 3 = polylinea oraria
				(setq Start   	 (cdr (nth 0 (nth (fix vr) CoShp))))
				(setq Bulge 	 (vla-getbulge (vlax-ename->vla-object EnameShape) (fix vr)))
				
				(if (= (- nv 1) (fix vr))
					(setq End  	(cdr (nth 0 (nth 0 CoShp))))
					(setq End   (cdr (nth 0 (nth (fix (1+ vr)) CoShp))))
				)
				(cond 
					((= TypShape 1) 	; controno esterno
						(cond
							((= (car InfoShape) 2) ; percorrenza antioraria
								(cond
									((> Bulge 0.0)
										(setq Px (LM:bulgecentre Start End Bulge))
										(setq Px (prol (car Px) (cadr Px) (car PointOnSet) (cadr PointOnSet) LengthTrigger))
									)
									((< Bulge 0.0)
										(setq Px (LM:bulgecentre Start End Bulge))
										(setq Px (prol (car Px) (cadr Px) (car PointOnSet) (cadr PointOnSet) (- 0.0 LengthTrigger)))
									)
									((= Bulge 0.0)
										(setq Px (per (car Start) (cadr Start) (car PointOnSet) (cadr PointOnSet) (- 0.0 LengthTrigger)))
									)
								)
							)
							((= (car InfoShape) 3) ; percorrenza oraria
								(cond
									((> Bulge 0.0)
										(setq Px (LM:bulgecentre Start End Bulge))
										(setq Px (prol (car Px) (cadr Px) (car PointOnSet) (cadr PointOnSet) (- 0.0 LengthTrigger)))
									)
									((< Bulge 0.0)
										(setq Px (LM:bulgecentre Start End Bulge))
										(setq Px (prol (car Px) (cadr Px) (car PointOnSet) (cadr PointOnSet) LengthTrigger))
									)
									((= Bulge 0.0)
										(setq Px (per (car Start) (cadr Start) (car PointOnSet) (cadr PointOnSet) LengthTrigger))
									)
								)
							)
						)
					)
					((= TypShape 2) 	; controno interno
						(cond
							((= (car InfoShape) 2) ; percorrenza antioraria
								(cond
									((> Bulge 0.0)
										(setq Px (LM:bulgecentre Start End Bulge))
										(setq Px (prol (car Px) (cadr Px) (car PointOnSet) (cadr PointOnSet) (- 0.0 LengthTrigger)))
									)
									((< Bulge 0.0)
										(setq Px (LM:bulgecentre Start End Bulge))
										(setq Px (prol (car Px) (cadr Px) (car PointOnSet) (cadr PointOnSet) LengthTrigger))
									)
									((= Bulge 0.0)
										(setq Px (per (car Start) (cadr Start) (car PointOnSet) (cadr PointOnSet) LengthTrigger))
									)
								)
							)
							((= (car InfoShape) 3) ; percorrenza oraria
								(cond
									((> Bulge 0.0)
										(setq Px (LM:bulgecentre Start End Bulge))
										(setq Px (prol (car Px) (cadr Px) (car PointOnSet) (cadr PointOnSet) LengthTrigger))
									)
									((< Bulge 0.0)
										(setq Px (LM:bulgecentre Start End Bulge))
										(setq Px (prol (car Px) (cadr Px) (car PointOnSet) (cadr PointOnSet) (- 0.0 LengthTrigger)))
									)
									((= Bulge 0.0)
										(setq Px (per (car Start) (cadr Start) (car PointOnSet) (cadr PointOnSet) (- 0.0 LengthTrigger)))
									)
								)
							)
						)
					)
				)
			)
		)
		Px
)
;		
			
			
	