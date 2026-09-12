;(defun Nst (/ Sheet Origin LstShape LstShapeNotAllocated LstNewSheet LstNestedShape Rtn)
;
;	(setq Sheet  (list 2000.0 1000.0))
;	(setq Origin (list 0.0 0.0))
;	
;	(setq LstShape	(list 	(list 600.0 650.0 (Random_Str))
;							(list 500.0 551.0 (Random_Str))
;							(list 500.0 550.0 (Random_Str))
;							(list 500.0 550.0 (Random_Str))
;							(list 500.0 550.0 (Random_Str))
;							(list 400.0 450.0 (Random_Str))
;							(list 300.0 350.0 (Random_Str))
;							(list 300.0 350.0 (Random_Str))
;							(list 100.0 120.0 (Random_Str))
;							(list 100.0 120.0 (Random_Str))
;							(list 824.0 478.0 (Random_Str))
;							(list 100.0 120.0 (Random_Str))
;							(list 100.0 120.0 (Random_Str))
;							(list 100.0 120.0 (Random_Str))
;							(list 100.0 120.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 320.0 1032.0 (Random_Str))
;							(list 1400.0 99.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))
;							(list 100.0 100.0 (Random_Str))))
;							
;		(setq Rtn (Nesting Sheet Origin LstShape))
;		
;		(setq LstShapeNotAllocated 	(nth 0 Rtn))
;		(setq LstNewSheet 			(nth 1 Rtn))
;		(setq LstNestedShape		(nth 2 Rtn))
;		
;		(ReportNesting Sheet LstShapeNotAllocated LstNewSheet LstNestedShape)
;		
;		(setq PS (getpoint "\nPunto introduzione lamiera "))
;		(PrintNestingSheet PS Sheet Origin LstNestedShape LstShapeNotAllocated)
;)
;
;
;
(defun Nst (/ FormatListStockSheet FormatListStockShape UpdateLstShape
			  LstTotSheet LstSheet LstShapeTot LstShape itm itm1 AssocItm
			  SheetWidth SheetHeight SheetId OriginSheet TkSheet MatSheet Sheet Shape 
			  Rtn LstShapeNotAllocated LstNewSheet LstNestedShape) 

	
	(defun FormatListStockSheet (LstSheet / itm SplitLst AssocItm Rcd L Rtn)
	
		; 0        1          2         3      4    5     6       7        8
		;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
        ;itm      id        nome      larg   lung   sp    mq     peso     qua

		(foreach itm LstSheet
		
			(setq SplitLst  (LM:str->lst itm "\t"))
			(setq AssocItm  (strcat (nth 5 SplitLst) "|" (nth 8 SplitLst)))
			
			(if (setq Rcd (assoc AssocItm Rtn))
				(setq L   (append (list AssocItm) (cdr Rcd) (list (list (atof (nth 3 SplitLst)) (atof (nth 4 SplitLst)) (nth 1 SplitLst))))
					  Rtn (subst L Rcd Rtn)
				)
				(setq Rtn 	(append Rtn (list 	(list (strcat (nth 5 SplitLst) "|" (nth 8 SplitLst))
													(list (- (atof (nth 3 SplitLst)) $MargineAccosto $MargineAccosto)
														  (- (atof (nth 4 SplitLst)) $MargineAccosto $MargineAccosto)
														  (nth 1 SplitLst)
													)
												)	
										)
							)
				)
			)
		)
		
		;( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)
		
		Rtn
	)
	;
	;
	;
	(defun FormatListStockShape (LstShape / itm SplitLst AssocItm Qta Rcd NewLst Rtn)
	
		; 0       1         2      3      4      5   6     7      8       9
		;"2" "516645398" "C872" "300" "178-370" "2" "1" "277.5" "290" "S355J0"
		;itm     id       comm   fase    mk     qta  sp   lung   larg    qua

		(foreach itm LstShape
			(setq SplitLst (LM:str->lst itm "\t"))
			(setq AssocItm  (strcat (nth 6 SplitLst) "|" (nth 9 SplitLst)))
			(setq Qta (atoi (nth 5 SplitLst)))
			
			(setq NewLst nil)
			(if (setq Rcd (assoc AssocItm Rtn))
			
				(progn
					(repeat Qta
						;(setq NewLst (append NewLst (list (list (atof (nth 7 SplitLst)) (atof (nth 8 SplitLst)) (nth 1 SplitLst)))))
						(setq NewLst (append NewLst (list (list (+ $MargineAccosto (atof (nth 7 SplitLst)))
																(+ $MargineAccosto (atof (nth 8 SplitLst)))
																(nth 1 SplitLst)))))
					)
					(setq NewLst (append (list AssocItm) (cdr Rcd) NewLst)
						  Rtn (subst NewLst Rcd Rtn)
					)
				)
				(progn
					(repeat Qta
						;(setq NewLst (append NewLst (list (list (atof (nth 7 SplitLst)) (atof (nth 8 SplitLst)) (nth 1 SplitLst)))))
						(setq NewLst (append NewLst (list (list (+ $MargineAccosto (atof (nth 7 SplitLst)))
																(+ $MargineAccosto (atof (nth 8 SplitLst)))
																(nth 1 SplitLst)))))
					)
					(setq Rtn 	(append Rtn (list (append (list (strcat (nth 6 SplitLst) "|" (nth 9 SplitLst))) NewLst))))
				)	
			)
			
			
		)
		;( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)   
		
		Rtn
	)
	;
	;
	;
	(defun UpdateLstShape (LstShape LstNestedShape / itm)
		;
		;LstShape		( (450.3 332.8 "162504882") (450.3 332.8 "015685") ...)
		;LstNestedShape ( ((1112 2534 "4566") (xori yori)) (....) )
		;
		(if (and LstShape LstNestedShape)
			(progn
				(foreach itm LstNestedShape
					(setq LstShape (LM:RemoveOnce (car itm) LstShape))
					; (LM:RemoveOnce (list 3 4) (list 3 4 (list 3 4) 5 3 6)) ---> (3 4 5 3 6)
				)
			)
		)
		LstShape
	)
	;
	;
	;
	(setq LstTotSheet 	(GuiTableStockSheetNesting))
	(setq LstSheet 		(FormatListStockSheet LstTotSheet)) ;----> ( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)
	
	(setq LstShapeTot	(GuiTableStockShapeNesting))
	(setq LstShape 		(FormatListStockShape LstShapeTot)) ;----> ( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)
	
	
	(if (not LstSheet) (alert "Nessuna lamiera selezionata"))
	(if (not LstShape) (alert "Nessun controno selezionato"))

	(foreach itm LstSheet				; ciclo per spessore e qualità
		
		(setq AssocItm (car itm))
		(setq Shape (cdr (assoc AssocItm LstShape)))
		
		(foreach itm1 (cdr itm)			; ciclo per lamiera
		
			(setq SheetWidth	(car itm1))
			(setq SheetHeight	(cadr itm1))
			(setq SheetId 		(caddr itm1))
			(setq OriginSheet 	(GetOriginSheet (GetEnameSheetById SheetId)))
			(setq TkSheet    	(nth 0 (splitxt AssocItm "|")))
			(setq MatSheet    	(nth 1 (splitxt AssocItm "|")))
			(setq Sheet			(list SheetWidth SheetHeight))
			
			
			;(setq Rtn (Nesting Sheet OriginSheet Shape))
			(setq Rtn (Nesting Sheet (list (+ (car OriginSheet)  $MargineAccosto)
										   (+ (cadr OriginSheet) $MargineAccosto))
										   Shape))
		
			(setq LstShapeNotAllocated 	(nth 0 Rtn))
			(setq LstNewSheet 			(nth 1 Rtn))
			(setq LstNestedShape		(nth 2 Rtn))

			(ReportNesting Sheet LstShapeNotAllocated LstNewSheet LstNestedShape)
			
			; LstShapeNotAllocated ( (100 125 "123456") ....)
			; LstNewSheet		   ( ((1112 2534) (xori yori)) (....) )
			; LstNestedShape       ( ((1112 2534 "4566") (xori yori)) (....) )
			
			(PrintNestingSheet OriginSheet LstNestedShape LstShapeNotAllocated)
		
			(setq Shape (UpdateLstShape Shape LstNestedShape))
		)
	)
	
	;(setq PS (getpoint "\nPunto introduzione lamiera "))
	;(PrintNestingSheet PS Sheet Origin LstNestedShape LstShapeNotAllocated)
)
;
;
;
(defun Nesting (Sheet Origin LstShape / Rtn1 Rtn2 LstShapeNotAllocated LstNewSheet LstNestedShape itm itm1)

	;
	; Fase 1 ++++++++++++++++++++++++++++++++++
	;
	(princ "\n Ordinamento 1")
	(setq LstShape (SortShape01 LstShape))
	(setq Rtn1 (Nesting01 Sheet Origin LstShape))
	;(ReportNesting  Sheet (nth 0 Rtn1) (nth 1 Rtn1) (nth 2 Rtn1))
	
	(setq LstShapeNotAllocated 	    (nth 0 Rtn1))
	(setq LstNewSheet			 	(nth 1 Rtn1))
	(setq LstNestedShape		    (nth 2 Rtn1))
	
	;Shape not Alocated     ---->((2100.0 100.0))
	;List New sheet         ---->(((900.0 1.0) (1100.0 550.0))   ((100.0 100.0) (1900.0 1000.0)) ((900.0 20.0) (1100.0 1100.0)) 
	;							  ((1500.0 80.0) (500.0 1120.0)) ((1400.0 99.0) (600.0 551.0))   ((1200.0 350.0) (800.0 650.0)) 
	;							  ((2000.0 2800.0) (0.0 1200.0)))
	;List Nested Shape      ---->(((600.0 650.0) (0.0 0.0)) ((500.0 551.0) (600.0 0.0)) ((500.0 550.0) (1100.0 0.0)) 
	;							   ((500.0 550.0) (0.0 650.0)) ((400.0 450.0) (1600.0 0.0)) ((300.0 350.0) (500.0 650.0)) 
	;							   ((100.0 120.0) (500.0 1000.0)) ((100.0 120.0) (600.0 1000.0)) ((100.0 120.0) (700.0 1000.0)) 
	;							   ((100.0 120.0) (800.0 1000.0)) ((100.0 120.0) (900.0 1000.0)) ((100.0 120.0) (1000.0 1000.0)) ....)

	
	(if (and LstShapeNotAllocated LstNewSheet)
		(progn
			;
			; Fase 2 ++++++++++++++++++++++++++++++++++
			;
			(princ "\n Ordinamento 2")
			(setq LstShape (SortShape02 LstShapeNotAllocated))
			
			(foreach itm LstNewSheet
			
				(setq Rtn2 (Nesting01 (car itm) (cadr itm) LstShape))
				
				(if (nth 2 Rtn2) ; LstNestedShape
					(progn 
						(setq LstNestedShape (append LstNestedShape (nth 2 Rtn2)))
						(foreach itm1  (nth 2 Rtn2) ; LstNestedShape
							(setq LstShapeNotAllocated  (LM:RemoveOnce (list (cadr (car itm1)) (car (car itm1)))  LstShapeNotAllocated ))
						)
						
						(setq LstNewSheet  (LM:RemoveOnce (list (car itm) (cadr itm)) LstNewSheet))
					
						(foreach itm1  (nth 1 Rtn2)
							(setq LstNewSheet (append LstNewSheet (list itm1))) 
						)
						
					)
				)
			)
		)
	)
	(list LstShapeNotAllocated LstNewSheet LstNestedShape)
)
;
;
;
(defun Nesting01 (Sheet Origin LstShape / GetSheetAfterCut
					                      LstShapeNotAlocated CkShape Continue ContaStock Rtn LstStock LstSheet LstNestedShape itm)
	;
	;
	;
	(defun GetSheetAfterCut (OriginSheet Sheet Shape / BShape1 HShape1 BShape2 HShape2 IdShape BSheet HSheet 
													   BScrap1 HScrap1 BScrap2 HScrap2
													   BNSheet1 HNSheet1 BNSheet2 HNSheet2 BitVal
													   OScrap ONSheet Rtn)
	
		(if (and Sheet Shape)
			(progn
				(setq BShape1 (car  Shape)
					  HShape1 (cadr Shape)
					  BShape2 (cadr Shape)
					  HShape2 (car  Shape)
					  IdShape (caddr Shape)
					  BSheet  (car  Sheet)
					  HSheet  (cadr Sheet)
				)
				
				(setq BScrap1 (- BSheet BShape1)
					  HScrap1 HShape1
					  BScrap2 (- BSheet BShape2)
					  HScrap2 HShape2
				)
				
				(setq BNSheet1 BSheet
					  HNSheet1 (- HSheet HShape1)
					  BNSheet2 BSheet
					  HNSheet2 (- HSheet HShape2)
				)
				
				(setq Scrap   nil
				      NSheet  nil
					  OScrap  nil
					  ONSheet nil
				)
				
				(setq BitVal nil)
				(if (and (>= BScrap1 0) (>= HNSheet1 0))
					(setq BitVal 10)
					(if (and (not BitVal) (>= BScrap2 0) (>= HNSheet2 0))  ; ----> rotazione 90°
						(setq BitVal 11)
					)
				)
				
				(cond
					((= BitVal 10) 
						(if (>= BScrap1   0) 
							(setq Scrap  (list BScrap1 HScrap1) 
								  Oscrap (list (+ (car OriginSheet) BShape1) (cadr OriginSheet))
							)
						)
						(if (>= HNSheet1  0) 
							(setq NSheet  (list BNSheet1 HNSheet1)
								  ONSheet (list (car OriginSheet) (+ (cadr OriginSheet) HShape1))
							)
						)
						(setq Shape (list BShape1 HShape1 IdShape ))
					)
					((= BitVal 11) ; ----> rotazione 90°
						(if (>= BScrap2   0) 
							(setq Scrap  (list BScrap2 HScrap2) 
								  Oscrap (list (+ (car OriginSheet) BShape2) (cadr OriginSheet))
							)
						)
						(if (>= HNSheet2  0) 
							(setq NSheet  (list BNSheet2 HNSheet2)
								  ONSheet (list (car OriginSheet) (+ (cadr OriginSheet) HShape2))
							)
						)
						(setq Shape (list BShape2 HShape2 IdShape ))
					)
				)
	
				(setq Rtn (list Scrap NSheet Oscrap ONSheet Shape))
			)
		)
		Rtn
	)
	;
	;
	;
	(setq LstStock (list (list Sheet Origin)))

	(foreach CkShape LstShape
	
		(setq Continue T)
		(setq ContaStock 0)
		
		(while (and Continue  (nth ContaStock LstStock))
		
			(setq Rtn (GetSheetAfterCut (nth 1 (nth ContaStock LstStock)) (nth 0 (nth ContaStock LstStock)) CkShape))
			
			(if (nth 0 Rtn)	; Scrap
				(setq Continue 	nil
				      LstStock 	(append LstStock (list (list (nth 0 Rtn) (nth 2 Rtn))))
				)
			)
			(if (nth 1 Rtn) ; New Shape
				(setq Continue nil
				      LstStock 	(append LstStock (list (list (nth 1 Rtn) (nth 3 Rtn))))
				)
			)
			
			(if (not Continue)
				(progn
					;(setq LstNestedShape 	(append LstNestedShape (list (list CkShape (nth 1 (nth ContaStock LstStock))))))
					(setq LstNestedShape 	(append LstNestedShape (list (list (nth 4 Rtn) (nth 1 (nth ContaStock LstStock))))))
					(setq LstStock 			(LM:RemoveNth ContaStock LstStock))
					
					(setq LstStock (vl-sort LstStock (function (lambda (e1 e2) (< (* (car (car e1)) (cadr (car e1))) (* (car (car e2)) (cadr (car e2))))))))
					(setq CkShape nil)
				)
			)
			(setq ContaStock (1+ ContaStock))
		)
		(if CkShape (setq LstShapeNotAlocated (append LstShapeNotAlocated (list CkShape))))
	)
	;
	; Filter Stock
	;
	(foreach itm LstStock
		(if (> (* (car (car itm)) (cadr (car itm))) 0)
			(setq LstSheet (append LstSheet (list itm)))
		)
	)
	
	(list LstShapeNotAlocated LstSheet LstNestedShape)
)
;
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
							(list 	(car  Origin)
									(cadr Origin)
						)
					)
	)	
)
;
;
;
(defun ReportNesting (Sheet LstShapeNotAllocated LstNewSheet LstNestedShape / itm AreaShapeNotAllocated AreaScrap AreaShapeAllocated)

	; Sheet (1000.0 2500.0)
	; LstShapeNotAllocated ( (100 125 "123456") ....)
	; LstNewSheet		   ( ((1112 2534) (xori yori)) (....) )
	; LstNestedShape       ( ((1112 2534 "4566") (xori yori)) (....) )
	
	(if (and (null LstShapeNotAllocated) (null LstNestedShape))
		(progn
			(princ "\n")
			(princ "\n******* Nothing Nesting *******")
			(princ "\nList shape not allocated --> nil")
			(princ "\nList shape allocated     --> nil")
		)
		(progn
			(princ "\n")
			(princ "\nList shape not allocated")
			(setq AreaShapeNotAllocated 0.0)
			(if LstShapeNotAllocated
				(foreach itm LstShapeNotAllocated
					(princ "\nDimension ") (princ (LM:rtos (car itm) 2 1)) (princ " x ") (princ (LM:rtos (cadr itm) 2 1)) (princ " id ") (princ (caddr itm))
					(setq AreaShapeNotAllocated (+ AreaShapeNotAllocated (* (car itm) (cadr itm))))
				)
				(princ "\nComplete !")
			)
			; +++++++++++++++++++++++++++++++++++
			(princ "\n")
			(princ "\nList scrap")
			(setq AreaScrap 0.0)
			(if LstNewSheet
				(foreach itm LstNewSheet
					(princ "\nDimension ") (princ (LM:rtos (car (car itm)) 2 1)) (princ " x ") (princ (LM:rtos (cadr (car itm)) 2 1))
					(setq AreaScrap (+ AreaScrap (* (car (car itm)) (cadr (car itm)))))
				)
				(princ "\nNo Scrap !")
			)
			; +++++++++++++++++++++++++++++++++++	
			(princ "\n")
			(princ "\nList shape allocated")
			(setq AreaShapeAllocated 0.0)
			(if LstNestedShape
				(foreach itm LstNestedShape
					(princ "\nDimension ") (princ (LM:rtos (car (car itm)) 2 1)) (princ " x ") (princ (LM:rtos (cadr (car itm)) 2 1)) (princ " id ") (princ (caddr (car itm)))
					(setq AreaShapeAllocated (+ AreaShapeAllocated (* (car (car itm)) (cadr (car itm)))))
				)
				(princ "\nNo Nested Shape !")
			)
			; +++++++++++++++++++++++++++++++++++
			(princ "\n")
			(princ "\nScrap               ") (princ (LM:rtos  (* (/ AreaScrap 			    (* (car Sheet) (cadr Sheet))) 100.0) 2 3))  (princ "%")
			(princ "\nSheet used          ") (princ (LM:rtos  (* (- 1.0 (/ AreaScrap 		(* (car Sheet) (cadr Sheet)))) 100.0) 2 3)) (princ "%")
			(princ "\nShape not allocated ") (princ (LM:rtos  (* (/ AreaShapeNotAllocated   (+ AreaShapeNotAllocated AreaShapeAllocated)) 100.0) 2 3)) (princ "%")
			(princ "\nShape allocated     ") (princ (LM:rtos  (* (/ AreaShapeAllocated 	    (+ AreaShapeNotAllocated AreaShapeAllocated)) 100.0) 2 3)) (princ "%")
			(princ "\n")
		)
	)
)
;
;
;
(defun PrintNestingSheet (Origin LstNestedShape LstShapeNotAllocated / itm Shape OriginNewShape OriginOldShape Ssel GrpName old_OSMODE)
	
	;
	; Grafica nesting +++
	;
	; LstShapeNotAllocated ( (100 125 "123456") ....)
	; LstNestedShape       ( ((1112 2534 "4566") (xori yori)) (....) )
	
	(if (and Origin LstNestedShape)
		(progn
			
			(foreach itm LstNestedShape
				;(setq xxx itm)
				;(terpri) (princ itm)
				
				(setq Shape       	 (list (car (car itm)) (cadr (car itm)))
					  IdShape 		 (caddr (car itm))
					  OriginNewShape (cadr itm)
					  OriginOldShape (GetOriginShape (nth 0 (GetEnameById IdShape)))
				)
				
				;(terpri) (princ Shape)
				;(terpri) (princ OriginNewShape)
				;(terpri) (princ OriginOldShape)
				
				(setq Ssel (SelectShape (nth 0 (GetEnameById IdShape))))
				(setq Clone$ T)
				(setq old_OSMODE   (getvar "OSMODE"))
				
				(setvar "OSMODE" 0)
				(command "_Copy" Ssel "" OriginOldShape OriginNewShape)
				(redraw)
				(setvar "OSMODE" old_OSMODE)
				
				(setq Clone$ nil)
					
				(setq GrpName (Gnames (nth 0 EasyCutLstEnameCopy$)))
				(CloneShape&Trigger (nth 0 GrpName))
				
				
				;(MakeRectangle OriginShape (car Shape) (cadr Shape))
			)

			;(setq XOrigin (+ (car  Origin) (car  Ps) (car Sheet) 50.0))
			;(setq YOrigin (+ (cadr Origin) (cadr Ps)))
			;(foreach itm LstShapeNotAllocated
			;	(MakeRectangle (list XOrigin YOrigin) (car itm) (cadr itm))
			;	(setq XOrigin (+ XOrigin (car itm) 50.0))
			;)
		)
	)
)
;
;
;
(defun LM:RemoveOnce ( x l / f )
	; (LM:RemoveOnce (list 3 4) (list 3 4 (list 3 4) 5 3 6)) ---> (3 4 5 3 6)
    (setq f equal)
    (vl-remove-if '(lambda ( a ) (if (f a x) (setq f (lambda ( a b ) nil)))) l)
)
;
;
;
(defun LM:RemoveNth ( n l / i )
		;(LM:RemoveNth 3 '("A" "B" "C" "D" "E" "F")) ---> ("A" "B" "C" "E" "F")
		(setq i -1)
		(vl-remove-if '(lambda ( x ) (= (setq i (1+ i)) n)) l)
)
;
;
;
(defun SortShape01 (LstShape / MaxRecordSort Chk1 Chk2 )
	;
	; ordinamento per area / altezza / base
	;
	(setq MaxRecordSort 10)
	(if LstShape
		(setq LstShape 
			(vl-sort LstShape 
				(function 
					(lambda (e1 e2)
							
						; ordinamento per area +++
						
						;(setq Chk1 "")
						;(setq Chk2 "")
						
						(setq Chk1 (CompleteString (rtos (* (car e1) (cadr e1)) 2 0) MaxRecordSort "0"))
						(setq Chk2 (CompleteString (rtos (* (car e2) (cadr e2)) 2 0) MaxRecordSort "0"))
						
						;(repeat (- MaxRecordSort (strlen (rtos (* (car e1) (cadr e1)) 2 0)))
						;	(setq Chk1 (strcat Chk1 "0"))
						;)
						;(setq Chk1 (strcat Chk1 (rtos (* (car e1) (cadr e1)) 2 0)))
						;
						;(repeat (- MaxRecordSort (strlen (rtos (* (car e2) (cadr e2)) 2 0)))
						;	(setq Chk2 (strcat Chk2 "0"))
						;)
						;(setq Chk2 (strcat Chk2 (rtos (* (car e2) (cadr e2)) 2 0)))
						
						; ordinamento per altezza 
							
						(setq Chk1 (strcat Chk1 (CompleteString (rtos (cadr e1) 2 0) MaxRecordSort "0")))
						(setq Chk2 (strcat Chk2 (CompleteString (rtos (cadr e2) 2 0) MaxRecordSort "0")))

						;(repeat (- MaxRecordSort (strlen (rtos (cadr e1) 2 0)))
						;	(setq Chk1 (strcat Chk1 "0"))
						;)
						;(setq Chk1 (strcat Chk1 (rtos (cadr e1) 2 0)))
						;
						;(repeat (- MaxRecordSort (strlen (rtos (cadr e2) 2 0)))
						;	(setq Chk2 (strcat Chk2 "0"))
						;)
						;(setq Chk2 (strcat Chk2 (rtos (cadr e2) 2 0)))
					
						; ordinamento per base 

						(setq Chk1 (strcat Chk1 (CompleteString (rtos (car e1) 2 0) MaxRecordSort "0")))
						(setq Chk2 (strcat Chk2 (CompleteString (rtos (car e2) 2 0) MaxRecordSort "0")))

						;(repeat (- MaxRecordSort (strlen (rtos (car e1) 2 0)))
						;	(setq Chk1 (strcat Chk1 "0"))
						;)
						;(setq Chk1 (strcat Chk1 (rtos (car e1) 2 0)))
						;
						;(repeat (- MaxRecordSort (strlen (rtos (car e2) 2 0)))
						;	(setq Chk2 (strcat Chk2 "0"))
						;)
						;(setq Chk2 (strcat Chk2 (rtos (car e2) 2 0)))
					
						(> Chk1 Chk2)
					)
				)
			)
		)
	)
)
;
;
;
(defun SortShape02 (LstShape / itm LstShape1)
	;
	; ordinamento per area / altezza / base ruotato di 90°
	;
	(foreach itm LstShape
		(setq LstShape1 (append LstShape1 (list (list (cadr itm) (car itm)))))
	)
	(SortShape01 LstShape1)
)
;
;
;
(defun GetTableStockShapeNesting (LstBlockBoom / SortTableNesting01
									             LstInfoTable LstTmp Rtn itm itm1)

	; ("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2")
	
	(defun SortTableNesting01 (LstTable / MaxRecordSort Chk1 Chk2)
		(setq MaxRecordSort 10)
		(if LstTable
			(setq LstTable 
				(vl-sort LstTable 
					(function 
						(lambda (e1 e2)
							
							; ordinamento per commessa +++

							(setq Chk1 (CompleteString (nth 1 e1) MaxRecordSort "0"))
							(setq Chk2 (CompleteString (nth 1 e2) MaxRecordSort "0"))
													
							; ordinamento per fase +++
							
							(setq Chk1 (strcat Chk1 (CompleteString (nth 2 e1) MaxRecordSort "0")))
							(setq Chk2 (strcat Chk2 (CompleteString (nth 2 e2) MaxRecordSort "0")))
							
							; ordinamento per spessore +++
						
							(setq Chk1 (strcat Chk1 (CompleteString (rtos (* (atof (nth 5 e1)) 100) 2 0) MaxRecordSort "0")))
							(setq Chk2 (strcat Chk2 (CompleteString (rtos (* (atof (nth 5 e2)) 100) 2 0) MaxRecordSort "0")))

							; ordinamento per marca +++

							(setq Chk1 (strcat Chk1 (CompleteString (nth 3 e1) MaxRecordSort "0")))
							(setq Chk2 (strcat Chk2 (CompleteString (nth 3 e2) MaxRecordSort "0")))
							
							(< Chk1 Chk2)
						)
					)
				)
			)
		)
	)
	;
	;
	;
	(setq LstInfoTable (list "IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "MKSHAPE" "QTASHAPE" "TKSHAPE" "LENGTHSHAPE" "HEIGHTSHAPE" "MATSHAPE"))
	
	(foreach itm LstBlockBoom
	
		;0  IDSHAPE			id contorno
		;1  ORDERSHAPE		commessa
		;2  PHASESHAPE		fase
		;3  MKSHAPE			marca
		;4  TKSHAPE			spessore
		;5  LENGTHSHAPE		lunghezza	
		;6  HEIGHTSHAPE		larghezza
		;7  MATSHAPE		materiale
		;8  LASTMODIFYSHAPE	ultima modifica
		;9  PERIMETERSHAPE	perimetro
		;10 WEIGTHSHAPE		peso
		;11 TYPESHAPE		tipo contorno
		;12 JOUSHAPE		percorrenza
		;13 COMPSHAPE		compensazione
		;14 TIMECUTSHAPE	tempo taglio
		;15 QTASHAPE		quantità
		
		(setq LstTmp nil)
		(foreach itm1 LstInfoTable
			(setq LstTmp (append LstTmp (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) itm1))))
		)
		(setq Rtn (append Rtn (list LstTmp)))
		
	)
	(SortTableNesting01 Rtn)
)
;
;
;
(defun GetTableStockSheetNesting (/ SortTableNesting01 
									LstNameStockVoidSheet itm  Rtn)

	;(IdSheet 		NameSheet 		Widthsheet 	HeightSheet  ThickSheet  SurfaceSheet  WeightSheet  MatSheet)
	;("072488826" 	"STK_GGGG_2" 	"2500" 		"5000" 		 "20" 		 "12.5" 	   "1962.5" 	"dddd")

	
	(defun SortTableNesting01 (LstTable / MaxRecordSort Chk1 Chk2)
		(setq MaxRecordSort 10)
		(if LstTable
			(setq LstTable 
				(vl-sort LstTable 
					(function 
						(lambda (e1 e2)
							
							; ordinamento per spessore +++
						
							(setq Chk1 (CompleteString (rtos (* (atof (nth 4 e1)) 100) 2 0) MaxRecordSort "0"))
							(setq Chk2 (CompleteString (rtos (* (atof (nth 4 e2)) 100) 2 0) MaxRecordSort "0"))
							
																											
							; ordinamento per nome +++
							
							(setq Chk1 (strcat Chk1 (CompleteString (nth 1 e1) MaxRecordSort "0")))
							(setq Chk2 (strcat Chk2 (CompleteString (nth 1 e2) MaxRecordSort "0")))
							
							(< Chk1 Chk2)
						)
					)
				)
			)
		)
	)
	;
	;
	;
	(setq LstNameStockVoidSheet (VoidStockListSheet))
	(foreach itm LstNameStockVoidSheet
		;IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet	
		(setq Rtn (append Rtn (list (GetDataSheetByName itm))))
	)
	(SortTableNesting01 Rtn)
)
;
;
;
(defun EvalString (Str1 Operators Str2 Mode / Val1 Val2 Segno1 Segno2 TypeStr1 TypeStr2 Rtn)

	; mode = 1 numero
	; mode = 2 stringa
	
	(setq Val1 Str1)
	(setq Val2 Str2)
	(cond
		((= Mode 1)
			(setq Val1 (read Str1))
			(if (>= Val1 0) (setq Segno1 1) (setq Segno1 -1))
			 (setq TypeStr1 1)
		)
		((= Mode 2)
			(if (= (substr Str1 1 1) "+") 
				(setq Segno1 1 
					  Val1 (substr Str1 2 (strlen Str1))
				)
				(if (= (substr Str1 1 1) "-") 
					(setq Segno1 -1 
						  Val1 (substr Str1 2 (strlen Str1))
					)
					(setq Segno1 1)
				)
			)
			(setq TypeStr1 2)
		)
	)
	(cond 
		((= Mode 1)
			(setq Val2 (read Str2))
			(if (>= Val2 0) (setq Segno2 1) (setq Segno2 -1))
			 (setq TypeStr2 1)
		)
		((= Mode 2)
			(if (= (substr Str2 1 1) "+") 
				(setq Segno2 1 
					  Val2 (substr Str2 2 (strlen Str2))
				)
				(if (= (substr Str2 1 1) "-") 
					(setq Segno2 -1 
						  Val2 (substr Str2 2 (strlen Str2))
					)
					(setq Segno2 1)
				)
			)
			(setq TypeStr2 2)
		)
	)
	
	(if (and (= TypeStr1 2) (= TypeStr2 2))
		(if (< (strlen Val1) (strlen Val2))
		    (setq Val1 (CompleteString Val1 (strlen Val2)  "0"))
			(setq Val2 (CompleteString Val2 (strlen Val1)  "0"))
		)
	)
	;(if (= Mode 1)
	;	(princ (strcat "\n" (rtos Segno1 2 0) " " (rtos Val1 2 3) " " (rtos Segno2 2 0) " "  (rtos Val2 2 3) "\n"))
	;	(princ (strcat "\n" (rtos Segno1 2 0) " " Val1 " " (rtos Segno2 2 0) " "  Val2 "\n"))
	;)
	
	(cond 
		((= Operators ">")
			(cond
				((> Segno1 Segno2)
					(setq Rtn T)
				)
				((< Segno1 Segno2)
					(setq Rtn nil)
				)
				((= Segno1 Segno2)
					(if (> Val1 Val2)
						(setq Rtn T)
					)
				)
			)
		)
		((= Operators ">=")
			(cond
				((> Segno1 Segno2)
					(setq Rtn T)
				)
				((< Segno1 Segno2)
					(setq Rtn nil)
				)
				((= Segno1 Segno2)
					(if (>= Val1 Val2)
						(setq Rtn T)
					)
				)
			)
		)
		((= Operators "<")
			(cond
				((< Segno1 Segno2) 
					(setq Rtn T)
				)
				((> Segno1 Segno2) 
					(setq Rtn nil)
				)
				((= Segno1 Segno2) 
					(if (< Val1 Val2)
						(setq Rtn T)
					)
				)
			)
		)
		((= Operators "<=")
			(cond
				((< Segno1 Segno2) 
					(setq Rtn T)
				)
				((> Segno1 Segno2) 
					(setq Rtn nil)
				)
				((= Segno1 Segno2) 
					(if (<= Val1 Val2)
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
(defun CompleteString (String MaxChar Char / Rtn)

	(if (and String MaxChar Char)
		(progn
		
			;(if (= (substr String 1 1) "-")
			;	(setq String (substr String 2 (strlen String))
			;	      Segno "-"
			;	)
			;	(setq Segno "")
			;)
			
			(if (< (strlen String) MaxChar)
				(progn
					(setq Rtn "")
					(repeat (- MaxChar (strlen String))
							(setq Rtn (strcat Rtn Char))
					)
					(setq Rtn (strcat Rtn String))
				)
				(setq Rtn String)
			)
			
			;(setq Rtn (strcat Segno Rtn))
		)
	)
	Rtn
)
;
;
;
(defun LogicFilter (Chk FilterString Mode / Rtn Loop Conta itm)

	;
	;
	;
	
	(setq Loop T)
	(setq Conta 0)
	
	(if (and Chk (setq LstItm (CheckFilterString FilterString Mode)))
		(progn
					
			(while (and Loop (nth Conta LstItm))
				(cond 
					((and (= (nth Conta LstItm) "[") (= (nth (+ Conta 3) LstItm) "]"))
						;(if (and (>= Chk (nth (+ Conta 1) LstItm)) (<= Chk (nth (+ Conta 2) LstItm)))
						(if (and (EvalString Chk ">=" (nth (+ Conta 1) LstItm) Mode) 
								 (EvalString Chk "<=" (nth (+ Conta 2) LstItm) Mode))
							(progn
								(setq Rtn T)
								(setq Loop nil)
							)
						)
					)
					((and (= (nth Conta LstItm) "[") (= (nth (+ Conta 1) LstItm) "]"))
						(setq Rtn T)
						(setq Loop nil)
					)
					(t
					
						;(terpri) (princ Chk) (princ " ") (princ (nth Conta LstItm))
						
						(if (= (substr (nth Conta LstItm) 1 1) "-")
							
								;(princ "  entro  ") (princ (substr (nth Conta LstItm) 2 (strlen (nth Conta LstItm)))) (princ " ")
								(if (= Chk (substr (nth Conta LstItm) 2 (strlen (nth Conta LstItm))))
									(setq Rtn nil
										  Loop nil
									)
									(setq Rtn T)
								)
								
						
						
								(if (= Chk (nth Conta LstItm))
									(progn
										(setq Rtn T)
										(setq Loop nil)
									)
								)
							
						)
						
						;(princ " ") (princ Rtn) (princ " ") (princ Loop) (terpri)
					)
				)
				(setq Conta (1+ Conta))
			)
		)
	)
	Rtn
)
;
;
;
(defun CheckFilterString (FilterString Mode / Rtn LstFilterString Conta Loop From To MaxRecordSort)
	
	(setq MaxRecordSort 10)
	(if FilterString
		(progn
			
			(while (vl-string-search " " FilterString)
						(setq FilterString (vl-string-subst "" " " FilterString))
			)
			
			(setq From  0)
			(setq To    0)
			(setq Conta 1)
			
			(repeat (strlen FilterString)
				(if (= (substr FilterString Conta 1) "<") (setq From (1+ From)))
				(if (= (substr FilterString Conta 1) ">") (setq To (1+ To)))
				(setq Conta (1+ Conta))
			)
			
			
			(if (and (/= FilterString "")
					 (null (wcmatch FilterString "*(*"))
					 (null (wcmatch FilterString "*)*"))
					 (null (wcmatch FilterString "*[*"))
					 (null (wcmatch FilterString "*]*"))
					 (if (= From To) T)
				)	
				(progn
					; controllo <>
					(while (vl-string-search "<" FilterString)
						(setq FilterString (vl-string-subst "[," "<" FilterString))
					)
					(while (vl-string-search ">" FilterString)
						(setq FilterString (vl-string-subst ",]" ">" FilterString))
					)
					
					(setq LstFilterString (LM:str->lst FilterString ","))
					
					;(setq From 0)
					;(setq To 0)
						
					(foreach itm LstFilterString
					
						(cond 
							((= itm "[")  
								;(setq From (1+ From))
								(setq Rtn (append Rtn (list itm)))
							)
							((= itm "]")  
								;(setq To (1+ To))
								(setq Rtn (append Rtn (list itm)))
							)
							((/= itm "")
								;(if (= Mode 1)
									(setq Rtn (append Rtn (list itm)))
									;(setq Rtn (append Rtn (list (CompleteString itm MaxRecordSort "0"))))
								;)
							)
						)
					)
					
					; +++++++++++++++++++++++++++++++++++++++++++
					(setq Conta 0)
					(setq Loop  T)
					;(if (= From To) 
					;	(setq Loop T)
					;	(setq Loop nil
					;		  Rtn  nil
					;	)
					;)
					
					(while (and Loop (nth conta Rtn))
						
						(cond
							((= (nth Conta Rtn) "[")
								(cond
								
									((and (= (nth (+ Conta 3) Rtn) "]")
										  ;(>= (nth (+ Conta 2) Rtn) (nth (+ Conta 1) Rtn))
										  (EvalString (nth (+ Conta 2) Rtn) ">=" (nth (+ Conta 1) Rtn) Mode)
									 )
										(setq Conta (+ 3 Conta))
									)
							
									((= (nth (+ Conta 1) Rtn) "]") 
										(setq Conta (+ 1 Conta))
								    )
									(t
										(setq Loop nil)
										(setq Rtn nil)
									)
								)
							)
							((= (nth Conta Rtn) "]")
								(setq Loop nil)
								(setq Rtn nil)
							)
						)
						
						(setq Conta (1+ Conta))
					)
					; +++++++++++++++++++++++++++++++++++++++++++
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun LogicFilterSelectStockShape (Order
						  Phase
						  Mark
						  Quantity
						  Thikness
						  Length
						  Height
						  Material
						  ;
						  OrderFilter 
						  PhaseFilter
						  MarkFilter
						  QuantityFilter
						  ThiknessFilter
						  LengthFilter
						  HeightFilter
						  MaterialFilter / Rtn)
						  
						  
	(if (and Order Phase Mark Quantity Thikness Length Height Length Material
			 OrderFilter PhaseFilter MarkFilter QuantityFilter ThiknessFilter LengthFilter HeightFilter MaterialFilter)
			 
		(if (and (LogicFilter Order    OrderFilter 2)
				 (LogicFilter Phase    PhaseFilter 2)
				 (LogicFilter Mark     MarkFilter  2)
				 (LogicFilter Quantity QuantityFilter 1)
				 (LogicFilter Thikness ThiknessFilter 1)
				 (LogicFilter Length   LengthFilter   1)
				 (LogicFilter Height   HeightFilter   1)
				 (LogicFilter Material MaterialFilter 2)
			)
			(setq Rtn T)
		)
	)
	Rtn
)
;
;
;
(defun LogicFilterSelectStockSheet (Name
									Width
									Height
									Thikness
									Material
									;
									NameFilter
									WidthFilter
									HeightFilter
									ThiknessFilter
									MaterialFilter / Rtn)
						  
		           
						  
	(if (and Name Width Height Thikness Material
			 NameFilter WidthFilter HeightFilter ThiknessFilter  MaterialFilter)
			 
		(if (and (LogicFilter Name     NameFilter     2)
				 (LogicFilter Width    WidthFilter    1)
				 (LogicFilter Height   HeightFilter   1)
				 (LogicFilter Thikness ThiknessFilter 1)
				 (LogicFilter Material MaterialFilter 2)
			)
			(setq Rtn T)
		)
	)
	Rtn
)
;
;
;
;(defun SetFileOut ()
;	
;)
;
;
;
;(defun SaveStockSheetNesting (FileName LstStockSheetNesting LstFilterActiveStockSheetNesting LstFilterStockSheetNesting / itm Wf)
;
;		(if (and FileName LstStockSheetNesting LstFilterActiveStockSheetNesting LstFilterStockSheetNesting)
;			(progn
;				(setq Wf (open FileName "w"))
;				(if Wf
;					(progn
;						(foreach itm LstFilterActiveStockSheetNesting
;							(princ itm Wf) (princ "|" Wf)
;						)
;						(princ "\n" Wf)
;						(foreach itm LstFilterStockSheetNesting
;							(princ itm Wf) (princ "|" Wf)
;						)
;						(princ "\n" Wf)
;						(foreach itm LstStockSheetNesting
;							(princ itm Wf) (princ "\n" Wf)
;						)
;						(close Wf)
;					)
;				)
;			)
;		)
;)
;
;
;						
(defun GetNameStockSheet (/ itm SplitStock Rtn)
		
	(setq LstName (GetNameSheet))
	(foreach itm LstName
		(setq SplitStock (splitxt itm "_"))
		(if SplitStock
			(progn
				(if (and (>= (length SplitStock) 3) 
						 (= (strcase (nth 0 SplitStock)) (strcase "STK"))
					)
					(setq Rtn (append Rtn (list itm)))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun VoidStockListSheet (/ LstStockSheet itm Rtn)
	
	(setq LstStockSheet (GetNameStockSheet))
	(foreach itm LstStockSheet
		(if (null (GetEnameShapeByEnameSheet (GetEnameSheetByName itm) "*"))
			(setq Rtn (append Rtn (list itm)))
		)
	)
	Rtn
)
;
;
;
(defun GuiStockSheet (/ MakeStockSheet MakeSheet IfExistStockSheet AddStockList MakeStock 
						xx $StockList$)
	;
	;
	;
	(defun MakeStockSheet (Px LstInfoStock / Conta itm Margine)
		
		; (("STOCK_FFF" "2500" "5000" "10" "11" "ascasda"))
		
		(setq Margine 250.0)
		(if (and Px LstInfoStock)
			(progn
				(setq PStartStockSheet Px)
				(foreach itm LstInfoStock
					(setq Conta 1)
					(repeat (atoi (nth 4 itm))
						(MakeSheet (list 	(Random_Str) 
											(strcat (nth 0 itm) "_" (rtos Conta 2 0))
											(nth 1 itm)
											(nth 2 itm)
											(nth 3 itm)
											(nth 5 itm))
											Px
						)
						(setq Conta (1+ Conta))
						(setq Px (list (+ (car Px) (atof (nth 1 itm)) Margine) (cadr Px)))
					)
				)
			)
		)
	)
	;
	;
	;
	(defun MakeSheet (DataSheet Px / xstart ystart x1 y1 x2 y2 x3 y3 x4 y4 
									 mspace arraypt anarray myobj ultent xd_list nuova_entita ColorSheet
									 DimSheet ThkSheet MatSheet NameSheet IDSheet BlockName EnameBlock) 
				
				
		;DataSheet = IdSheet NameSheet WidthSheet HeightSheet ThickSheet MatSheet
		(setq 	xstart (nth 0 px)
				ystart (nth 1 px)
				x1 xstart
				y1 ystart
				x2 (+ x1 (atof (nth 2 DataSheet)))
				y2 y1
				x3 x2
				y3 (+ y2 (atof (nth 3 DataSheet)))
				x4 x1
				y4 y3
		)
		
		(setq mspace (vla-get-modelSpace (vla-get-activeDocument (vlax-get-acad-object))))
		(setq arraypt (list x1 y1 x2 y2 x3 y3 x4 y4))
		(setq anarray (vlax-make-safearray vlax-vbDouble '(0 . 7)))
		(vlax-safearray-fill anarray arraypt)
		(setq myobj (vla-addLightweightPolyline mspace anarray))
		(vla-put-Closed myobj :vlax-true)
		
		; (-3 ("LAMIERA" (1002 . "{") 
		;                   (1000 . nome lamiera  		-valore stringa-)
		;                   (1000 . id lamiera    		-valore stringa-)
		;                   (1000 . spessore lamiera    -valore stringa-)
		;                   (1002 . "}") 
		;     )
		; 
		; )
		
		(AssignNameSheet (vlax-vla-object->ename myobj) (nth 1 DataSheet) (nth 0 DataSheet) (nth 4 DataSheet)  (nth 5 DataSheet))

		(setq DimSheet  (strcat (nth 2 DataSheet) "x" (nth 3 DataSheet)))
		(setq MatSheet  (nth 5 DataSheet))
		(setq ThkSheet  (nth 4 DataSheet))
		(setq NameSheet (nth 1 DataSheet))
		(setq IDSheet   (nth 0 DataSheet))
		(setq BlockName    (strcat LibPathEasyCut$ NameBlockSheet$ ".dwg"))
		(command "._-insert" BlockName (list (nth 0 Px) (- (nth 1 Px) 420.0)) 1.0 1.0 0 DimSheet ThkSheet NameSheet IDSheet MatSheet)
		(setq EnameBlock (entlast))
		(setq ultent  (entget EnameBlock))
		(setq xd_list (list '(1002 . "}")))
		(setq xd_list (cons '(1002 . "{")  xd_list))
		(setq xd_list (cons $RgpSheetTarget xd_list))
		(setq xd_list (list -3 xd_list))
		(setq nuova_entita (append ultent (list xd_list)))
		(entmod nuova_entita)
		(entupd EnameBlock)
	)
	;
	;
	;
	(defun IfExistStockSheet (StockName / LstName itm SplitStock Conta NameStock Rtn)
	
		(if StockName
			(progn
		
				(setq LstName (GetNameSheet))
				(if LstName
					(progn
						(foreach itm LstName
							(setq SplitStock (splitxt itm "_"))
							(if SplitStock
								(progn
									(if (and (>= (length SplitStock) 3) 
											 (= (strcase (nth 0 SplitStock)) (strcase "STK"))
										)
										(progn
											(setq Conta 1)
											(setq NameStock "")
											(repeat (- (length SplitStock) 2)
												(setq NameStock (strcat NameStock (nth Conta SplitStock)))									
												(setq Conta (1+ Conta))
											)
											(if (= (strcase NameStock) (strcase StockName))
												(setq Rtn T)
											)
										)
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
	(defun AddStockList (StockList / StockSheet QtaSheet WidthSheet HeightSheet ThickSheet MatSheet itm Record)
		
		(setq StockSheet  (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "namesheet"))))
		(setq QtaSheet    (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "qtasheet"))))
		(setq WidthSheet  (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "widthsheet"))))
		(setq HeightSheet (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "heightsheet"))))
		(setq ThickSheet  (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "thicksheet"))))
		(setq MatSheet    (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "matsheet"))))
		
		(if (= StockSheet "")
			(alert "Inserire nome stock")
			(progn
				(if (IfExistStockSheet StockSheet)
					(progn
						(alert (strcat "Lo stock " StockSheet " esiste gia' (cambia il nome)"))
						(setq StockSheet "")
					)
					(if (null (vl-string-search (strcase "STK") (strcase StockSheet)))
						(setq StockSheet (strcat (strcase "STK_") (strcase StockSheet)))
					)
				)
			)
		)
		
		
		(if (= QtaSheet "")    (alert "Inserire quantita' lamiere"))
		(if (= WidthSheet "")  (alert "Inserire larghezza lamiera"))
		(if (= HeightSheet "") (alert "Inserire altezza lamiera"))
		(if (= ThickSheet "")  (alert "Inserire spessore lamiera"))
		(if (= MatSheet "")    (alert "Inserire qualita' lamiera"))
	
	
		(if (and (/= StockSheet "") (/= QtaSheet "") (/= WidthSheet "") (/= HeightSheet "") (/= ThickSheet "")  (/= MatSheet ""))
			(progn
				(if StockList
					(progn
						(if (assoc StockSheet StockList)
							(setq StockList (subst (list StockSheet WidthSheet HeightSheet ThickSheet QtaSheet MatSheet)
												   (assoc StockSheet StockList) StockList)
							)
							(setq StockList (append StockList (list (list StockSheet WidthSheet HeightSheet ThickSheet QtaSheet MatSheet))))
						)
					)
					(setq StockList (list (list StockSheet WidthSheet HeightSheet ThickSheet QtaSheet MatSheet)))
				)
								
				(start_list "box_info")
				(foreach itm StockList
					(setq Record (strcat (nth 0 itm) "\t" (nth 1 itm) "\t" (nth 2 itm) "\t" (nth 3 itm) "\t" (nth 4 itm) "\t" (nth 5 itm)))
					(add_list Record)
				)
				(end_list)
			)
		)
		StockList
	)
	;
	;
	;
	; procedura genera/modifica stock lamiera
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
	(setq $StockList$ nil)
	
		(new_dialog "stock_lam" xx "" (cond ( *stock_lam* ) ( '(-1 -1) )))
		
		; azioni
		
		(action_tile "cancel"         (strcat "(setq *stock_lam* (done_dialog)) (unload_dialog xx)"))
		(action_tile "addstock"       "(setq $StockList$ (AddStockList $StockList$))")
		(action_tile "createstock"    (strcat "(setq MakeStock T *stock_lam* (done_dialog)) (unload_dialog xx)"))
		(start_dialog)
		
		(if MakeStock
			(MakeStockSheet (getpoint "Punto di inserimento ") $StockList$)
		)
)
;
;
;
(defun GuiTableStockSheetNesting (/ FormatTableNesting GetRecordNesting SetRecordNesting GetFilterList
									LstTableNesting Loop xx Rtn
									$ActiveFilterName$ $ActiveFilterWidth$ $ActiveFilterHeight$ $ActiveFilterThikness$ $ActiveFilterMaterial$
									$NameFilter$ $WidthFilter$ $HeightFilter$ $ThiknessFilter$ $MaterialFilter$
									LstStockSheetNesting) 

	;
	;
	;
	(defun FormatTableNesting (LstTable / conta itm itm1 StrTmp Rtn)
	
		(setq conta 1)
		(foreach itm LstTable
		
			(setq StrTmp (strcat (rtos conta 2 0) "\t"))
			
			(foreach itm1 itm
				(setq StrTmp (strcat StrTmp itm1 "\t"))
			)
			(setq Rtn (append Rtn (list StrTmp)))
			(setq conta (1+ conta))
		)
		Rtn
	)
	;
	;
	;
	(defun GetRecordNesting (LstTableNesting / Itm)
			
		;(princ "\n-------< Reason ") (princ $reason)
		
		(if (and LstTableNesting (= 4 $reason))
			(progn
				(setq Itm      (get_tile "box_info"))
				(setq Itm (nth (atoi Itm) LstTableNesting))
				
				(setq *InfoTableNesting* (done_dialog))
				(unload_dialog xx)
			)
		)
		Itm
	)
	;
	;
	;
	(defun SetRecordNesting (LstTableNesting / itm LstFilter ErrorFilter Conta Rtn)
		;(IdSheet 		NameSheet 		Widthsheet 	HeightSheet  ThickSheet  SurfaceSheet  WeightSheet  MatSheet)
		;("072488826" 	"STK_GGGG_2" 	"2500" 		"5000" 		 "20" 		 "12.5" 	   "1962.5" 	"dddd")
		;					1			  1			1			 1										1
		(if LstTableNesting
			(progn
				(mode_tile "box_label" 2)
								
				(setq $ActiveFilterName$    	(get_tile "ActiveFilterName"))
				(setq $ActiveFilterWidth$	    (get_tile "ActiveFilterWidth"))
				(setq $ActiveFilterHeight$	    (get_tile "ActiveFilterHeight"))
				(setq $ActiveFilterThikness$	(get_tile "ActiveFilterThikness"))
				(setq $ActiveFilterMaterial$    (get_tile "ActiveFilterMaterial"))
				
				
				(if (= $ActiveFilterName$ "1")
					(progn
						(mode_tile "NameFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "NameFilter"))))
					)
					(progn
						(mode_tile "NameFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- LengthFilter
				(if (= $ActiveFilterWidth$ "1")
					(progn
						(mode_tile "WidthFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "WidthFilter"))))
					)
					(progn
						(mode_tile "WidthFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- HeightFilter
				(if (= $ActiveFilterHeight$ "1")
					(progn
						(mode_tile "HeightFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "HeightFilter"))))
					)
					(progn
						(mode_tile "HeightFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)

				; ---------------------------------- ThiknessFilter
				(if (= $ActiveFilterThikness$ "1")
					(progn
						(mode_tile "ThiknessFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "ThiknessFilter"))))
					)
					(progn
						(mode_tile "ThiknessFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- MaterialFilter
				(if (= $ActiveFilterMaterial$ "1")
					(progn
						(mode_tile "MaterialFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "MaterialFilter"))))
					)
					(progn
						(mode_tile "MaterialFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ----------------------------------
				(setq Conta 1)
				(foreach itm LstFilter
					(if (null (CheckFilterString itm 2))
						(progn
							(setq ErrorFilter T)
							(alert "Potrebbe esserci un errore di sintassi nel filtro (controlla)")
						)
					)
				)
				
				;(princ (strcat "\n" (nth 0 LstFilter) "--" (nth 1 LstFilter) "--" (nth 2 LstFilter) "--" (nth 3 LstFilter) "--" (nth 4 LstFilter)))
				
				(if (null ErrorFilter)
					(progn
						(setq Rtn (GetFilterList LstTableNesting LstFilter))
						(start_list "box_info")
							(mapcar 'add_list Rtn)
						(end_list)
					)
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(defun GetFilterList (LstTableNesting LstFilter / Conta itm Split Rtn)
		(if (and LstTableNesting LstFilter)
			(progn
				(setq Conta 1)
				(foreach itm LstTableNesting
					(setq Split (LM:str->lst itm "\t"))
					
		            ;1 072488826 STK_GGGG_2 2500 5000 20 11.5 3335.8 S355
		            
					(if (LogicFilterSelectStockSheet (nth 2 Split) (nth 3 Split) (nth 4 Split) (nth 5 Split) (nth 8 Split)
													 (nth 0 LstFilter)
													 (nth 1 LstFilter)
													 (nth 2 LstFilter)
													 (nth 3 LstFilter)
													 (nth 4 LstFilter))
											
						(setq Rtn (append Rtn (list (strcat (rtos Conta 2 0) "\t"
															(nth 1 Split) "\t"
															(nth 2 Split) "\t"
															(nth 3 Split) "\t"
															(nth 4 Split) "\t"
															(nth 5 Split) "\t"
															(nth 6 Split) "\t"
															(nth 7 Split) "\t"
															(nth 8 Split))))
							 Conta (1+ Conta)
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
	(setq LstTableNesting (FormatTableNesting (GetTableStockSheetNesting)))
	
	;NameFilter
	;WidthFilter
	;HeightFilter
	;ThiknessFilter
	;MaterialFilter

	(setq $ActiveFilterName$ 		"1")
	(setq $ActiveFilterWidth$		"1")
	(setq $ActiveFilterHeight$		"1")
	(setq $ActiveFilterThikness$	"1")
	(setq $ActiveFilterMaterial$	"1")
	

	(setq $NameFilter$ 				"<>")
	(setq $WidthFilter$				"<>")
	(setq $HeightFilter$			"<>")
    (setq $ThiknessFilter$ 			"<>")
    (setq $MaterialFilter$ 			"<>")
	
	(if LstTableNesting
		(progn
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(new_dialog "InfoTableStockSheetNesting" xx "" (cond ( *InfoTableNesting* ) ( '(-1 -1) )))
				(start_list "box_info")
					(mapcar 'add_list LstTableNesting)
				(end_list)
			
				(set_tile  "ActiveFilterName"			$ActiveFilterName$)	
				(set_tile  "ActiveFilterWidth"	    	$ActiveFilterWidth$)
				(set_tile  "ActiveFilterHeight"	    	$ActiveFilterHeight$)
                (set_tile  "ActiveFilterThikness"	    $ActiveFilterThikness$)
                (set_tile  "ActiveFilterMaterial"	    $ActiveFilterMaterial$)
			
				(set_tile  "NameFilter"					$NameFilter$)
				(set_tile  "WidthFilter"				$WidthFilter$)
				(set_tile  "HeightFilter"				$HeightFilter$)
				(set_tile  "ThiknessFilter"				$ThiknessFilter$)
				(set_tile  "MaterialFilter"				$MaterialFilter$)
				
				(if (= $ActiveFilterName$     "1")	(mode_tile "NameFilter"     0)	(mode_tile "NameFilter"     1))
				(if (= $ActiveFilterWidth$   "1")	(mode_tile "WidthFilter"    0)	(mode_tile "WidthFilter"    1))
				(if (= $ActiveFilterHeight$   "1")	(mode_tile "HeightFilter"   0)	(mode_tile "HeightFilter"   1))
				(if (= $ActiveFilterThikness$ "1")	(mode_tile "ThiknessFilter" 0)	(mode_tile "ThiknessFilter" 1))
				(if (= $ActiveFilterMaterial$ "1")	(mode_tile "MaterialFilter" 0)	(mode_tile "MaterialFilter" 1))
				(mode_tile "box_label" 2)
				;(mode_tile "box_info" 1)
				
				;(action_tile "box_info"             "(setq Rtn (GetRecordNesting LstTableNesting))")

				(action_tile "ActiveFilterName"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterWidth"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterHeight"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterThikness"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterMaterial"	"(setq Rtn (SetRecordNesting LstTableNesting))")

 				(action_tile "NameFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "WidthFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "HeightFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
                (action_tile "ThiknessFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
                (action_tile "MaterialFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")

				(action_tile "exit"	               	"(setq *InfoTableNesting* (done_dialog)) (unload_dialog xx)")
				(action_tile "save"                 "(setq LstStockSheetNesting (SetRecordNesting LstTableNesting) *InfoTableNesting* (done_dialog)) (unload_dialog xx)")
				(start_dialog)
				
				
		)
	)
	LstStockSheetNesting
)
;
;
;
(defun GuiTableStockShapeNesting (/ FormatTableNesting GetRecordNesting SetRecordNesting GetFilterList
									LstTableNesting Loop xx Rtn
									$ActiveFilterOrder$    $ActiveFilterPhase$  $ActiveFilterMark$   $ActiveFilterQuantity$
									$ActiveFilterThikness$ $ActiveFilterLength$ $ActiveFilterHeight$ $ActiveFilterMaterial$
									$OrderFilter$    $PhaseFilter$  $MarkFilter$    $QuantityFilter$
									$ThiknessFilter$ $LengthFilter$ $HeightFilter$	$MaterialFilter$
									LstStockShapeNesting)


	;
	;
	;
	(defun FormatTableNesting (LstTable / conta itm itm1 StrTmp Rtn)
	
		(setq conta 1)
		(foreach itm LstTable
		
			(setq StrTmp (strcat (rtos conta 2 0) "\t"))
			
			(foreach itm1 itm
				(setq StrTmp (strcat StrTmp itm1 "\t"))
			)
			(setq Rtn (append Rtn (list StrTmp)))
			(setq conta (1+ conta))
		)
		Rtn
	)
	;
	;
	;
	(defun GetRecordNesting (LstTableNesting / Itm)
			
		;(princ "\n-------< Reason ") (princ $reason)
		
		(if (and LstTableNesting (= 4 $reason))
			(progn
				(setq Itm      (get_tile "box_info"))
				(setq Itm (nth (atoi Itm) LstTableNesting))
				
				(setq *InfoTableNesting* (done_dialog))
				(unload_dialog xx)
			)
		)
		Itm
	)
	;
	;
	;
	(defun SetRecordNesting (LstTableNesting / itm LstFilter ErrorFilter Conta Rtn)
	
		(if LstTableNesting
			(progn
				(mode_tile "box_label" 2)
				(setq $ActiveFilterOrder$ 		(get_tile "ActiveFilterOrder"))
				(setq $ActiveFilterPhase$  		(get_tile "ActiveFilterPhase"))
				(setq $ActiveFilterMark$     	(get_tile "ActiveFilterMark"))
				(setq $ActiveFilterQuantity$    (get_tile "ActiveFilterQuantity"))
				(setq $ActiveFilterThikness$	(get_tile "ActiveFilterThikness"))
				(setq $ActiveFilterLength$	    (get_tile "ActiveFilterLength"))
				(setq $ActiveFilterHeight$	    (get_tile "ActiveFilterHeight"))
				(setq $ActiveFilterMaterial$    (get_tile "ActiveFilterMaterial"))
				
				;(alert (strcat $ActiveFilterOrder$ " " $ActiveFilterPhase$ " " $ActiveFilterMark$ " " $ActiveFilterThikness$ " " $ActiveFilterMaterial$))
				; ---------------------------------- OrderFilter 
				(if (= $ActiveFilterOrder$ "1")
					(progn
						(mode_tile "OrderFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "OrderFilter"))))
					)
					(progn
						(mode_tile "OrderFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- PhaseFilter
				(if (= $ActiveFilterPhase$ "1")
					(progn
						(mode_tile "PhaseFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "PhaseFilter"))))
					)
					(progn
						(mode_tile "PhaseFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- MarkFilter
				(if (= $ActiveFilterMark$ "1")
					(progn
						(mode_tile "MarkFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "MarkFilter"))))
					)
					(progn
						(mode_tile "MarkFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- QuantityFilter
				(if (= $ActiveFilterQuantity$ "1")
					(progn
						(mode_tile "QuantityFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "QuantityFilter"))))
					)
					(progn
						(mode_tile "QuantityFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- ThiknessFilter
				(if (= $ActiveFilterThikness$ "1")
					(progn
						(mode_tile "ThiknessFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "ThiknessFilter"))))
					)
					(progn
						(mode_tile "ThiknessFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- LengthFilter
				(if (= $ActiveFilterLength$ "1")
					(progn
						(mode_tile "LengthFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "LengthFilter"))))
					)
					(progn
						(mode_tile "LengthFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- HeightFilter
				(if (= $ActiveFilterHeight$ "1")
					(progn
						(mode_tile "HeightFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "HeightFilter"))))
					)
					(progn
						(mode_tile "HeightFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- MaterialFilter
				(if (= $ActiveFilterMaterial$ "1")
					(progn
						(mode_tile "MaterialFilter" 0) ; attivo
						(setq LstFilter (append LstFilter (list (get_tile "MaterialFilter"))))
					)
					(progn
						(mode_tile "MaterialFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ----------------------------------
				(setq Conta 1)
				(foreach itm LstFilter
					(if (null (CheckFilterString itm 2))
						(progn
							(setq ErrorFilter T)
							(alert "Potrebbe esserci un errore di sintassi nel filtro (controlla)")
						)
					)
				)
				
				;(princ (strcat "\n" (nth 0 LstFilter) "--" (nth 1 LstFilter) "--" (nth 2 LstFilter) "--" (nth 3 LstFilter) "--" (nth 4 LstFilter)))
				
				(if (null ErrorFilter)
					(progn
						(setq Rtn (GetFilterList LstTableNesting LstFilter))
						(start_list "box_info")
							(mapcar 'add_list Rtn)
						(end_list)
					)
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(defun GetFilterList (LstTableNesting LstFilter / Conta itm Split Rtn)
		(if (and LstTableNesting LstFilter)
			(progn
				(setq Conta 1)
				(foreach itm LstTableNesting
					(setq Split (LM:str->lst itm "\t"))
					;					  2      3      4      5    6    7        8       9
					; ("01" "026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2")
					(if (LogicFilterSelectStockShape 	(nth 2 Split) (nth 3 Split) (nth 4 Split) (nth 5 Split)
														(nth 6 Split) (nth 7 Split) (nth 8 Split) (nth 9 Split)
														(nth 0 LstFilter)
														(nth 1 LstFilter)
														(nth 2 LstFilter)
														(nth 3 LstFilter)
														(nth 4 LstFilter)
														(nth 5 LstFilter)
														(nth 6 LstFilter)
														(nth 7 LstFilter))
						(setq Rtn (append Rtn (list (strcat (rtos Conta 2 0) "\t"
															(nth 1 Split) "\t"
															(nth 2 Split) "\t"
															(nth 3 Split) "\t"
															(nth 4 Split) "\t"
															(nth 5 Split) "\t"
															(nth 6 Split) "\t"
															(nth 7 Split) "\t"
															(nth 8 Split) "\t"
															(nth 9 Split))))
							 Conta (1+ Conta)
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
	(setq LstTableNesting (FormatTableNesting (GetTableStockShapeNesting (GetLstBlock NameBlockShape$))))
	(setq $ActiveFilterOrder$ 		"1")
	(setq $ActiveFilterPhase$ 		"1")
	(setq $ActiveFilterMark$ 		"1")
	(setq $ActiveFilterQuantity$ 	"1")
	(setq $ActiveFilterThikness$	"1")
	(setq $ActiveFilterLength$		"1")
	(setq $ActiveFilterHeight$		"1")
	(setq $ActiveFilterMaterial$	"1")

	(setq $OrderFilter$ 			"<>")			
    (setq $PhaseFilter$ 			"<>")			
	(setq $MarkFilter$ 				"<>")
	(setq $QuantityFilter$ 			"<>")
    (setq $ThiknessFilter$ 			"<>")
	(setq $LengthFilter$			"<>")
	(setq $HeightFilter$			"<>")
    (setq $MaterialFilter$ 			"<>")
	
	(if LstTableNesting
		(progn
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(new_dialog "InfoTableNesting" xx "" (cond ( *InfoTableNesting* ) ( '(-1 -1) )))
				(start_list "box_info")
					(mapcar 'add_list LstTableNesting)
				(end_list)
			

				(set_tile  "ActiveFilterOrder"		    $ActiveFilterOrder$)			
				(set_tile  "ActiveFilterPhase"		    $ActiveFilterPhase$)			
				(set_tile  "ActiveFilterMark"			$ActiveFilterMark$)	
				(set_tile  "ActiveFilterQuantity"		$ActiveFilterQuantity$)
				(set_tile  "ActiveFilterThikness"	    $ActiveFilterThikness$)
				(set_tile  "ActiveFilterLength"	    	$ActiveFilterLength$)
				(set_tile  "ActiveFilterHeight"	    	$ActiveFilterHeight$)
				(set_tile  "ActiveFilterMaterial"	    $ActiveFilterMaterial$)
			
				(set_tile  "OrderFilter"				$OrderFilter$)			
				(set_tile  "PhaseFilter"				$PhaseFilter$)			
				(set_tile  "MarkFilter"					$MarkFilter$)
				(set_tile  "QuantityFilter"				$QuantityFilter$)
				(set_tile  "ThiknessFilter"				$ThiknessFilter$)
				(set_tile  "LengthFilter"				$LengthFilter$)
				(set_tile  "HeightFilter"				$HeightFilter$)
				(set_tile  "MaterialFilter"				$MaterialFilter$)
				
				(if (= $ActiveFilterOrder$    "1")	(mode_tile "OrderFilter"    0)	(mode_tile "OrderFilter"    1))
				(if (= $ActiveFilterPhase$    "1")	(mode_tile "PhaseFilter"    0)	(mode_tile "PhaseFilter"    1))	
				(if (= $ActiveFilterMark$     "1")	(mode_tile "MarkFilter"     0)	(mode_tile "MarkFilter"     1))
				(if (= $ActiveFilterQuantity$ "1")	(mode_tile "QuantityFilter" 0)	(mode_tile "QuantityFilter" 1))
				(if (= $ActiveFilterThikness$ "1")	(mode_tile "ThiknessFilter" 0)	(mode_tile "ThiknessFilter" 1))
				(if (= $ActiveFilterLength$   "1")	(mode_tile "LengthFilter"   0)	(mode_tile "LengthFilter"   1))
				(if (= $ActiveFilterHeight$   "1")	(mode_tile "HeightFilter"   0)	(mode_tile "HeightFilter"   1))
				(if (= $ActiveFilterMaterial$ "1")	(mode_tile "MaterialFilter" 0)	(mode_tile "MaterialFilter" 1))
				(mode_tile "box_label" 2)
			
				(action_tile "ActiveFilterOrder" 	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterPhase"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterMark"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterQuantity"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterThikness"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterLength"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterHeight"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterMaterial"	"(setq Rtn (SetRecordNesting LstTableNesting))")

				(action_tile "OrderFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
                (action_tile "PhaseFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "MarkFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "QuantityFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ThiknessFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "LengthFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "HeightFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "MaterialFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")

				(action_tile "exit"	               	"(setq Rtn nil *InfoTableNesting* (done_dialog)) (unload_dialog xx)")
				(action_tile "save"                 "(setq LstStockShapeNesting (SetRecordNesting LstTableNesting) *InfoTableNesting* (done_dialog)) (unload_dialog xx)")
															
				
				(start_dialog)
		)
	)
	LstStockShapeNesting
)
;
;
