(defun GetEnameRuleByNameSheet (NameSheet / Ssel conta IdRule Rtn)

	(if NameSheet
		(progn
			(setq Ssel (ssget "_X" (list (list -3 (list $RgpRule)))))
			(if Ssel
				(progn
					(setq conta 0)
					(repeat (sslength Ssel)
						(setq IdRule (cdr (nth 2 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))
						(if (= IdRule NameSheet)
							(setq Rtn (append Rtn (list (ssname Ssel conta))))
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
(defun GetEnameRuleByEnameSheet (EnameSheet / LstDataSheet IdSheet Ssel conta IdRule Rtn)

	(if EnameSheet
		(if (setq LstDataSheet (GetDataSheetByEname EnameSheet))
			(progn
				(setq IdSheet (car LstDataSheet))
				(setq Ssel (ssget "_X" (list (list -3 (list $RgpRule)))))
				(if Ssel
					(progn
						(setq conta 0)
						(repeat (sslength Ssel)
							(setq IdRule (cdr (nth 2 (nth 1 (assoc -3 (entget (ssname Ssel conta) (list "*")))))))
							(if (= IdRule IdSheet)
								(setq Rtn (append Rtn (list (ssname Ssel conta))))
							)
							(setq conta (1+ conta))
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
(defun PrintRuleSheet (EnameSheet / CreatRule
									UnitsRuleX UnitsRuleY TargetX SubTargetX TargetY SubTargetY
									LenghtUnits	LenghtSubTarget	LenghtTarget
									ColorUnits ColorSubTarget ColorTarget
									HtextUnits HtextSubTarget HtextTarget
									ColorTextUnits ColorTextSubTarget ColorTextTarget
									OffsetRule LstInfoShape IdSheet
									Width Height PO POx POy NdivX NdivY
									Units SubMultiple Multiple Pt LstEnameX LstEnameY LstTmp)
	;
	;
	(defun CreatRule (StartRule LenghtRule RotateRule ColorRule HtextRule ColorTextRule StyleTextRule TextRule IdSheet / 
						DistanceTextRule EndRule PosTxt modelSpace lineObj textObj LstData xd_list Rtn)
		
		(setq DistanceTextRule 50.0)
		(if (and StartRule LenghtRule RotateRule ColorRule HtextRule ColorTextRule TextRule)
			(progn
				(if (> LenghtRule 0.0)
					(progn
						(setq EndRule 		(polar StartRule (/ (* pi RotateRule) 180.0) LenghtRule))
						(setq PosTxt  		(prol (car StartRule) (cadr StartRule) (car EndRule) (cadr EndRule) DistanceTextRule))
						(setq modelSpace	(vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object))))
						(setq lineObj    	(vla-AddLine modelSpace (vlax-3d-point StartRule) (vlax-3d-point EndRule)))
						;
						(if lineObj
							(progn
								(setq LstData (entget (vlax-vla-object->ename lineObj))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 IdSheet)  xd_list) ; id 
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons $RgpRule xd_list)
									  xd_list (list -3 xd_list)
									  LstData (append LstData (list xd_list))
								)
								(entmod LstData)
								(entupd (vlax-vla-object->ename lineObj))
								(setq Rtn (append Rtn (list (vlax-vla-object->ename lineObj))))
							)
						)
					)
				)
				;
				(if (/= TextRule "")
					(progn
						(setq textObj    	(vla-AddText modelSpace TextRule (vlax-3d-point PosTxt) HtextRule))  
				
						(vlax-put-property lineObj 'Color ColorRule)
				
						(if (and (>= RotateRule 0.0)  (<= RotateRule 90.0))	    (vlax-put-property textObj 'Alignment acAlignmentMiddleLeft))
						(if (and (> RotateRule 90.0)  (<= RotateRule 270.0))	(vlax-put-property textObj 'Alignment acAlignmentMiddleRight))
						(if (and (> RotateRule 270.0) (<= RotateRule 360.0))	(vlax-put-property textObj 'Alignment acAlignmentMiddleLeft))

						(vlax-put-property textObj 'TextAlignmentPoint (vlax-3d-point PosTxt))
						(vlax-put-property textObj 'StyleName StyleTextRule)
						(vlax-put-property textObj 'ScaleFactor 0.80)
						(vlax-put-property textObj 'Color ColorTextRule)

						(if (and (>= RotateRule 0.0)  (<= RotateRule 90.0))	    (vlax-put-property textObj 'Rotation (/ (* pi RotateRule) 180.0)))
						(if (and (> RotateRule 90.0)  (<= RotateRule 270.0))	(vlax-put-property textObj 'Rotation (/ (* pi (- RotateRule 180.0)) 180.0)))
						(if (and (> RotateRule 270.0) (<= RotateRule 360.0))	(vlax-put-property textObj 'Rotation (/ (* pi (- RotateRule 360.0)) 180.0)))

						(if lineObj
							(progn
								(setq LstData (entget (vlax-vla-object->ename textObj))
									  xd_list (list '(1002 . "}"))
									  xd_list (cons (cons 1000 IdSheet)  xd_list) ; id 
									  xd_list (cons '(1002 . "{") xd_list)
									  xd_list (cons $RgpRule xd_list)
								  	  xd_list (list -3 xd_list)
									  LstData (append LstData (list xd_list))
								)
								(entmod LstData)
								(entupd (vlax-vla-object->ename lineObj))
								(setq Rtn (append Rtn (list (vlax-vla-object->ename textObj))))
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
	(setq UnitsRuleX 	100.0)
	(setq UnitsRuleY 	100.0)
	(setq TargetX   	1000.0)
	(setq SubTargetX    500.0)
	(setq TargetY   	1000.0)
	(setq SubTargetY    500.0)
	
	(setq LenghtUnits 		100.0)
	(setq LenghtSubTarget 	150.0)
	(setq LenghtTarget 		200.0)

	(setq ColorUnits 		2)
	(setq ColorSubTarget 	7)
	(setq ColorTarget 		1)

	(setq HtextUnits 		30)
	(setq HtextSubTarget 	50)
	(setq HtextTarget 		70)

	(setq ColorTextUnits 		7)
	(setq ColorTextSubTarget 	7)
	(setq ColorTextTarget 		7)
	
	(setq OffsetRule	50)
	
	(if (setq LstInfoShape (GetDataSheetByEname EnameSheet))
        ;("66096" "STK_VVVV_1" "2500" "5000" "10" "12.5" "981.25" "DDDD")
		(setq IdSheet (car LstInfoShape))
		(setq IdSheet "Nothing Sheet")
	)
	(if EnameSheet
		(progn
			(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
			(setq Width   		(abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
			(setq Height  		(abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
			(setq PO			(vlax-safearray->list mnl))
			(setq POx			(list (car PO) (- (cadr PO) OffsetRule)))
			(setq POy			(list (- (car PO) OffsetRule) (cadr PO)))
			(setq NdivX 		(fix (/ Width  UnitsRuleX)))
			(setq NdivY 		(fix (/ Height UnitsRuleY)))

			(setq LstEnameX (CreatRule POx LenghtTarget 270.0  ColorTarget HtextTarget ColorTextTarget $StyleEasyCut "0" IdSheet))
			(setq LstEnrmaY (CreatRule POy LenghtTarget 180.0  ColorTarget HtextTarget ColorTextTarget $StyleEasyCut "0" IdSheet))
			
			; ---- X -----
			
			(setq Units        0.0)
			(setq SubMultiple  0.0)
			(setq Multiple     0.0)
			(repeat NdivX
				(setq Units       (+ Units UnitsRuleX))
				(setq SubMultiple (+ SubMultiple UnitsRuleX))
				(setq Multiple    (+ Multiple UnitsRuleX))
				(setq Pt 		  (list (+ Units (nth 0 POx)) (nth 1 POx)))
				(cond 
					((= Multiple TargetX)
						(setq LstTmp (CreatRule Pt LenghtTarget 270.0 ColorTarget HtextTarget ColorTextTarget $StyleEasyCut (rtos Units 2 0) IdSheet))
						(setq Multiple     0.0)
						(setq SubMultiple  0.0)
					)
					((= SubMultiple SubTargetX)
						(setq LstTmp (CreatRule Pt LenghtSubTarget 270.0 ColorSubTarget HtextSubTarget ColorTextSubTarget $StyleEasyCut (rtos Units 2 0) IdSheet))
						(setq SubMultiple  0.0)
					)
					(t
						(setq LstTmp (CreatRule Pt LenghtUnits 270.0 ColorUnits HtextUnits ColorTextUnits $StyleEasyCut (rtos Units 2 0) IdSheet))
					)
				)
				(if LstTmp (setq LstEnameX (append LstEnameX LstTmp)))
			)

			; ---- Y -----

			(setq Units        0.0)
			(setq SubMultiple  0.0)
			(setq Multiple     0.0)
			(repeat NdivY
				(setq Units       (+ Units UnitsRuleY))
				(setq SubMultiple (+ SubMultiple UnitsRuleY))
				(setq Multiple    (+ Multiple UnitsRuleY))
				(setq Pt 		  (list (nth 0 POy) (+ Units (nth 1 POy))))
				(cond 
					((= Multiple TargetY)
						(setq LstTmp (CreatRule Pt LenghtTarget 180.0 ColorTarget HtextTarget ColorTextTarget $StyleEasyCut (rtos Units 2 0) IdSheet))
					    (setq Multiple     0.0)
						(setq SubMultiple  0.0)
					)
					((= SubMultiple SubTargetX)
						(setq LstTmp (CreatRule Pt LenghtSubTarget 180.0 ColorSubTarget HtextSubTarget ColorTextSubTarget $StyleEasyCut (rtos Units 2 0) IdSheet))
						(setq SubMultiple  0.0)
					)
					(t
						(setq LstTmp (CreatRule Pt LenghtUnits 180.0 ColorUnits HtextUnits ColorTextUnits $StyleEasyCut (rtos Units 2 0) IdSheet))
					)
				)
				(if LstTmp (setq LstEnameY (append LstEnameY LstTmp)))
			)
		)
	)
	(append LstEnameX LstEnameY)
)