;(defun Nst (/ Sheet Origin LstShape LstShapeNotAllocated LstNewSheet LstNestedShape Rtn)
;
;	(setq Sheet  (list 2000.0 1000.0))
;	(setq Origin (list 0.0 0.0))
;	
;	(setq LstShape	(list 	(list 600.0 650.0 (Random_Str 9))
;							(list 500.0 551.0 (Random_Str 9))
;							(list 500.0 550.0 (Random_Str 9))
;							(list 500.0 550.0 (Random_Str 9))
;							(list 500.0 550.0 (Random_Str 9))
;							(list 400.0 450.0 (Random_Str 9))
;							(list 300.0 350.0 (Random_Str 9))
;							(list 300.0 350.0 (Random_Str 9))
;							(list 100.0 120.0 (Random_Str 9))
;							(list 100.0 120.0 (Random_Str 9))
;							(list 824.0 478.0 (Random_Str 9))
;							(list 100.0 120.0 (Random_Str 9))
;							(list 100.0 120.0 (Random_Str 9))
;							(list 100.0 120.0 (Random_Str 9))
;							(list 100.0 120.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 320.0 1032.0 (Random_Str 9))
;							(list 1400.0 99.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))
;							(list 100.0 100.0 (Random_Str 9))))
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
(defun GuiNesting (/ xx SeletcShapeSimple SeletcShapeExpert SeletcSheetSimple SeletcSheetExpert 
					 RestoreShapeSimple RestoreShapeExpert RestoreSheetSimple RestoreSheetExpert
					 EditShapeSimple EditShapeExpert EditSheetSimple EditSheetExpert 
					 FileSaveShapeSimple FileSaveSheetSimple FileSaveShapeExpert FileSaveSheetExpert
					 Loop Rtn LstDataShape LstFile
					 LstDataShapeSimple LstDataShapeExpert LstDataSheetSimple LstDataSheetExpert
					 NestingSimple NestingExpert ImportExpert ShapeExpert
					 LstSheetSimple LstSheetExpert LstShapeSimple LstShapeExpert
					 
					 
					 )

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
	(setq SeletcShapeSimple nil)
	(setq SeletcShapeExpert nil)
	(setq SeletcSheetSimple nil)
	(setq SeletcSheetExpert nil)
		
	(setq RestoreShapeSimple nil)
	(setq RestoreShapeExpert nil)
	(setq RestoreSheetSimple nil)
	(setq RestoreSheetExpert nil)
		
	(setq EditShapeSimple nil)
	(setq EditShapeExpert nil)
	(setq EditSheetSimple nil)
	(setq EditSheetExpert nil)

	(setq Loop T)
	(while Loop
		(new_dialog "NestingDialog" xx "" (cond ( *NestingDialog* ) ( '(-1 -1) )))
		
		(if FileSaveShapeSimple$
			(if (findfile FileSaveShapeSimple$) 
				(set_tile  "FileSelectShapeSimple"	FileSaveShapeSimple$) 
			)
		)
		(if FileSaveSheetSimple$ 
			(if (findfile FileSaveSheetSimple$) 
				(set_tile  "FileSelectSheetSimple"	FileSaveSheetSimple$) 
			)
		)
		(if FileSaveShapeExpert$
			(if (findfile FileSaveShapeExpert$) 
				(set_tile  "FileSelectShapeExpert"	FileSaveShapeExpert$) 
			)
		)
		(if FileSaveSheetExpert$
			(if (findfile FileSaveSheetExpert$) 
				(set_tile  "FileSelectSheetExpert"	FileSaveSheetExpert$)
			)
		)
	
		(action_tile "SelectShapeSimple" 	(strcat "(setq SeletcShapeSimple T  *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "SelectShapeExpert" 	(strcat "(setq SeletcShapeExpert T  *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "SelectSheetSimple" 	(strcat "(setq SeletcSheetSimple T  *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "SelectSheetExpert" 	(strcat "(setq SeletcSheetExpert T  *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		
		(action_tile "RestoreShapeSimple"	(strcat "(setq RestoreShapeSimple T *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "RestoreShapeExpert"	(strcat "(setq RestoreShapeExpert T *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "RestoreSheetSimple"	(strcat "(setq RestoreSheetSimple T *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "RestoreSheetExpert"	(strcat "(setq RestoreSheetExpert T *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		
		(action_tile "EditShapeSimple"		(strcat "(setq EditShapeSimple T  
														   FileSaveShapeSimple (get_tile \"FileSelectShapeSimple\")
														   *NestingDialog* (done_dialog)) (unload_dialog xx))"))
														
		(action_tile "EditShapeExpert"		(strcat "(setq EditShapeExpert T  
														   FileSaveShapeExpert (get_tile \"FileSelectShapeExpert\")
														   *NestingDialog* (done_dialog)) (unload_dialog xx))"))
					
		(action_tile "EditSheetSimple"		(strcat "(setq EditSheetSimple T  
														   FileSaveSheetSimple (get_tile \"FileSelectSheetSimple\")
														   *NestingDialog* (done_dialog)) (unload_dialog xx))"))
												
		(action_tile "EditSheetExpert"		(strcat "(setq EditSheetExpert T  
														   FileSaveSheetExpert (get_tile \"FileSelectSheetExpert\")
														   *NestingDialog* (done_dialog)) (unload_dialog xx))"))
														 
		
		(action_tile "NestingSimple" 		(strcat "(setq NestingSimple T  LstSheetSimple (ReadFileNesting (get_tile \"FileSelectSheetSimple\"))
																			LstShapeSimple (ReadFileNesting (get_tile \"FileSelectShapeSimple\"))
																			Loop nil
																			*NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "NestingExpert"		(strcat "(setq NestingExpert T  LstSheetExpert (ReadFileNesting (get_tile \"FileSelectSheetExpert\"))
																			LstShapeExpert (ReadFileNesting (get_tile \"FileSelectShapeExpert\"))
																			Loop nil
																			*NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "ImportExpert"			(strcat "(setq ImportExpert  T  Loop nil *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		(action_tile "ShapeExpert"			(strcat "(setq ShapeExpert   T  Loop nil *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		
		(action_tile "cancel"				(strcat "(setq Loop nil *NestingDialog* (done_dialog)) (unload_dialog xx)"))
		
		(start_dialog)
		
		(cond
			((= NestingSimple T)
				(CreateNestingSimple (cdr LstSheetSimple) (cdr LstShapeSimple))
			)
			((= NestingExpert T)
				(CreateNestingExpert (cdr LstSheetExpert) (cdr LstShapeExpert))
			)
			
			((= SeletcShapeSimple T)
				(setq Rtn (GuiSelPiecesShape))
				(setq FileSaveShapeSimple$ 	(car Rtn))
				(setq LstDataShapeSimple	(cdr Rtn))
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq SeletcShapeSimple nil)
			)
			((= SeletcShapeExpert T)
				(setq Rtn (GuiSelPiecesShape))
				(setq FileSaveShapeExpert$ (car Rtn))
				(setq LstDataShapeExper	  (cdr Rtn))
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq SeletcShapeExpert nil)
			)
			((= SeletcSheetSimple T)
				(setq Rtn (GuiSelPiecesSheet))
				(setq FileSaveSheetSimple$ (car Rtn))
				(setq LstDataSheetSimple  (cdr Rtn))
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq SeletcSheetSimple nil)
			)
			((= SeletcSheetExpert T)
				(setq Rtn (GuiSelPiecesSheet))
				(setq FileSaveSheetExpert$ (car Rtn))
				(setq LstDataSheetExpert  (cdr Rtn))
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq SeletcSheetExpert nil)
			)
			;+++++++++++++++++++++++
			((= RestoreShapeSimple T)
				(setq LstFile (LM:getfiles "Seleziona file Shape" DxfNestingEasyCut$ "shp"))
				(if LstFile (setq FileSaveShapeSimple$ (car LstFile)))
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq RestoreShapeSimple nil)
			)
			((= RestoreShapeExpert T)
				(setq LstFile (LM:getfiles "Seleziona file Shape" DxfNestingEasyCut$ "shp"))
				(if LstFile (setq FileSaveShapeExpert$ (car LstFile)))
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq RestoreShapeExpert nil)
			)
			((= RestoreSheetSimple T)
				(setq LstFile (LM:getfiles "Seleziona file Sheet" DxfNestingEasyCut$ "sht"))
				(if LstFile (setq FileSaveSheetSimple$ (car LstFile)))
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq RestoreSheetSimple nil)
			)
			((= RestoreSheetExpert T)
				(setq LstFile (LM:getfiles "Seleziona file Sheet" DxfNestingEasyCut$ "sht"))
				(if LstFile (setq FileSaveSheetExpert$ (car LstFile)))
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq RestoreSheetExpert nil)
			)
			;+++++++++++++++++++++++
			((= EditShapeSimple T)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(if (findfile FileSaveShapeSimple) (startapp "notepad" FileSaveShapeSimple) (alert "file non valido"))
				(setq EditShapeSimple nil)
			)
			((= EditShapeExpert T)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(if (findfile FileSaveShapeExpert) (startapp "notepad" FileSaveShapeExpert) (alert "file non valido"))
				(setq EditShapeExpert nil)
			)
			((= EditSheetSimple T)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(if (findfile FileSaveSheetSimple) (startapp "notepad" FileSaveSheetSimple) (alert "file non valido"))
				(setq EditSheetSimple nil)
			)
			((= EditSheetExpert T)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(if (findfile FileSaveSheetExpert) (startapp "notepad" FileSaveSheetExpert) (alert "file non valido"))
				(setq EditSheetExpert nil)
			)
			;+++++++++++++++++++++++
			((= ImportExpert T)
				(ImportDxfFile)
			)
			;+++++++++++++++++++++++
			((= ShapeExpert T)
				(TrattaNestProfessor)
			)
			
		)
	)
)
;
;
;
(defun CreateNestingSimple (LstSheet LstShape / FormatListStockSheet FormatListStockShape UpdateLstShape
												LstTotSheet LstTotShape itm itm1 AssocItm
												SheetWidth SheetHeight SheetId OriginSheet TkSheet MatSheet Sheet Shape 
												Rtn LstShapeNotAllocated LstNewSheet LstNestedShape) 

	
	(defun FormatListStockSheet (LstSheet / itm SplitLst AssocItm Rcd L Rtn)
	
		; 0        1          2         3      4    5     6       7        8
		;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
        ;itm      id        nome      larg   lung   sp    mq     peso     qua

		(foreach itm LstSheet
		
			;(setq SplitLst  (LM:str->lst itm " "))
			(setq SplitLst  itm)
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
			;(setq SplitLst (LM:str->lst itm " "))
			(setq SplitLst itm)
			(setq AssocItm  (strcat (nth 6 SplitLst) "|" (nth 9 SplitLst)))
			(setq Qta (atoi (nth 5 SplitLst)))
			
			(setq NewLst nil)
			(if (setq Rcd (assoc AssocItm Rtn))
			
				(progn
					(repeat Qta
					
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
	(defun UpdateLstShape (LstShape LstNestedShape / itm NItm)
		;
		;LstShape		( (450.3 332.8 "162504882") (450.3 332.8 "015685") ...)
		;LstNestedShape ( ((1112 2534 "4566" 90) (xori yori)) (....) )
		;
		(if (and LstShape LstNestedShape)
			(progn

				
				(foreach itm LstNestedShape
					
					(setq NItm (length LstShape))
					(setq LstShape (LM:RemoveOnce (list (car (car itm)) (cadr (car itm)) (caddr (car itm))) LstShape))
					(if (= NItm (length LstShape))
						(setq LstShape (LM:RemoveOnce (list (cadr (car itm)) (car (car itm)) (caddr (car itm))) LstShape))
					)
					
					
				)
				

			)
		)
		LstShape
	)
	;
	;
	;
	;(ListId->EnameCreate)
	;(setq LstTotSheet 	(GuiSelPiecesSheet))
	;(if LstTotSheet (setq LstTotShape (GuiSelPiecesShape)))
	
	;(setq LstSheet 		(FormatListStockSheet LstTotSheet)) ;----> ( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)
	;(setq LstShape 		(FormatListStockShape LstTotShape)) ;----> ( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)
	;(ListId->EnameDelete)

	(if (not LstSheet) (alert "Nessuna lamiera selezionata"))
	(if (not LstShape) (alert "Nessun controno selezionato"))
	
	(if (and LstSheet LstShape)
		(progn
			(setq LstSheet 	(FormatListStockSheet LstSheet)) ;----> ( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)
			(setq LstShape 	(FormatListStockShape LstShape)) ;----> ( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)
			
			(if (and LstSheet LstShape)
				(progn
				
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

							(ReportNesting Sheet SheetId LstShapeNotAllocated LstNewSheet LstNestedShape)
			
							; LstShapeNotAllocated ( (100 125 "123456") ....)
							; LstNewSheet		   ( ((1112 2534) (xori yori)) (....) )
							; LstNestedShape       ( ((1112 2534 "4566") (xori yori)) (....) )
			
							(PrintNestingSheet OriginSheet LstNestedShape LstShapeNotAllocated)
		
							(setq Shape (UpdateLstShape Shape LstNestedShape))
						)
					)
				)
			)
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

	
	;(if (and LstShapeNotAllocated LstNewSheet)
	;	(progn
	;		;
	;		; Fase 2 ++++++++++++++++++++++++++++++++++
	;		;
	;		(princ "\n Ordinamento 2")
	;		(setq LstShape (SortShape02 LstShapeNotAllocated))
	;		
	;		(foreach itm LstNewSheet
	;		
	;			(setq Rtn2 (Nesting01 (car itm) (cadr itm) LstShape))
	;			
	;			(if (nth 2 Rtn2) ; LstNestedShape
	;				(progn 
	;					(setq LstNestedShape (append LstNestedShape (nth 2 Rtn2)))
	;					(foreach itm1  (nth 2 Rtn2) ; LstNestedShape
	;						(setq LstShapeNotAllocated  (LM:RemoveOnce (list (cadr (car itm1)) (car (car itm1)))  LstShapeNotAllocated ))
	;					)
	;					
	;					(setq LstNewSheet  (LM:RemoveOnce (list (car itm) (cadr itm)) LstNewSheet))
	;				
	;					(foreach itm1  (nth 1 Rtn2)
	;						(setq LstNewSheet (append LstNewSheet (list itm1))) 
	;					)
	;					
	;				)
	;			)
	;		)
	;	)
	;)
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
					(setq BitVal 0)
					(if (and (not BitVal) (>= BScrap2 0) (>= HNSheet2 0))  ; ----> rotazione 90°
						(setq BitVal 90)
					)
				)
				
				(cond
					((= BitVal 0) 
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
						(setq Shape (list BShape1 HShape1 IdShape BitVal))
					)
					((= BitVal 90) ; ----> rotazione 90°
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
						(setq Shape (list BShape2 HShape2 IdShape BitVal))
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
	(defun PrintData (Id / LstData)
		(if Id
			(progn
				(setq LstData (nth 1  (assoc -3 (entget (nth 0 (GetEnameById Id)) (list "*")))))
				(princ "\nMarca ") (princ (cdr (nth 5  LstData)))
			)
		)
	)
	;
	;
	;
	(setq LstStock (list (list Sheet Origin)))

	(foreach CkShape LstShape
	
		(setq Continue T)
		(setq ContaStock 0)
		
		(while (and Continue  (nth ContaStock LstStock))
			
			
			;(PrintData (caddr CkShape))
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
					;(princ "\nNesting ok")
					;(getstring "----")
					;(setq LstNestedShape 	(append LstNestedShape (list (list CkShape (nth 1 (nth ContaStock LstStock))))))
					(setq LstNestedShape 	(append LstNestedShape (list (list (nth 4 Rtn) (nth 1 (nth ContaStock LstStock))))))
					;(princ "\n prima ") (princ (length LstStock))
					(setq LstStock 			(LM:RemoveNth ContaStock LstStock))
					;(princ "\n dopo  ") (princ (length LstStock))
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
							;(list 	(car  Origin)
							;		(cadr Origin)
							;)
					)
	)	
)
;
;
;
(defun ReportNesting (Sheet SheetId LstShapeNotAllocated LstNewSheet LstNestedShape / itm AreaShapeNotAllocated AreaScrap AreaShapeAllocated)

	; Sheet (1000.0 2500.0)
	; LstShapeNotAllocated ( (100 125 "123456") ....)
	; LstNewSheet		   ( ((1112 2534) (xori yori)) (....) )
	; LstNestedShape       ( ((1112 2534 "4566") (xori yori)) (....) )
	
	(princ "\n+---------------------------------------------------------------+")
	(princ "\n")
	(princ (strcat "\nReport Sheet " SheetID " " (rtos (car Sheet) 2 0) "x" (rtos (cadr Sheet) 2 0)))
	(princ "\n")
	(princ "\n+---------------------------------------------------------------+")

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
(defun SselCopy (Ssel Pstart Pend / conta CopyObj LstEname Rtn l)
	(if Ssel
		(progn
			(setq conta 0)
			(repeat (sslength Ssel)
				(setq CopyObj (vlax-ename->vla-object (entmakex (entget (ssname Ssel conta)))))
				(vla-Move CopyObj   (vlax-3d-point (car Pstart) (cadr Pstart) 0.0)
									(vlax-3d-point (car Pend)   (cadr Pend) 0.0))
				;(redraw (vlax-vla-object->ename CopyObj) 1)
				
				(CloneEname (ssname Ssel conta) (vlax-vla-object->ename CopyObj))
				(setq LstEname (append LstEname (list (vlax-vla-object->ename CopyObj))))
				(setq conta (1+ conta))
			)
			
			(setq l nil)
			(foreach  EnameShape LstEname
					(setq l (cons (vlax-ename->vla-object EnameShape) l))
			)
			(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) (Random_Str 9)) 'appenditems l)
			
			(setq Rtn (LstEname->Ssget LstEname))
		)
	)
)

;
;
;
(defun PrintNestingSheet (Origin LstNestedShape LstShapeNotAllocated / itm Shape Rotation OriginNewShape OriginOldShape 
																	   Ssel GrpName old_OSMODE conta PtRotation EnameShape)
	
	;
	; Grafica nesting +++
	;
	; LstShapeNotAllocated ( (100 125 "123456") ....)
	; LstNestedShape       ( ((1112 2534 "4566" rotazione) (xori yori)) (....) )
	
	(if (and Origin LstNestedShape)
		(progn
			
			(foreach itm LstNestedShape
				;(setq xxx itm)
				;(terpri) (princ ">>>> ") (princ itm)
				
				(setq Shape       	 (list (car (car itm)) (cadr (car itm)))) 			;(princ " ok1 \n")
				(setq IdShape 		 (caddr (car itm))) 								;(princ " ok2 \n")
				(setq Rotation		 (cadddr (car itm))) 								;(princ " ok3 \n")
				(setq OriginNewShape (cadr itm)) 										;(princ " ok4 \n")
				(setq EnameShape 	 (nth 0 (GetEnameById IdShape)))
				
				(vla-getboundingbox  (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
				(setq OriginOldShape (vlax-safearray->list mnl))
				;(setq OriginOldShape (GetOriginShape (nth 0 (GetEnameById IdShape)))) 	(princ " ok4 \n")
				
							
				;(terpri) (princ "++++ ") (princ Shape)
				;(terpri) (princ "---- ") (princ OriginNewShape)
				;(terpri) (princ "**** ") (princ OriginOldShape)
				;(getstring)
				(setq Ssel (SelectShape EnameShape))
				(redraw)
				;(setq Clone$ T)
				;(setq old_OSMODE   (getvar "OSMODE"))
				;(setvar "OSMODE" 0)
				(setq Ssel (SselCopy Ssel OriginOldShape OriginNewShape))
				;(command "_Copy" Ssel "" OriginOldShape OriginNewShape)
				;(princ "\n---------> ")(princ OriginNewShape) (princ " ") (princ (car Shape)) (princ " <---------\n")
				(if (/= Rotation 0)
					(progn
						;(command "_Rotate" Ssel "" (list (+ (car OriginNewShape)  (/ (- (car Shape) $MargineAccosto) 2.0))
						;								  (+ (cadr OriginNewShape) (/ (- (car Shape) $MargineAccosto $MargineAccosto) 2.0))) Rotation))
						(setq conta 0)
						(setq PtRotation (vlax-3d-point (+ (car OriginNewShape)  (/ (- (car Shape) $MargineAccosto) 2.0))
													    (+ (cadr OriginNewShape) (/ (- (car Shape) $MargineAccosto $MargineAccosto) 2.0))
														0.0))
						(repeat (sslength Ssel)
							(vla-Rotate (vlax-ename->vla-object (ssname Ssel conta)) PtRotation (/ (* Rotation PI) 180.0))
							(redraw (ssname Ssel conta) 1)
							(setq conta (1+ conta))															   
						)
					)
				)
				
				;(redraw)
				;(setvar "OSMODE" old_OSMODE)
				;(setq Clone$ nil)
					
				;(setq GrpName (Gnames (nth 0 EasyCutLstEnameCopy$)))
				;(CloneShape&Trigger (nth 0 GrpName))
				
				
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
							
						; ordinamento per area +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						
						(setq Chk1 "")
						(setq Chk2 "")
						
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
						
						; ordinamento per altezza +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							
						;(setq Chk1 (strcat Chk1 (CompleteString (rtos (cadr e1) 2 0) MaxRecordSort "0")))
						;(setq Chk2 (strcat Chk2 (CompleteString (rtos (cadr e2) 2 0) MaxRecordSort "0")))

						;(repeat (- MaxRecordSort (strlen (rtos (cadr e1) 2 0)))
						;	(setq Chk1 (strcat Chk1 "0"))
						;)
						;(setq Chk1 (strcat Chk1 (rtos (cadr e1) 2 0)))
						;
						;(repeat (- MaxRecordSort (strlen (rtos (cadr e2) 2 0)))
						;	(setq Chk2 (strcat Chk2 "0"))
						;)
						;(setq Chk2 (strcat Chk2 (rtos (cadr e2) 2 0)))
					
						; ordinamento per base ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

	; ("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/12/2018")
	
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
	(setq LstInfoTable (list "IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "MKSHAPE" "QTASHAPE" "TKSHAPE" "LENGTHSHAPE" "HEIGHTSHAPE" "MATSHAPE" "LASTMODIFYSHAPE" "JOUSHAPE"))
	
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
		((= Operators "=")
			(cond
				((= Segno1 Segno2) 
					(if (= Val1 Val2)
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
						
						(if (and (EvalString Chk ">=" (nth (+ Conta 1) LstItm) Mode) 
								 (EvalString Chk "<=" (nth (+ Conta 2) LstItm) Mode))
								(setq Rtn T)
						)
						(setq Conta (+ Conta 4))
					)
					
					((and (= (nth Conta LstItm) "[") (= (nth (+ Conta 1) LstItm) "]"))
						(setq Rtn T)
						(setq Conta (+ Conta 2))
					)
					
					
					((= (substr (nth Conta LstItm) 1 1) "-")
						(if (EvalString Chk "=" (substr (nth Conta LstItm) 2 (strlen (nth Conta LstItm)))  Mode)
							(setq Rtn nil Loop nil)
							(setq Rtn T)
						)
						(setq Conta (1+ Conta))
					)
					
					((EvalString Chk "=" (nth Conta LstItm) Mode)
						(setq Rtn T)
						(setq Conta (1+ Conta))
					)
					
					(t
						(setq Conta (1+ Conta))
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
(defun SplitChoiseFilter (FilterString  / AcceptString ChekString StringToList
										  SplitFilterString ControlPre Conta Check Control
										  Rtn Loop Nchr)
	
	;
	;
	; (AcceptString "abcdefghilmnopqrstuvzwxyjkABCDEFGHILMNOPQRSTUVZWXYJK01234567890,-.<>" "SDFSDF")
	(defun AcceptString (StrControl ChekStr / loop conta Rtn)
			
		(setq conta 1)
		(setq Rtn T)
		(setq loop T)
		(if (and StrControl ChekStr)
			
			(while Loop
				(if (not (vl-string-position (ascii (substr ChekStr conta 1)) StrControl))
					(progn
						(setq Loop nil)
						(setq Rtn nil)
					)
				)
				
				(setq conta (1+ conta))
				
				(if (> conta (strlen ChekStr)) 
					(setq Loop nil)
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(defun ChekString (Str Check Pos / Rtn)
	
		(if (and Str Check Pos)
			(if (and	(> (strlen Str) 1)
						(= (substr Str Pos 1) Check)
				)
				(setq Rtn T)
			)
		)
		Rtn
	)
	;
	;
	;
	(defun StringToList (String Char / StringSplit Rtn Conta)
	
		(if (and String Char)
			(progn
				(setq conta 0)
				(setq StringSplit (splitxt String Char))
				(if StringSplit
					(repeat (length StringSplit)
						(setq Rtn (append Rtn (list (nth Conta StringSplit))))
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
	(if FilterString
		(progn
			
			(while (vl-string-search " " FilterString)
						(setq FilterString (vl-string-subst "" " " FilterString))
			)
			
			(if (AcceptString "abcdefghilmnopqrstuvzwxyjkABCDEFGHILMNOPQRSTUVZWXYJK01234567890,-_.<>/" FilterString)
				(progn
				
					(setq Rtn "")
					(setq SplitFilterString (splitxt FilterString ","))
					(setq Conta 0)
					(setq Check T)
					
					(if SplitFilterString 
						(progn
						
							(setq Loop (nth Conta SplitFilterString))
							
							(while Loop

								(if (= (substr Loop 1 1) "<")
									(setq ControlPre 1)
								)

								(cond
									((> (length SplitFilterString) 1)
									
										
										(setq Nchr (strlen Loop))
								
										(cond
										
											((= Loop "<>")
												(setq Control 3)
											)
											
											(	(and (vl-string-search "<" Loop)
													 (vl-string-search ">" Loop)
												)
												;(princ "\n -------- 1 ")
												(setq Control -1)
											)
											
											(	(= ControlPre 1)
												;(princ "\n -------- 2 ")
												(if (ChekString Loop "<" 1) 		(setq Control 0 ControlPre 0) (setq Control -1))
											)
											
											(	(= ControlPre 0)
												;(princ "\n -------- 3 ")
												(if (ChekString Loop ">" Nchr) 	(setq Control 1 ControlPre nil) (setq Control -1))
											)
												
											(t 
												;(princ "\n -------- 4 ")
												(if (and (not (vl-string-search "<" Loop))
													     (not (vl-string-search ">" Loop))
												    )
												
													(setq Control 2)
													(setq Control -1)
												)
											)
										)
									)
									
									(t
										;(princ "\n entro T ")
										(cond
											((= Loop "<>")
												(setq Control 3)
											)
											((not  (and (vl-string-search "<" Loop)
													    (vl-string-search ">" Loop)))
												(setq Control 2)
											)
											(t
												(setq Control -1)
											)
										)
									)
								)
	
								;(princ "\n----->") (princ Control) (getstring "")
					
								(cond 
									((= Control 0)
										(if (AcceptString "abcdefghilmnopqrstuvzwxyjkABCDEFGHILMNOPQRSTUVZWXYJK01234567890,-_/." (substr Loop 2 (strlen Loop)))
											(setq Rtn (strcat Rtn " [ " (substr Loop 2 (strlen Loop))))
											(setq Check nil)
										)
										(setq Conta (1+ Conta))
									)
									((= Control 1)
										(if (AcceptString "abcdefghilmnopqrstuvzwxyjkABCDEFGHILMNOPQRSTUVZWXYJK01234567890,-/." (substr Loop 1 (- (strlen Loop) 1)))
											(setq Rtn (strcat Rtn " " (substr Loop 1 (- (strlen Loop) 1)) " ] "))
											(setq Check nil)
										)
										(setq Conta (1+ Conta))
									)
									((= Control 2)
										(if (AcceptString "abcdefghilmnopqrstuvzwxyjkABCDEFGHILMNOPQRSTUVZWXYJK01234567890,-_/." Loop)
											(setq Rtn (strcat Rtn " " Loop))
											(setq Check nil)
										)
										(setq Conta (1+ Conta))
									)
									((= Control 3)
										(setq Rtn " [ ] ")
										(setq Conta 10000)
									)
									(t
										(setq Check nil)
										(setq Conta (1+ Conta))
									)
								)
								(if (not Check)
									(setq Loop nil)
									(setq Loop (nth Conta SplitFilterString))
								)
							)
						)
					)
				)
			)
		)
	)
	(if Check (StringToList Rtn " ") nil)
)
;
;
;
(defun CheckFilterString (FilterString Mode / PosCharString ChekString
											  Rtn Conta Loop)
	

	(defun PosCharString (Str Char / conta Rtn)
		(if (and Str Char)
			(progn
				(setq conta 1)
				(repeat (strlen Str)
					(if (= (substr Str conta 1) Char)
						(setq Rtn (append Rtn (list Conta)))
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
	(defun ChekString (Str / Nchar Rtn1 Rtn2)
		(if Str
			(progn
			
				;(if (setq Nchar (PosCharString Str "-"))
				;	(cond
				;		((> (length Nchar) 1)
				;			(setq Rtn1 nil)
				;	)
				;		((and (= (length Nchar) 1) (= (nth 0 Nchar) 1))
				;			(setq Rtn1 T)
				;		)
				;	)
				;	(setq Rtn1 T)
				;)
				(setq Rtn1 T)
				
				(if (setq Nchar (PosCharString Str "."))
					(cond
						((> (length Nchar) 1)
							(setq Rtn2 nil)
						)
						((and (= (length Nchar) 1) (= (length (splitxt Str ".")) 2))
							(setq Rtn2 T)
						)
					)
					(setq Rtn2 T)
				)
							
			)
		)
		(if (and Rtn1 Rtn2) T nil)
	)					
	;
	;
	;
	(if FilterString
		(progn
			(setq Rtn (SplitChoiseFilter FilterString))
			(if Rtn
				(progn
					(setq Conta 0)
					(setq Loop  T)
					;
					;(princ "\n+++++") (princ Rtn) (princ "+++++\n") 
					; controllo dati
					(if Rtn
						(while (and Loop (nth conta Rtn))
						
							(cond
							
								((and (= (nth Conta Rtn) "[") (= (nth (+ Conta 3) Rtn) "]"))
									
									(if (EvalString (nth (+ Conta 2) Rtn) ">=" (nth (+ Conta 1) Rtn) Mode)
										(setq Conta (+ 4 Conta))
										(progn
											(setq Loop nil)
											(setq Rtn nil)
										)
									)
								)
								
								((and (= (nth Conta  Rtn) "[") (= (nth (+ Conta 1) Rtn) "]")) 
									(setq Conta (+ 2 Conta))
								)
								
								(t
									(if (not (ChekString (nth Conta  Rtn)))
										(progn
											(setq Loop nil)
											(setq Rtn nil)
										)
									)
									(setq Conta (1+ Conta))
										
								)
							)
						)
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
(defun LogicFilterSelectStockShape (	Prg_
										Id_
										Order_
										Phase_
										Mark_
										Quantity_
										Thikness_
										Length_
										Height_
										Material_
										Date_
										Cut_
										;
										PrgFilter 
										IdFilter 
										OrderFilter 
										PhaseFilter
										MarkFilter
										QuantityFilter
										ThiknessFilter
										LengthFilter
										HeightFilter
										MaterialFilter 
										DateFilter
										CutFilter
										/ Rtn)
						  
						  
	(if (and Prg_ Id_ Order_ Phase_ Mark_ Quantity_ Thikness_ Length_ Height_ Material_ Date_ Cut_
			 PrgFilter IdFilter OrderFilter PhaseFilter MarkFilter QuantityFilter ThiknessFilter LengthFilter HeightFilter MaterialFilter DateFilter CutFilter)
			 
		(if (and (LogicFilter Prg_       	PrgFilter 		2)
				 (LogicFilter Id_       	IdFilter 		2)
				 (LogicFilter Order_    	OrderFilter 	2)
				 (LogicFilter Phase_    	PhaseFilter 	2)
				 (LogicFilter Mark_     	MarkFilter  	2)
				 (LogicFilter Quantity_ 	QuantityFilter 	1)
				 (LogicFilter Thikness_ 	ThiknessFilter 	1)
				 (LogicFilter Length_   	LengthFilter   	1)
				 (LogicFilter Height_   	HeightFilter   	1)
				 (LogicFilter Material_ 	MaterialFilter 	2)
				 (LogicFilter Date_ 	   	DateFilter 		2)
				 (LogicFilter Cut_     		CutFilter 		2)
			)
			(setq Rtn T)
		)
		;(if  (LogicFilter Mark_ 	MarkFilter  	2)
		;	(setq Rtn T)
		;)

	)
	Rtn
)
;
;
;
(defun LogicFilterSelectStockSheet (Prg
									Id
									Name
									Width
									Height
									Thikness
									Material
									;
									PrgFilter
									IdFilter
									NameFilter
									WidthFilter
									HeightFilter
									ThiknessFilter
									MaterialFilter / Rtn)
						  
		           
						  
	(if (and Prg Id Name Width Height Thikness Material
			 PrgFilter IdFilter NameFilter WidthFilter HeightFilter ThiknessFilter  MaterialFilter)
			 
		(if (and (LogicFilter Prg      PrgFilter      1)
				 (LogicFilter Id       IdFilter       2)
				 (LogicFilter Name     NameFilter     2)
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
						(MakeSheet (list 	(Random_Str 5) 
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
	(defun AddStockList (StockList / StockList StockSheet QtaSheet WidthSheet HeightSheet ThickSheet MatSheet itm Record)
		
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
					(if (vl-string-search (strcase "STK") (strcase StockSheet))
						(progn
							(alert "Cambia nome allo stock")
							(setq StockSheet "")
						)
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
					(setq StockList (list (list StockSheet WidthSheet HeightSheet ThickSheet QtaSheet (strcase MatSheet))))
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
(defun GuiSelPiecesSheet (/ FormatTableNesting GetRecordNesting SetRecordNesting GetFilterList SelectAllBoxList GetDataBoxList SelectItmBoxList
							LstTableNesting Loop xx accept save FileOut Rtn
							$ActiveFilterPrg$  $ActiveFilterId$ $ActiveFilterName$ $ActiveFilterWidth$ $ActiveFilterHeight$ $ActiveFilterThikness$ $ActiveFilterMaterial$
							$PrgFilter$ $IdFilter$ $NameFilter$ $WidthFilter$ $HeightFilter$ $ThiknessFilter$ $MaterialFilter$
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
	(defun SetRecordNesting (LstTableNesting / itm LstFilter ErrorFilter Conta Rtn
											   Value  
											   ErrorPrgFilter
											   ErrorIdFilter
											   ErrorNameFilter
											   ErrorWidthFilter
											   ErrorHeightFilter
											   ErrorThiknessFilter
											   ErrorMaterialFilter)
											   
		;(IdSheet 		NameSheet 		Widthsheet 	HeightSheet  ThickSheet  SurfaceSheet  WeightSheet  MatSheet)
		;("072488826" 	"STK_GGGG_2" 	"2500" 		"5000" 		 "20" 		 "12.5" 	   "1962.5" 	"dddd")
		;					1			  1			1			 1										1
		(if LstTableNesting
			(progn
				(mode_tile "box_label" 2)
				
				(setq $ActiveFilterPrg$    		(get_tile "ActiveFilterPrg"))
				(setq $ActiveFilterId$    		(get_tile "ActiveFilterId"))
				(setq $ActiveFilterName$    	(get_tile "ActiveFilterName"))
				(setq $ActiveFilterWidth$	    (get_tile "ActiveFilterWidth"))
				(setq $ActiveFilterHeight$	    (get_tile "ActiveFilterHeight"))
				(setq $ActiveFilterThikness$	(get_tile "ActiveFilterThikness"))
				(setq $ActiveFilterMaterial$    (get_tile "ActiveFilterMaterial"))
				

				; ---------------------------------- PrgFilter
				(if (= $ActiveFilterPrg$ "1")
					(progn
						(mode_tile "PrgFilter" 0) ; attivo
						(setq Value (get_tile "PrgFilter"))
						(if (CheckFilterString Value 1)	
							(progn
								(setq LstFilter (append LstFilter (list (get_tile "PrgFilter"))))
								(setq $PrgFilter$ Value)
							)
							(setq ErrorPrgFilter T)
						)
					)
					(progn
						(mode_tile "PrgFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- IdFilter
				(if (= $ActiveFilterId$ "1")
					(progn
						(mode_tile "IdFilter" 0) ; attivo
						(setq Value (get_tile "IdFilter"))
						(if (CheckFilterString Value 2)	
							(progn
								(setq LstFilter (append LstFilter (list (get_tile "IdFilter"))))
								(setq $IdFilter$ Value)
							)
							(setq ErrorIdFilter T)
						)
					)
					(progn
						(mode_tile "IdFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- LengthFilter
				(if (= $ActiveFilterName$ "1")
					(progn
						(mode_tile "NameFilter" 0) ; attivo
						(setq Value (get_tile "NameFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list (get_tile "NameFilter"))))
								(setq $NameFilter$ Value)
							)
							(setq ErrorNameFilter T)
						)
								
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
						(setq Value (get_tile "WidthFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list (get_tile "WidthFilter"))))
								(setq $WidthFilter$ Value)
							)
							(setq ErrorWidthFilter T)
						)
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
						(setq Value (get_tile "HeightFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list (get_tile "HeightFilter"))))
								(setq $HeightFilter$ Value)
							)
							(setq ErrorHeightFilter T)
						)
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
						(setq Value (get_tile "ThiknessFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list (get_tile "ThiknessFilter"))))
								(setq $ThiknessFilter$ Value)
							)
							(setq ErrorThiknessFilter T)
						)
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
						(setq Value (get_tile "MaterialFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list (get_tile "MaterialFilter"))))
								(setq $MaterialFilter$ Value)
							)
							(setq ErrorMaterialFilter T)
						)
					)
					(progn
						(mode_tile "MaterialFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ----------------------------------
				;$PrgFilter$
				;$IdFilter$
				;$NameFilter$
				;$WidthFilter$
				;$HeightFilter$
				;$ThiknessFilter$
				;$MaterialFilter$
				
				(if (and 	(not ErrorPrgFilter)
							(not ErrorIdFilter)
							(not ErrorNameFilter)
							(not ErrorWidthFilter)
							(not ErrorHeightFilter)
							(not ErrorThiknessFilter)
							(not ErrorMaterialFilter)
					)
						(setq ErrorFilter nil)
						
						(progn
							(if ErrorPrgFilter			(alert "Possibile errore di sintassi ITEM"))
							(if ErrorIdFilter			(alert "Possibile errore di sintassi ID"))
							(if ErrorNameFilter			(alert "Possibile errore di sintassi NAME"))
							(if ErrorWidthFilter		(alert "Possibile errore di sintassi WIDTH"))
							(if ErrorHeightFilter		(alert "Possibile errore di sintassi HEIGHT"))
							(if ErrorThiknessFilter		(alert "Possibile errore di sintassi THIKNESS"))
							(if ErrorMaterialFilter		(alert "Possibile errore di sintassi MATERIAL"))
						)
				)
				
				
				(if (null ErrorFilter)
					(progn
						(set_tile "box_info" "")
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
		            
					(if (LogicFilterSelectStockSheet (nth 0 Split) (nth 1 Split) (nth 2 Split) (nth 3 Split) (nth 4 Split) (nth 5 Split) (nth 8 Split)
													 (nth 0 LstFilter)
													 (nth 1 LstFilter)
													 (nth 2 LstFilter)
													 (nth 3 LstFilter)
													 (nth 4 LstFilter)
													 (nth 5 LstFilter)
													 (nth 6 LstFilter))
											
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
	(defun SelectItmBoxList (KeyName)
		(if KeyName
			(get_tile keyName)
		)
	)	
	;
	;
	;
	(defun SelectAllBoxList (KeyName LstTableNesting / Select conta)
	
		(if (and KeyName LstTableNesting)
			(progn
				(setq Select "")
				(setq conta 0)
				(foreach itm LstTableNesting
					(setq Select (strcat Select (rtos conta 2 0) " "))
					(setq conta (1+ conta))
				)
				(set_tile KeyName Select)
			)
		)
	)
	;
	;
	;
	(defun GetDataBoxList (KeyName LstTableNesting Nth_ / Get_Tile_List LstItmSelect itm SplitRow Rtn TmpLst)
	
		(defun Get_Tile_List (KeyName / itm itemsplit Rtn)
			(setq itm (get_tile KeyName))
			;(alert itm)
			(cond
				((= itm "") (setq rtn nil))
				(t
					(foreach itemsplit (splitxt itm " ")
						(setq Rtn (append rtn (list itemsplit)))
					)
				)
			)
			Rtn
		)
		;
		;
		;
		(if (and KeyName LstTableNesting)
			(progn
				(setq LstItmSelect (Get_Tile_List KeyName))
				(foreach itm LstItmSelect
					(setq SplitRow (splitxt (nth (atoi itm)  LstTableNesting) "\t"))
					(if Nth_
						(setq Rtn (append Rtn (list (nth Nth_ SplitRow))))
						(progn
							(foreach itm1 SplitRow
								(setq TmpLst (append TmpLst (list itm1)))
							)
							(setq Rtn (append Rtn (list TmpLst)))
							(setq TmpLst nil)
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
	
	;PrgFilter
	;IdFilter
	;NameFilter
	;WidthFilter
	;HeightFilter
	;ThiknessFilter
	;MaterialFilter

	(setq $ActiveFilterPrg$ 		"0")
	(setq $ActiveFilterId$ 			"0")
	(setq $ActiveFilterName$ 		"0")
	(setq $ActiveFilterWidth$		"0")
	(setq $ActiveFilterHeight$		"0")
	(setq $ActiveFilterThikness$	"0")
	(setq $ActiveFilterMaterial$	"0")
	

	(setq $PrgFilter$ 				"<>")
	(setq $IdFilter$ 				"<>")
	(setq $NameFilter$ 				"<>")
	(setq $WidthFilter$				"<>")
	(setq $HeightFilter$			"<>")
    (setq $ThiknessFilter$ 			"<>")
    (setq $MaterialFilter$ 			"<>")
	
	(if LstTableNesting
		(progn
				(setq ok nil)
				(setq save nil)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(new_dialog "InfoTableStockSheetNesting" xx "" (cond ( *InfoTableStockSheetNesting* ) ( '(-1 -1) )))
				(start_list "box_info")
					(mapcar 'add_list LstTableNesting)
				(end_list)
				
				(set_tile  "ActiveFilterPrg"			$ActiveFilterPrg$)
				(set_tile  "ActiveFilterId"				$ActiveFilterId$)	
				(set_tile  "ActiveFilterName"			$ActiveFilterName$)	
				(set_tile  "ActiveFilterWidth"	    	$ActiveFilterWidth$)
				(set_tile  "ActiveFilterHeight"	    	$ActiveFilterHeight$)
                (set_tile  "ActiveFilterThikness"	    $ActiveFilterThikness$)
                (set_tile  "ActiveFilterMaterial"	    $ActiveFilterMaterial$)
			
				(set_tile  "PrgFilter"					$PrgFilter$)
				(set_tile  "IdFilter"					$IdFilter$)
				(set_tile  "NameFilter"					$NameFilter$)
				(set_tile  "WidthFilter"				$WidthFilter$)
				(set_tile  "HeightFilter"				$HeightFilter$)
				(set_tile  "ThiknessFilter"				$ThiknessFilter$)
				(set_tile  "MaterialFilter"				$MaterialFilter$)
				
				;(if (= $ActiveFilterPrg$		"1")	(mode_tile "PrgFilter"     	0)	(mode_tile "PrgFilter"	    1))
				;(if (= $ActiveFilterId$     	"1")	(mode_tile "IdFilter"     	0)	(mode_tile "IdFilter"	    1))
				;(if (= $ActiveFilterName$   	"1")	(mode_tile "NameFilter"     0)	(mode_tile "NameFilter" 	1))
				;(if (= $ActiveFilterWidth$   	"1")	(mode_tile "WidthFilter"    0)	(mode_tile "WidthFilter"    1))
				;(if (= $ActiveFilterHeight$   	"1")	(mode_tile "HeightFilter"   0)	(mode_tile "HeightFilter"   1))
				;(if (= $ActiveFilterThikness$ 	"1")	(mode_tile "ThiknessFilter" 0)	(mode_tile "ThiknessFilter" 1))
				;(if (= $ActiveFilterMaterial$ 	"1")	(mode_tile "MaterialFilter" 0)	(mode_tile "MaterialFilter" 1))

				(mode_tile "PrgFilter"	    1)
				(mode_tile "IdFilter"	    1)
				(mode_tile "NameFilter" 	1)
				(mode_tile "WidthFilter"    1)
				(mode_tile "HeightFilter"   1)
				(mode_tile "ThiknessFilter" 1)
				(mode_tile "MaterialFilter" 1)

				(mode_tile "box_label" 2)

				(setq Rtn (SetRecordNesting LstTableNesting))
				

				(action_tile "ActiveFilterPrg"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterId"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterName"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterWidth"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterHeight"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterThikness"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterMaterial"	"(setq Rtn (SetRecordNesting LstTableNesting))")

				(action_tile "PrgFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
 				(action_tile "IdFilter"				"(setq Rtn (SetRecordNesting LstTableNesting))")
 				(action_tile "NameFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "WidthFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "HeightFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
                (action_tile "ThiknessFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
                (action_tile "MaterialFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")

				(action_tile "box_info"				"(SelectItmBoxList \"box_info\")")
				(action_tile "selectall"			"(SelectAllBoxList \"box_info\" (SetRecordNesting LstTableNesting))")
				(action_tile "import"				(strcat "(if (GetDataBoxList \"box_info\" Rtn nil)"
															"    (progn"
															"       (setq Rtn (GetDataBoxList \"box_info\" Rtn nil))"
															"       (setq accept T *InfoTableNesting* (done_dialog))"
															"       (unload_dialog xx)"
															"     )"
															"    (alert \"Nessun file selezionato\")"
															")"
													))
				(action_tile "save"					(strcat "(if (GetDataBoxList \"box_info\" Rtn nil)"
															"    (progn"
															"       (setq Rtn (GetDataBoxList \"box_info\" Rtn nil))"
															"       (setq save T *InfoTableNesting* (done_dialog))"
															"       (unload_dialog xx)"
															"     )"
															"    (alert \"Nessun file selezionato\")"
															")"
													))
				(action_tile "list"					(strcat "(if (GetDataBoxList  \"box_info\" Rtn nil)"
															"	 (ListNesting \"SHEET\" (GetDataBoxList  \"box_info\" Rtn nil))"
															"	 (alert \"Nessun file selezionato\")"
															")"
													))
				(action_tile "cancel"				"(setq Rtn nil *InfoTableNestingDstv* (done_dialog)) (unload_dialog xx)")

				(start_dialog)
		)
	)
	(cond
		((= accept T)
			(setq FileOut (strcat DxfNestingEasyCut$ "StdSheet.sht"))
			(WriteFileNesting "SHEET" Rtn FileOut)
		)
		((= save T)
			(setq FileOut (getfiled "Select File Sheet" DxfNestingEasyCut$ "sht" 1))
			(WriteFileNesting "SHEET" Rtn FileOut)
		)
	)
	
	(list FileOut Rtn)
)
;
;
;
(defun GuiSelPiecesShape (/ FormatTableNesting GetRecordNesting SetRecordNesting GetFilterList GetDataBoxList SelectAllBoxList SelectItmBoxList
							LstTableNesting Loop xx accept save FileOut Rtn)
							
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
	(defun SetRecordNesting (LstTableNesting /  itm LstFilter ErrorFilter 
												ErrorPrgFilter
												ErrorIdFilter
												ErrorOrderFilter
												ErrorPhaseFilter
												ErrorMarkFilter
												ErrorQuantityFilter
												ErrorThiknessFilter
												ErrorLengthFilter
												ErrorHeightFilter
												ErrorMaterialFilter
												ErrorDateFilter
												ErrorCutFilter
												Value
												Conta Rtn)
	
		(if LstTableNesting
			(progn
				(mode_tile "box_label" 2)
				
				(setq $ActiveFilterPrg$ 		(get_tile "ActiveFilterPrg"))
				(setq $ActiveFilterId$ 			(get_tile "ActiveFilterId"))
				(setq $ActiveFilterOrder$ 		(get_tile "ActiveFilterOrder"))
				(setq $ActiveFilterPhase$  		(get_tile "ActiveFilterPhase"))
				(setq $ActiveFilterMark$     	(get_tile "ActiveFilterMark"))
				(setq $ActiveFilterQuantity$    (get_tile "ActiveFilterQuantity"))
				(setq $ActiveFilterThikness$	(get_tile "ActiveFilterThikness"))
				(setq $ActiveFilterLength$	    (get_tile "ActiveFilterLength"))
				(setq $ActiveFilterHeight$	    (get_tile "ActiveFilterHeight"))
				(setq $ActiveFilterMaterial$    (get_tile "ActiveFilterMaterial"))
				(setq $ActiveFilterDate$    	(get_tile "ActiveFilterDate"))
				(setq $ActiveFilterCut$    		(get_tile "ActiveFilterCut"))
				
				;(alert (strcat $ActiveFilterOrder$ " " $ActiveFilterPhase$ " " $ActiveFilterMark$ " " $ActiveFilterThikness$ " " $ActiveFilterMaterial$))
				; ---------------------------------- PrgFilter 
				(if (= $ActiveFilterPrg$ "1")
					(progn
						(mode_tile "PrgFilter" 0) ; attivo
						(setq Value (get_tile "PrgFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $PrgFilter$ Value)
							)
							(setq ErrorIdFilter T)
						)
					)
					(progn
						(mode_tile "PrgFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- IdFilter 
				(if (= $ActiveFilterId$ "1")
					(progn
						(mode_tile "IdFilter" 0) ; attivo
						(setq Value (get_tile "IdFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $IdFilter$ Value)
							)
							(setq ErrorIdFilter T)
						)
					)
					(progn
						(mode_tile "IdFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- OrderFilter 
				(if (= $ActiveFilterOrder$ "1")
					(progn
						(mode_tile "OrderFilter" 0) ; attivo
						(setq Value (get_tile "OrderFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $OrderFilter$ Value)
							)
							(setq ErrorOrderFilter T)
						)
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
						(setq Value (get_tile "PhaseFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $PhaseFilter$ Value)
							)
							(setq ErrorPhaseFilter T)
						)
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
						(setq Value (get_tile "MarkFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $MarkFilter$ Value)
							)
							(setq ErrorMarkFilter T)
						)
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
						(setq Value (get_tile "QuantityFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $QuantityFilter$ Value)
							)
							(setq ErrorQuantityFilter T)
						)
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
						(setq Value (get_tile "ThiknessFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $ThiknessFilter$ Value)
							)
							(setq ErrorThiknessFilter T)
						)
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
						(setq Value (get_tile "LengthFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $LengthFilter$ Value)
							)
							(setq ErrorLengthFilter T)
						)
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
						(setq Value (get_tile "HeightFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $HeightFilter$ Value)
							)
							(setq ErrorHeightFilter T)
						)
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
						(setq Value (get_tile "MaterialFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $MaterialFilter$ Value)
							)
							(setq ErrorMaterialFilter T)
						)
					)
					(progn
						(mode_tile "MaterialFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- DateFilter
				(if (= $ActiveFilterDate$ "1")
					(progn
						(mode_tile "DateFilter" 0) ; attivo
						(setq Value (get_tile "DateFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $DateFilter$ Value)
							)
							(setq ErrorDateFilter T)
						)
					)
					(progn
						(mode_tile "DateFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- CutFilter
				(if (= $ActiveFilterCut$ "1")
					(progn
						(mode_tile "CutFilter" 0) ; attivo
						(setq Value (get_tile "CutFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $CutFilter$ Value)
							)
							(setq ErrorCutFilter T)
						)
					)
					(progn
						(mode_tile "CutFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ----------------------------------

				(if (and 	(not ErrorPrgFilter)
							(not ErrorIdFilter)
							(not ErrorOrderFilter)
							(not ErrorPhaseFilter)
							(not ErrorMarkFilter)
							(not ErrorQuantityFilter)
							(not ErrorThiknessFilter)
							(not ErrorLengthFilter)
							(not ErrorHeightFilter)
							(not ErrorMaterialFilter)
							(not ErrorDateFilter)
							(not ErrorCutFilter)
					)
						(setq ErrorFilter nil)
						
						(progn
							(if ErrorPrgFilter			(alert "Possibile errore di sintassi ITEM"))
							(if ErrorIdFilter			(alert "Possibile errore di sintassi ID"))
							(if ErrorOrderFilter		(alert "Possibile errore di sintassi ORDER"))
							(if ErrorPhaseFilter		(alert "Possibile errore di sintassi PHASE"))
							(if ErrorMarkFilter			(alert "Possibile errore di sintassi MARK"))
							(if ErrorQuantityFilter		(alert "Possibile errore di sintassi QUANTITY"))
							(if ErrorThiknessFilter		(alert "Possibile errore di sintassi THIKNESS"))
							(if ErrorLengthFilter		(alert "Possibile errore di sintassi LENGTH"))
							(if ErrorHeightFilter		(alert "Possibile errore di sintassi HEIGTH"))
							(if ErrorMaterialFilter		(alert "Possibile errore di sintassi MATERIAL"))
							(if ErrorDateFilter			(alert "Possibile errore di sintassi DATE"))
							(if ErrorCutFilter			(alert "Possibile errore di sintassi CUT"))
						)
				)
					
				
				;(princ (strcat "\n" (nth 0 LstFilter) "--" (nth 1 LstFilter) "--" (nth 2 LstFilter) "--" (nth 3 LstFilter) "--" (nth 4 LstFilter)))
				
				(if (null ErrorFilter)
					(progn
						(set_tile "box_info" "")
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
					;	0	     1		  2      3      4      5    6    7        8       9			10			11
					; ("01" "026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/10/2018" "Antioraria")
					(if (LogicFilterSelectStockShape 	(nth 0 Split) (nth 1 Split) (nth 2 Split) (nth 3 Split) (nth 4 Split)  (nth 5 Split)
														(nth 6 Split) (nth 7 Split) (nth 8 Split) (nth 9 Split) (nth 10 Split) (nth 11 Split)
														(nth 0 LstFilter)
														(nth 1 LstFilter)
														(nth 2 LstFilter)
														(nth 3 LstFilter)
														(nth 4 LstFilter)
														(nth 5 LstFilter)
														(nth 6 LstFilter)
														(nth 7 LstFilter)
														(nth 8 LstFilter)
														(nth 9 LstFilter)
														(nth 10 LstFilter)
														(nth 11 LstFilter))
						(setq Rtn (append Rtn (list (strcat (rtos Conta 2 0) "\t"
															(nth 1 Split) "\t"
															(nth 2 Split) "\t"
															(nth 3 Split) "\t"
															(nth 4 Split) "\t"
															(nth 5 Split) "\t"
															(nth 6 Split) "\t"
															(nth 7 Split) "\t"
															(nth 8 Split) "\t"
															(nth 9 Split) "\t"
															(nth 10 Split) "\t"
															(nth 11 Split)
													)))
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
	(defun SelectItmBoxList (KeyName)
		(if KeyName
			(get_tile keyName)
		)
	)	
	;
	;
	;
	(defun SelectAllBoxList (KeyName LstTableNesting / Select conta)
	
		(if (and KeyName LstTableNesting)
			(progn
				(setq Select "")
				(setq conta 0)
				(foreach itm LstTableNesting
					(setq Select (strcat Select (rtos conta 2 0) " "))
					(setq conta (1+ conta))
				)
				(set_tile KeyName Select)
			)
		)
	)
	;
	;
	;
	(defun GetDataBoxList (KeyName LstTableNesting Nth_ / Get_Tile_List LstItmSelect itm SplitRow Rtn TmpLst)
	
		(defun Get_Tile_List (KeyName / itm itemsplit Rtn)
			(setq itm (get_tile KeyName))
			;(alert itm)
			(cond
				((= itm "") (setq rtn nil))
				(t
					(foreach itemsplit (splitxt itm " ")
						(setq Rtn (append rtn (list itemsplit)))
					)
				)
			)
			Rtn
		)
		;
		;
		;
		(if (and KeyName LstTableNesting)
			(progn
				(setq LstItmSelect (Get_Tile_List KeyName))
				(foreach itm LstItmSelect
					(setq SplitRow (splitxt (nth (atoi itm)  LstTableNesting) "\t"))
					(if Nth_
						(setq Rtn (append Rtn (list (nth Nth_ SplitRow))))
						(progn
							(foreach itm1 SplitRow
								(setq TmpLst (append TmpLst (list itm1)))
							)
							(setq Rtn (append Rtn (list TmpLst)))
							(setq TmpLst nil)
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
	
	;(if (not $ActiveFilterPrg$)		(setq $ActiveFilterPrg$			"1"))
	;(if (not $ActiveFilterId$)			(setq $ActiveFilterId$ 			"1"))
	;(if (not $ActiveFilterOrder$)		(setq $ActiveFilterOrder$ 		"1"))
	;(if (not $ActiveFilterPhase$)		(setq $ActiveFilterPhase$ 		"1"))
	;(if (not $ActiveFilterFamily$)		(setq $ActiveFilterFamily$ 		"1"))
	;(if (not $ActiveFilterMark$)		(setq $ActiveFilterMark$ 		"1"))
	;(if (not $ActiveFilterQuantity$)	(setq $ActiveFilterQuantity$ 	"1"))
	;(if (not $ActiveFilterName$)		(setq $ActiveFilterName$ 		"1"))
	;(if (not $ActiveFilterMaterial$)	(setq $ActiveFilterMaterial$	"1"))
	;(if (not $ActiveFilterThikness$)	(setq $ActiveFilterThikness$	"1"))
	;(if (not $ActiveFilterLength$)		(setq $ActiveFilterLength$		"1"))
	;(if (not $ActiveFilterHeight$)		(setq $ActiveFilterHeight$		"1"))
	;(if (not $ActiveFilterCut$)		(setq $ActiveFilterCut$			"1"))
	;(if (not $ActiveFilterDate$)		(setq $ActiveFilterDate$		"1"))
	;(if (not $ActiveFilterFlag1$)		(setq $ActiveFilterFlag1$		"1"))
	;(if (not $ActiveFilterFlag2$)		(setq $ActiveFilterFlag2$		"1"))
	;(if (not $ActiveFilterFlag3$)		(setq $ActiveFilterFlag3$		"1"))

	(setq $ActiveFilterPrg$			"0")
	(setq $ActiveFilterId$ 			"0")
	(setq $ActiveFilterOrder$ 		"0")
	(setq $ActiveFilterPhase$ 		"0")
	(setq $ActiveFilterFamily$ 		"0")
	(setq $ActiveFilterMark$ 		"0")
	(setq $ActiveFilterQuantity$ 	"0")
	(setq $ActiveFilterName$ 		"0")
	(setq $ActiveFilterMaterial$	"0")
	(setq $ActiveFilterThikness$	"0")
	(setq $ActiveFilterLength$		"0")
	(setq $ActiveFilterHeight$		"0")
	(setq $ActiveFilterCut$			"0")
	(setq $ActiveFilterDate$		"0")
	(setq $ActiveFilterFlag1$		"0")
	(setq $ActiveFilterFlag2$		"0")
	(setq $ActiveFilterFlag3$		"0")
	

	(if (not $PrgFilter$)		(setq $PrgFilter$ 				"<>"))			
	(if (not $IdFilter$)		(setq $IdFilter$ 				"<>"))			
	(if (not $OrderFilter$)		(setq $OrderFilter$ 			"<>"))			
    (if (not $PhaseFilter$)	 	(setq $PhaseFilter$ 			"<>"))			
    (if (not $FamilyFilter$)	(setq $FamilyFilter$ 			"<>"))	
	(if (not $MarkFilter$)		(setq $MarkFilter$ 				"<>"))
	(if (not $QuantityFilter$)	(setq $QuantityFilter$ 			"<>"))
	(if (not NameFilter$)		(setq $NameFilter$ 				"<>"))
	(if (not $MaterialFilter$)	(setq $MaterialFilter$ 			"<>"))
	(if (not $ThiknessFilter$)	(setq $ThiknessFilter$ 			"<>"))
	(if (not $LengthFilter$)	(setq $LengthFilter$			"<>"))
	(if (not $HeightFilter$)	(setq $HeightFilter$			"<>"))
	(if (not $CutFilter$)		(setq $CutFilter$				"<>"))
	(if (not $DateFilter$)		(setq $DateFilter$				"<>"))
	(if (not $Flag1Filter$)		(setq $Flag1Filter$				"<>"))
	(if (not $Flag2Filter$)		(setq $Flag2Filter$				"<>"))
	(if (not $Flag3Filter$)		(setq $Flag3Filter$				"<>"))
	
	
	(if LstTableNesting
		(progn
				(setq ok nil)
				(setq save nil)
				
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(new_dialog "InfoTableNesting" xx "" (cond ( *InfoTableNesting* ) ( '(-1 -1) )))
				(start_list "box_info")
					(mapcar 'add_list LstTableNesting)
				(end_list)
			

				(set_tile  "ActiveFilterPrg"	    	$ActiveFilterPrg$)			
				(set_tile  "ActiveFilterId"		    	$ActiveFilterId$)			
				(set_tile  "ActiveFilterOrder"		    $ActiveFilterOrder$)			
				(set_tile  "ActiveFilterPhase"		    $ActiveFilterPhase$)			
				(set_tile  "ActiveFilterMark"			$ActiveFilterMark$)	
				(set_tile  "ActiveFilterQuantity"		$ActiveFilterQuantity$)
				(set_tile  "ActiveFilterThikness"	    $ActiveFilterThikness$)
				(set_tile  "ActiveFilterLength"	    	$ActiveFilterLength$)
				(set_tile  "ActiveFilterHeight"	    	$ActiveFilterHeight$)
				(set_tile  "ActiveFilterMaterial"	    $ActiveFilterMaterial$)
				(set_tile  "ActiveFilterDate"	    	$ActiveFilterDate$)
				(set_tile  "ActiveFilterCut"		    $ActiveFilterCut$)
			
				(set_tile  "PrgFilter"					$PrgFilter$)			
				(set_tile  "IdFilter"					$IdFilter$)			
				(set_tile  "OrderFilter"				$OrderFilter$)			
				(set_tile  "PhaseFilter"				$PhaseFilter$)			
				(set_tile  "MarkFilter"					$MarkFilter$)
				(set_tile  "QuantityFilter"				$QuantityFilter$)
				(set_tile  "ThiknessFilter"				$ThiknessFilter$)
				(set_tile  "LengthFilter"				$LengthFilter$)
				(set_tile  "HeightFilter"				$HeightFilter$)
				(set_tile  "MaterialFilter"				$MaterialFilter$)
				(set_tile  "DateFilter"					$DateFilter$)
				(set_tile  "CutFilter"					$CutFilter$)
				
				;(if (= $ActiveFilterPrg$    	"1")	(mode_tile "PrgFilter"    	0)	(mode_tile "PrgFilter" 	   1))
				;(if (= $ActiveFilterId$    	"1")	(mode_tile "IdFilter"    	0)	(mode_tile "IdFilter" 	   1))
				;(if (= $ActiveFilterOrder$    	"1")	(mode_tile "OrderFilter"    0)	(mode_tile "OrderFilter"    1))
				;(if (= $ActiveFilterPhase$    	"1")	(mode_tile "PhaseFilter"    0)	(mode_tile "PhaseFilter"    1))	
				;(if (= $ActiveFilterMark$     	"1")	(mode_tile "MarkFilter"     0)	(mode_tile "MarkFilter"     1))
				;(if (= $ActiveFilterQuantity$ 	"1")	(mode_tile "QuantityFilter" 0)	(mode_tile "QuantityFilter" 1))
				;(if (= $ActiveFilterThikness$ 	"1")	(mode_tile "ThiknessFilter" 0)	(mode_tile "ThiknessFilter" 1))
				;(if (= $ActiveFilterLength$   	"1")	(mode_tile "LengthFilter"   0)	(mode_tile "LengthFilter"   1))
				;(if (= $ActiveFilterHeight$   	"1")	(mode_tile "HeightFilter"   0)	(mode_tile "HeightFilter"   1))
				;(if (= $ActiveFilterMaterial$ 	"1")	(mode_tile "MaterialFilter" 0)	(mode_tile "MaterialFilter" 1))
				;(if (= $ActiveFilterDate$ 	  	"1")	(mode_tile "DateFilter" 	0)	(mode_tile "DateFilter" 	1))
				;(if (= $ActiveFilterCut$ 	  	"1")	(mode_tile "CutFilter" 		0)	(mode_tile "CutFilter"	 	1))
				
				(mode_tile "PrgFilter"    	1)
				(mode_tile "IdFilter"    	1)
				(mode_tile "OrderFilter"    1)
				(mode_tile "PhaseFilter"    1)
				(mode_tile "MarkFilter"     1)
				(mode_tile "QuantityFilter" 1)
				(mode_tile "ThiknessFilter" 1)
				(mode_tile "LengthFilter"   1)
				(mode_tile "HeightFilter"   1)
				(mode_tile "MaterialFilter" 1)
				(mode_tile "DateFilter" 	1)
				(mode_tile "CutFilter" 	1)
				
				(mode_tile "box_label" 2)
				(setq Rtn (SetRecordNesting LstTableNesting))
				
				(action_tile "ActiveFilterPrg" 		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterId" 		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterOrder" 	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterPhase"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterMark"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterQuantity"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterThikness"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterLength"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterHeight"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterMaterial"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterDate"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterCut"		"(setq Rtn (SetRecordNesting LstTableNesting))")

				(action_tile "PrgFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "IdFilter"				"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "OrderFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
                (action_tile "PhaseFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "MarkFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "QuantityFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ThiknessFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "LengthFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "HeightFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "MaterialFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "DateFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "CutFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				
				(action_tile "HelpPrg" 		"(alert \"esempio 1,2 oppure <> -1\")")
				(action_tile "HelpId" 		"(alert \"esempio 012563584,555872369 oppure <> -15235877\")")
				(action_tile "HelpOrder" 	"(alert \"esempio C800,C900 oppure <> oppure -C900,-C901\")")
				(action_tile "HelpPhase" 	"(alert \"esempio 100,101 oppure <> oppure -100\")")
				(action_tile "HelpMark" 	"(alert \"esempio CT100,OP101 oppure <> oppure -17552\")")
				(action_tile "HelpQuantity" "(alert \"esempio <1,10>,-9,25  oppure <> oppure -1,-2\")")
				(action_tile "HelpMaterial" "(alert \"esempio S355J0,S275JR  oppure <> oppure -S275JR \")")
				(action_tile "HelpThikness" "(alert \"esempio <1,10>,-9,25  oppure <> oppure -1,-2\")")
				(action_tile "HelpLength" 	"(alert \"esempio <1,10>,-9,25  oppure <> oppure -1100.2\")")
				(action_tile "HelpHeight" 	"(alert \"esempio <1,10>,-9,25  oppure <> oppure -1100.2\")")
				(action_tile "HelpCut" 		"(alert \"esempio 1,2  oppure <> oppure -1,-2\")")
				(action_tile "HelpDate" 	"(alert \"01/20/2018,01/20/2019\")")


				
				(action_tile "box_info"				"(SelectItmBoxList \"box_info\")")
				(action_tile "selectall"			"(SelectAllBoxList \"box_info\" (SetRecordNesting LstTableNesting))")
				(action_tile "import"				(strcat "(if (GetDataBoxList \"box_info\" Rtn nil)"
															"    (progn"
															"       (setq Rtn (GetDataBoxList \"box_info\" Rtn nil))"
															"       (setq accept T *InfoTableNesting* (done_dialog))"
															"       (unload_dialog xx)"
															"     )"
															"    (alert \"Nessun file selezionato\")"
															")"
													))
				(action_tile "save"					(strcat "(if (GetDataBoxList \"box_info\" Rtn nil)"
															"    (progn"
															"       (setq Rtn (GetDataBoxList \"box_info\" Rtn nil))"
															"       (setq save T *InfoTableNesting* (done_dialog))"
															"       (unload_dialog xx)"
															"     )"
															"    (alert \"Nessun file selezionato\")"
															")"
													))
				(action_tile "list"					(strcat "(if (GetDataBoxList  \"box_info\" Rtn nil)"
															"	 (ListNesting \"SHAPE\" (GetDataBoxList  \"box_info\" Rtn nil))"
															"	 (alert \"Nessun file selezionato\")"
															")"
													))
				(action_tile "cancel"				"(setq Rtn nil *InfoTableNestingDstv* (done_dialog)) (unload_dialog xx)")

				(start_dialog)
		)
	)
	(cond
		((= accept T)
			(setq FileOut (strcat DxfNestingEasyCut$ "StdShape.shp"))
			(WriteFileNesting "SHAPE" Rtn FileOut)
		)
		((= save T)
			(setq FileOut (getfiled "Select File Shape" DxfNestingEasyCut$ "shp" 1))
			(WriteFileNesting "SHAPE" Rtn FileOut)
		)
	)
	(list FileOut Rtn)
)
;
;
;
(defun ListNesting (Type LstDataNesting / conta FileOut Stream itm tm1 SplitLstDataDstv)
	
	;(princ LstDataDst)
	
	(if (and Type LstDataNesting)
		(progn
			(setq conta 1)
			(setq FileOut 	(strcat HtmlStorageEasyCut$ ECFolderShapePreview$ "list.txt"))
			(setq Stream 	(open FileOut "w"))
			(cond
				((= Type "SHAPE")
					(princ "Prg Id Order Phase Mark Qta Thik Length Height Mat Date Cut\n" Stream)
					(foreach itm LstDataNesting
						(foreach itm1 itm
							(princ (strcat 	itm1 " ") Stream)
						)
						(princ "\n" Stream)
					)
					(close Stream)
				)
				((= Type "SHEET")
					(princ "Prg Id Stok Width Length Thik Surface Weight Mat\n" Stream)
					(foreach itm LstDataNesting
						(foreach itm1 itm
							(princ (strcat 	itm1 " ") Stream)
						)
						(princ "\n" Stream)
					)
					(close Stream)
				)
			)
			(close Stream)
			(ViewHtmlPage01 FileOut  (strcat Type " List"))
			(vl-file-delete  FileOut)
		)	
	)
)
;
;
;
(defun DxfOutShape (Ssel FileNameDxf / Go)

	(if (and Ssel FileNameDxf)
		(progn
			(setq Go T)
			(if (findfile FileNameDxf)
				(if (not (vl-file-delete FileNameDxf))
					(progn
						(setq Go nil)
						;(alert (strcat "Problema nella cancellazione del file " FileNameDxf))
						(princ (strcat "\n Problem to deleted File " FileNameDxf))
					)
					(princ (strcat "\n Deleted File " FileNameDxf))
					
				)
			)
			(if Go
				(progn 
					(command "_DxfOut" FileNameDxf "_Objects" Ssel "" "")
					(princ (strcat "\n Create File " FileNameDxf))
				)
			)
		)
	)
	Go
)
;
;
;
(defun CreateNestingExpert (LstSheet LstShape / DxfNestingStorage 
												itm SplitLst 
												IdShape EnameShape OriginShape 
												IdSheet EnameSheet CodeSheet
												Ssel FileNameDxf RtnOffset RtnCode conta DimensionShape LstDataSheet
												LstFileNameShape LstFileNameSheet)


	;(setq LstShape (GuiSelPiecesShape))
	;(if LstShape (setq LstSheet (GuiSelPiecesSheet)))
	
	(if (not LstSheet) (alert "Nessuna lamiera selezionata"))
	(if (not LstShape) (alert "Nessun controno selezionato"))
	
	(if (and LstSheet LstShape)
		(progn
		
			(foreach itm (vl-directory-files DxfNestingEasyCut$ "*.dxf")
					(vl-file-delete  (strcat DxfNestingEasyCut$ itm))
			)
		
			(foreach itm LstShape
		
				; 0		  1			2	  3		  4	     5	 6	  7	      8		9
				;"2" "516645398" "C872" "300" "178-370" "2" "1" "277.5" "290" "S355J0"
				;itm     id       comm   fase    mk     qta  sp   lung   larg    qua

				;(setq SplitLst		(LM:str->lst itm " "))	
				(setq SplitLst		itm)	
				(setq IdShape  		(nth 1 SplitLst))
				(setq EnameShape	(nth 0 (GetEnameById IdShape)))
			
				(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
				(setq OriginShape	(vlax-safearray->list mnl))
				(setq Ssel 			(SelectShape EnameShape))
						
				(if Ssel
					(progn
						(setq RtnOffset	(OffsetShape EnameShape (/ $MargineAccosto 2.0)))
						(ssadd RtnOffset  Ssel)
						(ssdel EnameShape Ssel)
					
						(setq InfoPosLineMessage (PutPosLineMessageShape EnameShape))
						(setq RtnCode 			 (PutLineMessageShape EnameShape "C" InfoPosLineMessage))
					
						(setq conta 0)
						(repeat (sslength RtnCode)
							(setq Ssel (ssadd (ssname RtnCode conta) Ssel))
							(setq conta (1+ conta))
						)

						(setq FileNameDxf 	(strcat DxfNestingEasyCut$ 	(nth 2 SplitLst) "_" 
																		(nth 3 SplitLst) "_" 
																		(nth 4 SplitLst) "_qt"
																		(nth 5 SplitLst) "_tk"
																		(nth 6 SplitLst) 
																		".dxf"))
																		
						(DxfOutShape Ssel FileNameDxf)

						(entdel RtnOffset)
						(setq conta 0)
						(repeat (sslength RtnCode)
							(entdel (ssname RtnCode conta))
							(setq conta (1+ conta))
						)

						(setq LstFileNameShape (append LstFileNameShape (list (list FileNameDxf (nth 5 SplitLst) ))))
					)		
				)
			)
			;
			; DXF Sheet ++++++++++++++
			;
			(foreach itm LstSheet

				; 0        1          2         3      4    5     6       7        8
				;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
				;itm      id        nome      larg   lung   sp    mq     peso     qua

				;(setq SplitLst		(LM:str->lst itm " "))	
				(setq SplitLst			itm)
				(setq IdSheet  			(nth 1 SplitLst))
				(setq EnameSheet		(GetEnameSheetById IdSheet))
				(setq CodeSheet 		(PutLineMessageSheet EnameSheet IdSheet))
				;(setq OriginSheet 		(GetOriginSheet EnameSheet))
				;(setq DimensionSheet 	(GetDimensionSheet EnameSheet))	;(Width Height)
				;(setq Rtn 				(MakeRectangle OriginSheet 	(+ (nth 0 DimensionSheet) (atof (strcat "0.000" IdSheet)))
				;													(+ (nth 1 DimensionSheet) (atof (strcat "0.000" IdSheet)))
				;						))
				(setq FileNameDxf 		(strcat DxfNestingEasyCut$ 	(nth 1 SplitLst) "_" 
																	(nth 3 SplitLst) "_" 
																	(nth 4 SplitLst) "_"
																	(nth 5 SplitLst) ".dxf"))
																	
				(DxfOutShape (LstEname->Ssget (list EnameSheet CodeSheet)) FileNameDxf)
				
				(entdel CodeSheet)
				
				(setq LstFileNameSheet (append LstFileNameSheet (list (list FileNameDxf "1" ))))
			
			)
			
			(WriteXmlNested (strcat DxfNestingEasyCut$ "FileXml.xml") LstFileNameShape LstFileNameSheet)
			;(WriteXmlNested (strcat DxfNestingEasyCut$ "FileXml.xml") LstFileNameShape LstDataSheet)
		)
	)
	(if (and LstShape LstSheet) (GoNestProfessor))
)
;
;
;
(defun WriteXmlNested (FileXml LstFileNameShape LstFileNameSheet / 	wf itm NameFileShape 
																	NameFileSheet QtaShape QtaSheet Rotate
																	NameSheet WidthSheet HeightSheet)

;<NestTask>
;    <PartList>
;        <Part>
;            <Path>C:\EasyCut\test\dxf\029223651.dxf</Path>
;            <Count>10</Count>
;            <Rotate>0</Rotate>
;        </Part>
;        <Part>
;            <Path>C:\EasyCut\test\dxf\44972925.dxf</Path>
;            <Count>1</Count>
;            <Rotate>0</Rotate>
;        </Part>
;        <Part>
;            <Path>C:\EasyCut\test\dxf\103230966.dxf</Path>
;            <Count>1</Count>
;            <Rotate>0</Rotate>
;        </Part>
;        <Part>
;            <Path>C:\EasyCut\test\dxf\586161683.dxf</Path>
;            <Count>1</Count>
;            <Rotate>0</Rotate>
;        </Part>
;    </PartList>
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;   <MaterialList>
;        <Material>
;            <MatPath>C:\EasyCut\Output\dxfnestings\lam10.dxf</MatPath>
;            <Count>1</Count>
;        </Material>
;    </MaterialList>
;
; oppure +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;    <MaterialList>
;        <Material>
;            <Name>Tk_20_12345678</Name>
;            <Width>2500.000123456780</Width>
;            <Height>5000.000123456780</Height>
;            <Count>1</Count>
;        </Material>
;    </MaterialList>
;    <Param>
;        <MatLeftMargin>10.0000000000000000</MatLeftMargin>
;        <MatRightMargin>10.0000000000000000</MatRightMargin>
;        <MatTopMargin>10.0000000000000000</MatTopMargin>
;        <MatBottomMargin>10.0000000000000000</MatBottomMargin>
;        <MatMargin>10.0000000000000000</MatMargin>
;        <PartDis>10.0000000000000000</PartDis>
;        <ConTol>0.0200000000000000</ConTol>
;        <PartRotStep>10.0000000000000000</PartRotStep>
;        <StartCorner>1</StartCorner>
;        <NestDir>0</NestDir>
;        <PartInPart>1</PartInPart>
;        <EvalFactor>1</EvalFactor>
;    </Param>
;</NestTask>

	
	(if (and FileXml LstFileNameShape LstFileNameSheet)
		(progn
		
			(setq wf (open FileXml "w"))
			(if wf
				(progn
				
					(princ "<NestTask>\n" 															wf)
					(princ "    <PartList>\n" 														wf)
					
					(foreach itm LstFileNameShape
						(setq NameFileShape (car itm))
						(setq QtaShape 		(cadr itm))
						(setq Rotate "0")
						(princ "        <Part>\n" 													wf)
						(princ (strcat "            <Path>" NameFileShape "</Path>\n")  			wf)
						(princ (strcat "            <Count>" QtaShape "</Count>\n")     			wf)
						(princ (strcat "            <Rotate>" Rotate "</Rotate>\n")     			wf)
						(princ "        </Part>\n" 													wf)
					)
					(princ "    </PartList>\n"    													wf)
					(princ "    <MaterialList>\n" 													wf)
					(foreach itm LstFileNameSheet
					
						(setq NameFileSheet (car itm))
						(setq QtaShape	 	(cadr itm))
						;(setq HeightSheet 	(caddr itm))
					
						(princ "        <Material>\n"  												wf)
						(princ (strcat "            <MatPath>" NameFileSheet "</MatPath>\n")  		wf)
						(princ (strcat "            <Count>" QtaShape "</Count>\n")     			wf)

						;(princ (strcat "            <Name>" NameSheet "</Name>\n")  				wf)
						;(princ (strcat "            <Width>" WidthSheet "</Width>\n")           	wf)
						;(princ (strcat "            <Height>" HeightSheet "</Height>\n")            wf)
						;(princ "            <Count>1</Count>\n" 									wf)
						
						(princ "        </Material>\n" 												wf)
					)
					(princ "    </MaterialList>\n"    												wf)
					
					(princ "    <Param>\n"  														wf)
					(princ "             <MatLeftMargin>10.0000000000000000</MatLeftMargin>\n"  	wf)
					(princ "             <MatRightMargin>10.0000000000000000</MatRightMargin>\n"  	wf)
					(princ "             <MatTopMargin>10.0000000000000000</MatTopMargin>\n"  		wf)
					(princ "             <MatBottomMargin>10.0000000000000000</MatBottomMargin>\n"  wf)
					(princ "             <MatMargin>10.0000000000000000</MatMargin>\n"  			wf)
					(princ "             <PartDis>10.0000000000000000</PartDis>\n"  				wf)
					(princ "             <ConTol>0.0200000000000000</ConTol>\n"  					wf)
					(princ "             <PartRotStep>10.0000000000000000</PartRotStep>\n"  		wf)
					(princ "             <StartCorner>1</StartCorner>\n"  							wf)
					(princ "             <NestDir>0</NestDir>\n"  									wf)
					(princ "             <PartInPart>1</PartInPart>\n"  							wf)
					(princ "             <EvalFactor>1</EvalFactor>\n"  							wf)
					(princ "    </Param>\n"  														wf)
					(princ "</NestTask>\n"  														wf)
					
					(close wf)
		
				)
			)
		)
	)
)
;
;
;
(defun GoNestProfessor ()
	(startapp (strcat NestPorfessorEasyCut$ "nestClient.exe"))
)
;
;
;
(defun TrattaNestProfessor (/ MSecStart Ssel LstCodeLine MSecEnd)
	
	(setq MSecStart (getvar "MILLISECS"))
	(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
	
	(prompt "\Selezionare i pezzi ")
	(setq Ssel (ssget (list (cons '0 "Line"))))
	(if Ssel
		(progn
			(setq LstCodeLine (GetLineMessage Ssel))
			(setq MSecEnd (getvar "MILLISECS"))
			(princ "\nBenchMark  GetLineMessage ") (princ (/ (- MSecEnd MSecStart) 1000.0))
			(if LstCodeLine
				(GetShapeNestProfessor LstCodeLine)
			)
		)
	)
	(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
	
)
;
;
;
(defun GetShapeNestProfessor (LstCodeLine / MargXZoom MargYZoom
											itm Type IdShape Pt Alfa MaxMin
											MinX MinY MaxX MaxY P1 p2 P3 P4
											SelCheK RtnSel EnameShape RtnOffset Ssel RefShape Conta
											FileName Stream Error) 
											
	
	;(("C" "927897745" (28269.5 19405.0) Angle (MinX MinY MaxX MaxY) ) 
	; ("C" "927897745" (27114.5 19395.0) Angle (MinX MinY MaxX MaxY) ))
	;
	;
	(setq MargXZoom 10.0)
	(setq MargYZoom 10.0)
	(setq Conta 1)
	;
	;
	;
	(if LstCodeLine
		(progn
			(setq FileName (vl-filename-mktemp))
			(setq Stream (open FileName "w"))
			(setq Error nil)
			
			(acet-ui-progress-init "Trattamento Shape:" (length LstCodeLine))
			(foreach itm LstCodeLine
				
				(acet-ui-progress-safe Conta)
				(setq Conta (1+ Conta))
				
				(setq Type	 		(nth 0 itm))
				(setq IdShape 		(nth 1 itm))
				(setq Pt			(nth 2 itm))
				(setq Alfa			(nth 3 itm))
				(setq MaxMin 		(nth 4 itm))
				
				(princ "\rTrattamento Shape Id ") (princ IdShape)
				
				(setq MinX (nth 0 MaxMin))
				(setq MinY (nth 1 MaxMin))
				(setq MaxX (nth 2 MaxMin))
				(setq MaxY (nth 3 MaxMin))
				
				; Rotate Bounding Box
				
				(setq P1 (dca (car Pt) (cadr Pt) (+ (car Pt) MinX) (+ (cadr Pt) MinY) Alfa))
				(setq P2 (dca (car Pt) (cadr Pt) (+ (car Pt) MaxX) (+ (cadr Pt) MinY) Alfa))
				(setq P3 (dca (car Pt) (cadr Pt) (+ (car Pt) MaxX) (+ (cadr Pt) MaxY) Alfa))
				(setq P4 (dca (car Pt) (cadr Pt) (+ (car Pt) MinX) (+ (cadr Pt) MaxY) Alfa))
				
				(setq MinX (min (car P1)  (car P2)  (car P3)  (car P4)))
				(setq MinY (min (cadr P1) (cadr P2) (cadr P3) (cadr P4)))
				(setq MaxX (max (car P1)  (car P2)  (car P3)  (car P4)))
				(setq MaxY (max (cadr P1) (cadr P2) (cadr P3) (cadr P4)))
				
				
				(ZoomWindow01 (list (- MinX MargXZoom) (- MinY MargYZoom) 0.0) (list (+ MaxX MargXZoom) (+ MaxY MargYZoom) 0.0))
				
				(setq SelCheK (ssget "_C" 	(list (- MinX MargXZoom) (- MinY MargYZoom) 0.0)
											(list (+ MaxX MargXZoom) (+ MaxY MargYZoom) 0.0)
											'((-4 . "<OR") (0 . "Arc") (0 . "Line") (-4 . "OR>")))
				)
				
				(if SelCheK
					(progn
						(setq RtnSel 		(MyBoundary Pt SelCheK))
						(setq EnameShape	(MultiLineToPline RtnSel "0.00000"))
						(if EnameShape
							(progn
								(setq RtnOffset	 (OffsetShape (nth 0 EnameShape) (* (/ $MargineAccosto 2.0) -1.0)))
								(setq Ssel (ssget "_CP" (DiscretizeShape RtnOffset) '((-4 . "<OR") (0 . "Arc") (0 . "Line") (-4 . "OR>"))))
								(entdel (nth 0 EnameShape))
								(MultiLineToPline Ssel "0.00000")
								
								(setq RefShape (GetEnameById IdShape))
								(if (car RefShape)
									(AssignNameShape RtnOffset (list 	(GetNameShape  (car RefShape)) 		;nome piatto
																		(GetCutShape   (car RefShape)) 		;compensazione taglio
																		(GetComShape   (car RefShape)) 		;nome commessa
																		(GetPhaseShape (car RefShape)) 		;nome fase
																		(GetMatShape   (car RefShape)) 		;nome qualita
																		(GetTkShape    (car RefShape)) 		;spessore
																		(Today)								;ultima modifica
																		(GetQtaShape   (car RefShape)))) 	;quantita
									(progn
										(setq Error T)
										(princ (strcat "Non trovo la corrispondenza del contorno id " IdShape "\n") Stream)
									)
								)
							)
						)
					)
				)
			)
			(acet-ui-progress-done)
		)
	)
	(close Stream)
	(if Error
		(startapp "notepad" FileName)
	)
)
;
;
;
(defun GetBoundarySheet (LstEname / FindContour 
									MinMaxSsel X1 X2 Y1 Y2 ObjNested ModelSpace ObLine 
									MinDist itm itm1 PointIntersect Dist EnameReference SselContour conta Rtn)

	(defun FindContour (Ename Ssel / en fl in l1 l2 s1 s2 sf vl )

        (if (and Ename Ssel)
            (progn
				(setq s1 Ssel)
                (setq s2 (ssadd)
                      en Ename
                      l1 (list (vlax-curve-getstartpoint en) (vlax-curve-getendpoint en))
                )
                (repeat (setq in (sslength s1))
                    (setq en (ssname s1 (setq in (1- in)))
                          vl (cons (list (vlax-curve-getstartpoint en) (vlax-curve-getendpoint en) en) vl)
                    )
                )
                (while
                    (progn
                        (foreach v vl
                            (if (vl-some '(lambda ( p ) (or (equal (car v) p 1e-8) (equal (cadr v) p 1e-8))) l1)
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
            )
        )
		;(sssetfirst nil s2)
		(if s2
			(if (> (sslength s2) 1)
				s2
				nil
			)
		)
	)
	;
	; Main
	;
	(if LstEname 
		(progn
			(setq MinMaxSsel	(LM:SSBoundingBox (LstEname->Ssget LstEname)))
			(setq X1 (- (nth 0 (nth 3 MinMaxSsel)) 1.0))
			(setq Y1 (+ (nth 1 (nth 3 MinMaxSsel)) 1.0))
			(setq X2 (+ (nth 0 (nth 1 MinMaxSsel)) 1.0))
			(setq Y2 (- (nth 1 (nth 1 MinMaxSsel)) 1.0))
			
			(setq ModelSpace 	(vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
			(setq ObLine 	 	(vla-AddLine ModelSpace (vlax-3d-point (list X1 Y1 0.0)) (vlax-3d-point (list X2 Y2 0.0))))
			
			
			(setq MinDist 1.0e+006)
			(foreach itm  LstEname
			
				(setq PointIntersect (MainVla-IntersectWith (vlax-vla-object->ename ObLine) itm))
				
				(foreach itm1 PointIntersect
					;(command "_Point" itm1)
					(setq Dist (distance (list X1 Y1 0.0) itm1))
					(if (< Dist MinDist)
						(progn 
							(setq MinDist Dist)
							(setq EnameReference itm)
						)
					)
					;(princ "\n") (princ itm) (princ " ** ") (princ EnameReference) (princ " ** ") (princ MinDist) (getstring "---")
				)
			)
			(vla-delete ObLine)	
			(if EnameReference
				(if (setq SselContour 	(FindContour EnameReference (LstEname->Ssget LstEname)))
					(progn
						(setq conta 0)
						(repeat (sslength SselContour) 
							(setq LstEname (vl-remove (ssname SselContour conta) LstEname))
							(setq conta (1+ conta))
						)
						
						(if (setq Rtn (LineToPline SselContour)) (setq Rtn (list (car Rtn) LstEname)))
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
(defun MyBoundary (Point SelectSel / FindContour FindIntersectionContour
									 DistCatch MinDist ModelSpace ObLine conta PointIntersect itm Dist EnameReference Rtn)

	(setq DistCatch (+ $MargineAccosto 10.0))
	;
	;
	;
	(defun FindContour (Ename Ssel / en fl in l1 l2 s1 s2 sf vl )

        (if (and Ename Ssel)
            (progn
				(setq s1 Ssel)
                (setq s2 (ssadd)
                      en Ename
                      l1 (list (vlax-curve-getstartpoint en) (vlax-curve-getendpoint en))
                )
                (repeat (setq in (sslength s1))
                    (setq en (ssname s1 (setq in (1- in)))
                          vl (cons (list (vlax-curve-getstartpoint en) (vlax-curve-getendpoint en) en) vl)
                    )
                )
                (while
                    (progn
                        (foreach v vl
                            (if (vl-some '(lambda ( p ) (or (equal (car v) p 1e-8) (equal (cadr v) p 1e-8))) l1)
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
            )
        )
		;(sssetfirst nil s2)
		(if s2
			(if (> (sslength s2) 1)
				s2
				nil
			)
		)
	)	
	;
	;
	;
	(defun FindIntersectionContour (Point Ssel DistCatch / ModelSpace ObCircle Loop Conta PointIntersect Rtn)
		
		
		(if (and Point Ssel DistCatch)
			(progn
				(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq ObCircle 	 (vla-AddCircle ModelSpace (vlax-3d-point Point) DistCatch))
				(setq Loop T)
				(setq Conta 0)
				(while Loop
					(setq PointIntersect (MainVla-IntersectWith (vlax-vla-object->ename ObCircle) (ssname Ssel conta)))
					(if PointIntersect
						(progn
							(setq Loop nil)
							(setq Rtn (car PointIntersect))
						)
					)
					
					(setq Conta (1+ Conta))
					
					(if (= Conta (sslength Ssel))
						(setq Loop nil)
					)
				)
				(vla-delete ObCircle)
			)
		)
		Rtn
	)
	;
	;
	;
	(if (and Point SelectSel)
		(progn
			(setq MinDist 1.0e+006)
			(setq Rtn (FindIntersectionContour Point SelectSel DistCatch))
			(if Rtn
				(progn
					(setq ModelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
					(setq ObLine 	 (vla-AddLine ModelSpace (vlax-3d-point Point) (vlax-3d-point Rtn)))
					(setq conta 0)
					(repeat (sslength SelectSel)
						(setq PointIntersect (MainVla-IntersectWith (vlax-vla-object->ename ObLine) (ssname SelectSel conta)))
						(foreach itm PointIntersect
							;(command "_Point" itm)
							(setq Dist (distance Point itm))
							(if (< Dist MinDist)
								(progn 
									(setq MinDist Dist)
									(setq EnameReference (ssname SelectSel conta))
								)
							)
							;(princ "\n") (princ itm) (princ " ** ") (princ EnameReference) (princ " ** ") (princ MinDist) (getstring "---")
						)
				
						(setq conta (1+ conta))
					)
			
					(vla-delete ObLine)
				)
			)
		)
	)
	(if EnameReference 
		(setq Rtn (FindContour EnameReference SelectSel))
	)
	Rtn
)
;
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
						(setq GetDoubleClickGetInfo$ nil)
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
					(setq GetDoubleClickGetInfo$ nil)
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
;
(defun DecodeLineMessage (EnamePolyline Fuzz / 	LengthToChar 
												Vertex p1 p2 LstLength conta PSt PEn AngCode
												Loop LengthLine s2 LstEnameCode LstEnameToPoly itm 
												Step Char Sign1 Sign2 Sign3 Sign4 
												MinX MinY MaxX MaxY RtnStr)

	(defun LengthToChar (LengthLine Fuzz / Rtn)
		(foreach itm $LengthLineMessage
			(if (equal  (cdr itm) LengthLine Fuzz)
				(setq Rtn (car itm))
			)
		)
		Rtn
	)										   
	;
	;
	;
	(if (and EnamePolyline Fuzz)
		(progn
			(setq Vertex (LM:lwvertices (entget EnamePolyline)))
							
			(setq conta 0)
			(repeat (- (length Vertex) 1)
				(setq p1 (cdr (assoc 10 (nth (+ conta 0) Vertex))))
				(setq p2 (cdr (assoc 10 (nth (+ conta 1) Vertex))))
				(setq LstLength (append LstLength (list (distance p1 p2))))
				(setq conta (1+ conta))
			)
				
			(if (and (equal (car LstLength) $CharEndLineMessage Fuzz) (equal (last LstLength) $CharStartLineMessage Fuzz))
				(progn
					(setq LstLength (reverse LstLength))
					(setq PSt (cdr (assoc 10 (last Vertex))))
					(setq PEn (cdr (assoc 10 (car Vertex))))
				)
			)
			(if (and (equal (car LstLength) $CharStartLineMessage Fuzz) (equal (last LstLength) $CharEndLineMessage Fuzz))
				(progn
					(setq PSt (cdr (assoc 10 (car Vertex))))
					(setq PEn (cdr (assoc 10 (last Vertex))))
				)
			)
							
			(if (and PSt PEn)
				(progn
					(setq AngCode (angle Pst PEn))
					(setq conta 1)
					(setq RtnStr "")
					(setq Step 1)
					(setq Loop T)
						
					(while Loop
							
						(setq Char (LengthToChar (nth conta LstLength) Fuzz))
						(if Char
							(if (= Char "_")
								(setq Step (1+ Step))
								(progn
									(cond
										((= Step 1)
											(setq RtnStr (strcat RtnStr Char))
										)
										((= Step 2)
											(setq Sign1 (LengthToChar (nth (+ 0 conta) LstLength) Fuzz))
											(setq MinX  (* 10000.0    (nth (+ 1 conta) LstLength)))
											(setq Sign2 (LengthToChar (nth (+ 2 conta) LstLength) Fuzz))
											(setq MinY  (* 10000.0    (nth (+ 3 conta) LstLength)))
											(setq Sign3 (LengthToChar (nth (+ 4 conta) LstLength) Fuzz))
											(setq MaxX  (* 10000.0    (nth (+ 5 conta) LstLength)))
											(setq Sign4 (LengthToChar (nth (+ 6 conta) LstLength) Fuzz))
											(setq MaxY  (* 10000.0    (nth (+ 7 conta) LstLength)))
											(if (= Sign1 "-") (setq MinX (- 0.0 MinX)))
											(if (= Sign2 "-") (setq MinY (- 0.0 MinY)))
											(if (= Sign3 "-") (setq MaxX (- 0.0 MaxX)))
											(if (= Sign4 "-") (setq MaxY (- 0.0 MaxY)))
											(setq Loop nil)
										)
									)
								)
							)
							(progn
								(alert "Problema nella decodifica del Codice a Linee")
								(setq RtnStr "")
								(setq Loop nil)
							)
						)
						(setq conta (1+ conta))
					)
						
					(if (/= RtnStr "")
						(setq RtnStr (list  (substr RtnStr 1 1)  
											(substr RtnStr 2 (- (strlen RtnStr) 1))
											PSt AngCode (list MinX MinY MaxX MaxY))
						)
						(setq RtnStr nil)
					)
					
				)	
			)		
		)
	)
	RtnStr
)
;
;
;
(defun GetLineMessage (SsChk / Fuzz MaxLengthSegment Ssel SsChk ent LstPline conta itm RtnStr LstRtn i)
	;
	;
	(setq Fuzz 0.001)
	(setq MaxLengthSegment 2.0)
	
	(if SsChk
		(progn
			(setq Ssel (ssadd)) 
			;(setq SsChk (ssget "_X" (list (cons '0 "Line"))))
			;(setq SsChk (ssget (list (cons '0 "Line"))))
	
			(foreach ent (LM:ss->ent SsChk)
				(if (<= (vla-get-length (vlax-ename->vla-object ent)) MaxLengthSegment)
					(ssadd ent Ssel)
				)
			)	
			
			(if Ssel
				(progn
					(acet-ui-progress-init "Convert Line in Pline:" 500)
					(setq i 0)
					(repeat 499; loop
						(setq i (1+ i))
						(acet-ui-progress-safe i); update progressbar
					)
					(setq LstPline (MultiLineToPline Ssel "0.000000"))
					(acet-ui-progress-safe 500)
					(acet-ui-progress-done)
					
					(setq LstRtn nil)
					(setq conta 0)
					(foreach itm LstPline
		
						(setq RtnStr (DecodeLineMessage itm Fuzz))
		
						(if RtnStr 
							(progn 
								(princ "\nDecode Shape Id ") (princ (setq conta (1+ conta))) (princ " ") (princ (cadr RtnStr))
								(entdel itm) 
								(setq LstRtn (append LstRtn (list RtnStr)))
							)
							(command "_Explode" itm)
						)
					)
				)
			)
		)
	)
	LstRtn
)
;
;
;
(defun test ()
	(setq ename (car (entsel)))
	
	(setq aa (PutPosLineMessageShape ename))
	(PutLineMessageShape Ename "C" aa)
)
;
;
;
(defun PutLineMessageShape (Ename Type InfoPosLineMessage / CharSeparator modelSpace IdShape minx miny maxx maxy P1 P2 Ang Rtn SegmentSeparator
															SegmentMinX SegmentMinY SegmentMaxX SegmentMaxY SignDef conta Char LengthChar)

		(setq CharSeparator "_")
		
		; InfoPosLineMessag ((-294.092 878.124 0.0) (-293.352 878.797 0.0) (-293.42 877.384 0.0) (-10.0 -10.0 749.262 752.852)))
		(if (and Ename InfoPosLineMessage)
			(progn
				(setq modelSpace (vla-get-modelspace(vla-get-activedocument (vlax-get-acad-object))))
				(setq IdShape (GetIdShape Ename))
				(setq minx (nth 0  (nth 3 InfoPosLineMessage)))
				(setq miny (nth 1  (nth 3 InfoPosLineMessage)))
				(setq maxx (nth 2  (nth 3 InfoPosLineMessage)))
				(setq maxy (nth 3  (nth 3 InfoPosLineMessage)))
				(setq P1   (car InfoPosLineMessage))
				(setq P2   (cadr InfoPosLineMessage))
				(setq Ang  (angle P1 P2))
				(setq Rtn (ssadd))
				;
				; Attach info dimension Shape
				;
				(setq SegmentSeparator (cdr (assoc CharSeparator $LengthLineMessage)))
				(setq SegmentMinX (/ minx 10000.0))
				(setq SegmentMinY (/ miny 10000.0))
				(setq SegmentMaxX (/ maxx 10000.0))
				(setq SegmentMaxY (/ maxy 10000.0))
				(setq SignDef "+")
				(if (< minx 0.0) (setq Sign1 "-") (setq Sign1 SignDef))
				(if (< miny 0.0) (setq Sign2 "-") (setq Sign2 SignDef))
				(if (< maxx 0.0) (setq Sign3 "-") (setq Sign3 SignDef))
				(if (< maxy 0.0) (setq Sign4 "-") (setq Sign4 SignDef))
				
				
				
				; StartChar ------------------------------------------------

				(setq P2 (polar P1 Ang $CharStartLineMessage))
				(ssadd (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		(vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)
				
				; Type  ------------------------------------------------

				(cond
					((= Type "L")
						(setq Char Type)
						(setq LengthChar (cdr (assoc Char $LengthLineMessage)))
						(if LengthChar
							(progn 
								(setq P2 (polar P1 Ang LengthChar))
								(ssadd (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																						(vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
								(setq P1 P2)
							)
						)
					)
					((= Type "C")
						(setq Char Type)
						(setq LengthChar (cdr (assoc Char $LengthLineMessage)))
						(if LengthChar
							(progn 
								(setq P2 (polar P1 Ang LengthChar))
								(ssadd (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																						(vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
								(setq P1 P2)
							)
						)
					)
				)
					
				; Number id ------------------------------------------------

				(setq conta 1)
				(repeat (strlen IdShape)
					(setq Char (substr IdShape conta 1))
					(setq LengthChar (cdr (assoc Char $LengthLineMessage)))
					(if LengthChar
						(progn 
							(setq P2 (polar P1 Ang LengthChar))
							(ssadd (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																					(vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
							(setq P1 P2)
							(setq conta (1+ conta))
						)
					)
				)
						
				; Separator ------------------------------------------------
				
				(setq P2   (polar P1 Ang SegmentSeparator))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)
				
				;Sign1 ------------------------------------------------
							
				(setq P2   (polar P1 Ang (cdr (assoc Sign1 $LengthLineMessage))))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)

				;Minx ------------------------------------------------

				(setq P2   (polar P1 Ang (abs SegmentMinX)))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)
				
				;Sign2 ------------------------------------------------
		
				(setq P2   (polar P1 Ang (cdr (assoc Sign2 $LengthLineMessage))))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)

				;MinY ------------------------------------------------

				(setq P2   (polar P1 Ang (abs SegmentMinY)))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)
				
				;Sign3 ------------------------------------------------
				
				(setq P2   (polar P1 Ang (cdr (assoc Sign3 $LengthLineMessage))))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)				

				;MaxX ------------------------------------------------

				(setq P2   (polar P1 Ang (abs SegmentMaxX)))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)
				
				;Sign4 ------------------------------------------------
				
				(setq P2   (polar P1 Ang (cdr (assoc Sign4 $LengthLineMessage))))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)				

				;MaxY ------------------------------------------------

				(setq P2   (polar P1 Ang (abs SegmentMaxY)))
				(ssadd     (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		    (vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
				(setq P1 P2)				

				; EndChar ------------------------------------------------

				(setq P2 (polar P1 Ang $CharEndLineMessage))
				(ssadd (vlax-vla-object->ename (vla-AddLine modelSpace 	(vlax-3d-point  (car P1) (cadr P1) 0.0)
																		(vlax-3d-point  (car P2) (cadr P2) 0.0))) Rtn)
			)
		)
		Rtn
)
;
;
;
(defun PutPosLineMessageShape (Ename / 	MrgX MrgY
										MaxDimensionLengthCode Shape Jou DataCircle Loop conta
										p1g p2g p3g p1l p2l p3l MinX MinY MaxX MaxY Rtn)

	(setq MrgX (+ $MargineAccosto 5.0))
	(setq MrgY (+ $MargineAccosto 5.0))
	(setq MaxDimensionLengthCode 37.0)
	
	(setq Shape (DiscretizeShape Ename))
	(setq Jou 	(CheckPoly Ename))
	
	(if (setq DataCircle (IsLwPolylineCircle Ename))
		(progn
			(if (> (- (* (nth 1 DataCircle) 2.0) $MargineAccosto $MargineAccosto) MaxDimensionLengthCode)
				(progn
					(setq p1g (list (- (nth 0 (nth 0 DataCircle)) (nth 1 DataCircle))
									(- (nth 1 (nth 0 DataCircle)) MrgY)))
					(setq p2g (list    (nth 0 (nth 0 DataCircle))
									(- (nth 1 (nth 0 DataCircle)) MrgY)))
				)
			)
		)
		(progn
			(setq conta 0)
			(setq Loop T)
			(while Loop
	
				(setq p1g 	(nth (+ conta 0) Shape))
				(setq p2g 	(nth (+ conta 1) Shape))

				(if (> (distance p1g p2g) MaxDimensionLengthCode)
					(setq Loop nil)
					(setq p1g nil p2g nil)
				)
					
				(if (= (1+ conta) (length Shape))
					(setq Loop nil)
				)
				(setq conta (1+ conta))
				;(princ "\n") (princ p1g) (princ p2g)
			)
		)
	)

	(if (and p1g p2g)
		(progn
			(cond	
				((= (car Jou) 2)
					;(princ "\nPercorrenza Antioraria")
					(setq p3g (per (car p2g) (cadr p2g) (car p1g) (cadr p1g) (* -1.0 1.0)))
				)
				((= (car Jou) 3) 
					;(princ "\nPercorrenza Oraria")
					(setq p3g (per (car p2g) (cadr p2g) (car p1g) (cadr p1g) 1.0))
				)
			)
	
			(if p3g
	
				(progn
					(setq CosDir (DefPiano (car p1g) (cadr p1g) 0.0 (car p2g) (cadr p2g) 0.0 (car p3g) (cadr p3g) 0.0))
					(setq p1l (list    MrgX      MrgY 0.0))
					(setq p2l (list (+ MrgX 1.0) MrgY 0.0))
					(setq p3l (list    MrgX   (+ MrgY 1.0) 0.0))
					(setq p1g (TransG (car p1l) (cadr p1l) (caddr p1l) CosDir))
					(setq p2g (TransG (car p2l) (cadr p2l) (caddr p2l) CosDir))
					(setq p3g (TransG (car p3l) (cadr p3l) (caddr p3l) CosDir))
					(setq CosDir (DefPiano (car p1g) (cadr p1g) 0.0 (car p2g) (cadr p2g) 0.0 (car p3g) (cadr p3g) 0.0))
					
					(setq LstX nil LstY nil)
					(foreach itm Shape
						(setq Point (TransL (car itm) (cadr itm) 0.0 CosDir))
						(setq LstX (append LstX (list (car Point))))
						(setq LstY (append LstY (list (cadr Point))))
					)
					(setq MinX (apply 'min LstX))
					(setq MinY (apply 'min LstY))
					(setq MaxX (apply 'max LstX))
					(setq MaxY (apply 'max LstY))
					
					;(vla-TransformBy    (vlax-ename->vla-object Ename) 
					;					(vlax-tmatrix (MyUCS2WCSMatrix p1g p2g p3g)))
								
					;(vla-Getboundingbox (vlax-ename->vla-object Ename) 'minpoint 'maxpoint)
					;
					;(vla-TransformBy    (vlax-ename->vla-object Ename) 
					;					(vlax-tmatrix (MyWCS2UCSMatrix p1g p2g p3g)))
					;					
					;(setq MaxMin        (list (vlax-safearray->list minpoint) (vlax-safearray->list maxpoint)))
						
					;(setq Rtn (list p1g p2g p3g MaxMin))
					(setq Rtn (list p1g p2g p3g (list MinX MinY MaxX MaxY)))
				)
			)
		)
	)

	Rtn ; ((-294.092 878.124 0.0) (-293.352 878.797 0.0) (-293.42 877.384 0.0) ((-10.0 -10.0 0.0) (749.262 752.852 0.0)))
)
;
;
;
(defun PutPosLineMessageSheet (EnameSheet / HeightRect OriginSheet DimensionSheet
											Rtn)

	;(setq MrgX  0.0)
	;(setq MrgY  1.0)
	
	
	(if EnameSheet
		(progn
	
			(setq OriginSheet 		(GetOriginSheet 	EnameSheet))
			(setq DimensionSheet 	(GetDimensionSheet 	EnameSheet))
			(setq Rtn (list (nth 0 OriginSheet) 
							(+ (nth 1 OriginSheet) (nth 1 DimensionSheet))))
		)
	)
	Rtn ; (-294.092 878.124 0.0)
)
;
;
;
(defun PutLineMessageSheet (EnameSheet Message / HeightRect Divider PosMessage WidthRect Rtn)
	
	(setq HeightRect 1.0)
	(setq Divider 5000.0)
	
	(if (and EnameSheet Message)
		(progn
			
			(setq PosMessage 	(PutPosLineMessageSheet EnameSheet))
			(setq WidthRect		(/ (/ (atoi Message) Divider) HeightRect))
			(setq Rtn 			(MakeRectangle PosMessage WidthRect HeightRect))
		)
	)
	Rtn		
)
;
;
;
(defun NestedEnameBlock (EnameBlock TypeEntity / blst1 blst2 conta Rtn)

	(setq conta 1)
	(if (and EnameBlock
			(= (cdr (assoc 0 (setq blst1 (entget EnameBlock)))) "INSERT")
			(setq blst2 (tblobjname "BLOCK" (cdr (assoc 2 blst1))))
			;(setq PtInsert (cdr (assoc 10 (entget blst2))))
		)
		
		(while (and (not (= blst2 nil)) (setq blst2 (entnext blst2)))
			(if (= (cdr (assoc 0 (entget blst2))) TypeEntity)
				(progn
					(setq Rtn (append Rtn (list blst2)))
					;(princ "\n") (princ conta) 
					;(princ " ")  (princ (cdr (assoc 10 (entget blst2)))) 
					;(princ " ")  (princ (cdr (assoc 11 (entget blst2))))
					;(princ " ")  (princ (distance (cdr (assoc 10 (entget blst2))) (cdr (assoc 11 (entget blst2)))))
					;(princ " ")  (princ (cdr (assoc 210 (entget blst2))))
				)
			)
			(setq conta (1+ conta))
		)
	)
	Rtn
)
;
;
;
(defun test ()
	(setq Eb (car (entsel)))
	(setq LstEname (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value (vla-Explode (vlax-ename->vla-object Eb))))))
	(setq Rtn (GetLineMessageSheet LstEname))
)
	
;
;
;
(defun GetLineMessageSheet (LstEname / Fuzz Divider MaxCode HRect LRect LstEnameLine Ssel MinMaxSsel Xr Yr
									   XminC YminC XmaxC YmaxC
									   itm xp1 yp1 xp2 yp2 LstEntityCode Rtn)
	
	;(setq MrgX  	0.0)
	;(setq MrgY  	1.0)
	(setq Fuzz 		0.5)
	(setq Divider 	5000.0)
	(setq MaxCode 	99999)
	(setq HRect 	1.0)
	(setq LRect		(/ MaxCode Divider))

	(if LstEname
		(progn

			(setq Ssel 			(LstEname->Ssget LstEname))
			(setq MinMaxSsel	(LM:SSBoundingBox Ssel))
			(setq Xr			(car  (nth 3 MinMaxSsel)))
			(setq Yr			(- (cadr (nth 3 MinMaxSsel)) HRect))
			
			(setq XminC			(- Xr Fuzz))
			(setq YminC			(- Yr Fuzz))
			(setq XmaxC			(+ Xr LRect Fuzz))
			(setq YmaxC			(+ Yr HRect Fuzz))

			;(setq PtBlock		(cdr (assoc 10 (entget EnameBlock))))
			
			(foreach itm LstEname
				(if (= (cdr (assoc 0 (entget itm))) "LINE")
					(progn
						(setq xp1 (car  (cdr (assoc 10 (entget itm)))))
						(setq yp1 (cadr (cdr (assoc 10 (entget itm)))))
			
						(setq xp2 (car  (cdr (assoc 11 (entget itm)))))
						(setq yp2 (cadr (cdr (assoc 11 (entget itm)))))
			
				
						(if (and (>= xp1 XminC) (<= xp1 XmaxC)
								 (>= xp2 XminC) (<= xp2 XmaxC)
						 
								 (>= yp1 YminC) (<= yp1 YmaxC)
								 (>= yp2 YminC) (<= yp2 YmaxC)
							)
							;(if (and  (<= (distance (cdr (assoc 10 (entget itm))) (cdr (assoc 11 (entget itm)))) HRect)
							;		  (<= (distance (cdr (assoc 10 (entget itm))) (cdr (assoc 11 (entget itm)))) LRect)
							;	)
								(setq LstEntityCode (append LstEntityCode (list itm)))
							;)
						)
					)
				)
			)
								
			;(foreach itm LstEntityCode
			;	(princ "\n") (princ (distance (cdr (assoc 10 (entget itm))) (cdr (assoc 11 (entget itm)))))
			;)
			
			(if (= (length LstEntityCode) 4)
				(progn
					(setq Rtn (* (distance (cdr (assoc 10 (entget (nth 0 LstEntityCode)))) (cdr (assoc 11 (entget (nth 0 LstEntityCode)))))
								 (distance (cdr (assoc 10 (entget (nth 1 LstEntityCode)))) (cdr (assoc 11 (entget (nth 1 LstEntityCode)))))
								 (distance (cdr (assoc 10 (entget (nth 2 LstEntityCode)))) (cdr (assoc 11 (entget (nth 2 LstEntityCode)))))
								 (distance (cdr (assoc 10 (entget (nth 3 LstEntityCode)))) (cdr (assoc 11 (entget (nth 3 LstEntityCode)))))
							  )
					)
					(setq Rtn (rtos  (* (sqrt Rtn) Divider) 2 1))
					(repeat (- (strlen (rtos MaxCode 2 0)) (strlen Rtn))
						(setq Rtn (strcat "0" Rtn))
					)
					(foreach itm LstEntityCode
						(setq LstEname (vl-remove itm LstEname))
						(entdel itm)
					)
					(setq Rtn (list Rtn LstEname))
				)
			)
		)
	)
	Rtn
	
)
;
;
;
(defun test ()

	(setq ename (car (entsel)))
	(setq InfoSheet 	(GetDataSheetByEname ename))  ; ("40029" "STK_CSD_1" "2500" "5000" "10" "12.5" "981.25" "S355J0")
	(setq aa 			(PutLineMessageSheet ename  (car InfoSheet)))
	
	
)
;
;
;
(defun ImportDxfFile (/ ListFile LstIdSheet itm PtInsert MinX MinY MaxX MaxY
						LstEname LstRtn IdSheet EnameSheet IsSheetNestProfessor LstBlockToPurge OriginSheet
						Ssel WidthSheet HeightSheet MatSheet ThkSheet NameSheet DimSheet BlockName EnameBlock ultent xd_list)
	
	
	(setq ListFile (LM:getfiles "Seleziona file" DxfNestingEasyCut$ "dxf"))
	(setq LstIdSheet (GetIdSheet))
		
	(foreach itm ListFile
		
		(setq PtInsert (list 0.0 0.0))
		(command "_.-insert" itm "_none" PtInsert "" "" "")
		(setq EnameBlock (entlast))
		
		(if EnameBlock
			(progn
				
								
				(vla-getboundingbox (vlax-ename->vla-object EnameBlock) 'mnl 'mxl)
				(setq MinX   (nth 0 (vlax-safearray->list mnl)))
				(setq MinY   (nth 1 (vlax-safearray->list mnl)))
				
				
				(setq LstEname (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value (vla-Explode (vlax-ename->vla-object EnameBlock))))))
				
				(setq LstRtn      (GetLineMessageSheet LstEname))
				(setq IdSheet     (nth 0 LstRtn))
				(setq LstEname    (nth 1 LstRtn))
				(setq LstRtn      (GetBoundarySheet LstEname))
				(setq EnameSheet  (nth 0 LstRtn))
				(setq LstEname    (nth 1 LstRtn))
				
				; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				(setq LstBlockToPurge nil)
				(setq LstBlockToPurge (append LstBlockToPurge (list (cdr (assoc 2 (entget EnameBlock))))))
				(entdel EnameBlock)
				(foreach itm LstBlockToPurge
					(PurgeBlock itm)
				)
				; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				
				
				(if (member IdSheet LstIdSheet) 
					(setq IsSheetNestProfessor T)
					(setq IsSheetNestProfessor nil)
				)
				
				
				(cond
					((= IsSheetNestProfessor T)
						(entdel EnameSheet)
						(setq EnameSheet  (GetEnameSheetById IdSheet))
						(setq OriginSheet (GetOriginSheet EnameSheet))
								
						(foreach itm LstEname
							(vla-move 	(vlax-ename->vla-object itm) 
										(vlax-3d-point (list Minx MinY))
										(vlax-3d-point OriginSheet)
							)
						)
					)
					(t 
						(alert "non ho trovato la lamiera corrispondente")

						(setq Ssel (LstEname->Ssget (append LstEname (list EnameSheet))))
						(command "_Move" Ssel "" (list MinX MinY) pause)
						(while (not (FindAreaAvailable Ssel))
							(command "_Move" Ssel "" (getvar "LASTPOINT") pause)
						)
												
						(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
						(setq MinX   (nth 0 (vlax-safearray->list mnl)))
						(setq MinY   (nth 1 (vlax-safearray->list mnl)))
						(setq MaxX   (nth 0 (vlax-safearray->list mxl)))
						(setq MaxY   (nth 1 (vlax-safearray->list mxl)))
						(setq WidthSheet  (rtos (abs (- MaxX MinX)) 2 0))
						(setq HeightSheet (rtos (abs (- MaxY MinY)) 2 0))
						(setq MatSheet "UNKNOWN")
						(setq ThkSheet  "1")
						(setq NameSheet (strcat "SHEET_" (Random_Str 5)))
						
						(AssignNameSheet EnameSheet NameSheet IdSheet ThkSheet MatSheet)
						
						(setq DimSheet  (strcat WidthSheet "x" HeightSheet))
						(setq BlockName (strcat LibPathEasyCut$ NameBlockSheet$ ".dwg"))
						(command "._-insert" BlockName (list MinX (- MinY 420.0)) 1.0 1.0 0 DimSheet ThkSheet NameSheet IDSheet MatSheet)
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
				)
			)
		)
	)
)
;
;
;
(defun DeleteSheetNestProfessor (ObjArr WidthSheet HeightSheet / Loop Conta itm LengthLine Trovati)

	(setq Loop T)
	(setq Conta 0)
	(setq Trovati 0)
	
	(if (and ObjArr WidthSheet HeightSheet)
	
		(while Loop
		
			(setq itm (nth Conta ObjArr))
			
			(if (= (vlax-get-property itm 'ObjectName) "AcDbLine")
				(progn
					(setq LengthLine (vla-get-length itm))
					
					(if (or (equal LengthLine WidthSheet  1) 
							(equal LengthLine HeightSheet 1)
						)
						(progn 
							(vla-Delete itm) 
							(setq Trovati (1+ Trovati))
						)
					)
					
					
					
					(if (= Trovati 4) (setq Loop nil))
					
				)
			)
			
			(setq Conta (1+ Conta))
			(if (= Conta (length ObjArr)) (setq Loop nil))
			
		)
	)
)
;
;
;
(defun PurgeBlock (NameBlock)
  (if (vl-catch-all-error-p
        (vl-catch-all-apply
          'vla-delete
          (list (vl-catch-all-apply
                  'vla-item
                  (list (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object))) NameBlock)
                )
          )
        )
      )
    nil ; name cannot be purged or doesn't exist
    T ; name purged
  )
)
;
;
;
(defun WriteFileNesting (Type LstData FileOut / Go itm itm1 Stream SplitLst)

	
	(if FileOut
		(if (findfile FileOut)
			(if (not (vl-file-delete FileOut))
				(progn
					(setq Go nil)
					(alert (strcat "Problema nella cancellazione del file " FileOut))
					(exit)
				)
			)
		)
	)
	
	(if LstData
		(progn
			(setq Stream (open FileOut "w"))
			(if Stream
				(cond
					((= Type "SHAPE")
						(princ "Prg Id Order Phase Mark Qta Thik Length Height Mat\n" Stream)
						(foreach itm LstData
							; 0		  1			2	  3		  4	     5	 6	  7	      8		9
							;"2" "516645398" "C872" "300" "178-370" "2" "1" "277.5" "290" "S355J0"
							;itm     id       comm   fase    mk     qta  sp   lung   larg    qua
							(foreach itm1 itm
								(princ (strcat 	itm1 " ") Stream)
							)
							(princ "\n" Stream)
						)
						(close Stream)
					)
					((= Type "SHEET")
						(princ "Prg Id Stok Width Length Thik Surface Weight Mat\n" Stream)
						(foreach itm LstData
							; 0        1          2         3      4    5     6       7        8
							;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
							;itm      id        nome      larg   lung   sp    mq     peso     qua
							(foreach itm1 itm
								(princ (strcat 	itm1 " ") Stream)
							)
							(princ "\n" Stream)
						)
						(close Stream)
					)
				)
				(alert (strcat "Problema nella creazione del file " FileOut))
			)
		)
		(alert "Nessun contorno selezionato")
	)
)
;
;
;
(defun ReadFileNesting (FileIn / Stream Line SplitLine Rtn)

	(if FileIn
		(progn
			(setq Stream (open FileIn "r"))
			(if Stream
				(progn
					(setq Line (read-line Stream))
					(while Line
						(setq SplitLine	(SpliTxt Line " "))
						(setq Rtn (append Rtn (list SplitLine)))
						(setq Line (read-line Stream))
					)
					(close Stream)
				)
				(alert (strcat "Problema lettura del file " FileIn))
			)
		)
	)
	Rtn
)
;
;
;